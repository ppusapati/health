/// The reception board (UX-W1-01, SRS-SCH-007 … SRS-SCH-011).
///
/// What a receptionist actually looks at: who has arrived, who is still
/// expected, where each person is in the queue, and how long they have been
/// waiting. The server owns the queue and its estimates (SRS-SCH-009); this
/// turns that into rows and decides what the screen is allowed to imply.
///
/// Two of those decisions matter more than they look.
///
/// A board is a snapshot, and a stale snapshot is worse than a blank one. The
/// numbers change continuously as people are called through, and a
/// receptionist reading a five-minute-old position as current tells a patient
/// something untrue. So staleness is computed and shown rather than left to a
/// polling interval nobody can see. On a tablet this is sharper still: the
/// device goes in a pocket mid-shift and comes back out showing whatever it
/// was showing, with no tab switch or window focus to hint that time passed.
///
/// Waiting time is measured from arrival, not from the appointment. A patient
/// who arrived an hour early has not been waiting an hour, and a patient whose
/// appointment was at nine and who arrived at ten has been waiting since ten.
/// Measuring from the scheduled time produces a board that sorts the wrong
/// people to the top.
library;

import 'package:meta/meta.dart';

import '../prefs/views.dart';

/// Mirrors scheduling.v1.AppointmentStatus.
enum QueueStatus {
  scheduled,
  arrived,
  triaged,
  waitingClinician,
  inConsultation,
  postConsultation,
  completed,
  noShow,
  cancelled,

  /// Not a wire value: what the mapping produces for a status this build has
  /// no meaning for. Treated as neither present nor actionable, so an
  /// unreadable row never offers a check-in.
  unrecognised,
}

/// Mirrors scheduling.v1.Priority.
enum QueuePriority {
  immediate,
  veryUrgent,
  urgent,
  standard,
  nonUrgent,

  /// Not a wire value. Ranked with standard rather than at either extreme:
  /// inventing urgency is as wrong as burying it, and the label is the part
  /// that actually helps — it says the app is behind the server.
  unrecognised,
}

/// Mirrors scheduling.v1.ArrivalMode.
enum ArrivalMode {
  walkIn,
  scheduled,
  ambulance,
  referral,
  telehealth,

  /// Not a wire value. Cosmetic here: how somebody arrived changes no action
  /// on this screen.
  unrecognised,
}

/// Human label for a queue status.
String describeStatus(QueueStatus status) => switch (status) {
      QueueStatus.scheduled => 'Expected',
      QueueStatus.arrived => 'Arrived',
      QueueStatus.triaged => 'Triaged',
      QueueStatus.waitingClinician => 'Waiting for clinician',
      QueueStatus.inConsultation => 'In consultation',
      QueueStatus.postConsultation => 'After consultation',
      QueueStatus.completed => 'Completed',
      QueueStatus.noShow => 'Did not attend',
      QueueStatus.cancelled => 'Cancelled',
      QueueStatus.unrecognised => 'Status not recognised by this app',
    };

/// Human label for a queue priority.
String describeQueuePriority(QueuePriority priority) => switch (priority) {
      QueuePriority.immediate => 'Immediate',
      QueuePriority.veryUrgent => 'Very urgent',
      QueuePriority.urgent => 'Urgent',
      QueuePriority.standard => 'Standard',
      QueuePriority.nonUrgent => 'Non-urgent',
      QueuePriority.unrecognised => 'Priority not recognised by this app',
    };

/// Rank for sorting. Lower is more urgent.
int _priorityRank(QueuePriority priority) => switch (priority) {
      QueuePriority.immediate => 0,
      QueuePriority.veryUrgent => 1,
      QueuePriority.urgent => 2,
      QueuePriority.standard => 3,
      QueuePriority.nonUrgent => 4,
      // With standard, for the reason on the enum member.
      QueuePriority.unrecognised => 3,
    };

/// Statuses where the patient is in the department but not yet finished.
bool _present(QueueStatus status) =>
    status == QueueStatus.arrived ||
    status == QueueStatus.triaged ||
    status == QueueStatus.waitingClinician ||
    status == QueueStatus.inConsultation ||
    status == QueueStatus.postConsultation;

/// Statuses where reception has nothing left to do.
bool _withClinician(QueueStatus status) =>
    status == QueueStatus.waitingClinician ||
    status == QueueStatus.inConsultation ||
    status == QueueStatus.postConsultation;

