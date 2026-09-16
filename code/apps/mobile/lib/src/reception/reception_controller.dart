/// Loading the board, searching, acknowledging and registering.
///
/// Holds the search-before-create state, because it is state: the gate is a
/// function of what was searched and what has been acknowledged, and both
/// belong to the desk's session rather than to a widget that can be rebuilt.
library;

import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

import '../api/api_error.dart';
import '../api/empi_client.dart';
import '../api/scheduling_client.dart';
import '../gen/healthcare/empi/v1/patient.pb.dart' as empi;
import '../screens/reception_screen.dart';
import 'board.dart';
import 'mapping.dart';
import 'search.dart';

class ReceptionController {
  /// Positional because a named parameter cannot be a private initializing
  /// formal. The clock is injected so a test can hold time still, which a
  /// board whose whole point is staleness needs.
  ReceptionController(this._scheduling, this._empi, this._now);

  final SchedulingClient _scheduling;
  final EmpiClient _empi;
  final DateTime Function() _now;

  Board? _board;
  List<PresentedMatch> _matches = const [];
  final List<String> _acknowledged = [];
  bool _searched = false;
  String _searchProblem = '';
  String? _failure;
  bool _loading = false;

  ReceptionView? _view;

  ReceptionView? get view => _view;
  String? get failure => _failure;
  bool get loading => _loading;

  void _rebuild() {
    final board = _board;
    if (board == null) {
      return;
    }
    _view = ReceptionView(
      board: board,
      matches: _matches,
      acknowledged: List.unmodifiable(_acknowledged),
      searched: _searched,
      searchProblem: _searchProblem,
    );
  }

  /// Fetches the queue and the day's appointments together.
  ///
  /// Together, not one or the other: the queue holds who has arrived and the
  /// appointment list holds who has not, and a board built from the queue
  /// alone shows an empty clinic at nine in the morning.
  Future<void> loadBoard({required String facilityId}) async {
    _loading = true;
    try {
      final now = _now();
      final startOfDay = DateTime.utc(now.year, now.month, now.day);
      // Issued together rather than in sequence: the two halves describe the
      // same moment, and a board whose queue is a round trip older than its
      // appointment list reports an age that is true of neither.
      final queueRequest = _scheduling.getQueue(facilityId: facilityId);
      final expectedRequest = _scheduling.listAppointments(
        facilityId: facilityId,
        from: startOfDay,
        until: startOfDay.add(const Duration(days: 1)),
      );
      final queue = await queueRequest;
      final appointments = await expectedRequest;

      _board = buildBoard(
        positions: [
          for (final p in queue.positions) positionOf(p),
        ],
        expected: [
          for (final a in appointments.appointments) appointmentOf(a),
        ],
        // The moment the response arrived, not the moment it is drawn: the
        // age this reports has to be the age of the data.
        fetchedAt: _now(),
        now: _now(),
        serviceMinutes:
            queue.hasEstimate() ? queue.estimate.serviceMinutes.round() : null,
        estimateObserved: queue.hasEstimate() && queue.estimate.observed,
        activeClinicians:
            queue.hasEstimate() ? queue.estimate.activeClinicians : 0,
      );
      _failure = null;
      _rebuild();
    } on ApiError catch (error) {
      _failure = error.message;
      _rebuild();
    } finally {
      _loading = false;
    }
  }

  /// Re-reads the board against the current clock without refetching.
  ///
  /// What makes the staleness line move while nobody is touching the screen.
  void tick() {
    final board = _board;
    if (board == null) {
      return;
    }
    _rebuild();
  }

  /// Runs a search, if it may be run.
  ///
  /// A refused search does not set [searched], so the gate stays shut: a
  /// search that never ran is not a search that found nothing.
  Future<void> search(SearchCriteria criteria) async {
    final validity = validateSearch(criteria);
    if (!validity.runnable) {
      _searchProblem = validity.message;
      _rebuild();
      return;
    }

    _searchProblem = '';
    _loading = true;
    try {
      final response = await _empi.searchPatients(
        name: criteria.name.trim(),
        phone: criteria.phone.trim(),
        identifierValue: criteria.identifierValue.trim(),
        birthDate: _partialDate(criteria.birthDate),
      );
      _matches = [for (final m in response.matches) matchOf(m)];
      // A new search clears every acknowledgement. A stale one would unlock
      // the gate for a different set of candidates entirely — the receptionist
      // said "somebody else" about people who are no longer on screen.
      _acknowledged.clear();
      _searched = true;
      _failure = null;
      _rebuild();
    } on ApiError catch (error) {
      _failure = error.message;
      // Deliberately not setting _searched: a search that failed is not a
      // search that came back empty, and only one of those opens the gate.
      _rebuild();
    } finally {
      _loading = false;
    }
  }

  /// Records that the user looked at a candidate and said it is somebody else.
  void acknowledge(String patientId) {
    if (!_acknowledged.contains(patientId)) {
      _acknowledged.add(patientId);
    }
    _rebuild();
  }

  /// Registers, naming the candidates that were acknowledged.
  ///
  /// The gate is checked here as well as drawn on screen, because a screen is
  /// not a control. The server checks it a third time, and that one is.
  Future<empi.Patient?> register({
    required empi.Demographics demographics,
    List<empi.PatientIdentifier> identifiers = const [],
  }) async {
    final gate = registrationGate(
      searched: _searched,
      matches: _matches,
      acknowledged: _acknowledged,
    );
    if (!gate.mayRegister) {
      _failure = gate.message;
      _rebuild();
      return null;
    }

    try {
      final response = await _empi.registerPatient(
        demographics: demographics,
        identifiers: identifiers,
        acknowledgedDuplicatePatientIds: List.of(_acknowledged),
      );
      _failure = null;
      _rebuild();
      return response.patient;
    } on ApiError catch (error) {
      _failure = error.message;
      _rebuild();
      return null;
    }
  }

  /// Checks a patient in and reloads the board.
  Future<void> checkIn({
    required String appointmentId,
    required String facilityId,
  }) async {
    try {
      await _scheduling.checkIn(appointmentId: appointmentId);
      _failure = null;
    } on ApiError catch (error) {
      // Including the refusal of a second check-in, which is the server
      // telling this screen it was stale rather than an error to hide.
      _failure = error.message;
      _rebuild();
      return;
    }
    await loadBoard(facilityId: facilityId);
  }

  /// Parses the typed date, or returns null when there is nothing to parse.
  ///
  /// A date that cannot be read is sent as no date rather than as a wrong one:
  /// the search then returns more candidates, which is the safe direction.
  empi.PartialDate? _partialDate(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final parsed = DateTime.tryParse('${trimmed}T00:00:00Z');
    if (parsed == null) {
      return null;
    }
    return empi.PartialDate(
      date: Timestamp.fromDateTime(parsed.toUtc()),
      precision: empi.DatePrecision.DATE_PRECISION_DAY,
    );
  }
}
