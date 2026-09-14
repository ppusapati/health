/**
 * The patient banner (SRS-CLN-001, UX-W1-01 … 06).
 *
 * Every workspace in Wave 1 shows the same banner, and it is the control that
 * makes "wrong patient" a thing a clinician can notice. So the rules about
 * what it shows live here, once, tested, rather than in six components that
 * drift apart.
 *
 * Three of those rules are worth stating because the obvious implementation
 * gets each of them wrong.
 *
 * An unknown age is not zero. A patient whose birth date is recorded as a year
 * only, or estimated from appearance, has an age that is approximately known —
 * and rendering "0" or a precise age for them is a dosing error waiting to
 * happen. The precision travels with the date for exactly this reason, and
 * this module refuses to discard it.
 *
 * An alert is never silently dropped. Deceased, merged-away, and
 * not-yet-identified are all states where acting on the record as though it
 * were an ordinary active patient is the failure. They are computed here and
 * ordered by how badly they need to be seen.
 *
 * Masked is a state, not an absence. When field-level access hides a
 * demographic (SRS-EMPI-014), the banner says it is hidden. A blank reads as
 * "not recorded", which is a different clinical fact.
 */

/** How much of a birth date is known. Mirrors empi.v1.DatePrecision. */
export type DatePrecision = 'day' | 'month' | 'year' | 'estimated' | 'unknown';

/** Mirrors empi.v1.Sex. */
export type Sex = 'female' | 'male' | 'other' | 'unknown' | 'unspecified';

/** Mirrors empi.v1.PatientStatus. */
export type PatientStatus = 'candidate' | 'active' | 'merged' | 'inactive' | 'unspecified';

/** One identifier as the banner shows it. */
export interface BannerIdentifier {
	/** Short label: "MRN", "ABHA". */
	readonly label: string;
	readonly value: string;
	/** True for the one a receptionist reads back to the patient. */
	readonly primary: boolean;
}

/** Something about this patient that changes how the record may be used. */
export interface BannerAlert {
	readonly kind: 'deceased' | 'merged' | 'unidentified' | 'inactive' | 'masked';
	readonly text: string;
	/**
	 * Ordering, ascending — 0 is the one that must be read first. A banner with
	 * three alerts and no ordering shows them in whatever order the data
	 * happened to arrive, and the one that matters ends up last.
	 */
	readonly severity: number;
}

/** What the banner component renders. */
export interface PatientBanner {
	readonly patientId: string;
	/** Full display name, or the temporary designation for an unidentified patient. */
	readonly displayName: string;
	/** "34y", "about 40y", "7m", or "age unknown". Never a bare number. */
	readonly age: string;
	readonly sex: string;
	readonly identifiers: readonly BannerIdentifier[];
	readonly alerts: readonly BannerAlert[];
	/**
	 * True when this record must not be used for new clinical or financial
	 * activity — it lost a merge, or the patient has died. The workspace
	 * disables its action panel rather than letting a click discover it.
	 */
	readonly readOnly: boolean;
}

/** The subset of empi.v1.Patient the banner reads. */
export interface PatientLike {
	readonly patientId: string;
	readonly status: PatientStatus;
	readonly name: { readonly family: string; readonly given: readonly string[] } | null;
	readonly birthDate: { readonly date: Date; readonly precision: DatePrecision } | null;
	readonly sex: Sex;
	readonly identifiers: readonly BannerIdentifier[];
	readonly deceased: { readonly date: Date | null } | null;
	readonly mergedIntoPatientId: string;
	readonly designation: {
		readonly label: string;
		readonly apparentSex: Sex;
		readonly apparentAge: number;
	} | null;
	/** True when field-level access hid one or more demographics. */
	readonly masked: boolean;
}

const sexLabel: Record<Sex, string> = {
	female: 'Female',
	male: 'Male',
	other: 'Other',
	// "Unknown" and "not stated" are different facts and the banner keeps them
	// apart: one says somebody asked, the other says nobody did.
	unknown: 'Unknown',
	unspecified: 'Not stated'
};

/**
 * Renders an age from a partial date.
 *
 * Never a bare number, because the number alone is a claim of precision this
 * system usually does not have. "about 40y" and "40y" mean different things to
 * anybody calculating a dose.
 */
