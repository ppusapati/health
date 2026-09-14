// This is a generated file - do not edit.
//
// Generated from healthcare/empi/v1/patient.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Patient identity lifecycle (Wave-1 spec §6).
class PatientStatus extends $pb.ProtobufEnum {
  static const PatientStatus PATIENT_STATUS_UNSPECIFIED =
      PatientStatus._(0, _omitEnumNames ? '' : 'PATIENT_STATUS_UNSPECIFIED');

  /// Created before identity was confirmed — an unconscious admission, a portal
  /// pre-registration. A real patient who can receive care; what is missing is
  /// a confirmed identity.
  static const PatientStatus PATIENT_STATUS_CANDIDATE =
      PatientStatus._(1, _omitEnumNames ? '' : 'PATIENT_STATUS_CANDIDATE');
  static const PatientStatus PATIENT_STATUS_ACTIVE =
      PatientStatus._(2, _omitEnumNames ? '' : 'PATIENT_STATUS_ACTIVE');

  /// Lost a merge. Never deleted: clinical records written against it still
  /// point here, and resolution to the survivor is what makes them readable.
  static const PatientStatus PATIENT_STATUS_MERGED =
      PatientStatus._(3, _omitEnumNames ? '' : 'PATIENT_STATUS_MERGED');
  static const PatientStatus PATIENT_STATUS_INACTIVE =
      PatientStatus._(4, _omitEnumNames ? '' : 'PATIENT_STATUS_INACTIVE');

  static const $core.List<PatientStatus> values = <PatientStatus>[
    PATIENT_STATUS_UNSPECIFIED,
    PATIENT_STATUS_CANDIDATE,
    PATIENT_STATUS_ACTIVE,
    PATIENT_STATUS_MERGED,
    PATIENT_STATUS_INACTIVE,
  ];

  static final $core.List<PatientStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static PatientStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PatientStatus._(super.value, super.name);
}

/// Administrative sex, recorded for identification and clinical safety.
///
/// Deliberately not named Gender: this is the field a laboratory uses to pick a
/// reference range. How a person identifies is a clinical observation with its
/// own history and belongs to SRS-CLN.
class Sex extends $pb.ProtobufEnum {
  static const Sex SEX_UNSPECIFIED =
      Sex._(0, _omitEnumNames ? '' : 'SEX_UNSPECIFIED');
  static const Sex SEX_UNKNOWN = Sex._(1, _omitEnumNames ? '' : 'SEX_UNKNOWN');
  static const Sex SEX_FEMALE = Sex._(2, _omitEnumNames ? '' : 'SEX_FEMALE');
  static const Sex SEX_MALE = Sex._(3, _omitEnumNames ? '' : 'SEX_MALE');
  static const Sex SEX_OTHER = Sex._(4, _omitEnumNames ? '' : 'SEX_OTHER');

  static const $core.List<Sex> values = <Sex>[
    SEX_UNSPECIFIED,
    SEX_UNKNOWN,
    SEX_FEMALE,
    SEX_MALE,
    SEX_OTHER,
  ];

  static final $core.List<Sex?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Sex? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Sex._(super.value, super.name);
}

/// How much of a date is actually known.
///
/// "About forty years old" is what an emergency department has for an
/// unconscious patient. Storing it as 1 January of the implied year would be a
/// false precision that duplicate matching then treats as a strong signal, so
/// the precision travels with the value.
class DatePrecision extends $pb.ProtobufEnum {
  static const DatePrecision DATE_PRECISION_UNSPECIFIED =
      DatePrecision._(0, _omitEnumNames ? '' : 'DATE_PRECISION_UNSPECIFIED');
  static const DatePrecision DATE_PRECISION_DAY =
      DatePrecision._(1, _omitEnumNames ? '' : 'DATE_PRECISION_DAY');
  static const DatePrecision DATE_PRECISION_MONTH =
      DatePrecision._(2, _omitEnumNames ? '' : 'DATE_PRECISION_MONTH');
  static const DatePrecision DATE_PRECISION_YEAR =
      DatePrecision._(3, _omitEnumNames ? '' : 'DATE_PRECISION_YEAR');

  /// Derived from a stated age. The weakest signal a matcher can be given.
  static const DatePrecision DATE_PRECISION_ESTIMATED =
      DatePrecision._(4, _omitEnumNames ? '' : 'DATE_PRECISION_ESTIMATED');

