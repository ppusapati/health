// This is a generated file - do not edit.
//
// Generated from healthcare/clinical/v1/clinical.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// How tightly a clinical record is held (SRS-CLN-019).
class Confidentiality extends $pb.ProtobufEnum {
  static const Confidentiality CONFIDENTIALITY_UNSPECIFIED =
      Confidentiality._(0, _omitEnumNames ? '' : 'CONFIDENTIALITY_UNSPECIFIED');
  static const Confidentiality CONFIDENTIALITY_NORMAL =
      Confidentiality._(1, _omitEnumNames ? '' : 'CONFIDENTIALITY_NORMAL');

  /// Needs a narrower role and purpose. Mental health, sexual health,
  /// safeguarding.
  static const Confidentiality CONFIDENTIALITY_RESTRICTED =
      Confidentiality._(2, _omitEnumNames ? '' : 'CONFIDENTIALITY_RESTRICTED');

  /// Visible only to the authoring team unless an emergency is declared.
  static const Confidentiality CONFIDENTIALITY_VERY_RESTRICTED =
      Confidentiality._(
          3, _omitEnumNames ? '' : 'CONFIDENTIALITY_VERY_RESTRICTED');

  static const $core.List<Confidentiality> values = <Confidentiality>[
    CONFIDENTIALITY_UNSPECIFIED,
    CONFIDENTIALITY_NORMAL,
    CONFIDENTIALITY_RESTRICTED,
    CONFIDENTIALITY_VERY_RESTRICTED,
  ];

  static final $core.List<Confidentiality?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Confidentiality? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Confidentiality._(super.value, super.name);
}

/// Where a clinical document sits in its life (SRS-CLN-008).
class DocumentStatus extends $pb.ProtobufEnum {
  static const DocumentStatus DOCUMENT_STATUS_UNSPECIFIED =
      DocumentStatus._(0, _omitEnumNames ? '' : 'DOCUMENT_STATUS_UNSPECIFIED');

  /// Being written. Editable in place, and not visible to the whole hospital: a
  /// half-written note read as fact is worse than no note.
  static const DocumentStatus DOCUMENT_STATUS_DRAFT =
      DocumentStatus._(1, _omitEnumNames ? '' : 'DOCUMENT_STATUS_DRAFT');

  /// Final and immutable. Everything after this is a new document that points
  /// back.
  static const DocumentStatus DOCUMENT_STATUS_SIGNED =
      DocumentStatus._(2, _omitEnumNames ? '' : 'DOCUMENT_STATUS_SIGNED');
  static const DocumentStatus DOCUMENT_STATUS_AMENDED =
      DocumentStatus._(3, _omitEnumNames ? '' : 'DOCUMENT_STATUS_AMENDED');

  /// Adds to a signed document without contradicting it — the result that came
  /// back after the patient went home.
  static const DocumentStatus DOCUMENT_STATUS_ADDENDUM =
      DocumentStatus._(4, _omitEnumNames ? '' : 'DOCUMENT_STATUS_ADDENDUM');

  /// Retained rather than deleted: somebody may have read and acted on it.
  static const DocumentStatus DOCUMENT_STATUS_ENTERED_IN_ERROR =
      DocumentStatus._(
          5, _omitEnumNames ? '' : 'DOCUMENT_STATUS_ENTERED_IN_ERROR');

  static const $core.List<DocumentStatus> values = <DocumentStatus>[
    DOCUMENT_STATUS_UNSPECIFIED,
    DOCUMENT_STATUS_DRAFT,
    DOCUMENT_STATUS_SIGNED,
    DOCUMENT_STATUS_AMENDED,
    DOCUMENT_STATUS_ADDENDUM,
    DOCUMENT_STATUS_ENTERED_IN_ERROR,
  ];

  static final $core.List<DocumentStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static DocumentStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DocumentStatus._(super.value, super.name);
}

class DocumentKind extends $pb.ProtobufEnum {
  static const DocumentKind DOCUMENT_KIND_UNSPECIFIED =
      DocumentKind._(0, _omitEnumNames ? '' : 'DOCUMENT_KIND_UNSPECIFIED');
  static const DocumentKind DOCUMENT_KIND_PROGRESS_NOTE =
      DocumentKind._(1, _omitEnumNames ? '' : 'DOCUMENT_KIND_PROGRESS_NOTE');
  static const DocumentKind DOCUMENT_KIND_CONSULTATION_NOTE = DocumentKind._(
      2, _omitEnumNames ? '' : 'DOCUMENT_KIND_CONSULTATION_NOTE');
  static const DocumentKind DOCUMENT_KIND_DISCHARGE_SUMMARY = DocumentKind._(
      3, _omitEnumNames ? '' : 'DOCUMENT_KIND_DISCHARGE_SUMMARY');
  static const DocumentKind DOCUMENT_KIND_OPERATION_NOTE =
      DocumentKind._(4, _omitEnumNames ? '' : 'DOCUMENT_KIND_OPERATION_NOTE');
  static const DocumentKind DOCUMENT_KIND_NURSING_NOTE =
      DocumentKind._(5, _omitEnumNames ? '' : 'DOCUMENT_KIND_NURSING_NOTE');
  static const DocumentKind DOCUMENT_KIND_REFERRAL_LETTER =
      DocumentKind._(6, _omitEnumNames ? '' : 'DOCUMENT_KIND_REFERRAL_LETTER');
  static const DocumentKind DOCUMENT_KIND_PROCEDURE_REPORT =
      DocumentKind._(7, _omitEnumNames ? '' : 'DOCUMENT_KIND_PROCEDURE_REPORT');

