/// The bedside patient banner.
///
/// The allergy line is the one line on a ward tablet that must not be read
/// past, so most of these tests are about not training anybody to read past it.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/patient/banner.dart';

final _now = DateTime.utc(2026, 9, 15);

BannerAllergy allergy({
  String substance = 'Penicillin',
  String reaction = 'Anaphylaxis',
  AllergyCriticality criticality = AllergyCriticality.high,
  AllergyStatus status = AllergyStatus.active,
}) =>
    BannerAllergy(
      substance: substance,
      reaction: reaction,
      criticality: criticality,
      status: status,
    );

PatientBanner banner({
  String given = 'Asha',
  String family = 'Rao',
  // A default parameter cannot be a DateTime, so "no birth date recorded" is
  // asked for with a flag rather than by passing null.
  bool birthDateRecorded = true,
  DateTime? birthDate,
  Sex sex = Sex.female,
  List<BannerAllergy> allergies = const [],
  bool allergiesRecorded = true,
  bool deceased = false,
  String mergedInto = '',
  bool identityConfirmed = true,
  bool masked = false,
  String unidentifiedLabel = '',
}) =>
    bannerFor(
      patientId: 'patient-1',
      given: given,
      family: family,
      birthDate: birthDateRecorded ? (birthDate ?? DateTime.utc(1990, 6, 1)) : null,
      sex: sex,
      now: _now,
      allergies: allergies,
      allergiesRecorded: allergiesRecorded,
      deceased: deceased,
      mergedInto: mergedInto,
      identityConfirmed: identityConfirmed,
      masked: masked,
      unidentifiedLabel: unidentifiedLabel,
    );

void main() {
  group('allergies', () {
    test('an unasked question is not the same as no allergies', () {
      // An empty list reads as "no allergies". Nobody having asked must not.
      expect(banner(allergiesRecorded: false).allergiesUnknown, isTrue);
      expect(banner(allergiesRecorded: true).allergiesUnknown, isFalse);
      expect(banner(allergiesRecorded: false).allergies, isEmpty);
    });

    test('the most critical allergy comes first', () {
      final result = banner(allergies: [
        allergy(substance: 'Latex', criticality: AllergyCriticality.low),
        allergy(substance: 'Codeine', criticality: AllergyCriticality.unableToAssess),
        allergy(substance: 'Penicillin', criticality: AllergyCriticality.high),
      ]);

      expect(result.allergies.map((a) => a.substance),
          ['Penicillin', 'Codeine', 'Latex']);
    });

    test('equal criticality sorts by substance, so the list does not shuffle', () {
      final result = banner(allergies: [
        allergy(substance: 'Sulfonamides', criticality: AllergyCriticality.high),
        allergy(substance: 'Aspirin', criticality: AllergyCriticality.high),
      ]);
      expect(result.allergies.first.substance, 'Aspirin');
    });

    test('a resolved allergy is not shown', () {
      // Listing one trains staff to read past the allergy line.
      final result = banner(allergies: [
        allergy(substance: 'Peanut', status: AllergyStatus.resolved),
        allergy(substance: 'Penicillin'),
      ]);
      expect(result.allergies.map((a) => a.substance), ['Penicillin']);
    });

    test('an allergy entered in error is not shown', () {
      final result = banner(allergies: [
        allergy(status: AllergyStatus.enteredInError),
      ]);
      expect(result.allergies, isEmpty);
    });

    test('the chip names the reaction, because reactions differ', () {
      // "penicillin — anaphylaxis" and "penicillin — rash" are different
      // decisions for whoever is holding the syringe.
      expect(allergy().label, 'Penicillin — Anaphylaxis');
      expect(allergy(reaction: '  ').label, 'Penicillin');
    });

    test('a high-criticality allergy is flagged for the medication round', () {
      expect(banner(allergies: [allergy()]).hasHighCriticalityAllergy, isTrue);
      expect(
        banner(allergies: [allergy(criticality: AllergyCriticality.low)])
            .hasHighCriticalityAllergy,
        isFalse,
      );
    });
  });

  group('identity', () {
    test('a name with no family name is not padded', () {
      expect(displayName('Asha', ''), 'Asha');
      expect(displayName('', 'Rao'), 'Rao');
      expect(displayName('Asha', 'Rao'), 'Asha Rao');
    });

    test('an unidentified patient falls back to what is on the wristband', () {
      final result = banner(
        given: '',
        family: '',
        unidentifiedLabel: 'Trauma Alpha',
        identityConfirmed: false,
      );
      expect(result.displayName, 'Trauma Alpha');
      expect(result.alerts.map((a) => a.kind), contains('unidentified'));
    });

    test('a record with no name at all says so rather than showing a blank', () {
      expect(banner(given: '', family: '').displayName, 'Name not recorded');
    });

    test('age is years once a patient is two', () {
      expect(banner(birthDate: DateTime.utc(1990, 6, 1)).age, '36y');
    });

    test('age before a birthday has not rolled over', () {
      expect(banner(birthDate: DateTime.utc(1990, 12, 1)).age, '35y');
    });

    test('an infant is shown in months, because the dose changes', () {
      expect(banner(birthDate: DateTime.utc(2026, 3, 15)).age, '6m');
      expect(banner(birthDate: DateTime.utc(2025, 9, 20)).age, '11m');
    });

    test('a missing birth date says so', () {
      expect(banner(birthDateRecorded: false).age, 'Age not recorded');
    });

    test('every sex has a label, and unspecified is not blank', () {
      for (final sex in Sex.values) {
        expect(banner(sex: sex).sex, isNotEmpty, reason: sex.name);
      }
      expect(banner(sex: Sex.unspecified).sex, 'Not recorded');
    });
  });

  group('alerts on the record', () {
    test('deceased sorts above everything', () {
      final result = banner(deceased: true, masked: true, identityConfirmed: false);
      expect(result.alerts.first.kind, 'deceased');
    });

    test('a merged record names the survivor', () {
      // Not a vague "this record was merged": the reader has to be able to get
      // to the record that is current.
      final result = banner(mergedInto: 'patient-99');
      expect(result.alerts.single.text, 'Merged into patient-99');
    });

    test('masking is said out loud', () {
      // So a blank field is not read as "not recorded".
      final result = banner(masked: true);
      expect(result.alerts.single.text, contains('hidden by your access level'));
    });

    test('a clean record has no alerts', () {
      expect(banner().alerts, isEmpty);
    });
  });

  group('read-only', () {
    test('a deceased patient takes no new activity', () {
      expect(banner(deceased: true).readOnly, isTrue);
    });

    test('a merged-away record takes no new activity', () {
      expect(banner(mergedInto: 'patient-99').readOnly, isTrue);
    });

    test('a masked record is still writable', () {
      // Masking hides fields from this reader. It does not close the record.
      expect(banner(masked: true).readOnly, isFalse);
    });

    test('an ordinary record is writable', () {
      expect(banner().readOnly, isFalse);
    });
  });
}
