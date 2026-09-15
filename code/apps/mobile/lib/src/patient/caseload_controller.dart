/// Loading the caseload, resolving a scan, and searching.
library;

import '../api/api_error.dart';
import '../api/empi_client.dart';
import '../api/nursing_client.dart';
import '../gen/healthcare/empi/v1/patient.pb.dart' as empi;
import '../gen/healthcare/nursing/v1/nursing.pb.dart' as wire;
import '../screens/patient_picker_screen.dart';
import 'caseload.dart';

class CaseloadController {
  CaseloadController(this._nursing, this._empi);

  final NursingClient _nursing;
  final EmpiClient _empi;

  List<CaseloadPatient> _caseload = const [];
  List<CaseloadPatient> _results = const [];
  bool _searched = false;
  String _scanProblem = '';
  String? _failure;
  bool _loading = false;

  CaseloadView? _view;

  CaseloadView? get view => _view;
  String? get failure => _failure;
  bool get loading => _loading;

  void _rebuild() {
    _view = CaseloadView(
      patients: _caseload,
      scanProblem: _scanProblem,
      searchResults: _results,
      searched: _searched,
    );
  }

  /// Loads the patients assigned to this nurse.
  Future<void> load({required String nurseId, String unitId = ''}) async {
    _loading = true;
    try {
      final response =
          await _nursing.listAssignments(nurseId: nurseId, unitId: unitId);
      _caseload = orderCaseload(
        response.assignments.map(_fromAssignment).toList(growable: false),
      );
      _failure = null;
      _rebuild();
    } on ApiError catch (error) {
      _failure = error.message;
      // The caseload already on screen is kept: a nurse mid-round with a
      // flaky connection still needs the list they were walking.
      _rebuild();
    } finally {
      _loading = false;
    }
  }

  /// Resolves a scanned wristband.
  ///
  /// The lookup asks for two matches, not one, so a duplicated identifier is
  /// visible as a duplicate rather than arriving as a clean single result. What
  /// to do about that is `resolveScan`'s decision, and it refuses.
  Future<PatientSelection?> scan(String barcode) async {
    _scanProblem = '';
    try {
      final response =
          await _empi.findByIdentifier(identifierValue: barcode.trim());
      final matches = response.matches
          .map((match) => _fromPatient(match.patient))
          .toList(growable: false);

      final resolution = resolveScan(barcode: barcode, matches: matches);
      _scanProblem = resolution.problem;
      _rebuild();
      return resolution.selection;
    } on ApiError catch (error) {
      _scanProblem = error.message;
      _rebuild();
      return null;
    }
  }

  /// Searches by name, for a band that cannot be read.
  Future<void> search(String name) async {
    if (name.trim().isEmpty) {
      _results = const [];
      _searched = false;
      _rebuild();
      return;
    }
    try {
      final response = await _empi.searchByName(name: name.trim());
      _results = response.matches
          .map((match) => _fromPatient(match.patient))
          .toList(growable: false);
      _searched = true;
      _failure = null;
    } on ApiError catch (error) {
      _failure = error.message;
      _results = const [];
      _searched = true;
    }
    _rebuild();
  }

  /// One assignment as a caseload row.
  ///
  /// The counts are left at zero here. The alternative is a worklist call per
  /// patient before the list can be drawn, which on a twelve-bed bay is twelve
  /// round trips before a nurse sees anything; the screen shows what it knows
  /// and the per-patient detail arrives when a patient is opened.
  CaseloadPatient _fromAssignment(wire.NurseAssignment assignment) =>
      CaseloadPatient(
        patientId: assignment.patientId,
        // The assignment names a bed, not an encounter. The encounter is
        // resolved when the patient is opened, so an assignment left behind by
        // a discharge cannot put a stale encounter on screen.
        encounterId: '',
        displayName: assignment.patientId,
        bed: assignment.bedId,
        unit: assignment.unitId,
        outstandingTasks: 0,
        dosesDue: 0,
        hasHighCriticalityAllergy: false,
      );

  CaseloadPatient _fromPatient(empi.Patient patient) {
    final name = [
      patient.demographics.name.given.join(' '),
      patient.demographics.name.family,
    ].where((part) => part.trim().isNotEmpty).join(' ');

    return CaseloadPatient(
      patientId: patient.patientId,
      encounterId: '',
      displayName: name.isEmpty
          ? (patient.designation.label.isEmpty
              ? 'Name not recorded'
              : patient.designation.label)
          : name,
      bed: '',
      unit: '',
      outstandingTasks: 0,
      dosesDue: 0,
      hasHighCriticalityAllergy: false,
    );
  }
}
