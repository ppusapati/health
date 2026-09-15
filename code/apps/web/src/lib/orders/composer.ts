/**
 * The order composer and the results inbox (SRS-ORD-002, SRS-ORD-007,
 * SRS-ORD-009, SRS-CLN-012, UX-W1-04).
 *
 * Placing an order is the point at which a clinician's intention becomes work
 * somebody else does — a phlebotomist draws blood, a radiographer irradiates
 * somebody, a porter moves a bed. The composer's job is to make the order
 * either complete or refused, never ambiguous, because an ambiguous order is
 * resolved downstream by somebody guessing.
 *
 * Three rules shape it.
 *
 * A required indication blocks submit (SRS-ORD-007). Not a warning: the
 * indication is what the performing service uses to decide protocol and
 * urgency, and "clinical correlation" written after the fact is not the same
 * information. Which types require one is configuration, so the composer reads
 * it rather than hard-coding a list that will be wrong in some hospital.
 *
 * A duplicate is a warning with an override, never a silent suppression
 * (SRS-ORD-009). Two potassium levels four hours apart may be exactly right in
 * a patient on an insulin infusion. Suppressing the second would hide a
 * clinically necessary order; refusing it outright would make the system
 * something clinicians work around. So the screen shows what already exists,
 * asks why, and records the answer.
 *
 * An acknowledgement is per-order, not a blanket "yes". The override names the
 * orders it was given against, so acknowledging a duplicate this morning does
 * not silently cover a different duplicate this afternoon.
 */

/** Mirrors orders.v1.OrderType. */
export type OrderType =
	| 'laboratory'
	| 'imaging'
	| 'medication'
	| 'procedure'
	| 'diet'
	| 'nursing'
	| 'blood_product'
	| 'referral'
	| 'allied_health'
	| 'unspecified';

/** Mirrors orders.v1.OrderStatus. */
export type OrderStatus =
	| 'draft'
	| 'requested'
	| 'accepted'
	| 'scheduled'
	| 'in_progress'
	| 'completed'
	| 'cancelled'
	| 'entered_in_error'
	| 'unspecified';

/** Mirrors orders.v1.Priority. */
export type OrderPriority =
	| 'routine'
	| 'urgent'
	| 'stat'
	| 'timing_critical'
	| 'unspecified';

/** What configuration says an order type requires. */
export interface OrderPolicy {
	readonly type: OrderType;
	/** SRS-ORD-007: submit is blocked until an indication is given. */
	readonly indicationRequired: boolean;
	/** SRS-ORD-008: a start time and frequency rather than free text. */
	readonly structuredTimingRequired: boolean;
	/** Named so the screen can say which privilege is missing, not just "no". */
	readonly requiredPrivilege: string;
}

const typeLabels: Record<OrderType, string> = {
	laboratory: 'Laboratory',
	imaging: 'Imaging',
	medication: 'Medication',
	procedure: 'Procedure',
	diet: 'Diet',
	nursing: 'Nursing',
	blood_product: 'Blood product',
	referral: 'Referral',
	allied_health: 'Allied health',
	unspecified: 'Not specified'
};

const statusLabels: Record<OrderStatus, string> = {
	draft: 'Draft',
	requested: 'Requested',
	accepted: 'Accepted',
	scheduled: 'Scheduled',
	in_progress: 'In progress',
	completed: 'Completed',
	cancelled: 'Cancelled',
	// Retained, not deleted: the performing service may already have acted.
	entered_in_error: 'Entered in error',
	unspecified: 'Unknown'
};

const priorityLabels: Record<OrderPriority, string> = {
	stat: 'STAT',
	urgent: 'Urgent',
	// Its own priority, not a synonym for urgent: a dose that must be given at
	// 08:00 is not more urgent than one needed now, it is differently urgent.
	timing_critical: 'Timing critical',
	routine: 'Routine',
	unspecified: 'Not prioritised'
};

/** Human label for an order type. */
export function describeType(type: OrderType): string {
	return typeLabels[type];
}

/** Human label for an order status. */
export function describeOrderStatus(status: OrderStatus): string {
	return statusLabels[status];
}

/** Human label for an order priority. */
export function describeOrderPriority(priority: OrderPriority): string {
	return priorityLabels[priority];
}

/** What the composer holds. */
export interface OrderDraft {
	readonly type: OrderType;
	readonly patientId: string;
	readonly encounterId: string;
	readonly code: string;
	readonly display: string;
	readonly detail: string;
	readonly indication: string;
	readonly priority: OrderPriority;
	/** ISO local datetime, or '' when not given. */
	readonly startAt: string;
	readonly frequencySeconds: number;
	readonly conditionalInstruction: string;
}

/** Why an order cannot be placed yet. */
export interface ComposerValidity {
	readonly ready: boolean;
	/** Keyed by the field, so the message can sit beside the input. */
	readonly problems: Readonly<Record<string, string>>;
	/** In the order they should be fixed, for a summary. */
	readonly order: readonly string[];
}

/**
 * Validates a draft order against the configured policy for its type.
 *
 * The server validates again and is the authority (SRS-ORD-002 returns
 * structured field errors). This exists so the clinician is told before the
 * click — an order refused after submit costs the composer's contents in
 * practice, because the failure arrives when attention has already moved on.
 */
