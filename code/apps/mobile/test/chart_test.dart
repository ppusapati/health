import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/chart/notes.dart';
import 'package:health_mobile/src/chart/safety.dart';

ChartDocument doc({
  DocumentStatus status = DocumentStatus.draft,
  bool intact = true,
  List<DocumentSignature> signatures = const [],
}) =>
    ChartDocument(
      documentId: 'd1',
      title: 'Ward round',
      status: status,
      authoredBy: 'dr-1',
      createdAt: DateTime.utc(2026, 9, 16, 9),
      intact: intact,
      signatures: signatures,
    );

DocumentSignature sig(SignatureMeaning meaning) => DocumentSignature(
      subjectId: 's1', meaning: meaning, signedAt: DateTime.utc(2026, 9, 16),
    );

void main() {
  group('the document lifecycle', () {
    test('a draft may be edited and signed', () {
      final actions = actionsFor(doc(), mayWrite: true);
      expect(actions.edit, isTrue);
      expect(actions.sign, isTrue);
      expect(actions.amend, isFalse);
    });

    test('a signed note offers no edit at all', () {
      // The whole rule. Not disabled — the action does not exist, because the
      // moment a clinician sees Edit on a note they signed is the moment they
      // assume the change is invisible.
      for (final status in [
        DocumentStatus.signed,
        DocumentStatus.amended,
        DocumentStatus.addendum,
      ]) {
        final actions = actionsFor(doc(status: status), mayWrite: true);
        expect(actions.edit, isFalse, reason: 'edit offered on $status');
        expect(actions.sign, isFalse, reason: 'sign offered on $status');
        expect(actions.amend, isTrue);
        expect(actions.addendum, isTrue);
      }
    });

    test('a broken signature offers nothing at all, not even an amendment', () {
      // Amending it would produce a new document derived from content nobody
      // vouched for, which is worse than refusing.
      final actions =
          actionsFor(doc(status: DocumentStatus.signed, intact: false),
              mayWrite: true);
      expect(actions.none, isTrue);
      expect(actions.blockedReason, contains('no longer matches what was signed'));
      expect(actions.blockedReason, contains('do not amend'));
    });

    test('a broken signature outranks even a draft', () {
      final actions = actionsFor(doc(intact: false), mayWrite: true);
      expect(actions.none, isTrue);
    });

    test('read-only access offers nothing and says why', () {
      final actions = actionsFor(doc(), mayWrite: false);
      expect(actions.none, isTrue);
      expect(actions.blockedReason, contains('read-only'));
    });

    test('a retracted document is kept and cannot be changed further', () {
      final actions =
          actionsFor(doc(status: DocumentStatus.enteredInError), mayWrite: true);
      expect(actions.none, isTrue);
      expect(actions.blockedReason, contains('kept for the record'));
    });

    test('an unreadable status refuses rather than guessing a lifecycle', () {
      for (final status in [
        DocumentStatus.unspecified,
        DocumentStatus.unrecognised,
      ]) {
        final actions = actionsFor(doc(status: status), mayWrite: true);
        expect(actions.none, isTrue, reason: '$status offered an action');
        expect(actions.blockedReason, contains('does not recognise'));
      }
    });

    test('a draft is retracted rather than deleted', () {
      // A draft visible to the care team for an hour was still visible.
      expect(actionsFor(doc(), mayWrite: true).retract, isTrue);
    });

    test('a transcriber does not finalise a note', () {
      // SRS-CLN-016: they typed what somebody else said and are not asserting
      // the clinical content. Counting it is how a dictated note reaches the
      // record with nobody clinically accountable.
      expect(finalises(SignatureMeaning.transcriber), isFalse);
      expect(finalises(SignatureMeaning.witness), isFalse);
      expect(finalises(SignatureMeaning.author), isTrue);
      expect(finalises(SignatureMeaning.verifier), isTrue);
      expect(finalises(SignatureMeaning.cosigner), isTrue);
    });

    test('a note signed only by a transcriber is not finalised', () {
      expect(doc(signatures: [sig(SignatureMeaning.transcriber)]).finalised,
          isFalse);
      expect(
        doc(signatures: [
          sig(SignatureMeaning.transcriber),
          sig(SignatureMeaning.author),
        ]).finalised,
        isTrue,
      );
    });

    test('an unrecognised signature meaning does not finalise anything', () {
      expect(finalises(SignatureMeaning.unrecognised), isFalse);
    });

    test('retraction is never described as deletion', () {
      expect(describeDocumentStatus(DocumentStatus.enteredInError),
          'Entered in error');
      expect(describeDocumentStatus(DocumentStatus.enteredInError),
          isNot(contains('Delete')));
    });
  });

  group('correcting a note', () {
    test('the choice is put as the question the clinician is answering', () {
      // Not "Amend" and "Addendum": those are the record's words, not the
      // question, which is whether what they wrote was wrong.
      expect(describeCorrection(CorrectionKind.amendment).title,
          'Correct what this note says');
      expect(describeCorrection(CorrectionKind.addendum).title,
          'Add something that arrived later');
    });

    test('an amendment needs a reason and an addendum does not', () {
      // An amendment with no reason leaves the next reader unable to tell a
      // typing slip from a clinical reversal.
      expect(describeCorrection(CorrectionKind.amendment).reasonRequired, isTrue);
      expect(describeCorrection(CorrectionKind.addendum).reasonRequired, isFalse);
    });

    test('both explain that the original survives', () {
      expect(describeCorrection(CorrectionKind.amendment).detail,
          contains('original stays readable'));
      expect(describeCorrection(CorrectionKind.addendum).detail,
          contains('original is unchanged'));
    });
  });

  group('signing a draft', () {
    SignReadiness check({
      String title = 'Ward round',
      List<DraftSection> sections = const [
        DraftSection(heading: 'Plan', text: 'Continue.'),
      ],
      String templateVersion = 'v3',
      String patientId = 'p1',
      String encounterId = 'e1',
    }) =>
        readyToSign(
          title: title,
          sections: sections,
          templateVersion: templateVersion,
          patientId: patientId,
          encounterId: encounterId,
        );

    test('a complete draft is ready', () {
      expect(check().ready, isTrue);
      expect(check().problems, isEmpty);
    });

    test('an empty note is refused, because it reads as an assessment', () {
      final result = check(sections: const [
        DraftSection(heading: 'Plan', text: '   '),
      ]);
      expect(result.ready, isFalse);
      expect(result.problems, contains('The note has no content.'));
    });

    test('a note with no template version cannot be re-rendered later', () {
      // SRS-CLN-002: without it, the note cannot be shown as written once the
      // template changes.
      expect(check(templateVersion: '').problems,
          contains('The note is not linked to a template version.'));
    });

    test('a note detached from a patient or encounter is refused', () {
      expect(check(patientId: '').ready, isFalse);
      expect(check(encounterId: '').ready, isFalse);
    });

    test('every problem is reported at once, not one at a time', () {
      final result = check(
        title: '', patientId: '', encounterId: '', templateVersion: '',
        sections: const [],
      );
      expect(result.problems, hasLength(5));
    });
  });

  group('the allergy panel', () {
    PresentedAllergy allergy({
      String id = 'a1',
      String substance = 'Penicillin',
      Criticality criticality = Criticality.high,
      Verification verification = Verification.confirmed,
    }) =>
        presentAllergy(
          allergyId: id,
          substance: substance,
          kind: AllergyKind.allergy,
          criticality: criticality,
          verification: verification,
        );

    test('unable to assess sorts with the high risks, never with the low', () {
      // Rendering it beside the low ones tells a prescriber there is no danger
      // when what it means is that nobody has looked.
      final ordered = orderAllergies([
        allergy(id: 'low', substance: 'A', criticality: Criticality.low),
        allergy(id: 'ungraded', substance: 'B',
            criticality: Criticality.unableToAssess),
        allergy(id: 'high', substance: 'C', criticality: Criticality.high),
      ]);
      expect(ordered.map((a) => a.allergyId), ['high', 'ungraded', 'low']);
    });

    test('unable to assess is prominent, like a known high risk', () {
      expect(allergy(criticality: Criticality.unableToAssess).prominent, isTrue);
      expect(allergy(criticality: Criticality.low).prominent, isFalse);
    });

    test('its label says the risk is unknown, never "low" and never blank', () {
      // The second half is the clinical point: that nobody assessed it is a
      // fact about the process, that the risk is unknown is a fact about the
      // patient. Same words as the web shell, so a clinician moving between a
      // desk terminal and a tablet meets one vocabulary.
      final label = describeCriticality(Criticality.unableToAssess);
      expect(label, 'Not assessed — risk unknown');
      expect(label.toLowerCase(), isNot(contains('low')));
    });

    test('a ruled-out allergy stays on the list, below the live ones', () {
      // Deleting it loses the fact that the question was asked and settled,
      // and the next clinician re-records it from the patient's recollection.
      final ordered = orderAllergies([
        allergy(id: 'refuted', substance: 'A',
            verification: Verification.refuted),
        allergy(id: 'live', substance: 'Z', criticality: Criticality.low),
      ]);
      expect(ordered.map((a) => a.allergyId), ['live', 'refuted']);
      expect(ordered.last.historical, isTrue);
    });

    test('a ruled-out high-risk allergy is not prominent', () {
      final refuted = allergy(
        criticality: Criticality.high, verification: Verification.refuted,
      );
      expect(refuted.prominent, isFalse);
      expect(refuted.historical, isTrue);
    });

    test('an unreadable criticality is treated as needing attention', () {
      // Not as low. A risk this build cannot read is not a low one.
      expect(allergy(criticality: Criticality.unrecognised).prominent, isTrue);
      final ordered = orderAllergies([
        allergy(id: 'low', substance: 'A', criticality: Criticality.low),
        allergy(id: 'unknown', substance: 'B',
            criticality: Criticality.unrecognised),
      ]);
      expect(ordered.first.allergyId, 'unknown');
    });

    test('an empty panel is "nobody asked", not "no known allergies"', () {
      // Two different clinical facts, and an empty list is the second one.
      expect(allergiesUnrecorded([]), isTrue);
      expect(allergiesUnrecorded([allergy()]), isFalse);
    });

    test('criticality is never derived from the reaction text', () {
      // A screen reading "anaphylaxis" out of free text is a second,
      // undocumented classifier beside the recorded one.
      final recorded = presentAllergy(
        allergyId: 'a1',
        substance: 'Penicillin',
        kind: AllergyKind.allergy,
        criticality: Criticality.low,
        verification: Verification.confirmed,
        reactions: ['anaphylaxis', 'cardiac arrest'],
      );
      expect(recorded.criticality, Criticality.low);
      expect(recorded.prominent, isFalse);
    });
  });

  group('the problem list', () {
    PresentedProblem problem({
      String id = 'p1',
      ProblemStatus status = ProblemStatus.active,
      DateTime? onsetAt,
    }) =>
        presentProblem(
          problemId: id, code: 'X', display: 'Something',
          status: status, onsetAt: onsetAt,
        );

    test('active problems come first, then most recent onset', () {
      final ordered = orderProblems([
        problem(id: 'resolved', status: ProblemStatus.resolved),
        problem(id: 'old', onsetAt: DateTime.utc(2020)),
        problem(id: 'new', onsetAt: DateTime.utc(2026)),
      ]);
      expect(ordered.map((p) => p.problemId), ['new', 'old', 'resolved']);
    });

    test('remission counts as current, resolved does not', () {
      expect(problem(status: ProblemStatus.remission).active, isTrue);
      expect(problem(status: ProblemStatus.resolved).active, isFalse);
      expect(problem(status: ProblemStatus.resolved).historical, isTrue);
    });

    test('a problem with no onset date sorts after one that has it', () {
      // Treating a missing date as the epoch would sort it to the bottom by
      // accident rather than on purpose, and to the top under a descending
      // comparison.
      final ordered = orderProblems([
        problem(id: 'undated'),
        problem(id: 'dated', onsetAt: DateTime.utc(1990)),
      ]);
      expect(ordered.map((p) => p.problemId), ['dated', 'undated']);
    });
  });

  group('results and trends', () {
    PresentedObservation observation({
      String id = 'o1',
      double? value = 7.4,
      String unit = 'mmol/L',
      Interpretation interpretation = Interpretation.normal,
      DateTime? at,
    }) =>
        presentObservation(
          observationId: id,
          display: 'Glucose',
          effectiveAt: at ?? DateTime.utc(2026, 9, 16, 9),
          interpretation: interpretation,
          value: value,
          unit: unit,
          interpretationSource: 'Central Laboratory',
        );

    test('"not interpreted" is never rendered as normal', () {
      // The difference is the whole reason the enum has the value.
      expect(describeInterpretation(Interpretation.unknown), 'Not interpreted');
      expect(describeInterpretation(Interpretation.unspecified),
          'Not interpreted');
      expect(describeInterpretation(Interpretation.unknown),
          isNot(contains('Normal')));
    });

    test('only the critical interpretations are flagged critical', () {
      expect(observation(interpretation: Interpretation.criticalHigh).critical,
          isTrue);
      expect(observation(interpretation: Interpretation.criticalLow).critical,
          isTrue);
      expect(observation(interpretation: Interpretation.high).critical, isFalse);
      expect(observation(interpretation: Interpretation.abnormal).critical,
          isFalse);
    });

    test('who flagged it is carried, because an unattributed flag looks inferred',
        () {
      // SRS-CLN-011 is explicit that the flag comes from the authoritative
      // service and the UI must not infer it.
      expect(observation().interpretationSource, 'Central Laboratory');
    });

    test('a trend refuses to plot across units rather than converting', () {
      // Conversion needs the analyte's molar mass, which this layer does not
      // have and must not guess.
      final trend = buildTrend([
        observation(id: 'a', value: 7.4, unit: 'mmol/L'),
        observation(id: 'b', value: 133, unit: 'mg/dL'),
      ]);
      expect(trend.mixedUnits, isTrue);
      expect(trend.points, isEmpty);
    });

    test('a single-unit series plots in time order', () {
      final trend = buildTrend([
        observation(id: 'b', value: 8.1, at: DateTime.utc(2026, 9, 16, 12)),
        observation(id: 'a', value: 7.4, at: DateTime.utc(2026, 9, 16, 9)),
      ]);
      expect(trend.mixedUnits, isFalse);
      expect(trend.points.map((p) => p.value), [7.4, 8.1]);
      expect(trend.unit, 'mmol/L');
    });

    test('a non-numeric result is kept off the trend but still shown', () {
      final text = presentObservation(
        observationId: 'o9', display: 'Culture',
        effectiveAt: DateTime.utc(2026, 9, 16),
        interpretation: Interpretation.abnormal,
        textValue: 'E. coli isolated',
      );
      expect(text.value, 'E. coli isolated');
      expect(buildTrend([text]).points, isEmpty);
    });

    test('a value is rendered with its unit, and without one when there is none',
        () {
      expect(observation().value, '7.4 mmol/L');
      expect(observation(unit: '').value, '7.4');
    });
  });
}
