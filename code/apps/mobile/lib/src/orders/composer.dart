/// The order composer and the results inbox
/// (UX-W1-04, SRS-ORD-002, SRS-ORD-007, SRS-ORD-009, SRS-CLN-012).
///
/// Placing an order is the point at which a clinician's intention becomes work
/// somebody else does — a phlebotomist draws blood, a radiographer irradiates
/// somebody, a porter moves a bed. The composer's job is to make the order
/// either complete or refused, never ambiguous, because an ambiguous order is
/// resolved downstream by somebody guessing.
///
/// Three rules shape it.
///
/// A required indication blocks submit (SRS-ORD-007). Not a warning: the
/// indication is what the performing service uses to decide protocol and
/// urgency, and "clinical correlation" written after the fact is not the same
/// information. Which types require one is configuration, so the composer reads
/// it rather than hard-coding a list that will be wrong in some hospital.
///
/// A duplicate is a warning with an override, never a silent suppression
/// (SRS-ORD-009). Two potassium levels four hours apart may be exactly right in
/// a patient on an insulin infusion. Suppressing the second would hide a
/// clinically necessary order; refusing it outright would make the system
/// something clinicians work around. So the screen shows what already exists,
/// asks why, and records the answer.
///
/// An acknowledgement is per-order, not a blanket yes. The override names the
/// orders it was given against, so acknowledging a duplicate this morning does
/// not silently cover a different duplicate this afternoon.
library;

import 'package:meta/meta.dart';

/// Mirrors orders.v1.OrderType.
enum OrderType {
  laboratory,
  imaging,
  medication,
  procedure,
  diet,
  nursing,
  bloodProduct,
  referral,
  alliedHealth,
  unspecified,
  unrecognised,
}

/// Mirrors orders.v1.OrderStatus.
enum OrderStatus {
  draft,
  requested,
  accepted,
  scheduled,
  inProgress,
  completed,
  cancelled,
  enteredInError,
  unspecified,
  unrecognised,
}

/// Mirrors orders.v1.OrderPriority.
enum OrderPriority {
  stat,
  urgent,
  timingCritical,
  routine,
  unspecified,
  unrecognised,
}

String describeOrderType(OrderType type) => switch (type) {
      OrderType.laboratory => 'Laboratory',
      OrderType.imaging => 'Imaging',
      OrderType.medication => 'Medication',
      OrderType.procedure => 'Procedure',
      OrderType.diet => 'Diet',
      OrderType.nursing => 'Nursing',
      OrderType.bloodProduct => 'Blood product',
      OrderType.referral => 'Referral',
      OrderType.alliedHealth => 'Allied health',
      OrderType.unspecified => 'Not specified',
      OrderType.unrecognised => 'Type not recognised by this app',
    };

String describeOrderStatus(OrderStatus status) => switch (status) {
      OrderStatus.draft => 'Draft',
      OrderStatus.requested => 'Requested',
      OrderStatus.accepted => 'Accepted',
      OrderStatus.scheduled => 'Scheduled',
      OrderStatus.inProgress => 'In progress',
      OrderStatus.completed => 'Completed',
      OrderStatus.cancelled => 'Cancelled',
      // Retained, not deleted: the performing service may already have acted.
      OrderStatus.enteredInError => 'Entered in error',
      OrderStatus.unspecified => 'Unknown',
      OrderStatus.unrecognised => 'Status not recognised by this app',
    };

String describeOrderPriority(OrderPriority priority) => switch (priority) {
      OrderPriority.stat => 'STAT',
      OrderPriority.urgent => 'Urgent',
      // Its own priority, not a synonym for urgent: a dose that must be given
      // at 08:00 is not more urgent than one needed now, it is differently
      // urgent.
      OrderPriority.timingCritical => 'Timing critical',
      OrderPriority.routine => 'Routine',
      OrderPriority.unspecified => 'Not prioritised',
      OrderPriority.unrecognised => 'Priority not recognised by this app',
    };

/// What the configured policy says about one order type.
@immutable
class OrderPolicy {
  const OrderPolicy({
    required this.type,
    this.indicationRequired = false,
    this.structuredTimingRequired = false,
    this.requiredPrivilege = '',
  });

  final OrderType type;

  /// SRS-ORD-007: submit is blocked until an indication is given.
  final bool indicationRequired;

