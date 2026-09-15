/// Recording an administration from a device that may be offline
/// (SRS-NUR-006, SRS-NFR-013).
///
/// A ward tablet loses its network in lifts, in stairwells, and in the corner
/// of the bay furthest from the access point. The round does not stop, so the
/// question is not whether to work offline but what is true afterwards.
///
/// Three facts have to survive, and they are different facts:
///
///   * **when the dose was given** — the bedside time, not the time the tablet
///     reconnected. A dose that reads as given at 14:40 because that is when
///     the lift doors opened is a falsified record;
///   * **that it was captured offline** — so a reviewer reading a gap in the
///     timestamps knows why it is there rather than inferring a late entry;
///   * **which administration it is** — the idempotency key is minted at the
///     bedside, before anything is sent, so a replay after a lost response is
///     deduplicated by the server instead of becoming a second dose.
///
/// And one thing must not happen: the tile must never say "given" because the
/// nurse pressed a button. It says given when the server confirms, or queued
/// when it is safely on disk. Those are different words because they are
/// different states, and a nurse who sees "given" for something that never
/// arrived is a nurse whose colleague gives it again.
library;

import 'dart:async';

import '../api/api_error.dart';
import '../api/optimistic.dart';
import '../offline/operation_queue.dart';
import 'round.dart';

/// The type recorded in the offline queue for an administration.
const String administrationOperationType = 'nursing.administer';

/// One administration, as captured at the bedside.
class CapturedAdministration {
  const CapturedAdministration({
    required this.orderId,
    required this.facilityId,
    required this.scheduledAt,
    required this.givenAt,
    required this.outcome,
    required this.idempotencyKey,
    this.doseValue,
    this.doseUnit = '',
    this.route = '',
    this.site = '',
    this.reason = '',
    this.scan = const Scan(),
    this.overrideReason = '',
    this.witnessedBy = '',
  });

  final String orderId;
  final String facilityId;
  final DateTime scheduledAt;

  /// When the dose was given, at the bedside.
  final DateTime givenAt;

  final AdministrationOutcome outcome;

  /// Minted before anything is sent. See the library comment.
  final String idempotencyKey;

  final double? doseValue;
  final String doseUnit;
  final String route;
  final String site;
  final String reason;
  final Scan scan;
  final String overrideReason;
  final String witnessedBy;

  /// The payload the queue persists, and which a replay re-sends verbatim.
  ///
  /// `given_at` is in it rather than being reconstructed on replay, because the
  /// only machine that knows when the dose was given is the one that was at the
  /// bedside.
  Map<String, dynamic> toPayload() => {
        'order_id': orderId,
        'facility_id': facilityId,
        'scheduled_at': scheduledAt.toUtc().toIso8601String(),
        'given_at': givenAt.toUtc().toIso8601String(),
        'outcome': outcome.name,
        'idempotency_key': idempotencyKey,
        if (doseValue != null) 'dose_value': doseValue,
        'dose_unit': doseUnit,
        'route': route,
        'site': site,
        'reason': reason,
        'patient_scanned': scan.patient,
        'medication_scanned': scan.medication,
        'override_reason': overrideReason,
        'witnessed_by': witnessedBy,
      };
}

/// Where an administration ended up.
enum SubmissionState {
  /// The server has it. This is the only state that may be shown as given.
  confirmed,

  /// On this device's queue, not yet delivered. Shown as queued, never as
  /// given: it is a promise, and the ward needs to know which doses are still
  /// only promises.
  queued,

  /// Neither. The record does not have it and neither does the queue.
  failed,
}

/// The outcome of recording one administration.
class Submission {
  const Submission({
    required this.state,
    required this.idempotencyKey,
    this.message = '',
  });

  final SubmissionState state;

  /// Carried out so the screen can match a later confirmation to the tile that
  /// is still showing as queued.
  final String idempotencyKey;

  /// What to tell the nurse. Never a raw error.
  final String message;

  /// Whether the drug can be shown as given.
  bool get settled => state == SubmissionState.confirmed;
}

/// Records an administration, queueing it if the device cannot reach the server.
///
/// [send] performs the call. [queue] is the device's durable queue. [now] is
/// injected so the queue records the same instant the caller reasoned about,
/// and [onProgress] is how the tile shows pending before it shows an answer.
Future<Submission> submitAdministration({
  required CapturedAdministration captured,
  required Future<void> Function() send,
  required OperationQueue queue,
  void Function(OptimisticResult<void>)? onProgress,
  DateTime? now,
}) async {
  // The clinical path never shows a guess. Stated at the call site rather than
  // left to the policy module, because this is the one place where being wrong
  // means a second dose.
  if (mayBeOptimistic(OperationKind.medicationWrite)) {
    throw StateError(
      'medicationWrite became optimistic; an administration must never be '
      'shown as given before the server confirms it',
    );
  }

  // `confirmed` drives the pending -> settled reporting the tile renders. It
  // deliberately swallows the exception -- its job is what the screen shows,
  // not what the caller does next -- so the error is captured on the way past
  // for routing here.
  Object? failure;
  final progress = await confirmed<void>(
    original: null,
    commit: () async {
      try {
        await send();
      } catch (error) {
        failure = error;
        rethrow;
      }
    },
    onChange: onProgress,
  );

  if (progress.state == OptimisticState.confirmed) {
    return Submission(
      state: SubmissionState.confirmed,
      idempotencyKey: captured.idempotencyKey,
      message: 'Recorded.',
    );
  }

  // A failure that is not a connectivity failure is not queued. A dose the
  // server refused -- because the order was cancelled, or the override was not
  // permitted -- is a decision, and replaying it later is asking the same
  // question hoping for a different answer.
  final error = failure;
  final lostNetwork = error is TimeoutException ||
      (error is ApiError && _isConnectivity(error));

  if (!lostNetwork) {
    return Submission(
      state: SubmissionState.failed,
      idempotencyKey: captured.idempotencyKey,
      message: error is ApiError ? error.message : progress.reason,
    );
  }

  await _enqueue(captured, queue, now);
  return Submission(
    state: SubmissionState.queued,
    idempotencyKey: captured.idempotencyKey,
    message: 'Saved on this device. It will be sent when the network returns.',
  );
}

/// Whether the failure was the network rather than the server's answer.
///
/// `unavailable` and `deadline_exceeded` mean nobody decided anything, so the
/// operation is still worth replaying. Everything else is an answer.
bool _isConnectivity(ApiError error) =>
    error.status == ApiStatus.unavailable ||
    error.status == ApiStatus.deadlineExceeded;

Future<void> _enqueue(
  CapturedAdministration captured,
  OperationQueue queue,
  DateTime? now,
) async {
  await queue.enqueue(QueuedOperation(
    // The same key the request carried, so a replay is the same operation and
    // not a second dose.
    id: captured.idempotencyKey,
    type: administrationOperationType,
    payload: captured.toPayload(),
    // When it happened on the device, which is what the queue orders by.
    occurredAt: now ?? captured.givenAt,
  ));
}
