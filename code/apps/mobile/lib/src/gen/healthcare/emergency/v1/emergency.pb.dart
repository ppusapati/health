// This is a generated file - do not edit.
//
// Generated from healthcare/emergency/v1/emergency.proto.

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

import 'emergency.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'emergency.pbenum.dart';

class EmergencyVisit extends $pb.GeneratedMessage {
  factory EmergencyVisit({
    $core.String? visitId,
    $core.String? encounterId,
    $core.String? patientId,
    $core.String? facilityId,
    ArrivalMode? arrivalMode,
    $core.String? chiefComplaint,
    $0.Timestamp? arrivedAt,
    $core.bool? unidentified,
    $core.String? temporaryName,
    $core.bool? medicoLegal,
    $core.String? medicoLegalRef,
    VisitStatus? status,
    $core.String? location,
    Disposition? disposition,
    $0.Timestamp? disposedAt,
    $core.String? dispositionNote,
    $core.String? receivingService,
    $0.Timestamp? observationStartedAt,
    $0.Timestamp? observationEndsAt,
    $core.String? createdBy,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $fixnum.Int64? version,
    $core.bool? restricted,
  }) {
    final result = create();
    if (visitId != null) result.visitId = visitId;
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (facilityId != null) result.facilityId = facilityId;
    if (arrivalMode != null) result.arrivalMode = arrivalMode;
    if (chiefComplaint != null) result.chiefComplaint = chiefComplaint;
    if (arrivedAt != null) result.arrivedAt = arrivedAt;
    if (unidentified != null) result.unidentified = unidentified;
    if (temporaryName != null) result.temporaryName = temporaryName;
    if (medicoLegal != null) result.medicoLegal = medicoLegal;
    if (medicoLegalRef != null) result.medicoLegalRef = medicoLegalRef;
    if (status != null) result.status = status;
    if (location != null) result.location = location;
    if (disposition != null) result.disposition = disposition;
    if (disposedAt != null) result.disposedAt = disposedAt;
    if (dispositionNote != null) result.dispositionNote = dispositionNote;
    if (receivingService != null) result.receivingService = receivingService;
    if (observationStartedAt != null)
      result.observationStartedAt = observationStartedAt;
    if (observationEndsAt != null) result.observationEndsAt = observationEndsAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (version != null) result.version = version;
    if (restricted != null) result.restricted = restricted;
    return result;
  }

  EmergencyVisit._();