  /// SRS-ORD-008: a start time and frequency rather than free text.
  final bool structuredTimingRequired;

  /// Named so the screen can say which privilege is missing, not just "no".
  final String requiredPrivilege;
}

/// A draft order as the composer holds it.
@immutable
class OrderDraft {
  const OrderDraft({
    required this.type,
    required this.patientId,
    required this.encounterId,
    this.code = '',
    this.display = '',
    this.detail = '',
    this.indication = '',
    this.priority = OrderPriority.routine,
    this.startAt = '',
    this.frequencySeconds = 0,
    this.conditionalInstruction = '',
  });

  final OrderType type;
  final String patientId;
  final String encounterId;
  final String code;
  final String display;
  final String detail;
  final String indication;
  final OrderPriority priority;

  /// ISO local datetime, or '' when not given.
  final String startAt;
  final int frequencySeconds;
  final String conditionalInstruction;
}

/// Field keys the composer reports problems against.
///
/// Constants rather than bare strings so a screen cannot look up a message
/// under a key the validator never writes, which renders as no message at all.
class OrderField {
  static const type = 'type';
  static const patient = 'patient';
  static const encounter = 'encounter';
  static const code = 'code';
  static const indication = 'indication';
  static const startAt = 'startAt';
  static const frequency = 'frequency';

  /// In the order they should be fixed.
  static const ordered = [
    type,
    patient,
    encounter,
    code,
    indication,
    startAt,
    frequency,
  ];
}

/// Why an order cannot be placed yet.
@immutable
class ComposerValidity {
  const ComposerValidity({
    required this.ready,
    required this.problems,
    required this.order,
  });

  final bool ready;

  /// Keyed by the field, so the message can sit beside the input.
  final Map<String, String> problems;

  /// In the order they should be fixed, for a summary.
  final List<String> order;
}

/// Validates a draft order against the configured policy for its type.
///
/// The server validates again and is the authority (SRS-ORD-002 returns
/// structured field errors). This exists so the clinician is told before the
/// click — an order refused after submit costs the composer's contents in
/// practice, because the failure arrives when attention has already moved on.
ComposerValidity validateOrder(OrderDraft draft, OrderPolicy? policy) {
  final problems = <String, String>{};

  if (draft.type == OrderType.unspecified ||
      draft.type == OrderType.unrecognised) {
    problems[OrderField.type] = 'Choose what kind of order this is.';
  }
  if (draft.patientId.trim().isEmpty) {
    problems[OrderField.patient] = 'This order is not attached to a patient.';
  }
  if (draft.encounterId.trim().isEmpty) {
    problems[OrderField.encounter] =
        'This order is not attached to an encounter.';
  }
  if (draft.code.trim().isEmpty && draft.display.trim().isEmpty) {
    problems[OrderField.code] = 'Choose what is being ordered.';
  }

  if (policy != null && policy.indicationRequired &&
      draft.indication.trim().isEmpty) {
    // SRS-ORD-007. Blocking, not advisory: the performing service uses the
    // indication to decide protocol and urgency, and it cannot be
    // reconstructed afterwards.
    problems[OrderField.indication] =
        'This kind of order needs a clinical indication before it can be placed.';
  }

  if (policy != null && policy.structuredTimingRequired) {
    if (draft.startAt.trim().isEmpty) {
      problems[OrderField.startAt] = 'Give a start time.';
    }
    if (draft.frequencySeconds <= 0) {
      // SRS-ORD-008: downstream receives normalised timing. "TDS" in a
      // free-text box is not something a scheduler can act on.
      problems[OrderField.frequency] =
          'Give how often, as a frequency rather than as free text.';
    }
  }

  final order = [
    for (final field in OrderField.ordered)
      if (problems.containsKey(field)) problems[field]!,
  ];

  return ComposerValidity(
    ready: order.isEmpty,
    problems: Map.unmodifiable(problems),
    order: order,
  );
}

/// An existing order the composer is warning about.
@immutable
class DuplicateCandidate {
  const DuplicateCandidate({
    required this.orderId,
    required this.number,
    required this.display,
    required this.status,
    required this.placedAt,
    this.requesterId = '',
  });

