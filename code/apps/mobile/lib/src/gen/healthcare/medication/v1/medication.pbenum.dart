// This is a generated file - do not edit.
//
// Generated from healthcare/medication/v1/medication.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Is the patient on this drug right now (SRS-MED-013)?
class TherapyStatus extends $pb.ProtobufEnum {
  static const TherapyStatus THERAPY_STATUS_UNSPECIFIED =
      TherapyStatus._(0, _omitEnumNames ? '' : 'THERAPY_STATUS_UNSPECIFIED');

  /// Composed and not yet prescribed. Nothing downstream can see it.
  static const TherapyStatus THERAPY_STATUS_DRAFT =
      TherapyStatus._(1, _omitEnumNames ? '' : 'THERAPY_STATUS_DRAFT');
  static const TherapyStatus THERAPY_STATUS_ACTIVE =
      TherapyStatus._(2, _omitEnumNames ? '' : 'THERAPY_STATUS_ACTIVE');

  /// Suspended and expected to resume. Distinct from discontinued because a held
  /// drug is one somebody must remember to restart.
  static const TherapyStatus THERAPY_STATUS_HELD =
      TherapyStatus._(3, _omitEnumNames ? '' : 'THERAPY_STATUS_HELD');
  static const TherapyStatus THERAPY_STATUS_DISCONTINUED =
      TherapyStatus._(4, _omitEnumNames ? '' : 'THERAPY_STATUS_DISCONTINUED');
  static const TherapyStatus THERAPY_STATUS_COMPLETED =
      TherapyStatus._(5, _omitEnumNames ? '' : 'THERAPY_STATUS_COMPLETED');

  static const $core.List<TherapyStatus> values = <TherapyStatus>[
    THERAPY_STATUS_UNSPECIFIED,
    THERAPY_STATUS_DRAFT,
    THERAPY_STATUS_ACTIVE,
    THERAPY_STATUS_HELD,
    THERAPY_STATUS_DISCONTINUED,
    THERAPY_STATUS_COMPLETED,
  ];

  static final $core.List<TherapyStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static TherapyStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TherapyStatus._(super.value, super.name);
}

/// How a course ends (SRS-MED-001).
class StopConditionKind extends $pb.ProtobufEnum {
  static const StopConditionKind STOP_CONDITION_KIND_UNSPECIFIED =
      StopConditionKind._(
          0, _omitEnumNames ? '' : 'STOP_CONDITION_KIND_UNSPECIFIED');
  static const StopConditionKind STOP_CONDITION_KIND_AT_TIME =
      StopConditionKind._(
          1, _omitEnumNames ? '' : 'STOP_CONDITION_KIND_AT_TIME');

  /// "Five days of antibiotics" is really ten doses, and expressing it as a date
  /// gets it wrong whenever a dose is missed.
  static const StopConditionKind STOP_CONDITION_KIND_AFTER_DOSES =
      StopConditionKind._(
          2, _omitEnumNames ? '' : 'STOP_CONDITION_KIND_AFTER_DOSES');

  /// A clinical condition in words: "until afebrile for 48 hours".
  static const StopConditionKind STOP_CONDITION_KIND_ON_CONDITION =
      StopConditionKind._(
          3, _omitEnumNames ? '' : 'STOP_CONDITION_KIND_ON_CONDITION');

  /// A continuing medication with no planned end. Explicit rather than absent:
  /// "nobody said" and "this is meant to continue" are different facts, and only
  /// one of them is a prescribing error.
  static const StopConditionKind STOP_CONDITION_KIND_NONE =
      StopConditionKind._(4, _omitEnumNames ? '' : 'STOP_CONDITION_KIND_NONE');

  static const $core.List<StopConditionKind> values = <StopConditionKind>[
    STOP_CONDITION_KIND_UNSPECIFIED,
    STOP_CONDITION_KIND_AT_TIME,
    STOP_CONDITION_KIND_AFTER_DOSES,
    STOP_CONDITION_KIND_ON_CONDITION,
    STOP_CONDITION_KIND_NONE,
  ];

