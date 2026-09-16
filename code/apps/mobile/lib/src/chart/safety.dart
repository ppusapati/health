/// The safety panels: allergies, problems and results
/// (UX-W1-02, SRS-CLN-003, SRS-CLN-004, SRS-CLN-011, SRS-CLN-012).
///
/// These are the parts of a chart that exist to stop something happening, and
/// each has a presentation rule that looks like a detail and is not.
///
/// "Unable to assess" is not "low". An allergy nobody could grade is a gap in
/// what is known; rendering it beside the low-criticality entries tells a
/// prescriber there is no danger when what it means is that nobody has looked.
/// It sorts with the high ones, because the question it raises is urgent.
///
/// A refuted allergy stays on the list. Deleting it loses the fact that the
/// question was asked and settled, and the next clinician asks again — or
/// worse, re-records it from the patient's recollection.
///
/// Criticality is never inferred from the reaction text. The laboratory, the
/// prescriber or the allergy service says how serious this is; a screen reading
/// "anaphylaxis" out of free text and promoting the row is a second,
/// undocumented classifier operating beside the recorded one.
library;

import 'package:meta/meta.dart';

/// Mirrors clinical.v1.AllergyCriticality.
enum Criticality { low, high, unableToAssess, unspecified, unrecognised }

/// Mirrors clinical.v1.AllergyVerification.
enum Verification {
  unconfirmed,
  confirmed,
  refuted,
  enteredInError,
  unspecified,
  unrecognised,
}

/// Mirrors clinical.v1.AllergyKind.
enum AllergyKind { allergy, intolerance, unspecified, unrecognised }

/// Mirrors clinical.v1.ProblemStatus.
enum ProblemStatus {
  active,
  remission,
  resolved,
  inactive,
  enteredInError,
  unspecified,
  unrecognised,
}

/// Mirrors clinical.v1.Interpretation.
enum Interpretation {
  normal,
  high,
  low,
  criticalHigh,
  criticalLow,
  abnormal,
  unknown,
  unspecified,
  unrecognised,
}

String describeCriticality(Criticality c) => switch (c) {
      Criticality.high => 'High risk',
      // Never "low" and never blank, and it has to say the risk is unknown
      // rather than only that the assessment did not happen — the second half
      // is the clinical point. Same words as the web shell: a clinician moving
      // between a desk terminal and a tablet should not meet two vocabularies
      // for the same fact.
      Criticality.unableToAssess => 'Not assessed — risk unknown',
      Criticality.low => 'Low risk',
      // "Not classified", not "not recorded": the allergy is recorded, its
      // criticality is not, and an empty panel already says "nothing
      // recorded" about something else entirely.
      Criticality.unspecified => 'Not classified',
      Criticality.unrecognised => 'Risk not recognised by this app',
    };

String describeVerification(Verification v) => switch (v) {
      Verification.confirmed => 'Confirmed',
      Verification.unconfirmed => 'Not confirmed',
      Verification.refuted => 'Ruled out',
      Verification.enteredInError => 'Entered in error',
      Verification.unspecified => 'Not verified',
      Verification.unrecognised => 'Verification not recognised by this app',
    };

String describeAllergyKind(AllergyKind k) => switch (k) {
      AllergyKind.allergy => 'Allergy',
      AllergyKind.intolerance => 'Intolerance',
      AllergyKind.unspecified => 'Not classified',
      AllergyKind.unrecognised => 'Kind not recognised by this app',
    };

String describeProblemStatus(ProblemStatus s) => switch (s) {
      ProblemStatus.active => 'Active',
      ProblemStatus.remission => 'In remission',
      ProblemStatus.resolved => 'Resolved',
      ProblemStatus.inactive => 'Inactive',
      ProblemStatus.enteredInError => 'Entered in error',
      ProblemStatus.unspecified => 'Not classified',
      ProblemStatus.unrecognised => 'Status not recognised by this app',
    };

String describeInterpretation(Interpretation i) => switch (i) {
      Interpretation.normal => 'Normal',
      Interpretation.high => 'High',
      Interpretation.low => 'Low',
      Interpretation.criticalHigh => 'Critically high',
      Interpretation.criticalLow => 'Critically low',
      Interpretation.abnormal => 'Abnormal',
      // "Nobody said" rather than "it is fine". The difference is the whole
      // reason the enum has this value.
      Interpretation.unknown => 'Not interpreted',
      Interpretation.unspecified => 'Not interpreted',
      Interpretation.unrecognised => 'Not interpreted by this app',
    };

