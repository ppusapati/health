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
