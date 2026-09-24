// This is a generated file - do not edit.
//
// Generated from healthcare/quality/v1/quality.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// How far an event got (SRS-QMS-001).
class Reach extends $pb.ProtobufEnum {
  static const Reach REACH_UNSPECIFIED =
      Reach._(0, _omitEnumNames ? '' : 'REACH_UNSPECIFIED');

  /// Never got to the patient. Caught by a check, a person, or luck — and a
  /// free lesson.
  static const Reach REACH_NEAR_MISS =
      Reach._(1, _omitEnumNames ? '' : 'REACH_NEAR_MISS');

  /// Got to the patient and did nothing to them.
  static const Reach REACH_NO_HARM =
      Reach._(2, _omitEnumNames ? '' : 'REACH_NO_HARM');

  /// Got to the patient and hurt them.
  static const Reach REACH_HARM =
      Reach._(3, _omitEnumNames ? '' : 'REACH_HARM');

  /// Did not involve a patient: a staff injury, a property loss.
  static const Reach REACH_NOT_PATIENT =
      Reach._(4, _omitEnumNames ? '' : 'REACH_NOT_PATIENT');

  static const $core.List<Reach> values = <Reach>[
    REACH_UNSPECIFIED,
    REACH_NEAR_MISS,
    REACH_NO_HARM,
    REACH_HARM,
    REACH_NOT_PATIENT,
  ];

  static final $core.List<Reach?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Reach? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Reach._(super.value, super.name);
}

/// How badly somebody was hurt (SRS-QMS-001).
class Harm extends $pb.ProtobufEnum {
  static const Harm HARM_UNSPECIFIED =
      Harm._(0, _omitEnumNames ? '' : 'HARM_UNSPECIFIED');
  static const Harm HARM_NONE = Harm._(1, _omitEnumNames ? '' : 'HARM_NONE');
  static const Harm HARM_MILD = Harm._(2, _omitEnumNames ? '' : 'HARM_MILD');
  static const Harm HARM_MODERATE =
      Harm._(3, _omitEnumNames ? '' : 'HARM_MODERATE');
  static const Harm HARM_SEVERE =
      Harm._(4, _omitEnumNames ? '' : 'HARM_SEVERE');

  /// A death is always a sentinel event, whatever the reporter ticked.
  static const Harm HARM_DEATH = Harm._(5, _omitEnumNames ? '' : 'HARM_DEATH');

  static const $core.List<Harm> values = <Harm>[
    HARM_UNSPECIFIED,
    HARM_NONE,
    HARM_MILD,
    HARM_MODERATE,
    HARM_SEVERE,
    HARM_DEATH,
  ];

  static final $core.List<Harm?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static Harm? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Harm._(super.value, super.name);
}

/// How bad the outcome was or could have been (SRS-QMS-002).
class Consequence extends $pb.ProtobufEnum {
  static const Consequence CONSEQUENCE_UNSPECIFIED =
      Consequence._(0, _omitEnumNames ? '' : 'CONSEQUENCE_UNSPECIFIED');
  static const Consequence CONSEQUENCE_NEGLIGIBLE =
      Consequence._(1, _omitEnumNames ? '' : 'CONSEQUENCE_NEGLIGIBLE');
  static const Consequence CONSEQUENCE_MINOR =
      Consequence._(2, _omitEnumNames ? '' : 'CONSEQUENCE_MINOR');
  static const Consequence CONSEQUENCE_MODERATE =
      Consequence._(3, _omitEnumNames ? '' : 'CONSEQUENCE_MODERATE');
  static const Consequence CONSEQUENCE_MAJOR =
      Consequence._(4, _omitEnumNames ? '' : 'CONSEQUENCE_MAJOR');
  static const Consequence CONSEQUENCE_CATASTROPHIC =
      Consequence._(5, _omitEnumNames ? '' : 'CONSEQUENCE_CATASTROPHIC');

  static const $core.List<Consequence> values = <Consequence>[
    CONSEQUENCE_UNSPECIFIED,
    CONSEQUENCE_NEGLIGIBLE,
    CONSEQUENCE_MINOR,
    CONSEQUENCE_MODERATE,
    CONSEQUENCE_MAJOR,
    CONSEQUENCE_CATASTROPHIC,
  ];

  static final $core.List<Consequence?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static Consequence? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Consequence._(super.value, super.name);
}

/// How often this is expected to happen again (SRS-QMS-002).
class Likelihood extends $pb.ProtobufEnum {
  static const Likelihood LIKELIHOOD_UNSPECIFIED =
      Likelihood._(0, _omitEnumNames ? '' : 'LIKELIHOOD_UNSPECIFIED');
  static const Likelihood LIKELIHOOD_RARE =
      Likelihood._(1, _omitEnumNames ? '' : 'LIKELIHOOD_RARE');
  static const Likelihood LIKELIHOOD_UNLIKELY =
      Likelihood._(2, _omitEnumNames ? '' : 'LIKELIHOOD_UNLIKELY');
  static const Likelihood LIKELIHOOD_POSSIBLE =
      Likelihood._(3, _omitEnumNames ? '' : 'LIKELIHOOD_POSSIBLE');
  static const Likelihood LIKELIHOOD_LIKELY =
      Likelihood._(4, _omitEnumNames ? '' : 'LIKELIHOOD_LIKELY');
  static const Likelihood LIKELIHOOD_ALMOST_CERTAIN =
      Likelihood._(5, _omitEnumNames ? '' : 'LIKELIHOOD_ALMOST_CERTAIN');

