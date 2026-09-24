// This is a generated file - do not edit.
//
// Generated from healthcare/records/v1/records.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// What a checklist item asks for (SRS-MRD-001).
class DocumentRequirement extends $pb.ProtobufEnum {
  static const DocumentRequirement DOCUMENT_REQUIREMENT_UNSPECIFIED =
      DocumentRequirement._(
          0, _omitEnumNames ? '' : 'DOCUMENT_REQUIREMENT_UNSPECIFIED');

  /// Present and signed. A discharge summary nobody signed is a draft.
  static const DocumentRequirement DOCUMENT_REQUIREMENT_SIGNED =
      DocumentRequirement._(
          1, _omitEnumNames ? '' : 'DOCUMENT_REQUIREMENT_SIGNED');

  /// Present is enough — a scanned consent form, a pathology report.
  static const DocumentRequirement DOCUMENT_REQUIREMENT_PRESENT =
      DocumentRequirement._(
          2, _omitEnumNames ? '' : 'DOCUMENT_REQUIREMENT_PRESENT');

  /// Required only when the encounter's facts say so: an operation note when
  /// there was an operation.
  static const DocumentRequirement DOCUMENT_REQUIREMENT_CONDITIONAL =
      DocumentRequirement._(
          3, _omitEnumNames ? '' : 'DOCUMENT_REQUIREMENT_CONDITIONAL');

  static const $core.List<DocumentRequirement> values = <DocumentRequirement>[
    DOCUMENT_REQUIREMENT_UNSPECIFIED,
    DOCUMENT_REQUIREMENT_SIGNED,
    DOCUMENT_REQUIREMENT_PRESENT,
    DOCUMENT_REQUIREMENT_CONDITIONAL,
  ];

  static final $core.List<DocumentRequirement?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static DocumentRequirement? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DocumentRequirement._(super.value, super.name);
}

/// What is wrong with a chart (SRS-MRD-002).
class DeficiencyKind extends $pb.ProtobufEnum {
  static const DeficiencyKind DEFICIENCY_KIND_UNSPECIFIED =
      DeficiencyKind._(0, _omitEnumNames ? '' : 'DEFICIENCY_KIND_UNSPECIFIED');
  static const DeficiencyKind DEFICIENCY_KIND_MISSING_DOCUMENT =
      DeficiencyKind._(
          1, _omitEnumNames ? '' : 'DEFICIENCY_KIND_MISSING_DOCUMENT');
  static const DeficiencyKind DEFICIENCY_KIND_UNSIGNED_DOCUMENT =
      DeficiencyKind._(
          2, _omitEnumNames ? '' : 'DEFICIENCY_KIND_UNSIGNED_DOCUMENT');

  /// Present and signed and not good enough. Answered by an addendum, never
  /// by changing the original.
  static const DeficiencyKind DEFICIENCY_KIND_INCOMPLETE_DOCUMENT =
      DeficiencyKind._(
          3, _omitEnumNames ? '' : 'DEFICIENCY_KIND_INCOMPLETE_DOCUMENT');

  /// A coder's question back to the clinician.
  static const DeficiencyKind DEFICIENCY_KIND_CODING_QUERY =
      DeficiencyKind._(4, _omitEnumNames ? '' : 'DEFICIENCY_KIND_CODING_QUERY');

  static const $core.List<DeficiencyKind> values = <DeficiencyKind>[
    DEFICIENCY_KIND_UNSPECIFIED,
    DEFICIENCY_KIND_MISSING_DOCUMENT,
    DEFICIENCY_KIND_UNSIGNED_DOCUMENT,
    DEFICIENCY_KIND_INCOMPLETE_DOCUMENT,
    DEFICIENCY_KIND_CODING_QUERY,
  ];

  static final $core.List<DeficiencyKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static DeficiencyKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DeficiencyKind._(super.value, super.name);
}

