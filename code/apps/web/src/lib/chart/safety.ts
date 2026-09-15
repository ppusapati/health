/**
 * The safety panels: allergies, problems and critical results
 * (SRS-CLN-003, SRS-CLN-004, SRS-CLN-011, SRS-CLN-012, UX-W1-02).
 *
 * These are the parts of a chart that exist to stop something happening, and
 * each of them has a presentation rule that looks like a detail and is not.
 *
 * "Unable to assess" is not "low". An allergy nobody could grade is a gap in
 * what is known; rendering it beside the low-criticality entries tells a
 * prescriber there is no danger when what it means is that nobody has looked.
 * It sorts with the high ones, because the question it raises is urgent.
 *
 * A refuted allergy stays on the list. Deleting it loses the fact that the
 * question was asked and settled, and the next clinician asks again — or worse,
 * re-records it from the patient's recollection.
 *
 * Criticality is never inferred from the reaction text. The laboratory,
 * the prescriber or the allergy service says how serious this is; a screen
 * reading "anaphylaxis" out of free text and promoting the row is a second,
 * undocumented classifier operating beside the recorded one.
 */

/** Mirrors clinical.v1.AllergyCriticality. */
export type Criticality = 'low' | 'high' | 'unable_to_assess' | 'unspecified';

/** Mirrors clinical.v1.AllergyVerification. */
export type Verification =
	| 'unconfirmed'
	| 'confirmed'
	| 'refuted'
	| 'entered_in_error'
	| 'unspecified';

/** Mirrors clinical.v1.AllergyKind. */
export type AllergyKind = 'allergy' | 'intolerance' | 'unspecified';

/** Mirrors clinical.v1.ProblemStatus. */
export type ProblemStatus =
	| 'active'
	| 'remission'
	| 'resolved'
	| 'inactive'
	| 'entered_in_error'
	| 'unspecified';

/** Mirrors clinical.v1.Interpretation. */
export type Interpretation =
	| 'normal'
	| 'high'
	| 'low'
	| 'critical_high'
	| 'critical_low'
	| 'abnormal'
	| 'unknown'
	| 'unspecified';

/** An allergy as the panel shows it. */
export interface PresentedAllergy {
	readonly allergyId: string;
	readonly substance: string;
	readonly kind: AllergyKind;
	/** "Allergy" or "Intolerance". Never conflated: see below. */
	readonly kindLabel: string;
	readonly criticality: Criticality;
	readonly criticalityLabel: string;
	readonly verification: Verification;
	readonly verificationLabel: string;
	readonly reactions: readonly string[];
	/** True when this row should be visually prominent. */
	readonly prominent: boolean;
	/** True when the row is kept for the record rather than acted on. */
	readonly historical: boolean;
	readonly note: string;
}

const criticalityLabels: Record<Criticality, string> = {
	high: 'High risk',
	low: 'Low risk',
	// The honest phrasing. "Unknown" reads as a shrug; this reads as a task.
	unable_to_assess: 'Not assessed — risk unknown',
	unspecified: 'Not recorded'
};

const verificationLabels: Record<Verification, string> = {
	// Most allergy records are this, and they still warn. Labelling it
	// "unverified" in a way that invites dismissal is how a real allergy gets
	// prescribed through.
	unconfirmed: 'Reported by the patient',
	confirmed: 'Confirmed',
	refuted: 'Investigated and ruled out',
	entered_in_error: 'Entered in error',
	unspecified: 'Not recorded'
};

const kindLabels: Record<AllergyKind, string> = {
	// Clinically different. Confusing them is how a patient with mild nausea on
	// codeine ends up unable to receive any opiate.
	allergy: 'Allergy',
	intolerance: 'Intolerance',
	unspecified: 'Not classified'
};

/** Sort rank. Lower is shown first. */
const criticalityRank: Record<Criticality, number> = {
	high: 0,
	// Sorted with the high ones. The question "nobody has graded this" is
	// urgent in the same way a known high risk is.
	unable_to_assess: 1,
	unspecified: 2,
	low: 3
};

/** Verifications where the row is kept for the record rather than acted on. */
const historicalVerifications = new Set<Verification>(['refuted', 'entered_in_error']);

