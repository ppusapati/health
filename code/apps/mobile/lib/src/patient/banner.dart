/// The patient banner, for a bedside device (SRS-EMPI-001, SRS-CLN-005).
///
/// The web shell has a banner too, and this is deliberately not a copy of it. A
/// desk terminal has room for a demographic header; a tablet held in one hand
/// at a bedside has room for the things that change what the next thirty
/// seconds should be. So this carries allergies, which the web banner leaves to
/// the chart, and it carries them first.
///
/// The ordering rule throughout: whatever would make the reader stop.
library;

import 'package:meta/meta.dart';

/// Mirrors empi.v1.Sex.
enum Sex { female, male, other, unknown, unspecified }

/// How certain an allergy is (mirrors clinical.v1.AllergyCriticality).
enum AllergyCriticality { high, low, unableToAssess, unspecified }

/// Whether an allergy is still believed (mirrors clinical.v1.AllergyStatus).
enum AllergyStatus { active, inactive, resolved, enteredInError, unspecified }

String _sexLabel(Sex sex) => switch (sex) {
      Sex.female => 'Female',
      Sex.male => 'Male',
      Sex.other => 'Other',
      Sex.unknown => 'Unknown',
      Sex.unspecified => 'Not recorded',
    };

/// One allergy as the banner shows it.
@immutable
class BannerAllergy {
  const BannerAllergy({
    required this.substance,
    required this.reaction,
    required this.criticality,
    required this.status,
  });

  final String substance;
  final String reaction;
  final AllergyCriticality criticality;
  final AllergyStatus status;

  /// Whether this allergy should stop somebody about to give a drug.
  bool get active => status == AllergyStatus.active;

  /// What the chip says. The substance always; the reaction when there is one,
  /// because "penicillin — anaphylaxis" and "penicillin — rash" are different
  /// decisions.
  String get label =>
      reaction.trim().isEmpty ? substance : '$substance — $reaction';
}

int _criticalityRank(AllergyCriticality criticality) => switch (criticality) {
      AllergyCriticality.high => 0,
      AllergyCriticality.unableToAssess => 1,
      AllergyCriticality.low => 2,
      AllergyCriticality.unspecified => 3,
    };

/// One thing about the record itself that the reader needs to know.
@immutable
class BannerAlert {
  const BannerAlert({
    required this.kind,
    required this.text,
    required this.severity,
  });

  final String kind;
  final String text;

  /// Lower sorts first.
  final int severity;
}

/// What the banner shows.
@immutable
class PatientBanner {
  const PatientBanner({
    required this.patientId,
    required this.displayName,
    required this.age,
    required this.sex,
    required this.allergies,
    required this.alerts,
    required this.readOnly,
    required this.allergiesUnknown,
  });

  final String patientId;
  final String displayName;
  final String age;
  final String sex;

  /// Active allergies, most critical first. Inactive and entered-in-error ones
  /// are dropped: a banner listing a resolved allergy trains staff to read past
  /// the allergy line, which is the one line that must not be read past.
  final List<BannerAllergy> allergies;

  final List<BannerAlert> alerts;

  /// Deceased and merged-away records take no new activity. Computed here so
  /// every screen disables its actions the same way rather than each
  /// discovering the rule when the server refuses.
  final bool readOnly;

  /// True when nobody has recorded whether this patient has allergies.
  ///
  /// Distinct from having none, and the distinction is the point: an empty
  /// allergy list reads as "no allergies" and an unasked question must not.
  final bool allergiesUnknown;

  /// Whether anything here should stop a medication round.
  bool get hasHighCriticalityAllergy =>
      allergies.any((a) => a.criticality == AllergyCriticality.high);
}

/// Age in whole years, in the form a ward says out loud.
///
/// Under two years old it is months, because "1y" covers a period in which a
/// dose changes several times.
String displayAge(DateTime? birthDate, DateTime now) {
  if (birthDate == null) return 'Age not recorded';

  var years = now.year - birthDate.year;
  final hadBirthday = now.month > birthDate.month ||
      (now.month == birthDate.month && now.day >= birthDate.day);
  if (!hadBirthday) years -= 1;
  if (years < 0) return 'Age not recorded';

  if (years >= 2) return '${years}y';

  var months = (now.year - birthDate.year) * 12 + now.month - birthDate.month;
  if (now.day < birthDate.day) months -= 1;
  if (months < 0) months = 0;
  return '${months}m';
}

/// Joins a name without assuming a family name exists.
///
/// Some cultures record none, and a template that assumes "given family"
/// produces a trailing space and a name that looks truncated.
String displayName(String given, String family) =>
    [given.trim(), family.trim()].where((p) => p.isNotEmpty).join(' ');

/// Builds the banner.
PatientBanner bannerFor({
  required String patientId,
  required String given,
  required String family,
  required DateTime? birthDate,
  required Sex sex,
  required DateTime now,
  List<BannerAllergy> allergies = const [],
  bool allergiesRecorded = false,
  bool deceased = false,
  String mergedInto = '',
  bool identityConfirmed = true,
  bool masked = false,
  String unidentifiedLabel = '',
}) {
  final alerts = <BannerAlert>[];

  if (deceased) {
    alerts.add(const BannerAlert(kind: 'deceased', text: 'Deceased', severity: 0));
  }
  if (mergedInto.isNotEmpty) {
    alerts.add(BannerAlert(
      kind: 'merged',
      // The survivor's id, not a vague "this record was merged": the point is
      // that the reader can get to the record that is current.
      text: 'Merged into $mergedInto',
      severity: 1,
    ));
  }
  if (!identityConfirmed) {
    alerts.add(const BannerAlert(
      kind: 'unidentified',
      text: 'Identity not confirmed',
      severity: 2,
    ));
  }
  if (masked) {
    alerts.add(const BannerAlert(
      kind: 'masked',
      // Said out loud, so a blank field is not read as "not recorded".
      text: 'Some details are hidden by your access level',
      severity: 3,
    ));
  }
  alerts.sort((a, b) => a.severity.compareTo(b.severity));

  final named = displayName(given, family);
  var name = named;
  if (name.isEmpty && unidentifiedLabel.trim().isNotEmpty) {
    // An unidentified patient still has to be identifiable at the bedside. The
    // label is what staff say out loud and what prints on the wristband.
    name = unidentifiedLabel.trim();
  }
  if (name.isEmpty) name = 'Name not recorded';

  final active = allergies.where((a) => a.active).toList()
    ..sort((a, b) {
      final byCriticality =
          _criticalityRank(a.criticality) - _criticalityRank(b.criticality);
      return byCriticality != 0
          ? byCriticality
          : a.substance.toLowerCase().compareTo(b.substance.toLowerCase());
    });

  return PatientBanner(
    patientId: patientId,
    displayName: name,
    age: displayAge(birthDate, now),
    sex: _sexLabel(sex),
    allergies: active,
    alerts: alerts,
    readOnly: deceased || mergedInto.isNotEmpty,
    allergiesUnknown: !allergiesRecorded,
  );
}