/// Where a deficiency stands (SRS-MRD-002).
class DeficiencyState extends $pb.ProtobufEnum {
  static const DeficiencyState DEFICIENCY_STATE_UNSPECIFIED = DeficiencyState._(
      0, _omitEnumNames ? '' : 'DEFICIENCY_STATE_UNSPECIFIED');
  static const DeficiencyState DEFICIENCY_STATE_OPEN =
      DeficiencyState._(1, _omitEnumNames ? '' : 'DEFICIENCY_STATE_OPEN');
  static const DeficiencyState DEFICIENCY_STATE_RESOLVED =
      DeficiencyState._(2, _omitEnumNames ? '' : 'DEFICIENCY_STATE_RESOLVED');

  /// Written off. Never the same as resolved: the document never arrived.
  static const DeficiencyState DEFICIENCY_STATE_WAIVED =
      DeficiencyState._(3, _omitEnumNames ? '' : 'DEFICIENCY_STATE_WAIVED');

  static const $core.List<DeficiencyState> values = <DeficiencyState>[
    DEFICIENCY_STATE_UNSPECIFIED,
    DEFICIENCY_STATE_OPEN,
    DEFICIENCY_STATE_RESOLVED,
    DEFICIENCY_STATE_WAIVED,
  ];

  static final $core.List<DeficiencyState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static DeficiencyState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DeficiencyState._(super.value, super.name);
}

/// What a code is doing on an episode (SRS-MRD-003).
class CodeRole extends $pb.ProtobufEnum {
  static const CodeRole CODE_ROLE_UNSPECIFIED =
      CodeRole._(0, _omitEnumNames ? '' : 'CODE_ROLE_UNSPECIFIED');
  static const CodeRole CODE_ROLE_PRINCIPAL_DIAGNOSIS =
      CodeRole._(1, _omitEnumNames ? '' : 'CODE_ROLE_PRINCIPAL_DIAGNOSIS');
  static const CodeRole CODE_ROLE_SECONDARY_DIAGNOSIS =
      CodeRole._(2, _omitEnumNames ? '' : 'CODE_ROLE_SECONDARY_DIAGNOSIS');
  static const CodeRole CODE_ROLE_PRINCIPAL_PROCEDURE =
      CodeRole._(3, _omitEnumNames ? '' : 'CODE_ROLE_PRINCIPAL_PROCEDURE');
  static const CodeRole CODE_ROLE_SECONDARY_PROCEDURE =
      CodeRole._(4, _omitEnumNames ? '' : 'CODE_ROLE_SECONDARY_PROCEDURE');
  static const CodeRole CODE_ROLE_EXTERNAL_CAUSE =
      CodeRole._(5, _omitEnumNames ? '' : 'CODE_ROLE_EXTERNAL_CAUSE');
  static const CodeRole CODE_ROLE_MORPHOLOGY =
      CodeRole._(6, _omitEnumNames ? '' : 'CODE_ROLE_MORPHOLOGY');

  static const $core.List<CodeRole> values = <CodeRole>[
    CODE_ROLE_UNSPECIFIED,
    CODE_ROLE_PRINCIPAL_DIAGNOSIS,
    CODE_ROLE_SECONDARY_DIAGNOSIS,
    CODE_ROLE_PRINCIPAL_PROCEDURE,
    CODE_ROLE_SECONDARY_PROCEDURE,
    CODE_ROLE_EXTERNAL_CAUSE,
    CODE_ROLE_MORPHOLOGY,
  ];

  static final $core.List<CodeRole?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static CodeRole? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CodeRole._(super.value, super.name);
}

/// Whether a diagnosis was there on arrival (SRS-MRD-003).
///
/// Required on a diagnosis and forbidden on a procedure. Defaulting it would
/// bias every hospital-acquired complication rate computed from coded data, in
/// whichever direction the default fell.
class PresentOnAdmission extends $pb.ProtobufEnum {
  static const PresentOnAdmission PRESENT_ON_ADMISSION_UNSPECIFIED =
      PresentOnAdmission._(
          0, _omitEnumNames ? '' : 'PRESENT_ON_ADMISSION_UNSPECIFIED');
  static const PresentOnAdmission PRESENT_ON_ADMISSION_YES =
      PresentOnAdmission._(1, _omitEnumNames ? '' : 'PRESENT_ON_ADMISSION_YES');
  static const PresentOnAdmission PRESENT_ON_ADMISSION_NO =
      PresentOnAdmission._(2, _omitEnumNames ? '' : 'PRESENT_ON_ADMISSION_NO');