/// Sort rank for criticality. Lower is shown first.
int _criticalityRank(Criticality c) => switch (c) {
      Criticality.high => 0,
      // With the high ones. "Nobody has graded this" is urgent in the same way
      // a known high risk is.
      Criticality.unableToAssess => 1,
      // Also near the top: a risk this build cannot read is not a low one.
      Criticality.unrecognised => 1,
      Criticality.unspecified => 2,
      Criticality.low => 3,
    };

/// Verifications where the row is kept for the record rather than acted on.
bool _historical(Verification v) =>
    v == Verification.refuted || v == Verification.enteredInError;

/// An allergy as the panel shows it.
@immutable
class PresentedAllergy {
  const PresentedAllergy({
    required this.allergyId,
    required this.substance,
    required this.kind,
    required this.kindLabel,
    required this.criticality,
    required this.criticalityLabel,
    required this.verification,
    required this.verificationLabel,
    required this.reactions,
    required this.prominent,
    required this.historical,
    required this.note,
  });

  final String allergyId;
  final String substance;
  final AllergyKind kind;
  final String kindLabel;
  final Criticality criticality;
  final String criticalityLabel;
  final Verification verification;
  final String verificationLabel;
  final List<String> reactions;

  /// True when this row is one a prescriber has to see before prescribing.
  final bool prominent;

  /// True when it is kept for the record rather than acted on.
  final bool historical;

  final String note;
}

/// Presents one allergy.
PresentedAllergy presentAllergy({
  required String allergyId,
  required String substance,
  required AllergyKind kind,
  required Criticality criticality,
  required Verification verification,
  List<String> reactions = const [],
  String note = '',
}) {
  final historical = _historical(verification);
  return PresentedAllergy(
    allergyId: allergyId,
    substance: substance,
    kind: kind,
    kindLabel: describeAllergyKind(kind),
    criticality: criticality,
    criticalityLabel: describeCriticality(criticality),
    verification: verification,
    verificationLabel: describeVerification(verification),
    reactions: reactions,
    prominent: !historical &&
        (criticality == Criticality.high ||
            criticality == Criticality.unableToAssess ||
            criticality == Criticality.unrecognised),
    historical: historical,
    note: note,
  );
}

/// Orders the allergy panel.
///
/// Active before historical, then by criticality. A refuted entry above a live
/// high-risk one is the ordering that buries the thing a prescriber needs.
List<PresentedAllergy> orderAllergies(List<PresentedAllergy> allergies) =>
    [...allergies]..sort((a, b) {
        if (a.historical != b.historical) {
          return a.historical ? 1 : -1;
        }
        final byCriticality =
            _criticalityRank(a.criticality) - _criticalityRank(b.criticality);
        if (byCriticality != 0) {
          return byCriticality;
        }
        return a.substance.compareTo(b.substance);
      });

/// True when the panel has nothing recorded at all.
///
/// Its own concept, because "no known allergies" and "nobody has asked" are
/// different clinical facts and an empty list is the second one. The screen
/// says so rather than rendering a reassuring blank.
bool allergiesUnrecorded(List<PresentedAllergy> allergies) => allergies.isEmpty;

/// Rank for problem status. Lower is shown first.
int _problemRank(ProblemStatus s) => switch (s) {
      ProblemStatus.active => 0,
      ProblemStatus.remission => 1,
      ProblemStatus.inactive => 2,
      ProblemStatus.unspecified => 3,
      ProblemStatus.unrecognised => 3,
      ProblemStatus.resolved => 4,
      ProblemStatus.enteredInError => 5,
    };

/// A problem as the list shows it.
@immutable
class PresentedProblem {
  const PresentedProblem({
    required this.problemId,
    required this.code,
    required this.display,
    required this.status,
    required this.statusLabel,
    required this.onsetAt,
    required this.resolvedAt,
    required this.active,
    required this.historical,
  });

  final String problemId;
  final String code;
  final String display;
  final ProblemStatus status;
  final String statusLabel;
  final DateTime? onsetAt;
  final DateTime? resolvedAt;

  /// True when the problem is current.
  final bool active;

  /// True when it is kept as history rather than acted on.
  final bool historical;
}

/// Presents one problem.
PresentedProblem presentProblem({
  required String problemId,
  required String code,
  required String display,
  required ProblemStatus status,
  DateTime? onsetAt,
  DateTime? resolvedAt,
}) =>
    PresentedProblem(
      problemId: problemId,
      code: code,
      display: display,
      status: status,
      statusLabel: describeProblemStatus(status),
      onsetAt: onsetAt,
      resolvedAt: resolvedAt,
      active: status == ProblemStatus.active || status == ProblemStatus.remission,
      historical: status == ProblemStatus.resolved ||
          status == ProblemStatus.inactive ||
          status == ProblemStatus.enteredInError,
    );

