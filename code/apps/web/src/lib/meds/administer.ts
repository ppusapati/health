/**
 * Medication administration / eMAR (UX-W1-05, SRS-NUR-006/007, SRS-MED-009).
 *
 * The counterpart to `prescribe.ts`: that is where a medication order comes
 * from, this is where it reaches a patient. It is the screen where a mistake
 * arrives at a bedside, so the rules are stricter than anywhere else and the
 * reasons are written down.
 *
 * Three of them shape everything below.
 *
 * **An administration is never optimistic.** An optimistic tile shows the dose
 * as given the moment the button is pressed. If the request then fails, the
 * nurse has seen "given" and moves on, the next nurse reads the chart, sees
 * nothing, and gives it again. The tile stays pending until the server
 * confirms.
 *
 * **Refusing is not the same as not having given it.** The outcomes are
 * distinct on the wire and are kept distinct here: "held" is a clinical
 * decision, "refused" is the patient's, "not administered" is everything else,
 * and flattening them loses the only record of which happened.
 *
 * **The verification gate is the control, not the button.** Where policy
 * requires a barcode scan, an unscanned administration must be refused unless
 * an override reason is given — and the override must be recorded against the
 * dose, because an override nobody can find afterwards is not a control.
 *
 * The same rules as the Flutter shell's `lib/src/meds/round.dart`, and held to
 * that by `tools/parity`. A nurse who learns this round on a tablet and then
 * picks up a workstation must not meet a second set.
 */

/** Mirrors nursing.v1.AdministrationOutcome. */
export type AdministrationOutcome =
	| 'administered'
	| 'not_administered'
	| 'held'
	| 'refused'
	| 'delayed'
	| 'unspecified';

const outcomeLabels: Record<AdministrationOutcome, string> = {
	administered: 'Given',
	not_administered: 'Not given',
	held: 'Held',
	refused: 'Refused by patient',
	delayed: 'Delayed',
	unspecified: 'Outcome not recorded'
};

/** Human label for an outcome. */
export function describeOutcome(outcome: AdministrationOutcome): string {
	return outcomeLabels[outcome];
}

/**
 * Whether the outcome means the drug reached the patient.
 *
 * Used to decide what the tile says, never to decide what to send: the
 * outcomes are recorded as chosen.
 */
export function wasGiven(outcome: AdministrationOutcome): boolean {
	return outcome === 'administered';
}

/**
 * Outcomes that require the nurse to say why.
 *
 * Anything other than giving the drug as ordered is a deviation from the
 * prescription, and a deviation with no reason is a gap in the record at
 * exactly the point somebody will later ask about.
 */
export function needsReason(outcome: AdministrationOutcome): boolean {
	return outcome !== 'administered' && outcome !== 'unspecified';
}

/** What the deployment requires before a dose may be given. */
export interface RoundPolicy {
	/** True when patient and medication must be scanned. */
	readonly barcodeRequired: boolean;
	/**
	 * True when an unscanned dose may proceed with a recorded reason. A
	 * deployment that sets this false has decided the scan is absolute, and the
	 * screen must not offer a way past it.
	 */
	readonly overrideAllowed: boolean;
	/** How long after the scheduled time a dose counts as late. */
	readonly lateAfterMinutes: number;
}

/**
 * The shape used when the server sent no policy.
 *
 * The safe default is the strict one: requiring a scan the deployment did not
 * ask for is an inconvenience, and skipping one it did ask for is a patient
 * given the wrong drug.
 */
export const strictPolicy: RoundPolicy = {
	barcodeRequired: true,
	overrideAllowed: false,
	lateAfterMinutes: 60
};

/** What was scanned at the bedside. */
export interface Scan {
	readonly patient: string;
	readonly medication: string;
}

export function patientScanned(scan: Scan): boolean {
	return scan.patient.trim() !== '';
}

export function medicationScanned(scan: Scan): boolean {
	return scan.medication.trim() !== '';
}

export function scanComplete(scan: Scan): boolean {
	return patientScanned(scan) && medicationScanned(scan);
}

/** One due dose as the round shows it. */
export interface PresentedDose {
	readonly orderId: string;
	readonly medication: string;
	readonly doseLabel: string;
	readonly route: string;
	readonly scheduledAt: Date;
	/** Whether it still needs giving. */
	readonly outstanding: boolean;
	/**
	 * Whether the server says it is overdue — as with the worklist, not
	 * recomputed against the device clock.
	 */
	readonly overdue: boolean;
	/** How late, for display only. Negative before it is due. */
	readonly minutesLate: number;
	readonly prn: boolean;
	/**
	 * Whether a pharmacist has verified the order (SRS-MED-005). Shown because
	 * giving an unverified drug is a decision a nurse should make knowingly.
	 */
	readonly verifiedByPharmacy: boolean;
	/** The outcome already recorded, when there is one. */
	readonly recordedOutcome: AdministrationOutcome | null;
}

/** True when the dose has been dealt with, whatever the outcome was. */
export function settled(dose: PresentedDose): boolean {
	return dose.recordedOutcome !== null;
}

