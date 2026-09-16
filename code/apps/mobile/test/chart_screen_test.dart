import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/chart/notes.dart';
import 'package:health_mobile/src/chart/safety.dart';
import 'package:health_mobile/src/screens/chart_screen.dart';

ChartDocument doc({
  String id = 'd1',
  DocumentStatus status = DocumentStatus.draft,
  bool intact = true,
  bool dictated = false,
}) =>
    ChartDocument(
      documentId: id,
      title: 'Ward round',
      status: status,
      authoredBy: 'Dr Rao',
      createdAt: DateTime.utc(2026, 9, 16, 9),
      intact: intact,
      dictated: dictated,
    );

PresentedAllergy allergy({
  String id = 'a1',
  String substance = 'Penicillin',
  Criticality criticality = Criticality.high,
  Verification verification = Verification.confirmed,
}) =>
    presentAllergy(
      allergyId: id, substance: substance, kind: AllergyKind.allergy,
      criticality: criticality, verification: verification,
    );

PresentedObservation obs({
  String id = 'o1',
  double? value = 7.4,
  String unit = 'mmol/L',
  Interpretation interpretation = Interpretation.normal,
  String source = 'Central Laboratory',
}) =>
    presentObservation(
      observationId: id, display: 'Glucose',
      effectiveAt: DateTime.utc(2026, 9, 16, 9),
      interpretation: interpretation, value: value, unit: unit,
      interpretationSource: source,
    );

Future<void> pump(WidgetTester tester, Widget child) =>
    tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));

