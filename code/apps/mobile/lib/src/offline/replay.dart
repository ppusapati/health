/// Turning a queued operation back into a request (SRS-NFR-013).
///
/// `SyncService` knows how to drain a queue; it does not know what any
/// particular operation means. This is where a payload that was written at a
/// bedside becomes a call again.
///
/// The rule that shapes all of it: **a replay re-sends what was captured, it
/// does not reconstruct it.** Every field the server needs was written to disk
/// at the moment it was true. Recomputing `given_at`, or minting a fresh
/// idempotency key, would turn a delayed record into a false one — and in the
/// case of the key, into a second dose.
///
/// An operation whose type nothing claims is refused rather than dropped. A
/// queue that silently discards what it cannot route is a queue that loses a
/// nurse's work and reports success.
library;

import '../api/api_error.dart';
import '../api/nursing_client.dart';
import '../gen/healthcare/nursing/v1/nursing.pb.dart' as wire;
import '../meds/round.dart';
import '../meds/submission.dart';
import 'operation_queue.dart';
import 'sync.dart';

/// Routes queued operations to whatever knows how to send them.
class OperationRouter {
  OperationRouter(this._handlers);

  final Map<String, OperationSender> _handlers;

  /// The types this router can deliver.
  Iterable<String> get handledTypes => _handlers.keys;

  /// An [OperationSender] for [SyncService].
  ///
  /// An unroutable operation fails permanently rather than being deferred:
  /// deferring it would retry forever, and the queue would never drain past it.
  /// Marked failed, it is parked where somebody will see it.
  Future<void> send(QueuedOperation operation) async {
    final handler = _handlers[operation.type];
    if (handler == null) {
      throw ApiError(
        status: ApiStatus.unimplemented,
        code: 'UNROUTABLE_OPERATION',
        correlationId: '',
      );
    }
    await handler(operation);
  }
}

/// Re-sends an administration captured while the device was offline.
///
/// `offline: true` is set on the way out. The server is being told that this
/// was recorded on a device that could not reach it at the time, which is a
/// different fact from when it arrived, and the only machine that knows it is
/// this one.
OperationSender administrationSender(NursingClient nursing) {
  return (operation) async {
    final payload = operation.payload;

    await nursing.administer(
      orderId: payload['order_id'] as String,
      facilityId: payload['facility_id'] as String,
      scheduledAt: DateTime.parse(payload['scheduled_at'] as String),
      // The bedside time, as captured. Never now.
      givenAt: DateTime.parse(payload['given_at'] as String),
      outcome: _wireOutcome(payload['outcome'] as String),
      // The key minted at the bedside, so this is the same operation and not a
      // second dose.
      idempotencyKey: payload['idempotency_key'] as String,
      givenDose: _quantity(payload),
      route: payload['route'] as String? ?? '',
      site: payload['site'] as String? ?? '',
      reason: payload['reason'] as String? ?? '',
      verification: _verification(payload),
      overrideReason: payload['override_reason'] as String? ?? '',
      witnessedBy: payload['witnessed_by'] as String? ?? '',
      offline: true,
    );
  };
}

/// The router a ward device uses.
OperationRouter wardRouter(NursingClient nursing) => OperationRouter({
      administrationOperationType: administrationSender(nursing),
    });

wire.Quantity? _quantity(Map<String, dynamic> payload) {
  final value = payload['dose_value'];
  if (value is! num) return null;
  return wire.Quantity(
    value: value.toDouble(),
    unit: payload['dose_unit'] as String? ?? '',
  );
}

/// Rebuilds the verification from what was actually scanned.
///
/// `performed` is derived rather than stored: it is true when both scans
/// happened, and a stored flag could disagree with the barcodes beside it.
wire.Verification? _verification(Map<String, dynamic> payload) {
  final scan = Scan(
    patient: payload['patient_scanned'] as String? ?? '',
    medication: payload['medication_scanned'] as String? ?? '',
  );
  if (!scan.patientScanned && !scan.medicationScanned) return null;

  return wire.Verification(
    patientScanned: scan.patient,
    medicationScanned: scan.medication,
    performed: scan.complete,
  );
}

/// The wire enum for a stored outcome name.
///
/// An unrecognised name is an error, not a default. Defaulting would file a
/// dose that was held or refused as though nothing had been decided about it.
wire.AdministrationOutcome _wireOutcome(String name) => switch (name) {
      'administered' => wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_ADMINISTERED,
      'notAdministered' =>
        wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_NOT_ADMINISTERED,
      'held' => wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_HELD,
      'refused' => wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_REFUSED,
      'delayed' => wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_DELAYED,
      _ => throw ApiError(
          status: ApiStatus.invalidArgument,
          code: 'UNKNOWN_ADMINISTRATION_OUTCOME',
          correlationId: '',
        ),
    };
