/// Prescribing (UX-W1-05, SRS-MED-001/002/003/006/010/012).
///
/// Prescribing is the highest-consequence action a clinician takes through a
/// screen, and the screen's job is almost entirely about what it refuses.
///
/// A contraindicated finding is not overridable — at all, by anybody, with any
/// reason. It is the one severity where the answer is "no" rather than "why".
/// Everything below it is overridable *with a reason attached to that specific
/// rule*, because the reason is what a pharmacist reads at verification and
/// what an incident review reads afterwards, and a blanket "override all" would
/// make both worthless.
///
/// A free-text dose is refused for configured classes (SRS-MED-010). "As
/// directed" for an anticoagulant is not a dose; it is a note somebody else has
/// to interpret at 3am. The structured fields are the ones the eMAR, the
/// interaction checker and the dose-support rules can all read.
///
/// A non-formulary choice is not blocked. It shows the policy action and the
/// approval path (SRS-MED-012), because the drug may be exactly right and the
/// prescriber needs to know what it takes to get it — a hard block produces a
/// phone call and a handwritten chart.
///
/// The same rules as the web shell's `lib/meds/prescribe.ts`, and held to that
/// by `tools/parity`: a prescriber who learns them at a desk and then picks up
/// a tablet must not meet a second set.
library;

import 'package:meta/meta.dart';

/// Mirrors medication.v1.Severity.
enum Severity {
  contraindicated,
  severe,
  moderate,
  mild,
  informational,
  unspecified,
  unrecognised,
}

/// Mirrors medication.v1.FindingKind.
enum FindingKind {
  allergy,
  interaction,
  duplicateTherapy,
  doseSupport,
  unspecified,
  unrecognised,
}

/// Mirrors medication.v1.FormularyStatus.
enum FormularyStatus {
  formulary,
  restricted,
  nonFormulary,
  unknown,
  unspecified,
  unrecognised,
}

String describeSeverity(Severity severity) => switch (severity) {
      Severity.contraindicated => 'Contraindicated',
      Severity.severe => 'Severe',
      Severity.moderate => 'Moderate',
      Severity.mild => 'Mild',
      Severity.informational => 'For information',
      Severity.unspecified => 'Severity not graded',
      // Treated as needing a reason, not as safe — see presentFinding.
      Severity.unrecognised => 'Severity not recognised by this app',
    };

String describeFindingKind(FindingKind kind) => switch (kind) {
      FindingKind.allergy => 'Allergy',
      FindingKind.interaction => 'Interaction',
      FindingKind.duplicateTherapy => 'Duplicate therapy',
      FindingKind.doseSupport => 'Dose advice',
      FindingKind.unspecified => 'Safety finding',
      FindingKind.unrecognised => 'Finding not recognised by this app',
    };

/// A dose amount is a plain decimal, with an optional sign so that a negative
/// one can be refused for the right reason.
///
/// Shape first, parse second. `double.tryParse` accepts 'NaN' and 'Infinity',
/// and NaN fails every comparison — so `amount <= 0` was false for it and a
/// dose of NaN validated cleanly, which is what the parity corpus caught.
/// Scientific notation is refused for a related reason: a prescriber reading
/// back `1e3` does not see a gram.
final RegExp _decimalAmount = RegExp(r'^-?\d+(\.\d+)?$');

/// A naked decimal point, which is a dose written dangerously rather than a typo.
final RegExp _nakedDecimal = RegExp(r'^-?\.\d+$');

int _severityRank(Severity severity) => switch (severity) {
      Severity.contraindicated => 0,
      Severity.severe => 1,
      // With severe: a finding this build cannot grade is not a mild one, and
      // it belongs where a prescriber will read it.
      Severity.unrecognised => 1,
      Severity.moderate => 2,
      Severity.mild => 3,
      Severity.informational => 4,
      Severity.unspecified => 5,
    };

/// One safety finding as the screen shows it.
@immutable
class PresentedFinding {
  const PresentedFinding({
    required this.ruleId,
    required this.kind,
    required this.severity,
    required this.summary,
    required this.overridable,
    this.ruleVersion = '',
    this.subjects = const [],
    this.existingOverrideReason = '',
  });

  final String ruleId;
  final String ruleVersion;
  final FindingKind kind;
  final Severity severity;
  final String summary;
  final List<String> subjects;