  static final $core.List<StopConditionKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static StopConditionKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const StopConditionKind._(super.value, super.name);
}

/// Which rule produced a finding (SRS-MED-002, SRS-MED-003, SRS-MED-004).
class FindingKind extends $pb.ProtobufEnum {
  static const FindingKind FINDING_KIND_UNSPECIFIED =
      FindingKind._(0, _omitEnumNames ? '' : 'FINDING_KIND_UNSPECIFIED');
  static const FindingKind FINDING_KIND_ALLERGY =
      FindingKind._(1, _omitEnumNames ? '' : 'FINDING_KIND_ALLERGY');
  static const FindingKind FINDING_KIND_INTERACTION =
      FindingKind._(2, _omitEnumNames ? '' : 'FINDING_KIND_INTERACTION');
  static const FindingKind FINDING_KIND_DUPLICATE_THERAPY =
      FindingKind._(3, _omitEnumNames ? '' : 'FINDING_KIND_DUPLICATE_THERAPY');

  /// Renal, hepatic or paediatric dose advice. Advisory by construction: final
  /// prescribing authority remains with the clinician.
  static const FindingKind FINDING_KIND_DOSE_SUPPORT =
      FindingKind._(4, _omitEnumNames ? '' : 'FINDING_KIND_DOSE_SUPPORT');

  static const $core.List<FindingKind> values = <FindingKind>[
    FINDING_KIND_UNSPECIFIED,
    FINDING_KIND_ALLERGY,
    FINDING_KIND_INTERACTION,
    FINDING_KIND_DUPLICATE_THERAPY,
    FINDING_KIND_DOSE_SUPPORT,
  ];

  static final $core.List<FindingKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static FindingKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FindingKind._(super.value, super.name);
}

class Severity extends $pb.ProtobufEnum {
  static const Severity SEVERITY_UNSPECIFIED =
      Severity._(0, _omitEnumNames ? '' : 'SEVERITY_UNSPECIFIED');

  /// Never overridable, whatever a tenant configures.
  static const Severity SEVERITY_CONTRAINDICATED =
      Severity._(1, _omitEnumNames ? '' : 'SEVERITY_CONTRAINDICATED');
  static const Severity SEVERITY_SEVERE =
      Severity._(2, _omitEnumNames ? '' : 'SEVERITY_SEVERE');
  static const Severity SEVERITY_MODERATE =
      Severity._(3, _omitEnumNames ? '' : 'SEVERITY_MODERATE');
  static const Severity SEVERITY_MILD =
      Severity._(4, _omitEnumNames ? '' : 'SEVERITY_MILD');
  static const Severity SEVERITY_INFORMATIONAL =
      Severity._(5, _omitEnumNames ? '' : 'SEVERITY_INFORMATIONAL');

  static const $core.List<Severity> values = <Severity>[
    SEVERITY_UNSPECIFIED,
    SEVERITY_CONTRAINDICATED,
    SEVERITY_SEVERE,
    SEVERITY_MODERATE,
    SEVERITY_MILD,
    SEVERITY_INFORMATIONAL,
  ];

  static final $core.List<Severity?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static Severity? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Severity._(super.value, super.name);
}

/// Where a medication stands with a formulary (SRS-MED-012).
class FormularyStatus extends $pb.ProtobufEnum {
  static const FormularyStatus FORMULARY_STATUS_UNSPECIFIED = FormularyStatus._(
      0, _omitEnumNames ? '' : 'FORMULARY_STATUS_UNSPECIFIED');
  static const FormularyStatus FORMULARY_STATUS_FORMULARY =
      FormularyStatus._(1, _omitEnumNames ? '' : 'FORMULARY_STATUS_FORMULARY');
  static const FormularyStatus FORMULARY_STATUS_RESTRICTED =
      FormularyStatus._(2, _omitEnumNames ? '' : 'FORMULARY_STATUS_RESTRICTED');

