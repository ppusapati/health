// This is a generated file - do not edit.
//
// Generated from healthcare/icu/v1/icu.proto.

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

import 'icu.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'icu.pbenum.dart';

class IcuEpisode extends $pb.GeneratedMessage {
  factory IcuEpisode({
    $core.String? episodeId,
    $core.String? encounterId,
    $core.String? patientId,
    $core.String? facilityId,
    $core.String? unitId,
    $core.String? bedId,
    AdmissionSource? source,
    $core.String? transferredFrom,
    $core.String? responsibleTeam,
    $core.String? responsibleClinician,
    EpisodeStatus? status,
    $0.Timestamp? admittedAt,
    $0.Timestamp? readyAt,
    $0.Timestamp? dischargedAt,
    EpisodeOutcome? outcome,
    $core.String? outcomeNote,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (facilityId != null) result.facilityId = facilityId;
    if (unitId != null) result.unitId = unitId;
    if (bedId != null) result.bedId = bedId;
    if (source != null) result.source = source;
    if (transferredFrom != null) result.transferredFrom = transferredFrom;
    if (responsibleTeam != null) result.responsibleTeam = responsibleTeam;
    if (responsibleClinician != null)
      result.responsibleClinician = responsibleClinician;
    if (status != null) result.status = status;
    if (admittedAt != null) result.admittedAt = admittedAt;
    if (readyAt != null) result.readyAt = readyAt;
    if (dischargedAt != null) result.dischargedAt = dischargedAt;
    if (outcome != null) result.outcome = outcome;
    if (outcomeNote != null) result.outcomeNote = outcomeNote;
    if (version != null) result.version = version;
    return result;
  }

  IcuEpisode._();

  factory IcuEpisode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IcuEpisode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IcuEpisode',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'unitId')
    ..aOS(6, _omitFieldNames ? '' : 'bedId')
    ..aE<AdmissionSource>(7, _omitFieldNames ? '' : 'source',
        enumValues: AdmissionSource.values)
    ..aOS(8, _omitFieldNames ? '' : 'transferredFrom')
    ..aOS(9, _omitFieldNames ? '' : 'responsibleTeam')
    ..aOS(10, _omitFieldNames ? '' : 'responsibleClinician')
    ..aE<EpisodeStatus>(11, _omitFieldNames ? '' : 'status',
        enumValues: EpisodeStatus.values)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'admittedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'readyAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'dischargedAt',
        subBuilder: $0.Timestamp.create)
    ..aE<EpisodeOutcome>(15, _omitFieldNames ? '' : 'outcome',
        enumValues: EpisodeOutcome.values)
    ..aOS(16, _omitFieldNames ? '' : 'outcomeNote')
    ..aInt64(17, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IcuEpisode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IcuEpisode copyWith(void Function(IcuEpisode) updates) =>
      super.copyWith((message) => updates(message as IcuEpisode)) as IcuEpisode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IcuEpisode create() => IcuEpisode._();
  @$core.override
  IcuEpisode createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IcuEpisode getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IcuEpisode>(create);
  static IcuEpisode? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  /// The Wave-1 encounter this is the critical-care detail of.
  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get patientId => $_getSZ(2);
  @$pb.TagNumber(3)
  set patientId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPatientId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatientId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get unitId => $_getSZ(4);
  @$pb.TagNumber(5)
  set unitId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnitId() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnitId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get bedId => $_getSZ(5);
  @$pb.TagNumber(6)
  set bedId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBedId() => $_has(5);
  @$pb.TagNumber(6)
  void clearBedId() => $_clearField(6);

  @$pb.TagNumber(7)
  AdmissionSource get source => $_getN(6);
  @$pb.TagNumber(7)
  set source(AdmissionSource value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSource() => $_has(6);
  @$pb.TagNumber(7)
  void clearSource() => $_clearField(7);

  /// The episode this one continues, where a patient moved between units.
  @$pb.TagNumber(8)
  $core.String get transferredFrom => $_getSZ(7);
  @$pb.TagNumber(8)
  set transferredFrom($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTransferredFrom() => $_has(7);
  @$pb.TagNumber(8)
  void clearTransferredFrom() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get responsibleTeam => $_getSZ(8);
  @$pb.TagNumber(9)
  set responsibleTeam($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasResponsibleTeam() => $_has(8);
  @$pb.TagNumber(9)
  void clearResponsibleTeam() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get responsibleClinician => $_getSZ(9);
  @$pb.TagNumber(10)
  set responsibleClinician($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasResponsibleClinician() => $_has(9);
  @$pb.TagNumber(10)
  void clearResponsibleClinician() => $_clearField(10);

  @$pb.TagNumber(11)
  EpisodeStatus get status => $_getN(10);
  @$pb.TagNumber(11)
  set status(EpisodeStatus value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasStatus() => $_has(10);
  @$pb.TagNumber(11)
  void clearStatus() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get admittedAt => $_getN(11);
  @$pb.TagNumber(12)
  set admittedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasAdmittedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearAdmittedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureAdmittedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $0.Timestamp get readyAt => $_getN(12);
  @$pb.TagNumber(13)
  set readyAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasReadyAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearReadyAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureReadyAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Timestamp get dischargedAt => $_getN(13);
  @$pb.TagNumber(14)
  set dischargedAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasDischargedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearDischargedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureDischargedAt() => $_ensure(13);

  @$pb.TagNumber(15)
  EpisodeOutcome get outcome => $_getN(14);
  @$pb.TagNumber(15)
  set outcome(EpisodeOutcome value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasOutcome() => $_has(14);
  @$pb.TagNumber(15)
  void clearOutcome() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get outcomeNote => $_getSZ(15);
  @$pb.TagNumber(16)
  set outcomeNote($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasOutcomeNote() => $_has(15);
  @$pb.TagNumber(16)
  void clearOutcomeNote() => $_clearField(16);

  @$pb.TagNumber(17)
  $fixnum.Int64 get version => $_getI64(16);
  @$pb.TagNumber(17)
  set version($fixnum.Int64 value) => $_setInt64(16, value);
  @$pb.TagNumber(17)
  $core.bool hasVersion() => $_has(16);
  @$pb.TagNumber(17)
  void clearVersion() => $_clearField(17);
}

/// The machine a value came from (SRS-ICU-003).
class DeviceSource extends $pb.GeneratedMessage {
  factory DeviceSource({
    $core.String? deviceId,
    $core.String? model,
    $core.String? channelId,
    $0.Timestamp? measuredAt,
    $core.String? quality,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (model != null) result.model = model;
    if (channelId != null) result.channelId = channelId;
    if (measuredAt != null) result.measuredAt = measuredAt;
    if (quality != null) result.quality = quality;
    return result;
  }

  DeviceSource._();

  factory DeviceSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceSource',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'model')
    ..aOS(3, _omitFieldNames ? '' : 'channelId')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'measuredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'quality')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSource copyWith(void Function(DeviceSource) updates) =>
      super.copyWith((message) => updates(message as DeviceSource))
          as DeviceSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceSource create() => DeviceSource._();
  @$core.override
  DeviceSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceSource>(create);
  static DeviceSource? _defaultInstance;

  /// The hospital's asset identifier, so a run of bad readings traces to the
  /// monitor rather than to the bed.
  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get model => $_getSZ(1);
  @$pb.TagNumber(2)
  set model($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModel() => $_has(1);
  @$pb.TagNumber(2)
  void clearModel() => $_clearField(2);

  /// Which parameter on the device — a monitor sends a dozen.
  @$pb.TagNumber(3)
  $core.String get channelId => $_getSZ(2);
  @$pb.TagNumber(3)
  set channelId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChannelId() => $_has(2);
  @$pb.TagNumber(3)
  void clearChannelId() => $_clearField(3);

  /// The device's own clock. Absent where the feed has sent nothing, which is
  /// how a stale feed is told from a current one.
  @$pb.TagNumber(4)
  $0.Timestamp get measuredAt => $_getN(3);
  @$pb.TagNumber(4)
  set measuredAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMeasuredAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearMeasuredAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureMeasuredAt() => $_ensure(3);

  /// What the device said about its own reading, verbatim. Never interpreted:
  /// every vendor's quality vocabulary is its own.
  @$pb.TagNumber(5)
  $core.String get quality => $_getSZ(4);
  @$pb.TagNumber(5)
  set quality($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuality() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuality() => $_clearField(5);
}

class Observation extends $pb.GeneratedMessage {
  factory Observation({
    $core.String? observationId,
    $core.String? episodeId,
    $core.String? codeSystem,
    $core.String? code,
    $core.String? display,
    $core.String? dimension,
    $core.double? value,
    $core.String? unit,
    $core.double? rawValue,
    $core.String? rawUnit,
    $core.bool? normalised,
    ObservationSource? source,
    ValidationState? validation,
    DeviceSource? device,
    $0.Timestamp? observedAt,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
    $core.String? validatedBy,
    $0.Timestamp? validatedAt,
    $core.String? validationNote,
  }) {
    final result = create();
    if (observationId != null) result.observationId = observationId;
    if (episodeId != null) result.episodeId = episodeId;
    if (codeSystem != null) result.codeSystem = codeSystem;
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (dimension != null) result.dimension = dimension;
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (rawValue != null) result.rawValue = rawValue;
    if (rawUnit != null) result.rawUnit = rawUnit;
    if (normalised != null) result.normalised = normalised;
    if (source != null) result.source = source;
    if (validation != null) result.validation = validation;
    if (device != null) result.device = device;
    if (observedAt != null) result.observedAt = observedAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (validatedBy != null) result.validatedBy = validatedBy;
    if (validatedAt != null) result.validatedAt = validatedAt;
    if (validationNote != null) result.validationNote = validationNote;
    return result;
  }

  Observation._();

  factory Observation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Observation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Observation',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'observationId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeId')
    ..aOS(3, _omitFieldNames ? '' : 'codeSystem')
    ..aOS(4, _omitFieldNames ? '' : 'code')
    ..aOS(5, _omitFieldNames ? '' : 'display')
    ..aOS(6, _omitFieldNames ? '' : 'dimension')
    ..aD(7, _omitFieldNames ? '' : 'value')
    ..aOS(8, _omitFieldNames ? '' : 'unit')
    ..aD(9, _omitFieldNames ? '' : 'rawValue')
    ..aOS(10, _omitFieldNames ? '' : 'rawUnit')
    ..aOB(11, _omitFieldNames ? '' : 'normalised')
    ..aE<ObservationSource>(12, _omitFieldNames ? '' : 'source',
        enumValues: ObservationSource.values)
    ..aE<ValidationState>(13, _omitFieldNames ? '' : 'validation',
        enumValues: ValidationState.values)
    ..aOM<DeviceSource>(14, _omitFieldNames ? '' : 'device',
        subBuilder: DeviceSource.create)
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(17, _omitFieldNames ? '' : 'recordedBy')
    ..aOS(18, _omitFieldNames ? '' : 'validatedBy')
    ..aOM<$0.Timestamp>(19, _omitFieldNames ? '' : 'validatedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(20, _omitFieldNames ? '' : 'validationNote')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Observation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Observation copyWith(void Function(Observation) updates) =>
      super.copyWith((message) => updates(message as Observation))
          as Observation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Observation create() => Observation._();
  @$core.override
  Observation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Observation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Observation>(create);
  static Observation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get observationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set observationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasObservationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearObservationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get episodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set episodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpisodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpisodeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get codeSystem => $_getSZ(2);
  @$pb.TagNumber(3)
  set codeSystem($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCodeSystem() => $_has(2);
  @$pb.TagNumber(3)
  void clearCodeSystem() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get code => $_getSZ(3);
  @$pb.TagNumber(4)
  set code($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get display => $_getSZ(4);
  @$pb.TagNumber(5)
  set display($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDisplay() => $_has(4);
  @$pb.TagNumber(5)
  void clearDisplay() => $_clearField(5);

  /// The unit family the value is measured in — temperature, pressure, volume.
  @$pb.TagNumber(6)
  $core.String get dimension => $_getSZ(5);
  @$pb.TagNumber(6)
  set dimension($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDimension() => $_has(5);
  @$pb.TagNumber(6)
  void clearDimension() => $_clearField(6);

  /// Normalised.
  @$pb.TagNumber(7)
  $core.double get value => $_getN(6);
  @$pb.TagNumber(7)
  set value($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearValue() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get unit => $_getSZ(7);
  @$pb.TagNumber(8)
  set unit($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUnit() => $_has(7);
  @$pb.TagNumber(8)
  void clearUnit() => $_clearField(8);

  /// As it arrived.
  @$pb.TagNumber(9)
  $core.double get rawValue => $_getN(8);
  @$pb.TagNumber(9)
  set rawValue($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRawValue() => $_has(8);
  @$pb.TagNumber(9)
  void clearRawValue() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get rawUnit => $_getSZ(9);
  @$pb.TagNumber(10)
  set rawUnit($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRawUnit() => $_has(9);
  @$pb.TagNumber(10)
  void clearRawUnit() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get normalised => $_getBF(10);
  @$pb.TagNumber(11)
  set normalised($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNormalised() => $_has(10);
  @$pb.TagNumber(11)
  void clearNormalised() => $_clearField(11);

  @$pb.TagNumber(12)
  ObservationSource get source => $_getN(11);
  @$pb.TagNumber(12)
  set source(ObservationSource value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSource() => $_has(11);
  @$pb.TagNumber(12)
  void clearSource() => $_clearField(12);

  @$pb.TagNumber(13)
  ValidationState get validation => $_getN(12);
  @$pb.TagNumber(13)
  set validation(ValidationState value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasValidation() => $_has(12);
  @$pb.TagNumber(13)
  void clearValidation() => $_clearField(13);

  @$pb.TagNumber(14)
  DeviceSource get device => $_getN(13);
  @$pb.TagNumber(14)
  set device(DeviceSource value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasDevice() => $_has(13);
  @$pb.TagNumber(14)
  void clearDevice() => $_clearField(14);
  @$pb.TagNumber(14)
  DeviceSource ensureDevice() => $_ensure(13);

  @$pb.TagNumber(15)
  $0.Timestamp get observedAt => $_getN(14);
  @$pb.TagNumber(15)
  set observedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasObservedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearObservedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureObservedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $0.Timestamp get recordedAt => $_getN(15);
  @$pb.TagNumber(16)
  set recordedAt($0.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasRecordedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearRecordedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureRecordedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.String get recordedBy => $_getSZ(16);
  @$pb.TagNumber(17)
  set recordedBy($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasRecordedBy() => $_has(16);
  @$pb.TagNumber(17)
  void clearRecordedBy() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get validatedBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set validatedBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasValidatedBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearValidatedBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $0.Timestamp get validatedAt => $_getN(18);
  @$pb.TagNumber(19)
  set validatedAt($0.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasValidatedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearValidatedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Timestamp ensureValidatedAt() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.String get validationNote => $_getSZ(19);
  @$pb.TagNumber(20)
  set validationNote($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasValidationNote() => $_has(19);
  @$pb.TagNumber(20)
  void clearValidationNote() => $_clearField(20);
}

/// A period's fluid balance (SRS-ICU-007).
///
/// Recomputed from the live entries every time. Nothing stores a running total,
/// so a correction cannot leave one that no set of entries adds up to.
class Balance extends $pb.GeneratedMessage {
  factory Balance({
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.double? intakeMl,
    $core.double? outputMl,
    $core.double? netMl,
    $core.int? entries,
    $core.int? corrections,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (intakeMl != null) result.intakeMl = intakeMl;
    if (outputMl != null) result.outputMl = outputMl;
    if (netMl != null) result.netMl = netMl;
    if (entries != null) result.entries = entries;
    if (corrections != null) result.corrections = corrections;
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
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aD(3, _omitFieldNames ? '' : 'intakeMl')
    ..aD(4, _omitFieldNames ? '' : 'outputMl')
    ..aD(5, _omitFieldNames ? '' : 'netMl')
    ..aI(6, _omitFieldNames ? '' : 'entries')
    ..aI(7, _omitFieldNames ? '' : 'corrections')
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

  /// How many live entries the totals came from, so a zero from no entries is
  /// distinguishable from a genuine zero balance.
  @$pb.TagNumber(6)
  $core.int get entries => $_getIZ(5);
  @$pb.TagNumber(6)
  set entries($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEntries() => $_has(5);
  @$pb.TagNumber(6)
  void clearEntries() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get corrections => $_getIZ(6);
  @$pb.TagNumber(7)
  set corrections($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCorrections() => $_has(6);
  @$pb.TagNumber(7)
  void clearCorrections() => $_clearField(7);
}

class BalanceEntry extends $pb.GeneratedMessage {
  factory BalanceEntry({
    $core.String? entryId,
    $core.String? episodeId,
    $core.String? direction,
    $core.String? route,
    $core.double? volumeMl,
    $0.Timestamp? occurredAt,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
    $core.String? supersededBy,
    $core.String? corrects,
    $core.String? correctionReason,
  }) {
    final result = create();
    if (entryId != null) result.entryId = entryId;
    if (episodeId != null) result.episodeId = episodeId;
    if (direction != null) result.direction = direction;
    if (route != null) result.route = route;
    if (volumeMl != null) result.volumeMl = volumeMl;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (supersededBy != null) result.supersededBy = supersededBy;
    if (corrects != null) result.corrects = corrects;
    if (correctionReason != null) result.correctionReason = correctionReason;
    return result;
  }

  BalanceEntry._();

  factory BalanceEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BalanceEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BalanceEntry',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'entryId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeId')
    ..aOS(3, _omitFieldNames ? '' : 'direction')
    ..aOS(4, _omitFieldNames ? '' : 'route')
    ..aD(5, _omitFieldNames ? '' : 'volumeMl')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'recordedBy')
    ..aOS(9, _omitFieldNames ? '' : 'supersededBy')
    ..aOS(10, _omitFieldNames ? '' : 'corrects')
    ..aOS(11, _omitFieldNames ? '' : 'correctionReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BalanceEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BalanceEntry copyWith(void Function(BalanceEntry) updates) =>
      super.copyWith((message) => updates(message as BalanceEntry))
          as BalanceEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BalanceEntry create() => BalanceEntry._();
  @$core.override
  BalanceEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BalanceEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BalanceEntry>(create);
  static BalanceEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set entryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get episodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set episodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpisodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpisodeId() => $_clearField(2);

  /// "intake" or "output".
  @$pb.TagNumber(3)
  $core.String get direction => $_getSZ(2);
  @$pb.TagNumber(3)
  set direction($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDirection() => $_has(2);
  @$pb.TagNumber(3)
  void clearDirection() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get route => $_getSZ(3);
  @$pb.TagNumber(4)
  set route($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRoute() => $_has(3);
  @$pb.TagNumber(4)
  void clearRoute() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get volumeMl => $_getN(4);
  @$pb.TagNumber(5)
  set volumeMl($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVolumeMl() => $_has(4);
  @$pb.TagNumber(5)
  void clearVolumeMl() => $_clearField(5);

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

  @$pb.TagNumber(7)
  $0.Timestamp get recordedAt => $_getN(6);
  @$pb.TagNumber(7)
  set recordedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasRecordedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearRecordedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureRecordedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get recordedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set recordedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRecordedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearRecordedBy() => $_clearField(8);

  /// Set where this entry has been corrected by a later one.
  @$pb.TagNumber(9)
  $core.String get supersededBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set supersededBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSupersededBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearSupersededBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get corrects => $_getSZ(9);
  @$pb.TagNumber(10)
  set corrects($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCorrects() => $_has(9);
  @$pb.TagNumber(10)
  void clearCorrects() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get correctionReason => $_getSZ(10);
  @$pb.TagNumber(11)
  set correctionReason($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCorrectionReason() => $_has(10);
  @$pb.TagNumber(11)
  void clearCorrectionReason() => $_clearField(11);
}

class Support extends $pb.GeneratedMessage {
  factory Support({
    $core.String? supportId,
    $core.String? episodeId,
    SupportKind? kind,
    $core.String? label,
    $core.String? modality,
    $0.Timestamp? startedAt,
    $core.String? startedBy,
    $0.Timestamp? stoppedAt,
    $core.String? stoppedBy,
    $core.String? stopNote,
  }) {
    final result = create();
    if (supportId != null) result.supportId = supportId;
    if (episodeId != null) result.episodeId = episodeId;
    if (kind != null) result.kind = kind;
    if (label != null) result.label = label;
    if (modality != null) result.modality = modality;
    if (startedAt != null) result.startedAt = startedAt;
    if (startedBy != null) result.startedBy = startedBy;
    if (stoppedAt != null) result.stoppedAt = stoppedAt;
    if (stoppedBy != null) result.stoppedBy = stoppedBy;
    if (stopNote != null) result.stopNote = stopNote;
    return result;
  }

  Support._();

  factory Support.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Support.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Support',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'supportId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeId')
    ..aE<SupportKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: SupportKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'label')
    ..aOS(5, _omitFieldNames ? '' : 'modality')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'startedBy')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'stoppedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'stoppedBy')
    ..aOS(10, _omitFieldNames ? '' : 'stopNote')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Support clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Support copyWith(void Function(Support) updates) =>
      super.copyWith((message) => updates(message as Support)) as Support;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Support create() => Support._();
  @$core.override
  Support createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Support getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Support>(create);
  static Support? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get supportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set supportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSupportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSupportId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get episodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set episodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpisodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpisodeId() => $_clearField(2);

  @$pb.TagNumber(3)
  SupportKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(SupportKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  /// Names a local modality where kind is OTHER.
  @$pb.TagNumber(4)
  $core.String get label => $_getSZ(3);
  @$pb.TagNumber(4)
  set label($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLabel() => $_has(3);
  @$pb.TagNumber(4)
  void clearLabel() => $_clearField(4);

  /// The specific form — CVVHDF, VV-ECMO, noradrenaline.
  @$pb.TagNumber(5)
  $core.String get modality => $_getSZ(4);
  @$pb.TagNumber(5)
  set modality($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasModality() => $_has(4);
  @$pb.TagNumber(5)
  void clearModality() => $_clearField(5);

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
  $core.String get startedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set startedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStartedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearStartedBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get stoppedAt => $_getN(7);
  @$pb.TagNumber(8)
  set stoppedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStoppedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearStoppedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureStoppedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get stoppedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set stoppedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasStoppedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearStoppedBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get stopNote => $_getSZ(9);
  @$pb.TagNumber(10)
  set stopNote($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasStopNote() => $_has(9);
  @$pb.TagNumber(10)
  void clearStopNote() => $_clearField(10);
}

class VentSetting extends $pb.GeneratedMessage {
  factory VentSetting({
    $core.String? settingId,
    $core.String? episodeId,
    $core.String? supportId,
    $core.String? mode,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? parameters,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? measured,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? units,
    $core.String? deviceId,
    $0.Timestamp? effectiveAt,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
    $core.String? changeReason,
  }) {
    final result = create();
    if (settingId != null) result.settingId = settingId;
    if (episodeId != null) result.episodeId = episodeId;
    if (supportId != null) result.supportId = supportId;
    if (mode != null) result.mode = mode;
    if (parameters != null) result.parameters.addEntries(parameters);
    if (measured != null) result.measured.addEntries(measured);
    if (units != null) result.units.addEntries(units);
    if (deviceId != null) result.deviceId = deviceId;
    if (effectiveAt != null) result.effectiveAt = effectiveAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (changeReason != null) result.changeReason = changeReason;
    return result;
  }

  VentSetting._();

  factory VentSetting.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VentSetting.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VentSetting',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'settingId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeId')
    ..aOS(3, _omitFieldNames ? '' : 'supportId')
    ..aOS(4, _omitFieldNames ? '' : 'mode')
    ..m<$core.String, $core.double>(5, _omitFieldNames ? '' : 'parameters',
        entryClassName: 'VentSetting.ParametersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('healthcare.icu.v1'))
    ..m<$core.String, $core.double>(6, _omitFieldNames ? '' : 'measured',
        entryClassName: 'VentSetting.MeasuredEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('healthcare.icu.v1'))
    ..m<$core.String, $core.String>(7, _omitFieldNames ? '' : 'units',
        entryClassName: 'VentSetting.UnitsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('healthcare.icu.v1'))
    ..aOS(8, _omitFieldNames ? '' : 'deviceId')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'effectiveAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'recordedBy')
    ..aOS(12, _omitFieldNames ? '' : 'changeReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VentSetting clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VentSetting copyWith(void Function(VentSetting) updates) =>
      super.copyWith((message) => updates(message as VentSetting))
          as VentSetting;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VentSetting create() => VentSetting._();
  @$core.override
  VentSetting createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VentSetting getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VentSetting>(create);
  static VentSetting? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get settingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set settingId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSettingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get episodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set episodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpisodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpisodeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get supportId => $_getSZ(2);
  @$pb.TagNumber(3)
  set supportId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSupportId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSupportId() => $_clearField(3);

  /// The vendor's own mode string. Every manufacturer names modes differently,
  /// and a normalised enumeration would lose the mode the machine is in.
  @$pb.TagNumber(4)
  $core.String get mode => $_getSZ(3);
  @$pb.TagNumber(4)
  set mode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearMode() => $_clearField(4);

  /// Set parameters and measured ones side by side: the difference between a
  /// set tidal volume and a delivered one is the clinical finding.
  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.double> get parameters => $_getMap(4);

  @$pb.TagNumber(6)
  $pb.PbMap<$core.String, $core.double> get measured => $_getMap(5);

  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $core.String> get units => $_getMap(6);

  @$pb.TagNumber(8)
  $core.String get deviceId => $_getSZ(7);
  @$pb.TagNumber(8)
  set deviceId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDeviceId() => $_has(7);
  @$pb.TagNumber(8)
  void clearDeviceId() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get effectiveAt => $_getN(8);
  @$pb.TagNumber(9)
  set effectiveAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasEffectiveAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearEffectiveAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureEffectiveAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get recordedAt => $_getN(9);
  @$pb.TagNumber(10)
  set recordedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasRecordedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearRecordedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureRecordedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get recordedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set recordedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRecordedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearRecordedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get changeReason => $_getSZ(11);
  @$pb.TagNumber(12)
  set changeReason($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasChangeReason() => $_has(11);
  @$pb.TagNumber(12)
  void clearChangeReason() => $_clearField(12);
}

class Infusion extends $pb.GeneratedMessage {
  factory Infusion({
    $core.String? infusionId,
    $core.String? episodeId,
    $core.String? prescriptionId,
    $core.String? drugCode,
    $core.String? drugDisplay,
    $core.double? concentrationAmount,
    $core.String? concentrationUnit,
    $core.double? concentrationVolume,
    $core.String? doseUnit,
    $core.double? weightKg,
    $0.Timestamp? startedAt,
    $core.String? startedBy,
    $0.Timestamp? stoppedAt,
    $core.String? stoppedBy,
    $core.Iterable<Titration>? titrations,
  }) {
    final result = create();
    if (infusionId != null) result.infusionId = infusionId;
    if (episodeId != null) result.episodeId = episodeId;
    if (prescriptionId != null) result.prescriptionId = prescriptionId;
    if (drugCode != null) result.drugCode = drugCode;
    if (drugDisplay != null) result.drugDisplay = drugDisplay;
    if (concentrationAmount != null)
      result.concentrationAmount = concentrationAmount;
    if (concentrationUnit != null) result.concentrationUnit = concentrationUnit;
    if (concentrationVolume != null)
      result.concentrationVolume = concentrationVolume;
    if (doseUnit != null) result.doseUnit = doseUnit;
    if (weightKg != null) result.weightKg = weightKg;
    if (startedAt != null) result.startedAt = startedAt;
    if (startedBy != null) result.startedBy = startedBy;
    if (stoppedAt != null) result.stoppedAt = stoppedAt;
    if (stoppedBy != null) result.stoppedBy = stoppedBy;
    if (titrations != null) result.titrations.addAll(titrations);
    return result;
  }

  Infusion._();

  factory Infusion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Infusion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Infusion',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'infusionId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeId')
    ..aOS(3, _omitFieldNames ? '' : 'prescriptionId')
    ..aOS(4, _omitFieldNames ? '' : 'drugCode')
    ..aOS(5, _omitFieldNames ? '' : 'drugDisplay')
    ..aD(6, _omitFieldNames ? '' : 'concentrationAmount')
    ..aOS(7, _omitFieldNames ? '' : 'concentrationUnit')
    ..aD(8, _omitFieldNames ? '' : 'concentrationVolume')
    ..aOS(9, _omitFieldNames ? '' : 'doseUnit')
    ..aD(10, _omitFieldNames ? '' : 'weightKg')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'startedBy')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'stoppedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(14, _omitFieldNames ? '' : 'stoppedBy')
    ..pPM<Titration>(15, _omitFieldNames ? '' : 'titrations',
        subBuilder: Titration.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Infusion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Infusion copyWith(void Function(Infusion) updates) =>
      super.copyWith((message) => updates(message as Infusion)) as Infusion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Infusion create() => Infusion._();
  @$core.override
  Infusion createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Infusion getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Infusion>(create);
  static Infusion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get infusionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set infusionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInfusionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInfusionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get episodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set episodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpisodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpisodeId() => $_clearField(2);

  /// The Wave-1 prescription is the authority; this is what was running.
  @$pb.TagNumber(3)
  $core.String get prescriptionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set prescriptionId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrescriptionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrescriptionId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get drugCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set drugCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDrugCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearDrugCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get drugDisplay => $_getSZ(4);
  @$pb.TagNumber(5)
  set drugDisplay($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDrugDisplay() => $_has(4);
  @$pb.TagNumber(5)
  void clearDrugDisplay() => $_clearField(5);

  /// What is in the bag. A rate in mL/h means nothing without it.
  @$pb.TagNumber(6)
  $core.double get concentrationAmount => $_getN(5);
  @$pb.TagNumber(6)
  set concentrationAmount($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasConcentrationAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearConcentrationAmount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get concentrationUnit => $_getSZ(6);
  @$pb.TagNumber(7)
  set concentrationUnit($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasConcentrationUnit() => $_has(6);
  @$pb.TagNumber(7)
  void clearConcentrationUnit() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get concentrationVolume => $_getN(7);
  @$pb.TagNumber(8)
  set concentrationVolume($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasConcentrationVolume() => $_has(7);
  @$pb.TagNumber(8)
  void clearConcentrationVolume() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get doseUnit => $_getSZ(8);
  @$pb.TagNumber(9)
  set doseUnit($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDoseUnit() => $_has(8);
  @$pb.TagNumber(9)
  void clearDoseUnit() => $_clearField(9);

  /// The weight the dose was calculated from, frozen at the time.
  @$pb.TagNumber(10)
  $core.double get weightKg => $_getN(9);
  @$pb.TagNumber(10)
  set weightKg($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasWeightKg() => $_has(9);
  @$pb.TagNumber(10)
  void clearWeightKg() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get startedAt => $_getN(10);
  @$pb.TagNumber(11)
  set startedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasStartedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearStartedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureStartedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get startedBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set startedBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasStartedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearStartedBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get stoppedAt => $_getN(12);
  @$pb.TagNumber(13)
  set stoppedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasStoppedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearStoppedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureStoppedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get stoppedBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set stoppedBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasStoppedBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearStoppedBy() => $_clearField(14);

  @$pb.TagNumber(15)
  $pb.PbList<Titration> get titrations => $_getList(14);
}

class Titration extends $pb.GeneratedMessage {
  factory Titration({
    $core.String? titrationId,
    $core.double? rate,
    $core.String? rateUnit,
    $core.double? dose,
    $0.Timestamp? effectiveAt,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
    $core.String? deviceId,
    $core.String? reason,
  }) {
    final result = create();
    if (titrationId != null) result.titrationId = titrationId;
    if (rate != null) result.rate = rate;
    if (rateUnit != null) result.rateUnit = rateUnit;
    if (dose != null) result.dose = dose;
    if (effectiveAt != null) result.effectiveAt = effectiveAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (deviceId != null) result.deviceId = deviceId;
    if (reason != null) result.reason = reason;
    return result;
  }

  Titration._();

  factory Titration.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Titration.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Titration',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'titrationId')
    ..aD(2, _omitFieldNames ? '' : 'rate')
    ..aOS(3, _omitFieldNames ? '' : 'rateUnit')
    ..aD(4, _omitFieldNames ? '' : 'dose')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'effectiveAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'recordedBy')
    ..aOS(8, _omitFieldNames ? '' : 'deviceId')
    ..aOS(9, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Titration clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Titration copyWith(void Function(Titration) updates) =>
      super.copyWith((message) => updates(message as Titration)) as Titration;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Titration create() => Titration._();
  @$core.override
  Titration createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Titration getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Titration>(create);
  static Titration? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get titrationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set titrationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitrationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitrationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get rate => $_getN(1);
  @$pb.TagNumber(2)
  set rate($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRate() => $_has(1);
  @$pb.TagNumber(2)
  void clearRate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get rateUnit => $_getSZ(2);
  @$pb.TagNumber(3)
  set rateUnit($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRateUnit() => $_has(2);
  @$pb.TagNumber(3)
  void clearRateUnit() => $_clearField(3);

  /// The clinical dose the rate works out to, stored rather than recomputed.
  @$pb.TagNumber(4)
  $core.double get dose => $_getN(3);
  @$pb.TagNumber(4)
  set dose($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDose() => $_has(3);
  @$pb.TagNumber(4)
  void clearDose() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get effectiveAt => $_getN(4);
  @$pb.TagNumber(5)
  set effectiveAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEffectiveAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearEffectiveAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureEffectiveAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get recordedAt => $_getN(5);
  @$pb.TagNumber(6)
  set recordedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRecordedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecordedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureRecordedAt() => $_ensure(5);

  /// One of these is always set: a rate change attributed to nobody is one no
  /// review can ask about.
  @$pb.TagNumber(7)
  $core.String get recordedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set recordedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRecordedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearRecordedBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get deviceId => $_getSZ(7);
  @$pb.TagNumber(8)
  set deviceId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDeviceId() => $_has(7);
  @$pb.TagNumber(8)
  void clearDeviceId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get reason => $_getSZ(8);
  @$pb.TagNumber(9)
  set reason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearReason() => $_clearField(9);
}

class InvasiveDevice extends $pb.GeneratedMessage {
  factory InvasiveDevice({
    $core.String? deviceId,
    $core.String? episodeId,
    $core.String? kind,
    $core.String? site,
    $core.int? lumens,
    $0.Timestamp? insertedAt,
    $core.String? insertedBy,
    $0.Timestamp? removedAt,
    $core.String? removedBy,
    $core.String? removalReason,
    $fixnum.Int64? reviewEverySeconds,
    $0.Timestamp? lastReviewedAt,
    $core.String? lastReviewedBy,
    $core.bool? reviewOverdue,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (episodeId != null) result.episodeId = episodeId;
    if (kind != null) result.kind = kind;
    if (site != null) result.site = site;
    if (lumens != null) result.lumens = lumens;
    if (insertedAt != null) result.insertedAt = insertedAt;
    if (insertedBy != null) result.insertedBy = insertedBy;
    if (removedAt != null) result.removedAt = removedAt;
    if (removedBy != null) result.removedBy = removedBy;
    if (removalReason != null) result.removalReason = removalReason;
    if (reviewEverySeconds != null)
      result.reviewEverySeconds = reviewEverySeconds;
    if (lastReviewedAt != null) result.lastReviewedAt = lastReviewedAt;
    if (lastReviewedBy != null) result.lastReviewedBy = lastReviewedBy;
    if (reviewOverdue != null) result.reviewOverdue = reviewOverdue;
    return result;
  }

  InvasiveDevice._();

  factory InvasiveDevice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InvasiveDevice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InvasiveDevice',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeId')
    ..aOS(3, _omitFieldNames ? '' : 'kind')
    ..aOS(4, _omitFieldNames ? '' : 'site')
    ..aI(5, _omitFieldNames ? '' : 'lumens')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'insertedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'insertedBy')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'removedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'removedBy')
    ..aOS(10, _omitFieldNames ? '' : 'removalReason')
    ..aInt64(11, _omitFieldNames ? '' : 'reviewEverySeconds')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'lastReviewedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'lastReviewedBy')
    ..aOB(14, _omitFieldNames ? '' : 'reviewOverdue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InvasiveDevice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InvasiveDevice copyWith(void Function(InvasiveDevice) updates) =>
      super.copyWith((message) => updates(message as InvasiveDevice))
          as InvasiveDevice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvasiveDevice create() => InvasiveDevice._();
  @$core.override
  InvasiveDevice createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InvasiveDevice getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InvasiveDevice>(create);
  static InvasiveDevice? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get episodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set episodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpisodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpisodeId() => $_clearField(2);

  /// The deployment's own vocabulary; infection surveillance names categories
  /// differently everywhere.
  @$pb.TagNumber(3)
  $core.String get kind => $_getSZ(2);
  @$pb.TagNumber(3)
  set kind($core.String value) => $_setString(2, value);
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
  $core.int get lumens => $_getIZ(4);
  @$pb.TagNumber(5)
  set lumens($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLumens() => $_has(4);
  @$pb.TagNumber(5)
  void clearLumens() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get insertedAt => $_getN(5);
  @$pb.TagNumber(6)
  set insertedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasInsertedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearInsertedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureInsertedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get insertedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set insertedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasInsertedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearInsertedBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get removedAt => $_getN(7);
  @$pb.TagNumber(8)
  set removedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRemovedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearRemovedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureRemovedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get removedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set removedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRemovedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearRemovedBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get removalReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set removalReason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRemovalReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearRemovalReason() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get reviewEverySeconds => $_getI64(10);
  @$pb.TagNumber(11)
  set reviewEverySeconds($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasReviewEverySeconds() => $_has(10);
  @$pb.TagNumber(11)
  void clearReviewEverySeconds() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get lastReviewedAt => $_getN(11);
  @$pb.TagNumber(12)
  set lastReviewedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasLastReviewedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearLastReviewedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureLastReviewedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get lastReviewedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set lastReviewedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasLastReviewedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearLastReviewedBy() => $_clearField(13);

  /// Derived per response, never stored: a device whose review interval was
  /// changed yesterday is overdue against the new one.
  @$pb.TagNumber(14)
  $core.bool get reviewOverdue => $_getBF(13);
  @$pb.TagNumber(14)
  set reviewOverdue($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasReviewOverdue() => $_has(13);
  @$pb.TagNumber(14)
  void clearReviewOverdue() => $_clearField(14);
}

class ScoreInput extends $pb.GeneratedMessage {
  factory ScoreInput({
    $core.String? code,
    $core.String? observationId,
    $core.double? value,
    $core.String? unit,
    $0.Timestamp? observedAt,
    $core.int? points,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (observationId != null) result.observationId = observationId;
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (observedAt != null) result.observedAt = observedAt;
    if (points != null) result.points = points;
    return result;
  }

  ScoreInput._();

  factory ScoreInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScoreInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScoreInput',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'observationId')
    ..aD(3, _omitFieldNames ? '' : 'value')
    ..aOS(4, _omitFieldNames ? '' : 'unit')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..aI(6, _omitFieldNames ? '' : 'points')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScoreInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScoreInput copyWith(void Function(ScoreInput) updates) =>
      super.copyWith((message) => updates(message as ScoreInput)) as ScoreInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScoreInput create() => ScoreInput._();
  @$core.override
  ScoreInput createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScoreInput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScoreInput>(create);
  static ScoreInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  /// The exact chart entry, not just the value: the same number recorded twice
  /// is two observations, and a review asks which one.
  @$pb.TagNumber(2)
  $core.String get observationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set observationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasObservationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearObservationId() => $_clearField(2);

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
  $0.Timestamp get observedAt => $_getN(4);
  @$pb.TagNumber(5)
  set observedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasObservedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearObservedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureObservedAt() => $_ensure(4);

  /// What this input contributed, so the arithmetic reads without re-running
  /// the formula.
  @$pb.TagNumber(6)
  $core.int get points => $_getIZ(5);
  @$pb.TagNumber(6)
  set points($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPoints() => $_has(5);
  @$pb.TagNumber(6)
  void clearPoints() => $_clearField(6);
}

class Score extends $pb.GeneratedMessage {
  factory Score({
    $core.String? scoreId,
    $core.String? episodeId,
    $core.String? name,
    $core.String? formulaVersion,
    $core.int? total,
    $core.Iterable<ScoreInput>? inputs,
    $core.Iterable<$core.String>? missing,
    $core.bool? complete,
    $0.Timestamp? calculatedAt,
    $core.String? calculatedBy,
  }) {
    final result = create();
    if (scoreId != null) result.scoreId = scoreId;
    if (episodeId != null) result.episodeId = episodeId;
    if (name != null) result.name = name;
    if (formulaVersion != null) result.formulaVersion = formulaVersion;
    if (total != null) result.total = total;
    if (inputs != null) result.inputs.addAll(inputs);
    if (missing != null) result.missing.addAll(missing);
    if (complete != null) result.complete = complete;
    if (calculatedAt != null) result.calculatedAt = calculatedAt;
    if (calculatedBy != null) result.calculatedBy = calculatedBy;
    return result;
  }

  Score._();

  factory Score.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Score.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Score',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'scoreId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'formulaVersion')
    ..aI(5, _omitFieldNames ? '' : 'total')
    ..pPM<ScoreInput>(6, _omitFieldNames ? '' : 'inputs',
        subBuilder: ScoreInput.create)
    ..pPS(7, _omitFieldNames ? '' : 'missing')
    ..aOB(8, _omitFieldNames ? '' : 'complete')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'calculatedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'calculatedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Score clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Score copyWith(void Function(Score) updates) =>
      super.copyWith((message) => updates(message as Score)) as Score;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Score create() => Score._();
  @$core.override
  Score createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Score getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Score>(create);
  static Score? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get scoreId => $_getSZ(0);
  @$pb.TagNumber(1)
  set scoreId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScoreId() => $_has(0);
  @$pb.TagNumber(1)
  void clearScoreId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get episodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set episodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpisodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpisodeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get formulaVersion => $_getSZ(3);
  @$pb.TagNumber(4)
  set formulaVersion($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFormulaVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearFormulaVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get total => $_getIZ(4);
  @$pb.TagNumber(5)
  set total($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTotal() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotal() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<ScoreInput> get inputs => $_getList(5);

  /// Components no validated input was available for. A score with one is
  /// incomplete, not lower: an absent platelet count scored as normal is how a
  /// coagulopathy scores zero.
  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get missing => $_getList(6);

  @$pb.TagNumber(8)
  $core.bool get complete => $_getBF(7);
  @$pb.TagNumber(8)
  set complete($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasComplete() => $_has(7);
  @$pb.TagNumber(8)
  void clearComplete() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get calculatedAt => $_getN(8);
  @$pb.TagNumber(9)
  set calculatedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCalculatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCalculatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureCalculatedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get calculatedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set calculatedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCalculatedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearCalculatedBy() => $_clearField(10);
}

class BundleResult extends $pb.GeneratedMessage {
  factory BundleResult({
    $core.String? code,
    BundleItemState? state,
    $core.String? reason,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (state != null) result.state = state;
    if (reason != null) result.reason = reason;
    return result;
  }

  BundleResult._();

  factory BundleResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BundleResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BundleResult',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aE<BundleItemState>(2, _omitFieldNames ? '' : 'state',
        enumValues: BundleItemState.values)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleResult copyWith(void Function(BundleResult) updates) =>
      super.copyWith((message) => updates(message as BundleResult))
          as BundleResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BundleResult create() => BundleResult._();
  @$core.override
  BundleResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BundleResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BundleResult>(create);
  static BundleResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  BundleItemState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(BundleItemState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  /// Required for an exception. An exception with no reason is a failure
  /// wearing a better name.
  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class BundlePerformance extends $pb.GeneratedMessage {
  factory BundlePerformance({
    $core.String? performanceId,
    $core.String? episodeId,
    BundleKind? kind,
    $core.String? label,
    $core.String? version,
    $core.Iterable<BundleResult>? results,
    $0.Timestamp? performedAt,
    $core.String? performedBy,
    Compliance? compliance,
  }) {
    final result = create();
    if (performanceId != null) result.performanceId = performanceId;
    if (episodeId != null) result.episodeId = episodeId;
    if (kind != null) result.kind = kind;
    if (label != null) result.label = label;
    if (version != null) result.version = version;
    if (results != null) result.results.addAll(results);
    if (performedAt != null) result.performedAt = performedAt;
    if (performedBy != null) result.performedBy = performedBy;
    if (compliance != null) result.compliance = compliance;
    return result;
  }

  BundlePerformance._();

  factory BundlePerformance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BundlePerformance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BundlePerformance',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'performanceId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeId')
    ..aE<BundleKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: BundleKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'label')
    ..aOS(5, _omitFieldNames ? '' : 'version')
    ..pPM<BundleResult>(6, _omitFieldNames ? '' : 'results',
        subBuilder: BundleResult.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'performedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'performedBy')
    ..aOM<Compliance>(9, _omitFieldNames ? '' : 'compliance',
        subBuilder: Compliance.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundlePerformance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundlePerformance copyWith(void Function(BundlePerformance) updates) =>
      super.copyWith((message) => updates(message as BundlePerformance))
          as BundlePerformance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BundlePerformance create() => BundlePerformance._();
  @$core.override
  BundlePerformance createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BundlePerformance getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BundlePerformance>(create);
  static BundlePerformance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get performanceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set performanceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPerformanceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPerformanceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get episodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set episodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpisodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpisodeId() => $_clearField(2);

  @$pb.TagNumber(3)
  BundleKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(BundleKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get label => $_getSZ(3);
  @$pb.TagNumber(4)
  set label($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLabel() => $_has(3);
  @$pb.TagNumber(4)
  void clearLabel() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get version => $_getSZ(4);
  @$pb.TagNumber(5)
  set version($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<BundleResult> get results => $_getList(5);

  @$pb.TagNumber(7)
  $0.Timestamp get performedAt => $_getN(6);
  @$pb.TagNumber(7)
  set performedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPerformedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearPerformedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensurePerformedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get performedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set performedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPerformedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearPerformedBy() => $_clearField(8);

  @$pb.TagNumber(9)
  Compliance get compliance => $_getN(8);
  @$pb.TagNumber(9)
  set compliance(Compliance value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCompliance() => $_has(8);
  @$pb.TagNumber(9)
  void clearCompliance() => $_clearField(9);
  @$pb.TagNumber(9)
  Compliance ensureCompliance() => $_ensure(8);
}

class Compliance extends $pb.GeneratedMessage {
  factory Compliance({
    $core.int? required,
    $core.int? done,
    $core.int? excepted,
    $core.int? missed,
    $core.bool? compliant,
  }) {
    final result = create();
    if (required != null) result.required = required;
    if (done != null) result.done = done;
    if (excepted != null) result.excepted = excepted;
    if (missed != null) result.missed = missed;
    if (compliant != null) result.compliant = compliant;
    return result;
  }

  Compliance._();

  factory Compliance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Compliance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Compliance',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'required')
    ..aI(2, _omitFieldNames ? '' : 'done')
    ..aI(3, _omitFieldNames ? '' : 'excepted')
    ..aI(4, _omitFieldNames ? '' : 'missed')
    ..aOB(5, _omitFieldNames ? '' : 'compliant')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Compliance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Compliance copyWith(void Function(Compliance) updates) =>
      super.copyWith((message) => updates(message as Compliance)) as Compliance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Compliance create() => Compliance._();
  @$core.override
  Compliance createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Compliance getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Compliance>(create);
  static Compliance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get required => $_getIZ(0);
  @$pb.TagNumber(1)
  set required($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequired() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequired() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get done => $_getIZ(1);
  @$pb.TagNumber(2)
  set done($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDone() => $_has(1);
  @$pb.TagNumber(2)
  void clearDone() => $_clearField(2);

  /// Counted apart from both sides: "we did not do it" and "we decided not to,
  /// and here is why" are different facts, and a unit improves on only one.
  @$pb.TagNumber(3)
  $core.int get excepted => $_getIZ(2);
  @$pb.TagNumber(3)
  set excepted($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExcepted() => $_has(2);
  @$pb.TagNumber(3)
  void clearExcepted() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get missed => $_getIZ(3);
  @$pb.TagNumber(4)
  set missed($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMissed() => $_has(3);
  @$pb.TagNumber(4)
  void clearMissed() => $_clearField(4);

  /// All-or-nothing, as every published bundle measure is: four-fifths of a
  /// sepsis bundle is not 80% of the benefit.
  @$pb.TagNumber(5)
  $core.bool get compliant => $_getBF(4);
  @$pb.TagNumber(5)
  set compliant($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCompliant() => $_has(4);
  @$pb.TagNumber(5)
  void clearCompliant() => $_clearField(5);
}

class Assessment extends $pb.GeneratedMessage {
  factory Assessment({
    $core.String? assessmentId,
    $core.String? episodeId,
    $core.String? kind,
    $core.String? scale,
    $core.int? score,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? findings,
    $core.String? note,
    $0.Timestamp? performedAt,
    $core.String? performedBy,
    $0.Timestamp? nextDueAt,
    $core.bool? overdue,
  }) {
    final result = create();
    if (assessmentId != null) result.assessmentId = assessmentId;
    if (episodeId != null) result.episodeId = episodeId;
    if (kind != null) result.kind = kind;
    if (scale != null) result.scale = scale;
    if (score != null) result.score = score;
    if (findings != null) result.findings.addEntries(findings);
    if (note != null) result.note = note;
    if (performedAt != null) result.performedAt = performedAt;
    if (performedBy != null) result.performedBy = performedBy;
    if (nextDueAt != null) result.nextDueAt = nextDueAt;
    if (overdue != null) result.overdue = overdue;
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
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assessmentId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeId')
    ..aOS(3, _omitFieldNames ? '' : 'kind')
    ..aOS(4, _omitFieldNames ? '' : 'scale')
    ..aI(5, _omitFieldNames ? '' : 'score')
    ..m<$core.String, $core.String>(6, _omitFieldNames ? '' : 'findings',
        entryClassName: 'Assessment.FindingsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('healthcare.icu.v1'))
    ..aOS(7, _omitFieldNames ? '' : 'note')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'performedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'performedBy')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'nextDueAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(11, _omitFieldNames ? '' : 'overdue')
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
  $core.String get episodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set episodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpisodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpisodeId() => $_clearField(2);

  /// pressure_injury, skin, positioning, restraint, sedation, delirium.
  @$pb.TagNumber(3)
  $core.String get kind => $_getSZ(2);
  @$pb.TagNumber(3)
  set kind($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get scale => $_getSZ(3);
  @$pb.TagNumber(4)
  set scale($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScale() => $_has(3);
  @$pb.TagNumber(4)
  void clearScale() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get score => $_getIZ(4);
  @$pb.TagNumber(5)
  set score($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasScore() => $_has(4);
  @$pb.TagNumber(5)
  void clearScore() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbMap<$core.String, $core.String> get findings => $_getMap(5);

  @$pb.TagNumber(7)
  $core.String get note => $_getSZ(6);
  @$pb.TagNumber(7)
  set note($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearNote() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get performedAt => $_getN(7);
  @$pb.TagNumber(8)
  set performedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPerformedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearPerformedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensurePerformedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get performedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set performedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPerformedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearPerformedBy() => $_clearField(9);

  /// Generated on write, so the unit's worklist and its audit agree about when
  /// the reassessment was due.
  @$pb.TagNumber(10)
  $0.Timestamp get nextDueAt => $_getN(9);
  @$pb.TagNumber(10)
  set nextDueAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasNextDueAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearNextDueAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureNextDueAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.bool get overdue => $_getBF(10);
  @$pb.TagNumber(11)
  set overdue($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOverdue() => $_has(10);
  @$pb.TagNumber(11)
  void clearOverdue() => $_clearField(11);
}

class Round extends $pb.GeneratedMessage {
  factory Round({
    $core.String? roundId,
    $core.String? episodeId,
    $core.Iterable<$core.String>? attendance,
    $core.String? summary,
    $0.Timestamp? performedAt,
    $core.String? performedBy,
  }) {
    final result = create();
    if (roundId != null) result.roundId = roundId;
    if (episodeId != null) result.episodeId = episodeId;
    if (attendance != null) result.attendance.addAll(attendance);
    if (summary != null) result.summary = summary;
    if (performedAt != null) result.performedAt = performedAt;
    if (performedBy != null) result.performedBy = performedBy;
    return result;
  }

  Round._();

  factory Round.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Round.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Round',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roundId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeId')
    ..pPS(3, _omitFieldNames ? '' : 'attendance')
    ..aOS(4, _omitFieldNames ? '' : 'summary')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'performedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'performedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Round clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Round copyWith(void Function(Round) updates) =>
      super.copyWith((message) => updates(message as Round)) as Round;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Round create() => Round._();
  @$core.override
  Round createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Round getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Round>(create);
  static Round? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roundId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roundId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoundId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoundId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get episodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set episodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpisodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpisodeId() => $_clearField(2);

  /// Who was on the round, by role. A multidisciplinary round with no
  /// pharmacist is not a multidisciplinary round.
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get attendance => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get summary => $_getSZ(3);
  @$pb.TagNumber(4)
  set summary($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => $_clearField(4);

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

class Goal extends $pb.GeneratedMessage {
  factory Goal({
    $core.String? goalId,
    $core.String? episodeId,
    $core.String? roundId,
    $core.String? domain,
    $core.String? text,
    $core.String? ownerRole,
    $core.String? ownerId,
    GoalStatus? status,
    $0.Timestamp? targetAt,
    $0.Timestamp? resolvedAt,
    $core.String? resolvedBy,
    $core.String? outcome,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
  }) {
    final result = create();
    if (goalId != null) result.goalId = goalId;
    if (episodeId != null) result.episodeId = episodeId;
    if (roundId != null) result.roundId = roundId;
    if (domain != null) result.domain = domain;
    if (text != null) result.text = text;
    if (ownerRole != null) result.ownerRole = ownerRole;
    if (ownerId != null) result.ownerId = ownerId;
    if (status != null) result.status = status;
    if (targetAt != null) result.targetAt = targetAt;
    if (resolvedAt != null) result.resolvedAt = resolvedAt;
    if (resolvedBy != null) result.resolvedBy = resolvedBy;
    if (outcome != null) result.outcome = outcome;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    return result;
  }

  Goal._();

  factory Goal.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Goal.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Goal',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'goalId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeId')
    ..aOS(3, _omitFieldNames ? '' : 'roundId')
    ..aOS(4, _omitFieldNames ? '' : 'domain')
    ..aOS(5, _omitFieldNames ? '' : 'text')
    ..aOS(6, _omitFieldNames ? '' : 'ownerRole')
    ..aOS(7, _omitFieldNames ? '' : 'ownerId')
    ..aE<GoalStatus>(8, _omitFieldNames ? '' : 'status',
        enumValues: GoalStatus.values)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'targetAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'resolvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'resolvedBy')
    ..aOS(12, _omitFieldNames ? '' : 'outcome')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(14, _omitFieldNames ? '' : 'createdBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Goal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Goal copyWith(void Function(Goal) updates) =>
      super.copyWith((message) => updates(message as Goal)) as Goal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Goal create() => Goal._();
  @$core.override
  Goal createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Goal getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Goal>(create);
  static Goal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get goalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set goalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGoalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGoalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get episodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set episodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpisodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpisodeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get roundId => $_getSZ(2);
  @$pb.TagNumber(3)
  set roundId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRoundId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoundId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get domain => $_getSZ(3);
  @$pb.TagNumber(4)
  set domain($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDomain() => $_has(3);
  @$pb.TagNumber(4)
  void clearDomain() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get text => $_getSZ(4);
  @$pb.TagNumber(5)
  set text($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasText() => $_has(4);
  @$pb.TagNumber(5)
  void clearText() => $_clearField(5);

  /// A role rather than a person, because the person changes at handover and
  /// the responsibility does not.
  @$pb.TagNumber(6)
  $core.String get ownerRole => $_getSZ(5);
  @$pb.TagNumber(6)
  set ownerRole($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOwnerRole() => $_has(5);
  @$pb.TagNumber(6)
  void clearOwnerRole() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get ownerId => $_getSZ(6);
  @$pb.TagNumber(7)
  set ownerId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOwnerId() => $_has(6);
  @$pb.TagNumber(7)
  void clearOwnerId() => $_clearField(7);

  @$pb.TagNumber(8)
  GoalStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(GoalStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get targetAt => $_getN(8);
  @$pb.TagNumber(9)
  set targetAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasTargetAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearTargetAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureTargetAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get resolvedAt => $_getN(9);
  @$pb.TagNumber(10)
  set resolvedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasResolvedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearResolvedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureResolvedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get resolvedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set resolvedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasResolvedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearResolvedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get outcome => $_getSZ(11);
  @$pb.TagNumber(12)
  set outcome($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOutcome() => $_has(11);
  @$pb.TagNumber(12)
  void clearOutcome() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get createdAt => $_getN(12);
  @$pb.TagNumber(13)
  set createdAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCreatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureCreatedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get createdBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set createdBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasCreatedBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearCreatedBy() => $_clearField(14);
}

class GoalsOfCare extends $pb.GeneratedMessage {
  factory GoalsOfCare({
    $core.String? goalsOfCareId,
    $core.String? episodeId,
    CareIntent? intent,
    $core.Iterable<$core.String>? limitations,
    $core.String? cprStatus,
    $core.String? discussedWith,
    $core.String? rationale,
    $core.String? authorisedBy,
    $core.String? authorisedRole,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
    $core.String? supersededBy,
    $0.Timestamp? supersededAt,
    $0.Timestamp? reviewBy,
    $core.bool? current,
    $core.bool? reviewOverdue,
  }) {
    final result = create();
    if (goalsOfCareId != null) result.goalsOfCareId = goalsOfCareId;
    if (episodeId != null) result.episodeId = episodeId;
    if (intent != null) result.intent = intent;
    if (limitations != null) result.limitations.addAll(limitations);
    if (cprStatus != null) result.cprStatus = cprStatus;
    if (discussedWith != null) result.discussedWith = discussedWith;
    if (rationale != null) result.rationale = rationale;
    if (authorisedBy != null) result.authorisedBy = authorisedBy;
    if (authorisedRole != null) result.authorisedRole = authorisedRole;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (supersededBy != null) result.supersededBy = supersededBy;
    if (supersededAt != null) result.supersededAt = supersededAt;
    if (reviewBy != null) result.reviewBy = reviewBy;
    if (current != null) result.current = current;
    if (reviewOverdue != null) result.reviewOverdue = reviewOverdue;
    return result;
  }

  GoalsOfCare._();

  factory GoalsOfCare.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GoalsOfCare.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GoalsOfCare',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'goalsOfCareId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeId')
    ..aE<CareIntent>(3, _omitFieldNames ? '' : 'intent',
        enumValues: CareIntent.values)
    ..pPS(4, _omitFieldNames ? '' : 'limitations')
    ..aOS(5, _omitFieldNames ? '' : 'cprStatus')
    ..aOS(6, _omitFieldNames ? '' : 'discussedWith')
    ..aOS(7, _omitFieldNames ? '' : 'rationale')
    ..aOS(8, _omitFieldNames ? '' : 'authorisedBy')
    ..aOS(9, _omitFieldNames ? '' : 'authorisedRole')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'recordedBy')
    ..aOS(12, _omitFieldNames ? '' : 'supersededBy')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'supersededAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'reviewBy',
        subBuilder: $0.Timestamp.create)
    ..aOB(15, _omitFieldNames ? '' : 'current')
    ..aOB(16, _omitFieldNames ? '' : 'reviewOverdue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GoalsOfCare clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GoalsOfCare copyWith(void Function(GoalsOfCare) updates) =>
      super.copyWith((message) => updates(message as GoalsOfCare))
          as GoalsOfCare;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GoalsOfCare create() => GoalsOfCare._();
  @$core.override
  GoalsOfCare createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GoalsOfCare getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GoalsOfCare>(create);
  static GoalsOfCare? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get goalsOfCareId => $_getSZ(0);
  @$pb.TagNumber(1)
  set goalsOfCareId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGoalsOfCareId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGoalsOfCareId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get episodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set episodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpisodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpisodeId() => $_clearField(2);

  @$pb.TagNumber(3)
  CareIntent get intent => $_getN(2);
  @$pb.TagNumber(3)
  set intent(CareIntent value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasIntent() => $_has(2);
  @$pb.TagNumber(3)
  void clearIntent() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get limitations => $_getList(3);

  /// Carried separately because it is the first question every arriving team
  /// asks, and burying it in a list is how it is missed.
  @$pb.TagNumber(5)
  $core.String get cprStatus => $_getSZ(4);
  @$pb.TagNumber(5)
  set cprStatus($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCprStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearCprStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get discussedWith => $_getSZ(5);
  @$pb.TagNumber(6)
  set discussedWith($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDiscussedWith() => $_has(5);
  @$pb.TagNumber(6)
  void clearDiscussedWith() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get rationale => $_getSZ(6);
  @$pb.TagNumber(7)
  set rationale($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRationale() => $_has(6);
  @$pb.TagNumber(7)
  void clearRationale() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get authorisedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set authorisedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAuthorisedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearAuthorisedBy() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get authorisedRole => $_getSZ(8);
  @$pb.TagNumber(9)
  set authorisedRole($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAuthorisedRole() => $_has(8);
  @$pb.TagNumber(9)
  void clearAuthorisedRole() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get recordedAt => $_getN(9);
  @$pb.TagNumber(10)
  set recordedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasRecordedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearRecordedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureRecordedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get recordedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set recordedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRecordedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearRecordedBy() => $_clearField(11);

  /// Set on a ceiling that has been replaced. The history is the point: a
  /// document a coroner reads cannot have had its history overwritten.
  @$pb.TagNumber(12)
  $core.String get supersededBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set supersededBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSupersededBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearSupersededBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get supersededAt => $_getN(12);
  @$pb.TagNumber(13)
  set supersededAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasSupersededAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearSupersededAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureSupersededAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Timestamp get reviewBy => $_getN(13);
  @$pb.TagNumber(14)
  set reviewBy($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasReviewBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearReviewBy() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureReviewBy() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.bool get current => $_getBF(14);
  @$pb.TagNumber(15)
  set current($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasCurrent() => $_has(14);
  @$pb.TagNumber(15)
  void clearCurrent() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.bool get reviewOverdue => $_getBF(15);
  @$pb.TagNumber(16)
  set reviewOverdue($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(16)
  $core.bool hasReviewOverdue() => $_has(15);
  @$pb.TagNumber(16)
  void clearReviewOverdue() => $_clearField(16);
}

/// An advisory worklist entry (SRS-ICU-013).
///
/// Note what is absent: nothing here changes what a bedside device does. This
/// software may notice things and tell people; the monitor's own alarms are a
/// safety function of a regulated device and are not reachable from here.
class Alarm extends $pb.GeneratedMessage {
  factory Alarm({
    $core.String? alarmId,
    $core.String? episodeId,
    $core.String? kind,
    AlarmSeverity? severity,
    $core.String? summary,
    $0.Timestamp? raisedAt,
  }) {
    final result = create();
    if (alarmId != null) result.alarmId = alarmId;
    if (episodeId != null) result.episodeId = episodeId;
    if (kind != null) result.kind = kind;
    if (severity != null) result.severity = severity;
    if (summary != null) result.summary = summary;
    if (raisedAt != null) result.raisedAt = raisedAt;
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
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'alarmId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeId')
    ..aOS(3, _omitFieldNames ? '' : 'kind')
    ..aE<AlarmSeverity>(4, _omitFieldNames ? '' : 'severity',
        enumValues: AlarmSeverity.values)
    ..aOS(5, _omitFieldNames ? '' : 'summary')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'raisedAt',
        subBuilder: $0.Timestamp.create)
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
  $core.String get episodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set episodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpisodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpisodeId() => $_clearField(2);

  /// device_review_overdue, assessment_overdue, feed_stale.
  @$pb.TagNumber(3)
  $core.String get kind => $_getSZ(2);
  @$pb.TagNumber(3)
  set kind($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  AlarmSeverity get severity => $_getN(3);
  @$pb.TagNumber(4)
  set severity(AlarmSeverity value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSeverity() => $_has(3);
  @$pb.TagNumber(4)
  void clearSeverity() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get summary => $_getSZ(4);
  @$pb.TagNumber(5)
  set summary($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSummary() => $_has(4);
  @$pb.TagNumber(5)
  void clearSummary() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get raisedAt => $_getN(5);
  @$pb.TagNumber(6)
  set raisedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRaisedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearRaisedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureRaisedAt() => $_ensure(5);
}

/// One number on the dashboard, with the chart entry it came from.
class DashboardValue extends $pb.GeneratedMessage {
  factory DashboardValue({
    $core.String? code,
    $core.String? display,
    $core.double? value,
    $core.String? unit,
    $core.String? observationId,
    ObservationSource? source,
    ValidationState? validation,
    $core.String? deviceId,
    $0.Timestamp? observedAt,
    $core.bool? stale,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (observationId != null) result.observationId = observationId;
    if (source != null) result.source = source;
    if (validation != null) result.validation = validation;
    if (deviceId != null) result.deviceId = deviceId;
    if (observedAt != null) result.observedAt = observedAt;
    if (stale != null) result.stale = stale;
    return result;
  }

  DashboardValue._();

  factory DashboardValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DashboardValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DashboardValue',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'display')
    ..aD(3, _omitFieldNames ? '' : 'value')
    ..aOS(4, _omitFieldNames ? '' : 'unit')
    ..aOS(5, _omitFieldNames ? '' : 'observationId')
    ..aE<ObservationSource>(6, _omitFieldNames ? '' : 'source',
        enumValues: ObservationSource.values)
    ..aE<ValidationState>(7, _omitFieldNames ? '' : 'validation',
        enumValues: ValidationState.values)
    ..aOS(8, _omitFieldNames ? '' : 'deviceId')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(10, _omitFieldNames ? '' : 'stale')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DashboardValue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DashboardValue copyWith(void Function(DashboardValue) updates) =>
      super.copyWith((message) => updates(message as DashboardValue))
          as DashboardValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DashboardValue create() => DashboardValue._();
  @$core.override
  DashboardValue createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DashboardValue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DashboardValue>(create);
  static DashboardValue? _defaultInstance;

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

  /// What a clinician opens to see the reading itself.
  @$pb.TagNumber(5)
  $core.String get observationId => $_getSZ(4);
  @$pb.TagNumber(5)
  set observationId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasObservationId() => $_has(4);
  @$pb.TagNumber(5)
  void clearObservationId() => $_clearField(5);

  @$pb.TagNumber(6)
  ObservationSource get source => $_getN(5);
  @$pb.TagNumber(6)
  set source(ObservationSource value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSource() => $_has(5);
  @$pb.TagNumber(6)
  void clearSource() => $_clearField(6);

  @$pb.TagNumber(7)
  ValidationState get validation => $_getN(6);
  @$pb.TagNumber(7)
  set validation(ValidationState value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasValidation() => $_has(6);
  @$pb.TagNumber(7)
  void clearValidation() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get deviceId => $_getSZ(7);
  @$pb.TagNumber(8)
  set deviceId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDeviceId() => $_has(7);
  @$pb.TagNumber(8)
  void clearDeviceId() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get observedAt => $_getN(8);
  @$pb.TagNumber(9)
  set observedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasObservedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearObservedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureObservedAt() => $_ensure(8);

  /// From a feed that has gone quiet. The value is shown and marked, rather
  /// than hidden: a blood pressure from an hour ago is information, and
  /// pretending it is current is not.
  @$pb.TagNumber(10)
  $core.bool get stale => $_getBF(9);
  @$pb.TagNumber(10)
  set stale($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasStale() => $_has(9);
  @$pb.TagNumber(10)
  void clearStale() => $_clearField(10);
}

class DashboardRow extends $pb.GeneratedMessage {
  factory DashboardRow({
    $core.String? episodeId,
    $core.String? patientId,
    $core.String? bedId,
    $core.String? unitId,
    $core.String? display,
    $core.Iterable<DashboardValue>? vitals,
    $core.Iterable<SupportKind>? support,
    $core.int? devices,
    $core.int? overdueDevices,
    $core.int? dueAssessments,
    $core.int? openGoals,
    Balance? balance,
    Score? latestScore,
    CareIntent? careIntent,
    $core.String? cprStatus,
    $core.bool? ceilingRestricted,
    $core.int? staleFeeds,
    $0.Timestamp? admittedAt,
    $core.bool? readyForTransfer,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (patientId != null) result.patientId = patientId;
    if (bedId != null) result.bedId = bedId;
    if (unitId != null) result.unitId = unitId;
    if (display != null) result.display = display;
    if (vitals != null) result.vitals.addAll(vitals);
    if (support != null) result.support.addAll(support);
    if (devices != null) result.devices = devices;
    if (overdueDevices != null) result.overdueDevices = overdueDevices;
    if (dueAssessments != null) result.dueAssessments = dueAssessments;
    if (openGoals != null) result.openGoals = openGoals;
    if (balance != null) result.balance = balance;
    if (latestScore != null) result.latestScore = latestScore;
    if (careIntent != null) result.careIntent = careIntent;
    if (cprStatus != null) result.cprStatus = cprStatus;
    if (ceilingRestricted != null) result.ceilingRestricted = ceilingRestricted;
    if (staleFeeds != null) result.staleFeeds = staleFeeds;
    if (admittedAt != null) result.admittedAt = admittedAt;
    if (readyForTransfer != null) result.readyForTransfer = readyForTransfer;
    return result;
  }

  DashboardRow._();

  factory DashboardRow.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DashboardRow.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DashboardRow',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'bedId')
    ..aOS(4, _omitFieldNames ? '' : 'unitId')
    ..aOS(5, _omitFieldNames ? '' : 'display')
    ..pPM<DashboardValue>(6, _omitFieldNames ? '' : 'vitals',
        subBuilder: DashboardValue.create)
    ..pc<SupportKind>(7, _omitFieldNames ? '' : 'support', $pb.PbFieldType.KE,
        valueOf: SupportKind.valueOf,
        enumValues: SupportKind.values,
        defaultEnumValue: SupportKind.SUPPORT_KIND_UNSPECIFIED)
    ..aI(8, _omitFieldNames ? '' : 'devices')
    ..aI(9, _omitFieldNames ? '' : 'overdueDevices')
    ..aI(10, _omitFieldNames ? '' : 'dueAssessments')
    ..aI(11, _omitFieldNames ? '' : 'openGoals')
    ..aOM<Balance>(12, _omitFieldNames ? '' : 'balance',
        subBuilder: Balance.create)
    ..aOM<Score>(13, _omitFieldNames ? '' : 'latestScore',
        subBuilder: Score.create)
    ..aE<CareIntent>(14, _omitFieldNames ? '' : 'careIntent',
        enumValues: CareIntent.values)
    ..aOS(15, _omitFieldNames ? '' : 'cprStatus')
    ..aOB(16, _omitFieldNames ? '' : 'ceilingRestricted')
    ..aI(17, _omitFieldNames ? '' : 'staleFeeds')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'admittedAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(19, _omitFieldNames ? '' : 'readyForTransfer')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DashboardRow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DashboardRow copyWith(void Function(DashboardRow) updates) =>
      super.copyWith((message) => updates(message as DashboardRow))
          as DashboardRow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DashboardRow create() => DashboardRow._();
  @$core.override
  DashboardRow createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DashboardRow getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DashboardRow>(create);
  static DashboardRow? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get bedId => $_getSZ(2);
  @$pb.TagNumber(3)
  set bedId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBedId() => $_has(2);
  @$pb.TagNumber(3)
  void clearBedId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get unitId => $_getSZ(3);
  @$pb.TagNumber(4)
  set unitId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnitId() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnitId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get display => $_getSZ(4);
  @$pb.TagNumber(5)
  set display($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDisplay() => $_has(4);
  @$pb.TagNumber(5)
  void clearDisplay() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<DashboardValue> get vitals => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<SupportKind> get support => $_getList(6);

  @$pb.TagNumber(8)
  $core.int get devices => $_getIZ(7);
  @$pb.TagNumber(8)
  set devices($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDevices() => $_has(7);
  @$pb.TagNumber(8)
  void clearDevices() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get overdueDevices => $_getIZ(8);
  @$pb.TagNumber(9)
  set overdueDevices($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOverdueDevices() => $_has(8);
  @$pb.TagNumber(9)
  void clearOverdueDevices() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get dueAssessments => $_getIZ(9);
  @$pb.TagNumber(10)
  set dueAssessments($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDueAssessments() => $_has(9);
  @$pb.TagNumber(10)
  void clearDueAssessments() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get openGoals => $_getIZ(10);
  @$pb.TagNumber(11)
  set openGoals($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOpenGoals() => $_has(10);
  @$pb.TagNumber(11)
  void clearOpenGoals() => $_clearField(11);

  @$pb.TagNumber(12)
  Balance get balance => $_getN(11);
  @$pb.TagNumber(12)
  set balance(Balance value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasBalance() => $_has(11);
  @$pb.TagNumber(12)
  void clearBalance() => $_clearField(12);
  @$pb.TagNumber(12)
  Balance ensureBalance() => $_ensure(11);

  @$pb.TagNumber(13)
  Score get latestScore => $_getN(12);
  @$pb.TagNumber(13)
  set latestScore(Score value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasLatestScore() => $_has(12);
  @$pb.TagNumber(13)
  void clearLatestScore() => $_clearField(13);
  @$pb.TagNumber(13)
  Score ensureLatestScore() => $_ensure(12);

  /// Present for a viewer who may read it.
  @$pb.TagNumber(14)
  CareIntent get careIntent => $_getN(13);
  @$pb.TagNumber(14)
  set careIntent(CareIntent value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasCareIntent() => $_has(13);
  @$pb.TagNumber(14)
  void clearCareIntent() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get cprStatus => $_getSZ(14);
  @$pb.TagNumber(15)
  set cprStatus($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasCprStatus() => $_has(14);
  @$pb.TagNumber(15)
  void clearCprStatus() => $_clearField(15);

  /// True where this viewer may not read the ceiling. Distinct from an absent
  /// one, which means no ceiling has been agreed — and the difference is what
  /// gets a patient resuscitated against their wishes.
  @$pb.TagNumber(16)
  $core.bool get ceilingRestricted => $_getBF(15);
  @$pb.TagNumber(16)
  set ceilingRestricted($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCeilingRestricted() => $_has(15);
  @$pb.TagNumber(16)
  void clearCeilingRestricted() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.int get staleFeeds => $_getIZ(16);
  @$pb.TagNumber(17)
  set staleFeeds($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasStaleFeeds() => $_has(16);
  @$pb.TagNumber(17)
  void clearStaleFeeds() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get admittedAt => $_getN(17);
  @$pb.TagNumber(18)
  set admittedAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasAdmittedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearAdmittedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureAdmittedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $core.bool get readyForTransfer => $_getBF(18);
  @$pb.TagNumber(19)
  set readyForTransfer($core.bool value) => $_setBool(18, value);
  @$pb.TagNumber(19)
  $core.bool hasReadyForTransfer() => $_has(18);
  @$pb.TagNumber(19)
  void clearReadyForTransfer() => $_clearField(19);
}

/// SRS-ICU-017: reconciles to episode and device timestamps, derived every time
/// rather than kept as counters.
class UnitMetrics extends $pb.GeneratedMessage {
  factory UnitMetrics({
    $core.String? unitId,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? admissions,
    $core.int? discharges,
    $core.int? deaths,
    $core.int? bedDays,
    $core.int? ventilatorDays,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? deviceDays,
    $core.double? meanLengthOfStayHours,
    $core.int? closedEpisodes,
    $core.double? meanDischargeDelayHours,
    $core.int? delayedDischarges,
  }) {
    final result = create();
    if (unitId != null) result.unitId = unitId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (admissions != null) result.admissions = admissions;
    if (discharges != null) result.discharges = discharges;
    if (deaths != null) result.deaths = deaths;
    if (bedDays != null) result.bedDays = bedDays;
    if (ventilatorDays != null) result.ventilatorDays = ventilatorDays;
    if (deviceDays != null) result.deviceDays.addEntries(deviceDays);
    if (meanLengthOfStayHours != null)
      result.meanLengthOfStayHours = meanLengthOfStayHours;
    if (closedEpisodes != null) result.closedEpisodes = closedEpisodes;
    if (meanDischargeDelayHours != null)
      result.meanDischargeDelayHours = meanDischargeDelayHours;
    if (delayedDischarges != null) result.delayedDischarges = delayedDischarges;
    return result;
  }

  UnitMetrics._();

  factory UnitMetrics.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnitMetrics.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnitMetrics',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(4, _omitFieldNames ? '' : 'admissions')
    ..aI(5, _omitFieldNames ? '' : 'discharges')
    ..aI(6, _omitFieldNames ? '' : 'deaths')
    ..aI(7, _omitFieldNames ? '' : 'bedDays')
    ..aI(8, _omitFieldNames ? '' : 'ventilatorDays')
    ..m<$core.String, $core.int>(9, _omitFieldNames ? '' : 'deviceDays',
        entryClassName: 'UnitMetrics.DeviceDaysEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('healthcare.icu.v1'))
    ..aD(10, _omitFieldNames ? '' : 'meanLengthOfStayHours')
    ..aI(11, _omitFieldNames ? '' : 'closedEpisodes')
    ..aD(12, _omitFieldNames ? '' : 'meanDischargeDelayHours')
    ..aI(13, _omitFieldNames ? '' : 'delayedDischarges')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnitMetrics clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnitMetrics copyWith(void Function(UnitMetrics) updates) =>
      super.copyWith((message) => updates(message as UnitMetrics))
          as UnitMetrics;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnitMetrics create() => UnitMetrics._();
  @$core.override
  UnitMetrics createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnitMetrics getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnitMetrics>(create);
  static UnitMetrics? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitId() => $_clearField(1);

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
  $core.int get admissions => $_getIZ(3);
  @$pb.TagNumber(4)
  set admissions($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAdmissions() => $_has(3);
  @$pb.TagNumber(4)
  void clearAdmissions() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get discharges => $_getIZ(4);
  @$pb.TagNumber(5)
  set discharges($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDischarges() => $_has(4);
  @$pb.TagNumber(5)
  void clearDischarges() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get deaths => $_getIZ(5);
  @$pb.TagNumber(6)
  set deaths($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDeaths() => $_has(5);
  @$pb.TagNumber(6)
  void clearDeaths() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get bedDays => $_getIZ(6);
  @$pb.TagNumber(7)
  set bedDays($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBedDays() => $_has(6);
  @$pb.TagNumber(7)
  void clearBedDays() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get ventilatorDays => $_getIZ(7);
  @$pb.TagNumber(8)
  set ventilatorDays($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVentilatorDays() => $_has(7);
  @$pb.TagNumber(8)
  void clearVentilatorDays() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbMap<$core.String, $core.int> get deviceDays => $_getMap(8);

  @$pb.TagNumber(10)
  $core.double get meanLengthOfStayHours => $_getN(9);
  @$pb.TagNumber(10)
  set meanLengthOfStayHours($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMeanLengthOfStayHours() => $_has(9);
  @$pb.TagNumber(10)
  void clearMeanLengthOfStayHours() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get closedEpisodes => $_getIZ(10);
  @$pb.TagNumber(11)
  set closedEpisodes($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasClosedEpisodes() => $_has(10);
  @$pb.TagNumber(11)
  void clearClosedEpisodes() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get meanDischargeDelayHours => $_getN(11);
  @$pb.TagNumber(12)
  set meanDischargeDelayHours($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMeanDischargeDelayHours() => $_has(11);
  @$pb.TagNumber(12)
  void clearMeanDischargeDelayHours() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get delayedDischarges => $_getIZ(12);
  @$pb.TagNumber(13)
  set delayedDischarges($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDelayedDischarges() => $_has(12);
  @$pb.TagNumber(13)
  void clearDelayedDischarges() => $_clearField(13);
}

class AdmitRequest extends $pb.GeneratedMessage {
  factory AdmitRequest({
    $core.String? encounterId,
    $core.String? patientId,
    $core.String? facilityId,
    $core.String? unitId,
    $core.String? bedId,
    AdmissionSource? source,
    $core.String? transferredFrom,
    $core.String? responsibleTeam,
    $core.String? responsibleClinician,
    $0.Timestamp? admittedAt,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (facilityId != null) result.facilityId = facilityId;
    if (unitId != null) result.unitId = unitId;
    if (bedId != null) result.bedId = bedId;
    if (source != null) result.source = source;
    if (transferredFrom != null) result.transferredFrom = transferredFrom;
    if (responsibleTeam != null) result.responsibleTeam = responsibleTeam;
    if (responsibleClinician != null)
      result.responsibleClinician = responsibleClinician;
    if (admittedAt != null) result.admittedAt = admittedAt;
    return result;
  }

  AdmitRequest._();

  factory AdmitRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdmitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdmitRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'unitId')
    ..aOS(5, _omitFieldNames ? '' : 'bedId')
    ..aE<AdmissionSource>(6, _omitFieldNames ? '' : 'source',
        enumValues: AdmissionSource.values)
    ..aOS(7, _omitFieldNames ? '' : 'transferredFrom')
    ..aOS(8, _omitFieldNames ? '' : 'responsibleTeam')
    ..aOS(9, _omitFieldNames ? '' : 'responsibleClinician')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'admittedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdmitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdmitRequest copyWith(void Function(AdmitRequest) updates) =>
      super.copyWith((message) => updates(message as AdmitRequest))
          as AdmitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdmitRequest create() => AdmitRequest._();
  @$core.override
  AdmitRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdmitRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdmitRequest>(create);
  static AdmitRequest? _defaultInstance;

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
  $core.String get unitId => $_getSZ(3);
  @$pb.TagNumber(4)
  set unitId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnitId() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnitId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get bedId => $_getSZ(4);
  @$pb.TagNumber(5)
  set bedId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBedId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBedId() => $_clearField(5);

  @$pb.TagNumber(6)
  AdmissionSource get source => $_getN(5);
  @$pb.TagNumber(6)
  set source(AdmissionSource value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSource() => $_has(5);
  @$pb.TagNumber(6)
  void clearSource() => $_clearField(6);

  /// Required when source is OTHER_ICU.
  @$pb.TagNumber(7)
  $core.String get transferredFrom => $_getSZ(6);
  @$pb.TagNumber(7)
  set transferredFrom($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTransferredFrom() => $_has(6);
  @$pb.TagNumber(7)
  void clearTransferredFrom() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get responsibleTeam => $_getSZ(7);
  @$pb.TagNumber(8)
  set responsibleTeam($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasResponsibleTeam() => $_has(7);
  @$pb.TagNumber(8)
  void clearResponsibleTeam() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get responsibleClinician => $_getSZ(8);
  @$pb.TagNumber(9)
  set responsibleClinician($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasResponsibleClinician() => $_has(8);
  @$pb.TagNumber(9)
  void clearResponsibleClinician() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get admittedAt => $_getN(9);
  @$pb.TagNumber(10)
  set admittedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasAdmittedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearAdmittedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureAdmittedAt() => $_ensure(9);
}

class AdmitResponse extends $pb.GeneratedMessage {
  factory AdmitResponse({
    IcuEpisode? episode,
  }) {
    final result = create();
    if (episode != null) result.episode = episode;
    return result;
  }

  AdmitResponse._();

  factory AdmitResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdmitResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdmitResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<IcuEpisode>(1, _omitFieldNames ? '' : 'episode',
        subBuilder: IcuEpisode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdmitResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdmitResponse copyWith(void Function(AdmitResponse) updates) =>
      super.copyWith((message) => updates(message as AdmitResponse))
          as AdmitResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdmitResponse create() => AdmitResponse._();
  @$core.override
  AdmitResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdmitResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdmitResponse>(create);
  static AdmitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  IcuEpisode get episode => $_getN(0);
  @$pb.TagNumber(1)
  set episode(IcuEpisode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisode() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisode() => $_clearField(1);
  @$pb.TagNumber(1)
  IcuEpisode ensureEpisode() => $_ensure(0);
}

class GetIcuEpisodeRequest extends $pb.GeneratedMessage {
  factory GetIcuEpisodeRequest({
    $core.String? episodeId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    return result;
  }

  GetIcuEpisodeRequest._();

  factory GetIcuEpisodeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetIcuEpisodeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetIcuEpisodeRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIcuEpisodeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIcuEpisodeRequest copyWith(void Function(GetIcuEpisodeRequest) updates) =>
      super.copyWith((message) => updates(message as GetIcuEpisodeRequest))
          as GetIcuEpisodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetIcuEpisodeRequest create() => GetIcuEpisodeRequest._();
  @$core.override
  GetIcuEpisodeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetIcuEpisodeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetIcuEpisodeRequest>(create);
  static GetIcuEpisodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);
}

class GetIcuEpisodeResponse extends $pb.GeneratedMessage {
  factory GetIcuEpisodeResponse({
    IcuEpisode? episode,
    $core.Iterable<Support>? support,
    $core.Iterable<InvasiveDevice>? devices,
    $core.Iterable<Infusion>? infusions,
    $core.Iterable<Goal>? openGoals,
    GoalsOfCare? ceiling,
    $core.bool? ceilingRestricted,
  }) {
    final result = create();
    if (episode != null) result.episode = episode;
    if (support != null) result.support.addAll(support);
    if (devices != null) result.devices.addAll(devices);
    if (infusions != null) result.infusions.addAll(infusions);
    if (openGoals != null) result.openGoals.addAll(openGoals);
    if (ceiling != null) result.ceiling = ceiling;
    if (ceilingRestricted != null) result.ceilingRestricted = ceilingRestricted;
    return result;
  }

  GetIcuEpisodeResponse._();

  factory GetIcuEpisodeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetIcuEpisodeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetIcuEpisodeResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<IcuEpisode>(1, _omitFieldNames ? '' : 'episode',
        subBuilder: IcuEpisode.create)
    ..pPM<Support>(2, _omitFieldNames ? '' : 'support',
        subBuilder: Support.create)
    ..pPM<InvasiveDevice>(3, _omitFieldNames ? '' : 'devices',
        subBuilder: InvasiveDevice.create)
    ..pPM<Infusion>(4, _omitFieldNames ? '' : 'infusions',
        subBuilder: Infusion.create)
    ..pPM<Goal>(5, _omitFieldNames ? '' : 'openGoals', subBuilder: Goal.create)
    ..aOM<GoalsOfCare>(6, _omitFieldNames ? '' : 'ceiling',
        subBuilder: GoalsOfCare.create)
    ..aOB(7, _omitFieldNames ? '' : 'ceilingRestricted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIcuEpisodeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIcuEpisodeResponse copyWith(
          void Function(GetIcuEpisodeResponse) updates) =>
      super.copyWith((message) => updates(message as GetIcuEpisodeResponse))
          as GetIcuEpisodeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetIcuEpisodeResponse create() => GetIcuEpisodeResponse._();
  @$core.override
  GetIcuEpisodeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetIcuEpisodeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetIcuEpisodeResponse>(create);
  static GetIcuEpisodeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  IcuEpisode get episode => $_getN(0);
  @$pb.TagNumber(1)
  set episode(IcuEpisode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisode() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisode() => $_clearField(1);
  @$pb.TagNumber(1)
  IcuEpisode ensureEpisode() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Support> get support => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<InvasiveDevice> get devices => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<Infusion> get infusions => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<Goal> get openGoals => $_getList(4);

  /// Present only for a caller who may read it.
  @$pb.TagNumber(6)
  GoalsOfCare get ceiling => $_getN(5);
  @$pb.TagNumber(6)
  set ceiling(GoalsOfCare value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCeiling() => $_has(5);
  @$pb.TagNumber(6)
  void clearCeiling() => $_clearField(6);
  @$pb.TagNumber(6)
  GoalsOfCare ensureCeiling() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.bool get ceilingRestricted => $_getBF(6);
  @$pb.TagNumber(7)
  set ceilingRestricted($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCeilingRestricted() => $_has(6);
  @$pb.TagNumber(7)
  void clearCeilingRestricted() => $_clearField(7);
}

class MoveBedRequest extends $pb.GeneratedMessage {
  factory MoveBedRequest({
    $core.String? episodeId,
    $core.String? bedId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (bedId != null) result.bedId = bedId;
    return result;
  }

  MoveBedRequest._();

  factory MoveBedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MoveBedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MoveBedRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'bedId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveBedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveBedRequest copyWith(void Function(MoveBedRequest) updates) =>
      super.copyWith((message) => updates(message as MoveBedRequest))
          as MoveBedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoveBedRequest create() => MoveBedRequest._();
  @$core.override
  MoveBedRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MoveBedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MoveBedRequest>(create);
  static MoveBedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get bedId => $_getSZ(1);
  @$pb.TagNumber(2)
  set bedId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBedId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBedId() => $_clearField(2);
}

class MoveBedResponse extends $pb.GeneratedMessage {
  factory MoveBedResponse({
    IcuEpisode? episode,
  }) {
    final result = create();
    if (episode != null) result.episode = episode;
    return result;
  }

  MoveBedResponse._();

  factory MoveBedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MoveBedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MoveBedResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<IcuEpisode>(1, _omitFieldNames ? '' : 'episode',
        subBuilder: IcuEpisode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveBedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveBedResponse copyWith(void Function(MoveBedResponse) updates) =>
      super.copyWith((message) => updates(message as MoveBedResponse))
          as MoveBedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoveBedResponse create() => MoveBedResponse._();
  @$core.override
  MoveBedResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MoveBedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MoveBedResponse>(create);
  static MoveBedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  IcuEpisode get episode => $_getN(0);
  @$pb.TagNumber(1)
  set episode(IcuEpisode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisode() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisode() => $_clearField(1);
  @$pb.TagNumber(1)
  IcuEpisode ensureEpisode() => $_ensure(0);
}

class DeclareReadyRequest extends $pb.GeneratedMessage {
  factory DeclareReadyRequest({
    $core.String? episodeId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    return result;
  }

  DeclareReadyRequest._();

  factory DeclareReadyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeclareReadyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeclareReadyRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeclareReadyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeclareReadyRequest copyWith(void Function(DeclareReadyRequest) updates) =>
      super.copyWith((message) => updates(message as DeclareReadyRequest))
          as DeclareReadyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeclareReadyRequest create() => DeclareReadyRequest._();
  @$core.override
  DeclareReadyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeclareReadyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeclareReadyRequest>(create);
  static DeclareReadyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);
}

class DeclareReadyResponse extends $pb.GeneratedMessage {
  factory DeclareReadyResponse({
    IcuEpisode? episode,
  }) {
    final result = create();
    if (episode != null) result.episode = episode;
    return result;
  }

  DeclareReadyResponse._();

  factory DeclareReadyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeclareReadyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeclareReadyResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<IcuEpisode>(1, _omitFieldNames ? '' : 'episode',
        subBuilder: IcuEpisode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeclareReadyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeclareReadyResponse copyWith(void Function(DeclareReadyResponse) updates) =>
      super.copyWith((message) => updates(message as DeclareReadyResponse))
          as DeclareReadyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeclareReadyResponse create() => DeclareReadyResponse._();
  @$core.override
  DeclareReadyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeclareReadyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeclareReadyResponse>(create);
  static DeclareReadyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  IcuEpisode get episode => $_getN(0);
  @$pb.TagNumber(1)
  set episode(IcuEpisode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisode() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisode() => $_clearField(1);
  @$pb.TagNumber(1)
  IcuEpisode ensureEpisode() => $_ensure(0);
}

class DischargeRequest extends $pb.GeneratedMessage {
  factory DischargeRequest({
    $core.String? episodeId,
    EpisodeOutcome? outcome,
    $core.String? note,
    $core.bool? medicationsReconciled,
    $core.bool? devicesListed,
    $core.bool? tasksHandedOver,
    $core.bool? summaryWritten,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (outcome != null) result.outcome = outcome;
    if (note != null) result.note = note;
    if (medicationsReconciled != null)
      result.medicationsReconciled = medicationsReconciled;
    if (devicesListed != null) result.devicesListed = devicesListed;
    if (tasksHandedOver != null) result.tasksHandedOver = tasksHandedOver;
    if (summaryWritten != null) result.summaryWritten = summaryWritten;
    return result;
  }

  DischargeRequest._();

  factory DischargeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DischargeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DischargeRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aE<EpisodeOutcome>(2, _omitFieldNames ? '' : 'outcome',
        enumValues: EpisodeOutcome.values)
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..aOB(4, _omitFieldNames ? '' : 'medicationsReconciled')
    ..aOB(5, _omitFieldNames ? '' : 'devicesListed')
    ..aOB(6, _omitFieldNames ? '' : 'tasksHandedOver')
    ..aOB(7, _omitFieldNames ? '' : 'summaryWritten')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DischargeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DischargeRequest copyWith(void Function(DischargeRequest) updates) =>
      super.copyWith((message) => updates(message as DischargeRequest))
          as DischargeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DischargeRequest create() => DischargeRequest._();
  @$core.override
  DischargeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DischargeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DischargeRequest>(create);
  static DischargeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  EpisodeOutcome get outcome => $_getN(1);
  @$pb.TagNumber(2)
  set outcome(EpisodeOutcome value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOutcome() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutcome() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);

  /// The caller's assertion about the handover (SRS-ICU-016). Passed rather
  /// than inferred: the drug chart and the task list belong to other contexts,
  /// and a unit deciding for itself would be a second authority on them.
  @$pb.TagNumber(4)
  $core.bool get medicationsReconciled => $_getBF(3);
  @$pb.TagNumber(4)
  set medicationsReconciled($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMedicationsReconciled() => $_has(3);
  @$pb.TagNumber(4)
  void clearMedicationsReconciled() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get devicesListed => $_getBF(4);
  @$pb.TagNumber(5)
  set devicesListed($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDevicesListed() => $_has(4);
  @$pb.TagNumber(5)
  void clearDevicesListed() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get tasksHandedOver => $_getBF(5);
  @$pb.TagNumber(6)
  set tasksHandedOver($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTasksHandedOver() => $_has(5);
  @$pb.TagNumber(6)
  void clearTasksHandedOver() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get summaryWritten => $_getBF(6);
  @$pb.TagNumber(7)
  set summaryWritten($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSummaryWritten() => $_has(6);
  @$pb.TagNumber(7)
  void clearSummaryWritten() => $_clearField(7);
}

class DischargeResponse extends $pb.GeneratedMessage {
  factory DischargeResponse({
    IcuEpisode? episode,
  }) {
    final result = create();
    if (episode != null) result.episode = episode;
    return result;
  }

  DischargeResponse._();

  factory DischargeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DischargeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DischargeResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<IcuEpisode>(1, _omitFieldNames ? '' : 'episode',
        subBuilder: IcuEpisode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DischargeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DischargeResponse copyWith(void Function(DischargeResponse) updates) =>
      super.copyWith((message) => updates(message as DischargeResponse))
          as DischargeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DischargeResponse create() => DischargeResponse._();
  @$core.override
  DischargeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DischargeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DischargeResponse>(create);
  static DischargeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  IcuEpisode get episode => $_getN(0);
  @$pb.TagNumber(1)
  set episode(IcuEpisode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisode() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisode() => $_clearField(1);
  @$pb.TagNumber(1)
  IcuEpisode ensureEpisode() => $_ensure(0);
}

class ChartValueRequest extends $pb.GeneratedMessage {
  factory ChartValueRequest({
    $core.String? episodeId,
    $core.String? codeSystem,
    $core.String? code,
    $core.String? display,
    $core.String? dimension,
    $core.double? value,
    $core.String? unit,
    ObservationSource? source,
    DeviceSource? device,
    $0.Timestamp? observedAt,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (codeSystem != null) result.codeSystem = codeSystem;
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (dimension != null) result.dimension = dimension;
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (source != null) result.source = source;
    if (device != null) result.device = device;
    if (observedAt != null) result.observedAt = observedAt;
    return result;
  }

  ChartValueRequest._();

  factory ChartValueRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChartValueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChartValueRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'codeSystem')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'display')
    ..aOS(5, _omitFieldNames ? '' : 'dimension')
    ..aD(6, _omitFieldNames ? '' : 'value')
    ..aOS(7, _omitFieldNames ? '' : 'unit')
    ..aE<ObservationSource>(8, _omitFieldNames ? '' : 'source',
        enumValues: ObservationSource.values)
    ..aOM<DeviceSource>(9, _omitFieldNames ? '' : 'device',
        subBuilder: DeviceSource.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartValueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartValueRequest copyWith(void Function(ChartValueRequest) updates) =>
      super.copyWith((message) => updates(message as ChartValueRequest))
          as ChartValueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChartValueRequest create() => ChartValueRequest._();
  @$core.override
  ChartValueRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChartValueRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChartValueRequest>(create);
  static ChartValueRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get codeSystem => $_getSZ(1);
  @$pb.TagNumber(2)
  set codeSystem($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCodeSystem() => $_has(1);
  @$pb.TagNumber(2)
  void clearCodeSystem() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get display => $_getSZ(3);
  @$pb.TagNumber(4)
  set display($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisplay() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplay() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get dimension => $_getSZ(4);
  @$pb.TagNumber(5)
  set dimension($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDimension() => $_has(4);
  @$pb.TagNumber(5)
  void clearDimension() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get value => $_getN(5);
  @$pb.TagNumber(6)
  set value($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearValue() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get unit => $_getSZ(6);
  @$pb.TagNumber(7)
  set unit($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUnit() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnit() => $_clearField(7);

  @$pb.TagNumber(8)
  ObservationSource get source => $_getN(7);
  @$pb.TagNumber(8)
  set source(ObservationSource value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSource() => $_has(7);
  @$pb.TagNumber(8)
  void clearSource() => $_clearField(8);

  @$pb.TagNumber(9)
  DeviceSource get device => $_getN(8);
  @$pb.TagNumber(9)
  set device(DeviceSource value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasDevice() => $_has(8);
  @$pb.TagNumber(9)
  void clearDevice() => $_clearField(9);
  @$pb.TagNumber(9)
  DeviceSource ensureDevice() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get observedAt => $_getN(9);
  @$pb.TagNumber(10)
  set observedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasObservedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearObservedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureObservedAt() => $_ensure(9);
}

class ChartValueResponse extends $pb.GeneratedMessage {
  factory ChartValueResponse({
    Observation? observation,
  }) {
    final result = create();
    if (observation != null) result.observation = observation;
    return result;
  }

  ChartValueResponse._();

  factory ChartValueResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChartValueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChartValueResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<Observation>(1, _omitFieldNames ? '' : 'observation',
        subBuilder: Observation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartValueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartValueResponse copyWith(void Function(ChartValueResponse) updates) =>
      super.copyWith((message) => updates(message as ChartValueResponse))
          as ChartValueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChartValueResponse create() => ChartValueResponse._();
  @$core.override
  ChartValueResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChartValueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChartValueResponse>(create);
  static ChartValueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Observation get observation => $_getN(0);
  @$pb.TagNumber(1)
  set observation(Observation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasObservation() => $_has(0);
  @$pb.TagNumber(1)
  void clearObservation() => $_clearField(1);
  @$pb.TagNumber(1)
  Observation ensureObservation() => $_ensure(0);
}

class DecideReadingRequest extends $pb.GeneratedMessage {
  factory DecideReadingRequest({
    $core.String? observationId,
    $core.bool? accept,
    $core.String? note,
  }) {
    final result = create();
    if (observationId != null) result.observationId = observationId;
    if (accept != null) result.accept = accept;
    if (note != null) result.note = note;
    return result;
  }

  DecideReadingRequest._();

  factory DecideReadingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DecideReadingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DecideReadingRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'observationId')
    ..aOB(2, _omitFieldNames ? '' : 'accept')
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecideReadingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecideReadingRequest copyWith(void Function(DecideReadingRequest) updates) =>
      super.copyWith((message) => updates(message as DecideReadingRequest))
          as DecideReadingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DecideReadingRequest create() => DecideReadingRequest._();
  @$core.override
  DecideReadingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DecideReadingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DecideReadingRequest>(create);
  static DecideReadingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get observationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set observationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasObservationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearObservationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get accept => $_getBF(1);
  @$pb.TagNumber(2)
  set accept($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccept() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccept() => $_clearField(2);

  /// Required to reject. A rejection with no reason is an artefact nobody can
  /// learn from.
  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);
}

class DecideReadingResponse extends $pb.GeneratedMessage {
  factory DecideReadingResponse({
    Observation? observation,
  }) {
    final result = create();
    if (observation != null) result.observation = observation;
    return result;
  }

  DecideReadingResponse._();

  factory DecideReadingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DecideReadingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DecideReadingResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<Observation>(1, _omitFieldNames ? '' : 'observation',
        subBuilder: Observation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecideReadingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecideReadingResponse copyWith(
          void Function(DecideReadingResponse) updates) =>
      super.copyWith((message) => updates(message as DecideReadingResponse))
          as DecideReadingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DecideReadingResponse create() => DecideReadingResponse._();
  @$core.override
  DecideReadingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DecideReadingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DecideReadingResponse>(create);
  static DecideReadingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Observation get observation => $_getN(0);
  @$pb.TagNumber(1)
  set observation(Observation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasObservation() => $_has(0);
  @$pb.TagNumber(1)
  void clearObservation() => $_clearField(1);
  @$pb.TagNumber(1)
  Observation ensureObservation() => $_ensure(0);
}

class ListFlowsheetRequest extends $pb.GeneratedMessage {
  factory ListFlowsheetRequest({
    $core.String? episodeId,
    $0.Timestamp? since,
    $core.int? pageSize,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (since != null) result.since = since;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListFlowsheetRequest._();

  factory ListFlowsheetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFlowsheetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFlowsheetRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'since',
        subBuilder: $0.Timestamp.create)
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFlowsheetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFlowsheetRequest copyWith(void Function(ListFlowsheetRequest) updates) =>
      super.copyWith((message) => updates(message as ListFlowsheetRequest))
          as ListFlowsheetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFlowsheetRequest create() => ListFlowsheetRequest._();
  @$core.override
  ListFlowsheetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFlowsheetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFlowsheetRequest>(create);
  static ListFlowsheetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get since => $_getN(1);
  @$pb.TagNumber(2)
  set since($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSince() => $_has(1);
  @$pb.TagNumber(2)
  void clearSince() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureSince() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListFlowsheetResponse extends $pb.GeneratedMessage {
  factory ListFlowsheetResponse({
    $core.Iterable<Observation>? observations,
  }) {
    final result = create();
    if (observations != null) result.observations.addAll(observations);
    return result;
  }

  ListFlowsheetResponse._();

  factory ListFlowsheetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFlowsheetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFlowsheetResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..pPM<Observation>(1, _omitFieldNames ? '' : 'observations',
        subBuilder: Observation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFlowsheetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFlowsheetResponse copyWith(
          void Function(ListFlowsheetResponse) updates) =>
      super.copyWith((message) => updates(message as ListFlowsheetResponse))
          as ListFlowsheetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFlowsheetResponse create() => ListFlowsheetResponse._();
  @$core.override
  ListFlowsheetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFlowsheetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFlowsheetResponse>(create);
  static ListFlowsheetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Observation> get observations => $_getList(0);
}

class ListPendingReadingsRequest extends $pb.GeneratedMessage {
  factory ListPendingReadingsRequest({
    $core.String? episodeId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListPendingReadingsRequest._();

  factory ListPendingReadingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPendingReadingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPendingReadingsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPendingReadingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPendingReadingsRequest copyWith(
          void Function(ListPendingReadingsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListPendingReadingsRequest))
          as ListPendingReadingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPendingReadingsRequest create() => ListPendingReadingsRequest._();
  @$core.override
  ListPendingReadingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPendingReadingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPendingReadingsRequest>(create);
  static ListPendingReadingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListPendingReadingsResponse extends $pb.GeneratedMessage {
  factory ListPendingReadingsResponse({
    $core.Iterable<Observation>? observations,
  }) {
    final result = create();
    if (observations != null) result.observations.addAll(observations);
    return result;
  }

  ListPendingReadingsResponse._();

  factory ListPendingReadingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPendingReadingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPendingReadingsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..pPM<Observation>(1, _omitFieldNames ? '' : 'observations',
        subBuilder: Observation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPendingReadingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPendingReadingsResponse copyWith(
          void Function(ListPendingReadingsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListPendingReadingsResponse))
          as ListPendingReadingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPendingReadingsResponse create() =>
      ListPendingReadingsResponse._();
  @$core.override
  ListPendingReadingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPendingReadingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPendingReadingsResponse>(create);
  static ListPendingReadingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Observation> get observations => $_getList(0);
}

class RecordBalanceRequest extends $pb.GeneratedMessage {
  factory RecordBalanceRequest({
    $core.String? episodeId,
    $core.String? direction,
    $core.String? route,
    $core.double? volume,
    $core.String? unit,
    $0.Timestamp? occurredAt,
    $core.String? corrects,
    $core.String? correctionReason,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (direction != null) result.direction = direction;
    if (route != null) result.route = route;
    if (volume != null) result.volume = volume;
    if (unit != null) result.unit = unit;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (corrects != null) result.corrects = corrects;
    if (correctionReason != null) result.correctionReason = correctionReason;
    return result;
  }

  RecordBalanceRequest._();

  factory RecordBalanceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordBalanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordBalanceRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'direction')
    ..aOS(3, _omitFieldNames ? '' : 'route')
    ..aD(4, _omitFieldNames ? '' : 'volume')
    ..aOS(5, _omitFieldNames ? '' : 'unit')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'corrects')
    ..aOS(8, _omitFieldNames ? '' : 'correctionReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordBalanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordBalanceRequest copyWith(void Function(RecordBalanceRequest) updates) =>
      super.copyWith((message) => updates(message as RecordBalanceRequest))
          as RecordBalanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordBalanceRequest create() => RecordBalanceRequest._();
  @$core.override
  RecordBalanceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordBalanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordBalanceRequest>(create);
  static RecordBalanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get direction => $_getSZ(1);
  @$pb.TagNumber(2)
  set direction($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDirection() => $_has(1);
  @$pb.TagNumber(2)
  void clearDirection() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get route => $_getSZ(2);
  @$pb.TagNumber(3)
  set route($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRoute() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoute() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get volume => $_getN(3);
  @$pb.TagNumber(4)
  set volume($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVolume() => $_has(3);
  @$pb.TagNumber(4)
  void clearVolume() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get unit => $_getSZ(4);
  @$pb.TagNumber(5)
  set unit($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnit() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnit() => $_clearField(5);

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

  /// Makes this entry a correction of another. The reason is required.
  @$pb.TagNumber(7)
  $core.String get corrects => $_getSZ(6);
  @$pb.TagNumber(7)
  set corrects($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCorrects() => $_has(6);
  @$pb.TagNumber(7)
  void clearCorrects() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get correctionReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set correctionReason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCorrectionReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearCorrectionReason() => $_clearField(8);
}

class RecordBalanceResponse extends $pb.GeneratedMessage {
  factory RecordBalanceResponse({
    BalanceEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  RecordBalanceResponse._();

  factory RecordBalanceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordBalanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordBalanceResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<BalanceEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: BalanceEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordBalanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordBalanceResponse copyWith(
          void Function(RecordBalanceResponse) updates) =>
      super.copyWith((message) => updates(message as RecordBalanceResponse))
          as RecordBalanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordBalanceResponse create() => RecordBalanceResponse._();
  @$core.override
  RecordBalanceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordBalanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordBalanceResponse>(create);
  static RecordBalanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BalanceEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(BalanceEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  BalanceEntry ensureEntry() => $_ensure(0);
}

class GetBalanceRequest extends $pb.GeneratedMessage {
  factory GetBalanceRequest({
    $core.String? episodeId,
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  GetBalanceRequest._();

  factory GetBalanceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBalanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBalanceRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBalanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBalanceRequest copyWith(void Function(GetBalanceRequest) updates) =>
      super.copyWith((message) => updates(message as GetBalanceRequest))
          as GetBalanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBalanceRequest create() => GetBalanceRequest._();
  @$core.override
  GetBalanceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBalanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBalanceRequest>(create);
  static GetBalanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

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

class GetBalanceResponse extends $pb.GeneratedMessage {
  factory GetBalanceResponse({
    Balance? total,
    $core.Iterable<Balance>? hourly,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (hourly != null) result.hourly.addAll(hourly);
    return result;
  }

  GetBalanceResponse._();

  factory GetBalanceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBalanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBalanceResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<Balance>(1, _omitFieldNames ? '' : 'total',
        subBuilder: Balance.create)
    ..pPM<Balance>(2, _omitFieldNames ? '' : 'hourly',
        subBuilder: Balance.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBalanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBalanceResponse copyWith(void Function(GetBalanceResponse) updates) =>
      super.copyWith((message) => updates(message as GetBalanceResponse))
          as GetBalanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBalanceResponse create() => GetBalanceResponse._();
  @$core.override
  GetBalanceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBalanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBalanceResponse>(create);
  static GetBalanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Balance get total => $_getN(0);
  @$pb.TagNumber(1)
  set total(Balance value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);
  @$pb.TagNumber(1)
  Balance ensureTotal() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Balance> get hourly => $_getList(1);
}

class StartSupportRequest extends $pb.GeneratedMessage {
  factory StartSupportRequest({
    $core.String? episodeId,
    SupportKind? kind,
    $core.String? label,
    $core.String? modality,
    $0.Timestamp? startedAt,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (kind != null) result.kind = kind;
    if (label != null) result.label = label;
    if (modality != null) result.modality = modality;
    if (startedAt != null) result.startedAt = startedAt;
    return result;
  }

  StartSupportRequest._();

  factory StartSupportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartSupportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartSupportRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aE<SupportKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: SupportKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'label')
    ..aOS(4, _omitFieldNames ? '' : 'modality')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartSupportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartSupportRequest copyWith(void Function(StartSupportRequest) updates) =>
      super.copyWith((message) => updates(message as StartSupportRequest))
          as StartSupportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartSupportRequest create() => StartSupportRequest._();
  @$core.override
  StartSupportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartSupportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartSupportRequest>(create);
  static StartSupportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  SupportKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(SupportKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get label => $_getSZ(2);
  @$pb.TagNumber(3)
  set label($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLabel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLabel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get modality => $_getSZ(3);
  @$pb.TagNumber(4)
  set modality($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasModality() => $_has(3);
  @$pb.TagNumber(4)
  void clearModality() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get startedAt => $_getN(4);
  @$pb.TagNumber(5)
  set startedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStartedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureStartedAt() => $_ensure(4);
}

class StartSupportResponse extends $pb.GeneratedMessage {
  factory StartSupportResponse({
    Support? support,
  }) {
    final result = create();
    if (support != null) result.support = support;
    return result;
  }

  StartSupportResponse._();

  factory StartSupportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartSupportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartSupportResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<Support>(1, _omitFieldNames ? '' : 'support',
        subBuilder: Support.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartSupportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartSupportResponse copyWith(void Function(StartSupportResponse) updates) =>
      super.copyWith((message) => updates(message as StartSupportResponse))
          as StartSupportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartSupportResponse create() => StartSupportResponse._();
  @$core.override
  StartSupportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartSupportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartSupportResponse>(create);
  static StartSupportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Support get support => $_getN(0);
  @$pb.TagNumber(1)
  set support(Support value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSupport() => $_has(0);
  @$pb.TagNumber(1)
  void clearSupport() => $_clearField(1);
  @$pb.TagNumber(1)
  Support ensureSupport() => $_ensure(0);
}

class StopSupportRequest extends $pb.GeneratedMessage {
  factory StopSupportRequest({
    $core.String? supportId,
    $core.String? note,
    $0.Timestamp? stoppedAt,
  }) {
    final result = create();
    if (supportId != null) result.supportId = supportId;
    if (note != null) result.note = note;
    if (stoppedAt != null) result.stoppedAt = stoppedAt;
    return result;
  }

  StopSupportRequest._();

  factory StopSupportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopSupportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopSupportRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'supportId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'stoppedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopSupportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopSupportRequest copyWith(void Function(StopSupportRequest) updates) =>
      super.copyWith((message) => updates(message as StopSupportRequest))
          as StopSupportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopSupportRequest create() => StopSupportRequest._();
  @$core.override
  StopSupportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StopSupportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopSupportRequest>(create);
  static StopSupportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get supportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set supportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSupportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSupportId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get stoppedAt => $_getN(2);
  @$pb.TagNumber(3)
  set stoppedAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStoppedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearStoppedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureStoppedAt() => $_ensure(2);
}

class StopSupportResponse extends $pb.GeneratedMessage {
  factory StopSupportResponse() => create();

  StopSupportResponse._();

  factory StopSupportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopSupportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopSupportResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopSupportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopSupportResponse copyWith(void Function(StopSupportResponse) updates) =>
      super.copyWith((message) => updates(message as StopSupportResponse))
          as StopSupportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopSupportResponse create() => StopSupportResponse._();
  @$core.override
  StopSupportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StopSupportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopSupportResponse>(create);
  static StopSupportResponse? _defaultInstance;
}

class ListSupportRequest extends $pb.GeneratedMessage {
  factory ListSupportRequest({
    $core.String? episodeId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    return result;
  }

  ListSupportRequest._();

  factory ListSupportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSupportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSupportRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSupportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSupportRequest copyWith(void Function(ListSupportRequest) updates) =>
      super.copyWith((message) => updates(message as ListSupportRequest))
          as ListSupportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSupportRequest create() => ListSupportRequest._();
  @$core.override
  ListSupportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSupportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSupportRequest>(create);
  static ListSupportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);
}

class ListSupportResponse extends $pb.GeneratedMessage {
  factory ListSupportResponse({
    $core.Iterable<Support>? support,
  }) {
    final result = create();
    if (support != null) result.support.addAll(support);
    return result;
  }

  ListSupportResponse._();

  factory ListSupportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSupportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSupportResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..pPM<Support>(1, _omitFieldNames ? '' : 'support',
        subBuilder: Support.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSupportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSupportResponse copyWith(void Function(ListSupportResponse) updates) =>
      super.copyWith((message) => updates(message as ListSupportResponse))
          as ListSupportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSupportResponse create() => ListSupportResponse._();
  @$core.override
  ListSupportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSupportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSupportResponse>(create);
  static ListSupportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Support> get support => $_getList(0);
}

class RecordVentSettingRequest extends $pb.GeneratedMessage {
  factory RecordVentSettingRequest({
    $core.String? episodeId,
    $core.String? supportId,
    $core.String? mode,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? parameters,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? measured,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? units,
    $core.String? deviceId,
    $0.Timestamp? effectiveAt,
    $core.String? changeReason,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (supportId != null) result.supportId = supportId;
    if (mode != null) result.mode = mode;
    if (parameters != null) result.parameters.addEntries(parameters);
    if (measured != null) result.measured.addEntries(measured);
    if (units != null) result.units.addEntries(units);
    if (deviceId != null) result.deviceId = deviceId;
    if (effectiveAt != null) result.effectiveAt = effectiveAt;
    if (changeReason != null) result.changeReason = changeReason;
    return result;
  }

  RecordVentSettingRequest._();

  factory RecordVentSettingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordVentSettingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordVentSettingRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'supportId')
    ..aOS(3, _omitFieldNames ? '' : 'mode')
    ..m<$core.String, $core.double>(4, _omitFieldNames ? '' : 'parameters',
        entryClassName: 'RecordVentSettingRequest.ParametersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('healthcare.icu.v1'))
    ..m<$core.String, $core.double>(5, _omitFieldNames ? '' : 'measured',
        entryClassName: 'RecordVentSettingRequest.MeasuredEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('healthcare.icu.v1'))
    ..m<$core.String, $core.String>(6, _omitFieldNames ? '' : 'units',
        entryClassName: 'RecordVentSettingRequest.UnitsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('healthcare.icu.v1'))
    ..aOS(7, _omitFieldNames ? '' : 'deviceId')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'effectiveAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'changeReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordVentSettingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordVentSettingRequest copyWith(
          void Function(RecordVentSettingRequest) updates) =>
      super.copyWith((message) => updates(message as RecordVentSettingRequest))
          as RecordVentSettingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordVentSettingRequest create() => RecordVentSettingRequest._();
  @$core.override
  RecordVentSettingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordVentSettingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordVentSettingRequest>(create);
  static RecordVentSettingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get supportId => $_getSZ(1);
  @$pb.TagNumber(2)
  set supportId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSupportId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSupportId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get mode => $_getSZ(2);
  @$pb.TagNumber(3)
  set mode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.double> get parameters => $_getMap(3);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.double> get measured => $_getMap(4);

  @$pb.TagNumber(6)
  $pb.PbMap<$core.String, $core.String> get units => $_getMap(5);

  @$pb.TagNumber(7)
  $core.String get deviceId => $_getSZ(6);
  @$pb.TagNumber(7)
  set deviceId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDeviceId() => $_has(6);
  @$pb.TagNumber(7)
  void clearDeviceId() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get effectiveAt => $_getN(7);
  @$pb.TagNumber(8)
  set effectiveAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasEffectiveAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearEffectiveAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureEffectiveAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get changeReason => $_getSZ(8);
  @$pb.TagNumber(9)
  set changeReason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasChangeReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearChangeReason() => $_clearField(9);
}

class RecordVentSettingResponse extends $pb.GeneratedMessage {
  factory RecordVentSettingResponse({
    VentSetting? setting,
  }) {
    final result = create();
    if (setting != null) result.setting = setting;
    return result;
  }

  RecordVentSettingResponse._();

  factory RecordVentSettingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordVentSettingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordVentSettingResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<VentSetting>(1, _omitFieldNames ? '' : 'setting',
        subBuilder: VentSetting.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordVentSettingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordVentSettingResponse copyWith(
          void Function(RecordVentSettingResponse) updates) =>
      super.copyWith((message) => updates(message as RecordVentSettingResponse))
          as RecordVentSettingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordVentSettingResponse create() => RecordVentSettingResponse._();
  @$core.override
  RecordVentSettingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordVentSettingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordVentSettingResponse>(create);
  static RecordVentSettingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  VentSetting get setting => $_getN(0);
  @$pb.TagNumber(1)
  set setting(VentSetting value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSetting() => $_has(0);
  @$pb.TagNumber(1)
  void clearSetting() => $_clearField(1);
  @$pb.TagNumber(1)
  VentSetting ensureSetting() => $_ensure(0);
}

class GetVentTimelineRequest extends $pb.GeneratedMessage {
  factory GetVentTimelineRequest({
    $core.String? episodeId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    return result;
  }

  GetVentTimelineRequest._();

  factory GetVentTimelineRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetVentTimelineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetVentTimelineRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVentTimelineRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVentTimelineRequest copyWith(
          void Function(GetVentTimelineRequest) updates) =>
      super.copyWith((message) => updates(message as GetVentTimelineRequest))
          as GetVentTimelineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetVentTimelineRequest create() => GetVentTimelineRequest._();
  @$core.override
  GetVentTimelineRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetVentTimelineRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetVentTimelineRequest>(create);
  static GetVentTimelineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);
}

class GetVentTimelineResponse extends $pb.GeneratedMessage {
  factory GetVentTimelineResponse({
    $core.Iterable<VentSetting>? settings,
  }) {
    final result = create();
    if (settings != null) result.settings.addAll(settings);
    return result;
  }

  GetVentTimelineResponse._();

  factory GetVentTimelineResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetVentTimelineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetVentTimelineResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..pPM<VentSetting>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: VentSetting.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVentTimelineResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVentTimelineResponse copyWith(
          void Function(GetVentTimelineResponse) updates) =>
      super.copyWith((message) => updates(message as GetVentTimelineResponse))
          as GetVentTimelineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetVentTimelineResponse create() => GetVentTimelineResponse._();
  @$core.override
  GetVentTimelineResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetVentTimelineResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetVentTimelineResponse>(create);
  static GetVentTimelineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<VentSetting> get settings => $_getList(0);
}

class StartInfusionRequest extends $pb.GeneratedMessage {
  factory StartInfusionRequest({
    $core.String? episodeId,
    $core.String? prescriptionId,
    $core.String? drugCode,
    $core.String? drugDisplay,
    $core.double? concentrationAmount,
    $core.String? concentrationUnit,
    $core.double? concentrationVolume,
    $core.String? doseUnit,
    $core.double? weightKg,
    $0.Timestamp? startedAt,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (prescriptionId != null) result.prescriptionId = prescriptionId;
    if (drugCode != null) result.drugCode = drugCode;
    if (drugDisplay != null) result.drugDisplay = drugDisplay;
    if (concentrationAmount != null)
      result.concentrationAmount = concentrationAmount;
    if (concentrationUnit != null) result.concentrationUnit = concentrationUnit;
    if (concentrationVolume != null)
      result.concentrationVolume = concentrationVolume;
    if (doseUnit != null) result.doseUnit = doseUnit;
    if (weightKg != null) result.weightKg = weightKg;
    if (startedAt != null) result.startedAt = startedAt;
    return result;
  }

  StartInfusionRequest._();

  factory StartInfusionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartInfusionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartInfusionRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'prescriptionId')
    ..aOS(3, _omitFieldNames ? '' : 'drugCode')
    ..aOS(4, _omitFieldNames ? '' : 'drugDisplay')
    ..aD(5, _omitFieldNames ? '' : 'concentrationAmount')
    ..aOS(6, _omitFieldNames ? '' : 'concentrationUnit')
    ..aD(7, _omitFieldNames ? '' : 'concentrationVolume')
    ..aOS(8, _omitFieldNames ? '' : 'doseUnit')
    ..aD(9, _omitFieldNames ? '' : 'weightKg')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartInfusionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartInfusionRequest copyWith(void Function(StartInfusionRequest) updates) =>
      super.copyWith((message) => updates(message as StartInfusionRequest))
          as StartInfusionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartInfusionRequest create() => StartInfusionRequest._();
  @$core.override
  StartInfusionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartInfusionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartInfusionRequest>(create);
  static StartInfusionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get prescriptionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set prescriptionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrescriptionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrescriptionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get drugCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set drugCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDrugCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearDrugCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get drugDisplay => $_getSZ(3);
  @$pb.TagNumber(4)
  set drugDisplay($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDrugDisplay() => $_has(3);
  @$pb.TagNumber(4)
  void clearDrugDisplay() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get concentrationAmount => $_getN(4);
  @$pb.TagNumber(5)
  set concentrationAmount($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConcentrationAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearConcentrationAmount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get concentrationUnit => $_getSZ(5);
  @$pb.TagNumber(6)
  set concentrationUnit($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasConcentrationUnit() => $_has(5);
  @$pb.TagNumber(6)
  void clearConcentrationUnit() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get concentrationVolume => $_getN(6);
  @$pb.TagNumber(7)
  set concentrationVolume($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasConcentrationVolume() => $_has(6);
  @$pb.TagNumber(7)
  void clearConcentrationVolume() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get doseUnit => $_getSZ(7);
  @$pb.TagNumber(8)
  set doseUnit($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDoseUnit() => $_has(7);
  @$pb.TagNumber(8)
  void clearDoseUnit() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get weightKg => $_getN(8);
  @$pb.TagNumber(9)
  set weightKg($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasWeightKg() => $_has(8);
  @$pb.TagNumber(9)
  void clearWeightKg() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get startedAt => $_getN(9);
  @$pb.TagNumber(10)
  set startedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStartedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearStartedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureStartedAt() => $_ensure(9);
}

class StartInfusionResponse extends $pb.GeneratedMessage {
  factory StartInfusionResponse({
    Infusion? infusion,
  }) {
    final result = create();
    if (infusion != null) result.infusion = infusion;
    return result;
  }

  StartInfusionResponse._();

  factory StartInfusionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartInfusionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartInfusionResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<Infusion>(1, _omitFieldNames ? '' : 'infusion',
        subBuilder: Infusion.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartInfusionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartInfusionResponse copyWith(
          void Function(StartInfusionResponse) updates) =>
      super.copyWith((message) => updates(message as StartInfusionResponse))
          as StartInfusionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartInfusionResponse create() => StartInfusionResponse._();
  @$core.override
  StartInfusionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartInfusionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartInfusionResponse>(create);
  static StartInfusionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Infusion get infusion => $_getN(0);
  @$pb.TagNumber(1)
  set infusion(Infusion value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInfusion() => $_has(0);
  @$pb.TagNumber(1)
  void clearInfusion() => $_clearField(1);
  @$pb.TagNumber(1)
  Infusion ensureInfusion() => $_ensure(0);
}

class TitrateRequest extends $pb.GeneratedMessage {
  factory TitrateRequest({
    $core.String? infusionId,
    $core.double? rate,
    $core.String? rateUnit,
    $core.double? dose,
    $0.Timestamp? effectiveAt,
    $core.String? deviceId,
    $core.String? reason,
  }) {
    final result = create();
    if (infusionId != null) result.infusionId = infusionId;
    if (rate != null) result.rate = rate;
    if (rateUnit != null) result.rateUnit = rateUnit;
    if (dose != null) result.dose = dose;
    if (effectiveAt != null) result.effectiveAt = effectiveAt;
    if (deviceId != null) result.deviceId = deviceId;
    if (reason != null) result.reason = reason;
    return result;
  }

  TitrateRequest._();

  factory TitrateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TitrateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TitrateRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'infusionId')
    ..aD(2, _omitFieldNames ? '' : 'rate')
    ..aOS(3, _omitFieldNames ? '' : 'rateUnit')
    ..aD(4, _omitFieldNames ? '' : 'dose')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'effectiveAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'deviceId')
    ..aOS(7, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TitrateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TitrateRequest copyWith(void Function(TitrateRequest) updates) =>
      super.copyWith((message) => updates(message as TitrateRequest))
          as TitrateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TitrateRequest create() => TitrateRequest._();
  @$core.override
  TitrateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TitrateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TitrateRequest>(create);
  static TitrateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get infusionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set infusionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInfusionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInfusionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get rate => $_getN(1);
  @$pb.TagNumber(2)
  set rate($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRate() => $_has(1);
  @$pb.TagNumber(2)
  void clearRate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get rateUnit => $_getSZ(2);
  @$pb.TagNumber(3)
  set rateUnit($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRateUnit() => $_has(2);
  @$pb.TagNumber(3)
  void clearRateUnit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get dose => $_getN(3);
  @$pb.TagNumber(4)
  set dose($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDose() => $_has(3);
  @$pb.TagNumber(4)
  void clearDose() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get effectiveAt => $_getN(4);
  @$pb.TagNumber(5)
  set effectiveAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEffectiveAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearEffectiveAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureEffectiveAt() => $_ensure(4);

  /// Set where a pump reported the change itself.
  @$pb.TagNumber(6)
  $core.String get deviceId => $_getSZ(5);
  @$pb.TagNumber(6)
  set deviceId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDeviceId() => $_has(5);
  @$pb.TagNumber(6)
  void clearDeviceId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get reason => $_getSZ(6);
  @$pb.TagNumber(7)
  set reason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearReason() => $_clearField(7);
}

class TitrateResponse extends $pb.GeneratedMessage {
  factory TitrateResponse({
    Titration? titration,
  }) {
    final result = create();
    if (titration != null) result.titration = titration;
    return result;
  }

  TitrateResponse._();

  factory TitrateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TitrateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TitrateResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<Titration>(1, _omitFieldNames ? '' : 'titration',
        subBuilder: Titration.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TitrateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TitrateResponse copyWith(void Function(TitrateResponse) updates) =>
      super.copyWith((message) => updates(message as TitrateResponse))
          as TitrateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TitrateResponse create() => TitrateResponse._();
  @$core.override
  TitrateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TitrateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TitrateResponse>(create);
  static TitrateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Titration get titration => $_getN(0);
  @$pb.TagNumber(1)
  set titration(Titration value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTitration() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitration() => $_clearField(1);
  @$pb.TagNumber(1)
  Titration ensureTitration() => $_ensure(0);
}

class StopInfusionRequest extends $pb.GeneratedMessage {
  factory StopInfusionRequest({
    $core.String? infusionId,
  }) {
    final result = create();
    if (infusionId != null) result.infusionId = infusionId;
    return result;
  }

  StopInfusionRequest._();

  factory StopInfusionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopInfusionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopInfusionRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'infusionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopInfusionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopInfusionRequest copyWith(void Function(StopInfusionRequest) updates) =>
      super.copyWith((message) => updates(message as StopInfusionRequest))
          as StopInfusionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopInfusionRequest create() => StopInfusionRequest._();
  @$core.override
  StopInfusionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StopInfusionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopInfusionRequest>(create);
  static StopInfusionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get infusionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set infusionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInfusionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInfusionId() => $_clearField(1);
}

class StopInfusionResponse extends $pb.GeneratedMessage {
  factory StopInfusionResponse() => create();

  StopInfusionResponse._();

  factory StopInfusionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopInfusionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopInfusionResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopInfusionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopInfusionResponse copyWith(void Function(StopInfusionResponse) updates) =>
      super.copyWith((message) => updates(message as StopInfusionResponse))
          as StopInfusionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopInfusionResponse create() => StopInfusionResponse._();
  @$core.override
  StopInfusionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StopInfusionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopInfusionResponse>(create);
  static StopInfusionResponse? _defaultInstance;
}

class ListInfusionsRequest extends $pb.GeneratedMessage {
  factory ListInfusionsRequest({
    $core.String? episodeId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    return result;
  }

  ListInfusionsRequest._();

  factory ListInfusionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListInfusionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInfusionsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInfusionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInfusionsRequest copyWith(void Function(ListInfusionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListInfusionsRequest))
          as ListInfusionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListInfusionsRequest create() => ListInfusionsRequest._();
  @$core.override
  ListInfusionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListInfusionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInfusionsRequest>(create);
  static ListInfusionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);
}

class ListInfusionsResponse extends $pb.GeneratedMessage {
  factory ListInfusionsResponse({
    $core.Iterable<Infusion>? infusions,
  }) {
    final result = create();
    if (infusions != null) result.infusions.addAll(infusions);
    return result;
  }

  ListInfusionsResponse._();

  factory ListInfusionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListInfusionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInfusionsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..pPM<Infusion>(1, _omitFieldNames ? '' : 'infusions',
        subBuilder: Infusion.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInfusionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInfusionsResponse copyWith(
          void Function(ListInfusionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListInfusionsResponse))
          as ListInfusionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListInfusionsResponse create() => ListInfusionsResponse._();
  @$core.override
  ListInfusionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListInfusionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInfusionsResponse>(create);
  static ListInfusionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Infusion> get infusions => $_getList(0);
}

class InsertDeviceRequest extends $pb.GeneratedMessage {
  factory InsertDeviceRequest({
    $core.String? episodeId,
    $core.String? kind,
    $core.String? site,
    $core.int? lumens,
    $0.Timestamp? insertedAt,
    $fixnum.Int64? reviewEverySeconds,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (kind != null) result.kind = kind;
    if (site != null) result.site = site;
    if (lumens != null) result.lumens = lumens;
    if (insertedAt != null) result.insertedAt = insertedAt;
    if (reviewEverySeconds != null)
      result.reviewEverySeconds = reviewEverySeconds;
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
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'kind')
    ..aOS(3, _omitFieldNames ? '' : 'site')
    ..aI(4, _omitFieldNames ? '' : 'lumens')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'insertedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(6, _omitFieldNames ? '' : 'reviewEverySeconds')
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
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get kind => $_getSZ(1);
  @$pb.TagNumber(2)
  set kind($core.String value) => $_setString(1, value);
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
  $core.int get lumens => $_getIZ(3);
  @$pb.TagNumber(4)
  set lumens($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLumens() => $_has(3);
  @$pb.TagNumber(4)
  void clearLumens() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get insertedAt => $_getN(4);
  @$pb.TagNumber(5)
  set insertedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasInsertedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearInsertedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureInsertedAt() => $_ensure(4);

  /// Zero takes the deployment's default, which is daily.
  @$pb.TagNumber(6)
  $fixnum.Int64 get reviewEverySeconds => $_getI64(5);
  @$pb.TagNumber(6)
  set reviewEverySeconds($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReviewEverySeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearReviewEverySeconds() => $_clearField(6);
}

class InsertDeviceResponse extends $pb.GeneratedMessage {
  factory InsertDeviceResponse({
    InvasiveDevice? device,
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
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<InvasiveDevice>(1, _omitFieldNames ? '' : 'device',
        subBuilder: InvasiveDevice.create)
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
  InvasiveDevice get device => $_getN(0);
  @$pb.TagNumber(1)
  set device(InvasiveDevice value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => $_clearField(1);
  @$pb.TagNumber(1)
  InvasiveDevice ensureDevice() => $_ensure(0);
}

class RemoveDeviceRequest extends $pb.GeneratedMessage {
  factory RemoveDeviceRequest({
    $core.String? deviceId,
    $core.String? reason,
    $0.Timestamp? removedAt,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (reason != null) result.reason = reason;
    if (removedAt != null) result.removedAt = removedAt;
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
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'removedAt',
        subBuilder: $0.Timestamp.create)
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
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get removedAt => $_getN(2);
  @$pb.TagNumber(3)
  set removedAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRemovedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearRemovedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureRemovedAt() => $_ensure(2);
}

class RemoveDeviceResponse extends $pb.GeneratedMessage {
  factory RemoveDeviceResponse() => create();

  RemoveDeviceResponse._();

  factory RemoveDeviceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveDeviceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveDeviceResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
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
}

class ReviewDeviceRequest extends $pb.GeneratedMessage {
  factory ReviewDeviceRequest({
    $core.String? deviceId,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    return result;
  }

  ReviewDeviceRequest._();

  factory ReviewDeviceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReviewDeviceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewDeviceRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewDeviceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewDeviceRequest copyWith(void Function(ReviewDeviceRequest) updates) =>
      super.copyWith((message) => updates(message as ReviewDeviceRequest))
          as ReviewDeviceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReviewDeviceRequest create() => ReviewDeviceRequest._();
  @$core.override
  ReviewDeviceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReviewDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewDeviceRequest>(create);
  static ReviewDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);
}

class ReviewDeviceResponse extends $pb.GeneratedMessage {
  factory ReviewDeviceResponse() => create();

  ReviewDeviceResponse._();

  factory ReviewDeviceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReviewDeviceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewDeviceResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewDeviceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewDeviceResponse copyWith(void Function(ReviewDeviceResponse) updates) =>
      super.copyWith((message) => updates(message as ReviewDeviceResponse))
          as ReviewDeviceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReviewDeviceResponse create() => ReviewDeviceResponse._();
  @$core.override
  ReviewDeviceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReviewDeviceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewDeviceResponse>(create);
  static ReviewDeviceResponse? _defaultInstance;
}

class ListDevicesRequest extends $pb.GeneratedMessage {
  factory ListDevicesRequest({
    $core.String? episodeId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
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
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
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
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);
}

class ListDevicesResponse extends $pb.GeneratedMessage {
  factory ListDevicesResponse({
    $core.Iterable<InvasiveDevice>? devices,
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
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..pPM<InvasiveDevice>(1, _omitFieldNames ? '' : 'devices',
        subBuilder: InvasiveDevice.create)
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
  $pb.PbList<InvasiveDevice> get devices => $_getList(0);
}

class CalculateScoreRequest extends $pb.GeneratedMessage {
  factory CalculateScoreRequest({
    $core.String? episodeId,
    $core.String? formulaName,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (formulaName != null) result.formulaName = formulaName;
    return result;
  }

  CalculateScoreRequest._();

  factory CalculateScoreRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CalculateScoreRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CalculateScoreRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'formulaName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculateScoreRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculateScoreRequest copyWith(
          void Function(CalculateScoreRequest) updates) =>
      super.copyWith((message) => updates(message as CalculateScoreRequest))
          as CalculateScoreRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateScoreRequest create() => CalculateScoreRequest._();
  @$core.override
  CalculateScoreRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CalculateScoreRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CalculateScoreRequest>(create);
  static CalculateScoreRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  /// A formula this deployment has configured. One it has not agreed the
  /// definition of is one nobody should act on the result of.
  @$pb.TagNumber(2)
  $core.String get formulaName => $_getSZ(1);
  @$pb.TagNumber(2)
  set formulaName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFormulaName() => $_has(1);
  @$pb.TagNumber(2)
  void clearFormulaName() => $_clearField(2);
}

class CalculateScoreResponse extends $pb.GeneratedMessage {
  factory CalculateScoreResponse({
    Score? score,
  }) {
    final result = create();
    if (score != null) result.score = score;
    return result;
  }

  CalculateScoreResponse._();

  factory CalculateScoreResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CalculateScoreResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CalculateScoreResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<Score>(1, _omitFieldNames ? '' : 'score', subBuilder: Score.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculateScoreResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculateScoreResponse copyWith(
          void Function(CalculateScoreResponse) updates) =>
      super.copyWith((message) => updates(message as CalculateScoreResponse))
          as CalculateScoreResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateScoreResponse create() => CalculateScoreResponse._();
  @$core.override
  CalculateScoreResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CalculateScoreResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CalculateScoreResponse>(create);
  static CalculateScoreResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Score get score => $_getN(0);
  @$pb.TagNumber(1)
  set score(Score value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScore() => $_has(0);
  @$pb.TagNumber(1)
  void clearScore() => $_clearField(1);
  @$pb.TagNumber(1)
  Score ensureScore() => $_ensure(0);
}

class ListScoresRequest extends $pb.GeneratedMessage {
  factory ListScoresRequest({
    $core.String? episodeId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListScoresRequest._();

  factory ListScoresRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListScoresRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListScoresRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListScoresRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListScoresRequest copyWith(void Function(ListScoresRequest) updates) =>
      super.copyWith((message) => updates(message as ListScoresRequest))
          as ListScoresRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListScoresRequest create() => ListScoresRequest._();
  @$core.override
  ListScoresRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListScoresRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListScoresRequest>(create);
  static ListScoresRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListScoresResponse extends $pb.GeneratedMessage {
  factory ListScoresResponse({
    $core.Iterable<Score>? scores,
  }) {
    final result = create();
    if (scores != null) result.scores.addAll(scores);
    return result;
  }

  ListScoresResponse._();

  factory ListScoresResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListScoresResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListScoresResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..pPM<Score>(1, _omitFieldNames ? '' : 'scores', subBuilder: Score.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListScoresResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListScoresResponse copyWith(void Function(ListScoresResponse) updates) =>
      super.copyWith((message) => updates(message as ListScoresResponse))
          as ListScoresResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListScoresResponse create() => ListScoresResponse._();
  @$core.override
  ListScoresResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListScoresResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListScoresResponse>(create);
  static ListScoresResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Score> get scores => $_getList(0);
}

/// SRS-ICU-009's verification clause, made callable.
class ReproduceScoreRequest extends $pb.GeneratedMessage {
  factory ReproduceScoreRequest({
    $core.String? episodeId,
    $core.String? scoreId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (scoreId != null) result.scoreId = scoreId;
    return result;
  }

  ReproduceScoreRequest._();

  factory ReproduceScoreRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReproduceScoreRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReproduceScoreRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'scoreId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReproduceScoreRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReproduceScoreRequest copyWith(
          void Function(ReproduceScoreRequest) updates) =>
      super.copyWith((message) => updates(message as ReproduceScoreRequest))
          as ReproduceScoreRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReproduceScoreRequest create() => ReproduceScoreRequest._();
  @$core.override
  ReproduceScoreRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReproduceScoreRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReproduceScoreRequest>(create);
  static ReproduceScoreRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scoreId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scoreId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScoreId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScoreId() => $_clearField(2);
}

class ReproduceScoreResponse extends $pb.GeneratedMessage {
  factory ReproduceScoreResponse({
    $core.int? storedTotal,
    $core.int? reproducedTotal,
    $core.bool? reproduced,
  }) {
    final result = create();
    if (storedTotal != null) result.storedTotal = storedTotal;
    if (reproducedTotal != null) result.reproducedTotal = reproducedTotal;
    if (reproduced != null) result.reproduced = reproduced;
    return result;
  }

  ReproduceScoreResponse._();

  factory ReproduceScoreResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReproduceScoreResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReproduceScoreResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'storedTotal')
    ..aI(2, _omitFieldNames ? '' : 'reproducedTotal')
    ..aOB(3, _omitFieldNames ? '' : 'reproduced')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReproduceScoreResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReproduceScoreResponse copyWith(
          void Function(ReproduceScoreResponse) updates) =>
      super.copyWith((message) => updates(message as ReproduceScoreResponse))
          as ReproduceScoreResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReproduceScoreResponse create() => ReproduceScoreResponse._();
  @$core.override
  ReproduceScoreResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReproduceScoreResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReproduceScoreResponse>(create);
  static ReproduceScoreResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get storedTotal => $_getIZ(0);
  @$pb.TagNumber(1)
  set storedTotal($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStoredTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearStoredTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get reproducedTotal => $_getIZ(1);
  @$pb.TagNumber(2)
  set reproducedTotal($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReproducedTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearReproducedTotal() => $_clearField(2);

  /// False where the two disagree, which means the inputs or the chart changed
  /// after the score was calculated. Reported rather than corrected: the
  /// disagreement is worth more than either number.
  @$pb.TagNumber(3)
  $core.bool get reproduced => $_getBF(2);
  @$pb.TagNumber(3)
  set reproduced($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReproduced() => $_has(2);
  @$pb.TagNumber(3)
  void clearReproduced() => $_clearField(3);
}

class PerformBundleRequest extends $pb.GeneratedMessage {
  factory PerformBundleRequest({
    $core.String? episodeId,
    BundleKind? kind,
    $core.Iterable<BundleResult>? results,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (kind != null) result.kind = kind;
    if (results != null) result.results.addAll(results);
    return result;
  }

  PerformBundleRequest._();

  factory PerformBundleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PerformBundleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PerformBundleRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aE<BundleKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: BundleKind.values)
    ..pPM<BundleResult>(3, _omitFieldNames ? '' : 'results',
        subBuilder: BundleResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PerformBundleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PerformBundleRequest copyWith(void Function(PerformBundleRequest) updates) =>
      super.copyWith((message) => updates(message as PerformBundleRequest))
          as PerformBundleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PerformBundleRequest create() => PerformBundleRequest._();
  @$core.override
  PerformBundleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PerformBundleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PerformBundleRequest>(create);
  static PerformBundleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  BundleKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(BundleKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<BundleResult> get results => $_getList(2);
}

class PerformBundleResponse extends $pb.GeneratedMessage {
  factory PerformBundleResponse({
    BundlePerformance? performance,
  }) {
    final result = create();
    if (performance != null) result.performance = performance;
    return result;
  }

  PerformBundleResponse._();

  factory PerformBundleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PerformBundleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PerformBundleResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<BundlePerformance>(1, _omitFieldNames ? '' : 'performance',
        subBuilder: BundlePerformance.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PerformBundleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PerformBundleResponse copyWith(
          void Function(PerformBundleResponse) updates) =>
      super.copyWith((message) => updates(message as PerformBundleResponse))
          as PerformBundleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PerformBundleResponse create() => PerformBundleResponse._();
  @$core.override
  PerformBundleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PerformBundleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PerformBundleResponse>(create);
  static PerformBundleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BundlePerformance get performance => $_getN(0);
  @$pb.TagNumber(1)
  set performance(BundlePerformance value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPerformance() => $_has(0);
  @$pb.TagNumber(1)
  void clearPerformance() => $_clearField(1);
  @$pb.TagNumber(1)
  BundlePerformance ensurePerformance() => $_ensure(0);
}

class ListBundlesRequest extends $pb.GeneratedMessage {
  factory ListBundlesRequest({
    $core.String? episodeId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListBundlesRequest._();

  factory ListBundlesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBundlesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBundlesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBundlesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBundlesRequest copyWith(void Function(ListBundlesRequest) updates) =>
      super.copyWith((message) => updates(message as ListBundlesRequest))
          as ListBundlesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBundlesRequest create() => ListBundlesRequest._();
  @$core.override
  ListBundlesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBundlesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBundlesRequest>(create);
  static ListBundlesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListBundlesResponse extends $pb.GeneratedMessage {
  factory ListBundlesResponse({
    $core.Iterable<BundlePerformance>? performances,
  }) {
    final result = create();
    if (performances != null) result.performances.addAll(performances);
    return result;
  }

  ListBundlesResponse._();

  factory ListBundlesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBundlesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBundlesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..pPM<BundlePerformance>(1, _omitFieldNames ? '' : 'performances',
        subBuilder: BundlePerformance.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBundlesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBundlesResponse copyWith(void Function(ListBundlesResponse) updates) =>
      super.copyWith((message) => updates(message as ListBundlesResponse))
          as ListBundlesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBundlesResponse create() => ListBundlesResponse._();
  @$core.override
  ListBundlesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBundlesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBundlesResponse>(create);
  static ListBundlesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BundlePerformance> get performances => $_getList(0);
}

class RecordAssessmentRequest extends $pb.GeneratedMessage {
  factory RecordAssessmentRequest({
    $core.String? episodeId,
    $core.String? kind,
    $core.String? scale,
    $core.int? score,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? findings,
    $core.String? note,
    $0.Timestamp? performedAt,
    $fixnum.Int64? everySeconds,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (kind != null) result.kind = kind;
    if (scale != null) result.scale = scale;
    if (score != null) result.score = score;
    if (findings != null) result.findings.addEntries(findings);
    if (note != null) result.note = note;
    if (performedAt != null) result.performedAt = performedAt;
    if (everySeconds != null) result.everySeconds = everySeconds;
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
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'kind')
    ..aOS(3, _omitFieldNames ? '' : 'scale')
    ..aI(4, _omitFieldNames ? '' : 'score')
    ..m<$core.String, $core.String>(5, _omitFieldNames ? '' : 'findings',
        entryClassName: 'RecordAssessmentRequest.FindingsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('healthcare.icu.v1'))
    ..aOS(6, _omitFieldNames ? '' : 'note')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'performedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(8, _omitFieldNames ? '' : 'everySeconds')
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
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get kind => $_getSZ(1);
  @$pb.TagNumber(2)
  set kind($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scale => $_getSZ(2);
  @$pb.TagNumber(3)
  set scale($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScale() => $_has(2);
  @$pb.TagNumber(3)
  void clearScale() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get score => $_getIZ(3);
  @$pb.TagNumber(4)
  set score($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearScore() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.String> get findings => $_getMap(4);

  @$pb.TagNumber(6)
  $core.String get note => $_getSZ(5);
  @$pb.TagNumber(6)
  set note($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNote() => $_has(5);
  @$pb.TagNumber(6)
  void clearNote() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get performedAt => $_getN(6);
  @$pb.TagNumber(7)
  set performedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPerformedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearPerformedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensurePerformedAt() => $_ensure(6);

  /// Zero takes the interval configured for the kind.
  @$pb.TagNumber(8)
  $fixnum.Int64 get everySeconds => $_getI64(7);
  @$pb.TagNumber(8)
  set everySeconds($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEverySeconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearEverySeconds() => $_clearField(8);
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
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
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

class ListDueAssessmentsRequest extends $pb.GeneratedMessage {
  factory ListDueAssessmentsRequest({
    $core.String? episodeId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    return result;
  }

  ListDueAssessmentsRequest._();

  factory ListDueAssessmentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDueAssessmentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDueAssessmentsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueAssessmentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueAssessmentsRequest copyWith(
          void Function(ListDueAssessmentsRequest) updates) =>
      super.copyWith((message) => updates(message as ListDueAssessmentsRequest))
          as ListDueAssessmentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDueAssessmentsRequest create() => ListDueAssessmentsRequest._();
  @$core.override
  ListDueAssessmentsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDueAssessmentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDueAssessmentsRequest>(create);
  static ListDueAssessmentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);
}

class ListDueAssessmentsResponse extends $pb.GeneratedMessage {
  factory ListDueAssessmentsResponse({
    $core.Iterable<Assessment>? assessments,
  }) {
    final result = create();
    if (assessments != null) result.assessments.addAll(assessments);
    return result;
  }

  ListDueAssessmentsResponse._();

  factory ListDueAssessmentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDueAssessmentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDueAssessmentsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..pPM<Assessment>(1, _omitFieldNames ? '' : 'assessments',
        subBuilder: Assessment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueAssessmentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueAssessmentsResponse copyWith(
          void Function(ListDueAssessmentsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListDueAssessmentsResponse))
          as ListDueAssessmentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDueAssessmentsResponse create() => ListDueAssessmentsResponse._();
  @$core.override
  ListDueAssessmentsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDueAssessmentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDueAssessmentsResponse>(create);
  static ListDueAssessmentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Assessment> get assessments => $_getList(0);
}

class GoalRequest extends $pb.GeneratedMessage {
  factory GoalRequest({
    $core.String? domain,
    $core.String? text,
    $core.String? ownerRole,
    $core.String? ownerId,
    $0.Timestamp? targetAt,
  }) {
    final result = create();
    if (domain != null) result.domain = domain;
    if (text != null) result.text = text;
    if (ownerRole != null) result.ownerRole = ownerRole;
    if (ownerId != null) result.ownerId = ownerId;
    if (targetAt != null) result.targetAt = targetAt;
    return result;
  }

  GoalRequest._();

  factory GoalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GoalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GoalRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'domain')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'ownerRole')
    ..aOS(4, _omitFieldNames ? '' : 'ownerId')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'targetAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GoalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GoalRequest copyWith(void Function(GoalRequest) updates) =>
      super.copyWith((message) => updates(message as GoalRequest))
          as GoalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GoalRequest create() => GoalRequest._();
  @$core.override
  GoalRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GoalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GoalRequest>(create);
  static GoalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get domain => $_getSZ(0);
  @$pb.TagNumber(1)
  set domain($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDomain() => $_has(0);
  @$pb.TagNumber(1)
  void clearDomain() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get ownerRole => $_getSZ(2);
  @$pb.TagNumber(3)
  set ownerRole($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOwnerRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearOwnerRole() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get ownerId => $_getSZ(3);
  @$pb.TagNumber(4)
  set ownerId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOwnerId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOwnerId() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get targetAt => $_getN(4);
  @$pb.TagNumber(5)
  set targetAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureTargetAt() => $_ensure(4);
}

class RecordRoundRequest extends $pb.GeneratedMessage {
  factory RecordRoundRequest({
    $core.String? episodeId,
    $core.Iterable<$core.String>? attendance,
    $core.String? summary,
    $core.Iterable<GoalRequest>? goals,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (attendance != null) result.attendance.addAll(attendance);
    if (summary != null) result.summary = summary;
    if (goals != null) result.goals.addAll(goals);
    return result;
  }

  RecordRoundRequest._();

  factory RecordRoundRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordRoundRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordRoundRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..pPS(2, _omitFieldNames ? '' : 'attendance')
    ..aOS(3, _omitFieldNames ? '' : 'summary')
    ..pPM<GoalRequest>(4, _omitFieldNames ? '' : 'goals',
        subBuilder: GoalRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordRoundRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordRoundRequest copyWith(void Function(RecordRoundRequest) updates) =>
      super.copyWith((message) => updates(message as RecordRoundRequest))
          as RecordRoundRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordRoundRequest create() => RecordRoundRequest._();
  @$core.override
  RecordRoundRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordRoundRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordRoundRequest>(create);
  static RecordRoundRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get attendance => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get summary => $_getSZ(2);
  @$pb.TagNumber(3)
  set summary($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSummary() => $_has(2);
  @$pb.TagNumber(3)
  void clearSummary() => $_clearField(3);

  /// The goals are the round: a round recorded without them is a note saying a
  /// meeting happened.
  @$pb.TagNumber(4)
  $pb.PbList<GoalRequest> get goals => $_getList(3);
}

class RecordRoundResponse extends $pb.GeneratedMessage {
  factory RecordRoundResponse({
    Round? round,
    $core.Iterable<Goal>? goals,
  }) {
    final result = create();
    if (round != null) result.round = round;
    if (goals != null) result.goals.addAll(goals);
    return result;
  }

  RecordRoundResponse._();

  factory RecordRoundResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordRoundResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordRoundResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<Round>(1, _omitFieldNames ? '' : 'round', subBuilder: Round.create)
    ..pPM<Goal>(2, _omitFieldNames ? '' : 'goals', subBuilder: Goal.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordRoundResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordRoundResponse copyWith(void Function(RecordRoundResponse) updates) =>
      super.copyWith((message) => updates(message as RecordRoundResponse))
          as RecordRoundResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordRoundResponse create() => RecordRoundResponse._();
  @$core.override
  RecordRoundResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordRoundResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordRoundResponse>(create);
  static RecordRoundResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Round get round => $_getN(0);
  @$pb.TagNumber(1)
  set round(Round value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRound() => $_has(0);
  @$pb.TagNumber(1)
  void clearRound() => $_clearField(1);
  @$pb.TagNumber(1)
  Round ensureRound() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Goal> get goals => $_getList(1);
}

class ResolveGoalRequest extends $pb.GeneratedMessage {
  factory ResolveGoalRequest({
    $core.String? episodeId,
    $core.String? goalId,
    GoalStatus? status,
    $core.String? outcome,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (goalId != null) result.goalId = goalId;
    if (status != null) result.status = status;
    if (outcome != null) result.outcome = outcome;
    return result;
  }

  ResolveGoalRequest._();

  factory ResolveGoalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveGoalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveGoalRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'goalId')
    ..aE<GoalStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: GoalStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'outcome')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveGoalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveGoalRequest copyWith(void Function(ResolveGoalRequest) updates) =>
      super.copyWith((message) => updates(message as ResolveGoalRequest))
          as ResolveGoalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveGoalRequest create() => ResolveGoalRequest._();
  @$core.override
  ResolveGoalRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveGoalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveGoalRequest>(create);
  static ResolveGoalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get goalId => $_getSZ(1);
  @$pb.TagNumber(2)
  set goalId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGoalId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGoalId() => $_clearField(2);

  @$pb.TagNumber(3)
  GoalStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(GoalStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  /// Required unless the goal was met.
  @$pb.TagNumber(4)
  $core.String get outcome => $_getSZ(3);
  @$pb.TagNumber(4)
  set outcome($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutcome() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutcome() => $_clearField(4);
}

class ResolveGoalResponse extends $pb.GeneratedMessage {
  factory ResolveGoalResponse() => create();

  ResolveGoalResponse._();

  factory ResolveGoalResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveGoalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveGoalResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveGoalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveGoalResponse copyWith(void Function(ResolveGoalResponse) updates) =>
      super.copyWith((message) => updates(message as ResolveGoalResponse))
          as ResolveGoalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveGoalResponse create() => ResolveGoalResponse._();
  @$core.override
  ResolveGoalResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveGoalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveGoalResponse>(create);
  static ResolveGoalResponse? _defaultInstance;
}

class ListOpenGoalsRequest extends $pb.GeneratedMessage {
  factory ListOpenGoalsRequest({
    $core.String? episodeId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    return result;
  }

  ListOpenGoalsRequest._();

  factory ListOpenGoalsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOpenGoalsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOpenGoalsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOpenGoalsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOpenGoalsRequest copyWith(void Function(ListOpenGoalsRequest) updates) =>
      super.copyWith((message) => updates(message as ListOpenGoalsRequest))
          as ListOpenGoalsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOpenGoalsRequest create() => ListOpenGoalsRequest._();
  @$core.override
  ListOpenGoalsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOpenGoalsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOpenGoalsRequest>(create);
  static ListOpenGoalsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);
}

class ListOpenGoalsResponse extends $pb.GeneratedMessage {
  factory ListOpenGoalsResponse({
    $core.Iterable<Goal>? goals,
  }) {
    final result = create();
    if (goals != null) result.goals.addAll(goals);
    return result;
  }

  ListOpenGoalsResponse._();

  factory ListOpenGoalsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOpenGoalsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOpenGoalsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..pPM<Goal>(1, _omitFieldNames ? '' : 'goals', subBuilder: Goal.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOpenGoalsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOpenGoalsResponse copyWith(
          void Function(ListOpenGoalsResponse) updates) =>
      super.copyWith((message) => updates(message as ListOpenGoalsResponse))
          as ListOpenGoalsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOpenGoalsResponse create() => ListOpenGoalsResponse._();
  @$core.override
  ListOpenGoalsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOpenGoalsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOpenGoalsResponse>(create);
  static ListOpenGoalsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Goal> get goals => $_getList(0);
}

class SetCeilingRequest extends $pb.GeneratedMessage {
  factory SetCeilingRequest({
    $core.String? episodeId,
    CareIntent? intent,
    $core.Iterable<$core.String>? limitations,
    $core.String? cprStatus,
    $core.String? discussedWith,
    $core.String? rationale,
    $core.String? authorisedBy,
    $core.String? authorisedRole,
    $0.Timestamp? reviewBy,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (intent != null) result.intent = intent;
    if (limitations != null) result.limitations.addAll(limitations);
    if (cprStatus != null) result.cprStatus = cprStatus;
    if (discussedWith != null) result.discussedWith = discussedWith;
    if (rationale != null) result.rationale = rationale;
    if (authorisedBy != null) result.authorisedBy = authorisedBy;
    if (authorisedRole != null) result.authorisedRole = authorisedRole;
    if (reviewBy != null) result.reviewBy = reviewBy;
    return result;
  }

  SetCeilingRequest._();

  factory SetCeilingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetCeilingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetCeilingRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aE<CareIntent>(2, _omitFieldNames ? '' : 'intent',
        enumValues: CareIntent.values)
    ..pPS(3, _omitFieldNames ? '' : 'limitations')
    ..aOS(4, _omitFieldNames ? '' : 'cprStatus')
    ..aOS(5, _omitFieldNames ? '' : 'discussedWith')
    ..aOS(6, _omitFieldNames ? '' : 'rationale')
    ..aOS(7, _omitFieldNames ? '' : 'authorisedBy')
    ..aOS(8, _omitFieldNames ? '' : 'authorisedRole')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'reviewBy',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetCeilingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetCeilingRequest copyWith(void Function(SetCeilingRequest) updates) =>
      super.copyWith((message) => updates(message as SetCeilingRequest))
          as SetCeilingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetCeilingRequest create() => SetCeilingRequest._();
  @$core.override
  SetCeilingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetCeilingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetCeilingRequest>(create);
  static SetCeilingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  CareIntent get intent => $_getN(1);
  @$pb.TagNumber(2)
  set intent(CareIntent value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasIntent() => $_has(1);
  @$pb.TagNumber(2)
  void clearIntent() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get limitations => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get cprStatus => $_getSZ(3);
  @$pb.TagNumber(4)
  set cprStatus($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCprStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearCprStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get discussedWith => $_getSZ(4);
  @$pb.TagNumber(5)
  set discussedWith($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDiscussedWith() => $_has(4);
  @$pb.TagNumber(5)
  void clearDiscussedWith() => $_clearField(5);

  /// Required unless the intent is full escalation.
  @$pb.TagNumber(6)
  $core.String get rationale => $_getSZ(5);
  @$pb.TagNumber(6)
  set rationale($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRationale() => $_has(5);
  @$pb.TagNumber(6)
  void clearRationale() => $_clearField(6);

  /// The senior clinician who owns the decision, which may not be the caller: a
  /// registrar writing up a consultant's decision is the ordinary case.
  @$pb.TagNumber(7)
  $core.String get authorisedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set authorisedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAuthorisedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearAuthorisedBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get authorisedRole => $_getSZ(7);
  @$pb.TagNumber(8)
  set authorisedRole($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAuthorisedRole() => $_has(7);
  @$pb.TagNumber(8)
  void clearAuthorisedRole() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get reviewBy => $_getN(8);
  @$pb.TagNumber(9)
  set reviewBy($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasReviewBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearReviewBy() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureReviewBy() => $_ensure(8);
}

class SetCeilingResponse extends $pb.GeneratedMessage {
  factory SetCeilingResponse({
    GoalsOfCare? ceiling,
  }) {
    final result = create();
    if (ceiling != null) result.ceiling = ceiling;
    return result;
  }

  SetCeilingResponse._();

  factory SetCeilingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetCeilingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetCeilingResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<GoalsOfCare>(1, _omitFieldNames ? '' : 'ceiling',
        subBuilder: GoalsOfCare.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetCeilingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetCeilingResponse copyWith(void Function(SetCeilingResponse) updates) =>
      super.copyWith((message) => updates(message as SetCeilingResponse))
          as SetCeilingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetCeilingResponse create() => SetCeilingResponse._();
  @$core.override
  SetCeilingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetCeilingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetCeilingResponse>(create);
  static SetCeilingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  GoalsOfCare get ceiling => $_getN(0);
  @$pb.TagNumber(1)
  set ceiling(GoalsOfCare value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCeiling() => $_has(0);
  @$pb.TagNumber(1)
  void clearCeiling() => $_clearField(1);
  @$pb.TagNumber(1)
  GoalsOfCare ensureCeiling() => $_ensure(0);
}

class GetCeilingRequest extends $pb.GeneratedMessage {
  factory GetCeilingRequest({
    $core.String? episodeId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    return result;
  }

  GetCeilingRequest._();

  factory GetCeilingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCeilingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCeilingRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCeilingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCeilingRequest copyWith(void Function(GetCeilingRequest) updates) =>
      super.copyWith((message) => updates(message as GetCeilingRequest))
          as GetCeilingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCeilingRequest create() => GetCeilingRequest._();
  @$core.override
  GetCeilingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCeilingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCeilingRequest>(create);
  static GetCeilingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);
}

class GetCeilingResponse extends $pb.GeneratedMessage {
  factory GetCeilingResponse({
    GoalsOfCare? current,
    $core.Iterable<GoalsOfCare>? history,
  }) {
    final result = create();
    if (current != null) result.current = current;
    if (history != null) result.history.addAll(history);
    return result;
  }

  GetCeilingResponse._();

  factory GetCeilingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCeilingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCeilingResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<GoalsOfCare>(1, _omitFieldNames ? '' : 'current',
        subBuilder: GoalsOfCare.create)
    ..pPM<GoalsOfCare>(2, _omitFieldNames ? '' : 'history',
        subBuilder: GoalsOfCare.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCeilingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCeilingResponse copyWith(void Function(GetCeilingResponse) updates) =>
      super.copyWith((message) => updates(message as GetCeilingResponse))
          as GetCeilingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCeilingResponse create() => GetCeilingResponse._();
  @$core.override
  GetCeilingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCeilingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCeilingResponse>(create);
  static GetCeilingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  GoalsOfCare get current => $_getN(0);
  @$pb.TagNumber(1)
  set current(GoalsOfCare value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrent() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrent() => $_clearField(1);
  @$pb.TagNumber(1)
  GoalsOfCare ensureCurrent() => $_ensure(0);

  /// Superseded ceilings included. The history is the point.
  @$pb.TagNumber(2)
  $pb.PbList<GoalsOfCare> get history => $_getList(1);
}

class GetDashboardRequest extends $pb.GeneratedMessage {
  factory GetDashboardRequest({
    $core.String? unitId,
    $core.int? pageSize,
    $fixnum.Int64? balanceWindowSeconds,
  }) {
    final result = create();
    if (unitId != null) result.unitId = unitId;
    if (pageSize != null) result.pageSize = pageSize;
    if (balanceWindowSeconds != null)
      result.balanceWindowSeconds = balanceWindowSeconds;
    return result;
  }

  GetDashboardRequest._();

  factory GetDashboardRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDashboardRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDashboardRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aInt64(3, _omitFieldNames ? '' : 'balanceWindowSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardRequest copyWith(void Function(GetDashboardRequest) updates) =>
      super.copyWith((message) => updates(message as GetDashboardRequest))
          as GetDashboardRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDashboardRequest create() => GetDashboardRequest._();
  @$core.override
  GetDashboardRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDashboardRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDashboardRequest>(create);
  static GetDashboardRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  /// How far back the running fluid balance looks. Zero takes one shift.
  @$pb.TagNumber(3)
  $fixnum.Int64 get balanceWindowSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set balanceWindowSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBalanceWindowSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearBalanceWindowSeconds() => $_clearField(3);
}

class GetDashboardResponse extends $pb.GeneratedMessage {
  factory GetDashboardResponse({
    $core.Iterable<DashboardRow>? rows,
  }) {
    final result = create();
    if (rows != null) result.rows.addAll(rows);
    return result;
  }

  GetDashboardResponse._();

  factory GetDashboardResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDashboardResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDashboardResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..pPM<DashboardRow>(1, _omitFieldNames ? '' : 'rows',
        subBuilder: DashboardRow.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardResponse copyWith(void Function(GetDashboardResponse) updates) =>
      super.copyWith((message) => updates(message as GetDashboardResponse))
          as GetDashboardResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDashboardResponse create() => GetDashboardResponse._();
  @$core.override
  GetDashboardResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDashboardResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDashboardResponse>(create);
  static GetDashboardResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DashboardRow> get rows => $_getList(0);
}

class ListAdvisoriesRequest extends $pb.GeneratedMessage {
  factory ListAdvisoriesRequest({
    $core.String? episodeId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    return result;
  }

  ListAdvisoriesRequest._();

  factory ListAdvisoriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAdvisoriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAdvisoriesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAdvisoriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAdvisoriesRequest copyWith(
          void Function(ListAdvisoriesRequest) updates) =>
      super.copyWith((message) => updates(message as ListAdvisoriesRequest))
          as ListAdvisoriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAdvisoriesRequest create() => ListAdvisoriesRequest._();
  @$core.override
  ListAdvisoriesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAdvisoriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAdvisoriesRequest>(create);
  static ListAdvisoriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);
}

class ListAdvisoriesResponse extends $pb.GeneratedMessage {
  factory ListAdvisoriesResponse({
    $core.Iterable<Alarm>? alarms,
  }) {
    final result = create();
    if (alarms != null) result.alarms.addAll(alarms);
    return result;
  }

  ListAdvisoriesResponse._();

  factory ListAdvisoriesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAdvisoriesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAdvisoriesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..pPM<Alarm>(1, _omitFieldNames ? '' : 'alarms', subBuilder: Alarm.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAdvisoriesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAdvisoriesResponse copyWith(
          void Function(ListAdvisoriesResponse) updates) =>
      super.copyWith((message) => updates(message as ListAdvisoriesResponse))
          as ListAdvisoriesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAdvisoriesResponse create() => ListAdvisoriesResponse._();
  @$core.override
  ListAdvisoriesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAdvisoriesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAdvisoriesResponse>(create);
  static ListAdvisoriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Alarm> get alarms => $_getList(0);
}

class EscalateAdvisoryRequest extends $pb.GeneratedMessage {
  factory EscalateAdvisoryRequest({
    $core.String? episodeId,
    $core.String? kind,
    $core.String? summary,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (kind != null) result.kind = kind;
    if (summary != null) result.summary = summary;
    return result;
  }

  EscalateAdvisoryRequest._();

  factory EscalateAdvisoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EscalateAdvisoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EscalateAdvisoryRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'kind')
    ..aOS(3, _omitFieldNames ? '' : 'summary')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateAdvisoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateAdvisoryRequest copyWith(
          void Function(EscalateAdvisoryRequest) updates) =>
      super.copyWith((message) => updates(message as EscalateAdvisoryRequest))
          as EscalateAdvisoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EscalateAdvisoryRequest create() => EscalateAdvisoryRequest._();
  @$core.override
  EscalateAdvisoryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EscalateAdvisoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EscalateAdvisoryRequest>(create);
  static EscalateAdvisoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get kind => $_getSZ(1);
  @$pb.TagNumber(2)
  set kind($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get summary => $_getSZ(2);
  @$pb.TagNumber(3)
  set summary($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSummary() => $_has(2);
  @$pb.TagNumber(3)
  void clearSummary() => $_clearField(3);
}

class EscalateAdvisoryResponse extends $pb.GeneratedMessage {
  factory EscalateAdvisoryResponse({
    $core.String? noticeId,
  }) {
    final result = create();
    if (noticeId != null) result.noticeId = noticeId;
    return result;
  }

  EscalateAdvisoryResponse._();

  factory EscalateAdvisoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EscalateAdvisoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EscalateAdvisoryResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'noticeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateAdvisoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateAdvisoryResponse copyWith(
          void Function(EscalateAdvisoryResponse) updates) =>
      super.copyWith((message) => updates(message as EscalateAdvisoryResponse))
          as EscalateAdvisoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EscalateAdvisoryResponse create() => EscalateAdvisoryResponse._();
  @$core.override
  EscalateAdvisoryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EscalateAdvisoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EscalateAdvisoryResponse>(create);
  static EscalateAdvisoryResponse? _defaultInstance;

  /// Empty where the unit has configured no escalation chain: the escalation is
  /// recorded and nobody is paged through this software, which is a real
  /// arrangement rather than a defect.
  @$pb.TagNumber(1)
  $core.String get noticeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set noticeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNoticeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNoticeId() => $_clearField(1);
}

class GetUnitMetricsRequest extends $pb.GeneratedMessage {
  factory GetUnitMetricsRequest({
    $core.String? unitId,
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (unitId != null) result.unitId = unitId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  GetUnitMetricsRequest._();

  factory GetUnitMetricsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUnitMetricsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUnitMetricsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnitMetricsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnitMetricsRequest copyWith(
          void Function(GetUnitMetricsRequest) updates) =>
      super.copyWith((message) => updates(message as GetUnitMetricsRequest))
          as GetUnitMetricsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUnitMetricsRequest create() => GetUnitMetricsRequest._();
  @$core.override
  GetUnitMetricsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUnitMetricsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUnitMetricsRequest>(create);
  static GetUnitMetricsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitId() => $_clearField(1);

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

class GetUnitMetricsResponse extends $pb.GeneratedMessage {
  factory GetUnitMetricsResponse({
    UnitMetrics? metrics,
  }) {
    final result = create();
    if (metrics != null) result.metrics = metrics;
    return result;
  }

  GetUnitMetricsResponse._();

  factory GetUnitMetricsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUnitMetricsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUnitMetricsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.icu.v1'),
      createEmptyInstance: create)
    ..aOM<UnitMetrics>(1, _omitFieldNames ? '' : 'metrics',
        subBuilder: UnitMetrics.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnitMetricsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnitMetricsResponse copyWith(
          void Function(GetUnitMetricsResponse) updates) =>
      super.copyWith((message) => updates(message as GetUnitMetricsResponse))
          as GetUnitMetricsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUnitMetricsResponse create() => GetUnitMetricsResponse._();
  @$core.override
  GetUnitMetricsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUnitMetricsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUnitMetricsResponse>(create);
  static GetUnitMetricsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  UnitMetrics get metrics => $_getN(0);
  @$pb.TagNumber(1)
  set metrics(UnitMetrics value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMetrics() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetrics() => $_clearField(1);
  @$pb.TagNumber(1)
  UnitMetrics ensureMetrics() => $_ensure(0);
}

class IcuServiceApi {
  final $pb.RpcClient _client;

  IcuServiceApi(this._client);

  /// The episode (SRS-ICU-001, SRS-ICU-016).
  $async.Future<AdmitResponse> admit(
          $pb.ClientContext? ctx, AdmitRequest request) =>
      _client.invoke<AdmitResponse>(
          ctx, 'IcuService', 'Admit', request, AdmitResponse());
  $async.Future<GetIcuEpisodeResponse> getIcuEpisode(
          $pb.ClientContext? ctx, GetIcuEpisodeRequest request) =>
      _client.invoke<GetIcuEpisodeResponse>(
          ctx, 'IcuService', 'GetIcuEpisode', request, GetIcuEpisodeResponse());
  $async.Future<MoveBedResponse> moveBed(
          $pb.ClientContext? ctx, MoveBedRequest request) =>
      _client.invoke<MoveBedResponse>(
          ctx, 'IcuService', 'MoveBed', request, MoveBedResponse());
  $async.Future<DeclareReadyResponse> declareReady(
          $pb.ClientContext? ctx, DeclareReadyRequest request) =>
      _client.invoke<DeclareReadyResponse>(
          ctx, 'IcuService', 'DeclareReady', request, DeclareReadyResponse());
  $async.Future<DischargeResponse> discharge(
          $pb.ClientContext? ctx, DischargeRequest request) =>
      _client.invoke<DischargeResponse>(
          ctx, 'IcuService', 'Discharge', request, DischargeResponse());

  /// The flowsheet and the balance (SRS-ICU-002, SRS-ICU-003, SRS-ICU-007).
  $async.Future<ChartValueResponse> chartValue(
          $pb.ClientContext? ctx, ChartValueRequest request) =>
      _client.invoke<ChartValueResponse>(
          ctx, 'IcuService', 'ChartValue', request, ChartValueResponse());
  $async.Future<DecideReadingResponse> decideReading(
          $pb.ClientContext? ctx, DecideReadingRequest request) =>
      _client.invoke<DecideReadingResponse>(
          ctx, 'IcuService', 'DecideReading', request, DecideReadingResponse());
  $async.Future<ListFlowsheetResponse> listFlowsheet(
          $pb.ClientContext? ctx, ListFlowsheetRequest request) =>
      _client.invoke<ListFlowsheetResponse>(
          ctx, 'IcuService', 'ListFlowsheet', request, ListFlowsheetResponse());
  $async.Future<ListPendingReadingsResponse> listPendingReadings(
          $pb.ClientContext? ctx, ListPendingReadingsRequest request) =>
      _client.invoke<ListPendingReadingsResponse>(ctx, 'IcuService',
          'ListPendingReadings', request, ListPendingReadingsResponse());
  $async.Future<RecordBalanceResponse> recordBalance(
          $pb.ClientContext? ctx, RecordBalanceRequest request) =>
      _client.invoke<RecordBalanceResponse>(
          ctx, 'IcuService', 'RecordBalance', request, RecordBalanceResponse());
  $async.Future<GetBalanceResponse> getBalance(
          $pb.ClientContext? ctx, GetBalanceRequest request) =>
      _client.invoke<GetBalanceResponse>(
          ctx, 'IcuService', 'GetBalance', request, GetBalanceResponse());

  /// Organ support (SRS-ICU-004, SRS-ICU-005, SRS-ICU-006, SRS-ICU-011).
  $async.Future<StartSupportResponse> startSupport(
          $pb.ClientContext? ctx, StartSupportRequest request) =>
      _client.invoke<StartSupportResponse>(
          ctx, 'IcuService', 'StartSupport', request, StartSupportResponse());
  $async.Future<StopSupportResponse> stopSupport(
          $pb.ClientContext? ctx, StopSupportRequest request) =>
      _client.invoke<StopSupportResponse>(
          ctx, 'IcuService', 'StopSupport', request, StopSupportResponse());
  $async.Future<ListSupportResponse> listSupport(
          $pb.ClientContext? ctx, ListSupportRequest request) =>
      _client.invoke<ListSupportResponse>(
          ctx, 'IcuService', 'ListSupport', request, ListSupportResponse());
  $async.Future<RecordVentSettingResponse> recordVentSetting(
          $pb.ClientContext? ctx, RecordVentSettingRequest request) =>
      _client.invoke<RecordVentSettingResponse>(ctx, 'IcuService',
          'RecordVentSetting', request, RecordVentSettingResponse());
  $async.Future<GetVentTimelineResponse> getVentTimeline(
          $pb.ClientContext? ctx, GetVentTimelineRequest request) =>
      _client.invoke<GetVentTimelineResponse>(ctx, 'IcuService',
          'GetVentTimeline', request, GetVentTimelineResponse());
  $async.Future<StartInfusionResponse> startInfusion(
          $pb.ClientContext? ctx, StartInfusionRequest request) =>
      _client.invoke<StartInfusionResponse>(
          ctx, 'IcuService', 'StartInfusion', request, StartInfusionResponse());
  $async.Future<TitrateResponse> titrate(
          $pb.ClientContext? ctx, TitrateRequest request) =>
      _client.invoke<TitrateResponse>(
          ctx, 'IcuService', 'Titrate', request, TitrateResponse());
  $async.Future<StopInfusionResponse> stopInfusion(
          $pb.ClientContext? ctx, StopInfusionRequest request) =>
      _client.invoke<StopInfusionResponse>(
          ctx, 'IcuService', 'StopInfusion', request, StopInfusionResponse());
  $async.Future<ListInfusionsResponse> listInfusions(
          $pb.ClientContext? ctx, ListInfusionsRequest request) =>
      _client.invoke<ListInfusionsResponse>(
          ctx, 'IcuService', 'ListInfusions', request, ListInfusionsResponse());
  $async.Future<InsertDeviceResponse> insertDevice(
          $pb.ClientContext? ctx, InsertDeviceRequest request) =>
      _client.invoke<InsertDeviceResponse>(
          ctx, 'IcuService', 'InsertDevice', request, InsertDeviceResponse());
  $async.Future<RemoveDeviceResponse> removeDevice(
          $pb.ClientContext? ctx, RemoveDeviceRequest request) =>
      _client.invoke<RemoveDeviceResponse>(
          ctx, 'IcuService', 'RemoveDevice', request, RemoveDeviceResponse());
  $async.Future<ReviewDeviceResponse> reviewDevice(
          $pb.ClientContext? ctx, ReviewDeviceRequest request) =>
      _client.invoke<ReviewDeviceResponse>(
          ctx, 'IcuService', 'ReviewDevice', request, ReviewDeviceResponse());
  $async.Future<ListDevicesResponse> listDevices(
          $pb.ClientContext? ctx, ListDevicesRequest request) =>
      _client.invoke<ListDevicesResponse>(
          ctx, 'IcuService', 'ListDevices', request, ListDevicesResponse());

  /// Scores, bundles, assessments, rounds (SRS-ICU-008 … 010, SRS-ICU-014).
  $async.Future<CalculateScoreResponse> calculateScore(
          $pb.ClientContext? ctx, CalculateScoreRequest request) =>
      _client.invoke<CalculateScoreResponse>(ctx, 'IcuService',
          'CalculateScore', request, CalculateScoreResponse());
  $async.Future<ListScoresResponse> listScores(
          $pb.ClientContext? ctx, ListScoresRequest request) =>
      _client.invoke<ListScoresResponse>(
          ctx, 'IcuService', 'ListScores', request, ListScoresResponse());
  $async.Future<ReproduceScoreResponse> reproduceScore(
          $pb.ClientContext? ctx, ReproduceScoreRequest request) =>
      _client.invoke<ReproduceScoreResponse>(ctx, 'IcuService',
          'ReproduceScore', request, ReproduceScoreResponse());
  $async.Future<PerformBundleResponse> performBundle(
          $pb.ClientContext? ctx, PerformBundleRequest request) =>
      _client.invoke<PerformBundleResponse>(
          ctx, 'IcuService', 'PerformBundle', request, PerformBundleResponse());
  $async.Future<ListBundlesResponse> listBundles(
          $pb.ClientContext? ctx, ListBundlesRequest request) =>
      _client.invoke<ListBundlesResponse>(
          ctx, 'IcuService', 'ListBundles', request, ListBundlesResponse());
  $async.Future<RecordAssessmentResponse> recordAssessment(
          $pb.ClientContext? ctx, RecordAssessmentRequest request) =>
      _client.invoke<RecordAssessmentResponse>(ctx, 'IcuService',
          'RecordAssessment', request, RecordAssessmentResponse());
  $async.Future<ListDueAssessmentsResponse> listDueAssessments(
          $pb.ClientContext? ctx, ListDueAssessmentsRequest request) =>
      _client.invoke<ListDueAssessmentsResponse>(ctx, 'IcuService',
          'ListDueAssessments', request, ListDueAssessmentsResponse());
  $async.Future<RecordRoundResponse> recordRound(
          $pb.ClientContext? ctx, RecordRoundRequest request) =>
      _client.invoke<RecordRoundResponse>(
          ctx, 'IcuService', 'RecordRound', request, RecordRoundResponse());
  $async.Future<ResolveGoalResponse> resolveGoal(
          $pb.ClientContext? ctx, ResolveGoalRequest request) =>
      _client.invoke<ResolveGoalResponse>(
          ctx, 'IcuService', 'ResolveGoal', request, ResolveGoalResponse());
  $async.Future<ListOpenGoalsResponse> listOpenGoals(
          $pb.ClientContext? ctx, ListOpenGoalsRequest request) =>
      _client.invoke<ListOpenGoalsResponse>(
          ctx, 'IcuService', 'ListOpenGoals', request, ListOpenGoalsResponse());

  /// The ceiling of treatment (SRS-ICU-015).
  $async.Future<SetCeilingResponse> setCeiling(
          $pb.ClientContext? ctx, SetCeilingRequest request) =>
      _client.invoke<SetCeilingResponse>(
          ctx, 'IcuService', 'SetCeiling', request, SetCeilingResponse());
  $async.Future<GetCeilingResponse> getCeiling(
          $pb.ClientContext? ctx, GetCeilingRequest request) =>
      _client.invoke<GetCeilingResponse>(
          ctx, 'IcuService', 'GetCeiling', request, GetCeilingResponse());

  /// The dashboard, the advisory worklist and the unit's numbers
  /// (SRS-ICU-012, SRS-ICU-013, SRS-ICU-017).
  $async.Future<GetDashboardResponse> getDashboard(
          $pb.ClientContext? ctx, GetDashboardRequest request) =>
      _client.invoke<GetDashboardResponse>(
          ctx, 'IcuService', 'GetDashboard', request, GetDashboardResponse());
  $async.Future<ListAdvisoriesResponse> listAdvisories(
          $pb.ClientContext? ctx, ListAdvisoriesRequest request) =>
      _client.invoke<ListAdvisoriesResponse>(ctx, 'IcuService',
          'ListAdvisories', request, ListAdvisoriesResponse());
  $async.Future<EscalateAdvisoryResponse> escalateAdvisory(
          $pb.ClientContext? ctx, EscalateAdvisoryRequest request) =>
      _client.invoke<EscalateAdvisoryResponse>(ctx, 'IcuService',
          'EscalateAdvisory', request, EscalateAdvisoryResponse());
  $async.Future<GetUnitMetricsResponse> getUnitMetrics(
          $pb.ClientContext? ctx, GetUnitMetricsRequest request) =>
      _client.invoke<GetUnitMetricsResponse>(ctx, 'IcuService',
          'GetUnitMetrics', request, GetUnitMetricsResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