  static const $core.List<Likelihood> values = <Likelihood>[
    LIKELIHOOD_UNSPECIFIED,
    LIKELIHOOD_RARE,
    LIKELIHOOD_UNLIKELY,
    LIKELIHOOD_POSSIBLE,
    LIKELIHOOD_LIKELY,
    LIKELIHOOD_ALMOST_CERTAIN,
  ];

  static final $core.List<Likelihood?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static Likelihood? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Likelihood._(super.value, super.name);
}

/// Where a score falls (SRS-QMS-002).
class RiskBand extends $pb.ProtobufEnum {
  static const RiskBand RISK_BAND_UNSPECIFIED =
      RiskBand._(0, _omitEnumNames ? '' : 'RISK_BAND_UNSPECIFIED');
  static const RiskBand RISK_BAND_LOW =
      RiskBand._(1, _omitEnumNames ? '' : 'RISK_BAND_LOW');
  static const RiskBand RISK_BAND_MODERATE =
      RiskBand._(2, _omitEnumNames ? '' : 'RISK_BAND_MODERATE');
  static const RiskBand RISK_BAND_HIGH =
      RiskBand._(3, _omitEnumNames ? '' : 'RISK_BAND_HIGH');
  static const RiskBand RISK_BAND_EXTREME =
      RiskBand._(4, _omitEnumNames ? '' : 'RISK_BAND_EXTREME');

  static const $core.List<RiskBand> values = <RiskBand>[
    RISK_BAND_UNSPECIFIED,
    RISK_BAND_LOW,
    RISK_BAND_MODERATE,
    RISK_BAND_HIGH,
    RISK_BAND_EXTREME,
  ];

  static final $core.List<RiskBand?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static RiskBand? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RiskBand._(super.value, super.name);
}

/// Where a report stands (SRS-QMS-001).
class IncidentState extends $pb.ProtobufEnum {
  static const IncidentState INCIDENT_STATE_UNSPECIFIED =
      IncidentState._(0, _omitEnumNames ? '' : 'INCIDENT_STATE_UNSPECIFIED');
  static const IncidentState INCIDENT_STATE_REPORTED =
      IncidentState._(1, _omitEnumNames ? '' : 'INCIDENT_STATE_REPORTED');
  static const IncidentState INCIDENT_STATE_UNDER_REVIEW =
      IncidentState._(2, _omitEnumNames ? '' : 'INCIDENT_STATE_UNDER_REVIEW');
  static const IncidentState INCIDENT_STATE_INVESTIGATED =
      IncidentState._(3, _omitEnumNames ? '' : 'INCIDENT_STATE_INVESTIGATED');
  static const IncidentState INCIDENT_STATE_CLOSED =
      IncidentState._(4, _omitEnumNames ? '' : 'INCIDENT_STATE_CLOSED');

  /// A report the reviewer found was not an incident. Kept rather than
  /// deleted: a report somebody dismissed is evidence about the reviewer.
  static const IncidentState INCIDENT_STATE_REJECTED =
      IncidentState._(5, _omitEnumNames ? '' : 'INCIDENT_STATE_REJECTED');

  static const $core.List<IncidentState> values = <IncidentState>[
    INCIDENT_STATE_UNSPECIFIED,
    INCIDENT_STATE_REPORTED,
    INCIDENT_STATE_UNDER_REVIEW,
    INCIDENT_STATE_INVESTIGATED,
    INCIDENT_STATE_CLOSED,
    INCIDENT_STATE_REJECTED,
  ];

  static final $core.List<IncidentState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static IncidentState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const IncidentState._(super.value, super.name);
}