/// One appointment as the board reads it.
@immutable
class BoardAppointment {
  const BoardAppointment({
    required this.appointmentId,
    required this.patientId,
    required this.token,
    required this.status,
    required this.priority,
    required this.arrivalMode,
    required this.startsAt,
    this.priorityReason = '',
    this.checkedInAt,
    this.version = 1,
  });

  final String appointmentId;
  final String patientId;
  final String token;
  final QueueStatus status;
  final QueuePriority priority;
  final String priorityReason;
  final ArrivalMode arrivalMode;
  final DateTime startsAt;
  final DateTime? checkedInAt;
  final int version;
}

/// A queue position as the server reported it.
@immutable
class BoardPosition {
  const BoardPosition({
    required this.appointment,
    required this.position,
    required this.estimatedWaitSeconds,
  });

  final BoardAppointment appointment;
  final int position;
  final int estimatedWaitSeconds;
}

/// One row on the board.
@immutable
class BoardRow {
  const BoardRow({
    required this.appointmentId,
    required this.patientId,
    required this.token,
    required this.status,
    required this.statusLabel,
    required this.priority,
    required this.priorityReason,
    required this.arrivalMode,
    required this.scheduledAt,
    required this.position,
    required this.waitedMinutes,
    required this.estimatedWaitMinutes,
    required this.withClinician,
    required this.canCheckIn,
    required this.version,
  });

  final String appointmentId;
  final String patientId;
  final String token;
  final QueueStatus status;
  final String statusLabel;
  final QueuePriority priority;

  /// Non-empty only when the priority was raised, and then it is required.
  final String priorityReason;
  final ArrivalMode arrivalMode;
  final DateTime scheduledAt;

  /// Position in the queue, or null for someone who has not arrived.
  final int? position;

  /// Minutes since arrival, or null for someone who has not arrived.
  final int? waitedMinutes;

  /// The server's estimate, in minutes, or null when it gave none.
  final int? estimatedWaitMinutes;

  /// True when this row is waiting on a clinician rather than on reception.
  final bool withClinician;

  /// The check-in action is offered only for someone expected and not yet here.
  final bool canCheckIn;

  /// The version this row was read at.
  ///
  /// Not sent with an action — CheckIn takes no expected version, because the
  /// server guards the transition itself: the appointment's state machine
  /// refuses a second check-in and the repository writes under the version it
  /// read. It is kept so the screen can tell that a row changed under it
  /// between refreshes, which is the difference between "nothing happened" and
  /// "somebody else did this while you were looking".
  final int version;
}

/// The whole board.
@immutable
class Board {
  const Board({
    required this.rows,
    required this.waiting,
    required this.serviceMinutes,
    required this.estimateObserved,
    required this.activeClinicians,
    required this.empty,
    required this.ageSeconds,
    required this.stale,
  });

  final List<BoardRow> rows;

  /// How many have arrived and are still waiting to be seen.
  final int waiting;

  /// The service rate the estimate is based on, in minutes.
  final int? serviceMinutes;

  /// True when the estimate is derived from what this clinic actually did
  /// today rather than from a configured default. A configured default shown
  /// as though it were observed is a wait time a receptionist will quote.
  final bool estimateObserved;

  final int activeClinicians;

  /// True when nothing is expected and nobody is waiting.
  final bool empty;

  /// Age of the snapshot, in seconds.
  final int ageSeconds;

  /// True when the snapshot is too old to be quoted to a patient.
  final bool stale;
}

/// How old a board may be before it is called stale.
///
/// Thirty seconds, because that is roughly how long it takes for a position to
/// be wrong once a clinic is moving: one patient called through shifts every
/// number below them.
const int staleAfterSeconds = 30;