  static const $core.List<DocumentKind> values = <DocumentKind>[
    DOCUMENT_KIND_UNSPECIFIED,
    DOCUMENT_KIND_PROGRESS_NOTE,
    DOCUMENT_KIND_CONSULTATION_NOTE,
    DOCUMENT_KIND_DISCHARGE_SUMMARY,
    DOCUMENT_KIND_OPERATION_NOTE,
    DOCUMENT_KIND_NURSING_NOTE,
    DOCUMENT_KIND_REFERRAL_LETTER,
    DOCUMENT_KIND_PROCEDURE_REPORT,
  ];

  static final $core.List<DocumentKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static DocumentKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DocumentKind._(super.value, super.name);
}

/// What signing asserts (SRS-CLN-009).
///
/// "I wrote this" and "I supervised whoever wrote this" are different claims
/// with different consequences.
class SignatureMeaning extends $pb.ProtobufEnum {
  static const SignatureMeaning SIGNATURE_MEANING_UNSPECIFIED =
      SignatureMeaning._(
          0, _omitEnumNames ? '' : 'SIGNATURE_MEANING_UNSPECIFIED');
  static const SignatureMeaning SIGNATURE_MEANING_AUTHOR =
      SignatureMeaning._(1, _omitEnumNames ? '' : 'SIGNATURE_MEANING_AUTHOR');
  static const SignatureMeaning SIGNATURE_MEANING_VERIFIER =
      SignatureMeaning._(2, _omitEnumNames ? '' : 'SIGNATURE_MEANING_VERIFIER');

  /// A supervising consultant asserting responsibility rather than agreement
  /// with every word.
  static const SignatureMeaning SIGNATURE_MEANING_COSIGNER =
      SignatureMeaning._(3, _omitEnumNames ? '' : 'SIGNATURE_MEANING_COSIGNER');
  static const SignatureMeaning SIGNATURE_MEANING_WITNESS =
      SignatureMeaning._(4, _omitEnumNames ? '' : 'SIGNATURE_MEANING_WITNESS');

  /// Typed what somebody else dictated, and is not asserting the clinical
  /// content at all (SRS-CLN-016). Does not finalise the note.
  static const SignatureMeaning SIGNATURE_MEANING_TRANSCRIBER =
      SignatureMeaning._(
          5, _omitEnumNames ? '' : 'SIGNATURE_MEANING_TRANSCRIBER');

  static const $core.List<SignatureMeaning> values = <SignatureMeaning>[
    SIGNATURE_MEANING_UNSPECIFIED,
    SIGNATURE_MEANING_AUTHOR,
    SIGNATURE_MEANING_VERIFIER,
    SIGNATURE_MEANING_COSIGNER,
    SIGNATURE_MEANING_WITNESS,
    SIGNATURE_MEANING_TRANSCRIBER,
  ];

  static final $core.List<SignatureMeaning?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static SignatureMeaning? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SignatureMeaning._(super.value, super.name);
}

class ProblemStatus extends $pb.ProtobufEnum {
  static const ProblemStatus PROBLEM_STATUS_UNSPECIFIED =
      ProblemStatus._(0, _omitEnumNames ? '' : 'PROBLEM_STATUS_UNSPECIFIED');
  static const ProblemStatus PROBLEM_STATUS_ACTIVE =
      ProblemStatus._(1, _omitEnumNames ? '' : 'PROBLEM_STATUS_ACTIVE');

  /// Neither active nor resolved: a cancer in remission is not a cancer that
  /// has gone.
  static const ProblemStatus PROBLEM_STATUS_REMISSION =
      ProblemStatus._(2, _omitEnumNames ? '' : 'PROBLEM_STATUS_REMISSION');

  /// Kept on the list as historical: a problem list that forgot a resolved
  /// myocardial infarction would hide the most important fact about the patient.
  static const ProblemStatus PROBLEM_STATUS_RESOLVED =
      ProblemStatus._(3, _omitEnumNames ? '' : 'PROBLEM_STATUS_RESOLVED');
  static const ProblemStatus PROBLEM_STATUS_INACTIVE =
      ProblemStatus._(4, _omitEnumNames ? '' : 'PROBLEM_STATUS_INACTIVE');
  static const ProblemStatus PROBLEM_STATUS_ENTERED_IN_ERROR = ProblemStatus._(
      5, _omitEnumNames ? '' : 'PROBLEM_STATUS_ENTERED_IN_ERROR');

  static const $core.List<ProblemStatus> values = <ProblemStatus>[
    PROBLEM_STATUS_UNSPECIFIED,
    PROBLEM_STATUS_ACTIVE,
    PROBLEM_STATUS_REMISSION,
    PROBLEM_STATUS_RESOLVED,
    PROBLEM_STATUS_INACTIVE,
    PROBLEM_STATUS_ENTERED_IN_ERROR,
  ];

  static final $core.List<ProblemStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ProblemStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ProblemStatus._(super.value, super.name);
}

class AllergyKind extends $pb.ProtobufEnum {
  static const AllergyKind ALLERGY_KIND_UNSPECIFIED =
      AllergyKind._(0, _omitEnumNames ? '' : 'ALLERGY_KIND_UNSPECIFIED');
  static const AllergyKind ALLERGY_KIND_ALLERGY =
      AllergyKind._(1, _omitEnumNames ? '' : 'ALLERGY_KIND_ALLERGY');

  /// Clinically different. Confusing them is how a patient with mild nausea on
  /// codeine ends up unable to receive any opiate.
  static const AllergyKind ALLERGY_KIND_INTOLERANCE =
      AllergyKind._(2, _omitEnumNames ? '' : 'ALLERGY_KIND_INTOLERANCE');

  static const $core.List<AllergyKind> values = <AllergyKind>[
    ALLERGY_KIND_UNSPECIFIED,
    ALLERGY_KIND_ALLERGY,
    ALLERGY_KIND_INTOLERANCE,
  ];