/// What group a contributing factor falls in (SRS-QMS-003).
class FactorCategory extends $pb.ProtobufEnum {
  static const FactorCategory FACTOR_CATEGORY_UNSPECIFIED =
      FactorCategory._(0, _omitEnumNames ? '' : 'FACTOR_CATEGORY_UNSPECIFIED');
  static const FactorCategory FACTOR_CATEGORY_PATIENT =
      FactorCategory._(1, _omitEnumNames ? '' : 'FACTOR_CATEGORY_PATIENT');
  static const FactorCategory FACTOR_CATEGORY_TASK =
      FactorCategory._(2, _omitEnumNames ? '' : 'FACTOR_CATEGORY_TASK');
  static const FactorCategory FACTOR_CATEGORY_INDIVIDUAL =
      FactorCategory._(3, _omitEnumNames ? '' : 'FACTOR_CATEGORY_INDIVIDUAL');
  static const FactorCategory FACTOR_CATEGORY_TEAM =
      FactorCategory._(4, _omitEnumNames ? '' : 'FACTOR_CATEGORY_TEAM');
  static const FactorCategory FACTOR_CATEGORY_ENVIRONMENT =
      FactorCategory._(5, _omitEnumNames ? '' : 'FACTOR_CATEGORY_ENVIRONMENT');
  static const FactorCategory FACTOR_CATEGORY_EQUIPMENT =
      FactorCategory._(6, _omitEnumNames ? '' : 'FACTOR_CATEGORY_EQUIPMENT');
  static const FactorCategory FACTOR_CATEGORY_ORGANISATIONAL = FactorCategory._(
      7, _omitEnumNames ? '' : 'FACTOR_CATEGORY_ORGANISATIONAL');

  static const $core.List<FactorCategory> values = <FactorCategory>[
    FACTOR_CATEGORY_UNSPECIFIED,
    FACTOR_CATEGORY_PATIENT,
    FACTOR_CATEGORY_TASK,
    FACTOR_CATEGORY_INDIVIDUAL,
    FACTOR_CATEGORY_TEAM,
    FACTOR_CATEGORY_ENVIRONMENT,
    FACTOR_CATEGORY_EQUIPMENT,
    FACTOR_CATEGORY_ORGANISATIONAL,
  ];

  static final $core.List<FactorCategory?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static FactorCategory? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FactorCategory._(super.value, super.name);
}

/// Where an analysis or a peer review stands.
class ReviewState extends $pb.ProtobufEnum {
  static const ReviewState REVIEW_STATE_UNSPECIFIED =
      ReviewState._(0, _omitEnumNames ? '' : 'REVIEW_STATE_UNSPECIFIED');
  static const ReviewState REVIEW_STATE_OPEN =
      ReviewState._(1, _omitEnumNames ? '' : 'REVIEW_STATE_OPEN');
  static const ReviewState REVIEW_STATE_COMPLETE =
      ReviewState._(2, _omitEnumNames ? '' : 'REVIEW_STATE_COMPLETE');

  static const $core.List<ReviewState> values = <ReviewState>[
    REVIEW_STATE_UNSPECIFIED,
    REVIEW_STATE_OPEN,
    REVIEW_STATE_COMPLETE,
  ];

  static final $core.List<ReviewState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ReviewState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReviewState._(super.value, super.name);
}

/// Fixing this one, or stopping the next one (SRS-QMS-004).
class ActionKind extends $pb.ProtobufEnum {
  static const ActionKind ACTION_KIND_UNSPECIFIED =
      ActionKind._(0, _omitEnumNames ? '' : 'ACTION_KIND_UNSPECIFIED');

  /// Repairs the instance.
  static const ActionKind ACTION_KIND_CORRECTIVE =
      ActionKind._(1, _omitEnumNames ? '' : 'ACTION_KIND_CORRECTIVE');

  /// Changes the system so it does not recur. An analysis whose actions are
  /// all corrective has fixed a patient and left the cause in place.
  static const ActionKind ACTION_KIND_PREVENTIVE =
      ActionKind._(2, _omitEnumNames ? '' : 'ACTION_KIND_PREVENTIVE');

  static const $core.List<ActionKind> values = <ActionKind>[
    ACTION_KIND_UNSPECIFIED,
    ACTION_KIND_CORRECTIVE,
    ACTION_KIND_PREVENTIVE,
  ];

  static final $core.List<ActionKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ActionKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ActionKind._(super.value, super.name);
}

/// What raised an action (SRS-QMS-004, SRS-QMS-007).
class ActionSource extends $pb.ProtobufEnum {
  static const ActionSource ACTION_SOURCE_UNSPECIFIED =
      ActionSource._(0, _omitEnumNames ? '' : 'ACTION_SOURCE_UNSPECIFIED');
  static const ActionSource ACTION_SOURCE_INCIDENT =
      ActionSource._(1, _omitEnumNames ? '' : 'ACTION_SOURCE_INCIDENT');
  static const ActionSource ACTION_SOURCE_RCA =
      ActionSource._(2, _omitEnumNames ? '' : 'ACTION_SOURCE_RCA');
  static const ActionSource ACTION_SOURCE_AUDIT_FINDING =
      ActionSource._(3, _omitEnumNames ? '' : 'ACTION_SOURCE_AUDIT_FINDING');
  static const ActionSource ACTION_SOURCE_COMPLAINT =
      ActionSource._(4, _omitEnumNames ? '' : 'ACTION_SOURCE_COMPLAINT');
  static const ActionSource ACTION_SOURCE_COMMITTEE =
      ActionSource._(5, _omitEnumNames ? '' : 'ACTION_SOURCE_COMMITTEE');
  static const ActionSource ACTION_SOURCE_INSPECTION =
      ActionSource._(6, _omitEnumNames ? '' : 'ACTION_SOURCE_INSPECTION');

