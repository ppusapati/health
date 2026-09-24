/// SRS-NFR-007's verification clause: the release includes automated and
/// sampled manual verification against WCAG 2.2 AA. This is the automated half
/// on the device; the browser half runs in CI and the manual sample is held by
/// the release gate.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:health_mobile/src/config/environment.dart';
import 'package:health_mobile/src/gen/healthcare/identity_access/v1/identity.pb.dart';
import 'package:health_mobile/src/offline/operation_queue.dart';
import 'package:health_mobile/src/ui/app_shell.dart';
import 'package:health_mobile/src/ui/states.dart';

/// Automated accessibility gate (SRS-WEB-009, applied to mobile).
///
/// SRS-NFR's baseline says "web targets WCAG 2.2 AA; mobile equivalent
/// platform accessibility practices". Flutter's own guideline matchers are that
/// equivalent, and they check the three things a mobile app gets wrong that a
/// browser does not: a tap target too small for a thumb, a tappable widget with
/// no label for a screen reader, and text that fails contrast on a cheap panel
/// at a bad angle.
///
/// Two things are worth stating plainly, because an accessibility suite that
/// overstates what it proves is worse than none.
///
/// These matchers catch a subset. They find sizes, labels and contrast — real
/// defects, and the ones most often introduced by a routine change. They cannot
/// tell whether a label is *meaningful*, whether a traversal order makes sense
/// to somebody who cannot see the layout, or whether an error message explains
/// what to do. Those need the manual pass the release gate requires.
///
/// And they run against the widgets as this suite composes them. A screen that
/// is never pumped here is never checked, which is why the states below are
/// enumerated exhaustively rather than sampled.
void main() {
  Widget host(Widget child) => MaterialApp(
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF1C5FD6)),
        home: Scaffold(body: SingleChildScrollView(child: child)),
      );

  Future<void> meetsAll(WidgetTester tester) async {
    final handle = tester.ensureSemantics();
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    handle.dispose();
  }

  group('every screen state', () {
    for (final kind in ScreenStateKind.values) {
      testWidgets('${kind.name} meets the platform guidelines', (tester) async {
        await tester.pumpWidget(
          host(
            Padding(
              padding: const EdgeInsets.all(16),
              child: ScreenState(
                kind: kind,
                title: 'Nothing to show',
                detail: 'A longer sentence explaining what to do about it.',
                // Every state is checked with its action present: a tap target
                // that only appears in the failure state is a tap target the
                // other cases never exercise.
                onRetry: () {},
              ),
            ),
          ),
        );
        await meetsAll(tester);
      });
    }

    testWidgets('renders distinctly for each kind', (tester) async {
      // The failure this guards is a screen rendering several states
      // identically: an empty worklist and one the user may not see look the
      // same from outside and mean opposite things.
      for (final kind in ScreenStateKind.values) {
        await tester.pumpWidget(
          host(ScreenState(kind: kind, title: 'Title')),
        );
        expect(find.byKey(Key('screen-state-${kind.name}')), findsOneWidget);
      }
    });

    testWidgets('announces itself to assistive technology', (tester) async {
      // On a phone the screen is frequently not being looked at when the state
      // changes. A state that only changes colour is a state that is missed.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(const ScreenState(
          kind: ScreenStateKind.conflict,
          title: 'This changed while you were editing',
        )),
      );

      // The label is prefixed so a screen reader announces that something is
      // wrong before reading what, rather than after.
      expect(
        find.bySemanticsLabel('Error. This changed while you were editing'),
        findsOneWidget,
      );
      handle.dispose();
    });
  });

  group('the guidelines themselves', () {
    // Deliberately not the scrolling host above: the tap-target guideline skips
    // any node touching a scrollable's boundary, on the grounds that it may be
    // partially scrolled off screen. A bad widget placed in a scroll view is
    // therefore not reported, which would make these guards pass for the wrong
    // reason.
    Widget plain(Widget child) => MaterialApp(
          home: Scaffold(
            body: Padding(padding: const EdgeInsets.all(40), child: child),
          ),
        );

    // Every assertion above passes when it finds nothing wrong, so a matcher
    // that had stopped working would silently pass the whole suite rather than
    // fail it. These prove each guideline still fires on a known-bad widget.

    testWidgets('reject a tap target too small for a thumb', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        plain(
          Align(
            alignment: Alignment.topLeft,
            child: Semantics(
              label: 'Tiny',
              button: true,
              onTap: () {},
              child: Container(width: 20, height: 20, color: Colors.black),
            ),
          ),
        ),
      );
      await expectLater(tester, doesNotMeetGuideline(androidTapTargetGuideline));
      await expectLater(tester, doesNotMeetGuideline(iOSTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('reject a tappable widget with no label', (tester) async {
      // A screen reader announces it as "button" and nothing else, which is
      // the same as not having it.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        plain(
          Align(
            alignment: Alignment.topLeft,
            child: Semantics(
              button: true,
              onTap: () {},
              child: Container(width: 64, height: 64, color: Colors.black),
            ),
          ),
        ),
      );
      await expectLater(tester, doesNotMeetGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('reject text that fails contrast', (tester) async {
      // A ward terminal is often a cheap panel at a bad angle, and this is the
      // failure most easily introduced by a routine colour change.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: const Center(
              child: Text(
                'Barely legible',
                style: TextStyle(color: Color(0xFFEFEFEF), fontSize: 14),
              ),
            ),
          ),
        ),
      );
      await expectLater(tester, doesNotMeetGuideline(textContrastGuideline));
      handle.dispose();
    });
  });

  group('a field error', () {
    testWidgets('names the field it belongs to', (tester) async {
      // A screen reader reads the message on its own, and "This field is
      // required" with no field name is unusable.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(const FieldError(fieldLabel: 'Token', message: 'This field is required.')),
      );

      expect(
        find.bySemanticsLabel('Token: This field is required.'),
        findsOneWidget,
      );
      handle.dispose();
    });
  });

  group('the application shell', () {
    testWidgets('meets the platform guidelines signed out', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF1C5FD6)),
          home: AppShell(
            config: const AppConfig(
              apiBaseUrl: 'https://example.invalid',
              environment: Environment.development,
            ),
            title: 'Facilities',
            child: const ScreenState(
              kind: ScreenStateKind.awaitingInput,
              title: 'Sign in to continue',
            ),
          ),
        ),
      );
      await meetsAll(tester);
    });

    testWidgets('meets the platform guidelines with context and a sign-out action',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF1C5FD6)),
          home: AppShell(
            config: const AppConfig(
              apiBaseUrl: 'https://example.invalid',
              environment: Environment.development,
            ),
            title: 'Facilities',
            session: SessionContext(
              tenantId: 'tenant-1',
              subjectId: 'clerk-1',
              activeFacilityId: 'fac-1',
            ),
            queueCounts: const {QueuedStatus.pending: 2, QueuedStatus.failed: 1},
            onSignOut: () {},
            child: const SizedBox(height: 120),
          ),
        ),
      );
      await meetsAll(tester);
    });
  });
}
