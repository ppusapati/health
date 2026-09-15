/// The ward worklist and medication round as screens.
///
/// The logic behind them is tested in `ward_worklist_test.dart`,
/// `meds_round_test.dart` and `patient_banner_test.dart`. These tests are about
/// what reaches a nurse's eyes and ears: that the allergy line is spoken, that
/// a queued dose is never called given, and that both screens meet the platform
/// accessibility guidelines — including on their failure paths, which are the
/// ones read under pressure.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/meds/round.dart';
import 'package:health_mobile/src/meds/submission.dart';
import 'package:health_mobile/src/patient/banner.dart';
import 'package:health_mobile/src/screens/medication_round_screen.dart';
import 'package:health_mobile/src/screens/ward_worklist_screen.dart';
import 'package:health_mobile/src/ward/worklist.dart';

final _now = DateTime.utc(2026, 9, 15, 10, 0);

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

PatientBanner banner({
  List<BannerAllergy> allergies = const [],
  bool allergiesRecorded = true,
  bool deceased = false,
}) =>
    bannerFor(
      patientId: 'patient-1',
      given: 'Asha',
      family: 'Rao',
      birthDate: DateTime.utc(1990, 6, 1),
      sex: Sex.female,
      now: _now,
      allergies: allergies,
      allergiesRecorded: allergiesRecorded,
      deceased: deceased,
    );

PresentedTask task({
  String id = 't1',
  String description = 'Record observations',
  TaskPriority priority = TaskPriority.routine,
  TaskStatus status = TaskStatus.pending,
  bool overdue = false,
  int? overdueBy,
  String escalatedTo = '',
}) =>
    presentTask(
      taskId: id,
      patientId: 'patient-1',
      description: description,
      priority: priority,
      status: status,
      dueAt: overdueBy == null ? null : _now.subtract(Duration(minutes: overdueBy)),
      overdue: overdue,
      escalatedTo: escalatedTo,
      sourceKind: 'care-plan',
      version: 1,
      now: _now,
    );

WardWorklistView wardView({List<PresentedTask>? tasks, PatientBanner? bar}) {
  final list = tasks ?? [task()];
  return WardWorklistView(
    banner: bar ?? banner(),
    tasks: orderTasks(list),
    summary: summarise(list),
  );
}

PresentedDose dose({
  String orderId = 'order-1',
  bool outstanding = true,
  bool overdue = false,
  int lateBy = 0,
  bool verified = true,
  AdministrationOutcome? recorded,
}) =>
    presentDose(
      orderId: orderId,
      medication: 'Paracetamol',
      doseValue: 500,
      doseUnit: 'mg',
      route: 'oral',
      scheduledAt: _now.subtract(Duration(minutes: lateBy)),
      outstanding: outstanding,
      overdue: overdue,
      prn: false,
      verifiedByPharmacy: verified,
      recordedOutcome: recorded,
      now: _now,
    );