  static const $core.List<ActionSource> values = <ActionSource>[
    ACTION_SOURCE_UNSPECIFIED,
    ACTION_SOURCE_INCIDENT,
    ACTION_SOURCE_RCA,
    ACTION_SOURCE_AUDIT_FINDING,
    ACTION_SOURCE_COMPLAINT,
    ACTION_SOURCE_COMMITTEE,
    ACTION_SOURCE_INSPECTION,
  ];

  static final $core.List<ActionSource?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static ActionSource? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ActionSource._(super.value, super.name);
}

/// Where an action stands (SRS-QMS-004).
class ActionState extends $pb.ProtobufEnum {
  static const ActionState ACTION_STATE_UNSPECIFIED =
      ActionState._(0, _omitEnumNames ? '' : 'ACTION_STATE_UNSPECIFIED');
  static const ActionState ACTION_STATE_DRAFT =
      ActionState._(1, _omitEnumNames ? '' : 'ACTION_STATE_DRAFT');
  static const ActionState ACTION_STATE_APPROVED =
      ActionState._(2, _omitEnumNames ? '' : 'ACTION_STATE_APPROVED');
  static const ActionState ACTION_STATE_OPEN =
      ActionState._(3, _omitEnumNames ? '' : 'ACTION_STATE_OPEN');
  static const ActionState ACTION_STATE_IN_PROGRESS =
      ActionState._(4, _omitEnumNames ? '' : 'ACTION_STATE_IN_PROGRESS');
  static const ActionState ACTION_STATE_EFFECTIVENESS_REVIEW = ActionState._(
      5, _omitEnumNames ? '' : 'ACTION_STATE_EFFECTIVENESS_REVIEW');
  static const ActionState ACTION_STATE_CLOSED =
      ActionState._(6, _omitEnumNames ? '' : 'ACTION_STATE_CLOSED');
  static const ActionState ACTION_STATE_CANCELLED =
      ActionState._(7, _omitEnumNames ? '' : 'ACTION_STATE_CANCELLED');

  static const $core.List<ActionState> values = <ActionState>[
    ACTION_STATE_UNSPECIFIED,
    ACTION_STATE_DRAFT,
    ACTION_STATE_APPROVED,
    ACTION_STATE_OPEN,
    ACTION_STATE_IN_PROGRESS,
    ACTION_STATE_EFFECTIVENESS_REVIEW,
    ACTION_STATE_CLOSED,
    ACTION_STATE_CANCELLED,
  ];

  static final $core.List<ActionState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static ActionState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ActionState._(super.value, super.name);
}

/// What sort of controlled document this is (SRS-QMS-006).
class DocumentKind extends $pb.ProtobufEnum {
  static const DocumentKind DOCUMENT_KIND_UNSPECIFIED =
      DocumentKind._(0, _omitEnumNames ? '' : 'DOCUMENT_KIND_UNSPECIFIED');
  static const DocumentKind DOCUMENT_KIND_POLICY =
      DocumentKind._(1, _omitEnumNames ? '' : 'DOCUMENT_KIND_POLICY');
  static const DocumentKind DOCUMENT_KIND_SOP =
      DocumentKind._(2, _omitEnumNames ? '' : 'DOCUMENT_KIND_SOP');
  static const DocumentKind DOCUMENT_KIND_PROTOCOL =
      DocumentKind._(3, _omitEnumNames ? '' : 'DOCUMENT_KIND_PROTOCOL');
  static const DocumentKind DOCUMENT_KIND_GUIDELINE =
      DocumentKind._(4, _omitEnumNames ? '' : 'DOCUMENT_KIND_GUIDELINE');
  static const DocumentKind DOCUMENT_KIND_FORM =
      DocumentKind._(5, _omitEnumNames ? '' : 'DOCUMENT_KIND_FORM');
  static const DocumentKind DOCUMENT_KIND_MANUAL =
      DocumentKind._(6, _omitEnumNames ? '' : 'DOCUMENT_KIND_MANUAL');

  static const $core.List<DocumentKind> values = <DocumentKind>[
    DOCUMENT_KIND_UNSPECIFIED,
    DOCUMENT_KIND_POLICY,
    DOCUMENT_KIND_SOP,
    DOCUMENT_KIND_PROTOCOL,
    DOCUMENT_KIND_GUIDELINE,
    DOCUMENT_KIND_FORM,
    DOCUMENT_KIND_MANUAL,
  ];

  static final $core.List<DocumentKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static DocumentKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DocumentKind._(super.value, super.name);
}

/// Where one revision stands (SRS-QMS-006).
class VersionState extends $pb.ProtobufEnum {
  static const VersionState VERSION_STATE_UNSPECIFIED =
      VersionState._(0, _omitEnumNames ? '' : 'VERSION_STATE_UNSPECIFIED');

