/// Optimistic updates, and where they are forbidden (SRS-WEB-007).
///
/// The requirement permits optimistic UI "only where server conflict semantics
/// are defined and rollback is visible". Both halves are constraints, and the
/// second is the one a mobile app gets wrong: a phone is frequently offline, so
/// the gap between showing a result and the server confirming it can be
/// minutes rather than milliseconds, and a rollback that happens quietly while
/// the screen is in a pocket is a change the user never learns about.
///
/// So an optimistic result here is never silently reverted. A rollback carries
/// the reason and stays visible until it is acknowledged, and the operations
/// where that is not good enough are refused outright rather than left to a
/// caller's judgement.
library;

import 'dart:async';

/// The kinds of operation an optimistic update may be attempted for.
enum OperationKind {
  /// A user's own view preference. Wrong for nobody but them, and instantly
  /// re-settable.
  preference,

  /// Marking something read or acknowledged in a worklist.
  acknowledgement,

  /// Anything that writes to the clinical record.
  clinicalWrite,

  /// Anything that moves money.
  financialWrite,

  /// Anything that administers or prescribes a medicine.
  medicationWrite,
}

/// Thrown when optimism is attempted where it is not permitted.
class OptimismForbiddenError implements Exception {
  OptimismForbiddenError(this.kind);

  final OperationKind kind;

  @override
  String toString() =>
      'OptimismForbiddenError: $kind must not be shown as done before the '
      'server confirms it';
}

/// Whether an optimistic update is permitted for this kind of operation.
///
/// Clinical, financial and medication writes are refused. The reason is not
/// that they are important in the abstract — it is that showing them as done
/// changes what the user does next: a nurse who sees a dose recorded does not
/// record it again, and a rollback arriving after they have walked away leaves
/// a dose nobody gave and nobody knows is missing.
bool mayBeOptimistic(OperationKind kind) =>
    kind == OperationKind.preference || kind == OperationKind.acknowledgement;

/// Where an optimistic value stands.
enum OptimisticState { idle, pending, confirmed, rolledBack }

/// An optimistic value and what became of it.
class OptimisticResult<T> {
  const OptimisticResult({
    required this.value,
    required this.state,
    this.reason = '',
  });

  /// What the screen should show: the optimistic value while pending, the
  /// server's value once confirmed, the original once rolled back.
  final T value;

  final OptimisticState state;

  /// Why it was rolled back. Non-empty only for [OptimisticState.rolledBack],
  /// and shown to the user rather than logged — a silent revert is a change
  /// the user never learns about.
  final String reason;

  bool get needsAcknowledgement => state == OptimisticState.rolledBack;
}

/// Applies an update optimistically, rolling back visibly on failure.
///
/// [optimistic] is shown immediately; [commit] is the server call. On failure
/// the original value comes back with the reason attached, so the caller
/// renders the revert rather than quietly dropping it.
Future<OptimisticResult<T>> optimistic<T>({
  required OperationKind kind,
  required T original,
  required T optimistic,
  required Future<T> Function() commit,
  void Function(OptimisticResult<T>)? onChange,
}) async {
  if (!mayBeOptimistic(kind)) {
    throw OptimismForbiddenError(kind);
  }

  onChange?.call(
    OptimisticResult(value: optimistic, state: OptimisticState.pending),
  );

  try {
    final confirmed = await commit();
    final result =
        OptimisticResult(value: confirmed, state: OptimisticState.confirmed);
    onChange?.call(result);
    return result;
  } catch (error) {
    final result = OptimisticResult(
      value: original,
      state: OptimisticState.rolledBack,
      // The message, not the exception: it is going on a screen.
      reason: _describe(error),
    );
    onChange?.call(result);
    return result;
  }
}

/// Runs an operation that must not be shown as done until the server says so.
///
/// The counterpart to [optimistic], and the one every clinical path uses. The
/// screen shows pending, then the server's answer — never a guess.
Future<OptimisticResult<T>> confirmed<T>({
  required T original,
  required Future<T> Function() commit,
  void Function(OptimisticResult<T>)? onChange,
}) async {
  onChange?.call(
    OptimisticResult(value: original, state: OptimisticState.pending),
  );
  try {
    final settled = await commit();
    final result =
        OptimisticResult(value: settled, state: OptimisticState.confirmed);
    onChange?.call(result);
    return result;
  } catch (error) {
    final result = OptimisticResult(
      value: original,
      state: OptimisticState.rolledBack,
      reason: _describe(error),
    );
    onChange?.call(result);
    return result;
  }
}

String _describe(Object error) {
  final text = error.toString();
  return text.isEmpty ? 'The change could not be saved.' : text;
}
