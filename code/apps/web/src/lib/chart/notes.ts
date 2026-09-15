/**
 * The clinical document lifecycle, as a screen has to obey it
 * (SRS-CLN-008, SRS-CLN-009, UX-W1-02).
 *
 * One rule shapes everything: signed content cannot be edited in place. There
 * is no UpdateNote for a signed document — only Amend, which supersedes it, and
 * Addendum, which adds without contradicting. Both produce a new document that
 * points back at the old one, and the old one stays readable, because somebody
 * may have read and acted on it.
 *
 * That rule is enforced by the server. What this module does is make the screen
 * agree with it *before* the click, so a clinician is never offered an Edit
 * button that will be refused — and, more importantly, is never offered one on
 * a note they have already signed, which is the moment they would assume the
 * edit is invisible.
 *
 * The distinction between Amend and Addendum is the one clinicians get wrong,
 * so the screen makes it explicit rather than inferring it. An amendment says
 * "what I wrote was wrong"; an addendum says "here is something that arrived
 * later". A discharge summary corrected because the discharge date was mistyped
 * is an amendment. The same summary with a histology result that came back a
 * week later is an addendum. Recording one as the other misrepresents whether
 * the original was ever true.
 */

/** Mirrors clinical.v1.DocumentStatus. */
export type DocumentStatus =
	| 'draft'
	| 'signed'
	| 'amended'
	| 'addendum'
	| 'entered_in_error'
	| 'unspecified';

/** Mirrors clinical.v1.SignatureMeaning. */
export type SignatureMeaning =
	| 'author'
	| 'verifier'
	| 'cosigner'
	| 'witness'
	| 'transcriber'
	| 'unspecified';

/** What may be done to a document from here. */
export interface DocumentActions {
	/** Editing the text in place. Only ever true for a draft. */
	readonly edit: boolean;
	/** Signing, which finalises it. */
	readonly sign: boolean;
	/** Correcting something that was wrong. */
	readonly amend: boolean;
	/** Adding something that arrived later. */
	readonly addendum: boolean;
	/** Marking it entered in error. Retained, never deleted. */
	readonly retract: boolean;
	/**
	 * Why nothing may be done, when nothing may be. Empty when at least one
	 * action is available.
	 */
	readonly blockedReason: string;
}

/** A document as the screen reads it. */
export interface ChartDocument {
	readonly documentId: string;
	readonly title: string;
	readonly kind: string;
	readonly status: DocumentStatus;
	readonly authoredBy: string;
	readonly createdAt: Date;
	readonly updatedAt: Date;
	/** Non-empty when this document supersedes another. */
	readonly amendsId: string;
	/** Non-empty when this document adds to another. */
	readonly addsToId: string;
	readonly changeReason: string;
	readonly retractionReason: string;
	/** True when the note was dictated rather than typed (SRS-CLN-016). */
	readonly dictated: boolean;
	readonly signatures: readonly {
		readonly subjectId: string;
		readonly meaning: SignatureMeaning;
		readonly signedAt: Date;
	}[];
	/**
	 * False when the stored content no longer hashes to what was signed
	 * (SRS-CLN-009).
	 */
	readonly intact: boolean;
	readonly confidentiality: string;
}

const statusLabels: Record<DocumentStatus, string> = {
	draft: 'Draft',
	signed: 'Signed',
	amended: 'Amended',
	addendum: 'Addendum',
	// Not "deleted". The document is retained because somebody may have read
	// and acted on it, and a record that can vanish proves nothing.
	entered_in_error: 'Entered in error',
	unspecified: 'Unknown'
};

/** Human label for a document status. */
export function describeStatus(status: DocumentStatus): string {
	return statusLabels[status];
}

/**
 * True when a signature finalises the document.
 *
 * A transcriber typed what somebody else dictated and is not asserting the
 * clinical content (SRS-CLN-016), so their signature does not finalise
 * anything — the clinician still has to review and sign. Treating it as a
 * signature is how a dictated note reaches the record with nobody clinically
 * accountable for it.
 */
export function finalises(meaning: SignatureMeaning): boolean {
	return meaning === 'author' || meaning === 'verifier' || meaning === 'cosigner';
}

/** True when the document carries at least one signature that finalises it. */
export function isFinalised(document: ChartDocument): boolean {
	return document.signatures.some((s) => finalises(s.meaning));
}

/**
 * What the screen may offer for this document.
 *
 * `isAuthor` is passed in rather than compared here because "may I amend
 * somebody else's note" is a policy the server owns; this only decides what to
 * render, and renders the narrower thing when in doubt.
 */