  /// Being written. Never shown as the document.
  static const VersionState VERSION_STATE_DRAFT =
      VersionState._(1, _omitEnumNames ? '' : 'VERSION_STATE_DRAFT');

  /// Signed off and waiting for its effective date.
  static const VersionState VERSION_STATE_APPROVED =
      VersionState._(2, _omitEnumNames ? '' : 'VERSION_STATE_APPROVED');
  static const VersionState VERSION_STATE_EFFECTIVE =
      VersionState._(3, _omitEnumNames ? '' : 'VERSION_STATE_EFFECTIVE');

  /// Replaced, and retained: an incident is judged against the version in
  /// force when it happened.
  static const VersionState VERSION_STATE_OBSOLETE =
      VersionState._(4, _omitEnumNames ? '' : 'VERSION_STATE_OBSOLETE');

  static const $core.List<VersionState> values = <VersionState>[
    VERSION_STATE_UNSPECIFIED,
    VERSION_STATE_DRAFT,
    VERSION_STATE_APPROVED,
    VERSION_STATE_EFFECTIVE,
    VERSION_STATE_OBSOLETE,
  ];

  static final $core.List<VersionState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static VersionState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const VersionState._(super.value, super.name);
}

/// How serious an audit finding is (SRS-QMS-007).
class FindingSeverity extends $pb.ProtobufEnum {
  static const FindingSeverity FINDING_SEVERITY_UNSPECIFIED = FindingSeverity._(
      0, _omitEnumNames ? '' : 'FINDING_SEVERITY_UNSPECIFIED');

  /// Advice. Closes with a note.
  static const FindingSeverity FINDING_SEVERITY_OBSERVATION = FindingSeverity._(
      1, _omitEnumNames ? '' : 'FINDING_SEVERITY_OBSERVATION');

  /// A failure. Closes only through a closed corrective action.
  static const FindingSeverity FINDING_SEVERITY_MINOR_NC =
      FindingSeverity._(2, _omitEnumNames ? '' : 'FINDING_SEVERITY_MINOR_NC');
  static const FindingSeverity FINDING_SEVERITY_MAJOR_NC =
      FindingSeverity._(3, _omitEnumNames ? '' : 'FINDING_SEVERITY_MAJOR_NC');

  static const $core.List<FindingSeverity> values = <FindingSeverity>[
    FINDING_SEVERITY_UNSPECIFIED,
    FINDING_SEVERITY_OBSERVATION,
    FINDING_SEVERITY_MINOR_NC,
    FINDING_SEVERITY_MAJOR_NC,
  ];

  static final $core.List<FindingSeverity?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static FindingSeverity? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FindingSeverity._(super.value, super.name);
}

/// Where an audit stands (SRS-QMS-007).
class AuditState extends $pb.ProtobufEnum {
  static const AuditState AUDIT_STATE_UNSPECIFIED =
      AuditState._(0, _omitEnumNames ? '' : 'AUDIT_STATE_UNSPECIFIED');
  static const AuditState AUDIT_STATE_PLANNED =
      AuditState._(1, _omitEnumNames ? '' : 'AUDIT_STATE_PLANNED');
  static const AuditState AUDIT_STATE_IN_PROGRESS =
      AuditState._(2, _omitEnumNames ? '' : 'AUDIT_STATE_IN_PROGRESS');
  static const AuditState AUDIT_STATE_REPORTED =
      AuditState._(3, _omitEnumNames ? '' : 'AUDIT_STATE_REPORTED');
  static const AuditState AUDIT_STATE_CLOSED =
      AuditState._(4, _omitEnumNames ? '' : 'AUDIT_STATE_CLOSED');
  static const AuditState AUDIT_STATE_CANCELLED =
      AuditState._(5, _omitEnumNames ? '' : 'AUDIT_STATE_CANCELLED');

  static const $core.List<AuditState> values = <AuditState>[
    AUDIT_STATE_UNSPECIFIED,
    AUDIT_STATE_PLANNED,
    AUDIT_STATE_IN_PROGRESS,
    AUDIT_STATE_REPORTED,
    AUDIT_STATE_CLOSED,
    AUDIT_STATE_CANCELLED,
  ];

  static final $core.List<AuditState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static AuditState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AuditState._(super.value, super.name);
}

/// Where a meeting stands (SRS-QMS-008).
class MeetingState extends $pb.ProtobufEnum {
  static const MeetingState MEETING_STATE_UNSPECIFIED =
      MeetingState._(0, _omitEnumNames ? '' : 'MEETING_STATE_UNSPECIFIED');
  static const MeetingState MEETING_STATE_SCHEDULED =
      MeetingState._(1, _omitEnumNames ? '' : 'MEETING_STATE_SCHEDULED');
  static const MeetingState MEETING_STATE_HELD =
      MeetingState._(2, _omitEnumNames ? '' : 'MEETING_STATE_HELD');
  static const MeetingState MEETING_STATE_MINUTES_APPROVED =
      MeetingState._(3, _omitEnumNames ? '' : 'MEETING_STATE_MINUTES_APPROVED');
  static const MeetingState MEETING_STATE_CANCELLED =
      MeetingState._(4, _omitEnumNames ? '' : 'MEETING_STATE_CANCELLED');

