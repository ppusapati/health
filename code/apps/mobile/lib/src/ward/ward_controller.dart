/// Fetching the ward worklist and recording against it.
///
/// The screen renders a finished view and the logic modules decide what is in
/// it; this is the piece in between that talks to the server. It exists as its
/// own object rather than as state inside the widget so the mapping from wire
/// types to presented ones can be tested without pumping anything, and so the
/// widget stays a function of its input.
library;

import '../api/api_error.dart';
import '../api/nursing_client.dart';
import '../gen/healthcare/nursing/v1/nursing.pb.dart' as wire;
import '../screens/ward_worklist_screen.dart';
import '../patient/banner.dart';
import 'worklist.dart';

/// Reads the worklist and records completions.
class WardController {
  /// Positional because a named parameter cannot be a private initializing
  /// formal, and assigning private fields from same-named named parameters is
  /// what `prefer_initializing_formals` objects to. The clock and the key
  /// factory are injected so a test can hold time still and mint predictable
  /// keys.
  WardController(this._nursing, this._now, this._newIdempotencyKey);

  final NursingClient _nursing;
  final DateTime Function() _now;
  final String Function() _newIdempotencyKey;

  WardWorklistView? _view;
  String? _failure;
  bool _loading = false;

  WardWorklistView? get view => _view;

  /// A message safe for a screen — never a raw server string.
  String? get failure => _failure;

  bool get loading => _loading;

  /// Loads the work outstanding for one encounter.
  ///
  /// A failure keeps whatever was already on screen. The rows are still the
  /// best information available, and throwing them away to show an error
  /// helps nobody.
  Future<void> load({
    required String encounterId,
    PatientBanner? banner,
  }) async {
    _loading = true;
    try {
      final response = await _nursing.getWorklist(encounterId: encounterId);
      final tasks = response.tasks
          .map((task) => _present(task))
          .toList(growable: false);

      _view = WardWorklistView(
        banner: banner ?? _view?.banner,
        tasks: orderTasks(tasks),
        summary: summarise(tasks),
      );
      _failure = null;
    } on ApiError catch (error) {
      _failure = error.message;
    } finally {
      _loading = false;
    }
  }

  /// Records a task as done.
  ///
  /// The idempotency key is minted before the call, so a retry after a lost
  /// response closes the same task rather than being refused as a conflict.
  /// The worklist is reloaded afterwards rather than adjusted locally: the
  /// server may have escalated something else in the meantime, and a locally
  /// patched list would hide it.
  Future<bool> complete({
    required PresentedTask task,
    required String evidence,
    required String encounterId,
  }) async {
    try {
      await _nursing.completeTask(
        taskId: task.taskId,
        evidence: evidence,
        idempotencyKey: _newIdempotencyKey(),
      );
    } on ApiError catch (error) {
      _failure = error.message;
      return false;
    }
    await load(encounterId: encounterId);
    return true;
  }

  /// Charts an observation.
  Future<bool> chart({
    required String patientId,
    required String encounterId,
    required wire.Coding code,
    required DateTime observedAt,
    double? value,
    String unit = '',
    String textValue = '',
    String lateEntryReason = '',
  }) async {
    try {
      await _nursing.chartObservation(
        patientId: patientId,
        encounterId: encounterId,
        code: code,
        observedAt: observedAt,
        // Typed by a person at a bedside. Not a device reading, and saying so
        // is what lets a reviewer tell the two apart.
        source: wire.EntrySource.ENTRY_SOURCE_MANUAL,
        value: value == null ? null : wire.Quantity(value: value, unit: unit),
        textValue: textValue,
        lateEntryReason: lateEntryReason,
        idempotencyKey: _newIdempotencyKey(),
      );
    } on ApiError catch (error) {
      _failure = error.message;
      return false;
    }
    await load(encounterId: encounterId);
    return true;
  }

  PresentedTask _present(wire.NursingTask task) => presentTask(
        taskId: task.taskId,
        patientId: task.patientId,
        description: task.description,
        priority: _priority(task.priority),
        status: _status(task.status),
        dueAt: task.hasDueAt() ? task.dueAt.toDateTime().toUtc() : null,
        // From the server. The device clock does not get a say — see
        // `presentTask`.
        overdue: task.overdue,
        escalatedTo: task.escalatedTo,
        sourceKind: task.sourceKind,
        version: task.version.toInt(),
        now: _now(),
      );
}

TaskPriority _priority(wire.TaskPriority priority) => switch (priority) {
      wire.TaskPriority.TASK_PRIORITY_CRITICAL => TaskPriority.critical,
      wire.TaskPriority.TASK_PRIORITY_URGENT => TaskPriority.urgent,
      wire.TaskPriority.TASK_PRIORITY_ROUTINE => TaskPriority.routine,
      // A priority this build does not know is shown as unprioritised rather
      // than guessed at. Guessing downwards hides work; guessing upwards
      // floods the top of the list.
      _ => TaskPriority.unspecified,
    };

TaskStatus _status(wire.TaskStatus status) => switch (status) {
      wire.TaskStatus.TASK_STATUS_PENDING => TaskStatus.pending,
      wire.TaskStatus.TASK_STATUS_DONE => TaskStatus.done,
      wire.TaskStatus.TASK_STATUS_NOT_DONE => TaskStatus.notDone,
      wire.TaskStatus.TASK_STATUS_CANCELLED => TaskStatus.cancelled,
      // Unknown is not "open". A task this build cannot classify must not be
      // offered a Record button that sends something meaningless.
      _ => TaskStatus.unspecified,
    };