  static final $core.List<AllergyKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static AllergyKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AllergyKind._(super.value, super.name);
}

class AllergyCriticality extends $pb.ProtobufEnum {
  static const AllergyCriticality ALLERGY_CRITICALITY_UNSPECIFIED =
      AllergyCriticality._(
          0, _omitEnumNames ? '' : 'ALLERGY_CRITICALITY_UNSPECIFIED');
  static const AllergyCriticality ALLERGY_CRITICALITY_LOW =
      AllergyCriticality._(1, _omitEnumNames ? '' : 'ALLERGY_CRITICALITY_LOW');
  static const AllergyCriticality ALLERGY_CRITICALITY_HIGH =
      AllergyCriticality._(2, _omitEnumNames ? '' : 'ALLERGY_CRITICALITY_HIGH');

  /// The honest answer when nobody knows, and not the same as low: defaulting
  /// to low would tell a prescriber there is no danger when it means nobody has
  /// looked.
  static const AllergyCriticality ALLERGY_CRITICALITY_UNABLE_TO_ASSESS =
      AllergyCriticality._(
          3, _omitEnumNames ? '' : 'ALLERGY_CRITICALITY_UNABLE_TO_ASSESS');

  static const $core.List<AllergyCriticality> values = <AllergyCriticality>[
    ALLERGY_CRITICALITY_UNSPECIFIED,
    ALLERGY_CRITICALITY_LOW,
    ALLERGY_CRITICALITY_HIGH,
    ALLERGY_CRITICALITY_UNABLE_TO_ASSESS,
  ];

  static final $core.List<AllergyCriticality?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static AllergyCriticality? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AllergyCriticality._(super.value, super.name);
}

class AllergyVerification extends $pb.ProtobufEnum {
  static const AllergyVerification ALLERGY_VERIFICATION_UNSPECIFIED =
      AllergyVerification._(
          0, _omitEnumNames ? '' : 'ALLERGY_VERIFICATION_UNSPECIFIED');

  /// What the patient said. Most allergy records are this, and it still warns.
  static const AllergyVerification ALLERGY_VERIFICATION_UNCONFIRMED =
      AllergyVerification._(
          1, _omitEnumNames ? '' : 'ALLERGY_VERIFICATION_UNCONFIRMED');
  static const AllergyVerification ALLERGY_VERIFICATION_CONFIRMED =
      AllergyVerification._(
          2, _omitEnumNames ? '' : 'ALLERGY_VERIFICATION_CONFIRMED');

  /// Investigated and not true. Kept rather than deleted: the next clinician
  /// needs to know the question was asked and settled.
  static const AllergyVerification ALLERGY_VERIFICATION_REFUTED =
      AllergyVerification._(
          3, _omitEnumNames ? '' : 'ALLERGY_VERIFICATION_REFUTED');
  static const AllergyVerification ALLERGY_VERIFICATION_ENTERED_IN_ERROR =
      AllergyVerification._(
          4, _omitEnumNames ? '' : 'ALLERGY_VERIFICATION_ENTERED_IN_ERROR');

  static const $core.List<AllergyVerification> values = <AllergyVerification>[
    ALLERGY_VERIFICATION_UNSPECIFIED,
    ALLERGY_VERIFICATION_UNCONFIRMED,
    ALLERGY_VERIFICATION_CONFIRMED,
    ALLERGY_VERIFICATION_REFUTED,
    ALLERGY_VERIFICATION_ENTERED_IN_ERROR,
  ];

  static final $core.List<AllergyVerification?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static AllergyVerification? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AllergyVerification._(super.value, super.name);
}

/// The authoritative service's reading of a value (SRS-CLN-011).
///
/// Supplied, never derived here: the laboratory knows its reference ranges, its
/// analyser and its population; a chart guessing from a number does not.
class Interpretation extends $pb.ProtobufEnum {
  static const Interpretation INTERPRETATION_UNSPECIFIED =
      Interpretation._(0, _omitEnumNames ? '' : 'INTERPRETATION_UNSPECIFIED');
  static const Interpretation INTERPRETATION_NORMAL =
      Interpretation._(1, _omitEnumNames ? '' : 'INTERPRETATION_NORMAL');
  static const Interpretation INTERPRETATION_HIGH =
      Interpretation._(2, _omitEnumNames ? '' : 'INTERPRETATION_HIGH');
  static const Interpretation INTERPRETATION_LOW =
      Interpretation._(3, _omitEnumNames ? '' : 'INTERPRETATION_LOW');
  static const Interpretation INTERPRETATION_CRITICAL_HIGH =
      Interpretation._(4, _omitEnumNames ? '' : 'INTERPRETATION_CRITICAL_HIGH');
  static const Interpretation INTERPRETATION_CRITICAL_LOW =
      Interpretation._(5, _omitEnumNames ? '' : 'INTERPRETATION_CRITICAL_LOW');
  static const Interpretation INTERPRETATION_ABNORMAL =
      Interpretation._(6, _omitEnumNames ? '' : 'INTERPRETATION_ABNORMAL');

  /// "Nobody said" rather than "it is fine".
  static const Interpretation INTERPRETATION_UNKNOWN =
      Interpretation._(7, _omitEnumNames ? '' : 'INTERPRETATION_UNKNOWN');

  static const $core.List<Interpretation> values = <Interpretation>[
    INTERPRETATION_UNSPECIFIED,
    INTERPRETATION_NORMAL,
    INTERPRETATION_HIGH,
    INTERPRETATION_LOW,
    INTERPRETATION_CRITICAL_HIGH,
    INTERPRETATION_CRITICAL_LOW,
    INTERPRETATION_ABNORMAL,
    INTERPRETATION_UNKNOWN,
  ];

