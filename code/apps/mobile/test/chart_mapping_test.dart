import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/chart/mapping.dart';
import 'package:health_mobile/src/chart/notes.dart';
import 'package:health_mobile/src/chart/safety.dart';
import 'package:health_mobile/src/gen/healthcare/clinical/v1/clinical.pb.dart' as wire;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

/// Appends a varint field, the way a server on a newer contract would.
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
    test('an unreadable document status offers no action at all', () {
      // The dangerous fallback is the zero member, whose lifecycle this build
      // would then apply — and if that were ever mapped to draft it would put
      // an Edit button on a record nobody can interpret.
      final bytes = withVarintField(
        wire.Document(documentId: 'd1', title: 'Note').writeToBuffer(),
        documentStatusField,
        9999,
      );
      final document = documentOf(wire.Document.fromBuffer(bytes));
      expect(document.status, DocumentStatus.unrecognised);

      final actions = actionsFor(document, mayWrite: true);
      expect(actions.none, isTrue);
      expect(actions.edit, isFalse);
    });

    test('an unreadable signature meaning never finalises a note', () {
      // Finalising is what makes a note un-editable and clinically
      // attributed; guessing "author" would attribute it to somebody.
      final bytes = withVarintField(
        wire.Signature(subjectId: 's1').writeToBuffer(), 2, 9999,
      );
      expect(signatureMeaningOf(wire.Signature.fromBuffer(bytes)),
          SignatureMeaning.unrecognised);
      expect(finalises(SignatureMeaning.unrecognised), isFalse);
    });

    test('one unreadable signature does not cost the others', () {
      final document = wire.Document(
        documentId: 'd1',
        status: wire.DocumentStatus.DOCUMENT_STATUS_SIGNED,
        signatures: [
          wire.Signature(
            subjectId: 's1',
            meaning: wire.SignatureMeaning.SIGNATURE_MEANING_AUTHOR,
            signedAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16)),
          ),
        ],
      );
      final mapped = documentOf(document);
      expect(mapped.signatures, hasLength(1));
      expect(mapped.finalised, isTrue);
    });

    test('an unreadable criticality is not a low one', () {
      final bytes = withVarintField(
        wire.Allergy(allergyId: 'a1').writeToBuffer(),
        allergyCriticalityField,
        9999,
      );
      final allergy = allergyOf(wire.Allergy.fromBuffer(bytes));
      expect(allergy.criticality, Criticality.unrecognised);
      // The point: it stays in front of a prescriber.
      expect(allergy.prominent, isTrue);
    });

    test('an unreadable verification does not bury a live allergy', () {
      // Guessing "refuted" would move it into the historical section and out
      // of a prescriber's way, which is the worst available answer.
      final bytes = withVarintField(
        wire.Allergy(allergyId: 'a1').writeToBuffer(),
        allergyVerificationField,
        9999,
      );
      final allergy = allergyOf(wire.Allergy.fromBuffer(bytes));
      expect(allergy.verification, Verification.unrecognised);
      expect(allergy.historical, isFalse);
    });

    test('an unreadable interpretation does not claim a laboratory verdict', () {
      final bytes = withVarintField(
        wire.Observation(observationId: 'o1').writeToBuffer(),
        interpretationField,
        9999,
      );
      final observation = observationOf(wire.Observation.fromBuffer(bytes));
      expect(observation.interpretation, Interpretation.unrecognised);
      expect(observation.critical, isFalse);
      expect(observation.interpretationLabel, contains('Not interpreted'));
    });

    test('an unreadable problem status is neither active nor resolved', () {
      final bytes = withVarintField(
        wire.Problem(problemId: 'p1').writeToBuffer(),
        problemStatusField,
        9999,
      );
      final problem = problemOf(wire.Problem.fromBuffer(bytes));
      expect(problem.status, ProblemStatus.unrecognised);
      expect(problem.active, isFalse);
      expect(problem.historical, isFalse);
    });

    test('the field tags are the ones the contract actually uses', () {
      expect(wire.Document.getDefault().info_.byName['status']!.tagNumber,
          documentStatusField);
      final allergy = wire.Allergy.getDefault().info_;
      expect(allergy.byName['kind']!.tagNumber, allergyKindField);
      expect(allergy.byName['criticality']!.tagNumber, allergyCriticalityField);
      expect(allergy.byName['verification']!.tagNumber, allergyVerificationField);
      expect(wire.Problem.getDefault().info_.byName['status']!.tagNumber,
          problemStatusField);
      expect(
        wire.Observation.getDefault().info_.byName['interpretation']!.tagNumber,
        interpretationField,
      );
    });
  });

  group('observations', () {
    test('a measured zero is a result, not a missing value', () {
      // A platelet count of zero read as "no numeric value" is the result that
      // most needs to be on the trend, disappearing off it.
      final observation = observationOf(wire.Observation(
        observationId: 'o1',
        code: wire.Coding(display: 'Platelets'),
        value: wire.Quantity(value: 0, unit: '10^9/L'),
        effectiveAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16)),
      ));
      expect(observation.numericValue, 0);
      expect(observation.value, '0.0 10^9/L');
      expect(buildTrend([observation]).points, hasLength(1));
    });

    test('a text result carries its text and stays off the trend', () {
      final observation = observationOf(wire.Observation(
        observationId: 'o1',
        code: wire.Coding(display: 'Culture'),
        textValue: 'E. coli isolated',
        effectiveAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16)),
      ));
      expect(observation.value, 'E. coli isolated');
      expect(observation.numericValue, isNull);
      expect(buildTrend([observation]).points, isEmpty);
    });

    test('a reference range is used only when the server said it has one', () {
      // Otherwise two zeroes render as a range of "0–0", which reads as a
      // result outside its bounds.
      final none = observationOf(wire.Observation(
        observationId: 'o1',
        effectiveAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16)),
      ));
      expect(none.referenceRange, '');

      final some = observationOf(wire.Observation(
        observationId: 'o2',
        value: wire.Quantity(value: 7.4, unit: 'mmol/L'),
        hasReferenceRange: true,
        referenceLow: 4,
        referenceHigh: 6,
        effectiveAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16)),
      ));
      expect(some.referenceRange, '4.0–6.0 mmol/L');
    });
  });

  group('codings', () {
    test('a substance with no display text falls back to its code', () {
      // Worse to read and far better than a blank row on the panel a
      // prescriber checks.
      final allergy = allergyOf(wire.Allergy(
        allergyId: 'a1',
        substance: wire.Coding(code: 'N02BE01'),
      ));
      expect(allergy.substance, 'N02BE01');
    });

    test('a problem with a display uses it', () {
      final problem = problemOf(wire.Problem(
        problemId: 'p1',
        code: wire.Coding(code: 'E11', display: 'Type 2 diabetes'),
        status: wire.ProblemStatus.PROBLEM_STATUS_ACTIVE,
      ));
      expect(problem.display, 'Type 2 diabetes');
      expect(problem.code, 'E11');
    });

    test('an absent onset is absent, not the epoch', () {
      final problem = problemOf(wire.Problem(
        problemId: 'p1',
        status: wire.ProblemStatus.PROBLEM_STATUS_ACTIVE,
      ));
      expect(problem.onsetAt, isNull);
      expect(problem.resolvedAt, isNull);
    });
  });

  group('documents', () {
    test('every status the contract defines maps to something usable', () {
      for (final status in wire.DocumentStatus.values) {
        final mapped = documentStatusOf(wire.Document(status: status));
        expect(mapped, isNot(DocumentStatus.unrecognised),
            reason: 'no mapping for ${status.name}');
      }
    });

    test('every signature meaning the contract defines maps', () {
      for (final meaning in wire.SignatureMeaning.values) {
        final mapped = signatureMeaningOf(wire.Signature(meaning: meaning));
        expect(mapped, isNot(SignatureMeaning.unrecognised),
            reason: 'no mapping for ${meaning.name}');
      }
    });

    test('intact travels as the server set it', () {
      expect(documentOf(wire.Document(documentId: 'd1', intact: true)).intact,
          isTrue);
      expect(documentOf(wire.Document(documentId: 'd1', intact: false)).intact,
          isFalse);
    });
  });
}
