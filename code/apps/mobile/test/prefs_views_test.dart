/// SRS-WEB-013 — saved views and column preferences.
///
/// The interesting cases are not "does a preference apply". They are what
/// happens when the worklist changes under a view that was saved months ago,
/// and what a preference is not allowed to do to a safety-critical column.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/prefs/views.dart';

const _definition = WorklistDefinition(
  worklist: 'ward-round',
  columns: [
    ColumnPreference(key: 'patient', visible: true, position: 0),
    ColumnPreference(key: 'allergies', visible: true, position: 1),
    ColumnPreference(key: 'bed', visible: true, position: 2),
    ColumnPreference(key: 'consultant', visible: true, position: 3),
  ],
  mandatoryColumns: ['patient', 'allergies'],
);

SavedView view({
  String name = 'My round',
  String worklist = 'ward-round',
  required List<ColumnPreference> columns,
}) =>
    SavedView(
      id: 'v1',
      name: name,
      worklist: worklist,
      columns: columns,
    );

void main() {
  group('applying preferences', () {
    test('no saved view leaves the worklist in its defined order', () {
      final columns = applyPreferences(_definition, null);

      expect(columns.map((c) => c.key), ['patient', 'allergies', 'bed', 'consultant']);
      expect(columns.every((c) => c.visible), isTrue);
    });

    test('a saved view reorders and hides the columns it names', () {
      final columns = applyPreferences(
        _definition,
        view(columns: const [
          ColumnPreference(key: 'bed', visible: true, position: 0),
          ColumnPreference(key: 'patient', visible: true, position: 1),
          ColumnPreference(key: 'allergies', visible: true, position: 2),
          ColumnPreference(key: 'consultant', visible: false, position: 3),
        ]),
      );

      expect(columns.map((c) => c.key), ['bed', 'patient', 'allergies', 'consultant']);
      expect(columns.last.visible, isFalse);
    });

    test('a column added since the view was saved appears, visible, at the end', () {
      // A hidden new column is indistinguishable from one that does not exist,
      // so a view saved before the column existed must not hide it.
      final columns = applyPreferences(
        _definition,
        view(columns: const [
          ColumnPreference(key: 'patient', visible: true, position: 0),
          ColumnPreference(key: 'allergies', visible: true, position: 1),
        ]),
      );

      expect(columns.map((c) => c.key).take(2), ['patient', 'allergies']);
      final added = columns.where((c) => c.key == 'bed' || c.key == 'consultant');
      expect(added, hasLength(2));
      expect(added.every((c) => c.visible), isTrue);
    });

    test('a new column does not displace columns the user deliberately ordered', () {
      final columns = applyPreferences(
        _definition,
        view(columns: const [
          // The user put the consultant first. A column the release added must
          // not land above it.
          ColumnPreference(key: 'consultant', visible: true, position: 0),
          ColumnPreference(key: 'patient', visible: true, position: 1),
          ColumnPreference(key: 'allergies', visible: true, position: 2),
        ]),
      );

      expect(columns.first.key, 'consultant');
      expect(columns.last.key, 'bed');
    });

    test('a column dropped from the worklist is dropped from the view', () {
      // Not an error: the saved view is older than the release, and refusing to
      // open it would strand the user on a worklist they cannot use.
      final columns = applyPreferences(
        _definition,
        view(columns: const [
          ColumnPreference(key: 'patient', visible: true, position: 0),
          ColumnPreference(key: 'allergies', visible: true, position: 1),
          ColumnPreference(key: 'discharge-date', visible: true, position: 2),
        ]),
      );

      expect(columns.map((c) => c.key), isNot(contains('discharge-date')));
    });

    test('a view saved before a column became mandatory stops hiding it', () {
      final columns = applyPreferences(
        _definition,
        view(columns: const [
          ColumnPreference(key: 'patient', visible: true, position: 0),
          // Hidden when the view was saved; mandatory now.
          ColumnPreference(key: 'allergies', visible: false, position: 1),
          ColumnPreference(key: 'bed', visible: true, position: 2),
          ColumnPreference(key: 'consultant', visible: true, position: 3),
        ]),
      );

      final allergies = columns.firstWhere((c) => c.key == 'allergies');
      expect(allergies.visible, isTrue);
    });

    test('a saved width survives, and an unset one stays unset', () {
      final columns = applyPreferences(
        _definition,
        view(columns: const [
          ColumnPreference(key: 'patient', visible: true, position: 0, width: 220),
          ColumnPreference(key: 'allergies', visible: true, position: 1),
          ColumnPreference(key: 'bed', visible: true, position: 2),
          ColumnPreference(key: 'consultant', visible: true, position: 3),
        ]),
      );

      expect(columns.firstWhere((c) => c.key == 'patient').width, 220);
      expect(columns.firstWhere((c) => c.key == 'bed').width, isNull);
    });

    test('applying a view leaves the definition untouched for the next user', () {
      // The ward tablet is handed over mid-shift. One nurse's view must not
      // become the device's default.
      applyPreferences(
        _definition,
        view(columns: const [
          ColumnPreference(key: 'consultant', visible: true, position: 0),
          ColumnPreference(key: 'patient', visible: true, position: 1),
          ColumnPreference(key: 'allergies', visible: true, position: 2),
          ColumnPreference(key: 'bed', visible: false, position: 3),
        ]),
      );

      final fresh = applyPreferences(_definition, null);
      expect(fresh.map((c) => c.key), ['patient', 'allergies', 'bed', 'consultant']);
      expect(fresh.every((c) => c.visible), isTrue);
    });
  });

  group('validating a view before it is saved', () {
    test('a usable view is accepted', () {
      expect(
        () => validateView(
          _definition,
          view(columns: const [
            ColumnPreference(key: 'patient', visible: true, position: 0),
            ColumnPreference(key: 'allergies', visible: true, position: 1),
            ColumnPreference(key: 'bed', visible: false, position: 2),
          ]),
        ),
        returnsNormally,
      );
    });

    test('a view without a name is refused', () {
      expect(
        () => validateView(
          _definition,
          view(name: '   ', columns: const [
            ColumnPreference(key: 'patient', visible: true, position: 0),
          ]),
        ),
        throwsA(isA<InvalidViewError>()),
      );
    });

    test('a view belonging to another worklist is refused', () {
      expect(
        () => validateView(
          _definition,
          view(worklist: 'theatre-list', columns: const [
            ColumnPreference(key: 'patient', visible: true, position: 0),
          ]),
        ),
        throwsA(
          isA<InvalidViewError>().having(
            (e) => e.message,
            'message',
            contains('theatre-list'),
          ),
        ),
      );
    });

    test('a view naming a column the worklist does not have is refused', () {
      expect(
        () => validateView(
          _definition,
          view(columns: const [
            ColumnPreference(key: 'patient', visible: true, position: 0),
            ColumnPreference(key: 'nhs-number', visible: true, position: 1),
          ]),
        ),
        throwsA(
          isA<InvalidViewError>().having(
            (e) => e.message,
            'message',
            contains('nhs-number'),
          ),
        ),
      );
    });

    test('hiding a safety-critical column is refused, not quietly corrected', () {
      // applyPreferences forces the column back on, but that is the repair path
      // for a view saved before the rule existed. A view being saved now is
      // told, so the user knows the preference did not take.
      expect(
        () => validateView(
          _definition,
          view(columns: const [
            ColumnPreference(key: 'patient', visible: true, position: 0),
            ColumnPreference(key: 'allergies', visible: false, position: 1),
          ]),
        ),
        throwsA(
          isA<InvalidViewError>().having(
            (e) => e.message,
            'message',
            contains('allergies'),
          ),
        ),
      );
    });

    test('a view that shows nothing is refused', () {
      expect(
        () => validateView(
          _definition,
          view(columns: const [
            ColumnPreference(key: 'bed', visible: false, position: 0),
            ColumnPreference(key: 'consultant', visible: false, position: 1),
          ]),
        ),
        throwsA(isA<InvalidViewError>()),
      );
    });

    test('the error says what is wrong in words the user can act on', () {
      try {
        validateView(
          _definition,
          view(columns: const [
            ColumnPreference(key: 'patient', visible: true, position: 0),
            ColumnPreference(key: 'allergies', visible: false, position: 1),
          ]),
        );
        fail('expected the view to be refused');
      } on InvalidViewError catch (error) {
        expect(error.toString(), startsWith('InvalidViewError:'));
        expect(error.message, contains('must always show'));
      }
    });
  });

  group('resetting', () {
    test('discarding the view returns the worklist as shipped', () {
      // Resettable is half the requirement: a filter narrow enough to hide the
      // patients the user is looking for looks exactly like an empty worklist,
      // and the only way out is a reset that ignores the saved state entirely.
      final narrowed = applyPreferences(
        _definition,
        view(columns: const [
          ColumnPreference(key: 'patient', visible: true, position: 0),
          ColumnPreference(key: 'allergies', visible: true, position: 1),
          ColumnPreference(key: 'bed', visible: false, position: 2),
          ColumnPreference(key: 'consultant', visible: false, position: 3),
        ]),
      );
      expect(narrowed.where((c) => c.visible), hasLength(2));

      final reset = applyPreferences(_definition, null);
      expect(reset.where((c) => c.visible), hasLength(4));
    });
  });

  group('round-tripping a preference through storage', () {
    test('a preference survives being written and read back', () {
      const original =
          ColumnPreference(key: 'bed', visible: false, position: 3, width: 96);
      final restored = ColumnPreference.fromJson(original.toJson());

      expect(restored.key, original.key);
      expect(restored.visible, original.visible);
      expect(restored.position, original.position);
      expect(restored.width, original.width);
    });

    test('a preference written by an older build reads as visible', () {
      // Defaulting the other way would hide a column because a field was
      // missing, which is the same failure as hiding a new one.
      final restored = ColumnPreference.fromJson({'key': 'bed'});

      expect(restored.visible, isTrue);
      expect(restored.position, 0);
      expect(restored.width, isNull);
    });
  });
}