  static final $core.List<Interpretation?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static Interpretation? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Interpretation._(super.value, super.name);
}

class ObservationStatus extends $pb.ProtobufEnum {
  static const ObservationStatus OBSERVATION_STATUS_UNSPECIFIED =
      ObservationStatus._(
          0, _omitEnumNames ? '' : 'OBSERVATION_STATUS_UNSPECIFIED');
  static const ObservationStatus OBSERVATION_STATUS_REGISTERED =
      ObservationStatus._(
          1, _omitEnumNames ? '' : 'OBSERVATION_STATUS_REGISTERED');

  /// May still change. Reported because a preliminary blood culture at 2am
  /// changes treatment.
  static const ObservationStatus OBSERVATION_STATUS_PRELIMINARY =
      ObservationStatus._(
          2, _omitEnumNames ? '' : 'OBSERVATION_STATUS_PRELIMINARY');
  static const ObservationStatus OBSERVATION_STATUS_FINAL =
      ObservationStatus._(3, _omitEnumNames ? '' : 'OBSERVATION_STATUS_FINAL');
  static const ObservationStatus OBSERVATION_STATUS_AMENDED =
      ObservationStatus._(
          4, _omitEnumNames ? '' : 'OBSERVATION_STATUS_AMENDED');
  static const ObservationStatus OBSERVATION_STATUS_CANCELLED =
      ObservationStatus._(
          5, _omitEnumNames ? '' : 'OBSERVATION_STATUS_CANCELLED');
  static const ObservationStatus OBSERVATION_STATUS_ENTERED_IN_ERROR =
      ObservationStatus._(
          6, _omitEnumNames ? '' : 'OBSERVATION_STATUS_ENTERED_IN_ERROR');

  static const $core.List<ObservationStatus> values = <ObservationStatus>[
    OBSERVATION_STATUS_UNSPECIFIED,
    OBSERVATION_STATUS_REGISTERED,
    OBSERVATION_STATUS_PRELIMINARY,
    OBSERVATION_STATUS_FINAL,
    OBSERVATION_STATUS_AMENDED,
    OBSERVATION_STATUS_CANCELLED,
    OBSERVATION_STATUS_ENTERED_IN_ERROR,
  ];

  static final $core.List<ObservationStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static ObservationStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ObservationStatus._(super.value, super.name);
}

class ProcedureStatus extends $pb.ProtobufEnum {
  static const ProcedureStatus PROCEDURE_STATUS_UNSPECIFIED = ProcedureStatus._(
      0, _omitEnumNames ? '' : 'PROCEDURE_STATUS_UNSPECIFIED');
  static const ProcedureStatus PROCEDURE_STATUS_PLANNED =
      ProcedureStatus._(1, _omitEnumNames ? '' : 'PROCEDURE_STATUS_PLANNED');
  static const ProcedureStatus PROCEDURE_STATUS_IN_PROGRESS = ProcedureStatus._(
      2, _omitEnumNames ? '' : 'PROCEDURE_STATUS_IN_PROGRESS');
  static const ProcedureStatus PROCEDURE_STATUS_COMPLETED =
      ProcedureStatus._(3, _omitEnumNames ? '' : 'PROCEDURE_STATUS_COMPLETED');

  /// Begun and abandoned. A laparotomy abandoned on opening is a very different
  /// fact from one that was cancelled.
  static const ProcedureStatus PROCEDURE_STATUS_STOPPED =
      ProcedureStatus._(4, _omitEnumNames ? '' : 'PROCEDURE_STATUS_STOPPED');
  static const ProcedureStatus PROCEDURE_STATUS_NOT_DONE =
      ProcedureStatus._(5, _omitEnumNames ? '' : 'PROCEDURE_STATUS_NOT_DONE');
  static const ProcedureStatus PROCEDURE_STATUS_ENTERED_IN_ERROR =
      ProcedureStatus._(
          6, _omitEnumNames ? '' : 'PROCEDURE_STATUS_ENTERED_IN_ERROR');

  static const $core.List<ProcedureStatus> values = <ProcedureStatus>[
    PROCEDURE_STATUS_UNSPECIFIED,
    PROCEDURE_STATUS_PLANNED,
    PROCEDURE_STATUS_IN_PROGRESS,
    PROCEDURE_STATUS_COMPLETED,
    PROCEDURE_STATUS_STOPPED,
    PROCEDURE_STATUS_NOT_DONE,
    PROCEDURE_STATUS_ENTERED_IN_ERROR,
  ];

  static final $core.List<ProcedureStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static ProcedureStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ProcedureStatus._(super.value, super.name);
}

/// Which side a procedure was performed on (SRS-CLN-006).
///
/// Its own field rather than free text: wrong-side surgery is a never-event, and
/// the only defence a record offers is that the side was stated somewhere a
/// checklist can read.
class Laterality extends $pb.ProtobufEnum {
  static const Laterality LATERALITY_UNSPECIFIED =
      Laterality._(0, _omitEnumNames ? '' : 'LATERALITY_UNSPECIFIED');
  static const Laterality LATERALITY_NOT_APPLICABLE =
      Laterality._(1, _omitEnumNames ? '' : 'LATERALITY_NOT_APPLICABLE');
  static const Laterality LATERALITY_LEFT =
      Laterality._(2, _omitEnumNames ? '' : 'LATERALITY_LEFT');
  static const Laterality LATERALITY_RIGHT =
      Laterality._(3, _omitEnumNames ? '' : 'LATERALITY_RIGHT');
  static const Laterality LATERALITY_BILATERAL =
      Laterality._(4, _omitEnumNames ? '' : 'LATERALITY_BILATERAL');

