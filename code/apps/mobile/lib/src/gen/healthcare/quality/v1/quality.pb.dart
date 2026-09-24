// This is a generated file - do not edit.
//
// Generated from healthcare/quality/v1/quality.proto.

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

import 'quality.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'quality.pbenum.dart';

/// Risk is a scored incident (SRS-QMS-002).
///
/// Every field is read-only. The score is consequence × likelihood and the band
/// follows from the score; a request that could set them could set the one
/// incident that most needs escalating to "low".
class Risk extends $pb.GeneratedMessage {
  factory Risk({
    Consequence? consequence,
    Likelihood? likelihood,
    $core.int? score,
    RiskBand? band,
  }) {
    final result = create();
    if (consequence != null) result.consequence = consequence;
    if (likelihood != null) result.likelihood = likelihood;
    if (score != null) result.score = score;
    if (band != null) result.band = band;
    return result;
  }

  Risk._();

  factory Risk.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Risk.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Risk',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aE<Consequence>(1, _omitFieldNames ? '' : 'consequence',
        enumValues: Consequence.values)
    ..aE<Likelihood>(2, _omitFieldNames ? '' : 'likelihood',
        enumValues: Likelihood.values)
    ..aI(3, _omitFieldNames ? '' : 'score')
    ..aE<RiskBand>(4, _omitFieldNames ? '' : 'band',
        enumValues: RiskBand.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Risk clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Risk copyWith(void Function(Risk) updates) =>
      super.copyWith((message) => updates(message as Risk)) as Risk;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Risk create() => Risk._();
  @$core.override
  Risk createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Risk getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Risk>(create);
  static Risk? _defaultInstance;

  @$pb.TagNumber(1)
  Consequence get consequence => $_getN(0);
  @$pb.TagNumber(1)
  set consequence(Consequence value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasConsequence() => $_has(0);
  @$pb.TagNumber(1)
  void clearConsequence() => $_clearField(1);

  @$pb.TagNumber(2)
  Likelihood get likelihood => $_getN(1);
  @$pb.TagNumber(2)
  set likelihood(Likelihood value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLikelihood() => $_has(1);
  @$pb.TagNumber(2)
  void clearLikelihood() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get score => $_getIZ(2);
  @$pb.TagNumber(3)
  set score($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScore() => $_has(2);
  @$pb.TagNumber(3)
  void clearScore() => $_clearField(3);

  @$pb.TagNumber(4)
  RiskBand get band => $_getN(3);
  @$pb.TagNumber(4)
  set band(RiskBand value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBand() => $_has(3);
  @$pb.TagNumber(4)
  void clearBand() => $_clearField(4);
}

/// Incident is one reported event or near miss (SRS-QMS-001).
class Incident extends $pb.GeneratedMessage {
  factory Incident({
    $core.String? incidentId,
    $core.String? reference,
    $core.String? category,
    $core.String? subcategory,
    Reach? reach,
    Harm? harm,
    Risk? risk,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? assetId,
    $core.String? locationId,
    $core.String? facilityId,
    $core.String? department,
    $core.String? narrative,
    $core.String? immediateAction,
    $core.bool? sentinel,
    $core.bool? restricted,
    $core.bool? redacted,
    IncidentState? state,
    $core.bool? anonymous,
    $core.String? reportedBy,
    $0.Timestamp? occurredAt,
    $0.Timestamp? reportedAt,
    $core.String? reviewedBy,
    $0.Timestamp? reviewedAt,
    $core.String? closedBy,
    $0.Timestamp? closedAt,
    $core.String? closureReason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (incidentId != null) result.incidentId = incidentId;
    if (reference != null) result.reference = reference;
    if (category != null) result.category = category;
    if (subcategory != null) result.subcategory = subcategory;
    if (reach != null) result.reach = reach;
    if (harm != null) result.harm = harm;
    if (risk != null) result.risk = risk;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (assetId != null) result.assetId = assetId;
    if (locationId != null) result.locationId = locationId;
    if (facilityId != null) result.facilityId = facilityId;
    if (department != null) result.department = department;
    if (narrative != null) result.narrative = narrative;
    if (immediateAction != null) result.immediateAction = immediateAction;
    if (sentinel != null) result.sentinel = sentinel;
    if (restricted != null) result.restricted = restricted;
    if (redacted != null) result.redacted = redacted;
    if (state != null) result.state = state;
    if (anonymous != null) result.anonymous = anonymous;
    if (reportedBy != null) result.reportedBy = reportedBy;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (reportedAt != null) result.reportedAt = reportedAt;
    if (reviewedBy != null) result.reviewedBy = reviewedBy;
    if (reviewedAt != null) result.reviewedAt = reviewedAt;
    if (closedBy != null) result.closedBy = closedBy;
    if (closedAt != null) result.closedAt = closedAt;
    if (closureReason != null) result.closureReason = closureReason;
    if (version != null) result.version = version;
    return result;
  }

  Incident._();

  factory Incident.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Incident.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Incident',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'incidentId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aOS(3, _omitFieldNames ? '' : 'category')
    ..aOS(4, _omitFieldNames ? '' : 'subcategory')
    ..aE<Reach>(5, _omitFieldNames ? '' : 'reach', enumValues: Reach.values)
    ..aE<Harm>(6, _omitFieldNames ? '' : 'harm', enumValues: Harm.values)
    ..aOM<Risk>(7, _omitFieldNames ? '' : 'risk', subBuilder: Risk.create)
    ..aOS(8, _omitFieldNames ? '' : 'patientId')
    ..aOS(9, _omitFieldNames ? '' : 'encounterId')
    ..aOS(10, _omitFieldNames ? '' : 'assetId')
    ..aOS(11, _omitFieldNames ? '' : 'locationId')
    ..aOS(12, _omitFieldNames ? '' : 'facilityId')
    ..aOS(13, _omitFieldNames ? '' : 'department')
    ..aOS(14, _omitFieldNames ? '' : 'narrative')
    ..aOS(15, _omitFieldNames ? '' : 'immediateAction')
    ..aOB(16, _omitFieldNames ? '' : 'sentinel')
    ..aOB(17, _omitFieldNames ? '' : 'restricted')
    ..aOB(18, _omitFieldNames ? '' : 'redacted')
    ..aE<IncidentState>(19, _omitFieldNames ? '' : 'state',
        enumValues: IncidentState.values)
    ..aOB(20, _omitFieldNames ? '' : 'anonymous')
    ..aOS(21, _omitFieldNames ? '' : 'reportedBy')
    ..aOM<$0.Timestamp>(22, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(23, _omitFieldNames ? '' : 'reportedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(24, _omitFieldNames ? '' : 'reviewedBy')
    ..aOM<$0.Timestamp>(25, _omitFieldNames ? '' : 'reviewedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(26, _omitFieldNames ? '' : 'closedBy')
    ..aOM<$0.Timestamp>(27, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(28, _omitFieldNames ? '' : 'closureReason')
    ..aInt64(29, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Incident clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Incident copyWith(void Function(Incident) updates) =>
      super.copyWith((message) => updates(message as Incident)) as Incident;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Incident create() => Incident._();
  @$core.override
  Incident createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Incident getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Incident>(create);
  static Incident? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get incidentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set incidentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIncidentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncidentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reference => $_getSZ(1);
  @$pb.TagNumber(2)
  set reference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearReference() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get category => $_getSZ(2);
  @$pb.TagNumber(3)
  set category($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCategory() => $_has(2);
  @$pb.TagNumber(3)
  void clearCategory() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get subcategory => $_getSZ(3);
  @$pb.TagNumber(4)
  set subcategory($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubcategory() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubcategory() => $_clearField(4);

  @$pb.TagNumber(5)
  Reach get reach => $_getN(4);
  @$pb.TagNumber(5)
  set reach(Reach value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReach() => $_has(4);
  @$pb.TagNumber(5)
  void clearReach() => $_clearField(5);

  @$pb.TagNumber(6)
  Harm get harm => $_getN(5);
  @$pb.TagNumber(6)
  set harm(Harm value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasHarm() => $_has(5);
  @$pb.TagNumber(6)
  void clearHarm() => $_clearField(6);

  @$pb.TagNumber(7)
  Risk get risk => $_getN(6);
  @$pb.TagNumber(7)
  set risk(Risk value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasRisk() => $_has(6);
  @$pb.TagNumber(7)
  void clearRisk() => $_clearField(7);
  @$pb.TagNumber(7)
  Risk ensureRisk() => $_ensure(6);

  /// All optional and all independent: an incident can involve a patient, a
  /// machine, both or neither. Blanked on a restricted record the caller may
  /// not read in full.
  @$pb.TagNumber(8)
  $core.String get patientId => $_getSZ(7);
  @$pb.TagNumber(8)
  set patientId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPatientId() => $_has(7);
  @$pb.TagNumber(8)
  void clearPatientId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get encounterId => $_getSZ(8);
  @$pb.TagNumber(9)
  set encounterId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEncounterId() => $_has(8);
  @$pb.TagNumber(9)
  void clearEncounterId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get assetId => $_getSZ(9);
  @$pb.TagNumber(10)
  set assetId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAssetId() => $_has(9);
  @$pb.TagNumber(10)
  void clearAssetId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get locationId => $_getSZ(10);
  @$pb.TagNumber(11)
  set locationId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasLocationId() => $_has(10);
  @$pb.TagNumber(11)
  void clearLocationId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get facilityId => $_getSZ(11);
  @$pb.TagNumber(12)
  set facilityId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasFacilityId() => $_has(11);
  @$pb.TagNumber(12)
  void clearFacilityId() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get department => $_getSZ(12);
  @$pb.TagNumber(13)
  set department($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDepartment() => $_has(12);
  @$pb.TagNumber(13)
  void clearDepartment() => $_clearField(13);

  /// Blanked on a restricted record the caller may not read in full.
  @$pb.TagNumber(14)
  $core.String get narrative => $_getSZ(13);
  @$pb.TagNumber(14)
  set narrative($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasNarrative() => $_has(13);
  @$pb.TagNumber(14)
  void clearNarrative() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get immediateAction => $_getSZ(14);
  @$pb.TagNumber(15)
  set immediateAction($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasImmediateAction() => $_has(14);
  @$pb.TagNumber(15)
  void clearImmediateAction() => $_clearField(15);

  /// Told about individually. Always true for a death, and always restricted.
  @$pb.TagNumber(16)
  $core.bool get sentinel => $_getBF(15);
  @$pb.TagNumber(16)
  set sentinel($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(16)
  $core.bool hasSentinel() => $_has(15);
  @$pb.TagNumber(16)
  void clearSentinel() => $_clearField(16);

  /// Limited to authorised readers. Separate from the incident's existence.
  @$pb.TagNumber(17)
  $core.bool get restricted => $_getBF(16);
  @$pb.TagNumber(17)
  set restricted($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasRestricted() => $_has(16);
  @$pb.TagNumber(17)
  void clearRestricted() => $_clearField(17);

  /// True where the caller was given the redacted form. A client that cannot
  /// tell a blank narrative from a withheld one shows the ward an empty screen
  /// and no explanation.
  @$pb.TagNumber(18)
  $core.bool get redacted => $_getBF(17);
  @$pb.TagNumber(18)
  set redacted($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(18)
  $core.bool hasRedacted() => $_has(17);
  @$pb.TagNumber(18)
  void clearRedacted() => $_clearField(18);

  @$pb.TagNumber(19)
  IncidentState get state => $_getN(18);
  @$pb.TagNumber(19)
  set state(IncidentState value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasState() => $_has(18);
  @$pb.TagNumber(19)
  void clearState() => $_clearField(19);

  /// Hidden from readers and never from the audit trail. A reporting system in
  /// which staff are identified is one staff stop using.
  @$pb.TagNumber(20)
  $core.bool get anonymous => $_getBF(19);
  @$pb.TagNumber(20)
  set anonymous($core.bool value) => $_setBool(19, value);
  @$pb.TagNumber(20)
  $core.bool hasAnonymous() => $_has(19);
  @$pb.TagNumber(20)
  void clearAnonymous() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get reportedBy => $_getSZ(20);
  @$pb.TagNumber(21)
  set reportedBy($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasReportedBy() => $_has(20);
  @$pb.TagNumber(21)
  void clearReportedBy() => $_clearField(21);

  @$pb.TagNumber(22)
  $0.Timestamp get occurredAt => $_getN(21);
  @$pb.TagNumber(22)
  set occurredAt($0.Timestamp value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasOccurredAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearOccurredAt() => $_clearField(22);
  @$pb.TagNumber(22)
  $0.Timestamp ensureOccurredAt() => $_ensure(21);

  @$pb.TagNumber(23)
  $0.Timestamp get reportedAt => $_getN(22);
  @$pb.TagNumber(23)
  set reportedAt($0.Timestamp value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasReportedAt() => $_has(22);
  @$pb.TagNumber(23)
  void clearReportedAt() => $_clearField(23);
  @$pb.TagNumber(23)
  $0.Timestamp ensureReportedAt() => $_ensure(22);

  @$pb.TagNumber(24)
  $core.String get reviewedBy => $_getSZ(23);
  @$pb.TagNumber(24)
  set reviewedBy($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasReviewedBy() => $_has(23);
  @$pb.TagNumber(24)
  void clearReviewedBy() => $_clearField(24);

  @$pb.TagNumber(25)
  $0.Timestamp get reviewedAt => $_getN(24);
  @$pb.TagNumber(25)
  set reviewedAt($0.Timestamp value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasReviewedAt() => $_has(24);
  @$pb.TagNumber(25)
  void clearReviewedAt() => $_clearField(25);
  @$pb.TagNumber(25)
  $0.Timestamp ensureReviewedAt() => $_ensure(24);

  @$pb.TagNumber(26)
  $core.String get closedBy => $_getSZ(25);
  @$pb.TagNumber(26)
  set closedBy($core.String value) => $_setString(25, value);
  @$pb.TagNumber(26)
  $core.bool hasClosedBy() => $_has(25);
  @$pb.TagNumber(26)
  void clearClosedBy() => $_clearField(26);

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
  $core.String get closureReason => $_getSZ(27);
  @$pb.TagNumber(28)
  set closureReason($core.String value) => $_setString(27, value);
  @$pb.TagNumber(28)
  $core.bool hasClosureReason() => $_has(27);
  @$pb.TagNumber(28)
  void clearClosureReason() => $_clearField(28);

  @$pb.TagNumber(29)
  $fixnum.Int64 get version => $_getI64(28);
  @$pb.TagNumber(29)
  set version($fixnum.Int64 value) => $_setInt64(28, value);
  @$pb.TagNumber(29)
  $core.bool hasVersion() => $_has(28);
  @$pb.TagNumber(29)
  void clearVersion() => $_clearField(29);
}

class ReportIncidentRequest extends $pb.GeneratedMessage {
  factory ReportIncidentRequest({
    $core.String? reference,
    $core.String? category,
    $core.String? subcategory,
    Reach? reach,
    Harm? harm,
    Consequence? consequence,
    Likelihood? likelihood,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? assetId,
    $core.String? locationId,
    $core.String? facilityId,
    $core.String? department,
    $core.String? narrative,
    $core.String? immediateAction,
    $core.bool? sentinel,
    $core.bool? anonymous,
    $0.Timestamp? occurredAt,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    if (category != null) result.category = category;
    if (subcategory != null) result.subcategory = subcategory;
    if (reach != null) result.reach = reach;
    if (harm != null) result.harm = harm;
    if (consequence != null) result.consequence = consequence;
    if (likelihood != null) result.likelihood = likelihood;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (assetId != null) result.assetId = assetId;
    if (locationId != null) result.locationId = locationId;
    if (facilityId != null) result.facilityId = facilityId;
    if (department != null) result.department = department;
    if (narrative != null) result.narrative = narrative;
    if (immediateAction != null) result.immediateAction = immediateAction;
    if (sentinel != null) result.sentinel = sentinel;
    if (anonymous != null) result.anonymous = anonymous;
    if (occurredAt != null) result.occurredAt = occurredAt;
    return result;
  }

  ReportIncidentRequest._();

  factory ReportIncidentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportIncidentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportIncidentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..aOS(2, _omitFieldNames ? '' : 'category')
    ..aOS(3, _omitFieldNames ? '' : 'subcategory')
    ..aE<Reach>(4, _omitFieldNames ? '' : 'reach', enumValues: Reach.values)
    ..aE<Harm>(5, _omitFieldNames ? '' : 'harm', enumValues: Harm.values)
    ..aE<Consequence>(6, _omitFieldNames ? '' : 'consequence',
        enumValues: Consequence.values)
    ..aE<Likelihood>(7, _omitFieldNames ? '' : 'likelihood',
        enumValues: Likelihood.values)
    ..aOS(8, _omitFieldNames ? '' : 'patientId')
    ..aOS(9, _omitFieldNames ? '' : 'encounterId')
    ..aOS(10, _omitFieldNames ? '' : 'assetId')
    ..aOS(11, _omitFieldNames ? '' : 'locationId')
    ..aOS(12, _omitFieldNames ? '' : 'facilityId')
    ..aOS(13, _omitFieldNames ? '' : 'department')
    ..aOS(14, _omitFieldNames ? '' : 'narrative')
    ..aOS(15, _omitFieldNames ? '' : 'immediateAction')
    ..aOB(16, _omitFieldNames ? '' : 'sentinel')
    ..aOB(17, _omitFieldNames ? '' : 'anonymous')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportIncidentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportIncidentRequest copyWith(
          void Function(ReportIncidentRequest) updates) =>
      super.copyWith((message) => updates(message as ReportIncidentRequest))
          as ReportIncidentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportIncidentRequest create() => ReportIncidentRequest._();
  @$core.override
  ReportIncidentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReportIncidentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportIncidentRequest>(create);
  static ReportIncidentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reference => $_getSZ(0);
  @$pb.TagNumber(1)
  set reference($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReference() => $_has(0);
  @$pb.TagNumber(1)
  void clearReference() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get category => $_getSZ(1);
  @$pb.TagNumber(2)
  set category($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCategory() => $_has(1);
  @$pb.TagNumber(2)
  void clearCategory() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get subcategory => $_getSZ(2);
  @$pb.TagNumber(3)
  set subcategory($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubcategory() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubcategory() => $_clearField(3);

  @$pb.TagNumber(4)
  Reach get reach => $_getN(3);
  @$pb.TagNumber(4)
  set reach(Reach value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasReach() => $_has(3);
  @$pb.TagNumber(4)
  void clearReach() => $_clearField(4);

  @$pb.TagNumber(5)
  Harm get harm => $_getN(4);
  @$pb.TagNumber(5)
  set harm(Harm value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasHarm() => $_has(4);
  @$pb.TagNumber(5)
  void clearHarm() => $_clearField(5);

  /// The score is derived from these two.
  @$pb.TagNumber(6)
  Consequence get consequence => $_getN(5);
  @$pb.TagNumber(6)
  set consequence(Consequence value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasConsequence() => $_has(5);
  @$pb.TagNumber(6)
  void clearConsequence() => $_clearField(6);

  @$pb.TagNumber(7)
  Likelihood get likelihood => $_getN(6);
  @$pb.TagNumber(7)
  set likelihood(Likelihood value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasLikelihood() => $_has(6);
  @$pb.TagNumber(7)
  void clearLikelihood() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get patientId => $_getSZ(7);
  @$pb.TagNumber(8)
  set patientId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPatientId() => $_has(7);
  @$pb.TagNumber(8)
  void clearPatientId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get encounterId => $_getSZ(8);
  @$pb.TagNumber(9)
  set encounterId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEncounterId() => $_has(8);
  @$pb.TagNumber(9)
  void clearEncounterId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get assetId => $_getSZ(9);
  @$pb.TagNumber(10)
  set assetId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAssetId() => $_has(9);
  @$pb.TagNumber(10)
  void clearAssetId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get locationId => $_getSZ(10);
  @$pb.TagNumber(11)
  set locationId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasLocationId() => $_has(10);
  @$pb.TagNumber(11)
  void clearLocationId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get facilityId => $_getSZ(11);
  @$pb.TagNumber(12)
  set facilityId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasFacilityId() => $_has(11);
  @$pb.TagNumber(12)
  void clearFacilityId() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get department => $_getSZ(12);
  @$pb.TagNumber(13)
  set department($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDepartment() => $_has(12);
  @$pb.TagNumber(13)
  void clearDepartment() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get narrative => $_getSZ(13);
  @$pb.TagNumber(14)
  set narrative($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasNarrative() => $_has(13);
  @$pb.TagNumber(14)
  void clearNarrative() => $_clearField(14);

  /// Required once anything reached a patient.
  @$pb.TagNumber(15)
  $core.String get immediateAction => $_getSZ(14);
  @$pb.TagNumber(15)
  set immediateAction($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasImmediateAction() => $_has(14);
  @$pb.TagNumber(15)
  void clearImmediateAction() => $_clearField(15);

  /// Requested, not decided: a death is a sentinel event whatever this says,
  /// and so is anything in the hospital's configured sentinel categories.
  @$pb.TagNumber(16)
  $core.bool get sentinel => $_getBF(15);
  @$pb.TagNumber(16)
  set sentinel($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(16)
  $core.bool hasSentinel() => $_has(15);
  @$pb.TagNumber(16)
  void clearSentinel() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.bool get anonymous => $_getBF(16);
  @$pb.TagNumber(17)
  set anonymous($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasAnonymous() => $_has(16);
  @$pb.TagNumber(17)
  void clearAnonymous() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get occurredAt => $_getN(17);
  @$pb.TagNumber(18)
  set occurredAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasOccurredAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearOccurredAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureOccurredAt() => $_ensure(17);
}

class ReportIncidentResponse extends $pb.GeneratedMessage {
  factory ReportIncidentResponse({
    Incident? incident,
  }) {
    final result = create();
    if (incident != null) result.incident = incident;
    return result;
  }

  ReportIncidentResponse._();

  factory ReportIncidentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportIncidentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportIncidentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Incident>(1, _omitFieldNames ? '' : 'incident',
        subBuilder: Incident.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportIncidentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportIncidentResponse copyWith(
          void Function(ReportIncidentResponse) updates) =>
      super.copyWith((message) => updates(message as ReportIncidentResponse))
          as ReportIncidentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportIncidentResponse create() => ReportIncidentResponse._();
  @$core.override
  ReportIncidentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReportIncidentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportIncidentResponse>(create);
  static ReportIncidentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Incident get incident => $_getN(0);
  @$pb.TagNumber(1)
  set incident(Incident value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIncident() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncident() => $_clearField(1);
  @$pb.TagNumber(1)
  Incident ensureIncident() => $_ensure(0);
}

class GetIncidentRequest extends $pb.GeneratedMessage {
  factory GetIncidentRequest({
    $core.String? incidentId,
  }) {
    final result = create();
    if (incidentId != null) result.incidentId = incidentId;
    return result;
  }

  GetIncidentRequest._();

  factory GetIncidentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetIncidentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetIncidentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'incidentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIncidentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIncidentRequest copyWith(void Function(GetIncidentRequest) updates) =>
      super.copyWith((message) => updates(message as GetIncidentRequest))
          as GetIncidentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetIncidentRequest create() => GetIncidentRequest._();
  @$core.override
  GetIncidentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetIncidentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetIncidentRequest>(create);
  static GetIncidentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get incidentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set incidentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIncidentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncidentId() => $_clearField(1);
}

class GetIncidentResponse extends $pb.GeneratedMessage {
  factory GetIncidentResponse({
    Incident? incident,
  }) {
    final result = create();
    if (incident != null) result.incident = incident;
    return result;
  }

  GetIncidentResponse._();

  factory GetIncidentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetIncidentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetIncidentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Incident>(1, _omitFieldNames ? '' : 'incident',
        subBuilder: Incident.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIncidentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIncidentResponse copyWith(void Function(GetIncidentResponse) updates) =>
      super.copyWith((message) => updates(message as GetIncidentResponse))
          as GetIncidentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetIncidentResponse create() => GetIncidentResponse._();
  @$core.override
  GetIncidentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetIncidentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetIncidentResponse>(create);
  static GetIncidentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Incident get incident => $_getN(0);
  @$pb.TagNumber(1)
  set incident(Incident value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIncident() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncident() => $_clearField(1);
  @$pb.TagNumber(1)
  Incident ensureIncident() => $_ensure(0);
}

class ListIncidentsRequest extends $pb.GeneratedMessage {
  factory ListIncidentsRequest({
    $core.String? category,
    IncidentState? state,
    $core.bool? openOnly,
    $core.bool? sentinelOnly,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
  }) {
    final result = create();
    if (category != null) result.category = category;
    if (state != null) result.state = state;
    if (openOnly != null) result.openOnly = openOnly;
    if (sentinelOnly != null) result.sentinelOnly = sentinelOnly;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListIncidentsRequest._();

  factory ListIncidentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListIncidentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListIncidentsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'category')
    ..aE<IncidentState>(2, _omitFieldNames ? '' : 'state',
        enumValues: IncidentState.values)
    ..aOB(3, _omitFieldNames ? '' : 'openOnly')
    ..aOB(4, _omitFieldNames ? '' : 'sentinelOnly')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(7, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListIncidentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListIncidentsRequest copyWith(void Function(ListIncidentsRequest) updates) =>
      super.copyWith((message) => updates(message as ListIncidentsRequest))
          as ListIncidentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListIncidentsRequest create() => ListIncidentsRequest._();
  @$core.override
  ListIncidentsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListIncidentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListIncidentsRequest>(create);
  static ListIncidentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get category => $_getSZ(0);
  @$pb.TagNumber(1)
  set category($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => $_clearField(1);

  @$pb.TagNumber(2)
  IncidentState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(IncidentState value) => $_setField(2, value);
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
  $core.bool get sentinelOnly => $_getBF(3);
  @$pb.TagNumber(4)
  set sentinelOnly($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSentinelOnly() => $_has(3);
  @$pb.TagNumber(4)
  void clearSentinelOnly() => $_clearField(4);

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
}

class ListIncidentsResponse extends $pb.GeneratedMessage {
  factory ListIncidentsResponse({
    $core.Iterable<Incident>? incidents,
  }) {
    final result = create();
    if (incidents != null) result.incidents.addAll(incidents);
    return result;
  }

  ListIncidentsResponse._();

  factory ListIncidentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListIncidentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListIncidentsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<Incident>(1, _omitFieldNames ? '' : 'incidents',
        subBuilder: Incident.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListIncidentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListIncidentsResponse copyWith(
          void Function(ListIncidentsResponse) updates) =>
      super.copyWith((message) => updates(message as ListIncidentsResponse))
          as ListIncidentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListIncidentsResponse create() => ListIncidentsResponse._();
  @$core.override
  ListIncidentsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListIncidentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListIncidentsResponse>(create);
  static ListIncidentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Incident> get incidents => $_getList(0);
}

class RescoreIncidentRequest extends $pb.GeneratedMessage {
  factory RescoreIncidentRequest({
    $core.String? incidentId,
    Consequence? consequence,
    Likelihood? likelihood,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (incidentId != null) result.incidentId = incidentId;
    if (consequence != null) result.consequence = consequence;
    if (likelihood != null) result.likelihood = likelihood;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  RescoreIncidentRequest._();

  factory RescoreIncidentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RescoreIncidentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RescoreIncidentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'incidentId')
    ..aE<Consequence>(2, _omitFieldNames ? '' : 'consequence',
        enumValues: Consequence.values)
    ..aE<Likelihood>(3, _omitFieldNames ? '' : 'likelihood',
        enumValues: Likelihood.values)
    ..aInt64(4, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RescoreIncidentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RescoreIncidentRequest copyWith(
          void Function(RescoreIncidentRequest) updates) =>
      super.copyWith((message) => updates(message as RescoreIncidentRequest))
          as RescoreIncidentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RescoreIncidentRequest create() => RescoreIncidentRequest._();
  @$core.override
  RescoreIncidentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RescoreIncidentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RescoreIncidentRequest>(create);
  static RescoreIncidentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get incidentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set incidentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIncidentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncidentId() => $_clearField(1);

  @$pb.TagNumber(2)
  Consequence get consequence => $_getN(1);
  @$pb.TagNumber(2)
  set consequence(Consequence value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasConsequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearConsequence() => $_clearField(2);

  @$pb.TagNumber(3)
  Likelihood get likelihood => $_getN(2);
  @$pb.TagNumber(3)
  set likelihood(Likelihood value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLikelihood() => $_has(2);
  @$pb.TagNumber(3)
  void clearLikelihood() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expectedVersion => $_getI64(3);
  @$pb.TagNumber(4)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedVersion() => $_clearField(4);
}

class RescoreIncidentResponse extends $pb.GeneratedMessage {
  factory RescoreIncidentResponse({
    Incident? incident,
  }) {
    final result = create();
    if (incident != null) result.incident = incident;
    return result;
  }

  RescoreIncidentResponse._();

  factory RescoreIncidentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RescoreIncidentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RescoreIncidentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Incident>(1, _omitFieldNames ? '' : 'incident',
        subBuilder: Incident.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RescoreIncidentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RescoreIncidentResponse copyWith(
          void Function(RescoreIncidentResponse) updates) =>
      super.copyWith((message) => updates(message as RescoreIncidentResponse))
          as RescoreIncidentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RescoreIncidentResponse create() => RescoreIncidentResponse._();
  @$core.override
  RescoreIncidentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RescoreIncidentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RescoreIncidentResponse>(create);
  static RescoreIncidentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Incident get incident => $_getN(0);
  @$pb.TagNumber(1)
  set incident(Incident value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIncident() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncident() => $_clearField(1);
  @$pb.TagNumber(1)
  Incident ensureIncident() => $_ensure(0);
}

class AdvanceIncidentRequest extends $pb.GeneratedMessage {
  factory AdvanceIncidentRequest({
    $core.String? incidentId,
    IncidentState? state,
    $core.String? reason,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (incidentId != null) result.incidentId = incidentId;
    if (state != null) result.state = state;
    if (reason != null) result.reason = reason;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  AdvanceIncidentRequest._();

  factory AdvanceIncidentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvanceIncidentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvanceIncidentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'incidentId')
    ..aE<IncidentState>(2, _omitFieldNames ? '' : 'state',
        enumValues: IncidentState.values)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aInt64(4, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceIncidentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceIncidentRequest copyWith(
          void Function(AdvanceIncidentRequest) updates) =>
      super.copyWith((message) => updates(message as AdvanceIncidentRequest))
          as AdvanceIncidentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvanceIncidentRequest create() => AdvanceIncidentRequest._();
  @$core.override
  AdvanceIncidentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvanceIncidentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvanceIncidentRequest>(create);
  static AdvanceIncidentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get incidentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set incidentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIncidentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncidentId() => $_clearField(1);

  @$pb.TagNumber(2)
  IncidentState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(IncidentState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  /// Required at closure and at rejection: both are decisions somebody has to
  /// be able to question later.
  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expectedVersion => $_getI64(3);
  @$pb.TagNumber(4)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedVersion() => $_clearField(4);
}

/// AdvanceIncidentResponse names what a closure left behind (SRS-QMS-003).
///
/// Reported rather than refused. An incident log that will not let anything
/// close until somebody has done a root cause analysis is a log work goes into
/// and never comes out of, and the backlog hides the real ones.
class AdvanceIncidentResponse extends $pb.GeneratedMessage {
  factory AdvanceIncidentResponse({
    Incident? incident,
    $core.Iterable<$core.String>? concerns,
  }) {
    final result = create();
    if (incident != null) result.incident = incident;
    if (concerns != null) result.concerns.addAll(concerns);
    return result;
  }

  AdvanceIncidentResponse._();

  factory AdvanceIncidentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvanceIncidentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvanceIncidentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Incident>(1, _omitFieldNames ? '' : 'incident',
        subBuilder: Incident.create)
    ..pPS(2, _omitFieldNames ? '' : 'concerns')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceIncidentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceIncidentResponse copyWith(
          void Function(AdvanceIncidentResponse) updates) =>
      super.copyWith((message) => updates(message as AdvanceIncidentResponse))
          as AdvanceIncidentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvanceIncidentResponse create() => AdvanceIncidentResponse._();
  @$core.override
  AdvanceIncidentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvanceIncidentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvanceIncidentResponse>(create);
  static AdvanceIncidentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Incident get incident => $_getN(0);
  @$pb.TagNumber(1)
  set incident(Incident value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIncident() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncident() => $_clearField(1);
  @$pb.TagNumber(1)
  Incident ensureIncident() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get concerns => $_getList(1);
}

class SetIncidentRestrictionRequest extends $pb.GeneratedMessage {
  factory SetIncidentRestrictionRequest({
    $core.String? incidentId,
    $core.bool? restricted,
    $core.String? reason,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (incidentId != null) result.incidentId = incidentId;
    if (restricted != null) result.restricted = restricted;
    if (reason != null) result.reason = reason;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  SetIncidentRestrictionRequest._();

  factory SetIncidentRestrictionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetIncidentRestrictionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetIncidentRestrictionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'incidentId')
    ..aOB(2, _omitFieldNames ? '' : 'restricted')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aInt64(4, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetIncidentRestrictionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetIncidentRestrictionRequest copyWith(
          void Function(SetIncidentRestrictionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetIncidentRestrictionRequest))
          as SetIncidentRestrictionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetIncidentRestrictionRequest create() =>
      SetIncidentRestrictionRequest._();
  @$core.override
  SetIncidentRestrictionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetIncidentRestrictionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetIncidentRestrictionRequest>(create);
  static SetIncidentRestrictionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get incidentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set incidentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIncidentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncidentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get restricted => $_getBF(1);
  @$pb.TagNumber(2)
  set restricted($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRestricted() => $_has(1);
  @$pb.TagNumber(2)
  void clearRestricted() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expectedVersion => $_getI64(3);
  @$pb.TagNumber(4)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedVersion() => $_clearField(4);
}

class SetIncidentRestrictionResponse extends $pb.GeneratedMessage {
  factory SetIncidentRestrictionResponse({
    Incident? incident,
  }) {
    final result = create();
    if (incident != null) result.incident = incident;
    return result;
  }

  SetIncidentRestrictionResponse._();

  factory SetIncidentRestrictionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetIncidentRestrictionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetIncidentRestrictionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Incident>(1, _omitFieldNames ? '' : 'incident',
        subBuilder: Incident.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetIncidentRestrictionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetIncidentRestrictionResponse copyWith(
          void Function(SetIncidentRestrictionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetIncidentRestrictionResponse))
          as SetIncidentRestrictionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetIncidentRestrictionResponse create() =>
      SetIncidentRestrictionResponse._();
  @$core.override
  SetIncidentRestrictionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetIncidentRestrictionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetIncidentRestrictionResponse>(create);
  static SetIncidentRestrictionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Incident get incident => $_getN(0);
  @$pb.TagNumber(1)
  set incident(Incident value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIncident() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncident() => $_clearField(1);
  @$pb.TagNumber(1)
  Incident ensureIncident() => $_ensure(0);
}

/// Trend is one line of the incident pattern (SRS-QMS-002).
class Trend extends $pb.GeneratedMessage {
  factory Trend({
    $core.String? category,
    $core.int? count,
    $core.int? nearMisses,
    $core.int? harmful,
    Harm? worstHarm,
    $core.int? extreme,
  }) {
    final result = create();
    if (category != null) result.category = category;
    if (count != null) result.count = count;
    if (nearMisses != null) result.nearMisses = nearMisses;
    if (harmful != null) result.harmful = harmful;
    if (worstHarm != null) result.worstHarm = worstHarm;
    if (extreme != null) result.extreme = extreme;
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
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'category')
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..aI(3, _omitFieldNames ? '' : 'nearMisses')
    ..aI(4, _omitFieldNames ? '' : 'harmful')
    ..aE<Harm>(5, _omitFieldNames ? '' : 'worstHarm', enumValues: Harm.values)
    ..aI(6, _omitFieldNames ? '' : 'extreme')
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
  $core.String get category => $_getSZ(0);
  @$pb.TagNumber(1)
  set category($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);

  /// Counted separately rather than folded in: a category whose count is
  /// rising because people have started reporting near misses is getting
  /// safer, and a single total says the opposite.
  @$pb.TagNumber(3)
  $core.int get nearMisses => $_getIZ(2);
  @$pb.TagNumber(3)
  set nearMisses($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNearMisses() => $_has(2);
  @$pb.TagNumber(3)
  void clearNearMisses() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get harmful => $_getIZ(3);
  @$pb.TagNumber(4)
  set harmful($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHarmful() => $_has(3);
  @$pb.TagNumber(4)
  void clearHarmful() => $_clearField(4);

  /// The worst single outcome, so a category with one death and forty
  /// scratches does not read as forty-one scratches.
  @$pb.TagNumber(5)
  Harm get worstHarm => $_getN(4);
  @$pb.TagNumber(5)
  set worstHarm(Harm value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasWorstHarm() => $_has(4);
  @$pb.TagNumber(5)
  void clearWorstHarm() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get extreme => $_getIZ(5);
  @$pb.TagNumber(6)
  set extreme($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExtreme() => $_has(5);
  @$pb.TagNumber(6)
  void clearExtreme() => $_clearField(6);
}

class GetTrendsRequest extends $pb.GeneratedMessage {
  factory GetTrendsRequest({
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  GetTrendsRequest._();

  factory GetTrendsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTrendsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTrendsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTrendsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTrendsRequest copyWith(void Function(GetTrendsRequest) updates) =>
      super.copyWith((message) => updates(message as GetTrendsRequest))
          as GetTrendsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTrendsRequest create() => GetTrendsRequest._();
  @$core.override
  GetTrendsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTrendsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTrendsRequest>(create);
  static GetTrendsRequest? _defaultInstance;

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
}

class GetTrendsResponse extends $pb.GeneratedMessage {
  factory GetTrendsResponse({
    $core.Iterable<Trend>? trends,
  }) {
    final result = create();
    if (trends != null) result.trends.addAll(trends);
    return result;
  }

  GetTrendsResponse._();

  factory GetTrendsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTrendsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTrendsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<Trend>(1, _omitFieldNames ? '' : 'trends', subBuilder: Trend.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTrendsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTrendsResponse copyWith(void Function(GetTrendsResponse) updates) =>
      super.copyWith((message) => updates(message as GetTrendsResponse))
          as GetTrendsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTrendsResponse create() => GetTrendsResponse._();
  @$core.override
  GetTrendsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTrendsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTrendsResponse>(create);
  static GetTrendsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Trend> get trends => $_getList(0);
}

/// ContributingFactor is one thing that helped an incident happen
/// (SRS-QMS-003).
class ContributingFactor extends $pb.GeneratedMessage {
  factory ContributingFactor({
    FactorCategory? category,
    $core.String? detail,
    $core.bool? root,
  }) {
    final result = create();
    if (category != null) result.category = category;
    if (detail != null) result.detail = detail;
    if (root != null) result.root = root;
    return result;
  }

  ContributingFactor._();

  factory ContributingFactor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContributingFactor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContributingFactor',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aE<FactorCategory>(1, _omitFieldNames ? '' : 'category',
        enumValues: FactorCategory.values)
    ..aOS(2, _omitFieldNames ? '' : 'detail')
    ..aOB(3, _omitFieldNames ? '' : 'root')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContributingFactor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContributingFactor copyWith(void Function(ContributingFactor) updates) =>
      super.copyWith((message) => updates(message as ContributingFactor))
          as ContributingFactor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContributingFactor create() => ContributingFactor._();
  @$core.override
  ContributingFactor createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContributingFactor getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContributingFactor>(create);
  static ContributingFactor? _defaultInstance;

  @$pb.TagNumber(1)
  FactorCategory get category => $_getN(0);
  @$pb.TagNumber(1)
  set category(FactorCategory value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get detail => $_getSZ(1);
  @$pb.TagNumber(2)
  set detail($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDetail() => $_has(1);
  @$pb.TagNumber(2)
  void clearDetail() => $_clearField(2);

  /// A cause rather than a circumstance. An analysis that calls everything a
  /// root cause has not analysed anything.
  @$pb.TagNumber(3)
  $core.bool get root => $_getBF(2);
  @$pb.TagNumber(3)
  set root($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRoot() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoot() => $_clearField(3);
}

/// RootCauseAnalysis is an investigation of one incident (SRS-QMS-003).
class RootCauseAnalysis extends $pb.GeneratedMessage {
  factory RootCauseAnalysis({
    $core.String? rcaId,
    $core.String? incidentId,
    $core.String? method,
    $core.String? accountableOwner,
    $core.Iterable<ContributingFactor>? factors,
    $core.String? findings,
    $core.String? noActionReason,
    ReviewState? state,
    $core.bool? restricted,
    $0.Timestamp? openedAt,
    $core.String? openedBy,
    $0.Timestamp? closedAt,
    $core.String? closedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (rcaId != null) result.rcaId = rcaId;
    if (incidentId != null) result.incidentId = incidentId;
    if (method != null) result.method = method;
    if (accountableOwner != null) result.accountableOwner = accountableOwner;
    if (factors != null) result.factors.addAll(factors);
    if (findings != null) result.findings = findings;
    if (noActionReason != null) result.noActionReason = noActionReason;
    if (state != null) result.state = state;
    if (restricted != null) result.restricted = restricted;
    if (openedAt != null) result.openedAt = openedAt;
    if (openedBy != null) result.openedBy = openedBy;
    if (closedAt != null) result.closedAt = closedAt;
    if (closedBy != null) result.closedBy = closedBy;
    if (version != null) result.version = version;
    return result;
  }

  RootCauseAnalysis._();

  factory RootCauseAnalysis.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RootCauseAnalysis.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RootCauseAnalysis',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'rcaId')
    ..aOS(2, _omitFieldNames ? '' : 'incidentId')
    ..aOS(3, _omitFieldNames ? '' : 'method')
    ..aOS(4, _omitFieldNames ? '' : 'accountableOwner')
    ..pPM<ContributingFactor>(5, _omitFieldNames ? '' : 'factors',
        subBuilder: ContributingFactor.create)
    ..aOS(6, _omitFieldNames ? '' : 'findings')
    ..aOS(7, _omitFieldNames ? '' : 'noActionReason')
    ..aE<ReviewState>(8, _omitFieldNames ? '' : 'state',
        enumValues: ReviewState.values)
    ..aOB(9, _omitFieldNames ? '' : 'restricted')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'openedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'openedBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'closedBy')
    ..aInt64(14, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RootCauseAnalysis clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RootCauseAnalysis copyWith(void Function(RootCauseAnalysis) updates) =>
      super.copyWith((message) => updates(message as RootCauseAnalysis))
          as RootCauseAnalysis;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RootCauseAnalysis create() => RootCauseAnalysis._();
  @$core.override
  RootCauseAnalysis createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RootCauseAnalysis getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RootCauseAnalysis>(create);
  static RootCauseAnalysis? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rcaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set rcaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRcaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRcaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get incidentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set incidentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIncidentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearIncidentId() => $_clearField(2);

  /// Five whys, fishbone, the London Protocol. Named because the method
  /// decides what the analysis can find.
  @$pb.TagNumber(3)
  $core.String get method => $_getSZ(2);
  @$pb.TagNumber(3)
  set method($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMethod() => $_has(2);
  @$pb.TagNumber(3)
  void clearMethod() => $_clearField(3);

  /// Required at completion. An analysis owned by "the committee" is owned by
  /// nobody.
  @$pb.TagNumber(4)
  $core.String get accountableOwner => $_getSZ(3);
  @$pb.TagNumber(4)
  set accountableOwner($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAccountableOwner() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccountableOwner() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<ContributingFactor> get factors => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get findings => $_getSZ(5);
  @$pb.TagNumber(6)
  set findings($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFindings() => $_has(5);
  @$pb.TagNumber(6)
  void clearFindings() => $_clearField(6);

  /// Required when the analysis raised no corrective action: "we investigated
  /// and changed nothing" is a defensible conclusion and an undefended one is
  /// how root cause analysis becomes paperwork.
  @$pb.TagNumber(7)
  $core.String get noActionReason => $_getSZ(6);
  @$pb.TagNumber(7)
  set noActionReason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNoActionReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearNoActionReason() => $_clearField(7);

  @$pb.TagNumber(8)
  ReviewState get state => $_getN(7);
  @$pb.TagNumber(8)
  set state(ReviewState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasState() => $_has(7);
  @$pb.TagNumber(8)
  void clearState() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get restricted => $_getBF(8);
  @$pb.TagNumber(9)
  set restricted($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRestricted() => $_has(8);
  @$pb.TagNumber(9)
  void clearRestricted() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get openedAt => $_getN(9);
  @$pb.TagNumber(10)
  set openedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasOpenedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearOpenedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureOpenedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get openedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set openedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOpenedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearOpenedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get closedAt => $_getN(11);
  @$pb.TagNumber(12)
  set closedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasClosedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearClosedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureClosedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get closedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set closedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasClosedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearClosedBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get version => $_getI64(13);
  @$pb.TagNumber(14)
  set version($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasVersion() => $_has(13);
  @$pb.TagNumber(14)
  void clearVersion() => $_clearField(14);
}

class StartRcaRequest extends $pb.GeneratedMessage {
  factory StartRcaRequest({
    $core.String? incidentId,
    $core.String? method,
  }) {
    final result = create();
    if (incidentId != null) result.incidentId = incidentId;
    if (method != null) result.method = method;
    return result;
  }

  StartRcaRequest._();

  factory StartRcaRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartRcaRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartRcaRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'incidentId')
    ..aOS(2, _omitFieldNames ? '' : 'method')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartRcaRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartRcaRequest copyWith(void Function(StartRcaRequest) updates) =>
      super.copyWith((message) => updates(message as StartRcaRequest))
          as StartRcaRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartRcaRequest create() => StartRcaRequest._();
  @$core.override
  StartRcaRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartRcaRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartRcaRequest>(create);
  static StartRcaRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get incidentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set incidentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIncidentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncidentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get method => $_getSZ(1);
  @$pb.TagNumber(2)
  set method($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMethod() => $_has(1);
  @$pb.TagNumber(2)
  void clearMethod() => $_clearField(2);
}

class StartRcaResponse extends $pb.GeneratedMessage {
  factory StartRcaResponse({
    RootCauseAnalysis? rca,
  }) {
    final result = create();
    if (rca != null) result.rca = rca;
    return result;
  }

  StartRcaResponse._();

  factory StartRcaResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartRcaResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartRcaResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<RootCauseAnalysis>(1, _omitFieldNames ? '' : 'rca',
        subBuilder: RootCauseAnalysis.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartRcaResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartRcaResponse copyWith(void Function(StartRcaResponse) updates) =>
      super.copyWith((message) => updates(message as StartRcaResponse))
          as StartRcaResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartRcaResponse create() => StartRcaResponse._();
  @$core.override
  StartRcaResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartRcaResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartRcaResponse>(create);
  static StartRcaResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RootCauseAnalysis get rca => $_getN(0);
  @$pb.TagNumber(1)
  set rca(RootCauseAnalysis value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRca() => $_has(0);
  @$pb.TagNumber(1)
  void clearRca() => $_clearField(1);
  @$pb.TagNumber(1)
  RootCauseAnalysis ensureRca() => $_ensure(0);
}

class AddFactorRequest extends $pb.GeneratedMessage {
  factory AddFactorRequest({
    $core.String? rcaId,
    ContributingFactor? factor,
  }) {
    final result = create();
    if (rcaId != null) result.rcaId = rcaId;
    if (factor != null) result.factor = factor;
    return result;
  }

  AddFactorRequest._();

  factory AddFactorRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddFactorRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddFactorRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'rcaId')
    ..aOM<ContributingFactor>(2, _omitFieldNames ? '' : 'factor',
        subBuilder: ContributingFactor.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddFactorRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddFactorRequest copyWith(void Function(AddFactorRequest) updates) =>
      super.copyWith((message) => updates(message as AddFactorRequest))
          as AddFactorRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddFactorRequest create() => AddFactorRequest._();
  @$core.override
  AddFactorRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddFactorRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddFactorRequest>(create);
  static AddFactorRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rcaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set rcaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRcaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRcaId() => $_clearField(1);

  @$pb.TagNumber(2)
  ContributingFactor get factor => $_getN(1);
  @$pb.TagNumber(2)
  set factor(ContributingFactor value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFactor() => $_has(1);
  @$pb.TagNumber(2)
  void clearFactor() => $_clearField(2);
  @$pb.TagNumber(2)
  ContributingFactor ensureFactor() => $_ensure(1);
}

class AddFactorResponse extends $pb.GeneratedMessage {
  factory AddFactorResponse({
    RootCauseAnalysis? rca,
  }) {
    final result = create();
    if (rca != null) result.rca = rca;
    return result;
  }

  AddFactorResponse._();

  factory AddFactorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddFactorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddFactorResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<RootCauseAnalysis>(1, _omitFieldNames ? '' : 'rca',
        subBuilder: RootCauseAnalysis.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddFactorResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddFactorResponse copyWith(void Function(AddFactorResponse) updates) =>
      super.copyWith((message) => updates(message as AddFactorResponse))
          as AddFactorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddFactorResponse create() => AddFactorResponse._();
  @$core.override
  AddFactorResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddFactorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddFactorResponse>(create);
  static AddFactorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RootCauseAnalysis get rca => $_getN(0);
  @$pb.TagNumber(1)
  set rca(RootCauseAnalysis value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRca() => $_has(0);
  @$pb.TagNumber(1)
  void clearRca() => $_clearField(1);
  @$pb.TagNumber(1)
  RootCauseAnalysis ensureRca() => $_ensure(0);
}

class CompleteRcaRequest extends $pb.GeneratedMessage {
  factory CompleteRcaRequest({
    $core.String? rcaId,
    $core.String? accountableOwner,
    $core.String? findings,
    $core.String? noActionReason,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (rcaId != null) result.rcaId = rcaId;
    if (accountableOwner != null) result.accountableOwner = accountableOwner;
    if (findings != null) result.findings = findings;
    if (noActionReason != null) result.noActionReason = noActionReason;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  CompleteRcaRequest._();

  factory CompleteRcaRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteRcaRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteRcaRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'rcaId')
    ..aOS(2, _omitFieldNames ? '' : 'accountableOwner')
    ..aOS(3, _omitFieldNames ? '' : 'findings')
    ..aOS(4, _omitFieldNames ? '' : 'noActionReason')
    ..aInt64(5, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteRcaRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteRcaRequest copyWith(void Function(CompleteRcaRequest) updates) =>
      super.copyWith((message) => updates(message as CompleteRcaRequest))
          as CompleteRcaRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteRcaRequest create() => CompleteRcaRequest._();
  @$core.override
  CompleteRcaRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteRcaRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteRcaRequest>(create);
  static CompleteRcaRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rcaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set rcaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRcaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRcaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get accountableOwner => $_getSZ(1);
  @$pb.TagNumber(2)
  set accountableOwner($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccountableOwner() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccountableOwner() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get findings => $_getSZ(2);
  @$pb.TagNumber(3)
  set findings($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFindings() => $_has(2);
  @$pb.TagNumber(3)
  void clearFindings() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get noActionReason => $_getSZ(3);
  @$pb.TagNumber(4)
  set noActionReason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNoActionReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearNoActionReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get expectedVersion => $_getI64(4);
  @$pb.TagNumber(5)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpectedVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpectedVersion() => $_clearField(5);
}

class CompleteRcaResponse extends $pb.GeneratedMessage {
  factory CompleteRcaResponse({
    RootCauseAnalysis? rca,
  }) {
    final result = create();
    if (rca != null) result.rca = rca;
    return result;
  }

  CompleteRcaResponse._();

  factory CompleteRcaResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteRcaResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteRcaResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<RootCauseAnalysis>(1, _omitFieldNames ? '' : 'rca',
        subBuilder: RootCauseAnalysis.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteRcaResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteRcaResponse copyWith(void Function(CompleteRcaResponse) updates) =>
      super.copyWith((message) => updates(message as CompleteRcaResponse))
          as CompleteRcaResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteRcaResponse create() => CompleteRcaResponse._();
  @$core.override
  CompleteRcaResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteRcaResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteRcaResponse>(create);
  static CompleteRcaResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RootCauseAnalysis get rca => $_getN(0);
  @$pb.TagNumber(1)
  set rca(RootCauseAnalysis value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRca() => $_has(0);
  @$pb.TagNumber(1)
  void clearRca() => $_clearField(1);
  @$pb.TagNumber(1)
  RootCauseAnalysis ensureRca() => $_ensure(0);
}

class GetRcaRequest extends $pb.GeneratedMessage {
  factory GetRcaRequest({
    $core.String? rcaId,
  }) {
    final result = create();
    if (rcaId != null) result.rcaId = rcaId;
    return result;
  }

  GetRcaRequest._();

  factory GetRcaRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRcaRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRcaRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'rcaId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRcaRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRcaRequest copyWith(void Function(GetRcaRequest) updates) =>
      super.copyWith((message) => updates(message as GetRcaRequest))
          as GetRcaRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRcaRequest create() => GetRcaRequest._();
  @$core.override
  GetRcaRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRcaRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRcaRequest>(create);
  static GetRcaRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rcaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set rcaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRcaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRcaId() => $_clearField(1);
}

class GetRcaResponse extends $pb.GeneratedMessage {
  factory GetRcaResponse({
    RootCauseAnalysis? rca,
  }) {
    final result = create();
    if (rca != null) result.rca = rca;
    return result;
  }

  GetRcaResponse._();

  factory GetRcaResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRcaResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRcaResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<RootCauseAnalysis>(1, _omitFieldNames ? '' : 'rca',
        subBuilder: RootCauseAnalysis.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRcaResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRcaResponse copyWith(void Function(GetRcaResponse) updates) =>
      super.copyWith((message) => updates(message as GetRcaResponse))
          as GetRcaResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRcaResponse create() => GetRcaResponse._();
  @$core.override
  GetRcaResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRcaResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRcaResponse>(create);
  static GetRcaResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RootCauseAnalysis get rca => $_getN(0);
  @$pb.TagNumber(1)
  set rca(RootCauseAnalysis value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRca() => $_has(0);
  @$pb.TagNumber(1)
  void clearRca() => $_clearField(1);
  @$pb.TagNumber(1)
  RootCauseAnalysis ensureRca() => $_ensure(0);
}

/// EffectivenessCheck says whether an action worked (SRS-QMS-004).
class EffectivenessCheck extends $pb.GeneratedMessage {
  factory EffectivenessCheck({
    $0.Timestamp? checkedAt,
    $core.String? checkedBy,
    $core.bool? effective,
    $core.String? evidence,
  }) {
    final result = create();
    if (checkedAt != null) result.checkedAt = checkedAt;
    if (checkedBy != null) result.checkedBy = checkedBy;
    if (effective != null) result.effective = effective;
    if (evidence != null) result.evidence = evidence;
    return result;
  }

  EffectivenessCheck._();

  factory EffectivenessCheck.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EffectivenessCheck.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EffectivenessCheck',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'checkedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(2, _omitFieldNames ? '' : 'checkedBy')
    ..aOB(3, _omitFieldNames ? '' : 'effective')
    ..aOS(4, _omitFieldNames ? '' : 'evidence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EffectivenessCheck clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EffectivenessCheck copyWith(void Function(EffectivenessCheck) updates) =>
      super.copyWith((message) => updates(message as EffectivenessCheck))
          as EffectivenessCheck;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EffectivenessCheck create() => EffectivenessCheck._();
  @$core.override
  EffectivenessCheck createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EffectivenessCheck getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EffectivenessCheck>(create);
  static EffectivenessCheck? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get checkedAt => $_getN(0);
  @$pb.TagNumber(1)
  set checkedAt($0.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCheckedAt() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheckedAt() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureCheckedAt() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get checkedBy => $_getSZ(1);
  @$pb.TagNumber(2)
  set checkedBy($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCheckedBy() => $_has(1);
  @$pb.TagNumber(2)
  void clearCheckedBy() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get effective => $_getBF(2);
  @$pb.TagNumber(3)
  set effective($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEffective() => $_has(2);
  @$pb.TagNumber(3)
  void clearEffective() => $_clearField(3);

  /// What was looked at. "It worked" is an opinion; a re-audit result is a
  /// fact.
  @$pb.TagNumber(4)
  $core.String get evidence => $_getSZ(3);
  @$pb.TagNumber(4)
  set evidence($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEvidence() => $_has(3);
  @$pb.TagNumber(4)
  void clearEvidence() => $_clearField(4);
}

/// CorrectiveAction is one corrective or preventive action (SRS-QMS-004).
class CorrectiveAction extends $pb.GeneratedMessage {
  factory CorrectiveAction({
    $core.String? capaId,
    $core.String? reference,
    ActionKind? kind,
    ActionSource? sourceKind,
    $core.String? sourceId,
    $core.String? action,
    $core.String? ownerId,
    $0.Timestamp? dueOn,
    $0.Timestamp? effectivenessDueOn,
    ActionState? state,
    $core.String? approvedBy,
    $0.Timestamp? approvedAt,
    $core.Iterable<EffectivenessCheck>? checks,
    $core.String? closedBy,
    $0.Timestamp? closedAt,
    $core.String? closureNote,
    $core.String? cancelledReason,
    $core.bool? restricted,
    $0.Timestamp? raisedAt,
    $core.String? raisedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (capaId != null) result.capaId = capaId;
    if (reference != null) result.reference = reference;
    if (kind != null) result.kind = kind;
    if (sourceKind != null) result.sourceKind = sourceKind;
    if (sourceId != null) result.sourceId = sourceId;
    if (action != null) result.action = action;
    if (ownerId != null) result.ownerId = ownerId;
    if (dueOn != null) result.dueOn = dueOn;
    if (effectivenessDueOn != null)
      result.effectivenessDueOn = effectivenessDueOn;
    if (state != null) result.state = state;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (checks != null) result.checks.addAll(checks);
    if (closedBy != null) result.closedBy = closedBy;
    if (closedAt != null) result.closedAt = closedAt;
    if (closureNote != null) result.closureNote = closureNote;
    if (cancelledReason != null) result.cancelledReason = cancelledReason;
    if (restricted != null) result.restricted = restricted;
    if (raisedAt != null) result.raisedAt = raisedAt;
    if (raisedBy != null) result.raisedBy = raisedBy;
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
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'capaId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aE<ActionKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: ActionKind.values)
    ..aE<ActionSource>(4, _omitFieldNames ? '' : 'sourceKind',
        enumValues: ActionSource.values)
    ..aOS(5, _omitFieldNames ? '' : 'sourceId')
    ..aOS(6, _omitFieldNames ? '' : 'action')
    ..aOS(7, _omitFieldNames ? '' : 'ownerId')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'dueOn',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'effectivenessDueOn',
        subBuilder: $0.Timestamp.create)
    ..aE<ActionState>(10, _omitFieldNames ? '' : 'state',
        enumValues: ActionState.values)
    ..aOS(11, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'approvedAt',
        subBuilder: $0.Timestamp.create)
    ..pPM<EffectivenessCheck>(13, _omitFieldNames ? '' : 'checks',
        subBuilder: EffectivenessCheck.create)
    ..aOS(14, _omitFieldNames ? '' : 'closedBy')
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'closureNote')
    ..aOS(17, _omitFieldNames ? '' : 'cancelledReason')
    ..aOB(18, _omitFieldNames ? '' : 'restricted')
    ..aOM<$0.Timestamp>(19, _omitFieldNames ? '' : 'raisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(20, _omitFieldNames ? '' : 'raisedBy')
    ..aInt64(21, _omitFieldNames ? '' : 'version')
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
  $core.String get capaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set capaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCapaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCapaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reference => $_getSZ(1);
  @$pb.TagNumber(2)
  set reference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearReference() => $_clearField(2);

  @$pb.TagNumber(3)
  ActionKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(ActionKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  ActionSource get sourceKind => $_getN(3);
  @$pb.TagNumber(4)
  set sourceKind(ActionSource value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sourceId => $_getSZ(4);
  @$pb.TagNumber(5)
  set sourceId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSourceId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourceId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get action => $_getSZ(5);
  @$pb.TagNumber(6)
  set action($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAction() => $_has(5);
  @$pb.TagNumber(6)
  void clearAction() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get ownerId => $_getSZ(6);
  @$pb.TagNumber(7)
  set ownerId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOwnerId() => $_has(6);
  @$pb.TagNumber(7)
  void clearOwnerId() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get dueOn => $_getN(7);
  @$pb.TagNumber(8)
  set dueOn($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDueOn() => $_has(7);
  @$pb.TagNumber(8)
  void clearDueOn() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureDueOn() => $_ensure(7);

  /// Separate from the action's own due date, because the check is meaningless
  /// before the change has had time to be used.
  @$pb.TagNumber(9)
  $0.Timestamp get effectivenessDueOn => $_getN(8);
  @$pb.TagNumber(9)
  set effectivenessDueOn($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasEffectivenessDueOn() => $_has(8);
  @$pb.TagNumber(9)
  void clearEffectivenessDueOn() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureEffectivenessDueOn() => $_ensure(8);

  @$pb.TagNumber(10)
  ActionState get state => $_getN(9);
  @$pb.TagNumber(10)
  set state(ActionState value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasState() => $_has(9);
  @$pb.TagNumber(10)
  void clearState() => $_clearField(10);

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

  /// Every check, including the ones that failed.
  @$pb.TagNumber(13)
  $pb.PbList<EffectivenessCheck> get checks => $_getList(12);

  @$pb.TagNumber(14)
  $core.String get closedBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set closedBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasClosedBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearClosedBy() => $_clearField(14);

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
  $core.String get closureNote => $_getSZ(15);
  @$pb.TagNumber(16)
  set closureNote($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasClosureNote() => $_has(15);
  @$pb.TagNumber(16)
  void clearClosureNote() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get cancelledReason => $_getSZ(16);
  @$pb.TagNumber(17)
  set cancelledReason($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasCancelledReason() => $_has(16);
  @$pb.TagNumber(17)
  void clearCancelledReason() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.bool get restricted => $_getBF(17);
  @$pb.TagNumber(18)
  set restricted($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(18)
  $core.bool hasRestricted() => $_has(17);
  @$pb.TagNumber(18)
  void clearRestricted() => $_clearField(18);

  @$pb.TagNumber(19)
  $0.Timestamp get raisedAt => $_getN(18);
  @$pb.TagNumber(19)
  set raisedAt($0.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasRaisedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearRaisedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Timestamp ensureRaisedAt() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.String get raisedBy => $_getSZ(19);
  @$pb.TagNumber(20)
  set raisedBy($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasRaisedBy() => $_has(19);
  @$pb.TagNumber(20)
  void clearRaisedBy() => $_clearField(20);

  @$pb.TagNumber(21)
  $fixnum.Int64 get version => $_getI64(20);
  @$pb.TagNumber(21)
  set version($fixnum.Int64 value) => $_setInt64(20, value);
  @$pb.TagNumber(21)
  $core.bool hasVersion() => $_has(20);
  @$pb.TagNumber(21)
  void clearVersion() => $_clearField(21);
}

class RaiseActionRequest extends $pb.GeneratedMessage {
  factory RaiseActionRequest({
    $core.String? reference,
    ActionKind? kind,
    ActionSource? sourceKind,
    $core.String? sourceId,
    $core.String? action,
    $core.String? ownerId,
    $0.Timestamp? dueOn,
    $0.Timestamp? effectivenessDueOn,
    $core.bool? restricted,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    if (kind != null) result.kind = kind;
    if (sourceKind != null) result.sourceKind = sourceKind;
    if (sourceId != null) result.sourceId = sourceId;
    if (action != null) result.action = action;
    if (ownerId != null) result.ownerId = ownerId;
    if (dueOn != null) result.dueOn = dueOn;
    if (effectivenessDueOn != null)
      result.effectivenessDueOn = effectivenessDueOn;
    if (restricted != null) result.restricted = restricted;
    return result;
  }

  RaiseActionRequest._();

  factory RaiseActionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseActionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseActionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..aE<ActionKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: ActionKind.values)
    ..aE<ActionSource>(3, _omitFieldNames ? '' : 'sourceKind',
        enumValues: ActionSource.values)
    ..aOS(4, _omitFieldNames ? '' : 'sourceId')
    ..aOS(5, _omitFieldNames ? '' : 'action')
    ..aOS(6, _omitFieldNames ? '' : 'ownerId')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'dueOn',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'effectivenessDueOn',
        subBuilder: $0.Timestamp.create)
    ..aOB(9, _omitFieldNames ? '' : 'restricted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseActionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseActionRequest copyWith(void Function(RaiseActionRequest) updates) =>
      super.copyWith((message) => updates(message as RaiseActionRequest))
          as RaiseActionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseActionRequest create() => RaiseActionRequest._();
  @$core.override
  RaiseActionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseActionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseActionRequest>(create);
  static RaiseActionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reference => $_getSZ(0);
  @$pb.TagNumber(1)
  set reference($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReference() => $_has(0);
  @$pb.TagNumber(1)
  void clearReference() => $_clearField(1);

  @$pb.TagNumber(2)
  ActionKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(ActionKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  ActionSource get sourceKind => $_getN(2);
  @$pb.TagNumber(3)
  set sourceKind(ActionSource value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSourceKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sourceId => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourceId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get action => $_getSZ(4);
  @$pb.TagNumber(5)
  set action($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAction() => $_has(4);
  @$pb.TagNumber(5)
  void clearAction() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get ownerId => $_getSZ(5);
  @$pb.TagNumber(6)
  set ownerId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOwnerId() => $_has(5);
  @$pb.TagNumber(6)
  void clearOwnerId() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get dueOn => $_getN(6);
  @$pb.TagNumber(7)
  set dueOn($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDueOn() => $_has(6);
  @$pb.TagNumber(7)
  void clearDueOn() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureDueOn() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get effectivenessDueOn => $_getN(7);
  @$pb.TagNumber(8)
  set effectivenessDueOn($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasEffectivenessDueOn() => $_has(7);
  @$pb.TagNumber(8)
  void clearEffectivenessDueOn() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureEffectivenessDueOn() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.bool get restricted => $_getBF(8);
  @$pb.TagNumber(9)
  set restricted($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRestricted() => $_has(8);
  @$pb.TagNumber(9)
  void clearRestricted() => $_clearField(9);
}

class RaiseActionResponse extends $pb.GeneratedMessage {
  factory RaiseActionResponse({
    CorrectiveAction? action,
  }) {
    final result = create();
    if (action != null) result.action = action;
    return result;
  }

  RaiseActionResponse._();

  factory RaiseActionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseActionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseActionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<CorrectiveAction>(1, _omitFieldNames ? '' : 'action',
        subBuilder: CorrectiveAction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseActionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseActionResponse copyWith(void Function(RaiseActionResponse) updates) =>
      super.copyWith((message) => updates(message as RaiseActionResponse))
          as RaiseActionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseActionResponse create() => RaiseActionResponse._();
  @$core.override
  RaiseActionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseActionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseActionResponse>(create);
  static RaiseActionResponse? _defaultInstance;

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

class ApproveActionRequest extends $pb.GeneratedMessage {
  factory ApproveActionRequest({
    $core.String? capaId,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (capaId != null) result.capaId = capaId;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  ApproveActionRequest._();

  factory ApproveActionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveActionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveActionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'capaId')
    ..aInt64(2, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveActionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveActionRequest copyWith(void Function(ApproveActionRequest) updates) =>
      super.copyWith((message) => updates(message as ApproveActionRequest))
          as ApproveActionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveActionRequest create() => ApproveActionRequest._();
  @$core.override
  ApproveActionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveActionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveActionRequest>(create);
  static ApproveActionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get capaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set capaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCapaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCapaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expectedVersion => $_getI64(1);
  @$pb.TagNumber(2)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedVersion() => $_clearField(2);
}

class ApproveActionResponse extends $pb.GeneratedMessage {
  factory ApproveActionResponse({
    CorrectiveAction? action,
  }) {
    final result = create();
    if (action != null) result.action = action;
    return result;
  }

  ApproveActionResponse._();

  factory ApproveActionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveActionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveActionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<CorrectiveAction>(1, _omitFieldNames ? '' : 'action',
        subBuilder: CorrectiveAction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveActionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveActionResponse copyWith(
          void Function(ApproveActionResponse) updates) =>
      super.copyWith((message) => updates(message as ApproveActionResponse))
          as ApproveActionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveActionResponse create() => ApproveActionResponse._();
  @$core.override
  ApproveActionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveActionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveActionResponse>(create);
  static ApproveActionResponse? _defaultInstance;

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

class AdvanceActionRequest extends $pb.GeneratedMessage {
  factory AdvanceActionRequest({
    $core.String? capaId,
    ActionState? state,
    $core.String? reason,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (capaId != null) result.capaId = capaId;
    if (state != null) result.state = state;
    if (reason != null) result.reason = reason;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  AdvanceActionRequest._();

  factory AdvanceActionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvanceActionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvanceActionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'capaId')
    ..aE<ActionState>(2, _omitFieldNames ? '' : 'state',
        enumValues: ActionState.values)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aInt64(4, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceActionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceActionRequest copyWith(void Function(AdvanceActionRequest) updates) =>
      super.copyWith((message) => updates(message as AdvanceActionRequest))
          as AdvanceActionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvanceActionRequest create() => AdvanceActionRequest._();
  @$core.override
  AdvanceActionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvanceActionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvanceActionRequest>(create);
  static AdvanceActionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get capaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set capaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCapaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCapaId() => $_clearField(1);

  @$pb.TagNumber(2)
  ActionState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(ActionState value) => $_setField(2, value);
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

  @$pb.TagNumber(4)
  $fixnum.Int64 get expectedVersion => $_getI64(3);
  @$pb.TagNumber(4)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedVersion() => $_clearField(4);
}

class AdvanceActionResponse extends $pb.GeneratedMessage {
  factory AdvanceActionResponse({
    CorrectiveAction? action,
  }) {
    final result = create();
    if (action != null) result.action = action;
    return result;
  }

  AdvanceActionResponse._();

  factory AdvanceActionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvanceActionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvanceActionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<CorrectiveAction>(1, _omitFieldNames ? '' : 'action',
        subBuilder: CorrectiveAction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceActionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceActionResponse copyWith(
          void Function(AdvanceActionResponse) updates) =>
      super.copyWith((message) => updates(message as AdvanceActionResponse))
          as AdvanceActionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvanceActionResponse create() => AdvanceActionResponse._();
  @$core.override
  AdvanceActionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvanceActionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvanceActionResponse>(create);
  static AdvanceActionResponse? _defaultInstance;

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

/// RecordEffectivenessRequest records a review of whether an action worked.
///
/// A failed check is recorded and returns the action to work rather than being
/// discarded: "we checked and it had not worked" is the finding.
class RecordEffectivenessRequest extends $pb.GeneratedMessage {
  factory RecordEffectivenessRequest({
    $core.String? capaId,
    $core.bool? effective,
    $core.String? evidence,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (capaId != null) result.capaId = capaId;
    if (effective != null) result.effective = effective;
    if (evidence != null) result.evidence = evidence;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  RecordEffectivenessRequest._();

  factory RecordEffectivenessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordEffectivenessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordEffectivenessRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'capaId')
    ..aOB(2, _omitFieldNames ? '' : 'effective')
    ..aOS(3, _omitFieldNames ? '' : 'evidence')
    ..aInt64(4, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordEffectivenessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordEffectivenessRequest copyWith(
          void Function(RecordEffectivenessRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RecordEffectivenessRequest))
          as RecordEffectivenessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordEffectivenessRequest create() => RecordEffectivenessRequest._();
  @$core.override
  RecordEffectivenessRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordEffectivenessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordEffectivenessRequest>(create);
  static RecordEffectivenessRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get capaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set capaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCapaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCapaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get effective => $_getBF(1);
  @$pb.TagNumber(2)
  set effective($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEffective() => $_has(1);
  @$pb.TagNumber(2)
  void clearEffective() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get evidence => $_getSZ(2);
  @$pb.TagNumber(3)
  set evidence($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEvidence() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvidence() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expectedVersion => $_getI64(3);
  @$pb.TagNumber(4)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedVersion() => $_clearField(4);
}

class RecordEffectivenessResponse extends $pb.GeneratedMessage {
  factory RecordEffectivenessResponse({
    CorrectiveAction? action,
  }) {
    final result = create();
    if (action != null) result.action = action;
    return result;
  }

  RecordEffectivenessResponse._();

  factory RecordEffectivenessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordEffectivenessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordEffectivenessResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<CorrectiveAction>(1, _omitFieldNames ? '' : 'action',
        subBuilder: CorrectiveAction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordEffectivenessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordEffectivenessResponse copyWith(
          void Function(RecordEffectivenessResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RecordEffectivenessResponse))
          as RecordEffectivenessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordEffectivenessResponse create() =>
      RecordEffectivenessResponse._();
  @$core.override
  RecordEffectivenessResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordEffectivenessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordEffectivenessResponse>(create);
  static RecordEffectivenessResponse? _defaultInstance;

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

class CloseActionRequest extends $pb.GeneratedMessage {
  factory CloseActionRequest({
    $core.String? capaId,
    $core.String? note,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (capaId != null) result.capaId = capaId;
    if (note != null) result.note = note;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  CloseActionRequest._();

  factory CloseActionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseActionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseActionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'capaId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..aInt64(3, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseActionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseActionRequest copyWith(void Function(CloseActionRequest) updates) =>
      super.copyWith((message) => updates(message as CloseActionRequest))
          as CloseActionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseActionRequest create() => CloseActionRequest._();
  @$core.override
  CloseActionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseActionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseActionRequest>(create);
  static CloseActionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get capaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set capaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCapaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCapaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedVersion => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedVersion() => $_clearField(3);
}

class CloseActionResponse extends $pb.GeneratedMessage {
  factory CloseActionResponse({
    CorrectiveAction? action,
  }) {
    final result = create();
    if (action != null) result.action = action;
    return result;
  }

  CloseActionResponse._();

  factory CloseActionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseActionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseActionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<CorrectiveAction>(1, _omitFieldNames ? '' : 'action',
        subBuilder: CorrectiveAction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseActionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseActionResponse copyWith(void Function(CloseActionResponse) updates) =>
      super.copyWith((message) => updates(message as CloseActionResponse))
          as CloseActionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseActionResponse create() => CloseActionResponse._();
  @$core.override
  CloseActionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseActionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseActionResponse>(create);
  static CloseActionResponse? _defaultInstance;

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

class GetActionRequest extends $pb.GeneratedMessage {
  factory GetActionRequest({
    $core.String? capaId,
  }) {
    final result = create();
    if (capaId != null) result.capaId = capaId;
    return result;
  }

  GetActionRequest._();

  factory GetActionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetActionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetActionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'capaId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActionRequest copyWith(void Function(GetActionRequest) updates) =>
      super.copyWith((message) => updates(message as GetActionRequest))
          as GetActionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetActionRequest create() => GetActionRequest._();
  @$core.override
  GetActionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetActionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetActionRequest>(create);
  static GetActionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get capaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set capaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCapaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCapaId() => $_clearField(1);
}

class GetActionResponse extends $pb.GeneratedMessage {
  factory GetActionResponse({
    CorrectiveAction? action,
  }) {
    final result = create();
    if (action != null) result.action = action;
    return result;
  }

  GetActionResponse._();

  factory GetActionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetActionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetActionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<CorrectiveAction>(1, _omitFieldNames ? '' : 'action',
        subBuilder: CorrectiveAction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActionResponse copyWith(void Function(GetActionResponse) updates) =>
      super.copyWith((message) => updates(message as GetActionResponse))
          as GetActionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetActionResponse create() => GetActionResponse._();
  @$core.override
  GetActionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetActionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetActionResponse>(create);
  static GetActionResponse? _defaultInstance;

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

class ListActionsRequest extends $pb.GeneratedMessage {
  factory ListActionsRequest({
    ActionSource? sourceKind,
    $core.String? sourceId,
    $core.String? ownerId,
    $core.bool? liveOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (sourceKind != null) result.sourceKind = sourceKind;
    if (sourceId != null) result.sourceId = sourceId;
    if (ownerId != null) result.ownerId = ownerId;
    if (liveOnly != null) result.liveOnly = liveOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListActionsRequest._();

  factory ListActionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListActionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListActionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aE<ActionSource>(1, _omitFieldNames ? '' : 'sourceKind',
        enumValues: ActionSource.values)
    ..aOS(2, _omitFieldNames ? '' : 'sourceId')
    ..aOS(3, _omitFieldNames ? '' : 'ownerId')
    ..aOB(4, _omitFieldNames ? '' : 'liveOnly')
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListActionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListActionsRequest copyWith(void Function(ListActionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListActionsRequest))
          as ListActionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListActionsRequest create() => ListActionsRequest._();
  @$core.override
  ListActionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListActionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListActionsRequest>(create);
  static ListActionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ActionSource get sourceKind => $_getN(0);
  @$pb.TagNumber(1)
  set sourceKind(ActionSource value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSourceKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearSourceKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sourceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sourceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSourceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get ownerId => $_getSZ(2);
  @$pb.TagNumber(3)
  set ownerId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOwnerId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOwnerId() => $_clearField(3);

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
}

class ListActionsResponse extends $pb.GeneratedMessage {
  factory ListActionsResponse({
    $core.Iterable<CorrectiveAction>? actions,
  }) {
    final result = create();
    if (actions != null) result.actions.addAll(actions);
    return result;
  }

  ListActionsResponse._();

  factory ListActionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListActionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListActionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<CorrectiveAction>(1, _omitFieldNames ? '' : 'actions',
        subBuilder: CorrectiveAction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListActionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListActionsResponse copyWith(void Function(ListActionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListActionsResponse))
          as ListActionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListActionsResponse create() => ListActionsResponse._();
  @$core.override
  ListActionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListActionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListActionsResponse>(create);
  static ListActionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CorrectiveAction> get actions => $_getList(0);
}

/// OverdueAction is one action past a date it should have met (SRS-QMS-004).
class OverdueAction extends $pb.GeneratedMessage {
  factory OverdueAction({
    CorrectiveAction? action,
    $core.int? actionOverdueDays,
    $core.int? checkOverdueDays,
  }) {
    final result = create();
    if (action != null) result.action = action;
    if (actionOverdueDays != null) result.actionOverdueDays = actionOverdueDays;
    if (checkOverdueDays != null) result.checkOverdueDays = checkOverdueDays;
    return result;
  }

  OverdueAction._();

  factory OverdueAction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OverdueAction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OverdueAction',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<CorrectiveAction>(1, _omitFieldNames ? '' : 'action',
        subBuilder: CorrectiveAction.create)
    ..aI(2, _omitFieldNames ? '' : 'actionOverdueDays')
    ..aI(3, _omitFieldNames ? '' : 'checkOverdueDays')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverdueAction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverdueAction copyWith(void Function(OverdueAction) updates) =>
      super.copyWith((message) => updates(message as OverdueAction))
          as OverdueAction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OverdueAction create() => OverdueAction._();
  @$core.override
  OverdueAction createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OverdueAction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OverdueAction>(create);
  static OverdueAction? _defaultInstance;

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

  /// Reported separately, because an action that was done on time and never
  /// checked is a different failure from one that was never done.
  @$pb.TagNumber(2)
  $core.int get actionOverdueDays => $_getIZ(1);
  @$pb.TagNumber(2)
  set actionOverdueDays($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActionOverdueDays() => $_has(1);
  @$pb.TagNumber(2)
  void clearActionOverdueDays() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get checkOverdueDays => $_getIZ(2);
  @$pb.TagNumber(3)
  set checkOverdueDays($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCheckOverdueDays() => $_has(2);
  @$pb.TagNumber(3)
  void clearCheckOverdueDays() => $_clearField(3);
}

class ListOverdueActionsRequest extends $pb.GeneratedMessage {
  factory ListOverdueActionsRequest() => create();

  ListOverdueActionsRequest._();

  factory ListOverdueActionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOverdueActionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOverdueActionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOverdueActionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOverdueActionsRequest copyWith(
          void Function(ListOverdueActionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListOverdueActionsRequest))
          as ListOverdueActionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOverdueActionsRequest create() => ListOverdueActionsRequest._();
  @$core.override
  ListOverdueActionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOverdueActionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOverdueActionsRequest>(create);
  static ListOverdueActionsRequest? _defaultInstance;
}

class ListOverdueActionsResponse extends $pb.GeneratedMessage {
  factory ListOverdueActionsResponse({
    $core.Iterable<OverdueAction>? overdue,
  }) {
    final result = create();
    if (overdue != null) result.overdue.addAll(overdue);
    return result;
  }

  ListOverdueActionsResponse._();

  factory ListOverdueActionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOverdueActionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOverdueActionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<OverdueAction>(1, _omitFieldNames ? '' : 'overdue',
        subBuilder: OverdueAction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOverdueActionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOverdueActionsResponse copyWith(
          void Function(ListOverdueActionsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListOverdueActionsResponse))
          as ListOverdueActionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOverdueActionsResponse create() => ListOverdueActionsResponse._();
  @$core.override
  ListOverdueActionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOverdueActionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOverdueActionsResponse>(create);
  static ListOverdueActionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<OverdueAction> get overdue => $_getList(0);
}

class EscalateOverdueActionsRequest extends $pb.GeneratedMessage {
  factory EscalateOverdueActionsRequest() => create();

  EscalateOverdueActionsRequest._();

  factory EscalateOverdueActionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EscalateOverdueActionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EscalateOverdueActionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateOverdueActionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateOverdueActionsRequest copyWith(
          void Function(EscalateOverdueActionsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as EscalateOverdueActionsRequest))
          as EscalateOverdueActionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EscalateOverdueActionsRequest create() =>
      EscalateOverdueActionsRequest._();
  @$core.override
  EscalateOverdueActionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EscalateOverdueActionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EscalateOverdueActionsRequest>(create);
  static EscalateOverdueActionsRequest? _defaultInstance;
}

class EscalateOverdueActionsResponse extends $pb.GeneratedMessage {
  factory EscalateOverdueActionsResponse({
    $core.int? raised,
  }) {
    final result = create();
    if (raised != null) result.raised = raised;
    return result;
  }

  EscalateOverdueActionsResponse._();

  factory EscalateOverdueActionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EscalateOverdueActionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EscalateOverdueActionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'raised')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateOverdueActionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateOverdueActionsResponse copyWith(
          void Function(EscalateOverdueActionsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as EscalateOverdueActionsResponse))
          as EscalateOverdueActionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EscalateOverdueActionsResponse create() =>
      EscalateOverdueActionsResponse._();
  @$core.override
  EscalateOverdueActionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EscalateOverdueActionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EscalateOverdueActionsResponse>(create);
  static EscalateOverdueActionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get raised => $_getIZ(0);
  @$pb.TagNumber(1)
  set raised($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRaised() => $_has(0);
  @$pb.TagNumber(1)
  void clearRaised() => $_clearField(1);
}

/// ControlledDocument is a policy, SOP or protocol under version control
/// (SRS-QMS-006).
class ControlledDocument extends $pb.GeneratedMessage {
  factory ControlledDocument({
    $core.String? documentId,
    $core.String? code,
    $core.String? title,
    DocumentKind? kind,
    $core.String? ownerId,
    $core.int? reviewMonths,
    $core.String? department,
    $core.bool? withdrawn,
    $0.Timestamp? withdrawnAt,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (documentId != null) result.documentId = documentId;
    if (code != null) result.code = code;
    if (title != null) result.title = title;
    if (kind != null) result.kind = kind;
    if (ownerId != null) result.ownerId = ownerId;
    if (reviewMonths != null) result.reviewMonths = reviewMonths;
    if (department != null) result.department = department;
    if (withdrawn != null) result.withdrawn = withdrawn;
    if (withdrawnAt != null) result.withdrawnAt = withdrawnAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  ControlledDocument._();

  factory ControlledDocument.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ControlledDocument.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ControlledDocument',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'documentId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aE<DocumentKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: DocumentKind.values)
    ..aOS(5, _omitFieldNames ? '' : 'ownerId')
    ..aI(6, _omitFieldNames ? '' : 'reviewMonths')
    ..aOS(7, _omitFieldNames ? '' : 'department')
    ..aOB(8, _omitFieldNames ? '' : 'withdrawn')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'withdrawnAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(12, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ControlledDocument clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ControlledDocument copyWith(void Function(ControlledDocument) updates) =>
      super.copyWith((message) => updates(message as ControlledDocument))
          as ControlledDocument;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ControlledDocument create() => ControlledDocument._();
  @$core.override
  ControlledDocument createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ControlledDocument getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ControlledDocument>(create);
  static ControlledDocument? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get documentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set documentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  DocumentKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(DocumentKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get ownerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set ownerId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOwnerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearOwnerId() => $_clearField(5);

  /// Zero means nobody has decided, which the readiness report names rather
  /// than treating as "never expires".
  @$pb.TagNumber(6)
  $core.int get reviewMonths => $_getIZ(5);
  @$pb.TagNumber(6)
  set reviewMonths($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReviewMonths() => $_has(5);
  @$pb.TagNumber(6)
  void clearReviewMonths() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get department => $_getSZ(6);
  @$pb.TagNumber(7)
  set department($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDepartment() => $_has(6);
  @$pb.TagNumber(7)
  void clearDepartment() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get withdrawn => $_getBF(7);
  @$pb.TagNumber(8)
  set withdrawn($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasWithdrawn() => $_has(7);
  @$pb.TagNumber(8)
  void clearWithdrawn() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get withdrawnAt => $_getN(8);
  @$pb.TagNumber(9)
  set withdrawnAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasWithdrawnAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearWithdrawnAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureWithdrawnAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get createdAt => $_getN(9);
  @$pb.TagNumber(10)
  set createdAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureCreatedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get createdBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set createdBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCreatedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreatedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get version => $_getI64(11);
  @$pb.TagNumber(12)
  set version($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasVersion() => $_has(11);
  @$pb.TagNumber(12)
  void clearVersion() => $_clearField(12);
}

/// DocumentVersion is one revision (SRS-QMS-006).
class DocumentVersion extends $pb.GeneratedMessage {
  factory DocumentVersion({
    $core.String? versionId,
    $core.String? documentId,
    $core.String? label,
    $core.int? ordinal,
    $core.String? contentRef,
    $core.String? changeSummary,
    VersionState? state,
    $core.String? approvedBy,
    $0.Timestamp? approvedAt,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? obsoleteFrom,
    $core.bool? requiresAcknowledgement,
    $core.bool? requiresRetraining,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (versionId != null) result.versionId = versionId;
    if (documentId != null) result.documentId = documentId;
    if (label != null) result.label = label;
    if (ordinal != null) result.ordinal = ordinal;
    if (contentRef != null) result.contentRef = contentRef;
    if (changeSummary != null) result.changeSummary = changeSummary;
    if (state != null) result.state = state;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (obsoleteFrom != null) result.obsoleteFrom = obsoleteFrom;
    if (requiresAcknowledgement != null)
      result.requiresAcknowledgement = requiresAcknowledgement;
    if (requiresRetraining != null)
      result.requiresRetraining = requiresRetraining;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  DocumentVersion._();

  factory DocumentVersion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DocumentVersion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DocumentVersion',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'versionId')
    ..aOS(2, _omitFieldNames ? '' : 'documentId')
    ..aOS(3, _omitFieldNames ? '' : 'label')
    ..aI(4, _omitFieldNames ? '' : 'ordinal')
    ..aOS(5, _omitFieldNames ? '' : 'contentRef')
    ..aOS(6, _omitFieldNames ? '' : 'changeSummary')
    ..aE<VersionState>(7, _omitFieldNames ? '' : 'state',
        enumValues: VersionState.values)
    ..aOS(8, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'approvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'obsoleteFrom',
        subBuilder: $0.Timestamp.create)
    ..aOB(12, _omitFieldNames ? '' : 'requiresAcknowledgement')
    ..aOB(13, _omitFieldNames ? '' : 'requiresRetraining')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(16, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DocumentVersion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DocumentVersion copyWith(void Function(DocumentVersion) updates) =>
      super.copyWith((message) => updates(message as DocumentVersion))
          as DocumentVersion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DocumentVersion create() => DocumentVersion._();
  @$core.override
  DocumentVersion createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DocumentVersion getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DocumentVersion>(create);
  static DocumentVersion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get versionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set versionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get documentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set documentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDocumentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDocumentId() => $_clearField(2);

  /// What the hospital calls it. The ordinal is what the system orders by,
  /// because "10" sorts before "9" as a string.
  @$pb.TagNumber(3)
  $core.String get label => $_getSZ(2);
  @$pb.TagNumber(3)
  set label($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLabel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLabel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get ordinal => $_getIZ(3);
  @$pb.TagNumber(4)
  set ordinal($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOrdinal() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrdinal() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get contentRef => $_getSZ(4);
  @$pb.TagNumber(5)
  set contentRef($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContentRef() => $_has(4);
  @$pb.TagNumber(5)
  void clearContentRef() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get changeSummary => $_getSZ(5);
  @$pb.TagNumber(6)
  set changeSummary($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasChangeSummary() => $_has(5);
  @$pb.TagNumber(6)
  void clearChangeSummary() => $_clearField(6);

  @$pb.TagNumber(7)
  VersionState get state => $_getN(6);
  @$pb.TagNumber(7)
  set state(VersionState value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasState() => $_has(6);
  @$pb.TagNumber(7)
  void clearState() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get approvedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set approvedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasApprovedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearApprovedBy() => $_clearField(8);

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

  /// May be in the future: that is how a hospital publishes a policy change
  /// before the date it starts applying.
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

  @$pb.TagNumber(11)
  $0.Timestamp get obsoleteFrom => $_getN(10);
  @$pb.TagNumber(11)
  set obsoleteFrom($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasObsoleteFrom() => $_has(10);
  @$pb.TagNumber(11)
  void clearObsoleteFrom() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureObsoleteFrom() => $_ensure(10);

  /// Per version. Acknowledging version 1 says nothing about version 2.
  @$pb.TagNumber(12)
  $core.bool get requiresAcknowledgement => $_getBF(11);
  @$pb.TagNumber(12)
  set requiresAcknowledgement($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRequiresAcknowledgement() => $_has(11);
  @$pb.TagNumber(12)
  void clearRequiresAcknowledgement() => $_clearField(12);

  /// Expires competencies awarded against earlier versions. Not every revision
  /// does: a typo correction should not invalidate a ward's training records.
  @$pb.TagNumber(13)
  $core.bool get requiresRetraining => $_getBF(12);
  @$pb.TagNumber(13)
  set requiresRetraining($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRequiresRetraining() => $_has(12);
  @$pb.TagNumber(13)
  void clearRequiresRetraining() => $_clearField(13);

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

  @$pb.TagNumber(16)
  $fixnum.Int64 get version => $_getI64(15);
  @$pb.TagNumber(16)
  set version($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasVersion() => $_has(15);
  @$pb.TagNumber(16)
  void clearVersion() => $_clearField(16);
}

class RegisterDocumentRequest extends $pb.GeneratedMessage {
  factory RegisterDocumentRequest({
    $core.String? code,
    $core.String? title,
    DocumentKind? kind,
    $core.String? ownerId,
    $core.int? reviewMonths,
    $core.String? department,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (title != null) result.title = title;
    if (kind != null) result.kind = kind;
    if (ownerId != null) result.ownerId = ownerId;
    if (reviewMonths != null) result.reviewMonths = reviewMonths;
    if (department != null) result.department = department;
    return result;
  }

  RegisterDocumentRequest._();

  factory RegisterDocumentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterDocumentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterDocumentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aE<DocumentKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: DocumentKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'ownerId')
    ..aI(5, _omitFieldNames ? '' : 'reviewMonths')
    ..aOS(6, _omitFieldNames ? '' : 'department')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterDocumentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterDocumentRequest copyWith(
          void Function(RegisterDocumentRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterDocumentRequest))
          as RegisterDocumentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterDocumentRequest create() => RegisterDocumentRequest._();
  @$core.override
  RegisterDocumentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterDocumentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterDocumentRequest>(create);
  static RegisterDocumentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  DocumentKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(DocumentKind value) => $_setField(3, value);
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
  $core.int get reviewMonths => $_getIZ(4);
  @$pb.TagNumber(5)
  set reviewMonths($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReviewMonths() => $_has(4);
  @$pb.TagNumber(5)
  void clearReviewMonths() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get department => $_getSZ(5);
  @$pb.TagNumber(6)
  set department($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDepartment() => $_has(5);
  @$pb.TagNumber(6)
  void clearDepartment() => $_clearField(6);
}

class RegisterDocumentResponse extends $pb.GeneratedMessage {
  factory RegisterDocumentResponse({
    ControlledDocument? document,
  }) {
    final result = create();
    if (document != null) result.document = document;
    return result;
  }

  RegisterDocumentResponse._();

  factory RegisterDocumentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterDocumentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterDocumentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<ControlledDocument>(1, _omitFieldNames ? '' : 'document',
        subBuilder: ControlledDocument.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterDocumentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterDocumentResponse copyWith(
          void Function(RegisterDocumentResponse) updates) =>
      super.copyWith((message) => updates(message as RegisterDocumentResponse))
          as RegisterDocumentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterDocumentResponse create() => RegisterDocumentResponse._();
  @$core.override
  RegisterDocumentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterDocumentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterDocumentResponse>(create);
  static RegisterDocumentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ControlledDocument get document => $_getN(0);
  @$pb.TagNumber(1)
  set document(ControlledDocument value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDocument() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocument() => $_clearField(1);
  @$pb.TagNumber(1)
  ControlledDocument ensureDocument() => $_ensure(0);
}

/// DraftVersionRequest starts a revision.
///
/// The ordinal is assigned by the server, one past whatever exists: two people
/// drafting from the same screen would otherwise both pick the next number.
class DraftVersionRequest extends $pb.GeneratedMessage {
  factory DraftVersionRequest({
    $core.String? documentId,
    $core.String? label,
    $core.String? contentRef,
    $core.String? changeSummary,
    $core.bool? requiresAcknowledgement,
    $core.bool? requiresRetraining,
  }) {
    final result = create();
    if (documentId != null) result.documentId = documentId;
    if (label != null) result.label = label;
    if (contentRef != null) result.contentRef = contentRef;
    if (changeSummary != null) result.changeSummary = changeSummary;
    if (requiresAcknowledgement != null)
      result.requiresAcknowledgement = requiresAcknowledgement;
    if (requiresRetraining != null)
      result.requiresRetraining = requiresRetraining;
    return result;
  }

  DraftVersionRequest._();

  factory DraftVersionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DraftVersionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DraftVersionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'documentId')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOS(3, _omitFieldNames ? '' : 'contentRef')
    ..aOS(4, _omitFieldNames ? '' : 'changeSummary')
    ..aOB(5, _omitFieldNames ? '' : 'requiresAcknowledgement')
    ..aOB(6, _omitFieldNames ? '' : 'requiresRetraining')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftVersionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftVersionRequest copyWith(void Function(DraftVersionRequest) updates) =>
      super.copyWith((message) => updates(message as DraftVersionRequest))
          as DraftVersionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DraftVersionRequest create() => DraftVersionRequest._();
  @$core.override
  DraftVersionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DraftVersionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DraftVersionRequest>(create);
  static DraftVersionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get documentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set documentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get contentRef => $_getSZ(2);
  @$pb.TagNumber(3)
  set contentRef($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContentRef() => $_has(2);
  @$pb.TagNumber(3)
  void clearContentRef() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get changeSummary => $_getSZ(3);
  @$pb.TagNumber(4)
  set changeSummary($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChangeSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearChangeSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get requiresAcknowledgement => $_getBF(4);
  @$pb.TagNumber(5)
  set requiresAcknowledgement($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRequiresAcknowledgement() => $_has(4);
  @$pb.TagNumber(5)
  void clearRequiresAcknowledgement() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get requiresRetraining => $_getBF(5);
  @$pb.TagNumber(6)
  set requiresRetraining($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRequiresRetraining() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequiresRetraining() => $_clearField(6);
}

class DraftVersionResponse extends $pb.GeneratedMessage {
  factory DraftVersionResponse({
    DocumentVersion? version,
  }) {
    final result = create();
    if (version != null) result.version = version;
    return result;
  }

  DraftVersionResponse._();

  factory DraftVersionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DraftVersionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DraftVersionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<DocumentVersion>(1, _omitFieldNames ? '' : 'version',
        subBuilder: DocumentVersion.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftVersionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftVersionResponse copyWith(void Function(DraftVersionResponse) updates) =>
      super.copyWith((message) => updates(message as DraftVersionResponse))
          as DraftVersionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DraftVersionResponse create() => DraftVersionResponse._();
  @$core.override
  DraftVersionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DraftVersionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DraftVersionResponse>(create);
  static DraftVersionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DocumentVersion get version => $_getN(0);
  @$pb.TagNumber(1)
  set version(DocumentVersion value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);
  @$pb.TagNumber(1)
  DocumentVersion ensureVersion() => $_ensure(0);
}

class ApproveVersionRequest extends $pb.GeneratedMessage {
  factory ApproveVersionRequest({
    $core.String? versionId,
    $0.Timestamp? effectiveFrom,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (versionId != null) result.versionId = versionId;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  ApproveVersionRequest._();

  factory ApproveVersionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveVersionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveVersionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'versionId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aInt64(3, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveVersionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveVersionRequest copyWith(
          void Function(ApproveVersionRequest) updates) =>
      super.copyWith((message) => updates(message as ApproveVersionRequest))
          as ApproveVersionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveVersionRequest create() => ApproveVersionRequest._();
  @$core.override
  ApproveVersionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveVersionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveVersionRequest>(create);
  static ApproveVersionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get versionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set versionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersionId() => $_clearField(1);

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

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedVersion => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedVersion() => $_clearField(3);
}

class ApproveVersionResponse extends $pb.GeneratedMessage {
  factory ApproveVersionResponse({
    DocumentVersion? version,
  }) {
    final result = create();
    if (version != null) result.version = version;
    return result;
  }

  ApproveVersionResponse._();

  factory ApproveVersionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveVersionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveVersionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<DocumentVersion>(1, _omitFieldNames ? '' : 'version',
        subBuilder: DocumentVersion.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveVersionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveVersionResponse copyWith(
          void Function(ApproveVersionResponse) updates) =>
      super.copyWith((message) => updates(message as ApproveVersionResponse))
          as ApproveVersionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveVersionResponse create() => ApproveVersionResponse._();
  @$core.override
  ApproveVersionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveVersionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveVersionResponse>(create);
  static ApproveVersionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DocumentVersion get version => $_getN(0);
  @$pb.TagNumber(1)
  set version(DocumentVersion value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);
  @$pb.TagNumber(1)
  DocumentVersion ensureVersion() => $_ensure(0);
}

class GetCurrentVersionRequest extends $pb.GeneratedMessage {
  factory GetCurrentVersionRequest({
    $core.String? documentId,
  }) {
    final result = create();
    if (documentId != null) result.documentId = documentId;
    return result;
  }

  GetCurrentVersionRequest._();

  factory GetCurrentVersionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCurrentVersionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCurrentVersionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'documentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentVersionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentVersionRequest copyWith(
          void Function(GetCurrentVersionRequest) updates) =>
      super.copyWith((message) => updates(message as GetCurrentVersionRequest))
          as GetCurrentVersionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCurrentVersionRequest create() => GetCurrentVersionRequest._();
  @$core.override
  GetCurrentVersionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCurrentVersionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCurrentVersionRequest>(create);
  static GetCurrentVersionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get documentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set documentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentId() => $_clearField(1);
}

/// GetCurrentVersionResponse is the revision in force right now.
///
/// found is false where nothing is in force — a gap somebody has to see, not a
/// reason to return an unapproved draft.
class GetCurrentVersionResponse extends $pb.GeneratedMessage {
  factory GetCurrentVersionResponse({
    DocumentVersion? version,
    $core.bool? found,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (found != null) result.found = found;
    return result;
  }

  GetCurrentVersionResponse._();

  factory GetCurrentVersionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCurrentVersionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCurrentVersionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<DocumentVersion>(1, _omitFieldNames ? '' : 'version',
        subBuilder: DocumentVersion.create)
    ..aOB(2, _omitFieldNames ? '' : 'found')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentVersionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentVersionResponse copyWith(
          void Function(GetCurrentVersionResponse) updates) =>
      super.copyWith((message) => updates(message as GetCurrentVersionResponse))
          as GetCurrentVersionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCurrentVersionResponse create() => GetCurrentVersionResponse._();
  @$core.override
  GetCurrentVersionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCurrentVersionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCurrentVersionResponse>(create);
  static GetCurrentVersionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DocumentVersion get version => $_getN(0);
  @$pb.TagNumber(1)
  set version(DocumentVersion value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);
  @$pb.TagNumber(1)
  DocumentVersion ensureVersion() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get found => $_getBF(1);
  @$pb.TagNumber(2)
  set found($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFound() => $_has(1);
  @$pb.TagNumber(2)
  void clearFound() => $_clearField(2);
}

class ListVersionsRequest extends $pb.GeneratedMessage {
  factory ListVersionsRequest({
    $core.String? documentId,
  }) {
    final result = create();
    if (documentId != null) result.documentId = documentId;
    return result;
  }

  ListVersionsRequest._();

  factory ListVersionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListVersionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListVersionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'documentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVersionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVersionsRequest copyWith(void Function(ListVersionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListVersionsRequest))
          as ListVersionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListVersionsRequest create() => ListVersionsRequest._();
  @$core.override
  ListVersionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListVersionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListVersionsRequest>(create);
  static ListVersionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get documentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set documentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentId() => $_clearField(1);
}

class ListVersionsResponse extends $pb.GeneratedMessage {
  factory ListVersionsResponse({
    $core.Iterable<DocumentVersion>? versions,
  }) {
    final result = create();
    if (versions != null) result.versions.addAll(versions);
    return result;
  }

  ListVersionsResponse._();

  factory ListVersionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListVersionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListVersionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<DocumentVersion>(1, _omitFieldNames ? '' : 'versions',
        subBuilder: DocumentVersion.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVersionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVersionsResponse copyWith(void Function(ListVersionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListVersionsResponse))
          as ListVersionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListVersionsResponse create() => ListVersionsResponse._();
  @$core.override
  ListVersionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListVersionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListVersionsResponse>(create);
  static ListVersionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DocumentVersion> get versions => $_getList(0);
}

class ListDocumentsRequest extends $pb.GeneratedMessage {
  factory ListDocumentsRequest({
    DocumentKind? kind,
    $core.String? department,
    $core.bool? excludeWithdrawn,
    $core.int? pageSize,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (department != null) result.department = department;
    if (excludeWithdrawn != null) result.excludeWithdrawn = excludeWithdrawn;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListDocumentsRequest._();

  factory ListDocumentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDocumentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDocumentsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aE<DocumentKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: DocumentKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'department')
    ..aOB(3, _omitFieldNames ? '' : 'excludeWithdrawn')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDocumentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDocumentsRequest copyWith(void Function(ListDocumentsRequest) updates) =>
      super.copyWith((message) => updates(message as ListDocumentsRequest))
          as ListDocumentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDocumentsRequest create() => ListDocumentsRequest._();
  @$core.override
  ListDocumentsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDocumentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDocumentsRequest>(create);
  static ListDocumentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  DocumentKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(DocumentKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get department => $_getSZ(1);
  @$pb.TagNumber(2)
  set department($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDepartment() => $_has(1);
  @$pb.TagNumber(2)
  void clearDepartment() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get excludeWithdrawn => $_getBF(2);
  @$pb.TagNumber(3)
  set excludeWithdrawn($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExcludeWithdrawn() => $_has(2);
  @$pb.TagNumber(3)
  void clearExcludeWithdrawn() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

class ListDocumentsResponse extends $pb.GeneratedMessage {
  factory ListDocumentsResponse({
    $core.Iterable<ControlledDocument>? documents,
  }) {
    final result = create();
    if (documents != null) result.documents.addAll(documents);
    return result;
  }

  ListDocumentsResponse._();

  factory ListDocumentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDocumentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDocumentsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<ControlledDocument>(1, _omitFieldNames ? '' : 'documents',
        subBuilder: ControlledDocument.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDocumentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDocumentsResponse copyWith(
          void Function(ListDocumentsResponse) updates) =>
      super.copyWith((message) => updates(message as ListDocumentsResponse))
          as ListDocumentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDocumentsResponse create() => ListDocumentsResponse._();
  @$core.override
  ListDocumentsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDocumentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDocumentsResponse>(create);
  static ListDocumentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ControlledDocument> get documents => $_getList(0);
}

/// AcknowledgeDocumentRequest confirms the caller has read the version in
/// force.
///
/// The caller does not name the version: a client that could choose which
/// version it was confirming could confirm the old one for ever.
class AcknowledgeDocumentRequest extends $pb.GeneratedMessage {
  factory AcknowledgeDocumentRequest({
    $core.String? documentId,
    $core.String? role,
  }) {
    final result = create();
    if (documentId != null) result.documentId = documentId;
    if (role != null) result.role = role;
    return result;
  }

  AcknowledgeDocumentRequest._();

  factory AcknowledgeDocumentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgeDocumentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgeDocumentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'documentId')
    ..aOS(2, _omitFieldNames ? '' : 'role')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeDocumentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeDocumentRequest copyWith(
          void Function(AcknowledgeDocumentRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AcknowledgeDocumentRequest))
          as AcknowledgeDocumentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeDocumentRequest create() => AcknowledgeDocumentRequest._();
  @$core.override
  AcknowledgeDocumentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeDocumentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgeDocumentRequest>(create);
  static AcknowledgeDocumentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get documentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set documentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get role => $_getSZ(1);
  @$pb.TagNumber(2)
  set role($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);
}

class AcknowledgeDocumentResponse extends $pb.GeneratedMessage {
  factory AcknowledgeDocumentResponse({
    $core.String? acknowledgementId,
    $core.String? versionId,
    $0.Timestamp? acknowledgedAt,
  }) {
    final result = create();
    if (acknowledgementId != null) result.acknowledgementId = acknowledgementId;
    if (versionId != null) result.versionId = versionId;
    if (acknowledgedAt != null) result.acknowledgedAt = acknowledgedAt;
    return result;
  }

  AcknowledgeDocumentResponse._();

  factory AcknowledgeDocumentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgeDocumentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgeDocumentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'acknowledgementId')
    ..aOS(2, _omitFieldNames ? '' : 'versionId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'acknowledgedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeDocumentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeDocumentResponse copyWith(
          void Function(AcknowledgeDocumentResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AcknowledgeDocumentResponse))
          as AcknowledgeDocumentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeDocumentResponse create() =>
      AcknowledgeDocumentResponse._();
  @$core.override
  AcknowledgeDocumentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeDocumentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgeDocumentResponse>(create);
  static AcknowledgeDocumentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get acknowledgementId => $_getSZ(0);
  @$pb.TagNumber(1)
  set acknowledgementId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAcknowledgementId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAcknowledgementId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get versionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set versionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get acknowledgedAt => $_getN(2);
  @$pb.TagNumber(3)
  set acknowledgedAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAcknowledgedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearAcknowledgedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureAcknowledgedAt() => $_ensure(2);
}

/// AcknowledgementGap is somebody who has not read a version they must.
class AcknowledgementGap extends $pb.GeneratedMessage {
  factory AcknowledgementGap({
    $core.String? documentId,
    $core.String? versionId,
    $core.String? code,
    $core.String? personId,
    $core.String? role,
  }) {
    final result = create();
    if (documentId != null) result.documentId = documentId;
    if (versionId != null) result.versionId = versionId;
    if (code != null) result.code = code;
    if (personId != null) result.personId = personId;
    if (role != null) result.role = role;
    return result;
  }

  AcknowledgementGap._();

  factory AcknowledgementGap.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgementGap.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgementGap',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'documentId')
    ..aOS(2, _omitFieldNames ? '' : 'versionId')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'personId')
    ..aOS(5, _omitFieldNames ? '' : 'role')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgementGap clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgementGap copyWith(void Function(AcknowledgementGap) updates) =>
      super.copyWith((message) => updates(message as AcknowledgementGap))
          as AcknowledgementGap;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgementGap create() => AcknowledgementGap._();
  @$core.override
  AcknowledgementGap createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgementGap getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgementGap>(create);
  static AcknowledgementGap? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get documentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set documentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get versionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set versionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get personId => $_getSZ(3);
  @$pb.TagNumber(4)
  set personId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPersonId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPersonId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get role => $_getSZ(4);
  @$pb.TagNumber(5)
  set role($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRole() => $_has(4);
  @$pb.TagNumber(5)
  void clearRole() => $_clearField(5);
}

class ListOutstandingAcknowledgementsRequest extends $pb.GeneratedMessage {
  factory ListOutstandingAcknowledgementsRequest({
    $core.String? documentId,
  }) {
    final result = create();
    if (documentId != null) result.documentId = documentId;
    return result;
  }

  ListOutstandingAcknowledgementsRequest._();

  factory ListOutstandingAcknowledgementsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOutstandingAcknowledgementsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOutstandingAcknowledgementsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'documentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutstandingAcknowledgementsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutstandingAcknowledgementsRequest copyWith(
          void Function(ListOutstandingAcknowledgementsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ListOutstandingAcknowledgementsRequest))
          as ListOutstandingAcknowledgementsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOutstandingAcknowledgementsRequest create() =>
      ListOutstandingAcknowledgementsRequest._();
  @$core.override
  ListOutstandingAcknowledgementsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOutstandingAcknowledgementsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          ListOutstandingAcknowledgementsRequest>(create);
  static ListOutstandingAcknowledgementsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get documentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set documentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentId() => $_clearField(1);
}

class ListOutstandingAcknowledgementsResponse extends $pb.GeneratedMessage {
  factory ListOutstandingAcknowledgementsResponse({
    $core.Iterable<AcknowledgementGap>? gaps,
  }) {
    final result = create();
    if (gaps != null) result.gaps.addAll(gaps);
    return result;
  }

  ListOutstandingAcknowledgementsResponse._();

  factory ListOutstandingAcknowledgementsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOutstandingAcknowledgementsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOutstandingAcknowledgementsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<AcknowledgementGap>(1, _omitFieldNames ? '' : 'gaps',
        subBuilder: AcknowledgementGap.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutstandingAcknowledgementsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutstandingAcknowledgementsResponse copyWith(
          void Function(ListOutstandingAcknowledgementsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ListOutstandingAcknowledgementsResponse))
          as ListOutstandingAcknowledgementsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOutstandingAcknowledgementsResponse create() =>
      ListOutstandingAcknowledgementsResponse._();
  @$core.override
  ListOutstandingAcknowledgementsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOutstandingAcknowledgementsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          ListOutstandingAcknowledgementsResponse>(create);
  static ListOutstandingAcknowledgementsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AcknowledgementGap> get gaps => $_getList(0);
}

/// ReviewDue is a controlled document past its own review interval
/// (SRS-QMS-006).
class ReviewDue extends $pb.GeneratedMessage {
  factory ReviewDue({
    $core.String? documentId,
    $core.String? code,
    $core.String? title,
    $core.String? ownerId,
    $0.Timestamp? lastEffective,
    $0.Timestamp? dueOn,
    $core.int? daysOverdue,
    $core.bool? noEffectiveVersion,
    $core.bool? noReviewInterval,
  }) {
    final result = create();
    if (documentId != null) result.documentId = documentId;
    if (code != null) result.code = code;
    if (title != null) result.title = title;
    if (ownerId != null) result.ownerId = ownerId;
    if (lastEffective != null) result.lastEffective = lastEffective;
    if (dueOn != null) result.dueOn = dueOn;
    if (daysOverdue != null) result.daysOverdue = daysOverdue;
    if (noEffectiveVersion != null)
      result.noEffectiveVersion = noEffectiveVersion;
    if (noReviewInterval != null) result.noReviewInterval = noReviewInterval;
    return result;
  }

  ReviewDue._();

  factory ReviewDue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReviewDue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewDue',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'documentId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'ownerId')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'lastEffective',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'dueOn',
        subBuilder: $0.Timestamp.create)
    ..aI(7, _omitFieldNames ? '' : 'daysOverdue')
    ..aOB(8, _omitFieldNames ? '' : 'noEffectiveVersion')
    ..aOB(9, _omitFieldNames ? '' : 'noReviewInterval')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewDue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewDue copyWith(void Function(ReviewDue) updates) =>
      super.copyWith((message) => updates(message as ReviewDue)) as ReviewDue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReviewDue create() => ReviewDue._();
  @$core.override
  ReviewDue createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReviewDue getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReviewDue>(create);
  static ReviewDue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get documentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set documentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get ownerId => $_getSZ(3);
  @$pb.TagNumber(4)
  set ownerId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOwnerId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOwnerId() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get lastEffective => $_getN(4);
  @$pb.TagNumber(5)
  set lastEffective($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLastEffective() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastEffective() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureLastEffective() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get dueOn => $_getN(5);
  @$pb.TagNumber(6)
  set dueOn($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasDueOn() => $_has(5);
  @$pb.TagNumber(6)
  void clearDueOn() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureDueOn() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.int get daysOverdue => $_getIZ(6);
  @$pb.TagNumber(7)
  set daysOverdue($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDaysOverdue() => $_has(6);
  @$pb.TagNumber(7)
  void clearDaysOverdue() => $_clearField(7);

  /// Nothing in force at all: approved drafts, obsolete versions, or nothing.
  /// The worse case, and reported apart from an overdue review.
  @$pb.TagNumber(8)
  $core.bool get noEffectiveVersion => $_getBF(7);
  @$pb.TagNumber(8)
  set noEffectiveVersion($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNoEffectiveVersion() => $_has(7);
  @$pb.TagNumber(8)
  void clearNoEffectiveVersion() => $_clearField(8);

  /// Nobody decided a review period. Named rather than treated as "never due",
  /// because that is the answer that makes the report look clean.
  @$pb.TagNumber(9)
  $core.bool get noReviewInterval => $_getBF(8);
  @$pb.TagNumber(9)
  set noReviewInterval($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasNoReviewInterval() => $_has(8);
  @$pb.TagNumber(9)
  void clearNoReviewInterval() => $_clearField(9);
}

class ListReviewsDueRequest extends $pb.GeneratedMessage {
  factory ListReviewsDueRequest() => create();

  ListReviewsDueRequest._();

  factory ListReviewsDueRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReviewsDueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReviewsDueRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReviewsDueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReviewsDueRequest copyWith(
          void Function(ListReviewsDueRequest) updates) =>
      super.copyWith((message) => updates(message as ListReviewsDueRequest))
          as ListReviewsDueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReviewsDueRequest create() => ListReviewsDueRequest._();
  @$core.override
  ListReviewsDueRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReviewsDueRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReviewsDueRequest>(create);
  static ListReviewsDueRequest? _defaultInstance;
}

class ListReviewsDueResponse extends $pb.GeneratedMessage {
  factory ListReviewsDueResponse({
    $core.Iterable<ReviewDue>? due,
  }) {
    final result = create();
    if (due != null) result.due.addAll(due);
    return result;
  }

  ListReviewsDueResponse._();

  factory ListReviewsDueResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReviewsDueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReviewsDueResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<ReviewDue>(1, _omitFieldNames ? '' : 'due',
        subBuilder: ReviewDue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReviewsDueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReviewsDueResponse copyWith(
          void Function(ListReviewsDueResponse) updates) =>
      super.copyWith((message) => updates(message as ListReviewsDueResponse))
          as ListReviewsDueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReviewsDueResponse create() => ListReviewsDueResponse._();
  @$core.override
  ListReviewsDueResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReviewsDueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReviewsDueResponse>(create);
  static ListReviewsDueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ReviewDue> get due => $_getList(0);
}

/// Competency is a skill somebody must be able to evidence (SRS-QMS-013).
class Competency extends $pb.GeneratedMessage {
  factory Competency({
    $core.String? competencyId,
    $core.String? code,
    $core.String? name,
    $core.String? documentId,
    $core.int? validMonths,
    $core.bool? active,
  }) {
    final result = create();
    if (competencyId != null) result.competencyId = competencyId;
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (documentId != null) result.documentId = documentId;
    if (validMonths != null) result.validMonths = validMonths;
    if (active != null) result.active = active;
    return result;
  }

  Competency._();

  factory Competency.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Competency.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Competency',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'competencyId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'documentId')
    ..aI(5, _omitFieldNames ? '' : 'validMonths')
    ..aOB(6, _omitFieldNames ? '' : 'active')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Competency clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Competency copyWith(void Function(Competency) updates) =>
      super.copyWith((message) => updates(message as Competency)) as Competency;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Competency create() => Competency._();
  @$core.override
  Competency createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Competency getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Competency>(create);
  static Competency? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get competencyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set competencyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCompetencyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCompetencyId() => $_clearField(1);

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

  /// The controlled document that defines it. What makes a policy revision
  /// able to expire training against it.
  @$pb.TagNumber(4)
  $core.String get documentId => $_getSZ(3);
  @$pb.TagNumber(4)
  set documentId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDocumentId() => $_has(3);
  @$pb.TagNumber(4)
  void clearDocumentId() => $_clearField(4);

  /// Zero means it does not expire, which is a decision rather than an
  /// omission.
  @$pb.TagNumber(5)
  $core.int get validMonths => $_getIZ(4);
  @$pb.TagNumber(5)
  set validMonths($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasValidMonths() => $_has(4);
  @$pb.TagNumber(5)
  void clearValidMonths() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get active => $_getBF(5);
  @$pb.TagNumber(6)
  set active($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasActive() => $_has(5);
  @$pb.TagNumber(6)
  void clearActive() => $_clearField(6);
}

class DefineCompetencyRequest extends $pb.GeneratedMessage {
  factory DefineCompetencyRequest({
    $core.String? code,
    $core.String? name,
    $core.String? documentId,
    $core.int? validMonths,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (documentId != null) result.documentId = documentId;
    if (validMonths != null) result.validMonths = validMonths;
    return result;
  }

  DefineCompetencyRequest._();

  factory DefineCompetencyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineCompetencyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineCompetencyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'documentId')
    ..aI(4, _omitFieldNames ? '' : 'validMonths')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineCompetencyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineCompetencyRequest copyWith(
          void Function(DefineCompetencyRequest) updates) =>
      super.copyWith((message) => updates(message as DefineCompetencyRequest))
          as DefineCompetencyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineCompetencyRequest create() => DefineCompetencyRequest._();
  @$core.override
  DefineCompetencyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineCompetencyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineCompetencyRequest>(create);
  static DefineCompetencyRequest? _defaultInstance;

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
  $core.String get documentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set documentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDocumentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearDocumentId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get validMonths => $_getIZ(3);
  @$pb.TagNumber(4)
  set validMonths($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasValidMonths() => $_has(3);
  @$pb.TagNumber(4)
  void clearValidMonths() => $_clearField(4);
}

class DefineCompetencyResponse extends $pb.GeneratedMessage {
  factory DefineCompetencyResponse({
    Competency? competency,
  }) {
    final result = create();
    if (competency != null) result.competency = competency;
    return result;
  }

  DefineCompetencyResponse._();

  factory DefineCompetencyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineCompetencyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineCompetencyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Competency>(1, _omitFieldNames ? '' : 'competency',
        subBuilder: Competency.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineCompetencyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineCompetencyResponse copyWith(
          void Function(DefineCompetencyResponse) updates) =>
      super.copyWith((message) => updates(message as DefineCompetencyResponse))
          as DefineCompetencyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineCompetencyResponse create() => DefineCompetencyResponse._();
  @$core.override
  DefineCompetencyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineCompetencyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineCompetencyResponse>(create);
  static DefineCompetencyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Competency get competency => $_getN(0);
  @$pb.TagNumber(1)
  set competency(Competency value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCompetency() => $_has(0);
  @$pb.TagNumber(1)
  void clearCompetency() => $_clearField(1);
  @$pb.TagNumber(1)
  Competency ensureCompetency() => $_ensure(0);
}

class RequireCompetencyRequest extends $pb.GeneratedMessage {
  factory RequireCompetencyRequest({
    $core.String? role,
    $core.String? competencyId,
  }) {
    final result = create();
    if (role != null) result.role = role;
    if (competencyId != null) result.competencyId = competencyId;
    return result;
  }

  RequireCompetencyRequest._();

  factory RequireCompetencyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequireCompetencyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequireCompetencyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'role')
    ..aOS(2, _omitFieldNames ? '' : 'competencyId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequireCompetencyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequireCompetencyRequest copyWith(
          void Function(RequireCompetencyRequest) updates) =>
      super.copyWith((message) => updates(message as RequireCompetencyRequest))
          as RequireCompetencyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequireCompetencyRequest create() => RequireCompetencyRequest._();
  @$core.override
  RequireCompetencyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequireCompetencyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequireCompetencyRequest>(create);
  static RequireCompetencyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get role => $_getSZ(0);
  @$pb.TagNumber(1)
  set role($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRole() => $_has(0);
  @$pb.TagNumber(1)
  void clearRole() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get competencyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set competencyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCompetencyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompetencyId() => $_clearField(2);
}

class RequireCompetencyResponse extends $pb.GeneratedMessage {
  factory RequireCompetencyResponse() => create();

  RequireCompetencyResponse._();

  factory RequireCompetencyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequireCompetencyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequireCompetencyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequireCompetencyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequireCompetencyResponse copyWith(
          void Function(RequireCompetencyResponse) updates) =>
      super.copyWith((message) => updates(message as RequireCompetencyResponse))
          as RequireCompetencyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequireCompetencyResponse create() => RequireCompetencyResponse._();
  @$core.override
  RequireCompetencyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequireCompetencyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequireCompetencyResponse>(create);
  static RequireCompetencyResponse? _defaultInstance;
}

/// AwardCompetencyRequest records training or assessment.
///
/// The expiry is computed from the competency's own validity period: a caller
/// that could set its own could award a one-year certificate that lasts ten.
class AwardCompetencyRequest extends $pb.GeneratedMessage {
  factory AwardCompetencyRequest({
    $core.String? competencyId,
    $core.String? personId,
    $core.String? versionId,
    $core.String? evidence,
    $0.Timestamp? awardedAt,
  }) {
    final result = create();
    if (competencyId != null) result.competencyId = competencyId;
    if (personId != null) result.personId = personId;
    if (versionId != null) result.versionId = versionId;
    if (evidence != null) result.evidence = evidence;
    if (awardedAt != null) result.awardedAt = awardedAt;
    return result;
  }

  AwardCompetencyRequest._();

  factory AwardCompetencyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AwardCompetencyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AwardCompetencyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'competencyId')
    ..aOS(2, _omitFieldNames ? '' : 'personId')
    ..aOS(3, _omitFieldNames ? '' : 'versionId')
    ..aOS(4, _omitFieldNames ? '' : 'evidence')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'awardedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AwardCompetencyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AwardCompetencyRequest copyWith(
          void Function(AwardCompetencyRequest) updates) =>
      super.copyWith((message) => updates(message as AwardCompetencyRequest))
          as AwardCompetencyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AwardCompetencyRequest create() => AwardCompetencyRequest._();
  @$core.override
  AwardCompetencyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AwardCompetencyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AwardCompetencyRequest>(create);
  static AwardCompetencyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get competencyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set competencyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCompetencyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCompetencyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get personId => $_getSZ(1);
  @$pb.TagNumber(2)
  set personId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPersonId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPersonId() => $_clearField(2);

  /// The document version they were trained against. Left empty the server
  /// takes the one in force.
  @$pb.TagNumber(3)
  $core.String get versionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set versionId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersionId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get evidence => $_getSZ(3);
  @$pb.TagNumber(4)
  set evidence($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEvidence() => $_has(3);
  @$pb.TagNumber(4)
  void clearEvidence() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get awardedAt => $_getN(4);
  @$pb.TagNumber(5)
  set awardedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAwardedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearAwardedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureAwardedAt() => $_ensure(4);
}

class AwardCompetencyResponse extends $pb.GeneratedMessage {
  factory AwardCompetencyResponse({
    $core.String? awardId,
    $0.Timestamp? expiresAt,
  }) {
    final result = create();
    if (awardId != null) result.awardId = awardId;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  AwardCompetencyResponse._();

  factory AwardCompetencyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AwardCompetencyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AwardCompetencyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'awardId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AwardCompetencyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AwardCompetencyResponse copyWith(
          void Function(AwardCompetencyResponse) updates) =>
      super.copyWith((message) => updates(message as AwardCompetencyResponse))
          as AwardCompetencyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AwardCompetencyResponse create() => AwardCompetencyResponse._();
  @$core.override
  AwardCompetencyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AwardCompetencyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AwardCompetencyResponse>(create);
  static AwardCompetencyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get awardId => $_getSZ(0);
  @$pb.TagNumber(1)
  set awardId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAwardId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAwardId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get expiresAt => $_getN(1);
  @$pb.TagNumber(2)
  set expiresAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasExpiresAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpiresAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureExpiresAt() => $_ensure(1);
}

/// CompetencyGap is somebody missing something their role requires.
///
/// The reason distinguishes never-held from lapsed from trained-against-
/// superseded-text, because they need three different actions: train them,
/// re-assess them, or brief them on what changed.
class CompetencyGap extends $pb.GeneratedMessage {
  factory CompetencyGap({
    $core.String? personId,
    $core.String? role,
    $core.String? competencyId,
    $core.String? code,
    $core.String? reason,
  }) {
    final result = create();
    if (personId != null) result.personId = personId;
    if (role != null) result.role = role;
    if (competencyId != null) result.competencyId = competencyId;
    if (code != null) result.code = code;
    if (reason != null) result.reason = reason;
    return result;
  }

  CompetencyGap._();

  factory CompetencyGap.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompetencyGap.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompetencyGap',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'personId')
    ..aOS(2, _omitFieldNames ? '' : 'role')
    ..aOS(3, _omitFieldNames ? '' : 'competencyId')
    ..aOS(4, _omitFieldNames ? '' : 'code')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetencyGap clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetencyGap copyWith(void Function(CompetencyGap) updates) =>
      super.copyWith((message) => updates(message as CompetencyGap))
          as CompetencyGap;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompetencyGap create() => CompetencyGap._();
  @$core.override
  CompetencyGap createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompetencyGap getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompetencyGap>(create);
  static CompetencyGap? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get personId => $_getSZ(0);
  @$pb.TagNumber(1)
  set personId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPersonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPersonId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get role => $_getSZ(1);
  @$pb.TagNumber(2)
  set role($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get competencyId => $_getSZ(2);
  @$pb.TagNumber(3)
  set competencyId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCompetencyId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCompetencyId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get code => $_getSZ(3);
  @$pb.TagNumber(4)
  set code($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);
}

class ListCompetencyGapsRequest extends $pb.GeneratedMessage {
  factory ListCompetencyGapsRequest() => create();

  ListCompetencyGapsRequest._();

  factory ListCompetencyGapsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCompetencyGapsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCompetencyGapsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCompetencyGapsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCompetencyGapsRequest copyWith(
          void Function(ListCompetencyGapsRequest) updates) =>
      super.copyWith((message) => updates(message as ListCompetencyGapsRequest))
          as ListCompetencyGapsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCompetencyGapsRequest create() => ListCompetencyGapsRequest._();
  @$core.override
  ListCompetencyGapsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCompetencyGapsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCompetencyGapsRequest>(create);
  static ListCompetencyGapsRequest? _defaultInstance;
}

class ListCompetencyGapsResponse extends $pb.GeneratedMessage {
  factory ListCompetencyGapsResponse({
    $core.Iterable<CompetencyGap>? gaps,
  }) {
    final result = create();
    if (gaps != null) result.gaps.addAll(gaps);
    return result;
  }

  ListCompetencyGapsResponse._();

  factory ListCompetencyGapsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCompetencyGapsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCompetencyGapsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<CompetencyGap>(1, _omitFieldNames ? '' : 'gaps',
        subBuilder: CompetencyGap.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCompetencyGapsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCompetencyGapsResponse copyWith(
          void Function(ListCompetencyGapsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListCompetencyGapsResponse))
          as ListCompetencyGapsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCompetencyGapsResponse create() => ListCompetencyGapsResponse._();
  @$core.override
  ListCompetencyGapsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCompetencyGapsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCompetencyGapsResponse>(create);
  static ListCompetencyGapsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CompetencyGap> get gaps => $_getList(0);
}

/// Audit is one planned internal audit (SRS-QMS-007).
class Audit extends $pb.GeneratedMessage {
  factory Audit({
    $core.String? auditId,
    $core.String? reference,
    $core.String? title,
    $core.String? scope,
    $core.String? standardId,
    $core.String? auditorId,
    $core.String? auditeeDepartment,
    $0.Timestamp? plannedFrom,
    $0.Timestamp? plannedTo,
    AuditState? state,
    $core.String? summary,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $0.Timestamp? closedAt,
    $core.String? closedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (auditId != null) result.auditId = auditId;
    if (reference != null) result.reference = reference;
    if (title != null) result.title = title;
    if (scope != null) result.scope = scope;
    if (standardId != null) result.standardId = standardId;
    if (auditorId != null) result.auditorId = auditorId;
    if (auditeeDepartment != null) result.auditeeDepartment = auditeeDepartment;
    if (plannedFrom != null) result.plannedFrom = plannedFrom;
    if (plannedTo != null) result.plannedTo = plannedTo;
    if (state != null) result.state = state;
    if (summary != null) result.summary = summary;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (closedAt != null) result.closedAt = closedAt;
    if (closedBy != null) result.closedBy = closedBy;
    if (version != null) result.version = version;
    return result;
  }

  Audit._();

  factory Audit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Audit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Audit',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'auditId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'scope')
    ..aOS(5, _omitFieldNames ? '' : 'standardId')
    ..aOS(6, _omitFieldNames ? '' : 'auditorId')
    ..aOS(7, _omitFieldNames ? '' : 'auditeeDepartment')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'plannedFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'plannedTo',
        subBuilder: $0.Timestamp.create)
    ..aE<AuditState>(10, _omitFieldNames ? '' : 'state',
        enumValues: AuditState.values)
    ..aOS(11, _omitFieldNames ? '' : 'summary')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'createdBy')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'closedBy')
    ..aInt64(16, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Audit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Audit copyWith(void Function(Audit) updates) =>
      super.copyWith((message) => updates(message as Audit)) as Audit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Audit create() => Audit._();
  @$core.override
  Audit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Audit getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Audit>(create);
  static Audit? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get auditId => $_getSZ(0);
  @$pb.TagNumber(1)
  set auditId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAuditId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuditId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reference => $_getSZ(1);
  @$pb.TagNumber(2)
  set reference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearReference() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get scope => $_getSZ(3);
  @$pb.TagNumber(4)
  set scope($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScope() => $_has(3);
  @$pb.TagNumber(4)
  void clearScope() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get standardId => $_getSZ(4);
  @$pb.TagNumber(5)
  set standardId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStandardId() => $_has(4);
  @$pb.TagNumber(5)
  void clearStandardId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get auditorId => $_getSZ(5);
  @$pb.TagNumber(6)
  set auditorId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAuditorId() => $_has(5);
  @$pb.TagNumber(6)
  void clearAuditorId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get auditeeDepartment => $_getSZ(6);
  @$pb.TagNumber(7)
  set auditeeDepartment($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAuditeeDepartment() => $_has(6);
  @$pb.TagNumber(7)
  void clearAuditeeDepartment() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get plannedFrom => $_getN(7);
  @$pb.TagNumber(8)
  set plannedFrom($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPlannedFrom() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlannedFrom() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensurePlannedFrom() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Timestamp get plannedTo => $_getN(8);
  @$pb.TagNumber(9)
  set plannedTo($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasPlannedTo() => $_has(8);
  @$pb.TagNumber(9)
  void clearPlannedTo() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensurePlannedTo() => $_ensure(8);

  @$pb.TagNumber(10)
  AuditState get state => $_getN(9);
  @$pb.TagNumber(10)
  set state(AuditState value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasState() => $_has(9);
  @$pb.TagNumber(10)
  void clearState() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get summary => $_getSZ(10);
  @$pb.TagNumber(11)
  set summary($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSummary() => $_has(10);
  @$pb.TagNumber(11)
  void clearSummary() => $_clearField(11);

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
  $fixnum.Int64 get version => $_getI64(15);
  @$pb.TagNumber(16)
  set version($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasVersion() => $_has(15);
  @$pb.TagNumber(16)
  void clearVersion() => $_clearField(16);
}

/// Finding is one thing an audit found (SRS-QMS-007).
class Finding extends $pb.GeneratedMessage {
  factory Finding({
    $core.String? findingId,
    $core.String? auditId,
    $core.String? clauseId,
    FindingSeverity? severity,
    $core.String? detail,
    $core.String? evidence,
    $core.String? capaId,
    $0.Timestamp? closedAt,
    $core.String? closedBy,
    $core.String? closureNote,
    $0.Timestamp? raisedAt,
    $core.String? raisedBy,
  }) {
    final result = create();
    if (findingId != null) result.findingId = findingId;
    if (auditId != null) result.auditId = auditId;
    if (clauseId != null) result.clauseId = clauseId;
    if (severity != null) result.severity = severity;
    if (detail != null) result.detail = detail;
    if (evidence != null) result.evidence = evidence;
    if (capaId != null) result.capaId = capaId;
    if (closedAt != null) result.closedAt = closedAt;
    if (closedBy != null) result.closedBy = closedBy;
    if (closureNote != null) result.closureNote = closureNote;
    if (raisedAt != null) result.raisedAt = raisedAt;
    if (raisedBy != null) result.raisedBy = raisedBy;
    return result;
  }

  Finding._();

  factory Finding.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Finding.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Finding',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'findingId')
    ..aOS(2, _omitFieldNames ? '' : 'auditId')
    ..aOS(3, _omitFieldNames ? '' : 'clauseId')
    ..aE<FindingSeverity>(4, _omitFieldNames ? '' : 'severity',
        enumValues: FindingSeverity.values)
    ..aOS(5, _omitFieldNames ? '' : 'detail')
    ..aOS(6, _omitFieldNames ? '' : 'evidence')
    ..aOS(7, _omitFieldNames ? '' : 'capaId')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'closedBy')
    ..aOS(10, _omitFieldNames ? '' : 'closureNote')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'raisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'raisedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Finding clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Finding copyWith(void Function(Finding) updates) =>
      super.copyWith((message) => updates(message as Finding)) as Finding;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Finding create() => Finding._();
  @$core.override
  Finding createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Finding getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Finding>(create);
  static Finding? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get findingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set findingId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFindingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFindingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get auditId => $_getSZ(1);
  @$pb.TagNumber(2)
  set auditId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAuditId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuditId() => $_clearField(2);

  /// The accreditation clause it fails, where there is one.
  @$pb.TagNumber(3)
  $core.String get clauseId => $_getSZ(2);
  @$pb.TagNumber(3)
  set clauseId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasClauseId() => $_has(2);
  @$pb.TagNumber(3)
  void clearClauseId() => $_clearField(3);

  @$pb.TagNumber(4)
  FindingSeverity get severity => $_getN(3);
  @$pb.TagNumber(4)
  set severity(FindingSeverity value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSeverity() => $_has(3);
  @$pb.TagNumber(4)
  void clearSeverity() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get detail => $_getSZ(4);
  @$pb.TagNumber(5)
  set detail($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDetail() => $_has(4);
  @$pb.TagNumber(5)
  void clearDetail() => $_clearField(5);

  /// Required for a non-conformity: an accusation with no evidence is an
  /// opinion, and the department it names will treat it as one.
  @$pb.TagNumber(6)
  $core.String get evidence => $_getSZ(5);
  @$pb.TagNumber(6)
  set evidence($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEvidence() => $_has(5);
  @$pb.TagNumber(6)
  void clearEvidence() => $_clearField(6);

  /// The action it will close through. A non-conformity closes no other way.
  @$pb.TagNumber(7)
  $core.String get capaId => $_getSZ(6);
  @$pb.TagNumber(7)
  set capaId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCapaId() => $_has(6);
  @$pb.TagNumber(7)
  void clearCapaId() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get closedAt => $_getN(7);
  @$pb.TagNumber(8)
  set closedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasClosedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearClosedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureClosedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get closedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set closedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasClosedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearClosedBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get closureNote => $_getSZ(9);
  @$pb.TagNumber(10)
  set closureNote($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasClosureNote() => $_has(9);
  @$pb.TagNumber(10)
  void clearClosureNote() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get raisedAt => $_getN(10);
  @$pb.TagNumber(11)
  set raisedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasRaisedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearRaisedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureRaisedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get raisedBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set raisedBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRaisedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearRaisedBy() => $_clearField(12);
}

class PlanAuditRequest extends $pb.GeneratedMessage {
  factory PlanAuditRequest({
    $core.String? reference,
    $core.String? title,
    $core.String? scope,
    $core.String? standardId,
    $core.String? auditorId,
    $core.String? auditeeDepartment,
    $0.Timestamp? plannedFrom,
    $0.Timestamp? plannedTo,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    if (title != null) result.title = title;
    if (scope != null) result.scope = scope;
    if (standardId != null) result.standardId = standardId;
    if (auditorId != null) result.auditorId = auditorId;
    if (auditeeDepartment != null) result.auditeeDepartment = auditeeDepartment;
    if (plannedFrom != null) result.plannedFrom = plannedFrom;
    if (plannedTo != null) result.plannedTo = plannedTo;
    return result;
  }

  PlanAuditRequest._();

  factory PlanAuditRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlanAuditRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlanAuditRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'scope')
    ..aOS(4, _omitFieldNames ? '' : 'standardId')
    ..aOS(5, _omitFieldNames ? '' : 'auditorId')
    ..aOS(6, _omitFieldNames ? '' : 'auditeeDepartment')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'plannedFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'plannedTo',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanAuditRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanAuditRequest copyWith(void Function(PlanAuditRequest) updates) =>
      super.copyWith((message) => updates(message as PlanAuditRequest))
          as PlanAuditRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlanAuditRequest create() => PlanAuditRequest._();
  @$core.override
  PlanAuditRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlanAuditRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlanAuditRequest>(create);
  static PlanAuditRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reference => $_getSZ(0);
  @$pb.TagNumber(1)
  set reference($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReference() => $_has(0);
  @$pb.TagNumber(1)
  void clearReference() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scope => $_getSZ(2);
  @$pb.TagNumber(3)
  set scope($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScope() => $_has(2);
  @$pb.TagNumber(3)
  void clearScope() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get standardId => $_getSZ(3);
  @$pb.TagNumber(4)
  set standardId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStandardId() => $_has(3);
  @$pb.TagNumber(4)
  void clearStandardId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get auditorId => $_getSZ(4);
  @$pb.TagNumber(5)
  set auditorId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAuditorId() => $_has(4);
  @$pb.TagNumber(5)
  void clearAuditorId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get auditeeDepartment => $_getSZ(5);
  @$pb.TagNumber(6)
  set auditeeDepartment($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAuditeeDepartment() => $_has(5);
  @$pb.TagNumber(6)
  void clearAuditeeDepartment() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get plannedFrom => $_getN(6);
  @$pb.TagNumber(7)
  set plannedFrom($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPlannedFrom() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlannedFrom() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensurePlannedFrom() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get plannedTo => $_getN(7);
  @$pb.TagNumber(8)
  set plannedTo($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPlannedTo() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlannedTo() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensurePlannedTo() => $_ensure(7);
}

class PlanAuditResponse extends $pb.GeneratedMessage {
  factory PlanAuditResponse({
    Audit? audit,
  }) {
    final result = create();
    if (audit != null) result.audit = audit;
    return result;
  }

  PlanAuditResponse._();

  factory PlanAuditResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlanAuditResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlanAuditResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Audit>(1, _omitFieldNames ? '' : 'audit', subBuilder: Audit.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanAuditResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanAuditResponse copyWith(void Function(PlanAuditResponse) updates) =>
      super.copyWith((message) => updates(message as PlanAuditResponse))
          as PlanAuditResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlanAuditResponse create() => PlanAuditResponse._();
  @$core.override
  PlanAuditResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlanAuditResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlanAuditResponse>(create);
  static PlanAuditResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Audit get audit => $_getN(0);
  @$pb.TagNumber(1)
  set audit(Audit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAudit() => $_has(0);
  @$pb.TagNumber(1)
  void clearAudit() => $_clearField(1);
  @$pb.TagNumber(1)
  Audit ensureAudit() => $_ensure(0);
}

class RecordFindingRequest extends $pb.GeneratedMessage {
  factory RecordFindingRequest({
    $core.String? auditId,
    $core.String? clauseId,
    FindingSeverity? severity,
    $core.String? detail,
    $core.String? evidence,
  }) {
    final result = create();
    if (auditId != null) result.auditId = auditId;
    if (clauseId != null) result.clauseId = clauseId;
    if (severity != null) result.severity = severity;
    if (detail != null) result.detail = detail;
    if (evidence != null) result.evidence = evidence;
    return result;
  }

  RecordFindingRequest._();

  factory RecordFindingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordFindingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordFindingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'auditId')
    ..aOS(2, _omitFieldNames ? '' : 'clauseId')
    ..aE<FindingSeverity>(3, _omitFieldNames ? '' : 'severity',
        enumValues: FindingSeverity.values)
    ..aOS(4, _omitFieldNames ? '' : 'detail')
    ..aOS(5, _omitFieldNames ? '' : 'evidence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordFindingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordFindingRequest copyWith(void Function(RecordFindingRequest) updates) =>
      super.copyWith((message) => updates(message as RecordFindingRequest))
          as RecordFindingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordFindingRequest create() => RecordFindingRequest._();
  @$core.override
  RecordFindingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordFindingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordFindingRequest>(create);
  static RecordFindingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get auditId => $_getSZ(0);
  @$pb.TagNumber(1)
  set auditId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAuditId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuditId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clauseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set clauseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClauseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearClauseId() => $_clearField(2);

  @$pb.TagNumber(3)
  FindingSeverity get severity => $_getN(2);
  @$pb.TagNumber(3)
  set severity(FindingSeverity value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSeverity() => $_has(2);
  @$pb.TagNumber(3)
  void clearSeverity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get detail => $_getSZ(3);
  @$pb.TagNumber(4)
  set detail($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDetail() => $_has(3);
  @$pb.TagNumber(4)
  void clearDetail() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get evidence => $_getSZ(4);
  @$pb.TagNumber(5)
  set evidence($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEvidence() => $_has(4);
  @$pb.TagNumber(5)
  void clearEvidence() => $_clearField(5);
}

class RecordFindingResponse extends $pb.GeneratedMessage {
  factory RecordFindingResponse({
    Finding? finding,
  }) {
    final result = create();
    if (finding != null) result.finding = finding;
    return result;
  }

  RecordFindingResponse._();

  factory RecordFindingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordFindingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordFindingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Finding>(1, _omitFieldNames ? '' : 'finding',
        subBuilder: Finding.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordFindingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordFindingResponse copyWith(
          void Function(RecordFindingResponse) updates) =>
      super.copyWith((message) => updates(message as RecordFindingResponse))
          as RecordFindingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordFindingResponse create() => RecordFindingResponse._();
  @$core.override
  RecordFindingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordFindingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordFindingResponse>(create);
  static RecordFindingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Finding get finding => $_getN(0);
  @$pb.TagNumber(1)
  set finding(Finding value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFinding() => $_has(0);
  @$pb.TagNumber(1)
  void clearFinding() => $_clearField(1);
  @$pb.TagNumber(1)
  Finding ensureFinding() => $_ensure(0);
}

class LinkFindingActionRequest extends $pb.GeneratedMessage {
  factory LinkFindingActionRequest({
    $core.String? findingId,
    $core.String? capaId,
  }) {
    final result = create();
    if (findingId != null) result.findingId = findingId;
    if (capaId != null) result.capaId = capaId;
    return result;
  }

  LinkFindingActionRequest._();

  factory LinkFindingActionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LinkFindingActionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkFindingActionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'findingId')
    ..aOS(2, _omitFieldNames ? '' : 'capaId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkFindingActionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkFindingActionRequest copyWith(
          void Function(LinkFindingActionRequest) updates) =>
      super.copyWith((message) => updates(message as LinkFindingActionRequest))
          as LinkFindingActionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LinkFindingActionRequest create() => LinkFindingActionRequest._();
  @$core.override
  LinkFindingActionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LinkFindingActionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkFindingActionRequest>(create);
  static LinkFindingActionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get findingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set findingId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFindingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFindingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get capaId => $_getSZ(1);
  @$pb.TagNumber(2)
  set capaId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCapaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCapaId() => $_clearField(2);
}

class LinkFindingActionResponse extends $pb.GeneratedMessage {
  factory LinkFindingActionResponse({
    Finding? finding,
  }) {
    final result = create();
    if (finding != null) result.finding = finding;
    return result;
  }

  LinkFindingActionResponse._();

  factory LinkFindingActionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LinkFindingActionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkFindingActionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Finding>(1, _omitFieldNames ? '' : 'finding',
        subBuilder: Finding.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkFindingActionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkFindingActionResponse copyWith(
          void Function(LinkFindingActionResponse) updates) =>
      super.copyWith((message) => updates(message as LinkFindingActionResponse))
          as LinkFindingActionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LinkFindingActionResponse create() => LinkFindingActionResponse._();
  @$core.override
  LinkFindingActionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LinkFindingActionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkFindingActionResponse>(create);
  static LinkFindingActionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Finding get finding => $_getN(0);
  @$pb.TagNumber(1)
  set finding(Finding value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFinding() => $_has(0);
  @$pb.TagNumber(1)
  void clearFinding() => $_clearField(1);
  @$pb.TagNumber(1)
  Finding ensureFinding() => $_ensure(0);
}

class CloseFindingRequest extends $pb.GeneratedMessage {
  factory CloseFindingRequest({
    $core.String? findingId,
    $core.String? note,
  }) {
    final result = create();
    if (findingId != null) result.findingId = findingId;
    if (note != null) result.note = note;
    return result;
  }

  CloseFindingRequest._();

  factory CloseFindingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseFindingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseFindingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'findingId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseFindingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseFindingRequest copyWith(void Function(CloseFindingRequest) updates) =>
      super.copyWith((message) => updates(message as CloseFindingRequest))
          as CloseFindingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseFindingRequest create() => CloseFindingRequest._();
  @$core.override
  CloseFindingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseFindingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseFindingRequest>(create);
  static CloseFindingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get findingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set findingId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFindingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFindingId() => $_clearField(1);

  /// How an observation is closed. A non-conformity cannot be closed this way.
  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);
}

class CloseFindingResponse extends $pb.GeneratedMessage {
  factory CloseFindingResponse({
    Finding? finding,
  }) {
    final result = create();
    if (finding != null) result.finding = finding;
    return result;
  }

  CloseFindingResponse._();

  factory CloseFindingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseFindingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseFindingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Finding>(1, _omitFieldNames ? '' : 'finding',
        subBuilder: Finding.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseFindingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseFindingResponse copyWith(void Function(CloseFindingResponse) updates) =>
      super.copyWith((message) => updates(message as CloseFindingResponse))
          as CloseFindingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseFindingResponse create() => CloseFindingResponse._();
  @$core.override
  CloseFindingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseFindingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseFindingResponse>(create);
  static CloseFindingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Finding get finding => $_getN(0);
  @$pb.TagNumber(1)
  set finding(Finding value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFinding() => $_has(0);
  @$pb.TagNumber(1)
  void clearFinding() => $_clearField(1);
  @$pb.TagNumber(1)
  Finding ensureFinding() => $_ensure(0);
}

class ReportAuditRequest extends $pb.GeneratedMessage {
  factory ReportAuditRequest({
    $core.String? auditId,
    $core.String? summary,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (auditId != null) result.auditId = auditId;
    if (summary != null) result.summary = summary;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  ReportAuditRequest._();

  factory ReportAuditRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportAuditRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportAuditRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'auditId')
    ..aOS(2, _omitFieldNames ? '' : 'summary')
    ..aInt64(3, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportAuditRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportAuditRequest copyWith(void Function(ReportAuditRequest) updates) =>
      super.copyWith((message) => updates(message as ReportAuditRequest))
          as ReportAuditRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportAuditRequest create() => ReportAuditRequest._();
  @$core.override
  ReportAuditRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReportAuditRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportAuditRequest>(create);
  static ReportAuditRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get auditId => $_getSZ(0);
  @$pb.TagNumber(1)
  set auditId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAuditId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuditId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get summary => $_getSZ(1);
  @$pb.TagNumber(2)
  set summary($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSummary() => $_has(1);
  @$pb.TagNumber(2)
  void clearSummary() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedVersion => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedVersion() => $_clearField(3);
}

class ReportAuditResponse extends $pb.GeneratedMessage {
  factory ReportAuditResponse({
    Audit? audit,
  }) {
    final result = create();
    if (audit != null) result.audit = audit;
    return result;
  }

  ReportAuditResponse._();

  factory ReportAuditResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportAuditResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportAuditResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Audit>(1, _omitFieldNames ? '' : 'audit', subBuilder: Audit.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportAuditResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportAuditResponse copyWith(void Function(ReportAuditResponse) updates) =>
      super.copyWith((message) => updates(message as ReportAuditResponse))
          as ReportAuditResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportAuditResponse create() => ReportAuditResponse._();
  @$core.override
  ReportAuditResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReportAuditResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportAuditResponse>(create);
  static ReportAuditResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Audit get audit => $_getN(0);
  @$pb.TagNumber(1)
  set audit(Audit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAudit() => $_has(0);
  @$pb.TagNumber(1)
  void clearAudit() => $_clearField(1);
  @$pb.TagNumber(1)
  Audit ensureAudit() => $_ensure(0);
}

class CloseAuditRequest extends $pb.GeneratedMessage {
  factory CloseAuditRequest({
    $core.String? auditId,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (auditId != null) result.auditId = auditId;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  CloseAuditRequest._();

  factory CloseAuditRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseAuditRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseAuditRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'auditId')
    ..aInt64(2, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseAuditRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseAuditRequest copyWith(void Function(CloseAuditRequest) updates) =>
      super.copyWith((message) => updates(message as CloseAuditRequest))
          as CloseAuditRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseAuditRequest create() => CloseAuditRequest._();
  @$core.override
  CloseAuditRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseAuditRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseAuditRequest>(create);
  static CloseAuditRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get auditId => $_getSZ(0);
  @$pb.TagNumber(1)
  set auditId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAuditId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuditId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expectedVersion => $_getI64(1);
  @$pb.TagNumber(2)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedVersion() => $_clearField(2);
}

class CloseAuditResponse extends $pb.GeneratedMessage {
  factory CloseAuditResponse({
    Audit? audit,
  }) {
    final result = create();
    if (audit != null) result.audit = audit;
    return result;
  }

  CloseAuditResponse._();

  factory CloseAuditResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseAuditResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseAuditResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Audit>(1, _omitFieldNames ? '' : 'audit', subBuilder: Audit.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseAuditResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseAuditResponse copyWith(void Function(CloseAuditResponse) updates) =>
      super.copyWith((message) => updates(message as CloseAuditResponse))
          as CloseAuditResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseAuditResponse create() => CloseAuditResponse._();
  @$core.override
  CloseAuditResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseAuditResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseAuditResponse>(create);
  static CloseAuditResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Audit get audit => $_getN(0);
  @$pb.TagNumber(1)
  set audit(Audit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAudit() => $_has(0);
  @$pb.TagNumber(1)
  void clearAudit() => $_clearField(1);
  @$pb.TagNumber(1)
  Audit ensureAudit() => $_ensure(0);
}

class GetAuditRequest extends $pb.GeneratedMessage {
  factory GetAuditRequest({
    $core.String? auditId,
  }) {
    final result = create();
    if (auditId != null) result.auditId = auditId;
    return result;
  }

  GetAuditRequest._();

  factory GetAuditRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAuditRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAuditRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'auditId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAuditRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAuditRequest copyWith(void Function(GetAuditRequest) updates) =>
      super.copyWith((message) => updates(message as GetAuditRequest))
          as GetAuditRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAuditRequest create() => GetAuditRequest._();
  @$core.override
  GetAuditRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAuditRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAuditRequest>(create);
  static GetAuditRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get auditId => $_getSZ(0);
  @$pb.TagNumber(1)
  set auditId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAuditId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuditId() => $_clearField(1);
}

class GetAuditResponse extends $pb.GeneratedMessage {
  factory GetAuditResponse({
    Audit? audit,
  }) {
    final result = create();
    if (audit != null) result.audit = audit;
    return result;
  }

  GetAuditResponse._();

  factory GetAuditResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAuditResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAuditResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Audit>(1, _omitFieldNames ? '' : 'audit', subBuilder: Audit.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAuditResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAuditResponse copyWith(void Function(GetAuditResponse) updates) =>
      super.copyWith((message) => updates(message as GetAuditResponse))
          as GetAuditResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAuditResponse create() => GetAuditResponse._();
  @$core.override
  GetAuditResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAuditResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAuditResponse>(create);
  static GetAuditResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Audit get audit => $_getN(0);
  @$pb.TagNumber(1)
  set audit(Audit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAudit() => $_has(0);
  @$pb.TagNumber(1)
  void clearAudit() => $_clearField(1);
  @$pb.TagNumber(1)
  Audit ensureAudit() => $_ensure(0);
}

class ListAuditsRequest extends $pb.GeneratedMessage {
  factory ListAuditsRequest({
    AuditState? state,
    $core.int? pageSize,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListAuditsRequest._();

  factory ListAuditsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAuditsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAuditsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aE<AuditState>(1, _omitFieldNames ? '' : 'state',
        enumValues: AuditState.values)
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAuditsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAuditsRequest copyWith(void Function(ListAuditsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAuditsRequest))
          as ListAuditsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAuditsRequest create() => ListAuditsRequest._();
  @$core.override
  ListAuditsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAuditsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAuditsRequest>(create);
  static ListAuditsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  AuditState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(AuditState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListAuditsResponse extends $pb.GeneratedMessage {
  factory ListAuditsResponse({
    $core.Iterable<Audit>? audits,
  }) {
    final result = create();
    if (audits != null) result.audits.addAll(audits);
    return result;
  }

  ListAuditsResponse._();

  factory ListAuditsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAuditsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAuditsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<Audit>(1, _omitFieldNames ? '' : 'audits', subBuilder: Audit.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAuditsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAuditsResponse copyWith(void Function(ListAuditsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAuditsResponse))
          as ListAuditsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAuditsResponse create() => ListAuditsResponse._();
  @$core.override
  ListAuditsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAuditsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAuditsResponse>(create);
  static ListAuditsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Audit> get audits => $_getList(0);
}

class ListFindingsRequest extends $pb.GeneratedMessage {
  factory ListFindingsRequest({
    $core.String? auditId,
    $core.bool? openOnly,
  }) {
    final result = create();
    if (auditId != null) result.auditId = auditId;
    if (openOnly != null) result.openOnly = openOnly;
    return result;
  }

  ListFindingsRequest._();

  factory ListFindingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFindingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFindingsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'auditId')
    ..aOB(2, _omitFieldNames ? '' : 'openOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFindingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFindingsRequest copyWith(void Function(ListFindingsRequest) updates) =>
      super.copyWith((message) => updates(message as ListFindingsRequest))
          as ListFindingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFindingsRequest create() => ListFindingsRequest._();
  @$core.override
  ListFindingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFindingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFindingsRequest>(create);
  static ListFindingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get auditId => $_getSZ(0);
  @$pb.TagNumber(1)
  set auditId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAuditId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuditId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get openOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set openOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpenOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpenOnly() => $_clearField(2);
}

class ListFindingsResponse extends $pb.GeneratedMessage {
  factory ListFindingsResponse({
    $core.Iterable<Finding>? findings,
  }) {
    final result = create();
    if (findings != null) result.findings.addAll(findings);
    return result;
  }

  ListFindingsResponse._();

  factory ListFindingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFindingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFindingsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<Finding>(1, _omitFieldNames ? '' : 'findings',
        subBuilder: Finding.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFindingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFindingsResponse copyWith(void Function(ListFindingsResponse) updates) =>
      super.copyWith((message) => updates(message as ListFindingsResponse))
          as ListFindingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFindingsResponse create() => ListFindingsResponse._();
  @$core.override
  ListFindingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFindingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFindingsResponse>(create);
  static ListFindingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Finding> get findings => $_getList(0);
}

/// Committee is a standing group that meets and decides (SRS-QMS-008).
class Committee extends $pb.GeneratedMessage {
  factory Committee({
    $core.String? committeeId,
    $core.String? code,
    $core.String? name,
    $core.String? terms,
    $core.int? quorumSize,
    $core.bool? restricted,
    $core.Iterable<$core.String>? members,
    $core.bool? active,
  }) {
    final result = create();
    if (committeeId != null) result.committeeId = committeeId;
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (terms != null) result.terms = terms;
    if (quorumSize != null) result.quorumSize = quorumSize;
    if (restricted != null) result.restricted = restricted;
    if (members != null) result.members.addAll(members);
    if (active != null) result.active = active;
    return result;
  }

  Committee._();

  factory Committee.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Committee.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Committee',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'committeeId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'terms')
    ..aI(5, _omitFieldNames ? '' : 'quorumSize')
    ..aOB(6, _omitFieldNames ? '' : 'restricted')
    ..pPS(7, _omitFieldNames ? '' : 'members')
    ..aOB(8, _omitFieldNames ? '' : 'active')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Committee clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Committee copyWith(void Function(Committee) updates) =>
      super.copyWith((message) => updates(message as Committee)) as Committee;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Committee create() => Committee._();
  @$core.override
  Committee createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Committee getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Committee>(create);
  static Committee? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get committeeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set committeeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCommitteeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommitteeId() => $_clearField(1);

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
  $core.String get terms => $_getSZ(3);
  @$pb.TagNumber(4)
  set terms($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTerms() => $_has(3);
  @$pb.TagNumber(4)
  void clearTerms() => $_clearField(4);

  /// Zero means the hospital has not set one, which is reported rather than
  /// treated as "any number will do".
  @$pb.TagNumber(5)
  $core.int get quorumSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set quorumSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuorumSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuorumSize() => $_clearField(5);

  /// Minutes are peer-review material — mortality and morbidity, serious
  /// incident review.
  @$pb.TagNumber(6)
  $core.bool get restricted => $_getBF(5);
  @$pb.TagNumber(6)
  set restricted($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRestricted() => $_has(5);
  @$pb.TagNumber(6)
  void clearRestricted() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get members => $_getList(6);

  @$pb.TagNumber(8)
  $core.bool get active => $_getBF(7);
  @$pb.TagNumber(8)
  set active($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasActive() => $_has(7);
  @$pb.TagNumber(8)
  void clearActive() => $_clearField(8);
}

/// Decision is one thing a meeting decided (SRS-QMS-008).
class Decision extends $pb.GeneratedMessage {
  factory Decision({
    $core.String? text,
    $core.Iterable<$core.String>? actionIds,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (actionIds != null) result.actionIds.addAll(actionIds);
    return result;
  }

  Decision._();

  factory Decision.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Decision.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Decision',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..pPS(2, _omitFieldNames ? '' : 'actionIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Decision clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Decision copyWith(void Function(Decision) updates) =>
      super.copyWith((message) => updates(message as Decision)) as Decision;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Decision create() => Decision._();
  @$core.override
  Decision createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Decision getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Decision>(create);
  static Decision? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  /// Committee actions are corrective actions, not a second kind of task: an
  /// action item with an owner and a due date that escalates when it is late
  /// is what a CAPA already is.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get actionIds => $_getList(1);
}

/// Meeting is one sitting of a committee (SRS-QMS-008).
class Meeting extends $pb.GeneratedMessage {
  factory Meeting({
    $core.String? meetingId,
    $core.String? committeeId,
    $0.Timestamp? scheduledAt,
    $0.Timestamp? heldAt,
    $core.Iterable<$core.String>? agenda,
    $core.Iterable<$core.String>? attendees,
    $core.Iterable<$core.String>? apologies,
    $core.String? minutes,
    $core.Iterable<Decision>? decisions,
    MeetingState? state,
    $core.String? approvedBy,
    $0.Timestamp? approvedAt,
    $core.bool? restricted,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (meetingId != null) result.meetingId = meetingId;
    if (committeeId != null) result.committeeId = committeeId;
    if (scheduledAt != null) result.scheduledAt = scheduledAt;
    if (heldAt != null) result.heldAt = heldAt;
    if (agenda != null) result.agenda.addAll(agenda);
    if (attendees != null) result.attendees.addAll(attendees);
    if (apologies != null) result.apologies.addAll(apologies);
    if (minutes != null) result.minutes = minutes;
    if (decisions != null) result.decisions.addAll(decisions);
    if (state != null) result.state = state;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (restricted != null) result.restricted = restricted;
    if (version != null) result.version = version;
    return result;
  }

  Meeting._();

  factory Meeting.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Meeting.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Meeting',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'meetingId')
    ..aOS(2, _omitFieldNames ? '' : 'committeeId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'scheduledAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'heldAt',
        subBuilder: $0.Timestamp.create)
    ..pPS(5, _omitFieldNames ? '' : 'agenda')
    ..pPS(6, _omitFieldNames ? '' : 'attendees')
    ..pPS(7, _omitFieldNames ? '' : 'apologies')
    ..aOS(8, _omitFieldNames ? '' : 'minutes')
    ..pPM<Decision>(9, _omitFieldNames ? '' : 'decisions',
        subBuilder: Decision.create)
    ..aE<MeetingState>(10, _omitFieldNames ? '' : 'state',
        enumValues: MeetingState.values)
    ..aOS(11, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'approvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(13, _omitFieldNames ? '' : 'restricted')
    ..aInt64(14, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Meeting clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Meeting copyWith(void Function(Meeting) updates) =>
      super.copyWith((message) => updates(message as Meeting)) as Meeting;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Meeting create() => Meeting._();
  @$core.override
  Meeting createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Meeting getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Meeting>(create);
  static Meeting? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get meetingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set meetingId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMeetingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMeetingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get committeeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set committeeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommitteeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommitteeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get scheduledAt => $_getN(2);
  @$pb.TagNumber(3)
  set scheduledAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasScheduledAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearScheduledAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureScheduledAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get heldAt => $_getN(3);
  @$pb.TagNumber(4)
  set heldAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasHeldAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeldAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureHeldAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get agenda => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get attendees => $_getList(5);

  /// Recorded apart from absence: "did not come and said so" and "did not
  /// come" are different facts about a committee.
  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get apologies => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get minutes => $_getSZ(7);
  @$pb.TagNumber(8)
  set minutes($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMinutes() => $_has(7);
  @$pb.TagNumber(8)
  void clearMinutes() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<Decision> get decisions => $_getList(8);

  @$pb.TagNumber(10)
  MeetingState get state => $_getN(9);
  @$pb.TagNumber(10)
  set state(MeetingState value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasState() => $_has(9);
  @$pb.TagNumber(10)
  void clearState() => $_clearField(10);

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
  $core.bool get restricted => $_getBF(12);
  @$pb.TagNumber(13)
  set restricted($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRestricted() => $_has(12);
  @$pb.TagNumber(13)
  void clearRestricted() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get version => $_getI64(13);
  @$pb.TagNumber(14)
  set version($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasVersion() => $_has(13);
  @$pb.TagNumber(14)
  void clearVersion() => $_clearField(14);
}

class FormCommitteeRequest extends $pb.GeneratedMessage {
  factory FormCommitteeRequest({
    $core.String? code,
    $core.String? name,
    $core.String? terms,
    $core.int? quorumSize,
    $core.bool? restricted,
    $core.Iterable<$core.String>? members,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (terms != null) result.terms = terms;
    if (quorumSize != null) result.quorumSize = quorumSize;
    if (restricted != null) result.restricted = restricted;
    if (members != null) result.members.addAll(members);
    return result;
  }

  FormCommitteeRequest._();

  factory FormCommitteeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FormCommitteeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FormCommitteeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'terms')
    ..aI(4, _omitFieldNames ? '' : 'quorumSize')
    ..aOB(5, _omitFieldNames ? '' : 'restricted')
    ..pPS(6, _omitFieldNames ? '' : 'members')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FormCommitteeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FormCommitteeRequest copyWith(void Function(FormCommitteeRequest) updates) =>
      super.copyWith((message) => updates(message as FormCommitteeRequest))
          as FormCommitteeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormCommitteeRequest create() => FormCommitteeRequest._();
  @$core.override
  FormCommitteeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FormCommitteeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FormCommitteeRequest>(create);
  static FormCommitteeRequest? _defaultInstance;

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
  $core.String get terms => $_getSZ(2);
  @$pb.TagNumber(3)
  set terms($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTerms() => $_has(2);
  @$pb.TagNumber(3)
  void clearTerms() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get quorumSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set quorumSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuorumSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuorumSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get restricted => $_getBF(4);
  @$pb.TagNumber(5)
  set restricted($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRestricted() => $_has(4);
  @$pb.TagNumber(5)
  void clearRestricted() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get members => $_getList(5);
}

class FormCommitteeResponse extends $pb.GeneratedMessage {
  factory FormCommitteeResponse({
    Committee? committee,
  }) {
    final result = create();
    if (committee != null) result.committee = committee;
    return result;
  }

  FormCommitteeResponse._();

  factory FormCommitteeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FormCommitteeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FormCommitteeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Committee>(1, _omitFieldNames ? '' : 'committee',
        subBuilder: Committee.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FormCommitteeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FormCommitteeResponse copyWith(
          void Function(FormCommitteeResponse) updates) =>
      super.copyWith((message) => updates(message as FormCommitteeResponse))
          as FormCommitteeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormCommitteeResponse create() => FormCommitteeResponse._();
  @$core.override
  FormCommitteeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FormCommitteeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FormCommitteeResponse>(create);
  static FormCommitteeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Committee get committee => $_getN(0);
  @$pb.TagNumber(1)
  set committee(Committee value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCommittee() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommittee() => $_clearField(1);
  @$pb.TagNumber(1)
  Committee ensureCommittee() => $_ensure(0);
}

class ScheduleMeetingRequest extends $pb.GeneratedMessage {
  factory ScheduleMeetingRequest({
    $core.String? committeeId,
    $0.Timestamp? scheduledAt,
    $core.Iterable<$core.String>? agenda,
  }) {
    final result = create();
    if (committeeId != null) result.committeeId = committeeId;
    if (scheduledAt != null) result.scheduledAt = scheduledAt;
    if (agenda != null) result.agenda.addAll(agenda);
    return result;
  }

  ScheduleMeetingRequest._();

  factory ScheduleMeetingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScheduleMeetingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleMeetingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'committeeId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'scheduledAt',
        subBuilder: $0.Timestamp.create)
    ..pPS(3, _omitFieldNames ? '' : 'agenda')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleMeetingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleMeetingRequest copyWith(
          void Function(ScheduleMeetingRequest) updates) =>
      super.copyWith((message) => updates(message as ScheduleMeetingRequest))
          as ScheduleMeetingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduleMeetingRequest create() => ScheduleMeetingRequest._();
  @$core.override
  ScheduleMeetingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScheduleMeetingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScheduleMeetingRequest>(create);
  static ScheduleMeetingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get committeeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set committeeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCommitteeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommitteeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get scheduledAt => $_getN(1);
  @$pb.TagNumber(2)
  set scheduledAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasScheduledAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearScheduledAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureScheduledAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get agenda => $_getList(2);
}

class ScheduleMeetingResponse extends $pb.GeneratedMessage {
  factory ScheduleMeetingResponse({
    Meeting? meeting,
  }) {
    final result = create();
    if (meeting != null) result.meeting = meeting;
    return result;
  }

  ScheduleMeetingResponse._();

  factory ScheduleMeetingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScheduleMeetingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleMeetingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Meeting>(1, _omitFieldNames ? '' : 'meeting',
        subBuilder: Meeting.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleMeetingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleMeetingResponse copyWith(
          void Function(ScheduleMeetingResponse) updates) =>
      super.copyWith((message) => updates(message as ScheduleMeetingResponse))
          as ScheduleMeetingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduleMeetingResponse create() => ScheduleMeetingResponse._();
  @$core.override
  ScheduleMeetingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScheduleMeetingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScheduleMeetingResponse>(create);
  static ScheduleMeetingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Meeting get meeting => $_getN(0);
  @$pb.TagNumber(1)
  set meeting(Meeting value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMeeting() => $_has(0);
  @$pb.TagNumber(1)
  void clearMeeting() => $_clearField(1);
  @$pb.TagNumber(1)
  Meeting ensureMeeting() => $_ensure(0);
}

/// RecordMinutesRequest writes a sitting up and optionally approves it.
///
/// Minutes recording decisions cannot be approved below the committee's quorum:
/// a decision taken by two people from a committee of nine is not the
/// committee's decision, and minutes that record it as one are the document a
/// survey reads.
class RecordMinutesRequest extends $pb.GeneratedMessage {
  factory RecordMinutesRequest({
    $core.String? meetingId,
    $0.Timestamp? heldAt,
    $core.Iterable<$core.String>? attendees,
    $core.Iterable<$core.String>? apologies,
    $core.String? minutes,
    $core.Iterable<Decision>? decisions,
    $core.bool? approve,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (meetingId != null) result.meetingId = meetingId;
    if (heldAt != null) result.heldAt = heldAt;
    if (attendees != null) result.attendees.addAll(attendees);
    if (apologies != null) result.apologies.addAll(apologies);
    if (minutes != null) result.minutes = minutes;
    if (decisions != null) result.decisions.addAll(decisions);
    if (approve != null) result.approve = approve;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  RecordMinutesRequest._();

  factory RecordMinutesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordMinutesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordMinutesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'meetingId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'heldAt',
        subBuilder: $0.Timestamp.create)
    ..pPS(3, _omitFieldNames ? '' : 'attendees')
    ..pPS(4, _omitFieldNames ? '' : 'apologies')
    ..aOS(5, _omitFieldNames ? '' : 'minutes')
    ..pPM<Decision>(6, _omitFieldNames ? '' : 'decisions',
        subBuilder: Decision.create)
    ..aOB(7, _omitFieldNames ? '' : 'approve')
    ..aInt64(8, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordMinutesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordMinutesRequest copyWith(void Function(RecordMinutesRequest) updates) =>
      super.copyWith((message) => updates(message as RecordMinutesRequest))
          as RecordMinutesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordMinutesRequest create() => RecordMinutesRequest._();
  @$core.override
  RecordMinutesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordMinutesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordMinutesRequest>(create);
  static RecordMinutesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get meetingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set meetingId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMeetingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMeetingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get heldAt => $_getN(1);
  @$pb.TagNumber(2)
  set heldAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasHeldAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeldAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureHeldAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get attendees => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get apologies => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get minutes => $_getSZ(4);
  @$pb.TagNumber(5)
  set minutes($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMinutes() => $_has(4);
  @$pb.TagNumber(5)
  void clearMinutes() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<Decision> get decisions => $_getList(5);

  @$pb.TagNumber(7)
  $core.bool get approve => $_getBF(6);
  @$pb.TagNumber(7)
  set approve($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasApprove() => $_has(6);
  @$pb.TagNumber(7)
  void clearApprove() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get expectedVersion => $_getI64(7);
  @$pb.TagNumber(8)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasExpectedVersion() => $_has(7);
  @$pb.TagNumber(8)
  void clearExpectedVersion() => $_clearField(8);
}

class RecordMinutesResponse extends $pb.GeneratedMessage {
  factory RecordMinutesResponse({
    Meeting? meeting,
  }) {
    final result = create();
    if (meeting != null) result.meeting = meeting;
    return result;
  }

  RecordMinutesResponse._();

  factory RecordMinutesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordMinutesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordMinutesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Meeting>(1, _omitFieldNames ? '' : 'meeting',
        subBuilder: Meeting.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordMinutesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordMinutesResponse copyWith(
          void Function(RecordMinutesResponse) updates) =>
      super.copyWith((message) => updates(message as RecordMinutesResponse))
          as RecordMinutesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordMinutesResponse create() => RecordMinutesResponse._();
  @$core.override
  RecordMinutesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordMinutesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordMinutesResponse>(create);
  static RecordMinutesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Meeting get meeting => $_getN(0);
  @$pb.TagNumber(1)
  set meeting(Meeting value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMeeting() => $_has(0);
  @$pb.TagNumber(1)
  void clearMeeting() => $_clearField(1);
  @$pb.TagNumber(1)
  Meeting ensureMeeting() => $_ensure(0);
}

class GetMeetingRequest extends $pb.GeneratedMessage {
  factory GetMeetingRequest({
    $core.String? meetingId,
  }) {
    final result = create();
    if (meetingId != null) result.meetingId = meetingId;
    return result;
  }

  GetMeetingRequest._();

  factory GetMeetingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMeetingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMeetingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'meetingId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMeetingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMeetingRequest copyWith(void Function(GetMeetingRequest) updates) =>
      super.copyWith((message) => updates(message as GetMeetingRequest))
          as GetMeetingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMeetingRequest create() => GetMeetingRequest._();
  @$core.override
  GetMeetingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMeetingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMeetingRequest>(create);
  static GetMeetingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get meetingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set meetingId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMeetingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMeetingId() => $_clearField(1);
}

class GetMeetingResponse extends $pb.GeneratedMessage {
  factory GetMeetingResponse({
    Meeting? meeting,
  }) {
    final result = create();
    if (meeting != null) result.meeting = meeting;
    return result;
  }

  GetMeetingResponse._();

  factory GetMeetingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMeetingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMeetingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Meeting>(1, _omitFieldNames ? '' : 'meeting',
        subBuilder: Meeting.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMeetingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMeetingResponse copyWith(void Function(GetMeetingResponse) updates) =>
      super.copyWith((message) => updates(message as GetMeetingResponse))
          as GetMeetingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMeetingResponse create() => GetMeetingResponse._();
  @$core.override
  GetMeetingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMeetingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMeetingResponse>(create);
  static GetMeetingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Meeting get meeting => $_getN(0);
  @$pb.TagNumber(1)
  set meeting(Meeting value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMeeting() => $_has(0);
  @$pb.TagNumber(1)
  void clearMeeting() => $_clearField(1);
  @$pb.TagNumber(1)
  Meeting ensureMeeting() => $_ensure(0);
}

class ListCommitteesRequest extends $pb.GeneratedMessage {
  factory ListCommitteesRequest({
    $core.bool? activeOnly,
  }) {
    final result = create();
    if (activeOnly != null) result.activeOnly = activeOnly;
    return result;
  }

  ListCommitteesRequest._();

  factory ListCommitteesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCommitteesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCommitteesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'activeOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCommitteesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCommitteesRequest copyWith(
          void Function(ListCommitteesRequest) updates) =>
      super.copyWith((message) => updates(message as ListCommitteesRequest))
          as ListCommitteesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCommitteesRequest create() => ListCommitteesRequest._();
  @$core.override
  ListCommitteesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCommitteesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCommitteesRequest>(create);
  static ListCommitteesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get activeOnly => $_getBF(0);
  @$pb.TagNumber(1)
  set activeOnly($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActiveOnly() => $_has(0);
  @$pb.TagNumber(1)
  void clearActiveOnly() => $_clearField(1);
}

class ListCommitteesResponse extends $pb.GeneratedMessage {
  factory ListCommitteesResponse({
    $core.Iterable<Committee>? committees,
  }) {
    final result = create();
    if (committees != null) result.committees.addAll(committees);
    return result;
  }

  ListCommitteesResponse._();

  factory ListCommitteesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCommitteesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCommitteesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<Committee>(1, _omitFieldNames ? '' : 'committees',
        subBuilder: Committee.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCommitteesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCommitteesResponse copyWith(
          void Function(ListCommitteesResponse) updates) =>
      super.copyWith((message) => updates(message as ListCommitteesResponse))
          as ListCommitteesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCommitteesResponse create() => ListCommitteesResponse._();
  @$core.override
  ListCommitteesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCommitteesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCommitteesResponse>(create);
  static ListCommitteesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Committee> get committees => $_getList(0);
}

/// Standard is an accreditation standard (SRS-QMS-009).
class Standard extends $pb.GeneratedMessage {
  factory Standard({
    $core.String? standardId,
    $core.String? code,
    $core.String? name,
    $core.String? edition,
    $core.bool? active,
  }) {
    final result = create();
    if (standardId != null) result.standardId = standardId;
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (edition != null) result.edition = edition;
    if (active != null) result.active = active;
    return result;
  }

  Standard._();

  factory Standard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Standard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Standard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'standardId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'edition')
    ..aOB(5, _omitFieldNames ? '' : 'active')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Standard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Standard copyWith(void Function(Standard) updates) =>
      super.copyWith((message) => updates(message as Standard)) as Standard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Standard create() => Standard._();
  @$core.override
  Standard createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Standard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Standard>(create);
  static Standard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get standardId => $_getSZ(0);
  @$pb.TagNumber(1)
  set standardId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStandardId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStandardId() => $_clearField(1);

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

  /// Part of the identity: clause numbering changes between editions, and
  /// evidence filed under the old numbering is evidence against a clause that
  /// no longer exists.
  @$pb.TagNumber(4)
  $core.String get edition => $_getSZ(3);
  @$pb.TagNumber(4)
  set edition($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEdition() => $_has(3);
  @$pb.TagNumber(4)
  void clearEdition() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get active => $_getBF(4);
  @$pb.TagNumber(5)
  set active($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasActive() => $_has(4);
  @$pb.TagNumber(5)
  void clearActive() => $_clearField(5);
}

/// Clause is one requirement of a standard (SRS-QMS-009).
class Clause extends $pb.GeneratedMessage {
  factory Clause({
    $core.String? clauseId,
    $core.String? standardId,
    $core.String? reference,
    $core.String? chapter,
    $core.String? text,
    $core.bool? critical,
  }) {
    final result = create();
    if (clauseId != null) result.clauseId = clauseId;
    if (standardId != null) result.standardId = standardId;
    if (reference != null) result.reference = reference;
    if (chapter != null) result.chapter = chapter;
    if (text != null) result.text = text;
    if (critical != null) result.critical = critical;
    return result;
  }

  Clause._();

  factory Clause.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Clause.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Clause',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clauseId')
    ..aOS(2, _omitFieldNames ? '' : 'standardId')
    ..aOS(3, _omitFieldNames ? '' : 'reference')
    ..aOS(4, _omitFieldNames ? '' : 'chapter')
    ..aOS(5, _omitFieldNames ? '' : 'text')
    ..aOB(6, _omitFieldNames ? '' : 'critical')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Clause clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Clause copyWith(void Function(Clause) updates) =>
      super.copyWith((message) => updates(message as Clause)) as Clause;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Clause create() => Clause._();
  @$core.override
  Clause createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Clause getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Clause>(create);
  static Clause? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clauseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clauseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClauseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClauseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get standardId => $_getSZ(1);
  @$pb.TagNumber(2)
  set standardId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStandardId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStandardId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reference => $_getSZ(2);
  @$pb.TagNumber(3)
  set reference($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReference() => $_has(2);
  @$pb.TagNumber(3)
  void clearReference() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get chapter => $_getSZ(3);
  @$pb.TagNumber(4)
  set chapter($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChapter() => $_has(3);
  @$pb.TagNumber(4)
  void clearChapter() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get text => $_getSZ(4);
  @$pb.TagNumber(5)
  set text($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasText() => $_has(4);
  @$pb.TagNumber(5)
  void clearText() => $_clearField(5);

  /// A clause a survey will not pass without. Counted apart, because a
  /// readiness report that treats every clause as equal hides the ones that
  /// matter.
  @$pb.TagNumber(6)
  $core.bool get critical => $_getBF(5);
  @$pb.TagNumber(6)
  set critical($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCritical() => $_has(5);
  @$pb.TagNumber(6)
  void clearCritical() => $_clearField(6);
}

class ClauseInput extends $pb.GeneratedMessage {
  factory ClauseInput({
    $core.String? reference,
    $core.String? chapter,
    $core.String? text,
    $core.bool? critical,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    if (chapter != null) result.chapter = chapter;
    if (text != null) result.text = text;
    if (critical != null) result.critical = critical;
    return result;
  }

  ClauseInput._();

  factory ClauseInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClauseInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClauseInput',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..aOS(2, _omitFieldNames ? '' : 'chapter')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aOB(4, _omitFieldNames ? '' : 'critical')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClauseInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClauseInput copyWith(void Function(ClauseInput) updates) =>
      super.copyWith((message) => updates(message as ClauseInput))
          as ClauseInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClauseInput create() => ClauseInput._();
  @$core.override
  ClauseInput createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClauseInput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClauseInput>(create);
  static ClauseInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reference => $_getSZ(0);
  @$pb.TagNumber(1)
  set reference($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReference() => $_has(0);
  @$pb.TagNumber(1)
  void clearReference() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get chapter => $_getSZ(1);
  @$pb.TagNumber(2)
  set chapter($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChapter() => $_has(1);
  @$pb.TagNumber(2)
  void clearChapter() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get critical => $_getBF(3);
  @$pb.TagNumber(4)
  set critical($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCritical() => $_has(3);
  @$pb.TagNumber(4)
  void clearCritical() => $_clearField(4);
}

/// LoadStandardRequest registers a standard and its clause tree in one call.
///
/// A half-loaded standard is a readiness report that says the hospital is doing
/// better than it is, because the clauses that did not load are clauses nobody
/// is failing.
class LoadStandardRequest extends $pb.GeneratedMessage {
  factory LoadStandardRequest({
    $core.String? code,
    $core.String? name,
    $core.String? edition,
    $core.Iterable<ClauseInput>? clauses,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (edition != null) result.edition = edition;
    if (clauses != null) result.clauses.addAll(clauses);
    return result;
  }

  LoadStandardRequest._();

  factory LoadStandardRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoadStandardRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoadStandardRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'edition')
    ..pPM<ClauseInput>(4, _omitFieldNames ? '' : 'clauses',
        subBuilder: ClauseInput.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoadStandardRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoadStandardRequest copyWith(void Function(LoadStandardRequest) updates) =>
      super.copyWith((message) => updates(message as LoadStandardRequest))
          as LoadStandardRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoadStandardRequest create() => LoadStandardRequest._();
  @$core.override
  LoadStandardRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoadStandardRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoadStandardRequest>(create);
  static LoadStandardRequest? _defaultInstance;

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
  $core.String get edition => $_getSZ(2);
  @$pb.TagNumber(3)
  set edition($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEdition() => $_has(2);
  @$pb.TagNumber(3)
  void clearEdition() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<ClauseInput> get clauses => $_getList(3);
}

class LoadStandardResponse extends $pb.GeneratedMessage {
  factory LoadStandardResponse({
    Standard? standard,
    $core.int? clausesLoaded,
  }) {
    final result = create();
    if (standard != null) result.standard = standard;
    if (clausesLoaded != null) result.clausesLoaded = clausesLoaded;
    return result;
  }

  LoadStandardResponse._();

  factory LoadStandardResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoadStandardResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoadStandardResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Standard>(1, _omitFieldNames ? '' : 'standard',
        subBuilder: Standard.create)
    ..aI(2, _omitFieldNames ? '' : 'clausesLoaded')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoadStandardResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoadStandardResponse copyWith(void Function(LoadStandardResponse) updates) =>
      super.copyWith((message) => updates(message as LoadStandardResponse))
          as LoadStandardResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoadStandardResponse create() => LoadStandardResponse._();
  @$core.override
  LoadStandardResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoadStandardResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoadStandardResponse>(create);
  static LoadStandardResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Standard get standard => $_getN(0);
  @$pb.TagNumber(1)
  set standard(Standard value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStandard() => $_has(0);
  @$pb.TagNumber(1)
  void clearStandard() => $_clearField(1);
  @$pb.TagNumber(1)
  Standard ensureStandard() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get clausesLoaded => $_getIZ(1);
  @$pb.TagNumber(2)
  set clausesLoaded($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClausesLoaded() => $_has(1);
  @$pb.TagNumber(2)
  void clearClausesLoaded() => $_clearField(2);
}

/// Evidence is one thing offered against one clause (SRS-QMS-009).
class Evidence extends $pb.GeneratedMessage {
  factory Evidence({
    $core.String? evidenceId,
    $core.String? clauseId,
    EvidenceKind? kind,
    $core.String? refId,
    $core.String? externalRef,
    $core.String? description,
    $0.Timestamp? addedAt,
    $core.String? addedBy,
    $0.Timestamp? removedAt,
    $core.String? removedBy,
    $core.String? removedWhy,
  }) {
    final result = create();
    if (evidenceId != null) result.evidenceId = evidenceId;
    if (clauseId != null) result.clauseId = clauseId;
    if (kind != null) result.kind = kind;
    if (refId != null) result.refId = refId;
    if (externalRef != null) result.externalRef = externalRef;
    if (description != null) result.description = description;
    if (addedAt != null) result.addedAt = addedAt;
    if (addedBy != null) result.addedBy = addedBy;
    if (removedAt != null) result.removedAt = removedAt;
    if (removedBy != null) result.removedBy = removedBy;
    if (removedWhy != null) result.removedWhy = removedWhy;
    return result;
  }

  Evidence._();

  factory Evidence.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Evidence.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Evidence',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'evidenceId')
    ..aOS(2, _omitFieldNames ? '' : 'clauseId')
    ..aE<EvidenceKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: EvidenceKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'refId')
    ..aOS(5, _omitFieldNames ? '' : 'externalRef')
    ..aOS(6, _omitFieldNames ? '' : 'description')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'addedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'addedBy')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'removedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'removedBy')
    ..aOS(11, _omitFieldNames ? '' : 'removedWhy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Evidence clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Evidence copyWith(void Function(Evidence) updates) =>
      super.copyWith((message) => updates(message as Evidence)) as Evidence;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Evidence create() => Evidence._();
  @$core.override
  Evidence createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Evidence getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Evidence>(create);
  static Evidence? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get evidenceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set evidenceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEvidenceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvidenceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clauseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set clauseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClauseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearClauseId() => $_clearField(2);

  @$pb.TagNumber(3)
  EvidenceKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(EvidenceKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get refId => $_getSZ(3);
  @$pb.TagNumber(4)
  set refId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRefId() => $_has(3);
  @$pb.TagNumber(4)
  void clearRefId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get externalRef => $_getSZ(4);
  @$pb.TagNumber(5)
  set externalRef($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExternalRef() => $_has(4);
  @$pb.TagNumber(5)
  void clearExternalRef() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get description => $_getSZ(5);
  @$pb.TagNumber(6)
  set description($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearDescription() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get addedAt => $_getN(6);
  @$pb.TagNumber(7)
  set addedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAddedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearAddedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureAddedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get addedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set addedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAddedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearAddedBy() => $_clearField(8);

  /// Withdrawn rather than deleted: a survey that asks what changed since the
  /// last one is asking exactly this.
  @$pb.TagNumber(9)
  $0.Timestamp get removedAt => $_getN(8);
  @$pb.TagNumber(9)
  set removedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasRemovedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearRemovedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureRemovedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get removedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set removedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRemovedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearRemovedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get removedWhy => $_getSZ(10);
  @$pb.TagNumber(11)
  set removedWhy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRemovedWhy() => $_has(10);
  @$pb.TagNumber(11)
  void clearRemovedWhy() => $_clearField(11);
}

class FileEvidenceRequest extends $pb.GeneratedMessage {
  factory FileEvidenceRequest({
    $core.String? clauseId,
    EvidenceKind? kind,
    $core.String? refId,
    $core.String? externalRef,
    $core.String? description,
  }) {
    final result = create();
    if (clauseId != null) result.clauseId = clauseId;
    if (kind != null) result.kind = kind;
    if (refId != null) result.refId = refId;
    if (externalRef != null) result.externalRef = externalRef;
    if (description != null) result.description = description;
    return result;
  }

  FileEvidenceRequest._();

  factory FileEvidenceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FileEvidenceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FileEvidenceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clauseId')
    ..aE<EvidenceKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: EvidenceKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'refId')
    ..aOS(4, _omitFieldNames ? '' : 'externalRef')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileEvidenceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileEvidenceRequest copyWith(void Function(FileEvidenceRequest) updates) =>
      super.copyWith((message) => updates(message as FileEvidenceRequest))
          as FileEvidenceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileEvidenceRequest create() => FileEvidenceRequest._();
  @$core.override
  FileEvidenceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FileEvidenceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FileEvidenceRequest>(create);
  static FileEvidenceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clauseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clauseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClauseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClauseId() => $_clearField(1);

  @$pb.TagNumber(2)
  EvidenceKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(EvidenceKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  /// The record inside this system, for every kind but EXTERNAL. Checked to
  /// exist: evidence naming a record that does not is a tick in a box that
  /// looks like a link.
  @$pb.TagNumber(3)
  $core.String get refId => $_getSZ(2);
  @$pb.TagNumber(3)
  set refId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRefId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRefId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get externalRef => $_getSZ(3);
  @$pb.TagNumber(4)
  set externalRef($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExternalRef() => $_has(3);
  @$pb.TagNumber(4)
  void clearExternalRef() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);
}

class FileEvidenceResponse extends $pb.GeneratedMessage {
  factory FileEvidenceResponse({
    Evidence? evidence,
  }) {
    final result = create();
    if (evidence != null) result.evidence = evidence;
    return result;
  }

  FileEvidenceResponse._();

  factory FileEvidenceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FileEvidenceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FileEvidenceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Evidence>(1, _omitFieldNames ? '' : 'evidence',
        subBuilder: Evidence.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileEvidenceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileEvidenceResponse copyWith(void Function(FileEvidenceResponse) updates) =>
      super.copyWith((message) => updates(message as FileEvidenceResponse))
          as FileEvidenceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileEvidenceResponse create() => FileEvidenceResponse._();
  @$core.override
  FileEvidenceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FileEvidenceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FileEvidenceResponse>(create);
  static FileEvidenceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Evidence get evidence => $_getN(0);
  @$pb.TagNumber(1)
  set evidence(Evidence value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEvidence() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvidence() => $_clearField(1);
  @$pb.TagNumber(1)
  Evidence ensureEvidence() => $_ensure(0);
}

class WithdrawEvidenceRequest extends $pb.GeneratedMessage {
  factory WithdrawEvidenceRequest({
    $core.String? evidenceId,
    $core.String? reason,
  }) {
    final result = create();
    if (evidenceId != null) result.evidenceId = evidenceId;
    if (reason != null) result.reason = reason;
    return result;
  }

  WithdrawEvidenceRequest._();

  factory WithdrawEvidenceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WithdrawEvidenceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WithdrawEvidenceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'evidenceId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawEvidenceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawEvidenceRequest copyWith(
          void Function(WithdrawEvidenceRequest) updates) =>
      super.copyWith((message) => updates(message as WithdrawEvidenceRequest))
          as WithdrawEvidenceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WithdrawEvidenceRequest create() => WithdrawEvidenceRequest._();
  @$core.override
  WithdrawEvidenceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WithdrawEvidenceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WithdrawEvidenceRequest>(create);
  static WithdrawEvidenceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get evidenceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set evidenceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEvidenceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvidenceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class WithdrawEvidenceResponse extends $pb.GeneratedMessage {
  factory WithdrawEvidenceResponse() => create();

  WithdrawEvidenceResponse._();

  factory WithdrawEvidenceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WithdrawEvidenceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WithdrawEvidenceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawEvidenceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawEvidenceResponse copyWith(
          void Function(WithdrawEvidenceResponse) updates) =>
      super.copyWith((message) => updates(message as WithdrawEvidenceResponse))
          as WithdrawEvidenceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WithdrawEvidenceResponse create() => WithdrawEvidenceResponse._();
  @$core.override
  WithdrawEvidenceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WithdrawEvidenceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WithdrawEvidenceResponse>(create);
  static WithdrawEvidenceResponse? _defaultInstance;
}

class ReviewClauseRequest extends $pb.GeneratedMessage {
  factory ReviewClauseRequest({
    $core.String? standardId,
    $core.String? clauseId,
    Verdict? verdict,
    $core.String? note,
    $core.String? capaId,
  }) {
    final result = create();
    if (standardId != null) result.standardId = standardId;
    if (clauseId != null) result.clauseId = clauseId;
    if (verdict != null) result.verdict = verdict;
    if (note != null) result.note = note;
    if (capaId != null) result.capaId = capaId;
    return result;
  }

  ReviewClauseRequest._();

  factory ReviewClauseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReviewClauseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewClauseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'standardId')
    ..aOS(2, _omitFieldNames ? '' : 'clauseId')
    ..aE<Verdict>(3, _omitFieldNames ? '' : 'verdict',
        enumValues: Verdict.values)
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..aOS(5, _omitFieldNames ? '' : 'capaId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewClauseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewClauseRequest copyWith(void Function(ReviewClauseRequest) updates) =>
      super.copyWith((message) => updates(message as ReviewClauseRequest))
          as ReviewClauseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReviewClauseRequest create() => ReviewClauseRequest._();
  @$core.override
  ReviewClauseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReviewClauseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewClauseRequest>(create);
  static ReviewClauseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get standardId => $_getSZ(0);
  @$pb.TagNumber(1)
  set standardId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStandardId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStandardId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clauseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set clauseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClauseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearClauseId() => $_clearField(2);

  @$pb.TagNumber(3)
  Verdict get verdict => $_getN(2);
  @$pb.TagNumber(3)
  set verdict(Verdict value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasVerdict() => $_has(2);
  @$pb.TagNumber(3)
  void clearVerdict() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);

  /// Required for NOT_MET.
  @$pb.TagNumber(5)
  $core.String get capaId => $_getSZ(4);
  @$pb.TagNumber(5)
  set capaId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCapaId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCapaId() => $_clearField(5);
}

class ReviewClauseResponse extends $pb.GeneratedMessage {
  factory ReviewClauseResponse({
    $core.String? reviewId,
    Verdict? verdict,
    $0.Timestamp? reviewedAt,
  }) {
    final result = create();
    if (reviewId != null) result.reviewId = reviewId;
    if (verdict != null) result.verdict = verdict;
    if (reviewedAt != null) result.reviewedAt = reviewedAt;
    return result;
  }

  ReviewClauseResponse._();

  factory ReviewClauseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReviewClauseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewClauseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..aE<Verdict>(2, _omitFieldNames ? '' : 'verdict',
        enumValues: Verdict.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'reviewedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewClauseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewClauseResponse copyWith(void Function(ReviewClauseResponse) updates) =>
      super.copyWith((message) => updates(message as ReviewClauseResponse))
          as ReviewClauseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReviewClauseResponse create() => ReviewClauseResponse._();
  @$core.override
  ReviewClauseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReviewClauseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewClauseResponse>(create);
  static ReviewClauseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);

  @$pb.TagNumber(2)
  Verdict get verdict => $_getN(1);
  @$pb.TagNumber(2)
  set verdict(Verdict value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasVerdict() => $_has(1);
  @$pb.TagNumber(2)
  void clearVerdict() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get reviewedAt => $_getN(2);
  @$pb.TagNumber(3)
  set reviewedAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReviewedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearReviewedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureReviewedAt() => $_ensure(2);
}

/// ClauseStatus is one line of the readiness view (SRS-QMS-014).
class ClauseStatus extends $pb.GeneratedMessage {
  factory ClauseStatus({
    $core.String? clauseId,
    $core.String? reference,
    $core.String? chapter,
    $core.bool? critical,
    Verdict? verdict,
    $core.int? evidenceCount,
    $0.Timestamp? reviewedAt,
    $core.String? reviewedBy,
    $core.bool? stale,
    $core.String? capaId,
  }) {
    final result = create();
    if (clauseId != null) result.clauseId = clauseId;
    if (reference != null) result.reference = reference;
    if (chapter != null) result.chapter = chapter;
    if (critical != null) result.critical = critical;
    if (verdict != null) result.verdict = verdict;
    if (evidenceCount != null) result.evidenceCount = evidenceCount;
    if (reviewedAt != null) result.reviewedAt = reviewedAt;
    if (reviewedBy != null) result.reviewedBy = reviewedBy;
    if (stale != null) result.stale = stale;
    if (capaId != null) result.capaId = capaId;
    return result;
  }

  ClauseStatus._();

  factory ClauseStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClauseStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClauseStatus',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clauseId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aOS(3, _omitFieldNames ? '' : 'chapter')
    ..aOB(4, _omitFieldNames ? '' : 'critical')
    ..aE<Verdict>(5, _omitFieldNames ? '' : 'verdict',
        enumValues: Verdict.values)
    ..aI(6, _omitFieldNames ? '' : 'evidenceCount')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'reviewedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'reviewedBy')
    ..aOB(9, _omitFieldNames ? '' : 'stale')
    ..aOS(10, _omitFieldNames ? '' : 'capaId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClauseStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClauseStatus copyWith(void Function(ClauseStatus) updates) =>
      super.copyWith((message) => updates(message as ClauseStatus))
          as ClauseStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClauseStatus create() => ClauseStatus._();
  @$core.override
  ClauseStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClauseStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClauseStatus>(create);
  static ClauseStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clauseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clauseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClauseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClauseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reference => $_getSZ(1);
  @$pb.TagNumber(2)
  set reference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearReference() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get chapter => $_getSZ(2);
  @$pb.TagNumber(3)
  set chapter($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChapter() => $_has(2);
  @$pb.TagNumber(3)
  void clearChapter() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get critical => $_getBF(3);
  @$pb.TagNumber(4)
  set critical($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCritical() => $_has(3);
  @$pb.TagNumber(4)
  void clearCritical() => $_clearField(4);

  @$pb.TagNumber(5)
  Verdict get verdict => $_getN(4);
  @$pb.TagNumber(5)
  set verdict(Verdict value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasVerdict() => $_has(4);
  @$pb.TagNumber(5)
  void clearVerdict() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get evidenceCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set evidenceCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEvidenceCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearEvidenceCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get reviewedAt => $_getN(6);
  @$pb.TagNumber(7)
  set reviewedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasReviewedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearReviewedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureReviewedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get reviewedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set reviewedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReviewedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearReviewedBy() => $_clearField(8);

  /// Reviewed longer ago than the survey window. A judgement from three years
  /// ago is not evidence that the clause is met today.
  @$pb.TagNumber(9)
  $core.bool get stale => $_getBF(8);
  @$pb.TagNumber(9)
  set stale($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasStale() => $_has(8);
  @$pb.TagNumber(9)
  void clearStale() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get capaId => $_getSZ(9);
  @$pb.TagNumber(10)
  set capaId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCapaId() => $_has(9);
  @$pb.TagNumber(10)
  void clearCapaId() => $_clearField(10);
}

class GetReadinessRequest extends $pb.GeneratedMessage {
  factory GetReadinessRequest({
    $core.String? standardId,
  }) {
    final result = create();
    if (standardId != null) result.standardId = standardId;
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
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'standardId')
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
  $core.String get standardId => $_getSZ(0);
  @$pb.TagNumber(1)
  set standardId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStandardId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStandardId() => $_clearField(1);
}

/// GetReadinessResponse is the survey-preparation picture (SRS-QMS-014).
///
/// Derived every time. A stored readiness percentage is out of date the moment
/// a document is revised or an action closes.
class GetReadinessResponse extends $pb.GeneratedMessage {
  factory GetReadinessResponse({
    $core.String? standardId,
    $core.int? total,
    $core.int? met,
    $core.int? partiallyMet,
    $core.int? notMet,
    $core.int? notApplicable,
    $core.int? unreviewed,
    $core.int? criticalGaps,
    $core.int? staleReviews,
    $core.int? evidenceGaps,
    $core.int? overdueActions,
    $core.Iterable<ClauseStatus>? clauses,
  }) {
    final result = create();
    if (standardId != null) result.standardId = standardId;
    if (total != null) result.total = total;
    if (met != null) result.met = met;
    if (partiallyMet != null) result.partiallyMet = partiallyMet;
    if (notMet != null) result.notMet = notMet;
    if (notApplicable != null) result.notApplicable = notApplicable;
    if (unreviewed != null) result.unreviewed = unreviewed;
    if (criticalGaps != null) result.criticalGaps = criticalGaps;
    if (staleReviews != null) result.staleReviews = staleReviews;
    if (evidenceGaps != null) result.evidenceGaps = evidenceGaps;
    if (overdueActions != null) result.overdueActions = overdueActions;
    if (clauses != null) result.clauses.addAll(clauses);
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
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'standardId')
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..aI(3, _omitFieldNames ? '' : 'met')
    ..aI(4, _omitFieldNames ? '' : 'partiallyMet')
    ..aI(5, _omitFieldNames ? '' : 'notMet')
    ..aI(6, _omitFieldNames ? '' : 'notApplicable')
    ..aI(7, _omitFieldNames ? '' : 'unreviewed')
    ..aI(8, _omitFieldNames ? '' : 'criticalGaps')
    ..aI(9, _omitFieldNames ? '' : 'staleReviews')
    ..aI(10, _omitFieldNames ? '' : 'evidenceGaps')
    ..aI(11, _omitFieldNames ? '' : 'overdueActions')
    ..pPM<ClauseStatus>(12, _omitFieldNames ? '' : 'clauses',
        subBuilder: ClauseStatus.create)
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
  $core.String get standardId => $_getSZ(0);
  @$pb.TagNumber(1)
  set standardId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStandardId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStandardId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get met => $_getIZ(2);
  @$pb.TagNumber(3)
  set met($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMet() => $_has(2);
  @$pb.TagNumber(3)
  void clearMet() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get partiallyMet => $_getIZ(3);
  @$pb.TagNumber(4)
  set partiallyMet($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPartiallyMet() => $_has(3);
  @$pb.TagNumber(4)
  void clearPartiallyMet() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get notMet => $_getIZ(4);
  @$pb.TagNumber(5)
  set notMet($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNotMet() => $_has(4);
  @$pb.TagNumber(5)
  void clearNotMet() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get notApplicable => $_getIZ(5);
  @$pb.TagNumber(6)
  set notApplicable($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNotApplicable() => $_has(5);
  @$pb.TagNumber(6)
  void clearNotApplicable() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get unreviewed => $_getIZ(6);
  @$pb.TagNumber(7)
  set unreviewed($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUnreviewed() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnreviewed() => $_clearField(7);

  /// Critical clauses not met, partially met or never reviewed. Counted apart
  /// because a survey does not average them in with the rest.
  @$pb.TagNumber(8)
  $core.int get criticalGaps => $_getIZ(7);
  @$pb.TagNumber(8)
  set criticalGaps($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCriticalGaps() => $_has(7);
  @$pb.TagNumber(8)
  void clearCriticalGaps() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get staleReviews => $_getIZ(8);
  @$pb.TagNumber(9)
  set staleReviews($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasStaleReviews() => $_has(8);
  @$pb.TagNumber(9)
  void clearStaleReviews() => $_clearField(9);

  /// Clauses with no live evidence at all, whatever the verdict says.
  @$pb.TagNumber(10)
  $core.int get evidenceGaps => $_getIZ(9);
  @$pb.TagNumber(10)
  set evidenceGaps($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasEvidenceGaps() => $_has(9);
  @$pb.TagNumber(10)
  void clearEvidenceGaps() => $_clearField(10);

  /// The hospital's overdue corrective actions, not this standard's: a survey
  /// asks whether the quality system is working.
  @$pb.TagNumber(11)
  $core.int get overdueActions => $_getIZ(10);
  @$pb.TagNumber(11)
  set overdueActions($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOverdueActions() => $_has(10);
  @$pb.TagNumber(11)
  void clearOverdueActions() => $_clearField(11);

  /// Worst first, critical before ordinary at the same verdict.
  @$pb.TagNumber(12)
  $pb.PbList<ClauseStatus> get clauses => $_getList(11);
}

class ListStandardsRequest extends $pb.GeneratedMessage {
  factory ListStandardsRequest({
    $core.bool? activeOnly,
  }) {
    final result = create();
    if (activeOnly != null) result.activeOnly = activeOnly;
    return result;
  }

  ListStandardsRequest._();

  factory ListStandardsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListStandardsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListStandardsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'activeOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStandardsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStandardsRequest copyWith(void Function(ListStandardsRequest) updates) =>
      super.copyWith((message) => updates(message as ListStandardsRequest))
          as ListStandardsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListStandardsRequest create() => ListStandardsRequest._();
  @$core.override
  ListStandardsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListStandardsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListStandardsRequest>(create);
  static ListStandardsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get activeOnly => $_getBF(0);
  @$pb.TagNumber(1)
  set activeOnly($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActiveOnly() => $_has(0);
  @$pb.TagNumber(1)
  void clearActiveOnly() => $_clearField(1);
}

class ListStandardsResponse extends $pb.GeneratedMessage {
  factory ListStandardsResponse({
    $core.Iterable<Standard>? standards,
  }) {
    final result = create();
    if (standards != null) result.standards.addAll(standards);
    return result;
  }

  ListStandardsResponse._();

  factory ListStandardsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListStandardsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListStandardsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<Standard>(1, _omitFieldNames ? '' : 'standards',
        subBuilder: Standard.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStandardsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStandardsResponse copyWith(
          void Function(ListStandardsResponse) updates) =>
      super.copyWith((message) => updates(message as ListStandardsResponse))
          as ListStandardsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListStandardsResponse create() => ListStandardsResponse._();
  @$core.override
  ListStandardsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListStandardsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListStandardsResponse>(create);
  static ListStandardsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Standard> get standards => $_getList(0);
}

class ListClausesRequest extends $pb.GeneratedMessage {
  factory ListClausesRequest({
    $core.String? standardId,
  }) {
    final result = create();
    if (standardId != null) result.standardId = standardId;
    return result;
  }

  ListClausesRequest._();

  factory ListClausesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListClausesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListClausesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'standardId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListClausesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListClausesRequest copyWith(void Function(ListClausesRequest) updates) =>
      super.copyWith((message) => updates(message as ListClausesRequest))
          as ListClausesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListClausesRequest create() => ListClausesRequest._();
  @$core.override
  ListClausesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListClausesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListClausesRequest>(create);
  static ListClausesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get standardId => $_getSZ(0);
  @$pb.TagNumber(1)
  set standardId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStandardId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStandardId() => $_clearField(1);
}

class ListClausesResponse extends $pb.GeneratedMessage {
  factory ListClausesResponse({
    $core.Iterable<Clause>? clauses,
  }) {
    final result = create();
    if (clauses != null) result.clauses.addAll(clauses);
    return result;
  }

  ListClausesResponse._();

  factory ListClausesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListClausesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListClausesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<Clause>(1, _omitFieldNames ? '' : 'clauses',
        subBuilder: Clause.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListClausesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListClausesResponse copyWith(void Function(ListClausesResponse) updates) =>
      super.copyWith((message) => updates(message as ListClausesResponse))
          as ListClausesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListClausesResponse create() => ListClausesResponse._();
  @$core.override
  ListClausesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListClausesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListClausesResponse>(create);
  static ListClausesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Clause> get clauses => $_getList(0);
}

/// IndicatorDefinition is one entry in the dictionary (SRS-QMS-010).
class IndicatorDefinition extends $pb.GeneratedMessage {
  factory IndicatorDefinition({
    $core.String? definitionId,
    $core.String? code,
    $core.String? name,
    $core.int? revision,
    $core.String? numerator,
    $core.String? denominator,
    $core.String? unit,
    $core.int? targetPermille,
    Direction? direction,
    Frequency? frequency,
    $core.String? ownerId,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? supersededAt,
  }) {
    final result = create();
    if (definitionId != null) result.definitionId = definitionId;
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (revision != null) result.revision = revision;
    if (numerator != null) result.numerator = numerator;
    if (denominator != null) result.denominator = denominator;
    if (unit != null) result.unit = unit;
    if (targetPermille != null) result.targetPermille = targetPermille;
    if (direction != null) result.direction = direction;
    if (frequency != null) result.frequency = frequency;
    if (ownerId != null) result.ownerId = ownerId;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (supersededAt != null) result.supersededAt = supersededAt;
    return result;
  }

  IndicatorDefinition._();

  factory IndicatorDefinition.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IndicatorDefinition.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IndicatorDefinition',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'definitionId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aI(4, _omitFieldNames ? '' : 'revision')
    ..aOS(5, _omitFieldNames ? '' : 'numerator')
    ..aOS(6, _omitFieldNames ? '' : 'denominator')
    ..aOS(7, _omitFieldNames ? '' : 'unit')
    ..aI(8, _omitFieldNames ? '' : 'targetPermille')
    ..aE<Direction>(9, _omitFieldNames ? '' : 'direction',
        enumValues: Direction.values)
    ..aE<Frequency>(10, _omitFieldNames ? '' : 'frequency',
        enumValues: Frequency.values)
    ..aOS(11, _omitFieldNames ? '' : 'ownerId')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'supersededAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IndicatorDefinition clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IndicatorDefinition copyWith(void Function(IndicatorDefinition) updates) =>
      super.copyWith((message) => updates(message as IndicatorDefinition))
          as IndicatorDefinition;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IndicatorDefinition create() => IndicatorDefinition._();
  @$core.override
  IndicatorDefinition createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IndicatorDefinition getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IndicatorDefinition>(create);
  static IndicatorDefinition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get definitionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set definitionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDefinitionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDefinitionId() => $_clearField(1);

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

  /// Assigned by the server, one past whatever exists. Versioned and never
  /// edited: an indicator changed in place turns its own history into two
  /// different measurements plotted on one line.
  @$pb.TagNumber(4)
  $core.int get revision => $_getIZ(3);
  @$pb.TagNumber(4)
  set revision($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevision() => $_clearField(4);

  /// What is counted, in words. Computing these from the hospital's source
  /// records is a reporting engine's job and is a named seam rather than half
  /// built here.
  @$pb.TagNumber(5)
  $core.String get numerator => $_getSZ(4);
  @$pb.TagNumber(5)
  set numerator($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNumerator() => $_has(4);
  @$pb.TagNumber(5)
  void clearNumerator() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get denominator => $_getSZ(5);
  @$pb.TagNumber(6)
  set denominator($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDenominator() => $_has(5);
  @$pb.TagNumber(6)
  void clearDenominator() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get unit => $_getSZ(6);
  @$pb.TagNumber(7)
  set unit($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUnit() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnit() => $_clearField(7);

  /// Parts per thousand and an integer. A float target that reads 0.949999 in
  /// one report and 95% in another is an argument in a committee meeting.
  @$pb.TagNumber(8)
  $core.int get targetPermille => $_getIZ(7);
  @$pb.TagNumber(8)
  set targetPermille($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTargetPermille() => $_has(7);
  @$pb.TagNumber(8)
  void clearTargetPermille() => $_clearField(8);

  @$pb.TagNumber(9)
  Direction get direction => $_getN(8);
  @$pb.TagNumber(9)
  set direction(Direction value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasDirection() => $_has(8);
  @$pb.TagNumber(9)
  void clearDirection() => $_clearField(9);

  @$pb.TagNumber(10)
  Frequency get frequency => $_getN(9);
  @$pb.TagNumber(10)
  set frequency(Frequency value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasFrequency() => $_has(9);
  @$pb.TagNumber(10)
  void clearFrequency() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get ownerId => $_getSZ(10);
  @$pb.TagNumber(11)
  set ownerId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOwnerId() => $_has(10);
  @$pb.TagNumber(11)
  void clearOwnerId() => $_clearField(11);

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
}

/// IndicatorValue is one measurement over one period (SRS-QMS-010).
class IndicatorValue extends $pb.GeneratedMessage {
  factory IndicatorValue({
    $core.String? valueId,
    $core.String? definitionId,
    $core.String? code,
    $core.int? revision,
    $0.Timestamp? periodFrom,
    $0.Timestamp? periodTo,
    $fixnum.Int64? numerator,
    $fixnum.Int64? denominator,
    $core.int? permille,
    $core.bool? unanswerable,
    $core.String? sourceNote,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (valueId != null) result.valueId = valueId;
    if (definitionId != null) result.definitionId = definitionId;
    if (code != null) result.code = code;
    if (revision != null) result.revision = revision;
    if (periodFrom != null) result.periodFrom = periodFrom;
    if (periodTo != null) result.periodTo = periodTo;
    if (numerator != null) result.numerator = numerator;
    if (denominator != null) result.denominator = denominator;
    if (permille != null) result.permille = permille;
    if (unanswerable != null) result.unanswerable = unanswerable;
    if (sourceNote != null) result.sourceNote = sourceNote;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  IndicatorValue._();

  factory IndicatorValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IndicatorValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IndicatorValue',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'valueId')
    ..aOS(2, _omitFieldNames ? '' : 'definitionId')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aI(4, _omitFieldNames ? '' : 'revision')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'periodFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'periodTo',
        subBuilder: $0.Timestamp.create)
    ..aInt64(7, _omitFieldNames ? '' : 'numerator')
    ..aInt64(8, _omitFieldNames ? '' : 'denominator')
    ..aI(9, _omitFieldNames ? '' : 'permille')
    ..aOB(10, _omitFieldNames ? '' : 'unanswerable')
    ..aOS(11, _omitFieldNames ? '' : 'sourceNote')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IndicatorValue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IndicatorValue copyWith(void Function(IndicatorValue) updates) =>
      super.copyWith((message) => updates(message as IndicatorValue))
          as IndicatorValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IndicatorValue create() => IndicatorValue._();
  @$core.override
  IndicatorValue createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IndicatorValue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IndicatorValue>(create);
  static IndicatorValue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get valueId => $_getSZ(0);
  @$pb.TagNumber(1)
  set valueId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValueId() => $_has(0);
  @$pb.TagNumber(1)
  void clearValueId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get definitionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set definitionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDefinitionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDefinitionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  /// The revision this value was computed under.
  @$pb.TagNumber(4)
  $core.int get revision => $_getIZ(3);
  @$pb.TagNumber(4)
  set revision($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevision() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get periodFrom => $_getN(4);
  @$pb.TagNumber(5)
  set periodFrom($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPeriodFrom() => $_has(4);
  @$pb.TagNumber(5)
  void clearPeriodFrom() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensurePeriodFrom() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get periodTo => $_getN(5);
  @$pb.TagNumber(6)
  set periodTo($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPeriodTo() => $_has(5);
  @$pb.TagNumber(6)
  void clearPeriodTo() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensurePeriodTo() => $_ensure(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get numerator => $_getI64(6);
  @$pb.TagNumber(7)
  set numerator($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNumerator() => $_has(6);
  @$pb.TagNumber(7)
  void clearNumerator() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get denominator => $_getI64(7);
  @$pb.TagNumber(8)
  set denominator($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDenominator() => $_has(7);
  @$pb.TagNumber(8)
  void clearDenominator() => $_clearField(8);

  /// Derived, never supplied: a value a submitter can type is a value that
  /// will not match its own numerator.
  @$pb.TagNumber(9)
  $core.int get permille => $_getIZ(8);
  @$pb.TagNumber(9)
  set permille($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPermille() => $_has(8);
  @$pb.TagNumber(9)
  void clearPermille() => $_clearField(9);

  /// A period with a zero denominator. Named rather than reported as zero,
  /// because "no eligible cases" and "we failed every case" are opposite
  /// facts.
  @$pb.TagNumber(10)
  $core.bool get unanswerable => $_getBF(9);
  @$pb.TagNumber(10)
  set unanswerable($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUnanswerable() => $_has(9);
  @$pb.TagNumber(10)
  void clearUnanswerable() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get sourceNote => $_getSZ(10);
  @$pb.TagNumber(11)
  set sourceNote($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSourceNote() => $_has(10);
  @$pb.TagNumber(11)
  void clearSourceNote() => $_clearField(11);

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
}

class DefineIndicatorRequest extends $pb.GeneratedMessage {
  factory DefineIndicatorRequest({
    $core.String? code,
    $core.String? name,
    $core.String? numerator,
    $core.String? denominator,
    $core.String? unit,
    $core.int? targetPermille,
    Direction? direction,
    Frequency? frequency,
    $core.String? ownerId,
    $0.Timestamp? effectiveFrom,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (numerator != null) result.numerator = numerator;
    if (denominator != null) result.denominator = denominator;
    if (unit != null) result.unit = unit;
    if (targetPermille != null) result.targetPermille = targetPermille;
    if (direction != null) result.direction = direction;
    if (frequency != null) result.frequency = frequency;
    if (ownerId != null) result.ownerId = ownerId;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    return result;
  }

  DefineIndicatorRequest._();

  factory DefineIndicatorRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineIndicatorRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineIndicatorRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'numerator')
    ..aOS(4, _omitFieldNames ? '' : 'denominator')
    ..aOS(5, _omitFieldNames ? '' : 'unit')
    ..aI(6, _omitFieldNames ? '' : 'targetPermille')
    ..aE<Direction>(7, _omitFieldNames ? '' : 'direction',
        enumValues: Direction.values)
    ..aE<Frequency>(8, _omitFieldNames ? '' : 'frequency',
        enumValues: Frequency.values)
    ..aOS(9, _omitFieldNames ? '' : 'ownerId')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineIndicatorRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineIndicatorRequest copyWith(
          void Function(DefineIndicatorRequest) updates) =>
      super.copyWith((message) => updates(message as DefineIndicatorRequest))
          as DefineIndicatorRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineIndicatorRequest create() => DefineIndicatorRequest._();
  @$core.override
  DefineIndicatorRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineIndicatorRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineIndicatorRequest>(create);
  static DefineIndicatorRequest? _defaultInstance;

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
  $core.String get numerator => $_getSZ(2);
  @$pb.TagNumber(3)
  set numerator($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNumerator() => $_has(2);
  @$pb.TagNumber(3)
  void clearNumerator() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get denominator => $_getSZ(3);
  @$pb.TagNumber(4)
  set denominator($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDenominator() => $_has(3);
  @$pb.TagNumber(4)
  void clearDenominator() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get unit => $_getSZ(4);
  @$pb.TagNumber(5)
  set unit($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnit() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnit() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get targetPermille => $_getIZ(5);
  @$pb.TagNumber(6)
  set targetPermille($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTargetPermille() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetPermille() => $_clearField(6);

  @$pb.TagNumber(7)
  Direction get direction => $_getN(6);
  @$pb.TagNumber(7)
  set direction(Direction value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDirection() => $_has(6);
  @$pb.TagNumber(7)
  void clearDirection() => $_clearField(7);

  @$pb.TagNumber(8)
  Frequency get frequency => $_getN(7);
  @$pb.TagNumber(8)
  set frequency(Frequency value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasFrequency() => $_has(7);
  @$pb.TagNumber(8)
  void clearFrequency() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get ownerId => $_getSZ(8);
  @$pb.TagNumber(9)
  set ownerId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOwnerId() => $_has(8);
  @$pb.TagNumber(9)
  void clearOwnerId() => $_clearField(9);

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

class DefineIndicatorResponse extends $pb.GeneratedMessage {
  factory DefineIndicatorResponse({
    IndicatorDefinition? definition,
  }) {
    final result = create();
    if (definition != null) result.definition = definition;
    return result;
  }

  DefineIndicatorResponse._();

  factory DefineIndicatorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineIndicatorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineIndicatorResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<IndicatorDefinition>(1, _omitFieldNames ? '' : 'definition',
        subBuilder: IndicatorDefinition.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineIndicatorResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineIndicatorResponse copyWith(
          void Function(DefineIndicatorResponse) updates) =>
      super.copyWith((message) => updates(message as DefineIndicatorResponse))
          as DefineIndicatorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineIndicatorResponse create() => DefineIndicatorResponse._();
  @$core.override
  DefineIndicatorResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineIndicatorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineIndicatorResponse>(create);
  static DefineIndicatorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  IndicatorDefinition get definition => $_getN(0);
  @$pb.TagNumber(1)
  set definition(IndicatorDefinition value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDefinition() => $_has(0);
  @$pb.TagNumber(1)
  void clearDefinition() => $_clearField(1);
  @$pb.TagNumber(1)
  IndicatorDefinition ensureDefinition() => $_ensure(0);
}

class RecordIndicatorValueRequest extends $pb.GeneratedMessage {
  factory RecordIndicatorValueRequest({
    $core.String? code,
    $0.Timestamp? periodFrom,
    $0.Timestamp? periodTo,
    $fixnum.Int64? numerator,
    $fixnum.Int64? denominator,
    $core.String? sourceNote,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (periodFrom != null) result.periodFrom = periodFrom;
    if (periodTo != null) result.periodTo = periodTo;
    if (numerator != null) result.numerator = numerator;
    if (denominator != null) result.denominator = denominator;
    if (sourceNote != null) result.sourceNote = sourceNote;
    return result;
  }

  RecordIndicatorValueRequest._();

  factory RecordIndicatorValueRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordIndicatorValueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordIndicatorValueRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'periodFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'periodTo',
        subBuilder: $0.Timestamp.create)
    ..aInt64(4, _omitFieldNames ? '' : 'numerator')
    ..aInt64(5, _omitFieldNames ? '' : 'denominator')
    ..aOS(6, _omitFieldNames ? '' : 'sourceNote')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordIndicatorValueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordIndicatorValueRequest copyWith(
          void Function(RecordIndicatorValueRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RecordIndicatorValueRequest))
          as RecordIndicatorValueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordIndicatorValueRequest create() =>
      RecordIndicatorValueRequest._();
  @$core.override
  RecordIndicatorValueRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordIndicatorValueRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordIndicatorValueRequest>(create);
  static RecordIndicatorValueRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

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

  @$pb.TagNumber(4)
  $fixnum.Int64 get numerator => $_getI64(3);
  @$pb.TagNumber(4)
  set numerator($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNumerator() => $_has(3);
  @$pb.TagNumber(4)
  void clearNumerator() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get denominator => $_getI64(4);
  @$pb.TagNumber(5)
  set denominator($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDenominator() => $_has(4);
  @$pb.TagNumber(5)
  void clearDenominator() => $_clearField(5);

  /// Where the counts came from, which is what makes the figure auditable.
  @$pb.TagNumber(6)
  $core.String get sourceNote => $_getSZ(5);
  @$pb.TagNumber(6)
  set sourceNote($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSourceNote() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceNote() => $_clearField(6);
}

class RecordIndicatorValueResponse extends $pb.GeneratedMessage {
  factory RecordIndicatorValueResponse({
    IndicatorValue? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  RecordIndicatorValueResponse._();

  factory RecordIndicatorValueResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordIndicatorValueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordIndicatorValueResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<IndicatorValue>(1, _omitFieldNames ? '' : 'value',
        subBuilder: IndicatorValue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordIndicatorValueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordIndicatorValueResponse copyWith(
          void Function(RecordIndicatorValueResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RecordIndicatorValueResponse))
          as RecordIndicatorValueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordIndicatorValueResponse create() =>
      RecordIndicatorValueResponse._();
  @$core.override
  RecordIndicatorValueResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordIndicatorValueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordIndicatorValueResponse>(create);
  static RecordIndicatorValueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  IndicatorValue get value => $_getN(0);
  @$pb.TagNumber(1)
  set value(IndicatorValue value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
  @$pb.TagNumber(1)
  IndicatorValue ensureValue() => $_ensure(0);
}

/// IndicatorLine is one dictionary entry with its latest measurement.
class IndicatorLine extends $pb.GeneratedMessage {
  factory IndicatorLine({
    IndicatorDefinition? definition,
    IndicatorValue? latest,
    $core.bool? recorded,
    $core.bool? metTarget,
    $core.bool? comparable,
  }) {
    final result = create();
    if (definition != null) result.definition = definition;
    if (latest != null) result.latest = latest;
    if (recorded != null) result.recorded = recorded;
    if (metTarget != null) result.metTarget = metTarget;
    if (comparable != null) result.comparable = comparable;
    return result;
  }

  IndicatorLine._();

  factory IndicatorLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IndicatorLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IndicatorLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<IndicatorDefinition>(1, _omitFieldNames ? '' : 'definition',
        subBuilder: IndicatorDefinition.create)
    ..aOM<IndicatorValue>(2, _omitFieldNames ? '' : 'latest',
        subBuilder: IndicatorValue.create)
    ..aOB(3, _omitFieldNames ? '' : 'recorded')
    ..aOB(4, _omitFieldNames ? '' : 'metTarget')
    ..aOB(5, _omitFieldNames ? '' : 'comparable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IndicatorLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IndicatorLine copyWith(void Function(IndicatorLine) updates) =>
      super.copyWith((message) => updates(message as IndicatorLine))
          as IndicatorLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IndicatorLine create() => IndicatorLine._();
  @$core.override
  IndicatorLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IndicatorLine getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IndicatorLine>(create);
  static IndicatorLine? _defaultInstance;

  @$pb.TagNumber(1)
  IndicatorDefinition get definition => $_getN(0);
  @$pb.TagNumber(1)
  set definition(IndicatorDefinition value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDefinition() => $_has(0);
  @$pb.TagNumber(1)
  void clearDefinition() => $_clearField(1);
  @$pb.TagNumber(1)
  IndicatorDefinition ensureDefinition() => $_ensure(0);

  @$pb.TagNumber(2)
  IndicatorValue get latest => $_getN(1);
  @$pb.TagNumber(2)
  set latest(IndicatorValue value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLatest() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatest() => $_clearField(2);
  @$pb.TagNumber(2)
  IndicatorValue ensureLatest() => $_ensure(1);

  /// An indicator defined and never measured is a gap, not a zero.
  @$pb.TagNumber(3)
  $core.bool get recorded => $_getBF(2);
  @$pb.TagNumber(3)
  set recorded($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecorded() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecorded() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get metTarget => $_getBF(3);
  @$pb.TagNumber(4)
  set metTarget($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMetTarget() => $_has(3);
  @$pb.TagNumber(4)
  void clearMetTarget() => $_clearField(4);

  /// Whether the question could be asked at all: an unanswerable period is not
  /// a failure.
  @$pb.TagNumber(5)
  $core.bool get comparable => $_getBF(4);
  @$pb.TagNumber(5)
  set comparable($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasComparable() => $_has(4);
  @$pb.TagNumber(5)
  void clearComparable() => $_clearField(5);
}

class GetDashboardRequest extends $pb.GeneratedMessage {
  factory GetDashboardRequest({
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  GetDashboardRequest._();

  factory GetDashboardRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDashboardRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDashboardRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardRequest copyWith(void Function(GetDashboardRequest) updates) =>
      super.copyWith((message) => updates(message as GetDashboardRequest))
          as GetDashboardRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDashboardRequest create() => GetDashboardRequest._();
  @$core.override
  GetDashboardRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDashboardRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDashboardRequest>(create);
  static GetDashboardRequest? _defaultInstance;

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
}

class GetDashboardResponse extends $pb.GeneratedMessage {
  factory GetDashboardResponse({
    $core.Iterable<IndicatorLine>? lines,
  }) {
    final result = create();
    if (lines != null) result.lines.addAll(lines);
    return result;
  }

  GetDashboardResponse._();

  factory GetDashboardResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDashboardResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDashboardResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<IndicatorLine>(1, _omitFieldNames ? '' : 'lines',
        subBuilder: IndicatorLine.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardResponse copyWith(void Function(GetDashboardResponse) updates) =>
      super.copyWith((message) => updates(message as GetDashboardResponse))
          as GetDashboardResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDashboardResponse create() => GetDashboardResponse._();
  @$core.override
  GetDashboardResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDashboardResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDashboardResponse>(create);
  static GetDashboardResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<IndicatorLine> get lines => $_getList(0);
}

class ListIndicatorValuesRequest extends $pb.GeneratedMessage {
  factory ListIndicatorValuesRequest({
    $core.String? code,
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  ListIndicatorValuesRequest._();

  factory ListIndicatorValuesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListIndicatorValuesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListIndicatorValuesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListIndicatorValuesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListIndicatorValuesRequest copyWith(
          void Function(ListIndicatorValuesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListIndicatorValuesRequest))
          as ListIndicatorValuesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListIndicatorValuesRequest create() => ListIndicatorValuesRequest._();
  @$core.override
  ListIndicatorValuesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListIndicatorValuesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListIndicatorValuesRequest>(create);
  static ListIndicatorValuesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

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

class ListIndicatorValuesResponse extends $pb.GeneratedMessage {
  factory ListIndicatorValuesResponse({
    $core.Iterable<IndicatorValue>? values,
  }) {
    final result = create();
    if (values != null) result.values.addAll(values);
    return result;
  }

  ListIndicatorValuesResponse._();

  factory ListIndicatorValuesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListIndicatorValuesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListIndicatorValuesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<IndicatorValue>(1, _omitFieldNames ? '' : 'values',
        subBuilder: IndicatorValue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListIndicatorValuesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListIndicatorValuesResponse copyWith(
          void Function(ListIndicatorValuesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListIndicatorValuesResponse))
          as ListIndicatorValuesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListIndicatorValuesResponse create() =>
      ListIndicatorValuesResponse._();
  @$core.override
  ListIndicatorValuesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListIndicatorValuesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListIndicatorValuesResponse>(create);
  static ListIndicatorValuesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<IndicatorValue> get values => $_getList(0);
}

/// Complaint is one grievance and its handling (SRS-QMS-011).
class Complaint extends $pb.GeneratedMessage {
  factory Complaint({
    $core.String? complaintId,
    $core.String? reference,
    ComplainantKind? kind,
    $core.String? complainantRef,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? category,
    $core.String? department,
    $core.String? facilityId,
    $core.String? channel,
    $core.String? detail,
    $0.Timestamp? acknowledgeBy,
    $0.Timestamp? acknowledgedAt,
    $core.String? acknowledgedBy,
    $0.Timestamp? resolveBy,
    ComplaintState? state,
    ComplaintOutcome? outcome,
    $core.String? resolution,
    $core.String? closureReason,
    $core.bool? escalated,
    $0.Timestamp? escalatedAt,
    $0.Timestamp? receivedAt,
    $core.String? receivedBy,
    $0.Timestamp? closedAt,
    $core.String? closedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (complaintId != null) result.complaintId = complaintId;
    if (reference != null) result.reference = reference;
    if (kind != null) result.kind = kind;
    if (complainantRef != null) result.complainantRef = complainantRef;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (category != null) result.category = category;
    if (department != null) result.department = department;
    if (facilityId != null) result.facilityId = facilityId;
    if (channel != null) result.channel = channel;
    if (detail != null) result.detail = detail;
    if (acknowledgeBy != null) result.acknowledgeBy = acknowledgeBy;
    if (acknowledgedAt != null) result.acknowledgedAt = acknowledgedAt;
    if (acknowledgedBy != null) result.acknowledgedBy = acknowledgedBy;
    if (resolveBy != null) result.resolveBy = resolveBy;
    if (state != null) result.state = state;
    if (outcome != null) result.outcome = outcome;
    if (resolution != null) result.resolution = resolution;
    if (closureReason != null) result.closureReason = closureReason;
    if (escalated != null) result.escalated = escalated;
    if (escalatedAt != null) result.escalatedAt = escalatedAt;
    if (receivedAt != null) result.receivedAt = receivedAt;
    if (receivedBy != null) result.receivedBy = receivedBy;
    if (closedAt != null) result.closedAt = closedAt;
    if (closedBy != null) result.closedBy = closedBy;
    if (version != null) result.version = version;
    return result;
  }

  Complaint._();

  factory Complaint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Complaint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Complaint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'complaintId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aE<ComplainantKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: ComplainantKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'complainantRef')
    ..aOS(5, _omitFieldNames ? '' : 'patientId')
    ..aOS(6, _omitFieldNames ? '' : 'encounterId')
    ..aOS(7, _omitFieldNames ? '' : 'category')
    ..aOS(8, _omitFieldNames ? '' : 'department')
    ..aOS(9, _omitFieldNames ? '' : 'facilityId')
    ..aOS(10, _omitFieldNames ? '' : 'channel')
    ..aOS(11, _omitFieldNames ? '' : 'detail')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'acknowledgeBy',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'acknowledgedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(14, _omitFieldNames ? '' : 'acknowledgedBy')
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'resolveBy',
        subBuilder: $0.Timestamp.create)
    ..aE<ComplaintState>(16, _omitFieldNames ? '' : 'state',
        enumValues: ComplaintState.values)
    ..aE<ComplaintOutcome>(17, _omitFieldNames ? '' : 'outcome',
        enumValues: ComplaintOutcome.values)
    ..aOS(18, _omitFieldNames ? '' : 'resolution')
    ..aOS(19, _omitFieldNames ? '' : 'closureReason')
    ..aOB(20, _omitFieldNames ? '' : 'escalated')
    ..aOM<$0.Timestamp>(21, _omitFieldNames ? '' : 'escalatedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(22, _omitFieldNames ? '' : 'receivedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(23, _omitFieldNames ? '' : 'receivedBy')
    ..aOM<$0.Timestamp>(24, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(25, _omitFieldNames ? '' : 'closedBy')
    ..aInt64(26, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Complaint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Complaint copyWith(void Function(Complaint) updates) =>
      super.copyWith((message) => updates(message as Complaint)) as Complaint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Complaint create() => Complaint._();
  @$core.override
  Complaint createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Complaint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Complaint>(create);
  static Complaint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get complaintId => $_getSZ(0);
  @$pb.TagNumber(1)
  set complaintId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasComplaintId() => $_has(0);
  @$pb.TagNumber(1)
  void clearComplaintId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reference => $_getSZ(1);
  @$pb.TagNumber(2)
  set reference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearReference() => $_clearField(2);

  @$pb.TagNumber(3)
  ComplainantKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(ComplainantKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get complainantRef => $_getSZ(3);
  @$pb.TagNumber(4)
  set complainantRef($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasComplainantRef() => $_has(3);
  @$pb.TagNumber(4)
  void clearComplainantRef() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get patientId => $_getSZ(4);
  @$pb.TagNumber(5)
  set patientId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPatientId() => $_has(4);
  @$pb.TagNumber(5)
  void clearPatientId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get encounterId => $_getSZ(5);
  @$pb.TagNumber(6)
  set encounterId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEncounterId() => $_has(5);
  @$pb.TagNumber(6)
  void clearEncounterId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get category => $_getSZ(6);
  @$pb.TagNumber(7)
  set category($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCategory() => $_has(6);
  @$pb.TagNumber(7)
  void clearCategory() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get department => $_getSZ(7);
  @$pb.TagNumber(8)
  set department($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDepartment() => $_has(7);
  @$pb.TagNumber(8)
  void clearDepartment() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get facilityId => $_getSZ(8);
  @$pb.TagNumber(9)
  set facilityId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFacilityId() => $_has(8);
  @$pb.TagNumber(9)
  void clearFacilityId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get channel => $_getSZ(9);
  @$pb.TagNumber(10)
  set channel($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasChannel() => $_has(9);
  @$pb.TagNumber(10)
  void clearChannel() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get detail => $_getSZ(10);
  @$pb.TagNumber(11)
  set detail($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDetail() => $_has(10);
  @$pb.TagNumber(11)
  void clearDetail() => $_clearField(11);

  /// Two clocks, not one. A hospital that acknowledges in a day and resolves
  /// in a month is behaving correctly; merging them hides whichever is being
  /// missed. Both are set from the deployment's SLA configuration.
  @$pb.TagNumber(12)
  $0.Timestamp get acknowledgeBy => $_getN(11);
  @$pb.TagNumber(12)
  set acknowledgeBy($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasAcknowledgeBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearAcknowledgeBy() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureAcknowledgeBy() => $_ensure(11);

  @$pb.TagNumber(13)
  $0.Timestamp get acknowledgedAt => $_getN(12);
  @$pb.TagNumber(13)
  set acknowledgedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasAcknowledgedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearAcknowledgedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureAcknowledgedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get acknowledgedBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set acknowledgedBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasAcknowledgedBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearAcknowledgedBy() => $_clearField(14);

  @$pb.TagNumber(15)
  $0.Timestamp get resolveBy => $_getN(14);
  @$pb.TagNumber(15)
  set resolveBy($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasResolveBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearResolveBy() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureResolveBy() => $_ensure(14);

  @$pb.TagNumber(16)
  ComplaintState get state => $_getN(15);
  @$pb.TagNumber(16)
  set state(ComplaintState value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasState() => $_has(15);
  @$pb.TagNumber(16)
  void clearState() => $_clearField(16);

  @$pb.TagNumber(17)
  ComplaintOutcome get outcome => $_getN(16);
  @$pb.TagNumber(17)
  set outcome(ComplaintOutcome value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasOutcome() => $_has(16);
  @$pb.TagNumber(17)
  void clearOutcome() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get resolution => $_getSZ(17);
  @$pb.TagNumber(18)
  set resolution($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasResolution() => $_has(17);
  @$pb.TagNumber(18)
  void clearResolution() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get closureReason => $_getSZ(18);
  @$pb.TagNumber(19)
  set closureReason($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasClosureReason() => $_has(18);
  @$pb.TagNumber(19)
  void clearClosureReason() => $_clearField(19);

  /// Kept on the record as well as derived: the acceptance is that the
  /// escalation is retained, and a derived-only view loses that it ever
  /// happened once the complaint is resolved.
  @$pb.TagNumber(20)
  $core.bool get escalated => $_getBF(19);
  @$pb.TagNumber(20)
  set escalated($core.bool value) => $_setBool(19, value);
  @$pb.TagNumber(20)
  $core.bool hasEscalated() => $_has(19);
  @$pb.TagNumber(20)
  void clearEscalated() => $_clearField(20);

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
  $0.Timestamp get receivedAt => $_getN(21);
  @$pb.TagNumber(22)
  set receivedAt($0.Timestamp value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasReceivedAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearReceivedAt() => $_clearField(22);
  @$pb.TagNumber(22)
  $0.Timestamp ensureReceivedAt() => $_ensure(21);

  @$pb.TagNumber(23)
  $core.String get receivedBy => $_getSZ(22);
  @$pb.TagNumber(23)
  set receivedBy($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasReceivedBy() => $_has(22);
  @$pb.TagNumber(23)
  void clearReceivedBy() => $_clearField(23);

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

class ReceiveComplaintRequest extends $pb.GeneratedMessage {
  factory ReceiveComplaintRequest({
    $core.String? reference,
    ComplainantKind? kind,
    $core.String? complainantRef,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? category,
    $core.String? department,
    $core.String? facilityId,
    $core.String? channel,
    $core.String? detail,
    $0.Timestamp? receivedAt,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    if (kind != null) result.kind = kind;
    if (complainantRef != null) result.complainantRef = complainantRef;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (category != null) result.category = category;
    if (department != null) result.department = department;
    if (facilityId != null) result.facilityId = facilityId;
    if (channel != null) result.channel = channel;
    if (detail != null) result.detail = detail;
    if (receivedAt != null) result.receivedAt = receivedAt;
    return result;
  }

  ReceiveComplaintRequest._();

  factory ReceiveComplaintRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReceiveComplaintRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReceiveComplaintRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..aE<ComplainantKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: ComplainantKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'complainantRef')
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aOS(5, _omitFieldNames ? '' : 'encounterId')
    ..aOS(6, _omitFieldNames ? '' : 'category')
    ..aOS(7, _omitFieldNames ? '' : 'department')
    ..aOS(8, _omitFieldNames ? '' : 'facilityId')
    ..aOS(9, _omitFieldNames ? '' : 'channel')
    ..aOS(10, _omitFieldNames ? '' : 'detail')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'receivedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveComplaintRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveComplaintRequest copyWith(
          void Function(ReceiveComplaintRequest) updates) =>
      super.copyWith((message) => updates(message as ReceiveComplaintRequest))
          as ReceiveComplaintRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiveComplaintRequest create() => ReceiveComplaintRequest._();
  @$core.override
  ReceiveComplaintRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReceiveComplaintRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReceiveComplaintRequest>(create);
  static ReceiveComplaintRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reference => $_getSZ(0);
  @$pb.TagNumber(1)
  set reference($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReference() => $_has(0);
  @$pb.TagNumber(1)
  void clearReference() => $_clearField(1);

  @$pb.TagNumber(2)
  ComplainantKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(ComplainantKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get complainantRef => $_getSZ(2);
  @$pb.TagNumber(3)
  set complainantRef($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasComplainantRef() => $_has(2);
  @$pb.TagNumber(3)
  void clearComplainantRef() => $_clearField(3);

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
  $core.String get category => $_getSZ(5);
  @$pb.TagNumber(6)
  set category($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCategory() => $_has(5);
  @$pb.TagNumber(6)
  void clearCategory() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get department => $_getSZ(6);
  @$pb.TagNumber(7)
  set department($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDepartment() => $_has(6);
  @$pb.TagNumber(7)
  void clearDepartment() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get facilityId => $_getSZ(7);
  @$pb.TagNumber(8)
  set facilityId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFacilityId() => $_has(7);
  @$pb.TagNumber(8)
  void clearFacilityId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get channel => $_getSZ(8);
  @$pb.TagNumber(9)
  set channel($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasChannel() => $_has(8);
  @$pb.TagNumber(9)
  void clearChannel() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get detail => $_getSZ(9);
  @$pb.TagNumber(10)
  set detail($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDetail() => $_has(9);
  @$pb.TagNumber(10)
  void clearDetail() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get receivedAt => $_getN(10);
  @$pb.TagNumber(11)
  set receivedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasReceivedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearReceivedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureReceivedAt() => $_ensure(10);
}

class ReceiveComplaintResponse extends $pb.GeneratedMessage {
  factory ReceiveComplaintResponse({
    Complaint? complaint,
  }) {
    final result = create();
    if (complaint != null) result.complaint = complaint;
    return result;
  }

  ReceiveComplaintResponse._();

  factory ReceiveComplaintResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReceiveComplaintResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReceiveComplaintResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Complaint>(1, _omitFieldNames ? '' : 'complaint',
        subBuilder: Complaint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveComplaintResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveComplaintResponse copyWith(
          void Function(ReceiveComplaintResponse) updates) =>
      super.copyWith((message) => updates(message as ReceiveComplaintResponse))
          as ReceiveComplaintResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiveComplaintResponse create() => ReceiveComplaintResponse._();
  @$core.override
  ReceiveComplaintResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReceiveComplaintResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReceiveComplaintResponse>(create);
  static ReceiveComplaintResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Complaint get complaint => $_getN(0);
  @$pb.TagNumber(1)
  set complaint(Complaint value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasComplaint() => $_has(0);
  @$pb.TagNumber(1)
  void clearComplaint() => $_clearField(1);
  @$pb.TagNumber(1)
  Complaint ensureComplaint() => $_ensure(0);
}

class AcknowledgeComplaintRequest extends $pb.GeneratedMessage {
  factory AcknowledgeComplaintRequest({
    $core.String? complaintId,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (complaintId != null) result.complaintId = complaintId;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  AcknowledgeComplaintRequest._();

  factory AcknowledgeComplaintRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgeComplaintRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgeComplaintRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'complaintId')
    ..aInt64(2, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeComplaintRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeComplaintRequest copyWith(
          void Function(AcknowledgeComplaintRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AcknowledgeComplaintRequest))
          as AcknowledgeComplaintRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeComplaintRequest create() =>
      AcknowledgeComplaintRequest._();
  @$core.override
  AcknowledgeComplaintRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeComplaintRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgeComplaintRequest>(create);
  static AcknowledgeComplaintRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get complaintId => $_getSZ(0);
  @$pb.TagNumber(1)
  set complaintId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasComplaintId() => $_has(0);
  @$pb.TagNumber(1)
  void clearComplaintId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expectedVersion => $_getI64(1);
  @$pb.TagNumber(2)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedVersion() => $_clearField(2);
}

class AcknowledgeComplaintResponse extends $pb.GeneratedMessage {
  factory AcknowledgeComplaintResponse({
    Complaint? complaint,
  }) {
    final result = create();
    if (complaint != null) result.complaint = complaint;
    return result;
  }

  AcknowledgeComplaintResponse._();

  factory AcknowledgeComplaintResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgeComplaintResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgeComplaintResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Complaint>(1, _omitFieldNames ? '' : 'complaint',
        subBuilder: Complaint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeComplaintResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeComplaintResponse copyWith(
          void Function(AcknowledgeComplaintResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AcknowledgeComplaintResponse))
          as AcknowledgeComplaintResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeComplaintResponse create() =>
      AcknowledgeComplaintResponse._();
  @$core.override
  AcknowledgeComplaintResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeComplaintResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgeComplaintResponse>(create);
  static AcknowledgeComplaintResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Complaint get complaint => $_getN(0);
  @$pb.TagNumber(1)
  set complaint(Complaint value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasComplaint() => $_has(0);
  @$pb.TagNumber(1)
  void clearComplaint() => $_clearField(1);
  @$pb.TagNumber(1)
  Complaint ensureComplaint() => $_ensure(0);
}

class ResolveComplaintRequest extends $pb.GeneratedMessage {
  factory ResolveComplaintRequest({
    $core.String? complaintId,
    ComplaintOutcome? outcome,
    $core.String? resolution,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (complaintId != null) result.complaintId = complaintId;
    if (outcome != null) result.outcome = outcome;
    if (resolution != null) result.resolution = resolution;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  ResolveComplaintRequest._();

  factory ResolveComplaintRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveComplaintRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveComplaintRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'complaintId')
    ..aE<ComplaintOutcome>(2, _omitFieldNames ? '' : 'outcome',
        enumValues: ComplaintOutcome.values)
    ..aOS(3, _omitFieldNames ? '' : 'resolution')
    ..aInt64(4, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveComplaintRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveComplaintRequest copyWith(
          void Function(ResolveComplaintRequest) updates) =>
      super.copyWith((message) => updates(message as ResolveComplaintRequest))
          as ResolveComplaintRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveComplaintRequest create() => ResolveComplaintRequest._();
  @$core.override
  ResolveComplaintRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveComplaintRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveComplaintRequest>(create);
  static ResolveComplaintRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get complaintId => $_getSZ(0);
  @$pb.TagNumber(1)
  set complaintId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasComplaintId() => $_has(0);
  @$pb.TagNumber(1)
  void clearComplaintId() => $_clearField(1);

  @$pb.TagNumber(2)
  ComplaintOutcome get outcome => $_getN(1);
  @$pb.TagNumber(2)
  set outcome(ComplaintOutcome value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOutcome() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutcome() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get resolution => $_getSZ(2);
  @$pb.TagNumber(3)
  set resolution($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResolution() => $_has(2);
  @$pb.TagNumber(3)
  void clearResolution() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expectedVersion => $_getI64(3);
  @$pb.TagNumber(4)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedVersion() => $_clearField(4);
}

class ResolveComplaintResponse extends $pb.GeneratedMessage {
  factory ResolveComplaintResponse({
    Complaint? complaint,
  }) {
    final result = create();
    if (complaint != null) result.complaint = complaint;
    return result;
  }

  ResolveComplaintResponse._();

  factory ResolveComplaintResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveComplaintResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveComplaintResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Complaint>(1, _omitFieldNames ? '' : 'complaint',
        subBuilder: Complaint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveComplaintResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveComplaintResponse copyWith(
          void Function(ResolveComplaintResponse) updates) =>
      super.copyWith((message) => updates(message as ResolveComplaintResponse))
          as ResolveComplaintResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveComplaintResponse create() => ResolveComplaintResponse._();
  @$core.override
  ResolveComplaintResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveComplaintResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveComplaintResponse>(create);
  static ResolveComplaintResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Complaint get complaint => $_getN(0);
  @$pb.TagNumber(1)
  set complaint(Complaint value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasComplaint() => $_has(0);
  @$pb.TagNumber(1)
  void clearComplaint() => $_clearField(1);
  @$pb.TagNumber(1)
  Complaint ensureComplaint() => $_ensure(0);
}

class CloseComplaintRequest extends $pb.GeneratedMessage {
  factory CloseComplaintRequest({
    $core.String? complaintId,
    $core.String? reason,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (complaintId != null) result.complaintId = complaintId;
    if (reason != null) result.reason = reason;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  CloseComplaintRequest._();

  factory CloseComplaintRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseComplaintRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseComplaintRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'complaintId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aInt64(3, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseComplaintRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseComplaintRequest copyWith(
          void Function(CloseComplaintRequest) updates) =>
      super.copyWith((message) => updates(message as CloseComplaintRequest))
          as CloseComplaintRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseComplaintRequest create() => CloseComplaintRequest._();
  @$core.override
  CloseComplaintRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseComplaintRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseComplaintRequest>(create);
  static CloseComplaintRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get complaintId => $_getSZ(0);
  @$pb.TagNumber(1)
  set complaintId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasComplaintId() => $_has(0);
  @$pb.TagNumber(1)
  void clearComplaintId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedVersion => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedVersion() => $_clearField(3);
}

class CloseComplaintResponse extends $pb.GeneratedMessage {
  factory CloseComplaintResponse({
    Complaint? complaint,
  }) {
    final result = create();
    if (complaint != null) result.complaint = complaint;
    return result;
  }

  CloseComplaintResponse._();

  factory CloseComplaintResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseComplaintResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseComplaintResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Complaint>(1, _omitFieldNames ? '' : 'complaint',
        subBuilder: Complaint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseComplaintResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseComplaintResponse copyWith(
          void Function(CloseComplaintResponse) updates) =>
      super.copyWith((message) => updates(message as CloseComplaintResponse))
          as CloseComplaintResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseComplaintResponse create() => CloseComplaintResponse._();
  @$core.override
  CloseComplaintResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseComplaintResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseComplaintResponse>(create);
  static CloseComplaintResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Complaint get complaint => $_getN(0);
  @$pb.TagNumber(1)
  set complaint(Complaint value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasComplaint() => $_has(0);
  @$pb.TagNumber(1)
  void clearComplaint() => $_clearField(1);
  @$pb.TagNumber(1)
  Complaint ensureComplaint() => $_ensure(0);
}

class GetComplaintRequest extends $pb.GeneratedMessage {
  factory GetComplaintRequest({
    $core.String? complaintId,
  }) {
    final result = create();
    if (complaintId != null) result.complaintId = complaintId;
    return result;
  }

  GetComplaintRequest._();

  factory GetComplaintRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetComplaintRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetComplaintRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'complaintId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetComplaintRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetComplaintRequest copyWith(void Function(GetComplaintRequest) updates) =>
      super.copyWith((message) => updates(message as GetComplaintRequest))
          as GetComplaintRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetComplaintRequest create() => GetComplaintRequest._();
  @$core.override
  GetComplaintRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetComplaintRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetComplaintRequest>(create);
  static GetComplaintRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get complaintId => $_getSZ(0);
  @$pb.TagNumber(1)
  set complaintId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasComplaintId() => $_has(0);
  @$pb.TagNumber(1)
  void clearComplaintId() => $_clearField(1);
}

class GetComplaintResponse extends $pb.GeneratedMessage {
  factory GetComplaintResponse({
    Complaint? complaint,
  }) {
    final result = create();
    if (complaint != null) result.complaint = complaint;
    return result;
  }

  GetComplaintResponse._();

  factory GetComplaintResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetComplaintResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetComplaintResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Complaint>(1, _omitFieldNames ? '' : 'complaint',
        subBuilder: Complaint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetComplaintResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetComplaintResponse copyWith(void Function(GetComplaintResponse) updates) =>
      super.copyWith((message) => updates(message as GetComplaintResponse))
          as GetComplaintResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetComplaintResponse create() => GetComplaintResponse._();
  @$core.override
  GetComplaintResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetComplaintResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetComplaintResponse>(create);
  static GetComplaintResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Complaint get complaint => $_getN(0);
  @$pb.TagNumber(1)
  set complaint(Complaint value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasComplaint() => $_has(0);
  @$pb.TagNumber(1)
  void clearComplaint() => $_clearField(1);
  @$pb.TagNumber(1)
  Complaint ensureComplaint() => $_ensure(0);
}

class ListComplaintsRequest extends $pb.GeneratedMessage {
  factory ListComplaintsRequest({
    $core.String? category,
    $core.bool? openOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (category != null) result.category = category;
    if (openOnly != null) result.openOnly = openOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListComplaintsRequest._();

  factory ListComplaintsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListComplaintsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListComplaintsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'category')
    ..aOB(2, _omitFieldNames ? '' : 'openOnly')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListComplaintsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListComplaintsRequest copyWith(
          void Function(ListComplaintsRequest) updates) =>
      super.copyWith((message) => updates(message as ListComplaintsRequest))
          as ListComplaintsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListComplaintsRequest create() => ListComplaintsRequest._();
  @$core.override
  ListComplaintsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListComplaintsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListComplaintsRequest>(create);
  static ListComplaintsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get category => $_getSZ(0);
  @$pb.TagNumber(1)
  set category($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => $_clearField(1);

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

class ListComplaintsResponse extends $pb.GeneratedMessage {
  factory ListComplaintsResponse({
    $core.Iterable<Complaint>? complaints,
  }) {
    final result = create();
    if (complaints != null) result.complaints.addAll(complaints);
    return result;
  }

  ListComplaintsResponse._();

  factory ListComplaintsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListComplaintsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListComplaintsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<Complaint>(1, _omitFieldNames ? '' : 'complaints',
        subBuilder: Complaint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListComplaintsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListComplaintsResponse copyWith(
          void Function(ListComplaintsResponse) updates) =>
      super.copyWith((message) => updates(message as ListComplaintsResponse))
          as ListComplaintsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListComplaintsResponse create() => ListComplaintsResponse._();
  @$core.override
  ListComplaintsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListComplaintsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListComplaintsResponse>(create);
  static ListComplaintsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Complaint> get complaints => $_getList(0);
}

/// ComplaintBreach is one grievance past a clock (SRS-QMS-011).
class ComplaintBreach extends $pb.GeneratedMessage {
  factory ComplaintBreach({
    Complaint? complaint,
    $core.bool? acknowledgementBreached,
    $core.bool? resolutionBreached,
  }) {
    final result = create();
    if (complaint != null) result.complaint = complaint;
    if (acknowledgementBreached != null)
      result.acknowledgementBreached = acknowledgementBreached;
    if (resolutionBreached != null)
      result.resolutionBreached = resolutionBreached;
    return result;
  }

  ComplaintBreach._();

  factory ComplaintBreach.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ComplaintBreach.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ComplaintBreach',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<Complaint>(1, _omitFieldNames ? '' : 'complaint',
        subBuilder: Complaint.create)
    ..aOB(2, _omitFieldNames ? '' : 'acknowledgementBreached')
    ..aOB(3, _omitFieldNames ? '' : 'resolutionBreached')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComplaintBreach clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComplaintBreach copyWith(void Function(ComplaintBreach) updates) =>
      super.copyWith((message) => updates(message as ComplaintBreach))
          as ComplaintBreach;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComplaintBreach create() => ComplaintBreach._();
  @$core.override
  ComplaintBreach createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ComplaintBreach getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ComplaintBreach>(create);
  static ComplaintBreach? _defaultInstance;

  @$pb.TagNumber(1)
  Complaint get complaint => $_getN(0);
  @$pb.TagNumber(1)
  set complaint(Complaint value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasComplaint() => $_has(0);
  @$pb.TagNumber(1)
  void clearComplaint() => $_clearField(1);
  @$pb.TagNumber(1)
  Complaint ensureComplaint() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get acknowledgementBreached => $_getBF(1);
  @$pb.TagNumber(2)
  set acknowledgementBreached($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAcknowledgementBreached() => $_has(1);
  @$pb.TagNumber(2)
  void clearAcknowledgementBreached() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get resolutionBreached => $_getBF(2);
  @$pb.TagNumber(3)
  set resolutionBreached($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResolutionBreached() => $_has(2);
  @$pb.TagNumber(3)
  void clearResolutionBreached() => $_clearField(3);
}

class ListComplaintBreachesRequest extends $pb.GeneratedMessage {
  factory ListComplaintBreachesRequest() => create();

  ListComplaintBreachesRequest._();

  factory ListComplaintBreachesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListComplaintBreachesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListComplaintBreachesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListComplaintBreachesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListComplaintBreachesRequest copyWith(
          void Function(ListComplaintBreachesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListComplaintBreachesRequest))
          as ListComplaintBreachesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListComplaintBreachesRequest create() =>
      ListComplaintBreachesRequest._();
  @$core.override
  ListComplaintBreachesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListComplaintBreachesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListComplaintBreachesRequest>(create);
  static ListComplaintBreachesRequest? _defaultInstance;
}

class ListComplaintBreachesResponse extends $pb.GeneratedMessage {
  factory ListComplaintBreachesResponse({
    $core.Iterable<ComplaintBreach>? breaches,
  }) {
    final result = create();
    if (breaches != null) result.breaches.addAll(breaches);
    return result;
  }

  ListComplaintBreachesResponse._();

  factory ListComplaintBreachesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListComplaintBreachesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListComplaintBreachesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<ComplaintBreach>(1, _omitFieldNames ? '' : 'breaches',
        subBuilder: ComplaintBreach.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListComplaintBreachesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListComplaintBreachesResponse copyWith(
          void Function(ListComplaintBreachesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListComplaintBreachesResponse))
          as ListComplaintBreachesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListComplaintBreachesResponse create() =>
      ListComplaintBreachesResponse._();
  @$core.override
  ListComplaintBreachesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListComplaintBreachesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListComplaintBreachesResponse>(create);
  static ListComplaintBreachesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ComplaintBreach> get breaches => $_getList(0);
}

class EscalateComplaintBreachesRequest extends $pb.GeneratedMessage {
  factory EscalateComplaintBreachesRequest() => create();

  EscalateComplaintBreachesRequest._();

  factory EscalateComplaintBreachesRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EscalateComplaintBreachesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EscalateComplaintBreachesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateComplaintBreachesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateComplaintBreachesRequest copyWith(
          void Function(EscalateComplaintBreachesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as EscalateComplaintBreachesRequest))
          as EscalateComplaintBreachesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EscalateComplaintBreachesRequest create() =>
      EscalateComplaintBreachesRequest._();
  @$core.override
  EscalateComplaintBreachesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EscalateComplaintBreachesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EscalateComplaintBreachesRequest>(
          create);
  static EscalateComplaintBreachesRequest? _defaultInstance;
}

class EscalateComplaintBreachesResponse extends $pb.GeneratedMessage {
  factory EscalateComplaintBreachesResponse({
    $core.int? raised,
  }) {
    final result = create();
    if (raised != null) result.raised = raised;
    return result;
  }

  EscalateComplaintBreachesResponse._();

  factory EscalateComplaintBreachesResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EscalateComplaintBreachesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EscalateComplaintBreachesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'raised')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateComplaintBreachesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateComplaintBreachesResponse copyWith(
          void Function(EscalateComplaintBreachesResponse) updates) =>
      super.copyWith((message) =>
              updates(message as EscalateComplaintBreachesResponse))
          as EscalateComplaintBreachesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EscalateComplaintBreachesResponse create() =>
      EscalateComplaintBreachesResponse._();
  @$core.override
  EscalateComplaintBreachesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EscalateComplaintBreachesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EscalateComplaintBreachesResponse>(
          create);
  static EscalateComplaintBreachesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get raised => $_getIZ(0);
  @$pb.TagNumber(1)
  set raised($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRaised() => $_has(0);
  @$pb.TagNumber(1)
  void clearRaised() => $_clearField(1);
}

/// MortalityReview is one peer review of a death (SRS-QMS-012).
///
/// Always restricted, behind its own permission, and every read audited. Peer
/// review is a discussion between clinicians about whether a colleague's care
/// was adequate, and it only happens honestly if it is not readable by
/// everybody with a clinical login.
class MortalityReview extends $pb.GeneratedMessage {
  factory MortalityReview({
    $core.String? reviewId,
    $core.String? patientId,
    $core.String? encounterId,
    $0.Timestamp? diedAt,
    $core.String? committeeId,
    $core.String? meetingId,
    DeathClassification? classification,
    $core.String? findings,
    $core.String? learningPoints,
    $core.Iterable<$core.String>? actionIds,
    ReviewState? state,
    $0.Timestamp? openedAt,
    $core.String? openedBy,
    $0.Timestamp? completedAt,
    $core.String? completedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (reviewId != null) result.reviewId = reviewId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (diedAt != null) result.diedAt = diedAt;
    if (committeeId != null) result.committeeId = committeeId;
    if (meetingId != null) result.meetingId = meetingId;
    if (classification != null) result.classification = classification;
    if (findings != null) result.findings = findings;
    if (learningPoints != null) result.learningPoints = learningPoints;
    if (actionIds != null) result.actionIds.addAll(actionIds);
    if (state != null) result.state = state;
    if (openedAt != null) result.openedAt = openedAt;
    if (openedBy != null) result.openedBy = openedBy;
    if (completedAt != null) result.completedAt = completedAt;
    if (completedBy != null) result.completedBy = completedBy;
    if (version != null) result.version = version;
    return result;
  }

  MortalityReview._();

  factory MortalityReview.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MortalityReview.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MortalityReview',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'diedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'committeeId')
    ..aOS(6, _omitFieldNames ? '' : 'meetingId')
    ..aE<DeathClassification>(7, _omitFieldNames ? '' : 'classification',
        enumValues: DeathClassification.values)
    ..aOS(8, _omitFieldNames ? '' : 'findings')
    ..aOS(9, _omitFieldNames ? '' : 'learningPoints')
    ..pPS(10, _omitFieldNames ? '' : 'actionIds')
    ..aE<ReviewState>(11, _omitFieldNames ? '' : 'state',
        enumValues: ReviewState.values)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'openedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'openedBy')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'completedBy')
    ..aInt64(16, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MortalityReview clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MortalityReview copyWith(void Function(MortalityReview) updates) =>
      super.copyWith((message) => updates(message as MortalityReview))
          as MortalityReview;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MortalityReview create() => MortalityReview._();
  @$core.override
  MortalityReview createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MortalityReview getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MortalityReview>(create);
  static MortalityReview? _defaultInstance;

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
  $0.Timestamp get diedAt => $_getN(3);
  @$pb.TagNumber(4)
  set diedAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDiedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureDiedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get committeeId => $_getSZ(4);
  @$pb.TagNumber(5)
  set committeeId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCommitteeId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCommitteeId() => $_clearField(5);

  /// Required at completion: a peer review signed by one person is not a peer
  /// review.
  @$pb.TagNumber(6)
  $core.String get meetingId => $_getSZ(5);
  @$pb.TagNumber(6)
  set meetingId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMeetingId() => $_has(5);
  @$pb.TagNumber(6)
  void clearMeetingId() => $_clearField(6);

  @$pb.TagNumber(7)
  DeathClassification get classification => $_getN(6);
  @$pb.TagNumber(7)
  set classification(DeathClassification value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasClassification() => $_has(6);
  @$pb.TagNumber(7)
  void clearClassification() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get findings => $_getSZ(7);
  @$pb.TagNumber(8)
  set findings($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFindings() => $_has(7);
  @$pb.TagNumber(8)
  void clearFindings() => $_clearField(8);

  /// What the hospital takes from it, apart from the findings: the findings
  /// are about this death and the learning is what changes for the next
  /// patient.
  @$pb.TagNumber(9)
  $core.String get learningPoints => $_getSZ(8);
  @$pb.TagNumber(9)
  set learningPoints($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLearningPoints() => $_has(8);
  @$pb.TagNumber(9)
  void clearLearningPoints() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get actionIds => $_getList(9);

  @$pb.TagNumber(11)
  ReviewState get state => $_getN(10);
  @$pb.TagNumber(11)
  set state(ReviewState value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasState() => $_has(10);
  @$pb.TagNumber(11)
  void clearState() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get openedAt => $_getN(11);
  @$pb.TagNumber(12)
  set openedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasOpenedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearOpenedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureOpenedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get openedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set openedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasOpenedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearOpenedBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get completedAt => $_getN(13);
  @$pb.TagNumber(14)
  set completedAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasCompletedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearCompletedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureCompletedAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get completedBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set completedBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasCompletedBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearCompletedBy() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get version => $_getI64(15);
  @$pb.TagNumber(16)
  set version($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasVersion() => $_has(15);
  @$pb.TagNumber(16)
  void clearVersion() => $_clearField(16);
}

class StartMortalityReviewRequest extends $pb.GeneratedMessage {
  factory StartMortalityReviewRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? committeeId,
    $0.Timestamp? diedAt,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (committeeId != null) result.committeeId = committeeId;
    if (diedAt != null) result.diedAt = diedAt;
    return result;
  }

  StartMortalityReviewRequest._();

  factory StartMortalityReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartMortalityReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartMortalityReviewRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'committeeId')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'diedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartMortalityReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartMortalityReviewRequest copyWith(
          void Function(StartMortalityReviewRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StartMortalityReviewRequest))
          as StartMortalityReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartMortalityReviewRequest create() =>
      StartMortalityReviewRequest._();
  @$core.override
  StartMortalityReviewRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartMortalityReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartMortalityReviewRequest>(create);
  static StartMortalityReviewRequest? _defaultInstance;

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
  $core.String get committeeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set committeeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCommitteeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommitteeId() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get diedAt => $_getN(3);
  @$pb.TagNumber(4)
  set diedAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDiedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureDiedAt() => $_ensure(3);
}

class StartMortalityReviewResponse extends $pb.GeneratedMessage {
  factory StartMortalityReviewResponse({
    MortalityReview? review,
  }) {
    final result = create();
    if (review != null) result.review = review;
    return result;
  }

  StartMortalityReviewResponse._();

  factory StartMortalityReviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartMortalityReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartMortalityReviewResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<MortalityReview>(1, _omitFieldNames ? '' : 'review',
        subBuilder: MortalityReview.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartMortalityReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartMortalityReviewResponse copyWith(
          void Function(StartMortalityReviewResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StartMortalityReviewResponse))
          as StartMortalityReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartMortalityReviewResponse create() =>
      StartMortalityReviewResponse._();
  @$core.override
  StartMortalityReviewResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartMortalityReviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartMortalityReviewResponse>(create);
  static StartMortalityReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MortalityReview get review => $_getN(0);
  @$pb.TagNumber(1)
  set review(MortalityReview value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReview() => $_has(0);
  @$pb.TagNumber(1)
  void clearReview() => $_clearField(1);
  @$pb.TagNumber(1)
  MortalityReview ensureReview() => $_ensure(0);
}

class CompleteMortalityReviewRequest extends $pb.GeneratedMessage {
  factory CompleteMortalityReviewRequest({
    $core.String? reviewId,
    $core.String? meetingId,
    DeathClassification? classification,
    $core.String? findings,
    $core.String? learningPoints,
    $core.Iterable<$core.String>? actionIds,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (reviewId != null) result.reviewId = reviewId;
    if (meetingId != null) result.meetingId = meetingId;
    if (classification != null) result.classification = classification;
    if (findings != null) result.findings = findings;
    if (learningPoints != null) result.learningPoints = learningPoints;
    if (actionIds != null) result.actionIds.addAll(actionIds);
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  CompleteMortalityReviewRequest._();

  factory CompleteMortalityReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteMortalityReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteMortalityReviewRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..aOS(2, _omitFieldNames ? '' : 'meetingId')
    ..aE<DeathClassification>(3, _omitFieldNames ? '' : 'classification',
        enumValues: DeathClassification.values)
    ..aOS(4, _omitFieldNames ? '' : 'findings')
    ..aOS(5, _omitFieldNames ? '' : 'learningPoints')
    ..pPS(6, _omitFieldNames ? '' : 'actionIds')
    ..aInt64(7, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteMortalityReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteMortalityReviewRequest copyWith(
          void Function(CompleteMortalityReviewRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CompleteMortalityReviewRequest))
          as CompleteMortalityReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteMortalityReviewRequest create() =>
      CompleteMortalityReviewRequest._();
  @$core.override
  CompleteMortalityReviewRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteMortalityReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteMortalityReviewRequest>(create);
  static CompleteMortalityReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get meetingId => $_getSZ(1);
  @$pb.TagNumber(2)
  set meetingId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMeetingId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMeetingId() => $_clearField(2);

  @$pb.TagNumber(3)
  DeathClassification get classification => $_getN(2);
  @$pb.TagNumber(3)
  set classification(DeathClassification value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasClassification() => $_has(2);
  @$pb.TagNumber(3)
  void clearClassification() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get findings => $_getSZ(3);
  @$pb.TagNumber(4)
  set findings($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFindings() => $_has(3);
  @$pb.TagNumber(4)
  void clearFindings() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get learningPoints => $_getSZ(4);
  @$pb.TagNumber(5)
  set learningPoints($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLearningPoints() => $_has(4);
  @$pb.TagNumber(5)
  void clearLearningPoints() => $_clearField(5);

  /// Required for a preventable or potentially preventable death.
  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get actionIds => $_getList(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get expectedVersion => $_getI64(6);
  @$pb.TagNumber(7)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasExpectedVersion() => $_has(6);
  @$pb.TagNumber(7)
  void clearExpectedVersion() => $_clearField(7);
}

class CompleteMortalityReviewResponse extends $pb.GeneratedMessage {
  factory CompleteMortalityReviewResponse({
    MortalityReview? review,
  }) {
    final result = create();
    if (review != null) result.review = review;
    return result;
  }

  CompleteMortalityReviewResponse._();

  factory CompleteMortalityReviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteMortalityReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteMortalityReviewResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<MortalityReview>(1, _omitFieldNames ? '' : 'review',
        subBuilder: MortalityReview.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteMortalityReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteMortalityReviewResponse copyWith(
          void Function(CompleteMortalityReviewResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CompleteMortalityReviewResponse))
          as CompleteMortalityReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteMortalityReviewResponse create() =>
      CompleteMortalityReviewResponse._();
  @$core.override
  CompleteMortalityReviewResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteMortalityReviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteMortalityReviewResponse>(
          create);
  static CompleteMortalityReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MortalityReview get review => $_getN(0);
  @$pb.TagNumber(1)
  set review(MortalityReview value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReview() => $_has(0);
  @$pb.TagNumber(1)
  void clearReview() => $_clearField(1);
  @$pb.TagNumber(1)
  MortalityReview ensureReview() => $_ensure(0);
}

class GetMortalityReviewRequest extends $pb.GeneratedMessage {
  factory GetMortalityReviewRequest({
    $core.String? reviewId,
  }) {
    final result = create();
    if (reviewId != null) result.reviewId = reviewId;
    return result;
  }

  GetMortalityReviewRequest._();

  factory GetMortalityReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMortalityReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMortalityReviewRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMortalityReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMortalityReviewRequest copyWith(
          void Function(GetMortalityReviewRequest) updates) =>
      super.copyWith((message) => updates(message as GetMortalityReviewRequest))
          as GetMortalityReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMortalityReviewRequest create() => GetMortalityReviewRequest._();
  @$core.override
  GetMortalityReviewRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMortalityReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMortalityReviewRequest>(create);
  static GetMortalityReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);
}

class GetMortalityReviewResponse extends $pb.GeneratedMessage {
  factory GetMortalityReviewResponse({
    MortalityReview? review,
  }) {
    final result = create();
    if (review != null) result.review = review;
    return result;
  }

  GetMortalityReviewResponse._();

  factory GetMortalityReviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMortalityReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMortalityReviewResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOM<MortalityReview>(1, _omitFieldNames ? '' : 'review',
        subBuilder: MortalityReview.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMortalityReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMortalityReviewResponse copyWith(
          void Function(GetMortalityReviewResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetMortalityReviewResponse))
          as GetMortalityReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMortalityReviewResponse create() => GetMortalityReviewResponse._();
  @$core.override
  GetMortalityReviewResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMortalityReviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMortalityReviewResponse>(create);
  static GetMortalityReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MortalityReview get review => $_getN(0);
  @$pb.TagNumber(1)
  set review(MortalityReview value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReview() => $_has(0);
  @$pb.TagNumber(1)
  void clearReview() => $_clearField(1);
  @$pb.TagNumber(1)
  MortalityReview ensureReview() => $_ensure(0);
}

class ListMortalityReviewsRequest extends $pb.GeneratedMessage {
  factory ListMortalityReviewsRequest({
    $core.bool? openOnly,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
  }) {
    final result = create();
    if (openOnly != null) result.openOnly = openOnly;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListMortalityReviewsRequest._();

  factory ListMortalityReviewsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMortalityReviewsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMortalityReviewsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'openOnly')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMortalityReviewsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMortalityReviewsRequest copyWith(
          void Function(ListMortalityReviewsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListMortalityReviewsRequest))
          as ListMortalityReviewsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMortalityReviewsRequest create() =>
      ListMortalityReviewsRequest._();
  @$core.override
  ListMortalityReviewsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMortalityReviewsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMortalityReviewsRequest>(create);
  static ListMortalityReviewsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get openOnly => $_getBF(0);
  @$pb.TagNumber(1)
  set openOnly($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOpenOnly() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpenOnly() => $_clearField(1);

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

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

class ListMortalityReviewsResponse extends $pb.GeneratedMessage {
  factory ListMortalityReviewsResponse({
    $core.Iterable<MortalityReview>? reviews,
  }) {
    final result = create();
    if (reviews != null) result.reviews.addAll(reviews);
    return result;
  }

  ListMortalityReviewsResponse._();

  factory ListMortalityReviewsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMortalityReviewsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMortalityReviewsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..pPM<MortalityReview>(1, _omitFieldNames ? '' : 'reviews',
        subBuilder: MortalityReview.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMortalityReviewsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMortalityReviewsResponse copyWith(
          void Function(ListMortalityReviewsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListMortalityReviewsResponse))
          as ListMortalityReviewsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMortalityReviewsResponse create() =>
      ListMortalityReviewsResponse._();
  @$core.override
  ListMortalityReviewsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMortalityReviewsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMortalityReviewsResponse>(create);
  static ListMortalityReviewsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MortalityReview> get reviews => $_getList(0);
}

/// PlaceHoldRequest puts a record beyond deletion and beyond change
/// (SRS-QMS-015).
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
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
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

  /// One of the record classes this context holds.
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
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
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
    $core.String? reason,
  }) {
    final result = create();
    if (recordClass != null) result.recordClass = recordClass;
    if (recordId != null) result.recordId = recordId;
    if (reason != null) result.reason = reason;
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
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordClass')
    ..aOS(2, _omitFieldNames ? '' : 'recordId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
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

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
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
          _omitMessageNames ? '' : 'healthcare.quality.v1'),
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

/// QualityService is the quality management contract (SRS-QMS-001 … 015).
class QualityServiceApi {
  final $pb.RpcClient _client;

  QualityServiceApi(this._client);

  /// Incidents, near misses and risk (SRS-QMS-001, SRS-QMS-002, SRS-QMS-005).
  $async.Future<ReportIncidentResponse> reportIncident(
          $pb.ClientContext? ctx, ReportIncidentRequest request) =>
      _client.invoke<ReportIncidentResponse>(ctx, 'QualityService',
          'ReportIncident', request, ReportIncidentResponse());
  $async.Future<GetIncidentResponse> getIncident(
          $pb.ClientContext? ctx, GetIncidentRequest request) =>
      _client.invoke<GetIncidentResponse>(
          ctx, 'QualityService', 'GetIncident', request, GetIncidentResponse());
  $async.Future<ListIncidentsResponse> listIncidents(
          $pb.ClientContext? ctx, ListIncidentsRequest request) =>
      _client.invoke<ListIncidentsResponse>(ctx, 'QualityService',
          'ListIncidents', request, ListIncidentsResponse());
  $async.Future<RescoreIncidentResponse> rescoreIncident(
          $pb.ClientContext? ctx, RescoreIncidentRequest request) =>
      _client.invoke<RescoreIncidentResponse>(ctx, 'QualityService',
          'RescoreIncident', request, RescoreIncidentResponse());
  $async.Future<AdvanceIncidentResponse> advanceIncident(
          $pb.ClientContext? ctx, AdvanceIncidentRequest request) =>
      _client.invoke<AdvanceIncidentResponse>(ctx, 'QualityService',
          'AdvanceIncident', request, AdvanceIncidentResponse());
  $async.Future<SetIncidentRestrictionResponse> setIncidentRestriction(
          $pb.ClientContext? ctx, SetIncidentRestrictionRequest request) =>
      _client.invoke<SetIncidentRestrictionResponse>(ctx, 'QualityService',
          'SetIncidentRestriction', request, SetIncidentRestrictionResponse());
  $async.Future<GetTrendsResponse> getTrends(
          $pb.ClientContext? ctx, GetTrendsRequest request) =>
      _client.invoke<GetTrendsResponse>(
          ctx, 'QualityService', 'GetTrends', request, GetTrendsResponse());

  /// Root cause analysis (SRS-QMS-003).
  $async.Future<StartRcaResponse> startRca(
          $pb.ClientContext? ctx, StartRcaRequest request) =>
      _client.invoke<StartRcaResponse>(
          ctx, 'QualityService', 'StartRca', request, StartRcaResponse());
  $async.Future<AddFactorResponse> addFactor(
          $pb.ClientContext? ctx, AddFactorRequest request) =>
      _client.invoke<AddFactorResponse>(
          ctx, 'QualityService', 'AddFactor', request, AddFactorResponse());
  $async.Future<CompleteRcaResponse> completeRca(
          $pb.ClientContext? ctx, CompleteRcaRequest request) =>
      _client.invoke<CompleteRcaResponse>(
          ctx, 'QualityService', 'CompleteRca', request, CompleteRcaResponse());
  $async.Future<GetRcaResponse> getRca(
          $pb.ClientContext? ctx, GetRcaRequest request) =>
      _client.invoke<GetRcaResponse>(
          ctx, 'QualityService', 'GetRca', request, GetRcaResponse());

  /// Corrective and preventive action (SRS-QMS-004).
  $async.Future<RaiseActionResponse> raiseAction(
          $pb.ClientContext? ctx, RaiseActionRequest request) =>
      _client.invoke<RaiseActionResponse>(
          ctx, 'QualityService', 'RaiseAction', request, RaiseActionResponse());
  $async.Future<ApproveActionResponse> approveAction(
          $pb.ClientContext? ctx, ApproveActionRequest request) =>
      _client.invoke<ApproveActionResponse>(ctx, 'QualityService',
          'ApproveAction', request, ApproveActionResponse());
  $async.Future<AdvanceActionResponse> advanceAction(
          $pb.ClientContext? ctx, AdvanceActionRequest request) =>
      _client.invoke<AdvanceActionResponse>(ctx, 'QualityService',
          'AdvanceAction', request, AdvanceActionResponse());
  $async.Future<RecordEffectivenessResponse> recordEffectiveness(
          $pb.ClientContext? ctx, RecordEffectivenessRequest request) =>
      _client.invoke<RecordEffectivenessResponse>(ctx, 'QualityService',
          'RecordEffectiveness', request, RecordEffectivenessResponse());
  $async.Future<CloseActionResponse> closeAction(
          $pb.ClientContext? ctx, CloseActionRequest request) =>
      _client.invoke<CloseActionResponse>(
          ctx, 'QualityService', 'CloseAction', request, CloseActionResponse());
  $async.Future<GetActionResponse> getAction(
          $pb.ClientContext? ctx, GetActionRequest request) =>
      _client.invoke<GetActionResponse>(
          ctx, 'QualityService', 'GetAction', request, GetActionResponse());
  $async.Future<ListActionsResponse> listActions(
          $pb.ClientContext? ctx, ListActionsRequest request) =>
      _client.invoke<ListActionsResponse>(
          ctx, 'QualityService', 'ListActions', request, ListActionsResponse());
  $async.Future<ListOverdueActionsResponse> listOverdueActions(
          $pb.ClientContext? ctx, ListOverdueActionsRequest request) =>
      _client.invoke<ListOverdueActionsResponse>(ctx, 'QualityService',
          'ListOverdueActions', request, ListOverdueActionsResponse());
  $async.Future<EscalateOverdueActionsResponse> escalateOverdueActions(
          $pb.ClientContext? ctx, EscalateOverdueActionsRequest request) =>
      _client.invoke<EscalateOverdueActionsResponse>(ctx, 'QualityService',
          'EscalateOverdueActions', request, EscalateOverdueActionsResponse());

  /// Document control (SRS-QMS-006).
  $async.Future<RegisterDocumentResponse> registerDocument(
          $pb.ClientContext? ctx, RegisterDocumentRequest request) =>
      _client.invoke<RegisterDocumentResponse>(ctx, 'QualityService',
          'RegisterDocument', request, RegisterDocumentResponse());
  $async.Future<DraftVersionResponse> draftVersion(
          $pb.ClientContext? ctx, DraftVersionRequest request) =>
      _client.invoke<DraftVersionResponse>(ctx, 'QualityService',
          'DraftVersion', request, DraftVersionResponse());
  $async.Future<ApproveVersionResponse> approveVersion(
          $pb.ClientContext? ctx, ApproveVersionRequest request) =>
      _client.invoke<ApproveVersionResponse>(ctx, 'QualityService',
          'ApproveVersion', request, ApproveVersionResponse());
  $async.Future<GetCurrentVersionResponse> getCurrentVersion(
          $pb.ClientContext? ctx, GetCurrentVersionRequest request) =>
      _client.invoke<GetCurrentVersionResponse>(ctx, 'QualityService',
          'GetCurrentVersion', request, GetCurrentVersionResponse());
  $async.Future<ListVersionsResponse> listVersions(
          $pb.ClientContext? ctx, ListVersionsRequest request) =>
      _client.invoke<ListVersionsResponse>(ctx, 'QualityService',
          'ListVersions', request, ListVersionsResponse());
  $async.Future<ListDocumentsResponse> listDocuments(
          $pb.ClientContext? ctx, ListDocumentsRequest request) =>
      _client.invoke<ListDocumentsResponse>(ctx, 'QualityService',
          'ListDocuments', request, ListDocumentsResponse());
  $async.Future<AcknowledgeDocumentResponse> acknowledgeDocument(
          $pb.ClientContext? ctx, AcknowledgeDocumentRequest request) =>
      _client.invoke<AcknowledgeDocumentResponse>(ctx, 'QualityService',
          'AcknowledgeDocument', request, AcknowledgeDocumentResponse());
  $async.Future<ListOutstandingAcknowledgementsResponse>
      listOutstandingAcknowledgements($pb.ClientContext? ctx,
              ListOutstandingAcknowledgementsRequest request) =>
          _client.invoke<ListOutstandingAcknowledgementsResponse>(
              ctx,
              'QualityService',
              'ListOutstandingAcknowledgements',
              request,
              ListOutstandingAcknowledgementsResponse());
  $async.Future<ListReviewsDueResponse> listReviewsDue(
          $pb.ClientContext? ctx, ListReviewsDueRequest request) =>
      _client.invoke<ListReviewsDueResponse>(ctx, 'QualityService',
          'ListReviewsDue', request, ListReviewsDueResponse());

  /// Competency (SRS-QMS-013).
  $async.Future<DefineCompetencyResponse> defineCompetency(
          $pb.ClientContext? ctx, DefineCompetencyRequest request) =>
      _client.invoke<DefineCompetencyResponse>(ctx, 'QualityService',
          'DefineCompetency', request, DefineCompetencyResponse());
  $async.Future<RequireCompetencyResponse> requireCompetency(
          $pb.ClientContext? ctx, RequireCompetencyRequest request) =>
      _client.invoke<RequireCompetencyResponse>(ctx, 'QualityService',
          'RequireCompetency', request, RequireCompetencyResponse());
  $async.Future<AwardCompetencyResponse> awardCompetency(
          $pb.ClientContext? ctx, AwardCompetencyRequest request) =>
      _client.invoke<AwardCompetencyResponse>(ctx, 'QualityService',
          'AwardCompetency', request, AwardCompetencyResponse());
  $async.Future<ListCompetencyGapsResponse> listCompetencyGaps(
          $pb.ClientContext? ctx, ListCompetencyGapsRequest request) =>
      _client.invoke<ListCompetencyGapsResponse>(ctx, 'QualityService',
          'ListCompetencyGaps', request, ListCompetencyGapsResponse());

  /// Internal audit (SRS-QMS-007).
  $async.Future<PlanAuditResponse> planAudit(
          $pb.ClientContext? ctx, PlanAuditRequest request) =>
      _client.invoke<PlanAuditResponse>(
          ctx, 'QualityService', 'PlanAudit', request, PlanAuditResponse());
  $async.Future<RecordFindingResponse> recordFinding(
          $pb.ClientContext? ctx, RecordFindingRequest request) =>
      _client.invoke<RecordFindingResponse>(ctx, 'QualityService',
          'RecordFinding', request, RecordFindingResponse());
  $async.Future<LinkFindingActionResponse> linkFindingAction(
          $pb.ClientContext? ctx, LinkFindingActionRequest request) =>
      _client.invoke<LinkFindingActionResponse>(ctx, 'QualityService',
          'LinkFindingAction', request, LinkFindingActionResponse());
  $async.Future<CloseFindingResponse> closeFinding(
          $pb.ClientContext? ctx, CloseFindingRequest request) =>
      _client.invoke<CloseFindingResponse>(ctx, 'QualityService',
          'CloseFinding', request, CloseFindingResponse());
  $async.Future<ReportAuditResponse> reportAudit(
          $pb.ClientContext? ctx, ReportAuditRequest request) =>
      _client.invoke<ReportAuditResponse>(
          ctx, 'QualityService', 'ReportAudit', request, ReportAuditResponse());
  $async.Future<CloseAuditResponse> closeAudit(
          $pb.ClientContext? ctx, CloseAuditRequest request) =>
      _client.invoke<CloseAuditResponse>(
          ctx, 'QualityService', 'CloseAudit', request, CloseAuditResponse());
  $async.Future<GetAuditResponse> getAudit(
          $pb.ClientContext? ctx, GetAuditRequest request) =>
      _client.invoke<GetAuditResponse>(
          ctx, 'QualityService', 'GetAudit', request, GetAuditResponse());
  $async.Future<ListAuditsResponse> listAudits(
          $pb.ClientContext? ctx, ListAuditsRequest request) =>
      _client.invoke<ListAuditsResponse>(
          ctx, 'QualityService', 'ListAudits', request, ListAuditsResponse());
  $async.Future<ListFindingsResponse> listFindings(
          $pb.ClientContext? ctx, ListFindingsRequest request) =>
      _client.invoke<ListFindingsResponse>(ctx, 'QualityService',
          'ListFindings', request, ListFindingsResponse());

  /// Committees (SRS-QMS-008).
  $async.Future<FormCommitteeResponse> formCommittee(
          $pb.ClientContext? ctx, FormCommitteeRequest request) =>
      _client.invoke<FormCommitteeResponse>(ctx, 'QualityService',
          'FormCommittee', request, FormCommitteeResponse());
  $async.Future<ScheduleMeetingResponse> scheduleMeeting(
          $pb.ClientContext? ctx, ScheduleMeetingRequest request) =>
      _client.invoke<ScheduleMeetingResponse>(ctx, 'QualityService',
          'ScheduleMeeting', request, ScheduleMeetingResponse());
  $async.Future<RecordMinutesResponse> recordMinutes(
          $pb.ClientContext? ctx, RecordMinutesRequest request) =>
      _client.invoke<RecordMinutesResponse>(ctx, 'QualityService',
          'RecordMinutes', request, RecordMinutesResponse());
  $async.Future<GetMeetingResponse> getMeeting(
          $pb.ClientContext? ctx, GetMeetingRequest request) =>
      _client.invoke<GetMeetingResponse>(
          ctx, 'QualityService', 'GetMeeting', request, GetMeetingResponse());
  $async.Future<ListCommitteesResponse> listCommittees(
          $pb.ClientContext? ctx, ListCommitteesRequest request) =>
      _client.invoke<ListCommitteesResponse>(ctx, 'QualityService',
          'ListCommittees', request, ListCommitteesResponse());

  /// Accreditation and readiness (SRS-QMS-009, SRS-QMS-014).
  $async.Future<LoadStandardResponse> loadStandard(
          $pb.ClientContext? ctx, LoadStandardRequest request) =>
      _client.invoke<LoadStandardResponse>(ctx, 'QualityService',
          'LoadStandard', request, LoadStandardResponse());
  $async.Future<FileEvidenceResponse> fileEvidence(
          $pb.ClientContext? ctx, FileEvidenceRequest request) =>
      _client.invoke<FileEvidenceResponse>(ctx, 'QualityService',
          'FileEvidence', request, FileEvidenceResponse());
  $async.Future<WithdrawEvidenceResponse> withdrawEvidence(
          $pb.ClientContext? ctx, WithdrawEvidenceRequest request) =>
      _client.invoke<WithdrawEvidenceResponse>(ctx, 'QualityService',
          'WithdrawEvidence', request, WithdrawEvidenceResponse());
  $async.Future<ReviewClauseResponse> reviewClause(
          $pb.ClientContext? ctx, ReviewClauseRequest request) =>
      _client.invoke<ReviewClauseResponse>(ctx, 'QualityService',
          'ReviewClause', request, ReviewClauseResponse());
  $async.Future<GetReadinessResponse> getReadiness(
          $pb.ClientContext? ctx, GetReadinessRequest request) =>
      _client.invoke<GetReadinessResponse>(ctx, 'QualityService',
          'GetReadiness', request, GetReadinessResponse());
  $async.Future<ListStandardsResponse> listStandards(
          $pb.ClientContext? ctx, ListStandardsRequest request) =>
      _client.invoke<ListStandardsResponse>(ctx, 'QualityService',
          'ListStandards', request, ListStandardsResponse());
  $async.Future<ListClausesResponse> listClauses(
          $pb.ClientContext? ctx, ListClausesRequest request) =>
      _client.invoke<ListClausesResponse>(
          ctx, 'QualityService', 'ListClauses', request, ListClausesResponse());

  /// The indicator dictionary (SRS-QMS-010).
  $async.Future<DefineIndicatorResponse> defineIndicator(
          $pb.ClientContext? ctx, DefineIndicatorRequest request) =>
      _client.invoke<DefineIndicatorResponse>(ctx, 'QualityService',
          'DefineIndicator', request, DefineIndicatorResponse());
  $async.Future<RecordIndicatorValueResponse> recordIndicatorValue(
          $pb.ClientContext? ctx, RecordIndicatorValueRequest request) =>
      _client.invoke<RecordIndicatorValueResponse>(ctx, 'QualityService',
          'RecordIndicatorValue', request, RecordIndicatorValueResponse());
  $async.Future<GetDashboardResponse> getDashboard(
          $pb.ClientContext? ctx, GetDashboardRequest request) =>
      _client.invoke<GetDashboardResponse>(ctx, 'QualityService',
          'GetDashboard', request, GetDashboardResponse());
  $async.Future<ListIndicatorValuesResponse> listIndicatorValues(
          $pb.ClientContext? ctx, ListIndicatorValuesRequest request) =>
      _client.invoke<ListIndicatorValuesResponse>(ctx, 'QualityService',
          'ListIndicatorValues', request, ListIndicatorValuesResponse());

  /// Complaints (SRS-QMS-011).
  $async.Future<ReceiveComplaintResponse> receiveComplaint(
          $pb.ClientContext? ctx, ReceiveComplaintRequest request) =>
      _client.invoke<ReceiveComplaintResponse>(ctx, 'QualityService',
          'ReceiveComplaint', request, ReceiveComplaintResponse());
  $async.Future<AcknowledgeComplaintResponse> acknowledgeComplaint(
          $pb.ClientContext? ctx, AcknowledgeComplaintRequest request) =>
      _client.invoke<AcknowledgeComplaintResponse>(ctx, 'QualityService',
          'AcknowledgeComplaint', request, AcknowledgeComplaintResponse());
  $async.Future<ResolveComplaintResponse> resolveComplaint(
          $pb.ClientContext? ctx, ResolveComplaintRequest request) =>
      _client.invoke<ResolveComplaintResponse>(ctx, 'QualityService',
          'ResolveComplaint', request, ResolveComplaintResponse());
  $async.Future<CloseComplaintResponse> closeComplaint(
          $pb.ClientContext? ctx, CloseComplaintRequest request) =>
      _client.invoke<CloseComplaintResponse>(ctx, 'QualityService',
          'CloseComplaint', request, CloseComplaintResponse());
  $async.Future<GetComplaintResponse> getComplaint(
          $pb.ClientContext? ctx, GetComplaintRequest request) =>
      _client.invoke<GetComplaintResponse>(ctx, 'QualityService',
          'GetComplaint', request, GetComplaintResponse());
  $async.Future<ListComplaintsResponse> listComplaints(
          $pb.ClientContext? ctx, ListComplaintsRequest request) =>
      _client.invoke<ListComplaintsResponse>(ctx, 'QualityService',
          'ListComplaints', request, ListComplaintsResponse());
  $async.Future<ListComplaintBreachesResponse> listComplaintBreaches(
          $pb.ClientContext? ctx, ListComplaintBreachesRequest request) =>
      _client.invoke<ListComplaintBreachesResponse>(ctx, 'QualityService',
          'ListComplaintBreaches', request, ListComplaintBreachesResponse());
  $async.Future<EscalateComplaintBreachesResponse> escalateComplaintBreaches(
          $pb.ClientContext? ctx, EscalateComplaintBreachesRequest request) =>
      _client.invoke<EscalateComplaintBreachesResponse>(
          ctx,
          'QualityService',
          'EscalateComplaintBreaches',
          request,
          EscalateComplaintBreachesResponse());

  /// Peer review (SRS-QMS-012).
  $async.Future<StartMortalityReviewResponse> startMortalityReview(
          $pb.ClientContext? ctx, StartMortalityReviewRequest request) =>
      _client.invoke<StartMortalityReviewResponse>(ctx, 'QualityService',
          'StartMortalityReview', request, StartMortalityReviewResponse());
  $async.Future<CompleteMortalityReviewResponse> completeMortalityReview(
          $pb.ClientContext? ctx, CompleteMortalityReviewRequest request) =>
      _client.invoke<CompleteMortalityReviewResponse>(
          ctx,
          'QualityService',
          'CompleteMortalityReview',
          request,
          CompleteMortalityReviewResponse());
  $async.Future<GetMortalityReviewResponse> getMortalityReview(
          $pb.ClientContext? ctx, GetMortalityReviewRequest request) =>
      _client.invoke<GetMortalityReviewResponse>(ctx, 'QualityService',
          'GetMortalityReview', request, GetMortalityReviewResponse());
  $async.Future<ListMortalityReviewsResponse> listMortalityReviews(
          $pb.ClientContext? ctx, ListMortalityReviewsRequest request) =>
      _client.invoke<ListMortalityReviewsResponse>(ctx, 'QualityService',
          'ListMortalityReviews', request, ListMortalityReviewsResponse());

  /// Retention and legal hold (SRS-QMS-015).
  $async.Future<PlaceHoldResponse> placeHold(
          $pb.ClientContext? ctx, PlaceHoldRequest request) =>
      _client.invoke<PlaceHoldResponse>(
          ctx, 'QualityService', 'PlaceHold', request, PlaceHoldResponse());
  $async.Future<ReleaseHoldResponse> releaseHold(
          $pb.ClientContext? ctx, ReleaseHoldRequest request) =>
      _client.invoke<ReleaseHoldResponse>(
          ctx, 'QualityService', 'ReleaseHold', request, ReleaseHoldResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