  /// The record does not say. A real answer, and not the same as "no".
  static const PresentOnAdmission PRESENT_ON_ADMISSION_UNDETERMINED =
      PresentOnAdmission._(
          3, _omitEnumNames ? '' : 'PRESENT_ON_ADMISSION_UNDETERMINED');

  /// For a procedure, which was never "present".
  static const PresentOnAdmission PRESENT_ON_ADMISSION_NOT_APPLICABLE =
      PresentOnAdmission._(
          4, _omitEnumNames ? '' : 'PRESENT_ON_ADMISSION_NOT_APPLICABLE');

  static const $core.List<PresentOnAdmission> values = <PresentOnAdmission>[
    PRESENT_ON_ADMISSION_UNSPECIFIED,
    PRESENT_ON_ADMISSION_YES,
    PRESENT_ON_ADMISSION_NO,
    PRESENT_ON_ADMISSION_UNDETERMINED,
    PRESENT_ON_ADMISSION_NOT_APPLICABLE,
  ];

  static final $core.List<PresentOnAdmission?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static PresentOnAdmission? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PresentOnAdmission._(super.value, super.name);
}

/// Where a coding stands (SRS-MRD-003).
class CodingState extends $pb.ProtobufEnum {
  static const CodingState CODING_STATE_UNSPECIFIED =
      CodingState._(0, _omitEnumNames ? '' : 'CODING_STATE_UNSPECIFIED');
  static const CodingState CODING_STATE_IN_PROGRESS =
      CodingState._(1, _omitEnumNames ? '' : 'CODING_STATE_IN_PROGRESS');
  static const CodingState CODING_STATE_CODED =
      CodingState._(2, _omitEnumNames ? '' : 'CODING_STATE_CODED');

  /// A second reader has agreed. The domain refuses the coder.
  static const CodingState CODING_STATE_FINAL =
      CodingState._(3, _omitEnumNames ? '' : 'CODING_STATE_FINAL');

  /// A question is outstanding with the clinician, and a queried episode
  /// cannot be finalised.
  static const CodingState CODING_STATE_QUERIED =
      CodingState._(4, _omitEnumNames ? '' : 'CODING_STATE_QUERIED');

  static const $core.List<CodingState> values = <CodingState>[
    CODING_STATE_UNSPECIFIED,
    CODING_STATE_IN_PROGRESS,
    CODING_STATE_CODED,
    CODING_STATE_FINAL,
    CODING_STATE_QUERIED,
  ];

  static final $core.List<CodingState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CodingState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CodingState._(super.value, super.name);
}

/// What makes a release lawful (SRS-MRD-004).
class AuthorityKind extends $pb.ProtobufEnum {
  static const AuthorityKind AUTHORITY_KIND_UNSPECIFIED =
      AuthorityKind._(0, _omitEnumNames ? '' : 'AUTHORITY_KIND_UNSPECIFIED');
  static const AuthorityKind AUTHORITY_KIND_PATIENT_CONSENT = AuthorityKind._(
      1, _omitEnumNames ? '' : 'AUTHORITY_KIND_PATIENT_CONSENT');

