import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/api/api_error.dart';
import 'package:health_mobile/src/offline/file_queue_storage.dart';
import 'package:health_mobile/src/offline/operation_queue.dart';
import 'package:health_mobile/src/offline/sync.dart';

final _at = DateTime.utc(2026, 9, 11, 9);

QueuedOperation op(String id, {Duration offset = Duration.zero}) => QueuedOperation(
      id: id,
      type: 'homecare.visit_observation_recorded',
      payload: {'observation': 'BP 120/80'},
      occurredAt: _at.add(offset),
    );

void main() {
  _fileQueueTests();

  group('OperationQueue', () {
    test('queues work and reports it pending', () async {
      final queue = OperationQueue(InMemoryQueueStorage());

      await queue.enqueue(op('op-1'));
      await queue.enqueue(op('op-2', offset: const Duration(minutes: 1)));

      final pending = await queue.pending();
      expect(pending.map((o) => o.id), ['op-1', 'op-2']);
    });

    // The device can be killed between capturing an action and persisting it,
    // so the caller may retry with the same ID.
    test('enqueue is idempotent on the operation ID', () async {
      final queue = OperationQueue(InMemoryQueueStorage());

      await queue.enqueue(op('op-1'));
      await queue.enqueue(op('op-1'));
      await queue.enqueue(op('op-1'));

      expect((await queue.pending()).length, 1);
    });

    // The server must see operations in the order the user performed them, not
    // the order the network happened to recover.
    test('pending is ordered by when the action happened on the device', () async {
      final queue = OperationQueue(InMemoryQueueStorage());

      await queue.enqueue(op('op-late', offset: const Duration(minutes: 10)));
      await queue.enqueue(op('op-early'));
      await queue.enqueue(op('op-middle', offset: const Duration(minutes: 5)));

      expect((await queue.pending()).map((o) => o.id), ['op-early', 'op-middle', 'op-late']);
    });

    test('ordering is deterministic when timestamps collide', () async {
      final queue = OperationQueue(InMemoryQueueStorage());

      await queue.enqueue(op('op-b'));
      await queue.enqueue(op('op-a'));

      expect((await queue.pending()).map((o) => o.id), ['op-a', 'op-b']);
    });

    test('survives a process restart', () async {
      final storage = InMemoryQueueStorage();

      final first = OperationQueue(storage);
      await first.enqueue(op('op-1'));
      await first.enqueue(op('op-2', offset: const Duration(minutes: 1)));

      // A fresh queue over the same storage is what a cold start looks like.
      final second = OperationQueue(storage);
      expect((await second.pending()).length, 2);
    });

    test('sent operations leave the pending set', () async {
      final queue = OperationQueue(InMemoryQueueStorage());
      await queue.enqueue(op('op-1'));

      await queue.markSent('op-1');

      expect(await queue.pending(), isEmpty);
      expect((await queue.counts())[QueuedStatus.sent], 1);
    });

    // Silently dropping a nurse's queued action is worse than surfacing it.
    test('failed operations are kept for a human, not discarded', () async {
      final queue = OperationQueue(InMemoryQueueStorage());
      await queue.enqueue(op('op-1'));

      await queue.markFailed('op-1', 'ORG_FACILITY_RETIRED');

      expect(await queue.pending(), isEmpty);
      expect((await queue.counts())[QueuedStatus.failed], 1);
    });

    test('a recorded failure keeps the operation pending and counts attempts', () async {
      final queue = OperationQueue(InMemoryQueueStorage());
      await queue.enqueue(op('op-1'));

      await queue.recordFailure('op-1', 'OFFLINE');
      await queue.recordFailure('op-1', 'OFFLINE');

      final pending = await queue.pending();
      expect(pending.length, 1);
      expect(pending.first.attempts, 2);
    });
  });

  group('SyncService', () {
    test('delivers everything when the device is online', () async {
      final queue = OperationQueue(InMemoryQueueStorage());
      await queue.enqueue(op('op-1'));
      await queue.enqueue(op('op-2', offset: const Duration(minutes: 1)));

      final delivered = <String>[];
      final result = await SyncService(queue, (o) async => delivered.add(o.id)).sync();

      expect(result.sent, 2);
      expect(result.isComplete, isTrue);
      expect(delivered, ['op-1', 'op-2']);
    });

    // If the device is offline for one operation it is offline for all of them;
    // continuing would inflate every attempt counter for nothing.
    test('stops at the first offline error and defers the rest', () async {
      final queue = OperationQueue(InMemoryQueueStorage());
      for (var i = 0; i < 4; i++) {
        await queue.enqueue(op('op-$i', offset: Duration(minutes: i)));
      }

      var attempts = 0;
      final result = await SyncService(queue, (o) async {
        attempts++;
        throw ApiError.offline();
      }).sync();

      expect(attempts, 1, reason: 'only the first operation should have been attempted');
      expect(result.sent, 0);
      expect(result.deferred, 4);
      expect(result.isComplete, isFalse);
      expect((await queue.pending()).length, 4, reason: 'nothing may be dropped');
    });

    test('resumes cleanly once connectivity returns', () async {
      final queue = OperationQueue(InMemoryQueueStorage());
      for (var i = 0; i < 3; i++) {
        await queue.enqueue(op('op-$i', offset: Duration(minutes: i)));
      }

      var online = false;
      Future<void> sender(QueuedOperation o) async {
        if (!online) throw ApiError.offline();
      }

      final offlineResult = await SyncService(queue, sender).sync();
      expect(offlineResult.sent, 0);

      online = true;
      final onlineResult = await SyncService(queue, sender).sync();

      expect(onlineResult.sent, 3);
      expect(await queue.pending(), isEmpty);
    });

    // A permanent refusal will not succeed on retry, so parking it keeps the
    // queue moving instead of wedging behind one bad operation.
    test('a permanent rejection does not block the rest of the queue', () async {
      final queue = OperationQueue(InMemoryQueueStorage());
      await queue.enqueue(op('op-1'));
      await queue.enqueue(op('op-bad', offset: const Duration(minutes: 1)));
      await queue.enqueue(op('op-3', offset: const Duration(minutes: 2)));

      final result = await SyncService(queue, (o) async {
        if (o.id == 'op-bad') {
          throw ApiError(
            status: ApiStatus.failedPrecondition,
            code: 'ORG_FACILITY_RETIRED',
            correlationId: 'corr-1',
          );
        }
      }).sync();

      expect(result.sent, 2);
      expect(result.failed, 1);
      expect(await queue.pending(), isEmpty);
      expect((await queue.counts())[QueuedStatus.failed], 1);
    });
  });
}

