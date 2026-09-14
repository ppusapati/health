import { describe, expect, it } from 'vitest';
import { bannerFor, displayAge, displayName, type PatientLike } from './banner.js';

const now = new Date('2026-09-14T10:00:00Z');

function patient(overrides: Partial<PatientLike> = {}): PatientLike {
	return {
		patientId: 'pat-1',
		status: 'active',
		name: { family: 'Iyer', given: ['Meera'] },
		birthDate: { date: new Date('1992-03-01T00:00:00Z'), precision: 'day' },
		sex: 'female',
		identifiers: [{ label: 'MRN', value: 'MRN-000123', primary: true }],
		deceased: null,
		mergedIntoPatientId: '',
		designation: null,
		masked: false,
		...overrides
	};
}

describe('age', () => {
	it('is never a bare number for an imprecise date', () => {
		// A year-only or estimated birth date is approximately known, and
		// rendering it as an exact age is a claim of precision this system does
		// not have — the one a dose calculation would act on.
		expect(displayAge({ date: new Date('1986-01-01T00:00:00Z'), precision: 'year' }, now)).toBe(
			'about 40y'
		);
		expect(
			displayAge({ date: new Date('1986-01-01T00:00:00Z'), precision: 'estimated' }, now)
		).toBe('about 40y');
		expect(displayAge({ date: new Date('1986-01-01T00:00:00Z'), precision: 'day' }, now)).toBe(
			'40y'
		);
	});

	it('is days for a neonate and months for an infant', () => {
		// "0y" for a two-week-old is how a per-kilogram, per-day-of-life dose
		// goes wrong.
		expect(displayAge({ date: new Date('2026-09-01T00:00:00Z'), precision: 'day' }, now)).toBe(
			'13d'
		);
		expect(displayAge({ date: new Date('2026-02-14T00:00:00Z'), precision: 'day' }, now)).toBe(
			'7m'
		);
		expect(displayAge({ date: new Date('2024-09-14T00:00:00Z'), precision: 'day' }, now)).toBe(
			'2y'
		);
	});

	it('says so rather than inventing one', () => {
		expect(displayAge(null, now)).toBe('age unknown');
		expect(
			displayAge({ date: new Date('2030-01-01T00:00:00Z'), precision: 'day' }, now)
		).toBe('age unknown');
	});
});

describe('name', () => {
	it('does not assume a family name exists', () => {
		// Some cultures record none. A "given family" template leaves a trailing
		// space and a name that reads as truncated.
		expect(displayName({ family: '', given: ['Anitha'] })).toBe('Anitha');
		expect(displayName({ family: 'Iyer', given: [] })).toBe('Iyer');
		expect(displayName({ family: 'Iyer', given: ['Meera', 'Lakshmi'] })).toBe(
			'Meera Lakshmi Iyer'
		);
	});
});

describe('alerts', () => {
	it('puts the one that matters most first', () => {
		// A banner that shows three alerts in arrival order buries the one a
		// clinician has to read.
		const b = bannerFor(
			patient({
				status: 'merged',
				mergedIntoPatientId: 'pat-2',
				deceased: { date: null },
				masked: true
			}),
			now
		);
		expect(b.alerts.map((a) => a.kind)).toEqual(['deceased', 'merged', 'masked']);
	});

	it('names the surviving record rather than just saying a merge happened', () => {
		const b = bannerFor(patient({ status: 'merged', mergedIntoPatientId: 'pat-2' }), now);
		expect(b.alerts[0].text).toContain('pat-2');
	});

	it('says a hidden field is hidden', () => {
		// A blank reads as "not recorded", which is a different clinical fact
		// from "you may not see this" (SRS-EMPI-014).
		const b = bannerFor(patient({ masked: true }), now);
		expect(b.alerts.some((a) => a.kind === 'masked')).toBe(true);
	});
});

describe('read-only records', () => {
	it('marks a deceased or merged-away patient', () => {
		// Computed once here so every workspace disables its actions the same
		// way, instead of each discovering the rule when the server refuses.
		expect(bannerFor(patient({ deceased: { date: null } }), now).readOnly).toBe(true);
		expect(
			bannerFor(patient({ status: 'merged', mergedIntoPatientId: 'pat-2' }), now).readOnly
		).toBe(true);
		expect(bannerFor(patient(), now).readOnly).toBe(false);
	});

	it('does not mark an unconfirmed identity read-only', () => {
		// A candidate is a real patient receiving real care. What is missing is
		// a confirmed identity, not permission to treat them.
		const b = bannerFor(patient({ status: 'candidate' }), now);
		expect(b.readOnly).toBe(false);
		expect(b.alerts.some((a) => a.kind === 'unidentified')).toBe(true);
	});
});

describe('an unidentified patient', () => {
	it('is identifiable at the bedside from its designation', () => {
		const b = bannerFor(
			patient({
				status: 'candidate',
				name: null,
				birthDate: null,
				sex: 'unspecified',
				designation: { label: 'TRAUMA ALPHA', apparentSex: 'male', apparentAge: 40 }
			}),
			now
		);
		expect(b.displayName).toBe('TRAUMA ALPHA');
		expect(b.age).toBe('about 40y');
		// Marked apparent, because it is an observation at the bedside rather
		// than a claim about who this person is.
		expect(b.sex).toBe('Male (apparent)');
	});

	it('never renders an empty name', () => {
		const b = bannerFor(patient({ name: null, designation: null }), now);
		expect(b.displayName).toBe('Name not recorded');
	});
});

describe('identifiers', () => {
	it('puts the one a receptionist reads back first', () => {
		const b = bannerFor(
			patient({
				identifiers: [
					{ label: 'ABHA', value: '11-2222-3333-4444', primary: false },
					{ label: 'MRN', value: 'MRN-000123', primary: true }
				]
			}),
			now
		);
		expect(b.identifiers[0].label).toBe('MRN');
	});
});
