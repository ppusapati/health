import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'package:health_mobile/src/time/display.dart';

void main() {
  setUpAll(tzdata.initializeTimeZones);

  group('rendering a clinically material timestamp', () {
    test('always names the clock it is on', () {
      // A time with no zone is the bug: "administered 01:30" means different
      // things on a ward in Kolkata and to a reader in London, and the reader
      // cannot tell which they are looking at.
      final instant = DateTime.utc(2026, 9, 12, 20, 0);
      final rendered = clinical(instant, 'Asia/Kolkata');

      expect(rendered, contains('13 Sep 2026, 01:30'));
      expect(rendered, contains('IST'));
    });

    test('renders the same instant differently on two clocks', () {
      final instant = DateTime.utc(2026, 9, 12, 20, 0);
      expect(forZone(instant, 'Asia/Kolkata').text, '13 Sep 2026, 01:30');
      expect(forZone(instant, 'Europe/London').text, '12 Sep 2026, 21:00');
      expect(forZone(instant, 'UTC').text, '12 Sep 2026, 20:00');
    });

    test('refuses a zone the database does not know', () {
      final instant = DateTime.utc(2026, 9, 12, 20, 0);
      expect(() => clinical(instant, 'Mars/Olympus'), throwsA(isA<UnknownZoneError>()));
      expect(() => clinical(instant, ''), throwsA(isA<UnknownZoneError>()));
    });
  });

  group('daylight saving', () {
    test('follows the offset across a spring transition', () {
      // London moves to BST at 01:00 UTC on the last Sunday in March.
      final before = DateTime.utc(2026, 3, 29, 0, 30);
      final after = DateTime.utc(2026, 3, 29, 1, 30);

      expect(offsetMinutes(before, 'Europe/London'), 0);
      expect(offsetMinutes(after, 'Europe/London'), 60);
      expect(forZone(before, 'Europe/London').text, '29 Mar 2026, 00:30');
      expect(forZone(after, 'Europe/London').text, '29 Mar 2026, 02:30');
    });

    test('marks the hour that happens twice', () {
      // London falls back at 02:00 BST on the last Sunday in October, so
      // 01:30 local occurs at both 00:30 and 01:30 UTC. Two genuinely
      // different instants print identically, and a clinician comparing two
      // administrations an hour apart would see the same time twice.
      final first = DateTime.utc(2026, 10, 25, 0, 30);
      final second = DateTime.utc(2026, 10, 25, 1, 30);

      expect(forZone(first, 'Europe/London').text, forZone(second, 'Europe/London').text);
      expect(forZone(second, 'Europe/London').ambiguous, isTrue);
      expect(clinical(second, 'Europe/London'), contains('repeated hour'));
    });

    test('does not mark an ordinary hour as repeated', () {
      final ordinary = DateTime.utc(2026, 6, 1, 12, 0);
      expect(forZone(ordinary, 'Europe/London').ambiguous, isFalse);
      expect(clinical(ordinary, 'Europe/London'), isNot(contains('repeated')));
    });

    test('handles a zone with no daylight saving at all', () {
      // India does not observe it, so the offset is the same in June and
      // December — the case a test suite written only against London misses.
      final june = DateTime.utc(2026, 6, 1, 12, 0);
      final december = DateTime.utc(2026, 12, 1, 12, 0);
      expect(offsetMinutes(june, 'Asia/Kolkata'), 330);
      expect(offsetMinutes(december, 'Asia/Kolkata'), 330);
    });
  });

  group('a transfer between sites', () {
    test('shows both clocks when they differ', () {
      final instant = DateTime.utc(2026, 9, 12, 20, 0);
      final rendered = acrossSites(instant, 'Asia/Kolkata', 'Europe/London');

      expect(rendered.facility, contains('13 Sep 2026, 01:30'));
      expect(rendered.viewer, isNotNull);
      expect(rendered.viewer, contains('12 Sep 2026, 21:00'));
    });

    test('shows one clock when they agree', () {
      // A single-site hospital must not be shown the same time twice.
      final instant = DateTime.utc(2026, 9, 12, 20, 0);
      final rendered = acrossSites(instant, 'Asia/Kolkata', 'Asia/Kolkata');
      expect(rendered.viewer, isNull);
    });

    test('compares by offset rather than by zone name', () {
      // Two different zone names on the same offset are the same clock to a
      // reader, and showing both would be noise.
      final instant = DateTime.utc(2026, 1, 15, 12, 0);
      final rendered = acrossSites(instant, 'Europe/London', 'Europe/Lisbon');
      expect(rendered.viewer, isNull);
    });
  });

  group('the device clock', () {
    test('is reported for comparison, not used for rendering', () {
      // Every rendering function takes a zone. The device's own zone is
      // available only so a screen can say the two differ.
      expect(deviceZoneOr('UTC'), isNotEmpty);
    });
  });

  group('tz database', () {
    test('resolves a zone with a half-hour offset', () {
      // Half-hour and three-quarter-hour offsets are where a hand-rolled
      // offset table goes wrong.
      final instant = DateTime.utc(2026, 6, 1, 12, 0);
      expect(offsetMinutes(instant, 'Asia/Kathmandu'), 345);
      expect(offsetMinutes(instant, 'Australia/Adelaide'), 570);
    });

    test('is initialised for every zone the app may be given', () {
      expect(() => tz.getLocation('America/New_York'), returnsNormally);
      expect(() => tz.getLocation('Africa/Nairobi'), returnsNormally);
    });
  });
}
