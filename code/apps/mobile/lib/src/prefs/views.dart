/// Saved views and column preferences (SRS-WEB-013).
///
/// The verification clause is "preferences are user-scoped and resettable", and
/// both halves are load-bearing on a shared device more than on a shared
/// desktop: a ward tablet is handed between nurses on the same shift, and a
/// preference that outlives the handover belongs to whoever set it, not to the
/// device.
///
/// Resettable, because a saved view can be wrong in a way its owner cannot see:
/// a filter narrow enough to hide the patients they are looking for looks
/// exactly like an empty worklist.
library;

import 'package:meta/meta.dart';

/// One column's presentation in a worklist.
@immutable
class ColumnPreference {
  const ColumnPreference({
    required this.key,
    required this.visible,
    required this.position,
    this.width,
  });

  final String key;
  final bool visible;

  /// Display order, ascending.
  final int position;

  /// Logical width, or null to let the layout decide.
  final double? width;

  ColumnPreference copyWith({bool? visible, int? position, double? width}) =>
      ColumnPreference(
        key: key,
        visible: visible ?? this.visible,
        position: position ?? this.position,
        width: width ?? this.width,
      );

  Map<String, dynamic> toJson() => {
        'key': key,
        'visible': visible,
        'position': position,
        'width': width,
      };

  static ColumnPreference fromJson(Map<String, dynamic> json) =>
      ColumnPreference(
        key: json['key'] as String,
        visible: json['visible'] as bool? ?? true,
        position: json['position'] as int? ?? 0,
        width: (json['width'] as num?)?.toDouble(),
      );
}

/// A named, saved configuration of a worklist.
@immutable
class SavedView {
  const SavedView({
    required this.id,
    required this.name,
    required this.worklist,
    required this.columns,
    this.filters = const {},
    this.sortKey,
    this.sortDescending = false,
  });

  final String id;
  final String name;
  final String worklist;
  final List<ColumnPreference> columns;

  /// Opaque filter state, owned by the worklist that defined it.
  final Map<String, String> filters;
  final String? sortKey;
  final bool sortDescending;
}

/// The columns a worklist ships with, before any preference is applied.
@immutable
class WorklistDefinition {
  const WorklistDefinition({
    required this.worklist,
    required this.columns,
    required this.mandatoryColumns,
  });

  final String worklist;
  final List<ColumnPreference> columns;

  /// Columns that may never be hidden. Allergies, alerts, patient identifiers:
  /// a preference that can hide a safety-critical column is a preference that
  /// will hide one.
  final List<String> mandatoryColumns;
}

/// Thrown when a preference would produce an unusable or unsafe view.
class InvalidViewError implements Exception {
  InvalidViewError(this.message);
  final String message;

  @override
  String toString() => 'InvalidViewError: $message';
}

/// Applies saved preferences to a worklist's definition.
///
/// Unknown columns in the saved view are dropped and columns the definition has
/// gained are appended visible. That combination is what makes a saved view
/// survive a release: a view saved last month must not break when a column is
/// added, and must not hide a new column the user has never seen — a hidden new
/// column is indistinguishable from one that does not exist.
List<ColumnPreference> applyPreferences(
  WorklistDefinition definition,
  SavedView? view,
) {
  if (view == null) {
    return [...definition.columns]
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  final saved = {for (final c in view.columns) c.key: c};
  final mandatory = definition.mandatoryColumns.toSet();

  final resolved = <ColumnPreference>[];
  for (var i = 0; i < definition.columns.length; i++) {
    final column = definition.columns[i];
    final preference = saved[column.key];
    if (preference == null) {
      // A column the definition gained since the view was saved. Visible, and
      // placed after the saved ones so it does not silently displace a column
      // the user deliberately ordered.
      resolved.add(column.copyWith(position: 1000 + i));
      continue;
    }
    resolved.add(
      ColumnPreference(
        key: column.key,
        // Mandatory columns ignore the saved visibility. A view saved before a
        // column became mandatory would otherwise keep hiding it.
        visible: mandatory.contains(column.key) ? true : preference.visible,
        position: preference.position,
        width: preference.width,
      ),
    );
  }

  return resolved..sort((a, b) => a.position.compareTo(b.position));
}

/// Validates a view before it is saved.
///
/// Rejects rather than silently corrects. A silently corrected preference is
/// one the user will set again, because from their side nothing happened.
void validateView(WorklistDefinition definition, SavedView view) {
  if (view.name.trim().isEmpty) {
    throw InvalidViewError('a saved view needs a name');
  }
  if (view.worklist != definition.worklist) {
    throw InvalidViewError(
      'view is for worklist ${view.worklist}, not ${definition.worklist}',
    );
  }

  final known = {for (final c in definition.columns) c.key};
  for (final column in view.columns) {
    if (!known.contains(column.key)) {
      throw InvalidViewError('unknown column ${column.key}');
    }
  }

  for (final key in definition.mandatoryColumns) {
    final preference =
        view.columns.where((c) => c.key == key).cast<ColumnPreference?>().firstOrNull;
    if (preference != null && !preference.visible) {
      throw InvalidViewError(
        'column $key cannot be hidden: it carries information the worklist '
        'must always show',
      );
    }
  }

  if (!view.columns.any((c) => c.visible)) {
    throw InvalidViewError('a view must show at least one column');
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
