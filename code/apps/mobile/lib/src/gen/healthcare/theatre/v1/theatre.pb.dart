// This is a generated file - do not edit.
//
// Generated from healthcare/theatre/v1/theatre.proto.

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

import 'theatre.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'theatre.pbenum.dart';

class Room extends $pb.GeneratedMessage {
  factory Room({
    $core.String? roomId,
    $core.String? facilityId,
    $core.String? code,
    $core.String? name,
    $core.Iterable<$core.String>? specialties,
    $core.Iterable<$core.String>? equipment,
    $core.bool? active,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (facilityId != null) result.facilityId = facilityId;
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (specialties != null) result.specialties.addAll(specialties);
    if (equipment != null) result.equipment.addAll(equipment);
    if (active != null) result.active = active;
    return result;
  }

  Room._();

  factory Room.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Room.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Room',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..pPS(5, _omitFieldNames ? '' : 'specialties')
    ..pPS(6, _omitFieldNames ? '' : 'equipment')
    ..aOB(7, _omitFieldNames ? '' : 'active')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Room clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Room copyWith(void Function(Room) updates) =>
      super.copyWith((message) => updates(message as Room)) as Room;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Room create() => Room._();
  @$core.override
  Room createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Room getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Room>(create);
  static Room? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  /// Empty means any: a hospital with one theatre should not have to enumerate
  /// every specialty it does.
  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get specialties => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get equipment => $_getList(5);

  @$pb.TagNumber(7)
  $core.bool get active => $_getBF(6);
  @$pb.TagNumber(7)
  set active($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasActive() => $_has(6);
  @$pb.TagNumber(7)
  void clearActive() => $_clearField(7);
}

class Block extends $pb.GeneratedMessage {
  factory Block({
    $core.String? blockId,
    $core.String? roomId,
    BlockKind? kind,
    $core.String? ownerId,
    $core.String? specialty,
    $0.Timestamp? startsAt,
    $0.Timestamp? endsAt,
    $core.String? note,
  }) {
    final result = create();
    if (blockId != null) result.blockId = blockId;
    if (roomId != null) result.roomId = roomId;
    if (kind != null) result.kind = kind;
    if (ownerId != null) result.ownerId = ownerId;
    if (specialty != null) result.specialty = specialty;
    if (startsAt != null) result.startsAt = startsAt;
    if (endsAt != null) result.endsAt = endsAt;
    if (note != null) result.note = note;
    return result;
  }

  Block._();

  factory Block.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Block.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Block',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'blockId')
    ..aOS(2, _omitFieldNames ? '' : 'roomId')
    ..aE<BlockKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: BlockKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'ownerId')
    ..aOS(5, _omitFieldNames ? '' : 'specialty')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'endsAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Block clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Block copyWith(void Function(Block) updates) =>
      super.copyWith((message) => updates(message as Block)) as Block;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Block create() => Block._();
  @$core.override
  Block createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Block getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Block>(create);
  static Block? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get blockId => $_getSZ(0);
  @$pb.TagNumber(1)
  set blockId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBlockId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlockId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get roomId => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoomId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomId() => $_clearField(2);

  @$pb.TagNumber(3)
  BlockKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(BlockKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get ownerId => $_getSZ(3);
  @$pb.TagNumber(4)
  set ownerId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOwnerId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOwnerId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get specialty => $_getSZ(4);
  @$pb.TagNumber(5)
  set specialty($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSpecialty() => $_has(4);
  @$pb.TagNumber(5)
  void clearSpecialty() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get startsAt => $_getN(5);
  @$pb.TagNumber(6)
  set startsAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStartsAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearStartsAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureStartsAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get endsAt => $_getN(6);
  @$pb.TagNumber(7)
  set endsAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasEndsAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearEndsAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureEndsAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get note => $_getSZ(7);
  @$pb.TagNumber(8)
  set note($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNote() => $_has(7);
  @$pb.TagNumber(8)
  void clearNote() => $_clearField(8);
}

class SurgicalCase extends $pb.GeneratedMessage {
  factory SurgicalCase({
    $core.String? caseId,
    $core.String? encounterId,
    $core.String? patientId,
    $core.String? facilityId,
    $core.String? procedureCode,
    $core.String? procedureDisplay,
    $core.String? diagnosisCode,
    $core.String? diagnosisDisplay,
    Laterality? laterality,
    $core.String? site,
    Urgency? urgency,
    $fixnum.Int64? expectedDurationSeconds,
    $core.String? surgeonId,
    $core.Iterable<$core.String>? team,
    $core.Iterable<$core.String>? requirements,
    $core.String? anaesthesiaType,
    $core.String? specialNotes,
    CaseStatus? status,
    $core.String? roomId,
    $0.Timestamp? scheduledStart,
    $0.Timestamp? scheduledEnd,
    CaseCause? cause,
    $core.String? causeReason,
    $core.String? causeNote,
    $0.Timestamp? closedAt,
    $core.String? requestedBy,
    $0.Timestamp? requestedAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (facilityId != null) result.facilityId = facilityId;
    if (procedureCode != null) result.procedureCode = procedureCode;
    if (procedureDisplay != null) result.procedureDisplay = procedureDisplay;
    if (diagnosisCode != null) result.diagnosisCode = diagnosisCode;
    if (diagnosisDisplay != null) result.diagnosisDisplay = diagnosisDisplay;
    if (laterality != null) result.laterality = laterality;
    if (site != null) result.site = site;
    if (urgency != null) result.urgency = urgency;
    if (expectedDurationSeconds != null)
      result.expectedDurationSeconds = expectedDurationSeconds;
    if (surgeonId != null) result.surgeonId = surgeonId;
    if (team != null) result.team.addAll(team);
    if (requirements != null) result.requirements.addAll(requirements);
    if (anaesthesiaType != null) result.anaesthesiaType = anaesthesiaType;
    if (specialNotes != null) result.specialNotes = specialNotes;
    if (status != null) result.status = status;
    if (roomId != null) result.roomId = roomId;
    if (scheduledStart != null) result.scheduledStart = scheduledStart;
    if (scheduledEnd != null) result.scheduledEnd = scheduledEnd;
    if (cause != null) result.cause = cause;
    if (causeReason != null) result.causeReason = causeReason;
    if (causeNote != null) result.causeNote = causeNote;
    if (closedAt != null) result.closedAt = closedAt;
    if (requestedBy != null) result.requestedBy = requestedBy;
    if (requestedAt != null) result.requestedAt = requestedAt;
    if (version != null) result.version = version;
    return result;
  }

  SurgicalCase._();

  factory SurgicalCase.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SurgicalCase.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SurgicalCase',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'procedureCode')
    ..aOS(6, _omitFieldNames ? '' : 'procedureDisplay')
    ..aOS(7, _omitFieldNames ? '' : 'diagnosisCode')
    ..aOS(8, _omitFieldNames ? '' : 'diagnosisDisplay')
    ..aE<Laterality>(9, _omitFieldNames ? '' : 'laterality',
        enumValues: Laterality.values)
    ..aOS(10, _omitFieldNames ? '' : 'site')
    ..aE<Urgency>(11, _omitFieldNames ? '' : 'urgency',
        enumValues: Urgency.values)
    ..aInt64(12, _omitFieldNames ? '' : 'expectedDurationSeconds')
    ..aOS(13, _omitFieldNames ? '' : 'surgeonId')
    ..pPS(14, _omitFieldNames ? '' : 'team')
    ..pPS(15, _omitFieldNames ? '' : 'requirements')
    ..aOS(16, _omitFieldNames ? '' : 'anaesthesiaType')
    ..aOS(17, _omitFieldNames ? '' : 'specialNotes')
    ..aE<CaseStatus>(18, _omitFieldNames ? '' : 'status',
        enumValues: CaseStatus.values)
    ..aOS(19, _omitFieldNames ? '' : 'roomId')
    ..aOM<$0.Timestamp>(20, _omitFieldNames ? '' : 'scheduledStart',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(21, _omitFieldNames ? '' : 'scheduledEnd',
        subBuilder: $0.Timestamp.create)
    ..aE<CaseCause>(22, _omitFieldNames ? '' : 'cause',
        enumValues: CaseCause.values)
    ..aOS(23, _omitFieldNames ? '' : 'causeReason')
    ..aOS(24, _omitFieldNames ? '' : 'causeNote')
    ..aOM<$0.Timestamp>(25, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(26, _omitFieldNames ? '' : 'requestedBy')
    ..aOM<$0.Timestamp>(27, _omitFieldNames ? '' : 'requestedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(28, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SurgicalCase clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SurgicalCase copyWith(void Function(SurgicalCase) updates) =>
      super.copyWith((message) => updates(message as SurgicalCase))
          as SurgicalCase;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SurgicalCase create() => SurgicalCase._();
  @$core.override
  SurgicalCase createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SurgicalCase getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SurgicalCase>(create);
  static SurgicalCase? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  /// The Wave-1 encounter this is the perioperative detail of.
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
  $core.String get procedureCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set procedureCode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProcedureCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearProcedureCode() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get procedureDisplay => $_getSZ(5);
  @$pb.TagNumber(6)
  set procedureDisplay($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProcedureDisplay() => $_has(5);
  @$pb.TagNumber(6)
  void clearProcedureDisplay() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get diagnosisCode => $_getSZ(6);
  @$pb.TagNumber(7)
  set diagnosisCode($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDiagnosisCode() => $_has(6);
  @$pb.TagNumber(7)
  void clearDiagnosisCode() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get diagnosisDisplay => $_getSZ(7);
  @$pb.TagNumber(8)
  set diagnosisDisplay($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDiagnosisDisplay() => $_has(7);
  @$pb.TagNumber(8)
  void clearDiagnosisDisplay() => $_clearField(8);

  @$pb.TagNumber(9)
  Laterality get laterality => $_getN(8);
  @$pb.TagNumber(9)
  set laterality(Laterality value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasLaterality() => $_has(8);
  @$pb.TagNumber(9)
  void clearLaterality() => $_clearField(9);

  /// The anatomical site in words, beside the laterality. Both: "left" is
  /// checkable and "medial third of the clavicle" is what the surgeon marks.
  @$pb.TagNumber(10)
  $core.String get site => $_getSZ(9);
  @$pb.TagNumber(10)
  set site($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSite() => $_has(9);
  @$pb.TagNumber(10)
  void clearSite() => $_clearField(10);

  @$pb.TagNumber(11)
  Urgency get urgency => $_getN(10);
  @$pb.TagNumber(11)
  set urgency(Urgency value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUrgency() => $_has(10);
  @$pb.TagNumber(11)
  void clearUrgency() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get expectedDurationSeconds => $_getI64(11);
  @$pb.TagNumber(12)
  set expectedDurationSeconds($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasExpectedDurationSeconds() => $_has(11);
  @$pb.TagNumber(12)
  void clearExpectedDurationSeconds() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get surgeonId => $_getSZ(12);
  @$pb.TagNumber(13)
  set surgeonId($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasSurgeonId() => $_has(12);
  @$pb.TagNumber(13)
  void clearSurgeonId() => $_clearField(13);

  @$pb.TagNumber(14)
  $pb.PbList<$core.String> get team => $_getList(13);

  @$pb.TagNumber(15)
  $pb.PbList<$core.String> get requirements => $_getList(14);

  @$pb.TagNumber(16)
  $core.String get anaesthesiaType => $_getSZ(15);
  @$pb.TagNumber(16)
  set anaesthesiaType($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasAnaesthesiaType() => $_has(15);
  @$pb.TagNumber(16)
  void clearAnaesthesiaType() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get specialNotes => $_getSZ(16);
  @$pb.TagNumber(17)
  set specialNotes($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasSpecialNotes() => $_has(16);
  @$pb.TagNumber(17)
  void clearSpecialNotes() => $_clearField(17);

  @$pb.TagNumber(18)
  CaseStatus get status => $_getN(17);
  @$pb.TagNumber(18)
  set status(CaseStatus value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasStatus() => $_has(17);
  @$pb.TagNumber(18)
  void clearStatus() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get roomId => $_getSZ(18);
  @$pb.TagNumber(19)
  set roomId($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasRoomId() => $_has(18);
  @$pb.TagNumber(19)
  void clearRoomId() => $_clearField(19);

  @$pb.TagNumber(20)
  $0.Timestamp get scheduledStart => $_getN(19);
  @$pb.TagNumber(20)
  set scheduledStart($0.Timestamp value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasScheduledStart() => $_has(19);
  @$pb.TagNumber(20)
  void clearScheduledStart() => $_clearField(20);
  @$pb.TagNumber(20)
  $0.Timestamp ensureScheduledStart() => $_ensure(19);

  @$pb.TagNumber(21)
  $0.Timestamp get scheduledEnd => $_getN(20);
  @$pb.TagNumber(21)
  set scheduledEnd($0.Timestamp value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasScheduledEnd() => $_has(20);
  @$pb.TagNumber(21)
  void clearScheduledEnd() => $_clearField(21);
  @$pb.TagNumber(21)
  $0.Timestamp ensureScheduledEnd() => $_ensure(20);

  @$pb.TagNumber(22)
  CaseCause get cause => $_getN(21);
  @$pb.TagNumber(22)
  set cause(CaseCause value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasCause() => $_has(21);
  @$pb.TagNumber(22)
  void clearCause() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.String get causeReason => $_getSZ(22);
  @$pb.TagNumber(23)
  set causeReason($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasCauseReason() => $_has(22);
  @$pb.TagNumber(23)
  void clearCauseReason() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.String get causeNote => $_getSZ(23);
  @$pb.TagNumber(24)
  set causeNote($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasCauseNote() => $_has(23);
  @$pb.TagNumber(24)
  void clearCauseNote() => $_clearField(24);

  @$pb.TagNumber(25)
  $0.Timestamp get closedAt => $_getN(24);
  @$pb.TagNumber(25)
  set closedAt($0.Timestamp value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasClosedAt() => $_has(24);
  @$pb.TagNumber(25)
  void clearClosedAt() => $_clearField(25);
  @$pb.TagNumber(25)
  $0.Timestamp ensureClosedAt() => $_ensure(24);

  @$pb.TagNumber(26)
  $core.String get requestedBy => $_getSZ(25);
  @$pb.TagNumber(26)
  set requestedBy($core.String value) => $_setString(25, value);
  @$pb.TagNumber(26)
  $core.bool hasRequestedBy() => $_has(25);
  @$pb.TagNumber(26)
  void clearRequestedBy() => $_clearField(26);

  @$pb.TagNumber(27)
  $0.Timestamp get requestedAt => $_getN(26);
  @$pb.TagNumber(27)
  set requestedAt($0.Timestamp value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasRequestedAt() => $_has(26);
  @$pb.TagNumber(27)
  void clearRequestedAt() => $_clearField(27);
  @$pb.TagNumber(27)
  $0.Timestamp ensureRequestedAt() => $_ensure(26);

  @$pb.TagNumber(28)
  $fixnum.Int64 get version => $_getI64(27);
  @$pb.TagNumber(28)
  set version($fixnum.Int64 value) => $_setInt64(27, value);
  @$pb.TagNumber(28)
  $core.bool hasVersion() => $_has(27);
  @$pb.TagNumber(28)
  void clearVersion() => $_clearField(28);
}

/// One reason a case cannot go in a slot (SRS-OT-004).
class ScheduleConflict extends $pb.GeneratedMessage {
  factory ScheduleConflict({
    $core.String? kind,
    $core.String? detail,
    $core.bool? overridable,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (detail != null) result.detail = detail;
    if (overridable != null) result.overridable = overridable;
    return result;
  }

  ScheduleConflict._();

  factory ScheduleConflict.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScheduleConflict.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleConflict',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'kind')
    ..aOS(2, _omitFieldNames ? '' : 'detail')
    ..aOB(3, _omitFieldNames ? '' : 'overridable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleConflict clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleConflict copyWith(void Function(ScheduleConflict) updates) =>
      super.copyWith((message) => updates(message as ScheduleConflict))
          as ScheduleConflict;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduleConflict create() => ScheduleConflict._();
  @$core.override
  ScheduleConflict createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScheduleConflict getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScheduleConflict>(create);
  static ScheduleConflict? _defaultInstance;

  /// room, surgeon or slot.
  @$pb.TagNumber(1)
  $core.String get kind => $_getSZ(0);
  @$pb.TagNumber(1)
  set kind($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get detail => $_getSZ(1);
  @$pb.TagNumber(2)
  set detail($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDetail() => $_has(1);
  @$pb.TagNumber(2)
  void clearDetail() => $_clearField(2);

  /// False for a hard constraint. Overriding "another case is in this room"
  /// does not make a second theatre appear, so it is refused whatever the
  /// caller asks.
  @$pb.TagNumber(3)
  $core.bool get overridable => $_getBF(2);
  @$pb.TagNumber(3)
  set overridable($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOverridable() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverridable() => $_clearField(3);
}

class PreopEntry extends $pb.GeneratedMessage {
  factory PreopEntry({
    $core.String? code,
    PreopState? state,
    $core.String? note,
    $core.String? waivedBy,
    $core.String? waivedRole,
    $core.String? recordedBy,
    $0.Timestamp? recordedAt,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (state != null) result.state = state;
    if (note != null) result.note = note;
    if (waivedBy != null) result.waivedBy = waivedBy;
    if (waivedRole != null) result.waivedRole = waivedRole;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (recordedAt != null) result.recordedAt = recordedAt;
    return result;
  }

  PreopEntry._();

  factory PreopEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PreopEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PreopEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aE<PreopState>(2, _omitFieldNames ? '' : 'state',
        enumValues: PreopState.values)
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..aOS(4, _omitFieldNames ? '' : 'waivedBy')
    ..aOS(5, _omitFieldNames ? '' : 'waivedRole')
    ..aOS(6, _omitFieldNames ? '' : 'recordedBy')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreopEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreopEntry copyWith(void Function(PreopEntry) updates) =>
      super.copyWith((message) => updates(message as PreopEntry)) as PreopEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PreopEntry create() => PreopEntry._();
  @$core.override
  PreopEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PreopEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreopEntry>(create);
  static PreopEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  PreopState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(PreopState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get waivedBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set waivedBy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWaivedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearWaivedBy() => $_clearField(4);

  /// The role that entitled somebody to waive it. Checked against the item:
  /// consent and site marking cannot be waived by anybody at all.
  @$pb.TagNumber(5)
  $core.String get waivedRole => $_getSZ(4);
  @$pb.TagNumber(5)
  set waivedRole($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWaivedRole() => $_has(4);
  @$pb.TagNumber(5)
  void clearWaivedRole() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get recordedBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set recordedBy($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRecordedBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecordedBy() => $_clearField(6);

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
}

/// A mandatory pre-operative item still unmet and unwaived (SRS-OT-006).
class Blocker extends $pb.GeneratedMessage {
  factory Blocker({
    $core.String? code,
    $core.String? label,
    $core.String? waivableBy,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (label != null) result.label = label;
    if (waivableBy != null) result.waivableBy = waivableBy;
    return result;
  }

  Blocker._();

  factory Blocker.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Blocker.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Blocker',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOS(3, _omitFieldNames ? '' : 'waivableBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Blocker clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Blocker copyWith(void Function(Blocker) updates) =>
      super.copyWith((message) => updates(message as Blocker)) as Blocker;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Blocker create() => Blocker._();
  @$core.override
  Blocker createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Blocker getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Blocker>(create);
  static Blocker? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  /// Empty where nobody may waive it.
  @$pb.TagNumber(3)
  $core.String get waivableBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set waivableBy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWaivableBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearWaivableBy() => $_clearField(3);
}

class SafetyAnswer extends $pb.GeneratedMessage {
  factory SafetyAnswer({
    $core.String? code,
    $core.bool? confirmed,
    $core.String? exception,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (confirmed != null) result.confirmed = confirmed;
    if (exception != null) result.exception = exception;
    return result;
  }

  SafetyAnswer._();

  factory SafetyAnswer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SafetyAnswer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SafetyAnswer',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOB(2, _omitFieldNames ? '' : 'confirmed')
    ..aOS(3, _omitFieldNames ? '' : 'exception')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SafetyAnswer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SafetyAnswer copyWith(void Function(SafetyAnswer) updates) =>
      super.copyWith((message) => updates(message as SafetyAnswer))
          as SafetyAnswer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SafetyAnswer create() => SafetyAnswer._();
  @$core.override
  SafetyAnswer createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SafetyAnswer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SafetyAnswer>(create);
  static SafetyAnswer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get confirmed => $_getBF(1);
  @$pb.TagNumber(2)
  set confirmed($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConfirmed() => $_has(1);
  @$pb.TagNumber(2)
  void clearConfirmed() => $_clearField(2);

  /// Required when not confirmed. SRS-OT-007's "missing item requires explicit
  /// exception" is what stops a checklist being completed by leaving things
  /// blank.
  @$pb.TagNumber(3)
  $core.String get exception => $_getSZ(2);
  @$pb.TagNumber(3)
  set exception($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasException() => $_has(2);
  @$pb.TagNumber(3)
  void clearException() => $_clearField(3);
}

class SafetyCheck extends $pb.GeneratedMessage {
  factory SafetyCheck({
    $core.String? checkId,
    $core.String? caseId,
    SafetyPhase? phase,
    $core.Iterable<$core.String>? participants,
    $core.Iterable<SafetyAnswer>? answers,
    $0.Timestamp? performedAt,
    $core.String? performedBy,
  }) {
    final result = create();
    if (checkId != null) result.checkId = checkId;
    if (caseId != null) result.caseId = caseId;
    if (phase != null) result.phase = phase;
    if (participants != null) result.participants.addAll(participants);
    if (answers != null) result.answers.addAll(answers);
    if (performedAt != null) result.performedAt = performedAt;
    if (performedBy != null) result.performedBy = performedBy;
    return result;
  }

  SafetyCheck._();

  factory SafetyCheck.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SafetyCheck.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SafetyCheck',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'checkId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aE<SafetyPhase>(3, _omitFieldNames ? '' : 'phase',
        enumValues: SafetyPhase.values)
    ..pPS(4, _omitFieldNames ? '' : 'participants')
    ..pPM<SafetyAnswer>(5, _omitFieldNames ? '' : 'answers',
        subBuilder: SafetyAnswer.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'performedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'performedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SafetyCheck clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SafetyCheck copyWith(void Function(SafetyCheck) updates) =>
      super.copyWith((message) => updates(message as SafetyCheck))
          as SafetyCheck;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SafetyCheck create() => SafetyCheck._();
  @$core.override
  SafetyCheck createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SafetyCheck getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SafetyCheck>(create);
  static SafetyCheck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checkId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCheckId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheckId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  @$pb.TagNumber(3)
  SafetyPhase get phase => $_getN(2);
  @$pb.TagNumber(3)
  set phase(SafetyPhase value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPhase() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhase() => $_clearField(3);

  /// At least two. A time-out is the team stopping together; one person reading
  /// a list to themselves is the failure the requirement exists to prevent.
  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get participants => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<SafetyAnswer> get answers => $_getList(4);

  @$pb.TagNumber(6)
  $0.Timestamp get performedAt => $_getN(5);
  @$pb.TagNumber(6)
  set performedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPerformedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearPerformedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensurePerformedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get performedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set performedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPerformedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearPerformedBy() => $_clearField(7);
}

class MilestoneRecord extends $pb.GeneratedMessage {
  factory MilestoneRecord({
    $core.String? milestoneId,
    $core.String? caseId,
    Milestone? milestone,
    $0.Timestamp? occurredAt,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
    $core.String? note,
  }) {
    final result = create();
    if (milestoneId != null) result.milestoneId = milestoneId;
    if (caseId != null) result.caseId = caseId;
    if (milestone != null) result.milestone = milestone;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (note != null) result.note = note;
    return result;
  }

  MilestoneRecord._();

  factory MilestoneRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MilestoneRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MilestoneRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'milestoneId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aE<Milestone>(3, _omitFieldNames ? '' : 'milestone',
        enumValues: Milestone.values)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'recordedBy')
    ..aOS(7, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MilestoneRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MilestoneRecord copyWith(void Function(MilestoneRecord) updates) =>
      super.copyWith((message) => updates(message as MilestoneRecord))
          as MilestoneRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MilestoneRecord create() => MilestoneRecord._();
  @$core.override
  MilestoneRecord createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MilestoneRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MilestoneRecord>(create);
  static MilestoneRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get milestoneId => $_getSZ(0);
  @$pb.TagNumber(1)
  set milestoneId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMilestoneId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMilestoneId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  @$pb.TagNumber(3)
  Milestone get milestone => $_getN(2);
  @$pb.TagNumber(3)
  set milestone(Milestone value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMilestone() => $_has(2);
  @$pb.TagNumber(3)
  void clearMilestone() => $_clearField(3);

  /// When the patient moved, and when somebody typed it. Separate, because a
  /// list written up at the end of the day is a reconstruction.
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

  @$pb.TagNumber(5)
  $0.Timestamp get recordedAt => $_getN(4);
  @$pb.TagNumber(5)
  set recordedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRecordedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecordedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureRecordedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get recordedBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set recordedBy($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRecordedBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecordedBy() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get note => $_getSZ(6);
  @$pb.TagNumber(7)
  set note($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearNote() => $_clearField(7);
}

/// Derived per response, never stored (SRS-OT-015).
///
/// Every field is optional: an interval whose milestones have not both happened
/// is absent, because a zero anaesthesia time would make a list look efficient
/// while the patient was still in the anaesthetic room.
class CaseIntervals extends $pb.GeneratedMessage {
  factory CaseIntervals({
    $fixnum.Int64? anaesthesiaToIncisionSeconds,
    $fixnum.Int64? incisionToClosureSeconds,
    $fixnum.Int64? theatreOccupancySeconds,
    $fixnum.Int64? pacuStaySeconds,
    $fixnum.Int64? startDelaySeconds,
  }) {
    final result = create();
    if (anaesthesiaToIncisionSeconds != null)
      result.anaesthesiaToIncisionSeconds = anaesthesiaToIncisionSeconds;
    if (incisionToClosureSeconds != null)
      result.incisionToClosureSeconds = incisionToClosureSeconds;
    if (theatreOccupancySeconds != null)
      result.theatreOccupancySeconds = theatreOccupancySeconds;
    if (pacuStaySeconds != null) result.pacuStaySeconds = pacuStaySeconds;
    if (startDelaySeconds != null) result.startDelaySeconds = startDelaySeconds;
    return result;
  }

  CaseIntervals._();

  factory CaseIntervals.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CaseIntervals.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CaseIntervals',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'anaesthesiaToIncisionSeconds')
    ..aInt64(2, _omitFieldNames ? '' : 'incisionToClosureSeconds')
    ..aInt64(3, _omitFieldNames ? '' : 'theatreOccupancySeconds')
    ..aInt64(4, _omitFieldNames ? '' : 'pacuStaySeconds')
    ..aInt64(5, _omitFieldNames ? '' : 'startDelaySeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CaseIntervals clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CaseIntervals copyWith(void Function(CaseIntervals) updates) =>
      super.copyWith((message) => updates(message as CaseIntervals))
          as CaseIntervals;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CaseIntervals create() => CaseIntervals._();
  @$core.override
  CaseIntervals createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CaseIntervals getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CaseIntervals>(create);
  static CaseIntervals? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get anaesthesiaToIncisionSeconds => $_getI64(0);
  @$pb.TagNumber(1)
  set anaesthesiaToIncisionSeconds($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAnaesthesiaToIncisionSeconds() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnaesthesiaToIncisionSeconds() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get incisionToClosureSeconds => $_getI64(1);
  @$pb.TagNumber(2)
  set incisionToClosureSeconds($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIncisionToClosureSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearIncisionToClosureSeconds() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get theatreOccupancySeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set theatreOccupancySeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTheatreOccupancySeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearTheatreOccupancySeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get pacuStaySeconds => $_getI64(3);
  @$pb.TagNumber(4)
  set pacuStaySeconds($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPacuStaySeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearPacuStaySeconds() => $_clearField(4);

  /// Negative where the case started early: a list that consistently starts
  /// early is as much a planning fact as one that starts late.
  @$pb.TagNumber(5)
  $fixnum.Int64 get startDelaySeconds => $_getI64(4);
  @$pb.TagNumber(5)
  set startDelaySeconds($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStartDelaySeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartDelaySeconds() => $_clearField(5);
}

class Delay extends $pb.GeneratedMessage {
  factory Delay({
    $core.String? delayId,
    $core.String? caseId,
    DelayReason? reason,
    $core.String? dependency,
    $core.int? minutes,
    $core.String? note,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (delayId != null) result.delayId = delayId;
    if (caseId != null) result.caseId = caseId;
    if (reason != null) result.reason = reason;
    if (dependency != null) result.dependency = dependency;
    if (minutes != null) result.minutes = minutes;
    if (note != null) result.note = note;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  Delay._();

  factory Delay.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Delay.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Delay',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'delayId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aE<DelayReason>(3, _omitFieldNames ? '' : 'reason',
        enumValues: DelayReason.values)
    ..aOS(4, _omitFieldNames ? '' : 'dependency')
    ..aI(5, _omitFieldNames ? '' : 'minutes')
    ..aOS(6, _omitFieldNames ? '' : 'note')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Delay clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Delay copyWith(void Function(Delay) updates) =>
      super.copyWith((message) => updates(message as Delay)) as Delay;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Delay create() => Delay._();
  @$core.override
  Delay createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Delay getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Delay>(create);
  static Delay? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get delayId => $_getSZ(0);
  @$pb.TagNumber(1)
  set delayId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDelayId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDelayId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  @$pb.TagNumber(3)
  DelayReason get reason => $_getN(2);
  @$pb.TagNumber(3)
  set reason(DelayReason value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  /// The department answerable. A theatre's delay report is read by the
  /// departments it names.
  @$pb.TagNumber(4)
  $core.String get dependency => $_getSZ(3);
  @$pb.TagNumber(4)
  set dependency($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDependency() => $_has(3);
  @$pb.TagNumber(4)
  void clearDependency() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get minutes => $_getIZ(4);
  @$pb.TagNumber(5)
  set minutes($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMinutes() => $_has(4);
  @$pb.TagNumber(5)
  void clearMinutes() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get note => $_getSZ(5);
  @$pb.TagNumber(6)
  set note($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNote() => $_has(5);
  @$pb.TagNumber(6)
  void clearNote() => $_clearField(6);

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
}

class OperativeNote extends $pb.GeneratedMessage {
  factory OperativeNote({
    $core.String? noteId,
    $core.String? caseId,
    $core.int? version,
    $core.String? supersedes,
    $core.String? procedurePerformed,
    $core.String? findings,
    $core.Iterable<$core.String>? specimenIds,
    $core.Iterable<$core.String>? implantIds,
    $core.Iterable<$core.String>? complications,
    $core.int? estimatedBloodLossMl,
    $core.String? postOperativeOrders,
    $core.String? narrative,
    NoteStatus? status,
    $core.String? amendmentReason,
    $core.String? authoredBy,
    $0.Timestamp? authoredAt,
    $core.String? signedBy,
    $0.Timestamp? signedAt,
  }) {
    final result = create();
    if (noteId != null) result.noteId = noteId;
    if (caseId != null) result.caseId = caseId;
    if (version != null) result.version = version;
    if (supersedes != null) result.supersedes = supersedes;
    if (procedurePerformed != null)
      result.procedurePerformed = procedurePerformed;
    if (findings != null) result.findings = findings;
    if (specimenIds != null) result.specimenIds.addAll(specimenIds);
    if (implantIds != null) result.implantIds.addAll(implantIds);
    if (complications != null) result.complications.addAll(complications);
    if (estimatedBloodLossMl != null)
      result.estimatedBloodLossMl = estimatedBloodLossMl;
    if (postOperativeOrders != null)
      result.postOperativeOrders = postOperativeOrders;
    if (narrative != null) result.narrative = narrative;
    if (status != null) result.status = status;
    if (amendmentReason != null) result.amendmentReason = amendmentReason;
    if (authoredBy != null) result.authoredBy = authoredBy;
    if (authoredAt != null) result.authoredAt = authoredAt;
    if (signedBy != null) result.signedBy = signedBy;
    if (signedAt != null) result.signedAt = signedAt;
    return result;
  }

  OperativeNote._();

  factory OperativeNote.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OperativeNote.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OperativeNote',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'noteId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aI(3, _omitFieldNames ? '' : 'version')
    ..aOS(4, _omitFieldNames ? '' : 'supersedes')
    ..aOS(5, _omitFieldNames ? '' : 'procedurePerformed')
    ..aOS(6, _omitFieldNames ? '' : 'findings')
    ..pPS(7, _omitFieldNames ? '' : 'specimenIds')
    ..pPS(8, _omitFieldNames ? '' : 'implantIds')
    ..pPS(9, _omitFieldNames ? '' : 'complications')
    ..aI(10, _omitFieldNames ? '' : 'estimatedBloodLossMl')
    ..aOS(11, _omitFieldNames ? '' : 'postOperativeOrders')
    ..aOS(12, _omitFieldNames ? '' : 'narrative')
    ..aE<NoteStatus>(13, _omitFieldNames ? '' : 'status',
        enumValues: NoteStatus.values)
    ..aOS(14, _omitFieldNames ? '' : 'amendmentReason')
    ..aOS(15, _omitFieldNames ? '' : 'authoredBy')
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'authoredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(17, _omitFieldNames ? '' : 'signedBy')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'signedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperativeNote clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperativeNote copyWith(void Function(OperativeNote) updates) =>
      super.copyWith((message) => updates(message as OperativeNote))
          as OperativeNote;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OperativeNote create() => OperativeNote._();
  @$core.override
  OperativeNote createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OperativeNote getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OperativeNote>(create);
  static OperativeNote? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get noteId => $_getSZ(0);
  @$pb.TagNumber(1)
  set noteId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNoteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNoteId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  /// Versioned rather than edited once signed. An operative note is read in a
  /// complaint, a claim and a coroner's court.
  @$pb.TagNumber(3)
  $core.int get version => $_getIZ(2);
  @$pb.TagNumber(3)
  set version($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get supersedes => $_getSZ(3);
  @$pb.TagNumber(4)
  set supersedes($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSupersedes() => $_has(3);
  @$pb.TagNumber(4)
  void clearSupersedes() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get procedurePerformed => $_getSZ(4);
  @$pb.TagNumber(5)
  set procedurePerformed($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProcedurePerformed() => $_has(4);
  @$pb.TagNumber(5)
  void clearProcedurePerformed() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get findings => $_getSZ(5);
  @$pb.TagNumber(6)
  set findings($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFindings() => $_has(5);
  @$pb.TagNumber(6)
  void clearFindings() => $_clearField(6);

  /// Structured rather than buried in the narrative: each list is read by a
  /// different department.
  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get specimenIds => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get implantIds => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get complications => $_getList(8);

  /// A number rather than a phrase: "minimal" means different things to
  /// different surgeons, and the transfusion service needs a figure.
  @$pb.TagNumber(10)
  $core.int get estimatedBloodLossMl => $_getIZ(9);
  @$pb.TagNumber(10)
  set estimatedBloodLossMl($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasEstimatedBloodLossMl() => $_has(9);
  @$pb.TagNumber(10)
  void clearEstimatedBloodLossMl() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get postOperativeOrders => $_getSZ(10);
  @$pb.TagNumber(11)
  set postOperativeOrders($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPostOperativeOrders() => $_has(10);
  @$pb.TagNumber(11)
  void clearPostOperativeOrders() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get narrative => $_getSZ(11);
  @$pb.TagNumber(12)
  set narrative($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasNarrative() => $_has(11);
  @$pb.TagNumber(12)
  void clearNarrative() => $_clearField(12);

  @$pb.TagNumber(13)
  NoteStatus get status => $_getN(12);
  @$pb.TagNumber(13)
  set status(NoteStatus value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasStatus() => $_has(12);
  @$pb.TagNumber(13)
  void clearStatus() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get amendmentReason => $_getSZ(13);
  @$pb.TagNumber(14)
  set amendmentReason($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasAmendmentReason() => $_has(13);
  @$pb.TagNumber(14)
  void clearAmendmentReason() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get authoredBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set authoredBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasAuthoredBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearAuthoredBy() => $_clearField(15);

  @$pb.TagNumber(16)
  $0.Timestamp get authoredAt => $_getN(15);
  @$pb.TagNumber(16)
  set authoredAt($0.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasAuthoredAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearAuthoredAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureAuthoredAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.String get signedBy => $_getSZ(16);
  @$pb.TagNumber(17)
  set signedBy($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasSignedBy() => $_has(16);
  @$pb.TagNumber(17)
  void clearSignedBy() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get signedAt => $_getN(17);
  @$pb.TagNumber(18)
  set signedAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasSignedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearSignedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureSignedAt() => $_ensure(17);
}

class Usage extends $pb.GeneratedMessage {
  factory Usage({
    $core.String? usageId,
    $core.String? caseId,
    UsageKind? kind,
    $core.String? itemCode,
    $core.String? itemName,
    $core.String? lotNumber,
    $core.String? serialNumber,
    $core.int? quantity,
    $0.Timestamp? expiryDate,
    $core.bool? scanned,
    $core.String? scanData,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
    $core.bool? expired,
  }) {
    final result = create();
    if (usageId != null) result.usageId = usageId;
    if (caseId != null) result.caseId = caseId;
    if (kind != null) result.kind = kind;
    if (itemCode != null) result.itemCode = itemCode;
    if (itemName != null) result.itemName = itemName;
    if (lotNumber != null) result.lotNumber = lotNumber;
    if (serialNumber != null) result.serialNumber = serialNumber;
    if (quantity != null) result.quantity = quantity;
    if (expiryDate != null) result.expiryDate = expiryDate;
    if (scanned != null) result.scanned = scanned;
    if (scanData != null) result.scanData = scanData;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (expired != null) result.expired = expired;
    return result;
  }

  Usage._();

  factory Usage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Usage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Usage',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'usageId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aE<UsageKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: UsageKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'itemCode')
    ..aOS(5, _omitFieldNames ? '' : 'itemName')
    ..aOS(6, _omitFieldNames ? '' : 'lotNumber')
    ..aOS(7, _omitFieldNames ? '' : 'serialNumber')
    ..aI(8, _omitFieldNames ? '' : 'quantity')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'expiryDate',
        subBuilder: $0.Timestamp.create)
    ..aOB(10, _omitFieldNames ? '' : 'scanned')
    ..aOS(11, _omitFieldNames ? '' : 'scanData')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'recordedBy')
    ..aOB(14, _omitFieldNames ? '' : 'expired')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Usage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Usage copyWith(void Function(Usage) updates) =>
      super.copyWith((message) => updates(message as Usage)) as Usage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Usage create() => Usage._();
  @$core.override
  Usage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Usage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Usage>(create);
  static Usage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get usageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set usageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  @$pb.TagNumber(3)
  UsageKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(UsageKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get itemCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set itemCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasItemCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearItemCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get itemName => $_getSZ(4);
  @$pb.TagNumber(5)
  set itemName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasItemName() => $_has(4);
  @$pb.TagNumber(5)
  void clearItemName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get lotNumber => $_getSZ(5);
  @$pb.TagNumber(6)
  set lotNumber($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLotNumber() => $_has(5);
  @$pb.TagNumber(6)
  void clearLotNumber() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get serialNumber => $_getSZ(6);
  @$pb.TagNumber(7)
  set serialNumber($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSerialNumber() => $_has(6);
  @$pb.TagNumber(7)
  void clearSerialNumber() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get quantity => $_getIZ(7);
  @$pb.TagNumber(8)
  set quantity($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasQuantity() => $_has(7);
  @$pb.TagNumber(8)
  void clearQuantity() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get expiryDate => $_getN(8);
  @$pb.TagNumber(9)
  set expiryDate($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasExpiryDate() => $_has(8);
  @$pb.TagNumber(9)
  void clearExpiryDate() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureExpiryDate() => $_ensure(8);

  /// "Inventory decrement and patient charge are traceable to scan", which a
  /// typed item is not.
  @$pb.TagNumber(10)
  $core.bool get scanned => $_getBF(9);
  @$pb.TagNumber(10)
  set scanned($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasScanned() => $_has(9);
  @$pb.TagNumber(10)
  void clearScanned() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get scanData => $_getSZ(10);
  @$pb.TagNumber(11)
  set scanData($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasScanData() => $_has(10);
  @$pb.TagNumber(11)
  void clearScanData() => $_clearField(11);

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
  $core.String get recordedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set recordedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRecordedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearRecordedBy() => $_clearField(13);

  /// Derived per response: an item used past its expiry date is a governance
  /// event, recorded rather than refused.
  @$pb.TagNumber(14)
  $core.bool get expired => $_getBF(13);
  @$pb.TagNumber(14)
  set expired($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasExpired() => $_has(13);
  @$pb.TagNumber(14)
  void clearExpired() => $_clearField(14);
}

class Specimen extends $pb.GeneratedMessage {
  factory Specimen({
    $core.String? specimenId,
    $core.String? caseId,
    $core.String? patientId,
    $core.String? label,
    $core.String? site,
    Laterality? laterality,
    $core.String? container,
    $core.String? fixative,
    $core.String? orderId,
    $0.Timestamp? takenAt,
    $core.String? takenBy,
  }) {
    final result = create();
    if (specimenId != null) result.specimenId = specimenId;
    if (caseId != null) result.caseId = caseId;
    if (patientId != null) result.patientId = patientId;
    if (label != null) result.label = label;
    if (site != null) result.site = site;
    if (laterality != null) result.laterality = laterality;
    if (container != null) result.container = container;
    if (fixative != null) result.fixative = fixative;
    if (orderId != null) result.orderId = orderId;
    if (takenAt != null) result.takenAt = takenAt;
    if (takenBy != null) result.takenBy = takenBy;
    return result;
  }

  Specimen._();

  factory Specimen.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Specimen.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Specimen',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'specimenId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'label')
    ..aOS(5, _omitFieldNames ? '' : 'site')
    ..aE<Laterality>(6, _omitFieldNames ? '' : 'laterality',
        enumValues: Laterality.values)
    ..aOS(7, _omitFieldNames ? '' : 'container')
    ..aOS(8, _omitFieldNames ? '' : 'fixative')
    ..aOS(9, _omitFieldNames ? '' : 'orderId')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'takenAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'takenBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Specimen clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Specimen copyWith(void Function(Specimen) updates) =>
      super.copyWith((message) => updates(message as Specimen)) as Specimen;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Specimen create() => Specimen._();
  @$core.override
  Specimen createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Specimen getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Specimen>(create);
  static Specimen? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get specimenId => $_getSZ(0);
  @$pb.TagNumber(1)
  set specimenId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSpecimenId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSpecimenId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get patientId => $_getSZ(2);
  @$pb.TagNumber(3)
  set patientId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPatientId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatientId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get label => $_getSZ(3);
  @$pb.TagNumber(4)
  set label($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLabel() => $_has(3);
  @$pb.TagNumber(4)
  void clearLabel() => $_clearField(4);

  /// The site is half of every histology report, and the half that cannot be
  /// reconstructed afterwards.
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
  $core.String get container => $_getSZ(6);
  @$pb.TagNumber(7)
  set container($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasContainer() => $_has(6);
  @$pb.TagNumber(7)
  void clearContainer() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get fixative => $_getSZ(7);
  @$pb.TagNumber(8)
  set fixative($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFixative() => $_has(7);
  @$pb.TagNumber(8)
  void clearFixative() => $_clearField(8);

  /// The diagnostic order raised for it. Empty means the chain has not started,
  /// which is what the outstanding list looks for.
  @$pb.TagNumber(9)
  $core.String get orderId => $_getSZ(8);
  @$pb.TagNumber(9)
  set orderId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOrderId() => $_has(8);
  @$pb.TagNumber(9)
  void clearOrderId() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get takenAt => $_getN(9);
  @$pb.TagNumber(10)
  set takenAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasTakenAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearTakenAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureTakenAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get takenBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set takenBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTakenBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearTakenBy() => $_clearField(11);
}

class TrayUse extends $pb.GeneratedMessage {
  factory TrayUse({
    $core.String? trayUseId,
    $core.String? caseId,
    $core.String? trayId,
    $core.String? trayName,
    $core.String? cycleId,
    $core.bool? indicatorPassed,
    $core.String? indicatorNote,
    $0.Timestamp? openedAt,
    $core.String? openedBy,
  }) {
    final result = create();
    if (trayUseId != null) result.trayUseId = trayUseId;
    if (caseId != null) result.caseId = caseId;
    if (trayId != null) result.trayId = trayId;
    if (trayName != null) result.trayName = trayName;
    if (cycleId != null) result.cycleId = cycleId;
    if (indicatorPassed != null) result.indicatorPassed = indicatorPassed;
    if (indicatorNote != null) result.indicatorNote = indicatorNote;
    if (openedAt != null) result.openedAt = openedAt;
    if (openedBy != null) result.openedBy = openedBy;
    return result;
  }

  TrayUse._();

  factory TrayUse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrayUse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrayUse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trayUseId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aOS(3, _omitFieldNames ? '' : 'trayId')
    ..aOS(4, _omitFieldNames ? '' : 'trayName')
    ..aOS(5, _omitFieldNames ? '' : 'cycleId')
    ..aOB(6, _omitFieldNames ? '' : 'indicatorPassed')
    ..aOS(7, _omitFieldNames ? '' : 'indicatorNote')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'openedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'openedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrayUse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrayUse copyWith(void Function(TrayUse) updates) =>
      super.copyWith((message) => updates(message as TrayUse)) as TrayUse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrayUse create() => TrayUse._();
  @$core.override
  TrayUse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TrayUse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrayUse>(create);
  static TrayUse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trayUseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trayUseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrayUseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrayUseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get trayId => $_getSZ(2);
  @$pb.TagNumber(3)
  set trayId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTrayId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrayId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get trayName => $_getSZ(3);
  @$pb.TagNumber(4)
  set trayName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTrayName() => $_has(3);
  @$pb.TagNumber(4)
  void clearTrayName() => $_clearField(4);

  /// The sterilisation cycle the tray came out of. Without it there is no chain
  /// for an infection investigation to run back along.
  @$pb.TagNumber(5)
  $core.String get cycleId => $_getSZ(4);
  @$pb.TagNumber(5)
  set cycleId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCycleId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCycleId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get indicatorPassed => $_getBF(5);
  @$pb.TagNumber(6)
  set indicatorPassed($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIndicatorPassed() => $_has(5);
  @$pb.TagNumber(6)
  void clearIndicatorPassed() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get indicatorNote => $_getSZ(6);
  @$pb.TagNumber(7)
  set indicatorNote($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIndicatorNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearIndicatorNote() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get openedAt => $_getN(7);
  @$pb.TagNumber(8)
  set openedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasOpenedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearOpenedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureOpenedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get openedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set openedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOpenedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearOpenedBy() => $_clearField(9);
}

/// A patient reached by a recall or an infection investigation.
///
/// Deliberately thin: identifiers and what links them, no clinical detail.
/// Both lists are read by people outside the care team.
class Recipient extends $pb.GeneratedMessage {
  factory Recipient({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? caseId,
    $core.String? reference,
    $0.Timestamp? at,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (caseId != null) result.caseId = caseId;
    if (reference != null) result.reference = reference;
    if (at != null) result.at = at;
    return result;
  }

  Recipient._();

  factory Recipient.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Recipient.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Recipient',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'caseId')
    ..aOS(4, _omitFieldNames ? '' : 'reference')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'at',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Recipient clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Recipient copyWith(void Function(Recipient) updates) =>
      super.copyWith((message) => updates(message as Recipient)) as Recipient;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Recipient create() => Recipient._();
  @$core.override
  Recipient createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Recipient getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Recipient>(create);
  static Recipient? _defaultInstance;

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
  $core.String get caseId => $_getSZ(2);
  @$pb.TagNumber(3)
  set caseId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCaseId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCaseId() => $_clearField(3);

  /// The serial, lot or tray that links them.
  @$pb.TagNumber(4)
  $core.String get reference => $_getSZ(3);
  @$pb.TagNumber(4)
  set reference($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReference() => $_has(3);
  @$pb.TagNumber(4)
  void clearReference() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get at => $_getN(4);
  @$pb.TagNumber(5)
  set at($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureAt() => $_ensure(4);
}

class CardItem extends $pb.GeneratedMessage {
  factory CardItem({
    $core.String? itemCode,
    $core.String? itemName,
    $core.int? quantity,
  }) {
    final result = create();
    if (itemCode != null) result.itemCode = itemCode;
    if (itemName != null) result.itemName = itemName;
    if (quantity != null) result.quantity = quantity;
    return result;
  }

  CardItem._();

  factory CardItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CardItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CardItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemCode')
    ..aOS(2, _omitFieldNames ? '' : 'itemName')
    ..aI(3, _omitFieldNames ? '' : 'quantity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardItem copyWith(void Function(CardItem) updates) =>
      super.copyWith((message) => updates(message as CardItem)) as CardItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CardItem create() => CardItem._();
  @$core.override
  CardItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CardItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CardItem>(create);
  static CardItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemName => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemName() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get quantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);
}

/// A surgeon's usual requirements (SRS-OT-016).
///
/// Seeds a case and never constrains what is actually used: a system that
/// refused an instrument because it was not on the card would have theatre
/// staff editing cards mid-case.
class PreferenceCard extends $pb.GeneratedMessage {
  factory PreferenceCard({
    $core.String? cardId,
    $core.String? surgeonId,
    $core.String? procedureCode,
    $core.String? name,
    $core.Iterable<$core.String>? equipment,
    $core.Iterable<CardItem>? consumables,
    $core.Iterable<$core.String>? trays,
    $core.String? notes,
    $core.int? version,
    $0.Timestamp? updatedAt,
    $core.String? updatedBy,
  }) {
    final result = create();
    if (cardId != null) result.cardId = cardId;
    if (surgeonId != null) result.surgeonId = surgeonId;
    if (procedureCode != null) result.procedureCode = procedureCode;
    if (name != null) result.name = name;
    if (equipment != null) result.equipment.addAll(equipment);
    if (consumables != null) result.consumables.addAll(consumables);
    if (trays != null) result.trays.addAll(trays);
    if (notes != null) result.notes = notes;
    if (version != null) result.version = version;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (updatedBy != null) result.updatedBy = updatedBy;
    return result;
  }

  PreferenceCard._();

  factory PreferenceCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PreferenceCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PreferenceCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cardId')
    ..aOS(2, _omitFieldNames ? '' : 'surgeonId')
    ..aOS(3, _omitFieldNames ? '' : 'procedureCode')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..pPS(5, _omitFieldNames ? '' : 'equipment')
    ..pPM<CardItem>(6, _omitFieldNames ? '' : 'consumables',
        subBuilder: CardItem.create)
    ..pPS(7, _omitFieldNames ? '' : 'trays')
    ..aOS(8, _omitFieldNames ? '' : 'notes')
    ..aI(9, _omitFieldNames ? '' : 'version')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'updatedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreferenceCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreferenceCard copyWith(void Function(PreferenceCard) updates) =>
      super.copyWith((message) => updates(message as PreferenceCard))
          as PreferenceCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PreferenceCard create() => PreferenceCard._();
  @$core.override
  PreferenceCard createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PreferenceCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreferenceCard>(create);
  static PreferenceCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cardId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cardId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCardId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCardId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get surgeonId => $_getSZ(1);
  @$pb.TagNumber(2)
  set surgeonId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSurgeonId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSurgeonId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get procedureCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set procedureCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProcedureCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearProcedureCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get equipment => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<CardItem> get consumables => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get trays => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get notes => $_getSZ(7);
  @$pb.TagNumber(8)
  set notes($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNotes() => $_has(7);
  @$pb.TagNumber(8)
  void clearNotes() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get version => $_getIZ(8);
  @$pb.TagNumber(9)
  set version($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasVersion() => $_has(8);
  @$pb.TagNumber(9)
  void clearVersion() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get updatedAt => $_getN(9);
  @$pb.TagNumber(10)
  set updatedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasUpdatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpdatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureUpdatedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get updatedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set updatedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdatedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedBy() => $_clearField(11);
}

class BoardRow extends $pb.GeneratedMessage {
  factory BoardRow({
    $core.String? roomId,
    $core.String? roomCode,
    RoomStage? stage,
    $core.String? currentCaseId,
    $core.String? currentProcedure,
    $core.String? currentSurgeon,
    Milestone? currentMilestone,
    $fixnum.Int64? elapsedSeconds,
    $core.bool? overRunning,
    $core.String? nextCaseId,
    $core.String? nextProcedure,
    $0.Timestamp? nextStart,
    $core.bool? nextReady,
    $core.Iterable<$core.String>? nextBlockers,
    $fixnum.Int64? turnoverSoFarSeconds,
    $core.int? delayMinutes,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (roomCode != null) result.roomCode = roomCode;
    if (stage != null) result.stage = stage;
    if (currentCaseId != null) result.currentCaseId = currentCaseId;
    if (currentProcedure != null) result.currentProcedure = currentProcedure;
    if (currentSurgeon != null) result.currentSurgeon = currentSurgeon;
    if (currentMilestone != null) result.currentMilestone = currentMilestone;
    if (elapsedSeconds != null) result.elapsedSeconds = elapsedSeconds;
    if (overRunning != null) result.overRunning = overRunning;
    if (nextCaseId != null) result.nextCaseId = nextCaseId;
    if (nextProcedure != null) result.nextProcedure = nextProcedure;
    if (nextStart != null) result.nextStart = nextStart;
    if (nextReady != null) result.nextReady = nextReady;
    if (nextBlockers != null) result.nextBlockers.addAll(nextBlockers);
    if (turnoverSoFarSeconds != null)
      result.turnoverSoFarSeconds = turnoverSoFarSeconds;
    if (delayMinutes != null) result.delayMinutes = delayMinutes;
    return result;
  }

  BoardRow._();

  factory BoardRow.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BoardRow.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BoardRow',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'roomCode')
    ..aE<RoomStage>(3, _omitFieldNames ? '' : 'stage',
        enumValues: RoomStage.values)
    ..aOS(4, _omitFieldNames ? '' : 'currentCaseId')
    ..aOS(5, _omitFieldNames ? '' : 'currentProcedure')
    ..aOS(6, _omitFieldNames ? '' : 'currentSurgeon')
    ..aE<Milestone>(7, _omitFieldNames ? '' : 'currentMilestone',
        enumValues: Milestone.values)
    ..aInt64(8, _omitFieldNames ? '' : 'elapsedSeconds')
    ..aOB(9, _omitFieldNames ? '' : 'overRunning')
    ..aOS(10, _omitFieldNames ? '' : 'nextCaseId')
    ..aOS(11, _omitFieldNames ? '' : 'nextProcedure')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'nextStart',
        subBuilder: $0.Timestamp.create)
    ..aOB(13, _omitFieldNames ? '' : 'nextReady')
    ..pPS(14, _omitFieldNames ? '' : 'nextBlockers')
    ..aInt64(15, _omitFieldNames ? '' : 'turnoverSoFarSeconds')
    ..aI(16, _omitFieldNames ? '' : 'delayMinutes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BoardRow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BoardRow copyWith(void Function(BoardRow) updates) =>
      super.copyWith((message) => updates(message as BoardRow)) as BoardRow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BoardRow create() => BoardRow._();
  @$core.override
  BoardRow createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BoardRow getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BoardRow>(create);
  static BoardRow? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get roomCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoomCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomCode() => $_clearField(2);

  @$pb.TagNumber(3)
  RoomStage get stage => $_getN(2);
  @$pb.TagNumber(3)
  set stage(RoomStage value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStage() => $_has(2);
  @$pb.TagNumber(3)
  void clearStage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get currentCaseId => $_getSZ(3);
  @$pb.TagNumber(4)
  set currentCaseId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCurrentCaseId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrentCaseId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get currentProcedure => $_getSZ(4);
  @$pb.TagNumber(5)
  set currentProcedure($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrentProcedure() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrentProcedure() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currentSurgeon => $_getSZ(5);
  @$pb.TagNumber(6)
  set currentSurgeon($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrentSurgeon() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrentSurgeon() => $_clearField(6);

  /// The stage the case has reached, which is what "status derives from
  /// milestones" means.
  @$pb.TagNumber(7)
  Milestone get currentMilestone => $_getN(6);
  @$pb.TagNumber(7)
  set currentMilestone(Milestone value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCurrentMilestone() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrentMilestone() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get elapsedSeconds => $_getI64(7);
  @$pb.TagNumber(8)
  set elapsedSeconds($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasElapsedSeconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearElapsedSeconds() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get overRunning => $_getBF(8);
  @$pb.TagNumber(9)
  set overRunning($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOverRunning() => $_has(8);
  @$pb.TagNumber(9)
  void clearOverRunning() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get nextCaseId => $_getSZ(9);
  @$pb.TagNumber(10)
  set nextCaseId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasNextCaseId() => $_has(9);
  @$pb.TagNumber(10)
  void clearNextCaseId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get nextProcedure => $_getSZ(10);
  @$pb.TagNumber(11)
  set nextProcedure($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNextProcedure() => $_has(10);
  @$pb.TagNumber(11)
  void clearNextProcedure() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get nextStart => $_getN(11);
  @$pb.TagNumber(12)
  set nextStart($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasNextStart() => $_has(11);
  @$pb.TagNumber(12)
  void clearNextStart() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureNextStart() => $_ensure(11);

  /// The one thing a theatre manager most wants to know and most often cannot
  /// see.
  @$pb.TagNumber(13)
  $core.bool get nextReady => $_getBF(12);
  @$pb.TagNumber(13)
  set nextReady($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasNextReady() => $_has(12);
  @$pb.TagNumber(13)
  void clearNextReady() => $_clearField(13);

  @$pb.TagNumber(14)
  $pb.PbList<$core.String> get nextBlockers => $_getList(13);

  @$pb.TagNumber(15)
  $fixnum.Int64 get turnoverSoFarSeconds => $_getI64(14);
  @$pb.TagNumber(15)
  set turnoverSoFarSeconds($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasTurnoverSoFarSeconds() => $_has(14);
  @$pb.TagNumber(15)
  void clearTurnoverSoFarSeconds() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get delayMinutes => $_getIZ(15);
  @$pb.TagNumber(16)
  set delayMinutes($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasDelayMinutes() => $_has(15);
  @$pb.TagNumber(16)
  void clearDelayMinutes() => $_clearField(16);
}

class CauseCount extends $pb.GeneratedMessage {
  factory CauseCount({
    CaseCause? cause,
    $core.int? count,
  }) {
    final result = create();
    if (cause != null) result.cause = cause;
    if (count != null) result.count = count;
    return result;
  }

  CauseCount._();

  factory CauseCount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CauseCount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CauseCount',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aE<CaseCause>(1, _omitFieldNames ? '' : 'cause',
        enumValues: CaseCause.values)
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CauseCount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CauseCount copyWith(void Function(CauseCount) updates) =>
      super.copyWith((message) => updates(message as CauseCount)) as CauseCount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CauseCount create() => CauseCount._();
  @$core.override
  CauseCount createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CauseCount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CauseCount>(create);
  static CauseCount? _defaultInstance;

  @$pb.TagNumber(1)
  CaseCause get cause => $_getN(0);
  @$pb.TagNumber(1)
  set cause(CaseCause value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCause() => $_has(0);
  @$pb.TagNumber(1)
  void clearCause() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);
}

class DelayCount extends $pb.GeneratedMessage {
  factory DelayCount({
    DelayReason? reason,
    $core.int? minutes,
  }) {
    final result = create();
    if (reason != null) result.reason = reason;
    if (minutes != null) result.minutes = minutes;
    return result;
  }

  DelayCount._();

  factory DelayCount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelayCount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelayCount',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aE<DelayReason>(1, _omitFieldNames ? '' : 'reason',
        enumValues: DelayReason.values)
    ..aI(2, _omitFieldNames ? '' : 'minutes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelayCount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelayCount copyWith(void Function(DelayCount) updates) =>
      super.copyWith((message) => updates(message as DelayCount)) as DelayCount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelayCount create() => DelayCount._();
  @$core.override
  DelayCount createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelayCount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelayCount>(create);
  static DelayCount? _defaultInstance;

  @$pb.TagNumber(1)
  DelayReason get reason => $_getN(0);
  @$pb.TagNumber(1)
  set reason(DelayReason value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get minutes => $_getIZ(1);
  @$pb.TagNumber(2)
  set minutes($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMinutes() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinutes() => $_clearField(2);
}

/// SRS-OT-015: derived from the recorded timestamps every time, never stored.
class Utilisation extends $pb.GeneratedMessage {
  factory Utilisation({
    $core.String? roomId,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? scheduledMinutes,
    $core.int? operatingMinutes,
    $core.int? blockMinutes,
    $core.int? cases,
    $core.int? completed,
    $core.int? cancelled,
    $core.int? postponed,
    $core.Iterable<CauseCount>? cancellationsByCause,
    $core.int? onTimeStarts,
    $core.int? firstCases,
    $core.int? onTimeFirstCases,
    $core.int? turnoverCount,
    $core.int? turnoverMinutes,
    $core.int? delayMinutes,
    $core.Iterable<DelayCount>? delaysByReason,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (scheduledMinutes != null) result.scheduledMinutes = scheduledMinutes;
    if (operatingMinutes != null) result.operatingMinutes = operatingMinutes;
    if (blockMinutes != null) result.blockMinutes = blockMinutes;
    if (cases != null) result.cases = cases;
    if (completed != null) result.completed = completed;
    if (cancelled != null) result.cancelled = cancelled;
    if (postponed != null) result.postponed = postponed;
    if (cancellationsByCause != null)
      result.cancellationsByCause.addAll(cancellationsByCause);
    if (onTimeStarts != null) result.onTimeStarts = onTimeStarts;
    if (firstCases != null) result.firstCases = firstCases;
    if (onTimeFirstCases != null) result.onTimeFirstCases = onTimeFirstCases;
    if (turnoverCount != null) result.turnoverCount = turnoverCount;
    if (turnoverMinutes != null) result.turnoverMinutes = turnoverMinutes;
    if (delayMinutes != null) result.delayMinutes = delayMinutes;
    if (delaysByReason != null) result.delaysByReason.addAll(delaysByReason);
    return result;
  }

  Utilisation._();

  factory Utilisation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Utilisation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Utilisation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(4, _omitFieldNames ? '' : 'scheduledMinutes')
    ..aI(5, _omitFieldNames ? '' : 'operatingMinutes')
    ..aI(6, _omitFieldNames ? '' : 'blockMinutes')
    ..aI(7, _omitFieldNames ? '' : 'cases')
    ..aI(8, _omitFieldNames ? '' : 'completed')
    ..aI(9, _omitFieldNames ? '' : 'cancelled')
    ..aI(10, _omitFieldNames ? '' : 'postponed')
    ..pPM<CauseCount>(11, _omitFieldNames ? '' : 'cancellationsByCause',
        subBuilder: CauseCount.create)
    ..aI(12, _omitFieldNames ? '' : 'onTimeStarts')
    ..aI(13, _omitFieldNames ? '' : 'firstCases')
    ..aI(14, _omitFieldNames ? '' : 'onTimeFirstCases')
    ..aI(15, _omitFieldNames ? '' : 'turnoverCount')
    ..aI(16, _omitFieldNames ? '' : 'turnoverMinutes')
    ..aI(17, _omitFieldNames ? '' : 'delayMinutes')
    ..pPM<DelayCount>(18, _omitFieldNames ? '' : 'delaysByReason',
        subBuilder: DelayCount.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Utilisation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Utilisation copyWith(void Function(Utilisation) updates) =>
      super.copyWith((message) => updates(message as Utilisation))
          as Utilisation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Utilisation create() => Utilisation._();
  @$core.override
  Utilisation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Utilisation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Utilisation>(create);
  static Utilisation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

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

  /// Three numbers, because the ratio anybody quotes depends on which pair they
  /// divided.
  @$pb.TagNumber(4)
  $core.int get scheduledMinutes => $_getIZ(3);
  @$pb.TagNumber(4)
  set scheduledMinutes($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScheduledMinutes() => $_has(3);
  @$pb.TagNumber(4)
  void clearScheduledMinutes() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get operatingMinutes => $_getIZ(4);
  @$pb.TagNumber(5)
  set operatingMinutes($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOperatingMinutes() => $_has(4);
  @$pb.TagNumber(5)
  void clearOperatingMinutes() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get blockMinutes => $_getIZ(5);
  @$pb.TagNumber(6)
  set blockMinutes($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBlockMinutes() => $_has(5);
  @$pb.TagNumber(6)
  void clearBlockMinutes() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get cases => $_getIZ(6);
  @$pb.TagNumber(7)
  set cases($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCases() => $_has(6);
  @$pb.TagNumber(7)
  void clearCases() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get completed => $_getIZ(7);
  @$pb.TagNumber(8)
  set completed($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCompleted() => $_has(7);
  @$pb.TagNumber(8)
  void clearCompleted() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get cancelled => $_getIZ(8);
  @$pb.TagNumber(9)
  set cancelled($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCancelled() => $_has(8);
  @$pb.TagNumber(9)
  void clearCancelled() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get postponed => $_getIZ(9);
  @$pb.TagNumber(10)
  set postponed($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPostponed() => $_has(9);
  @$pb.TagNumber(10)
  void clearPostponed() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<CauseCount> get cancellationsByCause => $_getList(10);

  @$pb.TagNumber(12)
  $core.int get onTimeStarts => $_getIZ(11);
  @$pb.TagNumber(12)
  set onTimeStarts($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOnTimeStarts() => $_has(11);
  @$pb.TagNumber(12)
  void clearOnTimeStarts() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get firstCases => $_getIZ(12);
  @$pb.TagNumber(13)
  set firstCases($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasFirstCases() => $_has(12);
  @$pb.TagNumber(13)
  void clearFirstCases() => $_clearField(13);

  /// The number a theatre is actually judged on.
  @$pb.TagNumber(14)
  $core.int get onTimeFirstCases => $_getIZ(13);
  @$pb.TagNumber(14)
  set onTimeFirstCases($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasOnTimeFirstCases() => $_has(13);
  @$pb.TagNumber(14)
  void clearOnTimeFirstCases() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get turnoverCount => $_getIZ(14);
  @$pb.TagNumber(15)
  set turnoverCount($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasTurnoverCount() => $_has(14);
  @$pb.TagNumber(15)
  void clearTurnoverCount() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get turnoverMinutes => $_getIZ(15);
  @$pb.TagNumber(16)
  set turnoverMinutes($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasTurnoverMinutes() => $_has(15);
  @$pb.TagNumber(16)
  void clearTurnoverMinutes() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.int get delayMinutes => $_getIZ(16);
  @$pb.TagNumber(17)
  set delayMinutes($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasDelayMinutes() => $_has(16);
  @$pb.TagNumber(17)
  void clearDelayMinutes() => $_clearField(17);

  @$pb.TagNumber(18)
  $pb.PbList<DelayCount> get delaysByReason => $_getList(17);
}

class SaveRoomRequest extends $pb.GeneratedMessage {
  factory SaveRoomRequest({
    $core.String? roomId,
    $core.String? facilityId,
    $core.String? code,
    $core.String? name,
    $core.Iterable<$core.String>? specialties,
    $core.Iterable<$core.String>? equipment,
    $core.bool? active,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (facilityId != null) result.facilityId = facilityId;
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (specialties != null) result.specialties.addAll(specialties);
    if (equipment != null) result.equipment.addAll(equipment);
    if (active != null) result.active = active;
    return result;
  }

  SaveRoomRequest._();

  factory SaveRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SaveRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SaveRoomRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..pPS(5, _omitFieldNames ? '' : 'specialties')
    ..pPS(6, _omitFieldNames ? '' : 'equipment')
    ..aOB(7, _omitFieldNames ? '' : 'active')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveRoomRequest copyWith(void Function(SaveRoomRequest) updates) =>
      super.copyWith((message) => updates(message as SaveRoomRequest))
          as SaveRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SaveRoomRequest create() => SaveRoomRequest._();
  @$core.override
  SaveRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SaveRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SaveRoomRequest>(create);
  static SaveRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get specialties => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get equipment => $_getList(5);

  @$pb.TagNumber(7)
  $core.bool get active => $_getBF(6);
  @$pb.TagNumber(7)
  set active($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasActive() => $_has(6);
  @$pb.TagNumber(7)
  void clearActive() => $_clearField(7);
}

class SaveRoomResponse extends $pb.GeneratedMessage {
  factory SaveRoomResponse({
    Room? room,
  }) {
    final result = create();
    if (room != null) result.room = room;
    return result;
  }

  SaveRoomResponse._();

  factory SaveRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SaveRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SaveRoomResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<Room>(1, _omitFieldNames ? '' : 'room', subBuilder: Room.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveRoomResponse copyWith(void Function(SaveRoomResponse) updates) =>
      super.copyWith((message) => updates(message as SaveRoomResponse))
          as SaveRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SaveRoomResponse create() => SaveRoomResponse._();
  @$core.override
  SaveRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SaveRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SaveRoomResponse>(create);
  static SaveRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Room get room => $_getN(0);
  @$pb.TagNumber(1)
  set room(Room value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  Room ensureRoom() => $_ensure(0);
}

class ListRoomsRequest extends $pb.GeneratedMessage {
  factory ListRoomsRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  ListRoomsRequest._();

  factory ListRoomsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRoomsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRoomsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomsRequest copyWith(void Function(ListRoomsRequest) updates) =>
      super.copyWith((message) => updates(message as ListRoomsRequest))
          as ListRoomsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRoomsRequest create() => ListRoomsRequest._();
  @$core.override
  ListRoomsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRoomsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRoomsRequest>(create);
  static ListRoomsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

class ListRoomsResponse extends $pb.GeneratedMessage {
  factory ListRoomsResponse({
    $core.Iterable<Room>? rooms,
  }) {
    final result = create();
    if (rooms != null) result.rooms.addAll(rooms);
    return result;
  }

  ListRoomsResponse._();

  factory ListRoomsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRoomsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRoomsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..pPM<Room>(1, _omitFieldNames ? '' : 'rooms', subBuilder: Room.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomsResponse copyWith(void Function(ListRoomsResponse) updates) =>
      super.copyWith((message) => updates(message as ListRoomsResponse))
          as ListRoomsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRoomsResponse create() => ListRoomsResponse._();
  @$core.override
  ListRoomsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRoomsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRoomsResponse>(create);
  static ListRoomsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Room> get rooms => $_getList(0);
}

class SaveBlockRequest extends $pb.GeneratedMessage {
  factory SaveBlockRequest({
    $core.String? roomId,
    BlockKind? kind,
    $core.String? ownerId,
    $core.String? specialty,
    $0.Timestamp? startsAt,
    $0.Timestamp? endsAt,
    $core.String? note,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (kind != null) result.kind = kind;
    if (ownerId != null) result.ownerId = ownerId;
    if (specialty != null) result.specialty = specialty;
    if (startsAt != null) result.startsAt = startsAt;
    if (endsAt != null) result.endsAt = endsAt;
    if (note != null) result.note = note;
    return result;
  }

  SaveBlockRequest._();

  factory SaveBlockRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SaveBlockRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SaveBlockRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aE<BlockKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: BlockKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'ownerId')
    ..aOS(4, _omitFieldNames ? '' : 'specialty')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'endsAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveBlockRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveBlockRequest copyWith(void Function(SaveBlockRequest) updates) =>
      super.copyWith((message) => updates(message as SaveBlockRequest))
          as SaveBlockRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SaveBlockRequest create() => SaveBlockRequest._();
  @$core.override
  SaveBlockRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SaveBlockRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SaveBlockRequest>(create);
  static SaveBlockRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  BlockKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(BlockKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get ownerId => $_getSZ(2);
  @$pb.TagNumber(3)
  set ownerId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOwnerId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOwnerId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get specialty => $_getSZ(3);
  @$pb.TagNumber(4)
  set specialty($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSpecialty() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpecialty() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get startsAt => $_getN(4);
  @$pb.TagNumber(5)
  set startsAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStartsAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartsAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureStartsAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get endsAt => $_getN(5);
  @$pb.TagNumber(6)
  set endsAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEndsAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearEndsAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureEndsAt() => $_ensure(5);

  /// Required for downtime: a closed theatre is one somebody will ask about.
  @$pb.TagNumber(7)
  $core.String get note => $_getSZ(6);
  @$pb.TagNumber(7)
  set note($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearNote() => $_clearField(7);
}

class SaveBlockResponse extends $pb.GeneratedMessage {
  factory SaveBlockResponse({
    Block? block,
  }) {
    final result = create();
    if (block != null) result.block = block;
    return result;
  }

  SaveBlockResponse._();

  factory SaveBlockResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SaveBlockResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SaveBlockResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<Block>(1, _omitFieldNames ? '' : 'block', subBuilder: Block.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveBlockResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveBlockResponse copyWith(void Function(SaveBlockResponse) updates) =>
      super.copyWith((message) => updates(message as SaveBlockResponse))
          as SaveBlockResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SaveBlockResponse create() => SaveBlockResponse._();
  @$core.override
  SaveBlockResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SaveBlockResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SaveBlockResponse>(create);
  static SaveBlockResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Block get block => $_getN(0);
  @$pb.TagNumber(1)
  set block(Block value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBlock() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlock() => $_clearField(1);
  @$pb.TagNumber(1)
  Block ensureBlock() => $_ensure(0);
}

class RequestSurgeryRequest extends $pb.GeneratedMessage {
  factory RequestSurgeryRequest({
    $core.String? encounterId,
    $core.String? patientId,
    $core.String? facilityId,
    $core.String? procedureCode,
    $core.String? procedureDisplay,
    $core.String? diagnosisCode,
    $core.String? diagnosisDisplay,
    Laterality? laterality,
    $core.String? site,
    Urgency? urgency,
    $fixnum.Int64? expectedDurationSeconds,
    $core.String? surgeonId,
    $core.Iterable<$core.String>? team,
    $core.Iterable<$core.String>? requirements,
    $core.String? anaesthesiaType,
    $core.String? specialNotes,
    $core.bool? seedFromCard,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (facilityId != null) result.facilityId = facilityId;
    if (procedureCode != null) result.procedureCode = procedureCode;
    if (procedureDisplay != null) result.procedureDisplay = procedureDisplay;
    if (diagnosisCode != null) result.diagnosisCode = diagnosisCode;
    if (diagnosisDisplay != null) result.diagnosisDisplay = diagnosisDisplay;
    if (laterality != null) result.laterality = laterality;
    if (site != null) result.site = site;
    if (urgency != null) result.urgency = urgency;
    if (expectedDurationSeconds != null)
      result.expectedDurationSeconds = expectedDurationSeconds;
    if (surgeonId != null) result.surgeonId = surgeonId;
    if (team != null) result.team.addAll(team);
    if (requirements != null) result.requirements.addAll(requirements);
    if (anaesthesiaType != null) result.anaesthesiaType = anaesthesiaType;
    if (specialNotes != null) result.specialNotes = specialNotes;
    if (seedFromCard != null) result.seedFromCard = seedFromCard;
    return result;
  }

  RequestSurgeryRequest._();

  factory RequestSurgeryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSurgeryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSurgeryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'procedureCode')
    ..aOS(5, _omitFieldNames ? '' : 'procedureDisplay')
    ..aOS(6, _omitFieldNames ? '' : 'diagnosisCode')
    ..aOS(7, _omitFieldNames ? '' : 'diagnosisDisplay')
    ..aE<Laterality>(8, _omitFieldNames ? '' : 'laterality',
        enumValues: Laterality.values)
    ..aOS(9, _omitFieldNames ? '' : 'site')
    ..aE<Urgency>(10, _omitFieldNames ? '' : 'urgency',
        enumValues: Urgency.values)
    ..aInt64(11, _omitFieldNames ? '' : 'expectedDurationSeconds')
    ..aOS(12, _omitFieldNames ? '' : 'surgeonId')
    ..pPS(13, _omitFieldNames ? '' : 'team')
    ..pPS(14, _omitFieldNames ? '' : 'requirements')
    ..aOS(15, _omitFieldNames ? '' : 'anaesthesiaType')
    ..aOS(16, _omitFieldNames ? '' : 'specialNotes')
    ..aOB(17, _omitFieldNames ? '' : 'seedFromCard')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSurgeryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSurgeryRequest copyWith(
          void Function(RequestSurgeryRequest) updates) =>
      super.copyWith((message) => updates(message as RequestSurgeryRequest))
          as RequestSurgeryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSurgeryRequest create() => RequestSurgeryRequest._();
  @$core.override
  RequestSurgeryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSurgeryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSurgeryRequest>(create);
  static RequestSurgeryRequest? _defaultInstance;

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
  $core.String get procedureCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set procedureCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProcedureCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearProcedureCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get procedureDisplay => $_getSZ(4);
  @$pb.TagNumber(5)
  set procedureDisplay($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProcedureDisplay() => $_has(4);
  @$pb.TagNumber(5)
  void clearProcedureDisplay() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get diagnosisCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set diagnosisCode($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDiagnosisCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearDiagnosisCode() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get diagnosisDisplay => $_getSZ(6);
  @$pb.TagNumber(7)
  set diagnosisDisplay($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDiagnosisDisplay() => $_has(6);
  @$pb.TagNumber(7)
  void clearDiagnosisDisplay() => $_clearField(7);

  @$pb.TagNumber(8)
  Laterality get laterality => $_getN(7);
  @$pb.TagNumber(8)
  set laterality(Laterality value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasLaterality() => $_has(7);
  @$pb.TagNumber(8)
  void clearLaterality() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get site => $_getSZ(8);
  @$pb.TagNumber(9)
  set site($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSite() => $_has(8);
  @$pb.TagNumber(9)
  void clearSite() => $_clearField(9);

  @$pb.TagNumber(10)
  Urgency get urgency => $_getN(9);
  @$pb.TagNumber(10)
  set urgency(Urgency value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasUrgency() => $_has(9);
  @$pb.TagNumber(10)
  void clearUrgency() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get expectedDurationSeconds => $_getI64(10);
  @$pb.TagNumber(11)
  set expectedDurationSeconds($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasExpectedDurationSeconds() => $_has(10);
  @$pb.TagNumber(11)
  void clearExpectedDurationSeconds() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get surgeonId => $_getSZ(11);
  @$pb.TagNumber(12)
  set surgeonId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSurgeonId() => $_has(11);
  @$pb.TagNumber(12)
  void clearSurgeonId() => $_clearField(12);

  @$pb.TagNumber(13)
  $pb.PbList<$core.String> get team => $_getList(12);

  @$pb.TagNumber(14)
  $pb.PbList<$core.String> get requirements => $_getList(13);

  @$pb.TagNumber(15)
  $core.String get anaesthesiaType => $_getSZ(14);
  @$pb.TagNumber(15)
  set anaesthesiaType($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasAnaesthesiaType() => $_has(14);
  @$pb.TagNumber(15)
  void clearAnaesthesiaType() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get specialNotes => $_getSZ(15);
  @$pb.TagNumber(16)
  set specialNotes($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasSpecialNotes() => $_has(15);
  @$pb.TagNumber(16)
  void clearSpecialNotes() => $_clearField(16);

  /// Applies the surgeon's preference card where one exists (SRS-OT-016).
  @$pb.TagNumber(17)
  $core.bool get seedFromCard => $_getBF(16);
  @$pb.TagNumber(17)
  set seedFromCard($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasSeedFromCard() => $_has(16);
  @$pb.TagNumber(17)
  void clearSeedFromCard() => $_clearField(17);
}

class RequestSurgeryResponse extends $pb.GeneratedMessage {
  factory RequestSurgeryResponse({
    SurgicalCase? surgicalCase,
    $core.Iterable<$core.String>? outstanding,
  }) {
    final result = create();
    if (surgicalCase != null) result.surgicalCase = surgicalCase;
    if (outstanding != null) result.outstanding.addAll(outstanding);
    return result;
  }

  RequestSurgeryResponse._();

  factory RequestSurgeryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSurgeryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSurgeryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<SurgicalCase>(1, _omitFieldNames ? '' : 'surgicalCase',
        subBuilder: SurgicalCase.create)
    ..pPS(2, _omitFieldNames ? '' : 'outstanding')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSurgeryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSurgeryResponse copyWith(
          void Function(RequestSurgeryResponse) updates) =>
      super.copyWith((message) => updates(message as RequestSurgeryResponse))
          as RequestSurgeryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSurgeryResponse create() => RequestSurgeryResponse._();
  @$core.override
  RequestSurgeryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSurgeryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSurgeryResponse>(create);
  static RequestSurgeryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SurgicalCase get surgicalCase => $_getN(0);
  @$pb.TagNumber(1)
  set surgicalCase(SurgicalCase value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSurgicalCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurgicalCase() => $_clearField(1);
  @$pb.TagNumber(1)
  SurgicalCase ensureSurgicalCase() => $_ensure(0);

  /// What keeps the request out of the schedulable state. Returned rather than
  /// refused: a surgeon who cannot put a patient on a list at all is a surgeon
  /// keeping a paper list.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get outstanding => $_getList(1);
}

class CompleteRequestRequest extends $pb.GeneratedMessage {
  factory CompleteRequestRequest({
    $core.String? caseId,
    $core.String? diagnosisCode,
    $core.String? diagnosisDisplay,
    Laterality? laterality,
    $core.String? site,
    $fixnum.Int64? expectedDurationSeconds,
    $core.String? surgeonId,
    $core.Iterable<$core.String>? team,
    $core.Iterable<$core.String>? requirements,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (diagnosisCode != null) result.diagnosisCode = diagnosisCode;
    if (diagnosisDisplay != null) result.diagnosisDisplay = diagnosisDisplay;
    if (laterality != null) result.laterality = laterality;
    if (site != null) result.site = site;
    if (expectedDurationSeconds != null)
      result.expectedDurationSeconds = expectedDurationSeconds;
    if (surgeonId != null) result.surgeonId = surgeonId;
    if (team != null) result.team.addAll(team);
    if (requirements != null) result.requirements.addAll(requirements);
    return result;
  }

  CompleteRequestRequest._();

  factory CompleteRequestRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteRequestRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteRequestRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'diagnosisCode')
    ..aOS(3, _omitFieldNames ? '' : 'diagnosisDisplay')
    ..aE<Laterality>(4, _omitFieldNames ? '' : 'laterality',
        enumValues: Laterality.values)
    ..aOS(5, _omitFieldNames ? '' : 'site')
    ..aInt64(6, _omitFieldNames ? '' : 'expectedDurationSeconds')
    ..aOS(7, _omitFieldNames ? '' : 'surgeonId')
    ..pPS(8, _omitFieldNames ? '' : 'team')
    ..pPS(9, _omitFieldNames ? '' : 'requirements')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteRequestRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteRequestRequest copyWith(
          void Function(CompleteRequestRequest) updates) =>
      super.copyWith((message) => updates(message as CompleteRequestRequest))
          as CompleteRequestRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteRequestRequest create() => CompleteRequestRequest._();
  @$core.override
  CompleteRequestRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteRequestRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteRequestRequest>(create);
  static CompleteRequestRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get diagnosisCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set diagnosisCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDiagnosisCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearDiagnosisCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get diagnosisDisplay => $_getSZ(2);
  @$pb.TagNumber(3)
  set diagnosisDisplay($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDiagnosisDisplay() => $_has(2);
  @$pb.TagNumber(3)
  void clearDiagnosisDisplay() => $_clearField(3);

  @$pb.TagNumber(4)
  Laterality get laterality => $_getN(3);
  @$pb.TagNumber(4)
  set laterality(Laterality value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLaterality() => $_has(3);
  @$pb.TagNumber(4)
  void clearLaterality() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get site => $_getSZ(4);
  @$pb.TagNumber(5)
  set site($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSite() => $_has(4);
  @$pb.TagNumber(5)
  void clearSite() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get expectedDurationSeconds => $_getI64(5);
  @$pb.TagNumber(6)
  set expectedDurationSeconds($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpectedDurationSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpectedDurationSeconds() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get surgeonId => $_getSZ(6);
  @$pb.TagNumber(7)
  set surgeonId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSurgeonId() => $_has(6);
  @$pb.TagNumber(7)
  void clearSurgeonId() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get team => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get requirements => $_getList(8);
}

class CompleteRequestResponse extends $pb.GeneratedMessage {
  factory CompleteRequestResponse({
    SurgicalCase? surgicalCase,
    $core.Iterable<$core.String>? outstanding,
  }) {
    final result = create();
    if (surgicalCase != null) result.surgicalCase = surgicalCase;
    if (outstanding != null) result.outstanding.addAll(outstanding);
    return result;
  }

  CompleteRequestResponse._();

  factory CompleteRequestResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteRequestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteRequestResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<SurgicalCase>(1, _omitFieldNames ? '' : 'surgicalCase',
        subBuilder: SurgicalCase.create)
    ..pPS(2, _omitFieldNames ? '' : 'outstanding')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteRequestResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteRequestResponse copyWith(
          void Function(CompleteRequestResponse) updates) =>
      super.copyWith((message) => updates(message as CompleteRequestResponse))
          as CompleteRequestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteRequestResponse create() => CompleteRequestResponse._();
  @$core.override
  CompleteRequestResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteRequestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteRequestResponse>(create);
  static CompleteRequestResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SurgicalCase get surgicalCase => $_getN(0);
  @$pb.TagNumber(1)
  set surgicalCase(SurgicalCase value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSurgicalCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurgicalCase() => $_clearField(1);
  @$pb.TagNumber(1)
  SurgicalCase ensureSurgicalCase() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get outstanding => $_getList(1);
}

class GetSurgicalCaseRequest extends $pb.GeneratedMessage {
  factory GetSurgicalCaseRequest({
    $core.String? caseId,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    return result;
  }

  GetSurgicalCaseRequest._();

  factory GetSurgicalCaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSurgicalCaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSurgicalCaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSurgicalCaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSurgicalCaseRequest copyWith(
          void Function(GetSurgicalCaseRequest) updates) =>
      super.copyWith((message) => updates(message as GetSurgicalCaseRequest))
          as GetSurgicalCaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSurgicalCaseRequest create() => GetSurgicalCaseRequest._();
  @$core.override
  GetSurgicalCaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSurgicalCaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSurgicalCaseRequest>(create);
  static GetSurgicalCaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
}

class GetSurgicalCaseResponse extends $pb.GeneratedMessage {
  factory GetSurgicalCaseResponse({
    SurgicalCase? surgicalCase,
    $core.Iterable<PreopEntry>? preop,
    $core.Iterable<Blocker>? blockers,
    $core.Iterable<SafetyCheck>? safetyChecks,
    $core.Iterable<MilestoneRecord>? milestones,
    CaseIntervals? intervals,
    $core.Iterable<Delay>? delays,
    $core.Iterable<OperativeNote>? notes,
    $core.Iterable<Usage>? usage,
    $core.Iterable<Specimen>? specimens,
    $core.Iterable<TrayUse>? trays,
  }) {
    final result = create();
    if (surgicalCase != null) result.surgicalCase = surgicalCase;
    if (preop != null) result.preop.addAll(preop);
    if (blockers != null) result.blockers.addAll(blockers);
    if (safetyChecks != null) result.safetyChecks.addAll(safetyChecks);
    if (milestones != null) result.milestones.addAll(milestones);
    if (intervals != null) result.intervals = intervals;
    if (delays != null) result.delays.addAll(delays);
    if (notes != null) result.notes.addAll(notes);
    if (usage != null) result.usage.addAll(usage);
    if (specimens != null) result.specimens.addAll(specimens);
    if (trays != null) result.trays.addAll(trays);
    return result;
  }

  GetSurgicalCaseResponse._();

  factory GetSurgicalCaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSurgicalCaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSurgicalCaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<SurgicalCase>(1, _omitFieldNames ? '' : 'surgicalCase',
        subBuilder: SurgicalCase.create)
    ..pPM<PreopEntry>(2, _omitFieldNames ? '' : 'preop',
        subBuilder: PreopEntry.create)
    ..pPM<Blocker>(3, _omitFieldNames ? '' : 'blockers',
        subBuilder: Blocker.create)
    ..pPM<SafetyCheck>(4, _omitFieldNames ? '' : 'safetyChecks',
        subBuilder: SafetyCheck.create)
    ..pPM<MilestoneRecord>(5, _omitFieldNames ? '' : 'milestones',
        subBuilder: MilestoneRecord.create)
    ..aOM<CaseIntervals>(6, _omitFieldNames ? '' : 'intervals',
        subBuilder: CaseIntervals.create)
    ..pPM<Delay>(7, _omitFieldNames ? '' : 'delays', subBuilder: Delay.create)
    ..pPM<OperativeNote>(8, _omitFieldNames ? '' : 'notes',
        subBuilder: OperativeNote.create)
    ..pPM<Usage>(9, _omitFieldNames ? '' : 'usage', subBuilder: Usage.create)
    ..pPM<Specimen>(10, _omitFieldNames ? '' : 'specimens',
        subBuilder: Specimen.create)
    ..pPM<TrayUse>(11, _omitFieldNames ? '' : 'trays',
        subBuilder: TrayUse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSurgicalCaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSurgicalCaseResponse copyWith(
          void Function(GetSurgicalCaseResponse) updates) =>
      super.copyWith((message) => updates(message as GetSurgicalCaseResponse))
          as GetSurgicalCaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSurgicalCaseResponse create() => GetSurgicalCaseResponse._();
  @$core.override
  GetSurgicalCaseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSurgicalCaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSurgicalCaseResponse>(create);
  static GetSurgicalCaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SurgicalCase get surgicalCase => $_getN(0);
  @$pb.TagNumber(1)
  set surgicalCase(SurgicalCase value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSurgicalCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurgicalCase() => $_clearField(1);
  @$pb.TagNumber(1)
  SurgicalCase ensureSurgicalCase() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<PreopEntry> get preop => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<Blocker> get blockers => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<SafetyCheck> get safetyChecks => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<MilestoneRecord> get milestones => $_getList(4);

  @$pb.TagNumber(6)
  CaseIntervals get intervals => $_getN(5);
  @$pb.TagNumber(6)
  set intervals(CaseIntervals value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasIntervals() => $_has(5);
  @$pb.TagNumber(6)
  void clearIntervals() => $_clearField(6);
  @$pb.TagNumber(6)
  CaseIntervals ensureIntervals() => $_ensure(5);

  @$pb.TagNumber(7)
  $pb.PbList<Delay> get delays => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<OperativeNote> get notes => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<Usage> get usage => $_getList(8);

  @$pb.TagNumber(10)
  $pb.PbList<Specimen> get specimens => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<TrayUse> get trays => $_getList(10);
}

class ReprioritiseRequest extends $pb.GeneratedMessage {
  factory ReprioritiseRequest({
    $core.String? caseId,
    Urgency? urgency,
    $core.String? reason,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (urgency != null) result.urgency = urgency;
    if (reason != null) result.reason = reason;
    return result;
  }

  ReprioritiseRequest._();

  factory ReprioritiseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReprioritiseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReprioritiseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aE<Urgency>(2, _omitFieldNames ? '' : 'urgency',
        enumValues: Urgency.values)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReprioritiseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReprioritiseRequest copyWith(void Function(ReprioritiseRequest) updates) =>
      super.copyWith((message) => updates(message as ReprioritiseRequest))
          as ReprioritiseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReprioritiseRequest create() => ReprioritiseRequest._();
  @$core.override
  ReprioritiseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReprioritiseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReprioritiseRequest>(create);
  static ReprioritiseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  Urgency get urgency => $_getN(1);
  @$pb.TagNumber(2)
  set urgency(Urgency value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUrgency() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrgency() => $_clearField(2);

  /// Required in both directions. Moving a case up is the decision somebody
  /// asks about afterwards; moving one down is the decision the patient asks
  /// about.
  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class ReprioritiseResponse extends $pb.GeneratedMessage {
  factory ReprioritiseResponse({
    SurgicalCase? surgicalCase,
  }) {
    final result = create();
    if (surgicalCase != null) result.surgicalCase = surgicalCase;
    return result;
  }

  ReprioritiseResponse._();

  factory ReprioritiseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReprioritiseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReprioritiseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<SurgicalCase>(1, _omitFieldNames ? '' : 'surgicalCase',
        subBuilder: SurgicalCase.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReprioritiseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReprioritiseResponse copyWith(void Function(ReprioritiseResponse) updates) =>
      super.copyWith((message) => updates(message as ReprioritiseResponse))
          as ReprioritiseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReprioritiseResponse create() => ReprioritiseResponse._();
  @$core.override
  ReprioritiseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReprioritiseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReprioritiseResponse>(create);
  static ReprioritiseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SurgicalCase get surgicalCase => $_getN(0);
  @$pb.TagNumber(1)
  set surgicalCase(SurgicalCase value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSurgicalCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurgicalCase() => $_clearField(1);
  @$pb.TagNumber(1)
  SurgicalCase ensureSurgicalCase() => $_ensure(0);
}

class CheckSlotRequest extends $pb.GeneratedMessage {
  factory CheckSlotRequest({
    $core.String? caseId,
    $core.String? roomId,
    $0.Timestamp? start,
    $0.Timestamp? end,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (roomId != null) result.roomId = roomId;
    if (start != null) result.start = start;
    if (end != null) result.end = end;
    return result;
  }

  CheckSlotRequest._();

  factory CheckSlotRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckSlotRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckSlotRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'roomId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'start',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'end',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckSlotRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckSlotRequest copyWith(void Function(CheckSlotRequest) updates) =>
      super.copyWith((message) => updates(message as CheckSlotRequest))
          as CheckSlotRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckSlotRequest create() => CheckSlotRequest._();
  @$core.override
  CheckSlotRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckSlotRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckSlotRequest>(create);
  static CheckSlotRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get roomId => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoomId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get start => $_getN(2);
  @$pb.TagNumber(3)
  set start($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStart() => $_has(2);
  @$pb.TagNumber(3)
  void clearStart() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureStart() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get end => $_getN(3);
  @$pb.TagNumber(4)
  set end($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEnd() => $_has(3);
  @$pb.TagNumber(4)
  void clearEnd() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureEnd() => $_ensure(3);
}

class CheckSlotResponse extends $pb.GeneratedMessage {
  factory CheckSlotResponse({
    $core.Iterable<ScheduleConflict>? conflicts,
  }) {
    final result = create();
    if (conflicts != null) result.conflicts.addAll(conflicts);
    return result;
  }

  CheckSlotResponse._();

  factory CheckSlotResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckSlotResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckSlotResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..pPM<ScheduleConflict>(1, _omitFieldNames ? '' : 'conflicts',
        subBuilder: ScheduleConflict.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckSlotResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckSlotResponse copyWith(void Function(CheckSlotResponse) updates) =>
      super.copyWith((message) => updates(message as CheckSlotResponse))
          as CheckSlotResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckSlotResponse create() => CheckSlotResponse._();
  @$core.override
  CheckSlotResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckSlotResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckSlotResponse>(create);
  static CheckSlotResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ScheduleConflict> get conflicts => $_getList(0);
}

class ScheduleCaseRequest extends $pb.GeneratedMessage {
  factory ScheduleCaseRequest({
    $core.String? caseId,
    $core.String? roomId,
    $0.Timestamp? start,
    $0.Timestamp? end,
    $core.bool? override,
    $core.String? overrideReason,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (roomId != null) result.roomId = roomId;
    if (start != null) result.start = start;
    if (end != null) result.end = end;
    if (override != null) result.override = override;
    if (overrideReason != null) result.overrideReason = overrideReason;
    return result;
  }

  ScheduleCaseRequest._();

  factory ScheduleCaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScheduleCaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleCaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'roomId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'start',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'end',
        subBuilder: $0.Timestamp.create)
    ..aOB(5, _omitFieldNames ? '' : 'override')
    ..aOS(6, _omitFieldNames ? '' : 'overrideReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleCaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleCaseRequest copyWith(void Function(ScheduleCaseRequest) updates) =>
      super.copyWith((message) => updates(message as ScheduleCaseRequest))
          as ScheduleCaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduleCaseRequest create() => ScheduleCaseRequest._();
  @$core.override
  ScheduleCaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScheduleCaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScheduleCaseRequest>(create);
  static ScheduleCaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get roomId => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoomId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get start => $_getN(2);
  @$pb.TagNumber(3)
  set start($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStart() => $_has(2);
  @$pb.TagNumber(3)
  void clearStart() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureStart() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get end => $_getN(3);
  @$pb.TagNumber(4)
  set end($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEnd() => $_has(3);
  @$pb.TagNumber(4)
  void clearEnd() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureEnd() => $_ensure(3);

  /// Books despite a soft conflict. Needs its own permission, and a reason: a
  /// list that overran is traced back to this decision.
  @$pb.TagNumber(5)
  $core.bool get override => $_getBF(4);
  @$pb.TagNumber(5)
  set override($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOverride() => $_has(4);
  @$pb.TagNumber(5)
  void clearOverride() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get overrideReason => $_getSZ(5);
  @$pb.TagNumber(6)
  set overrideReason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOverrideReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearOverrideReason() => $_clearField(6);
}

class ScheduleCaseResponse extends $pb.GeneratedMessage {
  factory ScheduleCaseResponse({
    SurgicalCase? surgicalCase,
    $core.Iterable<ScheduleConflict>? conflicts,
    $core.bool? booked,
  }) {
    final result = create();
    if (surgicalCase != null) result.surgicalCase = surgicalCase;
    if (conflicts != null) result.conflicts.addAll(conflicts);
    if (booked != null) result.booked = booked;
    return result;
  }

  ScheduleCaseResponse._();

  factory ScheduleCaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScheduleCaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleCaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<SurgicalCase>(1, _omitFieldNames ? '' : 'surgicalCase',
        subBuilder: SurgicalCase.create)
    ..pPM<ScheduleConflict>(2, _omitFieldNames ? '' : 'conflicts',
        subBuilder: ScheduleConflict.create)
    ..aOB(3, _omitFieldNames ? '' : 'booked')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleCaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleCaseResponse copyWith(void Function(ScheduleCaseResponse) updates) =>
      super.copyWith((message) => updates(message as ScheduleCaseResponse))
          as ScheduleCaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduleCaseResponse create() => ScheduleCaseResponse._();
  @$core.override
  ScheduleCaseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScheduleCaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScheduleCaseResponse>(create);
  static ScheduleCaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SurgicalCase get surgicalCase => $_getN(0);
  @$pb.TagNumber(1)
  set surgicalCase(SurgicalCase value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSurgicalCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurgicalCase() => $_clearField(1);
  @$pb.TagNumber(1)
  SurgicalCase ensureSurgicalCase() => $_ensure(0);

  /// Returned whether or not the booking went ahead, so a scheduler who
  /// overrode a conflict still sees what they overrode.
  @$pb.TagNumber(2)
  $pb.PbList<ScheduleConflict> get conflicts => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get booked => $_getBF(2);
  @$pb.TagNumber(3)
  set booked($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBooked() => $_has(2);
  @$pb.TagNumber(3)
  void clearBooked() => $_clearField(3);
}

class CloseCaseRequest extends $pb.GeneratedMessage {
  factory CloseCaseRequest({
    $core.String? caseId,
    $core.bool? postpone,
    CaseCause? cause,
    $core.String? reason,
    $core.String? note,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (postpone != null) result.postpone = postpone;
    if (cause != null) result.cause = cause;
    if (reason != null) result.reason = reason;
    if (note != null) result.note = note;
    return result;
  }

  CloseCaseRequest._();

  factory CloseCaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseCaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseCaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOB(2, _omitFieldNames ? '' : 'postpone')
    ..aE<CaseCause>(3, _omitFieldNames ? '' : 'cause',
        enumValues: CaseCause.values)
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aOS(5, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseCaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseCaseRequest copyWith(void Function(CloseCaseRequest) updates) =>
      super.copyWith((message) => updates(message as CloseCaseRequest))
          as CloseCaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseCaseRequest create() => CloseCaseRequest._();
  @$core.override
  CloseCaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseCaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseCaseRequest>(create);
  static CloseCaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  /// Postpone rebooks later; otherwise the case is cancelled outright.
  @$pb.TagNumber(2)
  $core.bool get postpone => $_getBF(1);
  @$pb.TagNumber(2)
  set postpone($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPostpone() => $_has(1);
  @$pb.TagNumber(2)
  void clearPostpone() => $_clearField(2);

  @$pb.TagNumber(3)
  CaseCause get cause => $_getN(2);
  @$pb.TagNumber(3)
  set cause(CaseCause value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCause() => $_has(2);
  @$pb.TagNumber(3)
  void clearCause() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get note => $_getSZ(4);
  @$pb.TagNumber(5)
  set note($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNote() => $_has(4);
  @$pb.TagNumber(5)
  void clearNote() => $_clearField(5);
}

class CloseCaseResponse extends $pb.GeneratedMessage {
  factory CloseCaseResponse({
    SurgicalCase? surgicalCase,
  }) {
    final result = create();
    if (surgicalCase != null) result.surgicalCase = surgicalCase;
    return result;
  }

  CloseCaseResponse._();

  factory CloseCaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseCaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseCaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<SurgicalCase>(1, _omitFieldNames ? '' : 'surgicalCase',
        subBuilder: SurgicalCase.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseCaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseCaseResponse copyWith(void Function(CloseCaseResponse) updates) =>
      super.copyWith((message) => updates(message as CloseCaseResponse))
          as CloseCaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseCaseResponse create() => CloseCaseResponse._();
  @$core.override
  CloseCaseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseCaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseCaseResponse>(create);
  static CloseCaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SurgicalCase get surgicalCase => $_getN(0);
  @$pb.TagNumber(1)
  set surgicalCase(SurgicalCase value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSurgicalCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurgicalCase() => $_clearField(1);
  @$pb.TagNumber(1)
  SurgicalCase ensureSurgicalCase() => $_ensure(0);
}

class ListWaitingRequest extends $pb.GeneratedMessage {
  factory ListWaitingRequest({
    $core.String? facilityId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListWaitingRequest._();

  factory ListWaitingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWaitingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWaitingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWaitingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWaitingRequest copyWith(void Function(ListWaitingRequest) updates) =>
      super.copyWith((message) => updates(message as ListWaitingRequest))
          as ListWaitingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWaitingRequest create() => ListWaitingRequest._();
  @$core.override
  ListWaitingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListWaitingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWaitingRequest>(create);
  static ListWaitingRequest? _defaultInstance;

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

class ListWaitingResponse extends $pb.GeneratedMessage {
  factory ListWaitingResponse({
    $core.Iterable<SurgicalCase>? cases,
  }) {
    final result = create();
    if (cases != null) result.cases.addAll(cases);
    return result;
  }

  ListWaitingResponse._();

  factory ListWaitingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWaitingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWaitingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..pPM<SurgicalCase>(1, _omitFieldNames ? '' : 'cases',
        subBuilder: SurgicalCase.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWaitingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWaitingResponse copyWith(void Function(ListWaitingResponse) updates) =>
      super.copyWith((message) => updates(message as ListWaitingResponse))
          as ListWaitingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWaitingResponse create() => ListWaitingResponse._();
  @$core.override
  ListWaitingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListWaitingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWaitingResponse>(create);
  static ListWaitingResponse? _defaultInstance;

  /// Urgency first, then how long they have waited.
  @$pb.TagNumber(1)
  $pb.PbList<SurgicalCase> get cases => $_getList(0);
}

class RecordPreopRequest extends $pb.GeneratedMessage {
  factory RecordPreopRequest({
    $core.String? caseId,
    $core.String? code,
    PreopState? state,
    $core.String? note,
    $core.String? waivedRole,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (code != null) result.code = code;
    if (state != null) result.state = state;
    if (note != null) result.note = note;
    if (waivedRole != null) result.waivedRole = waivedRole;
    return result;
  }

  RecordPreopRequest._();

  factory RecordPreopRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordPreopRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordPreopRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aE<PreopState>(3, _omitFieldNames ? '' : 'state',
        enumValues: PreopState.values)
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..aOS(5, _omitFieldNames ? '' : 'waivedRole')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordPreopRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordPreopRequest copyWith(void Function(RecordPreopRequest) updates) =>
      super.copyWith((message) => updates(message as RecordPreopRequest))
          as RecordPreopRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordPreopRequest create() => RecordPreopRequest._();
  @$core.override
  RecordPreopRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordPreopRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordPreopRequest>(create);
  static RecordPreopRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  PreopState get state => $_getN(2);
  @$pb.TagNumber(3)
  set state(PreopState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);

  /// The role claimed for a waiver.
  @$pb.TagNumber(5)
  $core.String get waivedRole => $_getSZ(4);
  @$pb.TagNumber(5)
  set waivedRole($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWaivedRole() => $_has(4);
  @$pb.TagNumber(5)
  void clearWaivedRole() => $_clearField(5);
}

class RecordPreopResponse extends $pb.GeneratedMessage {
  factory RecordPreopResponse({
    $core.Iterable<Blocker>? blockers,
  }) {
    final result = create();
    if (blockers != null) result.blockers.addAll(blockers);
    return result;
  }

  RecordPreopResponse._();

  factory RecordPreopResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordPreopResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordPreopResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..pPM<Blocker>(1, _omitFieldNames ? '' : 'blockers',
        subBuilder: Blocker.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordPreopResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordPreopResponse copyWith(void Function(RecordPreopResponse) updates) =>
      super.copyWith((message) => updates(message as RecordPreopResponse))
          as RecordPreopResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordPreopResponse create() => RecordPreopResponse._();
  @$core.override
  RecordPreopResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordPreopResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordPreopResponse>(create);
  static RecordPreopResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Blocker> get blockers => $_getList(0);
}

class ListBlockersRequest extends $pb.GeneratedMessage {
  factory ListBlockersRequest({
    $core.String? caseId,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    return result;
  }

  ListBlockersRequest._();

  factory ListBlockersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBlockersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBlockersRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBlockersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBlockersRequest copyWith(void Function(ListBlockersRequest) updates) =>
      super.copyWith((message) => updates(message as ListBlockersRequest))
          as ListBlockersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBlockersRequest create() => ListBlockersRequest._();
  @$core.override
  ListBlockersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBlockersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBlockersRequest>(create);
  static ListBlockersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
}

class ListBlockersResponse extends $pb.GeneratedMessage {
  factory ListBlockersResponse({
    $core.Iterable<Blocker>? blockers,
  }) {
    final result = create();
    if (blockers != null) result.blockers.addAll(blockers);
    return result;
  }

  ListBlockersResponse._();

  factory ListBlockersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBlockersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBlockersResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..pPM<Blocker>(1, _omitFieldNames ? '' : 'blockers',
        subBuilder: Blocker.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBlockersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBlockersResponse copyWith(void Function(ListBlockersResponse) updates) =>
      super.copyWith((message) => updates(message as ListBlockersResponse))
          as ListBlockersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBlockersResponse create() => ListBlockersResponse._();
  @$core.override
  ListBlockersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBlockersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBlockersResponse>(create);
  static ListBlockersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Blocker> get blockers => $_getList(0);
}

class PerformSafetyCheckRequest extends $pb.GeneratedMessage {
  factory PerformSafetyCheckRequest({
    $core.String? caseId,
    SafetyPhase? phase,
    $core.Iterable<$core.String>? participants,
    $core.Iterable<SafetyAnswer>? answers,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (phase != null) result.phase = phase;
    if (participants != null) result.participants.addAll(participants);
    if (answers != null) result.answers.addAll(answers);
    return result;
  }

  PerformSafetyCheckRequest._();

  factory PerformSafetyCheckRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PerformSafetyCheckRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PerformSafetyCheckRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aE<SafetyPhase>(2, _omitFieldNames ? '' : 'phase',
        enumValues: SafetyPhase.values)
    ..pPS(3, _omitFieldNames ? '' : 'participants')
    ..pPM<SafetyAnswer>(4, _omitFieldNames ? '' : 'answers',
        subBuilder: SafetyAnswer.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PerformSafetyCheckRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PerformSafetyCheckRequest copyWith(
          void Function(PerformSafetyCheckRequest) updates) =>
      super.copyWith((message) => updates(message as PerformSafetyCheckRequest))
          as PerformSafetyCheckRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PerformSafetyCheckRequest create() => PerformSafetyCheckRequest._();
  @$core.override
  PerformSafetyCheckRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PerformSafetyCheckRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PerformSafetyCheckRequest>(create);
  static PerformSafetyCheckRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  SafetyPhase get phase => $_getN(1);
  @$pb.TagNumber(2)
  set phase(SafetyPhase value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPhase() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhase() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get participants => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<SafetyAnswer> get answers => $_getList(3);
}

class PerformSafetyCheckResponse extends $pb.GeneratedMessage {
  factory PerformSafetyCheckResponse({
    SafetyCheck? check_1,
  }) {
    final result = create();
    if (check_1 != null) result.check_1 = check_1;
    return result;
  }

  PerformSafetyCheckResponse._();

  factory PerformSafetyCheckResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PerformSafetyCheckResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PerformSafetyCheckResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<SafetyCheck>(1, _omitFieldNames ? '' : 'check',
        subBuilder: SafetyCheck.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PerformSafetyCheckResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PerformSafetyCheckResponse copyWith(
          void Function(PerformSafetyCheckResponse) updates) =>
      super.copyWith(
              (message) => updates(message as PerformSafetyCheckResponse))
          as PerformSafetyCheckResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PerformSafetyCheckResponse create() => PerformSafetyCheckResponse._();
  @$core.override
  PerformSafetyCheckResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PerformSafetyCheckResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PerformSafetyCheckResponse>(create);
  static PerformSafetyCheckResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SafetyCheck get check_1 => $_getN(0);
  @$pb.TagNumber(1)
  set check_1(SafetyCheck value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCheck_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheck_1() => $_clearField(1);
  @$pb.TagNumber(1)
  SafetyCheck ensureCheck_1() => $_ensure(0);
}

class RecordMilestoneRequest extends $pb.GeneratedMessage {
  factory RecordMilestoneRequest({
    $core.String? caseId,
    Milestone? milestone,
    $0.Timestamp? occurredAt,
    $core.String? note,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (milestone != null) result.milestone = milestone;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (note != null) result.note = note;
    return result;
  }

  RecordMilestoneRequest._();

  factory RecordMilestoneRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordMilestoneRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordMilestoneRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aE<Milestone>(2, _omitFieldNames ? '' : 'milestone',
        enumValues: Milestone.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordMilestoneRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordMilestoneRequest copyWith(
          void Function(RecordMilestoneRequest) updates) =>
      super.copyWith((message) => updates(message as RecordMilestoneRequest))
          as RecordMilestoneRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordMilestoneRequest create() => RecordMilestoneRequest._();
  @$core.override
  RecordMilestoneRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordMilestoneRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordMilestoneRequest>(create);
  static RecordMilestoneRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  Milestone get milestone => $_getN(1);
  @$pb.TagNumber(2)
  set milestone(Milestone value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMilestone() => $_has(1);
  @$pb.TagNumber(2)
  void clearMilestone() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get occurredAt => $_getN(2);
  @$pb.TagNumber(3)
  set occurredAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOccurredAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearOccurredAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureOccurredAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);
}

class RecordMilestoneResponse extends $pb.GeneratedMessage {
  factory RecordMilestoneResponse({
    MilestoneRecord? milestone,
  }) {
    final result = create();
    if (milestone != null) result.milestone = milestone;
    return result;
  }

  RecordMilestoneResponse._();

  factory RecordMilestoneResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordMilestoneResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordMilestoneResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<MilestoneRecord>(1, _omitFieldNames ? '' : 'milestone',
        subBuilder: MilestoneRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordMilestoneResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordMilestoneResponse copyWith(
          void Function(RecordMilestoneResponse) updates) =>
      super.copyWith((message) => updates(message as RecordMilestoneResponse))
          as RecordMilestoneResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordMilestoneResponse create() => RecordMilestoneResponse._();
  @$core.override
  RecordMilestoneResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordMilestoneResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordMilestoneResponse>(create);
  static RecordMilestoneResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MilestoneRecord get milestone => $_getN(0);
  @$pb.TagNumber(1)
  set milestone(MilestoneRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMilestone() => $_has(0);
  @$pb.TagNumber(1)
  void clearMilestone() => $_clearField(1);
  @$pb.TagNumber(1)
  MilestoneRecord ensureMilestone() => $_ensure(0);
}

class GetTimelineRequest extends $pb.GeneratedMessage {
  factory GetTimelineRequest({
    $core.String? caseId,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
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
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
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
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
}

class GetTimelineResponse extends $pb.GeneratedMessage {
  factory GetTimelineResponse({
    $core.Iterable<MilestoneRecord>? milestones,
    CaseIntervals? intervals,
    $core.Iterable<$core.String>? outOfSequence,
  }) {
    final result = create();
    if (milestones != null) result.milestones.addAll(milestones);
    if (intervals != null) result.intervals = intervals;
    if (outOfSequence != null) result.outOfSequence.addAll(outOfSequence);
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
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..pPM<MilestoneRecord>(1, _omitFieldNames ? '' : 'milestones',
        subBuilder: MilestoneRecord.create)
    ..aOM<CaseIntervals>(2, _omitFieldNames ? '' : 'intervals',
        subBuilder: CaseIntervals.create)
    ..pPS(3, _omitFieldNames ? '' : 'outOfSequence')
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
  $pb.PbList<MilestoneRecord> get milestones => $_getList(0);

  @$pb.TagNumber(2)
  CaseIntervals get intervals => $_getN(1);
  @$pb.TagNumber(2)
  set intervals(CaseIntervals value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasIntervals() => $_has(1);
  @$pb.TagNumber(2)
  void clearIntervals() => $_clearField(2);
  @$pb.TagNumber(2)
  CaseIntervals ensureIntervals() => $_ensure(1);

  /// Milestones timed in an order the patient could not have moved in.
  /// Reported rather than refused: refusing leaves the real time unrecorded,
  /// and ignoring it puts a negative operating time into the reporting.
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get outOfSequence => $_getList(2);
}

class RecordDelayRequest extends $pb.GeneratedMessage {
  factory RecordDelayRequest({
    $core.String? caseId,
    DelayReason? reason,
    $core.String? dependency,
    $core.int? minutes,
    $core.String? note,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (reason != null) result.reason = reason;
    if (dependency != null) result.dependency = dependency;
    if (minutes != null) result.minutes = minutes;
    if (note != null) result.note = note;
    return result;
  }

  RecordDelayRequest._();

  factory RecordDelayRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordDelayRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordDelayRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aE<DelayReason>(2, _omitFieldNames ? '' : 'reason',
        enumValues: DelayReason.values)
    ..aOS(3, _omitFieldNames ? '' : 'dependency')
    ..aI(4, _omitFieldNames ? '' : 'minutes')
    ..aOS(5, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDelayRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDelayRequest copyWith(void Function(RecordDelayRequest) updates) =>
      super.copyWith((message) => updates(message as RecordDelayRequest))
          as RecordDelayRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordDelayRequest create() => RecordDelayRequest._();
  @$core.override
  RecordDelayRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordDelayRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordDelayRequest>(create);
  static RecordDelayRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  DelayReason get reason => $_getN(1);
  @$pb.TagNumber(2)
  set reason(DelayReason value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get dependency => $_getSZ(2);
  @$pb.TagNumber(3)
  set dependency($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDependency() => $_has(2);
  @$pb.TagNumber(3)
  void clearDependency() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get minutes => $_getIZ(3);
  @$pb.TagNumber(4)
  set minutes($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMinutes() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinutes() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get note => $_getSZ(4);
  @$pb.TagNumber(5)
  set note($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNote() => $_has(4);
  @$pb.TagNumber(5)
  void clearNote() => $_clearField(5);
}

class RecordDelayResponse extends $pb.GeneratedMessage {
  factory RecordDelayResponse({
    Delay? delay,
  }) {
    final result = create();
    if (delay != null) result.delay = delay;
    return result;
  }

  RecordDelayResponse._();

  factory RecordDelayResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordDelayResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordDelayResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<Delay>(1, _omitFieldNames ? '' : 'delay', subBuilder: Delay.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDelayResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDelayResponse copyWith(void Function(RecordDelayResponse) updates) =>
      super.copyWith((message) => updates(message as RecordDelayResponse))
          as RecordDelayResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordDelayResponse create() => RecordDelayResponse._();
  @$core.override
  RecordDelayResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordDelayResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordDelayResponse>(create);
  static RecordDelayResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Delay get delay => $_getN(0);
  @$pb.TagNumber(1)
  set delay(Delay value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDelay() => $_has(0);
  @$pb.TagNumber(1)
  void clearDelay() => $_clearField(1);
  @$pb.TagNumber(1)
  Delay ensureDelay() => $_ensure(0);
}

class WriteOperativeNoteRequest extends $pb.GeneratedMessage {
  factory WriteOperativeNoteRequest({
    $core.String? caseId,
    $core.String? procedurePerformed,
    $core.String? findings,
    $core.Iterable<$core.String>? specimenIds,
    $core.Iterable<$core.String>? implantIds,
    $core.Iterable<$core.String>? complications,
    $core.int? estimatedBloodLossMl,
    $core.String? postOperativeOrders,
    $core.String? narrative,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (procedurePerformed != null)
      result.procedurePerformed = procedurePerformed;
    if (findings != null) result.findings = findings;
    if (specimenIds != null) result.specimenIds.addAll(specimenIds);
    if (implantIds != null) result.implantIds.addAll(implantIds);
    if (complications != null) result.complications.addAll(complications);
    if (estimatedBloodLossMl != null)
      result.estimatedBloodLossMl = estimatedBloodLossMl;
    if (postOperativeOrders != null)
      result.postOperativeOrders = postOperativeOrders;
    if (narrative != null) result.narrative = narrative;
    return result;
  }

  WriteOperativeNoteRequest._();

  factory WriteOperativeNoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WriteOperativeNoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WriteOperativeNoteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'procedurePerformed')
    ..aOS(3, _omitFieldNames ? '' : 'findings')
    ..pPS(4, _omitFieldNames ? '' : 'specimenIds')
    ..pPS(5, _omitFieldNames ? '' : 'implantIds')
    ..pPS(6, _omitFieldNames ? '' : 'complications')
    ..aI(7, _omitFieldNames ? '' : 'estimatedBloodLossMl')
    ..aOS(8, _omitFieldNames ? '' : 'postOperativeOrders')
    ..aOS(9, _omitFieldNames ? '' : 'narrative')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteOperativeNoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteOperativeNoteRequest copyWith(
          void Function(WriteOperativeNoteRequest) updates) =>
      super.copyWith((message) => updates(message as WriteOperativeNoteRequest))
          as WriteOperativeNoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WriteOperativeNoteRequest create() => WriteOperativeNoteRequest._();
  @$core.override
  WriteOperativeNoteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WriteOperativeNoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteOperativeNoteRequest>(create);
  static WriteOperativeNoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get procedurePerformed => $_getSZ(1);
  @$pb.TagNumber(2)
  set procedurePerformed($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProcedurePerformed() => $_has(1);
  @$pb.TagNumber(2)
  void clearProcedurePerformed() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get findings => $_getSZ(2);
  @$pb.TagNumber(3)
  set findings($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFindings() => $_has(2);
  @$pb.TagNumber(3)
  void clearFindings() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get specimenIds => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get implantIds => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get complications => $_getList(5);

  @$pb.TagNumber(7)
  $core.int get estimatedBloodLossMl => $_getIZ(6);
  @$pb.TagNumber(7)
  set estimatedBloodLossMl($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEstimatedBloodLossMl() => $_has(6);
  @$pb.TagNumber(7)
  void clearEstimatedBloodLossMl() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get postOperativeOrders => $_getSZ(7);
  @$pb.TagNumber(8)
  set postOperativeOrders($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPostOperativeOrders() => $_has(7);
  @$pb.TagNumber(8)
  void clearPostOperativeOrders() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get narrative => $_getSZ(8);
  @$pb.TagNumber(9)
  set narrative($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasNarrative() => $_has(8);
  @$pb.TagNumber(9)
  void clearNarrative() => $_clearField(9);
}

class WriteOperativeNoteResponse extends $pb.GeneratedMessage {
  factory WriteOperativeNoteResponse({
    OperativeNote? note,
  }) {
    final result = create();
    if (note != null) result.note = note;
    return result;
  }

  WriteOperativeNoteResponse._();

  factory WriteOperativeNoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WriteOperativeNoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WriteOperativeNoteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<OperativeNote>(1, _omitFieldNames ? '' : 'note',
        subBuilder: OperativeNote.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteOperativeNoteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteOperativeNoteResponse copyWith(
          void Function(WriteOperativeNoteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WriteOperativeNoteResponse))
          as WriteOperativeNoteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WriteOperativeNoteResponse create() => WriteOperativeNoteResponse._();
  @$core.override
  WriteOperativeNoteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WriteOperativeNoteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteOperativeNoteResponse>(create);
  static WriteOperativeNoteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  OperativeNote get note => $_getN(0);
  @$pb.TagNumber(1)
  set note(OperativeNote value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNote() => $_has(0);
  @$pb.TagNumber(1)
  void clearNote() => $_clearField(1);
  @$pb.TagNumber(1)
  OperativeNote ensureNote() => $_ensure(0);
}

class SignOperativeNoteRequest extends $pb.GeneratedMessage {
  factory SignOperativeNoteRequest({
    $core.String? caseId,
    $core.String? noteId,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (noteId != null) result.noteId = noteId;
    return result;
  }

  SignOperativeNoteRequest._();

  factory SignOperativeNoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignOperativeNoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignOperativeNoteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'noteId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignOperativeNoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignOperativeNoteRequest copyWith(
          void Function(SignOperativeNoteRequest) updates) =>
      super.copyWith((message) => updates(message as SignOperativeNoteRequest))
          as SignOperativeNoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignOperativeNoteRequest create() => SignOperativeNoteRequest._();
  @$core.override
  SignOperativeNoteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SignOperativeNoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignOperativeNoteRequest>(create);
  static SignOperativeNoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get noteId => $_getSZ(1);
  @$pb.TagNumber(2)
  set noteId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNoteId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNoteId() => $_clearField(2);
}

class SignOperativeNoteResponse extends $pb.GeneratedMessage {
  factory SignOperativeNoteResponse() => create();

  SignOperativeNoteResponse._();

  factory SignOperativeNoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignOperativeNoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignOperativeNoteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignOperativeNoteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignOperativeNoteResponse copyWith(
          void Function(SignOperativeNoteResponse) updates) =>
      super.copyWith((message) => updates(message as SignOperativeNoteResponse))
          as SignOperativeNoteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignOperativeNoteResponse create() => SignOperativeNoteResponse._();
  @$core.override
  SignOperativeNoteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SignOperativeNoteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignOperativeNoteResponse>(create);
  static SignOperativeNoteResponse? _defaultInstance;
}

class AmendOperativeNoteRequest extends $pb.GeneratedMessage {
  factory AmendOperativeNoteRequest({
    $core.String? caseId,
    $core.String? noteId,
    $core.String? reason,
    $core.String? procedurePerformed,
    $core.String? findings,
    $core.Iterable<$core.String>? specimenIds,
    $core.Iterable<$core.String>? implantIds,
    $core.Iterable<$core.String>? complications,
    $core.int? estimatedBloodLossMl,
    $core.String? postOperativeOrders,
    $core.String? narrative,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (noteId != null) result.noteId = noteId;
    if (reason != null) result.reason = reason;
    if (procedurePerformed != null)
      result.procedurePerformed = procedurePerformed;
    if (findings != null) result.findings = findings;
    if (specimenIds != null) result.specimenIds.addAll(specimenIds);
    if (implantIds != null) result.implantIds.addAll(implantIds);
    if (complications != null) result.complications.addAll(complications);
    if (estimatedBloodLossMl != null)
      result.estimatedBloodLossMl = estimatedBloodLossMl;
    if (postOperativeOrders != null)
      result.postOperativeOrders = postOperativeOrders;
    if (narrative != null) result.narrative = narrative;
    return result;
  }

  AmendOperativeNoteRequest._();

  factory AmendOperativeNoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AmendOperativeNoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AmendOperativeNoteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'noteId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOS(4, _omitFieldNames ? '' : 'procedurePerformed')
    ..aOS(5, _omitFieldNames ? '' : 'findings')
    ..pPS(6, _omitFieldNames ? '' : 'specimenIds')
    ..pPS(7, _omitFieldNames ? '' : 'implantIds')
    ..pPS(8, _omitFieldNames ? '' : 'complications')
    ..aI(9, _omitFieldNames ? '' : 'estimatedBloodLossMl')
    ..aOS(10, _omitFieldNames ? '' : 'postOperativeOrders')
    ..aOS(11, _omitFieldNames ? '' : 'narrative')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendOperativeNoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendOperativeNoteRequest copyWith(
          void Function(AmendOperativeNoteRequest) updates) =>
      super.copyWith((message) => updates(message as AmendOperativeNoteRequest))
          as AmendOperativeNoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AmendOperativeNoteRequest create() => AmendOperativeNoteRequest._();
  @$core.override
  AmendOperativeNoteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AmendOperativeNoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AmendOperativeNoteRequest>(create);
  static AmendOperativeNoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get noteId => $_getSZ(1);
  @$pb.TagNumber(2)
  set noteId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNoteId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNoteId() => $_clearField(2);

  /// Required. An unexplained amendment is the entry a claim asks about.
  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get procedurePerformed => $_getSZ(3);
  @$pb.TagNumber(4)
  set procedurePerformed($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProcedurePerformed() => $_has(3);
  @$pb.TagNumber(4)
  void clearProcedurePerformed() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get findings => $_getSZ(4);
  @$pb.TagNumber(5)
  set findings($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFindings() => $_has(4);
  @$pb.TagNumber(5)
  void clearFindings() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get specimenIds => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get implantIds => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get complications => $_getList(7);

  @$pb.TagNumber(9)
  $core.int get estimatedBloodLossMl => $_getIZ(8);
  @$pb.TagNumber(9)
  set estimatedBloodLossMl($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEstimatedBloodLossMl() => $_has(8);
  @$pb.TagNumber(9)
  void clearEstimatedBloodLossMl() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get postOperativeOrders => $_getSZ(9);
  @$pb.TagNumber(10)
  set postOperativeOrders($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPostOperativeOrders() => $_has(9);
  @$pb.TagNumber(10)
  void clearPostOperativeOrders() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get narrative => $_getSZ(10);
  @$pb.TagNumber(11)
  set narrative($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNarrative() => $_has(10);
  @$pb.TagNumber(11)
  void clearNarrative() => $_clearField(11);
}

class AmendOperativeNoteResponse extends $pb.GeneratedMessage {
  factory AmendOperativeNoteResponse({
    OperativeNote? note,
  }) {
    final result = create();
    if (note != null) result.note = note;
    return result;
  }

  AmendOperativeNoteResponse._();

  factory AmendOperativeNoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AmendOperativeNoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AmendOperativeNoteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<OperativeNote>(1, _omitFieldNames ? '' : 'note',
        subBuilder: OperativeNote.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendOperativeNoteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendOperativeNoteResponse copyWith(
          void Function(AmendOperativeNoteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AmendOperativeNoteResponse))
          as AmendOperativeNoteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AmendOperativeNoteResponse create() => AmendOperativeNoteResponse._();
  @$core.override
  AmendOperativeNoteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AmendOperativeNoteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AmendOperativeNoteResponse>(create);
  static AmendOperativeNoteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  OperativeNote get note => $_getN(0);
  @$pb.TagNumber(1)
  set note(OperativeNote value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNote() => $_has(0);
  @$pb.TagNumber(1)
  void clearNote() => $_clearField(1);
  @$pb.TagNumber(1)
  OperativeNote ensureNote() => $_ensure(0);
}

class RecordUsageRequest extends $pb.GeneratedMessage {
  factory RecordUsageRequest({
    $core.String? caseId,
    UsageKind? kind,
    $core.String? itemCode,
    $core.String? itemName,
    $core.String? lotNumber,
    $core.String? serialNumber,
    $core.int? quantity,
    $0.Timestamp? expiryDate,
    $core.bool? scanned,
    $core.String? scanData,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (kind != null) result.kind = kind;
    if (itemCode != null) result.itemCode = itemCode;
    if (itemName != null) result.itemName = itemName;
    if (lotNumber != null) result.lotNumber = lotNumber;
    if (serialNumber != null) result.serialNumber = serialNumber;
    if (quantity != null) result.quantity = quantity;
    if (expiryDate != null) result.expiryDate = expiryDate;
    if (scanned != null) result.scanned = scanned;
    if (scanData != null) result.scanData = scanData;
    return result;
  }

  RecordUsageRequest._();

  factory RecordUsageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordUsageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordUsageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aE<UsageKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: UsageKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'itemCode')
    ..aOS(4, _omitFieldNames ? '' : 'itemName')
    ..aOS(5, _omitFieldNames ? '' : 'lotNumber')
    ..aOS(6, _omitFieldNames ? '' : 'serialNumber')
    ..aI(7, _omitFieldNames ? '' : 'quantity')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'expiryDate',
        subBuilder: $0.Timestamp.create)
    ..aOB(9, _omitFieldNames ? '' : 'scanned')
    ..aOS(10, _omitFieldNames ? '' : 'scanData')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordUsageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordUsageRequest copyWith(void Function(RecordUsageRequest) updates) =>
      super.copyWith((message) => updates(message as RecordUsageRequest))
          as RecordUsageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordUsageRequest create() => RecordUsageRequest._();
  @$core.override
  RecordUsageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordUsageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordUsageRequest>(create);
  static RecordUsageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  UsageKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(UsageKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get itemCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set itemCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasItemCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearItemCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get itemName => $_getSZ(3);
  @$pb.TagNumber(4)
  set itemName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasItemName() => $_has(3);
  @$pb.TagNumber(4)
  void clearItemName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get lotNumber => $_getSZ(4);
  @$pb.TagNumber(5)
  set lotNumber($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLotNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearLotNumber() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get serialNumber => $_getSZ(5);
  @$pb.TagNumber(6)
  set serialNumber($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSerialNumber() => $_has(5);
  @$pb.TagNumber(6)
  void clearSerialNumber() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get quantity => $_getIZ(6);
  @$pb.TagNumber(7)
  set quantity($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasQuantity() => $_has(6);
  @$pb.TagNumber(7)
  void clearQuantity() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get expiryDate => $_getN(7);
  @$pb.TagNumber(8)
  set expiryDate($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasExpiryDate() => $_has(7);
  @$pb.TagNumber(8)
  void clearExpiryDate() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureExpiryDate() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.bool get scanned => $_getBF(8);
  @$pb.TagNumber(9)
  set scanned($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasScanned() => $_has(8);
  @$pb.TagNumber(9)
  void clearScanned() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get scanData => $_getSZ(9);
  @$pb.TagNumber(10)
  set scanData($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasScanData() => $_has(9);
  @$pb.TagNumber(10)
  void clearScanData() => $_clearField(10);
}

class RecordUsageResponse extends $pb.GeneratedMessage {
  factory RecordUsageResponse({
    Usage? usage,
  }) {
    final result = create();
    if (usage != null) result.usage = usage;
    return result;
  }

  RecordUsageResponse._();

  factory RecordUsageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordUsageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordUsageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<Usage>(1, _omitFieldNames ? '' : 'usage', subBuilder: Usage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordUsageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordUsageResponse copyWith(void Function(RecordUsageResponse) updates) =>
      super.copyWith((message) => updates(message as RecordUsageResponse))
          as RecordUsageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordUsageResponse create() => RecordUsageResponse._();
  @$core.override
  RecordUsageResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordUsageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordUsageResponse>(create);
  static RecordUsageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Usage get usage => $_getN(0);
  @$pb.TagNumber(1)
  set usage(Usage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUsage() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsage() => $_clearField(1);
  @$pb.TagNumber(1)
  Usage ensureUsage() => $_ensure(0);
}

class RecallImplantRequest extends $pb.GeneratedMessage {
  factory RecallImplantRequest({
    $core.String? itemCode,
    $core.String? lotNumber,
  }) {
    final result = create();
    if (itemCode != null) result.itemCode = itemCode;
    if (lotNumber != null) result.lotNumber = lotNumber;
    return result;
  }

  RecallImplantRequest._();

  factory RecallImplantRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecallImplantRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecallImplantRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemCode')
    ..aOS(2, _omitFieldNames ? '' : 'lotNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecallImplantRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecallImplantRequest copyWith(void Function(RecallImplantRequest) updates) =>
      super.copyWith((message) => updates(message as RecallImplantRequest))
          as RecallImplantRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecallImplantRequest create() => RecallImplantRequest._();
  @$core.override
  RecallImplantRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecallImplantRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecallImplantRequest>(create);
  static RecallImplantRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemCode() => $_clearField(1);

  /// Narrows to one lot. Empty reaches every patient who received the item.
  @$pb.TagNumber(2)
  $core.String get lotNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set lotNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLotNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearLotNumber() => $_clearField(2);
}

class RecallImplantResponse extends $pb.GeneratedMessage {
  factory RecallImplantResponse({
    $core.Iterable<Recipient>? recipients,
  }) {
    final result = create();
    if (recipients != null) result.recipients.addAll(recipients);
    return result;
  }

  RecallImplantResponse._();

  factory RecallImplantResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecallImplantResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecallImplantResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..pPM<Recipient>(1, _omitFieldNames ? '' : 'recipients',
        subBuilder: Recipient.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecallImplantResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecallImplantResponse copyWith(
          void Function(RecallImplantResponse) updates) =>
      super.copyWith((message) => updates(message as RecallImplantResponse))
          as RecallImplantResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecallImplantResponse create() => RecallImplantResponse._();
  @$core.override
  RecallImplantResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecallImplantResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecallImplantResponse>(create);
  static RecallImplantResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Recipient> get recipients => $_getList(0);
}

class TakeSpecimenRequest extends $pb.GeneratedMessage {
  factory TakeSpecimenRequest({
    $core.String? caseId,
    $core.String? label,
    $core.String? site,
    $core.String? container,
    $core.String? fixative,
    $0.Timestamp? takenAt,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (label != null) result.label = label;
    if (site != null) result.site = site;
    if (container != null) result.container = container;
    if (fixative != null) result.fixative = fixative;
    if (takenAt != null) result.takenAt = takenAt;
    return result;
  }

  TakeSpecimenRequest._();

  factory TakeSpecimenRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TakeSpecimenRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TakeSpecimenRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOS(3, _omitFieldNames ? '' : 'site')
    ..aOS(4, _omitFieldNames ? '' : 'container')
    ..aOS(5, _omitFieldNames ? '' : 'fixative')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'takenAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TakeSpecimenRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TakeSpecimenRequest copyWith(void Function(TakeSpecimenRequest) updates) =>
      super.copyWith((message) => updates(message as TakeSpecimenRequest))
          as TakeSpecimenRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TakeSpecimenRequest create() => TakeSpecimenRequest._();
  @$core.override
  TakeSpecimenRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TakeSpecimenRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TakeSpecimenRequest>(create);
  static TakeSpecimenRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  /// Defaults to the case's site. The patient and the laterality always come
  /// from the case, so a left-sided case cannot produce a right-sided specimen.
  @$pb.TagNumber(3)
  $core.String get site => $_getSZ(2);
  @$pb.TagNumber(3)
  set site($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSite() => $_has(2);
  @$pb.TagNumber(3)
  void clearSite() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get container => $_getSZ(3);
  @$pb.TagNumber(4)
  set container($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContainer() => $_has(3);
  @$pb.TagNumber(4)
  void clearContainer() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get fixative => $_getSZ(4);
  @$pb.TagNumber(5)
  set fixative($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFixative() => $_has(4);
  @$pb.TagNumber(5)
  void clearFixative() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get takenAt => $_getN(5);
  @$pb.TagNumber(6)
  set takenAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTakenAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearTakenAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureTakenAt() => $_ensure(5);
}

class TakeSpecimenResponse extends $pb.GeneratedMessage {
  factory TakeSpecimenResponse({
    Specimen? specimen,
  }) {
    final result = create();
    if (specimen != null) result.specimen = specimen;
    return result;
  }

  TakeSpecimenResponse._();

  factory TakeSpecimenResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TakeSpecimenResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TakeSpecimenResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<Specimen>(1, _omitFieldNames ? '' : 'specimen',
        subBuilder: Specimen.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TakeSpecimenResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TakeSpecimenResponse copyWith(void Function(TakeSpecimenResponse) updates) =>
      super.copyWith((message) => updates(message as TakeSpecimenResponse))
          as TakeSpecimenResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TakeSpecimenResponse create() => TakeSpecimenResponse._();
  @$core.override
  TakeSpecimenResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TakeSpecimenResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TakeSpecimenResponse>(create);
  static TakeSpecimenResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Specimen get specimen => $_getN(0);
  @$pb.TagNumber(1)
  set specimen(Specimen value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSpecimen() => $_has(0);
  @$pb.TagNumber(1)
  void clearSpecimen() => $_clearField(1);
  @$pb.TagNumber(1)
  Specimen ensureSpecimen() => $_ensure(0);
}

class AccessionSpecimenRequest extends $pb.GeneratedMessage {
  factory AccessionSpecimenRequest({
    $core.String? specimenId,
    $core.String? orderId,
  }) {
    final result = create();
    if (specimenId != null) result.specimenId = specimenId;
    if (orderId != null) result.orderId = orderId;
    return result;
  }

  AccessionSpecimenRequest._();

  factory AccessionSpecimenRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccessionSpecimenRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccessionSpecimenRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'specimenId')
    ..aOS(2, _omitFieldNames ? '' : 'orderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccessionSpecimenRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccessionSpecimenRequest copyWith(
          void Function(AccessionSpecimenRequest) updates) =>
      super.copyWith((message) => updates(message as AccessionSpecimenRequest))
          as AccessionSpecimenRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccessionSpecimenRequest create() => AccessionSpecimenRequest._();
  @$core.override
  AccessionSpecimenRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccessionSpecimenRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AccessionSpecimenRequest>(create);
  static AccessionSpecimenRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get specimenId => $_getSZ(0);
  @$pb.TagNumber(1)
  set specimenId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSpecimenId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSpecimenId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get orderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set orderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderId() => $_clearField(2);
}

class AccessionSpecimenResponse extends $pb.GeneratedMessage {
  factory AccessionSpecimenResponse() => create();

  AccessionSpecimenResponse._();

  factory AccessionSpecimenResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccessionSpecimenResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccessionSpecimenResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccessionSpecimenResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccessionSpecimenResponse copyWith(
          void Function(AccessionSpecimenResponse) updates) =>
      super.copyWith((message) => updates(message as AccessionSpecimenResponse))
          as AccessionSpecimenResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccessionSpecimenResponse create() => AccessionSpecimenResponse._();
  @$core.override
  AccessionSpecimenResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccessionSpecimenResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AccessionSpecimenResponse>(create);
  static AccessionSpecimenResponse? _defaultInstance;
}

class ListOutstandingSpecimensRequest extends $pb.GeneratedMessage {
  factory ListOutstandingSpecimensRequest({
    $core.String? facilityId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListOutstandingSpecimensRequest._();

  factory ListOutstandingSpecimensRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOutstandingSpecimensRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOutstandingSpecimensRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutstandingSpecimensRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutstandingSpecimensRequest copyWith(
          void Function(ListOutstandingSpecimensRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListOutstandingSpecimensRequest))
          as ListOutstandingSpecimensRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOutstandingSpecimensRequest create() =>
      ListOutstandingSpecimensRequest._();
  @$core.override
  ListOutstandingSpecimensRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOutstandingSpecimensRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOutstandingSpecimensRequest>(
          create);
  static ListOutstandingSpecimensRequest? _defaultInstance;

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

class ListOutstandingSpecimensResponse extends $pb.GeneratedMessage {
  factory ListOutstandingSpecimensResponse({
    $core.Iterable<Specimen>? specimens,
  }) {
    final result = create();
    if (specimens != null) result.specimens.addAll(specimens);
    return result;
  }

  ListOutstandingSpecimensResponse._();

  factory ListOutstandingSpecimensResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOutstandingSpecimensResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOutstandingSpecimensResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..pPM<Specimen>(1, _omitFieldNames ? '' : 'specimens',
        subBuilder: Specimen.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutstandingSpecimensResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutstandingSpecimensResponse copyWith(
          void Function(ListOutstandingSpecimensResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListOutstandingSpecimensResponse))
          as ListOutstandingSpecimensResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOutstandingSpecimensResponse create() =>
      ListOutstandingSpecimensResponse._();
  @$core.override
  ListOutstandingSpecimensResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOutstandingSpecimensResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOutstandingSpecimensResponse>(
          create);
  static ListOutstandingSpecimensResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Specimen> get specimens => $_getList(0);
}

class OpenTrayRequest extends $pb.GeneratedMessage {
  factory OpenTrayRequest({
    $core.String? caseId,
    $core.String? trayId,
    $core.String? trayName,
    $core.String? cycleId,
    $core.bool? indicatorPassed,
    $core.String? indicatorNote,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (trayId != null) result.trayId = trayId;
    if (trayName != null) result.trayName = trayName;
    if (cycleId != null) result.cycleId = cycleId;
    if (indicatorPassed != null) result.indicatorPassed = indicatorPassed;
    if (indicatorNote != null) result.indicatorNote = indicatorNote;
    return result;
  }

  OpenTrayRequest._();

  factory OpenTrayRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenTrayRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenTrayRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'trayId')
    ..aOS(3, _omitFieldNames ? '' : 'trayName')
    ..aOS(4, _omitFieldNames ? '' : 'cycleId')
    ..aOB(5, _omitFieldNames ? '' : 'indicatorPassed')
    ..aOS(6, _omitFieldNames ? '' : 'indicatorNote')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenTrayRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenTrayRequest copyWith(void Function(OpenTrayRequest) updates) =>
      super.copyWith((message) => updates(message as OpenTrayRequest))
          as OpenTrayRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenTrayRequest create() => OpenTrayRequest._();
  @$core.override
  OpenTrayRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenTrayRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenTrayRequest>(create);
  static OpenTrayRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get trayId => $_getSZ(1);
  @$pb.TagNumber(2)
  set trayId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTrayId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrayId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get trayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set trayName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTrayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrayName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cycleId => $_getSZ(3);
  @$pb.TagNumber(4)
  set cycleId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCycleId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCycleId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get indicatorPassed => $_getBF(4);
  @$pb.TagNumber(5)
  set indicatorPassed($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIndicatorPassed() => $_has(4);
  @$pb.TagNumber(5)
  void clearIndicatorPassed() => $_clearField(5);

  /// Required when the indicator failed: a failed indicator recorded without
  /// saying what was done is worse than not recording it.
  @$pb.TagNumber(6)
  $core.String get indicatorNote => $_getSZ(5);
  @$pb.TagNumber(6)
  set indicatorNote($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIndicatorNote() => $_has(5);
  @$pb.TagNumber(6)
  void clearIndicatorNote() => $_clearField(6);
}

class OpenTrayResponse extends $pb.GeneratedMessage {
  factory OpenTrayResponse({
    TrayUse? trayUse,
  }) {
    final result = create();
    if (trayUse != null) result.trayUse = trayUse;
    return result;
  }

  OpenTrayResponse._();

  factory OpenTrayResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenTrayResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenTrayResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<TrayUse>(1, _omitFieldNames ? '' : 'trayUse',
        subBuilder: TrayUse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenTrayResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenTrayResponse copyWith(void Function(OpenTrayResponse) updates) =>
      super.copyWith((message) => updates(message as OpenTrayResponse))
          as OpenTrayResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenTrayResponse create() => OpenTrayResponse._();
  @$core.override
  OpenTrayResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenTrayResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenTrayResponse>(create);
  static OpenTrayResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TrayUse get trayUse => $_getN(0);
  @$pb.TagNumber(1)
  set trayUse(TrayUse value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrayUse() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrayUse() => $_clearField(1);
  @$pb.TagNumber(1)
  TrayUse ensureTrayUse() => $_ensure(0);
}

class TraceCycleRequest extends $pb.GeneratedMessage {
  factory TraceCycleRequest({
    $core.String? cycleId,
  }) {
    final result = create();
    if (cycleId != null) result.cycleId = cycleId;
    return result;
  }

  TraceCycleRequest._();

  factory TraceCycleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TraceCycleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TraceCycleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cycleId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceCycleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceCycleRequest copyWith(void Function(TraceCycleRequest) updates) =>
      super.copyWith((message) => updates(message as TraceCycleRequest))
          as TraceCycleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TraceCycleRequest create() => TraceCycleRequest._();
  @$core.override
  TraceCycleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TraceCycleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TraceCycleRequest>(create);
  static TraceCycleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cycleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cycleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCycleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycleId() => $_clearField(1);
}

class TraceCycleResponse extends $pb.GeneratedMessage {
  factory TraceCycleResponse({
    $core.Iterable<Recipient>? recipients,
  }) {
    final result = create();
    if (recipients != null) result.recipients.addAll(recipients);
    return result;
  }

  TraceCycleResponse._();

  factory TraceCycleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TraceCycleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TraceCycleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..pPM<Recipient>(1, _omitFieldNames ? '' : 'recipients',
        subBuilder: Recipient.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceCycleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceCycleResponse copyWith(void Function(TraceCycleResponse) updates) =>
      super.copyWith((message) => updates(message as TraceCycleResponse))
          as TraceCycleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TraceCycleResponse create() => TraceCycleResponse._();
  @$core.override
  TraceCycleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TraceCycleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TraceCycleResponse>(create);
  static TraceCycleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Recipient> get recipients => $_getList(0);
}

class SavePreferenceCardRequest extends $pb.GeneratedMessage {
  factory SavePreferenceCardRequest({
    $core.String? surgeonId,
    $core.String? procedureCode,
    $core.String? name,
    $core.Iterable<$core.String>? equipment,
    $core.Iterable<CardItem>? consumables,
    $core.Iterable<$core.String>? trays,
    $core.String? notes,
  }) {
    final result = create();
    if (surgeonId != null) result.surgeonId = surgeonId;
    if (procedureCode != null) result.procedureCode = procedureCode;
    if (name != null) result.name = name;
    if (equipment != null) result.equipment.addAll(equipment);
    if (consumables != null) result.consumables.addAll(consumables);
    if (trays != null) result.trays.addAll(trays);
    if (notes != null) result.notes = notes;
    return result;
  }

  SavePreferenceCardRequest._();

  factory SavePreferenceCardRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SavePreferenceCardRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SavePreferenceCardRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'surgeonId')
    ..aOS(2, _omitFieldNames ? '' : 'procedureCode')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..pPS(4, _omitFieldNames ? '' : 'equipment')
    ..pPM<CardItem>(5, _omitFieldNames ? '' : 'consumables',
        subBuilder: CardItem.create)
    ..pPS(6, _omitFieldNames ? '' : 'trays')
    ..aOS(7, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SavePreferenceCardRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SavePreferenceCardRequest copyWith(
          void Function(SavePreferenceCardRequest) updates) =>
      super.copyWith((message) => updates(message as SavePreferenceCardRequest))
          as SavePreferenceCardRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SavePreferenceCardRequest create() => SavePreferenceCardRequest._();
  @$core.override
  SavePreferenceCardRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SavePreferenceCardRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SavePreferenceCardRequest>(create);
  static SavePreferenceCardRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get surgeonId => $_getSZ(0);
  @$pb.TagNumber(1)
  set surgeonId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSurgeonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurgeonId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get procedureCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set procedureCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProcedureCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearProcedureCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get equipment => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<CardItem> get consumables => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get trays => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get notes => $_getSZ(6);
  @$pb.TagNumber(7)
  set notes($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNotes() => $_has(6);
  @$pb.TagNumber(7)
  void clearNotes() => $_clearField(7);
}

class SavePreferenceCardResponse extends $pb.GeneratedMessage {
  factory SavePreferenceCardResponse({
    PreferenceCard? card,
  }) {
    final result = create();
    if (card != null) result.card = card;
    return result;
  }

  SavePreferenceCardResponse._();

  factory SavePreferenceCardResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SavePreferenceCardResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SavePreferenceCardResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<PreferenceCard>(1, _omitFieldNames ? '' : 'card',
        subBuilder: PreferenceCard.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SavePreferenceCardResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SavePreferenceCardResponse copyWith(
          void Function(SavePreferenceCardResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SavePreferenceCardResponse))
          as SavePreferenceCardResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SavePreferenceCardResponse create() => SavePreferenceCardResponse._();
  @$core.override
  SavePreferenceCardResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SavePreferenceCardResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SavePreferenceCardResponse>(create);
  static SavePreferenceCardResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PreferenceCard get card => $_getN(0);
  @$pb.TagNumber(1)
  set card(PreferenceCard value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCard() => $_has(0);
  @$pb.TagNumber(1)
  void clearCard() => $_clearField(1);
  @$pb.TagNumber(1)
  PreferenceCard ensureCard() => $_ensure(0);
}

class GetPreferenceCardRequest extends $pb.GeneratedMessage {
  factory GetPreferenceCardRequest({
    $core.String? surgeonId,
    $core.String? procedureCode,
  }) {
    final result = create();
    if (surgeonId != null) result.surgeonId = surgeonId;
    if (procedureCode != null) result.procedureCode = procedureCode;
    return result;
  }

  GetPreferenceCardRequest._();

  factory GetPreferenceCardRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPreferenceCardRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPreferenceCardRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'surgeonId')
    ..aOS(2, _omitFieldNames ? '' : 'procedureCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPreferenceCardRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPreferenceCardRequest copyWith(
          void Function(GetPreferenceCardRequest) updates) =>
      super.copyWith((message) => updates(message as GetPreferenceCardRequest))
          as GetPreferenceCardRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPreferenceCardRequest create() => GetPreferenceCardRequest._();
  @$core.override
  GetPreferenceCardRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPreferenceCardRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPreferenceCardRequest>(create);
  static GetPreferenceCardRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get surgeonId => $_getSZ(0);
  @$pb.TagNumber(1)
  set surgeonId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSurgeonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurgeonId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get procedureCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set procedureCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProcedureCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearProcedureCode() => $_clearField(2);
}

class GetPreferenceCardResponse extends $pb.GeneratedMessage {
  factory GetPreferenceCardResponse({
    PreferenceCard? card,
    $core.bool? found,
  }) {
    final result = create();
    if (card != null) result.card = card;
    if (found != null) result.found = found;
    return result;
  }

  GetPreferenceCardResponse._();

  factory GetPreferenceCardResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPreferenceCardResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPreferenceCardResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<PreferenceCard>(1, _omitFieldNames ? '' : 'card',
        subBuilder: PreferenceCard.create)
    ..aOB(2, _omitFieldNames ? '' : 'found')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPreferenceCardResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPreferenceCardResponse copyWith(
          void Function(GetPreferenceCardResponse) updates) =>
      super.copyWith((message) => updates(message as GetPreferenceCardResponse))
          as GetPreferenceCardResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPreferenceCardResponse create() => GetPreferenceCardResponse._();
  @$core.override
  GetPreferenceCardResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPreferenceCardResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPreferenceCardResponse>(create);
  static GetPreferenceCardResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PreferenceCard get card => $_getN(0);
  @$pb.TagNumber(1)
  set card(PreferenceCard value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCard() => $_has(0);
  @$pb.TagNumber(1)
  void clearCard() => $_clearField(1);
  @$pb.TagNumber(1)
  PreferenceCard ensureCard() => $_ensure(0);

  /// False where the surgeon has no card for this procedure, which is the
  /// ordinary case and not an error.
  @$pb.TagNumber(2)
  $core.bool get found => $_getBF(1);
  @$pb.TagNumber(2)
  set found($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFound() => $_has(1);
  @$pb.TagNumber(2)
  void clearFound() => $_clearField(2);
}

class GetBoardRequest extends $pb.GeneratedMessage {
  factory GetBoardRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  GetBoardRequest._();

  factory GetBoardRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBoardRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBoardRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBoardRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBoardRequest copyWith(void Function(GetBoardRequest) updates) =>
      super.copyWith((message) => updates(message as GetBoardRequest))
          as GetBoardRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBoardRequest create() => GetBoardRequest._();
  @$core.override
  GetBoardRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBoardRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBoardRequest>(create);
  static GetBoardRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

class GetBoardResponse extends $pb.GeneratedMessage {
  factory GetBoardResponse({
    $core.Iterable<BoardRow>? rows,
  }) {
    final result = create();
    if (rows != null) result.rows.addAll(rows);
    return result;
  }

  GetBoardResponse._();

  factory GetBoardResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBoardResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBoardResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..pPM<BoardRow>(1, _omitFieldNames ? '' : 'rows',
        subBuilder: BoardRow.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBoardResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBoardResponse copyWith(void Function(GetBoardResponse) updates) =>
      super.copyWith((message) => updates(message as GetBoardResponse))
          as GetBoardResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBoardResponse create() => GetBoardResponse._();
  @$core.override
  GetBoardResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBoardResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBoardResponse>(create);
  static GetBoardResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BoardRow> get rows => $_getList(0);
}

class GetUtilisationRequest extends $pb.GeneratedMessage {
  factory GetUtilisationRequest({
    $core.String? roomId,
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  GetUtilisationRequest._();

  factory GetUtilisationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUtilisationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUtilisationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUtilisationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUtilisationRequest copyWith(
          void Function(GetUtilisationRequest) updates) =>
      super.copyWith((message) => updates(message as GetUtilisationRequest))
          as GetUtilisationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUtilisationRequest create() => GetUtilisationRequest._();
  @$core.override
  GetUtilisationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUtilisationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUtilisationRequest>(create);
  static GetUtilisationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

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

class GetUtilisationResponse extends $pb.GeneratedMessage {
  factory GetUtilisationResponse({
    Utilisation? utilisation,
  }) {
    final result = create();
    if (utilisation != null) result.utilisation = utilisation;
    return result;
  }

  GetUtilisationResponse._();

  factory GetUtilisationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUtilisationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUtilisationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.theatre.v1'),
      createEmptyInstance: create)
    ..aOM<Utilisation>(1, _omitFieldNames ? '' : 'utilisation',
        subBuilder: Utilisation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUtilisationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUtilisationResponse copyWith(
          void Function(GetUtilisationResponse) updates) =>
      super.copyWith((message) => updates(message as GetUtilisationResponse))
          as GetUtilisationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUtilisationResponse create() => GetUtilisationResponse._();
  @$core.override
  GetUtilisationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUtilisationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUtilisationResponse>(create);
  static GetUtilisationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Utilisation get utilisation => $_getN(0);
  @$pb.TagNumber(1)
  set utilisation(Utilisation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUtilisation() => $_has(0);
  @$pb.TagNumber(1)
  void clearUtilisation() => $_clearField(1);
  @$pb.TagNumber(1)
  Utilisation ensureUtilisation() => $_ensure(0);
}

class TheatreServiceApi {
  final $pb.RpcClient _client;

  TheatreServiceApi(this._client);

  /// Rooms and lists (SRS-OT-001).
  $async.Future<SaveRoomResponse> saveRoom(
          $pb.ClientContext? ctx, SaveRoomRequest request) =>
      _client.invoke<SaveRoomResponse>(
          ctx, 'TheatreService', 'SaveRoom', request, SaveRoomResponse());
  $async.Future<ListRoomsResponse> listRooms(
          $pb.ClientContext? ctx, ListRoomsRequest request) =>
      _client.invoke<ListRoomsResponse>(
          ctx, 'TheatreService', 'ListRooms', request, ListRoomsResponse());
  $async.Future<SaveBlockResponse> saveBlock(
          $pb.ClientContext? ctx, SaveBlockRequest request) =>
      _client.invoke<SaveBlockResponse>(
          ctx, 'TheatreService', 'SaveBlock', request, SaveBlockResponse());

  /// The request, priority and scheduling (SRS-OT-002 … 005, SRS-OT-017).
  $async.Future<RequestSurgeryResponse> requestSurgery(
          $pb.ClientContext? ctx, RequestSurgeryRequest request) =>
      _client.invoke<RequestSurgeryResponse>(ctx, 'TheatreService',
          'RequestSurgery', request, RequestSurgeryResponse());
  $async.Future<CompleteRequestResponse> completeRequest(
          $pb.ClientContext? ctx, CompleteRequestRequest request) =>
      _client.invoke<CompleteRequestResponse>(ctx, 'TheatreService',
          'CompleteRequest', request, CompleteRequestResponse());
  $async.Future<GetSurgicalCaseResponse> getSurgicalCase(
          $pb.ClientContext? ctx, GetSurgicalCaseRequest request) =>
      _client.invoke<GetSurgicalCaseResponse>(ctx, 'TheatreService',
          'GetSurgicalCase', request, GetSurgicalCaseResponse());
  $async.Future<ReprioritiseResponse> reprioritise(
          $pb.ClientContext? ctx, ReprioritiseRequest request) =>
      _client.invoke<ReprioritiseResponse>(ctx, 'TheatreService',
          'Reprioritise', request, ReprioritiseResponse());
  $async.Future<CheckSlotResponse> checkSlot(
          $pb.ClientContext? ctx, CheckSlotRequest request) =>
      _client.invoke<CheckSlotResponse>(
          ctx, 'TheatreService', 'CheckSlot', request, CheckSlotResponse());
  $async.Future<ScheduleCaseResponse> scheduleCase(
          $pb.ClientContext? ctx, ScheduleCaseRequest request) =>
      _client.invoke<ScheduleCaseResponse>(ctx, 'TheatreService',
          'ScheduleCase', request, ScheduleCaseResponse());
  $async.Future<CloseCaseResponse> closeCase(
          $pb.ClientContext? ctx, CloseCaseRequest request) =>
      _client.invoke<CloseCaseResponse>(
          ctx, 'TheatreService', 'CloseCase', request, CloseCaseResponse());
  $async.Future<ListWaitingResponse> listWaiting(
          $pb.ClientContext? ctx, ListWaitingRequest request) =>
      _client.invoke<ListWaitingResponse>(
          ctx, 'TheatreService', 'ListWaiting', request, ListWaitingResponse());

  /// The checklists (SRS-OT-006, SRS-OT-007).
  $async.Future<RecordPreopResponse> recordPreop(
          $pb.ClientContext? ctx, RecordPreopRequest request) =>
      _client.invoke<RecordPreopResponse>(
          ctx, 'TheatreService', 'RecordPreop', request, RecordPreopResponse());
  $async.Future<ListBlockersResponse> listBlockers(
          $pb.ClientContext? ctx, ListBlockersRequest request) =>
      _client.invoke<ListBlockersResponse>(ctx, 'TheatreService',
          'ListBlockers', request, ListBlockersResponse());
  $async.Future<PerformSafetyCheckResponse> performSafetyCheck(
          $pb.ClientContext? ctx, PerformSafetyCheckRequest request) =>
      _client.invoke<PerformSafetyCheckResponse>(ctx, 'TheatreService',
          'PerformSafetyCheck', request, PerformSafetyCheckResponse());

  /// Movement and delays (SRS-OT-008, SRS-OT-014).
  $async.Future<RecordMilestoneResponse> recordMilestone(
          $pb.ClientContext? ctx, RecordMilestoneRequest request) =>
      _client.invoke<RecordMilestoneResponse>(ctx, 'TheatreService',
          'RecordMilestone', request, RecordMilestoneResponse());
  $async.Future<GetTimelineResponse> getTimeline(
          $pb.ClientContext? ctx, GetTimelineRequest request) =>
      _client.invoke<GetTimelineResponse>(
          ctx, 'TheatreService', 'GetTimeline', request, GetTimelineResponse());
  $async.Future<RecordDelayResponse> recordDelay(
          $pb.ClientContext? ctx, RecordDelayRequest request) =>
      _client.invoke<RecordDelayResponse>(
          ctx, 'TheatreService', 'RecordDelay', request, RecordDelayResponse());

  /// The operative note (SRS-OT-009).
  $async.Future<WriteOperativeNoteResponse> writeOperativeNote(
          $pb.ClientContext? ctx, WriteOperativeNoteRequest request) =>
      _client.invoke<WriteOperativeNoteResponse>(ctx, 'TheatreService',
          'WriteOperativeNote', request, WriteOperativeNoteResponse());
  $async.Future<SignOperativeNoteResponse> signOperativeNote(
          $pb.ClientContext? ctx, SignOperativeNoteRequest request) =>
      _client.invoke<SignOperativeNoteResponse>(ctx, 'TheatreService',
          'SignOperativeNote', request, SignOperativeNoteResponse());
  $async.Future<AmendOperativeNoteResponse> amendOperativeNote(
          $pb.ClientContext? ctx, AmendOperativeNoteRequest request) =>
      _client.invoke<AmendOperativeNoteResponse>(ctx, 'TheatreService',
          'AmendOperativeNote', request, AmendOperativeNoteResponse());

  /// Consumables, implants, specimens and trays (SRS-OT-010 … 012).
  $async.Future<RecordUsageResponse> recordUsage(
          $pb.ClientContext? ctx, RecordUsageRequest request) =>
      _client.invoke<RecordUsageResponse>(
          ctx, 'TheatreService', 'RecordUsage', request, RecordUsageResponse());
  $async.Future<RecallImplantResponse> recallImplant(
          $pb.ClientContext? ctx, RecallImplantRequest request) =>
      _client.invoke<RecallImplantResponse>(ctx, 'TheatreService',
          'RecallImplant', request, RecallImplantResponse());
  $async.Future<TakeSpecimenResponse> takeSpecimen(
          $pb.ClientContext? ctx, TakeSpecimenRequest request) =>
      _client.invoke<TakeSpecimenResponse>(ctx, 'TheatreService',
          'TakeSpecimen', request, TakeSpecimenResponse());
  $async.Future<AccessionSpecimenResponse> accessionSpecimen(
          $pb.ClientContext? ctx, AccessionSpecimenRequest request) =>
      _client.invoke<AccessionSpecimenResponse>(ctx, 'TheatreService',
          'AccessionSpecimen', request, AccessionSpecimenResponse());
  $async.Future<ListOutstandingSpecimensResponse> listOutstandingSpecimens(
          $pb.ClientContext? ctx, ListOutstandingSpecimensRequest request) =>
      _client.invoke<ListOutstandingSpecimensResponse>(
          ctx,
          'TheatreService',
          'ListOutstandingSpecimens',
          request,
          ListOutstandingSpecimensResponse());
  $async.Future<OpenTrayResponse> openTray(
          $pb.ClientContext? ctx, OpenTrayRequest request) =>
      _client.invoke<OpenTrayResponse>(
          ctx, 'TheatreService', 'OpenTray', request, OpenTrayResponse());
  $async.Future<TraceCycleResponse> traceCycle(
          $pb.ClientContext? ctx, TraceCycleRequest request) =>
      _client.invoke<TraceCycleResponse>(
          ctx, 'TheatreService', 'TraceCycle', request, TraceCycleResponse());

  /// Preference cards, the board and the numbers (SRS-OT-013, 015, 016).
  $async.Future<SavePreferenceCardResponse> savePreferenceCard(
          $pb.ClientContext? ctx, SavePreferenceCardRequest request) =>
      _client.invoke<SavePreferenceCardResponse>(ctx, 'TheatreService',
          'SavePreferenceCard', request, SavePreferenceCardResponse());
  $async.Future<GetPreferenceCardResponse> getPreferenceCard(
          $pb.ClientContext? ctx, GetPreferenceCardRequest request) =>
      _client.invoke<GetPreferenceCardResponse>(ctx, 'TheatreService',
          'GetPreferenceCard', request, GetPreferenceCardResponse());
  $async.Future<GetBoardResponse> getBoard(
          $pb.ClientContext? ctx, GetBoardRequest request) =>
      _client.invoke<GetBoardResponse>(
          ctx, 'TheatreService', 'GetBoard', request, GetBoardResponse());
  $async.Future<GetUtilisationResponse> getUtilisation(
          $pb.ClientContext? ctx, GetUtilisationRequest request) =>
      _client.invoke<GetUtilisationResponse>(ctx, 'TheatreService',
          'GetUtilisation', request, GetUtilisationResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
