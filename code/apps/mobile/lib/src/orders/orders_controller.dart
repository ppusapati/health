/// Loading the inbox, placing an order, and acknowledging a result.
library;

import '../api/api_error.dart';
import '../api/clinical_client.dart';
import '../api/orders_client.dart';
import '../chart/mapping.dart' as chart;
import '../gen/healthcare/orders/v1/orders.pb.dart' as wire;
import '../screens/orders_screen.dart';
import 'composer.dart';
import 'mapping.dart';

class OrdersController {
  /// Positional because a named parameter cannot be a private initializing
  /// formal. The clock is injected so a test can hold time still while the
  /// inbox reports how long a result has been waiting.
  OrdersController(this._orders, this._clinical, this._now);

  final OrdersClient _orders;
  final ClinicalClient _clinical;
  final DateTime Function() _now;

  OrderDraft _draft = const OrderDraft(
    type: OrderType.unspecified, patientId: '', encounterId: '',
  );
  OrderPolicy? _policy;
  DuplicateGate _gate = const DuplicateGate(state: DuplicateState.clear);
  List<InboxItem> _inbox = const [];
  final List<String> _acknowledged = [];
  String _overrideReason = '';
  String? _failure;
  bool _loading = false;

  OrdersView? _view;

  OrdersView? get view => _view;
  String? get failure => _failure;
  bool get loading => _loading;

  void _rebuild() {
    _view = OrdersView(
      draft: _draft,
      policy: _policy,
      gate: _gate,
      inbox: _inbox,
      acknowledged: List.unmodifiable(_acknowledged),
      overrideReason: _overrideReason,
    );
  }

  /// Starts a new order for a patient, discarding any half-built one.
  ///
  /// The duplicate gate and its acknowledgements go with it: a reason given
  /// for one patient's duplicate must never carry to another's.
  void startDraft({
    required String patientId,
    required String encounterId,
    required OrderType type,
    String code = '',
    String display = '',
    OrderPolicy? policy,
  }) {
    _draft = OrderDraft(
      type: type,
      patientId: patientId,
      encounterId: encounterId,
      code: code,
      display: display,
    );
    _policy = policy;
    _gate = const DuplicateGate(state: DuplicateState.clear);
    _acknowledged.clear();
    _overrideReason = '';
    _rebuild();
  }

  void setIndication(String indication) {
    _draft = OrderDraft(
      type: _draft.type,
      patientId: _draft.patientId,
      encounterId: _draft.encounterId,
      code: _draft.code,
      display: _draft.display,
      detail: _draft.detail,
      indication: indication,
      priority: _draft.priority,
      startAt: _draft.startAt,
      frequencySeconds: _draft.frequencySeconds,
      conditionalInstruction: _draft.conditionalInstruction,
    );
    _rebuild();
  }

  void setOverrideReason(String reason) {
    _overrideReason = reason;
    _regate();
  }

  void acknowledgeDuplicate(String orderId) {
    if (!_acknowledged.contains(orderId)) {
      _acknowledged.add(orderId);
    }
    _regate();
  }

  /// Re-evaluates the gate against the current acknowledgements and reason.
  void _regate() {
    _gate = duplicateGate(
      candidates: _gate.candidates,
      overridable: _gate.state != DuplicateState.refused,
      windowSeconds: _gate.windowHours * 3600,
      acknowledged: _acknowledged,
      reason: _overrideReason,
    );
    _rebuild();
  }

  /// Loads the ward-wide critical-result inbox.
  Future<void> loadInbox() async {
    _loading = true;
    try {
      final response = await _clinical.listCriticalResults();
      final now = _now();
      _inbox = [
        for (final result in response.results)
          () {
            final observation = chart.observationOf(result.observation);
            return InboxItem(
              observationId: observation.observationId,
              patientId: result.observation.patientId,
              display: observation.display,
              value: observation.value,
              interpretationLabel: observation.interpretationLabel,
              effectiveAt: observation.effectiveAt,
              dueEscalations: result.dueEscalations,
              waitingMinutes:
                  now.difference(observation.effectiveAt).inMinutes.clamp(0, 1 << 31),
            );
          }(),
      ];
      _failure = null;
    } on ApiError catch (error) {
      _failure = error.message;
    } finally {
      _loading = false;
      _rebuild();
    }
  }

  /// Places the draft order.
  ///
  /// Returns the placed order, or null when it was refused or a duplicate
  /// warning came back. A warning is not a failure: it is the server asking
  /// the question the gate exists to put to the clinician, so it updates the
  /// gate rather than the error.
  Future<wire.Order?> place() async {
    final validity = validateOrder(_draft, _policy);
    if (!mayPlace(validity, _gate)) {
      _failure = validity.order.isNotEmpty ? validity.order.first : _gate.message;
      _rebuild();
      return null;
    }

    final type = wireOrderTypeOf(_draft.type);
    if (type == null) {
      // validateOrder has already refused this; the second reading is here
      // because this is the point where it would otherwise reach the wire.
      _failure = 'Choose what kind of order this is.';
      _rebuild();
      return null;
    }

    try {
      final response = await _orders.placeOrder(
        type: type,
        patientId: _draft.patientId,
        encounterId: _draft.encounterId,
        code: wire.Coding(code: _draft.code, display: _draft.display),
        detail: _draft.detail,
        indication: _draft.indication,
        priority: wirePriorityOf(_draft.priority),
        conditionalInstruction: _draft.conditionalInstruction,
        acknowledgeDuplicates: _overrideReason,
      );

      if (response.hasWarning() && response.warning.existing.isNotEmpty) {
        // The server found duplicates this screen had not seen. The order was
        // not placed; the gate now has something to ask about.
        _gate = gateForWarning(
          response.warning,
          acknowledged: _acknowledged,
          reason: _overrideReason,
        );
        _failure = null;
        _rebuild();
        return null;
      }

      _failure = null;
      _rebuild();
      return response.order;
    } on ApiError catch (error) {
      _failure = error.message;
      _rebuild();
      return null;
    }
  }

  /// Acknowledges a critical result with what was done about it.
  Future<bool> acknowledgeResult({
    required String observationId,
    required String action,
  }) async {
    final problem = acknowledgementProblem(action);
    if (problem.isNotEmpty) {
      _failure = problem;
      _rebuild();
      return false;
    }

    try {
      await _clinical.acknowledgeCriticalResult(
        observationId: observationId,
        action: action,
      );
      _failure = null;
    } on ApiError catch (error) {
      _failure = error.message;
      _rebuild();
      return false;
    }
    await loadInbox();
    return true;
  }
}
