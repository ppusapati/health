/// Recording an observation at the bedside.
///
/// The two things this form exists for: asking about a late entry while the
/// nurse still remembers, and being a draft the guard can protect.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/drafts/guard.dart';
import 'package:health_mobile/src/screens/observation_form.dart';
import 'package:health_mobile/src/ui/states.dart';

void main() {
  late DraftRegistry drafts;
  late DateTime clock;
  ObservationEntry? submitted;

  setUp(() {
    drafts = DraftRegistry();
    clock = DateTime.utc(2026, 9, 15, 10, 0);
    submitted = null;
  });

  Future<void> open(WidgetTester tester, {String patient = 'patient-1'}) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ObservationForm(
          patientRef: patient,
          label: 'Temperature',
          unit: '°C',
          drafts: drafts,
          now: () => clock,
          onSubmit: (entry) => submitted = entry,
        ),
      ),
    ));
  }

  group('recording', () {
    testWidgets('a reading taken now is recorded without further questions',
        (tester) async {
      await open(tester);
      await tester.enterText(find.byKey(const Key('observation-value')), '36.8');
      await tester.tap(find.byKey(const Key('observation-submit')));
      await tester.pump();

      expect(submitted?.numericValue, '36.8');
      expect(submitted?.lateEntryReason, '');
      expect(find.byKey(const Key('late-entry-reason')), findsNothing);
    });

    testWidgets('an empty reading is refused, against the field', (tester) async {
      await open(tester);
      await tester.tap(find.byKey(const Key('observation-submit')));
      await tester.pump();

      expect(submitted, isNull);
      expect(find.byType(FieldError), findsOneWidget);
      expect(find.bySemanticsLabel('Reading: Enter a reading.'), findsOneWidget);
    });

    testWidgets('the form does not complain before it has been used',
        (tester) async {
      // A form that complains about an empty field the moment it opens teaches
      // people to ignore it.
      await open(tester);
      expect(find.byType(FieldError), findsNothing);
    });

    testWidgets('a reading that is not a number is refused', (tester) async {
      await open(tester);
      await tester.enterText(
          find.byKey(const Key('observation-value')), 'thirty six');
      await tester.tap(find.byKey(const Key('observation-submit')));
      await tester.pump();

      expect(submitted, isNull);
      expect(find.bySemanticsLabel('Reading: That is not a number.'),
          findsOneWidget);
    });
  });

  group('the late-entry rule', () {
    Future<void> nudgeBack(WidgetTester tester, int times) async {
      for (var i = 0; i < times; i++) {
        await tester.tap(find.byKey(const Key('observed-earlier')));
        await tester.pump();
      }
    }

    testWidgets('nudging the time back says how long ago it was', (tester) async {
      await open(tester);
      await nudgeBack(tester, 2);
      expect(find.text('Taken 10 minutes ago'), findsOneWidget);
    });

    testWidgets('past the threshold the form asks why, unprompted',
        (tester) async {
      // The moment to ask is while the nurse still remembers, not when the
      // server refuses.
      await open(tester);
      expect(find.byKey(const Key('late-entry-reason')), findsNothing);

      await nudgeBack(tester, 4); // 20 minutes
      expect(find.byKey(const Key('late-entry-reason')), findsOneWidget);
    });

    testWidgets('a late entry without a reason is refused', (tester) async {
      await open(tester);
      await tester.enterText(find.byKey(const Key('observation-value')), '36.8');
      await nudgeBack(tester, 4);
      await tester.tap(find.byKey(const Key('observation-submit')));
      await tester.pump();

      expect(submitted, isNull);
      expect(find.textContaining('15 minutes ago'), findsOneWidget);
    });

    testWidgets('a late entry with a reason is recorded, reason and all',
        (tester) async {
      await open(tester);
      await tester.enterText(find.byKey(const Key('observation-value')), '36.8');
      await nudgeBack(tester, 4);
      await tester.enterText(find.byKey(const Key('late-entry-reason')),
          'Charted after the resuscitation');
      await tester.tap(find.byKey(const Key('observation-submit')));
      await tester.pump();

      expect(submitted?.lateEntryReason, 'Charted after the resuscitation');
      expect(submitted?.observedAt, clock.subtract(const Duration(minutes: 20)));
    });
  });

  group('the draft guard', () {
    testWidgets('an untouched form does not prompt on the way out',
        (tester) async {
      await open(tester);
      final decision = drafts.evaluateNavigation(const SignOut());
      expect(decision.prompt, isFalse);
    });

    testWidgets('a half-entered observation is unsaved work', (tester) async {
      await open(tester);
      await tester.enterText(find.byKey(const Key('observation-value')), '36');

      final decision = drafts.evaluateNavigation(const SignOut());
      expect(decision.prompt, isTrue);
      expect(describe(decision), contains('temperature observation'));
    });

    testWidgets('switching patients mid-observation is refused outright',
        (tester) async {
      // Not a prompt. Saving these numbers against the wrong chart is the
      // hazard, and there is no version of "are you sure" that makes it safe.
      await open(tester);
      await tester.enterText(find.byKey(const Key('observation-value')), '36');

      final decision =
          drafts.evaluateNavigation(const PatientSwitch('patient-2'));
      expect(decision.blocked, isTrue);
      expect(decision.allow, isFalse);
      expect(describe(decision), contains('patient-1'));
    });

    testWidgets('backgrounding must persist it rather than prompt',
        (tester) async {
      // A tablet in a pocket cannot answer a dialog.
      await open(tester);
      await tester.enterText(find.byKey(const Key('observation-value')), '36');

      final decision = drafts.evaluateNavigation(const Backgrounded());
      expect(decision.mustPersist, isTrue);
      expect(decision.prompt, isFalse);
    });

    testWidgets('a recorded observation is no longer unsaved work',
        (tester) async {
      await open(tester);
      await tester.enterText(find.byKey(const Key('observation-value')), '36.8');
      await tester.tap(find.byKey(const Key('observation-submit')));
      await tester.pump();

      expect(drafts.evaluateNavigation(const SignOut()).prompt, isFalse);
    });

    testWidgets('closing the form leaves no draft behind', (tester) async {
      // A leaked draft keeps prompting after its screen is gone.
      await open(tester);
      await tester.enterText(find.byKey(const Key('observation-value')), '36');
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));

      expect(drafts.open, isEmpty);
    });
  });

  testWidgets('the form meets the platform accessibility guidelines',
      (tester) async {
    final handle = tester.ensureSemantics();
    await open(tester);
    await tester.enterText(find.byKey(const Key('observation-value')), '36.8');
    await tester.tap(find.byKey(const Key('observed-earlier')));
    await tester.pump();

    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    handle.dispose();
  });
}
