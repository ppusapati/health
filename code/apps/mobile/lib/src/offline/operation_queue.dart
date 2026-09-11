/// Offline operation queue.
///
/// SRS-NFR-013 permits selected mobile workflows to queue operations during a
/// transient outage, with deterministic conflict resolution. Two rules follow
/// from "deterministic":
///
///   * the client generates the operation ID, so a retry after a lost response
///     is deduplicated by the server rather than guessed at by the client;
///   * the queue records when the action happened on the device, which is not
///     when the server heard about it.
///
/// The queue is intentionally small and explicit. A general offline-sync
/// framework would hide exactly the conflict decisions that need to be visible
/// in a clinical system.
library;

import 'dart:async';
import 'dart:convert';

/// Lifecycle of a queued operation.
enum QueuedStatus { pending, sent, failed }

/// One operation captured on the device.
class QueuedOperation {
  QueuedOperation({
    required this.id,
    required this.type,
    required this.payload,
    required this.occurredAt,
    this.status = QueuedStatus.pending,
    this.attempts = 0,
    this.lastError = '',
  });

  /// Client-generated idempotency key.
  final String id;
  final String type;
  final Map<String, dynamic> payload;
  final DateTime occurredAt;

  QueuedStatus status;
  int attempts;
  String lastError;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'payload': payload,
        'occurred_at': occurredAt.toUtc().toIso8601String(),
        'status': status.name,
        'attempts': attempts,
        'last_error': lastError,
      };

  static QueuedOperation fromJson(Map<String, dynamic> json) => QueuedOperation(
        id: json['id'] as String,
        type: json['type'] as String,
        payload: Map<String, dynamic>.from(json['payload'] as Map),
        occurredAt: DateTime.parse(json['occurred_at'] as String),
        status: QueuedStatus.values.byName(json['status'] as String? ?? 'pending'),
        attempts: json['attempts'] as int? ?? 0,
        lastError: json['last_error'] as String? ?? '',
      );
}

/// Durable storage for the queue.
///
/// The device may be killed at any moment, so an in-memory queue would lose
/// work the user believes is saved.
abstract interface class QueueStorage {
  Future<String?> load();
  Future<void> save(String contents);
}

/// In-memory storage, for tests.
class InMemoryQueueStorage implements QueueStorage {
  String? _contents;

  @override
  Future<String?> load() async => _contents;

  @override
  Future<void> save(String contents) async => _contents = contents;
}

/// Queues operations captured while offline and replays them on recovery.
class OperationQueue {
  OperationQueue(this._storage);

  final QueueStorage _storage;
  final List<QueuedOperation> _operations = [];
  bool _loaded = false;

  /// Loads the queue from storage. Safe to call repeatedly.
  Future<void> load() async {
    if (_loaded) return;

    final raw = await _storage.load();
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      _operations
        ..clear()
        ..addAll(decoded.map((e) => QueuedOperation.fromJson(e as Map<String, dynamic>)));
    }
    _loaded = true;
  }

  Future<void> _persist() async {
    await _storage.save(jsonEncode(_operations.map((o) => o.toJson()).toList()));
  }

  /// Adds an operation, or returns the existing one with the same ID.
  ///
  /// Idempotent because the caller may retry after a crash between capturing
  /// the action and persisting it.
  Future<void> enqueue(QueuedOperation operation) async {
    await load();
    if (_operations.any((o) => o.id == operation.id)) return;

    _operations.add(operation);
    await _persist();
  }

  /// Operations awaiting delivery, oldest first.
  ///
  /// Ordering is by when the action happened on the device, so the server sees
  /// them in the order the user performed them.
  Future<List<QueuedOperation>> pending() async {
    await load();
    final pending = _operations.where((o) => o.status == QueuedStatus.pending).toList()
      ..sort((a, b) {
        final byTime = a.occurredAt.compareTo(b.occurredAt);
        // A stable tiebreak keeps the order deterministic when two operations
        // share a timestamp.
        return byTime != 0 ? byTime : a.id.compareTo(b.id);
      });
    return pending;
  }

  /// Marks an operation delivered.
  Future<void> markSent(String id) async {
    await load();
    for (final operation in _operations) {
      if (operation.id == id) {
        operation.status = QueuedStatus.sent;
        operation.lastError = '';
      }
    }
    await _persist();
  }

  /// Records a delivery failure, keeping the operation pending.
  Future<void> recordFailure(String id, String reason) async {
    await load();
    for (final operation in _operations) {
      if (operation.id == id) {
        operation.attempts += 1;
        operation.lastError = reason;
      }
    }
    await _persist();
  }

  /// Marks an operation permanently failed, for a human to resolve.
  ///
  /// The record is kept rather than discarded: silently dropping a nurse's
  /// queued action is worse than surfacing it.
  Future<void> markFailed(String id, String reason) async {
    await load();
    for (final operation in _operations) {
      if (operation.id == id) {
        operation.status = QueuedStatus.failed;
        operation.lastError = reason;
      }
    }
    await _persist();
  }

  /// Counts by status, for the sync indicator.
  Future<Map<QueuedStatus, int>> counts() async {
    await load();
    final counts = {for (final status in QueuedStatus.values) status: 0};
    for (final operation in _operations) {
      counts[operation.status] = counts[operation.status]! + 1;
    }
    return counts;
  }
}
