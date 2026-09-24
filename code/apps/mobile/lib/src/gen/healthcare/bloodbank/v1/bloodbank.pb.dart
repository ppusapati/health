// This is a generated file - do not edit.
//
// Generated from healthcare/bloodbank/v1/bloodbank.proto.

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

import 'bloodbank.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'bloodbank.pbenum.dart';

/// A complete ABO and Rh(D) type.
class BloodGroup extends $pb.GeneratedMessage {
  factory BloodGroup({
    Abo? abo,
    RhD? rhD,
    $core.String? display,
  }) {
    final result = create();
    if (abo != null) result.abo = abo;
    if (rhD != null) result.rhD = rhD;
    if (display != null) result.display = display;
    return result;
  }

  BloodGroup._();

  factory BloodGroup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BloodGroup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BloodGroup',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aE<Abo>(1, _omitFieldNames ? '' : 'abo', enumValues: Abo.values)
    ..aE<RhD>(2, _omitFieldNames ? '' : 'rhD', enumValues: RhD.values)
    ..aOS(3, _omitFieldNames ? '' : 'display')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BloodGroup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BloodGroup copyWith(void Function(BloodGroup) updates) =>
      super.copyWith((message) => updates(message as BloodGroup)) as BloodGroup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BloodGroup create() => BloodGroup._();
  @$core.override
  BloodGroup createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BloodGroup getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BloodGroup>(create);
  static BloodGroup? _defaultInstance;