  /// False only for a contraindication. Not configurable here: the ceiling a
  /// policy may set is a server decision (SRS-MED-003), and what this asserts
  /// is only that a contraindication is never presented as something a reason
  /// can clear.
  final bool overridable;

  final String existingOverrideReason;

  String get kindLabel => describeFindingKind(kind);
  String get severityLabel => describeSeverity(severity);
}

/// Presents one safety finding.
PresentedFinding presentFinding({
  required String ruleId,
  required FindingKind kind,
  required Severity severity,
  required String summary,
  String ruleVersion = '',
  List<String> subjects = const [],
  String existingOverrideReason = '',
}) =>
    PresentedFinding(
      ruleId: ruleId,
      ruleVersion: ruleVersion,
      kind: kind,
      severity: severity,
      summary: summary,
      subjects: subjects,
      overridable: severity != Severity.contraindicated,
      existingOverrideReason: existingOverrideReason,
    );

/// Orders findings so the one that stops the prescription is first.
List<PresentedFinding> orderFindings(List<PresentedFinding> findings) =>
    [...findings]..sort((a, b) {
        final bySeverity = _severityRank(a.severity) - _severityRank(b.severity);
        if (bySeverity != 0) {
          return bySeverity;
        }
        return a.ruleId.compareTo(b.ruleId);
      });

/// A reason given against one rule.
@immutable
class OverrideAnswer {
  const OverrideAnswer({required this.ruleId, required this.reason});
  final String ruleId;
  final String reason;
}

/// Where the prescriber is with the safety findings.
enum SafetyState {
  /// Nothing gates.
  clear,

  /// At least one contraindication. No reason will help.
  contraindicated,

  /// Overridable findings that have not all been answered.
  needsReasons,

  /// Every gating finding has a reason against its own rule.
  overridden,
}

/// The safety gate, and what to say at it.
@immutable
class SafetyGate {
  const SafetyGate({
    required this.state,
    this.message = '',
    this.findings = const [],
    this.outstanding = const [],
  });

  final SafetyState state;
  final String message;

  /// The contraindications, when there are any.
  final List<PresentedFinding> findings;

  /// The findings still needing a reason.
  final List<PresentedFinding> outstanding;
}

/// Decides whether the prescription may be submitted.
///
/// Reasons are matched per rule. A single "I have considered these" box would
/// be one sentence covering an allergy and a dose warning at once, which is
/// exactly what makes an override record unreadable at verification.
SafetyGate safetyGate(
  List<PresentedFinding> findings,
  List<OverrideAnswer> answers,
) {
  final blocking = findings.where((f) => !f.overridable).toList();
  if (blocking.isNotEmpty) {
    return SafetyGate(
      state: SafetyState.contraindicated,
      message: blocking.length == 1
          ? 'This is contraindicated for this patient. It cannot be prescribed here.'
          : '${blocking.length} contraindications apply. This cannot be prescribed here.',
      findings: blocking,
    );
  }

  // Informational findings are shown and do not gate. Requiring a typed reason
  // for every piece of advice is what trains prescribers to type "ok" into the
  // box that also guards the severe ones.
  final gating = findings
      .where((f) =>
          f.severity != Severity.informational && f.existingOverrideReason.isEmpty)
      .toList();
  if (gating.isEmpty) {
    return const SafetyGate(state: SafetyState.clear);
  }

  final answered = {
    for (final a in answers)
      if (a.reason.trim().isNotEmpty) a.ruleId,
  };
  final outstanding = gating.where((f) => !answered.contains(f.ruleId)).toList();

  if (outstanding.isNotEmpty) {
    return SafetyGate(
      state: SafetyState.needsReasons,
      message: outstanding.length == 1
          ? 'Give a reason for the safety warning before prescribing.'
          : 'Give a reason for each of the ${outstanding.length} safety warnings.',
      outstanding: outstanding,
    );
  }

  return SafetyGate(state: SafetyState.overridden, outstanding: const []);
}

/// A dose as typed into the composer.
@immutable
class DoseDraft {
  const DoseDraft({
    this.amount = '',
    this.unit = '',
    this.freeText = '',
    this.frequencySeconds = 0,
  });

  /// Numeric amount, or '' when only free text was given.
  final String amount;
  final String unit;

  /// What the prescriber typed instead of a structured dose.
  final String freeText;

  /// Seconds between doses. Zero means none given.
  final int frequencySeconds;
}

