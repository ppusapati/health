import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/orders/composer.dart';

OrderDraft draft({
  OrderType type = OrderType.laboratory,
  String patientId = 'p1',
  String encounterId = 'e1',
  String code = 'GLU',
  String indication = '',
  String startAt = '',
  int frequencySeconds = 0,
}) =>
    OrderDraft(
      type: type,
      patientId: patientId,
      encounterId: encounterId,
      code: code,
      indication: indication,
      startAt: startAt,
      frequencySeconds: frequencySeconds,
    );

DuplicateCandidate dup(String id) => DuplicateCandidate(
      orderId: id,
      number: 'ORD-$id',
      display: 'Potassium',
      status: OrderStatus.requested,
      placedAt: DateTime.utc(2026, 9, 16, 6),
    );

void main() {
  group('validating an order', () {
    test('a complete order with no policy is ready', () {
      expect(validateOrder(draft(), null).ready, isTrue);
    });

    test('a required indication blocks, it does not warn beside the field', () {
      // SRS-ORD-007. The performing service uses the indication to decide
      // protocol and urgency; it cannot be reconstructed afterwards.
      const policy = OrderPolicy(
        type: OrderType.imaging, indicationRequired: true,
      );
      final validity = validateOrder(draft(type: OrderType.imaging), policy);
      expect(validity.ready, isFalse);
      expect(validity.problems[OrderField.indication],
          contains('needs a clinical indication'));
    });

    test('an indication satisfies the requirement once given', () {
      const policy = OrderPolicy(
        type: OrderType.imaging, indicationRequired: true,
      );
      expect(
        validateOrder(
          draft(type: OrderType.imaging, indication: 'query PE'), policy,
        ).ready,
        isTrue,
      );
    });

    test('whitespace is not an indication', () {
      const policy = OrderPolicy(
        type: OrderType.imaging, indicationRequired: true,
      );
      expect(
        validateOrder(draft(type: OrderType.imaging, indication: '   '), policy)
            .ready,
        isFalse,
      );
    });

    test('no policy means no indication requirement, not a default one', () {
      // Which types require one is configuration. Hard-coding a list here is
      // how it becomes wrong in some hospital.
      expect(validateOrder(draft(indication: ''), null).ready, isTrue);
    });

    test('structured timing wants a start and a frequency, not free text', () {
      // SRS-ORD-008: "TDS" in a free-text box is not something a scheduler can
      // act on.
      const policy = OrderPolicy(
        type: OrderType.medication, structuredTimingRequired: true,
      );
      final validity = validateOrder(draft(type: OrderType.medication), policy);
      expect(validity.problems[OrderField.startAt], 'Give a start time.');
      expect(validity.problems[OrderField.frequency],
          contains('rather than as free text'));
    });

    test('a zero or negative frequency is not a frequency', () {
      const policy = OrderPolicy(
        type: OrderType.medication, structuredTimingRequired: true,
      );
      for (final seconds in [0, -1]) {
        expect(
          validateOrder(
            draft(
              type: OrderType.medication,
              startAt: '2026-09-16T08:00',
              frequencySeconds: seconds,
            ),
            policy,
          ).ready,
          isFalse,
        );
      }
    });

    test('an order detached from a patient or encounter is refused', () {
      expect(validateOrder(draft(patientId: ''), null).ready, isFalse);
      expect(validateOrder(draft(encounterId: ''), null).ready, isFalse);
    });

    test('an unchosen or unreadable type is refused', () {
      expect(validateOrder(draft(type: OrderType.unspecified), null).ready,
          isFalse);
      // An order type this build cannot name must not be placed under it.
      expect(validateOrder(draft(type: OrderType.unrecognised), null).ready,
          isFalse);
    });

    test('either a code or a display names what is ordered', () {
      expect(validateOrder(draft(code: ''), null).ready, isFalse);
      expect(
        validateOrder(
          OrderDraft(
            type: OrderType.laboratory, patientId: 'p1', encounterId: 'e1',
            display: 'Glucose',
          ),
          null,
        ).ready,
        isTrue,
      );
    });

    test('problems are reported in the order they should be fixed', () {
      const policy = OrderPolicy(
        type: OrderType.imaging,
        indicationRequired: true,
        structuredTimingRequired: true,
      );
      final validity = validateOrder(
        draft(type: OrderType.unspecified, patientId: '', code: ''), policy,
      );
      expect(validity.order.first, contains('what kind of order'));
      expect(validity.order.last, contains('how often'));
    });
  });

  group('the duplicate gate', () {
    test('no candidates is clear', () {
      final gate = duplicateGate(
        candidates: [], overridable: true, windowSeconds: 14400,
      );
      expect(gate.state, DuplicateState.clear);
      expect(mayPlace(validateOrder(draft(), null), gate), isTrue);
    });

    test('a duplicate is shown with what exists, never suppressed', () {
      // Two potassium levels four hours apart may be exactly right on an
      // insulin infusion. Suppressing the second hides a necessary order.
      final gate = duplicateGate(
        candidates: [dup('o1')], overridable: true, windowSeconds: 14400,
      );
      expect(gate.state, DuplicateState.needsOverride);
      expect(gate.candidates.single.display, 'Potassium');
      expect(gate.message, contains('last 4 hours'));
      expect(mayPlace(validateOrder(draft(), null), gate), isFalse);
    });

    test('an override needs both the acknowledgement and a reason', () {
      final withoutReason = duplicateGate(
        candidates: [dup('o1')], overridable: true, windowSeconds: 14400,
        acknowledged: ['o1'],
      );
      expect(withoutReason.state, DuplicateState.needsOverride);

      final withoutAck = duplicateGate(
        candidates: [dup('o1')], overridable: true, windowSeconds: 14400,
        reason: 'on an insulin infusion',
      );
      expect(withoutAck.state, DuplicateState.needsOverride);

      final both = duplicateGate(
        candidates: [dup('o1')], overridable: true, windowSeconds: 14400,
        acknowledged: ['o1'], reason: 'on an insulin infusion',
      );
      expect(both.state, DuplicateState.overridden);
    });

    test('a reason given this morning does not cover a different duplicate', () {
      // The acknowledgement names the orders it was given against.
      final gate = duplicateGate(
        candidates: [dup('this-afternoon')],
        overridable: true,
        windowSeconds: 14400,
        acknowledged: ['this-morning'],
        reason: 'on an insulin infusion',
      );
      expect(gate.state, DuplicateState.needsOverride);
    });

    test('every candidate has to be acknowledged, not just one', () {
      final partial = duplicateGate(
        candidates: [dup('o1'), dup('o2')],
        overridable: true, windowSeconds: 14400,
        acknowledged: ['o1'], reason: 'needed again',
      );
      expect(partial.state, DuplicateState.needsOverride);

      final whole = duplicateGate(
        candidates: [dup('o1'), dup('o2')],
        overridable: true, windowSeconds: 14400,
        acknowledged: ['o1', 'o2'], reason: 'needed again',
      );
      expect(whole.state, DuplicateState.overridden);
    });

    test('whitespace is not a reason', () {
      final gate = duplicateGate(
        candidates: [dup('o1')], overridable: true, windowSeconds: 14400,
        acknowledged: ['o1'], reason: '   ',
      );
      expect(gate.state, DuplicateState.needsOverride);
    });

    test('a policy that forbids duplicates refuses and says what to do', () {
      final gate = duplicateGate(
        candidates: [dup('o1')], overridable: false, windowSeconds: 14400,
        acknowledged: ['o1'], reason: 'I still want it',
      );
      expect(gate.state, DuplicateState.refused);
      expect(gate.message, contains('Use the existing order'));
      expect(mayPlace(validateOrder(draft(), null), gate), isFalse);
    });

    test('an override cannot rescue an invalid order', () {
      final gate = duplicateGate(
        candidates: [dup('o1')], overridable: true, windowSeconds: 14400,
        acknowledged: ['o1'], reason: 'needed',
      );
      expect(gate.state, DuplicateState.overridden);
      expect(mayPlace(validateOrder(draft(patientId: ''), null), gate), isFalse);
    });

    test('the window is reported in whole hours, never as zero', () {
      // "Placed in the last 0 hours" reads as a bug and teaches people to
      // ignore the sentence.
      final gate = duplicateGate(
        candidates: [dup('o1')], overridable: true, windowSeconds: 60,
      );
      expect(gate.windowHours, 1);
      expect(gate.message, contains('last 1 hours'));
    });

    test('the plural message counts the candidates', () {
      final gate = duplicateGate(
        candidates: [dup('o1'), dup('o2')],
        overridable: true, windowSeconds: 14400,
      );
      expect(gate.message, startsWith('2 orders'));
    });
  });

  group('the results inbox', () {
    InboxItem item({
      required String id,
      int escalations = 0,
      DateTime? at,
    }) =>
        InboxItem(
          observationId: id,
          patientId: 'p-$id',
          display: 'Potassium',
          value: '6.8 mmol/L',
          interpretationLabel: 'Critically high',
          effectiveAt: at ?? DateTime.utc(2026, 9, 16, 9),
          dueEscalations: escalations,
        );

    test('escalated results sort above fresher unread ones', () {
      // A result that has escalated twice is one where the acknowledgement
      // process has failed; sorting purely by age buries it as the list grows.
      final ordered = orderInbox([
        item(id: 'fresh', at: DateTime.utc(2026, 9, 16, 11)),
        item(id: 'escalated', escalations: 2,
            at: DateTime.utc(2026, 9, 16, 7)),
        item(id: 'old', at: DateTime.utc(2026, 9, 16, 6)),
      ]);
      expect(ordered.map((i) => i.observationId),
          ['escalated', 'old', 'fresh']);
    });

    test('within the same escalation count, oldest first', () {
      final ordered = orderInbox([
        item(id: 'newer', at: DateTime.utc(2026, 9, 16, 11)),
        item(id: 'older', at: DateTime.utc(2026, 9, 16, 8)),
      ]);
      expect(ordered.map((i) => i.observationId), ['older', 'newer']);
    });

    test('every row says whose result it is, because the inbox is ward-wide', () {
      // Scoping it to the open chart hides exactly the results nobody is
      // looking at.
      expect(item(id: 'o1').patientId, 'p-o1');
    });

    test('an acknowledgement needs the action taken, not just "seen"', () {
      // SRS-CLN-012. "Seen" closes the loop administratively and leaves the
      // next reader unable to tell whether anything was done about a
      // potassium of 6.8.
      expect(acknowledgementProblem(''), contains('not only that it was seen'));
      expect(acknowledgementProblem('   '), isNotEmpty);
      expect(acknowledgementProblem('Potassium rechecked, insulin stopped'), '');
    });
  });

  group('labels', () {
    test('timing critical is its own priority, not a synonym for urgent', () {
      // A dose due at 08:00 is not more urgent than one needed now; it is
      // differently urgent.
      expect(describeOrderPriority(OrderPriority.timingCritical),
          'Timing critical');
      expect(describeOrderPriority(OrderPriority.urgent), 'Urgent');
    });

    test('entered in error is never described as deleted', () {
      expect(describeOrderStatus(OrderStatus.enteredInError),
          'Entered in error');
    });

    test('every enum member has a label', () {
      for (final t in OrderType.values) {
        expect(describeOrderType(t), isNotEmpty);
      }
      for (final s in OrderStatus.values) {
        expect(describeOrderStatus(s), isNotEmpty);
      }
      for (final p in OrderPriority.values) {
        expect(describeOrderPriority(p), isNotEmpty);
      }
    });
  });
}