  static const $core.List<DatePrecision> values = <DatePrecision>[
    DATE_PRECISION_UNSPECIFIED,
    DATE_PRECISION_DAY,
    DATE_PRECISION_MONTH,
    DATE_PRECISION_YEAR,
    DATE_PRECISION_ESTIMATED,
  ];

  static final $core.List<DatePrecision?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static DatePrecision? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DatePrecision._(super.value, super.name);
}

class IdentifierType extends $pb.ProtobufEnum {
  static const IdentifierType IDENTIFIER_TYPE_UNSPECIFIED =
      IdentifierType._(0, _omitEnumNames ? '' : 'IDENTIFIER_TYPE_UNSPECIFIED');

  /// Medical record number, issued by a facility.
  static const IdentifierType IDENTIFIER_TYPE_MRN =
      IdentifierType._(1, _omitEnumNames ? '' : 'IDENTIFIER_TYPE_MRN');

  /// National or regional health identifier — ABHA, NHS number.
  static const IdentifierType IDENTIFIER_TYPE_NATIONAL_HEALTH =
      IdentifierType._(
          2, _omitEnumNames ? '' : 'IDENTIFIER_TYPE_NATIONAL_HEALTH');
  static const IdentifierType IDENTIFIER_TYPE_GOVERNMENT =
      IdentifierType._(3, _omitEnumNames ? '' : 'IDENTIFIER_TYPE_GOVERNMENT');
  static const IdentifierType IDENTIFIER_TYPE_INSURANCE =
      IdentifierType._(4, _omitEnumNames ? '' : 'IDENTIFIER_TYPE_INSURANCE');
  static const IdentifierType IDENTIFIER_TYPE_EXTERNAL =
      IdentifierType._(5, _omitEnumNames ? '' : 'IDENTIFIER_TYPE_EXTERNAL');

  static const $core.List<IdentifierType> values = <IdentifierType>[
    IDENTIFIER_TYPE_UNSPECIFIED,
    IDENTIFIER_TYPE_MRN,
    IDENTIFIER_TYPE_NATIONAL_HEALTH,
    IDENTIFIER_TYPE_GOVERNMENT,
    IDENTIFIER_TYPE_INSURANCE,
    IDENTIFIER_TYPE_EXTERNAL,
  ];

  static final $core.List<IdentifierType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static IdentifierType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const IdentifierType._(super.value, super.name);
}

/// How much an identifier is worth as identity evidence (SRS-EMPI-011).
///
/// "A clerk typed this ABHA number" and "ABDM confirmed it belongs to this
/// person" are the same value with very different weight, and SRS-EMPI-010
/// relies on the difference when it requires a configured *positive* identifier.
class IdentifierAssurance extends $pb.ProtobufEnum {
  static const IdentifierAssurance IDENTIFIER_ASSURANCE_UNSPECIFIED =
      IdentifierAssurance._(
          0, _omitEnumNames ? '' : 'IDENTIFIER_ASSURANCE_UNSPECIFIED');

  /// Stated by a person and typed in. What happens at a registration desk.
  static const IdentifierAssurance IDENTIFIER_ASSURANCE_ASSERTED =
      IdentifierAssurance._(
          1, _omitEnumNames ? '' : 'IDENTIFIER_ASSURANCE_ASSERTED');

  /// Confirmed by the authority that issues it, at a recorded moment.
  static const IdentifierAssurance IDENTIFIER_ASSURANCE_VERIFIED =
      IdentifierAssurance._(
          2, _omitEnumNames ? '' : 'IDENTIFIER_ASSURANCE_VERIFIED');

  static const $core.List<IdentifierAssurance> values = <IdentifierAssurance>[
    IDENTIFIER_ASSURANCE_UNSPECIFIED,
    IDENTIFIER_ASSURANCE_ASSERTED,
    IDENTIFIER_ASSURANCE_VERIFIED,
  ];

  static final $core.List<IdentifierAssurance?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static IdentifierAssurance? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const IdentifierAssurance._(super.value, super.name);
}