  static const $core.List<MeetingState> values = <MeetingState>[
    MEETING_STATE_UNSPECIFIED,
    MEETING_STATE_SCHEDULED,
    MEETING_STATE_HELD,
    MEETING_STATE_MINUTES_APPROVED,
    MEETING_STATE_CANCELLED,
  ];

  static final $core.List<MeetingState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static MeetingState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MeetingState._(super.value, super.name);
}

/// What sort of thing is offered against a clause (SRS-QMS-009).
class EvidenceKind extends $pb.ProtobufEnum {
  static const EvidenceKind EVIDENCE_KIND_UNSPECIFIED =
      EvidenceKind._(0, _omitEnumNames ? '' : 'EVIDENCE_KIND_UNSPECIFIED');

  /// A controlled document *version*, never a document: an SOP revised after
  /// the evidence was filed is a different document.
  static const EvidenceKind EVIDENCE_KIND_DOCUMENT_VERSION =
      EvidenceKind._(1, _omitEnumNames ? '' : 'EVIDENCE_KIND_DOCUMENT_VERSION');
  static const EvidenceKind EVIDENCE_KIND_AUDIT =
      EvidenceKind._(2, _omitEnumNames ? '' : 'EVIDENCE_KIND_AUDIT');
  static const EvidenceKind EVIDENCE_KIND_AUDIT_FINDING =
      EvidenceKind._(3, _omitEnumNames ? '' : 'EVIDENCE_KIND_AUDIT_FINDING');
  static const EvidenceKind EVIDENCE_KIND_CAPA =
      EvidenceKind._(4, _omitEnumNames ? '' : 'EVIDENCE_KIND_CAPA');
  static const EvidenceKind EVIDENCE_KIND_KPI =
      EvidenceKind._(5, _omitEnumNames ? '' : 'EVIDENCE_KIND_KPI');
  static const EvidenceKind EVIDENCE_KIND_COMMITTEE_MEETING = EvidenceKind._(
      6, _omitEnumNames ? '' : 'EVIDENCE_KIND_COMMITTEE_MEETING');
  static const EvidenceKind EVIDENCE_KIND_COMPETENCY =
      EvidenceKind._(7, _omitEnumNames ? '' : 'EVIDENCE_KIND_COMPETENCY');

  /// Held outside this system. A reference and a description, because
  /// pretending to hold a fire certificate would be worse than naming where it
  /// is.
  static const EvidenceKind EVIDENCE_KIND_EXTERNAL =
      EvidenceKind._(8, _omitEnumNames ? '' : 'EVIDENCE_KIND_EXTERNAL');

  static const $core.List<EvidenceKind> values = <EvidenceKind>[
    EVIDENCE_KIND_UNSPECIFIED,
    EVIDENCE_KIND_DOCUMENT_VERSION,
    EVIDENCE_KIND_AUDIT,
    EVIDENCE_KIND_AUDIT_FINDING,
    EVIDENCE_KIND_CAPA,
    EVIDENCE_KIND_KPI,
    EVIDENCE_KIND_COMMITTEE_MEETING,
    EVIDENCE_KIND_COMPETENCY,
    EVIDENCE_KIND_EXTERNAL,
  ];

  static final $core.List<EvidenceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static EvidenceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EvidenceKind._(super.value, super.name);
}

/// A reviewer's judgement of a clause (SRS-QMS-009).
class Verdict extends $pb.ProtobufEnum {
  static const Verdict VERDICT_UNSPECIFIED =
      Verdict._(0, _omitEnumNames ? '' : 'VERDICT_UNSPECIFIED');
  static const Verdict VERDICT_UNREVIEWED =
      Verdict._(1, _omitEnumNames ? '' : 'VERDICT_UNREVIEWED');
  static const Verdict VERDICT_MET =
      Verdict._(2, _omitEnumNames ? '' : 'VERDICT_MET');
  static const Verdict VERDICT_PARTIALLY_MET =
      Verdict._(3, _omitEnumNames ? '' : 'VERDICT_PARTIALLY_MET');

  /// Must name the action that will close it.
  static const Verdict VERDICT_NOT_MET =
      Verdict._(4, _omitEnumNames ? '' : 'VERDICT_NOT_MET');

  /// The verdict that removes a clause from the assessment, so the one that
  /// needs a reason.
  static const Verdict VERDICT_NOT_APPLICABLE =
      Verdict._(5, _omitEnumNames ? '' : 'VERDICT_NOT_APPLICABLE');

  static const $core.List<Verdict> values = <Verdict>[
    VERDICT_UNSPECIFIED,
    VERDICT_UNREVIEWED,
    VERDICT_MET,
    VERDICT_PARTIALLY_MET,
    VERDICT_NOT_MET,
    VERDICT_NOT_APPLICABLE,
  ];