/// What the prescription composer holds.
@immutable
class PrescriptionDraft {
  const PrescriptionDraft({
    required this.patientId,
    required this.encounterId,
    this.ingredientCode = '',
    this.ingredientDisplay = '',
    this.drugClass = '',
    this.route = '',
    this.dose = const DoseDraft(),
    this.indication = '',
    this.startsAt = '',
  });

  final String patientId;
  final String encounterId;
  final String ingredientCode;
  final String ingredientDisplay;

  /// The drug's therapeutic class, when the prescriber has named one.
  ///
  /// The structured-dose rule is configured per class (SRS-MED-010), and the
  /// class of an arbitrary typed code is not something the client can know. So
  /// when it is blank the client cannot apply the rule and does not pretend to
  /// — the server still enforces it, and the refusal explains itself.
  final String drugClass;

  final String route;
  final DoseDraft dose;
  final String indication;
  final String startsAt;
}

/// Field keys the composer reports problems against.
class PrescribeField {
  static const patient = 'patient';
  static const encounter = 'encounter';
  static const ingredient = 'ingredient';
  static const dose = 'dose';
  static const route = 'route';
  static const indication = 'indication';

  /// In the order they should be fixed.
  static const ordered = [patient, encounter, ingredient, dose, route, indication];
}

/// Whether this drug's class must carry a structured dose.
///
/// False for a drug whose class is unknown to the composer. That is the honest
/// answer rather than the safe-looking one: refusing free text for everything
/// unclassified would block legitimate "two puffs as needed" prescribing on the
/// many drugs a hospital never classifies, and the server is the authority
/// either way.
bool structuredDoseRequiredFor(
  List<String> structuredDoseClasses,
  String drugClass,
) {
  final normalised = drugClass.trim().toLowerCase();
  if (normalised.isEmpty) {
    return false;
  }
  return structuredDoseClasses
      .any((klass) => klass.trim().toLowerCase() == normalised);
}

/// Why a prescription cannot be written yet.
@immutable
class PrescribeValidity {
  const PrescribeValidity({
    required this.ready,
    required this.problems,
    required this.order,
  });

  final bool ready;
  final Map<String, String> problems;
  final List<String> order;
}

/// Validates a prescription draft.
///
/// [structuredDoseRequired] comes from the medication policy for this drug's
/// class (SRS-MED-010). Passed in rather than decided here: which classes must
/// not take a free-text dose is a clinical policy a hospital sets, and a list
/// hard-coded in a client would be both wrong and invisible.
PrescribeValidity validatePrescription(
  PrescriptionDraft draft, {
  required bool structuredDoseRequired,
}) {
  final problems = <String, String>{};

  if (draft.patientId.trim().isEmpty) {
    problems[PrescribeField.patient] =
        'This prescription is not attached to a patient.';
  }
  if (draft.encounterId.trim().isEmpty) {
    problems[PrescribeField.encounter] =
        'This prescription is not attached to an encounter.';
  }
  if (draft.ingredientCode.trim().isEmpty &&
      draft.ingredientDisplay.trim().isEmpty) {
    problems[PrescribeField.ingredient] = 'Choose what is being prescribed.';
  }
  if (draft.route.trim().isEmpty) {
    // A drug with no route is one the eMAR cannot present and a nurse has to
    // guess at. Oral and intravenous paracetamol are different doses.
    problems[PrescribeField.route] = 'Give the route.';
  }
  if (draft.indication.trim().isEmpty) {
    // SRS-MED-001 asks for it, and it is what makes a later review able to
    // tell whether the therapy is still needed.
    problems[PrescribeField.indication] = 'Give the indication.';
  }

  final hasStructured =
      draft.dose.amount.trim().isNotEmpty && draft.dose.unit.trim().isNotEmpty;
  final hasFreeText = draft.dose.freeText.trim().isNotEmpty;

  if (!hasStructured && !hasFreeText) {
    problems[PrescribeField.dose] = 'Give a dose.';
  } else if (structuredDoseRequired && !hasStructured) {
    // SRS-MED-010.
    problems[PrescribeField.dose] =
        'This medicine needs a numeric dose and unit rather than free text. '
        'The eMAR and the dose checks cannot read free text.';
  }

  if (hasStructured) {
    final amount = draft.dose.amount.trim();
    if (_nakedDecimal.hasMatch(amount)) {
      // .5 read as 5 is a tenfold overdose, which is why every medication
      // safety list says to write the leading zero. The composer can just ask
      // for it rather than pass an ambiguous string on.
      problems[PrescribeField.dose] =
          'Write the dose with a leading zero: ${amount.replaceFirst('.', '0.')}, '
          'not $amount.';
    } else if (!_decimalAmount.hasMatch(amount)) {
      problems[PrescribeField.dose] = 'The dose amount is not a number.';
    } else if (double.parse(amount) <= 0) {
      problems[PrescribeField.dose] =
          'The dose amount must be greater than zero.';
    }
  }

  final order = [
    for (final field in PrescribeField.ordered)
      if (problems.containsKey(field)) problems[field]!,
  ];

  return PrescribeValidity(
    ready: order.isEmpty,
    problems: Map.unmodifiable(problems),
    order: order,
  );
}