  /// A parent, guardian or attorney. Apart from the patient's own consent
  /// because the representative's standing is what gets checked and what
  /// expires.
  static const AuthorityKind AUTHORITY_KIND_AUTHORISED_REPRESENTATIVE =
      AuthorityKind._(
          2, _omitEnumNames ? '' : 'AUTHORITY_KIND_AUTHORISED_REPRESENTATIVE');
  static const AuthorityKind AUTHORITY_KIND_COURT_ORDER =
      AuthorityKind._(3, _omitEnumNames ? '' : 'AUTHORITY_KIND_COURT_ORDER');
  static const AuthorityKind AUTHORITY_KIND_STATUTORY_REQUIREMENT =
      AuthorityKind._(
          4, _omitEnumNames ? '' : 'AUTHORITY_KIND_STATUTORY_REQUIREMENT');
  static const AuthorityKind AUTHORITY_KIND_CONTINUITY_OF_CARE =
      AuthorityKind._(
          5, _omitEnumNames ? '' : 'AUTHORITY_KIND_CONTINUITY_OF_CARE');
  static const AuthorityKind AUTHORITY_KIND_INSURANCE_CLAIM = AuthorityKind._(
      6, _omitEnumNames ? '' : 'AUTHORITY_KIND_INSURANCE_CLAIM');

  static const $core.List<AuthorityKind> values = <AuthorityKind>[
    AUTHORITY_KIND_UNSPECIFIED,
    AUTHORITY_KIND_PATIENT_CONSENT,
    AUTHORITY_KIND_AUTHORISED_REPRESENTATIVE,
    AUTHORITY_KIND_COURT_ORDER,
    AUTHORITY_KIND_STATUTORY_REQUIREMENT,
    AUTHORITY_KIND_CONTINUITY_OF_CARE,
    AUTHORITY_KIND_INSURANCE_CLAIM,
  ];

  static final $core.List<AuthorityKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static AuthorityKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AuthorityKind._(super.value, super.name);
}

/// Who is receiving a record (SRS-MRD-004).
class RecipientKind extends $pb.ProtobufEnum {
  static const RecipientKind RECIPIENT_KIND_UNSPECIFIED =
      RecipientKind._(0, _omitEnumNames ? '' : 'RECIPIENT_KIND_UNSPECIFIED');
  static const RecipientKind RECIPIENT_KIND_PATIENT =
      RecipientKind._(1, _omitEnumNames ? '' : 'RECIPIENT_KIND_PATIENT');
  static const RecipientKind RECIPIENT_KIND_TREATING_CLINICIAN =
      RecipientKind._(
          2, _omitEnumNames ? '' : 'RECIPIENT_KIND_TREATING_CLINICIAN');
  static const RecipientKind RECIPIENT_KIND_INSTITUTION =
      RecipientKind._(3, _omitEnumNames ? '' : 'RECIPIENT_KIND_INSTITUTION');
  static const RecipientKind RECIPIENT_KIND_INSURER =
      RecipientKind._(4, _omitEnumNames ? '' : 'RECIPIENT_KIND_INSURER');
  static const RecipientKind RECIPIENT_KIND_LEGAL =
      RecipientKind._(5, _omitEnumNames ? '' : 'RECIPIENT_KIND_LEGAL');
  static const RecipientKind RECIPIENT_KIND_GOVERNMENT_BODY = RecipientKind._(
      6, _omitEnumNames ? '' : 'RECIPIENT_KIND_GOVERNMENT_BODY');

  static const $core.List<RecipientKind> values = <RecipientKind>[
    RECIPIENT_KIND_UNSPECIFIED,
    RECIPIENT_KIND_PATIENT,
    RECIPIENT_KIND_TREATING_CLINICIAN,
    RECIPIENT_KIND_INSTITUTION,
    RECIPIENT_KIND_INSURER,
    RECIPIENT_KIND_LEGAL,
    RECIPIENT_KIND_GOVERNMENT_BODY,
  ];

  static final $core.List<RecipientKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static RecipientKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RecipientKind._(super.value, super.name);
}