  /// Never a refusal: the requirement asks for the approval path to be shown,
  /// which is a different thing from blocking.
  static const FormularyStatus FORMULARY_STATUS_NON_FORMULARY =
      FormularyStatus._(
          3, _omitEnumNames ? '' : 'FORMULARY_STATUS_NON_FORMULARY');

  /// Nobody has classified it. Distinct from non-formulary: "we have decided not
  /// to stock this" and "nobody has looked" are different answers.
  static const FormularyStatus FORMULARY_STATUS_UNKNOWN =
      FormularyStatus._(4, _omitEnumNames ? '' : 'FORMULARY_STATUS_UNKNOWN');

  static const $core.List<FormularyStatus> values = <FormularyStatus>[
    FORMULARY_STATUS_UNSPECIFIED,
    FORMULARY_STATUS_FORMULARY,
    FORMULARY_STATUS_RESTRICTED,
    FORMULARY_STATUS_NON_FORMULARY,
    FORMULARY_STATUS_UNKNOWN,
  ];

  static final $core.List<FormularyStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static FormularyStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FormularyStatus._(super.value, super.name);
}

/// Where a home-medication list came from (SRS-MED-005).
///
/// Recorded because it is how much the list can be trusted: a printout from the
/// GP system and a relative's recollection are both worth having and are not
/// worth the same.
class HomeMedicationSource extends $pb.ProtobufEnum {
  static const HomeMedicationSource HOME_MEDICATION_SOURCE_UNSPECIFIED =
      HomeMedicationSource._(
          0, _omitEnumNames ? '' : 'HOME_MEDICATION_SOURCE_UNSPECIFIED');
  static const HomeMedicationSource HOME_MEDICATION_SOURCE_PATIENT =
      HomeMedicationSource._(
          1, _omitEnumNames ? '' : 'HOME_MEDICATION_SOURCE_PATIENT');
  static const HomeMedicationSource HOME_MEDICATION_SOURCE_CARER =
      HomeMedicationSource._(
          2, _omitEnumNames ? '' : 'HOME_MEDICATION_SOURCE_CARER');
  static const HomeMedicationSource HOME_MEDICATION_SOURCE_GP_RECORD =
      HomeMedicationSource._(
          3, _omitEnumNames ? '' : 'HOME_MEDICATION_SOURCE_GP_RECORD');
  static const HomeMedicationSource HOME_MEDICATION_SOURCE_PHARMACY =
      HomeMedicationSource._(
          4, _omitEnumNames ? '' : 'HOME_MEDICATION_SOURCE_PHARMACY');
  static const HomeMedicationSource HOME_MEDICATION_SOURCE_PREVIOUS_STAY =
      HomeMedicationSource._(
          5, _omitEnumNames ? '' : 'HOME_MEDICATION_SOURCE_PREVIOUS_STAY');
  static const HomeMedicationSource HOME_MEDICATION_SOURCE_MEDICATION_BAG =
      HomeMedicationSource._(
          6, _omitEnumNames ? '' : 'HOME_MEDICATION_SOURCE_MEDICATION_BAG');

  static const $core.List<HomeMedicationSource> values = <HomeMedicationSource>[
    HOME_MEDICATION_SOURCE_UNSPECIFIED,
    HOME_MEDICATION_SOURCE_PATIENT,
    HOME_MEDICATION_SOURCE_CARER,
    HOME_MEDICATION_SOURCE_GP_RECORD,
    HOME_MEDICATION_SOURCE_PHARMACY,
    HOME_MEDICATION_SOURCE_PREVIOUS_STAY,
    HOME_MEDICATION_SOURCE_MEDICATION_BAG,
  ];

  static final $core.List<HomeMedicationSource?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static HomeMedicationSource? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const HomeMedicationSource._(super.value, super.name);
}

/// What was decided about one medication (SRS-MED-005).
class Disposition extends $pb.ProtobufEnum {
  static const Disposition DISPOSITION_UNSPECIFIED =
      Disposition._(0, _omitEnumNames ? '' : 'DISPOSITION_UNSPECIFIED');

