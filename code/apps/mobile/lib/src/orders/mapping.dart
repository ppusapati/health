/// Wire types to the order composer's models (UX-W1-04).
///
/// Same unknown-enum discipline as the other two workspaces; the reasoning is
/// written out in `reception/mapping.dart`.
///
/// The fallback that matters here is the order type. An unreadable type must
/// not become `laboratory`, because the type is what routes the order to a
/// performing service — a misrouted order is work that either never happens or
/// happens in the wrong department. `unrecognised` is refused by
/// `validateOrder`, so the composer will not place one.
library;

import 'package:protobuf/protobuf.dart' as pb;

import '../gen/healthcare/orders/v1/orders.pb.dart' as wire;
import 'composer.dart';

/// Field tags carrying the enums this module reads. Pinned by test.
const int orderTypeField = 3; // orders.v1.Order.type
const int orderPriorityField = 14; // orders.v1.Order.priority
const int orderStatusField = 17; // orders.v1.Order.status

/// True when [message] carried a value for [tag] this build could not read.
bool sentUnknownValueFor(pb.GeneratedMessage message, int tag) =>
    message.unknownFields.hasField(tag);

OrderType orderTypeOf(wire.Order order) {
  if (sentUnknownValueFor(order, orderTypeField)) {
    return OrderType.unrecognised;
  }
  return switch (order.type) {
    wire.OrderType.ORDER_TYPE_LABORATORY => OrderType.laboratory,
    wire.OrderType.ORDER_TYPE_IMAGING => OrderType.imaging,
    wire.OrderType.ORDER_TYPE_MEDICATION => OrderType.medication,
    wire.OrderType.ORDER_TYPE_PROCEDURE => OrderType.procedure,
    wire.OrderType.ORDER_TYPE_DIET => OrderType.diet,
    wire.OrderType.ORDER_TYPE_NURSING => OrderType.nursing,
    wire.OrderType.ORDER_TYPE_BLOOD_PRODUCT => OrderType.bloodProduct,
    wire.OrderType.ORDER_TYPE_REFERRAL => OrderType.referral,
    wire.OrderType.ORDER_TYPE_ALLIED_HEALTH => OrderType.alliedHealth,
    wire.OrderType.ORDER_TYPE_UNSPECIFIED => OrderType.unspecified,
    _ => OrderType.unrecognised,
  };
}

OrderStatus orderStatusOf(wire.Order order) {
  if (sentUnknownValueFor(order, orderStatusField)) {
    return OrderStatus.unrecognised;
  }
  return switch (order.status) {
    wire.OrderStatus.ORDER_STATUS_DRAFT => OrderStatus.draft,
    wire.OrderStatus.ORDER_STATUS_REQUESTED => OrderStatus.requested,
    wire.OrderStatus.ORDER_STATUS_ACCEPTED => OrderStatus.accepted,
    wire.OrderStatus.ORDER_STATUS_SCHEDULED => OrderStatus.scheduled,
    wire.OrderStatus.ORDER_STATUS_IN_PROGRESS => OrderStatus.inProgress,
    wire.OrderStatus.ORDER_STATUS_COMPLETED => OrderStatus.completed,
    wire.OrderStatus.ORDER_STATUS_CANCELLED => OrderStatus.cancelled,
    wire.OrderStatus.ORDER_STATUS_ENTERED_IN_ERROR => OrderStatus.enteredInError,
    wire.OrderStatus.ORDER_STATUS_UNSPECIFIED => OrderStatus.unspecified,
    _ => OrderStatus.unrecognised,
  };
}

OrderPriority orderPriorityOf(wire.Order order) {
  if (sentUnknownValueFor(order, orderPriorityField)) {
    return OrderPriority.unrecognised;
  }
  return switch (order.priority) {
    wire.Priority.PRIORITY_STAT => OrderPriority.stat,
    wire.Priority.PRIORITY_URGENT => OrderPriority.urgent,
    wire.Priority.PRIORITY_TIMING_CRITICAL => OrderPriority.timingCritical,
    wire.Priority.PRIORITY_ROUTINE => OrderPriority.routine,
    wire.Priority.PRIORITY_UNSPECIFIED => OrderPriority.unspecified,
    _ => OrderPriority.unrecognised,
  };
}

/// Wire order type for a model one, for placing.
///
/// Returns null for anything the composer should not be placing under, which
/// `validateOrder` has already refused — this is the second reading of the
/// same rule, at the point where it would otherwise reach the wire.
wire.OrderType? wireOrderTypeOf(OrderType type) => switch (type) {
      OrderType.laboratory => wire.OrderType.ORDER_TYPE_LABORATORY,
      OrderType.imaging => wire.OrderType.ORDER_TYPE_IMAGING,
      OrderType.medication => wire.OrderType.ORDER_TYPE_MEDICATION,
      OrderType.procedure => wire.OrderType.ORDER_TYPE_PROCEDURE,
      OrderType.diet => wire.OrderType.ORDER_TYPE_DIET,
      OrderType.nursing => wire.OrderType.ORDER_TYPE_NURSING,
      OrderType.bloodProduct => wire.OrderType.ORDER_TYPE_BLOOD_PRODUCT,
      OrderType.referral => wire.OrderType.ORDER_TYPE_REFERRAL,
      OrderType.alliedHealth => wire.OrderType.ORDER_TYPE_ALLIED_HEALTH,
      OrderType.unspecified || OrderType.unrecognised => null,
    };

/// Wire priority for a model one. Unspecified where there is nothing to say.
wire.Priority wirePriorityOf(OrderPriority priority) => switch (priority) {
      OrderPriority.stat => wire.Priority.PRIORITY_STAT,
      OrderPriority.urgent => wire.Priority.PRIORITY_URGENT,
      OrderPriority.timingCritical => wire.Priority.PRIORITY_TIMING_CRITICAL,
      OrderPriority.routine => wire.Priority.PRIORITY_ROUTINE,
      OrderPriority.unspecified ||
      OrderPriority.unrecognised =>
        wire.Priority.PRIORITY_UNSPECIFIED,
    };

/// One existing order, as a duplicate candidate.
DuplicateCandidate candidateOf(wire.Order order) => DuplicateCandidate(
      orderId: order.orderId,
      number: order.number,
      display: order.code.display.isNotEmpty
          ? order.code.display
          : order.code.code,
      status: orderStatusOf(order),
      // created_at, because that is when the order was placed — the contract
      // has no separate placed_at, and the status history's first entry would
      // be the same instant by a longer route.
      placedAt: order.createdAt.toDateTime().toUtc(),
      requesterId: order.requesterId,
    );

/// The duplicate gate for a warning the server returned.
DuplicateGate gateForWarning(
  wire.DuplicateWarning warning, {
  List<String> acknowledged = const [],
  String reason = '',
}) =>
    duplicateGate(
      candidates: [for (final o in warning.existing) candidateOf(o)],
      overridable: warning.overridable,
      windowSeconds: warning.windowSeconds.toInt(),
      acknowledged: acknowledged,
      reason: reason,
    );
