import { describe, expect, it } from 'vitest';
import { create } from '@bufbuild/protobuf';
import { timestampFromDate } from '@bufbuild/protobuf/wkt';
import {
	FindingKind,
	FormularyStatus,
	PrescriptionSchema,
	SafetyFindingSchema,
	Severity,
	TherapyStatus
} from '$gen/healthcare/medication/v1/medication_pb.js';
import {
	describePrescription,
	toFormularyDecision,
	toPresentedFinding,
	toQueueEntry,
	toTherapyStatus,
	toPresentedDose,
	toRoundPolicy,
	toWireOutcome
} from './mapping.js';
import {
	AdministrationOutcome as WireOutcome,
	AdministrationPolicySchema,
	DueDoseSchema
} from '$gen/healthcare/nursing/v1/nursing_pb.js';
import { settled } from './administer.js';
import { safetyGate } from './prescribe.js';

describe('a safety finding off the wire', () => {
	it('translates every severity and kind', () => {
		for (const [wire, want] of Object.entries({
			[Severity.CONTRAINDICATED]: 'contraindicated',
			[Severity.SEVERE]: 'severe',
			[Severity.MODERATE]: 'moderate',
			[Severity.MILD]: 'mild',
			[Severity.INFORMATIONAL]: 'informational'
		})) {
			const finding = create(SafetyFindingSchema, { severity: Number(wire) });
			expect(toPresentedFinding(finding).severity).toBe(want);
		}
		for (const [wire, want] of Object.entries({
			[FindingKind.ALLERGY]: 'allergy',
			[FindingKind.INTERACTION]: 'interaction',
			[FindingKind.DUPLICATE_THERAPY]: 'duplicate_therapy',
			[FindingKind.DOSE_SUPPORT]: 'dose_support'
		})) {
			const finding = create(SafetyFindingSchema, { kind: Number(wire) });
			expect(toPresentedFinding(finding).kind).toBe(want);
		}
	});

	it('treats an ungraded finding as needing a reason, not as safe', () => {
		// Folding an unrecognised severity into 'informational' would let a
		// newly added one through silently.
		const ungraded = create(SafetyFindingSchema, {
			ruleId: 'new-rule',
			severity: Severity.UNSPECIFIED,
			summary: 'a severity this client does not know'
		});
		const gate = safetyGate([toPresentedFinding(ungraded)], []);
		expect(gate.state).toBe('needs-reasons');
	});

	it('carries a reason already recorded against the finding', () => {
		const overridden = create(SafetyFindingSchema, {
			ruleId: 'rule-1',
			severity: Severity.SEVERE,
			override: { by: 'dr-1', reason: 'INR monitored daily' }
		});
		expect(toPresentedFinding(overridden).existingOverrideReason).toMatch(/INR/);
	});

	it('names the medicines involved', () => {
		const interaction = create(SafetyFindingSchema, {
			subjects: [{ display: 'Warfarin' }, { code: 'M01AE01', display: '' }]
		});
		expect(toPresentedFinding(interaction).subjects).toEqual(['Warfarin', 'M01AE01']);
	});
});

