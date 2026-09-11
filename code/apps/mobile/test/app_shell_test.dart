import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/config/environment.dart';
import 'package:health_mobile/src/gen/healthcare/identity_access/v1/identity.pb.dart';
import 'package:health_mobile/src/offline/operation_queue.dart';
import 'package:health_mobile/src/ui/app_shell.dart';

Widget wrap(Widget child) => MaterialApp(home: child);

void main() {
  group('AppShell', () {
    // Nobody should be able to enter real patient data into a test system
    // without seeing that it is one.
    testWidgets('shows an environment banner outside production', (tester) async {
      await tester.pumpWidget(wrap(AppShell(
        config: const AppConfig(apiBaseUrl: 'http://x', environment: Environment.development),
        title: 'Facilities',
        child: const SizedBox(),
      )));

      expect(find.byKey(const Key('environment-banner')), findsOneWidget);
      expect(find.textContaining('not for real patient data'), findsOneWidget);
    });

    testWidgets('hides the environment banner in production', (tester) async {
      await tester.pumpWidget(wrap(AppShell(
        config: const AppConfig(apiBaseUrl: 'http://x', environment: Environment.production),
        title: 'Facilities',
        child: const SizedBox(),
      )));

      expect(find.byKey(const Key('environment-banner')), findsNothing);
    });

    // Context first: the user must know which tenant and facility they are
    // acting in before they act.
    testWidgets('shows tenant and facility context when signed in', (tester) async {
      await tester.pumpWidget(wrap(AppShell(
        config: const AppConfig(apiBaseUrl: 'http://x', environment: Environment.production),
        title: 'Facilities',
        session: SessionContext(
          subjectId: 'nurse-1',
          tenantId: 'tenant-a',
          activeFacilityId: 'facility-1',
        ),
        child: const SizedBox(),
      )));

      expect(find.byKey(const Key('context-bar')), findsOneWidget);
      expect(find.text('tenant-a'), findsOneWidget);
      expect(find.text('facility-1'), findsOneWidget);
      expect(find.text('nurse-1'), findsOneWidget);
    });

    testWidgets('says so explicitly when no facility is selected', (tester) async {
      await tester.pumpWidget(wrap(AppShell(
        config: const AppConfig(apiBaseUrl: 'http://x', environment: Environment.production),
        title: 'Facilities',
        session: SessionContext(subjectId: 'nurse-1', tenantId: 'tenant-a'),
        child: const SizedBox(),
      )));

      expect(find.text('All facilities'), findsOneWidget);
    });

    // A break-glass override must be visible for its whole duration.
    testWidgets('shows a persistent break-glass indicator', (tester) async {
      await tester.pumpWidget(wrap(AppShell(
        config: const AppConfig(apiBaseUrl: 'http://x', environment: Environment.production),
        title: 'Facilities',
        session: SessionContext(
          subjectId: 'doctor-1',
          tenantId: 'tenant-a',
          breakGlassActive: true,
        ),
        child: const SizedBox(),
      )));

      expect(find.byKey(const Key('break-glass-indicator')), findsOneWidget);
    });

    // Queued work must be visible, or the user cannot tell saved from sent.
    testWidgets('shows queued work in the sync indicator', (tester) async {
      await tester.pumpWidget(wrap(AppShell(
        config: const AppConfig(apiBaseUrl: 'http://x', environment: Environment.production),
        title: 'Visits',
        queueCounts: const {QueuedStatus.pending: 3, QueuedStatus.sent: 10, QueuedStatus.failed: 0},
        child: const SizedBox(),
      )));

      expect(find.byKey(const Key('sync-indicator')), findsOneWidget);
      expect(find.textContaining('3 waiting to sync'), findsOneWidget);
    });

    testWidgets('hides the sync indicator when nothing is outstanding', (tester) async {
      await tester.pumpWidget(wrap(AppShell(
        config: const AppConfig(apiBaseUrl: 'http://x', environment: Environment.production),
        title: 'Visits',
        queueCounts: const {QueuedStatus.pending: 0, QueuedStatus.sent: 10, QueuedStatus.failed: 0},
        child: const SizedBox(),
      )));

      expect(find.byKey(const Key('sync-indicator')), findsNothing);
    });

    testWidgets('surfaces operations that need attention', (tester) async {
      await tester.pumpWidget(wrap(AppShell(
        config: const AppConfig(apiBaseUrl: 'http://x', environment: Environment.production),
        title: 'Visits',
        queueCounts: const {QueuedStatus.pending: 0, QueuedStatus.sent: 1, QueuedStatus.failed: 2},
        child: const SizedBox(),
      )));

      expect(find.textContaining('2 need attention'), findsOneWidget);
    });
  });
}
