import { describe, expect, it } from 'vitest';
import {
	allergiesUnrecorded,
	buildTrend,
	describeInterpretation,
	orderAllergies,
	orderProblems,
	presentAllergy,
	presentObservation,
	presentProblem,
	type Criticality,
	type ProblemStatus,
	type Verification
} from './safety.js';

function allergy(overrides: Partial<Parameters<typeof presentAllergy>[0]> = {}) {
	return presentAllergy({
		allergyId: 'alg-1',
		substance: 'Penicillin',
		kind: 'allergy',
		criticality: 'high',
		verification: 'confirmed',
		reactions: ['Anaphylaxis'],
		note: '',
		...overrides
	});
}

describe('allergy criticality', () => {
	it('does not present "unable to assess" as low risk', () => {
		// It is a gap in what is known, not a reassurance. Rendering it beside
		// the low-risk entries tells a prescriber there is no danger when it
		// means nobody has looked.
		const unassessed = allergy({ criticality: 'unable_to_assess' });
		expect(unassessed.criticalityLabel).toMatch(/unknown|not assessed/i);
		expect(unassessed.prominent).toBe(true);

		expect(allergy({ criticality: 'low' }).prominent).toBe(false);
	});

	it('sorts an unassessed allergy with the high-risk ones', () => {
		const rows = orderAllergies([
			allergy({ allergyId: 'low', substance: 'Latex', criticality: 'low' }),
			allergy({ allergyId: 'unknown', substance: 'Aspirin', criticality: 'unable_to_assess' }),
			allergy({ allergyId: 'high', substance: 'Penicillin', criticality: 'high' })
		]);
		expect(rows.map((r) => r.allergyId)).toEqual(['high', 'unknown', 'low']);
	});
});

describe('allergy verification', () => {
	it('keeps a refuted allergy on the list, below the live ones', () => {
		// Deleting it loses the fact that the question was asked and settled,
		// and the next clinician re-records it from the patient's recollection.
		const rows = orderAllergies([
			allergy({ allergyId: 'refuted', criticality: 'high', verification: 'refuted' }),
			allergy({ allergyId: 'live', criticality: 'low', verification: 'confirmed' })
		]);
		expect(rows.map((r) => r.allergyId)).toEqual(['live', 'refuted']);
		expect(rows[1].historical).toBe(true);
		expect(rows[1].prominent).toBe(false);
	});

	it('does not word an unconfirmed allergy so it invites dismissal', () => {
		// Most allergy records are patient-reported and they still warn.
		const reported = allergy({ verification: 'unconfirmed' });
		expect(reported.verificationLabel).toMatch(/reported by the patient/i);
		expect(reported.historical).toBe(false);
	});

	it('labels every verification state', () => {
		for (const verification of [
			'unconfirmed',
			'confirmed',
			'refuted',
			'entered_in_error',
			'unspecified'
		] as Verification[]) {
			expect(allergy({ verification }).verificationLabel).not.toBe('');
		}
	});
});

describe('allergy and intolerance', () => {
	it('keeps them apart', () => {
		// Confusing them is how a patient with mild nausea on codeine ends up
		// unable to receive any opiate.
		expect(allergy({ kind: 'allergy' }).kindLabel).toBe('Allergy');
		expect(allergy({ kind: 'intolerance' }).kindLabel).toBe('Intolerance');
	});
});

describe('an empty allergy panel', () => {
	it('is reported as unrecorded rather than as no known allergies', () => {
		// "No known allergies" and "nobody has asked" are different clinical
		// facts, and an empty list is the second one.
		expect(allergiesUnrecorded([])).toBe(true);
		expect(allergiesUnrecorded([allergy()])).toBe(false);
	});
});

function problem(overrides: Partial<Parameters<typeof presentProblem>[0]> = {}) {
	return presentProblem({
		problemId: 'prb-1',
		code: 'I21.9',
		display: 'Acute myocardial infarction',
		status: 'active',
		onsetAt: new Date('2024-01-01T00:00:00Z'),
		resolvedAt: null,
		note: '',
		...overrides
	});
}

