/// UX-W1-05 — the medication round.
///
/// This is the screen where a mistake reaches a patient, so most of these tests
/// are about refusing rather than about working.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/meds/round.dart';

final _now = DateTime.utc(2026, 9, 15, 10, 0);

PresentedDose dose({
  String orderId = 'order-1',
  Duration scheduledAgo = Duration.zero,
  bool outstanding = true,
  bool overdue = false,
  bool prn = false,
  bool verified = true,
  AdministrationOutcome? recorded,
}) =>
    presentDose(
      orderId: orderId,
      medication: 'Paracetamol',
      doseValue: 500,
      doseUnit: 'mg',
      route: 'oral',
      scheduledAt: _now.subtract(scheduledAgo),
      outstanding: outstanding,
      overdue: overdue,
      prn: prn,
      verifiedByPharmacy: verified,
      recordedOutcome: recorded,
      now: _now,
    );

const _scanned = Scan(patient: 'wristband-1', medication: 'pack-1');

AdministrationDecision decide({
  PresentedDose? given,
  RoundPolicy policy = RoundPolicy.strict,
  AdministrationOutcome? outcome = AdministrationOutcome.administered,
  Scan scan = _scanned,
  String overrideReason = '',
  String reason = '',
}) =>
    evaluateAdministration(
      dose: given ?? dose(),
      policy: policy,
      outcome: outcome,
      scan: scan,
      overrideReason: overrideReason,
      reason: reason,
    );