  /// The absence of a decision. Never a valid completed state.
  static const Disposition DISPOSITION_PENDING =
      Disposition._(1, _omitEnumNames ? '' : 'DISPOSITION_PENDING');
  static const Disposition DISPOSITION_CONTINUE =
      Disposition._(2, _omitEnumNames ? '' : 'DISPOSITION_CONTINUE');
  static const Disposition DISPOSITION_STOP =
      Disposition._(3, _omitEnumNames ? '' : 'DISPOSITION_STOP');

  /// Continue at a different dose, which is a third answer rather than a stop
  /// followed by a start: the patient has been on this drug throughout.
  static const Disposition DISPOSITION_CHANGE =
      Disposition._(4, _omitEnumNames ? '' : 'DISPOSITION_CHANGE');

  /// An honest answer — the patient cannot remember the dose and the surgery is
  /// shut. Recorded so the gap is visible rather than resolved by a guess.
  static const Disposition DISPOSITION_UNKNOWN =
      Disposition._(5, _omitEnumNames ? '' : 'DISPOSITION_UNKNOWN');

  static const $core.List<Disposition> values = <Disposition>[
    DISPOSITION_UNSPECIFIED,
    DISPOSITION_PENDING,
    DISPOSITION_CONTINUE,
    DISPOSITION_STOP,
    DISPOSITION_CHANGE,
    DISPOSITION_UNKNOWN,
  ];

  static final $core.List<Disposition?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static Disposition? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Disposition._(super.value, super.name);
}

class ReconciliationEvent extends $pb.ProtobufEnum {
  static const ReconciliationEvent RECONCILIATION_EVENT_UNSPECIFIED =
      ReconciliationEvent._(
          0, _omitEnumNames ? '' : 'RECONCILIATION_EVENT_UNSPECIFIED');
  static const ReconciliationEvent RECONCILIATION_EVENT_ADMISSION =
      ReconciliationEvent._(
          1, _omitEnumNames ? '' : 'RECONCILIATION_EVENT_ADMISSION');
  static const ReconciliationEvent RECONCILIATION_EVENT_TRANSFER =
      ReconciliationEvent._(
          2, _omitEnumNames ? '' : 'RECONCILIATION_EVENT_TRANSFER');
  static const ReconciliationEvent RECONCILIATION_EVENT_DISCHARGE =
      ReconciliationEvent._(
          3, _omitEnumNames ? '' : 'RECONCILIATION_EVENT_DISCHARGE');

  static const $core.List<ReconciliationEvent> values = <ReconciliationEvent>[
    RECONCILIATION_EVENT_UNSPECIFIED,
    RECONCILIATION_EVENT_ADMISSION,
    RECONCILIATION_EVENT_TRANSFER,
    RECONCILIATION_EVENT_DISCHARGE,
  ];

  static final $core.List<ReconciliationEvent?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ReconciliationEvent? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReconciliationEvent._(super.value, super.name);
}

/// What sort of swap was made (SRS-MED-011).
class SubstitutionKind extends $pb.ProtobufEnum {
  static const SubstitutionKind SUBSTITUTION_KIND_UNSPECIFIED =
      SubstitutionKind._(
          0, _omitEnumNames ? '' : 'SUBSTITUTION_KIND_UNSPECIFIED');
  static const SubstitutionKind SUBSTITUTION_KIND_GENERIC =
      SubstitutionKind._(1, _omitEnumNames ? '' : 'SUBSTITUTION_KIND_GENERIC');

  /// A different molecule doing the same job, which is a clinical decision
  /// rather than a stock one — and needs somebody other than the pharmacist
  /// proposing it.
  static const SubstitutionKind SUBSTITUTION_KIND_THERAPEUTIC =
      SubstitutionKind._(
          2, _omitEnumNames ? '' : 'SUBSTITUTION_KIND_THERAPEUTIC');
  static const SubstitutionKind SUBSTITUTION_KIND_FORMULARY =
      SubstitutionKind._(
          3, _omitEnumNames ? '' : 'SUBSTITUTION_KIND_FORMULARY');
  static const SubstitutionKind SUBSTITUTION_KIND_STOCK =
      SubstitutionKind._(4, _omitEnumNames ? '' : 'SUBSTITUTION_KIND_STOCK');