  /// The honest answer when nobody recorded it, and not the same as not
  /// applicable: an omission must not look like a decision.
  static const Laterality LATERALITY_UNRECORDED =
      Laterality._(5, _omitEnumNames ? '' : 'LATERALITY_UNRECORDED');

  static const $core.List<Laterality> values = <Laterality>[
    LATERALITY_UNSPECIFIED,
    LATERALITY_NOT_APPLICABLE,
    LATERALITY_LEFT,
    LATERALITY_RIGHT,
    LATERALITY_BILATERAL,
    LATERALITY_UNRECORDED,
  ];

  static final $core.List<Laterality?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static Laterality? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Laterality._(super.value, super.name);
}

class CarePlanStatus extends $pb.ProtobufEnum {
  static const CarePlanStatus CARE_PLAN_STATUS_UNSPECIFIED =
      CarePlanStatus._(0, _omitEnumNames ? '' : 'CARE_PLAN_STATUS_UNSPECIFIED');
  static const CarePlanStatus CARE_PLAN_STATUS_DRAFT =
      CarePlanStatus._(1, _omitEnumNames ? '' : 'CARE_PLAN_STATUS_DRAFT');
  static const CarePlanStatus CARE_PLAN_STATUS_ACTIVE =
      CarePlanStatus._(2, _omitEnumNames ? '' : 'CARE_PLAN_STATUS_ACTIVE');
  static const CarePlanStatus CARE_PLAN_STATUS_ON_HOLD =
      CarePlanStatus._(3, _omitEnumNames ? '' : 'CARE_PLAN_STATUS_ON_HOLD');
  static const CarePlanStatus CARE_PLAN_STATUS_COMPLETED =
      CarePlanStatus._(4, _omitEnumNames ? '' : 'CARE_PLAN_STATUS_COMPLETED');
  static const CarePlanStatus CARE_PLAN_STATUS_REVOKED =
      CarePlanStatus._(5, _omitEnumNames ? '' : 'CARE_PLAN_STATUS_REVOKED');

  static const $core.List<CarePlanStatus> values = <CarePlanStatus>[
    CARE_PLAN_STATUS_UNSPECIFIED,
    CARE_PLAN_STATUS_DRAFT,
    CARE_PLAN_STATUS_ACTIVE,
    CARE_PLAN_STATUS_ON_HOLD,
    CARE_PLAN_STATUS_COMPLETED,
    CARE_PLAN_STATUS_REVOKED,
  ];

  static final $core.List<CarePlanStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static CarePlanStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CarePlanStatus._(super.value, super.name);
}

class GoalStatus extends $pb.ProtobufEnum {
  static const GoalStatus GOAL_STATUS_UNSPECIFIED =
      GoalStatus._(0, _omitEnumNames ? '' : 'GOAL_STATUS_UNSPECIFIED');
  static const GoalStatus GOAL_STATUS_PROPOSED =
      GoalStatus._(1, _omitEnumNames ? '' : 'GOAL_STATUS_PROPOSED');
  static const GoalStatus GOAL_STATUS_ACTIVE =
      GoalStatus._(2, _omitEnumNames ? '' : 'GOAL_STATUS_ACTIVE');
  static const GoalStatus GOAL_STATUS_ACHIEVED =
      GoalStatus._(3, _omitEnumNames ? '' : 'GOAL_STATUS_ACHIEVED');
  static const GoalStatus GOAL_STATUS_NOT_ACHIEVED =
      GoalStatus._(4, _omitEnumNames ? '' : 'GOAL_STATUS_NOT_ACHIEVED');
  static const GoalStatus GOAL_STATUS_CANCELLED =
      GoalStatus._(5, _omitEnumNames ? '' : 'GOAL_STATUS_CANCELLED');

  static const $core.List<GoalStatus> values = <GoalStatus>[
    GOAL_STATUS_UNSPECIFIED,
    GOAL_STATUS_PROPOSED,
    GOAL_STATUS_ACTIVE,
    GOAL_STATUS_ACHIEVED,
    GOAL_STATUS_NOT_ACHIEVED,
    GOAL_STATUS_CANCELLED,
  ];

  static final $core.List<GoalStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static GoalStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const GoalStatus._(super.value, super.name);
}

class ActivityStatus extends $pb.ProtobufEnum {
  static const ActivityStatus ACTIVITY_STATUS_UNSPECIFIED =
      ActivityStatus._(0, _omitEnumNames ? '' : 'ACTIVITY_STATUS_UNSPECIFIED');
  static const ActivityStatus ACTIVITY_STATUS_NOT_STARTED =
      ActivityStatus._(1, _omitEnumNames ? '' : 'ACTIVITY_STATUS_NOT_STARTED');
  static const ActivityStatus ACTIVITY_STATUS_SCHEDULED =
      ActivityStatus._(2, _omitEnumNames ? '' : 'ACTIVITY_STATUS_SCHEDULED');
  static const ActivityStatus ACTIVITY_STATUS_IN_PROGRESS =
      ActivityStatus._(3, _omitEnumNames ? '' : 'ACTIVITY_STATUS_IN_PROGRESS');
  static const ActivityStatus ACTIVITY_STATUS_COMPLETED =
      ActivityStatus._(4, _omitEnumNames ? '' : 'ACTIVITY_STATUS_COMPLETED');
  static const ActivityStatus ACTIVITY_STATUS_CANCELLED =
      ActivityStatus._(5, _omitEnumNames ? '' : 'ACTIVITY_STATUS_CANCELLED');

