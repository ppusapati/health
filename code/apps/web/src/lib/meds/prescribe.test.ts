import { describe, expect, it } from 'vitest';
import {
	describeFormulary,
	describeSeverity,
	mayPrescribe,
	orderFindings,
	orderQueue,
	presentFinding,
	safetyGate,
	structuredDoseRequiredFor,
	validatePrescription,
	worstSeverity,
	type PresentedFinding,
	type PrescriptionDraft,
	type QueueEntry,
	type Severity
} from './prescribe.js';

function finding(overrides: Partial<Parameters<typeof presentFinding>[0]> = {}): PresentedFinding {
	return presentFinding({
		ruleId: 'rule-1',
		ruleVersion: 'v3',
		kind: 'interaction',
		severity: 'severe',
		summary: 'Increases bleeding risk with warfarin',
		subjects: ['Warfarin', 'Ibuprofen'],
		existingOverrideReason: '',
		...overrides
	});
}

function draft(overrides: Partial<PrescriptionDraft> = {}): PrescriptionDraft {
	return {
		patientId: 'pat-1',
		encounterId: 'enc-1',
		ingredientCode: 'N02BE01',
		ingredientDisplay: 'Paracetamol',
		drugClass: 'analgesic',
		route: 'oral',
		dose: { amount: '1', unit: 'g', freeText: '', frequencySeconds: 21600 },
		indication: 'fever',
		startsAt: '',
		...overrides
	};
}

describe('a contraindication', () => {
	it('is never presented as overridable', () => {
		// The one severity where the answer is no rather than why.
		expect(finding({ severity: 'contraindicated' }).overridable).toBe(false);
		for (const severity of ['severe', 'moderate', 'mild', 'informational'] as Severity[]) {
			expect(finding({ severity }).overridable).toBe(true);
		}
	});

	it('blocks the prescription whatever reasons are given', () => {
		const gate = safetyGate(
			[finding({ ruleId: 'contra', severity: 'contraindicated' })],
			[{ ruleId: 'contra', reason: 'I have considered this carefully' }]
		);
		expect(gate.state).toBe('contraindicated');
		expect(mayPrescribe(validatePrescription(draft(), { structuredDoseRequired: false }), gate)).toBe(
			false
		);
	});

	it('sorts first, above everything else', () => {
		const rows = orderFindings([
			finding({ ruleId: 'mild', severity: 'mild' }),
			finding({ ruleId: 'contra', severity: 'contraindicated' }),
			finding({ ruleId: 'severe', severity: 'severe' })
		]);
		expect(rows.map((r) => r.ruleId)).toEqual(['contra', 'severe', 'mild']);
	});
});

describe('the safety gate', () => {
	it('is clear when there are no findings', () => {
		expect(safetyGate([], []).state).toBe('clear');
	});

	it('needs a reason per rule, not one blanket answer', () => {
		// A single "I have considered these" box is one sentence covering an
		// allergy and a dose warning at once, which is what makes an override
		// record unreadable at verification.
		const findings = [
			finding({ ruleId: 'rule-1', kind: 'allergy' }),
			finding({ ruleId: 'rule-2', kind: 'interaction' })
		];

		const partial = safetyGate(findings, [{ ruleId: 'rule-1', reason: 'mild rash only' }]);
		expect(partial.state).toBe('needs-reasons');
		expect(partial.state === 'needs-reasons' && partial.outstanding.map((f) => f.ruleId)).toEqual([
			'rule-2'
		]);

		const complete = safetyGate(findings, [
			{ ruleId: 'rule-1', reason: 'mild rash only' },
			{ ruleId: 'rule-2', reason: 'INR monitored daily' }
		]);
		expect(complete.state).toBe('overridden');
	});

	it('ignores an empty reason', () => {
		const gate = safetyGate([finding()], [{ ruleId: 'rule-1', reason: '   ' }]);
		expect(gate.state).toBe('needs-reasons');
	});

	it('does not gate on informational findings', () => {
		// Requiring a typed reason for every piece of advice is what trains
		// prescribers to type "ok" into the box that also guards the severe
		// ones.
		const gate = safetyGate([finding({ severity: 'informational' })], []);
		expect(gate.state).toBe('clear');
	});

	it('accepts a reason already recorded on the finding', () => {
		const gate = safetyGate(
			[finding({ existingOverrideReason: 'discussed with pharmacy' })],
			[]
		);
		expect(gate.state).toBe('clear');
	});

	it('does not let a stale reason cover a different rule', () => {
		const gate = safetyGate([finding({ ruleId: 'rule-9' })], [{ ruleId: 'rule-1', reason: 'ok' }]);
		expect(gate.state).toBe('needs-reasons');
	});
});