void main() {
  group('presenting a dose', () {
    test('a dose is shown exactly as ordered', () {
      // Never rounded. A dose displayed as something other than the dose
      // ordered is the defect this screen exists to prevent.
      expect(formatDose(2.5, 'mg'), '2.5 mg');
      expect(formatDose(0.125, 'mg'), '0.125 mg');
      expect(formatDose(1000, 'units'), '1000 units');
    });

    test('a whole number does not pretend to a precision nobody measured', () {
      expect(formatDose(5, 'mg'), '5 mg');
      expect(formatDose(5.0, 'mg'), '5 mg');
    });

    test('a dose with no unit is still shown', () {
      expect(formatDose(2, ''), '2');
    });

    test('lateness is presentation; overdue comes from the server', () {
      final late = dose(scheduledAgo: const Duration(minutes: 90), overdue: false);
      expect(late.minutesLate, 90);
      expect(late.overdue, isFalse);
    });

    test('a dose not yet due reads as negative minutes', () {
      expect(dose(scheduledAgo: const Duration(minutes: -30)).minutesLate, -30);
    });

    test('a dose with a recorded outcome is settled', () {
      expect(dose().settled, isFalse);
      expect(dose(recorded: AdministrationOutcome.held).settled, isTrue);
    });
  });

  group('ordering the round', () {
    test('outstanding doses come first, then by scheduled time', () {
      final ordered = orderDoses([
        dose(orderId: 'settled', outstanding: false, scheduledAgo: const Duration(hours: 3)),
        dose(orderId: 'later', scheduledAgo: const Duration(minutes: -60)),
        dose(orderId: 'earlier', scheduledAgo: const Duration(minutes: 30)),
      ]);
      expect(ordered.map((d) => d.orderId), ['earlier', 'later', 'settled']);
    });

    test('ordering does not mutate the list it was given', () {
      final original = [
        dose(orderId: 'b', outstanding: false),
        dose(orderId: 'a'),
      ];
      orderDoses(original);
      expect(original.map((d) => d.orderId), ['b', 'a']);
    });
  });

  group('outcomes', () {
    test('only administering means the drug reached the patient', () {
      expect(wasGiven(AdministrationOutcome.administered), isTrue);
      for (final other in [
        AdministrationOutcome.held,
        AdministrationOutcome.refused,
        AdministrationOutcome.notAdministered,
        AdministrationOutcome.delayed,
      ]) {
        expect(wasGiven(other), isFalse, reason: other.name);
      }
    });

    test('held and refused are kept apart', () {
      // One is a clinical decision, the other is the patient's. Flattening them
      // loses the only record of which happened.
      expect(describeOutcome(AdministrationOutcome.held), 'Held');
      expect(describeOutcome(AdministrationOutcome.refused), 'Refused by patient');
      expect(
        describeOutcome(AdministrationOutcome.held),
        isNot(describeOutcome(AdministrationOutcome.notAdministered)),
      );
    });

    test('every deviation from the prescription needs a reason', () {
      expect(needsReason(AdministrationOutcome.administered), isFalse);
      for (final deviation in [
        AdministrationOutcome.held,
        AdministrationOutcome.refused,
        AdministrationOutcome.notAdministered,
        AdministrationOutcome.delayed,
      ]) {
        expect(needsReason(deviation), isTrue, reason: deviation.name);
      }
    });

    test('every outcome has a label', () {
      for (final outcome in AdministrationOutcome.values) {
        expect(describeOutcome(outcome), isNotEmpty, reason: outcome.name);
      }
    });
  });

  group('the verification gate', () {
    test('a scanned dose with an outcome is allowed', () {
      final result = decide();
      expect(result.allowed, isTrue);
      expect(result.overriding, isFalse);
      expect(result.refusals, isEmpty);
    });

    test('an unscanned patient is refused', () {
      final result = decide(scan: const Scan(medication: 'pack-1'));
      expect(result.allowed, isFalse);
      expect(result.refusals, contains(Refusal.patientNotScanned));
      expect(result.refusals, isNot(contains(Refusal.medicationNotScanned)));
    });

    test('an unscanned medication is refused', () {
      final result = decide(scan: const Scan(patient: 'wristband-1'));
      expect(result.refusals, contains(Refusal.medicationNotScanned));
    });

    test('both missing scans are reported at once', () {
      // A nurse told one problem at a time makes three trips to the trolley.
      final result = decide(scan: const Scan());
      expect(result.refusals, containsAll([
        Refusal.patientNotScanned,
        Refusal.medicationNotScanned,
      ]));
    });

    test('whitespace is not a scan', () {
      final result = decide(scan: const Scan(patient: '   ', medication: '  '));
      expect(result.allowed, isFalse);
    });

    test('a ward that forbids overriding offers no way past the scanner', () {
      final result = decide(
        scan: const Scan(),
        overrideReason: 'Scanner is broken',
        policy: const RoundPolicy(
          barcodeRequired: true,
          overrideAllowed: false,
          lateAfter: Duration(minutes: 60),
        ),
      );
      expect(result.allowed, isFalse);
      expect(result.refusals, contains(Refusal.overrideNotPermitted));
      expect(result.overriding, isFalse);
    });

    test('where overriding is allowed, it still needs a reason', () {
      const permissive = RoundPolicy(
        barcodeRequired: true,
        overrideAllowed: true,
        lateAfter: Duration(minutes: 60),
      );

      final without = decide(scan: const Scan(), policy: permissive);
      expect(without.allowed, isFalse);
      expect(without.refusals, contains(Refusal.overrideReasonMissing));

      final with_ = decide(
        scan: const Scan(),
        policy: permissive,
        overrideReason: 'Scanner failed; second nurse checked',
      );
      expect(with_.allowed, isTrue);
      // Named out loud, so it is something the nurse chose rather than
      // something they discover afterwards.
      expect(with_.overriding, isTrue);
    });

    test('a ward that requires no scan lets a dose through unscanned', () {
      final result = decide(
        scan: const Scan(),
        policy: const RoundPolicy(
          barcodeRequired: false,
          overrideAllowed: false,
          lateAfter: Duration(minutes: 60),
        ),
      );
      expect(result.allowed, isTrue);
      expect(result.overriding, isFalse);
    });

    test('recording that a patient refused does not require a wristband scan', () {
      // Nothing goes into the patient. Demanding a scan before a nurse can
      // write down that the patient declined would teach them to record it as
      // something else.
      final result = decide(
        outcome: AdministrationOutcome.refused,
        scan: const Scan(),
        reason: 'Patient declined',
      );
      expect(result.allowed, isTrue);
      expect(result.refusals, isEmpty);
    });

    test('the default policy is the strict one', () {
      // A deployment whose policy did not arrive gets the safe shape: requiring
      // a scan nobody asked for is an inconvenience; skipping one they did is a
      // patient given the wrong drug.
      expect(RoundPolicy.strict.barcodeRequired, isTrue);
      expect(RoundPolicy.strict.overrideAllowed, isFalse);
    });
  });

  group('refusing for other reasons', () {
    test('no outcome chosen is refused', () {
      expect(decide(outcome: null).refusals, contains(Refusal.outcomeMissing));
      expect(
        decide(outcome: AdministrationOutcome.unspecified).refusals,
        contains(Refusal.outcomeMissing),
      );
    });

    test('a deviation with no reason is refused', () {
      final result = decide(outcome: AdministrationOutcome.held, reason: '  ');
      expect(result.allowed, isFalse);
      expect(result.refusals, contains(Refusal.reasonMissing));
    });

    test('a dose already recorded cannot be recorded again', () {
      final result = decide(given: dose(recorded: AdministrationOutcome.administered));
      expect(result.allowed, isFalse);
      expect(result.refusals, contains(Refusal.alreadySettled));
    });

    test('every refusal tells the nurse what to do about it', () {
      for (final refusal in Refusal.values) {
        expect(describeRefusal(refusal), isNotEmpty, reason: refusal.name);
      }
      expect(describeRefusal(Refusal.patientNotScanned), contains('wristband'));
    });
  });
}