// The durable binding: queued clinical work must survive the app being killed.
// An in-memory queue would appear to work while losing exactly the work the
// user believes is saved.
void _fileQueueTests() {
  group('FileQueueStorage', () {
    test('persists across a fresh queue over the same directory', () async {
      final dir = await Directory.systemTemp.createTemp('queue');
      addTearDown(() => dir.delete(recursive: true));

      final first = OperationQueue(FileQueueStorage.inDirectory(dir));
      await first.enqueue(op('op-1'));
      await first.enqueue(op('op-2', offset: const Duration(minutes: 1)));

      // A cold start is a new queue over the same storage.
      final second = OperationQueue(FileQueueStorage.inDirectory(dir));
      final pending = await second.pending();

      expect(pending.map((o) => o.id), ['op-1', 'op-2']);
    });

    test('an absent file reads as an empty queue rather than an error', () async {
      final dir = await Directory.systemTemp.createTemp('queue');
      addTearDown(() => dir.delete(recursive: true));

      final queue = OperationQueue(FileQueueStorage.inDirectory(dir));
      expect(await queue.pending(), isEmpty);
    });

    // A process killed mid-write must leave the old queue or the new one, never
    // a truncated file that fails to parse and loses everything.
    test('writes atomically, leaving no partial file behind', () async {
      final dir = await Directory.systemTemp.createTemp('queue');
      addTearDown(() => dir.delete(recursive: true));

      final storage = FileQueueStorage.inDirectory(dir);
      final queue = OperationQueue(storage);
      await queue.enqueue(op('op-1'));

      final leftovers = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.tmp'))
          .toList();
      expect(leftovers, isEmpty, reason: 'temporary file was not renamed away');

      final contents = await storage.load();
      expect(contents, isNotNull);
      expect(jsonDecode(contents!), isA<List<dynamic>>());
    });

    test('status changes are persisted, not just held in memory', () async {
      final dir = await Directory.systemTemp.createTemp('queue');
      addTearDown(() => dir.delete(recursive: true));

      final first = OperationQueue(FileQueueStorage.inDirectory(dir));
      await first.enqueue(op('op-1'));
      await first.markSent('op-1');

      final second = OperationQueue(FileQueueStorage.inDirectory(dir));
      expect(await second.pending(), isEmpty);
      expect((await second.counts())[QueuedStatus.sent], 1);
    });
  });
}