describe('validating a prescription', () => {
	it('accepts a complete one', () => {
		expect(validatePrescription(draft(), { structuredDoseRequired: false }).ready).toBe(true);
	});

	it('refuses a free-text dose where the class requires a structured one', () => {
		// SRS-MED-010. "As directed" for an anticoagulant is not a dose; it is
		// a note somebody has to interpret at 3am.
		const freeText = draft({
			dose: { amount: '', unit: '', freeText: 'as directed', frequencySeconds: 0 }
		});
		const refused = validatePrescription(freeText, { structuredDoseRequired: true });
		expect(refused.ready).toBe(false);
		expect(refused.problems.dose).toMatch(/free text/i);

		// And accepts it where the class does not.
		expect(validatePrescription(freeText, { structuredDoseRequired: false }).ready).toBe(true);
	});

	it('refuses a dose that is not a positive number', () => {
		for (const amount of ['abc', '0', '-5']) {
			const bad = draft({ dose: { amount, unit: 'mg', freeText: '', frequencySeconds: 0 } });
			expect(validatePrescription(bad, { structuredDoseRequired: true }).ready).toBe(false);
		}
	});

	it('requires a route', () => {
		// Oral and intravenous paracetamol are different doses, and a drug with
		// no route is one the nurse has to guess at.
		expect(validatePrescription(draft({ route: '' }), { structuredDoseRequired: false }).ready).toBe(
			false
		);
	});

	it('requires an indication', () => {
		// SRS-MED-001, and what makes a later review able to tell whether the
		// therapy is still needed.
		expect(
			validatePrescription(draft({ indication: '' }), { structuredDoseRequired: false }).ready
		).toBe(false);
	});

	it('refuses a prescription with no dose at all', () => {
		const none = draft({ dose: { amount: '', unit: '', freeText: '', frequencySeconds: 0 } });
		expect(validatePrescription(none, { structuredDoseRequired: false }).ready).toBe(false);
	});
});

describe('the formulary notice', () => {
	it('never blocks, and says what it takes', () => {
		// A hard block here produces a phone call and a handwritten chart,
		// which is worse in every way (SRS-MED-012).
		const notice = describeFormulary({
			status: 'non_formulary',
			restriction: '',
			approvalPath: 'microbiology approval required'
		});
		expect(notice.prominent).toBe(true);
		expect(notice.action).toMatch(/microbiology/i);

		const gate = safetyGate([], []);
		expect(mayPrescribe(validatePrescription(draft(), { structuredDoseRequired: false }), gate)).toBe(
			true
		);
	});

	it('distinguishes unknown from on-formulary', () => {
		// "Nobody has classified this" is not "it is fine".
		expect(describeFormulary({ status: 'unknown', restriction: '', approvalPath: '' }).label).toMatch(
			/unknown/i
		);
		expect(
			describeFormulary({ status: 'formulary', restriction: '', approvalPath: '' }).prominent
		).toBe(false);
	});
});

function entry(overrides: Partial<QueueEntry> = {}): QueueEntry {
	return {
		prescriptionId: 'rx-1',
		patientId: 'pat-1',
		description: 'Paracetamol 1 g oral six-hourly',
		prescriberId: 'dr-1',
		createdAt: new Date('2026-09-15T09:00:00Z'),
		therapyStatus: 'active',
		worstSeverity: 'unspecified',
		findings: [],
		overridden: false,
		verified: false,
		...overrides
	};
}

describe('the verification queue', () => {
	it('puts the most serious finding first', () => {
		// A pharmacist working top-down should meet the severe interaction
		// before the twentieth routine paracetamol.
		const rows = orderQueue([
			entry({ prescriptionId: 'routine', worstSeverity: 'unspecified' }),
			entry({ prescriptionId: 'severe', worstSeverity: 'severe' }),
			entry({ prescriptionId: 'mild', worstSeverity: 'mild' })
		]);
		expect(rows.map((r) => r.prescriptionId)).toEqual(['severe', 'mild', 'routine']);
	});

	it('takes the oldest first among equals, so the bottom does not starve', () => {
		const rows = orderQueue([
			entry({ prescriptionId: 'newer', createdAt: new Date('2026-09-15T11:00:00Z') }),
			entry({ prescriptionId: 'older', createdAt: new Date('2026-09-15T07:00:00Z') })
		]);
		expect(rows.map((r) => r.prescriptionId)).toEqual(['older', 'newer']);
	});

	it('reports the worst severity among a set of findings', () => {
		expect(worstSeverity([])).toBe('unspecified');
		expect(
			worstSeverity([finding({ severity: 'mild' }), finding({ severity: 'contraindicated' })])
		).toBe('contraindicated');
		expect(worstSeverity([finding({ severity: 'moderate' })])).toBe('moderate');
	});
});

describe('severity labels', () => {
	it('names every severity', () => {
		for (const severity of [
			'contraindicated',
			'severe',
			'moderate',
			'mild',
			'informational',
			'unspecified'
		] as Severity[]) {
			expect(describeSeverity(severity)).not.toBe('');
		}
	});
});

describe('which classes need a structured dose', () => {
	const classes = ['anticoagulant', 'Insulin', 'chemotherapy'];

	it('matches a configured class, ignoring case and padding', () => {
		expect(structuredDoseRequiredFor(classes, 'anticoagulant')).toBe(true);
		expect(structuredDoseRequiredFor(classes, '  INSULIN ')).toBe(true);
		expect(structuredDoseRequiredFor(classes, 'analgesic')).toBe(false);
	});

	it('says no for a drug whose class the composer does not know', () => {
		// The honest answer rather than the safe-looking one: refusing free
		// text for everything unclassified would block legitimate "two puffs as
		// needed" prescribing on the many drugs a hospital never classifies,
		// and the server is the authority either way.
		expect(structuredDoseRequiredFor(classes, '')).toBe(false);
		expect(structuredDoseRequiredFor([], 'anticoagulant')).toBe(false);
	});
});
