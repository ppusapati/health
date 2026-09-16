import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/meds/prescribe.dart';
import 'package:health_mobile/src/screens/prescribe_screen.dart';

PrescriptionDraft draft({
  String ingredient = 'Amoxicillin',
  String route = 'oral',
  String indication = 'chest infection',
  String amount = '500',
  String unit = 'mg',
  String freeText = '',
  String drugClass = '',
}) =>
    PrescriptionDraft(
      patientId: 'p1',
      encounterId: 'e1',
      ingredientDisplay: ingredient,
      drugClass: drugClass,
      route: route,
      dose: DoseDraft(amount: amount, unit: unit, freeText: freeText),
      indication: indication,
    );

PresentedFinding finding({
  String ruleId = 'r1',
  Severity severity = Severity.severe,
  String existing = '',
}) =>
    presentFinding(
      ruleId: ruleId,
      kind: FindingKind.interaction,
      severity: severity,
      summary: 'Interacts with warfarin',
      subjects: const ['Warfarin'],
      existingOverrideReason: existing,
    );

QueueEntry queued(String id, Severity severity) => QueueEntry(
      prescriptionId: id,
      patientId: 'p-$id',
      description: 'Warfarin 5 mg oral',
      prescriberId: 'dr1',
      createdAt: DateTime.utc(2026, 9, 16, 9),
      worstSeverity: severity,
    );