class IdentifierStatus extends $pb.ProtobufEnum {
  static const IdentifierStatus IDENTIFIER_STATUS_UNSPECIFIED =
      IdentifierStatus._(
          0, _omitEnumNames ? '' : 'IDENTIFIER_STATUS_UNSPECIFIED');
  static const IdentifierStatus IDENTIFIER_STATUS_ACTIVE =
      IdentifierStatus._(1, _omitEnumNames ? '' : 'IDENTIFIER_STATUS_ACTIVE');

  /// Was correct and has been replaced. Still resolves: a discharge summary
  /// printed last week quotes it.
  static const IdentifierStatus IDENTIFIER_STATUS_SUPERSEDED =
      IdentifierStatus._(
          2, _omitEnumNames ? '' : 'IDENTIFIER_STATUS_SUPERSEDED');

  /// Was wrong. Must NOT resolve to this patient — it belongs to somebody else,
  /// or to nobody. That single difference is why there are two states here
  /// rather than one "inactive".
  static const IdentifierStatus IDENTIFIER_STATUS_REVOKED =
      IdentifierStatus._(3, _omitEnumNames ? '' : 'IDENTIFIER_STATUS_REVOKED');

  static const $core.List<IdentifierStatus> values = <IdentifierStatus>[
    IDENTIFIER_STATUS_UNSPECIFIED,
    IDENTIFIER_STATUS_ACTIVE,
    IDENTIFIER_STATUS_SUPERSEDED,
    IDENTIFIER_STATUS_REVOKED,
  ];

  static final $core.List<IdentifierStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static IdentifierStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const IdentifierStatus._(super.value, super.name);
}

class ContactSystem extends $pb.ProtobufEnum {
  static const ContactSystem CONTACT_SYSTEM_UNSPECIFIED =
      ContactSystem._(0, _omitEnumNames ? '' : 'CONTACT_SYSTEM_UNSPECIFIED');
  static const ContactSystem CONTACT_SYSTEM_PHONE =
      ContactSystem._(1, _omitEnumNames ? '' : 'CONTACT_SYSTEM_PHONE');
  static const ContactSystem CONTACT_SYSTEM_EMAIL =
      ContactSystem._(2, _omitEnumNames ? '' : 'CONTACT_SYSTEM_EMAIL');

  static const $core.List<ContactSystem> values = <ContactSystem>[
    CONTACT_SYSTEM_UNSPECIFIED,
    CONTACT_SYSTEM_PHONE,
    CONTACT_SYSTEM_EMAIL,
  ];

  static final $core.List<ContactSystem?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ContactSystem? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ContactSystem._(super.value, super.name);
}

/// Where a proposed demographic change came from (SRS-EMPI-012, SRS-EMPI-017).
///
/// Not decoration: the origin decides who may raise one, what the reviewer is
/// being asked, and whether a repeat is a duplicate or a second independent
/// claim.
class ProposalOrigin extends $pb.ProtobufEnum {
  static const ProposalOrigin PROPOSAL_ORIGIN_UNSPECIFIED =
      ProposalOrigin._(0, _omitEnumNames ? '' : 'PROPOSAL_ORIGIN_UNSPECIFIED');

  /// A machine feed — a national registry, an HIE, a payer file.
  static const ProposalOrigin PROPOSAL_ORIGIN_EXTERNAL_SOURCE =
      ProposalOrigin._(
          1, _omitEnumNames ? '' : 'PROPOSAL_ORIGIN_EXTERNAL_SOURCE');

  /// A person asking for their record to be corrected.
  static const ProposalOrigin PROPOSAL_ORIGIN_CORRECTION_REQUEST =
      ProposalOrigin._(
          2, _omitEnumNames ? '' : 'PROPOSAL_ORIGIN_CORRECTION_REQUEST');

  static const $core.List<ProposalOrigin> values = <ProposalOrigin>[
    PROPOSAL_ORIGIN_UNSPECIFIED,
    PROPOSAL_ORIGIN_EXTERNAL_SOURCE,
    PROPOSAL_ORIGIN_CORRECTION_REQUEST,
  ];

  static final $core.List<ProposalOrigin?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ProposalOrigin? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ProposalOrigin._(super.value, super.name);
}

