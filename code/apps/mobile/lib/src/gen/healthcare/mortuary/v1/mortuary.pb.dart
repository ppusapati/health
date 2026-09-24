// This is a generated file - do not edit.
//
// Generated from healthcare/mortuary/v1/mortuary.proto.

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

import 'mortuary.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'mortuary.pbenum.dart';

/// One body in the mortuary's care (SRS-MORT-001).
class Case extends $pb.GeneratedMessage {
  factory Case({
    $core.String? caseId,
    $core.String? reference,
    Source? source,
    $core.String? encounterId,
    $core.String? patientId,
    $core.String? externalSource,
    Identity? identity,
    $core.String? identifiedBy,
    $0.Timestamp? identifiedAt,
    $core.String? identifiedNote,
    $core.String? displayName,
    $core.bool? medicoLegal,
    $core.String? mlcReference,
    $core.bool? restricted,
    $core.String? causeSummary,
    $core.String? deathCertificateRef,
    $core.String? certificateRecordedBy,
    $0.Timestamp? certificateRecordedAt,
    CaseState? state,
    $core.String? locationId,
    $core.String? storageTag,
    $0.Timestamp? diedAt,
    $0.Timestamp? receivedAt,
    $core.String? receivedBy,
    $core.String? facilityId,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (reference != null) result.reference = reference;
    if (source != null) result.source = source;
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (externalSource != null) result.externalSource = externalSource;
    if (identity != null) result.identity = identity;
    if (identifiedBy != null) result.identifiedBy = identifiedBy;
    if (identifiedAt != null) result.identifiedAt = identifiedAt;
    if (identifiedNote != null) result.identifiedNote = identifiedNote;
    if (displayName != null) result.displayName = displayName;
    if (medicoLegal != null) result.medicoLegal = medicoLegal;
    if (mlcReference != null) result.mlcReference = mlcReference;
    if (restricted != null) result.restricted = restricted;
    if (causeSummary != null) result.causeSummary = causeSummary;
    if (deathCertificateRef != null)
      result.deathCertificateRef = deathCertificateRef;
    if (certificateRecordedBy != null)
      result.certificateRecordedBy = certificateRecordedBy;
    if (certificateRecordedAt != null)
      result.certificateRecordedAt = certificateRecordedAt;
    if (state != null) result.state = state;
    if (locationId != null) result.locationId = locationId;
    if (storageTag != null) result.storageTag = storageTag;
    if (diedAt != null) result.diedAt = diedAt;
    if (receivedAt != null) result.receivedAt = receivedAt;
    if (receivedBy != null) result.receivedBy = receivedBy;
    if (facilityId != null) result.facilityId = facilityId;
    if (version != null) result.version = version;
    return result;
  }

  Case._();

  factory Case.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Case.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Case',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aE<Source>(3, _omitFieldNames ? '' : 'source', enumValues: Source.values)
    ..aOS(4, _omitFieldNames ? '' : 'encounterId')
    ..aOS(5, _omitFieldNames ? '' : 'patientId')
    ..aOS(6, _omitFieldNames ? '' : 'externalSource')
    ..aE<Identity>(7, _omitFieldNames ? '' : 'identity',
        enumValues: Identity.values)
    ..aOS(8, _omitFieldNames ? '' : 'identifiedBy')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'identifiedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'identifiedNote')
    ..aOS(11, _omitFieldNames ? '' : 'displayName')
    ..aOB(12, _omitFieldNames ? '' : 'medicoLegal')
    ..aOS(13, _omitFieldNames ? '' : 'mlcReference')
    ..aOB(14, _omitFieldNames ? '' : 'restricted')
    ..aOS(15, _omitFieldNames ? '' : 'causeSummary')
    ..aOS(16, _omitFieldNames ? '' : 'deathCertificateRef')
    ..aOS(17, _omitFieldNames ? '' : 'certificateRecordedBy')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'certificateRecordedAt',
        subBuilder: $0.Timestamp.create)
    ..aE<CaseState>(19, _omitFieldNames ? '' : 'state',
        enumValues: CaseState.values)
    ..aOS(20, _omitFieldNames ? '' : 'locationId')
    ..aOS(21, _omitFieldNames ? '' : 'storageTag')
    ..aOM<$0.Timestamp>(22, _omitFieldNames ? '' : 'diedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(23, _omitFieldNames ? '' : 'receivedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(24, _omitFieldNames ? '' : 'receivedBy')
    ..aOS(25, _omitFieldNames ? '' : 'facilityId')
    ..aInt64(26, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Case clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Case copyWith(void Function(Case) updates) =>
      super.copyWith((message) => updates(message as Case)) as Case;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Case create() => Case._();
  @$core.override
  Case createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Case getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Case>(create);
  static Case? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  /// What everybody says out loud: the number on the tag, on the register
  /// and on the paperwork the family carries away.
  @$pb.TagNumber(2)
  $core.String get reference => $_getSZ(1);
  @$pb.TagNumber(2)
  set reference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearReference() => $_clearField(2);

  @$pb.TagNumber(3)
  Source get source => $_getN(2);
  @$pb.TagNumber(3)
  set source(Source value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get encounterId => $_getSZ(3);
  @$pb.TagNumber(4)
  set encounterId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEncounterId() => $_has(3);
  @$pb.TagNumber(4)
  void clearEncounterId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get patientId => $_getSZ(4);
  @$pb.TagNumber(5)
  set patientId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPatientId() => $_has(4);
  @$pb.TagNumber(5)
  void clearPatientId() => $_clearField(5);

  /// Who brought the body in. Set for a brought-in case.
  @$pb.TagNumber(6)
  $core.String get externalSource => $_getSZ(5);
  @$pb.TagNumber(6)
  set externalSource($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExternalSource() => $_has(5);
  @$pb.TagNumber(6)
  void clearExternalSource() => $_clearField(6);

  @$pb.TagNumber(7)
  Identity get identity => $_getN(6);
  @$pb.TagNumber(7)
  set identity(Identity value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasIdentity() => $_has(6);
  @$pb.TagNumber(7)
  void clearIdentity() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get identifiedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set identifiedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIdentifiedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearIdentifiedBy() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get identifiedAt => $_getN(8);
  @$pb.TagNumber(9)
  set identifiedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasIdentifiedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearIdentifiedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureIdentifiedAt() => $_ensure(8);

  /// How it was confirmed: a relative who knew them, a dental record, a
  /// document with a photograph. Required for a confirmed identification.
  @$pb.TagNumber(10)
  $core.String get identifiedNote => $_getSZ(9);
  @$pb.TagNumber(10)
  set identifiedNote($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIdentifiedNote() => $_has(9);
  @$pb.TagNumber(10)
  void clearIdentifiedNote() => $_clearField(10);

  /// Blank for an unidentified body, where the reference is the only name
  /// there is.
  @$pb.TagNumber(11)
  $core.String get displayName => $_getSZ(10);
  @$pb.TagNumber(11)
  set displayName($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDisplayName() => $_has(10);
  @$pb.TagNumber(11)
  void clearDisplayName() => $_clearField(11);

  /// A case an authority has an interest in. Decides whether a release needs
  /// clearance, and there is no RPC that clears it.
  @$pb.TagNumber(12)
  $core.bool get medicoLegal => $_getBF(11);
  @$pb.TagNumber(12)
  set medicoLegal($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMedicoLegal() => $_has(11);
  @$pb.TagNumber(12)
  void clearMedicoLegal() => $_clearField(12);

  /// The police or coroner's own number. Sensitive: carried only for a
  /// caller holding mort.sensitive.read.
  @$pb.TagNumber(13)
  $core.String get mlcReference => $_getSZ(12);
  @$pb.TagNumber(13)
  set mlcReference($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasMlcReference() => $_has(12);
  @$pb.TagNumber(13)
  void clearMlcReference() => $_clearField(13);

  /// A case whose detail is not on the ordinary board. The board shows its
  /// reference and no name.
  @$pb.TagNumber(14)
  $core.bool get restricted => $_getBF(13);
  @$pb.TagNumber(14)
  set restricted($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRestricted() => $_has(13);
  @$pb.TagNumber(14)
  void clearRestricted() => $_clearField(14);

  /// Sensitive. Carried only for a caller holding mort.sensitive.read, and
  /// that read is audited each time.
  @$pb.TagNumber(15)
  $core.String get causeSummary => $_getSZ(14);
  @$pb.TagNumber(15)
  set causeSummary($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasCauseSummary() => $_has(14);
  @$pb.TagNumber(15)
  void clearCauseSummary() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get deathCertificateRef => $_getSZ(15);
  @$pb.TagNumber(16)
  set deathCertificateRef($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasDeathCertificateRef() => $_has(15);
  @$pb.TagNumber(16)
  void clearDeathCertificateRef() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get certificateRecordedBy => $_getSZ(16);
  @$pb.TagNumber(17)
  set certificateRecordedBy($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasCertificateRecordedBy() => $_has(16);
  @$pb.TagNumber(17)
  void clearCertificateRecordedBy() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get certificateRecordedAt => $_getN(17);
  @$pb.TagNumber(18)
  set certificateRecordedAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasCertificateRecordedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearCertificateRecordedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureCertificateRecordedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  CaseState get state => $_getN(18);
  @$pb.TagNumber(19)
  set state(CaseState value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasState() => $_has(18);
  @$pb.TagNumber(19)
  void clearState() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get locationId => $_getSZ(19);
  @$pb.TagNumber(20)
  set locationId($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasLocationId() => $_has(19);
  @$pb.TagNumber(20)
  void clearLocationId() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get storageTag => $_getSZ(20);
  @$pb.TagNumber(21)
  set storageTag($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasStorageTag() => $_has(20);
  @$pb.TagNumber(21)
  void clearStorageTag() => $_clearField(21);

  @$pb.TagNumber(22)
  $0.Timestamp get diedAt => $_getN(21);
  @$pb.TagNumber(22)
  set diedAt($0.Timestamp value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasDiedAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearDiedAt() => $_clearField(22);
  @$pb.TagNumber(22)
  $0.Timestamp ensureDiedAt() => $_ensure(21);

  @$pb.TagNumber(23)
  $0.Timestamp get receivedAt => $_getN(22);
  @$pb.TagNumber(23)
  set receivedAt($0.Timestamp value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasReceivedAt() => $_has(22);
  @$pb.TagNumber(23)
  void clearReceivedAt() => $_clearField(23);
  @$pb.TagNumber(23)
  $0.Timestamp ensureReceivedAt() => $_ensure(22);

  @$pb.TagNumber(24)
  $core.String get receivedBy => $_getSZ(23);
  @$pb.TagNumber(24)
  set receivedBy($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasReceivedBy() => $_has(23);
  @$pb.TagNumber(24)
  void clearReceivedBy() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.String get facilityId => $_getSZ(24);
  @$pb.TagNumber(25)
  set facilityId($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasFacilityId() => $_has(24);
  @$pb.TagNumber(25)
  void clearFacilityId() => $_clearField(25);

  @$pb.TagNumber(26)
  $fixnum.Int64 get version => $_getI64(25);
  @$pb.TagNumber(26)
  set version($fixnum.Int64 value) => $_setInt64(25, value);
  @$pb.TagNumber(26)
  $core.bool hasVersion() => $_has(25);
  @$pb.TagNumber(26)
  void clearVersion() => $_clearField(26);
}

/// One storage space (SRS-MORT-002).
class Location extends $pb.GeneratedMessage {
  factory Location({
    $core.String? locationId,
    $core.String? code,
    SpaceKind? kind,
    $core.String? facilityId,
    $core.String? zone,
    $core.bool? outOfService,
    $core.String? outOfServiceReason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    if (code != null) result.code = code;
    if (kind != null) result.kind = kind;
    if (facilityId != null) result.facilityId = facilityId;
    if (zone != null) result.zone = zone;
    if (outOfService != null) result.outOfService = outOfService;
    if (outOfServiceReason != null)
      result.outOfServiceReason = outOfServiceReason;
    if (version != null) result.version = version;
    return result;
  }

  Location._();

  factory Location.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Location.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Location',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aE<SpaceKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: SpaceKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'zone')
    ..aOB(6, _omitFieldNames ? '' : 'outOfService')
    ..aOS(7, _omitFieldNames ? '' : 'outOfServiceReason')
    ..aInt64(8, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Location clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Location copyWith(void Function(Location) updates) =>
      super.copyWith((message) => updates(message as Location)) as Location;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Location create() => Location._();
  @$core.override
  Location createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Location getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Location>(create);
  static Location? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

  /// What is painted on the door.
  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  SpaceKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(SpaceKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

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

  /// A broken unit is still a space, and the bodies that were in it last
  /// month were in it.
  @$pb.TagNumber(6)
  $core.bool get outOfService => $_getBF(5);
  @$pb.TagNumber(6)
  set outOfService($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOutOfService() => $_has(5);
  @$pb.TagNumber(6)
  void clearOutOfService() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get outOfServiceReason => $_getSZ(6);
  @$pb.TagNumber(7)
  set outOfServiceReason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOutOfServiceReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearOutOfServiceReason() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get version => $_getI64(7);
  @$pb.TagNumber(8)
  set version($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVersion() => $_has(7);
  @$pb.TagNumber(8)
  void clearVersion() => $_clearField(8);
}

/// One body in one space for one period (SRS-MORT-002).
class Placement extends $pb.GeneratedMessage {
  factory Placement({
    $core.String? placementId,
    $core.String? caseId,
    $core.String? locationId,
    $core.String? storageTag,
    PlacementState? state,
    $core.String? identityCheckedBy,
    $core.String? identityCheckedNote,
    $0.Timestamp? placedAt,
    $core.String? placedBy,
    $0.Timestamp? endedAt,
    $core.String? endedBy,
    $core.String? endedReason,
  }) {
    final result = create();
    if (placementId != null) result.placementId = placementId;
    if (caseId != null) result.caseId = caseId;
    if (locationId != null) result.locationId = locationId;
    if (storageTag != null) result.storageTag = storageTag;
    if (state != null) result.state = state;
    if (identityCheckedBy != null) result.identityCheckedBy = identityCheckedBy;
    if (identityCheckedNote != null)
      result.identityCheckedNote = identityCheckedNote;
    if (placedAt != null) result.placedAt = placedAt;
    if (placedBy != null) result.placedBy = placedBy;
    if (endedAt != null) result.endedAt = endedAt;
    if (endedBy != null) result.endedBy = endedBy;
    if (endedReason != null) result.endedReason = endedReason;
    return result;
  }

  Placement._();

  factory Placement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Placement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Placement',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'placementId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aOS(3, _omitFieldNames ? '' : 'locationId')
    ..aOS(4, _omitFieldNames ? '' : 'storageTag')
    ..aE<PlacementState>(5, _omitFieldNames ? '' : 'state',
        enumValues: PlacementState.values)
    ..aOS(6, _omitFieldNames ? '' : 'identityCheckedBy')
    ..aOS(7, _omitFieldNames ? '' : 'identityCheckedNote')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'placedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'placedBy')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'endedBy')
    ..aOS(12, _omitFieldNames ? '' : 'endedReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Placement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Placement copyWith(void Function(Placement) updates) =>
      super.copyWith((message) => updates(message as Placement)) as Placement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Placement create() => Placement._();
  @$core.override
  Placement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Placement getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Placement>(create);
  static Placement? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get placementId => $_getSZ(0);
  @$pb.TagNumber(1)
  set placementId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlacementId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlacementId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationId() => $_clearField(3);

  /// What the person opening the drawer actually reads.
  @$pb.TagNumber(4)
  $core.String get storageTag => $_getSZ(3);
  @$pb.TagNumber(4)
  set storageTag($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStorageTag() => $_has(3);
  @$pb.TagNumber(4)
  void clearStorageTag() => $_clearField(4);

  @$pb.TagNumber(5)
  PlacementState get state => $_getN(4);
  @$pb.TagNumber(5)
  set state(PlacementState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasState() => $_has(4);
  @$pb.TagNumber(5)
  void clearState() => $_clearField(5);

  /// The positive identity check made at the moment of placing, and what was
  /// checked against what.
  @$pb.TagNumber(6)
  $core.String get identityCheckedBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set identityCheckedBy($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIdentityCheckedBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearIdentityCheckedBy() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get identityCheckedNote => $_getSZ(6);
  @$pb.TagNumber(7)
  set identityCheckedNote($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIdentityCheckedNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearIdentityCheckedNote() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get placedAt => $_getN(7);
  @$pb.TagNumber(8)
  set placedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPlacedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlacedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensurePlacedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get placedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set placedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPlacedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearPlacedBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get endedAt => $_getN(9);
  @$pb.TagNumber(10)
  set endedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasEndedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearEndedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureEndedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get endedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set endedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasEndedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearEndedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get endedReason => $_getSZ(11);
  @$pb.TagNumber(12)
  set endedReason($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasEndedReason() => $_has(11);
  @$pb.TagNumber(12)
  void clearEndedReason() => $_clearField(12);
}

/// One belonging (SRS-MORT-004).
class Item extends $pb.GeneratedMessage {
  factory Item({
    $core.String? itemId,
    $core.String? caseId,
    ItemKind? kind,
    $core.String? description,
    $core.int? quantity,
    ItemState? state,
    $core.String? sealNumber,
    $0.Timestamp? listedAt,
    $core.String? listedBy,
    $core.String? witnessedBy,
    $core.String? handoverId,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (caseId != null) result.caseId = caseId;
    if (kind != null) result.kind = kind;
    if (description != null) result.description = description;
    if (quantity != null) result.quantity = quantity;
    if (state != null) result.state = state;
    if (sealNumber != null) result.sealNumber = sealNumber;
    if (listedAt != null) result.listedAt = listedAt;
    if (listedBy != null) result.listedBy = listedBy;
    if (witnessedBy != null) result.witnessedBy = witnessedBy;
    if (handoverId != null) result.handoverId = handoverId;
    return result;
  }

  Item._();

  factory Item.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Item.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Item',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aE<ItemKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: ItemKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aI(5, _omitFieldNames ? '' : 'quantity')
    ..aE<ItemState>(6, _omitFieldNames ? '' : 'state',
        enumValues: ItemState.values)
    ..aOS(7, _omitFieldNames ? '' : 'sealNumber')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'listedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'listedBy')
    ..aOS(10, _omitFieldNames ? '' : 'witnessedBy')
    ..aOS(11, _omitFieldNames ? '' : 'handoverId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Item clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Item copyWith(void Function(Item) updates) =>
      super.copyWith((message) => updates(message as Item)) as Item;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Item create() => Item._();
  @$core.override
  Item createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Item getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Item>(create);
  static Item? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  @$pb.TagNumber(3)
  ItemKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(ItemKind value) => $_setField(3, value);
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

  /// "Three rings" is a different listing from "a ring".
  @$pb.TagNumber(5)
  $core.int get quantity => $_getIZ(4);
  @$pb.TagNumber(5)
  set quantity($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuantity() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuantity() => $_clearField(5);

  @$pb.TagNumber(6)
  ItemState get state => $_getN(5);
  @$pb.TagNumber(6)
  set state(ItemState value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasState() => $_has(5);
  @$pb.TagNumber(6)
  void clearState() => $_clearField(6);

  /// The tamper-evident bag it went into. Required for a valuable.
  @$pb.TagNumber(7)
  $core.String get sealNumber => $_getSZ(6);
  @$pb.TagNumber(7)
  set sealNumber($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSealNumber() => $_has(6);
  @$pb.TagNumber(7)
  void clearSealNumber() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get listedAt => $_getN(7);
  @$pb.TagNumber(8)
  set listedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasListedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearListedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureListedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get listedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set listedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasListedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearListedBy() => $_clearField(9);

  /// The second person present at the listing. Required for a valuable.
  @$pb.TagNumber(10)
  $core.String get witnessedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set witnessedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasWitnessedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearWitnessedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get handoverId => $_getSZ(10);
  @$pb.TagNumber(11)
  set handoverId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasHandoverId() => $_has(10);
  @$pb.TagNumber(11)
  void clearHandoverId() => $_clearField(11);
}

/// One act of giving belongings to somebody (SRS-MORT-004).
class Handover extends $pb.GeneratedMessage {
  factory Handover({
    $core.String? handoverId,
    $core.String? caseId,
    $core.String? recipientName,
    $core.String? recipientRelation,
    $core.String? recipientIdType,
    $core.String? recipientIdRef,
    $core.String? signatureRef,
    $core.Iterable<$core.String>? itemIds,
    $0.Timestamp? handedAt,
    $core.String? handedBy,
    $core.String? witnessedBy,
    $core.String? note,
  }) {
    final result = create();
    if (handoverId != null) result.handoverId = handoverId;
    if (caseId != null) result.caseId = caseId;
    if (recipientName != null) result.recipientName = recipientName;
    if (recipientRelation != null) result.recipientRelation = recipientRelation;
    if (recipientIdType != null) result.recipientIdType = recipientIdType;
    if (recipientIdRef != null) result.recipientIdRef = recipientIdRef;
    if (signatureRef != null) result.signatureRef = signatureRef;
    if (itemIds != null) result.itemIds.addAll(itemIds);
    if (handedAt != null) result.handedAt = handedAt;
    if (handedBy != null) result.handedBy = handedBy;
    if (witnessedBy != null) result.witnessedBy = witnessedBy;
    if (note != null) result.note = note;
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
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'handoverId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aOS(3, _omitFieldNames ? '' : 'recipientName')
    ..aOS(4, _omitFieldNames ? '' : 'recipientRelation')
    ..aOS(5, _omitFieldNames ? '' : 'recipientIdType')
    ..aOS(6, _omitFieldNames ? '' : 'recipientIdRef')
    ..aOS(7, _omitFieldNames ? '' : 'signatureRef')
    ..pPS(8, _omitFieldNames ? '' : 'itemIds')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'handedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'handedBy')
    ..aOS(11, _omitFieldNames ? '' : 'witnessedBy')
    ..aOS(12, _omitFieldNames ? '' : 'note')
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
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get recipientName => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipientName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecipientName() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipientName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get recipientRelation => $_getSZ(3);
  @$pb.TagNumber(4)
  set recipientRelation($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRecipientRelation() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecipientRelation() => $_clearField(4);

  /// The document the mortuary checked. Belongings handed to somebody nobody
  /// asked for identification from is the story that ends in a complaint.
  @$pb.TagNumber(5)
  $core.String get recipientIdType => $_getSZ(4);
  @$pb.TagNumber(5)
  set recipientIdType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRecipientIdType() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecipientIdType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get recipientIdRef => $_getSZ(5);
  @$pb.TagNumber(6)
  set recipientIdRef($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRecipientIdRef() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecipientIdRef() => $_clearField(6);

  /// A reference to the signed register page, not an image: the document
  /// lives where documents live.
  @$pb.TagNumber(7)
  $core.String get signatureRef => $_getSZ(6);
  @$pb.TagNumber(7)
  set signatureRef($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSignatureRef() => $_has(6);
  @$pb.TagNumber(7)
  void clearSignatureRef() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get itemIds => $_getList(7);

  @$pb.TagNumber(9)
  $0.Timestamp get handedAt => $_getN(8);
  @$pb.TagNumber(9)
  set handedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasHandedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearHandedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureHandedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get handedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set handedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasHandedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearHandedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get witnessedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set witnessedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasWitnessedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearWitnessedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get note => $_getSZ(11);
  @$pb.TagNumber(12)
  set note($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasNote() => $_has(11);
  @$pb.TagNumber(12)
  void clearNote() => $_clearField(12);
}

/// One line of the chain of custody (SRS-MORT-004).
///
/// Append-only. A chain somebody can edit says whatever the last person to
/// touch it wanted it to say.
class CustodyEntry extends $pb.GeneratedMessage {
  factory CustodyEntry({
    $core.String? entryId,
    $core.String? caseId,
    $core.String? event,
    $core.String? detail,
    $core.String? fromParty,
    $core.String? toParty,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (entryId != null) result.entryId = entryId;
    if (caseId != null) result.caseId = caseId;
    if (event != null) result.event = event;
    if (detail != null) result.detail = detail;
    if (fromParty != null) result.fromParty = fromParty;
    if (toParty != null) result.toParty = toParty;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  CustodyEntry._();

  factory CustodyEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CustodyEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CustodyEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'entryId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aOS(3, _omitFieldNames ? '' : 'event')
    ..aOS(4, _omitFieldNames ? '' : 'detail')
    ..aOS(5, _omitFieldNames ? '' : 'fromParty')
    ..aOS(6, _omitFieldNames ? '' : 'toParty')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CustodyEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CustodyEntry copyWith(void Function(CustodyEntry) updates) =>
      super.copyWith((message) => updates(message as CustodyEntry))
          as CustodyEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CustodyEntry create() => CustodyEntry._();
  @$core.override
  CustodyEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CustodyEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CustodyEntry>(create);
  static CustodyEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set entryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get event => $_getSZ(2);
  @$pb.TagNumber(3)
  set event($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEvent() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvent() => $_clearField(3);

  /// The short human line beside it. No cause of death and no medico-legal
  /// narrative: the chain is read more widely than the case.
  @$pb.TagNumber(4)
  $core.String get detail => $_getSZ(3);
  @$pb.TagNumber(4)
  set detail($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDetail() => $_has(3);
  @$pb.TagNumber(4)
  void clearDetail() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get fromParty => $_getSZ(4);
  @$pb.TagNumber(5)
  set fromParty($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFromParty() => $_has(4);
  @$pb.TagNumber(5)
  void clearFromParty() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get toParty => $_getSZ(5);
  @$pb.TagNumber(6)
  set toParty($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasToParty() => $_has(5);
  @$pb.TagNumber(6)
  void clearToParty() => $_clearField(6);

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

/// One examination request and what became of it (SRS-MORT-005).
class Postmortem extends $pb.GeneratedMessage {
  factory Postmortem({
    $core.String? postmortemId,
    $core.String? caseId,
    PostmortemKind? kind,
    $core.String? reason,
    PostmortemState? state,
    $core.String? authority,
    $core.String? authorityReference,
    $core.String? authorisedBy,
    $0.Timestamp? authorisedAt,
    $core.String? performedBy,
    $0.Timestamp? performedAt,
    $core.String? reportRef,
    $0.Timestamp? reportedAt,
    $core.String? declineReason,
    $0.Timestamp? requestedAt,
    $core.String? requestedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (postmortemId != null) result.postmortemId = postmortemId;
    if (caseId != null) result.caseId = caseId;
    if (kind != null) result.kind = kind;
    if (reason != null) result.reason = reason;
    if (state != null) result.state = state;
    if (authority != null) result.authority = authority;
    if (authorityReference != null)
      result.authorityReference = authorityReference;
    if (authorisedBy != null) result.authorisedBy = authorisedBy;
    if (authorisedAt != null) result.authorisedAt = authorisedAt;
    if (performedBy != null) result.performedBy = performedBy;
    if (performedAt != null) result.performedAt = performedAt;
    if (reportRef != null) result.reportRef = reportRef;
    if (reportedAt != null) result.reportedAt = reportedAt;
    if (declineReason != null) result.declineReason = declineReason;
    if (requestedAt != null) result.requestedAt = requestedAt;
    if (requestedBy != null) result.requestedBy = requestedBy;
    if (version != null) result.version = version;
    return result;
  }

  Postmortem._();

  factory Postmortem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Postmortem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Postmortem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'postmortemId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aE<PostmortemKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: PostmortemKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aE<PostmortemState>(5, _omitFieldNames ? '' : 'state',
        enumValues: PostmortemState.values)
    ..aOS(6, _omitFieldNames ? '' : 'authority')
    ..aOS(7, _omitFieldNames ? '' : 'authorityReference')
    ..aOS(8, _omitFieldNames ? '' : 'authorisedBy')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'authorisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'performedBy')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'performedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'reportRef')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'reportedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(14, _omitFieldNames ? '' : 'declineReason')
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'requestedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'requestedBy')
    ..aInt64(17, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Postmortem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Postmortem copyWith(void Function(Postmortem) updates) =>
      super.copyWith((message) => updates(message as Postmortem)) as Postmortem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Postmortem create() => Postmortem._();
  @$core.override
  Postmortem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Postmortem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Postmortem>(create);
  static Postmortem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get postmortemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set postmortemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPostmortemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPostmortemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  @$pb.TagNumber(3)
  PostmortemKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(PostmortemKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  PostmortemState get state => $_getN(4);
  @$pb.TagNumber(5)
  set state(PostmortemState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasState() => $_has(4);
  @$pb.TagNumber(5)
  void clearState() => $_clearField(5);

  /// The body that authorised it, and their own reference. The two travel
  /// together: a name with no reference is not something anybody can check.
  @$pb.TagNumber(6)
  $core.String get authority => $_getSZ(5);
  @$pb.TagNumber(6)
  set authority($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAuthority() => $_has(5);
  @$pb.TagNumber(6)
  void clearAuthority() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get authorityReference => $_getSZ(6);
  @$pb.TagNumber(7)
  set authorityReference($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAuthorityReference() => $_has(6);
  @$pb.TagNumber(7)
  void clearAuthorityReference() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get authorisedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set authorisedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAuthorisedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearAuthorisedBy() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get authorisedAt => $_getN(8);
  @$pb.TagNumber(9)
  set authorisedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasAuthorisedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearAuthorisedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureAuthorisedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get performedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set performedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPerformedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearPerformedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get performedAt => $_getN(10);
  @$pb.TagNumber(11)
  set performedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasPerformedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearPerformedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensurePerformedAt() => $_ensure(10);

  /// A reference rather than the text: a postmortem report is a clinical
  /// document with its own access rules.
  @$pb.TagNumber(12)
  $core.String get reportRef => $_getSZ(11);
  @$pb.TagNumber(12)
  set reportRef($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasReportRef() => $_has(11);
  @$pb.TagNumber(12)
  void clearReportRef() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get reportedAt => $_getN(12);
  @$pb.TagNumber(13)
  set reportedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasReportedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearReportedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureReportedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get declineReason => $_getSZ(13);
  @$pb.TagNumber(14)
  set declineReason($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasDeclineReason() => $_has(13);
  @$pb.TagNumber(14)
  void clearDeclineReason() => $_clearField(14);

  @$pb.TagNumber(15)
  $0.Timestamp get requestedAt => $_getN(14);
  @$pb.TagNumber(15)
  set requestedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasRequestedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearRequestedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureRequestedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get requestedBy => $_getSZ(15);
  @$pb.TagNumber(16)
  set requestedBy($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasRequestedBy() => $_has(15);
  @$pb.TagNumber(16)
  void clearRequestedBy() => $_clearField(16);

  @$pb.TagNumber(17)
  $fixnum.Int64 get version => $_getI64(16);
  @$pb.TagNumber(17)
  set version($fixnum.Int64 value) => $_setInt64(16, value);
  @$pb.TagNumber(17)
  $core.bool hasVersion() => $_has(16);
  @$pb.TagNumber(17)
  void clearVersion() => $_clearField(17);
}

/// An external clearance to release (SRS-MORT-006, SRS-MORT-007).
class Authorisation extends $pb.GeneratedMessage {
  factory Authorisation({
    $core.String? authority,
    $core.String? reference,
    $core.String? recordedBy,
    $0.Timestamp? recordedAt,
    $core.String? note,
  }) {
    final result = create();
    if (authority != null) result.authority = authority;
    if (reference != null) result.reference = reference;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (note != null) result.note = note;
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
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'authority')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aOS(3, _omitFieldNames ? '' : 'recordedBy')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'note')
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
  $core.String get authority => $_getSZ(0);
  @$pb.TagNumber(1)
  set authority($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAuthority() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthority() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reference => $_getSZ(1);
  @$pb.TagNumber(2)
  set reference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearReference() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get recordedBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set recordedBy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecordedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecordedBy() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get recordedAt => $_getN(3);
  @$pb.TagNumber(4)
  set recordedAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRecordedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecordedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureRecordedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get note => $_getSZ(4);
  @$pb.TagNumber(5)
  set note($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNote() => $_has(4);
  @$pb.TagNumber(5)
  void clearNote() => $_clearField(5);
}

/// One thing standing between a case and the door (SRS-MORT-006).
class ReleaseCheck extends $pb.GeneratedMessage {
  factory ReleaseCheck({
    $core.String? code,
    $core.String? detail,
    $core.bool? mandatory,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (detail != null) result.detail = detail;
    if (mandatory != null) result.mandatory = mandatory;
    return result;
  }

  ReleaseCheck._();

  factory ReleaseCheck.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseCheck.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseCheck',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'detail')
    ..aOB(3, _omitFieldNames ? '' : 'mandatory')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseCheck clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseCheck copyWith(void Function(ReleaseCheck) updates) =>
      super.copyWith((message) => updates(message as ReleaseCheck))
          as ReleaseCheck;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseCheck create() => ReleaseCheck._();
  @$core.override
  ReleaseCheck createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseCheck getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseCheck>(create);
  static ReleaseCheck? _defaultInstance;

  /// Stable and machine-readable, so a screen can show the right button
  /// beside it rather than matching on a sentence.
  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get detail => $_getSZ(1);
  @$pb.TagNumber(2)
  set detail($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDetail() => $_has(1);
  @$pb.TagNumber(2)
  void clearDetail() => $_clearField(2);

  /// A check no policy can switch off (SRS-MORT-007).
  @$pb.TagNumber(3)
  $core.bool get mandatory => $_getBF(2);
  @$pb.TagNumber(3)
  set mandatory($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMandatory() => $_has(2);
  @$pb.TagNumber(3)
  void clearMandatory() => $_clearField(3);
}

/// The record of a body leaving (SRS-MORT-006).
class Release extends $pb.GeneratedMessage {
  factory Release({
    $core.String? releaseId,
    $core.String? caseId,
    $core.String? recipientName,
    $core.String? recipientRelation,
    $core.String? recipientIdType,
    $core.String? recipientIdRef,
    $core.String? verificationNote,
    $core.String? signatureRef,
    $core.String? destination,
    $core.String? deathCertificateRef,
    $core.bool? medicoLegal,
    $core.String? authority,
    $core.String? authorityReference,
    $0.Timestamp? releasedAt,
    $core.String? releasedBy,
    $core.String? witnessedBy,
    $core.String? note,
  }) {
    final result = create();
    if (releaseId != null) result.releaseId = releaseId;
    if (caseId != null) result.caseId = caseId;
    if (recipientName != null) result.recipientName = recipientName;
    if (recipientRelation != null) result.recipientRelation = recipientRelation;
    if (recipientIdType != null) result.recipientIdType = recipientIdType;
    if (recipientIdRef != null) result.recipientIdRef = recipientIdRef;
    if (verificationNote != null) result.verificationNote = verificationNote;
    if (signatureRef != null) result.signatureRef = signatureRef;
    if (destination != null) result.destination = destination;
    if (deathCertificateRef != null)
      result.deathCertificateRef = deathCertificateRef;
    if (medicoLegal != null) result.medicoLegal = medicoLegal;
    if (authority != null) result.authority = authority;
    if (authorityReference != null)
      result.authorityReference = authorityReference;
    if (releasedAt != null) result.releasedAt = releasedAt;
    if (releasedBy != null) result.releasedBy = releasedBy;
    if (witnessedBy != null) result.witnessedBy = witnessedBy;
    if (note != null) result.note = note;
    return result;
  }

  Release._();

  factory Release.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Release.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Release',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'releaseId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..aOS(3, _omitFieldNames ? '' : 'recipientName')
    ..aOS(4, _omitFieldNames ? '' : 'recipientRelation')
    ..aOS(5, _omitFieldNames ? '' : 'recipientIdType')
    ..aOS(6, _omitFieldNames ? '' : 'recipientIdRef')
    ..aOS(7, _omitFieldNames ? '' : 'verificationNote')
    ..aOS(8, _omitFieldNames ? '' : 'signatureRef')
    ..aOS(9, _omitFieldNames ? '' : 'destination')
    ..aOS(10, _omitFieldNames ? '' : 'deathCertificateRef')
    ..aOB(11, _omitFieldNames ? '' : 'medicoLegal')
    ..aOS(12, _omitFieldNames ? '' : 'authority')
    ..aOS(13, _omitFieldNames ? '' : 'authorityReference')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'releasedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'releasedBy')
    ..aOS(16, _omitFieldNames ? '' : 'witnessedBy')
    ..aOS(17, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Release clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Release copyWith(void Function(Release) updates) =>
      super.copyWith((message) => updates(message as Release)) as Release;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Release create() => Release._();
  @$core.override
  Release createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Release getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Release>(create);
  static Release? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get releaseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set releaseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReleaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReleaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get recipientName => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipientName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecipientName() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipientName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get recipientRelation => $_getSZ(3);
  @$pb.TagNumber(4)
  set recipientRelation($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRecipientRelation() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecipientRelation() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get recipientIdType => $_getSZ(4);
  @$pb.TagNumber(5)
  set recipientIdType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRecipientIdType() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecipientIdType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get recipientIdRef => $_getSZ(5);
  @$pb.TagNumber(6)
  set recipientIdRef($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRecipientIdRef() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecipientIdRef() => $_clearField(6);

  /// What was verified and against what. The acceptance asks for
  /// verification, and a tick is not one.
  @$pb.TagNumber(7)
  $core.String get verificationNote => $_getSZ(6);
  @$pb.TagNumber(7)
  set verificationNote($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVerificationNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearVerificationNote() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get signatureRef => $_getSZ(7);
  @$pb.TagNumber(8)
  set signatureRef($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSignatureRef() => $_has(7);
  @$pb.TagNumber(8)
  void clearSignatureRef() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get destination => $_getSZ(8);
  @$pb.TagNumber(9)
  set destination($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDestination() => $_has(8);
  @$pb.TagNumber(9)
  void clearDestination() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get deathCertificateRef => $_getSZ(9);
  @$pb.TagNumber(10)
  set deathCertificateRef($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDeathCertificateRef() => $_has(9);
  @$pb.TagNumber(10)
  void clearDeathCertificateRef() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get medicoLegal => $_getBF(10);
  @$pb.TagNumber(11)
  set medicoLegal($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMedicoLegal() => $_has(10);
  @$pb.TagNumber(11)
  void clearMedicoLegal() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get authority => $_getSZ(11);
  @$pb.TagNumber(12)
  set authority($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAuthority() => $_has(11);
  @$pb.TagNumber(12)
  void clearAuthority() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get authorityReference => $_getSZ(12);
  @$pb.TagNumber(13)
  set authorityReference($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasAuthorityReference() => $_has(12);
  @$pb.TagNumber(13)
  void clearAuthorityReference() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get releasedAt => $_getN(13);
  @$pb.TagNumber(14)
  set releasedAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasReleasedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearReleasedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureReleasedAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get releasedBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set releasedBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasReleasedBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearReleasedBy() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get witnessedBy => $_getSZ(15);
  @$pb.TagNumber(16)
  set witnessedBy($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasWitnessedBy() => $_has(15);
  @$pb.TagNumber(16)
  void clearWitnessedBy() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get note => $_getSZ(16);
  @$pb.TagNumber(17)
  set note($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasNote() => $_has(16);
  @$pb.TagNumber(17)
  void clearNote() => $_clearField(17);
}

/// One row of the occupancy board (SRS-MORT-003, SRS-MORT-008).
///
/// No cause of death and no medico-legal reference: this message has no field
/// for either, which is what makes "without unnecessary clinical detail" a
/// property of the contract rather than of whoever writes the next screen.
class BoardRow extends $pb.GeneratedMessage {
  factory BoardRow({
    $core.String? caseId,
    $core.String? reference,
    $core.String? locationId,
    $core.String? storageTag,
    CaseState? state,
    $core.String? displayName,
    $core.bool? medicoLegal,
    Identity? identity,
    $0.Timestamp? receivedAt,
    $core.int? heldHours,
    $core.bool? pendingRelease,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (reference != null) result.reference = reference;
    if (locationId != null) result.locationId = locationId;
    if (storageTag != null) result.storageTag = storageTag;
    if (state != null) result.state = state;
    if (displayName != null) result.displayName = displayName;
    if (medicoLegal != null) result.medicoLegal = medicoLegal;
    if (identity != null) result.identity = identity;
    if (receivedAt != null) result.receivedAt = receivedAt;
    if (heldHours != null) result.heldHours = heldHours;
    if (pendingRelease != null) result.pendingRelease = pendingRelease;
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
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aOS(3, _omitFieldNames ? '' : 'locationId')
    ..aOS(4, _omitFieldNames ? '' : 'storageTag')
    ..aE<CaseState>(5, _omitFieldNames ? '' : 'state',
        enumValues: CaseState.values)
    ..aOS(6, _omitFieldNames ? '' : 'displayName')
    ..aOB(7, _omitFieldNames ? '' : 'medicoLegal')
    ..aE<Identity>(8, _omitFieldNames ? '' : 'identity',
        enumValues: Identity.values)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'receivedAt',
        subBuilder: $0.Timestamp.create)
    ..aI(10, _omitFieldNames ? '' : 'heldHours')
    ..aOB(11, _omitFieldNames ? '' : 'pendingRelease')
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
  $core.String get locationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get storageTag => $_getSZ(3);
  @$pb.TagNumber(4)
  set storageTag($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStorageTag() => $_has(3);
  @$pb.TagNumber(4)
  void clearStorageTag() => $_clearField(4);

  @$pb.TagNumber(5)
  CaseState get state => $_getN(4);
  @$pb.TagNumber(5)
  set state(CaseState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasState() => $_has(4);
  @$pb.TagNumber(5)
  void clearState() => $_clearField(5);

  /// Blank for a restricted case. The reference is what the board shows
  /// instead.
  @$pb.TagNumber(6)
  $core.String get displayName => $_getSZ(5);
  @$pb.TagNumber(6)
  set displayName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDisplayName() => $_has(5);
  @$pb.TagNumber(6)
  void clearDisplayName() => $_clearField(6);

  /// A flag and not a reference: an attendant needs to know a case needs
  /// clearance before they move it.
  @$pb.TagNumber(7)
  $core.bool get medicoLegal => $_getBF(6);
  @$pb.TagNumber(7)
  set medicoLegal($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMedicoLegal() => $_has(6);
  @$pb.TagNumber(7)
  void clearMedicoLegal() => $_clearField(7);

  @$pb.TagNumber(8)
  Identity get identity => $_getN(7);
  @$pb.TagNumber(8)
  set identity(Identity value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasIdentity() => $_has(7);
  @$pb.TagNumber(8)
  void clearIdentity() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get receivedAt => $_getN(8);
  @$pb.TagNumber(9)
  set receivedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasReceivedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearReceivedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureReceivedAt() => $_ensure(8);

  /// How long the body has been here, which is the number a mortuary
  /// actually manages by.
  @$pb.TagNumber(10)
  $core.int get heldHours => $_getIZ(9);
  @$pb.TagNumber(10)
  set heldHours($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasHeldHours() => $_has(9);
  @$pb.TagNumber(10)
  void clearHeldHours() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get pendingRelease => $_getBF(10);
  @$pb.TagNumber(11)
  set pendingRelease($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPendingRelease() => $_has(10);
  @$pb.TagNumber(11)
  void clearPendingRelease() => $_clearField(11);
}

/// How full a mortuary is (SRS-MORT-008).
class Occupancy extends $pb.GeneratedMessage {
  factory Occupancy({
    $core.int? total,
    $core.int? inService,
    $core.int? occupied,
    $core.int? free,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? freeByKind,
    $core.int? outOfService,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (inService != null) result.inService = inService;
    if (occupied != null) result.occupied = occupied;
    if (free != null) result.free = free;
    if (freeByKind != null) result.freeByKind.addEntries(freeByKind);
    if (outOfService != null) result.outOfService = outOfService;
    return result;
  }

  Occupancy._();

  factory Occupancy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Occupancy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Occupancy',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'total')
    ..aI(2, _omitFieldNames ? '' : 'inService')
    ..aI(3, _omitFieldNames ? '' : 'occupied')
    ..aI(4, _omitFieldNames ? '' : 'free')
    ..m<$core.String, $core.int>(5, _omitFieldNames ? '' : 'freeByKind',
        entryClassName: 'Occupancy.FreeByKindEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('healthcare.mortuary.v1'))
    ..aI(6, _omitFieldNames ? '' : 'outOfService')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Occupancy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Occupancy copyWith(void Function(Occupancy) updates) =>
      super.copyWith((message) => updates(message as Occupancy)) as Occupancy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Occupancy create() => Occupancy._();
  @$core.override
  Occupancy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Occupancy getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Occupancy>(create);
  static Occupancy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get total => $_getIZ(0);
  @$pb.TagNumber(1)
  set total($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  /// Excludes the broken units, which is the number a mortuary actually has.
  @$pb.TagNumber(2)
  $core.int get inService => $_getIZ(1);
  @$pb.TagNumber(2)
  set inService($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInService() => $_has(1);
  @$pb.TagNumber(2)
  void clearInService() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get occupied => $_getIZ(2);
  @$pb.TagNumber(3)
  set occupied($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOccupied() => $_has(2);
  @$pb.TagNumber(3)
  void clearOccupied() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get free => $_getIZ(3);
  @$pb.TagNumber(4)
  set free($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFree() => $_has(3);
  @$pb.TagNumber(4)
  void clearFree() => $_clearField(4);

  /// Free spaces by kind: a free viewing room does not help somebody looking
  /// for a drawer.
  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.int> get freeByKind => $_getMap(4);

  /// Reported rather than hidden: a mortuary running at nine tenths because
  /// a third of its units are broken has a different problem from one that
  /// is simply full.
  @$pb.TagNumber(6)
  $core.int get outOfService => $_getIZ(5);
  @$pb.TagNumber(6)
  set outOfService($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOutOfService() => $_has(5);
  @$pb.TagNumber(6)
  void clearOutOfService() => $_clearField(6);
}

class OpenCaseRequest extends $pb.GeneratedMessage {
  factory OpenCaseRequest({
    $core.String? reference,
    Source? source,
    $core.String? encounterId,
    $core.String? patientId,
    $core.String? externalSource,
    Identity? identity,
    $core.String? identificationNote,
    $core.String? displayName,
    $core.bool? medicoLegal,
    $core.String? mlcReference,
    $core.bool? restricted,
    $0.Timestamp? diedAt,
    $core.String? facilityId,
    $core.String? receivedFrom,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    if (source != null) result.source = source;
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (externalSource != null) result.externalSource = externalSource;
    if (identity != null) result.identity = identity;
    if (identificationNote != null)
      result.identificationNote = identificationNote;
    if (displayName != null) result.displayName = displayName;
    if (medicoLegal != null) result.medicoLegal = medicoLegal;
    if (mlcReference != null) result.mlcReference = mlcReference;
    if (restricted != null) result.restricted = restricted;
    if (diedAt != null) result.diedAt = diedAt;
    if (facilityId != null) result.facilityId = facilityId;
    if (receivedFrom != null) result.receivedFrom = receivedFrom;
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
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..aE<Source>(2, _omitFieldNames ? '' : 'source', enumValues: Source.values)
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aOS(5, _omitFieldNames ? '' : 'externalSource')
    ..aE<Identity>(6, _omitFieldNames ? '' : 'identity',
        enumValues: Identity.values)
    ..aOS(7, _omitFieldNames ? '' : 'identificationNote')
    ..aOS(8, _omitFieldNames ? '' : 'displayName')
    ..aOB(9, _omitFieldNames ? '' : 'medicoLegal')
    ..aOS(10, _omitFieldNames ? '' : 'mlcReference')
    ..aOB(11, _omitFieldNames ? '' : 'restricted')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'diedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'facilityId')
    ..aOS(14, _omitFieldNames ? '' : 'receivedFrom')
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
  Source get source => $_getN(1);
  @$pb.TagNumber(2)
  set source(Source value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearSource() => $_clearField(2);

  /// Required for an in-hospital death, refused for a body brought in.
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

  /// Required for a body brought in.
  @$pb.TagNumber(5)
  $core.String get externalSource => $_getSZ(4);
  @$pb.TagNumber(5)
  set externalSource($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExternalSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearExternalSource() => $_clearField(5);

  @$pb.TagNumber(6)
  Identity get identity => $_getN(5);
  @$pb.TagNumber(6)
  set identity(Identity value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasIdentity() => $_has(5);
  @$pb.TagNumber(6)
  void clearIdentity() => $_clearField(6);

  /// How the identity was established at receipt. Required where the case
  /// arrives already confirmed.
  @$pb.TagNumber(7)
  $core.String get identificationNote => $_getSZ(6);
  @$pb.TagNumber(7)
  set identificationNote($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIdentificationNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearIdentificationNote() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get displayName => $_getSZ(7);
  @$pb.TagNumber(8)
  set displayName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDisplayName() => $_has(7);
  @$pb.TagNumber(8)
  void clearDisplayName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get medicoLegal => $_getBF(8);
  @$pb.TagNumber(9)
  set medicoLegal($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMedicoLegal() => $_has(8);
  @$pb.TagNumber(9)
  void clearMedicoLegal() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get mlcReference => $_getSZ(9);
  @$pb.TagNumber(10)
  set mlcReference($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMlcReference() => $_has(9);
  @$pb.TagNumber(10)
  void clearMlcReference() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get restricted => $_getBF(10);
  @$pb.TagNumber(11)
  set restricted($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRestricted() => $_has(10);
  @$pb.TagNumber(11)
  void clearRestricted() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get diedAt => $_getN(11);
  @$pb.TagNumber(12)
  set diedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasDiedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearDiedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureDiedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get facilityId => $_getSZ(12);
  @$pb.TagNumber(13)
  set facilityId($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasFacilityId() => $_has(12);
  @$pb.TagNumber(13)
  void clearFacilityId() => $_clearField(13);

  /// The ward, the ambulance or the police who brought the body. Opens the
  /// chain of custody.
  @$pb.TagNumber(14)
  $core.String get receivedFrom => $_getSZ(13);
  @$pb.TagNumber(14)
  set receivedFrom($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasReceivedFrom() => $_has(13);
  @$pb.TagNumber(14)
  void clearReceivedFrom() => $_clearField(14);
}

class OpenCaseResponse extends $pb.GeneratedMessage {
  factory OpenCaseResponse({
    Case? mortuaryCase,
  }) {
    final result = create();
    if (mortuaryCase != null) result.mortuaryCase = mortuaryCase;
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
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Case>(1, _omitFieldNames ? '' : 'mortuaryCase',
        subBuilder: Case.create)
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
  Case get mortuaryCase => $_getN(0);
  @$pb.TagNumber(1)
  set mortuaryCase(Case value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMortuaryCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearMortuaryCase() => $_clearField(1);
  @$pb.TagNumber(1)
  Case ensureMortuaryCase() => $_ensure(0);
}

class IdentifyRequest extends $pb.GeneratedMessage {
  factory IdentifyRequest({
    $core.String? caseId,
    Identity? identity,
    $core.String? name,
    $core.String? note,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (identity != null) result.identity = identity;
    if (name != null) result.name = name;
    if (note != null) result.note = note;
    if (version != null) result.version = version;
    return result;
  }

  IdentifyRequest._();

  factory IdentifyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IdentifyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdentifyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aE<Identity>(2, _omitFieldNames ? '' : 'identity',
        enumValues: Identity.values)
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..aInt64(5, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentifyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentifyRequest copyWith(void Function(IdentifyRequest) updates) =>
      super.copyWith((message) => updates(message as IdentifyRequest))
          as IdentifyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IdentifyRequest create() => IdentifyRequest._();
  @$core.override
  IdentifyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IdentifyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdentifyRequest>(create);
  static IdentifyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  Identity get identity => $_getN(1);
  @$pb.TagNumber(2)
  set identity(Identity value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasIdentity() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdentity() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  /// How it was confirmed. Required for a confirmed identification.
  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get version => $_getI64(4);
  @$pb.TagNumber(5)
  set version($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersion() => $_clearField(5);
}

class IdentifyResponse extends $pb.GeneratedMessage {
  factory IdentifyResponse({
    Case? mortuaryCase,
  }) {
    final result = create();
    if (mortuaryCase != null) result.mortuaryCase = mortuaryCase;
    return result;
  }

  IdentifyResponse._();

  factory IdentifyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IdentifyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdentifyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Case>(1, _omitFieldNames ? '' : 'mortuaryCase',
        subBuilder: Case.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentifyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentifyResponse copyWith(void Function(IdentifyResponse) updates) =>
      super.copyWith((message) => updates(message as IdentifyResponse))
          as IdentifyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IdentifyResponse create() => IdentifyResponse._();
  @$core.override
  IdentifyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IdentifyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdentifyResponse>(create);
  static IdentifyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Case get mortuaryCase => $_getN(0);
  @$pb.TagNumber(1)
  set mortuaryCase(Case value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMortuaryCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearMortuaryCase() => $_clearField(1);
  @$pb.TagNumber(1)
  Case ensureMortuaryCase() => $_ensure(0);
}

class RecordCauseRequest extends $pb.GeneratedMessage {
  factory RecordCauseRequest({
    $core.String? caseId,
    $core.String? summary,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (summary != null) result.summary = summary;
    if (version != null) result.version = version;
    return result;
  }

  RecordCauseRequest._();

  factory RecordCauseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordCauseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordCauseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'summary')
    ..aInt64(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCauseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCauseRequest copyWith(void Function(RecordCauseRequest) updates) =>
      super.copyWith((message) => updates(message as RecordCauseRequest))
          as RecordCauseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordCauseRequest create() => RecordCauseRequest._();
  @$core.override
  RecordCauseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordCauseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordCauseRequest>(create);
  static RecordCauseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get summary => $_getSZ(1);
  @$pb.TagNumber(2)
  set summary($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSummary() => $_has(1);
  @$pb.TagNumber(2)
  void clearSummary() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get version => $_getI64(2);
  @$pb.TagNumber(3)
  set version($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);
}

class RecordCauseResponse extends $pb.GeneratedMessage {
  factory RecordCauseResponse({
    Case? mortuaryCase,
  }) {
    final result = create();
    if (mortuaryCase != null) result.mortuaryCase = mortuaryCase;
    return result;
  }

  RecordCauseResponse._();

  factory RecordCauseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordCauseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordCauseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Case>(1, _omitFieldNames ? '' : 'mortuaryCase',
        subBuilder: Case.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCauseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCauseResponse copyWith(void Function(RecordCauseResponse) updates) =>
      super.copyWith((message) => updates(message as RecordCauseResponse))
          as RecordCauseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordCauseResponse create() => RecordCauseResponse._();
  @$core.override
  RecordCauseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordCauseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordCauseResponse>(create);
  static RecordCauseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Case get mortuaryCase => $_getN(0);
  @$pb.TagNumber(1)
  set mortuaryCase(Case value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMortuaryCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearMortuaryCase() => $_clearField(1);
  @$pb.TagNumber(1)
  Case ensureMortuaryCase() => $_ensure(0);
}

class RecordDeathCertificateRequest extends $pb.GeneratedMessage {
  factory RecordDeathCertificateRequest({
    $core.String? caseId,
    $core.String? reference,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (reference != null) result.reference = reference;
    if (version != null) result.version = version;
    return result;
  }

  RecordDeathCertificateRequest._();

  factory RecordDeathCertificateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordDeathCertificateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordDeathCertificateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aInt64(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeathCertificateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeathCertificateRequest copyWith(
          void Function(RecordDeathCertificateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RecordDeathCertificateRequest))
          as RecordDeathCertificateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordDeathCertificateRequest create() =>
      RecordDeathCertificateRequest._();
  @$core.override
  RecordDeathCertificateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordDeathCertificateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordDeathCertificateRequest>(create);
  static RecordDeathCertificateRequest? _defaultInstance;

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
  $fixnum.Int64 get version => $_getI64(2);
  @$pb.TagNumber(3)
  set version($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);
}

class RecordDeathCertificateResponse extends $pb.GeneratedMessage {
  factory RecordDeathCertificateResponse({
    Case? mortuaryCase,
  }) {
    final result = create();
    if (mortuaryCase != null) result.mortuaryCase = mortuaryCase;
    return result;
  }

  RecordDeathCertificateResponse._();

  factory RecordDeathCertificateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordDeathCertificateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordDeathCertificateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Case>(1, _omitFieldNames ? '' : 'mortuaryCase',
        subBuilder: Case.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeathCertificateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeathCertificateResponse copyWith(
          void Function(RecordDeathCertificateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RecordDeathCertificateResponse))
          as RecordDeathCertificateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordDeathCertificateResponse create() =>
      RecordDeathCertificateResponse._();
  @$core.override
  RecordDeathCertificateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordDeathCertificateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordDeathCertificateResponse>(create);
  static RecordDeathCertificateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Case get mortuaryCase => $_getN(0);
  @$pb.TagNumber(1)
  set mortuaryCase(Case value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMortuaryCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearMortuaryCase() => $_clearField(1);
  @$pb.TagNumber(1)
  Case ensureMortuaryCase() => $_ensure(0);
}

class MarkMedicoLegalRequest extends $pb.GeneratedMessage {
  factory MarkMedicoLegalRequest({
    $core.String? caseId,
    $core.String? reference,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (reference != null) result.reference = reference;
    if (version != null) result.version = version;
    return result;
  }

  MarkMedicoLegalRequest._();

  factory MarkMedicoLegalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MarkMedicoLegalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkMedicoLegalRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aInt64(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkMedicoLegalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkMedicoLegalRequest copyWith(
          void Function(MarkMedicoLegalRequest) updates) =>
      super.copyWith((message) => updates(message as MarkMedicoLegalRequest))
          as MarkMedicoLegalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarkMedicoLegalRequest create() => MarkMedicoLegalRequest._();
  @$core.override
  MarkMedicoLegalRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MarkMedicoLegalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkMedicoLegalRequest>(create);
  static MarkMedicoLegalRequest? _defaultInstance;

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
  $fixnum.Int64 get version => $_getI64(2);
  @$pb.TagNumber(3)
  set version($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);
}

class MarkMedicoLegalResponse extends $pb.GeneratedMessage {
  factory MarkMedicoLegalResponse({
    Case? mortuaryCase,
  }) {
    final result = create();
    if (mortuaryCase != null) result.mortuaryCase = mortuaryCase;
    return result;
  }

  MarkMedicoLegalResponse._();

  factory MarkMedicoLegalResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MarkMedicoLegalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkMedicoLegalResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Case>(1, _omitFieldNames ? '' : 'mortuaryCase',
        subBuilder: Case.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkMedicoLegalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkMedicoLegalResponse copyWith(
          void Function(MarkMedicoLegalResponse) updates) =>
      super.copyWith((message) => updates(message as MarkMedicoLegalResponse))
          as MarkMedicoLegalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarkMedicoLegalResponse create() => MarkMedicoLegalResponse._();
  @$core.override
  MarkMedicoLegalResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MarkMedicoLegalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkMedicoLegalResponse>(create);
  static MarkMedicoLegalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Case get mortuaryCase => $_getN(0);
  @$pb.TagNumber(1)
  set mortuaryCase(Case value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMortuaryCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearMortuaryCase() => $_clearField(1);
  @$pb.TagNumber(1)
  Case ensureMortuaryCase() => $_ensure(0);
}

class GetCaseRequest extends $pb.GeneratedMessage {
  factory GetCaseRequest({
    $core.String? caseId,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    return result;
  }

  GetCaseRequest._();

  factory GetCaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCaseRequest copyWith(void Function(GetCaseRequest) updates) =>
      super.copyWith((message) => updates(message as GetCaseRequest))
          as GetCaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCaseRequest create() => GetCaseRequest._();
  @$core.override
  GetCaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCaseRequest>(create);
  static GetCaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
}

class GetCaseResponse extends $pb.GeneratedMessage {
  factory GetCaseResponse({
    Case? mortuaryCase,
  }) {
    final result = create();
    if (mortuaryCase != null) result.mortuaryCase = mortuaryCase;
    return result;
  }

  GetCaseResponse._();

  factory GetCaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Case>(1, _omitFieldNames ? '' : 'mortuaryCase',
        subBuilder: Case.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCaseResponse copyWith(void Function(GetCaseResponse) updates) =>
      super.copyWith((message) => updates(message as GetCaseResponse))
          as GetCaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCaseResponse create() => GetCaseResponse._();
  @$core.override
  GetCaseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCaseResponse>(create);
  static GetCaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Case get mortuaryCase => $_getN(0);
  @$pb.TagNumber(1)
  set mortuaryCase(Case value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMortuaryCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearMortuaryCase() => $_clearField(1);
  @$pb.TagNumber(1)
  Case ensureMortuaryCase() => $_ensure(0);
}

class GetCaseByReferenceRequest extends $pb.GeneratedMessage {
  factory GetCaseByReferenceRequest({
    $core.String? reference,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    return result;
  }

  GetCaseByReferenceRequest._();

  factory GetCaseByReferenceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCaseByReferenceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCaseByReferenceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCaseByReferenceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCaseByReferenceRequest copyWith(
          void Function(GetCaseByReferenceRequest) updates) =>
      super.copyWith((message) => updates(message as GetCaseByReferenceRequest))
          as GetCaseByReferenceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCaseByReferenceRequest create() => GetCaseByReferenceRequest._();
  @$core.override
  GetCaseByReferenceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCaseByReferenceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCaseByReferenceRequest>(create);
  static GetCaseByReferenceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reference => $_getSZ(0);
  @$pb.TagNumber(1)
  set reference($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReference() => $_has(0);
  @$pb.TagNumber(1)
  void clearReference() => $_clearField(1);
}

class GetCaseByReferenceResponse extends $pb.GeneratedMessage {
  factory GetCaseByReferenceResponse({
    Case? mortuaryCase,
  }) {
    final result = create();
    if (mortuaryCase != null) result.mortuaryCase = mortuaryCase;
    return result;
  }

  GetCaseByReferenceResponse._();

  factory GetCaseByReferenceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCaseByReferenceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCaseByReferenceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Case>(1, _omitFieldNames ? '' : 'mortuaryCase',
        subBuilder: Case.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCaseByReferenceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCaseByReferenceResponse copyWith(
          void Function(GetCaseByReferenceResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetCaseByReferenceResponse))
          as GetCaseByReferenceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCaseByReferenceResponse create() => GetCaseByReferenceResponse._();
  @$core.override
  GetCaseByReferenceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCaseByReferenceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCaseByReferenceResponse>(create);
  static GetCaseByReferenceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Case get mortuaryCase => $_getN(0);
  @$pb.TagNumber(1)
  set mortuaryCase(Case value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMortuaryCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearMortuaryCase() => $_clearField(1);
  @$pb.TagNumber(1)
  Case ensureMortuaryCase() => $_ensure(0);
}

class ListCasesRequest extends $pb.GeneratedMessage {
  factory ListCasesRequest({
    $core.Iterable<CaseState>? states,
    $core.Iterable<Identity>? identities,
    $core.String? facilityId,
    $core.bool? medicoLegalOnly,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (states != null) result.states.addAll(states);
    if (identities != null) result.identities.addAll(identities);
    if (facilityId != null) result.facilityId = facilityId;
    if (medicoLegalOnly != null) result.medicoLegalOnly = medicoLegalOnly;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
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
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..pc<CaseState>(1, _omitFieldNames ? '' : 'states', $pb.PbFieldType.KE,
        valueOf: CaseState.valueOf,
        enumValues: CaseState.values,
        defaultEnumValue: CaseState.CASE_STATE_UNSPECIFIED)
    ..pc<Identity>(2, _omitFieldNames ? '' : 'identities', $pb.PbFieldType.KE,
        valueOf: Identity.valueOf,
        enumValues: Identity.values,
        defaultEnumValue: Identity.IDENTITY_UNSPECIFIED)
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOB(4, _omitFieldNames ? '' : 'medicoLegalOnly')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(7, _omitFieldNames ? '' : 'pageSize')
    ..aI(8, _omitFieldNames ? '' : 'offset')
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
  $pb.PbList<CaseState> get states => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<Identity> get identities => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get medicoLegalOnly => $_getBF(3);
  @$pb.TagNumber(4)
  set medicoLegalOnly($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMedicoLegalOnly() => $_has(3);
  @$pb.TagNumber(4)
  void clearMedicoLegalOnly() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get from => $_getN(4);
  @$pb.TagNumber(5)
  set from($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasFrom() => $_has(4);
  @$pb.TagNumber(5)
  void clearFrom() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureFrom() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get to => $_getN(5);
  @$pb.TagNumber(6)
  set to($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTo() => $_has(5);
  @$pb.TagNumber(6)
  void clearTo() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureTo() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.int get pageSize => $_getIZ(6);
  @$pb.TagNumber(7)
  set pageSize($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPageSize() => $_has(6);
  @$pb.TagNumber(7)
  void clearPageSize() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get offset => $_getIZ(7);
  @$pb.TagNumber(8)
  set offset($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOffset() => $_has(7);
  @$pb.TagNumber(8)
  void clearOffset() => $_clearField(8);
}

/// The sensitive fields are absent from every row, whoever asks.
class ListCasesResponse extends $pb.GeneratedMessage {
  factory ListCasesResponse({
    $core.Iterable<Case>? cases,
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
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..pPM<Case>(1, _omitFieldNames ? '' : 'cases', subBuilder: Case.create)
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
  $pb.PbList<Case> get cases => $_getList(0);
}

class AddLocationRequest extends $pb.GeneratedMessage {
  factory AddLocationRequest({
    $core.String? code,
    SpaceKind? kind,
    $core.String? facilityId,
    $core.String? zone,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (kind != null) result.kind = kind;
    if (facilityId != null) result.facilityId = facilityId;
    if (zone != null) result.zone = zone;
    return result;
  }

  AddLocationRequest._();

  factory AddLocationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddLocationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddLocationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aE<SpaceKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: SpaceKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'zone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddLocationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddLocationRequest copyWith(void Function(AddLocationRequest) updates) =>
      super.copyWith((message) => updates(message as AddLocationRequest))
          as AddLocationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddLocationRequest create() => AddLocationRequest._();
  @$core.override
  AddLocationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddLocationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddLocationRequest>(create);
  static AddLocationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  SpaceKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(SpaceKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

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
}

class AddLocationResponse extends $pb.GeneratedMessage {
  factory AddLocationResponse({
    Location? location,
  }) {
    final result = create();
    if (location != null) result.location = location;
    return result;
  }

  AddLocationResponse._();

  factory AddLocationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddLocationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddLocationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Location>(1, _omitFieldNames ? '' : 'location',
        subBuilder: Location.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddLocationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddLocationResponse copyWith(void Function(AddLocationResponse) updates) =>
      super.copyWith((message) => updates(message as AddLocationResponse))
          as AddLocationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddLocationResponse create() => AddLocationResponse._();
  @$core.override
  AddLocationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddLocationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddLocationResponse>(create);
  static AddLocationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Location get location => $_getN(0);
  @$pb.TagNumber(1)
  set location(Location value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLocation() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocation() => $_clearField(1);
  @$pb.TagNumber(1)
  Location ensureLocation() => $_ensure(0);
}

class SetLocationServiceRequest extends $pb.GeneratedMessage {
  factory SetLocationServiceRequest({
    $core.String? locationId,
    $core.bool? outOfService,
    $core.String? reason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    if (outOfService != null) result.outOfService = outOfService;
    if (reason != null) result.reason = reason;
    if (version != null) result.version = version;
    return result;
  }

  SetLocationServiceRequest._();

  factory SetLocationServiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetLocationServiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetLocationServiceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..aOB(2, _omitFieldNames ? '' : 'outOfService')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aInt64(4, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetLocationServiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetLocationServiceRequest copyWith(
          void Function(SetLocationServiceRequest) updates) =>
      super.copyWith((message) => updates(message as SetLocationServiceRequest))
          as SetLocationServiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetLocationServiceRequest create() => SetLocationServiceRequest._();
  @$core.override
  SetLocationServiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetLocationServiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetLocationServiceRequest>(create);
  static SetLocationServiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get outOfService => $_getBF(1);
  @$pb.TagNumber(2)
  set outOfService($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOutOfService() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutOfService() => $_clearField(2);

  /// Required when taking a space off the board.
  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get version => $_getI64(3);
  @$pb.TagNumber(4)
  set version($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => $_clearField(4);
}

class SetLocationServiceResponse extends $pb.GeneratedMessage {
  factory SetLocationServiceResponse({
    Location? location,
  }) {
    final result = create();
    if (location != null) result.location = location;
    return result;
  }

  SetLocationServiceResponse._();

  factory SetLocationServiceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetLocationServiceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetLocationServiceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Location>(1, _omitFieldNames ? '' : 'location',
        subBuilder: Location.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetLocationServiceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetLocationServiceResponse copyWith(
          void Function(SetLocationServiceResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetLocationServiceResponse))
          as SetLocationServiceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetLocationServiceResponse create() => SetLocationServiceResponse._();
  @$core.override
  SetLocationServiceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetLocationServiceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetLocationServiceResponse>(create);
  static SetLocationServiceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Location get location => $_getN(0);
  @$pb.TagNumber(1)
  set location(Location value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLocation() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocation() => $_clearField(1);
  @$pb.TagNumber(1)
  Location ensureLocation() => $_ensure(0);
}

class ListLocationsRequest extends $pb.GeneratedMessage {
  factory ListLocationsRequest({
    $core.String? facilityId,
    $core.Iterable<SpaceKind>? kinds,
    $core.bool? inServiceOnly,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (kinds != null) result.kinds.addAll(kinds);
    if (inServiceOnly != null) result.inServiceOnly = inServiceOnly;
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
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..pc<SpaceKind>(2, _omitFieldNames ? '' : 'kinds', $pb.PbFieldType.KE,
        valueOf: SpaceKind.valueOf,
        enumValues: SpaceKind.values,
        defaultEnumValue: SpaceKind.SPACE_KIND_UNSPECIFIED)
    ..aOB(3, _omitFieldNames ? '' : 'inServiceOnly')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..aI(5, _omitFieldNames ? '' : 'offset')
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
  $pb.PbList<SpaceKind> get kinds => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get inServiceOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set inServiceOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInServiceOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearInServiceOnly() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get offset => $_getIZ(4);
  @$pb.TagNumber(5)
  set offset($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOffset() => $_has(4);
  @$pb.TagNumber(5)
  void clearOffset() => $_clearField(5);
}

class ListLocationsResponse extends $pb.GeneratedMessage {
  factory ListLocationsResponse({
    $core.Iterable<Location>? locations,
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
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..pPM<Location>(1, _omitFieldNames ? '' : 'locations',
        subBuilder: Location.create)
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
  $pb.PbList<Location> get locations => $_getList(0);
}

class PlaceBodyRequest extends $pb.GeneratedMessage {
  factory PlaceBodyRequest({
    $core.String? caseId,
    $core.String? locationId,
    $core.String? storageTag,
    $core.String? checkedNote,
    $core.String? moveReason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (locationId != null) result.locationId = locationId;
    if (storageTag != null) result.storageTag = storageTag;
    if (checkedNote != null) result.checkedNote = checkedNote;
    if (moveReason != null) result.moveReason = moveReason;
    if (version != null) result.version = version;
    return result;
  }

  PlaceBodyRequest._();

  factory PlaceBodyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaceBodyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaceBodyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'locationId')
    ..aOS(3, _omitFieldNames ? '' : 'storageTag')
    ..aOS(4, _omitFieldNames ? '' : 'checkedNote')
    ..aOS(5, _omitFieldNames ? '' : 'moveReason')
    ..aInt64(6, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceBodyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceBodyRequest copyWith(void Function(PlaceBodyRequest) updates) =>
      super.copyWith((message) => updates(message as PlaceBodyRequest))
          as PlaceBodyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaceBodyRequest create() => PlaceBodyRequest._();
  @$core.override
  PlaceBodyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaceBodyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaceBodyRequest>(create);
  static PlaceBodyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get locationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get storageTag => $_getSZ(2);
  @$pb.TagNumber(3)
  set storageTag($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStorageTag() => $_has(2);
  @$pb.TagNumber(3)
  void clearStorageTag() => $_clearField(3);

  /// What was checked against what. The requirement asks for positive
  /// identity checks, and a tick is not one.
  @$pb.TagNumber(4)
  $core.String get checkedNote => $_getSZ(3);
  @$pb.TagNumber(4)
  set checkedNote($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCheckedNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearCheckedNote() => $_clearField(4);

  /// Why the body moved, where it was somewhere already.
  @$pb.TagNumber(5)
  $core.String get moveReason => $_getSZ(4);
  @$pb.TagNumber(5)
  set moveReason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMoveReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearMoveReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get version => $_getI64(5);
  @$pb.TagNumber(6)
  set version($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => $_clearField(6);
}

class PlaceBodyResponse extends $pb.GeneratedMessage {
  factory PlaceBodyResponse({
    Placement? placement,
  }) {
    final result = create();
    if (placement != null) result.placement = placement;
    return result;
  }

  PlaceBodyResponse._();

  factory PlaceBodyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaceBodyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaceBodyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Placement>(1, _omitFieldNames ? '' : 'placement',
        subBuilder: Placement.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceBodyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceBodyResponse copyWith(void Function(PlaceBodyResponse) updates) =>
      super.copyWith((message) => updates(message as PlaceBodyResponse))
          as PlaceBodyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaceBodyResponse create() => PlaceBodyResponse._();
  @$core.override
  PlaceBodyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaceBodyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaceBodyResponse>(create);
  static PlaceBodyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Placement get placement => $_getN(0);
  @$pb.TagNumber(1)
  set placement(Placement value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlacement() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlacement() => $_clearField(1);
  @$pb.TagNumber(1)
  Placement ensurePlacement() => $_ensure(0);
}

class GetPlacementHistoryRequest extends $pb.GeneratedMessage {
  factory GetPlacementHistoryRequest({
    $core.String? caseId,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    return result;
  }

  GetPlacementHistoryRequest._();

  factory GetPlacementHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPlacementHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPlacementHistoryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlacementHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlacementHistoryRequest copyWith(
          void Function(GetPlacementHistoryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetPlacementHistoryRequest))
          as GetPlacementHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPlacementHistoryRequest create() => GetPlacementHistoryRequest._();
  @$core.override
  GetPlacementHistoryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPlacementHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPlacementHistoryRequest>(create);
  static GetPlacementHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
}

class GetPlacementHistoryResponse extends $pb.GeneratedMessage {
  factory GetPlacementHistoryResponse({
    $core.Iterable<Placement>? placements,
  }) {
    final result = create();
    if (placements != null) result.placements.addAll(placements);
    return result;
  }

  GetPlacementHistoryResponse._();

  factory GetPlacementHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPlacementHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPlacementHistoryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..pPM<Placement>(1, _omitFieldNames ? '' : 'placements',
        subBuilder: Placement.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlacementHistoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlacementHistoryResponse copyWith(
          void Function(GetPlacementHistoryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetPlacementHistoryResponse))
          as GetPlacementHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPlacementHistoryResponse create() =>
      GetPlacementHistoryResponse._();
  @$core.override
  GetPlacementHistoryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPlacementHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPlacementHistoryResponse>(create);
  static GetPlacementHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Placement> get placements => $_getList(0);
}

class ListItemRequest extends $pb.GeneratedMessage {
  factory ListItemRequest({
    $core.String? caseId,
    ItemKind? kind,
    $core.String? description,
    $core.int? quantity,
    $core.String? sealNumber,
    $core.String? witnessedBy,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (kind != null) result.kind = kind;
    if (description != null) result.description = description;
    if (quantity != null) result.quantity = quantity;
    if (sealNumber != null) result.sealNumber = sealNumber;
    if (witnessedBy != null) result.witnessedBy = witnessedBy;
    return result;
  }

  ListItemRequest._();

  factory ListItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListItemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aE<ItemKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: ItemKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aI(4, _omitFieldNames ? '' : 'quantity')
    ..aOS(5, _omitFieldNames ? '' : 'sealNumber')
    ..aOS(6, _omitFieldNames ? '' : 'witnessedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListItemRequest copyWith(void Function(ListItemRequest) updates) =>
      super.copyWith((message) => updates(message as ListItemRequest))
          as ListItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListItemRequest create() => ListItemRequest._();
  @$core.override
  ListItemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListItemRequest>(create);
  static ListItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  ItemKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(ItemKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get quantity => $_getIZ(3);
  @$pb.TagNumber(4)
  set quantity($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuantity() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuantity() => $_clearField(4);

  /// Required for a valuable.
  @$pb.TagNumber(5)
  $core.String get sealNumber => $_getSZ(4);
  @$pb.TagNumber(5)
  set sealNumber($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSealNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearSealNumber() => $_clearField(5);

  /// Required for a valuable, and somebody other than the caller.
  @$pb.TagNumber(6)
  $core.String get witnessedBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set witnessedBy($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWitnessedBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearWitnessedBy() => $_clearField(6);
}

class ListItemResponse extends $pb.GeneratedMessage {
  factory ListItemResponse({
    Item? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  ListItemResponse._();

  factory ListItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListItemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Item>(1, _omitFieldNames ? '' : 'item', subBuilder: Item.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListItemResponse copyWith(void Function(ListItemResponse) updates) =>
      super.copyWith((message) => updates(message as ListItemResponse))
          as ListItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListItemResponse create() => ListItemResponse._();
  @$core.override
  ListItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListItemResponse>(create);
  static ListItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Item get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(Item value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  Item ensureItem() => $_ensure(0);
}

class RetainItemRequest extends $pb.GeneratedMessage {
  factory RetainItemRequest({
    $core.String? itemId,
    $core.String? authority,
    $core.String? reference,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (authority != null) result.authority = authority;
    if (reference != null) result.reference = reference;
    return result;
  }

  RetainItemRequest._();

  factory RetainItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetainItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetainItemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'authority')
    ..aOS(3, _omitFieldNames ? '' : 'reference')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetainItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetainItemRequest copyWith(void Function(RetainItemRequest) updates) =>
      super.copyWith((message) => updates(message as RetainItemRequest))
          as RetainItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetainItemRequest create() => RetainItemRequest._();
  @$core.override
  RetainItemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetainItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetainItemRequest>(create);
  static RetainItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get authority => $_getSZ(1);
  @$pb.TagNumber(2)
  set authority($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAuthority() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthority() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reference => $_getSZ(2);
  @$pb.TagNumber(3)
  set reference($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReference() => $_has(2);
  @$pb.TagNumber(3)
  void clearReference() => $_clearField(3);
}

class RetainItemResponse extends $pb.GeneratedMessage {
  factory RetainItemResponse({
    Item? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  RetainItemResponse._();

  factory RetainItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetainItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetainItemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Item>(1, _omitFieldNames ? '' : 'item', subBuilder: Item.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetainItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetainItemResponse copyWith(void Function(RetainItemResponse) updates) =>
      super.copyWith((message) => updates(message as RetainItemResponse))
          as RetainItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetainItemResponse create() => RetainItemResponse._();
  @$core.override
  RetainItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetainItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetainItemResponse>(create);
  static RetainItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Item get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(Item value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  Item ensureItem() => $_ensure(0);
}

class HandOverBelongingsRequest extends $pb.GeneratedMessage {
  factory HandOverBelongingsRequest({
    $core.String? caseId,
    $core.Iterable<$core.String>? itemIds,
    $core.String? recipientName,
    $core.String? recipientRelation,
    $core.String? recipientIdType,
    $core.String? recipientIdRef,
    $core.String? signatureRef,
    $core.String? witnessedBy,
    $core.String? note,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (itemIds != null) result.itemIds.addAll(itemIds);
    if (recipientName != null) result.recipientName = recipientName;
    if (recipientRelation != null) result.recipientRelation = recipientRelation;
    if (recipientIdType != null) result.recipientIdType = recipientIdType;
    if (recipientIdRef != null) result.recipientIdRef = recipientIdRef;
    if (signatureRef != null) result.signatureRef = signatureRef;
    if (witnessedBy != null) result.witnessedBy = witnessedBy;
    if (note != null) result.note = note;
    return result;
  }

  HandOverBelongingsRequest._();

  factory HandOverBelongingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HandOverBelongingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HandOverBelongingsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..pPS(2, _omitFieldNames ? '' : 'itemIds')
    ..aOS(3, _omitFieldNames ? '' : 'recipientName')
    ..aOS(4, _omitFieldNames ? '' : 'recipientRelation')
    ..aOS(5, _omitFieldNames ? '' : 'recipientIdType')
    ..aOS(6, _omitFieldNames ? '' : 'recipientIdRef')
    ..aOS(7, _omitFieldNames ? '' : 'signatureRef')
    ..aOS(8, _omitFieldNames ? '' : 'witnessedBy')
    ..aOS(9, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HandOverBelongingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HandOverBelongingsRequest copyWith(
          void Function(HandOverBelongingsRequest) updates) =>
      super.copyWith((message) => updates(message as HandOverBelongingsRequest))
          as HandOverBelongingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HandOverBelongingsRequest create() => HandOverBelongingsRequest._();
  @$core.override
  HandOverBelongingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HandOverBelongingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HandOverBelongingsRequest>(create);
  static HandOverBelongingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get itemIds => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get recipientName => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipientName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecipientName() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipientName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get recipientRelation => $_getSZ(3);
  @$pb.TagNumber(4)
  set recipientRelation($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRecipientRelation() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecipientRelation() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get recipientIdType => $_getSZ(4);
  @$pb.TagNumber(5)
  set recipientIdType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRecipientIdType() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecipientIdType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get recipientIdRef => $_getSZ(5);
  @$pb.TagNumber(6)
  set recipientIdRef($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRecipientIdRef() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecipientIdRef() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get signatureRef => $_getSZ(6);
  @$pb.TagNumber(7)
  set signatureRef($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSignatureRef() => $_has(6);
  @$pb.TagNumber(7)
  void clearSignatureRef() => $_clearField(7);

  /// A second member of staff, and somebody other than the caller.
  @$pb.TagNumber(8)
  $core.String get witnessedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set witnessedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasWitnessedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearWitnessedBy() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get note => $_getSZ(8);
  @$pb.TagNumber(9)
  set note($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasNote() => $_has(8);
  @$pb.TagNumber(9)
  void clearNote() => $_clearField(9);
}

class HandOverBelongingsResponse extends $pb.GeneratedMessage {
  factory HandOverBelongingsResponse({
    Handover? handover,
  }) {
    final result = create();
    if (handover != null) result.handover = handover;
    return result;
  }

  HandOverBelongingsResponse._();

  factory HandOverBelongingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HandOverBelongingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HandOverBelongingsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Handover>(1, _omitFieldNames ? '' : 'handover',
        subBuilder: Handover.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HandOverBelongingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HandOverBelongingsResponse copyWith(
          void Function(HandOverBelongingsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as HandOverBelongingsResponse))
          as HandOverBelongingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HandOverBelongingsResponse create() => HandOverBelongingsResponse._();
  @$core.override
  HandOverBelongingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HandOverBelongingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HandOverBelongingsResponse>(create);
  static HandOverBelongingsResponse? _defaultInstance;

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

class GetBelongingsRequest extends $pb.GeneratedMessage {
  factory GetBelongingsRequest({
    $core.String? caseId,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    return result;
  }

  GetBelongingsRequest._();

  factory GetBelongingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBelongingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBelongingsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBelongingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBelongingsRequest copyWith(void Function(GetBelongingsRequest) updates) =>
      super.copyWith((message) => updates(message as GetBelongingsRequest))
          as GetBelongingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBelongingsRequest create() => GetBelongingsRequest._();
  @$core.override
  GetBelongingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBelongingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBelongingsRequest>(create);
  static GetBelongingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
}

class GetBelongingsResponse extends $pb.GeneratedMessage {
  factory GetBelongingsResponse({
    $core.Iterable<Item>? items,
    $core.Iterable<Handover>? handovers,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (handovers != null) result.handovers.addAll(handovers);
    return result;
  }

  GetBelongingsResponse._();

  factory GetBelongingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBelongingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBelongingsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..pPM<Item>(1, _omitFieldNames ? '' : 'items', subBuilder: Item.create)
    ..pPM<Handover>(2, _omitFieldNames ? '' : 'handovers',
        subBuilder: Handover.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBelongingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBelongingsResponse copyWith(
          void Function(GetBelongingsResponse) updates) =>
      super.copyWith((message) => updates(message as GetBelongingsResponse))
          as GetBelongingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBelongingsResponse create() => GetBelongingsResponse._();
  @$core.override
  GetBelongingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBelongingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBelongingsResponse>(create);
  static GetBelongingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Item> get items => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<Handover> get handovers => $_getList(1);
}

class GetChainOfCustodyRequest extends $pb.GeneratedMessage {
  factory GetChainOfCustodyRequest({
    $core.String? caseId,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    return result;
  }

  GetChainOfCustodyRequest._();

  factory GetChainOfCustodyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetChainOfCustodyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetChainOfCustodyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChainOfCustodyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChainOfCustodyRequest copyWith(
          void Function(GetChainOfCustodyRequest) updates) =>
      super.copyWith((message) => updates(message as GetChainOfCustodyRequest))
          as GetChainOfCustodyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetChainOfCustodyRequest create() => GetChainOfCustodyRequest._();
  @$core.override
  GetChainOfCustodyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetChainOfCustodyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetChainOfCustodyRequest>(create);
  static GetChainOfCustodyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
}

class GetChainOfCustodyResponse extends $pb.GeneratedMessage {
  factory GetChainOfCustodyResponse({
    $core.Iterable<CustodyEntry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  GetChainOfCustodyResponse._();

  factory GetChainOfCustodyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetChainOfCustodyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetChainOfCustodyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..pPM<CustodyEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: CustodyEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChainOfCustodyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChainOfCustodyResponse copyWith(
          void Function(GetChainOfCustodyResponse) updates) =>
      super.copyWith((message) => updates(message as GetChainOfCustodyResponse))
          as GetChainOfCustodyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetChainOfCustodyResponse create() => GetChainOfCustodyResponse._();
  @$core.override
  GetChainOfCustodyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetChainOfCustodyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetChainOfCustodyResponse>(create);
  static GetChainOfCustodyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CustodyEntry> get entries => $_getList(0);
}

class RequestPostmortemRequest extends $pb.GeneratedMessage {
  factory RequestPostmortemRequest({
    $core.String? caseId,
    PostmortemKind? kind,
    $core.String? reason,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (kind != null) result.kind = kind;
    if (reason != null) result.reason = reason;
    return result;
  }

  RequestPostmortemRequest._();

  factory RequestPostmortemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestPostmortemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestPostmortemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aE<PostmortemKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: PostmortemKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestPostmortemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestPostmortemRequest copyWith(
          void Function(RequestPostmortemRequest) updates) =>
      super.copyWith((message) => updates(message as RequestPostmortemRequest))
          as RequestPostmortemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestPostmortemRequest create() => RequestPostmortemRequest._();
  @$core.override
  RequestPostmortemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestPostmortemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestPostmortemRequest>(create);
  static RequestPostmortemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  PostmortemKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(PostmortemKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class RequestPostmortemResponse extends $pb.GeneratedMessage {
  factory RequestPostmortemResponse({
    Postmortem? postmortem,
  }) {
    final result = create();
    if (postmortem != null) result.postmortem = postmortem;
    return result;
  }

  RequestPostmortemResponse._();

  factory RequestPostmortemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestPostmortemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestPostmortemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Postmortem>(1, _omitFieldNames ? '' : 'postmortem',
        subBuilder: Postmortem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestPostmortemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestPostmortemResponse copyWith(
          void Function(RequestPostmortemResponse) updates) =>
      super.copyWith((message) => updates(message as RequestPostmortemResponse))
          as RequestPostmortemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestPostmortemResponse create() => RequestPostmortemResponse._();
  @$core.override
  RequestPostmortemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestPostmortemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestPostmortemResponse>(create);
  static RequestPostmortemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Postmortem get postmortem => $_getN(0);
  @$pb.TagNumber(1)
  set postmortem(Postmortem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPostmortem() => $_has(0);
  @$pb.TagNumber(1)
  void clearPostmortem() => $_clearField(1);
  @$pb.TagNumber(1)
  Postmortem ensurePostmortem() => $_ensure(0);
}

class AdvancePostmortemRequest extends $pb.GeneratedMessage {
  factory AdvancePostmortemRequest({
    $core.String? postmortemId,
    PostmortemState? to,
    $core.String? authority,
    $core.String? authorityReference,
    $core.String? pathologist,
    $core.String? reportRef,
    $core.String? reason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (postmortemId != null) result.postmortemId = postmortemId;
    if (to != null) result.to = to;
    if (authority != null) result.authority = authority;
    if (authorityReference != null)
      result.authorityReference = authorityReference;
    if (pathologist != null) result.pathologist = pathologist;
    if (reportRef != null) result.reportRef = reportRef;
    if (reason != null) result.reason = reason;
    if (version != null) result.version = version;
    return result;
  }

  AdvancePostmortemRequest._();

  factory AdvancePostmortemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvancePostmortemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvancePostmortemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'postmortemId')
    ..aE<PostmortemState>(2, _omitFieldNames ? '' : 'to',
        enumValues: PostmortemState.values)
    ..aOS(3, _omitFieldNames ? '' : 'authority')
    ..aOS(4, _omitFieldNames ? '' : 'authorityReference')
    ..aOS(5, _omitFieldNames ? '' : 'pathologist')
    ..aOS(6, _omitFieldNames ? '' : 'reportRef')
    ..aOS(7, _omitFieldNames ? '' : 'reason')
    ..aInt64(8, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvancePostmortemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvancePostmortemRequest copyWith(
          void Function(AdvancePostmortemRequest) updates) =>
      super.copyWith((message) => updates(message as AdvancePostmortemRequest))
          as AdvancePostmortemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvancePostmortemRequest create() => AdvancePostmortemRequest._();
  @$core.override
  AdvancePostmortemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvancePostmortemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvancePostmortemRequest>(create);
  static AdvancePostmortemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get postmortemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set postmortemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPostmortemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPostmortemId() => $_clearField(1);

  @$pb.TagNumber(2)
  PostmortemState get to => $_getN(1);
  @$pb.TagNumber(2)
  set to(PostmortemState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get authority => $_getSZ(2);
  @$pb.TagNumber(3)
  set authority($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthority() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthority() => $_clearField(3);

  /// Required for a medico-legal authorisation.
  @$pb.TagNumber(4)
  $core.String get authorityReference => $_getSZ(3);
  @$pb.TagNumber(4)
  set authorityReference($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAuthorityReference() => $_has(3);
  @$pb.TagNumber(4)
  void clearAuthorityReference() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get pathologist => $_getSZ(4);
  @$pb.TagNumber(5)
  set pathologist($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPathologist() => $_has(4);
  @$pb.TagNumber(5)
  void clearPathologist() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reportRef => $_getSZ(5);
  @$pb.TagNumber(6)
  set reportRef($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReportRef() => $_has(5);
  @$pb.TagNumber(6)
  void clearReportRef() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get reason => $_getSZ(6);
  @$pb.TagNumber(7)
  set reason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearReason() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get version => $_getI64(7);
  @$pb.TagNumber(8)
  set version($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVersion() => $_has(7);
  @$pb.TagNumber(8)
  void clearVersion() => $_clearField(8);
}

class AdvancePostmortemResponse extends $pb.GeneratedMessage {
  factory AdvancePostmortemResponse({
    Postmortem? postmortem,
  }) {
    final result = create();
    if (postmortem != null) result.postmortem = postmortem;
    return result;
  }

  AdvancePostmortemResponse._();

  factory AdvancePostmortemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvancePostmortemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvancePostmortemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Postmortem>(1, _omitFieldNames ? '' : 'postmortem',
        subBuilder: Postmortem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvancePostmortemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvancePostmortemResponse copyWith(
          void Function(AdvancePostmortemResponse) updates) =>
      super.copyWith((message) => updates(message as AdvancePostmortemResponse))
          as AdvancePostmortemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvancePostmortemResponse create() => AdvancePostmortemResponse._();
  @$core.override
  AdvancePostmortemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvancePostmortemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvancePostmortemResponse>(create);
  static AdvancePostmortemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Postmortem get postmortem => $_getN(0);
  @$pb.TagNumber(1)
  set postmortem(Postmortem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPostmortem() => $_has(0);
  @$pb.TagNumber(1)
  void clearPostmortem() => $_clearField(1);
  @$pb.TagNumber(1)
  Postmortem ensurePostmortem() => $_ensure(0);
}

class GetPostmortemsRequest extends $pb.GeneratedMessage {
  factory GetPostmortemsRequest({
    $core.String? caseId,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    return result;
  }

  GetPostmortemsRequest._();

  factory GetPostmortemsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPostmortemsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPostmortemsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPostmortemsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPostmortemsRequest copyWith(
          void Function(GetPostmortemsRequest) updates) =>
      super.copyWith((message) => updates(message as GetPostmortemsRequest))
          as GetPostmortemsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPostmortemsRequest create() => GetPostmortemsRequest._();
  @$core.override
  GetPostmortemsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPostmortemsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPostmortemsRequest>(create);
  static GetPostmortemsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
}

class GetPostmortemsResponse extends $pb.GeneratedMessage {
  factory GetPostmortemsResponse({
    $core.Iterable<Postmortem>? postmortems,
  }) {
    final result = create();
    if (postmortems != null) result.postmortems.addAll(postmortems);
    return result;
  }

  GetPostmortemsResponse._();

  factory GetPostmortemsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPostmortemsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPostmortemsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..pPM<Postmortem>(1, _omitFieldNames ? '' : 'postmortems',
        subBuilder: Postmortem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPostmortemsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPostmortemsResponse copyWith(
          void Function(GetPostmortemsResponse) updates) =>
      super.copyWith((message) => updates(message as GetPostmortemsResponse))
          as GetPostmortemsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPostmortemsResponse create() => GetPostmortemsResponse._();
  @$core.override
  GetPostmortemsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPostmortemsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPostmortemsResponse>(create);
  static GetPostmortemsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Postmortem> get postmortems => $_getList(0);
}

class RecordAuthorisationRequest extends $pb.GeneratedMessage {
  factory RecordAuthorisationRequest({
    $core.String? caseId,
    $core.String? authority,
    $core.String? reference,
    $core.String? note,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (authority != null) result.authority = authority;
    if (reference != null) result.reference = reference;
    if (note != null) result.note = note;
    return result;
  }

  RecordAuthorisationRequest._();

  factory RecordAuthorisationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordAuthorisationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordAuthorisationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'authority')
    ..aOS(3, _omitFieldNames ? '' : 'reference')
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAuthorisationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAuthorisationRequest copyWith(
          void Function(RecordAuthorisationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RecordAuthorisationRequest))
          as RecordAuthorisationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordAuthorisationRequest create() => RecordAuthorisationRequest._();
  @$core.override
  RecordAuthorisationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordAuthorisationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordAuthorisationRequest>(create);
  static RecordAuthorisationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get authority => $_getSZ(1);
  @$pb.TagNumber(2)
  set authority($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAuthority() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthority() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reference => $_getSZ(2);
  @$pb.TagNumber(3)
  set reference($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReference() => $_has(2);
  @$pb.TagNumber(3)
  void clearReference() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);
}

class RecordAuthorisationResponse extends $pb.GeneratedMessage {
  factory RecordAuthorisationResponse({
    Authorisation? authorisation,
  }) {
    final result = create();
    if (authorisation != null) result.authorisation = authorisation;
    return result;
  }

  RecordAuthorisationResponse._();

  factory RecordAuthorisationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordAuthorisationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordAuthorisationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Authorisation>(1, _omitFieldNames ? '' : 'authorisation',
        subBuilder: Authorisation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAuthorisationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAuthorisationResponse copyWith(
          void Function(RecordAuthorisationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RecordAuthorisationResponse))
          as RecordAuthorisationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordAuthorisationResponse create() =>
      RecordAuthorisationResponse._();
  @$core.override
  RecordAuthorisationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordAuthorisationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordAuthorisationResponse>(create);
  static RecordAuthorisationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Authorisation get authorisation => $_getN(0);
  @$pb.TagNumber(1)
  set authorisation(Authorisation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAuthorisation() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthorisation() => $_clearField(1);
  @$pb.TagNumber(1)
  Authorisation ensureAuthorisation() => $_ensure(0);
}

class GetReleaseChecksRequest extends $pb.GeneratedMessage {
  factory GetReleaseChecksRequest({
    $core.String? caseId,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    return result;
  }

  GetReleaseChecksRequest._();

  factory GetReleaseChecksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReleaseChecksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReleaseChecksRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReleaseChecksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReleaseChecksRequest copyWith(
          void Function(GetReleaseChecksRequest) updates) =>
      super.copyWith((message) => updates(message as GetReleaseChecksRequest))
          as GetReleaseChecksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReleaseChecksRequest create() => GetReleaseChecksRequest._();
  @$core.override
  GetReleaseChecksRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetReleaseChecksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReleaseChecksRequest>(create);
  static GetReleaseChecksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
}

/// The whole list at once.
class GetReleaseChecksResponse extends $pb.GeneratedMessage {
  factory GetReleaseChecksResponse({
    $core.Iterable<ReleaseCheck>? checks,
  }) {
    final result = create();
    if (checks != null) result.checks.addAll(checks);
    return result;
  }

  GetReleaseChecksResponse._();

  factory GetReleaseChecksResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReleaseChecksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReleaseChecksResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..pPM<ReleaseCheck>(1, _omitFieldNames ? '' : 'checks',
        subBuilder: ReleaseCheck.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReleaseChecksResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReleaseChecksResponse copyWith(
          void Function(GetReleaseChecksResponse) updates) =>
      super.copyWith((message) => updates(message as GetReleaseChecksResponse))
          as GetReleaseChecksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReleaseChecksResponse create() => GetReleaseChecksResponse._();
  @$core.override
  GetReleaseChecksResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetReleaseChecksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReleaseChecksResponse>(create);
  static GetReleaseChecksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ReleaseCheck> get checks => $_getList(0);
}

class ReleaseBodyRequest extends $pb.GeneratedMessage {
  factory ReleaseBodyRequest({
    $core.String? caseId,
    $core.String? recipientName,
    $core.String? recipientRelation,
    $core.String? recipientIdType,
    $core.String? recipientIdRef,
    $core.String? verificationNote,
    $core.String? signatureRef,
    $core.String? deathCertificateRef,
    $core.String? destination,
    $core.String? witnessedBy,
    $core.String? note,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (recipientName != null) result.recipientName = recipientName;
    if (recipientRelation != null) result.recipientRelation = recipientRelation;
    if (recipientIdType != null) result.recipientIdType = recipientIdType;
    if (recipientIdRef != null) result.recipientIdRef = recipientIdRef;
    if (verificationNote != null) result.verificationNote = verificationNote;
    if (signatureRef != null) result.signatureRef = signatureRef;
    if (deathCertificateRef != null)
      result.deathCertificateRef = deathCertificateRef;
    if (destination != null) result.destination = destination;
    if (witnessedBy != null) result.witnessedBy = witnessedBy;
    if (note != null) result.note = note;
    if (version != null) result.version = version;
    return result;
  }

  ReleaseBodyRequest._();

  factory ReleaseBodyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseBodyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseBodyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..aOS(2, _omitFieldNames ? '' : 'recipientName')
    ..aOS(3, _omitFieldNames ? '' : 'recipientRelation')
    ..aOS(4, _omitFieldNames ? '' : 'recipientIdType')
    ..aOS(5, _omitFieldNames ? '' : 'recipientIdRef')
    ..aOS(6, _omitFieldNames ? '' : 'verificationNote')
    ..aOS(7, _omitFieldNames ? '' : 'signatureRef')
    ..aOS(8, _omitFieldNames ? '' : 'deathCertificateRef')
    ..aOS(9, _omitFieldNames ? '' : 'destination')
    ..aOS(10, _omitFieldNames ? '' : 'witnessedBy')
    ..aOS(11, _omitFieldNames ? '' : 'note')
    ..aInt64(12, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseBodyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseBodyRequest copyWith(void Function(ReleaseBodyRequest) updates) =>
      super.copyWith((message) => updates(message as ReleaseBodyRequest))
          as ReleaseBodyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseBodyRequest create() => ReleaseBodyRequest._();
  @$core.override
  ReleaseBodyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseBodyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseBodyRequest>(create);
  static ReleaseBodyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recipientName => $_getSZ(1);
  @$pb.TagNumber(2)
  set recipientName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecipientName() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecipientName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get recipientRelation => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipientRelation($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecipientRelation() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipientRelation() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get recipientIdType => $_getSZ(3);
  @$pb.TagNumber(4)
  set recipientIdType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRecipientIdType() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecipientIdType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get recipientIdRef => $_getSZ(4);
  @$pb.TagNumber(5)
  set recipientIdRef($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRecipientIdRef() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecipientIdRef() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get verificationNote => $_getSZ(5);
  @$pb.TagNumber(6)
  set verificationNote($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVerificationNote() => $_has(5);
  @$pb.TagNumber(6)
  void clearVerificationNote() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get signatureRef => $_getSZ(6);
  @$pb.TagNumber(7)
  set signatureRef($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSignatureRef() => $_has(6);
  @$pb.TagNumber(7)
  void clearSignatureRef() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get deathCertificateRef => $_getSZ(7);
  @$pb.TagNumber(8)
  set deathCertificateRef($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDeathCertificateRef() => $_has(7);
  @$pb.TagNumber(8)
  void clearDeathCertificateRef() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get destination => $_getSZ(8);
  @$pb.TagNumber(9)
  set destination($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDestination() => $_has(8);
  @$pb.TagNumber(9)
  void clearDestination() => $_clearField(9);

  /// A second member of staff, and somebody other than the caller.
  @$pb.TagNumber(10)
  $core.String get witnessedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set witnessedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasWitnessedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearWitnessedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get note => $_getSZ(10);
  @$pb.TagNumber(11)
  set note($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNote() => $_has(10);
  @$pb.TagNumber(11)
  void clearNote() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get version => $_getI64(11);
  @$pb.TagNumber(12)
  set version($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasVersion() => $_has(11);
  @$pb.TagNumber(12)
  void clearVersion() => $_clearField(12);
}

class ReleaseBodyResponse extends $pb.GeneratedMessage {
  factory ReleaseBodyResponse({
    Release? release,
  }) {
    final result = create();
    if (release != null) result.release = release;
    return result;
  }

  ReleaseBodyResponse._();

  factory ReleaseBodyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseBodyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseBodyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Release>(1, _omitFieldNames ? '' : 'release',
        subBuilder: Release.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseBodyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseBodyResponse copyWith(void Function(ReleaseBodyResponse) updates) =>
      super.copyWith((message) => updates(message as ReleaseBodyResponse))
          as ReleaseBodyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseBodyResponse create() => ReleaseBodyResponse._();
  @$core.override
  ReleaseBodyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseBodyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseBodyResponse>(create);
  static ReleaseBodyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Release get release => $_getN(0);
  @$pb.TagNumber(1)
  set release(Release value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRelease() => $_has(0);
  @$pb.TagNumber(1)
  void clearRelease() => $_clearField(1);
  @$pb.TagNumber(1)
  Release ensureRelease() => $_ensure(0);
}

class GetReleaseRequest extends $pb.GeneratedMessage {
  factory GetReleaseRequest({
    $core.String? caseId,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    return result;
  }

  GetReleaseRequest._();

  factory GetReleaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReleaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReleaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReleaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReleaseRequest copyWith(void Function(GetReleaseRequest) updates) =>
      super.copyWith((message) => updates(message as GetReleaseRequest))
          as GetReleaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReleaseRequest create() => GetReleaseRequest._();
  @$core.override
  GetReleaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetReleaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReleaseRequest>(create);
  static GetReleaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
}

class GetReleaseResponse extends $pb.GeneratedMessage {
  factory GetReleaseResponse({
    Release? release,
  }) {
    final result = create();
    if (release != null) result.release = release;
    return result;
  }

  GetReleaseResponse._();

  factory GetReleaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReleaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReleaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<Release>(1, _omitFieldNames ? '' : 'release',
        subBuilder: Release.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReleaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReleaseResponse copyWith(void Function(GetReleaseResponse) updates) =>
      super.copyWith((message) => updates(message as GetReleaseResponse))
          as GetReleaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReleaseResponse create() => GetReleaseResponse._();
  @$core.override
  GetReleaseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetReleaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReleaseResponse>(create);
  static GetReleaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Release get release => $_getN(0);
  @$pb.TagNumber(1)
  set release(Release value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRelease() => $_has(0);
  @$pb.TagNumber(1)
  void clearRelease() => $_clearField(1);
  @$pb.TagNumber(1)
  Release ensureRelease() => $_ensure(0);
}

class ListReleasesRequest extends $pb.GeneratedMessage {
  factory ListReleasesRequest({
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
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
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..aI(4, _omitFieldNames ? '' : 'offset')
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

  @$pb.TagNumber(4)
  $core.int get offset => $_getIZ(3);
  @$pb.TagNumber(4)
  set offset($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);
}

class ListReleasesResponse extends $pb.GeneratedMessage {
  factory ListReleasesResponse({
    $core.Iterable<Release>? releases,
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
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..pPM<Release>(1, _omitFieldNames ? '' : 'releases',
        subBuilder: Release.create)
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
  $pb.PbList<Release> get releases => $_getList(0);
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
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
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
    Occupancy? occupancy,
    $core.bool? truncated,
  }) {
    final result = create();
    if (rows != null) result.rows.addAll(rows);
    if (occupancy != null) result.occupancy = occupancy;
    if (truncated != null) result.truncated = truncated;
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
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..pPM<BoardRow>(1, _omitFieldNames ? '' : 'rows',
        subBuilder: BoardRow.create)
    ..aOM<Occupancy>(2, _omitFieldNames ? '' : 'occupancy',
        subBuilder: Occupancy.create)
    ..aOB(3, _omitFieldNames ? '' : 'truncated')
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

  @$pb.TagNumber(2)
  Occupancy get occupancy => $_getN(1);
  @$pb.TagNumber(2)
  set occupancy(Occupancy value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOccupancy() => $_has(1);
  @$pb.TagNumber(2)
  void clearOccupancy() => $_clearField(2);
  @$pb.TagNumber(2)
  Occupancy ensureOccupancy() => $_ensure(1);

  /// The mortuary holds more cases than one dashboard may read, so these
  /// figures come from part of it.
  @$pb.TagNumber(3)
  $core.bool get truncated => $_getBF(2);
  @$pb.TagNumber(3)
  set truncated($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTruncated() => $_has(2);
  @$pb.TagNumber(3)
  void clearTruncated() => $_clearField(3);
}

class SweepLongStayRequest extends $pb.GeneratedMessage {
  factory SweepLongStayRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  SweepLongStayRequest._();

  factory SweepLongStayRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SweepLongStayRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SweepLongStayRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepLongStayRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepLongStayRequest copyWith(void Function(SweepLongStayRequest) updates) =>
      super.copyWith((message) => updates(message as SweepLongStayRequest))
          as SweepLongStayRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SweepLongStayRequest create() => SweepLongStayRequest._();
  @$core.override
  SweepLongStayRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SweepLongStayRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SweepLongStayRequest>(create);
  static SweepLongStayRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

class SweepLongStayResponse extends $pb.GeneratedMessage {
  factory SweepLongStayResponse({
    $core.int? raised,
  }) {
    final result = create();
    if (raised != null) result.raised = raised;
    return result;
  }

  SweepLongStayResponse._();

  factory SweepLongStayResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SweepLongStayResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SweepLongStayResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.mortuary.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'raised')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepLongStayResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepLongStayResponse copyWith(
          void Function(SweepLongStayResponse) updates) =>
      super.copyWith((message) => updates(message as SweepLongStayResponse))
          as SweepLongStayResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SweepLongStayResponse create() => SweepLongStayResponse._();
  @$core.override
  SweepLongStayResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SweepLongStayResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SweepLongStayResponse>(create);
  static SweepLongStayResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get raised => $_getIZ(0);
  @$pb.TagNumber(1)
  set raised($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRaised() => $_has(0);
  @$pb.TagNumber(1)
  void clearRaised() => $_clearField(1);
}

/// Mortuary operations (SRS-MORT-001 … 008).
class MortuaryServiceApi {
  final $pb.RpcClient _client;

  MortuaryServiceApi(this._client);

  /// SRS-MORT-001 and SRS-MORT-003.
  $async.Future<OpenCaseResponse> openCase(
          $pb.ClientContext? ctx, OpenCaseRequest request) =>
      _client.invoke<OpenCaseResponse>(
          ctx, 'MortuaryService', 'OpenCase', request, OpenCaseResponse());
  $async.Future<IdentifyResponse> identify(
          $pb.ClientContext? ctx, IdentifyRequest request) =>
      _client.invoke<IdentifyResponse>(
          ctx, 'MortuaryService', 'Identify', request, IdentifyResponse());

  /// Its own permission, mort.cause.record. The cause is not known when the
  /// body arrives, so it is recorded when it is.
  $async.Future<RecordCauseResponse> recordCause(
          $pb.ClientContext? ctx, RecordCauseRequest request) =>
      _client.invoke<RecordCauseResponse>(ctx, 'MortuaryService', 'RecordCause',
          request, RecordCauseResponse());
  $async.Future<RecordDeathCertificateResponse> recordDeathCertificate(
          $pb.ClientContext? ctx, RecordDeathCertificateRequest request) =>
      _client.invoke<RecordDeathCertificateResponse>(ctx, 'MortuaryService',
          'RecordDeathCertificate', request, RecordDeathCertificateResponse());
  $async.Future<MarkMedicoLegalResponse> markMedicoLegal(
          $pb.ClientContext? ctx, MarkMedicoLegalRequest request) =>
      _client.invoke<MarkMedicoLegalResponse>(ctx, 'MortuaryService',
          'MarkMedicoLegal', request, MarkMedicoLegalResponse());
  $async.Future<GetCaseResponse> getCase(
          $pb.ClientContext? ctx, GetCaseRequest request) =>
      _client.invoke<GetCaseResponse>(
          ctx, 'MortuaryService', 'GetCase', request, GetCaseResponse());
  $async.Future<GetCaseByReferenceResponse> getCaseByReference(
          $pb.ClientContext? ctx, GetCaseByReferenceRequest request) =>
      _client.invoke<GetCaseByReferenceResponse>(ctx, 'MortuaryService',
          'GetCaseByReference', request, GetCaseByReferenceResponse());
  $async.Future<ListCasesResponse> listCases(
          $pb.ClientContext? ctx, ListCasesRequest request) =>
      _client.invoke<ListCasesResponse>(
          ctx, 'MortuaryService', 'ListCases', request, ListCasesResponse());

  /// SRS-MORT-002.
  $async.Future<AddLocationResponse> addLocation(
          $pb.ClientContext? ctx, AddLocationRequest request) =>
      _client.invoke<AddLocationResponse>(ctx, 'MortuaryService', 'AddLocation',
          request, AddLocationResponse());
  $async.Future<SetLocationServiceResponse> setLocationService(
          $pb.ClientContext? ctx, SetLocationServiceRequest request) =>
      _client.invoke<SetLocationServiceResponse>(ctx, 'MortuaryService',
          'SetLocationService', request, SetLocationServiceResponse());
  $async.Future<ListLocationsResponse> listLocations(
          $pb.ClientContext? ctx, ListLocationsRequest request) =>
      _client.invoke<ListLocationsResponse>(ctx, 'MortuaryService',
          'ListLocations', request, ListLocationsResponse());
  $async.Future<PlaceBodyResponse> placeBody(
          $pb.ClientContext? ctx, PlaceBodyRequest request) =>
      _client.invoke<PlaceBodyResponse>(
          ctx, 'MortuaryService', 'PlaceBody', request, PlaceBodyResponse());
  $async.Future<GetPlacementHistoryResponse> getPlacementHistory(
          $pb.ClientContext? ctx, GetPlacementHistoryRequest request) =>
      _client.invoke<GetPlacementHistoryResponse>(ctx, 'MortuaryService',
          'GetPlacementHistory', request, GetPlacementHistoryResponse());

  /// SRS-MORT-004.
  $async.Future<ListItemResponse> listItem(
          $pb.ClientContext? ctx, ListItemRequest request) =>
      _client.invoke<ListItemResponse>(
          ctx, 'MortuaryService', 'ListItem', request, ListItemResponse());
  $async.Future<RetainItemResponse> retainItem(
          $pb.ClientContext? ctx, RetainItemRequest request) =>
      _client.invoke<RetainItemResponse>(
          ctx, 'MortuaryService', 'RetainItem', request, RetainItemResponse());
  $async.Future<HandOverBelongingsResponse> handOverBelongings(
          $pb.ClientContext? ctx, HandOverBelongingsRequest request) =>
      _client.invoke<HandOverBelongingsResponse>(ctx, 'MortuaryService',
          'HandOverBelongings', request, HandOverBelongingsResponse());
  $async.Future<GetBelongingsResponse> getBelongings(
          $pb.ClientContext? ctx, GetBelongingsRequest request) =>
      _client.invoke<GetBelongingsResponse>(ctx, 'MortuaryService',
          'GetBelongings', request, GetBelongingsResponse());
  $async.Future<GetChainOfCustodyResponse> getChainOfCustody(
          $pb.ClientContext? ctx, GetChainOfCustodyRequest request) =>
      _client.invoke<GetChainOfCustodyResponse>(ctx, 'MortuaryService',
          'GetChainOfCustody', request, GetChainOfCustodyResponse());

  /// SRS-MORT-005.
  $async.Future<RequestPostmortemResponse> requestPostmortem(
          $pb.ClientContext? ctx, RequestPostmortemRequest request) =>
      _client.invoke<RequestPostmortemResponse>(ctx, 'MortuaryService',
          'RequestPostmortem', request, RequestPostmortemResponse());
  $async.Future<AdvancePostmortemResponse> advancePostmortem(
          $pb.ClientContext? ctx, AdvancePostmortemRequest request) =>
      _client.invoke<AdvancePostmortemResponse>(ctx, 'MortuaryService',
          'AdvancePostmortem', request, AdvancePostmortemResponse());
  $async.Future<GetPostmortemsResponse> getPostmortems(
          $pb.ClientContext? ctx, GetPostmortemsRequest request) =>
      _client.invoke<GetPostmortemsResponse>(ctx, 'MortuaryService',
          'GetPostmortems', request, GetPostmortemsResponse());

  /// SRS-MORT-006 and SRS-MORT-007.
  $async.Future<RecordAuthorisationResponse> recordAuthorisation(
          $pb.ClientContext? ctx, RecordAuthorisationRequest request) =>
      _client.invoke<RecordAuthorisationResponse>(ctx, 'MortuaryService',
          'RecordAuthorisation', request, RecordAuthorisationResponse());
  $async.Future<GetReleaseChecksResponse> getReleaseChecks(
          $pb.ClientContext? ctx, GetReleaseChecksRequest request) =>
      _client.invoke<GetReleaseChecksResponse>(ctx, 'MortuaryService',
          'GetReleaseChecks', request, GetReleaseChecksResponse());
  $async.Future<ReleaseBodyResponse> releaseBody(
          $pb.ClientContext? ctx, ReleaseBodyRequest request) =>
      _client.invoke<ReleaseBodyResponse>(ctx, 'MortuaryService', 'ReleaseBody',
          request, ReleaseBodyResponse());
  $async.Future<GetReleaseResponse> getRelease(
          $pb.ClientContext? ctx, GetReleaseRequest request) =>
      _client.invoke<GetReleaseResponse>(
          ctx, 'MortuaryService', 'GetRelease', request, GetReleaseResponse());
  $async.Future<ListReleasesResponse> listReleases(
          $pb.ClientContext? ctx, ListReleasesRequest request) =>
      _client.invoke<ListReleasesResponse>(ctx, 'MortuaryService',
          'ListReleases', request, ListReleasesResponse());

  /// SRS-MORT-008.
  $async.Future<GetBoardResponse> getBoard(
          $pb.ClientContext? ctx, GetBoardRequest request) =>
      _client.invoke<GetBoardResponse>(
          ctx, 'MortuaryService', 'GetBoard', request, GetBoardResponse());
  $async.Future<SweepLongStayResponse> sweepLongStay(
          $pb.ClientContext? ctx, SweepLongStayRequest request) =>
      _client.invoke<SweepLongStayResponse>(ctx, 'MortuaryService',
          'SweepLongStay', request, SweepLongStayResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
