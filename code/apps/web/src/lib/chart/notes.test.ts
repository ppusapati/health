import { describe, expect, it } from 'vitest';
import {
	actionsFor,
	describeCorrection,
	finalises,
	isFinalised,
	readyToSign,
	type ChartDocument,
	type DocumentStatus,
	type SignatureMeaning
} from './notes.js';

const at = new Date('2026-09-15T09:00:00Z');

function document(overrides: Partial<ChartDocument> = {}): ChartDocument {
	return {
		documentId: 'doc-1',
		title: 'Progress note',
		kind: 'progress_note',
		status: 'draft',
		authoredBy: 'dr-1',
		createdAt: at,
		updatedAt: at,
		amendsId: '',
		addsToId: '',
		changeReason: '',
		retractionReason: '',
		dictated: false,
		signatures: [],
		intact: true,
		confidentiality: 'normal',
		...overrides
	};
}

const author = { subjectId: 'dr-1', mayWrite: true };

describe('what a document allows', () => {
	it('lets a draft be edited and signed', () => {
		const actions = actionsFor(document(), author);
		expect(actions.edit).toBe(true);
		expect(actions.sign).toBe(true);
		expect(actions.amend).toBe(false);
	});

	it('never lets signed content be edited in place', () => {
		// The whole rule. A signed note that can be edited is a record whose
		// documents prove nothing, and a clinician offered an Edit button would
		// reasonably assume the change is invisible.
		for (const status of ['signed', 'amended', 'addendum'] as DocumentStatus[]) {
			const actions = actionsFor(document({ status }), author);
			expect(actions.edit).toBe(false);
			expect(actions.sign).toBe(false);
			expect(actions.amend).toBe(true);
			expect(actions.addendum).toBe(true);
		}
	});

	it('offers nothing on a document marked entered in error', () => {
		const actions = actionsFor(document({ status: 'entered_in_error' }), author);
		expect(actions.edit || actions.sign || actions.amend || actions.addendum).toBe(false);
		expect(actions.blockedReason).toMatch(/kept for the record/i);
	});

	it('offers nothing to a read-only viewer', () => {
		const actions = actionsFor(document(), { subjectId: 'obs-1', mayWrite: false });
		expect(actions.edit).toBe(false);
		expect(actions.blockedReason).toMatch(/read-only/i);
	});

	it('refuses everything when the content no longer matches its signature', () => {
		// Amending it would produce a new document derived from content nobody
		// vouched for, which is worse than refusing.
		const actions = actionsFor(document({ status: 'signed', intact: false }), author);
		expect(actions.amend).toBe(false);
		expect(actions.addendum).toBe(false);
		expect(actions.retract).toBe(false);
		expect(actions.blockedReason).toMatch(/no longer matches/i);
	});

	it('still allows a draft to be retracted rather than deleted', () => {
		// A draft the care team could see for an hour was still visible.
		expect(actionsFor(document(), author).retract).toBe(true);
	});
});

describe('signatures', () => {
	it('does not treat a transcriber as having finalised anything', () => {
		// SRS-CLN-016: a transcriber typed what somebody else dictated and is
		// not asserting the clinical content. Counting it is how a dictated
		// note reaches the record with nobody clinically accountable.
		expect(finalises('transcriber')).toBe(false);
		expect(finalises('witness')).toBe(false);
		for (const meaning of ['author', 'verifier', 'cosigner'] as SignatureMeaning[]) {
			expect(finalises(meaning)).toBe(true);
		}
	});

	it('reports a note as unfinalised when only a transcriber has signed', () => {
		const transcribed = document({
			dictated: true,
			signatures: [{ subjectId: 'sec-1', meaning: 'transcriber', signedAt: at }]
		});
		expect(isFinalised(transcribed)).toBe(false);

		const signed = document({
			signatures: [
				{ subjectId: 'sec-1', meaning: 'transcriber', signedAt: at },
				{ subjectId: 'dr-1', meaning: 'author', signedAt: at }
			]
		});
		expect(isFinalised(signed)).toBe(true);
	});
});

describe('choosing between an amendment and an addendum', () => {
	it('explains them as the question the clinician is answering', () => {
		// "Amend" and "Addendum" are the record's words, not the choice. The
		// choice is whether what was written was wrong or whether something has
		// since arrived, and recording one as the other misrepresents whether
		// the original was ever true.
		const amendment = describeCorrection('amendment');
		expect(amendment.detail).toMatch(/was wrong/i);
		expect(amendment.reasonRequired).toBe(true);

		const addendum = describeCorrection('addendum');
		expect(addendum.detail).toMatch(/more to say|arrived|came back/i);
		expect(addendum.reasonRequired).toBe(false);
	});
});

describe('readiness to sign', () => {
	const complete = {
		title: 'Progress note',
		sections: [{ heading: 'Assessment', text: 'Reviewed on the ward round.' }],
		templateVersion: 'v3',
		patientId: 'pat-1',
		encounterId: 'enc-1'
	};

	it('accepts a complete draft', () => {
		expect(readyToSign(complete).ready).toBe(true);
	});

	it('refuses a note with no content', () => {
		// An empty signed note is worse than no note: it reads as an assessment
		// that found nothing worth recording.
		const empty = readyToSign({
			...complete,
			sections: [{ heading: 'Assessment', text: '   ' }]
		});
		expect(empty.ready).toBe(false);
		expect(empty.problems.join(' ')).toMatch(/no content/i);
	});

	it('refuses a note not pinned to a template version', () => {
		// SRS-CLN-002: without it the note cannot be re-rendered as it was
		// written once the template changes.
		const untemplated = readyToSign({ ...complete, templateVersion: '' });
		expect(untemplated.ready).toBe(false);
		expect(untemplated.problems.join(' ')).toMatch(/template version/i);
	});

	it('refuses a note not attached to a patient or an encounter', () => {
		expect(readyToSign({ ...complete, patientId: '' }).ready).toBe(false);
		expect(readyToSign({ ...complete, encounterId: '' }).ready).toBe(false);
	});

	it('lists every problem rather than only the first', () => {
		// Fixing one and being told about the next is how a clinician gives up
		// on a form.
		const bad = readyToSign({
			title: '',
			sections: [],
			templateVersion: '',
			patientId: '',
			encounterId: ''
		});
		expect(bad.problems.length).toBeGreaterThan(3);
	});
});
