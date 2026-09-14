// This is a generated file - do not edit.
//
// Generated from healthcare/encounter/v1/encounter.proto.

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

import 'encounter.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'encounter.pbenum.dart';

/// A coded concept from a terminology.
///
/// System and code together, never code alone: "C50" means breast cancer in
/// ICD-10 and something else in a local scheme.
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
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
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

  /// Pins the release. ICD-10 codes have been reassigned between revisions, so a
  /// code with no version is ambiguous once a decade.
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

class EncounterStatusChange extends $pb.GeneratedMessage {
  factory EncounterStatusChange({
    EncounterStatus? from,
    EncounterStatus? to,
    $0.Timestamp? at,
    $core.String? by,
    $core.String? reason,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (at != null) result.at = at;
    if (by != null) result.by = by;
    if (reason != null) result.reason = reason;
    return result;
  }

  EncounterStatusChange._();

  factory EncounterStatusChange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EncounterStatusChange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EncounterStatusChange',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aE<EncounterStatus>(1, _omitFieldNames ? '' : 'from',
        enumValues: EncounterStatus.values)
    ..aE<EncounterStatus>(2, _omitFieldNames ? '' : 'to',
        enumValues: EncounterStatus.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'at',
        subBuilder: $0.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'by')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EncounterStatusChange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EncounterStatusChange copyWith(
          void Function(EncounterStatusChange) updates) =>
      super.copyWith((message) => updates(message as EncounterStatusChange))
          as EncounterStatusChange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EncounterStatusChange create() => EncounterStatusChange._();
  @$core.override
  EncounterStatusChange createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EncounterStatusChange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EncounterStatusChange>(create);
  static EncounterStatusChange? _defaultInstance;

  @$pb.TagNumber(1)
  EncounterStatus get from => $_getN(0);
  @$pb.TagNumber(1)
  set from(EncounterStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);