  static final $core.List<Verdict?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static Verdict? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Verdict._(super.value, super.name);
}

/// Which way an indicator should move (SRS-QMS-010).
class Direction extends $pb.ProtobufEnum {
  static const Direction DIRECTION_UNSPECIFIED =
      Direction._(0, _omitEnumNames ? '' : 'DIRECTION_UNSPECIFIED');
  static const Direction DIRECTION_HIGHER_IS_BETTER =
      Direction._(1, _omitEnumNames ? '' : 'DIRECTION_HIGHER_IS_BETTER');
  static const Direction DIRECTION_LOWER_IS_BETTER =
      Direction._(2, _omitEnumNames ? '' : 'DIRECTION_LOWER_IS_BETTER');

  static const $core.List<Direction> values = <Direction>[
    DIRECTION_UNSPECIFIED,
    DIRECTION_HIGHER_IS_BETTER,
    DIRECTION_LOWER_IS_BETTER,
  ];

  static final $core.List<Direction?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static Direction? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Direction._(super.value, super.name);
}

/// How often an indicator is measured (SRS-QMS-010).
class Frequency extends $pb.ProtobufEnum {
  static const Frequency FREQUENCY_UNSPECIFIED =
      Frequency._(0, _omitEnumNames ? '' : 'FREQUENCY_UNSPECIFIED');
  static const Frequency FREQUENCY_DAILY =
      Frequency._(1, _omitEnumNames ? '' : 'FREQUENCY_DAILY');
  static const Frequency FREQUENCY_WEEKLY =
      Frequency._(2, _omitEnumNames ? '' : 'FREQUENCY_WEEKLY');
  static const Frequency FREQUENCY_MONTHLY =
      Frequency._(3, _omitEnumNames ? '' : 'FREQUENCY_MONTHLY');
  static const Frequency FREQUENCY_QUARTERLY =
      Frequency._(4, _omitEnumNames ? '' : 'FREQUENCY_QUARTERLY');
  static const Frequency FREQUENCY_ANNUAL =
      Frequency._(5, _omitEnumNames ? '' : 'FREQUENCY_ANNUAL');

  static const $core.List<Frequency> values = <Frequency>[
    FREQUENCY_UNSPECIFIED,
    FREQUENCY_DAILY,
    FREQUENCY_WEEKLY,
    FREQUENCY_MONTHLY,
    FREQUENCY_QUARTERLY,
    FREQUENCY_ANNUAL,
  ];

  static final $core.List<Frequency?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static Frequency? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Frequency._(super.value, super.name);
}

/// Who is complaining (SRS-QMS-011).
class ComplainantKind extends $pb.ProtobufEnum {
  static const ComplainantKind COMPLAINANT_KIND_UNSPECIFIED = ComplainantKind._(
      0, _omitEnumNames ? '' : 'COMPLAINANT_KIND_UNSPECIFIED');
  static const ComplainantKind COMPLAINANT_KIND_PATIENT =
      ComplainantKind._(1, _omitEnumNames ? '' : 'COMPLAINANT_KIND_PATIENT');
  static const ComplainantKind COMPLAINANT_KIND_RELATIVE =
      ComplainantKind._(2, _omitEnumNames ? '' : 'COMPLAINANT_KIND_RELATIVE');
  static const ComplainantKind COMPLAINANT_KIND_VISITOR =
      ComplainantKind._(3, _omitEnumNames ? '' : 'COMPLAINANT_KIND_VISITOR');
  static const ComplainantKind COMPLAINANT_KIND_STAFF =
      ComplainantKind._(4, _omitEnumNames ? '' : 'COMPLAINANT_KIND_STAFF');
  static const ComplainantKind COMPLAINANT_KIND_EXTERNAL =
      ComplainantKind._(5, _omitEnumNames ? '' : 'COMPLAINANT_KIND_EXTERNAL');

  static const $core.List<ComplainantKind> values = <ComplainantKind>[
    COMPLAINANT_KIND_UNSPECIFIED,
    COMPLAINANT_KIND_PATIENT,
    COMPLAINANT_KIND_RELATIVE,
    COMPLAINANT_KIND_VISITOR,
    COMPLAINANT_KIND_STAFF,
    COMPLAINANT_KIND_EXTERNAL,
  ];

  static final $core.List<ComplainantKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ComplainantKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ComplainantKind._(super.value, super.name);
}