/// True when everything permits the prescription to be written.
bool mayPrescribe(PrescribeValidity validity, SafetyGate gate) {
  if (!validity.ready) {
    return false;
  }
  return gate.state == SafetyState.clear ||
      gate.state == SafetyState.overridden;
}

/// What the formulary panel says.
@immutable
class FormularyNotice {
  const FormularyNotice({
    required this.status,
    required this.label,
    required this.action,
    required this.prominent,
  });

  final FormularyStatus status;
  final String label;

  /// What has to happen for this drug to be used here.
  final String action;

  /// True when the notice deserves prominence.
  final bool prominent;
}

String describeFormulary(FormularyStatus status) => switch (status) {
      FormularyStatus.formulary => 'On formulary',
      FormularyStatus.restricted => 'Restricted',
      FormularyStatus.nonFormulary => 'Not on formulary',
      // "Nobody has classified this" rather than "it is fine".
      FormularyStatus.unknown => 'Formulary status unknown',
      FormularyStatus.unspecified => 'Formulary status not checked',
      FormularyStatus.unrecognised => 'Formulary status not recognised by this app',
    };

/// Describes the formulary decision.
///
/// Never a block. The drug may be exactly right, and the prescriber needs to
/// know what it takes to get it — a hard block here produces a phone call and a
/// handwritten chart, which is worse in every way (SRS-MED-012).
FormularyNotice formularyNotice({
  required FormularyStatus status,
  String restriction = '',
  String approvalPath = '',
}) =>
    FormularyNotice(
      status: status,
      label: describeFormulary(status),
      action: approvalPath.isNotEmpty
          ? approvalPath
          : restriction.isNotEmpty
              ? restriction
              : '',
      prominent: status == FormularyStatus.nonFormulary ||
          status == FormularyStatus.restricted,
    );

/// Mirrors medication.v1.TherapyStatus.
enum TherapyStatus {
  draft,
  active,
  held,
  discontinued,
  completed,
  unspecified,
  unrecognised,
}

/// A prescription in the pharmacist's verification queue.
@immutable
class QueueEntry {
  const QueueEntry({
    required this.prescriptionId,
    required this.patientId,
    required this.description,
    required this.createdAt,
    this.prescriberId = '',
    this.therapyStatus = TherapyStatus.draft,
    this.worstSeverity = Severity.unspecified,
    this.findings = const [],
    this.overridden = false,
    this.verified = false,
  });

  final String prescriptionId;
  final String patientId;
  final String description;
  final String prescriberId;
  final DateTime createdAt;
  final TherapyStatus therapyStatus;

  /// The most serious ungraded-away finding, for triage.
  final Severity worstSeverity;
  final List<PresentedFinding> findings;

  /// True when the prescriber overrode at least one finding.
  final bool overridden;
  final bool verified;
}

/// Orders the verification queue.
///
/// By worst finding, then oldest first. A pharmacist working top-down should
/// meet the prescription with a severe interaction before the twentieth routine
/// paracetamol, and among equals the one that has been waiting longest — a
/// queue sorted only by severity starves the bottom.
List<QueueEntry> orderQueue(List<QueueEntry> entries) =>
    [...entries]..sort((a, b) {
        final bySeverity =
            _severityRank(a.worstSeverity) - _severityRank(b.worstSeverity);
        if (bySeverity != 0) {
          return bySeverity;
        }
        return a.createdAt.compareTo(b.createdAt);
      });

/// The most serious severity among findings, or unspecified when there are none.
Severity worstSeverity(List<PresentedFinding> findings) {
  var worst = Severity.unspecified;
  for (final finding in findings) {
    if (_severityRank(finding.severity) < _severityRank(worst)) {
      worst = finding.severity;
    }
  }
  return worst;
}
