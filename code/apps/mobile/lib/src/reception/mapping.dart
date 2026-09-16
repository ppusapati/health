/// Wire types to the reception screens' models (UX-W1-01).
///
/// # How an enum this build has never heard of arrives
///
/// The web shell gets exhaustiveness for free: its maps are
/// `Record<WireEnum, T>` and `tsc` refuses a file that misses a member. That
/// caught a real mistake during UX-W1-03. Dart cannot do the same, because a
/// generated protobuf enum is a class of constants rather than a closed set.
///
/// The obvious runtime substitute — a `default:` arm that throws — is worse
/// than useless here, because it can never run. Measured rather than assumed:
/// `protobuf.dart` decodes an unrecognised enum tag as the **zero member** and
/// files the real tag under `unknownFields`. So a future
/// `MATCH_OUTCOME_MERGED` does not arrive as something unmapped; it arrives as
/// `MATCH_OUTCOME_UNSPECIFIED`, which this build reads as "match strength not
/// assessed" — a verdict that does not block registration. A newer server
/// would silently unlock the create button on a patient already in the index.
///
/// So the check is on `unknownFields`, which is where the evidence actually
/// is. A field whose tag appears there was sent as a value this build cannot
/// name, and the mapping returns an explicit `unrecognised` member rather than
/// the zero one. Each of those members is defined to fail safe: an
/// unrecognised match outcome blocks registration, an unrecognised appointment
/// status offers no check-in.
///
/// Refusing the whole response instead would be defensible, but it turns one
/// unfamiliar row into an unusable screen, and a receptionist with a queue in
/// front of them will find another way. One marked row is the better failure.
library;

import 'package:protobuf/protobuf.dart' as pb;

import '../gen/healthcare/empi/v1/patient.pb.dart' as empi;
import '../gen/healthcare/scheduling/v1/appointment.pb.dart' as sched;
import 'board.dart';
import 'search.dart';

/// Field tags carrying the enums this module reads.
///
/// Named constants because the number is the whole check: reading the wrong
/// tag would silently stop detecting anything, and a test pins each one.
const int matchOutcomeField = 3; // empi.v1.PatientMatch.outcome
const int appointmentStatusField = 10; // scheduling.v1.Appointment.status
const int arrivalModeField = 21; // scheduling.v1.Appointment.arrival_mode
const int priorityField = 23; // scheduling.v1.Appointment.priority

/// True when [message] carried a value for [tag] that this build could not
/// interpret.
bool sentUnknownValueFor(pb.GeneratedMessage message, int tag) =>
    message.unknownFields.hasField(tag);

/// Match outcome, wire to model.
///
/// Takes the enclosing message rather than the enum, because the enum alone
/// cannot answer the question — an unknown value and a genuinely unspecified
/// one are the same constant by the time they reach a getter.
MatchOutcome matchOutcomeOf(empi.PatientMatch wire) {
  if (sentUnknownValueFor(wire, matchOutcomeField)) {
    return MatchOutcome.unrecognised;
  }
  return switch (wire.outcome) {
    empi.MatchOutcome.MATCH_OUTCOME_DISTINCT => MatchOutcome.distinct,
    empi.MatchOutcome.MATCH_OUTCOME_REVIEW => MatchOutcome.review,
    empi.MatchOutcome.MATCH_OUTCOME_PROBABLE => MatchOutcome.probable,
    empi.MatchOutcome.MATCH_OUTCOME_CONFLICT => MatchOutcome.conflict,
    empi.MatchOutcome.MATCH_OUTCOME_UNSPECIFIED => MatchOutcome.unspecified,
    // Unreachable by the decoding above, and kept rather than left to an
    // analyser warning: if protobuf's behaviour ever changes, failing safe is
    // still the right answer.
    _ => MatchOutcome.unrecognised,
  };
}

/// Appointment status, wire to model.
QueueStatus queueStatusOf(sched.Appointment wire) {
  if (sentUnknownValueFor(wire, appointmentStatusField)) {
    return QueueStatus.unrecognised;
  }
  return switch (wire.status) {
    sched.AppointmentStatus.APPOINTMENT_STATUS_SCHEDULED => QueueStatus.scheduled,
    sched.AppointmentStatus.APPOINTMENT_STATUS_ARRIVED => QueueStatus.arrived,
    sched.AppointmentStatus.APPOINTMENT_STATUS_TRIAGED => QueueStatus.triaged,
    sched.AppointmentStatus.APPOINTMENT_STATUS_WAITING_CLINICIAN =>
      QueueStatus.waitingClinician,
    sched.AppointmentStatus.APPOINTMENT_STATUS_IN_CONSULTATION =>
      QueueStatus.inConsultation,
    sched.AppointmentStatus.APPOINTMENT_STATUS_POST_CONSULTATION =>
      QueueStatus.postConsultation,
    sched.AppointmentStatus.APPOINTMENT_STATUS_COMPLETED => QueueStatus.completed,
    sched.AppointmentStatus.APPOINTMENT_STATUS_NO_SHOW => QueueStatus.noShow,
    sched.AppointmentStatus.APPOINTMENT_STATUS_CANCELLED => QueueStatus.cancelled,
    sched.AppointmentStatus.APPOINTMENT_STATUS_UNSPECIFIED =>
      QueueStatus.unrecognised,
    _ => QueueStatus.unrecognised,
  };
}