  static const $core.List<ActivityStatus> values = <ActivityStatus>[
    ACTIVITY_STATUS_UNSPECIFIED,
    ACTIVITY_STATUS_NOT_STARTED,
    ACTIVITY_STATUS_SCHEDULED,
    ACTIVITY_STATUS_IN_PROGRESS,
    ACTIVITY_STATUS_COMPLETED,
    ACTIVITY_STATUS_CANCELLED,
  ];

  static final $core.List<ActivityStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ActivityStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ActivityStatus._(super.value, super.name);
}

class AttachmentKind extends $pb.ProtobufEnum {
  static const AttachmentKind ATTACHMENT_KIND_UNSPECIFIED =
      AttachmentKind._(0, _omitEnumNames ? '' : 'ATTACHMENT_KIND_UNSPECIFIED');
  static const AttachmentKind ATTACHMENT_KIND_IMAGE =
      AttachmentKind._(1, _omitEnumNames ? '' : 'ATTACHMENT_KIND_IMAGE');
  static const AttachmentKind ATTACHMENT_KIND_DOCUMENT =
      AttachmentKind._(2, _omitEnumNames ? '' : 'ATTACHMENT_KIND_DOCUMENT');
  static const AttachmentKind ATTACHMENT_KIND_AUDIO =
      AttachmentKind._(3, _omitEnumNames ? '' : 'ATTACHMENT_KIND_AUDIO');
  static const AttachmentKind ATTACHMENT_KIND_VIDEO =
      AttachmentKind._(4, _omitEnumNames ? '' : 'ATTACHMENT_KIND_VIDEO');
  static const AttachmentKind ATTACHMENT_KIND_WAVEFORM =
      AttachmentKind._(5, _omitEnumNames ? '' : 'ATTACHMENT_KIND_WAVEFORM');

  static const $core.List<AttachmentKind> values = <AttachmentKind>[
    ATTACHMENT_KIND_UNSPECIFIED,
    ATTACHMENT_KIND_IMAGE,
    ATTACHMENT_KIND_DOCUMENT,
    ATTACHMENT_KIND_AUDIO,
    ATTACHMENT_KIND_VIDEO,
    ATTACHMENT_KIND_WAVEFORM,
  ];

  static final $core.List<AttachmentKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static AttachmentKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AttachmentKind._(super.value, super.name);
}

/// What a clinical consent covers (SRS-CLN-013).
///
/// Deliberately not the privacy consent of SRS-EMPI-013: conflating them
/// produces a system where withdrawing a marketing preference cancels an
/// operation.
class ConsentKind extends $pb.ProtobufEnum {
  static const ConsentKind CONSENT_KIND_UNSPECIFIED =
      ConsentKind._(0, _omitEnumNames ? '' : 'CONSENT_KIND_UNSPECIFIED');
  static const ConsentKind CONSENT_KIND_PROCEDURE =
      ConsentKind._(1, _omitEnumNames ? '' : 'CONSENT_KIND_PROCEDURE');
  static const ConsentKind CONSENT_KIND_ANAESTHESIA =
      ConsentKind._(2, _omitEnumNames ? '' : 'CONSENT_KIND_ANAESTHESIA');
  static const ConsentKind CONSENT_KIND_TRANSFUSION =
      ConsentKind._(3, _omitEnumNames ? '' : 'CONSENT_KIND_TRANSFUSION');
  static const ConsentKind CONSENT_KIND_PHOTOGRAPHY =
      ConsentKind._(4, _omitEnumNames ? '' : 'CONSENT_KIND_PHOTOGRAPHY');
  static const ConsentKind CONSENT_KIND_RESEARCH =
      ConsentKind._(5, _omitEnumNames ? '' : 'CONSENT_KIND_RESEARCH');
  static const ConsentKind CONSENT_KIND_TREATMENT =
      ConsentKind._(6, _omitEnumNames ? '' : 'CONSENT_KIND_TREATMENT');

  static const $core.List<ConsentKind> values = <ConsentKind>[
    CONSENT_KIND_UNSPECIFIED,
    CONSENT_KIND_PROCEDURE,
    CONSENT_KIND_ANAESTHESIA,
    CONSENT_KIND_TRANSFUSION,
    CONSENT_KIND_PHOTOGRAPHY,
    CONSENT_KIND_RESEARCH,
    CONSENT_KIND_TREATMENT,
  ];

  static final $core.List<ConsentKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static ConsentKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ConsentKind._(super.value, super.name);
}

class ConsentStatus extends $pb.ProtobufEnum {
  static const ConsentStatus CONSENT_STATUS_UNSPECIFIED =
      ConsentStatus._(0, _omitEnumNames ? '' : 'CONSENT_STATUS_UNSPECIFIED');
  static const ConsentStatus CONSENT_STATUS_GIVEN =
      ConsentStatus._(1, _omitEnumNames ? '' : 'CONSENT_STATUS_GIVEN');

  /// A recorded refusal, which is not the same as an absent consent.
  static const ConsentStatus CONSENT_STATUS_REFUSED =
      ConsentStatus._(2, _omitEnumNames ? '' : 'CONSENT_STATUS_REFUSED');
  static const ConsentStatus CONSENT_STATUS_WITHDRAWN =
      ConsentStatus._(3, _omitEnumNames ? '' : 'CONSENT_STATUS_WITHDRAWN');
  static const ConsentStatus CONSENT_STATUS_EXPIRED =
      ConsentStatus._(4, _omitEnumNames ? '' : 'CONSENT_STATUS_EXPIRED');

  static const $core.List<ConsentStatus> values = <ConsentStatus>[
    CONSENT_STATUS_UNSPECIFIED,
    CONSENT_STATUS_GIVEN,
    CONSENT_STATUS_REFUSED,
    CONSENT_STATUS_WITHDRAWN,
    CONSENT_STATUS_EXPIRED,
  ];

