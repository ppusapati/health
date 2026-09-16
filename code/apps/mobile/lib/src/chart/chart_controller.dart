/// Loading the chart, signing and correcting.
library;

import '../api/api_error.dart';
import '../api/clinical_client.dart';
import '../gen/healthcare/clinical/v1/clinical.pb.dart' as wire;
import '../screens/chart_screen.dart';
import 'mapping.dart';
import 'notes.dart';

class ChartController {
  ChartController(this._clinical);

  final ClinicalClient _clinical;

  ChartView? _view;
  String? _failure;
  bool _loading = false;

  ChartView? get view => _view;
  String? get failure => _failure;
  bool get loading => _loading;

  /// Loads the four panels for one patient.
  ///
  /// Issued together. A chart drawn from four responses arriving over several
  /// seconds shows allergies against a problem list from a different moment,
  /// and the gap is exactly where a clinician reads one and acts on the other.
  Future<void> load({
    required String patientId,
    String encounterId = '',
    required bool mayWrite,
  }) async {
    _loading = true;
    try {
      final allergiesRequest = _clinical.listAllergies(patientId: patientId);
      final problemsRequest = _clinical.listProblems(patientId: patientId);
      final observationsRequest = _clinical.listObservations(
          patientId: patientId, encounterId: encounterId);
      final notesRequest = _clinical.listNotes(
          patientId: patientId, encounterId: encounterId);

      final allergies = await allergiesRequest;
      final problems = await problemsRequest;
      final observations = await observationsRequest;
      final notes = await notesRequest;

      _view = ChartView(
        allergies: [for (final a in allergies.allergies) allergyOf(a)],
        problems: [for (final p in problems.problems) problemOf(p)],
        observations: [
          for (final o in observations.observations) observationOf(o),
        ],
        documents: [for (final d in notes.documents) documentOf(d)],
        mayWrite: mayWrite,
      );
      _failure = null;
    } on ApiError catch (error) {
      _failure = error.message;
      // Whatever was on screen stays. A clinician mid-round with a flaky
      // connection still needs the allergies they were reading, and a blank
      // panel would read as "none recorded".
    } finally {
      _loading = false;
    }
  }

  /// Signs a note as its author.
  Future<bool> sign(ChartDocument document) async {
    try {
      await _clinical.signNote(
        documentId: document.documentId,
        meaning: wire.SignatureMeaning.SIGNATURE_MEANING_AUTHOR,
      );
      _failure = null;
      return true;
    } on ApiError catch (error) {
      // Including the server's own refusal to sign something already signed,
      // which is it telling this screen it was stale.
      _failure = error.message;
      return false;
    }
  }

  /// Amends or adds to a note.
  ///
  /// The reason is required for an amendment and refused here before the
  /// request, because the server's refusal arrives after the clinician has
  /// typed the correction and is the worst moment to lose it.
  Future<bool> correct({
    required ChartDocument document,
    required CorrectionKind kind,
    required String title,
    required List<DraftSection> sections,
    String reason = '',
  }) async {
    final guidance = describeCorrection(kind);
    if (guidance.reasonRequired && reason.trim().isEmpty) {
      _failure = 'Say why this note is being corrected. The next reader needs '
          'to know whether the original was a slip or a change of view.';
      return false;
    }

    try {
      await _clinical.amendNote(
        documentId: document.documentId,
        title: title,
        sections: [
          for (final s in sections)
            wire.Section(heading: s.heading, text: s.text),
        ],
        addendum: kind == CorrectionKind.addendum,
        reason: reason,
      );
      _failure = null;
      return true;
    } on ApiError catch (error) {
      _failure = error.message;
      return false;
    }
  }
}