/// Builds the board from the queue and the appointments expected today.
///
/// Both are needed. The queue holds people who have arrived; the appointment
/// list holds people who have not. A board built from the queue alone shows an
/// empty clinic at nine in the morning, which is exactly when a receptionist
/// needs to see who is coming.
Board buildBoard({
  required List<BoardPosition> positions,
  required List<BoardAppointment> expected,
  required DateTime fetchedAt,
  required DateTime now,
  int? serviceMinutes,
  bool estimateObserved = false,
  int activeClinicians = 0,
}) {
  final queued = {for (final p in positions) p.appointment.appointmentId};

  final rows = <BoardRow>[
    for (final position in positions) _toRow(position.appointment, position, now),
    for (final appointment in expected)
      if (!queued.contains(appointment.appointmentId) &&
          // Finished and abandoned appointments are not the reception desk's
          // work. Leaving them on the board is how a busy clinic's screen
          // fills with rows nobody acts on and the live ones stop being
          // noticed.
          appointment.status != QueueStatus.completed &&
          appointment.status != QueueStatus.cancelled &&
          appointment.status != QueueStatus.noShow)
        _toRow(appointment, null, now),
  ]..sort(_compareRows);

  final ageSeconds = now.difference(fetchedAt).inSeconds.clamp(0, 1 << 31);

  return Board(
    rows: rows,
    waiting: rows.where((r) => r.position != null && !r.withClinician).length,
    serviceMinutes: serviceMinutes,
    estimateObserved: estimateObserved,
    activeClinicians: activeClinicians,
    empty: rows.isEmpty,
    ageSeconds: ageSeconds,
    stale: ageSeconds > staleAfterSeconds,
  );
}

BoardRow _toRow(
  BoardAppointment appointment,
  BoardPosition? position,
  DateTime now,
) {
  final checkedInAt = appointment.checkedInAt;
  return BoardRow(
    appointmentId: appointment.appointmentId,
    patientId: appointment.patientId,
    token: appointment.token,
    status: appointment.status,
    statusLabel: describeStatus(appointment.status),
    priority: appointment.priority,
    priorityReason: appointment.priorityReason,
    arrivalMode: appointment.arrivalMode,
    scheduledAt: appointment.startsAt,
    position: position?.position,
    waitedMinutes: checkedInAt == null
        ? null
        : now.difference(checkedInAt).inMinutes.clamp(0, 1 << 31),
    estimatedWaitMinutes:
        position != null && position.estimatedWaitSeconds > 0
            ? (position.estimatedWaitSeconds / 60).round()
            : null,
    withClinician: _withClinician(appointment.status),
    // Only for someone expected and not yet here. Offering it for an arrived
    // patient invites a second check-in that the server refuses, and offering
    // it for a cancelled one is just noise.
    canCheckIn: appointment.status == QueueStatus.scheduled,
    version: appointment.version,
  );
}

/// Orders the board the way a receptionist reads it.
///
/// Present patients first, because they are standing at the desk. Within those,
/// clinical priority, then queue position. Expected patients follow in
/// appointment order, which is the order they will arrive in.
int _compareRows(BoardRow a, BoardRow b) {
  final aPresent = _present(a.status);
  final bPresent = _present(b.status);
  if (aPresent != bPresent) {
    return aPresent ? -1 : 1;
  }
  if (aPresent) {
    final byPriority = _priorityRank(a.priority) - _priorityRank(b.priority);
    if (byPriority != 0) {
      return byPriority;
    }
    final aPosition = a.position ?? 1 << 31;
    final bPosition = b.position ?? 1 << 31;
    if (aPosition != bPosition) {
      return aPosition - bPosition;
    }
  }
  return a.scheduledAt.compareTo(b.scheduledAt);
}

/// The board's columns.
///
/// Token, patient and priority are mandatory. A saved view that hides the token
/// makes it impossible to call the next patient; one that hides the priority
/// hides the reason somebody was moved up the queue, which is the thing
/// SRS-SCH-011 requires to stay visible.
const WorklistDefinition receptionWorklist = WorklistDefinition(
  worklist: 'reception-board',
  columns: [
    ColumnPreference(key: 'token', visible: true, position: 0, width: 80),
    ColumnPreference(key: 'patient', visible: true, position: 1),
    ColumnPreference(key: 'status', visible: true, position: 2, width: 160),
    ColumnPreference(key: 'priority', visible: true, position: 3, width: 120),
    ColumnPreference(key: 'scheduled', visible: true, position: 4, width: 100),
    ColumnPreference(key: 'waited', visible: true, position: 5, width: 100),
    ColumnPreference(key: 'estimate', visible: true, position: 6, width: 120),
    ColumnPreference(key: 'arrival', visible: false, position: 7, width: 120),
  ],
  mandatoryColumns: ['token', 'patient', 'priority'],
);
