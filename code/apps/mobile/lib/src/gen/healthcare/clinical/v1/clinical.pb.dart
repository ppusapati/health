// This is a generated file - do not edit.
//
// Generated from healthcare/clinical/v1/clinical.proto.

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

import 'clinical.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'clinical.pbenum.dart';

/// A coded concept from a terminology.
///
/// System and code together, never code alone: "C50" means breast cancer in
/// ICD-10 and something else in a local scheme.
class Coding extends $pb.GeneratedMessage {
  factory Coding({
    $core.String? system,
    $core.String? version,
    $core.String? code,
    $core.String? display,
  }) {
    final result = create();
    if (system != null) result.system = system;
    if (version != null) result.version = version;
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    return result;
  }

  Coding._();

  factory Coding.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Coding.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Coding',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'system')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'display')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Coding clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Coding copyWith(void Function(Coding) updates) =>
      super.copyWith((message) => updates(message as Coding)) as Coding;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Coding create() => Coding._();
  @$core.override
  Coding createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Coding getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Coding>(create);
  static Coding? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get system => $_getSZ(0);
  @$pb.TagNumber(1)
  set system($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSystem() => $_has(0);
  @$pb.TagNumber(1)
  void clearSystem() => $_clearField(1);

  /// Pins the release. Codes have been reassigned between revisions, so a code
  /// with no version is ambiguous once a decade.
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

  /// A bare code on a screen is a screen clinicians stop reading.
  @$pb.TagNumber(4)
  $core.String get display => $_getSZ(3);
  @$pb.TagNumber(4)
  set display($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisplay() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplay() => $_clearField(4);
}

/// The chart the caller believes they are working in (SRS-CLN-017).
///
/// Carried on every action that changes a patient's record and checked against
/// the record the action lands on. The failure it guards against is mundane and
/// common: four charts open, the wrong tab in front, a prescription for the
/// patient in the next bed.
class PatientContext extends $pb.GeneratedMessage {
  factory PatientContext({
    $core.String? patientId,
    $core.String? encounterId,
    $0.Timestamp? openedAt,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (openedAt != null) result.openedAt = openedAt;
    return result;
  }

  PatientContext._();

  factory PatientContext.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PatientContext.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PatientContext',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'openedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PatientContext clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PatientContext copyWith(void Function(PatientContext) updates) =>
      super.copyWith((message) => updates(message as PatientContext))
          as PatientContext;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PatientContext create() => PatientContext._();
  @$core.override
  PatientContext createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PatientContext getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PatientContext>(create);
  static PatientContext? _defaultInstance;

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

  /// When the chart was opened. A screen left open overnight is a screen the
  /// next clinician inherits with somebody else's patient in it.
  @$pb.TagNumber(3)
  $0.Timestamp get openedAt => $_getN(2);
  @$pb.TagNumber(3)
  set openedAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOpenedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearOpenedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureOpenedAt() => $_ensure(2);
}

class Section extends $pb.GeneratedMessage {
  factory Section({
    $core.String? heading,
    $core.String? text,
  }) {
    final result = create();
    if (heading != null) result.heading = heading;
    if (text != null) result.text = text;
    return result;
  }

  Section._();

  factory Section.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Section.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Section',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'heading')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Section clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Section copyWith(void Function(Section) updates) =>
      super.copyWith((message) => updates(message as Section)) as Section;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Section create() => Section._();
  @$core.override
  Section createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Section getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Section>(create);
  static Section? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get heading => $_getSZ(0);
  @$pb.TagNumber(1)
  set heading($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHeading() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeading() => $_clearField(1);

  /// The expanded content. Smart phrases are expanded before storage
  /// (SRS-CLN-015), so what is signed is what a reader sees.
  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);
}

class Signature extends $pb.GeneratedMessage {
  factory Signature({
    $core.String? signatureId,
    $core.String? subjectId,
    SignatureMeaning? meaning,
    $0.Timestamp? signedAt,
    $core.String? contentHash,
    $core.String? templateVersion,
  }) {
    final result = create();
    if (signatureId != null) result.signatureId = signatureId;
    if (subjectId != null) result.subjectId = subjectId;
    if (meaning != null) result.meaning = meaning;
    if (signedAt != null) result.signedAt = signedAt;
    if (contentHash != null) result.contentHash = contentHash;
    if (templateVersion != null) result.templateVersion = templateVersion;
    return result;
  }

  Signature._();

  factory Signature.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Signature.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Signature',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'signatureId')
    ..aOS(2, _omitFieldNames ? '' : 'subjectId')
    ..aE<SignatureMeaning>(3, _omitFieldNames ? '' : 'meaning',
        enumValues: SignatureMeaning.values)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'signedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'contentHash')
    ..aOS(6, _omitFieldNames ? '' : 'templateVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Signature clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Signature copyWith(void Function(Signature) updates) =>
      super.copyWith((message) => updates(message as Signature)) as Signature;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Signature create() => Signature._();
  @$core.override
  Signature createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Signature getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Signature>(create);
  static Signature? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get signatureId => $_getSZ(0);
  @$pb.TagNumber(1)
  set signatureId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSignatureId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignatureId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get subjectId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subjectId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubjectId() => $_clearField(2);

  @$pb.TagNumber(3)
  SignatureMeaning get meaning => $_getN(2);
  @$pb.TagNumber(3)
  set meaning(SignatureMeaning value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMeaning() => $_has(2);
  @$pb.TagNumber(3)
  void clearMeaning() => $_clearField(3);

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

  /// Pins what was signed. Without it a signature says "this person signed
  /// something called note 47", and the content of note 47 is exactly what a
  /// dispute is about.
  @$pb.TagNumber(5)
  $core.String get contentHash => $_getSZ(4);
  @$pb.TagNumber(5)
  set contentHash($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContentHash() => $_has(4);
  @$pb.TagNumber(5)
  void clearContentHash() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get templateVersion => $_getSZ(5);
  @$pb.TagNumber(6)
  set templateVersion($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTemplateVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearTemplateVersion() => $_clearField(6);
}

class Document extends $pb.GeneratedMessage {
  factory Document({
    $core.String? documentId,
    $core.String? patientId,
    $core.String? encounterId,
    DocumentKind? kind,
    $core.String? templateId,
    $core.String? templateVersion,
    $core.String? title,
    $core.Iterable<Section>? sections,
    DocumentStatus? status,
    Confidentiality? confidentiality,
    $core.String? amendsId,
    $core.String? addsToId,
    $core.String? changeReason,
    $core.String? retractionReason,
    $core.bool? dictated,
    $core.Iterable<Signature>? signatures,
    $core.String? authoredBy,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $fixnum.Int64? version,
    $core.bool? intact,
  }) {
    final result = create();
    if (documentId != null) result.documentId = documentId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (kind != null) result.kind = kind;
    if (templateId != null) result.templateId = templateId;
    if (templateVersion != null) result.templateVersion = templateVersion;
    if (title != null) result.title = title;
    if (sections != null) result.sections.addAll(sections);
    if (status != null) result.status = status;
    if (confidentiality != null) result.confidentiality = confidentiality;
    if (amendsId != null) result.amendsId = amendsId;
    if (addsToId != null) result.addsToId = addsToId;
    if (changeReason != null) result.changeReason = changeReason;
    if (retractionReason != null) result.retractionReason = retractionReason;
    if (dictated != null) result.dictated = dictated;
    if (signatures != null) result.signatures.addAll(signatures);
    if (authoredBy != null) result.authoredBy = authoredBy;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (version != null) result.version = version;
    if (intact != null) result.intact = intact;
    return result;
  }

  Document._();

  factory Document.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Document.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Document',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'documentId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aE<DocumentKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: DocumentKind.values)
    ..aOS(5, _omitFieldNames ? '' : 'templateId')
    ..aOS(6, _omitFieldNames ? '' : 'templateVersion')
    ..aOS(7, _omitFieldNames ? '' : 'title')
    ..pPM<Section>(8, _omitFieldNames ? '' : 'sections',
        subBuilder: Section.create)
    ..aE<DocumentStatus>(9, _omitFieldNames ? '' : 'status',
        enumValues: DocumentStatus.values)
    ..aE<Confidentiality>(10, _omitFieldNames ? '' : 'confidentiality',
        enumValues: Confidentiality.values)
    ..aOS(11, _omitFieldNames ? '' : 'amendsId')
    ..aOS(12, _omitFieldNames ? '' : 'addsToId')
    ..aOS(13, _omitFieldNames ? '' : 'changeReason')
    ..aOS(14, _omitFieldNames ? '' : 'retractionReason')
    ..aOB(15, _omitFieldNames ? '' : 'dictated')
    ..pPM<Signature>(16, _omitFieldNames ? '' : 'signatures',
        subBuilder: Signature.create)
    ..aOS(17, _omitFieldNames ? '' : 'authoredBy')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(19, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(20, _omitFieldNames ? '' : 'version')
    ..aOB(21, _omitFieldNames ? '' : 'intact')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Document clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Document copyWith(void Function(Document) updates) =>
      super.copyWith((message) => updates(message as Document)) as Document;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Document create() => Document._();
  @$core.override
  Document createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Document getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Document>(create);
  static Document? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get documentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set documentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentId() => $_clearField(1);

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
  DocumentKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(DocumentKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get templateId => $_getSZ(4);
  @$pb.TagNumber(5)
  set templateId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTemplateId() => $_has(4);
  @$pb.TagNumber(5)
  void clearTemplateId() => $_clearField(5);

  /// The exact revision the note was composed against (SRS-CLN-002).
  @$pb.TagNumber(6)
  $core.String get templateVersion => $_getSZ(5);
  @$pb.TagNumber(6)
  set templateVersion($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTemplateVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearTemplateVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get title => $_getSZ(6);
  @$pb.TagNumber(7)
  set title($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTitle() => $_has(6);
  @$pb.TagNumber(7)
  void clearTitle() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<Section> get sections => $_getList(7);

  @$pb.TagNumber(9)
  DocumentStatus get status => $_getN(8);
  @$pb.TagNumber(9)
  set status(DocumentStatus value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  Confidentiality get confidentiality => $_getN(9);
  @$pb.TagNumber(10)
  set confidentiality(Confidentiality value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasConfidentiality() => $_has(9);
  @$pb.TagNumber(10)
  void clearConfidentiality() => $_clearField(10);

  /// Exactly one, and only on an amendment or an addendum.
  @$pb.TagNumber(11)
  $core.String get amendsId => $_getSZ(10);
  @$pb.TagNumber(11)
  set amendsId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasAmendsId() => $_has(10);
  @$pb.TagNumber(11)
  void clearAmendsId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get addsToId => $_getSZ(11);
  @$pb.TagNumber(12)
  set addsToId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAddsToId() => $_has(11);
  @$pb.TagNumber(12)
  void clearAddsToId() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get changeReason => $_getSZ(12);
  @$pb.TagNumber(13)
  set changeReason($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasChangeReason() => $_has(12);
  @$pb.TagNumber(13)
  void clearChangeReason() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get retractionReason => $_getSZ(13);
  @$pb.TagNumber(14)
  set retractionReason($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRetractionReason() => $_has(13);
  @$pb.TagNumber(14)
  void clearRetractionReason() => $_clearField(14);

  /// Content that arrived from speech recognition (SRS-CLN-016).
  @$pb.TagNumber(15)
  $core.bool get dictated => $_getBF(14);
  @$pb.TagNumber(15)
  set dictated($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasDictated() => $_has(14);
  @$pb.TagNumber(15)
  void clearDictated() => $_clearField(15);

  @$pb.TagNumber(16)
  $pb.PbList<Signature> get signatures => $_getList(15);

  @$pb.TagNumber(17)
  $core.String get authoredBy => $_getSZ(16);
  @$pb.TagNumber(17)
  set authoredBy($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasAuthoredBy() => $_has(16);
  @$pb.TagNumber(17)
  void clearAuthoredBy() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get createdAt => $_getN(17);
  @$pb.TagNumber(18)
  set createdAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasCreatedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearCreatedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureCreatedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $0.Timestamp get updatedAt => $_getN(18);
  @$pb.TagNumber(19)
  set updatedAt($0.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasUpdatedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearUpdatedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Timestamp ensureUpdatedAt() => $_ensure(18);

  @$pb.TagNumber(20)
  $fixnum.Int64 get version => $_getI64(19);
  @$pb.TagNumber(20)
  set version($fixnum.Int64 value) => $_setInt64(19, value);
  @$pb.TagNumber(20)
  $core.bool hasVersion() => $_has(19);
  @$pb.TagNumber(20)
  void clearVersion() => $_clearField(20);

  /// Whether the content still matches what was signed. A signature is only
  /// evidence if the thing it pinned has not moved.
  @$pb.TagNumber(21)
  $core.bool get intact => $_getBF(20);
  @$pb.TagNumber(21)
  set intact($core.bool value) => $_setBool(20, value);
  @$pb.TagNumber(21)
  $core.bool hasIntact() => $_has(20);
  @$pb.TagNumber(21)
  void clearIntact() => $_clearField(21);
}

class Template extends $pb.GeneratedMessage {
  factory Template({
    $core.String? templateId,
    $core.String? name,
    $core.String? version,
    DocumentKind? kind,
    $core.String? specialty,
    $core.Iterable<$core.String>? sections,
    $core.bool? retired,
  }) {
    final result = create();
    if (templateId != null) result.templateId = templateId;
    if (name != null) result.name = name;
    if (version != null) result.version = version;
    if (kind != null) result.kind = kind;
    if (specialty != null) result.specialty = specialty;
    if (sections != null) result.sections.addAll(sections);
    if (retired != null) result.retired = retired;
    return result;
  }

  Template._();

  factory Template.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Template.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Template',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'templateId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'version')
    ..aE<DocumentKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: DocumentKind.values)
    ..aOS(5, _omitFieldNames ? '' : 'specialty')
    ..pPS(6, _omitFieldNames ? '' : 'sections')
    ..aOB(7, _omitFieldNames ? '' : 'retired')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Template clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Template copyWith(void Function(Template) updates) =>
      super.copyWith((message) => updates(message as Template)) as Template;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Template create() => Template._();
  @$core.override
  Template createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Template getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Template>(create);
  static Template? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get templateId => $_getSZ(0);
  @$pb.TagNumber(1)
  set templateId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTemplateId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemplateId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// Never mutated in place: editing a published template would silently rewrite
  /// what every historical note claims to have answered.
  @$pb.TagNumber(3)
  $core.String get version => $_getSZ(2);
  @$pb.TagNumber(3)
  set version($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  DocumentKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(DocumentKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get specialty => $_getSZ(4);
  @$pb.TagNumber(5)
  set specialty($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSpecialty() => $_has(4);
  @$pb.TagNumber(5)
  void clearSpecialty() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get sections => $_getList(5);

  /// A retired template can still be read on old notes but cannot be chosen for
  /// a new one.
  @$pb.TagNumber(7)
  $core.bool get retired => $_getBF(6);
  @$pb.TagNumber(7)
  set retired($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRetired() => $_has(6);
  @$pb.TagNumber(7)
  void clearRetired() => $_clearField(7);
}

class Problem extends $pb.GeneratedMessage {
  factory Problem({
    $core.String? problemId,
    $core.String? patientId,
    $core.String? encounterId,
    Coding? code,
    $core.String? note,
    ProblemStatus? status,
    $0.Timestamp? onsetAt,
    $0.Timestamp? resolvedAt,
    Confidentiality? confidentiality,
    $core.String? recordedBy,
    $0.Timestamp? recordedAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (problemId != null) result.problemId = problemId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (code != null) result.code = code;
    if (note != null) result.note = note;
    if (status != null) result.status = status;
    if (onsetAt != null) result.onsetAt = onsetAt;
    if (resolvedAt != null) result.resolvedAt = resolvedAt;
    if (confidentiality != null) result.confidentiality = confidentiality;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (version != null) result.version = version;
    return result;
  }

  Problem._();

  factory Problem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Problem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Problem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'problemId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'code', subBuilder: Coding.create)
    ..aOS(5, _omitFieldNames ? '' : 'note')
    ..aE<ProblemStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: ProblemStatus.values)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'onsetAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'resolvedAt',
        subBuilder: $0.Timestamp.create)
    ..aE<Confidentiality>(9, _omitFieldNames ? '' : 'confidentiality',
        enumValues: Confidentiality.values)
    ..aOS(10, _omitFieldNames ? '' : 'recordedBy')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(12, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Problem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Problem copyWith(void Function(Problem) updates) =>
      super.copyWith((message) => updates(message as Problem)) as Problem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Problem create() => Problem._();
  @$core.override
  Problem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Problem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Problem>(create);
  static Problem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get problemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set problemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProblemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProblemId() => $_clearField(1);

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
  Coding get code => $_getN(3);
  @$pb.TagNumber(4)
  set code(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearCode() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureCode() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get note => $_getSZ(4);
  @$pb.TagNumber(5)
  set note($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNote() => $_has(4);
  @$pb.TagNumber(5)
  void clearNote() => $_clearField(5);

  @$pb.TagNumber(6)
  ProblemStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(ProblemStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get onsetAt => $_getN(6);
  @$pb.TagNumber(7)
  set onsetAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasOnsetAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearOnsetAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureOnsetAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get resolvedAt => $_getN(7);
  @$pb.TagNumber(8)
  set resolvedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasResolvedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearResolvedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureResolvedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  Confidentiality get confidentiality => $_getN(8);
  @$pb.TagNumber(9)
  set confidentiality(Confidentiality value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasConfidentiality() => $_has(8);
  @$pb.TagNumber(9)
  void clearConfidentiality() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get recordedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set recordedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRecordedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearRecordedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get recordedAt => $_getN(10);
  @$pb.TagNumber(11)
  set recordedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasRecordedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearRecordedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureRecordedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $fixnum.Int64 get version => $_getI64(11);
  @$pb.TagNumber(12)
  set version($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasVersion() => $_has(11);
  @$pb.TagNumber(12)
  void clearVersion() => $_clearField(12);
}

class Reaction extends $pb.GeneratedMessage {
  factory Reaction({
    Coding? manifestation,
    $core.String? severity,
    $core.String? note,
  }) {
    final result = create();
    if (manifestation != null) result.manifestation = manifestation;
    if (severity != null) result.severity = severity;
    if (note != null) result.note = note;
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
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Coding>(1, _omitFieldNames ? '' : 'manifestation',
        subBuilder: Coding.create)
    ..aOS(2, _omitFieldNames ? '' : 'severity')
    ..aOS(3, _omitFieldNames ? '' : 'note')
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
  Coding get manifestation => $_getN(0);
  @$pb.TagNumber(1)
  set manifestation(Coding value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasManifestation() => $_has(0);
  @$pb.TagNumber(1)
  void clearManifestation() => $_clearField(1);
  @$pb.TagNumber(1)
  Coding ensureManifestation() => $_ensure(0);

  /// How bad it was, which is not the same as criticality: a mild past reaction
  /// to a drug can still carry a high criticality.
  @$pb.TagNumber(2)
  $core.String get severity => $_getSZ(1);
  @$pb.TagNumber(2)
  set severity($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSeverity() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeverity() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);
}

class Allergy extends $pb.GeneratedMessage {
  factory Allergy({
    $core.String? allergyId,
    $core.String? patientId,
    $core.String? encounterId,
    Coding? substance,
    AllergyKind? kind,
    AllergyCriticality? criticality,
    AllergyVerification? verification,
    $core.Iterable<Reaction>? reactions,
    $0.Timestamp? onsetAt,
    $core.String? note,
    $core.String? recordedBy,
    $0.Timestamp? recordedAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (allergyId != null) result.allergyId = allergyId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (substance != null) result.substance = substance;
    if (kind != null) result.kind = kind;
    if (criticality != null) result.criticality = criticality;
    if (verification != null) result.verification = verification;
    if (reactions != null) result.reactions.addAll(reactions);
    if (onsetAt != null) result.onsetAt = onsetAt;
    if (note != null) result.note = note;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (version != null) result.version = version;
    return result;
  }

  Allergy._();

  factory Allergy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Allergy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Allergy',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'allergyId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'substance',
        subBuilder: Coding.create)
    ..aE<AllergyKind>(5, _omitFieldNames ? '' : 'kind',
        enumValues: AllergyKind.values)
    ..aE<AllergyCriticality>(6, _omitFieldNames ? '' : 'criticality',
        enumValues: AllergyCriticality.values)
    ..aE<AllergyVerification>(7, _omitFieldNames ? '' : 'verification',
        enumValues: AllergyVerification.values)
    ..pPM<Reaction>(8, _omitFieldNames ? '' : 'reactions',
        subBuilder: Reaction.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'onsetAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'note')
    ..aOS(11, _omitFieldNames ? '' : 'recordedBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(13, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Allergy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Allergy copyWith(void Function(Allergy) updates) =>
      super.copyWith((message) => updates(message as Allergy)) as Allergy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Allergy create() => Allergy._();
  @$core.override
  Allergy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Allergy getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Allergy>(create);
  static Allergy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get allergyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set allergyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAllergyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllergyId() => $_clearField(1);

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

  /// Coded, because the acceptance criterion is that the allergy reaches
  /// medication decision support, and free text cannot be checked.
  @$pb.TagNumber(4)
  Coding get substance => $_getN(3);
  @$pb.TagNumber(4)
  set substance(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSubstance() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubstance() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureSubstance() => $_ensure(3);

  @$pb.TagNumber(5)
  AllergyKind get kind => $_getN(4);
  @$pb.TagNumber(5)
  set kind(AllergyKind value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearKind() => $_clearField(5);

  @$pb.TagNumber(6)
  AllergyCriticality get criticality => $_getN(5);
  @$pb.TagNumber(6)
  set criticality(AllergyCriticality value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCriticality() => $_has(5);
  @$pb.TagNumber(6)
  void clearCriticality() => $_clearField(6);

  @$pb.TagNumber(7)
  AllergyVerification get verification => $_getN(6);
  @$pb.TagNumber(7)
  set verification(AllergyVerification value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasVerification() => $_has(6);
  @$pb.TagNumber(7)
  void clearVerification() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<Reaction> get reactions => $_getList(7);

  @$pb.TagNumber(9)
  $0.Timestamp get onsetAt => $_getN(8);
  @$pb.TagNumber(9)
  set onsetAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasOnsetAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearOnsetAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureOnsetAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get note => $_getSZ(9);
  @$pb.TagNumber(10)
  set note($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasNote() => $_has(9);
  @$pb.TagNumber(10)
  void clearNote() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get recordedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set recordedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRecordedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearRecordedBy() => $_clearField(11);

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
  $fixnum.Int64 get version => $_getI64(12);
  @$pb.TagNumber(13)
  set version($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(13)
  $core.bool hasVersion() => $_has(12);
  @$pb.TagNumber(13)
  void clearVersion() => $_clearField(13);
}

class Quantity extends $pb.GeneratedMessage {
  factory Quantity({
    $core.double? value,
    $core.String? unit,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    return result;
  }

  Quantity._();

  factory Quantity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Quantity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Quantity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'value')
    ..aOS(2, _omitFieldNames ? '' : 'unit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Quantity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Quantity copyWith(void Function(Quantity) updates) =>
      super.copyWith((message) => updates(message as Quantity)) as Quantity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Quantity create() => Quantity._();
  @$core.override
  Quantity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Quantity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Quantity>(create);
  static Quantity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  /// Unit and value are inseparable. A potassium of 6.1 is a crisis in mmol/L
  /// and meaningless without it.
  @$pb.TagNumber(2)
  $core.String get unit => $_getSZ(1);
  @$pb.TagNumber(2)
  set unit($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnit() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnit() => $_clearField(2);
}

class Observation extends $pb.GeneratedMessage {
  factory Observation({
    $core.String? observationId,
    $core.String? patientId,
    $core.String? encounterId,
    Coding? code,
    Quantity? value,
    $core.String? textValue,
    Coding? codedValue,
    $core.double? referenceLow,
    $core.double? referenceHigh,
    $core.bool? hasReferenceRange,
    $core.String? referenceText,
    Interpretation? interpretation,
    $core.String? interpretationSource,
    ObservationStatus? status,
    $0.Timestamp? effectiveAt,
    $0.Timestamp? issuedAt,
    $core.String? performerId,
    $core.String? deviceId,
    $core.String? sourceSystem,
    $core.String? note,
    $core.String? amendsId,
    $core.String? recordedBy,
    $0.Timestamp? recordedAt,
    ObservationSource? source,
    ValidationState? validation,
    DeviceSource? device,
    $core.String? validatedBy,
    $0.Timestamp? validatedAt,
    $core.String? validationNote,
  }) {
    final result = create();
    if (observationId != null) result.observationId = observationId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (code != null) result.code = code;
    if (value != null) result.value = value;
    if (textValue != null) result.textValue = textValue;
    if (codedValue != null) result.codedValue = codedValue;
    if (referenceLow != null) result.referenceLow = referenceLow;
    if (referenceHigh != null) result.referenceHigh = referenceHigh;
    if (hasReferenceRange != null) result.hasReferenceRange = hasReferenceRange;
    if (referenceText != null) result.referenceText = referenceText;
    if (interpretation != null) result.interpretation = interpretation;
    if (interpretationSource != null)
      result.interpretationSource = interpretationSource;
    if (status != null) result.status = status;
    if (effectiveAt != null) result.effectiveAt = effectiveAt;
    if (issuedAt != null) result.issuedAt = issuedAt;
    if (performerId != null) result.performerId = performerId;
    if (deviceId != null) result.deviceId = deviceId;
    if (sourceSystem != null) result.sourceSystem = sourceSystem;
    if (note != null) result.note = note;
    if (amendsId != null) result.amendsId = amendsId;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (source != null) result.source = source;
    if (validation != null) result.validation = validation;
    if (device != null) result.device = device;
    if (validatedBy != null) result.validatedBy = validatedBy;
    if (validatedAt != null) result.validatedAt = validatedAt;
    if (validationNote != null) result.validationNote = validationNote;
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
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'observationId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'code', subBuilder: Coding.create)
    ..aOM<Quantity>(5, _omitFieldNames ? '' : 'value',
        subBuilder: Quantity.create)
    ..aOS(6, _omitFieldNames ? '' : 'textValue')
    ..aOM<Coding>(7, _omitFieldNames ? '' : 'codedValue',
        subBuilder: Coding.create)
    ..aD(8, _omitFieldNames ? '' : 'referenceLow')
    ..aD(9, _omitFieldNames ? '' : 'referenceHigh')
    ..aOB(10, _omitFieldNames ? '' : 'hasReferenceRange')
    ..aOS(11, _omitFieldNames ? '' : 'referenceText')
    ..aE<Interpretation>(12, _omitFieldNames ? '' : 'interpretation',
        enumValues: Interpretation.values)
    ..aOS(13, _omitFieldNames ? '' : 'interpretationSource')
    ..aE<ObservationStatus>(14, _omitFieldNames ? '' : 'status',
        enumValues: ObservationStatus.values)
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'effectiveAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'issuedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(17, _omitFieldNames ? '' : 'performerId')
    ..aOS(18, _omitFieldNames ? '' : 'deviceId')
    ..aOS(19, _omitFieldNames ? '' : 'sourceSystem')
    ..aOS(20, _omitFieldNames ? '' : 'note')
    ..aOS(21, _omitFieldNames ? '' : 'amendsId')
    ..aOS(22, _omitFieldNames ? '' : 'recordedBy')
    ..aOM<$0.Timestamp>(23, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aE<ObservationSource>(24, _omitFieldNames ? '' : 'source',
        enumValues: ObservationSource.values)
    ..aE<ValidationState>(25, _omitFieldNames ? '' : 'validation',
        enumValues: ValidationState.values)
    ..aOM<DeviceSource>(26, _omitFieldNames ? '' : 'device',
        subBuilder: DeviceSource.create)
    ..aOS(27, _omitFieldNames ? '' : 'validatedBy')
    ..aOM<$0.Timestamp>(28, _omitFieldNames ? '' : 'validatedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(29, _omitFieldNames ? '' : 'validationNote')
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
  Coding get code => $_getN(3);
  @$pb.TagNumber(4)
  set code(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearCode() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureCode() => $_ensure(3);

  /// Exactly one carries the result: a blood pressure is a quantity, a blood
  /// group is a code, and a microbiology comment is text.
  @$pb.TagNumber(5)
  Quantity get value => $_getN(4);
  @$pb.TagNumber(5)
  set value(Quantity value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearValue() => $_clearField(5);
  @$pb.TagNumber(5)
  Quantity ensureValue() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get textValue => $_getSZ(5);
  @$pb.TagNumber(6)
  set textValue($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTextValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearTextValue() => $_clearField(6);

  @$pb.TagNumber(7)
  Coding get codedValue => $_getN(6);
  @$pb.TagNumber(7)
  set codedValue(Coding value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCodedValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearCodedValue() => $_clearField(7);
  @$pb.TagNumber(7)
  Coding ensureCodedValue() => $_ensure(6);

  /// The range the source used, stored rather than looked up: applying today's
  /// range to a five-year-old result would reinterpret history.
  @$pb.TagNumber(8)
  $core.double get referenceLow => $_getN(7);
  @$pb.TagNumber(8)
  set referenceLow($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReferenceLow() => $_has(7);
  @$pb.TagNumber(8)
  void clearReferenceLow() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get referenceHigh => $_getN(8);
  @$pb.TagNumber(9)
  set referenceHigh($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReferenceHigh() => $_has(8);
  @$pb.TagNumber(9)
  void clearReferenceHigh() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get hasReferenceRange => $_getBF(9);
  @$pb.TagNumber(10)
  set hasReferenceRange($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasHasReferenceRange() => $_has(9);
  @$pb.TagNumber(10)
  void clearHasReferenceRange() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get referenceText => $_getSZ(10);
  @$pb.TagNumber(11)
  set referenceText($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasReferenceText() => $_has(10);
  @$pb.TagNumber(11)
  void clearReferenceText() => $_clearField(11);

  /// Supplied by the authoritative service, never derived (SRS-CLN-011).
  @$pb.TagNumber(12)
  Interpretation get interpretation => $_getN(11);
  @$pb.TagNumber(12)
  set interpretation(Interpretation value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasInterpretation() => $_has(11);
  @$pb.TagNumber(12)
  void clearInterpretation() => $_clearField(12);

  /// Flag provenance. A chart showing "critical" with no source cannot answer
  /// "who decided this".
  @$pb.TagNumber(13)
  $core.String get interpretationSource => $_getSZ(12);
  @$pb.TagNumber(13)
  set interpretationSource($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasInterpretationSource() => $_has(12);
  @$pb.TagNumber(13)
  void clearInterpretationSource() => $_clearField(13);

  @$pb.TagNumber(14)
  ObservationStatus get status => $_getN(13);
  @$pb.TagNumber(14)
  set status(ObservationStatus value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasStatus() => $_has(13);
  @$pb.TagNumber(14)
  void clearStatus() => $_clearField(14);

  /// When the observation was true of the patient — when blood was drawn, not
  /// when the analyser finished.
  @$pb.TagNumber(15)
  $0.Timestamp get effectiveAt => $_getN(14);
  @$pb.TagNumber(15)
  set effectiveAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasEffectiveAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearEffectiveAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureEffectiveAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $0.Timestamp get issuedAt => $_getN(15);
  @$pb.TagNumber(16)
  set issuedAt($0.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasIssuedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearIssuedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureIssuedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.String get performerId => $_getSZ(16);
  @$pb.TagNumber(17)
  set performerId($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasPerformerId() => $_has(16);
  @$pb.TagNumber(17)
  void clearPerformerId() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get deviceId => $_getSZ(17);
  @$pb.TagNumber(18)
  set deviceId($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasDeviceId() => $_has(17);
  @$pb.TagNumber(18)
  void clearDeviceId() => $_clearField(18);

  /// Empty for something recorded here; set for anything imported
  /// (SRS-CLN-010).
  @$pb.TagNumber(19)
  $core.String get sourceSystem => $_getSZ(18);
  @$pb.TagNumber(19)
  set sourceSystem($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasSourceSystem() => $_has(18);
  @$pb.TagNumber(19)
  void clearSourceSystem() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get note => $_getSZ(19);
  @$pb.TagNumber(20)
  set note($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasNote() => $_has(19);
  @$pb.TagNumber(20)
  void clearNote() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get amendsId => $_getSZ(20);
  @$pb.TagNumber(21)
  set amendsId($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasAmendsId() => $_has(20);
  @$pb.TagNumber(21)
  void clearAmendsId() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.String get recordedBy => $_getSZ(21);
  @$pb.TagNumber(22)
  set recordedBy($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasRecordedBy() => $_has(21);
  @$pb.TagNumber(22)
  void clearRecordedBy() => $_clearField(22);

  @$pb.TagNumber(23)
  $0.Timestamp get recordedAt => $_getN(22);
  @$pb.TagNumber(23)
  set recordedAt($0.Timestamp value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasRecordedAt() => $_has(22);
  @$pb.TagNumber(23)
  void clearRecordedAt() => $_clearField(23);
  @$pb.TagNumber(23)
  $0.Timestamp ensureRecordedAt() => $_ensure(22);

  /// Where the reading came from and whether a human has accepted it into the
  /// chart (SRS-ICU-003). A client that showed a provisional monitor value the
  /// same way it shows a typed measurement would undo the distinction these
  /// fields exist to carry, so both travel and neither is optional.
  @$pb.TagNumber(24)
  ObservationSource get source => $_getN(23);
  @$pb.TagNumber(24)
  set source(ObservationSource value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasSource() => $_has(23);
  @$pb.TagNumber(24)
  void clearSource() => $_clearField(24);

  @$pb.TagNumber(25)
  ValidationState get validation => $_getN(24);
  @$pb.TagNumber(25)
  set validation(ValidationState value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasValidation() => $_has(24);
  @$pb.TagNumber(25)
  void clearValidation() => $_clearField(25);

  @$pb.TagNumber(26)
  DeviceSource get device => $_getN(25);
  @$pb.TagNumber(26)
  set device(DeviceSource value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasDevice() => $_has(25);
  @$pb.TagNumber(26)
  void clearDevice() => $_clearField(26);
  @$pb.TagNumber(26)
  DeviceSource ensureDevice() => $_ensure(25);

  @$pb.TagNumber(27)
  $core.String get validatedBy => $_getSZ(26);
  @$pb.TagNumber(27)
  set validatedBy($core.String value) => $_setString(26, value);
  @$pb.TagNumber(27)
  $core.bool hasValidatedBy() => $_has(26);
  @$pb.TagNumber(27)
  void clearValidatedBy() => $_clearField(27);

  @$pb.TagNumber(28)
  $0.Timestamp get validatedAt => $_getN(27);
  @$pb.TagNumber(28)
  set validatedAt($0.Timestamp value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasValidatedAt() => $_has(27);
  @$pb.TagNumber(28)
  void clearValidatedAt() => $_clearField(28);
  @$pb.TagNumber(28)
  $0.Timestamp ensureValidatedAt() => $_ensure(27);

  /// Why a reading was rejected. A run of rejections with reasons is how a
  /// failing probe is found.
  @$pb.TagNumber(29)
  $core.String get validationNote => $_getSZ(28);
  @$pb.TagNumber(29)
  set validationNote($core.String value) => $_setString(28, value);
  @$pb.TagNumber(29)
  $core.bool hasValidationNote() => $_has(28);
  @$pb.TagNumber(29)
  void clearValidationNote() => $_clearField(29);
}

/// Device identity and quality metadata (SRS-ICU-003).
class DeviceSource extends $pb.GeneratedMessage {
  factory DeviceSource({
    $core.String? deviceId,
    $core.String? channel,
    $core.String? quality,
    $0.Timestamp? observedAt,
    $0.Timestamp? receivedAt,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (channel != null) result.channel = channel;
    if (quality != null) result.quality = quality;
    if (observedAt != null) result.observedAt = observedAt;
    if (receivedAt != null) result.receivedAt = receivedAt;
    return result;
  }

  DeviceSource._();

  factory DeviceSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'channel')
    ..aOS(3, _omitFieldNames ? '' : 'quality')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'receivedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSource copyWith(void Function(DeviceSource) updates) =>
      super.copyWith((message) => updates(message as DeviceSource))
          as DeviceSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceSource create() => DeviceSource._();
  @$core.override
  DeviceSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceSource>(create);
  static DeviceSource? _defaultInstance;

  /// Required for a device reading: a run of implausible values almost always
  /// means one device, and a reading that cannot name its own is one nobody can
  /// trace to the probe that caused it.
  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  /// Which parameter of the device this came from — "SpO2", "ART". A monitor
  /// produces several streams and they fail independently.
  @$pb.TagNumber(2)
  $core.String get channel => $_getSZ(1);
  @$pb.TagNumber(2)
  set channel($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChannel() => $_has(1);
  @$pb.TagNumber(2)
  void clearChannel() => $_clearField(2);

  /// What the device said about its own signal, verbatim: "good", "artefact",
  /// "searching". Not normalised, because every vendor has its own vocabulary
  /// and flattening it would lose the difference between "the device said
  /// nothing" and "the device said a word we do not know".
  @$pb.TagNumber(3)
  $core.String get quality => $_getSZ(2);
  @$pb.TagNumber(3)
  set quality($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuality() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuality() => $_clearField(3);

  /// The device's own clock, and ours. Two fields because the gap between them
  /// is what makes a feed stale, and one timestamp cannot show it.
  @$pb.TagNumber(4)
  $0.Timestamp get observedAt => $_getN(3);
  @$pb.TagNumber(4)
  set observedAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasObservedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearObservedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureObservedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get receivedAt => $_getN(4);
  @$pb.TagNumber(5)
  set receivedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReceivedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearReceivedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureReceivedAt() => $_ensure(4);
}

class IngestDeviceReadingRequest extends $pb.GeneratedMessage {
  factory IngestDeviceReadingRequest({
    $core.String? patientId,
    $core.String? encounterId,
    Coding? code,
    Quantity? value,
    DeviceSource? device,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (code != null) result.code = code;
    if (value != null) result.value = value;
    if (device != null) result.device = device;
    return result;
  }

  IngestDeviceReadingRequest._();

  factory IngestDeviceReadingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IngestDeviceReadingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IngestDeviceReadingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(3, _omitFieldNames ? '' : 'code', subBuilder: Coding.create)
    ..aOM<Quantity>(4, _omitFieldNames ? '' : 'value',
        subBuilder: Quantity.create)
    ..aOM<DeviceSource>(5, _omitFieldNames ? '' : 'device',
        subBuilder: DeviceSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngestDeviceReadingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngestDeviceReadingRequest copyWith(
          void Function(IngestDeviceReadingRequest) updates) =>
      super.copyWith(
              (message) => updates(message as IngestDeviceReadingRequest))
          as IngestDeviceReadingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IngestDeviceReadingRequest create() => IngestDeviceReadingRequest._();
  @$core.override
  IngestDeviceReadingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IngestDeviceReadingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IngestDeviceReadingRequest>(create);
  static IngestDeviceReadingRequest? _defaultInstance;

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
  Coding get code => $_getN(2);
  @$pb.TagNumber(3)
  set code(Coding value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);
  @$pb.TagNumber(3)
  Coding ensureCode() => $_ensure(2);

  @$pb.TagNumber(4)
  Quantity get value => $_getN(3);
  @$pb.TagNumber(4)
  set value(Quantity value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => $_clearField(4);
  @$pb.TagNumber(4)
  Quantity ensureValue() => $_ensure(3);

  @$pb.TagNumber(5)
  DeviceSource get device => $_getN(4);
  @$pb.TagNumber(5)
  set device(DeviceSource value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDevice() => $_has(4);
  @$pb.TagNumber(5)
  void clearDevice() => $_clearField(5);
  @$pb.TagNumber(5)
  DeviceSource ensureDevice() => $_ensure(4);
}

class IngestDeviceReadingResponse extends $pb.GeneratedMessage {
  factory IngestDeviceReadingResponse({
    Observation? observation,
  }) {
    final result = create();
    if (observation != null) result.observation = observation;
    return result;
  }

  IngestDeviceReadingResponse._();

  factory IngestDeviceReadingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IngestDeviceReadingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IngestDeviceReadingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Observation>(1, _omitFieldNames ? '' : 'observation',
        subBuilder: Observation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngestDeviceReadingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngestDeviceReadingResponse copyWith(
          void Function(IngestDeviceReadingResponse) updates) =>
      super.copyWith(
              (message) => updates(message as IngestDeviceReadingResponse))
          as IngestDeviceReadingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IngestDeviceReadingResponse create() =>
      IngestDeviceReadingResponse._();
  @$core.override
  IngestDeviceReadingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IngestDeviceReadingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IngestDeviceReadingResponse>(create);
  static IngestDeviceReadingResponse? _defaultInstance;

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

class DecideReadingRequest extends $pb.GeneratedMessage {
  factory DecideReadingRequest({
    $core.String? observationId,
    $core.bool? accept,
    $core.String? reason,
  }) {
    final result = create();
    if (observationId != null) result.observationId = observationId;
    if (accept != null) result.accept = accept;
    if (reason != null) result.reason = reason;
    return result;
  }

  DecideReadingRequest._();

  factory DecideReadingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DecideReadingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DecideReadingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'observationId')
    ..aOB(2, _omitFieldNames ? '' : 'accept')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecideReadingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecideReadingRequest copyWith(void Function(DecideReadingRequest) updates) =>
      super.copyWith((message) => updates(message as DecideReadingRequest))
          as DecideReadingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DecideReadingRequest create() => DecideReadingRequest._();
  @$core.override
  DecideReadingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DecideReadingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DecideReadingRequest>(create);
  static DecideReadingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get observationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set observationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasObservationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearObservationId() => $_clearField(1);

  /// True to confirm the reading into the chart, false to mark it an artefact.
  @$pb.TagNumber(2)
  $core.bool get accept => $_getBF(1);
  @$pb.TagNumber(2)
  set accept($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccept() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccept() => $_clearField(2);

  /// Required on a rejection. A column of the word "artefact" with no reasons
  /// is not how a failing probe gets found.
  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class DecideReadingResponse extends $pb.GeneratedMessage {
  factory DecideReadingResponse({
    Observation? observation,
  }) {
    final result = create();
    if (observation != null) result.observation = observation;
    return result;
  }

  DecideReadingResponse._();

  factory DecideReadingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DecideReadingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DecideReadingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Observation>(1, _omitFieldNames ? '' : 'observation',
        subBuilder: Observation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecideReadingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecideReadingResponse copyWith(
          void Function(DecideReadingResponse) updates) =>
      super.copyWith((message) => updates(message as DecideReadingResponse))
          as DecideReadingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DecideReadingResponse create() => DecideReadingResponse._();
  @$core.override
  DecideReadingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DecideReadingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DecideReadingResponse>(create);
  static DecideReadingResponse? _defaultInstance;

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

class ListProvisionalReadingsRequest extends $pb.GeneratedMessage {
  factory ListProvisionalReadingsRequest({
    $core.String? patientId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListProvisionalReadingsRequest._();

  factory ListProvisionalReadingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProvisionalReadingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProvisionalReadingsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProvisionalReadingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProvisionalReadingsRequest copyWith(
          void Function(ListProvisionalReadingsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListProvisionalReadingsRequest))
          as ListProvisionalReadingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProvisionalReadingsRequest create() =>
      ListProvisionalReadingsRequest._();
  @$core.override
  ListProvisionalReadingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListProvisionalReadingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProvisionalReadingsRequest>(create);
  static ListProvisionalReadingsRequest? _defaultInstance;

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

class ListProvisionalReadingsResponse extends $pb.GeneratedMessage {
  factory ListProvisionalReadingsResponse({
    $core.Iterable<Observation>? observations,
  }) {
    final result = create();
    if (observations != null) result.observations.addAll(observations);
    return result;
  }

  ListProvisionalReadingsResponse._();

  factory ListProvisionalReadingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProvisionalReadingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProvisionalReadingsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<Observation>(1, _omitFieldNames ? '' : 'observations',
        subBuilder: Observation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProvisionalReadingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProvisionalReadingsResponse copyWith(
          void Function(ListProvisionalReadingsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListProvisionalReadingsResponse))
          as ListProvisionalReadingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProvisionalReadingsResponse create() =>
      ListProvisionalReadingsResponse._();
  @$core.override
  ListProvisionalReadingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListProvisionalReadingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProvisionalReadingsResponse>(
          create);
  static ListProvisionalReadingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Observation> get observations => $_getList(0);
}

class CriticalAcknowledgement extends $pb.GeneratedMessage {
  factory CriticalAcknowledgement({
    $core.String? acknowledgementId,
    $core.String? observationId,
    $core.String? patientId,
    $core.String? acknowledgedBy,
    $0.Timestamp? acknowledgedAt,
    $core.String? action,
    $0.Timestamp? notifiedAt,
    $fixnum.Int64? delaySeconds,
  }) {
    final result = create();
    if (acknowledgementId != null) result.acknowledgementId = acknowledgementId;
    if (observationId != null) result.observationId = observationId;
    if (patientId != null) result.patientId = patientId;
    if (acknowledgedBy != null) result.acknowledgedBy = acknowledgedBy;
    if (acknowledgedAt != null) result.acknowledgedAt = acknowledgedAt;
    if (action != null) result.action = action;
    if (notifiedAt != null) result.notifiedAt = notifiedAt;
    if (delaySeconds != null) result.delaySeconds = delaySeconds;
    return result;
  }

  CriticalAcknowledgement._();

  factory CriticalAcknowledgement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CriticalAcknowledgement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CriticalAcknowledgement',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'acknowledgementId')
    ..aOS(2, _omitFieldNames ? '' : 'observationId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'acknowledgedBy')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'acknowledgedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'action')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'notifiedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(8, _omitFieldNames ? '' : 'delaySeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CriticalAcknowledgement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CriticalAcknowledgement copyWith(
          void Function(CriticalAcknowledgement) updates) =>
      super.copyWith((message) => updates(message as CriticalAcknowledgement))
          as CriticalAcknowledgement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CriticalAcknowledgement create() => CriticalAcknowledgement._();
  @$core.override
  CriticalAcknowledgement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CriticalAcknowledgement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CriticalAcknowledgement>(create);
  static CriticalAcknowledgement? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get acknowledgementId => $_getSZ(0);
  @$pb.TagNumber(1)
  set acknowledgementId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAcknowledgementId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAcknowledgementId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get observationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set observationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasObservationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearObservationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get patientId => $_getSZ(2);
  @$pb.TagNumber(3)
  set patientId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPatientId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatientId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get acknowledgedBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set acknowledgedBy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAcknowledgedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearAcknowledgedBy() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get acknowledgedAt => $_getN(4);
  @$pb.TagNumber(5)
  set acknowledgedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAcknowledgedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearAcknowledgedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureAcknowledgedAt() => $_ensure(4);

  /// What the clinician did. Mandatory: "seen" is not a clinical response to a
  /// potassium of 6.9.
  @$pb.TagNumber(6)
  $core.String get action => $_getSZ(5);
  @$pb.TagNumber(6)
  set action($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAction() => $_has(5);
  @$pb.TagNumber(6)
  void clearAction() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get notifiedAt => $_getN(6);
  @$pb.TagNumber(7)
  set notifiedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasNotifiedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearNotifiedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureNotifiedAt() => $_ensure(6);

  /// The gap between notification and acknowledgement, which is the number a
  /// safety review wants.
  @$pb.TagNumber(8)
  $fixnum.Int64 get delaySeconds => $_getI64(7);
  @$pb.TagNumber(8)
  set delaySeconds($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDelaySeconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearDelaySeconds() => $_clearField(8);
}

class Performer extends $pb.GeneratedMessage {
  factory Performer({
    $core.String? subjectId,
    $core.String? role,
  }) {
    final result = create();
    if (subjectId != null) result.subjectId = subjectId;
    if (role != null) result.role = role;
    return result;
  }

  Performer._();

  factory Performer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Performer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Performer',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'subjectId')
    ..aOS(2, _omitFieldNames ? '' : 'role')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Performer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Performer copyWith(void Function(Performer) updates) =>
      super.copyWith((message) => updates(message as Performer)) as Performer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Performer create() => Performer._();
  @$core.override
  Performer createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Performer getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Performer>(create);
  static Performer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get subjectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set subjectId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSubjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get role => $_getSZ(1);
  @$pb.TagNumber(2)
  set role($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);
}

class Procedure extends $pb.GeneratedMessage {
  factory Procedure({
    $core.String? procedureId,
    $core.String? patientId,
    $core.String? encounterId,
    Coding? code,
    ProcedureStatus? status,
    Coding? indication,
    $core.Iterable<Performer>? performers,
    Coding? bodySite,
    Laterality? laterality,
    $core.String? outcome,
    $core.Iterable<Coding>? complications,
    $core.Iterable<$core.String>? orderIds,
    $core.Iterable<$core.String>? deviceIds,
    $core.Iterable<$core.String>? specimenIds,
    $0.Timestamp? performedStart,
    $0.Timestamp? performedEnd,
    $core.String? note,
    $core.String? recordedBy,
    $0.Timestamp? recordedAt,
  }) {
    final result = create();
    if (procedureId != null) result.procedureId = procedureId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (code != null) result.code = code;
    if (status != null) result.status = status;
    if (indication != null) result.indication = indication;
    if (performers != null) result.performers.addAll(performers);
    if (bodySite != null) result.bodySite = bodySite;
    if (laterality != null) result.laterality = laterality;
    if (outcome != null) result.outcome = outcome;
    if (complications != null) result.complications.addAll(complications);
    if (orderIds != null) result.orderIds.addAll(orderIds);
    if (deviceIds != null) result.deviceIds.addAll(deviceIds);
    if (specimenIds != null) result.specimenIds.addAll(specimenIds);
    if (performedStart != null) result.performedStart = performedStart;
    if (performedEnd != null) result.performedEnd = performedEnd;
    if (note != null) result.note = note;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (recordedAt != null) result.recordedAt = recordedAt;
    return result;
  }

  Procedure._();

  factory Procedure.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Procedure.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Procedure',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'procedureId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'code', subBuilder: Coding.create)
    ..aE<ProcedureStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: ProcedureStatus.values)
    ..aOM<Coding>(6, _omitFieldNames ? '' : 'indication',
        subBuilder: Coding.create)
    ..pPM<Performer>(7, _omitFieldNames ? '' : 'performers',
        subBuilder: Performer.create)
    ..aOM<Coding>(8, _omitFieldNames ? '' : 'bodySite',
        subBuilder: Coding.create)
    ..aE<Laterality>(9, _omitFieldNames ? '' : 'laterality',
        enumValues: Laterality.values)
    ..aOS(10, _omitFieldNames ? '' : 'outcome')
    ..pPM<Coding>(11, _omitFieldNames ? '' : 'complications',
        subBuilder: Coding.create)
    ..pPS(12, _omitFieldNames ? '' : 'orderIds')
    ..pPS(13, _omitFieldNames ? '' : 'deviceIds')
    ..pPS(14, _omitFieldNames ? '' : 'specimenIds')
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'performedStart',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'performedEnd',
        subBuilder: $0.Timestamp.create)
    ..aOS(17, _omitFieldNames ? '' : 'note')
    ..aOS(18, _omitFieldNames ? '' : 'recordedBy')
    ..aOM<$0.Timestamp>(19, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Procedure clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Procedure copyWith(void Function(Procedure) updates) =>
      super.copyWith((message) => updates(message as Procedure)) as Procedure;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Procedure create() => Procedure._();
  @$core.override
  Procedure createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Procedure getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Procedure>(create);
  static Procedure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get procedureId => $_getSZ(0);
  @$pb.TagNumber(1)
  set procedureId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProcedureId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProcedureId() => $_clearField(1);

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
  Coding get code => $_getN(3);
  @$pb.TagNumber(4)
  set code(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearCode() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureCode() => $_ensure(3);

  @$pb.TagNumber(5)
  ProcedureStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(ProcedureStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  Coding get indication => $_getN(5);
  @$pb.TagNumber(6)
  set indication(Coding value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasIndication() => $_has(5);
  @$pb.TagNumber(6)
  void clearIndication() => $_clearField(6);
  @$pb.TagNumber(6)
  Coding ensureIndication() => $_ensure(5);

  @$pb.TagNumber(7)
  $pb.PbList<Performer> get performers => $_getList(6);

  @$pb.TagNumber(8)
  Coding get bodySite => $_getN(7);
  @$pb.TagNumber(8)
  set bodySite(Coding value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasBodySite() => $_has(7);
  @$pb.TagNumber(8)
  void clearBodySite() => $_clearField(8);
  @$pb.TagNumber(8)
  Coding ensureBodySite() => $_ensure(7);

  @$pb.TagNumber(9)
  Laterality get laterality => $_getN(8);
  @$pb.TagNumber(9)
  set laterality(Laterality value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasLaterality() => $_has(8);
  @$pb.TagNumber(9)
  void clearLaterality() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get outcome => $_getSZ(9);
  @$pb.TagNumber(10)
  set outcome($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasOutcome() => $_has(9);
  @$pb.TagNumber(10)
  void clearOutcome() => $_clearField(10);

  /// Coded so they can be counted. A complication in free text is a
  /// complication that never reaches a quality report.
  @$pb.TagNumber(11)
  $pb.PbList<Coding> get complications => $_getList(10);

  /// References rather than copies: a copied implant record is the one that
  /// stays wrong after a recall.
  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get orderIds => $_getList(11);

  @$pb.TagNumber(13)
  $pb.PbList<$core.String> get deviceIds => $_getList(12);

  @$pb.TagNumber(14)
  $pb.PbList<$core.String> get specimenIds => $_getList(13);

  @$pb.TagNumber(15)
  $0.Timestamp get performedStart => $_getN(14);
  @$pb.TagNumber(15)
  set performedStart($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasPerformedStart() => $_has(14);
  @$pb.TagNumber(15)
  void clearPerformedStart() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensurePerformedStart() => $_ensure(14);

  @$pb.TagNumber(16)
  $0.Timestamp get performedEnd => $_getN(15);
  @$pb.TagNumber(16)
  set performedEnd($0.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasPerformedEnd() => $_has(15);
  @$pb.TagNumber(16)
  void clearPerformedEnd() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensurePerformedEnd() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.String get note => $_getSZ(16);
  @$pb.TagNumber(17)
  set note($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasNote() => $_has(16);
  @$pb.TagNumber(17)
  void clearNote() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get recordedBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set recordedBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasRecordedBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearRecordedBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $0.Timestamp get recordedAt => $_getN(18);
  @$pb.TagNumber(19)
  set recordedAt($0.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasRecordedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearRecordedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Timestamp ensureRecordedAt() => $_ensure(18);
}

class Goal extends $pb.GeneratedMessage {
  factory Goal({
    $core.String? goalId,
    $core.String? description,
    GoalStatus? status,
    $0.Timestamp? targetDate,
    $0.Timestamp? achievedAt,
  }) {
    final result = create();
    if (goalId != null) result.goalId = goalId;
    if (description != null) result.description = description;
    if (status != null) result.status = status;
    if (targetDate != null) result.targetDate = targetDate;
    if (achievedAt != null) result.achievedAt = achievedAt;
    return result;
  }

  Goal._();

  factory Goal.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Goal.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Goal',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'goalId')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aE<GoalStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: GoalStatus.values)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'targetDate',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'achievedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Goal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Goal copyWith(void Function(Goal) updates) =>
      super.copyWith((message) => updates(message as Goal)) as Goal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Goal create() => Goal._();
  @$core.override
  Goal createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Goal getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Goal>(create);
  static Goal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get goalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set goalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGoalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGoalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  GoalStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(GoalStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get targetDate => $_getN(3);
  @$pb.TagNumber(4)
  set targetDate($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTargetDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetDate() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureTargetDate() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get achievedAt => $_getN(4);
  @$pb.TagNumber(5)
  set achievedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAchievedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearAchievedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureAchievedAt() => $_ensure(4);
}

class Activity extends $pb.GeneratedMessage {
  factory Activity({
    $core.String? activityId,
    $core.String? description,
    $core.String? ownerId,
    ActivityStatus? status,
    $0.Timestamp? scheduledFor,
    $core.String? taskId,
  }) {
    final result = create();
    if (activityId != null) result.activityId = activityId;
    if (description != null) result.description = description;
    if (ownerId != null) result.ownerId = ownerId;
    if (status != null) result.status = status;
    if (scheduledFor != null) result.scheduledFor = scheduledFor;
    if (taskId != null) result.taskId = taskId;
    return result;
  }

  Activity._();

  factory Activity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Activity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Activity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'activityId')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aOS(3, _omitFieldNames ? '' : 'ownerId')
    ..aE<ActivityStatus>(4, _omitFieldNames ? '' : 'status',
        enumValues: ActivityStatus.values)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'scheduledFor',
        subBuilder: $0.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'taskId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Activity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Activity copyWith(void Function(Activity) updates) =>
      super.copyWith((message) => updates(message as Activity)) as Activity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Activity create() => Activity._();
  @$core.override
  Activity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Activity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Activity>(create);
  static Activity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get activityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set activityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActivityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearActivityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  /// A plan whose activities have no owner is a list of things everybody
  /// assumes somebody else is doing.
  @$pb.TagNumber(3)
  $core.String get ownerId => $_getSZ(2);
  @$pb.TagNumber(3)
  set ownerId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOwnerId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOwnerId() => $_clearField(3);

  @$pb.TagNumber(4)
  ActivityStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(ActivityStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get scheduledFor => $_getN(4);
  @$pb.TagNumber(5)
  set scheduledFor($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasScheduledFor() => $_has(4);
  @$pb.TagNumber(5)
  void clearScheduledFor() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureScheduledFor() => $_ensure(4);

  /// Links to the task that carries it out, so the worklist and the plan do not
  /// drift (SRS-NUR-002).
  @$pb.TagNumber(6)
  $core.String get taskId => $_getSZ(5);
  @$pb.TagNumber(6)
  set taskId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTaskId() => $_has(5);
  @$pb.TagNumber(6)
  void clearTaskId() => $_clearField(6);
}

class CarePlan extends $pb.GeneratedMessage {
  factory CarePlan({
    $core.String? carePlanId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? title,
    CarePlanStatus? status,
    $core.Iterable<$core.String>? problemIds,
    $core.Iterable<Goal>? goals,
    $core.Iterable<Activity>? activities,
    $core.String? ownerId,
    $0.Timestamp? startsAt,
    $0.Timestamp? endsAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (carePlanId != null) result.carePlanId = carePlanId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (title != null) result.title = title;
    if (status != null) result.status = status;
    if (problemIds != null) result.problemIds.addAll(problemIds);
    if (goals != null) result.goals.addAll(goals);
    if (activities != null) result.activities.addAll(activities);
    if (ownerId != null) result.ownerId = ownerId;
    if (startsAt != null) result.startsAt = startsAt;
    if (endsAt != null) result.endsAt = endsAt;
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
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'carePlanId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aE<CarePlanStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: CarePlanStatus.values)
    ..pPS(6, _omitFieldNames ? '' : 'problemIds')
    ..pPM<Goal>(7, _omitFieldNames ? '' : 'goals', subBuilder: Goal.create)
    ..pPM<Activity>(8, _omitFieldNames ? '' : 'activities',
        subBuilder: Activity.create)
    ..aOS(9, _omitFieldNames ? '' : 'ownerId')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'endsAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(12, _omitFieldNames ? '' : 'version')
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
  $core.String get carePlanId => $_getSZ(0);
  @$pb.TagNumber(1)
  set carePlanId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCarePlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCarePlanId() => $_clearField(1);

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
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  CarePlanStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(CarePlanStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  /// References rather than copies: a plan holding its own copy of a diagnosis
  /// is the copy that stays wrong after the diagnosis changes.
  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get problemIds => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<Goal> get goals => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<Activity> get activities => $_getList(7);

  @$pb.TagNumber(9)
  $core.String get ownerId => $_getSZ(8);
  @$pb.TagNumber(9)
  set ownerId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOwnerId() => $_has(8);
  @$pb.TagNumber(9)
  void clearOwnerId() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get startsAt => $_getN(9);
  @$pb.TagNumber(10)
  set startsAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStartsAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearStartsAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureStartsAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $0.Timestamp get endsAt => $_getN(10);
  @$pb.TagNumber(11)
  set endsAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasEndsAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearEndsAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureEndsAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $fixnum.Int64 get version => $_getI64(11);
  @$pb.TagNumber(12)
  set version($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasVersion() => $_has(11);
  @$pb.TagNumber(12)
  void clearVersion() => $_clearField(12);
}

/// Where an imported record came from (SRS-CLN-010).
class Provenance extends $pb.GeneratedMessage {
  factory Provenance({
    $core.String? provenanceId,
    $core.String? recordType,
    $core.String? recordId,
    $core.String? sourceOrganization,
    $core.String? sourceSystem,
    $core.String? sourceRecordId,
    $0.Timestamp? ingestedAt,
    $0.Timestamp? authoredAt,
    $core.String? authoredBy,
    $core.String? assertion,
  }) {
    final result = create();
    if (provenanceId != null) result.provenanceId = provenanceId;
    if (recordType != null) result.recordType = recordType;
    if (recordId != null) result.recordId = recordId;
    if (sourceOrganization != null)
      result.sourceOrganization = sourceOrganization;
    if (sourceSystem != null) result.sourceSystem = sourceSystem;
    if (sourceRecordId != null) result.sourceRecordId = sourceRecordId;
    if (ingestedAt != null) result.ingestedAt = ingestedAt;
    if (authoredAt != null) result.authoredAt = authoredAt;
    if (authoredBy != null) result.authoredBy = authoredBy;
    if (assertion != null) result.assertion = assertion;
    return result;
  }

  Provenance._();

  factory Provenance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Provenance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Provenance',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'provenanceId')
    ..aOS(2, _omitFieldNames ? '' : 'recordType')
    ..aOS(3, _omitFieldNames ? '' : 'recordId')
    ..aOS(4, _omitFieldNames ? '' : 'sourceOrganization')
    ..aOS(5, _omitFieldNames ? '' : 'sourceSystem')
    ..aOS(6, _omitFieldNames ? '' : 'sourceRecordId')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'ingestedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'authoredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'authoredBy')
    ..aOS(10, _omitFieldNames ? '' : 'assertion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Provenance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Provenance copyWith(void Function(Provenance) updates) =>
      super.copyWith((message) => updates(message as Provenance)) as Provenance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Provenance create() => Provenance._();
  @$core.override
  Provenance createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Provenance getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Provenance>(create);
  static Provenance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get provenanceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set provenanceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProvenanceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProvenanceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recordType => $_getSZ(1);
  @$pb.TagNumber(2)
  set recordType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordType() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get recordId => $_getSZ(2);
  @$pb.TagNumber(3)
  set recordId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecordId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecordId() => $_clearField(3);

  /// Without the organisation this says "it came from outside", which tells a
  /// clinician nothing they can weigh.
  @$pb.TagNumber(4)
  $core.String get sourceOrganization => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourceOrganization($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceOrganization() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceOrganization() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sourceSystem => $_getSZ(4);
  @$pb.TagNumber(5)
  set sourceSystem($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSourceSystem() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourceSystem() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get sourceRecordId => $_getSZ(5);
  @$pb.TagNumber(6)
  set sourceRecordId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSourceRecordId() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceRecordId() => $_clearField(6);

  /// When it arrived here, distinct from when it was true of the patient.
  @$pb.TagNumber(7)
  $0.Timestamp get ingestedAt => $_getN(6);
  @$pb.TagNumber(7)
  set ingestedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasIngestedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearIngestedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureIngestedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get authoredAt => $_getN(7);
  @$pb.TagNumber(8)
  set authoredAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasAuthoredAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearAuthoredAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureAuthoredAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get authoredBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set authoredBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAuthoredBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearAuthoredBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get assertion => $_getSZ(9);
  @$pb.TagNumber(10)
  set assertion($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAssertion() => $_has(9);
  @$pb.TagNumber(10)
  void clearAssertion() => $_clearField(10);
}

class Attachment extends $pb.GeneratedMessage {
  factory Attachment({
    $core.String? attachmentId,
    $core.String? parentType,
    $core.String? parentId,
    $core.String? patientId,
    AttachmentKind? kind,
    $core.String? contentType,
    $core.String? storageKey,
    $fixnum.Int64? sizeBytes,
    $core.String? digest,
    $core.String? description,
    Confidentiality? confidentiality,
    $0.Timestamp? capturedAt,
    $core.String? sourceSystem,
    $core.String? uploadedBy,
    $0.Timestamp? uploadedAt,
  }) {
    final result = create();
    if (attachmentId != null) result.attachmentId = attachmentId;
    if (parentType != null) result.parentType = parentType;
    if (parentId != null) result.parentId = parentId;
    if (patientId != null) result.patientId = patientId;
    if (kind != null) result.kind = kind;
    if (contentType != null) result.contentType = contentType;
    if (storageKey != null) result.storageKey = storageKey;
    if (sizeBytes != null) result.sizeBytes = sizeBytes;
    if (digest != null) result.digest = digest;
    if (description != null) result.description = description;
    if (confidentiality != null) result.confidentiality = confidentiality;
    if (capturedAt != null) result.capturedAt = capturedAt;
    if (sourceSystem != null) result.sourceSystem = sourceSystem;
    if (uploadedBy != null) result.uploadedBy = uploadedBy;
    if (uploadedAt != null) result.uploadedAt = uploadedAt;
    return result;
  }

  Attachment._();

  factory Attachment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Attachment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Attachment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'attachmentId')
    ..aOS(2, _omitFieldNames ? '' : 'parentType')
    ..aOS(3, _omitFieldNames ? '' : 'parentId')
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aE<AttachmentKind>(5, _omitFieldNames ? '' : 'kind',
        enumValues: AttachmentKind.values)
    ..aOS(6, _omitFieldNames ? '' : 'contentType')
    ..aOS(7, _omitFieldNames ? '' : 'storageKey')
    ..aInt64(8, _omitFieldNames ? '' : 'sizeBytes')
    ..aOS(9, _omitFieldNames ? '' : 'digest')
    ..aOS(10, _omitFieldNames ? '' : 'description')
    ..aE<Confidentiality>(11, _omitFieldNames ? '' : 'confidentiality',
        enumValues: Confidentiality.values)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'capturedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'sourceSystem')
    ..aOS(14, _omitFieldNames ? '' : 'uploadedBy')
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'uploadedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Attachment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Attachment copyWith(void Function(Attachment) updates) =>
      super.copyWith((message) => updates(message as Attachment)) as Attachment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Attachment create() => Attachment._();
  @$core.override
  Attachment createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Attachment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Attachment>(create);
  static Attachment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get attachmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set attachmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAttachmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAttachmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get parentType => $_getSZ(1);
  @$pb.TagNumber(2)
  set parentType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasParentType() => $_has(1);
  @$pb.TagNumber(2)
  void clearParentType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get parentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set parentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasParentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearParentId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get patientId => $_getSZ(3);
  @$pb.TagNumber(4)
  set patientId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPatientId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPatientId() => $_clearField(4);

  @$pb.TagNumber(5)
  AttachmentKind get kind => $_getN(4);
  @$pb.TagNumber(5)
  set kind(AttachmentKind value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearKind() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get contentType => $_getSZ(5);
  @$pb.TagNumber(6)
  set contentType($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasContentType() => $_has(5);
  @$pb.TagNumber(6)
  void clearContentType() => $_clearField(6);

  /// Opaque: a key that encoded the patient would leak in every log line.
  @$pb.TagNumber(7)
  $core.String get storageKey => $_getSZ(6);
  @$pb.TagNumber(7)
  set storageKey($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStorageKey() => $_has(6);
  @$pb.TagNumber(7)
  void clearStorageKey() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get sizeBytes => $_getI64(7);
  @$pb.TagNumber(8)
  set sizeBytes($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSizeBytes() => $_has(7);
  @$pb.TagNumber(8)
  void clearSizeBytes() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get digest => $_getSZ(8);
  @$pb.TagNumber(9)
  set digest($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDigest() => $_has(8);
  @$pb.TagNumber(9)
  void clearDigest() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get description => $_getSZ(9);
  @$pb.TagNumber(10)
  set description($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDescription() => $_has(9);
  @$pb.TagNumber(10)
  void clearDescription() => $_clearField(10);

  /// The attachment's own class, which may be tighter than its parent's.
  @$pb.TagNumber(11)
  Confidentiality get confidentiality => $_getN(10);
  @$pb.TagNumber(11)
  set confidentiality(Confidentiality value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasConfidentiality() => $_has(10);
  @$pb.TagNumber(11)
  void clearConfidentiality() => $_clearField(11);

  /// When the image or recording was made, which is not when it was uploaded.
  @$pb.TagNumber(12)
  $0.Timestamp get capturedAt => $_getN(11);
  @$pb.TagNumber(12)
  set capturedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCapturedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCapturedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureCapturedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get sourceSystem => $_getSZ(12);
  @$pb.TagNumber(13)
  set sourceSystem($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasSourceSystem() => $_has(12);
  @$pb.TagNumber(13)
  void clearSourceSystem() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get uploadedBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set uploadedBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasUploadedBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearUploadedBy() => $_clearField(14);

  @$pb.TagNumber(15)
  $0.Timestamp get uploadedAt => $_getN(14);
  @$pb.TagNumber(15)
  set uploadedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasUploadedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearUploadedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureUploadedAt() => $_ensure(14);
}

class ClinicalConsent extends $pb.GeneratedMessage {
  factory ClinicalConsent({
    $core.String? consentId,
    $core.String? patientId,
    $core.String? encounterId,
    ConsentKind? kind,
    Coding? procedureCode,
    ConsentStatus? status,
    ConsentGiver? givenBy,
    $core.String? givenByName,
    $core.String? documentId,
    $core.String? witnessId,
    $0.Timestamp? validFrom,
    $0.Timestamp? validUntil,
    $core.String? note,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (consentId != null) result.consentId = consentId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (kind != null) result.kind = kind;
    if (procedureCode != null) result.procedureCode = procedureCode;
    if (status != null) result.status = status;
    if (givenBy != null) result.givenBy = givenBy;
    if (givenByName != null) result.givenByName = givenByName;
    if (documentId != null) result.documentId = documentId;
    if (witnessId != null) result.witnessId = witnessId;
    if (validFrom != null) result.validFrom = validFrom;
    if (validUntil != null) result.validUntil = validUntil;
    if (note != null) result.note = note;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  ClinicalConsent._();

  factory ClinicalConsent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClinicalConsent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClinicalConsent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'consentId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aE<ConsentKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: ConsentKind.values)
    ..aOM<Coding>(5, _omitFieldNames ? '' : 'procedureCode',
        subBuilder: Coding.create)
    ..aE<ConsentStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: ConsentStatus.values)
    ..aE<ConsentGiver>(7, _omitFieldNames ? '' : 'givenBy',
        enumValues: ConsentGiver.values)
    ..aOS(8, _omitFieldNames ? '' : 'givenByName')
    ..aOS(9, _omitFieldNames ? '' : 'documentId')
    ..aOS(10, _omitFieldNames ? '' : 'witnessId')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'validFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'validUntil',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'note')
    ..aOS(14, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClinicalConsent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClinicalConsent copyWith(void Function(ClinicalConsent) updates) =>
      super.copyWith((message) => updates(message as ClinicalConsent))
          as ClinicalConsent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClinicalConsent create() => ClinicalConsent._();
  @$core.override
  ClinicalConsent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClinicalConsent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClinicalConsent>(create);
  static ClinicalConsent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get consentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set consentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConsentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConsentId() => $_clearField(1);

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
  ConsentKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(ConsentKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  /// A consent for "a procedure" is not a consent for any procedure.
  @$pb.TagNumber(5)
  Coding get procedureCode => $_getN(4);
  @$pb.TagNumber(5)
  set procedureCode(Coding value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasProcedureCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearProcedureCode() => $_clearField(5);
  @$pb.TagNumber(5)
  Coding ensureProcedureCode() => $_ensure(4);

  @$pb.TagNumber(6)
  ConsentStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(ConsentStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  ConsentGiver get givenBy => $_getN(6);
  @$pb.TagNumber(7)
  set givenBy(ConsentGiver value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasGivenBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearGivenBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get givenByName => $_getSZ(7);
  @$pb.TagNumber(8)
  set givenByName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasGivenByName() => $_has(7);
  @$pb.TagNumber(8)
  void clearGivenByName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get documentId => $_getSZ(8);
  @$pb.TagNumber(9)
  set documentId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDocumentId() => $_has(8);
  @$pb.TagNumber(9)
  void clearDocumentId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get witnessId => $_getSZ(9);
  @$pb.TagNumber(10)
  set witnessId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasWitnessId() => $_has(9);
  @$pb.TagNumber(10)
  void clearWitnessId() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get validFrom => $_getN(10);
  @$pb.TagNumber(11)
  set validFrom($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasValidFrom() => $_has(10);
  @$pb.TagNumber(11)
  void clearValidFrom() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureValidFrom() => $_ensure(10);

  /// A consent with no expiry for an operation two years later is a consent to
  /// something the patient no longer remembers agreeing to.
  @$pb.TagNumber(12)
  $0.Timestamp get validUntil => $_getN(11);
  @$pb.TagNumber(12)
  set validUntil($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasValidUntil() => $_has(11);
  @$pb.TagNumber(12)
  void clearValidUntil() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureValidUntil() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get note => $_getSZ(12);
  @$pb.TagNumber(13)
  set note($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasNote() => $_has(12);
  @$pb.TagNumber(13)
  void clearNote() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get recordedBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set recordedBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRecordedBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearRecordedBy() => $_clearField(14);
}

class CalculatorInput extends $pb.GeneratedMessage {
  factory CalculatorInput({
    $core.String? name,
    $core.String? value,
    $core.String? unit,
    $core.String? sourceId,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (sourceId != null) result.sourceId = sourceId;
    return result;
  }

  CalculatorInput._();

  factory CalculatorInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CalculatorInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CalculatorInput',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..aOS(3, _omitFieldNames ? '' : 'unit')
    ..aOS(4, _omitFieldNames ? '' : 'sourceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculatorInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculatorInput copyWith(void Function(CalculatorInput) updates) =>
      super.copyWith((message) => updates(message as CalculatorInput))
          as CalculatorInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculatorInput create() => CalculatorInput._();
  @$core.override
  CalculatorInput createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CalculatorInput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CalculatorInput>(create);
  static CalculatorInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get unit => $_getSZ(2);
  @$pb.TagNumber(3)
  set unit($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnit() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnit() => $_clearField(3);

  /// Which record the value came from. A score built from typed values is a
  /// different thing from one built from measurements.
  @$pb.TagNumber(4)
  $core.String get sourceId => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourceId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceId() => $_clearField(4);
}

class CalculatorResult extends $pb.GeneratedMessage {
  factory CalculatorResult({
    $core.String? resultId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? calculatorId,
    $core.String? formulaVersion,
    $core.String? name,
    $core.Iterable<CalculatorInput>? inputs,
    $core.double? value,
    $core.String? unit,
    $core.String? interpretation,
    $core.String? supersededById,
    $core.String? calculatedBy,
    $0.Timestamp? calculatedAt,
  }) {
    final result = create();
    if (resultId != null) result.resultId = resultId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (calculatorId != null) result.calculatorId = calculatorId;
    if (formulaVersion != null) result.formulaVersion = formulaVersion;
    if (name != null) result.name = name;
    if (inputs != null) result.inputs.addAll(inputs);
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (interpretation != null) result.interpretation = interpretation;
    if (supersededById != null) result.supersededById = supersededById;
    if (calculatedBy != null) result.calculatedBy = calculatedBy;
    if (calculatedAt != null) result.calculatedAt = calculatedAt;
    return result;
  }

  CalculatorResult._();

  factory CalculatorResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CalculatorResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CalculatorResult',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'resultId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'calculatorId')
    ..aOS(5, _omitFieldNames ? '' : 'formulaVersion')
    ..aOS(6, _omitFieldNames ? '' : 'name')
    ..pPM<CalculatorInput>(7, _omitFieldNames ? '' : 'inputs',
        subBuilder: CalculatorInput.create)
    ..aD(8, _omitFieldNames ? '' : 'value')
    ..aOS(9, _omitFieldNames ? '' : 'unit')
    ..aOS(10, _omitFieldNames ? '' : 'interpretation')
    ..aOS(11, _omitFieldNames ? '' : 'supersededById')
    ..aOS(12, _omitFieldNames ? '' : 'calculatedBy')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'calculatedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculatorResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculatorResult copyWith(void Function(CalculatorResult) updates) =>
      super.copyWith((message) => updates(message as CalculatorResult))
          as CalculatorResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculatorResult create() => CalculatorResult._();
  @$core.override
  CalculatorResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CalculatorResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CalculatorResult>(create);
  static CalculatorResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get resultId => $_getSZ(0);
  @$pb.TagNumber(1)
  set resultId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResultId() => $_has(0);
  @$pb.TagNumber(1)
  void clearResultId() => $_clearField(1);

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
  $core.String get calculatorId => $_getSZ(3);
  @$pb.TagNumber(4)
  set calculatorId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCalculatorId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCalculatorId() => $_clearField(4);

  /// An unversioned calculator makes every stored score ambiguous the first
  /// time somebody corrects a coefficient.
  @$pb.TagNumber(5)
  $core.String get formulaVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set formulaVersion($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFormulaVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearFormulaVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get name => $_getSZ(5);
  @$pb.TagNumber(6)
  set name($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasName() => $_has(5);
  @$pb.TagNumber(6)
  void clearName() => $_clearField(6);

  /// A score whose inputs were not kept cannot be checked, and the one time
  /// anybody checks is when it looks wrong.
  @$pb.TagNumber(7)
  $pb.PbList<CalculatorInput> get inputs => $_getList(6);

  @$pb.TagNumber(8)
  $core.double get value => $_getN(7);
  @$pb.TagNumber(8)
  set value($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasValue() => $_has(7);
  @$pb.TagNumber(8)
  void clearValue() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get unit => $_getSZ(8);
  @$pb.TagNumber(9)
  set unit($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUnit() => $_has(8);
  @$pb.TagNumber(9)
  void clearUnit() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get interpretation => $_getSZ(9);
  @$pb.TagNumber(10)
  set interpretation($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasInterpretation() => $_has(9);
  @$pb.TagNumber(10)
  void clearInterpretation() => $_clearField(10);

  /// A rerun with a newer formula chains forward; the original stays.
  @$pb.TagNumber(11)
  $core.String get supersededById => $_getSZ(10);
  @$pb.TagNumber(11)
  set supersededById($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSupersededById() => $_has(10);
  @$pb.TagNumber(11)
  void clearSupersededById() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get calculatedBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set calculatedBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCalculatedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearCalculatedBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get calculatedAt => $_getN(12);
  @$pb.TagNumber(13)
  set calculatedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCalculatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCalculatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureCalculatedAt() => $_ensure(12);
}

class CDSAlert extends $pb.GeneratedMessage {
  factory CDSAlert({
    $core.String? alertId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? ruleId,
    $core.String? ruleVersion,
    AlertLevel? level,
    $core.String? message,
    $core.String? contextType,
    $core.String? contextId,
    AlertOutcome? outcome,
    $core.String? overrideCode,
    $core.String? overrideReason,
    $0.Timestamp? firedAt,
    $core.String? respondedBy,
    $0.Timestamp? respondedAt,
  }) {
    final result = create();
    if (alertId != null) result.alertId = alertId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (ruleId != null) result.ruleId = ruleId;
    if (ruleVersion != null) result.ruleVersion = ruleVersion;
    if (level != null) result.level = level;
    if (message != null) result.message = message;
    if (contextType != null) result.contextType = contextType;
    if (contextId != null) result.contextId = contextId;
    if (outcome != null) result.outcome = outcome;
    if (overrideCode != null) result.overrideCode = overrideCode;
    if (overrideReason != null) result.overrideReason = overrideReason;
    if (firedAt != null) result.firedAt = firedAt;
    if (respondedBy != null) result.respondedBy = respondedBy;
    if (respondedAt != null) result.respondedAt = respondedAt;
    return result;
  }

  CDSAlert._();

  factory CDSAlert.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CDSAlert.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CDSAlert',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'alertId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'ruleId')
    ..aOS(5, _omitFieldNames ? '' : 'ruleVersion')
    ..aE<AlertLevel>(6, _omitFieldNames ? '' : 'level',
        enumValues: AlertLevel.values)
    ..aOS(7, _omitFieldNames ? '' : 'message')
    ..aOS(8, _omitFieldNames ? '' : 'contextType')
    ..aOS(9, _omitFieldNames ? '' : 'contextId')
    ..aE<AlertOutcome>(10, _omitFieldNames ? '' : 'outcome',
        enumValues: AlertOutcome.values)
    ..aOS(11, _omitFieldNames ? '' : 'overrideCode')
    ..aOS(12, _omitFieldNames ? '' : 'overrideReason')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'firedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(14, _omitFieldNames ? '' : 'respondedBy')
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'respondedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CDSAlert clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CDSAlert copyWith(void Function(CDSAlert) updates) =>
      super.copyWith((message) => updates(message as CDSAlert)) as CDSAlert;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CDSAlert create() => CDSAlert._();
  @$core.override
  CDSAlert createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CDSAlert getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CDSAlert>(create);
  static CDSAlert? _defaultInstance;

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
  $core.String get ruleId => $_getSZ(3);
  @$pb.TagNumber(4)
  set ruleId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRuleId() => $_has(3);
  @$pb.TagNumber(4)
  void clearRuleId() => $_clearField(4);

  /// An override report that could not say which version fired cannot tell a
  /// tuning change from a behaviour change.
  @$pb.TagNumber(5)
  $core.String get ruleVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set ruleVersion($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRuleVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearRuleVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  AlertLevel get level => $_getN(5);
  @$pb.TagNumber(6)
  set level(AlertLevel value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLevel() => $_has(5);
  @$pb.TagNumber(6)
  void clearLevel() => $_clearField(6);

  /// The wording is tuned too, and an override against a message nobody can
  /// reproduce is an override nobody can interpret.
  @$pb.TagNumber(7)
  $core.String get message => $_getSZ(6);
  @$pb.TagNumber(7)
  set message($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMessage() => $_has(6);
  @$pb.TagNumber(7)
  void clearMessage() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get contextType => $_getSZ(7);
  @$pb.TagNumber(8)
  set contextType($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasContextType() => $_has(7);
  @$pb.TagNumber(8)
  void clearContextType() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get contextId => $_getSZ(8);
  @$pb.TagNumber(9)
  set contextId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasContextId() => $_has(8);
  @$pb.TagNumber(9)
  void clearContextId() => $_clearField(9);

  @$pb.TagNumber(10)
  AlertOutcome get outcome => $_getN(9);
  @$pb.TagNumber(10)
  set outcome(AlertOutcome value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasOutcome() => $_has(9);
  @$pb.TagNumber(10)
  void clearOutcome() => $_clearField(10);

  /// A chosen code is what makes overrides reportable rather than a pile of
  /// free text.
  @$pb.TagNumber(11)
  $core.String get overrideCode => $_getSZ(10);
  @$pb.TagNumber(11)
  set overrideCode($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOverrideCode() => $_has(10);
  @$pb.TagNumber(11)
  void clearOverrideCode() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get overrideReason => $_getSZ(11);
  @$pb.TagNumber(12)
  set overrideReason($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOverrideReason() => $_has(11);
  @$pb.TagNumber(12)
  void clearOverrideReason() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get firedAt => $_getN(12);
  @$pb.TagNumber(13)
  set firedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasFiredAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearFiredAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureFiredAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get respondedBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set respondedBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRespondedBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearRespondedBy() => $_clearField(14);

  @$pb.TagNumber(15)
  $0.Timestamp get respondedAt => $_getN(14);
  @$pb.TagNumber(15)
  set respondedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasRespondedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearRespondedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureRespondedAt() => $_ensure(14);
}

class Consult extends $pb.GeneratedMessage {
  factory Consult({
    $core.String? consultId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? specialty,
    ConsultUrgency? urgency,
    $core.String? reason,
    $core.String? question,
    ConsultStatus? status,
    $core.String? respondingSubjectId,
    $core.String? response,
    $core.String? responseDocumentId,
    $core.String? declineReason,
    $core.String? requestedBy,
    $0.Timestamp? requestedAt,
    $0.Timestamp? respondedAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (consultId != null) result.consultId = consultId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (specialty != null) result.specialty = specialty;
    if (urgency != null) result.urgency = urgency;
    if (reason != null) result.reason = reason;
    if (question != null) result.question = question;
    if (status != null) result.status = status;
    if (respondingSubjectId != null)
      result.respondingSubjectId = respondingSubjectId;
    if (response != null) result.response = response;
    if (responseDocumentId != null)
      result.responseDocumentId = responseDocumentId;
    if (declineReason != null) result.declineReason = declineReason;
    if (requestedBy != null) result.requestedBy = requestedBy;
    if (requestedAt != null) result.requestedAt = requestedAt;
    if (respondedAt != null) result.respondedAt = respondedAt;
    if (version != null) result.version = version;
    return result;
  }

  Consult._();

  factory Consult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Consult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Consult',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'consultId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'specialty')
    ..aE<ConsultUrgency>(5, _omitFieldNames ? '' : 'urgency',
        enumValues: ConsultUrgency.values)
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..aOS(7, _omitFieldNames ? '' : 'question')
    ..aE<ConsultStatus>(8, _omitFieldNames ? '' : 'status',
        enumValues: ConsultStatus.values)
    ..aOS(9, _omitFieldNames ? '' : 'respondingSubjectId')
    ..aOS(10, _omitFieldNames ? '' : 'response')
    ..aOS(11, _omitFieldNames ? '' : 'responseDocumentId')
    ..aOS(12, _omitFieldNames ? '' : 'declineReason')
    ..aOS(13, _omitFieldNames ? '' : 'requestedBy')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'requestedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'respondedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(16, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Consult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Consult copyWith(void Function(Consult) updates) =>
      super.copyWith((message) => updates(message as Consult)) as Consult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Consult create() => Consult._();
  @$core.override
  Consult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Consult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Consult>(create);
  static Consult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get consultId => $_getSZ(0);
  @$pb.TagNumber(1)
  set consultId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConsultId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConsultId() => $_clearField(1);

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
  $core.String get specialty => $_getSZ(3);
  @$pb.TagNumber(4)
  set specialty($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSpecialty() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpecialty() => $_clearField(4);

  @$pb.TagNumber(5)
  ConsultUrgency get urgency => $_getN(4);
  @$pb.TagNumber(5)
  set urgency(ConsultUrgency value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUrgency() => $_has(4);
  @$pb.TagNumber(5)
  void clearUrgency() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => $_clearField(6);

  /// A consult with background but no question produces an opinion that answers
  /// something else.
  @$pb.TagNumber(7)
  $core.String get question => $_getSZ(6);
  @$pb.TagNumber(7)
  set question($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasQuestion() => $_has(6);
  @$pb.TagNumber(7)
  void clearQuestion() => $_clearField(7);

  @$pb.TagNumber(8)
  ConsultStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(ConsultStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get respondingSubjectId => $_getSZ(8);
  @$pb.TagNumber(9)
  set respondingSubjectId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRespondingSubjectId() => $_has(8);
  @$pb.TagNumber(9)
  void clearRespondingSubjectId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get response => $_getSZ(9);
  @$pb.TagNumber(10)
  set response($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasResponse() => $_has(9);
  @$pb.TagNumber(10)
  void clearResponse() => $_clearField(10);

  /// The answer lands on the request rather than becoming a free-floating note.
  @$pb.TagNumber(11)
  $core.String get responseDocumentId => $_getSZ(10);
  @$pb.TagNumber(11)
  set responseDocumentId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasResponseDocumentId() => $_has(10);
  @$pb.TagNumber(11)
  void clearResponseDocumentId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get declineReason => $_getSZ(11);
  @$pb.TagNumber(12)
  set declineReason($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasDeclineReason() => $_has(11);
  @$pb.TagNumber(12)
  void clearDeclineReason() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get requestedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set requestedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRequestedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearRequestedBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get requestedAt => $_getN(13);
  @$pb.TagNumber(14)
  set requestedAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasRequestedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearRequestedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureRequestedAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $0.Timestamp get respondedAt => $_getN(14);
  @$pb.TagNumber(15)
  set respondedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasRespondedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearRespondedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureRespondedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $fixnum.Int64 get version => $_getI64(15);
  @$pb.TagNumber(16)
  set version($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasVersion() => $_has(15);
  @$pb.TagNumber(16)
  void clearVersion() => $_clearField(16);
}

class RegistryMembership extends $pb.GeneratedMessage {
  factory RegistryMembership({
    $core.String? membershipId,
    $core.String? patientId,
    $core.String? registryId,
    $core.String? problemId,
    $core.String? diagnosisId,
    $0.Timestamp? enrolledAt,
    $0.Timestamp? exitedAt,
    $core.String? exitReason,
    $core.bool? consented,
  }) {
    final result = create();
    if (membershipId != null) result.membershipId = membershipId;
    if (patientId != null) result.patientId = patientId;
    if (registryId != null) result.registryId = registryId;
    if (problemId != null) result.problemId = problemId;
    if (diagnosisId != null) result.diagnosisId = diagnosisId;
    if (enrolledAt != null) result.enrolledAt = enrolledAt;
    if (exitedAt != null) result.exitedAt = exitedAt;
    if (exitReason != null) result.exitReason = exitReason;
    if (consented != null) result.consented = consented;
    return result;
  }

  RegistryMembership._();

  factory RegistryMembership.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegistryMembership.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegistryMembership',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'membershipId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'registryId')
    ..aOS(4, _omitFieldNames ? '' : 'problemId')
    ..aOS(5, _omitFieldNames ? '' : 'diagnosisId')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'enrolledAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'exitedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'exitReason')
    ..aOB(9, _omitFieldNames ? '' : 'consented')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegistryMembership clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegistryMembership copyWith(void Function(RegistryMembership) updates) =>
      super.copyWith((message) => updates(message as RegistryMembership))
          as RegistryMembership;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegistryMembership create() => RegistryMembership._();
  @$core.override
  RegistryMembership createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegistryMembership getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegistryMembership>(create);
  static RegistryMembership? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get membershipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set membershipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMembershipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMembershipId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get registryId => $_getSZ(2);
  @$pb.TagNumber(3)
  set registryId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRegistryId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRegistryId() => $_clearField(3);

  /// The canonical facts membership rests on. At least one is required: a
  /// membership resting on nothing cannot be re-derived or defended.
  @$pb.TagNumber(4)
  $core.String get problemId => $_getSZ(3);
  @$pb.TagNumber(4)
  set problemId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProblemId() => $_has(3);
  @$pb.TagNumber(4)
  void clearProblemId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get diagnosisId => $_getSZ(4);
  @$pb.TagNumber(5)
  set diagnosisId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDiagnosisId() => $_has(4);
  @$pb.TagNumber(5)
  void clearDiagnosisId() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get enrolledAt => $_getN(5);
  @$pb.TagNumber(6)
  set enrolledAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEnrolledAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearEnrolledAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureEnrolledAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get exitedAt => $_getN(6);
  @$pb.TagNumber(7)
  set exitedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasExitedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearExitedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureExitedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get exitReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set exitReason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasExitReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearExitReason() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get consented => $_getBF(8);
  @$pb.TagNumber(9)
  set consented($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasConsented() => $_has(8);
  @$pb.TagNumber(9)
  void clearConsented() => $_clearField(9);
}

class SmartPhrase extends $pb.GeneratedMessage {
  factory SmartPhrase({
    $core.String? phraseId,
    $core.String? ownerId,
    $core.String? shortcut,
    $core.String? expansion,
  }) {
    final result = create();
    if (phraseId != null) result.phraseId = phraseId;
    if (ownerId != null) result.ownerId = ownerId;
    if (shortcut != null) result.shortcut = shortcut;
    if (expansion != null) result.expansion = expansion;
    return result;
  }

  SmartPhrase._();

  factory SmartPhrase.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmartPhrase.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmartPhrase',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'phraseId')
    ..aOS(2, _omitFieldNames ? '' : 'ownerId')
    ..aOS(3, _omitFieldNames ? '' : 'shortcut')
    ..aOS(4, _omitFieldNames ? '' : 'expansion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmartPhrase clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmartPhrase copyWith(void Function(SmartPhrase) updates) =>
      super.copyWith((message) => updates(message as SmartPhrase))
          as SmartPhrase;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmartPhrase create() => SmartPhrase._();
  @$core.override
  SmartPhrase createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SmartPhrase getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmartPhrase>(create);
  static SmartPhrase? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phraseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set phraseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPhraseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhraseId() => $_clearField(1);

  /// Empty means shared across the tenant; otherwise it is one clinician's.
  @$pb.TagNumber(2)
  $core.String get ownerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set ownerId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOwnerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOwnerId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get shortcut => $_getSZ(2);
  @$pb.TagNumber(3)
  set shortcut($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShortcut() => $_has(2);
  @$pb.TagNumber(3)
  void clearShortcut() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get expansion => $_getSZ(3);
  @$pb.TagNumber(4)
  set expansion($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpansion() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpansion() => $_clearField(4);
}

/// One identifier a clinician can read out at the bedside (SRS-CLN-001).
class BannerIdentifier extends $pb.GeneratedMessage {
  factory BannerIdentifier({
    $core.String? system,
    $core.String? value,
    $core.String? label,
  }) {
    final result = create();
    if (system != null) result.system = system;
    if (value != null) result.value = value;
    if (label != null) result.label = label;
    return result;
  }

  BannerIdentifier._();

  factory BannerIdentifier.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BannerIdentifier.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BannerIdentifier',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'system')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..aOS(3, _omitFieldNames ? '' : 'label')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BannerIdentifier clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BannerIdentifier copyWith(void Function(BannerIdentifier) updates) =>
      super.copyWith((message) => updates(message as BannerIdentifier))
          as BannerIdentifier;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BannerIdentifier create() => BannerIdentifier._();
  @$core.override
  BannerIdentifier createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BannerIdentifier getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BannerIdentifier>(create);
  static BannerIdentifier? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get system => $_getSZ(0);
  @$pb.TagNumber(1)
  set system($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSystem() => $_has(0);
  @$pb.TagNumber(1)
  void clearSystem() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get label => $_getSZ(2);
  @$pb.TagNumber(3)
  set label($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLabel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLabel() => $_clearField(3);
}

class BannerAlert extends $pb.GeneratedMessage {
  factory BannerAlert({
    $core.String? severity,
    $core.String? kind,
    $core.String? text,
    $core.String? recordId,
  }) {
    final result = create();
    if (severity != null) result.severity = severity;
    if (kind != null) result.kind = kind;
    if (text != null) result.text = text;
    if (recordId != null) result.recordId = recordId;
    return result;
  }

  BannerAlert._();

  factory BannerAlert.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BannerAlert.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BannerAlert',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'severity')
    ..aOS(2, _omitFieldNames ? '' : 'kind')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aOS(4, _omitFieldNames ? '' : 'recordId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BannerAlert clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BannerAlert copyWith(void Function(BannerAlert) updates) =>
      super.copyWith((message) => updates(message as BannerAlert))
          as BannerAlert;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BannerAlert create() => BannerAlert._();
  @$core.override
  BannerAlert createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BannerAlert getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BannerAlert>(create);
  static BannerAlert? _defaultInstance;

  /// "critical", "warning", "info".
  @$pb.TagNumber(1)
  $core.String get severity => $_getSZ(0);
  @$pb.TagNumber(1)
  set severity($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeverity() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeverity() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get kind => $_getSZ(1);
  @$pb.TagNumber(2)
  set kind($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  /// Kept short: a banner is read in a second, and an alert that needs a
  /// paragraph belongs in the chart.
  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get recordId => $_getSZ(3);
  @$pb.TagNumber(4)
  set recordId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRecordId() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecordId() => $_clearField(4);
}

/// What every clinical screen shows about the patient in front of the clinician
/// (SRS-CLN-001).
class Banner extends $pb.GeneratedMessage {
  factory Banner({
    $core.String? patientId,
    $core.Iterable<BannerIdentifier>? identifiers,
    $core.String? displayName,
    $core.String? ageDisplay,
    $core.String? sex,
    $core.Iterable<BannerAlert>? alerts,
    $core.String? encounterContext,
    $core.bool? deceased,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (identifiers != null) result.identifiers.addAll(identifiers);
    if (displayName != null) result.displayName = displayName;
    if (ageDisplay != null) result.ageDisplay = ageDisplay;
    if (sex != null) result.sex = sex;
    if (alerts != null) result.alerts.addAll(alerts);
    if (encounterContext != null) result.encounterContext = encounterContext;
    if (deceased != null) result.deceased = deceased;
    return result;
  }

  Banner._();

  factory Banner.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Banner.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Banner',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..pPM<BannerIdentifier>(2, _omitFieldNames ? '' : 'identifiers',
        subBuilder: BannerIdentifier.create)
    ..aOS(3, _omitFieldNames ? '' : 'displayName')
    ..aOS(4, _omitFieldNames ? '' : 'ageDisplay')
    ..aOS(5, _omitFieldNames ? '' : 'sex')
    ..pPM<BannerAlert>(6, _omitFieldNames ? '' : 'alerts',
        subBuilder: BannerAlert.create)
    ..aOS(7, _omitFieldNames ? '' : 'encounterContext')
    ..aOB(8, _omitFieldNames ? '' : 'deceased')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Banner clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Banner copyWith(void Function(Banner) updates) =>
      super.copyWith((message) => updates(message as Banner)) as Banner;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Banner create() => Banner._();
  @$core.override
  Banner createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Banner getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Banner>(create);
  static Banner? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<BannerIdentifier> get identifiers => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => $_clearField(3);

  /// Rendered rather than a date: a screen showing "0" for a two-week-old is a
  /// dosing error waiting to happen.
  @$pb.TagNumber(4)
  $core.String get ageDisplay => $_getSZ(3);
  @$pb.TagNumber(4)
  set ageDisplay($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAgeDisplay() => $_has(3);
  @$pb.TagNumber(4)
  void clearAgeDisplay() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sex => $_getSZ(4);
  @$pb.TagNumber(5)
  set sex($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSex() => $_has(4);
  @$pb.TagNumber(5)
  void clearSex() => $_clearField(5);

  /// Deliberately few. A banner with fifteen alerts is a banner nobody reads.
  @$pb.TagNumber(6)
  $pb.PbList<BannerAlert> get alerts => $_getList(5);

  /// Which visit the screen is in — "Ward 4, inpatient, day 3".
  @$pb.TagNumber(7)
  $core.String get encounterContext => $_getSZ(6);
  @$pb.TagNumber(7)
  set encounterContext($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEncounterContext() => $_has(6);
  @$pb.TagNumber(7)
  void clearEncounterContext() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get deceased => $_getBF(7);
  @$pb.TagNumber(8)
  set deceased($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDeceased() => $_has(7);
  @$pb.TagNumber(8)
  void clearDeceased() => $_clearField(8);
}

class WriteNoteRequest extends $pb.GeneratedMessage {
  factory WriteNoteRequest({
    $core.String? documentId,
    $core.String? patientId,
    $core.String? encounterId,
    DocumentKind? kind,
    $core.String? templateId,
    $core.String? templateVersion,
    $core.String? title,
    $core.Iterable<Section>? sections,
    Confidentiality? confidentiality,
    $core.bool? dictated,
    PatientContext? context,
  }) {
    final result = create();
    if (documentId != null) result.documentId = documentId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (kind != null) result.kind = kind;
    if (templateId != null) result.templateId = templateId;
    if (templateVersion != null) result.templateVersion = templateVersion;
    if (title != null) result.title = title;
    if (sections != null) result.sections.addAll(sections);
    if (confidentiality != null) result.confidentiality = confidentiality;
    if (dictated != null) result.dictated = dictated;
    if (context != null) result.context = context;
    return result;
  }

  WriteNoteRequest._();

  factory WriteNoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WriteNoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WriteNoteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'documentId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aE<DocumentKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: DocumentKind.values)
    ..aOS(5, _omitFieldNames ? '' : 'templateId')
    ..aOS(6, _omitFieldNames ? '' : 'templateVersion')
    ..aOS(7, _omitFieldNames ? '' : 'title')
    ..pPM<Section>(8, _omitFieldNames ? '' : 'sections',
        subBuilder: Section.create)
    ..aE<Confidentiality>(9, _omitFieldNames ? '' : 'confidentiality',
        enumValues: Confidentiality.values)
    ..aOB(10, _omitFieldNames ? '' : 'dictated')
    ..aOM<PatientContext>(11, _omitFieldNames ? '' : 'context',
        subBuilder: PatientContext.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteNoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteNoteRequest copyWith(void Function(WriteNoteRequest) updates) =>
      super.copyWith((message) => updates(message as WriteNoteRequest))
          as WriteNoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WriteNoteRequest create() => WriteNoteRequest._();
  @$core.override
  WriteNoteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WriteNoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteNoteRequest>(create);
  static WriteNoteRequest? _defaultInstance;

  /// Revises an existing draft. Empty starts a new one.
  @$pb.TagNumber(1)
  $core.String get documentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set documentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentId() => $_clearField(1);

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
  DocumentKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(DocumentKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get templateId => $_getSZ(4);
  @$pb.TagNumber(5)
  set templateId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTemplateId() => $_has(4);
  @$pb.TagNumber(5)
  void clearTemplateId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get templateVersion => $_getSZ(5);
  @$pb.TagNumber(6)
  set templateVersion($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTemplateVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearTemplateVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get title => $_getSZ(6);
  @$pb.TagNumber(7)
  set title($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTitle() => $_has(6);
  @$pb.TagNumber(7)
  void clearTitle() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<Section> get sections => $_getList(7);

  @$pb.TagNumber(9)
  Confidentiality get confidentiality => $_getN(8);
  @$pb.TagNumber(9)
  set confidentiality(Confidentiality value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasConfidentiality() => $_has(8);
  @$pb.TagNumber(9)
  void clearConfidentiality() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get dictated => $_getBF(9);
  @$pb.TagNumber(10)
  set dictated($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDictated() => $_has(9);
  @$pb.TagNumber(10)
  void clearDictated() => $_clearField(10);

  @$pb.TagNumber(11)
  PatientContext get context => $_getN(10);
  @$pb.TagNumber(11)
  set context(PatientContext value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasContext() => $_has(10);
  @$pb.TagNumber(11)
  void clearContext() => $_clearField(11);
  @$pb.TagNumber(11)
  PatientContext ensureContext() => $_ensure(10);
}

class WriteNoteResponse extends $pb.GeneratedMessage {
  factory WriteNoteResponse({
    Document? document,
  }) {
    final result = create();
    if (document != null) result.document = document;
    return result;
  }

  WriteNoteResponse._();

  factory WriteNoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WriteNoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WriteNoteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Document>(1, _omitFieldNames ? '' : 'document',
        subBuilder: Document.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteNoteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteNoteResponse copyWith(void Function(WriteNoteResponse) updates) =>
      super.copyWith((message) => updates(message as WriteNoteResponse))
          as WriteNoteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WriteNoteResponse create() => WriteNoteResponse._();
  @$core.override
  WriteNoteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WriteNoteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteNoteResponse>(create);
  static WriteNoteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Document get document => $_getN(0);
  @$pb.TagNumber(1)
  set document(Document value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDocument() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocument() => $_clearField(1);
  @$pb.TagNumber(1)
  Document ensureDocument() => $_ensure(0);
}

class SignNoteRequest extends $pb.GeneratedMessage {
  factory SignNoteRequest({
    $core.String? documentId,
    SignatureMeaning? meaning,
    PatientContext? context,
  }) {
    final result = create();
    if (documentId != null) result.documentId = documentId;
    if (meaning != null) result.meaning = meaning;
    if (context != null) result.context = context;
    return result;
  }

  SignNoteRequest._();

  factory SignNoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignNoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignNoteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'documentId')
    ..aE<SignatureMeaning>(2, _omitFieldNames ? '' : 'meaning',
        enumValues: SignatureMeaning.values)
    ..aOM<PatientContext>(3, _omitFieldNames ? '' : 'context',
        subBuilder: PatientContext.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignNoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignNoteRequest copyWith(void Function(SignNoteRequest) updates) =>
      super.copyWith((message) => updates(message as SignNoteRequest))
          as SignNoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignNoteRequest create() => SignNoteRequest._();
  @$core.override
  SignNoteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SignNoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignNoteRequest>(create);
  static SignNoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get documentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set documentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentId() => $_clearField(1);

  @$pb.TagNumber(2)
  SignatureMeaning get meaning => $_getN(1);
  @$pb.TagNumber(2)
  set meaning(SignatureMeaning value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMeaning() => $_has(1);
  @$pb.TagNumber(2)
  void clearMeaning() => $_clearField(2);

  @$pb.TagNumber(3)
  PatientContext get context => $_getN(2);
  @$pb.TagNumber(3)
  set context(PatientContext value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasContext() => $_has(2);
  @$pb.TagNumber(3)
  void clearContext() => $_clearField(3);
  @$pb.TagNumber(3)
  PatientContext ensureContext() => $_ensure(2);
}

class SignNoteResponse extends $pb.GeneratedMessage {
  factory SignNoteResponse({
    Document? document,
  }) {
    final result = create();
    if (document != null) result.document = document;
    return result;
  }

  SignNoteResponse._();

  factory SignNoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignNoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignNoteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Document>(1, _omitFieldNames ? '' : 'document',
        subBuilder: Document.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignNoteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignNoteResponse copyWith(void Function(SignNoteResponse) updates) =>
      super.copyWith((message) => updates(message as SignNoteResponse))
          as SignNoteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignNoteResponse create() => SignNoteResponse._();
  @$core.override
  SignNoteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SignNoteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignNoteResponse>(create);
  static SignNoteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Document get document => $_getN(0);
  @$pb.TagNumber(1)
  set document(Document value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDocument() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocument() => $_clearField(1);
  @$pb.TagNumber(1)
  Document ensureDocument() => $_ensure(0);
}

class AmendNoteRequest extends $pb.GeneratedMessage {
  factory AmendNoteRequest({
    $core.String? documentId,
    $core.String? title,
    $core.Iterable<Section>? sections,
    $core.String? reason,
    $core.bool? addendum,
    PatientContext? context,
  }) {
    final result = create();
    if (documentId != null) result.documentId = documentId;
    if (title != null) result.title = title;
    if (sections != null) result.sections.addAll(sections);
    if (reason != null) result.reason = reason;
    if (addendum != null) result.addendum = addendum;
    if (context != null) result.context = context;
    return result;
  }

  AmendNoteRequest._();

  factory AmendNoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AmendNoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AmendNoteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'documentId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..pPM<Section>(3, _omitFieldNames ? '' : 'sections',
        subBuilder: Section.create)
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aOB(5, _omitFieldNames ? '' : 'addendum')
    ..aOM<PatientContext>(6, _omitFieldNames ? '' : 'context',
        subBuilder: PatientContext.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendNoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendNoteRequest copyWith(void Function(AmendNoteRequest) updates) =>
      super.copyWith((message) => updates(message as AmendNoteRequest))
          as AmendNoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AmendNoteRequest create() => AmendNoteRequest._();
  @$core.override
  AmendNoteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AmendNoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AmendNoteRequest>(create);
  static AmendNoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get documentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set documentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<Section> get sections => $_getList(2);

  /// Required for an amendment and absent for an addendum: an addendum does not
  /// contradict anything, it adds what was not yet known.
  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get addendum => $_getBF(4);
  @$pb.TagNumber(5)
  set addendum($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAddendum() => $_has(4);
  @$pb.TagNumber(5)
  void clearAddendum() => $_clearField(5);

  @$pb.TagNumber(6)
  PatientContext get context => $_getN(5);
  @$pb.TagNumber(6)
  set context(PatientContext value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasContext() => $_has(5);
  @$pb.TagNumber(6)
  void clearContext() => $_clearField(6);
  @$pb.TagNumber(6)
  PatientContext ensureContext() => $_ensure(5);
}

class AmendNoteResponse extends $pb.GeneratedMessage {
  factory AmendNoteResponse({
    Document? document,
  }) {
    final result = create();
    if (document != null) result.document = document;
    return result;
  }

  AmendNoteResponse._();

  factory AmendNoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AmendNoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AmendNoteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Document>(1, _omitFieldNames ? '' : 'document',
        subBuilder: Document.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendNoteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendNoteResponse copyWith(void Function(AmendNoteResponse) updates) =>
      super.copyWith((message) => updates(message as AmendNoteResponse))
          as AmendNoteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AmendNoteResponse create() => AmendNoteResponse._();
  @$core.override
  AmendNoteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AmendNoteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AmendNoteResponse>(create);
  static AmendNoteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Document get document => $_getN(0);
  @$pb.TagNumber(1)
  set document(Document value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDocument() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocument() => $_clearField(1);
  @$pb.TagNumber(1)
  Document ensureDocument() => $_ensure(0);
}

class RetractNoteRequest extends $pb.GeneratedMessage {
  factory RetractNoteRequest({
    $core.String? documentId,
    $core.String? reason,
  }) {
    final result = create();
    if (documentId != null) result.documentId = documentId;
    if (reason != null) result.reason = reason;
    return result;
  }

  RetractNoteRequest._();

  factory RetractNoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetractNoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetractNoteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'documentId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetractNoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetractNoteRequest copyWith(void Function(RetractNoteRequest) updates) =>
      super.copyWith((message) => updates(message as RetractNoteRequest))
          as RetractNoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetractNoteRequest create() => RetractNoteRequest._();
  @$core.override
  RetractNoteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetractNoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetractNoteRequest>(create);
  static RetractNoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get documentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set documentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class RetractNoteResponse extends $pb.GeneratedMessage {
  factory RetractNoteResponse() => create();

  RetractNoteResponse._();

  factory RetractNoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetractNoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetractNoteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetractNoteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetractNoteResponse copyWith(void Function(RetractNoteResponse) updates) =>
      super.copyWith((message) => updates(message as RetractNoteResponse))
          as RetractNoteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetractNoteResponse create() => RetractNoteResponse._();
  @$core.override
  RetractNoteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetractNoteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetractNoteResponse>(create);
  static RetractNoteResponse? _defaultInstance;
}

class GetNoteRequest extends $pb.GeneratedMessage {
  factory GetNoteRequest({
    $core.String? documentId,
  }) {
    final result = create();
    if (documentId != null) result.documentId = documentId;
    return result;
  }

  GetNoteRequest._();

  factory GetNoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetNoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetNoteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'documentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetNoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetNoteRequest copyWith(void Function(GetNoteRequest) updates) =>
      super.copyWith((message) => updates(message as GetNoteRequest))
          as GetNoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetNoteRequest create() => GetNoteRequest._();
  @$core.override
  GetNoteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetNoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetNoteRequest>(create);
  static GetNoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get documentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set documentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentId() => $_clearField(1);
}

class GetNoteResponse extends $pb.GeneratedMessage {
  factory GetNoteResponse({
    Document? document,
  }) {
    final result = create();
    if (document != null) result.document = document;
    return result;
  }

  GetNoteResponse._();

  factory GetNoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetNoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetNoteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Document>(1, _omitFieldNames ? '' : 'document',
        subBuilder: Document.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetNoteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetNoteResponse copyWith(void Function(GetNoteResponse) updates) =>
      super.copyWith((message) => updates(message as GetNoteResponse))
          as GetNoteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetNoteResponse create() => GetNoteResponse._();
  @$core.override
  GetNoteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetNoteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetNoteResponse>(create);
  static GetNoteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Document get document => $_getN(0);
  @$pb.TagNumber(1)
  set document(Document value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDocument() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocument() => $_clearField(1);
  @$pb.TagNumber(1)
  Document ensureDocument() => $_ensure(0);
}

class ListNotesRequest extends $pb.GeneratedMessage {
  factory ListNotesRequest({
    $core.String? patientId,
    $core.String? encounterId,
    DocumentKind? kind,
    $core.bool? includeDrafts,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (kind != null) result.kind = kind;
    if (includeDrafts != null) result.includeDrafts = includeDrafts;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListNotesRequest._();

  factory ListNotesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListNotesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListNotesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aE<DocumentKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: DocumentKind.values)
    ..aOB(4, _omitFieldNames ? '' : 'includeDrafts')
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotesRequest copyWith(void Function(ListNotesRequest) updates) =>
      super.copyWith((message) => updates(message as ListNotesRequest))
          as ListNotesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListNotesRequest create() => ListNotesRequest._();
  @$core.override
  ListNotesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListNotesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListNotesRequest>(create);
  static ListNotesRequest? _defaultInstance;

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
  DocumentKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(DocumentKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get includeDrafts => $_getBF(3);
  @$pb.TagNumber(4)
  set includeDrafts($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIncludeDrafts() => $_has(3);
  @$pb.TagNumber(4)
  void clearIncludeDrafts() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);
}

class ListNotesResponse extends $pb.GeneratedMessage {
  factory ListNotesResponse({
    $core.Iterable<Document>? documents,
  }) {
    final result = create();
    if (documents != null) result.documents.addAll(documents);
    return result;
  }

  ListNotesResponse._();

  factory ListNotesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListNotesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListNotesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<Document>(1, _omitFieldNames ? '' : 'documents',
        subBuilder: Document.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotesResponse copyWith(void Function(ListNotesResponse) updates) =>
      super.copyWith((message) => updates(message as ListNotesResponse))
          as ListNotesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListNotesResponse create() => ListNotesResponse._();
  @$core.override
  ListNotesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListNotesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListNotesResponse>(create);
  static ListNotesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Document> get documents => $_getList(0);
}

class DefineTemplateRequest extends $pb.GeneratedMessage {
  factory DefineTemplateRequest({
    Template? template,
  }) {
    final result = create();
    if (template != null) result.template = template;
    return result;
  }

  DefineTemplateRequest._();

  factory DefineTemplateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineTemplateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineTemplateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Template>(1, _omitFieldNames ? '' : 'template',
        subBuilder: Template.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineTemplateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineTemplateRequest copyWith(
          void Function(DefineTemplateRequest) updates) =>
      super.copyWith((message) => updates(message as DefineTemplateRequest))
          as DefineTemplateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineTemplateRequest create() => DefineTemplateRequest._();
  @$core.override
  DefineTemplateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineTemplateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineTemplateRequest>(create);
  static DefineTemplateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Template get template => $_getN(0);
  @$pb.TagNumber(1)
  set template(Template value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTemplate() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemplate() => $_clearField(1);
  @$pb.TagNumber(1)
  Template ensureTemplate() => $_ensure(0);
}

class DefineTemplateResponse extends $pb.GeneratedMessage {
  factory DefineTemplateResponse() => create();

  DefineTemplateResponse._();

  factory DefineTemplateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineTemplateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineTemplateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineTemplateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineTemplateResponse copyWith(
          void Function(DefineTemplateResponse) updates) =>
      super.copyWith((message) => updates(message as DefineTemplateResponse))
          as DefineTemplateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineTemplateResponse create() => DefineTemplateResponse._();
  @$core.override
  DefineTemplateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineTemplateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineTemplateResponse>(create);
  static DefineTemplateResponse? _defaultInstance;
}

class ListTemplatesRequest extends $pb.GeneratedMessage {
  factory ListTemplatesRequest({
    DocumentKind? kind,
    $core.bool? includeRetired,
    $core.int? pageSize,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (includeRetired != null) result.includeRetired = includeRetired;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListTemplatesRequest._();

  factory ListTemplatesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTemplatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTemplatesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aE<DocumentKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: DocumentKind.values)
    ..aOB(2, _omitFieldNames ? '' : 'includeRetired')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTemplatesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTemplatesRequest copyWith(void Function(ListTemplatesRequest) updates) =>
      super.copyWith((message) => updates(message as ListTemplatesRequest))
          as ListTemplatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTemplatesRequest create() => ListTemplatesRequest._();
  @$core.override
  ListTemplatesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTemplatesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTemplatesRequest>(create);
  static ListTemplatesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  DocumentKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(DocumentKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get includeRetired => $_getBF(1);
  @$pb.TagNumber(2)
  set includeRetired($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIncludeRetired() => $_has(1);
  @$pb.TagNumber(2)
  void clearIncludeRetired() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListTemplatesResponse extends $pb.GeneratedMessage {
  factory ListTemplatesResponse({
    $core.Iterable<Template>? templates,
  }) {
    final result = create();
    if (templates != null) result.templates.addAll(templates);
    return result;
  }

  ListTemplatesResponse._();

  factory ListTemplatesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTemplatesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTemplatesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<Template>(1, _omitFieldNames ? '' : 'templates',
        subBuilder: Template.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTemplatesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTemplatesResponse copyWith(
          void Function(ListTemplatesResponse) updates) =>
      super.copyWith((message) => updates(message as ListTemplatesResponse))
          as ListTemplatesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTemplatesResponse create() => ListTemplatesResponse._();
  @$core.override
  ListTemplatesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTemplatesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTemplatesResponse>(create);
  static ListTemplatesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Template> get templates => $_getList(0);
}

class RetireTemplateRequest extends $pb.GeneratedMessage {
  factory RetireTemplateRequest({
    $core.String? templateId,
    $core.String? version,
  }) {
    final result = create();
    if (templateId != null) result.templateId = templateId;
    if (version != null) result.version = version;
    return result;
  }

  RetireTemplateRequest._();

  factory RetireTemplateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetireTemplateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetireTemplateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'templateId')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireTemplateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireTemplateRequest copyWith(
          void Function(RetireTemplateRequest) updates) =>
      super.copyWith((message) => updates(message as RetireTemplateRequest))
          as RetireTemplateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetireTemplateRequest create() => RetireTemplateRequest._();
  @$core.override
  RetireTemplateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetireTemplateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetireTemplateRequest>(create);
  static RetireTemplateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get templateId => $_getSZ(0);
  @$pb.TagNumber(1)
  set templateId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTemplateId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemplateId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
}

class RetireTemplateResponse extends $pb.GeneratedMessage {
  factory RetireTemplateResponse() => create();

  RetireTemplateResponse._();

  factory RetireTemplateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetireTemplateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetireTemplateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireTemplateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireTemplateResponse copyWith(
          void Function(RetireTemplateResponse) updates) =>
      super.copyWith((message) => updates(message as RetireTemplateResponse))
          as RetireTemplateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetireTemplateResponse create() => RetireTemplateResponse._();
  @$core.override
  RetireTemplateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetireTemplateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetireTemplateResponse>(create);
  static RetireTemplateResponse? _defaultInstance;
}

class DefineSmartPhraseRequest extends $pb.GeneratedMessage {
  factory DefineSmartPhraseRequest({
    $core.String? shortcut,
    $core.String? expansion,
    $core.bool? shared,
  }) {
    final result = create();
    if (shortcut != null) result.shortcut = shortcut;
    if (expansion != null) result.expansion = expansion;
    if (shared != null) result.shared = shared;
    return result;
  }

  DefineSmartPhraseRequest._();

  factory DefineSmartPhraseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineSmartPhraseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineSmartPhraseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'shortcut')
    ..aOS(2, _omitFieldNames ? '' : 'expansion')
    ..aOB(3, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineSmartPhraseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineSmartPhraseRequest copyWith(
          void Function(DefineSmartPhraseRequest) updates) =>
      super.copyWith((message) => updates(message as DefineSmartPhraseRequest))
          as DefineSmartPhraseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineSmartPhraseRequest create() => DefineSmartPhraseRequest._();
  @$core.override
  DefineSmartPhraseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineSmartPhraseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineSmartPhraseRequest>(create);
  static DefineSmartPhraseRequest? _defaultInstance;

  /// Without its leading dot.
  @$pb.TagNumber(1)
  $core.String get shortcut => $_getSZ(0);
  @$pb.TagNumber(1)
  set shortcut($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShortcut() => $_has(0);
  @$pb.TagNumber(1)
  void clearShortcut() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get expansion => $_getSZ(1);
  @$pb.TagNumber(2)
  set expansion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpansion() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpansion() => $_clearField(2);

  /// A shared phrase changes what everybody's notes say, so it needs the
  /// configuration permission.
  @$pb.TagNumber(3)
  $core.bool get shared => $_getBF(2);
  @$pb.TagNumber(3)
  set shared($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShared() => $_has(2);
  @$pb.TagNumber(3)
  void clearShared() => $_clearField(3);
}

class DefineSmartPhraseResponse extends $pb.GeneratedMessage {
  factory DefineSmartPhraseResponse({
    SmartPhrase? phrase,
  }) {
    final result = create();
    if (phrase != null) result.phrase = phrase;
    return result;
  }

  DefineSmartPhraseResponse._();

  factory DefineSmartPhraseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineSmartPhraseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineSmartPhraseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<SmartPhrase>(1, _omitFieldNames ? '' : 'phrase',
        subBuilder: SmartPhrase.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineSmartPhraseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineSmartPhraseResponse copyWith(
          void Function(DefineSmartPhraseResponse) updates) =>
      super.copyWith((message) => updates(message as DefineSmartPhraseResponse))
          as DefineSmartPhraseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineSmartPhraseResponse create() => DefineSmartPhraseResponse._();
  @$core.override
  DefineSmartPhraseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineSmartPhraseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineSmartPhraseResponse>(create);
  static DefineSmartPhraseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SmartPhrase get phrase => $_getN(0);
  @$pb.TagNumber(1)
  set phrase(SmartPhrase value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPhrase() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhrase() => $_clearField(1);
  @$pb.TagNumber(1)
  SmartPhrase ensurePhrase() => $_ensure(0);
}

class ListSmartPhrasesRequest extends $pb.GeneratedMessage {
  factory ListSmartPhrasesRequest() => create();

  ListSmartPhrasesRequest._();

  factory ListSmartPhrasesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSmartPhrasesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSmartPhrasesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSmartPhrasesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSmartPhrasesRequest copyWith(
          void Function(ListSmartPhrasesRequest) updates) =>
      super.copyWith((message) => updates(message as ListSmartPhrasesRequest))
          as ListSmartPhrasesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSmartPhrasesRequest create() => ListSmartPhrasesRequest._();
  @$core.override
  ListSmartPhrasesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSmartPhrasesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSmartPhrasesRequest>(create);
  static ListSmartPhrasesRequest? _defaultInstance;
}

class ListSmartPhrasesResponse extends $pb.GeneratedMessage {
  factory ListSmartPhrasesResponse({
    $core.Iterable<SmartPhrase>? phrases,
  }) {
    final result = create();
    if (phrases != null) result.phrases.addAll(phrases);
    return result;
  }

  ListSmartPhrasesResponse._();

  factory ListSmartPhrasesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSmartPhrasesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSmartPhrasesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<SmartPhrase>(1, _omitFieldNames ? '' : 'phrases',
        subBuilder: SmartPhrase.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSmartPhrasesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSmartPhrasesResponse copyWith(
          void Function(ListSmartPhrasesResponse) updates) =>
      super.copyWith((message) => updates(message as ListSmartPhrasesResponse))
          as ListSmartPhrasesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSmartPhrasesResponse create() => ListSmartPhrasesResponse._();
  @$core.override
  ListSmartPhrasesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSmartPhrasesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSmartPhrasesResponse>(create);
  static ListSmartPhrasesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SmartPhrase> get phrases => $_getList(0);
}

class RecordProblemRequest extends $pb.GeneratedMessage {
  factory RecordProblemRequest({
    $core.String? patientId,
    $core.String? encounterId,
    Coding? code,
    $core.String? note,
    ProblemStatus? status,
    $0.Timestamp? onsetAt,
    Confidentiality? confidentiality,
    PatientContext? context,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (code != null) result.code = code;
    if (note != null) result.note = note;
    if (status != null) result.status = status;
    if (onsetAt != null) result.onsetAt = onsetAt;
    if (confidentiality != null) result.confidentiality = confidentiality;
    if (context != null) result.context = context;
    return result;
  }

  RecordProblemRequest._();

  factory RecordProblemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordProblemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordProblemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(3, _omitFieldNames ? '' : 'code', subBuilder: Coding.create)
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..aE<ProblemStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: ProblemStatus.values)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'onsetAt',
        subBuilder: $0.Timestamp.create)
    ..aE<Confidentiality>(7, _omitFieldNames ? '' : 'confidentiality',
        enumValues: Confidentiality.values)
    ..aOM<PatientContext>(8, _omitFieldNames ? '' : 'context',
        subBuilder: PatientContext.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordProblemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordProblemRequest copyWith(void Function(RecordProblemRequest) updates) =>
      super.copyWith((message) => updates(message as RecordProblemRequest))
          as RecordProblemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordProblemRequest create() => RecordProblemRequest._();
  @$core.override
  RecordProblemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordProblemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordProblemRequest>(create);
  static RecordProblemRequest? _defaultInstance;

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
  Coding get code => $_getN(2);
  @$pb.TagNumber(3)
  set code(Coding value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);
  @$pb.TagNumber(3)
  Coding ensureCode() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);

  @$pb.TagNumber(5)
  ProblemStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(ProblemStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get onsetAt => $_getN(5);
  @$pb.TagNumber(6)
  set onsetAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOnsetAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearOnsetAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureOnsetAt() => $_ensure(5);

  @$pb.TagNumber(7)
  Confidentiality get confidentiality => $_getN(6);
  @$pb.TagNumber(7)
  set confidentiality(Confidentiality value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasConfidentiality() => $_has(6);
  @$pb.TagNumber(7)
  void clearConfidentiality() => $_clearField(7);

  @$pb.TagNumber(8)
  PatientContext get context => $_getN(7);
  @$pb.TagNumber(8)
  set context(PatientContext value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasContext() => $_has(7);
  @$pb.TagNumber(8)
  void clearContext() => $_clearField(8);
  @$pb.TagNumber(8)
  PatientContext ensureContext() => $_ensure(7);
}

class RecordProblemResponse extends $pb.GeneratedMessage {
  factory RecordProblemResponse({
    Problem? problem,
  }) {
    final result = create();
    if (problem != null) result.problem = problem;
    return result;
  }

  RecordProblemResponse._();

  factory RecordProblemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordProblemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordProblemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Problem>(1, _omitFieldNames ? '' : 'problem',
        subBuilder: Problem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordProblemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordProblemResponse copyWith(
          void Function(RecordProblemResponse) updates) =>
      super.copyWith((message) => updates(message as RecordProblemResponse))
          as RecordProblemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordProblemResponse create() => RecordProblemResponse._();
  @$core.override
  RecordProblemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordProblemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordProblemResponse>(create);
  static RecordProblemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Problem get problem => $_getN(0);
  @$pb.TagNumber(1)
  set problem(Problem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProblem() => $_has(0);
  @$pb.TagNumber(1)
  void clearProblem() => $_clearField(1);
  @$pb.TagNumber(1)
  Problem ensureProblem() => $_ensure(0);
}

class UpdateProblemRequest extends $pb.GeneratedMessage {
  factory UpdateProblemRequest({
    $core.String? problemId,
    ProblemStatus? status,
    $0.Timestamp? resolvedAt,
  }) {
    final result = create();
    if (problemId != null) result.problemId = problemId;
    if (status != null) result.status = status;
    if (resolvedAt != null) result.resolvedAt = resolvedAt;
    return result;
  }

  UpdateProblemRequest._();

  factory UpdateProblemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateProblemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateProblemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'problemId')
    ..aE<ProblemStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: ProblemStatus.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'resolvedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProblemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProblemRequest copyWith(void Function(UpdateProblemRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateProblemRequest))
          as UpdateProblemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateProblemRequest create() => UpdateProblemRequest._();
  @$core.override
  UpdateProblemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateProblemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateProblemRequest>(create);
  static UpdateProblemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get problemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set problemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProblemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProblemId() => $_clearField(1);

  @$pb.TagNumber(2)
  ProblemStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(ProblemStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get resolvedAt => $_getN(2);
  @$pb.TagNumber(3)
  set resolvedAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasResolvedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearResolvedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureResolvedAt() => $_ensure(2);
}

class UpdateProblemResponse extends $pb.GeneratedMessage {
  factory UpdateProblemResponse({
    Problem? problem,
  }) {
    final result = create();
    if (problem != null) result.problem = problem;
    return result;
  }

  UpdateProblemResponse._();

  factory UpdateProblemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateProblemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateProblemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Problem>(1, _omitFieldNames ? '' : 'problem',
        subBuilder: Problem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProblemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProblemResponse copyWith(
          void Function(UpdateProblemResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateProblemResponse))
          as UpdateProblemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateProblemResponse create() => UpdateProblemResponse._();
  @$core.override
  UpdateProblemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateProblemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateProblemResponse>(create);
  static UpdateProblemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Problem get problem => $_getN(0);
  @$pb.TagNumber(1)
  set problem(Problem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProblem() => $_has(0);
  @$pb.TagNumber(1)
  void clearProblem() => $_clearField(1);
  @$pb.TagNumber(1)
  Problem ensureProblem() => $_ensure(0);
}

class ListProblemsRequest extends $pb.GeneratedMessage {
  factory ListProblemsRequest({
    $core.String? patientId,
    $core.bool? activeOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (activeOnly != null) result.activeOnly = activeOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListProblemsRequest._();

  factory ListProblemsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProblemsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProblemsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOB(2, _omitFieldNames ? '' : 'activeOnly')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProblemsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProblemsRequest copyWith(void Function(ListProblemsRequest) updates) =>
      super.copyWith((message) => updates(message as ListProblemsRequest))
          as ListProblemsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProblemsRequest create() => ListProblemsRequest._();
  @$core.override
  ListProblemsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListProblemsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProblemsRequest>(create);
  static ListProblemsRequest? _defaultInstance;

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
}

class ListProblemsResponse extends $pb.GeneratedMessage {
  factory ListProblemsResponse({
    $core.Iterable<Problem>? problems,
  }) {
    final result = create();
    if (problems != null) result.problems.addAll(problems);
    return result;
  }

  ListProblemsResponse._();

  factory ListProblemsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProblemsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProblemsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<Problem>(1, _omitFieldNames ? '' : 'problems',
        subBuilder: Problem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProblemsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProblemsResponse copyWith(void Function(ListProblemsResponse) updates) =>
      super.copyWith((message) => updates(message as ListProblemsResponse))
          as ListProblemsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProblemsResponse create() => ListProblemsResponse._();
  @$core.override
  ListProblemsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListProblemsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProblemsResponse>(create);
  static ListProblemsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Problem> get problems => $_getList(0);
}

class RecordAllergyRequest extends $pb.GeneratedMessage {
  factory RecordAllergyRequest({
    $core.String? patientId,
    $core.String? encounterId,
    Coding? substance,
    AllergyKind? kind,
    AllergyCriticality? criticality,
    AllergyVerification? verification,
    $core.Iterable<Reaction>? reactions,
    $0.Timestamp? onsetAt,
    $core.String? note,
    PatientContext? context,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (substance != null) result.substance = substance;
    if (kind != null) result.kind = kind;
    if (criticality != null) result.criticality = criticality;
    if (verification != null) result.verification = verification;
    if (reactions != null) result.reactions.addAll(reactions);
    if (onsetAt != null) result.onsetAt = onsetAt;
    if (note != null) result.note = note;
    if (context != null) result.context = context;
    return result;
  }

  RecordAllergyRequest._();

  factory RecordAllergyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordAllergyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordAllergyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(3, _omitFieldNames ? '' : 'substance',
        subBuilder: Coding.create)
    ..aE<AllergyKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: AllergyKind.values)
    ..aE<AllergyCriticality>(5, _omitFieldNames ? '' : 'criticality',
        enumValues: AllergyCriticality.values)
    ..aE<AllergyVerification>(6, _omitFieldNames ? '' : 'verification',
        enumValues: AllergyVerification.values)
    ..pPM<Reaction>(7, _omitFieldNames ? '' : 'reactions',
        subBuilder: Reaction.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'onsetAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'note')
    ..aOM<PatientContext>(10, _omitFieldNames ? '' : 'context',
        subBuilder: PatientContext.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAllergyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAllergyRequest copyWith(void Function(RecordAllergyRequest) updates) =>
      super.copyWith((message) => updates(message as RecordAllergyRequest))
          as RecordAllergyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordAllergyRequest create() => RecordAllergyRequest._();
  @$core.override
  RecordAllergyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordAllergyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordAllergyRequest>(create);
  static RecordAllergyRequest? _defaultInstance;

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
  Coding get substance => $_getN(2);
  @$pb.TagNumber(3)
  set substance(Coding value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSubstance() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubstance() => $_clearField(3);
  @$pb.TagNumber(3)
  Coding ensureSubstance() => $_ensure(2);

  @$pb.TagNumber(4)
  AllergyKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(AllergyKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  AllergyCriticality get criticality => $_getN(4);
  @$pb.TagNumber(5)
  set criticality(AllergyCriticality value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCriticality() => $_has(4);
  @$pb.TagNumber(5)
  void clearCriticality() => $_clearField(5);

  @$pb.TagNumber(6)
  AllergyVerification get verification => $_getN(5);
  @$pb.TagNumber(6)
  set verification(AllergyVerification value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasVerification() => $_has(5);
  @$pb.TagNumber(6)
  void clearVerification() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<Reaction> get reactions => $_getList(6);

  @$pb.TagNumber(8)
  $0.Timestamp get onsetAt => $_getN(7);
  @$pb.TagNumber(8)
  set onsetAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasOnsetAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearOnsetAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureOnsetAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get note => $_getSZ(8);
  @$pb.TagNumber(9)
  set note($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasNote() => $_has(8);
  @$pb.TagNumber(9)
  void clearNote() => $_clearField(9);

  @$pb.TagNumber(10)
  PatientContext get context => $_getN(9);
  @$pb.TagNumber(10)
  set context(PatientContext value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasContext() => $_has(9);
  @$pb.TagNumber(10)
  void clearContext() => $_clearField(10);
  @$pb.TagNumber(10)
  PatientContext ensureContext() => $_ensure(9);
}

class RecordAllergyResponse extends $pb.GeneratedMessage {
  factory RecordAllergyResponse({
    Allergy? allergy,
  }) {
    final result = create();
    if (allergy != null) result.allergy = allergy;
    return result;
  }

  RecordAllergyResponse._();

  factory RecordAllergyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordAllergyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordAllergyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Allergy>(1, _omitFieldNames ? '' : 'allergy',
        subBuilder: Allergy.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAllergyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAllergyResponse copyWith(
          void Function(RecordAllergyResponse) updates) =>
      super.copyWith((message) => updates(message as RecordAllergyResponse))
          as RecordAllergyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordAllergyResponse create() => RecordAllergyResponse._();
  @$core.override
  RecordAllergyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordAllergyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordAllergyResponse>(create);
  static RecordAllergyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Allergy get allergy => $_getN(0);
  @$pb.TagNumber(1)
  set allergy(Allergy value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAllergy() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllergy() => $_clearField(1);
  @$pb.TagNumber(1)
  Allergy ensureAllergy() => $_ensure(0);
}

class VerifyAllergyRequest extends $pb.GeneratedMessage {
  factory VerifyAllergyRequest({
    $core.String? allergyId,
    AllergyVerification? verification,
  }) {
    final result = create();
    if (allergyId != null) result.allergyId = allergyId;
    if (verification != null) result.verification = verification;
    return result;
  }

  VerifyAllergyRequest._();

  factory VerifyAllergyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyAllergyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyAllergyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'allergyId')
    ..aE<AllergyVerification>(2, _omitFieldNames ? '' : 'verification',
        enumValues: AllergyVerification.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyAllergyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyAllergyRequest copyWith(void Function(VerifyAllergyRequest) updates) =>
      super.copyWith((message) => updates(message as VerifyAllergyRequest))
          as VerifyAllergyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyAllergyRequest create() => VerifyAllergyRequest._();
  @$core.override
  VerifyAllergyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyAllergyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyAllergyRequest>(create);
  static VerifyAllergyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get allergyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set allergyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAllergyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllergyId() => $_clearField(1);

  @$pb.TagNumber(2)
  AllergyVerification get verification => $_getN(1);
  @$pb.TagNumber(2)
  set verification(AllergyVerification value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasVerification() => $_has(1);
  @$pb.TagNumber(2)
  void clearVerification() => $_clearField(2);
}

class VerifyAllergyResponse extends $pb.GeneratedMessage {
  factory VerifyAllergyResponse({
    Allergy? allergy,
  }) {
    final result = create();
    if (allergy != null) result.allergy = allergy;
    return result;
  }

  VerifyAllergyResponse._();

  factory VerifyAllergyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyAllergyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyAllergyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Allergy>(1, _omitFieldNames ? '' : 'allergy',
        subBuilder: Allergy.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyAllergyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyAllergyResponse copyWith(
          void Function(VerifyAllergyResponse) updates) =>
      super.copyWith((message) => updates(message as VerifyAllergyResponse))
          as VerifyAllergyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyAllergyResponse create() => VerifyAllergyResponse._();
  @$core.override
  VerifyAllergyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyAllergyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyAllergyResponse>(create);
  static VerifyAllergyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Allergy get allergy => $_getN(0);
  @$pb.TagNumber(1)
  set allergy(Allergy value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAllergy() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllergy() => $_clearField(1);
  @$pb.TagNumber(1)
  Allergy ensureAllergy() => $_ensure(0);
}

class ListAllergiesRequest extends $pb.GeneratedMessage {
  factory ListAllergiesRequest({
    $core.String? patientId,
    $core.bool? activeOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (activeOnly != null) result.activeOnly = activeOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListAllergiesRequest._();

  factory ListAllergiesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAllergiesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAllergiesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOB(2, _omitFieldNames ? '' : 'activeOnly')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAllergiesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAllergiesRequest copyWith(void Function(ListAllergiesRequest) updates) =>
      super.copyWith((message) => updates(message as ListAllergiesRequest))
          as ListAllergiesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAllergiesRequest create() => ListAllergiesRequest._();
  @$core.override
  ListAllergiesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAllergiesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAllergiesRequest>(create);
  static ListAllergiesRequest? _defaultInstance;

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
}

class ListAllergiesResponse extends $pb.GeneratedMessage {
  factory ListAllergiesResponse({
    $core.Iterable<Allergy>? allergies,
  }) {
    final result = create();
    if (allergies != null) result.allergies.addAll(allergies);
    return result;
  }

  ListAllergiesResponse._();

  factory ListAllergiesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAllergiesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAllergiesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<Allergy>(1, _omitFieldNames ? '' : 'allergies',
        subBuilder: Allergy.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAllergiesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAllergiesResponse copyWith(
          void Function(ListAllergiesResponse) updates) =>
      super.copyWith((message) => updates(message as ListAllergiesResponse))
          as ListAllergiesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAllergiesResponse create() => ListAllergiesResponse._();
  @$core.override
  ListAllergiesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAllergiesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAllergiesResponse>(create);
  static ListAllergiesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Allergy> get allergies => $_getList(0);
}

class RecordObservationRequest extends $pb.GeneratedMessage {
  factory RecordObservationRequest({
    $core.String? patientId,
    $core.String? encounterId,
    Coding? code,
    Quantity? value,
    $core.String? textValue,
    Coding? codedValue,
    $core.double? referenceLow,
    $core.double? referenceHigh,
    $core.bool? hasReferenceRange,
    $core.String? referenceText,
    Interpretation? interpretation,
    $core.String? interpretationSource,
    ObservationStatus? status,
    $0.Timestamp? effectiveAt,
    $0.Timestamp? issuedAt,
    $core.String? performerId,
    $core.String? deviceId,
    $core.String? sourceSystem,
    Provenance? provenance,
    $core.String? note,
    PatientContext? context,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (code != null) result.code = code;
    if (value != null) result.value = value;
    if (textValue != null) result.textValue = textValue;
    if (codedValue != null) result.codedValue = codedValue;
    if (referenceLow != null) result.referenceLow = referenceLow;
    if (referenceHigh != null) result.referenceHigh = referenceHigh;
    if (hasReferenceRange != null) result.hasReferenceRange = hasReferenceRange;
    if (referenceText != null) result.referenceText = referenceText;
    if (interpretation != null) result.interpretation = interpretation;
    if (interpretationSource != null)
      result.interpretationSource = interpretationSource;
    if (status != null) result.status = status;
    if (effectiveAt != null) result.effectiveAt = effectiveAt;
    if (issuedAt != null) result.issuedAt = issuedAt;
    if (performerId != null) result.performerId = performerId;
    if (deviceId != null) result.deviceId = deviceId;
    if (sourceSystem != null) result.sourceSystem = sourceSystem;
    if (provenance != null) result.provenance = provenance;
    if (note != null) result.note = note;
    if (context != null) result.context = context;
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
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(3, _omitFieldNames ? '' : 'code', subBuilder: Coding.create)
    ..aOM<Quantity>(4, _omitFieldNames ? '' : 'value',
        subBuilder: Quantity.create)
    ..aOS(5, _omitFieldNames ? '' : 'textValue')
    ..aOM<Coding>(6, _omitFieldNames ? '' : 'codedValue',
        subBuilder: Coding.create)
    ..aD(7, _omitFieldNames ? '' : 'referenceLow')
    ..aD(8, _omitFieldNames ? '' : 'referenceHigh')
    ..aOB(9, _omitFieldNames ? '' : 'hasReferenceRange')
    ..aOS(10, _omitFieldNames ? '' : 'referenceText')
    ..aE<Interpretation>(11, _omitFieldNames ? '' : 'interpretation',
        enumValues: Interpretation.values)
    ..aOS(12, _omitFieldNames ? '' : 'interpretationSource')
    ..aE<ObservationStatus>(13, _omitFieldNames ? '' : 'status',
        enumValues: ObservationStatus.values)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'effectiveAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'issuedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'performerId')
    ..aOS(17, _omitFieldNames ? '' : 'deviceId')
    ..aOS(18, _omitFieldNames ? '' : 'sourceSystem')
    ..aOM<Provenance>(19, _omitFieldNames ? '' : 'provenance',
        subBuilder: Provenance.create)
    ..aOS(20, _omitFieldNames ? '' : 'note')
    ..aOM<PatientContext>(21, _omitFieldNames ? '' : 'context',
        subBuilder: PatientContext.create)
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
  Coding get code => $_getN(2);
  @$pb.TagNumber(3)
  set code(Coding value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);
  @$pb.TagNumber(3)
  Coding ensureCode() => $_ensure(2);

  @$pb.TagNumber(4)
  Quantity get value => $_getN(3);
  @$pb.TagNumber(4)
  set value(Quantity value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => $_clearField(4);
  @$pb.TagNumber(4)
  Quantity ensureValue() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get textValue => $_getSZ(4);
  @$pb.TagNumber(5)
  set textValue($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTextValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearTextValue() => $_clearField(5);

  @$pb.TagNumber(6)
  Coding get codedValue => $_getN(5);
  @$pb.TagNumber(6)
  set codedValue(Coding value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCodedValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearCodedValue() => $_clearField(6);
  @$pb.TagNumber(6)
  Coding ensureCodedValue() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.double get referenceLow => $_getN(6);
  @$pb.TagNumber(7)
  set referenceLow($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReferenceLow() => $_has(6);
  @$pb.TagNumber(7)
  void clearReferenceLow() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get referenceHigh => $_getN(7);
  @$pb.TagNumber(8)
  set referenceHigh($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReferenceHigh() => $_has(7);
  @$pb.TagNumber(8)
  void clearReferenceHigh() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get hasReferenceRange => $_getBF(8);
  @$pb.TagNumber(9)
  set hasReferenceRange($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasHasReferenceRange() => $_has(8);
  @$pb.TagNumber(9)
  void clearHasReferenceRange() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get referenceText => $_getSZ(9);
  @$pb.TagNumber(10)
  set referenceText($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasReferenceText() => $_has(9);
  @$pb.TagNumber(10)
  void clearReferenceText() => $_clearField(10);

  /// Supplied by the authoritative diagnostic service. The server never infers
  /// it (SRS-CLN-011).
  @$pb.TagNumber(11)
  Interpretation get interpretation => $_getN(10);
  @$pb.TagNumber(11)
  set interpretation(Interpretation value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasInterpretation() => $_has(10);
  @$pb.TagNumber(11)
  void clearInterpretation() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get interpretationSource => $_getSZ(11);
  @$pb.TagNumber(12)
  set interpretationSource($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasInterpretationSource() => $_has(11);
  @$pb.TagNumber(12)
  void clearInterpretationSource() => $_clearField(12);

  @$pb.TagNumber(13)
  ObservationStatus get status => $_getN(12);
  @$pb.TagNumber(13)
  set status(ObservationStatus value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasStatus() => $_has(12);
  @$pb.TagNumber(13)
  void clearStatus() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get effectiveAt => $_getN(13);
  @$pb.TagNumber(14)
  set effectiveAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasEffectiveAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearEffectiveAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureEffectiveAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $0.Timestamp get issuedAt => $_getN(14);
  @$pb.TagNumber(15)
  set issuedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasIssuedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearIssuedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureIssuedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get performerId => $_getSZ(15);
  @$pb.TagNumber(16)
  set performerId($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasPerformerId() => $_has(15);
  @$pb.TagNumber(16)
  void clearPerformerId() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get deviceId => $_getSZ(16);
  @$pb.TagNumber(17)
  set deviceId($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasDeviceId() => $_has(16);
  @$pb.TagNumber(17)
  void clearDeviceId() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get sourceSystem => $_getSZ(17);
  @$pb.TagNumber(18)
  set sourceSystem($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasSourceSystem() => $_has(17);
  @$pb.TagNumber(18)
  void clearSourceSystem() => $_clearField(18);

  /// Records where an imported result came from (SRS-CLN-010).
  @$pb.TagNumber(19)
  Provenance get provenance => $_getN(18);
  @$pb.TagNumber(19)
  set provenance(Provenance value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasProvenance() => $_has(18);
  @$pb.TagNumber(19)
  void clearProvenance() => $_clearField(19);
  @$pb.TagNumber(19)
  Provenance ensureProvenance() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.String get note => $_getSZ(19);
  @$pb.TagNumber(20)
  set note($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasNote() => $_has(19);
  @$pb.TagNumber(20)
  void clearNote() => $_clearField(20);

  @$pb.TagNumber(21)
  PatientContext get context => $_getN(20);
  @$pb.TagNumber(21)
  set context(PatientContext value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasContext() => $_has(20);
  @$pb.TagNumber(21)
  void clearContext() => $_clearField(21);
  @$pb.TagNumber(21)
  PatientContext ensureContext() => $_ensure(20);
}

class RecordObservationResponse extends $pb.GeneratedMessage {
  factory RecordObservationResponse({
    Observation? observation,
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
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Observation>(1, _omitFieldNames ? '' : 'observation',
        subBuilder: Observation.create)
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

class ListObservationsRequest extends $pb.GeneratedMessage {
  factory ListObservationsRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? code,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (code != null) result.code = code;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListObservationsRequest._();

  factory ListObservationsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListObservationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListObservationsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListObservationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListObservationsRequest copyWith(
          void Function(ListObservationsRequest) updates) =>
      super.copyWith((message) => updates(message as ListObservationsRequest))
          as ListObservationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListObservationsRequest create() => ListObservationsRequest._();
  @$core.override
  ListObservationsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListObservationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListObservationsRequest>(create);
  static ListObservationsRequest? _defaultInstance;

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

  /// Narrows to one measurement, which is what a trend asks for.
  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

class ListObservationsResponse extends $pb.GeneratedMessage {
  factory ListObservationsResponse({
    $core.Iterable<Observation>? observations,
  }) {
    final result = create();
    if (observations != null) result.observations.addAll(observations);
    return result;
  }

  ListObservationsResponse._();

  factory ListObservationsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListObservationsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListObservationsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<Observation>(1, _omitFieldNames ? '' : 'observations',
        subBuilder: Observation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListObservationsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListObservationsResponse copyWith(
          void Function(ListObservationsResponse) updates) =>
      super.copyWith((message) => updates(message as ListObservationsResponse))
          as ListObservationsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListObservationsResponse create() => ListObservationsResponse._();
  @$core.override
  ListObservationsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListObservationsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListObservationsResponse>(create);
  static ListObservationsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Observation> get observations => $_getList(0);
}

class CriticalResult extends $pb.GeneratedMessage {
  factory CriticalResult({
    Observation? observation,
    $core.int? dueEscalations,
  }) {
    final result = create();
    if (observation != null) result.observation = observation;
    if (dueEscalations != null) result.dueEscalations = dueEscalations;
    return result;
  }

  CriticalResult._();

  factory CriticalResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CriticalResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CriticalResult',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Observation>(1, _omitFieldNames ? '' : 'observation',
        subBuilder: Observation.create)
    ..aI(2, _omitFieldNames ? '' : 'dueEscalations')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CriticalResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CriticalResult copyWith(void Function(CriticalResult) updates) =>
      super.copyWith((message) => updates(message as CriticalResult))
          as CriticalResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CriticalResult create() => CriticalResult._();
  @$core.override
  CriticalResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CriticalResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CriticalResult>(create);
  static CriticalResult? _defaultInstance;

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

  /// How many times this should have escalated by now (SRS-CLN-012). Computed
  /// rather than stored, so a policy change takes effect on results already
  /// outstanding.
  @$pb.TagNumber(2)
  $core.int get dueEscalations => $_getIZ(1);
  @$pb.TagNumber(2)
  set dueEscalations($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDueEscalations() => $_has(1);
  @$pb.TagNumber(2)
  void clearDueEscalations() => $_clearField(2);
}

class ListCriticalResultsRequest extends $pb.GeneratedMessage {
  factory ListCriticalResultsRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListCriticalResultsRequest._();

  factory ListCriticalResultsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCriticalResultsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCriticalResultsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCriticalResultsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCriticalResultsRequest copyWith(
          void Function(ListCriticalResultsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListCriticalResultsRequest))
          as ListCriticalResultsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCriticalResultsRequest create() => ListCriticalResultsRequest._();
  @$core.override
  ListCriticalResultsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCriticalResultsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCriticalResultsRequest>(create);
  static ListCriticalResultsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListCriticalResultsResponse extends $pb.GeneratedMessage {
  factory ListCriticalResultsResponse({
    $core.Iterable<CriticalResult>? results,
  }) {
    final result = create();
    if (results != null) result.results.addAll(results);
    return result;
  }

  ListCriticalResultsResponse._();

  factory ListCriticalResultsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCriticalResultsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCriticalResultsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<CriticalResult>(1, _omitFieldNames ? '' : 'results',
        subBuilder: CriticalResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCriticalResultsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCriticalResultsResponse copyWith(
          void Function(ListCriticalResultsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListCriticalResultsResponse))
          as ListCriticalResultsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCriticalResultsResponse create() =>
      ListCriticalResultsResponse._();
  @$core.override
  ListCriticalResultsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCriticalResultsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCriticalResultsResponse>(create);
  static ListCriticalResultsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CriticalResult> get results => $_getList(0);
}

class AcknowledgeCriticalResultRequest extends $pb.GeneratedMessage {
  factory AcknowledgeCriticalResultRequest({
    $core.String? observationId,
    $core.String? action,
  }) {
    final result = create();
    if (observationId != null) result.observationId = observationId;
    if (action != null) result.action = action;
    return result;
  }

  AcknowledgeCriticalResultRequest._();

  factory AcknowledgeCriticalResultRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgeCriticalResultRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgeCriticalResultRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'observationId')
    ..aOS(2, _omitFieldNames ? '' : 'action')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeCriticalResultRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeCriticalResultRequest copyWith(
          void Function(AcknowledgeCriticalResultRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AcknowledgeCriticalResultRequest))
          as AcknowledgeCriticalResultRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeCriticalResultRequest create() =>
      AcknowledgeCriticalResultRequest._();
  @$core.override
  AcknowledgeCriticalResultRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeCriticalResultRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgeCriticalResultRequest>(
          create);
  static AcknowledgeCriticalResultRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get observationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set observationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasObservationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearObservationId() => $_clearField(1);

  /// Mandatory: "seen" is not a clinical response to a potassium of 6.9.
  @$pb.TagNumber(2)
  $core.String get action => $_getSZ(1);
  @$pb.TagNumber(2)
  set action($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);
}

class AcknowledgeCriticalResultResponse extends $pb.GeneratedMessage {
  factory AcknowledgeCriticalResultResponse({
    CriticalAcknowledgement? acknowledgement,
  }) {
    final result = create();
    if (acknowledgement != null) result.acknowledgement = acknowledgement;
    return result;
  }

  AcknowledgeCriticalResultResponse._();

  factory AcknowledgeCriticalResultResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgeCriticalResultResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgeCriticalResultResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<CriticalAcknowledgement>(1, _omitFieldNames ? '' : 'acknowledgement',
        subBuilder: CriticalAcknowledgement.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeCriticalResultResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeCriticalResultResponse copyWith(
          void Function(AcknowledgeCriticalResultResponse) updates) =>
      super.copyWith((message) =>
              updates(message as AcknowledgeCriticalResultResponse))
          as AcknowledgeCriticalResultResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeCriticalResultResponse create() =>
      AcknowledgeCriticalResultResponse._();
  @$core.override
  AcknowledgeCriticalResultResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeCriticalResultResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgeCriticalResultResponse>(
          create);
  static AcknowledgeCriticalResultResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CriticalAcknowledgement get acknowledgement => $_getN(0);
  @$pb.TagNumber(1)
  set acknowledgement(CriticalAcknowledgement value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAcknowledgement() => $_has(0);
  @$pb.TagNumber(1)
  void clearAcknowledgement() => $_clearField(1);
  @$pb.TagNumber(1)
  CriticalAcknowledgement ensureAcknowledgement() => $_ensure(0);
}

class RecordProcedureRequest extends $pb.GeneratedMessage {
  factory RecordProcedureRequest({
    $core.String? patientId,
    $core.String? encounterId,
    Coding? code,
    ProcedureStatus? status,
    Coding? indication,
    $core.Iterable<Performer>? performers,
    Coding? bodySite,
    Laterality? laterality,
    $core.String? outcome,
    $core.Iterable<Coding>? complications,
    $core.Iterable<$core.String>? orderIds,
    $core.Iterable<$core.String>? deviceIds,
    $core.Iterable<$core.String>? specimenIds,
    $0.Timestamp? performedStart,
    $0.Timestamp? performedEnd,
    $core.String? note,
    $core.bool? requireConsent,
    PatientContext? context,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (code != null) result.code = code;
    if (status != null) result.status = status;
    if (indication != null) result.indication = indication;
    if (performers != null) result.performers.addAll(performers);
    if (bodySite != null) result.bodySite = bodySite;
    if (laterality != null) result.laterality = laterality;
    if (outcome != null) result.outcome = outcome;
    if (complications != null) result.complications.addAll(complications);
    if (orderIds != null) result.orderIds.addAll(orderIds);
    if (deviceIds != null) result.deviceIds.addAll(deviceIds);
    if (specimenIds != null) result.specimenIds.addAll(specimenIds);
    if (performedStart != null) result.performedStart = performedStart;
    if (performedEnd != null) result.performedEnd = performedEnd;
    if (note != null) result.note = note;
    if (requireConsent != null) result.requireConsent = requireConsent;
    if (context != null) result.context = context;
    return result;
  }

  RecordProcedureRequest._();

  factory RecordProcedureRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordProcedureRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordProcedureRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(3, _omitFieldNames ? '' : 'code', subBuilder: Coding.create)
    ..aE<ProcedureStatus>(4, _omitFieldNames ? '' : 'status',
        enumValues: ProcedureStatus.values)
    ..aOM<Coding>(5, _omitFieldNames ? '' : 'indication',
        subBuilder: Coding.create)
    ..pPM<Performer>(6, _omitFieldNames ? '' : 'performers',
        subBuilder: Performer.create)
    ..aOM<Coding>(7, _omitFieldNames ? '' : 'bodySite',
        subBuilder: Coding.create)
    ..aE<Laterality>(8, _omitFieldNames ? '' : 'laterality',
        enumValues: Laterality.values)
    ..aOS(9, _omitFieldNames ? '' : 'outcome')
    ..pPM<Coding>(10, _omitFieldNames ? '' : 'complications',
        subBuilder: Coding.create)
    ..pPS(11, _omitFieldNames ? '' : 'orderIds')
    ..pPS(12, _omitFieldNames ? '' : 'deviceIds')
    ..pPS(13, _omitFieldNames ? '' : 'specimenIds')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'performedStart',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'performedEnd',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'note')
    ..aOB(17, _omitFieldNames ? '' : 'requireConsent')
    ..aOM<PatientContext>(18, _omitFieldNames ? '' : 'context',
        subBuilder: PatientContext.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordProcedureRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordProcedureRequest copyWith(
          void Function(RecordProcedureRequest) updates) =>
      super.copyWith((message) => updates(message as RecordProcedureRequest))
          as RecordProcedureRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordProcedureRequest create() => RecordProcedureRequest._();
  @$core.override
  RecordProcedureRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordProcedureRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordProcedureRequest>(create);
  static RecordProcedureRequest? _defaultInstance;

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
  Coding get code => $_getN(2);
  @$pb.TagNumber(3)
  set code(Coding value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);
  @$pb.TagNumber(3)
  Coding ensureCode() => $_ensure(2);

  @$pb.TagNumber(4)
  ProcedureStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(ProcedureStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  Coding get indication => $_getN(4);
  @$pb.TagNumber(5)
  set indication(Coding value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasIndication() => $_has(4);
  @$pb.TagNumber(5)
  void clearIndication() => $_clearField(5);
  @$pb.TagNumber(5)
  Coding ensureIndication() => $_ensure(4);

  @$pb.TagNumber(6)
  $pb.PbList<Performer> get performers => $_getList(5);

  @$pb.TagNumber(7)
  Coding get bodySite => $_getN(6);
  @$pb.TagNumber(7)
  set bodySite(Coding value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasBodySite() => $_has(6);
  @$pb.TagNumber(7)
  void clearBodySite() => $_clearField(7);
  @$pb.TagNumber(7)
  Coding ensureBodySite() => $_ensure(6);

  @$pb.TagNumber(8)
  Laterality get laterality => $_getN(7);
  @$pb.TagNumber(8)
  set laterality(Laterality value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasLaterality() => $_has(7);
  @$pb.TagNumber(8)
  void clearLaterality() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get outcome => $_getSZ(8);
  @$pb.TagNumber(9)
  set outcome($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOutcome() => $_has(8);
  @$pb.TagNumber(9)
  void clearOutcome() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<Coding> get complications => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get orderIds => $_getList(10);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get deviceIds => $_getList(11);

  @$pb.TagNumber(13)
  $pb.PbList<$core.String> get specimenIds => $_getList(12);

  @$pb.TagNumber(14)
  $0.Timestamp get performedStart => $_getN(13);
  @$pb.TagNumber(14)
  set performedStart($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasPerformedStart() => $_has(13);
  @$pb.TagNumber(14)
  void clearPerformedStart() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensurePerformedStart() => $_ensure(13);

  @$pb.TagNumber(15)
  $0.Timestamp get performedEnd => $_getN(14);
  @$pb.TagNumber(15)
  set performedEnd($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasPerformedEnd() => $_has(14);
  @$pb.TagNumber(15)
  void clearPerformedEnd() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensurePerformedEnd() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get note => $_getSZ(15);
  @$pb.TagNumber(16)
  set note($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasNote() => $_has(15);
  @$pb.TagNumber(16)
  void clearNote() => $_clearField(16);

  /// Checks that the patient consented to this procedure before recording it
  /// (SRS-CLN-013).
  @$pb.TagNumber(17)
  $core.bool get requireConsent => $_getBF(16);
  @$pb.TagNumber(17)
  set requireConsent($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasRequireConsent() => $_has(16);
  @$pb.TagNumber(17)
  void clearRequireConsent() => $_clearField(17);

  @$pb.TagNumber(18)
  PatientContext get context => $_getN(17);
  @$pb.TagNumber(18)
  set context(PatientContext value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasContext() => $_has(17);
  @$pb.TagNumber(18)
  void clearContext() => $_clearField(18);
  @$pb.TagNumber(18)
  PatientContext ensureContext() => $_ensure(17);
}

class RecordProcedureResponse extends $pb.GeneratedMessage {
  factory RecordProcedureResponse({
    Procedure? procedure,
  }) {
    final result = create();
    if (procedure != null) result.procedure = procedure;
    return result;
  }

  RecordProcedureResponse._();

  factory RecordProcedureResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordProcedureResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordProcedureResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Procedure>(1, _omitFieldNames ? '' : 'procedure',
        subBuilder: Procedure.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordProcedureResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordProcedureResponse copyWith(
          void Function(RecordProcedureResponse) updates) =>
      super.copyWith((message) => updates(message as RecordProcedureResponse))
          as RecordProcedureResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordProcedureResponse create() => RecordProcedureResponse._();
  @$core.override
  RecordProcedureResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordProcedureResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordProcedureResponse>(create);
  static RecordProcedureResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Procedure get procedure => $_getN(0);
  @$pb.TagNumber(1)
  set procedure(Procedure value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProcedure() => $_has(0);
  @$pb.TagNumber(1)
  void clearProcedure() => $_clearField(1);
  @$pb.TagNumber(1)
  Procedure ensureProcedure() => $_ensure(0);
}

class ListProceduresRequest extends $pb.GeneratedMessage {
  factory ListProceduresRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListProceduresRequest._();

  factory ListProceduresRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProceduresRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProceduresRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProceduresRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProceduresRequest copyWith(
          void Function(ListProceduresRequest) updates) =>
      super.copyWith((message) => updates(message as ListProceduresRequest))
          as ListProceduresRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProceduresRequest create() => ListProceduresRequest._();
  @$core.override
  ListProceduresRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListProceduresRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProceduresRequest>(create);
  static ListProceduresRequest? _defaultInstance;

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
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListProceduresResponse extends $pb.GeneratedMessage {
  factory ListProceduresResponse({
    $core.Iterable<Procedure>? procedures,
  }) {
    final result = create();
    if (procedures != null) result.procedures.addAll(procedures);
    return result;
  }

  ListProceduresResponse._();

  factory ListProceduresResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProceduresResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProceduresResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<Procedure>(1, _omitFieldNames ? '' : 'procedures',
        subBuilder: Procedure.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProceduresResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProceduresResponse copyWith(
          void Function(ListProceduresResponse) updates) =>
      super.copyWith((message) => updates(message as ListProceduresResponse))
          as ListProceduresResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProceduresResponse create() => ListProceduresResponse._();
  @$core.override
  ListProceduresResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListProceduresResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProceduresResponse>(create);
  static ListProceduresResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Procedure> get procedures => $_getList(0);
}

class CreateCarePlanRequest extends $pb.GeneratedMessage {
  factory CreateCarePlanRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? title,
    $core.Iterable<$core.String>? problemIds,
    $core.Iterable<Goal>? goals,
    $core.Iterable<Activity>? activities,
    $core.String? ownerId,
    $0.Timestamp? startsAt,
    $0.Timestamp? endsAt,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (title != null) result.title = title;
    if (problemIds != null) result.problemIds.addAll(problemIds);
    if (goals != null) result.goals.addAll(goals);
    if (activities != null) result.activities.addAll(activities);
    if (ownerId != null) result.ownerId = ownerId;
    if (startsAt != null) result.startsAt = startsAt;
    if (endsAt != null) result.endsAt = endsAt;
    return result;
  }

  CreateCarePlanRequest._();

  factory CreateCarePlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateCarePlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateCarePlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..pPS(4, _omitFieldNames ? '' : 'problemIds')
    ..pPM<Goal>(5, _omitFieldNames ? '' : 'goals', subBuilder: Goal.create)
    ..pPM<Activity>(6, _omitFieldNames ? '' : 'activities',
        subBuilder: Activity.create)
    ..aOS(7, _omitFieldNames ? '' : 'ownerId')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'endsAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateCarePlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateCarePlanRequest copyWith(
          void Function(CreateCarePlanRequest) updates) =>
      super.copyWith((message) => updates(message as CreateCarePlanRequest))
          as CreateCarePlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateCarePlanRequest create() => CreateCarePlanRequest._();
  @$core.override
  CreateCarePlanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateCarePlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateCarePlanRequest>(create);
  static CreateCarePlanRequest? _defaultInstance;

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
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get problemIds => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<Goal> get goals => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<Activity> get activities => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get ownerId => $_getSZ(6);
  @$pb.TagNumber(7)
  set ownerId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOwnerId() => $_has(6);
  @$pb.TagNumber(7)
  void clearOwnerId() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get startsAt => $_getN(7);
  @$pb.TagNumber(8)
  set startsAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStartsAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearStartsAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureStartsAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Timestamp get endsAt => $_getN(8);
  @$pb.TagNumber(9)
  set endsAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasEndsAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearEndsAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureEndsAt() => $_ensure(8);
}

class CreateCarePlanResponse extends $pb.GeneratedMessage {
  factory CreateCarePlanResponse({
    CarePlan? carePlan,
  }) {
    final result = create();
    if (carePlan != null) result.carePlan = carePlan;
    return result;
  }

  CreateCarePlanResponse._();

  factory CreateCarePlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateCarePlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateCarePlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<CarePlan>(1, _omitFieldNames ? '' : 'carePlan',
        subBuilder: CarePlan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateCarePlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateCarePlanResponse copyWith(
          void Function(CreateCarePlanResponse) updates) =>
      super.copyWith((message) => updates(message as CreateCarePlanResponse))
          as CreateCarePlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateCarePlanResponse create() => CreateCarePlanResponse._();
  @$core.override
  CreateCarePlanResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateCarePlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateCarePlanResponse>(create);
  static CreateCarePlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CarePlan get carePlan => $_getN(0);
  @$pb.TagNumber(1)
  set carePlan(CarePlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCarePlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearCarePlan() => $_clearField(1);
  @$pb.TagNumber(1)
  CarePlan ensureCarePlan() => $_ensure(0);
}

class UpdateCarePlanRequest extends $pb.GeneratedMessage {
  factory UpdateCarePlanRequest({
    $core.String? carePlanId,
    CarePlanStatus? status,
    $core.Iterable<Goal>? goals,
    $core.Iterable<Activity>? activities,
    $core.Iterable<$core.String>? problemIds,
  }) {
    final result = create();
    if (carePlanId != null) result.carePlanId = carePlanId;
    if (status != null) result.status = status;
    if (goals != null) result.goals.addAll(goals);
    if (activities != null) result.activities.addAll(activities);
    if (problemIds != null) result.problemIds.addAll(problemIds);
    return result;
  }

  UpdateCarePlanRequest._();

  factory UpdateCarePlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateCarePlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateCarePlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'carePlanId')
    ..aE<CarePlanStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: CarePlanStatus.values)
    ..pPM<Goal>(3, _omitFieldNames ? '' : 'goals', subBuilder: Goal.create)
    ..pPM<Activity>(4, _omitFieldNames ? '' : 'activities',
        subBuilder: Activity.create)
    ..pPS(5, _omitFieldNames ? '' : 'problemIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateCarePlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateCarePlanRequest copyWith(
          void Function(UpdateCarePlanRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateCarePlanRequest))
          as UpdateCarePlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateCarePlanRequest create() => UpdateCarePlanRequest._();
  @$core.override
  UpdateCarePlanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateCarePlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateCarePlanRequest>(create);
  static UpdateCarePlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get carePlanId => $_getSZ(0);
  @$pb.TagNumber(1)
  set carePlanId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCarePlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCarePlanId() => $_clearField(1);

  @$pb.TagNumber(2)
  CarePlanStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(CarePlanStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<Goal> get goals => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<Activity> get activities => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get problemIds => $_getList(4);
}

class UpdateCarePlanResponse extends $pb.GeneratedMessage {
  factory UpdateCarePlanResponse({
    CarePlan? carePlan,
  }) {
    final result = create();
    if (carePlan != null) result.carePlan = carePlan;
    return result;
  }

  UpdateCarePlanResponse._();

  factory UpdateCarePlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateCarePlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateCarePlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<CarePlan>(1, _omitFieldNames ? '' : 'carePlan',
        subBuilder: CarePlan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateCarePlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateCarePlanResponse copyWith(
          void Function(UpdateCarePlanResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateCarePlanResponse))
          as UpdateCarePlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateCarePlanResponse create() => UpdateCarePlanResponse._();
  @$core.override
  UpdateCarePlanResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateCarePlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateCarePlanResponse>(create);
  static UpdateCarePlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CarePlan get carePlan => $_getN(0);
  @$pb.TagNumber(1)
  set carePlan(CarePlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCarePlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearCarePlan() => $_clearField(1);
  @$pb.TagNumber(1)
  CarePlan ensureCarePlan() => $_ensure(0);
}

class ListCarePlansRequest extends $pb.GeneratedMessage {
  factory ListCarePlansRequest({
    $core.String? patientId,
    $core.bool? activeOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (activeOnly != null) result.activeOnly = activeOnly;
    if (pageSize != null) result.pageSize = pageSize;
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
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOB(2, _omitFieldNames ? '' : 'activeOnly')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
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
}

class ListCarePlansResponse extends $pb.GeneratedMessage {
  factory ListCarePlansResponse({
    $core.Iterable<CarePlan>? carePlans,
  }) {
    final result = create();
    if (carePlans != null) result.carePlans.addAll(carePlans);
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
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<CarePlan>(1, _omitFieldNames ? '' : 'carePlans',
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
  $pb.PbList<CarePlan> get carePlans => $_getList(0);
}

class GetBannerRequest extends $pb.GeneratedMessage {
  factory GetBannerRequest({
    $core.String? patientId,
    $core.String? encounterContext,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterContext != null) result.encounterContext = encounterContext;
    return result;
  }

  GetBannerRequest._();

  factory GetBannerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBannerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBannerRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterContext')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBannerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBannerRequest copyWith(void Function(GetBannerRequest) updates) =>
      super.copyWith((message) => updates(message as GetBannerRequest))
          as GetBannerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBannerRequest create() => GetBannerRequest._();
  @$core.override
  GetBannerRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBannerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBannerRequest>(create);
  static GetBannerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  /// "Ward 4, inpatient, day 3". Supplied by the caller because it is the
  /// encounter context's fact, not this one's.
  @$pb.TagNumber(2)
  $core.String get encounterContext => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterContext($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterContext() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterContext() => $_clearField(2);
}

class GetBannerResponse extends $pb.GeneratedMessage {
  factory GetBannerResponse({
    Banner? banner,
  }) {
    final result = create();
    if (banner != null) result.banner = banner;
    return result;
  }

  GetBannerResponse._();

  factory GetBannerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBannerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBannerResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Banner>(1, _omitFieldNames ? '' : 'banner', subBuilder: Banner.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBannerResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBannerResponse copyWith(void Function(GetBannerResponse) updates) =>
      super.copyWith((message) => updates(message as GetBannerResponse))
          as GetBannerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBannerResponse create() => GetBannerResponse._();
  @$core.override
  GetBannerResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBannerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBannerResponse>(create);
  static GetBannerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Banner get banner => $_getN(0);
  @$pb.TagNumber(1)
  set banner(Banner value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBanner() => $_has(0);
  @$pb.TagNumber(1)
  void clearBanner() => $_clearField(1);
  @$pb.TagNumber(1)
  Banner ensureBanner() => $_ensure(0);
}

class RecordConsentRequest extends $pb.GeneratedMessage {
  factory RecordConsentRequest({
    $core.String? patientId,
    $core.String? encounterId,
    ConsentKind? kind,
    Coding? procedureCode,
    ConsentStatus? status,
    ConsentGiver? givenBy,
    $core.String? givenByName,
    $core.String? documentId,
    $core.String? witnessId,
    $0.Timestamp? validFrom,
    $0.Timestamp? validUntil,
    $core.String? note,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (kind != null) result.kind = kind;
    if (procedureCode != null) result.procedureCode = procedureCode;
    if (status != null) result.status = status;
    if (givenBy != null) result.givenBy = givenBy;
    if (givenByName != null) result.givenByName = givenByName;
    if (documentId != null) result.documentId = documentId;
    if (witnessId != null) result.witnessId = witnessId;
    if (validFrom != null) result.validFrom = validFrom;
    if (validUntil != null) result.validUntil = validUntil;
    if (note != null) result.note = note;
    return result;
  }

  RecordConsentRequest._();

  factory RecordConsentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordConsentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordConsentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aE<ConsentKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: ConsentKind.values)
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'procedureCode',
        subBuilder: Coding.create)
    ..aE<ConsentStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: ConsentStatus.values)
    ..aE<ConsentGiver>(6, _omitFieldNames ? '' : 'givenBy',
        enumValues: ConsentGiver.values)
    ..aOS(7, _omitFieldNames ? '' : 'givenByName')
    ..aOS(8, _omitFieldNames ? '' : 'documentId')
    ..aOS(9, _omitFieldNames ? '' : 'witnessId')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'validFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'validUntil',
        subBuilder: $0.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordConsentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordConsentRequest copyWith(void Function(RecordConsentRequest) updates) =>
      super.copyWith((message) => updates(message as RecordConsentRequest))
          as RecordConsentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordConsentRequest create() => RecordConsentRequest._();
  @$core.override
  RecordConsentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordConsentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordConsentRequest>(create);
  static RecordConsentRequest? _defaultInstance;

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
  ConsentKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(ConsentKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  Coding get procedureCode => $_getN(3);
  @$pb.TagNumber(4)
  set procedureCode(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasProcedureCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearProcedureCode() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureProcedureCode() => $_ensure(3);

  @$pb.TagNumber(5)
  ConsentStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(ConsentStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  ConsentGiver get givenBy => $_getN(5);
  @$pb.TagNumber(6)
  set givenBy(ConsentGiver value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasGivenBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearGivenBy() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get givenByName => $_getSZ(6);
  @$pb.TagNumber(7)
  set givenByName($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasGivenByName() => $_has(6);
  @$pb.TagNumber(7)
  void clearGivenByName() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get documentId => $_getSZ(7);
  @$pb.TagNumber(8)
  set documentId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDocumentId() => $_has(7);
  @$pb.TagNumber(8)
  void clearDocumentId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get witnessId => $_getSZ(8);
  @$pb.TagNumber(9)
  set witnessId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasWitnessId() => $_has(8);
  @$pb.TagNumber(9)
  void clearWitnessId() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get validFrom => $_getN(9);
  @$pb.TagNumber(10)
  set validFrom($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasValidFrom() => $_has(9);
  @$pb.TagNumber(10)
  void clearValidFrom() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureValidFrom() => $_ensure(9);

  @$pb.TagNumber(11)
  $0.Timestamp get validUntil => $_getN(10);
  @$pb.TagNumber(11)
  set validUntil($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasValidUntil() => $_has(10);
  @$pb.TagNumber(11)
  void clearValidUntil() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureValidUntil() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get note => $_getSZ(11);
  @$pb.TagNumber(12)
  set note($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasNote() => $_has(11);
  @$pb.TagNumber(12)
  void clearNote() => $_clearField(12);
}

class RecordConsentResponse extends $pb.GeneratedMessage {
  factory RecordConsentResponse({
    ClinicalConsent? consent,
  }) {
    final result = create();
    if (consent != null) result.consent = consent;
    return result;
  }

  RecordConsentResponse._();

  factory RecordConsentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordConsentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordConsentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<ClinicalConsent>(1, _omitFieldNames ? '' : 'consent',
        subBuilder: ClinicalConsent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordConsentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordConsentResponse copyWith(
          void Function(RecordConsentResponse) updates) =>
      super.copyWith((message) => updates(message as RecordConsentResponse))
          as RecordConsentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordConsentResponse create() => RecordConsentResponse._();
  @$core.override
  RecordConsentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordConsentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordConsentResponse>(create);
  static RecordConsentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ClinicalConsent get consent => $_getN(0);
  @$pb.TagNumber(1)
  set consent(ClinicalConsent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasConsent() => $_has(0);
  @$pb.TagNumber(1)
  void clearConsent() => $_clearField(1);
  @$pb.TagNumber(1)
  ClinicalConsent ensureConsent() => $_ensure(0);
}

class WithdrawConsentRequest extends $pb.GeneratedMessage {
  factory WithdrawConsentRequest({
    $core.String? consentId,
  }) {
    final result = create();
    if (consentId != null) result.consentId = consentId;
    return result;
  }

  WithdrawConsentRequest._();

  factory WithdrawConsentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WithdrawConsentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WithdrawConsentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'consentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawConsentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawConsentRequest copyWith(
          void Function(WithdrawConsentRequest) updates) =>
      super.copyWith((message) => updates(message as WithdrawConsentRequest))
          as WithdrawConsentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WithdrawConsentRequest create() => WithdrawConsentRequest._();
  @$core.override
  WithdrawConsentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WithdrawConsentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WithdrawConsentRequest>(create);
  static WithdrawConsentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get consentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set consentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConsentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConsentId() => $_clearField(1);
}

class WithdrawConsentResponse extends $pb.GeneratedMessage {
  factory WithdrawConsentResponse() => create();

  WithdrawConsentResponse._();

  factory WithdrawConsentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WithdrawConsentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WithdrawConsentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawConsentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawConsentResponse copyWith(
          void Function(WithdrawConsentResponse) updates) =>
      super.copyWith((message) => updates(message as WithdrawConsentResponse))
          as WithdrawConsentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WithdrawConsentResponse create() => WithdrawConsentResponse._();
  @$core.override
  WithdrawConsentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WithdrawConsentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WithdrawConsentResponse>(create);
  static WithdrawConsentResponse? _defaultInstance;
}

class ListConsentsRequest extends $pb.GeneratedMessage {
  factory ListConsentsRequest({
    $core.String? patientId,
    ConsentKind? kind,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (kind != null) result.kind = kind;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListConsentsRequest._();

  factory ListConsentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListConsentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListConsentsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aE<ConsentKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: ConsentKind.values)
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListConsentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListConsentsRequest copyWith(void Function(ListConsentsRequest) updates) =>
      super.copyWith((message) => updates(message as ListConsentsRequest))
          as ListConsentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListConsentsRequest create() => ListConsentsRequest._();
  @$core.override
  ListConsentsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListConsentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListConsentsRequest>(create);
  static ListConsentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  ConsentKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(ConsentKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListConsentsResponse extends $pb.GeneratedMessage {
  factory ListConsentsResponse({
    $core.Iterable<ClinicalConsent>? consents,
  }) {
    final result = create();
    if (consents != null) result.consents.addAll(consents);
    return result;
  }

  ListConsentsResponse._();

  factory ListConsentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListConsentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListConsentsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<ClinicalConsent>(1, _omitFieldNames ? '' : 'consents',
        subBuilder: ClinicalConsent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListConsentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListConsentsResponse copyWith(void Function(ListConsentsResponse) updates) =>
      super.copyWith((message) => updates(message as ListConsentsResponse))
          as ListConsentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListConsentsResponse create() => ListConsentsResponse._();
  @$core.override
  ListConsentsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListConsentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListConsentsResponse>(create);
  static ListConsentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ClinicalConsent> get consents => $_getList(0);
}

class AttachFileRequest extends $pb.GeneratedMessage {
  factory AttachFileRequest({
    $core.String? parentType,
    $core.String? parentId,
    $core.String? patientId,
    AttachmentKind? kind,
    $core.String? contentType,
    @$core.Deprecated('This field is deprecated.') $core.String? storageKey,
    @$core.Deprecated('This field is deprecated.') $fixnum.Int64? sizeBytes,
    @$core.Deprecated('This field is deprecated.') $core.String? digest,
    $core.String? description,
    Confidentiality? confidentiality,
    $0.Timestamp? capturedAt,
    $core.String? sourceSystem,
    Provenance? provenance,
    $core.List<$core.int>? content,
  }) {
    final result = create();
    if (parentType != null) result.parentType = parentType;
    if (parentId != null) result.parentId = parentId;
    if (patientId != null) result.patientId = patientId;
    if (kind != null) result.kind = kind;
    if (contentType != null) result.contentType = contentType;
    if (storageKey != null) result.storageKey = storageKey;
    if (sizeBytes != null) result.sizeBytes = sizeBytes;
    if (digest != null) result.digest = digest;
    if (description != null) result.description = description;
    if (confidentiality != null) result.confidentiality = confidentiality;
    if (capturedAt != null) result.capturedAt = capturedAt;
    if (sourceSystem != null) result.sourceSystem = sourceSystem;
    if (provenance != null) result.provenance = provenance;
    if (content != null) result.content = content;
    return result;
  }

  AttachFileRequest._();

  factory AttachFileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AttachFileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttachFileRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'parentType')
    ..aOS(2, _omitFieldNames ? '' : 'parentId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aE<AttachmentKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: AttachmentKind.values)
    ..aOS(5, _omitFieldNames ? '' : 'contentType')
    ..aOS(6, _omitFieldNames ? '' : 'storageKey')
    ..aInt64(7, _omitFieldNames ? '' : 'sizeBytes')
    ..aOS(8, _omitFieldNames ? '' : 'digest')
    ..aOS(9, _omitFieldNames ? '' : 'description')
    ..aE<Confidentiality>(10, _omitFieldNames ? '' : 'confidentiality',
        enumValues: Confidentiality.values)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'capturedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'sourceSystem')
    ..aOM<Provenance>(13, _omitFieldNames ? '' : 'provenance',
        subBuilder: Provenance.create)
    ..a<$core.List<$core.int>>(
        14, _omitFieldNames ? '' : 'content', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachFileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachFileRequest copyWith(void Function(AttachFileRequest) updates) =>
      super.copyWith((message) => updates(message as AttachFileRequest))
          as AttachFileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AttachFileRequest create() => AttachFileRequest._();
  @$core.override
  AttachFileRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AttachFileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AttachFileRequest>(create);
  static AttachFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get parentType => $_getSZ(0);
  @$pb.TagNumber(1)
  set parentType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParentType() => $_has(0);
  @$pb.TagNumber(1)
  void clearParentType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get parentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set parentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasParentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearParentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get patientId => $_getSZ(2);
  @$pb.TagNumber(3)
  set patientId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPatientId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatientId() => $_clearField(3);

  @$pb.TagNumber(4)
  AttachmentKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(AttachmentKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get contentType => $_getSZ(4);
  @$pb.TagNumber(5)
  set contentType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContentType() => $_has(4);
  @$pb.TagNumber(5)
  void clearContentType() => $_clearField(5);

  /// Superseded by content, and refused rather than ignored if set.
  ///
  /// These were the caller's word for where it had already put the bytes and
  /// what they were. A caller-supplied storage key is a caller-supplied path:
  /// it can address another tenant's object, something outside the store, or
  /// nothing at all, and the attachment record would still look complete. A
  /// caller-supplied digest is worse — it is the field a reader trusts to tell
  /// it the content has not been altered, asserted by whoever supplied the
  /// content.
  ///
  /// Kept on the wire rather than removed so an old client gets an error that
  /// names the problem instead of a field number that has quietly changed
  /// meaning.
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(6)
  $core.String get storageKey => $_getSZ(5);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(6)
  set storageKey($core.String value) => $_setString(5, value);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(6)
  $core.bool hasStorageKey() => $_has(5);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(6)
  void clearStorageKey() => $_clearField(6);

  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(7)
  $fixnum.Int64 get sizeBytes => $_getI64(6);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(7)
  set sizeBytes($fixnum.Int64 value) => $_setInt64(6, value);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(7)
  $core.bool hasSizeBytes() => $_has(6);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(7)
  void clearSizeBytes() => $_clearField(7);

  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(8)
  $core.String get digest => $_getSZ(7);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(8)
  set digest($core.String value) => $_setString(7, value);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(8)
  $core.bool hasDigest() => $_has(7);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(8)
  void clearDigest() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get description => $_getSZ(8);
  @$pb.TagNumber(9)
  set description($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDescription() => $_has(8);
  @$pb.TagNumber(9)
  void clearDescription() => $_clearField(9);

  @$pb.TagNumber(10)
  Confidentiality get confidentiality => $_getN(9);
  @$pb.TagNumber(10)
  set confidentiality(Confidentiality value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasConfidentiality() => $_has(9);
  @$pb.TagNumber(10)
  void clearConfidentiality() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get capturedAt => $_getN(10);
  @$pb.TagNumber(11)
  set capturedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasCapturedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearCapturedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureCapturedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get sourceSystem => $_getSZ(11);
  @$pb.TagNumber(12)
  set sourceSystem($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSourceSystem() => $_has(11);
  @$pb.TagNumber(12)
  void clearSourceSystem() => $_clearField(12);

  @$pb.TagNumber(13)
  Provenance get provenance => $_getN(12);
  @$pb.TagNumber(13)
  set provenance(Provenance value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasProvenance() => $_has(12);
  @$pb.TagNumber(13)
  void clearProvenance() => $_clearField(13);
  @$pb.TagNumber(13)
  Provenance ensureProvenance() => $_ensure(12);

  /// The file itself.
  ///
  /// The bytes, not a key naming where the caller already put them. A
  /// caller-supplied storage key is a caller-supplied path: it can point at
  /// another tenant's object, at something outside the store, or at nothing at
  /// all, and the record would still look complete. The server writes the
  /// bytes, chooses the key and computes the size and the digest, so the
  /// attachment's own metadata is a statement about content the server has
  /// actually seen.
  ///
  /// Attachments are bounded (see MaxAttachmentBytes and the configured class
  /// limit) and travel in the request. When something genuinely large arrives —
  /// imaging — it gets a presigned upload of its own rather than a bigger
  /// message.
  @$pb.TagNumber(14)
  $core.List<$core.int> get content => $_getN(13);
  @$pb.TagNumber(14)
  set content($core.List<$core.int> value) => $_setBytes(13, value);
  @$pb.TagNumber(14)
  $core.bool hasContent() => $_has(13);
  @$pb.TagNumber(14)
  void clearContent() => $_clearField(14);
}

class AttachFileResponse extends $pb.GeneratedMessage {
  factory AttachFileResponse({
    Attachment? attachment,
  }) {
    final result = create();
    if (attachment != null) result.attachment = attachment;
    return result;
  }

  AttachFileResponse._();

  factory AttachFileResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AttachFileResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttachFileResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Attachment>(1, _omitFieldNames ? '' : 'attachment',
        subBuilder: Attachment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachFileResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachFileResponse copyWith(void Function(AttachFileResponse) updates) =>
      super.copyWith((message) => updates(message as AttachFileResponse))
          as AttachFileResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AttachFileResponse create() => AttachFileResponse._();
  @$core.override
  AttachFileResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AttachFileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AttachFileResponse>(create);
  static AttachFileResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Attachment get attachment => $_getN(0);
  @$pb.TagNumber(1)
  set attachment(Attachment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAttachment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAttachment() => $_clearField(1);
  @$pb.TagNumber(1)
  Attachment ensureAttachment() => $_ensure(0);
}

class ListAttachmentsRequest extends $pb.GeneratedMessage {
  factory ListAttachmentsRequest({
    $core.String? parentType,
    $core.String? parentId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (parentType != null) result.parentType = parentType;
    if (parentId != null) result.parentId = parentId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListAttachmentsRequest._();

  factory ListAttachmentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAttachmentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAttachmentsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'parentType')
    ..aOS(2, _omitFieldNames ? '' : 'parentId')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAttachmentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAttachmentsRequest copyWith(
          void Function(ListAttachmentsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAttachmentsRequest))
          as ListAttachmentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAttachmentsRequest create() => ListAttachmentsRequest._();
  @$core.override
  ListAttachmentsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAttachmentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAttachmentsRequest>(create);
  static ListAttachmentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get parentType => $_getSZ(0);
  @$pb.TagNumber(1)
  set parentType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParentType() => $_has(0);
  @$pb.TagNumber(1)
  void clearParentType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get parentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set parentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasParentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearParentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListAttachmentsResponse extends $pb.GeneratedMessage {
  factory ListAttachmentsResponse({
    $core.Iterable<Attachment>? attachments,
  }) {
    final result = create();
    if (attachments != null) result.attachments.addAll(attachments);
    return result;
  }

  ListAttachmentsResponse._();

  factory ListAttachmentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAttachmentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAttachmentsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<Attachment>(1, _omitFieldNames ? '' : 'attachments',
        subBuilder: Attachment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAttachmentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAttachmentsResponse copyWith(
          void Function(ListAttachmentsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAttachmentsResponse))
          as ListAttachmentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAttachmentsResponse create() => ListAttachmentsResponse._();
  @$core.override
  ListAttachmentsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAttachmentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAttachmentsResponse>(create);
  static ListAttachmentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Attachment> get attachments => $_getList(0);
}

class GetProvenanceRequest extends $pb.GeneratedMessage {
  factory GetProvenanceRequest({
    $core.String? recordType,
    $core.String? recordId,
  }) {
    final result = create();
    if (recordType != null) result.recordType = recordType;
    if (recordId != null) result.recordId = recordId;
    return result;
  }

  GetProvenanceRequest._();

  factory GetProvenanceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetProvenanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetProvenanceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordType')
    ..aOS(2, _omitFieldNames ? '' : 'recordId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProvenanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProvenanceRequest copyWith(void Function(GetProvenanceRequest) updates) =>
      super.copyWith((message) => updates(message as GetProvenanceRequest))
          as GetProvenanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetProvenanceRequest create() => GetProvenanceRequest._();
  @$core.override
  GetProvenanceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetProvenanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProvenanceRequest>(create);
  static GetProvenanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordType => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordType() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recordId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recordId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordId() => $_clearField(2);
}

class GetProvenanceResponse extends $pb.GeneratedMessage {
  factory GetProvenanceResponse({
    $core.Iterable<Provenance>? provenance,
  }) {
    final result = create();
    if (provenance != null) result.provenance.addAll(provenance);
    return result;
  }

  GetProvenanceResponse._();

  factory GetProvenanceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetProvenanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetProvenanceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<Provenance>(1, _omitFieldNames ? '' : 'provenance',
        subBuilder: Provenance.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProvenanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProvenanceResponse copyWith(
          void Function(GetProvenanceResponse) updates) =>
      super.copyWith((message) => updates(message as GetProvenanceResponse))
          as GetProvenanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetProvenanceResponse create() => GetProvenanceResponse._();
  @$core.override
  GetProvenanceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetProvenanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProvenanceResponse>(create);
  static GetProvenanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Provenance> get provenance => $_getList(0);
}

class StoreCalculationRequest extends $pb.GeneratedMessage {
  factory StoreCalculationRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? calculatorId,
    $core.String? formulaVersion,
    $core.String? name,
    $core.Iterable<CalculatorInput>? inputs,
    $core.double? value,
    $core.String? unit,
    $core.String? interpretation,
    $core.String? supersedesId,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (calculatorId != null) result.calculatorId = calculatorId;
    if (formulaVersion != null) result.formulaVersion = formulaVersion;
    if (name != null) result.name = name;
    if (inputs != null) result.inputs.addAll(inputs);
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (interpretation != null) result.interpretation = interpretation;
    if (supersedesId != null) result.supersedesId = supersedesId;
    return result;
  }

  StoreCalculationRequest._();

  factory StoreCalculationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StoreCalculationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreCalculationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'calculatorId')
    ..aOS(4, _omitFieldNames ? '' : 'formulaVersion')
    ..aOS(5, _omitFieldNames ? '' : 'name')
    ..pPM<CalculatorInput>(6, _omitFieldNames ? '' : 'inputs',
        subBuilder: CalculatorInput.create)
    ..aD(7, _omitFieldNames ? '' : 'value')
    ..aOS(8, _omitFieldNames ? '' : 'unit')
    ..aOS(9, _omitFieldNames ? '' : 'interpretation')
    ..aOS(10, _omitFieldNames ? '' : 'supersedesId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreCalculationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreCalculationRequest copyWith(
          void Function(StoreCalculationRequest) updates) =>
      super.copyWith((message) => updates(message as StoreCalculationRequest))
          as StoreCalculationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StoreCalculationRequest create() => StoreCalculationRequest._();
  @$core.override
  StoreCalculationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StoreCalculationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreCalculationRequest>(create);
  static StoreCalculationRequest? _defaultInstance;

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
  $core.String get calculatorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set calculatorId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCalculatorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCalculatorId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get formulaVersion => $_getSZ(3);
  @$pb.TagNumber(4)
  set formulaVersion($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFormulaVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearFormulaVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<CalculatorInput> get inputs => $_getList(5);

  @$pb.TagNumber(7)
  $core.double get value => $_getN(6);
  @$pb.TagNumber(7)
  set value($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearValue() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get unit => $_getSZ(7);
  @$pb.TagNumber(8)
  set unit($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUnit() => $_has(7);
  @$pb.TagNumber(8)
  void clearUnit() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get interpretation => $_getSZ(8);
  @$pb.TagNumber(9)
  set interpretation($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasInterpretation() => $_has(8);
  @$pb.TagNumber(9)
  void clearInterpretation() => $_clearField(9);

  /// Names an earlier result this rerun replaces. The earlier one stays.
  @$pb.TagNumber(10)
  $core.String get supersedesId => $_getSZ(9);
  @$pb.TagNumber(10)
  set supersedesId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSupersedesId() => $_has(9);
  @$pb.TagNumber(10)
  void clearSupersedesId() => $_clearField(10);
}

class StoreCalculationResponse extends $pb.GeneratedMessage {
  factory StoreCalculationResponse({
    CalculatorResult? result,
  }) {
    final result$ = create();
    if (result != null) result$.result = result;
    return result$;
  }

  StoreCalculationResponse._();

  factory StoreCalculationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StoreCalculationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreCalculationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<CalculatorResult>(1, _omitFieldNames ? '' : 'result',
        subBuilder: CalculatorResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreCalculationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreCalculationResponse copyWith(
          void Function(StoreCalculationResponse) updates) =>
      super.copyWith((message) => updates(message as StoreCalculationResponse))
          as StoreCalculationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StoreCalculationResponse create() => StoreCalculationResponse._();
  @$core.override
  StoreCalculationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StoreCalculationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreCalculationResponse>(create);
  static StoreCalculationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CalculatorResult get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(CalculatorResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);
  @$pb.TagNumber(1)
  CalculatorResult ensureResult() => $_ensure(0);
}

class ListCalculationsRequest extends $pb.GeneratedMessage {
  factory ListCalculationsRequest({
    $core.String? patientId,
    $core.String? calculatorId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (calculatorId != null) result.calculatorId = calculatorId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListCalculationsRequest._();

  factory ListCalculationsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCalculationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCalculationsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'calculatorId')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCalculationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCalculationsRequest copyWith(
          void Function(ListCalculationsRequest) updates) =>
      super.copyWith((message) => updates(message as ListCalculationsRequest))
          as ListCalculationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCalculationsRequest create() => ListCalculationsRequest._();
  @$core.override
  ListCalculationsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCalculationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCalculationsRequest>(create);
  static ListCalculationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get calculatorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set calculatorId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCalculatorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCalculatorId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListCalculationsResponse extends $pb.GeneratedMessage {
  factory ListCalculationsResponse({
    $core.Iterable<CalculatorResult>? results,
  }) {
    final result = create();
    if (results != null) result.results.addAll(results);
    return result;
  }

  ListCalculationsResponse._();

  factory ListCalculationsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCalculationsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCalculationsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<CalculatorResult>(1, _omitFieldNames ? '' : 'results',
        subBuilder: CalculatorResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCalculationsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCalculationsResponse copyWith(
          void Function(ListCalculationsResponse) updates) =>
      super.copyWith((message) => updates(message as ListCalculationsResponse))
          as ListCalculationsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCalculationsResponse create() => ListCalculationsResponse._();
  @$core.override
  ListCalculationsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCalculationsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCalculationsResponse>(create);
  static ListCalculationsResponse? _defaultInstance;

  /// Superseded results included: the superseded one is the number a decision
  /// was made from, and hiding it would make the decision inexplicable.
  @$pb.TagNumber(1)
  $pb.PbList<CalculatorResult> get results => $_getList(0);
}

class RaiseAlertRequest extends $pb.GeneratedMessage {
  factory RaiseAlertRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? ruleId,
    $core.String? ruleVersion,
    AlertLevel? level,
    $core.String? message,
    $core.String? contextType,
    $core.String? contextId,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (ruleId != null) result.ruleId = ruleId;
    if (ruleVersion != null) result.ruleVersion = ruleVersion;
    if (level != null) result.level = level;
    if (message != null) result.message = message;
    if (contextType != null) result.contextType = contextType;
    if (contextId != null) result.contextId = contextId;
    return result;
  }

  RaiseAlertRequest._();

  factory RaiseAlertRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseAlertRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseAlertRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'ruleId')
    ..aOS(4, _omitFieldNames ? '' : 'ruleVersion')
    ..aE<AlertLevel>(5, _omitFieldNames ? '' : 'level',
        enumValues: AlertLevel.values)
    ..aOS(6, _omitFieldNames ? '' : 'message')
    ..aOS(7, _omitFieldNames ? '' : 'contextType')
    ..aOS(8, _omitFieldNames ? '' : 'contextId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseAlertRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseAlertRequest copyWith(void Function(RaiseAlertRequest) updates) =>
      super.copyWith((message) => updates(message as RaiseAlertRequest))
          as RaiseAlertRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseAlertRequest create() => RaiseAlertRequest._();
  @$core.override
  RaiseAlertRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseAlertRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseAlertRequest>(create);
  static RaiseAlertRequest? _defaultInstance;

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
  $core.String get ruleId => $_getSZ(2);
  @$pb.TagNumber(3)
  set ruleId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRuleId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRuleId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get ruleVersion => $_getSZ(3);
  @$pb.TagNumber(4)
  set ruleVersion($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRuleVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearRuleVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  AlertLevel get level => $_getN(4);
  @$pb.TagNumber(5)
  set level(AlertLevel value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLevel() => $_has(4);
  @$pb.TagNumber(5)
  void clearLevel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get message => $_getSZ(5);
  @$pb.TagNumber(6)
  set message($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMessage() => $_has(5);
  @$pb.TagNumber(6)
  void clearMessage() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get contextType => $_getSZ(6);
  @$pb.TagNumber(7)
  set contextType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasContextType() => $_has(6);
  @$pb.TagNumber(7)
  void clearContextType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get contextId => $_getSZ(7);
  @$pb.TagNumber(8)
  set contextId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasContextId() => $_has(7);
  @$pb.TagNumber(8)
  void clearContextId() => $_clearField(8);
}

class RaiseAlertResponse extends $pb.GeneratedMessage {
  factory RaiseAlertResponse({
    CDSAlert? alert,
  }) {
    final result = create();
    if (alert != null) result.alert = alert;
    return result;
  }

  RaiseAlertResponse._();

  factory RaiseAlertResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseAlertResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseAlertResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<CDSAlert>(1, _omitFieldNames ? '' : 'alert',
        subBuilder: CDSAlert.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseAlertResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseAlertResponse copyWith(void Function(RaiseAlertResponse) updates) =>
      super.copyWith((message) => updates(message as RaiseAlertResponse))
          as RaiseAlertResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseAlertResponse create() => RaiseAlertResponse._();
  @$core.override
  RaiseAlertResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseAlertResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseAlertResponse>(create);
  static RaiseAlertResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CDSAlert get alert => $_getN(0);
  @$pb.TagNumber(1)
  set alert(CDSAlert value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAlert() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlert() => $_clearField(1);
  @$pb.TagNumber(1)
  CDSAlert ensureAlert() => $_ensure(0);
}

class RespondToAlertRequest extends $pb.GeneratedMessage {
  factory RespondToAlertRequest({
    $core.String? alertId,
    AlertOutcome? outcome,
    $core.String? overrideCode,
    $core.String? overrideReason,
  }) {
    final result = create();
    if (alertId != null) result.alertId = alertId;
    if (outcome != null) result.outcome = outcome;
    if (overrideCode != null) result.overrideCode = overrideCode;
    if (overrideReason != null) result.overrideReason = overrideReason;
    return result;
  }

  RespondToAlertRequest._();

  factory RespondToAlertRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RespondToAlertRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RespondToAlertRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'alertId')
    ..aE<AlertOutcome>(2, _omitFieldNames ? '' : 'outcome',
        enumValues: AlertOutcome.values)
    ..aOS(3, _omitFieldNames ? '' : 'overrideCode')
    ..aOS(4, _omitFieldNames ? '' : 'overrideReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespondToAlertRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespondToAlertRequest copyWith(
          void Function(RespondToAlertRequest) updates) =>
      super.copyWith((message) => updates(message as RespondToAlertRequest))
          as RespondToAlertRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RespondToAlertRequest create() => RespondToAlertRequest._();
  @$core.override
  RespondToAlertRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RespondToAlertRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RespondToAlertRequest>(create);
  static RespondToAlertRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get alertId => $_getSZ(0);
  @$pb.TagNumber(1)
  set alertId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlertId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlertId() => $_clearField(1);

  @$pb.TagNumber(2)
  AlertOutcome get outcome => $_getN(1);
  @$pb.TagNumber(2)
  set outcome(AlertOutcome value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOutcome() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutcome() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get overrideCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set overrideCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOverrideCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverrideCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get overrideReason => $_getSZ(3);
  @$pb.TagNumber(4)
  set overrideReason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOverrideReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearOverrideReason() => $_clearField(4);
}

class RespondToAlertResponse extends $pb.GeneratedMessage {
  factory RespondToAlertResponse({
    CDSAlert? alert,
  }) {
    final result = create();
    if (alert != null) result.alert = alert;
    return result;
  }

  RespondToAlertResponse._();

  factory RespondToAlertResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RespondToAlertResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RespondToAlertResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<CDSAlert>(1, _omitFieldNames ? '' : 'alert',
        subBuilder: CDSAlert.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespondToAlertResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespondToAlertResponse copyWith(
          void Function(RespondToAlertResponse) updates) =>
      super.copyWith((message) => updates(message as RespondToAlertResponse))
          as RespondToAlertResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RespondToAlertResponse create() => RespondToAlertResponse._();
  @$core.override
  RespondToAlertResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RespondToAlertResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RespondToAlertResponse>(create);
  static RespondToAlertResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CDSAlert get alert => $_getN(0);
  @$pb.TagNumber(1)
  set alert(CDSAlert value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAlert() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlert() => $_clearField(1);
  @$pb.TagNumber(1)
  CDSAlert ensureAlert() => $_ensure(0);
}

class ListAlertsRequest extends $pb.GeneratedMessage {
  factory ListAlertsRequest({
    $core.String? patientId,
    AlertOutcome? outcome,
    $core.String? ruleId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (outcome != null) result.outcome = outcome;
    if (ruleId != null) result.ruleId = ruleId;
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
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aE<AlertOutcome>(2, _omitFieldNames ? '' : 'outcome',
        enumValues: AlertOutcome.values)
    ..aOS(3, _omitFieldNames ? '' : 'ruleId')
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

  /// Narrows to pending, overridden and so on, which is what the override
  /// report asks for.
  @$pb.TagNumber(2)
  AlertOutcome get outcome => $_getN(1);
  @$pb.TagNumber(2)
  set outcome(AlertOutcome value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOutcome() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutcome() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get ruleId => $_getSZ(2);
  @$pb.TagNumber(3)
  set ruleId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRuleId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRuleId() => $_clearField(3);

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
    $core.Iterable<CDSAlert>? alerts,
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
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<CDSAlert>(1, _omitFieldNames ? '' : 'alerts',
        subBuilder: CDSAlert.create)
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
  $pb.PbList<CDSAlert> get alerts => $_getList(0);
}

class RequestConsultRequest extends $pb.GeneratedMessage {
  factory RequestConsultRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? specialty,
    ConsultUrgency? urgency,
    $core.String? reason,
    $core.String? question,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (specialty != null) result.specialty = specialty;
    if (urgency != null) result.urgency = urgency;
    if (reason != null) result.reason = reason;
    if (question != null) result.question = question;
    return result;
  }

  RequestConsultRequest._();

  factory RequestConsultRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestConsultRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestConsultRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'specialty')
    ..aE<ConsultUrgency>(4, _omitFieldNames ? '' : 'urgency',
        enumValues: ConsultUrgency.values)
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aOS(6, _omitFieldNames ? '' : 'question')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestConsultRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestConsultRequest copyWith(
          void Function(RequestConsultRequest) updates) =>
      super.copyWith((message) => updates(message as RequestConsultRequest))
          as RequestConsultRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestConsultRequest create() => RequestConsultRequest._();
  @$core.override
  RequestConsultRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestConsultRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestConsultRequest>(create);
  static RequestConsultRequest? _defaultInstance;

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
  $core.String get specialty => $_getSZ(2);
  @$pb.TagNumber(3)
  set specialty($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSpecialty() => $_has(2);
  @$pb.TagNumber(3)
  void clearSpecialty() => $_clearField(3);

  @$pb.TagNumber(4)
  ConsultUrgency get urgency => $_getN(3);
  @$pb.TagNumber(4)
  set urgency(ConsultUrgency value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUrgency() => $_has(3);
  @$pb.TagNumber(4)
  void clearUrgency() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get question => $_getSZ(5);
  @$pb.TagNumber(6)
  set question($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasQuestion() => $_has(5);
  @$pb.TagNumber(6)
  void clearQuestion() => $_clearField(6);
}

class RequestConsultResponse extends $pb.GeneratedMessage {
  factory RequestConsultResponse({
    Consult? consult,
  }) {
    final result = create();
    if (consult != null) result.consult = consult;
    return result;
  }

  RequestConsultResponse._();

  factory RequestConsultResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestConsultResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestConsultResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Consult>(1, _omitFieldNames ? '' : 'consult',
        subBuilder: Consult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestConsultResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestConsultResponse copyWith(
          void Function(RequestConsultResponse) updates) =>
      super.copyWith((message) => updates(message as RequestConsultResponse))
          as RequestConsultResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestConsultResponse create() => RequestConsultResponse._();
  @$core.override
  RequestConsultResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestConsultResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestConsultResponse>(create);
  static RequestConsultResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Consult get consult => $_getN(0);
  @$pb.TagNumber(1)
  set consult(Consult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasConsult() => $_has(0);
  @$pb.TagNumber(1)
  void clearConsult() => $_clearField(1);
  @$pb.TagNumber(1)
  Consult ensureConsult() => $_ensure(0);
}

class RespondToConsultRequest extends $pb.GeneratedMessage {
  factory RespondToConsultRequest({
    $core.String? consultId,
    $core.bool? accept,
    $core.String? response,
    $core.String? responseDocumentId,
    $core.String? declineReason,
  }) {
    final result = create();
    if (consultId != null) result.consultId = consultId;
    if (accept != null) result.accept = accept;
    if (response != null) result.response = response;
    if (responseDocumentId != null)
      result.responseDocumentId = responseDocumentId;
    if (declineReason != null) result.declineReason = declineReason;
    return result;
  }

  RespondToConsultRequest._();

  factory RespondToConsultRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RespondToConsultRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RespondToConsultRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'consultId')
    ..aOB(2, _omitFieldNames ? '' : 'accept')
    ..aOS(3, _omitFieldNames ? '' : 'response')
    ..aOS(4, _omitFieldNames ? '' : 'responseDocumentId')
    ..aOS(5, _omitFieldNames ? '' : 'declineReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespondToConsultRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespondToConsultRequest copyWith(
          void Function(RespondToConsultRequest) updates) =>
      super.copyWith((message) => updates(message as RespondToConsultRequest))
          as RespondToConsultRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RespondToConsultRequest create() => RespondToConsultRequest._();
  @$core.override
  RespondToConsultRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RespondToConsultRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RespondToConsultRequest>(create);
  static RespondToConsultRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get consultId => $_getSZ(0);
  @$pb.TagNumber(1)
  set consultId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConsultId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConsultId() => $_clearField(1);

  /// Picks the consult up without answering it yet.
  @$pb.TagNumber(2)
  $core.bool get accept => $_getBF(1);
  @$pb.TagNumber(2)
  set accept($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccept() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccept() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get response => $_getSZ(2);
  @$pb.TagNumber(3)
  set response($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResponse() => $_has(2);
  @$pb.TagNumber(3)
  void clearResponse() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get responseDocumentId => $_getSZ(3);
  @$pb.TagNumber(4)
  set responseDocumentId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasResponseDocumentId() => $_has(3);
  @$pb.TagNumber(4)
  void clearResponseDocumentId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get declineReason => $_getSZ(4);
  @$pb.TagNumber(5)
  set declineReason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDeclineReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeclineReason() => $_clearField(5);
}

class RespondToConsultResponse extends $pb.GeneratedMessage {
  factory RespondToConsultResponse({
    Consult? consult,
  }) {
    final result = create();
    if (consult != null) result.consult = consult;
    return result;
  }

  RespondToConsultResponse._();

  factory RespondToConsultResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RespondToConsultResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RespondToConsultResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<Consult>(1, _omitFieldNames ? '' : 'consult',
        subBuilder: Consult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespondToConsultResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespondToConsultResponse copyWith(
          void Function(RespondToConsultResponse) updates) =>
      super.copyWith((message) => updates(message as RespondToConsultResponse))
          as RespondToConsultResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RespondToConsultResponse create() => RespondToConsultResponse._();
  @$core.override
  RespondToConsultResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RespondToConsultResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RespondToConsultResponse>(create);
  static RespondToConsultResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Consult get consult => $_getN(0);
  @$pb.TagNumber(1)
  set consult(Consult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasConsult() => $_has(0);
  @$pb.TagNumber(1)
  void clearConsult() => $_clearField(1);
  @$pb.TagNumber(1)
  Consult ensureConsult() => $_ensure(0);
}

class ListConsultsRequest extends $pb.GeneratedMessage {
  factory ListConsultsRequest({
    $core.String? patientId,
    $core.String? specialty,
    $core.bool? openOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (specialty != null) result.specialty = specialty;
    if (openOnly != null) result.openOnly = openOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListConsultsRequest._();

  factory ListConsultsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListConsultsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListConsultsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'specialty')
    ..aOB(3, _omitFieldNames ? '' : 'openOnly')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListConsultsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListConsultsRequest copyWith(void Function(ListConsultsRequest) updates) =>
      super.copyWith((message) => updates(message as ListConsultsRequest))
          as ListConsultsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListConsultsRequest create() => ListConsultsRequest._();
  @$core.override
  ListConsultsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListConsultsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListConsultsRequest>(create);
  static ListConsultsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get specialty => $_getSZ(1);
  @$pb.TagNumber(2)
  set specialty($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSpecialty() => $_has(1);
  @$pb.TagNumber(2)
  void clearSpecialty() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get openOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set openOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOpenOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearOpenOnly() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

class ListConsultsResponse extends $pb.GeneratedMessage {
  factory ListConsultsResponse({
    $core.Iterable<Consult>? consults,
  }) {
    final result = create();
    if (consults != null) result.consults.addAll(consults);
    return result;
  }

  ListConsultsResponse._();

  factory ListConsultsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListConsultsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListConsultsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<Consult>(1, _omitFieldNames ? '' : 'consults',
        subBuilder: Consult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListConsultsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListConsultsResponse copyWith(void Function(ListConsultsResponse) updates) =>
      super.copyWith((message) => updates(message as ListConsultsResponse))
          as ListConsultsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListConsultsResponse create() => ListConsultsResponse._();
  @$core.override
  ListConsultsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListConsultsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListConsultsResponse>(create);
  static ListConsultsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Consult> get consults => $_getList(0);
}

class EnrolInRegistryRequest extends $pb.GeneratedMessage {
  factory EnrolInRegistryRequest({
    $core.String? patientId,
    $core.String? registryId,
    $core.String? problemId,
    $core.String? diagnosisId,
    $0.Timestamp? enrolledAt,
    $core.bool? consented,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (registryId != null) result.registryId = registryId;
    if (problemId != null) result.problemId = problemId;
    if (diagnosisId != null) result.diagnosisId = diagnosisId;
    if (enrolledAt != null) result.enrolledAt = enrolledAt;
    if (consented != null) result.consented = consented;
    return result;
  }

  EnrolInRegistryRequest._();

  factory EnrolInRegistryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnrolInRegistryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnrolInRegistryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'registryId')
    ..aOS(3, _omitFieldNames ? '' : 'problemId')
    ..aOS(4, _omitFieldNames ? '' : 'diagnosisId')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'enrolledAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(6, _omitFieldNames ? '' : 'consented')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnrolInRegistryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnrolInRegistryRequest copyWith(
          void Function(EnrolInRegistryRequest) updates) =>
      super.copyWith((message) => updates(message as EnrolInRegistryRequest))
          as EnrolInRegistryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnrolInRegistryRequest create() => EnrolInRegistryRequest._();
  @$core.override
  EnrolInRegistryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnrolInRegistryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnrolInRegistryRequest>(create);
  static EnrolInRegistryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get registryId => $_getSZ(1);
  @$pb.TagNumber(2)
  set registryId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRegistryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRegistryId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get problemId => $_getSZ(2);
  @$pb.TagNumber(3)
  set problemId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProblemId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProblemId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get diagnosisId => $_getSZ(3);
  @$pb.TagNumber(4)
  set diagnosisId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDiagnosisId() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiagnosisId() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get enrolledAt => $_getN(4);
  @$pb.TagNumber(5)
  set enrolledAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEnrolledAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearEnrolledAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureEnrolledAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get consented => $_getBF(5);
  @$pb.TagNumber(6)
  set consented($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasConsented() => $_has(5);
  @$pb.TagNumber(6)
  void clearConsented() => $_clearField(6);
}

class EnrolInRegistryResponse extends $pb.GeneratedMessage {
  factory EnrolInRegistryResponse({
    RegistryMembership? membership,
  }) {
    final result = create();
    if (membership != null) result.membership = membership;
    return result;
  }

  EnrolInRegistryResponse._();

  factory EnrolInRegistryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnrolInRegistryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnrolInRegistryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOM<RegistryMembership>(1, _omitFieldNames ? '' : 'membership',
        subBuilder: RegistryMembership.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnrolInRegistryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnrolInRegistryResponse copyWith(
          void Function(EnrolInRegistryResponse) updates) =>
      super.copyWith((message) => updates(message as EnrolInRegistryResponse))
          as EnrolInRegistryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnrolInRegistryResponse create() => EnrolInRegistryResponse._();
  @$core.override
  EnrolInRegistryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnrolInRegistryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnrolInRegistryResponse>(create);
  static EnrolInRegistryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RegistryMembership get membership => $_getN(0);
  @$pb.TagNumber(1)
  set membership(RegistryMembership value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMembership() => $_has(0);
  @$pb.TagNumber(1)
  void clearMembership() => $_clearField(1);
  @$pb.TagNumber(1)
  RegistryMembership ensureMembership() => $_ensure(0);
}

class ExitRegistryRequest extends $pb.GeneratedMessage {
  factory ExitRegistryRequest({
    $core.String? membershipId,
    $0.Timestamp? exitedAt,
    $core.String? reason,
  }) {
    final result = create();
    if (membershipId != null) result.membershipId = membershipId;
    if (exitedAt != null) result.exitedAt = exitedAt;
    if (reason != null) result.reason = reason;
    return result;
  }

  ExitRegistryRequest._();

  factory ExitRegistryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExitRegistryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExitRegistryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'membershipId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'exitedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExitRegistryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExitRegistryRequest copyWith(void Function(ExitRegistryRequest) updates) =>
      super.copyWith((message) => updates(message as ExitRegistryRequest))
          as ExitRegistryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExitRegistryRequest create() => ExitRegistryRequest._();
  @$core.override
  ExitRegistryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExitRegistryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExitRegistryRequest>(create);
  static ExitRegistryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get membershipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set membershipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMembershipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMembershipId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get exitedAt => $_getN(1);
  @$pb.TagNumber(2)
  set exitedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasExitedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearExitedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureExitedAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class ExitRegistryResponse extends $pb.GeneratedMessage {
  factory ExitRegistryResponse() => create();

  ExitRegistryResponse._();

  factory ExitRegistryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExitRegistryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExitRegistryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExitRegistryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExitRegistryResponse copyWith(void Function(ExitRegistryResponse) updates) =>
      super.copyWith((message) => updates(message as ExitRegistryResponse))
          as ExitRegistryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExitRegistryResponse create() => ExitRegistryResponse._();
  @$core.override
  ExitRegistryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExitRegistryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExitRegistryResponse>(create);
  static ExitRegistryResponse? _defaultInstance;
}

class ListRegistryMembershipsRequest extends $pb.GeneratedMessage {
  factory ListRegistryMembershipsRequest({
    $core.String? patientId,
    $core.String? registryId,
    $core.bool? currentOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (registryId != null) result.registryId = registryId;
    if (currentOnly != null) result.currentOnly = currentOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListRegistryMembershipsRequest._();

  factory ListRegistryMembershipsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRegistryMembershipsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRegistryMembershipsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'registryId')
    ..aOB(3, _omitFieldNames ? '' : 'currentOnly')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRegistryMembershipsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRegistryMembershipsRequest copyWith(
          void Function(ListRegistryMembershipsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListRegistryMembershipsRequest))
          as ListRegistryMembershipsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRegistryMembershipsRequest create() =>
      ListRegistryMembershipsRequest._();
  @$core.override
  ListRegistryMembershipsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRegistryMembershipsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRegistryMembershipsRequest>(create);
  static ListRegistryMembershipsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get registryId => $_getSZ(1);
  @$pb.TagNumber(2)
  set registryId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRegistryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRegistryId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get currentOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set currentOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCurrentOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrentOnly() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

class ListRegistryMembershipsResponse extends $pb.GeneratedMessage {
  factory ListRegistryMembershipsResponse({
    $core.Iterable<RegistryMembership>? memberships,
  }) {
    final result = create();
    if (memberships != null) result.memberships.addAll(memberships);
    return result;
  }

  ListRegistryMembershipsResponse._();

  factory ListRegistryMembershipsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRegistryMembershipsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRegistryMembershipsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.clinical.v1'),
      createEmptyInstance: create)
    ..pPM<RegistryMembership>(1, _omitFieldNames ? '' : 'memberships',
        subBuilder: RegistryMembership.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRegistryMembershipsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRegistryMembershipsResponse copyWith(
          void Function(ListRegistryMembershipsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListRegistryMembershipsResponse))
          as ListRegistryMembershipsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRegistryMembershipsResponse create() =>
      ListRegistryMembershipsResponse._();
  @$core.override
  ListRegistryMembershipsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRegistryMembershipsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRegistryMembershipsResponse>(
          create);
  static ListRegistryMembershipsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RegistryMembership> get memberships => $_getList(0);
}

class ClinicalServiceApi {
  final $pb.RpcClient _client;

  ClinicalServiceApi(this._client);

  /// SRS-CLN-002, SRS-CLN-008, SRS-CLN-009, SRS-CLN-015, SRS-CLN-016. A signed
  /// note is never edited: it is amended or extended by an addendum, each a new
  /// document that points back.
  $async.Future<WriteNoteResponse> writeNote(
          $pb.ClientContext? ctx, WriteNoteRequest request) =>
      _client.invoke<WriteNoteResponse>(
          ctx, 'ClinicalService', 'WriteNote', request, WriteNoteResponse());
  $async.Future<SignNoteResponse> signNote(
          $pb.ClientContext? ctx, SignNoteRequest request) =>
      _client.invoke<SignNoteResponse>(
          ctx, 'ClinicalService', 'SignNote', request, SignNoteResponse());
  $async.Future<AmendNoteResponse> amendNote(
          $pb.ClientContext? ctx, AmendNoteRequest request) =>
      _client.invoke<AmendNoteResponse>(
          ctx, 'ClinicalService', 'AmendNote', request, AmendNoteResponse());
  $async.Future<RetractNoteResponse> retractNote(
          $pb.ClientContext? ctx, RetractNoteRequest request) =>
      _client.invoke<RetractNoteResponse>(ctx, 'ClinicalService', 'RetractNote',
          request, RetractNoteResponse());
  $async.Future<GetNoteResponse> getNote(
          $pb.ClientContext? ctx, GetNoteRequest request) =>
      _client.invoke<GetNoteResponse>(
          ctx, 'ClinicalService', 'GetNote', request, GetNoteResponse());
  $async.Future<ListNotesResponse> listNotes(
          $pb.ClientContext? ctx, ListNotesRequest request) =>
      _client.invoke<ListNotesResponse>(
          ctx, 'ClinicalService', 'ListNotes', request, ListNotesResponse());
  $async.Future<DefineTemplateResponse> defineTemplate(
          $pb.ClientContext? ctx, DefineTemplateRequest request) =>
      _client.invoke<DefineTemplateResponse>(ctx, 'ClinicalService',
          'DefineTemplate', request, DefineTemplateResponse());
  $async.Future<ListTemplatesResponse> listTemplates(
          $pb.ClientContext? ctx, ListTemplatesRequest request) =>
      _client.invoke<ListTemplatesResponse>(ctx, 'ClinicalService',
          'ListTemplates', request, ListTemplatesResponse());
  $async.Future<RetireTemplateResponse> retireTemplate(
          $pb.ClientContext? ctx, RetireTemplateRequest request) =>
      _client.invoke<RetireTemplateResponse>(ctx, 'ClinicalService',
          'RetireTemplate', request, RetireTemplateResponse());

  /// SRS-CLN-015. Expansions are stored into the note, so what is signed is
  /// what a reader sees.
  $async.Future<DefineSmartPhraseResponse> defineSmartPhrase(
          $pb.ClientContext? ctx, DefineSmartPhraseRequest request) =>
      _client.invoke<DefineSmartPhraseResponse>(ctx, 'ClinicalService',
          'DefineSmartPhrase', request, DefineSmartPhraseResponse());
  $async.Future<ListSmartPhrasesResponse> listSmartPhrases(
          $pb.ClientContext? ctx, ListSmartPhrasesRequest request) =>
      _client.invoke<ListSmartPhrasesResponse>(ctx, 'ClinicalService',
          'ListSmartPhrases', request, ListSmartPhrasesResponse());

  /// SRS-CLN-003. A resolved problem stays on the list as historical.
  $async.Future<RecordProblemResponse> recordProblem(
          $pb.ClientContext? ctx, RecordProblemRequest request) =>
      _client.invoke<RecordProblemResponse>(ctx, 'ClinicalService',
          'RecordProblem', request, RecordProblemResponse());
  $async.Future<UpdateProblemResponse> updateProblem(
          $pb.ClientContext? ctx, UpdateProblemRequest request) =>
      _client.invoke<UpdateProblemResponse>(ctx, 'ClinicalService',
          'UpdateProblem', request, UpdateProblemResponse());
  $async.Future<ListProblemsResponse> listProblems(
          $pb.ClientContext? ctx, ListProblemsRequest request) =>
      _client.invoke<ListProblemsResponse>(ctx, 'ClinicalService',
          'ListProblems', request, ListProblemsResponse());

  /// SRS-CLN-004. Coded, so medication decision support can check a
  /// prescription against it immediately after commit.
  $async.Future<RecordAllergyResponse> recordAllergy(
          $pb.ClientContext? ctx, RecordAllergyRequest request) =>
      _client.invoke<RecordAllergyResponse>(ctx, 'ClinicalService',
          'RecordAllergy', request, RecordAllergyResponse());
  $async.Future<VerifyAllergyResponse> verifyAllergy(
          $pb.ClientContext? ctx, VerifyAllergyRequest request) =>
      _client.invoke<VerifyAllergyResponse>(ctx, 'ClinicalService',
          'VerifyAllergy', request, VerifyAllergyResponse());
  $async.Future<ListAllergiesResponse> listAllergies(
          $pb.ClientContext? ctx, ListAllergiesRequest request) =>
      _client.invoke<ListAllergiesResponse>(ctx, 'ClinicalService',
          'ListAllergies', request, ListAllergiesResponse());

  /// SRS-CLN-005, SRS-CLN-010, SRS-CLN-011. Criticality is supplied by the
  /// authoritative diagnostic service and never inferred here.
  $async.Future<RecordObservationResponse> recordObservation(
          $pb.ClientContext? ctx, RecordObservationRequest request) =>
      _client.invoke<RecordObservationResponse>(ctx, 'ClinicalService',
          'RecordObservation', request, RecordObservationResponse());

  /// Device-sourced readings (SRS-ICU-003). Ingest puts a monitor value on the
  /// chart as provisional; DecideReading is the only path by which one becomes
  /// a chart value, and it needs the clinical write permission rather than the
  /// interface credential that ingested it — an interface that could confirm
  /// its own readings would make the distinction meaningless.
  $async.Future<IngestDeviceReadingResponse> ingestDeviceReading(
          $pb.ClientContext? ctx, IngestDeviceReadingRequest request) =>
      _client.invoke<IngestDeviceReadingResponse>(ctx, 'ClinicalService',
          'IngestDeviceReading', request, IngestDeviceReadingResponse());
  $async.Future<DecideReadingResponse> decideReading(
          $pb.ClientContext? ctx, DecideReadingRequest request) =>
      _client.invoke<DecideReadingResponse>(ctx, 'ClinicalService',
          'DecideReading', request, DecideReadingResponse());
  $async.Future<ListProvisionalReadingsResponse> listProvisionalReadings(
          $pb.ClientContext? ctx, ListProvisionalReadingsRequest request) =>
      _client.invoke<ListProvisionalReadingsResponse>(
          ctx,
          'ClinicalService',
          'ListProvisionalReadings',
          request,
          ListProvisionalReadingsResponse());
  $async.Future<ListObservationsResponse> listObservations(
          $pb.ClientContext? ctx, ListObservationsRequest request) =>
      _client.invoke<ListObservationsResponse>(ctx, 'ClinicalService',
          'ListObservations', request, ListObservationsResponse());

  /// SRS-CLN-012. Unacknowledged critical results escalate according to policy.
  $async.Future<ListCriticalResultsResponse> listCriticalResults(
          $pb.ClientContext? ctx, ListCriticalResultsRequest request) =>
      _client.invoke<ListCriticalResultsResponse>(ctx, 'ClinicalService',
          'ListCriticalResults', request, ListCriticalResultsResponse());
  $async.Future<AcknowledgeCriticalResultResponse> acknowledgeCriticalResult(
          $pb.ClientContext? ctx, AcknowledgeCriticalResultRequest request) =>
      _client.invoke<AcknowledgeCriticalResultResponse>(
          ctx,
          'ClinicalService',
          'AcknowledgeCriticalResult',
          request,
          AcknowledgeCriticalResultResponse());

  /// SRS-CLN-006. Laterality is stated rather than assumed, and complications
  /// are coded so they can be counted.
  $async.Future<RecordProcedureResponse> recordProcedure(
          $pb.ClientContext? ctx, RecordProcedureRequest request) =>
      _client.invoke<RecordProcedureResponse>(ctx, 'ClinicalService',
          'RecordProcedure', request, RecordProcedureResponse());
  $async.Future<ListProceduresResponse> listProcedures(
          $pb.ClientContext? ctx, ListProceduresRequest request) =>
      _client.invoke<ListProceduresResponse>(ctx, 'ClinicalService',
          'ListProcedures', request, ListProceduresResponse());

  /// SRS-CLN-007. Activities carry the task id that executes them.
  $async.Future<CreateCarePlanResponse> createCarePlan(
          $pb.ClientContext? ctx, CreateCarePlanRequest request) =>
      _client.invoke<CreateCarePlanResponse>(ctx, 'ClinicalService',
          'CreateCarePlan', request, CreateCarePlanResponse());
  $async.Future<UpdateCarePlanResponse> updateCarePlan(
          $pb.ClientContext? ctx, UpdateCarePlanRequest request) =>
      _client.invoke<UpdateCarePlanResponse>(ctx, 'ClinicalService',
          'UpdateCarePlan', request, UpdateCarePlanResponse());
  $async.Future<ListCarePlansResponse> listCarePlans(
          $pb.ClientContext? ctx, ListCarePlansRequest request) =>
      _client.invoke<ListCarePlansResponse>(ctx, 'ClinicalService',
          'ListCarePlans', request, ListCarePlansResponse());

  /// SRS-CLN-001. Assembled server-side, because a banner that differs between
  /// screens is worse than none.
  $async.Future<GetBannerResponse> getBanner(
          $pb.ClientContext? ctx, GetBannerRequest request) =>
      _client.invoke<GetBannerResponse>(
          ctx, 'ClinicalService', 'GetBanner', request, GetBannerResponse());

  /// SRS-CLN-013. Clinical consent, deliberately not the privacy consent of
  /// SRS-EMPI-013.
  $async.Future<RecordConsentResponse> recordConsent(
          $pb.ClientContext? ctx, RecordConsentRequest request) =>
      _client.invoke<RecordConsentResponse>(ctx, 'ClinicalService',
          'RecordConsent', request, RecordConsentResponse());
  $async.Future<WithdrawConsentResponse> withdrawConsent(
          $pb.ClientContext? ctx, WithdrawConsentRequest request) =>
      _client.invoke<WithdrawConsentResponse>(ctx, 'ClinicalService',
          'WithdrawConsent', request, WithdrawConsentResponse());
  $async.Future<ListConsentsResponse> listConsents(
          $pb.ClientContext? ctx, ListConsentsRequest request) =>
      _client.invoke<ListConsentsResponse>(ctx, 'ClinicalService',
          'ListConsents', request, ListConsentsResponse());

  /// SRS-CLN-010, SRS-CLN-014. Access follows the parent record and the
  /// attachment's own classification.
  $async.Future<AttachFileResponse> attachFile(
          $pb.ClientContext? ctx, AttachFileRequest request) =>
      _client.invoke<AttachFileResponse>(
          ctx, 'ClinicalService', 'AttachFile', request, AttachFileResponse());
  $async.Future<ListAttachmentsResponse> listAttachments(
          $pb.ClientContext? ctx, ListAttachmentsRequest request) =>
      _client.invoke<ListAttachmentsResponse>(ctx, 'ClinicalService',
          'ListAttachments', request, ListAttachmentsResponse());
  $async.Future<GetProvenanceResponse> getProvenance(
          $pb.ClientContext? ctx, GetProvenanceRequest request) =>
      _client.invoke<GetProvenanceResponse>(ctx, 'ClinicalService',
          'GetProvenance', request, GetProvenanceResponse());

  /// SRS-CLN-020. Recalculation with a new formula never overwrites a
  /// historical result.
  $async.Future<StoreCalculationResponse> storeCalculation(
          $pb.ClientContext? ctx, StoreCalculationRequest request) =>
      _client.invoke<StoreCalculationResponse>(ctx, 'ClinicalService',
          'StoreCalculation', request, StoreCalculationResponse());
  $async.Future<ListCalculationsResponse> listCalculations(
          $pb.ClientContext? ctx, ListCalculationsRequest request) =>
      _client.invoke<ListCalculationsResponse>(ctx, 'ClinicalService',
          'ListCalculations', request, ListCalculationsResponse());

  /// SRS-CLN-021. Alerts identify the triggering rule and version; overrides are
  /// stored and reportable.
  $async.Future<RaiseAlertResponse> raiseAlert(
          $pb.ClientContext? ctx, RaiseAlertRequest request) =>
      _client.invoke<RaiseAlertResponse>(
          ctx, 'ClinicalService', 'RaiseAlert', request, RaiseAlertResponse());
  $async.Future<RespondToAlertResponse> respondToAlert(
          $pb.ClientContext? ctx, RespondToAlertRequest request) =>
      _client.invoke<RespondToAlertResponse>(ctx, 'ClinicalService',
          'RespondToAlert', request, RespondToAlertResponse());
  $async.Future<ListAlertsResponse> listAlerts(
          $pb.ClientContext? ctx, ListAlertsRequest request) =>
      _client.invoke<ListAlertsResponse>(
          ctx, 'ClinicalService', 'ListAlerts', request, ListAlertsResponse());

  /// SRS-CLN-022. The response closes the loop and stays linked to the request.
  $async.Future<RequestConsultResponse> requestConsult(
          $pb.ClientContext? ctx, RequestConsultRequest request) =>
      _client.invoke<RequestConsultResponse>(ctx, 'ClinicalService',
          'RequestConsult', request, RequestConsultResponse());
  $async.Future<RespondToConsultResponse> respondToConsult(
          $pb.ClientContext? ctx, RespondToConsultRequest request) =>
      _client.invoke<RespondToConsultResponse>(ctx, 'ClinicalService',
          'RespondToConsult', request, RespondToConsultResponse());
  $async.Future<ListConsultsResponse> listConsults(
          $pb.ClientContext? ctx, ListConsultsRequest request) =>
      _client.invoke<ListConsultsResponse>(ctx, 'ClinicalService',
          'ListConsults', request, ListConsultsResponse());

  /// SRS-CLN-023. Membership points at canonical clinical facts rather than
  /// copying the chart.
  $async.Future<EnrolInRegistryResponse> enrolInRegistry(
          $pb.ClientContext? ctx, EnrolInRegistryRequest request) =>
      _client.invoke<EnrolInRegistryResponse>(ctx, 'ClinicalService',
          'EnrolInRegistry', request, EnrolInRegistryResponse());
  $async.Future<ExitRegistryResponse> exitRegistry(
          $pb.ClientContext? ctx, ExitRegistryRequest request) =>
      _client.invoke<ExitRegistryResponse>(ctx, 'ClinicalService',
          'ExitRegistry', request, ExitRegistryResponse());
  $async.Future<ListRegistryMembershipsResponse> listRegistryMemberships(
          $pb.ClientContext? ctx, ListRegistryMembershipsRequest request) =>
      _client.invoke<ListRegistryMembershipsResponse>(
          ctx,
          'ClinicalService',
          'ListRegistryMemberships',
          request,
          ListRegistryMembershipsResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