class ProposalStatus extends $pb.ProtobufEnum {
  static const ProposalStatus PROPOSAL_STATUS_UNSPECIFIED =
      ProposalStatus._(0, _omitEnumNames ? '' : 'PROPOSAL_STATUS_UNSPECIFIED');
  static const ProposalStatus PROPOSAL_STATUS_OPEN =
      ProposalStatus._(1, _omitEnumNames ? '' : 'PROPOSAL_STATUS_OPEN');
  static const ProposalStatus PROPOSAL_STATUS_ACCEPTED =
      ProposalStatus._(2, _omitEnumNames ? '' : 'PROPOSAL_STATUS_ACCEPTED');

  /// Refused in full, and kept. That a value was offered and refused is what
  /// makes a third arrival of the same value a pattern rather than a surprise.
  static const ProposalStatus PROPOSAL_STATUS_REJECTED =
      ProposalStatus._(3, _omitEnumNames ? '' : 'PROPOSAL_STATUS_REJECTED');
  static const ProposalStatus PROPOSAL_STATUS_WITHDRAWN =
      ProposalStatus._(4, _omitEnumNames ? '' : 'PROPOSAL_STATUS_WITHDRAWN');

  /// Overtaken: the record changed underneath, so the comparison a reviewer
  /// would be shown no longer holds.
  static const ProposalStatus PROPOSAL_STATUS_SUPERSEDED =
      ProposalStatus._(5, _omitEnumNames ? '' : 'PROPOSAL_STATUS_SUPERSEDED');

  static const $core.List<ProposalStatus> values = <ProposalStatus>[
    PROPOSAL_STATUS_UNSPECIFIED,
    PROPOSAL_STATUS_OPEN,
    PROPOSAL_STATUS_ACCEPTED,
    PROPOSAL_STATUS_REJECTED,
    PROPOSAL_STATUS_WITHDRAWN,
    PROPOSAL_STATUS_SUPERSEDED,
  ];

  static final $core.List<ProposalStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ProposalStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ProposalStatus._(super.value, super.name);
}

/// Which demographic element a proposal changes.
class DemographicField extends $pb.ProtobufEnum {
  static const DemographicField DEMOGRAPHIC_FIELD_UNSPECIFIED =
      DemographicField._(
          0, _omitEnumNames ? '' : 'DEMOGRAPHIC_FIELD_UNSPECIFIED');
  static const DemographicField DEMOGRAPHIC_FIELD_FAMILY_NAME =
      DemographicField._(
          1, _omitEnumNames ? '' : 'DEMOGRAPHIC_FIELD_FAMILY_NAME');
  static const DemographicField DEMOGRAPHIC_FIELD_GIVEN_NAME =
      DemographicField._(
          2, _omitEnumNames ? '' : 'DEMOGRAPHIC_FIELD_GIVEN_NAME');
  static const DemographicField DEMOGRAPHIC_FIELD_BIRTH_DATE =
      DemographicField._(
          3, _omitEnumNames ? '' : 'DEMOGRAPHIC_FIELD_BIRTH_DATE');
  static const DemographicField DEMOGRAPHIC_FIELD_SEX =
      DemographicField._(4, _omitEnumNames ? '' : 'DEMOGRAPHIC_FIELD_SEX');
  static const DemographicField DEMOGRAPHIC_FIELD_PHONE =
      DemographicField._(5, _omitEnumNames ? '' : 'DEMOGRAPHIC_FIELD_PHONE');
  static const DemographicField DEMOGRAPHIC_FIELD_EMAIL =
      DemographicField._(6, _omitEnumNames ? '' : 'DEMOGRAPHIC_FIELD_EMAIL');
  static const DemographicField DEMOGRAPHIC_FIELD_ADDRESS =
      DemographicField._(7, _omitEnumNames ? '' : 'DEMOGRAPHIC_FIELD_ADDRESS');

  static const $core.List<DemographicField> values = <DemographicField>[
    DEMOGRAPHIC_FIELD_UNSPECIFIED,
    DEMOGRAPHIC_FIELD_FAMILY_NAME,
    DEMOGRAPHIC_FIELD_GIVEN_NAME,
    DEMOGRAPHIC_FIELD_BIRTH_DATE,
    DEMOGRAPHIC_FIELD_SEX,
    DEMOGRAPHIC_FIELD_PHONE,
    DEMOGRAPHIC_FIELD_EMAIL,
    DEMOGRAPHIC_FIELD_ADDRESS,
  ];

  static final $core.List<DemographicField?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static DemographicField? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DemographicField._(super.value, super.name);
}

