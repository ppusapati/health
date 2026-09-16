/**
 * Medication protobuf messages to the composer's models.
 */
import { timestampDate } from '@bufbuild/protobuf/wkt';
import type { Timestamp } from '@bufbuild/protobuf/wkt';
import {
	FindingKind as WireFindingKind,
	FormularyStatus as WireFormularyStatus,
	Severity as WireSeverity,
	TherapyStatus as WireTherapyStatus,
	type Prescription as WirePrescription,
	type SafetyFinding as WireFinding
} from '$gen/healthcare/medication/v1/medication_pb.js';
import {
	presentFinding,
	worstSeverity,
	type FindingKind,
	type FormularyStatus,
	type PresentedFinding,
	type QueueEntry,
	type Severity,
	type TherapyStatus
} from './prescribe.js';
import {
	AdministrationOutcome as WireOutcome,
	type AdministrationPolicy as WireAdministrationPolicy,
	type DueDose as WireDueDose
} from '$gen/healthcare/nursing/v1/nursing_pb.js';
import {
	formatDose,
	strictPolicy,
	type AdministrationOutcome,
	type PresentedDose,
	type RoundPolicy
} from './administer.js';

function toDate(timestamp: Timestamp | undefined): Date | null {
	return timestamp ? timestampDate(timestamp) : null;
}

const severities: Record<WireSeverity, Severity> = {
	[WireSeverity.UNSPECIFIED]: 'unspecified',
	[WireSeverity.CONTRAINDICATED]: 'contraindicated',
	[WireSeverity.SEVERE]: 'severe',
	[WireSeverity.MODERATE]: 'moderate',
	[WireSeverity.MILD]: 'mild',
	[WireSeverity.INFORMATIONAL]: 'informational'
};

const kinds: Record<WireFindingKind, FindingKind> = {
	[WireFindingKind.UNSPECIFIED]: 'unspecified',
	[WireFindingKind.ALLERGY]: 'allergy',
	[WireFindingKind.INTERACTION]: 'interaction',
	[WireFindingKind.DUPLICATE_THERAPY]: 'duplicate_therapy',
	[WireFindingKind.DOSE_SUPPORT]: 'dose_support'
};

const therapyStatuses: Record<WireTherapyStatus, TherapyStatus> = {
	[WireTherapyStatus.UNSPECIFIED]: 'unspecified',
	[WireTherapyStatus.DRAFT]: 'draft',
	[WireTherapyStatus.ACTIVE]: 'active',
	[WireTherapyStatus.HELD]: 'held',
	[WireTherapyStatus.DISCONTINUED]: 'discontinued',
	[WireTherapyStatus.COMPLETED]: 'completed'
};

const formularyStatuses: Record<WireFormularyStatus, FormularyStatus> = {
	[WireFormularyStatus.UNSPECIFIED]: 'unspecified',
	[WireFormularyStatus.FORMULARY]: 'formulary',
	[WireFormularyStatus.RESTRICTED]: 'restricted',
	[WireFormularyStatus.NON_FORMULARY]: 'non_formulary',
	[WireFormularyStatus.UNKNOWN]: 'unknown'
};

/** Human labels for therapy status. */
export const therapyLabels: Record<TherapyStatus, string> = {
	draft: 'Draft',
	active: 'Active',
	// Held is not discontinued: the therapy is expected to resume, and the
	// chart shows future doses suppressed rather than the drug removed.
	held: 'Held',
	discontinued: 'Discontinued',
	completed: 'Completed',
	unspecified: 'Unknown'
};

/** Adapts a wire SafetyFinding. */
export function toPresentedFinding(finding: WireFinding): PresentedFinding {
	return presentFinding({
		ruleId: finding.ruleId,
		ruleVersion: finding.ruleVersion,
		kind: kinds[finding.kind] ?? 'unspecified',
		// An unrecognised severity maps to 'unspecified', which the gate treats
		// as needing a reason rather than as safe. The alternative — folding it
		// into 'informational' — would let a newly added severity through
		// silently.
		severity: severities[finding.severity] ?? 'unspecified',
		summary: finding.summary,
		subjects: finding.subjects.map((subject) => subject.display || subject.code || ''),
		existingOverrideReason: finding.override?.reason ?? ''
	});
}

/** Describes a prescription in one line, for a queue row. */
export function describePrescription(prescription: WirePrescription): string {
	if (prescription.description !== '') {
		return prescription.description;
	}
	const drug =
		prescription.product?.display ||
		prescription.ingredient?.display ||
		prescription.ingredient?.code ||
		'Medicine';
	const first = prescription.segments[0];
	const dose = first?.dose
		? `${first.dose.value} ${first.dose.unit}`
		: (first?.freeTextDose ?? '');
	return [drug, dose, prescription.route].filter((part) => part !== '').join(' ');
}