/**
 * Formats a dose for display.
 *
 * A trailing `.0` is dropped because "5.0 mg" and "5 mg" read differently at a
 * glance and one of them looks like a precision that was not measured. The
 * value is never rounded: a dose displayed as something other than the dose
 * ordered is the defect this whole screen exists to prevent.
 *
 * The magnitude guard is where this and the Dart implementation stop agreeing:
 * above 1e15 the two languages' default double formatting diverges (Dart
 * prints `1e+15`, JavaScript prints the digits). No medication dose is within
 * twelve orders of magnitude of that, and the parity corpus covers the range
 * that exists; if a dose ever is, this is the line to look at.
 */
export function formatDose(value: number, unit: string): string {
	const text =
		Number.isInteger(value) && Math.abs(value) < 1e15 ? value.toFixed(0) : String(value);
	return unit === '' ? text : `${text} ${unit}`;
}

/**
 * Orders the round.
 *
 * Outstanding doses first, earliest scheduled first. Settled doses keep their
 * place in time below, so the round reads as a timeline rather than a queue
 * that empties.
 */
export function orderDoses(doses: readonly PresentedDose[]): readonly PresentedDose[] {
	return [...doses].sort((a, b) => {
		if (a.outstanding !== b.outstanding) {
			return a.outstanding ? -1 : 1;
		}
		return a.scheduledAt.getTime() - b.scheduledAt.getTime();
	});
}

/** Why an administration may not proceed. */
export type Refusal =
	/** Policy requires a scan and the patient was not scanned. */
	| 'patient_not_scanned'
	/** Policy requires a scan and the medication was not scanned. */
	| 'medication_not_scanned'
	/** A scan is missing, an override would be needed, and none was given. */
	| 'override_reason_missing'
	/** A scan is missing and this deployment does not permit overriding. */
	| 'override_not_permitted'
	/** The outcome is a deviation and no reason was given. */
	| 'reason_missing'
	/** No outcome was chosen. */
	| 'outcome_missing'
	/** The dose has already been recorded. */
	| 'already_settled';

const refusalMessages: Record<Refusal, string> = {
	patient_not_scanned: 'Scan the patient’s wristband.',
	medication_not_scanned: 'Scan the medication.',
	override_reason_missing:
		'Giving this without scanning needs a reason, and the reason is kept with the dose.',
	override_not_permitted:
		'This ward does not allow giving a dose without scanning. Find a working scanner or a second nurse.',
	reason_missing: 'Say why the dose was not given as ordered.',
	outcome_missing: 'Choose what happened to this dose.',
	already_settled: 'This dose has already been recorded.'
};

/** What the screen tells the nurse about each refusal. */
export function describeRefusal(refusal: Refusal): string {
	return refusalMessages[refusal];
}

/** The decision about one attempted administration. */
export interface AdministrationDecision {
	readonly allowed: boolean;
	/**
	 * Everything wrong, not just the first thing. A nurse told one problem at a
	 * time is a nurse making three round trips to the trolley.
	 */
	readonly refusals: readonly Refusal[];
	/**
	 * True when this will be recorded as an override. The screen says so before
	 * the button is pressed, because an override is a thing the nurse is
	 * choosing, not a consequence they discover afterwards.
	 */
	readonly overriding: boolean;
}

/**
 * Decides whether an administration may be recorded.
 *
 * This is a local pre-flight, not the control. The server enforces the same
 * policy and its answer is the one that counts; this exists so a nurse at a
 * bedside is told what is missing before a round trip, and so the override is
 * named out loud at the moment it is being chosen.
 */
export function evaluateAdministration(input: {
	readonly dose: PresentedDose;
	readonly policy: RoundPolicy;
	readonly outcome: AdministrationOutcome | null;
	readonly scan: Scan;
	readonly overrideReason: string;
	readonly reason: string;
}): AdministrationDecision {
	const refusals: Refusal[] = [];

	if (settled(input.dose)) {
		refusals.push('already_settled');
	}
	if (input.outcome === null || input.outcome === 'unspecified') {
		refusals.push('outcome_missing');
	}
	if (input.outcome !== null && needsReason(input.outcome) && input.reason.trim() === '') {
		refusals.push('reason_missing');
	}

	// The scan gate applies to giving the drug. Recording that it was held or
	// refused does not put anything into a patient, and demanding a wristband
	// scan before a nurse can write down that the patient declined would teach
	// them to record it as something else.
	let overriding = false;
	const wouldGive = input.outcome === 'administered';
	if (input.policy.barcodeRequired && wouldGive && !scanComplete(input.scan)) {
		if (!patientScanned(input.scan)) refusals.push('patient_not_scanned');
		if (!medicationScanned(input.scan)) refusals.push('medication_not_scanned');

		if (!input.policy.overrideAllowed) {
			refusals.push('override_not_permitted');
		} else if (input.overrideReason.trim() === '') {
			refusals.push('override_reason_missing');
		} else {
			// The missing scans are excused by the override, but the override
			// itself is what gets recorded.
			for (let i = refusals.length - 1; i >= 0; i--) {
				if (refusals[i] === 'patient_not_scanned' || refusals[i] === 'medication_not_scanned') {
					refusals.splice(i, 1);
				}
			}
			overriding = true;
		}
	}

	return { allowed: refusals.length === 0, refusals, overriding };
}
