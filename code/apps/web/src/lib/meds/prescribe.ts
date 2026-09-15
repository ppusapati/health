/**
 * Prescribing and the pharmacist's verification queue
 * (SRS-MED-001, SRS-MED-002, SRS-MED-003, SRS-MED-010, SRS-MED-012,
 * SRS-MED-006, UX-W1-05).
 *
 * Prescribing is the highest-consequence action a clinician takes through a
 * screen, and the screen's job is almost entirely about what it refuses.
 *
 * A contraindicated finding is not overridable — at all, by anybody, with any
 * reason. It is the one severity where the answer is "no" rather than "why".
 * Everything below it is overridable *with a reason attached to that specific
 * rule*, because the reason is what a pharmacist reads at verification and what
 * an incident review reads afterwards, and a blanket "override all" would make
 * both worthless.
 *
 * A free-text dose is refused for configured classes (SRS-MED-010). "As
 * directed" for an anticoagulant is not a dose; it is a note that somebody else
 * will have to interpret at 3am. The structured fields are the ones the eMAR,
 * the interaction checker and the dose-support rules can all read.
 *
 * A non-formulary choice is not blocked. It shows the policy action and the
 * approval path (SRS-MED-012), because the drug may be exactly right and the
 * prescriber needs to know what it takes to get it — a hard block here is what
 * produces a phone call and a handwritten chart.
 */

/** Mirrors medication.v1.Severity. */
export type Severity =
	| 'contraindicated'
	| 'severe'
	| 'moderate'
	| 'mild'
	| 'informational'
	| 'unspecified';

/** Mirrors medication.v1.FindingKind. */
export type FindingKind =
	| 'allergy'
	| 'interaction'
	| 'duplicate_therapy'
	| 'dose_support'
	| 'unspecified';

/** Mirrors medication.v1.TherapyStatus. */
export type TherapyStatus =
	| 'draft'
	| 'active'
	| 'held'
	| 'discontinued'
	| 'completed'
	| 'unspecified';

/** Mirrors medication.v1.FormularyStatus. */
export type FormularyStatus =
	| 'formulary'
	| 'restricted'
	| 'non_formulary'
	| 'unknown'
	| 'unspecified';

/** One safety finding as the screen shows it. */
export interface PresentedFinding {
	/** Identifies the rule this finding came from, for the override. */
	readonly ruleId: string;
	readonly ruleVersion: string;
	readonly kind: FindingKind;
	readonly kindLabel: string;
	readonly severity: Severity;
	readonly severityLabel: string;
	readonly summary: string;
	/** The medications or substances involved, named. */
	readonly subjects: readonly string[];
	/**
	 * False for a contraindication. The one severity where the answer is no
	 * rather than why.
	 */
	readonly overridable: boolean;
	/** A reason already recorded against this finding, if any. */
	readonly existingOverrideReason: string;
}

const severityLabels: Record<Severity, string> = {
	contraindicated: 'Contraindicated',
	severe: 'Severe',
	moderate: 'Moderate',
	mild: 'Mild',
	informational: 'For information',
	unspecified: 'Not graded'
};

const kindLabels: Record<FindingKind, string> = {
	allergy: 'Allergy',
	interaction: 'Interaction',
	duplicate_therapy: 'Duplicate therapy',
	dose_support: 'Dose advice',
	unspecified: 'Safety finding'
};

/** Sort rank. Lower is more serious. */
const severityRank: Record<Severity, number> = {
	contraindicated: 0,
	severe: 1,
	moderate: 2,
	mild: 3,
	informational: 4,
	unspecified: 5
};

/** Human label for a severity. */
export function describeSeverity(severity: Severity): string {
	return severityLabels[severity];
}

/** Human label for a finding kind. */
export function describeFindingKind(kind: FindingKind): string {
	return kindLabels[kind];
}

/** Presents one safety finding. */
export function presentFinding(finding: {
	readonly ruleId: string;
	readonly ruleVersion: string;
	readonly kind: FindingKind;
	readonly severity: Severity;
	readonly summary: string;
	readonly subjects: readonly string[];
	readonly existingOverrideReason: string;
}): PresentedFinding {
	return {
		ruleId: finding.ruleId,
		ruleVersion: finding.ruleVersion,
		kind: finding.kind,
		kindLabel: kindLabels[finding.kind],
		severity: finding.severity,
		severityLabel: severityLabels[finding.severity],
		summary: finding.summary,
		subjects: finding.subjects,
		// Not configurable here. The ceiling a policy may set is a server
		// decision (SRS-MED-003); what this asserts is only that a
		// contraindication is never presented as something a reason can clear.
		overridable: finding.severity !== 'contraindicated',
		existingOverrideReason: finding.existingOverrideReason
	};
}

/** Orders findings so the one that stops the prescription is first. */
export function orderFindings(findings: readonly PresentedFinding[]): readonly PresentedFinding[] {
	return [...findings].sort(
		(a, b) => severityRank[a.severity] - severityRank[b.severity] || a.ruleId.localeCompare(b.ruleId)
	);
}

