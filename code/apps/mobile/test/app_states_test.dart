/// SRS-WEB-006 applied to the shell — the states are wired, not just available.
///
/// The failure these tests exist to catch is the one the Wave-0 review already
/// found twice: a module written, tested, and never reached by the running
/// application. Testing `ScreenState` in isolation proves the widget works; it
/// proves nothing about whether any screen uses it.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/main.dart';
import 'package:health_mobile/src/auth/secure_store.dart';
import 'package:health_mobile/src/auth/session.dart';
import 'package:health_mobile/src/config/environment.dart';
import 'package:health_mobile/src/gen/healthcare/identity_access/v1/identity.pb.dart';
import 'package:health_mobile/src/drafts/guard.dart';
import 'package:health_mobile/src/offline/operation_queue.dart';
import 'package:health_mobile/src/ui/states.dart';

DraftRegistry drafts = DraftRegistry();

Widget app({SessionManager? session}) => HealthApp(
      config: const AppConfig(
        // Nothing in these tests reaches the network: the assertions are about
        // what the shell renders before and instead of a request.
        apiBaseUrl: 'http://127.0.0.1:1',
        environment: Environment.development,
      ),
      session: session ?? SessionManager(InMemorySecureStore()),
      queue: OperationQueue(InMemoryQueueStorage()),
      drafts: drafts,
    );

/// A session established without a round trip, so the signed-in shell can be
/// examined without standing up a server.
Future<SessionManager> signedIn() async {
  final session = SessionManager(InMemorySecureStore());
  await session.signIn(
    token: 'tenant-a:nurse-1:nurse',
    context: SessionContext(
      subjectId: 'nurse-1',
      tenantId: 'tenant-a',
      activeFacilityId: 'facility-1',
      permissions: ['organization.facility.read'],
    ),
  );
  return session;
}


/// Pumps without waiting for the frame loop to go quiet.
///
/// The signed-in shell renders its loading state, and a progress indicator
/// animates forever, so `pumpAndSettle` never returns there.
Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  setUp(() => drafts = DraftRegistry());

  testWidgets('signed out, the shell says it is waiting for input', (tester) async {
    await tester.pumpWidget(app());

    // Not "empty" and not "loading". A screen that has asked for nothing looks
    // identical to one that asked and got nothing unless it says so.
    expect(find.byKey(const Key('screen-state-awaitingInput')), findsOneWidget);
    expect(find.byKey(const Key('screen-state-loading')), findsNothing);
    expect(find.byKey(const Key('screen-state-empty')), findsNothing);
  });

  testWidgets('an empty token is refused on the device, against the field', (tester) async {
    await tester.pumpWidget(app());

    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    // Named against the field, because a screen reader reads the message on its
    // own and "This field is required" without a field name is unusable.
    expect(find.byType(FieldError), findsOneWidget);
    expect(find.bySemanticsLabel('Token: This field is required.'), findsOneWidget);

    // And not rendered as a general screen failure: the correction is in the
    // form, so the message belongs in the form.
    expect(find.byKey(const Key('screen-state-failure')), findsNothing);
  });

  testWidgets('the field error clears once the field is filled and retried', (tester) async {
    await tester.pumpWidget(app());

    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    expect(find.byType(FieldError), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'tenant:subject:admin');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pump();

    // The request now goes out and will fail against a closed port, but the
    // field-level complaint must not survive the correction.
    expect(find.byType(FieldError), findsNothing);
    await tester.pumpAndSettle();
  });

  testWidgets('a failed sign-in is reported as a failure carrying its reference',
      (tester) async {
    await tester.pumpWidget(app());

    await tester.enterText(find.byType(TextField), 'tenant:subject:admin');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('screen-state-failure')), findsOneWidget);
    expect(find.textContaining('Reference:'), findsOneWidget);

    // Still signed out, and still able to try: a rejected token never leaves a
    // half-signed-in screen behind.
    expect(find.byKey(const Key('screen-state-awaitingInput')), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
  });

  testWidgets('the signed-out shell meets the platform accessibility guidelines',
      (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(app());

    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    handle.dispose();
  });

  testWidgets('a failed sign-in still meets the guidelines', (tester) async {
    // The error path is the one that gets shipped unexamined, and it is the one
    // being read under pressure.
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(app());

    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    handle.dispose();
  });

  group('signing out with unsaved work', () {
    testWidgets('signs out immediately when nothing is unsaved', (tester) async {
      await tester.pumpWidget(app(session: await signedIn()));
      await settle(tester);

      await tester.tap(find.byTooltip('Sign out'));
      await settle(tester);

      expect(find.byKey(const Key('discard-drafts')), findsNothing);
      expect(find.byKey(const Key('screen-state-awaitingInput')), findsOneWidget);
    });

    testWidgets('asks before discarding unsaved work, and names it', (tester) async {
      drafts.register(const Draft(
        id: 'note-1',
        description: 'progress note',
        policy: DraftPolicy.confirm,
        patientRef: 'patient-1',
        dirty: true,
      ));

      await tester.pumpWidget(app(session: await signedIn()));
      await settle(tester);

      await tester.tap(find.byTooltip('Sign out'));
      await settle(tester);

      // Named, because "you have unsaved changes" is not enough to decide with.
      expect(find.textContaining('progress note'), findsOneWidget);

      await tester.tap(find.text('Stay signed in'));
      await settle(tester);

      // Still signed in: declining the prompt must not sign the user out
      // anyway, which is the bug that makes people stop reading prompts.
      expect(find.byTooltip('Sign out'), findsOneWidget);
      expect(find.byKey(const Key('screen-state-awaitingInput')), findsNothing);
    });

    testWidgets('signs out when the user confirms the discard', (tester) async {
      drafts.register(const Draft(
        id: 'note-1',
        description: 'progress note',
        policy: DraftPolicy.confirm,
        patientRef: 'patient-1',
        dirty: true,
      ));

      await tester.pumpWidget(app(session: await signedIn()));
      await settle(tester);

      await tester.tap(find.byTooltip('Sign out'));
      await settle(tester);
      await tester.tap(find.text('Discard and sign out'));
      await settle(tester);

      expect(find.byKey(const Key('screen-state-awaitingInput')), findsOneWidget);
    });

    testWidgets('a saved draft does not prompt', (tester) async {
      drafts.register(const Draft(
        id: 'note-1',
        description: 'progress note',
        policy: DraftPolicy.confirm,
        patientRef: 'patient-1',
        dirty: false,
      ));

      await tester.pumpWidget(app(session: await signedIn()));
      await settle(tester);

      await tester.tap(find.byTooltip('Sign out'));
      await settle(tester);

      expect(find.byKey(const Key('discard-drafts')), findsNothing);
    });
  });
}