void main() {
  group('the allergy panel', () {
    testWidgets('an empty panel says nothing is recorded, not "no allergies"',
        (tester) async {
      await pump(tester, const ChartScreen(view: ChartView()));
      final text = tester.widget<Text>(find.byKey(const Key('allergies-unrecorded')));
      expect(text.data, contains('Nothing recorded'));
      expect(text.data!.toLowerCase(), isNot(contains('no known')));
    });

    testWidgets('a high-risk allergy is drawn prominently', (tester) async {
      await pump(tester, ChartScreen(view: ChartView(allergies: [allergy()])));
      expect(find.byIcon(Icons.warning_amber), findsOneWidget);
    });

    testWidgets('unable to assess is drawn like a high risk, not a low one',
        (tester) async {
      await pump(tester, ChartScreen(view: ChartView(
        allergies: [allergy(criticality: Criticality.unableToAssess)],
      )));
      expect(find.byIcon(Icons.warning_amber), findsOneWidget);
      expect(find.textContaining('Could not be assessed'), findsOneWidget);
    });

    testWidgets('a ruled-out allergy is struck through, not removed',
        (tester) async {
      await pump(tester, ChartScreen(view: ChartView(
        allergies: [allergy(verification: Verification.refuted)],
      )));
      expect(find.text('Penicillin'), findsOneWidget);
      expect(find.textContaining('Ruled out'), findsOneWidget);
    });

    testWidgets('criticality is stated in words, not colour alone',
        (tester) async {
      await pump(tester, ChartScreen(view: ChartView(allergies: [allergy()])));
      expect(find.textContaining('High risk'), findsOneWidget);
    });
  });

  group('results', () {
    testWidgets('a trend across units refuses and explains why', (tester) async {
      await pump(tester, ChartScreen(view: ChartView(observations: [
        obs(id: 'a', value: 7.4, unit: 'mmol/L'),
        obs(id: 'b', value: 133, unit: 'mg/dL'),
      ])));
      final refusal = tester.widget<Text>(find.byKey(const Key('trend-refused')));
      expect(refusal.data, contains('more than one unit'));
      expect(refusal.data, contains('change that did not happen'));
    });

    testWidgets('a single-unit series is not refused', (tester) async {
      await pump(tester, ChartScreen(view: ChartView(observations: [
        obs(id: 'a'), obs(id: 'b', value: 8.1),
      ])));
      expect(find.byKey(const Key('trend-refused')), findsNothing);
    });

    testWidgets('who flagged a result is shown beside it', (tester) async {
      await pump(tester, ChartScreen(view: ChartView(observations: [
        obs(interpretation: Interpretation.criticalHigh),
      ])));
      expect(find.textContaining('Flagged by Central Laboratory'), findsOneWidget);
    });

    testWidgets('a critical result is marked', (tester) async {
      await pump(tester, ChartScreen(view: ChartView(observations: [
        obs(interpretation: Interpretation.criticalLow),
      ])));
      expect(find.byIcon(Icons.priority_high), findsOneWidget);
    });

    testWidgets('an uninterpreted result does not read as normal',
        (tester) async {
      await pump(tester, ChartScreen(view: ChartView(observations: [
        obs(interpretation: Interpretation.unknown),
      ])));
      expect(find.text('Not interpreted'), findsOneWidget);
      expect(find.text('Normal'), findsNothing);
    });
  });

  group('notes', () {
    testWidgets('a draft offers Sign', (tester) async {
      await pump(tester, ChartScreen(view: ChartView(
        documents: [doc()], mayWrite: true,
      )));
      expect(find.byKey(const Key('sign-d1')), findsOneWidget);
    });

    testWidgets('a signed note has no edit control anywhere', (tester) async {
      await pump(tester, ChartScreen(view: ChartView(
        documents: [doc(status: DocumentStatus.signed)], mayWrite: true,
      )));
      expect(find.text('Edit'), findsNothing);
      expect(find.byKey(const Key('sign-d1')), findsNothing);
      expect(find.byKey(const Key('amend-d1')), findsOneWidget);
      expect(find.byKey(const Key('addendum-d1')), findsOneWidget);
    });

    testWidgets('the two corrections are labelled as the question, not the record\'s words',
        (tester) async {
      await pump(tester, ChartScreen(view: ChartView(
        documents: [doc(status: DocumentStatus.signed)], mayWrite: true,
      )));
      expect(find.text('Correct what this note says'), findsOneWidget);
      expect(find.text('Add something that arrived later'), findsOneWidget);
    });

    testWidgets('a broken signature offers nothing and says so', (tester) async {
      await pump(tester, ChartScreen(view: ChartView(
        documents: [doc(status: DocumentStatus.signed, intact: false)],
        mayWrite: true,
      )));
      expect(find.byKey(const Key('broken-signature')), findsOneWidget);
      expect(find.byKey(const Key('amend-d1')), findsNothing);
      expect(find.byKey(const Key('addendum-d1')), findsNothing);
      expect(find.byKey(const Key('sign-d1')), findsNothing);
      expect(
        tester.widget<Text>(find.byKey(const Key('blocked-d1'))).data,
        contains('do not amend'),
      );
    });

    testWidgets('a read-only viewer is told why, and offered nothing',
        (tester) async {
      await pump(tester, ChartScreen(view: ChartView(
        documents: [doc()], mayWrite: false,
      )));
      expect(
        tester.widget<Text>(find.byKey(const Key('blocked-d1'))).data,
        contains('read-only'),
      );
      expect(find.byKey(const Key('sign-d1')), findsNothing);
    });

    testWidgets('a dictated note is marked as dictated', (tester) async {
      await pump(tester, ChartScreen(view: ChartView(
        documents: [doc(dictated: true)], mayWrite: true,
      )));
      expect(find.text('Dictated'), findsOneWidget);
    });

    testWidgets('an unreadable status offers nothing and sends you elsewhere',
        (tester) async {
      await pump(tester, ChartScreen(view: ChartView(
        documents: [doc(status: DocumentStatus.unrecognised)], mayWrite: true,
      )));
      expect(find.byKey(const Key('sign-d1')), findsNothing);
      expect(find.byKey(const Key('amend-d1')), findsNothing);
      expect(
        tester.widget<Text>(find.byKey(const Key('blocked-d1'))).data,
        contains('desktop'),
      );
    });

    testWidgets('correcting reports which kind was chosen', (tester) async {
      CorrectionKind? chosen;
      await pump(tester, ChartScreen(
        view: ChartView(
          documents: [doc(status: DocumentStatus.signed)], mayWrite: true,
        ),
        onCorrect: (_, kind) => chosen = kind,
      ));
      await tester.tap(find.byKey(const Key('addendum-d1')));
      expect(chosen, CorrectionKind.addendum);
    });
  });

  group('states', () {
    testWidgets('loading with nothing yet says so', (tester) async {
      await pump(tester, const ChartScreen(view: null, loading: true));
      expect(find.textContaining('Loading the chart'), findsOneWidget);
    });

    testWidgets('a failure with nothing yet offers a retry', (tester) async {
      var retried = false;
      await pump(tester, ChartScreen(
        view: null, failure: 'Cannot reach the record.',
        onRetry: () => retried = true,
      ));
      await tester.tap(find.text('Try again'));
      expect(retried, isTrue);
    });

    testWidgets('a failure with a chart still shows the chart', (tester) async {
      await pump(tester, ChartScreen(
        view: ChartView(allergies: [allergy()]),
        failure: 'Could not refresh.',
      ));
      expect(find.text('Penicillin'), findsOneWidget);
    });

    testWidgets('meets the platform accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, ChartScreen(view: ChartView(
        allergies: [allergy(), allergy(id: 'a2', substance: 'Latex',
            criticality: Criticality.unableToAssess)],
        problems: [presentProblem(
          problemId: 'p1', code: 'E11', display: 'Type 2 diabetes',
          status: ProblemStatus.active,
        )],
        observations: [obs(interpretation: Interpretation.criticalHigh)],
        documents: [doc(status: DocumentStatus.signed)],
        mayWrite: true,
      )));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });
  });
}
