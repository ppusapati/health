// This is a generated file - do not edit.
//
// Generated from healthcare/housekeeping/v1/housekeeping.proto.

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

import 'housekeeping.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'housekeeping.pbenum.dart';

/// One thing a clean has to include (SRS-HKP-002).
class ChecklistItem extends $pb.GeneratedMessage {
  factory ChecklistItem({
    $core.String? code,
    $core.String? label,
    $core.bool? required,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (label != null) result.label = label;
    if (required != null) result.required = required;
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
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOB(3, _omitFieldNames ? '' : 'required')
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

  /// An item a clean cannot be completed without an answer for. An optional
  /// item is one the hospital wants counted rather than insisted on.
  @$pb.TagNumber(3)
  $core.bool get required => $_getBF(2);
  @$pb.TagNumber(3)
  set required($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequired() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequired() => $_clearField(3);
}

/// One checklist item's outcome (SRS-HKP-004).
class ChecklistAnswer extends $pb.GeneratedMessage {
  factory ChecklistAnswer({
    $core.String? code,
    $core.bool? done,
    $core.String? exception,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (done != null) result.done = done;
    if (exception != null) result.exception = exception;
    return result;
  }

  ChecklistAnswer._();

  factory ChecklistAnswer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChecklistAnswer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChecklistAnswer',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOB(2, _omitFieldNames ? '' : 'done')
    ..aOS(3, _omitFieldNames ? '' : 'exception')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChecklistAnswer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChecklistAnswer copyWith(void Function(ChecklistAnswer) updates) =>
      super.copyWith((message) => updates(message as ChecklistAnswer))
          as ChecklistAnswer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChecklistAnswer create() => ChecklistAnswer._();
  @$core.override
  ChecklistAnswer createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChecklistAnswer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChecklistAnswer>(create);
  static ChecklistAnswer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get done => $_getBF(1);
  @$pb.TagNumber(2)
  set done($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDone() => $_has(1);
  @$pb.TagNumber(2)
  void clearDone() => $_clearField(2);

  /// Why an item was not done. Required when done is false: an unticked box
  /// with no note is indistinguishable from one nobody looked at.
  @$pb.TagNumber(3)
  $core.String get exception => $_getSZ(2);
  @$pb.TagNumber(3)
  set exception($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasException() => $_has(2);
  @$pb.TagNumber(3)
  void clearException() => $_clearField(3);
}

/// A place with a cleaning standard (SRS-HKP-001).
///
/// Versioned by (code, revision) and effective-dated, because a standard
/// edited in place would change what a clean completed last month was judged
/// against.
class CleanableLocation extends $pb.GeneratedMessage {
  factory CleanableLocation({
    $core.String? locationId,
    $core.String? code,
    $core.String? name,
    $core.int? revision,
    $core.String? facilityId,
    $core.String? zone,
    $core.String? bedId,
    RiskClass? riskClass,
    $core.int? routineEveryHours,
    $core.int? routineSlaMinutes,
    $core.int? terminalSlaMinutes,
    $core.Iterable<ChecklistItem>? checklist,
    $core.String? scanCode,
    $core.bool? approved,
    $core.String? approvedBy,
    $0.Timestamp? approvedAt,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? supersededAt,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (revision != null) result.revision = revision;
    if (facilityId != null) result.facilityId = facilityId;
    if (zone != null) result.zone = zone;
    if (bedId != null) result.bedId = bedId;
    if (riskClass != null) result.riskClass = riskClass;
    if (routineEveryHours != null) result.routineEveryHours = routineEveryHours;
    if (routineSlaMinutes != null) result.routineSlaMinutes = routineSlaMinutes;
    if (terminalSlaMinutes != null)
      result.terminalSlaMinutes = terminalSlaMinutes;
    if (checklist != null) result.checklist.addAll(checklist);
    if (scanCode != null) result.scanCode = scanCode;
    if (approved != null) result.approved = approved;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (supersededAt != null) result.supersededAt = supersededAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  CleanableLocation._();

  factory CleanableLocation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CleanableLocation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CleanableLocation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aI(4, _omitFieldNames ? '' : 'revision')
    ..aOS(5, _omitFieldNames ? '' : 'facilityId')
    ..aOS(6, _omitFieldNames ? '' : 'zone')
    ..aOS(7, _omitFieldNames ? '' : 'bedId')
    ..aE<RiskClass>(8, _omitFieldNames ? '' : 'riskClass',
        enumValues: RiskClass.values)
    ..aI(9, _omitFieldNames ? '' : 'routineEveryHours')
    ..aI(10, _omitFieldNames ? '' : 'routineSlaMinutes')
    ..aI(11, _omitFieldNames ? '' : 'terminalSlaMinutes')
    ..pPM<ChecklistItem>(12, _omitFieldNames ? '' : 'checklist',
        subBuilder: ChecklistItem.create)
    ..aOS(13, _omitFieldNames ? '' : 'scanCode')
    ..aOB(14, _omitFieldNames ? '' : 'approved')
    ..aOS(15, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'approvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'supersededAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(19, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(20, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(21, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CleanableLocation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CleanableLocation copyWith(void Function(CleanableLocation) updates) =>
      super.copyWith((message) => updates(message as CleanableLocation))
          as CleanableLocation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CleanableLocation create() => CleanableLocation._();
  @$core.override
  CleanableLocation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CleanableLocation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CleanableLocation>(create);
  static CleanableLocation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

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
  $core.String get facilityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set facilityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFacilityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearFacilityId() => $_clearField(5);

  /// The ward, theatre suite or floor the people who work here are organised
  /// by.
  @$pb.TagNumber(6)
  $core.String get zone => $_getSZ(5);
  @$pb.TagNumber(6)
  set zone($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasZone() => $_has(5);
  @$pb.TagNumber(6)
  void clearZone() => $_clearField(6);

  /// Set for a location that is a bed. It is what a terminal clean holds.
  @$pb.TagNumber(7)
  $core.String get bedId => $_getSZ(6);
  @$pb.TagNumber(7)
  set bedId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBedId() => $_has(6);
  @$pb.TagNumber(7)
  void clearBedId() => $_clearField(7);

  @$pb.TagNumber(8)
  RiskClass get riskClass => $_getN(7);
  @$pb.TagNumber(8)
  set riskClass(RiskClass value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRiskClass() => $_has(7);
  @$pb.TagNumber(8)
  void clearRiskClass() => $_clearField(8);

  /// Zero means no routine schedule — a store room cleaned when somebody asks
  /// — rather than a location overdue for ever.
  @$pb.TagNumber(9)
  $core.int get routineEveryHours => $_getIZ(8);
  @$pb.TagNumber(9)
  set routineEveryHours($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRoutineEveryHours() => $_has(8);
  @$pb.TagNumber(9)
  void clearRoutineEveryHours() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get routineSlaMinutes => $_getIZ(9);
  @$pb.TagNumber(10)
  set routineSlaMinutes($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRoutineSlaMinutes() => $_has(9);
  @$pb.TagNumber(10)
  void clearRoutineSlaMinutes() => $_clearField(10);

  /// Shorter than the routine SLA, because a bed is out of service until the
  /// terminal clean is done.
  @$pb.TagNumber(11)
  $core.int get terminalSlaMinutes => $_getIZ(10);
  @$pb.TagNumber(11)
  set terminalSlaMinutes($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTerminalSlaMinutes() => $_has(10);
  @$pb.TagNumber(11)
  void clearTerminalSlaMinutes() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<ChecklistItem> get checklist => $_getList(11);

  /// The code on the label at the door.
  @$pb.TagNumber(13)
  $core.String get scanCode => $_getSZ(12);
  @$pb.TagNumber(13)
  set scanCode($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasScanCode() => $_has(12);
  @$pb.TagNumber(13)
  void clearScanCode() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get approved => $_getBF(13);
  @$pb.TagNumber(14)
  set approved($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasApproved() => $_has(13);
  @$pb.TagNumber(14)
  void clearApproved() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get approvedBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set approvedBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasApprovedBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearApprovedBy() => $_clearField(15);

  @$pb.TagNumber(16)
  $0.Timestamp get approvedAt => $_getN(15);
  @$pb.TagNumber(16)
  set approvedAt($0.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasApprovedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearApprovedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureApprovedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $0.Timestamp get effectiveFrom => $_getN(16);
  @$pb.TagNumber(17)
  set effectiveFrom($0.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasEffectiveFrom() => $_has(16);
  @$pb.TagNumber(17)
  void clearEffectiveFrom() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(16);

  @$pb.TagNumber(18)
  $0.Timestamp get supersededAt => $_getN(17);
  @$pb.TagNumber(18)
  set supersededAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasSupersededAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearSupersededAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureSupersededAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $0.Timestamp get createdAt => $_getN(18);
  @$pb.TagNumber(19)
  set createdAt($0.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasCreatedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearCreatedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Timestamp ensureCreatedAt() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.String get createdBy => $_getSZ(19);
  @$pb.TagNumber(20)
  set createdBy($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasCreatedBy() => $_has(19);
  @$pb.TagNumber(20)
  void clearCreatedBy() => $_clearField(20);

  @$pb.TagNumber(21)
  $fixnum.Int64 get version => $_getI64(20);
  @$pb.TagNumber(21)
  set version($fixnum.Int64 value) => $_setInt64(20, value);
  @$pb.TagNumber(21)
  $core.bool hasVersion() => $_has(20);
  @$pb.TagNumber(21)
  void clearVersion() => $_clearField(21);
}

/// A code read at the door (SRS-HKP-007).
///
/// Evidence that somebody was in the room, attributed to the authenticated
/// person who scanned it. Never authority.
class LocationScan extends $pb.GeneratedMessage {
  factory LocationScan({
    $core.String? scannedCode,
    $core.bool? matched,
    $core.String? scannedBy,
    $0.Timestamp? scannedAt,
  }) {
    final result = create();
    if (scannedCode != null) result.scannedCode = scannedCode;
    if (matched != null) result.matched = matched;
    if (scannedBy != null) result.scannedBy = scannedBy;
    if (scannedAt != null) result.scannedAt = scannedAt;
    return result;
  }

  LocationScan._();

  factory LocationScan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LocationScan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LocationScan',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'scannedCode')
    ..aOB(2, _omitFieldNames ? '' : 'matched')
    ..aOS(3, _omitFieldNames ? '' : 'scannedBy')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'scannedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LocationScan clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LocationScan copyWith(void Function(LocationScan) updates) =>
      super.copyWith((message) => updates(message as LocationScan))
          as LocationScan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LocationScan create() => LocationScan._();
  @$core.override
  LocationScan createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LocationScan getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LocationScan>(create);
  static LocationScan? _defaultInstance;

  /// What came off the label, exactly as read.
  @$pb.TagNumber(1)
  $core.String get scannedCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set scannedCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScannedCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearScannedCode() => $_clearField(1);

  /// Whether the code agreed with the location's own. A mismatch is the
  /// finding.
  @$pb.TagNumber(2)
  $core.bool get matched => $_getBF(1);
  @$pb.TagNumber(2)
  set matched($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMatched() => $_has(1);
  @$pb.TagNumber(2)
  void clearMatched() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scannedBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set scannedBy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScannedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearScannedBy() => $_clearField(3);

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

/// One piece of cleaning work (SRS-HKP-002, SRS-HKP-004, SRS-HKP-006).
class CleaningTask extends $pb.GeneratedMessage {
  factory CleaningTask({
    $core.String? taskId,
    TaskKind? kind,
    $core.String? locationCode,
    $core.String? locationName,
    $core.String? facilityId,
    $core.String? zone,
    $core.String? bedId,
    RiskClass? riskClass,
    $core.int? locationRevision,
    $core.Iterable<ChecklistItem>? checklist,
    $core.String? scanCode,
    $core.bool? restricted,
    $core.String? incidentRef,
    $core.String? detail,
    $core.String? assigneeId,
    $0.Timestamp? dueBy,
    TaskState? state,
    $core.Iterable<ChecklistAnswer>? answers,
    $core.Iterable<LocationScan>? scans,
    $0.Timestamp? startedAt,
    $core.String? startedBy,
    $0.Timestamp? completedAt,
    $core.String? completedBy,
    $0.Timestamp? verifiedAt,
    $core.String? verifiedBy,
    $core.String? verifyNote,
    $core.String? cancelReason,
    $0.Timestamp? escalatedAt,
    $0.Timestamp? raisedAt,
    $core.String? raisedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (kind != null) result.kind = kind;
    if (locationCode != null) result.locationCode = locationCode;
    if (locationName != null) result.locationName = locationName;
    if (facilityId != null) result.facilityId = facilityId;
    if (zone != null) result.zone = zone;
    if (bedId != null) result.bedId = bedId;
    if (riskClass != null) result.riskClass = riskClass;
    if (locationRevision != null) result.locationRevision = locationRevision;
    if (checklist != null) result.checklist.addAll(checklist);
    if (scanCode != null) result.scanCode = scanCode;
    if (restricted != null) result.restricted = restricted;
    if (incidentRef != null) result.incidentRef = incidentRef;
    if (detail != null) result.detail = detail;
    if (assigneeId != null) result.assigneeId = assigneeId;
    if (dueBy != null) result.dueBy = dueBy;
    if (state != null) result.state = state;
    if (answers != null) result.answers.addAll(answers);
    if (scans != null) result.scans.addAll(scans);
    if (startedAt != null) result.startedAt = startedAt;
    if (startedBy != null) result.startedBy = startedBy;
    if (completedAt != null) result.completedAt = completedAt;
    if (completedBy != null) result.completedBy = completedBy;
    if (verifiedAt != null) result.verifiedAt = verifiedAt;
    if (verifiedBy != null) result.verifiedBy = verifiedBy;
    if (verifyNote != null) result.verifyNote = verifyNote;
    if (cancelReason != null) result.cancelReason = cancelReason;
    if (escalatedAt != null) result.escalatedAt = escalatedAt;
    if (raisedAt != null) result.raisedAt = raisedAt;
    if (raisedBy != null) result.raisedBy = raisedBy;
    if (version != null) result.version = version;
    return result;
  }

  CleaningTask._();

  factory CleaningTask.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CleaningTask.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CleaningTask',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aE<TaskKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: TaskKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'locationCode')
    ..aOS(4, _omitFieldNames ? '' : 'locationName')
    ..aOS(5, _omitFieldNames ? '' : 'facilityId')
    ..aOS(6, _omitFieldNames ? '' : 'zone')
    ..aOS(7, _omitFieldNames ? '' : 'bedId')
    ..aE<RiskClass>(8, _omitFieldNames ? '' : 'riskClass',
        enumValues: RiskClass.values)
    ..aI(9, _omitFieldNames ? '' : 'locationRevision')
    ..pPM<ChecklistItem>(10, _omitFieldNames ? '' : 'checklist',
        subBuilder: ChecklistItem.create)
    ..aOS(11, _omitFieldNames ? '' : 'scanCode')
    ..aOB(12, _omitFieldNames ? '' : 'restricted')
    ..aOS(13, _omitFieldNames ? '' : 'incidentRef')
    ..aOS(14, _omitFieldNames ? '' : 'detail')
    ..aOS(15, _omitFieldNames ? '' : 'assigneeId')
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'dueBy',
        subBuilder: $0.Timestamp.create)
    ..aE<TaskState>(17, _omitFieldNames ? '' : 'state',
        enumValues: TaskState.values)
    ..pPM<ChecklistAnswer>(18, _omitFieldNames ? '' : 'answers',
        subBuilder: ChecklistAnswer.create)
    ..pPM<LocationScan>(19, _omitFieldNames ? '' : 'scans',
        subBuilder: LocationScan.create)
    ..aOM<$0.Timestamp>(20, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(21, _omitFieldNames ? '' : 'startedBy')
    ..aOM<$0.Timestamp>(22, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(23, _omitFieldNames ? '' : 'completedBy')
    ..aOM<$0.Timestamp>(24, _omitFieldNames ? '' : 'verifiedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(25, _omitFieldNames ? '' : 'verifiedBy')
    ..aOS(26, _omitFieldNames ? '' : 'verifyNote')
    ..aOS(27, _omitFieldNames ? '' : 'cancelReason')
    ..aOM<$0.Timestamp>(28, _omitFieldNames ? '' : 'escalatedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(29, _omitFieldNames ? '' : 'raisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(30, _omitFieldNames ? '' : 'raisedBy')
    ..aInt64(31, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CleaningTask clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CleaningTask copyWith(void Function(CleaningTask) updates) =>
      super.copyWith((message) => updates(message as CleaningTask))
          as CleaningTask;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CleaningTask create() => CleaningTask._();
  @$core.override
  CleaningTask createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CleaningTask getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CleaningTask>(create);
  static CleaningTask? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);

  @$pb.TagNumber(2)
  TaskKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(TaskKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locationCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get locationName => $_getSZ(3);
  @$pb.TagNumber(4)
  set locationName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocationName() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocationName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get facilityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set facilityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFacilityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearFacilityId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get zone => $_getSZ(5);
  @$pb.TagNumber(6)
  set zone($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasZone() => $_has(5);
  @$pb.TagNumber(6)
  void clearZone() => $_clearField(6);

  /// Set for a terminal clean on a bed, and what the hold is against.
  @$pb.TagNumber(7)
  $core.String get bedId => $_getSZ(6);
  @$pb.TagNumber(7)
  set bedId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBedId() => $_has(6);
  @$pb.TagNumber(7)
  void clearBedId() => $_clearField(7);

  @$pb.TagNumber(8)
  RiskClass get riskClass => $_getN(7);
  @$pb.TagNumber(8)
  set riskClass(RiskClass value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRiskClass() => $_has(7);
  @$pb.TagNumber(8)
  void clearRiskClass() => $_clearField(8);

  /// The revision of the standard this task was raised under.
  @$pb.TagNumber(9)
  $core.int get locationRevision => $_getIZ(8);
  @$pb.TagNumber(9)
  set locationRevision($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLocationRevision() => $_has(8);
  @$pb.TagNumber(9)
  void clearLocationRevision() => $_clearField(9);

  /// The standard's items, copied at raise time.
  @$pb.TagNumber(10)
  $pb.PbList<ChecklistItem> get checklist => $_getList(9);

  @$pb.TagNumber(11)
  $core.String get scanCode => $_getSZ(10);
  @$pb.TagNumber(11)
  set scanCode($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasScanCode() => $_has(10);
  @$pb.TagNumber(11)
  void clearScanCode() => $_clearField(11);

  /// Whether this task's detail is held out of the general worklist. Set from
  /// the kind rather than chosen.
  @$pb.TagNumber(12)
  $core.bool get restricted => $_getBF(11);
  @$pb.TagNumber(12)
  set restricted($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRestricted() => $_has(11);
  @$pb.TagNumber(12)
  void clearRestricted() => $_clearField(12);

  /// The incident this spill belongs to, in the quality context. Cleared for a
  /// caller without hkp.spill.read.
  @$pb.TagNumber(13)
  $core.String get incidentRef => $_getSZ(12);
  @$pb.TagNumber(13)
  set incidentRef($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasIncidentRef() => $_has(12);
  @$pb.TagNumber(13)
  void clearIncidentRef() => $_clearField(13);

  /// What was spilled. Cleared for a caller without hkp.spill.read.
  @$pb.TagNumber(14)
  $core.String get detail => $_getSZ(13);
  @$pb.TagNumber(14)
  set detail($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasDetail() => $_has(13);
  @$pb.TagNumber(14)
  void clearDetail() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get assigneeId => $_getSZ(14);
  @$pb.TagNumber(15)
  set assigneeId($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasAssigneeId() => $_has(14);
  @$pb.TagNumber(15)
  void clearAssigneeId() => $_clearField(15);

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
  TaskState get state => $_getN(16);
  @$pb.TagNumber(17)
  set state(TaskState value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasState() => $_has(16);
  @$pb.TagNumber(17)
  void clearState() => $_clearField(17);

  @$pb.TagNumber(18)
  $pb.PbList<ChecklistAnswer> get answers => $_getList(17);

  @$pb.TagNumber(19)
  $pb.PbList<LocationScan> get scans => $_getList(18);

  @$pb.TagNumber(20)
  $0.Timestamp get startedAt => $_getN(19);
  @$pb.TagNumber(20)
  set startedAt($0.Timestamp value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasStartedAt() => $_has(19);
  @$pb.TagNumber(20)
  void clearStartedAt() => $_clearField(20);
  @$pb.TagNumber(20)
  $0.Timestamp ensureStartedAt() => $_ensure(19);

  @$pb.TagNumber(21)
  $core.String get startedBy => $_getSZ(20);
  @$pb.TagNumber(21)
  set startedBy($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasStartedBy() => $_has(20);
  @$pb.TagNumber(21)
  void clearStartedBy() => $_clearField(21);

  @$pb.TagNumber(22)
  $0.Timestamp get completedAt => $_getN(21);
  @$pb.TagNumber(22)
  set completedAt($0.Timestamp value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasCompletedAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearCompletedAt() => $_clearField(22);
  @$pb.TagNumber(22)
  $0.Timestamp ensureCompletedAt() => $_ensure(21);

  @$pb.TagNumber(23)
  $core.String get completedBy => $_getSZ(22);
  @$pb.TagNumber(23)
  set completedBy($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasCompletedBy() => $_has(22);
  @$pb.TagNumber(23)
  void clearCompletedBy() => $_clearField(23);

  @$pb.TagNumber(24)
  $0.Timestamp get verifiedAt => $_getN(23);
  @$pb.TagNumber(24)
  set verifiedAt($0.Timestamp value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasVerifiedAt() => $_has(23);
  @$pb.TagNumber(24)
  void clearVerifiedAt() => $_clearField(24);
  @$pb.TagNumber(24)
  $0.Timestamp ensureVerifiedAt() => $_ensure(23);

  /// Never the same person as completed_by.
  @$pb.TagNumber(25)
  $core.String get verifiedBy => $_getSZ(24);
  @$pb.TagNumber(25)
  set verifiedBy($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasVerifiedBy() => $_has(24);
  @$pb.TagNumber(25)
  void clearVerifiedBy() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.String get verifyNote => $_getSZ(25);
  @$pb.TagNumber(26)
  set verifyNote($core.String value) => $_setString(25, value);
  @$pb.TagNumber(26)
  $core.bool hasVerifyNote() => $_has(25);
  @$pb.TagNumber(26)
  void clearVerifyNote() => $_clearField(26);

  @$pb.TagNumber(27)
  $core.String get cancelReason => $_getSZ(26);
  @$pb.TagNumber(27)
  set cancelReason($core.String value) => $_setString(26, value);
  @$pb.TagNumber(27)
  $core.bool hasCancelReason() => $_has(26);
  @$pb.TagNumber(27)
  void clearCancelReason() => $_clearField(27);

  @$pb.TagNumber(28)
  $0.Timestamp get escalatedAt => $_getN(27);
  @$pb.TagNumber(28)
  set escalatedAt($0.Timestamp value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasEscalatedAt() => $_has(27);
  @$pb.TagNumber(28)
  void clearEscalatedAt() => $_clearField(28);
  @$pb.TagNumber(28)
  $0.Timestamp ensureEscalatedAt() => $_ensure(27);

  @$pb.TagNumber(29)
  $0.Timestamp get raisedAt => $_getN(28);
  @$pb.TagNumber(29)
  set raisedAt($0.Timestamp value) => $_setField(29, value);
  @$pb.TagNumber(29)
  $core.bool hasRaisedAt() => $_has(28);
  @$pb.TagNumber(29)
  void clearRaisedAt() => $_clearField(29);
  @$pb.TagNumber(29)
  $0.Timestamp ensureRaisedAt() => $_ensure(28);

  @$pb.TagNumber(30)
  $core.String get raisedBy => $_getSZ(29);
  @$pb.TagNumber(30)
  set raisedBy($core.String value) => $_setString(29, value);
  @$pb.TagNumber(30)
  $core.bool hasRaisedBy() => $_has(29);
  @$pb.TagNumber(30)
  void clearRaisedBy() => $_clearField(30);

  @$pb.TagNumber(31)
  $fixnum.Int64 get version => $_getI64(30);
  @$pb.TagNumber(31)
  set version($fixnum.Int64 value) => $_setInt64(30, value);
  @$pb.TagNumber(31)
  $core.bool hasVersion() => $_has(30);
  @$pb.TagNumber(31)
  void clearVersion() => $_clearField(31);
}

/// A bed kept out of service until it has been cleaned (SRS-HKP-003).
class BedHold extends $pb.GeneratedMessage {
  factory BedHold({
    $core.String? holdId,
    $core.String? bedId,
    $core.String? locationCode,
    $core.String? facilityId,
    $core.String? zone,
    $core.String? taskId,
    $core.String? encounterId,
    HoldState? state,
    $0.Timestamp? placedAt,
    $core.String? placedBy,
    $0.Timestamp? releasedAt,
    $core.String? releasedBy,
    $0.Timestamp? overriddenAt,
    $core.String? overriddenBy,
    $core.String? overrideReason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (holdId != null) result.holdId = holdId;
    if (bedId != null) result.bedId = bedId;
    if (locationCode != null) result.locationCode = locationCode;
    if (facilityId != null) result.facilityId = facilityId;
    if (zone != null) result.zone = zone;
    if (taskId != null) result.taskId = taskId;
    if (encounterId != null) result.encounterId = encounterId;
    if (state != null) result.state = state;
    if (placedAt != null) result.placedAt = placedAt;
    if (placedBy != null) result.placedBy = placedBy;
    if (releasedAt != null) result.releasedAt = releasedAt;
    if (releasedBy != null) result.releasedBy = releasedBy;
    if (overriddenAt != null) result.overriddenAt = overriddenAt;
    if (overriddenBy != null) result.overriddenBy = overriddenBy;
    if (overrideReason != null) result.overrideReason = overrideReason;
    if (version != null) result.version = version;
    return result;
  }

  BedHold._();

  factory BedHold.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BedHold.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BedHold',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'holdId')
    ..aOS(2, _omitFieldNames ? '' : 'bedId')
    ..aOS(3, _omitFieldNames ? '' : 'locationCode')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'zone')
    ..aOS(6, _omitFieldNames ? '' : 'taskId')
    ..aOS(7, _omitFieldNames ? '' : 'encounterId')
    ..aE<HoldState>(8, _omitFieldNames ? '' : 'state',
        enumValues: HoldState.values)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'placedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'placedBy')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'releasedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'releasedBy')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'overriddenAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(14, _omitFieldNames ? '' : 'overriddenBy')
    ..aOS(15, _omitFieldNames ? '' : 'overrideReason')
    ..aInt64(16, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BedHold clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BedHold copyWith(void Function(BedHold) updates) =>
      super.copyWith((message) => updates(message as BedHold)) as BedHold;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BedHold create() => BedHold._();
  @$core.override
  BedHold createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BedHold getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BedHold>(create);
  static BedHold? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get holdId => $_getSZ(0);
  @$pb.TagNumber(1)
  set holdId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHoldId() => $_has(0);
  @$pb.TagNumber(1)
  void clearHoldId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get bedId => $_getSZ(1);
  @$pb.TagNumber(2)
  set bedId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBedId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBedId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locationCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get zone => $_getSZ(4);
  @$pb.TagNumber(5)
  set zone($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasZone() => $_has(4);
  @$pb.TagNumber(5)
  void clearZone() => $_clearField(5);

  /// The terminal clean that must finish.
  @$pb.TagNumber(6)
  $core.String get taskId => $_getSZ(5);
  @$pb.TagNumber(6)
  set taskId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTaskId() => $_has(5);
  @$pb.TagNumber(6)
  void clearTaskId() => $_clearField(6);

  /// The encounter whose end raised it, where there was one.
  @$pb.TagNumber(7)
  $core.String get encounterId => $_getSZ(6);
  @$pb.TagNumber(7)
  set encounterId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEncounterId() => $_has(6);
  @$pb.TagNumber(7)
  void clearEncounterId() => $_clearField(7);

  @$pb.TagNumber(8)
  HoldState get state => $_getN(7);
  @$pb.TagNumber(8)
  set state(HoldState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasState() => $_has(7);
  @$pb.TagNumber(8)
  void clearState() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get placedAt => $_getN(8);
  @$pb.TagNumber(9)
  set placedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasPlacedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearPlacedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensurePlacedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get placedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set placedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPlacedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearPlacedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get releasedAt => $_getN(10);
  @$pb.TagNumber(11)
  set releasedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasReleasedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearReleasedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureReleasedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get releasedBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set releasedBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasReleasedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearReleasedBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get overriddenAt => $_getN(12);
  @$pb.TagNumber(13)
  set overriddenAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasOverriddenAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearOverriddenAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureOverriddenAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get overriddenBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set overriddenBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasOverriddenBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearOverriddenBy() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get overrideReason => $_getSZ(14);
  @$pb.TagNumber(15)
  set overrideReason($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasOverrideReason() => $_has(14);
  @$pb.TagNumber(15)
  void clearOverrideReason() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get version => $_getI64(15);
  @$pb.TagNumber(16)
  set version($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasVersion() => $_has(15);
  @$pb.TagNumber(16)
  void clearVersion() => $_clearField(16);
}

/// A location whose routine clean has fallen due (SRS-HKP-001).
class DueRoutineClean extends $pb.GeneratedMessage {
  factory DueRoutineClean({
    CleanableLocation? location,
    $0.Timestamp? lastCleanedAt,
    $0.Timestamp? dueSince,
    $core.bool? neverCleaned,
  }) {
    final result = create();
    if (location != null) result.location = location;
    if (lastCleanedAt != null) result.lastCleanedAt = lastCleanedAt;
    if (dueSince != null) result.dueSince = dueSince;
    if (neverCleaned != null) result.neverCleaned = neverCleaned;
    return result;
  }

  DueRoutineClean._();

  factory DueRoutineClean.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DueRoutineClean.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DueRoutineClean',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOM<CleanableLocation>(1, _omitFieldNames ? '' : 'location',
        subBuilder: CleanableLocation.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'lastCleanedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'dueSince',
        subBuilder: $0.Timestamp.create)
    ..aOB(4, _omitFieldNames ? '' : 'neverCleaned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DueRoutineClean clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DueRoutineClean copyWith(void Function(DueRoutineClean) updates) =>
      super.copyWith((message) => updates(message as DueRoutineClean))
          as DueRoutineClean;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DueRoutineClean create() => DueRoutineClean._();
  @$core.override
  DueRoutineClean createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DueRoutineClean getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DueRoutineClean>(create);
  static DueRoutineClean? _defaultInstance;

  @$pb.TagNumber(1)
  CleanableLocation get location => $_getN(0);
  @$pb.TagNumber(1)
  set location(CleanableLocation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLocation() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocation() => $_clearField(1);
  @$pb.TagNumber(1)
  CleanableLocation ensureLocation() => $_ensure(0);

  /// Zero for a location nobody has ever cleaned, which appears first rather
  /// than never: a room with no history is the one most likely to have been
  /// missed.
  @$pb.TagNumber(2)
  $0.Timestamp get lastCleanedAt => $_getN(1);
  @$pb.TagNumber(2)
  set lastCleanedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLastCleanedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastCleanedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureLastCleanedAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get dueSince => $_getN(2);
  @$pb.TagNumber(3)
  set dueSince($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDueSince() => $_has(2);
  @$pb.TagNumber(3)
  void clearDueSince() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureDueSince() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get neverCleaned => $_getBF(3);
  @$pb.TagNumber(4)
  set neverCleaned($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNeverCleaned() => $_has(3);
  @$pb.TagNumber(4)
  void clearNeverCleaned() => $_clearField(4);
}

class ConfigureLocationRequest extends $pb.GeneratedMessage {
  factory ConfigureLocationRequest({
    $core.String? code,
    $core.String? name,
    $core.String? facilityId,
    $core.String? zone,
    $core.String? bedId,
    RiskClass? riskClass,
    $core.int? routineEveryHours,
    $core.int? routineSlaMinutes,
    $core.int? terminalSlaMinutes,
    $core.Iterable<ChecklistItem>? checklist,
    $core.String? scanCode,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (facilityId != null) result.facilityId = facilityId;
    if (zone != null) result.zone = zone;
    if (bedId != null) result.bedId = bedId;
    if (riskClass != null) result.riskClass = riskClass;
    if (routineEveryHours != null) result.routineEveryHours = routineEveryHours;
    if (routineSlaMinutes != null) result.routineSlaMinutes = routineSlaMinutes;
    if (terminalSlaMinutes != null)
      result.terminalSlaMinutes = terminalSlaMinutes;
    if (checklist != null) result.checklist.addAll(checklist);
    if (scanCode != null) result.scanCode = scanCode;
    return result;
  }

  ConfigureLocationRequest._();

  factory ConfigureLocationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfigureLocationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfigureLocationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'zone')
    ..aOS(5, _omitFieldNames ? '' : 'bedId')
    ..aE<RiskClass>(6, _omitFieldNames ? '' : 'riskClass',
        enumValues: RiskClass.values)
    ..aI(7, _omitFieldNames ? '' : 'routineEveryHours')
    ..aI(8, _omitFieldNames ? '' : 'routineSlaMinutes')
    ..aI(9, _omitFieldNames ? '' : 'terminalSlaMinutes')
    ..pPM<ChecklistItem>(10, _omitFieldNames ? '' : 'checklist',
        subBuilder: ChecklistItem.create)
    ..aOS(11, _omitFieldNames ? '' : 'scanCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureLocationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureLocationRequest copyWith(
          void Function(ConfigureLocationRequest) updates) =>
      super.copyWith((message) => updates(message as ConfigureLocationRequest))
          as ConfigureLocationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigureLocationRequest create() => ConfigureLocationRequest._();
  @$core.override
  ConfigureLocationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfigureLocationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigureLocationRequest>(create);
  static ConfigureLocationRequest? _defaultInstance;

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
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get zone => $_getSZ(3);
  @$pb.TagNumber(4)
  set zone($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasZone() => $_has(3);
  @$pb.TagNumber(4)
  void clearZone() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get bedId => $_getSZ(4);
  @$pb.TagNumber(5)
  set bedId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBedId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBedId() => $_clearField(5);

  @$pb.TagNumber(6)
  RiskClass get riskClass => $_getN(5);
  @$pb.TagNumber(6)
  set riskClass(RiskClass value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRiskClass() => $_has(5);
  @$pb.TagNumber(6)
  void clearRiskClass() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get routineEveryHours => $_getIZ(6);
  @$pb.TagNumber(7)
  set routineEveryHours($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRoutineEveryHours() => $_has(6);
  @$pb.TagNumber(7)
  void clearRoutineEveryHours() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get routineSlaMinutes => $_getIZ(7);
  @$pb.TagNumber(8)
  set routineSlaMinutes($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRoutineSlaMinutes() => $_has(7);
  @$pb.TagNumber(8)
  void clearRoutineSlaMinutes() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get terminalSlaMinutes => $_getIZ(8);
  @$pb.TagNumber(9)
  set terminalSlaMinutes($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTerminalSlaMinutes() => $_has(8);
  @$pb.TagNumber(9)
  void clearTerminalSlaMinutes() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<ChecklistItem> get checklist => $_getList(9);

  @$pb.TagNumber(11)
  $core.String get scanCode => $_getSZ(10);
  @$pb.TagNumber(11)
  set scanCode($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasScanCode() => $_has(10);
  @$pb.TagNumber(11)
  void clearScanCode() => $_clearField(11);
}

class ConfigureLocationResponse extends $pb.GeneratedMessage {
  factory ConfigureLocationResponse({
    CleanableLocation? location,
  }) {
    final result = create();
    if (location != null) result.location = location;
    return result;
  }

  ConfigureLocationResponse._();

  factory ConfigureLocationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfigureLocationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfigureLocationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOM<CleanableLocation>(1, _omitFieldNames ? '' : 'location',
        subBuilder: CleanableLocation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureLocationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureLocationResponse copyWith(
          void Function(ConfigureLocationResponse) updates) =>
      super.copyWith((message) => updates(message as ConfigureLocationResponse))
          as ConfigureLocationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigureLocationResponse create() => ConfigureLocationResponse._();
  @$core.override
  ConfigureLocationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfigureLocationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigureLocationResponse>(create);
  static ConfigureLocationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CleanableLocation get location => $_getN(0);
  @$pb.TagNumber(1)
  set location(CleanableLocation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLocation() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocation() => $_clearField(1);
  @$pb.TagNumber(1)
  CleanableLocation ensureLocation() => $_ensure(0);
}

class ApproveLocationRequest extends $pb.GeneratedMessage {
  factory ApproveLocationRequest({
    $core.String? locationId,
    $0.Timestamp? effectiveFrom,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    return result;
  }

  ApproveLocationRequest._();

  factory ApproveLocationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveLocationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveLocationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveLocationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveLocationRequest copyWith(
          void Function(ApproveLocationRequest) updates) =>
      super.copyWith((message) => updates(message as ApproveLocationRequest))
          as ApproveLocationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveLocationRequest create() => ApproveLocationRequest._();
  @$core.override
  ApproveLocationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveLocationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveLocationRequest>(create);
  static ApproveLocationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

  /// When the standard takes effect. Empty means now.
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

class ApproveLocationResponse extends $pb.GeneratedMessage {
  factory ApproveLocationResponse({
    CleanableLocation? location,
  }) {
    final result = create();
    if (location != null) result.location = location;
    return result;
  }

  ApproveLocationResponse._();

  factory ApproveLocationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveLocationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveLocationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOM<CleanableLocation>(1, _omitFieldNames ? '' : 'location',
        subBuilder: CleanableLocation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveLocationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveLocationResponse copyWith(
          void Function(ApproveLocationResponse) updates) =>
      super.copyWith((message) => updates(message as ApproveLocationResponse))
          as ApproveLocationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveLocationResponse create() => ApproveLocationResponse._();
  @$core.override
  ApproveLocationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveLocationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveLocationResponse>(create);
  static ApproveLocationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CleanableLocation get location => $_getN(0);
  @$pb.TagNumber(1)
  set location(CleanableLocation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLocation() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocation() => $_clearField(1);
  @$pb.TagNumber(1)
  CleanableLocation ensureLocation() => $_ensure(0);
}

class ListLocationsRequest extends $pb.GeneratedMessage {
  factory ListLocationsRequest({
    $core.String? facilityId,
    $core.String? zone,
    RiskClass? riskClass,
    $core.bool? liveOnly,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (zone != null) result.zone = zone;
    if (riskClass != null) result.riskClass = riskClass;
    if (liveOnly != null) result.liveOnly = liveOnly;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListLocationsRequest._();

  factory ListLocationsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLocationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLocationsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'zone')
    ..aE<RiskClass>(3, _omitFieldNames ? '' : 'riskClass',
        enumValues: RiskClass.values)
    ..aOB(4, _omitFieldNames ? '' : 'liveOnly')
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..aI(6, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLocationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLocationsRequest copyWith(void Function(ListLocationsRequest) updates) =>
      super.copyWith((message) => updates(message as ListLocationsRequest))
          as ListLocationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLocationsRequest create() => ListLocationsRequest._();
  @$core.override
  ListLocationsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLocationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLocationsRequest>(create);
  static ListLocationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get zone => $_getSZ(1);
  @$pb.TagNumber(2)
  set zone($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasZone() => $_has(1);
  @$pb.TagNumber(2)
  void clearZone() => $_clearField(2);

  @$pb.TagNumber(3)
  RiskClass get riskClass => $_getN(2);
  @$pb.TagNumber(3)
  set riskClass(RiskClass value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRiskClass() => $_has(2);
  @$pb.TagNumber(3)
  void clearRiskClass() => $_clearField(3);

  /// Restrict to standards in force right now.
  @$pb.TagNumber(4)
  $core.bool get liveOnly => $_getBF(3);
  @$pb.TagNumber(4)
  set liveOnly($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLiveOnly() => $_has(3);
  @$pb.TagNumber(4)
  void clearLiveOnly() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get offset => $_getIZ(5);
  @$pb.TagNumber(6)
  set offset($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOffset() => $_has(5);
  @$pb.TagNumber(6)
  void clearOffset() => $_clearField(6);
}

class ListLocationsResponse extends $pb.GeneratedMessage {
  factory ListLocationsResponse({
    $core.Iterable<CleanableLocation>? locations,
  }) {
    final result = create();
    if (locations != null) result.locations.addAll(locations);
    return result;
  }

  ListLocationsResponse._();

  factory ListLocationsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLocationsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLocationsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..pPM<CleanableLocation>(1, _omitFieldNames ? '' : 'locations',
        subBuilder: CleanableLocation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLocationsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLocationsResponse copyWith(
          void Function(ListLocationsResponse) updates) =>
      super.copyWith((message) => updates(message as ListLocationsResponse))
          as ListLocationsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLocationsResponse create() => ListLocationsResponse._();
  @$core.override
  ListLocationsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLocationsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLocationsResponse>(create);
  static ListLocationsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CleanableLocation> get locations => $_getList(0);
}

class GetLocationInForceRequest extends $pb.GeneratedMessage {
  factory GetLocationInForceRequest({
    $core.String? code,
  }) {
    final result = create();
    if (code != null) result.code = code;
    return result;
  }

  GetLocationInForceRequest._();

  factory GetLocationInForceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLocationInForceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLocationInForceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLocationInForceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLocationInForceRequest copyWith(
          void Function(GetLocationInForceRequest) updates) =>
      super.copyWith((message) => updates(message as GetLocationInForceRequest))
          as GetLocationInForceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLocationInForceRequest create() => GetLocationInForceRequest._();
  @$core.override
  GetLocationInForceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetLocationInForceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLocationInForceRequest>(create);
  static GetLocationInForceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);
}

class GetLocationInForceResponse extends $pb.GeneratedMessage {
  factory GetLocationInForceResponse({
    CleanableLocation? location,
  }) {
    final result = create();
    if (location != null) result.location = location;
    return result;
  }

  GetLocationInForceResponse._();

  factory GetLocationInForceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLocationInForceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLocationInForceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOM<CleanableLocation>(1, _omitFieldNames ? '' : 'location',
        subBuilder: CleanableLocation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLocationInForceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLocationInForceResponse copyWith(
          void Function(GetLocationInForceResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetLocationInForceResponse))
          as GetLocationInForceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLocationInForceResponse create() => GetLocationInForceResponse._();
  @$core.override
  GetLocationInForceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetLocationInForceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLocationInForceResponse>(create);
  static GetLocationInForceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CleanableLocation get location => $_getN(0);
  @$pb.TagNumber(1)
  set location(CleanableLocation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLocation() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocation() => $_clearField(1);
  @$pb.TagNumber(1)
  CleanableLocation ensureLocation() => $_ensure(0);
}

class ListDueRoutineCleansRequest extends $pb.GeneratedMessage {
  factory ListDueRoutineCleansRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  ListDueRoutineCleansRequest._();

  factory ListDueRoutineCleansRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDueRoutineCleansRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDueRoutineCleansRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueRoutineCleansRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueRoutineCleansRequest copyWith(
          void Function(ListDueRoutineCleansRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListDueRoutineCleansRequest))
          as ListDueRoutineCleansRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDueRoutineCleansRequest create() =>
      ListDueRoutineCleansRequest._();
  @$core.override
  ListDueRoutineCleansRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDueRoutineCleansRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDueRoutineCleansRequest>(create);
  static ListDueRoutineCleansRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

class ListDueRoutineCleansResponse extends $pb.GeneratedMessage {
  factory ListDueRoutineCleansResponse({
    $core.Iterable<DueRoutineClean>? due,
  }) {
    final result = create();
    if (due != null) result.due.addAll(due);
    return result;
  }

  ListDueRoutineCleansResponse._();

  factory ListDueRoutineCleansResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDueRoutineCleansResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDueRoutineCleansResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..pPM<DueRoutineClean>(1, _omitFieldNames ? '' : 'due',
        subBuilder: DueRoutineClean.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueRoutineCleansResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueRoutineCleansResponse copyWith(
          void Function(ListDueRoutineCleansResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListDueRoutineCleansResponse))
          as ListDueRoutineCleansResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDueRoutineCleansResponse create() =>
      ListDueRoutineCleansResponse._();
  @$core.override
  ListDueRoutineCleansResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDueRoutineCleansResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDueRoutineCleansResponse>(create);
  static ListDueRoutineCleansResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DueRoutineClean> get due => $_getList(0);
}

class RaiseCleaningTaskRequest extends $pb.GeneratedMessage {
  factory RaiseCleaningTaskRequest({
    $core.String? locationCode,
    TaskKind? kind,
    $core.String? incidentRef,
    $core.String? detail,
    $core.String? assigneeId,
  }) {
    final result = create();
    if (locationCode != null) result.locationCode = locationCode;
    if (kind != null) result.kind = kind;
    if (incidentRef != null) result.incidentRef = incidentRef;
    if (detail != null) result.detail = detail;
    if (assigneeId != null) result.assigneeId = assigneeId;
    return result;
  }

  RaiseCleaningTaskRequest._();

  factory RaiseCleaningTaskRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseCleaningTaskRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseCleaningTaskRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationCode')
    ..aE<TaskKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: TaskKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'incidentRef')
    ..aOS(4, _omitFieldNames ? '' : 'detail')
    ..aOS(5, _omitFieldNames ? '' : 'assigneeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseCleaningTaskRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseCleaningTaskRequest copyWith(
          void Function(RaiseCleaningTaskRequest) updates) =>
      super.copyWith((message) => updates(message as RaiseCleaningTaskRequest))
          as RaiseCleaningTaskRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseCleaningTaskRequest create() => RaiseCleaningTaskRequest._();
  @$core.override
  RaiseCleaningTaskRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseCleaningTaskRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseCleaningTaskRequest>(create);
  static RaiseCleaningTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationCode() => $_clearField(1);

  @$pb.TagNumber(2)
  TaskKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(TaskKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  /// The incident this spill belongs to. A deployment may require it to
  /// resolve.
  @$pb.TagNumber(3)
  $core.String get incidentRef => $_getSZ(2);
  @$pb.TagNumber(3)
  set incidentRef($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIncidentRef() => $_has(2);
  @$pb.TagNumber(3)
  void clearIncidentRef() => $_clearField(3);

  /// What was spilled. Required for a spill: a biohazard task with no detail
  /// sends somebody with the wrong equipment.
  @$pb.TagNumber(4)
  $core.String get detail => $_getSZ(3);
  @$pb.TagNumber(4)
  set detail($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDetail() => $_has(3);
  @$pb.TagNumber(4)
  void clearDetail() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get assigneeId => $_getSZ(4);
  @$pb.TagNumber(5)
  set assigneeId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAssigneeId() => $_has(4);
  @$pb.TagNumber(5)
  void clearAssigneeId() => $_clearField(5);
}

class RaiseCleaningTaskResponse extends $pb.GeneratedMessage {
  factory RaiseCleaningTaskResponse({
    CleaningTask? task,
  }) {
    final result = create();
    if (task != null) result.task = task;
    return result;
  }

  RaiseCleaningTaskResponse._();

  factory RaiseCleaningTaskResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseCleaningTaskResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseCleaningTaskResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOM<CleaningTask>(1, _omitFieldNames ? '' : 'task',
        subBuilder: CleaningTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseCleaningTaskResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseCleaningTaskResponse copyWith(
          void Function(RaiseCleaningTaskResponse) updates) =>
      super.copyWith((message) => updates(message as RaiseCleaningTaskResponse))
          as RaiseCleaningTaskResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseCleaningTaskResponse create() => RaiseCleaningTaskResponse._();
  @$core.override
  RaiseCleaningTaskResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseCleaningTaskResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseCleaningTaskResponse>(create);
  static RaiseCleaningTaskResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CleaningTask get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(CleaningTask value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  CleaningTask ensureTask() => $_ensure(0);
}

class AssignCleaningTaskRequest extends $pb.GeneratedMessage {
  factory AssignCleaningTaskRequest({
    $core.String? taskId,
    $core.String? assigneeId,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (assigneeId != null) result.assigneeId = assigneeId;
    return result;
  }

  AssignCleaningTaskRequest._();

  factory AssignCleaningTaskRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssignCleaningTaskRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssignCleaningTaskRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aOS(2, _omitFieldNames ? '' : 'assigneeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignCleaningTaskRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignCleaningTaskRequest copyWith(
          void Function(AssignCleaningTaskRequest) updates) =>
      super.copyWith((message) => updates(message as AssignCleaningTaskRequest))
          as AssignCleaningTaskRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignCleaningTaskRequest create() => AssignCleaningTaskRequest._();
  @$core.override
  AssignCleaningTaskRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssignCleaningTaskRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssignCleaningTaskRequest>(create);
  static AssignCleaningTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assigneeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assigneeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssigneeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssigneeId() => $_clearField(2);
}

class AssignCleaningTaskResponse extends $pb.GeneratedMessage {
  factory AssignCleaningTaskResponse({
    CleaningTask? task,
  }) {
    final result = create();
    if (task != null) result.task = task;
    return result;
  }

  AssignCleaningTaskResponse._();

  factory AssignCleaningTaskResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssignCleaningTaskResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssignCleaningTaskResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOM<CleaningTask>(1, _omitFieldNames ? '' : 'task',
        subBuilder: CleaningTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignCleaningTaskResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignCleaningTaskResponse copyWith(
          void Function(AssignCleaningTaskResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AssignCleaningTaskResponse))
          as AssignCleaningTaskResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignCleaningTaskResponse create() => AssignCleaningTaskResponse._();
  @$core.override
  AssignCleaningTaskResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssignCleaningTaskResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssignCleaningTaskResponse>(create);
  static AssignCleaningTaskResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CleaningTask get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(CleaningTask value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  CleaningTask ensureTask() => $_ensure(0);
}

class StartCleaningTaskRequest extends $pb.GeneratedMessage {
  factory StartCleaningTaskRequest({
    $core.String? taskId,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    return result;
  }

  StartCleaningTaskRequest._();

  factory StartCleaningTaskRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartCleaningTaskRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartCleaningTaskRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartCleaningTaskRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartCleaningTaskRequest copyWith(
          void Function(StartCleaningTaskRequest) updates) =>
      super.copyWith((message) => updates(message as StartCleaningTaskRequest))
          as StartCleaningTaskRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartCleaningTaskRequest create() => StartCleaningTaskRequest._();
  @$core.override
  StartCleaningTaskRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartCleaningTaskRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartCleaningTaskRequest>(create);
  static StartCleaningTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);
}

class StartCleaningTaskResponse extends $pb.GeneratedMessage {
  factory StartCleaningTaskResponse({
    CleaningTask? task,
  }) {
    final result = create();
    if (task != null) result.task = task;
    return result;
  }

  StartCleaningTaskResponse._();

  factory StartCleaningTaskResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartCleaningTaskResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartCleaningTaskResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOM<CleaningTask>(1, _omitFieldNames ? '' : 'task',
        subBuilder: CleaningTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartCleaningTaskResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartCleaningTaskResponse copyWith(
          void Function(StartCleaningTaskResponse) updates) =>
      super.copyWith((message) => updates(message as StartCleaningTaskResponse))
          as StartCleaningTaskResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartCleaningTaskResponse create() => StartCleaningTaskResponse._();
  @$core.override
  StartCleaningTaskResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartCleaningTaskResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartCleaningTaskResponse>(create);
  static StartCleaningTaskResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CleaningTask get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(CleaningTask value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  CleaningTask ensureTask() => $_ensure(0);
}

class CompleteCleaningTaskRequest extends $pb.GeneratedMessage {
  factory CompleteCleaningTaskRequest({
    $core.String? taskId,
    $core.Iterable<ChecklistAnswer>? answers,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (answers != null) result.answers.addAll(answers);
    return result;
  }

  CompleteCleaningTaskRequest._();

  factory CompleteCleaningTaskRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteCleaningTaskRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteCleaningTaskRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..pPM<ChecklistAnswer>(2, _omitFieldNames ? '' : 'answers',
        subBuilder: ChecklistAnswer.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteCleaningTaskRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteCleaningTaskRequest copyWith(
          void Function(CompleteCleaningTaskRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CompleteCleaningTaskRequest))
          as CompleteCleaningTaskRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteCleaningTaskRequest create() =>
      CompleteCleaningTaskRequest._();
  @$core.override
  CompleteCleaningTaskRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteCleaningTaskRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteCleaningTaskRequest>(create);
  static CompleteCleaningTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ChecklistAnswer> get answers => $_getList(1);
}

class CompleteCleaningTaskResponse extends $pb.GeneratedMessage {
  factory CompleteCleaningTaskResponse({
    CleaningTask? task,
  }) {
    final result = create();
    if (task != null) result.task = task;
    return result;
  }

  CompleteCleaningTaskResponse._();

  factory CompleteCleaningTaskResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteCleaningTaskResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteCleaningTaskResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOM<CleaningTask>(1, _omitFieldNames ? '' : 'task',
        subBuilder: CleaningTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteCleaningTaskResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteCleaningTaskResponse copyWith(
          void Function(CompleteCleaningTaskResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CompleteCleaningTaskResponse))
          as CompleteCleaningTaskResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteCleaningTaskResponse create() =>
      CompleteCleaningTaskResponse._();
  @$core.override
  CompleteCleaningTaskResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteCleaningTaskResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteCleaningTaskResponse>(create);
  static CompleteCleaningTaskResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CleaningTask get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(CleaningTask value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  CleaningTask ensureTask() => $_ensure(0);
}

class VerifyCleaningTaskRequest extends $pb.GeneratedMessage {
  factory VerifyCleaningTaskRequest({
    $core.String? taskId,
    $core.String? note,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (note != null) result.note = note;
    return result;
  }

  VerifyCleaningTaskRequest._();

  factory VerifyCleaningTaskRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyCleaningTaskRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyCleaningTaskRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyCleaningTaskRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyCleaningTaskRequest copyWith(
          void Function(VerifyCleaningTaskRequest) updates) =>
      super.copyWith((message) => updates(message as VerifyCleaningTaskRequest))
          as VerifyCleaningTaskRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyCleaningTaskRequest create() => VerifyCleaningTaskRequest._();
  @$core.override
  VerifyCleaningTaskRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyCleaningTaskRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyCleaningTaskRequest>(create);
  static VerifyCleaningTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);
}

class VerifyCleaningTaskResponse extends $pb.GeneratedMessage {
  factory VerifyCleaningTaskResponse({
    CleaningTask? task,
  }) {
    final result = create();
    if (task != null) result.task = task;
    return result;
  }

  VerifyCleaningTaskResponse._();

  factory VerifyCleaningTaskResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyCleaningTaskResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyCleaningTaskResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOM<CleaningTask>(1, _omitFieldNames ? '' : 'task',
        subBuilder: CleaningTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyCleaningTaskResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyCleaningTaskResponse copyWith(
          void Function(VerifyCleaningTaskResponse) updates) =>
      super.copyWith(
              (message) => updates(message as VerifyCleaningTaskResponse))
          as VerifyCleaningTaskResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyCleaningTaskResponse create() => VerifyCleaningTaskResponse._();
  @$core.override
  VerifyCleaningTaskResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyCleaningTaskResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyCleaningTaskResponse>(create);
  static VerifyCleaningTaskResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CleaningTask get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(CleaningTask value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  CleaningTask ensureTask() => $_ensure(0);
}

class CancelCleaningTaskRequest extends $pb.GeneratedMessage {
  factory CancelCleaningTaskRequest({
    $core.String? taskId,
    $core.String? reason,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (reason != null) result.reason = reason;
    return result;
  }

  CancelCleaningTaskRequest._();

  factory CancelCleaningTaskRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelCleaningTaskRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelCleaningTaskRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelCleaningTaskRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelCleaningTaskRequest copyWith(
          void Function(CancelCleaningTaskRequest) updates) =>
      super.copyWith((message) => updates(message as CancelCleaningTaskRequest))
          as CancelCleaningTaskRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelCleaningTaskRequest create() => CancelCleaningTaskRequest._();
  @$core.override
  CancelCleaningTaskRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelCleaningTaskRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelCleaningTaskRequest>(create);
  static CancelCleaningTaskRequest? _defaultInstance;

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

class CancelCleaningTaskResponse extends $pb.GeneratedMessage {
  factory CancelCleaningTaskResponse({
    CleaningTask? task,
  }) {
    final result = create();
    if (task != null) result.task = task;
    return result;
  }

  CancelCleaningTaskResponse._();

  factory CancelCleaningTaskResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelCleaningTaskResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelCleaningTaskResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOM<CleaningTask>(1, _omitFieldNames ? '' : 'task',
        subBuilder: CleaningTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelCleaningTaskResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelCleaningTaskResponse copyWith(
          void Function(CancelCleaningTaskResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CancelCleaningTaskResponse))
          as CancelCleaningTaskResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelCleaningTaskResponse create() => CancelCleaningTaskResponse._();
  @$core.override
  CancelCleaningTaskResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelCleaningTaskResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelCleaningTaskResponse>(create);
  static CancelCleaningTaskResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CleaningTask get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(CleaningTask value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  CleaningTask ensureTask() => $_ensure(0);
}

class GetCleaningTaskRequest extends $pb.GeneratedMessage {
  factory GetCleaningTaskRequest({
    $core.String? taskId,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    return result;
  }

  GetCleaningTaskRequest._();

  factory GetCleaningTaskRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCleaningTaskRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCleaningTaskRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCleaningTaskRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCleaningTaskRequest copyWith(
          void Function(GetCleaningTaskRequest) updates) =>
      super.copyWith((message) => updates(message as GetCleaningTaskRequest))
          as GetCleaningTaskRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCleaningTaskRequest create() => GetCleaningTaskRequest._();
  @$core.override
  GetCleaningTaskRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCleaningTaskRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCleaningTaskRequest>(create);
  static GetCleaningTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);
}

class GetCleaningTaskResponse extends $pb.GeneratedMessage {
  factory GetCleaningTaskResponse({
    CleaningTask? task,
  }) {
    final result = create();
    if (task != null) result.task = task;
    return result;
  }

  GetCleaningTaskResponse._();

  factory GetCleaningTaskResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCleaningTaskResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCleaningTaskResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOM<CleaningTask>(1, _omitFieldNames ? '' : 'task',
        subBuilder: CleaningTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCleaningTaskResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCleaningTaskResponse copyWith(
          void Function(GetCleaningTaskResponse) updates) =>
      super.copyWith((message) => updates(message as GetCleaningTaskResponse))
          as GetCleaningTaskResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCleaningTaskResponse create() => GetCleaningTaskResponse._();
  @$core.override
  GetCleaningTaskResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCleaningTaskResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCleaningTaskResponse>(create);
  static GetCleaningTaskResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CleaningTask get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(CleaningTask value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  CleaningTask ensureTask() => $_ensure(0);
}

class ListCleaningTasksRequest extends $pb.GeneratedMessage {
  factory ListCleaningTasksRequest({
    $core.String? facilityId,
    $core.String? zone,
    $core.String? locationCode,
    $core.String? bedId,
    TaskKind? kind,
    $core.Iterable<TaskState>? states,
    $core.String? assigneeId,
    $core.bool? openOnly,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (zone != null) result.zone = zone;
    if (locationCode != null) result.locationCode = locationCode;
    if (bedId != null) result.bedId = bedId;
    if (kind != null) result.kind = kind;
    if (states != null) result.states.addAll(states);
    if (assigneeId != null) result.assigneeId = assigneeId;
    if (openOnly != null) result.openOnly = openOnly;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListCleaningTasksRequest._();

  factory ListCleaningTasksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCleaningTasksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCleaningTasksRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'zone')
    ..aOS(3, _omitFieldNames ? '' : 'locationCode')
    ..aOS(4, _omitFieldNames ? '' : 'bedId')
    ..aE<TaskKind>(5, _omitFieldNames ? '' : 'kind',
        enumValues: TaskKind.values)
    ..pc<TaskState>(6, _omitFieldNames ? '' : 'states', $pb.PbFieldType.KE,
        valueOf: TaskState.valueOf,
        enumValues: TaskState.values,
        defaultEnumValue: TaskState.TASK_STATE_UNSPECIFIED)
    ..aOS(7, _omitFieldNames ? '' : 'assigneeId')
    ..aOB(8, _omitFieldNames ? '' : 'openOnly')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(11, _omitFieldNames ? '' : 'pageSize')
    ..aI(12, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCleaningTasksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCleaningTasksRequest copyWith(
          void Function(ListCleaningTasksRequest) updates) =>
      super.copyWith((message) => updates(message as ListCleaningTasksRequest))
          as ListCleaningTasksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCleaningTasksRequest create() => ListCleaningTasksRequest._();
  @$core.override
  ListCleaningTasksRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCleaningTasksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCleaningTasksRequest>(create);
  static ListCleaningTasksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get zone => $_getSZ(1);
  @$pb.TagNumber(2)
  set zone($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasZone() => $_has(1);
  @$pb.TagNumber(2)
  void clearZone() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locationCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get bedId => $_getSZ(3);
  @$pb.TagNumber(4)
  set bedId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBedId() => $_has(3);
  @$pb.TagNumber(4)
  void clearBedId() => $_clearField(4);

  @$pb.TagNumber(5)
  TaskKind get kind => $_getN(4);
  @$pb.TagNumber(5)
  set kind(TaskKind value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearKind() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<TaskState> get states => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get assigneeId => $_getSZ(6);
  @$pb.TagNumber(7)
  set assigneeId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAssigneeId() => $_has(6);
  @$pb.TagNumber(7)
  void clearAssigneeId() => $_clearField(7);

  /// Only tasks somebody still has to do.
  @$pb.TagNumber(8)
  $core.bool get openOnly => $_getBF(7);
  @$pb.TagNumber(8)
  set openOnly($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOpenOnly() => $_has(7);
  @$pb.TagNumber(8)
  void clearOpenOnly() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get from => $_getN(8);
  @$pb.TagNumber(9)
  set from($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasFrom() => $_has(8);
  @$pb.TagNumber(9)
  void clearFrom() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureFrom() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get to => $_getN(9);
  @$pb.TagNumber(10)
  set to($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasTo() => $_has(9);
  @$pb.TagNumber(10)
  void clearTo() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureTo() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.int get pageSize => $_getIZ(10);
  @$pb.TagNumber(11)
  set pageSize($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPageSize() => $_has(10);
  @$pb.TagNumber(11)
  void clearPageSize() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get offset => $_getIZ(11);
  @$pb.TagNumber(12)
  set offset($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOffset() => $_has(11);
  @$pb.TagNumber(12)
  void clearOffset() => $_clearField(12);
}

class ListCleaningTasksResponse extends $pb.GeneratedMessage {
  factory ListCleaningTasksResponse({
    $core.Iterable<CleaningTask>? tasks,
  }) {
    final result = create();
    if (tasks != null) result.tasks.addAll(tasks);
    return result;
  }

  ListCleaningTasksResponse._();

  factory ListCleaningTasksResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCleaningTasksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCleaningTasksResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..pPM<CleaningTask>(1, _omitFieldNames ? '' : 'tasks',
        subBuilder: CleaningTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCleaningTasksResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCleaningTasksResponse copyWith(
          void Function(ListCleaningTasksResponse) updates) =>
      super.copyWith((message) => updates(message as ListCleaningTasksResponse))
          as ListCleaningTasksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCleaningTasksResponse create() => ListCleaningTasksResponse._();
  @$core.override
  ListCleaningTasksResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCleaningTasksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCleaningTasksResponse>(create);
  static ListCleaningTasksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CleaningTask> get tasks => $_getList(0);
}

class EscalateOverdueCleansRequest extends $pb.GeneratedMessage {
  factory EscalateOverdueCleansRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  EscalateOverdueCleansRequest._();

  factory EscalateOverdueCleansRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EscalateOverdueCleansRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EscalateOverdueCleansRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateOverdueCleansRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateOverdueCleansRequest copyWith(
          void Function(EscalateOverdueCleansRequest) updates) =>
      super.copyWith(
              (message) => updates(message as EscalateOverdueCleansRequest))
          as EscalateOverdueCleansRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EscalateOverdueCleansRequest create() =>
      EscalateOverdueCleansRequest._();
  @$core.override
  EscalateOverdueCleansRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EscalateOverdueCleansRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EscalateOverdueCleansRequest>(create);
  static EscalateOverdueCleansRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

class EscalateOverdueCleansResponse extends $pb.GeneratedMessage {
  factory EscalateOverdueCleansResponse({
    $core.Iterable<CleaningTask>? escalated,
  }) {
    final result = create();
    if (escalated != null) result.escalated.addAll(escalated);
    return result;
  }

  EscalateOverdueCleansResponse._();

  factory EscalateOverdueCleansResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EscalateOverdueCleansResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EscalateOverdueCleansResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..pPM<CleaningTask>(1, _omitFieldNames ? '' : 'escalated',
        subBuilder: CleaningTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateOverdueCleansResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateOverdueCleansResponse copyWith(
          void Function(EscalateOverdueCleansResponse) updates) =>
      super.copyWith(
              (message) => updates(message as EscalateOverdueCleansResponse))
          as EscalateOverdueCleansResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EscalateOverdueCleansResponse create() =>
      EscalateOverdueCleansResponse._();
  @$core.override
  EscalateOverdueCleansResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EscalateOverdueCleansResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EscalateOverdueCleansResponse>(create);
  static EscalateOverdueCleansResponse? _defaultInstance;

  /// The tasks a notice went out for. Critical areas only, once each.
  @$pb.TagNumber(1)
  $pb.PbList<CleaningTask> get escalated => $_getList(0);
}

class RecordLocationScanRequest extends $pb.GeneratedMessage {
  factory RecordLocationScanRequest({
    $core.String? taskId,
    $core.String? scannedCode,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (scannedCode != null) result.scannedCode = scannedCode;
    return result;
  }

  RecordLocationScanRequest._();

  factory RecordLocationScanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordLocationScanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordLocationScanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aOS(2, _omitFieldNames ? '' : 'scannedCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordLocationScanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordLocationScanRequest copyWith(
          void Function(RecordLocationScanRequest) updates) =>
      super.copyWith((message) => updates(message as RecordLocationScanRequest))
          as RecordLocationScanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordLocationScanRequest create() => RecordLocationScanRequest._();
  @$core.override
  RecordLocationScanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordLocationScanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordLocationScanRequest>(create);
  static RecordLocationScanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);

  /// The code that was read, exactly as read.
  @$pb.TagNumber(2)
  $core.String get scannedCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set scannedCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScannedCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearScannedCode() => $_clearField(2);
}

class RecordLocationScanResponse extends $pb.GeneratedMessage {
  factory RecordLocationScanResponse({
    LocationScan? scan,
  }) {
    final result = create();
    if (scan != null) result.scan = scan;
    return result;
  }

  RecordLocationScanResponse._();

  factory RecordLocationScanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordLocationScanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordLocationScanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOM<LocationScan>(1, _omitFieldNames ? '' : 'scan',
        subBuilder: LocationScan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordLocationScanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordLocationScanResponse copyWith(
          void Function(RecordLocationScanResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RecordLocationScanResponse))
          as RecordLocationScanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordLocationScanResponse create() => RecordLocationScanResponse._();
  @$core.override
  RecordLocationScanResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordLocationScanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordLocationScanResponse>(create);
  static RecordLocationScanResponse? _defaultInstance;

  /// The scan as recorded. A mismatch comes back here rather than as an
  /// error.
  @$pb.TagNumber(1)
  LocationScan get scan => $_getN(0);
  @$pb.TagNumber(1)
  set scan(LocationScan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScan() => $_has(0);
  @$pb.TagNumber(1)
  void clearScan() => $_clearField(1);
  @$pb.TagNumber(1)
  LocationScan ensureScan() => $_ensure(0);
}

class TriggerTerminalCleanRequest extends $pb.GeneratedMessage {
  factory TriggerTerminalCleanRequest({
    $core.String? locationCode,
    $core.String? encounterId,
    $core.String? assigneeId,
    $core.String? detail,
  }) {
    final result = create();
    if (locationCode != null) result.locationCode = locationCode;
    if (encounterId != null) result.encounterId = encounterId;
    if (assigneeId != null) result.assigneeId = assigneeId;
    if (detail != null) result.detail = detail;
    return result;
  }

  TriggerTerminalCleanRequest._();

  factory TriggerTerminalCleanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TriggerTerminalCleanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TriggerTerminalCleanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationCode')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'assigneeId')
    ..aOS(4, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriggerTerminalCleanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriggerTerminalCleanRequest copyWith(
          void Function(TriggerTerminalCleanRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TriggerTerminalCleanRequest))
          as TriggerTerminalCleanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TriggerTerminalCleanRequest create() =>
      TriggerTerminalCleanRequest._();
  @$core.override
  TriggerTerminalCleanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TriggerTerminalCleanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TriggerTerminalCleanRequest>(create);
  static TriggerTerminalCleanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationCode() => $_clearField(1);

  /// The discharge or transfer that triggered it. A deployment may require it
  /// to name an encounter that has actually ended.
  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assigneeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assigneeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssigneeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssigneeId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get detail => $_getSZ(3);
  @$pb.TagNumber(4)
  set detail($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDetail() => $_has(3);
  @$pb.TagNumber(4)
  void clearDetail() => $_clearField(4);
}

class TriggerTerminalCleanResponse extends $pb.GeneratedMessage {
  factory TriggerTerminalCleanResponse({
    CleaningTask? task,
    BedHold? hold,
  }) {
    final result = create();
    if (task != null) result.task = task;
    if (hold != null) result.hold = hold;
    return result;
  }

  TriggerTerminalCleanResponse._();

  factory TriggerTerminalCleanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TriggerTerminalCleanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TriggerTerminalCleanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOM<CleaningTask>(1, _omitFieldNames ? '' : 'task',
        subBuilder: CleaningTask.create)
    ..aOM<BedHold>(2, _omitFieldNames ? '' : 'hold', subBuilder: BedHold.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriggerTerminalCleanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriggerTerminalCleanResponse copyWith(
          void Function(TriggerTerminalCleanResponse) updates) =>
      super.copyWith(
              (message) => updates(message as TriggerTerminalCleanResponse))
          as TriggerTerminalCleanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TriggerTerminalCleanResponse create() =>
      TriggerTerminalCleanResponse._();
  @$core.override
  TriggerTerminalCleanResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TriggerTerminalCleanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TriggerTerminalCleanResponse>(create);
  static TriggerTerminalCleanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CleaningTask get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(CleaningTask value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  CleaningTask ensureTask() => $_ensure(0);

  @$pb.TagNumber(2)
  BedHold get hold => $_getN(1);
  @$pb.TagNumber(2)
  set hold(BedHold value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasHold() => $_has(1);
  @$pb.TagNumber(2)
  void clearHold() => $_clearField(2);
  @$pb.TagNumber(2)
  BedHold ensureHold() => $_ensure(1);
}

class OverrideBedHoldRequest extends $pb.GeneratedMessage {
  factory OverrideBedHoldRequest({
    $core.String? holdId,
    $core.String? reason,
  }) {
    final result = create();
    if (holdId != null) result.holdId = holdId;
    if (reason != null) result.reason = reason;
    return result;
  }

  OverrideBedHoldRequest._();

  factory OverrideBedHoldRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OverrideBedHoldRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OverrideBedHoldRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'holdId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideBedHoldRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideBedHoldRequest copyWith(
          void Function(OverrideBedHoldRequest) updates) =>
      super.copyWith((message) => updates(message as OverrideBedHoldRequest))
          as OverrideBedHoldRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OverrideBedHoldRequest create() => OverrideBedHoldRequest._();
  @$core.override
  OverrideBedHoldRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OverrideBedHoldRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OverrideBedHoldRequest>(create);
  static OverrideBedHoldRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get holdId => $_getSZ(0);
  @$pb.TagNumber(1)
  set holdId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHoldId() => $_has(0);
  @$pb.TagNumber(1)
  void clearHoldId() => $_clearField(1);

  /// Why this bed is going back into service uncleaned. Required.
  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class OverrideBedHoldResponse extends $pb.GeneratedMessage {
  factory OverrideBedHoldResponse({
    BedHold? hold,
  }) {
    final result = create();
    if (hold != null) result.hold = hold;
    return result;
  }

  OverrideBedHoldResponse._();

  factory OverrideBedHoldResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OverrideBedHoldResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OverrideBedHoldResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOM<BedHold>(1, _omitFieldNames ? '' : 'hold', subBuilder: BedHold.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideBedHoldResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideBedHoldResponse copyWith(
          void Function(OverrideBedHoldResponse) updates) =>
      super.copyWith((message) => updates(message as OverrideBedHoldResponse))
          as OverrideBedHoldResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OverrideBedHoldResponse create() => OverrideBedHoldResponse._();
  @$core.override
  OverrideBedHoldResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OverrideBedHoldResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OverrideBedHoldResponse>(create);
  static OverrideBedHoldResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BedHold get hold => $_getN(0);
  @$pb.TagNumber(1)
  set hold(BedHold value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHold() => $_has(0);
  @$pb.TagNumber(1)
  void clearHold() => $_clearField(1);
  @$pb.TagNumber(1)
  BedHold ensureHold() => $_ensure(0);
}

class GetBedStatusRequest extends $pb.GeneratedMessage {
  factory GetBedStatusRequest({
    $core.String? bedId,
  }) {
    final result = create();
    if (bedId != null) result.bedId = bedId;
    return result;
  }

  GetBedStatusRequest._();

  factory GetBedStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBedStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBedStatusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'bedId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBedStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBedStatusRequest copyWith(void Function(GetBedStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetBedStatusRequest))
          as GetBedStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBedStatusRequest create() => GetBedStatusRequest._();
  @$core.override
  GetBedStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBedStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBedStatusRequest>(create);
  static GetBedStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bedId => $_getSZ(0);
  @$pb.TagNumber(1)
  set bedId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBedId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBedId() => $_clearField(1);
}

class GetBedStatusResponse extends $pb.GeneratedMessage {
  factory GetBedStatusResponse({
    $core.String? bedId,
    $core.bool? clear_2,
    BedHold? hold,
  }) {
    final result = create();
    if (bedId != null) result.bedId = bedId;
    if (clear_2 != null) result.clear_2 = clear_2;
    if (hold != null) result.hold = hold;
    return result;
  }

  GetBedStatusResponse._();

  factory GetBedStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBedStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBedStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'bedId')
    ..aOB(2, _omitFieldNames ? '' : 'clear')
    ..aOM<BedHold>(3, _omitFieldNames ? '' : 'hold', subBuilder: BedHold.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBedStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBedStatusResponse copyWith(void Function(GetBedStatusResponse) updates) =>
      super.copyWith((message) => updates(message as GetBedStatusResponse))
          as GetBedStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBedStatusResponse create() => GetBedStatusResponse._();
  @$core.override
  GetBedStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBedStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBedStatusResponse>(create);
  static GetBedStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bedId => $_getSZ(0);
  @$pb.TagNumber(1)
  set bedId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBedId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBedId() => $_clearField(1);

  /// False while any hold on the bed is open. A bed this context knows
  /// nothing about comes back clear.
  @$pb.TagNumber(2)
  $core.bool get clear_2 => $_getBF(1);
  @$pb.TagNumber(2)
  set clear_2($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClear_2() => $_has(1);
  @$pb.TagNumber(2)
  void clearClear_2() => $_clearField(2);

  /// The open hold, when there is one.
  @$pb.TagNumber(3)
  BedHold get hold => $_getN(2);
  @$pb.TagNumber(3)
  set hold(BedHold value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasHold() => $_has(2);
  @$pb.TagNumber(3)
  void clearHold() => $_clearField(3);
  @$pb.TagNumber(3)
  BedHold ensureHold() => $_ensure(2);
}

class ListHeldBedsRequest extends $pb.GeneratedMessage {
  factory ListHeldBedsRequest({
    $core.String? facilityId,
    $core.String? zone,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (zone != null) result.zone = zone;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListHeldBedsRequest._();

  factory ListHeldBedsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListHeldBedsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListHeldBedsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'zone')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..aI(4, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHeldBedsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHeldBedsRequest copyWith(void Function(ListHeldBedsRequest) updates) =>
      super.copyWith((message) => updates(message as ListHeldBedsRequest))
          as ListHeldBedsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListHeldBedsRequest create() => ListHeldBedsRequest._();
  @$core.override
  ListHeldBedsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListHeldBedsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListHeldBedsRequest>(create);
  static ListHeldBedsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get zone => $_getSZ(1);
  @$pb.TagNumber(2)
  set zone($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasZone() => $_has(1);
  @$pb.TagNumber(2)
  void clearZone() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get offset => $_getIZ(3);
  @$pb.TagNumber(4)
  set offset($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);
}

class ListHeldBedsResponse extends $pb.GeneratedMessage {
  factory ListHeldBedsResponse({
    $core.Iterable<BedHold>? holds,
  }) {
    final result = create();
    if (holds != null) result.holds.addAll(holds);
    return result;
  }

  ListHeldBedsResponse._();

  factory ListHeldBedsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListHeldBedsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListHeldBedsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..pPM<BedHold>(1, _omitFieldNames ? '' : 'holds',
        subBuilder: BedHold.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHeldBedsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHeldBedsResponse copyWith(void Function(ListHeldBedsResponse) updates) =>
      super.copyWith((message) => updates(message as ListHeldBedsResponse))
          as ListHeldBedsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListHeldBedsResponse create() => ListHeldBedsResponse._();
  @$core.override
  ListHeldBedsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListHeldBedsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListHeldBedsResponse>(create);
  static ListHeldBedsResponse? _defaultInstance;

  /// Longest held first.
  @$pb.TagNumber(1)
  $pb.PbList<BedHold> get holds => $_getList(0);
}

class CleaningSummary extends $pb.GeneratedMessage {
  factory CleaningSummary({
    $core.int? raised,
    $core.int? completed,
    $core.int? cancelled,
    $core.int? outstanding,
    $core.int? overdueNow,
    $core.int? completedLate,
    $core.int? withinSla,
    $core.int? meanTurnaroundMinutes,
    $core.int? longestTurnaroundMinutes,
    $core.int? verified,
    $core.int? scanVerified,
    $core.bool? unanswerable,
  }) {
    final result = create();
    if (raised != null) result.raised = raised;
    if (completed != null) result.completed = completed;
    if (cancelled != null) result.cancelled = cancelled;
    if (outstanding != null) result.outstanding = outstanding;
    if (overdueNow != null) result.overdueNow = overdueNow;
    if (completedLate != null) result.completedLate = completedLate;
    if (withinSla != null) result.withinSla = withinSla;
    if (meanTurnaroundMinutes != null)
      result.meanTurnaroundMinutes = meanTurnaroundMinutes;
    if (longestTurnaroundMinutes != null)
      result.longestTurnaroundMinutes = longestTurnaroundMinutes;
    if (verified != null) result.verified = verified;
    if (scanVerified != null) result.scanVerified = scanVerified;
    if (unanswerable != null) result.unanswerable = unanswerable;
    return result;
  }

  CleaningSummary._();

  factory CleaningSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CleaningSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CleaningSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'raised')
    ..aI(2, _omitFieldNames ? '' : 'completed')
    ..aI(3, _omitFieldNames ? '' : 'cancelled')
    ..aI(4, _omitFieldNames ? '' : 'outstanding')
    ..aI(5, _omitFieldNames ? '' : 'overdueNow')
    ..aI(6, _omitFieldNames ? '' : 'completedLate')
    ..aI(7, _omitFieldNames ? '' : 'withinSla')
    ..aI(8, _omitFieldNames ? '' : 'meanTurnaroundMinutes')
    ..aI(9, _omitFieldNames ? '' : 'longestTurnaroundMinutes')
    ..aI(10, _omitFieldNames ? '' : 'verified')
    ..aI(11, _omitFieldNames ? '' : 'scanVerified')
    ..aOB(12, _omitFieldNames ? '' : 'unanswerable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CleaningSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CleaningSummary copyWith(void Function(CleaningSummary) updates) =>
      super.copyWith((message) => updates(message as CleaningSummary))
          as CleaningSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CleaningSummary create() => CleaningSummary._();
  @$core.override
  CleaningSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CleaningSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CleaningSummary>(create);
  static CleaningSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get raised => $_getIZ(0);
  @$pb.TagNumber(1)
  set raised($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRaised() => $_has(0);
  @$pb.TagNumber(1)
  void clearRaised() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get completed => $_getIZ(1);
  @$pb.TagNumber(2)
  set completed($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCompleted() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompleted() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get cancelled => $_getIZ(2);
  @$pb.TagNumber(3)
  set cancelled($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCancelled() => $_has(2);
  @$pb.TagNumber(3)
  void clearCancelled() => $_clearField(3);

  /// Tasks still to do at the moment asked about.
  @$pb.TagNumber(4)
  $core.int get outstanding => $_getIZ(3);
  @$pb.TagNumber(4)
  set outstanding($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutstanding() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutstanding() => $_clearField(4);

  /// Outstanding tasks already past their SLA. Counted apart from the ones
  /// completed late, because a ward can still act on these.
  @$pb.TagNumber(5)
  $core.int get overdueNow => $_getIZ(4);
  @$pb.TagNumber(5)
  set overdueNow($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOverdueNow() => $_has(4);
  @$pb.TagNumber(5)
  void clearOverdueNow() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get completedLate => $_getIZ(5);
  @$pb.TagNumber(6)
  set completedLate($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCompletedLate() => $_has(5);
  @$pb.TagNumber(6)
  void clearCompletedLate() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get withinSla => $_getIZ(6);
  @$pb.TagNumber(7)
  set withinSla($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWithinSla() => $_has(6);
  @$pb.TagNumber(7)
  void clearWithinSla() => $_clearField(7);

  /// Whole minutes. A turnaround of 43.7 minutes is a figure whose decimal is
  /// noise from how many tasks there were.
  @$pb.TagNumber(8)
  $core.int get meanTurnaroundMinutes => $_getIZ(7);
  @$pb.TagNumber(8)
  set meanTurnaroundMinutes($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMeanTurnaroundMinutes() => $_has(7);
  @$pb.TagNumber(8)
  void clearMeanTurnaroundMinutes() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get longestTurnaroundMinutes => $_getIZ(8);
  @$pb.TagNumber(9)
  set longestTurnaroundMinutes($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLongestTurnaroundMinutes() => $_has(8);
  @$pb.TagNumber(9)
  void clearLongestTurnaroundMinutes() => $_clearField(9);

  /// Completed tasks a supervisor signed off, and completed tasks somebody
  /// scanned the right door for. Both against completed rather than raised: a
  /// task nobody has finished is not an audit failure yet.
  @$pb.TagNumber(10)
  $core.int get verified => $_getIZ(9);
  @$pb.TagNumber(10)
  set verified($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVerified() => $_has(9);
  @$pb.TagNumber(10)
  void clearVerified() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get scanVerified => $_getIZ(10);
  @$pb.TagNumber(11)
  set scanVerified($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasScanVerified() => $_has(10);
  @$pb.TagNumber(11)
  void clearScanVerified() => $_clearField(11);

  /// A set with nothing completed in it. Reported rather than a mean of zero,
  /// which reads as a hospital that cleans every room instantly.
  @$pb.TagNumber(12)
  $core.bool get unanswerable => $_getBF(11);
  @$pb.TagNumber(12)
  set unanswerable($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasUnanswerable() => $_has(11);
  @$pb.TagNumber(12)
  void clearUnanswerable() => $_clearField(12);
}

class TurnaroundSummary extends $pb.GeneratedMessage {
  factory TurnaroundSummary({
    $core.int? held,
    $core.int? released,
    $core.int? stillHeld,
    $core.int? overridden,
    $core.int? meanMinutes,
    $core.int? longestMinutes,
    $core.bool? unanswerable,
  }) {
    final result = create();
    if (held != null) result.held = held;
    if (released != null) result.released = released;
    if (stillHeld != null) result.stillHeld = stillHeld;
    if (overridden != null) result.overridden = overridden;
    if (meanMinutes != null) result.meanMinutes = meanMinutes;
    if (longestMinutes != null) result.longestMinutes = longestMinutes;
    if (unanswerable != null) result.unanswerable = unanswerable;
    return result;
  }

  TurnaroundSummary._();

  factory TurnaroundSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TurnaroundSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TurnaroundSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'held')
    ..aI(2, _omitFieldNames ? '' : 'released')
    ..aI(3, _omitFieldNames ? '' : 'stillHeld')
    ..aI(4, _omitFieldNames ? '' : 'overridden')
    ..aI(5, _omitFieldNames ? '' : 'meanMinutes')
    ..aI(6, _omitFieldNames ? '' : 'longestMinutes')
    ..aOB(7, _omitFieldNames ? '' : 'unanswerable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnaroundSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnaroundSummary copyWith(void Function(TurnaroundSummary) updates) =>
      super.copyWith((message) => updates(message as TurnaroundSummary))
          as TurnaroundSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TurnaroundSummary create() => TurnaroundSummary._();
  @$core.override
  TurnaroundSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TurnaroundSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TurnaroundSummary>(create);
  static TurnaroundSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get held => $_getIZ(0);
  @$pb.TagNumber(1)
  set held($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHeld() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeld() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get released => $_getIZ(1);
  @$pb.TagNumber(2)
  set released($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReleased() => $_has(1);
  @$pb.TagNumber(2)
  void clearReleased() => $_clearField(2);

  /// Beds out of service at the moment asked about.
  @$pb.TagNumber(3)
  $core.int get stillHeld => $_getIZ(2);
  @$pb.TagNumber(3)
  set stillHeld($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStillHeld() => $_has(2);
  @$pb.TagNumber(3)
  void clearStillHeld() => $_clearField(3);

  /// Beds that went back into service without the clean finishing. Never
  /// averaged into the turnaround.
  @$pb.TagNumber(4)
  $core.int get overridden => $_getIZ(3);
  @$pb.TagNumber(4)
  set overridden($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOverridden() => $_has(3);
  @$pb.TagNumber(4)
  void clearOverridden() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get meanMinutes => $_getIZ(4);
  @$pb.TagNumber(5)
  set meanMinutes($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMeanMinutes() => $_has(4);
  @$pb.TagNumber(5)
  void clearMeanMinutes() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get longestMinutes => $_getIZ(5);
  @$pb.TagNumber(6)
  set longestMinutes($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLongestMinutes() => $_has(5);
  @$pb.TagNumber(6)
  void clearLongestMinutes() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get unanswerable => $_getBF(6);
  @$pb.TagNumber(7)
  set unanswerable($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUnanswerable() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnanswerable() => $_clearField(7);
}

class GetCleaningReportRequest extends $pb.GeneratedMessage {
  factory GetCleaningReportRequest({
    $core.String? facilityId,
    $core.String? zone,
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (zone != null) result.zone = zone;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  GetCleaningReportRequest._();

  factory GetCleaningReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCleaningReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCleaningReportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'zone')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCleaningReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCleaningReportRequest copyWith(
          void Function(GetCleaningReportRequest) updates) =>
      super.copyWith((message) => updates(message as GetCleaningReportRequest))
          as GetCleaningReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCleaningReportRequest create() => GetCleaningReportRequest._();
  @$core.override
  GetCleaningReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCleaningReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCleaningReportRequest>(create);
  static GetCleaningReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get zone => $_getSZ(1);
  @$pb.TagNumber(2)
  set zone($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasZone() => $_has(1);
  @$pb.TagNumber(2)
  void clearZone() => $_clearField(2);

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

class GetCleaningReportResponse extends $pb.GeneratedMessage {
  factory GetCleaningReportResponse({
    CleaningSummary? summary,
    $core.bool? truncated,
  }) {
    final result = create();
    if (summary != null) result.summary = summary;
    if (truncated != null) result.truncated = truncated;
    return result;
  }

  GetCleaningReportResponse._();

  factory GetCleaningReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCleaningReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCleaningReportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOM<CleaningSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: CleaningSummary.create)
    ..aOB(2, _omitFieldNames ? '' : 'truncated')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCleaningReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCleaningReportResponse copyWith(
          void Function(GetCleaningReportResponse) updates) =>
      super.copyWith((message) => updates(message as GetCleaningReportResponse))
          as GetCleaningReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCleaningReportResponse create() => GetCleaningReportResponse._();
  @$core.override
  GetCleaningReportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCleaningReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCleaningReportResponse>(create);
  static GetCleaningReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CleaningSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(CleaningSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  CleaningSummary ensureSummary() => $_ensure(0);

  /// The window held more tasks than one report may read, so this summarises
  /// some of the hospital rather than all of it.
  @$pb.TagNumber(2)
  $core.bool get truncated => $_getBF(1);
  @$pb.TagNumber(2)
  set truncated($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTruncated() => $_has(1);
  @$pb.TagNumber(2)
  void clearTruncated() => $_clearField(2);
}

class GetTurnaroundReportRequest extends $pb.GeneratedMessage {
  factory GetTurnaroundReportRequest({
    $core.String? facilityId,
    $core.String? zone,
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (zone != null) result.zone = zone;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  GetTurnaroundReportRequest._();

  factory GetTurnaroundReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTurnaroundReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTurnaroundReportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'zone')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTurnaroundReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTurnaroundReportRequest copyWith(
          void Function(GetTurnaroundReportRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetTurnaroundReportRequest))
          as GetTurnaroundReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTurnaroundReportRequest create() => GetTurnaroundReportRequest._();
  @$core.override
  GetTurnaroundReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTurnaroundReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTurnaroundReportRequest>(create);
  static GetTurnaroundReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get zone => $_getSZ(1);
  @$pb.TagNumber(2)
  set zone($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasZone() => $_has(1);
  @$pb.TagNumber(2)
  void clearZone() => $_clearField(2);

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

class GetTurnaroundReportResponse extends $pb.GeneratedMessage {
  factory GetTurnaroundReportResponse({
    TurnaroundSummary? summary,
    $core.bool? truncated,
  }) {
    final result = create();
    if (summary != null) result.summary = summary;
    if (truncated != null) result.truncated = truncated;
    return result;
  }

  GetTurnaroundReportResponse._();

  factory GetTurnaroundReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTurnaroundReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTurnaroundReportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.housekeeping.v1'),
      createEmptyInstance: create)
    ..aOM<TurnaroundSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: TurnaroundSummary.create)
    ..aOB(2, _omitFieldNames ? '' : 'truncated')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTurnaroundReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTurnaroundReportResponse copyWith(
          void Function(GetTurnaroundReportResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetTurnaroundReportResponse))
          as GetTurnaroundReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTurnaroundReportResponse create() =>
      GetTurnaroundReportResponse._();
  @$core.override
  GetTurnaroundReportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTurnaroundReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTurnaroundReportResponse>(create);
  static GetTurnaroundReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TurnaroundSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(TurnaroundSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  TurnaroundSummary ensureSummary() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get truncated => $_getBF(1);
  @$pb.TagNumber(2)
  set truncated($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTruncated() => $_has(1);
  @$pb.TagNumber(2)
  void clearTruncated() => $_clearField(2);
}

/// Housekeeping and environmental services (SRS-HKP-001 … 008).
class HousekeepingServiceApi {
  final $pb.RpcClient _client;

  HousekeepingServiceApi(this._client);

  /// Cleanable locations and their standards (SRS-HKP-001).
  $async.Future<ConfigureLocationResponse> configureLocation(
          $pb.ClientContext? ctx, ConfigureLocationRequest request) =>
      _client.invoke<ConfigureLocationResponse>(ctx, 'HousekeepingService',
          'ConfigureLocation', request, ConfigureLocationResponse());
  $async.Future<ApproveLocationResponse> approveLocation(
          $pb.ClientContext? ctx, ApproveLocationRequest request) =>
      _client.invoke<ApproveLocationResponse>(ctx, 'HousekeepingService',
          'ApproveLocation', request, ApproveLocationResponse());
  $async.Future<ListLocationsResponse> listLocations(
          $pb.ClientContext? ctx, ListLocationsRequest request) =>
      _client.invoke<ListLocationsResponse>(ctx, 'HousekeepingService',
          'ListLocations', request, ListLocationsResponse());
  $async.Future<GetLocationInForceResponse> getLocationInForce(
          $pb.ClientContext? ctx, GetLocationInForceRequest request) =>
      _client.invoke<GetLocationInForceResponse>(ctx, 'HousekeepingService',
          'GetLocationInForce', request, GetLocationInForceResponse());
  $async.Future<ListDueRoutineCleansResponse> listDueRoutineCleans(
          $pb.ClientContext? ctx, ListDueRoutineCleansRequest request) =>
      _client.invoke<ListDueRoutineCleansResponse>(ctx, 'HousekeepingService',
          'ListDueRoutineCleans', request, ListDueRoutineCleansResponse());

  /// Cleaning work (SRS-HKP-002, SRS-HKP-004, SRS-HKP-006).
  $async.Future<RaiseCleaningTaskResponse> raiseCleaningTask(
          $pb.ClientContext? ctx, RaiseCleaningTaskRequest request) =>
      _client.invoke<RaiseCleaningTaskResponse>(ctx, 'HousekeepingService',
          'RaiseCleaningTask', request, RaiseCleaningTaskResponse());
  $async.Future<AssignCleaningTaskResponse> assignCleaningTask(
          $pb.ClientContext? ctx, AssignCleaningTaskRequest request) =>
      _client.invoke<AssignCleaningTaskResponse>(ctx, 'HousekeepingService',
          'AssignCleaningTask', request, AssignCleaningTaskResponse());
  $async.Future<StartCleaningTaskResponse> startCleaningTask(
          $pb.ClientContext? ctx, StartCleaningTaskRequest request) =>
      _client.invoke<StartCleaningTaskResponse>(ctx, 'HousekeepingService',
          'StartCleaningTask', request, StartCleaningTaskResponse());
  $async.Future<CompleteCleaningTaskResponse> completeCleaningTask(
          $pb.ClientContext? ctx, CompleteCleaningTaskRequest request) =>
      _client.invoke<CompleteCleaningTaskResponse>(ctx, 'HousekeepingService',
          'CompleteCleaningTask', request, CompleteCleaningTaskResponse());
  $async.Future<VerifyCleaningTaskResponse> verifyCleaningTask(
          $pb.ClientContext? ctx, VerifyCleaningTaskRequest request) =>
      _client.invoke<VerifyCleaningTaskResponse>(ctx, 'HousekeepingService',
          'VerifyCleaningTask', request, VerifyCleaningTaskResponse());
  $async.Future<CancelCleaningTaskResponse> cancelCleaningTask(
          $pb.ClientContext? ctx, CancelCleaningTaskRequest request) =>
      _client.invoke<CancelCleaningTaskResponse>(ctx, 'HousekeepingService',
          'CancelCleaningTask', request, CancelCleaningTaskResponse());
  $async.Future<GetCleaningTaskResponse> getCleaningTask(
          $pb.ClientContext? ctx, GetCleaningTaskRequest request) =>
      _client.invoke<GetCleaningTaskResponse>(ctx, 'HousekeepingService',
          'GetCleaningTask', request, GetCleaningTaskResponse());
  $async.Future<ListCleaningTasksResponse> listCleaningTasks(
          $pb.ClientContext? ctx, ListCleaningTasksRequest request) =>
      _client.invoke<ListCleaningTasksResponse>(ctx, 'HousekeepingService',
          'ListCleaningTasks', request, ListCleaningTasksResponse());

  /// Overdue critical-area escalation (SRS-HKP-005).
  $async.Future<EscalateOverdueCleansResponse> escalateOverdueCleans(
          $pb.ClientContext? ctx, EscalateOverdueCleansRequest request) =>
      _client.invoke<EscalateOverdueCleansResponse>(ctx, 'HousekeepingService',
          'EscalateOverdueCleans', request, EscalateOverdueCleansResponse());

  /// Location scanning (SRS-HKP-007).
  $async.Future<RecordLocationScanResponse> recordLocationScan(
          $pb.ClientContext? ctx, RecordLocationScanRequest request) =>
      _client.invoke<RecordLocationScanResponse>(ctx, 'HousekeepingService',
          'RecordLocationScan', request, RecordLocationScanResponse());

  /// Bed cleaning holds (SRS-HKP-003).
  $async.Future<TriggerTerminalCleanResponse> triggerTerminalClean(
          $pb.ClientContext? ctx, TriggerTerminalCleanRequest request) =>
      _client.invoke<TriggerTerminalCleanResponse>(ctx, 'HousekeepingService',
          'TriggerTerminalClean', request, TriggerTerminalCleanResponse());
  $async.Future<OverrideBedHoldResponse> overrideBedHold(
          $pb.ClientContext? ctx, OverrideBedHoldRequest request) =>
      _client.invoke<OverrideBedHoldResponse>(ctx, 'HousekeepingService',
          'OverrideBedHold', request, OverrideBedHoldResponse());
  $async.Future<GetBedStatusResponse> getBedStatus(
          $pb.ClientContext? ctx, GetBedStatusRequest request) =>
      _client.invoke<GetBedStatusResponse>(ctx, 'HousekeepingService',
          'GetBedStatus', request, GetBedStatusResponse());
  $async.Future<ListHeldBedsResponse> listHeldBeds(
          $pb.ClientContext? ctx, ListHeldBedsRequest request) =>
      _client.invoke<ListHeldBedsResponse>(ctx, 'HousekeepingService',
          'ListHeldBeds', request, ListHeldBedsResponse());

  /// Reporting (SRS-HKP-008).
  $async.Future<GetCleaningReportResponse> getCleaningReport(
          $pb.ClientContext? ctx, GetCleaningReportRequest request) =>
      _client.invoke<GetCleaningReportResponse>(ctx, 'HousekeepingService',
          'GetCleaningReport', request, GetCleaningReportResponse());
  $async.Future<GetTurnaroundReportResponse> getTurnaroundReport(
          $pb.ClientContext? ctx, GetTurnaroundReportRequest request) =>
      _client.invoke<GetTurnaroundReportResponse>(ctx, 'HousekeepingService',
          'GetTurnaroundReport', request, GetTurnaroundReportResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