/// Where a release stands (SRS-MRD-004).
class ReleaseState extends $pb.ProtobufEnum {
  static const ReleaseState RELEASE_STATE_UNSPECIFIED =
      ReleaseState._(0, _omitEnumNames ? '' : 'RELEASE_STATE_UNSPECIFIED');
  static const ReleaseState RELEASE_STATE_REQUESTED =
      ReleaseState._(1, _omitEnumNames ? '' : 'RELEASE_STATE_REQUESTED');
  static const ReleaseState RELEASE_STATE_APPROVED =
      ReleaseState._(2, _omitEnumNames ? '' : 'RELEASE_STATE_APPROVED');
  static const ReleaseState RELEASE_STATE_ASSEMBLED =
      ReleaseState._(3, _omitEnumNames ? '' : 'RELEASE_STATE_ASSEMBLED');
  static const ReleaseState RELEASE_STATE_RELEASED =
      ReleaseState._(4, _omitEnumNames ? '' : 'RELEASE_STATE_RELEASED');
  static const ReleaseState RELEASE_STATE_REFUSED =
      ReleaseState._(5, _omitEnumNames ? '' : 'RELEASE_STATE_REFUSED');

  static const $core.List<ReleaseState> values = <ReleaseState>[
    RELEASE_STATE_UNSPECIFIED,
    RELEASE_STATE_REQUESTED,
    RELEASE_STATE_APPROVED,
    RELEASE_STATE_ASSEMBLED,
    RELEASE_STATE_RELEASED,
    RELEASE_STATE_REFUSED,
  ];

  static final $core.List<ReleaseState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ReleaseState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReleaseState._(super.value, super.name);
}

/// How a record left (SRS-MRD-010).
class DisclosureKind extends $pb.ProtobufEnum {
  static const DisclosureKind DISCLOSURE_KIND_UNSPECIFIED =
      DisclosureKind._(0, _omitEnumNames ? '' : 'DISCLOSURE_KIND_UNSPECIFIED');
  static const DisclosureKind DISCLOSURE_KIND_RELEASE =
      DisclosureKind._(1, _omitEnumNames ? '' : 'DISCLOSURE_KIND_RELEASE');
  static const DisclosureKind DISCLOSURE_KIND_EXPORT =
      DisclosureKind._(2, _omitEnumNames ? '' : 'DISCLOSURE_KIND_EXPORT');
  static const DisclosureKind DISCLOSURE_KIND_PRINT =
      DisclosureKind._(3, _omitEnumNames ? '' : 'DISCLOSURE_KIND_PRINT');

  static const $core.List<DisclosureKind> values = <DisclosureKind>[
    DISCLOSURE_KIND_UNSPECIFIED,
    DISCLOSURE_KIND_RELEASE,
    DISCLOSURE_KIND_EXPORT,
    DISCLOSURE_KIND_PRINT,
  ];

  static final $core.List<DisclosureKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static DisclosureKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DisclosureKind._(super.value, super.name);
}

/// What a retention period is counted from (SRS-MRD-009).
class RetentionAnchor extends $pb.ProtobufEnum {
  static const RetentionAnchor RETENTION_ANCHOR_UNSPECIFIED = RetentionAnchor._(
      0, _omitEnumNames ? '' : 'RETENTION_ANCHOR_UNSPECIFIED');
  static const RetentionAnchor RETENTION_ANCHOR_DISCHARGE =
      RetentionAnchor._(1, _omitEnumNames ? '' : 'RETENTION_ANCHOR_DISCHARGE');
  static const RetentionAnchor RETENTION_ANCHOR_LAST_CONTACT =
      RetentionAnchor._(
          2, _omitEnumNames ? '' : 'RETENTION_ANCHOR_LAST_CONTACT');
  static const RetentionAnchor RETENTION_ANCHOR_DEATH =
      RetentionAnchor._(3, _omitEnumNames ? '' : 'RETENTION_ANCHOR_DEATH');

  /// A child's records run from the age of majority, not from the encounter.
  static const RetentionAnchor RETENTION_ANCHOR_MAJORITY =
      RetentionAnchor._(4, _omitEnumNames ? '' : 'RETENTION_ANCHOR_MAJORITY');
  static const RetentionAnchor RETENTION_ANCHOR_CREATION =
      RetentionAnchor._(5, _omitEnumNames ? '' : 'RETENTION_ANCHOR_CREATION');