/** A reason given against one rule. */
export interface OverrideAnswer {
	readonly ruleId: string;
	readonly reason: string;
}

/** Where the prescriber is with the safety findings. */
export type SafetyGate =
	| { readonly state: 'clear' }
	/** At least one contraindication. No reason will help. */
	| {
			readonly state: 'contraindicated';
			readonly message: string;
			readonly findings: readonly PresentedFinding[];
	  }
	/** Overridable findings that have not all been answered. */
	| {
			readonly state: 'needs-reasons';
			readonly message: string;
			readonly outstanding: readonly PresentedFinding[];
	  }
	| { readonly state: 'overridden'; readonly answered: readonly PresentedFinding[] };

/**
 * Decides whether the prescription may be submitted.
 *
 * Reasons are matched per rule. A single "I have considered these" box would be
 * one sentence covering an allergy and a dose warning at once, which is exactly
 * what makes an override record unreadable at the verification step.
 */
export function safetyGate(
	findings: readonly PresentedFinding[],
	answers: readonly OverrideAnswer[]
): SafetyGate {
	const blocking = findings.filter((f) => !f.overridable);
	if (blocking.length > 0) {
		return {
			state: 'contraindicated',
			message:
				blocking.length === 1
					? 'This is contraindicated for this patient. It cannot be prescribed here.'
					: `${blocking.length} contraindications apply. This cannot be prescribed here.`,
			findings: blocking
		};
	}

	// Informational findings are shown and do not gate. Requiring a typed
	// reason for every piece of advice is what trains prescribers to type "ok"
	// into the box that also guards the severe ones.
	const gating = findings.filter(
		(f) => f.severity !== 'informational' && f.existingOverrideReason === ''
	);
	if (gating.length === 0) {
		return { state: 'clear' };
	}

	const answered = new Map(
		answers.filter((a) => a.reason.trim() !== '').map((a) => [a.ruleId, a.reason])
	);
	const outstanding = gating.filter((f) => !answered.has(f.ruleId));

	if (outstanding.length > 0) {
		return {
			state: 'needs-reasons',
			message:
				outstanding.length === 1
					? 'Give a reason for the safety warning before prescribing.'
					: `Give a reason for each of the ${outstanding.length} safety warnings.`,
			outstanding
		};
	}

	return { state: 'overridden', answered: gating };
}

/** A dose as typed into the composer. */
export interface DoseDraft {
	/** Numeric amount, or '' when only free text was given. */
	readonly amount: string;
	readonly unit: string;
	/** What the prescriber typed instead of a structured dose. */
	readonly freeText: string;
	/** Seconds between doses. Zero means none given. */
	readonly frequencySeconds: number;
}

/** What the prescription composer holds. */
export interface PrescriptionDraft {
	readonly patientId: string;
	readonly encounterId: string;
	readonly ingredientCode: string;
	readonly ingredientDisplay: string;
	/**
	 * The drug's therapeutic class, when the prescriber has named one.
	 *
	 * The structured-dose rule is configured per class (SRS-MED-010), and the
	 * class of an arbitrary typed code is not something the browser can know.
	 * So when it is blank the client cannot apply the rule and does not pretend
	 * to — the server still enforces it, and the refusal explains itself.
	 */
	readonly drugClass: string;
	readonly route: string;
	readonly dose: DoseDraft;
	readonly indication: string;
	readonly startsAt: string;
}

/**
 * Whether this drug's class must carry a structured dose.
 *
 * Returns false for a drug whose class is unknown to the composer. That is the
 * honest answer rather than the safe-looking one: refusing free text for
 * everything unclassified would block legitimate "two puffs as needed"
 * prescribing on the many drugs a hospital never classifies, and the server
 * is the authority either way.
 */
export function structuredDoseRequiredFor(
	structuredDoseClasses: readonly string[],
	drugClass: string
): boolean {
	const normalised = drugClass.trim().toLowerCase();
	if (normalised === '') {
		return false;
	}
	return structuredDoseClasses.some((klass) => klass.trim().toLowerCase() === normalised);
}

/** Why a prescription cannot be written yet. */
export interface PrescribeValidity {
	readonly ready: boolean;
	readonly problems: Readonly<Record<string, string>>;
	readonly order: readonly string[];
}

/**
 * Validates a prescription draft.
 *
 * `structuredDoseRequired` comes from the medication policy for this drug's
 * class (SRS-MED-010). Passed in rather than decided here: which classes must
 * not take a free-text dose is a clinical policy a hospital sets, and a list
 * hard-coded in the browser would be both wrong and invisible.
 */
