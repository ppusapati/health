import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/reception/board.dart';
import 'package:health_mobile/src/reception/search.dart';
import 'package:health_mobile/src/screens/reception_screen.dart';

Board boardWith({
  List<BoardRow> rows = const [],
  bool stale = false,
  int ageSeconds = 0,
  int waiting = 0,
}) =>
    Board(
      rows: rows,
      waiting: waiting,
      serviceMinutes: null,
      estimateObserved: false,
      activeClinicians: 0,
      empty: rows.isEmpty,
      ageSeconds: ageSeconds,
      stale: stale,
    );

BoardRow row({
  String id = 'a1',
  String token = 'A7',
  QueueStatus status = QueueStatus.scheduled,
  bool canCheckIn = true,
  String priorityReason = '',
  QueuePriority priority = QueuePriority.standard,
}) =>
    BoardRow(
      appointmentId: id,
      patientId: 'p-$id',
      token: token,
      status: status,
      statusLabel: describeStatus(status),
      priority: priority,
      priorityReason: priorityReason,
      arrivalMode: ArrivalMode.scheduled,
      scheduledAt: DateTime.utc(2026, 9, 16, 9),
      position: null,
      waitedMinutes: null,
      estimatedWaitMinutes: null,
      withClinician: false,
      canCheckIn: canCheckIn,
      version: 1,
    );

PresentedMatch candidate(String id, MatchOutcome outcome) => presentMatch(
      patientId: id, displayName: 'Anita Sharma', confidence: 0.9,
      outcome: outcome,
    );

Future<void> pump(WidgetTester tester, Widget child) =>
    tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));