  static const $core.List<RetentionAnchor> values = <RetentionAnchor>[
    RETENTION_ANCHOR_UNSPECIFIED,
    RETENTION_ANCHOR_DISCHARGE,
    RETENTION_ANCHOR_LAST_CONTACT,
    RETENTION_ANCHOR_DEATH,
    RETENTION_ANCHOR_MAJORITY,
    RETENTION_ANCHOR_CREATION,
  ];

  static final $core.List<RetentionAnchor?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static RetentionAnchor? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RetentionAnchor._(super.value, super.name);
}

/// What happens when a retention period runs out (SRS-MRD-009).
class DispositionKind extends $pb.ProtobufEnum {
  static const DispositionKind DISPOSITION_KIND_UNSPECIFIED = DispositionKind._(
      0, _omitEnumNames ? '' : 'DISPOSITION_KIND_UNSPECIFIED');
  static const DispositionKind DISPOSITION_KIND_DESTROY =
      DispositionKind._(1, _omitEnumNames ? '' : 'DISPOSITION_KIND_DESTROY');
  static const DispositionKind DISPOSITION_KIND_ARCHIVE =
      DispositionKind._(2, _omitEnumNames ? '' : 'DISPOSITION_KIND_ARCHIVE');

  /// Kept for ever, which is a decision and not the absence of one.
  static const DispositionKind DISPOSITION_KIND_PERMANENT =
      DispositionKind._(3, _omitEnumNames ? '' : 'DISPOSITION_KIND_PERMANENT');

  static const $core.List<DispositionKind> values = <DispositionKind>[
    DISPOSITION_KIND_UNSPECIFIED,
    DISPOSITION_KIND_DESTROY,
    DISPOSITION_KIND_ARCHIVE,
    DISPOSITION_KIND_PERMANENT,
  ];

  static final $core.List<DispositionKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static DispositionKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DispositionKind._(super.value, super.name);
}

/// Where a disposition list stands (SRS-MRD-009).
class DispositionState extends $pb.ProtobufEnum {
  static const DispositionState DISPOSITION_STATE_UNSPECIFIED =
      DispositionState._(
          0, _omitEnumNames ? '' : 'DISPOSITION_STATE_UNSPECIFIED');
  static const DispositionState DISPOSITION_STATE_DRAFT =
      DispositionState._(1, _omitEnumNames ? '' : 'DISPOSITION_STATE_DRAFT');
  static const DispositionState DISPOSITION_STATE_APPROVED =
      DispositionState._(2, _omitEnumNames ? '' : 'DISPOSITION_STATE_APPROVED');
  static const DispositionState DISPOSITION_STATE_EXECUTED =
      DispositionState._(3, _omitEnumNames ? '' : 'DISPOSITION_STATE_EXECUTED');
  static const DispositionState DISPOSITION_STATE_CANCELLED =
      DispositionState._(
          4, _omitEnumNames ? '' : 'DISPOSITION_STATE_CANCELLED');

  static const $core.List<DispositionState> values = <DispositionState>[
    DISPOSITION_STATE_UNSPECIFIED,
    DISPOSITION_STATE_DRAFT,
    DISPOSITION_STATE_APPROVED,
    DISPOSITION_STATE_EXECUTED,
    DISPOSITION_STATE_CANCELLED,
  ];

  static final $core.List<DispositionState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static DispositionState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DispositionState._(super.value, super.name);
}

/// Where a paper volume is (SRS-MRD-006).
class PhysicalState extends $pb.ProtobufEnum {
  static const PhysicalState PHYSICAL_STATE_UNSPECIFIED =
      PhysicalState._(0, _omitEnumNames ? '' : 'PHYSICAL_STATE_UNSPECIFIED');
  static const PhysicalState PHYSICAL_STATE_FILED =
      PhysicalState._(1, _omitEnumNames ? '' : 'PHYSICAL_STATE_FILED');
  static const PhysicalState PHYSICAL_STATE_CHECKED_OUT =
      PhysicalState._(2, _omitEnumNames ? '' : 'PHYSICAL_STATE_CHECKED_OUT');
  static const PhysicalState PHYSICAL_STATE_ARCHIVED =
      PhysicalState._(3, _omitEnumNames ? '' : 'PHYSICAL_STATE_ARCHIVED');
  static const PhysicalState PHYSICAL_STATE_MISSING =
      PhysicalState._(4, _omitEnumNames ? '' : 'PHYSICAL_STATE_MISSING');
  static const PhysicalState PHYSICAL_STATE_DESTROYED =
      PhysicalState._(5, _omitEnumNames ? '' : 'PHYSICAL_STATE_DESTROYED');