/// Priority, wire to model.
///
/// An unspecified priority is standard, which the proto says in as many words
/// — a documented meaning rather than a guess, so it maps. A tag this build
/// cannot name is a different thing and gets its own member.
QueuePriority queuePriorityOf(sched.Appointment wire) {
  if (sentUnknownValueFor(wire, priorityField)) {
    return QueuePriority.unrecognised;
  }
  return switch (wire.priority) {
    sched.Priority.PRIORITY_IMMEDIATE => QueuePriority.immediate,
    sched.Priority.PRIORITY_VERY_URGENT => QueuePriority.veryUrgent,
    sched.Priority.PRIORITY_URGENT => QueuePriority.urgent,
    sched.Priority.PRIORITY_STANDARD => QueuePriority.standard,
    sched.Priority.PRIORITY_NON_URGENT => QueuePriority.nonUrgent,
    sched.Priority.PRIORITY_UNSPECIFIED => QueuePriority.standard,
    _ => QueuePriority.unrecognised,
  };
}

/// Arrival mode, wire to model.
ArrivalMode arrivalModeOf(sched.Appointment wire) {
  if (sentUnknownValueFor(wire, arrivalModeField)) {
    return ArrivalMode.unrecognised;
  }
  return switch (wire.arrivalMode) {
    sched.ArrivalMode.ARRIVAL_MODE_WALK_IN => ArrivalMode.walkIn,
    sched.ArrivalMode.ARRIVAL_MODE_SCHEDULED => ArrivalMode.scheduled,
    sched.ArrivalMode.ARRIVAL_MODE_AMBULANCE => ArrivalMode.ambulance,
    sched.ArrivalMode.ARRIVAL_MODE_REFERRAL => ArrivalMode.referral,
    sched.ArrivalMode.ARRIVAL_MODE_TELEHEALTH => ArrivalMode.telehealth,
    sched.ArrivalMode.ARRIVAL_MODE_UNSPECIFIED => ArrivalMode.scheduled,
    _ => ArrivalMode.unrecognised,
  };
}

/// One appointment, wire to model.
BoardAppointment appointmentOf(sched.Appointment wire) => BoardAppointment(
      appointmentId: wire.appointmentId,
      patientId: wire.patientId,
      token: wire.token,
      status: queueStatusOf(wire),
      priority: queuePriorityOf(wire),
      priorityReason: wire.priorityReason,
      arrivalMode: arrivalModeOf(wire),
      startsAt: wire.startsAt.toDateTime().toUtc(),
      // hasCheckedInAt rather than a zero-timestamp check: the epoch is a real
      // instant, and "not checked in" has to stay distinguishable from a clock
      // that was wrong.
      checkedInAt:
          wire.hasCheckedInAt() ? wire.checkedInAt.toDateTime().toUtc() : null,
      version: wire.version.toInt(),
    );

/// One queue position, wire to model.
BoardPosition positionOf(sched.QueuePosition wire) => BoardPosition(
      appointment: appointmentOf(wire.appointment),
      position: wire.position,
      estimatedWaitSeconds: wire.estimatedWaitSeconds.toInt(),
    );

/// One search candidate, wire to model.
PresentedMatch matchOf(empi.PatientMatch wire) {
  // No fallback here, unlike the display name: an absent former name is
  // absent, and "also known as Name not available" is worse than silence.
  final formerName =
      wire.hasMatchedFormerName() ? _join(wire.matchedFormerName.name) : '';

  return presentMatch(
    patientId: wire.patient.patientId,
    // An empty name is shown as such rather than as a blank row. A row with
    // nothing in the name column reads as a rendering fault, and a
    // receptionist scanning for "is this them" skips it.
    displayName: _orUnavailable(_join(wire.patient.demographics.name)),
    confidence: wire.confidence,
    outcome: matchOutcomeOf(wire),
    masked: wire.masked,
    matchedFormerName: formerName,
  );
}

/// Joins a name's parts, which may legitimately produce nothing.
String _join(empi.HumanName name) => [name.given.join(' ').trim(), name.family]
    .where((p) => p.isNotEmpty)
    .join(' ');

/// The fallback for a name a row has to show something for.
String _orUnavailable(String name) =>
    name.isEmpty ? 'Name not available' : name;
