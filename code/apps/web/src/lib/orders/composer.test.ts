import { describe, expect, it } from 'vitest';
import {
	acknowledgementProblem,
	describeOrderPriority,
	duplicateGate,
	mayPlace,
	orderInbox,
	validateOrder,
	type DuplicateCandidate,
	type InboxItem,
	type OrderDraft,
	type OrderPolicy
} from './composer.js';

function draft(overrides: Partial<OrderDraft> = {}): OrderDraft {
	return {
		type: 'laboratory',
		patientId: 'pat-1',
		encounterId: 'enc-1',
		code: 'K',
		display: 'Serum potassium',
		detail: '',
		indication: '',
		priority: 'routine',
		startAt: '',
		frequencySeconds: 0,
		conditionalInstruction: '',
		...overrides
	};
}

function policy(overrides: Partial<OrderPolicy> = {}): OrderPolicy {
	return {
		type: 'laboratory',
		indicationRequired: false,
		structuredTimingRequired: false,
		requiredPrivilege: '',
		...overrides
	};
}

describe('validating an order', () => {
	it('accepts a complete one when policy asks for nothing extra', () => {
		expect(validateOrder(draft(), policy()).ready).toBe(true);
	});

	it('blocks submit when the type requires an indication', () => {
		// SRS-ORD-007. Blocking rather than advisory: the performing service
		// uses the indication to decide protocol and urgency, and it cannot be
		// reconstructed afterwards.
		const refused = validateOrder(draft(), policy({ indicationRequired: true }));
		expect(refused.ready).toBe(false);
		expect(refused.problems.indication).toMatch(/indication/i);

		const given = validateOrder(
			draft({ indication: 'hyperkalaemia on insulin infusion' }),
			policy({ indicationRequired: true })
		);
		expect(given.ready).toBe(true);
	});

	it('requires a frequency rather than free text where timing is structured', () => {
		// SRS-ORD-008: downstream receives normalised timing. "TDS" in a
		// free-text box is not something a scheduler can act on.
		const refused = validateOrder(
			draft({ startAt: '2026-09-15T08:00' }),
			policy({ structuredTimingRequired: true })
		);
		expect(refused.ready).toBe(false);
		expect(refused.problems.frequency).toMatch(/free text/i);

		const structured = validateOrder(
			draft({ startAt: '2026-09-15T08:00', frequencySeconds: 28800 }),
			policy({ structuredTimingRequired: true })
		);
		expect(structured.ready).toBe(true);
	});

	it('refuses an order with no patient, encounter, type or code', () => {
		expect(validateOrder(draft({ patientId: '' }), policy()).ready).toBe(false);
		expect(validateOrder(draft({ encounterId: '' }), policy()).ready).toBe(false);
		expect(validateOrder(draft({ type: 'unspecified' }), policy()).ready).toBe(false);
		expect(validateOrder(draft({ code: '', display: '' }), policy()).ready).toBe(false);
	});

	it('keys problems by field so each sits beside its input', () => {
		const bad = validateOrder(draft({ code: '', display: '', patientId: '' }), policy());
		expect(Object.keys(bad.problems).sort()).toEqual(['code', 'patient']);
		expect(bad.order).toHaveLength(2);
	});

	it('applies no policy requirements when none is configured', () => {
		// A hospital that has configured nothing for a type gets the base
		// checks, not a guessed list of required fields.
		expect(validateOrder(draft(), null).ready).toBe(true);
	});
});

function candidate(orderId = 'ord-1'): DuplicateCandidate {
	return {
		orderId,
		number: 'LAB-0012',
		display: 'Serum potassium',
		status: 'requested',
		statusLabel: 'Requested',
		placedAt: new Date('2026-09-15T08:00:00Z'),
		requesterId: 'dr-2'
	};
}

