import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/meds/prescribe.dart';

PresentedFinding finding(
  String id,
  Severity severity, {
  String existingReason = '',
  FindingKind kind = FindingKind.interaction,
}) =>
    presentFinding(
      ruleId: id, kind: kind, severity: severity,
      summary: 'Finding $id', existingOverrideReason: existingReason,
    );

PrescriptionDraft draft({
  String patientId = 'p1',
  String encounterId = 'e1',
  String ingredientCode = 'AMX',
  String route = 'oral',
  String indication = 'chest infection',
  DoseDraft dose = const DoseDraft(amount: '500', unit: 'mg'),
}) =>
    PrescriptionDraft(
      patientId: patientId, encounterId: encounterId,
      ingredientCode: ingredientCode, route: route,
      indication: indication, dose: dose,
    );

void main() {
  group('a contraindication is not overridable', () {
    test('by anybody, with any reason', () {
      // The one severity where the answer is "no" rather than "why".
      final gate = safetyGate(
        [finding('r1', Severity.contraindicated)],
        [const OverrideAnswer(ruleId: 'r1', reason: 'I am sure')],
      );
      expect(gate.state, SafetyState.contraindicated);
      expect(gate.message, contains('cannot be prescribed here'));
      expect(mayPrescribe(validatePrescription(draft(),
          structuredDoseRequired: false), gate), isFalse);
    });

    test('it is never presented as something a reason could clear', () {
      expect(finding('r1', Severity.contraindicated).overridable, isFalse);
      for (final severity in [
        Severity.severe, Severity.moderate, Severity.mild,
        Severity.informational, Severity.unspecified, Severity.unrecognised,
      ]) {
        expect(finding('r1', severity).overridable, isTrue,
            reason: '$severity was not overridable');
      }
    });

    test('the message counts them', () {
      final gate = safetyGate([
        finding('r1', Severity.contraindicated),
        finding('r2', Severity.contraindicated),
      ], []);
      expect(gate.message, startsWith('2 contraindications'));
      expect(gate.findings, hasLength(2));
    });

    test('a contraindication outranks every overridable finding', () {
      final gate = safetyGate([
        finding('r1', Severity.severe),
        finding('r2', Severity.contraindicated),
      ], [const OverrideAnswer(ruleId: 'r1', reason: 'considered')]);
      expect(gate.state, SafetyState.contraindicated);
    });
  });

  group('overrides are per rule', () {
    test('a reason for one warning does not clear another', () {
      // A single "I have considered these" box produces one sentence covering
      // an allergy and a dose warning at once, which is what makes an override
      // record unreadable at verification.
      final gate = safetyGate([
        finding('allergy', Severity.severe),
        finding('dose', Severity.moderate),
      ], [const OverrideAnswer(ruleId: 'allergy', reason: 'mild rash only')]);
      expect(gate.state, SafetyState.needsReasons);
      expect(gate.outstanding.map((f) => f.ruleId), ['dose']);
    });

    test('answering every rule opens the gate', () {
      final gate = safetyGate([
        finding('allergy', Severity.severe),
        finding('dose', Severity.moderate),
      ], [
        const OverrideAnswer(ruleId: 'allergy', reason: 'mild rash only'),
        const OverrideAnswer(ruleId: 'dose', reason: 'renal dosing applied'),
      ]);
      expect(gate.state, SafetyState.overridden);
    });

    test('whitespace is not a reason', () {
      final gate = safetyGate(
        [finding('r1', Severity.severe)],
        [const OverrideAnswer(ruleId: 'r1', reason: '   ')],
      );
      expect(gate.state, SafetyState.needsReasons);
    });

    test('a reason for a rule that was not raised opens nothing', () {
      final gate = safetyGate(
        [finding('r1', Severity.severe)],
        [const OverrideAnswer(ruleId: 'other', reason: 'considered')],
      );
      expect(gate.state, SafetyState.needsReasons);
    });

    test('a reason already recorded on the server does not need retyping', () {
      final gate = safetyGate(
        [finding('r1', Severity.severe, existingReason: 'agreed at the MDT')],
        [],
      );
      expect(gate.state, SafetyState.clear);
    });
  });

  group('informational findings do not gate', () {
    test('they are shown and asked nothing', () {
      // Requiring a typed reason for every piece of advice trains prescribers
      // to type "ok" into the box that also guards the severe ones.
      final gate = safetyGate([finding('r1', Severity.informational)], []);
      expect(gate.state, SafetyState.clear);
    });

    test('but an unrecognised severity does gate', () {
      // A finding this build cannot grade is not advice.
      final gate = safetyGate([finding('r1', Severity.unrecognised)], []);
      expect(gate.state, SafetyState.needsReasons);
    });

    test('an unrecognised severity sorts with the severe ones', () {
      final ordered = orderFindings([
        finding('mild', Severity.mild),
        finding('unknown', Severity.unrecognised),
        finding('stop', Severity.contraindicated),
      ]);
      expect(ordered.map((f) => f.ruleId), ['stop', 'unknown', 'mild']);
    });

    test('findings sort by severity, then by rule for a stable order', () {
      final ordered = orderFindings([
        finding('z', Severity.moderate),
        finding('a', Severity.moderate),
        finding('stop', Severity.contraindicated),
      ]);
      expect(ordered.map((f) => f.ruleId), ['stop', 'a', 'z']);
    });
  });

  group('the dose', () {
    PrescribeValidity check(DoseDraft dose, {bool structured = false}) =>
        validatePrescription(draft(dose: dose),
            structuredDoseRequired: structured);

    test('a structured dose satisfies both policies', () {
      expect(check(const DoseDraft(amount: '500', unit: 'mg')).ready, isTrue);
      expect(check(const DoseDraft(amount: '500', unit: 'mg'), structured: true)
          .ready, isTrue);
    });

    test('free text is fine unless the class forbids it', () {
      expect(check(const DoseDraft(freeText: 'two puffs as needed')).ready,
          isTrue);
      final refused = check(
          const DoseDraft(freeText: 'as directed'), structured: true);
      expect(refused.ready, isFalse);
      expect(refused.problems[PrescribeField.dose],
          contains('cannot read free text'));
    });

    test('no dose at all is refused', () {
      expect(check(const DoseDraft()).problems[PrescribeField.dose],
          'Give a dose.');
    });

    test('a dose amount that is not a number is refused', () {
      expect(
        check(const DoseDraft(amount: 'five hundred', unit: 'mg'))
            .problems[PrescribeField.dose],
        'The dose amount is not a number.',
      );
    });

    test('a dose that parses to something impossible is refused', () {
      // double.tryParse accepts both of these, and NaN fails every comparison
      // — so `amount <= 0` was false for it and a dose of NaN validated
      // cleanly. Found by asking the web the same question.
      for (final amount in ['NaN', 'Infinity', '-Infinity', '1e3', '0x10', '1,5']) {
        expect(
          check(DoseDraft(amount: amount, unit: 'mg'))
              .problems[PrescribeField.dose],
          'The dose amount is not a number.',
          reason: amount,
        );
      }
    });

    test('a naked decimal point is refused, and says why', () {
      // .5 read as 5 is a tenfold overdose.
      expect(
        check(const DoseDraft(amount: '.5', unit: 'mg'))
            .problems[PrescribeField.dose],
        'Write the dose with a leading zero: 0.5, not .5.',
      );
      expect(check(const DoseDraft(amount: '0.5', unit: 'mg')).ready, isTrue);
    });

    test('a zero or negative dose is refused', () {
      for (final amount in ['0', '-5']) {
        expect(
          check(DoseDraft(amount: amount, unit: 'mg'))
              .problems[PrescribeField.dose],
          'The dose amount must be greater than zero.',
        );
      }
    });

    test('an amount with no unit is not a structured dose', () {
      // "500" of what? It falls back to needing free text.
      expect(check(const DoseDraft(amount: '500')).ready, isFalse);
    });
  });

  group('the structured-dose policy', () {
    test('matches a configured class, case and space insensitively', () {
      expect(structuredDoseRequiredFor(['anticoagulant'], 'Anticoagulant'),
          isTrue);
      expect(structuredDoseRequiredFor(['anticoagulant'], '  anticoagulant '),
          isTrue);
      expect(structuredDoseRequiredFor(['anticoagulant'], 'analgesic'), isFalse);
    });

    test('an unclassified drug is not forced into structured dosing', () {
      // The honest answer rather than the safe-looking one: refusing free text
      // for everything unclassified blocks legitimate "two puffs as needed"
      // prescribing on the many drugs a hospital never classifies.
      expect(structuredDoseRequiredFor(['anticoagulant'], ''), isFalse);
      expect(structuredDoseRequiredFor(['anticoagulant'], '   '), isFalse);
    });
  });

  group('what else a prescription needs', () {
    test('a route, because oral and intravenous are different doses', () {
      expect(validatePrescription(draft(route: ''), structuredDoseRequired: false)
          .problems[PrescribeField.route], 'Give the route.');
    });

    test('an indication, so a later review can tell if it is still needed', () {
      expect(
        validatePrescription(draft(indication: ''), structuredDoseRequired: false)
            .problems[PrescribeField.indication],
        'Give the indication.',
      );
    });

    test('a patient, an encounter and something to prescribe', () {
      expect(validatePrescription(draft(patientId: ''),
          structuredDoseRequired: false).ready, isFalse);
      expect(validatePrescription(draft(encounterId: ''),
          structuredDoseRequired: false).ready, isFalse);
      expect(validatePrescription(draft(ingredientCode: ''),
          structuredDoseRequired: false).ready, isFalse);
    });

    test('problems come back in the order they should be fixed', () {
      final validity = validatePrescription(
        draft(patientId: '', route: '', indication: '',
            dose: const DoseDraft()),
        structuredDoseRequired: false,
      );
      expect(validity.order.first, contains('not attached to a patient'));
      expect(validity.order.last, contains('indication'));
    });
  });

  group('the formulary never blocks', () {
    test('a non-formulary drug shows the approval path instead', () {
      // A hard block produces a phone call and a handwritten chart, which is
      // worse in every way.
      final notice = formularyNotice(
        status: FormularyStatus.nonFormulary,
        approvalPath: 'Consultant microbiologist approval',
      );
      expect(notice.action, 'Consultant microbiologist approval');
      expect(notice.prominent, isTrue);
      // Nothing about the notice gates the prescription.
      expect(
        mayPrescribe(
          validatePrescription(draft(), structuredDoseRequired: false),
          safetyGate([], []),
        ),
        isTrue,
      );
    });

    test('the approval path wins over a bare restriction', () {
      expect(
        formularyNotice(
          status: FormularyStatus.restricted,
          restriction: 'ICU only',
          approvalPath: 'Ask the on-call consultant',
        ).action,
        'Ask the on-call consultant',
      );
      expect(
        formularyNotice(
          status: FormularyStatus.restricted, restriction: 'ICU only',
        ).action,
        'ICU only',
      );
    });

    test('unknown is "nobody classified this", not "it is fine"', () {
      expect(describeFormulary(FormularyStatus.unknown),
          'Formulary status unknown');
      expect(describeFormulary(FormularyStatus.unknown),
          isNot(contains('On formulary')));
    });

    test('only the two that need action are prominent', () {
      expect(formularyNotice(status: FormularyStatus.formulary).prominent,
          isFalse);
      expect(formularyNotice(status: FormularyStatus.unknown).prominent,
          isFalse);
      expect(formularyNotice(status: FormularyStatus.restricted).prominent,
          isTrue);
      expect(formularyNotice(status: FormularyStatus.nonFormulary).prominent,
          isTrue);
    });
  });
}
