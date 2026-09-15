/// Clinically material timestamp display (SRS-WEB-014).
///
/// The verification clause is "UTC storage is converted consistently and DST
/// tests pass for supported regions", and the word doing the work is
/// *explicitly*. A timestamp rendered without saying which clock it is on is
/// the bug: "administered 01:30" means different things on a ward in Kolkata
/// and to a reader in London, and the reader has no way to tell which they are
/// looking at.
///
/// On a phone this matters more than it does in a browser, not less. A ward
/// tablet travels; a clinician reviewing a transfer is often not in the
/// facility whose record they are reading; and `DateTime.toLocal()` silently
/// renders whatever the device's clock is set to, which is the one zone that
/// is never clinically meaningful. So the zone is always a parameter, never the
/// device's, and it is always part of the rendered string.
library;

import 'package:timezone/timezone.dart' as tz;

/// Thrown when a zone is not one the tz database knows.
class UnknownZoneError implements Exception {
  UnknownZoneError(this.zone);

  final String zone;

  @override
  String toString() => 'UnknownZoneError: unknown time zone: $zone';
}

/// A timestamp rendered for one specific clock.
class DisplayedInstant {
  const DisplayedInstant({
    required this.text,
    required this.zone,
    required this.abbreviation,
    required this.instant,
    required this.ambiguous,
  });

  /// The wall-clock rendering, e.g. "12 Sep 2026, 01:30".
  final String text;

  /// The zone it was rendered in, e.g. "Asia/Kolkata".
  final String zone;

  /// The offset abbreviation in force, e.g. "IST".
  final String abbreviation;

  /// The original instant, so a caller can re-render for another clock.
  final DateTime instant;

  /// True when this wall time occurs twice that day — the daylight-saving
  /// fallback. The UI disambiguates rather than showing an hour that appears
  /// twice in a sorted list with no explanation.
  final bool ambiguous;
}

const _months = <String>[
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

tz.Location _locationFor(String zone) {
  if (zone.isEmpty) {
    throw UnknownZoneError(zone);
  }
  try {
    return tz.getLocation(zone);
  } on tz.LocationNotFoundException {
    throw UnknownZoneError(zone);
  }
}

/// The UTC offset in minutes that a zone was on at an instant.
///
/// Read from the tz database rather than from a table in this file, so it
/// follows tzdata across rule changes instead of needing this code to ship an
/// update every time a country moves its clocks.
int offsetMinutes(DateTime instant, String zone) {
  final location = _locationFor(zone);
  return tz.TZDateTime.from(instant, location).timeZoneOffset.inMinutes;
}

/// Whether a wall time occurs twice in this zone — the fallback hour.
///
/// Detected by asking whether the instant an hour earlier renders to the same
/// wall clock. During a one-hour fallback it does, and two genuinely different
/// instants then print identically.
bool _isAmbiguous(DateTime instant, tz.Location location) {
  final here = tz.TZDateTime.from(instant, location);
  final anHourEarlier =
      tz.TZDateTime.from(instant.subtract(const Duration(hours: 1)), location);
  return here.hour == anHourEarlier.hour &&
      here.day == anHourEarlier.day &&
      here.minute == anHourEarlier.minute;
}

/// Renders an instant on one named clock.
DisplayedInstant forZone(DateTime instant, String zone) {
  final location = _locationFor(zone);
  final local = tz.TZDateTime.from(instant, location);

  final text = '${local.day.toString().padLeft(2, '0')} '
      '${_months[local.month - 1]} ${local.year}, '
      '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';

  return DisplayedInstant(
    text: text,
    zone: zone,
    abbreviation: local.timeZoneName,
    instant: instant,
    ambiguous: _isAmbiguous(instant, location),
  );
}

/// Renders a clinically material timestamp.
///
/// The zone abbreviation is part of the string rather than a tooltip, because a
/// screenshot and a printed page both lose the tooltip and both end up in a
/// case file.
String clinical(DateTime instant, String zone) {
  final displayed = forZone(instant, zone);
  final suffix =
      displayed.abbreviation.isEmpty ? '' : ' ${displayed.abbreviation}';
  // Not decoration: during a fallback hour two different instants render
  // identically, and a clinician comparing two administrations an hour apart
  // would otherwise see the same time twice with no explanation.
  final marker = displayed.ambiguous ? ' (repeated hour)' : '';
  return '${displayed.text}$suffix$marker';
}

/// The same instant on two clocks, for a transfer between sites.
class AcrossSites {
  const AcrossSites({required this.facility, required this.viewer});

  final String facility;

  /// Null when both clocks agree, so a single-site hospital is not shown the
  /// same time twice.
  final String? viewer;
}

/// Renders an instant for the facility and, when they differ, for the reader.
AcrossSites acrossSites(
  DateTime instant,
  String facilityZone,
  String viewerZone,
) {
  final facility = clinical(instant, facilityZone);
  if (offsetMinutes(instant, facilityZone) ==
      offsetMinutes(instant, viewerZone)) {
    return AcrossSites(facility: facility, viewer: null);
  }
  return AcrossSites(
    facility: facility,
    viewer: clinical(instant, viewerZone),
  );
}

/// The device's own IANA zone name, when the platform reports one.
///
/// Deliberately not used for rendering anything clinical. It is here so a
/// screen can *compare* the device clock against the facility clock and say
/// they differ — which is the useful thing to do with it — rather than quietly
/// rendering in it.
String deviceZoneOr(String fallback) {
  final name = DateTime.now().timeZoneName;
  return name.isEmpty ? fallback : name;
}