  static const $core.List<PhysicalState> values = <PhysicalState>[
    PHYSICAL_STATE_UNSPECIFIED,
    PHYSICAL_STATE_FILED,
    PHYSICAL_STATE_CHECKED_OUT,
    PHYSICAL_STATE_ARCHIVED,
    PHYSICAL_STATE_MISSING,
    PHYSICAL_STATE_DESTROYED,
  ];

  static final $core.List<PhysicalState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static PhysicalState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PhysicalState._(super.value, super.name);
}

/// What a statutory certificate certifies (SRS-MRD-007).
class CertificateKind extends $pb.ProtobufEnum {
  static const CertificateKind CERTIFICATE_KIND_UNSPECIFIED = CertificateKind._(
      0, _omitEnumNames ? '' : 'CERTIFICATE_KIND_UNSPECIFIED');
  static const CertificateKind CERTIFICATE_KIND_BIRTH =
      CertificateKind._(1, _omitEnumNames ? '' : 'CERTIFICATE_KIND_BIRTH');
  static const CertificateKind CERTIFICATE_KIND_DEATH =
      CertificateKind._(2, _omitEnumNames ? '' : 'CERTIFICATE_KIND_DEATH');
  static const CertificateKind CERTIFICATE_KIND_STILLBIRTH =
      CertificateKind._(3, _omitEnumNames ? '' : 'CERTIFICATE_KIND_STILLBIRTH');
  static const CertificateKind CERTIFICATE_KIND_MEDICAL =
      CertificateKind._(4, _omitEnumNames ? '' : 'CERTIFICATE_KIND_MEDICAL');
  static const CertificateKind CERTIFICATE_KIND_CAUSE_OF_DEATH =
      CertificateKind._(
          5, _omitEnumNames ? '' : 'CERTIFICATE_KIND_CAUSE_OF_DEATH');

  static const $core.List<CertificateKind> values = <CertificateKind>[
    CERTIFICATE_KIND_UNSPECIFIED,
    CERTIFICATE_KIND_BIRTH,
    CERTIFICATE_KIND_DEATH,
    CERTIFICATE_KIND_STILLBIRTH,
    CERTIFICATE_KIND_MEDICAL,
    CERTIFICATE_KIND_CAUSE_OF_DEATH,
  ];

  static final $core.List<CertificateKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static CertificateKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CertificateKind._(super.value, super.name);
}

/// Whether a certificate still stands (SRS-MRD-007).
class CertificateState extends $pb.ProtobufEnum {
  static const CertificateState CERTIFICATE_STATE_UNSPECIFIED =
      CertificateState._(
          0, _omitEnumNames ? '' : 'CERTIFICATE_STATE_UNSPECIFIED');
  static const CertificateState CERTIFICATE_STATE_ISSUED =
      CertificateState._(1, _omitEnumNames ? '' : 'CERTIFICATE_STATE_ISSUED');
  static const CertificateState CERTIFICATE_STATE_VOIDED =
      CertificateState._(2, _omitEnumNames ? '' : 'CERTIFICATE_STATE_VOIDED');

  static const $core.List<CertificateState> values = <CertificateState>[
    CERTIFICATE_STATE_UNSPECIFIED,
    CERTIFICATE_STATE_ISSUED,
    CERTIFICATE_STATE_VOIDED,
  ];

  static final $core.List<CertificateState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static CertificateState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CertificateState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