  static final $core.List<ConsentStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ConsentStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ConsentStatus._(super.value, super.name);
}

/// Who gave the consent (SRS-CLN-013).
///
/// A consent given by a parent for a child is a different fact from one the
/// patient gave, and the difference is what a court asks about.
class ConsentGiver extends $pb.ProtobufEnum {
  static const ConsentGiver CONSENT_GIVER_UNSPECIFIED =
      ConsentGiver._(0, _omitEnumNames ? '' : 'CONSENT_GIVER_UNSPECIFIED');
  static const ConsentGiver CONSENT_GIVER_PATIENT =
      ConsentGiver._(1, _omitEnumNames ? '' : 'CONSENT_GIVER_PATIENT');
  static const ConsentGiver CONSENT_GIVER_PARENT =
      ConsentGiver._(2, _omitEnumNames ? '' : 'CONSENT_GIVER_PARENT');
  static const ConsentGiver CONSENT_GIVER_LEGAL_GUARDIAN =
      ConsentGiver._(3, _omitEnumNames ? '' : 'CONSENT_GIVER_LEGAL_GUARDIAN');
  static const ConsentGiver CONSENT_GIVER_REPRESENTATIVE =
      ConsentGiver._(4, _omitEnumNames ? '' : 'CONSENT_GIVER_REPRESENTATIVE');

  static const $core.List<ConsentGiver> values = <ConsentGiver>[
    CONSENT_GIVER_UNSPECIFIED,
    CONSENT_GIVER_PATIENT,
    CONSENT_GIVER_PARENT,
    CONSENT_GIVER_LEGAL_GUARDIAN,
    CONSENT_GIVER_REPRESENTATIVE,
  ];

  static final $core.List<ConsentGiver?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ConsentGiver? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ConsentGiver._(super.value, super.name);
}

/// How urgent a decision-support alert is (SRS-CLN-021).
class AlertLevel extends $pb.ProtobufEnum {
  static const AlertLevel ALERT_LEVEL_UNSPECIFIED =
      AlertLevel._(0, _omitEnumNames ? '' : 'ALERT_LEVEL_UNSPECIFIED');

  /// Stops the action until somebody overrides it. Reserved for the few rules
  /// where proceeding is almost never right.
  static const AlertLevel ALERT_LEVEL_HARD =
      AlertLevel._(1, _omitEnumNames ? '' : 'ALERT_LEVEL_HARD');

  /// Warns and lets the clinician proceed. Most rules are this, because a
  /// system where everything is a hard stop is one where clinicians learn to
  /// dismiss hard stops.
  static const AlertLevel ALERT_LEVEL_SOFT =
      AlertLevel._(2, _omitEnumNames ? '' : 'ALERT_LEVEL_SOFT');
  static const AlertLevel ALERT_LEVEL_INFO =
      AlertLevel._(3, _omitEnumNames ? '' : 'ALERT_LEVEL_INFO');

  static const $core.List<AlertLevel> values = <AlertLevel>[
    ALERT_LEVEL_UNSPECIFIED,
    ALERT_LEVEL_HARD,
    ALERT_LEVEL_SOFT,
    ALERT_LEVEL_INFO,
  ];

  static final $core.List<AlertLevel?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static AlertLevel? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AlertLevel._(super.value, super.name);
}

class AlertOutcome extends $pb.ProtobufEnum {
  static const AlertOutcome ALERT_OUTCOME_UNSPECIFIED =
      AlertOutcome._(0, _omitEnumNames ? '' : 'ALERT_OUTCOME_UNSPECIFIED');
  static const AlertOutcome ALERT_OUTCOME_PENDING =
      AlertOutcome._(1, _omitEnumNames ? '' : 'ALERT_OUTCOME_PENDING');

  /// The clinician changed what they were doing — the outcome that justifies
  /// the whole system.
  static const AlertOutcome ALERT_OUTCOME_ACCEPTED =
      AlertOutcome._(2, _omitEnumNames ? '' : 'ALERT_OUTCOME_ACCEPTED');
  static const AlertOutcome ALERT_OUTCOME_OVERRIDDEN =
      AlertOutcome._(3, _omitEnumNames ? '' : 'ALERT_OUTCOME_OVERRIDDEN');
  static const AlertOutcome ALERT_OUTCOME_NOT_APPLICABLE =
      AlertOutcome._(4, _omitEnumNames ? '' : 'ALERT_OUTCOME_NOT_APPLICABLE');

  static const $core.List<AlertOutcome> values = <AlertOutcome>[
    ALERT_OUTCOME_UNSPECIFIED,
    ALERT_OUTCOME_PENDING,
    ALERT_OUTCOME_ACCEPTED,
    ALERT_OUTCOME_OVERRIDDEN,
    ALERT_OUTCOME_NOT_APPLICABLE,
  ];

  static final $core.List<AlertOutcome?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static AlertOutcome? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AlertOutcome._(super.value, super.name);
}

class ConsultUrgency extends $pb.ProtobufEnum {
  static const ConsultUrgency CONSULT_URGENCY_UNSPECIFIED =
      ConsultUrgency._(0, _omitEnumNames ? '' : 'CONSULT_URGENCY_UNSPECIFIED');
  static const ConsultUrgency CONSULT_URGENCY_EMERGENCY =
      ConsultUrgency._(1, _omitEnumNames ? '' : 'CONSULT_URGENCY_EMERGENCY');
  static const ConsultUrgency CONSULT_URGENCY_URGENT =
      ConsultUrgency._(2, _omitEnumNames ? '' : 'CONSULT_URGENCY_URGENT');
  static const ConsultUrgency CONSULT_URGENCY_ROUTINE =
      ConsultUrgency._(3, _omitEnumNames ? '' : 'CONSULT_URGENCY_ROUTINE');

