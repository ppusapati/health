// This is a generated file - do not edit.
//
// Generated from healthcare/anaesthesia/v1/anaesthesia.proto.

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

import 'anaesthesia.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'anaesthesia.pbenum.dart';

/// The predicted airway, kept as its parts rather than a score: units differ on
/// which scale they record, and the anaesthetist's judgement is not the sum of
/// the measurements (SRS-ANE-001).
class AirwayAssessment extends $pb.GeneratedMessage {
  factory AirwayAssessment({
    $core.String? mallampati,
    $core.int? mouthOpeningMm,
    $core.int? thyromentalMm,
    $core.String? neckMovement,
    $core.String? dentition,
    $core.String? notes,
    $core.bool? predictedDifficult,
  }) {
    final result = create();
    if (mallampati != null) result.mallampati = mallampati;
    if (mouthOpeningMm != null) result.mouthOpeningMm = mouthOpeningMm;
    if (thyromentalMm != null) result.thyromentalMm = thyromentalMm;
    if (neckMovement != null) result.neckMovement = neckMovement;
    if (dentition != null) result.dentition = dentition;
    if (notes != null) result.notes = notes;
    if (predictedDifficult != null)
      result.predictedDifficult = predictedDifficult;
    return result;
  }

  AirwayAssessment._();