/// A viewport tall enough to hold the whole composer.
///
/// Not a cosmetic choice. The composer is a ListView, which does not build the
/// children below the fold at all — so on the default 800x600 surface a
/// `findsNothing` for the prescribe button passes whether the button is absent
/// because the gate refused it or merely because it is off-screen, and half
/// these tests would be asserting nothing.
Future<void> pump(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(1200, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
}

Future<void> openComposer(WidgetTester tester) async {
  await tester.tap(find.text('Prescribe'));
  await tester.pumpAndSettle();
}

Future<void> openQueue(WidgetTester tester) async {
  await tester.tap(find.text('Verify'));
  await tester.pumpAndSettle();
}

void main() {
  group('the composer', () {
    testWidgets('a complete prescription offers the button', (tester) async {
      await pump(tester, PrescribeScreen(view: PrescribeView(draft: draft())));
      await openComposer(tester);
      expect(find.byKey(const Key('prescribe')), findsOneWidget);
    });

    testWidgets('a missing indication removes it rather than disabling it',
        (tester) async {
      // A disabled button reads as a permission problem, when what is missing
      // is a sentence only the prescriber can write.
      await pump(tester,
          PrescribeScreen(view: PrescribeView(draft: draft(indication: ''))));
      await openComposer(tester);
      expect(find.byKey(const Key('prescribe')), findsNothing);
      expect(find.textContaining('Give the indication.'), findsWidgets);
    });

    testWidgets('a class that needs a structured dose refuses free text',
        (tester) async {
      await pump(
        tester,
        PrescribeScreen(
          view: PrescribeView(
            draft: draft(amount: '', unit: '', freeText: 'as directed',
                drugClass: 'anticoagulant'),
            structuredDoseClasses: const ['anticoagulant'],
          ),
        ),
      );
      await openComposer(tester);
      expect(find.byKey(const Key('prescribe')), findsNothing);
      expect(find.textContaining('cannot read free text'), findsWidgets);
    });

    testWidgets('the same free text is fine for an unconfigured class',
        (tester) async {
      await pump(
        tester,
        PrescribeScreen(
          view: PrescribeView(
            draft: draft(amount: '', unit: '', freeText: 'two puffs as needed',
                drugClass: 'inhaled bronchodilator'),
            structuredDoseClasses: const ['anticoagulant'],
          ),
        ),
      );
      await openComposer(tester);
      expect(find.byKey(const Key('prescribe')), findsOneWidget);
    });
  });

  group('the safety panel', () {
    testWidgets('a contraindication offers no reason box at all',
        (tester) async {
      // The one severity where the answer is no rather than why. An empty box
      // under it would say the opposite.
      await pump(
        tester,
        PrescribeScreen(
          view: PrescribeView(
            draft: draft(),
            findings: [finding(severity: Severity.contraindicated)],
          ),
        ),
      );
      await openComposer(tester);
      expect(find.byKey(const Key('reason-r1')), findsNothing);
      expect(find.byKey(const Key('prescribe')), findsNothing);
      expect(find.textContaining('cannot be prescribed here'), findsWidgets);
    });

    testWidgets('an overridable finding asks for a reason against its own rule',
        (tester) async {
      await pump(
        tester,
        PrescribeScreen(
          view: PrescribeView(
            draft: draft(),
            findings: [finding(ruleId: 'r1'), finding(ruleId: 'r2')],
          ),
        ),
      );
      await openComposer(tester);
      expect(find.byKey(const Key('reason-r1')), findsOneWidget);
      expect(find.byKey(const Key('reason-r2')), findsOneWidget);
      expect(find.byKey(const Key('prescribe')), findsNothing);
    });

    testWidgets('a reason for one rule does not clear another', (tester) async {
      await pump(
        tester,
        PrescribeScreen(
          view: PrescribeView(
            draft: draft(),
            findings: [finding(ruleId: 'r1'), finding(ruleId: 'r2')],
            answers: const {'r1': 'considered'},
          ),
        ),
      );
      await openComposer(tester);
      expect(find.byKey(const Key('prescribe')), findsNothing);
    });

    testWidgets('a reason against every rule unblocks it', (tester) async {
      await pump(
        tester,
        PrescribeScreen(
          view: PrescribeView(
            draft: draft(),
            findings: [finding(ruleId: 'r1'), finding(ruleId: 'r2')],
            answers: const {'r1': 'considered', 'r2': 'INR monitored'},
          ),
        ),
      );
      await openComposer(tester);
      expect(find.byKey(const Key('prescribe')), findsOneWidget);
    });

    testWidgets('an informational finding is shown and does not gate',
        (tester) async {
      await pump(
        tester,
        PrescribeScreen(
          view: PrescribeView(
            draft: draft(),
            findings: [finding(severity: Severity.informational)],
          ),
        ),
      );
      await openComposer(tester);
      expect(find.byKey(const Key('finding-r1')), findsOneWidget);
      expect(find.byKey(const Key('reason-r1')), findsNothing);
      expect(find.byKey(const Key('prescribe')), findsOneWidget);
    });

    testWidgets('the findings name what they are about', (tester) async {
      // "An interaction exists" without saying with what is a warning nobody
      // can act on.
      await pump(
        tester,
        PrescribeScreen(
          view: PrescribeView(draft: draft(), findings: [finding()]),
        ),
      );
      await openComposer(tester);
      expect(find.text('Warfarin'), findsOneWidget);
    });

    testWidgets('typing a reason reaches the caller keyed by rule',
        (tester) async {
      final given = <String, String>{};
      await pump(
        tester,
        PrescribeScreen(
          view: PrescribeView(draft: draft(), findings: [finding()]),
          onReasonChanged: (ruleId, reason) => given[ruleId] = reason,
        ),
      );
      await openComposer(tester);
      await tester.enterText(find.byKey(const Key('reason-r1')), 'monitored');
      expect(given, {'r1': 'monitored'});
    });
  });

  group('the formulary notice', () {
    testWidgets('never blocks, and says what it takes', (tester) async {
      await pump(
        tester,
        PrescribeScreen(
          view: PrescribeView(
            draft: draft(),
            formulary: formularyNotice(
              status: FormularyStatus.nonFormulary,
              approvalPath: 'Consultant microbiologist approval',
            ),
          ),
        ),
      );
      await openComposer(tester);
      expect(find.text('Not on formulary'), findsOneWidget);
      expect(find.text('Consultant microbiologist approval'), findsOneWidget);
      // Still prescribable: a hard block here produces a phone call and a
      // handwritten chart.
      expect(find.byKey(const Key('prescribe')), findsOneWidget);
    });
  });

  group('the verification queue', () {
    testWidgets('is not offered to somebody who cannot verify', (tester) async {
      await pump(tester, PrescribeScreen(view: PrescribeView(draft: draft())));
      expect(find.text('Verify'), findsNothing);
    });

    testWidgets('puts the most serious first', (tester) async {
      await pump(
        tester,
        PrescribeScreen(
          view: PrescribeView(
            draft: draft(),
            mayVerify: true,
            queue: [
              queued('mild', Severity.mild),
              queued('stop', Severity.contraindicated),
              queued('severe', Severity.severe),
            ],
          ),
        ),
      );
      await openQueue(tester);
      final cards = tester.widgetList<Card>(find.byType(Card)).toList();
      expect(
        cards.map((c) => (c.key! as ValueKey<String>).value),
        ['queued-stop', 'queued-severe', 'queued-mild'],
      );
    });

    testWidgets('verifying reaches the caller', (tester) async {
      String? verified;
      await pump(
        tester,
        PrescribeScreen(
          view: PrescribeView(
            draft: draft(),
            mayVerify: true,
            queue: [queued('rx1', Severity.mild)],
          ),
          onVerify: (entry) => verified = entry.prescriptionId,
        ),
      );
      await openQueue(tester);
      await tester.tap(find.byKey(const Key('verify-rx1')));
      expect(verified, 'rx1');
    });

    testWidgets('an empty queue says so rather than looking broken',
        (tester) async {
      await pump(
        tester,
        PrescribeScreen(
          view: PrescribeView(draft: draft(), mayVerify: true),
        ),
      );
      await openQueue(tester);
      expect(find.textContaining('Nothing waiting'), findsOneWidget);
    });
  });

  group('what the patient is already on', () {
    testWidgets('names the status and whether pharmacy has seen it',
        (tester) async {
      await pump(
        tester,
        PrescribeScreen(
          view: PrescribeView(
            draft: draft(),
            therapies: [
              QueueEntry(
                prescriptionId: 'rx1',
                patientId: 'p1',
                description: 'Warfarin 5 mg oral',
                createdAt: DateTime.utc(2026, 9, 16, 9),
                therapyStatus: TherapyStatus.active,
              ),
            ],
          ),
        ),
      );
      expect(find.text('Warfarin 5 mg oral'), findsOneWidget);
      expect(find.textContaining('Awaiting pharmacy verification'),
          findsOneWidget);
    });
  });

  testWidgets('the screen meets the platform accessibility guidelines',
      (tester) async {
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      PrescribeScreen(
        view: PrescribeView(
          draft: draft(),
          findings: [finding()],
          formulary: formularyNotice(status: FormularyStatus.restricted,
              restriction: 'ICU only'),
          mayVerify: true,
          queue: [queued('rx1', Severity.severe)],
        ),
      ),
    );
    await openComposer(tester);
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    handle.dispose();
  });
}