  final String orderId;
  final String number;
  final String display;
  final OrderStatus status;
  final DateTime placedAt;
  final String requesterId;

  String get statusLabel => describeOrderStatus(status);
}

/// Where the clinician is with a duplicate warning.
enum DuplicateState {
  /// Nothing to warn about.
  clear,

  /// Duplicates exist and policy allows an override with a reason.
  needsOverride,

  /// Duplicates exist and policy does not permit an override.
  refused,

  /// A reason has been given for these specific orders.
  overridden,
}

/// The duplicate gate, and what to say at it.
@immutable
class DuplicateGate {
  const DuplicateGate({
    required this.state,
    this.message = '',
    this.candidates = const [],
    this.windowHours = 0,
  });

  final DuplicateState state;
  final String message;
  final List<DuplicateCandidate> candidates;
  final int windowHours;
}

/// Decides what to do about a duplicate warning.
///
/// [acknowledged] lists the order ids the reason was given against. It is
/// compared against the current candidates rather than counted, so a reason
/// given for this morning's duplicate does not silently cover a different one
/// this afternoon.
DuplicateGate duplicateGate({
  required List<DuplicateCandidate> candidates,
  required bool overridable,
  required int windowSeconds,
  List<String> acknowledged = const [],
  String reason = '',
}) {
  if (candidates.isEmpty) {
    return const DuplicateGate(state: DuplicateState.clear);
  }

  if (!overridable) {
    return DuplicateGate(
      state: DuplicateState.refused,
      message: 'An identical order is already live and policy does not allow '
          'a duplicate. Use the existing order, or cancel it first.',
      candidates: candidates,
    );
  }

  final seen = acknowledged.toSet();
  final covered = candidates.every((c) => seen.contains(c.orderId));

  if (covered && reason.trim().isNotEmpty) {
    return DuplicateGate(
      state: DuplicateState.overridden,
      candidates: candidates,
    );
  }

  final windowHours = (windowSeconds / 3600).round().clamp(1, 1 << 31);
  return DuplicateGate(
    state: DuplicateState.needsOverride,
    message: candidates.length == 1
        ? 'An order for this was placed in the last $windowHours hours. '
            'Say why another is needed.'
        : '${candidates.length} orders for this were placed in the last '
            '$windowHours hours. Say why another is needed.',
    candidates: candidates,
    windowHours: windowHours,
  );
}

/// True when the place button may be enabled.
bool mayPlace(ComposerValidity validity, DuplicateGate gate) {
  if (!validity.ready) {
    return false;
  }
  return gate.state == DuplicateState.clear ||
      gate.state == DuplicateState.overridden;
}

/// A critical result awaiting acknowledgement.
@immutable
class InboxItem {
  const InboxItem({
    required this.observationId,
    required this.patientId,
    required this.display,
    required this.value,
    required this.interpretationLabel,
    required this.effectiveAt,
    this.dueEscalations = 0,
    this.waitingMinutes = 0,
  });

  final String observationId;

  /// Carried because the inbox is ward-wide: a row that cannot say whose
  /// result it is is a row nobody can act on.
  final String patientId;

  final String display;
  final String value;
  final String interpretationLabel;
  final DateTime effectiveAt;

  /// How many escalations the server says are now due (SRS-CLN-012).
  final int dueEscalations;

  /// Minutes since the result was issued.
  final int waitingMinutes;
}

/// Orders the results inbox.
///
/// By escalations first, then by age. A result that has already escalated twice
/// is one where the acknowledgement process has failed, and it belongs above a
/// fresher result that is merely unread — sorting purely by age buries it as the
/// list grows.
List<InboxItem> orderInbox(List<InboxItem> items) => [...items]..sort((a, b) {
      if (a.dueEscalations != b.dueEscalations) {
        return b.dueEscalations - a.dueEscalations;
      }
      return a.effectiveAt.compareTo(b.effectiveAt);
    });

/// Why an acknowledgement cannot be submitted, or '' when it can.
String acknowledgementProblem(String action) {
  if (action.trim().isEmpty) {
    // SRS-CLN-012 asks for the action taken, not merely that somebody looked.
    // "Seen" closes the loop administratively and leaves the next reader
    // unable to tell whether anything was done about a potassium of 6.8.
    return 'Say what was done about this result, not only that it was seen.';
  }
  return '';
}
