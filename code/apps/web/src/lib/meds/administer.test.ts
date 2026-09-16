import { describe, it, expect } from 'vitest';
import {
	describeOutcome,
	describeRefusal,
	evaluateAdministration,
	formatDose,
	needsReason,
	orderDoses,
	scanComplete,
	settled,
	strictPolicy,
	wasGiven,
	type AdministrationOutcome,
	type PresentedDose,
	type RoundPolicy
} from './administer.js';

function dose(overrides: Partial<PresentedDose> = {}): PresentedDose {
	return {
		orderId: 'o1',
		medication: 'Amoxicillin',
		doseLabel: '500 mg',
		route: 'oral',
		scheduledAt: new Date('2026-09-16T09:00:00Z'),
		outstanding: true,
		overdue: false,
		minutesLate: 0,
		prn: false,
		verifiedByPharmacy: true,
		recordedOutcome: null,
		...overrides
	};
}

const scanned = { patient: 'PT-1', medication: 'MED-1' };
const unscanned = { patient: '', medication: '' };

function evaluate(input: {
	dose?: PresentedDose;
	policy?: RoundPolicy;
	outcome?: AdministrationOutcome | null;
	scan?: { patient: string; medication: string };
	overrideReason?: string;
	reason?: string;
}) {
	return evaluateAdministration({
		dose: input.dose ?? dose(),
		policy: input.policy ?? strictPolicy,
		outcome: input.outcome === undefined ? 'administered' : input.outcome,
		scan: input.scan ?? scanned,
		overrideReason: input.overrideReason ?? '',
		reason: input.reason ?? ''
	});
}

describe('the outcomes', () => {
	it('keeps held, refused and not given distinct', () => {
		// Flattening them loses the only record of which happened: held is a
		// clinical decision, refused is the patient's.
		const labels = (['held', 'refused', 'not_administered'] as const).map(describeOutcome);
		expect(new Set(labels).size).toBe(3);
	});

	it('says only one of them means the drug reached the patient', () => {
		expect(wasGiven('administered')).toBe(true);
		for (const outcome of ['not_administered', 'held', 'refused', 'delayed'] as const) {
			expect(wasGiven(outcome), outcome).toBe(false);
		}
	});

	it('asks why for every deviation from the prescription', () => {
		for (const outcome of ['not_administered', 'held', 'refused', 'delayed'] as const) {
			expect(needsReason(outcome), outcome).toBe(true);
		}
		expect(needsReason('administered')).toBe(false);
	});
});

describe('the scan gate', () => {
	it('refuses an unscanned dose where the policy requires a scan', () => {
		const decision = evaluate({ scan: unscanned });
		expect(decision.allowed).toBe(false);
		expect(decision.refusals).toContain('patient_not_scanned');
		expect(decision.refusals).toContain('medication_not_scanned');
	});

	it('names everything wrong at once', () => {
		// A nurse told one problem at a time is a nurse making three round
		// trips to the trolley.
		const decision = evaluate({ scan: { patient: 'PT-1', medication: '' } });
		expect(decision.refusals).toEqual(
			expect.arrayContaining(['medication_not_scanned', 'override_not_permitted'])
		);
	});

	it('does not ask for a scan before an outcome has been chosen', () => {
		// The gate is about giving the drug. Asking for a wristband on a tile
		// nobody has decided about yet is a warning the nurse learns to ignore.
		const decision = evaluate({ scan: unscanned, outcome: null });
		expect(decision.refusals).toEqual(['outcome_missing']);
	});

	it('does not offer a way past a scan the ward made absolute', () => {
		const decision = evaluate({ scan: unscanned, overrideReason: 'scanner broken' });
		expect(decision.allowed).toBe(false);
		expect(decision.refusals).toContain('override_not_permitted');
		expect(decision.overriding).toBe(false);
	});

	it('lets a reason stand in where the ward permits it', () => {
		const decision = evaluate({
			policy: { ...strictPolicy, overrideAllowed: true },
			scan: unscanned,
			overrideReason: 'scanner broken, second nurse checked'
		});
		expect(decision.allowed).toBe(true);
		// Named out loud: an override is a thing the nurse is choosing, not a
		// consequence they discover afterwards.
		expect(decision.overriding).toBe(true);
		expect(decision.refusals).toEqual([]);
	});

	it('still refuses when the override is permitted but unexplained', () => {
		const decision = evaluate({
			policy: { ...strictPolicy, overrideAllowed: true },
			scan: unscanned,
			overrideReason: '   '
		});
		expect(decision.allowed).toBe(false);
		expect(decision.refusals).toContain('override_reason_missing');
		expect(decision.overriding).toBe(false);
	});

	it('does not gate recording that the patient refused it', () => {
		// Demanding a wristband scan before a nurse can write down that the
		// patient declined would teach them to record it as something else.
		const decision = evaluate({
			scan: unscanned,
			outcome: 'refused',
			reason: 'patient declined'
		});
		expect(decision.allowed).toBe(true);
	});

	it('applies no gate at all where the ward does not scan', () => {
		const decision = evaluate({
			policy: { ...strictPolicy, barcodeRequired: false },
			scan: unscanned
		});
		expect(decision.allowed).toBe(true);
	});

	it('defaults to the strict policy', () => {
		// Requiring a scan the deployment did not ask for is an inconvenience;
		// skipping one it did ask for is a patient given the wrong drug.
		expect(strictPolicy.barcodeRequired).toBe(true);
		expect(strictPolicy.overrideAllowed).toBe(false);
	});
});