describe('the problem list', () => {
	it('does not treat remission as resolved', () => {
		// A cancer in remission is not a cancer that has gone.
		const remission = problem({ status: 'remission' });
		expect(remission.statusLabel).toMatch(/remission/i);
		expect(remission.active).toBe(true);
	});

	it('keeps resolved problems on the list rather than hiding them', () => {
		// A problem list that forgot a resolved myocardial infarction would
		// hide the most important fact about the patient.
		const rows = orderProblems([
			problem({ problemId: 'resolved', status: 'resolved' }),
			problem({ problemId: 'active', status: 'active' })
		]);
		expect(rows.map((r) => r.problemId)).toEqual(['active', 'resolved']);
		expect(rows).toHaveLength(2);
	});

	it('falls back to the code when there is no display name', () => {
		// A bare code on a screen is a screen clinicians stop reading, but it
		// is still better than a blank row.
		expect(problem({ display: '' }).display).toBe('I21.9');
	});

	it('labels every status', () => {
		for (const status of [
			'active',
			'remission',
			'resolved',
			'inactive',
			'entered_in_error',
			'unspecified'
		] as ProblemStatus[]) {
			expect(problem({ status }).statusLabel).not.toBe('');
		}
	});
});

function observation(overrides: Partial<Parameters<typeof presentObservation>[0]> = {}) {
	return presentObservation({
		observationId: 'obs-1',
		display: 'Serum potassium',
		value: 6.8,
		unit: 'mmol/L',
		textValue: '',
		interpretation: 'critical_high',
		interpretationSource: 'Central laboratory',
		referenceLow: 3.5,
		referenceHigh: 5.1,
		hasReferenceRange: true,
		referenceText: '',
		effectiveAt: new Date('2026-09-15T08:00:00Z'),
		status: 'final',
		...overrides
	});
}

describe('observations', () => {
	it('shows who interpreted the result', () => {
		// SRS-CLN-011 is explicit that the flag comes from the authoritative
		// service and the UI must not infer it — and a flag with no
		// attribution is indistinguishable from an inferred one.
		expect(observation().interpretationSource).toBe('Central laboratory');
	});

	it('distinguishes "not interpreted" from "normal"', () => {
		// "Nobody said" is not "it is fine".
		expect(describeInterpretation('unknown')).toMatch(/not interpreted/i);
		expect(describeInterpretation('normal')).toBe('Normal');
	});

	it('marks a critical result', () => {
		expect(observation({ interpretation: 'critical_high' }).critical).toBe(true);
		expect(observation({ interpretation: 'critical_low' }).critical).toBe(true);
		expect(observation({ interpretation: 'high' }).critical).toBe(false);
	});

	it('keeps the unit with the value', () => {
		expect(observation().value).toBe('6.8 mmol/L');
		expect(observation().referenceRange).toBe('3.5–5.1 mmol/L');
	});

	it('falls back to a text value when there is no quantity', () => {
		const cultured = observation({
			value: null,
			unit: '',
			textValue: 'No growth after 48 hours',
			hasReferenceRange: false
		});
		expect(cultured.value).toBe('No growth after 48 hours');
	});
});

describe('trends', () => {
	it('plots a series in time order', () => {
		const later = observation({
			observationId: 'obs-2',
			effectiveAt: new Date('2026-09-15T12:00:00Z')
		});
		const trend = buildTrend(
			[later, observation()],
			[
				{ observationId: 'obs-1', value: 6.8 },
				{ observationId: 'obs-2', value: 5.2 }
			]
		);
		expect(trend.points.map((p) => p.value)).toEqual([6.8, 5.2]);
		expect(trend.unit).toBe('mmol/L');
	});

	it('refuses to plot across units rather than converting', () => {
		// Conversion needs the analyte's molar mass, which this layer does not
		// have and must not guess — and a silently converted series looks
		// exactly like a correctly measured one.
		const other = observation({ observationId: 'obs-2', unit: 'mg/dL' });
		const trend = buildTrend(
			[observation(), other],
			[
				{ observationId: 'obs-1', value: 6.8 },
				{ observationId: 'obs-2', value: 26.6 }
			]
		);
		expect(trend.mixedUnits).toBe(true);
		expect(trend.points).toEqual([]);
	});

	it('leaves non-numeric results out of the series', () => {
		const cultured = observation({ observationId: 'obs-2', value: null, textValue: 'No growth' });
		const trend = buildTrend(
			[observation(), cultured],
			[
				{ observationId: 'obs-1', value: 6.8 },
				{ observationId: 'obs-2', value: null }
			]
		);
		expect(trend.points).toHaveLength(1);
	});
});