export function validateOrder(draft: OrderDraft, policy: OrderPolicy | null): ComposerValidity {
	const problems: Record<string, string> = {};

	if (draft.type === 'unspecified') {
		problems.type = 'Choose what kind of order this is.';
	}
	if (draft.patientId.trim() === '') {
		problems.patient = 'This order is not attached to a patient.';
	}
	if (draft.encounterId.trim() === '') {
		problems.encounter = 'This order is not attached to an encounter.';
	}
	if (draft.code.trim() === '' && draft.display.trim() === '') {
		problems.code = 'Choose what is being ordered.';
	}

	if (policy?.indicationRequired && draft.indication.trim() === '') {
		// SRS-ORD-007. Blocking, not advisory: the performing service uses the
		// indication to decide protocol and urgency, and it cannot be
		// reconstructed afterwards.
		problems.indication =
			'This kind of order needs a clinical indication before it can be placed.';
	}

	if (policy?.structuredTimingRequired) {
		if (draft.startAt.trim() === '') {
			problems.startAt = 'Give a start time.';
		}
		if (draft.frequencySeconds <= 0) {
			// SRS-ORD-008: downstream receives normalised timing. "TDS" in a
			// free-text box is not something a scheduler can act on.
			problems.frequency = 'Give how often, as a frequency rather than as free text.';
		}
	}

	const order = [
		'type',
		'patient',
		'encounter',
		'code',
		'indication',
		'startAt',
		'frequency'
	]
		.filter((field) => problems[field] !== undefined)
		.map((field) => problems[field]);

	return { ready: order.length === 0, problems, order };
}

/** An existing order the composer is warning about. */
export interface DuplicateCandidate {
	readonly orderId: string;
	readonly number: string;
	readonly display: string;
	readonly status: OrderStatus;
	readonly statusLabel: string;
	readonly placedAt: Date;
	readonly requesterId: string;
}

/** Where the clinician is with a duplicate warning. */
export type DuplicateGate =
	/** Nothing to warn about. */
	| { readonly state: 'clear' }
	/** Duplicates exist and policy allows an override with a reason. */
	| {
			readonly state: 'needs-override';
			readonly message: string;
			readonly candidates: readonly DuplicateCandidate[];
			readonly windowHours: number;
	  }
	/** Duplicates exist and policy does not permit an override. */
	| {
			readonly state: 'refused';
			readonly message: string;
			readonly candidates: readonly DuplicateCandidate[];
	  }
	/** The clinician has given a reason for these specific orders. */
	| { readonly state: 'overridden'; readonly candidates: readonly DuplicateCandidate[] };

/**
 * Decides what to do about a duplicate warning.
 *
 * `acknowledged` lists the order ids the reason was given against. It is
 * compared against the current candidates rather than counted, so a reason
 * given for this morning's duplicate does not silently cover a different one
 * this afternoon.
 */
export function duplicateGate(params: {
	readonly candidates: readonly DuplicateCandidate[];
	readonly overridable: boolean;
	readonly windowSeconds: number;
	readonly acknowledged: readonly string[];
	readonly reason: string;
}): DuplicateGate {
	if (params.candidates.length === 0) {
		return { state: 'clear' };
	}

	if (!params.overridable) {
		return {
			state: 'refused',
			message:
				'An identical order is already live and policy does not allow a duplicate. ' +
				'Use the existing order, or cancel it first.',
			candidates: params.candidates
		};
	}

	const seen = new Set(params.acknowledged);
	const covered = params.candidates.every((candidate) => seen.has(candidate.orderId));

	if (covered && params.reason.trim() !== '') {
		return { state: 'overridden', candidates: params.candidates };
	}

	const windowHours = Math.max(1, Math.round(params.windowSeconds / 3600));
	return {
		state: 'needs-override',
		message:
			params.candidates.length === 1
				? `An order for this was placed in the last ${windowHours} hours. ` +
					'Say why another is needed.'
				: `${params.candidates.length} orders for this were placed in the last ` +
					`${windowHours} hours. Say why another is needed.`,
		candidates: params.candidates,
		windowHours
	};
}

/** True when the place button may be enabled. */
export function mayPlace(validity: ComposerValidity, gate: DuplicateGate): boolean {
	if (!validity.ready) {
		return false;
	}
	return gate.state === 'clear' || gate.state === 'overridden';
}

/** A critical result awaiting acknowledgement. */
export interface InboxItem {
	readonly observationId: string;
	readonly patientId: string;
	readonly display: string;
	readonly value: string;
	readonly interpretationLabel: string;
	readonly effectiveAt: Date;
	/** How many escalations the server says are now due (SRS-CLN-012). */
	readonly dueEscalations: number;
	/** Minutes since the result was issued. */
	readonly waitingMinutes: number;
}

/**
 * Orders the results inbox.
 *
 * By escalations first, then by age. A result that has already escalated twice
 * is one where the acknowledgement process has failed, and it belongs above a
 * fresher result that is merely unread — sorting purely by age buries it as the
 * list grows.
 */
export function orderInbox(items: readonly InboxItem[]): readonly InboxItem[] {
	return [...items].sort((a, b) => {
		if (a.dueEscalations !== b.dueEscalations) {
			return b.dueEscalations - a.dueEscalations;
		}
		return a.effectiveAt.getTime() - b.effectiveAt.getTime();
	});
}

/** Why an acknowledgement cannot be submitted. */
export function acknowledgementProblem(action: string): string {
	if (action.trim() === '') {
		// SRS-CLN-012 asks for the action taken, not merely that somebody
		// looked. "Seen" closes the loop administratively and leaves the next
		// reader unable to tell whether anything was done about a potassium of
		// 6.8.
		return 'Say what was done about this result, not only that it was seen.';
	}
	return '';
}
