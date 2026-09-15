/**
 * Clinical protobuf messages to the models the chart uses.
 *
 * Same boundary discipline as $lib/reception/mapping.ts: every enum is mapped
 * exhaustively, with no `default:` that silently picks a plausible value. In a
 * clinical panel that matters more than it does on a board — a new criticality
 * value read as "low" is a reassurance nobody wrote.
 */
import { timestampDate } from '@bufbuild/protobuf/wkt';
import type { Timestamp } from '@bufbuild/protobuf/wkt';
import {
	AllergyCriticality as WireCriticality,
	AllergyKind as WireAllergyKind,
	AllergyVerification as WireVerification,
	Confidentiality as WireConfidentiality,
	DocumentStatus as WireDocumentStatus,
	Interpretation as WireInterpretation,
	ObservationStatus as WireObservationStatus,
	ProblemStatus as WireProblemStatus,
	SignatureMeaning as WireSignatureMeaning,
	type Allergy as WireAllergy,
	type Document as WireDocument,
	type Observation as WireObservation,
	type Problem as WireProblem
} from '$gen/healthcare/clinical/v1/clinical_pb.js';
import type { ChartDocument, DocumentStatus, SignatureMeaning } from './notes.js';
import {
	presentAllergy,
	presentObservation,
	presentProblem,
	type AllergyKind,
	type Criticality,
	type Interpretation,
	type PresentedAllergy,
	type PresentedObservation,
	type PresentedProblem,
	type ProblemStatus,
	type Verification
} from './safety.js';

function toDate(timestamp: Timestamp | undefined): Date | null {
	return timestamp ? timestampDate(timestamp) : null;
}

const documentStatuses: Record<WireDocumentStatus, DocumentStatus> = {
	[WireDocumentStatus.UNSPECIFIED]: 'unspecified',
	[WireDocumentStatus.DRAFT]: 'draft',
	[WireDocumentStatus.SIGNED]: 'signed',
	[WireDocumentStatus.AMENDED]: 'amended',
	[WireDocumentStatus.ADDENDUM]: 'addendum',
	[WireDocumentStatus.ENTERED_IN_ERROR]: 'entered_in_error'
};

const signatureMeanings: Record<WireSignatureMeaning, SignatureMeaning> = {
	[WireSignatureMeaning.UNSPECIFIED]: 'unspecified',
	[WireSignatureMeaning.AUTHOR]: 'author',
	[WireSignatureMeaning.VERIFIER]: 'verifier',
	[WireSignatureMeaning.COSIGNER]: 'cosigner',
	[WireSignatureMeaning.WITNESS]: 'witness',
	[WireSignatureMeaning.TRANSCRIBER]: 'transcriber'
};

const criticalities: Record<WireCriticality, Criticality> = {
	[WireCriticality.UNSPECIFIED]: 'unspecified',
	[WireCriticality.LOW]: 'low',
	[WireCriticality.HIGH]: 'high',
	// Deliberately not folded into 'low' or 'unspecified'. It is the one value
	// whose whole point is that it is neither.
	[WireCriticality.UNABLE_TO_ASSESS]: 'unable_to_assess'
};

const verifications: Record<WireVerification, Verification> = {
	[WireVerification.UNSPECIFIED]: 'unspecified',
	[WireVerification.UNCONFIRMED]: 'unconfirmed',
	[WireVerification.CONFIRMED]: 'confirmed',
	[WireVerification.REFUTED]: 'refuted',
	[WireVerification.ENTERED_IN_ERROR]: 'entered_in_error'
};

const allergyKinds: Record<WireAllergyKind, AllergyKind> = {
	[WireAllergyKind.UNSPECIFIED]: 'unspecified',
	[WireAllergyKind.ALLERGY]: 'allergy',
	[WireAllergyKind.INTOLERANCE]: 'intolerance'
};

const problemStatuses: Record<WireProblemStatus, ProblemStatus> = {
	[WireProblemStatus.UNSPECIFIED]: 'unspecified',
	[WireProblemStatus.ACTIVE]: 'active',
	[WireProblemStatus.REMISSION]: 'remission',
	[WireProblemStatus.RESOLVED]: 'resolved',
	[WireProblemStatus.INACTIVE]: 'inactive',
	[WireProblemStatus.ENTERED_IN_ERROR]: 'entered_in_error'
};

const interpretations: Record<WireInterpretation, Interpretation> = {
	[WireInterpretation.UNSPECIFIED]: 'unspecified',
	[WireInterpretation.NORMAL]: 'normal',
	[WireInterpretation.HIGH]: 'high',
	[WireInterpretation.LOW]: 'low',
	[WireInterpretation.CRITICAL_HIGH]: 'critical_high',
	[WireInterpretation.CRITICAL_LOW]: 'critical_low',
	[WireInterpretation.ABNORMAL]: 'abnormal',
	[WireInterpretation.UNKNOWN]: 'unknown'
};