  factory AirwayAssessment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AirwayAssessment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AirwayAssessment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mallampati')
    ..aI(2, _omitFieldNames ? '' : 'mouthOpeningMm')
    ..aI(3, _omitFieldNames ? '' : 'thyromentalMm')
    ..aOS(4, _omitFieldNames ? '' : 'neckMovement')
    ..aOS(5, _omitFieldNames ? '' : 'dentition')
    ..aOS(6, _omitFieldNames ? '' : 'notes')
    ..aOB(7, _omitFieldNames ? '' : 'predictedDifficult')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AirwayAssessment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AirwayAssessment copyWith(void Function(AirwayAssessment) updates) =>
      super.copyWith((message) => updates(message as AirwayAssessment))
          as AirwayAssessment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AirwayAssessment create() => AirwayAssessment._();
  @$core.override
  AirwayAssessment createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AirwayAssessment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AirwayAssessment>(create);
  static AirwayAssessment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mallampati => $_getSZ(0);
  @$pb.TagNumber(1)
  set mallampati($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMallampati() => $_has(0);
  @$pb.TagNumber(1)
  void clearMallampati() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get mouthOpeningMm => $_getIZ(1);
  @$pb.TagNumber(2)
  set mouthOpeningMm($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMouthOpeningMm() => $_has(1);
  @$pb.TagNumber(2)
  void clearMouthOpeningMm() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get thyromentalMm => $_getIZ(2);
  @$pb.TagNumber(3)
  set thyromentalMm($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThyromentalMm() => $_has(2);
  @$pb.TagNumber(3)
  void clearThyromentalMm() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get neckMovement => $_getSZ(3);
  @$pb.TagNumber(4)
  set neckMovement($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNeckMovement() => $_has(3);
  @$pb.TagNumber(4)
  void clearNeckMovement() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get dentition => $_getSZ(4);
  @$pb.TagNumber(5)
  set dentition($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDentition() => $_has(4);
  @$pb.TagNumber(5)
  void clearDentition() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get notes => $_getSZ(5);
  @$pb.TagNumber(6)
  set notes($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNotes() => $_has(5);
  @$pb.TagNumber(6)
  void clearNotes() => $_clearField(6);

  /// The one prediction the theatre most needs in advance, because the
  /// equipment for it lives somewhere else.
  @$pb.TagNumber(7)
  $core.bool get predictedDifficult => $_getBF(6);
  @$pb.TagNumber(7)
  set predictedDifficult($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPredictedDifficult() => $_has(6);
  @$pb.TagNumber(7)
  void clearPredictedDifficult() => $_clearField(7);
}

/// A pre-anaesthesia assessment (SRS-ANE-001).
class Assessment extends $pb.GeneratedMessage {
  factory Assessment({
    $core.String? assessmentId,
    $core.String? caseId,
    $core.String? encounterId,
    $core.String? patientId,
    $core.int? version,
    $core.String? supersedes,
    $core.bool? current,
    $core.String? history,
    AirwayAssessment? airway,
    $core.String? asaGrade,
    $core.Iterable<$core.String>? investigations,
    $core.Iterable<$core.String>? risks,
    $core.String? plan,
    ConsentStatus? consent,
    $core.String? consentNote,
    $core.bool? fitToProceed,
    $core.Iterable<$core.String>? conditions,
    $core.String? assessedBy,
    $0.Timestamp? assessedAt,
    $0.Timestamp? supersededAt,
  }) {
    final result = create();
    if (assessmentId != null) result.assessmentId = assessmentId;
    if (caseId != null) result.caseId = caseId;
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (version != null) result.version = version;
    if (supersedes != null) result.supersedes = supersedes;
    if (current != null) result.current = current;
    if (history != null) result.history = history;
    if (airway != null) result.airway = airway;
    if (asaGrade != null) result.asaGrade = asaGrade;
    if (investigations != null) result.investigations.addAll(investigations);
    if (risks != null) result.risks.addAll(risks);
    if (plan != null) result.plan = plan;
    if (consent != null) result.consent = consent;
    if (consentNote != null) result.consentNote = consentNote;
    if (fitToProceed != null) result.fitToProceed = fitToProceed;
    if (conditions != null) result.conditions.addAll(conditions);
    if (assessedBy != null) result.assessedBy = assessedBy;
    if (assessedAt != null) result.assessedAt = assessedAt;
    if (supersededAt != null) result.supersededAt = supersededAt;
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
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assessmentId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aI(5, _omitFieldNames ? '' : 'version')
    ..aOS(6, _omitFieldNames ? '' : 'supersedes')
    ..aOB(7, _omitFieldNames ? '' : 'current')
    ..aOS(8, _omitFieldNames ? '' : 'history')
    ..aOM<AirwayAssessment>(9, _omitFieldNames ? '' : 'airway',
        subBuilder: AirwayAssessment.create)
    ..aOS(10, _omitFieldNames ? '' : 'asaGrade')
    ..pPS(11, _omitFieldNames ? '' : 'investigations')
    ..pPS(12, _omitFieldNames ? '' : 'risks')
    ..aOS(13, _omitFieldNames ? '' : 'plan')
    ..aE<ConsentStatus>(14, _omitFieldNames ? '' : 'consent',
        enumValues: ConsentStatus.values)
    ..aOS(15, _omitFieldNames ? '' : 'consentNote')
    ..aOB(16, _omitFieldNames ? '' : 'fitToProceed')
    ..pPS(17, _omitFieldNames ? '' : 'conditions')
    ..aOS(18, _omitFieldNames ? '' : 'assessedBy')
    ..aOM<$0.Timestamp>(19, _omitFieldNames ? '' : 'assessedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(20, _omitFieldNames ? '' : 'supersededAt',
        subBuilder: $0.Timestamp.create)
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
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get encounterId => $_getSZ(2);
  @$pb.TagNumber(3)
  set encounterId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEncounterId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEncounterId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get patientId => $_getSZ(3);
  @$pb.TagNumber(4)
  set patientId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPatientId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPatientId() => $_clearField(4);

  /// Versioned rather than edited: a patient assessed in clinic and reassessed
  /// on the morning of surgery has two, and the difference is the point.
  @$pb.TagNumber(5)
  $core.int get version => $_getIZ(4);
  @$pb.TagNumber(5)
  set version($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get supersedes => $_getSZ(5);
  @$pb.TagNumber(6)
  set supersedes($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSupersedes() => $_has(5);
  @$pb.TagNumber(6)
  void clearSupersedes() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get current => $_getBF(6);
  @$pb.TagNumber(7)
  set current($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCurrent() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrent() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get history => $_getSZ(7);
  @$pb.TagNumber(8)
  set history($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHistory() => $_has(7);
  @$pb.TagNumber(8)
  void clearHistory() => $_clearField(8);

  @$pb.TagNumber(9)
  AirwayAssessment get airway => $_getN(8);
  @$pb.TagNumber(9)
  set airway(AirwayAssessment value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasAirway() => $_has(8);
  @$pb.TagNumber(9)
  void clearAirway() => $_clearField(9);
  @$pb.TagNumber(9)
  AirwayAssessment ensureAirway() => $_ensure(8);

  /// A string because the emergency modifier is part of the grade.
  @$pb.TagNumber(10)
  $core.String get asaGrade => $_getSZ(9);
  @$pb.TagNumber(10)
  set asaGrade($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAsaGrade() => $_has(9);
  @$pb.TagNumber(10)
  void clearAsaGrade() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get investigations => $_getList(10);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get risks => $_getList(11);

  @$pb.TagNumber(13)
  $core.String get plan => $_getSZ(12);
  @$pb.TagNumber(13)
  set plan($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasPlan() => $_has(12);
  @$pb.TagNumber(13)
  void clearPlan() => $_clearField(13);

  @$pb.TagNumber(14)
  ConsentStatus get consent => $_getN(13);
  @$pb.TagNumber(14)
  set consent(ConsentStatus value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasConsent() => $_has(13);
  @$pb.TagNumber(14)
  void clearConsent() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get consentNote => $_getSZ(14);
  @$pb.TagNumber(15)
  set consentNote($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasConsentNote() => $_has(14);
  @$pb.TagNumber(15)
  void clearConsentNote() => $_clearField(15);

  /// Separate from the grade: an ASA 4 patient can be fit for the operation
  /// they need and an ASA 2 patient can be unfit today.
  @$pb.TagNumber(16)
  $core.bool get fitToProceed => $_getBF(15);
  @$pb.TagNumber(16)
  set fitToProceed($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(16)
  $core.bool hasFitToProceed() => $_has(15);
  @$pb.TagNumber(16)
  void clearFitToProceed() => $_clearField(16);

  @$pb.TagNumber(17)
  $pb.PbList<$core.String> get conditions => $_getList(16);

  @$pb.TagNumber(18)
  $core.String get assessedBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set assessedBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasAssessedBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearAssessedBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $0.Timestamp get assessedAt => $_getN(18);
  @$pb.TagNumber(19)
  set assessedAt($0.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasAssessedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearAssessedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Timestamp ensureAssessedAt() => $_ensure(18);

  @$pb.TagNumber(20)
  $0.Timestamp get supersededAt => $_getN(19);
  @$pb.TagNumber(20)
  set supersededAt($0.Timestamp value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasSupersededAt() => $_has(19);
  @$pb.TagNumber(20)
  void clearSupersededAt() => $_clearField(20);
  @$pb.TagNumber(20)
  $0.Timestamp ensureSupersededAt() => $_ensure(19);
}

/// The anaesthetic plan (SRS-ANE-002).
class Plan extends $pb.GeneratedMessage {
  factory Plan({
    $core.String? planId,
    $core.String? caseId,
    Technique? technique,
    $core.Iterable<$core.String>? agents,
    $core.String? airway,
    $core.Iterable<$core.String>? monitoring,
    $core.Iterable<$core.String>? specialEquipment,
    $core.String? postOperative,
    $core.String? notes,
    $core.String? plannedBy,
    $0.Timestamp? plannedAt,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    if (caseId != null) result.caseId = caseId;
    if (technique != null) result.technique = technique;
    if (agents != null) result.agents.addAll(agents);
    if (airway != null) result.airway = airway;
    if (monitoring != null) result.monitoring.addAll(monitoring);
    if (specialEquipment != null)
      result.specialEquipment.addAll(specialEquipment);
    if (postOperative != null) result.postOperative = postOperative;
    if (notes != null) result.notes = notes;
    if (plannedBy != null) result.plannedBy = plannedBy;
    if (plannedAt != null) result.plannedAt = plannedAt;
    return result;
  }

  Plan._();

  factory Plan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Plan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Plan',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'planId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aE<Technique>(3, _omitFieldNames ? '' : 'technique',
        enumValues: Technique.values)
    ..pPS(4, _omitFieldNames ? '' : 'agents')
    ..aOS(5, _omitFieldNames ? '' : 'airway')
    ..pPS(6, _omitFieldNames ? '' : 'monitoring')
    ..pPS(7, _omitFieldNames ? '' : 'specialEquipment')
    ..aOS(8, _omitFieldNames ? '' : 'postOperative')
    ..aOS(9, _omitFieldNames ? '' : 'notes')
    ..aOS(10, _omitFieldNames ? '' : 'plannedBy')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'plannedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Plan clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Plan copyWith(void Function(Plan) updates) =>
      super.copyWith((message) => updates(message as Plan)) as Plan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Plan create() => Plan._();
  @$core.override
  Plan createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Plan getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Plan>(create);
  static Plan? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get planId => $_getSZ(0);
  @$pb.TagNumber(1)
  set planId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  @$pb.TagNumber(3)
  Technique get technique => $_getN(2);
  @$pb.TagNumber(3)
  set technique(Technique value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTechnique() => $_has(2);
  @$pb.TagNumber(3)
  void clearTechnique() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get agents => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get airway => $_getSZ(4);
  @$pb.TagNumber(5)
  set airway($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAirway() => $_has(4);
  @$pb.TagNumber(5)
  void clearAirway() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get monitoring => $_getList(5);

  /// What has to be fetched, which is why the theatre reads the plan at all.
  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get specialEquipment => $_getList(6);

  /// Where the patient is planned to go. At planning, because a critical-care
  /// bed is booked before the operation rather than after it.
  @$pb.TagNumber(8)
  $core.String get postOperative => $_getSZ(7);
  @$pb.TagNumber(8)
  set postOperative($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPostOperative() => $_has(7);
  @$pb.TagNumber(8)
  void clearPostOperative() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get notes => $_getSZ(8);
  @$pb.TagNumber(9)
  set notes($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasNotes() => $_has(8);
  @$pb.TagNumber(9)
  void clearNotes() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get plannedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set plannedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPlannedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearPlannedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get plannedAt => $_getN(10);
  @$pb.TagNumber(11)
  set plannedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasPlannedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearPlannedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensurePlannedAt() => $_ensure(10);
}

/// What the theatre's pre-operative checklist needs from anaesthesia
/// (SRS-ANE-002).
///
/// A projection rather than the whole record: the checklist is read by the
/// whole theatre team and does not need the history.
class Readiness extends $pb.GeneratedMessage {
  factory Readiness({
    $core.bool? assessed,
    $core.bool? fit,
    $core.Iterable<$core.String>? conditions,
    $core.String? asaGrade,
    $core.bool? difficultAirway,
    ConsentStatus? consent,
    $core.bool? planned,
    Technique? technique,
    $core.Iterable<$core.String>? specialEquipment,
    $core.String? postOperative,
    $core.Iterable<$core.String>? outstanding,
  }) {
    final result = create();
    if (assessed != null) result.assessed = assessed;
    if (fit != null) result.fit = fit;
    if (conditions != null) result.conditions.addAll(conditions);
    if (asaGrade != null) result.asaGrade = asaGrade;
    if (difficultAirway != null) result.difficultAirway = difficultAirway;
    if (consent != null) result.consent = consent;
    if (planned != null) result.planned = planned;
    if (technique != null) result.technique = technique;
    if (specialEquipment != null)
      result.specialEquipment.addAll(specialEquipment);
    if (postOperative != null) result.postOperative = postOperative;
    if (outstanding != null) result.outstanding.addAll(outstanding);
    return result;
  }

  Readiness._();

  factory Readiness.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Readiness.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Readiness',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'assessed')
    ..aOB(2, _omitFieldNames ? '' : 'fit')
    ..pPS(3, _omitFieldNames ? '' : 'conditions')
    ..aOS(4, _omitFieldNames ? '' : 'asaGrade')
    ..aOB(5, _omitFieldNames ? '' : 'difficultAirway')
    ..aE<ConsentStatus>(6, _omitFieldNames ? '' : 'consent',
        enumValues: ConsentStatus.values)
    ..aOB(7, _omitFieldNames ? '' : 'planned')
    ..aE<Technique>(8, _omitFieldNames ? '' : 'technique',
        enumValues: Technique.values)
    ..pPS(9, _omitFieldNames ? '' : 'specialEquipment')
    ..aOS(10, _omitFieldNames ? '' : 'postOperative')
    ..pPS(11, _omitFieldNames ? '' : 'outstanding')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Readiness clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Readiness copyWith(void Function(Readiness) updates) =>
      super.copyWith((message) => updates(message as Readiness)) as Readiness;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Readiness create() => Readiness._();
  @$core.override
  Readiness createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Readiness getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Readiness>(create);
  static Readiness? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get assessed => $_getBF(0);
  @$pb.TagNumber(1)
  set assessed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssessed() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssessed() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get fit => $_getBF(1);
  @$pb.TagNumber(2)
  set fit($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFit() => $_has(1);
  @$pb.TagNumber(2)
  void clearFit() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get conditions => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get asaGrade => $_getSZ(3);
  @$pb.TagNumber(4)
  set asaGrade($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAsaGrade() => $_has(3);
  @$pb.TagNumber(4)
  void clearAsaGrade() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get difficultAirway => $_getBF(4);
  @$pb.TagNumber(5)
  set difficultAirway($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDifficultAirway() => $_has(4);
  @$pb.TagNumber(5)
  void clearDifficultAirway() => $_clearField(5);

  @$pb.TagNumber(6)
  ConsentStatus get consent => $_getN(5);
  @$pb.TagNumber(6)
  set consent(ConsentStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasConsent() => $_has(5);
  @$pb.TagNumber(6)
  void clearConsent() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get planned => $_getBF(6);
  @$pb.TagNumber(7)
  set planned($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPlanned() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlanned() => $_clearField(7);

  @$pb.TagNumber(8)
  Technique get technique => $_getN(7);
  @$pb.TagNumber(8)
  set technique(Technique value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasTechnique() => $_has(7);
  @$pb.TagNumber(8)
  void clearTechnique() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get specialEquipment => $_getList(8);

  @$pb.TagNumber(10)
  $core.String get postOperative => $_getSZ(9);
  @$pb.TagNumber(10)
  set postOperative($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPostOperative() => $_has(9);
  @$pb.TagNumber(10)
  void clearPostOperative() => $_clearField(10);

  /// What is missing, so the checklist can show it rather than a bare "not
  /// ready".
  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get outstanding => $_getList(10);
}

/// The device an entry came from, and its state at the moment of the reading
/// (SRS-ANE-005).
class DeviceLink extends $pb.GeneratedMessage {
  factory DeviceLink({
    $core.String? deviceId,
    $core.String? model,
    $core.bool? connected,
    $0.Timestamp? measuredAt,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (model != null) result.model = model;
    if (connected != null) result.connected = connected;
    if (measuredAt != null) result.measuredAt = measuredAt;
    return result;
  }

  DeviceLink._();

  factory DeviceLink.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceLink.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceLink',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'model')
    ..aOB(3, _omitFieldNames ? '' : 'connected')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'measuredAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceLink clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceLink copyWith(void Function(DeviceLink) updates) =>
      super.copyWith((message) => updates(message as DeviceLink)) as DeviceLink;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceLink create() => DeviceLink._();
  @$core.override
  DeviceLink createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceLink getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceLink>(create);
  static DeviceLink? _defaultInstance;

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

  /// A value recorded while the monitor was disconnected is one nobody should
  /// trend.
  @$pb.TagNumber(3)
  $core.bool get connected => $_getBF(2);
  @$pb.TagNumber(3)
  set connected($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConnected() => $_has(2);
  @$pb.TagNumber(3)
  void clearConnected() => $_clearField(3);

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
}

/// The intraoperative anaesthetic record (SRS-ANE-003).
class Record extends $pb.GeneratedMessage {
  factory Record({
    $core.String? recordId,
    $core.String? caseId,
    $core.String? encounterId,
    $core.String? patientId,
    Technique? technique,
    RecordStatus? status,
    $0.Timestamp? startedAt,
    $core.String? startedBy,
    $0.Timestamp? endedAt,
    EntrySource? origin,
    $core.String? importNote,
    $0.Timestamp? importedAt,
    $core.String? importedBy,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (caseId != null) result.caseId = caseId;
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (technique != null) result.technique = technique;
    if (status != null) result.status = status;
    if (startedAt != null) result.startedAt = startedAt;
    if (startedBy != null) result.startedBy = startedBy;
    if (endedAt != null) result.endedAt = endedAt;
    if (origin != null) result.origin = origin;
    if (importNote != null) result.importNote = importNote;
    if (importedAt != null) result.importedAt = importedAt;
    if (importedBy != null) result.importedBy = importedBy;
    return result;
  }

  Record._();

  factory Record.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Record.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Record',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aE<Technique>(5, _omitFieldNames ? '' : 'technique',
        enumValues: Technique.values)
    ..aE<RecordStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: RecordStatus.values)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'startedBy')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..aE<EntrySource>(10, _omitFieldNames ? '' : 'origin',
        enumValues: EntrySource.values)
    ..aOS(11, _omitFieldNames ? '' : 'importNote')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'importedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'importedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Record clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Record copyWith(void Function(Record) updates) =>
      super.copyWith((message) => updates(message as Record)) as Record;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Record create() => Record._();
  @$core.override
  Record createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Record getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Record>(create);
  static Record? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get encounterId => $_getSZ(2);
  @$pb.TagNumber(3)
  set encounterId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEncounterId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEncounterId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get patientId => $_getSZ(3);
  @$pb.TagNumber(4)
  set patientId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPatientId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPatientId() => $_clearField(4);

  @$pb.TagNumber(5)
  Technique get technique => $_getN(4);
  @$pb.TagNumber(5)
  set technique(Technique value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTechnique() => $_has(4);
  @$pb.TagNumber(5)
  void clearTechnique() => $_clearField(5);

  @$pb.TagNumber(6)
  RecordStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(RecordStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get startedAt => $_getN(6);
  @$pb.TagNumber(7)
  set startedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStartedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearStartedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureStartedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get startedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set startedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasStartedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearStartedBy() => $_clearField(8);

  /// When the anaesthetic ended, which is not when the operation ended:
  /// emergence takes time and it is the anaesthetist's.
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

  /// A record made here, or transcribed from paper after a downtime. A
  /// reconstructed record that did not say so would read as a contemporaneous
  /// one (SRS-ANE-011).
  @$pb.TagNumber(10)
  EntrySource get origin => $_getN(9);
  @$pb.TagNumber(10)
  set origin(EntrySource value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasOrigin() => $_has(9);
  @$pb.TagNumber(10)
  void clearOrigin() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get importNote => $_getSZ(10);
  @$pb.TagNumber(11)
  set importNote($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasImportNote() => $_has(10);
  @$pb.TagNumber(11)
  void clearImportNote() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get importedAt => $_getN(11);
  @$pb.TagNumber(12)
  set importedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasImportedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearImportedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureImportedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get importedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set importedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasImportedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearImportedBy() => $_clearField(13);
}

/// One intraoperative value (SRS-ANE-003, SRS-ANE-005).
class VitalEntry extends $pb.GeneratedMessage {
  factory VitalEntry({
    $core.String? vitalId,
    $core.String? recordId,
    $core.String? code,
    $core.String? display,
    $core.double? value,
    $core.String? unit,
    EntrySource? source,
    DeviceLink? device,
    $0.Timestamp? observedAt,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
    $core.bool? trustworthy,
  }) {
    final result = create();
    if (vitalId != null) result.vitalId = vitalId;
    if (recordId != null) result.recordId = recordId;
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (source != null) result.source = source;
    if (device != null) result.device = device;
    if (observedAt != null) result.observedAt = observedAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (trustworthy != null) result.trustworthy = trustworthy;
    return result;
  }

  VitalEntry._();

  factory VitalEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VitalEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VitalEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vitalId')
    ..aOS(2, _omitFieldNames ? '' : 'recordId')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'display')
    ..aD(5, _omitFieldNames ? '' : 'value')
    ..aOS(6, _omitFieldNames ? '' : 'unit')
    ..aE<EntrySource>(7, _omitFieldNames ? '' : 'source',
        enumValues: EntrySource.values)
    ..aOM<DeviceLink>(8, _omitFieldNames ? '' : 'device',
        subBuilder: DeviceLink.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'recordedBy')
    ..aOB(12, _omitFieldNames ? '' : 'trustworthy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VitalEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VitalEntry copyWith(void Function(VitalEntry) updates) =>
      super.copyWith((message) => updates(message as VitalEntry)) as VitalEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VitalEntry create() => VitalEntry._();
  @$core.override
  VitalEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VitalEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VitalEntry>(create);
  static VitalEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vitalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set vitalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVitalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVitalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recordId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recordId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordId() => $_clearField(2);

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
  $core.double get value => $_getN(4);
  @$pb.TagNumber(5)
  set value($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearValue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get unit => $_getSZ(5);
  @$pb.TagNumber(6)
  set unit($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUnit() => $_has(5);
  @$pb.TagNumber(6)
  void clearUnit() => $_clearField(6);

  @$pb.TagNumber(7)
  EntrySource get source => $_getN(6);
  @$pb.TagNumber(7)
  set source(EntrySource value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSource() => $_has(6);
  @$pb.TagNumber(7)
  void clearSource() => $_clearField(7);

  @$pb.TagNumber(8)
  DeviceLink get device => $_getN(7);
  @$pb.TagNumber(8)
  set device(DeviceLink value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDevice() => $_has(7);
  @$pb.TagNumber(8)
  void clearDevice() => $_clearField(8);
  @$pb.TagNumber(8)
  DeviceLink ensureDevice() => $_ensure(7);

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

  /// False for a device reading taken while the monitor was disconnected.
  /// Derived, so a client cannot forget to apply the rule.
  @$pb.TagNumber(12)
  $core.bool get trustworthy => $_getBF(11);
  @$pb.TagNumber(12)
  set trustworthy($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasTrustworthy() => $_has(11);
  @$pb.TagNumber(12)
  void clearTrustworthy() => $_clearField(12);
}

/// One drug or infusion (SRS-ANE-004).
class DrugEntry extends $pb.GeneratedMessage {
  factory DrugEntry({
    $core.String? drugId,
    $core.String? recordId,
    $core.String? drugCode,
    $core.String? drugDisplay,
    $core.String? route,
    $core.double? dose,
    $core.String? doseUnit,
    $core.double? concentrationAmount,
    $core.String? concentrationUnit,
    $core.double? concentrationVolume,
    $core.double? rateMlPerHour,
    $core.bool? infusion,
    $0.Timestamp? stoppedAt,
    EntrySource? source,
    DeviceLink? device,
    $0.Timestamp? givenAt,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
    $core.String? note,
  }) {
    final result = create();
    if (drugId != null) result.drugId = drugId;
    if (recordId != null) result.recordId = recordId;
    if (drugCode != null) result.drugCode = drugCode;
    if (drugDisplay != null) result.drugDisplay = drugDisplay;
    if (route != null) result.route = route;
    if (dose != null) result.dose = dose;
    if (doseUnit != null) result.doseUnit = doseUnit;
    if (concentrationAmount != null)
      result.concentrationAmount = concentrationAmount;
    if (concentrationUnit != null) result.concentrationUnit = concentrationUnit;
    if (concentrationVolume != null)
      result.concentrationVolume = concentrationVolume;
    if (rateMlPerHour != null) result.rateMlPerHour = rateMlPerHour;
    if (infusion != null) result.infusion = infusion;
    if (stoppedAt != null) result.stoppedAt = stoppedAt;
    if (source != null) result.source = source;
    if (device != null) result.device = device;
    if (givenAt != null) result.givenAt = givenAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (note != null) result.note = note;
    return result;
  }

  DrugEntry._();

  factory DrugEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DrugEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DrugEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drugId')
    ..aOS(2, _omitFieldNames ? '' : 'recordId')
    ..aOS(3, _omitFieldNames ? '' : 'drugCode')
    ..aOS(4, _omitFieldNames ? '' : 'drugDisplay')
    ..aOS(5, _omitFieldNames ? '' : 'route')
    ..aD(6, _omitFieldNames ? '' : 'dose')
    ..aOS(7, _omitFieldNames ? '' : 'doseUnit')
    ..aD(8, _omitFieldNames ? '' : 'concentrationAmount')
    ..aOS(9, _omitFieldNames ? '' : 'concentrationUnit')
    ..aD(10, _omitFieldNames ? '' : 'concentrationVolume')
    ..aD(11, _omitFieldNames ? '' : 'rateMlPerHour')
    ..aOB(12, _omitFieldNames ? '' : 'infusion')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'stoppedAt',
        subBuilder: $0.Timestamp.create)
    ..aE<EntrySource>(14, _omitFieldNames ? '' : 'source',
        enumValues: EntrySource.values)
    ..aOM<DeviceLink>(15, _omitFieldNames ? '' : 'device',
        subBuilder: DeviceLink.create)
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'givenAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(18, _omitFieldNames ? '' : 'recordedBy')
    ..aOS(19, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DrugEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DrugEntry copyWith(void Function(DrugEntry) updates) =>
      super.copyWith((message) => updates(message as DrugEntry)) as DrugEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DrugEntry create() => DrugEntry._();
  @$core.override
  DrugEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DrugEntry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DrugEntry>(create);
  static DrugEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drugId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drugId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDrugId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrugId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recordId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recordId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordId() => $_clearField(2);

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
  $core.String get route => $_getSZ(4);
  @$pb.TagNumber(5)
  set route($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRoute() => $_has(4);
  @$pb.TagNumber(5)
  void clearRoute() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get dose => $_getN(5);
  @$pb.TagNumber(6)
  set dose($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDose() => $_has(5);
  @$pb.TagNumber(6)
  void clearDose() => $_clearField(6);

  /// A system that stored "5" without knowing whether it was millilitres or
  /// milligrams has recorded nothing.
  @$pb.TagNumber(7)
  $core.String get doseUnit => $_getSZ(6);
  @$pb.TagNumber(7)
  set doseUnit($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDoseUnit() => $_has(6);
  @$pb.TagNumber(7)
  void clearDoseUnit() => $_clearField(7);

  /// Both halves, because without them a rate cannot be turned into a dose.
  @$pb.TagNumber(8)
  $core.double get concentrationAmount => $_getN(7);
  @$pb.TagNumber(8)
  set concentrationAmount($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasConcentrationAmount() => $_has(7);
  @$pb.TagNumber(8)
  void clearConcentrationAmount() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get concentrationUnit => $_getSZ(8);
  @$pb.TagNumber(9)
  set concentrationUnit($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasConcentrationUnit() => $_has(8);
  @$pb.TagNumber(9)
  void clearConcentrationUnit() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get concentrationVolume => $_getN(9);
  @$pb.TagNumber(10)
  set concentrationVolume($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasConcentrationVolume() => $_has(9);
  @$pb.TagNumber(10)
  void clearConcentrationVolume() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get rateMlPerHour => $_getN(10);
  @$pb.TagNumber(11)
  set rateMlPerHour($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRateMlPerHour() => $_has(10);
  @$pb.TagNumber(11)
  void clearRateMlPerHour() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get infusion => $_getBF(11);
  @$pb.TagNumber(12)
  set infusion($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasInfusion() => $_has(11);
  @$pb.TagNumber(12)
  void clearInfusion() => $_clearField(12);

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
  EntrySource get source => $_getN(13);
  @$pb.TagNumber(14)
  set source(EntrySource value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasSource() => $_has(13);
  @$pb.TagNumber(14)
  void clearSource() => $_clearField(14);

  @$pb.TagNumber(15)
  DeviceLink get device => $_getN(14);
  @$pb.TagNumber(15)
  set device(DeviceLink value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasDevice() => $_has(14);
  @$pb.TagNumber(15)
  void clearDevice() => $_clearField(15);
  @$pb.TagNumber(15)
  DeviceLink ensureDevice() => $_ensure(14);

  @$pb.TagNumber(16)
  $0.Timestamp get givenAt => $_getN(15);
  @$pb.TagNumber(16)
  set givenAt($0.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasGivenAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearGivenAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureGivenAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $0.Timestamp get recordedAt => $_getN(16);
  @$pb.TagNumber(17)
  set recordedAt($0.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasRecordedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearRecordedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Timestamp ensureRecordedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.String get recordedBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set recordedBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasRecordedBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearRecordedBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get note => $_getSZ(18);
  @$pb.TagNumber(19)
  set note($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasNote() => $_has(18);
  @$pb.TagNumber(19)
  void clearNote() => $_clearField(19);
}

/// One airway attempt (SRS-ANE-006).
class AirwayEvent extends $pb.GeneratedMessage {
  factory AirwayEvent({
    $core.String? airwayId,
    $core.String? recordId,
    $core.String? device,
    $core.int? attempt,
    $core.String? grade,
    $core.bool? successful,
    $core.String? difficulty,
    $core.Iterable<$core.String>? complications,
    $core.Iterable<$core.String>? adjuncts,
    $0.Timestamp? occurredAt,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (airwayId != null) result.airwayId = airwayId;
    if (recordId != null) result.recordId = recordId;
    if (device != null) result.device = device;
    if (attempt != null) result.attempt = attempt;
    if (grade != null) result.grade = grade;
    if (successful != null) result.successful = successful;
    if (difficulty != null) result.difficulty = difficulty;
    if (complications != null) result.complications.addAll(complications);
    if (adjuncts != null) result.adjuncts.addAll(adjuncts);
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  AirwayEvent._();

  factory AirwayEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AirwayEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AirwayEvent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'airwayId')
    ..aOS(2, _omitFieldNames ? '' : 'recordId')
    ..aOS(3, _omitFieldNames ? '' : 'device')
    ..aI(4, _omitFieldNames ? '' : 'attempt')
    ..aOS(5, _omitFieldNames ? '' : 'grade')
    ..aOB(6, _omitFieldNames ? '' : 'successful')
    ..aOS(7, _omitFieldNames ? '' : 'difficulty')
    ..pPS(8, _omitFieldNames ? '' : 'complications')
    ..pPS(9, _omitFieldNames ? '' : 'adjuncts')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AirwayEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AirwayEvent copyWith(void Function(AirwayEvent) updates) =>
      super.copyWith((message) => updates(message as AirwayEvent))
          as AirwayEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AirwayEvent create() => AirwayEvent._();
  @$core.override
  AirwayEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AirwayEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AirwayEvent>(create);
  static AirwayEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get airwayId => $_getSZ(0);
  @$pb.TagNumber(1)
  set airwayId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAirwayId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAirwayId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recordId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recordId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get device => $_getSZ(2);
  @$pb.TagNumber(3)
  set device($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDevice() => $_has(2);
  @$pb.TagNumber(3)
  void clearDevice() => $_clearField(3);

  /// Attempts count from one: a zeroth attempt would make the count of
  /// attempts, which is what the next anaesthetist reads, wrong.
  @$pb.TagNumber(4)
  $core.int get attempt => $_getIZ(3);
  @$pb.TagNumber(4)
  set attempt($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAttempt() => $_has(3);
  @$pb.TagNumber(4)
  void clearAttempt() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get grade => $_getSZ(4);
  @$pb.TagNumber(5)
  set grade($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasGrade() => $_has(4);
  @$pb.TagNumber(5)
  void clearGrade() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get successful => $_getBF(5);
  @$pb.TagNumber(6)
  set successful($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSuccessful() => $_has(5);
  @$pb.TagNumber(6)
  void clearSuccessful() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get difficulty => $_getSZ(6);
  @$pb.TagNumber(7)
  set difficulty($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDifficulty() => $_has(6);
  @$pb.TagNumber(7)
  void clearDifficulty() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get complications => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get adjuncts => $_getList(8);

  @$pb.TagNumber(10)
  $0.Timestamp get occurredAt => $_getN(9);
  @$pb.TagNumber(10)
  set occurredAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasOccurredAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearOccurredAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureOccurredAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get recordedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set recordedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRecordedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearRecordedBy() => $_clearField(11);
}

/// What the next anaesthetist reads (SRS-ANE-006).
class DifficultAirway extends $pb.GeneratedMessage {
  factory DifficultAirway({
    $core.int? attempts,
    $core.bool? difficult,
    $core.Iterable<$core.String>? reasons,
    $core.String? finalDevice,
    $core.Iterable<$core.String>? complications,
  }) {
    final result = create();
    if (attempts != null) result.attempts = attempts;
    if (difficult != null) result.difficult = difficult;
    if (reasons != null) result.reasons.addAll(reasons);
    if (finalDevice != null) result.finalDevice = finalDevice;
    if (complications != null) result.complications.addAll(complications);
    return result;
  }

  DifficultAirway._();

  factory DifficultAirway.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DifficultAirway.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DifficultAirway',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'attempts')
    ..aOB(2, _omitFieldNames ? '' : 'difficult')
    ..pPS(3, _omitFieldNames ? '' : 'reasons')
    ..aOS(4, _omitFieldNames ? '' : 'finalDevice')
    ..pPS(5, _omitFieldNames ? '' : 'complications')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DifficultAirway clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DifficultAirway copyWith(void Function(DifficultAirway) updates) =>
      super.copyWith((message) => updates(message as DifficultAirway))
          as DifficultAirway;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DifficultAirway create() => DifficultAirway._();
  @$core.override
  DifficultAirway createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DifficultAirway getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DifficultAirway>(create);
  static DifficultAirway? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get attempts => $_getIZ(0);
  @$pb.TagNumber(1)
  set attempts($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAttempts() => $_has(0);
  @$pb.TagNumber(1)
  void clearAttempts() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get difficult => $_getBF(1);
  @$pb.TagNumber(2)
  set difficult($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDifficult() => $_has(1);
  @$pb.TagNumber(2)
  void clearDifficult() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get reasons => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get finalDevice => $_getSZ(3);
  @$pb.TagNumber(4)
  set finalDevice($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFinalDevice() => $_has(3);
  @$pb.TagNumber(4)
  void clearFinalDevice() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get complications => $_getList(4);
}

/// One fluid in or out (SRS-ANE-007).
class FluidEntry extends $pb.GeneratedMessage {
  factory FluidEntry({
    $core.String? fluidId,
    $core.String? recordId,
    FluidDirection? direction,
    $core.String? kind,
    $core.String? label,
    $core.double? volumeMl,
    $core.String? productId,
    $0.Timestamp? occurredAt,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (fluidId != null) result.fluidId = fluidId;
    if (recordId != null) result.recordId = recordId;
    if (direction != null) result.direction = direction;
    if (kind != null) result.kind = kind;
    if (label != null) result.label = label;
    if (volumeMl != null) result.volumeMl = volumeMl;
    if (productId != null) result.productId = productId;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
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
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fluidId')
    ..aOS(2, _omitFieldNames ? '' : 'recordId')
    ..aE<FluidDirection>(3, _omitFieldNames ? '' : 'direction',
        enumValues: FluidDirection.values)
    ..aOS(4, _omitFieldNames ? '' : 'kind')
    ..aOS(5, _omitFieldNames ? '' : 'label')
    ..aD(6, _omitFieldNames ? '' : 'volumeMl')
    ..aOS(7, _omitFieldNames ? '' : 'productId')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'recordedBy')
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
  $core.String get recordId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recordId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordId() => $_clearField(2);

  @$pb.TagNumber(3)
  FluidDirection get direction => $_getN(2);
  @$pb.TagNumber(3)
  set direction(FluidDirection value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDirection() => $_has(2);
  @$pb.TagNumber(3)
  void clearDirection() => $_clearField(3);

  /// A litre in and a litre of blood out are different clinical pictures.
  @$pb.TagNumber(4)
  $core.String get kind => $_getSZ(3);
  @$pb.TagNumber(4)
  set kind($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get label => $_getSZ(4);
  @$pb.TagNumber(5)
  set label($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLabel() => $_has(4);
  @$pb.TagNumber(5)
  void clearLabel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get volumeMl => $_getN(5);
  @$pb.TagNumber(6)
  set volumeMl($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVolumeMl() => $_has(5);
  @$pb.TagNumber(6)
  void clearVolumeMl() => $_clearField(6);

  /// The blood bank's unit identifier, for a transfusion. Without it the
  /// transfusion cannot be reconciled against the issue record.
  @$pb.TagNumber(7)
  $core.String get productId => $_getSZ(6);
  @$pb.TagNumber(7)
  set productId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasProductId() => $_has(6);
  @$pb.TagNumber(7)
  void clearProductId() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get occurredAt => $_getN(7);
  @$pb.TagNumber(8)
  set occurredAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasOccurredAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearOccurredAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureOccurredAt() => $_ensure(7);

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
  $core.String get recordedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set recordedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRecordedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearRecordedBy() => $_clearField(10);
}

/// The running fluid balance (SRS-ANE-007).
class FluidBalance extends $pb.GeneratedMessage {
  factory FluidBalance({
    $core.double? inMl,
    $core.double? outMl,
    $core.double? netMl,
    $core.double? bloodLossMl,
    $core.double? transfusedMl,
    $core.double? urineMl,
    $core.int? entries,
  }) {
    final result = create();
    if (inMl != null) result.inMl = inMl;
    if (outMl != null) result.outMl = outMl;
    if (netMl != null) result.netMl = netMl;
    if (bloodLossMl != null) result.bloodLossMl = bloodLossMl;
    if (transfusedMl != null) result.transfusedMl = transfusedMl;
    if (urineMl != null) result.urineMl = urineMl;
    if (entries != null) result.entries = entries;
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
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'inMl')
    ..aD(2, _omitFieldNames ? '' : 'outMl')
    ..aD(3, _omitFieldNames ? '' : 'netMl')
    ..aD(4, _omitFieldNames ? '' : 'bloodLossMl')
    ..aD(5, _omitFieldNames ? '' : 'transfusedMl')
    ..aD(6, _omitFieldNames ? '' : 'urineMl')
    ..aI(7, _omitFieldNames ? '' : 'entries')
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
  $core.double get inMl => $_getN(0);
  @$pb.TagNumber(1)
  set inMl($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInMl() => $_has(0);
  @$pb.TagNumber(1)
  void clearInMl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get outMl => $_getN(1);
  @$pb.TagNumber(2)
  set outMl($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOutMl() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutMl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get netMl => $_getN(2);
  @$pb.TagNumber(3)
  set netMl($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNetMl() => $_has(2);
  @$pb.TagNumber(3)
  void clearNetMl() => $_clearField(3);

  /// Called out separately, because these are the three a handover asks about.
  @$pb.TagNumber(4)
  $core.double get bloodLossMl => $_getN(3);
  @$pb.TagNumber(4)
  set bloodLossMl($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBloodLossMl() => $_has(3);
  @$pb.TagNumber(4)
  void clearBloodLossMl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get transfusedMl => $_getN(4);
  @$pb.TagNumber(5)
  set transfusedMl($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTransfusedMl() => $_has(4);
  @$pb.TagNumber(5)
  void clearTransfusedMl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get urineMl => $_getN(5);
  @$pb.TagNumber(6)
  set urineMl($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUrineMl() => $_has(5);
  @$pb.TagNumber(6)
  void clearUrineMl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get entries => $_getIZ(6);
  @$pb.TagNumber(7)
  set entries($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEntries() => $_has(6);
  @$pb.TagNumber(7)
  void clearEntries() => $_clearField(7);
}

/// The anaesthetist's handover to recovery (SRS-ANE-008).
class Handover extends $pb.GeneratedMessage {
  factory Handover({
    $core.String? handoverId,
    $core.String? recordId,
    $core.String? fromClinician,
    $core.String? toClinician,
    $core.String? summary,
    $core.Iterable<$core.String>? concerns,
    $core.Iterable<$core.String>? instructions,
    $core.Iterable<$core.String>? analgesiaGiven,
    $core.Iterable<$core.String>? antiemeticGiven,
    $0.Timestamp? handedOverAt,
  }) {
    final result = create();
    if (handoverId != null) result.handoverId = handoverId;
    if (recordId != null) result.recordId = recordId;
    if (fromClinician != null) result.fromClinician = fromClinician;
    if (toClinician != null) result.toClinician = toClinician;
    if (summary != null) result.summary = summary;
    if (concerns != null) result.concerns.addAll(concerns);
    if (instructions != null) result.instructions.addAll(instructions);
    if (analgesiaGiven != null) result.analgesiaGiven.addAll(analgesiaGiven);
    if (antiemeticGiven != null) result.antiemeticGiven.addAll(antiemeticGiven);
    if (handedOverAt != null) result.handedOverAt = handedOverAt;
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
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'handoverId')
    ..aOS(2, _omitFieldNames ? '' : 'recordId')
    ..aOS(3, _omitFieldNames ? '' : 'fromClinician')
    ..aOS(4, _omitFieldNames ? '' : 'toClinician')
    ..aOS(5, _omitFieldNames ? '' : 'summary')
    ..pPS(6, _omitFieldNames ? '' : 'concerns')
    ..pPS(7, _omitFieldNames ? '' : 'instructions')
    ..pPS(8, _omitFieldNames ? '' : 'analgesiaGiven')
    ..pPS(9, _omitFieldNames ? '' : 'antiemeticGiven')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'handedOverAt',
        subBuilder: $0.Timestamp.create)
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
  $core.String get recordId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recordId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordId() => $_clearField(2);

  /// Both people. A handover naming only the giver is a note left on a trolley.
  @$pb.TagNumber(3)
  $core.String get fromClinician => $_getSZ(2);
  @$pb.TagNumber(3)
  set fromClinician($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFromClinician() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromClinician() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get toClinician => $_getSZ(3);
  @$pb.TagNumber(4)
  set toClinician($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasToClinician() => $_has(3);
  @$pb.TagNumber(4)
  void clearToClinician() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get summary => $_getSZ(4);
  @$pb.TagNumber(5)
  set summary($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSummary() => $_has(4);
  @$pb.TagNumber(5)
  void clearSummary() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get concerns => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get instructions => $_getList(6);

  /// What was given in theatre, so recovery knows what is already on board
  /// before giving more.
  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get analgesiaGiven => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get antiemeticGiven => $_getList(8);

  @$pb.TagNumber(10)
  $0.Timestamp get handedOverAt => $_getN(9);
  @$pb.TagNumber(10)
  set handedOverAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasHandedOverAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearHandedOverAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureHandedOverAt() => $_ensure(9);
}

/// One element of a recovery score.
class ScoreComponent extends $pb.GeneratedMessage {
  factory ScoreComponent({
    $core.String? code,
    $core.String? label,
    $core.int? max,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (label != null) result.label = label;
    if (max != null) result.max = max;
    return result;
  }

  ScoreComponent._();

  factory ScoreComponent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScoreComponent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScoreComponent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aI(3, _omitFieldNames ? '' : 'max')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScoreComponent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScoreComponent copyWith(void Function(ScoreComponent) updates) =>
      super.copyWith((message) => updates(message as ScoreComponent))
          as ScoreComponent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScoreComponent create() => ScoreComponent._();
  @$core.override
  ScoreComponent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScoreComponent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScoreComponent>(create);
  static ScoreComponent? _defaultInstance;

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
  $core.int get max => $_getIZ(2);
  @$pb.TagNumber(3)
  set max($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMax() => $_has(2);
  @$pb.TagNumber(3)
  void clearMax() => $_clearField(3);
}

/// The score this unit discharges from recovery on (SRS-ANE-008).
///
/// Configured rather than fixed: Aldrete, modified Aldrete and PADSS are all in
/// use. The threshold travels with the scale, so a score recorded under one is
/// never read against another's bar.
class RecoveryScale extends $pb.GeneratedMessage {
  factory RecoveryScale({
    $core.String? name,
    $core.String? version,
    $core.Iterable<ScoreComponent>? components,
    $core.int? dischargeAt,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (version != null) result.version = version;
    if (components != null) result.components.addAll(components);
    if (dischargeAt != null) result.dischargeAt = dischargeAt;
    return result;
  }

  RecoveryScale._();

  factory RecoveryScale.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecoveryScale.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecoveryScale',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..pPM<ScoreComponent>(3, _omitFieldNames ? '' : 'components',
        subBuilder: ScoreComponent.create)
    ..aI(4, _omitFieldNames ? '' : 'dischargeAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecoveryScale clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecoveryScale copyWith(void Function(RecoveryScale) updates) =>
      super.copyWith((message) => updates(message as RecoveryScale))
          as RecoveryScale;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecoveryScale create() => RecoveryScale._();
  @$core.override
  RecoveryScale createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecoveryScale getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecoveryScale>(create);
  static RecoveryScale? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<ScoreComponent> get components => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get dischargeAt => $_getIZ(3);
  @$pb.TagNumber(4)
  set dischargeAt($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDischargeAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearDischargeAt() => $_clearField(4);
}

/// One scored assessment in PACU (SRS-ANE-008).
class RecoveryAssessment extends $pb.GeneratedMessage {
  factory RecoveryAssessment({
    $core.String? assessmentId,
    $core.String? recordId,
    $core.String? scaleName,
    $core.String? scaleVersion,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? scores,
    $core.int? total,
    $core.int? dischargeThreshold,
    $core.Iterable<$core.String>? missing,
    $0.Timestamp? assessedAt,
    $core.String? assessedBy,
    $core.bool? complete,
    $core.bool? meetsThreshold,
  }) {
    final result = create();
    if (assessmentId != null) result.assessmentId = assessmentId;
    if (recordId != null) result.recordId = recordId;
    if (scaleName != null) result.scaleName = scaleName;
    if (scaleVersion != null) result.scaleVersion = scaleVersion;
    if (scores != null) result.scores.addEntries(scores);
    if (total != null) result.total = total;
    if (dischargeThreshold != null)
      result.dischargeThreshold = dischargeThreshold;
    if (missing != null) result.missing.addAll(missing);
    if (assessedAt != null) result.assessedAt = assessedAt;
    if (assessedBy != null) result.assessedBy = assessedBy;
    if (complete != null) result.complete = complete;
    if (meetsThreshold != null) result.meetsThreshold = meetsThreshold;
    return result;
  }

  RecoveryAssessment._();

  factory RecoveryAssessment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecoveryAssessment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecoveryAssessment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assessmentId')
    ..aOS(2, _omitFieldNames ? '' : 'recordId')
    ..aOS(3, _omitFieldNames ? '' : 'scaleName')
    ..aOS(4, _omitFieldNames ? '' : 'scaleVersion')
    ..m<$core.String, $core.int>(5, _omitFieldNames ? '' : 'scores',
        entryClassName: 'RecoveryAssessment.ScoresEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('healthcare.anaesthesia.v1'))
    ..aI(6, _omitFieldNames ? '' : 'total')
    ..aI(7, _omitFieldNames ? '' : 'dischargeThreshold')
    ..pPS(8, _omitFieldNames ? '' : 'missing')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'assessedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'assessedBy')
    ..aOB(11, _omitFieldNames ? '' : 'complete')
    ..aOB(12, _omitFieldNames ? '' : 'meetsThreshold')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecoveryAssessment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecoveryAssessment copyWith(void Function(RecoveryAssessment) updates) =>
      super.copyWith((message) => updates(message as RecoveryAssessment))
          as RecoveryAssessment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecoveryAssessment create() => RecoveryAssessment._();
  @$core.override
  RecoveryAssessment createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecoveryAssessment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecoveryAssessment>(create);
  static RecoveryAssessment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assessmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assessmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssessmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssessmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recordId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recordId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scaleName => $_getSZ(2);
  @$pb.TagNumber(3)
  set scaleName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScaleName() => $_has(2);
  @$pb.TagNumber(3)
  void clearScaleName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get scaleVersion => $_getSZ(3);
  @$pb.TagNumber(4)
  set scaleVersion($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScaleVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearScaleVersion() => $_clearField(4);

  /// The component values as recorded, so the total can be read back rather
  /// than taken on trust.
  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.int> get scores => $_getMap(4);

  @$pb.TagNumber(6)
  $core.int get total => $_getIZ(5);
  @$pb.TagNumber(6)
  set total($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTotal() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotal() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get dischargeThreshold => $_getIZ(6);
  @$pb.TagNumber(7)
  set dischargeThreshold($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDischargeThreshold() => $_has(6);
  @$pb.TagNumber(7)
  void clearDischargeThreshold() => $_clearField(7);

  /// Components with no score. A partial assessment is not a low one.
  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get missing => $_getList(7);

  @$pb.TagNumber(9)
  $0.Timestamp get assessedAt => $_getN(8);
  @$pb.TagNumber(9)
  set assessedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasAssessedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearAssessedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureAssessedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get assessedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set assessedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAssessedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearAssessedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get complete => $_getBF(10);
  @$pb.TagNumber(11)
  set complete($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasComplete() => $_has(10);
  @$pb.TagNumber(11)
  void clearComplete() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get meetsThreshold => $_getBF(11);
  @$pb.TagNumber(12)
  set meetsThreshold($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMeetsThreshold() => $_has(11);
  @$pb.TagNumber(12)
  void clearMeetsThreshold() => $_clearField(12);
}

/// Whether a patient may leave recovery, and why not (SRS-ANE-008).
class DischargeDecision extends $pb.GeneratedMessage {
  factory DischargeDecision({
    $core.bool? allowed,
    $core.Iterable<DischargeRefusal>? refusals,
    $core.Iterable<$core.String>? explanations,
    RecoveryAssessment? score,
  }) {
    final result = create();
    if (allowed != null) result.allowed = allowed;
    if (refusals != null) result.refusals.addAll(refusals);
    if (explanations != null) result.explanations.addAll(explanations);
    if (score != null) result.score = score;
    return result;
  }

  DischargeDecision._();

  factory DischargeDecision.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DischargeDecision.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DischargeDecision',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'allowed')
    ..pc<DischargeRefusal>(
        2, _omitFieldNames ? '' : 'refusals', $pb.PbFieldType.KE,
        valueOf: DischargeRefusal.valueOf,
        enumValues: DischargeRefusal.values,
        defaultEnumValue: DischargeRefusal.DISCHARGE_REFUSAL_UNSPECIFIED)
    ..pPS(3, _omitFieldNames ? '' : 'explanations')
    ..aOM<RecoveryAssessment>(4, _omitFieldNames ? '' : 'score',
        subBuilder: RecoveryAssessment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DischargeDecision clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DischargeDecision copyWith(void Function(DischargeDecision) updates) =>
      super.copyWith((message) => updates(message as DischargeDecision))
          as DischargeDecision;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DischargeDecision create() => DischargeDecision._();
  @$core.override
  DischargeDecision createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DischargeDecision getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DischargeDecision>(create);
  static DischargeDecision? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get allowed => $_getBF(0);
  @$pb.TagNumber(1)
  set allowed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAllowed() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllowed() => $_clearField(1);

  /// Every refusal, not the first.
  @$pb.TagNumber(2)
  $pb.PbList<DischargeRefusal> get refusals => $_getList(1);

  /// In words, so a client need not carry the explanations.
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get explanations => $_getList(2);

  /// The assessment the decision was made against, where one exists.
  @$pb.TagNumber(4)
  RecoveryAssessment get score => $_getN(3);
  @$pb.TagNumber(4)
  set score(RecoveryAssessment value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearScore() => $_clearField(4);
  @$pb.TagNumber(4)
  RecoveryAssessment ensureScore() => $_ensure(3);
}

/// A discharge from recovery (SRS-ANE-008).
class Discharge extends $pb.GeneratedMessage {
  factory Discharge({
    $core.String? dischargeId,
    $core.String? recordId,
    $core.String? destination,
    $core.bool? overridden,
    $core.String? overrideReason,
    $core.String? scoreId,
    $0.Timestamp? dischargedAt,
    $core.String? dischargedBy,
  }) {
    final result = create();
    if (dischargeId != null) result.dischargeId = dischargeId;
    if (recordId != null) result.recordId = recordId;
    if (destination != null) result.destination = destination;
    if (overridden != null) result.overridden = overridden;
    if (overrideReason != null) result.overrideReason = overrideReason;
    if (scoreId != null) result.scoreId = scoreId;
    if (dischargedAt != null) result.dischargedAt = dischargedAt;
    if (dischargedBy != null) result.dischargedBy = dischargedBy;
    return result;
  }

  Discharge._();

  factory Discharge.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Discharge.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Discharge',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'dischargeId')
    ..aOS(2, _omitFieldNames ? '' : 'recordId')
    ..aOS(3, _omitFieldNames ? '' : 'destination')
    ..aOB(4, _omitFieldNames ? '' : 'overridden')
    ..aOS(5, _omitFieldNames ? '' : 'overrideReason')
    ..aOS(6, _omitFieldNames ? '' : 'scoreId')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'dischargedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'dischargedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Discharge clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Discharge copyWith(void Function(Discharge) updates) =>
      super.copyWith((message) => updates(message as Discharge)) as Discharge;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Discharge create() => Discharge._();
  @$core.override
  Discharge createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Discharge getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Discharge>(create);
  static Discharge? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get dischargeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set dischargeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDischargeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDischargeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recordId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recordId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get destination => $_getSZ(2);
  @$pb.TagNumber(3)
  set destination($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDestination() => $_has(2);
  @$pb.TagNumber(3)
  void clearDestination() => $_clearField(3);

  /// A discharge below the threshold, with the reason. The override is the
  /// whole of what a review reads.
  @$pb.TagNumber(4)
  $core.bool get overridden => $_getBF(3);
  @$pb.TagNumber(4)
  set overridden($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOverridden() => $_has(3);
  @$pb.TagNumber(4)
  void clearOverridden() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get overrideReason => $_getSZ(4);
  @$pb.TagNumber(5)
  set overrideReason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOverrideReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearOverrideReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get scoreId => $_getSZ(5);
  @$pb.TagNumber(6)
  set scoreId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasScoreId() => $_has(5);
  @$pb.TagNumber(6)
  void clearScoreId() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get dischargedAt => $_getN(6);
  @$pb.TagNumber(7)
  set dischargedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDischargedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearDischargedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureDischargedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get dischargedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set dischargedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDischargedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearDischargedBy() => $_clearField(8);
}

/// An acute pain instruction (SRS-ANE-009).
class PainOrder extends $pb.GeneratedMessage {
  factory PainOrder({
    $core.String? orderId,
    $core.String? recordId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? modality,
    $core.Iterable<$core.String>? prescriptionIds,
    $core.String? targetScore,
    $core.Iterable<$core.String>? monitoring,
    $core.String? escalation,
    $0.Timestamp? reviewBy,
    $core.String? orderedBy,
    $0.Timestamp? orderedAt,
    $0.Timestamp? stoppedAt,
    $core.String? stoppedBy,
    $core.bool? reviewOverdue,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (recordId != null) result.recordId = recordId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (modality != null) result.modality = modality;
    if (prescriptionIds != null) result.prescriptionIds.addAll(prescriptionIds);
    if (targetScore != null) result.targetScore = targetScore;
    if (monitoring != null) result.monitoring.addAll(monitoring);
    if (escalation != null) result.escalation = escalation;
    if (reviewBy != null) result.reviewBy = reviewBy;
    if (orderedBy != null) result.orderedBy = orderedBy;
    if (orderedAt != null) result.orderedAt = orderedAt;
    if (stoppedAt != null) result.stoppedAt = stoppedAt;
    if (stoppedBy != null) result.stoppedBy = stoppedBy;
    if (reviewOverdue != null) result.reviewOverdue = reviewOverdue;
    return result;
  }

  PainOrder._();

  factory PainOrder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PainOrder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PainOrder',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aOS(2, _omitFieldNames ? '' : 'recordId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'encounterId')
    ..aOS(5, _omitFieldNames ? '' : 'modality')
    ..pPS(6, _omitFieldNames ? '' : 'prescriptionIds')
    ..aOS(7, _omitFieldNames ? '' : 'targetScore')
    ..pPS(8, _omitFieldNames ? '' : 'monitoring')
    ..aOS(9, _omitFieldNames ? '' : 'escalation')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'reviewBy',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'orderedBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'orderedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'stoppedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(14, _omitFieldNames ? '' : 'stoppedBy')
    ..aOB(15, _omitFieldNames ? '' : 'reviewOverdue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PainOrder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PainOrder copyWith(void Function(PainOrder) updates) =>
      super.copyWith((message) => updates(message as PainOrder)) as PainOrder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PainOrder create() => PainOrder._();
  @$core.override
  PainOrder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PainOrder getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PainOrder>(create);
  static PainOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recordId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recordId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordId() => $_clearField(2);

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
  $core.String get modality => $_getSZ(4);
  @$pb.TagNumber(5)
  set modality($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasModality() => $_has(4);
  @$pb.TagNumber(5)
  void clearModality() => $_clearField(5);

  /// The drug chart is SRS-MED's. A second place to prescribe from is how a
  /// patient gets two doses, so this names the prescriptions rather than being
  /// one.
  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get prescriptionIds => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get targetScore => $_getSZ(6);
  @$pb.TagNumber(7)
  set targetScore($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTargetScore() => $_has(6);
  @$pb.TagNumber(7)
  void clearTargetScore() => $_clearField(7);

  /// A plan with nothing to observe is one nursing cannot follow, and one with
  /// no escalation is one a ward nurse cannot act on at 3am.
  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get monitoring => $_getList(7);

  @$pb.TagNumber(9)
  $core.String get escalation => $_getSZ(8);
  @$pb.TagNumber(9)
  set escalation($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEscalation() => $_has(8);
  @$pb.TagNumber(9)
  void clearEscalation() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get reviewBy => $_getN(9);
  @$pb.TagNumber(10)
  set reviewBy($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasReviewBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearReviewBy() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureReviewBy() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get orderedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set orderedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOrderedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearOrderedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get orderedAt => $_getN(11);
  @$pb.TagNumber(12)
  set orderedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasOrderedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearOrderedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureOrderedAt() => $_ensure(11);

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
  $core.bool get reviewOverdue => $_getBF(14);
  @$pb.TagNumber(15)
  set reviewOverdue($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasReviewOverdue() => $_has(14);
  @$pb.TagNumber(15)
  void clearReviewOverdue() => $_clearField(15);
}

/// The anaesthetic summary (SRS-ANE-010).
///
/// Derived, never submitted.
class Summary extends $pb.GeneratedMessage {
  factory Summary({
    $core.String? recordId,
    $core.String? caseId,
    $core.String? patientId,
    Technique? technique,
    $core.String? asaGrade,
    $0.Timestamp? startedAt,
    $0.Timestamp? endedAt,
    DifficultAirway? airway,
    $core.Iterable<DrugEntry>? keyDrugs,
    FluidBalance? fluids,
    $core.Iterable<$core.String>? events,
    RecoveryAssessment? recovery,
    $core.String? disposal,
    $core.bool? dischargeOverridden,
    $core.String? overrideReason,
    $core.Iterable<$core.String>? incomplete,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (caseId != null) result.caseId = caseId;
    if (patientId != null) result.patientId = patientId;
    if (technique != null) result.technique = technique;
    if (asaGrade != null) result.asaGrade = asaGrade;
    if (startedAt != null) result.startedAt = startedAt;
    if (endedAt != null) result.endedAt = endedAt;
    if (airway != null) result.airway = airway;
    if (keyDrugs != null) result.keyDrugs.addAll(keyDrugs);
    if (fluids != null) result.fluids = fluids;
    if (events != null) result.events.addAll(events);
    if (recovery != null) result.recovery = recovery;
    if (disposal != null) result.disposal = disposal;
    if (dischargeOverridden != null)
      result.dischargeOverridden = dischargeOverridden;
    if (overrideReason != null) result.overrideReason = overrideReason;
    if (incomplete != null) result.incomplete.addAll(incomplete);
    return result;
  }

  Summary._();

  factory Summary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Summary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Summary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aE<Technique>(4, _omitFieldNames ? '' : 'technique',
        enumValues: Technique.values)
    ..aOS(5, _omitFieldNames ? '' : 'asaGrade')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<DifficultAirway>(8, _omitFieldNames ? '' : 'airway',
        subBuilder: DifficultAirway.create)
    ..pPM<DrugEntry>(9, _omitFieldNames ? '' : 'keyDrugs',
        subBuilder: DrugEntry.create)
    ..aOM<FluidBalance>(10, _omitFieldNames ? '' : 'fluids',
        subBuilder: FluidBalance.create)
    ..pPS(11, _omitFieldNames ? '' : 'events')
    ..aOM<RecoveryAssessment>(12, _omitFieldNames ? '' : 'recovery',
        subBuilder: RecoveryAssessment.create)
    ..aOS(13, _omitFieldNames ? '' : 'disposal')
    ..aOB(14, _omitFieldNames ? '' : 'dischargeOverridden')
    ..aOS(15, _omitFieldNames ? '' : 'overrideReason')
    ..pPS(16, _omitFieldNames ? '' : 'incomplete')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Summary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Summary copyWith(void Function(Summary) updates) =>
      super.copyWith((message) => updates(message as Summary)) as Summary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Summary create() => Summary._();
  @$core.override
  Summary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Summary getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Summary>(create);
  static Summary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

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
  Technique get technique => $_getN(3);
  @$pb.TagNumber(4)
  set technique(Technique value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTechnique() => $_has(3);
  @$pb.TagNumber(4)
  void clearTechnique() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get asaGrade => $_getSZ(4);
  @$pb.TagNumber(5)
  set asaGrade($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAsaGrade() => $_has(4);
  @$pb.TagNumber(5)
  void clearAsaGrade() => $_clearField(5);

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
  $0.Timestamp get endedAt => $_getN(6);
  @$pb.TagNumber(7)
  set endedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasEndedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearEndedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureEndedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  DifficultAirway get airway => $_getN(7);
  @$pb.TagNumber(8)
  set airway(DifficultAirway value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasAirway() => $_has(7);
  @$pb.TagNumber(8)
  void clearAirway() => $_clearField(8);
  @$pb.TagNumber(8)
  DifficultAirway ensureAirway() => $_ensure(7);

  @$pb.TagNumber(9)
  $pb.PbList<DrugEntry> get keyDrugs => $_getList(8);

  @$pb.TagNumber(10)
  FluidBalance get fluids => $_getN(9);
  @$pb.TagNumber(10)
  set fluids(FluidBalance value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasFluids() => $_has(9);
  @$pb.TagNumber(10)
  void clearFluids() => $_clearField(10);
  @$pb.TagNumber(10)
  FluidBalance ensureFluids() => $_ensure(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get events => $_getList(10);

  @$pb.TagNumber(12)
  RecoveryAssessment get recovery => $_getN(11);
  @$pb.TagNumber(12)
  set recovery(RecoveryAssessment value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasRecovery() => $_has(11);
  @$pb.TagNumber(12)
  void clearRecovery() => $_clearField(12);
  @$pb.TagNumber(12)
  RecoveryAssessment ensureRecovery() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get disposal => $_getSZ(12);
  @$pb.TagNumber(13)
  set disposal($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDisposal() => $_has(12);
  @$pb.TagNumber(13)
  void clearDisposal() => $_clearField(13);

  /// A recovery discharge below the threshold, which is the one thing a
  /// summary reader must not have to dig for.
  @$pb.TagNumber(14)
  $core.bool get dischargeOverridden => $_getBF(13);
  @$pb.TagNumber(14)
  set dischargeOverridden($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasDischargeOverridden() => $_has(13);
  @$pb.TagNumber(14)
  void clearDischargeOverridden() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get overrideReason => $_getSZ(14);
  @$pb.TagNumber(15)
  set overrideReason($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasOverrideReason() => $_has(14);
  @$pb.TagNumber(15)
  void clearOverrideReason() => $_clearField(15);

  /// What the summary could not be built from. A summary that quietly omitted
  /// the recovery score would read as a patient who was never scored.
  @$pb.TagNumber(16)
  $pb.PbList<$core.String> get incomplete => $_getList(15);
}

class RecordAssessmentRequest extends $pb.GeneratedMessage {
  factory RecordAssessmentRequest({
    $core.String? caseId,
    $core.String? encounterId,
    $core.String? patientId,
    $core.String? history,
    AirwayAssessment? airway,
    $core.String? asaGrade,
    $core.Iterable<$core.String>? investigations,
    $core.Iterable<$core.String>? risks,
    $core.String? plan,
    ConsentStatus? consent,
    $core.String? consentNote,
    $core.bool? fitToProceed,
    $core.Iterable<$core.String>? conditions,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (history != null) result.history = history;
    if (airway != null) result.airway = airway;
    if (asaGrade != null) result.asaGrade = asaGrade;
    if (investigations != null) result.investigations.addAll(investigations);
    if (risks != null) result.risks.addAll(risks);
    if (plan != null) result.plan = plan;
    if (consent != null) result.consent = consent;
    if (consentNote != null) result.consentNote = consentNote;
    if (fitToProceed != null) result.fitToProceed = fitToProceed;
    if (conditions != null) result.conditions.addAll(conditions);
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
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'history')
    ..aOM<AirwayAssessment>(5, _omitFieldNames ? '' : 'airway',
        subBuilder: AirwayAssessment.create)
    ..aOS(6, _omitFieldNames ? '' : 'asaGrade')
    ..pPS(7, _omitFieldNames ? '' : 'investigations')
    ..pPS(8, _omitFieldNames ? '' : 'risks')
    ..aOS(9, _omitFieldNames ? '' : 'plan')
    ..aE<ConsentStatus>(10, _omitFieldNames ? '' : 'consent',
        enumValues: ConsentStatus.values)
    ..aOS(11, _omitFieldNames ? '' : 'consentNote')
    ..aOB(12, _omitFieldNames ? '' : 'fitToProceed')
    ..pPS(13, _omitFieldNames ? '' : 'conditions')
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
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

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
  $core.String get history => $_getSZ(3);
  @$pb.TagNumber(4)
  set history($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHistory() => $_has(3);
  @$pb.TagNumber(4)
  void clearHistory() => $_clearField(4);

  @$pb.TagNumber(5)
  AirwayAssessment get airway => $_getN(4);
  @$pb.TagNumber(5)
  set airway(AirwayAssessment value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAirway() => $_has(4);
  @$pb.TagNumber(5)
  void clearAirway() => $_clearField(5);
  @$pb.TagNumber(5)
  AirwayAssessment ensureAirway() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get asaGrade => $_getSZ(5);
  @$pb.TagNumber(6)
  set asaGrade($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAsaGrade() => $_has(5);
  @$pb.TagNumber(6)
  void clearAsaGrade() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get investigations => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get risks => $_getList(7);

  @$pb.TagNumber(9)
  $core.String get plan => $_getSZ(8);
  @$pb.TagNumber(9)
  set plan($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPlan() => $_has(8);
  @$pb.TagNumber(9)
  void clearPlan() => $_clearField(9);

  @$pb.TagNumber(10)
  ConsentStatus get consent => $_getN(9);
  @$pb.TagNumber(10)
  set consent(ConsentStatus value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasConsent() => $_has(9);
  @$pb.TagNumber(10)
  void clearConsent() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get consentNote => $_getSZ(10);
  @$pb.TagNumber(11)
  set consentNote($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasConsentNote() => $_has(10);
  @$pb.TagNumber(11)
  void clearConsentNote() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get fitToProceed => $_getBF(11);
  @$pb.TagNumber(12)
  set fitToProceed($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasFitToProceed() => $_has(11);
  @$pb.TagNumber(12)
  void clearFitToProceed() => $_clearField(12);

  @$pb.TagNumber(13)
  $pb.PbList<$core.String> get conditions => $_getList(12);
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
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
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
    $core.String? caseId,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
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
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
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
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
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
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
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

class ListPatientAssessmentsRequest extends $pb.GeneratedMessage {
  factory ListPatientAssessmentsRequest({
    $core.String? patientId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListPatientAssessmentsRequest._();

  factory ListPatientAssessmentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPatientAssessmentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPatientAssessmentsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPatientAssessmentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPatientAssessmentsRequest copyWith(
          void Function(ListPatientAssessmentsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListPatientAssessmentsRequest))
          as ListPatientAssessmentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPatientAssessmentsRequest create() =>
      ListPatientAssessmentsRequest._();
  @$core.override
  ListPatientAssessmentsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPatientAssessmentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPatientAssessmentsRequest>(create);
  static ListPatientAssessmentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListPatientAssessmentsResponse extends $pb.GeneratedMessage {
  factory ListPatientAssessmentsResponse({
    $core.Iterable<Assessment>? assessments,
  }) {
    final result = create();
    if (assessments != null) result.assessments.addAll(assessments);
    return result;
  }

  ListPatientAssessmentsResponse._();

  factory ListPatientAssessmentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPatientAssessmentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPatientAssessmentsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..pPM<Assessment>(1, _omitFieldNames ? '' : 'assessments',
        subBuilder: Assessment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPatientAssessmentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPatientAssessmentsResponse copyWith(
          void Function(ListPatientAssessmentsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListPatientAssessmentsResponse))
          as ListPatientAssessmentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPatientAssessmentsResponse create() =>
      ListPatientAssessmentsResponse._();
  @$core.override
  ListPatientAssessmentsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPatientAssessmentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPatientAssessmentsResponse>(create);
  static ListPatientAssessmentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Assessment> get assessments => $_getList(0);
}

class RecordPlanRequest extends $pb.GeneratedMessage {
  factory RecordPlanRequest({
    $core.String? caseId,
    Technique? technique,
    $core.Iterable<$core.String>? agents,
    $core.String? airway,
    $core.Iterable<$core.String>? monitoring,
    $core.Iterable<$core.String>? specialEquipment,
    $core.String? postOperative,
    $core.String? notes,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (technique != null) result.technique = technique;
    if (agents != null) result.agents.addAll(agents);
    if (airway != null) result.airway = airway;
    if (monitoring != null) result.monitoring.addAll(monitoring);
    if (specialEquipment != null)
      result.specialEquipment.addAll(specialEquipment);
    if (postOperative != null) result.postOperative = postOperative;
    if (notes != null) result.notes = notes;
    return result;
  }

  RecordPlanRequest._();

  factory RecordPlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordPlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordPlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aE<Technique>(2, _omitFieldNames ? '' : 'technique',
        enumValues: Technique.values)
    ..pPS(3, _omitFieldNames ? '' : 'agents')
    ..aOS(4, _omitFieldNames ? '' : 'airway')
    ..pPS(5, _omitFieldNames ? '' : 'monitoring')
    ..pPS(6, _omitFieldNames ? '' : 'specialEquipment')
    ..aOS(7, _omitFieldNames ? '' : 'postOperative')
    ..aOS(8, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordPlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordPlanRequest copyWith(void Function(RecordPlanRequest) updates) =>
      super.copyWith((message) => updates(message as RecordPlanRequest))
          as RecordPlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordPlanRequest create() => RecordPlanRequest._();
  @$core.override
  RecordPlanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordPlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordPlanRequest>(create);
  static RecordPlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  Technique get technique => $_getN(1);
  @$pb.TagNumber(2)
  set technique(Technique value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTechnique() => $_has(1);
  @$pb.TagNumber(2)
  void clearTechnique() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get agents => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get airway => $_getSZ(3);
  @$pb.TagNumber(4)
  set airway($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAirway() => $_has(3);
  @$pb.TagNumber(4)
  void clearAirway() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get monitoring => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get specialEquipment => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get postOperative => $_getSZ(6);
  @$pb.TagNumber(7)
  set postOperative($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPostOperative() => $_has(6);
  @$pb.TagNumber(7)
  void clearPostOperative() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get notes => $_getSZ(7);
  @$pb.TagNumber(8)
  set notes($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNotes() => $_has(7);
  @$pb.TagNumber(8)
  void clearNotes() => $_clearField(8);
}

class RecordPlanResponse extends $pb.GeneratedMessage {
  factory RecordPlanResponse({
    Plan? plan,
  }) {
    final result = create();
    if (plan != null) result.plan = plan;
    return result;
  }

  RecordPlanResponse._();

  factory RecordPlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordPlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordPlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<Plan>(1, _omitFieldNames ? '' : 'plan', subBuilder: Plan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordPlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordPlanResponse copyWith(void Function(RecordPlanResponse) updates) =>
      super.copyWith((message) => updates(message as RecordPlanResponse))
          as RecordPlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordPlanResponse create() => RecordPlanResponse._();
  @$core.override
  RecordPlanResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordPlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordPlanResponse>(create);
  static RecordPlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Plan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(Plan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  Plan ensurePlan() => $_ensure(0);
}

class GetPlanRequest extends $pb.GeneratedMessage {
  factory GetPlanRequest({
    $core.String? caseId,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    return result;
  }

  GetPlanRequest._();

  factory GetPlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlanRequest copyWith(void Function(GetPlanRequest) updates) =>
      super.copyWith((message) => updates(message as GetPlanRequest))
          as GetPlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPlanRequest create() => GetPlanRequest._();
  @$core.override
  GetPlanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPlanRequest>(create);
  static GetPlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
}

class GetPlanResponse extends $pb.GeneratedMessage {
  factory GetPlanResponse({
    Plan? plan,
  }) {
    final result = create();
    if (plan != null) result.plan = plan;
    return result;
  }

  GetPlanResponse._();

  factory GetPlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<Plan>(1, _omitFieldNames ? '' : 'plan', subBuilder: Plan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlanResponse copyWith(void Function(GetPlanResponse) updates) =>
      super.copyWith((message) => updates(message as GetPlanResponse))
          as GetPlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPlanResponse create() => GetPlanResponse._();
  @$core.override
  GetPlanResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPlanResponse>(create);
  static GetPlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Plan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(Plan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  Plan ensurePlan() => $_ensure(0);
}

class GetReadinessRequest extends $pb.GeneratedMessage {
  factory GetReadinessRequest({
    $core.String? caseId,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    return result;
  }

  GetReadinessRequest._();

  factory GetReadinessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReadinessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReadinessRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReadinessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReadinessRequest copyWith(void Function(GetReadinessRequest) updates) =>
      super.copyWith((message) => updates(message as GetReadinessRequest))
          as GetReadinessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReadinessRequest create() => GetReadinessRequest._();
  @$core.override
  GetReadinessRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetReadinessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReadinessRequest>(create);
  static GetReadinessRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
}

class GetReadinessResponse extends $pb.GeneratedMessage {
  factory GetReadinessResponse({
    Readiness? readiness,
  }) {
    final result = create();
    if (readiness != null) result.readiness = readiness;
    return result;
  }

  GetReadinessResponse._();

  factory GetReadinessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReadinessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReadinessResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<Readiness>(1, _omitFieldNames ? '' : 'readiness',
        subBuilder: Readiness.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReadinessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReadinessResponse copyWith(void Function(GetReadinessResponse) updates) =>
      super.copyWith((message) => updates(message as GetReadinessResponse))
          as GetReadinessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReadinessResponse create() => GetReadinessResponse._();
  @$core.override
  GetReadinessResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetReadinessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReadinessResponse>(create);
  static GetReadinessResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Readiness get readiness => $_getN(0);
  @$pb.TagNumber(1)
  set readiness(Readiness value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReadiness() => $_has(0);
  @$pb.TagNumber(1)
  void clearReadiness() => $_clearField(1);
  @$pb.TagNumber(1)
  Readiness ensureReadiness() => $_ensure(0);
}

class OpenRecordRequest extends $pb.GeneratedMessage {
  factory OpenRecordRequest({
    $core.String? caseId,
    $core.String? encounterId,
    $core.String? patientId,
    Technique? technique,
    $0.Timestamp? startedAt,
    EntrySource? origin,
    $core.String? importNote,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (technique != null) result.technique = technique;
    if (startedAt != null) result.startedAt = startedAt;
    if (origin != null) result.origin = origin;
    if (importNote != null) result.importNote = importNote;
    return result;
  }

  OpenRecordRequest._();

  factory OpenRecordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenRecordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenRecordRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aE<Technique>(4, _omitFieldNames ? '' : 'technique',
        enumValues: Technique.values)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aE<EntrySource>(6, _omitFieldNames ? '' : 'origin',
        enumValues: EntrySource.values)
    ..aOS(7, _omitFieldNames ? '' : 'importNote')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenRecordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenRecordRequest copyWith(void Function(OpenRecordRequest) updates) =>
      super.copyWith((message) => updates(message as OpenRecordRequest))
          as OpenRecordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenRecordRequest create() => OpenRecordRequest._();
  @$core.override
  OpenRecordRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenRecordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenRecordRequest>(create);
  static OpenRecordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

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
  Technique get technique => $_getN(3);
  @$pb.TagNumber(4)
  set technique(Technique value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTechnique() => $_has(3);
  @$pb.TagNumber(4)
  void clearTechnique() => $_clearField(4);

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

  /// Marks a downtime transcription. An imported record needs its own
  /// permission and says where it came from.
  @$pb.TagNumber(6)
  EntrySource get origin => $_getN(5);
  @$pb.TagNumber(6)
  set origin(EntrySource value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOrigin() => $_has(5);
  @$pb.TagNumber(6)
  void clearOrigin() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get importNote => $_getSZ(6);
  @$pb.TagNumber(7)
  set importNote($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasImportNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearImportNote() => $_clearField(7);
}

class OpenRecordResponse extends $pb.GeneratedMessage {
  factory OpenRecordResponse({
    Record? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  OpenRecordResponse._();

  factory OpenRecordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenRecordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenRecordResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<Record>(1, _omitFieldNames ? '' : 'record', subBuilder: Record.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenRecordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenRecordResponse copyWith(void Function(OpenRecordResponse) updates) =>
      super.copyWith((message) => updates(message as OpenRecordResponse))
          as OpenRecordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenRecordResponse create() => OpenRecordResponse._();
  @$core.override
  OpenRecordResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenRecordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenRecordResponse>(create);
  static OpenRecordResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Record get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(Record value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  Record ensureRecord() => $_ensure(0);
}

class GetRecordRequest extends $pb.GeneratedMessage {
  factory GetRecordRequest({
    $core.String? recordId,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    return result;
  }

  GetRecordRequest._();

  factory GetRecordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRecordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRecordRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecordRequest copyWith(void Function(GetRecordRequest) updates) =>
      super.copyWith((message) => updates(message as GetRecordRequest))
          as GetRecordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRecordRequest create() => GetRecordRequest._();
  @$core.override
  GetRecordRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRecordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRecordRequest>(create);
  static GetRecordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);
}

class GetRecordResponse extends $pb.GeneratedMessage {
  factory GetRecordResponse({
    Record? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  GetRecordResponse._();

  factory GetRecordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRecordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRecordResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<Record>(1, _omitFieldNames ? '' : 'record', subBuilder: Record.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecordResponse copyWith(void Function(GetRecordResponse) updates) =>
      super.copyWith((message) => updates(message as GetRecordResponse))
          as GetRecordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRecordResponse create() => GetRecordResponse._();
  @$core.override
  GetRecordResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRecordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRecordResponse>(create);
  static GetRecordResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Record get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(Record value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  Record ensureRecord() => $_ensure(0);
}

class GetRecordForCaseRequest extends $pb.GeneratedMessage {
  factory GetRecordForCaseRequest({
    $core.String? caseId,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    return result;
  }

  GetRecordForCaseRequest._();

  factory GetRecordForCaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRecordForCaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRecordForCaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecordForCaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecordForCaseRequest copyWith(
          void Function(GetRecordForCaseRequest) updates) =>
      super.copyWith((message) => updates(message as GetRecordForCaseRequest))
          as GetRecordForCaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRecordForCaseRequest create() => GetRecordForCaseRequest._();
  @$core.override
  GetRecordForCaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRecordForCaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRecordForCaseRequest>(create);
  static GetRecordForCaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
}

class GetRecordForCaseResponse extends $pb.GeneratedMessage {
  factory GetRecordForCaseResponse({
    Record? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  GetRecordForCaseResponse._();

  factory GetRecordForCaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRecordForCaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRecordForCaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<Record>(1, _omitFieldNames ? '' : 'record', subBuilder: Record.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecordForCaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecordForCaseResponse copyWith(
          void Function(GetRecordForCaseResponse) updates) =>
      super.copyWith((message) => updates(message as GetRecordForCaseResponse))
          as GetRecordForCaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRecordForCaseResponse create() => GetRecordForCaseResponse._();
  @$core.override
  GetRecordForCaseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRecordForCaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRecordForCaseResponse>(create);
  static GetRecordForCaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Record get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(Record value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  Record ensureRecord() => $_ensure(0);
}

class ChartVitalRequest extends $pb.GeneratedMessage {
  factory ChartVitalRequest({
    $core.String? recordId,
    $core.String? code,
    $core.String? display,
    $core.double? value,
    $core.String? unit,
    EntrySource? source,
    DeviceLink? device,
    $0.Timestamp? observedAt,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (source != null) result.source = source;
    if (device != null) result.device = device;
    if (observedAt != null) result.observedAt = observedAt;
    return result;
  }

  ChartVitalRequest._();

  factory ChartVitalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChartVitalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChartVitalRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'display')
    ..aD(4, _omitFieldNames ? '' : 'value')
    ..aOS(5, _omitFieldNames ? '' : 'unit')
    ..aE<EntrySource>(6, _omitFieldNames ? '' : 'source',
        enumValues: EntrySource.values)
    ..aOM<DeviceLink>(7, _omitFieldNames ? '' : 'device',
        subBuilder: DeviceLink.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartVitalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartVitalRequest copyWith(void Function(ChartVitalRequest) updates) =>
      super.copyWith((message) => updates(message as ChartVitalRequest))
          as ChartVitalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChartVitalRequest create() => ChartVitalRequest._();
  @$core.override
  ChartVitalRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChartVitalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChartVitalRequest>(create);
  static ChartVitalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get display => $_getSZ(2);
  @$pb.TagNumber(3)
  set display($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplay() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplay() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get value => $_getN(3);
  @$pb.TagNumber(4)
  set value($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get unit => $_getSZ(4);
  @$pb.TagNumber(5)
  set unit($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnit() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnit() => $_clearField(5);

  @$pb.TagNumber(6)
  EntrySource get source => $_getN(5);
  @$pb.TagNumber(6)
  set source(EntrySource value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSource() => $_has(5);
  @$pb.TagNumber(6)
  void clearSource() => $_clearField(6);

  @$pb.TagNumber(7)
  DeviceLink get device => $_getN(6);
  @$pb.TagNumber(7)
  set device(DeviceLink value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDevice() => $_has(6);
  @$pb.TagNumber(7)
  void clearDevice() => $_clearField(7);
  @$pb.TagNumber(7)
  DeviceLink ensureDevice() => $_ensure(6);

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
}

class ChartVitalResponse extends $pb.GeneratedMessage {
  factory ChartVitalResponse({
    VitalEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  ChartVitalResponse._();

  factory ChartVitalResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChartVitalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChartVitalResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<VitalEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: VitalEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartVitalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartVitalResponse copyWith(void Function(ChartVitalResponse) updates) =>
      super.copyWith((message) => updates(message as ChartVitalResponse))
          as ChartVitalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChartVitalResponse create() => ChartVitalResponse._();
  @$core.override
  ChartVitalResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChartVitalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChartVitalResponse>(create);
  static ChartVitalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  VitalEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(VitalEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  VitalEntry ensureEntry() => $_ensure(0);
}

class ListVitalsRequest extends $pb.GeneratedMessage {
  factory ListVitalsRequest({
    $core.String? recordId,
    $core.String? code,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (code != null) result.code = code;
    return result;
  }

  ListVitalsRequest._();

  factory ListVitalsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListVitalsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListVitalsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVitalsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVitalsRequest copyWith(void Function(ListVitalsRequest) updates) =>
      super.copyWith((message) => updates(message as ListVitalsRequest))
          as ListVitalsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListVitalsRequest create() => ListVitalsRequest._();
  @$core.override
  ListVitalsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListVitalsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListVitalsRequest>(create);
  static ListVitalsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  /// Empty returns every series, which is what the record view reads.
  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);
}

class ListVitalsResponse extends $pb.GeneratedMessage {
  factory ListVitalsResponse({
    $core.Iterable<VitalEntry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  ListVitalsResponse._();

  factory ListVitalsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListVitalsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListVitalsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..pPM<VitalEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: VitalEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVitalsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVitalsResponse copyWith(void Function(ListVitalsResponse) updates) =>
      super.copyWith((message) => updates(message as ListVitalsResponse))
          as ListVitalsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListVitalsResponse create() => ListVitalsResponse._();
  @$core.override
  ListVitalsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListVitalsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListVitalsResponse>(create);
  static ListVitalsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<VitalEntry> get entries => $_getList(0);
}

class ChartDrugRequest extends $pb.GeneratedMessage {
  factory ChartDrugRequest({
    $core.String? recordId,
    $core.String? drugCode,
    $core.String? drugDisplay,
    $core.String? route,
    $core.double? dose,
    $core.String? doseUnit,
    $core.double? concentrationAmount,
    $core.String? concentrationUnit,
    $core.double? concentrationVolume,
    $core.double? rateMlPerHour,
    $core.bool? infusion,
    EntrySource? source,
    DeviceLink? device,
    $0.Timestamp? givenAt,
    $core.String? note,
    $core.String? expectedUnit,
    $core.bool? acknowledgedMismatch,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (drugCode != null) result.drugCode = drugCode;
    if (drugDisplay != null) result.drugDisplay = drugDisplay;
    if (route != null) result.route = route;
    if (dose != null) result.dose = dose;
    if (doseUnit != null) result.doseUnit = doseUnit;
    if (concentrationAmount != null)
      result.concentrationAmount = concentrationAmount;
    if (concentrationUnit != null) result.concentrationUnit = concentrationUnit;
    if (concentrationVolume != null)
      result.concentrationVolume = concentrationVolume;
    if (rateMlPerHour != null) result.rateMlPerHour = rateMlPerHour;
    if (infusion != null) result.infusion = infusion;
    if (source != null) result.source = source;
    if (device != null) result.device = device;
    if (givenAt != null) result.givenAt = givenAt;
    if (note != null) result.note = note;
    if (expectedUnit != null) result.expectedUnit = expectedUnit;
    if (acknowledgedMismatch != null)
      result.acknowledgedMismatch = acknowledgedMismatch;
    return result;
  }

  ChartDrugRequest._();

  factory ChartDrugRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChartDrugRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChartDrugRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'drugCode')
    ..aOS(3, _omitFieldNames ? '' : 'drugDisplay')
    ..aOS(4, _omitFieldNames ? '' : 'route')
    ..aD(5, _omitFieldNames ? '' : 'dose')
    ..aOS(6, _omitFieldNames ? '' : 'doseUnit')
    ..aD(7, _omitFieldNames ? '' : 'concentrationAmount')
    ..aOS(8, _omitFieldNames ? '' : 'concentrationUnit')
    ..aD(9, _omitFieldNames ? '' : 'concentrationVolume')
    ..aD(10, _omitFieldNames ? '' : 'rateMlPerHour')
    ..aOB(11, _omitFieldNames ? '' : 'infusion')
    ..aE<EntrySource>(12, _omitFieldNames ? '' : 'source',
        enumValues: EntrySource.values)
    ..aOM<DeviceLink>(13, _omitFieldNames ? '' : 'device',
        subBuilder: DeviceLink.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'givenAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'note')
    ..aOS(16, _omitFieldNames ? '' : 'expectedUnit')
    ..aOB(17, _omitFieldNames ? '' : 'acknowledgedMismatch')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartDrugRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartDrugRequest copyWith(void Function(ChartDrugRequest) updates) =>
      super.copyWith((message) => updates(message as ChartDrugRequest))
          as ChartDrugRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChartDrugRequest create() => ChartDrugRequest._();
  @$core.override
  ChartDrugRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChartDrugRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChartDrugRequest>(create);
  static ChartDrugRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get drugCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set drugCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDrugCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearDrugCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get drugDisplay => $_getSZ(2);
  @$pb.TagNumber(3)
  set drugDisplay($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDrugDisplay() => $_has(2);
  @$pb.TagNumber(3)
  void clearDrugDisplay() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get route => $_getSZ(3);
  @$pb.TagNumber(4)
  set route($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRoute() => $_has(3);
  @$pb.TagNumber(4)
  void clearRoute() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get dose => $_getN(4);
  @$pb.TagNumber(5)
  set dose($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDose() => $_has(4);
  @$pb.TagNumber(5)
  void clearDose() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get doseUnit => $_getSZ(5);
  @$pb.TagNumber(6)
  set doseUnit($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDoseUnit() => $_has(5);
  @$pb.TagNumber(6)
  void clearDoseUnit() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get concentrationAmount => $_getN(6);
  @$pb.TagNumber(7)
  set concentrationAmount($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasConcentrationAmount() => $_has(6);
  @$pb.TagNumber(7)
  void clearConcentrationAmount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get concentrationUnit => $_getSZ(7);
  @$pb.TagNumber(8)
  set concentrationUnit($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasConcentrationUnit() => $_has(7);
  @$pb.TagNumber(8)
  void clearConcentrationUnit() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get concentrationVolume => $_getN(8);
  @$pb.TagNumber(9)
  set concentrationVolume($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasConcentrationVolume() => $_has(8);
  @$pb.TagNumber(9)
  void clearConcentrationVolume() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get rateMlPerHour => $_getN(9);
  @$pb.TagNumber(10)
  set rateMlPerHour($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRateMlPerHour() => $_has(9);
  @$pb.TagNumber(10)
  void clearRateMlPerHour() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get infusion => $_getBF(10);
  @$pb.TagNumber(11)
  set infusion($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasInfusion() => $_has(10);
  @$pb.TagNumber(11)
  void clearInfusion() => $_clearField(11);

  @$pb.TagNumber(12)
  EntrySource get source => $_getN(11);
  @$pb.TagNumber(12)
  set source(EntrySource value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSource() => $_has(11);
  @$pb.TagNumber(12)
  void clearSource() => $_clearField(12);

  @$pb.TagNumber(13)
  DeviceLink get device => $_getN(12);
  @$pb.TagNumber(13)
  set device(DeviceLink value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasDevice() => $_has(12);
  @$pb.TagNumber(13)
  void clearDevice() => $_clearField(13);
  @$pb.TagNumber(13)
  DeviceLink ensureDevice() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Timestamp get givenAt => $_getN(13);
  @$pb.TagNumber(14)
  set givenAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasGivenAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearGivenAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureGivenAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get note => $_getSZ(14);
  @$pb.TagNumber(15)
  set note($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasNote() => $_has(14);
  @$pb.TagNumber(15)
  void clearNote() => $_clearField(15);

  /// The unit the formulary doses this drug in. A mismatch is refused unless
  /// the anaesthetist says explicitly that they meant it (SRS-ANE-004).
  @$pb.TagNumber(16)
  $core.String get expectedUnit => $_getSZ(15);
  @$pb.TagNumber(16)
  set expectedUnit($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasExpectedUnit() => $_has(15);
  @$pb.TagNumber(16)
  void clearExpectedUnit() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.bool get acknowledgedMismatch => $_getBF(16);
  @$pb.TagNumber(17)
  set acknowledgedMismatch($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasAcknowledgedMismatch() => $_has(16);
  @$pb.TagNumber(17)
  void clearAcknowledgedMismatch() => $_clearField(17);
}

class ChartDrugResponse extends $pb.GeneratedMessage {
  factory ChartDrugResponse({
    DrugEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  ChartDrugResponse._();

  factory ChartDrugResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChartDrugResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChartDrugResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<DrugEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: DrugEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartDrugResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartDrugResponse copyWith(void Function(ChartDrugResponse) updates) =>
      super.copyWith((message) => updates(message as ChartDrugResponse))
          as ChartDrugResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChartDrugResponse create() => ChartDrugResponse._();
  @$core.override
  ChartDrugResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChartDrugResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChartDrugResponse>(create);
  static ChartDrugResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DrugEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(DrugEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  DrugEntry ensureEntry() => $_ensure(0);
}

class ListDrugsRequest extends $pb.GeneratedMessage {
  factory ListDrugsRequest({
    $core.String? recordId,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    return result;
  }

  ListDrugsRequest._();

  factory ListDrugsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDrugsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDrugsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDrugsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDrugsRequest copyWith(void Function(ListDrugsRequest) updates) =>
      super.copyWith((message) => updates(message as ListDrugsRequest))
          as ListDrugsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDrugsRequest create() => ListDrugsRequest._();
  @$core.override
  ListDrugsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDrugsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDrugsRequest>(create);
  static ListDrugsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);
}

class ListDrugsResponse extends $pb.GeneratedMessage {
  factory ListDrugsResponse({
    $core.Iterable<DrugEntry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  ListDrugsResponse._();

  factory ListDrugsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDrugsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDrugsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..pPM<DrugEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: DrugEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDrugsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDrugsResponse copyWith(void Function(ListDrugsResponse) updates) =>
      super.copyWith((message) => updates(message as ListDrugsResponse))
          as ListDrugsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDrugsResponse create() => ListDrugsResponse._();
  @$core.override
  ListDrugsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDrugsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDrugsResponse>(create);
  static ListDrugsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DrugEntry> get entries => $_getList(0);
}

class StopInfusionRequest extends $pb.GeneratedMessage {
  factory StopInfusionRequest({
    $core.String? drugId,
    $0.Timestamp? stoppedAt,
  }) {
    final result = create();
    if (drugId != null) result.drugId = drugId;
    if (stoppedAt != null) result.stoppedAt = stoppedAt;
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
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drugId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'stoppedAt',
        subBuilder: $0.Timestamp.create)
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
  $core.String get drugId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drugId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDrugId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrugId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get stoppedAt => $_getN(1);
  @$pb.TagNumber(2)
  set stoppedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStoppedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearStoppedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureStoppedAt() => $_ensure(1);
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
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
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

class RecordAirwayRequest extends $pb.GeneratedMessage {
  factory RecordAirwayRequest({
    $core.String? recordId,
    $core.String? device,
    $core.int? attempt,
    $core.String? grade,
    $core.bool? successful,
    $core.String? difficulty,
    $core.Iterable<$core.String>? complications,
    $core.Iterable<$core.String>? adjuncts,
    $0.Timestamp? occurredAt,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (device != null) result.device = device;
    if (attempt != null) result.attempt = attempt;
    if (grade != null) result.grade = grade;
    if (successful != null) result.successful = successful;
    if (difficulty != null) result.difficulty = difficulty;
    if (complications != null) result.complications.addAll(complications);
    if (adjuncts != null) result.adjuncts.addAll(adjuncts);
    if (occurredAt != null) result.occurredAt = occurredAt;
    return result;
  }

  RecordAirwayRequest._();

  factory RecordAirwayRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordAirwayRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordAirwayRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'device')
    ..aI(3, _omitFieldNames ? '' : 'attempt')
    ..aOS(4, _omitFieldNames ? '' : 'grade')
    ..aOB(5, _omitFieldNames ? '' : 'successful')
    ..aOS(6, _omitFieldNames ? '' : 'difficulty')
    ..pPS(7, _omitFieldNames ? '' : 'complications')
    ..pPS(8, _omitFieldNames ? '' : 'adjuncts')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAirwayRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAirwayRequest copyWith(void Function(RecordAirwayRequest) updates) =>
      super.copyWith((message) => updates(message as RecordAirwayRequest))
          as RecordAirwayRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordAirwayRequest create() => RecordAirwayRequest._();
  @$core.override
  RecordAirwayRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordAirwayRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordAirwayRequest>(create);
  static RecordAirwayRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get device => $_getSZ(1);
  @$pb.TagNumber(2)
  set device($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDevice() => $_has(1);
  @$pb.TagNumber(2)
  void clearDevice() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get attempt => $_getIZ(2);
  @$pb.TagNumber(3)
  set attempt($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAttempt() => $_has(2);
  @$pb.TagNumber(3)
  void clearAttempt() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get grade => $_getSZ(3);
  @$pb.TagNumber(4)
  set grade($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasGrade() => $_has(3);
  @$pb.TagNumber(4)
  void clearGrade() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get successful => $_getBF(4);
  @$pb.TagNumber(5)
  set successful($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSuccessful() => $_has(4);
  @$pb.TagNumber(5)
  void clearSuccessful() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get difficulty => $_getSZ(5);
  @$pb.TagNumber(6)
  set difficulty($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDifficulty() => $_has(5);
  @$pb.TagNumber(6)
  void clearDifficulty() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get complications => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get adjuncts => $_getList(7);

  @$pb.TagNumber(9)
  $0.Timestamp get occurredAt => $_getN(8);
  @$pb.TagNumber(9)
  set occurredAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasOccurredAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearOccurredAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureOccurredAt() => $_ensure(8);
}

class RecordAirwayResponse extends $pb.GeneratedMessage {
  factory RecordAirwayResponse({
    AirwayEvent? event,
  }) {
    final result = create();
    if (event != null) result.event = event;
    return result;
  }

  RecordAirwayResponse._();

  factory RecordAirwayResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordAirwayResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordAirwayResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<AirwayEvent>(1, _omitFieldNames ? '' : 'event',
        subBuilder: AirwayEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAirwayResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAirwayResponse copyWith(void Function(RecordAirwayResponse) updates) =>
      super.copyWith((message) => updates(message as RecordAirwayResponse))
          as RecordAirwayResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordAirwayResponse create() => RecordAirwayResponse._();
  @$core.override
  RecordAirwayResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordAirwayResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordAirwayResponse>(create);
  static RecordAirwayResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AirwayEvent get event => $_getN(0);
  @$pb.TagNumber(1)
  set event(AirwayEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  AirwayEvent ensureEvent() => $_ensure(0);
}

class GetAirwayRequest extends $pb.GeneratedMessage {
  factory GetAirwayRequest({
    $core.String? recordId,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    return result;
  }

  GetAirwayRequest._();

  factory GetAirwayRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAirwayRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAirwayRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAirwayRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAirwayRequest copyWith(void Function(GetAirwayRequest) updates) =>
      super.copyWith((message) => updates(message as GetAirwayRequest))
          as GetAirwayRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAirwayRequest create() => GetAirwayRequest._();
  @$core.override
  GetAirwayRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAirwayRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAirwayRequest>(create);
  static GetAirwayRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);
}

class GetAirwayResponse extends $pb.GeneratedMessage {
  factory GetAirwayResponse({
    DifficultAirway? airway,
    $core.Iterable<AirwayEvent>? events,
  }) {
    final result = create();
    if (airway != null) result.airway = airway;
    if (events != null) result.events.addAll(events);
    return result;
  }

  GetAirwayResponse._();

  factory GetAirwayResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAirwayResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAirwayResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<DifficultAirway>(1, _omitFieldNames ? '' : 'airway',
        subBuilder: DifficultAirway.create)
    ..pPM<AirwayEvent>(2, _omitFieldNames ? '' : 'events',
        subBuilder: AirwayEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAirwayResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAirwayResponse copyWith(void Function(GetAirwayResponse) updates) =>
      super.copyWith((message) => updates(message as GetAirwayResponse))
          as GetAirwayResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAirwayResponse create() => GetAirwayResponse._();
  @$core.override
  GetAirwayResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAirwayResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAirwayResponse>(create);
  static GetAirwayResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DifficultAirway get airway => $_getN(0);
  @$pb.TagNumber(1)
  set airway(DifficultAirway value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAirway() => $_has(0);
  @$pb.TagNumber(1)
  void clearAirway() => $_clearField(1);
  @$pb.TagNumber(1)
  DifficultAirway ensureAirway() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<AirwayEvent> get events => $_getList(1);
}

class GetPatientAirwayRequest extends $pb.GeneratedMessage {
  factory GetPatientAirwayRequest({
    $core.String? patientId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetPatientAirwayRequest._();

  factory GetPatientAirwayRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPatientAirwayRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPatientAirwayRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPatientAirwayRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPatientAirwayRequest copyWith(
          void Function(GetPatientAirwayRequest) updates) =>
      super.copyWith((message) => updates(message as GetPatientAirwayRequest))
          as GetPatientAirwayRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPatientAirwayRequest create() => GetPatientAirwayRequest._();
  @$core.override
  GetPatientAirwayRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPatientAirwayRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPatientAirwayRequest>(create);
  static GetPatientAirwayRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class GetPatientAirwayResponse extends $pb.GeneratedMessage {
  factory GetPatientAirwayResponse({
    DifficultAirway? airway,
  }) {
    final result = create();
    if (airway != null) result.airway = airway;
    return result;
  }

  GetPatientAirwayResponse._();

  factory GetPatientAirwayResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPatientAirwayResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPatientAirwayResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<DifficultAirway>(1, _omitFieldNames ? '' : 'airway',
        subBuilder: DifficultAirway.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPatientAirwayResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPatientAirwayResponse copyWith(
          void Function(GetPatientAirwayResponse) updates) =>
      super.copyWith((message) => updates(message as GetPatientAirwayResponse))
          as GetPatientAirwayResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPatientAirwayResponse create() => GetPatientAirwayResponse._();
  @$core.override
  GetPatientAirwayResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPatientAirwayResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPatientAirwayResponse>(create);
  static GetPatientAirwayResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DifficultAirway get airway => $_getN(0);
  @$pb.TagNumber(1)
  set airway(DifficultAirway value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAirway() => $_has(0);
  @$pb.TagNumber(1)
  void clearAirway() => $_clearField(1);
  @$pb.TagNumber(1)
  DifficultAirway ensureAirway() => $_ensure(0);
}

class ChartFluidRequest extends $pb.GeneratedMessage {
  factory ChartFluidRequest({
    $core.String? recordId,
    FluidDirection? direction,
    $core.String? kind,
    $core.String? label,
    $core.double? volumeMl,
    $core.String? productId,
    $0.Timestamp? occurredAt,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (direction != null) result.direction = direction;
    if (kind != null) result.kind = kind;
    if (label != null) result.label = label;
    if (volumeMl != null) result.volumeMl = volumeMl;
    if (productId != null) result.productId = productId;
    if (occurredAt != null) result.occurredAt = occurredAt;
    return result;
  }

  ChartFluidRequest._();

  factory ChartFluidRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChartFluidRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChartFluidRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aE<FluidDirection>(2, _omitFieldNames ? '' : 'direction',
        enumValues: FluidDirection.values)
    ..aOS(3, _omitFieldNames ? '' : 'kind')
    ..aOS(4, _omitFieldNames ? '' : 'label')
    ..aD(5, _omitFieldNames ? '' : 'volumeMl')
    ..aOS(6, _omitFieldNames ? '' : 'productId')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartFluidRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartFluidRequest copyWith(void Function(ChartFluidRequest) updates) =>
      super.copyWith((message) => updates(message as ChartFluidRequest))
          as ChartFluidRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChartFluidRequest create() => ChartFluidRequest._();
  @$core.override
  ChartFluidRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChartFluidRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChartFluidRequest>(create);
  static ChartFluidRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  FluidDirection get direction => $_getN(1);
  @$pb.TagNumber(2)
  set direction(FluidDirection value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDirection() => $_has(1);
  @$pb.TagNumber(2)
  void clearDirection() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get kind => $_getSZ(2);
  @$pb.TagNumber(3)
  set kind($core.String value) => $_setString(2, value);
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
  $core.double get volumeMl => $_getN(4);
  @$pb.TagNumber(5)
  set volumeMl($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVolumeMl() => $_has(4);
  @$pb.TagNumber(5)
  void clearVolumeMl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get productId => $_getSZ(5);
  @$pb.TagNumber(6)
  set productId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProductId() => $_has(5);
  @$pb.TagNumber(6)
  void clearProductId() => $_clearField(6);

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

class ChartFluidResponse extends $pb.GeneratedMessage {
  factory ChartFluidResponse({
    FluidEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  ChartFluidResponse._();

  factory ChartFluidResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChartFluidResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChartFluidResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<FluidEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: FluidEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartFluidResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartFluidResponse copyWith(void Function(ChartFluidResponse) updates) =>
      super.copyWith((message) => updates(message as ChartFluidResponse))
          as ChartFluidResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChartFluidResponse create() => ChartFluidResponse._();
  @$core.override
  ChartFluidResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChartFluidResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChartFluidResponse>(create);
  static ChartFluidResponse? _defaultInstance;

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

class GetBalanceRequest extends $pb.GeneratedMessage {
  factory GetBalanceRequest({
    $core.String? recordId,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
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
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
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
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);
}

class GetBalanceResponse extends $pb.GeneratedMessage {
  factory GetBalanceResponse({
    FluidBalance? balance,
    $core.Iterable<FluidEntry>? entries,
  }) {
    final result = create();
    if (balance != null) result.balance = balance;
    if (entries != null) result.entries.addAll(entries);
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
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<FluidBalance>(1, _omitFieldNames ? '' : 'balance',
        subBuilder: FluidBalance.create)
    ..pPM<FluidEntry>(2, _omitFieldNames ? '' : 'entries',
        subBuilder: FluidEntry.create)
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
  FluidBalance get balance => $_getN(0);
  @$pb.TagNumber(1)
  set balance(FluidBalance value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBalance() => $_has(0);
  @$pb.TagNumber(1)
  void clearBalance() => $_clearField(1);
  @$pb.TagNumber(1)
  FluidBalance ensureBalance() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<FluidEntry> get entries => $_getList(1);
}

class EndAnaesthesiaRequest extends $pb.GeneratedMessage {
  factory EndAnaesthesiaRequest({
    $core.String? recordId,
    $0.Timestamp? endedAt,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (endedAt != null) result.endedAt = endedAt;
    return result;
  }

  EndAnaesthesiaRequest._();

  factory EndAnaesthesiaRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndAnaesthesiaRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndAnaesthesiaRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndAnaesthesiaRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndAnaesthesiaRequest copyWith(
          void Function(EndAnaesthesiaRequest) updates) =>
      super.copyWith((message) => updates(message as EndAnaesthesiaRequest))
          as EndAnaesthesiaRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndAnaesthesiaRequest create() => EndAnaesthesiaRequest._();
  @$core.override
  EndAnaesthesiaRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndAnaesthesiaRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndAnaesthesiaRequest>(create);
  static EndAnaesthesiaRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

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

class EndAnaesthesiaResponse extends $pb.GeneratedMessage {
  factory EndAnaesthesiaResponse({
    Record? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  EndAnaesthesiaResponse._();

  factory EndAnaesthesiaResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndAnaesthesiaResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndAnaesthesiaResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<Record>(1, _omitFieldNames ? '' : 'record', subBuilder: Record.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndAnaesthesiaResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndAnaesthesiaResponse copyWith(
          void Function(EndAnaesthesiaResponse) updates) =>
      super.copyWith((message) => updates(message as EndAnaesthesiaResponse))
          as EndAnaesthesiaResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndAnaesthesiaResponse create() => EndAnaesthesiaResponse._();
  @$core.override
  EndAnaesthesiaResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndAnaesthesiaResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndAnaesthesiaResponse>(create);
  static EndAnaesthesiaResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Record get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(Record value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  Record ensureRecord() => $_ensure(0);
}

class HandOverRequest extends $pb.GeneratedMessage {
  factory HandOverRequest({
    $core.String? recordId,
    $core.String? toClinician,
    $core.String? summary,
    $core.Iterable<$core.String>? concerns,
    $core.Iterable<$core.String>? instructions,
    $core.Iterable<$core.String>? analgesiaGiven,
    $core.Iterable<$core.String>? antiemeticGiven,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (toClinician != null) result.toClinician = toClinician;
    if (summary != null) result.summary = summary;
    if (concerns != null) result.concerns.addAll(concerns);
    if (instructions != null) result.instructions.addAll(instructions);
    if (analgesiaGiven != null) result.analgesiaGiven.addAll(analgesiaGiven);
    if (antiemeticGiven != null) result.antiemeticGiven.addAll(antiemeticGiven);
    return result;
  }

  HandOverRequest._();

  factory HandOverRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HandOverRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HandOverRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'toClinician')
    ..aOS(3, _omitFieldNames ? '' : 'summary')
    ..pPS(4, _omitFieldNames ? '' : 'concerns')
    ..pPS(5, _omitFieldNames ? '' : 'instructions')
    ..pPS(6, _omitFieldNames ? '' : 'analgesiaGiven')
    ..pPS(7, _omitFieldNames ? '' : 'antiemeticGiven')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HandOverRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HandOverRequest copyWith(void Function(HandOverRequest) updates) =>
      super.copyWith((message) => updates(message as HandOverRequest))
          as HandOverRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HandOverRequest create() => HandOverRequest._();
  @$core.override
  HandOverRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HandOverRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HandOverRequest>(create);
  static HandOverRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toClinician => $_getSZ(1);
  @$pb.TagNumber(2)
  set toClinician($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToClinician() => $_has(1);
  @$pb.TagNumber(2)
  void clearToClinician() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get summary => $_getSZ(2);
  @$pb.TagNumber(3)
  set summary($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSummary() => $_has(2);
  @$pb.TagNumber(3)
  void clearSummary() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get concerns => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get instructions => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get analgesiaGiven => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get antiemeticGiven => $_getList(6);
}

class HandOverResponse extends $pb.GeneratedMessage {
  factory HandOverResponse({
    Handover? handover,
  }) {
    final result = create();
    if (handover != null) result.handover = handover;
    return result;
  }

  HandOverResponse._();

  factory HandOverResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HandOverResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HandOverResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<Handover>(1, _omitFieldNames ? '' : 'handover',
        subBuilder: Handover.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HandOverResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HandOverResponse copyWith(void Function(HandOverResponse) updates) =>
      super.copyWith((message) => updates(message as HandOverResponse))
          as HandOverResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HandOverResponse create() => HandOverResponse._();
  @$core.override
  HandOverResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HandOverResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HandOverResponse>(create);
  static HandOverResponse? _defaultInstance;

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
    $core.String? recordId,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
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
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
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
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);
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
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
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

class GetRecoveryScaleRequest extends $pb.GeneratedMessage {
  factory GetRecoveryScaleRequest() => create();

  GetRecoveryScaleRequest._();

  factory GetRecoveryScaleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRecoveryScaleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRecoveryScaleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecoveryScaleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecoveryScaleRequest copyWith(
          void Function(GetRecoveryScaleRequest) updates) =>
      super.copyWith((message) => updates(message as GetRecoveryScaleRequest))
          as GetRecoveryScaleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRecoveryScaleRequest create() => GetRecoveryScaleRequest._();
  @$core.override
  GetRecoveryScaleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRecoveryScaleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRecoveryScaleRequest>(create);
  static GetRecoveryScaleRequest? _defaultInstance;
}

class GetRecoveryScaleResponse extends $pb.GeneratedMessage {
  factory GetRecoveryScaleResponse({
    RecoveryScale? scale,
  }) {
    final result = create();
    if (scale != null) result.scale = scale;
    return result;
  }

  GetRecoveryScaleResponse._();

  factory GetRecoveryScaleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRecoveryScaleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRecoveryScaleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<RecoveryScale>(1, _omitFieldNames ? '' : 'scale',
        subBuilder: RecoveryScale.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecoveryScaleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecoveryScaleResponse copyWith(
          void Function(GetRecoveryScaleResponse) updates) =>
      super.copyWith((message) => updates(message as GetRecoveryScaleResponse))
          as GetRecoveryScaleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRecoveryScaleResponse create() => GetRecoveryScaleResponse._();
  @$core.override
  GetRecoveryScaleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRecoveryScaleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRecoveryScaleResponse>(create);
  static GetRecoveryScaleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RecoveryScale get scale => $_getN(0);
  @$pb.TagNumber(1)
  set scale(RecoveryScale value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScale() => $_has(0);
  @$pb.TagNumber(1)
  void clearScale() => $_clearField(1);
  @$pb.TagNumber(1)
  RecoveryScale ensureScale() => $_ensure(0);
}

class AssessRecoveryRequest extends $pb.GeneratedMessage {
  factory AssessRecoveryRequest({
    $core.String? recordId,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? scores,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (scores != null) result.scores.addEntries(scores);
    return result;
  }

  AssessRecoveryRequest._();

  factory AssessRecoveryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssessRecoveryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssessRecoveryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..m<$core.String, $core.int>(2, _omitFieldNames ? '' : 'scores',
        entryClassName: 'AssessRecoveryRequest.ScoresEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('healthcare.anaesthesia.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssessRecoveryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssessRecoveryRequest copyWith(
          void Function(AssessRecoveryRequest) updates) =>
      super.copyWith((message) => updates(message as AssessRecoveryRequest))
          as AssessRecoveryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssessRecoveryRequest create() => AssessRecoveryRequest._();
  @$core.override
  AssessRecoveryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssessRecoveryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssessRecoveryRequest>(create);
  static AssessRecoveryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  /// A component left out is recorded as missing rather than as zero.
  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.int> get scores => $_getMap(1);
}

class AssessRecoveryResponse extends $pb.GeneratedMessage {
  factory AssessRecoveryResponse({
    RecoveryAssessment? assessment,
  }) {
    final result = create();
    if (assessment != null) result.assessment = assessment;
    return result;
  }

  AssessRecoveryResponse._();

  factory AssessRecoveryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssessRecoveryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssessRecoveryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<RecoveryAssessment>(1, _omitFieldNames ? '' : 'assessment',
        subBuilder: RecoveryAssessment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssessRecoveryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssessRecoveryResponse copyWith(
          void Function(AssessRecoveryResponse) updates) =>
      super.copyWith((message) => updates(message as AssessRecoveryResponse))
          as AssessRecoveryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssessRecoveryResponse create() => AssessRecoveryResponse._();
  @$core.override
  AssessRecoveryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssessRecoveryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssessRecoveryResponse>(create);
  static AssessRecoveryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RecoveryAssessment get assessment => $_getN(0);
  @$pb.TagNumber(1)
  set assessment(RecoveryAssessment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssessment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssessment() => $_clearField(1);
  @$pb.TagNumber(1)
  RecoveryAssessment ensureAssessment() => $_ensure(0);
}

class ListRecoveryAssessmentsRequest extends $pb.GeneratedMessage {
  factory ListRecoveryAssessmentsRequest({
    $core.String? recordId,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    return result;
  }

  ListRecoveryAssessmentsRequest._();

  factory ListRecoveryAssessmentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRecoveryAssessmentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRecoveryAssessmentsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRecoveryAssessmentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRecoveryAssessmentsRequest copyWith(
          void Function(ListRecoveryAssessmentsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListRecoveryAssessmentsRequest))
          as ListRecoveryAssessmentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRecoveryAssessmentsRequest create() =>
      ListRecoveryAssessmentsRequest._();
  @$core.override
  ListRecoveryAssessmentsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRecoveryAssessmentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRecoveryAssessmentsRequest>(create);
  static ListRecoveryAssessmentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);
}

class ListRecoveryAssessmentsResponse extends $pb.GeneratedMessage {
  factory ListRecoveryAssessmentsResponse({
    $core.Iterable<RecoveryAssessment>? assessments,
  }) {
    final result = create();
    if (assessments != null) result.assessments.addAll(assessments);
    return result;
  }

  ListRecoveryAssessmentsResponse._();

  factory ListRecoveryAssessmentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRecoveryAssessmentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRecoveryAssessmentsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..pPM<RecoveryAssessment>(1, _omitFieldNames ? '' : 'assessments',
        subBuilder: RecoveryAssessment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRecoveryAssessmentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRecoveryAssessmentsResponse copyWith(
          void Function(ListRecoveryAssessmentsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListRecoveryAssessmentsResponse))
          as ListRecoveryAssessmentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRecoveryAssessmentsResponse create() =>
      ListRecoveryAssessmentsResponse._();
  @$core.override
  ListRecoveryAssessmentsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRecoveryAssessmentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRecoveryAssessmentsResponse>(
          create);
  static ListRecoveryAssessmentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RecoveryAssessment> get assessments => $_getList(0);
}

class EvaluateDischargeRequest extends $pb.GeneratedMessage {
  factory EvaluateDischargeRequest({
    $core.String? recordId,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    return result;
  }

  EvaluateDischargeRequest._();

  factory EvaluateDischargeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EvaluateDischargeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvaluateDischargeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateDischargeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateDischargeRequest copyWith(
          void Function(EvaluateDischargeRequest) updates) =>
      super.copyWith((message) => updates(message as EvaluateDischargeRequest))
          as EvaluateDischargeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EvaluateDischargeRequest create() => EvaluateDischargeRequest._();
  @$core.override
  EvaluateDischargeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EvaluateDischargeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvaluateDischargeRequest>(create);
  static EvaluateDischargeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);
}

class EvaluateDischargeResponse extends $pb.GeneratedMessage {
  factory EvaluateDischargeResponse({
    DischargeDecision? decision,
  }) {
    final result = create();
    if (decision != null) result.decision = decision;
    return result;
  }

  EvaluateDischargeResponse._();

  factory EvaluateDischargeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EvaluateDischargeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvaluateDischargeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<DischargeDecision>(1, _omitFieldNames ? '' : 'decision',
        subBuilder: DischargeDecision.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateDischargeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateDischargeResponse copyWith(
          void Function(EvaluateDischargeResponse) updates) =>
      super.copyWith((message) => updates(message as EvaluateDischargeResponse))
          as EvaluateDischargeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EvaluateDischargeResponse create() => EvaluateDischargeResponse._();
  @$core.override
  EvaluateDischargeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EvaluateDischargeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvaluateDischargeResponse>(create);
  static EvaluateDischargeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DischargeDecision get decision => $_getN(0);
  @$pb.TagNumber(1)
  set decision(DischargeDecision value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDecision() => $_has(0);
  @$pb.TagNumber(1)
  void clearDecision() => $_clearField(1);
  @$pb.TagNumber(1)
  DischargeDecision ensureDecision() => $_ensure(0);
}

class DischargeFromRecoveryRequest extends $pb.GeneratedMessage {
  factory DischargeFromRecoveryRequest({
    $core.String? recordId,
    $core.String? destination,
    $core.String? overrideReason,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (destination != null) result.destination = destination;
    if (overrideReason != null) result.overrideReason = overrideReason;
    return result;
  }

  DischargeFromRecoveryRequest._();

  factory DischargeFromRecoveryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DischargeFromRecoveryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DischargeFromRecoveryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'destination')
    ..aOS(3, _omitFieldNames ? '' : 'overrideReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DischargeFromRecoveryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DischargeFromRecoveryRequest copyWith(
          void Function(DischargeFromRecoveryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DischargeFromRecoveryRequest))
          as DischargeFromRecoveryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DischargeFromRecoveryRequest create() =>
      DischargeFromRecoveryRequest._();
  @$core.override
  DischargeFromRecoveryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DischargeFromRecoveryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DischargeFromRecoveryRequest>(create);
  static DischargeFromRecoveryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get destination => $_getSZ(1);
  @$pb.TagNumber(2)
  set destination($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDestination() => $_has(1);
  @$pb.TagNumber(2)
  void clearDestination() => $_clearField(2);

  /// Required to discharge a patient who does not meet the bar, and refused
  /// for one nobody has handed over.
  @$pb.TagNumber(3)
  $core.String get overrideReason => $_getSZ(2);
  @$pb.TagNumber(3)
  set overrideReason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOverrideReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverrideReason() => $_clearField(3);
}

class DischargeFromRecoveryResponse extends $pb.GeneratedMessage {
  factory DischargeFromRecoveryResponse({
    Discharge? discharge,
  }) {
    final result = create();
    if (discharge != null) result.discharge = discharge;
    return result;
  }

  DischargeFromRecoveryResponse._();

  factory DischargeFromRecoveryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DischargeFromRecoveryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DischargeFromRecoveryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<Discharge>(1, _omitFieldNames ? '' : 'discharge',
        subBuilder: Discharge.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DischargeFromRecoveryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DischargeFromRecoveryResponse copyWith(
          void Function(DischargeFromRecoveryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DischargeFromRecoveryResponse))
          as DischargeFromRecoveryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DischargeFromRecoveryResponse create() =>
      DischargeFromRecoveryResponse._();
  @$core.override
  DischargeFromRecoveryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DischargeFromRecoveryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DischargeFromRecoveryResponse>(create);
  static DischargeFromRecoveryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Discharge get discharge => $_getN(0);
  @$pb.TagNumber(1)
  set discharge(Discharge value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDischarge() => $_has(0);
  @$pb.TagNumber(1)
  void clearDischarge() => $_clearField(1);
  @$pb.TagNumber(1)
  Discharge ensureDischarge() => $_ensure(0);
}

class OrderPainRequest extends $pb.GeneratedMessage {
  factory OrderPainRequest({
    $core.String? recordId,
    $core.String? modality,
    $core.Iterable<$core.String>? prescriptionIds,
    $core.String? targetScore,
    $core.Iterable<$core.String>? monitoring,
    $core.String? escalation,
    $0.Timestamp? reviewBy,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (modality != null) result.modality = modality;
    if (prescriptionIds != null) result.prescriptionIds.addAll(prescriptionIds);
    if (targetScore != null) result.targetScore = targetScore;
    if (monitoring != null) result.monitoring.addAll(monitoring);
    if (escalation != null) result.escalation = escalation;
    if (reviewBy != null) result.reviewBy = reviewBy;
    return result;
  }

  OrderPainRequest._();

  factory OrderPainRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OrderPainRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderPainRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'modality')
    ..pPS(3, _omitFieldNames ? '' : 'prescriptionIds')
    ..aOS(4, _omitFieldNames ? '' : 'targetScore')
    ..pPS(5, _omitFieldNames ? '' : 'monitoring')
    ..aOS(6, _omitFieldNames ? '' : 'escalation')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'reviewBy',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderPainRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderPainRequest copyWith(void Function(OrderPainRequest) updates) =>
      super.copyWith((message) => updates(message as OrderPainRequest))
          as OrderPainRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrderPainRequest create() => OrderPainRequest._();
  @$core.override
  OrderPainRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OrderPainRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderPainRequest>(create);
  static OrderPainRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get modality => $_getSZ(1);
  @$pb.TagNumber(2)
  set modality($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModality() => $_has(1);
  @$pb.TagNumber(2)
  void clearModality() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get prescriptionIds => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get targetScore => $_getSZ(3);
  @$pb.TagNumber(4)
  set targetScore($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTargetScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetScore() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get monitoring => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get escalation => $_getSZ(5);
  @$pb.TagNumber(6)
  set escalation($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEscalation() => $_has(5);
  @$pb.TagNumber(6)
  void clearEscalation() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get reviewBy => $_getN(6);
  @$pb.TagNumber(7)
  set reviewBy($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasReviewBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearReviewBy() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureReviewBy() => $_ensure(6);
}

class OrderPainResponse extends $pb.GeneratedMessage {
  factory OrderPainResponse({
    PainOrder? order,
  }) {
    final result = create();
    if (order != null) result.order = order;
    return result;
  }

  OrderPainResponse._();

  factory OrderPainResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OrderPainResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderPainResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<PainOrder>(1, _omitFieldNames ? '' : 'order',
        subBuilder: PainOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderPainResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderPainResponse copyWith(void Function(OrderPainResponse) updates) =>
      super.copyWith((message) => updates(message as OrderPainResponse))
          as OrderPainResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrderPainResponse create() => OrderPainResponse._();
  @$core.override
  OrderPainResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OrderPainResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderPainResponse>(create);
  static OrderPainResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PainOrder get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(PainOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  PainOrder ensureOrder() => $_ensure(0);
}

class ListPainOrdersRequest extends $pb.GeneratedMessage {
  factory ListPainOrdersRequest({
    $core.String? recordId,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    return result;
  }

  ListPainOrdersRequest._();

  factory ListPainOrdersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPainOrdersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPainOrdersRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPainOrdersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPainOrdersRequest copyWith(
          void Function(ListPainOrdersRequest) updates) =>
      super.copyWith((message) => updates(message as ListPainOrdersRequest))
          as ListPainOrdersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPainOrdersRequest create() => ListPainOrdersRequest._();
  @$core.override
  ListPainOrdersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPainOrdersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPainOrdersRequest>(create);
  static ListPainOrdersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);
}

class ListPainOrdersResponse extends $pb.GeneratedMessage {
  factory ListPainOrdersResponse({
    $core.Iterable<PainOrder>? orders,
  }) {
    final result = create();
    if (orders != null) result.orders.addAll(orders);
    return result;
  }

  ListPainOrdersResponse._();

  factory ListPainOrdersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPainOrdersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPainOrdersResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..pPM<PainOrder>(1, _omitFieldNames ? '' : 'orders',
        subBuilder: PainOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPainOrdersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPainOrdersResponse copyWith(
          void Function(ListPainOrdersResponse) updates) =>
      super.copyWith((message) => updates(message as ListPainOrdersResponse))
          as ListPainOrdersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPainOrdersResponse create() => ListPainOrdersResponse._();
  @$core.override
  ListPainOrdersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPainOrdersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPainOrdersResponse>(create);
  static ListPainOrdersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PainOrder> get orders => $_getList(0);
}

class GetPainRoundRequest extends $pb.GeneratedMessage {
  factory GetPainRoundRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetPainRoundRequest._();

  factory GetPainRoundRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPainRoundRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPainRoundRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPainRoundRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPainRoundRequest copyWith(void Function(GetPainRoundRequest) updates) =>
      super.copyWith((message) => updates(message as GetPainRoundRequest))
          as GetPainRoundRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPainRoundRequest create() => GetPainRoundRequest._();
  @$core.override
  GetPainRoundRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPainRoundRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPainRoundRequest>(create);
  static GetPainRoundRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class GetPainRoundResponse extends $pb.GeneratedMessage {
  factory GetPainRoundResponse({
    $core.Iterable<PainOrder>? orders,
  }) {
    final result = create();
    if (orders != null) result.orders.addAll(orders);
    return result;
  }

  GetPainRoundResponse._();

  factory GetPainRoundResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPainRoundResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPainRoundResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..pPM<PainOrder>(1, _omitFieldNames ? '' : 'orders',
        subBuilder: PainOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPainRoundResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPainRoundResponse copyWith(void Function(GetPainRoundResponse) updates) =>
      super.copyWith((message) => updates(message as GetPainRoundResponse))
          as GetPainRoundResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPainRoundResponse create() => GetPainRoundResponse._();
  @$core.override
  GetPainRoundResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPainRoundResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPainRoundResponse>(create);
  static GetPainRoundResponse? _defaultInstance;

  /// Soonest review first. A plan with no review time sorts last rather than
  /// being hidden: an unreviewed plan is the one the round exists to find.
  @$pb.TagNumber(1)
  $pb.PbList<PainOrder> get orders => $_getList(0);
}

class StopPainRequest extends $pb.GeneratedMessage {
  factory StopPainRequest({
    $core.String? orderId,
    $0.Timestamp? stoppedAt,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (stoppedAt != null) result.stoppedAt = stoppedAt;
    return result;
  }

  StopPainRequest._();

  factory StopPainRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopPainRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopPainRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'stoppedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopPainRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopPainRequest copyWith(void Function(StopPainRequest) updates) =>
      super.copyWith((message) => updates(message as StopPainRequest))
          as StopPainRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopPainRequest create() => StopPainRequest._();
  @$core.override
  StopPainRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StopPainRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopPainRequest>(create);
  static StopPainRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get stoppedAt => $_getN(1);
  @$pb.TagNumber(2)
  set stoppedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStoppedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearStoppedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureStoppedAt() => $_ensure(1);
}

class StopPainResponse extends $pb.GeneratedMessage {
  factory StopPainResponse() => create();

  StopPainResponse._();

  factory StopPainResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopPainResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopPainResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopPainResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopPainResponse copyWith(void Function(StopPainResponse) updates) =>
      super.copyWith((message) => updates(message as StopPainResponse))
          as StopPainResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopPainResponse create() => StopPainResponse._();
  @$core.override
  StopPainResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StopPainResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopPainResponse>(create);
  static StopPainResponse? _defaultInstance;
}

class GetSummaryRequest extends $pb.GeneratedMessage {
  factory GetSummaryRequest({
    $core.String? recordId,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    return result;
  }

  GetSummaryRequest._();

  factory GetSummaryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSummaryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSummaryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSummaryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSummaryRequest copyWith(void Function(GetSummaryRequest) updates) =>
      super.copyWith((message) => updates(message as GetSummaryRequest))
          as GetSummaryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSummaryRequest create() => GetSummaryRequest._();
  @$core.override
  GetSummaryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSummaryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSummaryRequest>(create);
  static GetSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);
}

class GetSummaryResponse extends $pb.GeneratedMessage {
  factory GetSummaryResponse({
    Summary? summary,
  }) {
    final result = create();
    if (summary != null) result.summary = summary;
    return result;
  }

  GetSummaryResponse._();

  factory GetSummaryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSummaryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSummaryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.anaesthesia.v1'),
      createEmptyInstance: create)
    ..aOM<Summary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: Summary.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSummaryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSummaryResponse copyWith(void Function(GetSummaryResponse) updates) =>
      super.copyWith((message) => updates(message as GetSummaryResponse))
          as GetSummaryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSummaryResponse create() => GetSummaryResponse._();
  @$core.override
  GetSummaryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSummaryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSummaryResponse>(create);
  static GetSummaryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Summary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(Summary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  Summary ensureSummary() => $_ensure(0);
}

/// Anaesthesia and recovery (SRS-ANE-001 … 011).
class AnaesthesiaServiceApi {
  final $pb.RpcClient _client;

  AnaesthesiaServiceApi(this._client);

  /// SRS-ANE-001. A second assessment for a case supersedes the first rather
  /// than replacing it.
  $async.Future<RecordAssessmentResponse> recordAssessment(
          $pb.ClientContext? ctx, RecordAssessmentRequest request) =>
      _client.invoke<RecordAssessmentResponse>(ctx, 'AnaesthesiaService',
          'RecordAssessment', request, RecordAssessmentResponse());
  $async.Future<ListAssessmentsResponse> listAssessments(
          $pb.ClientContext? ctx, ListAssessmentsRequest request) =>
      _client.invoke<ListAssessmentsResponse>(ctx, 'AnaesthesiaService',
          'ListAssessments', request, ListAssessmentsResponse());

  /// Across admissions, which is a different kind of access from reading the
  /// case in front of you.
  $async.Future<ListPatientAssessmentsResponse> listPatientAssessments(
          $pb.ClientContext? ctx, ListPatientAssessmentsRequest request) =>
      _client.invoke<ListPatientAssessmentsResponse>(ctx, 'AnaesthesiaService',
          'ListPatientAssessments', request, ListPatientAssessmentsResponse());

  /// SRS-ANE-002.
  $async.Future<RecordPlanResponse> recordPlan(
          $pb.ClientContext? ctx, RecordPlanRequest request) =>
      _client.invoke<RecordPlanResponse>(ctx, 'AnaesthesiaService',
          'RecordPlan', request, RecordPlanResponse());
  $async.Future<GetPlanResponse> getPlan(
          $pb.ClientContext? ctx, GetPlanRequest request) =>
      _client.invoke<GetPlanResponse>(
          ctx, 'AnaesthesiaService', 'GetPlan', request, GetPlanResponse());
  $async.Future<GetReadinessResponse> getReadiness(
          $pb.ClientContext? ctx, GetReadinessRequest request) =>
      _client.invoke<GetReadinessResponse>(ctx, 'AnaesthesiaService',
          'GetReadiness', request, GetReadinessResponse());

  /// SRS-ANE-003, SRS-ANE-011.
  $async.Future<OpenRecordResponse> openRecord(
          $pb.ClientContext? ctx, OpenRecordRequest request) =>
      _client.invoke<OpenRecordResponse>(ctx, 'AnaesthesiaService',
          'OpenRecord', request, OpenRecordResponse());
  $async.Future<GetRecordResponse> getRecord(
          $pb.ClientContext? ctx, GetRecordRequest request) =>
      _client.invoke<GetRecordResponse>(
          ctx, 'AnaesthesiaService', 'GetRecord', request, GetRecordResponse());
  $async.Future<GetRecordForCaseResponse> getRecordForCase(
          $pb.ClientContext? ctx, GetRecordForCaseRequest request) =>
      _client.invoke<GetRecordForCaseResponse>(ctx, 'AnaesthesiaService',
          'GetRecordForCase', request, GetRecordForCaseResponse());
  $async.Future<EndAnaesthesiaResponse> endAnaesthesia(
          $pb.ClientContext? ctx, EndAnaesthesiaRequest request) =>
      _client.invoke<EndAnaesthesiaResponse>(ctx, 'AnaesthesiaService',
          'EndAnaesthesia', request, EndAnaesthesiaResponse());

  /// SRS-ANE-003, SRS-ANE-005.
  $async.Future<ChartVitalResponse> chartVital(
          $pb.ClientContext? ctx, ChartVitalRequest request) =>
      _client.invoke<ChartVitalResponse>(ctx, 'AnaesthesiaService',
          'ChartVital', request, ChartVitalResponse());
  $async.Future<ListVitalsResponse> listVitals(
          $pb.ClientContext? ctx, ListVitalsRequest request) =>
      _client.invoke<ListVitalsResponse>(ctx, 'AnaesthesiaService',
          'ListVitals', request, ListVitalsResponse());

  /// SRS-ANE-004.
  $async.Future<ChartDrugResponse> chartDrug(
          $pb.ClientContext? ctx, ChartDrugRequest request) =>
      _client.invoke<ChartDrugResponse>(
          ctx, 'AnaesthesiaService', 'ChartDrug', request, ChartDrugResponse());
  $async.Future<ListDrugsResponse> listDrugs(
          $pb.ClientContext? ctx, ListDrugsRequest request) =>
      _client.invoke<ListDrugsResponse>(
          ctx, 'AnaesthesiaService', 'ListDrugs', request, ListDrugsResponse());
  $async.Future<StopInfusionResponse> stopInfusion(
          $pb.ClientContext? ctx, StopInfusionRequest request) =>
      _client.invoke<StopInfusionResponse>(ctx, 'AnaesthesiaService',
          'StopInfusion', request, StopInfusionResponse());

  /// SRS-ANE-006.
  $async.Future<RecordAirwayResponse> recordAirway(
          $pb.ClientContext? ctx, RecordAirwayRequest request) =>
      _client.invoke<RecordAirwayResponse>(ctx, 'AnaesthesiaService',
          'RecordAirway', request, RecordAirwayResponse());
  $async.Future<GetAirwayResponse> getAirway(
          $pb.ClientContext? ctx, GetAirwayRequest request) =>
      _client.invoke<GetAirwayResponse>(
          ctx, 'AnaesthesiaService', 'GetAirway', request, GetAirwayResponse());
  $async.Future<GetPatientAirwayResponse> getPatientAirway(
          $pb.ClientContext? ctx, GetPatientAirwayRequest request) =>
      _client.invoke<GetPatientAirwayResponse>(ctx, 'AnaesthesiaService',
          'GetPatientAirway', request, GetPatientAirwayResponse());

  /// SRS-ANE-007.
  $async.Future<ChartFluidResponse> chartFluid(
          $pb.ClientContext? ctx, ChartFluidRequest request) =>
      _client.invoke<ChartFluidResponse>(ctx, 'AnaesthesiaService',
          'ChartFluid', request, ChartFluidResponse());
  $async.Future<GetBalanceResponse> getBalance(
          $pb.ClientContext? ctx, GetBalanceRequest request) =>
      _client.invoke<GetBalanceResponse>(ctx, 'AnaesthesiaService',
          'GetBalance', request, GetBalanceResponse());

  /// SRS-ANE-008.
  $async.Future<HandOverResponse> handOver(
          $pb.ClientContext? ctx, HandOverRequest request) =>
      _client.invoke<HandOverResponse>(
          ctx, 'AnaesthesiaService', 'HandOver', request, HandOverResponse());
  $async.Future<ListHandoversResponse> listHandovers(
          $pb.ClientContext? ctx, ListHandoversRequest request) =>
      _client.invoke<ListHandoversResponse>(ctx, 'AnaesthesiaService',
          'ListHandovers', request, ListHandoversResponse());
  $async.Future<GetRecoveryScaleResponse> getRecoveryScale(
          $pb.ClientContext? ctx, GetRecoveryScaleRequest request) =>
      _client.invoke<GetRecoveryScaleResponse>(ctx, 'AnaesthesiaService',
          'GetRecoveryScale', request, GetRecoveryScaleResponse());
  $async.Future<AssessRecoveryResponse> assessRecovery(
          $pb.ClientContext? ctx, AssessRecoveryRequest request) =>
      _client.invoke<AssessRecoveryResponse>(ctx, 'AnaesthesiaService',
          'AssessRecovery', request, AssessRecoveryResponse());
  $async.Future<ListRecoveryAssessmentsResponse> listRecoveryAssessments(
          $pb.ClientContext? ctx, ListRecoveryAssessmentsRequest request) =>
      _client.invoke<ListRecoveryAssessmentsResponse>(
          ctx,
          'AnaesthesiaService',
          'ListRecoveryAssessments',
          request,
          ListRecoveryAssessmentsResponse());
  $async.Future<EvaluateDischargeResponse> evaluateDischarge(
          $pb.ClientContext? ctx, EvaluateDischargeRequest request) =>
      _client.invoke<EvaluateDischargeResponse>(ctx, 'AnaesthesiaService',
          'EvaluateDischarge', request, EvaluateDischargeResponse());
  $async.Future<DischargeFromRecoveryResponse> dischargeFromRecovery(
          $pb.ClientContext? ctx, DischargeFromRecoveryRequest request) =>
      _client.invoke<DischargeFromRecoveryResponse>(ctx, 'AnaesthesiaService',
          'DischargeFromRecovery', request, DischargeFromRecoveryResponse());

  /// SRS-ANE-009.
  $async.Future<OrderPainResponse> orderPain(
          $pb.ClientContext? ctx, OrderPainRequest request) =>
      _client.invoke<OrderPainResponse>(
          ctx, 'AnaesthesiaService', 'OrderPain', request, OrderPainResponse());
  $async.Future<ListPainOrdersResponse> listPainOrders(
          $pb.ClientContext? ctx, ListPainOrdersRequest request) =>
      _client.invoke<ListPainOrdersResponse>(ctx, 'AnaesthesiaService',
          'ListPainOrders', request, ListPainOrdersResponse());
  $async.Future<GetPainRoundResponse> getPainRound(
          $pb.ClientContext? ctx, GetPainRoundRequest request) =>
      _client.invoke<GetPainRoundResponse>(ctx, 'AnaesthesiaService',
          'GetPainRound', request, GetPainRoundResponse());
  $async.Future<StopPainResponse> stopPain(
          $pb.ClientContext? ctx, StopPainRequest request) =>
      _client.invoke<StopPainResponse>(
          ctx, 'AnaesthesiaService', 'StopPain', request, StopPainResponse());

  /// SRS-ANE-010. Derived from the record, never submitted.
  $async.Future<GetSummaryResponse> getSummary(
          $pb.ClientContext? ctx, GetSummaryRequest request) =>
      _client.invoke<GetSummaryResponse>(ctx, 'AnaesthesiaService',
          'GetSummary', request, GetSummaryResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