describe('a prescription off the wire', () => {
	it('translates every therapy status', () => {
		for (const [wire, want] of Object.entries({
			[TherapyStatus.DRAFT]: 'draft',
			[TherapyStatus.ACTIVE]: 'active',
			[TherapyStatus.HELD]: 'held',
			[TherapyStatus.DISCONTINUED]: 'discontinued',
			[TherapyStatus.COMPLETED]: 'completed'
		})) {
			const prescription = create(PrescriptionSchema, { therapyStatus: Number(wire) });
			expect(toTherapyStatus(prescription)).toBe(want);
		}
	});

	it('describes itself from the drug, dose and route when the server sent no description', () => {
		const prescription = create(PrescriptionSchema, {
			ingredient: { display: 'Paracetamol' },
			route: 'oral',
			segments: [{ sequence: 1, dose: { value: 1, unit: 'g' } }]
		});
		expect(describePrescription(prescription)).toBe('Paracetamol 1 g oral');
	});

	it('falls back to a free-text dose in the description', () => {
		const prescription = create(PrescriptionSchema, {
			ingredient: { display: 'Salbutamol' },
			route: 'inhaled',
			segments: [{ sequence: 1, freeTextDose: 'two puffs as needed' }]
		});
		expect(describePrescription(prescription)).toMatch(/two puffs/);
	});

	it('treats a verification with no author as unverified', () => {
		// An empty `by` on a present message would be a server bug, and
		// unverified is the safer reading of one.
		const empty = create(PrescriptionSchema, { verification: { by: '' } });
		expect(toQueueEntry(empty).verified).toBe(false);

		const verified = create(PrescriptionSchema, {
			verification: { by: 'pharm-1', at: timestampFromDate(new Date()) }
		});
		expect(toQueueEntry(verified).verified).toBe(true);
	});

	it('takes the worst finding for the queue row', () => {
		const prescription = create(PrescriptionSchema, {
			findings: [
				{ ruleId: 'a', severity: Severity.MILD },
				{ ruleId: 'b', severity: Severity.SEVERE }
			]
		});
		expect(toQueueEntry(prescription).worstSeverity).toBe('severe');
	});

	it('reports the formulary decision and its approval path', () => {
		const prescription = create(PrescriptionSchema, {
			formulary: {
				status: FormularyStatus.NON_FORMULARY,
				approvalPath: 'microbiology approval required'
			}
		});
		const decision = toFormularyDecision(prescription);
		expect(decision.status).toBe('non_formulary');
		expect(decision.approvalPath).toMatch(/microbiology/);
	});

	it('reports no formulary check rather than inventing one', () => {
		const prescription = create(PrescriptionSchema, {});
		expect(toFormularyDecision(prescription).status).toBe('unspecified');
	});
});

describe('adapting the round', () => {
	const scheduled = new Date('2026-09-16T09:00:00Z');

	function due(overrides: Record<string, unknown> = {}) {
		return create(DueDoseSchema, {
			order: {
				orderId: 'o1',
				medication: { code: 'AMX', display: 'Amoxicillin' },
				dose: { value: 500, unit: 'mg' },
				route: 'oral',
				prn: false,
				verified: true
			},
			scheduledAt: timestampFromDate(scheduled),
			outstanding: true,
			overdue: false,
			...overrides
		});
	}

	it('formats the dose from the order rather than restating it', () => {
		expect(toPresentedDose(due(), scheduled).doseLabel).toBe('500 mg');
	});

	it('takes overdue from the server, not the browser clock', () => {
		// A workstation with a wrong clock would otherwise silently reorder the
		// round.
		const late = new Date('2026-09-16T12:00:00Z');
		const presented = toPresentedDose(due({ overdue: false }), late);
		expect(presented.overdue).toBe(false);
		expect(presented.minutesLate).toBe(180);
	});

	it('reports a dose with no administration as unrecorded', () => {
		expect(toPresentedDose(due(), scheduled).recordedOutcome).toBeNull();
	});

	it('carries a recorded outcome across without flattening it', () => {
		const held = toPresentedDose(
			due({ given: { outcome: WireOutcome.HELD }, outstanding: false }),
			scheduled
		);
		expect(held.recordedOutcome).toBe('held');
		expect(settled(held)).toBe(true);
	});

	it('shows an outcome it cannot read as unrecorded rather than as given', () => {
		// "Given" would be the dangerous guess: the next nurse would skip it.
		const unknown = toPresentedDose(
			due({ given: { outcome: 99 as WireOutcome } }),
			scheduled
		);
		expect(unknown.recordedOutcome).toBe('unspecified');
	});

	it('falls back to the strict policy when the server sent none', () => {
		// Requiring a scan the deployment did not ask for is an inconvenience;
		// skipping one it did ask for is a patient given the wrong drug.
		const policy = toRoundPolicy(undefined);
		expect(policy.barcodeRequired).toBe(true);
		expect(policy.overrideAllowed).toBe(false);
	});

	it('takes the policy the server sent, including a permissive one', () => {
		const policy = toRoundPolicy(
			create(AdministrationPolicySchema, {
				barcodeRequired: false,
				overrideAllowed: true,
				lateAfterSeconds: 1800n
			})
		);
		expect(policy).toEqual({
			barcodeRequired: false,
			overrideAllowed: true,
			lateAfterMinutes: 30
		});
	});

	it('every outcome the composer can choose has a wire value', () => {
		const chosen = [
			'administered', 'not_administered', 'held', 'refused', 'delayed', 'unspecified'
		] as const;
		const values = chosen.map(toWireOutcome);
		// Distinct, so nothing is quietly recorded as something else.
		expect(new Set(values).size).toBe(chosen.length);
	});
});