const observationStatuses: Record<WireObservationStatus, string> = {
	[WireObservationStatus.UNSPECIFIED]: 'Unknown',
	[WireObservationStatus.REGISTERED]: 'Registered',
	// Reported because a preliminary blood culture at 2am changes treatment,
	// and labelled so nobody mistakes it for the final answer.
	[WireObservationStatus.PRELIMINARY]: 'Preliminary',
	[WireObservationStatus.FINAL]: 'Final',
	[WireObservationStatus.AMENDED]: 'Amended',
	[WireObservationStatus.CANCELLED]: 'Cancelled',
	[WireObservationStatus.ENTERED_IN_ERROR]: 'Entered in error'
};

const confidentialities: Record<WireConfidentiality, string> = {
	[WireConfidentiality.UNSPECIFIED]: 'normal',
	[WireConfidentiality.NORMAL]: 'normal',
	[WireConfidentiality.RESTRICTED]: 'restricted',
	[WireConfidentiality.VERY_RESTRICTED]: 'very_restricted'
};

/** Adapts a wire Document for the chart. */
export function toChartDocument(document: WireDocument): ChartDocument {
	return {
		documentId: document.documentId,
		title: document.title,
		kind: String(document.kind),
		status: documentStatuses[document.status] ?? 'unspecified',
		authoredBy: document.authoredBy,
		createdAt: toDate(document.createdAt) ?? new Date(0),
		updatedAt: toDate(document.updatedAt) ?? new Date(0),
		amendsId: document.amendsId,
		addsToId: document.addsToId,
		changeReason: document.changeReason,
		retractionReason: document.retractionReason,
		dictated: document.dictated,
		signatures: document.signatures.map((signature) => ({
			subjectId: signature.subjectId,
			meaning: signatureMeanings[signature.meaning] ?? 'unspecified',
			signedAt: toDate(signature.signedAt) ?? new Date(0)
		})),
		// Defaults to false when the field is absent rather than true. An
		// unverifiable document treated as intact is the one case where the
		// safe default and the convenient default differ.
		intact: document.intact,
		confidentiality: confidentialities[document.confidentiality] ?? 'normal'
	};
}

/** Adapts a wire Allergy for the safety panel. */
export function toPresentedAllergy(allergy: WireAllergy): PresentedAllergy {
	return presentAllergy({
		allergyId: allergy.allergyId,
		substance: allergy.substance?.display || allergy.substance?.code || 'Unnamed substance',
		kind: allergyKinds[allergy.kind] ?? 'unspecified',
		criticality: criticalities[allergy.criticality] ?? 'unspecified',
		verification: verifications[allergy.verification] ?? 'unspecified',
		reactions: allergy.reactions.map(
			(reaction) => reaction.manifestation?.display || reaction.manifestation?.code || ''
		),
		note: allergy.note
	});
}

/** Adapts a wire Problem for the problem list. */
export function toPresentedProblem(problem: WireProblem): PresentedProblem {
	return presentProblem({
		problemId: problem.problemId,
		code: problem.code?.code ?? '',
		display: problem.code?.display ?? '',
		status: problemStatuses[problem.status] ?? 'unspecified',
		onsetAt: toDate(problem.onsetAt),
		resolvedAt: toDate(problem.resolvedAt),
		note: problem.note
	});
}

/** Adapts a wire Observation for the results panel. */
export function toPresentedObservation(observation: WireObservation): PresentedObservation {
	return presentObservation({
		observationId: observation.observationId,
		display: observation.code?.display || observation.code?.code || 'Result',
		// A quantity of exactly zero is a real measurement, so the presence of
		// the value message decides, not its truthiness.
		value: observation.value ? observation.value.value : null,
		unit: observation.value?.unit ?? '',
		textValue: observation.textValue || observation.codedValue?.display || '',
		interpretation: interpretations[observation.interpretation] ?? 'unspecified',
		interpretationSource: observation.interpretationSource,
		referenceLow: observation.referenceLow,
		referenceHigh: observation.referenceHigh,
		hasReferenceRange: observation.hasReferenceRange,
		referenceText: observation.referenceText,
		effectiveAt: toDate(observation.effectiveAt) ?? new Date(0),
		status: observationStatuses[observation.status] ?? 'Unknown'
	});
}

/** The raw numeric values a trend needs, paired with their ids. */
export function toTrendValues(
	observations: readonly WireObservation[]
): readonly { readonly observationId: string; readonly value: number | null }[] {
	return observations.map((observation) => ({
		observationId: observation.observationId,
		value: observation.value ? observation.value.value : null
	}));
}
