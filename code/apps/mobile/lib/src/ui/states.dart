/// The states every screen has to be able to be in (SRS-WEB-006).
///
/// The requirement lists them — loading, saved, validation, conflict, failure —
/// and the UX specification adds empty and permission-denied. The failure this
/// prevents is a screen that renders several of them identically: an empty
/// worklist and a worklist the user may not see look the same from the outside
/// and mean completely different things, one being a quiet morning and the
/// other being a call to an administrator.
///
/// They live here as one widget with a named kind rather than as seven
/// widgets, so a screen cannot invent a seventh rendering and so the set can be
/// asserted against the accessibility guidelines in one place.
///
/// Every state announces itself. On a phone the screen is frequently not being
/// looked at when the state changes — it is in a pocket, or the user is holding
/// a patient's arm — so a state that only changes colour is a state that is
/// missed.
library;

import 'package:flutter/material.dart';

/// What a screen is currently showing instead of its content.
enum ScreenStateKind {
  /// A request is in flight.
  loading,

  /// The request returned nothing.
  empty,

  /// Nothing has been asked for yet. Distinct from [empty]: they look the same
  /// and mean the opposite things.
  awaitingInput,

  /// The user may not see this.
  permissionDenied,

  /// The record changed underneath the user.
  conflict,

  /// Something went wrong.
  failure,

  /// The change was saved.
  saved,
}

/// A screen state, rendered consistently and announced to assistive technology.
class ScreenState extends StatelessWidget {
  const ScreenState({
    super.key,
    required this.kind,
    required this.title,
    this.detail = '',
    this.onRetry,
    this.retryLabel = 'Try again',
  });

  final ScreenStateKind kind;
  final String title;
  final String detail;

  /// Offered only where an identical retry is safe. A retry button on a
  /// non-idempotent failure is how one charge becomes two.
  final VoidCallback? onRetry;
  final String retryLabel;

  bool get _isAlert =>
      kind == ScreenStateKind.failure || kind == ScreenStateKind.conflict;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground) = switch (kind) {
      ScreenStateKind.failure ||
      ScreenStateKind.conflict =>
        (const Color(0xFFFDECEB), const Color(0xFF7A1C17)),
      ScreenStateKind.permissionDenied =>
        (const Color(0xFFFDF3E0), const Color(0xFF6B4708)),
      ScreenStateKind.saved =>
        (const Color(0xFFE7F5EC), const Color(0xFF11593A)),
      _ => (scheme.surfaceContainerHighest, const Color(0xFF33415C)),
    };

    // One node for the whole state, carrying the full sentence.
    //
    // The child Text widgets are excluded rather than left to compose
    // themselves: read separately, "Nothing to show" and the detail below it
    // arrive as two unrelated announcements, and the retry button lands between
    // them. `excludeSemantics` keeps the visible text visible and makes the
    // spoken version one sentence.
    return Semantics(
      container: true,
      liveRegion: true,
      label: _isAlert
          // The prefix goes first so a screen reader says something is wrong
          // before saying what, rather than after.
          ? 'Error. $title${detail.isEmpty ? '' : '. $detail'}'
          : '$title${detail.isEmpty ? '' : '. $detail'}',
      excludeSemantics: true,
      child: Container(
        key: Key('screen-state-${kind.name}'),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (kind == ScreenStateKind.loading) ...[
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, color: foreground),
            ),
            if (detail.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                detail,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: foreground),
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              // Outside the excluded subtree, so the action stays operable and
              // keeps its own label. A minimum tap target rather than the
              // default, which on a dense list falls below both platform
              // guidelines.
              Semantics(
                excludeSemantics: false,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 88, minHeight: 48),
                  child: FilledButton(
                    onPressed: onRetry,
                    child: Text(retryLabel),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// An inline validation message for one field.
///
/// Tied to the field by [fieldLabel] rather than by proximity: a screen reader
/// reads the message on its own, and "This field is required" with no field
/// name is unusable.
class FieldError extends StatelessWidget {
  const FieldError({
    super.key,
    required this.fieldLabel,
    required this.message,
  });

  final String fieldLabel;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      label: '$fieldLabel: $message',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          message,
          style: const TextStyle(fontSize: 12, color: Color(0xFF7A1C17)),
        ),
      ),
    );
  }
}
