import { describe, expect, it } from 'vitest';
import {
	REASON_NO_CRITERIA,
	REASON_TOO_BROAD,
	mayRegister,
	presentMatch,
	registrationGate,
	validateSearch,
	type MatchOutcome,
	type PresentedMatch
} from './search.js';

function criteria(overrides: Partial<Parameters<typeof validateSearch>[0]> = {}) {
	return { name: '', phone: '', identifierValue: '', birthDate: '', ...overrides };
}

function match(outcome: MatchOutcome, patientId = 'pat-1'): PresentedMatch {
	return presentMatch({
		patientId,
		displayName: 'Meera Iyer',
		confidence: 0.92,
		outcome,
		masked: false,
		matchedFormerName: ''
	});
}

describe('validating a search', () => {
	it('refuses an empty one', () => {
		const v = validateSearch(criteria());
		expect(v.runnable).toBe(false);
		expect(v.reason).toBe(REASON_NO_CRITERIA);
	});

	it('refuses a single letter of a name', () => {
		// It would return the first page of an enormous result set, which reads
		// to the user as "not on this page" and leads straight to a duplicate —
		// the precise failure search-before-create exists to prevent.
		const v = validateSearch(criteria({ name: 'I' }));
		expect(v.runnable).toBe(false);
		expect(v.reason).toBe(REASON_TOO_BROAD);
	});

	it('accepts a single letter once something narrows it', () => {
		expect(validateSearch(criteria({ name: 'I', birthDate: '1992-03-01' })).runnable).toBe(true);
		expect(validateSearch(criteria({ name: 'I', phone: '9876543210' })).runnable).toBe(true);
	});

	it('accepts an identifier on its own', () => {
		// An MRN or a national health number is exact; it needs nothing else.
		expect(validateSearch(criteria({ identifierValue: 'MRN-000123' })).runnable).toBe(true);
	});

	it('says what to do rather than only that it refused', () => {
		expect(validateSearch(criteria()).message).toMatch(/name|phone|identifier/i);
		expect(validateSearch(criteria({ name: 'I' })).message).toMatch(/two letters/i);
	});
});

describe('presenting a candidate', () => {
	it('labels the strength in words rather than as a bare percentage', () => {
		// A percentage invites a receptionist to develop a private threshold.
		// The threshold that matters is the configured one the server applied.
		expect(match('probable').outcomeLabel).toMatch(/certainly/i);
		expect(match('review').outcomeLabel).toMatch(/possibly/i);
		expect(match('conflict').outcomeLabel).toMatch(/review/i);
		expect(match('distinct').outcomeLabel).toMatch(/different person/i);
	});

	it('clamps a confidence into a percentage', () => {
		expect(presentMatch({ ...raw(), confidence: 1.4 }).confidencePercent).toBe(100);
		expect(presentMatch({ ...raw(), confidence: -0.2 }).confidencePercent).toBe(0);
		expect(presentMatch({ ...raw(), confidence: 0.815 }).confidencePercent).toBe(82);
	});

	it('carries a former name through', () => {
		// A match on a maiden name scores low against the current name, so
		// without this the row reads as irrelevant and is dismissed — which is
		// the outcome the name history exists to prevent (SRS-EMPI-007).
		const m = presentMatch({ ...raw(), matchedFormerName: 'Meera Raman' });
		expect(m.matchedFormerName).toBe('Meera Raman');
	});

	function raw() {
		return {
			patientId: 'pat-1',
			displayName: 'Meera Iyer',
			confidence: 0.9,
			outcome: 'review' as MatchOutcome,
			masked: false,
			matchedFormerName: ''
		};
	}
});

describe('the search-before-create gate', () => {
	it('does not offer registration before anything has been searched', () => {
		// "Nothing searched" and "nothing found" both produce an empty list and
		// mean opposite things. Conflating them is how the gate stops working.
		const gate = registrationGate({ searched: false, matches: [], acknowledged: [] });
		expect(gate.state).toBe('search-first');
		expect(mayRegister(gate)).toBe(false);
	});

	it('offers registration once a search found nothing', () => {
		const gate = registrationGate({ searched: true, matches: [], acknowledged: [] });
		expect(gate.state).toBe('clear');
		expect(mayRegister(gate)).toBe(true);
	});

	it('blocks registration while a probable duplicate is unreviewed', () => {
		const gate = registrationGate({
			searched: true,
			matches: [match('probable', 'pat-1')],
			acknowledged: []
		});
		expect(gate.state).toBe('review-candidates');
		expect(mayRegister(gate)).toBe(false);
		expect(gate.state === 'review-candidates' && gate.outstanding).toEqual(['pat-1']);
	});

	it('treats review and conflict as blocking, and distinct as not', () => {
		for (const outcome of ['probable', 'review', 'conflict'] as MatchOutcome[]) {
			const gate = registrationGate({
				searched: true,
				matches: [match(outcome)],
				acknowledged: []
			});
			expect(mayRegister(gate)).toBe(false);
		}
		const distinct = registrationGate({
			searched: true,
			matches: [match('distinct')],
			acknowledged: []
		});
		expect(mayRegister(distinct)).toBe(true);
	});

	it('needs every blocking candidate acknowledged, not just one', () => {
		const matches = [match('probable', 'pat-1'), match('review', 'pat-2')];
		const partial = registrationGate({ searched: true, matches, acknowledged: ['pat-1'] });
		expect(mayRegister(partial)).toBe(false);
		expect(partial.state === 'review-candidates' && partial.outstanding).toEqual(['pat-2']);

		const all = registrationGate({ searched: true, matches, acknowledged: ['pat-1', 'pat-2'] });
		expect(all.state).toBe('acknowledged');
		expect(mayRegister(all)).toBe(true);
	});

	it('counts the outstanding candidates in what it says', () => {
		const one = registrationGate({
			searched: true,
			matches: [match('probable', 'pat-1')],
			acknowledged: []
		});
		expect(one.message).toMatch(/one existing record/i);

		const two = registrationGate({
			searched: true,
			matches: [match('probable', 'pat-1'), match('review', 'pat-2')],
			acknowledged: []
		});
		expect(two.message).toMatch(/2 existing records/i);
	});

	it('ignores an acknowledgement for somebody who is not a candidate', () => {
		// A stale acknowledgement from a previous search must not unlock the
		// gate for a different set of candidates.
		const gate = registrationGate({
			searched: true,
			matches: [match('probable', 'pat-9')],
			acknowledged: ['pat-1', 'pat-2']
		});
		expect(mayRegister(gate)).toBe(false);
	});
});