  @$pb.TagNumber(2)
  EncounterStatus get to => $_getN(1);
  @$pb.TagNumber(2)
  set to(EncounterStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => $_clearField(2);

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

  @$pb.TagNumber(4)
  $core.String get by => $_getSZ(3);
  @$pb.TagNumber(4)
  set by($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearBy() => $_clearField(4);

  /// Required for cancellation, entered-in-error and any change after closure.
  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);
}

class Encounter extends $pb.GeneratedMessage {
  factory Encounter({
    $core.String? encounterId,
    $core.String? facilityId,
    $core.String? orgUnitId,
    $core.String? patientId,
    EncounterClass? class_5,
    $core.String? visitType,
    $core.String? attendingProviderId,
    $core.String? appointmentId,
    $core.String? episodeId,
    $core.String? referralId,
    $core.String? reason,
    EncounterStatus? status,
    $0.Timestamp? startedAt,
    $0.Timestamp? endedAt,
    $0.Timestamp? closedAt,
    $core.Iterable<EncounterStatusChange>? history,
    $core.String? createdBy,
    $0.Timestamp? createdAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (orgUnitId != null) result.orgUnitId = orgUnitId;
    if (patientId != null) result.patientId = patientId;
    if (class_5 != null) result.class_5 = class_5;
    if (visitType != null) result.visitType = visitType;
    if (attendingProviderId != null)
      result.attendingProviderId = attendingProviderId;
    if (appointmentId != null) result.appointmentId = appointmentId;
    if (episodeId != null) result.episodeId = episodeId;
    if (referralId != null) result.referralId = referralId;
    if (reason != null) result.reason = reason;
    if (status != null) result.status = status;
    if (startedAt != null) result.startedAt = startedAt;
    if (endedAt != null) result.endedAt = endedAt;
    if (closedAt != null) result.closedAt = closedAt;
    if (history != null) result.history.addAll(history);
    if (createdBy != null) result.createdBy = createdBy;
    if (createdAt != null) result.createdAt = createdAt;
    if (version != null) result.version = version;
    return result;
  }

  Encounter._();

  factory Encounter.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Encounter.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Encounter',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'orgUnitId')
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aE<EncounterClass>(5, _omitFieldNames ? '' : 'class',
        enumValues: EncounterClass.values)
    ..aOS(6, _omitFieldNames ? '' : 'visitType')
    ..aOS(7, _omitFieldNames ? '' : 'attendingProviderId')
    ..aOS(8, _omitFieldNames ? '' : 'appointmentId')
    ..aOS(9, _omitFieldNames ? '' : 'episodeId')
    ..aOS(10, _omitFieldNames ? '' : 'referralId')
    ..aOS(11, _omitFieldNames ? '' : 'reason')
    ..aE<EncounterStatus>(12, _omitFieldNames ? '' : 'status',
        enumValues: EncounterStatus.values)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..pPM<EncounterStatusChange>(16, _omitFieldNames ? '' : 'history',
        subBuilder: EncounterStatusChange.create)
    ..aOS(17, _omitFieldNames ? '' : 'createdBy')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(19, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Encounter clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Encounter copyWith(void Function(Encounter) updates) =>
      super.copyWith((message) => updates(message as Encounter)) as Encounter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Encounter create() => Encounter._();
  @$core.override
  Encounter createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Encounter getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Encounter>(create);
  static Encounter? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get orgUnitId => $_getSZ(2);
  @$pb.TagNumber(3)
  set orgUnitId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrgUnitId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrgUnitId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get patientId => $_getSZ(3);
  @$pb.TagNumber(4)
  set patientId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPatientId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPatientId() => $_clearField(4);

  @$pb.TagNumber(5)
  EncounterClass get class_5 => $_getN(4);
  @$pb.TagNumber(5)
  set class_5(EncounterClass value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasClass_5() => $_has(4);
  @$pb.TagNumber(5)
  void clearClass_5() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get visitType => $_getSZ(5);
  @$pb.TagNumber(6)
  set visitType($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVisitType() => $_has(5);
  @$pb.TagNumber(6)
  void clearVisitType() => $_clearField(6);

  /// The clinician responsible. One, not many: the care team holds everybody
  /// else, and a record where responsibility is diffuse is one where nobody
  /// holds it.
  @$pb.TagNumber(7)
  $core.String get attendingProviderId => $_getSZ(6);
  @$pb.TagNumber(7)
  set attendingProviderId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAttendingProviderId() => $_has(6);
  @$pb.TagNumber(7)
  void clearAttendingProviderId() => $_clearField(7);

  /// Empty for a walk-in, and empty is not an error (SRS-ENC-003).
  @$pb.TagNumber(8)
  $core.String get appointmentId => $_getSZ(7);
  @$pb.TagNumber(8)
  set appointmentId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAppointmentId() => $_has(7);
  @$pb.TagNumber(8)
  void clearAppointmentId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get episodeId => $_getSZ(8);
  @$pb.TagNumber(9)
  set episodeId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEpisodeId() => $_has(8);
  @$pb.TagNumber(9)
  void clearEpisodeId() => $_clearField(9);

  /// The external request this visit answers (SRS-ENC-010).
  @$pb.TagNumber(10)
  $core.String get referralId => $_getSZ(9);
  @$pb.TagNumber(10)
  set referralId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasReferralId() => $_has(9);
  @$pb.TagNumber(10)
  void clearReferralId() => $_clearField(10);

  /// Why the patient came, in the words recorded at the door.
  @$pb.TagNumber(11)
  $core.String get reason => $_getSZ(10);
  @$pb.TagNumber(11)
  set reason($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasReason() => $_has(10);
  @$pb.TagNumber(11)
  void clearReason() => $_clearField(11);

  @$pb.TagNumber(12)
  EncounterStatus get status => $_getN(11);
  @$pb.TagNumber(12)
  set status(EncounterStatus value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasStatus() => $_has(11);
  @$pb.TagNumber(12)
  void clearStatus() => $_clearField(12);

  /// Clinical times, independent of the appointment. Unset until the encounter
  /// begins and ends.
  @$pb.TagNumber(13)
  $0.Timestamp get startedAt => $_getN(12);
  @$pb.TagNumber(13)
  set startedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasStartedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearStartedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureStartedAt() => $_ensure(12);

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
  $0.Timestamp get closedAt => $_getN(14);
  @$pb.TagNumber(15)
  set closedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasClosedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearClosedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureClosedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $pb.PbList<EncounterStatusChange> get history => $_getList(15);

  @$pb.TagNumber(17)
  $core.String get createdBy => $_getSZ(16);
  @$pb.TagNumber(17)
  set createdBy($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasCreatedBy() => $_has(16);
  @$pb.TagNumber(17)
  void clearCreatedBy() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get createdAt => $_getN(17);
  @$pb.TagNumber(18)
  set createdAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasCreatedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearCreatedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureCreatedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $fixnum.Int64 get version => $_getI64(18);
  @$pb.TagNumber(19)
  set version($fixnum.Int64 value) => $_setInt64(18, value);
  @$pb.TagNumber(19)
  $core.bool hasVersion() => $_has(18);
  @$pb.TagNumber(19)
  void clearVersion() => $_clearField(19);
}

class Episode extends $pb.GeneratedMessage {
  factory Episode({
    $core.String? episodeId,
    $core.String? patientId,
    $core.String? facilityId,
    EpisodeType? type,
    $core.String? label,
    $core.String? careManagerId,
    EpisodeStatus? status,
    $0.Timestamp? startedAt,
    $0.Timestamp? endedAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (patientId != null) result.patientId = patientId;
    if (facilityId != null) result.facilityId = facilityId;
    if (type != null) result.type = type;
    if (label != null) result.label = label;
    if (careManagerId != null) result.careManagerId = careManagerId;
    if (status != null) result.status = status;
    if (startedAt != null) result.startedAt = startedAt;
    if (endedAt != null) result.endedAt = endedAt;
    if (version != null) result.version = version;
    return result;
  }

  Episode._();

  factory Episode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Episode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Episode',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aE<EpisodeType>(4, _omitFieldNames ? '' : 'type',
        enumValues: EpisodeType.values)
    ..aOS(5, _omitFieldNames ? '' : 'label')
    ..aOS(6, _omitFieldNames ? '' : 'careManagerId')
    ..aE<EpisodeStatus>(7, _omitFieldNames ? '' : 'status',
        enumValues: EpisodeStatus.values)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(10, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Episode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Episode copyWith(void Function(Episode) updates) =>
      super.copyWith((message) => updates(message as Episode)) as Episode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Episode create() => Episode._();
  @$core.override
  Episode createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Episode getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Episode>(create);
  static Episode? _defaultInstance;

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
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  EpisodeType get type => $_getN(3);
  @$pb.TagNumber(4)
  set type(EpisodeType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => $_clearField(4);

  /// What clinicians call it — "second pregnancy", "left breast".
  @$pb.TagNumber(5)
  $core.String get label => $_getSZ(4);
  @$pb.TagNumber(5)
  set label($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLabel() => $_has(4);
  @$pb.TagNumber(5)
  void clearLabel() => $_clearField(5);

  /// Optional: plenty of episodes are managed by a team rather than a person.
  @$pb.TagNumber(6)
  $core.String get careManagerId => $_getSZ(5);
  @$pb.TagNumber(6)
  set careManagerId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCareManagerId() => $_has(5);
  @$pb.TagNumber(6)
  void clearCareManagerId() => $_clearField(6);

  @$pb.TagNumber(7)
  EpisodeStatus get status => $_getN(6);
  @$pb.TagNumber(7)
  set status(EpisodeStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

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
  $0.Timestamp get endedAt => $_getN(8);
  @$pb.TagNumber(9)
  set endedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasEndedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearEndedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureEndedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $fixnum.Int64 get version => $_getI64(9);
  @$pb.TagNumber(10)
  set version($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVersion() => $_has(9);
  @$pb.TagNumber(10)
  void clearVersion() => $_clearField(10);
}

class CareTeamMember extends $pb.GeneratedMessage {
  factory CareTeamMember({
    $core.String? careTeamId,
    $core.String? encounterId,
    $core.String? subjectId,
    CareTeamRole? role,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? effectiveUntil,
    $core.String? assignedBy,
  }) {
    final result = create();
    if (careTeamId != null) result.careTeamId = careTeamId;
    if (encounterId != null) result.encounterId = encounterId;
    if (subjectId != null) result.subjectId = subjectId;
    if (role != null) result.role = role;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (effectiveUntil != null) result.effectiveUntil = effectiveUntil;
    if (assignedBy != null) result.assignedBy = assignedBy;
    return result;
  }

  CareTeamMember._();

  factory CareTeamMember.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CareTeamMember.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CareTeamMember',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'careTeamId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'subjectId')
    ..aE<CareTeamRole>(4, _omitFieldNames ? '' : 'role',
        enumValues: CareTeamRole.values)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'effectiveUntil',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'assignedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CareTeamMember clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CareTeamMember copyWith(void Function(CareTeamMember) updates) =>
      super.copyWith((message) => updates(message as CareTeamMember))
          as CareTeamMember;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CareTeamMember create() => CareTeamMember._();
  @$core.override
  CareTeamMember createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CareTeamMember getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CareTeamMember>(create);
  static CareTeamMember? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get careTeamId => $_getSZ(0);
  @$pb.TagNumber(1)
  set careTeamId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCareTeamId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCareTeamId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get subjectId => $_getSZ(2);
  @$pb.TagNumber(3)
  set subjectId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubjectId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubjectId() => $_clearField(3);

  @$pb.TagNumber(4)
  CareTeamRole get role => $_getN(3);
  @$pb.TagNumber(4)
  set role(CareTeamRole value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearRole() => $_clearField(4);

  /// Dated rather than a plain membership list: the question authorization asks
  /// is whether this clinician was on the team *at the time*.
  @$pb.TagNumber(5)
  $0.Timestamp get effectiveFrom => $_getN(4);
  @$pb.TagNumber(5)
  set effectiveFrom($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEffectiveFrom() => $_has(4);
  @$pb.TagNumber(5)
  void clearEffectiveFrom() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(4);

  /// Unset means still involved.
  @$pb.TagNumber(6)
  $0.Timestamp get effectiveUntil => $_getN(5);
  @$pb.TagNumber(6)
  set effectiveUntil($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEffectiveUntil() => $_has(5);
  @$pb.TagNumber(6)
  void clearEffectiveUntil() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureEffectiveUntil() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get assignedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set assignedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAssignedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearAssignedBy() => $_clearField(7);
}

class Diagnosis extends $pb.GeneratedMessage {
  factory Diagnosis({
    $core.String? diagnosisId,
    $core.String? encounterId,
    $core.String? patientId,
    Coding? code,
    DiagnosisCertainty? certainty,
    DiagnosisRank? rank,
    $core.String? note,
    $0.Timestamp? onsetAt,
    $core.String? supersededById,
    $core.String? retractedReason,
    $core.String? recordedBy,
    $0.Timestamp? recordedAt,
  }) {
    final result = create();
    if (diagnosisId != null) result.diagnosisId = diagnosisId;
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (code != null) result.code = code;
    if (certainty != null) result.certainty = certainty;
    if (rank != null) result.rank = rank;
    if (note != null) result.note = note;
    if (onsetAt != null) result.onsetAt = onsetAt;
    if (supersededById != null) result.supersededById = supersededById;
    if (retractedReason != null) result.retractedReason = retractedReason;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (recordedAt != null) result.recordedAt = recordedAt;
    return result;
  }

  Diagnosis._();

  factory Diagnosis.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Diagnosis.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Diagnosis',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'diagnosisId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'code', subBuilder: Coding.create)
    ..aE<DiagnosisCertainty>(5, _omitFieldNames ? '' : 'certainty',
        enumValues: DiagnosisCertainty.values)
    ..aE<DiagnosisRank>(6, _omitFieldNames ? '' : 'rank',
        enumValues: DiagnosisRank.values)
    ..aOS(7, _omitFieldNames ? '' : 'note')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'onsetAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'supersededById')
    ..aOS(10, _omitFieldNames ? '' : 'retractedReason')
    ..aOS(11, _omitFieldNames ? '' : 'recordedBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Diagnosis clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Diagnosis copyWith(void Function(Diagnosis) updates) =>
      super.copyWith((message) => updates(message as Diagnosis)) as Diagnosis;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Diagnosis create() => Diagnosis._();
  @$core.override
  Diagnosis createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Diagnosis getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Diagnosis>(create);
  static Diagnosis? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get diagnosisId => $_getSZ(0);
  @$pb.TagNumber(1)
  set diagnosisId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDiagnosisId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDiagnosisId() => $_clearField(1);

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
  DiagnosisCertainty get certainty => $_getN(4);
  @$pb.TagNumber(5)
  set certainty(DiagnosisCertainty value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCertainty() => $_has(4);
  @$pb.TagNumber(5)
  void clearCertainty() => $_clearField(5);

  @$pb.TagNumber(6)
  DiagnosisRank get rank => $_getN(5);
  @$pb.TagNumber(6)
  set rank(DiagnosisRank value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRank() => $_has(5);
  @$pb.TagNumber(6)
  void clearRank() => $_clearField(6);

  /// The clinician's qualification of the code — "left side", "since 2019".
  @$pb.TagNumber(7)
  $core.String get note => $_getSZ(6);
  @$pb.TagNumber(7)
  set note($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearNote() => $_clearField(7);

  /// When the condition began, where known. Distinct from recorded_at: a
  /// diagnosis of an illness that started last month is not a diagnosis made
  /// last month.
  @$pb.TagNumber(8)
  $0.Timestamp get onsetAt => $_getN(7);
  @$pb.TagNumber(8)
  set onsetAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasOnsetAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearOnsetAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureOnsetAt() => $_ensure(7);

  /// Chains to the entry that replaced this one, so the trail reads forwards.
  @$pb.TagNumber(9)
  $core.String get supersededById => $_getSZ(8);
  @$pb.TagNumber(9)
  set supersededById($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSupersededById() => $_has(8);
  @$pb.TagNumber(9)
  void clearSupersededById() => $_clearField(9);

  /// Distinct from superseded: superseded means the thinking moved on, retracted
  /// means this was never true of this patient.
  @$pb.TagNumber(10)
  $core.String get retractedReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set retractedReason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRetractedReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearRetractedReason() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get recordedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set recordedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRecordedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearRecordedBy() => $_clearField(11);

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
}

/// What closing an encounter produces (SRS-ENC-009).
///
/// Stored rather than rendered on demand: a summary rendered on demand shows
/// today's chart, so a patient handed a printout in March and a clinician
/// looking at the same "summary" in June see different documents with the same
/// name.
class VisitSummary extends $pb.GeneratedMessage {
  factory VisitSummary({
    $core.String? summaryId,
    $core.String? encounterId,
    $core.String? patientId,
    $core.int? version,
    $core.String? supersedesId,
    $core.String? amendmentReason,
    EncounterClass? class_7,
    $0.Timestamp? startedAt,
    $0.Timestamp? endedAt,
    $core.Iterable<Coding>? diagnoses,
    $core.Iterable<$core.String>? careTeam,
    $core.String? narrative,
    $core.String? generatedBy,
    $0.Timestamp? generatedAt,
  }) {
    final result = create();
    if (summaryId != null) result.summaryId = summaryId;
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (version != null) result.version = version;
    if (supersedesId != null) result.supersedesId = supersedesId;
    if (amendmentReason != null) result.amendmentReason = amendmentReason;
    if (class_7 != null) result.class_7 = class_7;
    if (startedAt != null) result.startedAt = startedAt;
    if (endedAt != null) result.endedAt = endedAt;
    if (diagnoses != null) result.diagnoses.addAll(diagnoses);
    if (careTeam != null) result.careTeam.addAll(careTeam);
    if (narrative != null) result.narrative = narrative;
    if (generatedBy != null) result.generatedBy = generatedBy;
    if (generatedAt != null) result.generatedAt = generatedAt;
    return result;
  }

  VisitSummary._();

  factory VisitSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VisitSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VisitSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'summaryId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aI(4, _omitFieldNames ? '' : 'version')
    ..aOS(5, _omitFieldNames ? '' : 'supersedesId')
    ..aOS(6, _omitFieldNames ? '' : 'amendmentReason')
    ..aE<EncounterClass>(7, _omitFieldNames ? '' : 'class',
        enumValues: EncounterClass.values)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..pPM<Coding>(10, _omitFieldNames ? '' : 'diagnoses',
        subBuilder: Coding.create)
    ..pPS(11, _omitFieldNames ? '' : 'careTeam')
    ..aOS(12, _omitFieldNames ? '' : 'narrative')
    ..aOS(13, _omitFieldNames ? '' : 'generatedBy')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'generatedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VisitSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VisitSummary copyWith(void Function(VisitSummary) updates) =>
      super.copyWith((message) => updates(message as VisitSummary))
          as VisitSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VisitSummary create() => VisitSummary._();
  @$core.override
  VisitSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VisitSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VisitSummary>(create);
  static VisitSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get summaryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set summaryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSummaryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummaryId() => $_clearField(1);

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

  /// Starts at 1 and increments with each amendment. The original is never
  /// replaced.
  @$pb.TagNumber(4)
  $core.int get version => $_getIZ(3);
  @$pb.TagNumber(4)
  set version($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get supersedesId => $_getSZ(4);
  @$pb.TagNumber(5)
  set supersedesId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSupersedesId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSupersedesId() => $_clearField(5);

  /// Empty on version 1. An amendment with no reason is indistinguishable from a
  /// rewrite, and a rewrite is what SRS-ENC-009 forbids.
  @$pb.TagNumber(6)
  $core.String get amendmentReason => $_getSZ(5);
  @$pb.TagNumber(6)
  set amendmentReason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAmendmentReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearAmendmentReason() => $_clearField(6);

  @$pb.TagNumber(7)
  EncounterClass get class_7 => $_getN(6);
  @$pb.TagNumber(7)
  set class_7(EncounterClass value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasClass_7() => $_has(6);
  @$pb.TagNumber(7)
  void clearClass_7() => $_clearField(7);

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
  $0.Timestamp get endedAt => $_getN(8);
  @$pb.TagNumber(9)
  set endedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasEndedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearEndedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureEndedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $pb.PbList<Coding> get diagnoses => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get careTeam => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get narrative => $_getSZ(11);
  @$pb.TagNumber(12)
  set narrative($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasNarrative() => $_has(11);
  @$pb.TagNumber(12)
  void clearNarrative() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get generatedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set generatedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasGeneratedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearGeneratedBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get generatedAt => $_getN(13);
  @$pb.TagNumber(14)
  set generatedAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasGeneratedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearGeneratedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureGeneratedAt() => $_ensure(13);
}

/// One thing that happened, as the timeline shows it (SRS-ENC-011).
class TimelineEntry extends $pb.GeneratedMessage {
  factory TimelineEntry({
    $core.String? entryId,
    TimelineEntryKind? kind,
    $0.Timestamp? at,
    $core.String? encounterId,
    $core.String? title,
    Confidentiality? confidentiality,
    $core.bool? masked,
  }) {
    final result = create();
    if (entryId != null) result.entryId = entryId;
    if (kind != null) result.kind = kind;
    if (at != null) result.at = at;
    if (encounterId != null) result.encounterId = encounterId;
    if (title != null) result.title = title;
    if (confidentiality != null) result.confidentiality = confidentiality;
    if (masked != null) result.masked = masked;
    return result;
  }

  TimelineEntry._();

  factory TimelineEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TimelineEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TimelineEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'entryId')
    ..aE<TimelineEntryKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: TimelineEntryKind.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'at',
        subBuilder: $0.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'encounterId')
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..aE<Confidentiality>(6, _omitFieldNames ? '' : 'confidentiality',
        enumValues: Confidentiality.values)
    ..aOB(7, _omitFieldNames ? '' : 'masked')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimelineEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimelineEntry copyWith(void Function(TimelineEntry) updates) =>
      super.copyWith((message) => updates(message as TimelineEntry))
          as TimelineEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TimelineEntry create() => TimelineEntry._();
  @$core.override
  TimelineEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TimelineEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TimelineEntry>(create);
  static TimelineEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set entryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntryId() => $_clearField(1);

  @$pb.TagNumber(2)
  TimelineEntryKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(TimelineEntryKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  /// When the thing happened clinically, not when it was typed.
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

  @$pb.TagNumber(4)
  $core.String get encounterId => $_getSZ(3);
  @$pb.TagNumber(4)
  set encounterId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEncounterId() => $_has(3);
  @$pb.TagNumber(4)
  void clearEncounterId() => $_clearField(4);

  /// A short label. Never a result value or a diagnosis text: a title is
  /// rendered in list views that a masked entry still appears in.
  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  Confidentiality get confidentiality => $_getN(5);
  @$pb.TagNumber(6)
  set confidentiality(Confidentiality value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasConfidentiality() => $_has(5);
  @$pb.TagNumber(6)
  void clearConfidentiality() => $_clearField(6);

  /// An entry the reader may know exists but may not read. A masked entry keeps
  /// its kind and time and loses its title, so a chart shows that something is
  /// there without saying what.
  @$pb.TagNumber(7)
  $core.bool get masked => $_getBF(6);
  @$pb.TagNumber(7)
  set masked($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMasked() => $_has(6);
  @$pb.TagNumber(7)
  void clearMasked() => $_clearField(7);
}

/// What a facility requires before an encounter can be closed (SRS-ENC-008).
class ClosurePolicyForClass extends $pb.GeneratedMessage {
  factory ClosurePolicyForClass({
    EncounterClass? class_1,
    $core.Iterable<$core.String>? requiredItems,
    $core.bool? allowOverride,
  }) {
    final result = create();
    if (class_1 != null) result.class_1 = class_1;
    if (requiredItems != null) result.requiredItems.addAll(requiredItems);
    if (allowOverride != null) result.allowOverride = allowOverride;
    return result;
  }

  ClosurePolicyForClass._();

  factory ClosurePolicyForClass.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClosurePolicyForClass.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClosurePolicyForClass',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aE<EncounterClass>(1, _omitFieldNames ? '' : 'class',
        enumValues: EncounterClass.values)
    ..pPS(2, _omitFieldNames ? '' : 'requiredItems')
    ..aOB(3, _omitFieldNames ? '' : 'allowOverride')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClosurePolicyForClass clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClosurePolicyForClass copyWith(
          void Function(ClosurePolicyForClass) updates) =>
      super.copyWith((message) => updates(message as ClosurePolicyForClass))
          as ClosurePolicyForClass;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClosurePolicyForClass create() => ClosurePolicyForClass._();
  @$core.override
  ClosurePolicyForClass createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClosurePolicyForClass getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClosurePolicyForClass>(create);
  static ClosurePolicyForClass? _defaultInstance;

  @$pb.TagNumber(1)
  EncounterClass get class_1 => $_getN(0);
  @$pb.TagNumber(1)
  set class_1(EncounterClass value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasClass_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearClass_1() => $_clearField(1);

  /// Item keys: final_diagnosis, signed_note, attending_provider, end_time,
  /// discharge_disposition.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get requiredItems => $_getList(1);

  /// Per class, because the judgement differs: an emergency department that
  /// cannot close a resuscitation until the notes are perfect will simply leave
  /// it open, and an open encounter reads as a patient still under care.
  @$pb.TagNumber(3)
  $core.bool get allowOverride => $_getBF(2);
  @$pb.TagNumber(3)
  set allowOverride($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAllowOverride() => $_has(2);
  @$pb.TagNumber(3)
  void clearAllowOverride() => $_clearField(3);
}

/// A finalisation forced over an incomplete record (SRS-ENC-008).
class ClosureOverride extends $pb.GeneratedMessage {
  factory ClosureOverride({
    $core.String? overrideId,
    $core.String? encounterId,
    $core.Iterable<$core.String>? missingItems,
    $core.String? reason,
    $core.String? overriddenBy,
    $0.Timestamp? overriddenAt,
  }) {
    final result = create();
    if (overrideId != null) result.overrideId = overrideId;
    if (encounterId != null) result.encounterId = encounterId;
    if (missingItems != null) result.missingItems.addAll(missingItems);
    if (reason != null) result.reason = reason;
    if (overriddenBy != null) result.overriddenBy = overriddenBy;
    if (overriddenAt != null) result.overriddenAt = overriddenAt;
    return result;
  }

  ClosureOverride._();

  factory ClosureOverride.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClosureOverride.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClosureOverride',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'overrideId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..pPS(3, _omitFieldNames ? '' : 'missingItems')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aOS(5, _omitFieldNames ? '' : 'overriddenBy')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'overriddenAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClosureOverride clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClosureOverride copyWith(void Function(ClosureOverride) updates) =>
      super.copyWith((message) => updates(message as ClosureOverride))
          as ClosureOverride;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClosureOverride create() => ClosureOverride._();
  @$core.override
  ClosureOverride createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClosureOverride getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClosureOverride>(create);
  static ClosureOverride? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get overrideId => $_getSZ(0);
  @$pb.TagNumber(1)
  set overrideId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOverrideId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOverrideId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  /// What was outstanding at the moment of the override, captured then rather
  /// than recomputed later.
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get missingItems => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get overriddenBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set overriddenBy($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOverriddenBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearOverriddenBy() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get overriddenAt => $_getN(5);
  @$pb.TagNumber(6)
  set overriddenAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOverriddenAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearOverriddenAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureOverriddenAt() => $_ensure(5);
}

class OpenEncounterRequest extends $pb.GeneratedMessage {
  factory OpenEncounterRequest({
    $core.String? patientId,
    $core.String? facilityId,
    $core.String? orgUnitId,
    EncounterClass? class_4,
    $core.String? visitType,
    $core.String? attendingProviderId,
    $core.String? appointmentId,
    $core.String? episodeId,
    $core.String? referralId,
    $core.String? reason,
    $core.bool? startImmediately,
    $0.Timestamp? startedAt,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (facilityId != null) result.facilityId = facilityId;
    if (orgUnitId != null) result.orgUnitId = orgUnitId;
    if (class_4 != null) result.class_4 = class_4;
    if (visitType != null) result.visitType = visitType;
    if (attendingProviderId != null)
      result.attendingProviderId = attendingProviderId;
    if (appointmentId != null) result.appointmentId = appointmentId;
    if (episodeId != null) result.episodeId = episodeId;
    if (referralId != null) result.referralId = referralId;
    if (reason != null) result.reason = reason;
    if (startImmediately != null) result.startImmediately = startImmediately;
    if (startedAt != null) result.startedAt = startedAt;
    return result;
  }

  OpenEncounterRequest._();

  factory OpenEncounterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenEncounterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenEncounterRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'orgUnitId')
    ..aE<EncounterClass>(4, _omitFieldNames ? '' : 'class',
        enumValues: EncounterClass.values)
    ..aOS(5, _omitFieldNames ? '' : 'visitType')
    ..aOS(6, _omitFieldNames ? '' : 'attendingProviderId')
    ..aOS(7, _omitFieldNames ? '' : 'appointmentId')
    ..aOS(8, _omitFieldNames ? '' : 'episodeId')
    ..aOS(9, _omitFieldNames ? '' : 'referralId')
    ..aOS(10, _omitFieldNames ? '' : 'reason')
    ..aOB(11, _omitFieldNames ? '' : 'startImmediately')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenEncounterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenEncounterRequest copyWith(void Function(OpenEncounterRequest) updates) =>
      super.copyWith((message) => updates(message as OpenEncounterRequest))
          as OpenEncounterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenEncounterRequest create() => OpenEncounterRequest._();
  @$core.override
  OpenEncounterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenEncounterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenEncounterRequest>(create);
  static OpenEncounterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get orgUnitId => $_getSZ(2);
  @$pb.TagNumber(3)
  set orgUnitId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrgUnitId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrgUnitId() => $_clearField(3);

  @$pb.TagNumber(4)
  EncounterClass get class_4 => $_getN(3);
  @$pb.TagNumber(4)
  set class_4(EncounterClass value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasClass_4() => $_has(3);
  @$pb.TagNumber(4)
  void clearClass_4() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get visitType => $_getSZ(4);
  @$pb.TagNumber(5)
  set visitType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVisitType() => $_has(4);
  @$pb.TagNumber(5)
  void clearVisitType() => $_clearField(5);

  /// Required for every class but diagnostic-only.
  @$pb.TagNumber(6)
  $core.String get attendingProviderId => $_getSZ(5);
  @$pb.TagNumber(6)
  set attendingProviderId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAttendingProviderId() => $_has(5);
  @$pb.TagNumber(6)
  void clearAttendingProviderId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get appointmentId => $_getSZ(6);
  @$pb.TagNumber(7)
  set appointmentId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAppointmentId() => $_has(6);
  @$pb.TagNumber(7)
  void clearAppointmentId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get episodeId => $_getSZ(7);
  @$pb.TagNumber(8)
  set episodeId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEpisodeId() => $_has(7);
  @$pb.TagNumber(8)
  void clearEpisodeId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get referralId => $_getSZ(8);
  @$pb.TagNumber(9)
  set referralId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReferralId() => $_has(8);
  @$pb.TagNumber(9)
  void clearReferralId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get reason => $_getSZ(9);
  @$pb.TagNumber(10)
  set reason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearReason() => $_clearField(10);

  /// Begins the encounter in the same call, which is what a consultation
  /// actually looks like. A planned encounter is the exception — a scheduled
  /// admission days ahead.
  @$pb.TagNumber(11)
  $core.bool get startImmediately => $_getBF(10);
  @$pb.TagNumber(11)
  set startImmediately($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasStartImmediately() => $_has(10);
  @$pb.TagNumber(11)
  void clearStartImmediately() => $_clearField(11);

  /// When the patient was actually seen, for a late entry.
  @$pb.TagNumber(12)
  $0.Timestamp get startedAt => $_getN(11);
  @$pb.TagNumber(12)
  set startedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasStartedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearStartedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureStartedAt() => $_ensure(11);
}

class OpenEncounterResponse extends $pb.GeneratedMessage {
  factory OpenEncounterResponse({
    Encounter? encounter,
  }) {
    final result = create();
    if (encounter != null) result.encounter = encounter;
    return result;
  }

  OpenEncounterResponse._();

  factory OpenEncounterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenEncounterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenEncounterResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOM<Encounter>(1, _omitFieldNames ? '' : 'encounter',
        subBuilder: Encounter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenEncounterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenEncounterResponse copyWith(
          void Function(OpenEncounterResponse) updates) =>
      super.copyWith((message) => updates(message as OpenEncounterResponse))
          as OpenEncounterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenEncounterResponse create() => OpenEncounterResponse._();
  @$core.override
  OpenEncounterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenEncounterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenEncounterResponse>(create);
  static OpenEncounterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Encounter get encounter => $_getN(0);
  @$pb.TagNumber(1)
  set encounter(Encounter value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounter() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounter() => $_clearField(1);
  @$pb.TagNumber(1)
  Encounter ensureEncounter() => $_ensure(0);
}

class StartEncounterRequest extends $pb.GeneratedMessage {
  factory StartEncounterRequest({
    $core.String? encounterId,
    $0.Timestamp? startedAt,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (startedAt != null) result.startedAt = startedAt;
    return result;
  }

  StartEncounterRequest._();

  factory StartEncounterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartEncounterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartEncounterRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartEncounterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartEncounterRequest copyWith(
          void Function(StartEncounterRequest) updates) =>
      super.copyWith((message) => updates(message as StartEncounterRequest))
          as StartEncounterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartEncounterRequest create() => StartEncounterRequest._();
  @$core.override
  StartEncounterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartEncounterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartEncounterRequest>(create);
  static StartEncounterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get startedAt => $_getN(1);
  @$pb.TagNumber(2)
  set startedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStartedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureStartedAt() => $_ensure(1);
}

class StartEncounterResponse extends $pb.GeneratedMessage {
  factory StartEncounterResponse({
    Encounter? encounter,
  }) {
    final result = create();
    if (encounter != null) result.encounter = encounter;
    return result;
  }

  StartEncounterResponse._();

  factory StartEncounterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartEncounterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartEncounterResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOM<Encounter>(1, _omitFieldNames ? '' : 'encounter',
        subBuilder: Encounter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartEncounterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartEncounterResponse copyWith(
          void Function(StartEncounterResponse) updates) =>
      super.copyWith((message) => updates(message as StartEncounterResponse))
          as StartEncounterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartEncounterResponse create() => StartEncounterResponse._();
  @$core.override
  StartEncounterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartEncounterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartEncounterResponse>(create);
  static StartEncounterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Encounter get encounter => $_getN(0);
  @$pb.TagNumber(1)
  set encounter(Encounter value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounter() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounter() => $_clearField(1);
  @$pb.TagNumber(1)
  Encounter ensureEncounter() => $_ensure(0);
}

class EndEncounterRequest extends $pb.GeneratedMessage {
  factory EndEncounterRequest({
    $core.String? encounterId,
    $0.Timestamp? endedAt,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (endedAt != null) result.endedAt = endedAt;
    return result;
  }

  EndEncounterRequest._();

  factory EndEncounterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndEncounterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndEncounterRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndEncounterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndEncounterRequest copyWith(void Function(EndEncounterRequest) updates) =>
      super.copyWith((message) => updates(message as EndEncounterRequest))
          as EndEncounterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndEncounterRequest create() => EndEncounterRequest._();
  @$core.override
  EndEncounterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndEncounterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndEncounterRequest>(create);
  static EndEncounterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

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

class EndEncounterResponse extends $pb.GeneratedMessage {
  factory EndEncounterResponse({
    Encounter? encounter,
  }) {
    final result = create();
    if (encounter != null) result.encounter = encounter;
    return result;
  }

  EndEncounterResponse._();

  factory EndEncounterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndEncounterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndEncounterResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOM<Encounter>(1, _omitFieldNames ? '' : 'encounter',
        subBuilder: Encounter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndEncounterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndEncounterResponse copyWith(void Function(EndEncounterResponse) updates) =>
      super.copyWith((message) => updates(message as EndEncounterResponse))
          as EndEncounterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndEncounterResponse create() => EndEncounterResponse._();
  @$core.override
  EndEncounterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndEncounterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndEncounterResponse>(create);
  static EndEncounterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Encounter get encounter => $_getN(0);
  @$pb.TagNumber(1)
  set encounter(Encounter value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounter() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounter() => $_clearField(1);
  @$pb.TagNumber(1)
  Encounter ensureEncounter() => $_ensure(0);
}

class CancelEncounterRequest extends $pb.GeneratedMessage {
  factory CancelEncounterRequest({
    $core.String? encounterId,
    $core.String? reason,
    $core.bool? enteredInError,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (reason != null) result.reason = reason;
    if (enteredInError != null) result.enteredInError = enteredInError;
    return result;
  }

  CancelEncounterRequest._();

  factory CancelEncounterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelEncounterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelEncounterRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOB(3, _omitFieldNames ? '' : 'enteredInError')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelEncounterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelEncounterRequest copyWith(
          void Function(CancelEncounterRequest) updates) =>
      super.copyWith((message) => updates(message as CancelEncounterRequest))
          as CancelEncounterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelEncounterRequest create() => CancelEncounterRequest._();
  @$core.override
  CancelEncounterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelEncounterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelEncounterRequest>(create);
  static CancelEncounterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  /// Marks a record that should never have existed rather than a visit that did
  /// not take place.
  @$pb.TagNumber(3)
  $core.bool get enteredInError => $_getBF(2);
  @$pb.TagNumber(3)
  set enteredInError($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEnteredInError() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnteredInError() => $_clearField(3);
}

class CancelEncounterResponse extends $pb.GeneratedMessage {
  factory CancelEncounterResponse({
    Encounter? encounter,
  }) {
    final result = create();
    if (encounter != null) result.encounter = encounter;
    return result;
  }

  CancelEncounterResponse._();

  factory CancelEncounterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelEncounterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelEncounterResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOM<Encounter>(1, _omitFieldNames ? '' : 'encounter',
        subBuilder: Encounter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelEncounterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelEncounterResponse copyWith(
          void Function(CancelEncounterResponse) updates) =>
      super.copyWith((message) => updates(message as CancelEncounterResponse))
          as CancelEncounterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelEncounterResponse create() => CancelEncounterResponse._();
  @$core.override
  CancelEncounterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelEncounterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelEncounterResponse>(create);
  static CancelEncounterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Encounter get encounter => $_getN(0);
  @$pb.TagNumber(1)
  set encounter(Encounter value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounter() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounter() => $_clearField(1);
  @$pb.TagNumber(1)
  Encounter ensureEncounter() => $_ensure(0);
}

class ReopenEncounterRequest extends $pb.GeneratedMessage {
  factory ReopenEncounterRequest({
    $core.String? encounterId,
    $core.String? reason,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (reason != null) result.reason = reason;
    return result;
  }

  ReopenEncounterRequest._();

  factory ReopenEncounterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReopenEncounterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReopenEncounterRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReopenEncounterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReopenEncounterRequest copyWith(
          void Function(ReopenEncounterRequest) updates) =>
      super.copyWith((message) => updates(message as ReopenEncounterRequest))
          as ReopenEncounterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReopenEncounterRequest create() => ReopenEncounterRequest._();
  @$core.override
  ReopenEncounterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReopenEncounterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReopenEncounterRequest>(create);
  static ReopenEncounterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class ReopenEncounterResponse extends $pb.GeneratedMessage {
  factory ReopenEncounterResponse({
    Encounter? encounter,
  }) {
    final result = create();
    if (encounter != null) result.encounter = encounter;
    return result;
  }

  ReopenEncounterResponse._();

  factory ReopenEncounterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReopenEncounterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReopenEncounterResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOM<Encounter>(1, _omitFieldNames ? '' : 'encounter',
        subBuilder: Encounter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReopenEncounterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReopenEncounterResponse copyWith(
          void Function(ReopenEncounterResponse) updates) =>
      super.copyWith((message) => updates(message as ReopenEncounterResponse))
          as ReopenEncounterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReopenEncounterResponse create() => ReopenEncounterResponse._();
  @$core.override
  ReopenEncounterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReopenEncounterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReopenEncounterResponse>(create);
  static ReopenEncounterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Encounter get encounter => $_getN(0);
  @$pb.TagNumber(1)
  set encounter(Encounter value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounter() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounter() => $_clearField(1);
  @$pb.TagNumber(1)
  Encounter ensureEncounter() => $_ensure(0);
}

class SetEncounterLeaveRequest extends $pb.GeneratedMessage {
  factory SetEncounterLeaveRequest({
    $core.String? encounterId,
    $core.String? reason,
    $core.bool? returning,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (reason != null) result.reason = reason;
    if (returning != null) result.returning = returning;
    return result;
  }

  SetEncounterLeaveRequest._();

  factory SetEncounterLeaveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetEncounterLeaveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetEncounterLeaveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOB(3, _omitFieldNames ? '' : 'returning')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetEncounterLeaveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetEncounterLeaveRequest copyWith(
          void Function(SetEncounterLeaveRequest) updates) =>
      super.copyWith((message) => updates(message as SetEncounterLeaveRequest))
          as SetEncounterLeaveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetEncounterLeaveRequest create() => SetEncounterLeaveRequest._();
  @$core.override
  SetEncounterLeaveRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetEncounterLeaveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetEncounterLeaveRequest>(create);
  static SetEncounterLeaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  /// Brings the patient back from leave.
  @$pb.TagNumber(3)
  $core.bool get returning => $_getBF(2);
  @$pb.TagNumber(3)
  set returning($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReturning() => $_has(2);
  @$pb.TagNumber(3)
  void clearReturning() => $_clearField(3);
}

class SetEncounterLeaveResponse extends $pb.GeneratedMessage {
  factory SetEncounterLeaveResponse({
    Encounter? encounter,
  }) {
    final result = create();
    if (encounter != null) result.encounter = encounter;
    return result;
  }

  SetEncounterLeaveResponse._();

  factory SetEncounterLeaveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetEncounterLeaveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetEncounterLeaveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOM<Encounter>(1, _omitFieldNames ? '' : 'encounter',
        subBuilder: Encounter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetEncounterLeaveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetEncounterLeaveResponse copyWith(
          void Function(SetEncounterLeaveResponse) updates) =>
      super.copyWith((message) => updates(message as SetEncounterLeaveResponse))
          as SetEncounterLeaveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetEncounterLeaveResponse create() => SetEncounterLeaveResponse._();
  @$core.override
  SetEncounterLeaveResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetEncounterLeaveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetEncounterLeaveResponse>(create);
  static SetEncounterLeaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Encounter get encounter => $_getN(0);
  @$pb.TagNumber(1)
  set encounter(Encounter value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounter() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounter() => $_clearField(1);
  @$pb.TagNumber(1)
  Encounter ensureEncounter() => $_ensure(0);
}

class GetEncounterRequest extends $pb.GeneratedMessage {
  factory GetEncounterRequest({
    $core.String? encounterId,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    return result;
  }

  GetEncounterRequest._();

  factory GetEncounterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetEncounterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetEncounterRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEncounterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEncounterRequest copyWith(void Function(GetEncounterRequest) updates) =>
      super.copyWith((message) => updates(message as GetEncounterRequest))
          as GetEncounterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetEncounterRequest create() => GetEncounterRequest._();
  @$core.override
  GetEncounterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetEncounterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetEncounterRequest>(create);
  static GetEncounterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);
}

class GetEncounterResponse extends $pb.GeneratedMessage {
  factory GetEncounterResponse({
    Encounter? encounter,
  }) {
    final result = create();
    if (encounter != null) result.encounter = encounter;
    return result;
  }

  GetEncounterResponse._();

  factory GetEncounterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetEncounterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetEncounterResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOM<Encounter>(1, _omitFieldNames ? '' : 'encounter',
        subBuilder: Encounter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEncounterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEncounterResponse copyWith(void Function(GetEncounterResponse) updates) =>
      super.copyWith((message) => updates(message as GetEncounterResponse))
          as GetEncounterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetEncounterResponse create() => GetEncounterResponse._();
  @$core.override
  GetEncounterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetEncounterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetEncounterResponse>(create);
  static GetEncounterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Encounter get encounter => $_getN(0);
  @$pb.TagNumber(1)
  set encounter(Encounter value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounter() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounter() => $_clearField(1);
  @$pb.TagNumber(1)
  Encounter ensureEncounter() => $_ensure(0);
}

class ListEncountersRequest extends $pb.GeneratedMessage {
  factory ListEncountersRequest({
    $core.String? patientId,
    $core.String? facilityId,
    $core.String? episodeId,
    EncounterClass? class_4,
    $core.bool? includeRetracted,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (facilityId != null) result.facilityId = facilityId;
    if (episodeId != null) result.episodeId = episodeId;
    if (class_4 != null) result.class_4 = class_4;
    if (includeRetracted != null) result.includeRetracted = includeRetracted;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListEncountersRequest._();

  factory ListEncountersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListEncountersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEncountersRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'episodeId')
    ..aE<EncounterClass>(4, _omitFieldNames ? '' : 'class',
        enumValues: EncounterClass.values)
    ..aOB(5, _omitFieldNames ? '' : 'includeRetracted')
    ..aI(6, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEncountersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEncountersRequest copyWith(
          void Function(ListEncountersRequest) updates) =>
      super.copyWith((message) => updates(message as ListEncountersRequest))
          as ListEncountersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListEncountersRequest create() => ListEncountersRequest._();
  @$core.override
  ListEncountersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListEncountersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListEncountersRequest>(create);
  static ListEncountersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  /// Returns the encounters still under way — the ward round. Mutually exclusive
  /// with patient_id.
  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get episodeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set episodeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEpisodeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEpisodeId() => $_clearField(3);

  @$pb.TagNumber(4)
  EncounterClass get class_4 => $_getN(3);
  @$pb.TagNumber(4)
  set class_4(EncounterClass value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasClass_4() => $_has(3);
  @$pb.TagNumber(4)
  void clearClass_4() => $_clearField(4);

  /// Shows entered-in-error encounters. Off by default: a record that was never
  /// true should not appear in a clinical chronology unless somebody is
  /// investigating precisely that.
  @$pb.TagNumber(5)
  $core.bool get includeRetracted => $_getBF(4);
  @$pb.TagNumber(5)
  set includeRetracted($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIncludeRetracted() => $_has(4);
  @$pb.TagNumber(5)
  void clearIncludeRetracted() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get pageSize => $_getIZ(5);
  @$pb.TagNumber(6)
  set pageSize($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageSize() => $_clearField(6);
}

class ListEncountersResponse extends $pb.GeneratedMessage {
  factory ListEncountersResponse({
    $core.Iterable<Encounter>? encounters,
  }) {
    final result = create();
    if (encounters != null) result.encounters.addAll(encounters);
    return result;
  }

  ListEncountersResponse._();

  factory ListEncountersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListEncountersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEncountersResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..pPM<Encounter>(1, _omitFieldNames ? '' : 'encounters',
        subBuilder: Encounter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEncountersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEncountersResponse copyWith(
          void Function(ListEncountersResponse) updates) =>
      super.copyWith((message) => updates(message as ListEncountersResponse))
          as ListEncountersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListEncountersResponse create() => ListEncountersResponse._();
  @$core.override
  ListEncountersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListEncountersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListEncountersResponse>(create);
  static ListEncountersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Encounter> get encounters => $_getList(0);
}

class OpenEpisodeRequest extends $pb.GeneratedMessage {
  factory OpenEpisodeRequest({
    $core.String? patientId,
    $core.String? facilityId,
    EpisodeType? type,
    $core.String? label,
    $core.String? careManagerId,
    $0.Timestamp? startedAt,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (facilityId != null) result.facilityId = facilityId;
    if (type != null) result.type = type;
    if (label != null) result.label = label;
    if (careManagerId != null) result.careManagerId = careManagerId;
    if (startedAt != null) result.startedAt = startedAt;
    return result;
  }

  OpenEpisodeRequest._();

  factory OpenEpisodeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenEpisodeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenEpisodeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aE<EpisodeType>(3, _omitFieldNames ? '' : 'type',
        enumValues: EpisodeType.values)
    ..aOS(4, _omitFieldNames ? '' : 'label')
    ..aOS(5, _omitFieldNames ? '' : 'careManagerId')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenEpisodeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenEpisodeRequest copyWith(void Function(OpenEpisodeRequest) updates) =>
      super.copyWith((message) => updates(message as OpenEpisodeRequest))
          as OpenEpisodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenEpisodeRequest create() => OpenEpisodeRequest._();
  @$core.override
  OpenEpisodeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenEpisodeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenEpisodeRequest>(create);
  static OpenEpisodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  EpisodeType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(EpisodeType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get label => $_getSZ(3);
  @$pb.TagNumber(4)
  set label($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLabel() => $_has(3);
  @$pb.TagNumber(4)
  void clearLabel() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get careManagerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set careManagerId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCareManagerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCareManagerId() => $_clearField(5);

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
}

class OpenEpisodeResponse extends $pb.GeneratedMessage {
  factory OpenEpisodeResponse({
    Episode? episode,
  }) {
    final result = create();
    if (episode != null) result.episode = episode;
    return result;
  }

  OpenEpisodeResponse._();

  factory OpenEpisodeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenEpisodeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenEpisodeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOM<Episode>(1, _omitFieldNames ? '' : 'episode',
        subBuilder: Episode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenEpisodeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenEpisodeResponse copyWith(void Function(OpenEpisodeResponse) updates) =>
      super.copyWith((message) => updates(message as OpenEpisodeResponse))
          as OpenEpisodeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenEpisodeResponse create() => OpenEpisodeResponse._();
  @$core.override
  OpenEpisodeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenEpisodeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenEpisodeResponse>(create);
  static OpenEpisodeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Episode get episode => $_getN(0);
  @$pb.TagNumber(1)
  set episode(Episode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisode() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisode() => $_clearField(1);
  @$pb.TagNumber(1)
  Episode ensureEpisode() => $_ensure(0);
}

class SetEpisodeStatusRequest extends $pb.GeneratedMessage {
  factory SetEpisodeStatusRequest({
    $core.String? episodeId,
    EpisodeStatus? status,
    $0.Timestamp? endedAt,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (status != null) result.status = status;
    if (endedAt != null) result.endedAt = endedAt;
    return result;
  }

  SetEpisodeStatusRequest._();

  factory SetEpisodeStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetEpisodeStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetEpisodeStatusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aE<EpisodeStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: EpisodeStatus.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetEpisodeStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetEpisodeStatusRequest copyWith(
          void Function(SetEpisodeStatusRequest) updates) =>
      super.copyWith((message) => updates(message as SetEpisodeStatusRequest))
          as SetEpisodeStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetEpisodeStatusRequest create() => SetEpisodeStatusRequest._();
  @$core.override
  SetEpisodeStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetEpisodeStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetEpisodeStatusRequest>(create);
  static SetEpisodeStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  EpisodeStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(EpisodeStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get endedAt => $_getN(2);
  @$pb.TagNumber(3)
  set endedAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEndedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureEndedAt() => $_ensure(2);
}

class SetEpisodeStatusResponse extends $pb.GeneratedMessage {
  factory SetEpisodeStatusResponse({
    Episode? episode,
  }) {
    final result = create();
    if (episode != null) result.episode = episode;
    return result;
  }

  SetEpisodeStatusResponse._();

  factory SetEpisodeStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetEpisodeStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetEpisodeStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOM<Episode>(1, _omitFieldNames ? '' : 'episode',
        subBuilder: Episode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetEpisodeStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetEpisodeStatusResponse copyWith(
          void Function(SetEpisodeStatusResponse) updates) =>
      super.copyWith((message) => updates(message as SetEpisodeStatusResponse))
          as SetEpisodeStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetEpisodeStatusResponse create() => SetEpisodeStatusResponse._();
  @$core.override
  SetEpisodeStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetEpisodeStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetEpisodeStatusResponse>(create);
  static SetEpisodeStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Episode get episode => $_getN(0);
  @$pb.TagNumber(1)
  set episode(Episode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisode() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisode() => $_clearField(1);
  @$pb.TagNumber(1)
  Episode ensureEpisode() => $_ensure(0);
}

class ListEpisodesRequest extends $pb.GeneratedMessage {
  factory ListEpisodesRequest({
    $core.String? patientId,
    $core.bool? openOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (openOnly != null) result.openOnly = openOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListEpisodesRequest._();

  factory ListEpisodesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListEpisodesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEpisodesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOB(2, _omitFieldNames ? '' : 'openOnly')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEpisodesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEpisodesRequest copyWith(void Function(ListEpisodesRequest) updates) =>
      super.copyWith((message) => updates(message as ListEpisodesRequest))
          as ListEpisodesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListEpisodesRequest create() => ListEpisodesRequest._();
  @$core.override
  ListEpisodesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListEpisodesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListEpisodesRequest>(create);
  static ListEpisodesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get openOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set openOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpenOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpenOnly() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListEpisodesResponse extends $pb.GeneratedMessage {
  factory ListEpisodesResponse({
    $core.Iterable<Episode>? episodes,
  }) {
    final result = create();
    if (episodes != null) result.episodes.addAll(episodes);
    return result;
  }

  ListEpisodesResponse._();

  factory ListEpisodesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListEpisodesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEpisodesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..pPM<Episode>(1, _omitFieldNames ? '' : 'episodes',
        subBuilder: Episode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEpisodesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEpisodesResponse copyWith(void Function(ListEpisodesResponse) updates) =>
      super.copyWith((message) => updates(message as ListEpisodesResponse))
          as ListEpisodesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListEpisodesResponse create() => ListEpisodesResponse._();
  @$core.override
  ListEpisodesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListEpisodesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListEpisodesResponse>(create);
  static ListEpisodesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Episode> get episodes => $_getList(0);
}

class AssignCareTeamMemberRequest extends $pb.GeneratedMessage {
  factory AssignCareTeamMemberRequest({
    $core.String? encounterId,
    $core.String? subjectId,
    CareTeamRole? role,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? effectiveUntil,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (subjectId != null) result.subjectId = subjectId;
    if (role != null) result.role = role;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (effectiveUntil != null) result.effectiveUntil = effectiveUntil;
    return result;
  }

  AssignCareTeamMemberRequest._();

  factory AssignCareTeamMemberRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssignCareTeamMemberRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssignCareTeamMemberRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'subjectId')
    ..aE<CareTeamRole>(3, _omitFieldNames ? '' : 'role',
        enumValues: CareTeamRole.values)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'effectiveUntil',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignCareTeamMemberRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignCareTeamMemberRequest copyWith(
          void Function(AssignCareTeamMemberRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AssignCareTeamMemberRequest))
          as AssignCareTeamMemberRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignCareTeamMemberRequest create() =>
      AssignCareTeamMemberRequest._();
  @$core.override
  AssignCareTeamMemberRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssignCareTeamMemberRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssignCareTeamMemberRequest>(create);
  static AssignCareTeamMemberRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get subjectId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subjectId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubjectId() => $_clearField(2);

  @$pb.TagNumber(3)
  CareTeamRole get role => $_getN(2);
  @$pb.TagNumber(3)
  set role(CareTeamRole value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get effectiveFrom => $_getN(3);
  @$pb.TagNumber(4)
  set effectiveFrom($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEffectiveFrom() => $_has(3);
  @$pb.TagNumber(4)
  void clearEffectiveFrom() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get effectiveUntil => $_getN(4);
  @$pb.TagNumber(5)
  set effectiveUntil($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEffectiveUntil() => $_has(4);
  @$pb.TagNumber(5)
  void clearEffectiveUntil() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureEffectiveUntil() => $_ensure(4);
}

class AssignCareTeamMemberResponse extends $pb.GeneratedMessage {
  factory AssignCareTeamMemberResponse({
    CareTeamMember? member,
  }) {
    final result = create();
    if (member != null) result.member = member;
    return result;
  }

  AssignCareTeamMemberResponse._();

  factory AssignCareTeamMemberResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssignCareTeamMemberResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssignCareTeamMemberResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOM<CareTeamMember>(1, _omitFieldNames ? '' : 'member',
        subBuilder: CareTeamMember.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignCareTeamMemberResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignCareTeamMemberResponse copyWith(
          void Function(AssignCareTeamMemberResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AssignCareTeamMemberResponse))
          as AssignCareTeamMemberResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignCareTeamMemberResponse create() =>
      AssignCareTeamMemberResponse._();
  @$core.override
  AssignCareTeamMemberResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssignCareTeamMemberResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssignCareTeamMemberResponse>(create);
  static AssignCareTeamMemberResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CareTeamMember get member => $_getN(0);
  @$pb.TagNumber(1)
  set member(CareTeamMember value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMember() => $_has(0);
  @$pb.TagNumber(1)
  void clearMember() => $_clearField(1);
  @$pb.TagNumber(1)
  CareTeamMember ensureMember() => $_ensure(0);
}

class EndCareTeamAssignmentRequest extends $pb.GeneratedMessage {
  factory EndCareTeamAssignmentRequest({
    $core.String? careTeamId,
    $0.Timestamp? effectiveUntil,
  }) {
    final result = create();
    if (careTeamId != null) result.careTeamId = careTeamId;
    if (effectiveUntil != null) result.effectiveUntil = effectiveUntil;
    return result;
  }

  EndCareTeamAssignmentRequest._();

  factory EndCareTeamAssignmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndCareTeamAssignmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndCareTeamAssignmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'careTeamId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'effectiveUntil',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndCareTeamAssignmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndCareTeamAssignmentRequest copyWith(
          void Function(EndCareTeamAssignmentRequest) updates) =>
      super.copyWith(
              (message) => updates(message as EndCareTeamAssignmentRequest))
          as EndCareTeamAssignmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndCareTeamAssignmentRequest create() =>
      EndCareTeamAssignmentRequest._();
  @$core.override
  EndCareTeamAssignmentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndCareTeamAssignmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndCareTeamAssignmentRequest>(create);
  static EndCareTeamAssignmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get careTeamId => $_getSZ(0);
  @$pb.TagNumber(1)
  set careTeamId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCareTeamId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCareTeamId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get effectiveUntil => $_getN(1);
  @$pb.TagNumber(2)
  set effectiveUntil($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEffectiveUntil() => $_has(1);
  @$pb.TagNumber(2)
  void clearEffectiveUntil() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureEffectiveUntil() => $_ensure(1);
}

class EndCareTeamAssignmentResponse extends $pb.GeneratedMessage {
  factory EndCareTeamAssignmentResponse() => create();

  EndCareTeamAssignmentResponse._();

  factory EndCareTeamAssignmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndCareTeamAssignmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndCareTeamAssignmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndCareTeamAssignmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndCareTeamAssignmentResponse copyWith(
          void Function(EndCareTeamAssignmentResponse) updates) =>
      super.copyWith(
              (message) => updates(message as EndCareTeamAssignmentResponse))
          as EndCareTeamAssignmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndCareTeamAssignmentResponse create() =>
      EndCareTeamAssignmentResponse._();
  @$core.override
  EndCareTeamAssignmentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndCareTeamAssignmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndCareTeamAssignmentResponse>(create);
  static EndCareTeamAssignmentResponse? _defaultInstance;
}

class GetCareTeamRequest extends $pb.GeneratedMessage {
  factory GetCareTeamRequest({
    $core.String? encounterId,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    return result;
  }

  GetCareTeamRequest._();

  factory GetCareTeamRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCareTeamRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCareTeamRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCareTeamRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCareTeamRequest copyWith(void Function(GetCareTeamRequest) updates) =>
      super.copyWith((message) => updates(message as GetCareTeamRequest))
          as GetCareTeamRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCareTeamRequest create() => GetCareTeamRequest._();
  @$core.override
  GetCareTeamRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCareTeamRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCareTeamRequest>(create);
  static GetCareTeamRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);
}

class GetCareTeamResponse extends $pb.GeneratedMessage {
  factory GetCareTeamResponse({
    $core.Iterable<CareTeamMember>? members,
  }) {
    final result = create();
    if (members != null) result.members.addAll(members);
    return result;
  }

  GetCareTeamResponse._();

  factory GetCareTeamResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCareTeamResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCareTeamResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..pPM<CareTeamMember>(1, _omitFieldNames ? '' : 'members',
        subBuilder: CareTeamMember.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCareTeamResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCareTeamResponse copyWith(void Function(GetCareTeamResponse) updates) =>
      super.copyWith((message) => updates(message as GetCareTeamResponse))
          as GetCareTeamResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCareTeamResponse create() => GetCareTeamResponse._();
  @$core.override
  GetCareTeamResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCareTeamResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCareTeamResponse>(create);
  static GetCareTeamResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CareTeamMember> get members => $_getList(0);
}

class RecordDiagnosisRequest extends $pb.GeneratedMessage {
  factory RecordDiagnosisRequest({
    $core.String? encounterId,
    Coding? code,
    DiagnosisCertainty? certainty,
    DiagnosisRank? rank,
    $core.String? note,
    $0.Timestamp? onsetAt,
    $core.String? supersedesId,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (code != null) result.code = code;
    if (certainty != null) result.certainty = certainty;
    if (rank != null) result.rank = rank;
    if (note != null) result.note = note;
    if (onsetAt != null) result.onsetAt = onsetAt;
    if (supersedesId != null) result.supersedesId = supersedesId;
    return result;
  }

  RecordDiagnosisRequest._();

  factory RecordDiagnosisRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordDiagnosisRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordDiagnosisRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(2, _omitFieldNames ? '' : 'code', subBuilder: Coding.create)
    ..aE<DiagnosisCertainty>(3, _omitFieldNames ? '' : 'certainty',
        enumValues: DiagnosisCertainty.values)
    ..aE<DiagnosisRank>(4, _omitFieldNames ? '' : 'rank',
        enumValues: DiagnosisRank.values)
    ..aOS(5, _omitFieldNames ? '' : 'note')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'onsetAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'supersedesId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDiagnosisRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDiagnosisRequest copyWith(
          void Function(RecordDiagnosisRequest) updates) =>
      super.copyWith((message) => updates(message as RecordDiagnosisRequest))
          as RecordDiagnosisRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordDiagnosisRequest create() => RecordDiagnosisRequest._();
  @$core.override
  RecordDiagnosisRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordDiagnosisRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordDiagnosisRequest>(create);
  static RecordDiagnosisRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  @$pb.TagNumber(2)
  Coding get code => $_getN(1);
  @$pb.TagNumber(2)
  set code(Coding value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);
  @$pb.TagNumber(2)
  Coding ensureCode() => $_ensure(1);

  @$pb.TagNumber(3)
  DiagnosisCertainty get certainty => $_getN(2);
  @$pb.TagNumber(3)
  set certainty(DiagnosisCertainty value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCertainty() => $_has(2);
  @$pb.TagNumber(3)
  void clearCertainty() => $_clearField(3);

  @$pb.TagNumber(4)
  DiagnosisRank get rank => $_getN(3);
  @$pb.TagNumber(4)
  set rank(DiagnosisRank value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRank() => $_has(3);
  @$pb.TagNumber(4)
  void clearRank() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get note => $_getSZ(4);
  @$pb.TagNumber(5)
  set note($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNote() => $_has(4);
  @$pb.TagNumber(5)
  void clearNote() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get onsetAt => $_getN(5);
  @$pb.TagNumber(6)
  set onsetAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOnsetAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearOnsetAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureOnsetAt() => $_ensure(5);

  /// Names the earlier entry this one replaces. The earlier entry is kept: a
  /// differential that became a final diagnosis is a clinical reasoning trail.
  @$pb.TagNumber(7)
  $core.String get supersedesId => $_getSZ(6);
  @$pb.TagNumber(7)
  set supersedesId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSupersedesId() => $_has(6);
  @$pb.TagNumber(7)
  void clearSupersedesId() => $_clearField(7);
}

class RecordDiagnosisResponse extends $pb.GeneratedMessage {
  factory RecordDiagnosisResponse({
    Diagnosis? diagnosis,
  }) {
    final result = create();
    if (diagnosis != null) result.diagnosis = diagnosis;
    return result;
  }

  RecordDiagnosisResponse._();

  factory RecordDiagnosisResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordDiagnosisResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordDiagnosisResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOM<Diagnosis>(1, _omitFieldNames ? '' : 'diagnosis',
        subBuilder: Diagnosis.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDiagnosisResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDiagnosisResponse copyWith(
          void Function(RecordDiagnosisResponse) updates) =>
      super.copyWith((message) => updates(message as RecordDiagnosisResponse))
          as RecordDiagnosisResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordDiagnosisResponse create() => RecordDiagnosisResponse._();
  @$core.override
  RecordDiagnosisResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordDiagnosisResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordDiagnosisResponse>(create);
  static RecordDiagnosisResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Diagnosis get diagnosis => $_getN(0);
  @$pb.TagNumber(1)
  set diagnosis(Diagnosis value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDiagnosis() => $_has(0);
  @$pb.TagNumber(1)
  void clearDiagnosis() => $_clearField(1);
  @$pb.TagNumber(1)
  Diagnosis ensureDiagnosis() => $_ensure(0);
}

class RetractDiagnosisRequest extends $pb.GeneratedMessage {
  factory RetractDiagnosisRequest({
    $core.String? diagnosisId,
    $core.String? reason,
  }) {
    final result = create();
    if (diagnosisId != null) result.diagnosisId = diagnosisId;
    if (reason != null) result.reason = reason;
    return result;
  }

  RetractDiagnosisRequest._();

  factory RetractDiagnosisRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetractDiagnosisRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetractDiagnosisRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'diagnosisId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetractDiagnosisRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetractDiagnosisRequest copyWith(
          void Function(RetractDiagnosisRequest) updates) =>
      super.copyWith((message) => updates(message as RetractDiagnosisRequest))
          as RetractDiagnosisRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetractDiagnosisRequest create() => RetractDiagnosisRequest._();
  @$core.override
  RetractDiagnosisRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetractDiagnosisRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetractDiagnosisRequest>(create);
  static RetractDiagnosisRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get diagnosisId => $_getSZ(0);
  @$pb.TagNumber(1)
  set diagnosisId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDiagnosisId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDiagnosisId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class RetractDiagnosisResponse extends $pb.GeneratedMessage {
  factory RetractDiagnosisResponse() => create();

  RetractDiagnosisResponse._();

  factory RetractDiagnosisResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetractDiagnosisResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetractDiagnosisResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetractDiagnosisResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetractDiagnosisResponse copyWith(
          void Function(RetractDiagnosisResponse) updates) =>
      super.copyWith((message) => updates(message as RetractDiagnosisResponse))
          as RetractDiagnosisResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetractDiagnosisResponse create() => RetractDiagnosisResponse._();
  @$core.override
  RetractDiagnosisResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetractDiagnosisResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetractDiagnosisResponse>(create);
  static RetractDiagnosisResponse? _defaultInstance;
}

class ListDiagnosesRequest extends $pb.GeneratedMessage {
  factory ListDiagnosesRequest({
    $core.String? encounterId,
    $core.String? patientId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListDiagnosesRequest._();

  factory ListDiagnosesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDiagnosesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDiagnosesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDiagnosesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDiagnosesRequest copyWith(void Function(ListDiagnosesRequest) updates) =>
      super.copyWith((message) => updates(message as ListDiagnosesRequest))
          as ListDiagnosesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDiagnosesRequest create() => ListDiagnosesRequest._();
  @$core.override
  ListDiagnosesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDiagnosesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDiagnosesRequest>(create);
  static ListDiagnosesRequest? _defaultInstance;

  /// An encounter's full trail, superseded entries included.
  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  /// Or the conditions that still stand across every encounter, which is what a
  /// problem list reads.
  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListDiagnosesResponse extends $pb.GeneratedMessage {
  factory ListDiagnosesResponse({
    $core.Iterable<Diagnosis>? diagnoses,
  }) {
    final result = create();
    if (diagnoses != null) result.diagnoses.addAll(diagnoses);
    return result;
  }

  ListDiagnosesResponse._();

  factory ListDiagnosesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDiagnosesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDiagnosesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..pPM<Diagnosis>(1, _omitFieldNames ? '' : 'diagnoses',
        subBuilder: Diagnosis.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDiagnosesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDiagnosesResponse copyWith(
          void Function(ListDiagnosesResponse) updates) =>
      super.copyWith((message) => updates(message as ListDiagnosesResponse))
          as ListDiagnosesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDiagnosesResponse create() => ListDiagnosesResponse._();
  @$core.override
  ListDiagnosesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDiagnosesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDiagnosesResponse>(create);
  static ListDiagnosesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Diagnosis> get diagnoses => $_getList(0);
}

class CloseEncounterRequest extends $pb.GeneratedMessage {
  factory CloseEncounterRequest({
    $core.String? encounterId,
    $core.String? narrative,
    $core.String? overrideReason,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (narrative != null) result.narrative = narrative;
    if (overrideReason != null) result.overrideReason = overrideReason;
    return result;
  }

  CloseEncounterRequest._();

  factory CloseEncounterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseEncounterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseEncounterRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'narrative')
    ..aOS(3, _omitFieldNames ? '' : 'overrideReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseEncounterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseEncounterRequest copyWith(
          void Function(CloseEncounterRequest) updates) =>
      super.copyWith((message) => updates(message as CloseEncounterRequest))
          as CloseEncounterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseEncounterRequest create() => CloseEncounterRequest._();
  @$core.override
  CloseEncounterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseEncounterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseEncounterRequest>(create);
  static CloseEncounterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  /// The summary text, assembled from signed content.
  @$pb.TagNumber(2)
  $core.String get narrative => $_getSZ(1);
  @$pb.TagNumber(2)
  set narrative($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNarrative() => $_has(1);
  @$pb.TagNumber(2)
  void clearNarrative() => $_clearField(2);

  /// Forces closure over an incomplete record where policy allows it. Needs the
  /// override permission as well.
  @$pb.TagNumber(3)
  $core.String get overrideReason => $_getSZ(2);
  @$pb.TagNumber(3)
  set overrideReason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOverrideReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverrideReason() => $_clearField(3);
}

class CloseEncounterResponse extends $pb.GeneratedMessage {
  factory CloseEncounterResponse({
    Encounter? encounter,
    VisitSummary? summary,
    $core.bool? overridden,
    $core.Iterable<$core.String>? missingItems,
  }) {
    final result = create();
    if (encounter != null) result.encounter = encounter;
    if (summary != null) result.summary = summary;
    if (overridden != null) result.overridden = overridden;
    if (missingItems != null) result.missingItems.addAll(missingItems);
    return result;
  }

  CloseEncounterResponse._();

  factory CloseEncounterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseEncounterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseEncounterResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOM<Encounter>(1, _omitFieldNames ? '' : 'encounter',
        subBuilder: Encounter.create)
    ..aOM<VisitSummary>(2, _omitFieldNames ? '' : 'summary',
        subBuilder: VisitSummary.create)
    ..aOB(3, _omitFieldNames ? '' : 'overridden')
    ..pPS(4, _omitFieldNames ? '' : 'missingItems')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseEncounterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseEncounterResponse copyWith(
          void Function(CloseEncounterResponse) updates) =>
      super.copyWith((message) => updates(message as CloseEncounterResponse))
          as CloseEncounterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseEncounterResponse create() => CloseEncounterResponse._();
  @$core.override
  CloseEncounterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseEncounterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseEncounterResponse>(create);
  static CloseEncounterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Encounter get encounter => $_getN(0);
  @$pb.TagNumber(1)
  set encounter(Encounter value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounter() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounter() => $_clearField(1);
  @$pb.TagNumber(1)
  Encounter ensureEncounter() => $_ensure(0);

  @$pb.TagNumber(2)
  VisitSummary get summary => $_getN(1);
  @$pb.TagNumber(2)
  set summary(VisitSummary value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSummary() => $_has(1);
  @$pb.TagNumber(2)
  void clearSummary() => $_clearField(2);
  @$pb.TagNumber(2)
  VisitSummary ensureSummary() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get overridden => $_getBF(2);
  @$pb.TagNumber(3)
  set overridden($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOverridden() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverridden() => $_clearField(3);

  /// What was outstanding at the moment of the override.
  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get missingItems => $_getList(3);
}

class AmendSummaryRequest extends $pb.GeneratedMessage {
  factory AmendSummaryRequest({
    $core.String? encounterId,
    $core.String? narrative,
    $core.String? reason,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (narrative != null) result.narrative = narrative;
    if (reason != null) result.reason = reason;
    return result;
  }

  AmendSummaryRequest._();

  factory AmendSummaryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AmendSummaryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AmendSummaryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'narrative')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendSummaryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendSummaryRequest copyWith(void Function(AmendSummaryRequest) updates) =>
      super.copyWith((message) => updates(message as AmendSummaryRequest))
          as AmendSummaryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AmendSummaryRequest create() => AmendSummaryRequest._();
  @$core.override
  AmendSummaryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AmendSummaryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AmendSummaryRequest>(create);
  static AmendSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get narrative => $_getSZ(1);
  @$pb.TagNumber(2)
  set narrative($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNarrative() => $_has(1);
  @$pb.TagNumber(2)
  void clearNarrative() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class AmendSummaryResponse extends $pb.GeneratedMessage {
  factory AmendSummaryResponse({
    VisitSummary? summary,
  }) {
    final result = create();
    if (summary != null) result.summary = summary;
    return result;
  }

  AmendSummaryResponse._();

  factory AmendSummaryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AmendSummaryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AmendSummaryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOM<VisitSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: VisitSummary.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendSummaryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendSummaryResponse copyWith(void Function(AmendSummaryResponse) updates) =>
      super.copyWith((message) => updates(message as AmendSummaryResponse))
          as AmendSummaryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AmendSummaryResponse create() => AmendSummaryResponse._();
  @$core.override
  AmendSummaryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AmendSummaryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AmendSummaryResponse>(create);
  static AmendSummaryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  VisitSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(VisitSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  VisitSummary ensureSummary() => $_ensure(0);
}

class GetSummariesRequest extends $pb.GeneratedMessage {
  factory GetSummariesRequest({
    $core.String? encounterId,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    return result;
  }

  GetSummariesRequest._();

  factory GetSummariesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSummariesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSummariesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSummariesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSummariesRequest copyWith(void Function(GetSummariesRequest) updates) =>
      super.copyWith((message) => updates(message as GetSummariesRequest))
          as GetSummariesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSummariesRequest create() => GetSummariesRequest._();
  @$core.override
  GetSummariesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSummariesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSummariesRequest>(create);
  static GetSummariesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);
}

class GetSummariesResponse extends $pb.GeneratedMessage {
  factory GetSummariesResponse({
    $core.Iterable<VisitSummary>? summaries,
  }) {
    final result = create();
    if (summaries != null) result.summaries.addAll(summaries);
    return result;
  }

  GetSummariesResponse._();

  factory GetSummariesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSummariesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSummariesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..pPM<VisitSummary>(1, _omitFieldNames ? '' : 'summaries',
        subBuilder: VisitSummary.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSummariesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSummariesResponse copyWith(void Function(GetSummariesResponse) updates) =>
      super.copyWith((message) => updates(message as GetSummariesResponse))
          as GetSummariesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSummariesResponse create() => GetSummariesResponse._();
  @$core.override
  GetSummariesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSummariesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSummariesResponse>(create);
  static GetSummariesResponse? _defaultInstance;

  /// Every version, newest first. The superseded ones stay readable: somebody
  /// acted on them.
  @$pb.TagNumber(1)
  $pb.PbList<VisitSummary> get summaries => $_getList(0);
}

class SetClosurePolicyRequest extends $pb.GeneratedMessage {
  factory SetClosurePolicyRequest({
    $core.String? facilityId,
    $core.Iterable<ClosurePolicyForClass>? classes,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (classes != null) result.classes.addAll(classes);
    return result;
  }

  SetClosurePolicyRequest._();

  factory SetClosurePolicyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetClosurePolicyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetClosurePolicyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..pPM<ClosurePolicyForClass>(2, _omitFieldNames ? '' : 'classes',
        subBuilder: ClosurePolicyForClass.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetClosurePolicyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetClosurePolicyRequest copyWith(
          void Function(SetClosurePolicyRequest) updates) =>
      super.copyWith((message) => updates(message as SetClosurePolicyRequest))
          as SetClosurePolicyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetClosurePolicyRequest create() => SetClosurePolicyRequest._();
  @$core.override
  SetClosurePolicyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetClosurePolicyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetClosurePolicyRequest>(create);
  static SetClosurePolicyRequest? _defaultInstance;

  /// Empty applies tenant-wide; naming a facility overrides.
  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ClosurePolicyForClass> get classes => $_getList(1);
}

class SetClosurePolicyResponse extends $pb.GeneratedMessage {
  factory SetClosurePolicyResponse() => create();

  SetClosurePolicyResponse._();

  factory SetClosurePolicyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetClosurePolicyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetClosurePolicyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetClosurePolicyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetClosurePolicyResponse copyWith(
          void Function(SetClosurePolicyResponse) updates) =>
      super.copyWith((message) => updates(message as SetClosurePolicyResponse))
          as SetClosurePolicyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetClosurePolicyResponse create() => SetClosurePolicyResponse._();
  @$core.override
  SetClosurePolicyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetClosurePolicyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetClosurePolicyResponse>(create);
  static SetClosurePolicyResponse? _defaultInstance;
}

class GetClosurePolicyRequest extends $pb.GeneratedMessage {
  factory GetClosurePolicyRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  GetClosurePolicyRequest._();

  factory GetClosurePolicyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetClosurePolicyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetClosurePolicyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetClosurePolicyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetClosurePolicyRequest copyWith(
          void Function(GetClosurePolicyRequest) updates) =>
      super.copyWith((message) => updates(message as GetClosurePolicyRequest))
          as GetClosurePolicyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetClosurePolicyRequest create() => GetClosurePolicyRequest._();
  @$core.override
  GetClosurePolicyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetClosurePolicyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetClosurePolicyRequest>(create);
  static GetClosurePolicyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

class GetClosurePolicyResponse extends $pb.GeneratedMessage {
  factory GetClosurePolicyResponse({
    $core.Iterable<ClosurePolicyForClass>? classes,
  }) {
    final result = create();
    if (classes != null) result.classes.addAll(classes);
    return result;
  }

  GetClosurePolicyResponse._();

  factory GetClosurePolicyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetClosurePolicyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetClosurePolicyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..pPM<ClosurePolicyForClass>(1, _omitFieldNames ? '' : 'classes',
        subBuilder: ClosurePolicyForClass.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetClosurePolicyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetClosurePolicyResponse copyWith(
          void Function(GetClosurePolicyResponse) updates) =>
      super.copyWith((message) => updates(message as GetClosurePolicyResponse))
          as GetClosurePolicyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetClosurePolicyResponse create() => GetClosurePolicyResponse._();
  @$core.override
  GetClosurePolicyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetClosurePolicyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetClosurePolicyResponse>(create);
  static GetClosurePolicyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ClosurePolicyForClass> get classes => $_getList(0);
}

class ListClosureOverridesRequest extends $pb.GeneratedMessage {
  factory ListClosureOverridesRequest({
    $core.String? encounterId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListClosureOverridesRequest._();

  factory ListClosureOverridesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListClosureOverridesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListClosureOverridesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListClosureOverridesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListClosureOverridesRequest copyWith(
          void Function(ListClosureOverridesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListClosureOverridesRequest))
          as ListClosureOverridesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListClosureOverridesRequest create() =>
      ListClosureOverridesRequest._();
  @$core.override
  ListClosureOverridesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListClosureOverridesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListClosureOverridesRequest>(create);
  static ListClosureOverridesRequest? _defaultInstance;

  /// Empty returns every forced closure in the tenant, which is the report
  /// SRS-ENC-008 exists to make possible.
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

class ListClosureOverridesResponse extends $pb.GeneratedMessage {
  factory ListClosureOverridesResponse({
    $core.Iterable<ClosureOverride>? overrides,
  }) {
    final result = create();
    if (overrides != null) result.overrides.addAll(overrides);
    return result;
  }

  ListClosureOverridesResponse._();

  factory ListClosureOverridesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListClosureOverridesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListClosureOverridesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..pPM<ClosureOverride>(1, _omitFieldNames ? '' : 'overrides',
        subBuilder: ClosureOverride.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListClosureOverridesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListClosureOverridesResponse copyWith(
          void Function(ListClosureOverridesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListClosureOverridesResponse))
          as ListClosureOverridesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListClosureOverridesResponse create() =>
      ListClosureOverridesResponse._();
  @$core.override
  ListClosureOverridesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListClosureOverridesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListClosureOverridesResponse>(create);
  static ListClosureOverridesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ClosureOverride> get overrides => $_getList(0);
}

class GetTimelineRequest extends $pb.GeneratedMessage {
  factory GetTimelineRequest({
    $core.String? patientId,
    $0.Timestamp? from,
    $0.Timestamp? until,
    $core.Iterable<TimelineEntryKind>? kinds,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (from != null) result.from = from;
    if (until != null) result.until = until;
    if (kinds != null) result.kinds.addAll(kinds);
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetTimelineRequest._();

  factory GetTimelineRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTimelineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTimelineRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'until',
        subBuilder: $0.Timestamp.create)
    ..pc<TimelineEntryKind>(
        4, _omitFieldNames ? '' : 'kinds', $pb.PbFieldType.KE,
        valueOf: TimelineEntryKind.valueOf,
        enumValues: TimelineEntryKind.values,
        defaultEnumValue: TimelineEntryKind.TIMELINE_ENTRY_KIND_UNSPECIFIED)
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineRequest copyWith(void Function(GetTimelineRequest) updates) =>
      super.copyWith((message) => updates(message as GetTimelineRequest))
          as GetTimelineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTimelineRequest create() => GetTimelineRequest._();
  @$core.override
  GetTimelineRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTimelineRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTimelineRequest>(create);
  static GetTimelineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

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
  $0.Timestamp get until => $_getN(2);
  @$pb.TagNumber(3)
  set until($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUntil() => $_has(2);
  @$pb.TagNumber(3)
  void clearUntil() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureUntil() => $_ensure(2);

  /// Empty means every kind. A filter is a view and never changes the record.
  @$pb.TagNumber(4)
  $pb.PbList<TimelineEntryKind> get kinds => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);
}

class GetTimelineResponse extends $pb.GeneratedMessage {
  factory GetTimelineResponse({
    $core.Iterable<TimelineEntry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  GetTimelineResponse._();

  factory GetTimelineResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTimelineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTimelineResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.encounter.v1'),
      createEmptyInstance: create)
    ..pPM<TimelineEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: TimelineEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineResponse copyWith(void Function(GetTimelineResponse) updates) =>
      super.copyWith((message) => updates(message as GetTimelineResponse))
          as GetTimelineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTimelineResponse create() => GetTimelineResponse._();
  @$core.override
  GetTimelineResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTimelineResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTimelineResponse>(create);
  static GetTimelineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TimelineEntry> get entries => $_getList(0);
}

class EncounterServiceApi {
  final $pb.RpcClient _client;

  EncounterServiceApi(this._client);

  /// SRS-ENC-001, SRS-ENC-002, SRS-ENC-003. An encounter carries its own
  /// clinical times; the appointment it answers, where there is one, is a
  /// reference rather than a parent.
  $async.Future<OpenEncounterResponse> openEncounter(
          $pb.ClientContext? ctx, OpenEncounterRequest request) =>
      _client.invoke<OpenEncounterResponse>(ctx, 'EncounterService',
          'OpenEncounter', request, OpenEncounterResponse());
  $async.Future<StartEncounterResponse> startEncounter(
          $pb.ClientContext? ctx, StartEncounterRequest request) =>
      _client.invoke<StartEncounterResponse>(ctx, 'EncounterService',
          'StartEncounter', request, StartEncounterResponse());
  $async.Future<EndEncounterResponse> endEncounter(
          $pb.ClientContext? ctx, EndEncounterRequest request) =>
      _client.invoke<EndEncounterResponse>(ctx, 'EncounterService',
          'EndEncounter', request, EndEncounterResponse());

  /// SRS-ENC-006. Invalid state changes are rejected; cancelled and
  /// entered-in-error are different facts and stay distinguishable.
  $async.Future<CancelEncounterResponse> cancelEncounter(
          $pb.ClientContext? ctx, CancelEncounterRequest request) =>
      _client.invoke<CancelEncounterResponse>(ctx, 'EncounterService',
          'CancelEncounter', request, CancelEncounterResponse());
  $async.Future<ReopenEncounterResponse> reopenEncounter(
          $pb.ClientContext? ctx, ReopenEncounterRequest request) =>
      _client.invoke<ReopenEncounterResponse>(ctx, 'EncounterService',
          'ReopenEncounter', request, ReopenEncounterResponse());
  $async.Future<SetEncounterLeaveResponse> setEncounterLeave(
          $pb.ClientContext? ctx, SetEncounterLeaveRequest request) =>
      _client.invoke<SetEncounterLeaveResponse>(ctx, 'EncounterService',
          'SetEncounterLeave', request, SetEncounterLeaveResponse());
  $async.Future<GetEncounterResponse> getEncounter(
          $pb.ClientContext? ctx, GetEncounterRequest request) =>
      _client.invoke<GetEncounterResponse>(ctx, 'EncounterService',
          'GetEncounter', request, GetEncounterResponse());
  $async.Future<ListEncountersResponse> listEncounters(
          $pb.ClientContext? ctx, ListEncountersRequest request) =>
      _client.invoke<ListEncountersResponse>(ctx, 'EncounterService',
          'ListEncounters', request, ListEncountersResponse());

  /// SRS-ENC-004. Multiple encounters reference one episode without copying
  /// data.
  $async.Future<OpenEpisodeResponse> openEpisode(
          $pb.ClientContext? ctx, OpenEpisodeRequest request) =>
      _client.invoke<OpenEpisodeResponse>(ctx, 'EncounterService',
          'OpenEpisode', request, OpenEpisodeResponse());
  $async.Future<SetEpisodeStatusResponse> setEpisodeStatus(
          $pb.ClientContext? ctx, SetEpisodeStatusRequest request) =>
      _client.invoke<SetEpisodeStatusResponse>(ctx, 'EncounterService',
          'SetEpisodeStatus', request, SetEpisodeStatusResponse());
  $async.Future<ListEpisodesResponse> listEpisodes(
          $pb.ClientContext? ctx, ListEpisodesRequest request) =>
      _client.invoke<ListEpisodesResponse>(ctx, 'EncounterService',
          'ListEpisodes', request, ListEpisodesResponse());

  /// SRS-ENC-005. Effective-dated, so authorization can evaluate whether a
  /// clinician was looking after this patient at the time.
  $async.Future<AssignCareTeamMemberResponse> assignCareTeamMember(
          $pb.ClientContext? ctx, AssignCareTeamMemberRequest request) =>
      _client.invoke<AssignCareTeamMemberResponse>(ctx, 'EncounterService',
          'AssignCareTeamMember', request, AssignCareTeamMemberResponse());
  $async.Future<EndCareTeamAssignmentResponse> endCareTeamAssignment(
          $pb.ClientContext? ctx, EndCareTeamAssignmentRequest request) =>
      _client.invoke<EndCareTeamAssignmentResponse>(ctx, 'EncounterService',
          'EndCareTeamAssignment', request, EndCareTeamAssignmentResponse());
  $async.Future<GetCareTeamResponse> getCareTeam(
          $pb.ClientContext? ctx, GetCareTeamRequest request) =>
      _client.invoke<GetCareTeamResponse>(ctx, 'EncounterService',
          'GetCareTeam', request, GetCareTeamResponse());

  /// SRS-ENC-007. Append-only: a change of mind supersedes rather than
  /// overwrites, because the trail is the clinical reasoning.
  $async.Future<RecordDiagnosisResponse> recordDiagnosis(
          $pb.ClientContext? ctx, RecordDiagnosisRequest request) =>
      _client.invoke<RecordDiagnosisResponse>(ctx, 'EncounterService',
          'RecordDiagnosis', request, RecordDiagnosisResponse());
  $async.Future<RetractDiagnosisResponse> retractDiagnosis(
          $pb.ClientContext? ctx, RetractDiagnosisRequest request) =>
      _client.invoke<RetractDiagnosisResponse>(ctx, 'EncounterService',
          'RetractDiagnosis', request, RetractDiagnosisResponse());
  $async.Future<ListDiagnosesResponse> listDiagnoses(
          $pb.ClientContext? ctx, ListDiagnosesRequest request) =>
      _client.invoke<ListDiagnosesResponse>(ctx, 'EncounterService',
          'ListDiagnoses', request, ListDiagnosesResponse());

  /// SRS-ENC-008, SRS-ENC-009. Closure lists what is blocking it, can be forced
  /// where policy allows with an audited reason, and issues a stored summary
  /// that is amended rather than rewritten.
  $async.Future<CloseEncounterResponse> closeEncounter(
          $pb.ClientContext? ctx, CloseEncounterRequest request) =>
      _client.invoke<CloseEncounterResponse>(ctx, 'EncounterService',
          'CloseEncounter', request, CloseEncounterResponse());
  $async.Future<AmendSummaryResponse> amendSummary(
          $pb.ClientContext? ctx, AmendSummaryRequest request) =>
      _client.invoke<AmendSummaryResponse>(ctx, 'EncounterService',
          'AmendSummary', request, AmendSummaryResponse());
  $async.Future<GetSummariesResponse> getSummaries(
          $pb.ClientContext? ctx, GetSummariesRequest request) =>
      _client.invoke<GetSummariesResponse>(ctx, 'EncounterService',
          'GetSummaries', request, GetSummariesResponse());
  $async.Future<SetClosurePolicyResponse> setClosurePolicy(
          $pb.ClientContext? ctx, SetClosurePolicyRequest request) =>
      _client.invoke<SetClosurePolicyResponse>(ctx, 'EncounterService',
          'SetClosurePolicy', request, SetClosurePolicyResponse());
  $async.Future<GetClosurePolicyResponse> getClosurePolicy(
          $pb.ClientContext? ctx, GetClosurePolicyRequest request) =>
      _client.invoke<GetClosurePolicyResponse>(ctx, 'EncounterService',
          'GetClosurePolicy', request, GetClosurePolicyResponse());
  $async.Future<ListClosureOverridesResponse> listClosureOverrides(
          $pb.ClientContext? ctx, ListClosureOverridesRequest request) =>
      _client.invoke<ListClosureOverridesResponse>(ctx, 'EncounterService',
          'ListClosureOverrides', request, ListClosureOverridesResponse());

  /// SRS-ENC-011. Restricted entries the reader may not see are masked or
  /// omitted, and the restricted read is explicitly audited.
  $async.Future<GetTimelineResponse> getTimeline(
          $pb.ClientContext? ctx, GetTimelineRequest request) =>
      _client.invoke<GetTimelineResponse>(ctx, 'EncounterService',
          'GetTimeline', request, GetTimelineResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