  factory EmergencyVisit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmergencyVisit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmergencyVisit',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'visitId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aE<ArrivalMode>(5, _omitFieldNames ? '' : 'arrivalMode',
        enumValues: ArrivalMode.values)
    ..aOS(6, _omitFieldNames ? '' : 'chiefComplaint')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'arrivedAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(8, _omitFieldNames ? '' : 'unidentified')
    ..aOS(9, _omitFieldNames ? '' : 'temporaryName')
    ..aOB(10, _omitFieldNames ? '' : 'medicoLegal')
    ..aOS(11, _omitFieldNames ? '' : 'medicoLegalRef')
    ..aE<VisitStatus>(12, _omitFieldNames ? '' : 'status',
        enumValues: VisitStatus.values)
    ..aOS(13, _omitFieldNames ? '' : 'location')
    ..aE<Disposition>(14, _omitFieldNames ? '' : 'disposition',
        enumValues: Disposition.values)
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'disposedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'dispositionNote')
    ..aOS(17, _omitFieldNames ? '' : 'receivingService')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'observationStartedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(19, _omitFieldNames ? '' : 'observationEndsAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(20, _omitFieldNames ? '' : 'createdBy')
    ..aOM<$0.Timestamp>(21, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(22, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(23, _omitFieldNames ? '' : 'version')
    ..aOB(24, _omitFieldNames ? '' : 'restricted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmergencyVisit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmergencyVisit copyWith(void Function(EmergencyVisit) updates) =>
      super.copyWith((message) => updates(message as EmergencyVisit))
          as EmergencyVisit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmergencyVisit create() => EmergencyVisit._();
  @$core.override
  EmergencyVisit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmergencyVisit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmergencyVisit>(create);
  static EmergencyVisit? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get visitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set visitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVisitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisitId() => $_clearField(1);

  /// The Wave-1 encounter this is the emergency detail of.
  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  /// Empty while the patient is unidentified (SRS-ER-004).
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
  ArrivalMode get arrivalMode => $_getN(4);
  @$pb.TagNumber(5)
  set arrivalMode(ArrivalMode value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasArrivalMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearArrivalMode() => $_clearField(5);

  /// What the patient or the crew said, in their words. Never coded: the first
  /// sentence is evidence, and coding it at the door loses the difference
  /// between "crushing chest pain" and "indigestion".
  @$pb.TagNumber(6)
  $core.String get chiefComplaint => $_getSZ(5);
  @$pb.TagNumber(6)
  set chiefComplaint($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasChiefComplaint() => $_has(5);
  @$pb.TagNumber(6)
  void clearChiefComplaint() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get arrivedAt => $_getN(6);
  @$pb.TagNumber(7)
  set arrivedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasArrivedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearArrivedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureArrivedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.bool get unidentified => $_getBF(7);
  @$pb.TagNumber(8)
  set unidentified($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUnidentified() => $_has(7);
  @$pb.TagNumber(8)
  void clearUnidentified() => $_clearField(8);

  /// Kept after identification. A record that renamed its own history would
  /// make the resuscitation timeline refer to somebody who was never there.
  @$pb.TagNumber(9)
  $core.String get temporaryName => $_getSZ(8);
  @$pb.TagNumber(9)
  set temporaryName($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTemporaryName() => $_has(8);
  @$pb.TagNumber(9)
  void clearTemporaryName() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get medicoLegal => $_getBF(9);
  @$pb.TagNumber(10)
  set medicoLegal($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMedicoLegal() => $_has(9);
  @$pb.TagNumber(10)
  void clearMedicoLegal() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get medicoLegalRef => $_getSZ(10);
  @$pb.TagNumber(11)
  set medicoLegalRef($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMedicoLegalRef() => $_has(10);
  @$pb.TagNumber(11)
  void clearMedicoLegalRef() => $_clearField(11);

  @$pb.TagNumber(12)
  VisitStatus get status => $_getN(11);
  @$pb.TagNumber(12)
  set status(VisitStatus value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasStatus() => $_has(11);
  @$pb.TagNumber(12)
  void clearStatus() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get location => $_getSZ(12);
  @$pb.TagNumber(13)
  set location($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasLocation() => $_has(12);
  @$pb.TagNumber(13)
  void clearLocation() => $_clearField(13);

  @$pb.TagNumber(14)
  Disposition get disposition => $_getN(13);
  @$pb.TagNumber(14)
  set disposition(Disposition value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasDisposition() => $_has(13);
  @$pb.TagNumber(14)
  void clearDisposition() => $_clearField(14);

  @$pb.TagNumber(15)
  $0.Timestamp get disposedAt => $_getN(14);
  @$pb.TagNumber(15)
  set disposedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasDisposedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearDisposedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureDisposedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get dispositionNote => $_getSZ(15);
  @$pb.TagNumber(16)
  set dispositionNote($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasDispositionNote() => $_has(15);
  @$pb.TagNumber(16)
  void clearDispositionNote() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get receivingService => $_getSZ(16);
  @$pb.TagNumber(17)
  set receivingService($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasReceivingService() => $_has(16);
  @$pb.TagNumber(17)
  void clearReceivingService() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get observationStartedAt => $_getN(17);
  @$pb.TagNumber(18)
  set observationStartedAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasObservationStartedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearObservationStartedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureObservationStartedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $0.Timestamp get observationEndsAt => $_getN(18);
  @$pb.TagNumber(19)
  set observationEndsAt($0.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasObservationEndsAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearObservationEndsAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Timestamp ensureObservationEndsAt() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.String get createdBy => $_getSZ(19);
  @$pb.TagNumber(20)
  set createdBy($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasCreatedBy() => $_has(19);
  @$pb.TagNumber(20)
  void clearCreatedBy() => $_clearField(20);

  @$pb.TagNumber(21)
  $0.Timestamp get createdAt => $_getN(20);
  @$pb.TagNumber(21)
  set createdAt($0.Timestamp value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasCreatedAt() => $_has(20);
  @$pb.TagNumber(21)
  void clearCreatedAt() => $_clearField(21);
  @$pb.TagNumber(21)
  $0.Timestamp ensureCreatedAt() => $_ensure(20);

  @$pb.TagNumber(22)
  $0.Timestamp get updatedAt => $_getN(21);
  @$pb.TagNumber(22)
  set updatedAt($0.Timestamp value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasUpdatedAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearUpdatedAt() => $_clearField(22);
  @$pb.TagNumber(22)
  $0.Timestamp ensureUpdatedAt() => $_ensure(21);

  @$pb.TagNumber(23)
  $fixnum.Int64 get version => $_getI64(22);
  @$pb.TagNumber(23)
  set version($fixnum.Int64 value) => $_setInt64(22, value);
  @$pb.TagNumber(23)
  $core.bool hasVersion() => $_has(22);
  @$pb.TagNumber(23)
  void clearVersion() => $_clearField(23);

  /// True where this caller may not see the visit's detail (SRS-ER-011). The
  /// visit still comes back: a clinician who cannot read the medico-legal
  /// documentation may still need to know the patient is in Resus 2.
  @$pb.TagNumber(24)
  $core.bool get restricted => $_getBF(23);
  @$pb.TagNumber(24)
  set restricted($core.bool value) => $_setBool(23, value);
  @$pb.TagNumber(24)
  $core.bool hasRestricted() => $_has(23);
  @$pb.TagNumber(24)
  void clearRestricted() => $_clearField(24);
}

class Triage extends $pb.GeneratedMessage {
  factory Triage({
    $core.String? triageId,
    $core.String? visitId,
    $core.String? scaleName,
    $core.String? scaleVersion,
    $core.String? acuityCode,
    $core.int? acuityRank,
    $core.int? respiratoryRate,
    $core.int? heartRate,
    $core.int? systolicBp,
    $core.int? oxygenSaturation,
    $core.double? temperature,
    $core.int? painScore,
    $core.String? consciousness,
    $core.Iterable<$core.String>? redFlags,
    $core.Iterable<$core.String>? missingFields,
    $core.String? note,
    $core.String? assessedBy,
    $0.Timestamp? assessedAt,
  }) {
    final result = create();
    if (triageId != null) result.triageId = triageId;
    if (visitId != null) result.visitId = visitId;
    if (scaleName != null) result.scaleName = scaleName;
    if (scaleVersion != null) result.scaleVersion = scaleVersion;
    if (acuityCode != null) result.acuityCode = acuityCode;
    if (acuityRank != null) result.acuityRank = acuityRank;
    if (respiratoryRate != null) result.respiratoryRate = respiratoryRate;
    if (heartRate != null) result.heartRate = heartRate;
    if (systolicBp != null) result.systolicBp = systolicBp;
    if (oxygenSaturation != null) result.oxygenSaturation = oxygenSaturation;
    if (temperature != null) result.temperature = temperature;
    if (painScore != null) result.painScore = painScore;
    if (consciousness != null) result.consciousness = consciousness;
    if (redFlags != null) result.redFlags.addAll(redFlags);
    if (missingFields != null) result.missingFields.addAll(missingFields);
    if (note != null) result.note = note;
    if (assessedBy != null) result.assessedBy = assessedBy;
    if (assessedAt != null) result.assessedAt = assessedAt;
    return result;
  }

  Triage._();

  factory Triage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Triage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Triage',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'triageId')
    ..aOS(2, _omitFieldNames ? '' : 'visitId')
    ..aOS(3, _omitFieldNames ? '' : 'scaleName')
    ..aOS(4, _omitFieldNames ? '' : 'scaleVersion')
    ..aOS(5, _omitFieldNames ? '' : 'acuityCode')
    ..aI(6, _omitFieldNames ? '' : 'acuityRank')
    ..aI(7, _omitFieldNames ? '' : 'respiratoryRate')
    ..aI(8, _omitFieldNames ? '' : 'heartRate')
    ..aI(9, _omitFieldNames ? '' : 'systolicBp')
    ..aI(10, _omitFieldNames ? '' : 'oxygenSaturation')
    ..aD(11, _omitFieldNames ? '' : 'temperature')
    ..aI(12, _omitFieldNames ? '' : 'painScore')
    ..aOS(13, _omitFieldNames ? '' : 'consciousness')
    ..pPS(14, _omitFieldNames ? '' : 'redFlags')
    ..pPS(15, _omitFieldNames ? '' : 'missingFields')
    ..aOS(16, _omitFieldNames ? '' : 'note')
    ..aOS(17, _omitFieldNames ? '' : 'assessedBy')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'assessedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Triage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Triage copyWith(void Function(Triage) updates) =>
      super.copyWith((message) => updates(message as Triage)) as Triage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Triage create() => Triage._();
  @$core.override
  Triage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Triage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Triage>(create);
  static Triage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get triageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set triageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTriageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTriageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get visitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set visitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVisitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVisitId() => $_clearField(2);

  /// The scale travels with the assessment. An ESI 2 read under Manchester is a
  /// different patient.
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

  @$pb.TagNumber(5)
  $core.String get acuityCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set acuityCode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAcuityCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearAcuityCode() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get acuityRank => $_getIZ(5);
  @$pb.TagNumber(6)
  set acuityRank($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAcuityRank() => $_has(5);
  @$pb.TagNumber(6)
  void clearAcuityRank() => $_clearField(6);

  /// The inputs, as recorded. Optional throughout: a missing observation is
  /// recorded as missing rather than as zero.
  @$pb.TagNumber(7)
  $core.int get respiratoryRate => $_getIZ(6);
  @$pb.TagNumber(7)
  set respiratoryRate($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRespiratoryRate() => $_has(6);
  @$pb.TagNumber(7)
  void clearRespiratoryRate() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get heartRate => $_getIZ(7);
  @$pb.TagNumber(8)
  set heartRate($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHeartRate() => $_has(7);
  @$pb.TagNumber(8)
  void clearHeartRate() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get systolicBp => $_getIZ(8);
  @$pb.TagNumber(9)
  set systolicBp($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSystolicBp() => $_has(8);
  @$pb.TagNumber(9)
  void clearSystolicBp() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get oxygenSaturation => $_getIZ(9);
  @$pb.TagNumber(10)
  set oxygenSaturation($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasOxygenSaturation() => $_has(9);
  @$pb.TagNumber(10)
  void clearOxygenSaturation() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get temperature => $_getN(10);
  @$pb.TagNumber(11)
  set temperature($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTemperature() => $_has(10);
  @$pb.TagNumber(11)
  void clearTemperature() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get painScore => $_getIZ(11);
  @$pb.TagNumber(12)
  set painScore($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasPainScore() => $_has(11);
  @$pb.TagNumber(12)
  void clearPainScore() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get consciousness => $_getSZ(12);
  @$pb.TagNumber(13)
  set consciousness($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasConsciousness() => $_has(12);
  @$pb.TagNumber(13)
  void clearConsciousness() => $_clearField(13);

  @$pb.TagNumber(14)
  $pb.PbList<$core.String> get redFlags => $_getList(13);

  /// What the department required and did not get. Flagged rather than refused:
  /// a nurse with a crashing patient does not stop for a temperature, and
  /// refusing the assessment produces a fabricated one.
  @$pb.TagNumber(15)
  $pb.PbList<$core.String> get missingFields => $_getList(14);

  @$pb.TagNumber(16)
  $core.String get note => $_getSZ(15);
  @$pb.TagNumber(16)
  set note($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasNote() => $_has(15);
  @$pb.TagNumber(16)
  void clearNote() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get assessedBy => $_getSZ(16);
  @$pb.TagNumber(17)
  set assessedBy($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasAssessedBy() => $_has(16);
  @$pb.TagNumber(17)
  void clearAssessedBy() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get assessedAt => $_getN(17);
  @$pb.TagNumber(18)
  set assessedAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasAssessedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearAssessedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureAssessedAt() => $_ensure(17);
}

/// A clinician moving a patient in the queue (SRS-ER-003).
class PriorityOverride extends $pb.GeneratedMessage {
  factory PriorityOverride({
    $core.int? acuityRank,
    $core.String? reason,
    $core.String? overriddenBy,
    $0.Timestamp? overriddenAt,
  }) {
    final result = create();
    if (acuityRank != null) result.acuityRank = acuityRank;
    if (reason != null) result.reason = reason;
    if (overriddenBy != null) result.overriddenBy = overriddenBy;
    if (overriddenAt != null) result.overriddenAt = overriddenAt;
    return result;
  }

  PriorityOverride._();

  factory PriorityOverride.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PriorityOverride.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PriorityOverride',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'acuityRank')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOS(3, _omitFieldNames ? '' : 'overriddenBy')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'overriddenAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PriorityOverride clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PriorityOverride copyWith(void Function(PriorityOverride) updates) =>
      super.copyWith((message) => updates(message as PriorityOverride))
          as PriorityOverride;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PriorityOverride create() => PriorityOverride._();
  @$core.override
  PriorityOverride createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PriorityOverride getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PriorityOverride>(create);
  static PriorityOverride? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get acuityRank => $_getIZ(0);
  @$pb.TagNumber(1)
  set acuityRank($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAcuityRank() => $_has(0);
  @$pb.TagNumber(1)
  void clearAcuityRank() => $_clearField(1);

  /// Required in both directions. Moving somebody down is the decision argued
  /// about afterwards.
  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get overriddenBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set overriddenBy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOverriddenBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverriddenBy() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get overriddenAt => $_getN(3);
  @$pb.TagNumber(4)
  set overriddenAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasOverriddenAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearOverriddenAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureOverriddenAt() => $_ensure(3);
}

class MilestoneTarget extends $pb.GeneratedMessage {
  factory MilestoneTarget({
    $core.String? code,
    $core.String? label,
    $fixnum.Int64? withinSeconds,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (label != null) result.label = label;
    if (withinSeconds != null) result.withinSeconds = withinSeconds;
    return result;
  }

  MilestoneTarget._();

  factory MilestoneTarget.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MilestoneTarget.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MilestoneTarget',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aInt64(3, _omitFieldNames ? '' : 'withinSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MilestoneTarget clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MilestoneTarget copyWith(void Function(MilestoneTarget) updates) =>
      super.copyWith((message) => updates(message as MilestoneTarget))
          as MilestoneTarget;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MilestoneTarget create() => MilestoneTarget._();
  @$core.override
  MilestoneTarget createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MilestoneTarget getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MilestoneTarget>(create);
  static MilestoneTarget? _defaultInstance;

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
  $fixnum.Int64 get withinSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set withinSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWithinSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearWithinSeconds() => $_clearField(3);
}

class MilestoneState extends $pb.GeneratedMessage {
  factory MilestoneState({
    MilestoneTarget? target,
    $core.bool? reached,
    $0.Timestamp? reachedAt,
    $fixnum.Int64? elapsedSeconds,
    $core.bool? breached,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (reached != null) result.reached = reached;
    if (reachedAt != null) result.reachedAt = reachedAt;
    if (elapsedSeconds != null) result.elapsedSeconds = elapsedSeconds;
    if (breached != null) result.breached = breached;
    return result;
  }

  MilestoneState._();

  factory MilestoneState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MilestoneState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MilestoneState',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOM<MilestoneTarget>(1, _omitFieldNames ? '' : 'target',
        subBuilder: MilestoneTarget.create)
    ..aOB(2, _omitFieldNames ? '' : 'reached')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'reachedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(4, _omitFieldNames ? '' : 'elapsedSeconds')
    ..aOB(5, _omitFieldNames ? '' : 'breached')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MilestoneState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MilestoneState copyWith(void Function(MilestoneState) updates) =>
      super.copyWith((message) => updates(message as MilestoneState))
          as MilestoneState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MilestoneState create() => MilestoneState._();
  @$core.override
  MilestoneState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MilestoneState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MilestoneState>(create);
  static MilestoneState? _defaultInstance;

  @$pb.TagNumber(1)
  MilestoneTarget get target => $_getN(0);
  @$pb.TagNumber(1)
  set target(MilestoneTarget value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  MilestoneTarget ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get reached => $_getBF(1);
  @$pb.TagNumber(2)
  set reached($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReached() => $_has(1);
  @$pb.TagNumber(2)
  void clearReached() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get reachedAt => $_getN(2);
  @$pb.TagNumber(3)
  set reachedAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReachedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearReachedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureReachedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get elapsedSeconds => $_getI64(3);
  @$pb.TagNumber(4)
  set elapsedSeconds($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasElapsedSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearElapsedSeconds() => $_clearField(4);

  /// A target passed without the milestone. True while it is still missable,
  /// because a breach that only appears afterwards is one nobody could have
  /// prevented.
  @$pb.TagNumber(5)
  $core.bool get breached => $_getBF(4);
  @$pb.TagNumber(5)
  set breached($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBreached() => $_has(4);
  @$pb.TagNumber(5)
  void clearBreached() => $_clearField(5);
}

class Pathway extends $pb.GeneratedMessage {
  factory Pathway({
    $core.String? pathwayId,
    $core.String? visitId,
    PathwayKind? kind,
    $core.String? label,
    $0.Timestamp? activatedAt,
    $core.String? activatedBy,
    $core.String? notifiedTeam,
    $core.String? escalationNoticeId,
    $core.Iterable<MilestoneTarget>? targets,
    $0.Timestamp? stoodDownAt,
    $core.String? stoodDownReason,
  }) {
    final result = create();
    if (pathwayId != null) result.pathwayId = pathwayId;
    if (visitId != null) result.visitId = visitId;
    if (kind != null) result.kind = kind;
    if (label != null) result.label = label;
    if (activatedAt != null) result.activatedAt = activatedAt;
    if (activatedBy != null) result.activatedBy = activatedBy;
    if (notifiedTeam != null) result.notifiedTeam = notifiedTeam;
    if (escalationNoticeId != null)
      result.escalationNoticeId = escalationNoticeId;
    if (targets != null) result.targets.addAll(targets);
    if (stoodDownAt != null) result.stoodDownAt = stoodDownAt;
    if (stoodDownReason != null) result.stoodDownReason = stoodDownReason;
    return result;
  }

  Pathway._();

  factory Pathway.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Pathway.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Pathway',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'pathwayId')
    ..aOS(2, _omitFieldNames ? '' : 'visitId')
    ..aE<PathwayKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: PathwayKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'label')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'activatedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'activatedBy')
    ..aOS(7, _omitFieldNames ? '' : 'notifiedTeam')
    ..aOS(8, _omitFieldNames ? '' : 'escalationNoticeId')
    ..pPM<MilestoneTarget>(9, _omitFieldNames ? '' : 'targets',
        subBuilder: MilestoneTarget.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'stoodDownAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'stoodDownReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Pathway clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Pathway copyWith(void Function(Pathway) updates) =>
      super.copyWith((message) => updates(message as Pathway)) as Pathway;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Pathway create() => Pathway._();
  @$core.override
  Pathway createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Pathway getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Pathway>(create);
  static Pathway? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pathwayId => $_getSZ(0);
  @$pb.TagNumber(1)
  set pathwayId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPathwayId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPathwayId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get visitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set visitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVisitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVisitId() => $_clearField(2);

  @$pb.TagNumber(3)
  PathwayKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(PathwayKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  /// Names a locally defined pathway.
  @$pb.TagNumber(4)
  $core.String get label => $_getSZ(3);
  @$pb.TagNumber(4)
  set label($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLabel() => $_has(3);
  @$pb.TagNumber(4)
  void clearLabel() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get activatedAt => $_getN(4);
  @$pb.TagNumber(5)
  set activatedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasActivatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearActivatedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureActivatedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get activatedBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set activatedBy($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasActivatedBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearActivatedBy() => $_clearField(6);

  /// Who was called. The commonest failure in a time-critical pathway is not
  /// that nobody activated it — it is that the team nobody called did not come.
  @$pb.TagNumber(7)
  $core.String get notifiedTeam => $_getSZ(6);
  @$pb.TagNumber(7)
  set notifiedTeam($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNotifiedTeam() => $_has(6);
  @$pb.TagNumber(7)
  void clearNotifiedTeam() => $_clearField(7);

  /// The durable notice carrying the call (SRS-OPSNFR-003). Empty where the
  /// department activates by shouting across the resus room.
  @$pb.TagNumber(8)
  $core.String get escalationNoticeId => $_getSZ(7);
  @$pb.TagNumber(8)
  set escalationNoticeId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEscalationNoticeId() => $_has(7);
  @$pb.TagNumber(8)
  void clearEscalationNoticeId() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<MilestoneTarget> get targets => $_getList(8);

  @$pb.TagNumber(10)
  $0.Timestamp get stoodDownAt => $_getN(9);
  @$pb.TagNumber(10)
  set stoodDownAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStoodDownAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearStoodDownAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureStoodDownAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get stoodDownReason => $_getSZ(10);
  @$pb.TagNumber(11)
  set stoodDownReason($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasStoodDownReason() => $_has(10);
  @$pb.TagNumber(11)
  void clearStoodDownReason() => $_clearField(11);
}

class EmergencyEvent extends $pb.GeneratedMessage {
  factory EmergencyEvent({
    $core.String? eventId,
    $core.String? visitId,
    EventKind? kind,
    $core.String? detail,
    $0.Timestamp? occurredAt,
    $0.Timestamp? recordedAt,
    $core.int? sequence,
    $core.String? actorId,
    $core.bool? late,
    $core.String? pathwayId,
    $core.String? protocolId,
    $core.bool? needsReconciliation,
    $core.String? reconciledOrderId,
  }) {
    final result = create();
    if (eventId != null) result.eventId = eventId;
    if (visitId != null) result.visitId = visitId;
    if (kind != null) result.kind = kind;
    if (detail != null) result.detail = detail;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (sequence != null) result.sequence = sequence;
    if (actorId != null) result.actorId = actorId;
    if (late != null) result.late = late;
    if (pathwayId != null) result.pathwayId = pathwayId;
    if (protocolId != null) result.protocolId = protocolId;
    if (needsReconciliation != null)
      result.needsReconciliation = needsReconciliation;
    if (reconciledOrderId != null) result.reconciledOrderId = reconciledOrderId;
    return result;
  }

  EmergencyEvent._();

  factory EmergencyEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmergencyEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmergencyEvent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'eventId')
    ..aOS(2, _omitFieldNames ? '' : 'visitId')
    ..aE<EventKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: EventKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'detail')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aI(7, _omitFieldNames ? '' : 'sequence')
    ..aOS(8, _omitFieldNames ? '' : 'actorId')
    ..aOB(9, _omitFieldNames ? '' : 'late')
    ..aOS(10, _omitFieldNames ? '' : 'pathwayId')
    ..aOS(11, _omitFieldNames ? '' : 'protocolId')
    ..aOB(12, _omitFieldNames ? '' : 'needsReconciliation')
    ..aOS(13, _omitFieldNames ? '' : 'reconciledOrderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmergencyEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmergencyEvent copyWith(void Function(EmergencyEvent) updates) =>
      super.copyWith((message) => updates(message as EmergencyEvent))
          as EmergencyEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmergencyEvent create() => EmergencyEvent._();
  @$core.override
  EmergencyEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmergencyEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmergencyEvent>(create);
  static EmergencyEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eventId => $_getSZ(0);
  @$pb.TagNumber(1)
  set eventId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEventId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get visitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set visitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVisitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVisitId() => $_clearField(2);

  @$pb.TagNumber(3)
  EventKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(EventKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get detail => $_getSZ(3);
  @$pb.TagNumber(4)
  set detail($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDetail() => $_has(3);
  @$pb.TagNumber(4)
  void clearDetail() => $_clearField(4);

  /// When it happened to the patient, and when somebody typed it.
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
  $0.Timestamp get recordedAt => $_getN(5);
  @$pb.TagNumber(6)
  set recordedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRecordedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecordedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureRecordedAt() => $_ensure(5);

  /// Breaks ties within a minute. A defibrillation and the rhythm check before
  /// it are frequently recorded at the same minute, and their order is the
  /// clinically interesting part.
  @$pb.TagNumber(7)
  $core.int get sequence => $_getIZ(6);
  @$pb.TagNumber(7)
  set sequence($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSequence() => $_has(6);
  @$pb.TagNumber(7)
  void clearSequence() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get actorId => $_getSZ(7);
  @$pb.TagNumber(8)
  set actorId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasActorId() => $_has(7);
  @$pb.TagNumber(8)
  void clearActorId() => $_clearField(8);

  /// Derived from the gap between the two timestamps. Travels so a client
  /// cannot render a reconstruction as a contemporaneous record.
  @$pb.TagNumber(9)
  $core.bool get late => $_getBF(8);
  @$pb.TagNumber(9)
  set late($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLate() => $_has(8);
  @$pb.TagNumber(9)
  void clearLate() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get pathwayId => $_getSZ(9);
  @$pb.TagNumber(10)
  set pathwayId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPathwayId() => $_has(9);
  @$pb.TagNumber(10)
  void clearPathwayId() => $_clearField(10);

  /// The standing order a pre-order administration was given under
  /// (SRS-ER-009).
  @$pb.TagNumber(11)
  $core.String get protocolId => $_getSZ(10);
  @$pb.TagNumber(11)
  set protocolId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasProtocolId() => $_has(10);
  @$pb.TagNumber(11)
  void clearProtocolId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get needsReconciliation => $_getBF(11);
  @$pb.TagNumber(12)
  set needsReconciliation($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasNeedsReconciliation() => $_has(11);
  @$pb.TagNumber(12)
  void clearNeedsReconciliation() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get reconciledOrderId => $_getSZ(12);
  @$pb.TagNumber(13)
  set reconciledOrderId($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasReconciledOrderId() => $_has(12);
  @$pb.TagNumber(13)
  void clearReconciledOrderId() => $_clearField(13);
}

/// The clocks SRS-ER-006 asks for, derived per response.
///
/// Every field optional: an absent door-to-doctor means nobody has seen the
/// patient, and a zero is the number that makes a dashboard look best while the
/// department is at its worst.
class Intervals extends $pb.GeneratedMessage {
  factory Intervals({
    $fixnum.Int64? doorToTriageSeconds,
    $fixnum.Int64? doorToClinicianSeconds,
    $fixnum.Int64? doorToDispositionSeconds,
  }) {
    final result = create();
    if (doorToTriageSeconds != null)
      result.doorToTriageSeconds = doorToTriageSeconds;
    if (doorToClinicianSeconds != null)
      result.doorToClinicianSeconds = doorToClinicianSeconds;
    if (doorToDispositionSeconds != null)
      result.doorToDispositionSeconds = doorToDispositionSeconds;
    return result;
  }

  Intervals._();

  factory Intervals.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Intervals.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Intervals',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'doorToTriageSeconds')
    ..aInt64(2, _omitFieldNames ? '' : 'doorToClinicianSeconds')
    ..aInt64(3, _omitFieldNames ? '' : 'doorToDispositionSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Intervals clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Intervals copyWith(void Function(Intervals) updates) =>
      super.copyWith((message) => updates(message as Intervals)) as Intervals;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Intervals create() => Intervals._();
  @$core.override
  Intervals createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Intervals getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Intervals>(create);
  static Intervals? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get doorToTriageSeconds => $_getI64(0);
  @$pb.TagNumber(1)
  set doorToTriageSeconds($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDoorToTriageSeconds() => $_has(0);
  @$pb.TagNumber(1)
  void clearDoorToTriageSeconds() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get doorToClinicianSeconds => $_getI64(1);
  @$pb.TagNumber(2)
  set doorToClinicianSeconds($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDoorToClinicianSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearDoorToClinicianSeconds() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get doorToDispositionSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set doorToDispositionSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDoorToDispositionSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearDoorToDispositionSeconds() => $_clearField(3);
}

/// One line of the status board (SRS-ER-012).
class BoardRow extends $pb.GeneratedMessage {
  factory BoardRow({
    $core.String? visitId,
    $core.String? display,
    $core.int? acuityRank,
    $core.String? scaleName,
    $core.bool? triaged,
    $0.Timestamp? arrivedAt,
    VisitStatus? status,
    $core.String? location,
    PriorityOverride? override,
    $core.int? pendingOrders,
    $core.String? dispositionBarrier,
    $core.Iterable<PathwayKind>? pathways,
    $fixnum.Int64? waitingSeconds,
    $core.bool? breaching,
    $core.bool? observationOverdue,
    $core.bool? restricted,
  }) {
    final result = create();
    if (visitId != null) result.visitId = visitId;
    if (display != null) result.display = display;
    if (acuityRank != null) result.acuityRank = acuityRank;
    if (scaleName != null) result.scaleName = scaleName;
    if (triaged != null) result.triaged = triaged;
    if (arrivedAt != null) result.arrivedAt = arrivedAt;
    if (status != null) result.status = status;
    if (location != null) result.location = location;
    if (override != null) result.override = override;
    if (pendingOrders != null) result.pendingOrders = pendingOrders;
    if (dispositionBarrier != null)
      result.dispositionBarrier = dispositionBarrier;
    if (pathways != null) result.pathways.addAll(pathways);
    if (waitingSeconds != null) result.waitingSeconds = waitingSeconds;
    if (breaching != null) result.breaching = breaching;
    if (observationOverdue != null)
      result.observationOverdue = observationOverdue;
    if (restricted != null) result.restricted = restricted;
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
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'visitId')
    ..aOS(2, _omitFieldNames ? '' : 'display')
    ..aI(3, _omitFieldNames ? '' : 'acuityRank')
    ..aOS(4, _omitFieldNames ? '' : 'scaleName')
    ..aOB(5, _omitFieldNames ? '' : 'triaged')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'arrivedAt',
        subBuilder: $0.Timestamp.create)
    ..aE<VisitStatus>(7, _omitFieldNames ? '' : 'status',
        enumValues: VisitStatus.values)
    ..aOS(8, _omitFieldNames ? '' : 'location')
    ..aOM<PriorityOverride>(9, _omitFieldNames ? '' : 'override',
        subBuilder: PriorityOverride.create)
    ..aI(10, _omitFieldNames ? '' : 'pendingOrders')
    ..aOS(11, _omitFieldNames ? '' : 'dispositionBarrier')
    ..pc<PathwayKind>(12, _omitFieldNames ? '' : 'pathways', $pb.PbFieldType.KE,
        valueOf: PathwayKind.valueOf,
        enumValues: PathwayKind.values,
        defaultEnumValue: PathwayKind.PATHWAY_KIND_UNSPECIFIED)
    ..aInt64(13, _omitFieldNames ? '' : 'waitingSeconds')
    ..aOB(14, _omitFieldNames ? '' : 'breaching')
    ..aOB(15, _omitFieldNames ? '' : 'observationOverdue')
    ..aOB(16, _omitFieldNames ? '' : 'restricted')
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
  $core.String get visitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set visitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVisitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisitId() => $_clearField(1);

  /// The patient's name, or the temporary one, or "Restricted".
  @$pb.TagNumber(2)
  $core.String get display => $_getSZ(1);
  @$pb.TagNumber(2)
  set display($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplay() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplay() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get acuityRank => $_getIZ(2);
  @$pb.TagNumber(3)
  set acuityRank($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAcuityRank() => $_has(2);
  @$pb.TagNumber(3)
  void clearAcuityRank() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get scaleName => $_getSZ(3);
  @$pb.TagNumber(4)
  set scaleName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScaleName() => $_has(3);
  @$pb.TagNumber(4)
  void clearScaleName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get triaged => $_getBF(4);
  @$pb.TagNumber(5)
  set triaged($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTriaged() => $_has(4);
  @$pb.TagNumber(5)
  void clearTriaged() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get arrivedAt => $_getN(5);
  @$pb.TagNumber(6)
  set arrivedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasArrivedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearArrivedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureArrivedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  VisitStatus get status => $_getN(6);
  @$pb.TagNumber(7)
  set status(VisitStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get location => $_getSZ(7);
  @$pb.TagNumber(8)
  set location($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLocation() => $_has(7);
  @$pb.TagNumber(8)
  void clearLocation() => $_clearField(8);

  @$pb.TagNumber(9)
  PriorityOverride get override => $_getN(8);
  @$pb.TagNumber(9)
  set override(PriorityOverride value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasOverride() => $_has(8);
  @$pb.TagNumber(9)
  void clearOverride() => $_clearField(9);
  @$pb.TagNumber(9)
  PriorityOverride ensureOverride() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.int get pendingOrders => $_getIZ(9);
  @$pb.TagNumber(10)
  set pendingOrders($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPendingOrders() => $_has(9);
  @$pb.TagNumber(10)
  void clearPendingOrders() => $_clearField(10);

  /// The one thing stopping this patient leaving. The board's most useful
  /// column, because a department's flow problem is almost never the doctors.
  @$pb.TagNumber(11)
  $core.String get dispositionBarrier => $_getSZ(10);
  @$pb.TagNumber(11)
  set dispositionBarrier($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDispositionBarrier() => $_has(10);
  @$pb.TagNumber(11)
  void clearDispositionBarrier() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<PathwayKind> get pathways => $_getList(11);

  @$pb.TagNumber(13)
  $fixnum.Int64 get waitingSeconds => $_getI64(12);
  @$pb.TagNumber(13)
  set waitingSeconds($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(13)
  $core.bool hasWaitingSeconds() => $_has(12);
  @$pb.TagNumber(13)
  void clearWaitingSeconds() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get breaching => $_getBF(13);
  @$pb.TagNumber(14)
  set breaching($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasBreaching() => $_has(13);
  @$pb.TagNumber(14)
  void clearBreaching() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.bool get observationOverdue => $_getBF(14);
  @$pb.TagNumber(15)
  set observationOverdue($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasObservationOverdue() => $_has(14);
  @$pb.TagNumber(15)
  void clearObservationOverdue() => $_clearField(15);

  /// Shown in redacted form. The bed, the acuity and the clock stay; the
  /// identity and the barrier go.
  @$pb.TagNumber(16)
  $core.bool get restricted => $_getBF(15);
  @$pb.TagNumber(16)
  set restricted($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(16)
  $core.bool hasRestricted() => $_has(15);
  @$pb.TagNumber(16)
  void clearRestricted() => $_clearField(16);
}

class ArriveRequest extends $pb.GeneratedMessage {
  factory ArriveRequest({
    $core.String? encounterId,
    $core.String? patientId,
    $core.String? facilityId,
    ArrivalMode? arrivalMode,
    $core.String? chiefComplaint,
    $0.Timestamp? arrivedAt,
    $core.bool? unidentified,
    $core.String? temporaryName,
    $core.bool? medicoLegal,
    $core.String? medicoLegalRef,
    $core.String? location,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (facilityId != null) result.facilityId = facilityId;
    if (arrivalMode != null) result.arrivalMode = arrivalMode;
    if (chiefComplaint != null) result.chiefComplaint = chiefComplaint;
    if (arrivedAt != null) result.arrivedAt = arrivedAt;
    if (unidentified != null) result.unidentified = unidentified;
    if (temporaryName != null) result.temporaryName = temporaryName;
    if (medicoLegal != null) result.medicoLegal = medicoLegal;
    if (medicoLegalRef != null) result.medicoLegalRef = medicoLegalRef;
    if (location != null) result.location = location;
    return result;
  }

  ArriveRequest._();

  factory ArriveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ArriveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArriveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aE<ArrivalMode>(4, _omitFieldNames ? '' : 'arrivalMode',
        enumValues: ArrivalMode.values)
    ..aOS(5, _omitFieldNames ? '' : 'chiefComplaint')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'arrivedAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(7, _omitFieldNames ? '' : 'unidentified')
    ..aOS(8, _omitFieldNames ? '' : 'temporaryName')
    ..aOB(9, _omitFieldNames ? '' : 'medicoLegal')
    ..aOS(10, _omitFieldNames ? '' : 'medicoLegalRef')
    ..aOS(11, _omitFieldNames ? '' : 'location')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArriveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArriveRequest copyWith(void Function(ArriveRequest) updates) =>
      super.copyWith((message) => updates(message as ArriveRequest))
          as ArriveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ArriveRequest create() => ArriveRequest._();
  @$core.override
  ArriveRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ArriveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArriveRequest>(create);
  static ArriveRequest? _defaultInstance;

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
  ArrivalMode get arrivalMode => $_getN(3);
  @$pb.TagNumber(4)
  set arrivalMode(ArrivalMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasArrivalMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearArrivalMode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get chiefComplaint => $_getSZ(4);
  @$pb.TagNumber(5)
  set chiefComplaint($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasChiefComplaint() => $_has(4);
  @$pb.TagNumber(5)
  void clearChiefComplaint() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get arrivedAt => $_getN(5);
  @$pb.TagNumber(6)
  set arrivedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasArrivedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearArrivedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureArrivedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.bool get unidentified => $_getBF(6);
  @$pb.TagNumber(7)
  set unidentified($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUnidentified() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnidentified() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get temporaryName => $_getSZ(7);
  @$pb.TagNumber(8)
  set temporaryName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTemporaryName() => $_has(7);
  @$pb.TagNumber(8)
  void clearTemporaryName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get medicoLegal => $_getBF(8);
  @$pb.TagNumber(9)
  set medicoLegal($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMedicoLegal() => $_has(8);
  @$pb.TagNumber(9)
  void clearMedicoLegal() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get medicoLegalRef => $_getSZ(9);
  @$pb.TagNumber(10)
  set medicoLegalRef($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMedicoLegalRef() => $_has(9);
  @$pb.TagNumber(10)
  void clearMedicoLegalRef() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get location => $_getSZ(10);
  @$pb.TagNumber(11)
  set location($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasLocation() => $_has(10);
  @$pb.TagNumber(11)
  void clearLocation() => $_clearField(11);
}

class ArriveResponse extends $pb.GeneratedMessage {
  factory ArriveResponse({
    EmergencyVisit? visit,
  }) {
    final result = create();
    if (visit != null) result.visit = visit;
    return result;
  }

  ArriveResponse._();

  factory ArriveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ArriveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArriveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOM<EmergencyVisit>(1, _omitFieldNames ? '' : 'visit',
        subBuilder: EmergencyVisit.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArriveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArriveResponse copyWith(void Function(ArriveResponse) updates) =>
      super.copyWith((message) => updates(message as ArriveResponse))
          as ArriveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ArriveResponse create() => ArriveResponse._();
  @$core.override
  ArriveResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ArriveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArriveResponse>(create);
  static ArriveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EmergencyVisit get visit => $_getN(0);
  @$pb.TagNumber(1)
  set visit(EmergencyVisit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVisit() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisit() => $_clearField(1);
  @$pb.TagNumber(1)
  EmergencyVisit ensureVisit() => $_ensure(0);
}

class GetEmergencyVisitRequest extends $pb.GeneratedMessage {
  factory GetEmergencyVisitRequest({
    $core.String? visitId,
  }) {
    final result = create();
    if (visitId != null) result.visitId = visitId;
    return result;
  }

  GetEmergencyVisitRequest._();

  factory GetEmergencyVisitRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetEmergencyVisitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetEmergencyVisitRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'visitId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEmergencyVisitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEmergencyVisitRequest copyWith(
          void Function(GetEmergencyVisitRequest) updates) =>
      super.copyWith((message) => updates(message as GetEmergencyVisitRequest))
          as GetEmergencyVisitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetEmergencyVisitRequest create() => GetEmergencyVisitRequest._();
  @$core.override
  GetEmergencyVisitRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetEmergencyVisitRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetEmergencyVisitRequest>(create);
  static GetEmergencyVisitRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get visitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set visitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVisitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisitId() => $_clearField(1);
}

class GetEmergencyVisitResponse extends $pb.GeneratedMessage {
  factory GetEmergencyVisitResponse({
    EmergencyVisit? visit,
    $core.Iterable<Triage>? triage,
    $core.Iterable<Pathway>? pathways,
    $core.Iterable<$core.MapEntry<$core.String, MilestoneProgress>>? progress,
    $core.Iterable<EmergencyEvent>? timeline,
    Intervals? intervals,
  }) {
    final result = create();
    if (visit != null) result.visit = visit;
    if (triage != null) result.triage.addAll(triage);
    if (pathways != null) result.pathways.addAll(pathways);
    if (progress != null) result.progress.addEntries(progress);
    if (timeline != null) result.timeline.addAll(timeline);
    if (intervals != null) result.intervals = intervals;
    return result;
  }

  GetEmergencyVisitResponse._();

  factory GetEmergencyVisitResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetEmergencyVisitResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetEmergencyVisitResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOM<EmergencyVisit>(1, _omitFieldNames ? '' : 'visit',
        subBuilder: EmergencyVisit.create)
    ..pPM<Triage>(2, _omitFieldNames ? '' : 'triage', subBuilder: Triage.create)
    ..pPM<Pathway>(3, _omitFieldNames ? '' : 'pathways',
        subBuilder: Pathway.create)
    ..m<$core.String, MilestoneProgress>(4, _omitFieldNames ? '' : 'progress',
        entryClassName: 'GetEmergencyVisitResponse.ProgressEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: MilestoneProgress.create,
        valueDefaultOrMaker: MilestoneProgress.getDefault,
        packageName: const $pb.PackageName('healthcare.emergency.v1'))
    ..pPM<EmergencyEvent>(5, _omitFieldNames ? '' : 'timeline',
        subBuilder: EmergencyEvent.create)
    ..aOM<Intervals>(6, _omitFieldNames ? '' : 'intervals',
        subBuilder: Intervals.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEmergencyVisitResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEmergencyVisitResponse copyWith(
          void Function(GetEmergencyVisitResponse) updates) =>
      super.copyWith((message) => updates(message as GetEmergencyVisitResponse))
          as GetEmergencyVisitResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetEmergencyVisitResponse create() => GetEmergencyVisitResponse._();
  @$core.override
  GetEmergencyVisitResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetEmergencyVisitResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetEmergencyVisitResponse>(create);
  static GetEmergencyVisitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EmergencyVisit get visit => $_getN(0);
  @$pb.TagNumber(1)
  set visit(EmergencyVisit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVisit() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisit() => $_clearField(1);
  @$pb.TagNumber(1)
  EmergencyVisit ensureVisit() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Triage> get triage => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<Pathway> get pathways => $_getList(2);

  /// Keyed by pathway id.
  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, MilestoneProgress> get progress => $_getMap(3);

  @$pb.TagNumber(5)
  $pb.PbList<EmergencyEvent> get timeline => $_getList(4);

  @$pb.TagNumber(6)
  Intervals get intervals => $_getN(5);
  @$pb.TagNumber(6)
  set intervals(Intervals value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasIntervals() => $_has(5);
  @$pb.TagNumber(6)
  void clearIntervals() => $_clearField(6);
  @$pb.TagNumber(6)
  Intervals ensureIntervals() => $_ensure(5);
}

class MilestoneProgress extends $pb.GeneratedMessage {
  factory MilestoneProgress({
    $core.Iterable<MilestoneState>? states,
  }) {
    final result = create();
    if (states != null) result.states.addAll(states);
    return result;
  }

  MilestoneProgress._();

  factory MilestoneProgress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MilestoneProgress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MilestoneProgress',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..pPM<MilestoneState>(1, _omitFieldNames ? '' : 'states',
        subBuilder: MilestoneState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MilestoneProgress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MilestoneProgress copyWith(void Function(MilestoneProgress) updates) =>
      super.copyWith((message) => updates(message as MilestoneProgress))
          as MilestoneProgress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MilestoneProgress create() => MilestoneProgress._();
  @$core.override
  MilestoneProgress createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MilestoneProgress getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MilestoneProgress>(create);
  static MilestoneProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MilestoneState> get states => $_getList(0);
}

class IdentifyPatientRequest extends $pb.GeneratedMessage {
  factory IdentifyPatientRequest({
    $core.String? visitId,
    $core.String? patientId,
  }) {
    final result = create();
    if (visitId != null) result.visitId = visitId;
    if (patientId != null) result.patientId = patientId;
    return result;
  }

  IdentifyPatientRequest._();

  factory IdentifyPatientRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IdentifyPatientRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdentifyPatientRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'visitId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentifyPatientRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentifyPatientRequest copyWith(
          void Function(IdentifyPatientRequest) updates) =>
      super.copyWith((message) => updates(message as IdentifyPatientRequest))
          as IdentifyPatientRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IdentifyPatientRequest create() => IdentifyPatientRequest._();
  @$core.override
  IdentifyPatientRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IdentifyPatientRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdentifyPatientRequest>(create);
  static IdentifyPatientRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get visitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set visitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVisitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);
}

class IdentifyPatientResponse extends $pb.GeneratedMessage {
  factory IdentifyPatientResponse({
    EmergencyVisit? visit,
  }) {
    final result = create();
    if (visit != null) result.visit = visit;
    return result;
  }

  IdentifyPatientResponse._();

  factory IdentifyPatientResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IdentifyPatientResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdentifyPatientResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOM<EmergencyVisit>(1, _omitFieldNames ? '' : 'visit',
        subBuilder: EmergencyVisit.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentifyPatientResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentifyPatientResponse copyWith(
          void Function(IdentifyPatientResponse) updates) =>
      super.copyWith((message) => updates(message as IdentifyPatientResponse))
          as IdentifyPatientResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IdentifyPatientResponse create() => IdentifyPatientResponse._();
  @$core.override
  IdentifyPatientResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IdentifyPatientResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdentifyPatientResponse>(create);
  static IdentifyPatientResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EmergencyVisit get visit => $_getN(0);
  @$pb.TagNumber(1)
  set visit(EmergencyVisit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVisit() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisit() => $_clearField(1);
  @$pb.TagNumber(1)
  EmergencyVisit ensureVisit() => $_ensure(0);
}

class AssignTriageRequest extends $pb.GeneratedMessage {
  factory AssignTriageRequest({
    $core.String? visitId,
    $core.String? acuityCode,
    $core.int? respiratoryRate,
    $core.int? heartRate,
    $core.int? systolicBp,
    $core.int? oxygenSaturation,
    $core.double? temperature,
    $core.int? painScore,
    $core.String? consciousness,
    $core.Iterable<$core.String>? redFlags,
    $core.String? note,
  }) {
    final result = create();
    if (visitId != null) result.visitId = visitId;
    if (acuityCode != null) result.acuityCode = acuityCode;
    if (respiratoryRate != null) result.respiratoryRate = respiratoryRate;
    if (heartRate != null) result.heartRate = heartRate;
    if (systolicBp != null) result.systolicBp = systolicBp;
    if (oxygenSaturation != null) result.oxygenSaturation = oxygenSaturation;
    if (temperature != null) result.temperature = temperature;
    if (painScore != null) result.painScore = painScore;
    if (consciousness != null) result.consciousness = consciousness;
    if (redFlags != null) result.redFlags.addAll(redFlags);
    if (note != null) result.note = note;
    return result;
  }

  AssignTriageRequest._();

  factory AssignTriageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssignTriageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssignTriageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'visitId')
    ..aOS(2, _omitFieldNames ? '' : 'acuityCode')
    ..aI(3, _omitFieldNames ? '' : 'respiratoryRate')
    ..aI(4, _omitFieldNames ? '' : 'heartRate')
    ..aI(5, _omitFieldNames ? '' : 'systolicBp')
    ..aI(6, _omitFieldNames ? '' : 'oxygenSaturation')
    ..aD(7, _omitFieldNames ? '' : 'temperature')
    ..aI(8, _omitFieldNames ? '' : 'painScore')
    ..aOS(9, _omitFieldNames ? '' : 'consciousness')
    ..pPS(10, _omitFieldNames ? '' : 'redFlags')
    ..aOS(11, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignTriageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignTriageRequest copyWith(void Function(AssignTriageRequest) updates) =>
      super.copyWith((message) => updates(message as AssignTriageRequest))
          as AssignTriageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignTriageRequest create() => AssignTriageRequest._();
  @$core.override
  AssignTriageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssignTriageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssignTriageRequest>(create);
  static AssignTriageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get visitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set visitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVisitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get acuityCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set acuityCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAcuityCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearAcuityCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get respiratoryRate => $_getIZ(2);
  @$pb.TagNumber(3)
  set respiratoryRate($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRespiratoryRate() => $_has(2);
  @$pb.TagNumber(3)
  void clearRespiratoryRate() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get heartRate => $_getIZ(3);
  @$pb.TagNumber(4)
  set heartRate($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHeartRate() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeartRate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get systolicBp => $_getIZ(4);
  @$pb.TagNumber(5)
  set systolicBp($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSystolicBp() => $_has(4);
  @$pb.TagNumber(5)
  void clearSystolicBp() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get oxygenSaturation => $_getIZ(5);
  @$pb.TagNumber(6)
  set oxygenSaturation($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOxygenSaturation() => $_has(5);
  @$pb.TagNumber(6)
  void clearOxygenSaturation() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get temperature => $_getN(6);
  @$pb.TagNumber(7)
  set temperature($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTemperature() => $_has(6);
  @$pb.TagNumber(7)
  void clearTemperature() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get painScore => $_getIZ(7);
  @$pb.TagNumber(8)
  set painScore($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPainScore() => $_has(7);
  @$pb.TagNumber(8)
  void clearPainScore() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get consciousness => $_getSZ(8);
  @$pb.TagNumber(9)
  set consciousness($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasConsciousness() => $_has(8);
  @$pb.TagNumber(9)
  void clearConsciousness() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get redFlags => $_getList(9);

  @$pb.TagNumber(11)
  $core.String get note => $_getSZ(10);
  @$pb.TagNumber(11)
  set note($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNote() => $_has(10);
  @$pb.TagNumber(11)
  void clearNote() => $_clearField(11);
}

class AssignTriageResponse extends $pb.GeneratedMessage {
  factory AssignTriageResponse({
    Triage? triage,
  }) {
    final result = create();
    if (triage != null) result.triage = triage;
    return result;
  }

  AssignTriageResponse._();

  factory AssignTriageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssignTriageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssignTriageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOM<Triage>(1, _omitFieldNames ? '' : 'triage', subBuilder: Triage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignTriageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignTriageResponse copyWith(void Function(AssignTriageResponse) updates) =>
      super.copyWith((message) => updates(message as AssignTriageResponse))
          as AssignTriageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignTriageResponse create() => AssignTriageResponse._();
  @$core.override
  AssignTriageResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssignTriageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssignTriageResponse>(create);
  static AssignTriageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Triage get triage => $_getN(0);
  @$pb.TagNumber(1)
  set triage(Triage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTriage() => $_has(0);
  @$pb.TagNumber(1)
  void clearTriage() => $_clearField(1);
  @$pb.TagNumber(1)
  Triage ensureTriage() => $_ensure(0);
}

class OverridePriorityRequest extends $pb.GeneratedMessage {
  factory OverridePriorityRequest({
    $core.String? visitId,
    $core.int? acuityRank,
    $core.String? reason,
  }) {
    final result = create();
    if (visitId != null) result.visitId = visitId;
    if (acuityRank != null) result.acuityRank = acuityRank;
    if (reason != null) result.reason = reason;
    return result;
  }

  OverridePriorityRequest._();

  factory OverridePriorityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OverridePriorityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OverridePriorityRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'visitId')
    ..aI(2, _omitFieldNames ? '' : 'acuityRank')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverridePriorityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverridePriorityRequest copyWith(
          void Function(OverridePriorityRequest) updates) =>
      super.copyWith((message) => updates(message as OverridePriorityRequest))
          as OverridePriorityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OverridePriorityRequest create() => OverridePriorityRequest._();
  @$core.override
  OverridePriorityRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OverridePriorityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OverridePriorityRequest>(create);
  static OverridePriorityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get visitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set visitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVisitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get acuityRank => $_getIZ(1);
  @$pb.TagNumber(2)
  set acuityRank($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAcuityRank() => $_has(1);
  @$pb.TagNumber(2)
  void clearAcuityRank() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class OverridePriorityResponse extends $pb.GeneratedMessage {
  factory OverridePriorityResponse() => create();

  OverridePriorityResponse._();

  factory OverridePriorityResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OverridePriorityResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OverridePriorityResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverridePriorityResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverridePriorityResponse copyWith(
          void Function(OverridePriorityResponse) updates) =>
      super.copyWith((message) => updates(message as OverridePriorityResponse))
          as OverridePriorityResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OverridePriorityResponse create() => OverridePriorityResponse._();
  @$core.override
  OverridePriorityResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OverridePriorityResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OverridePriorityResponse>(create);
  static OverridePriorityResponse? _defaultInstance;
}

class ActivatePathwayRequest extends $pb.GeneratedMessage {
  factory ActivatePathwayRequest({
    $core.String? visitId,
    PathwayKind? kind,
    $core.String? label,
    $core.String? notifiedTeam,
  }) {
    final result = create();
    if (visitId != null) result.visitId = visitId;
    if (kind != null) result.kind = kind;
    if (label != null) result.label = label;
    if (notifiedTeam != null) result.notifiedTeam = notifiedTeam;
    return result;
  }

  ActivatePathwayRequest._();

  factory ActivatePathwayRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ActivatePathwayRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActivatePathwayRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'visitId')
    ..aE<PathwayKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: PathwayKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'label')
    ..aOS(4, _omitFieldNames ? '' : 'notifiedTeam')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivatePathwayRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivatePathwayRequest copyWith(
          void Function(ActivatePathwayRequest) updates) =>
      super.copyWith((message) => updates(message as ActivatePathwayRequest))
          as ActivatePathwayRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActivatePathwayRequest create() => ActivatePathwayRequest._();
  @$core.override
  ActivatePathwayRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ActivatePathwayRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ActivatePathwayRequest>(create);
  static ActivatePathwayRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get visitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set visitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVisitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisitId() => $_clearField(1);

  @$pb.TagNumber(2)
  PathwayKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(PathwayKind value) => $_setField(2, value);
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
  $core.String get notifiedTeam => $_getSZ(3);
  @$pb.TagNumber(4)
  set notifiedTeam($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNotifiedTeam() => $_has(3);
  @$pb.TagNumber(4)
  void clearNotifiedTeam() => $_clearField(4);
}

class ActivatePathwayResponse extends $pb.GeneratedMessage {
  factory ActivatePathwayResponse({
    Pathway? pathway,
  }) {
    final result = create();
    if (pathway != null) result.pathway = pathway;
    return result;
  }

  ActivatePathwayResponse._();

  factory ActivatePathwayResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ActivatePathwayResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActivatePathwayResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOM<Pathway>(1, _omitFieldNames ? '' : 'pathway',
        subBuilder: Pathway.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivatePathwayResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivatePathwayResponse copyWith(
          void Function(ActivatePathwayResponse) updates) =>
      super.copyWith((message) => updates(message as ActivatePathwayResponse))
          as ActivatePathwayResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActivatePathwayResponse create() => ActivatePathwayResponse._();
  @$core.override
  ActivatePathwayResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ActivatePathwayResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ActivatePathwayResponse>(create);
  static ActivatePathwayResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Pathway get pathway => $_getN(0);
  @$pb.TagNumber(1)
  set pathway(Pathway value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPathway() => $_has(0);
  @$pb.TagNumber(1)
  void clearPathway() => $_clearField(1);
  @$pb.TagNumber(1)
  Pathway ensurePathway() => $_ensure(0);
}

class StandDownPathwayRequest extends $pb.GeneratedMessage {
  factory StandDownPathwayRequest({
    $core.String? pathwayId,
    $core.String? reason,
  }) {
    final result = create();
    if (pathwayId != null) result.pathwayId = pathwayId;
    if (reason != null) result.reason = reason;
    return result;
  }

  StandDownPathwayRequest._();

  factory StandDownPathwayRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StandDownPathwayRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StandDownPathwayRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'pathwayId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StandDownPathwayRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StandDownPathwayRequest copyWith(
          void Function(StandDownPathwayRequest) updates) =>
      super.copyWith((message) => updates(message as StandDownPathwayRequest))
          as StandDownPathwayRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StandDownPathwayRequest create() => StandDownPathwayRequest._();
  @$core.override
  StandDownPathwayRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StandDownPathwayRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StandDownPathwayRequest>(create);
  static StandDownPathwayRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pathwayId => $_getSZ(0);
  @$pb.TagNumber(1)
  set pathwayId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPathwayId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPathwayId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class StandDownPathwayResponse extends $pb.GeneratedMessage {
  factory StandDownPathwayResponse() => create();

  StandDownPathwayResponse._();

  factory StandDownPathwayResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StandDownPathwayResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StandDownPathwayResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StandDownPathwayResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StandDownPathwayResponse copyWith(
          void Function(StandDownPathwayResponse) updates) =>
      super.copyWith((message) => updates(message as StandDownPathwayResponse))
          as StandDownPathwayResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StandDownPathwayResponse create() => StandDownPathwayResponse._();
  @$core.override
  StandDownPathwayResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StandDownPathwayResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StandDownPathwayResponse>(create);
  static StandDownPathwayResponse? _defaultInstance;
}

class RecordEmergencyEventRequest extends $pb.GeneratedMessage {
  factory RecordEmergencyEventRequest({
    $core.String? visitId,
    EventKind? kind,
    $core.String? detail,
    $0.Timestamp? occurredAt,
    $core.int? sequence,
    $core.String? pathwayId,
    $core.String? protocolId,
    $core.bool? preOrder,
  }) {
    final result = create();
    if (visitId != null) result.visitId = visitId;
    if (kind != null) result.kind = kind;
    if (detail != null) result.detail = detail;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (sequence != null) result.sequence = sequence;
    if (pathwayId != null) result.pathwayId = pathwayId;
    if (protocolId != null) result.protocolId = protocolId;
    if (preOrder != null) result.preOrder = preOrder;
    return result;
  }

  RecordEmergencyEventRequest._();

  factory RecordEmergencyEventRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordEmergencyEventRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordEmergencyEventRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'visitId')
    ..aE<EventKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: EventKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'detail')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aI(5, _omitFieldNames ? '' : 'sequence')
    ..aOS(6, _omitFieldNames ? '' : 'pathwayId')
    ..aOS(7, _omitFieldNames ? '' : 'protocolId')
    ..aOB(8, _omitFieldNames ? '' : 'preOrder')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordEmergencyEventRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordEmergencyEventRequest copyWith(
          void Function(RecordEmergencyEventRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RecordEmergencyEventRequest))
          as RecordEmergencyEventRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordEmergencyEventRequest create() =>
      RecordEmergencyEventRequest._();
  @$core.override
  RecordEmergencyEventRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordEmergencyEventRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordEmergencyEventRequest>(create);
  static RecordEmergencyEventRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get visitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set visitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVisitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisitId() => $_clearField(1);

  @$pb.TagNumber(2)
  EventKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(EventKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get detail => $_getSZ(2);
  @$pb.TagNumber(3)
  set detail($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDetail() => $_has(2);
  @$pb.TagNumber(3)
  void clearDetail() => $_clearField(3);

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
  $core.int get sequence => $_getIZ(4);
  @$pb.TagNumber(5)
  set sequence($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSequence() => $_has(4);
  @$pb.TagNumber(5)
  void clearSequence() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get pathwayId => $_getSZ(5);
  @$pb.TagNumber(6)
  set pathwayId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPathwayId() => $_has(5);
  @$pb.TagNumber(6)
  void clearPathwayId() => $_clearField(6);

  /// A medication given under a standing order before the order existed
  /// (SRS-ER-009). The protocol is required when pre_order is set.
  @$pb.TagNumber(7)
  $core.String get protocolId => $_getSZ(6);
  @$pb.TagNumber(7)
  set protocolId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasProtocolId() => $_has(6);
  @$pb.TagNumber(7)
  void clearProtocolId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get preOrder => $_getBF(7);
  @$pb.TagNumber(8)
  set preOrder($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPreOrder() => $_has(7);
  @$pb.TagNumber(8)
  void clearPreOrder() => $_clearField(8);
}

class RecordEmergencyEventResponse extends $pb.GeneratedMessage {
  factory RecordEmergencyEventResponse({
    EmergencyEvent? event,
  }) {
    final result = create();
    if (event != null) result.event = event;
    return result;
  }

  RecordEmergencyEventResponse._();

  factory RecordEmergencyEventResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordEmergencyEventResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordEmergencyEventResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOM<EmergencyEvent>(1, _omitFieldNames ? '' : 'event',
        subBuilder: EmergencyEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordEmergencyEventResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordEmergencyEventResponse copyWith(
          void Function(RecordEmergencyEventResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RecordEmergencyEventResponse))
          as RecordEmergencyEventResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordEmergencyEventResponse create() =>
      RecordEmergencyEventResponse._();
  @$core.override
  RecordEmergencyEventResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordEmergencyEventResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordEmergencyEventResponse>(create);
  static RecordEmergencyEventResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EmergencyEvent get event => $_getN(0);
  @$pb.TagNumber(1)
  set event(EmergencyEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  EmergencyEvent ensureEvent() => $_ensure(0);
}

class GetTimelineRequest extends $pb.GeneratedMessage {
  factory GetTimelineRequest({
    $core.String? visitId,
  }) {
    final result = create();
    if (visitId != null) result.visitId = visitId;
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
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'visitId')
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
  $core.String get visitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set visitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVisitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisitId() => $_clearField(1);
}

class GetTimelineResponse extends $pb.GeneratedMessage {
  factory GetTimelineResponse({
    $core.Iterable<EmergencyEvent>? events,
    Intervals? intervals,
  }) {
    final result = create();
    if (events != null) result.events.addAll(events);
    if (intervals != null) result.intervals = intervals;
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
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..pPM<EmergencyEvent>(1, _omitFieldNames ? '' : 'events',
        subBuilder: EmergencyEvent.create)
    ..aOM<Intervals>(2, _omitFieldNames ? '' : 'intervals',
        subBuilder: Intervals.create)
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
  $pb.PbList<EmergencyEvent> get events => $_getList(0);

  @$pb.TagNumber(2)
  Intervals get intervals => $_getN(1);
  @$pb.TagNumber(2)
  set intervals(Intervals value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasIntervals() => $_has(1);
  @$pb.TagNumber(2)
  void clearIntervals() => $_clearField(2);
  @$pb.TagNumber(2)
  Intervals ensureIntervals() => $_ensure(1);
}

class ReconcileAdministrationRequest extends $pb.GeneratedMessage {
  factory ReconcileAdministrationRequest({
    $core.String? eventId,
    $core.String? orderId,
  }) {
    final result = create();
    if (eventId != null) result.eventId = eventId;
    if (orderId != null) result.orderId = orderId;
    return result;
  }

  ReconcileAdministrationRequest._();

  factory ReconcileAdministrationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReconcileAdministrationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconcileAdministrationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'eventId')
    ..aOS(2, _omitFieldNames ? '' : 'orderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileAdministrationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileAdministrationRequest copyWith(
          void Function(ReconcileAdministrationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ReconcileAdministrationRequest))
          as ReconcileAdministrationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconcileAdministrationRequest create() =>
      ReconcileAdministrationRequest._();
  @$core.override
  ReconcileAdministrationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReconcileAdministrationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconcileAdministrationRequest>(create);
  static ReconcileAdministrationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eventId => $_getSZ(0);
  @$pb.TagNumber(1)
  set eventId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEventId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get orderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set orderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderId() => $_clearField(2);
}

class ReconcileAdministrationResponse extends $pb.GeneratedMessage {
  factory ReconcileAdministrationResponse() => create();

  ReconcileAdministrationResponse._();

  factory ReconcileAdministrationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReconcileAdministrationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconcileAdministrationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileAdministrationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileAdministrationResponse copyWith(
          void Function(ReconcileAdministrationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ReconcileAdministrationResponse))
          as ReconcileAdministrationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconcileAdministrationResponse create() =>
      ReconcileAdministrationResponse._();
  @$core.override
  ReconcileAdministrationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReconcileAdministrationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconcileAdministrationResponse>(
          create);
  static ReconcileAdministrationResponse? _defaultInstance;
}

class ListUnreconciledRequest extends $pb.GeneratedMessage {
  factory ListUnreconciledRequest({
    $core.String? facilityId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListUnreconciledRequest._();

  factory ListUnreconciledRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListUnreconciledRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUnreconciledRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUnreconciledRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUnreconciledRequest copyWith(
          void Function(ListUnreconciledRequest) updates) =>
      super.copyWith((message) => updates(message as ListUnreconciledRequest))
          as ListUnreconciledRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUnreconciledRequest create() => ListUnreconciledRequest._();
  @$core.override
  ListUnreconciledRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListUnreconciledRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUnreconciledRequest>(create);
  static ListUnreconciledRequest? _defaultInstance;

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

class ListUnreconciledResponse extends $pb.GeneratedMessage {
  factory ListUnreconciledResponse({
    $core.Iterable<EmergencyEvent>? events,
  }) {
    final result = create();
    if (events != null) result.events.addAll(events);
    return result;
  }

  ListUnreconciledResponse._();

  factory ListUnreconciledResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListUnreconciledResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUnreconciledResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..pPM<EmergencyEvent>(1, _omitFieldNames ? '' : 'events',
        subBuilder: EmergencyEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUnreconciledResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUnreconciledResponse copyWith(
          void Function(ListUnreconciledResponse) updates) =>
      super.copyWith((message) => updates(message as ListUnreconciledResponse))
          as ListUnreconciledResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUnreconciledResponse create() => ListUnreconciledResponse._();
  @$core.override
  ListUnreconciledResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListUnreconciledResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUnreconciledResponse>(create);
  static ListUnreconciledResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<EmergencyEvent> get events => $_getList(0);
}

class StartObservationRequest extends $pb.GeneratedMessage {
  factory StartObservationRequest({
    $core.String? visitId,
    $0.Timestamp? reviewAt,
    $core.String? location,
  }) {
    final result = create();
    if (visitId != null) result.visitId = visitId;
    if (reviewAt != null) result.reviewAt = reviewAt;
    if (location != null) result.location = location;
    return result;
  }

  StartObservationRequest._();

  factory StartObservationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartObservationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartObservationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'visitId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'reviewAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(3, _omitFieldNames ? '' : 'location')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartObservationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartObservationRequest copyWith(
          void Function(StartObservationRequest) updates) =>
      super.copyWith((message) => updates(message as StartObservationRequest))
          as StartObservationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartObservationRequest create() => StartObservationRequest._();
  @$core.override
  StartObservationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartObservationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartObservationRequest>(create);
  static StartObservationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get visitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set visitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVisitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get reviewAt => $_getN(1);
  @$pb.TagNumber(2)
  set reviewAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasReviewAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearReviewAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureReviewAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get location => $_getSZ(2);
  @$pb.TagNumber(3)
  set location($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocation() => $_clearField(3);
}

class StartObservationResponse extends $pb.GeneratedMessage {
  factory StartObservationResponse({
    EmergencyVisit? visit,
  }) {
    final result = create();
    if (visit != null) result.visit = visit;
    return result;
  }

  StartObservationResponse._();

  factory StartObservationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartObservationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartObservationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOM<EmergencyVisit>(1, _omitFieldNames ? '' : 'visit',
        subBuilder: EmergencyVisit.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartObservationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartObservationResponse copyWith(
          void Function(StartObservationResponse) updates) =>
      super.copyWith((message) => updates(message as StartObservationResponse))
          as StartObservationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartObservationResponse create() => StartObservationResponse._();
  @$core.override
  StartObservationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartObservationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartObservationResponse>(create);
  static StartObservationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EmergencyVisit get visit => $_getN(0);
  @$pb.TagNumber(1)
  set visit(EmergencyVisit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVisit() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisit() => $_clearField(1);
  @$pb.TagNumber(1)
  EmergencyVisit ensureVisit() => $_ensure(0);
}

class DisposeRequest extends $pb.GeneratedMessage {
  factory DisposeRequest({
    $core.String? visitId,
    Disposition? disposition,
    $core.String? note,
    $core.String? receivingService,
    $core.bool? summarySigned,
  }) {
    final result = create();
    if (visitId != null) result.visitId = visitId;
    if (disposition != null) result.disposition = disposition;
    if (note != null) result.note = note;
    if (receivingService != null) result.receivingService = receivingService;
    if (summarySigned != null) result.summarySigned = summarySigned;
    return result;
  }

  DisposeRequest._();

  factory DisposeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisposeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DisposeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'visitId')
    ..aE<Disposition>(2, _omitFieldNames ? '' : 'disposition',
        enumValues: Disposition.values)
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..aOS(4, _omitFieldNames ? '' : 'receivingService')
    ..aOB(5, _omitFieldNames ? '' : 'summarySigned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisposeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisposeRequest copyWith(void Function(DisposeRequest) updates) =>
      super.copyWith((message) => updates(message as DisposeRequest))
          as DisposeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisposeRequest create() => DisposeRequest._();
  @$core.override
  DisposeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DisposeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisposeRequest>(create);
  static DisposeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get visitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set visitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVisitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisitId() => $_clearField(1);

  @$pb.TagNumber(2)
  Disposition get disposition => $_getN(1);
  @$pb.TagNumber(2)
  set disposition(Disposition value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDisposition() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisposition() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get receivingService => $_getSZ(3);
  @$pb.TagNumber(4)
  set receivingService($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReceivingService() => $_has(3);
  @$pb.TagNumber(4)
  void clearReceivingService() => $_clearField(4);

  /// The caller's assertion that the discharge summary is signed (SRS-ER-015).
  /// Passed rather than inferred: the summary is a clinical document owned by
  /// SRS-CLN, and a department deciding for itself would be a second authority
  /// on it.
  @$pb.TagNumber(5)
  $core.bool get summarySigned => $_getBF(4);
  @$pb.TagNumber(5)
  set summarySigned($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSummarySigned() => $_has(4);
  @$pb.TagNumber(5)
  void clearSummarySigned() => $_clearField(5);
}

class DisposeResponse extends $pb.GeneratedMessage {
  factory DisposeResponse({
    EmergencyVisit? visit,
  }) {
    final result = create();
    if (visit != null) result.visit = visit;
    return result;
  }

  DisposeResponse._();

  factory DisposeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisposeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DisposeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOM<EmergencyVisit>(1, _omitFieldNames ? '' : 'visit',
        subBuilder: EmergencyVisit.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisposeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisposeResponse copyWith(void Function(DisposeResponse) updates) =>
      super.copyWith((message) => updates(message as DisposeResponse))
          as DisposeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisposeResponse create() => DisposeResponse._();
  @$core.override
  DisposeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DisposeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisposeResponse>(create);
  static DisposeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EmergencyVisit get visit => $_getN(0);
  @$pb.TagNumber(1)
  set visit(EmergencyVisit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVisit() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisit() => $_clearField(1);
  @$pb.TagNumber(1)
  EmergencyVisit ensureVisit() => $_ensure(0);
}

class GetBoardRequest extends $pb.GeneratedMessage {
  factory GetBoardRequest({
    $core.String? facilityId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (pageSize != null) result.pageSize = pageSize;
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
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
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

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class GetBoardResponse extends $pb.GeneratedMessage {
  factory GetBoardResponse({
    $core.Iterable<BoardRow>? rows,
    $core.int? restricted,
  }) {
    final result = create();
    if (rows != null) result.rows.addAll(rows);
    if (restricted != null) result.restricted = restricted;
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
          _omitMessageNames ? '' : 'healthcare.emergency.v1'),
      createEmptyInstance: create)
    ..pPM<BoardRow>(1, _omitFieldNames ? '' : 'rows',
        subBuilder: BoardRow.create)
    ..aI(2, _omitFieldNames ? '' : 'restricted')
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

  /// How many rows are shown redacted, so the board can say "and 2 restricted"
  /// rather than silently showing a shorter department than exists.
  @$pb.TagNumber(2)
  $core.int get restricted => $_getIZ(1);
  @$pb.TagNumber(2)
  set restricted($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRestricted() => $_has(1);
  @$pb.TagNumber(2)
  void clearRestricted() => $_clearField(2);
}

class EmergencyServiceApi {
  final $pb.RpcClient _client;

  EmergencyServiceApi(this._client);

  /// Arrival and identity (SRS-ER-001, SRS-ER-004).
  $async.Future<ArriveResponse> arrive(
          $pb.ClientContext? ctx, ArriveRequest request) =>
      _client.invoke<ArriveResponse>(
          ctx, 'EmergencyService', 'Arrive', request, ArriveResponse());
  $async.Future<GetEmergencyVisitResponse> getEmergencyVisit(
          $pb.ClientContext? ctx, GetEmergencyVisitRequest request) =>
      _client.invoke<GetEmergencyVisitResponse>(ctx, 'EmergencyService',
          'GetEmergencyVisit', request, GetEmergencyVisitResponse());
  $async.Future<IdentifyPatientResponse> identifyPatient(
          $pb.ClientContext? ctx, IdentifyPatientRequest request) =>
      _client.invoke<IdentifyPatientResponse>(ctx, 'EmergencyService',
          'IdentifyPatient', request, IdentifyPatientResponse());

  /// Triage and the queue (SRS-ER-002, SRS-ER-003, SRS-ER-012).
  $async.Future<AssignTriageResponse> assignTriage(
          $pb.ClientContext? ctx, AssignTriageRequest request) =>
      _client.invoke<AssignTriageResponse>(ctx, 'EmergencyService',
          'AssignTriage', request, AssignTriageResponse());
  $async.Future<OverridePriorityResponse> overridePriority(
          $pb.ClientContext? ctx, OverridePriorityRequest request) =>
      _client.invoke<OverridePriorityResponse>(ctx, 'EmergencyService',
          'OverridePriority', request, OverridePriorityResponse());
  $async.Future<GetBoardResponse> getBoard(
          $pb.ClientContext? ctx, GetBoardRequest request) =>
      _client.invoke<GetBoardResponse>(
          ctx, 'EmergencyService', 'GetBoard', request, GetBoardResponse());

  /// Time-critical pathways (SRS-ER-005).
  $async.Future<ActivatePathwayResponse> activatePathway(
          $pb.ClientContext? ctx, ActivatePathwayRequest request) =>
      _client.invoke<ActivatePathwayResponse>(ctx, 'EmergencyService',
          'ActivatePathway', request, ActivatePathwayResponse());
  $async.Future<StandDownPathwayResponse> standDownPathway(
          $pb.ClientContext? ctx, StandDownPathwayRequest request) =>
      _client.invoke<StandDownPathwayResponse>(ctx, 'EmergencyService',
          'StandDownPathway', request, StandDownPathwayResponse());

  /// The resuscitation timeline and its clocks (SRS-ER-006, SRS-ER-008,
  /// SRS-ER-009).
  $async.Future<RecordEmergencyEventResponse> recordEmergencyEvent(
          $pb.ClientContext? ctx, RecordEmergencyEventRequest request) =>
      _client.invoke<RecordEmergencyEventResponse>(ctx, 'EmergencyService',
          'RecordEmergencyEvent', request, RecordEmergencyEventResponse());
  $async.Future<GetTimelineResponse> getTimeline(
          $pb.ClientContext? ctx, GetTimelineRequest request) =>
      _client.invoke<GetTimelineResponse>(ctx, 'EmergencyService',
          'GetTimeline', request, GetTimelineResponse());
  $async.Future<ReconcileAdministrationResponse> reconcileAdministration(
          $pb.ClientContext? ctx, ReconcileAdministrationRequest request) =>
      _client.invoke<ReconcileAdministrationResponse>(
          ctx,
          'EmergencyService',
          'ReconcileAdministration',
          request,
          ReconcileAdministrationResponse());
  $async.Future<ListUnreconciledResponse> listUnreconciled(
          $pb.ClientContext? ctx, ListUnreconciledRequest request) =>
      _client.invoke<ListUnreconciledResponse>(ctx, 'EmergencyService',
          'ListUnreconciled', request, ListUnreconciledResponse());

  /// Observation and disposition (SRS-ER-013, SRS-ER-014).
  $async.Future<StartObservationResponse> startObservation(
          $pb.ClientContext? ctx, StartObservationRequest request) =>
      _client.invoke<StartObservationResponse>(ctx, 'EmergencyService',
          'StartObservation', request, StartObservationResponse());
  $async.Future<DisposeResponse> dispose(
          $pb.ClientContext? ctx, DisposeRequest request) =>
      _client.invoke<DisposeResponse>(
          ctx, 'EmergencyService', 'Dispose', request, DisposeResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
