import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/config/environment.dart';
import 'package:health_mobile/src/gen/healthcare/identity_access/v1/identity.pb.dart';
import 'package:health_mobile/src/offline/operation_queue.dart';
import 'package:health_mobile/src/ui/app_shell.dart';
import 'package:health_mobile/src/workspace/navigation.dart';

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
    // SRS-WEB-003, first half: the active tenant and facility are displayed
    // prominently. The requirement's other half — that a context switch is
    // explicit and cannot silently carry patient context — has no switch to
    // test yet; see docs/engineering/wave-0-status.md.
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

    // SRS-WEB-004. The workspace is built from permissions elsewhere and
    // tested there; these assert that the shell actually renders it, which is
    // the part a unit test of the builder cannot see.
    group('workspace navigation', () {
      Future<void> openDrawer(WidgetTester tester, Workspace? workspace) async {
        await tester.pumpWidget(wrap(AppShell(
          config: const AppConfig(
            apiBaseUrl: 'http://x',
            environment: Environment.production,
          ),
          title: 'Facilities',
          workspace: workspace,
          child: const SizedBox(),
        )));
        if (workspace != null) {
          await tester.tap(find.byTooltip('Open navigation menu'));
          await tester.pumpAndSettle();
        }
      }

      testWidgets('offers the entries the permissions allow', (tester) async {
        await openDrawer(
          tester,
          buildWorkspace(waveZeroCatalogue, [
            'organization.facility.read',
            'organization.facility.create',
          ]),
        );

        expect(find.byKey(const Key('nav-facilities')), findsOneWidget);
        expect(find.byKey(const Key('quick-action-new-facility')), findsOneWidget);

        // Not held, so not offered. The endpoint behind it is still there and
        // still refuses: hiding the link is a courtesy, not the control.
        expect(find.byKey(const Key('nav-org-units')), findsNothing);
        expect(find.byKey(const Key('worklist-pending-approvals')), findsNothing);
      });

      testWidgets('warns before an action that finalizes something', (tester) async {
        await openDrawer(
          tester,
          buildWorkspace(waveZeroCatalogue, ['organization.master_data.approve']),
        );

        expect(find.byKey(const Key('quick-action-approve-change')), findsOneWidget);
        expect(find.text('Opens a confirmation step'), findsOneWidget);
      });

      testWidgets('explains an empty workspace rather than showing a blank drawer',
          (tester) async {
        await openDrawer(tester, buildWorkspace(waveZeroCatalogue, const []));

        expect(find.textContaining('An administrator can grant them'), findsOneWidget);
      });

      testWidgets('offers no menu at all when signed out', (tester) async {
        await openDrawer(tester, null);

        expect(find.byTooltip('Open navigation menu'), findsNothing);
      });

      testWidgets('the workspace menu meets the platform guidelines', (tester) async {
        final handle = tester.ensureSemantics();
        await openDrawer(
          tester,
          buildWorkspace(waveZeroCatalogue, [
            'organization.facility.read',
            'organization.unit.read',
            'organization.master_data.approve',
          ]),
        );

        await expectLater(tester, meetsGuideline(textContrastGuideline));
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

        handle.dispose();
      });
    });
  });
}
