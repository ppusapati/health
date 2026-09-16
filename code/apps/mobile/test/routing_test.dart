/// Getting from the drawer to a screen, and being stopped on the way.
///
/// The part of routing worth testing here is not that a tap changes a widget.
/// It is that leaving a screen can be refused: a half-entered observation is
/// work the nurse has done, and navigating away from it silently is the most
/// ordinary way to lose clinical work.
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
import 'package:health_mobile/src/screens/medication_round_screen.dart';
import 'package:health_mobile/src/screens/ward_worklist_screen.dart';
import 'package:health_mobile/src/workspace/router.dart';

DraftRegistry drafts = DraftRegistry();

/// A nurse who may see everything a ward device offers.
Future<SessionManager> wardNurse() async {
  final session = SessionManager(InMemorySecureStore());
  await session.signIn(
    token: 'tenant-a:nurse-1:nurse',
    context: SessionContext(
      subjectId: 'nurse-1',
      tenantId: 'tenant-a',
      activeFacilityId: 'facility-1',
      permissions: [
        'organization.facility.read',
        'nursing.task.read',
        'nursing.administration.read',
      ],
    ),
  );
  return session;
}

Widget app(SessionManager session) => HealthApp(
      config: const AppConfig(
        // Nothing here reaches the network: the assertions are about which
        // screen the shell is on, and each screen's own awaiting state is what
        // shows before any data arrives.
        apiBaseUrl: 'http://127.0.0.1:1',
        environment: Environment.development,
      ),
      session: session,
      queue: OperationQueue(InMemoryQueueStorage()),
      drafts: drafts,
    );

/// The signed-in shell renders a loading spinner, so `pumpAndSettle` never
/// returns. Pump twice instead: once for the frame, once past the transition.
Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> tapDrawer(WidgetTester tester, String key) async {
  await tester.tap(find.byTooltip('Open navigation menu'));
  await settle(tester);
  await tester.tap(find.byKey(Key(key)));
  await settle(tester);
}

