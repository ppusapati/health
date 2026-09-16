import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/gen/healthcare/medication/v1/medication.pb.dart'
    as wire;
import 'package:health_mobile/src/meds/prescribe.dart';
import 'package:health_mobile/src/meds/prescribe_mapping.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

/// Appends a varint field to an encoded message, as a newer server would.
List<int> withVarintField(List<int> encoded, int tag, int value) {
  final out = [...encoded];
  _varint(out, (tag << 3) | 0);
  _varint(out, value);
  return out;
}

void _varint(List<int> out, int value) {
  var v = value;
  while (v >= 0x80) {
    out.add((v & 0x7f) | 0x80);
    v >>= 7;
  }
  out.add(v);
}

void main() {
  group('an enum from a newer contract', () {
    test('an unreadable severity is not shown as ungraded', () {
      // protobuf.dart decodes an unknown tag as the zero member, so without
      // the unknownFields check this would arrive as SEVERITY_UNSPECIFIED and
      // be labelled "Severity not graded" — quieter than the server meant.
      final bytes = withVarintField(
        wire.SafetyFinding(ruleId: 'r1').writeToBuffer(),
        findingSeverityField,
        9999,
      );
      final finding = wire.SafetyFinding.fromBuffer(bytes);
      expect(severityOf(finding), Severity.unrecognised);
      expect(describeSeverity(severityOf(finding)), contains('not recognised'));
    });

    test('an unreadable severity still needs a reason, and sorts with severe', () {
      final bytes = withVarintField(
        wire.SafetyFinding(ruleId: 'r1', summary: 'Something new')
            .writeToBuffer(),
        findingSeverityField,
        9999,
      );
      final finding = presentedFindingOf(wire.SafetyFinding.fromBuffer(bytes));

      // Overridable — an unknown severity is not a contraindication — but the
      // gate still asks for a reason.
      expect(finding.overridable, isTrue);
      expect(safetyGate([finding], const []).state, SafetyState.needsReasons);

      final ordered = orderFindings([
        presentFinding(
          ruleId: 'mild',
          kind: FindingKind.interaction,
          severity: Severity.mild,
          summary: 'Mild',
        ),
        finding,
      ]);
      expect(ordered.first.ruleId, 'r1');
    });

    test('an unreadable kind is not mistaken for a known one', () {
      final bytes = withVarintField(
        wire.SafetyFinding(ruleId: 'r1').writeToBuffer(),
        findingKindField,
        9999,
      );
      expect(findingKindOf(wire.SafetyFinding.fromBuffer(bytes)),
          FindingKind.unrecognised);
    });

    test('an unreadable formulary status is not read as on-formulary', () {
      final bytes = withVarintField(
        wire.FormularyDecision(restriction: 'ICU only').writeToBuffer(),
        formularyStatusField,
        9999,
      );
      final status =
          formularyStatusOf(wire.FormularyDecision.fromBuffer(bytes));
      expect(status, FormularyStatus.unrecognised);
      // And still never a block: the notice says what it takes.
      expect(formularyNotice(status: status, restriction: 'ICU only').action,
          'ICU only');
    });

    test('an unreadable therapy status is not read as discontinued', () {
      // The dangerous direction: a therapy this build cannot classify must not
      // look finished, because a finished therapy is one nobody restarts.
      final bytes = withVarintField(
        wire.Prescription(prescriptionId: 'rx1').writeToBuffer(),
        therapyStatusField,
        9999,
      );
      final status = therapyStatusOf(wire.Prescription.fromBuffer(bytes));
      expect(status, TherapyStatus.unrecognised);
      expect(describeTherapy(status), contains('not recognised'));
    });

    test('the field tags are the ones the contract actually uses', () {
      expect(wire.SafetyFinding.getDefault().info_.byName['kind']!.tagNumber,
          findingKindField);
      expect(
          wire.SafetyFinding.getDefault().info_.byName['severity']!.tagNumber,
          findingSeverityField);
      expect(
          wire.FormularyDecision.getDefault().info_.byName['status']!.tagNumber,
          formularyStatusField);
      expect(
          wire.Prescription.getDefault().info_
              .byName['therapyStatus']!.tagNumber,
          therapyStatusField);
    });

    test('every value the contract defines maps', () {
      for (final s in wire.Severity.values) {
        expect(severityOf(wire.SafetyFinding(severity: s)),
            isNot(Severity.unrecognised),
            reason: 'no mapping for ${s.name}');
      }
      for (final k in wire.FindingKind.values) {
        expect(findingKindOf(wire.SafetyFinding(kind: k)),
            isNot(FindingKind.unrecognised),
            reason: 'no mapping for ${k.name}');
      }
      for (final f in wire.FormularyStatus.values) {
        expect(formularyStatusOf(wire.FormularyDecision(status: f)),
            isNot(FormularyStatus.unrecognised),
            reason: 'no mapping for ${f.name}');
      }
      for (final t in wire.TherapyStatus.values) {
        expect(therapyStatusOf(wire.Prescription(therapyStatus: t)),
            isNot(TherapyStatus.unrecognised),
            reason: 'no mapping for ${t.name}');
      }
    });
  });

  group('adapting a prescription', () {
    test('the reason already recorded on a finding carries across', () {
      final finding = presentedFindingOf(wire.SafetyFinding(
        ruleId: 'r1',
        severity: wire.Severity.SEVERITY_SEVERE,
        override: wire.Override(by: 'dr1', reason: 'agreed at the MDT'),
      ));
      expect(finding.existingOverrideReason, 'agreed at the MDT');
      // Which is what stops the gate asking again for a reason already given.
      expect(safetyGate([finding], const []).state, SafetyState.clear);
    });

    test('the server composes the description, and it wins', () {
      final prescription = wire.Prescription(
        prescriptionId: 'rx1',
        description: 'Amoxicillin 500 mg oral',
        ingredient: wire.Coding(display: 'Something else'),
      );
      expect(describePrescription(prescription), 'Amoxicillin 500 mg oral');
    });

    test('a prescription with no description is still describable', () {
      final prescription = wire.Prescription(
        prescriptionId: 'rx1',
        ingredient: wire.Coding(code: 'AMX', display: 'Amoxicillin'),
        route: 'oral',
        segments: [
          wire.DoseSegment(
            sequence: 1,
            dose: wire.Quantity(value: 500, unit: 'mg'),
          ),
        ],
      );
      expect(describePrescription(prescription), 'Amoxicillin 500.0 mg oral');
    });

    test('a queue row carries the worst finding and whether it was overridden',
        () {
      final prescription = wire.Prescription(
        prescriptionId: 'rx1',
        patientId: 'p1',
        description: 'Warfarin 5 mg oral',
        createdAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16, 9)),
        findings: [
          wire.SafetyFinding(
            ruleId: 'r1',
            severity: wire.Severity.SEVERITY_MILD,
          ),
          wire.SafetyFinding(
            ruleId: 'r2',
            severity: wire.Severity.SEVERITY_SEVERE,
            override: wire.Override(by: 'dr1', reason: 'INR monitored daily'),
          ),
        ],
      );
      final entry = queueEntryOf(prescription);
      expect(entry.worstSeverity, Severity.severe);
      expect(entry.overridden, isTrue);
      // No verification message: unverified, which is the safe reading.
      expect(entry.verified, isFalse);
      expect(entry.createdAt, DateTime.utc(2026, 9, 16, 9));
    });

    test('a prescription with no formulary decision is not on formulary', () {
      final notice = formularyNoticeOf(wire.Prescription(prescriptionId: 'rx1'));
      expect(notice.status, FormularyStatus.unspecified);
      expect(notice.label, 'Formulary status not checked');
    });
  });
}