/// What a duplicate score means operationally (SRS-EMPI-004).
///
/// There is deliberately no outcome that means "merge". The strongest verdict
/// this system produces is that a human should look: a missed duplicate shows a
/// clinician half a history, while a wrong merge fuses two people's allergies
/// and medications into one chart.
class MatchOutcome extends $pb.ProtobufEnum {
  static const MatchOutcome MATCH_OUTCOME_UNSPECIFIED =
      MatchOutcome._(0, _omitEnumNames ? '' : 'MATCH_OUTCOME_UNSPECIFIED');
  static const MatchOutcome MATCH_OUTCOME_DISTINCT =
      MatchOutcome._(1, _omitEnumNames ? '' : 'MATCH_OUTCOME_DISTINCT');

  /// Possible duplicate; registration continues with the candidate shown.
  static const MatchOutcome MATCH_OUTCOME_REVIEW =
      MatchOutcome._(2, _omitEnumNames ? '' : 'MATCH_OUTCOME_REVIEW');

  /// Likely duplicate; routes to manual review. Does NOT authorise a merge.
  static const MatchOutcome MATCH_OUTCOME_PROBABLE =
      MatchOutcome._(3, _omitEnumNames ? '' : 'MATCH_OUTCOME_PROBABLE');

  /// An identifier says these are different people whatever the demographics
  /// suggest.
  static const MatchOutcome MATCH_OUTCOME_CONFLICT =
      MatchOutcome._(4, _omitEnumNames ? '' : 'MATCH_OUTCOME_CONFLICT');

  static const $core.List<MatchOutcome> values = <MatchOutcome>[
    MATCH_OUTCOME_UNSPECIFIED,
    MATCH_OUTCOME_DISTINCT,
    MATCH_OUTCOME_REVIEW,
    MATCH_OUTCOME_PROBABLE,
    MATCH_OUTCOME_CONFLICT,
  ];

  static final $core.List<MatchOutcome?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static MatchOutcome? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MatchOutcome._(super.value, super.name);
}

/// Where a duplicate pair sits in review (SRS-EMPI-004).
class ReviewStatus extends $pb.ProtobufEnum {
  static const ReviewStatus REVIEW_STATUS_UNSPECIFIED =
      ReviewStatus._(0, _omitEnumNames ? '' : 'REVIEW_STATUS_UNSPECIFIED');
  static const ReviewStatus REVIEW_STATUS_OPEN =
      ReviewStatus._(1, _omitEnumNames ? '' : 'REVIEW_STATUS_OPEN');
  static const ReviewStatus REVIEW_STATUS_MERGED =
      ReviewStatus._(2, _omitEnumNames ? '' : 'REVIEW_STATUS_MERGED');

  /// Judged to be two different people. Recorded rather than deleted, so the
  /// same pair does not return to the queue every time either record is
  /// touched.
  static const ReviewStatus REVIEW_STATUS_DISMISSED =
      ReviewStatus._(3, _omitEnumNames ? '' : 'REVIEW_STATUS_DISMISSED');

  static const $core.List<ReviewStatus> values = <ReviewStatus>[
    REVIEW_STATUS_UNSPECIFIED,
    REVIEW_STATUS_OPEN,
    REVIEW_STATUS_MERGED,
    REVIEW_STATUS_DISMISSED,
  ];

  static final $core.List<ReviewStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ReviewStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReviewStatus._(super.value, super.name);
}

/// What a recorded name is for (SRS-EMPI-007).
class NameKind extends $pb.ProtobufEnum {
  static const NameKind NAME_KIND_UNSPECIFIED =
      NameKind._(0, _omitEnumNames ? '' : 'NAME_KIND_UNSPECIFIED');

  /// The name on the identity document.
  static const NameKind NAME_KIND_LEGAL =
      NameKind._(1, _omitEnumNames ? '' : 'NAME_KIND_LEGAL');

  /// What the patient asks to be called. Shown on a worklist; never printed on
  /// a legal document, and never a replacement for the one on the paperwork.
  static const NameKind NAME_KIND_PREFERRED =
      NameKind._(2, _omitEnumNames ? '' : 'NAME_KIND_PREFERRED');

