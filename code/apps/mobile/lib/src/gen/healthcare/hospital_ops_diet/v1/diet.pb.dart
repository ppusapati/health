// This is a generated file - do not edit.
//
// Generated from healthcare/hospital_ops_diet/v1/diet.proto.

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

import 'diet.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'diet.pbenum.dart';

/// What was measured (SRS-DIET-001).
class Anthropometry extends $pb.GeneratedMessage {
  factory Anthropometry({
    $core.int? heightMm,
    $core.int? weightG,
    $core.int? midUpperArmMm,
    $core.bool? estimated,
    $0.Timestamp? measuredAt,
  }) {
    final result = create();
    if (heightMm != null) result.heightMm = heightMm;
    if (weightG != null) result.weightG = weightG;
    if (midUpperArmMm != null) result.midUpperArmMm = midUpperArmMm;
    if (estimated != null) result.estimated = estimated;
    if (measuredAt != null) result.measuredAt = measuredAt;
    return result;
  }

  Anthropometry._();

  factory Anthropometry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Anthropometry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Anthropometry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'heightMm')
    ..aI(2, _omitFieldNames ? '' : 'weightG')
    ..aI(3, _omitFieldNames ? '' : 'midUpperArmMm')
    ..aOB(4, _omitFieldNames ? '' : 'estimated')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'measuredAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Anthropometry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Anthropometry copyWith(void Function(Anthropometry) updates) =>
      super.copyWith((message) => updates(message as Anthropometry))
          as Anthropometry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Anthropometry create() => Anthropometry._();
  @$core.override
  Anthropometry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Anthropometry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Anthropometry>(create);
  static Anthropometry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get heightMm => $_getIZ(0);
  @$pb.TagNumber(1)
  set heightMm($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHeightMm() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeightMm() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get weightG => $_getIZ(1);
  @$pb.TagNumber(2)
  set weightG($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWeightG() => $_has(1);
  @$pb.TagNumber(2)
  void clearWeightG() => $_clearField(2);

  /// What is measurable when a patient cannot be weighed, which in critical
  /// care is most of them.
  @$pb.TagNumber(3)
  $core.int get midUpperArmMm => $_getIZ(2);
  @$pb.TagNumber(3)
  set midUpperArmMm($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMidUpperArmMm() => $_has(2);
  @$pb.TagNumber(3)
  void clearMidUpperArmMm() => $_clearField(3);

  /// A measurement somebody judged rather than took. A requirement computed
  /// from an estimate is an estimate.
  @$pb.TagNumber(4)
  $core.bool get estimated => $_getBF(3);
  @$pb.TagNumber(4)
  set estimated($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEstimated() => $_has(3);
  @$pb.TagNumber(4)
  void clearEstimated() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get measuredAt => $_getN(4);
  @$pb.TagNumber(5)
  set measuredAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMeasuredAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearMeasuredAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureMeasuredAt() => $_ensure(4);
}

/// What the patient needs in a day (SRS-DIET-001).
class Requirement extends $pb.GeneratedMessage {
  factory Requirement({
    $core.int? energyKcal,
    $core.int? proteinG,
    $core.int? fluidMl,
    $core.String? basis,
  }) {
    final result = create();
    if (energyKcal != null) result.energyKcal = energyKcal;
    if (proteinG != null) result.proteinG = proteinG;
    if (fluidMl != null) result.fluidMl = fluidMl;
    if (basis != null) result.basis = basis;
    return result;
  }

  Requirement._();

  factory Requirement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Requirement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Requirement',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'energyKcal')
    ..aI(2, _omitFieldNames ? '' : 'proteinG')
    ..aI(3, _omitFieldNames ? '' : 'fluidMl')
    ..aOS(4, _omitFieldNames ? '' : 'basis')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Requirement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Requirement copyWith(void Function(Requirement) updates) =>
      super.copyWith((message) => updates(message as Requirement))
          as Requirement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Requirement create() => Requirement._();
  @$core.override
  Requirement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Requirement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Requirement>(create);
  static Requirement? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get energyKcal => $_getIZ(0);
  @$pb.TagNumber(1)
  set energyKcal($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnergyKcal() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnergyKcal() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get proteinG => $_getIZ(1);
  @$pb.TagNumber(2)
  set proteinG($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProteinG() => $_has(1);
  @$pb.TagNumber(2)
  void clearProteinG() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get fluidMl => $_getIZ(2);
  @$pb.TagNumber(3)
  set fluidMl($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFluidMl() => $_has(2);
  @$pb.TagNumber(3)
  void clearFluidMl() => $_clearField(3);

  /// How the numbers were arrived at. A requirement nobody can reproduce is a
  /// number, and the next dietitian has to decide whether to believe it.
  @$pb.TagNumber(4)
  $core.String get basis => $_getSZ(3);
  @$pb.TagNumber(4)
  set basis($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBasis() => $_has(3);
  @$pb.TagNumber(4)
  void clearBasis() => $_clearField(4);
}

/// One dietitian's assessment of a patient (SRS-DIET-001).
class NutritionAssessment extends $pb.GeneratedMessage {
  factory NutritionAssessment({
    $core.String? assessmentId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    Anthropometry? anthropometry,
    $core.int? bodyMassIndexTenths,
    $core.String? intakeSummary,
    $core.String? diagnosisCode,
    $core.String? diagnosis,
    $core.Iterable<$core.String>? allergyRefs,
    Requirement? requirement,
    $core.String? riskTool,
    $core.int? riskScore,
    AssessmentState? state,
    $core.String? signedBy,
    $0.Timestamp? signedAt,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (assessmentId != null) result.assessmentId = assessmentId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (anthropometry != null) result.anthropometry = anthropometry;
    if (bodyMassIndexTenths != null)
      result.bodyMassIndexTenths = bodyMassIndexTenths;
    if (intakeSummary != null) result.intakeSummary = intakeSummary;
    if (diagnosisCode != null) result.diagnosisCode = diagnosisCode;
    if (diagnosis != null) result.diagnosis = diagnosis;
    if (allergyRefs != null) result.allergyRefs.addAll(allergyRefs);
    if (requirement != null) result.requirement = requirement;
    if (riskTool != null) result.riskTool = riskTool;
    if (riskScore != null) result.riskScore = riskScore;
    if (state != null) result.state = state;
    if (signedBy != null) result.signedBy = signedBy;
    if (signedAt != null) result.signedAt = signedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  NutritionAssessment._();

  factory NutritionAssessment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NutritionAssessment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NutritionAssessment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assessmentId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOM<Anthropometry>(5, _omitFieldNames ? '' : 'anthropometry',
        subBuilder: Anthropometry.create)
    ..aI(6, _omitFieldNames ? '' : 'bodyMassIndexTenths')
    ..aOS(7, _omitFieldNames ? '' : 'intakeSummary')
    ..aOS(8, _omitFieldNames ? '' : 'diagnosisCode')
    ..aOS(9, _omitFieldNames ? '' : 'diagnosis')
    ..pPS(10, _omitFieldNames ? '' : 'allergyRefs')
    ..aOM<Requirement>(11, _omitFieldNames ? '' : 'requirement',
        subBuilder: Requirement.create)
    ..aOS(12, _omitFieldNames ? '' : 'riskTool')
    ..aI(13, _omitFieldNames ? '' : 'riskScore')
    ..aE<AssessmentState>(14, _omitFieldNames ? '' : 'state',
        enumValues: AssessmentState.values)
    ..aOS(15, _omitFieldNames ? '' : 'signedBy')
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'signedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(18, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(19, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NutritionAssessment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NutritionAssessment copyWith(void Function(NutritionAssessment) updates) =>
      super.copyWith((message) => updates(message as NutritionAssessment))
          as NutritionAssessment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NutritionAssessment create() => NutritionAssessment._();
  @$core.override
  NutritionAssessment createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NutritionAssessment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NutritionAssessment>(create);
  static NutritionAssessment? _defaultInstance;

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
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  Anthropometry get anthropometry => $_getN(4);
  @$pb.TagNumber(5)
  set anthropometry(Anthropometry value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAnthropometry() => $_has(4);
  @$pb.TagNumber(5)
  void clearAnthropometry() => $_clearField(5);
  @$pb.TagNumber(5)
  Anthropometry ensureAnthropometry() => $_ensure(4);

  /// Derived from the height and weight above, never stored.
  @$pb.TagNumber(6)
  $core.int get bodyMassIndexTenths => $_getIZ(5);
  @$pb.TagNumber(6)
  set bodyMassIndexTenths($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBodyMassIndexTenths() => $_has(5);
  @$pb.TagNumber(6)
  void clearBodyMassIndexTenths() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get intakeSummary => $_getSZ(6);
  @$pb.TagNumber(7)
  set intakeSummary($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIntakeSummary() => $_has(6);
  @$pb.TagNumber(7)
  void clearIntakeSummary() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get diagnosisCode => $_getSZ(7);
  @$pb.TagNumber(8)
  set diagnosisCode($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDiagnosisCode() => $_has(7);
  @$pb.TagNumber(8)
  void clearDiagnosisCode() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get diagnosis => $_getSZ(8);
  @$pb.TagNumber(9)
  set diagnosis($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDiagnosis() => $_has(8);
  @$pb.TagNumber(9)
  void clearDiagnosis() => $_clearField(9);

  /// Which entries of the clinical allergy list the dietitian saw. References
  /// into the clinical record, never a copy of what the patient reacts to.
  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get allergyRefs => $_getList(9);

  @$pb.TagNumber(11)
  Requirement get requirement => $_getN(10);
  @$pb.TagNumber(11)
  set requirement(Requirement value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasRequirement() => $_has(10);
  @$pb.TagNumber(11)
  void clearRequirement() => $_clearField(11);
  @$pb.TagNumber(11)
  Requirement ensureRequirement() => $_ensure(10);

  /// A score of 3 means malnourished in one tool and at risk in another, so
  /// the tool is always named.
  @$pb.TagNumber(12)
  $core.String get riskTool => $_getSZ(11);
  @$pb.TagNumber(12)
  set riskTool($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRiskTool() => $_has(11);
  @$pb.TagNumber(12)
  void clearRiskTool() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get riskScore => $_getIZ(12);
  @$pb.TagNumber(13)
  set riskScore($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRiskScore() => $_has(12);
  @$pb.TagNumber(13)
  void clearRiskScore() => $_clearField(13);

  @$pb.TagNumber(14)
  AssessmentState get state => $_getN(13);
  @$pb.TagNumber(14)
  set state(AssessmentState value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasState() => $_has(13);
  @$pb.TagNumber(14)
  void clearState() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get signedBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set signedBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasSignedBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearSignedBy() => $_clearField(15);

  @$pb.TagNumber(16)
  $0.Timestamp get signedAt => $_getN(15);
  @$pb.TagNumber(16)
  set signedAt($0.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasSignedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearSignedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureSignedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $0.Timestamp get createdAt => $_getN(16);
  @$pb.TagNumber(17)
  set createdAt($0.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasCreatedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearCreatedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Timestamp ensureCreatedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.String get createdBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set createdBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasCreatedBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearCreatedBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $fixnum.Int64 get version => $_getI64(18);
  @$pb.TagNumber(19)
  set version($fixnum.Int64 value) => $_setInt64(18, value);
  @$pb.TagNumber(19)
  $core.bool hasVersion() => $_has(18);
  @$pb.TagNumber(19)
  void clearVersion() => $_clearField(19);
}

/// What the patient can physically manage (SRS-DIET-002).
class Texture extends $pb.GeneratedMessage {
  factory Texture({
    $core.String? code,
    $core.String? label,
    $core.String? fluidCode,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (label != null) result.label = label;
    if (fluidCode != null) result.fluidCode = fluidCode;
    return result;
  }

  Texture._();

  factory Texture.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Texture.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Texture',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOS(3, _omitFieldNames ? '' : 'fluidCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Texture clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Texture copyWith(void Function(Texture) updates) =>
      super.copyWith((message) => updates(message as Texture)) as Texture;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Texture create() => Texture._();
  @$core.override
  Texture createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Texture getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Texture>(create);
  static Texture? _defaultInstance;

  /// Configured codes rather than an enum: the national descriptor
  /// frameworks differ and a hospital using one should not be forced through
  /// another's vocabulary.
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
  $core.String get fluidCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set fluidCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFluidCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearFluidCode() => $_clearField(3);
}

/// A diet item against a documented allergy (SRS-DIET-003).
class Conflict extends $pb.GeneratedMessage {
  factory Conflict({
    $core.String? allergyRef,
    $core.String? substance,
    $core.String? item,
    $core.String? severity,
    $core.String? resolvedBy,
    $0.Timestamp? resolvedAt,
    $core.String? resolutionNote,
  }) {
    final result = create();
    if (allergyRef != null) result.allergyRef = allergyRef;
    if (substance != null) result.substance = substance;
    if (item != null) result.item = item;
    if (severity != null) result.severity = severity;
    if (resolvedBy != null) result.resolvedBy = resolvedBy;
    if (resolvedAt != null) result.resolvedAt = resolvedAt;
    if (resolutionNote != null) result.resolutionNote = resolutionNote;
    return result;
  }

  Conflict._();

  factory Conflict.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Conflict.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Conflict',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'allergyRef')
    ..aOS(2, _omitFieldNames ? '' : 'substance')
    ..aOS(3, _omitFieldNames ? '' : 'item')
    ..aOS(4, _omitFieldNames ? '' : 'severity')
    ..aOS(5, _omitFieldNames ? '' : 'resolvedBy')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'resolvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'resolutionNote')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Conflict clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Conflict copyWith(void Function(Conflict) updates) =>
      super.copyWith((message) => updates(message as Conflict)) as Conflict;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Conflict create() => Conflict._();
  @$core.override
  Conflict createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Conflict getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Conflict>(create);
  static Conflict? _defaultInstance;

  /// The clinical record's own reference, which is what a later question is
  /// answered against.
  @$pb.TagNumber(1)
  $core.String get allergyRef => $_getSZ(0);
  @$pb.TagNumber(1)
  set allergyRef($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAllergyRef() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllergyRef() => $_clearField(1);

  /// For the person reading the screen, never for answering that question.
  @$pb.TagNumber(2)
  $core.String get substance => $_getSZ(1);
  @$pb.TagNumber(2)
  set substance($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubstance() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubstance() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get item => $_getSZ(2);
  @$pb.TagNumber(3)
  set item($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasItem() => $_has(2);
  @$pb.TagNumber(3)
  void clearItem() => $_clearField(3);

  /// A conflict against an anaphylaxis is not the same decision as one
  /// against an intolerance.
  @$pb.TagNumber(4)
  $core.String get severity => $_getSZ(3);
  @$pb.TagNumber(4)
  set severity($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSeverity() => $_has(3);
  @$pb.TagNumber(4)
  void clearSeverity() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get resolvedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set resolvedBy($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasResolvedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearResolvedBy() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get resolvedAt => $_getN(5);
  @$pb.TagNumber(6)
  set resolvedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasResolvedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearResolvedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureResolvedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get resolutionNote => $_getSZ(6);
  @$pb.TagNumber(7)
  set resolutionNote($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasResolutionNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearResolutionNote() => $_clearField(7);
}

/// What the patient is to be given (SRS-DIET-002).
class DietOrder extends $pb.GeneratedMessage {
  factory DietOrder({
    $core.String? orderId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    $core.String? wardId,
    $core.String? bedId,
    Route? route,
    Texture? texture,
    $core.Iterable<$core.String>? restrictions,
    $core.Iterable<$core.String>? supplements,
    $core.String? instruction,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? effectiveTo,
    OrderState? state,
    $core.Iterable<Conflict>? conflicts,
    $core.String? cancelledReason,
    $core.String? cancelledBy,
    $0.Timestamp? cancelledAt,
    $0.Timestamp? placedAt,
    $core.String? placedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (wardId != null) result.wardId = wardId;
    if (bedId != null) result.bedId = bedId;
    if (route != null) result.route = route;
    if (texture != null) result.texture = texture;
    if (restrictions != null) result.restrictions.addAll(restrictions);
    if (supplements != null) result.supplements.addAll(supplements);
    if (instruction != null) result.instruction = instruction;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (effectiveTo != null) result.effectiveTo = effectiveTo;
    if (state != null) result.state = state;
    if (conflicts != null) result.conflicts.addAll(conflicts);
    if (cancelledReason != null) result.cancelledReason = cancelledReason;
    if (cancelledBy != null) result.cancelledBy = cancelledBy;
    if (cancelledAt != null) result.cancelledAt = cancelledAt;
    if (placedAt != null) result.placedAt = placedAt;
    if (placedBy != null) result.placedBy = placedBy;
    if (version != null) result.version = version;
    return result;
  }

  DietOrder._();

  factory DietOrder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DietOrder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DietOrder',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'wardId')
    ..aOS(6, _omitFieldNames ? '' : 'bedId')
    ..aE<Route>(7, _omitFieldNames ? '' : 'route', enumValues: Route.values)
    ..aOM<Texture>(8, _omitFieldNames ? '' : 'texture',
        subBuilder: Texture.create)
    ..pPS(9, _omitFieldNames ? '' : 'restrictions')
    ..pPS(10, _omitFieldNames ? '' : 'supplements')
    ..aOS(11, _omitFieldNames ? '' : 'instruction')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'effectiveTo',
        subBuilder: $0.Timestamp.create)
    ..aE<OrderState>(14, _omitFieldNames ? '' : 'state',
        enumValues: OrderState.values)
    ..pPM<Conflict>(15, _omitFieldNames ? '' : 'conflicts',
        subBuilder: Conflict.create)
    ..aOS(16, _omitFieldNames ? '' : 'cancelledReason')
    ..aOS(17, _omitFieldNames ? '' : 'cancelledBy')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'cancelledAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(19, _omitFieldNames ? '' : 'placedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(20, _omitFieldNames ? '' : 'placedBy')
    ..aInt64(21, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DietOrder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DietOrder copyWith(void Function(DietOrder) updates) =>
      super.copyWith((message) => updates(message as DietOrder)) as DietOrder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DietOrder create() => DietOrder._();
  @$core.override
  DietOrder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DietOrder getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DietOrder>(create);
  static DietOrder? _defaultInstance;

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
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get wardId => $_getSZ(4);
  @$pb.TagNumber(5)
  set wardId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWardId() => $_has(4);
  @$pb.TagNumber(5)
  void clearWardId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get bedId => $_getSZ(5);
  @$pb.TagNumber(6)
  set bedId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBedId() => $_has(5);
  @$pb.TagNumber(6)
  void clearBedId() => $_clearField(6);

  @$pb.TagNumber(7)
  Route get route => $_getN(6);
  @$pb.TagNumber(7)
  set route(Route value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasRoute() => $_has(6);
  @$pb.TagNumber(7)
  void clearRoute() => $_clearField(7);

  @$pb.TagNumber(8)
  Texture get texture => $_getN(7);
  @$pb.TagNumber(8)
  set texture(Texture value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasTexture() => $_has(7);
  @$pb.TagNumber(8)
  void clearTexture() => $_clearField(8);
  @$pb.TagNumber(8)
  Texture ensureTexture() => $_ensure(7);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get restrictions => $_getList(8);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get supplements => $_getList(9);

  @$pb.TagNumber(11)
  $core.String get instruction => $_getSZ(10);
  @$pb.TagNumber(11)
  set instruction($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasInstruction() => $_has(10);
  @$pb.TagNumber(11)
  void clearInstruction() => $_clearField(11);

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

  /// Unset runs until something supersedes it, which is the ordinary case for
  /// a diet.
  @$pb.TagNumber(13)
  $0.Timestamp get effectiveTo => $_getN(12);
  @$pb.TagNumber(13)
  set effectiveTo($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasEffectiveTo() => $_has(12);
  @$pb.TagNumber(13)
  void clearEffectiveTo() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureEffectiveTo() => $_ensure(12);

  @$pb.TagNumber(14)
  OrderState get state => $_getN(13);
  @$pb.TagNumber(14)
  set state(OrderState value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasState() => $_has(13);
  @$pb.TagNumber(14)
  void clearState() => $_clearField(14);

  /// An order with any unresolved conflict is pending and the kitchen never
  /// sees it.
  @$pb.TagNumber(15)
  $pb.PbList<Conflict> get conflicts => $_getList(14);

  @$pb.TagNumber(16)
  $core.String get cancelledReason => $_getSZ(15);
  @$pb.TagNumber(16)
  set cancelledReason($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCancelledReason() => $_has(15);
  @$pb.TagNumber(16)
  void clearCancelledReason() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get cancelledBy => $_getSZ(16);
  @$pb.TagNumber(17)
  set cancelledBy($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasCancelledBy() => $_has(16);
  @$pb.TagNumber(17)
  void clearCancelledBy() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get cancelledAt => $_getN(17);
  @$pb.TagNumber(18)
  set cancelledAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasCancelledAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearCancelledAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureCancelledAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $0.Timestamp get placedAt => $_getN(18);
  @$pb.TagNumber(19)
  set placedAt($0.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasPlacedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearPlacedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Timestamp ensurePlacedAt() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.String get placedBy => $_getSZ(19);
  @$pb.TagNumber(20)
  set placedBy($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasPlacedBy() => $_has(19);
  @$pb.TagNumber(20)
  void clearPlacedBy() => $_clearField(20);

  @$pb.TagNumber(21)
  $fixnum.Int64 get version => $_getI64(20);
  @$pb.TagNumber(21)
  set version($fixnum.Int64 value) => $_setInt64(20, value);
  @$pb.TagNumber(21)
  $core.bool hasVersion() => $_has(20);
  @$pb.TagNumber(21)
  void clearVersion() => $_clearField(21);
}

/// One thing a care plan is trying to achieve (SRS-DIET-004).
class NutritionGoal extends $pb.GeneratedMessage {
  factory NutritionGoal({
    $core.String? code,
    $core.String? label,
    $core.int? target,
    $core.String? unit,
    Direction? direction,
    $core.int? tolerance,
    $0.Timestamp? targetBy,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (label != null) result.label = label;
    if (target != null) result.target = target;
    if (unit != null) result.unit = unit;
    if (direction != null) result.direction = direction;
    if (tolerance != null) result.tolerance = tolerance;
    if (targetBy != null) result.targetBy = targetBy;
    return result;
  }

  NutritionGoal._();

  factory NutritionGoal.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NutritionGoal.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NutritionGoal',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aI(3, _omitFieldNames ? '' : 'target')
    ..aOS(4, _omitFieldNames ? '' : 'unit')
    ..aE<Direction>(5, _omitFieldNames ? '' : 'direction',
        enumValues: Direction.values)
    ..aI(6, _omitFieldNames ? '' : 'tolerance')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'targetBy',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NutritionGoal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NutritionGoal copyWith(void Function(NutritionGoal) updates) =>
      super.copyWith((message) => updates(message as NutritionGoal))
          as NutritionGoal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NutritionGoal create() => NutritionGoal._();
  @$core.override
  NutritionGoal createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NutritionGoal getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NutritionGoal>(create);
  static NutritionGoal? _defaultInstance;

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
  $core.int get target => $_getIZ(2);
  @$pb.TagNumber(3)
  set target($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTarget() => $_has(2);
  @$pb.TagNumber(3)
  void clearTarget() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get unit => $_getSZ(3);
  @$pb.TagNumber(4)
  set unit($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnit() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnit() => $_clearField(4);

  @$pb.TagNumber(5)
  Direction get direction => $_getN(4);
  @$pb.TagNumber(5)
  set direction(Direction value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDirection() => $_has(4);
  @$pb.TagNumber(5)
  void clearDirection() => $_clearField(5);

  /// How close counts as met. Exactly the target is almost never what
  /// anybody means about a body weight.
  @$pb.TagNumber(6)
  $core.int get tolerance => $_getIZ(5);
  @$pb.TagNumber(6)
  set tolerance($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTolerance() => $_has(5);
  @$pb.TagNumber(6)
  void clearTolerance() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get targetBy => $_getN(6);
  @$pb.TagNumber(7)
  set targetBy($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTargetBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearTargetBy() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureTargetBy() => $_ensure(6);
}

/// The dietitian's plan and what it is aiming at (SRS-DIET-004).
class CarePlan extends $pb.GeneratedMessage {
  factory CarePlan({
    $core.String? planId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? assessmentId,
    $core.Iterable<NutritionGoal>? goals,
    $core.String? plan,
    $0.Timestamp? reviewDue,
    PlanState? state,
    $0.Timestamp? closedAt,
    $core.String? closedBy,
    $core.String? closureNote,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (assessmentId != null) result.assessmentId = assessmentId;
    if (goals != null) result.goals.addAll(goals);
    if (plan != null) result.plan = plan;
    if (reviewDue != null) result.reviewDue = reviewDue;
    if (state != null) result.state = state;
    if (closedAt != null) result.closedAt = closedAt;
    if (closedBy != null) result.closedBy = closedBy;
    if (closureNote != null) result.closureNote = closureNote;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
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
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'planId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'assessmentId')
    ..pPM<NutritionGoal>(5, _omitFieldNames ? '' : 'goals',
        subBuilder: NutritionGoal.create)
    ..aOS(6, _omitFieldNames ? '' : 'plan')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'reviewDue',
        subBuilder: $0.Timestamp.create)
    ..aE<PlanState>(8, _omitFieldNames ? '' : 'state',
        enumValues: PlanState.values)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'closedBy')
    ..aOS(11, _omitFieldNames ? '' : 'closureNote')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(14, _omitFieldNames ? '' : 'version')
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

  /// The assessment this plan was written from. A plan whose reasoning cannot
  /// be produced is one nobody can review.
  @$pb.TagNumber(4)
  $core.String get assessmentId => $_getSZ(3);
  @$pb.TagNumber(4)
  set assessmentId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAssessmentId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAssessmentId() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<NutritionGoal> get goals => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get plan => $_getSZ(5);
  @$pb.TagNumber(6)
  set plan($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPlan() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlan() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get reviewDue => $_getN(6);
  @$pb.TagNumber(7)
  set reviewDue($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasReviewDue() => $_has(6);
  @$pb.TagNumber(7)
  void clearReviewDue() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureReviewDue() => $_ensure(6);

  @$pb.TagNumber(8)
  PlanState get state => $_getN(7);
  @$pb.TagNumber(8)
  set state(PlanState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasState() => $_has(7);
  @$pb.TagNumber(8)
  void clearState() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get closedAt => $_getN(8);
  @$pb.TagNumber(9)
  set closedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasClosedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearClosedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureClosedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get closedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set closedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasClosedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearClosedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get closureNote => $_getSZ(10);
  @$pb.TagNumber(11)
  set closureNote($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasClosureNote() => $_has(10);
  @$pb.TagNumber(11)
  void clearClosureNote() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get createdAt => $_getN(11);
  @$pb.TagNumber(12)
  set createdAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCreatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureCreatedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get createdBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set createdBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCreatedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get version => $_getI64(13);
  @$pb.TagNumber(14)
  set version($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasVersion() => $_has(13);
  @$pb.TagNumber(14)
  void clearVersion() => $_clearField(14);
}

/// One measurement against a goal (SRS-DIET-004).
class Progress extends $pb.GeneratedMessage {
  factory Progress({
    $core.String? progressId,
    $core.String? planId,
    $core.String? goalCode,
    $core.int? value,
    $core.String? unit,
    $core.String? note,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (progressId != null) result.progressId = progressId;
    if (planId != null) result.planId = planId;
    if (goalCode != null) result.goalCode = goalCode;
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (note != null) result.note = note;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  Progress._();

  factory Progress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Progress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Progress',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'progressId')
    ..aOS(2, _omitFieldNames ? '' : 'planId')
    ..aOS(3, _omitFieldNames ? '' : 'goalCode')
    ..aI(4, _omitFieldNames ? '' : 'value')
    ..aOS(5, _omitFieldNames ? '' : 'unit')
    ..aOS(6, _omitFieldNames ? '' : 'note')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Progress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Progress copyWith(void Function(Progress) updates) =>
      super.copyWith((message) => updates(message as Progress)) as Progress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Progress create() => Progress._();
  @$core.override
  Progress createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Progress getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Progress>(create);
  static Progress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get progressId => $_getSZ(0);
  @$pb.TagNumber(1)
  set progressId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProgressId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgressId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get planId => $_getSZ(1);
  @$pb.TagNumber(2)
  set planId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlanId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlanId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get goalCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set goalCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGoalCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearGoalCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get value => $_getIZ(3);
  @$pb.TagNumber(4)
  set value($core.int value) => $_setSignedInt32(3, value);
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

/// One point on a goal's trend (SRS-DIET-004).
class TrendPoint extends $pb.GeneratedMessage {
  factory TrendPoint({
    $core.int? value,
    $0.Timestamp? at,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (at != null) result.at = at;
    return result;
  }

  TrendPoint._();

  factory TrendPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrendPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendPoint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'value')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'at',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendPoint copyWith(void Function(TrendPoint) updates) =>
      super.copyWith((message) => updates(message as TrendPoint)) as TrendPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrendPoint create() => TrendPoint._();
  @$core.override
  TrendPoint createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TrendPoint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendPoint>(create);
  static TrendPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get value => $_getIZ(0);
  @$pb.TagNumber(1)
  set value($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get at => $_getN(1);
  @$pb.TagNumber(2)
  set at($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureAt() => $_ensure(1);
}

/// A goal and its measurements over time (SRS-DIET-004).
class Trend extends $pb.GeneratedMessage {
  factory Trend({
    NutritionGoal? goal,
    $core.Iterable<TrendPoint>? points,
    $core.bool? met,
    $core.bool? improving,
    $core.bool? unanswerable,
  }) {
    final result = create();
    if (goal != null) result.goal = goal;
    if (points != null) result.points.addAll(points);
    if (met != null) result.met = met;
    if (improving != null) result.improving = improving;
    if (unanswerable != null) result.unanswerable = unanswerable;
    return result;
  }

  Trend._();

  factory Trend.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Trend.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Trend',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<NutritionGoal>(1, _omitFieldNames ? '' : 'goal',
        subBuilder: NutritionGoal.create)
    ..pPM<TrendPoint>(2, _omitFieldNames ? '' : 'points',
        subBuilder: TrendPoint.create)
    ..aOB(3, _omitFieldNames ? '' : 'met')
    ..aOB(4, _omitFieldNames ? '' : 'improving')
    ..aOB(5, _omitFieldNames ? '' : 'unanswerable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Trend clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Trend copyWith(void Function(Trend) updates) =>
      super.copyWith((message) => updates(message as Trend)) as Trend;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Trend create() => Trend._();
  @$core.override
  Trend createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Trend getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Trend>(create);
  static Trend? _defaultInstance;

  @$pb.TagNumber(1)
  NutritionGoal get goal => $_getN(0);
  @$pb.TagNumber(1)
  set goal(NutritionGoal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGoal() => $_has(0);
  @$pb.TagNumber(1)
  void clearGoal() => $_clearField(1);
  @$pb.TagNumber(1)
  NutritionGoal ensureGoal() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<TrendPoint> get points => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get met => $_getBF(2);
  @$pb.TagNumber(3)
  set met($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMet() => $_has(2);
  @$pb.TagNumber(3)
  void clearMet() => $_clearField(3);

  /// Reported beside met rather than instead of it: a patient moving the
  /// right way and still far from target is a different conversation from
  /// one who has arrived.
  @$pb.TagNumber(4)
  $core.bool get improving => $_getBF(3);
  @$pb.TagNumber(4)
  set improving($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasImproving() => $_has(3);
  @$pb.TagNumber(4)
  void clearImproving() => $_clearField(4);

  /// A goal with nothing measured against it. Reported rather than shown as a
  /// flat line at zero, which reads as a patient whose weight is nothing.
  @$pb.TagNumber(5)
  $core.bool get unanswerable => $_getBF(4);
  @$pb.TagNumber(5)
  set unanswerable($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnanswerable() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnanswerable() => $_clearField(5);
}

/// One patient's place in a meal service (SRS-DIET-005).
class CensusLine extends $pb.GeneratedMessage {
  factory CensusLine({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? wardId,
    $core.String? bedId,
    $core.String? orderId,
    Route? route,
    $core.String? textureCode,
    $core.String? textureLabel,
    $core.String? fluidCode,
    $core.Iterable<$core.String>? restrictions,
    $core.Iterable<$core.String>? supplements,
    $core.String? instruction,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (wardId != null) result.wardId = wardId;
    if (bedId != null) result.bedId = bedId;
    if (orderId != null) result.orderId = orderId;
    if (route != null) result.route = route;
    if (textureCode != null) result.textureCode = textureCode;
    if (textureLabel != null) result.textureLabel = textureLabel;
    if (fluidCode != null) result.fluidCode = fluidCode;
    if (restrictions != null) result.restrictions.addAll(restrictions);
    if (supplements != null) result.supplements.addAll(supplements);
    if (instruction != null) result.instruction = instruction;
    return result;
  }

  CensusLine._();

  factory CensusLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CensusLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CensusLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'wardId')
    ..aOS(4, _omitFieldNames ? '' : 'bedId')
    ..aOS(5, _omitFieldNames ? '' : 'orderId')
    ..aE<Route>(6, _omitFieldNames ? '' : 'route', enumValues: Route.values)
    ..aOS(7, _omitFieldNames ? '' : 'textureCode')
    ..aOS(8, _omitFieldNames ? '' : 'textureLabel')
    ..aOS(9, _omitFieldNames ? '' : 'fluidCode')
    ..pPS(10, _omitFieldNames ? '' : 'restrictions')
    ..pPS(11, _omitFieldNames ? '' : 'supplements')
    ..aOS(12, _omitFieldNames ? '' : 'instruction')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CensusLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CensusLine copyWith(void Function(CensusLine) updates) =>
      super.copyWith((message) => updates(message as CensusLine)) as CensusLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CensusLine create() => CensusLine._();
  @$core.override
  CensusLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CensusLine getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CensusLine>(create);
  static CensusLine? _defaultInstance;

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
  $core.String get wardId => $_getSZ(2);
  @$pb.TagNumber(3)
  set wardId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWardId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWardId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get bedId => $_getSZ(3);
  @$pb.TagNumber(4)
  set bedId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBedId() => $_has(3);
  @$pb.TagNumber(4)
  void clearBedId() => $_clearField(4);

  /// The order this line was built from. After a wrong tray that is the first
  /// thing anybody asks.
  @$pb.TagNumber(5)
  $core.String get orderId => $_getSZ(4);
  @$pb.TagNumber(5)
  set orderId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOrderId() => $_has(4);
  @$pb.TagNumber(5)
  void clearOrderId() => $_clearField(5);

  @$pb.TagNumber(6)
  Route get route => $_getN(5);
  @$pb.TagNumber(6)
  set route(Route value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRoute() => $_has(5);
  @$pb.TagNumber(6)
  void clearRoute() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get textureCode => $_getSZ(6);
  @$pb.TagNumber(7)
  set textureCode($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTextureCode() => $_has(6);
  @$pb.TagNumber(7)
  void clearTextureCode() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get textureLabel => $_getSZ(7);
  @$pb.TagNumber(8)
  set textureLabel($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTextureLabel() => $_has(7);
  @$pb.TagNumber(8)
  void clearTextureLabel() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get fluidCode => $_getSZ(8);
  @$pb.TagNumber(9)
  set fluidCode($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFluidCode() => $_has(8);
  @$pb.TagNumber(9)
  void clearFluidCode() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get restrictions => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get supplements => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get instruction => $_getSZ(11);
  @$pb.TagNumber(12)
  set instruction($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasInstruction() => $_has(11);
  @$pb.TagNumber(12)
  void clearInstruction() => $_clearField(12);
}

/// What the kitchen produces for one ward and one service (SRS-DIET-005).
class MealCensus extends $pb.GeneratedMessage {
  factory MealCensus({
    $core.String? censusId,
    $core.String? facilityId,
    $core.String? wardId,
    MealCycle? cycle,
    $0.Timestamp? serviceDate,
    $0.Timestamp? cutoffAt,
    $core.Iterable<CensusLine>? lines,
    CensusState? state,
    $core.int? censusVersion,
    $core.String? supersedesId,
    $0.Timestamp? frozenAt,
    $core.String? frozenBy,
    $0.Timestamp? builtAt,
    $core.String? builtBy,
  }) {
    final result = create();
    if (censusId != null) result.censusId = censusId;
    if (facilityId != null) result.facilityId = facilityId;
    if (wardId != null) result.wardId = wardId;
    if (cycle != null) result.cycle = cycle;
    if (serviceDate != null) result.serviceDate = serviceDate;
    if (cutoffAt != null) result.cutoffAt = cutoffAt;
    if (lines != null) result.lines.addAll(lines);
    if (state != null) result.state = state;
    if (censusVersion != null) result.censusVersion = censusVersion;
    if (supersedesId != null) result.supersedesId = supersedesId;
    if (frozenAt != null) result.frozenAt = frozenAt;
    if (frozenBy != null) result.frozenBy = frozenBy;
    if (builtAt != null) result.builtAt = builtAt;
    if (builtBy != null) result.builtBy = builtBy;
    return result;
  }

  MealCensus._();

  factory MealCensus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MealCensus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MealCensus',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'censusId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'wardId')
    ..aE<MealCycle>(4, _omitFieldNames ? '' : 'cycle',
        enumValues: MealCycle.values)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'serviceDate',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'cutoffAt',
        subBuilder: $0.Timestamp.create)
    ..pPM<CensusLine>(7, _omitFieldNames ? '' : 'lines',
        subBuilder: CensusLine.create)
    ..aE<CensusState>(8, _omitFieldNames ? '' : 'state',
        enumValues: CensusState.values)
    ..aI(9, _omitFieldNames ? '' : 'censusVersion')
    ..aOS(10, _omitFieldNames ? '' : 'supersedesId')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'frozenAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'frozenBy')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'builtAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(14, _omitFieldNames ? '' : 'builtBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MealCensus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MealCensus copyWith(void Function(MealCensus) updates) =>
      super.copyWith((message) => updates(message as MealCensus)) as MealCensus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MealCensus create() => MealCensus._();
  @$core.override
  MealCensus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MealCensus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MealCensus>(create);
  static MealCensus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get censusId => $_getSZ(0);
  @$pb.TagNumber(1)
  set censusId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCensusId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCensusId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get wardId => $_getSZ(2);
  @$pb.TagNumber(3)
  set wardId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWardId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWardId() => $_clearField(3);

  @$pb.TagNumber(4)
  MealCycle get cycle => $_getN(3);
  @$pb.TagNumber(4)
  set cycle(MealCycle value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCycle() => $_has(3);
  @$pb.TagNumber(4)
  void clearCycle() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get serviceDate => $_getN(4);
  @$pb.TagNumber(5)
  set serviceDate($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasServiceDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearServiceDate() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureServiceDate() => $_ensure(4);

  /// When production starts and the count stops being negotiable.
  @$pb.TagNumber(6)
  $0.Timestamp get cutoffAt => $_getN(5);
  @$pb.TagNumber(6)
  set cutoffAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCutoffAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCutoffAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureCutoffAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $pb.PbList<CensusLine> get lines => $_getList(6);

  @$pb.TagNumber(8)
  CensusState get state => $_getN(7);
  @$pb.TagNumber(8)
  set state(CensusState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasState() => $_has(7);
  @$pb.TagNumber(8)
  void clearState() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get censusVersion => $_getIZ(8);
  @$pb.TagNumber(9)
  set censusVersion($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCensusVersion() => $_has(8);
  @$pb.TagNumber(9)
  void clearCensusVersion() => $_clearField(9);

  /// Chains a reissue back to the census it replaced, so the whole sequence
  /// for one service is readable.
  @$pb.TagNumber(10)
  $core.String get supersedesId => $_getSZ(9);
  @$pb.TagNumber(10)
  set supersedesId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSupersedesId() => $_has(9);
  @$pb.TagNumber(10)
  void clearSupersedesId() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get frozenAt => $_getN(10);
  @$pb.TagNumber(11)
  set frozenAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasFrozenAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearFrozenAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureFrozenAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get frozenBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set frozenBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasFrozenBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearFrozenBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get builtAt => $_getN(12);
  @$pb.TagNumber(13)
  set builtAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasBuiltAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearBuiltAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureBuiltAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get builtBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set builtBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasBuiltBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearBuiltBy() => $_clearField(14);
}

/// One patient's meal through preparation and delivery (SRS-DIET-006).
class Tray extends $pb.GeneratedMessage {
  factory Tray({
    $core.String? trayId,
    $core.String? censusId,
    $core.String? patientId,
    $core.String? wardId,
    $core.String? bedId,
    MealCycle? cycle,
    $core.String? orderId,
    TrayState? state,
    $core.String? reason,
    $0.Timestamp? preparedAt,
    $core.String? preparedBy,
    $0.Timestamp? dispatchedAt,
    $core.String? dispatchedBy,
    $0.Timestamp? deliveredAt,
    $core.String? deliveredBy,
    $0.Timestamp? dueBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (trayId != null) result.trayId = trayId;
    if (censusId != null) result.censusId = censusId;
    if (patientId != null) result.patientId = patientId;
    if (wardId != null) result.wardId = wardId;
    if (bedId != null) result.bedId = bedId;
    if (cycle != null) result.cycle = cycle;
    if (orderId != null) result.orderId = orderId;
    if (state != null) result.state = state;
    if (reason != null) result.reason = reason;
    if (preparedAt != null) result.preparedAt = preparedAt;
    if (preparedBy != null) result.preparedBy = preparedBy;
    if (dispatchedAt != null) result.dispatchedAt = dispatchedAt;
    if (dispatchedBy != null) result.dispatchedBy = dispatchedBy;
    if (deliveredAt != null) result.deliveredAt = deliveredAt;
    if (deliveredBy != null) result.deliveredBy = deliveredBy;
    if (dueBy != null) result.dueBy = dueBy;
    if (version != null) result.version = version;
    return result;
  }

  Tray._();

  factory Tray.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Tray.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Tray',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trayId')
    ..aOS(2, _omitFieldNames ? '' : 'censusId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'wardId')
    ..aOS(5, _omitFieldNames ? '' : 'bedId')
    ..aE<MealCycle>(6, _omitFieldNames ? '' : 'cycle',
        enumValues: MealCycle.values)
    ..aOS(7, _omitFieldNames ? '' : 'orderId')
    ..aE<TrayState>(8, _omitFieldNames ? '' : 'state',
        enumValues: TrayState.values)
    ..aOS(9, _omitFieldNames ? '' : 'reason')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'preparedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'preparedBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'dispatchedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'dispatchedBy')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'deliveredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'deliveredBy')
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'dueBy',
        subBuilder: $0.Timestamp.create)
    ..aInt64(17, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tray clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tray copyWith(void Function(Tray) updates) =>
      super.copyWith((message) => updates(message as Tray)) as Tray;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Tray create() => Tray._();
  @$core.override
  Tray createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Tray getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tray>(create);
  static Tray? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trayId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trayId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrayId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrayId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get censusId => $_getSZ(1);
  @$pb.TagNumber(2)
  set censusId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCensusId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCensusId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get patientId => $_getSZ(2);
  @$pb.TagNumber(3)
  set patientId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPatientId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatientId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get wardId => $_getSZ(3);
  @$pb.TagNumber(4)
  set wardId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWardId() => $_has(3);
  @$pb.TagNumber(4)
  void clearWardId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get bedId => $_getSZ(4);
  @$pb.TagNumber(5)
  set bedId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBedId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBedId() => $_clearField(5);

  @$pb.TagNumber(6)
  MealCycle get cycle => $_getN(5);
  @$pb.TagNumber(6)
  set cycle(MealCycle value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCycle() => $_has(5);
  @$pb.TagNumber(6)
  void clearCycle() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get orderId => $_getSZ(6);
  @$pb.TagNumber(7)
  set orderId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOrderId() => $_has(6);
  @$pb.TagNumber(7)
  void clearOrderId() => $_clearField(7);

  @$pb.TagNumber(8)
  TrayState get state => $_getN(7);
  @$pb.TagNumber(8)
  set state(TrayState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasState() => $_has(7);
  @$pb.TagNumber(8)
  void clearState() => $_clearField(8);

  /// Why the meal was held back, declined or missed. Always set for those
  /// three states.
  @$pb.TagNumber(9)
  $core.String get reason => $_getSZ(8);
  @$pb.TagNumber(9)
  set reason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearReason() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get preparedAt => $_getN(9);
  @$pb.TagNumber(10)
  set preparedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasPreparedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearPreparedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensurePreparedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get preparedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set preparedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPreparedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearPreparedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get dispatchedAt => $_getN(11);
  @$pb.TagNumber(12)
  set dispatchedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasDispatchedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearDispatchedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureDispatchedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get dispatchedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set dispatchedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDispatchedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearDispatchedBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get deliveredAt => $_getN(13);
  @$pb.TagNumber(14)
  set deliveredAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasDeliveredAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearDeliveredAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureDeliveredAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get deliveredBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set deliveredBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasDeliveredBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearDeliveredBy() => $_clearField(15);

  /// When the meal stops being this meal.
  @$pb.TagNumber(16)
  $0.Timestamp get dueBy => $_getN(15);
  @$pb.TagNumber(16)
  set dueBy($0.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasDueBy() => $_has(15);
  @$pb.TagNumber(16)
  void clearDueBy() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureDueBy() => $_ensure(15);

  @$pb.TagNumber(17)
  $fixnum.Int64 get version => $_getI64(16);
  @$pb.TagNumber(17)
  set version($fixnum.Int64 value) => $_setInt64(16, value);
  @$pb.TagNumber(17)
  $core.bool hasVersion() => $_has(16);
  @$pb.TagNumber(17)
  void clearVersion() => $_clearField(17);
}

/// What happened to a service's trays (SRS-DIET-006).
class MealOutcome extends $pb.GeneratedMessage {
  factory MealOutcome({
    $core.int? planned,
    $core.int? delivered,
    $core.int? refused,
    $core.int? missed,
    $core.int? withheld,
    $core.int? late,
    $core.int? outstanding,
  }) {
    final result = create();
    if (planned != null) result.planned = planned;
    if (delivered != null) result.delivered = delivered;
    if (refused != null) result.refused = refused;
    if (missed != null) result.missed = missed;
    if (withheld != null) result.withheld = withheld;
    if (late != null) result.late = late;
    if (outstanding != null) result.outstanding = outstanding;
    return result;
  }

  MealOutcome._();

  factory MealOutcome.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MealOutcome.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MealOutcome',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'planned')
    ..aI(2, _omitFieldNames ? '' : 'delivered')
    ..aI(3, _omitFieldNames ? '' : 'refused')
    ..aI(4, _omitFieldNames ? '' : 'missed')
    ..aI(5, _omitFieldNames ? '' : 'withheld')
    ..aI(6, _omitFieldNames ? '' : 'late')
    ..aI(7, _omitFieldNames ? '' : 'outstanding')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MealOutcome clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MealOutcome copyWith(void Function(MealOutcome) updates) =>
      super.copyWith((message) => updates(message as MealOutcome))
          as MealOutcome;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MealOutcome create() => MealOutcome._();
  @$core.override
  MealOutcome createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MealOutcome getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MealOutcome>(create);
  static MealOutcome? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get planned => $_getIZ(0);
  @$pb.TagNumber(1)
  set planned($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanned() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanned() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get delivered => $_getIZ(1);
  @$pb.TagNumber(2)
  set delivered($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDelivered() => $_has(1);
  @$pb.TagNumber(2)
  void clearDelivered() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get refused => $_getIZ(2);
  @$pb.TagNumber(3)
  set refused($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRefused() => $_has(2);
  @$pb.TagNumber(3)
  void clearRefused() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get missed => $_getIZ(3);
  @$pb.TagNumber(4)
  set missed($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMissed() => $_has(3);
  @$pb.TagNumber(4)
  void clearMissed() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get withheld => $_getIZ(4);
  @$pb.TagNumber(5)
  set withheld($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWithheld() => $_has(4);
  @$pb.TagNumber(5)
  void clearWithheld() => $_clearField(5);

  /// Counted apart from missed: a lunch at four is a different failure from a
  /// lunch that never came.
  @$pb.TagNumber(6)
  $core.int get late => $_getIZ(5);
  @$pb.TagNumber(6)
  set late($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLate() => $_has(5);
  @$pb.TagNumber(6)
  void clearLate() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get outstanding => $_getIZ(6);
  @$pb.TagNumber(7)
  set outstanding($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOutstanding() => $_has(6);
  @$pb.TagNumber(7)
  void clearOutstanding() => $_clearField(7);
}

/// The dietitian's plan for tube or intravenous feeding (SRS-DIET-007).
class NutritionSupportPlan extends $pb.GeneratedMessage {
  factory NutritionSupportPlan({
    $core.String? planId,
    $core.String? patientId,
    $core.String? encounterId,
    SupportKind? kind,
    $core.String? formulaCode,
    $core.String? formulaName,
    $core.int? targetVolumeMl,
    $core.int? targetEnergyKcal,
    $core.int? targetProteinG,
    $core.String? rampPlan,
    $core.String? orderRef,
    $core.String? orderContext,
    SupportState? state,
    $0.Timestamp? stoppedAt,
    $core.String? stoppedBy,
    $core.String? stopReason,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (kind != null) result.kind = kind;
    if (formulaCode != null) result.formulaCode = formulaCode;
    if (formulaName != null) result.formulaName = formulaName;
    if (targetVolumeMl != null) result.targetVolumeMl = targetVolumeMl;
    if (targetEnergyKcal != null) result.targetEnergyKcal = targetEnergyKcal;
    if (targetProteinG != null) result.targetProteinG = targetProteinG;
    if (rampPlan != null) result.rampPlan = rampPlan;
    if (orderRef != null) result.orderRef = orderRef;
    if (orderContext != null) result.orderContext = orderContext;
    if (state != null) result.state = state;
    if (stoppedAt != null) result.stoppedAt = stoppedAt;
    if (stoppedBy != null) result.stoppedBy = stoppedBy;
    if (stopReason != null) result.stopReason = stopReason;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  NutritionSupportPlan._();

  factory NutritionSupportPlan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NutritionSupportPlan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NutritionSupportPlan',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'planId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aE<SupportKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: SupportKind.values)
    ..aOS(5, _omitFieldNames ? '' : 'formulaCode')
    ..aOS(6, _omitFieldNames ? '' : 'formulaName')
    ..aI(7, _omitFieldNames ? '' : 'targetVolumeMl')
    ..aI(8, _omitFieldNames ? '' : 'targetEnergyKcal')
    ..aI(9, _omitFieldNames ? '' : 'targetProteinG')
    ..aOS(10, _omitFieldNames ? '' : 'rampPlan')
    ..aOS(11, _omitFieldNames ? '' : 'orderRef')
    ..aOS(12, _omitFieldNames ? '' : 'orderContext')
    ..aE<SupportState>(13, _omitFieldNames ? '' : 'state',
        enumValues: SupportState.values)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'stoppedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'stoppedBy')
    ..aOS(16, _omitFieldNames ? '' : 'stopReason')
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(18, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(19, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NutritionSupportPlan clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NutritionSupportPlan copyWith(void Function(NutritionSupportPlan) updates) =>
      super.copyWith((message) => updates(message as NutritionSupportPlan))
          as NutritionSupportPlan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NutritionSupportPlan create() => NutritionSupportPlan._();
  @$core.override
  NutritionSupportPlan createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NutritionSupportPlan getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NutritionSupportPlan>(create);
  static NutritionSupportPlan? _defaultInstance;

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
  SupportKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(SupportKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  /// A request, not a dispense.
  @$pb.TagNumber(5)
  $core.String get formulaCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set formulaCode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFormulaCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearFormulaCode() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get formulaName => $_getSZ(5);
  @$pb.TagNumber(6)
  set formulaName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFormulaName() => $_has(5);
  @$pb.TagNumber(6)
  void clearFormulaName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get targetVolumeMl => $_getIZ(6);
  @$pb.TagNumber(7)
  set targetVolumeMl($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTargetVolumeMl() => $_has(6);
  @$pb.TagNumber(7)
  void clearTargetVolumeMl() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get targetEnergyKcal => $_getIZ(7);
  @$pb.TagNumber(8)
  set targetEnergyKcal($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTargetEnergyKcal() => $_has(7);
  @$pb.TagNumber(8)
  void clearTargetEnergyKcal() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get targetProteinG => $_getIZ(8);
  @$pb.TagNumber(9)
  set targetProteinG($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTargetProteinG() => $_has(8);
  @$pb.TagNumber(9)
  void clearTargetProteinG() => $_clearField(9);

  /// How to build up, which matters more than the target for a patient at
  /// refeeding risk.
  @$pb.TagNumber(10)
  $core.String get rampPlan => $_getSZ(9);
  @$pb.TagNumber(10)
  set rampPlan($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRampPlan() => $_has(9);
  @$pb.TagNumber(10)
  void clearRampPlan() => $_clearField(10);

  /// The order or prescription that carries the plan out, and which context
  /// owns it. Required before the plan goes active.
  @$pb.TagNumber(11)
  $core.String get orderRef => $_getSZ(10);
  @$pb.TagNumber(11)
  set orderRef($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOrderRef() => $_has(10);
  @$pb.TagNumber(11)
  void clearOrderRef() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get orderContext => $_getSZ(11);
  @$pb.TagNumber(12)
  set orderContext($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOrderContext() => $_has(11);
  @$pb.TagNumber(12)
  void clearOrderContext() => $_clearField(12);

  @$pb.TagNumber(13)
  SupportState get state => $_getN(12);
  @$pb.TagNumber(13)
  set state(SupportState value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasState() => $_has(12);
  @$pb.TagNumber(13)
  void clearState() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get stoppedAt => $_getN(13);
  @$pb.TagNumber(14)
  set stoppedAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasStoppedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearStoppedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureStoppedAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get stoppedBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set stoppedBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasStoppedBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearStoppedBy() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get stopReason => $_getSZ(15);
  @$pb.TagNumber(16)
  set stopReason($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasStopReason() => $_has(15);
  @$pb.TagNumber(16)
  void clearStopReason() => $_clearField(16);

  @$pb.TagNumber(17)
  $0.Timestamp get createdAt => $_getN(16);
  @$pb.TagNumber(17)
  set createdAt($0.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasCreatedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearCreatedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Timestamp ensureCreatedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.String get createdBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set createdBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasCreatedBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearCreatedBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $fixnum.Int64 get version => $_getI64(18);
  @$pb.TagNumber(19)
  set version($fixnum.Int64 value) => $_setInt64(18, value);
  @$pb.TagNumber(19)
  $core.bool hasVersion() => $_has(18);
  @$pb.TagNumber(19)
  void clearVersion() => $_clearField(19);
}

/// Something the kitchen can put on a tray, and what is in it
/// (SRS-DIET-003).
class DietItem extends $pb.GeneratedMessage {
  factory DietItem({
    $core.String? code,
    $core.String? name,
    $core.Iterable<$core.String>? allergenCodes,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (allergenCodes != null) result.allergenCodes.addAll(allergenCodes);
    return result;
  }

  DietItem._();

  factory DietItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DietItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DietItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..pPS(3, _omitFieldNames ? '' : 'allergenCodes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DietItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DietItem copyWith(void Function(DietItem) updates) =>
      super.copyWith((message) => updates(message as DietItem)) as DietItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DietItem create() => DietItem._();
  @$core.override
  DietItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DietItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DietItem>(create);
  static DietItem? _defaultInstance;

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

  /// From the same terminologies the clinical allergy list uses. Matching on
  /// names is how "groundnut oil" gets past a peanut allergy.
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get allergenCodes => $_getList(2);
}

/// How much of one ingredient a portion uses (SRS-DIET-008).
class IngredientQuantity extends $pb.GeneratedMessage {
  factory IngredientQuantity({
    $core.String? code,
    $core.String? name,
    $core.int? grams,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (grams != null) result.grams = grams;
    return result;
  }

  IngredientQuantity._();

  factory IngredientQuantity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IngredientQuantity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IngredientQuantity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'grams')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngredientQuantity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngredientQuantity copyWith(void Function(IngredientQuantity) updates) =>
      super.copyWith((message) => updates(message as IngredientQuantity))
          as IngredientQuantity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IngredientQuantity create() => IngredientQuantity._();
  @$core.override
  IngredientQuantity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IngredientQuantity getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IngredientQuantity>(create);
  static IngredientQuantity? _defaultInstance;

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
  $core.int get grams => $_getIZ(2);
  @$pb.TagNumber(3)
  set grams($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGrams() => $_has(2);
  @$pb.TagNumber(3)
  void clearGrams() => $_clearField(3);
}

/// One dish and what it takes (SRS-DIET-008).
class Recipe extends $pb.GeneratedMessage {
  factory Recipe({
    $core.String? code,
    $core.String? name,
    $core.Iterable<IngredientQuantity>? ingredients,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (ingredients != null) result.ingredients.addAll(ingredients);
    return result;
  }

  Recipe._();

  factory Recipe.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Recipe.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Recipe',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..pPM<IngredientQuantity>(3, _omitFieldNames ? '' : 'ingredients',
        subBuilder: IngredientQuantity.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Recipe clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Recipe copyWith(void Function(Recipe) updates) =>
      super.copyWith((message) => updates(message as Recipe)) as Recipe;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Recipe create() => Recipe._();
  @$core.override
  Recipe createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Recipe getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Recipe>(create);
  static Recipe? _defaultInstance;

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
  $pb.PbList<IngredientQuantity> get ingredients => $_getList(2);
}

/// A recipe on the menu for a cycle and a texture (SRS-DIET-008).
class MenuItem extends $pb.GeneratedMessage {
  factory MenuItem({
    MealCycle? cycle,
    $core.String? textureCode,
    Recipe? recipe,
    $core.int? portions,
  }) {
    final result = create();
    if (cycle != null) result.cycle = cycle;
    if (textureCode != null) result.textureCode = textureCode;
    if (recipe != null) result.recipe = recipe;
    if (portions != null) result.portions = portions;
    return result;
  }

  MenuItem._();

  factory MenuItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MenuItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MenuItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aE<MealCycle>(1, _omitFieldNames ? '' : 'cycle',
        enumValues: MealCycle.values)
    ..aOS(2, _omitFieldNames ? '' : 'textureCode')
    ..aOM<Recipe>(3, _omitFieldNames ? '' : 'recipe', subBuilder: Recipe.create)
    ..aI(4, _omitFieldNames ? '' : 'portions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MenuItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MenuItem copyWith(void Function(MenuItem) updates) =>
      super.copyWith((message) => updates(message as MenuItem)) as MenuItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MenuItem create() => MenuItem._();
  @$core.override
  MenuItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MenuItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MenuItem>(create);
  static MenuItem? _defaultInstance;

  @$pb.TagNumber(1)
  MealCycle get cycle => $_getN(0);
  @$pb.TagNumber(1)
  set cycle(MealCycle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCycle() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycle() => $_clearField(1);

  /// A pureed lunch and a normal lunch are different dishes with different
  /// ingredients.
  @$pb.TagNumber(2)
  $core.String get textureCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set textureCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTextureCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearTextureCode() => $_clearField(2);

  @$pb.TagNumber(3)
  Recipe get recipe => $_getN(2);
  @$pb.TagNumber(3)
  set recipe(Recipe value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRecipe() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipe() => $_clearField(3);
  @$pb.TagNumber(3)
  Recipe ensureRecipe() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get portions => $_getIZ(3);
  @$pb.TagNumber(4)
  set portions($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPortions() => $_has(3);
  @$pb.TagNumber(4)
  void clearPortions() => $_clearField(4);
}

/// One ingredient's forecast and what was used (SRS-DIET-008).
class IngredientDemand extends $pb.GeneratedMessage {
  factory IngredientDemand({
    $core.String? code,
    $core.String? name,
    $core.int? forecastG,
    $core.int? actualG,
    $core.bool? actualRecorded,
    $core.int? wastageG,
    $core.bool? wastageKnown,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (forecastG != null) result.forecastG = forecastG;
    if (actualG != null) result.actualG = actualG;
    if (actualRecorded != null) result.actualRecorded = actualRecorded;
    if (wastageG != null) result.wastageG = wastageG;
    if (wastageKnown != null) result.wastageKnown = wastageKnown;
    return result;
  }

  IngredientDemand._();

  factory IngredientDemand.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IngredientDemand.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IngredientDemand',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'forecastG')
    ..aI(4, _omitFieldNames ? '' : 'actualG')
    ..aOB(5, _omitFieldNames ? '' : 'actualRecorded')
    ..aI(6, _omitFieldNames ? '' : 'wastageG')
    ..aOB(7, _omitFieldNames ? '' : 'wastageKnown')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngredientDemand clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngredientDemand copyWith(void Function(IngredientDemand) updates) =>
      super.copyWith((message) => updates(message as IngredientDemand))
          as IngredientDemand;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IngredientDemand create() => IngredientDemand._();
  @$core.override
  IngredientDemand createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IngredientDemand getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IngredientDemand>(create);
  static IngredientDemand? _defaultInstance;

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
  $core.int get forecastG => $_getIZ(2);
  @$pb.TagNumber(3)
  set forecastG($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasForecastG() => $_has(2);
  @$pb.TagNumber(3)
  void clearForecastG() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get actualG => $_getIZ(3);
  @$pb.TagNumber(4)
  set actualG($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActualG() => $_has(3);
  @$pb.TagNumber(4)
  void clearActualG() => $_clearField(4);

  /// Zero actual with this false means nobody has counted yet, which is not
  /// the same as having used none.
  @$pb.TagNumber(5)
  $core.bool get actualRecorded => $_getBF(4);
  @$pb.TagNumber(5)
  set actualRecorded($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasActualRecorded() => $_has(4);
  @$pb.TagNumber(5)
  void clearActualRecorded() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get wastageG => $_getIZ(5);
  @$pb.TagNumber(6)
  set wastageG($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWastageG() => $_has(5);
  @$pb.TagNumber(6)
  void clearWastageG() => $_clearField(6);

  /// Wastage is only meaningful once somebody has counted.
  @$pb.TagNumber(7)
  $core.bool get wastageKnown => $_getBF(6);
  @$pb.TagNumber(7)
  set wastageKnown($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWastageKnown() => $_has(6);
  @$pb.TagNumber(7)
  void clearWastageKnown() => $_clearField(7);
}

/// What one service was expected to consume and what it did (SRS-DIET-008).
class Forecast extends $pb.GeneratedMessage {
  factory Forecast({
    $core.String? censusId,
    $core.int? censusVersion,
    MealCycle? cycle,
    $0.Timestamp? serviceDate,
    $core.int? trays,
    $core.Iterable<IngredientDemand>? demand,
    $core.int? uncovered,
  }) {
    final result = create();
    if (censusId != null) result.censusId = censusId;
    if (censusVersion != null) result.censusVersion = censusVersion;
    if (cycle != null) result.cycle = cycle;
    if (serviceDate != null) result.serviceDate = serviceDate;
    if (trays != null) result.trays = trays;
    if (demand != null) result.demand.addAll(demand);
    if (uncovered != null) result.uncovered = uncovered;
    return result;
  }

  Forecast._();

  factory Forecast.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Forecast.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Forecast',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'censusId')
    ..aI(2, _omitFieldNames ? '' : 'censusVersion')
    ..aE<MealCycle>(3, _omitFieldNames ? '' : 'cycle',
        enumValues: MealCycle.values)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'serviceDate',
        subBuilder: $0.Timestamp.create)
    ..aI(5, _omitFieldNames ? '' : 'trays')
    ..pPM<IngredientDemand>(6, _omitFieldNames ? '' : 'demand',
        subBuilder: IngredientDemand.create)
    ..aI(7, _omitFieldNames ? '' : 'uncovered')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Forecast clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Forecast copyWith(void Function(Forecast) updates) =>
      super.copyWith((message) => updates(message as Forecast)) as Forecast;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Forecast create() => Forecast._();
  @$core.override
  Forecast createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Forecast getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Forecast>(create);
  static Forecast? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get censusId => $_getSZ(0);
  @$pb.TagNumber(1)
  set censusId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCensusId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCensusId() => $_clearField(1);

  /// Which version of the census this was computed from. A reissue changes
  /// the count, and a forecast that did not say which version it came from
  /// cannot be reconciled with either.
  @$pb.TagNumber(2)
  $core.int get censusVersion => $_getIZ(1);
  @$pb.TagNumber(2)
  set censusVersion($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCensusVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearCensusVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  MealCycle get cycle => $_getN(2);
  @$pb.TagNumber(3)
  set cycle(MealCycle value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCycle() => $_has(2);
  @$pb.TagNumber(3)
  void clearCycle() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get serviceDate => $_getN(3);
  @$pb.TagNumber(4)
  set serviceDate($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasServiceDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearServiceDate() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureServiceDate() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get trays => $_getIZ(4);
  @$pb.TagNumber(5)
  set trays($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTrays() => $_has(4);
  @$pb.TagNumber(5)
  void clearTrays() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<IngredientDemand> get demand => $_getList(5);

  /// Census lines no menu item covered. Reported rather than dropped: a
  /// forecast that silently ignored forty pureed trays is a kitchen that runs
  /// out.
  @$pb.TagNumber(7)
  $core.int get uncovered => $_getIZ(6);
  @$pb.TagNumber(7)
  set uncovered($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUncovered() => $_has(6);
  @$pb.TagNumber(7)
  void clearUncovered() => $_clearField(7);
}

class RecordAssessmentRequest extends $pb.GeneratedMessage {
  factory RecordAssessmentRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    Anthropometry? anthropometry,
    $core.String? intakeSummary,
    $core.String? diagnosisCode,
    $core.String? diagnosis,
    Requirement? requirement,
    $core.String? riskTool,
    $core.int? riskScore,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (anthropometry != null) result.anthropometry = anthropometry;
    if (intakeSummary != null) result.intakeSummary = intakeSummary;
    if (diagnosisCode != null) result.diagnosisCode = diagnosisCode;
    if (diagnosis != null) result.diagnosis = diagnosis;
    if (requirement != null) result.requirement = requirement;
    if (riskTool != null) result.riskTool = riskTool;
    if (riskScore != null) result.riskScore = riskScore;
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
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOM<Anthropometry>(4, _omitFieldNames ? '' : 'anthropometry',
        subBuilder: Anthropometry.create)
    ..aOS(5, _omitFieldNames ? '' : 'intakeSummary')
    ..aOS(6, _omitFieldNames ? '' : 'diagnosisCode')
    ..aOS(7, _omitFieldNames ? '' : 'diagnosis')
    ..aOM<Requirement>(8, _omitFieldNames ? '' : 'requirement',
        subBuilder: Requirement.create)
    ..aOS(9, _omitFieldNames ? '' : 'riskTool')
    ..aI(10, _omitFieldNames ? '' : 'riskScore')
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
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  Anthropometry get anthropometry => $_getN(3);
  @$pb.TagNumber(4)
  set anthropometry(Anthropometry value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAnthropometry() => $_has(3);
  @$pb.TagNumber(4)
  void clearAnthropometry() => $_clearField(4);
  @$pb.TagNumber(4)
  Anthropometry ensureAnthropometry() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get intakeSummary => $_getSZ(4);
  @$pb.TagNumber(5)
  set intakeSummary($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIntakeSummary() => $_has(4);
  @$pb.TagNumber(5)
  void clearIntakeSummary() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get diagnosisCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set diagnosisCode($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDiagnosisCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearDiagnosisCode() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get diagnosis => $_getSZ(6);
  @$pb.TagNumber(7)
  set diagnosis($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDiagnosis() => $_has(6);
  @$pb.TagNumber(7)
  void clearDiagnosis() => $_clearField(7);

  @$pb.TagNumber(8)
  Requirement get requirement => $_getN(7);
  @$pb.TagNumber(8)
  set requirement(Requirement value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRequirement() => $_has(7);
  @$pb.TagNumber(8)
  void clearRequirement() => $_clearField(8);
  @$pb.TagNumber(8)
  Requirement ensureRequirement() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get riskTool => $_getSZ(8);
  @$pb.TagNumber(9)
  set riskTool($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRiskTool() => $_has(8);
  @$pb.TagNumber(9)
  void clearRiskTool() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get riskScore => $_getIZ(9);
  @$pb.TagNumber(10)
  set riskScore($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRiskScore() => $_has(9);
  @$pb.TagNumber(10)
  void clearRiskScore() => $_clearField(10);
}

class RecordAssessmentResponse extends $pb.GeneratedMessage {
  factory RecordAssessmentResponse({
    NutritionAssessment? assessment,
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
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<NutritionAssessment>(1, _omitFieldNames ? '' : 'assessment',
        subBuilder: NutritionAssessment.create)
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

  /// The allergy references are filled from the clinical record rather than
  /// from the request: a later question is answered against what the
  /// dietitian actually saw.
  @$pb.TagNumber(1)
  NutritionAssessment get assessment => $_getN(0);
  @$pb.TagNumber(1)
  set assessment(NutritionAssessment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssessment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssessment() => $_clearField(1);
  @$pb.TagNumber(1)
  NutritionAssessment ensureAssessment() => $_ensure(0);
}

class SignAssessmentRequest extends $pb.GeneratedMessage {
  factory SignAssessmentRequest({
    $core.String? assessmentId,
  }) {
    final result = create();
    if (assessmentId != null) result.assessmentId = assessmentId;
    return result;
  }

  SignAssessmentRequest._();

  factory SignAssessmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignAssessmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignAssessmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assessmentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignAssessmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignAssessmentRequest copyWith(
          void Function(SignAssessmentRequest) updates) =>
      super.copyWith((message) => updates(message as SignAssessmentRequest))
          as SignAssessmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignAssessmentRequest create() => SignAssessmentRequest._();
  @$core.override
  SignAssessmentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SignAssessmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignAssessmentRequest>(create);
  static SignAssessmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assessmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assessmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssessmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssessmentId() => $_clearField(1);
}

class SignAssessmentResponse extends $pb.GeneratedMessage {
  factory SignAssessmentResponse({
    NutritionAssessment? assessment,
  }) {
    final result = create();
    if (assessment != null) result.assessment = assessment;
    return result;
  }

  SignAssessmentResponse._();

  factory SignAssessmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignAssessmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignAssessmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<NutritionAssessment>(1, _omitFieldNames ? '' : 'assessment',
        subBuilder: NutritionAssessment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignAssessmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignAssessmentResponse copyWith(
          void Function(SignAssessmentResponse) updates) =>
      super.copyWith((message) => updates(message as SignAssessmentResponse))
          as SignAssessmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignAssessmentResponse create() => SignAssessmentResponse._();
  @$core.override
  SignAssessmentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SignAssessmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignAssessmentResponse>(create);
  static SignAssessmentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  NutritionAssessment get assessment => $_getN(0);
  @$pb.TagNumber(1)
  set assessment(NutritionAssessment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssessment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssessment() => $_clearField(1);
  @$pb.TagNumber(1)
  NutritionAssessment ensureAssessment() => $_ensure(0);
}

class ListAssessmentsRequest extends $pb.GeneratedMessage {
  factory ListAssessmentsRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.bool? signedOnly,
    $core.int? pageSize,
    $core.int? pageOffset,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (signedOnly != null) result.signedOnly = signedOnly;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageOffset != null) result.pageOffset = pageOffset;
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
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOB(3, _omitFieldNames ? '' : 'signedOnly')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..aI(5, _omitFieldNames ? '' : 'pageOffset')
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
  $core.bool get signedOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set signedOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSignedOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearSignedOnly() => $_clearField(3);

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

class ListAssessmentsResponse extends $pb.GeneratedMessage {
  factory ListAssessmentsResponse({
    $core.Iterable<NutritionAssessment>? assessments,
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
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..pPM<NutritionAssessment>(1, _omitFieldNames ? '' : 'assessments',
        subBuilder: NutritionAssessment.create)
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
  $pb.PbList<NutritionAssessment> get assessments => $_getList(0);
}

class OpenCarePlanRequest extends $pb.GeneratedMessage {
  factory OpenCarePlanRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? assessmentId,
    $core.Iterable<NutritionGoal>? goals,
    $core.String? plan,
    $0.Timestamp? reviewDue,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (assessmentId != null) result.assessmentId = assessmentId;
    if (goals != null) result.goals.addAll(goals);
    if (plan != null) result.plan = plan;
    if (reviewDue != null) result.reviewDue = reviewDue;
    return result;
  }

  OpenCarePlanRequest._();

  factory OpenCarePlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenCarePlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenCarePlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'assessmentId')
    ..pPM<NutritionGoal>(4, _omitFieldNames ? '' : 'goals',
        subBuilder: NutritionGoal.create)
    ..aOS(5, _omitFieldNames ? '' : 'plan')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'reviewDue',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenCarePlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenCarePlanRequest copyWith(void Function(OpenCarePlanRequest) updates) =>
      super.copyWith((message) => updates(message as OpenCarePlanRequest))
          as OpenCarePlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenCarePlanRequest create() => OpenCarePlanRequest._();
  @$core.override
  OpenCarePlanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenCarePlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenCarePlanRequest>(create);
  static OpenCarePlanRequest? _defaultInstance;

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
  $core.String get assessmentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assessmentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssessmentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssessmentId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<NutritionGoal> get goals => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get plan => $_getSZ(4);
  @$pb.TagNumber(5)
  set plan($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPlan() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlan() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get reviewDue => $_getN(5);
  @$pb.TagNumber(6)
  set reviewDue($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasReviewDue() => $_has(5);
  @$pb.TagNumber(6)
  void clearReviewDue() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureReviewDue() => $_ensure(5);
}

class OpenCarePlanResponse extends $pb.GeneratedMessage {
  factory OpenCarePlanResponse({
    CarePlan? plan,
  }) {
    final result = create();
    if (plan != null) result.plan = plan;
    return result;
  }

  OpenCarePlanResponse._();

  factory OpenCarePlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenCarePlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenCarePlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<CarePlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: CarePlan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenCarePlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenCarePlanResponse copyWith(void Function(OpenCarePlanResponse) updates) =>
      super.copyWith((message) => updates(message as OpenCarePlanResponse))
          as OpenCarePlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenCarePlanResponse create() => OpenCarePlanResponse._();
  @$core.override
  OpenCarePlanResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenCarePlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenCarePlanResponse>(create);
  static OpenCarePlanResponse? _defaultInstance;

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

class RecordProgressRequest extends $pb.GeneratedMessage {
  factory RecordProgressRequest({
    $core.String? planId,
    $core.String? goalCode,
    $core.int? value,
    $core.String? note,
    $0.Timestamp? measuredAt,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    if (goalCode != null) result.goalCode = goalCode;
    if (value != null) result.value = value;
    if (note != null) result.note = note;
    if (measuredAt != null) result.measuredAt = measuredAt;
    return result;
  }

  RecordProgressRequest._();

  factory RecordProgressRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordProgressRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordProgressRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'planId')
    ..aOS(2, _omitFieldNames ? '' : 'goalCode')
    ..aI(3, _omitFieldNames ? '' : 'value')
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'measuredAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordProgressRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordProgressRequest copyWith(
          void Function(RecordProgressRequest) updates) =>
      super.copyWith((message) => updates(message as RecordProgressRequest))
          as RecordProgressRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordProgressRequest create() => RecordProgressRequest._();
  @$core.override
  RecordProgressRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordProgressRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordProgressRequest>(create);
  static RecordProgressRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get planId => $_getSZ(0);
  @$pb.TagNumber(1)
  set planId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get goalCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set goalCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGoalCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearGoalCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get value => $_getIZ(2);
  @$pb.TagNumber(3)
  set value($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearValue() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get measuredAt => $_getN(4);
  @$pb.TagNumber(5)
  set measuredAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMeasuredAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearMeasuredAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureMeasuredAt() => $_ensure(4);
}

class RecordProgressResponse extends $pb.GeneratedMessage {
  factory RecordProgressResponse({
    Progress? progress,
  }) {
    final result = create();
    if (progress != null) result.progress = progress;
    return result;
  }

  RecordProgressResponse._();

  factory RecordProgressResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordProgressResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordProgressResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<Progress>(1, _omitFieldNames ? '' : 'progress',
        subBuilder: Progress.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordProgressResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordProgressResponse copyWith(
          void Function(RecordProgressResponse) updates) =>
      super.copyWith((message) => updates(message as RecordProgressResponse))
          as RecordProgressResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordProgressResponse create() => RecordProgressResponse._();
  @$core.override
  RecordProgressResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordProgressResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordProgressResponse>(create);
  static RecordProgressResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Progress get progress => $_getN(0);
  @$pb.TagNumber(1)
  set progress(Progress value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProgress() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgress() => $_clearField(1);
  @$pb.TagNumber(1)
  Progress ensureProgress() => $_ensure(0);
}

class CloseCarePlanRequest extends $pb.GeneratedMessage {
  factory CloseCarePlanRequest({
    $core.String? planId,
    $core.String? note,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    if (note != null) result.note = note;
    return result;
  }

  CloseCarePlanRequest._();

  factory CloseCarePlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseCarePlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseCarePlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'planId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseCarePlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseCarePlanRequest copyWith(void Function(CloseCarePlanRequest) updates) =>
      super.copyWith((message) => updates(message as CloseCarePlanRequest))
          as CloseCarePlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseCarePlanRequest create() => CloseCarePlanRequest._();
  @$core.override
  CloseCarePlanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseCarePlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseCarePlanRequest>(create);
  static CloseCarePlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get planId => $_getSZ(0);
  @$pb.TagNumber(1)
  set planId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);
}

class CloseCarePlanResponse extends $pb.GeneratedMessage {
  factory CloseCarePlanResponse({
    CarePlan? plan,
  }) {
    final result = create();
    if (plan != null) result.plan = plan;
    return result;
  }

  CloseCarePlanResponse._();

  factory CloseCarePlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseCarePlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseCarePlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<CarePlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: CarePlan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseCarePlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseCarePlanResponse copyWith(
          void Function(CloseCarePlanResponse) updates) =>
      super.copyWith((message) => updates(message as CloseCarePlanResponse))
          as CloseCarePlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseCarePlanResponse create() => CloseCarePlanResponse._();
  @$core.override
  CloseCarePlanResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseCarePlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseCarePlanResponse>(create);
  static CloseCarePlanResponse? _defaultInstance;

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
    $core.String? patientId,
    $core.bool? openOnly,
    $core.int? pageSize,
    $core.int? pageOffset,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (openOnly != null) result.openOnly = openOnly;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageOffset != null) result.pageOffset = pageOffset;
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
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOB(2, _omitFieldNames ? '' : 'openOnly')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..aI(4, _omitFieldNames ? '' : 'pageOffset')
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

  @$pb.TagNumber(4)
  $core.int get pageOffset => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageOffset($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageOffset() => $_clearField(4);
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
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
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

class GetGoalTrendRequest extends $pb.GeneratedMessage {
  factory GetGoalTrendRequest({
    $core.String? planId,
    $core.String? goalCode,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    if (goalCode != null) result.goalCode = goalCode;
    return result;
  }

  GetGoalTrendRequest._();

  factory GetGoalTrendRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetGoalTrendRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetGoalTrendRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'planId')
    ..aOS(2, _omitFieldNames ? '' : 'goalCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetGoalTrendRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetGoalTrendRequest copyWith(void Function(GetGoalTrendRequest) updates) =>
      super.copyWith((message) => updates(message as GetGoalTrendRequest))
          as GetGoalTrendRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetGoalTrendRequest create() => GetGoalTrendRequest._();
  @$core.override
  GetGoalTrendRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetGoalTrendRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetGoalTrendRequest>(create);
  static GetGoalTrendRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get planId => $_getSZ(0);
  @$pb.TagNumber(1)
  set planId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get goalCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set goalCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGoalCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearGoalCode() => $_clearField(2);
}

class GetGoalTrendResponse extends $pb.GeneratedMessage {
  factory GetGoalTrendResponse({
    Trend? trend,
  }) {
    final result = create();
    if (trend != null) result.trend = trend;
    return result;
  }

  GetGoalTrendResponse._();

  factory GetGoalTrendResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetGoalTrendResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetGoalTrendResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<Trend>(1, _omitFieldNames ? '' : 'trend', subBuilder: Trend.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetGoalTrendResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetGoalTrendResponse copyWith(void Function(GetGoalTrendResponse) updates) =>
      super.copyWith((message) => updates(message as GetGoalTrendResponse))
          as GetGoalTrendResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetGoalTrendResponse create() => GetGoalTrendResponse._();
  @$core.override
  GetGoalTrendResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetGoalTrendResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetGoalTrendResponse>(create);
  static GetGoalTrendResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Trend get trend => $_getN(0);
  @$pb.TagNumber(1)
  set trend(Trend value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrend() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrend() => $_clearField(1);
  @$pb.TagNumber(1)
  Trend ensureTrend() => $_ensure(0);
}

class PlaceDietOrderRequest extends $pb.GeneratedMessage {
  factory PlaceDietOrderRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    $core.String? wardId,
    $core.String? bedId,
    Route? route,
    Texture? texture,
    $core.Iterable<$core.String>? restrictions,
    $core.Iterable<$core.String>? supplements,
    $core.String? instruction,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? effectiveTo,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (wardId != null) result.wardId = wardId;
    if (bedId != null) result.bedId = bedId;
    if (route != null) result.route = route;
    if (texture != null) result.texture = texture;
    if (restrictions != null) result.restrictions.addAll(restrictions);
    if (supplements != null) result.supplements.addAll(supplements);
    if (instruction != null) result.instruction = instruction;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (effectiveTo != null) result.effectiveTo = effectiveTo;
    return result;
  }

  PlaceDietOrderRequest._();

  factory PlaceDietOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaceDietOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaceDietOrderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'wardId')
    ..aOS(5, _omitFieldNames ? '' : 'bedId')
    ..aE<Route>(6, _omitFieldNames ? '' : 'route', enumValues: Route.values)
    ..aOM<Texture>(7, _omitFieldNames ? '' : 'texture',
        subBuilder: Texture.create)
    ..pPS(8, _omitFieldNames ? '' : 'restrictions')
    ..pPS(9, _omitFieldNames ? '' : 'supplements')
    ..aOS(10, _omitFieldNames ? '' : 'instruction')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'effectiveTo',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceDietOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceDietOrderRequest copyWith(
          void Function(PlaceDietOrderRequest) updates) =>
      super.copyWith((message) => updates(message as PlaceDietOrderRequest))
          as PlaceDietOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaceDietOrderRequest create() => PlaceDietOrderRequest._();
  @$core.override
  PlaceDietOrderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaceDietOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaceDietOrderRequest>(create);
  static PlaceDietOrderRequest? _defaultInstance;

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
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get wardId => $_getSZ(3);
  @$pb.TagNumber(4)
  set wardId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWardId() => $_has(3);
  @$pb.TagNumber(4)
  void clearWardId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get bedId => $_getSZ(4);
  @$pb.TagNumber(5)
  set bedId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBedId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBedId() => $_clearField(5);

  @$pb.TagNumber(6)
  Route get route => $_getN(5);
  @$pb.TagNumber(6)
  set route(Route value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRoute() => $_has(5);
  @$pb.TagNumber(6)
  void clearRoute() => $_clearField(6);

  @$pb.TagNumber(7)
  Texture get texture => $_getN(6);
  @$pb.TagNumber(7)
  set texture(Texture value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTexture() => $_has(6);
  @$pb.TagNumber(7)
  void clearTexture() => $_clearField(7);
  @$pb.TagNumber(7)
  Texture ensureTexture() => $_ensure(6);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get restrictions => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get supplements => $_getList(8);

  @$pb.TagNumber(10)
  $core.String get instruction => $_getSZ(9);
  @$pb.TagNumber(10)
  set instruction($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasInstruction() => $_has(9);
  @$pb.TagNumber(10)
  void clearInstruction() => $_clearField(10);

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
  $0.Timestamp get effectiveTo => $_getN(11);
  @$pb.TagNumber(12)
  set effectiveTo($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasEffectiveTo() => $_has(11);
  @$pb.TagNumber(12)
  void clearEffectiveTo() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureEffectiveTo() => $_ensure(11);
}

class PlaceDietOrderResponse extends $pb.GeneratedMessage {
  factory PlaceDietOrderResponse({
    DietOrder? order,
  }) {
    final result = create();
    if (order != null) result.order = order;
    return result;
  }

  PlaceDietOrderResponse._();

  factory PlaceDietOrderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaceDietOrderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaceDietOrderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<DietOrder>(1, _omitFieldNames ? '' : 'order',
        subBuilder: DietOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceDietOrderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceDietOrderResponse copyWith(
          void Function(PlaceDietOrderResponse) updates) =>
      super.copyWith((message) => updates(message as PlaceDietOrderResponse))
          as PlaceDietOrderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaceDietOrderResponse create() => PlaceDietOrderResponse._();
  @$core.override
  PlaceDietOrderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaceDietOrderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaceDietOrderResponse>(create);
  static PlaceDietOrderResponse? _defaultInstance;

  /// Pending when the order clashes with a documented allergy. The kitchen
  /// never sees a pending order.
  @$pb.TagNumber(1)
  DietOrder get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(DietOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  DietOrder ensureOrder() => $_ensure(0);
}

class ResolveConflictRequest extends $pb.GeneratedMessage {
  factory ResolveConflictRequest({
    $core.String? orderId,
    $core.String? allergyRef,
    $core.String? item,
    $core.String? note,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (allergyRef != null) result.allergyRef = allergyRef;
    if (item != null) result.item = item;
    if (note != null) result.note = note;
    return result;
  }

  ResolveConflictRequest._();

  factory ResolveConflictRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveConflictRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveConflictRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aOS(2, _omitFieldNames ? '' : 'allergyRef')
    ..aOS(3, _omitFieldNames ? '' : 'item')
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveConflictRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveConflictRequest copyWith(
          void Function(ResolveConflictRequest) updates) =>
      super.copyWith((message) => updates(message as ResolveConflictRequest))
          as ResolveConflictRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveConflictRequest create() => ResolveConflictRequest._();
  @$core.override
  ResolveConflictRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveConflictRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveConflictRequest>(create);
  static ResolveConflictRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get allergyRef => $_getSZ(1);
  @$pb.TagNumber(2)
  set allergyRef($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAllergyRef() => $_has(1);
  @$pb.TagNumber(2)
  void clearAllergyRef() => $_clearField(2);

  /// Empty resolves every open conflict on that allergy.
  @$pb.TagNumber(3)
  $core.String get item => $_getSZ(2);
  @$pb.TagNumber(3)
  set item($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasItem() => $_has(2);
  @$pb.TagNumber(3)
  void clearItem() => $_clearField(3);

  /// Why this item is safe for this patient. "Resolved by Dr Rao" is not an
  /// answer, and this is what an investigation reads.
  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);
}

class ResolveConflictResponse extends $pb.GeneratedMessage {
  factory ResolveConflictResponse({
    DietOrder? order,
  }) {
    final result = create();
    if (order != null) result.order = order;
    return result;
  }

  ResolveConflictResponse._();

  factory ResolveConflictResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveConflictResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveConflictResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<DietOrder>(1, _omitFieldNames ? '' : 'order',
        subBuilder: DietOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveConflictResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveConflictResponse copyWith(
          void Function(ResolveConflictResponse) updates) =>
      super.copyWith((message) => updates(message as ResolveConflictResponse))
          as ResolveConflictResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveConflictResponse create() => ResolveConflictResponse._();
  @$core.override
  ResolveConflictResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveConflictResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveConflictResponse>(create);
  static ResolveConflictResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DietOrder get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(DietOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  DietOrder ensureOrder() => $_ensure(0);
}

class CancelDietOrderRequest extends $pb.GeneratedMessage {
  factory CancelDietOrderRequest({
    $core.String? orderId,
    $core.String? reason,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (reason != null) result.reason = reason;
    return result;
  }

  CancelDietOrderRequest._();

  factory CancelDietOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelDietOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelDietOrderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelDietOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelDietOrderRequest copyWith(
          void Function(CancelDietOrderRequest) updates) =>
      super.copyWith((message) => updates(message as CancelDietOrderRequest))
          as CancelDietOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelDietOrderRequest create() => CancelDietOrderRequest._();
  @$core.override
  CancelDietOrderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelDietOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelDietOrderRequest>(create);
  static CancelDietOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class CancelDietOrderResponse extends $pb.GeneratedMessage {
  factory CancelDietOrderResponse({
    DietOrder? order,
  }) {
    final result = create();
    if (order != null) result.order = order;
    return result;
  }

  CancelDietOrderResponse._();

  factory CancelDietOrderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelDietOrderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelDietOrderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<DietOrder>(1, _omitFieldNames ? '' : 'order',
        subBuilder: DietOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelDietOrderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelDietOrderResponse copyWith(
          void Function(CancelDietOrderResponse) updates) =>
      super.copyWith((message) => updates(message as CancelDietOrderResponse))
          as CancelDietOrderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelDietOrderResponse create() => CancelDietOrderResponse._();
  @$core.override
  CancelDietOrderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelDietOrderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelDietOrderResponse>(create);
  static CancelDietOrderResponse? _defaultInstance;

  /// The order stops now, not at whatever time it was going to run to: a
  /// cancellation that leaves it in force until midnight sends supper.
  @$pb.TagNumber(1)
  DietOrder get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(DietOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  DietOrder ensureOrder() => $_ensure(0);
}

class GetCurrentDietOrderRequest extends $pb.GeneratedMessage {
  factory GetCurrentDietOrderRequest({
    $core.String? patientId,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    return result;
  }

  GetCurrentDietOrderRequest._();

  factory GetCurrentDietOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCurrentDietOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCurrentDietOrderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentDietOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentDietOrderRequest copyWith(
          void Function(GetCurrentDietOrderRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetCurrentDietOrderRequest))
          as GetCurrentDietOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCurrentDietOrderRequest create() => GetCurrentDietOrderRequest._();
  @$core.override
  GetCurrentDietOrderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCurrentDietOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCurrentDietOrderRequest>(create);
  static GetCurrentDietOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);
}

class GetCurrentDietOrderResponse extends $pb.GeneratedMessage {
  factory GetCurrentDietOrderResponse({
    DietOrder? order,
    $core.bool? found,
  }) {
    final result = create();
    if (order != null) result.order = order;
    if (found != null) result.found = found;
    return result;
  }

  GetCurrentDietOrderResponse._();

  factory GetCurrentDietOrderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCurrentDietOrderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCurrentDietOrderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<DietOrder>(1, _omitFieldNames ? '' : 'order',
        subBuilder: DietOrder.create)
    ..aOB(2, _omitFieldNames ? '' : 'found')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentDietOrderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentDietOrderResponse copyWith(
          void Function(GetCurrentDietOrderResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetCurrentDietOrderResponse))
          as GetCurrentDietOrderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCurrentDietOrderResponse create() =>
      GetCurrentDietOrderResponse._();
  @$core.override
  GetCurrentDietOrderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCurrentDietOrderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCurrentDietOrderResponse>(create);
  static GetCurrentDietOrderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DietOrder get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(DietOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  DietOrder ensureOrder() => $_ensure(0);

  /// False when nothing is in force, which is not the same as an empty order.
  @$pb.TagNumber(2)
  $core.bool get found => $_getBF(1);
  @$pb.TagNumber(2)
  set found($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFound() => $_has(1);
  @$pb.TagNumber(2)
  void clearFound() => $_clearField(2);
}

class ListDietOrdersRequest extends $pb.GeneratedMessage {
  factory ListDietOrdersRequest({
    $core.String? patientId,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    return result;
  }

  ListDietOrdersRequest._();

  factory ListDietOrdersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDietOrdersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDietOrdersRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDietOrdersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDietOrdersRequest copyWith(
          void Function(ListDietOrdersRequest) updates) =>
      super.copyWith((message) => updates(message as ListDietOrdersRequest))
          as ListDietOrdersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDietOrdersRequest create() => ListDietOrdersRequest._();
  @$core.override
  ListDietOrdersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDietOrdersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDietOrdersRequest>(create);
  static ListDietOrdersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);
}

class ListDietOrdersResponse extends $pb.GeneratedMessage {
  factory ListDietOrdersResponse({
    $core.Iterable<DietOrder>? orders,
  }) {
    final result = create();
    if (orders != null) result.orders.addAll(orders);
    return result;
  }

  ListDietOrdersResponse._();

  factory ListDietOrdersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDietOrdersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDietOrdersResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..pPM<DietOrder>(1, _omitFieldNames ? '' : 'orders',
        subBuilder: DietOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDietOrdersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDietOrdersResponse copyWith(
          void Function(ListDietOrdersResponse) updates) =>
      super.copyWith((message) => updates(message as ListDietOrdersResponse))
          as ListDietOrdersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDietOrdersResponse create() => ListDietOrdersResponse._();
  @$core.override
  ListDietOrdersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDietOrdersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDietOrdersResponse>(create);
  static ListDietOrdersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DietOrder> get orders => $_getList(0);
}

class PlanNutritionSupportRequest extends $pb.GeneratedMessage {
  factory PlanNutritionSupportRequest({
    $core.String? patientId,
    $core.String? encounterId,
    SupportKind? kind,
    $core.String? formulaCode,
    $core.String? formulaName,
    $core.int? targetVolumeMl,
    $core.int? targetEnergyKcal,
    $core.int? targetProteinG,
    $core.String? rampPlan,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (kind != null) result.kind = kind;
    if (formulaCode != null) result.formulaCode = formulaCode;
    if (formulaName != null) result.formulaName = formulaName;
    if (targetVolumeMl != null) result.targetVolumeMl = targetVolumeMl;
    if (targetEnergyKcal != null) result.targetEnergyKcal = targetEnergyKcal;
    if (targetProteinG != null) result.targetProteinG = targetProteinG;
    if (rampPlan != null) result.rampPlan = rampPlan;
    return result;
  }

  PlanNutritionSupportRequest._();

  factory PlanNutritionSupportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlanNutritionSupportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlanNutritionSupportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aE<SupportKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: SupportKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'formulaCode')
    ..aOS(5, _omitFieldNames ? '' : 'formulaName')
    ..aI(6, _omitFieldNames ? '' : 'targetVolumeMl')
    ..aI(7, _omitFieldNames ? '' : 'targetEnergyKcal')
    ..aI(8, _omitFieldNames ? '' : 'targetProteinG')
    ..aOS(9, _omitFieldNames ? '' : 'rampPlan')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanNutritionSupportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanNutritionSupportRequest copyWith(
          void Function(PlanNutritionSupportRequest) updates) =>
      super.copyWith(
              (message) => updates(message as PlanNutritionSupportRequest))
          as PlanNutritionSupportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlanNutritionSupportRequest create() =>
      PlanNutritionSupportRequest._();
  @$core.override
  PlanNutritionSupportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlanNutritionSupportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlanNutritionSupportRequest>(create);
  static PlanNutritionSupportRequest? _defaultInstance;

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
  SupportKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(SupportKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get formulaCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set formulaCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFormulaCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearFormulaCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get formulaName => $_getSZ(4);
  @$pb.TagNumber(5)
  set formulaName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFormulaName() => $_has(4);
  @$pb.TagNumber(5)
  void clearFormulaName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get targetVolumeMl => $_getIZ(5);
  @$pb.TagNumber(6)
  set targetVolumeMl($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTargetVolumeMl() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetVolumeMl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get targetEnergyKcal => $_getIZ(6);
  @$pb.TagNumber(7)
  set targetEnergyKcal($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTargetEnergyKcal() => $_has(6);
  @$pb.TagNumber(7)
  void clearTargetEnergyKcal() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get targetProteinG => $_getIZ(7);
  @$pb.TagNumber(8)
  set targetProteinG($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTargetProteinG() => $_has(7);
  @$pb.TagNumber(8)
  void clearTargetProteinG() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get rampPlan => $_getSZ(8);
  @$pb.TagNumber(9)
  set rampPlan($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRampPlan() => $_has(8);
  @$pb.TagNumber(9)
  void clearRampPlan() => $_clearField(9);
}

class PlanNutritionSupportResponse extends $pb.GeneratedMessage {
  factory PlanNutritionSupportResponse({
    NutritionSupportPlan? plan,
  }) {
    final result = create();
    if (plan != null) result.plan = plan;
    return result;
  }

  PlanNutritionSupportResponse._();

  factory PlanNutritionSupportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlanNutritionSupportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlanNutritionSupportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<NutritionSupportPlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: NutritionSupportPlan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanNutritionSupportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanNutritionSupportResponse copyWith(
          void Function(PlanNutritionSupportResponse) updates) =>
      super.copyWith(
              (message) => updates(message as PlanNutritionSupportResponse))
          as PlanNutritionSupportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlanNutritionSupportResponse create() =>
      PlanNutritionSupportResponse._();
  @$core.override
  PlanNutritionSupportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlanNutritionSupportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlanNutritionSupportResponse>(create);
  static PlanNutritionSupportResponse? _defaultInstance;

  /// Planned, never active. Nothing is running until an order exists.
  @$pb.TagNumber(1)
  NutritionSupportPlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(NutritionSupportPlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  NutritionSupportPlan ensurePlan() => $_ensure(0);
}

class LinkSupportOrderRequest extends $pb.GeneratedMessage {
  factory LinkSupportOrderRequest({
    $core.String? planId,
    $core.String? orderRef,
    $core.String? orderContext,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    if (orderRef != null) result.orderRef = orderRef;
    if (orderContext != null) result.orderContext = orderContext;
    return result;
  }

  LinkSupportOrderRequest._();

  factory LinkSupportOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LinkSupportOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkSupportOrderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'planId')
    ..aOS(2, _omitFieldNames ? '' : 'orderRef')
    ..aOS(3, _omitFieldNames ? '' : 'orderContext')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkSupportOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkSupportOrderRequest copyWith(
          void Function(LinkSupportOrderRequest) updates) =>
      super.copyWith((message) => updates(message as LinkSupportOrderRequest))
          as LinkSupportOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LinkSupportOrderRequest create() => LinkSupportOrderRequest._();
  @$core.override
  LinkSupportOrderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LinkSupportOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkSupportOrderRequest>(create);
  static LinkSupportOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get planId => $_getSZ(0);
  @$pb.TagNumber(1)
  set planId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanId() => $_clearField(1);

  /// The order or prescription carrying the plan out. Resolved in the context
  /// that owns it before the plan goes active.
  @$pb.TagNumber(2)
  $core.String get orderRef => $_getSZ(1);
  @$pb.TagNumber(2)
  set orderRef($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrderRef() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderRef() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get orderContext => $_getSZ(2);
  @$pb.TagNumber(3)
  set orderContext($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrderContext() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderContext() => $_clearField(3);
}

class LinkSupportOrderResponse extends $pb.GeneratedMessage {
  factory LinkSupportOrderResponse({
    NutritionSupportPlan? plan,
  }) {
    final result = create();
    if (plan != null) result.plan = plan;
    return result;
  }

  LinkSupportOrderResponse._();

  factory LinkSupportOrderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LinkSupportOrderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkSupportOrderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<NutritionSupportPlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: NutritionSupportPlan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkSupportOrderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkSupportOrderResponse copyWith(
          void Function(LinkSupportOrderResponse) updates) =>
      super.copyWith((message) => updates(message as LinkSupportOrderResponse))
          as LinkSupportOrderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LinkSupportOrderResponse create() => LinkSupportOrderResponse._();
  @$core.override
  LinkSupportOrderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LinkSupportOrderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkSupportOrderResponse>(create);
  static LinkSupportOrderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  NutritionSupportPlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(NutritionSupportPlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  NutritionSupportPlan ensurePlan() => $_ensure(0);
}

class StopSupportRequest extends $pb.GeneratedMessage {
  factory StopSupportRequest({
    $core.String? planId,
    $core.String? reason,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    if (reason != null) result.reason = reason;
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
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'planId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
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
  $core.String get planId => $_getSZ(0);
  @$pb.TagNumber(1)
  set planId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class StopSupportResponse extends $pb.GeneratedMessage {
  factory StopSupportResponse({
    NutritionSupportPlan? plan,
  }) {
    final result = create();
    if (plan != null) result.plan = plan;
    return result;
  }

  StopSupportResponse._();

  factory StopSupportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopSupportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopSupportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<NutritionSupportPlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: NutritionSupportPlan.create)
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

  /// Stopping the plan does not stop the feed: the order does that, in the
  /// context that owns it.
  @$pb.TagNumber(1)
  NutritionSupportPlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(NutritionSupportPlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  NutritionSupportPlan ensurePlan() => $_ensure(0);
}

class ListSupportPlansRequest extends $pb.GeneratedMessage {
  factory ListSupportPlansRequest({
    $core.String? patientId,
    $core.bool? activeOnly,
    $core.int? pageSize,
    $core.int? pageOffset,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (activeOnly != null) result.activeOnly = activeOnly;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageOffset != null) result.pageOffset = pageOffset;
    return result;
  }

  ListSupportPlansRequest._();

  factory ListSupportPlansRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSupportPlansRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSupportPlansRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOB(2, _omitFieldNames ? '' : 'activeOnly')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..aI(4, _omitFieldNames ? '' : 'pageOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSupportPlansRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSupportPlansRequest copyWith(
          void Function(ListSupportPlansRequest) updates) =>
      super.copyWith((message) => updates(message as ListSupportPlansRequest))
          as ListSupportPlansRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSupportPlansRequest create() => ListSupportPlansRequest._();
  @$core.override
  ListSupportPlansRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSupportPlansRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSupportPlansRequest>(create);
  static ListSupportPlansRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

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

  @$pb.TagNumber(4)
  $core.int get pageOffset => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageOffset($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageOffset() => $_clearField(4);
}

class ListSupportPlansResponse extends $pb.GeneratedMessage {
  factory ListSupportPlansResponse({
    $core.Iterable<NutritionSupportPlan>? plans,
  }) {
    final result = create();
    if (plans != null) result.plans.addAll(plans);
    return result;
  }

  ListSupportPlansResponse._();

  factory ListSupportPlansResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSupportPlansResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSupportPlansResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..pPM<NutritionSupportPlan>(1, _omitFieldNames ? '' : 'plans',
        subBuilder: NutritionSupportPlan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSupportPlansResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSupportPlansResponse copyWith(
          void Function(ListSupportPlansResponse) updates) =>
      super.copyWith((message) => updates(message as ListSupportPlansResponse))
          as ListSupportPlansResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSupportPlansResponse create() => ListSupportPlansResponse._();
  @$core.override
  ListSupportPlansResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSupportPlansResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSupportPlansResponse>(create);
  static ListSupportPlansResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<NutritionSupportPlan> get plans => $_getList(0);
}

class BuildCensusRequest extends $pb.GeneratedMessage {
  factory BuildCensusRequest({
    $core.String? wardId,
    $core.String? facilityId,
    MealCycle? cycle,
    $0.Timestamp? serviceDate,
    $0.Timestamp? cutoffAt,
  }) {
    final result = create();
    if (wardId != null) result.wardId = wardId;
    if (facilityId != null) result.facilityId = facilityId;
    if (cycle != null) result.cycle = cycle;
    if (serviceDate != null) result.serviceDate = serviceDate;
    if (cutoffAt != null) result.cutoffAt = cutoffAt;
    return result;
  }

  BuildCensusRequest._();

  factory BuildCensusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BuildCensusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BuildCensusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'wardId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aE<MealCycle>(3, _omitFieldNames ? '' : 'cycle',
        enumValues: MealCycle.values)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'serviceDate',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'cutoffAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BuildCensusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BuildCensusRequest copyWith(void Function(BuildCensusRequest) updates) =>
      super.copyWith((message) => updates(message as BuildCensusRequest))
          as BuildCensusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BuildCensusRequest create() => BuildCensusRequest._();
  @$core.override
  BuildCensusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BuildCensusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BuildCensusRequest>(create);
  static BuildCensusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get wardId => $_getSZ(0);
  @$pb.TagNumber(1)
  set wardId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWardId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWardId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  MealCycle get cycle => $_getN(2);
  @$pb.TagNumber(3)
  set cycle(MealCycle value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCycle() => $_has(2);
  @$pb.TagNumber(3)
  void clearCycle() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get serviceDate => $_getN(3);
  @$pb.TagNumber(4)
  set serviceDate($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasServiceDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearServiceDate() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureServiceDate() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get cutoffAt => $_getN(4);
  @$pb.TagNumber(5)
  set cutoffAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCutoffAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCutoffAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureCutoffAt() => $_ensure(4);
}

class BuildCensusResponse extends $pb.GeneratedMessage {
  factory BuildCensusResponse({
    MealCensus? census,
  }) {
    final result = create();
    if (census != null) result.census = census;
    return result;
  }

  BuildCensusResponse._();

  factory BuildCensusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BuildCensusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BuildCensusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<MealCensus>(1, _omitFieldNames ? '' : 'census',
        subBuilder: MealCensus.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BuildCensusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BuildCensusResponse copyWith(void Function(BuildCensusResponse) updates) =>
      super.copyWith((message) => updates(message as BuildCensusResponse))
          as BuildCensusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BuildCensusResponse create() => BuildCensusResponse._();
  @$core.override
  BuildCensusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BuildCensusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BuildCensusResponse>(create);
  static BuildCensusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MealCensus get census => $_getN(0);
  @$pb.TagNumber(1)
  set census(MealCensus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCensus() => $_has(0);
  @$pb.TagNumber(1)
  void clearCensus() => $_clearField(1);
  @$pb.TagNumber(1)
  MealCensus ensureCensus() => $_ensure(0);
}

class FreezeCensusRequest extends $pb.GeneratedMessage {
  factory FreezeCensusRequest({
    $core.String? censusId,
  }) {
    final result = create();
    if (censusId != null) result.censusId = censusId;
    return result;
  }

  FreezeCensusRequest._();

  factory FreezeCensusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FreezeCensusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FreezeCensusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'censusId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FreezeCensusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FreezeCensusRequest copyWith(void Function(FreezeCensusRequest) updates) =>
      super.copyWith((message) => updates(message as FreezeCensusRequest))
          as FreezeCensusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FreezeCensusRequest create() => FreezeCensusRequest._();
  @$core.override
  FreezeCensusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FreezeCensusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FreezeCensusRequest>(create);
  static FreezeCensusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get censusId => $_getSZ(0);
  @$pb.TagNumber(1)
  set censusId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCensusId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCensusId() => $_clearField(1);
}

class FreezeCensusResponse extends $pb.GeneratedMessage {
  factory FreezeCensusResponse({
    MealCensus? census,
  }) {
    final result = create();
    if (census != null) result.census = census;
    return result;
  }

  FreezeCensusResponse._();

  factory FreezeCensusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FreezeCensusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FreezeCensusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<MealCensus>(1, _omitFieldNames ? '' : 'census',
        subBuilder: MealCensus.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FreezeCensusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FreezeCensusResponse copyWith(void Function(FreezeCensusResponse) updates) =>
      super.copyWith((message) => updates(message as FreezeCensusResponse))
          as FreezeCensusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FreezeCensusResponse create() => FreezeCensusResponse._();
  @$core.override
  FreezeCensusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FreezeCensusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FreezeCensusResponse>(create);
  static FreezeCensusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MealCensus get census => $_getN(0);
  @$pb.TagNumber(1)
  set census(MealCensus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCensus() => $_has(0);
  @$pb.TagNumber(1)
  void clearCensus() => $_clearField(1);
  @$pb.TagNumber(1)
  MealCensus ensureCensus() => $_ensure(0);
}

class ReissueCensusRequest extends $pb.GeneratedMessage {
  factory ReissueCensusRequest({
    $core.String? censusId,
  }) {
    final result = create();
    if (censusId != null) result.censusId = censusId;
    return result;
  }

  ReissueCensusRequest._();

  factory ReissueCensusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReissueCensusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReissueCensusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'censusId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReissueCensusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReissueCensusRequest copyWith(void Function(ReissueCensusRequest) updates) =>
      super.copyWith((message) => updates(message as ReissueCensusRequest))
          as ReissueCensusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReissueCensusRequest create() => ReissueCensusRequest._();
  @$core.override
  ReissueCensusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReissueCensusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReissueCensusRequest>(create);
  static ReissueCensusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get censusId => $_getSZ(0);
  @$pb.TagNumber(1)
  set censusId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCensusId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCensusId() => $_clearField(1);
}

class ReissueCensusResponse extends $pb.GeneratedMessage {
  factory ReissueCensusResponse({
    MealCensus? census,
  }) {
    final result = create();
    if (census != null) result.census = census;
    return result;
  }

  ReissueCensusResponse._();

  factory ReissueCensusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReissueCensusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReissueCensusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<MealCensus>(1, _omitFieldNames ? '' : 'census',
        subBuilder: MealCensus.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReissueCensusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReissueCensusResponse copyWith(
          void Function(ReissueCensusResponse) updates) =>
      super.copyWith((message) => updates(message as ReissueCensusResponse))
          as ReissueCensusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReissueCensusResponse create() => ReissueCensusResponse._();
  @$core.override
  ReissueCensusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReissueCensusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReissueCensusResponse>(create);
  static ReissueCensusResponse? _defaultInstance;

  /// A new version. The frozen one stays readable: it is what the kitchen
  /// cooked to.
  @$pb.TagNumber(1)
  MealCensus get census => $_getN(0);
  @$pb.TagNumber(1)
  set census(MealCensus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCensus() => $_has(0);
  @$pb.TagNumber(1)
  void clearCensus() => $_clearField(1);
  @$pb.TagNumber(1)
  MealCensus ensureCensus() => $_ensure(0);
}

class ListCensusesRequest extends $pb.GeneratedMessage {
  factory ListCensusesRequest({
    $core.String? wardId,
    MealCycle? cycle,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
    $core.int? pageOffset,
  }) {
    final result = create();
    if (wardId != null) result.wardId = wardId;
    if (cycle != null) result.cycle = cycle;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageOffset != null) result.pageOffset = pageOffset;
    return result;
  }

  ListCensusesRequest._();

  factory ListCensusesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCensusesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCensusesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'wardId')
    ..aE<MealCycle>(2, _omitFieldNames ? '' : 'cycle',
        enumValues: MealCycle.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..aI(6, _omitFieldNames ? '' : 'pageOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCensusesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCensusesRequest copyWith(void Function(ListCensusesRequest) updates) =>
      super.copyWith((message) => updates(message as ListCensusesRequest))
          as ListCensusesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCensusesRequest create() => ListCensusesRequest._();
  @$core.override
  ListCensusesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCensusesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCensusesRequest>(create);
  static ListCensusesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get wardId => $_getSZ(0);
  @$pb.TagNumber(1)
  set wardId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWardId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWardId() => $_clearField(1);

  @$pb.TagNumber(2)
  MealCycle get cycle => $_getN(1);
  @$pb.TagNumber(2)
  set cycle(MealCycle value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCycle() => $_has(1);
  @$pb.TagNumber(2)
  void clearCycle() => $_clearField(2);

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

class ListCensusesResponse extends $pb.GeneratedMessage {
  factory ListCensusesResponse({
    $core.Iterable<MealCensus>? censuses,
  }) {
    final result = create();
    if (censuses != null) result.censuses.addAll(censuses);
    return result;
  }

  ListCensusesResponse._();

  factory ListCensusesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCensusesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCensusesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..pPM<MealCensus>(1, _omitFieldNames ? '' : 'censuses',
        subBuilder: MealCensus.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCensusesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCensusesResponse copyWith(void Function(ListCensusesResponse) updates) =>
      super.copyWith((message) => updates(message as ListCensusesResponse))
          as ListCensusesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCensusesResponse create() => ListCensusesResponse._();
  @$core.override
  ListCensusesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCensusesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCensusesResponse>(create);
  static ListCensusesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MealCensus> get censuses => $_getList(0);
}

class PlateTraysRequest extends $pb.GeneratedMessage {
  factory PlateTraysRequest({
    $core.String? censusId,
  }) {
    final result = create();
    if (censusId != null) result.censusId = censusId;
    return result;
  }

  PlateTraysRequest._();

  factory PlateTraysRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlateTraysRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlateTraysRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'censusId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlateTraysRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlateTraysRequest copyWith(void Function(PlateTraysRequest) updates) =>
      super.copyWith((message) => updates(message as PlateTraysRequest))
          as PlateTraysRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlateTraysRequest create() => PlateTraysRequest._();
  @$core.override
  PlateTraysRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlateTraysRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlateTraysRequest>(create);
  static PlateTraysRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get censusId => $_getSZ(0);
  @$pb.TagNumber(1)
  set censusId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCensusId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCensusId() => $_clearField(1);
}

class PlateTraysResponse extends $pb.GeneratedMessage {
  factory PlateTraysResponse({
    $core.Iterable<Tray>? trays,
  }) {
    final result = create();
    if (trays != null) result.trays.addAll(trays);
    return result;
  }

  PlateTraysResponse._();

  factory PlateTraysResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlateTraysResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlateTraysResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..pPM<Tray>(1, _omitFieldNames ? '' : 'trays', subBuilder: Tray.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlateTraysResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlateTraysResponse copyWith(void Function(PlateTraysResponse) updates) =>
      super.copyWith((message) => updates(message as PlateTraysResponse))
          as PlateTraysResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlateTraysResponse create() => PlateTraysResponse._();
  @$core.override
  PlateTraysResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlateTraysResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlateTraysResponse>(create);
  static PlateTraysResponse? _defaultInstance;

  /// Only the trays this call plated. Running it twice on a census plates
  /// nothing the second time.
  @$pb.TagNumber(1)
  $pb.PbList<Tray> get trays => $_getList(0);
}

class PrepareTrayRequest extends $pb.GeneratedMessage {
  factory PrepareTrayRequest({
    $core.String? trayId,
  }) {
    final result = create();
    if (trayId != null) result.trayId = trayId;
    return result;
  }

  PrepareTrayRequest._();

  factory PrepareTrayRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrepareTrayRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrepareTrayRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trayId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareTrayRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareTrayRequest copyWith(void Function(PrepareTrayRequest) updates) =>
      super.copyWith((message) => updates(message as PrepareTrayRequest))
          as PrepareTrayRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrepareTrayRequest create() => PrepareTrayRequest._();
  @$core.override
  PrepareTrayRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrepareTrayRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrepareTrayRequest>(create);
  static PrepareTrayRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trayId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trayId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrayId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrayId() => $_clearField(1);
}

class PrepareTrayResponse extends $pb.GeneratedMessage {
  factory PrepareTrayResponse({
    Tray? tray,
  }) {
    final result = create();
    if (tray != null) result.tray = tray;
    return result;
  }

  PrepareTrayResponse._();

  factory PrepareTrayResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrepareTrayResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrepareTrayResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<Tray>(1, _omitFieldNames ? '' : 'tray', subBuilder: Tray.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareTrayResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareTrayResponse copyWith(void Function(PrepareTrayResponse) updates) =>
      super.copyWith((message) => updates(message as PrepareTrayResponse))
          as PrepareTrayResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrepareTrayResponse create() => PrepareTrayResponse._();
  @$core.override
  PrepareTrayResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrepareTrayResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrepareTrayResponse>(create);
  static PrepareTrayResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Tray get tray => $_getN(0);
  @$pb.TagNumber(1)
  set tray(Tray value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTray() => $_has(0);
  @$pb.TagNumber(1)
  void clearTray() => $_clearField(1);
  @$pb.TagNumber(1)
  Tray ensureTray() => $_ensure(0);
}

class DispatchTrayRequest extends $pb.GeneratedMessage {
  factory DispatchTrayRequest({
    $core.String? trayId,
  }) {
    final result = create();
    if (trayId != null) result.trayId = trayId;
    return result;
  }

  DispatchTrayRequest._();

  factory DispatchTrayRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DispatchTrayRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DispatchTrayRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trayId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispatchTrayRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispatchTrayRequest copyWith(void Function(DispatchTrayRequest) updates) =>
      super.copyWith((message) => updates(message as DispatchTrayRequest))
          as DispatchTrayRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DispatchTrayRequest create() => DispatchTrayRequest._();
  @$core.override
  DispatchTrayRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DispatchTrayRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DispatchTrayRequest>(create);
  static DispatchTrayRequest? _defaultInstance;

  /// The tray, and nothing else. The order in force is re-read server-side at
  /// this moment: a contract that let the caller assert what the diet was
  /// would let a stale screen send breakfast to somebody about to be
  /// anaesthetised.
  @$pb.TagNumber(1)
  $core.String get trayId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trayId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrayId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrayId() => $_clearField(1);
}

class DispatchTrayResponse extends $pb.GeneratedMessage {
  factory DispatchTrayResponse({
    Tray? tray,
  }) {
    final result = create();
    if (tray != null) result.tray = tray;
    return result;
  }

  DispatchTrayResponse._();

  factory DispatchTrayResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DispatchTrayResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DispatchTrayResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<Tray>(1, _omitFieldNames ? '' : 'tray', subBuilder: Tray.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispatchTrayResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispatchTrayResponse copyWith(void Function(DispatchTrayResponse) updates) =>
      super.copyWith((message) => updates(message as DispatchTrayResponse))
          as DispatchTrayResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DispatchTrayResponse create() => DispatchTrayResponse._();
  @$core.override
  DispatchTrayResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DispatchTrayResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DispatchTrayResponse>(create);
  static DispatchTrayResponse? _defaultInstance;

  /// Withheld with the reason when the check stops it, so the ward is told
  /// the meal was held rather than left to assume it went astray.
  @$pb.TagNumber(1)
  Tray get tray => $_getN(0);
  @$pb.TagNumber(1)
  set tray(Tray value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTray() => $_has(0);
  @$pb.TagNumber(1)
  void clearTray() => $_clearField(1);
  @$pb.TagNumber(1)
  Tray ensureTray() => $_ensure(0);
}

class DeliverTrayRequest extends $pb.GeneratedMessage {
  factory DeliverTrayRequest({
    $core.String? trayId,
  }) {
    final result = create();
    if (trayId != null) result.trayId = trayId;
    return result;
  }

  DeliverTrayRequest._();

  factory DeliverTrayRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeliverTrayRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeliverTrayRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trayId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeliverTrayRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeliverTrayRequest copyWith(void Function(DeliverTrayRequest) updates) =>
      super.copyWith((message) => updates(message as DeliverTrayRequest))
          as DeliverTrayRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeliverTrayRequest create() => DeliverTrayRequest._();
  @$core.override
  DeliverTrayRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeliverTrayRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeliverTrayRequest>(create);
  static DeliverTrayRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trayId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trayId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrayId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrayId() => $_clearField(1);
}

class DeliverTrayResponse extends $pb.GeneratedMessage {
  factory DeliverTrayResponse({
    Tray? tray,
  }) {
    final result = create();
    if (tray != null) result.tray = tray;
    return result;
  }

  DeliverTrayResponse._();

  factory DeliverTrayResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeliverTrayResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeliverTrayResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<Tray>(1, _omitFieldNames ? '' : 'tray', subBuilder: Tray.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeliverTrayResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeliverTrayResponse copyWith(void Function(DeliverTrayResponse) updates) =>
      super.copyWith((message) => updates(message as DeliverTrayResponse))
          as DeliverTrayResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeliverTrayResponse create() => DeliverTrayResponse._();
  @$core.override
  DeliverTrayResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeliverTrayResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeliverTrayResponse>(create);
  static DeliverTrayResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Tray get tray => $_getN(0);
  @$pb.TagNumber(1)
  set tray(Tray value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTray() => $_has(0);
  @$pb.TagNumber(1)
  void clearTray() => $_clearField(1);
  @$pb.TagNumber(1)
  Tray ensureTray() => $_ensure(0);
}

class CloseTrayRequest extends $pb.GeneratedMessage {
  factory CloseTrayRequest({
    $core.String? trayId,
    TrayState? state,
    $core.String? reason,
  }) {
    final result = create();
    if (trayId != null) result.trayId = trayId;
    if (state != null) result.state = state;
    if (reason != null) result.reason = reason;
    return result;
  }

  CloseTrayRequest._();

  factory CloseTrayRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseTrayRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseTrayRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trayId')
    ..aE<TrayState>(2, _omitFieldNames ? '' : 'state',
        enumValues: TrayState.values)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseTrayRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseTrayRequest copyWith(void Function(CloseTrayRequest) updates) =>
      super.copyWith((message) => updates(message as CloseTrayRequest))
          as CloseTrayRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseTrayRequest create() => CloseTrayRequest._();
  @$core.override
  CloseTrayRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseTrayRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseTrayRequest>(create);
  static CloseTrayRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trayId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trayId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrayId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrayId() => $_clearField(1);

  /// Refused or missed.
  @$pb.TagNumber(2)
  TrayState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(TrayState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class CloseTrayResponse extends $pb.GeneratedMessage {
  factory CloseTrayResponse({
    Tray? tray,
  }) {
    final result = create();
    if (tray != null) result.tray = tray;
    return result;
  }

  CloseTrayResponse._();

  factory CloseTrayResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseTrayResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseTrayResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<Tray>(1, _omitFieldNames ? '' : 'tray', subBuilder: Tray.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseTrayResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseTrayResponse copyWith(void Function(CloseTrayResponse) updates) =>
      super.copyWith((message) => updates(message as CloseTrayResponse))
          as CloseTrayResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseTrayResponse create() => CloseTrayResponse._();
  @$core.override
  CloseTrayResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseTrayResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseTrayResponse>(create);
  static CloseTrayResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Tray get tray => $_getN(0);
  @$pb.TagNumber(1)
  set tray(Tray value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTray() => $_has(0);
  @$pb.TagNumber(1)
  void clearTray() => $_clearField(1);
  @$pb.TagNumber(1)
  Tray ensureTray() => $_ensure(0);
}

class ListTraysRequest extends $pb.GeneratedMessage {
  factory ListTraysRequest({
    $core.String? censusId,
    $core.String? wardId,
    TrayState? state,
    $core.int? pageSize,
    $core.int? pageOffset,
  }) {
    final result = create();
    if (censusId != null) result.censusId = censusId;
    if (wardId != null) result.wardId = wardId;
    if (state != null) result.state = state;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageOffset != null) result.pageOffset = pageOffset;
    return result;
  }

  ListTraysRequest._();

  factory ListTraysRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTraysRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTraysRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'censusId')
    ..aOS(2, _omitFieldNames ? '' : 'wardId')
    ..aE<TrayState>(3, _omitFieldNames ? '' : 'state',
        enumValues: TrayState.values)
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..aI(5, _omitFieldNames ? '' : 'pageOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTraysRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTraysRequest copyWith(void Function(ListTraysRequest) updates) =>
      super.copyWith((message) => updates(message as ListTraysRequest))
          as ListTraysRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTraysRequest create() => ListTraysRequest._();
  @$core.override
  ListTraysRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTraysRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTraysRequest>(create);
  static ListTraysRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get censusId => $_getSZ(0);
  @$pb.TagNumber(1)
  set censusId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCensusId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCensusId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get wardId => $_getSZ(1);
  @$pb.TagNumber(2)
  set wardId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWardId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWardId() => $_clearField(2);

  @$pb.TagNumber(3)
  TrayState get state => $_getN(2);
  @$pb.TagNumber(3)
  set state(TrayState value) => $_setField(3, value);
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

class ListTraysResponse extends $pb.GeneratedMessage {
  factory ListTraysResponse({
    $core.Iterable<Tray>? trays,
  }) {
    final result = create();
    if (trays != null) result.trays.addAll(trays);
    return result;
  }

  ListTraysResponse._();

  factory ListTraysResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTraysResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTraysResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..pPM<Tray>(1, _omitFieldNames ? '' : 'trays', subBuilder: Tray.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTraysResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTraysResponse copyWith(void Function(ListTraysResponse) updates) =>
      super.copyWith((message) => updates(message as ListTraysResponse))
          as ListTraysResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTraysResponse create() => ListTraysResponse._();
  @$core.override
  ListTraysResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTraysResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTraysResponse>(create);
  static ListTraysResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Tray> get trays => $_getList(0);
}

class GetMealOutcomeRequest extends $pb.GeneratedMessage {
  factory GetMealOutcomeRequest({
    $core.String? censusId,
  }) {
    final result = create();
    if (censusId != null) result.censusId = censusId;
    return result;
  }

  GetMealOutcomeRequest._();

  factory GetMealOutcomeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMealOutcomeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMealOutcomeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'censusId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMealOutcomeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMealOutcomeRequest copyWith(
          void Function(GetMealOutcomeRequest) updates) =>
      super.copyWith((message) => updates(message as GetMealOutcomeRequest))
          as GetMealOutcomeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMealOutcomeRequest create() => GetMealOutcomeRequest._();
  @$core.override
  GetMealOutcomeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMealOutcomeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMealOutcomeRequest>(create);
  static GetMealOutcomeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get censusId => $_getSZ(0);
  @$pb.TagNumber(1)
  set censusId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCensusId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCensusId() => $_clearField(1);
}

class GetMealOutcomeResponse extends $pb.GeneratedMessage {
  factory GetMealOutcomeResponse({
    MealOutcome? outcome,
  }) {
    final result = create();
    if (outcome != null) result.outcome = outcome;
    return result;
  }

  GetMealOutcomeResponse._();

  factory GetMealOutcomeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMealOutcomeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMealOutcomeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<MealOutcome>(1, _omitFieldNames ? '' : 'outcome',
        subBuilder: MealOutcome.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMealOutcomeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMealOutcomeResponse copyWith(
          void Function(GetMealOutcomeResponse) updates) =>
      super.copyWith((message) => updates(message as GetMealOutcomeResponse))
          as GetMealOutcomeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMealOutcomeResponse create() => GetMealOutcomeResponse._();
  @$core.override
  GetMealOutcomeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMealOutcomeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMealOutcomeResponse>(create);
  static GetMealOutcomeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MealOutcome get outcome => $_getN(0);
  @$pb.TagNumber(1)
  set outcome(MealOutcome value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOutcome() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutcome() => $_clearField(1);
  @$pb.TagNumber(1)
  MealOutcome ensureOutcome() => $_ensure(0);
}

class ConfigureItemRequest extends $pb.GeneratedMessage {
  factory ConfigureItemRequest({
    DietItem? item,
    $core.String? kind,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (kind != null) result.kind = kind;
    return result;
  }

  ConfigureItemRequest._();

  factory ConfigureItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfigureItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfigureItemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<DietItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: DietItem.create)
    ..aOS(2, _omitFieldNames ? '' : 'kind')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureItemRequest copyWith(void Function(ConfigureItemRequest) updates) =>
      super.copyWith((message) => updates(message as ConfigureItemRequest))
          as ConfigureItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigureItemRequest create() => ConfigureItemRequest._();
  @$core.override
  ConfigureItemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfigureItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigureItemRequest>(create);
  static ConfigureItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  DietItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(DietItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  DietItem ensureItem() => $_ensure(0);

  /// ingredient, supplement or dish.
  @$pb.TagNumber(2)
  $core.String get kind => $_getSZ(1);
  @$pb.TagNumber(2)
  set kind($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);
}

class ConfigureItemResponse extends $pb.GeneratedMessage {
  factory ConfigureItemResponse() => create();

  ConfigureItemResponse._();

  factory ConfigureItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfigureItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfigureItemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureItemResponse copyWith(
          void Function(ConfigureItemResponse) updates) =>
      super.copyWith((message) => updates(message as ConfigureItemResponse))
          as ConfigureItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigureItemResponse create() => ConfigureItemResponse._();
  @$core.override
  ConfigureItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfigureItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigureItemResponse>(create);
  static ConfigureItemResponse? _defaultInstance;
}

class ConfigureRecipeRequest extends $pb.GeneratedMessage {
  factory ConfigureRecipeRequest({
    Recipe? recipe,
  }) {
    final result = create();
    if (recipe != null) result.recipe = recipe;
    return result;
  }

  ConfigureRecipeRequest._();

  factory ConfigureRecipeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfigureRecipeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfigureRecipeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<Recipe>(1, _omitFieldNames ? '' : 'recipe', subBuilder: Recipe.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureRecipeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureRecipeRequest copyWith(
          void Function(ConfigureRecipeRequest) updates) =>
      super.copyWith((message) => updates(message as ConfigureRecipeRequest))
          as ConfigureRecipeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigureRecipeRequest create() => ConfigureRecipeRequest._();
  @$core.override
  ConfigureRecipeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfigureRecipeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigureRecipeRequest>(create);
  static ConfigureRecipeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Recipe get recipe => $_getN(0);
  @$pb.TagNumber(1)
  set recipe(Recipe value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecipe() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecipe() => $_clearField(1);
  @$pb.TagNumber(1)
  Recipe ensureRecipe() => $_ensure(0);
}

class ConfigureRecipeResponse extends $pb.GeneratedMessage {
  factory ConfigureRecipeResponse() => create();

  ConfigureRecipeResponse._();

  factory ConfigureRecipeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfigureRecipeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfigureRecipeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureRecipeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureRecipeResponse copyWith(
          void Function(ConfigureRecipeResponse) updates) =>
      super.copyWith((message) => updates(message as ConfigureRecipeResponse))
          as ConfigureRecipeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigureRecipeResponse create() => ConfigureRecipeResponse._();
  @$core.override
  ConfigureRecipeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfigureRecipeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigureRecipeResponse>(create);
  static ConfigureRecipeResponse? _defaultInstance;
}

class ConfigureMenuItemRequest extends $pb.GeneratedMessage {
  factory ConfigureMenuItemRequest({
    MenuItem? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  ConfigureMenuItemRequest._();

  factory ConfigureMenuItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfigureMenuItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfigureMenuItemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<MenuItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: MenuItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureMenuItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureMenuItemRequest copyWith(
          void Function(ConfigureMenuItemRequest) updates) =>
      super.copyWith((message) => updates(message as ConfigureMenuItemRequest))
          as ConfigureMenuItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigureMenuItemRequest create() => ConfigureMenuItemRequest._();
  @$core.override
  ConfigureMenuItemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfigureMenuItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigureMenuItemRequest>(create);
  static ConfigureMenuItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  MenuItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(MenuItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  MenuItem ensureItem() => $_ensure(0);
}

class ConfigureMenuItemResponse extends $pb.GeneratedMessage {
  factory ConfigureMenuItemResponse() => create();

  ConfigureMenuItemResponse._();

  factory ConfigureMenuItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfigureMenuItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfigureMenuItemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureMenuItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureMenuItemResponse copyWith(
          void Function(ConfigureMenuItemResponse) updates) =>
      super.copyWith((message) => updates(message as ConfigureMenuItemResponse))
          as ConfigureMenuItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigureMenuItemResponse create() => ConfigureMenuItemResponse._();
  @$core.override
  ConfigureMenuItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfigureMenuItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigureMenuItemResponse>(create);
  static ConfigureMenuItemResponse? _defaultInstance;
}

class ListMenuRequest extends $pb.GeneratedMessage {
  factory ListMenuRequest({
    MealCycle? cycle,
  }) {
    final result = create();
    if (cycle != null) result.cycle = cycle;
    return result;
  }

  ListMenuRequest._();

  factory ListMenuRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMenuRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMenuRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aE<MealCycle>(1, _omitFieldNames ? '' : 'cycle',
        enumValues: MealCycle.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMenuRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMenuRequest copyWith(void Function(ListMenuRequest) updates) =>
      super.copyWith((message) => updates(message as ListMenuRequest))
          as ListMenuRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMenuRequest create() => ListMenuRequest._();
  @$core.override
  ListMenuRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMenuRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMenuRequest>(create);
  static ListMenuRequest? _defaultInstance;

  @$pb.TagNumber(1)
  MealCycle get cycle => $_getN(0);
  @$pb.TagNumber(1)
  set cycle(MealCycle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCycle() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycle() => $_clearField(1);
}

class ListMenuResponse extends $pb.GeneratedMessage {
  factory ListMenuResponse({
    $core.Iterable<MenuItem>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListMenuResponse._();

  factory ListMenuResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMenuResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMenuResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..pPM<MenuItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: MenuItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMenuResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMenuResponse copyWith(void Function(ListMenuResponse) updates) =>
      super.copyWith((message) => updates(message as ListMenuResponse))
          as ListMenuResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMenuResponse create() => ListMenuResponse._();
  @$core.override
  ListMenuResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMenuResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMenuResponse>(create);
  static ListMenuResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MenuItem> get items => $_getList(0);
}

class RecordConsumptionRequest extends $pb.GeneratedMessage {
  factory RecordConsumptionRequest({
    $core.String? censusId,
    $core.String? ingredientCode,
    $core.int? actualG,
    $core.String? note,
  }) {
    final result = create();
    if (censusId != null) result.censusId = censusId;
    if (ingredientCode != null) result.ingredientCode = ingredientCode;
    if (actualG != null) result.actualG = actualG;
    if (note != null) result.note = note;
    return result;
  }

  RecordConsumptionRequest._();

  factory RecordConsumptionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordConsumptionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordConsumptionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'censusId')
    ..aOS(2, _omitFieldNames ? '' : 'ingredientCode')
    ..aI(3, _omitFieldNames ? '' : 'actualG')
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordConsumptionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordConsumptionRequest copyWith(
          void Function(RecordConsumptionRequest) updates) =>
      super.copyWith((message) => updates(message as RecordConsumptionRequest))
          as RecordConsumptionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordConsumptionRequest create() => RecordConsumptionRequest._();
  @$core.override
  RecordConsumptionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordConsumptionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordConsumptionRequest>(create);
  static RecordConsumptionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get censusId => $_getSZ(0);
  @$pb.TagNumber(1)
  set censusId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCensusId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCensusId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ingredientCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set ingredientCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIngredientCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearIngredientCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get actualG => $_getIZ(2);
  @$pb.TagNumber(3)
  set actualG($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActualG() => $_has(2);
  @$pb.TagNumber(3)
  void clearActualG() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);
}

class RecordConsumptionResponse extends $pb.GeneratedMessage {
  factory RecordConsumptionResponse({
    IngredientQuantity? counted,
  }) {
    final result = create();
    if (counted != null) result.counted = counted;
    return result;
  }

  RecordConsumptionResponse._();

  factory RecordConsumptionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordConsumptionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordConsumptionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<IngredientQuantity>(1, _omitFieldNames ? '' : 'counted',
        subBuilder: IngredientQuantity.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordConsumptionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordConsumptionResponse copyWith(
          void Function(RecordConsumptionResponse) updates) =>
      super.copyWith((message) => updates(message as RecordConsumptionResponse))
          as RecordConsumptionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordConsumptionResponse create() => RecordConsumptionResponse._();
  @$core.override
  RecordConsumptionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordConsumptionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordConsumptionResponse>(create);
  static RecordConsumptionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  IngredientQuantity get counted => $_getN(0);
  @$pb.TagNumber(1)
  set counted(IngredientQuantity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCounted() => $_has(0);
  @$pb.TagNumber(1)
  void clearCounted() => $_clearField(1);
  @$pb.TagNumber(1)
  IngredientQuantity ensureCounted() => $_ensure(0);
}

class GetIngredientForecastRequest extends $pb.GeneratedMessage {
  factory GetIngredientForecastRequest({
    $core.String? censusId,
  }) {
    final result = create();
    if (censusId != null) result.censusId = censusId;
    return result;
  }

  GetIngredientForecastRequest._();

  factory GetIngredientForecastRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetIngredientForecastRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetIngredientForecastRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'censusId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIngredientForecastRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIngredientForecastRequest copyWith(
          void Function(GetIngredientForecastRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetIngredientForecastRequest))
          as GetIngredientForecastRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetIngredientForecastRequest create() =>
      GetIngredientForecastRequest._();
  @$core.override
  GetIngredientForecastRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetIngredientForecastRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetIngredientForecastRequest>(create);
  static GetIngredientForecastRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get censusId => $_getSZ(0);
  @$pb.TagNumber(1)
  set censusId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCensusId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCensusId() => $_clearField(1);
}

class GetIngredientForecastResponse extends $pb.GeneratedMessage {
  factory GetIngredientForecastResponse({
    Forecast? forecast,
  }) {
    final result = create();
    if (forecast != null) result.forecast = forecast;
    return result;
  }

  GetIngredientForecastResponse._();

  factory GetIngredientForecastResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetIngredientForecastResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetIngredientForecastResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.hospital_ops_diet.v1'),
      createEmptyInstance: create)
    ..aOM<Forecast>(1, _omitFieldNames ? '' : 'forecast',
        subBuilder: Forecast.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIngredientForecastResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIngredientForecastResponse copyWith(
          void Function(GetIngredientForecastResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetIngredientForecastResponse))
          as GetIngredientForecastResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetIngredientForecastResponse create() =>
      GetIngredientForecastResponse._();
  @$core.override
  GetIngredientForecastResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetIngredientForecastResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetIngredientForecastResponse>(create);
  static GetIngredientForecastResponse? _defaultInstance;

  /// The forecast and the counts side by side, never merged: a single
  /// variance figure cannot say whether the kitchen over-ordered or
  /// over-served.
  @$pb.TagNumber(1)
  Forecast get forecast => $_getN(0);
  @$pb.TagNumber(1)
  set forecast(Forecast value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasForecast() => $_has(0);
  @$pb.TagNumber(1)
  void clearForecast() => $_clearField(1);
  @$pb.TagNumber(1)
  Forecast ensureForecast() => $_ensure(0);
}

/// The dietetics and kitchen operations service.
class DietServiceApi {
  final $pb.RpcClient _client;

  DietServiceApi(this._client);

  /// Nutrition assessment and care plans (SRS-DIET-001, SRS-DIET-004).
  $async.Future<RecordAssessmentResponse> recordAssessment(
          $pb.ClientContext? ctx, RecordAssessmentRequest request) =>
      _client.invoke<RecordAssessmentResponse>(ctx, 'DietService',
          'RecordAssessment', request, RecordAssessmentResponse());
  $async.Future<SignAssessmentResponse> signAssessment(
          $pb.ClientContext? ctx, SignAssessmentRequest request) =>
      _client.invoke<SignAssessmentResponse>(ctx, 'DietService',
          'SignAssessment', request, SignAssessmentResponse());
  $async.Future<ListAssessmentsResponse> listAssessments(
          $pb.ClientContext? ctx, ListAssessmentsRequest request) =>
      _client.invoke<ListAssessmentsResponse>(ctx, 'DietService',
          'ListAssessments', request, ListAssessmentsResponse());
  $async.Future<OpenCarePlanResponse> openCarePlan(
          $pb.ClientContext? ctx, OpenCarePlanRequest request) =>
      _client.invoke<OpenCarePlanResponse>(
          ctx, 'DietService', 'OpenCarePlan', request, OpenCarePlanResponse());
  $async.Future<RecordProgressResponse> recordProgress(
          $pb.ClientContext? ctx, RecordProgressRequest request) =>
      _client.invoke<RecordProgressResponse>(ctx, 'DietService',
          'RecordProgress', request, RecordProgressResponse());
  $async.Future<CloseCarePlanResponse> closeCarePlan(
          $pb.ClientContext? ctx, CloseCarePlanRequest request) =>
      _client.invoke<CloseCarePlanResponse>(ctx, 'DietService', 'CloseCarePlan',
          request, CloseCarePlanResponse());
  $async.Future<ListCarePlansResponse> listCarePlans(
          $pb.ClientContext? ctx, ListCarePlansRequest request) =>
      _client.invoke<ListCarePlansResponse>(ctx, 'DietService', 'ListCarePlans',
          request, ListCarePlansResponse());
  $async.Future<GetGoalTrendResponse> getGoalTrend(
          $pb.ClientContext? ctx, GetGoalTrendRequest request) =>
      _client.invoke<GetGoalTrendResponse>(
          ctx, 'DietService', 'GetGoalTrend', request, GetGoalTrendResponse());

  /// Diet orders (SRS-DIET-002, SRS-DIET-003, SRS-DIET-009).
  $async.Future<PlaceDietOrderResponse> placeDietOrder(
          $pb.ClientContext? ctx, PlaceDietOrderRequest request) =>
      _client.invoke<PlaceDietOrderResponse>(ctx, 'DietService',
          'PlaceDietOrder', request, PlaceDietOrderResponse());
  $async.Future<ResolveConflictResponse> resolveConflict(
          $pb.ClientContext? ctx, ResolveConflictRequest request) =>
      _client.invoke<ResolveConflictResponse>(ctx, 'DietService',
          'ResolveConflict', request, ResolveConflictResponse());
  $async.Future<CancelDietOrderResponse> cancelDietOrder(
          $pb.ClientContext? ctx, CancelDietOrderRequest request) =>
      _client.invoke<CancelDietOrderResponse>(ctx, 'DietService',
          'CancelDietOrder', request, CancelDietOrderResponse());
  $async.Future<GetCurrentDietOrderResponse> getCurrentDietOrder(
          $pb.ClientContext? ctx, GetCurrentDietOrderRequest request) =>
      _client.invoke<GetCurrentDietOrderResponse>(ctx, 'DietService',
          'GetCurrentDietOrder', request, GetCurrentDietOrderResponse());
  $async.Future<ListDietOrdersResponse> listDietOrders(
          $pb.ClientContext? ctx, ListDietOrdersRequest request) =>
      _client.invoke<ListDietOrdersResponse>(ctx, 'DietService',
          'ListDietOrders', request, ListDietOrdersResponse());

  /// Nutrition support (SRS-DIET-007).
  $async.Future<PlanNutritionSupportResponse> planNutritionSupport(
          $pb.ClientContext? ctx, PlanNutritionSupportRequest request) =>
      _client.invoke<PlanNutritionSupportResponse>(ctx, 'DietService',
          'PlanNutritionSupport', request, PlanNutritionSupportResponse());
  $async.Future<LinkSupportOrderResponse> linkSupportOrder(
          $pb.ClientContext? ctx, LinkSupportOrderRequest request) =>
      _client.invoke<LinkSupportOrderResponse>(ctx, 'DietService',
          'LinkSupportOrder', request, LinkSupportOrderResponse());
  $async.Future<StopSupportResponse> stopSupport(
          $pb.ClientContext? ctx, StopSupportRequest request) =>
      _client.invoke<StopSupportResponse>(
          ctx, 'DietService', 'StopSupport', request, StopSupportResponse());
  $async.Future<ListSupportPlansResponse> listSupportPlans(
          $pb.ClientContext? ctx, ListSupportPlansRequest request) =>
      _client.invoke<ListSupportPlansResponse>(ctx, 'DietService',
          'ListSupportPlans', request, ListSupportPlansResponse());

  /// Meal census and trays (SRS-DIET-005, SRS-DIET-006, SRS-DIET-009).
  $async.Future<BuildCensusResponse> buildCensus(
          $pb.ClientContext? ctx, BuildCensusRequest request) =>
      _client.invoke<BuildCensusResponse>(
          ctx, 'DietService', 'BuildCensus', request, BuildCensusResponse());
  $async.Future<FreezeCensusResponse> freezeCensus(
          $pb.ClientContext? ctx, FreezeCensusRequest request) =>
      _client.invoke<FreezeCensusResponse>(
          ctx, 'DietService', 'FreezeCensus', request, FreezeCensusResponse());
  $async.Future<ReissueCensusResponse> reissueCensus(
          $pb.ClientContext? ctx, ReissueCensusRequest request) =>
      _client.invoke<ReissueCensusResponse>(ctx, 'DietService', 'ReissueCensus',
          request, ReissueCensusResponse());
  $async.Future<ListCensusesResponse> listCensuses(
          $pb.ClientContext? ctx, ListCensusesRequest request) =>
      _client.invoke<ListCensusesResponse>(
          ctx, 'DietService', 'ListCensuses', request, ListCensusesResponse());
  $async.Future<PlateTraysResponse> plateTrays(
          $pb.ClientContext? ctx, PlateTraysRequest request) =>
      _client.invoke<PlateTraysResponse>(
          ctx, 'DietService', 'PlateTrays', request, PlateTraysResponse());
  $async.Future<PrepareTrayResponse> prepareTray(
          $pb.ClientContext? ctx, PrepareTrayRequest request) =>
      _client.invoke<PrepareTrayResponse>(
          ctx, 'DietService', 'PrepareTray', request, PrepareTrayResponse());
  $async.Future<DispatchTrayResponse> dispatchTray(
          $pb.ClientContext? ctx, DispatchTrayRequest request) =>
      _client.invoke<DispatchTrayResponse>(
          ctx, 'DietService', 'DispatchTray', request, DispatchTrayResponse());
  $async.Future<DeliverTrayResponse> deliverTray(
          $pb.ClientContext? ctx, DeliverTrayRequest request) =>
      _client.invoke<DeliverTrayResponse>(
          ctx, 'DietService', 'DeliverTray', request, DeliverTrayResponse());
  $async.Future<CloseTrayResponse> closeTray(
          $pb.ClientContext? ctx, CloseTrayRequest request) =>
      _client.invoke<CloseTrayResponse>(
          ctx, 'DietService', 'CloseTray', request, CloseTrayResponse());
  $async.Future<ListTraysResponse> listTrays(
          $pb.ClientContext? ctx, ListTraysRequest request) =>
      _client.invoke<ListTraysResponse>(
          ctx, 'DietService', 'ListTrays', request, ListTraysResponse());
  $async.Future<GetMealOutcomeResponse> getMealOutcome(
          $pb.ClientContext? ctx, GetMealOutcomeRequest request) =>
      _client.invoke<GetMealOutcomeResponse>(ctx, 'DietService',
          'GetMealOutcome', request, GetMealOutcomeResponse());

  /// Kitchen configuration and forecasting (SRS-DIET-003, SRS-DIET-008).
  $async.Future<ConfigureItemResponse> configureItem(
          $pb.ClientContext? ctx, ConfigureItemRequest request) =>
      _client.invoke<ConfigureItemResponse>(ctx, 'DietService', 'ConfigureItem',
          request, ConfigureItemResponse());
  $async.Future<ConfigureRecipeResponse> configureRecipe(
          $pb.ClientContext? ctx, ConfigureRecipeRequest request) =>
      _client.invoke<ConfigureRecipeResponse>(ctx, 'DietService',
          'ConfigureRecipe', request, ConfigureRecipeResponse());
  $async.Future<ConfigureMenuItemResponse> configureMenuItem(
          $pb.ClientContext? ctx, ConfigureMenuItemRequest request) =>
      _client.invoke<ConfigureMenuItemResponse>(ctx, 'DietService',
          'ConfigureMenuItem', request, ConfigureMenuItemResponse());
  $async.Future<ListMenuResponse> listMenu(
          $pb.ClientContext? ctx, ListMenuRequest request) =>
      _client.invoke<ListMenuResponse>(
          ctx, 'DietService', 'ListMenu', request, ListMenuResponse());
  $async.Future<RecordConsumptionResponse> recordConsumption(
          $pb.ClientContext? ctx, RecordConsumptionRequest request) =>
      _client.invoke<RecordConsumptionResponse>(ctx, 'DietService',
          'RecordConsumption', request, RecordConsumptionResponse());
  $async.Future<GetIngredientForecastResponse> getIngredientForecast(
          $pb.ClientContext? ctx, GetIngredientForecastRequest request) =>
      _client.invoke<GetIngredientForecastResponse>(ctx, 'DietService',
          'GetIngredientForecast', request, GetIngredientForecastResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