describe('the outcome gate', () => {
	it('refuses a dose with no outcome chosen', () => {
		expect(evaluate({ outcome: null }).refusals).toContain('outcome_missing');
		expect(evaluate({ outcome: 'unspecified' }).refusals).toContain('outcome_missing');
	});

	it('refuses a deviation with no reason', () => {
		expect(evaluate({ outcome: 'held', reason: '  ' }).refusals).toContain('reason_missing');
		expect(evaluate({ outcome: 'held', reason: 'awaiting review' }).allowed).toBe(true);
	});

	it('refuses a dose that has already been recorded', () => {
		const decision = evaluate({ dose: dose({ recordedOutcome: 'administered' }) });
		expect(decision.refusals).toContain('already_settled');
		expect(settled(dose({ recordedOutcome: 'administered' }))).toBe(true);
		expect(settled(dose())).toBe(false);
	});

	it('every refusal says what to do about it', () => {
		const refusals = [
			'patient_not_scanned', 'medication_not_scanned', 'override_reason_missing',
			'override_not_permitted', 'reason_missing', 'outcome_missing', 'already_settled'
		] as const;
		for (const refusal of refusals) {
			expect(describeRefusal(refusal), refusal).not.toBe('');
		}
	});
});

describe('the round', () => {
	it('puts outstanding doses first and settled ones in their place below', () => {
		const ordered = orderDoses([
			dose({ orderId: 'settled-early', outstanding: false,
				scheduledAt: new Date('2026-09-16T07:00:00Z'), recordedOutcome: 'administered' }),
			dose({ orderId: 'due-late', scheduledAt: new Date('2026-09-16T11:00:00Z') }),
			dose({ orderId: 'due-early', scheduledAt: new Date('2026-09-16T08:00:00Z') })
		]);
		expect(ordered.map((d) => d.orderId)).toEqual(['due-early', 'due-late', 'settled-early']);
	});

	it('does not mutate what it was given', () => {
		const doses = [dose({ orderId: 'b' }), dose({ orderId: 'a', outstanding: false })];
		orderDoses(doses);
		expect(doses.map((d) => d.orderId)).toEqual(['b', 'a']);
	});
});

describe('formatting a dose', () => {
	it('drops a trailing zero without rounding anything', () => {
		// "5.0 mg" looks like a precision that was not measured.
		expect(formatDose(5, 'mg')).toBe('5 mg');
		expect(formatDose(2.5, 'mg')).toBe('2.5 mg');
		expect(formatDose(0.125, 'mg')).toBe('0.125 mg');
	});

	it('never rounds', () => {
		expect(formatDose(0.3333333333333333, 'mg')).toBe('0.3333333333333333 mg');
	});

	it('omits an absent unit rather than leaving a space', () => {
		expect(formatDose(5, '')).toBe('5');
	});
});

describe('a complete scanned administration', () => {
	it('is allowed with nothing recorded against it', () => {
		const decision = evaluate({});
		expect(decision.allowed).toBe(true);
		expect(decision.overriding).toBe(false);
		expect(scanComplete(scanned)).toBe(true);
	});
});
