/**
 * Clinical print and PDF views (SRS-WEB-016).
 *
 * The verification clause is "printed representation references document
 * ID/version/date", and the reason is what happens to printed clinical
 * documents. They are faxed to another provider, scanned into a different
 * system, filed in a case bundle, and produced in evidence years later. By
 * then the only way to establish what a page is — and whether it is still
 * current — is what is printed on it.
 *
 * So a printed page carries its own identity, and a page whose identity cannot
 * be established is not printed at all. A document with a missing version is
 * more dangerous than no document: it looks authoritative and cannot be
 * checked against the record.
 */

/** Identity of the source record, printed on every page. */
export interface DocumentIdentity {
	readonly documentId: string;
	/** The record's version at the moment of printing. */
	readonly version: number;
	/** When the content was authored — not when it was printed. */
	readonly authoredAt: Date;
	/** The facility's zone, so the printed time means something specific. */
	readonly facilityZone: string;
	/** Who authored it. */
	readonly authorName: string;
}

/** A signature applied to the document, when it has one. */
export interface DocumentSignature {
	readonly signedBy: string;
	readonly signedAt: Date;
	/**
	 * Digest of the signed content. Printed so a later reader can establish
	 * that the page matches what was signed, rather than a later revision.
	 */
	readonly contentSha256: string;
}

/** The template that produced the layout. */
export interface TemplateVersion {
	readonly templateId: string;
	readonly version: string;
	/**
	 * Versioned templates matter because the same clinical content laid out
	 * differently can read differently — a field moved under a different
	 * heading changes what a reader believes it means. Reproducing a historical
	 * print needs the template it was produced with.
	 */
	readonly effectiveFrom: Date;
}

/** Thrown when a document cannot be printed safely. */
export class UnprintableDocumentError extends Error {
	constructor(message: string) {
		super(message);
		this.name = 'UnprintableDocumentError';
	}
}

/** The footer block rendered on every printed page. */
export interface PrintFooter {
	readonly documentReference: string;
	readonly templateReference: string;
	readonly printedAt: string;
	readonly signatureBlock: string | null;
	/**
	 * Shown when the document is unsigned. A draft that reaches a case file
	 * without saying it is a draft is the failure this exists to prevent.
	 */
	readonly draftWatermark: string | null;
}

function formatInZone(instant: Date, zone: string): string {
	return new Intl.DateTimeFormat('en-GB', {
		timeZone: zone,
		day: '2-digit',
		month: 'short',
		year: 'numeric',
		hour: '2-digit',
		minute: '2-digit',
		hour12: false,
		timeZoneName: 'short'
	}).format(instant);
}

/**
 * Builds the identity block for a printed document.
 *
 * Refuses rather than degrading. Every check here is something a reader years
 * later would need and could not reconstruct.
 */
export function buildFooter(params: {
	readonly identity: DocumentIdentity;
	readonly template: TemplateVersion;
	readonly signature: DocumentSignature | null;
	readonly printedAt: Date;
}): PrintFooter {
	const { identity, template, signature, printedAt } = params;

	if (!identity.documentId.trim()) {
		throw new UnprintableDocumentError('a printed document must carry its document id');
	}
	if (identity.version <= 0) {
		// A document with no version looks authoritative and cannot be checked
		// against the record, which is worse than not printing it.
		throw new UnprintableDocumentError(
			`document ${identity.documentId} has no version; a printed page that cannot ` +
				`be matched to a record version must not be produced`
		);
	}
	if (!template.templateId.trim() || !template.version.trim()) {
		throw new UnprintableDocumentError(
			'a printed document must name the template version that laid it out'
		);
	}
	if (Number.isNaN(identity.authoredAt.getTime())) {
		throw new UnprintableDocumentError('a printed document must carry its authored date');
	}

	return {
		documentReference:
			`Document ${identity.documentId} v${identity.version} · ` +
			`authored ${formatInZone(identity.authoredAt, identity.facilityZone)} ` +
			`by ${identity.authorName}`,
		templateReference: `Template ${template.templateId} v${template.version}`,
		// The printed time is distinct from the authored time and labelled as
		// such. A single date on a page is always read as the clinical date,
		// and on a reprint it would be wrong.
		printedAt: `Printed ${formatInZone(printedAt, identity.facilityZone)}`,
		signatureBlock: signature
			? `Signed by ${signature.signedBy} on ` +
				`${formatInZone(signature.signedAt, identity.facilityZone)} · ` +
				// Truncated for legibility; enough to detect a substituted page,
				// and the full digest is in the record.
				`content ${signature.contentSha256.slice(0, 16)}`
			: null,
		draftWatermark: signature ? null : 'DRAFT — NOT SIGNED'
	};
}

/**
 * Reports whether a printed page still matches the current record.
 *
 * Used when a page is re-presented — scanned back in, or quoted in a
 * discussion — to establish whether it is the current version. Returns a
 * reason rather than a boolean because "superseded" and "from another
 * document" call for different responses.
 */
export function reconcile(
	printed: { readonly documentId: string; readonly version: number },
	current: { readonly documentId: string; readonly version: number }
): { readonly current: boolean; readonly reason: string } {
	if (printed.documentId !== current.documentId) {
		return { current: false, reason: 'DIFFERENT_DOCUMENT' };
	}
	if (printed.version < current.version) {
		return { current: false, reason: 'SUPERSEDED' };
	}
	if (printed.version > current.version) {
		// The page claims a version the record does not have. Either the record
		// was restored from a backup or the page is not genuine; both need a
		// human.
		return { current: false, reason: 'UNKNOWN_VERSION' };
	}
	return { current: true, reason: 'CURRENT' };
}
