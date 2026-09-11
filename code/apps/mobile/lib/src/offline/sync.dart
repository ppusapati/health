/// Replays the offline queue when connectivity returns.
library;

import '../api/api_error.dart';
import 'operation_queue.dart';

/// Delivers one queued operation to the server.
typedef OperationSender = Future<void> Function(QueuedOperation operation);

/// Outcome of one sync pass.
class SyncResult {
  const SyncResult({this.sent = 0, this.failed = 0, this.deferred = 0});

  final int sent;

  /// Permanently rejected; needs a human.
  final int failed;

  /// Left pending because the device is offline.
  final int deferred;

  bool get isComplete => deferred == 0;
}

/// Drains the queue.
class SyncService {
  SyncService(this._queue, this._send);

  final OperationQueue _queue;
  final OperationSender _send;

  /// Delivers everything it can.
  ///
  /// On the first offline error it stops rather than walking the rest: if the
  /// device is offline for one operation it is offline for all of them, and
  /// continuing would inflate every attempt counter for nothing.
  Future<SyncResult> sync() async {
    final pending = await _queue.pending();

    var sent = 0;
    var failed = 0;

    for (var i = 0; i < pending.length; i++) {
      final operation = pending[i];
      try {
        await _send(operation);
        await _queue.markSent(operation.id);
        sent++;
      } on ApiError catch (error) {
        if (error.retryable) {
          await _queue.recordFailure(operation.id, error.code);
          return SyncResult(sent: sent, failed: failed, deferred: pending.length - sent - failed);
        }

        // A permanent refusal will not succeed on retry. Parking it keeps the
        // queue moving and puts the problem in front of someone.
        await _queue.markFailed(operation.id, error.code);
        failed++;
      }
    }

    return SyncResult(sent: sent, failed: failed);
  }
}
