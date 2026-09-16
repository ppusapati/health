import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/prefs/views.dart';
import 'package:health_mobile/src/reception/board.dart';
import 'package:health_mobile/src/reception/search.dart';

void main() {
  group('search before create', () {
    test('a search with nothing typed is refused before it is sent', () {
      final validity = validateSearch(const SearchCriteria());
      expect(validity.runnable, isFalse);
      expect(validity.reason, SearchRefusal.noCriteria);
      expect(validity.message, contains('Enter a name'));
    });

    test('one letter of a name is too broad to send', () {
      // The first page of an enormous result set reads as "not found here",
      // which is how a duplicate gets created.
      final validity = validateSearch(const SearchCriteria(name: 'S'));
      expect(validity.runnable, isFalse);
      expect(validity.reason, SearchRefusal.tooBroad);
    });

    test('one letter is enough once it is anchored to something else', () {
      for (final criteria in [
        const SearchCriteria(name: 'S', birthDate: '1984-02-11'),
        const SearchCriteria(name: 'S', phone: '9876543210'),
        const SearchCriteria(name: 'S', identifierValue: 'MRN-42'),
      ]) {
        expect(validateSearch(criteria).runnable, isTrue);
      }
    });

    test('an identifier alone is a search, with no name at all', () {
      expect(validateSearch(const SearchCriteria(identifierValue: 'MRN-42')).runnable, isTrue);
    });

    test('whitespace is not criteria', () {
      expect(validateSearch(const SearchCriteria(name: '   ')).runnable, isFalse);
    });

    test('an outcome is described in words, never as a bare percentage', () {
      // A percentage invites a private threshold; the configured one the
      // server applied is the one that matters.
      for (final outcome in MatchOutcome.values) {
        final label = describeOutcome(outcome);
        expect(label, isNotEmpty);
        expect(label, isNot(contains('%')));
      }
    });

    test('confidence is clamped into a percentage rather than trusted', () {
      expect(presentMatch(
        patientId: 'p1', displayName: 'A', confidence: 1.4,
        outcome: MatchOutcome.probable,
      ).confidencePercent, 100);
      expect(presentMatch(
        patientId: 'p1', displayName: 'A', confidence: -0.2,
        outcome: MatchOutcome.distinct,
      ).confidencePercent, 0);
      expect(presentMatch(
        patientId: 'p1', displayName: 'A', confidence: 0.923,
        outcome: MatchOutcome.review,
      ).confidencePercent, 92);
    });

    test('only the uncertain outcomes block registration', () {
      bool blocks(MatchOutcome outcome) => presentMatch(
            patientId: 'p1', displayName: 'A', confidence: 0.5, outcome: outcome,
          ).blocksRegistration;

      expect(blocks(MatchOutcome.probable), isTrue);
      expect(blocks(MatchOutcome.review), isTrue);
      expect(blocks(MatchOutcome.conflict), isTrue);
      expect(blocks(MatchOutcome.distinct), isFalse);
      // Not assessed is not the same as assessed and cleared, but it is also
      // not a candidate the server flagged; blocking on it would make every
      // unscored row a stop sign and teach people to click through them.
      expect(blocks(MatchOutcome.unspecified), isFalse);
    });
  });

  group('the registration gate', () {
    PresentedMatch candidate(String id, MatchOutcome outcome) => presentMatch(
          patientId: id, displayName: 'Candidate $id', confidence: 0.8, outcome: outcome,
        );

    test('registration is not offered before anybody has searched', () {
      final gate = registrationGate(searched: false, matches: [], acknowledged: []);
      expect(gate.state, GateState.searchFirst);
      expect(gate.mayRegister, isFalse);
    });

    test('an empty result before a search is not the same as a clear search', () {
      // Both are an empty list and they mean opposite things.
      final before = registrationGate(searched: false, matches: [], acknowledged: []);
      final after = registrationGate(searched: true, matches: [], acknowledged: []);
      expect(before.mayRegister, isFalse);
      expect(after.mayRegister, isTrue);
      expect(after.state, GateState.clear);
    });

    test('a blocking candidate holds the gate shut', () {
      final gate = registrationGate(
        searched: true,
        matches: [candidate('p1', MatchOutcome.probable)],
        acknowledged: [],
      );
      expect(gate.state, GateState.reviewCandidates);
      expect(gate.mayRegister, isFalse);
      expect(gate.outstanding, ['p1']);
      expect(gate.message, contains('One existing record'));
    });

    test('the gate opens only when every blocker has been rejected', () {
      final matches = [
        candidate('p1', MatchOutcome.probable),
        candidate('p2', MatchOutcome.review),
      ];
      final half = registrationGate(
        searched: true, matches: matches, acknowledged: ['p1'],
      );
      expect(half.mayRegister, isFalse);
      expect(half.outstanding, ['p2']);

      final whole = registrationGate(
        searched: true, matches: matches, acknowledged: ['p1', 'p2'],
      );
      expect(whole.state, GateState.acknowledged);
      expect(whole.mayRegister, isTrue);
    });

    test('a non-blocking candidate never needs acknowledging', () {
      final gate = registrationGate(
        searched: true,
        matches: [candidate('p1', MatchOutcome.distinct)],
        acknowledged: [],
      );
      expect(gate.state, GateState.clear);
      expect(gate.mayRegister, isTrue);
    });

    test('acknowledging somebody who was never a candidate opens nothing', () {
      final gate = registrationGate(
        searched: true,
        matches: [candidate('p1', MatchOutcome.probable)],
        acknowledged: ['someone-else'],
      );
      expect(gate.mayRegister, isFalse);
      expect(gate.outstanding, ['p1']);
    });

    test('the plural message counts the outstanding, not the candidates', () {
      final gate = registrationGate(
        searched: true,
        matches: [
          candidate('p1', MatchOutcome.probable),
          candidate('p2', MatchOutcome.review),
          candidate('p3', MatchOutcome.conflict),
        ],
        acknowledged: ['p1'],
      );
      expect(gate.message, startsWith('2 existing records'));
    });
  });

  group('the reception board', () {
    final fetchedAt = DateTime.utc(2026, 9, 16, 9, 30);

    BoardAppointment appointment({
      required String id,
      required QueueStatus status,
      QueuePriority priority = QueuePriority.standard,
      DateTime? startsAt,
      DateTime? checkedInAt,
      String token = 'A1',
    }) =>
        BoardAppointment(
          appointmentId: id,
          patientId: 'patient-$id',
          token: token,
          status: status,
          priority: priority,
          arrivalMode: ArrivalMode.scheduled,
          startsAt: startsAt ?? DateTime.utc(2026, 9, 16, 9),
          checkedInAt: checkedInAt,
        );

    test('waiting time is measured from arrival, never from the appointment', () {
      // Booked at nine, arrived at ten, read at half past ten: thirty minutes,
      // not ninety. Measuring from the booking sorts the wrong people up.
      final board = buildBoard(
        positions: [
          BoardPosition(
            appointment: appointment(
              id: 'a',
              status: QueueStatus.arrived,
              startsAt: DateTime.utc(2026, 9, 16, 9),
              checkedInAt: DateTime.utc(2026, 9, 16, 10),
            ),
            position: 1,
            estimatedWaitSeconds: 600,
          ),
        ],
        expected: [],
        fetchedAt: DateTime.utc(2026, 9, 16, 10, 30),
        now: DateTime.utc(2026, 9, 16, 10, 30),
      );
      expect(board.rows.single.waitedMinutes, 30);
    });

    test('somebody who has not arrived has no waiting time at all', () {
      // Zero would read as "waiting, just got here".
      final board = buildBoard(
        positions: [],
        expected: [appointment(id: 'a', status: QueueStatus.scheduled)],
        fetchedAt: fetchedAt,
        now: fetchedAt,
      );
      expect(board.rows.single.waitedMinutes, isNull);
      expect(board.rows.single.position, isNull);
    });

    test('the expected are on the board, so a clinic at nine is not empty', () {
      final board = buildBoard(
        positions: [],
        expected: [
          appointment(id: 'a', status: QueueStatus.scheduled),
          appointment(id: 'b', status: QueueStatus.scheduled),
        ],
        fetchedAt: fetchedAt,
        now: fetchedAt,
      );
      expect(board.rows, hasLength(2));
      expect(board.empty, isFalse);
    });

    test('finished and abandoned appointments leave the board', () {
      final board = buildBoard(
        positions: [],
        expected: [
          appointment(id: 'done', status: QueueStatus.completed),
          appointment(id: 'gone', status: QueueStatus.cancelled),
          appointment(id: 'absent', status: QueueStatus.noShow),
          appointment(id: 'live', status: QueueStatus.scheduled),
        ],
        fetchedAt: fetchedAt,
        now: fetchedAt,
      );
      expect(board.rows.map((r) => r.appointmentId), ['live']);
    });

    test('an appointment in the queue is not also listed as expected', () {
      final queued = appointment(
        id: 'a',
        status: QueueStatus.arrived,
        checkedInAt: DateTime.utc(2026, 9, 16, 9, 15),
      );
      final board = buildBoard(
        positions: [
          BoardPosition(appointment: queued, position: 1, estimatedWaitSeconds: 0),
        ],
        expected: [queued],
        fetchedAt: fetchedAt,
        now: fetchedAt,
      );
      expect(board.rows, hasLength(1));
    });

    test('present patients sort above the expected, then by priority', () {
      BoardAppointment present(String id, QueuePriority priority) => appointment(
            id: id,
            status: QueueStatus.arrived,
            priority: priority,
            checkedInAt: DateTime.utc(2026, 9, 16, 9),
          );
      final board = buildBoard(
        positions: [
          BoardPosition(
            appointment: present('standard', QueuePriority.standard),
            position: 1,
            estimatedWaitSeconds: 0,
          ),
          BoardPosition(
            appointment: present('immediate', QueuePriority.immediate),
            position: 2,
            estimatedWaitSeconds: 0,
          ),
        ],
        expected: [
          appointment(
            id: 'expected',
            status: QueueStatus.scheduled,
            startsAt: DateTime.utc(2026, 9, 16, 8),
          ),
        ],
        fetchedAt: fetchedAt,
        now: fetchedAt,
      );
      // The immediate patient outranks the standard one despite a worse queue
      // position, and both outrank somebody who has not walked in yet — even
      // one booked an hour earlier.
      expect(board.rows.map((r) => r.appointmentId),
          ['immediate', 'standard', 'expected']);
    });

    test('a board older than half a minute says so', () {
      final board = buildBoard(
        positions: [],
        expected: [appointment(id: 'a', status: QueueStatus.scheduled)],
        fetchedAt: fetchedAt,
        now: fetchedAt.add(const Duration(seconds: staleAfterSeconds + 1)),
      );
      expect(board.stale, isTrue);
      expect(board.ageSeconds, staleAfterSeconds + 1);
    });

    test('a board read the instant it arrived is not stale', () {
      final board = buildBoard(
        positions: [],
        expected: [appointment(id: 'a', status: QueueStatus.scheduled)],
        fetchedAt: fetchedAt,
        now: fetchedAt,
      );
      expect(board.stale, isFalse);
      expect(board.ageSeconds, 0);
    });

    test('a clock that ran backwards does not produce a negative age', () {
      final board = buildBoard(
        positions: [],
        expected: [appointment(id: 'a', status: QueueStatus.scheduled)],
        fetchedAt: fetchedAt,
        now: fetchedAt.subtract(const Duration(minutes: 5)),
      );
      expect(board.ageSeconds, 0);
      expect(board.stale, isFalse);
    });

    test('check-in is offered only to somebody expected and not yet here', () {
      for (final status in QueueStatus.values) {
        final board = buildBoard(
          positions: [],
          expected: [appointment(id: 'a', status: status)],
          fetchedAt: fetchedAt,
          now: fetchedAt,
        );
        if (board.rows.isEmpty) {
          continue; // completed, cancelled, no-show are off the board entirely
        }
        expect(board.rows.single.canCheckIn, status == QueueStatus.scheduled,
            reason: 'canCheckIn for $status');
      }
    });

    test('waiting counts those waiting on reception, not those with a clinician', () {
      BoardPosition queued(String id, QueueStatus status, int position) => BoardPosition(
            appointment: appointment(
              id: id,
              status: status,
              checkedInAt: DateTime.utc(2026, 9, 16, 9),
            ),
            position: position,
            estimatedWaitSeconds: 0,
          );
      final board = buildBoard(
        positions: [
          queued('a', QueueStatus.arrived, 1),
          queued('b', QueueStatus.triaged, 2),
          queued('c', QueueStatus.inConsultation, 3),
          queued('d', QueueStatus.waitingClinician, 4),
        ],
        expected: [],
        fetchedAt: fetchedAt,
        now: fetchedAt,
      );
      expect(board.waiting, 2);
    });

    test('an estimate of zero seconds is no estimate, not a zero-minute wait', () {
      final board = buildBoard(
        positions: [
          BoardPosition(
            appointment: appointment(
              id: 'a',
              status: QueueStatus.arrived,
              checkedInAt: DateTime.utc(2026, 9, 16, 9),
            ),
            position: 1,
            estimatedWaitSeconds: 0,
          ),
        ],
        expected: [],
        fetchedAt: fetchedAt,
        now: fetchedAt,
      );
      expect(board.rows.single.estimatedWaitMinutes, isNull);
    });

    test('the token and the priority can never be hidden by a saved view', () {
      // Hiding the token makes it impossible to call the next patient; hiding
      // the priority hides why somebody was moved up (SRS-SCH-011).
      expect(receptionWorklist.mandatoryColumns, containsAll(['token', 'priority']));
      expect(
        () => validateView(
          receptionWorklist,
          SavedView(
            id: 'v1',
            name: 'Minimal',
            worklist: 'reception-board',
            columns: [
              for (final c in receptionWorklist.columns)
                c.copyWith(visible: c.key != 'token'),
            ],
          ),
        ),
        throwsA(isA<InvalidViewError>()),
      );
    });
  });
}
