/// The patient picker as a screen, and switching patients through the shell.
///
/// The picker's reasoning is tested in `caseload_test.dart`. These are about
/// what a nurse can reach, what a scanner does without anybody touching the
/// screen, and the one navigation the draft guard refuses outright.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/main.dart';
import 'package:health_mobile/src/auth/secure_store.dart';
import 'package:health_mobile/src/auth/session.dart';
import 'package:health_mobile/src/config/environment.dart';
import 'package:health_mobile/src/drafts/guard.dart';
import 'package:health_mobile/src/gen/healthcare/identity_access/v1/identity.pb.dart';
import 'package:health_mobile/src/offline/operation_queue.dart';
import 'package:health_mobile/src/patient/caseload.dart';
import 'package:health_mobile/src/screens/patient_picker_screen.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

CaseloadPatient patient({
  String id = 'p1',
  String name = 'Asha Rao',
  String bed = 'Bed 1',
  int tasks = 0,
  int doses = 0,
  bool allergy = false,
}) =>
    CaseloadPatient(
      patientId: id,
      encounterId: 'enc-$id',
      displayName: name,
      bed: bed,
      unit: 'Ward A',
      outstandingTasks: tasks,
      dosesDue: doses,
      hasHighCriticalityAllergy: allergy,
    );