  /// Another name they are known by — a maiden name, a religious name, a
  /// transliteration.
  static const NameKind NAME_KIND_ALIAS =
      NameKind._(3, _omitEnumNames ? '' : 'NAME_KIND_ALIAS');

  static const $core.List<NameKind> values = <NameKind>[
    NAME_KIND_UNSPECIFIED,
    NAME_KIND_LEGAL,
    NAME_KIND_PREFERRED,
    NAME_KIND_ALIAS,
  ];

  static final $core.List<NameKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static NameKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const NameKind._(super.value, super.name);
}

class CommunicationChannel extends $pb.ProtobufEnum {
  static const CommunicationChannel COMMUNICATION_CHANNEL_UNSPECIFIED =
      CommunicationChannel._(
          0, _omitEnumNames ? '' : 'COMMUNICATION_CHANNEL_UNSPECIFIED');
  static const CommunicationChannel COMMUNICATION_CHANNEL_SMS =
      CommunicationChannel._(
          1, _omitEnumNames ? '' : 'COMMUNICATION_CHANNEL_SMS');
  static const CommunicationChannel COMMUNICATION_CHANNEL_EMAIL =
      CommunicationChannel._(
          2, _omitEnumNames ? '' : 'COMMUNICATION_CHANNEL_EMAIL');
  static const CommunicationChannel COMMUNICATION_CHANNEL_PHONE =
      CommunicationChannel._(
          3, _omitEnumNames ? '' : 'COMMUNICATION_CHANNEL_PHONE');
  static const CommunicationChannel COMMUNICATION_CHANNEL_POST =
      CommunicationChannel._(
          4, _omitEnumNames ? '' : 'COMMUNICATION_CHANNEL_POST');

  static const $core.List<CommunicationChannel> values = <CommunicationChannel>[
    COMMUNICATION_CHANNEL_UNSPECIFIED,
    COMMUNICATION_CHANNEL_SMS,
    COMMUNICATION_CHANNEL_EMAIL,
    COMMUNICATION_CHANNEL_PHONE,
    COMMUNICATION_CHANNEL_POST,
  ];

  static final $core.List<CommunicationChannel?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CommunicationChannel? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CommunicationChannel._(super.value, super.name);
}

/// What a message is about.
///
/// Held separately from the channel because the answers differ: a patient who
/// wants appointment reminders by SMS may want nothing else by SMS, and treating
/// "reachable by SMS" as one setting is how a hospital texts somebody their test
/// results.
class CommunicationPurpose extends $pb.ProtobufEnum {
  static const CommunicationPurpose COMMUNICATION_PURPOSE_UNSPECIFIED =
      CommunicationPurpose._(
          0, _omitEnumNames ? '' : 'COMMUNICATION_PURPOSE_UNSPECIFIED');
  static const CommunicationPurpose COMMUNICATION_PURPOSE_APPOINTMENT_REMINDER =
      CommunicationPurpose._(1,
          _omitEnumNames ? '' : 'COMMUNICATION_PURPOSE_APPOINTMENT_REMINDER');
  static const CommunicationPurpose COMMUNICATION_PURPOSE_RESULTS =
      CommunicationPurpose._(
          2, _omitEnumNames ? '' : 'COMMUNICATION_PURPOSE_RESULTS');
  static const CommunicationPurpose COMMUNICATION_PURPOSE_BILLING =
      CommunicationPurpose._(
          3, _omitEnumNames ? '' : 'COMMUNICATION_PURPOSE_BILLING');
  static const CommunicationPurpose COMMUNICATION_PURPOSE_HEALTH_PROMOTION =
      CommunicationPurpose._(
          4, _omitEnumNames ? '' : 'COMMUNICATION_PURPOSE_HEALTH_PROMOTION');

  static const $core.List<CommunicationPurpose> values = <CommunicationPurpose>[
    COMMUNICATION_PURPOSE_UNSPECIFIED,
    COMMUNICATION_PURPOSE_APPOINTMENT_REMINDER,
    COMMUNICATION_PURPOSE_RESULTS,
    COMMUNICATION_PURPOSE_BILLING,
    COMMUNICATION_PURPOSE_HEALTH_PROMOTION,
  ];

  static final $core.List<CommunicationPurpose?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CommunicationPurpose? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CommunicationPurpose._(super.value, super.name);
}