/** Adapts a wire Prescription into a verification queue row. */
export function toQueueEntry(prescription: WirePrescription): QueueEntry {
	const findings = prescription.findings.map(toPresentedFinding);
	return {
		prescriptionId: prescription.prescriptionId,
		patientId: prescription.patientId,
		description: describePrescription(prescription),
		prescriberId: prescription.prescriberId,
		createdAt: toDate(prescription.createdAt) ?? new Date(0),
		therapyStatus: therapyStatuses[prescription.therapyStatus] ?? 'unspecified',
		worstSeverity: worstSeverity(findings),
		findings,
		overridden: findings.some((f) => f.existingOverrideReason !== ''),
		// Presence of the verification message decides. An empty `by` on a
		// present message would be a server bug, and treating it as unverified
		// is the safer reading of one.
		verified: prescription.verification !== undefined && prescription.verification.by !== ''
	};
}

/** The formulary decision in the shape describeFormulary wants. */
export function toFormularyDecision(prescription: WirePrescription): {
	readonly status: FormularyStatus;
	readonly restriction: string;
	readonly approvalPath: string;
} {
	const decision = prescription.formulary;
	return {
		status: decision ? (formularyStatuses[decision.status] ?? 'unspecified') : 'unspecified',
		restriction: decision?.restriction ?? '',
		approvalPath: decision?.approvalPath ?? ''
	};
}

/** Adapts a wire Prescription's therapy status. */
export function toTherapyStatus(prescription: WirePrescription): TherapyStatus {
	return therapyStatuses[prescription.therapyStatus] ?? 'unspecified';
}

// --------------------------------------------------------------------------
// Administration (nursing.v1), the other half of UX-W1-05.

const outcomes: Record<WireOutcome, AdministrationOutcome> = {
	[WireOutcome.UNSPECIFIED]: 'unspecified',
	[WireOutcome.ADMINISTERED]: 'administered',
	[WireOutcome.NOT_ADMINISTERED]: 'not_administered',
	[WireOutcome.HELD]: 'held',
	[WireOutcome.REFUSED]: 'refused',
	[WireOutcome.DELAYED]: 'delayed'
};

/** Adapts a wire AdministrationPolicy. */
export function toRoundPolicy(policy: WireAdministrationPolicy | undefined): RoundPolicy {
	// The strict shape when the server sent none. Requiring a scan the
	// deployment did not ask for is an inconvenience; skipping one it did ask
	// for is a patient given the wrong drug.
	if (!policy) {
		return strictPolicy;
	}
	return {
		barcodeRequired: policy.barcodeRequired,
		overrideAllowed: policy.overrideAllowed,
		lateAfterMinutes: Math.trunc(Number(policy.lateAfterSeconds) / 60)
	};
}

/** Adapts a wire DueDose. */
export function toPresentedDose(dose: WireDueDose, now: Date): PresentedDose {
	const order = dose.order;
	const scheduledAt = toDate(dose.scheduledAt) ?? new Date(0);
	return {
		orderId: order?.orderId ?? '',
		medication: order?.medication?.display || order?.medication?.code || '',
		doseLabel: formatDose(order?.dose?.value ?? 0, order?.dose?.unit ?? ''),
		route: order?.route ?? '',
		scheduledAt,
		outstanding: dose.outstanding,
		// From the server, as with the worklist: a browser clock that is wrong
		// would silently reorder the round.
		overdue: dose.overdue,
		minutesLate: Math.floor((now.getTime() - scheduledAt.getTime()) / 60000),
		prn: order?.prn ?? false,
		verifiedByPharmacy: order?.verified ?? false,
		// An outcome this build does not know is shown as unrecorded rather
		// than guessed at. "Given" would be the dangerous guess.
		recordedOutcome: dose.given ? (outcomes[dose.given.outcome] ?? 'unspecified') : null
	};
}

/** The wire value for an outcome the nurse chose. */
export function toWireOutcome(outcome: AdministrationOutcome): WireOutcome {
	switch (outcome) {
		case 'administered':
			return WireOutcome.ADMINISTERED;
		case 'not_administered':
			return WireOutcome.NOT_ADMINISTERED;
		case 'held':
			return WireOutcome.HELD;
		case 'refused':
			return WireOutcome.REFUSED;
		case 'delayed':
			return WireOutcome.DELAYED;
		case 'unspecified':
			return WireOutcome.UNSPECIFIED;
	}
}