void main() {
  group('the caseload', () {
    testWidgets('opens on the nurse\'s own patients', (tester) async {
      await tester.pumpWidget(host(PatientPickerScreen(
        view: CaseloadView(patients: [
          patient(id: 'a', name: 'Asha Rao'),
          patient(id: 'b', name: 'Meera Iyer', bed: 'Bed 2'),
        ]),
      )));

      expect(find.byKey(const Key('patient-a')), findsOneWidget);
      expect(find.byKey(const Key('patient-b')), findsOneWidget);
    });

    testWidgets('a row says where the patient is and what is outstanding',
        (tester) async {
      // So the round can be planned from the list rather than by opening every
      // patient in turn.
      await tester.pumpWidget(host(PatientPickerScreen(
        view: CaseloadView(
          patients: [patient(tasks: 3, doses: 2, allergy: true)],
        ),
      )));

      expect(find.textContaining('Ward A · Bed 1'), findsOneWidget);
      expect(find.textContaining('3 outstanding'), findsOneWidget);
      expect(find.textContaining('2 due'), findsOneWidget);
      expect(find.textContaining('Allergy alert'), findsOneWidget);
    });

    testWidgets('an empty caseload is not a dead end', (tester) async {
      await tester.pumpWidget(host(
        const PatientPickerScreen(view: CaseloadView(patients: [])),
      ));

      expect(find.byKey(const Key('screen-state-empty')), findsOneWidget);
      // The other two ways in are named, and both are on the screen above.
      expect(find.textContaining('Scan a wristband or search'), findsOneWidget);
      expect(find.byKey(const Key('scan-band')), findsOneWidget);
    });

    testWidgets('picking a patient does not claim their identity was checked',
        (tester) async {
      PatientSelection? chosen;
      await tester.pumpWidget(host(PatientPickerScreen(
        view: CaseloadView(patients: [patient()]),
        onSelect: (selection) => chosen = selection,
      )));

      await tester.tap(find.byKey(const Key('patient-p1')));
      await tester.pump();

      expect(chosen?.method, SelectionMethod.caseload);
      expect(chosen?.identityVerified, isFalse);
    });
  });

  group('scanning', () {
    testWidgets('a scanner submits without anybody touching the screen',
        (tester) async {
      // A barcode scanner types and presses enter. Requiring a button press
      // would mean holding a tablet, a scanner and a drug chart at once.
      String? scanned;
      await tester.pumpWidget(host(PatientPickerScreen(
        view: const CaseloadView(patients: []),
        onScan: (barcode) => scanned = barcode,
      )));

      await tester.enterText(find.byKey(const Key('scan-band')), 'band-123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(scanned, 'band-123');
    });

    testWidgets('the field clears so the next scan is not appended',
        (tester) async {
      await tester.pumpWidget(host(PatientPickerScreen(
        view: const CaseloadView(patients: []),
        onScan: (_) {},
      )));

      await tester.enterText(find.byKey(const Key('scan-band')), 'band-123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(find.text('band-123'), findsNothing);
    });

    testWidgets('a scan that found nothing says so, and does not search',
        (tester) async {
      await tester.pumpWidget(host(const PatientPickerScreen(
        view: CaseloadView(
          patients: [],
          scanProblem: 'No patient here has the band band-999. '
              'Check the band, or find the patient by name.',
        ),
      )));

      expect(find.byKey(const Key('screen-state-failure')), findsOneWidget);
      expect(find.textContaining('band-999'), findsOneWidget);
    });

    testWidgets('an ambiguous band refuses rather than offering a choice',
        (tester) async {
      await tester.pumpWidget(host(const PatientPickerScreen(
        view: CaseloadView(
          patients: [],
          scanProblem: 'More than one patient has the band band-dup. '
              'Do not proceed from this band — tell the ward clerk.',
        ),
      )));

      expect(find.textContaining('Do not proceed'), findsOneWidget);
    });
  });

  group('searching', () {
    Future<void> openSearch(WidgetTester tester, CaseloadView view) async {
      await tester.pumpWidget(host(PatientPickerScreen(
        view: view,
        onSearch: (_) {},
        onSelect: (_) {},
      )));
      await tester.tap(find.byKey(const Key('toggle-search')));
      await tester.pump();
    }

    testWidgets('warns that a search does not confirm who the patient is',
        (tester) async {
      await openSearch(tester, const CaseloadView(patients: []));

      expect(find.byKey(const Key('search-name')), findsOneWidget);
      expect(find.textContaining('check the wristband at the bedside'),
          findsOneWidget);
    });

    testWidgets('"not searched" and "no matches" are different screens',
        (tester) async {
      await openSearch(tester, const CaseloadView(patients: []));
      expect(find.byKey(const Key('screen-state-awaitingInput')), findsOneWidget);

      await openSearch(
        tester,
        const CaseloadView(patients: [], searched: true, searchResults: []),
      );
      expect(find.byKey(const Key('screen-state-empty')), findsOneWidget);
    });

    testWidgets('a search result is selected as unverified', (tester) async {
      PatientSelection? chosen;
      await tester.pumpWidget(host(PatientPickerScreen(
        view: CaseloadView(
          patients: const [],
          searched: true,
          searchResults: [patient(id: 'p7', name: 'Ravi Menon')],
        ),
        onSearch: (_) {},
        onSelect: (selection) => chosen = selection,
      )));
      await tester.tap(find.byKey(const Key('toggle-search')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('patient-p7')));
      await tester.pump();

      expect(chosen?.method, SelectionMethod.search);
      expect(chosen?.identityVerified, isFalse);
    });
  });

  testWidgets('the picker meets the platform accessibility guidelines',
      (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(host(PatientPickerScreen(
      view: CaseloadView(patients: [
        patient(id: 'a', tasks: 3, allergy: true),
        patient(id: 'b', name: 'Meera Iyer', bed: 'Bed 12', doses: 1),
      ]),
      onSelect: (_) {},
      onScan: (_) {},
      onSearch: (_) {},
    )));

    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    handle.dispose();
  });

  group('reaching the picker through the shell', () {
    late DraftRegistry drafts;

    setUp(() => drafts = DraftRegistry());

    Future<SessionManager> nurse() async {
      final session = SessionManager(InMemorySecureStore());
      await session.signIn(
        token: 'tenant-a:nurse-1:nurse',
        context: SessionContext(
          subjectId: 'nurse-1',
          tenantId: 'tenant-a',
          activeFacilityId: 'facility-1',
          permissions: ['nursing.task.read', 'nursing.administration.read'],
        ),
      );
      return session;
    }

    Widget app(SessionManager session) => HealthApp(
          config: const AppConfig(
            apiBaseUrl: 'http://127.0.0.1:1',
            environment: Environment.development,
          ),
          session: session,
          queue: OperationQueue(InMemoryQueueStorage()),
          drafts: drafts,
        );

    Future<void> settle(WidgetTester tester) async {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
    }

    testWidgets('the drawer reaches My patients', (tester) async {
      await tester.pumpWidget(app(await nurse()));
      await settle(tester);

      await tester.tap(find.byTooltip('Open navigation menu'));
      await settle(tester);
      await tester.tap(find.byKey(const Key('nav-patients')));
      await settle(tester);

      expect(find.byType(PatientPickerScreen), findsOneWidget);
      expect(find.text('My patients'), findsWidgets);
    });

    testWidgets('the picker is the screen that fetches on arrival',
        (tester) async {
      // The clinical screens are about a patient; loading them before one is
      // chosen would be asking the server about nobody.
      await tester.pumpWidget(app(await nurse()));
      await settle(tester);

      await tester.tap(find.byTooltip('Open navigation menu'));
      await settle(tester);
      await tester.tap(find.byKey(const Key('nav-patients')));
      await settle(tester);

      // The fetch fails against a closed port, which is the proof it was made.
      expect(find.byKey(const Key('screen-state-failure')), findsOneWidget);
    });
  });
}