export function validatePrescription(
	draft: PrescriptionDraft,
	options: { readonly structuredDoseRequired: boolean }
): PrescribeValidity {
	const problems: Record<string, string> = {};

	if (draft.patientId.trim() === '') {
		problems.patient = 'This prescription is not attached to a patient.';
	}
	if (draft.encounterId.trim() === '') {
		problems.encounter = 'This prescription is not attached to an encounter.';
	}
	if (draft.ingredientCode.trim() === '' && draft.ingredientDisplay.trim() === '') {
		problems.ingredient = 'Choose what is being prescribed.';
	}
	if (draft.route.trim() === '') {
		// A drug with no route is one the eMAR cannot present and a nurse has
		// to guess at. Oral and intravenous paracetamol are different doses.
		problems.route = 'Give the route.';
	}
	if (draft.indication.trim() === '') {
		// SRS-MED-001 asks for it, and it is what makes a later review able to
		// tell whether the therapy is still needed.
		problems.indication = 'Give the indication.';
	}

	const hasStructured = draft.dose.amount.trim() !== '' && draft.dose.unit.trim() !== '';
	const hasFreeText = draft.dose.freeText.trim() !== '';

	if (!hasStructured && !hasFreeText) {
		problems.dose = 'Give a dose.';
	} else if (options.structuredDoseRequired && !hasStructured) {
		// SRS-MED-010. "As directed" for an anticoagulant is not a dose; it is
		// a note somebody has to interpret at 3am.
		problems.dose =
			'This medicine needs a numeric dose and unit rather than free text. ' +
			'The eMAR and the dose checks cannot read free text.';
	}

	if (hasStructured && Number.isNaN(Number(draft.dose.amount))) {
		problems.dose = 'The dose amount is not a number.';
	}
	if (hasStructured && Number(draft.dose.amount) <= 0) {
		problems.dose = 'The dose amount must be greater than zero.';
	}

	const order = ['patient', 'encounter', 'ingredient', 'dose', 'route', 'indication']
		.filter((field) => problems[field] !== undefined)
		.map((field) => problems[field]);

	return { ready: order.length === 0, problems, order };
}

/** True when everything permits the prescription to be written. */
export function mayPrescribe(validity: PrescribeValidity, gate: SafetyGate): boolean {
	if (!validity.ready) {
		return false;
	}
	return gate.state === 'clear' || gate.state === 'overridden';
}

/** What the formulary panel says. */
export interface FormularyNotice {
	readonly status: FormularyStatus;
	readonly label: string;
	/** What has to happen for this drug to be used here. */
	readonly action: string;
	/** True when the notice deserves prominence. */
	readonly prominent: boolean;
}

const formularyLabels: Record<FormularyStatus, string> = {
	formulary: 'On formulary',
	restricted: 'Restricted',
	non_formulary: 'Not on formulary',
	// "Nobody has classified this" rather than "it is fine".
	unknown: 'Formulary status unknown',
	unspecified: 'Formulary status not checked'
};

/**
 * Describes the formulary decision.
 *
 * Never a block. The drug may be exactly right, and the prescriber needs to
 * know what it takes to get it — a hard block here produces a phone call and a
 * handwritten chart, which is worse in every way (SRS-MED-012).
 */
export function describeFormulary(decision: {
	readonly status: FormularyStatus;
	readonly restriction: string;
	readonly approvalPath: string;
}): FormularyNotice {
	const action =
		decision.approvalPath !== ''
			? decision.approvalPath
			: decision.restriction !== ''
				? decision.restriction
				: '';

	return {
		status: decision.status,
		label: formularyLabels[decision.status],
		action,
		prominent: decision.status === 'non_formulary' || decision.status === 'restricted'
	};
}

/** A prescription in the pharmacist's queue. */
export interface QueueEntry {
	readonly prescriptionId: string;
	readonly patientId: string;
	readonly description: string;
	readonly prescriberId: string;
	readonly createdAt: Date;
	readonly therapyStatus: TherapyStatus;
	/** The most serious ungraded-away finding, for triage. */
	readonly worstSeverity: Severity;
	readonly findings: readonly PresentedFinding[];
	/** True when the prescriber overrode at least one finding. */
	readonly overridden: boolean;
	readonly verified: boolean;
}

/**
 * Orders the verification queue.
 *
 * By worst finding, then oldest first. A pharmacist working top-down should
 * meet the prescription with a severe interaction before the twentieth routine
 * paracetamol, and among equals the one that has been waiting longest — a queue
 * sorted only by severity starves the bottom.
 */
export function orderQueue(entries: readonly QueueEntry[]): readonly QueueEntry[] {
	return [...entries].sort((a, b) => {
		const bySeverity = severityRank[a.worstSeverity] - severityRank[b.worstSeverity];
		if (bySeverity !== 0) {
			return bySeverity;
		}
		return a.createdAt.getTime() - b.createdAt.getTime();
	});
}

/** The most serious severity among findings, or 'unspecified' when there are none. */
export function worstSeverity(findings: readonly PresentedFinding[]): Severity {
	let worst: Severity = 'unspecified';
	for (const finding of findings) {
		if (severityRank[finding.severity] < severityRank[worst]) {
			worst = finding.severity;
		}
	}
	return worst;
}