void main() {
  setUp(() => drafts = DraftRegistry());

  group('the route table', () {
    test('every catalogue route names a screen this build has', () {
      // A drawer entry pointing at a screen nobody wrote is a blank page. This
      // is the check that turns it into a failing test instead.
      for (final route in routes.keys) {
        expect(destinationFor(route), isNotNull, reason: route);
      }
    });

    test('an unknown route is null, not a redirect home', () {
      // Silently landing somewhere else hides the mistake from the only person
      // who could fix it.
      expect(destinationFor('/nowhere'), isNull);
    });

    test('the ward and the round are distinct destinations', () {
      expect(destinationFor('/ward'), Destination.ward);
      expect(destinationFor('/medications/round'), Destination.medicationRound);
    });

    test('giving a medication and prescribing one are different screens', () {
      // Two halves of the same requirement and two different people. Sharing a
      // route would put the prescriber's composer in front of a nurse on a
      // round.
      expect(destinationFor('/medications/round'), Destination.medicationRound);
      expect(destinationFor('/medications/prescribe'), Destination.prescribing);
    });
  });

  group('navigating', () {
    testWidgets('the drawer reaches the ward worklist', (tester) async {
      await tester.pumpWidget(app(await wardNurse()));
      await settle(tester);

      await tapDrawer(tester, 'nav-ward');

      expect(find.byType(WardWorklistScreen), findsOneWidget);
      expect(find.text('Ward worklist'), findsWidgets);
    });

    testWidgets('the drawer reaches the medication round', (tester) async {
      await tester.pumpWidget(app(await wardNurse()));
      await settle(tester);

      await tapDrawer(tester, 'nav-medication-round');

      expect(find.byType(MedicationRoundScreen), findsOneWidget);
    });

    testWidgets('a worklist tile reaches the round too', (tester) async {
      await tester.pumpWidget(app(await wardNurse()));
      await settle(tester);

      await tapDrawer(tester, 'worklist-doses-due');

      expect(find.byType(MedicationRoundScreen), findsOneWidget);
    });

    testWidgets('a screen with nothing loaded asks for a patient', (tester) async {
      // Not an empty list, which would read as "this patient has no work".
      await tester.pumpWidget(app(await wardNurse()));
      await settle(tester);
      await tapDrawer(tester, 'nav-ward');

      expect(find.byKey(const Key('screen-state-awaitingInput')), findsOneWidget);
      expect(find.byKey(const Key('screen-state-empty')), findsNothing);
    });

    testWidgets('the drawer closes behind the navigation', (tester) async {
      await tester.pumpWidget(app(await wardNurse()));
      await settle(tester);
      await tapDrawer(tester, 'nav-ward');

      expect(find.byKey(const Key('nav-ward')), findsNothing);
    });

    testWidgets('signing out returns to the landing screen', (tester) async {
      // Leaving the shell on a ward screen would show whoever picks the tablet
      // up next the shape of the last person's work.
      final session = await wardNurse();
      await tester.pumpWidget(app(session));
      await settle(tester);
      await tapDrawer(tester, 'nav-ward');
      expect(find.byType(WardWorklistScreen), findsOneWidget);

      await tester.tap(find.byTooltip('Sign out'));
      await settle(tester);

      expect(find.byType(WardWorklistScreen), findsNothing);
      expect(find.byKey(const Key('screen-state-awaitingInput')), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
    });
  });

  group('the draft guard on a route change', () {
    void startObservation({String patient = 'patient-1'}) {
      drafts.register(Draft(
        id: 'observation',
        description: 'temperature observation',
        policy: DraftPolicy.blockPatientSwitch,
        patientRef: patient,
        dirty: true,
      ));
    }

    testWidgets('a clean screen navigates without a question', (tester) async {
      await tester.pumpWidget(app(await wardNurse()));
      await settle(tester);

      await tapDrawer(tester, 'nav-ward');

      expect(find.byKey(const Key('discard-drafts')), findsNothing);
      expect(find.byType(WardWorklistScreen), findsOneWidget);
    });

    testWidgets('unsaved work is named before it is discarded', (tester) async {
      await tester.pumpWidget(app(await wardNurse()));
      await settle(tester);
      startObservation();

      await tapDrawer(tester, 'nav-ward');

      expect(find.byKey(const Key('discard-drafts')), findsOneWidget);
      // Named, because "you have unsaved changes" is not enough to decide with.
      expect(find.textContaining('temperature observation'), findsOneWidget);
      // And the words name the action being taken. Offering to sign the nurse
      // out when they tapped a different screen is a dialog they answer wrongly.
      expect(find.text('Leave and discard unsaved work?'), findsOneWidget);
      expect(find.text('Discard and sign out'), findsNothing);
    });

    testWidgets('declining the prompt stays put', (tester) async {
      await tester.pumpWidget(app(await wardNurse()));
      await settle(tester);
      startObservation();

      await tapDrawer(tester, 'nav-ward');
      await tester.tap(find.text('Stay here'));
      await settle(tester);

      // The screen did not change. A prompt that navigates anyway is the bug
      // that teaches people to stop reading prompts.
      expect(find.byType(WardWorklistScreen), findsNothing);
    });

    testWidgets('confirming the discard navigates', (tester) async {
      await tester.pumpWidget(app(await wardNurse()));
      await settle(tester);
      startObservation();

      await tapDrawer(tester, 'nav-ward');
      await tester.tap(find.text('Discard and leave'));
      await settle(tester);

      expect(find.byType(WardWorklistScreen), findsOneWidget);
    });

    test('a route change is evaluated against the drafts, not assumed safe', () {
      startObservation();
      final decision =
          decideNavigation(route: '/ward', drafts: drafts);

      expect(decision.guard.prompt, isTrue);
      expect(decision.immediate, isFalse);
      expect(decision.destination, Destination.ward);
    });

    test('an unknown route still reports the unsaved work behind it', () {
      // So a shell that reports a bad route still knows not to throw the work
      // away on the way to reporting it.
      startObservation();
      final decision =
          decideNavigation(route: '/nowhere', drafts: drafts);

      expect(decision.unknownRoute, isTrue);
      expect(decision.guard.prompt, isTrue);
    });

    test('a clean shell navigates immediately', () {
      final decision = decideNavigation(route: '/ward', drafts: drafts);
      expect(decision.immediate, isTrue);
    });
  });

  group('accessibility', () {
    testWidgets('the ward screen reached through the drawer meets the guidelines',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(app(await wardNurse()));
      await settle(tester);
      await tapDrawer(tester, 'nav-ward');

      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      handle.dispose();
    });
  });
}