  @$pb.TagNumber(1)
  Abo get abo => $_getN(0);
  @$pb.TagNumber(1)
  set abo(Abo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAbo() => $_has(0);
  @$pb.TagNumber(1)
  void clearAbo() => $_clearField(1);

  @$pb.TagNumber(2)
  RhD get rhD => $_getN(1);
  @$pb.TagNumber(2)
  set rhD(RhD value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRhD() => $_has(1);
  @$pb.TagNumber(2)
  void clearRhD() => $_clearField(2);

  /// Rendered the way a label reads it — "O-", "AB+" — so a client need not
  /// reimplement the formatting for a bedside screen.
  @$pb.TagNumber(3)
  $core.String get display => $_getSZ(2);
  @$pb.TagNumber(3)
  set display($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplay() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplay() => $_clearField(3);
}

/// Somebody who gives blood (SRS-BLD-001, SRS-BLD-002).
class Donor extends $pb.GeneratedMessage {
  factory Donor({
    $core.String? donorId,
    $core.String? donorNumber,
    $core.String? patientId,
    $core.String? displayName,
    $core.String? contactPhone,
    BloodGroup? group,
    DeferralKind? deferral,
    $core.String? deferralCode,
    $core.String? deferralNote,
    $0.Timestamp? deferredAt,
    $core.String? deferredBy,
    $0.Timestamp? deferredUntil,
    $core.bool? currentlyDeferred,
    $0.Timestamp? registeredAt,
    $core.String? registeredBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (donorId != null) result.donorId = donorId;
    if (donorNumber != null) result.donorNumber = donorNumber;
    if (patientId != null) result.patientId = patientId;
    if (displayName != null) result.displayName = displayName;
    if (contactPhone != null) result.contactPhone = contactPhone;
    if (group != null) result.group = group;
    if (deferral != null) result.deferral = deferral;
    if (deferralCode != null) result.deferralCode = deferralCode;
    if (deferralNote != null) result.deferralNote = deferralNote;
    if (deferredAt != null) result.deferredAt = deferredAt;
    if (deferredBy != null) result.deferredBy = deferredBy;
    if (deferredUntil != null) result.deferredUntil = deferredUntil;
    if (currentlyDeferred != null) result.currentlyDeferred = currentlyDeferred;
    if (registeredAt != null) result.registeredAt = registeredAt;
    if (registeredBy != null) result.registeredBy = registeredBy;
    if (version != null) result.version = version;
    return result;
  }

  Donor._();

  factory Donor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Donor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Donor',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'donorId')
    ..aOS(2, _omitFieldNames ? '' : 'donorNumber')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'displayName')
    ..aOS(5, _omitFieldNames ? '' : 'contactPhone')
    ..aOM<BloodGroup>(6, _omitFieldNames ? '' : 'group',
        subBuilder: BloodGroup.create)
    ..aE<DeferralKind>(7, _omitFieldNames ? '' : 'deferral',
        enumValues: DeferralKind.values)
    ..aOS(8, _omitFieldNames ? '' : 'deferralCode')
    ..aOS(9, _omitFieldNames ? '' : 'deferralNote')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'deferredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'deferredBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'deferredUntil',
        subBuilder: $0.Timestamp.create)
    ..aOB(13, _omitFieldNames ? '' : 'currentlyDeferred')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'registeredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'registeredBy')
    ..aInt64(16, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Donor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Donor copyWith(void Function(Donor) updates) =>
      super.copyWith((message) => updates(message as Donor)) as Donor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Donor create() => Donor._();
  @$core.override
  Donor createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Donor getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Donor>(create);
  static Donor? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get donorId => $_getSZ(0);
  @$pb.TagNumber(1)
  set donorId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDonorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDonorId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get donorNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set donorNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDonorNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearDonorNumber() => $_clearField(2);

  /// Set for a donor who is also a patient here: the autologous and
  /// directed-donation cases.
  @$pb.TagNumber(3)
  $core.String get patientId => $_getSZ(2);
  @$pb.TagNumber(3)
  set patientId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPatientId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatientId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get displayName => $_getSZ(3);
  @$pb.TagNumber(4)
  set displayName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisplayName() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplayName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get contactPhone => $_getSZ(4);
  @$pb.TagNumber(5)
  set contactPhone($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContactPhone() => $_has(4);
  @$pb.TagNumber(5)
  void clearContactPhone() => $_clearField(5);

  /// May be unspecified until the first donation is tested, which is an
  /// ordinary state for a donor and never one for a component.
  @$pb.TagNumber(6)
  BloodGroup get group => $_getN(5);
  @$pb.TagNumber(6)
  set group(BloodGroup value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasGroup() => $_has(5);
  @$pb.TagNumber(6)
  void clearGroup() => $_clearField(6);
  @$pb.TagNumber(6)
  BloodGroup ensureGroup() => $_ensure(5);

  @$pb.TagNumber(7)
  DeferralKind get deferral => $_getN(6);
  @$pb.TagNumber(7)
  set deferral(DeferralKind value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDeferral() => $_has(6);
  @$pb.TagNumber(7)
  void clearDeferral() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get deferralCode => $_getSZ(7);
  @$pb.TagNumber(8)
  set deferralCode($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDeferralCode() => $_has(7);
  @$pb.TagNumber(8)
  void clearDeferralCode() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get deferralNote => $_getSZ(8);
  @$pb.TagNumber(9)
  set deferralNote($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDeferralNote() => $_has(8);
  @$pb.TagNumber(9)
  void clearDeferralNote() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get deferredAt => $_getN(9);
  @$pb.TagNumber(10)
  set deferredAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasDeferredAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearDeferredAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureDeferredAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get deferredBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set deferredBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDeferredBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearDeferredBy() => $_clearField(11);

  /// Absent on a permanent deferral, which is what makes the two
  /// distinguishable without reading the kind.
  @$pb.TagNumber(12)
  $0.Timestamp get deferredUntil => $_getN(11);
  @$pb.TagNumber(12)
  set deferredUntil($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasDeferredUntil() => $_has(11);
  @$pb.TagNumber(12)
  void clearDeferredUntil() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureDeferredUntil() => $_ensure(11);

  /// Derived at the moment of rendering: a temporary deferral lapses on its own
  /// date rather than waiting for a job, because a donor still deferred because
  /// nobody ran one is a donor turned away for no reason.
  @$pb.TagNumber(13)
  $core.bool get currentlyDeferred => $_getBF(12);
  @$pb.TagNumber(13)
  set currentlyDeferred($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCurrentlyDeferred() => $_has(12);
  @$pb.TagNumber(13)
  void clearCurrentlyDeferred() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get registeredAt => $_getN(13);
  @$pb.TagNumber(14)
  set registeredAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasRegisteredAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearRegisteredAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureRegisteredAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get registeredBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set registeredBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasRegisteredBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearRegisteredBy() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get version => $_getI64(15);
  @$pb.TagNumber(16)
  set version($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasVersion() => $_has(15);
  @$pb.TagNumber(16)
  void clearVersion() => $_clearField(16);
}

/// One donor screening episode (SRS-BLD-002).
class Screening extends $pb.GeneratedMessage {
  factory Screening({
    $core.String? screeningId,
    $core.String? donorId,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? answers,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? measurements,
    $core.bool? consented,
    $core.String? consentNote,
    $core.bool? accepted,
    DeferralKind? deferral,
    $core.String? deferralCode,
    $0.Timestamp? screenedAt,
    $core.String? screenedBy,
  }) {
    final result = create();
    if (screeningId != null) result.screeningId = screeningId;
    if (donorId != null) result.donorId = donorId;
    if (answers != null) result.answers.addEntries(answers);
    if (measurements != null) result.measurements.addEntries(measurements);
    if (consented != null) result.consented = consented;
    if (consentNote != null) result.consentNote = consentNote;
    if (accepted != null) result.accepted = accepted;
    if (deferral != null) result.deferral = deferral;
    if (deferralCode != null) result.deferralCode = deferralCode;
    if (screenedAt != null) result.screenedAt = screenedAt;
    if (screenedBy != null) result.screenedBy = screenedBy;
    return result;
  }

  Screening._();

  factory Screening.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Screening.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Screening',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'screeningId')
    ..aOS(2, _omitFieldNames ? '' : 'donorId')
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'answers',
        entryClassName: 'Screening.AnswersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('healthcare.bloodbank.v1'))
    ..m<$core.String, $core.double>(4, _omitFieldNames ? '' : 'measurements',
        entryClassName: 'Screening.MeasurementsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('healthcare.bloodbank.v1'))
    ..aOB(5, _omitFieldNames ? '' : 'consented')
    ..aOS(6, _omitFieldNames ? '' : 'consentNote')
    ..aOB(7, _omitFieldNames ? '' : 'accepted')
    ..aE<DeferralKind>(8, _omitFieldNames ? '' : 'deferral',
        enumValues: DeferralKind.values)
    ..aOS(9, _omitFieldNames ? '' : 'deferralCode')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'screenedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'screenedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Screening clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Screening copyWith(void Function(Screening) updates) =>
      super.copyWith((message) => updates(message as Screening)) as Screening;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Screening create() => Screening._();
  @$core.override
  Screening createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Screening getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Screening>(create);
  static Screening? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get screeningId => $_getSZ(0);
  @$pb.TagNumber(1)
  set screeningId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScreeningId() => $_has(0);
  @$pb.TagNumber(1)
  void clearScreeningId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get donorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set donorId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDonorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDonorId() => $_clearField(2);

  /// The questionnaire as answered and the bedside measurements, kept as given
  /// rather than reduced to a verdict: the verdict is what somebody decided,
  /// and these are what the donor said and what was measured.
  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get answers => $_getMap(2);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.double> get measurements => $_getMap(3);

  @$pb.TagNumber(5)
  $core.bool get consented => $_getBF(4);
  @$pb.TagNumber(5)
  set consented($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConsented() => $_has(4);
  @$pb.TagNumber(5)
  void clearConsented() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get consentNote => $_getSZ(5);
  @$pb.TagNumber(6)
  set consentNote($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasConsentNote() => $_has(5);
  @$pb.TagNumber(6)
  void clearConsentNote() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get accepted => $_getBF(6);
  @$pb.TagNumber(7)
  set accepted($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAccepted() => $_has(6);
  @$pb.TagNumber(7)
  void clearAccepted() => $_clearField(7);

  @$pb.TagNumber(8)
  DeferralKind get deferral => $_getN(7);
  @$pb.TagNumber(8)
  set deferral(DeferralKind value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDeferral() => $_has(7);
  @$pb.TagNumber(8)
  void clearDeferral() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get deferralCode => $_getSZ(8);
  @$pb.TagNumber(9)
  set deferralCode($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDeferralCode() => $_has(8);
  @$pb.TagNumber(9)
  void clearDeferralCode() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get screenedAt => $_getN(9);
  @$pb.TagNumber(10)
  set screenedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasScreenedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearScreenedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureScreenedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get screenedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set screenedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasScreenedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearScreenedBy() => $_clearField(11);
}

/// One donation (SRS-BLD-003).
class Collection extends $pb.GeneratedMessage {
  factory Collection({
    $core.String? collectionId,
    $core.String? donorId,
    $core.String? screeningId,
    $core.String? donationNumber,
    $core.String? kind,
    $core.int? volumeMl,
    BloodGroup? group,
    $0.Timestamp? collectedAt,
    $core.String? collectedBy,
    $core.bool? adverseEvent,
    $core.String? adverseNote,
  }) {
    final result = create();
    if (collectionId != null) result.collectionId = collectionId;
    if (donorId != null) result.donorId = donorId;
    if (screeningId != null) result.screeningId = screeningId;
    if (donationNumber != null) result.donationNumber = donationNumber;
    if (kind != null) result.kind = kind;
    if (volumeMl != null) result.volumeMl = volumeMl;
    if (group != null) result.group = group;
    if (collectedAt != null) result.collectedAt = collectedAt;
    if (collectedBy != null) result.collectedBy = collectedBy;
    if (adverseEvent != null) result.adverseEvent = adverseEvent;
    if (adverseNote != null) result.adverseNote = adverseNote;
    return result;
  }

  Collection._();

  factory Collection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Collection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Collection',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'collectionId')
    ..aOS(2, _omitFieldNames ? '' : 'donorId')
    ..aOS(3, _omitFieldNames ? '' : 'screeningId')
    ..aOS(4, _omitFieldNames ? '' : 'donationNumber')
    ..aOS(5, _omitFieldNames ? '' : 'kind')
    ..aI(6, _omitFieldNames ? '' : 'volumeMl')
    ..aOM<BloodGroup>(7, _omitFieldNames ? '' : 'group',
        subBuilder: BloodGroup.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'collectedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'collectedBy')
    ..aOB(10, _omitFieldNames ? '' : 'adverseEvent')
    ..aOS(11, _omitFieldNames ? '' : 'adverseNote')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Collection clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Collection copyWith(void Function(Collection) updates) =>
      super.copyWith((message) => updates(message as Collection)) as Collection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Collection create() => Collection._();
  @$core.override
  Collection createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Collection getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Collection>(create);
  static Collection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get collectionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set collectionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCollectionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCollectionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get donorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set donorId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDonorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDonorId() => $_clearField(2);

  /// The screening that permitted it. "A deferred donor cannot proceed" is only
  /// enforceable if the collection names the decision that let it happen.
  @$pb.TagNumber(3)
  $core.String get screeningId => $_getSZ(2);
  @$pb.TagNumber(3)
  set screeningId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScreeningId() => $_has(2);
  @$pb.TagNumber(3)
  void clearScreeningId() => $_clearField(3);

  /// Every component made from it inherits this as its parent.
  @$pb.TagNumber(4)
  $core.String get donationNumber => $_getSZ(3);
  @$pb.TagNumber(4)
  set donationNumber($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDonationNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearDonationNumber() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get kind => $_getSZ(4);
  @$pb.TagNumber(5)
  set kind($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearKind() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get volumeMl => $_getIZ(5);
  @$pb.TagNumber(6)
  set volumeMl($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVolumeMl() => $_has(5);
  @$pb.TagNumber(6)
  void clearVolumeMl() => $_clearField(6);

  @$pb.TagNumber(7)
  BloodGroup get group => $_getN(6);
  @$pb.TagNumber(7)
  set group(BloodGroup value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasGroup() => $_has(6);
  @$pb.TagNumber(7)
  void clearGroup() => $_clearField(7);
  @$pb.TagNumber(7)
  BloodGroup ensureGroup() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get collectedAt => $_getN(7);
  @$pb.TagNumber(8)
  set collectedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCollectedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCollectedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureCollectedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get collectedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set collectedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCollectedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearCollectedBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get adverseEvent => $_getBF(9);
  @$pb.TagNumber(10)
  set adverseEvent($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAdverseEvent() => $_has(9);
  @$pb.TagNumber(10)
  void clearAdverseEvent() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get adverseNote => $_getSZ(10);
  @$pb.TagNumber(11)
  set adverseNote($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasAdverseNote() => $_has(10);
  @$pb.TagNumber(11)
  void clearAdverseNote() => $_clearField(11);
}

/// One mandatory test on a collection (SRS-BLD-004).
class TestResult extends $pb.GeneratedMessage {
  factory TestResult({
    $core.String? testId,
    $core.String? collectionId,
    $core.String? code,
    $core.String? display,
    $core.bool? reactive,
    $core.String? value,
    $core.String? method,
    $0.Timestamp? testedAt,
    $core.String? testedBy,
  }) {
    final result = create();
    if (testId != null) result.testId = testId;
    if (collectionId != null) result.collectionId = collectionId;
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (reactive != null) result.reactive = reactive;
    if (value != null) result.value = value;
    if (method != null) result.method = method;
    if (testedAt != null) result.testedAt = testedAt;
    if (testedBy != null) result.testedBy = testedBy;
    return result;
  }

  TestResult._();

  factory TestResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TestResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TestResult',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'testId')
    ..aOS(2, _omitFieldNames ? '' : 'collectionId')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'display')
    ..aOB(5, _omitFieldNames ? '' : 'reactive')
    ..aOS(6, _omitFieldNames ? '' : 'value')
    ..aOS(7, _omitFieldNames ? '' : 'method')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'testedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'testedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestResult copyWith(void Function(TestResult) updates) =>
      super.copyWith((message) => updates(message as TestResult)) as TestResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestResult create() => TestResult._();
  @$core.override
  TestResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TestResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TestResult>(create);
  static TestResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get testId => $_getSZ(0);
  @$pb.TagNumber(1)
  set testId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTestId() => $_clearField(1);

  /// On the donation, not the component: the tests run once and every component
  /// made from it inherits the outcome.
  @$pb.TagNumber(2)
  $core.String get collectionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set collectionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCollectionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCollectionId() => $_clearField(2);

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

  /// Named for what the assay says. A screening test is reactive and a
  /// confirmatory one is positive; conflating them discards good blood.
  @$pb.TagNumber(5)
  $core.bool get reactive => $_getBF(4);
  @$pb.TagNumber(5)
  set reactive($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReactive() => $_has(4);
  @$pb.TagNumber(5)
  void clearReactive() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get value => $_getSZ(5);
  @$pb.TagNumber(6)
  set value($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearValue() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get method => $_getSZ(6);
  @$pb.TagNumber(7)
  set method($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMethod() => $_has(6);
  @$pb.TagNumber(7)
  void clearMethod() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get testedAt => $_getN(7);
  @$pb.TagNumber(8)
  set testedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasTestedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearTestedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureTestedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get testedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set testedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTestedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearTestedBy() => $_clearField(9);
}

/// Whether a collection's components may leave quarantine (SRS-BLD-004).
class ReleaseDecision extends $pb.GeneratedMessage {
  factory ReleaseDecision({
    $core.bool? releasable,
    $core.Iterable<$core.String>? missing,
    $core.Iterable<$core.String>? reactive,
  }) {
    final result = create();
    if (releasable != null) result.releasable = releasable;
    if (missing != null) result.missing.addAll(missing);
    if (reactive != null) result.reactive.addAll(reactive);
    return result;
  }

  ReleaseDecision._();

  factory ReleaseDecision.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseDecision.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseDecision',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'releasable')
    ..pPS(2, _omitFieldNames ? '' : 'missing')
    ..pPS(3, _omitFieldNames ? '' : 'reactive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseDecision clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseDecision copyWith(void Function(ReleaseDecision) updates) =>
      super.copyWith((message) => updates(message as ReleaseDecision))
          as ReleaseDecision;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseDecision create() => ReleaseDecision._();
  @$core.override
  ReleaseDecision createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseDecision getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseDecision>(create);
  static ReleaseDecision? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get releasable => $_getBF(0);
  @$pb.TagNumber(1)
  set releasable($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReleasable() => $_has(0);
  @$pb.TagNumber(1)
  void clearReleasable() => $_clearField(1);

  /// Mandatory tests with no result, named so a scientist knows which assay to
  /// run rather than that "testing is incomplete".
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get missing => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get reactive => $_getList(2);
}

/// One transfusable unit (SRS-BLD-003, SRS-BLD-005).
class Component extends $pb.GeneratedMessage {
  factory Component({
    $core.String? componentId,
    $core.String? unitNumber,
    $core.String? collectionId,
    $core.String? donorId,
    $core.String? source,
    ComponentClass? componentClass,
    BloodGroup? group,
    UnitStatus? status,
    DiscardReason? discardReason,
    $core.int? volumeMl,
    $core.Iterable<$core.String>? attributes,
    $core.String? location,
    $0.Timestamp? collectedAt,
    $0.Timestamp? expiresAt,
    $core.bool? issuable,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (componentId != null) result.componentId = componentId;
    if (unitNumber != null) result.unitNumber = unitNumber;
    if (collectionId != null) result.collectionId = collectionId;
    if (donorId != null) result.donorId = donorId;
    if (source != null) result.source = source;
    if (componentClass != null) result.componentClass = componentClass;
    if (group != null) result.group = group;
    if (status != null) result.status = status;
    if (discardReason != null) result.discardReason = discardReason;
    if (volumeMl != null) result.volumeMl = volumeMl;
    if (attributes != null) result.attributes.addAll(attributes);
    if (location != null) result.location = location;
    if (collectedAt != null) result.collectedAt = collectedAt;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (issuable != null) result.issuable = issuable;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  Component._();

  factory Component.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Component.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Component',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'componentId')
    ..aOS(2, _omitFieldNames ? '' : 'unitNumber')
    ..aOS(3, _omitFieldNames ? '' : 'collectionId')
    ..aOS(4, _omitFieldNames ? '' : 'donorId')
    ..aOS(5, _omitFieldNames ? '' : 'source')
    ..aE<ComponentClass>(6, _omitFieldNames ? '' : 'componentClass',
        enumValues: ComponentClass.values)
    ..aOM<BloodGroup>(7, _omitFieldNames ? '' : 'group',
        subBuilder: BloodGroup.create)
    ..aE<UnitStatus>(8, _omitFieldNames ? '' : 'status',
        enumValues: UnitStatus.values)
    ..aE<DiscardReason>(9, _omitFieldNames ? '' : 'discardReason',
        enumValues: DiscardReason.values)
    ..aI(10, _omitFieldNames ? '' : 'volumeMl')
    ..pPS(11, _omitFieldNames ? '' : 'attributes')
    ..aOS(12, _omitFieldNames ? '' : 'location')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'collectedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(15, _omitFieldNames ? '' : 'issuable')
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(17, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(18, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Component clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Component copyWith(void Function(Component) updates) =>
      super.copyWith((message) => updates(message as Component)) as Component;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Component create() => Component._();
  @$core.override
  Component createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Component getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Component>(create);
  static Component? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get componentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set componentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasComponentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponentId() => $_clearField(1);

  /// The identifier on the label, which the bedside check reads aloud.
  @$pb.TagNumber(2)
  $core.String get unitNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set unitNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get collectionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set collectionId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCollectionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCollectionId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get donorId => $_getSZ(3);
  @$pb.TagNumber(4)
  set donorId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDonorId() => $_has(3);
  @$pb.TagNumber(4)
  void clearDonorId() => $_clearField(4);

  /// The external supplier, for a unit received rather than collected here.
  @$pb.TagNumber(5)
  $core.String get source => $_getSZ(4);
  @$pb.TagNumber(5)
  set source($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearSource() => $_clearField(5);

  @$pb.TagNumber(6)
  ComponentClass get componentClass => $_getN(5);
  @$pb.TagNumber(6)
  set componentClass(ComponentClass value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasComponentClass() => $_has(5);
  @$pb.TagNumber(6)
  void clearComponentClass() => $_clearField(6);

  @$pb.TagNumber(7)
  BloodGroup get group => $_getN(6);
  @$pb.TagNumber(7)
  set group(BloodGroup value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasGroup() => $_has(6);
  @$pb.TagNumber(7)
  void clearGroup() => $_clearField(7);
  @$pb.TagNumber(7)
  BloodGroup ensureGroup() => $_ensure(6);

  @$pb.TagNumber(8)
  UnitStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(UnitStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  DiscardReason get discardReason => $_getN(8);
  @$pb.TagNumber(9)
  set discardReason(DiscardReason value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasDiscardReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearDiscardReason() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get volumeMl => $_getIZ(9);
  @$pb.TagNumber(10)
  set volumeMl($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVolumeMl() => $_has(9);
  @$pb.TagNumber(10)
  void clearVolumeMl() => $_clearField(10);

  /// Irradiated, leucodepleted, CMV-negative, washed. Matched rather than
  /// interpreted, so a deployment adds one without a code change.
  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get attributes => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get location => $_getSZ(11);
  @$pb.TagNumber(12)
  set location($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasLocation() => $_has(11);
  @$pb.TagNumber(12)
  void clearLocation() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get collectedAt => $_getN(12);
  @$pb.TagNumber(13)
  set collectedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCollectedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCollectedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureCollectedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Timestamp get expiresAt => $_getN(13);
  @$pb.TagNumber(14)
  set expiresAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasExpiresAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearExpiresAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureExpiresAt() => $_ensure(13);

  /// Derived, so a client cannot offer an expired unit by checking only the
  /// status: the two fail independently.
  @$pb.TagNumber(15)
  $core.bool get issuable => $_getBF(14);
  @$pb.TagNumber(15)
  set issuable($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasIssuable() => $_has(14);
  @$pb.TagNumber(15)
  void clearIssuable() => $_clearField(15);

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

/// A clinician's request for blood (SRS-BLD-006).
class Request extends $pb.GeneratedMessage {
  factory Request({
    $core.String? requestId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    ComponentClass? componentClass,
    $core.int? quantity,
    $core.String? indication,
    RequestUrgency? urgency,
    $core.Iterable<$core.String>? requirements,
    $0.Timestamp? requiredBy,
    RequestStatus? status,
    $core.String? requestedBy,
    $0.Timestamp? requestedAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (componentClass != null) result.componentClass = componentClass;
    if (quantity != null) result.quantity = quantity;
    if (indication != null) result.indication = indication;
    if (urgency != null) result.urgency = urgency;
    if (requirements != null) result.requirements.addAll(requirements);
    if (requiredBy != null) result.requiredBy = requiredBy;
    if (status != null) result.status = status;
    if (requestedBy != null) result.requestedBy = requestedBy;
    if (requestedAt != null) result.requestedAt = requestedAt;
    if (version != null) result.version = version;
    return result;
  }

  Request._();

  factory Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Request.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Request',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aE<ComponentClass>(5, _omitFieldNames ? '' : 'componentClass',
        enumValues: ComponentClass.values)
    ..aI(6, _omitFieldNames ? '' : 'quantity')
    ..aOS(7, _omitFieldNames ? '' : 'indication')
    ..aE<RequestUrgency>(8, _omitFieldNames ? '' : 'urgency',
        enumValues: RequestUrgency.values)
    ..pPS(9, _omitFieldNames ? '' : 'requirements')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'requiredBy',
        subBuilder: $0.Timestamp.create)
    ..aE<RequestStatus>(11, _omitFieldNames ? '' : 'status',
        enumValues: RequestStatus.values)
    ..aOS(12, _omitFieldNames ? '' : 'requestedBy')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'requestedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(14, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Request copyWith(void Function(Request) updates) =>
      super.copyWith((message) => updates(message as Request)) as Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Request create() => Request._();
  @$core.override
  Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Request>(create);
  static Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

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
  ComponentClass get componentClass => $_getN(4);
  @$pb.TagNumber(5)
  set componentClass(ComponentClass value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasComponentClass() => $_has(4);
  @$pb.TagNumber(5)
  void clearComponentClass() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get quantity => $_getIZ(5);
  @$pb.TagNumber(6)
  set quantity($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasQuantity() => $_has(5);
  @$pb.TagNumber(6)
  void clearQuantity() => $_clearField(6);

  /// Required. SRS-BLD-015's utilisation report is read to find transfusions
  /// that should not have happened, and a report with no indications cannot.
  @$pb.TagNumber(7)
  $core.String get indication => $_getSZ(6);
  @$pb.TagNumber(7)
  set indication($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIndication() => $_has(6);
  @$pb.TagNumber(7)
  void clearIndication() => $_clearField(7);

  @$pb.TagNumber(8)
  RequestUrgency get urgency => $_getN(7);
  @$pb.TagNumber(8)
  set urgency(RequestUrgency value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasUrgency() => $_has(7);
  @$pb.TagNumber(8)
  void clearUrgency() => $_clearField(8);

  /// A unit that does not carry these is not a match for this patient however
  /// well the groups agree.
  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get requirements => $_getList(8);

  @$pb.TagNumber(10)
  $0.Timestamp get requiredBy => $_getN(9);
  @$pb.TagNumber(10)
  set requiredBy($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasRequiredBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearRequiredBy() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureRequiredBy() => $_ensure(9);

  @$pb.TagNumber(11)
  RequestStatus get status => $_getN(10);
  @$pb.TagNumber(11)
  set status(RequestStatus value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasStatus() => $_has(10);
  @$pb.TagNumber(11)
  void clearStatus() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get requestedBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set requestedBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRequestedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearRequestedBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get requestedAt => $_getN(12);
  @$pb.TagNumber(13)
  set requestedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasRequestedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearRequestedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureRequestedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $fixnum.Int64 get version => $_getI64(13);
  @$pb.TagNumber(14)
  set version($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasVersion() => $_has(13);
  @$pb.TagNumber(14)
  void clearVersion() => $_clearField(14);
}

/// A patient's grouping sample (SRS-BLD-007).
class PatientSample extends $pb.GeneratedMessage {
  factory PatientSample({
    $core.String? sampleId,
    $core.String? patientId,
    $core.String? sampleNumber,
    BloodGroup? group,
    $core.bool? antibodyScreenPositive,
    $core.String? antibodyNote,
    $core.bool? secondCheck,
    $0.Timestamp? collectedAt,
    $core.String? collectedBy,
    $0.Timestamp? expiresAt,
    $0.Timestamp? testedAt,
    $core.String? testedBy,
  }) {
    final result = create();
    if (sampleId != null) result.sampleId = sampleId;
    if (patientId != null) result.patientId = patientId;
    if (sampleNumber != null) result.sampleNumber = sampleNumber;
    if (group != null) result.group = group;
    if (antibodyScreenPositive != null)
      result.antibodyScreenPositive = antibodyScreenPositive;
    if (antibodyNote != null) result.antibodyNote = antibodyNote;
    if (secondCheck != null) result.secondCheck = secondCheck;
    if (collectedAt != null) result.collectedAt = collectedAt;
    if (collectedBy != null) result.collectedBy = collectedBy;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (testedAt != null) result.testedAt = testedAt;
    if (testedBy != null) result.testedBy = testedBy;
    return result;
  }

  PatientSample._();

  factory PatientSample.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PatientSample.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PatientSample',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sampleId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'sampleNumber')
    ..aOM<BloodGroup>(4, _omitFieldNames ? '' : 'group',
        subBuilder: BloodGroup.create)
    ..aOB(5, _omitFieldNames ? '' : 'antibodyScreenPositive')
    ..aOS(6, _omitFieldNames ? '' : 'antibodyNote')
    ..aOB(7, _omitFieldNames ? '' : 'secondCheck')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'collectedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'collectedBy')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'testedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'testedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PatientSample clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PatientSample copyWith(void Function(PatientSample) updates) =>
      super.copyWith((message) => updates(message as PatientSample))
          as PatientSample;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PatientSample create() => PatientSample._();
  @$core.override
  PatientSample createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PatientSample getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PatientSample>(create);
  static PatientSample? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sampleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sampleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  /// The identifier on the tube. Without it a sample cannot be matched back to
  /// the draw, and "we bled the wrong patient" is unanswerable.
  @$pb.TagNumber(3)
  $core.String get sampleNumber => $_getSZ(2);
  @$pb.TagNumber(3)
  set sampleNumber($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSampleNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearSampleNumber() => $_clearField(3);

  @$pb.TagNumber(4)
  BloodGroup get group => $_getN(3);
  @$pb.TagNumber(4)
  set group(BloodGroup value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasGroup() => $_has(3);
  @$pb.TagNumber(4)
  void clearGroup() => $_clearField(4);
  @$pb.TagNumber(4)
  BloodGroup ensureGroup() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get antibodyScreenPositive => $_getBF(4);
  @$pb.TagNumber(5)
  set antibodyScreenPositive($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAntibodyScreenPositive() => $_has(4);
  @$pb.TagNumber(5)
  void clearAntibodyScreenPositive() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get antibodyNote => $_getSZ(5);
  @$pb.TagNumber(6)
  set antibodyNote($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAntibodyNote() => $_has(5);
  @$pb.TagNumber(6)
  void clearAntibodyNote() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get secondCheck => $_getBF(6);
  @$pb.TagNumber(7)
  set secondCheck($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSecondCheck() => $_has(6);
  @$pb.TagNumber(7)
  void clearSecondCheck() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get collectedAt => $_getN(7);
  @$pb.TagNumber(8)
  set collectedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCollectedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCollectedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureCollectedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get collectedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set collectedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCollectedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearCollectedBy() => $_clearField(9);

  /// A sample older than the window cannot support a crossmatch: the patient
  /// may have been transfused since and formed new antibodies.
  @$pb.TagNumber(10)
  $0.Timestamp get expiresAt => $_getN(9);
  @$pb.TagNumber(10)
  set expiresAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasExpiresAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearExpiresAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureExpiresAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $0.Timestamp get testedAt => $_getN(10);
  @$pb.TagNumber(11)
  set testedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasTestedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearTestedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureTestedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get testedBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set testedBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasTestedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearTestedBy() => $_clearField(12);
}

/// Whether a unit may be reserved for a patient.
class MatchDecision extends $pb.GeneratedMessage {
  factory MatchDecision({
    $core.bool? allowed,
    $core.Iterable<MatchRefusal>? refusals,
    $core.Iterable<$core.String>? explanations,
  }) {
    final result = create();
    if (allowed != null) result.allowed = allowed;
    if (refusals != null) result.refusals.addAll(refusals);
    if (explanations != null) result.explanations.addAll(explanations);
    return result;
  }

  MatchDecision._();

  factory MatchDecision.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MatchDecision.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MatchDecision',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'allowed')
    ..pc<MatchRefusal>(2, _omitFieldNames ? '' : 'refusals', $pb.PbFieldType.KE,
        valueOf: MatchRefusal.valueOf,
        enumValues: MatchRefusal.values,
        defaultEnumValue: MatchRefusal.MATCH_REFUSAL_UNSPECIFIED)
    ..pPS(3, _omitFieldNames ? '' : 'explanations')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchDecision clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchDecision copyWith(void Function(MatchDecision) updates) =>
      super.copyWith((message) => updates(message as MatchDecision))
          as MatchDecision;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MatchDecision create() => MatchDecision._();
  @$core.override
  MatchDecision createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MatchDecision getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MatchDecision>(create);
  static MatchDecision? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get allowed => $_getBF(0);
  @$pb.TagNumber(1)
  set allowed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAllowed() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllowed() => $_clearField(1);

  /// Every reason, not the first: a scientist told one at a time pulls a second
  /// unit from the fridge to be told the next.
  @$pb.TagNumber(2)
  $pb.PbList<MatchRefusal> get refusals => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get explanations => $_getList(2);
}

/// One unit offered against a request, with its verdict.
class Candidate extends $pb.GeneratedMessage {
  factory Candidate({
    Component? component,
    MatchDecision? decision,
  }) {
    final result = create();
    if (component != null) result.component = component;
    if (decision != null) result.decision = decision;
    return result;
  }

  Candidate._();

  factory Candidate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Candidate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Candidate',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Component>(1, _omitFieldNames ? '' : 'component',
        subBuilder: Component.create)
    ..aOM<MatchDecision>(2, _omitFieldNames ? '' : 'decision',
        subBuilder: MatchDecision.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Candidate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Candidate copyWith(void Function(Candidate) updates) =>
      super.copyWith((message) => updates(message as Candidate)) as Candidate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Candidate create() => Candidate._();
  @$core.override
  Candidate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Candidate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Candidate>(create);
  static Candidate? _defaultInstance;

  @$pb.TagNumber(1)
  Component get component => $_getN(0);
  @$pb.TagNumber(1)
  set component(Component value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasComponent() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponent() => $_clearField(1);
  @$pb.TagNumber(1)
  Component ensureComponent() => $_ensure(0);

  @$pb.TagNumber(2)
  MatchDecision get decision => $_getN(1);
  @$pb.TagNumber(2)
  set decision(MatchDecision value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDecision() => $_has(1);
  @$pb.TagNumber(2)
  void clearDecision() => $_clearField(2);
  @$pb.TagNumber(2)
  MatchDecision ensureDecision() => $_ensure(1);
}

/// A unit held for a patient (SRS-BLD-008).
class Reservation extends $pb.GeneratedMessage {
  factory Reservation({
    $core.String? reservationId,
    $core.String? componentId,
    $core.String? requestId,
    $core.String? patientId,
    $core.String? sampleId,
    $core.bool? crossmatched,
    $core.String? crossmatchNote,
    ReservationStatus? status,
    $0.Timestamp? expiresAt,
    $0.Timestamp? reservedAt,
    $core.String? reservedBy,
    $core.String? releasedReason,
  }) {
    final result = create();
    if (reservationId != null) result.reservationId = reservationId;
    if (componentId != null) result.componentId = componentId;
    if (requestId != null) result.requestId = requestId;
    if (patientId != null) result.patientId = patientId;
    if (sampleId != null) result.sampleId = sampleId;
    if (crossmatched != null) result.crossmatched = crossmatched;
    if (crossmatchNote != null) result.crossmatchNote = crossmatchNote;
    if (status != null) result.status = status;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (reservedAt != null) result.reservedAt = reservedAt;
    if (reservedBy != null) result.reservedBy = reservedBy;
    if (releasedReason != null) result.releasedReason = releasedReason;
    return result;
  }

  Reservation._();

  factory Reservation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Reservation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Reservation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reservationId')
    ..aOS(2, _omitFieldNames ? '' : 'componentId')
    ..aOS(3, _omitFieldNames ? '' : 'requestId')
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aOS(5, _omitFieldNames ? '' : 'sampleId')
    ..aOB(6, _omitFieldNames ? '' : 'crossmatched')
    ..aOS(7, _omitFieldNames ? '' : 'crossmatchNote')
    ..aE<ReservationStatus>(8, _omitFieldNames ? '' : 'status',
        enumValues: ReservationStatus.values)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'reservedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'reservedBy')
    ..aOS(12, _omitFieldNames ? '' : 'releasedReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reservation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reservation copyWith(void Function(Reservation) updates) =>
      super.copyWith((message) => updates(message as Reservation))
          as Reservation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Reservation create() => Reservation._();
  @$core.override
  Reservation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Reservation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Reservation>(create);
  static Reservation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reservationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reservationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReservationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReservationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get componentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set componentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasComponentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearComponentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get requestId => $_getSZ(2);
  @$pb.TagNumber(3)
  set requestId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequestId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequestId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get patientId => $_getSZ(3);
  @$pb.TagNumber(4)
  set patientId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPatientId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPatientId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sampleId => $_getSZ(4);
  @$pb.TagNumber(5)
  set sampleId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSampleId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSampleId() => $_clearField(5);

  /// A serological crossmatch actually performed, as distinct from an
  /// electronic issue. False on an emergency release, which is the point.
  @$pb.TagNumber(6)
  $core.bool get crossmatched => $_getBF(5);
  @$pb.TagNumber(6)
  set crossmatched($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCrossmatched() => $_has(5);
  @$pb.TagNumber(6)
  void clearCrossmatched() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get crossmatchNote => $_getSZ(6);
  @$pb.TagNumber(7)
  set crossmatchNote($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCrossmatchNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearCrossmatchNote() => $_clearField(7);

  @$pb.TagNumber(8)
  ReservationStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(ReservationStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);

  /// Reservations expire, because blood held for a patient who did not need it
  /// is blood the next patient could not have.
  @$pb.TagNumber(9)
  $0.Timestamp get expiresAt => $_getN(8);
  @$pb.TagNumber(9)
  set expiresAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasExpiresAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearExpiresAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureExpiresAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get reservedAt => $_getN(9);
  @$pb.TagNumber(10)
  set reservedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasReservedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearReservedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureReservedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get reservedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set reservedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasReservedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearReservedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get releasedReason => $_getSZ(11);
  @$pb.TagNumber(12)
  set releasedReason($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasReleasedReason() => $_has(11);
  @$pb.TagNumber(12)
  void clearReleasedReason() => $_clearField(12);
}

/// A unit leaving the blood bank (SRS-BLD-009, SRS-BLD-016).
class Issue extends $pb.GeneratedMessage {
  factory Issue({
    $core.String? issueId,
    $core.String? componentId,
    $core.String? reservationId,
    $core.String? patientId,
    $core.String? requestId,
    $core.String? destination,
    $core.bool? emergency,
    $core.String? emergencyAuthoriser,
    $core.String? emergencyReason,
    $core.bool? reconciled,
    $0.Timestamp? reconciledAt,
    $core.String? reconciledBy,
    $core.String? reconcileNote,
    $0.Timestamp? issuedAt,
    $core.String? issuedBy,
    $core.String? issuedTo,
    $core.String? checkedBy,
  }) {
    final result = create();
    if (issueId != null) result.issueId = issueId;
    if (componentId != null) result.componentId = componentId;
    if (reservationId != null) result.reservationId = reservationId;
    if (patientId != null) result.patientId = patientId;
    if (requestId != null) result.requestId = requestId;
    if (destination != null) result.destination = destination;
    if (emergency != null) result.emergency = emergency;
    if (emergencyAuthoriser != null)
      result.emergencyAuthoriser = emergencyAuthoriser;
    if (emergencyReason != null) result.emergencyReason = emergencyReason;
    if (reconciled != null) result.reconciled = reconciled;
    if (reconciledAt != null) result.reconciledAt = reconciledAt;
    if (reconciledBy != null) result.reconciledBy = reconciledBy;
    if (reconcileNote != null) result.reconcileNote = reconcileNote;
    if (issuedAt != null) result.issuedAt = issuedAt;
    if (issuedBy != null) result.issuedBy = issuedBy;
    if (issuedTo != null) result.issuedTo = issuedTo;
    if (checkedBy != null) result.checkedBy = checkedBy;
    return result;
  }

  Issue._();

  factory Issue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Issue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Issue',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'issueId')
    ..aOS(2, _omitFieldNames ? '' : 'componentId')
    ..aOS(3, _omitFieldNames ? '' : 'reservationId')
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aOS(5, _omitFieldNames ? '' : 'requestId')
    ..aOS(6, _omitFieldNames ? '' : 'destination')
    ..aOB(7, _omitFieldNames ? '' : 'emergency')
    ..aOS(8, _omitFieldNames ? '' : 'emergencyAuthoriser')
    ..aOS(9, _omitFieldNames ? '' : 'emergencyReason')
    ..aOB(10, _omitFieldNames ? '' : 'reconciled')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'reconciledAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'reconciledBy')
    ..aOS(13, _omitFieldNames ? '' : 'reconcileNote')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'issuedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'issuedBy')
    ..aOS(16, _omitFieldNames ? '' : 'issuedTo')
    ..aOS(17, _omitFieldNames ? '' : 'checkedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Issue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Issue copyWith(void Function(Issue) updates) =>
      super.copyWith((message) => updates(message as Issue)) as Issue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Issue create() => Issue._();
  @$core.override
  Issue createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Issue getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Issue>(create);
  static Issue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get issueId => $_getSZ(0);
  @$pb.TagNumber(1)
  set issueId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIssueId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssueId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get componentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set componentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasComponentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearComponentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reservationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set reservationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReservationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearReservationId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get patientId => $_getSZ(3);
  @$pb.TagNumber(4)
  set patientId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPatientId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPatientId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get requestId => $_getSZ(4);
  @$pb.TagNumber(5)
  set requestId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRequestId() => $_has(4);
  @$pb.TagNumber(5)
  void clearRequestId() => $_clearField(5);

  /// A unit that left with no destination is one nobody can fetch back.
  @$pb.TagNumber(6)
  $core.String get destination => $_getSZ(5);
  @$pb.TagNumber(6)
  set destination($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDestination() => $_has(5);
  @$pb.TagNumber(6)
  void clearDestination() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get emergency => $_getBF(6);
  @$pb.TagNumber(7)
  set emergency($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEmergency() => $_has(6);
  @$pb.TagNumber(7)
  void clearEmergency() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get emergencyAuthoriser => $_getSZ(7);
  @$pb.TagNumber(8)
  set emergencyAuthoriser($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEmergencyAuthoriser() => $_has(7);
  @$pb.TagNumber(8)
  void clearEmergencyAuthoriser() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get emergencyReason => $_getSZ(8);
  @$pb.TagNumber(9)
  set emergencyReason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEmergencyReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearEmergencyReason() => $_clearField(9);

  /// An unreconciled emergency release is what a haemovigilance report exists
  /// to surface.
  @$pb.TagNumber(10)
  $core.bool get reconciled => $_getBF(9);
  @$pb.TagNumber(10)
  set reconciled($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasReconciled() => $_has(9);
  @$pb.TagNumber(10)
  void clearReconciled() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get reconciledAt => $_getN(10);
  @$pb.TagNumber(11)
  set reconciledAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasReconciledAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearReconciledAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureReconciledAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get reconciledBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set reconciledBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasReconciledBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearReconciledBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get reconcileNote => $_getSZ(12);
  @$pb.TagNumber(13)
  set reconcileNote($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasReconcileNote() => $_has(12);
  @$pb.TagNumber(13)
  void clearReconcileNote() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get issuedAt => $_getN(13);
  @$pb.TagNumber(14)
  set issuedAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasIssuedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearIssuedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureIssuedAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get issuedBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set issuedBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasIssuedBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearIssuedBy() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get issuedTo => $_getSZ(15);
  @$pb.TagNumber(16)
  set issuedTo($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasIssuedTo() => $_has(15);
  @$pb.TagNumber(16)
  void clearIssuedTo() => $_clearField(16);

  /// Who made the final identity check at the counter. A check nobody can name
  /// afterwards is one that cannot be reviewed.
  @$pb.TagNumber(17)
  $core.String get checkedBy => $_getSZ(16);
  @$pb.TagNumber(17)
  set checkedBy($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasCheckedBy() => $_has(16);
  @$pb.TagNumber(17)
  void clearCheckedBy() => $_clearField(17);
}

/// One set of observations during a transfusion (SRS-BLD-011).
class Observation extends $pb.GeneratedMessage {
  factory Observation({
    $core.String? observationId,
    $core.String? episodeId,
    $core.String? timing,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? values,
    $core.String? note,
    $0.Timestamp? observedAt,
    $core.String? observedBy,
  }) {
    final result = create();
    if (observationId != null) result.observationId = observationId;
    if (episodeId != null) result.episodeId = episodeId;
    if (timing != null) result.timing = timing;
    if (values != null) result.values.addEntries(values);
    if (note != null) result.note = note;
    if (observedAt != null) result.observedAt = observedAt;
    if (observedBy != null) result.observedBy = observedBy;
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
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'observationId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeId')
    ..aOS(3, _omitFieldNames ? '' : 'timing')
    ..m<$core.String, $core.double>(4, _omitFieldNames ? '' : 'values',
        entryClassName: 'Observation.ValuesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('healthcare.bloodbank.v1'))
    ..aOS(5, _omitFieldNames ? '' : 'note')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'observedBy')
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

  /// Where in the transfusion the set was taken — baseline, 15_minutes,
  /// periodic, completion. Coded, because the audit that matters is whether the
  /// fifteen-minute set exists.
  @$pb.TagNumber(3)
  $core.String get timing => $_getSZ(2);
  @$pb.TagNumber(3)
  set timing($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTiming() => $_has(2);
  @$pb.TagNumber(3)
  void clearTiming() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.double> get values => $_getMap(3);

  @$pb.TagNumber(5)
  $core.String get note => $_getSZ(4);
  @$pb.TagNumber(5)
  set note($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNote() => $_has(4);
  @$pb.TagNumber(5)
  void clearNote() => $_clearField(5);

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

  @$pb.TagNumber(7)
  $core.String get observedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set observedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasObservedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearObservedBy() => $_clearField(7);
}

/// One transfusion at the bedside (SRS-BLD-011).
class Episode extends $pb.GeneratedMessage {
  factory Episode({
    $core.String? episodeId,
    $core.String? componentId,
    $core.String? issueId,
    $core.String? patientId,
    $core.String? encounterId,
    EpisodeStatus? status,
    $0.Timestamp? startedAt,
    $core.String? startedBy,
    $0.Timestamp? endedAt,
    $core.int? volumeGivenMl,
    $core.String? stopReason,
    $core.Iterable<Observation>? observations,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (componentId != null) result.componentId = componentId;
    if (issueId != null) result.issueId = issueId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (status != null) result.status = status;
    if (startedAt != null) result.startedAt = startedAt;
    if (startedBy != null) result.startedBy = startedBy;
    if (endedAt != null) result.endedAt = endedAt;
    if (volumeGivenMl != null) result.volumeGivenMl = volumeGivenMl;
    if (stopReason != null) result.stopReason = stopReason;
    if (observations != null) result.observations.addAll(observations);
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
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'componentId')
    ..aOS(3, _omitFieldNames ? '' : 'issueId')
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aOS(5, _omitFieldNames ? '' : 'encounterId')
    ..aE<EpisodeStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: EpisodeStatus.values)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'startedBy')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..aI(10, _omitFieldNames ? '' : 'volumeGivenMl')
    ..aOS(11, _omitFieldNames ? '' : 'stopReason')
    ..pPM<Observation>(12, _omitFieldNames ? '' : 'observations',
        subBuilder: Observation.create)
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
  $core.String get componentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set componentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasComponentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearComponentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get issueId => $_getSZ(2);
  @$pb.TagNumber(3)
  set issueId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIssueId() => $_has(2);
  @$pb.TagNumber(3)
  void clearIssueId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get patientId => $_getSZ(3);
  @$pb.TagNumber(4)
  set patientId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPatientId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPatientId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get encounterId => $_getSZ(4);
  @$pb.TagNumber(5)
  set encounterId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEncounterId() => $_has(4);
  @$pb.TagNumber(5)
  void clearEncounterId() => $_clearField(5);

  @$pb.TagNumber(6)
  EpisodeStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(EpisodeStatus value) => $_setField(6, value);
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

  /// What the patient actually received, which is not the unit's volume when a
  /// transfusion was stopped part-way.
  @$pb.TagNumber(10)
  $core.int get volumeGivenMl => $_getIZ(9);
  @$pb.TagNumber(10)
  set volumeGivenMl($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVolumeGivenMl() => $_has(9);
  @$pb.TagNumber(10)
  void clearVolumeGivenMl() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get stopReason => $_getSZ(10);
  @$pb.TagNumber(11)
  set stopReason($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasStopReason() => $_has(10);
  @$pb.TagNumber(11)
  void clearStopReason() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<Observation> get observations => $_getList(11);
}

/// A suspected transfusion reaction (SRS-BLD-012).
class Reaction extends $pb.GeneratedMessage {
  factory Reaction({
    $core.String? reactionId,
    $core.String? episodeId,
    $core.String? componentId,
    $core.String? patientId,
    ReactionSeverity? severity,
    $core.Iterable<$core.String>? features,
    $core.String? note,
    $0.Timestamp? reportedAt,
    $core.String? reportedBy,
    InvestigationState? state,
    $core.String? classification,
    $core.String? conclusion,
    $0.Timestamp? concludedAt,
    $core.String? concludedBy,
    $core.bool? unitReturned,
    $core.String? actionTaken,
  }) {
    final result = create();
    if (reactionId != null) result.reactionId = reactionId;
    if (episodeId != null) result.episodeId = episodeId;
    if (componentId != null) result.componentId = componentId;
    if (patientId != null) result.patientId = patientId;
    if (severity != null) result.severity = severity;
    if (features != null) result.features.addAll(features);
    if (note != null) result.note = note;
    if (reportedAt != null) result.reportedAt = reportedAt;
    if (reportedBy != null) result.reportedBy = reportedBy;
    if (state != null) result.state = state;
    if (classification != null) result.classification = classification;
    if (conclusion != null) result.conclusion = conclusion;
    if (concludedAt != null) result.concludedAt = concludedAt;
    if (concludedBy != null) result.concludedBy = concludedBy;
    if (unitReturned != null) result.unitReturned = unitReturned;
    if (actionTaken != null) result.actionTaken = actionTaken;
    return result;
  }

  Reaction._();

  factory Reaction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Reaction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Reaction',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reactionId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeId')
    ..aOS(3, _omitFieldNames ? '' : 'componentId')
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aE<ReactionSeverity>(5, _omitFieldNames ? '' : 'severity',
        enumValues: ReactionSeverity.values)
    ..pPS(6, _omitFieldNames ? '' : 'features')
    ..aOS(7, _omitFieldNames ? '' : 'note')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'reportedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'reportedBy')
    ..aE<InvestigationState>(10, _omitFieldNames ? '' : 'state',
        enumValues: InvestigationState.values)
    ..aOS(11, _omitFieldNames ? '' : 'classification')
    ..aOS(12, _omitFieldNames ? '' : 'conclusion')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'concludedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(14, _omitFieldNames ? '' : 'concludedBy')
    ..aOB(15, _omitFieldNames ? '' : 'unitReturned')
    ..aOS(16, _omitFieldNames ? '' : 'actionTaken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reaction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reaction copyWith(void Function(Reaction) updates) =>
      super.copyWith((message) => updates(message as Reaction)) as Reaction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Reaction create() => Reaction._();
  @$core.override
  Reaction createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Reaction getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Reaction>(create);
  static Reaction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reactionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reactionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReactionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReactionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get episodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set episodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpisodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpisodeId() => $_clearField(2);

  /// Required. The investigation's first job is to find the other components
  /// made from the same donation, and a reaction recorded against a patient
  /// alone cannot.
  @$pb.TagNumber(3)
  $core.String get componentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set componentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasComponentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearComponentId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get patientId => $_getSZ(3);
  @$pb.TagNumber(4)
  set patientId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPatientId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPatientId() => $_clearField(4);

  @$pb.TagNumber(5)
  ReactionSeverity get severity => $_getN(4);
  @$pb.TagNumber(5)
  set severity(ReactionSeverity value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSeverity() => $_has(4);
  @$pb.TagNumber(5)
  void clearSeverity() => $_clearField(5);

  /// What was seen, listed rather than classified: the classification is the
  /// investigation's conclusion and this is the report that starts it.
  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get features => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get note => $_getSZ(6);
  @$pb.TagNumber(7)
  set note($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearNote() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get reportedAt => $_getN(7);
  @$pb.TagNumber(8)
  set reportedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasReportedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearReportedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureReportedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get reportedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set reportedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReportedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearReportedBy() => $_clearField(9);

  @$pb.TagNumber(10)
  InvestigationState get state => $_getN(9);
  @$pb.TagNumber(10)
  set state(InvestigationState value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasState() => $_has(9);
  @$pb.TagNumber(10)
  void clearState() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get classification => $_getSZ(10);
  @$pb.TagNumber(11)
  set classification($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasClassification() => $_has(10);
  @$pb.TagNumber(11)
  void clearClassification() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get conclusion => $_getSZ(11);
  @$pb.TagNumber(12)
  set conclusion($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasConclusion() => $_has(11);
  @$pb.TagNumber(12)
  void clearConclusion() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get concludedAt => $_getN(12);
  @$pb.TagNumber(13)
  set concludedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasConcludedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearConcludedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureConcludedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get concludedBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set concludedBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasConcludedBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearConcludedBy() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.bool get unitReturned => $_getBF(14);
  @$pb.TagNumber(15)
  set unitReturned($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasUnitReturned() => $_has(14);
  @$pb.TagNumber(15)
  void clearUnitReturned() => $_clearField(15);

  /// Required. What was done at the bedside — the transfusion stopped, the line
  /// kept open with saline, the unit returned. The reaction action runs from
  /// the bedside (SRS-NUR-014), and this report is where it is written down.
  @$pb.TagNumber(16)
  $core.String get actionTaken => $_getSZ(15);
  @$pb.TagNumber(16)
  set actionTaken($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasActionTaken() => $_has(15);
  @$pb.TagNumber(16)
  void clearActionTaken() => $_clearField(16);
}

/// One step of the vein-to-vein chain (SRS-BLD-014).
class ChainLink extends $pb.GeneratedMessage {
  factory ChainLink({
    $core.String? stage,
    $core.String? id,
    $core.String? label,
    $0.Timestamp? at,
    $core.String? by,
  }) {
    final result = create();
    if (stage != null) result.stage = stage;
    if (id != null) result.id = id;
    if (label != null) result.label = label;
    if (at != null) result.at = at;
    if (by != null) result.by = by;
    return result;
  }

  ChainLink._();

  factory ChainLink.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChainLink.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChainLink',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'stage')
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..aOS(3, _omitFieldNames ? '' : 'label')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'at',
        subBuilder: $0.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'by')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChainLink clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChainLink copyWith(void Function(ChainLink) updates) =>
      super.copyWith((message) => updates(message as ChainLink)) as ChainLink;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChainLink create() => ChainLink._();
  @$core.override
  ChainLink createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChainLink getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChainLink>(create);
  static ChainLink? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get stage => $_getSZ(0);
  @$pb.TagNumber(1)
  set stage($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStage() => $_has(0);
  @$pb.TagNumber(1)
  void clearStage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get label => $_getSZ(2);
  @$pb.TagNumber(3)
  set label($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLabel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLabel() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get at => $_getN(3);
  @$pb.TagNumber(4)
  set at($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get by => $_getSZ(4);
  @$pb.TagNumber(5)
  set by($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearBy() => $_clearField(5);
}

/// A unit's traceable history (SRS-BLD-014).
class Chain extends $pb.GeneratedMessage {
  factory Chain({
    $core.String? componentId,
    $core.String? unitNumber,
    $core.Iterable<ChainLink>? links,
    $core.Iterable<$core.String>? gaps,
  }) {
    final result = create();
    if (componentId != null) result.componentId = componentId;
    if (unitNumber != null) result.unitNumber = unitNumber;
    if (links != null) result.links.addAll(links);
    if (gaps != null) result.gaps.addAll(gaps);
    return result;
  }

  Chain._();

  factory Chain.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chain.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Chain',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'componentId')
    ..aOS(2, _omitFieldNames ? '' : 'unitNumber')
    ..pPM<ChainLink>(3, _omitFieldNames ? '' : 'links',
        subBuilder: ChainLink.create)
    ..pPS(4, _omitFieldNames ? '' : 'gaps')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chain clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chain copyWith(void Function(Chain) updates) =>
      super.copyWith((message) => updates(message as Chain)) as Chain;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chain create() => Chain._();
  @$core.override
  Chain createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chain getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chain>(create);
  static Chain? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get componentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set componentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasComponentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get unitNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set unitNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<ChainLink> get links => $_getList(2);

  /// Stages with no record, so a reader can tell "this unit was never
  /// transfused" from "we have lost the transfusion record".
  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get gaps => $_getList(3);
}

/// A patient reached by a look-back (SRS-BLD-014).
///
/// Identifiers and times, no clinical detail: this list goes to a
/// haemovigilance officer and sometimes to a regulator.
class Recipient extends $pb.GeneratedMessage {
  factory Recipient({
    $core.String? patientId,
    $core.String? episodeId,
    $core.String? componentId,
    $core.String? unitNumber,
    $0.Timestamp? at,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (episodeId != null) result.episodeId = episodeId;
    if (componentId != null) result.componentId = componentId;
    if (unitNumber != null) result.unitNumber = unitNumber;
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
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeId')
    ..aOS(3, _omitFieldNames ? '' : 'componentId')
    ..aOS(4, _omitFieldNames ? '' : 'unitNumber')
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
  $core.String get episodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set episodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpisodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpisodeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get componentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set componentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasComponentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearComponentId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get unitNumber => $_getSZ(3);
  @$pb.TagNumber(4)
  set unitNumber($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnitNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnitNumber() => $_clearField(4);

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

/// The count of units in one bucket (SRS-BLD-005, SRS-BLD-017).
class StockLevel extends $pb.GeneratedMessage {
  factory StockLevel({
    ComponentClass? componentClass,
    BloodGroup? group,
    $core.int? available,
    $core.int? expiringSoon,
    $core.int? quarantined,
    $core.int? reserved,
  }) {
    final result = create();
    if (componentClass != null) result.componentClass = componentClass;
    if (group != null) result.group = group;
    if (available != null) result.available = available;
    if (expiringSoon != null) result.expiringSoon = expiringSoon;
    if (quarantined != null) result.quarantined = quarantined;
    if (reserved != null) result.reserved = reserved;
    return result;
  }

  StockLevel._();

  factory StockLevel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StockLevel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StockLevel',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aE<ComponentClass>(1, _omitFieldNames ? '' : 'componentClass',
        enumValues: ComponentClass.values)
    ..aOM<BloodGroup>(2, _omitFieldNames ? '' : 'group',
        subBuilder: BloodGroup.create)
    ..aI(3, _omitFieldNames ? '' : 'available')
    ..aI(4, _omitFieldNames ? '' : 'expiringSoon')
    ..aI(5, _omitFieldNames ? '' : 'quarantined')
    ..aI(6, _omitFieldNames ? '' : 'reserved')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StockLevel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StockLevel copyWith(void Function(StockLevel) updates) =>
      super.copyWith((message) => updates(message as StockLevel)) as StockLevel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StockLevel create() => StockLevel._();
  @$core.override
  StockLevel createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StockLevel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StockLevel>(create);
  static StockLevel? _defaultInstance;

  @$pb.TagNumber(1)
  ComponentClass get componentClass => $_getN(0);
  @$pb.TagNumber(1)
  set componentClass(ComponentClass value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasComponentClass() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponentClass() => $_clearField(1);

  @$pb.TagNumber(2)
  BloodGroup get group => $_getN(1);
  @$pb.TagNumber(2)
  set group(BloodGroup value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasGroup() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroup() => $_clearField(2);
  @$pb.TagNumber(2)
  BloodGroup ensureGroup() => $_ensure(1);

  /// What could be issued now. A count including quarantined units would read
  /// as comfortable stock nobody can give.
  @$pb.TagNumber(3)
  $core.int get available => $_getIZ(2);
  @$pb.TagNumber(3)
  set available($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvailable() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvailable() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get expiringSoon => $_getIZ(3);
  @$pb.TagNumber(4)
  set expiringSoon($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiringSoon() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiringSoon() => $_clearField(4);

  /// Shown beside it, because a bank short because everything is reserved has a
  /// different problem from one short because nothing has been tested.
  @$pb.TagNumber(5)
  $core.int get quarantined => $_getIZ(4);
  @$pb.TagNumber(5)
  set quarantined($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuarantined() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuarantined() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get reserved => $_getIZ(5);
  @$pb.TagNumber(6)
  set reserved($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReserved() => $_has(5);
  @$pb.TagNumber(6)
  void clearReserved() => $_clearField(6);
}

/// One thing somebody has to do (SRS-BLD-017).
class StockAlert extends $pb.GeneratedMessage {
  factory StockAlert({
    StockAlertKind? kind,
    ComponentClass? componentClass,
    BloodGroup? group,
    $core.int? available,
    $core.int? minimum,
    $core.int? count,
    $core.String? message,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (componentClass != null) result.componentClass = componentClass;
    if (group != null) result.group = group;
    if (available != null) result.available = available;
    if (minimum != null) result.minimum = minimum;
    if (count != null) result.count = count;
    if (message != null) result.message = message;
    return result;
  }

  StockAlert._();

  factory StockAlert.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StockAlert.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StockAlert',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aE<StockAlertKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: StockAlertKind.values)
    ..aE<ComponentClass>(2, _omitFieldNames ? '' : 'componentClass',
        enumValues: ComponentClass.values)
    ..aOM<BloodGroup>(3, _omitFieldNames ? '' : 'group',
        subBuilder: BloodGroup.create)
    ..aI(4, _omitFieldNames ? '' : 'available')
    ..aI(5, _omitFieldNames ? '' : 'minimum')
    ..aI(6, _omitFieldNames ? '' : 'count')
    ..aOS(7, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StockAlert clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StockAlert copyWith(void Function(StockAlert) updates) =>
      super.copyWith((message) => updates(message as StockAlert)) as StockAlert;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StockAlert create() => StockAlert._();
  @$core.override
  StockAlert createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StockAlert getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StockAlert>(create);
  static StockAlert? _defaultInstance;

  @$pb.TagNumber(1)
  StockAlertKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(StockAlertKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  ComponentClass get componentClass => $_getN(1);
  @$pb.TagNumber(2)
  set componentClass(ComponentClass value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasComponentClass() => $_has(1);
  @$pb.TagNumber(2)
  void clearComponentClass() => $_clearField(2);

  @$pb.TagNumber(3)
  BloodGroup get group => $_getN(2);
  @$pb.TagNumber(3)
  set group(BloodGroup value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasGroup() => $_has(2);
  @$pb.TagNumber(3)
  void clearGroup() => $_clearField(3);
  @$pb.TagNumber(3)
  BloodGroup ensureGroup() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get available => $_getIZ(3);
  @$pb.TagNumber(4)
  set available($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAvailable() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvailable() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get minimum => $_getIZ(4);
  @$pb.TagNumber(5)
  set minimum($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMinimum() => $_has(4);
  @$pb.TagNumber(5)
  void clearMinimum() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get count => $_getIZ(5);
  @$pb.TagNumber(6)
  set count($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearCount() => $_clearField(6);

  /// In words, because an alert a reader has to go and look the numbers up for
  /// is an alert that gets dismissed.
  @$pb.TagNumber(7)
  $core.String get message => $_getSZ(6);
  @$pb.TagNumber(7)
  set message($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMessage() => $_has(6);
  @$pb.TagNumber(7)
  void clearMessage() => $_clearField(7);
}

/// A configured minimum (SRS-BLD-017).
class StockThreshold extends $pb.GeneratedMessage {
  factory StockThreshold({
    ComponentClass? componentClass,
    BloodGroup? group,
    $core.int? minimum,
  }) {
    final result = create();
    if (componentClass != null) result.componentClass = componentClass;
    if (group != null) result.group = group;
    if (minimum != null) result.minimum = minimum;
    return result;
  }

  StockThreshold._();

  factory StockThreshold.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StockThreshold.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StockThreshold',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aE<ComponentClass>(1, _omitFieldNames ? '' : 'componentClass',
        enumValues: ComponentClass.values)
    ..aOM<BloodGroup>(2, _omitFieldNames ? '' : 'group',
        subBuilder: BloodGroup.create)
    ..aI(3, _omitFieldNames ? '' : 'minimum')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StockThreshold clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StockThreshold copyWith(void Function(StockThreshold) updates) =>
      super.copyWith((message) => updates(message as StockThreshold))
          as StockThreshold;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StockThreshold create() => StockThreshold._();
  @$core.override
  StockThreshold createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StockThreshold getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StockThreshold>(create);
  static StockThreshold? _defaultInstance;

  @$pb.TagNumber(1)
  ComponentClass get componentClass => $_getN(0);
  @$pb.TagNumber(1)
  set componentClass(ComponentClass value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasComponentClass() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponentClass() => $_clearField(1);

  @$pb.TagNumber(2)
  BloodGroup get group => $_getN(1);
  @$pb.TagNumber(2)
  set group(BloodGroup value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasGroup() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroup() => $_clearField(2);
  @$pb.TagNumber(2)
  BloodGroup ensureGroup() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get minimum => $_getIZ(2);
  @$pb.TagNumber(3)
  set minimum($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMinimum() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinimum() => $_clearField(3);
}

/// The component utilisation report (SRS-BLD-015).
///
/// Derived from the issue, transfusion and reaction records every time.
class Utilisation extends $pb.GeneratedMessage {
  factory Utilisation({
    $core.int? issued,
    $core.int? transfused,
    $core.int? returned,
    $core.int? discarded,
    $core.int? reactions,
    $core.int? emergencyReleases,
    $core.int? unreconciledReleases,
    $core.int? reservations,
    $core.double? crossmatchToTransfusion,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? byIndication,
  }) {
    final result = create();
    if (issued != null) result.issued = issued;
    if (transfused != null) result.transfused = transfused;
    if (returned != null) result.returned = returned;
    if (discarded != null) result.discarded = discarded;
    if (reactions != null) result.reactions = reactions;
    if (emergencyReleases != null) result.emergencyReleases = emergencyReleases;
    if (unreconciledReleases != null)
      result.unreconciledReleases = unreconciledReleases;
    if (reservations != null) result.reservations = reservations;
    if (crossmatchToTransfusion != null)
      result.crossmatchToTransfusion = crossmatchToTransfusion;
    if (byIndication != null) result.byIndication.addEntries(byIndication);
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
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'issued')
    ..aI(2, _omitFieldNames ? '' : 'transfused')
    ..aI(3, _omitFieldNames ? '' : 'returned')
    ..aI(4, _omitFieldNames ? '' : 'discarded')
    ..aI(5, _omitFieldNames ? '' : 'reactions')
    ..aI(6, _omitFieldNames ? '' : 'emergencyReleases')
    ..aI(7, _omitFieldNames ? '' : 'unreconciledReleases')
    ..aI(8, _omitFieldNames ? '' : 'reservations')
    ..aD(9, _omitFieldNames ? '' : 'crossmatchToTransfusion')
    ..m<$core.String, $core.int>(10, _omitFieldNames ? '' : 'byIndication',
        entryClassName: 'Utilisation.ByIndicationEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('healthcare.bloodbank.v1'))
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
  $core.int get issued => $_getIZ(0);
  @$pb.TagNumber(1)
  set issued($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIssued() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssued() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get transfused => $_getIZ(1);
  @$pb.TagNumber(2)
  set transfused($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTransfused() => $_has(1);
  @$pb.TagNumber(2)
  void clearTransfused() => $_clearField(2);

  /// Issued and not transfused, which is the number a blood bank manages down:
  /// every returned unit spent time out of the fridge.
  @$pb.TagNumber(3)
  $core.int get returned => $_getIZ(2);
  @$pb.TagNumber(3)
  set returned($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReturned() => $_has(2);
  @$pb.TagNumber(3)
  void clearReturned() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get discarded => $_getIZ(3);
  @$pb.TagNumber(4)
  set discarded($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDiscarded() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiscarded() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get reactions => $_getIZ(4);
  @$pb.TagNumber(5)
  set reactions($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReactions() => $_has(4);
  @$pb.TagNumber(5)
  void clearReactions() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get emergencyReleases => $_getIZ(5);
  @$pb.TagNumber(6)
  set emergencyReleases($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEmergencyReleases() => $_has(5);
  @$pb.TagNumber(6)
  void clearEmergencyReleases() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get unreconciledReleases => $_getIZ(6);
  @$pb.TagNumber(7)
  set unreconciledReleases($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUnreconciledReleases() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnreconciledReleases() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get reservations => $_getIZ(7);
  @$pb.TagNumber(8)
  set reservations($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReservations() => $_has(7);
  @$pb.TagNumber(8)
  void clearReservations() => $_clearField(8);

  /// The C:T ratio, the number this report exists for: reserving three units
  /// for every one given ties up a bank's stock. Zero transfusions gives zero
  /// rather than an infinity, and reservations is carried so a reader can see
  /// why.
  @$pb.TagNumber(9)
  $core.double get crossmatchToTransfusion => $_getN(8);
  @$pb.TagNumber(9)
  set crossmatchToTransfusion($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCrossmatchToTransfusion() => $_has(8);
  @$pb.TagNumber(9)
  void clearCrossmatchToTransfusion() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbMap<$core.String, $core.int> get byIndication => $_getMap(9);
}

class RegisterDonorRequest extends $pb.GeneratedMessage {
  factory RegisterDonorRequest({
    $core.String? donorNumber,
    $core.String? patientId,
    $core.String? displayName,
    $core.String? contactPhone,
    BloodGroup? group,
  }) {
    final result = create();
    if (donorNumber != null) result.donorNumber = donorNumber;
    if (patientId != null) result.patientId = patientId;
    if (displayName != null) result.displayName = displayName;
    if (contactPhone != null) result.contactPhone = contactPhone;
    if (group != null) result.group = group;
    return result;
  }

  RegisterDonorRequest._();

  factory RegisterDonorRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterDonorRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterDonorRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'donorNumber')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'displayName')
    ..aOS(4, _omitFieldNames ? '' : 'contactPhone')
    ..aOM<BloodGroup>(5, _omitFieldNames ? '' : 'group',
        subBuilder: BloodGroup.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterDonorRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterDonorRequest copyWith(void Function(RegisterDonorRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterDonorRequest))
          as RegisterDonorRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterDonorRequest create() => RegisterDonorRequest._();
  @$core.override
  RegisterDonorRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterDonorRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterDonorRequest>(create);
  static RegisterDonorRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get donorNumber => $_getSZ(0);
  @$pb.TagNumber(1)
  set donorNumber($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDonorNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearDonorNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get contactPhone => $_getSZ(3);
  @$pb.TagNumber(4)
  set contactPhone($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContactPhone() => $_has(3);
  @$pb.TagNumber(4)
  void clearContactPhone() => $_clearField(4);

  @$pb.TagNumber(5)
  BloodGroup get group => $_getN(4);
  @$pb.TagNumber(5)
  set group(BloodGroup value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasGroup() => $_has(4);
  @$pb.TagNumber(5)
  void clearGroup() => $_clearField(5);
  @$pb.TagNumber(5)
  BloodGroup ensureGroup() => $_ensure(4);
}

class RegisterDonorResponse extends $pb.GeneratedMessage {
  factory RegisterDonorResponse({
    Donor? donor,
  }) {
    final result = create();
    if (donor != null) result.donor = donor;
    return result;
  }

  RegisterDonorResponse._();

  factory RegisterDonorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterDonorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterDonorResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Donor>(1, _omitFieldNames ? '' : 'donor', subBuilder: Donor.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterDonorResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterDonorResponse copyWith(
          void Function(RegisterDonorResponse) updates) =>
      super.copyWith((message) => updates(message as RegisterDonorResponse))
          as RegisterDonorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterDonorResponse create() => RegisterDonorResponse._();
  @$core.override
  RegisterDonorResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterDonorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterDonorResponse>(create);
  static RegisterDonorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Donor get donor => $_getN(0);
  @$pb.TagNumber(1)
  set donor(Donor value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDonor() => $_has(0);
  @$pb.TagNumber(1)
  void clearDonor() => $_clearField(1);
  @$pb.TagNumber(1)
  Donor ensureDonor() => $_ensure(0);
}

class GetDonorRequest extends $pb.GeneratedMessage {
  factory GetDonorRequest({
    $core.String? donorId,
  }) {
    final result = create();
    if (donorId != null) result.donorId = donorId;
    return result;
  }

  GetDonorRequest._();

  factory GetDonorRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDonorRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDonorRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'donorId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDonorRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDonorRequest copyWith(void Function(GetDonorRequest) updates) =>
      super.copyWith((message) => updates(message as GetDonorRequest))
          as GetDonorRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDonorRequest create() => GetDonorRequest._();
  @$core.override
  GetDonorRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDonorRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDonorRequest>(create);
  static GetDonorRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get donorId => $_getSZ(0);
  @$pb.TagNumber(1)
  set donorId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDonorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDonorId() => $_clearField(1);
}

class GetDonorResponse extends $pb.GeneratedMessage {
  factory GetDonorResponse({
    Donor? donor,
  }) {
    final result = create();
    if (donor != null) result.donor = donor;
    return result;
  }

  GetDonorResponse._();

  factory GetDonorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDonorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDonorResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Donor>(1, _omitFieldNames ? '' : 'donor', subBuilder: Donor.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDonorResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDonorResponse copyWith(void Function(GetDonorResponse) updates) =>
      super.copyWith((message) => updates(message as GetDonorResponse))
          as GetDonorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDonorResponse create() => GetDonorResponse._();
  @$core.override
  GetDonorResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDonorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDonorResponse>(create);
  static GetDonorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Donor get donor => $_getN(0);
  @$pb.TagNumber(1)
  set donor(Donor value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDonor() => $_has(0);
  @$pb.TagNumber(1)
  void clearDonor() => $_clearField(1);
  @$pb.TagNumber(1)
  Donor ensureDonor() => $_ensure(0);
}

class DeferDonorRequest extends $pb.GeneratedMessage {
  factory DeferDonorRequest({
    $core.String? donorId,
    DeferralKind? kind,
    $core.String? code,
    $core.String? note,
    $0.Timestamp? until,
  }) {
    final result = create();
    if (donorId != null) result.donorId = donorId;
    if (kind != null) result.kind = kind;
    if (code != null) result.code = code;
    if (note != null) result.note = note;
    if (until != null) result.until = until;
    return result;
  }

  DeferDonorRequest._();

  factory DeferDonorRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeferDonorRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeferDonorRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'donorId')
    ..aE<DeferralKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: DeferralKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'until',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeferDonorRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeferDonorRequest copyWith(void Function(DeferDonorRequest) updates) =>
      super.copyWith((message) => updates(message as DeferDonorRequest))
          as DeferDonorRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeferDonorRequest create() => DeferDonorRequest._();
  @$core.override
  DeferDonorRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeferDonorRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeferDonorRequest>(create);
  static DeferDonorRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get donorId => $_getSZ(0);
  @$pb.TagNumber(1)
  set donorId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDonorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDonorId() => $_clearField(1);

  @$pb.TagNumber(2)
  DeferralKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(DeferralKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);

  /// Required for a temporary deferral: one with no end is a permanent one
  /// nobody meant to make, and the donor is lost.
  @$pb.TagNumber(5)
  $0.Timestamp get until => $_getN(4);
  @$pb.TagNumber(5)
  set until($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUntil() => $_has(4);
  @$pb.TagNumber(5)
  void clearUntil() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureUntil() => $_ensure(4);
}

class DeferDonorResponse extends $pb.GeneratedMessage {
  factory DeferDonorResponse({
    Donor? donor,
  }) {
    final result = create();
    if (donor != null) result.donor = donor;
    return result;
  }

  DeferDonorResponse._();

  factory DeferDonorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeferDonorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeferDonorResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Donor>(1, _omitFieldNames ? '' : 'donor', subBuilder: Donor.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeferDonorResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeferDonorResponse copyWith(void Function(DeferDonorResponse) updates) =>
      super.copyWith((message) => updates(message as DeferDonorResponse))
          as DeferDonorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeferDonorResponse create() => DeferDonorResponse._();
  @$core.override
  DeferDonorResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeferDonorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeferDonorResponse>(create);
  static DeferDonorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Donor get donor => $_getN(0);
  @$pb.TagNumber(1)
  set donor(Donor value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDonor() => $_has(0);
  @$pb.TagNumber(1)
  void clearDonor() => $_clearField(1);
  @$pb.TagNumber(1)
  Donor ensureDonor() => $_ensure(0);
}

class ReinstateDonorRequest extends $pb.GeneratedMessage {
  factory ReinstateDonorRequest({
    $core.String? donorId,
    $core.String? reason,
  }) {
    final result = create();
    if (donorId != null) result.donorId = donorId;
    if (reason != null) result.reason = reason;
    return result;
  }

  ReinstateDonorRequest._();

  factory ReinstateDonorRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReinstateDonorRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReinstateDonorRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'donorId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReinstateDonorRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReinstateDonorRequest copyWith(
          void Function(ReinstateDonorRequest) updates) =>
      super.copyWith((message) => updates(message as ReinstateDonorRequest))
          as ReinstateDonorRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReinstateDonorRequest create() => ReinstateDonorRequest._();
  @$core.override
  ReinstateDonorRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReinstateDonorRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReinstateDonorRequest>(create);
  static ReinstateDonorRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get donorId => $_getSZ(0);
  @$pb.TagNumber(1)
  set donorId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDonorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDonorId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class ReinstateDonorResponse extends $pb.GeneratedMessage {
  factory ReinstateDonorResponse({
    Donor? donor,
  }) {
    final result = create();
    if (donor != null) result.donor = donor;
    return result;
  }

  ReinstateDonorResponse._();

  factory ReinstateDonorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReinstateDonorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReinstateDonorResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Donor>(1, _omitFieldNames ? '' : 'donor', subBuilder: Donor.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReinstateDonorResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReinstateDonorResponse copyWith(
          void Function(ReinstateDonorResponse) updates) =>
      super.copyWith((message) => updates(message as ReinstateDonorResponse))
          as ReinstateDonorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReinstateDonorResponse create() => ReinstateDonorResponse._();
  @$core.override
  ReinstateDonorResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReinstateDonorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReinstateDonorResponse>(create);
  static ReinstateDonorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Donor get donor => $_getN(0);
  @$pb.TagNumber(1)
  set donor(Donor value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDonor() => $_has(0);
  @$pb.TagNumber(1)
  void clearDonor() => $_clearField(1);
  @$pb.TagNumber(1)
  Donor ensureDonor() => $_ensure(0);
}

class ListDeferredDonorsRequest extends $pb.GeneratedMessage {
  factory ListDeferredDonorsRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListDeferredDonorsRequest._();

  factory ListDeferredDonorsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDeferredDonorsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDeferredDonorsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDeferredDonorsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDeferredDonorsRequest copyWith(
          void Function(ListDeferredDonorsRequest) updates) =>
      super.copyWith((message) => updates(message as ListDeferredDonorsRequest))
          as ListDeferredDonorsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDeferredDonorsRequest create() => ListDeferredDonorsRequest._();
  @$core.override
  ListDeferredDonorsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDeferredDonorsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDeferredDonorsRequest>(create);
  static ListDeferredDonorsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListDeferredDonorsResponse extends $pb.GeneratedMessage {
  factory ListDeferredDonorsResponse({
    $core.Iterable<Donor>? donors,
  }) {
    final result = create();
    if (donors != null) result.donors.addAll(donors);
    return result;
  }

  ListDeferredDonorsResponse._();

  factory ListDeferredDonorsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDeferredDonorsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDeferredDonorsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..pPM<Donor>(1, _omitFieldNames ? '' : 'donors', subBuilder: Donor.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDeferredDonorsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDeferredDonorsResponse copyWith(
          void Function(ListDeferredDonorsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListDeferredDonorsResponse))
          as ListDeferredDonorsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDeferredDonorsResponse create() => ListDeferredDonorsResponse._();
  @$core.override
  ListDeferredDonorsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDeferredDonorsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDeferredDonorsResponse>(create);
  static ListDeferredDonorsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Donor> get donors => $_getList(0);
}

class ScreenDonorRequest extends $pb.GeneratedMessage {
  factory ScreenDonorRequest({
    $core.String? donorId,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? answers,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? measurements,
    $core.bool? consented,
    $core.String? consentNote,
    $core.bool? accepted,
    DeferralKind? deferral,
    $core.String? deferralCode,
  }) {
    final result = create();
    if (donorId != null) result.donorId = donorId;
    if (answers != null) result.answers.addEntries(answers);
    if (measurements != null) result.measurements.addEntries(measurements);
    if (consented != null) result.consented = consented;
    if (consentNote != null) result.consentNote = consentNote;
    if (accepted != null) result.accepted = accepted;
    if (deferral != null) result.deferral = deferral;
    if (deferralCode != null) result.deferralCode = deferralCode;
    return result;
  }

  ScreenDonorRequest._();

  factory ScreenDonorRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScreenDonorRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScreenDonorRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'donorId')
    ..m<$core.String, $core.String>(2, _omitFieldNames ? '' : 'answers',
        entryClassName: 'ScreenDonorRequest.AnswersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('healthcare.bloodbank.v1'))
    ..m<$core.String, $core.double>(3, _omitFieldNames ? '' : 'measurements',
        entryClassName: 'ScreenDonorRequest.MeasurementsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('healthcare.bloodbank.v1'))
    ..aOB(4, _omitFieldNames ? '' : 'consented')
    ..aOS(5, _omitFieldNames ? '' : 'consentNote')
    ..aOB(6, _omitFieldNames ? '' : 'accepted')
    ..aE<DeferralKind>(7, _omitFieldNames ? '' : 'deferral',
        enumValues: DeferralKind.values)
    ..aOS(8, _omitFieldNames ? '' : 'deferralCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScreenDonorRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScreenDonorRequest copyWith(void Function(ScreenDonorRequest) updates) =>
      super.copyWith((message) => updates(message as ScreenDonorRequest))
          as ScreenDonorRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScreenDonorRequest create() => ScreenDonorRequest._();
  @$core.override
  ScreenDonorRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScreenDonorRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScreenDonorRequest>(create);
  static ScreenDonorRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get donorId => $_getSZ(0);
  @$pb.TagNumber(1)
  set donorId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDonorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDonorId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.String> get answers => $_getMap(1);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.double> get measurements => $_getMap(2);

  @$pb.TagNumber(4)
  $core.bool get consented => $_getBF(3);
  @$pb.TagNumber(4)
  set consented($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasConsented() => $_has(3);
  @$pb.TagNumber(4)
  void clearConsented() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get consentNote => $_getSZ(4);
  @$pb.TagNumber(5)
  set consentNote($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConsentNote() => $_has(4);
  @$pb.TagNumber(5)
  void clearConsentNote() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get accepted => $_getBF(5);
  @$pb.TagNumber(6)
  set accepted($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAccepted() => $_has(5);
  @$pb.TagNumber(6)
  void clearAccepted() => $_clearField(6);

  @$pb.TagNumber(7)
  DeferralKind get deferral => $_getN(6);
  @$pb.TagNumber(7)
  set deferral(DeferralKind value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDeferral() => $_has(6);
  @$pb.TagNumber(7)
  void clearDeferral() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get deferralCode => $_getSZ(7);
  @$pb.TagNumber(8)
  set deferralCode($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDeferralCode() => $_has(7);
  @$pb.TagNumber(8)
  void clearDeferralCode() => $_clearField(8);
}

class ScreenDonorResponse extends $pb.GeneratedMessage {
  factory ScreenDonorResponse({
    Screening? screening,
  }) {
    final result = create();
    if (screening != null) result.screening = screening;
    return result;
  }

  ScreenDonorResponse._();

  factory ScreenDonorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScreenDonorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScreenDonorResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Screening>(1, _omitFieldNames ? '' : 'screening',
        subBuilder: Screening.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScreenDonorResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScreenDonorResponse copyWith(void Function(ScreenDonorResponse) updates) =>
      super.copyWith((message) => updates(message as ScreenDonorResponse))
          as ScreenDonorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScreenDonorResponse create() => ScreenDonorResponse._();
  @$core.override
  ScreenDonorResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScreenDonorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScreenDonorResponse>(create);
  static ScreenDonorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Screening get screening => $_getN(0);
  @$pb.TagNumber(1)
  set screening(Screening value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScreening() => $_has(0);
  @$pb.TagNumber(1)
  void clearScreening() => $_clearField(1);
  @$pb.TagNumber(1)
  Screening ensureScreening() => $_ensure(0);
}

class CollectRequest extends $pb.GeneratedMessage {
  factory CollectRequest({
    $core.String? donorId,
    $core.String? screeningId,
    $core.String? donationNumber,
    $core.String? kind,
    $core.int? volumeMl,
    BloodGroup? group,
    $core.bool? adverseEvent,
    $core.String? adverseNote,
  }) {
    final result = create();
    if (donorId != null) result.donorId = donorId;
    if (screeningId != null) result.screeningId = screeningId;
    if (donationNumber != null) result.donationNumber = donationNumber;
    if (kind != null) result.kind = kind;
    if (volumeMl != null) result.volumeMl = volumeMl;
    if (group != null) result.group = group;
    if (adverseEvent != null) result.adverseEvent = adverseEvent;
    if (adverseNote != null) result.adverseNote = adverseNote;
    return result;
  }

  CollectRequest._();

  factory CollectRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CollectRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CollectRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'donorId')
    ..aOS(2, _omitFieldNames ? '' : 'screeningId')
    ..aOS(3, _omitFieldNames ? '' : 'donationNumber')
    ..aOS(4, _omitFieldNames ? '' : 'kind')
    ..aI(5, _omitFieldNames ? '' : 'volumeMl')
    ..aOM<BloodGroup>(6, _omitFieldNames ? '' : 'group',
        subBuilder: BloodGroup.create)
    ..aOB(7, _omitFieldNames ? '' : 'adverseEvent')
    ..aOS(8, _omitFieldNames ? '' : 'adverseNote')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectRequest copyWith(void Function(CollectRequest) updates) =>
      super.copyWith((message) => updates(message as CollectRequest))
          as CollectRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CollectRequest create() => CollectRequest._();
  @$core.override
  CollectRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CollectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CollectRequest>(create);
  static CollectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get donorId => $_getSZ(0);
  @$pb.TagNumber(1)
  set donorId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDonorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDonorId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get screeningId => $_getSZ(1);
  @$pb.TagNumber(2)
  set screeningId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScreeningId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScreeningId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get donationNumber => $_getSZ(2);
  @$pb.TagNumber(3)
  set donationNumber($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDonationNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearDonationNumber() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get kind => $_getSZ(3);
  @$pb.TagNumber(4)
  set kind($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get volumeMl => $_getIZ(4);
  @$pb.TagNumber(5)
  set volumeMl($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVolumeMl() => $_has(4);
  @$pb.TagNumber(5)
  void clearVolumeMl() => $_clearField(5);

  @$pb.TagNumber(6)
  BloodGroup get group => $_getN(5);
  @$pb.TagNumber(6)
  set group(BloodGroup value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasGroup() => $_has(5);
  @$pb.TagNumber(6)
  void clearGroup() => $_clearField(6);
  @$pb.TagNumber(6)
  BloodGroup ensureGroup() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.bool get adverseEvent => $_getBF(6);
  @$pb.TagNumber(7)
  set adverseEvent($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAdverseEvent() => $_has(6);
  @$pb.TagNumber(7)
  void clearAdverseEvent() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get adverseNote => $_getSZ(7);
  @$pb.TagNumber(8)
  set adverseNote($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAdverseNote() => $_has(7);
  @$pb.TagNumber(8)
  void clearAdverseNote() => $_clearField(8);
}

class CollectResponse extends $pb.GeneratedMessage {
  factory CollectResponse({
    Collection? collection,
  }) {
    final result = create();
    if (collection != null) result.collection = collection;
    return result;
  }

  CollectResponse._();

  factory CollectResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CollectResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CollectResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Collection>(1, _omitFieldNames ? '' : 'collection',
        subBuilder: Collection.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectResponse copyWith(void Function(CollectResponse) updates) =>
      super.copyWith((message) => updates(message as CollectResponse))
          as CollectResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CollectResponse create() => CollectResponse._();
  @$core.override
  CollectResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CollectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CollectResponse>(create);
  static CollectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Collection get collection => $_getN(0);
  @$pb.TagNumber(1)
  set collection(Collection value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCollection() => $_has(0);
  @$pb.TagNumber(1)
  void clearCollection() => $_clearField(1);
  @$pb.TagNumber(1)
  Collection ensureCollection() => $_ensure(0);
}

class RecordTestRequest extends $pb.GeneratedMessage {
  factory RecordTestRequest({
    $core.String? collectionId,
    $core.String? code,
    $core.String? display,
    $core.bool? reactive,
    $core.String? value,
    $core.String? method,
  }) {
    final result = create();
    if (collectionId != null) result.collectionId = collectionId;
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (reactive != null) result.reactive = reactive;
    if (value != null) result.value = value;
    if (method != null) result.method = method;
    return result;
  }

  RecordTestRequest._();

  factory RecordTestRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordTestRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordTestRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'collectionId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'display')
    ..aOB(4, _omitFieldNames ? '' : 'reactive')
    ..aOS(5, _omitFieldNames ? '' : 'value')
    ..aOS(6, _omitFieldNames ? '' : 'method')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordTestRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordTestRequest copyWith(void Function(RecordTestRequest) updates) =>
      super.copyWith((message) => updates(message as RecordTestRequest))
          as RecordTestRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordTestRequest create() => RecordTestRequest._();
  @$core.override
  RecordTestRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordTestRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordTestRequest>(create);
  static RecordTestRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get collectionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set collectionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCollectionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCollectionId() => $_clearField(1);

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
  $core.bool get reactive => $_getBF(3);
  @$pb.TagNumber(4)
  set reactive($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReactive() => $_has(3);
  @$pb.TagNumber(4)
  void clearReactive() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get value => $_getSZ(4);
  @$pb.TagNumber(5)
  set value($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearValue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get method => $_getSZ(5);
  @$pb.TagNumber(6)
  set method($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMethod() => $_has(5);
  @$pb.TagNumber(6)
  void clearMethod() => $_clearField(6);
}

class RecordTestResponse extends $pb.GeneratedMessage {
  factory RecordTestResponse({
    TestResult? result,
  }) {
    final result$ = create();
    if (result != null) result$.result = result;
    return result$;
  }

  RecordTestResponse._();

  factory RecordTestResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordTestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordTestResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<TestResult>(1, _omitFieldNames ? '' : 'result',
        subBuilder: TestResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordTestResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordTestResponse copyWith(void Function(RecordTestResponse) updates) =>
      super.copyWith((message) => updates(message as RecordTestResponse))
          as RecordTestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordTestResponse create() => RecordTestResponse._();
  @$core.override
  RecordTestResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordTestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordTestResponse>(create);
  static RecordTestResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TestResult get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(TestResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);
  @$pb.TagNumber(1)
  TestResult ensureResult() => $_ensure(0);
}

class GetReleaseDecisionRequest extends $pb.GeneratedMessage {
  factory GetReleaseDecisionRequest({
    $core.String? collectionId,
  }) {
    final result = create();
    if (collectionId != null) result.collectionId = collectionId;
    return result;
  }

  GetReleaseDecisionRequest._();

  factory GetReleaseDecisionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReleaseDecisionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReleaseDecisionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'collectionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReleaseDecisionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReleaseDecisionRequest copyWith(
          void Function(GetReleaseDecisionRequest) updates) =>
      super.copyWith((message) => updates(message as GetReleaseDecisionRequest))
          as GetReleaseDecisionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReleaseDecisionRequest create() => GetReleaseDecisionRequest._();
  @$core.override
  GetReleaseDecisionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetReleaseDecisionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReleaseDecisionRequest>(create);
  static GetReleaseDecisionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get collectionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set collectionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCollectionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCollectionId() => $_clearField(1);
}

class GetReleaseDecisionResponse extends $pb.GeneratedMessage {
  factory GetReleaseDecisionResponse({
    ReleaseDecision? decision,
  }) {
    final result = create();
    if (decision != null) result.decision = decision;
    return result;
  }

  GetReleaseDecisionResponse._();

  factory GetReleaseDecisionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReleaseDecisionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReleaseDecisionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<ReleaseDecision>(1, _omitFieldNames ? '' : 'decision',
        subBuilder: ReleaseDecision.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReleaseDecisionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReleaseDecisionResponse copyWith(
          void Function(GetReleaseDecisionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetReleaseDecisionResponse))
          as GetReleaseDecisionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReleaseDecisionResponse create() => GetReleaseDecisionResponse._();
  @$core.override
  GetReleaseDecisionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetReleaseDecisionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReleaseDecisionResponse>(create);
  static GetReleaseDecisionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReleaseDecision get decision => $_getN(0);
  @$pb.TagNumber(1)
  set decision(ReleaseDecision value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDecision() => $_has(0);
  @$pb.TagNumber(1)
  void clearDecision() => $_clearField(1);
  @$pb.TagNumber(1)
  ReleaseDecision ensureDecision() => $_ensure(0);
}

class ReleaseComponentsRequest extends $pb.GeneratedMessage {
  factory ReleaseComponentsRequest({
    $core.String? collectionId,
  }) {
    final result = create();
    if (collectionId != null) result.collectionId = collectionId;
    return result;
  }

  ReleaseComponentsRequest._();

  factory ReleaseComponentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseComponentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseComponentsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'collectionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseComponentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseComponentsRequest copyWith(
          void Function(ReleaseComponentsRequest) updates) =>
      super.copyWith((message) => updates(message as ReleaseComponentsRequest))
          as ReleaseComponentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseComponentsRequest create() => ReleaseComponentsRequest._();
  @$core.override
  ReleaseComponentsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseComponentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseComponentsRequest>(create);
  static ReleaseComponentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get collectionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set collectionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCollectionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCollectionId() => $_clearField(1);
}

class ReleaseComponentsResponse extends $pb.GeneratedMessage {
  factory ReleaseComponentsResponse({
    $core.Iterable<Component>? components,
  }) {
    final result = create();
    if (components != null) result.components.addAll(components);
    return result;
  }

  ReleaseComponentsResponse._();

  factory ReleaseComponentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseComponentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseComponentsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..pPM<Component>(1, _omitFieldNames ? '' : 'components',
        subBuilder: Component.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseComponentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseComponentsResponse copyWith(
          void Function(ReleaseComponentsResponse) updates) =>
      super.copyWith((message) => updates(message as ReleaseComponentsResponse))
          as ReleaseComponentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseComponentsResponse create() => ReleaseComponentsResponse._();
  @$core.override
  ReleaseComponentsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseComponentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseComponentsResponse>(create);
  static ReleaseComponentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Component> get components => $_getList(0);
}

class AddComponentRequest extends $pb.GeneratedMessage {
  factory AddComponentRequest({
    $core.String? unitNumber,
    $core.String? collectionId,
    $core.String? donorId,
    $core.String? source,
    ComponentClass? componentClass,
    BloodGroup? group,
    $core.int? volumeMl,
    $core.Iterable<$core.String>? attributes,
    $core.String? location,
    $0.Timestamp? collectedAt,
    $0.Timestamp? expiresAt,
    $core.bool? released,
  }) {
    final result = create();
    if (unitNumber != null) result.unitNumber = unitNumber;
    if (collectionId != null) result.collectionId = collectionId;
    if (donorId != null) result.donorId = donorId;
    if (source != null) result.source = source;
    if (componentClass != null) result.componentClass = componentClass;
    if (group != null) result.group = group;
    if (volumeMl != null) result.volumeMl = volumeMl;
    if (attributes != null) result.attributes.addAll(attributes);
    if (location != null) result.location = location;
    if (collectedAt != null) result.collectedAt = collectedAt;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (released != null) result.released = released;
    return result;
  }

  AddComponentRequest._();

  factory AddComponentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddComponentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddComponentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitNumber')
    ..aOS(2, _omitFieldNames ? '' : 'collectionId')
    ..aOS(3, _omitFieldNames ? '' : 'donorId')
    ..aOS(4, _omitFieldNames ? '' : 'source')
    ..aE<ComponentClass>(5, _omitFieldNames ? '' : 'componentClass',
        enumValues: ComponentClass.values)
    ..aOM<BloodGroup>(6, _omitFieldNames ? '' : 'group',
        subBuilder: BloodGroup.create)
    ..aI(7, _omitFieldNames ? '' : 'volumeMl')
    ..pPS(8, _omitFieldNames ? '' : 'attributes')
    ..aOS(9, _omitFieldNames ? '' : 'location')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'collectedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(12, _omitFieldNames ? '' : 'released')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddComponentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddComponentRequest copyWith(void Function(AddComponentRequest) updates) =>
      super.copyWith((message) => updates(message as AddComponentRequest))
          as AddComponentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddComponentRequest create() => AddComponentRequest._();
  @$core.override
  AddComponentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddComponentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddComponentRequest>(create);
  static AddComponentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitNumber => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitNumber($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get collectionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set collectionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCollectionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCollectionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get donorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set donorId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDonorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearDonorId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get source => $_getSZ(3);
  @$pb.TagNumber(4)
  set source($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);

  @$pb.TagNumber(5)
  ComponentClass get componentClass => $_getN(4);
  @$pb.TagNumber(5)
  set componentClass(ComponentClass value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasComponentClass() => $_has(4);
  @$pb.TagNumber(5)
  void clearComponentClass() => $_clearField(5);

  @$pb.TagNumber(6)
  BloodGroup get group => $_getN(5);
  @$pb.TagNumber(6)
  set group(BloodGroup value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasGroup() => $_has(5);
  @$pb.TagNumber(6)
  void clearGroup() => $_clearField(6);
  @$pb.TagNumber(6)
  BloodGroup ensureGroup() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.int get volumeMl => $_getIZ(6);
  @$pb.TagNumber(7)
  set volumeMl($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVolumeMl() => $_has(6);
  @$pb.TagNumber(7)
  void clearVolumeMl() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get attributes => $_getList(7);

  @$pb.TagNumber(9)
  $core.String get location => $_getSZ(8);
  @$pb.TagNumber(9)
  set location($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLocation() => $_has(8);
  @$pb.TagNumber(9)
  void clearLocation() => $_clearField(9);

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
  $0.Timestamp get expiresAt => $_getN(10);
  @$pb.TagNumber(11)
  set expiresAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasExpiresAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearExpiresAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureExpiresAt() => $_ensure(10);

  /// Marks a unit whose mandatory testing is already complete — the ordinary
  /// case for a unit bought in from a regional centre, and never the case for
  /// one collected here. Setting it needs the release permission.
  @$pb.TagNumber(12)
  $core.bool get released => $_getBF(11);
  @$pb.TagNumber(12)
  set released($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasReleased() => $_has(11);
  @$pb.TagNumber(12)
  void clearReleased() => $_clearField(12);
}

class AddComponentResponse extends $pb.GeneratedMessage {
  factory AddComponentResponse({
    Component? component,
  }) {
    final result = create();
    if (component != null) result.component = component;
    return result;
  }

  AddComponentResponse._();

  factory AddComponentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddComponentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddComponentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Component>(1, _omitFieldNames ? '' : 'component',
        subBuilder: Component.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddComponentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddComponentResponse copyWith(void Function(AddComponentResponse) updates) =>
      super.copyWith((message) => updates(message as AddComponentResponse))
          as AddComponentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddComponentResponse create() => AddComponentResponse._();
  @$core.override
  AddComponentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddComponentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddComponentResponse>(create);
  static AddComponentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Component get component => $_getN(0);
  @$pb.TagNumber(1)
  set component(Component value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasComponent() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponent() => $_clearField(1);
  @$pb.TagNumber(1)
  Component ensureComponent() => $_ensure(0);
}

class GetComponentRequest extends $pb.GeneratedMessage {
  factory GetComponentRequest({
    $core.String? componentId,
    $core.String? unitNumber,
  }) {
    final result = create();
    if (componentId != null) result.componentId = componentId;
    if (unitNumber != null) result.unitNumber = unitNumber;
    return result;
  }

  GetComponentRequest._();

  factory GetComponentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetComponentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetComponentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'componentId')
    ..aOS(2, _omitFieldNames ? '' : 'unitNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetComponentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetComponentRequest copyWith(void Function(GetComponentRequest) updates) =>
      super.copyWith((message) => updates(message as GetComponentRequest))
          as GetComponentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetComponentRequest create() => GetComponentRequest._();
  @$core.override
  GetComponentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetComponentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetComponentRequest>(create);
  static GetComponentRequest? _defaultInstance;

  /// Either. A bedside scan has the number on the label, not the row id.
  @$pb.TagNumber(1)
  $core.String get componentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set componentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasComponentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get unitNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set unitNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitNumber() => $_clearField(2);
}

class GetComponentResponse extends $pb.GeneratedMessage {
  factory GetComponentResponse({
    Component? component,
  }) {
    final result = create();
    if (component != null) result.component = component;
    return result;
  }

  GetComponentResponse._();

  factory GetComponentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetComponentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetComponentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Component>(1, _omitFieldNames ? '' : 'component',
        subBuilder: Component.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetComponentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetComponentResponse copyWith(void Function(GetComponentResponse) updates) =>
      super.copyWith((message) => updates(message as GetComponentResponse))
          as GetComponentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetComponentResponse create() => GetComponentResponse._();
  @$core.override
  GetComponentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetComponentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetComponentResponse>(create);
  static GetComponentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Component get component => $_getN(0);
  @$pb.TagNumber(1)
  set component(Component value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasComponent() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponent() => $_clearField(1);
  @$pb.TagNumber(1)
  Component ensureComponent() => $_ensure(0);
}

class DiscardComponentRequest extends $pb.GeneratedMessage {
  factory DiscardComponentRequest({
    $core.String? componentId,
    DiscardReason? reason,
  }) {
    final result = create();
    if (componentId != null) result.componentId = componentId;
    if (reason != null) result.reason = reason;
    return result;
  }

  DiscardComponentRequest._();

  factory DiscardComponentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DiscardComponentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiscardComponentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'componentId')
    ..aE<DiscardReason>(2, _omitFieldNames ? '' : 'reason',
        enumValues: DiscardReason.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscardComponentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscardComponentRequest copyWith(
          void Function(DiscardComponentRequest) updates) =>
      super.copyWith((message) => updates(message as DiscardComponentRequest))
          as DiscardComponentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscardComponentRequest create() => DiscardComponentRequest._();
  @$core.override
  DiscardComponentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DiscardComponentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscardComponentRequest>(create);
  static DiscardComponentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get componentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set componentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasComponentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponentId() => $_clearField(1);

  @$pb.TagNumber(2)
  DiscardReason get reason => $_getN(1);
  @$pb.TagNumber(2)
  set reason(DiscardReason value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class DiscardComponentResponse extends $pb.GeneratedMessage {
  factory DiscardComponentResponse({
    Component? component,
  }) {
    final result = create();
    if (component != null) result.component = component;
    return result;
  }

  DiscardComponentResponse._();

  factory DiscardComponentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DiscardComponentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiscardComponentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Component>(1, _omitFieldNames ? '' : 'component',
        subBuilder: Component.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscardComponentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscardComponentResponse copyWith(
          void Function(DiscardComponentResponse) updates) =>
      super.copyWith((message) => updates(message as DiscardComponentResponse))
          as DiscardComponentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscardComponentResponse create() => DiscardComponentResponse._();
  @$core.override
  DiscardComponentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DiscardComponentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscardComponentResponse>(create);
  static DiscardComponentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Component get component => $_getN(0);
  @$pb.TagNumber(1)
  set component(Component value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasComponent() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponent() => $_clearField(1);
  @$pb.TagNumber(1)
  Component ensureComponent() => $_ensure(0);
}

class PlaceRequestRequest extends $pb.GeneratedMessage {
  factory PlaceRequestRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    ComponentClass? componentClass,
    $core.int? quantity,
    $core.String? indication,
    RequestUrgency? urgency,
    $core.Iterable<$core.String>? requirements,
    $0.Timestamp? requiredBy,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (componentClass != null) result.componentClass = componentClass;
    if (quantity != null) result.quantity = quantity;
    if (indication != null) result.indication = indication;
    if (urgency != null) result.urgency = urgency;
    if (requirements != null) result.requirements.addAll(requirements);
    if (requiredBy != null) result.requiredBy = requiredBy;
    return result;
  }

  PlaceRequestRequest._();

  factory PlaceRequestRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaceRequestRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaceRequestRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aE<ComponentClass>(4, _omitFieldNames ? '' : 'componentClass',
        enumValues: ComponentClass.values)
    ..aI(5, _omitFieldNames ? '' : 'quantity')
    ..aOS(6, _omitFieldNames ? '' : 'indication')
    ..aE<RequestUrgency>(7, _omitFieldNames ? '' : 'urgency',
        enumValues: RequestUrgency.values)
    ..pPS(8, _omitFieldNames ? '' : 'requirements')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'requiredBy',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceRequestRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceRequestRequest copyWith(void Function(PlaceRequestRequest) updates) =>
      super.copyWith((message) => updates(message as PlaceRequestRequest))
          as PlaceRequestRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaceRequestRequest create() => PlaceRequestRequest._();
  @$core.override
  PlaceRequestRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaceRequestRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaceRequestRequest>(create);
  static PlaceRequestRequest? _defaultInstance;

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
  ComponentClass get componentClass => $_getN(3);
  @$pb.TagNumber(4)
  set componentClass(ComponentClass value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasComponentClass() => $_has(3);
  @$pb.TagNumber(4)
  void clearComponentClass() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get quantity => $_getIZ(4);
  @$pb.TagNumber(5)
  set quantity($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuantity() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuantity() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get indication => $_getSZ(5);
  @$pb.TagNumber(6)
  set indication($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIndication() => $_has(5);
  @$pb.TagNumber(6)
  void clearIndication() => $_clearField(6);

  @$pb.TagNumber(7)
  RequestUrgency get urgency => $_getN(6);
  @$pb.TagNumber(7)
  set urgency(RequestUrgency value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUrgency() => $_has(6);
  @$pb.TagNumber(7)
  void clearUrgency() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get requirements => $_getList(7);

  @$pb.TagNumber(9)
  $0.Timestamp get requiredBy => $_getN(8);
  @$pb.TagNumber(9)
  set requiredBy($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasRequiredBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearRequiredBy() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureRequiredBy() => $_ensure(8);
}

class PlaceRequestResponse extends $pb.GeneratedMessage {
  factory PlaceRequestResponse({
    Request? request,
  }) {
    final result = create();
    if (request != null) result.request = request;
    return result;
  }

  PlaceRequestResponse._();

  factory PlaceRequestResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaceRequestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaceRequestResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Request>(1, _omitFieldNames ? '' : 'request',
        subBuilder: Request.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceRequestResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceRequestResponse copyWith(void Function(PlaceRequestResponse) updates) =>
      super.copyWith((message) => updates(message as PlaceRequestResponse))
          as PlaceRequestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaceRequestResponse create() => PlaceRequestResponse._();
  @$core.override
  PlaceRequestResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaceRequestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaceRequestResponse>(create);
  static PlaceRequestResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Request get request => $_getN(0);
  @$pb.TagNumber(1)
  set request(Request value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  Request ensureRequest() => $_ensure(0);
}

class GetWorklistRequest extends $pb.GeneratedMessage {
  factory GetWorklistRequest({
    $core.String? facilityId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetWorklistRequest._();

  factory GetWorklistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetWorklistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWorklistRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWorklistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWorklistRequest copyWith(void Function(GetWorklistRequest) updates) =>
      super.copyWith((message) => updates(message as GetWorklistRequest))
          as GetWorklistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetWorklistRequest create() => GetWorklistRequest._();
  @$core.override
  GetWorklistRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetWorklistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWorklistRequest>(create);
  static GetWorklistRequest? _defaultInstance;

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

class GetWorklistResponse extends $pb.GeneratedMessage {
  factory GetWorklistResponse({
    $core.Iterable<Request>? requests,
  }) {
    final result = create();
    if (requests != null) result.requests.addAll(requests);
    return result;
  }

  GetWorklistResponse._();

  factory GetWorklistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetWorklistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWorklistResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..pPM<Request>(1, _omitFieldNames ? '' : 'requests',
        subBuilder: Request.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWorklistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWorklistResponse copyWith(void Function(GetWorklistResponse) updates) =>
      super.copyWith((message) => updates(message as GetWorklistResponse))
          as GetWorklistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetWorklistResponse create() => GetWorklistResponse._();
  @$core.override
  GetWorklistResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetWorklistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWorklistResponse>(create);
  static GetWorklistResponse? _defaultInstance;

  /// Emergency before urgent before routine, then soonest needed. A request
  /// with no required-by time sorts last rather than hiding.
  @$pb.TagNumber(1)
  $pb.PbList<Request> get requests => $_getList(0);
}

class ListPatientRequestsRequest extends $pb.GeneratedMessage {
  factory ListPatientRequestsRequest({
    $core.String? patientId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListPatientRequestsRequest._();

  factory ListPatientRequestsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPatientRequestsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPatientRequestsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPatientRequestsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPatientRequestsRequest copyWith(
          void Function(ListPatientRequestsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListPatientRequestsRequest))
          as ListPatientRequestsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPatientRequestsRequest create() => ListPatientRequestsRequest._();
  @$core.override
  ListPatientRequestsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPatientRequestsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPatientRequestsRequest>(create);
  static ListPatientRequestsRequest? _defaultInstance;

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

class ListPatientRequestsResponse extends $pb.GeneratedMessage {
  factory ListPatientRequestsResponse({
    $core.Iterable<Request>? requests,
  }) {
    final result = create();
    if (requests != null) result.requests.addAll(requests);
    return result;
  }

  ListPatientRequestsResponse._();

  factory ListPatientRequestsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPatientRequestsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPatientRequestsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..pPM<Request>(1, _omitFieldNames ? '' : 'requests',
        subBuilder: Request.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPatientRequestsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPatientRequestsResponse copyWith(
          void Function(ListPatientRequestsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListPatientRequestsResponse))
          as ListPatientRequestsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPatientRequestsResponse create() =>
      ListPatientRequestsResponse._();
  @$core.override
  ListPatientRequestsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPatientRequestsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPatientRequestsResponse>(create);
  static ListPatientRequestsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Request> get requests => $_getList(0);
}

class GroupPatientRequest extends $pb.GeneratedMessage {
  factory GroupPatientRequest({
    $core.String? patientId,
    $core.String? sampleNumber,
    BloodGroup? group,
    $core.bool? antibodyScreenPositive,
    $core.String? antibodyNote,
    $core.bool? secondCheck,
    $0.Timestamp? collectedAt,
    $core.String? collectedBy,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (sampleNumber != null) result.sampleNumber = sampleNumber;
    if (group != null) result.group = group;
    if (antibodyScreenPositive != null)
      result.antibodyScreenPositive = antibodyScreenPositive;
    if (antibodyNote != null) result.antibodyNote = antibodyNote;
    if (secondCheck != null) result.secondCheck = secondCheck;
    if (collectedAt != null) result.collectedAt = collectedAt;
    if (collectedBy != null) result.collectedBy = collectedBy;
    return result;
  }

  GroupPatientRequest._();

  factory GroupPatientRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupPatientRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupPatientRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'sampleNumber')
    ..aOM<BloodGroup>(3, _omitFieldNames ? '' : 'group',
        subBuilder: BloodGroup.create)
    ..aOB(4, _omitFieldNames ? '' : 'antibodyScreenPositive')
    ..aOS(5, _omitFieldNames ? '' : 'antibodyNote')
    ..aOB(6, _omitFieldNames ? '' : 'secondCheck')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'collectedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'collectedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupPatientRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupPatientRequest copyWith(void Function(GroupPatientRequest) updates) =>
      super.copyWith((message) => updates(message as GroupPatientRequest))
          as GroupPatientRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupPatientRequest create() => GroupPatientRequest._();
  @$core.override
  GroupPatientRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupPatientRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupPatientRequest>(create);
  static GroupPatientRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sampleNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set sampleNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSampleNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearSampleNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  BloodGroup get group => $_getN(2);
  @$pb.TagNumber(3)
  set group(BloodGroup value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasGroup() => $_has(2);
  @$pb.TagNumber(3)
  void clearGroup() => $_clearField(3);
  @$pb.TagNumber(3)
  BloodGroup ensureGroup() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get antibodyScreenPositive => $_getBF(3);
  @$pb.TagNumber(4)
  set antibodyScreenPositive($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAntibodyScreenPositive() => $_has(3);
  @$pb.TagNumber(4)
  void clearAntibodyScreenPositive() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get antibodyNote => $_getSZ(4);
  @$pb.TagNumber(5)
  set antibodyNote($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAntibodyNote() => $_has(4);
  @$pb.TagNumber(5)
  void clearAntibodyNote() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get secondCheck => $_getBF(5);
  @$pb.TagNumber(6)
  set secondCheck($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSecondCheck() => $_has(5);
  @$pb.TagNumber(6)
  void clearSecondCheck() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get collectedAt => $_getN(6);
  @$pb.TagNumber(7)
  set collectedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCollectedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCollectedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureCollectedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get collectedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set collectedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCollectedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearCollectedBy() => $_clearField(8);
}

class GroupPatientResponse extends $pb.GeneratedMessage {
  factory GroupPatientResponse({
    PatientSample? sample,
  }) {
    final result = create();
    if (sample != null) result.sample = sample;
    return result;
  }

  GroupPatientResponse._();

  factory GroupPatientResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupPatientResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupPatientResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<PatientSample>(1, _omitFieldNames ? '' : 'sample',
        subBuilder: PatientSample.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupPatientResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupPatientResponse copyWith(void Function(GroupPatientResponse) updates) =>
      super.copyWith((message) => updates(message as GroupPatientResponse))
          as GroupPatientResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupPatientResponse create() => GroupPatientResponse._();
  @$core.override
  GroupPatientResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupPatientResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupPatientResponse>(create);
  static GroupPatientResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PatientSample get sample => $_getN(0);
  @$pb.TagNumber(1)
  set sample(PatientSample value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSample() => $_has(0);
  @$pb.TagNumber(1)
  void clearSample() => $_clearField(1);
  @$pb.TagNumber(1)
  PatientSample ensureSample() => $_ensure(0);
}

class FindCompatibleRequest extends $pb.GeneratedMessage {
  factory FindCompatibleRequest({
    $core.String? requestId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  FindCompatibleRequest._();

  factory FindCompatibleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindCompatibleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FindCompatibleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindCompatibleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindCompatibleRequest copyWith(
          void Function(FindCompatibleRequest) updates) =>
      super.copyWith((message) => updates(message as FindCompatibleRequest))
          as FindCompatibleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindCompatibleRequest create() => FindCompatibleRequest._();
  @$core.override
  FindCompatibleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindCompatibleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FindCompatibleRequest>(create);
  static FindCompatibleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class FindCompatibleResponse extends $pb.GeneratedMessage {
  factory FindCompatibleResponse({
    $core.Iterable<Candidate>? candidates,
  }) {
    final result = create();
    if (candidates != null) result.candidates.addAll(candidates);
    return result;
  }

  FindCompatibleResponse._();

  factory FindCompatibleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindCompatibleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FindCompatibleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..pPM<Candidate>(1, _omitFieldNames ? '' : 'candidates',
        subBuilder: Candidate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindCompatibleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindCompatibleResponse copyWith(
          void Function(FindCompatibleResponse) updates) =>
      super.copyWith((message) => updates(message as FindCompatibleResponse))
          as FindCompatibleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindCompatibleResponse create() => FindCompatibleResponse._();
  @$core.override
  FindCompatibleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindCompatibleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FindCompatibleResponse>(create);
  static FindCompatibleResponse? _defaultInstance;

  /// Every candidate with its verdict, not a pre-filtered list.
  @$pb.TagNumber(1)
  $pb.PbList<Candidate> get candidates => $_getList(0);
}

class ReserveRequest extends $pb.GeneratedMessage {
  factory ReserveRequest({
    $core.String? requestId,
    $core.String? componentId,
    $core.bool? crossmatched,
    $core.String? note,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (componentId != null) result.componentId = componentId;
    if (crossmatched != null) result.crossmatched = crossmatched;
    if (note != null) result.note = note;
    return result;
  }

  ReserveRequest._();

  factory ReserveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReserveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReserveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'componentId')
    ..aOB(3, _omitFieldNames ? '' : 'crossmatched')
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReserveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReserveRequest copyWith(void Function(ReserveRequest) updates) =>
      super.copyWith((message) => updates(message as ReserveRequest))
          as ReserveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReserveRequest create() => ReserveRequest._();
  @$core.override
  ReserveRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReserveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReserveRequest>(create);
  static ReserveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get componentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set componentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasComponentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearComponentId() => $_clearField(2);

  /// A serological crossmatch actually performed, as distinct from an
  /// electronic issue.
  @$pb.TagNumber(3)
  $core.bool get crossmatched => $_getBF(2);
  @$pb.TagNumber(3)
  set crossmatched($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCrossmatched() => $_has(2);
  @$pb.TagNumber(3)
  void clearCrossmatched() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);
}

class ReserveResponse extends $pb.GeneratedMessage {
  factory ReserveResponse({
    Reservation? reservation,
  }) {
    final result = create();
    if (reservation != null) result.reservation = reservation;
    return result;
  }

  ReserveResponse._();

  factory ReserveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReserveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReserveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Reservation>(1, _omitFieldNames ? '' : 'reservation',
        subBuilder: Reservation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReserveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReserveResponse copyWith(void Function(ReserveResponse) updates) =>
      super.copyWith((message) => updates(message as ReserveResponse))
          as ReserveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReserveResponse create() => ReserveResponse._();
  @$core.override
  ReserveResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReserveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReserveResponse>(create);
  static ReserveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Reservation get reservation => $_getN(0);
  @$pb.TagNumber(1)
  set reservation(Reservation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReservation() => $_has(0);
  @$pb.TagNumber(1)
  void clearReservation() => $_clearField(1);
  @$pb.TagNumber(1)
  Reservation ensureReservation() => $_ensure(0);
}

class ReleaseReservationRequest extends $pb.GeneratedMessage {
  factory ReleaseReservationRequest({
    $core.String? reservationId,
    $core.String? reason,
  }) {
    final result = create();
    if (reservationId != null) result.reservationId = reservationId;
    if (reason != null) result.reason = reason;
    return result;
  }

  ReleaseReservationRequest._();

  factory ReleaseReservationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseReservationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseReservationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reservationId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseReservationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseReservationRequest copyWith(
          void Function(ReleaseReservationRequest) updates) =>
      super.copyWith((message) => updates(message as ReleaseReservationRequest))
          as ReleaseReservationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseReservationRequest create() => ReleaseReservationRequest._();
  @$core.override
  ReleaseReservationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseReservationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseReservationRequest>(create);
  static ReleaseReservationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reservationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reservationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReservationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReservationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class ReleaseReservationResponse extends $pb.GeneratedMessage {
  factory ReleaseReservationResponse() => create();

  ReleaseReservationResponse._();

  factory ReleaseReservationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseReservationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseReservationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseReservationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseReservationResponse copyWith(
          void Function(ReleaseReservationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ReleaseReservationResponse))
          as ReleaseReservationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseReservationResponse create() => ReleaseReservationResponse._();
  @$core.override
  ReleaseReservationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseReservationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseReservationResponse>(create);
  static ReleaseReservationResponse? _defaultInstance;
}

class SweepLapsedReservationsRequest extends $pb.GeneratedMessage {
  factory SweepLapsedReservationsRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  SweepLapsedReservationsRequest._();

  factory SweepLapsedReservationsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SweepLapsedReservationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SweepLapsedReservationsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepLapsedReservationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepLapsedReservationsRequest copyWith(
          void Function(SweepLapsedReservationsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SweepLapsedReservationsRequest))
          as SweepLapsedReservationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SweepLapsedReservationsRequest create() =>
      SweepLapsedReservationsRequest._();
  @$core.override
  SweepLapsedReservationsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SweepLapsedReservationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SweepLapsedReservationsRequest>(create);
  static SweepLapsedReservationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class SweepLapsedReservationsResponse extends $pb.GeneratedMessage {
  factory SweepLapsedReservationsResponse({
    $core.int? swept,
  }) {
    final result = create();
    if (swept != null) result.swept = swept;
    return result;
  }

  SweepLapsedReservationsResponse._();

  factory SweepLapsedReservationsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SweepLapsedReservationsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SweepLapsedReservationsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'swept')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepLapsedReservationsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepLapsedReservationsResponse copyWith(
          void Function(SweepLapsedReservationsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SweepLapsedReservationsResponse))
          as SweepLapsedReservationsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SweepLapsedReservationsResponse create() =>
      SweepLapsedReservationsResponse._();
  @$core.override
  SweepLapsedReservationsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SweepLapsedReservationsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SweepLapsedReservationsResponse>(
          create);
  static SweepLapsedReservationsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get swept => $_getIZ(0);
  @$pb.TagNumber(1)
  set swept($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSwept() => $_has(0);
  @$pb.TagNumber(1)
  void clearSwept() => $_clearField(1);
}

class IssueUnitRequest extends $pb.GeneratedMessage {
  factory IssueUnitRequest({
    $core.String? componentId,
    $core.String? reservationId,
    $core.String? destination,
    $core.String? issuedTo,
    $core.String? checkUnitNumber,
    $core.String? checkPatientId,
    $core.bool? emergency,
    $core.String? emergencyAuthoriser,
    $core.String? emergencyReason,
  }) {
    final result = create();
    if (componentId != null) result.componentId = componentId;
    if (reservationId != null) result.reservationId = reservationId;
    if (destination != null) result.destination = destination;
    if (issuedTo != null) result.issuedTo = issuedTo;
    if (checkUnitNumber != null) result.checkUnitNumber = checkUnitNumber;
    if (checkPatientId != null) result.checkPatientId = checkPatientId;
    if (emergency != null) result.emergency = emergency;
    if (emergencyAuthoriser != null)
      result.emergencyAuthoriser = emergencyAuthoriser;
    if (emergencyReason != null) result.emergencyReason = emergencyReason;
    return result;
  }

  IssueUnitRequest._();

  factory IssueUnitRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IssueUnitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IssueUnitRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'componentId')
    ..aOS(2, _omitFieldNames ? '' : 'reservationId')
    ..aOS(3, _omitFieldNames ? '' : 'destination')
    ..aOS(4, _omitFieldNames ? '' : 'issuedTo')
    ..aOS(5, _omitFieldNames ? '' : 'checkUnitNumber')
    ..aOS(6, _omitFieldNames ? '' : 'checkPatientId')
    ..aOB(7, _omitFieldNames ? '' : 'emergency')
    ..aOS(8, _omitFieldNames ? '' : 'emergencyAuthoriser')
    ..aOS(9, _omitFieldNames ? '' : 'emergencyReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueUnitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueUnitRequest copyWith(void Function(IssueUnitRequest) updates) =>
      super.copyWith((message) => updates(message as IssueUnitRequest))
          as IssueUnitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IssueUnitRequest create() => IssueUnitRequest._();
  @$core.override
  IssueUnitRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IssueUnitRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IssueUnitRequest>(create);
  static IssueUnitRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get componentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set componentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasComponentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reservationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set reservationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReservationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReservationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get destination => $_getSZ(2);
  @$pb.TagNumber(3)
  set destination($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDestination() => $_has(2);
  @$pb.TagNumber(3)
  void clearDestination() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get issuedTo => $_getSZ(3);
  @$pb.TagNumber(4)
  set issuedTo($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIssuedTo() => $_has(3);
  @$pb.TagNumber(4)
  void clearIssuedTo() => $_clearField(4);

  /// Read at the counter from the unit and the request, and compared against
  /// the record rather than trusted.
  @$pb.TagNumber(5)
  $core.String get checkUnitNumber => $_getSZ(4);
  @$pb.TagNumber(5)
  set checkUnitNumber($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCheckUnitNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearCheckUnitNumber() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get checkPatientId => $_getSZ(5);
  @$pb.TagNumber(6)
  set checkPatientId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCheckPatientId() => $_has(5);
  @$pb.TagNumber(6)
  void clearCheckPatientId() => $_clearField(6);

  /// An uncrossmatched release (SRS-BLD-016). Needs its own permission, a named
  /// senior authoriser and a reason, and it does not reach a quarantined unit.
  @$pb.TagNumber(7)
  $core.bool get emergency => $_getBF(6);
  @$pb.TagNumber(7)
  set emergency($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEmergency() => $_has(6);
  @$pb.TagNumber(7)
  void clearEmergency() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get emergencyAuthoriser => $_getSZ(7);
  @$pb.TagNumber(8)
  set emergencyAuthoriser($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEmergencyAuthoriser() => $_has(7);
  @$pb.TagNumber(8)
  void clearEmergencyAuthoriser() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get emergencyReason => $_getSZ(8);
  @$pb.TagNumber(9)
  set emergencyReason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEmergencyReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearEmergencyReason() => $_clearField(9);
}

class IssueUnitResponse extends $pb.GeneratedMessage {
  factory IssueUnitResponse({
    Issue? issue,
  }) {
    final result = create();
    if (issue != null) result.issue = issue;
    return result;
  }

  IssueUnitResponse._();

  factory IssueUnitResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IssueUnitResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IssueUnitResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Issue>(1, _omitFieldNames ? '' : 'issue', subBuilder: Issue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueUnitResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueUnitResponse copyWith(void Function(IssueUnitResponse) updates) =>
      super.copyWith((message) => updates(message as IssueUnitResponse))
          as IssueUnitResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IssueUnitResponse create() => IssueUnitResponse._();
  @$core.override
  IssueUnitResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IssueUnitResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IssueUnitResponse>(create);
  static IssueUnitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Issue get issue => $_getN(0);
  @$pb.TagNumber(1)
  set issue(Issue value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIssue() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssue() => $_clearField(1);
  @$pb.TagNumber(1)
  Issue ensureIssue() => $_ensure(0);
}

class ReconcileReleaseRequest extends $pb.GeneratedMessage {
  factory ReconcileReleaseRequest({
    $core.String? issueId,
    $core.String? note,
  }) {
    final result = create();
    if (issueId != null) result.issueId = issueId;
    if (note != null) result.note = note;
    return result;
  }

  ReconcileReleaseRequest._();

  factory ReconcileReleaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReconcileReleaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconcileReleaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'issueId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileReleaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileReleaseRequest copyWith(
          void Function(ReconcileReleaseRequest) updates) =>
      super.copyWith((message) => updates(message as ReconcileReleaseRequest))
          as ReconcileReleaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconcileReleaseRequest create() => ReconcileReleaseRequest._();
  @$core.override
  ReconcileReleaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReconcileReleaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconcileReleaseRequest>(create);
  static ReconcileReleaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get issueId => $_getSZ(0);
  @$pb.TagNumber(1)
  set issueId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIssueId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssueId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);
}

class ReconcileReleaseResponse extends $pb.GeneratedMessage {
  factory ReconcileReleaseResponse() => create();

  ReconcileReleaseResponse._();

  factory ReconcileReleaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReconcileReleaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconcileReleaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileReleaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileReleaseResponse copyWith(
          void Function(ReconcileReleaseResponse) updates) =>
      super.copyWith((message) => updates(message as ReconcileReleaseResponse))
          as ReconcileReleaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconcileReleaseResponse create() => ReconcileReleaseResponse._();
  @$core.override
  ReconcileReleaseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReconcileReleaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconcileReleaseResponse>(create);
  static ReconcileReleaseResponse? _defaultInstance;
}

class ListOutstandingReleasesRequest extends $pb.GeneratedMessage {
  factory ListOutstandingReleasesRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListOutstandingReleasesRequest._();

  factory ListOutstandingReleasesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOutstandingReleasesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOutstandingReleasesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutstandingReleasesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutstandingReleasesRequest copyWith(
          void Function(ListOutstandingReleasesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListOutstandingReleasesRequest))
          as ListOutstandingReleasesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOutstandingReleasesRequest create() =>
      ListOutstandingReleasesRequest._();
  @$core.override
  ListOutstandingReleasesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOutstandingReleasesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOutstandingReleasesRequest>(create);
  static ListOutstandingReleasesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListOutstandingReleasesResponse extends $pb.GeneratedMessage {
  factory ListOutstandingReleasesResponse({
    $core.Iterable<Issue>? issues,
  }) {
    final result = create();
    if (issues != null) result.issues.addAll(issues);
    return result;
  }

  ListOutstandingReleasesResponse._();

  factory ListOutstandingReleasesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOutstandingReleasesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOutstandingReleasesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..pPM<Issue>(1, _omitFieldNames ? '' : 'issues', subBuilder: Issue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutstandingReleasesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutstandingReleasesResponse copyWith(
          void Function(ListOutstandingReleasesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListOutstandingReleasesResponse))
          as ListOutstandingReleasesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOutstandingReleasesResponse create() =>
      ListOutstandingReleasesResponse._();
  @$core.override
  ListOutstandingReleasesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOutstandingReleasesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOutstandingReleasesResponse>(
          create);
  static ListOutstandingReleasesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Issue> get issues => $_getList(0);
}

/// The check made at the patient's side (SRS-BLD-010).
///
/// Its own message, carried by both RPCs below, because the two take exactly
/// the same input: verifying and starting differ in what they do with the
/// result, never in what is checked. Two field lists would drift.
class BedsideCheck extends $pb.GeneratedMessage {
  factory BedsideCheck({
    $core.String? unitNumber,
    $core.String? patientId,
    BloodGroup? patientGroup,
    BloodGroup? unitGroup,
    $core.String? checkedWith,
    $core.String? encounterId,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? baseline,
  }) {
    final result = create();
    if (unitNumber != null) result.unitNumber = unitNumber;
    if (patientId != null) result.patientId = patientId;
    if (patientGroup != null) result.patientGroup = patientGroup;
    if (unitGroup != null) result.unitGroup = unitGroup;
    if (checkedWith != null) result.checkedWith = checkedWith;
    if (encounterId != null) result.encounterId = encounterId;
    if (baseline != null) result.baseline.addEntries(baseline);
    return result;
  }

  BedsideCheck._();

  factory BedsideCheck.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BedsideCheck.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BedsideCheck',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitNumber')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOM<BloodGroup>(3, _omitFieldNames ? '' : 'patientGroup',
        subBuilder: BloodGroup.create)
    ..aOM<BloodGroup>(4, _omitFieldNames ? '' : 'unitGroup',
        subBuilder: BloodGroup.create)
    ..aOS(5, _omitFieldNames ? '' : 'checkedWith')
    ..aOS(6, _omitFieldNames ? '' : 'encounterId')
    ..m<$core.String, $core.double>(7, _omitFieldNames ? '' : 'baseline',
        entryClassName: 'BedsideCheck.BaselineEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('healthcare.bloodbank.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BedsideCheck clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BedsideCheck copyWith(void Function(BedsideCheck) updates) =>
      super.copyWith((message) => updates(message as BedsideCheck))
          as BedsideCheck;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BedsideCheck create() => BedsideCheck._();
  @$core.override
  BedsideCheck createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BedsideCheck getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BedsideCheck>(create);
  static BedsideCheck? _defaultInstance;

  /// As read aloud from the unit and the wristband.
  @$pb.TagNumber(1)
  $core.String get unitNumber => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitNumber($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  /// As read from the two labels, which is a different check from the one the
  /// database can make: it catches a label that does not match the record.
  @$pb.TagNumber(3)
  BloodGroup get patientGroup => $_getN(2);
  @$pb.TagNumber(3)
  set patientGroup(BloodGroup value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPatientGroup() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatientGroup() => $_clearField(3);
  @$pb.TagNumber(3)
  BloodGroup ensurePatientGroup() => $_ensure(2);

  @$pb.TagNumber(4)
  BloodGroup get unitGroup => $_getN(3);
  @$pb.TagNumber(4)
  set unitGroup(BloodGroup value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUnitGroup() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnitGroup() => $_clearField(4);
  @$pb.TagNumber(4)
  BloodGroup ensureUnitGroup() => $_ensure(3);

  /// The second person. The caller is the first.
  @$pb.TagNumber(5)
  $core.String get checkedWith => $_getSZ(4);
  @$pb.TagNumber(5)
  set checkedWith($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCheckedWith() => $_has(4);
  @$pb.TagNumber(5)
  void clearCheckedWith() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get encounterId => $_getSZ(5);
  @$pb.TagNumber(6)
  set encounterId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEncounterId() => $_has(5);
  @$pb.TagNumber(6)
  void clearEncounterId() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $core.double> get baseline => $_getMap(6);
}

class VerifyBedsideRequest extends $pb.GeneratedMessage {
  factory VerifyBedsideRequest({
    BedsideCheck? check_1,
  }) {
    final result = create();
    if (check_1 != null) result.check_1 = check_1;
    return result;
  }

  VerifyBedsideRequest._();

  factory VerifyBedsideRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyBedsideRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyBedsideRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<BedsideCheck>(1, _omitFieldNames ? '' : 'check',
        subBuilder: BedsideCheck.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyBedsideRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyBedsideRequest copyWith(void Function(VerifyBedsideRequest) updates) =>
      super.copyWith((message) => updates(message as VerifyBedsideRequest))
          as VerifyBedsideRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyBedsideRequest create() => VerifyBedsideRequest._();
  @$core.override
  VerifyBedsideRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyBedsideRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyBedsideRequest>(create);
  static VerifyBedsideRequest? _defaultInstance;

  @$pb.TagNumber(1)
  BedsideCheck get check_1 => $_getN(0);
  @$pb.TagNumber(1)
  set check_1(BedsideCheck value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCheck_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheck_1() => $_clearField(1);
  @$pb.TagNumber(1)
  BedsideCheck ensureCheck_1() => $_ensure(0);
}

class VerifyBedsideResponse extends $pb.GeneratedMessage {
  factory VerifyBedsideResponse({
    $core.bool? passed,
    $core.Iterable<BedsideRefusal>? refusals,
    $core.Iterable<$core.String>? explanations,
  }) {
    final result = create();
    if (passed != null) result.passed = passed;
    if (refusals != null) result.refusals.addAll(refusals);
    if (explanations != null) result.explanations.addAll(explanations);
    return result;
  }

  VerifyBedsideResponse._();

  factory VerifyBedsideResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyBedsideResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyBedsideResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'passed')
    ..pc<BedsideRefusal>(
        2, _omitFieldNames ? '' : 'refusals', $pb.PbFieldType.KE,
        valueOf: BedsideRefusal.valueOf,
        enumValues: BedsideRefusal.values,
        defaultEnumValue: BedsideRefusal.BEDSIDE_REFUSAL_UNSPECIFIED)
    ..pPS(3, _omitFieldNames ? '' : 'explanations')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyBedsideResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyBedsideResponse copyWith(
          void Function(VerifyBedsideResponse) updates) =>
      super.copyWith((message) => updates(message as VerifyBedsideResponse))
          as VerifyBedsideResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyBedsideResponse create() => VerifyBedsideResponse._();
  @$core.override
  VerifyBedsideResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyBedsideResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyBedsideResponse>(create);
  static VerifyBedsideResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get passed => $_getBF(0);
  @$pb.TagNumber(1)
  set passed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPassed() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassed() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<BedsideRefusal> get refusals => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get explanations => $_getList(2);
}

class StartTransfusionRequest extends $pb.GeneratedMessage {
  factory StartTransfusionRequest({
    BedsideCheck? check_1,
  }) {
    final result = create();
    if (check_1 != null) result.check_1 = check_1;
    return result;
  }

  StartTransfusionRequest._();

  factory StartTransfusionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartTransfusionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartTransfusionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<BedsideCheck>(1, _omitFieldNames ? '' : 'check',
        subBuilder: BedsideCheck.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartTransfusionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartTransfusionRequest copyWith(
          void Function(StartTransfusionRequest) updates) =>
      super.copyWith((message) => updates(message as StartTransfusionRequest))
          as StartTransfusionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartTransfusionRequest create() => StartTransfusionRequest._();
  @$core.override
  StartTransfusionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartTransfusionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartTransfusionRequest>(create);
  static StartTransfusionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  BedsideCheck get check_1 => $_getN(0);
  @$pb.TagNumber(1)
  set check_1(BedsideCheck value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCheck_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheck_1() => $_clearField(1);
  @$pb.TagNumber(1)
  BedsideCheck ensureCheck_1() => $_ensure(0);
}

class StartTransfusionResponse extends $pb.GeneratedMessage {
  factory StartTransfusionResponse({
    Episode? episode,
  }) {
    final result = create();
    if (episode != null) result.episode = episode;
    return result;
  }

  StartTransfusionResponse._();

  factory StartTransfusionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartTransfusionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartTransfusionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Episode>(1, _omitFieldNames ? '' : 'episode',
        subBuilder: Episode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartTransfusionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartTransfusionResponse copyWith(
          void Function(StartTransfusionResponse) updates) =>
      super.copyWith((message) => updates(message as StartTransfusionResponse))
          as StartTransfusionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartTransfusionResponse create() => StartTransfusionResponse._();
  @$core.override
  StartTransfusionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartTransfusionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartTransfusionResponse>(create);
  static StartTransfusionResponse? _defaultInstance;

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

class ObserveRequest extends $pb.GeneratedMessage {
  factory ObserveRequest({
    $core.String? episodeId,
    $core.String? timing,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? values,
    $core.String? note,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (timing != null) result.timing = timing;
    if (values != null) result.values.addEntries(values);
    if (note != null) result.note = note;
    return result;
  }

  ObserveRequest._();

  factory ObserveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ObserveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObserveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'timing')
    ..m<$core.String, $core.double>(3, _omitFieldNames ? '' : 'values',
        entryClassName: 'ObserveRequest.ValuesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('healthcare.bloodbank.v1'))
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObserveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObserveRequest copyWith(void Function(ObserveRequest) updates) =>
      super.copyWith((message) => updates(message as ObserveRequest))
          as ObserveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObserveRequest create() => ObserveRequest._();
  @$core.override
  ObserveRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ObserveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ObserveRequest>(create);
  static ObserveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get timing => $_getSZ(1);
  @$pb.TagNumber(2)
  set timing($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTiming() => $_has(1);
  @$pb.TagNumber(2)
  void clearTiming() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.double> get values => $_getMap(2);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);
}

class ObserveResponse extends $pb.GeneratedMessage {
  factory ObserveResponse({
    Observation? observation,
  }) {
    final result = create();
    if (observation != null) result.observation = observation;
    return result;
  }

  ObserveResponse._();

  factory ObserveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ObserveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObserveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Observation>(1, _omitFieldNames ? '' : 'observation',
        subBuilder: Observation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObserveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObserveResponse copyWith(void Function(ObserveResponse) updates) =>
      super.copyWith((message) => updates(message as ObserveResponse))
          as ObserveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObserveResponse create() => ObserveResponse._();
  @$core.override
  ObserveResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ObserveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ObserveResponse>(create);
  static ObserveResponse? _defaultInstance;

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

class EndTransfusionRequest extends $pb.GeneratedMessage {
  factory EndTransfusionRequest({
    $core.String? episodeId,
    $core.int? volumeGivenMl,
    $core.String? stopReason,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (volumeGivenMl != null) result.volumeGivenMl = volumeGivenMl;
    if (stopReason != null) result.stopReason = stopReason;
    return result;
  }

  EndTransfusionRequest._();

  factory EndTransfusionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndTransfusionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndTransfusionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aI(2, _omitFieldNames ? '' : 'volumeGivenMl')
    ..aOS(3, _omitFieldNames ? '' : 'stopReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndTransfusionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndTransfusionRequest copyWith(
          void Function(EndTransfusionRequest) updates) =>
      super.copyWith((message) => updates(message as EndTransfusionRequest))
          as EndTransfusionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndTransfusionRequest create() => EndTransfusionRequest._();
  @$core.override
  EndTransfusionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndTransfusionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndTransfusionRequest>(create);
  static EndTransfusionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get volumeGivenMl => $_getIZ(1);
  @$pb.TagNumber(2)
  set volumeGivenMl($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVolumeGivenMl() => $_has(1);
  @$pb.TagNumber(2)
  void clearVolumeGivenMl() => $_clearField(2);

  /// A reason means it was abandoned; its absence means it ran to the end.
  @$pb.TagNumber(3)
  $core.String get stopReason => $_getSZ(2);
  @$pb.TagNumber(3)
  set stopReason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStopReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearStopReason() => $_clearField(3);
}

class EndTransfusionResponse extends $pb.GeneratedMessage {
  factory EndTransfusionResponse({
    Episode? episode,
  }) {
    final result = create();
    if (episode != null) result.episode = episode;
    return result;
  }

  EndTransfusionResponse._();

  factory EndTransfusionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndTransfusionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndTransfusionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Episode>(1, _omitFieldNames ? '' : 'episode',
        subBuilder: Episode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndTransfusionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndTransfusionResponse copyWith(
          void Function(EndTransfusionResponse) updates) =>
      super.copyWith((message) => updates(message as EndTransfusionResponse))
          as EndTransfusionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndTransfusionResponse create() => EndTransfusionResponse._();
  @$core.override
  EndTransfusionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndTransfusionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndTransfusionResponse>(create);
  static EndTransfusionResponse? _defaultInstance;

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

class GetEpisodeRequest extends $pb.GeneratedMessage {
  factory GetEpisodeRequest({
    $core.String? episodeId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    return result;
  }

  GetEpisodeRequest._();

  factory GetEpisodeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetEpisodeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetEpisodeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEpisodeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEpisodeRequest copyWith(void Function(GetEpisodeRequest) updates) =>
      super.copyWith((message) => updates(message as GetEpisodeRequest))
          as GetEpisodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetEpisodeRequest create() => GetEpisodeRequest._();
  @$core.override
  GetEpisodeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetEpisodeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetEpisodeRequest>(create);
  static GetEpisodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);
}

class GetEpisodeResponse extends $pb.GeneratedMessage {
  factory GetEpisodeResponse({
    Episode? episode,
    $core.Iterable<$core.String>? missingObservations,
  }) {
    final result = create();
    if (episode != null) result.episode = episode;
    if (missingObservations != null)
      result.missingObservations.addAll(missingObservations);
    return result;
  }

  GetEpisodeResponse._();

  factory GetEpisodeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetEpisodeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetEpisodeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Episode>(1, _omitFieldNames ? '' : 'episode',
        subBuilder: Episode.create)
    ..pPS(2, _omitFieldNames ? '' : 'missingObservations')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEpisodeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEpisodeResponse copyWith(void Function(GetEpisodeResponse) updates) =>
      super.copyWith((message) => updates(message as GetEpisodeResponse))
          as GetEpisodeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetEpisodeResponse create() => GetEpisodeResponse._();
  @$core.override
  GetEpisodeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetEpisodeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetEpisodeResponse>(create);
  static GetEpisodeResponse? _defaultInstance;

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

  /// The protocol sets this transfusion has not had. Named rather than
  /// blocking: a nurse who has not taken the fifteen-minute set is a nurse who
  /// is fifteen minutes in.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get missingObservations => $_getList(1);
}

class ListPatientTransfusionsRequest extends $pb.GeneratedMessage {
  factory ListPatientTransfusionsRequest({
    $core.String? patientId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListPatientTransfusionsRequest._();

  factory ListPatientTransfusionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPatientTransfusionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPatientTransfusionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPatientTransfusionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPatientTransfusionsRequest copyWith(
          void Function(ListPatientTransfusionsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListPatientTransfusionsRequest))
          as ListPatientTransfusionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPatientTransfusionsRequest create() =>
      ListPatientTransfusionsRequest._();
  @$core.override
  ListPatientTransfusionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPatientTransfusionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPatientTransfusionsRequest>(create);
  static ListPatientTransfusionsRequest? _defaultInstance;

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

class ListPatientTransfusionsResponse extends $pb.GeneratedMessage {
  factory ListPatientTransfusionsResponse({
    $core.Iterable<Episode>? episodes,
  }) {
    final result = create();
    if (episodes != null) result.episodes.addAll(episodes);
    return result;
  }

  ListPatientTransfusionsResponse._();

  factory ListPatientTransfusionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPatientTransfusionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPatientTransfusionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..pPM<Episode>(1, _omitFieldNames ? '' : 'episodes',
        subBuilder: Episode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPatientTransfusionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPatientTransfusionsResponse copyWith(
          void Function(ListPatientTransfusionsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListPatientTransfusionsResponse))
          as ListPatientTransfusionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPatientTransfusionsResponse create() =>
      ListPatientTransfusionsResponse._();
  @$core.override
  ListPatientTransfusionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPatientTransfusionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPatientTransfusionsResponse>(
          create);
  static ListPatientTransfusionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Episode> get episodes => $_getList(0);
}

class ReportReactionRequest extends $pb.GeneratedMessage {
  factory ReportReactionRequest({
    $core.String? episodeId,
    $core.String? componentId,
    $core.String? patientId,
    ReactionSeverity? severity,
    $core.Iterable<$core.String>? features,
    $core.String? note,
    $core.String? actionTaken,
    $core.int? volumeGivenMl,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (componentId != null) result.componentId = componentId;
    if (patientId != null) result.patientId = patientId;
    if (severity != null) result.severity = severity;
    if (features != null) result.features.addAll(features);
    if (note != null) result.note = note;
    if (actionTaken != null) result.actionTaken = actionTaken;
    if (volumeGivenMl != null) result.volumeGivenMl = volumeGivenMl;
    return result;
  }

  ReportReactionRequest._();

  factory ReportReactionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportReactionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportReactionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'componentId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aE<ReactionSeverity>(4, _omitFieldNames ? '' : 'severity',
        enumValues: ReactionSeverity.values)
    ..pPS(5, _omitFieldNames ? '' : 'features')
    ..aOS(6, _omitFieldNames ? '' : 'note')
    ..aOS(7, _omitFieldNames ? '' : 'actionTaken')
    ..aI(8, _omitFieldNames ? '' : 'volumeGivenMl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportReactionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportReactionRequest copyWith(
          void Function(ReportReactionRequest) updates) =>
      super.copyWith((message) => updates(message as ReportReactionRequest))
          as ReportReactionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportReactionRequest create() => ReportReactionRequest._();
  @$core.override
  ReportReactionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReportReactionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportReactionRequest>(create);
  static ReportReactionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get componentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set componentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasComponentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearComponentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get patientId => $_getSZ(2);
  @$pb.TagNumber(3)
  set patientId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPatientId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatientId() => $_clearField(3);

  @$pb.TagNumber(4)
  ReactionSeverity get severity => $_getN(3);
  @$pb.TagNumber(4)
  set severity(ReactionSeverity value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSeverity() => $_has(3);
  @$pb.TagNumber(4)
  void clearSeverity() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get features => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get note => $_getSZ(5);
  @$pb.TagNumber(6)
  set note($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNote() => $_has(5);
  @$pb.TagNumber(6)
  void clearNote() => $_clearField(6);

  /// Required. What was done about it at the bedside.
  @$pb.TagNumber(7)
  $core.String get actionTaken => $_getSZ(6);
  @$pb.TagNumber(7)
  set actionTaken($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasActionTaken() => $_has(6);
  @$pb.TagNumber(7)
  void clearActionTaken() => $_clearField(7);

  /// What the patient received before the transfusion was stopped. Reporting a
  /// reaction stops the transfusion it was reported against, so the volume is
  /// recorded here rather than in a second call.
  @$pb.TagNumber(8)
  $core.int get volumeGivenMl => $_getIZ(7);
  @$pb.TagNumber(8)
  set volumeGivenMl($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVolumeGivenMl() => $_has(7);
  @$pb.TagNumber(8)
  void clearVolumeGivenMl() => $_clearField(8);
}

class ReportReactionResponse extends $pb.GeneratedMessage {
  factory ReportReactionResponse({
    Reaction? reaction,
  }) {
    final result = create();
    if (reaction != null) result.reaction = reaction;
    return result;
  }

  ReportReactionResponse._();

  factory ReportReactionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportReactionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportReactionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Reaction>(1, _omitFieldNames ? '' : 'reaction',
        subBuilder: Reaction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportReactionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportReactionResponse copyWith(
          void Function(ReportReactionResponse) updates) =>
      super.copyWith((message) => updates(message as ReportReactionResponse))
          as ReportReactionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportReactionResponse create() => ReportReactionResponse._();
  @$core.override
  ReportReactionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReportReactionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportReactionResponse>(create);
  static ReportReactionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Reaction get reaction => $_getN(0);
  @$pb.TagNumber(1)
  set reaction(Reaction value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReaction() => $_has(0);
  @$pb.TagNumber(1)
  void clearReaction() => $_clearField(1);
  @$pb.TagNumber(1)
  Reaction ensureReaction() => $_ensure(0);
}

class ConcludeInvestigationRequest extends $pb.GeneratedMessage {
  factory ConcludeInvestigationRequest({
    $core.String? reactionId,
    $core.String? classification,
    $core.String? conclusion,
    $core.bool? unitReturned,
  }) {
    final result = create();
    if (reactionId != null) result.reactionId = reactionId;
    if (classification != null) result.classification = classification;
    if (conclusion != null) result.conclusion = conclusion;
    if (unitReturned != null) result.unitReturned = unitReturned;
    return result;
  }

  ConcludeInvestigationRequest._();

  factory ConcludeInvestigationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConcludeInvestigationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConcludeInvestigationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reactionId')
    ..aOS(2, _omitFieldNames ? '' : 'classification')
    ..aOS(3, _omitFieldNames ? '' : 'conclusion')
    ..aOB(4, _omitFieldNames ? '' : 'unitReturned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConcludeInvestigationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConcludeInvestigationRequest copyWith(
          void Function(ConcludeInvestigationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ConcludeInvestigationRequest))
          as ConcludeInvestigationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConcludeInvestigationRequest create() =>
      ConcludeInvestigationRequest._();
  @$core.override
  ConcludeInvestigationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConcludeInvestigationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConcludeInvestigationRequest>(create);
  static ConcludeInvestigationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reactionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reactionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReactionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReactionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get classification => $_getSZ(1);
  @$pb.TagNumber(2)
  set classification($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClassification() => $_has(1);
  @$pb.TagNumber(2)
  void clearClassification() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get conclusion => $_getSZ(2);
  @$pb.TagNumber(3)
  set conclusion($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConclusion() => $_has(2);
  @$pb.TagNumber(3)
  void clearConclusion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get unitReturned => $_getBF(3);
  @$pb.TagNumber(4)
  set unitReturned($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnitReturned() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnitReturned() => $_clearField(4);
}

class ConcludeInvestigationResponse extends $pb.GeneratedMessage {
  factory ConcludeInvestigationResponse({
    Reaction? reaction,
  }) {
    final result = create();
    if (reaction != null) result.reaction = reaction;
    return result;
  }

  ConcludeInvestigationResponse._();

  factory ConcludeInvestigationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConcludeInvestigationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConcludeInvestigationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Reaction>(1, _omitFieldNames ? '' : 'reaction',
        subBuilder: Reaction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConcludeInvestigationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConcludeInvestigationResponse copyWith(
          void Function(ConcludeInvestigationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ConcludeInvestigationResponse))
          as ConcludeInvestigationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConcludeInvestigationResponse create() =>
      ConcludeInvestigationResponse._();
  @$core.override
  ConcludeInvestigationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConcludeInvestigationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConcludeInvestigationResponse>(create);
  static ConcludeInvestigationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Reaction get reaction => $_getN(0);
  @$pb.TagNumber(1)
  set reaction(Reaction value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReaction() => $_has(0);
  @$pb.TagNumber(1)
  void clearReaction() => $_clearField(1);
  @$pb.TagNumber(1)
  Reaction ensureReaction() => $_ensure(0);
}

class ListOpenInvestigationsRequest extends $pb.GeneratedMessage {
  factory ListOpenInvestigationsRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListOpenInvestigationsRequest._();

  factory ListOpenInvestigationsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOpenInvestigationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOpenInvestigationsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOpenInvestigationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOpenInvestigationsRequest copyWith(
          void Function(ListOpenInvestigationsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListOpenInvestigationsRequest))
          as ListOpenInvestigationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOpenInvestigationsRequest create() =>
      ListOpenInvestigationsRequest._();
  @$core.override
  ListOpenInvestigationsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOpenInvestigationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOpenInvestigationsRequest>(create);
  static ListOpenInvestigationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListOpenInvestigationsResponse extends $pb.GeneratedMessage {
  factory ListOpenInvestigationsResponse({
    $core.Iterable<Reaction>? reactions,
  }) {
    final result = create();
    if (reactions != null) result.reactions.addAll(reactions);
    return result;
  }

  ListOpenInvestigationsResponse._();

  factory ListOpenInvestigationsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOpenInvestigationsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOpenInvestigationsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..pPM<Reaction>(1, _omitFieldNames ? '' : 'reactions',
        subBuilder: Reaction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOpenInvestigationsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOpenInvestigationsResponse copyWith(
          void Function(ListOpenInvestigationsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListOpenInvestigationsResponse))
          as ListOpenInvestigationsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOpenInvestigationsResponse create() =>
      ListOpenInvestigationsResponse._();
  @$core.override
  ListOpenInvestigationsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOpenInvestigationsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOpenInvestigationsResponse>(create);
  static ListOpenInvestigationsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Reaction> get reactions => $_getList(0);
}

class TraceUnitRequest extends $pb.GeneratedMessage {
  factory TraceUnitRequest({
    $core.String? componentId,
  }) {
    final result = create();
    if (componentId != null) result.componentId = componentId;
    return result;
  }

  TraceUnitRequest._();

  factory TraceUnitRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TraceUnitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TraceUnitRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'componentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceUnitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceUnitRequest copyWith(void Function(TraceUnitRequest) updates) =>
      super.copyWith((message) => updates(message as TraceUnitRequest))
          as TraceUnitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TraceUnitRequest create() => TraceUnitRequest._();
  @$core.override
  TraceUnitRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TraceUnitRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TraceUnitRequest>(create);
  static TraceUnitRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get componentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set componentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasComponentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponentId() => $_clearField(1);
}

class TraceUnitResponse extends $pb.GeneratedMessage {
  factory TraceUnitResponse({
    Chain? chain,
  }) {
    final result = create();
    if (chain != null) result.chain = chain;
    return result;
  }

  TraceUnitResponse._();

  factory TraceUnitResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TraceUnitResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TraceUnitResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<Chain>(1, _omitFieldNames ? '' : 'chain', subBuilder: Chain.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceUnitResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceUnitResponse copyWith(void Function(TraceUnitResponse) updates) =>
      super.copyWith((message) => updates(message as TraceUnitResponse))
          as TraceUnitResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TraceUnitResponse create() => TraceUnitResponse._();
  @$core.override
  TraceUnitResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TraceUnitResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TraceUnitResponse>(create);
  static TraceUnitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Chain get chain => $_getN(0);
  @$pb.TagNumber(1)
  set chain(Chain value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChain() => $_has(0);
  @$pb.TagNumber(1)
  void clearChain() => $_clearField(1);
  @$pb.TagNumber(1)
  Chain ensureChain() => $_ensure(0);
}

class LookBackRequest extends $pb.GeneratedMessage {
  factory LookBackRequest({
    $core.String? donorId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (donorId != null) result.donorId = donorId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  LookBackRequest._();

  factory LookBackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LookBackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LookBackRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'donorId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LookBackRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LookBackRequest copyWith(void Function(LookBackRequest) updates) =>
      super.copyWith((message) => updates(message as LookBackRequest))
          as LookBackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LookBackRequest create() => LookBackRequest._();
  @$core.override
  LookBackRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LookBackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LookBackRequest>(create);
  static LookBackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get donorId => $_getSZ(0);
  @$pb.TagNumber(1)
  set donorId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDonorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDonorId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class LookBackResponse extends $pb.GeneratedMessage {
  factory LookBackResponse({
    $core.Iterable<Recipient>? recipients,
  }) {
    final result = create();
    if (recipients != null) result.recipients.addAll(recipients);
    return result;
  }

  LookBackResponse._();

  factory LookBackResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LookBackResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LookBackResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..pPM<Recipient>(1, _omitFieldNames ? '' : 'recipients',
        subBuilder: Recipient.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LookBackResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LookBackResponse copyWith(void Function(LookBackResponse) updates) =>
      super.copyWith((message) => updates(message as LookBackResponse))
          as LookBackResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LookBackResponse create() => LookBackResponse._();
  @$core.override
  LookBackResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LookBackResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LookBackResponse>(create);
  static LookBackResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Recipient> get recipients => $_getList(0);
}

class SetThresholdRequest extends $pb.GeneratedMessage {
  factory SetThresholdRequest({
    $core.String? facilityId,
    StockThreshold? threshold,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (threshold != null) result.threshold = threshold;
    return result;
  }

  SetThresholdRequest._();

  factory SetThresholdRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetThresholdRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetThresholdRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOM<StockThreshold>(2, _omitFieldNames ? '' : 'threshold',
        subBuilder: StockThreshold.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetThresholdRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetThresholdRequest copyWith(void Function(SetThresholdRequest) updates) =>
      super.copyWith((message) => updates(message as SetThresholdRequest))
          as SetThresholdRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetThresholdRequest create() => SetThresholdRequest._();
  @$core.override
  SetThresholdRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetThresholdRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetThresholdRequest>(create);
  static SetThresholdRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  StockThreshold get threshold => $_getN(1);
  @$pb.TagNumber(2)
  set threshold(StockThreshold value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasThreshold() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreshold() => $_clearField(2);
  @$pb.TagNumber(2)
  StockThreshold ensureThreshold() => $_ensure(1);
}

class SetThresholdResponse extends $pb.GeneratedMessage {
  factory SetThresholdResponse() => create();

  SetThresholdResponse._();

  factory SetThresholdResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetThresholdResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetThresholdResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetThresholdResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetThresholdResponse copyWith(void Function(SetThresholdResponse) updates) =>
      super.copyWith((message) => updates(message as SetThresholdResponse))
          as SetThresholdResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetThresholdResponse create() => SetThresholdResponse._();
  @$core.override
  SetThresholdResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetThresholdResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetThresholdResponse>(create);
  static SetThresholdResponse? _defaultInstance;
}

class GetStockRequest extends $pb.GeneratedMessage {
  factory GetStockRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  GetStockRequest._();

  factory GetStockRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetStockRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStockRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStockRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStockRequest copyWith(void Function(GetStockRequest) updates) =>
      super.copyWith((message) => updates(message as GetStockRequest))
          as GetStockRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStockRequest create() => GetStockRequest._();
  @$core.override
  GetStockRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetStockRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetStockRequest>(create);
  static GetStockRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

class GetStockResponse extends $pb.GeneratedMessage {
  factory GetStockResponse({
    $core.Iterable<StockLevel>? levels,
    $core.Iterable<StockAlert>? alerts,
  }) {
    final result = create();
    if (levels != null) result.levels.addAll(levels);
    if (alerts != null) result.alerts.addAll(alerts);
    return result;
  }

  GetStockResponse._();

  factory GetStockResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetStockResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStockResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..pPM<StockLevel>(1, _omitFieldNames ? '' : 'levels',
        subBuilder: StockLevel.create)
    ..pPM<StockAlert>(2, _omitFieldNames ? '' : 'alerts',
        subBuilder: StockAlert.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStockResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStockResponse copyWith(void Function(GetStockResponse) updates) =>
      super.copyWith((message) => updates(message as GetStockResponse))
          as GetStockResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStockResponse create() => GetStockResponse._();
  @$core.override
  GetStockResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetStockResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetStockResponse>(create);
  static GetStockResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StockLevel> get levels => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<StockAlert> get alerts => $_getList(1);
}

class GetUtilisationRequest extends $pb.GeneratedMessage {
  factory GetUtilisationRequest({
    $0.Timestamp? periodStart,
    $0.Timestamp? periodEnd,
  }) {
    final result = create();
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
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
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'periodStart',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'periodEnd',
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
  $0.Timestamp get periodStart => $_getN(0);
  @$pb.TagNumber(1)
  set periodStart($0.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPeriodStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeriodStart() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensurePeriodStart() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Timestamp get periodEnd => $_getN(1);
  @$pb.TagNumber(2)
  set periodEnd($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriodEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriodEnd() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensurePeriodEnd() => $_ensure(1);
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
          _omitMessageNames ? '' : 'healthcare.bloodbank.v1'),
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

/// Blood bank and transfusion medicine (SRS-BLD-001 … 017).
class BloodBankServiceApi {
  final $pb.RpcClient _client;

  BloodBankServiceApi(this._client);

  /// SRS-BLD-001, SRS-BLD-002.
  $async.Future<RegisterDonorResponse> registerDonor(
          $pb.ClientContext? ctx, RegisterDonorRequest request) =>
      _client.invoke<RegisterDonorResponse>(ctx, 'BloodBankService',
          'RegisterDonor', request, RegisterDonorResponse());
  $async.Future<GetDonorResponse> getDonor(
          $pb.ClientContext? ctx, GetDonorRequest request) =>
      _client.invoke<GetDonorResponse>(
          ctx, 'BloodBankService', 'GetDonor', request, GetDonorResponse());
  $async.Future<DeferDonorResponse> deferDonor(
          $pb.ClientContext? ctx, DeferDonorRequest request) =>
      _client.invoke<DeferDonorResponse>(
          ctx, 'BloodBankService', 'DeferDonor', request, DeferDonorResponse());

  /// Lifts a temporary deferral only. Reversing a permanent one is a medical
  /// decision about somebody told they could never give again.
  $async.Future<ReinstateDonorResponse> reinstateDonor(
          $pb.ClientContext? ctx, ReinstateDonorRequest request) =>
      _client.invoke<ReinstateDonorResponse>(ctx, 'BloodBankService',
          'ReinstateDonor', request, ReinstateDonorResponse());
  $async.Future<ListDeferredDonorsResponse> listDeferredDonors(
          $pb.ClientContext? ctx, ListDeferredDonorsRequest request) =>
      _client.invoke<ListDeferredDonorsResponse>(ctx, 'BloodBankService',
          'ListDeferredDonors', request, ListDeferredDonorsResponse());
  $async.Future<ScreenDonorResponse> screenDonor(
          $pb.ClientContext? ctx, ScreenDonorRequest request) =>
      _client.invoke<ScreenDonorResponse>(ctx, 'BloodBankService',
          'ScreenDonor', request, ScreenDonorResponse());

  /// SRS-BLD-003.
  $async.Future<CollectResponse> collect(
          $pb.ClientContext? ctx, CollectRequest request) =>
      _client.invoke<CollectResponse>(
          ctx, 'BloodBankService', 'Collect', request, CollectResponse());

  /// SRS-BLD-004. A reactive result quarantines every component already made
  /// from the collection.
  $async.Future<RecordTestResponse> recordTest(
          $pb.ClientContext? ctx, RecordTestRequest request) =>
      _client.invoke<RecordTestResponse>(
          ctx, 'BloodBankService', 'RecordTest', request, RecordTestResponse());
  $async.Future<GetReleaseDecisionResponse> getReleaseDecision(
          $pb.ClientContext? ctx, GetReleaseDecisionRequest request) =>
      _client.invoke<GetReleaseDecisionResponse>(ctx, 'BloodBankService',
          'GetReleaseDecision', request, GetReleaseDecisionResponse());
  $async.Future<ReleaseComponentsResponse> releaseComponents(
          $pb.ClientContext? ctx, ReleaseComponentsRequest request) =>
      _client.invoke<ReleaseComponentsResponse>(ctx, 'BloodBankService',
          'ReleaseComponents', request, ReleaseComponentsResponse());

  /// SRS-BLD-005, SRS-BLD-013.
  $async.Future<AddComponentResponse> addComponent(
          $pb.ClientContext? ctx, AddComponentRequest request) =>
      _client.invoke<AddComponentResponse>(ctx, 'BloodBankService',
          'AddComponent', request, AddComponentResponse());
  $async.Future<GetComponentResponse> getComponent(
          $pb.ClientContext? ctx, GetComponentRequest request) =>
      _client.invoke<GetComponentResponse>(ctx, 'BloodBankService',
          'GetComponent', request, GetComponentResponse());
  $async.Future<DiscardComponentResponse> discardComponent(
          $pb.ClientContext? ctx, DiscardComponentRequest request) =>
      _client.invoke<DiscardComponentResponse>(ctx, 'BloodBankService',
          'DiscardComponent', request, DiscardComponentResponse());

  /// SRS-BLD-006.
  $async.Future<PlaceRequestResponse> placeRequest(
          $pb.ClientContext? ctx, PlaceRequestRequest request) =>
      _client.invoke<PlaceRequestResponse>(ctx, 'BloodBankService',
          'PlaceRequest', request, PlaceRequestResponse());
  $async.Future<GetWorklistResponse> getWorklist(
          $pb.ClientContext? ctx, GetWorklistRequest request) =>
      _client.invoke<GetWorklistResponse>(ctx, 'BloodBankService',
          'GetWorklist', request, GetWorklistResponse());
  $async.Future<ListPatientRequestsResponse> listPatientRequests(
          $pb.ClientContext? ctx, ListPatientRequestsRequest request) =>
      _client.invoke<ListPatientRequestsResponse>(ctx, 'BloodBankService',
          'ListPatientRequests', request, ListPatientRequestsResponse());

  /// SRS-BLD-007, SRS-BLD-008.
  $async.Future<GroupPatientResponse> groupPatient(
          $pb.ClientContext? ctx, GroupPatientRequest request) =>
      _client.invoke<GroupPatientResponse>(ctx, 'BloodBankService',
          'GroupPatient', request, GroupPatientResponse());
  $async.Future<FindCompatibleResponse> findCompatible(
          $pb.ClientContext? ctx, FindCompatibleRequest request) =>
      _client.invoke<FindCompatibleResponse>(ctx, 'BloodBankService',
          'FindCompatible', request, FindCompatibleResponse());
  $async.Future<ReserveResponse> reserve(
          $pb.ClientContext? ctx, ReserveRequest request) =>
      _client.invoke<ReserveResponse>(
          ctx, 'BloodBankService', 'Reserve', request, ReserveResponse());
  $async.Future<ReleaseReservationResponse> releaseReservation(
          $pb.ClientContext? ctx, ReleaseReservationRequest request) =>
      _client.invoke<ReleaseReservationResponse>(ctx, 'BloodBankService',
          'ReleaseReservation', request, ReleaseReservationResponse());
  $async.Future<SweepLapsedReservationsResponse> sweepLapsedReservations(
          $pb.ClientContext? ctx, SweepLapsedReservationsRequest request) =>
      _client.invoke<SweepLapsedReservationsResponse>(
          ctx,
          'BloodBankService',
          'SweepLapsedReservations',
          request,
          SweepLapsedReservationsResponse());

  /// SRS-BLD-009, SRS-BLD-016.
  $async.Future<IssueUnitResponse> issueUnit(
          $pb.ClientContext? ctx, IssueUnitRequest request) =>
      _client.invoke<IssueUnitResponse>(
          ctx, 'BloodBankService', 'IssueUnit', request, IssueUnitResponse());
  $async.Future<ReconcileReleaseResponse> reconcileRelease(
          $pb.ClientContext? ctx, ReconcileReleaseRequest request) =>
      _client.invoke<ReconcileReleaseResponse>(ctx, 'BloodBankService',
          'ReconcileRelease', request, ReconcileReleaseResponse());
  $async.Future<ListOutstandingReleasesResponse> listOutstandingReleases(
          $pb.ClientContext? ctx, ListOutstandingReleasesRequest request) =>
      _client.invoke<ListOutstandingReleasesResponse>(
          ctx,
          'BloodBankService',
          'ListOutstandingReleases',
          request,
          ListOutstandingReleasesResponse());

  /// SRS-BLD-010, SRS-BLD-011. VerifyBedside shows the result before the nurse
  /// commits and records a failure as a critical exception either way;
  /// StartTransfusion re-runs the check from rows read in its own transaction,
  /// so nothing can change in between.
  $async.Future<VerifyBedsideResponse> verifyBedside(
          $pb.ClientContext? ctx, VerifyBedsideRequest request) =>
      _client.invoke<VerifyBedsideResponse>(ctx, 'BloodBankService',
          'VerifyBedside', request, VerifyBedsideResponse());
  $async.Future<StartTransfusionResponse> startTransfusion(
          $pb.ClientContext? ctx, StartTransfusionRequest request) =>
      _client.invoke<StartTransfusionResponse>(ctx, 'BloodBankService',
          'StartTransfusion', request, StartTransfusionResponse());
  $async.Future<ObserveResponse> observe(
          $pb.ClientContext? ctx, ObserveRequest request) =>
      _client.invoke<ObserveResponse>(
          ctx, 'BloodBankService', 'Observe', request, ObserveResponse());
  $async.Future<EndTransfusionResponse> endTransfusion(
          $pb.ClientContext? ctx, EndTransfusionRequest request) =>
      _client.invoke<EndTransfusionResponse>(ctx, 'BloodBankService',
          'EndTransfusion', request, EndTransfusionResponse());
  $async.Future<GetEpisodeResponse> getEpisode(
          $pb.ClientContext? ctx, GetEpisodeRequest request) =>
      _client.invoke<GetEpisodeResponse>(
          ctx, 'BloodBankService', 'GetEpisode', request, GetEpisodeResponse());
  $async.Future<ListPatientTransfusionsResponse> listPatientTransfusions(
          $pb.ClientContext? ctx, ListPatientTransfusionsRequest request) =>
      _client.invoke<ListPatientTransfusionsResponse>(
          ctx,
          'BloodBankService',
          'ListPatientTransfusions',
          request,
          ListPatientTransfusionsResponse());

  /// SRS-BLD-012.
  $async.Future<ReportReactionResponse> reportReaction(
          $pb.ClientContext? ctx, ReportReactionRequest request) =>
      _client.invoke<ReportReactionResponse>(ctx, 'BloodBankService',
          'ReportReaction', request, ReportReactionResponse());
  $async.Future<ConcludeInvestigationResponse> concludeInvestigation(
          $pb.ClientContext? ctx, ConcludeInvestigationRequest request) =>
      _client.invoke<ConcludeInvestigationResponse>(ctx, 'BloodBankService',
          'ConcludeInvestigation', request, ConcludeInvestigationResponse());
  $async.Future<ListOpenInvestigationsResponse> listOpenInvestigations(
          $pb.ClientContext? ctx, ListOpenInvestigationsRequest request) =>
      _client.invoke<ListOpenInvestigationsResponse>(ctx, 'BloodBankService',
          'ListOpenInvestigations', request, ListOpenInvestigationsResponse());

  /// SRS-BLD-014.
  $async.Future<TraceUnitResponse> traceUnit(
          $pb.ClientContext? ctx, TraceUnitRequest request) =>
      _client.invoke<TraceUnitResponse>(
          ctx, 'BloodBankService', 'TraceUnit', request, TraceUnitResponse());
  $async.Future<LookBackResponse> lookBack(
          $pb.ClientContext? ctx, LookBackRequest request) =>
      _client.invoke<LookBackResponse>(
          ctx, 'BloodBankService', 'LookBack', request, LookBackResponse());

  /// SRS-BLD-015, SRS-BLD-017.
  $async.Future<SetThresholdResponse> setThreshold(
          $pb.ClientContext? ctx, SetThresholdRequest request) =>
      _client.invoke<SetThresholdResponse>(ctx, 'BloodBankService',
          'SetThreshold', request, SetThresholdResponse());
  $async.Future<GetStockResponse> getStock(
          $pb.ClientContext? ctx, GetStockRequest request) =>
      _client.invoke<GetStockResponse>(
          ctx, 'BloodBankService', 'GetStock', request, GetStockResponse());
  $async.Future<GetUtilisationResponse> getUtilisation(
          $pb.ClientContext? ctx, GetUtilisationRequest request) =>
      _client.invoke<GetUtilisationResponse>(ctx, 'BloodBankService',
          'GetUtilisation', request, GetUtilisationResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
