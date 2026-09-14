/**
 * Search before create (SRS-EMPI-003, SRS-EMPI-004, UX-W1-01).
 *
 * The requirement is that a receptionist searches before registering, is shown
 * duplicates with a confidence, and cannot create a second record for somebody
 * already in the index without acknowledging that they saw the candidates.
 *
 * The load-bearing word is *cannot*. A workflow that merely suggests searching
 * first is a workflow where, on a busy Monday, somebody types a name straight
 * into the registration form and the index grows a duplicate — and duplicate
 * patient records are how a clinician reads half a chart and misses an
 * allergy. So the gate is explicit state here, and the screen has no path
 * around it.
 *
 * The server enforces the same rule independently: RegisterPatient refuses a
 * probable duplicate unless the caller lists the ids it has seen. This module
 * is the half that makes the refusal comprehensible rather than surprising —
 * it is not the control.
 */

/** Mirrors empi.v1.MatchOutcome. */
export type MatchOutcome = 'distinct' | 'review' | 'probable' | 'conflict' | 'unspecified';

/** What the user typed. */
export interface SearchCriteria {
	readonly name: string;
	readonly phone: string;
	readonly identifierValue: string;
	/** ISO yyyy-mm-dd, or '' when not given. */
	readonly birthDate: string;
}

/** A result row as the screen shows it. */
export interface PresentedMatch {
	readonly patientId: string;
	readonly displayName: string;
	readonly outcome: MatchOutcome;
	/** "Almost certainly the same person", and so on. Never a bare percentage. */
	readonly outcomeLabel: string;
	/** 0…100, for a bar. The label is what a user should read. */
	readonly confidencePercent: number;
	/** Set when this patient was reached through a name they no longer hold. */
	readonly matchedFormerName: string;
	/** True when field-level access hid something on this row. */
	readonly masked: boolean;
	/**
	 * True when this candidate has to be acknowledged before a new record may
	 * be created for the person being registered.
	 */
	readonly blocksRegistration: boolean;
}

/** Why a search cannot run. */
export const REASON_NO_CRITERIA = 'NO_CRITERIA';
/** Why a search cannot run: one loose fragment matches half the index. */
export const REASON_TOO_BROAD = 'TOO_BROAD';

export interface SearchValidity {
	readonly runnable: boolean;
	readonly reason: typeof REASON_NO_CRITERIA | typeof REASON_TOO_BROAD | null;
	readonly message: string;
}

/**
 * Decides whether a search may run.
 *
 * A single-letter name fragment is refused rather than sent. It would return
 * the first page of an enormous result set, which looks to the user like "not
 * found on this page" and leads directly to creating a duplicate — the precise
 * failure search-before-create exists to prevent.
 */
export function validateSearch(criteria: SearchCriteria): SearchValidity {
	const name = criteria.name.trim();
	const phone = criteria.phone.trim();
	const identifier = criteria.identifierValue.trim();
	const birthDate = criteria.birthDate.trim();

	if (name === '' && phone === '' && identifier === '' && birthDate === '') {
		return {
			runnable: false,
			reason: REASON_NO_CRITERIA,
			message: 'Enter a name, phone number, date of birth or identifier to search.'
		};
	}
	if (identifier === '' && phone === '' && birthDate === '' && name.length < 2) {
		return {
			runnable: false,
			reason: REASON_TOO_BROAD,
			message:
				'Use at least two letters of the name, or add a date of birth, ' +
				'phone number or identifier.'
		};
	}
	return { runnable: true, reason: null, message: '' };
}

const outcomeLabels: Record<MatchOutcome, string> = {
	// Deliberately sentences rather than "92%". A percentage invites a
	// receptionist to develop a private threshold, and the threshold that
	// matters is the configured one the server applied (SRS-EMPI-004).
	probable: 'Almost certainly the same person',
	review: 'Possibly the same person — check before registering',
	conflict: 'Same identifier, different details — needs review',
	distinct: 'A different person',
	unspecified: 'Match strength not assessed'
};

/** Outcomes that make a new record a probable duplicate. */
const blocking = new Set<MatchOutcome>(['probable', 'review', 'conflict']);

/** Human label for a match outcome. */
export function describeOutcome(outcome: MatchOutcome): string {
	return outcomeLabels[outcome];
}

/** What the screen shows for one candidate. */
export function presentMatch(match: {
	readonly patientId: string;
	readonly displayName: string;
	readonly confidence: number;
	readonly outcome: MatchOutcome;
	readonly masked: boolean;
	readonly matchedFormerName: string;
}): PresentedMatch {
	return {
		patientId: match.patientId,
		displayName: match.displayName,
		outcome: match.outcome,
		outcomeLabel: outcomeLabels[match.outcome],
		confidencePercent: Math.round(Math.min(1, Math.max(0, match.confidence)) * 100),
		matchedFormerName: match.matchedFormerName,
		masked: match.masked,
		blocksRegistration: blocking.has(match.outcome)
	};
}

/** Where the receptionist is in search-before-create. */
export type RegistrationGate =
	/** Nothing searched yet. Registration is not offered at all. */
	| { readonly state: 'search-first'; readonly message: string }
	/** Searched, nothing found. Registration is the obvious next step. */
	| { readonly state: 'clear'; readonly message: string }
	/**
	 * Searched, candidates found. Registration is offered only once every
	 * blocking candidate has been looked at and rejected.
	 */
	| {
			readonly state: 'review-candidates';
			readonly message: string;
			readonly outstanding: readonly string[];
	  }
	| { readonly state: 'acknowledged'; readonly message: string };

/**
 * Decides whether "Register a new patient" may be offered.
 *
 * `searched` is separate from "there are no matches" on purpose: both produce
 * an empty candidate list, and they mean opposite things. Before a search,
 * an empty list means nobody has looked.
 */
export function registrationGate(params: {
	readonly searched: boolean;
	readonly matches: readonly PresentedMatch[];
	/** Candidate ids the user has explicitly said are a different person. */
	readonly acknowledged: readonly string[];
}): RegistrationGate {
	if (!params.searched) {
		return {
			state: 'search-first',
			message: 'Search for the patient before registering a new record.'
		};
	}

	const blockers = params.matches.filter((m) => m.blocksRegistration);
	if (blockers.length === 0) {
		return {
			state: 'clear',
			message: 'No existing record matches. You can register a new patient.'
		};
	}

	const seen = new Set(params.acknowledged);
	const outstanding = blockers.filter((m) => !seen.has(m.patientId)).map((m) => m.patientId);

	if (outstanding.length > 0) {
		return {
			state: 'review-candidates',
			message:
				outstanding.length === 1
					? 'One existing record may be this patient. Open it, or confirm it is somebody else.'
					: `${outstanding.length} existing records may be this patient. ` +
						'Open them, or confirm each is somebody else.',
			outstanding
		};
	}

	return {
		state: 'acknowledged',
		message:
			'You have confirmed the existing records are different people. ' +
			'Registering will create a new record.'
	};
}

/** True when the register action may be enabled. */
export function mayRegister(gate: RegistrationGate): boolean {
	return gate.state === 'clear' || gate.state === 'acknowledged';
}