class RelationshipType extends $pb.ProtobufEnum {
  static const RelationshipType RELATIONSHIP_TYPE_UNSPECIFIED =
      RelationshipType._(
          0, _omitEnumNames ? '' : 'RELATIONSHIP_TYPE_UNSPECIFIED');
  static const RelationshipType RELATIONSHIP_TYPE_PARENT =
      RelationshipType._(1, _omitEnumNames ? '' : 'RELATIONSHIP_TYPE_PARENT');
  static const RelationshipType RELATIONSHIP_TYPE_GUARDIAN =
      RelationshipType._(2, _omitEnumNames ? '' : 'RELATIONSHIP_TYPE_GUARDIAN');
  static const RelationshipType RELATIONSHIP_TYPE_SPOUSE =
      RelationshipType._(3, _omitEnumNames ? '' : 'RELATIONSHIP_TYPE_SPOUSE');
  static const RelationshipType RELATIONSHIP_TYPE_CHILD =
      RelationshipType._(4, _omitEnumNames ? '' : 'RELATIONSHIP_TYPE_CHILD');
  static const RelationshipType RELATIONSHIP_TYPE_SIBLING =
      RelationshipType._(5, _omitEnumNames ? '' : 'RELATIONSHIP_TYPE_SIBLING');
  static const RelationshipType RELATIONSHIP_TYPE_CAREGIVER =
      RelationshipType._(
          6, _omitEnumNames ? '' : 'RELATIONSHIP_TYPE_CAREGIVER');

  /// Somebody to telephone. Carries no authority over the record, which is why
  /// it is a distinct type rather than a caregiver with an empty scope.
  static const RelationshipType RELATIONSHIP_TYPE_EMERGENCY_CONTACT =
      RelationshipType._(
          7, _omitEnumNames ? '' : 'RELATIONSHIP_TYPE_EMERGENCY_CONTACT');

  static const $core.List<RelationshipType> values = <RelationshipType>[
    RELATIONSHIP_TYPE_UNSPECIFIED,
    RELATIONSHIP_TYPE_PARENT,
    RELATIONSHIP_TYPE_GUARDIAN,
    RELATIONSHIP_TYPE_SPOUSE,
    RELATIONSHIP_TYPE_CHILD,
    RELATIONSHIP_TYPE_SIBLING,
    RELATIONSHIP_TYPE_CAREGIVER,
    RELATIONSHIP_TYPE_EMERGENCY_CONTACT,
  ];

  static final $core.List<RelationshipType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static RelationshipType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RelationshipType._(super.value, super.name);
}

/// One thing a related person may do (SRS-EMPI-009).
///
/// Scoped rather than all-or-nothing: the parent who brings a child to an
/// appointment needs to book it and be told the time, and does not by that fact
/// need the child's psychiatric notes.
class Authority extends $pb.ProtobufEnum {
  static const Authority AUTHORITY_UNSPECIFIED =
      Authority._(0, _omitEnumNames ? '' : 'AUTHORITY_UNSPECIFIED');
  static const Authority AUTHORITY_VIEW_DEMOGRAPHICS =
      Authority._(1, _omitEnumNames ? '' : 'AUTHORITY_VIEW_DEMOGRAPHICS');
  static const Authority AUTHORITY_BOOK_APPOINTMENTS =
      Authority._(2, _omitEnumNames ? '' : 'AUTHORITY_BOOK_APPOINTMENTS');
  static const Authority AUTHORITY_VIEW_CLINICAL =
      Authority._(3, _omitEnumNames ? '' : 'AUTHORITY_VIEW_CLINICAL');
  static const Authority AUTHORITY_RECEIVE_RESULTS =
      Authority._(4, _omitEnumNames ? '' : 'AUTHORITY_RECEIVE_RESULTS');
  static const Authority AUTHORITY_CONSENT =
      Authority._(5, _omitEnumNames ? '' : 'AUTHORITY_CONSENT');

  static const $core.List<Authority> values = <Authority>[
    AUTHORITY_UNSPECIFIED,
    AUTHORITY_VIEW_DEMOGRAPHICS,
    AUTHORITY_BOOK_APPOINTMENTS,
    AUTHORITY_VIEW_CLINICAL,
    AUTHORITY_RECEIVE_RESULTS,
    AUTHORITY_CONSENT,
  ];

  static final $core.List<Authority?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static Authority? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Authority._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