/// How a complaint was decided (SRS-QMS-011).
class ComplaintOutcome extends $pb.ProtobufEnum {
  static const ComplaintOutcome COMPLAINT_OUTCOME_UNSPECIFIED =
      ComplaintOutcome._(
          0, _omitEnumNames ? '' : 'COMPLAINT_OUTCOME_UNSPECIFIED');
  static const ComplaintOutcome COMPLAINT_OUTCOME_UPHELD =
      ComplaintOutcome._(1, _omitEnumNames ? '' : 'COMPLAINT_OUTCOME_UPHELD');
  static const ComplaintOutcome COMPLAINT_OUTCOME_PARTIALLY_UPHELD =
      ComplaintOutcome._(
          2, _omitEnumNames ? '' : 'COMPLAINT_OUTCOME_PARTIALLY_UPHELD');
  static const ComplaintOutcome COMPLAINT_OUTCOME_NOT_UPHELD =
      ComplaintOutcome._(
          3, _omitEnumNames ? '' : 'COMPLAINT_OUTCOME_NOT_UPHELD');
  static const ComplaintOutcome COMPLAINT_OUTCOME_WITHDRAWN =
      ComplaintOutcome._(
          4, _omitEnumNames ? '' : 'COMPLAINT_OUTCOME_WITHDRAWN');

  static const $core.List<ComplaintOutcome> values = <ComplaintOutcome>[
    COMPLAINT_OUTCOME_UNSPECIFIED,
    COMPLAINT_OUTCOME_UPHELD,
    COMPLAINT_OUTCOME_PARTIALLY_UPHELD,
    COMPLAINT_OUTCOME_NOT_UPHELD,
    COMPLAINT_OUTCOME_WITHDRAWN,
  ];

  static final $core.List<ComplaintOutcome?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ComplaintOutcome? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ComplaintOutcome._(super.value, super.name);
}

/// Where a grievance stands (SRS-QMS-011).
class ComplaintState extends $pb.ProtobufEnum {
  static const ComplaintState COMPLAINT_STATE_UNSPECIFIED =
      ComplaintState._(0, _omitEnumNames ? '' : 'COMPLAINT_STATE_UNSPECIFIED');
  static const ComplaintState COMPLAINT_STATE_RECEIVED =
      ComplaintState._(1, _omitEnumNames ? '' : 'COMPLAINT_STATE_RECEIVED');
  static const ComplaintState COMPLAINT_STATE_ACKNOWLEDGED =
      ComplaintState._(2, _omitEnumNames ? '' : 'COMPLAINT_STATE_ACKNOWLEDGED');
  static const ComplaintState COMPLAINT_STATE_INVESTIGATING = ComplaintState._(
      3, _omitEnumNames ? '' : 'COMPLAINT_STATE_INVESTIGATING');
  static const ComplaintState COMPLAINT_STATE_RESOLVED =
      ComplaintState._(4, _omitEnumNames ? '' : 'COMPLAINT_STATE_RESOLVED');
  static const ComplaintState COMPLAINT_STATE_CLOSED =
      ComplaintState._(5, _omitEnumNames ? '' : 'COMPLAINT_STATE_CLOSED');

  static const $core.List<ComplaintState> values = <ComplaintState>[
    COMPLAINT_STATE_UNSPECIFIED,
    COMPLAINT_STATE_RECEIVED,
    COMPLAINT_STATE_ACKNOWLEDGED,
    COMPLAINT_STATE_INVESTIGATING,
    COMPLAINT_STATE_RESOLVED,
    COMPLAINT_STATE_CLOSED,
  ];

  static final $core.List<ComplaintState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ComplaintState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ComplaintState._(super.value, super.name);
}

/// A peer review's verdict on a death (SRS-QMS-012).
class DeathClassification extends $pb.ProtobufEnum {
  static const DeathClassification DEATH_CLASSIFICATION_UNSPECIFIED =
      DeathClassification._(
          0, _omitEnumNames ? '' : 'DEATH_CLASSIFICATION_UNSPECIFIED');
  static const DeathClassification DEATH_CLASSIFICATION_EXPECTED =
      DeathClassification._(
          1, _omitEnumNames ? '' : 'DEATH_CLASSIFICATION_EXPECTED');
  static const DeathClassification DEATH_CLASSIFICATION_UNEXPECTED =
      DeathClassification._(
          2, _omitEnumNames ? '' : 'DEATH_CLASSIFICATION_UNEXPECTED');

  /// The classification that produces change, and the one that must name a
  /// corrective action.
  static const DeathClassification
      DEATH_CLASSIFICATION_POTENTIALLY_PREVENTABLE = DeathClassification._(3,
          _omitEnumNames ? '' : 'DEATH_CLASSIFICATION_POTENTIALLY_PREVENTABLE');
  static const DeathClassification DEATH_CLASSIFICATION_PREVENTABLE =
      DeathClassification._(
          4, _omitEnumNames ? '' : 'DEATH_CLASSIFICATION_PREVENTABLE');

  static const $core.List<DeathClassification> values = <DeathClassification>[
    DEATH_CLASSIFICATION_UNSPECIFIED,
    DEATH_CLASSIFICATION_EXPECTED,
    DEATH_CLASSIFICATION_UNEXPECTED,
    DEATH_CLASSIFICATION_POTENTIALLY_PREVENTABLE,
    DEATH_CLASSIFICATION_PREVENTABLE,
  ];

  static final $core.List<DeathClassification?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static DeathClassification? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DeathClassification._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