void main() {
  group('the board', () {
    testWidgets('shows the token, not the patient name', (tester) async {
      // This screen is held up at a desk a waiting room can see.
      await pump(tester, ReceptionScreen(view: ReceptionView(
        board: boardWith(rows: [row(token: 'B12')]),
      )));
      expect(find.text('B12'), findsOneWidget);
      expect(find.textContaining('Sharma'), findsNothing);
    });

    testWidgets('a stale board says so in words, with its age', (tester) async {
      await pump(tester, ReceptionScreen(view: ReceptionView(
        board: boardWith(rows: [row()], stale: true, ageSeconds: 95),
      )));
      final freshness = tester.widget<Text>(find.byKey(const Key('board-freshness')));
      expect(freshness.data, contains('95 seconds old'));
      expect(freshness.data, contains('Refresh'));
    });

    testWidgets('a fresh board does not warn', (tester) async {
      await pump(tester, ReceptionScreen(view: ReceptionView(
        board: boardWith(rows: [row()]),
      )));
      final freshness = tester.widget<Text>(find.byKey(const Key('board-freshness')));
      expect(freshness.data, 'Updated just now.');
    });

    testWidgets('a raised priority always shows its reason', (tester) async {
      // SRS-SCH-011: the reason somebody was moved up stays visible.
      await pump(tester, ReceptionScreen(view: ReceptionView(
        board: boardWith(rows: [
          row(priority: QueuePriority.immediate, priorityReason: 'chest pain'),
        ]),
      )));
      expect(find.textContaining('chest pain'), findsOneWidget);
    });

    testWidgets('check-in is offered only where the row allows it', (tester) async {
      await pump(tester, ReceptionScreen(view: ReceptionView(
        board: boardWith(rows: [
          row(id: 'expected', canCheckIn: true),
          row(id: 'here', status: QueueStatus.arrived, canCheckIn: false),
        ]),
      )));
      expect(find.byKey(const Key('check-in-expected')), findsOneWidget);
      expect(find.byKey(const Key('check-in-here')), findsNothing);
    });

    testWidgets('an empty board explains itself rather than showing nothing',
        (tester) async {
      await pump(tester, ReceptionScreen(view: ReceptionView(board: boardWith())));
      expect(find.textContaining('Nobody is waiting'), findsOneWidget);
    });

    testWidgets('checking in reports the row it was asked about', (tester) async {
      BoardRow? checkedIn;
      await pump(tester, ReceptionScreen(
        view: ReceptionView(board: boardWith(rows: [row(id: 'a9')])),
        onCheckIn: (r) => checkedIn = r,
      ));
      await tester.tap(find.byKey(const Key('check-in-a9')));
      expect(checkedIn?.appointmentId, 'a9');
    });
  });

  group('search before create', () {
    Future<void> openSearch(WidgetTester tester) async {
      await tester.tap(find.text('Find a patient'));
      await tester.pumpAndSettle();
    }

    testWidgets('the register button is absent before anybody has searched',
        (tester) async {
      // Absent, not disabled. A disabled button invites hunting for the
      // permission that would enable it; the truth is that the work has not
      // been done yet.
      await pump(tester, ReceptionScreen(view: ReceptionView(board: boardWith())));
      await openSearch(tester);
      expect(find.byKey(const Key('register-patient')), findsNothing);
      expect(
        tester.widget<Text>(find.byKey(const Key('gate-message'))).data,
        contains('Search for the patient before registering'),
      );
    });

    testWidgets('a clear search offers registration', (tester) async {
      await pump(tester, ReceptionScreen(view: ReceptionView(
        board: boardWith(), searched: true,
      )));
      await openSearch(tester);
      expect(find.byKey(const Key('register-patient')), findsOneWidget);
    });

    testWidgets('a blocking candidate keeps the button away', (tester) async {
      await pump(tester, ReceptionScreen(view: ReceptionView(
        board: boardWith(),
        searched: true,
        matches: [candidate('p1', MatchOutcome.probable)],
      )));
      await openSearch(tester);
      expect(find.byKey(const Key('register-patient')), findsNothing);
      expect(find.byKey(const Key('acknowledge-p1')), findsOneWidget);
    });

    testWidgets('acknowledging every blocker brings the button back',
        (tester) async {
      await pump(tester, ReceptionScreen(view: ReceptionView(
        board: boardWith(),
        searched: true,
        matches: [candidate('p1', MatchOutcome.probable)],
        acknowledged: ['p1'],
      )));
      await openSearch(tester);
      expect(find.byKey(const Key('register-patient')), findsOneWidget);
      // The acknowledgement is visible as a state, not just as an absence.
      final ack = tester.widget<TextButton>(find.byKey(const Key('acknowledge-p1')));
      expect(ack.onPressed, isNull);
    });

    testWidgets('a candidate is described in a sentence, not a percentage',
        (tester) async {
      await pump(tester, ReceptionScreen(view: ReceptionView(
        board: boardWith(),
        searched: true,
        matches: [candidate('p1', MatchOutcome.probable)],
      )));
      await openSearch(tester);
      expect(find.text('Almost certainly the same person'), findsOneWidget);
      expect(find.textContaining('90%'), findsNothing);
    });

    testWidgets('an unreadable match outcome still blocks the button',
        (tester) async {
      // The gate must not open because a newer server said something this
      // build cannot name.
      await pump(tester, ReceptionScreen(view: ReceptionView(
        board: boardWith(),
        searched: true,
        matches: [candidate('p1', MatchOutcome.unrecognised)],
      )));
      await openSearch(tester);
      expect(find.byKey(const Key('register-patient')), findsNothing);
    });

    testWidgets('a refused search is explained', (tester) async {
      await pump(tester, ReceptionScreen(view: ReceptionView(
        board: boardWith(),
        searchProblem: 'Use at least two letters of the name.',
      )));
      await openSearch(tester);
      expect(find.textContaining('at least two letters'), findsOneWidget);
    });

    testWidgets('searching reports what was typed', (tester) async {
      SearchCriteria? asked;
      await pump(tester, ReceptionScreen(
        view: ReceptionView(board: boardWith()),
        onSearch: (c) => asked = c,
      ));
      await openSearch(tester);
      await tester.enterText(find.byKey(const Key('search-name')), 'Anita');
      await tester.enterText(
          find.byKey(const Key('search-birth-date')), '1984-02-11');
      await tester.tap(find.byKey(const Key('run-search')));
      expect(asked?.name, 'Anita');
      expect(asked?.birthDate, '1984-02-11');
    });

    testWidgets('a masked row says so rather than looking complete',
        (tester) async {
      final masked = presentMatch(
        patientId: 'p1', displayName: 'Anita Sharma', confidence: 0.9,
        outcome: MatchOutcome.review, masked: true,
      );
      await pump(tester, ReceptionScreen(view: ReceptionView(
        board: boardWith(), searched: true, matches: [masked],
      )));
      await openSearch(tester);
      expect(find.textContaining('hidden by your access level'), findsOneWidget);
    });
  });

  group('states', () {
    testWidgets('loading with nothing yet shows the loading state',
        (tester) async {
      await pump(tester, const ReceptionScreen(view: null, loading: true));
      expect(find.textContaining('Loading the board'), findsOneWidget);
    });

    testWidgets('a failure with nothing yet offers a retry', (tester) async {
      var retried = false;
      await pump(tester, ReceptionScreen(
        view: null,
        failure: 'The desk system is not answering.',
        onRetry: () => retried = true,
      ));
      expect(find.textContaining('not answering'), findsOneWidget);
      await tester.tap(find.text('Try again'));
      expect(retried, isTrue);
    });

    testWidgets('a failure with a board still shows the board', (tester) async {
      // A receptionist with a queue in front of them needs the rows they had.
      await pump(tester, ReceptionScreen(
        view: ReceptionView(board: boardWith(rows: [row(token: 'C3')])),
        failure: 'Could not refresh.',
      ));
      expect(find.text('C3'), findsOneWidget);
      expect(find.textContaining('Could not refresh'), findsOneWidget);
    });

    testWidgets('meets the platform accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, ReceptionScreen(view: ReceptionView(
        board: boardWith(rows: [row(priorityReason: 'chest pain')], waiting: 3),
        searched: true,
        matches: [candidate('p1', MatchOutcome.review)],
      )));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });
  });
}
