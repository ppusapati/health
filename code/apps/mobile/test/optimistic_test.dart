import 'package:flutter_test/flutter_test.dart';

import 'package:health_mobile/src/api/optimistic.dart';

void main() {
  group('where optimism is permitted', () {
    test('allows preferences and acknowledgements', () {
      expect(mayBeOptimistic(OperationKind.preference), isTrue);
      expect(mayBeOptimistic(OperationKind.acknowledgement), isTrue);
    });

    test('refuses clinical, financial and medication writes', () {
      // Not because they are important in the abstract: showing them as done
      // changes what the user does next. A nurse who sees a dose recorded does
      // not record it again, and a rollback arriving after they have walked
      // away leaves a dose nobody gave and nobody knows is missing.
      for (final kind in [
        OperationKind.clinicalWrite,
        OperationKind.financialWrite,
        OperationKind.medicationWrite,
      ]) {
        expect(mayBeOptimistic(kind), isFalse);
      }
    });

    test('throws rather than silently degrading when optimism is attempted', () {
      // Quietly falling back to a confirmed update would make the forbidden
      // list advisory, and a call site that wanted optimism would keep it.
      expect(
        () => optimistic<int>(
          kind: OperationKind.medicationWrite,
          original: 0,
          optimistic: 1,
          commit: () async => 1,
        ),
        throwsA(isA<OptimismForbiddenError>()),
      );
    });
  });

  group('an optimistic update', () {
    test('shows the optimistic value, then the server\'s', () async {
      final states = <OptimisticState>[];
      final result = await optimistic<String>(
        kind: OperationKind.preference,
        original: 'list',
        optimistic: 'grid',
        commit: () async => 'grid',
        onChange: (r) => states.add(r.state),
      );

      expect(states, [OptimisticState.pending, OptimisticState.confirmed]);
      expect(result.value, 'grid');
      expect(result.needsAcknowledgement, isFalse);
    });

    test('rolls back visibly, with a reason', () async {
      // A rollback that happens quietly while the screen is in a pocket is a
      // change the user never learns about.
      final states = <OptimisticState>[];
      final result = await optimistic<String>(
        kind: OperationKind.preference,
        original: 'list',
        optimistic: 'grid',
        commit: () async => throw Exception('the server refused'),
        onChange: (r) => states.add(r.state),
      );

      expect(states, [OptimisticState.pending, OptimisticState.rolledBack]);
      expect(result.value, 'list', reason: 'the original comes back');
      expect(result.reason, contains('refused'));
      expect(result.needsAcknowledgement, isTrue);
    });

    test('takes the server\'s value rather than assuming its own', () async {
      // The server may normalise, clamp or reject part of the change, and
      // keeping the optimistic value would leave the screen disagreeing with
      // the record.
      final result = await optimistic<int>(
        kind: OperationKind.preference,
        original: 10,
        optimistic: 999,
        commit: () async => 100,
      );
      expect(result.value, 100);
    });
  });

  group('a confirmed update', () {
    test('never shows a value the server has not returned', () async {
      final seen = <int>[];
      final result = await confirmed<int>(
        original: 1,
        commit: () async => 2,
        onChange: (r) => seen.add(r.value),
      );
      expect(seen, [1, 2], reason: 'pending shows the original, not a guess');
      expect(result.value, 2);
    });

    test('reports a failure as a rollback with the original intact', () async {
      final result = await confirmed<int>(
        original: 1,
        commit: () async => throw Exception('offline'),
      );
      expect(result.state, OptimisticState.rolledBack);
      expect(result.value, 1);
      expect(result.needsAcknowledgement, isTrue);
    });
  });
}