export function actionsFor(
	document: ChartDocument,
	viewer: { readonly subjectId: string; readonly mayWrite: boolean }
): DocumentActions {
	const none: DocumentActions = {
		edit: false,
		sign: false,
		amend: false,
		addendum: false,
		retract: false,
		blockedReason: ''
	};

	if (!viewer.mayWrite) {
		return { ...none, blockedReason: 'You have read-only access to this record.' };
	}

	if (!document.intact) {
		// The stored content no longer matches what was signed. Everything is
		// refused: amending it would produce a new document derived from
		// content nobody vouched for, and that is worse than refusing.
		return {
			...none,
			blockedReason:
				'This document no longer matches what was signed. It has been reported; ' +
				'do not amend or rely on it.'
		};
	}

	switch (document.status) {
		case 'draft':
			return {
				edit: true,
				sign: true,
				amend: false,
				addendum: false,
				// A draft nobody has read can be abandoned, but it is still
				// retracted rather than deleted — a draft that was visible to
				// the care team for an hour was still visible.
				retract: true,
				blockedReason: ''
			};
		case 'signed':
		case 'amended':
		case 'addendum':
			return {
				// No edit. This is the whole rule.
				edit: false,
				sign: false,
				amend: true,
				addendum: true,
				retract: true,
				blockedReason: ''
			};
		case 'entered_in_error':
			return {
				...none,
				blockedReason:
					'This document is marked entered in error. It is kept for the record ' +
					'and cannot be changed further.'
			};
		default:
			return { ...none, blockedReason: 'This document is in an unknown state.' };
	}
}

/** Why a correction is being made. */
export type CorrectionKind = 'amendment' | 'addendum';

/** What the screen needs to describe a correction before it is made. */
export interface CorrectionGuidance {
	readonly title: string;
	readonly detail: string;
	/** True when a reason is mandatory before the action may be submitted. */
	readonly reasonRequired: boolean;
}

/**
 * Explains the two kinds of correction in the terms the choice is actually
 * about.
 *
 * Deliberately not "Amend" and "Addendum" alone: those are the words the record
 * uses, not the question the clinician is answering. The question is whether
 * what they wrote was wrong or whether something has since arrived.
 */
export function describeCorrection(kind: CorrectionKind): CorrectionGuidance {
	if (kind === 'amendment') {
		return {
			title: 'Correct what this note says',
			detail:
				'Use this when the note was wrong. The original stays readable and is ' +
				'marked as superseded, because somebody may have acted on it.',
			// Required. An amendment with no reason leaves the next reader
			// unable to tell whether the original was a typing slip or a
			// clinical reversal, and those have very different consequences.
			reasonRequired: true
		};
	}
	return {
		title: 'Add something that arrived later',
		detail:
			'Use this when the note was right and there is more to say — a result that ' +
			'came back, a conversation after discharge. The original is unchanged.',
		reasonRequired: false
	};
}

/** Why a draft cannot be signed yet. */
export interface SignReadiness {
	readonly ready: boolean;
	/** One sentence per problem, in the order they should be fixed. */
	readonly problems: readonly string[];
}

/**
 * Checks a draft before offering to sign it.
 *
 * Signing is the irreversible step — after it the note can only be superseded,
 * never edited — so the screen checks what it can before the click rather than
 * letting the server refuse afterwards. The checks are deliberately about
 * completeness, not content: whether a note is clinically adequate is not
 * something a browser can assess, and pretending otherwise would be worse than
 * not trying.
 */
export function readyToSign(draft: {
	readonly title: string;
	readonly sections: readonly { readonly heading: string; readonly text: string }[];
	readonly templateVersion: string;
	readonly patientId: string;
	readonly encounterId: string;
}): SignReadiness {
	const problems: string[] = [];

	if (draft.patientId.trim() === '') {
		problems.push('This note is not attached to a patient.');
	}
	if (draft.encounterId.trim() === '') {
		problems.push('This note is not attached to an encounter.');
	}
	if (draft.title.trim() === '') {
		problems.push('Give the note a title.');
	}
	if (!draft.sections.some((section) => section.text.trim() !== '')) {
		// An empty signed note is worse than no note: it reads as an
		// assessment that found nothing worth recording.
		problems.push('The note has no content.');
	}
	if (draft.templateVersion.trim() === '') {
		// SRS-CLN-002: the saved note references the exact template version.
		// Without it, a note cannot be re-rendered as it was written once the
		// template changes.
		problems.push('The note is not linked to a template version.');
	}

	return { ready: problems.length === 0, problems };
}