/** Presents one allergy. */
export function presentAllergy(allergy: {
	readonly allergyId: string;
	readonly substance: string;
	readonly kind: AllergyKind;
	readonly criticality: Criticality;
	readonly verification: Verification;
	readonly reactions: readonly string[];
	readonly note: string;
}): PresentedAllergy {
	const historical = historicalVerifications.has(allergy.verification);
	return {
		allergyId: allergy.allergyId,
		substance: allergy.substance,
		kind: allergy.kind,
		kindLabel: kindLabels[allergy.kind],
		criticality: allergy.criticality,
		criticalityLabel: criticalityLabels[allergy.criticality],
		verification: allergy.verification,
		verificationLabel: verificationLabels[allergy.verification],
		reactions: allergy.reactions,
		prominent:
			!historical &&
			(allergy.criticality === 'high' || allergy.criticality === 'unable_to_assess'),
		historical,
		note: allergy.note
	};
}

/**
 * Orders the allergy panel.
 *
 * Active before historical, then by criticality. A refuted entry below a live
 * high-risk one is the only ordering that does not bury the thing a prescriber
 * needs.
 */
export function orderAllergies(
	allergies: readonly PresentedAllergy[]
): readonly PresentedAllergy[] {
	return [...allergies].sort((a, b) => {
		if (a.historical !== b.historical) {
			return a.historical ? 1 : -1;
		}
		const byCriticality = criticalityRank[a.criticality] - criticalityRank[b.criticality];
		if (byCriticality !== 0) {
			return byCriticality;
		}
		return a.substance.localeCompare(b.substance);
	});
}

/**
 * True when the panel has nothing recorded at all.
 *
 * Its own concept, because "no known allergies" and "nobody has asked" are
 * different clinical facts and an empty list is the second one. The screen says
 * so rather than rendering a reassuring blank.
 */
export function allergiesUnrecorded(allergies: readonly PresentedAllergy[]): boolean {
	return allergies.length === 0;
}

/** A problem as the list shows it. */
export interface PresentedProblem {
	readonly problemId: string;
	readonly code: string;
	readonly display: string;
	readonly status: ProblemStatus;
	readonly statusLabel: string;
	readonly onsetAt: Date | null;
	readonly resolvedAt: Date | null;
	/** True when the problem is current. */
	readonly active: boolean;
	/** True when it is kept as history rather than acted on. */
	readonly historical: boolean;
	readonly note: string;
}

const problemLabels: Record<ProblemStatus, string> = {
	active: 'Active',
	// Neither active nor resolved. A cancer in remission is not a cancer that
	// has gone, and collapsing the two loses the most important fact about the
	// patient.
	remission: 'In remission',
	resolved: 'Resolved',
	inactive: 'Inactive',
	entered_in_error: 'Entered in error',
	unspecified: 'Not recorded'
};

const problemRank: Record<ProblemStatus, number> = {
	active: 0,
	remission: 1,
	inactive: 2,
	resolved: 3,
	unspecified: 4,
	entered_in_error: 5
};

/** Presents one problem. */
export function presentProblem(problem: {
	readonly problemId: string;
	readonly code: string;
	readonly display: string;
	readonly status: ProblemStatus;
	readonly onsetAt: Date | null;
	readonly resolvedAt: Date | null;
	readonly note: string;
}): PresentedProblem {
	return {
		problemId: problem.problemId,
		code: problem.code,
		// A bare code on a screen is a screen clinicians stop reading.
		display: problem.display || problem.code,
		status: problem.status,
		statusLabel: problemLabels[problem.status],
		onsetAt: problem.onsetAt,
		resolvedAt: problem.resolvedAt,
		active: problem.status === 'active' || problem.status === 'remission',
		historical: problem.status === 'entered_in_error',
		note: problem.note
	};
}

/**
 * Orders the problem list.
 *
 * Active first, then remission, and resolved problems kept at the bottom rather
 * than hidden: a problem list that forgot a resolved myocardial infarction
 * would hide the most important fact about the patient.
 */
export function orderProblems(problems: readonly PresentedProblem[]): readonly PresentedProblem[] {
	return [...problems].sort((a, b) => {
		const byStatus = problemRank[a.status] - problemRank[b.status];
		if (byStatus !== 0) {
			return byStatus;
		}
		const aOnset = a.onsetAt?.getTime() ?? 0;
		const bOnset = b.onsetAt?.getTime() ?? 0;
		return bOnset - aOnset;
	});
}

