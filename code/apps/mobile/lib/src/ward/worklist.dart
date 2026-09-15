/// Ward worklist and observation charting (UX-W1-03, SRS-NUR-008/009/001).
///
/// The same vocabulary as the web shell's `lib/ward/worklist.ts`, deliberately:
/// a nurse who learns the worklist on a desk terminal and then picks up a
/// tablet should not have to learn a second set of words for the same work, and
/// a difference in ordering between the two would be read as a difference in
/// the work.
///
/// Presentation only. Nothing here decides whether an action is permitted —
/// the server does, and a screen that believed otherwise would be a screen that
/// could be lied to.
library;

import 'package:meta/meta.dart';

/// Mirrors nursing.v1.TaskPriority.
enum TaskPriority { routine, urgent, critical, unspecified }

/// Mirrors nursing.v1.TaskStatus.
enum TaskStatus { pending, done, notDone, cancelled, unspecified }

/// Mirrors nursing.v1.EntrySource.
enum EntrySource { manual, device, paper, patient, unspecified }

/// Human label for a task priority.
String describePriority(TaskPriority priority) => switch (priority) {
      TaskPriority.critical => 'Critical',
      TaskPriority.urgent => 'Urgent',
      TaskPriority.routine => 'Routine',
      TaskPriority.unspecified => 'Not prioritised',
    };

int _priorityRank(TaskPriority priority) => switch (priority) {
      TaskPriority.critical => 0,
      TaskPriority.urgent => 1,
      TaskPriority.routine => 2,
      TaskPriority.unspecified => 3,
    };

/// Where an observation came from, in words.
String describeSource(EntrySource source) => switch (source) {
      EntrySource.manual => 'Entered by hand',
      EntrySource.device => 'From a device',
      EntrySource.paper => 'Transcribed from paper',
      EntrySource.patient => 'Reported by the patient',
      EntrySource.unspecified => 'Source not recorded',
    };

/// One task as the worklist shows it.
@immutable
class PresentedTask {
  const PresentedTask({
    required this.taskId,
    required this.patientId,
    required this.description,
    required this.priority,
    required this.priorityLabel,
    required this.status,
    required this.dueAt,
    required this.overdueMinutes,
    required this.overdue,
    required this.escalated,
    required this.escalatedTo,
    required this.source,
    required this.open,
    required this.version,
  });

  final String taskId;
  final String patientId;
  final String description;
  final TaskPriority priority;
  final String priorityLabel;
  final TaskStatus status;
  final DateTime? dueAt;

  /// Minutes past due; negative when it is not due yet, null with no due time.
  final int? overdueMinutes;

  /// Whether the server says it is overdue — not recomputed here, see below.
  final bool overdue;

  final bool escalated;
  final String escalatedTo;

  /// Where the task came from: a care plan, a protocol, a nurse.
  final String source;

  /// Whether it still needs doing.
  final bool open;

  /// The row version, carried so a completion can be rejected if the task has
  /// moved under the nurse holding the tablet.
  final int version;
}

/// Presents one task.
///
/// `overdue` is taken from the server rather than derived from `dueAt` against
/// the device clock. A tablet whose clock is ten minutes fast would otherwise
/// show work as overdue that is not, and escalate nothing — the escalation is
/// server-side, so the two would disagree and the screen would be the one
/// lying. The minutes are computed locally only to say *how* late, and are
/// presentation rather than a decision.
PresentedTask presentTask({
  required String taskId,
  required String patientId,
  required String description,
  required TaskPriority priority,
  required TaskStatus status,
  required DateTime? dueAt,
  required bool overdue,
  required String escalatedTo,
  required String sourceKind,
  required int version,
  required DateTime now,
}) {
  return PresentedTask(
    taskId: taskId,
    patientId: patientId,
    description: description,
    priority: priority,
    priorityLabel: describePriority(priority),
    status: status,
    dueAt: dueAt,
    overdueMinutes:
        dueAt == null ? null : now.difference(dueAt).inMinutes,
    overdue: overdue,
    escalated: escalatedTo.isNotEmpty,
    escalatedTo: escalatedTo,
    source: sourceKind,
    open: status == TaskStatus.pending,
    version: version,
  );
}