describe('the duplicate gate', () => {
	it('is clear when nothing matches', () => {
		const gate = duplicateGate({
			candidates: [],
			overridable: true,
			windowSeconds: 14400,
			acknowledged: [],
			reason: ''
		});
		expect(gate.state).toBe('clear');
		expect(mayPlace(validateOrder(draft(), policy()), gate)).toBe(true);
	});

	it('warns and asks why rather than suppressing the order', () => {
		// Two potassium levels four hours apart may be exactly right on an
		// insulin infusion. Suppressing the second hides a necessary order.
		const gate = duplicateGate({
			candidates: [candidate()],
			overridable: true,
			windowSeconds: 14400,
			acknowledged: [],
			reason: ''
		});
		expect(gate.state).toBe('needs-override');
		expect(mayPlace(validateOrder(draft(), policy()), gate)).toBe(false);
		expect(gate.state === 'needs-override' && gate.windowHours).toBe(4);
	});

	it('refuses outright where policy does not allow an override', () => {
		const gate = duplicateGate({
			candidates: [candidate()],
			overridable: false,
			windowSeconds: 14400,
			acknowledged: ['ord-1'],
			reason: 'clinically necessary'
		});
		expect(gate.state).toBe('refused');
		expect(mayPlace(validateOrder(draft(), policy()), gate)).toBe(false);
	});

	it('needs both a reason and an acknowledgement of every candidate', () => {
		const candidates = [candidate('ord-1'), candidate('ord-2')];

		const reasonOnly = duplicateGate({
			candidates,
			overridable: true,
			windowSeconds: 14400,
			acknowledged: [],
			reason: 'repeat after insulin'
		});
		expect(reasonOnly.state).toBe('needs-override');

		const partial = duplicateGate({
			candidates,
			overridable: true,
			windowSeconds: 14400,
			acknowledged: ['ord-1'],
			reason: 'repeat after insulin'
		});
		expect(partial.state).toBe('needs-override');

		const complete = duplicateGate({
			candidates,
			overridable: true,
			windowSeconds: 14400,
			acknowledged: ['ord-1', 'ord-2'],
			reason: 'repeat after insulin'
		});
		expect(complete.state).toBe('overridden');
		expect(mayPlace(validateOrder(draft(), policy()), complete)).toBe(true);
	});

	it('does not let this morning’s acknowledgement cover this afternoon’s duplicate', () => {
		// The override names the orders it was given against, so a stale
		// acknowledgement cannot silently authorise a different one.
		const gate = duplicateGate({
			candidates: [candidate('ord-99')],
			overridable: true,
			windowSeconds: 14400,
			acknowledged: ['ord-1', 'ord-2'],
			reason: 'repeat after insulin'
		});
		expect(gate.state).toBe('needs-override');
	});

	it('never lets an invalid order through, however the duplicates stand', () => {
		const clear = duplicateGate({
			candidates: [],
			overridable: true,
			windowSeconds: 0,
			acknowledged: [],
			reason: ''
		});
		const invalid = validateOrder(draft(), policy({ indicationRequired: true }));
		expect(mayPlace(invalid, clear)).toBe(false);
	});
});

describe('priorities', () => {
	it('keeps timing-critical distinct from urgent', () => {
		// A dose that must be given at 08:00 is not more urgent than one needed
		// now; it is differently urgent, and a scheduler treats them
		// differently.
		expect(describeOrderPriority('timing_critical')).toMatch(/timing/i);
		expect(describeOrderPriority('urgent')).toBe('Urgent');
		expect(describeOrderPriority('stat')).toBe('STAT');
	});
});

function inboxItem(overrides: Partial<InboxItem> = {}): InboxItem {
	return {
		observationId: 'obs-1',
		patientId: 'pat-1',
		display: 'Serum potassium',
		value: '6.8 mmol/L',
		interpretationLabel: 'Critically high',
		effectiveAt: new Date('2026-09-15T08:00:00Z'),
		dueEscalations: 0,
		waitingMinutes: 30,
		...overrides
	};
}

describe('the results inbox', () => {
	it('puts escalated results above merely unread ones', () => {
		// A result that has escalated twice is one where the acknowledgement
		// process has failed. Sorted purely by age it sinks as the list grows.
		const rows = orderInbox([
			inboxItem({ observationId: 'fresh', effectiveAt: new Date('2026-09-15T09:30:00Z') }),
			inboxItem({ observationId: 'escalated', dueEscalations: 2 })
		]);
		expect(rows.map((r) => r.observationId)).toEqual(['escalated', 'fresh']);
	});

	it('orders equally escalated results oldest first', () => {
		const rows = orderInbox([
			inboxItem({ observationId: 'newer', effectiveAt: new Date('2026-09-15T09:00:00Z') }),
			inboxItem({ observationId: 'older', effectiveAt: new Date('2026-09-15T07:00:00Z') })
		]);
		expect(rows.map((r) => r.observationId)).toEqual(['older', 'newer']);
	});

	it('requires an action rather than only an acknowledgement', () => {
		// SRS-CLN-012 asks for the action taken. "Seen" closes the loop
		// administratively and leaves the next reader unable to tell whether
		// anything was done about a potassium of 6.8.
		expect(acknowledgementProblem('')).toMatch(/what was done/i);
		expect(acknowledgementProblem('   ')).not.toBe('');
		expect(acknowledgementProblem('discussed with registrar, insulin-dextrose started')).toBe('');
	});
});
