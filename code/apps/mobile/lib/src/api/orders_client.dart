/// Typed client for healthcare.orders.v1.OrderService.
///
/// Placing an order, seeing what is already live, and the critical-result
/// inbox. Order sets and favourites stay on the web: both are curation, done
/// once and carefully, and neither belongs on a device somebody is holding in
/// one hand.
library;

import '../gen/healthcare/orders/v1/orders.pb.dart';
import 'connect_client.dart';

class OrdersClient {
  OrdersClient(this._connect);

  final ConnectClient _connect;

  static const _service = '/healthcare.orders.v1.OrderService';

  /// The orders on a chart.
  Future<ListOrdersResponse> listOrders({
    required String patientId,
    String encounterId = '',
    bool liveOnly = true,
    int pageSize = 100,
  }) {
    return _connect.unary(
      procedure: '$_service/ListOrders',
      request: ListOrdersRequest(
        patientId: patientId,
        encounterId: encounterId,
        liveOnly: liveOnly,
        pageSize: pageSize,
      ),
      parse: ListOrdersResponse.fromBuffer,
    );
  }

  /// Places an order.
  ///
  /// [acknowledgeDuplicates] is the reason the clinician gave, and the server
  /// records it against the orders it was given for. Sent empty on a first
  /// attempt: the duplicate warning comes back in the response, and only then
  /// does the screen have anything to ask about.
  Future<PlaceOrderResponse> placeOrder({
    required OrderType type,
    required String patientId,
    required String encounterId,
    required Coding code,
    String detail = '',
    String indication = '',
    Priority priority = Priority.PRIORITY_UNSPECIFIED,
    Timing? timing,
    String conditionalInstruction = '',
    String acknowledgeDuplicates = '',
  }) {
    return _connect.unary(
      procedure: '$_service/PlaceOrder',
      request: PlaceOrderRequest(
        type: type,
        patientId: patientId,
        encounterId: encounterId,
        code: code,
        detail: detail,
        indication: indication,
        priority: priority,
        timing: timing,
        conditionalInstruction: conditionalInstruction,
        acknowledgeDuplicates: acknowledgeDuplicates,
      ),
      parse: PlaceOrderResponse.fromBuffer,
    );
  }
}
