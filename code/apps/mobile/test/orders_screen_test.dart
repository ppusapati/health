import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/orders/composer.dart';
import 'package:health_mobile/src/screens/orders_screen.dart';

OrderDraft draft({String indication = '', OrderType type = OrderType.imaging}) =>
    OrderDraft(
      type: type, patientId: 'p1', encounterId: 'e1',
      code: 'CT-CHEST', display: 'CT chest', indication: indication,
    );

DuplicateCandidate dup(String id) => DuplicateCandidate(
      orderId: id, number: 'ORD-$id', display: 'Potassium',
      status: OrderStatus.requested, placedAt: DateTime.utc(2026, 9, 16, 6),
    );

InboxItem item({String id = 'o1', int escalations = 0}) => InboxItem(
      observationId: id, patientId: 'p-$id', display: 'Potassium',
      value: '6.8 mmol/L', interpretationLabel: 'Critically high',
      effectiveAt: DateTime.utc(2026, 9, 16, 9),
      dueEscalations: escalations, waitingMinutes: 42,
    );

Future<void> pump(WidgetTester tester, Widget child) =>
    tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));

Future<void> openComposer(WidgetTester tester) async {
  await tester.tap(find.text('New order'));
  await tester.pumpAndSettle();
}

void main() {
  group('the composer', () {
    testWidgets('a missing required indication blocks the button', (tester) async {
      // Blocked, not warned beside it.
      await pump(tester, OrdersScreen(view: OrdersView(
        draft: draft(),
        policy: const OrderPolicy(
          type: OrderType.imaging, indicationRequired: true),
      )));
      await openComposer(tester);
      expect(find.byKey(const Key('place-order')), findsNothing);
    });

    testWidgets('the indication field carries the reason it is blocked',
        (tester) async {
      await pump(tester, OrdersScreen(view: OrdersView(
        draft: draft(),
        policy: const OrderPolicy(
          type: OrderType.imaging, indicationRequired: true),
      )));
      await openComposer(tester);
      expect(find.textContaining('needs a clinical indication'), findsWidgets);
    });

    testWidgets('an indication unblocks it', (tester) async {
      await pump(tester, OrdersScreen(view: OrdersView(
        draft: draft(indication: 'query PE'),
        policy: const OrderPolicy(
          type: OrderType.imaging, indicationRequired: true),
      )));
      await openComposer(tester);
      expect(find.byKey(const Key('place-order')), findsOneWidget);
    });

    testWidgets('the field is labelled required when it is', (tester) async {
      await pump(tester, OrdersScreen(view: OrdersView(
        draft: draft(),
        policy: const OrderPolicy(
          type: OrderType.imaging, indicationRequired: true),
      )));
      await openComposer(tester);
      expect(find.text('Clinical indication (required)'), findsOneWidget);
    });

    testWidgets('a duplicate is shown in full, not counted', (tester) async {
      // "A duplicate exists" without saying which one is a warning nobody can
      // act on.
      await pump(tester, OrdersScreen(view: OrdersView(
        draft: draft(indication: 'recheck'),
        gate: duplicateGate(
          candidates: [dup('o1')], overridable: true, windowSeconds: 14400),
      )));
      await openComposer(tester);
      expect(find.byKey(const Key('duplicate-o1')), findsOneWidget);
      expect(find.textContaining('ORD-o1'), findsOneWidget);
      expect(find.textContaining('Potassium'), findsOneWidget);
    });

    testWidgets('a duplicate keeps the button away until it is overridden',
        (tester) async {
      await pump(tester, OrdersScreen(view: OrdersView(
        draft: draft(indication: 'recheck'),
        gate: duplicateGate(
          candidates: [dup('o1')], overridable: true, windowSeconds: 14400),
      )));
      await openComposer(tester);
      expect(find.byKey(const Key('place-order')), findsNothing);
      expect(find.byKey(const Key('override-reason')), findsOneWidget);
    });

    testWidgets('an overridden duplicate brings the button back', (tester) async {
      await pump(tester, OrdersScreen(view: OrdersView(
        draft: draft(indication: 'recheck'),
        acknowledged: const ['o1'],
        gate: duplicateGate(
          candidates: [dup('o1')], overridable: true, windowSeconds: 14400,
          acknowledged: const ['o1'], reason: 'on an insulin infusion'),
      )));
      await openComposer(tester);
      expect(find.byKey(const Key('place-order')), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const Key('duplicate-message'))).data,
        contains('said why another is needed'),
      );
    });

    testWidgets('a refused duplicate offers no reason box at all',
        (tester) async {
      // Policy does not allow proceeding; a reason box would invite typing one
      // and then refusing anyway.
      await pump(tester, OrdersScreen(view: OrdersView(
        draft: draft(indication: 'recheck'),
        gate: duplicateGate(
          candidates: [dup('o1')], overridable: false, windowSeconds: 14400),
      )));
      await openComposer(tester);
      expect(find.byKey(const Key('override-reason')), findsNothing);
      expect(find.byKey(const Key('ack-dup-o1')), findsNothing);
      expect(find.byKey(const Key('place-order')), findsNothing);
      expect(find.textContaining('Use the existing order'), findsOneWidget);
    });

    testWidgets('acknowledging one duplicate reports which one', (tester) async {
      DuplicateCandidate? seen;
      await pump(tester, OrdersScreen(
        view: OrdersView(
          draft: draft(indication: 'recheck'),
          gate: duplicateGate(
            candidates: [dup('o1')], overridable: true, windowSeconds: 14400),
        ),
        onAcknowledgeDuplicate: (c) => seen = c,
      ));
      await openComposer(tester);
      await tester.tap(find.byKey(const Key('ack-dup-o1')));
      expect(seen?.orderId, 'o1');
    });

    testWidgets('an already-acknowledged duplicate shows as seen',
        (tester) async {
      await pump(tester, OrdersScreen(view: OrdersView(
        draft: draft(indication: 'recheck'),
        acknowledged: const ['o1'],
        gate: duplicateGate(
          candidates: [dup('o1')], overridable: true, windowSeconds: 14400,
          acknowledged: const ['o1']),
      )));
      await openComposer(tester);
      final button =
          tester.widget<TextButton>(find.byKey(const Key('ack-dup-o1')));
      expect(button.onPressed, isNull);
      expect(find.text('Seen'), findsOneWidget);
    });

    testWidgets('every outstanding problem is listed', (tester) async {
      await pump(tester, OrdersScreen(view: OrdersView(
        draft: const OrderDraft(
          type: OrderType.unspecified, patientId: '', encounterId: ''),
      )));
      await openComposer(tester);
      expect(find.textContaining('what kind of order'), findsOneWidget);
      expect(find.textContaining('not attached to a patient'), findsOneWidget);
      expect(find.textContaining('not attached to an encounter'), findsOneWidget);
    });
  });

  group('the results inbox', () {
    testWidgets('an empty inbox says so', (tester) async {
      await pump(tester, OrdersScreen(view: OrdersView(draft: draft())));
      expect(find.textContaining('No critical results waiting'), findsOneWidget);
    });

    testWidgets('every row says whose result it is', (tester) async {
      // Ward-wide: scoping to the open chart hides the results nobody is
      // looking at.
      await pump(tester, OrdersScreen(view: OrdersView(
        draft: draft(), inbox: [item()],
      )));
      expect(find.textContaining('Patient p-o1'), findsOneWidget);
    });

    testWidgets('an escalated result says nobody has acknowledged it',
        (tester) async {
      await pump(tester, OrdersScreen(view: OrdersView(
        draft: draft(), inbox: [item(escalations: 2)],
      )));
      expect(
        tester.widget<Text>(find.byKey(const Key('escalated-o1'))).data,
        contains('Escalated 2 times'),
      );
    });

    testWidgets('escalated results are drawn above fresher ones', (tester) async {
      await pump(tester, OrdersScreen(view: OrdersView(
        draft: draft(),
        inbox: [item(id: 'fresh'), item(id: 'escalated', escalations: 3)],
      )));
      final cards = tester.widgetList(find.byType(Card)).toList();
      expect(cards, hasLength(2));
      final first = find.descendant(
        of: find.byKey(const Key('inbox-escalated')),
        matching: find.textContaining('Escalated'),
      );
      expect(first, findsOneWidget);
      // The escalated card is first in the list order.
      final positions = tester.getTopLeft(find.byKey(const Key('inbox-escalated')));
      final other = tester.getTopLeft(find.byKey(const Key('inbox-fresh')));
      expect(positions.dy, lessThan(other.dy));
    });

    testWidgets('an empty action is refused with the reason', (tester) async {
      // SRS-CLN-012 asks what was done, not that somebody looked.
      await pump(tester, OrdersScreen(view: OrdersView(
        draft: draft(), inbox: [item()],
      )));
      expect(
        tester.widget<Text>(find.byKey(const Key('ack-problem-o1'))).data,
        contains('not only that it was seen'),
      );
    });

    testWidgets('acknowledging reports the action typed', (tester) async {
      String? action;
      await pump(tester, OrdersScreen(
        view: OrdersView(draft: draft(), inbox: [item()]),
        onAcknowledgeResult: (_, a) => action = a,
      ));
      await tester.enterText(
          find.byKey(const Key('action-o1')), 'Insulin stopped, recheck sent');
      await tester.tap(find.byKey(const Key('acknowledge-o1')));
      expect(action, 'Insulin stopped, recheck sent');
    });
  });

  group('states', () {
    testWidgets('loading with nothing yet says so', (tester) async {
      await pump(tester, const OrdersScreen(view: null, loading: true));
      expect(find.textContaining('Loading orders'), findsOneWidget);
    });

    testWidgets('a failure with nothing yet offers a retry', (tester) async {
      var retried = false;
      await pump(tester, OrdersScreen(
        view: null, failure: 'Cannot reach orders.',
        onRetry: () => retried = true,
      ));
      await tester.tap(find.text('Try again'));
      expect(retried, isTrue);
    });

    testWidgets('meets the platform accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, OrdersScreen(view: OrdersView(
        draft: draft(indication: 'recheck'),
        inbox: [item(escalations: 1)],
        gate: duplicateGate(
          candidates: [dup('o1')], overridable: true, windowSeconds: 14400),
      )));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });
  });
}
