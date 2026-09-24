// This is a generated file - do not edit.
//
// Generated from healthcare/records/v1/records.proto.

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

import 'records.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'records.pbenum.dart';

/// One thing a complete chart has to have (SRS-MRD-001).
class ChecklistItem extends $pb.GeneratedMessage {
  factory ChecklistItem({
    $core.String? kind,
    $core.String? label,
    DocumentRequirement? requirement,
    $fixnum.Int64? dueWithinSeconds,
    $core.String? conditionCode,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (label != null) result.label = label;
    if (requirement != null) result.requirement = requirement;
    if (dueWithinSeconds != null) result.dueWithinSeconds = dueWithinSeconds;
    if (conditionCode != null) result.conditionCode = conditionCode;
    return result;
  }

  ChecklistItem._();

  factory ChecklistItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChecklistItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChecklistItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'kind')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aE<DocumentRequirement>(3, _omitFieldNames ? '' : 'requirement',
        enumValues: DocumentRequirement.values)
    ..aInt64(4, _omitFieldNames ? '' : 'dueWithinSeconds')
    ..aOS(5, _omitFieldNames ? '' : 'conditionCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChecklistItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChecklistItem copyWith(void Function(ChecklistItem) updates) =>
      super.copyWith((message) => updates(message as ChecklistItem))
          as ChecklistItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChecklistItem create() => ChecklistItem._();
  @$core.override
  ChecklistItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChecklistItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChecklistItem>(create);
  static ChecklistItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get kind => $_getSZ(0);
  @$pb.TagNumber(1)
  set kind($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  @$pb.TagNumber(3)
  DocumentRequirement get requirement => $_getN(2);
  @$pb.TagNumber(3)
  set requirement(DocumentRequirement value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRequirement() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequirement() => $_clearField(3);

  /// Seconds after the encounter ends. Zero leaves no deadline rather than a
  /// deadline in 1970.
  @$pb.TagNumber(4)
  $fixnum.Int64 get dueWithinSeconds => $_getI64(3);
  @$pb.TagNumber(4)
  set dueWithinSeconds($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDueWithinSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearDueWithinSeconds() => $_clearField(4);

  /// The encounter fact that switches a conditional item on.
  @$pb.TagNumber(5)
  $core.String get conditionCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set conditionCode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConditionCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearConditionCode() => $_clearField(5);
}

/// A versioned definition of what a complete chart is (SRS-MRD-001).
class ChartChecklist extends $pb.GeneratedMessage {
  factory ChartChecklist({
    $core.String? checklistId,
    $core.String? code,
    $core.String? name,
    $core.int? revision,
    $core.String? encounterClass,
    $core.String? specialty,
    $core.Iterable<ChecklistItem>? items,
    $core.bool? approved,
    $core.String? approvedBy,
    $0.Timestamp? approvedAt,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? supersededAt,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
  }) {
    final result = create();
    if (checklistId != null) result.checklistId = checklistId;
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (revision != null) result.revision = revision;
    if (encounterClass != null) result.encounterClass = encounterClass;
    if (specialty != null) result.specialty = specialty;
    if (items != null) result.items.addAll(items);
    if (approved != null) result.approved = approved;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (supersededAt != null) result.supersededAt = supersededAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    return result;
  }

  ChartChecklist._();

  factory ChartChecklist.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChartChecklist.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChartChecklist',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'checklistId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aI(4, _omitFieldNames ? '' : 'revision')
    ..aOS(5, _omitFieldNames ? '' : 'encounterClass')
    ..aOS(6, _omitFieldNames ? '' : 'specialty')
    ..pPM<ChecklistItem>(7, _omitFieldNames ? '' : 'items',
        subBuilder: ChecklistItem.create)
    ..aOB(8, _omitFieldNames ? '' : 'approved')
    ..aOS(9, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'approvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'supersededAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(14, _omitFieldNames ? '' : 'createdBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartChecklist clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartChecklist copyWith(void Function(ChartChecklist) updates) =>
      super.copyWith((message) => updates(message as ChartChecklist))
          as ChartChecklist;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChartChecklist create() => ChartChecklist._();
  @$core.override
  ChartChecklist createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChartChecklist getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChartChecklist>(create);
  static ChartChecklist? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checklistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checklistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChecklistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChecklistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get revision => $_getIZ(3);
  @$pb.TagNumber(4)
  set revision($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevision() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get encounterClass => $_getSZ(4);
  @$pb.TagNumber(5)
  set encounterClass($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEncounterClass() => $_has(4);
  @$pb.TagNumber(5)
  void clearEncounterClass() => $_clearField(5);

  /// Empty applies to every specialty; a specific one beats the general.
  @$pb.TagNumber(6)
  $core.String get specialty => $_getSZ(5);
  @$pb.TagNumber(6)
  set specialty($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSpecialty() => $_has(5);
  @$pb.TagNumber(6)
  void clearSpecialty() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<ChecklistItem> get items => $_getList(6);

  @$pb.TagNumber(8)
  $core.bool get approved => $_getBF(7);
  @$pb.TagNumber(8)
  set approved($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasApproved() => $_has(7);
  @$pb.TagNumber(8)
  void clearApproved() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get approvedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set approvedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasApprovedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearApprovedBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get approvedAt => $_getN(9);
  @$pb.TagNumber(10)
  set approvedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasApprovedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearApprovedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureApprovedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $0.Timestamp get effectiveFrom => $_getN(10);
  @$pb.TagNumber(11)
  set effectiveFrom($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasEffectiveFrom() => $_has(10);
  @$pb.TagNumber(11)
  void clearEffectiveFrom() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(10);

  @$pb.TagNumber(12)
  $0.Timestamp get supersededAt => $_getN(11);
  @$pb.TagNumber(12)
  set supersededAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSupersededAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearSupersededAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureSupersededAt() => $_ensure(11);

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

/// One thing a chart is missing (SRS-MRD-001).
class Gap extends $pb.GeneratedMessage {
  factory Gap({
    $core.String? kind,
    $core.String? label,
    $core.bool? missing,
    $core.String? documentId,
    $core.String? ownerId,
    $0.Timestamp? dueBy,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (label != null) result.label = label;
    if (missing != null) result.missing = missing;
    if (documentId != null) result.documentId = documentId;
    if (ownerId != null) result.ownerId = ownerId;
    if (dueBy != null) result.dueBy = dueBy;
    return result;
  }

  Gap._();

  factory Gap.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Gap.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Gap',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'kind')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOB(3, _omitFieldNames ? '' : 'missing')
    ..aOS(4, _omitFieldNames ? '' : 'documentId')
    ..aOS(5, _omitFieldNames ? '' : 'ownerId')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'dueBy',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Gap clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Gap copyWith(void Function(Gap) updates) =>
      super.copyWith((message) => updates(message as Gap)) as Gap;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Gap create() => Gap._();
  @$core.override
  Gap createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Gap getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Gap>(create);
  static Gap? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get kind => $_getSZ(0);
  @$pb.TagNumber(1)
  set kind($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  /// Missing distinguishes "there is no operation note" from "there is one and
  /// nobody signed it". They go to different people.
  @$pb.TagNumber(3)
  $core.bool get missing => $_getBF(2);
  @$pb.TagNumber(3)
  set missing($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMissing() => $_has(2);
  @$pb.TagNumber(3)
  void clearMissing() => $_clearField(3);

  /// The unsigned document, where there is one.
  @$pb.TagNumber(4)
  $core.String get documentId => $_getSZ(3);
  @$pb.TagNumber(4)
  set documentId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDocumentId() => $_has(3);
  @$pb.TagNumber(4)
  void clearDocumentId() => $_clearField(4);

  /// Who owes it — the author of the unsigned document. Empty for a missing
  /// one, because nobody wrote it.
  @$pb.TagNumber(5)
  $core.String get ownerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set ownerId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOwnerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearOwnerId() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get dueBy => $_getN(5);
  @$pb.TagNumber(6)
  set dueBy($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasDueBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearDueBy() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureDueBy() => $_ensure(5);
}

/// What a chart is missing and which version of the rules says so
/// (SRS-MRD-001).
class ChartStatus extends $pb.GeneratedMessage {
  factory ChartStatus({
    $core.String? encounterId,
    $core.String? patientId,
    $core.String? checklistCode,
    $core.int? checklistRevision,
    $core.Iterable<Gap>? gaps,
    $core.int? documents,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (checklistCode != null) result.checklistCode = checklistCode;
    if (checklistRevision != null) result.checklistRevision = checklistRevision;
    if (gaps != null) result.gaps.addAll(gaps);
    if (documents != null) result.documents = documents;
    return result;
  }

  ChartStatus._();

  factory ChartStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChartStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChartStatus',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'checklistCode')
    ..aI(4, _omitFieldNames ? '' : 'checklistRevision')
    ..pPM<Gap>(5, _omitFieldNames ? '' : 'gaps', subBuilder: Gap.create)
    ..aI(6, _omitFieldNames ? '' : 'documents')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartStatus copyWith(void Function(ChartStatus) updates) =>
      super.copyWith((message) => updates(message as ChartStatus))
          as ChartStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChartStatus create() => ChartStatus._();
  @$core.override
  ChartStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChartStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChartStatus>(create);
  static ChartStatus? _defaultInstance;

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
  $core.String get checklistCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set checklistCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChecklistCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearChecklistCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get checklistRevision => $_getIZ(3);
  @$pb.TagNumber(4)
  set checklistRevision($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChecklistRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearChecklistRevision() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<Gap> get gaps => $_getList(4);

  /// What the chart holds, so "no gaps" and "no documents at all" are
  /// distinguishable to a reader.
  @$pb.TagNumber(6)
  $core.int get documents => $_getIZ(5);
  @$pb.TagNumber(6)
  set documents($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDocuments() => $_has(5);
  @$pb.TagNumber(6)
  void clearDocuments() => $_clearField(6);
}

/// One outstanding item on a clinician's worklist (SRS-MRD-002).
class Deficiency extends $pb.GeneratedMessage {
  factory Deficiency({
    $core.String? deficiencyId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    DeficiencyKind? kind,
    $core.String? documentKind,
    $core.String? label,
    $core.String? documentId,
    $core.String? detail,
    $core.String? ownerId,
    $core.String? checklistCode,
    $core.int? checklistRevision,
    DeficiencyState? state,
    $0.Timestamp? dueBy,
    $0.Timestamp? raisedAt,
    $core.String? raisedBy,
    $core.String? resolvedByDocumentId,
    $0.Timestamp? resolvedAt,
    $core.String? resolvedBy,
    $core.String? waivedReason,
    $0.Timestamp? escalatedAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (deficiencyId != null) result.deficiencyId = deficiencyId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (kind != null) result.kind = kind;
    if (documentKind != null) result.documentKind = documentKind;
    if (label != null) result.label = label;
    if (documentId != null) result.documentId = documentId;
    if (detail != null) result.detail = detail;
    if (ownerId != null) result.ownerId = ownerId;
    if (checklistCode != null) result.checklistCode = checklistCode;
    if (checklistRevision != null) result.checklistRevision = checklistRevision;
    if (state != null) result.state = state;
    if (dueBy != null) result.dueBy = dueBy;
    if (raisedAt != null) result.raisedAt = raisedAt;
    if (raisedBy != null) result.raisedBy = raisedBy;
    if (resolvedByDocumentId != null)
      result.resolvedByDocumentId = resolvedByDocumentId;
    if (resolvedAt != null) result.resolvedAt = resolvedAt;
    if (resolvedBy != null) result.resolvedBy = resolvedBy;
    if (waivedReason != null) result.waivedReason = waivedReason;
    if (escalatedAt != null) result.escalatedAt = escalatedAt;
    if (version != null) result.version = version;
    return result;
  }

  Deficiency._();

  factory Deficiency.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Deficiency.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Deficiency',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deficiencyId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aE<DeficiencyKind>(5, _omitFieldNames ? '' : 'kind',
        enumValues: DeficiencyKind.values)
    ..aOS(6, _omitFieldNames ? '' : 'documentKind')
    ..aOS(7, _omitFieldNames ? '' : 'label')
    ..aOS(8, _omitFieldNames ? '' : 'documentId')
    ..aOS(9, _omitFieldNames ? '' : 'detail')
    ..aOS(10, _omitFieldNames ? '' : 'ownerId')
    ..aOS(11, _omitFieldNames ? '' : 'checklistCode')
    ..aI(12, _omitFieldNames ? '' : 'checklistRevision')
    ..aE<DeficiencyState>(13, _omitFieldNames ? '' : 'state',
        enumValues: DeficiencyState.values)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'dueBy',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'raisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'raisedBy')
    ..aOS(17, _omitFieldNames ? '' : 'resolvedByDocumentId')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'resolvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(19, _omitFieldNames ? '' : 'resolvedBy')
    ..aOS(20, _omitFieldNames ? '' : 'waivedReason')
    ..aOM<$0.Timestamp>(21, _omitFieldNames ? '' : 'escalatedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(22, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Deficiency clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Deficiency copyWith(void Function(Deficiency) updates) =>
      super.copyWith((message) => updates(message as Deficiency)) as Deficiency;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Deficiency create() => Deficiency._();
  @$core.override
  Deficiency createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Deficiency getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Deficiency>(create);
  static Deficiency? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deficiencyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deficiencyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeficiencyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeficiencyId() => $_clearField(1);

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
  DeficiencyKind get kind => $_getN(4);
  @$pb.TagNumber(5)
  set kind(DeficiencyKind value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearKind() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get documentKind => $_getSZ(5);
  @$pb.TagNumber(6)
  set documentKind($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDocumentKind() => $_has(5);
  @$pb.TagNumber(6)
  void clearDocumentKind() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get label => $_getSZ(6);
  @$pb.TagNumber(7)
  set label($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLabel() => $_has(6);
  @$pb.TagNumber(7)
  void clearLabel() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get documentId => $_getSZ(7);
  @$pb.TagNumber(8)
  set documentId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDocumentId() => $_has(7);
  @$pb.TagNumber(8)
  void clearDocumentId() => $_clearField(8);

  /// What is inadequate, for an incomplete document or a coding query. A
  /// question, never a rewrite.
  @$pb.TagNumber(9)
  $core.String get detail => $_getSZ(8);
  @$pb.TagNumber(9)
  set detail($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDetail() => $_has(8);
  @$pb.TagNumber(9)
  void clearDetail() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get ownerId => $_getSZ(9);
  @$pb.TagNumber(10)
  set ownerId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasOwnerId() => $_has(9);
  @$pb.TagNumber(10)
  void clearOwnerId() => $_clearField(10);

  /// The checklist version that raised it, pinned. Relaxing the checklist
  /// changes what happens next and nothing about what was already asked for.
  @$pb.TagNumber(11)
  $core.String get checklistCode => $_getSZ(10);
  @$pb.TagNumber(11)
  set checklistCode($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasChecklistCode() => $_has(10);
  @$pb.TagNumber(11)
  void clearChecklistCode() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get checklistRevision => $_getIZ(11);
  @$pb.TagNumber(12)
  set checklistRevision($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasChecklistRevision() => $_has(11);
  @$pb.TagNumber(12)
  void clearChecklistRevision() => $_clearField(12);

  @$pb.TagNumber(13)
  DeficiencyState get state => $_getN(12);
  @$pb.TagNumber(13)
  set state(DeficiencyState value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasState() => $_has(12);
  @$pb.TagNumber(13)
  void clearState() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get dueBy => $_getN(13);
  @$pb.TagNumber(14)
  set dueBy($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasDueBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearDueBy() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureDueBy() => $_ensure(13);

  @$pb.TagNumber(15)
  $0.Timestamp get raisedAt => $_getN(14);
  @$pb.TagNumber(15)
  set raisedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasRaisedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearRaisedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureRaisedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get raisedBy => $_getSZ(15);
  @$pb.TagNumber(16)
  set raisedBy($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasRaisedBy() => $_has(15);
  @$pb.TagNumber(16)
  void clearRaisedBy() => $_clearField(16);

  /// The document that answered it. For an inadequate document this is never
  /// the document complained about.
  @$pb.TagNumber(17)
  $core.String get resolvedByDocumentId => $_getSZ(16);
  @$pb.TagNumber(17)
  set resolvedByDocumentId($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasResolvedByDocumentId() => $_has(16);
  @$pb.TagNumber(17)
  void clearResolvedByDocumentId() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get resolvedAt => $_getN(17);
  @$pb.TagNumber(18)
  set resolvedAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasResolvedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearResolvedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureResolvedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $core.String get resolvedBy => $_getSZ(18);
  @$pb.TagNumber(19)
  set resolvedBy($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasResolvedBy() => $_has(18);
  @$pb.TagNumber(19)
  void clearResolvedBy() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get waivedReason => $_getSZ(19);
  @$pb.TagNumber(20)
  set waivedReason($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasWaivedReason() => $_has(19);
  @$pb.TagNumber(20)
  void clearWaivedReason() => $_clearField(20);

  @$pb.TagNumber(21)
  $0.Timestamp get escalatedAt => $_getN(20);
  @$pb.TagNumber(21)
  set escalatedAt($0.Timestamp value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasEscalatedAt() => $_has(20);
  @$pb.TagNumber(21)
  void clearEscalatedAt() => $_clearField(21);
  @$pb.TagNumber(21)
  $0.Timestamp ensureEscalatedAt() => $_ensure(20);

  @$pb.TagNumber(22)
  $fixnum.Int64 get version => $_getI64(21);
  @$pb.TagNumber(22)
  set version($fixnum.Int64 value) => $_setInt64(21, value);
  @$pb.TagNumber(22)
  $core.bool hasVersion() => $_has(21);
  @$pb.TagNumber(22)
  void clearVersion() => $_clearField(22);
}

/// One band of an aging report (SRS-MRD-002).
class AgeBucket extends $pb.GeneratedMessage {
  factory AgeBucket({
    $core.int? fromDays,
    $core.int? toDays,
    $core.String? label,
    $core.int? count,
    $core.int? overdue,
  }) {
    final result = create();
    if (fromDays != null) result.fromDays = fromDays;
    if (toDays != null) result.toDays = toDays;
    if (label != null) result.label = label;
    if (count != null) result.count = count;
    if (overdue != null) result.overdue = overdue;
    return result;
  }

  AgeBucket._();

  factory AgeBucket.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AgeBucket.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgeBucket',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'fromDays')
    ..aI(2, _omitFieldNames ? '' : 'toDays')
    ..aOS(3, _omitFieldNames ? '' : 'label')
    ..aI(4, _omitFieldNames ? '' : 'count')
    ..aI(5, _omitFieldNames ? '' : 'overdue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgeBucket clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgeBucket copyWith(void Function(AgeBucket) updates) =>
      super.copyWith((message) => updates(message as AgeBucket)) as AgeBucket;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgeBucket create() => AgeBucket._();
  @$core.override
  AgeBucket createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AgeBucket getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgeBucket>(create);
  static AgeBucket? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get fromDays => $_getIZ(0);
  @$pb.TagNumber(1)
  set fromDays($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromDays() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromDays() => $_clearField(1);

  /// Zero is open-ended.
  @$pb.TagNumber(2)
  $core.int get toDays => $_getIZ(1);
  @$pb.TagNumber(2)
  set toDays($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToDays() => $_has(1);
  @$pb.TagNumber(2)
  void clearToDays() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get label => $_getSZ(2);
  @$pb.TagNumber(3)
  set label($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLabel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLabel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get count => $_getIZ(3);
  @$pb.TagNumber(4)
  set count($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearCount() => $_clearField(4);

  /// Past its own date, which is not the same as being in the oldest band.
  @$pb.TagNumber(5)
  $core.int get overdue => $_getIZ(4);
  @$pb.TagNumber(5)
  set overdue($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOverdue() => $_has(4);
  @$pb.TagNumber(5)
  void clearOverdue() => $_clearField(5);
}

/// How many charts are complete (SRS-MRD-002).
class CompletionSummary extends $pb.GeneratedMessage {
  factory CompletionSummary({
    $core.int? encounters,
    $core.int? complete,
    $core.int? incompletable,
    $core.int? open,
    $core.int? overdue,
    $core.int? resolved,
    $core.int? waived,
    $core.int? completePermille,
    $core.bool? unanswerable,
  }) {
    final result = create();
    if (encounters != null) result.encounters = encounters;
    if (complete != null) result.complete = complete;
    if (incompletable != null) result.incompletable = incompletable;
    if (open != null) result.open = open;
    if (overdue != null) result.overdue = overdue;
    if (resolved != null) result.resolved = resolved;
    if (waived != null) result.waived = waived;
    if (completePermille != null) result.completePermille = completePermille;
    if (unanswerable != null) result.unanswerable = unanswerable;
    return result;
  }

  CompletionSummary._();

  factory CompletionSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompletionSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompletionSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'encounters')
    ..aI(2, _omitFieldNames ? '' : 'complete')
    ..aI(3, _omitFieldNames ? '' : 'incompletable')
    ..aI(4, _omitFieldNames ? '' : 'open')
    ..aI(5, _omitFieldNames ? '' : 'overdue')
    ..aI(6, _omitFieldNames ? '' : 'resolved')
    ..aI(7, _omitFieldNames ? '' : 'waived')
    ..aI(8, _omitFieldNames ? '' : 'completePermille')
    ..aOB(9, _omitFieldNames ? '' : 'unanswerable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompletionSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompletionSummary copyWith(void Function(CompletionSummary) updates) =>
      super.copyWith((message) => updates(message as CompletionSummary))
          as CompletionSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompletionSummary create() => CompletionSummary._();
  @$core.override
  CompletionSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompletionSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompletionSummary>(create);
  static CompletionSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get encounters => $_getIZ(0);
  @$pb.TagNumber(1)
  set encounters($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounters() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounters() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get complete => $_getIZ(1);
  @$pb.TagNumber(2)
  set complete($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasComplete() => $_has(1);
  @$pb.TagNumber(2)
  void clearComplete() => $_clearField(2);

  /// Encounters with a waiver on them. Never counted as complete: the
  /// document never arrived.
  @$pb.TagNumber(3)
  $core.int get incompletable => $_getIZ(2);
  @$pb.TagNumber(3)
  set incompletable($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIncompletable() => $_has(2);
  @$pb.TagNumber(3)
  void clearIncompletable() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get open => $_getIZ(3);
  @$pb.TagNumber(4)
  set open($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOpen() => $_has(3);
  @$pb.TagNumber(4)
  void clearOpen() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get overdue => $_getIZ(4);
  @$pb.TagNumber(5)
  set overdue($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOverdue() => $_has(4);
  @$pb.TagNumber(5)
  void clearOverdue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get resolved => $_getIZ(5);
  @$pb.TagNumber(6)
  set resolved($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasResolved() => $_has(5);
  @$pb.TagNumber(6)
  void clearResolved() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get waived => $_getIZ(6);
  @$pb.TagNumber(7)
  set waived($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWaived() => $_has(6);
  @$pb.TagNumber(7)
  void clearWaived() => $_clearField(7);

  /// Parts per thousand, so the figure is exact rather than a rounded float.
  @$pb.TagNumber(8)
  $core.int get completePermille => $_getIZ(7);
  @$pb.TagNumber(8)
  set completePermille($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCompletePermille() => $_has(7);
  @$pb.TagNumber(8)
  void clearCompletePermille() => $_clearField(8);

  /// True when there were no encounters to judge. "No charts to complete" and
  /// "no charts completed" are different facts.
  @$pb.TagNumber(9)
  $core.bool get unanswerable => $_getBF(8);
  @$pb.TagNumber(9)
  set unanswerable($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUnanswerable() => $_has(8);
  @$pb.TagNumber(9)
  void clearUnanswerable() => $_clearField(9);
}

/// One code on a coded episode (SRS-MRD-003).
class AssignedCode extends $pb.GeneratedMessage {
  factory AssignedCode({
    $core.String? system,
    $core.String? version,
    $core.String? code,
    $core.String? display,
    CodeRole? role,
    $core.int? sequence,
    PresentOnAdmission? presentOnAdmission,
    $core.String? sourceDocumentId,
  }) {
    final result = create();
    if (system != null) result.system = system;
    if (version != null) result.version = version;
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (role != null) result.role = role;
    if (sequence != null) result.sequence = sequence;
    if (presentOnAdmission != null)
      result.presentOnAdmission = presentOnAdmission;
    if (sourceDocumentId != null) result.sourceDocumentId = sourceDocumentId;
    return result;
  }

  AssignedCode._();

  factory AssignedCode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssignedCode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssignedCode',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'system')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'display')
    ..aE<CodeRole>(5, _omitFieldNames ? '' : 'role',
        enumValues: CodeRole.values)
    ..aI(6, _omitFieldNames ? '' : 'sequence')
    ..aE<PresentOnAdmission>(7, _omitFieldNames ? '' : 'presentOnAdmission',
        enumValues: PresentOnAdmission.values)
    ..aOS(8, _omitFieldNames ? '' : 'sourceDocumentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignedCode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignedCode copyWith(void Function(AssignedCode) updates) =>
      super.copyWith((message) => updates(message as AssignedCode))
          as AssignedCode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignedCode create() => AssignedCode._();
  @$core.override
  AssignedCode createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssignedCode getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssignedCode>(create);
  static AssignedCode? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get system => $_getSZ(0);
  @$pb.TagNumber(1)
  set system($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSystem() => $_has(0);
  @$pb.TagNumber(1)
  void clearSystem() => $_clearField(1);

  /// The edition. ICD-10 J18.9 and ICD-11 CA40.0 are both pneumonia and
  /// neither is the other.
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

  /// The terminology's own label, not a coder's words about the patient.
  @$pb.TagNumber(4)
  $core.String get display => $_getSZ(3);
  @$pb.TagNumber(4)
  set display($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisplay() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplay() => $_clearField(4);

  @$pb.TagNumber(5)
  CodeRole get role => $_getN(4);
  @$pb.TagNumber(5)
  set role(CodeRole value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRole() => $_has(4);
  @$pb.TagNumber(5)
  void clearRole() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get sequence => $_getIZ(5);
  @$pb.TagNumber(6)
  set sequence($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSequence() => $_has(5);
  @$pb.TagNumber(6)
  void clearSequence() => $_clearField(6);

  @$pb.TagNumber(7)
  PresentOnAdmission get presentOnAdmission => $_getN(6);
  @$pb.TagNumber(7)
  set presentOnAdmission(PresentOnAdmission value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPresentOnAdmission() => $_has(6);
  @$pb.TagNumber(7)
  void clearPresentOnAdmission() => $_clearField(7);

  /// Where the code was read from. Half of the provenance SRS-MRD-003 asks
  /// for; the revision history is the other half.
  @$pb.TagNumber(8)
  $core.String get sourceDocumentId => $_getSZ(7);
  @$pb.TagNumber(8)
  set sourceDocumentId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSourceDocumentId() => $_has(7);
  @$pb.TagNumber(8)
  void clearSourceDocumentId() => $_clearField(8);
}

/// One pass of coding, kept for ever (SRS-MRD-003).
class CodingRevision extends $pb.GeneratedMessage {
  factory CodingRevision({
    $core.int? revision,
    $core.Iterable<AssignedCode>? codes,
    $core.String? reason,
    $core.String? codedBy,
    $0.Timestamp? codedAt,
    CodingState? state,
    $core.String? reviewedBy,
    $0.Timestamp? reviewedAt,
  }) {
    final result = create();
    if (revision != null) result.revision = revision;
    if (codes != null) result.codes.addAll(codes);
    if (reason != null) result.reason = reason;
    if (codedBy != null) result.codedBy = codedBy;
    if (codedAt != null) result.codedAt = codedAt;
    if (state != null) result.state = state;
    if (reviewedBy != null) result.reviewedBy = reviewedBy;
    if (reviewedAt != null) result.reviewedAt = reviewedAt;
    return result;
  }

  CodingRevision._();

  factory CodingRevision.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CodingRevision.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CodingRevision',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'revision')
    ..pPM<AssignedCode>(2, _omitFieldNames ? '' : 'codes',
        subBuilder: AssignedCode.create)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOS(4, _omitFieldNames ? '' : 'codedBy')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'codedAt',
        subBuilder: $0.Timestamp.create)
    ..aE<CodingState>(6, _omitFieldNames ? '' : 'state',
        enumValues: CodingState.values)
    ..aOS(7, _omitFieldNames ? '' : 'reviewedBy')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'reviewedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CodingRevision clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CodingRevision copyWith(void Function(CodingRevision) updates) =>
      super.copyWith((message) => updates(message as CodingRevision))
          as CodingRevision;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CodingRevision create() => CodingRevision._();
  @$core.override
  CodingRevision createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CodingRevision getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CodingRevision>(create);
  static CodingRevision? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get revision => $_getIZ(0);
  @$pb.TagNumber(1)
  set revision($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRevision() => $_has(0);
  @$pb.TagNumber(1)
  void clearRevision() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<AssignedCode> get codes => $_getList(1);

  /// Required from the second revision on.
  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get codedBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set codedBy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCodedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearCodedBy() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get codedAt => $_getN(4);
  @$pb.TagNumber(5)
  set codedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCodedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCodedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureCodedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  CodingState get state => $_getN(5);
  @$pb.TagNumber(6)
  set state(CodingState value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasState() => $_has(5);
  @$pb.TagNumber(6)
  void clearState() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get reviewedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set reviewedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReviewedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearReviewedBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get reviewedAt => $_getN(7);
  @$pb.TagNumber(8)
  set reviewedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasReviewedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearReviewedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureReviewedAt() => $_ensure(7);
}

/// An encounter's coding with its whole history (SRS-MRD-003).
class CodedEpisode extends $pb.GeneratedMessage {
  factory CodedEpisode({
    $core.String? episodeId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    $core.Iterable<CodingRevision>? revisions,
    CodingState? state,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (revisions != null) result.revisions.addAll(revisions);
    if (state != null) result.state = state;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  CodedEpisode._();

  factory CodedEpisode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CodedEpisode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CodedEpisode',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..pPM<CodingRevision>(5, _omitFieldNames ? '' : 'revisions',
        subBuilder: CodingRevision.create)
    ..aE<CodingState>(6, _omitFieldNames ? '' : 'state',
        enumValues: CodingState.values)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(9, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CodedEpisode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CodedEpisode copyWith(void Function(CodedEpisode) updates) =>
      super.copyWith((message) => updates(message as CodedEpisode))
          as CodedEpisode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CodedEpisode create() => CodedEpisode._();
  @$core.override
  CodedEpisode createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CodedEpisode getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CodedEpisode>(create);
  static CodedEpisode? _defaultInstance;

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

  /// Oldest first. Append-only: a correction adds a revision and never edits
  /// the one that was billed on.
  @$pb.TagNumber(5)
  $pb.PbList<CodingRevision> get revisions => $_getList(4);

  @$pb.TagNumber(6)
  CodingState get state => $_getN(5);
  @$pb.TagNumber(6)
  set state(CodingState value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasState() => $_has(5);
  @$pb.TagNumber(6)
  void clearState() => $_clearField(6);

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
  $fixnum.Int64 get version => $_getI64(8);
  @$pb.TagNumber(9)
  set version($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasVersion() => $_has(8);
  @$pb.TagNumber(9)
  void clearVersion() => $_clearField(9);
}

/// What changed between two codings (SRS-MRD-003).
class CodingChange extends $pb.GeneratedMessage {
  factory CodingChange({
    $core.String? system,
    $core.String? code,
    CodeRole? was,
    CodeRole? now,
  }) {
    final result = create();
    if (system != null) result.system = system;
    if (code != null) result.code = code;
    if (was != null) result.was = was;
    if (now != null) result.now = now;
    return result;
  }

  CodingChange._();

  factory CodingChange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CodingChange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CodingChange',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'system')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aE<CodeRole>(3, _omitFieldNames ? '' : 'was', enumValues: CodeRole.values)
    ..aE<CodeRole>(4, _omitFieldNames ? '' : 'now', enumValues: CodeRole.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CodingChange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CodingChange copyWith(void Function(CodingChange) updates) =>
      super.copyWith((message) => updates(message as CodingChange))
          as CodingChange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CodingChange create() => CodingChange._();
  @$core.override
  CodingChange createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CodingChange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CodingChange>(create);
  static CodingChange? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get system => $_getSZ(0);
  @$pb.TagNumber(1)
  set system($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSystem() => $_has(0);
  @$pb.TagNumber(1)
  void clearSystem() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  /// Unspecified on one side means the code was added or removed.
  @$pb.TagNumber(3)
  CodeRole get was => $_getN(2);
  @$pb.TagNumber(3)
  set was(CodeRole value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasWas() => $_has(2);
  @$pb.TagNumber(3)
  void clearWas() => $_clearField(3);

  @$pb.TagNumber(4)
  CodeRole get now => $_getN(3);
  @$pb.TagNumber(4)
  set now(CodeRole value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasNow() => $_has(3);
  @$pb.TagNumber(4)
  void clearNow() => $_clearField(4);
}

/// The standing on which a record leaves the hospital (SRS-MRD-004).
class Authorisation extends $pb.GeneratedMessage {
  factory Authorisation({
    AuthorityKind? kind,
    $core.String? reference,
    $core.String? signedBy,
    $0.Timestamp? signedAt,
    $0.Timestamp? expiresAt,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (reference != null) result.reference = reference;
    if (signedBy != null) result.signedBy = signedBy;
    if (signedAt != null) result.signedAt = signedAt;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  Authorisation._();

  factory Authorisation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Authorisation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Authorisation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aE<AuthorityKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: AuthorityKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aOS(3, _omitFieldNames ? '' : 'signedBy')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'signedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Authorisation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Authorisation copyWith(void Function(Authorisation) updates) =>
      super.copyWith((message) => updates(message as Authorisation))
          as Authorisation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Authorisation create() => Authorisation._();
  @$core.override
  Authorisation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Authorisation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Authorisation>(create);
  static Authorisation? _defaultInstance;

  @$pb.TagNumber(1)
  AuthorityKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(AuthorityKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  /// The consent form, the order number, the statute. A release whose
  /// authority cannot be produced later is one nobody can defend.
  @$pb.TagNumber(2)
  $core.String get reference => $_getSZ(1);
  @$pb.TagNumber(2)
  set reference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearReference() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get signedBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set signedBy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSignedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearSignedBy() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get signedAt => $_getN(3);
  @$pb.TagNumber(4)
  set signedAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSignedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearSignedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureSignedAt() => $_ensure(3);

  /// Unset never expires, which is right for a court order and wrong for a
  /// consent form. The contract does not guess which.
  @$pb.TagNumber(5)
  $0.Timestamp get expiresAt => $_getN(4);
  @$pb.TagNumber(5)
  set expiresAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasExpiresAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiresAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureExpiresAt() => $_ensure(4);
}

/// Who is receiving it (SRS-MRD-004).
class Recipient extends $pb.GeneratedMessage {
  factory Recipient({
    RecipientKind? kind,
    $core.String? name,
    $core.String? reference,
    $core.String? deliveryMethod,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (name != null) result.name = name;
    if (reference != null) result.reference = reference;
    if (deliveryMethod != null) result.deliveryMethod = deliveryMethod;
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
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aE<RecipientKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: RecipientKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'reference')
    ..aOS(4, _omitFieldNames ? '' : 'deliveryMethod')
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
  RecipientKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(RecipientKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// Three hospitals are called St Mary's.
  @$pb.TagNumber(3)
  $core.String get reference => $_getSZ(2);
  @$pb.TagNumber(3)
  set reference($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReference() => $_has(2);
  @$pb.TagNumber(3)
  void clearReference() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get deliveryMethod => $_getSZ(3);
  @$pb.TagNumber(4)
  set deliveryMethod($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDeliveryMethod() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeliveryMethod() => $_clearField(4);
}

/// What a release covers (SRS-MRD-004).
class ReleaseScope extends $pb.GeneratedMessage {
  factory ReleaseScope({
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.Iterable<$core.String>? recordClasses,
    $core.Iterable<$core.String>? documentKinds,
    $core.Iterable<$core.String>? encounterIds,
    $core.bool? wholeRecord,
    $core.bool? includeRestricted,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (recordClasses != null) result.recordClasses.addAll(recordClasses);
    if (documentKinds != null) result.documentKinds.addAll(documentKinds);
    if (encounterIds != null) result.encounterIds.addAll(encounterIds);
    if (wholeRecord != null) result.wholeRecord = wholeRecord;
    if (includeRestricted != null) result.includeRestricted = includeRestricted;
    return result;
  }

  ReleaseScope._();

  factory ReleaseScope.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseScope.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseScope',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..pPS(3, _omitFieldNames ? '' : 'recordClasses')
    ..pPS(4, _omitFieldNames ? '' : 'documentKinds')
    ..pPS(5, _omitFieldNames ? '' : 'encounterIds')
    ..aOB(6, _omitFieldNames ? '' : 'wholeRecord')
    ..aOB(7, _omitFieldNames ? '' : 'includeRestricted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseScope clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseScope copyWith(void Function(ReleaseScope) updates) =>
      super.copyWith((message) => updates(message as ReleaseScope))
          as ReleaseScope;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseScope create() => ReleaseScope._();
  @$core.override
  ReleaseScope createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseScope getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseScope>(create);
  static ReleaseScope? _defaultInstance;

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
  $pb.PbList<$core.String> get recordClasses => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get documentKinds => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get encounterIds => $_getList(4);

  /// Everything ever recorded about this person. Has to be asked for rather
  /// than fallen into.
  @$pb.TagNumber(6)
  $core.bool get wholeRecord => $_getBF(5);
  @$pb.TagNumber(6)
  set wholeRecord($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWholeRecord() => $_has(5);
  @$pb.TagNumber(6)
  void clearWholeRecord() => $_clearField(6);

  /// Restricted material is held back unless this says otherwise.
  @$pb.TagNumber(7)
  $core.bool get includeRestricted => $_getBF(6);
  @$pb.TagNumber(7)
  set includeRestricted($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIncludeRestricted() => $_has(6);
  @$pb.TagNumber(7)
  void clearIncludeRestricted() => $_clearField(7);
}

/// One document in a package (SRS-MRD-004).
class ReleaseItem extends $pb.GeneratedMessage {
  factory ReleaseItem({
    $core.String? documentId,
    $core.String? encounterId,
    $core.String? kind,
    $core.String? recordClass,
    $0.Timestamp? occurredAt,
    $core.bool? restricted,
    $core.int? pages,
  }) {
    final result = create();
    if (documentId != null) result.documentId = documentId;
    if (encounterId != null) result.encounterId = encounterId;
    if (kind != null) result.kind = kind;
    if (recordClass != null) result.recordClass = recordClass;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (restricted != null) result.restricted = restricted;
    if (pages != null) result.pages = pages;
    return result;
  }

  ReleaseItem._();

  factory ReleaseItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'documentId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'kind')
    ..aOS(4, _omitFieldNames ? '' : 'recordClass')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(6, _omitFieldNames ? '' : 'restricted')
    ..aI(7, _omitFieldNames ? '' : 'pages')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseItem copyWith(void Function(ReleaseItem) updates) =>
      super.copyWith((message) => updates(message as ReleaseItem))
          as ReleaseItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseItem create() => ReleaseItem._();
  @$core.override
  ReleaseItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseItem>(create);
  static ReleaseItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get documentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set documentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get kind => $_getSZ(2);
  @$pb.TagNumber(3)
  set kind($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get recordClass => $_getSZ(3);
  @$pb.TagNumber(4)
  set recordClass($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRecordClass() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecordClass() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get occurredAt => $_getN(4);
  @$pb.TagNumber(5)
  set occurredAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasOccurredAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearOccurredAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureOccurredAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get restricted => $_getBF(5);
  @$pb.TagNumber(6)
  set restricted($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRestricted() => $_has(5);
  @$pb.TagNumber(6)
  void clearRestricted() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get pages => $_getIZ(6);
  @$pb.TagNumber(7)
  set pages($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPages() => $_has(6);
  @$pb.TagNumber(7)
  void clearPages() => $_clearField(7);
}

/// Exactly what went out (SRS-MRD-004).
class ReleasePackage extends $pb.GeneratedMessage {
  factory ReleasePackage({
    $core.Iterable<ReleaseItem>? items,
    $core.String? contentHash,
    $core.int? pages,
    $0.Timestamp? assembledAt,
    $core.String? assembledBy,
    $0.Timestamp? releasedAt,
    $core.String? releasedBy,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (contentHash != null) result.contentHash = contentHash;
    if (pages != null) result.pages = pages;
    if (assembledAt != null) result.assembledAt = assembledAt;
    if (assembledBy != null) result.assembledBy = assembledBy;
    if (releasedAt != null) result.releasedAt = releasedAt;
    if (releasedBy != null) result.releasedBy = releasedBy;
    return result;
  }

  ReleasePackage._();

  factory ReleasePackage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleasePackage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleasePackage',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..pPM<ReleaseItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: ReleaseItem.create)
    ..aOS(2, _omitFieldNames ? '' : 'contentHash')
    ..aI(3, _omitFieldNames ? '' : 'pages')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'assembledAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'assembledBy')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'releasedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'releasedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleasePackage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleasePackage copyWith(void Function(ReleasePackage) updates) =>
      super.copyWith((message) => updates(message as ReleasePackage))
          as ReleasePackage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleasePackage create() => ReleasePackage._();
  @$core.override
  ReleasePackage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleasePackage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleasePackage>(create);
  static ReleasePackage? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ReleaseItem> get items => $_getList(0);

  /// Over the manifest, so "what did we send" has one answer a year later.
  @$pb.TagNumber(2)
  $core.String get contentHash => $_getSZ(1);
  @$pb.TagNumber(2)
  set contentHash($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContentHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearContentHash() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pages => $_getIZ(2);
  @$pb.TagNumber(3)
  set pages($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPages() => $_has(2);
  @$pb.TagNumber(3)
  void clearPages() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get assembledAt => $_getN(3);
  @$pb.TagNumber(4)
  set assembledAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAssembledAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearAssembledAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureAssembledAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get assembledBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set assembledBy($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAssembledBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearAssembledBy() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get releasedAt => $_getN(5);
  @$pb.TagNumber(6)
  set releasedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasReleasedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearReleasedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureReleasedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get releasedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set releasedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReleasedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearReleasedBy() => $_clearField(7);
}

/// A request for a copy of a record (SRS-MRD-004).
class ReleaseRequest extends $pb.GeneratedMessage {
  factory ReleaseRequest({
    $core.String? releaseId,
    $core.String? reference,
    $core.String? patientId,
    $core.String? purpose,
    Authorisation? authorisation,
    Recipient? recipient,
    ReleaseScope? scope,
    ReleaseState? state,
    $core.String? refusalReason,
    $0.Timestamp? requestedAt,
    $core.String? requestedBy,
    $0.Timestamp? approvedAt,
    $core.String? approvedBy,
    ReleasePackage? package,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (releaseId != null) result.releaseId = releaseId;
    if (reference != null) result.reference = reference;
    if (patientId != null) result.patientId = patientId;
    if (purpose != null) result.purpose = purpose;
    if (authorisation != null) result.authorisation = authorisation;
    if (recipient != null) result.recipient = recipient;
    if (scope != null) result.scope = scope;
    if (state != null) result.state = state;
    if (refusalReason != null) result.refusalReason = refusalReason;
    if (requestedAt != null) result.requestedAt = requestedAt;
    if (requestedBy != null) result.requestedBy = requestedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (package != null) result.package = package;
    if (version != null) result.version = version;
    return result;
  }

  ReleaseRequest._();

  factory ReleaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'releaseId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'purpose')
    ..aOM<Authorisation>(5, _omitFieldNames ? '' : 'authorisation',
        subBuilder: Authorisation.create)
    ..aOM<Recipient>(6, _omitFieldNames ? '' : 'recipient',
        subBuilder: Recipient.create)
    ..aOM<ReleaseScope>(7, _omitFieldNames ? '' : 'scope',
        subBuilder: ReleaseScope.create)
    ..aE<ReleaseState>(8, _omitFieldNames ? '' : 'state',
        enumValues: ReleaseState.values)
    ..aOS(9, _omitFieldNames ? '' : 'refusalReason')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'requestedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'requestedBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'approvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<ReleasePackage>(14, _omitFieldNames ? '' : 'package',
        subBuilder: ReleasePackage.create)
    ..aInt64(15, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseRequest copyWith(void Function(ReleaseRequest) updates) =>
      super.copyWith((message) => updates(message as ReleaseRequest))
          as ReleaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseRequest create() => ReleaseRequest._();
  @$core.override
  ReleaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseRequest>(create);
  static ReleaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get releaseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set releaseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReleaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReleaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reference => $_getSZ(1);
  @$pb.TagNumber(2)
  set reference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearReference() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get patientId => $_getSZ(2);
  @$pb.TagNumber(3)
  set patientId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPatientId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatientId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get purpose => $_getSZ(3);
  @$pb.TagNumber(4)
  set purpose($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPurpose() => $_has(3);
  @$pb.TagNumber(4)
  void clearPurpose() => $_clearField(4);

  @$pb.TagNumber(5)
  Authorisation get authorisation => $_getN(4);
  @$pb.TagNumber(5)
  set authorisation(Authorisation value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAuthorisation() => $_has(4);
  @$pb.TagNumber(5)
  void clearAuthorisation() => $_clearField(5);
  @$pb.TagNumber(5)
  Authorisation ensureAuthorisation() => $_ensure(4);

  @$pb.TagNumber(6)
  Recipient get recipient => $_getN(5);
  @$pb.TagNumber(6)
  set recipient(Recipient value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRecipient() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecipient() => $_clearField(6);
  @$pb.TagNumber(6)
  Recipient ensureRecipient() => $_ensure(5);

  @$pb.TagNumber(7)
  ReleaseScope get scope => $_getN(6);
  @$pb.TagNumber(7)
  set scope(ReleaseScope value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasScope() => $_has(6);
  @$pb.TagNumber(7)
  void clearScope() => $_clearField(7);
  @$pb.TagNumber(7)
  ReleaseScope ensureScope() => $_ensure(6);

  @$pb.TagNumber(8)
  ReleaseState get state => $_getN(7);
  @$pb.TagNumber(8)
  set state(ReleaseState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasState() => $_has(7);
  @$pb.TagNumber(8)
  void clearState() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get refusalReason => $_getSZ(8);
  @$pb.TagNumber(9)
  set refusalReason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRefusalReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearRefusalReason() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get requestedAt => $_getN(9);
  @$pb.TagNumber(10)
  set requestedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasRequestedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearRequestedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureRequestedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get requestedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set requestedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRequestedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearRequestedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get approvedAt => $_getN(11);
  @$pb.TagNumber(12)
  set approvedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasApprovedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearApprovedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureApprovedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get approvedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set approvedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasApprovedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearApprovedBy() => $_clearField(13);

  @$pb.TagNumber(14)
  ReleasePackage get package => $_getN(13);
  @$pb.TagNumber(14)
  set package(ReleasePackage value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasPackage() => $_has(13);
  @$pb.TagNumber(14)
  void clearPackage() => $_clearField(14);
  @$pb.TagNumber(14)
  ReleasePackage ensurePackage() => $_ensure(13);

  @$pb.TagNumber(15)
  $fixnum.Int64 get version => $_getI64(14);
  @$pb.TagNumber(15)
  set version($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasVersion() => $_has(14);
  @$pb.TagNumber(15)
  void clearVersion() => $_clearField(15);
}

/// One entry in the accounting of disclosures (SRS-MRD-010).
class Disclosure extends $pb.GeneratedMessage {
  factory Disclosure({
    $core.String? disclosureId,
    $core.String? patientId,
    DisclosureKind? kind,
    $core.String? releaseId,
    $core.String? actorId,
    $core.String? purpose,
    $core.String? scopeSummary,
    $core.String? recipientReference,
    $core.String? recipientName,
    $core.int? items,
    $core.int? pages,
    $0.Timestamp? occurredAt,
  }) {
    final result = create();
    if (disclosureId != null) result.disclosureId = disclosureId;
    if (patientId != null) result.patientId = patientId;
    if (kind != null) result.kind = kind;
    if (releaseId != null) result.releaseId = releaseId;
    if (actorId != null) result.actorId = actorId;
    if (purpose != null) result.purpose = purpose;
    if (scopeSummary != null) result.scopeSummary = scopeSummary;
    if (recipientReference != null)
      result.recipientReference = recipientReference;
    if (recipientName != null) result.recipientName = recipientName;
    if (items != null) result.items = items;
    if (pages != null) result.pages = pages;
    if (occurredAt != null) result.occurredAt = occurredAt;
    return result;
  }

  Disclosure._();

  factory Disclosure.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Disclosure.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Disclosure',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'disclosureId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aE<DisclosureKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: DisclosureKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'releaseId')
    ..aOS(5, _omitFieldNames ? '' : 'actorId')
    ..aOS(6, _omitFieldNames ? '' : 'purpose')
    ..aOS(7, _omitFieldNames ? '' : 'scopeSummary')
    ..aOS(8, _omitFieldNames ? '' : 'recipientReference')
    ..aOS(9, _omitFieldNames ? '' : 'recipientName')
    ..aI(10, _omitFieldNames ? '' : 'items')
    ..aI(11, _omitFieldNames ? '' : 'pages')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Disclosure clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Disclosure copyWith(void Function(Disclosure) updates) =>
      super.copyWith((message) => updates(message as Disclosure)) as Disclosure;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Disclosure create() => Disclosure._();
  @$core.override
  Disclosure createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Disclosure getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Disclosure>(create);
  static Disclosure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get disclosureId => $_getSZ(0);
  @$pb.TagNumber(1)
  set disclosureId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDisclosureId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisclosureId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  DisclosureKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(DisclosureKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get releaseId => $_getSZ(3);
  @$pb.TagNumber(4)
  set releaseId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReleaseId() => $_has(3);
  @$pb.TagNumber(4)
  void clearReleaseId() => $_clearField(4);

  /// The four things SRS-MRD-010 names. Every one required.
  @$pb.TagNumber(5)
  $core.String get actorId => $_getSZ(4);
  @$pb.TagNumber(5)
  set actorId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasActorId() => $_has(4);
  @$pb.TagNumber(5)
  void clearActorId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get purpose => $_getSZ(5);
  @$pb.TagNumber(6)
  set purpose($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPurpose() => $_has(5);
  @$pb.TagNumber(6)
  void clearPurpose() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get scopeSummary => $_getSZ(6);
  @$pb.TagNumber(7)
  set scopeSummary($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasScopeSummary() => $_has(6);
  @$pb.TagNumber(7)
  void clearScopeSummary() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get recipientReference => $_getSZ(7);
  @$pb.TagNumber(8)
  set recipientReference($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRecipientReference() => $_has(7);
  @$pb.TagNumber(8)
  void clearRecipientReference() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get recipientName => $_getSZ(8);
  @$pb.TagNumber(9)
  set recipientName($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRecipientName() => $_has(8);
  @$pb.TagNumber(9)
  void clearRecipientName() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get items => $_getIZ(9);
  @$pb.TagNumber(10)
  set items($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasItems() => $_has(9);
  @$pb.TagNumber(10)
  void clearItems() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get pages => $_getIZ(10);
  @$pb.TagNumber(11)
  set pages($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPages() => $_has(10);
  @$pb.TagNumber(11)
  void clearPages() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get occurredAt => $_getN(11);
  @$pb.TagNumber(12)
  set occurredAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasOccurredAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearOccurredAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureOccurredAt() => $_ensure(11);
}

/// How long a class of record is kept, and under what authority
/// (SRS-MRD-009).
class RetentionRule extends $pb.GeneratedMessage {
  factory RetentionRule({
    $core.String? ruleId,
    $core.String? code,
    $core.String? name,
    $core.int? revision,
    $core.String? recordClass,
    $core.String? jurisdiction,
    RetentionAnchor? anchor,
    $core.int? retainYears,
    DispositionKind? disposition,
    $core.String? authority,
    $core.bool? approved,
    $core.String? approvedBy,
    $0.Timestamp? approvedAt,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? supersededAt,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
  }) {
    final result = create();
    if (ruleId != null) result.ruleId = ruleId;
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (revision != null) result.revision = revision;
    if (recordClass != null) result.recordClass = recordClass;
    if (jurisdiction != null) result.jurisdiction = jurisdiction;
    if (anchor != null) result.anchor = anchor;
    if (retainYears != null) result.retainYears = retainYears;
    if (disposition != null) result.disposition = disposition;
    if (authority != null) result.authority = authority;
    if (approved != null) result.approved = approved;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (supersededAt != null) result.supersededAt = supersededAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    return result;
  }

  RetentionRule._();

  factory RetentionRule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetentionRule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetentionRule',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ruleId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aI(4, _omitFieldNames ? '' : 'revision')
    ..aOS(5, _omitFieldNames ? '' : 'recordClass')
    ..aOS(6, _omitFieldNames ? '' : 'jurisdiction')
    ..aE<RetentionAnchor>(7, _omitFieldNames ? '' : 'anchor',
        enumValues: RetentionAnchor.values)
    ..aI(8, _omitFieldNames ? '' : 'retainYears')
    ..aE<DispositionKind>(9, _omitFieldNames ? '' : 'disposition',
        enumValues: DispositionKind.values)
    ..aOS(10, _omitFieldNames ? '' : 'authority')
    ..aOB(11, _omitFieldNames ? '' : 'approved')
    ..aOS(12, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'approvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'supersededAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(17, _omitFieldNames ? '' : 'createdBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetentionRule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetentionRule copyWith(void Function(RetentionRule) updates) =>
      super.copyWith((message) => updates(message as RetentionRule))
          as RetentionRule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetentionRule create() => RetentionRule._();
  @$core.override
  RetentionRule createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetentionRule getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetentionRule>(create);
  static RetentionRule? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ruleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ruleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRuleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRuleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get revision => $_getIZ(3);
  @$pb.TagNumber(4)
  set revision($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevision() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get recordClass => $_getSZ(4);
  @$pb.TagNumber(5)
  set recordClass($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRecordClass() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecordClass() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get jurisdiction => $_getSZ(5);
  @$pb.TagNumber(6)
  set jurisdiction($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasJurisdiction() => $_has(5);
  @$pb.TagNumber(6)
  void clearJurisdiction() => $_clearField(6);

  @$pb.TagNumber(7)
  RetentionAnchor get anchor => $_getN(6);
  @$pb.TagNumber(7)
  set anchor(RetentionAnchor value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAnchor() => $_has(6);
  @$pb.TagNumber(7)
  void clearAnchor() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get retainYears => $_getIZ(7);
  @$pb.TagNumber(8)
  set retainYears($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRetainYears() => $_has(7);
  @$pb.TagNumber(8)
  void clearRetainYears() => $_clearField(8);

  @$pb.TagNumber(9)
  DispositionKind get disposition => $_getN(8);
  @$pb.TagNumber(9)
  set disposition(DispositionKind value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasDisposition() => $_has(8);
  @$pb.TagNumber(9)
  void clearDisposition() => $_clearField(9);

  /// The statute or policy. A destruction nobody can point to a rule for is
  /// one nobody can defend.
  @$pb.TagNumber(10)
  $core.String get authority => $_getSZ(9);
  @$pb.TagNumber(10)
  set authority($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAuthority() => $_has(9);
  @$pb.TagNumber(10)
  void clearAuthority() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get approved => $_getBF(10);
  @$pb.TagNumber(11)
  set approved($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasApproved() => $_has(10);
  @$pb.TagNumber(11)
  void clearApproved() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get approvedBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set approvedBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasApprovedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearApprovedBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get approvedAt => $_getN(12);
  @$pb.TagNumber(13)
  set approvedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasApprovedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearApprovedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureApprovedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Timestamp get effectiveFrom => $_getN(13);
  @$pb.TagNumber(14)
  set effectiveFrom($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasEffectiveFrom() => $_has(13);
  @$pb.TagNumber(14)
  void clearEffectiveFrom() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(13);

  @$pb.TagNumber(15)
  $0.Timestamp get supersededAt => $_getN(14);
  @$pb.TagNumber(15)
  set supersededAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasSupersededAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearSupersededAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureSupersededAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $0.Timestamp get createdAt => $_getN(15);
  @$pb.TagNumber(16)
  set createdAt($0.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasCreatedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearCreatedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureCreatedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.String get createdBy => $_getSZ(16);
  @$pb.TagNumber(17)
  set createdBy($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasCreatedBy() => $_has(16);
  @$pb.TagNumber(17)
  void clearCreatedBy() => $_clearField(17);
}

/// A record whose retention has run (SRS-MRD-009).
class DispositionCandidate extends $pb.GeneratedMessage {
  factory DispositionCandidate({
    $core.String? recordId,
    $core.String? patientId,
    $core.String? recordClass,
    $core.String? description,
    $core.String? ruleCode,
    $core.int? ruleRevision,
    $core.String? authority,
    DispositionKind? disposition,
    $0.Timestamp? anchorDate,
    $0.Timestamp? eligibleFrom,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (patientId != null) result.patientId = patientId;
    if (recordClass != null) result.recordClass = recordClass;
    if (description != null) result.description = description;
    if (ruleCode != null) result.ruleCode = ruleCode;
    if (ruleRevision != null) result.ruleRevision = ruleRevision;
    if (authority != null) result.authority = authority;
    if (disposition != null) result.disposition = disposition;
    if (anchorDate != null) result.anchorDate = anchorDate;
    if (eligibleFrom != null) result.eligibleFrom = eligibleFrom;
    return result;
  }

  DispositionCandidate._();

  factory DispositionCandidate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DispositionCandidate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DispositionCandidate',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'recordClass')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'ruleCode')
    ..aI(6, _omitFieldNames ? '' : 'ruleRevision')
    ..aOS(7, _omitFieldNames ? '' : 'authority')
    ..aE<DispositionKind>(8, _omitFieldNames ? '' : 'disposition',
        enumValues: DispositionKind.values)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'anchorDate',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'eligibleFrom',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispositionCandidate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispositionCandidate copyWith(void Function(DispositionCandidate) updates) =>
      super.copyWith((message) => updates(message as DispositionCandidate))
          as DispositionCandidate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DispositionCandidate create() => DispositionCandidate._();
  @$core.override
  DispositionCandidate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DispositionCandidate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DispositionCandidate>(create);
  static DispositionCandidate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get recordClass => $_getSZ(2);
  @$pb.TagNumber(3)
  set recordClass($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecordClass() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecordClass() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  /// The rule that made it eligible, pinned. A rule revised afterwards must
  /// not change the answer to "what allowed this".
  @$pb.TagNumber(5)
  $core.String get ruleCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set ruleCode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRuleCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearRuleCode() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get ruleRevision => $_getIZ(5);
  @$pb.TagNumber(6)
  set ruleRevision($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRuleRevision() => $_has(5);
  @$pb.TagNumber(6)
  void clearRuleRevision() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get authority => $_getSZ(6);
  @$pb.TagNumber(7)
  set authority($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAuthority() => $_has(6);
  @$pb.TagNumber(7)
  void clearAuthority() => $_clearField(7);

  @$pb.TagNumber(8)
  DispositionKind get disposition => $_getN(7);
  @$pb.TagNumber(8)
  set disposition(DispositionKind value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDisposition() => $_has(7);
  @$pb.TagNumber(8)
  void clearDisposition() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get anchorDate => $_getN(8);
  @$pb.TagNumber(9)
  set anchorDate($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasAnchorDate() => $_has(8);
  @$pb.TagNumber(9)
  void clearAnchorDate() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureAnchorDate() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get eligibleFrom => $_getN(9);
  @$pb.TagNumber(10)
  set eligibleFrom($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasEligibleFrom() => $_has(9);
  @$pb.TagNumber(10)
  void clearEligibleFrom() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureEligibleFrom() => $_ensure(9);
}

/// A record the sweep passed over, and why (SRS-MRD-005, SRS-MRD-009).
class Ineligible extends $pb.GeneratedMessage {
  factory Ineligible({
    $core.String? recordId,
    $core.String? reason,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (reason != null) result.reason = reason;
    return result;
  }

  Ineligible._();

  factory Ineligible.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Ineligible.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Ineligible',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ineligible clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ineligible copyWith(void Function(Ineligible) updates) =>
      super.copyWith((message) => updates(message as Ineligible)) as Ineligible;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Ineligible create() => Ineligible._();
  @$core.override
  Ineligible createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Ineligible getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Ineligible>(create);
  static Ineligible? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

/// A batch of records to destroy or archive (SRS-MRD-009).
class DispositionList extends $pb.GeneratedMessage {
  factory DispositionList({
    $core.String? listId,
    $core.String? reference,
    $core.String? jurisdiction,
    DispositionKind? disposition,
    $core.Iterable<DispositionCandidate>? items,
    DispositionState? state,
    $0.Timestamp? preparedAt,
    $core.String? preparedBy,
    $0.Timestamp? approvedAt,
    $core.String? approvedBy,
    $0.Timestamp? executedAt,
    $core.String? executedBy,
    $core.String? certificate,
    $core.String? cancelledReason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    if (reference != null) result.reference = reference;
    if (jurisdiction != null) result.jurisdiction = jurisdiction;
    if (disposition != null) result.disposition = disposition;
    if (items != null) result.items.addAll(items);
    if (state != null) result.state = state;
    if (preparedAt != null) result.preparedAt = preparedAt;
    if (preparedBy != null) result.preparedBy = preparedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (executedAt != null) result.executedAt = executedAt;
    if (executedBy != null) result.executedBy = executedBy;
    if (certificate != null) result.certificate = certificate;
    if (cancelledReason != null) result.cancelledReason = cancelledReason;
    if (version != null) result.version = version;
    return result;
  }

  DispositionList._();

  factory DispositionList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DispositionList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DispositionList',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aOS(3, _omitFieldNames ? '' : 'jurisdiction')
    ..aE<DispositionKind>(4, _omitFieldNames ? '' : 'disposition',
        enumValues: DispositionKind.values)
    ..pPM<DispositionCandidate>(5, _omitFieldNames ? '' : 'items',
        subBuilder: DispositionCandidate.create)
    ..aE<DispositionState>(6, _omitFieldNames ? '' : 'state',
        enumValues: DispositionState.values)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'preparedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'preparedBy')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'approvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'executedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'executedBy')
    ..aOS(13, _omitFieldNames ? '' : 'certificate')
    ..aOS(14, _omitFieldNames ? '' : 'cancelledReason')
    ..aInt64(15, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispositionList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispositionList copyWith(void Function(DispositionList) updates) =>
      super.copyWith((message) => updates(message as DispositionList))
          as DispositionList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DispositionList create() => DispositionList._();
  @$core.override
  DispositionList createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DispositionList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DispositionList>(create);
  static DispositionList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reference => $_getSZ(1);
  @$pb.TagNumber(2)
  set reference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearReference() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get jurisdiction => $_getSZ(2);
  @$pb.TagNumber(3)
  set jurisdiction($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasJurisdiction() => $_has(2);
  @$pb.TagNumber(3)
  void clearJurisdiction() => $_clearField(3);

  @$pb.TagNumber(4)
  DispositionKind get disposition => $_getN(3);
  @$pb.TagNumber(4)
  set disposition(DispositionKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDisposition() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisposition() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<DispositionCandidate> get items => $_getList(4);

  @$pb.TagNumber(6)
  DispositionState get state => $_getN(5);
  @$pb.TagNumber(6)
  set state(DispositionState value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasState() => $_has(5);
  @$pb.TagNumber(6)
  void clearState() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get preparedAt => $_getN(6);
  @$pb.TagNumber(7)
  set preparedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPreparedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearPreparedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensurePreparedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get preparedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set preparedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPreparedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearPreparedBy() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get approvedAt => $_getN(8);
  @$pb.TagNumber(9)
  set approvedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasApprovedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearApprovedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureApprovedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get approvedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set approvedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasApprovedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearApprovedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get executedAt => $_getN(10);
  @$pb.TagNumber(11)
  set executedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasExecutedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearExecutedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureExecutedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get executedBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set executedBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasExecutedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearExecutedBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get certificate => $_getSZ(12);
  @$pb.TagNumber(13)
  set certificate($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCertificate() => $_has(12);
  @$pb.TagNumber(13)
  void clearCertificate() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get cancelledReason => $_getSZ(13);
  @$pb.TagNumber(14)
  set cancelledReason($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasCancelledReason() => $_has(13);
  @$pb.TagNumber(14)
  void clearCancelledReason() => $_clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get version => $_getI64(14);
  @$pb.TagNumber(15)
  set version($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasVersion() => $_has(14);
  @$pb.TagNumber(15)
  void clearVersion() => $_clearField(15);
}

/// A paper volume the hospital holds (SRS-MRD-006).
class PhysicalRecord extends $pb.GeneratedMessage {
  factory PhysicalRecord({
    $core.String? recordId,
    $core.String? reference,
    $core.String? patientId,
    $core.int? volume,
    $core.String? recordClass,
    $core.String? jurisdiction,
    $core.String? description,
    PhysicalState? state,
    $core.String? homeLocation,
    $core.String? currentLocation,
    $core.String? custodian,
    $0.Timestamp? checkedOutAt,
    $core.String? checkedOutBy,
    $0.Timestamp? dueBackAt,
    $core.String? purpose,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (reference != null) result.reference = reference;
    if (patientId != null) result.patientId = patientId;
    if (volume != null) result.volume = volume;
    if (recordClass != null) result.recordClass = recordClass;
    if (jurisdiction != null) result.jurisdiction = jurisdiction;
    if (description != null) result.description = description;
    if (state != null) result.state = state;
    if (homeLocation != null) result.homeLocation = homeLocation;
    if (currentLocation != null) result.currentLocation = currentLocation;
    if (custodian != null) result.custodian = custodian;
    if (checkedOutAt != null) result.checkedOutAt = checkedOutAt;
    if (checkedOutBy != null) result.checkedOutBy = checkedOutBy;
    if (dueBackAt != null) result.dueBackAt = dueBackAt;
    if (purpose != null) result.purpose = purpose;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  PhysicalRecord._();

  factory PhysicalRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PhysicalRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PhysicalRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aI(4, _omitFieldNames ? '' : 'volume')
    ..aOS(5, _omitFieldNames ? '' : 'recordClass')
    ..aOS(6, _omitFieldNames ? '' : 'jurisdiction')
    ..aOS(7, _omitFieldNames ? '' : 'description')
    ..aE<PhysicalState>(8, _omitFieldNames ? '' : 'state',
        enumValues: PhysicalState.values)
    ..aOS(9, _omitFieldNames ? '' : 'homeLocation')
    ..aOS(10, _omitFieldNames ? '' : 'currentLocation')
    ..aOS(11, _omitFieldNames ? '' : 'custodian')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'checkedOutAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'checkedOutBy')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'dueBackAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'purpose')
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(17, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(18, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhysicalRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhysicalRecord copyWith(void Function(PhysicalRecord) updates) =>
      super.copyWith((message) => updates(message as PhysicalRecord))
          as PhysicalRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PhysicalRecord create() => PhysicalRecord._();
  @$core.override
  PhysicalRecord createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PhysicalRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PhysicalRecord>(create);
  static PhysicalRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reference => $_getSZ(1);
  @$pb.TagNumber(2)
  set reference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearReference() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get patientId => $_getSZ(2);
  @$pb.TagNumber(3)
  set patientId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPatientId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatientId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get volume => $_getIZ(3);
  @$pb.TagNumber(4)
  set volume($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVolume() => $_has(3);
  @$pb.TagNumber(4)
  void clearVolume() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get recordClass => $_getSZ(4);
  @$pb.TagNumber(5)
  set recordClass($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRecordClass() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecordClass() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get jurisdiction => $_getSZ(5);
  @$pb.TagNumber(6)
  set jurisdiction($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasJurisdiction() => $_has(5);
  @$pb.TagNumber(6)
  void clearJurisdiction() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get description => $_getSZ(6);
  @$pb.TagNumber(7)
  set description($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDescription() => $_has(6);
  @$pb.TagNumber(7)
  void clearDescription() => $_clearField(7);

  @$pb.TagNumber(8)
  PhysicalState get state => $_getN(7);
  @$pb.TagNumber(8)
  set state(PhysicalState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasState() => $_has(7);
  @$pb.TagNumber(8)
  void clearState() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get homeLocation => $_getSZ(8);
  @$pb.TagNumber(9)
  set homeLocation($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasHomeLocation() => $_has(8);
  @$pb.TagNumber(9)
  void clearHomeLocation() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get currentLocation => $_getSZ(9);
  @$pb.TagNumber(10)
  set currentLocation($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCurrentLocation() => $_has(9);
  @$pb.TagNumber(10)
  void clearCurrentLocation() => $_clearField(10);

  /// One named person. "The clinic" cannot be asked where it put something.
  @$pb.TagNumber(11)
  $core.String get custodian => $_getSZ(10);
  @$pb.TagNumber(11)
  set custodian($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCustodian() => $_has(10);
  @$pb.TagNumber(11)
  void clearCustodian() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get checkedOutAt => $_getN(11);
  @$pb.TagNumber(12)
  set checkedOutAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCheckedOutAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCheckedOutAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureCheckedOutAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get checkedOutBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set checkedOutBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCheckedOutBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearCheckedOutBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get dueBackAt => $_getN(13);
  @$pb.TagNumber(14)
  set dueBackAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasDueBackAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearDueBackAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureDueBackAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get purpose => $_getSZ(14);
  @$pb.TagNumber(15)
  set purpose($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasPurpose() => $_has(14);
  @$pb.TagNumber(15)
  void clearPurpose() => $_clearField(15);

  @$pb.TagNumber(16)
  $0.Timestamp get createdAt => $_getN(15);
  @$pb.TagNumber(16)
  set createdAt($0.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasCreatedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearCreatedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureCreatedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.String get createdBy => $_getSZ(16);
  @$pb.TagNumber(17)
  set createdBy($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasCreatedBy() => $_has(16);
  @$pb.TagNumber(17)
  void clearCreatedBy() => $_clearField(17);

  @$pb.TagNumber(18)
  $fixnum.Int64 get version => $_getI64(17);
  @$pb.TagNumber(18)
  set version($fixnum.Int64 value) => $_setInt64(17, value);
  @$pb.TagNumber(18)
  $core.bool hasVersion() => $_has(17);
  @$pb.TagNumber(18)
  void clearVersion() => $_clearField(18);
}

/// One configured field of a statutory form (SRS-MRD-007).
class CertificateField extends $pb.GeneratedMessage {
  factory CertificateField({
    $core.String? code,
    $core.String? label,
    $core.bool? required,
    $core.String? sourcePath,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (label != null) result.label = label;
    if (required != null) result.required = required;
    if (sourcePath != null) result.sourcePath = sourcePath;
    return result;
  }

  CertificateField._();

  factory CertificateField.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CertificateField.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CertificateField',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOB(3, _omitFieldNames ? '' : 'required')
    ..aOS(4, _omitFieldNames ? '' : 'sourcePath')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CertificateField clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CertificateField copyWith(void Function(CertificateField) updates) =>
      super.copyWith((message) => updates(message as CertificateField))
          as CertificateField;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CertificateField create() => CertificateField._();
  @$core.override
  CertificateField createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CertificateField getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CertificateField>(create);
  static CertificateField? _defaultInstance;

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

  @$pb.TagNumber(3)
  $core.bool get required => $_getBF(2);
  @$pb.TagNumber(3)
  set required($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequired() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequired() => $_clearField(3);

  /// Where the value comes from in the hospital's own records, so a question
  /// years later is answered from the record.
  @$pb.TagNumber(4)
  $core.String get sourcePath => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourcePath($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourcePath() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourcePath() => $_clearField(4);
}

/// A jurisdiction's certificate form, versioned (SRS-MRD-007).
class CertificateForm extends $pb.GeneratedMessage {
  factory CertificateForm({
    $core.String? formId,
    $core.String? code,
    $core.String? name,
    $core.int? revision,
    CertificateKind? kind,
    $core.String? jurisdiction,
    $core.Iterable<CertificateField>? fields,
    $core.String? issuerRole,
    $core.bool? approved,
    $core.String? approvedBy,
    $0.Timestamp? approvedAt,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? supersededAt,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
  }) {
    final result = create();
    if (formId != null) result.formId = formId;
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (revision != null) result.revision = revision;
    if (kind != null) result.kind = kind;
    if (jurisdiction != null) result.jurisdiction = jurisdiction;
    if (fields != null) result.fields.addAll(fields);
    if (issuerRole != null) result.issuerRole = issuerRole;
    if (approved != null) result.approved = approved;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (supersededAt != null) result.supersededAt = supersededAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    return result;
  }

  CertificateForm._();

  factory CertificateForm.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CertificateForm.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CertificateForm',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'formId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aI(4, _omitFieldNames ? '' : 'revision')
    ..aE<CertificateKind>(5, _omitFieldNames ? '' : 'kind',
        enumValues: CertificateKind.values)
    ..aOS(6, _omitFieldNames ? '' : 'jurisdiction')
    ..pPM<CertificateField>(7, _omitFieldNames ? '' : 'fields',
        subBuilder: CertificateField.create)
    ..aOS(8, _omitFieldNames ? '' : 'issuerRole')
    ..aOB(9, _omitFieldNames ? '' : 'approved')
    ..aOS(10, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'approvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'supersededAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'createdBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CertificateForm clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CertificateForm copyWith(void Function(CertificateForm) updates) =>
      super.copyWith((message) => updates(message as CertificateForm))
          as CertificateForm;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CertificateForm create() => CertificateForm._();
  @$core.override
  CertificateForm createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CertificateForm getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CertificateForm>(create);
  static CertificateForm? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get formId => $_getSZ(0);
  @$pb.TagNumber(1)
  set formId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFormId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFormId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get revision => $_getIZ(3);
  @$pb.TagNumber(4)
  set revision($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevision() => $_clearField(4);

  @$pb.TagNumber(5)
  CertificateKind get kind => $_getN(4);
  @$pb.TagNumber(5)
  set kind(CertificateKind value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearKind() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get jurisdiction => $_getSZ(5);
  @$pb.TagNumber(6)
  set jurisdiction($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasJurisdiction() => $_has(5);
  @$pb.TagNumber(6)
  void clearJurisdiction() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<CertificateField> get fields => $_getList(6);

  /// Who may sign. A statutory question, not a permission the hospital
  /// invents at issue time.
  @$pb.TagNumber(8)
  $core.String get issuerRole => $_getSZ(7);
  @$pb.TagNumber(8)
  set issuerRole($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIssuerRole() => $_has(7);
  @$pb.TagNumber(8)
  void clearIssuerRole() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get approved => $_getBF(8);
  @$pb.TagNumber(9)
  set approved($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasApproved() => $_has(8);
  @$pb.TagNumber(9)
  void clearApproved() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get approvedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set approvedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasApprovedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearApprovedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get approvedAt => $_getN(10);
  @$pb.TagNumber(11)
  set approvedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasApprovedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearApprovedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureApprovedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $0.Timestamp get effectiveFrom => $_getN(11);
  @$pb.TagNumber(12)
  set effectiveFrom($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasEffectiveFrom() => $_has(11);
  @$pb.TagNumber(12)
  void clearEffectiveFrom() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(11);

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
  $0.Timestamp get createdAt => $_getN(13);
  @$pb.TagNumber(14)
  set createdAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasCreatedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearCreatedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureCreatedAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get createdBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set createdBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasCreatedBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearCreatedBy() => $_clearField(15);
}

/// One issued version of a certificate (SRS-MRD-007).
class CertificateVersion extends $pb.GeneratedMessage {
  factory CertificateVersion({
    $core.int? version,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? values,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? sourceRefs,
    $core.String? reason,
    $core.String? issuerId,
    $core.String? issuerName,
    $core.String? issuerRole,
    $0.Timestamp? issuedAt,
    $core.String? serialNumber,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (values != null) result.values.addEntries(values);
    if (sourceRefs != null) result.sourceRefs.addEntries(sourceRefs);
    if (reason != null) result.reason = reason;
    if (issuerId != null) result.issuerId = issuerId;
    if (issuerName != null) result.issuerName = issuerName;
    if (issuerRole != null) result.issuerRole = issuerRole;
    if (issuedAt != null) result.issuedAt = issuedAt;
    if (serialNumber != null) result.serialNumber = serialNumber;
    return result;
  }

  CertificateVersion._();

  factory CertificateVersion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CertificateVersion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CertificateVersion',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'version')
    ..m<$core.String, $core.String>(2, _omitFieldNames ? '' : 'values',
        entryClassName: 'CertificateVersion.ValuesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('healthcare.records.v1'))
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'sourceRefs',
        entryClassName: 'CertificateVersion.SourceRefsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('healthcare.records.v1'))
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aOS(5, _omitFieldNames ? '' : 'issuerId')
    ..aOS(6, _omitFieldNames ? '' : 'issuerName')
    ..aOS(7, _omitFieldNames ? '' : 'issuerRole')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'issuedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'serialNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CertificateVersion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CertificateVersion copyWith(void Function(CertificateVersion) updates) =>
      super.copyWith((message) => updates(message as CertificateVersion))
          as CertificateVersion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CertificateVersion create() => CertificateVersion._();
  @$core.override
  CertificateVersion createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CertificateVersion getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CertificateVersion>(create);
  static CertificateVersion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.String> get values => $_getMap(1);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get sourceRefs => $_getMap(2);

  /// Required on a correction.
  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get issuerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set issuerId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIssuerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearIssuerId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get issuerName => $_getSZ(5);
  @$pb.TagNumber(6)
  set issuerName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIssuerName() => $_has(5);
  @$pb.TagNumber(6)
  void clearIssuerName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get issuerRole => $_getSZ(6);
  @$pb.TagNumber(7)
  set issuerRole($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIssuerRole() => $_has(6);
  @$pb.TagNumber(7)
  void clearIssuerRole() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get issuedAt => $_getN(7);
  @$pb.TagNumber(8)
  set issuedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasIssuedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearIssuedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureIssuedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get serialNumber => $_getSZ(8);
  @$pb.TagNumber(9)
  set serialNumber($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSerialNumber() => $_has(8);
  @$pb.TagNumber(9)
  void clearSerialNumber() => $_clearField(9);
}

/// A statutory certificate and every version of it (SRS-MRD-007).
class StatutoryCertificate extends $pb.GeneratedMessage {
  factory StatutoryCertificate({
    $core.String? certificateId,
    CertificateKind? kind,
    $core.String? formCode,
    $core.int? formRevision,
    $core.String? jurisdiction,
    $core.String? patientId,
    $core.String? encounterId,
    $core.Iterable<CertificateVersion>? versions,
    CertificateState? state,
    $core.String? voidReason,
    $core.String? voidedBy,
    $0.Timestamp? voidedAt,
    $0.Timestamp? createdAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (certificateId != null) result.certificateId = certificateId;
    if (kind != null) result.kind = kind;
    if (formCode != null) result.formCode = formCode;
    if (formRevision != null) result.formRevision = formRevision;
    if (jurisdiction != null) result.jurisdiction = jurisdiction;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (versions != null) result.versions.addAll(versions);
    if (state != null) result.state = state;
    if (voidReason != null) result.voidReason = voidReason;
    if (voidedBy != null) result.voidedBy = voidedBy;
    if (voidedAt != null) result.voidedAt = voidedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (version != null) result.version = version;
    return result;
  }

  StatutoryCertificate._();

  factory StatutoryCertificate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StatutoryCertificate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StatutoryCertificate',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'certificateId')
    ..aE<CertificateKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: CertificateKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'formCode')
    ..aI(4, _omitFieldNames ? '' : 'formRevision')
    ..aOS(5, _omitFieldNames ? '' : 'jurisdiction')
    ..aOS(6, _omitFieldNames ? '' : 'patientId')
    ..aOS(7, _omitFieldNames ? '' : 'encounterId')
    ..pPM<CertificateVersion>(8, _omitFieldNames ? '' : 'versions',
        subBuilder: CertificateVersion.create)
    ..aE<CertificateState>(9, _omitFieldNames ? '' : 'state',
        enumValues: CertificateState.values)
    ..aOS(10, _omitFieldNames ? '' : 'voidReason')
    ..aOS(11, _omitFieldNames ? '' : 'voidedBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'voidedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(14, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatutoryCertificate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatutoryCertificate copyWith(void Function(StatutoryCertificate) updates) =>
      super.copyWith((message) => updates(message as StatutoryCertificate))
          as StatutoryCertificate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StatutoryCertificate create() => StatutoryCertificate._();
  @$core.override
  StatutoryCertificate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StatutoryCertificate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StatutoryCertificate>(create);
  static StatutoryCertificate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get certificateId => $_getSZ(0);
  @$pb.TagNumber(1)
  set certificateId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCertificateId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCertificateId() => $_clearField(1);

  @$pb.TagNumber(2)
  CertificateKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(CertificateKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get formCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set formCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFormCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get formRevision => $_getIZ(3);
  @$pb.TagNumber(4)
  set formRevision($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFormRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearFormRevision() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get jurisdiction => $_getSZ(4);
  @$pb.TagNumber(5)
  set jurisdiction($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasJurisdiction() => $_has(4);
  @$pb.TagNumber(5)
  void clearJurisdiction() => $_clearField(5);

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

  /// Oldest first. A correction adds a version; the one that was issued went
  /// to a family and to a registrar and stays readable.
  @$pb.TagNumber(8)
  $pb.PbList<CertificateVersion> get versions => $_getList(7);

  @$pb.TagNumber(9)
  CertificateState get state => $_getN(8);
  @$pb.TagNumber(9)
  set state(CertificateState value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasState() => $_has(8);
  @$pb.TagNumber(9)
  void clearState() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get voidReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set voidReason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVoidReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearVoidReason() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get voidedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set voidedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasVoidedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearVoidedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get voidedAt => $_getN(11);
  @$pb.TagNumber(12)
  set voidedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasVoidedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearVoidedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureVoidedAt() => $_ensure(11);

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
  $fixnum.Int64 get version => $_getI64(13);
  @$pb.TagNumber(14)
  set version($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasVersion() => $_has(13);
  @$pb.TagNumber(14)
  void clearVersion() => $_clearField(14);
}

class DraftChecklistRequest extends $pb.GeneratedMessage {
  factory DraftChecklistRequest({
    $core.String? code,
    $core.String? name,
    $core.int? revision,
    $core.String? encounterClass,
    $core.String? specialty,
    $core.Iterable<ChecklistItem>? items,
    $0.Timestamp? effectiveFrom,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (revision != null) result.revision = revision;
    if (encounterClass != null) result.encounterClass = encounterClass;
    if (specialty != null) result.specialty = specialty;
    if (items != null) result.items.addAll(items);
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    return result;
  }

  DraftChecklistRequest._();

  factory DraftChecklistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DraftChecklistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DraftChecklistRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'revision')
    ..aOS(4, _omitFieldNames ? '' : 'encounterClass')
    ..aOS(5, _omitFieldNames ? '' : 'specialty')
    ..pPM<ChecklistItem>(6, _omitFieldNames ? '' : 'items',
        subBuilder: ChecklistItem.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftChecklistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftChecklistRequest copyWith(
          void Function(DraftChecklistRequest) updates) =>
      super.copyWith((message) => updates(message as DraftChecklistRequest))
          as DraftChecklistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DraftChecklistRequest create() => DraftChecklistRequest._();
  @$core.override
  DraftChecklistRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DraftChecklistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DraftChecklistRequest>(create);
  static DraftChecklistRequest? _defaultInstance;

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
  $core.int get revision => $_getIZ(2);
  @$pb.TagNumber(3)
  set revision($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get encounterClass => $_getSZ(3);
  @$pb.TagNumber(4)
  set encounterClass($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEncounterClass() => $_has(3);
  @$pb.TagNumber(4)
  void clearEncounterClass() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get specialty => $_getSZ(4);
  @$pb.TagNumber(5)
  set specialty($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSpecialty() => $_has(4);
  @$pb.TagNumber(5)
  void clearSpecialty() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<ChecklistItem> get items => $_getList(5);

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
}

class DraftChecklistResponse extends $pb.GeneratedMessage {
  factory DraftChecklistResponse({
    ChartChecklist? checklist,
  }) {
    final result = create();
    if (checklist != null) result.checklist = checklist;
    return result;
  }

  DraftChecklistResponse._();

  factory DraftChecklistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DraftChecklistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DraftChecklistResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<ChartChecklist>(1, _omitFieldNames ? '' : 'checklist',
        subBuilder: ChartChecklist.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftChecklistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftChecklistResponse copyWith(
          void Function(DraftChecklistResponse) updates) =>
      super.copyWith((message) => updates(message as DraftChecklistResponse))
          as DraftChecklistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DraftChecklistResponse create() => DraftChecklistResponse._();
  @$core.override
  DraftChecklistResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DraftChecklistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DraftChecklistResponse>(create);
  static DraftChecklistResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ChartChecklist get checklist => $_getN(0);
  @$pb.TagNumber(1)
  set checklist(ChartChecklist value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChecklist() => $_has(0);
  @$pb.TagNumber(1)
  void clearChecklist() => $_clearField(1);
  @$pb.TagNumber(1)
  ChartChecklist ensureChecklist() => $_ensure(0);
}

class ApproveChecklistRequest extends $pb.GeneratedMessage {
  factory ApproveChecklistRequest({
    $core.String? checklistId,
    $0.Timestamp? effectiveFrom,
  }) {
    final result = create();
    if (checklistId != null) result.checklistId = checklistId;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    return result;
  }

  ApproveChecklistRequest._();

  factory ApproveChecklistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveChecklistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveChecklistRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'checklistId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveChecklistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveChecklistRequest copyWith(
          void Function(ApproveChecklistRequest) updates) =>
      super.copyWith((message) => updates(message as ApproveChecklistRequest))
          as ApproveChecklistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveChecklistRequest create() => ApproveChecklistRequest._();
  @$core.override
  ApproveChecklistRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveChecklistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveChecklistRequest>(create);
  static ApproveChecklistRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checklistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checklistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChecklistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChecklistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get effectiveFrom => $_getN(1);
  @$pb.TagNumber(2)
  set effectiveFrom($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEffectiveFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearEffectiveFrom() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(1);
}

class ApproveChecklistResponse extends $pb.GeneratedMessage {
  factory ApproveChecklistResponse({
    ChartChecklist? checklist,
  }) {
    final result = create();
    if (checklist != null) result.checklist = checklist;
    return result;
  }

  ApproveChecklistResponse._();

  factory ApproveChecklistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveChecklistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveChecklistResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<ChartChecklist>(1, _omitFieldNames ? '' : 'checklist',
        subBuilder: ChartChecklist.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveChecklistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveChecklistResponse copyWith(
          void Function(ApproveChecklistResponse) updates) =>
      super.copyWith((message) => updates(message as ApproveChecklistResponse))
          as ApproveChecklistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveChecklistResponse create() => ApproveChecklistResponse._();
  @$core.override
  ApproveChecklistResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveChecklistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveChecklistResponse>(create);
  static ApproveChecklistResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ChartChecklist get checklist => $_getN(0);
  @$pb.TagNumber(1)
  set checklist(ChartChecklist value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChecklist() => $_has(0);
  @$pb.TagNumber(1)
  void clearChecklist() => $_clearField(1);
  @$pb.TagNumber(1)
  ChartChecklist ensureChecklist() => $_ensure(0);
}

class ListChecklistsRequest extends $pb.GeneratedMessage {
  factory ListChecklistsRequest({
    $core.String? encounterClass,
    $core.bool? liveOnly,
  }) {
    final result = create();
    if (encounterClass != null) result.encounterClass = encounterClass;
    if (liveOnly != null) result.liveOnly = liveOnly;
    return result;
  }

  ListChecklistsRequest._();

  factory ListChecklistsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListChecklistsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListChecklistsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterClass')
    ..aOB(2, _omitFieldNames ? '' : 'liveOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChecklistsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChecklistsRequest copyWith(
          void Function(ListChecklistsRequest) updates) =>
      super.copyWith((message) => updates(message as ListChecklistsRequest))
          as ListChecklistsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListChecklistsRequest create() => ListChecklistsRequest._();
  @$core.override
  ListChecklistsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListChecklistsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListChecklistsRequest>(create);
  static ListChecklistsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterClass => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterClass($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterClass() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterClass() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get liveOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set liveOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLiveOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearLiveOnly() => $_clearField(2);
}

class ListChecklistsResponse extends $pb.GeneratedMessage {
  factory ListChecklistsResponse({
    $core.Iterable<ChartChecklist>? checklists,
  }) {
    final result = create();
    if (checklists != null) result.checklists.addAll(checklists);
    return result;
  }

  ListChecklistsResponse._();

  factory ListChecklistsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListChecklistsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListChecklistsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..pPM<ChartChecklist>(1, _omitFieldNames ? '' : 'checklists',
        subBuilder: ChartChecklist.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChecklistsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChecklistsResponse copyWith(
          void Function(ListChecklistsResponse) updates) =>
      super.copyWith((message) => updates(message as ListChecklistsResponse))
          as ListChecklistsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListChecklistsResponse create() => ListChecklistsResponse._();
  @$core.override
  ListChecklistsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListChecklistsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListChecklistsResponse>(create);
  static ListChecklistsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChartChecklist> get checklists => $_getList(0);
}

class GetChartGapsRequest extends $pb.GeneratedMessage {
  factory GetChartGapsRequest({
    $core.String? encounterId,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    return result;
  }

  GetChartGapsRequest._();

  factory GetChartGapsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetChartGapsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetChartGapsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChartGapsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChartGapsRequest copyWith(void Function(GetChartGapsRequest) updates) =>
      super.copyWith((message) => updates(message as GetChartGapsRequest))
          as GetChartGapsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetChartGapsRequest create() => GetChartGapsRequest._();
  @$core.override
  GetChartGapsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetChartGapsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetChartGapsRequest>(create);
  static GetChartGapsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);
}

class GetChartGapsResponse extends $pb.GeneratedMessage {
  factory GetChartGapsResponse({
    ChartStatus? status,
  }) {
    final result = create();
    if (status != null) result.status = status;
    return result;
  }

  GetChartGapsResponse._();

  factory GetChartGapsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetChartGapsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetChartGapsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<ChartStatus>(1, _omitFieldNames ? '' : 'status',
        subBuilder: ChartStatus.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChartGapsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChartGapsResponse copyWith(void Function(GetChartGapsResponse) updates) =>
      super.copyWith((message) => updates(message as GetChartGapsResponse))
          as GetChartGapsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetChartGapsResponse create() => GetChartGapsResponse._();
  @$core.override
  GetChartGapsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetChartGapsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetChartGapsResponse>(create);
  static GetChartGapsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ChartStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(ChartStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  ChartStatus ensureStatus() => $_ensure(0);
}

class RaiseDeficienciesRequest extends $pb.GeneratedMessage {
  factory RaiseDeficienciesRequest({
    $core.String? encounterId,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    return result;
  }

  RaiseDeficienciesRequest._();

  factory RaiseDeficienciesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseDeficienciesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseDeficienciesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseDeficienciesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseDeficienciesRequest copyWith(
          void Function(RaiseDeficienciesRequest) updates) =>
      super.copyWith((message) => updates(message as RaiseDeficienciesRequest))
          as RaiseDeficienciesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseDeficienciesRequest create() => RaiseDeficienciesRequest._();
  @$core.override
  RaiseDeficienciesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseDeficienciesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseDeficienciesRequest>(create);
  static RaiseDeficienciesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);
}

class RaiseDeficienciesResponse extends $pb.GeneratedMessage {
  factory RaiseDeficienciesResponse({
    $core.Iterable<Deficiency>? raised,
  }) {
    final result = create();
    if (raised != null) result.raised.addAll(raised);
    return result;
  }

  RaiseDeficienciesResponse._();

  factory RaiseDeficienciesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseDeficienciesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseDeficienciesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..pPM<Deficiency>(1, _omitFieldNames ? '' : 'raised',
        subBuilder: Deficiency.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseDeficienciesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseDeficienciesResponse copyWith(
          void Function(RaiseDeficienciesResponse) updates) =>
      super.copyWith((message) => updates(message as RaiseDeficienciesResponse))
          as RaiseDeficienciesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseDeficienciesResponse create() => RaiseDeficienciesResponse._();
  @$core.override
  RaiseDeficienciesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseDeficienciesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseDeficienciesResponse>(create);
  static RaiseDeficienciesResponse? _defaultInstance;

  /// Only the ones this call raised. Running the sweep twice on a chart
  /// nobody touched raises nothing the second time.
  @$pb.TagNumber(1)
  $pb.PbList<Deficiency> get raised => $_getList(0);
}

class RaiseCodingQueryRequest extends $pb.GeneratedMessage {
  factory RaiseCodingQueryRequest({
    $core.String? encounterId,
    $core.String? documentId,
    $core.String? ownerId,
    $core.String? detail,
    $0.Timestamp? dueBy,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (documentId != null) result.documentId = documentId;
    if (ownerId != null) result.ownerId = ownerId;
    if (detail != null) result.detail = detail;
    if (dueBy != null) result.dueBy = dueBy;
    return result;
  }

  RaiseCodingQueryRequest._();

  factory RaiseCodingQueryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseCodingQueryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseCodingQueryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'documentId')
    ..aOS(3, _omitFieldNames ? '' : 'ownerId')
    ..aOS(4, _omitFieldNames ? '' : 'detail')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'dueBy',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseCodingQueryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseCodingQueryRequest copyWith(
          void Function(RaiseCodingQueryRequest) updates) =>
      super.copyWith((message) => updates(message as RaiseCodingQueryRequest))
          as RaiseCodingQueryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseCodingQueryRequest create() => RaiseCodingQueryRequest._();
  @$core.override
  RaiseCodingQueryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseCodingQueryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseCodingQueryRequest>(create);
  static RaiseCodingQueryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get documentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set documentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDocumentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDocumentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get ownerId => $_getSZ(2);
  @$pb.TagNumber(3)
  set ownerId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOwnerId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOwnerId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get detail => $_getSZ(3);
  @$pb.TagNumber(4)
  set detail($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDetail() => $_has(3);
  @$pb.TagNumber(4)
  void clearDetail() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get dueBy => $_getN(4);
  @$pb.TagNumber(5)
  set dueBy($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDueBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearDueBy() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureDueBy() => $_ensure(4);
}

class RaiseCodingQueryResponse extends $pb.GeneratedMessage {
  factory RaiseCodingQueryResponse({
    Deficiency? deficiency,
  }) {
    final result = create();
    if (deficiency != null) result.deficiency = deficiency;
    return result;
  }

  RaiseCodingQueryResponse._();

  factory RaiseCodingQueryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseCodingQueryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseCodingQueryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<Deficiency>(1, _omitFieldNames ? '' : 'deficiency',
        subBuilder: Deficiency.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseCodingQueryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseCodingQueryResponse copyWith(
          void Function(RaiseCodingQueryResponse) updates) =>
      super.copyWith((message) => updates(message as RaiseCodingQueryResponse))
          as RaiseCodingQueryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseCodingQueryResponse create() => RaiseCodingQueryResponse._();
  @$core.override
  RaiseCodingQueryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseCodingQueryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseCodingQueryResponse>(create);
  static RaiseCodingQueryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Deficiency get deficiency => $_getN(0);
  @$pb.TagNumber(1)
  set deficiency(Deficiency value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDeficiency() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeficiency() => $_clearField(1);
  @$pb.TagNumber(1)
  Deficiency ensureDeficiency() => $_ensure(0);
}

class ResolveDeficiencyRequest extends $pb.GeneratedMessage {
  factory ResolveDeficiencyRequest({
    $core.String? deficiencyId,
    $core.String? documentId,
  }) {
    final result = create();
    if (deficiencyId != null) result.deficiencyId = deficiencyId;
    if (documentId != null) result.documentId = documentId;
    return result;
  }

  ResolveDeficiencyRequest._();

  factory ResolveDeficiencyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveDeficiencyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveDeficiencyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deficiencyId')
    ..aOS(2, _omitFieldNames ? '' : 'documentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveDeficiencyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveDeficiencyRequest copyWith(
          void Function(ResolveDeficiencyRequest) updates) =>
      super.copyWith((message) => updates(message as ResolveDeficiencyRequest))
          as ResolveDeficiencyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveDeficiencyRequest create() => ResolveDeficiencyRequest._();
  @$core.override
  ResolveDeficiencyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveDeficiencyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveDeficiencyRequest>(create);
  static ResolveDeficiencyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deficiencyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deficiencyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeficiencyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeficiencyId() => $_clearField(1);

  /// The document that answered it. For an inadequate document this must be a
  /// different document: an addendum answers it, an edit would rewrite signed
  /// history.
  @$pb.TagNumber(2)
  $core.String get documentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set documentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDocumentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDocumentId() => $_clearField(2);
}

class ResolveDeficiencyResponse extends $pb.GeneratedMessage {
  factory ResolveDeficiencyResponse({
    Deficiency? deficiency,
  }) {
    final result = create();
    if (deficiency != null) result.deficiency = deficiency;
    return result;
  }

  ResolveDeficiencyResponse._();

  factory ResolveDeficiencyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveDeficiencyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveDeficiencyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<Deficiency>(1, _omitFieldNames ? '' : 'deficiency',
        subBuilder: Deficiency.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveDeficiencyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveDeficiencyResponse copyWith(
          void Function(ResolveDeficiencyResponse) updates) =>
      super.copyWith((message) => updates(message as ResolveDeficiencyResponse))
          as ResolveDeficiencyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveDeficiencyResponse create() => ResolveDeficiencyResponse._();
  @$core.override
  ResolveDeficiencyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveDeficiencyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveDeficiencyResponse>(create);
  static ResolveDeficiencyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Deficiency get deficiency => $_getN(0);
  @$pb.TagNumber(1)
  set deficiency(Deficiency value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDeficiency() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeficiency() => $_clearField(1);
  @$pb.TagNumber(1)
  Deficiency ensureDeficiency() => $_ensure(0);
}

class WaiveDeficiencyRequest extends $pb.GeneratedMessage {
  factory WaiveDeficiencyRequest({
    $core.String? deficiencyId,
    $core.String? reason,
  }) {
    final result = create();
    if (deficiencyId != null) result.deficiencyId = deficiencyId;
    if (reason != null) result.reason = reason;
    return result;
  }

  WaiveDeficiencyRequest._();

  factory WaiveDeficiencyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WaiveDeficiencyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WaiveDeficiencyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deficiencyId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaiveDeficiencyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaiveDeficiencyRequest copyWith(
          void Function(WaiveDeficiencyRequest) updates) =>
      super.copyWith((message) => updates(message as WaiveDeficiencyRequest))
          as WaiveDeficiencyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WaiveDeficiencyRequest create() => WaiveDeficiencyRequest._();
  @$core.override
  WaiveDeficiencyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WaiveDeficiencyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WaiveDeficiencyRequest>(create);
  static WaiveDeficiencyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deficiencyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deficiencyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeficiencyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeficiencyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class WaiveDeficiencyResponse extends $pb.GeneratedMessage {
  factory WaiveDeficiencyResponse({
    Deficiency? deficiency,
  }) {
    final result = create();
    if (deficiency != null) result.deficiency = deficiency;
    return result;
  }

  WaiveDeficiencyResponse._();

  factory WaiveDeficiencyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WaiveDeficiencyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WaiveDeficiencyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<Deficiency>(1, _omitFieldNames ? '' : 'deficiency',
        subBuilder: Deficiency.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaiveDeficiencyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaiveDeficiencyResponse copyWith(
          void Function(WaiveDeficiencyResponse) updates) =>
      super.copyWith((message) => updates(message as WaiveDeficiencyResponse))
          as WaiveDeficiencyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WaiveDeficiencyResponse create() => WaiveDeficiencyResponse._();
  @$core.override
  WaiveDeficiencyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WaiveDeficiencyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WaiveDeficiencyResponse>(create);
  static WaiveDeficiencyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Deficiency get deficiency => $_getN(0);
  @$pb.TagNumber(1)
  set deficiency(Deficiency value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDeficiency() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeficiency() => $_clearField(1);
  @$pb.TagNumber(1)
  Deficiency ensureDeficiency() => $_ensure(0);
}

class ReassignDeficiencyRequest extends $pb.GeneratedMessage {
  factory ReassignDeficiencyRequest({
    $core.String? deficiencyId,
    $core.String? ownerId,
    $core.String? reason,
  }) {
    final result = create();
    if (deficiencyId != null) result.deficiencyId = deficiencyId;
    if (ownerId != null) result.ownerId = ownerId;
    if (reason != null) result.reason = reason;
    return result;
  }

  ReassignDeficiencyRequest._();

  factory ReassignDeficiencyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReassignDeficiencyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReassignDeficiencyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deficiencyId')
    ..aOS(2, _omitFieldNames ? '' : 'ownerId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReassignDeficiencyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReassignDeficiencyRequest copyWith(
          void Function(ReassignDeficiencyRequest) updates) =>
      super.copyWith((message) => updates(message as ReassignDeficiencyRequest))
          as ReassignDeficiencyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReassignDeficiencyRequest create() => ReassignDeficiencyRequest._();
  @$core.override
  ReassignDeficiencyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReassignDeficiencyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReassignDeficiencyRequest>(create);
  static ReassignDeficiencyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deficiencyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deficiencyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeficiencyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeficiencyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ownerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set ownerId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOwnerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOwnerId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class ReassignDeficiencyResponse extends $pb.GeneratedMessage {
  factory ReassignDeficiencyResponse({
    Deficiency? deficiency,
  }) {
    final result = create();
    if (deficiency != null) result.deficiency = deficiency;
    return result;
  }

  ReassignDeficiencyResponse._();

  factory ReassignDeficiencyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReassignDeficiencyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReassignDeficiencyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<Deficiency>(1, _omitFieldNames ? '' : 'deficiency',
        subBuilder: Deficiency.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReassignDeficiencyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReassignDeficiencyResponse copyWith(
          void Function(ReassignDeficiencyResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ReassignDeficiencyResponse))
          as ReassignDeficiencyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReassignDeficiencyResponse create() => ReassignDeficiencyResponse._();
  @$core.override
  ReassignDeficiencyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReassignDeficiencyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReassignDeficiencyResponse>(create);
  static ReassignDeficiencyResponse? _defaultInstance;

  /// The age does not reset. A deficiency passed between three registrars is
  /// three weeks old, not new.
  @$pb.TagNumber(1)
  Deficiency get deficiency => $_getN(0);
  @$pb.TagNumber(1)
  set deficiency(Deficiency value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDeficiency() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeficiency() => $_clearField(1);
  @$pb.TagNumber(1)
  Deficiency ensureDeficiency() => $_ensure(0);
}

class ListDeficienciesRequest extends $pb.GeneratedMessage {
  factory ListDeficienciesRequest({
    $core.String? ownerId,
    $core.String? encounterId,
    $core.String? facilityId,
    DeficiencyState? state,
    $core.bool? openOnly,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
    $core.int? pageOffset,
  }) {
    final result = create();
    if (ownerId != null) result.ownerId = ownerId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (state != null) result.state = state;
    if (openOnly != null) result.openOnly = openOnly;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageOffset != null) result.pageOffset = pageOffset;
    return result;
  }

  ListDeficienciesRequest._();

  factory ListDeficienciesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDeficienciesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDeficienciesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ownerId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aE<DeficiencyState>(4, _omitFieldNames ? '' : 'state',
        enumValues: DeficiencyState.values)
    ..aOB(5, _omitFieldNames ? '' : 'openOnly')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(8, _omitFieldNames ? '' : 'pageSize')
    ..aI(9, _omitFieldNames ? '' : 'pageOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDeficienciesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDeficienciesRequest copyWith(
          void Function(ListDeficienciesRequest) updates) =>
      super.copyWith((message) => updates(message as ListDeficienciesRequest))
          as ListDeficienciesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDeficienciesRequest create() => ListDeficienciesRequest._();
  @$core.override
  ListDeficienciesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDeficienciesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDeficienciesRequest>(create);
  static ListDeficienciesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ownerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ownerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOwnerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOwnerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  DeficiencyState get state => $_getN(3);
  @$pb.TagNumber(4)
  set state(DeficiencyState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get openOnly => $_getBF(4);
  @$pb.TagNumber(5)
  set openOnly($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOpenOnly() => $_has(4);
  @$pb.TagNumber(5)
  void clearOpenOnly() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get from => $_getN(5);
  @$pb.TagNumber(6)
  set from($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasFrom() => $_has(5);
  @$pb.TagNumber(6)
  void clearFrom() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureFrom() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get to => $_getN(6);
  @$pb.TagNumber(7)
  set to($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTo() => $_has(6);
  @$pb.TagNumber(7)
  void clearTo() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureTo() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.int get pageSize => $_getIZ(7);
  @$pb.TagNumber(8)
  set pageSize($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPageSize() => $_has(7);
  @$pb.TagNumber(8)
  void clearPageSize() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get pageOffset => $_getIZ(8);
  @$pb.TagNumber(9)
  set pageOffset($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPageOffset() => $_has(8);
  @$pb.TagNumber(9)
  void clearPageOffset() => $_clearField(9);
}

class ListDeficienciesResponse extends $pb.GeneratedMessage {
  factory ListDeficienciesResponse({
    $core.Iterable<Deficiency>? deficiencies,
  }) {
    final result = create();
    if (deficiencies != null) result.deficiencies.addAll(deficiencies);
    return result;
  }

  ListDeficienciesResponse._();

  factory ListDeficienciesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDeficienciesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDeficienciesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..pPM<Deficiency>(1, _omitFieldNames ? '' : 'deficiencies',
        subBuilder: Deficiency.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDeficienciesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDeficienciesResponse copyWith(
          void Function(ListDeficienciesResponse) updates) =>
      super.copyWith((message) => updates(message as ListDeficienciesResponse))
          as ListDeficienciesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDeficienciesResponse create() => ListDeficienciesResponse._();
  @$core.override
  ListDeficienciesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDeficienciesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDeficienciesResponse>(create);
  static ListDeficienciesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Deficiency> get deficiencies => $_getList(0);
}

class GetAgingReportRequest extends $pb.GeneratedMessage {
  factory GetAgingReportRequest({
    $core.String? ownerId,
    $core.String? facilityId,
  }) {
    final result = create();
    if (ownerId != null) result.ownerId = ownerId;
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  GetAgingReportRequest._();

  factory GetAgingReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAgingReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAgingReportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ownerId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAgingReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAgingReportRequest copyWith(
          void Function(GetAgingReportRequest) updates) =>
      super.copyWith((message) => updates(message as GetAgingReportRequest))
          as GetAgingReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAgingReportRequest create() => GetAgingReportRequest._();
  @$core.override
  GetAgingReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAgingReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAgingReportRequest>(create);
  static GetAgingReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ownerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ownerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOwnerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOwnerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);
}

class GetAgingReportResponse extends $pb.GeneratedMessage {
  factory GetAgingReportResponse({
    $core.Iterable<AgeBucket>? buckets,
  }) {
    final result = create();
    if (buckets != null) result.buckets.addAll(buckets);
    return result;
  }

  GetAgingReportResponse._();

  factory GetAgingReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAgingReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAgingReportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..pPM<AgeBucket>(1, _omitFieldNames ? '' : 'buckets',
        subBuilder: AgeBucket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAgingReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAgingReportResponse copyWith(
          void Function(GetAgingReportResponse) updates) =>
      super.copyWith((message) => updates(message as GetAgingReportResponse))
          as GetAgingReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAgingReportResponse create() => GetAgingReportResponse._();
  @$core.override
  GetAgingReportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAgingReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAgingReportResponse>(create);
  static GetAgingReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AgeBucket> get buckets => $_getList(0);
}

class GetCompletionSummaryRequest extends $pb.GeneratedMessage {
  factory GetCompletionSummaryRequest({
    $core.Iterable<$core.String>? encounterIds,
  }) {
    final result = create();
    if (encounterIds != null) result.encounterIds.addAll(encounterIds);
    return result;
  }

  GetCompletionSummaryRequest._();

  factory GetCompletionSummaryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCompletionSummaryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCompletionSummaryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'encounterIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCompletionSummaryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCompletionSummaryRequest copyWith(
          void Function(GetCompletionSummaryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetCompletionSummaryRequest))
          as GetCompletionSummaryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCompletionSummaryRequest create() =>
      GetCompletionSummaryRequest._();
  @$core.override
  GetCompletionSummaryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCompletionSummaryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCompletionSummaryRequest>(create);
  static GetCompletionSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get encounterIds => $_getList(0);
}

class GetCompletionSummaryResponse extends $pb.GeneratedMessage {
  factory GetCompletionSummaryResponse({
    CompletionSummary? summary,
  }) {
    final result = create();
    if (summary != null) result.summary = summary;
    return result;
  }

  GetCompletionSummaryResponse._();

  factory GetCompletionSummaryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCompletionSummaryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCompletionSummaryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<CompletionSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: CompletionSummary.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCompletionSummaryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCompletionSummaryResponse copyWith(
          void Function(GetCompletionSummaryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetCompletionSummaryResponse))
          as GetCompletionSummaryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCompletionSummaryResponse create() =>
      GetCompletionSummaryResponse._();
  @$core.override
  GetCompletionSummaryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCompletionSummaryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCompletionSummaryResponse>(create);
  static GetCompletionSummaryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CompletionSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(CompletionSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  CompletionSummary ensureSummary() => $_ensure(0);
}

class EscalateOverdueDeficienciesRequest extends $pb.GeneratedMessage {
  factory EscalateOverdueDeficienciesRequest() => create();

  EscalateOverdueDeficienciesRequest._();

  factory EscalateOverdueDeficienciesRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EscalateOverdueDeficienciesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EscalateOverdueDeficienciesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateOverdueDeficienciesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateOverdueDeficienciesRequest copyWith(
          void Function(EscalateOverdueDeficienciesRequest) updates) =>
      super.copyWith((message) =>
              updates(message as EscalateOverdueDeficienciesRequest))
          as EscalateOverdueDeficienciesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EscalateOverdueDeficienciesRequest create() =>
      EscalateOverdueDeficienciesRequest._();
  @$core.override
  EscalateOverdueDeficienciesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EscalateOverdueDeficienciesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EscalateOverdueDeficienciesRequest>(
          create);
  static EscalateOverdueDeficienciesRequest? _defaultInstance;
}

class EscalateOverdueDeficienciesResponse extends $pb.GeneratedMessage {
  factory EscalateOverdueDeficienciesResponse({
    $core.int? raised,
  }) {
    final result = create();
    if (raised != null) result.raised = raised;
    return result;
  }

  EscalateOverdueDeficienciesResponse._();

  factory EscalateOverdueDeficienciesResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EscalateOverdueDeficienciesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EscalateOverdueDeficienciesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'raised')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateOverdueDeficienciesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateOverdueDeficienciesResponse copyWith(
          void Function(EscalateOverdueDeficienciesResponse) updates) =>
      super.copyWith((message) =>
              updates(message as EscalateOverdueDeficienciesResponse))
          as EscalateOverdueDeficienciesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EscalateOverdueDeficienciesResponse create() =>
      EscalateOverdueDeficienciesResponse._();
  @$core.override
  EscalateOverdueDeficienciesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EscalateOverdueDeficienciesResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          EscalateOverdueDeficienciesResponse>(create);
  static EscalateOverdueDeficienciesResponse? _defaultInstance;

  /// Escalated once each: a deficiency that escalated yesterday and is still
  /// open does not produce a second notice.
  @$pb.TagNumber(1)
  $core.int get raised => $_getIZ(0);
  @$pb.TagNumber(1)
  set raised($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRaised() => $_has(0);
  @$pb.TagNumber(1)
  void clearRaised() => $_clearField(1);
}

class AssignCodesRequest extends $pb.GeneratedMessage {
  factory AssignCodesRequest({
    $core.String? encounterId,
    $core.Iterable<AssignedCode>? codes,
    $core.String? reason,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (codes != null) result.codes.addAll(codes);
    if (reason != null) result.reason = reason;
    return result;
  }

  AssignCodesRequest._();

  factory AssignCodesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssignCodesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssignCodesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..pPM<AssignedCode>(2, _omitFieldNames ? '' : 'codes',
        subBuilder: AssignedCode.create)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignCodesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignCodesRequest copyWith(void Function(AssignCodesRequest) updates) =>
      super.copyWith((message) => updates(message as AssignCodesRequest))
          as AssignCodesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignCodesRequest create() => AssignCodesRequest._();
  @$core.override
  AssignCodesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssignCodesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssignCodesRequest>(create);
  static AssignCodesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<AssignedCode> get codes => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class AssignCodesResponse extends $pb.GeneratedMessage {
  factory AssignCodesResponse({
    CodedEpisode? episode,
  }) {
    final result = create();
    if (episode != null) result.episode = episode;
    return result;
  }

  AssignCodesResponse._();

  factory AssignCodesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssignCodesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssignCodesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<CodedEpisode>(1, _omitFieldNames ? '' : 'episode',
        subBuilder: CodedEpisode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignCodesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignCodesResponse copyWith(void Function(AssignCodesResponse) updates) =>
      super.copyWith((message) => updates(message as AssignCodesResponse))
          as AssignCodesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignCodesResponse create() => AssignCodesResponse._();
  @$core.override
  AssignCodesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssignCodesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssignCodesResponse>(create);
  static AssignCodesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CodedEpisode get episode => $_getN(0);
  @$pb.TagNumber(1)
  set episode(CodedEpisode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisode() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisode() => $_clearField(1);
  @$pb.TagNumber(1)
  CodedEpisode ensureEpisode() => $_ensure(0);
}

class FinaliseCodingRequest extends $pb.GeneratedMessage {
  factory FinaliseCodingRequest({
    $core.String? episodeId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    return result;
  }

  FinaliseCodingRequest._();

  factory FinaliseCodingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FinaliseCodingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinaliseCodingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinaliseCodingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinaliseCodingRequest copyWith(
          void Function(FinaliseCodingRequest) updates) =>
      super.copyWith((message) => updates(message as FinaliseCodingRequest))
          as FinaliseCodingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinaliseCodingRequest create() => FinaliseCodingRequest._();
  @$core.override
  FinaliseCodingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FinaliseCodingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinaliseCodingRequest>(create);
  static FinaliseCodingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);
}

class FinaliseCodingResponse extends $pb.GeneratedMessage {
  factory FinaliseCodingResponse({
    CodedEpisode? episode,
  }) {
    final result = create();
    if (episode != null) result.episode = episode;
    return result;
  }

  FinaliseCodingResponse._();

  factory FinaliseCodingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FinaliseCodingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinaliseCodingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<CodedEpisode>(1, _omitFieldNames ? '' : 'episode',
        subBuilder: CodedEpisode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinaliseCodingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinaliseCodingResponse copyWith(
          void Function(FinaliseCodingResponse) updates) =>
      super.copyWith((message) => updates(message as FinaliseCodingResponse))
          as FinaliseCodingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinaliseCodingResponse create() => FinaliseCodingResponse._();
  @$core.override
  FinaliseCodingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FinaliseCodingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinaliseCodingResponse>(create);
  static FinaliseCodingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CodedEpisode get episode => $_getN(0);
  @$pb.TagNumber(1)
  set episode(CodedEpisode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisode() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisode() => $_clearField(1);
  @$pb.TagNumber(1)
  CodedEpisode ensureEpisode() => $_ensure(0);
}

class QueryCodingRequest extends $pb.GeneratedMessage {
  factory QueryCodingRequest({
    $core.String? episodeId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    return result;
  }

  QueryCodingRequest._();

  factory QueryCodingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QueryCodingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QueryCodingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QueryCodingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QueryCodingRequest copyWith(void Function(QueryCodingRequest) updates) =>
      super.copyWith((message) => updates(message as QueryCodingRequest))
          as QueryCodingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QueryCodingRequest create() => QueryCodingRequest._();
  @$core.override
  QueryCodingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QueryCodingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryCodingRequest>(create);
  static QueryCodingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);
}

class QueryCodingResponse extends $pb.GeneratedMessage {
  factory QueryCodingResponse({
    CodedEpisode? episode,
  }) {
    final result = create();
    if (episode != null) result.episode = episode;
    return result;
  }

  QueryCodingResponse._();

  factory QueryCodingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QueryCodingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QueryCodingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<CodedEpisode>(1, _omitFieldNames ? '' : 'episode',
        subBuilder: CodedEpisode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QueryCodingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QueryCodingResponse copyWith(void Function(QueryCodingResponse) updates) =>
      super.copyWith((message) => updates(message as QueryCodingResponse))
          as QueryCodingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QueryCodingResponse create() => QueryCodingResponse._();
  @$core.override
  QueryCodingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QueryCodingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryCodingResponse>(create);
  static QueryCodingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CodedEpisode get episode => $_getN(0);
  @$pb.TagNumber(1)
  set episode(CodedEpisode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisode() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisode() => $_clearField(1);
  @$pb.TagNumber(1)
  CodedEpisode ensureEpisode() => $_ensure(0);
}

class GetCodedEpisodeRequest extends $pb.GeneratedMessage {
  factory GetCodedEpisodeRequest({
    $core.String? episodeId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    return result;
  }

  GetCodedEpisodeRequest._();

  factory GetCodedEpisodeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCodedEpisodeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCodedEpisodeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCodedEpisodeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCodedEpisodeRequest copyWith(
          void Function(GetCodedEpisodeRequest) updates) =>
      super.copyWith((message) => updates(message as GetCodedEpisodeRequest))
          as GetCodedEpisodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCodedEpisodeRequest create() => GetCodedEpisodeRequest._();
  @$core.override
  GetCodedEpisodeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCodedEpisodeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCodedEpisodeRequest>(create);
  static GetCodedEpisodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);
}

class GetCodedEpisodeResponse extends $pb.GeneratedMessage {
  factory GetCodedEpisodeResponse({
    CodedEpisode? episode,
  }) {
    final result = create();
    if (episode != null) result.episode = episode;
    return result;
  }

  GetCodedEpisodeResponse._();

  factory GetCodedEpisodeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCodedEpisodeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCodedEpisodeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<CodedEpisode>(1, _omitFieldNames ? '' : 'episode',
        subBuilder: CodedEpisode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCodedEpisodeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCodedEpisodeResponse copyWith(
          void Function(GetCodedEpisodeResponse) updates) =>
      super.copyWith((message) => updates(message as GetCodedEpisodeResponse))
          as GetCodedEpisodeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCodedEpisodeResponse create() => GetCodedEpisodeResponse._();
  @$core.override
  GetCodedEpisodeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCodedEpisodeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCodedEpisodeResponse>(create);
  static GetCodedEpisodeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CodedEpisode get episode => $_getN(0);
  @$pb.TagNumber(1)
  set episode(CodedEpisode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisode() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisode() => $_clearField(1);
  @$pb.TagNumber(1)
  CodedEpisode ensureEpisode() => $_ensure(0);
}

class GetCodingDiffRequest extends $pb.GeneratedMessage {
  factory GetCodingDiffRequest({
    $core.String? episodeId,
    $core.int? beforeRevision,
    $core.int? afterRevision,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (beforeRevision != null) result.beforeRevision = beforeRevision;
    if (afterRevision != null) result.afterRevision = afterRevision;
    return result;
  }

  GetCodingDiffRequest._();

  factory GetCodingDiffRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCodingDiffRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCodingDiffRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aI(2, _omitFieldNames ? '' : 'beforeRevision')
    ..aI(3, _omitFieldNames ? '' : 'afterRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCodingDiffRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCodingDiffRequest copyWith(void Function(GetCodingDiffRequest) updates) =>
      super.copyWith((message) => updates(message as GetCodingDiffRequest))
          as GetCodingDiffRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCodingDiffRequest create() => GetCodingDiffRequest._();
  @$core.override
  GetCodingDiffRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCodingDiffRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCodingDiffRequest>(create);
  static GetCodingDiffRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get beforeRevision => $_getIZ(1);
  @$pb.TagNumber(2)
  set beforeRevision($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBeforeRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearBeforeRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get afterRevision => $_getIZ(2);
  @$pb.TagNumber(3)
  set afterRevision($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAfterRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearAfterRevision() => $_clearField(3);
}

class GetCodingDiffResponse extends $pb.GeneratedMessage {
  factory GetCodingDiffResponse({
    $core.Iterable<CodingChange>? changes,
  }) {
    final result = create();
    if (changes != null) result.changes.addAll(changes);
    return result;
  }

  GetCodingDiffResponse._();

  factory GetCodingDiffResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCodingDiffResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCodingDiffResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..pPM<CodingChange>(1, _omitFieldNames ? '' : 'changes',
        subBuilder: CodingChange.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCodingDiffResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCodingDiffResponse copyWith(
          void Function(GetCodingDiffResponse) updates) =>
      super.copyWith((message) => updates(message as GetCodingDiffResponse))
          as GetCodingDiffResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCodingDiffResponse create() => GetCodingDiffResponse._();
  @$core.override
  GetCodingDiffResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCodingDiffResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCodingDiffResponse>(create);
  static GetCodingDiffResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CodingChange> get changes => $_getList(0);
}

class RequestReleaseRequest extends $pb.GeneratedMessage {
  factory RequestReleaseRequest({
    $core.String? reference,
    $core.String? patientId,
    $core.String? purpose,
    Authorisation? authorisation,
    Recipient? recipient,
    ReleaseScope? scope,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    if (patientId != null) result.patientId = patientId;
    if (purpose != null) result.purpose = purpose;
    if (authorisation != null) result.authorisation = authorisation;
    if (recipient != null) result.recipient = recipient;
    if (scope != null) result.scope = scope;
    return result;
  }

  RequestReleaseRequest._();

  factory RequestReleaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestReleaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestReleaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'purpose')
    ..aOM<Authorisation>(4, _omitFieldNames ? '' : 'authorisation',
        subBuilder: Authorisation.create)
    ..aOM<Recipient>(5, _omitFieldNames ? '' : 'recipient',
        subBuilder: Recipient.create)
    ..aOM<ReleaseScope>(6, _omitFieldNames ? '' : 'scope',
        subBuilder: ReleaseScope.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestReleaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestReleaseRequest copyWith(
          void Function(RequestReleaseRequest) updates) =>
      super.copyWith((message) => updates(message as RequestReleaseRequest))
          as RequestReleaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestReleaseRequest create() => RequestReleaseRequest._();
  @$core.override
  RequestReleaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestReleaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestReleaseRequest>(create);
  static RequestReleaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reference => $_getSZ(0);
  @$pb.TagNumber(1)
  set reference($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReference() => $_has(0);
  @$pb.TagNumber(1)
  void clearReference() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get purpose => $_getSZ(2);
  @$pb.TagNumber(3)
  set purpose($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPurpose() => $_has(2);
  @$pb.TagNumber(3)
  void clearPurpose() => $_clearField(3);

  @$pb.TagNumber(4)
  Authorisation get authorisation => $_getN(3);
  @$pb.TagNumber(4)
  set authorisation(Authorisation value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAuthorisation() => $_has(3);
  @$pb.TagNumber(4)
  void clearAuthorisation() => $_clearField(4);
  @$pb.TagNumber(4)
  Authorisation ensureAuthorisation() => $_ensure(3);

  @$pb.TagNumber(5)
  Recipient get recipient => $_getN(4);
  @$pb.TagNumber(5)
  set recipient(Recipient value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRecipient() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecipient() => $_clearField(5);
  @$pb.TagNumber(5)
  Recipient ensureRecipient() => $_ensure(4);

  @$pb.TagNumber(6)
  ReleaseScope get scope => $_getN(5);
  @$pb.TagNumber(6)
  set scope(ReleaseScope value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasScope() => $_has(5);
  @$pb.TagNumber(6)
  void clearScope() => $_clearField(6);
  @$pb.TagNumber(6)
  ReleaseScope ensureScope() => $_ensure(5);
}

class RequestReleaseResponse extends $pb.GeneratedMessage {
  factory RequestReleaseResponse({
    ReleaseRequest? release,
  }) {
    final result = create();
    if (release != null) result.release = release;
    return result;
  }

  RequestReleaseResponse._();

  factory RequestReleaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestReleaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestReleaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<ReleaseRequest>(1, _omitFieldNames ? '' : 'release',
        subBuilder: ReleaseRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestReleaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestReleaseResponse copyWith(
          void Function(RequestReleaseResponse) updates) =>
      super.copyWith((message) => updates(message as RequestReleaseResponse))
          as RequestReleaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestReleaseResponse create() => RequestReleaseResponse._();
  @$core.override
  RequestReleaseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestReleaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestReleaseResponse>(create);
  static RequestReleaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReleaseRequest get release => $_getN(0);
  @$pb.TagNumber(1)
  set release(ReleaseRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRelease() => $_has(0);
  @$pb.TagNumber(1)
  void clearRelease() => $_clearField(1);
  @$pb.TagNumber(1)
  ReleaseRequest ensureRelease() => $_ensure(0);
}

class ApproveReleaseRequest extends $pb.GeneratedMessage {
  factory ApproveReleaseRequest({
    $core.String? releaseId,
  }) {
    final result = create();
    if (releaseId != null) result.releaseId = releaseId;
    return result;
  }

  ApproveReleaseRequest._();

  factory ApproveReleaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveReleaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveReleaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'releaseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveReleaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveReleaseRequest copyWith(
          void Function(ApproveReleaseRequest) updates) =>
      super.copyWith((message) => updates(message as ApproveReleaseRequest))
          as ApproveReleaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveReleaseRequest create() => ApproveReleaseRequest._();
  @$core.override
  ApproveReleaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveReleaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveReleaseRequest>(create);
  static ApproveReleaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get releaseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set releaseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReleaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReleaseId() => $_clearField(1);
}

class ApproveReleaseResponse extends $pb.GeneratedMessage {
  factory ApproveReleaseResponse({
    ReleaseRequest? release,
  }) {
    final result = create();
    if (release != null) result.release = release;
    return result;
  }

  ApproveReleaseResponse._();

  factory ApproveReleaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveReleaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveReleaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<ReleaseRequest>(1, _omitFieldNames ? '' : 'release',
        subBuilder: ReleaseRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveReleaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveReleaseResponse copyWith(
          void Function(ApproveReleaseResponse) updates) =>
      super.copyWith((message) => updates(message as ApproveReleaseResponse))
          as ApproveReleaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveReleaseResponse create() => ApproveReleaseResponse._();
  @$core.override
  ApproveReleaseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveReleaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveReleaseResponse>(create);
  static ApproveReleaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReleaseRequest get release => $_getN(0);
  @$pb.TagNumber(1)
  set release(ReleaseRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRelease() => $_has(0);
  @$pb.TagNumber(1)
  void clearRelease() => $_clearField(1);
  @$pb.TagNumber(1)
  ReleaseRequest ensureRelease() => $_ensure(0);
}

class RefuseReleaseRequest extends $pb.GeneratedMessage {
  factory RefuseReleaseRequest({
    $core.String? releaseId,
    $core.String? reason,
  }) {
    final result = create();
    if (releaseId != null) result.releaseId = releaseId;
    if (reason != null) result.reason = reason;
    return result;
  }

  RefuseReleaseRequest._();

  factory RefuseReleaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RefuseReleaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefuseReleaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'releaseId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefuseReleaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefuseReleaseRequest copyWith(void Function(RefuseReleaseRequest) updates) =>
      super.copyWith((message) => updates(message as RefuseReleaseRequest))
          as RefuseReleaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RefuseReleaseRequest create() => RefuseReleaseRequest._();
  @$core.override
  RefuseReleaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RefuseReleaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefuseReleaseRequest>(create);
  static RefuseReleaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get releaseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set releaseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReleaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReleaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class RefuseReleaseResponse extends $pb.GeneratedMessage {
  factory RefuseReleaseResponse({
    ReleaseRequest? release,
  }) {
    final result = create();
    if (release != null) result.release = release;
    return result;
  }

  RefuseReleaseResponse._();

  factory RefuseReleaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RefuseReleaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefuseReleaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<ReleaseRequest>(1, _omitFieldNames ? '' : 'release',
        subBuilder: ReleaseRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefuseReleaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefuseReleaseResponse copyWith(
          void Function(RefuseReleaseResponse) updates) =>
      super.copyWith((message) => updates(message as RefuseReleaseResponse))
          as RefuseReleaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RefuseReleaseResponse create() => RefuseReleaseResponse._();
  @$core.override
  RefuseReleaseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RefuseReleaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefuseReleaseResponse>(create);
  static RefuseReleaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReleaseRequest get release => $_getN(0);
  @$pb.TagNumber(1)
  set release(ReleaseRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRelease() => $_has(0);
  @$pb.TagNumber(1)
  void clearRelease() => $_clearField(1);
  @$pb.TagNumber(1)
  ReleaseRequest ensureRelease() => $_ensure(0);
}

class AssembleReleaseRequest extends $pb.GeneratedMessage {
  factory AssembleReleaseRequest({
    $core.String? releaseId,
  }) {
    final result = create();
    if (releaseId != null) result.releaseId = releaseId;
    return result;
  }

  AssembleReleaseRequest._();

  factory AssembleReleaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssembleReleaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssembleReleaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'releaseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssembleReleaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssembleReleaseRequest copyWith(
          void Function(AssembleReleaseRequest) updates) =>
      super.copyWith((message) => updates(message as AssembleReleaseRequest))
          as AssembleReleaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssembleReleaseRequest create() => AssembleReleaseRequest._();
  @$core.override
  AssembleReleaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssembleReleaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssembleReleaseRequest>(create);
  static AssembleReleaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get releaseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set releaseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReleaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReleaseId() => $_clearField(1);
}

class AssembleReleaseResponse extends $pb.GeneratedMessage {
  factory AssembleReleaseResponse({
    ReleaseRequest? release,
  }) {
    final result = create();
    if (release != null) result.release = release;
    return result;
  }

  AssembleReleaseResponse._();

  factory AssembleReleaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssembleReleaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssembleReleaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<ReleaseRequest>(1, _omitFieldNames ? '' : 'release',
        subBuilder: ReleaseRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssembleReleaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssembleReleaseResponse copyWith(
          void Function(AssembleReleaseResponse) updates) =>
      super.copyWith((message) => updates(message as AssembleReleaseResponse))
          as AssembleReleaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssembleReleaseResponse create() => AssembleReleaseResponse._();
  @$core.override
  AssembleReleaseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssembleReleaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssembleReleaseResponse>(create);
  static AssembleReleaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReleaseRequest get release => $_getN(0);
  @$pb.TagNumber(1)
  set release(ReleaseRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRelease() => $_has(0);
  @$pb.TagNumber(1)
  void clearRelease() => $_clearField(1);
  @$pb.TagNumber(1)
  ReleaseRequest ensureRelease() => $_ensure(0);
}

class SendReleaseRequest extends $pb.GeneratedMessage {
  factory SendReleaseRequest({
    $core.String? releaseId,
  }) {
    final result = create();
    if (releaseId != null) result.releaseId = releaseId;
    return result;
  }

  SendReleaseRequest._();

  factory SendReleaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendReleaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendReleaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'releaseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendReleaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendReleaseRequest copyWith(void Function(SendReleaseRequest) updates) =>
      super.copyWith((message) => updates(message as SendReleaseRequest))
          as SendReleaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendReleaseRequest create() => SendReleaseRequest._();
  @$core.override
  SendReleaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendReleaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendReleaseRequest>(create);
  static SendReleaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get releaseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set releaseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReleaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReleaseId() => $_clearField(1);
}

class SendReleaseResponse extends $pb.GeneratedMessage {
  factory SendReleaseResponse({
    ReleaseRequest? release,
    Disclosure? disclosure,
  }) {
    final result = create();
    if (release != null) result.release = release;
    if (disclosure != null) result.disclosure = disclosure;
    return result;
  }

  SendReleaseResponse._();

  factory SendReleaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendReleaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendReleaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<ReleaseRequest>(1, _omitFieldNames ? '' : 'release',
        subBuilder: ReleaseRequest.create)
    ..aOM<Disclosure>(2, _omitFieldNames ? '' : 'disclosure',
        subBuilder: Disclosure.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendReleaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendReleaseResponse copyWith(void Function(SendReleaseResponse) updates) =>
      super.copyWith((message) => updates(message as SendReleaseResponse))
          as SendReleaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendReleaseResponse create() => SendReleaseResponse._();
  @$core.override
  SendReleaseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendReleaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendReleaseResponse>(create);
  static SendReleaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReleaseRequest get release => $_getN(0);
  @$pb.TagNumber(1)
  set release(ReleaseRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRelease() => $_has(0);
  @$pb.TagNumber(1)
  void clearRelease() => $_clearField(1);
  @$pb.TagNumber(1)
  ReleaseRequest ensureRelease() => $_ensure(0);

  /// Filed in the same transaction. A release that went out with no
  /// disclosure recorded is one the patient cannot find out about.
  @$pb.TagNumber(2)
  Disclosure get disclosure => $_getN(1);
  @$pb.TagNumber(2)
  set disclosure(Disclosure value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDisclosure() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisclosure() => $_clearField(2);
  @$pb.TagNumber(2)
  Disclosure ensureDisclosure() => $_ensure(1);
}

class ListReleasesRequest extends $pb.GeneratedMessage {
  factory ListReleasesRequest({
    $core.String? patientId,
    ReleaseState? state,
    $core.bool? openOnly,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
    $core.int? pageOffset,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (state != null) result.state = state;
    if (openOnly != null) result.openOnly = openOnly;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageOffset != null) result.pageOffset = pageOffset;
    return result;
  }

  ListReleasesRequest._();

  factory ListReleasesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReleasesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReleasesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aE<ReleaseState>(2, _omitFieldNames ? '' : 'state',
        enumValues: ReleaseState.values)
    ..aOB(3, _omitFieldNames ? '' : 'openOnly')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(6, _omitFieldNames ? '' : 'pageSize')
    ..aI(7, _omitFieldNames ? '' : 'pageOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReleasesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReleasesRequest copyWith(void Function(ListReleasesRequest) updates) =>
      super.copyWith((message) => updates(message as ListReleasesRequest))
          as ListReleasesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReleasesRequest create() => ListReleasesRequest._();
  @$core.override
  ListReleasesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReleasesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReleasesRequest>(create);
  static ListReleasesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  ReleaseState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(ReleaseState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get openOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set openOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOpenOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearOpenOnly() => $_clearField(3);

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

  @$pb.TagNumber(6)
  $core.int get pageSize => $_getIZ(5);
  @$pb.TagNumber(6)
  set pageSize($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageSize() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get pageOffset => $_getIZ(6);
  @$pb.TagNumber(7)
  set pageOffset($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPageOffset() => $_has(6);
  @$pb.TagNumber(7)
  void clearPageOffset() => $_clearField(7);
}

class ListReleasesResponse extends $pb.GeneratedMessage {
  factory ListReleasesResponse({
    $core.Iterable<ReleaseRequest>? releases,
  }) {
    final result = create();
    if (releases != null) result.releases.addAll(releases);
    return result;
  }

  ListReleasesResponse._();

  factory ListReleasesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReleasesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReleasesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..pPM<ReleaseRequest>(1, _omitFieldNames ? '' : 'releases',
        subBuilder: ReleaseRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReleasesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReleasesResponse copyWith(void Function(ListReleasesResponse) updates) =>
      super.copyWith((message) => updates(message as ListReleasesResponse))
          as ListReleasesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReleasesResponse create() => ListReleasesResponse._();
  @$core.override
  ListReleasesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReleasesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReleasesResponse>(create);
  static ListReleasesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ReleaseRequest> get releases => $_getList(0);
}

class RecordDisclosureRequest extends $pb.GeneratedMessage {
  factory RecordDisclosureRequest({
    $core.String? patientId,
    DisclosureKind? kind,
    $core.String? purpose,
    $core.String? scopeSummary,
    Recipient? recipient,
    $core.int? items,
    $core.int? pages,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (kind != null) result.kind = kind;
    if (purpose != null) result.purpose = purpose;
    if (scopeSummary != null) result.scopeSummary = scopeSummary;
    if (recipient != null) result.recipient = recipient;
    if (items != null) result.items = items;
    if (pages != null) result.pages = pages;
    return result;
  }

  RecordDisclosureRequest._();

  factory RecordDisclosureRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordDisclosureRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordDisclosureRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aE<DisclosureKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: DisclosureKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'purpose')
    ..aOS(4, _omitFieldNames ? '' : 'scopeSummary')
    ..aOM<Recipient>(5, _omitFieldNames ? '' : 'recipient',
        subBuilder: Recipient.create)
    ..aI(6, _omitFieldNames ? '' : 'items')
    ..aI(7, _omitFieldNames ? '' : 'pages')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDisclosureRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDisclosureRequest copyWith(
          void Function(RecordDisclosureRequest) updates) =>
      super.copyWith((message) => updates(message as RecordDisclosureRequest))
          as RecordDisclosureRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordDisclosureRequest create() => RecordDisclosureRequest._();
  @$core.override
  RecordDisclosureRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordDisclosureRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordDisclosureRequest>(create);
  static RecordDisclosureRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  DisclosureKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(DisclosureKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get purpose => $_getSZ(2);
  @$pb.TagNumber(3)
  set purpose($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPurpose() => $_has(2);
  @$pb.TagNumber(3)
  void clearPurpose() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get scopeSummary => $_getSZ(3);
  @$pb.TagNumber(4)
  set scopeSummary($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScopeSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearScopeSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  Recipient get recipient => $_getN(4);
  @$pb.TagNumber(5)
  set recipient(Recipient value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRecipient() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecipient() => $_clearField(5);
  @$pb.TagNumber(5)
  Recipient ensureRecipient() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.int get items => $_getIZ(5);
  @$pb.TagNumber(6)
  set items($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasItems() => $_has(5);
  @$pb.TagNumber(6)
  void clearItems() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get pages => $_getIZ(6);
  @$pb.TagNumber(7)
  set pages($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPages() => $_has(6);
  @$pb.TagNumber(7)
  void clearPages() => $_clearField(7);
}

class RecordDisclosureResponse extends $pb.GeneratedMessage {
  factory RecordDisclosureResponse({
    Disclosure? disclosure,
  }) {
    final result = create();
    if (disclosure != null) result.disclosure = disclosure;
    return result;
  }

  RecordDisclosureResponse._();

  factory RecordDisclosureResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordDisclosureResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordDisclosureResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<Disclosure>(1, _omitFieldNames ? '' : 'disclosure',
        subBuilder: Disclosure.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDisclosureResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDisclosureResponse copyWith(
          void Function(RecordDisclosureResponse) updates) =>
      super.copyWith((message) => updates(message as RecordDisclosureResponse))
          as RecordDisclosureResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordDisclosureResponse create() => RecordDisclosureResponse._();
  @$core.override
  RecordDisclosureResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordDisclosureResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordDisclosureResponse>(create);
  static RecordDisclosureResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Disclosure get disclosure => $_getN(0);
  @$pb.TagNumber(1)
  set disclosure(Disclosure value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDisclosure() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisclosure() => $_clearField(1);
  @$pb.TagNumber(1)
  Disclosure ensureDisclosure() => $_ensure(0);
}

class ListDisclosuresRequest extends $pb.GeneratedMessage {
  factory ListDisclosuresRequest({
    $core.String? patientId,
    $core.String? actorId,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
    $core.int? pageOffset,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (actorId != null) result.actorId = actorId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageOffset != null) result.pageOffset = pageOffset;
    return result;
  }

  ListDisclosuresRequest._();

  factory ListDisclosuresRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDisclosuresRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDisclosuresRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'actorId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..aI(6, _omitFieldNames ? '' : 'pageOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDisclosuresRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDisclosuresRequest copyWith(
          void Function(ListDisclosuresRequest) updates) =>
      super.copyWith((message) => updates(message as ListDisclosuresRequest))
          as ListDisclosuresRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDisclosuresRequest create() => ListDisclosuresRequest._();
  @$core.override
  ListDisclosuresRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDisclosuresRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDisclosuresRequest>(create);
  static ListDisclosuresRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get actorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set actorId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearActorId() => $_clearField(2);

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

  @$pb.TagNumber(6)
  $core.int get pageOffset => $_getIZ(5);
  @$pb.TagNumber(6)
  set pageOffset($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageOffset() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageOffset() => $_clearField(6);
}

class ListDisclosuresResponse extends $pb.GeneratedMessage {
  factory ListDisclosuresResponse({
    $core.Iterable<Disclosure>? disclosures,
  }) {
    final result = create();
    if (disclosures != null) result.disclosures.addAll(disclosures);
    return result;
  }

  ListDisclosuresResponse._();

  factory ListDisclosuresResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDisclosuresResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDisclosuresResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..pPM<Disclosure>(1, _omitFieldNames ? '' : 'disclosures',
        subBuilder: Disclosure.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDisclosuresResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDisclosuresResponse copyWith(
          void Function(ListDisclosuresResponse) updates) =>
      super.copyWith((message) => updates(message as ListDisclosuresResponse))
          as ListDisclosuresResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDisclosuresResponse create() => ListDisclosuresResponse._();
  @$core.override
  ListDisclosuresResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDisclosuresResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDisclosuresResponse>(create);
  static ListDisclosuresResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Disclosure> get disclosures => $_getList(0);
}

class DraftRetentionRuleRequest extends $pb.GeneratedMessage {
  factory DraftRetentionRuleRequest({
    $core.String? code,
    $core.String? name,
    $core.int? revision,
    $core.String? recordClass,
    $core.String? jurisdiction,
    RetentionAnchor? anchor,
    $core.int? retainYears,
    DispositionKind? disposition,
    $core.String? authority,
    $0.Timestamp? effectiveFrom,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (revision != null) result.revision = revision;
    if (recordClass != null) result.recordClass = recordClass;
    if (jurisdiction != null) result.jurisdiction = jurisdiction;
    if (anchor != null) result.anchor = anchor;
    if (retainYears != null) result.retainYears = retainYears;
    if (disposition != null) result.disposition = disposition;
    if (authority != null) result.authority = authority;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    return result;
  }

  DraftRetentionRuleRequest._();

  factory DraftRetentionRuleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DraftRetentionRuleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DraftRetentionRuleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'revision')
    ..aOS(4, _omitFieldNames ? '' : 'recordClass')
    ..aOS(5, _omitFieldNames ? '' : 'jurisdiction')
    ..aE<RetentionAnchor>(6, _omitFieldNames ? '' : 'anchor',
        enumValues: RetentionAnchor.values)
    ..aI(7, _omitFieldNames ? '' : 'retainYears')
    ..aE<DispositionKind>(8, _omitFieldNames ? '' : 'disposition',
        enumValues: DispositionKind.values)
    ..aOS(9, _omitFieldNames ? '' : 'authority')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftRetentionRuleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftRetentionRuleRequest copyWith(
          void Function(DraftRetentionRuleRequest) updates) =>
      super.copyWith((message) => updates(message as DraftRetentionRuleRequest))
          as DraftRetentionRuleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DraftRetentionRuleRequest create() => DraftRetentionRuleRequest._();
  @$core.override
  DraftRetentionRuleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DraftRetentionRuleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DraftRetentionRuleRequest>(create);
  static DraftRetentionRuleRequest? _defaultInstance;

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
  $core.int get revision => $_getIZ(2);
  @$pb.TagNumber(3)
  set revision($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get recordClass => $_getSZ(3);
  @$pb.TagNumber(4)
  set recordClass($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRecordClass() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecordClass() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get jurisdiction => $_getSZ(4);
  @$pb.TagNumber(5)
  set jurisdiction($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasJurisdiction() => $_has(4);
  @$pb.TagNumber(5)
  void clearJurisdiction() => $_clearField(5);

  @$pb.TagNumber(6)
  RetentionAnchor get anchor => $_getN(5);
  @$pb.TagNumber(6)
  set anchor(RetentionAnchor value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAnchor() => $_has(5);
  @$pb.TagNumber(6)
  void clearAnchor() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get retainYears => $_getIZ(6);
  @$pb.TagNumber(7)
  set retainYears($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRetainYears() => $_has(6);
  @$pb.TagNumber(7)
  void clearRetainYears() => $_clearField(7);

  @$pb.TagNumber(8)
  DispositionKind get disposition => $_getN(7);
  @$pb.TagNumber(8)
  set disposition(DispositionKind value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDisposition() => $_has(7);
  @$pb.TagNumber(8)
  void clearDisposition() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get authority => $_getSZ(8);
  @$pb.TagNumber(9)
  set authority($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAuthority() => $_has(8);
  @$pb.TagNumber(9)
  void clearAuthority() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get effectiveFrom => $_getN(9);
  @$pb.TagNumber(10)
  set effectiveFrom($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasEffectiveFrom() => $_has(9);
  @$pb.TagNumber(10)
  void clearEffectiveFrom() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(9);
}

class DraftRetentionRuleResponse extends $pb.GeneratedMessage {
  factory DraftRetentionRuleResponse({
    RetentionRule? rule,
  }) {
    final result = create();
    if (rule != null) result.rule = rule;
    return result;
  }

  DraftRetentionRuleResponse._();

  factory DraftRetentionRuleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DraftRetentionRuleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DraftRetentionRuleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<RetentionRule>(1, _omitFieldNames ? '' : 'rule',
        subBuilder: RetentionRule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftRetentionRuleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftRetentionRuleResponse copyWith(
          void Function(DraftRetentionRuleResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DraftRetentionRuleResponse))
          as DraftRetentionRuleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DraftRetentionRuleResponse create() => DraftRetentionRuleResponse._();
  @$core.override
  DraftRetentionRuleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DraftRetentionRuleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DraftRetentionRuleResponse>(create);
  static DraftRetentionRuleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RetentionRule get rule => $_getN(0);
  @$pb.TagNumber(1)
  set rule(RetentionRule value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRule() => $_has(0);
  @$pb.TagNumber(1)
  void clearRule() => $_clearField(1);
  @$pb.TagNumber(1)
  RetentionRule ensureRule() => $_ensure(0);
}

class ApproveRetentionRuleRequest extends $pb.GeneratedMessage {
  factory ApproveRetentionRuleRequest({
    $core.String? ruleId,
    $0.Timestamp? effectiveFrom,
  }) {
    final result = create();
    if (ruleId != null) result.ruleId = ruleId;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    return result;
  }

  ApproveRetentionRuleRequest._();

  factory ApproveRetentionRuleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveRetentionRuleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveRetentionRuleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ruleId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveRetentionRuleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveRetentionRuleRequest copyWith(
          void Function(ApproveRetentionRuleRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ApproveRetentionRuleRequest))
          as ApproveRetentionRuleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveRetentionRuleRequest create() =>
      ApproveRetentionRuleRequest._();
  @$core.override
  ApproveRetentionRuleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveRetentionRuleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveRetentionRuleRequest>(create);
  static ApproveRetentionRuleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ruleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ruleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRuleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRuleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get effectiveFrom => $_getN(1);
  @$pb.TagNumber(2)
  set effectiveFrom($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEffectiveFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearEffectiveFrom() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(1);
}

class ApproveRetentionRuleResponse extends $pb.GeneratedMessage {
  factory ApproveRetentionRuleResponse({
    RetentionRule? rule,
  }) {
    final result = create();
    if (rule != null) result.rule = rule;
    return result;
  }

  ApproveRetentionRuleResponse._();

  factory ApproveRetentionRuleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveRetentionRuleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveRetentionRuleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<RetentionRule>(1, _omitFieldNames ? '' : 'rule',
        subBuilder: RetentionRule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveRetentionRuleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveRetentionRuleResponse copyWith(
          void Function(ApproveRetentionRuleResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ApproveRetentionRuleResponse))
          as ApproveRetentionRuleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveRetentionRuleResponse create() =>
      ApproveRetentionRuleResponse._();
  @$core.override
  ApproveRetentionRuleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveRetentionRuleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveRetentionRuleResponse>(create);
  static ApproveRetentionRuleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RetentionRule get rule => $_getN(0);
  @$pb.TagNumber(1)
  set rule(RetentionRule value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRule() => $_has(0);
  @$pb.TagNumber(1)
  void clearRule() => $_clearField(1);
  @$pb.TagNumber(1)
  RetentionRule ensureRule() => $_ensure(0);
}

class ListRetentionRulesRequest extends $pb.GeneratedMessage {
  factory ListRetentionRulesRequest({
    $core.String? jurisdiction,
    $core.String? recordClass,
    $core.bool? liveOnly,
  }) {
    final result = create();
    if (jurisdiction != null) result.jurisdiction = jurisdiction;
    if (recordClass != null) result.recordClass = recordClass;
    if (liveOnly != null) result.liveOnly = liveOnly;
    return result;
  }

  ListRetentionRulesRequest._();

  factory ListRetentionRulesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRetentionRulesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRetentionRulesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jurisdiction')
    ..aOS(2, _omitFieldNames ? '' : 'recordClass')
    ..aOB(3, _omitFieldNames ? '' : 'liveOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRetentionRulesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRetentionRulesRequest copyWith(
          void Function(ListRetentionRulesRequest) updates) =>
      super.copyWith((message) => updates(message as ListRetentionRulesRequest))
          as ListRetentionRulesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRetentionRulesRequest create() => ListRetentionRulesRequest._();
  @$core.override
  ListRetentionRulesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRetentionRulesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRetentionRulesRequest>(create);
  static ListRetentionRulesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jurisdiction => $_getSZ(0);
  @$pb.TagNumber(1)
  set jurisdiction($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJurisdiction() => $_has(0);
  @$pb.TagNumber(1)
  void clearJurisdiction() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recordClass => $_getSZ(1);
  @$pb.TagNumber(2)
  set recordClass($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordClass() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordClass() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get liveOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set liveOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLiveOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearLiveOnly() => $_clearField(3);
}

class ListRetentionRulesResponse extends $pb.GeneratedMessage {
  factory ListRetentionRulesResponse({
    $core.Iterable<RetentionRule>? rules,
  }) {
    final result = create();
    if (rules != null) result.rules.addAll(rules);
    return result;
  }

  ListRetentionRulesResponse._();

  factory ListRetentionRulesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRetentionRulesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRetentionRulesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..pPM<RetentionRule>(1, _omitFieldNames ? '' : 'rules',
        subBuilder: RetentionRule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRetentionRulesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRetentionRulesResponse copyWith(
          void Function(ListRetentionRulesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListRetentionRulesResponse))
          as ListRetentionRulesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRetentionRulesResponse create() => ListRetentionRulesResponse._();
  @$core.override
  ListRetentionRulesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRetentionRulesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRetentionRulesResponse>(create);
  static ListRetentionRulesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RetentionRule> get rules => $_getList(0);
}

class PlaceHoldRequest extends $pb.GeneratedMessage {
  factory PlaceHoldRequest({
    $core.String? recordClass,
    $core.String? recordId,
    $core.String? reason,
  }) {
    final result = create();
    if (recordClass != null) result.recordClass = recordClass;
    if (recordId != null) result.recordId = recordId;
    if (reason != null) result.reason = reason;
    return result;
  }

  PlaceHoldRequest._();

  factory PlaceHoldRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaceHoldRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaceHoldRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordClass')
    ..aOS(2, _omitFieldNames ? '' : 'recordId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceHoldRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceHoldRequest copyWith(void Function(PlaceHoldRequest) updates) =>
      super.copyWith((message) => updates(message as PlaceHoldRequest))
          as PlaceHoldRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaceHoldRequest create() => PlaceHoldRequest._();
  @$core.override
  PlaceHoldRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaceHoldRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaceHoldRequest>(create);
  static PlaceHoldRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordClass => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordClass($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordClass() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordClass() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recordId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recordId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class PlaceHoldResponse extends $pb.GeneratedMessage {
  factory PlaceHoldResponse() => create();

  PlaceHoldResponse._();

  factory PlaceHoldResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaceHoldResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaceHoldResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceHoldResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceHoldResponse copyWith(void Function(PlaceHoldResponse) updates) =>
      super.copyWith((message) => updates(message as PlaceHoldResponse))
          as PlaceHoldResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaceHoldResponse create() => PlaceHoldResponse._();
  @$core.override
  PlaceHoldResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaceHoldResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaceHoldResponse>(create);
  static PlaceHoldResponse? _defaultInstance;
}

class ReleaseHoldRequest extends $pb.GeneratedMessage {
  factory ReleaseHoldRequest({
    $core.String? recordClass,
    $core.String? recordId,
  }) {
    final result = create();
    if (recordClass != null) result.recordClass = recordClass;
    if (recordId != null) result.recordId = recordId;
    return result;
  }

  ReleaseHoldRequest._();

  factory ReleaseHoldRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseHoldRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseHoldRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordClass')
    ..aOS(2, _omitFieldNames ? '' : 'recordId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseHoldRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseHoldRequest copyWith(void Function(ReleaseHoldRequest) updates) =>
      super.copyWith((message) => updates(message as ReleaseHoldRequest))
          as ReleaseHoldRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseHoldRequest create() => ReleaseHoldRequest._();
  @$core.override
  ReleaseHoldRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseHoldRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseHoldRequest>(create);
  static ReleaseHoldRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordClass => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordClass($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordClass() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordClass() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recordId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recordId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordId() => $_clearField(2);
}

class ReleaseHoldResponse extends $pb.GeneratedMessage {
  factory ReleaseHoldResponse() => create();

  ReleaseHoldResponse._();

  factory ReleaseHoldResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseHoldResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseHoldResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseHoldResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseHoldResponse copyWith(void Function(ReleaseHoldResponse) updates) =>
      super.copyWith((message) => updates(message as ReleaseHoldResponse))
          as ReleaseHoldResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseHoldResponse create() => ReleaseHoldResponse._();
  @$core.override
  ReleaseHoldResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseHoldResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseHoldResponse>(create);
  static ReleaseHoldResponse? _defaultInstance;
}

class SweepForDispositionRequest extends $pb.GeneratedMessage {
  factory SweepForDispositionRequest({
    $core.String? jurisdiction,
  }) {
    final result = create();
    if (jurisdiction != null) result.jurisdiction = jurisdiction;
    return result;
  }

  SweepForDispositionRequest._();

  factory SweepForDispositionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SweepForDispositionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SweepForDispositionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jurisdiction')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepForDispositionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepForDispositionRequest copyWith(
          void Function(SweepForDispositionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SweepForDispositionRequest))
          as SweepForDispositionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SweepForDispositionRequest create() => SweepForDispositionRequest._();
  @$core.override
  SweepForDispositionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SweepForDispositionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SweepForDispositionRequest>(create);
  static SweepForDispositionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jurisdiction => $_getSZ(0);
  @$pb.TagNumber(1)
  set jurisdiction($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJurisdiction() => $_has(0);
  @$pb.TagNumber(1)
  void clearJurisdiction() => $_clearField(1);
}

class SweepForDispositionResponse extends $pb.GeneratedMessage {
  factory SweepForDispositionResponse({
    $core.String? jurisdiction,
    $core.Iterable<DispositionCandidate>? eligible,
    $core.Iterable<Ineligible>? ineligible,
    $core.int? swept,
  }) {
    final result = create();
    if (jurisdiction != null) result.jurisdiction = jurisdiction;
    if (eligible != null) result.eligible.addAll(eligible);
    if (ineligible != null) result.ineligible.addAll(ineligible);
    if (swept != null) result.swept = swept;
    return result;
  }

  SweepForDispositionResponse._();

  factory SweepForDispositionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SweepForDispositionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SweepForDispositionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jurisdiction')
    ..pPM<DispositionCandidate>(2, _omitFieldNames ? '' : 'eligible',
        subBuilder: DispositionCandidate.create)
    ..pPM<Ineligible>(3, _omitFieldNames ? '' : 'ineligible',
        subBuilder: Ineligible.create)
    ..aI(4, _omitFieldNames ? '' : 'swept')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepForDispositionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepForDispositionResponse copyWith(
          void Function(SweepForDispositionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SweepForDispositionResponse))
          as SweepForDispositionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SweepForDispositionResponse create() =>
      SweepForDispositionResponse._();
  @$core.override
  SweepForDispositionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SweepForDispositionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SweepForDispositionResponse>(create);
  static SweepForDispositionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jurisdiction => $_getSZ(0);
  @$pb.TagNumber(1)
  set jurisdiction($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJurisdiction() => $_has(0);
  @$pb.TagNumber(1)
  void clearJurisdiction() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<DispositionCandidate> get eligible => $_getList(1);

  /// Every record passed over and why. A sweep that reported only what it
  /// would destroy makes "why is this still here" unanswerable.
  @$pb.TagNumber(3)
  $pb.PbList<Ineligible> get ineligible => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get swept => $_getIZ(3);
  @$pb.TagNumber(4)
  set swept($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSwept() => $_has(3);
  @$pb.TagNumber(4)
  void clearSwept() => $_clearField(4);
}

class PrepareDispositionRequest extends $pb.GeneratedMessage {
  factory PrepareDispositionRequest({
    $core.String? reference,
    $core.String? jurisdiction,
    DispositionKind? disposition,
    $core.Iterable<$core.String>? recordIds,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    if (jurisdiction != null) result.jurisdiction = jurisdiction;
    if (disposition != null) result.disposition = disposition;
    if (recordIds != null) result.recordIds.addAll(recordIds);
    return result;
  }

  PrepareDispositionRequest._();

  factory PrepareDispositionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrepareDispositionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrepareDispositionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..aOS(2, _omitFieldNames ? '' : 'jurisdiction')
    ..aE<DispositionKind>(3, _omitFieldNames ? '' : 'disposition',
        enumValues: DispositionKind.values)
    ..pPS(4, _omitFieldNames ? '' : 'recordIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareDispositionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareDispositionRequest copyWith(
          void Function(PrepareDispositionRequest) updates) =>
      super.copyWith((message) => updates(message as PrepareDispositionRequest))
          as PrepareDispositionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrepareDispositionRequest create() => PrepareDispositionRequest._();
  @$core.override
  PrepareDispositionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrepareDispositionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrepareDispositionRequest>(create);
  static PrepareDispositionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reference => $_getSZ(0);
  @$pb.TagNumber(1)
  set reference($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReference() => $_has(0);
  @$pb.TagNumber(1)
  void clearReference() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get jurisdiction => $_getSZ(1);
  @$pb.TagNumber(2)
  set jurisdiction($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJurisdiction() => $_has(1);
  @$pb.TagNumber(2)
  void clearJurisdiction() => $_clearField(2);

  @$pb.TagNumber(3)
  DispositionKind get disposition => $_getN(2);
  @$pb.TagNumber(3)
  set disposition(DispositionKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDisposition() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisposition() => $_clearField(3);

  /// Empty takes everything the sweep found eligible.
  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get recordIds => $_getList(3);
}

class PrepareDispositionResponse extends $pb.GeneratedMessage {
  factory PrepareDispositionResponse({
    DispositionList? list,
  }) {
    final result = create();
    if (list != null) result.list = list;
    return result;
  }

  PrepareDispositionResponse._();

  factory PrepareDispositionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrepareDispositionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrepareDispositionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<DispositionList>(1, _omitFieldNames ? '' : 'list',
        subBuilder: DispositionList.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareDispositionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareDispositionResponse copyWith(
          void Function(PrepareDispositionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as PrepareDispositionResponse))
          as PrepareDispositionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrepareDispositionResponse create() => PrepareDispositionResponse._();
  @$core.override
  PrepareDispositionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrepareDispositionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrepareDispositionResponse>(create);
  static PrepareDispositionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DispositionList get list => $_getN(0);
  @$pb.TagNumber(1)
  set list(DispositionList value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasList() => $_has(0);
  @$pb.TagNumber(1)
  void clearList() => $_clearField(1);
  @$pb.TagNumber(1)
  DispositionList ensureList() => $_ensure(0);
}

class ApproveDispositionRequest extends $pb.GeneratedMessage {
  factory ApproveDispositionRequest({
    $core.String? listId,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    return result;
  }

  ApproveDispositionRequest._();

  factory ApproveDispositionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveDispositionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveDispositionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveDispositionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveDispositionRequest copyWith(
          void Function(ApproveDispositionRequest) updates) =>
      super.copyWith((message) => updates(message as ApproveDispositionRequest))
          as ApproveDispositionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveDispositionRequest create() => ApproveDispositionRequest._();
  @$core.override
  ApproveDispositionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveDispositionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveDispositionRequest>(create);
  static ApproveDispositionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);
}

class ApproveDispositionResponse extends $pb.GeneratedMessage {
  factory ApproveDispositionResponse({
    DispositionList? list,
  }) {
    final result = create();
    if (list != null) result.list = list;
    return result;
  }

  ApproveDispositionResponse._();

  factory ApproveDispositionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveDispositionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveDispositionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<DispositionList>(1, _omitFieldNames ? '' : 'list',
        subBuilder: DispositionList.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveDispositionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveDispositionResponse copyWith(
          void Function(ApproveDispositionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ApproveDispositionResponse))
          as ApproveDispositionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveDispositionResponse create() => ApproveDispositionResponse._();
  @$core.override
  ApproveDispositionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveDispositionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveDispositionResponse>(create);
  static ApproveDispositionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DispositionList get list => $_getN(0);
  @$pb.TagNumber(1)
  set list(DispositionList value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasList() => $_has(0);
  @$pb.TagNumber(1)
  void clearList() => $_clearField(1);
  @$pb.TagNumber(1)
  DispositionList ensureList() => $_ensure(0);
}

class ExecuteDispositionRequest extends $pb.GeneratedMessage {
  factory ExecuteDispositionRequest({
    $core.String? listId,
    $core.String? certificate,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    if (certificate != null) result.certificate = certificate;
    return result;
  }

  ExecuteDispositionRequest._();

  factory ExecuteDispositionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExecuteDispositionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecuteDispositionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..aOS(2, _omitFieldNames ? '' : 'certificate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteDispositionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteDispositionRequest copyWith(
          void Function(ExecuteDispositionRequest) updates) =>
      super.copyWith((message) => updates(message as ExecuteDispositionRequest))
          as ExecuteDispositionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExecuteDispositionRequest create() => ExecuteDispositionRequest._();
  @$core.override
  ExecuteDispositionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExecuteDispositionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExecuteDispositionRequest>(create);
  static ExecuteDispositionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);

  /// The destruction certificate's reference.
  @$pb.TagNumber(2)
  $core.String get certificate => $_getSZ(1);
  @$pb.TagNumber(2)
  set certificate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCertificate() => $_has(1);
  @$pb.TagNumber(2)
  void clearCertificate() => $_clearField(2);
}

class ExecuteDispositionResponse extends $pb.GeneratedMessage {
  factory ExecuteDispositionResponse({
    DispositionList? list,
  }) {
    final result = create();
    if (list != null) result.list = list;
    return result;
  }

  ExecuteDispositionResponse._();

  factory ExecuteDispositionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExecuteDispositionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecuteDispositionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<DispositionList>(1, _omitFieldNames ? '' : 'list',
        subBuilder: DispositionList.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteDispositionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteDispositionResponse copyWith(
          void Function(ExecuteDispositionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ExecuteDispositionResponse))
          as ExecuteDispositionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExecuteDispositionResponse create() => ExecuteDispositionResponse._();
  @$core.override
  ExecuteDispositionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExecuteDispositionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExecuteDispositionResponse>(create);
  static ExecuteDispositionResponse? _defaultInstance;

  /// The holds are read again at execution. Litigation does not wait for the
  /// records office's calendar.
  @$pb.TagNumber(1)
  DispositionList get list => $_getN(0);
  @$pb.TagNumber(1)
  set list(DispositionList value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasList() => $_has(0);
  @$pb.TagNumber(1)
  void clearList() => $_clearField(1);
  @$pb.TagNumber(1)
  DispositionList ensureList() => $_ensure(0);
}

class CancelDispositionRequest extends $pb.GeneratedMessage {
  factory CancelDispositionRequest({
    $core.String? listId,
    $core.String? reason,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    if (reason != null) result.reason = reason;
    return result;
  }

  CancelDispositionRequest._();

  factory CancelDispositionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelDispositionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelDispositionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelDispositionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelDispositionRequest copyWith(
          void Function(CancelDispositionRequest) updates) =>
      super.copyWith((message) => updates(message as CancelDispositionRequest))
          as CancelDispositionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelDispositionRequest create() => CancelDispositionRequest._();
  @$core.override
  CancelDispositionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelDispositionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelDispositionRequest>(create);
  static CancelDispositionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class CancelDispositionResponse extends $pb.GeneratedMessage {
  factory CancelDispositionResponse({
    DispositionList? list,
  }) {
    final result = create();
    if (list != null) result.list = list;
    return result;
  }

  CancelDispositionResponse._();

  factory CancelDispositionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelDispositionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelDispositionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<DispositionList>(1, _omitFieldNames ? '' : 'list',
        subBuilder: DispositionList.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelDispositionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelDispositionResponse copyWith(
          void Function(CancelDispositionResponse) updates) =>
      super.copyWith((message) => updates(message as CancelDispositionResponse))
          as CancelDispositionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelDispositionResponse create() => CancelDispositionResponse._();
  @$core.override
  CancelDispositionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelDispositionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelDispositionResponse>(create);
  static CancelDispositionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DispositionList get list => $_getN(0);
  @$pb.TagNumber(1)
  set list(DispositionList value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasList() => $_has(0);
  @$pb.TagNumber(1)
  void clearList() => $_clearField(1);
  @$pb.TagNumber(1)
  DispositionList ensureList() => $_ensure(0);
}

class ListDispositionListsRequest extends $pb.GeneratedMessage {
  factory ListDispositionListsRequest({
    DispositionState? state,
    $core.String? jurisdiction,
    $core.int? pageSize,
    $core.int? pageOffset,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (jurisdiction != null) result.jurisdiction = jurisdiction;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageOffset != null) result.pageOffset = pageOffset;
    return result;
  }

  ListDispositionListsRequest._();

  factory ListDispositionListsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDispositionListsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDispositionListsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aE<DispositionState>(1, _omitFieldNames ? '' : 'state',
        enumValues: DispositionState.values)
    ..aOS(2, _omitFieldNames ? '' : 'jurisdiction')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..aI(4, _omitFieldNames ? '' : 'pageOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDispositionListsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDispositionListsRequest copyWith(
          void Function(ListDispositionListsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListDispositionListsRequest))
          as ListDispositionListsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDispositionListsRequest create() =>
      ListDispositionListsRequest._();
  @$core.override
  ListDispositionListsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDispositionListsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDispositionListsRequest>(create);
  static ListDispositionListsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  DispositionState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(DispositionState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get jurisdiction => $_getSZ(1);
  @$pb.TagNumber(2)
  set jurisdiction($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJurisdiction() => $_has(1);
  @$pb.TagNumber(2)
  void clearJurisdiction() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageOffset => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageOffset($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageOffset() => $_clearField(4);
}

class ListDispositionListsResponse extends $pb.GeneratedMessage {
  factory ListDispositionListsResponse({
    $core.Iterable<DispositionList>? lists,
  }) {
    final result = create();
    if (lists != null) result.lists.addAll(lists);
    return result;
  }

  ListDispositionListsResponse._();

  factory ListDispositionListsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDispositionListsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDispositionListsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..pPM<DispositionList>(1, _omitFieldNames ? '' : 'lists',
        subBuilder: DispositionList.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDispositionListsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDispositionListsResponse copyWith(
          void Function(ListDispositionListsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListDispositionListsResponse))
          as ListDispositionListsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDispositionListsResponse create() =>
      ListDispositionListsResponse._();
  @$core.override
  ListDispositionListsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDispositionListsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDispositionListsResponse>(create);
  static ListDispositionListsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DispositionList> get lists => $_getList(0);
}

class RegisterPhysicalRecordRequest extends $pb.GeneratedMessage {
  factory RegisterPhysicalRecordRequest({
    $core.String? reference,
    $core.String? patientId,
    $core.int? volume,
    $core.String? recordClass,
    $core.String? jurisdiction,
    $core.String? description,
    $core.String? homeLocation,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    if (patientId != null) result.patientId = patientId;
    if (volume != null) result.volume = volume;
    if (recordClass != null) result.recordClass = recordClass;
    if (jurisdiction != null) result.jurisdiction = jurisdiction;
    if (description != null) result.description = description;
    if (homeLocation != null) result.homeLocation = homeLocation;
    return result;
  }

  RegisterPhysicalRecordRequest._();

  factory RegisterPhysicalRecordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterPhysicalRecordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterPhysicalRecordRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aI(3, _omitFieldNames ? '' : 'volume')
    ..aOS(4, _omitFieldNames ? '' : 'recordClass')
    ..aOS(5, _omitFieldNames ? '' : 'jurisdiction')
    ..aOS(6, _omitFieldNames ? '' : 'description')
    ..aOS(7, _omitFieldNames ? '' : 'homeLocation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterPhysicalRecordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterPhysicalRecordRequest copyWith(
          void Function(RegisterPhysicalRecordRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RegisterPhysicalRecordRequest))
          as RegisterPhysicalRecordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterPhysicalRecordRequest create() =>
      RegisterPhysicalRecordRequest._();
  @$core.override
  RegisterPhysicalRecordRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterPhysicalRecordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterPhysicalRecordRequest>(create);
  static RegisterPhysicalRecordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reference => $_getSZ(0);
  @$pb.TagNumber(1)
  set reference($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReference() => $_has(0);
  @$pb.TagNumber(1)
  void clearReference() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get volume => $_getIZ(2);
  @$pb.TagNumber(3)
  set volume($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVolume() => $_has(2);
  @$pb.TagNumber(3)
  void clearVolume() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get recordClass => $_getSZ(3);
  @$pb.TagNumber(4)
  set recordClass($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRecordClass() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecordClass() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get jurisdiction => $_getSZ(4);
  @$pb.TagNumber(5)
  set jurisdiction($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasJurisdiction() => $_has(4);
  @$pb.TagNumber(5)
  void clearJurisdiction() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get description => $_getSZ(5);
  @$pb.TagNumber(6)
  set description($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearDescription() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get homeLocation => $_getSZ(6);
  @$pb.TagNumber(7)
  set homeLocation($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHomeLocation() => $_has(6);
  @$pb.TagNumber(7)
  void clearHomeLocation() => $_clearField(7);
}

class RegisterPhysicalRecordResponse extends $pb.GeneratedMessage {
  factory RegisterPhysicalRecordResponse({
    PhysicalRecord? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  RegisterPhysicalRecordResponse._();

  factory RegisterPhysicalRecordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterPhysicalRecordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterPhysicalRecordResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<PhysicalRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: PhysicalRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterPhysicalRecordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterPhysicalRecordResponse copyWith(
          void Function(RegisterPhysicalRecordResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RegisterPhysicalRecordResponse))
          as RegisterPhysicalRecordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterPhysicalRecordResponse create() =>
      RegisterPhysicalRecordResponse._();
  @$core.override
  RegisterPhysicalRecordResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterPhysicalRecordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterPhysicalRecordResponse>(create);
  static RegisterPhysicalRecordResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PhysicalRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(PhysicalRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  PhysicalRecord ensureRecord() => $_ensure(0);
}

class CheckOutRecordRequest extends $pb.GeneratedMessage {
  factory CheckOutRecordRequest({
    $core.String? recordId,
    $core.String? custodian,
    $core.String? location,
    $core.String? purpose,
    $0.Timestamp? dueBack,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (custodian != null) result.custodian = custodian;
    if (location != null) result.location = location;
    if (purpose != null) result.purpose = purpose;
    if (dueBack != null) result.dueBack = dueBack;
    return result;
  }

  CheckOutRecordRequest._();

  factory CheckOutRecordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckOutRecordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckOutRecordRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'custodian')
    ..aOS(3, _omitFieldNames ? '' : 'location')
    ..aOS(4, _omitFieldNames ? '' : 'purpose')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'dueBack',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckOutRecordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckOutRecordRequest copyWith(
          void Function(CheckOutRecordRequest) updates) =>
      super.copyWith((message) => updates(message as CheckOutRecordRequest))
          as CheckOutRecordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckOutRecordRequest create() => CheckOutRecordRequest._();
  @$core.override
  CheckOutRecordRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckOutRecordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckOutRecordRequest>(create);
  static CheckOutRecordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get custodian => $_getSZ(1);
  @$pb.TagNumber(2)
  set custodian($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCustodian() => $_has(1);
  @$pb.TagNumber(2)
  void clearCustodian() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get location => $_getSZ(2);
  @$pb.TagNumber(3)
  set location($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocation() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get purpose => $_getSZ(3);
  @$pb.TagNumber(4)
  set purpose($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPurpose() => $_has(3);
  @$pb.TagNumber(4)
  void clearPurpose() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get dueBack => $_getN(4);
  @$pb.TagNumber(5)
  set dueBack($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDueBack() => $_has(4);
  @$pb.TagNumber(5)
  void clearDueBack() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureDueBack() => $_ensure(4);
}

class CheckOutRecordResponse extends $pb.GeneratedMessage {
  factory CheckOutRecordResponse({
    PhysicalRecord? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  CheckOutRecordResponse._();

  factory CheckOutRecordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckOutRecordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckOutRecordResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<PhysicalRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: PhysicalRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckOutRecordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckOutRecordResponse copyWith(
          void Function(CheckOutRecordResponse) updates) =>
      super.copyWith((message) => updates(message as CheckOutRecordResponse))
          as CheckOutRecordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckOutRecordResponse create() => CheckOutRecordResponse._();
  @$core.override
  CheckOutRecordResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckOutRecordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckOutRecordResponse>(create);
  static CheckOutRecordResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PhysicalRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(PhysicalRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  PhysicalRecord ensureRecord() => $_ensure(0);
}

class CheckInRecordRequest extends $pb.GeneratedMessage {
  factory CheckInRecordRequest({
    $core.String? recordId,
    $core.String? location,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (location != null) result.location = location;
    return result;
  }

  CheckInRecordRequest._();

  factory CheckInRecordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckInRecordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckInRecordRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'location')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckInRecordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckInRecordRequest copyWith(void Function(CheckInRecordRequest) updates) =>
      super.copyWith((message) => updates(message as CheckInRecordRequest))
          as CheckInRecordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckInRecordRequest create() => CheckInRecordRequest._();
  @$core.override
  CheckInRecordRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckInRecordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckInRecordRequest>(create);
  static CheckInRecordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get location => $_getSZ(1);
  @$pb.TagNumber(2)
  set location($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocation() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocation() => $_clearField(2);
}

class CheckInRecordResponse extends $pb.GeneratedMessage {
  factory CheckInRecordResponse({
    PhysicalRecord? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  CheckInRecordResponse._();

  factory CheckInRecordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckInRecordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckInRecordResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<PhysicalRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: PhysicalRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckInRecordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckInRecordResponse copyWith(
          void Function(CheckInRecordResponse) updates) =>
      super.copyWith((message) => updates(message as CheckInRecordResponse))
          as CheckInRecordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckInRecordResponse create() => CheckInRecordResponse._();
  @$core.override
  CheckInRecordResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckInRecordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckInRecordResponse>(create);
  static CheckInRecordResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PhysicalRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(PhysicalRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  PhysicalRecord ensureRecord() => $_ensure(0);
}

class MarkRecordMissingRequest extends $pb.GeneratedMessage {
  factory MarkRecordMissingRequest({
    $core.String? recordId,
    $core.String? reason,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (reason != null) result.reason = reason;
    return result;
  }

  MarkRecordMissingRequest._();

  factory MarkRecordMissingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MarkRecordMissingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkRecordMissingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkRecordMissingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkRecordMissingRequest copyWith(
          void Function(MarkRecordMissingRequest) updates) =>
      super.copyWith((message) => updates(message as MarkRecordMissingRequest))
          as MarkRecordMissingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarkRecordMissingRequest create() => MarkRecordMissingRequest._();
  @$core.override
  MarkRecordMissingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MarkRecordMissingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkRecordMissingRequest>(create);
  static MarkRecordMissingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class MarkRecordMissingResponse extends $pb.GeneratedMessage {
  factory MarkRecordMissingResponse({
    PhysicalRecord? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  MarkRecordMissingResponse._();

  factory MarkRecordMissingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MarkRecordMissingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkRecordMissingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<PhysicalRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: PhysicalRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkRecordMissingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkRecordMissingResponse copyWith(
          void Function(MarkRecordMissingResponse) updates) =>
      super.copyWith((message) => updates(message as MarkRecordMissingResponse))
          as MarkRecordMissingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarkRecordMissingResponse create() => MarkRecordMissingResponse._();
  @$core.override
  MarkRecordMissingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MarkRecordMissingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkRecordMissingResponse>(create);
  static MarkRecordMissingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PhysicalRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(PhysicalRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  PhysicalRecord ensureRecord() => $_ensure(0);
}

class ArchiveRecordRequest extends $pb.GeneratedMessage {
  factory ArchiveRecordRequest({
    $core.String? recordId,
    $core.String? location,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (location != null) result.location = location;
    return result;
  }

  ArchiveRecordRequest._();

  factory ArchiveRecordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ArchiveRecordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArchiveRecordRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'location')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArchiveRecordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArchiveRecordRequest copyWith(void Function(ArchiveRecordRequest) updates) =>
      super.copyWith((message) => updates(message as ArchiveRecordRequest))
          as ArchiveRecordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ArchiveRecordRequest create() => ArchiveRecordRequest._();
  @$core.override
  ArchiveRecordRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ArchiveRecordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArchiveRecordRequest>(create);
  static ArchiveRecordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get location => $_getSZ(1);
  @$pb.TagNumber(2)
  set location($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocation() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocation() => $_clearField(2);
}

class ArchiveRecordResponse extends $pb.GeneratedMessage {
  factory ArchiveRecordResponse({
    PhysicalRecord? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  ArchiveRecordResponse._();

  factory ArchiveRecordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ArchiveRecordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArchiveRecordResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<PhysicalRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: PhysicalRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArchiveRecordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArchiveRecordResponse copyWith(
          void Function(ArchiveRecordResponse) updates) =>
      super.copyWith((message) => updates(message as ArchiveRecordResponse))
          as ArchiveRecordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ArchiveRecordResponse create() => ArchiveRecordResponse._();
  @$core.override
  ArchiveRecordResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ArchiveRecordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArchiveRecordResponse>(create);
  static ArchiveRecordResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PhysicalRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(PhysicalRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  PhysicalRecord ensureRecord() => $_ensure(0);
}

class ListPhysicalRecordsRequest extends $pb.GeneratedMessage {
  factory ListPhysicalRecordsRequest({
    $core.String? patientId,
    PhysicalState? state,
    $core.bool? outOnly,
    $core.bool? overdueOnly,
    $core.int? pageSize,
    $core.int? pageOffset,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (state != null) result.state = state;
    if (outOnly != null) result.outOnly = outOnly;
    if (overdueOnly != null) result.overdueOnly = overdueOnly;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageOffset != null) result.pageOffset = pageOffset;
    return result;
  }

  ListPhysicalRecordsRequest._();

  factory ListPhysicalRecordsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPhysicalRecordsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPhysicalRecordsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aE<PhysicalState>(2, _omitFieldNames ? '' : 'state',
        enumValues: PhysicalState.values)
    ..aOB(3, _omitFieldNames ? '' : 'outOnly')
    ..aOB(4, _omitFieldNames ? '' : 'overdueOnly')
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..aI(6, _omitFieldNames ? '' : 'pageOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPhysicalRecordsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPhysicalRecordsRequest copyWith(
          void Function(ListPhysicalRecordsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListPhysicalRecordsRequest))
          as ListPhysicalRecordsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPhysicalRecordsRequest create() => ListPhysicalRecordsRequest._();
  @$core.override
  ListPhysicalRecordsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPhysicalRecordsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPhysicalRecordsRequest>(create);
  static ListPhysicalRecordsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  PhysicalState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(PhysicalState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get outOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set outOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOutOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutOnly() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get overdueOnly => $_getBF(3);
  @$pb.TagNumber(4)
  set overdueOnly($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOverdueOnly() => $_has(3);
  @$pb.TagNumber(4)
  void clearOverdueOnly() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get pageOffset => $_getIZ(5);
  @$pb.TagNumber(6)
  set pageOffset($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageOffset() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageOffset() => $_clearField(6);
}

class ListPhysicalRecordsResponse extends $pb.GeneratedMessage {
  factory ListPhysicalRecordsResponse({
    $core.Iterable<PhysicalRecord>? records,
  }) {
    final result = create();
    if (records != null) result.records.addAll(records);
    return result;
  }

  ListPhysicalRecordsResponse._();

  factory ListPhysicalRecordsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPhysicalRecordsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPhysicalRecordsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..pPM<PhysicalRecord>(1, _omitFieldNames ? '' : 'records',
        subBuilder: PhysicalRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPhysicalRecordsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPhysicalRecordsResponse copyWith(
          void Function(ListPhysicalRecordsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListPhysicalRecordsResponse))
          as ListPhysicalRecordsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPhysicalRecordsResponse create() =>
      ListPhysicalRecordsResponse._();
  @$core.override
  ListPhysicalRecordsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPhysicalRecordsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPhysicalRecordsResponse>(create);
  static ListPhysicalRecordsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PhysicalRecord> get records => $_getList(0);
}

class DraftCertificateFormRequest extends $pb.GeneratedMessage {
  factory DraftCertificateFormRequest({
    $core.String? code,
    $core.String? name,
    $core.int? revision,
    CertificateKind? kind,
    $core.String? jurisdiction,
    $core.Iterable<CertificateField>? fields,
    $core.String? issuerRole,
    $0.Timestamp? effectiveFrom,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (revision != null) result.revision = revision;
    if (kind != null) result.kind = kind;
    if (jurisdiction != null) result.jurisdiction = jurisdiction;
    if (fields != null) result.fields.addAll(fields);
    if (issuerRole != null) result.issuerRole = issuerRole;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    return result;
  }

  DraftCertificateFormRequest._();

  factory DraftCertificateFormRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DraftCertificateFormRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DraftCertificateFormRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'revision')
    ..aE<CertificateKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: CertificateKind.values)
    ..aOS(5, _omitFieldNames ? '' : 'jurisdiction')
    ..pPM<CertificateField>(6, _omitFieldNames ? '' : 'fields',
        subBuilder: CertificateField.create)
    ..aOS(7, _omitFieldNames ? '' : 'issuerRole')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftCertificateFormRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftCertificateFormRequest copyWith(
          void Function(DraftCertificateFormRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DraftCertificateFormRequest))
          as DraftCertificateFormRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DraftCertificateFormRequest create() =>
      DraftCertificateFormRequest._();
  @$core.override
  DraftCertificateFormRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DraftCertificateFormRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DraftCertificateFormRequest>(create);
  static DraftCertificateFormRequest? _defaultInstance;

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
  $core.int get revision => $_getIZ(2);
  @$pb.TagNumber(3)
  set revision($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  CertificateKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(CertificateKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get jurisdiction => $_getSZ(4);
  @$pb.TagNumber(5)
  set jurisdiction($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasJurisdiction() => $_has(4);
  @$pb.TagNumber(5)
  void clearJurisdiction() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<CertificateField> get fields => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get issuerRole => $_getSZ(6);
  @$pb.TagNumber(7)
  set issuerRole($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIssuerRole() => $_has(6);
  @$pb.TagNumber(7)
  void clearIssuerRole() => $_clearField(7);

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
}

class DraftCertificateFormResponse extends $pb.GeneratedMessage {
  factory DraftCertificateFormResponse({
    CertificateForm? form,
  }) {
    final result = create();
    if (form != null) result.form = form;
    return result;
  }

  DraftCertificateFormResponse._();

  factory DraftCertificateFormResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DraftCertificateFormResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DraftCertificateFormResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<CertificateForm>(1, _omitFieldNames ? '' : 'form',
        subBuilder: CertificateForm.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftCertificateFormResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftCertificateFormResponse copyWith(
          void Function(DraftCertificateFormResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DraftCertificateFormResponse))
          as DraftCertificateFormResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DraftCertificateFormResponse create() =>
      DraftCertificateFormResponse._();
  @$core.override
  DraftCertificateFormResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DraftCertificateFormResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DraftCertificateFormResponse>(create);
  static DraftCertificateFormResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CertificateForm get form => $_getN(0);
  @$pb.TagNumber(1)
  set form(CertificateForm value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasForm() => $_has(0);
  @$pb.TagNumber(1)
  void clearForm() => $_clearField(1);
  @$pb.TagNumber(1)
  CertificateForm ensureForm() => $_ensure(0);
}

class ApproveCertificateFormRequest extends $pb.GeneratedMessage {
  factory ApproveCertificateFormRequest({
    $core.String? formId,
    $0.Timestamp? effectiveFrom,
  }) {
    final result = create();
    if (formId != null) result.formId = formId;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    return result;
  }

  ApproveCertificateFormRequest._();

  factory ApproveCertificateFormRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveCertificateFormRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveCertificateFormRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'formId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveCertificateFormRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveCertificateFormRequest copyWith(
          void Function(ApproveCertificateFormRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ApproveCertificateFormRequest))
          as ApproveCertificateFormRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveCertificateFormRequest create() =>
      ApproveCertificateFormRequest._();
  @$core.override
  ApproveCertificateFormRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveCertificateFormRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveCertificateFormRequest>(create);
  static ApproveCertificateFormRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get formId => $_getSZ(0);
  @$pb.TagNumber(1)
  set formId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFormId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFormId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get effectiveFrom => $_getN(1);
  @$pb.TagNumber(2)
  set effectiveFrom($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEffectiveFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearEffectiveFrom() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(1);
}

class ApproveCertificateFormResponse extends $pb.GeneratedMessage {
  factory ApproveCertificateFormResponse({
    CertificateForm? form,
  }) {
    final result = create();
    if (form != null) result.form = form;
    return result;
  }

  ApproveCertificateFormResponse._();

  factory ApproveCertificateFormResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveCertificateFormResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveCertificateFormResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<CertificateForm>(1, _omitFieldNames ? '' : 'form',
        subBuilder: CertificateForm.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveCertificateFormResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveCertificateFormResponse copyWith(
          void Function(ApproveCertificateFormResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ApproveCertificateFormResponse))
          as ApproveCertificateFormResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveCertificateFormResponse create() =>
      ApproveCertificateFormResponse._();
  @$core.override
  ApproveCertificateFormResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveCertificateFormResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveCertificateFormResponse>(create);
  static ApproveCertificateFormResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CertificateForm get form => $_getN(0);
  @$pb.TagNumber(1)
  set form(CertificateForm value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasForm() => $_has(0);
  @$pb.TagNumber(1)
  void clearForm() => $_clearField(1);
  @$pb.TagNumber(1)
  CertificateForm ensureForm() => $_ensure(0);
}

class ListCertificateFormsRequest extends $pb.GeneratedMessage {
  factory ListCertificateFormsRequest({
    CertificateKind? kind,
    $core.String? jurisdiction,
    $core.bool? liveOnly,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (jurisdiction != null) result.jurisdiction = jurisdiction;
    if (liveOnly != null) result.liveOnly = liveOnly;
    return result;
  }

  ListCertificateFormsRequest._();

  factory ListCertificateFormsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCertificateFormsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCertificateFormsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aE<CertificateKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: CertificateKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'jurisdiction')
    ..aOB(3, _omitFieldNames ? '' : 'liveOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCertificateFormsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCertificateFormsRequest copyWith(
          void Function(ListCertificateFormsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListCertificateFormsRequest))
          as ListCertificateFormsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCertificateFormsRequest create() =>
      ListCertificateFormsRequest._();
  @$core.override
  ListCertificateFormsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCertificateFormsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCertificateFormsRequest>(create);
  static ListCertificateFormsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CertificateKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(CertificateKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get jurisdiction => $_getSZ(1);
  @$pb.TagNumber(2)
  set jurisdiction($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJurisdiction() => $_has(1);
  @$pb.TagNumber(2)
  void clearJurisdiction() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get liveOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set liveOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLiveOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearLiveOnly() => $_clearField(3);
}

class ListCertificateFormsResponse extends $pb.GeneratedMessage {
  factory ListCertificateFormsResponse({
    $core.Iterable<CertificateForm>? forms,
  }) {
    final result = create();
    if (forms != null) result.forms.addAll(forms);
    return result;
  }

  ListCertificateFormsResponse._();

  factory ListCertificateFormsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCertificateFormsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCertificateFormsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..pPM<CertificateForm>(1, _omitFieldNames ? '' : 'forms',
        subBuilder: CertificateForm.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCertificateFormsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCertificateFormsResponse copyWith(
          void Function(ListCertificateFormsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListCertificateFormsResponse))
          as ListCertificateFormsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCertificateFormsResponse create() =>
      ListCertificateFormsResponse._();
  @$core.override
  ListCertificateFormsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCertificateFormsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCertificateFormsResponse>(create);
  static ListCertificateFormsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CertificateForm> get forms => $_getList(0);
}

class IssueCertificateRequest extends $pb.GeneratedMessage {
  factory IssueCertificateRequest({
    CertificateKind? kind,
    $core.String? jurisdiction,
    $core.String? patientId,
    $core.String? encounterId,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? values,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? sourceRefs,
    $core.String? issuerRole,
    $core.String? issuerName,
    $core.String? serialNumber,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (jurisdiction != null) result.jurisdiction = jurisdiction;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (values != null) result.values.addEntries(values);
    if (sourceRefs != null) result.sourceRefs.addEntries(sourceRefs);
    if (issuerRole != null) result.issuerRole = issuerRole;
    if (issuerName != null) result.issuerName = issuerName;
    if (serialNumber != null) result.serialNumber = serialNumber;
    return result;
  }

  IssueCertificateRequest._();

  factory IssueCertificateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IssueCertificateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IssueCertificateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aE<CertificateKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: CertificateKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'jurisdiction')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'encounterId')
    ..m<$core.String, $core.String>(5, _omitFieldNames ? '' : 'values',
        entryClassName: 'IssueCertificateRequest.ValuesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('healthcare.records.v1'))
    ..m<$core.String, $core.String>(6, _omitFieldNames ? '' : 'sourceRefs',
        entryClassName: 'IssueCertificateRequest.SourceRefsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('healthcare.records.v1'))
    ..aOS(7, _omitFieldNames ? '' : 'issuerRole')
    ..aOS(8, _omitFieldNames ? '' : 'issuerName')
    ..aOS(9, _omitFieldNames ? '' : 'serialNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueCertificateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueCertificateRequest copyWith(
          void Function(IssueCertificateRequest) updates) =>
      super.copyWith((message) => updates(message as IssueCertificateRequest))
          as IssueCertificateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IssueCertificateRequest create() => IssueCertificateRequest._();
  @$core.override
  IssueCertificateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IssueCertificateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IssueCertificateRequest>(create);
  static IssueCertificateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CertificateKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(CertificateKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get jurisdiction => $_getSZ(1);
  @$pb.TagNumber(2)
  set jurisdiction($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJurisdiction() => $_has(1);
  @$pb.TagNumber(2)
  void clearJurisdiction() => $_clearField(2);

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
  $pb.PbMap<$core.String, $core.String> get values => $_getMap(4);

  @$pb.TagNumber(6)
  $pb.PbMap<$core.String, $core.String> get sourceRefs => $_getMap(5);

  /// Checked against the form's own issuer role. Who may sign a death
  /// certificate is a statutory question, and a permission grant is not an
  /// answer to it.
  @$pb.TagNumber(7)
  $core.String get issuerRole => $_getSZ(6);
  @$pb.TagNumber(7)
  set issuerRole($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIssuerRole() => $_has(6);
  @$pb.TagNumber(7)
  void clearIssuerRole() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get issuerName => $_getSZ(7);
  @$pb.TagNumber(8)
  set issuerName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIssuerName() => $_has(7);
  @$pb.TagNumber(8)
  void clearIssuerName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get serialNumber => $_getSZ(8);
  @$pb.TagNumber(9)
  set serialNumber($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSerialNumber() => $_has(8);
  @$pb.TagNumber(9)
  void clearSerialNumber() => $_clearField(9);
}

class IssueCertificateResponse extends $pb.GeneratedMessage {
  factory IssueCertificateResponse({
    StatutoryCertificate? certificate,
  }) {
    final result = create();
    if (certificate != null) result.certificate = certificate;
    return result;
  }

  IssueCertificateResponse._();

  factory IssueCertificateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IssueCertificateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IssueCertificateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<StatutoryCertificate>(1, _omitFieldNames ? '' : 'certificate',
        subBuilder: StatutoryCertificate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueCertificateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueCertificateResponse copyWith(
          void Function(IssueCertificateResponse) updates) =>
      super.copyWith((message) => updates(message as IssueCertificateResponse))
          as IssueCertificateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IssueCertificateResponse create() => IssueCertificateResponse._();
  @$core.override
  IssueCertificateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IssueCertificateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IssueCertificateResponse>(create);
  static IssueCertificateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StatutoryCertificate get certificate => $_getN(0);
  @$pb.TagNumber(1)
  set certificate(StatutoryCertificate value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCertificate() => $_has(0);
  @$pb.TagNumber(1)
  void clearCertificate() => $_clearField(1);
  @$pb.TagNumber(1)
  StatutoryCertificate ensureCertificate() => $_ensure(0);
}

class CorrectCertificateRequest extends $pb.GeneratedMessage {
  factory CorrectCertificateRequest({
    $core.String? certificateId,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? values,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? sourceRefs,
    $core.String? issuerRole,
    $core.String? issuerName,
    $core.String? reason,
    $core.String? serialNumber,
  }) {
    final result = create();
    if (certificateId != null) result.certificateId = certificateId;
    if (values != null) result.values.addEntries(values);
    if (sourceRefs != null) result.sourceRefs.addEntries(sourceRefs);
    if (issuerRole != null) result.issuerRole = issuerRole;
    if (issuerName != null) result.issuerName = issuerName;
    if (reason != null) result.reason = reason;
    if (serialNumber != null) result.serialNumber = serialNumber;
    return result;
  }

  CorrectCertificateRequest._();

  factory CorrectCertificateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CorrectCertificateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CorrectCertificateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'certificateId')
    ..m<$core.String, $core.String>(2, _omitFieldNames ? '' : 'values',
        entryClassName: 'CorrectCertificateRequest.ValuesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('healthcare.records.v1'))
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'sourceRefs',
        entryClassName: 'CorrectCertificateRequest.SourceRefsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('healthcare.records.v1'))
    ..aOS(4, _omitFieldNames ? '' : 'issuerRole')
    ..aOS(5, _omitFieldNames ? '' : 'issuerName')
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..aOS(7, _omitFieldNames ? '' : 'serialNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorrectCertificateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorrectCertificateRequest copyWith(
          void Function(CorrectCertificateRequest) updates) =>
      super.copyWith((message) => updates(message as CorrectCertificateRequest))
          as CorrectCertificateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CorrectCertificateRequest create() => CorrectCertificateRequest._();
  @$core.override
  CorrectCertificateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CorrectCertificateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CorrectCertificateRequest>(create);
  static CorrectCertificateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get certificateId => $_getSZ(0);
  @$pb.TagNumber(1)
  set certificateId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCertificateId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCertificateId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.String> get values => $_getMap(1);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get sourceRefs => $_getMap(2);

  @$pb.TagNumber(4)
  $core.String get issuerRole => $_getSZ(3);
  @$pb.TagNumber(4)
  set issuerRole($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIssuerRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearIssuerRole() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get issuerName => $_getSZ(4);
  @$pb.TagNumber(5)
  set issuerName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIssuerName() => $_has(4);
  @$pb.TagNumber(5)
  void clearIssuerName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get serialNumber => $_getSZ(6);
  @$pb.TagNumber(7)
  set serialNumber($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSerialNumber() => $_has(6);
  @$pb.TagNumber(7)
  void clearSerialNumber() => $_clearField(7);
}

class CorrectCertificateResponse extends $pb.GeneratedMessage {
  factory CorrectCertificateResponse({
    StatutoryCertificate? certificate,
  }) {
    final result = create();
    if (certificate != null) result.certificate = certificate;
    return result;
  }

  CorrectCertificateResponse._();

  factory CorrectCertificateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CorrectCertificateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CorrectCertificateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<StatutoryCertificate>(1, _omitFieldNames ? '' : 'certificate',
        subBuilder: StatutoryCertificate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorrectCertificateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorrectCertificateResponse copyWith(
          void Function(CorrectCertificateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CorrectCertificateResponse))
          as CorrectCertificateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CorrectCertificateResponse create() => CorrectCertificateResponse._();
  @$core.override
  CorrectCertificateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CorrectCertificateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CorrectCertificateResponse>(create);
  static CorrectCertificateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StatutoryCertificate get certificate => $_getN(0);
  @$pb.TagNumber(1)
  set certificate(StatutoryCertificate value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCertificate() => $_has(0);
  @$pb.TagNumber(1)
  void clearCertificate() => $_clearField(1);
  @$pb.TagNumber(1)
  StatutoryCertificate ensureCertificate() => $_ensure(0);
}

class VoidCertificateRequest extends $pb.GeneratedMessage {
  factory VoidCertificateRequest({
    $core.String? certificateId,
    $core.String? reason,
  }) {
    final result = create();
    if (certificateId != null) result.certificateId = certificateId;
    if (reason != null) result.reason = reason;
    return result;
  }

  VoidCertificateRequest._();

  factory VoidCertificateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VoidCertificateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoidCertificateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'certificateId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoidCertificateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoidCertificateRequest copyWith(
          void Function(VoidCertificateRequest) updates) =>
      super.copyWith((message) => updates(message as VoidCertificateRequest))
          as VoidCertificateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VoidCertificateRequest create() => VoidCertificateRequest._();
  @$core.override
  VoidCertificateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VoidCertificateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VoidCertificateRequest>(create);
  static VoidCertificateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get certificateId => $_getSZ(0);
  @$pb.TagNumber(1)
  set certificateId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCertificateId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCertificateId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class VoidCertificateResponse extends $pb.GeneratedMessage {
  factory VoidCertificateResponse({
    StatutoryCertificate? certificate,
  }) {
    final result = create();
    if (certificate != null) result.certificate = certificate;
    return result;
  }

  VoidCertificateResponse._();

  factory VoidCertificateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VoidCertificateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoidCertificateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOM<StatutoryCertificate>(1, _omitFieldNames ? '' : 'certificate',
        subBuilder: StatutoryCertificate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoidCertificateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoidCertificateResponse copyWith(
          void Function(VoidCertificateResponse) updates) =>
      super.copyWith((message) => updates(message as VoidCertificateResponse))
          as VoidCertificateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VoidCertificateResponse create() => VoidCertificateResponse._();
  @$core.override
  VoidCertificateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VoidCertificateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VoidCertificateResponse>(create);
  static VoidCertificateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StatutoryCertificate get certificate => $_getN(0);
  @$pb.TagNumber(1)
  set certificate(StatutoryCertificate value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCertificate() => $_has(0);
  @$pb.TagNumber(1)
  void clearCertificate() => $_clearField(1);
  @$pb.TagNumber(1)
  StatutoryCertificate ensureCertificate() => $_ensure(0);
}

class ListCertificatesRequest extends $pb.GeneratedMessage {
  factory ListCertificatesRequest({
    $core.String? patientId,
    CertificateKind? kind,
    CertificateState? state,
    $core.int? pageSize,
    $core.int? pageOffset,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (kind != null) result.kind = kind;
    if (state != null) result.state = state;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageOffset != null) result.pageOffset = pageOffset;
    return result;
  }

  ListCertificatesRequest._();

  factory ListCertificatesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCertificatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCertificatesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aE<CertificateKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: CertificateKind.values)
    ..aE<CertificateState>(3, _omitFieldNames ? '' : 'state',
        enumValues: CertificateState.values)
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..aI(5, _omitFieldNames ? '' : 'pageOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCertificatesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCertificatesRequest copyWith(
          void Function(ListCertificatesRequest) updates) =>
      super.copyWith((message) => updates(message as ListCertificatesRequest))
          as ListCertificatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCertificatesRequest create() => ListCertificatesRequest._();
  @$core.override
  ListCertificatesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCertificatesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCertificatesRequest>(create);
  static ListCertificatesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  CertificateKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(CertificateKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  CertificateState get state => $_getN(2);
  @$pb.TagNumber(3)
  set state(CertificateState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageOffset => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageOffset($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageOffset() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageOffset() => $_clearField(5);
}

class ListCertificatesResponse extends $pb.GeneratedMessage {
  factory ListCertificatesResponse({
    $core.Iterable<StatutoryCertificate>? certificates,
  }) {
    final result = create();
    if (certificates != null) result.certificates.addAll(certificates);
    return result;
  }

  ListCertificatesResponse._();

  factory ListCertificatesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCertificatesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCertificatesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.records.v1'),
      createEmptyInstance: create)
    ..pPM<StatutoryCertificate>(1, _omitFieldNames ? '' : 'certificates',
        subBuilder: StatutoryCertificate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCertificatesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCertificatesResponse copyWith(
          void Function(ListCertificatesResponse) updates) =>
      super.copyWith((message) => updates(message as ListCertificatesResponse))
          as ListCertificatesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCertificatesResponse create() => ListCertificatesResponse._();
  @$core.override
  ListCertificatesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCertificatesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCertificatesResponse>(create);
  static ListCertificatesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StatutoryCertificate> get certificates => $_getList(0);
}

/// The medical records and health information management service.
class RecordsServiceApi {
  final $pb.RpcClient _client;

  RecordsServiceApi(this._client);

  /// Chart completion (SRS-MRD-001).
  $async.Future<DraftChecklistResponse> draftChecklist(
          $pb.ClientContext? ctx, DraftChecklistRequest request) =>
      _client.invoke<DraftChecklistResponse>(ctx, 'RecordsService',
          'DraftChecklist', request, DraftChecklistResponse());
  $async.Future<ApproveChecklistResponse> approveChecklist(
          $pb.ClientContext? ctx, ApproveChecklistRequest request) =>
      _client.invoke<ApproveChecklistResponse>(ctx, 'RecordsService',
          'ApproveChecklist', request, ApproveChecklistResponse());
  $async.Future<ListChecklistsResponse> listChecklists(
          $pb.ClientContext? ctx, ListChecklistsRequest request) =>
      _client.invoke<ListChecklistsResponse>(ctx, 'RecordsService',
          'ListChecklists', request, ListChecklistsResponse());
  $async.Future<GetChartGapsResponse> getChartGaps(
          $pb.ClientContext? ctx, GetChartGapsRequest request) =>
      _client.invoke<GetChartGapsResponse>(ctx, 'RecordsService',
          'GetChartGaps', request, GetChartGapsResponse());

  /// Deficiencies (SRS-MRD-002, SRS-MRD-008).
  $async.Future<RaiseDeficienciesResponse> raiseDeficiencies(
          $pb.ClientContext? ctx, RaiseDeficienciesRequest request) =>
      _client.invoke<RaiseDeficienciesResponse>(ctx, 'RecordsService',
          'RaiseDeficiencies', request, RaiseDeficienciesResponse());
  $async.Future<RaiseCodingQueryResponse> raiseCodingQuery(
          $pb.ClientContext? ctx, RaiseCodingQueryRequest request) =>
      _client.invoke<RaiseCodingQueryResponse>(ctx, 'RecordsService',
          'RaiseCodingQuery', request, RaiseCodingQueryResponse());
  $async.Future<ResolveDeficiencyResponse> resolveDeficiency(
          $pb.ClientContext? ctx, ResolveDeficiencyRequest request) =>
      _client.invoke<ResolveDeficiencyResponse>(ctx, 'RecordsService',
          'ResolveDeficiency', request, ResolveDeficiencyResponse());
  $async.Future<WaiveDeficiencyResponse> waiveDeficiency(
          $pb.ClientContext? ctx, WaiveDeficiencyRequest request) =>
      _client.invoke<WaiveDeficiencyResponse>(ctx, 'RecordsService',
          'WaiveDeficiency', request, WaiveDeficiencyResponse());
  $async.Future<ReassignDeficiencyResponse> reassignDeficiency(
          $pb.ClientContext? ctx, ReassignDeficiencyRequest request) =>
      _client.invoke<ReassignDeficiencyResponse>(ctx, 'RecordsService',
          'ReassignDeficiency', request, ReassignDeficiencyResponse());
  $async.Future<ListDeficienciesResponse> listDeficiencies(
          $pb.ClientContext? ctx, ListDeficienciesRequest request) =>
      _client.invoke<ListDeficienciesResponse>(ctx, 'RecordsService',
          'ListDeficiencies', request, ListDeficienciesResponse());
  $async.Future<GetAgingReportResponse> getAgingReport(
          $pb.ClientContext? ctx, GetAgingReportRequest request) =>
      _client.invoke<GetAgingReportResponse>(ctx, 'RecordsService',
          'GetAgingReport', request, GetAgingReportResponse());
  $async.Future<GetCompletionSummaryResponse> getCompletionSummary(
          $pb.ClientContext? ctx, GetCompletionSummaryRequest request) =>
      _client.invoke<GetCompletionSummaryResponse>(ctx, 'RecordsService',
          'GetCompletionSummary', request, GetCompletionSummaryResponse());
  $async.Future<EscalateOverdueDeficienciesResponse>
      escalateOverdueDeficiencies($pb.ClientContext? ctx,
              EscalateOverdueDeficienciesRequest request) =>
          _client.invoke<EscalateOverdueDeficienciesResponse>(
              ctx,
              'RecordsService',
              'EscalateOverdueDeficiencies',
              request,
              EscalateOverdueDeficienciesResponse());

  /// Clinical coding (SRS-MRD-003).
  $async.Future<AssignCodesResponse> assignCodes(
          $pb.ClientContext? ctx, AssignCodesRequest request) =>
      _client.invoke<AssignCodesResponse>(
          ctx, 'RecordsService', 'AssignCodes', request, AssignCodesResponse());
  $async.Future<FinaliseCodingResponse> finaliseCoding(
          $pb.ClientContext? ctx, FinaliseCodingRequest request) =>
      _client.invoke<FinaliseCodingResponse>(ctx, 'RecordsService',
          'FinaliseCoding', request, FinaliseCodingResponse());
  $async.Future<QueryCodingResponse> queryCoding(
          $pb.ClientContext? ctx, QueryCodingRequest request) =>
      _client.invoke<QueryCodingResponse>(
          ctx, 'RecordsService', 'QueryCoding', request, QueryCodingResponse());
  $async.Future<GetCodedEpisodeResponse> getCodedEpisode(
          $pb.ClientContext? ctx, GetCodedEpisodeRequest request) =>
      _client.invoke<GetCodedEpisodeResponse>(ctx, 'RecordsService',
          'GetCodedEpisode', request, GetCodedEpisodeResponse());
  $async.Future<GetCodingDiffResponse> getCodingDiff(
          $pb.ClientContext? ctx, GetCodingDiffRequest request) =>
      _client.invoke<GetCodingDiffResponse>(ctx, 'RecordsService',
          'GetCodingDiff', request, GetCodingDiffResponse());

  /// Record release and the accounting of disclosures (SRS-MRD-004,
  /// SRS-MRD-010).
  $async.Future<RequestReleaseResponse> requestRelease(
          $pb.ClientContext? ctx, RequestReleaseRequest request) =>
      _client.invoke<RequestReleaseResponse>(ctx, 'RecordsService',
          'RequestRelease', request, RequestReleaseResponse());
  $async.Future<ApproveReleaseResponse> approveRelease(
          $pb.ClientContext? ctx, ApproveReleaseRequest request) =>
      _client.invoke<ApproveReleaseResponse>(ctx, 'RecordsService',
          'ApproveRelease', request, ApproveReleaseResponse());
  $async.Future<RefuseReleaseResponse> refuseRelease(
          $pb.ClientContext? ctx, RefuseReleaseRequest request) =>
      _client.invoke<RefuseReleaseResponse>(ctx, 'RecordsService',
          'RefuseRelease', request, RefuseReleaseResponse());
  $async.Future<AssembleReleaseResponse> assembleRelease(
          $pb.ClientContext? ctx, AssembleReleaseRequest request) =>
      _client.invoke<AssembleReleaseResponse>(ctx, 'RecordsService',
          'AssembleRelease', request, AssembleReleaseResponse());
  $async.Future<SendReleaseResponse> sendRelease(
          $pb.ClientContext? ctx, SendReleaseRequest request) =>
      _client.invoke<SendReleaseResponse>(
          ctx, 'RecordsService', 'SendRelease', request, SendReleaseResponse());
  $async.Future<ListReleasesResponse> listReleases(
          $pb.ClientContext? ctx, ListReleasesRequest request) =>
      _client.invoke<ListReleasesResponse>(ctx, 'RecordsService',
          'ListReleases', request, ListReleasesResponse());
  $async.Future<RecordDisclosureResponse> recordDisclosure(
          $pb.ClientContext? ctx, RecordDisclosureRequest request) =>
      _client.invoke<RecordDisclosureResponse>(ctx, 'RecordsService',
          'RecordDisclosure', request, RecordDisclosureResponse());
  $async.Future<ListDisclosuresResponse> listDisclosures(
          $pb.ClientContext? ctx, ListDisclosuresRequest request) =>
      _client.invoke<ListDisclosuresResponse>(ctx, 'RecordsService',
          'ListDisclosures', request, ListDisclosuresResponse());

  /// Retention, legal holds and disposition (SRS-MRD-005, SRS-MRD-009).
  $async.Future<DraftRetentionRuleResponse> draftRetentionRule(
          $pb.ClientContext? ctx, DraftRetentionRuleRequest request) =>
      _client.invoke<DraftRetentionRuleResponse>(ctx, 'RecordsService',
          'DraftRetentionRule', request, DraftRetentionRuleResponse());
  $async.Future<ApproveRetentionRuleResponse> approveRetentionRule(
          $pb.ClientContext? ctx, ApproveRetentionRuleRequest request) =>
      _client.invoke<ApproveRetentionRuleResponse>(ctx, 'RecordsService',
          'ApproveRetentionRule', request, ApproveRetentionRuleResponse());
  $async.Future<ListRetentionRulesResponse> listRetentionRules(
          $pb.ClientContext? ctx, ListRetentionRulesRequest request) =>
      _client.invoke<ListRetentionRulesResponse>(ctx, 'RecordsService',
          'ListRetentionRules', request, ListRetentionRulesResponse());
  $async.Future<PlaceHoldResponse> placeHold(
          $pb.ClientContext? ctx, PlaceHoldRequest request) =>
      _client.invoke<PlaceHoldResponse>(
          ctx, 'RecordsService', 'PlaceHold', request, PlaceHoldResponse());
  $async.Future<ReleaseHoldResponse> releaseHold(
          $pb.ClientContext? ctx, ReleaseHoldRequest request) =>
      _client.invoke<ReleaseHoldResponse>(
          ctx, 'RecordsService', 'ReleaseHold', request, ReleaseHoldResponse());
  $async.Future<SweepForDispositionResponse> sweepForDisposition(
          $pb.ClientContext? ctx, SweepForDispositionRequest request) =>
      _client.invoke<SweepForDispositionResponse>(ctx, 'RecordsService',
          'SweepForDisposition', request, SweepForDispositionResponse());
  $async.Future<PrepareDispositionResponse> prepareDisposition(
          $pb.ClientContext? ctx, PrepareDispositionRequest request) =>
      _client.invoke<PrepareDispositionResponse>(ctx, 'RecordsService',
          'PrepareDisposition', request, PrepareDispositionResponse());
  $async.Future<ApproveDispositionResponse> approveDisposition(
          $pb.ClientContext? ctx, ApproveDispositionRequest request) =>
      _client.invoke<ApproveDispositionResponse>(ctx, 'RecordsService',
          'ApproveDisposition', request, ApproveDispositionResponse());
  $async.Future<ExecuteDispositionResponse> executeDisposition(
          $pb.ClientContext? ctx, ExecuteDispositionRequest request) =>
      _client.invoke<ExecuteDispositionResponse>(ctx, 'RecordsService',
          'ExecuteDisposition', request, ExecuteDispositionResponse());
  $async.Future<CancelDispositionResponse> cancelDisposition(
          $pb.ClientContext? ctx, CancelDispositionRequest request) =>
      _client.invoke<CancelDispositionResponse>(ctx, 'RecordsService',
          'CancelDisposition', request, CancelDispositionResponse());
  $async.Future<ListDispositionListsResponse> listDispositionLists(
          $pb.ClientContext? ctx, ListDispositionListsRequest request) =>
      _client.invoke<ListDispositionListsResponse>(ctx, 'RecordsService',
          'ListDispositionLists', request, ListDispositionListsResponse());

  /// Physical record tracking (SRS-MRD-006).
  $async.Future<RegisterPhysicalRecordResponse> registerPhysicalRecord(
          $pb.ClientContext? ctx, RegisterPhysicalRecordRequest request) =>
      _client.invoke<RegisterPhysicalRecordResponse>(ctx, 'RecordsService',
          'RegisterPhysicalRecord', request, RegisterPhysicalRecordResponse());
  $async.Future<CheckOutRecordResponse> checkOutRecord(
          $pb.ClientContext? ctx, CheckOutRecordRequest request) =>
      _client.invoke<CheckOutRecordResponse>(ctx, 'RecordsService',
          'CheckOutRecord', request, CheckOutRecordResponse());
  $async.Future<CheckInRecordResponse> checkInRecord(
          $pb.ClientContext? ctx, CheckInRecordRequest request) =>
      _client.invoke<CheckInRecordResponse>(ctx, 'RecordsService',
          'CheckInRecord', request, CheckInRecordResponse());
  $async.Future<MarkRecordMissingResponse> markRecordMissing(
          $pb.ClientContext? ctx, MarkRecordMissingRequest request) =>
      _client.invoke<MarkRecordMissingResponse>(ctx, 'RecordsService',
          'MarkRecordMissing', request, MarkRecordMissingResponse());
  $async.Future<ArchiveRecordResponse> archiveRecord(
          $pb.ClientContext? ctx, ArchiveRecordRequest request) =>
      _client.invoke<ArchiveRecordResponse>(ctx, 'RecordsService',
          'ArchiveRecord', request, ArchiveRecordResponse());
  $async.Future<ListPhysicalRecordsResponse> listPhysicalRecords(
          $pb.ClientContext? ctx, ListPhysicalRecordsRequest request) =>
      _client.invoke<ListPhysicalRecordsResponse>(ctx, 'RecordsService',
          'ListPhysicalRecords', request, ListPhysicalRecordsResponse());

  /// Statutory certificates (SRS-MRD-007).
  $async.Future<DraftCertificateFormResponse> draftCertificateForm(
          $pb.ClientContext? ctx, DraftCertificateFormRequest request) =>
      _client.invoke<DraftCertificateFormResponse>(ctx, 'RecordsService',
          'DraftCertificateForm', request, DraftCertificateFormResponse());
  $async.Future<ApproveCertificateFormResponse> approveCertificateForm(
          $pb.ClientContext? ctx, ApproveCertificateFormRequest request) =>
      _client.invoke<ApproveCertificateFormResponse>(ctx, 'RecordsService',
          'ApproveCertificateForm', request, ApproveCertificateFormResponse());
  $async.Future<ListCertificateFormsResponse> listCertificateForms(
          $pb.ClientContext? ctx, ListCertificateFormsRequest request) =>
      _client.invoke<ListCertificateFormsResponse>(ctx, 'RecordsService',
          'ListCertificateForms', request, ListCertificateFormsResponse());
  $async.Future<IssueCertificateResponse> issueCertificate(
          $pb.ClientContext? ctx, IssueCertificateRequest request) =>
      _client.invoke<IssueCertificateResponse>(ctx, 'RecordsService',
          'IssueCertificate', request, IssueCertificateResponse());
  $async.Future<CorrectCertificateResponse> correctCertificate(
          $pb.ClientContext? ctx, CorrectCertificateRequest request) =>
      _client.invoke<CorrectCertificateResponse>(ctx, 'RecordsService',
          'CorrectCertificate', request, CorrectCertificateResponse());
  $async.Future<VoidCertificateResponse> voidCertificate(
          $pb.ClientContext? ctx, VoidCertificateRequest request) =>
      _client.invoke<VoidCertificateResponse>(ctx, 'RecordsService',
          'VoidCertificate', request, VoidCertificateResponse());
  $async.Future<ListCertificatesResponse> listCertificates(
          $pb.ClientContext? ctx, ListCertificatesRequest request) =>
      _client.invoke<ListCertificatesResponse>(ctx, 'RecordsService',
          'ListCertificates', request, ListCertificatesResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
