// This is a generated file - do not edit.
//
// Generated from healthcare/infection/v1/infection.proto.

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

import 'infection.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'infection.pbenum.dart';

/// One infection under surveillance (SRS-IPC-001).
class SurveillanceCase extends $pb.GeneratedMessage {
  factory SurveillanceCase({
    $core.String? caseId,
    $core.String? reference,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    $core.String? locationId,
    $core.String? organism,
    $core.String? organismCode,
    InfectionSite? site,
    $core.bool? multidrugResistant,
    Onset? onset,
    Onset? onsetOverride,
    $core.String? onsetOverrideWhy,
    $core.String? onsetOverriddenBy,
    $0.Timestamp? admittedAt,
    $0.Timestamp? onsetAt,
    $core.int? windowHours,
    $core.String? criteria,
    $core.String? reviewedBy,
    $0.Timestamp? reviewedAt,
    $core.bool? deviceInSitu,
    $core.int? deviceDays,
    CaseState? state,
    $core.String? notes,
    $0.Timestamp? reportedAt,
    $core.String? reportedBy,
    $0.Timestamp? closedAt,
    $core.String? closedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (reference != null) result.reference = reference;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (organism != null) result.organism = organism;
    if (organismCode != null) result.organismCode = organismCode;
    if (site != null) result.site = site;
    if (multidrugResistant != null)
      result.multidrugResistant = multidrugResistant;
    if (onset != null) result.onset = onset;
    if (onsetOverride != null) result.onsetOverride = onsetOverride;
    if (onsetOverrideWhy != null) result.onsetOverrideWhy = onsetOverrideWhy;
    if (onsetOverriddenBy != null) result.onsetOverriddenBy = onsetOverriddenBy;
    if (admittedAt != null) result.admittedAt = admittedAt;
    if (onsetAt != null) result.onsetAt = onsetAt;
    if (windowHours != null) result.windowHours = windowHours;
    if (criteria != null) result.criteria = criteria;
    if (reviewedBy != null) result.reviewedBy = reviewedBy;
    if (reviewedAt != null) result.reviewedAt = reviewedAt;
    if (deviceInSitu != null) result.deviceInSitu = deviceInSitu;
    if (deviceDays != null) result.deviceDays = deviceDays;
    if (state != null) result.state = state;
    if (notes != null) result.notes = notes;
    if (reportedAt != null) result.reportedAt = reportedAt;
    if (reportedBy != null) result.reportedBy = reportedBy;
    if (closedAt != null) result.closedAt = closedAt;
    if (closedBy != null) result.closedBy = closedBy;
    if (version != null) result.version = version;
    return result;
  }

  SurveillanceCase._();

  factory SurveillanceCase.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SurveillanceCase.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SurveillanceCase',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'encounterId')
    ..aOS(5, _omitFieldNames ? '' : 'facilityId')
    ..aOS(6, _omitFieldNames ? '' : 'locationId')
    ..aOS(7, _omitFieldNames ? '' : 'organism')
    ..aOS(8, _omitFieldNames ? '' : 'organismCode')
    ..aE<InfectionSite>(9, _omitFieldNames ? '' : 'site',
        enumValues: InfectionSite.values)
    ..aOB(10, _omitFieldNames ? '' : 'multidrugResistant')
    ..aE<Onset>(11, _omitFieldNames ? '' : 'onset', enumValues: Onset.values)
    ..aE<Onset>(12, _omitFieldNames ? '' : 'onsetOverride',
        enumValues: Onset.values)
    ..aOS(13, _omitFieldNames ? '' : 'onsetOverrideWhy')
    ..aOS(14, _omitFieldNames ? '' : 'onsetOverriddenBy')
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'admittedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'onsetAt',
        subBuilder: $0.Timestamp.create)
    ..aI(17, _omitFieldNames ? '' : 'windowHours')
    ..aOS(18, _omitFieldNames ? '' : 'criteria')
    ..aOS(19, _omitFieldNames ? '' : 'reviewedBy')
    ..aOM<$0.Timestamp>(20, _omitFieldNames ? '' : 'reviewedAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(21, _omitFieldNames ? '' : 'deviceInSitu')
    ..aI(22, _omitFieldNames ? '' : 'deviceDays')
    ..aE<CaseState>(23, _omitFieldNames ? '' : 'state',
        enumValues: CaseState.values)
    ..aOS(24, _omitFieldNames ? '' : 'notes')
    ..aOM<$0.Timestamp>(25, _omitFieldNames ? '' : 'reportedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(26, _omitFieldNames ? '' : 'reportedBy')
    ..aOM<$0.Timestamp>(27, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(28, _omitFieldNames ? '' : 'closedBy')
    ..aInt64(29, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SurveillanceCase clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SurveillanceCase copyWith(void Function(SurveillanceCase) updates) =>
      super.copyWith((message) => updates(message as SurveillanceCase))
          as SurveillanceCase;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SurveillanceCase create() => SurveillanceCase._();
  @$core.override
  SurveillanceCase createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SurveillanceCase getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SurveillanceCase>(create);
  static SurveillanceCase? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

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
  $core.String get encounterId => $_getSZ(3);
  @$pb.TagNumber(4)
  set encounterId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEncounterId() => $_has(3);
  @$pb.TagNumber(4)
  void clearEncounterId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get facilityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set facilityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFacilityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearFacilityId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get locationId => $_getSZ(5);
  @$pb.TagNumber(6)
  set locationId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLocationId() => $_has(5);
  @$pb.TagNumber(6)
  void clearLocationId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get organism => $_getSZ(6);
  @$pb.TagNumber(7)
  set organism($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOrganism() => $_has(6);
  @$pb.TagNumber(7)
  void clearOrganism() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get organismCode => $_getSZ(7);
  @$pb.TagNumber(8)
  set organismCode($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOrganismCode() => $_has(7);
  @$pb.TagNumber(8)
  void clearOrganismCode() => $_clearField(8);

  @$pb.TagNumber(9)
  InfectionSite get site => $_getN(8);
  @$pb.TagNumber(9)
  set site(InfectionSite value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSite() => $_has(8);
  @$pb.TagNumber(9)
  void clearSite() => $_clearField(9);

  /// Set from the hospital's configured list rather than typed.
  @$pb.TagNumber(10)
  $core.bool get multidrugResistant => $_getBF(9);
  @$pb.TagNumber(10)
  set multidrugResistant($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMultidrugResistant() => $_has(9);
  @$pb.TagNumber(10)
  void clearMultidrugResistant() => $_clearField(10);

  /// Derived from the dates and the window. Read-only.
  @$pb.TagNumber(11)
  Onset get onset => $_getN(10);
  @$pb.TagNumber(11)
  set onset(Onset value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasOnset() => $_has(10);
  @$pb.TagNumber(11)
  void clearOnset() => $_clearField(11);

  /// The reviewer's disagreement, where there was one. A separate field, with
  /// its reason and its author, so a reclassification stays visible as one.
  @$pb.TagNumber(12)
  Onset get onsetOverride => $_getN(11);
  @$pb.TagNumber(12)
  set onsetOverride(Onset value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasOnsetOverride() => $_has(11);
  @$pb.TagNumber(12)
  void clearOnsetOverride() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get onsetOverrideWhy => $_getSZ(12);
  @$pb.TagNumber(13)
  set onsetOverrideWhy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasOnsetOverrideWhy() => $_has(12);
  @$pb.TagNumber(13)
  void clearOnsetOverrideWhy() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get onsetOverriddenBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set onsetOverriddenBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasOnsetOverriddenBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearOnsetOverriddenBy() => $_clearField(14);

  @$pb.TagNumber(15)
  $0.Timestamp get admittedAt => $_getN(14);
  @$pb.TagNumber(15)
  set admittedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasAdmittedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearAdmittedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureAdmittedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $0.Timestamp get onsetAt => $_getN(15);
  @$pb.TagNumber(16)
  set onsetAt($0.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasOnsetAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearOnsetAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureOnsetAt() => $_ensure(15);

  /// The surveillance window the classification used, frozen on the case: a
  /// definition change must not silently re-judge history.
  @$pb.TagNumber(17)
  $core.int get windowHours => $_getIZ(16);
  @$pb.TagNumber(17)
  set windowHours($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasWindowHours() => $_has(16);
  @$pb.TagNumber(17)
  void clearWindowHours() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get criteria => $_getSZ(17);
  @$pb.TagNumber(18)
  set criteria($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasCriteria() => $_has(17);
  @$pb.TagNumber(18)
  void clearCriteria() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get reviewedBy => $_getSZ(18);
  @$pb.TagNumber(19)
  set reviewedBy($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasReviewedBy() => $_has(18);
  @$pb.TagNumber(19)
  void clearReviewedBy() => $_clearField(19);

  @$pb.TagNumber(20)
  $0.Timestamp get reviewedAt => $_getN(19);
  @$pb.TagNumber(20)
  set reviewedAt($0.Timestamp value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasReviewedAt() => $_has(19);
  @$pb.TagNumber(20)
  void clearReviewedAt() => $_clearField(20);
  @$pb.TagNumber(20)
  $0.Timestamp ensureReviewedAt() => $_ensure(19);

  @$pb.TagNumber(21)
  $core.bool get deviceInSitu => $_getBF(20);
  @$pb.TagNumber(21)
  set deviceInSitu($core.bool value) => $_setBool(20, value);
  @$pb.TagNumber(21)
  $core.bool hasDeviceInSitu() => $_has(20);
  @$pb.TagNumber(21)
  void clearDeviceInSitu() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.int get deviceDays => $_getIZ(21);
  @$pb.TagNumber(22)
  set deviceDays($core.int value) => $_setSignedInt32(21, value);
  @$pb.TagNumber(22)
  $core.bool hasDeviceDays() => $_has(21);
  @$pb.TagNumber(22)
  void clearDeviceDays() => $_clearField(22);

  @$pb.TagNumber(23)
  CaseState get state => $_getN(22);
  @$pb.TagNumber(23)
  set state(CaseState value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasState() => $_has(22);
  @$pb.TagNumber(23)
  void clearState() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.String get notes => $_getSZ(23);
  @$pb.TagNumber(24)
  set notes($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasNotes() => $_has(23);
  @$pb.TagNumber(24)
  void clearNotes() => $_clearField(24);

  @$pb.TagNumber(25)
  $0.Timestamp get reportedAt => $_getN(24);
  @$pb.TagNumber(25)
  set reportedAt($0.Timestamp value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasReportedAt() => $_has(24);
  @$pb.TagNumber(25)
  void clearReportedAt() => $_clearField(25);
  @$pb.TagNumber(25)
  $0.Timestamp ensureReportedAt() => $_ensure(24);

  @$pb.TagNumber(26)
  $core.String get reportedBy => $_getSZ(25);
  @$pb.TagNumber(26)
  set reportedBy($core.String value) => $_setString(25, value);
  @$pb.TagNumber(26)
  $core.bool hasReportedBy() => $_has(25);
  @$pb.TagNumber(26)
  void clearReportedBy() => $_clearField(26);

  @$pb.TagNumber(27)
  $0.Timestamp get closedAt => $_getN(26);
  @$pb.TagNumber(27)
  set closedAt($0.Timestamp value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasClosedAt() => $_has(26);
  @$pb.TagNumber(27)
  void clearClosedAt() => $_clearField(27);
  @$pb.TagNumber(27)
  $0.Timestamp ensureClosedAt() => $_ensure(26);

  @$pb.TagNumber(28)
  $core.String get closedBy => $_getSZ(27);
  @$pb.TagNumber(28)
  set closedBy($core.String value) => $_setString(27, value);
  @$pb.TagNumber(28)
  $core.bool hasClosedBy() => $_has(27);
  @$pb.TagNumber(28)
  void clearClosedBy() => $_clearField(28);

  @$pb.TagNumber(29)
  $fixnum.Int64 get version => $_getI64(28);
  @$pb.TagNumber(29)
  set version($fixnum.Int64 value) => $_setInt64(28, value);
  @$pb.TagNumber(29)
  $core.bool hasVersion() => $_has(28);
  @$pb.TagNumber(29)
  void clearVersion() => $_clearField(29);
}

/// One day's device usage in one location (SRS-IPC-002).
class DeviceDayCount extends $pb.GeneratedMessage {
  factory DeviceDayCount({
    $core.String? countId,
    $core.String? facilityId,
    $core.String? locationId,
    DeviceKind? device,
    $0.Timestamp? countedOn,
    $core.int? patientDays,
    $core.int? deviceDays,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (countId != null) result.countId = countId;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (device != null) result.device = device;
    if (countedOn != null) result.countedOn = countedOn;
    if (patientDays != null) result.patientDays = patientDays;
    if (deviceDays != null) result.deviceDays = deviceDays;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  DeviceDayCount._();

  factory DeviceDayCount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceDayCount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceDayCount',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'countId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'locationId')
    ..aE<DeviceKind>(4, _omitFieldNames ? '' : 'device',
        enumValues: DeviceKind.values)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'countedOn',
        subBuilder: $0.Timestamp.create)
    ..aI(6, _omitFieldNames ? '' : 'patientDays')
    ..aI(7, _omitFieldNames ? '' : 'deviceDays')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceDayCount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceDayCount copyWith(void Function(DeviceDayCount) updates) =>
      super.copyWith((message) => updates(message as DeviceDayCount))
          as DeviceDayCount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceDayCount create() => DeviceDayCount._();
  @$core.override
  DeviceDayCount createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceDayCount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceDayCount>(create);
  static DeviceDayCount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get countId => $_getSZ(0);
  @$pb.TagNumber(1)
  set countId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCountId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationId() => $_clearField(3);

  @$pb.TagNumber(4)
  DeviceKind get device => $_getN(3);
  @$pb.TagNumber(4)
  set device(DeviceKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDevice() => $_has(3);
  @$pb.TagNumber(4)
  void clearDevice() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get countedOn => $_getN(4);
  @$pb.TagNumber(5)
  set countedOn($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCountedOn() => $_has(4);
  @$pb.TagNumber(5)
  void clearCountedOn() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureCountedOn() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.int get patientDays => $_getIZ(5);
  @$pb.TagNumber(6)
  set patientDays($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPatientDays() => $_has(5);
  @$pb.TagNumber(6)
  void clearPatientDays() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get deviceDays => $_getIZ(6);
  @$pb.TagNumber(7)
  set deviceDays($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDeviceDays() => $_has(6);
  @$pb.TagNumber(7)
  void clearDeviceDays() => $_clearField(7);

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
}

/// How a period's cases were classified (SRS-IPC-010).
class OnsetSummary extends $pb.GeneratedMessage {
  factory OnsetSummary({
    $core.int? healthcare,
    $core.int? community,
    $core.int? indeterminate,
    $core.int? overridden,
    $core.int? overriddenToCommunity,
  }) {
    final result = create();
    if (healthcare != null) result.healthcare = healthcare;
    if (community != null) result.community = community;
    if (indeterminate != null) result.indeterminate = indeterminate;
    if (overridden != null) result.overridden = overridden;
    if (overriddenToCommunity != null)
      result.overriddenToCommunity = overriddenToCommunity;
    return result;
  }

  OnsetSummary._();

  factory OnsetSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OnsetSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OnsetSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'healthcare')
    ..aI(2, _omitFieldNames ? '' : 'community')
    ..aI(3, _omitFieldNames ? '' : 'indeterminate')
    ..aI(4, _omitFieldNames ? '' : 'overridden')
    ..aI(5, _omitFieldNames ? '' : 'overriddenToCommunity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OnsetSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OnsetSummary copyWith(void Function(OnsetSummary) updates) =>
      super.copyWith((message) => updates(message as OnsetSummary))
          as OnsetSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OnsetSummary create() => OnsetSummary._();
  @$core.override
  OnsetSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OnsetSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OnsetSummary>(create);
  static OnsetSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get healthcare => $_getIZ(0);
  @$pb.TagNumber(1)
  set healthcare($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHealthcare() => $_has(0);
  @$pb.TagNumber(1)
  void clearHealthcare() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get community => $_getIZ(1);
  @$pb.TagNumber(2)
  set community($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommunity() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommunity() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get indeterminate => $_getIZ(2);
  @$pb.TagNumber(3)
  set indeterminate($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIndeterminate() => $_has(2);
  @$pb.TagNumber(3)
  void clearIndeterminate() => $_clearField(3);

  /// Counted separately and never folded in. A month in which eleven
  /// healthcare-associated infections were reclassified by hand is a month
  /// somebody should look at.
  @$pb.TagNumber(4)
  $core.int get overridden => $_getIZ(3);
  @$pb.TagNumber(4)
  set overridden($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOverridden() => $_has(3);
  @$pb.TagNumber(4)
  void clearOverridden() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get overriddenToCommunity => $_getIZ(4);
  @$pb.TagNumber(5)
  set overriddenToCommunity($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOverriddenToCommunity() => $_has(4);
  @$pb.TagNumber(5)
  void clearOverriddenToCommunity() => $_clearField(5);
}

/// One infection rate over one period (SRS-IPC-002, SRS-IPC-010).
class Rate extends $pb.GeneratedMessage {
  factory Rate({
    InfectionSite? site,
    DeviceKind? device,
    $core.String? locationId,
    $0.Timestamp? periodFrom,
    $0.Timestamp? periodTo,
    $core.int? infections,
    $core.int? deviceDays,
    $core.int? patientDays,
    $core.int? perThousandDeviceDaysTenths,
    $core.int? utilisationPermille,
    $core.bool? unanswerable,
    OnsetSummary? onsets,
    $core.String? indicatorCode,
    $core.int? indicatorRevision,
  }) {
    final result = create();
    if (site != null) result.site = site;
    if (device != null) result.device = device;
    if (locationId != null) result.locationId = locationId;
    if (periodFrom != null) result.periodFrom = periodFrom;
    if (periodTo != null) result.periodTo = periodTo;
    if (infections != null) result.infections = infections;
    if (deviceDays != null) result.deviceDays = deviceDays;
    if (patientDays != null) result.patientDays = patientDays;
    if (perThousandDeviceDaysTenths != null)
      result.perThousandDeviceDaysTenths = perThousandDeviceDaysTenths;
    if (utilisationPermille != null)
      result.utilisationPermille = utilisationPermille;
    if (unanswerable != null) result.unanswerable = unanswerable;
    if (onsets != null) result.onsets = onsets;
    if (indicatorCode != null) result.indicatorCode = indicatorCode;
    if (indicatorRevision != null) result.indicatorRevision = indicatorRevision;
    return result;
  }

  Rate._();

  factory Rate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Rate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Rate',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aE<InfectionSite>(1, _omitFieldNames ? '' : 'site',
        enumValues: InfectionSite.values)
    ..aE<DeviceKind>(2, _omitFieldNames ? '' : 'device',
        enumValues: DeviceKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'locationId')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'periodFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'periodTo',
        subBuilder: $0.Timestamp.create)
    ..aI(6, _omitFieldNames ? '' : 'infections')
    ..aI(7, _omitFieldNames ? '' : 'deviceDays')
    ..aI(8, _omitFieldNames ? '' : 'patientDays')
    ..aI(9, _omitFieldNames ? '' : 'perThousandDeviceDaysTenths')
    ..aI(10, _omitFieldNames ? '' : 'utilisationPermille')
    ..aOB(11, _omitFieldNames ? '' : 'unanswerable')
    ..aOM<OnsetSummary>(12, _omitFieldNames ? '' : 'onsets',
        subBuilder: OnsetSummary.create)
    ..aOS(13, _omitFieldNames ? '' : 'indicatorCode')
    ..aI(14, _omitFieldNames ? '' : 'indicatorRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Rate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Rate copyWith(void Function(Rate) updates) =>
      super.copyWith((message) => updates(message as Rate)) as Rate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Rate create() => Rate._();
  @$core.override
  Rate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Rate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Rate>(create);
  static Rate? _defaultInstance;

  @$pb.TagNumber(1)
  InfectionSite get site => $_getN(0);
  @$pb.TagNumber(1)
  set site(InfectionSite value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSite() => $_has(0);
  @$pb.TagNumber(1)
  void clearSite() => $_clearField(1);

  @$pb.TagNumber(2)
  DeviceKind get device => $_getN(1);
  @$pb.TagNumber(2)
  set device(DeviceKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDevice() => $_has(1);
  @$pb.TagNumber(2)
  void clearDevice() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationId() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get periodFrom => $_getN(3);
  @$pb.TagNumber(4)
  set periodFrom($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPeriodFrom() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeriodFrom() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensurePeriodFrom() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get periodTo => $_getN(4);
  @$pb.TagNumber(5)
  set periodTo($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPeriodTo() => $_has(4);
  @$pb.TagNumber(5)
  void clearPeriodTo() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensurePeriodTo() => $_ensure(4);

  /// Confirmed, healthcare-associated cases at this site.
  @$pb.TagNumber(6)
  $core.int get infections => $_getIZ(5);
  @$pb.TagNumber(6)
  set infections($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInfections() => $_has(5);
  @$pb.TagNumber(6)
  void clearInfections() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get deviceDays => $_getIZ(6);
  @$pb.TagNumber(7)
  set deviceDays($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDeviceDays() => $_has(6);
  @$pb.TagNumber(7)
  void clearDeviceDays() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get patientDays => $_getIZ(7);
  @$pb.TagNumber(8)
  set patientDays($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPatientDays() => $_has(7);
  @$pb.TagNumber(8)
  void clearPatientDays() => $_clearField(8);

  /// Per 1000 device days, in tenths: 4.7 is 47. Integer arithmetic
  /// throughout, because a rate that reads 4.699999 in one report and 4.7 in
  /// another is an argument in a committee meeting.
  @$pb.TagNumber(9)
  $core.int get perThousandDeviceDaysTenths => $_getIZ(8);
  @$pb.TagNumber(9)
  set perThousandDeviceDaysTenths($core.int value) =>
      $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPerThousandDeviceDaysTenths() => $_has(8);
  @$pb.TagNumber(9)
  void clearPerThousandDeviceDaysTenths() => $_clearField(9);

  /// Device days over patient days, parts per thousand. A rate falling because
  /// the ward stopped using the device is a different fact from a rate falling
  /// because it got safer.
  @$pb.TagNumber(10)
  $core.int get utilisationPermille => $_getIZ(9);
  @$pb.TagNumber(10)
  set utilisationPermille($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUtilisationPermille() => $_has(9);
  @$pb.TagNumber(10)
  void clearUtilisationPermille() => $_clearField(10);

  /// No denominator, so no rate.
  @$pb.TagNumber(11)
  $core.bool get unanswerable => $_getBF(10);
  @$pb.TagNumber(11)
  set unanswerable($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasUnanswerable() => $_has(10);
  @$pb.TagNumber(11)
  void clearUnanswerable() => $_clearField(11);

  @$pb.TagNumber(12)
  OnsetSummary get onsets => $_getN(11);
  @$pb.TagNumber(12)
  set onsets(OnsetSummary value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasOnsets() => $_has(11);
  @$pb.TagNumber(12)
  void clearOnsets() => $_clearField(12);
  @$pb.TagNumber(12)
  OnsetSummary ensureOnsets() => $_ensure(11);

  /// The versioned indicator definition this was filed against, where one is
  /// configured (SRS-IPC-010).
  @$pb.TagNumber(13)
  $core.String get indicatorCode => $_getSZ(12);
  @$pb.TagNumber(13)
  set indicatorCode($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasIndicatorCode() => $_has(12);
  @$pb.TagNumber(13)
  void clearIndicatorCode() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get indicatorRevision => $_getIZ(13);
  @$pb.TagNumber(14)
  set indicatorRevision($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasIndicatorRevision() => $_has(13);
  @$pb.TagNumber(14)
  void clearIndicatorRevision() => $_clearField(14);
}

/// One patient under precautions (SRS-IPC-003).
class Isolation extends $pb.GeneratedMessage {
  factory Isolation({
    $core.String? isolationId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    $core.String? locationId,
    $core.String? bedId,
    Precaution? precaution,
    $core.String? reason,
    $core.String? caseId,
    $0.Timestamp? startedAt,
    $core.String? startedBy,
    $0.Timestamp? reviewDue,
    $0.Timestamp? endedAt,
    $core.String? endedBy,
    $core.String? endReason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (isolationId != null) result.isolationId = isolationId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (bedId != null) result.bedId = bedId;
    if (precaution != null) result.precaution = precaution;
    if (reason != null) result.reason = reason;
    if (caseId != null) result.caseId = caseId;
    if (startedAt != null) result.startedAt = startedAt;
    if (startedBy != null) result.startedBy = startedBy;
    if (reviewDue != null) result.reviewDue = reviewDue;
    if (endedAt != null) result.endedAt = endedAt;
    if (endedBy != null) result.endedBy = endedBy;
    if (endReason != null) result.endReason = endReason;
    if (version != null) result.version = version;
    return result;
  }

  Isolation._();

  factory Isolation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Isolation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Isolation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'isolationId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'locationId')
    ..aOS(6, _omitFieldNames ? '' : 'bedId')
    ..aE<Precaution>(7, _omitFieldNames ? '' : 'precaution',
        enumValues: Precaution.values)
    ..aOS(8, _omitFieldNames ? '' : 'reason')
    ..aOS(9, _omitFieldNames ? '' : 'caseId')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'startedBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'reviewDue',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(14, _omitFieldNames ? '' : 'endedBy')
    ..aOS(15, _omitFieldNames ? '' : 'endReason')
    ..aInt64(16, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Isolation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Isolation copyWith(void Function(Isolation) updates) =>
      super.copyWith((message) => updates(message as Isolation)) as Isolation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Isolation create() => Isolation._();
  @$core.override
  Isolation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Isolation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Isolation>(create);
  static Isolation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get isolationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set isolationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsolationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsolationId() => $_clearField(1);

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
  $core.String get locationId => $_getSZ(4);
  @$pb.TagNumber(5)
  set locationId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLocationId() => $_has(4);
  @$pb.TagNumber(5)
  void clearLocationId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get bedId => $_getSZ(5);
  @$pb.TagNumber(6)
  set bedId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBedId() => $_has(5);
  @$pb.TagNumber(6)
  void clearBedId() => $_clearField(6);

  @$pb.TagNumber(7)
  Precaution get precaution => $_getN(6);
  @$pb.TagNumber(7)
  set precaution(Precaution value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPrecaution() => $_has(6);
  @$pb.TagNumber(7)
  void clearPrecaution() => $_clearField(7);

  /// The clinical justification. Returned to infection control and never on a
  /// board entry.
  @$pb.TagNumber(8)
  $core.String get reason => $_getSZ(7);
  @$pb.TagNumber(8)
  set reason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearReason() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get caseId => $_getSZ(8);
  @$pb.TagNumber(9)
  set caseId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCaseId() => $_has(8);
  @$pb.TagNumber(9)
  void clearCaseId() => $_clearField(9);

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

  @$pb.TagNumber(11)
  $core.String get startedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set startedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasStartedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearStartedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get reviewDue => $_getN(11);
  @$pb.TagNumber(12)
  set reviewDue($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasReviewDue() => $_has(11);
  @$pb.TagNumber(12)
  void clearReviewDue() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureReviewDue() => $_ensure(11);

  @$pb.TagNumber(13)
  $0.Timestamp get endedAt => $_getN(12);
  @$pb.TagNumber(13)
  set endedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasEndedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearEndedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureEndedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get endedBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set endedBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasEndedBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearEndedBy() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get endReason => $_getSZ(14);
  @$pb.TagNumber(15)
  set endReason($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasEndReason() => $_has(14);
  @$pb.TagNumber(15)
  void clearEndReason() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get version => $_getI64(15);
  @$pb.TagNumber(16)
  set version($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasVersion() => $_has(15);
  @$pb.TagNumber(16)
  void clearVersion() => $_clearField(16);
}

/// What a bed board may show (SRS-IPC-003, SRS-OPSSEC-006).
///
/// There is no reason field here, and that is the point.
class BoardEntry extends $pb.GeneratedMessage {
  factory BoardEntry({
    $core.String? bedId,
    $core.String? locationId,
    $core.String? patientId,
    Precaution? precaution,
    $core.Iterable<$core.String>? ppe,
    $core.bool? requiresSideRoom,
    $0.Timestamp? since,
    $core.bool? reviewOverdue,
  }) {
    final result = create();
    if (bedId != null) result.bedId = bedId;
    if (locationId != null) result.locationId = locationId;
    if (patientId != null) result.patientId = patientId;
    if (precaution != null) result.precaution = precaution;
    if (ppe != null) result.ppe.addAll(ppe);
    if (requiresSideRoom != null) result.requiresSideRoom = requiresSideRoom;
    if (since != null) result.since = since;
    if (reviewOverdue != null) result.reviewOverdue = reviewOverdue;
    return result;
  }

  BoardEntry._();

  factory BoardEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BoardEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BoardEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'bedId')
    ..aOS(2, _omitFieldNames ? '' : 'locationId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aE<Precaution>(4, _omitFieldNames ? '' : 'precaution',
        enumValues: Precaution.values)
    ..pPS(5, _omitFieldNames ? '' : 'ppe')
    ..aOB(6, _omitFieldNames ? '' : 'requiresSideRoom')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'since',
        subBuilder: $0.Timestamp.create)
    ..aOB(8, _omitFieldNames ? '' : 'reviewOverdue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BoardEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BoardEntry copyWith(void Function(BoardEntry) updates) =>
      super.copyWith((message) => updates(message as BoardEntry)) as BoardEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BoardEntry create() => BoardEntry._();
  @$core.override
  BoardEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BoardEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BoardEntry>(create);
  static BoardEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bedId => $_getSZ(0);
  @$pb.TagNumber(1)
  set bedId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBedId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBedId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get locationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get patientId => $_getSZ(2);
  @$pb.TagNumber(3)
  set patientId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPatientId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatientId() => $_clearField(3);

  @$pb.TagNumber(4)
  Precaution get precaution => $_getN(3);
  @$pb.TagNumber(4)
  set precaution(Precaution value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPrecaution() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrecaution() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get ppe => $_getList(4);

  @$pb.TagNumber(6)
  $core.bool get requiresSideRoom => $_getBF(5);
  @$pb.TagNumber(6)
  set requiresSideRoom($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRequiresSideRoom() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequiresSideRoom() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get since => $_getN(6);
  @$pb.TagNumber(7)
  set since($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSince() => $_has(6);
  @$pb.TagNumber(7)
  void clearSince() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureSince() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.bool get reviewOverdue => $_getBF(7);
  @$pb.TagNumber(8)
  set reviewOverdue($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReviewOverdue() => $_has(7);
  @$pb.TagNumber(8)
  void clearReviewOverdue() => $_clearField(8);
}

/// A configured multidrug-resistant organism rule (SRS-IPC-004).
class AlertRule extends $pb.GeneratedMessage {
  factory AlertRule({
    $core.String? ruleId,
    $core.String? code,
    $core.String? name,
    $core.int? revision,
    $core.Iterable<$core.String>? organisms,
    $core.int? lookbackDays,
    Precaution? precaution,
    $core.String? advice,
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
    if (organisms != null) result.organisms.addAll(organisms);
    if (lookbackDays != null) result.lookbackDays = lookbackDays;
    if (precaution != null) result.precaution = precaution;
    if (advice != null) result.advice = advice;
    if (approved != null) result.approved = approved;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (supersededAt != null) result.supersededAt = supersededAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    return result;
  }

  AlertRule._();

  factory AlertRule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AlertRule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AlertRule',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ruleId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aI(4, _omitFieldNames ? '' : 'revision')
    ..pPS(5, _omitFieldNames ? '' : 'organisms')
    ..aI(6, _omitFieldNames ? '' : 'lookbackDays')
    ..aE<Precaution>(7, _omitFieldNames ? '' : 'precaution',
        enumValues: Precaution.values)
    ..aOS(8, _omitFieldNames ? '' : 'advice')
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
  AlertRule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlertRule copyWith(void Function(AlertRule) updates) =>
      super.copyWith((message) => updates(message as AlertRule)) as AlertRule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AlertRule create() => AlertRule._();
  @$core.override
  AlertRule createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AlertRule getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AlertRule>(create);
  static AlertRule? _defaultInstance;

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

  /// (code, revision) is the identity. A rule edited in place would make every
  /// past alert unexplainable.
  @$pb.TagNumber(4)
  $core.int get revision => $_getIZ(3);
  @$pb.TagNumber(4)
  set revision($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevision() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get organisms => $_getList(4);

  @$pb.TagNumber(6)
  $core.int get lookbackDays => $_getIZ(5);
  @$pb.TagNumber(6)
  set lookbackDays($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLookbackDays() => $_has(5);
  @$pb.TagNumber(6)
  void clearLookbackDays() => $_clearField(6);

  @$pb.TagNumber(7)
  Precaution get precaution => $_getN(6);
  @$pb.TagNumber(7)
  set precaution(Precaution value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPrecaution() => $_has(6);
  @$pb.TagNumber(7)
  void clearPrecaution() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get advice => $_getSZ(7);
  @$pb.TagNumber(8)
  set advice($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAdvice() => $_has(7);
  @$pb.TagNumber(8)
  void clearAdvice() => $_clearField(8);

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

/// One rule firing for one patient at one encounter (SRS-IPC-004).
class Alert extends $pb.GeneratedMessage {
  factory Alert({
    $core.String? alertId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    $core.String? ruleId,
    $core.String? ruleCode,
    $core.int? ruleRevision,
    $core.String? organism,
    $core.String? organismCode,
    $0.Timestamp? lastPositiveAt,
    Precaution? precaution,
    $core.String? advice,
    $0.Timestamp? raisedAt,
    $0.Timestamp? acknowledgedAt,
    $core.String? acknowledgedBy,
    $core.bool? overridden,
    $core.String? overrideWhy,
    $core.String? overriddenBy,
    $0.Timestamp? overriddenAt,
  }) {
    final result = create();
    if (alertId != null) result.alertId = alertId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (ruleId != null) result.ruleId = ruleId;
    if (ruleCode != null) result.ruleCode = ruleCode;
    if (ruleRevision != null) result.ruleRevision = ruleRevision;
    if (organism != null) result.organism = organism;
    if (organismCode != null) result.organismCode = organismCode;
    if (lastPositiveAt != null) result.lastPositiveAt = lastPositiveAt;
    if (precaution != null) result.precaution = precaution;
    if (advice != null) result.advice = advice;
    if (raisedAt != null) result.raisedAt = raisedAt;
    if (acknowledgedAt != null) result.acknowledgedAt = acknowledgedAt;
    if (acknowledgedBy != null) result.acknowledgedBy = acknowledgedBy;
    if (overridden != null) result.overridden = overridden;
    if (overrideWhy != null) result.overrideWhy = overrideWhy;
    if (overriddenBy != null) result.overriddenBy = overriddenBy;
    if (overriddenAt != null) result.overriddenAt = overriddenAt;
    return result;
  }

  Alert._();

  factory Alert.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Alert.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Alert',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'alertId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'ruleId')
    ..aOS(6, _omitFieldNames ? '' : 'ruleCode')
    ..aI(7, _omitFieldNames ? '' : 'ruleRevision')
    ..aOS(8, _omitFieldNames ? '' : 'organism')
    ..aOS(9, _omitFieldNames ? '' : 'organismCode')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'lastPositiveAt',
        subBuilder: $0.Timestamp.create)
    ..aE<Precaution>(11, _omitFieldNames ? '' : 'precaution',
        enumValues: Precaution.values)
    ..aOS(12, _omitFieldNames ? '' : 'advice')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'raisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'acknowledgedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'acknowledgedBy')
    ..aOB(16, _omitFieldNames ? '' : 'overridden')
    ..aOS(17, _omitFieldNames ? '' : 'overrideWhy')
    ..aOS(18, _omitFieldNames ? '' : 'overriddenBy')
    ..aOM<$0.Timestamp>(19, _omitFieldNames ? '' : 'overriddenAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Alert clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Alert copyWith(void Function(Alert) updates) =>
      super.copyWith((message) => updates(message as Alert)) as Alert;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Alert create() => Alert._();
  @$core.override
  Alert createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Alert getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Alert>(create);
  static Alert? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get alertId => $_getSZ(0);
  @$pb.TagNumber(1)
  set alertId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlertId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlertId() => $_clearField(1);

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
  $core.String get ruleId => $_getSZ(4);
  @$pb.TagNumber(5)
  set ruleId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRuleId() => $_has(4);
  @$pb.TagNumber(5)
  void clearRuleId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get ruleCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set ruleCode($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRuleCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearRuleCode() => $_clearField(6);

  /// The revision it fired under, so an alert from eighteen months ago stays
  /// explicable.
  @$pb.TagNumber(7)
  $core.int get ruleRevision => $_getIZ(6);
  @$pb.TagNumber(7)
  set ruleRevision($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRuleRevision() => $_has(6);
  @$pb.TagNumber(7)
  void clearRuleRevision() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get organism => $_getSZ(7);
  @$pb.TagNumber(8)
  set organism($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOrganism() => $_has(7);
  @$pb.TagNumber(8)
  void clearOrganism() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get organismCode => $_getSZ(8);
  @$pb.TagNumber(9)
  set organismCode($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOrganismCode() => $_has(8);
  @$pb.TagNumber(9)
  void clearOrganismCode() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get lastPositiveAt => $_getN(9);
  @$pb.TagNumber(10)
  set lastPositiveAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasLastPositiveAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearLastPositiveAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureLastPositiveAt() => $_ensure(9);

  @$pb.TagNumber(11)
  Precaution get precaution => $_getN(10);
  @$pb.TagNumber(11)
  set precaution(Precaution value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasPrecaution() => $_has(10);
  @$pb.TagNumber(11)
  void clearPrecaution() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get advice => $_getSZ(11);
  @$pb.TagNumber(12)
  set advice($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAdvice() => $_has(11);
  @$pb.TagNumber(12)
  void clearAdvice() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get raisedAt => $_getN(12);
  @$pb.TagNumber(13)
  set raisedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasRaisedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearRaisedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureRaisedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Timestamp get acknowledgedAt => $_getN(13);
  @$pb.TagNumber(14)
  set acknowledgedAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasAcknowledgedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearAcknowledgedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureAcknowledgedAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get acknowledgedBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set acknowledgedBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasAcknowledgedBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearAcknowledgedBy() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.bool get overridden => $_getBF(15);
  @$pb.TagNumber(16)
  set overridden($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(16)
  $core.bool hasOverridden() => $_has(15);
  @$pb.TagNumber(16)
  void clearOverridden() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get overrideWhy => $_getSZ(16);
  @$pb.TagNumber(17)
  set overrideWhy($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasOverrideWhy() => $_has(16);
  @$pb.TagNumber(17)
  void clearOverrideWhy() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get overriddenBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set overriddenBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasOverriddenBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearOverriddenBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $0.Timestamp get overriddenAt => $_getN(18);
  @$pb.TagNumber(19)
  set overriddenAt($0.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasOverriddenAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearOverriddenAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Timestamp ensureOverriddenAt() => $_ensure(18);
}

/// One cluster investigation (SRS-IPC-005).
class Outbreak extends $pb.GeneratedMessage {
  factory Outbreak({
    $core.String? outbreakId,
    $core.String? reference,
    $core.String? organism,
    $core.String? caseDefinition,
    $core.Iterable<$core.String>? locations,
    $0.Timestamp? windowFrom,
    $0.Timestamp? windowTo,
    OutbreakState? state,
    $core.String? findings,
    $core.Iterable<$core.String>? controlMeasures,
    $core.Iterable<$core.String>? actionIds,
    $0.Timestamp? declaredAt,
    $core.String? declaredBy,
    $0.Timestamp? closedAt,
    $core.String? closedBy,
    $core.String? closureWhy,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (outbreakId != null) result.outbreakId = outbreakId;
    if (reference != null) result.reference = reference;
    if (organism != null) result.organism = organism;
    if (caseDefinition != null) result.caseDefinition = caseDefinition;
    if (locations != null) result.locations.addAll(locations);
    if (windowFrom != null) result.windowFrom = windowFrom;
    if (windowTo != null) result.windowTo = windowTo;
    if (state != null) result.state = state;
    if (findings != null) result.findings = findings;
    if (controlMeasures != null) result.controlMeasures.addAll(controlMeasures);
    if (actionIds != null) result.actionIds.addAll(actionIds);
    if (declaredAt != null) result.declaredAt = declaredAt;
    if (declaredBy != null) result.declaredBy = declaredBy;
    if (closedAt != null) result.closedAt = closedAt;
    if (closedBy != null) result.closedBy = closedBy;
    if (closureWhy != null) result.closureWhy = closureWhy;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  Outbreak._();

  factory Outbreak.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Outbreak.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Outbreak',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'outbreakId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aOS(3, _omitFieldNames ? '' : 'organism')
    ..aOS(4, _omitFieldNames ? '' : 'caseDefinition')
    ..pPS(5, _omitFieldNames ? '' : 'locations')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'windowFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'windowTo',
        subBuilder: $0.Timestamp.create)
    ..aE<OutbreakState>(8, _omitFieldNames ? '' : 'state',
        enumValues: OutbreakState.values)
    ..aOS(9, _omitFieldNames ? '' : 'findings')
    ..pPS(10, _omitFieldNames ? '' : 'controlMeasures')
    ..pPS(11, _omitFieldNames ? '' : 'actionIds')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'declaredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'declaredBy')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'closedBy')
    ..aOS(16, _omitFieldNames ? '' : 'closureWhy')
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(18, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(19, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Outbreak clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Outbreak copyWith(void Function(Outbreak) updates) =>
      super.copyWith((message) => updates(message as Outbreak)) as Outbreak;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Outbreak create() => Outbreak._();
  @$core.override
  Outbreak createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Outbreak getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Outbreak>(create);
  static Outbreak? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outbreakId => $_getSZ(0);
  @$pb.TagNumber(1)
  set outbreakId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutbreakId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutbreakId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reference => $_getSZ(1);
  @$pb.TagNumber(2)
  set reference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearReference() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get organism => $_getSZ(2);
  @$pb.TagNumber(3)
  set organism($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrganism() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrganism() => $_clearField(3);

  /// What makes a patient part of this cluster. An outbreak whose cases were
  /// chosen one at a time is an outbreak whose size is whatever the
  /// investigator decided.
  @$pb.TagNumber(4)
  $core.String get caseDefinition => $_getSZ(3);
  @$pb.TagNumber(4)
  set caseDefinition($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCaseDefinition() => $_has(3);
  @$pb.TagNumber(4)
  void clearCaseDefinition() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get locations => $_getList(4);

  @$pb.TagNumber(6)
  $0.Timestamp get windowFrom => $_getN(5);
  @$pb.TagNumber(6)
  set windowFrom($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasWindowFrom() => $_has(5);
  @$pb.TagNumber(6)
  void clearWindowFrom() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureWindowFrom() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get windowTo => $_getN(6);
  @$pb.TagNumber(7)
  set windowTo($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasWindowTo() => $_has(6);
  @$pb.TagNumber(7)
  void clearWindowTo() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureWindowTo() => $_ensure(6);

  @$pb.TagNumber(8)
  OutbreakState get state => $_getN(7);
  @$pb.TagNumber(8)
  set state(OutbreakState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasState() => $_has(7);
  @$pb.TagNumber(8)
  void clearState() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get findings => $_getSZ(8);
  @$pb.TagNumber(9)
  set findings($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFindings() => $_has(8);
  @$pb.TagNumber(9)
  void clearFindings() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get controlMeasures => $_getList(9);

  /// Corrective actions raised in the quality system, named rather than
  /// duplicated.
  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get actionIds => $_getList(10);

  @$pb.TagNumber(12)
  $0.Timestamp get declaredAt => $_getN(11);
  @$pb.TagNumber(12)
  set declaredAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasDeclaredAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearDeclaredAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureDeclaredAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get declaredBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set declaredBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDeclaredBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearDeclaredBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get closedAt => $_getN(13);
  @$pb.TagNumber(14)
  set closedAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasClosedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearClosedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureClosedAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get closedBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set closedBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasClosedBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearClosedBy() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get closureWhy => $_getSZ(15);
  @$pb.TagNumber(16)
  set closureWhy($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasClosureWhy() => $_has(15);
  @$pb.TagNumber(16)
  void clearClosureWhy() => $_clearField(16);

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

/// One case's place in a cluster (SRS-IPC-005).
class Membership extends $pb.GeneratedMessage {
  factory Membership({
    $core.String? membershipId,
    $core.String? outbreakId,
    $core.String? caseId,
    $core.String? patientId,
    MembershipReason? reason,
    $core.String? note,
    $0.Timestamp? decidedAt,
    $core.String? decidedBy,
  }) {
    final result = create();
    if (membershipId != null) result.membershipId = membershipId;
    if (outbreakId != null) result.outbreakId = outbreakId;
    if (caseId != null) result.caseId = caseId;
    if (patientId != null) result.patientId = patientId;
    if (reason != null) result.reason = reason;
    if (note != null) result.note = note;
    if (decidedAt != null) result.decidedAt = decidedAt;
    if (decidedBy != null) result.decidedBy = decidedBy;
    return result;
  }

  Membership._();

  factory Membership.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Membership.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Membership',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'membershipId')
    ..aOS(2, _omitFieldNames ? '' : 'outbreakId')
    ..aOS(3, _omitFieldNames ? '' : 'caseId')
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aE<MembershipReason>(5, _omitFieldNames ? '' : 'reason',
        enumValues: MembershipReason.values)
    ..aOS(6, _omitFieldNames ? '' : 'note')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'decidedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'decidedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Membership clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Membership copyWith(void Function(Membership) updates) =>
      super.copyWith((message) => updates(message as Membership)) as Membership;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Membership create() => Membership._();
  @$core.override
  Membership createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Membership getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Membership>(create);
  static Membership? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get membershipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set membershipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMembershipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMembershipId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get outbreakId => $_getSZ(1);
  @$pb.TagNumber(2)
  set outbreakId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOutbreakId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutbreakId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get caseId => $_getSZ(2);
  @$pb.TagNumber(3)
  set caseId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCaseId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCaseId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get patientId => $_getSZ(3);
  @$pb.TagNumber(4)
  set patientId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPatientId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPatientId() => $_clearField(4);

  @$pb.TagNumber(5)
  MembershipReason get reason => $_getN(4);
  @$pb.TagNumber(5)
  set reason(MembershipReason value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get note => $_getSZ(5);
  @$pb.TagNumber(6)
  set note($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNote() => $_has(5);
  @$pb.TagNumber(6)
  void clearNote() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get decidedAt => $_getN(6);
  @$pb.TagNumber(7)
  set decidedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDecidedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearDecidedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureDecidedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get decidedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set decidedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDecidedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearDecidedBy() => $_clearField(8);
}

/// An investigation's size and shape (SRS-IPC-005, SRS-IPC-010).
class ClusterSummary extends $pb.GeneratedMessage {
  factory ClusterSummary({
    $core.String? outbreakId,
    $core.int? included,
    $core.int? excluded,
    $core.int? byLink,
    $core.Iterable<$core.String>? locations,
    $0.Timestamp? firstOnset,
    $0.Timestamp? lastOnset,
  }) {
    final result = create();
    if (outbreakId != null) result.outbreakId = outbreakId;
    if (included != null) result.included = included;
    if (excluded != null) result.excluded = excluded;
    if (byLink != null) result.byLink = byLink;
    if (locations != null) result.locations.addAll(locations);
    if (firstOnset != null) result.firstOnset = firstOnset;
    if (lastOnset != null) result.lastOnset = lastOnset;
    return result;
  }

  ClusterSummary._();

  factory ClusterSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClusterSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClusterSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'outbreakId')
    ..aI(2, _omitFieldNames ? '' : 'included')
    ..aI(3, _omitFieldNames ? '' : 'excluded')
    ..aI(4, _omitFieldNames ? '' : 'byLink')
    ..pPS(5, _omitFieldNames ? '' : 'locations')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'firstOnset',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'lastOnset',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClusterSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClusterSummary copyWith(void Function(ClusterSummary) updates) =>
      super.copyWith((message) => updates(message as ClusterSummary))
          as ClusterSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClusterSummary create() => ClusterSummary._();
  @$core.override
  ClusterSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClusterSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClusterSummary>(create);
  static ClusterSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outbreakId => $_getSZ(0);
  @$pb.TagNumber(1)
  set outbreakId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutbreakId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutbreakId() => $_clearField(1);

  /// Reported together, because a cluster of six that started as a cluster of
  /// fourteen is a different fact from a cluster of six.
  @$pb.TagNumber(2)
  $core.int get included => $_getIZ(1);
  @$pb.TagNumber(2)
  set included($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIncluded() => $_has(1);
  @$pb.TagNumber(2)
  void clearIncluded() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get excluded => $_getIZ(2);
  @$pb.TagNumber(3)
  set excluded($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExcluded() => $_has(2);
  @$pb.TagNumber(3)
  void clearExcluded() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get byLink => $_getIZ(3);
  @$pb.TagNumber(4)
  set byLink($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasByLink() => $_has(3);
  @$pb.TagNumber(4)
  void clearByLink() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get locations => $_getList(4);

  @$pb.TagNumber(6)
  $0.Timestamp get firstOnset => $_getN(5);
  @$pb.TagNumber(6)
  set firstOnset($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasFirstOnset() => $_has(5);
  @$pb.TagNumber(6)
  void clearFirstOnset() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureFirstOnset() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get lastOnset => $_getN(6);
  @$pb.TagNumber(7)
  set lastOnset($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasLastOnset() => $_has(6);
  @$pb.TagNumber(7)
  void clearLastOnset() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureLastOnset() => $_ensure(6);
}

/// One period of hand hygiene observation (SRS-IPC-006).
class HygieneSession extends $pb.GeneratedMessage {
  factory HygieneSession({
    $core.String? sessionId,
    $core.String? facilityId,
    $core.String? locationId,
    $core.String? observerId,
    $0.Timestamp? startedAt,
    $0.Timestamp? endedAt,
    $core.String? notes,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (observerId != null) result.observerId = observerId;
    if (startedAt != null) result.startedAt = startedAt;
    if (endedAt != null) result.endedAt = endedAt;
    if (notes != null) result.notes = notes;
    if (version != null) result.version = version;
    return result;
  }

  HygieneSession._();

  factory HygieneSession.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HygieneSession.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HygieneSession',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'locationId')
    ..aOS(4, _omitFieldNames ? '' : 'observerId')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'notes')
    ..aInt64(8, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HygieneSession clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HygieneSession copyWith(void Function(HygieneSession) updates) =>
      super.copyWith((message) => updates(message as HygieneSession))
          as HygieneSession;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HygieneSession create() => HygieneSession._();
  @$core.override
  HygieneSession createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HygieneSession getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HygieneSession>(create);
  static HygieneSession? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationId() => $_clearField(3);

  /// The observer is named; the observed never are.
  @$pb.TagNumber(4)
  $core.String get observerId => $_getSZ(3);
  @$pb.TagNumber(4)
  set observerId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasObserverId() => $_has(3);
  @$pb.TagNumber(4)
  void clearObserverId() => $_clearField(4);

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
  $core.String get notes => $_getSZ(6);
  @$pb.TagNumber(7)
  set notes($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNotes() => $_has(6);
  @$pb.TagNumber(7)
  void clearNotes() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get version => $_getI64(7);
  @$pb.TagNumber(8)
  set version($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVersion() => $_has(7);
  @$pb.TagNumber(8)
  void clearVersion() => $_clearField(8);
}

/// One opportunity and what happened (SRS-IPC-006).
///
/// There is no field here naming the person observed.
class HygieneObservation extends $pb.GeneratedMessage {
  factory HygieneObservation({
    $core.String? observationId,
    $core.String? sessionId,
    Discipline? discipline,
    Moment? moment,
    HygieneAction? action,
    $core.bool? glovesWorn,
    $0.Timestamp? observedAt,
  }) {
    final result = create();
    if (observationId != null) result.observationId = observationId;
    if (sessionId != null) result.sessionId = sessionId;
    if (discipline != null) result.discipline = discipline;
    if (moment != null) result.moment = moment;
    if (action != null) result.action = action;
    if (glovesWorn != null) result.glovesWorn = glovesWorn;
    if (observedAt != null) result.observedAt = observedAt;
    return result;
  }

  HygieneObservation._();

  factory HygieneObservation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HygieneObservation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HygieneObservation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'observationId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aE<Discipline>(3, _omitFieldNames ? '' : 'discipline',
        enumValues: Discipline.values)
    ..aE<Moment>(4, _omitFieldNames ? '' : 'moment', enumValues: Moment.values)
    ..aE<HygieneAction>(5, _omitFieldNames ? '' : 'action',
        enumValues: HygieneAction.values)
    ..aOB(6, _omitFieldNames ? '' : 'glovesWorn')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HygieneObservation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HygieneObservation copyWith(void Function(HygieneObservation) updates) =>
      super.copyWith((message) => updates(message as HygieneObservation))
          as HygieneObservation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HygieneObservation create() => HygieneObservation._();
  @$core.override
  HygieneObservation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HygieneObservation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HygieneObservation>(create);
  static HygieneObservation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get observationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set observationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasObservationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearObservationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  Discipline get discipline => $_getN(2);
  @$pb.TagNumber(3)
  set discipline(Discipline value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDiscipline() => $_has(2);
  @$pb.TagNumber(3)
  void clearDiscipline() => $_clearField(3);

  @$pb.TagNumber(4)
  Moment get moment => $_getN(3);
  @$pb.TagNumber(4)
  set moment(Moment value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMoment() => $_has(3);
  @$pb.TagNumber(4)
  void clearMoment() => $_clearField(4);

  @$pb.TagNumber(5)
  HygieneAction get action => $_getN(4);
  @$pb.TagNumber(5)
  set action(HygieneAction value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAction() => $_has(4);
  @$pb.TagNumber(5)
  void clearAction() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get glovesWorn => $_getBF(5);
  @$pb.TagNumber(6)
  set glovesWorn($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGlovesWorn() => $_has(5);
  @$pb.TagNumber(6)
  void clearGlovesWorn() => $_clearField(6);

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
}

/// One group's hand hygiene rate (SRS-IPC-006).
class Compliance extends $pb.GeneratedMessage {
  factory Compliance({
    $core.String? group,
    $core.int? opportunities,
    $core.int? performed,
    $core.int? permille,
    $core.int? glovesInsteadOf,
    $core.bool? suppressed,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (opportunities != null) result.opportunities = opportunities;
    if (performed != null) result.performed = performed;
    if (permille != null) result.permille = permille;
    if (glovesInsteadOf != null) result.glovesInsteadOf = glovesInsteadOf;
    if (suppressed != null) result.suppressed = suppressed;
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
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'group')
    ..aI(2, _omitFieldNames ? '' : 'opportunities')
    ..aI(3, _omitFieldNames ? '' : 'performed')
    ..aI(4, _omitFieldNames ? '' : 'permille')
    ..aI(5, _omitFieldNames ? '' : 'glovesInsteadOf')
    ..aOB(6, _omitFieldNames ? '' : 'suppressed')
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
  $core.String get group => $_getSZ(0);
  @$pb.TagNumber(1)
  set group($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get opportunities => $_getIZ(1);
  @$pb.TagNumber(2)
  set opportunities($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpportunities() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpportunities() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get performed => $_getIZ(2);
  @$pb.TagNumber(3)
  set performed($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPerformed() => $_has(2);
  @$pb.TagNumber(3)
  void clearPerformed() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get permille => $_getIZ(3);
  @$pb.TagNumber(4)
  set permille($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPermille() => $_has(3);
  @$pb.TagNumber(4)
  void clearPermille() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get glovesInsteadOf => $_getIZ(4);
  @$pb.TagNumber(5)
  set glovesInsteadOf($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasGlovesInsteadOf() => $_has(4);
  @$pb.TagNumber(5)
  void clearGlovesInsteadOf() => $_clearField(5);

  /// Too few observations to report. The counts come back blank with it,
  /// because publishing them would name somebody by arithmetic.
  @$pb.TagNumber(6)
  $core.bool get suppressed => $_getBF(5);
  @$pb.TagNumber(6)
  set suppressed($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSuppressed() => $_has(5);
  @$pb.TagNumber(6)
  void clearSuppressed() => $_clearField(6);
}

/// One occupational exposure (SRS-IPC-007). Restricted, always.
class Exposure extends $pb.GeneratedMessage {
  factory Exposure({
    $core.String? exposureId,
    $core.String? reference,
    $core.String? staffId,
    Discipline? discipline,
    $core.String? facilityId,
    $core.String? locationId,
    ExposureKind? kind,
    $core.String? device,
    $core.String? circumstance,
    $core.bool? deepInjury,
    $core.String? sourcePatientId,
    $core.bool? sourceKnown,
    $core.bool? sourceConsented,
    $0.Timestamp? occurredAt,
    $0.Timestamp? reportedAt,
    $core.String? reportedBy,
    $0.Timestamp? closedAt,
    $core.String? closedBy,
    $core.String? outcome,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (exposureId != null) result.exposureId = exposureId;
    if (reference != null) result.reference = reference;
    if (staffId != null) result.staffId = staffId;
    if (discipline != null) result.discipline = discipline;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (kind != null) result.kind = kind;
    if (device != null) result.device = device;
    if (circumstance != null) result.circumstance = circumstance;
    if (deepInjury != null) result.deepInjury = deepInjury;
    if (sourcePatientId != null) result.sourcePatientId = sourcePatientId;
    if (sourceKnown != null) result.sourceKnown = sourceKnown;
    if (sourceConsented != null) result.sourceConsented = sourceConsented;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (reportedAt != null) result.reportedAt = reportedAt;
    if (reportedBy != null) result.reportedBy = reportedBy;
    if (closedAt != null) result.closedAt = closedAt;
    if (closedBy != null) result.closedBy = closedBy;
    if (outcome != null) result.outcome = outcome;
    if (version != null) result.version = version;
    return result;
  }

  Exposure._();

  factory Exposure.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Exposure.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Exposure',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'exposureId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aOS(3, _omitFieldNames ? '' : 'staffId')
    ..aE<Discipline>(4, _omitFieldNames ? '' : 'discipline',
        enumValues: Discipline.values)
    ..aOS(5, _omitFieldNames ? '' : 'facilityId')
    ..aOS(6, _omitFieldNames ? '' : 'locationId')
    ..aE<ExposureKind>(7, _omitFieldNames ? '' : 'kind',
        enumValues: ExposureKind.values)
    ..aOS(8, _omitFieldNames ? '' : 'device')
    ..aOS(9, _omitFieldNames ? '' : 'circumstance')
    ..aOB(10, _omitFieldNames ? '' : 'deepInjury')
    ..aOS(11, _omitFieldNames ? '' : 'sourcePatientId')
    ..aOB(12, _omitFieldNames ? '' : 'sourceKnown')
    ..aOB(13, _omitFieldNames ? '' : 'sourceConsented')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'reportedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'reportedBy')
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(18, _omitFieldNames ? '' : 'closedBy')
    ..aOS(19, _omitFieldNames ? '' : 'outcome')
    ..aInt64(20, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Exposure clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Exposure copyWith(void Function(Exposure) updates) =>
      super.copyWith((message) => updates(message as Exposure)) as Exposure;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Exposure create() => Exposure._();
  @$core.override
  Exposure createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Exposure getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Exposure>(create);
  static Exposure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get exposureId => $_getSZ(0);
  @$pb.TagNumber(1)
  set exposureId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExposureId() => $_has(0);
  @$pb.TagNumber(1)
  void clearExposureId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reference => $_getSZ(1);
  @$pb.TagNumber(2)
  set reference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearReference() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get staffId => $_getSZ(2);
  @$pb.TagNumber(3)
  set staffId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStaffId() => $_has(2);
  @$pb.TagNumber(3)
  void clearStaffId() => $_clearField(3);

  @$pb.TagNumber(4)
  Discipline get discipline => $_getN(3);
  @$pb.TagNumber(4)
  set discipline(Discipline value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDiscipline() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiscipline() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get facilityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set facilityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFacilityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearFacilityId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get locationId => $_getSZ(5);
  @$pb.TagNumber(6)
  set locationId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLocationId() => $_has(5);
  @$pb.TagNumber(6)
  void clearLocationId() => $_clearField(6);

  @$pb.TagNumber(7)
  ExposureKind get kind => $_getN(6);
  @$pb.TagNumber(7)
  set kind(ExposureKind value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasKind() => $_has(6);
  @$pb.TagNumber(7)
  void clearKind() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get device => $_getSZ(7);
  @$pb.TagNumber(8)
  set device($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDevice() => $_has(7);
  @$pb.TagNumber(8)
  void clearDevice() => $_clearField(8);

  /// What a prevention programme reads: the same cannula on the same ward
  /// three times is a finding.
  @$pb.TagNumber(9)
  $core.String get circumstance => $_getSZ(8);
  @$pb.TagNumber(9)
  set circumstance($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCircumstance() => $_has(8);
  @$pb.TagNumber(9)
  void clearCircumstance() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get deepInjury => $_getBF(9);
  @$pb.TagNumber(10)
  set deepInjury($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDeepInjury() => $_has(9);
  @$pb.TagNumber(10)
  void clearDeepInjury() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get sourcePatientId => $_getSZ(10);
  @$pb.TagNumber(11)
  set sourcePatientId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSourcePatientId() => $_has(10);
  @$pb.TagNumber(11)
  void clearSourcePatientId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get sourceKnown => $_getBF(11);
  @$pb.TagNumber(12)
  set sourceKnown($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSourceKnown() => $_has(11);
  @$pb.TagNumber(12)
  void clearSourceKnown() => $_clearField(12);

  /// Testing a source patient's blood is a decision with its own law.
  @$pb.TagNumber(13)
  $core.bool get sourceConsented => $_getBF(12);
  @$pb.TagNumber(13)
  set sourceConsented($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasSourceConsented() => $_has(12);
  @$pb.TagNumber(13)
  void clearSourceConsented() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get occurredAt => $_getN(13);
  @$pb.TagNumber(14)
  set occurredAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasOccurredAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearOccurredAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureOccurredAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $0.Timestamp get reportedAt => $_getN(14);
  @$pb.TagNumber(15)
  set reportedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasReportedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearReportedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureReportedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get reportedBy => $_getSZ(15);
  @$pb.TagNumber(16)
  set reportedBy($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasReportedBy() => $_has(15);
  @$pb.TagNumber(16)
  void clearReportedBy() => $_clearField(16);

  @$pb.TagNumber(17)
  $0.Timestamp get closedAt => $_getN(16);
  @$pb.TagNumber(17)
  set closedAt($0.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasClosedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearClosedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Timestamp ensureClosedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.String get closedBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set closedBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasClosedBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearClosedBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get outcome => $_getSZ(18);
  @$pb.TagNumber(19)
  set outcome($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasOutcome() => $_has(18);
  @$pb.TagNumber(19)
  void clearOutcome() => $_clearField(19);

  @$pb.TagNumber(20)
  $fixnum.Int64 get version => $_getI64(19);
  @$pb.TagNumber(20)
  set version($fixnum.Int64 value) => $_setInt64(19, value);
  @$pb.TagNumber(20)
  $core.bool hasVersion() => $_has(19);
  @$pb.TagNumber(20)
  void clearVersion() => $_clearField(20);
}

/// One time-sensitive step after an exposure (SRS-IPC-007).
class ExposureTask extends $pb.GeneratedMessage {
  factory ExposureTask({
    $core.String? taskId,
    $core.String? exposureId,
    $core.String? code,
    $0.Timestamp? dueBy,
    TaskState? state,
    $core.String? outcome,
    $0.Timestamp? completedAt,
    $core.String? completedBy,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (exposureId != null) result.exposureId = exposureId;
    if (code != null) result.code = code;
    if (dueBy != null) result.dueBy = dueBy;
    if (state != null) result.state = state;
    if (outcome != null) result.outcome = outcome;
    if (completedAt != null) result.completedAt = completedAt;
    if (completedBy != null) result.completedBy = completedBy;
    return result;
  }

  ExposureTask._();

  factory ExposureTask.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExposureTask.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExposureTask',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aOS(2, _omitFieldNames ? '' : 'exposureId')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'dueBy',
        subBuilder: $0.Timestamp.create)
    ..aE<TaskState>(5, _omitFieldNames ? '' : 'state',
        enumValues: TaskState.values)
    ..aOS(6, _omitFieldNames ? '' : 'outcome')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'completedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExposureTask clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExposureTask copyWith(void Function(ExposureTask) updates) =>
      super.copyWith((message) => updates(message as ExposureTask))
          as ExposureTask;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExposureTask create() => ExposureTask._();
  @$core.override
  ExposureTask createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExposureTask getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExposureTask>(create);
  static ExposureTask? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get exposureId => $_getSZ(1);
  @$pb.TagNumber(2)
  set exposureId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExposureId() => $_has(1);
  @$pb.TagNumber(2)
  void clearExposureId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  /// When it stops being useful, counted from the exposure and not from the
  /// report.
  @$pb.TagNumber(4)
  $0.Timestamp get dueBy => $_getN(3);
  @$pb.TagNumber(4)
  set dueBy($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDueBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearDueBy() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureDueBy() => $_ensure(3);

  @$pb.TagNumber(5)
  TaskState get state => $_getN(4);
  @$pb.TagNumber(5)
  set state(TaskState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasState() => $_has(4);
  @$pb.TagNumber(5)
  void clearState() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get outcome => $_getSZ(5);
  @$pb.TagNumber(6)
  set outcome($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOutcome() => $_has(5);
  @$pb.TagNumber(6)
  void clearOutcome() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get completedAt => $_getN(6);
  @$pb.TagNumber(7)
  set completedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCompletedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCompletedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureCompletedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get completedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set completedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCompletedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearCompletedBy() => $_clearField(8);
}

/// A configured stewardship review trigger (SRS-IPC-008).
class StewardshipRule extends $pb.GeneratedMessage {
  factory StewardshipRule({
    $core.String? ruleId,
    $core.String? code,
    $core.String? name,
    $core.int? revision,
    TriggerKind? kind,
    $core.Iterable<$core.String>? agents,
    $core.bool? allAgents,
    $core.int? dayThreshold,
    $core.String? prompt,
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
    if (kind != null) result.kind = kind;
    if (agents != null) result.agents.addAll(agents);
    if (allAgents != null) result.allAgents = allAgents;
    if (dayThreshold != null) result.dayThreshold = dayThreshold;
    if (prompt != null) result.prompt = prompt;
    if (approved != null) result.approved = approved;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (supersededAt != null) result.supersededAt = supersededAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    return result;
  }

  StewardshipRule._();

  factory StewardshipRule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StewardshipRule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StewardshipRule',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ruleId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aI(4, _omitFieldNames ? '' : 'revision')
    ..aE<TriggerKind>(5, _omitFieldNames ? '' : 'kind',
        enumValues: TriggerKind.values)
    ..pPS(6, _omitFieldNames ? '' : 'agents')
    ..aOB(7, _omitFieldNames ? '' : 'allAgents')
    ..aI(8, _omitFieldNames ? '' : 'dayThreshold')
    ..aOS(9, _omitFieldNames ? '' : 'prompt')
    ..aOB(10, _omitFieldNames ? '' : 'approved')
    ..aOS(11, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'approvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'supersededAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'createdBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StewardshipRule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StewardshipRule copyWith(void Function(StewardshipRule) updates) =>
      super.copyWith((message) => updates(message as StewardshipRule))
          as StewardshipRule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StewardshipRule create() => StewardshipRule._();
  @$core.override
  StewardshipRule createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StewardshipRule getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StewardshipRule>(create);
  static StewardshipRule? _defaultInstance;

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
  TriggerKind get kind => $_getN(4);
  @$pb.TagNumber(5)
  set kind(TriggerKind value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearKind() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get agents => $_getList(5);

  /// Explicit rather than inferred from an empty agent list: a rule that
  /// silently widened to everything would flood the worklist, and a flooded
  /// worklist is an unread one.
  @$pb.TagNumber(7)
  $core.bool get allAgents => $_getBF(6);
  @$pb.TagNumber(7)
  set allAgents($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAllAgents() => $_has(6);
  @$pb.TagNumber(7)
  void clearAllAgents() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get dayThreshold => $_getIZ(7);
  @$pb.TagNumber(8)
  set dayThreshold($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDayThreshold() => $_has(7);
  @$pb.TagNumber(8)
  void clearDayThreshold() => $_clearField(8);

  /// The question put to the reviewer. A trigger that says only "review" gets
  /// a review that says only "continue".
  @$pb.TagNumber(9)
  $core.String get prompt => $_getSZ(8);
  @$pb.TagNumber(9)
  set prompt($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPrompt() => $_has(8);
  @$pb.TagNumber(9)
  void clearPrompt() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get approved => $_getBF(9);
  @$pb.TagNumber(10)
  set approved($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasApproved() => $_has(9);
  @$pb.TagNumber(10)
  void clearApproved() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get approvedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set approvedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasApprovedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearApprovedBy() => $_clearField(11);

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
  $0.Timestamp get effectiveFrom => $_getN(12);
  @$pb.TagNumber(13)
  set effectiveFrom($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasEffectiveFrom() => $_has(12);
  @$pb.TagNumber(13)
  void clearEffectiveFrom() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Timestamp get supersededAt => $_getN(13);
  @$pb.TagNumber(14)
  set supersededAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasSupersededAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearSupersededAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureSupersededAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $0.Timestamp get createdAt => $_getN(14);
  @$pb.TagNumber(15)
  set createdAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasCreatedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearCreatedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureCreatedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get createdBy => $_getSZ(15);
  @$pb.TagNumber(16)
  set createdBy($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCreatedBy() => $_has(15);
  @$pb.TagNumber(16)
  void clearCreatedBy() => $_clearField(16);
}

/// One stewardship worklist entry (SRS-IPC-008).
///
/// order_id is a reference a reviewer opens. There is no field here that
/// changes a prescription.
class StewardshipReview extends $pb.GeneratedMessage {
  factory StewardshipReview({
    $core.String? reviewId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? locationId,
    $core.String? ruleId,
    $core.String? ruleCode,
    $core.int? ruleRevision,
    TriggerKind? kind,
    $core.String? agent,
    $core.String? orderId,
    $core.String? why,
    ReviewState? state,
    $0.Timestamp? raisedAt,
    $0.Timestamp? dueBy,
    Recommendation? recommendation,
    $core.String? advice,
    $core.String? reviewedBy,
    $0.Timestamp? reviewedAt,
    Response? response,
    $core.String? responseReason,
    $core.String? respondedBy,
    $0.Timestamp? respondedAt,
    $core.String? withdrawnReason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (reviewId != null) result.reviewId = reviewId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (locationId != null) result.locationId = locationId;
    if (ruleId != null) result.ruleId = ruleId;
    if (ruleCode != null) result.ruleCode = ruleCode;
    if (ruleRevision != null) result.ruleRevision = ruleRevision;
    if (kind != null) result.kind = kind;
    if (agent != null) result.agent = agent;
    if (orderId != null) result.orderId = orderId;
    if (why != null) result.why = why;
    if (state != null) result.state = state;
    if (raisedAt != null) result.raisedAt = raisedAt;
    if (dueBy != null) result.dueBy = dueBy;
    if (recommendation != null) result.recommendation = recommendation;
    if (advice != null) result.advice = advice;
    if (reviewedBy != null) result.reviewedBy = reviewedBy;
    if (reviewedAt != null) result.reviewedAt = reviewedAt;
    if (response != null) result.response = response;
    if (responseReason != null) result.responseReason = responseReason;
    if (respondedBy != null) result.respondedBy = respondedBy;
    if (respondedAt != null) result.respondedAt = respondedAt;
    if (withdrawnReason != null) result.withdrawnReason = withdrawnReason;
    if (version != null) result.version = version;
    return result;
  }

  StewardshipReview._();

  factory StewardshipReview.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StewardshipReview.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StewardshipReview',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'locationId')
    ..aOS(5, _omitFieldNames ? '' : 'ruleId')
    ..aOS(6, _omitFieldNames ? '' : 'ruleCode')
    ..aI(7, _omitFieldNames ? '' : 'ruleRevision')
    ..aE<TriggerKind>(8, _omitFieldNames ? '' : 'kind',
        enumValues: TriggerKind.values)
    ..aOS(9, _omitFieldNames ? '' : 'agent')
    ..aOS(10, _omitFieldNames ? '' : 'orderId')
    ..aOS(11, _omitFieldNames ? '' : 'why')
    ..aE<ReviewState>(12, _omitFieldNames ? '' : 'state',
        enumValues: ReviewState.values)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'raisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'dueBy',
        subBuilder: $0.Timestamp.create)
    ..aE<Recommendation>(15, _omitFieldNames ? '' : 'recommendation',
        enumValues: Recommendation.values)
    ..aOS(16, _omitFieldNames ? '' : 'advice')
    ..aOS(17, _omitFieldNames ? '' : 'reviewedBy')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'reviewedAt',
        subBuilder: $0.Timestamp.create)
    ..aE<Response>(19, _omitFieldNames ? '' : 'response',
        enumValues: Response.values)
    ..aOS(20, _omitFieldNames ? '' : 'responseReason')
    ..aOS(21, _omitFieldNames ? '' : 'respondedBy')
    ..aOM<$0.Timestamp>(22, _omitFieldNames ? '' : 'respondedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(23, _omitFieldNames ? '' : 'withdrawnReason')
    ..aInt64(24, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StewardshipReview clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StewardshipReview copyWith(void Function(StewardshipReview) updates) =>
      super.copyWith((message) => updates(message as StewardshipReview))
          as StewardshipReview;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StewardshipReview create() => StewardshipReview._();
  @$core.override
  StewardshipReview createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StewardshipReview getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StewardshipReview>(create);
  static StewardshipReview? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);

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
  $core.String get locationId => $_getSZ(3);
  @$pb.TagNumber(4)
  set locationId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocationId() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocationId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get ruleId => $_getSZ(4);
  @$pb.TagNumber(5)
  set ruleId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRuleId() => $_has(4);
  @$pb.TagNumber(5)
  void clearRuleId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get ruleCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set ruleCode($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRuleCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearRuleCode() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get ruleRevision => $_getIZ(6);
  @$pb.TagNumber(7)
  set ruleRevision($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRuleRevision() => $_has(6);
  @$pb.TagNumber(7)
  void clearRuleRevision() => $_clearField(7);

  @$pb.TagNumber(8)
  TriggerKind get kind => $_getN(7);
  @$pb.TagNumber(8)
  set kind(TriggerKind value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasKind() => $_has(7);
  @$pb.TagNumber(8)
  void clearKind() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get agent => $_getSZ(8);
  @$pb.TagNumber(9)
  set agent($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAgent() => $_has(8);
  @$pb.TagNumber(9)
  void clearAgent() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get orderId => $_getSZ(9);
  @$pb.TagNumber(10)
  set orderId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasOrderId() => $_has(9);
  @$pb.TagNumber(10)
  void clearOrderId() => $_clearField(10);

  /// The fact that fired the rule, in words a prescriber reads.
  @$pb.TagNumber(11)
  $core.String get why => $_getSZ(10);
  @$pb.TagNumber(11)
  set why($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasWhy() => $_has(10);
  @$pb.TagNumber(11)
  void clearWhy() => $_clearField(11);

  @$pb.TagNumber(12)
  ReviewState get state => $_getN(11);
  @$pb.TagNumber(12)
  set state(ReviewState value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasState() => $_has(11);
  @$pb.TagNumber(12)
  void clearState() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get raisedAt => $_getN(12);
  @$pb.TagNumber(13)
  set raisedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasRaisedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearRaisedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureRaisedAt() => $_ensure(12);

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
  Recommendation get recommendation => $_getN(14);
  @$pb.TagNumber(15)
  set recommendation(Recommendation value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasRecommendation() => $_has(14);
  @$pb.TagNumber(15)
  void clearRecommendation() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get advice => $_getSZ(15);
  @$pb.TagNumber(16)
  set advice($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasAdvice() => $_has(15);
  @$pb.TagNumber(16)
  void clearAdvice() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get reviewedBy => $_getSZ(16);
  @$pb.TagNumber(17)
  set reviewedBy($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasReviewedBy() => $_has(16);
  @$pb.TagNumber(17)
  void clearReviewedBy() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get reviewedAt => $_getN(17);
  @$pb.TagNumber(18)
  set reviewedAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasReviewedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearReviewedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureReviewedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  Response get response => $_getN(18);
  @$pb.TagNumber(19)
  set response(Response value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasResponse() => $_has(18);
  @$pb.TagNumber(19)
  void clearResponse() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get responseReason => $_getSZ(19);
  @$pb.TagNumber(20)
  set responseReason($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasResponseReason() => $_has(19);
  @$pb.TagNumber(20)
  void clearResponseReason() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get respondedBy => $_getSZ(20);
  @$pb.TagNumber(21)
  set respondedBy($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasRespondedBy() => $_has(20);
  @$pb.TagNumber(21)
  void clearRespondedBy() => $_clearField(21);

  @$pb.TagNumber(22)
  $0.Timestamp get respondedAt => $_getN(21);
  @$pb.TagNumber(22)
  set respondedAt($0.Timestamp value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasRespondedAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearRespondedAt() => $_clearField(22);
  @$pb.TagNumber(22)
  $0.Timestamp ensureRespondedAt() => $_ensure(21);

  @$pb.TagNumber(23)
  $core.String get withdrawnReason => $_getSZ(22);
  @$pb.TagNumber(23)
  set withdrawnReason($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasWithdrawnReason() => $_has(22);
  @$pb.TagNumber(23)
  void clearWithdrawnReason() => $_clearField(23);

  @$pb.TagNumber(24)
  $fixnum.Int64 get version => $_getI64(23);
  @$pb.TagNumber(24)
  set version($fixnum.Int64 value) => $_setInt64(23, value);
  @$pb.TagNumber(24)
  $core.bool hasVersion() => $_has(23);
  @$pb.TagNumber(24)
  void clearVersion() => $_clearField(24);
}

/// Days of therapy against patient days (SRS-IPC-010).
class TherapyRate extends $pb.GeneratedMessage {
  factory TherapyRate({
    $core.int? therapyDays,
    $core.int? patientDays,
    $core.int? perThousandTenths,
    $core.bool? unanswerable,
  }) {
    final result = create();
    if (therapyDays != null) result.therapyDays = therapyDays;
    if (patientDays != null) result.patientDays = patientDays;
    if (perThousandTenths != null) result.perThousandTenths = perThousandTenths;
    if (unanswerable != null) result.unanswerable = unanswerable;
    return result;
  }

  TherapyRate._();

  factory TherapyRate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TherapyRate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TherapyRate',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'therapyDays')
    ..aI(2, _omitFieldNames ? '' : 'patientDays')
    ..aI(3, _omitFieldNames ? '' : 'perThousandTenths')
    ..aOB(4, _omitFieldNames ? '' : 'unanswerable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TherapyRate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TherapyRate copyWith(void Function(TherapyRate) updates) =>
      super.copyWith((message) => updates(message as TherapyRate))
          as TherapyRate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TherapyRate create() => TherapyRate._();
  @$core.override
  TherapyRate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TherapyRate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TherapyRate>(create);
  static TherapyRate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get therapyDays => $_getIZ(0);
  @$pb.TagNumber(1)
  set therapyDays($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTherapyDays() => $_has(0);
  @$pb.TagNumber(1)
  void clearTherapyDays() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get patientDays => $_getIZ(1);
  @$pb.TagNumber(2)
  set patientDays($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientDays() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientDays() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get perThousandTenths => $_getIZ(2);
  @$pb.TagNumber(3)
  set perThousandTenths($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPerThousandTenths() => $_has(2);
  @$pb.TagNumber(3)
  void clearPerThousandTenths() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get unanswerable => $_getBF(3);
  @$pb.TagNumber(4)
  set unanswerable($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnanswerable() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnanswerable() => $_clearField(4);
}

/// The stewardship programme's numbers (SRS-IPC-008, SRS-IPC-010).
class StewardshipSummary extends $pb.GeneratedMessage {
  factory StewardshipSummary({
    $core.int? raised,
    $core.int? awaiting,
    $core.int? advised,
    $core.int? accepted,
    $core.int? modified,
    $core.int? declined,
    $core.int? withdrawn,
    $core.int? overdue,
    $core.int? acceptancePermille,
    $core.bool? unanswerable,
    TherapyRate? therapyRate,
    $core.String? indicatorCode,
    $core.int? indicatorRevision,
  }) {
    final result = create();
    if (raised != null) result.raised = raised;
    if (awaiting != null) result.awaiting = awaiting;
    if (advised != null) result.advised = advised;
    if (accepted != null) result.accepted = accepted;
    if (modified != null) result.modified = modified;
    if (declined != null) result.declined = declined;
    if (withdrawn != null) result.withdrawn = withdrawn;
    if (overdue != null) result.overdue = overdue;
    if (acceptancePermille != null)
      result.acceptancePermille = acceptancePermille;
    if (unanswerable != null) result.unanswerable = unanswerable;
    if (therapyRate != null) result.therapyRate = therapyRate;
    if (indicatorCode != null) result.indicatorCode = indicatorCode;
    if (indicatorRevision != null) result.indicatorRevision = indicatorRevision;
    return result;
  }

  StewardshipSummary._();

  factory StewardshipSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StewardshipSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StewardshipSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'raised')
    ..aI(2, _omitFieldNames ? '' : 'awaiting')
    ..aI(3, _omitFieldNames ? '' : 'advised')
    ..aI(4, _omitFieldNames ? '' : 'accepted')
    ..aI(5, _omitFieldNames ? '' : 'modified')
    ..aI(6, _omitFieldNames ? '' : 'declined')
    ..aI(7, _omitFieldNames ? '' : 'withdrawn')
    ..aI(8, _omitFieldNames ? '' : 'overdue')
    ..aI(9, _omitFieldNames ? '' : 'acceptancePermille')
    ..aOB(10, _omitFieldNames ? '' : 'unanswerable')
    ..aOM<TherapyRate>(11, _omitFieldNames ? '' : 'therapyRate',
        subBuilder: TherapyRate.create)
    ..aOS(12, _omitFieldNames ? '' : 'indicatorCode')
    ..aI(13, _omitFieldNames ? '' : 'indicatorRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StewardshipSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StewardshipSummary copyWith(void Function(StewardshipSummary) updates) =>
      super.copyWith((message) => updates(message as StewardshipSummary))
          as StewardshipSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StewardshipSummary create() => StewardshipSummary._();
  @$core.override
  StewardshipSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StewardshipSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StewardshipSummary>(create);
  static StewardshipSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get raised => $_getIZ(0);
  @$pb.TagNumber(1)
  set raised($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRaised() => $_has(0);
  @$pb.TagNumber(1)
  void clearRaised() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get awaiting => $_getIZ(1);
  @$pb.TagNumber(2)
  set awaiting($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAwaiting() => $_has(1);
  @$pb.TagNumber(2)
  void clearAwaiting() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get advised => $_getIZ(2);
  @$pb.TagNumber(3)
  set advised($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAdvised() => $_has(2);
  @$pb.TagNumber(3)
  void clearAdvised() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get accepted => $_getIZ(3);
  @$pb.TagNumber(4)
  set accepted($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAccepted() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccepted() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get modified => $_getIZ(4);
  @$pb.TagNumber(5)
  set modified($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasModified() => $_has(4);
  @$pb.TagNumber(5)
  void clearModified() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get declined => $_getIZ(5);
  @$pb.TagNumber(6)
  set declined($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDeclined() => $_has(5);
  @$pb.TagNumber(6)
  void clearDeclined() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get withdrawn => $_getIZ(6);
  @$pb.TagNumber(7)
  set withdrawn($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWithdrawn() => $_has(6);
  @$pb.TagNumber(7)
  void clearWithdrawn() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get overdue => $_getIZ(7);
  @$pb.TagNumber(8)
  set overdue($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOverdue() => $_has(7);
  @$pb.TagNumber(8)
  void clearOverdue() => $_clearField(8);

  /// Accepted over the advice that got a response, parts per thousand.
  /// Modified counts in the denominator and not the numerator.
  @$pb.TagNumber(9)
  $core.int get acceptancePermille => $_getIZ(8);
  @$pb.TagNumber(9)
  set acceptancePermille($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAcceptancePermille() => $_has(8);
  @$pb.TagNumber(9)
  void clearAcceptancePermille() => $_clearField(9);

  /// Advice nobody has responded to yet. Reporting zero would read as
  /// universal refusal.
  @$pb.TagNumber(10)
  $core.bool get unanswerable => $_getBF(9);
  @$pb.TagNumber(10)
  set unanswerable($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUnanswerable() => $_has(9);
  @$pb.TagNumber(10)
  void clearUnanswerable() => $_clearField(10);

  @$pb.TagNumber(11)
  TherapyRate get therapyRate => $_getN(10);
  @$pb.TagNumber(11)
  set therapyRate(TherapyRate value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasTherapyRate() => $_has(10);
  @$pb.TagNumber(11)
  void clearTherapyRate() => $_clearField(11);
  @$pb.TagNumber(11)
  TherapyRate ensureTherapyRate() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get indicatorCode => $_getSZ(11);
  @$pb.TagNumber(12)
  set indicatorCode($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasIndicatorCode() => $_has(11);
  @$pb.TagNumber(12)
  void clearIndicatorCode() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get indicatorRevision => $_getIZ(12);
  @$pb.TagNumber(13)
  set indicatorRevision($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasIndicatorRevision() => $_has(12);
  @$pb.TagNumber(13)
  void clearIndicatorRevision() => $_clearField(13);
}

/// A versioned environmental threshold (SRS-IPC-009, SRS-IPC-010).
class EnvironmentalLimit extends $pb.GeneratedMessage {
  factory EnvironmentalLimit({
    $core.String? limitId,
    $core.String? code,
    $core.String? name,
    $core.int? revision,
    SampleKind? sampleKind,
    $core.String? unit,
    $fixnum.Int64? actionLevel,
    $fixnum.Int64? failLevel,
    $core.bool? detectionFails,
    $core.bool? belowIsFailure,
    $core.bool? approved,
    $core.String? approvedBy,
    $0.Timestamp? approvedAt,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? supersededAt,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
  }) {
    final result = create();
    if (limitId != null) result.limitId = limitId;
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (revision != null) result.revision = revision;
    if (sampleKind != null) result.sampleKind = sampleKind;
    if (unit != null) result.unit = unit;
    if (actionLevel != null) result.actionLevel = actionLevel;
    if (failLevel != null) result.failLevel = failLevel;
    if (detectionFails != null) result.detectionFails = detectionFails;
    if (belowIsFailure != null) result.belowIsFailure = belowIsFailure;
    if (approved != null) result.approved = approved;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (supersededAt != null) result.supersededAt = supersededAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    return result;
  }

  EnvironmentalLimit._();

  factory EnvironmentalLimit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnvironmentalLimit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnvironmentalLimit',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'limitId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aI(4, _omitFieldNames ? '' : 'revision')
    ..aE<SampleKind>(5, _omitFieldNames ? '' : 'sampleKind',
        enumValues: SampleKind.values)
    ..aOS(6, _omitFieldNames ? '' : 'unit')
    ..aInt64(7, _omitFieldNames ? '' : 'actionLevel')
    ..aInt64(8, _omitFieldNames ? '' : 'failLevel')
    ..aOB(9, _omitFieldNames ? '' : 'detectionFails')
    ..aOB(10, _omitFieldNames ? '' : 'belowIsFailure')
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
  EnvironmentalLimit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnvironmentalLimit copyWith(void Function(EnvironmentalLimit) updates) =>
      super.copyWith((message) => updates(message as EnvironmentalLimit))
          as EnvironmentalLimit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnvironmentalLimit create() => EnvironmentalLimit._();
  @$core.override
  EnvironmentalLimit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnvironmentalLimit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnvironmentalLimit>(create);
  static EnvironmentalLimit? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get limitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set limitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimitId() => $_clearField(1);

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
  SampleKind get sampleKind => $_getN(4);
  @$pb.TagNumber(5)
  set sampleKind(SampleKind value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSampleKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearSampleKind() => $_clearField(5);

  /// The unit the values are counted in — cfu/ml, cfu/plate, particles/m3,
  /// tenths of a pascal. Integers, so two reports of one sample cannot differ
  /// by a rounding.
  @$pb.TagNumber(6)
  $core.String get unit => $_getSZ(5);
  @$pb.TagNumber(6)
  set unit($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUnit() => $_has(5);
  @$pb.TagNumber(6)
  void clearUnit() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get actionLevel => $_getI64(6);
  @$pb.TagNumber(7)
  set actionLevel($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasActionLevel() => $_has(6);
  @$pb.TagNumber(7)
  void clearActionLevel() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get failLevel => $_getI64(7);
  @$pb.TagNumber(8)
  set failLevel($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFailLevel() => $_has(7);
  @$pb.TagNumber(8)
  void clearFailLevel() => $_clearField(8);

  /// Any detection fails regardless of count.
  @$pb.TagNumber(9)
  $core.bool get detectionFails => $_getBF(8);
  @$pb.TagNumber(9)
  set detectionFails($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDetectionFails() => $_has(8);
  @$pb.TagNumber(9)
  void clearDetectionFails() => $_clearField(9);

  /// Inverts the comparison where low is bad: a negative-pressure room, an
  /// air-change rate.
  @$pb.TagNumber(10)
  $core.bool get belowIsFailure => $_getBF(9);
  @$pb.TagNumber(10)
  set belowIsFailure($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasBelowIsFailure() => $_has(9);
  @$pb.TagNumber(10)
  void clearBelowIsFailure() => $_clearField(10);

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

/// A configured sampling schedule for a point (SRS-IPC-009).
class SamplingPlan extends $pb.GeneratedMessage {
  factory SamplingPlan({
    $core.String? planId,
    $core.String? code,
    SampleKind? sampleKind,
    $core.String? facilityId,
    $core.String? locationId,
    $core.String? samplePoint,
    $core.int? everyDays,
    $core.bool? active,
    $0.Timestamp? startedAt,
    $0.Timestamp? stoppedAt,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    if (code != null) result.code = code;
    if (sampleKind != null) result.sampleKind = sampleKind;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (samplePoint != null) result.samplePoint = samplePoint;
    if (everyDays != null) result.everyDays = everyDays;
    if (active != null) result.active = active;
    if (startedAt != null) result.startedAt = startedAt;
    if (stoppedAt != null) result.stoppedAt = stoppedAt;
    return result;
  }

  SamplingPlan._();

  factory SamplingPlan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SamplingPlan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SamplingPlan',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'planId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aE<SampleKind>(3, _omitFieldNames ? '' : 'sampleKind',
        enumValues: SampleKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'locationId')
    ..aOS(6, _omitFieldNames ? '' : 'samplePoint')
    ..aI(7, _omitFieldNames ? '' : 'everyDays')
    ..aOB(8, _omitFieldNames ? '' : 'active')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'stoppedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SamplingPlan clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SamplingPlan copyWith(void Function(SamplingPlan) updates) =>
      super.copyWith((message) => updates(message as SamplingPlan))
          as SamplingPlan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SamplingPlan create() => SamplingPlan._();
  @$core.override
  SamplingPlan createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SamplingPlan getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SamplingPlan>(create);
  static SamplingPlan? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get planId => $_getSZ(0);
  @$pb.TagNumber(1)
  set planId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  SampleKind get sampleKind => $_getN(2);
  @$pb.TagNumber(3)
  set sampleKind(SampleKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSampleKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearSampleKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get locationId => $_getSZ(4);
  @$pb.TagNumber(5)
  set locationId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLocationId() => $_has(4);
  @$pb.TagNumber(5)
  void clearLocationId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get samplePoint => $_getSZ(5);
  @$pb.TagNumber(6)
  set samplePoint($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSamplePoint() => $_has(5);
  @$pb.TagNumber(6)
  void clearSamplePoint() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get everyDays => $_getIZ(6);
  @$pb.TagNumber(7)
  set everyDays($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEveryDays() => $_has(6);
  @$pb.TagNumber(7)
  void clearEveryDays() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get active => $_getBF(7);
  @$pb.TagNumber(8)
  set active($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasActive() => $_has(7);
  @$pb.TagNumber(8)
  void clearActive() => $_clearField(8);

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
  $0.Timestamp get stoppedAt => $_getN(9);
  @$pb.TagNumber(10)
  set stoppedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStoppedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearStoppedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureStoppedAt() => $_ensure(9);
}

/// One water, air or surface test (SRS-IPC-009).
class EnvironmentalSample extends $pb.GeneratedMessage {
  factory EnvironmentalSample({
    $core.String? sampleId,
    $core.String? reference,
    SampleKind? sampleKind,
    $core.String? facilityId,
    $core.String? locationId,
    $core.String? samplePoint,
    $core.String? planId,
    $core.String? outbreakId,
    $core.String? repeatOfId,
    $0.Timestamp? collectedAt,
    $core.String? collectedBy,
    $core.String? method,
    SampleState? state,
    $core.String? labReference,
    $fixnum.Int64? value,
    $core.String? unit,
    $core.String? organism,
    $core.bool? detected,
    $0.Timestamp? resultedAt,
    $core.String? resultedBy,
    Outcome? outcome,
    $core.String? limitCode,
    $core.int? limitRevision,
    $0.Timestamp? closedAt,
    $core.String? closedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (sampleId != null) result.sampleId = sampleId;
    if (reference != null) result.reference = reference;
    if (sampleKind != null) result.sampleKind = sampleKind;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (samplePoint != null) result.samplePoint = samplePoint;
    if (planId != null) result.planId = planId;
    if (outbreakId != null) result.outbreakId = outbreakId;
    if (repeatOfId != null) result.repeatOfId = repeatOfId;
    if (collectedAt != null) result.collectedAt = collectedAt;
    if (collectedBy != null) result.collectedBy = collectedBy;
    if (method != null) result.method = method;
    if (state != null) result.state = state;
    if (labReference != null) result.labReference = labReference;
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (organism != null) result.organism = organism;
    if (detected != null) result.detected = detected;
    if (resultedAt != null) result.resultedAt = resultedAt;
    if (resultedBy != null) result.resultedBy = resultedBy;
    if (outcome != null) result.outcome = outcome;
    if (limitCode != null) result.limitCode = limitCode;
    if (limitRevision != null) result.limitRevision = limitRevision;
    if (closedAt != null) result.closedAt = closedAt;
    if (closedBy != null) result.closedBy = closedBy;
    if (version != null) result.version = version;
    return result;
  }

  EnvironmentalSample._();

  factory EnvironmentalSample.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnvironmentalSample.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnvironmentalSample',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sampleId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aE<SampleKind>(3, _omitFieldNames ? '' : 'sampleKind',
        enumValues: SampleKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'locationId')
    ..aOS(6, _omitFieldNames ? '' : 'samplePoint')
    ..aOS(7, _omitFieldNames ? '' : 'planId')
    ..aOS(8, _omitFieldNames ? '' : 'outbreakId')
    ..aOS(9, _omitFieldNames ? '' : 'repeatOfId')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'collectedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'collectedBy')
    ..aOS(12, _omitFieldNames ? '' : 'method')
    ..aE<SampleState>(13, _omitFieldNames ? '' : 'state',
        enumValues: SampleState.values)
    ..aOS(14, _omitFieldNames ? '' : 'labReference')
    ..aInt64(15, _omitFieldNames ? '' : 'value')
    ..aOS(16, _omitFieldNames ? '' : 'unit')
    ..aOS(17, _omitFieldNames ? '' : 'organism')
    ..aOB(18, _omitFieldNames ? '' : 'detected')
    ..aOM<$0.Timestamp>(19, _omitFieldNames ? '' : 'resultedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(20, _omitFieldNames ? '' : 'resultedBy')
    ..aE<Outcome>(21, _omitFieldNames ? '' : 'outcome',
        enumValues: Outcome.values)
    ..aOS(22, _omitFieldNames ? '' : 'limitCode')
    ..aI(23, _omitFieldNames ? '' : 'limitRevision')
    ..aOM<$0.Timestamp>(24, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(25, _omitFieldNames ? '' : 'closedBy')
    ..aInt64(26, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnvironmentalSample clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnvironmentalSample copyWith(void Function(EnvironmentalSample) updates) =>
      super.copyWith((message) => updates(message as EnvironmentalSample))
          as EnvironmentalSample;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnvironmentalSample create() => EnvironmentalSample._();
  @$core.override
  EnvironmentalSample createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnvironmentalSample getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnvironmentalSample>(create);
  static EnvironmentalSample? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sampleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sampleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reference => $_getSZ(1);
  @$pb.TagNumber(2)
  set reference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearReference() => $_clearField(2);

  @$pb.TagNumber(3)
  SampleKind get sampleKind => $_getN(2);
  @$pb.TagNumber(3)
  set sampleKind(SampleKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSampleKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearSampleKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  /// Required. A positive result that names only "the hospital" tells the
  /// estates team nothing they can act on.
  @$pb.TagNumber(5)
  $core.String get locationId => $_getSZ(4);
  @$pb.TagNumber(5)
  set locationId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLocationId() => $_has(4);
  @$pb.TagNumber(5)
  void clearLocationId() => $_clearField(5);

  /// The tap, the duct, the bench. A ward has forty of them and they do not
  /// fail together.
  @$pb.TagNumber(6)
  $core.String get samplePoint => $_getSZ(5);
  @$pb.TagNumber(6)
  set samplePoint($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSamplePoint() => $_has(5);
  @$pb.TagNumber(6)
  void clearSamplePoint() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get planId => $_getSZ(6);
  @$pb.TagNumber(7)
  set planId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPlanId() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlanId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get outbreakId => $_getSZ(7);
  @$pb.TagNumber(8)
  set outbreakId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOutbreakId() => $_has(7);
  @$pb.TagNumber(8)
  void clearOutbreakId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get repeatOfId => $_getSZ(8);
  @$pb.TagNumber(9)
  set repeatOfId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRepeatOfId() => $_has(8);
  @$pb.TagNumber(9)
  void clearRepeatOfId() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get collectedAt => $_getN(9);
  @$pb.TagNumber(10)
  set collectedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCollectedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCollectedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureCollectedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get collectedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set collectedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCollectedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearCollectedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get method => $_getSZ(11);
  @$pb.TagNumber(12)
  set method($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMethod() => $_has(11);
  @$pb.TagNumber(12)
  void clearMethod() => $_clearField(12);

  @$pb.TagNumber(13)
  SampleState get state => $_getN(12);
  @$pb.TagNumber(13)
  set state(SampleState value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasState() => $_has(12);
  @$pb.TagNumber(13)
  void clearState() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get labReference => $_getSZ(13);
  @$pb.TagNumber(14)
  set labReference($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasLabReference() => $_has(13);
  @$pb.TagNumber(14)
  void clearLabReference() => $_clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get value => $_getI64(14);
  @$pb.TagNumber(15)
  set value($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasValue() => $_has(14);
  @$pb.TagNumber(15)
  void clearValue() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get unit => $_getSZ(15);
  @$pb.TagNumber(16)
  set unit($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasUnit() => $_has(15);
  @$pb.TagNumber(16)
  void clearUnit() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get organism => $_getSZ(16);
  @$pb.TagNumber(17)
  set organism($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasOrganism() => $_has(16);
  @$pb.TagNumber(17)
  void clearOrganism() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.bool get detected => $_getBF(17);
  @$pb.TagNumber(18)
  set detected($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(18)
  $core.bool hasDetected() => $_has(17);
  @$pb.TagNumber(18)
  void clearDetected() => $_clearField(18);

  @$pb.TagNumber(19)
  $0.Timestamp get resultedAt => $_getN(18);
  @$pb.TagNumber(19)
  set resultedAt($0.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasResultedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearResultedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Timestamp ensureResultedAt() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.String get resultedBy => $_getSZ(19);
  @$pb.TagNumber(20)
  set resultedBy($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasResultedBy() => $_has(19);
  @$pb.TagNumber(20)
  void clearResultedBy() => $_clearField(20);

  /// Derived from the limit in force when the result was reported. Read-only.
  @$pb.TagNumber(21)
  Outcome get outcome => $_getN(20);
  @$pb.TagNumber(21)
  set outcome(Outcome value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasOutcome() => $_has(20);
  @$pb.TagNumber(21)
  void clearOutcome() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.String get limitCode => $_getSZ(21);
  @$pb.TagNumber(22)
  set limitCode($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasLimitCode() => $_has(21);
  @$pb.TagNumber(22)
  void clearLimitCode() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.int get limitRevision => $_getIZ(22);
  @$pb.TagNumber(23)
  set limitRevision($core.int value) => $_setSignedInt32(22, value);
  @$pb.TagNumber(23)
  $core.bool hasLimitRevision() => $_has(22);
  @$pb.TagNumber(23)
  void clearLimitRevision() => $_clearField(23);

  @$pb.TagNumber(24)
  $0.Timestamp get closedAt => $_getN(23);
  @$pb.TagNumber(24)
  set closedAt($0.Timestamp value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasClosedAt() => $_has(23);
  @$pb.TagNumber(24)
  void clearClosedAt() => $_clearField(24);
  @$pb.TagNumber(24)
  $0.Timestamp ensureClosedAt() => $_ensure(23);

  @$pb.TagNumber(25)
  $core.String get closedBy => $_getSZ(24);
  @$pb.TagNumber(25)
  set closedBy($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasClosedBy() => $_has(24);
  @$pb.TagNumber(25)
  void clearClosedBy() => $_clearField(25);

  @$pb.TagNumber(26)
  $fixnum.Int64 get version => $_getI64(25);
  @$pb.TagNumber(26)
  set version($fixnum.Int64 value) => $_setInt64(25, value);
  @$pb.TagNumber(26)
  $core.bool hasVersion() => $_has(25);
  @$pb.TagNumber(26)
  void clearVersion() => $_clearField(26);
}

/// What was done about a failing result (SRS-IPC-009).
class CorrectiveAction extends $pb.GeneratedMessage {
  factory CorrectiveAction({
    $core.String? actionId,
    $core.String? sampleId,
    $core.String? locationId,
    $core.String? action,
    $core.String? owner,
    $0.Timestamp? dueBy,
    ActionState? state,
    $0.Timestamp? doneAt,
    $core.String? doneBy,
    $core.String? doneNote,
    $core.String? repeatSampleId,
    $0.Timestamp? verifiedAt,
    $core.String? verifiedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (actionId != null) result.actionId = actionId;
    if (sampleId != null) result.sampleId = sampleId;
    if (locationId != null) result.locationId = locationId;
    if (action != null) result.action = action;
    if (owner != null) result.owner = owner;
    if (dueBy != null) result.dueBy = dueBy;
    if (state != null) result.state = state;
    if (doneAt != null) result.doneAt = doneAt;
    if (doneBy != null) result.doneBy = doneBy;
    if (doneNote != null) result.doneNote = doneNote;
    if (repeatSampleId != null) result.repeatSampleId = repeatSampleId;
    if (verifiedAt != null) result.verifiedAt = verifiedAt;
    if (verifiedBy != null) result.verifiedBy = verifiedBy;
    if (version != null) result.version = version;
    return result;
  }

  CorrectiveAction._();

  factory CorrectiveAction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CorrectiveAction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CorrectiveAction',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'actionId')
    ..aOS(2, _omitFieldNames ? '' : 'sampleId')
    ..aOS(3, _omitFieldNames ? '' : 'locationId')
    ..aOS(4, _omitFieldNames ? '' : 'action')
    ..aOS(5, _omitFieldNames ? '' : 'owner')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'dueBy',
        subBuilder: $0.Timestamp.create)
    ..aE<ActionState>(7, _omitFieldNames ? '' : 'state',
        enumValues: ActionState.values)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'doneAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'doneBy')
    ..aOS(10, _omitFieldNames ? '' : 'doneNote')
    ..aOS(11, _omitFieldNames ? '' : 'repeatSampleId')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'verifiedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'verifiedBy')
    ..aInt64(14, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorrectiveAction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorrectiveAction copyWith(void Function(CorrectiveAction) updates) =>
      super.copyWith((message) => updates(message as CorrectiveAction))
          as CorrectiveAction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CorrectiveAction create() => CorrectiveAction._();
  @$core.override
  CorrectiveAction createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CorrectiveAction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CorrectiveAction>(create);
  static CorrectiveAction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get actionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set actionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearActionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sampleId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sampleId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSampleId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSampleId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get action => $_getSZ(3);
  @$pb.TagNumber(4)
  set action($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get owner => $_getSZ(4);
  @$pb.TagNumber(5)
  set owner($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOwner() => $_has(4);
  @$pb.TagNumber(5)
  void clearOwner() => $_clearField(5);

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

  @$pb.TagNumber(7)
  ActionState get state => $_getN(6);
  @$pb.TagNumber(7)
  set state(ActionState value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasState() => $_has(6);
  @$pb.TagNumber(7)
  void clearState() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get doneAt => $_getN(7);
  @$pb.TagNumber(8)
  set doneAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDoneAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearDoneAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureDoneAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get doneBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set doneBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDoneBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearDoneBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get doneNote => $_getSZ(9);
  @$pb.TagNumber(10)
  set doneNote($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDoneNote() => $_has(9);
  @$pb.TagNumber(10)
  void clearDoneNote() => $_clearField(10);

  /// The repeat that verified it: same point, taken after the work, passed.
  @$pb.TagNumber(11)
  $core.String get repeatSampleId => $_getSZ(10);
  @$pb.TagNumber(11)
  set repeatSampleId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRepeatSampleId() => $_has(10);
  @$pb.TagNumber(11)
  void clearRepeatSampleId() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get verifiedAt => $_getN(11);
  @$pb.TagNumber(12)
  set verifiedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasVerifiedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearVerifiedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureVerifiedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get verifiedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set verifiedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasVerifiedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearVerifiedBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get version => $_getI64(13);
  @$pb.TagNumber(14)
  set version($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasVersion() => $_has(13);
  @$pb.TagNumber(14)
  void clearVersion() => $_clearField(14);
}

/// One sampling point that is due or overdue (SRS-IPC-009).
class DuePoint extends $pb.GeneratedMessage {
  factory DuePoint({
    $core.String? planId,
    SampleKind? sampleKind,
    $core.String? locationId,
    $core.String? samplePoint,
    $0.Timestamp? lastTakenAt,
    $0.Timestamp? dueAt,
    $core.int? overdueDays,
    $core.bool? neverSampled,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    if (sampleKind != null) result.sampleKind = sampleKind;
    if (locationId != null) result.locationId = locationId;
    if (samplePoint != null) result.samplePoint = samplePoint;
    if (lastTakenAt != null) result.lastTakenAt = lastTakenAt;
    if (dueAt != null) result.dueAt = dueAt;
    if (overdueDays != null) result.overdueDays = overdueDays;
    if (neverSampled != null) result.neverSampled = neverSampled;
    return result;
  }

  DuePoint._();

  factory DuePoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DuePoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DuePoint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'planId')
    ..aE<SampleKind>(2, _omitFieldNames ? '' : 'sampleKind',
        enumValues: SampleKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'locationId')
    ..aOS(4, _omitFieldNames ? '' : 'samplePoint')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'lastTakenAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'dueAt',
        subBuilder: $0.Timestamp.create)
    ..aI(7, _omitFieldNames ? '' : 'overdueDays')
    ..aOB(8, _omitFieldNames ? '' : 'neverSampled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DuePoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DuePoint copyWith(void Function(DuePoint) updates) =>
      super.copyWith((message) => updates(message as DuePoint)) as DuePoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DuePoint create() => DuePoint._();
  @$core.override
  DuePoint createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DuePoint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DuePoint>(create);
  static DuePoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get planId => $_getSZ(0);
  @$pb.TagNumber(1)
  set planId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanId() => $_clearField(1);

  @$pb.TagNumber(2)
  SampleKind get sampleKind => $_getN(1);
  @$pb.TagNumber(2)
  set sampleKind(SampleKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSampleKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearSampleKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get samplePoint => $_getSZ(3);
  @$pb.TagNumber(4)
  set samplePoint($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSamplePoint() => $_has(3);
  @$pb.TagNumber(4)
  void clearSamplePoint() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get lastTakenAt => $_getN(4);
  @$pb.TagNumber(5)
  set lastTakenAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLastTakenAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastTakenAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureLastTakenAt() => $_ensure(4);

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

  @$pb.TagNumber(7)
  $core.int get overdueDays => $_getIZ(6);
  @$pb.TagNumber(7)
  set overdueDays($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOverdueDays() => $_has(6);
  @$pb.TagNumber(7)
  void clearOverdueDays() => $_clearField(7);

  /// A point with a plan and no sample at all. Reported separately because it
  /// is the worst case and a "days overdue" column shows it as a blank.
  @$pb.TagNumber(8)
  $core.bool get neverSampled => $_getBF(7);
  @$pb.TagNumber(8)
  set neverSampled($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNeverSampled() => $_has(7);
  @$pb.TagNumber(8)
  void clearNeverSampled() => $_clearField(8);
}

/// A period's environmental testing (SRS-IPC-010).
class EnvironmentSummary extends $pb.GeneratedMessage {
  factory EnvironmentSummary({
    $core.int? samples,
    $core.int? passed,
    $core.int? actionLevel,
    $core.int? failed,
    $core.int? unassessable,
    $core.int? actionsOpen,
    $core.int? actionsDone,
    $core.int? actionsVerified,
    $core.int? passPermille,
    $core.bool? unanswerable,
  }) {
    final result = create();
    if (samples != null) result.samples = samples;
    if (passed != null) result.passed = passed;
    if (actionLevel != null) result.actionLevel = actionLevel;
    if (failed != null) result.failed = failed;
    if (unassessable != null) result.unassessable = unassessable;
    if (actionsOpen != null) result.actionsOpen = actionsOpen;
    if (actionsDone != null) result.actionsDone = actionsDone;
    if (actionsVerified != null) result.actionsVerified = actionsVerified;
    if (passPermille != null) result.passPermille = passPermille;
    if (unanswerable != null) result.unanswerable = unanswerable;
    return result;
  }

  EnvironmentSummary._();

  factory EnvironmentSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnvironmentSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnvironmentSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'samples')
    ..aI(2, _omitFieldNames ? '' : 'passed')
    ..aI(3, _omitFieldNames ? '' : 'actionLevel')
    ..aI(4, _omitFieldNames ? '' : 'failed')
    ..aI(5, _omitFieldNames ? '' : 'unassessable')
    ..aI(6, _omitFieldNames ? '' : 'actionsOpen')
    ..aI(7, _omitFieldNames ? '' : 'actionsDone')
    ..aI(8, _omitFieldNames ? '' : 'actionsVerified')
    ..aI(9, _omitFieldNames ? '' : 'passPermille')
    ..aOB(10, _omitFieldNames ? '' : 'unanswerable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnvironmentSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnvironmentSummary copyWith(void Function(EnvironmentSummary) updates) =>
      super.copyWith((message) => updates(message as EnvironmentSummary))
          as EnvironmentSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnvironmentSummary create() => EnvironmentSummary._();
  @$core.override
  EnvironmentSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnvironmentSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnvironmentSummary>(create);
  static EnvironmentSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get samples => $_getIZ(0);
  @$pb.TagNumber(1)
  set samples($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSamples() => $_has(0);
  @$pb.TagNumber(1)
  void clearSamples() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get passed => $_getIZ(1);
  @$pb.TagNumber(2)
  set passed($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassed() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassed() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get actionLevel => $_getIZ(2);
  @$pb.TagNumber(3)
  set actionLevel($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActionLevel() => $_has(2);
  @$pb.TagNumber(3)
  void clearActionLevel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get failed => $_getIZ(3);
  @$pb.TagNumber(4)
  set failed($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFailed() => $_has(3);
  @$pb.TagNumber(4)
  void clearFailed() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get unassessable => $_getIZ(4);
  @$pb.TagNumber(5)
  set unassessable($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnassessable() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnassessable() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get actionsOpen => $_getIZ(5);
  @$pb.TagNumber(6)
  set actionsOpen($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasActionsOpen() => $_has(5);
  @$pb.TagNumber(6)
  void clearActionsOpen() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get actionsDone => $_getIZ(6);
  @$pb.TagNumber(7)
  set actionsDone($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasActionsDone() => $_has(6);
  @$pb.TagNumber(7)
  void clearActionsDone() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get actionsVerified => $_getIZ(7);
  @$pb.TagNumber(8)
  set actionsVerified($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasActionsVerified() => $_has(7);
  @$pb.TagNumber(8)
  void clearActionsVerified() => $_clearField(8);

  /// Passes over the samples that could be judged at all. Unassessable ones
  /// are excluded rather than counted as passes.
  @$pb.TagNumber(9)
  $core.int get passPermille => $_getIZ(8);
  @$pb.TagNumber(9)
  set passPermille($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPassPermille() => $_has(8);
  @$pb.TagNumber(9)
  void clearPassPermille() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get unanswerable => $_getBF(9);
  @$pb.TagNumber(10)
  set unanswerable($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUnanswerable() => $_has(9);
  @$pb.TagNumber(10)
  void clearUnanswerable() => $_clearField(10);
}

class OpenCaseRequest extends $pb.GeneratedMessage {
  factory OpenCaseRequest({
    $core.String? reference,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    $core.String? locationId,
    $core.String? organism,
    $core.String? organismCode,
    InfectionSite? site,
    $0.Timestamp? admittedAt,
    $0.Timestamp? onsetAt,
    $core.bool? deviceInSitu,
    $core.int? deviceDays,
    $core.String? criteria,
    $core.String? notes,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (organism != null) result.organism = organism;
    if (organismCode != null) result.organismCode = organismCode;
    if (site != null) result.site = site;
    if (admittedAt != null) result.admittedAt = admittedAt;
    if (onsetAt != null) result.onsetAt = onsetAt;
    if (deviceInSitu != null) result.deviceInSitu = deviceInSitu;
    if (deviceDays != null) result.deviceDays = deviceDays;
    if (criteria != null) result.criteria = criteria;
    if (notes != null) result.notes = notes;
    return result;
  }

  OpenCaseRequest._();

  factory OpenCaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenCaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenCaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'locationId')
    ..aOS(6, _omitFieldNames ? '' : 'organism')
    ..aOS(7, _omitFieldNames ? '' : 'organismCode')
    ..aE<InfectionSite>(8, _omitFieldNames ? '' : 'site',
        enumValues: InfectionSite.values)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'admittedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'onsetAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(11, _omitFieldNames ? '' : 'deviceInSitu')
    ..aI(12, _omitFieldNames ? '' : 'deviceDays')
    ..aOS(13, _omitFieldNames ? '' : 'criteria')
    ..aOS(14, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenCaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenCaseRequest copyWith(void Function(OpenCaseRequest) updates) =>
      super.copyWith((message) => updates(message as OpenCaseRequest))
          as OpenCaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenCaseRequest create() => OpenCaseRequest._();
  @$core.override
  OpenCaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenCaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenCaseRequest>(create);
  static OpenCaseRequest? _defaultInstance;

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
  $core.String get locationId => $_getSZ(4);
  @$pb.TagNumber(5)
  set locationId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLocationId() => $_has(4);
  @$pb.TagNumber(5)
  void clearLocationId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get organism => $_getSZ(5);
  @$pb.TagNumber(6)
  set organism($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOrganism() => $_has(5);
  @$pb.TagNumber(6)
  void clearOrganism() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get organismCode => $_getSZ(6);
  @$pb.TagNumber(7)
  set organismCode($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOrganismCode() => $_has(6);
  @$pb.TagNumber(7)
  void clearOrganismCode() => $_clearField(7);

  @$pb.TagNumber(8)
  InfectionSite get site => $_getN(7);
  @$pb.TagNumber(8)
  set site(InfectionSite value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSite() => $_has(7);
  @$pb.TagNumber(8)
  void clearSite() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get admittedAt => $_getN(8);
  @$pb.TagNumber(9)
  set admittedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasAdmittedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearAdmittedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureAdmittedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get onsetAt => $_getN(9);
  @$pb.TagNumber(10)
  set onsetAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasOnsetAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearOnsetAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureOnsetAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.bool get deviceInSitu => $_getBF(10);
  @$pb.TagNumber(11)
  set deviceInSitu($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDeviceInSitu() => $_has(10);
  @$pb.TagNumber(11)
  void clearDeviceInSitu() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get deviceDays => $_getIZ(11);
  @$pb.TagNumber(12)
  set deviceDays($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasDeviceDays() => $_has(11);
  @$pb.TagNumber(12)
  void clearDeviceDays() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get criteria => $_getSZ(12);
  @$pb.TagNumber(13)
  set criteria($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCriteria() => $_has(12);
  @$pb.TagNumber(13)
  void clearCriteria() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get notes => $_getSZ(13);
  @$pb.TagNumber(14)
  set notes($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasNotes() => $_has(13);
  @$pb.TagNumber(14)
  void clearNotes() => $_clearField(14);
}

class OpenCaseResponse extends $pb.GeneratedMessage {
  factory OpenCaseResponse({
    SurveillanceCase? surveillanceCase,
  }) {
    final result = create();
    if (surveillanceCase != null) result.surveillanceCase = surveillanceCase;
    return result;
  }

  OpenCaseResponse._();

  factory OpenCaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenCaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenCaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<SurveillanceCase>(1, _omitFieldNames ? '' : 'surveillanceCase',
        subBuilder: SurveillanceCase.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenCaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenCaseResponse copyWith(void Function(OpenCaseResponse) updates) =>
      super.copyWith((message) => updates(message as OpenCaseResponse))
          as OpenCaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenCaseResponse create() => OpenCaseResponse._();
  @$core.override
  OpenCaseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenCaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenCaseResponse>(create);
  static OpenCaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SurveillanceCase get surveillanceCase => $_getN(0);
  @$pb.TagNumber(1)
  set surveillanceCase(SurveillanceCase value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSurveillanceCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurveillanceCase() => $_clearField(1);
  @$pb.TagNumber(1)
  SurveillanceCase ensureSurveillanceCase() => $_ensure(0);
}

class ReviewCaseRequest extends $pb.GeneratedMessage {
  factory ReviewCaseRequest({
    $core.String? caseId,
    CaseState? state,
    $core.String? criteria,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (state != null) result.state = state;
    if (criteria != null) result.criteria = criteria;
    return result;
  }

  ReviewCaseRequest._();

  factory ReviewCaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReviewCaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewCaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aE<CaseState>(2, _omitFieldNames ? '' : 'state',
        enumValues: CaseState.values)
    ..aOS(3, _omitFieldNames ? '' : 'criteria')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewCaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewCaseRequest copyWith(void Function(ReviewCaseRequest) updates) =>
      super.copyWith((message) => updates(message as ReviewCaseRequest))
          as ReviewCaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReviewCaseRequest create() => ReviewCaseRequest._();
  @$core.override
  ReviewCaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReviewCaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewCaseRequest>(create);
  static ReviewCaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  CaseState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(CaseState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get criteria => $_getSZ(2);
  @$pb.TagNumber(3)
  set criteria($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCriteria() => $_has(2);
  @$pb.TagNumber(3)
  void clearCriteria() => $_clearField(3);
}

class ReviewCaseResponse extends $pb.GeneratedMessage {
  factory ReviewCaseResponse({
    SurveillanceCase? surveillanceCase,
  }) {
    final result = create();
    if (surveillanceCase != null) result.surveillanceCase = surveillanceCase;
    return result;
  }

  ReviewCaseResponse._();

  factory ReviewCaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReviewCaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewCaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<SurveillanceCase>(1, _omitFieldNames ? '' : 'surveillanceCase',
        subBuilder: SurveillanceCase.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewCaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewCaseResponse copyWith(void Function(ReviewCaseResponse) updates) =>
      super.copyWith((message) => updates(message as ReviewCaseResponse))
          as ReviewCaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReviewCaseResponse create() => ReviewCaseResponse._();
  @$core.override
  ReviewCaseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReviewCaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewCaseResponse>(create);
  static ReviewCaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SurveillanceCase get surveillanceCase => $_getN(0);
  @$pb.TagNumber(1)
  set surveillanceCase(SurveillanceCase value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSurveillanceCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurveillanceCase() => $_clearField(1);
  @$pb.TagNumber(1)
  SurveillanceCase ensureSurveillanceCase() => $_ensure(0);
}

class OverrideOnsetRequest extends $pb.GeneratedMessage {
  factory OverrideOnsetRequest({
    $core.String? caseId,
    Onset? onset,
    $core.String? reason,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (onset != null) result.onset = onset;
    if (reason != null) result.reason = reason;
    return result;
  }

  OverrideOnsetRequest._();

  factory OverrideOnsetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OverrideOnsetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OverrideOnsetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aE<Onset>(2, _omitFieldNames ? '' : 'onset', enumValues: Onset.values)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideOnsetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideOnsetRequest copyWith(void Function(OverrideOnsetRequest) updates) =>
      super.copyWith((message) => updates(message as OverrideOnsetRequest))
          as OverrideOnsetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OverrideOnsetRequest create() => OverrideOnsetRequest._();
  @$core.override
  OverrideOnsetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OverrideOnsetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OverrideOnsetRequest>(create);
  static OverrideOnsetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  Onset get onset => $_getN(1);
  @$pb.TagNumber(2)
  set onset(Onset value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOnset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOnset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class OverrideOnsetResponse extends $pb.GeneratedMessage {
  factory OverrideOnsetResponse({
    SurveillanceCase? surveillanceCase,
  }) {
    final result = create();
    if (surveillanceCase != null) result.surveillanceCase = surveillanceCase;
    return result;
  }

  OverrideOnsetResponse._();

  factory OverrideOnsetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OverrideOnsetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OverrideOnsetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<SurveillanceCase>(1, _omitFieldNames ? '' : 'surveillanceCase',
        subBuilder: SurveillanceCase.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideOnsetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideOnsetResponse copyWith(
          void Function(OverrideOnsetResponse) updates) =>
      super.copyWith((message) => updates(message as OverrideOnsetResponse))
          as OverrideOnsetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OverrideOnsetResponse create() => OverrideOnsetResponse._();
  @$core.override
  OverrideOnsetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OverrideOnsetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OverrideOnsetResponse>(create);
  static OverrideOnsetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SurveillanceCase get surveillanceCase => $_getN(0);
  @$pb.TagNumber(1)
  set surveillanceCase(SurveillanceCase value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSurveillanceCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurveillanceCase() => $_clearField(1);
  @$pb.TagNumber(1)
  SurveillanceCase ensureSurveillanceCase() => $_ensure(0);
}

class ListCasesRequest extends $pb.GeneratedMessage {
  factory ListCasesRequest({
    $core.String? patientId,
    CaseState? state,
    InfectionSite? site,
    $core.String? locationId,
    $0.Timestamp? onsetFrom,
    $0.Timestamp? onsetTo,
    $core.int? pageSize,
    $core.int? pageOffset,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (state != null) result.state = state;
    if (site != null) result.site = site;
    if (locationId != null) result.locationId = locationId;
    if (onsetFrom != null) result.onsetFrom = onsetFrom;
    if (onsetTo != null) result.onsetTo = onsetTo;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageOffset != null) result.pageOffset = pageOffset;
    return result;
  }

  ListCasesRequest._();

  factory ListCasesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCasesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCasesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aE<CaseState>(2, _omitFieldNames ? '' : 'state',
        enumValues: CaseState.values)
    ..aE<InfectionSite>(3, _omitFieldNames ? '' : 'site',
        enumValues: InfectionSite.values)
    ..aOS(4, _omitFieldNames ? '' : 'locationId')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'onsetFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'onsetTo',
        subBuilder: $0.Timestamp.create)
    ..aI(7, _omitFieldNames ? '' : 'pageSize')
    ..aI(8, _omitFieldNames ? '' : 'pageOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCasesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCasesRequest copyWith(void Function(ListCasesRequest) updates) =>
      super.copyWith((message) => updates(message as ListCasesRequest))
          as ListCasesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCasesRequest create() => ListCasesRequest._();
  @$core.override
  ListCasesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCasesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCasesRequest>(create);
  static ListCasesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  CaseState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(CaseState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  InfectionSite get site => $_getN(2);
  @$pb.TagNumber(3)
  set site(InfectionSite value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSite() => $_has(2);
  @$pb.TagNumber(3)
  void clearSite() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get locationId => $_getSZ(3);
  @$pb.TagNumber(4)
  set locationId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocationId() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocationId() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get onsetFrom => $_getN(4);
  @$pb.TagNumber(5)
  set onsetFrom($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasOnsetFrom() => $_has(4);
  @$pb.TagNumber(5)
  void clearOnsetFrom() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureOnsetFrom() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get onsetTo => $_getN(5);
  @$pb.TagNumber(6)
  set onsetTo($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOnsetTo() => $_has(5);
  @$pb.TagNumber(6)
  void clearOnsetTo() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureOnsetTo() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.int get pageSize => $_getIZ(6);
  @$pb.TagNumber(7)
  set pageSize($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPageSize() => $_has(6);
  @$pb.TagNumber(7)
  void clearPageSize() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get pageOffset => $_getIZ(7);
  @$pb.TagNumber(8)
  set pageOffset($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPageOffset() => $_has(7);
  @$pb.TagNumber(8)
  void clearPageOffset() => $_clearField(8);
}

class ListCasesResponse extends $pb.GeneratedMessage {
  factory ListCasesResponse({
    $core.Iterable<SurveillanceCase>? cases,
  }) {
    final result = create();
    if (cases != null) result.cases.addAll(cases);
    return result;
  }

  ListCasesResponse._();

  factory ListCasesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCasesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCasesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..pPM<SurveillanceCase>(1, _omitFieldNames ? '' : 'cases',
        subBuilder: SurveillanceCase.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCasesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCasesResponse copyWith(void Function(ListCasesResponse) updates) =>
      super.copyWith((message) => updates(message as ListCasesResponse))
          as ListCasesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCasesResponse create() => ListCasesResponse._();
  @$core.override
  ListCasesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCasesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCasesResponse>(create);
  static ListCasesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SurveillanceCase> get cases => $_getList(0);
}

class RecordDeviceDaysRequest extends $pb.GeneratedMessage {
  factory RecordDeviceDaysRequest({
    $core.String? facilityId,
    $core.String? locationId,
    DeviceKind? device,
    $0.Timestamp? countedOn,
    $core.int? patientDays,
    $core.int? deviceDays,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (device != null) result.device = device;
    if (countedOn != null) result.countedOn = countedOn;
    if (patientDays != null) result.patientDays = patientDays;
    if (deviceDays != null) result.deviceDays = deviceDays;
    return result;
  }

  RecordDeviceDaysRequest._();

  factory RecordDeviceDaysRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordDeviceDaysRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordDeviceDaysRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'locationId')
    ..aE<DeviceKind>(3, _omitFieldNames ? '' : 'device',
        enumValues: DeviceKind.values)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'countedOn',
        subBuilder: $0.Timestamp.create)
    ..aI(5, _omitFieldNames ? '' : 'patientDays')
    ..aI(6, _omitFieldNames ? '' : 'deviceDays')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeviceDaysRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeviceDaysRequest copyWith(
          void Function(RecordDeviceDaysRequest) updates) =>
      super.copyWith((message) => updates(message as RecordDeviceDaysRequest))
          as RecordDeviceDaysRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordDeviceDaysRequest create() => RecordDeviceDaysRequest._();
  @$core.override
  RecordDeviceDaysRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordDeviceDaysRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordDeviceDaysRequest>(create);
  static RecordDeviceDaysRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get locationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationId() => $_clearField(2);

  @$pb.TagNumber(3)
  DeviceKind get device => $_getN(2);
  @$pb.TagNumber(3)
  set device(DeviceKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDevice() => $_has(2);
  @$pb.TagNumber(3)
  void clearDevice() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get countedOn => $_getN(3);
  @$pb.TagNumber(4)
  set countedOn($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCountedOn() => $_has(3);
  @$pb.TagNumber(4)
  void clearCountedOn() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureCountedOn() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get patientDays => $_getIZ(4);
  @$pb.TagNumber(5)
  set patientDays($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPatientDays() => $_has(4);
  @$pb.TagNumber(5)
  void clearPatientDays() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get deviceDays => $_getIZ(5);
  @$pb.TagNumber(6)
  set deviceDays($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDeviceDays() => $_has(5);
  @$pb.TagNumber(6)
  void clearDeviceDays() => $_clearField(6);
}

class RecordDeviceDaysResponse extends $pb.GeneratedMessage {
  factory RecordDeviceDaysResponse({
    DeviceDayCount? count,
  }) {
    final result = create();
    if (count != null) result.count = count;
    return result;
  }

  RecordDeviceDaysResponse._();

  factory RecordDeviceDaysResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordDeviceDaysResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordDeviceDaysResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<DeviceDayCount>(1, _omitFieldNames ? '' : 'count',
        subBuilder: DeviceDayCount.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeviceDaysResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeviceDaysResponse copyWith(
          void Function(RecordDeviceDaysResponse) updates) =>
      super.copyWith((message) => updates(message as RecordDeviceDaysResponse))
          as RecordDeviceDaysResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordDeviceDaysResponse create() => RecordDeviceDaysResponse._();
  @$core.override
  RecordDeviceDaysResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordDeviceDaysResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordDeviceDaysResponse>(create);
  static RecordDeviceDaysResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DeviceDayCount get count => $_getN(0);
  @$pb.TagNumber(1)
  set count(DeviceDayCount value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);
  @$pb.TagNumber(1)
  DeviceDayCount ensureCount() => $_ensure(0);
}

class GetRateRequest extends $pb.GeneratedMessage {
  factory GetRateRequest({
    InfectionSite? site,
    $core.String? locationId,
    $0.Timestamp? periodFrom,
    $0.Timestamp? periodTo,
  }) {
    final result = create();
    if (site != null) result.site = site;
    if (locationId != null) result.locationId = locationId;
    if (periodFrom != null) result.periodFrom = periodFrom;
    if (periodTo != null) result.periodTo = periodTo;
    return result;
  }

  GetRateRequest._();

  factory GetRateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aE<InfectionSite>(1, _omitFieldNames ? '' : 'site',
        enumValues: InfectionSite.values)
    ..aOS(2, _omitFieldNames ? '' : 'locationId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'periodFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'periodTo',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRateRequest copyWith(void Function(GetRateRequest) updates) =>
      super.copyWith((message) => updates(message as GetRateRequest))
          as GetRateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRateRequest create() => GetRateRequest._();
  @$core.override
  GetRateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRateRequest>(create);
  static GetRateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  InfectionSite get site => $_getN(0);
  @$pb.TagNumber(1)
  set site(InfectionSite value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSite() => $_has(0);
  @$pb.TagNumber(1)
  void clearSite() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get locationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get periodFrom => $_getN(2);
  @$pb.TagNumber(3)
  set periodFrom($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPeriodFrom() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriodFrom() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensurePeriodFrom() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get periodTo => $_getN(3);
  @$pb.TagNumber(4)
  set periodTo($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPeriodTo() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeriodTo() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensurePeriodTo() => $_ensure(3);
}

class GetRateResponse extends $pb.GeneratedMessage {
  factory GetRateResponse({
    Rate? rate,
  }) {
    final result = create();
    if (rate != null) result.rate = rate;
    return result;
  }

  GetRateResponse._();

  factory GetRateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<Rate>(1, _omitFieldNames ? '' : 'rate', subBuilder: Rate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRateResponse copyWith(void Function(GetRateResponse) updates) =>
      super.copyWith((message) => updates(message as GetRateResponse))
          as GetRateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRateResponse create() => GetRateResponse._();
  @$core.override
  GetRateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRateResponse>(create);
  static GetRateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Rate get rate => $_getN(0);
  @$pb.TagNumber(1)
  set rate(Rate value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRate() => $_has(0);
  @$pb.TagNumber(1)
  void clearRate() => $_clearField(1);
  @$pb.TagNumber(1)
  Rate ensureRate() => $_ensure(0);
}

class StartIsolationRequest extends $pb.GeneratedMessage {
  factory StartIsolationRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    $core.String? locationId,
    $core.String? bedId,
    Precaution? precaution,
    $core.String? reason,
    $core.String? caseId,
    $0.Timestamp? startedAt,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (bedId != null) result.bedId = bedId;
    if (precaution != null) result.precaution = precaution;
    if (reason != null) result.reason = reason;
    if (caseId != null) result.caseId = caseId;
    if (startedAt != null) result.startedAt = startedAt;
    return result;
  }

  StartIsolationRequest._();

  factory StartIsolationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartIsolationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartIsolationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'locationId')
    ..aOS(5, _omitFieldNames ? '' : 'bedId')
    ..aE<Precaution>(6, _omitFieldNames ? '' : 'precaution',
        enumValues: Precaution.values)
    ..aOS(7, _omitFieldNames ? '' : 'reason')
    ..aOS(8, _omitFieldNames ? '' : 'caseId')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartIsolationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartIsolationRequest copyWith(
          void Function(StartIsolationRequest) updates) =>
      super.copyWith((message) => updates(message as StartIsolationRequest))
          as StartIsolationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartIsolationRequest create() => StartIsolationRequest._();
  @$core.override
  StartIsolationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartIsolationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartIsolationRequest>(create);
  static StartIsolationRequest? _defaultInstance;

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
  $core.String get locationId => $_getSZ(3);
  @$pb.TagNumber(4)
  set locationId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocationId() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocationId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get bedId => $_getSZ(4);
  @$pb.TagNumber(5)
  set bedId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBedId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBedId() => $_clearField(5);

  @$pb.TagNumber(6)
  Precaution get precaution => $_getN(5);
  @$pb.TagNumber(6)
  set precaution(Precaution value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPrecaution() => $_has(5);
  @$pb.TagNumber(6)
  void clearPrecaution() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get reason => $_getSZ(6);
  @$pb.TagNumber(7)
  set reason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearReason() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get caseId => $_getSZ(7);
  @$pb.TagNumber(8)
  set caseId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCaseId() => $_has(7);
  @$pb.TagNumber(8)
  void clearCaseId() => $_clearField(8);

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
}

class StartIsolationResponse extends $pb.GeneratedMessage {
  factory StartIsolationResponse({
    Isolation? isolation,
  }) {
    final result = create();
    if (isolation != null) result.isolation = isolation;
    return result;
  }

  StartIsolationResponse._();

  factory StartIsolationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartIsolationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartIsolationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<Isolation>(1, _omitFieldNames ? '' : 'isolation',
        subBuilder: Isolation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartIsolationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartIsolationResponse copyWith(
          void Function(StartIsolationResponse) updates) =>
      super.copyWith((message) => updates(message as StartIsolationResponse))
          as StartIsolationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartIsolationResponse create() => StartIsolationResponse._();
  @$core.override
  StartIsolationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartIsolationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartIsolationResponse>(create);
  static StartIsolationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Isolation get isolation => $_getN(0);
  @$pb.TagNumber(1)
  set isolation(Isolation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIsolation() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsolation() => $_clearField(1);
  @$pb.TagNumber(1)
  Isolation ensureIsolation() => $_ensure(0);
}

class ExtendIsolationRequest extends $pb.GeneratedMessage {
  factory ExtendIsolationRequest({
    $core.String? isolationId,
  }) {
    final result = create();
    if (isolationId != null) result.isolationId = isolationId;
    return result;
  }

  ExtendIsolationRequest._();

  factory ExtendIsolationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExtendIsolationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtendIsolationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'isolationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtendIsolationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtendIsolationRequest copyWith(
          void Function(ExtendIsolationRequest) updates) =>
      super.copyWith((message) => updates(message as ExtendIsolationRequest))
          as ExtendIsolationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExtendIsolationRequest create() => ExtendIsolationRequest._();
  @$core.override
  ExtendIsolationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExtendIsolationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExtendIsolationRequest>(create);
  static ExtendIsolationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get isolationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set isolationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsolationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsolationId() => $_clearField(1);
}

class ExtendIsolationResponse extends $pb.GeneratedMessage {
  factory ExtendIsolationResponse({
    Isolation? isolation,
  }) {
    final result = create();
    if (isolation != null) result.isolation = isolation;
    return result;
  }

  ExtendIsolationResponse._();

  factory ExtendIsolationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExtendIsolationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtendIsolationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<Isolation>(1, _omitFieldNames ? '' : 'isolation',
        subBuilder: Isolation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtendIsolationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtendIsolationResponse copyWith(
          void Function(ExtendIsolationResponse) updates) =>
      super.copyWith((message) => updates(message as ExtendIsolationResponse))
          as ExtendIsolationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExtendIsolationResponse create() => ExtendIsolationResponse._();
  @$core.override
  ExtendIsolationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExtendIsolationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExtendIsolationResponse>(create);
  static ExtendIsolationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Isolation get isolation => $_getN(0);
  @$pb.TagNumber(1)
  set isolation(Isolation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIsolation() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsolation() => $_clearField(1);
  @$pb.TagNumber(1)
  Isolation ensureIsolation() => $_ensure(0);
}

class EndIsolationRequest extends $pb.GeneratedMessage {
  factory EndIsolationRequest({
    $core.String? isolationId,
    $core.String? reason,
  }) {
    final result = create();
    if (isolationId != null) result.isolationId = isolationId;
    if (reason != null) result.reason = reason;
    return result;
  }

  EndIsolationRequest._();

  factory EndIsolationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndIsolationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndIsolationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'isolationId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndIsolationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndIsolationRequest copyWith(void Function(EndIsolationRequest) updates) =>
      super.copyWith((message) => updates(message as EndIsolationRequest))
          as EndIsolationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndIsolationRequest create() => EndIsolationRequest._();
  @$core.override
  EndIsolationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndIsolationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndIsolationRequest>(create);
  static EndIsolationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get isolationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set isolationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsolationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsolationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class EndIsolationResponse extends $pb.GeneratedMessage {
  factory EndIsolationResponse({
    Isolation? isolation,
  }) {
    final result = create();
    if (isolation != null) result.isolation = isolation;
    return result;
  }

  EndIsolationResponse._();

  factory EndIsolationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndIsolationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndIsolationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<Isolation>(1, _omitFieldNames ? '' : 'isolation',
        subBuilder: Isolation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndIsolationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndIsolationResponse copyWith(void Function(EndIsolationResponse) updates) =>
      super.copyWith((message) => updates(message as EndIsolationResponse))
          as EndIsolationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndIsolationResponse create() => EndIsolationResponse._();
  @$core.override
  EndIsolationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndIsolationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndIsolationResponse>(create);
  static EndIsolationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Isolation get isolation => $_getN(0);
  @$pb.TagNumber(1)
  set isolation(Isolation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIsolation() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsolation() => $_clearField(1);
  @$pb.TagNumber(1)
  Isolation ensureIsolation() => $_ensure(0);
}

class GetBoardRequest extends $pb.GeneratedMessage {
  factory GetBoardRequest({
    $core.String? locationId,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
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
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
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
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);
}

class GetBoardResponse extends $pb.GeneratedMessage {
  factory GetBoardResponse({
    $core.Iterable<BoardEntry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
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
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..pPM<BoardEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: BoardEntry.create)
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
  $pb.PbList<BoardEntry> get entries => $_getList(0);
}

class DraftAlertRuleRequest extends $pb.GeneratedMessage {
  factory DraftAlertRuleRequest({
    $core.String? code,
    $core.String? name,
    $core.int? revision,
    $core.Iterable<$core.String>? organisms,
    $core.int? lookbackDays,
    Precaution? precaution,
    $core.String? advice,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (revision != null) result.revision = revision;
    if (organisms != null) result.organisms.addAll(organisms);
    if (lookbackDays != null) result.lookbackDays = lookbackDays;
    if (precaution != null) result.precaution = precaution;
    if (advice != null) result.advice = advice;
    return result;
  }

  DraftAlertRuleRequest._();

  factory DraftAlertRuleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DraftAlertRuleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DraftAlertRuleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'revision')
    ..pPS(4, _omitFieldNames ? '' : 'organisms')
    ..aI(5, _omitFieldNames ? '' : 'lookbackDays')
    ..aE<Precaution>(6, _omitFieldNames ? '' : 'precaution',
        enumValues: Precaution.values)
    ..aOS(7, _omitFieldNames ? '' : 'advice')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftAlertRuleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftAlertRuleRequest copyWith(
          void Function(DraftAlertRuleRequest) updates) =>
      super.copyWith((message) => updates(message as DraftAlertRuleRequest))
          as DraftAlertRuleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DraftAlertRuleRequest create() => DraftAlertRuleRequest._();
  @$core.override
  DraftAlertRuleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DraftAlertRuleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DraftAlertRuleRequest>(create);
  static DraftAlertRuleRequest? _defaultInstance;

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
  $pb.PbList<$core.String> get organisms => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get lookbackDays => $_getIZ(4);
  @$pb.TagNumber(5)
  set lookbackDays($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLookbackDays() => $_has(4);
  @$pb.TagNumber(5)
  void clearLookbackDays() => $_clearField(5);

  @$pb.TagNumber(6)
  Precaution get precaution => $_getN(5);
  @$pb.TagNumber(6)
  set precaution(Precaution value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPrecaution() => $_has(5);
  @$pb.TagNumber(6)
  void clearPrecaution() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get advice => $_getSZ(6);
  @$pb.TagNumber(7)
  set advice($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAdvice() => $_has(6);
  @$pb.TagNumber(7)
  void clearAdvice() => $_clearField(7);
}

class DraftAlertRuleResponse extends $pb.GeneratedMessage {
  factory DraftAlertRuleResponse({
    AlertRule? rule,
  }) {
    final result = create();
    if (rule != null) result.rule = rule;
    return result;
  }

  DraftAlertRuleResponse._();

  factory DraftAlertRuleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DraftAlertRuleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DraftAlertRuleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<AlertRule>(1, _omitFieldNames ? '' : 'rule',
        subBuilder: AlertRule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftAlertRuleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftAlertRuleResponse copyWith(
          void Function(DraftAlertRuleResponse) updates) =>
      super.copyWith((message) => updates(message as DraftAlertRuleResponse))
          as DraftAlertRuleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DraftAlertRuleResponse create() => DraftAlertRuleResponse._();
  @$core.override
  DraftAlertRuleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DraftAlertRuleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DraftAlertRuleResponse>(create);
  static DraftAlertRuleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AlertRule get rule => $_getN(0);
  @$pb.TagNumber(1)
  set rule(AlertRule value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRule() => $_has(0);
  @$pb.TagNumber(1)
  void clearRule() => $_clearField(1);
  @$pb.TagNumber(1)
  AlertRule ensureRule() => $_ensure(0);
}

class ApproveAlertRuleRequest extends $pb.GeneratedMessage {
  factory ApproveAlertRuleRequest({
    $core.String? ruleId,
    $0.Timestamp? effectiveFrom,
  }) {
    final result = create();
    if (ruleId != null) result.ruleId = ruleId;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    return result;
  }

  ApproveAlertRuleRequest._();

  factory ApproveAlertRuleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveAlertRuleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveAlertRuleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ruleId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveAlertRuleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveAlertRuleRequest copyWith(
          void Function(ApproveAlertRuleRequest) updates) =>
      super.copyWith((message) => updates(message as ApproveAlertRuleRequest))
          as ApproveAlertRuleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveAlertRuleRequest create() => ApproveAlertRuleRequest._();
  @$core.override
  ApproveAlertRuleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveAlertRuleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveAlertRuleRequest>(create);
  static ApproveAlertRuleRequest? _defaultInstance;

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

class ApproveAlertRuleResponse extends $pb.GeneratedMessage {
  factory ApproveAlertRuleResponse({
    AlertRule? rule,
  }) {
    final result = create();
    if (rule != null) result.rule = rule;
    return result;
  }

  ApproveAlertRuleResponse._();

  factory ApproveAlertRuleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveAlertRuleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveAlertRuleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<AlertRule>(1, _omitFieldNames ? '' : 'rule',
        subBuilder: AlertRule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveAlertRuleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveAlertRuleResponse copyWith(
          void Function(ApproveAlertRuleResponse) updates) =>
      super.copyWith((message) => updates(message as ApproveAlertRuleResponse))
          as ApproveAlertRuleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveAlertRuleResponse create() => ApproveAlertRuleResponse._();
  @$core.override
  ApproveAlertRuleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveAlertRuleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveAlertRuleResponse>(create);
  static ApproveAlertRuleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AlertRule get rule => $_getN(0);
  @$pb.TagNumber(1)
  set rule(AlertRule value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRule() => $_has(0);
  @$pb.TagNumber(1)
  void clearRule() => $_clearField(1);
  @$pb.TagNumber(1)
  AlertRule ensureRule() => $_ensure(0);
}

class ScreenEncounterRequest extends $pb.GeneratedMessage {
  factory ScreenEncounterRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    $core.String? organism,
    $core.String? organismCode,
    $0.Timestamp? lastPositiveAt,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (organism != null) result.organism = organism;
    if (organismCode != null) result.organismCode = organismCode;
    if (lastPositiveAt != null) result.lastPositiveAt = lastPositiveAt;
    return result;
  }

  ScreenEncounterRequest._();

  factory ScreenEncounterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScreenEncounterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScreenEncounterRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'organism')
    ..aOS(5, _omitFieldNames ? '' : 'organismCode')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'lastPositiveAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScreenEncounterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScreenEncounterRequest copyWith(
          void Function(ScreenEncounterRequest) updates) =>
      super.copyWith((message) => updates(message as ScreenEncounterRequest))
          as ScreenEncounterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScreenEncounterRequest create() => ScreenEncounterRequest._();
  @$core.override
  ScreenEncounterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScreenEncounterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScreenEncounterRequest>(create);
  static ScreenEncounterRequest? _defaultInstance;

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
  $core.String get organism => $_getSZ(3);
  @$pb.TagNumber(4)
  set organism($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOrganism() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrganism() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get organismCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set organismCode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOrganismCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearOrganismCode() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get lastPositiveAt => $_getN(5);
  @$pb.TagNumber(6)
  set lastPositiveAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLastPositiveAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastPositiveAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureLastPositiveAt() => $_ensure(5);
}

class ScreenEncounterResponse extends $pb.GeneratedMessage {
  factory ScreenEncounterResponse({
    $core.Iterable<Alert>? alerts,
  }) {
    final result = create();
    if (alerts != null) result.alerts.addAll(alerts);
    return result;
  }

  ScreenEncounterResponse._();

  factory ScreenEncounterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScreenEncounterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScreenEncounterResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..pPM<Alert>(1, _omitFieldNames ? '' : 'alerts', subBuilder: Alert.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScreenEncounterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScreenEncounterResponse copyWith(
          void Function(ScreenEncounterResponse) updates) =>
      super.copyWith((message) => updates(message as ScreenEncounterResponse))
          as ScreenEncounterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScreenEncounterResponse create() => ScreenEncounterResponse._();
  @$core.override
  ScreenEncounterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScreenEncounterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScreenEncounterResponse>(create);
  static ScreenEncounterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Alert> get alerts => $_getList(0);
}

class AcknowledgeAlertRequest extends $pb.GeneratedMessage {
  factory AcknowledgeAlertRequest({
    $core.String? alertId,
  }) {
    final result = create();
    if (alertId != null) result.alertId = alertId;
    return result;
  }

  AcknowledgeAlertRequest._();

  factory AcknowledgeAlertRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgeAlertRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgeAlertRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'alertId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeAlertRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeAlertRequest copyWith(
          void Function(AcknowledgeAlertRequest) updates) =>
      super.copyWith((message) => updates(message as AcknowledgeAlertRequest))
          as AcknowledgeAlertRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeAlertRequest create() => AcknowledgeAlertRequest._();
  @$core.override
  AcknowledgeAlertRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeAlertRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgeAlertRequest>(create);
  static AcknowledgeAlertRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get alertId => $_getSZ(0);
  @$pb.TagNumber(1)
  set alertId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlertId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlertId() => $_clearField(1);
}

class AcknowledgeAlertResponse extends $pb.GeneratedMessage {
  factory AcknowledgeAlertResponse({
    Alert? alert,
  }) {
    final result = create();
    if (alert != null) result.alert = alert;
    return result;
  }

  AcknowledgeAlertResponse._();

  factory AcknowledgeAlertResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgeAlertResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgeAlertResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<Alert>(1, _omitFieldNames ? '' : 'alert', subBuilder: Alert.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeAlertResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeAlertResponse copyWith(
          void Function(AcknowledgeAlertResponse) updates) =>
      super.copyWith((message) => updates(message as AcknowledgeAlertResponse))
          as AcknowledgeAlertResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeAlertResponse create() => AcknowledgeAlertResponse._();
  @$core.override
  AcknowledgeAlertResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeAlertResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgeAlertResponse>(create);
  static AcknowledgeAlertResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Alert get alert => $_getN(0);
  @$pb.TagNumber(1)
  set alert(Alert value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAlert() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlert() => $_clearField(1);
  @$pb.TagNumber(1)
  Alert ensureAlert() => $_ensure(0);
}

class OverrideAlertRequest extends $pb.GeneratedMessage {
  factory OverrideAlertRequest({
    $core.String? alertId,
    $core.String? reason,
  }) {
    final result = create();
    if (alertId != null) result.alertId = alertId;
    if (reason != null) result.reason = reason;
    return result;
  }

  OverrideAlertRequest._();

  factory OverrideAlertRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OverrideAlertRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OverrideAlertRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'alertId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideAlertRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideAlertRequest copyWith(void Function(OverrideAlertRequest) updates) =>
      super.copyWith((message) => updates(message as OverrideAlertRequest))
          as OverrideAlertRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OverrideAlertRequest create() => OverrideAlertRequest._();
  @$core.override
  OverrideAlertRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OverrideAlertRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OverrideAlertRequest>(create);
  static OverrideAlertRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get alertId => $_getSZ(0);
  @$pb.TagNumber(1)
  set alertId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlertId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlertId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class OverrideAlertResponse extends $pb.GeneratedMessage {
  factory OverrideAlertResponse({
    Alert? alert,
  }) {
    final result = create();
    if (alert != null) result.alert = alert;
    return result;
  }

  OverrideAlertResponse._();

  factory OverrideAlertResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OverrideAlertResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OverrideAlertResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<Alert>(1, _omitFieldNames ? '' : 'alert', subBuilder: Alert.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideAlertResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideAlertResponse copyWith(
          void Function(OverrideAlertResponse) updates) =>
      super.copyWith((message) => updates(message as OverrideAlertResponse))
          as OverrideAlertResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OverrideAlertResponse create() => OverrideAlertResponse._();
  @$core.override
  OverrideAlertResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OverrideAlertResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OverrideAlertResponse>(create);
  static OverrideAlertResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Alert get alert => $_getN(0);
  @$pb.TagNumber(1)
  set alert(Alert value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAlert() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlert() => $_clearField(1);
  @$pb.TagNumber(1)
  Alert ensureAlert() => $_ensure(0);
}

class ListAlertsRequest extends $pb.GeneratedMessage {
  factory ListAlertsRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.bool? outstandingOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (outstandingOnly != null) result.outstandingOnly = outstandingOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListAlertsRequest._();

  factory ListAlertsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAlertsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAlertsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOB(3, _omitFieldNames ? '' : 'outstandingOnly')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlertsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlertsRequest copyWith(void Function(ListAlertsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAlertsRequest))
          as ListAlertsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAlertsRequest create() => ListAlertsRequest._();
  @$core.override
  ListAlertsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAlertsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAlertsRequest>(create);
  static ListAlertsRequest? _defaultInstance;

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
  $core.bool get outstandingOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set outstandingOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOutstandingOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutstandingOnly() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

class ListAlertsResponse extends $pb.GeneratedMessage {
  factory ListAlertsResponse({
    $core.Iterable<Alert>? alerts,
  }) {
    final result = create();
    if (alerts != null) result.alerts.addAll(alerts);
    return result;
  }

  ListAlertsResponse._();

  factory ListAlertsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAlertsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAlertsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..pPM<Alert>(1, _omitFieldNames ? '' : 'alerts', subBuilder: Alert.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlertsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlertsResponse copyWith(void Function(ListAlertsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAlertsResponse))
          as ListAlertsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAlertsResponse create() => ListAlertsResponse._();
  @$core.override
  ListAlertsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAlertsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAlertsResponse>(create);
  static ListAlertsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Alert> get alerts => $_getList(0);
}

class OpenOutbreakRequest extends $pb.GeneratedMessage {
  factory OpenOutbreakRequest({
    $core.String? reference,
    $core.String? organism,
    $core.String? caseDefinition,
    $core.Iterable<$core.String>? locations,
    $0.Timestamp? windowFrom,
    $0.Timestamp? windowTo,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    if (organism != null) result.organism = organism;
    if (caseDefinition != null) result.caseDefinition = caseDefinition;
    if (locations != null) result.locations.addAll(locations);
    if (windowFrom != null) result.windowFrom = windowFrom;
    if (windowTo != null) result.windowTo = windowTo;
    return result;
  }

  OpenOutbreakRequest._();

  factory OpenOutbreakRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenOutbreakRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenOutbreakRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..aOS(2, _omitFieldNames ? '' : 'organism')
    ..aOS(3, _omitFieldNames ? '' : 'caseDefinition')
    ..pPS(4, _omitFieldNames ? '' : 'locations')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'windowFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'windowTo',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenOutbreakRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenOutbreakRequest copyWith(void Function(OpenOutbreakRequest) updates) =>
      super.copyWith((message) => updates(message as OpenOutbreakRequest))
          as OpenOutbreakRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenOutbreakRequest create() => OpenOutbreakRequest._();
  @$core.override
  OpenOutbreakRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenOutbreakRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenOutbreakRequest>(create);
  static OpenOutbreakRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reference => $_getSZ(0);
  @$pb.TagNumber(1)
  set reference($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReference() => $_has(0);
  @$pb.TagNumber(1)
  void clearReference() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get organism => $_getSZ(1);
  @$pb.TagNumber(2)
  set organism($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrganism() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrganism() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get caseDefinition => $_getSZ(2);
  @$pb.TagNumber(3)
  set caseDefinition($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCaseDefinition() => $_has(2);
  @$pb.TagNumber(3)
  void clearCaseDefinition() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get locations => $_getList(3);

  @$pb.TagNumber(5)
  $0.Timestamp get windowFrom => $_getN(4);
  @$pb.TagNumber(5)
  set windowFrom($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasWindowFrom() => $_has(4);
  @$pb.TagNumber(5)
  void clearWindowFrom() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureWindowFrom() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get windowTo => $_getN(5);
  @$pb.TagNumber(6)
  set windowTo($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasWindowTo() => $_has(5);
  @$pb.TagNumber(6)
  void clearWindowTo() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureWindowTo() => $_ensure(5);
}

class OpenOutbreakResponse extends $pb.GeneratedMessage {
  factory OpenOutbreakResponse({
    Outbreak? outbreak,
  }) {
    final result = create();
    if (outbreak != null) result.outbreak = outbreak;
    return result;
  }

  OpenOutbreakResponse._();

  factory OpenOutbreakResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenOutbreakResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenOutbreakResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<Outbreak>(1, _omitFieldNames ? '' : 'outbreak',
        subBuilder: Outbreak.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenOutbreakResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenOutbreakResponse copyWith(void Function(OpenOutbreakResponse) updates) =>
      super.copyWith((message) => updates(message as OpenOutbreakResponse))
          as OpenOutbreakResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenOutbreakResponse create() => OpenOutbreakResponse._();
  @$core.override
  OpenOutbreakResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenOutbreakResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenOutbreakResponse>(create);
  static OpenOutbreakResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Outbreak get outbreak => $_getN(0);
  @$pb.TagNumber(1)
  set outbreak(Outbreak value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOutbreak() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutbreak() => $_clearField(1);
  @$pb.TagNumber(1)
  Outbreak ensureOutbreak() => $_ensure(0);
}

class AdvanceOutbreakRequest extends $pb.GeneratedMessage {
  factory AdvanceOutbreakRequest({
    $core.String? outbreakId,
    OutbreakState? state,
    $core.String? reason,
  }) {
    final result = create();
    if (outbreakId != null) result.outbreakId = outbreakId;
    if (state != null) result.state = state;
    if (reason != null) result.reason = reason;
    return result;
  }

  AdvanceOutbreakRequest._();

  factory AdvanceOutbreakRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvanceOutbreakRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvanceOutbreakRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'outbreakId')
    ..aE<OutbreakState>(2, _omitFieldNames ? '' : 'state',
        enumValues: OutbreakState.values)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceOutbreakRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceOutbreakRequest copyWith(
          void Function(AdvanceOutbreakRequest) updates) =>
      super.copyWith((message) => updates(message as AdvanceOutbreakRequest))
          as AdvanceOutbreakRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvanceOutbreakRequest create() => AdvanceOutbreakRequest._();
  @$core.override
  AdvanceOutbreakRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvanceOutbreakRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvanceOutbreakRequest>(create);
  static AdvanceOutbreakRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outbreakId => $_getSZ(0);
  @$pb.TagNumber(1)
  set outbreakId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutbreakId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutbreakId() => $_clearField(1);

  @$pb.TagNumber(2)
  OutbreakState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(OutbreakState value) => $_setField(2, value);
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

class AdvanceOutbreakResponse extends $pb.GeneratedMessage {
  factory AdvanceOutbreakResponse({
    Outbreak? outbreak,
  }) {
    final result = create();
    if (outbreak != null) result.outbreak = outbreak;
    return result;
  }

  AdvanceOutbreakResponse._();

  factory AdvanceOutbreakResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvanceOutbreakResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvanceOutbreakResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<Outbreak>(1, _omitFieldNames ? '' : 'outbreak',
        subBuilder: Outbreak.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceOutbreakResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceOutbreakResponse copyWith(
          void Function(AdvanceOutbreakResponse) updates) =>
      super.copyWith((message) => updates(message as AdvanceOutbreakResponse))
          as AdvanceOutbreakResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvanceOutbreakResponse create() => AdvanceOutbreakResponse._();
  @$core.override
  AdvanceOutbreakResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvanceOutbreakResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvanceOutbreakResponse>(create);
  static AdvanceOutbreakResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Outbreak get outbreak => $_getN(0);
  @$pb.TagNumber(1)
  set outbreak(Outbreak value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOutbreak() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutbreak() => $_clearField(1);
  @$pb.TagNumber(1)
  Outbreak ensureOutbreak() => $_ensure(0);
}

class CloseOutbreakRequest extends $pb.GeneratedMessage {
  factory CloseOutbreakRequest({
    $core.String? outbreakId,
    $core.String? findings,
    $core.String? reason,
    $core.Iterable<$core.String>? controlMeasures,
    $core.Iterable<$core.String>? actionIds,
  }) {
    final result = create();
    if (outbreakId != null) result.outbreakId = outbreakId;
    if (findings != null) result.findings = findings;
    if (reason != null) result.reason = reason;
    if (controlMeasures != null) result.controlMeasures.addAll(controlMeasures);
    if (actionIds != null) result.actionIds.addAll(actionIds);
    return result;
  }

  CloseOutbreakRequest._();

  factory CloseOutbreakRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseOutbreakRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseOutbreakRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'outbreakId')
    ..aOS(2, _omitFieldNames ? '' : 'findings')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..pPS(4, _omitFieldNames ? '' : 'controlMeasures')
    ..pPS(5, _omitFieldNames ? '' : 'actionIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseOutbreakRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseOutbreakRequest copyWith(void Function(CloseOutbreakRequest) updates) =>
      super.copyWith((message) => updates(message as CloseOutbreakRequest))
          as CloseOutbreakRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseOutbreakRequest create() => CloseOutbreakRequest._();
  @$core.override
  CloseOutbreakRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseOutbreakRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseOutbreakRequest>(create);
  static CloseOutbreakRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outbreakId => $_getSZ(0);
  @$pb.TagNumber(1)
  set outbreakId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutbreakId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutbreakId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get findings => $_getSZ(1);
  @$pb.TagNumber(2)
  set findings($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFindings() => $_has(1);
  @$pb.TagNumber(2)
  void clearFindings() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get controlMeasures => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get actionIds => $_getList(4);
}

class CloseOutbreakResponse extends $pb.GeneratedMessage {
  factory CloseOutbreakResponse({
    Outbreak? outbreak,
  }) {
    final result = create();
    if (outbreak != null) result.outbreak = outbreak;
    return result;
  }

  CloseOutbreakResponse._();

  factory CloseOutbreakResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseOutbreakResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseOutbreakResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<Outbreak>(1, _omitFieldNames ? '' : 'outbreak',
        subBuilder: Outbreak.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseOutbreakResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseOutbreakResponse copyWith(
          void Function(CloseOutbreakResponse) updates) =>
      super.copyWith((message) => updates(message as CloseOutbreakResponse))
          as CloseOutbreakResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseOutbreakResponse create() => CloseOutbreakResponse._();
  @$core.override
  CloseOutbreakResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseOutbreakResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseOutbreakResponse>(create);
  static CloseOutbreakResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Outbreak get outbreak => $_getN(0);
  @$pb.TagNumber(1)
  set outbreak(Outbreak value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOutbreak() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutbreak() => $_clearField(1);
  @$pb.TagNumber(1)
  Outbreak ensureOutbreak() => $_ensure(0);
}

class AddOutbreakMemberRequest extends $pb.GeneratedMessage {
  factory AddOutbreakMemberRequest({
    $core.String? outbreakId,
    $core.String? caseId,
    MembershipReason? reason,
    $core.String? note,
  }) {
    final result = create();
    if (outbreakId != null) result.outbreakId = outbreakId;
    if (caseId != null) result.caseId = caseId;
    if (reason != null) result.reason = reason;
    if (note != null) result.note = note;
    return result;
  }

  AddOutbreakMemberRequest._();

  factory AddOutbreakMemberRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddOutbreakMemberRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddOutbreakMemberRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'outbreakId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aE<MembershipReason>(3, _omitFieldNames ? '' : 'reason',
        enumValues: MembershipReason.values)
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddOutbreakMemberRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddOutbreakMemberRequest copyWith(
          void Function(AddOutbreakMemberRequest) updates) =>
      super.copyWith((message) => updates(message as AddOutbreakMemberRequest))
          as AddOutbreakMemberRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddOutbreakMemberRequest create() => AddOutbreakMemberRequest._();
  @$core.override
  AddOutbreakMemberRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddOutbreakMemberRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddOutbreakMemberRequest>(create);
  static AddOutbreakMemberRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outbreakId => $_getSZ(0);
  @$pb.TagNumber(1)
  set outbreakId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutbreakId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutbreakId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  @$pb.TagNumber(3)
  MembershipReason get reason => $_getN(2);
  @$pb.TagNumber(3)
  set reason(MembershipReason value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);
}

class AddOutbreakMemberResponse extends $pb.GeneratedMessage {
  factory AddOutbreakMemberResponse({
    Membership? membership,
  }) {
    final result = create();
    if (membership != null) result.membership = membership;
    return result;
  }

  AddOutbreakMemberResponse._();

  factory AddOutbreakMemberResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddOutbreakMemberResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddOutbreakMemberResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<Membership>(1, _omitFieldNames ? '' : 'membership',
        subBuilder: Membership.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddOutbreakMemberResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddOutbreakMemberResponse copyWith(
          void Function(AddOutbreakMemberResponse) updates) =>
      super.copyWith((message) => updates(message as AddOutbreakMemberResponse))
          as AddOutbreakMemberResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddOutbreakMemberResponse create() => AddOutbreakMemberResponse._();
  @$core.override
  AddOutbreakMemberResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddOutbreakMemberResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddOutbreakMemberResponse>(create);
  static AddOutbreakMemberResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Membership get membership => $_getN(0);
  @$pb.TagNumber(1)
  set membership(Membership value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMembership() => $_has(0);
  @$pb.TagNumber(1)
  void clearMembership() => $_clearField(1);
  @$pb.TagNumber(1)
  Membership ensureMembership() => $_ensure(0);
}

class GetClusterRequest extends $pb.GeneratedMessage {
  factory GetClusterRequest({
    $core.String? outbreakId,
  }) {
    final result = create();
    if (outbreakId != null) result.outbreakId = outbreakId;
    return result;
  }

  GetClusterRequest._();

  factory GetClusterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetClusterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetClusterRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'outbreakId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetClusterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetClusterRequest copyWith(void Function(GetClusterRequest) updates) =>
      super.copyWith((message) => updates(message as GetClusterRequest))
          as GetClusterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetClusterRequest create() => GetClusterRequest._();
  @$core.override
  GetClusterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetClusterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetClusterRequest>(create);
  static GetClusterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outbreakId => $_getSZ(0);
  @$pb.TagNumber(1)
  set outbreakId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutbreakId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutbreakId() => $_clearField(1);
}

class GetClusterResponse extends $pb.GeneratedMessage {
  factory GetClusterResponse({
    ClusterSummary? cluster,
  }) {
    final result = create();
    if (cluster != null) result.cluster = cluster;
    return result;
  }

  GetClusterResponse._();

  factory GetClusterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetClusterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetClusterResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<ClusterSummary>(1, _omitFieldNames ? '' : 'cluster',
        subBuilder: ClusterSummary.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetClusterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetClusterResponse copyWith(void Function(GetClusterResponse) updates) =>
      super.copyWith((message) => updates(message as GetClusterResponse))
          as GetClusterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetClusterResponse create() => GetClusterResponse._();
  @$core.override
  GetClusterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetClusterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetClusterResponse>(create);
  static GetClusterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ClusterSummary get cluster => $_getN(0);
  @$pb.TagNumber(1)
  set cluster(ClusterSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCluster() => $_has(0);
  @$pb.TagNumber(1)
  void clearCluster() => $_clearField(1);
  @$pb.TagNumber(1)
  ClusterSummary ensureCluster() => $_ensure(0);
}

class ListOutbreaksRequest extends $pb.GeneratedMessage {
  factory ListOutbreaksRequest({
    OutbreakState? state,
    $core.bool? openOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (openOnly != null) result.openOnly = openOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListOutbreaksRequest._();

  factory ListOutbreaksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOutbreaksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOutbreaksRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aE<OutbreakState>(1, _omitFieldNames ? '' : 'state',
        enumValues: OutbreakState.values)
    ..aOB(2, _omitFieldNames ? '' : 'openOnly')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutbreaksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutbreaksRequest copyWith(void Function(ListOutbreaksRequest) updates) =>
      super.copyWith((message) => updates(message as ListOutbreaksRequest))
          as ListOutbreaksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOutbreaksRequest create() => ListOutbreaksRequest._();
  @$core.override
  ListOutbreaksRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOutbreaksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOutbreaksRequest>(create);
  static ListOutbreaksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  OutbreakState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(OutbreakState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

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

class ListOutbreaksResponse extends $pb.GeneratedMessage {
  factory ListOutbreaksResponse({
    $core.Iterable<Outbreak>? outbreaks,
  }) {
    final result = create();
    if (outbreaks != null) result.outbreaks.addAll(outbreaks);
    return result;
  }

  ListOutbreaksResponse._();

  factory ListOutbreaksResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOutbreaksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOutbreaksResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..pPM<Outbreak>(1, _omitFieldNames ? '' : 'outbreaks',
        subBuilder: Outbreak.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutbreaksResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutbreaksResponse copyWith(
          void Function(ListOutbreaksResponse) updates) =>
      super.copyWith((message) => updates(message as ListOutbreaksResponse))
          as ListOutbreaksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOutbreaksResponse create() => ListOutbreaksResponse._();
  @$core.override
  ListOutbreaksResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOutbreaksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOutbreaksResponse>(create);
  static ListOutbreaksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Outbreak> get outbreaks => $_getList(0);
}

class StartHygieneSessionRequest extends $pb.GeneratedMessage {
  factory StartHygieneSessionRequest({
    $core.String? facilityId,
    $core.String? locationId,
    $core.String? notes,
    $0.Timestamp? startedAt,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (notes != null) result.notes = notes;
    if (startedAt != null) result.startedAt = startedAt;
    return result;
  }

  StartHygieneSessionRequest._();

  factory StartHygieneSessionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartHygieneSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartHygieneSessionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'locationId')
    ..aOS(3, _omitFieldNames ? '' : 'notes')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartHygieneSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartHygieneSessionRequest copyWith(
          void Function(StartHygieneSessionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StartHygieneSessionRequest))
          as StartHygieneSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartHygieneSessionRequest create() => StartHygieneSessionRequest._();
  @$core.override
  StartHygieneSessionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartHygieneSessionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartHygieneSessionRequest>(create);
  static StartHygieneSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get locationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get notes => $_getSZ(2);
  @$pb.TagNumber(3)
  set notes($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNotes() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotes() => $_clearField(3);

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
}

class StartHygieneSessionResponse extends $pb.GeneratedMessage {
  factory StartHygieneSessionResponse({
    HygieneSession? session,
  }) {
    final result = create();
    if (session != null) result.session = session;
    return result;
  }

  StartHygieneSessionResponse._();

  factory StartHygieneSessionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartHygieneSessionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartHygieneSessionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<HygieneSession>(1, _omitFieldNames ? '' : 'session',
        subBuilder: HygieneSession.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartHygieneSessionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartHygieneSessionResponse copyWith(
          void Function(StartHygieneSessionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StartHygieneSessionResponse))
          as StartHygieneSessionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartHygieneSessionResponse create() =>
      StartHygieneSessionResponse._();
  @$core.override
  StartHygieneSessionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartHygieneSessionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartHygieneSessionResponse>(create);
  static StartHygieneSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  HygieneSession get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(HygieneSession value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  HygieneSession ensureSession() => $_ensure(0);
}

class RecordObservationRequest extends $pb.GeneratedMessage {
  factory RecordObservationRequest({
    $core.String? sessionId,
    Discipline? discipline,
    Moment? moment,
    HygieneAction? action,
    $core.bool? glovesWorn,
    $0.Timestamp? observedAt,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (discipline != null) result.discipline = discipline;
    if (moment != null) result.moment = moment;
    if (action != null) result.action = action;
    if (glovesWorn != null) result.glovesWorn = glovesWorn;
    if (observedAt != null) result.observedAt = observedAt;
    return result;
  }

  RecordObservationRequest._();

  factory RecordObservationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordObservationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordObservationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aE<Discipline>(2, _omitFieldNames ? '' : 'discipline',
        enumValues: Discipline.values)
    ..aE<Moment>(3, _omitFieldNames ? '' : 'moment', enumValues: Moment.values)
    ..aE<HygieneAction>(4, _omitFieldNames ? '' : 'action',
        enumValues: HygieneAction.values)
    ..aOB(5, _omitFieldNames ? '' : 'glovesWorn')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordObservationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordObservationRequest copyWith(
          void Function(RecordObservationRequest) updates) =>
      super.copyWith((message) => updates(message as RecordObservationRequest))
          as RecordObservationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordObservationRequest create() => RecordObservationRequest._();
  @$core.override
  RecordObservationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordObservationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordObservationRequest>(create);
  static RecordObservationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  Discipline get discipline => $_getN(1);
  @$pb.TagNumber(2)
  set discipline(Discipline value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDiscipline() => $_has(1);
  @$pb.TagNumber(2)
  void clearDiscipline() => $_clearField(2);

  @$pb.TagNumber(3)
  Moment get moment => $_getN(2);
  @$pb.TagNumber(3)
  set moment(Moment value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMoment() => $_has(2);
  @$pb.TagNumber(3)
  void clearMoment() => $_clearField(3);

  @$pb.TagNumber(4)
  HygieneAction get action => $_getN(3);
  @$pb.TagNumber(4)
  set action(HygieneAction value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get glovesWorn => $_getBF(4);
  @$pb.TagNumber(5)
  set glovesWorn($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasGlovesWorn() => $_has(4);
  @$pb.TagNumber(5)
  void clearGlovesWorn() => $_clearField(5);

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

class RecordObservationResponse extends $pb.GeneratedMessage {
  factory RecordObservationResponse({
    HygieneObservation? observation,
  }) {
    final result = create();
    if (observation != null) result.observation = observation;
    return result;
  }

  RecordObservationResponse._();

  factory RecordObservationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordObservationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordObservationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<HygieneObservation>(1, _omitFieldNames ? '' : 'observation',
        subBuilder: HygieneObservation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordObservationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordObservationResponse copyWith(
          void Function(RecordObservationResponse) updates) =>
      super.copyWith((message) => updates(message as RecordObservationResponse))
          as RecordObservationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordObservationResponse create() => RecordObservationResponse._();
  @$core.override
  RecordObservationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordObservationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordObservationResponse>(create);
  static RecordObservationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  HygieneObservation get observation => $_getN(0);
  @$pb.TagNumber(1)
  set observation(HygieneObservation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasObservation() => $_has(0);
  @$pb.TagNumber(1)
  void clearObservation() => $_clearField(1);
  @$pb.TagNumber(1)
  HygieneObservation ensureObservation() => $_ensure(0);
}

class EndHygieneSessionRequest extends $pb.GeneratedMessage {
  factory EndHygieneSessionRequest({
    $core.String? sessionId,
    $core.String? notes,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (notes != null) result.notes = notes;
    return result;
  }

  EndHygieneSessionRequest._();

  factory EndHygieneSessionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndHygieneSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndHygieneSessionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndHygieneSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndHygieneSessionRequest copyWith(
          void Function(EndHygieneSessionRequest) updates) =>
      super.copyWith((message) => updates(message as EndHygieneSessionRequest))
          as EndHygieneSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndHygieneSessionRequest create() => EndHygieneSessionRequest._();
  @$core.override
  EndHygieneSessionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndHygieneSessionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndHygieneSessionRequest>(create);
  static EndHygieneSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get notes => $_getSZ(1);
  @$pb.TagNumber(2)
  set notes($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNotes() => $_has(1);
  @$pb.TagNumber(2)
  void clearNotes() => $_clearField(2);
}

class EndHygieneSessionResponse extends $pb.GeneratedMessage {
  factory EndHygieneSessionResponse({
    HygieneSession? session,
  }) {
    final result = create();
    if (session != null) result.session = session;
    return result;
  }

  EndHygieneSessionResponse._();

  factory EndHygieneSessionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndHygieneSessionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndHygieneSessionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<HygieneSession>(1, _omitFieldNames ? '' : 'session',
        subBuilder: HygieneSession.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndHygieneSessionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndHygieneSessionResponse copyWith(
          void Function(EndHygieneSessionResponse) updates) =>
      super.copyWith((message) => updates(message as EndHygieneSessionResponse))
          as EndHygieneSessionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndHygieneSessionResponse create() => EndHygieneSessionResponse._();
  @$core.override
  EndHygieneSessionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndHygieneSessionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndHygieneSessionResponse>(create);
  static EndHygieneSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  HygieneSession get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(HygieneSession value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  HygieneSession ensureSession() => $_ensure(0);
}

class GetHygieneComplianceRequest extends $pb.GeneratedMessage {
  factory GetHygieneComplianceRequest({
    $core.String? locationId,
    $core.String? groupBy,
    $0.Timestamp? periodFrom,
    $0.Timestamp? periodTo,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    if (groupBy != null) result.groupBy = groupBy;
    if (periodFrom != null) result.periodFrom = periodFrom;
    if (periodTo != null) result.periodTo = periodTo;
    return result;
  }

  GetHygieneComplianceRequest._();

  factory GetHygieneComplianceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetHygieneComplianceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHygieneComplianceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..aOS(2, _omitFieldNames ? '' : 'groupBy')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'periodFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'periodTo',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHygieneComplianceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHygieneComplianceRequest copyWith(
          void Function(GetHygieneComplianceRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetHygieneComplianceRequest))
          as GetHygieneComplianceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetHygieneComplianceRequest create() =>
      GetHygieneComplianceRequest._();
  @$core.override
  GetHygieneComplianceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetHygieneComplianceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHygieneComplianceRequest>(create);
  static GetHygieneComplianceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

  /// "discipline", "moment", or empty for a single total.
  @$pb.TagNumber(2)
  $core.String get groupBy => $_getSZ(1);
  @$pb.TagNumber(2)
  set groupBy($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGroupBy() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupBy() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get periodFrom => $_getN(2);
  @$pb.TagNumber(3)
  set periodFrom($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPeriodFrom() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriodFrom() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensurePeriodFrom() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get periodTo => $_getN(3);
  @$pb.TagNumber(4)
  set periodTo($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPeriodTo() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeriodTo() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensurePeriodTo() => $_ensure(3);
}

class GetHygieneComplianceResponse extends $pb.GeneratedMessage {
  factory GetHygieneComplianceResponse({
    $core.Iterable<Compliance>? groups,
    $core.int? observations,
    $core.int? suppressionThreshold,
    $core.String? indicatorCode,
    $core.int? indicatorRevision,
  }) {
    final result = create();
    if (groups != null) result.groups.addAll(groups);
    if (observations != null) result.observations = observations;
    if (suppressionThreshold != null)
      result.suppressionThreshold = suppressionThreshold;
    if (indicatorCode != null) result.indicatorCode = indicatorCode;
    if (indicatorRevision != null) result.indicatorRevision = indicatorRevision;
    return result;
  }

  GetHygieneComplianceResponse._();

  factory GetHygieneComplianceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetHygieneComplianceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHygieneComplianceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..pPM<Compliance>(1, _omitFieldNames ? '' : 'groups',
        subBuilder: Compliance.create)
    ..aI(2, _omitFieldNames ? '' : 'observations')
    ..aI(3, _omitFieldNames ? '' : 'suppressionThreshold')
    ..aOS(4, _omitFieldNames ? '' : 'indicatorCode')
    ..aI(5, _omitFieldNames ? '' : 'indicatorRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHygieneComplianceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHygieneComplianceResponse copyWith(
          void Function(GetHygieneComplianceResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetHygieneComplianceResponse))
          as GetHygieneComplianceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetHygieneComplianceResponse create() =>
      GetHygieneComplianceResponse._();
  @$core.override
  GetHygieneComplianceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetHygieneComplianceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHygieneComplianceResponse>(create);
  static GetHygieneComplianceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Compliance> get groups => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get observations => $_getIZ(1);
  @$pb.TagNumber(2)
  set observations($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasObservations() => $_has(1);
  @$pb.TagNumber(2)
  void clearObservations() => $_clearField(2);

  /// The group size below which a figure was withheld. Reported, because a
  /// report with no suppression and one where nothing was small enough to
  /// suppress look identical otherwise.
  @$pb.TagNumber(3)
  $core.int get suppressionThreshold => $_getIZ(2);
  @$pb.TagNumber(3)
  set suppressionThreshold($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSuppressionThreshold() => $_has(2);
  @$pb.TagNumber(3)
  void clearSuppressionThreshold() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get indicatorCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set indicatorCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIndicatorCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearIndicatorCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get indicatorRevision => $_getIZ(4);
  @$pb.TagNumber(5)
  set indicatorRevision($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIndicatorRevision() => $_has(4);
  @$pb.TagNumber(5)
  void clearIndicatorRevision() => $_clearField(5);
}

class ReportExposureRequest extends $pb.GeneratedMessage {
  factory ReportExposureRequest({
    $core.String? reference,
    $core.String? staffId,
    Discipline? discipline,
    $core.String? facilityId,
    $core.String? locationId,
    ExposureKind? kind,
    $core.String? device,
    $core.String? circumstance,
    $core.bool? deepInjury,
    $core.String? sourcePatientId,
    $core.bool? sourceKnown,
    $core.bool? sourceConsented,
    $0.Timestamp? occurredAt,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    if (staffId != null) result.staffId = staffId;
    if (discipline != null) result.discipline = discipline;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (kind != null) result.kind = kind;
    if (device != null) result.device = device;
    if (circumstance != null) result.circumstance = circumstance;
    if (deepInjury != null) result.deepInjury = deepInjury;
    if (sourcePatientId != null) result.sourcePatientId = sourcePatientId;
    if (sourceKnown != null) result.sourceKnown = sourceKnown;
    if (sourceConsented != null) result.sourceConsented = sourceConsented;
    if (occurredAt != null) result.occurredAt = occurredAt;
    return result;
  }

  ReportExposureRequest._();

  factory ReportExposureRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportExposureRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportExposureRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..aOS(2, _omitFieldNames ? '' : 'staffId')
    ..aE<Discipline>(3, _omitFieldNames ? '' : 'discipline',
        enumValues: Discipline.values)
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'locationId')
    ..aE<ExposureKind>(6, _omitFieldNames ? '' : 'kind',
        enumValues: ExposureKind.values)
    ..aOS(7, _omitFieldNames ? '' : 'device')
    ..aOS(8, _omitFieldNames ? '' : 'circumstance')
    ..aOB(9, _omitFieldNames ? '' : 'deepInjury')
    ..aOS(10, _omitFieldNames ? '' : 'sourcePatientId')
    ..aOB(11, _omitFieldNames ? '' : 'sourceKnown')
    ..aOB(12, _omitFieldNames ? '' : 'sourceConsented')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportExposureRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportExposureRequest copyWith(
          void Function(ReportExposureRequest) updates) =>
      super.copyWith((message) => updates(message as ReportExposureRequest))
          as ReportExposureRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportExposureRequest create() => ReportExposureRequest._();
  @$core.override
  ReportExposureRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReportExposureRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportExposureRequest>(create);
  static ReportExposureRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reference => $_getSZ(0);
  @$pb.TagNumber(1)
  set reference($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReference() => $_has(0);
  @$pb.TagNumber(1)
  void clearReference() => $_clearField(1);

  /// Empty reports the caller's own exposure.
  @$pb.TagNumber(2)
  $core.String get staffId => $_getSZ(1);
  @$pb.TagNumber(2)
  set staffId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStaffId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStaffId() => $_clearField(2);

  @$pb.TagNumber(3)
  Discipline get discipline => $_getN(2);
  @$pb.TagNumber(3)
  set discipline(Discipline value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDiscipline() => $_has(2);
  @$pb.TagNumber(3)
  void clearDiscipline() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get locationId => $_getSZ(4);
  @$pb.TagNumber(5)
  set locationId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLocationId() => $_has(4);
  @$pb.TagNumber(5)
  void clearLocationId() => $_clearField(5);

  @$pb.TagNumber(6)
  ExposureKind get kind => $_getN(5);
  @$pb.TagNumber(6)
  set kind(ExposureKind value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasKind() => $_has(5);
  @$pb.TagNumber(6)
  void clearKind() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get device => $_getSZ(6);
  @$pb.TagNumber(7)
  set device($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDevice() => $_has(6);
  @$pb.TagNumber(7)
  void clearDevice() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get circumstance => $_getSZ(7);
  @$pb.TagNumber(8)
  set circumstance($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCircumstance() => $_has(7);
  @$pb.TagNumber(8)
  void clearCircumstance() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get deepInjury => $_getBF(8);
  @$pb.TagNumber(9)
  set deepInjury($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDeepInjury() => $_has(8);
  @$pb.TagNumber(9)
  void clearDeepInjury() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get sourcePatientId => $_getSZ(9);
  @$pb.TagNumber(10)
  set sourcePatientId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSourcePatientId() => $_has(9);
  @$pb.TagNumber(10)
  void clearSourcePatientId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get sourceKnown => $_getBF(10);
  @$pb.TagNumber(11)
  set sourceKnown($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSourceKnown() => $_has(10);
  @$pb.TagNumber(11)
  void clearSourceKnown() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get sourceConsented => $_getBF(11);
  @$pb.TagNumber(12)
  set sourceConsented($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSourceConsented() => $_has(11);
  @$pb.TagNumber(12)
  void clearSourceConsented() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get occurredAt => $_getN(12);
  @$pb.TagNumber(13)
  set occurredAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasOccurredAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearOccurredAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureOccurredAt() => $_ensure(12);
}

class ReportExposureResponse extends $pb.GeneratedMessage {
  factory ReportExposureResponse({
    Exposure? exposure,
    $core.Iterable<ExposureTask>? tasks,
  }) {
    final result = create();
    if (exposure != null) result.exposure = exposure;
    if (tasks != null) result.tasks.addAll(tasks);
    return result;
  }

  ReportExposureResponse._();

  factory ReportExposureResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportExposureResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportExposureResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<Exposure>(1, _omitFieldNames ? '' : 'exposure',
        subBuilder: Exposure.create)
    ..pPM<ExposureTask>(2, _omitFieldNames ? '' : 'tasks',
        subBuilder: ExposureTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportExposureResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportExposureResponse copyWith(
          void Function(ReportExposureResponse) updates) =>
      super.copyWith((message) => updates(message as ReportExposureResponse))
          as ReportExposureResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportExposureResponse create() => ReportExposureResponse._();
  @$core.override
  ReportExposureResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReportExposureResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportExposureResponse>(create);
  static ReportExposureResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Exposure get exposure => $_getN(0);
  @$pb.TagNumber(1)
  set exposure(Exposure value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasExposure() => $_has(0);
  @$pb.TagNumber(1)
  void clearExposure() => $_clearField(1);
  @$pb.TagNumber(1)
  Exposure ensureExposure() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<ExposureTask> get tasks => $_getList(1);
}

class GetExposureRequest extends $pb.GeneratedMessage {
  factory GetExposureRequest({
    $core.String? exposureId,
  }) {
    final result = create();
    if (exposureId != null) result.exposureId = exposureId;
    return result;
  }

  GetExposureRequest._();

  factory GetExposureRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetExposureRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetExposureRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'exposureId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExposureRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExposureRequest copyWith(void Function(GetExposureRequest) updates) =>
      super.copyWith((message) => updates(message as GetExposureRequest))
          as GetExposureRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetExposureRequest create() => GetExposureRequest._();
  @$core.override
  GetExposureRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetExposureRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetExposureRequest>(create);
  static GetExposureRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get exposureId => $_getSZ(0);
  @$pb.TagNumber(1)
  set exposureId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExposureId() => $_has(0);
  @$pb.TagNumber(1)
  void clearExposureId() => $_clearField(1);
}

class GetExposureResponse extends $pb.GeneratedMessage {
  factory GetExposureResponse({
    Exposure? exposure,
    $core.Iterable<ExposureTask>? tasks,
  }) {
    final result = create();
    if (exposure != null) result.exposure = exposure;
    if (tasks != null) result.tasks.addAll(tasks);
    return result;
  }

  GetExposureResponse._();

  factory GetExposureResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetExposureResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetExposureResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<Exposure>(1, _omitFieldNames ? '' : 'exposure',
        subBuilder: Exposure.create)
    ..pPM<ExposureTask>(2, _omitFieldNames ? '' : 'tasks',
        subBuilder: ExposureTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExposureResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExposureResponse copyWith(void Function(GetExposureResponse) updates) =>
      super.copyWith((message) => updates(message as GetExposureResponse))
          as GetExposureResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetExposureResponse create() => GetExposureResponse._();
  @$core.override
  GetExposureResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetExposureResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetExposureResponse>(create);
  static GetExposureResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Exposure get exposure => $_getN(0);
  @$pb.TagNumber(1)
  set exposure(Exposure value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasExposure() => $_has(0);
  @$pb.TagNumber(1)
  void clearExposure() => $_clearField(1);
  @$pb.TagNumber(1)
  Exposure ensureExposure() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<ExposureTask> get tasks => $_getList(1);
}

class CompleteExposureTaskRequest extends $pb.GeneratedMessage {
  factory CompleteExposureTaskRequest({
    $core.String? exposureId,
    $core.String? taskId,
    TaskState? state,
    $core.String? outcome,
  }) {
    final result = create();
    if (exposureId != null) result.exposureId = exposureId;
    if (taskId != null) result.taskId = taskId;
    if (state != null) result.state = state;
    if (outcome != null) result.outcome = outcome;
    return result;
  }

  CompleteExposureTaskRequest._();

  factory CompleteExposureTaskRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteExposureTaskRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteExposureTaskRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'exposureId')
    ..aOS(2, _omitFieldNames ? '' : 'taskId')
    ..aE<TaskState>(3, _omitFieldNames ? '' : 'state',
        enumValues: TaskState.values)
    ..aOS(4, _omitFieldNames ? '' : 'outcome')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteExposureTaskRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteExposureTaskRequest copyWith(
          void Function(CompleteExposureTaskRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CompleteExposureTaskRequest))
          as CompleteExposureTaskRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteExposureTaskRequest create() =>
      CompleteExposureTaskRequest._();
  @$core.override
  CompleteExposureTaskRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteExposureTaskRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteExposureTaskRequest>(create);
  static CompleteExposureTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get exposureId => $_getSZ(0);
  @$pb.TagNumber(1)
  set exposureId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExposureId() => $_has(0);
  @$pb.TagNumber(1)
  void clearExposureId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get taskId => $_getSZ(1);
  @$pb.TagNumber(2)
  set taskId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTaskId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaskId() => $_clearField(2);

  @$pb.TagNumber(3)
  TaskState get state => $_getN(2);
  @$pb.TagNumber(3)
  set state(TaskState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get outcome => $_getSZ(3);
  @$pb.TagNumber(4)
  set outcome($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutcome() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutcome() => $_clearField(4);
}

class CompleteExposureTaskResponse extends $pb.GeneratedMessage {
  factory CompleteExposureTaskResponse({
    ExposureTask? task,
  }) {
    final result = create();
    if (task != null) result.task = task;
    return result;
  }

  CompleteExposureTaskResponse._();

  factory CompleteExposureTaskResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteExposureTaskResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteExposureTaskResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<ExposureTask>(1, _omitFieldNames ? '' : 'task',
        subBuilder: ExposureTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteExposureTaskResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteExposureTaskResponse copyWith(
          void Function(CompleteExposureTaskResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CompleteExposureTaskResponse))
          as CompleteExposureTaskResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteExposureTaskResponse create() =>
      CompleteExposureTaskResponse._();
  @$core.override
  CompleteExposureTaskResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteExposureTaskResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteExposureTaskResponse>(create);
  static CompleteExposureTaskResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ExposureTask get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(ExposureTask value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  ExposureTask ensureTask() => $_ensure(0);
}

class CloseExposureRequest extends $pb.GeneratedMessage {
  factory CloseExposureRequest({
    $core.String? exposureId,
    $core.String? outcome,
  }) {
    final result = create();
    if (exposureId != null) result.exposureId = exposureId;
    if (outcome != null) result.outcome = outcome;
    return result;
  }

  CloseExposureRequest._();

  factory CloseExposureRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseExposureRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseExposureRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'exposureId')
    ..aOS(2, _omitFieldNames ? '' : 'outcome')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseExposureRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseExposureRequest copyWith(void Function(CloseExposureRequest) updates) =>
      super.copyWith((message) => updates(message as CloseExposureRequest))
          as CloseExposureRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseExposureRequest create() => CloseExposureRequest._();
  @$core.override
  CloseExposureRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseExposureRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseExposureRequest>(create);
  static CloseExposureRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get exposureId => $_getSZ(0);
  @$pb.TagNumber(1)
  set exposureId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExposureId() => $_has(0);
  @$pb.TagNumber(1)
  void clearExposureId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get outcome => $_getSZ(1);
  @$pb.TagNumber(2)
  set outcome($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOutcome() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutcome() => $_clearField(2);
}

class CloseExposureResponse extends $pb.GeneratedMessage {
  factory CloseExposureResponse({
    Exposure? exposure,
  }) {
    final result = create();
    if (exposure != null) result.exposure = exposure;
    return result;
  }

  CloseExposureResponse._();

  factory CloseExposureResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseExposureResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseExposureResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<Exposure>(1, _omitFieldNames ? '' : 'exposure',
        subBuilder: Exposure.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseExposureResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseExposureResponse copyWith(
          void Function(CloseExposureResponse) updates) =>
      super.copyWith((message) => updates(message as CloseExposureResponse))
          as CloseExposureResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseExposureResponse create() => CloseExposureResponse._();
  @$core.override
  CloseExposureResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseExposureResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseExposureResponse>(create);
  static CloseExposureResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Exposure get exposure => $_getN(0);
  @$pb.TagNumber(1)
  set exposure(Exposure value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasExposure() => $_has(0);
  @$pb.TagNumber(1)
  void clearExposure() => $_clearField(1);
  @$pb.TagNumber(1)
  Exposure ensureExposure() => $_ensure(0);
}

class ListExposuresRequest extends $pb.GeneratedMessage {
  factory ListExposuresRequest({
    $core.String? staffId,
    $core.bool? openOnly,
    $0.Timestamp? occurredFrom,
    $0.Timestamp? occurredTo,
    $core.int? pageSize,
    $core.int? pageOffset,
  }) {
    final result = create();
    if (staffId != null) result.staffId = staffId;
    if (openOnly != null) result.openOnly = openOnly;
    if (occurredFrom != null) result.occurredFrom = occurredFrom;
    if (occurredTo != null) result.occurredTo = occurredTo;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageOffset != null) result.pageOffset = pageOffset;
    return result;
  }

  ListExposuresRequest._();

  factory ListExposuresRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListExposuresRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListExposuresRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'staffId')
    ..aOB(2, _omitFieldNames ? '' : 'openOnly')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'occurredFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'occurredTo',
        subBuilder: $0.Timestamp.create)
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..aI(6, _omitFieldNames ? '' : 'pageOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExposuresRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExposuresRequest copyWith(void Function(ListExposuresRequest) updates) =>
      super.copyWith((message) => updates(message as ListExposuresRequest))
          as ListExposuresRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListExposuresRequest create() => ListExposuresRequest._();
  @$core.override
  ListExposuresRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListExposuresRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListExposuresRequest>(create);
  static ListExposuresRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get staffId => $_getSZ(0);
  @$pb.TagNumber(1)
  set staffId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStaffId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStaffId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get openOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set openOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpenOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpenOnly() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get occurredFrom => $_getN(2);
  @$pb.TagNumber(3)
  set occurredFrom($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOccurredFrom() => $_has(2);
  @$pb.TagNumber(3)
  void clearOccurredFrom() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureOccurredFrom() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get occurredTo => $_getN(3);
  @$pb.TagNumber(4)
  set occurredTo($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasOccurredTo() => $_has(3);
  @$pb.TagNumber(4)
  void clearOccurredTo() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureOccurredTo() => $_ensure(3);

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

class ListExposuresResponse extends $pb.GeneratedMessage {
  factory ListExposuresResponse({
    $core.Iterable<Exposure>? exposures,
  }) {
    final result = create();
    if (exposures != null) result.exposures.addAll(exposures);
    return result;
  }

  ListExposuresResponse._();

  factory ListExposuresResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListExposuresResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListExposuresResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..pPM<Exposure>(1, _omitFieldNames ? '' : 'exposures',
        subBuilder: Exposure.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExposuresResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExposuresResponse copyWith(
          void Function(ListExposuresResponse) updates) =>
      super.copyWith((message) => updates(message as ListExposuresResponse))
          as ListExposuresResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListExposuresResponse create() => ListExposuresResponse._();
  @$core.override
  ListExposuresResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListExposuresResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListExposuresResponse>(create);
  static ListExposuresResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Exposure> get exposures => $_getList(0);
}

class SweepExposureTasksRequest extends $pb.GeneratedMessage {
  factory SweepExposureTasksRequest() => create();

  SweepExposureTasksRequest._();

  factory SweepExposureTasksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SweepExposureTasksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SweepExposureTasksRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepExposureTasksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepExposureTasksRequest copyWith(
          void Function(SweepExposureTasksRequest) updates) =>
      super.copyWith((message) => updates(message as SweepExposureTasksRequest))
          as SweepExposureTasksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SweepExposureTasksRequest create() => SweepExposureTasksRequest._();
  @$core.override
  SweepExposureTasksRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SweepExposureTasksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SweepExposureTasksRequest>(create);
  static SweepExposureTasksRequest? _defaultInstance;
}

class SweepExposureTasksResponse extends $pb.GeneratedMessage {
  factory SweepExposureTasksResponse({
    $core.int? escalated,
  }) {
    final result = create();
    if (escalated != null) result.escalated = escalated;
    return result;
  }

  SweepExposureTasksResponse._();

  factory SweepExposureTasksResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SweepExposureTasksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SweepExposureTasksResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'escalated')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepExposureTasksResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepExposureTasksResponse copyWith(
          void Function(SweepExposureTasksResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SweepExposureTasksResponse))
          as SweepExposureTasksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SweepExposureTasksResponse create() => SweepExposureTasksResponse._();
  @$core.override
  SweepExposureTasksResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SweepExposureTasksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SweepExposureTasksResponse>(create);
  static SweepExposureTasksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get escalated => $_getIZ(0);
  @$pb.TagNumber(1)
  set escalated($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEscalated() => $_has(0);
  @$pb.TagNumber(1)
  void clearEscalated() => $_clearField(1);
}

class DraftStewardshipRuleRequest extends $pb.GeneratedMessage {
  factory DraftStewardshipRuleRequest({
    $core.String? code,
    $core.String? name,
    $core.int? revision,
    TriggerKind? kind,
    $core.Iterable<$core.String>? agents,
    $core.bool? allAgents,
    $core.int? dayThreshold,
    $core.String? prompt,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (revision != null) result.revision = revision;
    if (kind != null) result.kind = kind;
    if (agents != null) result.agents.addAll(agents);
    if (allAgents != null) result.allAgents = allAgents;
    if (dayThreshold != null) result.dayThreshold = dayThreshold;
    if (prompt != null) result.prompt = prompt;
    return result;
  }

  DraftStewardshipRuleRequest._();

  factory DraftStewardshipRuleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DraftStewardshipRuleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DraftStewardshipRuleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'revision')
    ..aE<TriggerKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: TriggerKind.values)
    ..pPS(5, _omitFieldNames ? '' : 'agents')
    ..aOB(6, _omitFieldNames ? '' : 'allAgents')
    ..aI(7, _omitFieldNames ? '' : 'dayThreshold')
    ..aOS(8, _omitFieldNames ? '' : 'prompt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftStewardshipRuleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftStewardshipRuleRequest copyWith(
          void Function(DraftStewardshipRuleRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DraftStewardshipRuleRequest))
          as DraftStewardshipRuleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DraftStewardshipRuleRequest create() =>
      DraftStewardshipRuleRequest._();
  @$core.override
  DraftStewardshipRuleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DraftStewardshipRuleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DraftStewardshipRuleRequest>(create);
  static DraftStewardshipRuleRequest? _defaultInstance;

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
  TriggerKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(TriggerKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get agents => $_getList(4);

  @$pb.TagNumber(6)
  $core.bool get allAgents => $_getBF(5);
  @$pb.TagNumber(6)
  set allAgents($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAllAgents() => $_has(5);
  @$pb.TagNumber(6)
  void clearAllAgents() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get dayThreshold => $_getIZ(6);
  @$pb.TagNumber(7)
  set dayThreshold($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDayThreshold() => $_has(6);
  @$pb.TagNumber(7)
  void clearDayThreshold() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get prompt => $_getSZ(7);
  @$pb.TagNumber(8)
  set prompt($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPrompt() => $_has(7);
  @$pb.TagNumber(8)
  void clearPrompt() => $_clearField(8);
}

class DraftStewardshipRuleResponse extends $pb.GeneratedMessage {
  factory DraftStewardshipRuleResponse({
    StewardshipRule? rule,
  }) {
    final result = create();
    if (rule != null) result.rule = rule;
    return result;
  }

  DraftStewardshipRuleResponse._();

  factory DraftStewardshipRuleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DraftStewardshipRuleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DraftStewardshipRuleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<StewardshipRule>(1, _omitFieldNames ? '' : 'rule',
        subBuilder: StewardshipRule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftStewardshipRuleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftStewardshipRuleResponse copyWith(
          void Function(DraftStewardshipRuleResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DraftStewardshipRuleResponse))
          as DraftStewardshipRuleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DraftStewardshipRuleResponse create() =>
      DraftStewardshipRuleResponse._();
  @$core.override
  DraftStewardshipRuleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DraftStewardshipRuleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DraftStewardshipRuleResponse>(create);
  static DraftStewardshipRuleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StewardshipRule get rule => $_getN(0);
  @$pb.TagNumber(1)
  set rule(StewardshipRule value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRule() => $_has(0);
  @$pb.TagNumber(1)
  void clearRule() => $_clearField(1);
  @$pb.TagNumber(1)
  StewardshipRule ensureRule() => $_ensure(0);
}

class ApproveStewardshipRuleRequest extends $pb.GeneratedMessage {
  factory ApproveStewardshipRuleRequest({
    $core.String? ruleId,
    $0.Timestamp? effectiveFrom,
  }) {
    final result = create();
    if (ruleId != null) result.ruleId = ruleId;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    return result;
  }

  ApproveStewardshipRuleRequest._();

  factory ApproveStewardshipRuleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveStewardshipRuleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveStewardshipRuleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ruleId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveStewardshipRuleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveStewardshipRuleRequest copyWith(
          void Function(ApproveStewardshipRuleRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ApproveStewardshipRuleRequest))
          as ApproveStewardshipRuleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveStewardshipRuleRequest create() =>
      ApproveStewardshipRuleRequest._();
  @$core.override
  ApproveStewardshipRuleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveStewardshipRuleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveStewardshipRuleRequest>(create);
  static ApproveStewardshipRuleRequest? _defaultInstance;

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

class ApproveStewardshipRuleResponse extends $pb.GeneratedMessage {
  factory ApproveStewardshipRuleResponse({
    StewardshipRule? rule,
  }) {
    final result = create();
    if (rule != null) result.rule = rule;
    return result;
  }

  ApproveStewardshipRuleResponse._();

  factory ApproveStewardshipRuleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveStewardshipRuleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveStewardshipRuleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<StewardshipRule>(1, _omitFieldNames ? '' : 'rule',
        subBuilder: StewardshipRule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveStewardshipRuleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveStewardshipRuleResponse copyWith(
          void Function(ApproveStewardshipRuleResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ApproveStewardshipRuleResponse))
          as ApproveStewardshipRuleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveStewardshipRuleResponse create() =>
      ApproveStewardshipRuleResponse._();
  @$core.override
  ApproveStewardshipRuleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveStewardshipRuleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveStewardshipRuleResponse>(create);
  static ApproveStewardshipRuleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StewardshipRule get rule => $_getN(0);
  @$pb.TagNumber(1)
  set rule(StewardshipRule value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRule() => $_has(0);
  @$pb.TagNumber(1)
  void clearRule() => $_clearField(1);
  @$pb.TagNumber(1)
  StewardshipRule ensureRule() => $_ensure(0);
}

class ReviewEncounterRequest extends $pb.GeneratedMessage {
  factory ReviewEncounterRequest({
    $core.String? encounterId,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    return result;
  }

  ReviewEncounterRequest._();

  factory ReviewEncounterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReviewEncounterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewEncounterRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewEncounterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewEncounterRequest copyWith(
          void Function(ReviewEncounterRequest) updates) =>
      super.copyWith((message) => updates(message as ReviewEncounterRequest))
          as ReviewEncounterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReviewEncounterRequest create() => ReviewEncounterRequest._();
  @$core.override
  ReviewEncounterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReviewEncounterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewEncounterRequest>(create);
  static ReviewEncounterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);
}

class ReviewEncounterResponse extends $pb.GeneratedMessage {
  factory ReviewEncounterResponse({
    $core.Iterable<StewardshipReview>? reviews,
  }) {
    final result = create();
    if (reviews != null) result.reviews.addAll(reviews);
    return result;
  }

  ReviewEncounterResponse._();

  factory ReviewEncounterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReviewEncounterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewEncounterResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..pPM<StewardshipReview>(1, _omitFieldNames ? '' : 'reviews',
        subBuilder: StewardshipReview.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewEncounterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewEncounterResponse copyWith(
          void Function(ReviewEncounterResponse) updates) =>
      super.copyWith((message) => updates(message as ReviewEncounterResponse))
          as ReviewEncounterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReviewEncounterResponse create() => ReviewEncounterResponse._();
  @$core.override
  ReviewEncounterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReviewEncounterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewEncounterResponse>(create);
  static ReviewEncounterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StewardshipReview> get reviews => $_getList(0);
}

class AdviseReviewRequest extends $pb.GeneratedMessage {
  factory AdviseReviewRequest({
    $core.String? reviewId,
    Recommendation? recommendation,
    $core.String? advice,
  }) {
    final result = create();
    if (reviewId != null) result.reviewId = reviewId;
    if (recommendation != null) result.recommendation = recommendation;
    if (advice != null) result.advice = advice;
    return result;
  }

  AdviseReviewRequest._();

  factory AdviseReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdviseReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdviseReviewRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..aE<Recommendation>(2, _omitFieldNames ? '' : 'recommendation',
        enumValues: Recommendation.values)
    ..aOS(3, _omitFieldNames ? '' : 'advice')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdviseReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdviseReviewRequest copyWith(void Function(AdviseReviewRequest) updates) =>
      super.copyWith((message) => updates(message as AdviseReviewRequest))
          as AdviseReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdviseReviewRequest create() => AdviseReviewRequest._();
  @$core.override
  AdviseReviewRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdviseReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdviseReviewRequest>(create);
  static AdviseReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);

  @$pb.TagNumber(2)
  Recommendation get recommendation => $_getN(1);
  @$pb.TagNumber(2)
  set recommendation(Recommendation value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRecommendation() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecommendation() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get advice => $_getSZ(2);
  @$pb.TagNumber(3)
  set advice($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAdvice() => $_has(2);
  @$pb.TagNumber(3)
  void clearAdvice() => $_clearField(3);
}

class AdviseReviewResponse extends $pb.GeneratedMessage {
  factory AdviseReviewResponse({
    StewardshipReview? review,
  }) {
    final result = create();
    if (review != null) result.review = review;
    return result;
  }

  AdviseReviewResponse._();

  factory AdviseReviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdviseReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdviseReviewResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<StewardshipReview>(1, _omitFieldNames ? '' : 'review',
        subBuilder: StewardshipReview.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdviseReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdviseReviewResponse copyWith(void Function(AdviseReviewResponse) updates) =>
      super.copyWith((message) => updates(message as AdviseReviewResponse))
          as AdviseReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdviseReviewResponse create() => AdviseReviewResponse._();
  @$core.override
  AdviseReviewResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdviseReviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdviseReviewResponse>(create);
  static AdviseReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StewardshipReview get review => $_getN(0);
  @$pb.TagNumber(1)
  set review(StewardshipReview value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReview() => $_has(0);
  @$pb.TagNumber(1)
  void clearReview() => $_clearField(1);
  @$pb.TagNumber(1)
  StewardshipReview ensureReview() => $_ensure(0);
}

class RespondToReviewRequest extends $pb.GeneratedMessage {
  factory RespondToReviewRequest({
    $core.String? reviewId,
    Response? response,
    $core.String? reason,
  }) {
    final result = create();
    if (reviewId != null) result.reviewId = reviewId;
    if (response != null) result.response = response;
    if (reason != null) result.reason = reason;
    return result;
  }

  RespondToReviewRequest._();

  factory RespondToReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RespondToReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RespondToReviewRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..aE<Response>(2, _omitFieldNames ? '' : 'response',
        enumValues: Response.values)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespondToReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespondToReviewRequest copyWith(
          void Function(RespondToReviewRequest) updates) =>
      super.copyWith((message) => updates(message as RespondToReviewRequest))
          as RespondToReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RespondToReviewRequest create() => RespondToReviewRequest._();
  @$core.override
  RespondToReviewRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RespondToReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RespondToReviewRequest>(create);
  static RespondToReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);

  @$pb.TagNumber(2)
  Response get response => $_getN(1);
  @$pb.TagNumber(2)
  set response(Response value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasResponse() => $_has(1);
  @$pb.TagNumber(2)
  void clearResponse() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class RespondToReviewResponse extends $pb.GeneratedMessage {
  factory RespondToReviewResponse({
    StewardshipReview? review,
  }) {
    final result = create();
    if (review != null) result.review = review;
    return result;
  }

  RespondToReviewResponse._();

  factory RespondToReviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RespondToReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RespondToReviewResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<StewardshipReview>(1, _omitFieldNames ? '' : 'review',
        subBuilder: StewardshipReview.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespondToReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespondToReviewResponse copyWith(
          void Function(RespondToReviewResponse) updates) =>
      super.copyWith((message) => updates(message as RespondToReviewResponse))
          as RespondToReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RespondToReviewResponse create() => RespondToReviewResponse._();
  @$core.override
  RespondToReviewResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RespondToReviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RespondToReviewResponse>(create);
  static RespondToReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StewardshipReview get review => $_getN(0);
  @$pb.TagNumber(1)
  set review(StewardshipReview value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReview() => $_has(0);
  @$pb.TagNumber(1)
  void clearReview() => $_clearField(1);
  @$pb.TagNumber(1)
  StewardshipReview ensureReview() => $_ensure(0);
}

class WithdrawReviewRequest extends $pb.GeneratedMessage {
  factory WithdrawReviewRequest({
    $core.String? reviewId,
    $core.String? reason,
  }) {
    final result = create();
    if (reviewId != null) result.reviewId = reviewId;
    if (reason != null) result.reason = reason;
    return result;
  }

  WithdrawReviewRequest._();

  factory WithdrawReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WithdrawReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WithdrawReviewRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawReviewRequest copyWith(
          void Function(WithdrawReviewRequest) updates) =>
      super.copyWith((message) => updates(message as WithdrawReviewRequest))
          as WithdrawReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WithdrawReviewRequest create() => WithdrawReviewRequest._();
  @$core.override
  WithdrawReviewRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WithdrawReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WithdrawReviewRequest>(create);
  static WithdrawReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class WithdrawReviewResponse extends $pb.GeneratedMessage {
  factory WithdrawReviewResponse({
    StewardshipReview? review,
  }) {
    final result = create();
    if (review != null) result.review = review;
    return result;
  }

  WithdrawReviewResponse._();

  factory WithdrawReviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WithdrawReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WithdrawReviewResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<StewardshipReview>(1, _omitFieldNames ? '' : 'review',
        subBuilder: StewardshipReview.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawReviewResponse copyWith(
          void Function(WithdrawReviewResponse) updates) =>
      super.copyWith((message) => updates(message as WithdrawReviewResponse))
          as WithdrawReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WithdrawReviewResponse create() => WithdrawReviewResponse._();
  @$core.override
  WithdrawReviewResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WithdrawReviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WithdrawReviewResponse>(create);
  static WithdrawReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StewardshipReview get review => $_getN(0);
  @$pb.TagNumber(1)
  set review(StewardshipReview value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReview() => $_has(0);
  @$pb.TagNumber(1)
  void clearReview() => $_clearField(1);
  @$pb.TagNumber(1)
  StewardshipReview ensureReview() => $_ensure(0);
}

class ListReviewsRequest extends $pb.GeneratedMessage {
  factory ListReviewsRequest({
    $core.String? patientId,
    $core.String? encounterId,
    ReviewState? state,
    $core.bool? worklistOnly,
    $0.Timestamp? raisedFrom,
    $0.Timestamp? raisedTo,
    $core.int? pageSize,
    $core.int? pageOffset,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (state != null) result.state = state;
    if (worklistOnly != null) result.worklistOnly = worklistOnly;
    if (raisedFrom != null) result.raisedFrom = raisedFrom;
    if (raisedTo != null) result.raisedTo = raisedTo;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageOffset != null) result.pageOffset = pageOffset;
    return result;
  }

  ListReviewsRequest._();

  factory ListReviewsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReviewsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReviewsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aE<ReviewState>(3, _omitFieldNames ? '' : 'state',
        enumValues: ReviewState.values)
    ..aOB(4, _omitFieldNames ? '' : 'worklistOnly')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'raisedFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'raisedTo',
        subBuilder: $0.Timestamp.create)
    ..aI(7, _omitFieldNames ? '' : 'pageSize')
    ..aI(8, _omitFieldNames ? '' : 'pageOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReviewsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReviewsRequest copyWith(void Function(ListReviewsRequest) updates) =>
      super.copyWith((message) => updates(message as ListReviewsRequest))
          as ListReviewsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReviewsRequest create() => ListReviewsRequest._();
  @$core.override
  ListReviewsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReviewsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReviewsRequest>(create);
  static ListReviewsRequest? _defaultInstance;

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
  ReviewState get state => $_getN(2);
  @$pb.TagNumber(3)
  set state(ReviewState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get worklistOnly => $_getBF(3);
  @$pb.TagNumber(4)
  set worklistOnly($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorklistOnly() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorklistOnly() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get raisedFrom => $_getN(4);
  @$pb.TagNumber(5)
  set raisedFrom($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRaisedFrom() => $_has(4);
  @$pb.TagNumber(5)
  void clearRaisedFrom() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureRaisedFrom() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get raisedTo => $_getN(5);
  @$pb.TagNumber(6)
  set raisedTo($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRaisedTo() => $_has(5);
  @$pb.TagNumber(6)
  void clearRaisedTo() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureRaisedTo() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.int get pageSize => $_getIZ(6);
  @$pb.TagNumber(7)
  set pageSize($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPageSize() => $_has(6);
  @$pb.TagNumber(7)
  void clearPageSize() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get pageOffset => $_getIZ(7);
  @$pb.TagNumber(8)
  set pageOffset($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPageOffset() => $_has(7);
  @$pb.TagNumber(8)
  void clearPageOffset() => $_clearField(8);
}

class ListReviewsResponse extends $pb.GeneratedMessage {
  factory ListReviewsResponse({
    $core.Iterable<StewardshipReview>? reviews,
  }) {
    final result = create();
    if (reviews != null) result.reviews.addAll(reviews);
    return result;
  }

  ListReviewsResponse._();

  factory ListReviewsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReviewsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReviewsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..pPM<StewardshipReview>(1, _omitFieldNames ? '' : 'reviews',
        subBuilder: StewardshipReview.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReviewsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReviewsResponse copyWith(void Function(ListReviewsResponse) updates) =>
      super.copyWith((message) => updates(message as ListReviewsResponse))
          as ListReviewsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReviewsResponse create() => ListReviewsResponse._();
  @$core.override
  ListReviewsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReviewsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReviewsResponse>(create);
  static ListReviewsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StewardshipReview> get reviews => $_getList(0);
}

class GetStewardshipIndicatorsRequest extends $pb.GeneratedMessage {
  factory GetStewardshipIndicatorsRequest({
    $core.String? locationId,
    $0.Timestamp? periodFrom,
    $0.Timestamp? periodTo,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    if (periodFrom != null) result.periodFrom = periodFrom;
    if (periodTo != null) result.periodTo = periodTo;
    return result;
  }

  GetStewardshipIndicatorsRequest._();

  factory GetStewardshipIndicatorsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetStewardshipIndicatorsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStewardshipIndicatorsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'periodFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'periodTo',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStewardshipIndicatorsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStewardshipIndicatorsRequest copyWith(
          void Function(GetStewardshipIndicatorsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetStewardshipIndicatorsRequest))
          as GetStewardshipIndicatorsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStewardshipIndicatorsRequest create() =>
      GetStewardshipIndicatorsRequest._();
  @$core.override
  GetStewardshipIndicatorsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetStewardshipIndicatorsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetStewardshipIndicatorsRequest>(
          create);
  static GetStewardshipIndicatorsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get periodFrom => $_getN(1);
  @$pb.TagNumber(2)
  set periodFrom($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriodFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriodFrom() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensurePeriodFrom() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get periodTo => $_getN(2);
  @$pb.TagNumber(3)
  set periodTo($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPeriodTo() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriodTo() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensurePeriodTo() => $_ensure(2);
}

class GetStewardshipIndicatorsResponse extends $pb.GeneratedMessage {
  factory GetStewardshipIndicatorsResponse({
    StewardshipSummary? summary,
  }) {
    final result = create();
    if (summary != null) result.summary = summary;
    return result;
  }

  GetStewardshipIndicatorsResponse._();

  factory GetStewardshipIndicatorsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetStewardshipIndicatorsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStewardshipIndicatorsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<StewardshipSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: StewardshipSummary.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStewardshipIndicatorsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStewardshipIndicatorsResponse copyWith(
          void Function(GetStewardshipIndicatorsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetStewardshipIndicatorsResponse))
          as GetStewardshipIndicatorsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStewardshipIndicatorsResponse create() =>
      GetStewardshipIndicatorsResponse._();
  @$core.override
  GetStewardshipIndicatorsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetStewardshipIndicatorsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetStewardshipIndicatorsResponse>(
          create);
  static GetStewardshipIndicatorsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StewardshipSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(StewardshipSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  StewardshipSummary ensureSummary() => $_ensure(0);
}

class DraftLimitRequest extends $pb.GeneratedMessage {
  factory DraftLimitRequest({
    $core.String? code,
    $core.String? name,
    $core.int? revision,
    SampleKind? sampleKind,
    $core.String? unit,
    $fixnum.Int64? actionLevel,
    $fixnum.Int64? failLevel,
    $core.bool? detectionFails,
    $core.bool? belowIsFailure,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (revision != null) result.revision = revision;
    if (sampleKind != null) result.sampleKind = sampleKind;
    if (unit != null) result.unit = unit;
    if (actionLevel != null) result.actionLevel = actionLevel;
    if (failLevel != null) result.failLevel = failLevel;
    if (detectionFails != null) result.detectionFails = detectionFails;
    if (belowIsFailure != null) result.belowIsFailure = belowIsFailure;
    return result;
  }

  DraftLimitRequest._();

  factory DraftLimitRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DraftLimitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DraftLimitRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'revision')
    ..aE<SampleKind>(4, _omitFieldNames ? '' : 'sampleKind',
        enumValues: SampleKind.values)
    ..aOS(5, _omitFieldNames ? '' : 'unit')
    ..aInt64(6, _omitFieldNames ? '' : 'actionLevel')
    ..aInt64(7, _omitFieldNames ? '' : 'failLevel')
    ..aOB(8, _omitFieldNames ? '' : 'detectionFails')
    ..aOB(9, _omitFieldNames ? '' : 'belowIsFailure')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftLimitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftLimitRequest copyWith(void Function(DraftLimitRequest) updates) =>
      super.copyWith((message) => updates(message as DraftLimitRequest))
          as DraftLimitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DraftLimitRequest create() => DraftLimitRequest._();
  @$core.override
  DraftLimitRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DraftLimitRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DraftLimitRequest>(create);
  static DraftLimitRequest? _defaultInstance;

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
  SampleKind get sampleKind => $_getN(3);
  @$pb.TagNumber(4)
  set sampleKind(SampleKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSampleKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearSampleKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get unit => $_getSZ(4);
  @$pb.TagNumber(5)
  set unit($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnit() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnit() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get actionLevel => $_getI64(5);
  @$pb.TagNumber(6)
  set actionLevel($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasActionLevel() => $_has(5);
  @$pb.TagNumber(6)
  void clearActionLevel() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get failLevel => $_getI64(6);
  @$pb.TagNumber(7)
  set failLevel($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFailLevel() => $_has(6);
  @$pb.TagNumber(7)
  void clearFailLevel() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get detectionFails => $_getBF(7);
  @$pb.TagNumber(8)
  set detectionFails($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDetectionFails() => $_has(7);
  @$pb.TagNumber(8)
  void clearDetectionFails() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get belowIsFailure => $_getBF(8);
  @$pb.TagNumber(9)
  set belowIsFailure($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBelowIsFailure() => $_has(8);
  @$pb.TagNumber(9)
  void clearBelowIsFailure() => $_clearField(9);
}

class DraftLimitResponse extends $pb.GeneratedMessage {
  factory DraftLimitResponse({
    EnvironmentalLimit? limit,
  }) {
    final result = create();
    if (limit != null) result.limit = limit;
    return result;
  }

  DraftLimitResponse._();

  factory DraftLimitResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DraftLimitResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DraftLimitResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<EnvironmentalLimit>(1, _omitFieldNames ? '' : 'limit',
        subBuilder: EnvironmentalLimit.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftLimitResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftLimitResponse copyWith(void Function(DraftLimitResponse) updates) =>
      super.copyWith((message) => updates(message as DraftLimitResponse))
          as DraftLimitResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DraftLimitResponse create() => DraftLimitResponse._();
  @$core.override
  DraftLimitResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DraftLimitResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DraftLimitResponse>(create);
  static DraftLimitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EnvironmentalLimit get limit => $_getN(0);
  @$pb.TagNumber(1)
  set limit(EnvironmentalLimit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);
  @$pb.TagNumber(1)
  EnvironmentalLimit ensureLimit() => $_ensure(0);
}

class ApproveLimitRequest extends $pb.GeneratedMessage {
  factory ApproveLimitRequest({
    $core.String? limitId,
    $0.Timestamp? effectiveFrom,
  }) {
    final result = create();
    if (limitId != null) result.limitId = limitId;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    return result;
  }

  ApproveLimitRequest._();

  factory ApproveLimitRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveLimitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveLimitRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'limitId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveLimitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveLimitRequest copyWith(void Function(ApproveLimitRequest) updates) =>
      super.copyWith((message) => updates(message as ApproveLimitRequest))
          as ApproveLimitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveLimitRequest create() => ApproveLimitRequest._();
  @$core.override
  ApproveLimitRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveLimitRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveLimitRequest>(create);
  static ApproveLimitRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get limitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set limitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimitId() => $_clearField(1);

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

class ApproveLimitResponse extends $pb.GeneratedMessage {
  factory ApproveLimitResponse({
    EnvironmentalLimit? limit,
  }) {
    final result = create();
    if (limit != null) result.limit = limit;
    return result;
  }

  ApproveLimitResponse._();

  factory ApproveLimitResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveLimitResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveLimitResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<EnvironmentalLimit>(1, _omitFieldNames ? '' : 'limit',
        subBuilder: EnvironmentalLimit.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveLimitResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveLimitResponse copyWith(void Function(ApproveLimitResponse) updates) =>
      super.copyWith((message) => updates(message as ApproveLimitResponse))
          as ApproveLimitResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveLimitResponse create() => ApproveLimitResponse._();
  @$core.override
  ApproveLimitResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveLimitResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveLimitResponse>(create);
  static ApproveLimitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EnvironmentalLimit get limit => $_getN(0);
  @$pb.TagNumber(1)
  set limit(EnvironmentalLimit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);
  @$pb.TagNumber(1)
  EnvironmentalLimit ensureLimit() => $_ensure(0);
}

class AddSamplingPlanRequest extends $pb.GeneratedMessage {
  factory AddSamplingPlanRequest({
    $core.String? code,
    SampleKind? sampleKind,
    $core.String? facilityId,
    $core.String? locationId,
    $core.String? samplePoint,
    $core.int? everyDays,
    $0.Timestamp? startedAt,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (sampleKind != null) result.sampleKind = sampleKind;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (samplePoint != null) result.samplePoint = samplePoint;
    if (everyDays != null) result.everyDays = everyDays;
    if (startedAt != null) result.startedAt = startedAt;
    return result;
  }

  AddSamplingPlanRequest._();

  factory AddSamplingPlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddSamplingPlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddSamplingPlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aE<SampleKind>(2, _omitFieldNames ? '' : 'sampleKind',
        enumValues: SampleKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'locationId')
    ..aOS(5, _omitFieldNames ? '' : 'samplePoint')
    ..aI(6, _omitFieldNames ? '' : 'everyDays')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddSamplingPlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddSamplingPlanRequest copyWith(
          void Function(AddSamplingPlanRequest) updates) =>
      super.copyWith((message) => updates(message as AddSamplingPlanRequest))
          as AddSamplingPlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddSamplingPlanRequest create() => AddSamplingPlanRequest._();
  @$core.override
  AddSamplingPlanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddSamplingPlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddSamplingPlanRequest>(create);
  static AddSamplingPlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  SampleKind get sampleKind => $_getN(1);
  @$pb.TagNumber(2)
  set sampleKind(SampleKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSampleKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearSampleKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get locationId => $_getSZ(3);
  @$pb.TagNumber(4)
  set locationId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocationId() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocationId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get samplePoint => $_getSZ(4);
  @$pb.TagNumber(5)
  set samplePoint($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSamplePoint() => $_has(4);
  @$pb.TagNumber(5)
  void clearSamplePoint() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get everyDays => $_getIZ(5);
  @$pb.TagNumber(6)
  set everyDays($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEveryDays() => $_has(5);
  @$pb.TagNumber(6)
  void clearEveryDays() => $_clearField(6);

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
}

class AddSamplingPlanResponse extends $pb.GeneratedMessage {
  factory AddSamplingPlanResponse({
    SamplingPlan? plan,
  }) {
    final result = create();
    if (plan != null) result.plan = plan;
    return result;
  }

  AddSamplingPlanResponse._();

  factory AddSamplingPlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddSamplingPlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddSamplingPlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<SamplingPlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: SamplingPlan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddSamplingPlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddSamplingPlanResponse copyWith(
          void Function(AddSamplingPlanResponse) updates) =>
      super.copyWith((message) => updates(message as AddSamplingPlanResponse))
          as AddSamplingPlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddSamplingPlanResponse create() => AddSamplingPlanResponse._();
  @$core.override
  AddSamplingPlanResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddSamplingPlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddSamplingPlanResponse>(create);
  static AddSamplingPlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SamplingPlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(SamplingPlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  SamplingPlan ensurePlan() => $_ensure(0);
}

class CollectSampleRequest extends $pb.GeneratedMessage {
  factory CollectSampleRequest({
    $core.String? reference,
    SampleKind? sampleKind,
    $core.String? facilityId,
    $core.String? locationId,
    $core.String? samplePoint,
    $core.String? planId,
    $core.String? outbreakId,
    $core.String? repeatOfId,
    $0.Timestamp? collectedAt,
    $core.String? method,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    if (sampleKind != null) result.sampleKind = sampleKind;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (samplePoint != null) result.samplePoint = samplePoint;
    if (planId != null) result.planId = planId;
    if (outbreakId != null) result.outbreakId = outbreakId;
    if (repeatOfId != null) result.repeatOfId = repeatOfId;
    if (collectedAt != null) result.collectedAt = collectedAt;
    if (method != null) result.method = method;
    return result;
  }

  CollectSampleRequest._();

  factory CollectSampleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CollectSampleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CollectSampleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..aE<SampleKind>(2, _omitFieldNames ? '' : 'sampleKind',
        enumValues: SampleKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'locationId')
    ..aOS(5, _omitFieldNames ? '' : 'samplePoint')
    ..aOS(6, _omitFieldNames ? '' : 'planId')
    ..aOS(7, _omitFieldNames ? '' : 'outbreakId')
    ..aOS(8, _omitFieldNames ? '' : 'repeatOfId')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'collectedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'method')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectSampleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectSampleRequest copyWith(void Function(CollectSampleRequest) updates) =>
      super.copyWith((message) => updates(message as CollectSampleRequest))
          as CollectSampleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CollectSampleRequest create() => CollectSampleRequest._();
  @$core.override
  CollectSampleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CollectSampleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CollectSampleRequest>(create);
  static CollectSampleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reference => $_getSZ(0);
  @$pb.TagNumber(1)
  set reference($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReference() => $_has(0);
  @$pb.TagNumber(1)
  void clearReference() => $_clearField(1);

  @$pb.TagNumber(2)
  SampleKind get sampleKind => $_getN(1);
  @$pb.TagNumber(2)
  set sampleKind(SampleKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSampleKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearSampleKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get locationId => $_getSZ(3);
  @$pb.TagNumber(4)
  set locationId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocationId() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocationId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get samplePoint => $_getSZ(4);
  @$pb.TagNumber(5)
  set samplePoint($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSamplePoint() => $_has(4);
  @$pb.TagNumber(5)
  void clearSamplePoint() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get planId => $_getSZ(5);
  @$pb.TagNumber(6)
  set planId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPlanId() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlanId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get outbreakId => $_getSZ(6);
  @$pb.TagNumber(7)
  set outbreakId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOutbreakId() => $_has(6);
  @$pb.TagNumber(7)
  void clearOutbreakId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get repeatOfId => $_getSZ(7);
  @$pb.TagNumber(8)
  set repeatOfId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRepeatOfId() => $_has(7);
  @$pb.TagNumber(8)
  void clearRepeatOfId() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get collectedAt => $_getN(8);
  @$pb.TagNumber(9)
  set collectedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCollectedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCollectedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureCollectedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get method => $_getSZ(9);
  @$pb.TagNumber(10)
  set method($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMethod() => $_has(9);
  @$pb.TagNumber(10)
  void clearMethod() => $_clearField(10);
}

class CollectSampleResponse extends $pb.GeneratedMessage {
  factory CollectSampleResponse({
    EnvironmentalSample? sample,
  }) {
    final result = create();
    if (sample != null) result.sample = sample;
    return result;
  }

  CollectSampleResponse._();

  factory CollectSampleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CollectSampleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CollectSampleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<EnvironmentalSample>(1, _omitFieldNames ? '' : 'sample',
        subBuilder: EnvironmentalSample.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectSampleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectSampleResponse copyWith(
          void Function(CollectSampleResponse) updates) =>
      super.copyWith((message) => updates(message as CollectSampleResponse))
          as CollectSampleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CollectSampleResponse create() => CollectSampleResponse._();
  @$core.override
  CollectSampleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CollectSampleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CollectSampleResponse>(create);
  static CollectSampleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EnvironmentalSample get sample => $_getN(0);
  @$pb.TagNumber(1)
  set sample(EnvironmentalSample value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSample() => $_has(0);
  @$pb.TagNumber(1)
  void clearSample() => $_clearField(1);
  @$pb.TagNumber(1)
  EnvironmentalSample ensureSample() => $_ensure(0);
}

class RecordSampleResultRequest extends $pb.GeneratedMessage {
  factory RecordSampleResultRequest({
    $core.String? sampleId,
    $core.String? labReference,
    $fixnum.Int64? value,
    $core.String? unit,
    $core.String? organism,
    $core.bool? detected,
    $0.Timestamp? resultedAt,
  }) {
    final result = create();
    if (sampleId != null) result.sampleId = sampleId;
    if (labReference != null) result.labReference = labReference;
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (organism != null) result.organism = organism;
    if (detected != null) result.detected = detected;
    if (resultedAt != null) result.resultedAt = resultedAt;
    return result;
  }

  RecordSampleResultRequest._();

  factory RecordSampleResultRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordSampleResultRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordSampleResultRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sampleId')
    ..aOS(2, _omitFieldNames ? '' : 'labReference')
    ..aInt64(3, _omitFieldNames ? '' : 'value')
    ..aOS(4, _omitFieldNames ? '' : 'unit')
    ..aOS(5, _omitFieldNames ? '' : 'organism')
    ..aOB(6, _omitFieldNames ? '' : 'detected')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'resultedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordSampleResultRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordSampleResultRequest copyWith(
          void Function(RecordSampleResultRequest) updates) =>
      super.copyWith((message) => updates(message as RecordSampleResultRequest))
          as RecordSampleResultRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordSampleResultRequest create() => RecordSampleResultRequest._();
  @$core.override
  RecordSampleResultRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordSampleResultRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordSampleResultRequest>(create);
  static RecordSampleResultRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sampleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sampleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get labReference => $_getSZ(1);
  @$pb.TagNumber(2)
  set labReference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabReference() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get value => $_getI64(2);
  @$pb.TagNumber(3)
  set value($fixnum.Int64 value) => $_setInt64(2, value);
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
  $core.String get organism => $_getSZ(4);
  @$pb.TagNumber(5)
  set organism($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOrganism() => $_has(4);
  @$pb.TagNumber(5)
  void clearOrganism() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get detected => $_getBF(5);
  @$pb.TagNumber(6)
  set detected($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDetected() => $_has(5);
  @$pb.TagNumber(6)
  void clearDetected() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get resultedAt => $_getN(6);
  @$pb.TagNumber(7)
  set resultedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasResultedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearResultedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureResultedAt() => $_ensure(6);
}

class RecordSampleResultResponse extends $pb.GeneratedMessage {
  factory RecordSampleResultResponse({
    EnvironmentalSample? sample,
  }) {
    final result = create();
    if (sample != null) result.sample = sample;
    return result;
  }

  RecordSampleResultResponse._();

  factory RecordSampleResultResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordSampleResultResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordSampleResultResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<EnvironmentalSample>(1, _omitFieldNames ? '' : 'sample',
        subBuilder: EnvironmentalSample.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordSampleResultResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordSampleResultResponse copyWith(
          void Function(RecordSampleResultResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RecordSampleResultResponse))
          as RecordSampleResultResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordSampleResultResponse create() => RecordSampleResultResponse._();
  @$core.override
  RecordSampleResultResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordSampleResultResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordSampleResultResponse>(create);
  static RecordSampleResultResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EnvironmentalSample get sample => $_getN(0);
  @$pb.TagNumber(1)
  set sample(EnvironmentalSample value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSample() => $_has(0);
  @$pb.TagNumber(1)
  void clearSample() => $_clearField(1);
  @$pb.TagNumber(1)
  EnvironmentalSample ensureSample() => $_ensure(0);
}

class RaiseCorrectiveActionRequest extends $pb.GeneratedMessage {
  factory RaiseCorrectiveActionRequest({
    $core.String? sampleId,
    $core.String? action,
    $core.String? owner,
    $0.Timestamp? dueBy,
  }) {
    final result = create();
    if (sampleId != null) result.sampleId = sampleId;
    if (action != null) result.action = action;
    if (owner != null) result.owner = owner;
    if (dueBy != null) result.dueBy = dueBy;
    return result;
  }

  RaiseCorrectiveActionRequest._();

  factory RaiseCorrectiveActionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseCorrectiveActionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseCorrectiveActionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sampleId')
    ..aOS(2, _omitFieldNames ? '' : 'action')
    ..aOS(3, _omitFieldNames ? '' : 'owner')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'dueBy',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseCorrectiveActionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseCorrectiveActionRequest copyWith(
          void Function(RaiseCorrectiveActionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RaiseCorrectiveActionRequest))
          as RaiseCorrectiveActionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseCorrectiveActionRequest create() =>
      RaiseCorrectiveActionRequest._();
  @$core.override
  RaiseCorrectiveActionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseCorrectiveActionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseCorrectiveActionRequest>(create);
  static RaiseCorrectiveActionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sampleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sampleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get action => $_getSZ(1);
  @$pb.TagNumber(2)
  set action($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get owner => $_getSZ(2);
  @$pb.TagNumber(3)
  set owner($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOwner() => $_has(2);
  @$pb.TagNumber(3)
  void clearOwner() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get dueBy => $_getN(3);
  @$pb.TagNumber(4)
  set dueBy($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDueBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearDueBy() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureDueBy() => $_ensure(3);
}

class RaiseCorrectiveActionResponse extends $pb.GeneratedMessage {
  factory RaiseCorrectiveActionResponse({
    CorrectiveAction? action,
  }) {
    final result = create();
    if (action != null) result.action = action;
    return result;
  }

  RaiseCorrectiveActionResponse._();

  factory RaiseCorrectiveActionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseCorrectiveActionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseCorrectiveActionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<CorrectiveAction>(1, _omitFieldNames ? '' : 'action',
        subBuilder: CorrectiveAction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseCorrectiveActionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseCorrectiveActionResponse copyWith(
          void Function(RaiseCorrectiveActionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RaiseCorrectiveActionResponse))
          as RaiseCorrectiveActionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseCorrectiveActionResponse create() =>
      RaiseCorrectiveActionResponse._();
  @$core.override
  RaiseCorrectiveActionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseCorrectiveActionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseCorrectiveActionResponse>(create);
  static RaiseCorrectiveActionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CorrectiveAction get action => $_getN(0);
  @$pb.TagNumber(1)
  set action(CorrectiveAction value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAction() => $_has(0);
  @$pb.TagNumber(1)
  void clearAction() => $_clearField(1);
  @$pb.TagNumber(1)
  CorrectiveAction ensureAction() => $_ensure(0);
}

class CompleteCorrectiveActionRequest extends $pb.GeneratedMessage {
  factory CompleteCorrectiveActionRequest({
    $core.String? actionId,
    $core.String? note,
  }) {
    final result = create();
    if (actionId != null) result.actionId = actionId;
    if (note != null) result.note = note;
    return result;
  }

  CompleteCorrectiveActionRequest._();

  factory CompleteCorrectiveActionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteCorrectiveActionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteCorrectiveActionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'actionId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteCorrectiveActionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteCorrectiveActionRequest copyWith(
          void Function(CompleteCorrectiveActionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CompleteCorrectiveActionRequest))
          as CompleteCorrectiveActionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteCorrectiveActionRequest create() =>
      CompleteCorrectiveActionRequest._();
  @$core.override
  CompleteCorrectiveActionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteCorrectiveActionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteCorrectiveActionRequest>(
          create);
  static CompleteCorrectiveActionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get actionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set actionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearActionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);
}

class CompleteCorrectiveActionResponse extends $pb.GeneratedMessage {
  factory CompleteCorrectiveActionResponse({
    CorrectiveAction? action,
  }) {
    final result = create();
    if (action != null) result.action = action;
    return result;
  }

  CompleteCorrectiveActionResponse._();

  factory CompleteCorrectiveActionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteCorrectiveActionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteCorrectiveActionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<CorrectiveAction>(1, _omitFieldNames ? '' : 'action',
        subBuilder: CorrectiveAction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteCorrectiveActionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteCorrectiveActionResponse copyWith(
          void Function(CompleteCorrectiveActionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CompleteCorrectiveActionResponse))
          as CompleteCorrectiveActionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteCorrectiveActionResponse create() =>
      CompleteCorrectiveActionResponse._();
  @$core.override
  CompleteCorrectiveActionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteCorrectiveActionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteCorrectiveActionResponse>(
          create);
  static CompleteCorrectiveActionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CorrectiveAction get action => $_getN(0);
  @$pb.TagNumber(1)
  set action(CorrectiveAction value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAction() => $_has(0);
  @$pb.TagNumber(1)
  void clearAction() => $_clearField(1);
  @$pb.TagNumber(1)
  CorrectiveAction ensureAction() => $_ensure(0);
}

class VerifyCorrectiveActionRequest extends $pb.GeneratedMessage {
  factory VerifyCorrectiveActionRequest({
    $core.String? actionId,
    $core.String? repeatSampleId,
  }) {
    final result = create();
    if (actionId != null) result.actionId = actionId;
    if (repeatSampleId != null) result.repeatSampleId = repeatSampleId;
    return result;
  }

  VerifyCorrectiveActionRequest._();

  factory VerifyCorrectiveActionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyCorrectiveActionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyCorrectiveActionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'actionId')
    ..aOS(2, _omitFieldNames ? '' : 'repeatSampleId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyCorrectiveActionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyCorrectiveActionRequest copyWith(
          void Function(VerifyCorrectiveActionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as VerifyCorrectiveActionRequest))
          as VerifyCorrectiveActionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyCorrectiveActionRequest create() =>
      VerifyCorrectiveActionRequest._();
  @$core.override
  VerifyCorrectiveActionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyCorrectiveActionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyCorrectiveActionRequest>(create);
  static VerifyCorrectiveActionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get actionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set actionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearActionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get repeatSampleId => $_getSZ(1);
  @$pb.TagNumber(2)
  set repeatSampleId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRepeatSampleId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRepeatSampleId() => $_clearField(2);
}

class VerifyCorrectiveActionResponse extends $pb.GeneratedMessage {
  factory VerifyCorrectiveActionResponse({
    CorrectiveAction? action,
  }) {
    final result = create();
    if (action != null) result.action = action;
    return result;
  }

  VerifyCorrectiveActionResponse._();

  factory VerifyCorrectiveActionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyCorrectiveActionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyCorrectiveActionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<CorrectiveAction>(1, _omitFieldNames ? '' : 'action',
        subBuilder: CorrectiveAction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyCorrectiveActionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyCorrectiveActionResponse copyWith(
          void Function(VerifyCorrectiveActionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as VerifyCorrectiveActionResponse))
          as VerifyCorrectiveActionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyCorrectiveActionResponse create() =>
      VerifyCorrectiveActionResponse._();
  @$core.override
  VerifyCorrectiveActionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyCorrectiveActionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyCorrectiveActionResponse>(create);
  static VerifyCorrectiveActionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CorrectiveAction get action => $_getN(0);
  @$pb.TagNumber(1)
  set action(CorrectiveAction value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAction() => $_has(0);
  @$pb.TagNumber(1)
  void clearAction() => $_clearField(1);
  @$pb.TagNumber(1)
  CorrectiveAction ensureAction() => $_ensure(0);
}

class CloseSampleRequest extends $pb.GeneratedMessage {
  factory CloseSampleRequest({
    $core.String? sampleId,
  }) {
    final result = create();
    if (sampleId != null) result.sampleId = sampleId;
    return result;
  }

  CloseSampleRequest._();

  factory CloseSampleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseSampleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseSampleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sampleId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseSampleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseSampleRequest copyWith(void Function(CloseSampleRequest) updates) =>
      super.copyWith((message) => updates(message as CloseSampleRequest))
          as CloseSampleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseSampleRequest create() => CloseSampleRequest._();
  @$core.override
  CloseSampleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseSampleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseSampleRequest>(create);
  static CloseSampleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sampleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sampleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleId() => $_clearField(1);
}

class CloseSampleResponse extends $pb.GeneratedMessage {
  factory CloseSampleResponse({
    EnvironmentalSample? sample,
  }) {
    final result = create();
    if (sample != null) result.sample = sample;
    return result;
  }

  CloseSampleResponse._();

  factory CloseSampleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseSampleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseSampleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<EnvironmentalSample>(1, _omitFieldNames ? '' : 'sample',
        subBuilder: EnvironmentalSample.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseSampleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseSampleResponse copyWith(void Function(CloseSampleResponse) updates) =>
      super.copyWith((message) => updates(message as CloseSampleResponse))
          as CloseSampleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseSampleResponse create() => CloseSampleResponse._();
  @$core.override
  CloseSampleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseSampleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseSampleResponse>(create);
  static CloseSampleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EnvironmentalSample get sample => $_getN(0);
  @$pb.TagNumber(1)
  set sample(EnvironmentalSample value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSample() => $_has(0);
  @$pb.TagNumber(1)
  void clearSample() => $_clearField(1);
  @$pb.TagNumber(1)
  EnvironmentalSample ensureSample() => $_ensure(0);
}

class ListDueSamplingRequest extends $pb.GeneratedMessage {
  factory ListDueSamplingRequest({
    $core.String? locationId,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    return result;
  }

  ListDueSamplingRequest._();

  factory ListDueSamplingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDueSamplingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDueSamplingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueSamplingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueSamplingRequest copyWith(
          void Function(ListDueSamplingRequest) updates) =>
      super.copyWith((message) => updates(message as ListDueSamplingRequest))
          as ListDueSamplingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDueSamplingRequest create() => ListDueSamplingRequest._();
  @$core.override
  ListDueSamplingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDueSamplingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDueSamplingRequest>(create);
  static ListDueSamplingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);
}

class ListDueSamplingResponse extends $pb.GeneratedMessage {
  factory ListDueSamplingResponse({
    $core.Iterable<DuePoint>? points,
  }) {
    final result = create();
    if (points != null) result.points.addAll(points);
    return result;
  }

  ListDueSamplingResponse._();

  factory ListDueSamplingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDueSamplingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDueSamplingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..pPM<DuePoint>(1, _omitFieldNames ? '' : 'points',
        subBuilder: DuePoint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueSamplingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueSamplingResponse copyWith(
          void Function(ListDueSamplingResponse) updates) =>
      super.copyWith((message) => updates(message as ListDueSamplingResponse))
          as ListDueSamplingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDueSamplingResponse create() => ListDueSamplingResponse._();
  @$core.override
  ListDueSamplingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDueSamplingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDueSamplingResponse>(create);
  static ListDueSamplingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DuePoint> get points => $_getList(0);
}

class ListSamplesRequest extends $pb.GeneratedMessage {
  factory ListSamplesRequest({
    $core.String? locationId,
    SampleKind? sampleKind,
    $core.bool? failingOnly,
    $0.Timestamp? collectedFrom,
    $0.Timestamp? collectedTo,
    $core.int? pageSize,
    $core.int? pageOffset,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    if (sampleKind != null) result.sampleKind = sampleKind;
    if (failingOnly != null) result.failingOnly = failingOnly;
    if (collectedFrom != null) result.collectedFrom = collectedFrom;
    if (collectedTo != null) result.collectedTo = collectedTo;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageOffset != null) result.pageOffset = pageOffset;
    return result;
  }

  ListSamplesRequest._();

  factory ListSamplesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSamplesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSamplesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..aE<SampleKind>(2, _omitFieldNames ? '' : 'sampleKind',
        enumValues: SampleKind.values)
    ..aOB(3, _omitFieldNames ? '' : 'failingOnly')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'collectedFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'collectedTo',
        subBuilder: $0.Timestamp.create)
    ..aI(6, _omitFieldNames ? '' : 'pageSize')
    ..aI(7, _omitFieldNames ? '' : 'pageOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSamplesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSamplesRequest copyWith(void Function(ListSamplesRequest) updates) =>
      super.copyWith((message) => updates(message as ListSamplesRequest))
          as ListSamplesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSamplesRequest create() => ListSamplesRequest._();
  @$core.override
  ListSamplesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSamplesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSamplesRequest>(create);
  static ListSamplesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

  @$pb.TagNumber(2)
  SampleKind get sampleKind => $_getN(1);
  @$pb.TagNumber(2)
  set sampleKind(SampleKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSampleKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearSampleKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get failingOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set failingOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFailingOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailingOnly() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get collectedFrom => $_getN(3);
  @$pb.TagNumber(4)
  set collectedFrom($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCollectedFrom() => $_has(3);
  @$pb.TagNumber(4)
  void clearCollectedFrom() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureCollectedFrom() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get collectedTo => $_getN(4);
  @$pb.TagNumber(5)
  set collectedTo($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCollectedTo() => $_has(4);
  @$pb.TagNumber(5)
  void clearCollectedTo() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureCollectedTo() => $_ensure(4);

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

class ListSamplesResponse extends $pb.GeneratedMessage {
  factory ListSamplesResponse({
    $core.Iterable<EnvironmentalSample>? samples,
  }) {
    final result = create();
    if (samples != null) result.samples.addAll(samples);
    return result;
  }

  ListSamplesResponse._();

  factory ListSamplesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSamplesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSamplesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..pPM<EnvironmentalSample>(1, _omitFieldNames ? '' : 'samples',
        subBuilder: EnvironmentalSample.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSamplesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSamplesResponse copyWith(void Function(ListSamplesResponse) updates) =>
      super.copyWith((message) => updates(message as ListSamplesResponse))
          as ListSamplesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSamplesResponse create() => ListSamplesResponse._();
  @$core.override
  ListSamplesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSamplesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSamplesResponse>(create);
  static ListSamplesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<EnvironmentalSample> get samples => $_getList(0);
}

class ListCorrectiveActionsRequest extends $pb.GeneratedMessage {
  factory ListCorrectiveActionsRequest({
    $core.String? sampleId,
    $core.bool? openOnly,
  }) {
    final result = create();
    if (sampleId != null) result.sampleId = sampleId;
    if (openOnly != null) result.openOnly = openOnly;
    return result;
  }

  ListCorrectiveActionsRequest._();

  factory ListCorrectiveActionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCorrectiveActionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCorrectiveActionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sampleId')
    ..aOB(2, _omitFieldNames ? '' : 'openOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCorrectiveActionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCorrectiveActionsRequest copyWith(
          void Function(ListCorrectiveActionsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListCorrectiveActionsRequest))
          as ListCorrectiveActionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCorrectiveActionsRequest create() =>
      ListCorrectiveActionsRequest._();
  @$core.override
  ListCorrectiveActionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCorrectiveActionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCorrectiveActionsRequest>(create);
  static ListCorrectiveActionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sampleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sampleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get openOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set openOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpenOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpenOnly() => $_clearField(2);
}

class ListCorrectiveActionsResponse extends $pb.GeneratedMessage {
  factory ListCorrectiveActionsResponse({
    $core.Iterable<CorrectiveAction>? actions,
  }) {
    final result = create();
    if (actions != null) result.actions.addAll(actions);
    return result;
  }

  ListCorrectiveActionsResponse._();

  factory ListCorrectiveActionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCorrectiveActionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCorrectiveActionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..pPM<CorrectiveAction>(1, _omitFieldNames ? '' : 'actions',
        subBuilder: CorrectiveAction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCorrectiveActionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCorrectiveActionsResponse copyWith(
          void Function(ListCorrectiveActionsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListCorrectiveActionsResponse))
          as ListCorrectiveActionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCorrectiveActionsResponse create() =>
      ListCorrectiveActionsResponse._();
  @$core.override
  ListCorrectiveActionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCorrectiveActionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCorrectiveActionsResponse>(create);
  static ListCorrectiveActionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CorrectiveAction> get actions => $_getList(0);
}

class GetEnvironmentSummaryRequest extends $pb.GeneratedMessage {
  factory GetEnvironmentSummaryRequest({
    $core.String? locationId,
    $0.Timestamp? periodFrom,
    $0.Timestamp? periodTo,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    if (periodFrom != null) result.periodFrom = periodFrom;
    if (periodTo != null) result.periodTo = periodTo;
    return result;
  }

  GetEnvironmentSummaryRequest._();

  factory GetEnvironmentSummaryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetEnvironmentSummaryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetEnvironmentSummaryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'periodFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'periodTo',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEnvironmentSummaryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEnvironmentSummaryRequest copyWith(
          void Function(GetEnvironmentSummaryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetEnvironmentSummaryRequest))
          as GetEnvironmentSummaryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetEnvironmentSummaryRequest create() =>
      GetEnvironmentSummaryRequest._();
  @$core.override
  GetEnvironmentSummaryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetEnvironmentSummaryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetEnvironmentSummaryRequest>(create);
  static GetEnvironmentSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get periodFrom => $_getN(1);
  @$pb.TagNumber(2)
  set periodFrom($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriodFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriodFrom() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensurePeriodFrom() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get periodTo => $_getN(2);
  @$pb.TagNumber(3)
  set periodTo($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPeriodTo() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriodTo() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensurePeriodTo() => $_ensure(2);
}

class GetEnvironmentSummaryResponse extends $pb.GeneratedMessage {
  factory GetEnvironmentSummaryResponse({
    EnvironmentSummary? summary,
  }) {
    final result = create();
    if (summary != null) result.summary = summary;
    return result;
  }

  GetEnvironmentSummaryResponse._();

  factory GetEnvironmentSummaryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetEnvironmentSummaryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetEnvironmentSummaryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.infection.v1'),
      createEmptyInstance: create)
    ..aOM<EnvironmentSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: EnvironmentSummary.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEnvironmentSummaryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEnvironmentSummaryResponse copyWith(
          void Function(GetEnvironmentSummaryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetEnvironmentSummaryResponse))
          as GetEnvironmentSummaryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetEnvironmentSummaryResponse create() =>
      GetEnvironmentSummaryResponse._();
  @$core.override
  GetEnvironmentSummaryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetEnvironmentSummaryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetEnvironmentSummaryResponse>(create);
  static GetEnvironmentSummaryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EnvironmentSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(EnvironmentSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  EnvironmentSummary ensureSummary() => $_ensure(0);
}

class InfectionServiceApi {
  final $pb.RpcClient _client;

  InfectionServiceApi(this._client);

  /// Surveillance and rates (SRS-IPC-001, SRS-IPC-002, SRS-IPC-010).
  $async.Future<OpenCaseResponse> openCase(
          $pb.ClientContext? ctx, OpenCaseRequest request) =>
      _client.invoke<OpenCaseResponse>(
          ctx, 'InfectionService', 'OpenCase', request, OpenCaseResponse());
  $async.Future<ReviewCaseResponse> reviewCase(
          $pb.ClientContext? ctx, ReviewCaseRequest request) =>
      _client.invoke<ReviewCaseResponse>(
          ctx, 'InfectionService', 'ReviewCase', request, ReviewCaseResponse());
  $async.Future<OverrideOnsetResponse> overrideOnset(
          $pb.ClientContext? ctx, OverrideOnsetRequest request) =>
      _client.invoke<OverrideOnsetResponse>(ctx, 'InfectionService',
          'OverrideOnset', request, OverrideOnsetResponse());
  $async.Future<ListCasesResponse> listCases(
          $pb.ClientContext? ctx, ListCasesRequest request) =>
      _client.invoke<ListCasesResponse>(
          ctx, 'InfectionService', 'ListCases', request, ListCasesResponse());
  $async.Future<RecordDeviceDaysResponse> recordDeviceDays(
          $pb.ClientContext? ctx, RecordDeviceDaysRequest request) =>
      _client.invoke<RecordDeviceDaysResponse>(ctx, 'InfectionService',
          'RecordDeviceDays', request, RecordDeviceDaysResponse());
  $async.Future<GetRateResponse> getRate(
          $pb.ClientContext? ctx, GetRateRequest request) =>
      _client.invoke<GetRateResponse>(
          ctx, 'InfectionService', 'GetRate', request, GetRateResponse());

  /// Isolation and the bed board (SRS-IPC-003).
  $async.Future<StartIsolationResponse> startIsolation(
          $pb.ClientContext? ctx, StartIsolationRequest request) =>
      _client.invoke<StartIsolationResponse>(ctx, 'InfectionService',
          'StartIsolation', request, StartIsolationResponse());
  $async.Future<ExtendIsolationResponse> extendIsolation(
          $pb.ClientContext? ctx, ExtendIsolationRequest request) =>
      _client.invoke<ExtendIsolationResponse>(ctx, 'InfectionService',
          'ExtendIsolation', request, ExtendIsolationResponse());
  $async.Future<EndIsolationResponse> endIsolation(
          $pb.ClientContext? ctx, EndIsolationRequest request) =>
      _client.invoke<EndIsolationResponse>(ctx, 'InfectionService',
          'EndIsolation', request, EndIsolationResponse());
  $async.Future<GetBoardResponse> getBoard(
          $pb.ClientContext? ctx, GetBoardRequest request) =>
      _client.invoke<GetBoardResponse>(
          ctx, 'InfectionService', 'GetBoard', request, GetBoardResponse());

  /// Multidrug-resistant organism alerting (SRS-IPC-004).
  $async.Future<DraftAlertRuleResponse> draftAlertRule(
          $pb.ClientContext? ctx, DraftAlertRuleRequest request) =>
      _client.invoke<DraftAlertRuleResponse>(ctx, 'InfectionService',
          'DraftAlertRule', request, DraftAlertRuleResponse());
  $async.Future<ApproveAlertRuleResponse> approveAlertRule(
          $pb.ClientContext? ctx, ApproveAlertRuleRequest request) =>
      _client.invoke<ApproveAlertRuleResponse>(ctx, 'InfectionService',
          'ApproveAlertRule', request, ApproveAlertRuleResponse());
  $async.Future<ScreenEncounterResponse> screenEncounter(
          $pb.ClientContext? ctx, ScreenEncounterRequest request) =>
      _client.invoke<ScreenEncounterResponse>(ctx, 'InfectionService',
          'ScreenEncounter', request, ScreenEncounterResponse());
  $async.Future<AcknowledgeAlertResponse> acknowledgeAlert(
          $pb.ClientContext? ctx, AcknowledgeAlertRequest request) =>
      _client.invoke<AcknowledgeAlertResponse>(ctx, 'InfectionService',
          'AcknowledgeAlert', request, AcknowledgeAlertResponse());
  $async.Future<OverrideAlertResponse> overrideAlert(
          $pb.ClientContext? ctx, OverrideAlertRequest request) =>
      _client.invoke<OverrideAlertResponse>(ctx, 'InfectionService',
          'OverrideAlert', request, OverrideAlertResponse());
  $async.Future<ListAlertsResponse> listAlerts(
          $pb.ClientContext? ctx, ListAlertsRequest request) =>
      _client.invoke<ListAlertsResponse>(
          ctx, 'InfectionService', 'ListAlerts', request, ListAlertsResponse());

  /// Outbreak investigation (SRS-IPC-005).
  $async.Future<OpenOutbreakResponse> openOutbreak(
          $pb.ClientContext? ctx, OpenOutbreakRequest request) =>
      _client.invoke<OpenOutbreakResponse>(ctx, 'InfectionService',
          'OpenOutbreak', request, OpenOutbreakResponse());
  $async.Future<AdvanceOutbreakResponse> advanceOutbreak(
          $pb.ClientContext? ctx, AdvanceOutbreakRequest request) =>
      _client.invoke<AdvanceOutbreakResponse>(ctx, 'InfectionService',
          'AdvanceOutbreak', request, AdvanceOutbreakResponse());
  $async.Future<CloseOutbreakResponse> closeOutbreak(
          $pb.ClientContext? ctx, CloseOutbreakRequest request) =>
      _client.invoke<CloseOutbreakResponse>(ctx, 'InfectionService',
          'CloseOutbreak', request, CloseOutbreakResponse());
  $async.Future<AddOutbreakMemberResponse> addOutbreakMember(
          $pb.ClientContext? ctx, AddOutbreakMemberRequest request) =>
      _client.invoke<AddOutbreakMemberResponse>(ctx, 'InfectionService',
          'AddOutbreakMember', request, AddOutbreakMemberResponse());
  $async.Future<GetClusterResponse> getCluster(
          $pb.ClientContext? ctx, GetClusterRequest request) =>
      _client.invoke<GetClusterResponse>(
          ctx, 'InfectionService', 'GetCluster', request, GetClusterResponse());
  $async.Future<ListOutbreaksResponse> listOutbreaks(
          $pb.ClientContext? ctx, ListOutbreaksRequest request) =>
      _client.invoke<ListOutbreaksResponse>(ctx, 'InfectionService',
          'ListOutbreaks', request, ListOutbreaksResponse());

  /// Hand hygiene audit (SRS-IPC-006).
  $async.Future<StartHygieneSessionResponse> startHygieneSession(
          $pb.ClientContext? ctx, StartHygieneSessionRequest request) =>
      _client.invoke<StartHygieneSessionResponse>(ctx, 'InfectionService',
          'StartHygieneSession', request, StartHygieneSessionResponse());
  $async.Future<RecordObservationResponse> recordObservation(
          $pb.ClientContext? ctx, RecordObservationRequest request) =>
      _client.invoke<RecordObservationResponse>(ctx, 'InfectionService',
          'RecordObservation', request, RecordObservationResponse());
  $async.Future<EndHygieneSessionResponse> endHygieneSession(
          $pb.ClientContext? ctx, EndHygieneSessionRequest request) =>
      _client.invoke<EndHygieneSessionResponse>(ctx, 'InfectionService',
          'EndHygieneSession', request, EndHygieneSessionResponse());
  $async.Future<GetHygieneComplianceResponse> getHygieneCompliance(
          $pb.ClientContext? ctx, GetHygieneComplianceRequest request) =>
      _client.invoke<GetHygieneComplianceResponse>(ctx, 'InfectionService',
          'GetHygieneCompliance', request, GetHygieneComplianceResponse());

  /// Occupational exposure (SRS-IPC-007).
  $async.Future<ReportExposureResponse> reportExposure(
          $pb.ClientContext? ctx, ReportExposureRequest request) =>
      _client.invoke<ReportExposureResponse>(ctx, 'InfectionService',
          'ReportExposure', request, ReportExposureResponse());
  $async.Future<GetExposureResponse> getExposure(
          $pb.ClientContext? ctx, GetExposureRequest request) =>
      _client.invoke<GetExposureResponse>(ctx, 'InfectionService',
          'GetExposure', request, GetExposureResponse());
  $async.Future<CompleteExposureTaskResponse> completeExposureTask(
          $pb.ClientContext? ctx, CompleteExposureTaskRequest request) =>
      _client.invoke<CompleteExposureTaskResponse>(ctx, 'InfectionService',
          'CompleteExposureTask', request, CompleteExposureTaskResponse());
  $async.Future<CloseExposureResponse> closeExposure(
          $pb.ClientContext? ctx, CloseExposureRequest request) =>
      _client.invoke<CloseExposureResponse>(ctx, 'InfectionService',
          'CloseExposure', request, CloseExposureResponse());
  $async.Future<ListExposuresResponse> listExposures(
          $pb.ClientContext? ctx, ListExposuresRequest request) =>
      _client.invoke<ListExposuresResponse>(ctx, 'InfectionService',
          'ListExposures', request, ListExposuresResponse());
  $async.Future<SweepExposureTasksResponse> sweepExposureTasks(
          $pb.ClientContext? ctx, SweepExposureTasksRequest request) =>
      _client.invoke<SweepExposureTasksResponse>(ctx, 'InfectionService',
          'SweepExposureTasks', request, SweepExposureTasksResponse());

  /// Antimicrobial stewardship (SRS-IPC-008). Nothing here changes a
  /// prescription.
  $async.Future<DraftStewardshipRuleResponse> draftStewardshipRule(
          $pb.ClientContext? ctx, DraftStewardshipRuleRequest request) =>
      _client.invoke<DraftStewardshipRuleResponse>(ctx, 'InfectionService',
          'DraftStewardshipRule', request, DraftStewardshipRuleResponse());
  $async.Future<ApproveStewardshipRuleResponse> approveStewardshipRule(
          $pb.ClientContext? ctx, ApproveStewardshipRuleRequest request) =>
      _client.invoke<ApproveStewardshipRuleResponse>(ctx, 'InfectionService',
          'ApproveStewardshipRule', request, ApproveStewardshipRuleResponse());
  $async.Future<ReviewEncounterResponse> reviewEncounter(
          $pb.ClientContext? ctx, ReviewEncounterRequest request) =>
      _client.invoke<ReviewEncounterResponse>(ctx, 'InfectionService',
          'ReviewEncounter', request, ReviewEncounterResponse());
  $async.Future<AdviseReviewResponse> adviseReview(
          $pb.ClientContext? ctx, AdviseReviewRequest request) =>
      _client.invoke<AdviseReviewResponse>(ctx, 'InfectionService',
          'AdviseReview', request, AdviseReviewResponse());
  $async.Future<RespondToReviewResponse> respondToReview(
          $pb.ClientContext? ctx, RespondToReviewRequest request) =>
      _client.invoke<RespondToReviewResponse>(ctx, 'InfectionService',
          'RespondToReview', request, RespondToReviewResponse());
  $async.Future<WithdrawReviewResponse> withdrawReview(
          $pb.ClientContext? ctx, WithdrawReviewRequest request) =>
      _client.invoke<WithdrawReviewResponse>(ctx, 'InfectionService',
          'WithdrawReview', request, WithdrawReviewResponse());
  $async.Future<ListReviewsResponse> listReviews(
          $pb.ClientContext? ctx, ListReviewsRequest request) =>
      _client.invoke<ListReviewsResponse>(ctx, 'InfectionService',
          'ListReviews', request, ListReviewsResponse());
  $async.Future<GetStewardshipIndicatorsResponse> getStewardshipIndicators(
          $pb.ClientContext? ctx, GetStewardshipIndicatorsRequest request) =>
      _client.invoke<GetStewardshipIndicatorsResponse>(
          ctx,
          'InfectionService',
          'GetStewardshipIndicators',
          request,
          GetStewardshipIndicatorsResponse());

  /// Environmental surveillance (SRS-IPC-009).
  $async.Future<DraftLimitResponse> draftLimit(
          $pb.ClientContext? ctx, DraftLimitRequest request) =>
      _client.invoke<DraftLimitResponse>(
          ctx, 'InfectionService', 'DraftLimit', request, DraftLimitResponse());
  $async.Future<ApproveLimitResponse> approveLimit(
          $pb.ClientContext? ctx, ApproveLimitRequest request) =>
      _client.invoke<ApproveLimitResponse>(ctx, 'InfectionService',
          'ApproveLimit', request, ApproveLimitResponse());
  $async.Future<AddSamplingPlanResponse> addSamplingPlan(
          $pb.ClientContext? ctx, AddSamplingPlanRequest request) =>
      _client.invoke<AddSamplingPlanResponse>(ctx, 'InfectionService',
          'AddSamplingPlan', request, AddSamplingPlanResponse());
  $async.Future<CollectSampleResponse> collectSample(
          $pb.ClientContext? ctx, CollectSampleRequest request) =>
      _client.invoke<CollectSampleResponse>(ctx, 'InfectionService',
          'CollectSample', request, CollectSampleResponse());
  $async.Future<RecordSampleResultResponse> recordSampleResult(
          $pb.ClientContext? ctx, RecordSampleResultRequest request) =>
      _client.invoke<RecordSampleResultResponse>(ctx, 'InfectionService',
          'RecordSampleResult', request, RecordSampleResultResponse());
  $async.Future<RaiseCorrectiveActionResponse> raiseCorrectiveAction(
          $pb.ClientContext? ctx, RaiseCorrectiveActionRequest request) =>
      _client.invoke<RaiseCorrectiveActionResponse>(ctx, 'InfectionService',
          'RaiseCorrectiveAction', request, RaiseCorrectiveActionResponse());
  $async.Future<CompleteCorrectiveActionResponse> completeCorrectiveAction(
          $pb.ClientContext? ctx, CompleteCorrectiveActionRequest request) =>
      _client.invoke<CompleteCorrectiveActionResponse>(
          ctx,
          'InfectionService',
          'CompleteCorrectiveAction',
          request,
          CompleteCorrectiveActionResponse());
  $async.Future<VerifyCorrectiveActionResponse> verifyCorrectiveAction(
          $pb.ClientContext? ctx, VerifyCorrectiveActionRequest request) =>
      _client.invoke<VerifyCorrectiveActionResponse>(ctx, 'InfectionService',
          'VerifyCorrectiveAction', request, VerifyCorrectiveActionResponse());
  $async.Future<CloseSampleResponse> closeSample(
          $pb.ClientContext? ctx, CloseSampleRequest request) =>
      _client.invoke<CloseSampleResponse>(ctx, 'InfectionService',
          'CloseSample', request, CloseSampleResponse());
  $async.Future<ListDueSamplingResponse> listDueSampling(
          $pb.ClientContext? ctx, ListDueSamplingRequest request) =>
      _client.invoke<ListDueSamplingResponse>(ctx, 'InfectionService',
          'ListDueSampling', request, ListDueSamplingResponse());
  $async.Future<ListSamplesResponse> listSamples(
          $pb.ClientContext? ctx, ListSamplesRequest request) =>
      _client.invoke<ListSamplesResponse>(ctx, 'InfectionService',
          'ListSamples', request, ListSamplesResponse());
  $async.Future<ListCorrectiveActionsResponse> listCorrectiveActions(
          $pb.ClientContext? ctx, ListCorrectiveActionsRequest request) =>
      _client.invoke<ListCorrectiveActionsResponse>(ctx, 'InfectionService',
          'ListCorrectiveActions', request, ListCorrectiveActionsResponse());
  $async.Future<GetEnvironmentSummaryResponse> getEnvironmentSummary(
          $pb.ClientContext? ctx, GetEnvironmentSummaryRequest request) =>
      _client.invoke<GetEnvironmentSummaryResponse>(ctx, 'InfectionService',
          'GetEnvironmentSummary', request, GetEnvironmentSummaryResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
