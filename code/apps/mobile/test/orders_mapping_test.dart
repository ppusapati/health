import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/gen/healthcare/orders/v1/orders.pb.dart' as wire;
import 'package:health_mobile/src/orders/composer.dart';
import 'package:health_mobile/src/orders/mapping.dart';
import 'package:fixnum/fixnum.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

List<int> withVarintField(List<int> encoded, int tag, int value) {
  final out = [...encoded];
  _varint(out, (tag << 3) | 0);
  _varint(out, value);
  return out;
}

void _varint(List<int> out, int value) {
  var v = value;
  while (v >= 0x80) {
    out.add((v & 0x7f) | 0x80);
    v >>= 7;
  }
  out.add(v);
}

void main() {
  group('an enum from a newer contract', () {
    test('an unreadable order type cannot be placed under', () {
      // The type is what routes an order to a performing service. Guessing
      // "laboratory" sends a scan to a phlebotomist.
      final bytes = withVarintField(
        wire.Order(orderId: 'o1').writeToBuffer(), orderTypeField, 9999,
      );
      final type = orderTypeOf(wire.Order.fromBuffer(bytes));
      expect(type, OrderType.unrecognised);

      final validity = validateOrder(
        OrderDraft(
          type: type, patientId: 'p1', encounterId: 'e1', code: 'X'),
        null,
      );
      expect(validity.ready, isFalse);
    });

    test('an unreadable type has no wire value to send', () {
      expect(wireOrderTypeOf(OrderType.unrecognised), isNull);
      expect(wireOrderTypeOf(OrderType.unspecified), isNull);
      expect(wireOrderTypeOf(OrderType.imaging),
          wire.OrderType.ORDER_TYPE_IMAGING);
    });

    test('an unreadable status is not mistaken for a live order', () {
      final bytes = withVarintField(
        wire.Order(orderId: 'o1').writeToBuffer(), orderStatusField, 9999,
      );
      final status = orderStatusOf(wire.Order.fromBuffer(bytes));
      expect(status, OrderStatus.unrecognised);
      expect(describeOrderStatus(status), contains('not recognised'));
    });

    test('an unreadable priority does not become routine', () {
      final bytes = withVarintField(
        wire.Order(orderId: 'o1').writeToBuffer(), orderPriorityField, 9999,
      );
      expect(orderPriorityOf(wire.Order.fromBuffer(bytes)),
          OrderPriority.unrecognised);
    });

    test('the field tags are the ones the contract actually uses', () {
      final order = wire.Order.getDefault().info_;
      expect(order.byName['type']!.tagNumber, orderTypeField);
      expect(order.byName['priority']!.tagNumber, orderPriorityField);
      expect(order.byName['status']!.tagNumber, orderStatusField);
    });

    test('every type, status and priority the contract defines maps', () {
      for (final t in wire.OrderType.values) {
        expect(orderTypeOf(wire.Order(type: t)), isNot(OrderType.unrecognised),
            reason: 'no mapping for ${t.name}');
      }
      for (final s in wire.OrderStatus.values) {
        expect(orderStatusOf(wire.Order(status: s)),
            isNot(OrderStatus.unrecognised), reason: 'no mapping for ${s.name}');
      }
      for (final p in wire.Priority.values) {
        expect(orderPriorityOf(wire.Order(priority: p)),
            isNot(OrderPriority.unrecognised),
            reason: 'no mapping for ${p.name}');
      }
    });
  });

  group('duplicate warnings', () {
    wire.Order existing({String id = 'o1', String display = 'Potassium'}) =>
        wire.Order(
          orderId: id,
          number: 'ORD-$id',
          code: wire.Coding(code: 'K', display: display),
          status: wire.OrderStatus.ORDER_STATUS_REQUESTED,
          createdAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16, 6)),
        );

    test('a warning becomes a gate carrying every candidate', () {
      final gate = gateForWarning(wire.DuplicateWarning(
        existing: [existing(), existing(id: 'o2')],
        overridable: true,
        windowSeconds: Int64(14400),
      ));
      expect(gate.state, DuplicateState.needsOverride);
      expect(gate.candidates, hasLength(2));
      expect(gate.windowHours, 4);
    });

    test('an unoverridable warning refuses', () {
      final gate = gateForWarning(wire.DuplicateWarning(
        existing: [existing()],
        overridable: false,
        windowSeconds: Int64(14400),
      ));
      expect(gate.state, DuplicateState.refused);
    });

    test('no existing orders is clear', () {
      expect(gateForWarning(wire.DuplicateWarning()).state,
          DuplicateState.clear);
    });

    test('a candidate with no display falls back to its code', () {
      final gate = gateForWarning(wire.DuplicateWarning(
        existing: [
          wire.Order(
            orderId: 'o1',
            code: wire.Coding(code: 'K'),
            createdAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16)),
          ),
        ],
        overridable: true,
        windowSeconds: Int64(3600),
      ));
      expect(gate.candidates.single.display, 'K');
    });

    test('the placed time comes through in UTC', () {
      final gate = gateForWarning(wire.DuplicateWarning(
        existing: [existing()], overridable: true,
        windowSeconds: Int64(3600),
      ));
      expect(gate.candidates.single.placedAt, DateTime.utc(2026, 9, 16, 6));
      expect(gate.candidates.single.placedAt.isUtc, isTrue);
    });
  });
}