/// Orders the problem list: active first, then most recent onset.
List<PresentedProblem> orderProblems(List<PresentedProblem> problems) =>
    [...problems]..sort((a, b) {
        final byStatus = _problemRank(a.status) - _problemRank(b.status);
        if (byStatus != 0) {
          return byStatus;
        }
        final aOnset = a.onsetAt;
        final bOnset = b.onsetAt;
        if (aOnset == null && bOnset == null) return 0;
        // A problem with no onset date sorts after one that has it, rather
        // than to the top as the epoch would put it.
        if (aOnset == null) return 1;
        if (bOnset == null) return -1;
        return bOnset.compareTo(aOnset);
      });

/// An observation as the chart shows it.
@immutable
class PresentedObservation {
  const PresentedObservation({
    required this.observationId,
    required this.display,
    required this.value,
    required this.unit,
    required this.interpretation,
    required this.interpretationLabel,
    required this.interpretationSource,
    required this.referenceRange,
    required this.effectiveAt,
    required this.critical,
    required this.numericValue,
    this.status = '',
  });

  final String observationId;
  final String display;

  /// "7.4 mmol/L", or the text value when it is not a quantity.
  final String value;

  /// The unit alone, so a trend can refuse to mix them.
  final String unit;

  final Interpretation interpretation;
  final String interpretationLabel;

  /// Who said it was abnormal. Shown, because SRS-CLN-011 is explicit that the
  /// flag comes from the authoritative service and the UI must not infer it —
  /// and a flag with no attribution is indistinguishable from an inferred one.
  final String interpretationSource;

  final String referenceRange;
  final DateTime effectiveAt;
  final bool critical;

  /// The number behind [value], or null when this is not a quantity. Carried
  /// on the row so a trend does not need a second lookup keyed on id — the web
  /// passes a parallel list, and two lists that have to stay aligned is a bug
  /// waiting for somebody to filter one of them.
  final double? numericValue;

  final String status;
}

/// Presents one observation.
PresentedObservation presentObservation({
  required String observationId,
  required String display,
  required DateTime effectiveAt,
  required Interpretation interpretation,
  double? value,
  String unit = '',
  String textValue = '',
  String interpretationSource = '',
  double? referenceLow,
  double? referenceHigh,
  String referenceText = '',
  String status = '',
}) {
  final rendered = value != null
      ? '$value${unit.isNotEmpty ? ' $unit' : ''}'
      : textValue;

  final range = referenceLow != null && referenceHigh != null
      ? '$referenceLow–$referenceHigh${unit.isNotEmpty ? ' $unit' : ''}'
      : referenceText;

  return PresentedObservation(
    observationId: observationId,
    display: display,
    value: rendered,
    unit: unit,
    interpretation: interpretation,
    interpretationLabel: describeInterpretation(interpretation),
    interpretationSource: interpretationSource,
    referenceRange: range,
    effectiveAt: effectiveAt,
    critical: interpretation == Interpretation.criticalHigh ||
        interpretation == Interpretation.criticalLow,
    numericValue: value,
    status: status,
  );
}

/// One point on a trend.
@immutable
class TrendPoint {
  const TrendPoint({required this.at, required this.value});
  final DateTime at;
  final double value;
}

/// A series of one observation code over time.
@immutable
class Trend {
  const Trend({
    required this.display,
    required this.unit,
    required this.points,
    required this.mixedUnits,
  });

  final String display;
  final String unit;
  final List<TrendPoint> points;

  /// True when the series contains more than one unit and was therefore not
  /// plotted. A trend that silently mixes mg/dL and mmol/L is a graph that
  /// reads as a clinical change.
  final bool mixedUnits;
}

/// Builds a trend from observations of one code.
///
/// Refuses to plot across units rather than converting. Conversion needs the
/// analyte's molar mass, which this layer does not have and must not guess, and
/// a silently converted series looks exactly like a correctly measured one.
Trend buildTrend(List<PresentedObservation> observations) {
  final numeric = observations.where((o) => o.numericValue != null).toList();
  final units = numeric.map((o) => o.unit).toSet();
  final mixedUnits = units.length > 1;

  return Trend(
    display: numeric.isEmpty ? '' : numeric.first.display,
    unit: numeric.isEmpty ? '' : numeric.first.unit,
    points: mixedUnits
        ? const []
        : (numeric
            .map((o) => TrendPoint(at: o.effectiveAt, value: o.numericValue!))
            .toList()
          ..sort((a, b) => a.at.compareTo(b.at))),
    mixedUnits: mixedUnits,
  );
}