/// Orders the worklist.
///
/// Open work first, then escalated, then priority, then due time. Escalated
/// above priority on purpose: an escalation means somebody else has already
/// been told this is not being done, and it stays at the top until it is closed
/// rather than sinking back down because it was only routine.
List<PresentedTask> orderTasks(List<PresentedTask> tasks) {
  final ordered = [...tasks];
  ordered.sort((a, b) {
    if (a.open != b.open) return a.open ? -1 : 1;
    if (a.open) {
      if (a.escalated != b.escalated) return a.escalated ? -1 : 1;
      final byPriority = _priorityRank(a.priority) - _priorityRank(b.priority);
      if (byPriority != 0) return byPriority;
    }
    final aDue = a.dueAt?.millisecondsSinceEpoch ?? (1 << 62);
    final bDue = b.dueAt?.millisecondsSinceEpoch ?? (1 << 62);
    return aDue.compareTo(bDue);
  });
  return ordered;
}

/// What the worklist header reports.
@immutable
class WorklistSummary {
  const WorklistSummary({
    required this.open,
    required this.overdue,
    required this.escalated,
    required this.critical,
  });

  final int open;
  final int overdue;
  final int escalated;
  final int critical;

  /// True when there is nothing outstanding. Distinct from a worklist that
  /// failed to load, which the screen states keep apart.
  bool get clear => open == 0;
}

/// Counts what the header shows.
WorklistSummary summarise(List<PresentedTask> tasks) {
  final open = tasks.where((t) => t.open).toList(growable: false);
  return WorklistSummary(
    open: open.length,
    overdue: open.where((t) => t.overdue).length,
    escalated: open.where((t) => t.escalated).length,
    critical: open.where((t) => t.priority == TaskPriority.critical).length,
  );
}

/// How long after an observation is taken it stops being a contemporaneous
/// record and becomes a late entry (SRS-NUR-001).
const int lateEntryAfterMinutes = 15;

/// Whether an observation taken then, entered now, is a late entry.
bool isLate(DateTime observedAt, DateTime now) =>
    now.difference(observedAt).inMinutes > lateEntryAfterMinutes;

/// What is wrong with a chart entry, if anything.
@immutable
class ChartValidity {
  const ChartValidity({
    required this.valid,
    required this.problems,
    required this.needsLateEntryReason,
  });

  final bool valid;

  /// Field path to the message to show against it.
  final Map<String, String> problems;

  /// True when the entry is late and the reason is what is missing. Separate
  /// from the other problems because it is the one the nurse can only answer
  /// after being told it applies.
  final bool needsLateEntryReason;
}

/// Validates a chart entry before it is sent.
///
/// The server validates too, and its answer is the one that counts. This exists
/// so a nurse holding a tablet at a bedside is told what is missing before the
/// round is interrupted by a round trip, and so a late entry is asked for a
/// reason at the moment the nurse still remembers it.
///
/// An observation in the future is refused rather than corrected. A device
/// clock that is wrong is a real and common fault on a ward, and silently
/// clamping the time would file the reading under a time it was not taken.
ChartValidity validateChartEntry({
  required DateTime? observedAt,
  required String? numericValue,
  required String textValue,
  required String lateEntryReason,
  required DateTime now,
}) {
  final problems = <String, String>{};

  if (observedAt == null) {
    problems['observedAt'] = 'Say when the reading was taken.';
  } else if (observedAt.isAfter(now)) {
    problems['observedAt'] =
        'That is in the future. Check the date and time on this device.';
  }

  final hasNumber = numericValue != null && numericValue.trim().isNotEmpty;
  final hasText = textValue.trim().isNotEmpty;
  if (!hasNumber && !hasText) {
    problems['value'] = 'Enter a reading.';
  }
  if (hasNumber && double.tryParse(numericValue.trim()) == null) {
    problems['value'] = 'That is not a number.';
  }

  final late = observedAt != null &&
      !observedAt.isAfter(now) &&
      isLate(observedAt, now);
  final needsReason = late && lateEntryReason.trim().isEmpty;
  if (needsReason) {
    problems['lateEntryReason'] =
        'This was taken more than $lateEntryAfterMinutes minutes ago. '
        'Say why it is being entered now.';
  }

  return ChartValidity(
    valid: problems.isEmpty,
    problems: problems,
    needsLateEntryReason: needsReason,
  );
}
