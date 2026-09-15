/// UX-W1-03 — the ward worklist and charting an observation.
///
/// The interesting cases are the ones where the tablet and the server could
/// disagree: a device clock that is wrong, an entry made long after the reading
/// was taken, and work that has been escalated to somebody else.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/ward/worklist.dart';

final _now = DateTime.utc(2026, 9, 15, 10, 0);

PresentedTask task({
  String id = 't1',
  String description = 'Record observations',
  TaskPriority priority = TaskPriority.routine,
  TaskStatus status = TaskStatus.pending,
  Duration? dueIn,
  bool overdue = false,
  String escalatedTo = '',
  DateTime? now,
}) {
  return presentTask(
    taskId: id,
    patientId: 'patient-1',
    description: description,
    priority: priority,
    status: status,
    dueAt: dueIn == null ? null : _now.add(dueIn),
    overdue: overdue,
    escalatedTo: escalatedTo,
    sourceKind: 'care-plan',
    version: 3,
    now: now ?? _now,
  );
}

void main() {
  group('presenting a task', () {
    test('overdue comes from the server, not from the device clock', () {
      // The tablet's clock is half an hour fast. The task is not overdue, and
      // the server is the thing that escalates, so the screen must not claim
      // otherwise — a nurse chasing work the server does not think is late is
      // a nurse the escalation will never reach.
      final fastClock = task(dueIn: const Duration(minutes: -20), overdue: false,
          now: _now.add(const Duration(minutes: 30)));

      expect(fastClock.overdue, isFalse);
      // The minutes are still computed, because "how late" is presentation.
      expect(fastClock.overdueMinutes, 50);
    });

    test('a task with no due time has no overdue minutes', () {
      expect(task().overdueMinutes, isNull);
      expect(task().dueAt, isNull);
    });

    test('minutes are negative before the task is due', () {
      expect(task(dueIn: const Duration(minutes: 45)).overdueMinutes, -45);
    });

    test('an escalation is recognised by having somewhere to have gone', () {
      expect(task().escalated, isFalse);
      expect(task(escalatedTo: 'charge-nurse').escalated, isTrue);
      expect(task(escalatedTo: 'charge-nurse').escalatedTo, 'charge-nurse');
    });

    test('only a pending task is open', () {
      expect(task(status: TaskStatus.pending).open, isTrue);
      for (final closed in [
        TaskStatus.done,
        TaskStatus.notDone,
        TaskStatus.cancelled,
      ]) {
        expect(task(status: closed).open, isFalse, reason: closed.name);
      }
    });

    test('every priority has a label a nurse can read', () {
      expect(describePriority(TaskPriority.critical), 'Critical');
      expect(describePriority(TaskPriority.urgent), 'Urgent');
      expect(describePriority(TaskPriority.routine), 'Routine');
      // Not blank: an unset priority is a data problem worth seeing, not
      // something to render as an empty cell.
      expect(describePriority(TaskPriority.unspecified), 'Not prioritised');
    });
  });

  group('ordering the worklist', () {
    test('open work comes before closed work', () {
      final ordered = orderTasks([
        task(id: 'done', status: TaskStatus.done),
        task(id: 'open'),
      ]);
      expect(ordered.map((t) => t.taskId), ['open', 'done']);
    });

    test('escalated work outranks a higher priority', () {
      // Somebody has already been told this routine task is not being done. It
      // stays at the top until it is closed rather than sinking back down.
      final ordered = orderTasks([
        task(id: 'critical', priority: TaskPriority.critical),
        task(id: 'escalated-routine', escalatedTo: 'charge-nurse'),
      ]);
      expect(ordered.first.taskId, 'escalated-routine');
    });

    test('priority orders the rest', () {
      final ordered = orderTasks([
        task(id: 'routine'),
        task(id: 'critical', priority: TaskPriority.critical),
        task(id: 'unspecified', priority: TaskPriority.unspecified),
        task(id: 'urgent', priority: TaskPriority.urgent),
      ]);
      expect(ordered.map((t) => t.taskId),
          ['critical', 'urgent', 'routine', 'unspecified']);
    });

    test('due time breaks a tie, and a task with no due time sorts last', () {
      final ordered = orderTasks([
        task(id: 'none'),
        task(id: 'later', dueIn: const Duration(hours: 2)),
        task(id: 'sooner', dueIn: const Duration(minutes: 10)),
      ]);
      expect(ordered.map((t) => t.taskId), ['sooner', 'later', 'none']);
    });

    test('ordering does not mutate the list it was given', () {
      final original = [
        task(id: 'b', priority: TaskPriority.routine),
        task(id: 'a', priority: TaskPriority.critical),
      ];
      orderTasks(original);
      expect(original.map((t) => t.taskId), ['b', 'a']);
    });
  });

  group('the worklist header', () {
    test('counts only open work', () {
      final summary = summarise([
        task(id: '1', overdue: true),
        task(id: '2', priority: TaskPriority.critical),
        task(id: '3', escalatedTo: 'charge-nurse'),
        // Closed: it is not outstanding and must not inflate the count.
        task(id: '4', status: TaskStatus.done, overdue: true),
      ]);

      expect(summary.open, 3);
      expect(summary.overdue, 1);
      expect(summary.critical, 1);
      expect(summary.escalated, 1);
      expect(summary.clear, isFalse);
    });

    test('a worklist with nothing open is clear', () {
      expect(summarise([task(status: TaskStatus.done)]).clear, isTrue);
      expect(summarise([]).clear, isTrue);
    });
  });

  group('charting an observation', () {
    ChartValidity check({
      Duration? observedAgo = Duration.zero,
      String? numeric = '36.8',
      String text = '',
      String reason = '',
    }) =>
        validateChartEntry(
          observedAt: observedAgo == null ? null : _now.subtract(observedAgo),
          numericValue: numeric,
          textValue: text,
          lateEntryReason: reason,
          now: _now,
        );

    test('a contemporaneous numeric reading is accepted', () {
      final result = check();
      expect(result.valid, isTrue);
      expect(result.needsLateEntryReason, isFalse);
    });

    test('a text reading is a reading', () {
      expect(check(numeric: null, text: 'Alert and orientated').valid, isTrue);
    });

    test('an entry with no reading at all is refused', () {
      final result = check(numeric: '', text: '   ');
      expect(result.valid, isFalse);
      expect(result.problems['value'], 'Enter a reading.');
    });

    test('a reading that is not a number is refused', () {
      expect(check(numeric: 'thirty six').problems['value'], 'That is not a number.');
    });

    test('an observation with no time is refused', () {
      expect(check(observedAgo: null).problems['observedAt'], isNotNull);
    });

    test('an observation in the future is refused, not corrected', () {
      // A device clock that is wrong is a real fault on a ward. Clamping the
      // time to now would file the reading under a time it was not taken.
      final result = validateChartEntry(
        observedAt: _now.add(const Duration(minutes: 20)),
        numericValue: '36.8',
        textValue: '',
        lateEntryReason: '',
        now: _now,
      );
      expect(result.valid, isFalse);
      expect(result.problems['observedAt'], contains('date and time on this device'));
      // And it is not also demanded a late-entry reason: it is not late, it is
      // impossible, and asking two questions about one fault helps nobody.
      expect(result.needsLateEntryReason, isFalse);
    });

    test('a reading taken a while ago needs a reason', () {
      final result = check(observedAgo: const Duration(minutes: 40));
      expect(result.valid, isFalse);
      expect(result.needsLateEntryReason, isTrue);
      expect(result.problems['lateEntryReason'], contains('15 minutes ago'));
    });

    test('a late entry with a reason is accepted', () {
      final result = check(
        observedAgo: const Duration(minutes: 40),
        reason: 'Charted after the resuscitation',
      );
      expect(result.valid, isTrue);
      expect(result.needsLateEntryReason, isFalse);
    });

    test('the boundary is a threshold, not a range', () {
      expect(isLate(_now.subtract(const Duration(minutes: 15)), _now), isFalse);
      expect(isLate(_now.subtract(const Duration(minutes: 16)), _now), isTrue);
    });

    test('every source has a description', () {
      for (final source in EntrySource.values) {
        expect(describeSource(source), isNotEmpty, reason: source.name);
      }
      expect(describeSource(EntrySource.paper), 'Transcribed from paper');
    });
  });
}