  static const $core.List<ConsultUrgency> values = <ConsultUrgency>[
    CONSULT_URGENCY_UNSPECIFIED,
    CONSULT_URGENCY_EMERGENCY,
    CONSULT_URGENCY_URGENT,
    CONSULT_URGENCY_ROUTINE,
  ];

  static final $core.List<ConsultUrgency?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ConsultUrgency? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ConsultUrgency._(super.value, super.name);
}

class ConsultStatus extends $pb.ProtobufEnum {
  static const ConsultStatus CONSULT_STATUS_UNSPECIFIED =
      ConsultStatus._(0, _omitEnumNames ? '' : 'CONSULT_STATUS_UNSPECIFIED');
  static const ConsultStatus CONSULT_STATUS_REQUESTED =
      ConsultStatus._(1, _omitEnumNames ? '' : 'CONSULT_STATUS_REQUESTED');

  /// Picked up by the receiving service, which is what tells the requester
  /// somebody has it.
  static const ConsultStatus CONSULT_STATUS_ACCEPTED =
      ConsultStatus._(2, _omitEnumNames ? '' : 'CONSULT_STATUS_ACCEPTED');
  static const ConsultStatus CONSULT_STATUS_ANSWERED =
      ConsultStatus._(3, _omitEnumNames ? '' : 'CONSULT_STATUS_ANSWERED');

  /// Recorded rather than deleted: a declined consult is the fact a requester
  /// most needs.
  static const ConsultStatus CONSULT_STATUS_DECLINED =
      ConsultStatus._(4, _omitEnumNames ? '' : 'CONSULT_STATUS_DECLINED');
  static const ConsultStatus CONSULT_STATUS_CANCELLED =
      ConsultStatus._(5, _omitEnumNames ? '' : 'CONSULT_STATUS_CANCELLED');

  static const $core.List<ConsultStatus> values = <ConsultStatus>[
    CONSULT_STATUS_UNSPECIFIED,
    CONSULT_STATUS_REQUESTED,
    CONSULT_STATUS_ACCEPTED,
    CONSULT_STATUS_ANSWERED,
    CONSULT_STATUS_DECLINED,
    CONSULT_STATUS_CANCELLED,
  ];

  static final $core.List<ConsultStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ConsultStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ConsultStatus._(super.value, super.name);
}

/// Where an observation came from (SRS-ICU-003).
class ObservationSource extends $pb.ProtobufEnum {
  static const ObservationSource OBSERVATION_SOURCE_UNSPECIFIED =
      ObservationSource._(
          0, _omitEnumNames ? '' : 'OBSERVATION_SOURCE_UNSPECIFIED');

  /// Typed by a person who was looking at the patient. Validated by
  /// construction: the human was the instrument.
  static const ObservationSource OBSERVATION_SOURCE_MANUAL =
      ObservationSource._(1, _omitEnumNames ? '' : 'OBSERVATION_SOURCE_MANUAL');

  /// Off a monitor or analyser at the bedside. Starts unvalidated.
  static const ObservationSource OBSERVATION_SOURCE_DEVICE =
      ObservationSource._(2, _omitEnumNames ? '' : 'OBSERVATION_SOURCE_DEVICE');

  /// From another system authoritative for it — a laboratory, another hospital
  /// (SRS-CLN-010). Validated where it arrived, not here.
  static const ObservationSource OBSERVATION_SOURCE_IMPORTED =
      ObservationSource._(
          3, _omitEnumNames ? '' : 'OBSERVATION_SOURCE_IMPORTED');

  static const $core.List<ObservationSource> values = <ObservationSource>[
    OBSERVATION_SOURCE_UNSPECIFIED,
    OBSERVATION_SOURCE_MANUAL,
    OBSERVATION_SOURCE_DEVICE,
    OBSERVATION_SOURCE_IMPORTED,
  ];

  static final $core.List<ObservationSource?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ObservationSource? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ObservationSource._(super.value, super.name);
}

/// Whether a human has accepted a reading into the chart (SRS-ICU-003).
class ValidationState extends $pb.ProtobufEnum {
  static const ValidationState VALIDATION_STATE_UNSPECIFIED = ValidationState._(
      0, _omitEnumNames ? '' : 'VALIDATION_STATE_UNSPECIFIED');

  /// The source is already authoritative and nobody has to confirm it.
  static const ValidationState VALIDATION_STATE_NOT_REQUIRED =
      ValidationState._(
          1, _omitEnumNames ? '' : 'VALIDATION_STATE_NOT_REQUIRED');

  /// A device reading nobody has looked at. Shown on the chart and excluded
  /// from anything computed (SRS-ICU-009).
  static const ValidationState VALIDATION_STATE_PENDING =
      ValidationState._(2, _omitEnumNames ? '' : 'VALIDATION_STATE_PENDING');
  static const ValidationState VALIDATION_STATE_CONFIRMED =
      ValidationState._(3, _omitEnumNames ? '' : 'VALIDATION_STATE_CONFIRMED');

  /// Marked an artefact — the probe was off, the line was being flushed. Kept
  /// rather than deleted, because a run of rejections is how a failing probe is
  /// found.
  static const ValidationState VALIDATION_STATE_REJECTED =
      ValidationState._(4, _omitEnumNames ? '' : 'VALIDATION_STATE_REJECTED');

  static const $core.List<ValidationState> values = <ValidationState>[
    VALIDATION_STATE_UNSPECIFIED,
    VALIDATION_STATE_NOT_REQUIRED,
    VALIDATION_STATE_PENDING,
    VALIDATION_STATE_CONFIRMED,
    VALIDATION_STATE_REJECTED,
  ];

  static final $core.List<ValidationState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ValidationState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ValidationState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