export function displayAge(
	birth: { readonly date: Date; readonly precision: DatePrecision } | null,
	now: Date
): string {
	if (!birth || birth.precision === 'unknown') {
		return 'age unknown';
	}

	const months = wholeMonthsBetween(birth.date, now);
	if (months < 0) {
		// A birth date in the future is bad data, not a negative age. Saying so
		// is more useful than rendering "-3y", which reads as a rendering bug
		// and gets ignored.
		return 'age unknown';
	}

	const approximate = birth.precision === 'estimated' || birth.precision === 'year';
	const prefix = approximate ? 'about ' : '';

	if (months < 1) {
		const days = Math.floor((now.getTime() - birth.date.getTime()) / 86_400_000);
		// Days matter for a neonate: a dose is per kilogram and per day of life,
		// and "0y" for a two-week-old is how that goes wrong.
		return `${prefix}${days}d`;
	}
	if (months < 24) {
		return `${prefix}${months}m`;
	}
	return `${prefix}${Math.floor(months / 12)}y`;
}

function wholeMonthsBetween(from: Date, to: Date): number {
	let months =
		(to.getUTCFullYear() - from.getUTCFullYear()) * 12 + (to.getUTCMonth() - from.getUTCMonth());
	if (to.getUTCDate() < from.getUTCDate()) {
		months -= 1;
	}
	return months;
}

/** Joins a structured name for display. */
export function displayName(
	name: { readonly family: string; readonly given: readonly string[] } | null
): string {
	if (!name) {
		return '';
	}
	const given = name.given.filter((part) => part.trim() !== '').join(' ');
	const family = name.family.trim();
	// Some cultures record no family name at all, so a template that assumes
	// "given family" produces a trailing space and a name that looks truncated.
	return [given, family].filter((part) => part !== '').join(' ');
}

/** Builds the banner for a patient. */
export function bannerFor(patient: PatientLike, now: Date): PatientBanner {
	const alerts: BannerAlert[] = [];

	if (patient.deceased) {
		alerts.push({
			kind: 'deceased',
			text: 'Deceased',
			severity: 0
		});
	}
	if (patient.status === 'merged' && patient.mergedIntoPatientId !== '') {
		alerts.push({
			kind: 'merged',
			// The survivor's id, not a vague "this record was merged": the whole
			// point is that the reader can get to the record that is current.
			text: `Merged into ${patient.mergedIntoPatientId}`,
			severity: 1
		});
	}
	if (patient.status === 'candidate') {
		alerts.push({
			kind: 'unidentified',
			text: 'Identity not confirmed',
			severity: 2
		});
	}
	if (patient.status === 'inactive') {
		alerts.push({ kind: 'inactive', text: 'Inactive record', severity: 3 });
	}
	if (patient.masked) {
		alerts.push({
			kind: 'masked',
			// Said out loud so a blank field is not read as "not recorded".
			text: 'Some details are hidden by your access level',
			severity: 4
		});
	}

	const designation = patient.designation;
	const named = displayName(patient.name);

	let name = named;
	let age = displayAge(patient.birthDate, now);
	let sex = sexLabel[patient.sex];

	if (named === '' && designation) {
		// An unidentified patient still has to be identifiable at the bedside.
		// The label is what staff say out loud and what prints on the band.
		name = designation.label;
		if (patient.birthDate === null && designation.apparentAge > 0) {
			age = `about ${designation.apparentAge}y`;
		}
		if (patient.sex === 'unspecified' || patient.sex === 'unknown') {
			sex = `${sexLabel[designation.apparentSex]} (apparent)`;
		}
	}
	if (name === '') {
		name = 'Name not recorded';
	}

	return {
		patientId: patient.patientId,
		displayName: name,
		age,
		sex,
		identifiers: [...patient.identifiers].sort(
			(a, b) => Number(b.primary) - Number(a.primary) || a.label.localeCompare(b.label)
		),
		alerts: alerts.sort((a, b) => a.severity - b.severity),
		// Deceased and merged-away records take no new activity. Computed here
		// so every workspace disables its actions the same way, rather than each
		// discovering the rule when the server refuses.
		readOnly: patient.deceased !== null || patient.status === 'merged'
	};
}