void main() {
  group('the ward worklist', () {
    testWidgets('shows the outstanding work and says what it adds up to',
        (tester) async {
      await tester.pumpWidget(host(WardWorklistScreen(
        view: wardView(tasks: [
          task(id: 'a', description: 'Reposition', overdue: true, overdueBy: 40),
          task(id: 'b', description: 'Pressure area check'),
        ]),
      )));

      expect(find.byKey(const Key('task-a')), findsOneWidget);
      expect(find.byKey(const Key('task-b')), findsOneWidget);
      expect(find.bySemanticsLabel('2 outstanding, 1 overdue, 0 escalated, 0 critical'),
          findsOneWidget);
    });

    testWidgets('a worklist with nothing on it says so rather than going blank',
        (tester) async {
      await tester.pumpWidget(host(WardWorklistScreen(view: wardView(tasks: []))));

      expect(find.byKey(const Key('screen-state-empty')), findsOneWidget);
      expect(find.text('Nothing outstanding'), findsWidgets);
    });

    testWidgets('with no patient chosen it waits rather than showing empty',
        (tester) async {
      await tester.pumpWidget(host(const WardWorklistScreen(view: null)));
      expect(find.byKey(const Key('screen-state-awaitingInput')), findsOneWidget);
      expect(find.byKey(const Key('screen-state-empty')), findsNothing);
    });

    testWidgets('a failure with rows already on screen keeps the rows',
        (tester) async {
      await tester.pumpWidget(host(WardWorklistScreen(
        view: wardView(),
        failure: 'You appear to be offline.',
        onRetry: () {},
      )));

      expect(find.byKey(const Key('task-t1')), findsOneWidget);
      expect(find.byKey(const Key('screen-state-failure')), findsOneWidget);
    });

    testWidgets('a task is recorded through the callback, not by the row',
        (tester) async {
      PresentedTask? recorded;
      await tester.pumpWidget(host(WardWorklistScreen(
        view: wardView(),
        onCompleteTask: (t) => recorded = t,
      )));

      await tester.tap(find.text('Record'));
      expect(recorded?.taskId, 't1');
    });

    testWidgets('a closed record offers no way to chart against it', (tester) async {
      await tester.pumpWidget(host(WardWorklistScreen(
        view: wardView(bar: banner(deceased: true)),
        onChartObservation: () {},
      )));

      final button = tester.widget<FilledButton>(
        find.byKey(const Key('chart-observation')),
      );
      expect(button.onPressed, isNull);
    });
  });

  group('the patient banner', () {
    testWidgets('speaks the allergies as part of one sentence', (tester) async {
      await tester.pumpWidget(host(WardWorklistScreen(
        view: wardView(
          bar: banner(allergies: [
            const BannerAllergy(
              substance: 'Penicillin',
              reaction: 'Anaphylaxis',
              criticality: AllergyCriticality.high,
              status: AllergyStatus.active,
            ),
          ]),
        ),
      )));

      expect(
        find.bySemanticsLabel(
            'Asha Rao. 36y. Female. Allergies: Penicillin — Anaphylaxis'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('allergy-Penicillin')), findsOneWidget);
    });

    testWidgets('an unasked allergy question is visibly different from none',
        (tester) async {
      await tester.pumpWidget(host(WardWorklistScreen(
        view: wardView(bar: banner(allergiesRecorded: false)),
      )));

      expect(find.byKey(const Key('allergies-unknown')), findsOneWidget);
      expect(find.byKey(const Key('allergies-none')), findsNothing);
      expect(find.textContaining('ask before giving anything'), findsOneWidget);
    });

    testWidgets('no known allergies is stated, not left blank', (tester) async {
      await tester.pumpWidget(host(WardWorklistScreen(view: wardView())));

      expect(find.byKey(const Key('allergies-none')), findsOneWidget);
      expect(find.text('No known allergies'), findsOneWidget);
    });
  });

  group('the medication round', () {
    MedicationRoundView roundView({
      List<PresentedDose>? doses,
      RoundPolicy policy = RoundPolicy.strict,
      Map<String, Submission> submissions = const {},
      PatientBanner? bar,
    }) =>
        MedicationRoundView(
          banner: bar ?? banner(),
          doses: orderDoses(doses ?? [dose()]),
          policy: policy,
          submissions: submissions,
        );

    testWidgets('says up front whether this ward requires scanning',
        (tester) async {
      // Before the round rather than at the first tile, so a nurse whose
      // scanner is flat finds out now and not at the bedside.
      await tester.pumpWidget(host(MedicationRoundScreen(view: roundView())));
      expect(
        find.bySemanticsLabel('1 dose outstanding. Scanning is required on this ward'),
        findsOneWidget,
      );
    });

    testWidgets('a queued dose is never called given', (tester) async {
      await tester.pumpWidget(host(MedicationRoundScreen(
        view: roundView(submissions: {
          'order-1': const Submission(
            state: SubmissionState.queued,
            idempotencyKey: 'idem-1',
          ),
        }),
      )));

      expect(find.textContaining('Saved on this device, not yet sent'),
          findsOneWidget);
      expect(find.textContaining('Given'), findsNothing);
      expect(find.textContaining('Recorded'), findsNothing);
    });

    testWidgets('a confirmed dose says so', (tester) async {
      await tester.pumpWidget(host(MedicationRoundScreen(
        view: roundView(submissions: {
          'order-1': const Submission(
            state: SubmissionState.confirmed,
            idempotencyKey: 'idem-1',
          ),
        }),
      )));
      expect(find.textContaining('Recorded'), findsOneWidget);
    });

    testWidgets('a failed dose says it is not recorded, and why', (tester) async {
      await tester.pumpWidget(host(MedicationRoundScreen(
        view: roundView(submissions: {
          'order-1': const Submission(
            state: SubmissionState.failed,
            idempotencyKey: 'idem-1',
            message: 'That action is not available right now.',
          ),
        }),
      )));

      expect(find.textContaining('Not recorded'), findsOneWidget);
      expect(find.textContaining('not available right now'), findsOneWidget);
    });

    testWidgets('an unverified drug says so before it is given', (tester) async {
      await tester.pumpWidget(host(MedicationRoundScreen(
        view: roundView(doses: [dose(verified: false)]),
      )));
      expect(find.textContaining('Not verified by pharmacy'), findsOneWidget);
    });

    testWidgets('a round with nothing due says so', (tester) async {
      await tester.pumpWidget(host(MedicationRoundScreen(
        view: roundView(doses: []),
      )));
      expect(find.byKey(const Key('screen-state-empty')), findsOneWidget);
    });

    testWidgets('a closed record offers no Record button', (tester) async {
      await tester.pumpWidget(host(MedicationRoundScreen(
        view: roundView(bar: banner(deceased: true)),
        onRecord: (_) {},
      )));
      expect(find.text('Record'), findsNothing);
    });

    testWidgets('recording goes through the callback', (tester) async {
      PresentedDose? chosen;
      await tester.pumpWidget(host(MedicationRoundScreen(
        view: roundView(),
        onRecord: (d) => chosen = d,
      )));

      await tester.tap(find.text('Record'));
      expect(chosen?.orderId, 'order-1');
    });
  });

  group('accessibility', () {
    Future<void> check(WidgetTester tester, Widget screen) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(host(screen));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    }

    testWidgets('the worklist meets the platform guidelines', (tester) async {
      await check(
        tester,
        WardWorklistScreen(
          view: wardView(tasks: [
            task(id: 'a', overdue: true, overdueBy: 90, priority: TaskPriority.critical),
            task(id: 'b', escalatedTo: 'charge-nurse'),
          ]),
          onCompleteTask: (_) {},
          onChartObservation: () {},
        ),
      );
    });

    testWidgets('the worklist failure path meets them too', (tester) async {
      // The path read under pressure is the one that gets shipped unexamined.
      await check(
        tester,
        WardWorklistScreen(
          view: null,
          failure: 'You appear to be offline.',
          onRetry: () {},
        ),
      );
    });

    testWidgets('the medication round meets the platform guidelines',
        (tester) async {
      await check(
        tester,
        MedicationRoundScreen(
          view: MedicationRoundView(
            banner: banner(allergies: [
              const BannerAllergy(
                substance: 'Penicillin',
                reaction: 'Anaphylaxis',
                criticality: AllergyCriticality.high,
                status: AllergyStatus.active,
              ),
            ]),
            doses: orderDoses([
              dose(orderId: 'a', overdue: true, lateBy: 75, verified: false),
              dose(orderId: 'b', recorded: AdministrationOutcome.refused),
            ]),
            policy: RoundPolicy.strict,
          ),
          onRecord: (_) {},
        ),
      );
    });
  });
}
