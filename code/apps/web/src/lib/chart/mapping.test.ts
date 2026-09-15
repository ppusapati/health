import { describe, expect, it } from 'vitest';
import { create } from '@bufbuild/protobuf';
import { timestampFromDate } from '@bufbuild/protobuf/wkt';
import {
	AllergyCriticality,
	AllergySchema,
	AllergyVerification,
	DocumentSchema,
	DocumentStatus,
	Interpretation,
	ObservationSchema,
	ObservationStatus,
	ProblemSchema,
	ProblemStatus,
	SignatureMeaning
} from '$gen/healthcare/clinical/v1/clinical_pb.js';
import {
	toChartDocument,
	toPresentedAllergy,
	toPresentedObservation,
	toPresentedProblem,
	toTrendValues
} from './mapping.js';
import { actionsFor, isFinalised } from './notes.js';

const author = { subjectId: 'dr-1', mayWrite: true };

describe('a document off the wire', () => {
	it('translates every status rather than defaulting', () => {
		const expected: Record<number, string> = {
			[DocumentStatus.DRAFT]: 'draft',
			[DocumentStatus.SIGNED]: 'signed',
			[DocumentStatus.AMENDED]: 'amended',
			[DocumentStatus.ADDENDUM]: 'addendum',
			[DocumentStatus.ENTERED_IN_ERROR]: 'entered_in_error'
		};
		for (const [wire, want] of Object.entries(expected)) {
			const document = create(DocumentSchema, { status: Number(wire), intact: true });
			expect(toChartDocument(document).status).toBe(want);
		}
	});

	it('carries the intact flag through, and false means false', () => {
		// A document whose content no longer hashes to what was signed must not
		// arrive here as usable. This is the one field where the safe default
		// and the convenient default differ.
		const tampered = create(DocumentSchema, { status: DocumentStatus.SIGNED, intact: false });
		expect(actionsFor(toChartDocument(tampered), author).blockedReason).toMatch(
			/no longer matches/i
		);
	});

	it('keeps a transcriber signature distinguishable from an author one', () => {
		const transcribed = create(DocumentSchema, {
			status: DocumentStatus.DRAFT,
			intact: true,
			dictated: true,
			signatures: [
				{ subjectId: 'sec-1', meaning: SignatureMeaning.TRANSCRIBER, signedAt: timestampFromDate(new Date()) }
			]
		});
		expect(isFinalised(toChartDocument(transcribed))).toBe(false);
	});
});

describe('an allergy off the wire', () => {
	it('keeps "unable to assess" distinct from low and unspecified', () => {
		const unassessed = create(AllergySchema, {
			substance: { code: 'N02BE01', display: 'Paracetamol' },
			criticality: AllergyCriticality.UNABLE_TO_ASSESS,
			verification: AllergyVerification.UNCONFIRMED
		});
		const presented = toPresentedAllergy(unassessed);
		expect(presented.criticality).toBe('unable_to_assess');
		expect(presented.prominent).toBe(true);
	});

	it('names the substance rather than rendering a blank row', () => {
		const coded = create(AllergySchema, { substance: { code: 'J01CA04', display: '' } });
		expect(toPresentedAllergy(coded).substance).toBe('J01CA04');

		const unnamed = create(AllergySchema, {});
		expect(toPresentedAllergy(unnamed).substance).toBe('Unnamed substance');
	});
});

describe('a problem off the wire', () => {
	it('translates every status', () => {
		for (const [wire, want] of Object.entries({
			[ProblemStatus.ACTIVE]: 'active',
			[ProblemStatus.REMISSION]: 'remission',
			[ProblemStatus.RESOLVED]: 'resolved',
			[ProblemStatus.INACTIVE]: 'inactive',
			[ProblemStatus.ENTERED_IN_ERROR]: 'entered_in_error'
		})) {
			const problem = create(ProblemSchema, { status: Number(wire) });
			expect(toPresentedProblem(problem).status).toBe(want);
		}
	});
});

describe('an observation off the wire', () => {
	it('treats a measured zero as a value, not as absent', () => {
		// A potassium of 0 is not plausible, but a fluid balance of 0 is, and a
		// truthiness check on the quantity turns it into "no result".
		const zero = create(ObservationSchema, {
			code: { display: 'Net fluid balance' },
			value: { value: 0, unit: 'mL' },
			status: ObservationStatus.FINAL
		});
		expect(toPresentedObservation(zero).value).toBe('0 mL');
		expect(toTrendValues([zero])[0].value).toBe(0);
	});

	it('reports no value when the quantity is genuinely absent', () => {
		const cultured = create(ObservationSchema, {
			code: { display: 'Blood culture' },
			textValue: 'No growth after 48 hours',
			status: ObservationStatus.PRELIMINARY
		});
		const presented = toPresentedObservation(cultured);
		expect(presented.value).toBe('No growth after 48 hours');
		expect(toTrendValues([cultured])[0].value).toBeNull();
	});

	it('labels a preliminary result as preliminary', () => {
		// A preliminary blood culture at 2am changes treatment, and must not be
		// mistaken for the final answer.
		const preliminary = create(ObservationSchema, { status: ObservationStatus.PRELIMINARY });
		expect(toPresentedObservation(preliminary).status).toBe('Preliminary');
	});

	it('carries the interpretation and its source', () => {
		const critical = create(ObservationSchema, {
			interpretation: Interpretation.CRITICAL_HIGH,
			interpretationSource: 'Central laboratory'
		});
		const presented = toPresentedObservation(critical);
		expect(presented.critical).toBe(true);
		expect(presented.interpretationSource).toBe('Central laboratory');
	});

	it('does not invent an interpretation when none was sent', () => {
		// SRS-CLN-011: the UI must not infer criticality. An unset value is
		// "nobody said", not "normal".
		const uninterpreted = create(ObservationSchema, {});
		const presented = toPresentedObservation(uninterpreted);
		expect(presented.critical).toBe(false);
		expect(presented.interpretationLabel).toMatch(/not interpreted/i);
	});
});
