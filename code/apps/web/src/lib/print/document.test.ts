import { describe, expect, it } from 'vitest';
import {
	buildFooter,
	reconcile,
	UnprintableDocumentError,
	type DocumentIdentity,
	type DocumentSignature,
	type TemplateVersion
} from './document.js';

const identity = (overrides: Partial<DocumentIdentity> = {}): DocumentIdentity => ({
	documentId: 'doc-9f2a',
	version: 3,
	authoredAt: new Date('2026-09-11T06:30:00Z'),
	facilityZone: 'Asia/Kolkata',
	authorName: 'Dr Priya Ramaswamy',
	...overrides
});

const template: TemplateVersion = {
	templateId: 'discharge-summary',
	version: '2.1',
	effectiveFrom: new Date('2026-01-01T00:00:00Z')
};

const signature: DocumentSignature = {
	signedBy: 'Dr Priya Ramaswamy',
	signedAt: new Date('2026-09-11T07:00:00Z'),
	contentSha256: 'abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789'
};

describe('printed document identity (SRS-WEB-016)', () => {
	it('prints the document id, version and authored date', () => {
		const footer = buildFooter({
			identity: identity(),
			template,
			signature,
			printedAt: new Date('2026-09-12T09:00:00Z')
		});

		expect(footer.documentReference).toContain('doc-9f2a');
		expect(footer.documentReference).toContain('v3');
		expect(footer.documentReference).toContain('12:00'); // 06:30 UTC in IST
	});

	it('names the template version that laid the page out', () => {
		// The same clinical content laid out differently can read differently:
		// a field moved under another heading changes what a reader believes it
		// means, so reproducing a historical print needs its template.
		const footer = buildFooter({
			identity: identity(),
			template,
			signature,
			printedAt: new Date('2026-09-12T09:00:00Z')
		});
		expect(footer.templateReference).toBe('Template discharge-summary v2.1');
	});

	it('distinguishes the printed date from the authored date', () => {
		// A single date on a page is always read as the clinical date, and on a
		// reprint that reading is wrong.
		const footer = buildFooter({
			identity: identity(),
			template,
			signature,
			printedAt: new Date('2026-09-12T09:00:00Z')
		});
		expect(footer.printedAt).toContain('Printed');
		// Matched loosely on the month: ICU renders en-GB's short month as
		// "Sep" or "Sept" depending on the Node build.
		expect(footer.printedAt).toMatch(/12 Sept? 2026/);
		expect(footer.documentReference).toMatch(/11 Sept? 2026/);
	});

	it('prints times in the facility’s zone, not the printer’s', () => {
		const footer = buildFooter({
			identity: identity({ facilityZone: 'Europe/London' }),
			template,
			signature,
			printedAt: new Date('2026-09-12T09:00:00Z')
		});
		// 06:30 UTC is 07:30 BST in September.
		expect(footer.documentReference).toContain('07:30');
	});

	it('carries the signature and its content digest', () => {
		const footer = buildFooter({
			identity: identity(),
			template,
			signature,
			printedAt: new Date('2026-09-12T09:00:00Z')
		});
		expect(footer.signatureBlock).toContain('Signed by Dr Priya Ramaswamy');
		// Enough digest to detect a substituted page.
		expect(footer.signatureBlock).toContain('abcdef0123456789');
		expect(footer.draftWatermark).toBeNull();
	});

	it('watermarks an unsigned document', () => {
		// A draft that reaches a case file without saying it is a draft is the
		// failure this exists to prevent.
		const footer = buildFooter({
			identity: identity(),
			template,
			signature: null,
			printedAt: new Date('2026-09-12T09:00:00Z')
		});
		expect(footer.draftWatermark).toContain('DRAFT');
		expect(footer.signatureBlock).toBeNull();
	});
});

describe('a page that cannot be identified is not printed', () => {
	it('refuses a document with no version', () => {
		// A document with no version looks authoritative and cannot be checked
		// against the record, which is worse than not printing it.
		expect(() =>
			buildFooter({
				identity: identity({ version: 0 }),
				template,
				signature,
				printedAt: new Date()
			})
		).toThrow(UnprintableDocumentError);
	});

	it('refuses a document with no id', () => {
		expect(() =>
			buildFooter({
				identity: identity({ documentId: '  ' }),
				template,
				signature,
				printedAt: new Date()
			})
		).toThrow(UnprintableDocumentError);
	});

	it('refuses a page with no template version', () => {
		expect(() =>
			buildFooter({
				identity: identity(),
				template: { ...template, version: '' },
				signature,
				printedAt: new Date()
			})
		).toThrow(UnprintableDocumentError);
	});

	it('refuses a document with no authored date', () => {
		expect(() =>
			buildFooter({
				identity: identity({ authoredAt: new Date('not a date') }),
				template,
				signature,
				printedAt: new Date()
			})
		).toThrow(UnprintableDocumentError);
	});
});

describe('reconciling a re-presented page', () => {
	it('recognises the current version', () => {
		expect(reconcile({ documentId: 'doc-1', version: 3 }, { documentId: 'doc-1', version: 3 }))
			.toEqual({ current: true, reason: 'CURRENT' });
	});

	it('reports a superseded page', () => {
		const result = reconcile(
			{ documentId: 'doc-1', version: 2 },
			{ documentId: 'doc-1', version: 5 }
		);
		expect(result.current).toBe(false);
		expect(result.reason).toBe('SUPERSEDED');
	});

	it('distinguishes a page from another document', () => {
		// "Superseded" and "from another document" call for different
		// responses, so they are different reasons rather than one false.
		const result = reconcile(
			{ documentId: 'doc-2', version: 3 },
			{ documentId: 'doc-1', version: 3 }
		);
		expect(result.reason).toBe('DIFFERENT_DOCUMENT');
	});

	it('flags a page claiming a version the record does not have', () => {
		// Either the record was restored from a backup or the page is not
		// genuine. Both need a human.
		const result = reconcile(
			{ documentId: 'doc-1', version: 9 },
			{ documentId: 'doc-1', version: 3 }
		);
		expect(result.reason).toBe('UNKNOWN_VERSION');
	});
});