  static const $core.List<SubstitutionKind> values = <SubstitutionKind>[
    SUBSTITUTION_KIND_UNSPECIFIED,
    SUBSTITUTION_KIND_GENERIC,
    SUBSTITUTION_KIND_THERAPEUTIC,
    SUBSTITUTION_KIND_FORMULARY,
    SUBSTITUTION_KIND_STOCK,
  ];

  static final $core.List<SubstitutionKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static SubstitutionKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SubstitutionKind._(super.value, super.name);
}

class SubstitutionStatus extends $pb.ProtobufEnum {
  static const SubstitutionStatus SUBSTITUTION_STATUS_UNSPECIFIED =
      SubstitutionStatus._(
          0, _omitEnumNames ? '' : 'SUBSTITUTION_STATUS_UNSPECIFIED');
  static const SubstitutionStatus SUBSTITUTION_STATUS_PROPOSED =
      SubstitutionStatus._(
          1, _omitEnumNames ? '' : 'SUBSTITUTION_STATUS_PROPOSED');
  static const SubstitutionStatus SUBSTITUTION_STATUS_ACCEPTED =
      SubstitutionStatus._(
          2, _omitEnumNames ? '' : 'SUBSTITUTION_STATUS_ACCEPTED');
  static const SubstitutionStatus SUBSTITUTION_STATUS_REJECTED =
      SubstitutionStatus._(
          3, _omitEnumNames ? '' : 'SUBSTITUTION_STATUS_REJECTED');
  static const SubstitutionStatus SUBSTITUTION_STATUS_DISPENSED =
      SubstitutionStatus._(
          4, _omitEnumNames ? '' : 'SUBSTITUTION_STATUS_DISPENSED');

  static const $core.List<SubstitutionStatus> values = <SubstitutionStatus>[
    SUBSTITUTION_STATUS_UNSPECIFIED,
    SUBSTITUTION_STATUS_PROPOSED,
    SUBSTITUTION_STATUS_ACCEPTED,
    SUBSTITUTION_STATUS_REJECTED,
    SUBSTITUTION_STATUS_DISPENSED,
  ];

  static final $core.List<SubstitutionStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static SubstitutionStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SubstitutionStatus._(super.value, super.name);
}

/// Which population a dose rule applies to (SRS-MED-004).
class DoseRuleScope extends $pb.ProtobufEnum {
  static const DoseRuleScope DOSE_RULE_SCOPE_UNSPECIFIED =
      DoseRuleScope._(0, _omitEnumNames ? '' : 'DOSE_RULE_SCOPE_UNSPECIFIED');
  static const DoseRuleScope DOSE_RULE_SCOPE_RENAL =
      DoseRuleScope._(1, _omitEnumNames ? '' : 'DOSE_RULE_SCOPE_RENAL');
  static const DoseRuleScope DOSE_RULE_SCOPE_HEPATIC =
      DoseRuleScope._(2, _omitEnumNames ? '' : 'DOSE_RULE_SCOPE_HEPATIC');
  static const DoseRuleScope DOSE_RULE_SCOPE_PAEDIATRIC =
      DoseRuleScope._(3, _omitEnumNames ? '' : 'DOSE_RULE_SCOPE_PAEDIATRIC');

  static const $core.List<DoseRuleScope> values = <DoseRuleScope>[
    DOSE_RULE_SCOPE_UNSPECIFIED,
    DOSE_RULE_SCOPE_RENAL,
    DOSE_RULE_SCOPE_HEPATIC,
    DOSE_RULE_SCOPE_PAEDIATRIC,
  ];

  static final $core.List<DoseRuleScope?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static DoseRuleScope? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DoseRuleScope._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
