/// Choosing a patient on a ward device.
///
/// Two things carry real weight here: beds ordering the way a nurse walks them,
/// and a scan being a different kind of selection from a tap.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/patient/caseload.dart';

CaseloadPatient patient({
  String id = 'p1',
  String name = 'Asha Rao',
  String bed = 'Bed 1',
  String unit = 'Ward A',
  int tasks = 0,
  int doses = 0,
  bool allergy = false,
}) =>
    CaseloadPatient(
      patientId: id,
      encounterId: 'enc-$id',
      displayName: name,
      bed: bed,
      unit: unit,
      outstandingTasks: tasks,
      dosesDue: doses,
      hasHighCriticalityAllergy: allergy,
    );

void main() {
  group('ordering the round', () {
    test('beds are walked in numeric order, not alphabetical', () {
      // "Bed 10" between "Bed 1" and "Bed 2" is what a plain string sort does,
      // and it is how somebody walks past a patient.
      final ordered = orderCaseload([
        patient(id: 'a', bed: 'Bed 10'),
        patient(id: 'b', bed: 'Bed 2'),
        patient(id: 'c', bed: 'Bed 1'),
      ]);

      expect(ordered.map((p) => p.bed), ['Bed 1', 'Bed 2', 'Bed 10']);
    });

    test('units group before beds', () {
      final ordered = orderCaseload([
        patient(id: 'a', unit: 'Ward B', bed: 'Bed 1'),
        patient(id: 'b', unit: 'Ward A', bed: 'Bed 9'),
      ]);

      expect(ordered.map((p) => p.unit), ['Ward A', 'Ward B']);
    });

    test('mixed labels still sort sensibly', () {
      final ordered = orderCaseload([
        patient(id: 'a', bed: 'Bay 2 Bed 1'),
        patient(id: 'b', bed: 'Bay 1 Bed 12'),
        patient(id: 'c', bed: 'Bay 1 Bed 2'),
      ]);

      expect(ordered.map((p) => p.bed),
          ['Bay 1 Bed 2', 'Bay 1 Bed 12', 'Bay 2 Bed 1']);
    });

    test('a patient with no bed sorts last rather than first', () {
      // A missing bed is a data problem. Burying it at the top of the round
      // would be worse than leaving it visible at the bottom.
      final ordered = orderCaseload([
        patient(id: 'a', bed: ''),
        patient(id: 'b', bed: 'Bed 3'),
      ]);

      expect(ordered.first.bed, 'Bed 3');
      expect(ordered.last.bed, '');
    });

    test('bed comparison is a total order', () {
      expect(compareBeds('Bed 1', 'Bed 1'), 0);
      expect(compareBeds('Bed 1', 'Bed 2'), lessThan(0));
      expect(compareBeds('Bed 2', 'Bed 1'), greaterThan(0));
      expect(compareBeds('', ''), 0);
    });

    test('ordering does not mutate the list it was given', () {
      final original = [patient(id: 'b', bed: 'Bed 9'), patient(id: 'a', bed: 'Bed 1')];
      orderCaseload(original);
      expect(original.map((p) => p.patientId), ['b', 'a']);
    });
  });

  group('what a row shows', () {
    test('a patient with nothing outstanding says so', () {
      expect(patient().hasWork, isFalse);
    });

    test('tasks or doses both count as work', () {
      expect(patient(tasks: 2).hasWork, isTrue);
      expect(patient(doses: 1).hasWork, isTrue);
    });
  });

  group('how a patient was chosen', () {
    test('picking off the caseload does not verify identity', () {
      // Picking the right name off a list is not the same as having checked
      // the band on the arm.
      final selection = patient().select();

      expect(selection.method, SelectionMethod.caseload);
      expect(selection.identityVerified, isFalse);
    });

    test('scanning a band does verify identity', () {
      final resolution =
          resolveScan(barcode: 'band-123', matches: [patient(id: 'p9')]);

      expect(resolution.resolved, isTrue);
      expect(resolution.selection!.method, SelectionMethod.scan);
      expect(resolution.selection!.identityVerified, isTrue);
      // Carried through, so the administration records the barcode the nurse
      // actually read rather than a re-derived one.
      expect(resolution.selection!.scannedIdentifier, 'band-123');
    });

    test('a search does not verify identity either', () {
      const found = PatientSelection(
        patientId: 'p1',
        encounterId: 'enc-1',
        displayName: 'Asha Rao',
        method: SelectionMethod.search,
      );
      expect(found.identityVerified, isFalse);
    });

    test('the selection carries where the patient is', () {
      final selection = patient(bed: 'Bed 4', unit: 'Ward A').select();
      expect(selection.bed, 'Bed 4');
      expect(selection.unit, 'Ward A');
    });
  });

  group('resolving a scan', () {
    test('a band nothing matches is reported, not turned into a search', () {
      // A scan that silently becomes a search is how the wrong patient gets
      // picked.
      final resolution = resolveScan(barcode: 'band-999', matches: []);

      expect(resolution.resolved, isFalse);
      expect(resolution.problem, contains('band-999'));
      expect(resolution.problem, contains('Check the band'));
    });

    test('a band matching more than one patient is refused outright', () {
      // A duplicate identifier is a data fault, and a bedside is the worst
      // place to resolve one by guessing.
      final resolution = resolveScan(
        barcode: 'band-dup',
        matches: [patient(id: 'a'), patient(id: 'b')],
      );

      expect(resolution.resolved, isFalse);
      expect(resolution.problem, contains('Do not proceed'));
      expect(resolution.problem, contains('ward clerk'));
    });

    test('an empty scan is not a match for everybody', () {
      final resolution = resolveScan(barcode: '  ', matches: [patient()]);
      expect(resolution.resolved, isFalse);
      expect(resolution.problem, 'Nothing was scanned.');
    });

    test('a resolved scan keeps the patient and encounter it found', () {
      final resolution = resolveScan(
        barcode: 'band-1',
        matches: [patient(id: 'p42', name: 'Meera Iyer')],
      );

      expect(resolution.selection!.patientId, 'p42');
      expect(resolution.selection!.encounterId, 'enc-p42');
      expect(resolution.selection!.displayName, 'Meera Iyer');
    });
  });
}
