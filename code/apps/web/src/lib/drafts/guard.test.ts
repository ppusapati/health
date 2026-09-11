import { describe, expect, it } from 'vitest';
import {
	DraftRegistry,
	describe as describeDecision,
	evaluate,
	REASON_CLEAN,
	REASON_CONFIRM,
	REASON_WRONG_CHART,
	type Draft
} from './guard.js';

const note = (overrides: Partial<Draft> = {}): Draft => ({
	id: 'draft-1',
	description: 'progress note',
	policy: 'confirm',
	patientRef: 'patient/p1',
	dirty: true,
	...overrides
});

describe('unsaved draft guard (SRS-WEB-012)', () => {
	it('lets the user leave when nothing is unsaved', () => {
		const decision = evaluate([note({ dirty: false })], { kind: 'route', to: '/facilities' });
		expect(decision.allow).toBe(true);
		expect(decision.reason).toBe(REASON_CLEAN);
	});

	it('offers stay or discard when a clinical draft is open', () => {
		const decision = evaluate([note()], { kind: 'route', to: '/facilities' });
		expect(decision.allow).toBe(false);
		expect(decision.prompt).toBe(true);
		expect(decision.blocked).toBe(false);
		expect(decision.reason).toBe(REASON_CONFIRM);
	});

	it('never interrupts for re-derivable work', () => {
		// A half-typed search box prompting on every navigation is how users
		// learn to click through the dialog without reading it.
		const filter = note({ id: 'filter', description: 'search box', policy: 'discard-silently' });
		expect(evaluate([filter], { kind: 'route', to: '/x' }).allow).toBe(true);
	});

	it('names the drafts, because "unsaved changes" is not actionable', () => {
		const decision = evaluate([note(), note({ id: 'd2', description: 'discharge summary' })], {
			kind: 'route',
			to: '/x'
		});
		const message = describeDecision(decision);
		expect(message).toContain('progress note');
		expect(message).toContain('discharge summary');
	});
});

describe('patient switch (the dangerous case)', () => {
	it('blocks a switch outright when the draft belongs to another chart', () => {
		// Navigating away loses work; switching patient risks the work being
		// filed against the wrong chart, which is worse.
		const order = note({
			description: 'medication order',
			policy: 'block-patient-switch',
			patientRef: 'patient/p1'
		});

		const decision = evaluate([order], { kind: 'patient-switch', toPatientRef: 'patient/p2' });
		expect(decision.blocked).toBe(true);
		expect(decision.prompt).toBe(false);
		expect(decision.reason).toBe(REASON_WRONG_CHART);
		expect(describeDecision(decision)).toContain('wrong chart');
	});

	it('allows a switch back to the draft’s own patient', () => {
		const order = note({ policy: 'block-patient-switch', patientRef: 'patient/p1' });
		const decision = evaluate([order], { kind: 'patient-switch', toPatientRef: 'patient/p1' });
		// Same chart: no risk of misfiling, so this is an ordinary confirm at
		// most rather than a block.
		expect(decision.blocked).toBe(false);
	});

	it('prompts rather than blocks for an ordinary draft', () => {
		const decision = evaluate([note()], { kind: 'patient-switch', toPatientRef: 'patient/p2' });
		expect(decision.blocked).toBe(false);
		expect(decision.prompt).toBe(true);
	});

	it('blocks when any one of several drafts is unsafe to carry across', () => {
		const drafts = [
			note({ id: 'd1', description: 'progress note' }),
			note({
				id: 'd2',
				description: 'medication order',
				policy: 'block-patient-switch',
				patientRef: 'patient/p1'
			})
		];
		const decision = evaluate(drafts, { kind: 'patient-switch', toPatientRef: 'patient/p2' });
		expect(decision.blocked).toBe(true);
		// Only the blocking draft is named, so the message says what to do.
		expect(decision.drafts).toHaveLength(1);
		expect(decision.drafts[0].description).toBe('medication order');
	});
});

describe('draft registry', () => {
	it('stops prompting once a draft is saved', () => {
		const registry = new DraftRegistry();
		registry.register(note());
		expect(registry.evaluate({ kind: 'route', to: '/x' }).allow).toBe(false);

		registry.setDirty('draft-1', false);
		expect(registry.evaluate({ kind: 'route', to: '/x' }).allow).toBe(true);
	});

	it('stops prompting once a draft is released', () => {
		// Per-component handlers are removed inconsistently, and the ones that
		// leak keep prompting after their component is gone. A registry makes
		// release explicit.
		const registry = new DraftRegistry();
		registry.register(note());
		registry.release('draft-1');
		expect(registry.evaluate({ kind: 'route', to: '/x' }).allow).toBe(true);
		expect(registry.open()).toHaveLength(0);
	});

	it('notifies subscribers as drafts change', () => {
		const registry = new DraftRegistry();
		const seen: number[] = [];
		const unsubscribe = registry.subscribe((drafts) => seen.push(drafts.length));

		registry.register(note());
		registry.register(note({ id: 'd2' }));
		registry.release('d2');
		unsubscribe();
		registry.register(note({ id: 'd3' }));

		expect(seen).toEqual([0, 1, 2, 1]);
	});

	it('ignores dirty-marking an unknown draft rather than resurrecting it', () => {
		const registry = new DraftRegistry();
		registry.setDirty('never-registered', true);
		expect(registry.open()).toHaveLength(0);
	});
});