/** An observation as the chart shows it. */
export interface PresentedObservation {
	readonly observationId: string;
	readonly display: string;
	/** "7.4 mmol/L", or the text value when it is not a quantity. */
	readonly value: string;
	/** The unit alone, so a trend can refuse to mix them. */
	readonly unit: string;
	readonly interpretation: Interpretation;
	readonly interpretationLabel: string;
	/**
	 * Who said it was abnormal. Shown, because SRS-CLN-011 is explicit that the
	 * flag comes from the authoritative service and the UI must not infer it —
	 * and a flag with no attribution is indistinguishable from an inferred one.
	 */
	readonly interpretationSource: string;
	readonly referenceRange: string;
	readonly effectiveAt: Date;
	readonly critical: boolean;
	readonly status: string;
}

const interpretationLabels: Record<Interpretation, string> = {
	normal: 'Normal',
	high: 'High',
	low: 'Low',
	critical_high: 'Critically high',
	critical_low: 'Critically low',
	abnormal: 'Abnormal',
	// "Nobody said" rather than "it is fine". The difference is the whole
	// reason the enum has this value.
	unknown: 'Not interpreted',
	unspecified: 'Not interpreted'
};

/** Human label for an interpretation. */
export function describeInterpretation(interpretation: Interpretation): string {
	return interpretationLabels[interpretation];
}

/** Presents one observation. */
export function presentObservation(observation: {
	readonly observationId: string;
	readonly display: string;
	readonly value: number | null;
	readonly unit: string;
	readonly textValue: string;
	readonly interpretation: Interpretation;
	readonly interpretationSource: string;
	readonly referenceLow: number;
	readonly referenceHigh: number;
	readonly hasReferenceRange: boolean;
	readonly referenceText: string;
	readonly effectiveAt: Date;
	readonly status: string;
}): PresentedObservation {
	const value =
		observation.value !== null
			? `${observation.value}${observation.unit ? ` ${observation.unit}` : ''}`
			: observation.textValue;

	const referenceRange = observation.hasReferenceRange
		? `${observation.referenceLow}–${observation.referenceHigh}${
				observation.unit ? ` ${observation.unit}` : ''
			}`
		: observation.referenceText;

	return {
		observationId: observation.observationId,
		display: observation.display,
		value,
		unit: observation.unit,
		interpretation: observation.interpretation,
		interpretationLabel: interpretationLabels[observation.interpretation],
		interpretationSource: observation.interpretationSource,
		referenceRange,
		effectiveAt: observation.effectiveAt,
		critical:
			observation.interpretation === 'critical_high' ||
			observation.interpretation === 'critical_low',
		status: observation.status
	};
}

/** A series of one observation code over time. */
export interface Trend {
	readonly display: string;
	readonly unit: string;
	readonly points: readonly { readonly at: Date; readonly value: number }[];
	/**
	 * True when the series contains more than one unit and was therefore not
	 * plotted. A trend that silently mixes mg/dL and mmol/L is a graph that
	 * reads as a clinical change.
	 */
	readonly mixedUnits: boolean;
}

/**
 * Builds a trend from observations of one code.
 *
 * Refuses to plot across units rather than converting. Conversion needs the
 * analyte's molar mass, which this layer does not have and must not guess; and
 * a silently converted series looks exactly like a correctly measured one.
 */
export function buildTrend(
	observations: readonly PresentedObservation[],
	raw: readonly { readonly observationId: string; readonly value: number | null }[]
): Trend {
	const byId = new Map(raw.map((r) => [r.observationId, r.value]));
	const numeric = observations.filter((o) => byId.get(o.observationId) !== null);

	const units = new Set(numeric.map((o) => o.unit));
	const mixedUnits = units.size > 1;

	return {
		display: numeric[0]?.display ?? '',
		unit: numeric[0]?.unit ?? '',
		points: mixedUnits
			? []
			: numeric
					.map((o) => ({ at: o.effectiveAt, value: byId.get(o.observationId) as number }))
					.sort((a, b) => a.at.getTime() - b.at.getTime()),
		mixedUnits
	};
}
