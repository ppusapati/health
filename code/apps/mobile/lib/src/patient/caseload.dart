/// Choosing a patient on a ward device (SRS-NUR-017, SRS-EMPI-002).
///
/// The design question this answers, and the answer it gives:
///
/// **A round is worked from the nurse's own caseload, in bed order.** That is
/// the default and it is what the screen opens on. A list of every patient in
/// the hospital is not a picker, it is a search box with extra steps, and on a
/// round the nurse already knows who they are going to see.
///
/// **Scanning a wristband is the way off that list.** Covering somebody else's
/// bay, a patient who moved beds, a patient admitted since the shift started —
/// all of them are reached by scanning, because scanning is the same action
/// that verifies identity at the bedside anyway.
///
/// **Searching is the fallback**, for a band that is missing or unreadable.
///
/// One thing falls out of that and is worth stating loudly: **a patient reached
/// by scanning has been verified, and a patient picked off a list has not.**
/// The medication round's barcode gate wants a patient scan; a patient chosen
/// *by* scanning has already supplied one, and the two facts are the same fact.
/// So the selection carries how it was made, and the round can tell.
library;

import 'package:meta/meta.dart';

/// How a patient came to be selected.
enum SelectionMethod {
  /// Picked from the nurse's assigned caseload.
  caseload,

  /// Reached by scanning a wristband. Identity is verified by the scan.
  scan,

  /// Found by searching. Identity is not verified — the search matched a
  /// record, which is not the same as matching the person in the bed.
  search,
}

/// A patient chosen, and how.
@immutable
class PatientSelection {
  const PatientSelection({
    required this.patientId,
    required this.encounterId,
    required this.displayName,
    required this.method,
    this.bed = '',
    this.unit = '',
    this.scannedIdentifier = '',
  });

  final String patientId;
  final String encounterId;
  final String displayName;
  final SelectionMethod method;
  final String bed;
  final String unit;

  /// What was actually scanned, when it was a scan. Carried through so the
  /// administration's verification records the same barcode the nurse read,
  /// rather than a re-derived one.
  final String scannedIdentifier;

  /// Whether choosing this patient verified who they are.
  ///
  /// Only a scan does. Picking the right name off a list is not the same as
  /// having checked the band on the arm, and a screen that treated them alike
  /// would quietly satisfy a control that exists precisely because people pick
  /// the wrong row.
  bool get identityVerified => method == SelectionMethod.scan;
}

/// One patient on the caseload.
@immutable
class CaseloadPatient {
  const CaseloadPatient({
    required this.patientId,
    required this.encounterId,
    required this.displayName,
    required this.bed,
    required this.unit,
    required this.outstandingTasks,
    required this.dosesDue,
    required this.hasHighCriticalityAllergy,
  });

  final String patientId;
  final String encounterId;
  final String displayName;
  final String bed;
  final String unit;

  /// How much is outstanding. Shown on the row so the round can be planned
  /// from the list rather than by opening every patient in turn.
  final int outstandingTasks;
  final int dosesDue;

  final bool hasHighCriticalityAllergy;

  bool get hasWork => outstandingTasks > 0 || dosesDue > 0;

  /// The selection this row produces.
  PatientSelection select() => PatientSelection(
        patientId: patientId,
        encounterId: encounterId,
        displayName: displayName,
        method: SelectionMethod.caseload,
        bed: bed,
        unit: unit,
      );
}

/// Orders a caseload the way a nurse walks it.
///
/// By unit, then by bed, and beds are compared with their numbers read as
/// numbers. "Bed 10" sorting between "Bed 1" and "Bed 2" is the kind of thing
/// that makes somebody walk past a patient, and it is what a plain string sort
/// does.
List<CaseloadPatient> orderCaseload(List<CaseloadPatient> patients) {
  final ordered = [...patients];
  ordered.sort((a, b) {
    final byUnit = a.unit.toLowerCase().compareTo(b.unit.toLowerCase());
    if (byUnit != 0) return byUnit;
    return compareBeds(a.bed, b.bed);
  });
  return ordered;
}

/// Compares two bed labels, reading digit runs as numbers.
///
/// A bed with no label sorts last: it is a data problem, and burying it at the
/// top of the round would be worse than leaving it at the bottom where it is
/// visible as an oddity.
int compareBeds(String a, String b) {
  if (a.trim().isEmpty && b.trim().isEmpty) return 0;
  if (a.trim().isEmpty) return 1;
  if (b.trim().isEmpty) return -1;

  final left = _chunks(a);
  final right = _chunks(b);

  for (var i = 0; i < left.length && i < right.length; i++) {
    final l = left[i];
    final r = right[i];

    final lNumber = int.tryParse(l);
    final rNumber = int.tryParse(r);

    final int comparison;
    if (lNumber != null && rNumber != null) {
      comparison = lNumber.compareTo(rNumber);
    } else {
      comparison = l.toLowerCase().compareTo(r.toLowerCase());
    }
    if (comparison != 0) return comparison;
  }
  return left.length.compareTo(right.length);
}

/// Splits a label into runs of digits and runs of everything else.
List<String> _chunks(String value) {
  final chunks = <String>[];
  final buffer = StringBuffer();
  bool? bufferIsDigits;

  for (final rune in value.trim().runes) {
    final char = String.fromCharCode(rune);
    final isDigit = rune >= 0x30 && rune <= 0x39;

    if (bufferIsDigits != null && isDigit != bufferIsDigits) {
      chunks.add(buffer.toString());
      buffer.clear();
    }
    buffer.write(char);
    bufferIsDigits = isDigit;
  }
  if (buffer.isNotEmpty) chunks.add(buffer.toString());
  return chunks;
}

/// What a scanned barcode turned out to be.
@immutable
class ScanResolution {
  const ScanResolution({
    required this.selection,
    required this.problem,
  });

  /// The patient, when the scan found exactly one.
  final PatientSelection? selection;

  /// What to tell the nurse, when it did not.
  final String problem;

  bool get resolved => selection != null;
}

/// Turns a wristband scan into a selection.
///
/// [matches] is what the identifier search returned. The rules:
///
///   * exactly one match is the patient;
///   * none means the band is not one this system issued, or the patient is
///     not registered here — either way the nurse is told, not handed a
///     search box, because a scan that silently becomes a search is how the
///     wrong patient gets picked;
///   * more than one is refused. A duplicate identifier is a data fault, and
///     resolving it by guessing at a bedside is the worst place to do it.
ScanResolution resolveScan({
  required String barcode,
  required List<CaseloadPatient> matches,
}) {
  if (barcode.trim().isEmpty) {
    return const ScanResolution(
      selection: null,
      problem: 'Nothing was scanned.',
    );
  }
  if (matches.isEmpty) {
    return ScanResolution(
      selection: null,
      problem: 'No patient here has the band $barcode. '
          'Check the band, or find the patient by name.',
    );
  }
  if (matches.length > 1) {
    return ScanResolution(
      selection: null,
      problem: 'More than one patient has the band $barcode. '
          'Do not proceed from this band — tell the ward clerk.',
    );
  }

  final match = matches.single;
  return ScanResolution(
    selection: PatientSelection(
      patientId: match.patientId,
      encounterId: match.encounterId,
      displayName: match.displayName,
      method: SelectionMethod.scan,
      bed: match.bed,
      unit: match.unit,
      scannedIdentifier: barcode.trim(),
    ),
    problem: '',
  );
}
