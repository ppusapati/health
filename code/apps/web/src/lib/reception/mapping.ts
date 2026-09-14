/**
 * Protobuf messages to the models the screens use.
 *
 * Everything above this file works in plain objects with string unions and
 * `Date`; everything below it is generated wire types with numeric enums and
 * protobuf `Timestamp`. Keeping the boundary in one tested module is what
 * stops an enum value being read as a truthy number somewhere in a template —
 * the kind of mistake that renders "Cancelled" as "Scheduled" and is invisible
 * in review.
 *
 * The translations are total. Every enum maps every case including
 * `UNSPECIFIED`, because a `default:` that silently picks a sensible-looking
 * value is how a new server enum arrives in the browser as something it is not.
 */
import { timestampDate } from '@bufbuild/protobuf/wkt';
import type { Timestamp } from '@bufbuild/protobuf/wkt';
import {
	DatePrecision as WireDatePrecision,
	IdentifierType as WireIdentifierType,
	MatchOutcome as WireMatchOutcome,
	PatientStatus as WirePatientStatus,
	Sex as WireSex,
	type Patient as WirePatient,
	type PatientMatch as WirePatientMatch
} from '$gen/healthcare/empi/v1/patient_pb.js';
import {
	AppointmentStatus as WireAppointmentStatus,
	ArrivalMode as WireArrivalMode,
	Priority as WirePriority,
	type Appointment as WireAppointment,
	type QueuePosition as WireQueuePosition
} from '$gen/healthcare/scheduling/v1/appointment_pb.js';
import {
	displayName,
	type BannerIdentifier,
	type DatePrecision,
	type PatientLike,
	type PatientStatus,
	type Sex
} from '../patient/banner.js';
import type { ArrivalMode, BoardAppointment, BoardPosition, Priority, QueueStatus } from './board.js';
import { presentMatch, type MatchOutcome, type PresentedMatch } from './search.js';

/** A protobuf Timestamp as a Date, or null when absent. */
export function toDate(timestamp: Timestamp | undefined): Date | null {
	return timestamp ? timestampDate(timestamp) : null;
}

const sexes: Record<WireSex, Sex> = {
	[WireSex.UNSPECIFIED]: 'unspecified',
	[WireSex.UNKNOWN]: 'unknown',
	[WireSex.FEMALE]: 'female',
	[WireSex.MALE]: 'male',
	[WireSex.OTHER]: 'other'
};

const precisions: Record<WireDatePrecision, DatePrecision> = {
	[WireDatePrecision.UNSPECIFIED]: 'unknown',
	[WireDatePrecision.DAY]: 'day',
	[WireDatePrecision.MONTH]: 'month',
	[WireDatePrecision.YEAR]: 'year',
	[WireDatePrecision.ESTIMATED]: 'estimated'
};

const statuses: Record<WirePatientStatus, PatientStatus> = {
	[WirePatientStatus.UNSPECIFIED]: 'unspecified',
	[WirePatientStatus.CANDIDATE]: 'candidate',
	[WirePatientStatus.ACTIVE]: 'active',
	[WirePatientStatus.MERGED]: 'merged',
	[WirePatientStatus.INACTIVE]: 'inactive'
};

const identifierLabels: Record<WireIdentifierType, string> = {
	[WireIdentifierType.UNSPECIFIED]: 'Identifier',
	[WireIdentifierType.MRN]: 'MRN',
	[WireIdentifierType.NATIONAL_HEALTH]: 'National health ID',
	[WireIdentifierType.GOVERNMENT]: 'Government ID',
	[WireIdentifierType.INSURANCE]: 'Insurance',
	[WireIdentifierType.EXTERNAL]: 'External ID'
};

const outcomes: Record<WireMatchOutcome, MatchOutcome> = {
	[WireMatchOutcome.UNSPECIFIED]: 'unspecified',
	[WireMatchOutcome.DISTINCT]: 'distinct',
	[WireMatchOutcome.REVIEW]: 'review',
	[WireMatchOutcome.PROBABLE]: 'probable',
	[WireMatchOutcome.CONFLICT]: 'conflict'
};

const queueStatuses: Record<WireAppointmentStatus, QueueStatus> = {
	// Unspecified is mapped to 'scheduled' rather than left to a default. It
	// only occurs for a server older than this client, and "expected" is the
	// state that offers a check-in — the wrong guess is recoverable, whereas
	// guessing "in consultation" hides a patient standing at the desk.
	[WireAppointmentStatus.UNSPECIFIED]: 'scheduled',
	[WireAppointmentStatus.SCHEDULED]: 'scheduled',
	[WireAppointmentStatus.ARRIVED]: 'arrived',
	[WireAppointmentStatus.TRIAGED]: 'triaged',
	[WireAppointmentStatus.WAITING_CLINICIAN]: 'waiting_clinician',
	[WireAppointmentStatus.IN_CONSULTATION]: 'in_consultation',
	[WireAppointmentStatus.POST_CONSULTATION]: 'post_consultation',
	[WireAppointmentStatus.COMPLETED]: 'completed',
	[WireAppointmentStatus.NO_SHOW]: 'no_show',
	[WireAppointmentStatus.CANCELLED]: 'cancelled'
};

const priorities: Record<WirePriority, Priority> = {
	// Unspecified becomes standard, which is what the server means by it, and
	// never 'immediate': a board that promotes every unset priority to the top
	// makes the real ones invisible.
	[WirePriority.UNSPECIFIED]: 'standard',
	[WirePriority.IMMEDIATE]: 'immediate',
	[WirePriority.VERY_URGENT]: 'very_urgent',
	[WirePriority.URGENT]: 'urgent',
	[WirePriority.STANDARD]: 'standard',
	[WirePriority.NON_URGENT]: 'non_urgent'
};

const arrivalModes: Record<WireArrivalMode, ArrivalMode> = {
	[WireArrivalMode.UNSPECIFIED]: 'scheduled',
	[WireArrivalMode.WALK_IN]: 'walk_in',
	[WireArrivalMode.SCHEDULED]: 'scheduled',
	[WireArrivalMode.AMBULANCE]: 'ambulance',
	[WireArrivalMode.REFERRAL]: 'referral',
	[WireArrivalMode.TELEHEALTH]: 'telehealth'
};

/** Adapts a wire Patient for the banner. */
export function toPatientLike(patient: WirePatient, masked = false): PatientLike {
	const demographics = patient.demographics;
	const birth = demographics?.birthDate;
	const birthDate = birth ? toDate(birth.date) : null;

	return {
		patientId: patient.patientId,
		status: statuses[patient.status] ?? 'unspecified',
		name: demographics?.name
			? { family: demographics.name.family, given: demographics.name.given }
			: null,
		birthDate: birthDate
			? { date: birthDate, precision: precisions[birth!.precision] ?? 'unknown' }
			: null,
		sex: sexes[demographics?.sex ?? WireSex.UNSPECIFIED] ?? 'unspecified',
		identifiers: patient.identifiers.map(
			(identifier): BannerIdentifier => ({
				label: identifierLabels[identifier.type] ?? 'Identifier',
				value: identifier.value,
				primary: identifier.primary
			})
		),
		deceased: patient.deceased
			? { date: patient.deceased.date ? toDate(patient.deceased.date.date) : null }
			: null,
		mergedIntoPatientId: patient.mergedIntoPatientId,
		designation: patient.designation
			? {
					label: patient.designation.label,
					apparentSex: sexes[patient.designation.apparentSex] ?? 'unspecified',
					apparentAge: patient.designation.apparentAge
				}
			: null,
		masked
	};
}

/** Adapts a wire PatientMatch for the search results. */
export function toPresentedMatch(match: WirePatientMatch): PresentedMatch {
	const patient = match.patient;
	const name = patient?.demographics?.name;
	const former = match.matchedFormerName?.name;

	return presentMatch({
		patientId: patient?.patientId ?? '',
		displayName: displayName(name ? { family: name.family, given: name.given } : null),
		confidence: match.confidence,
		outcome: outcomes[match.outcome] ?? 'unspecified',
		masked: match.masked,
		matchedFormerName: displayName(
			former ? { family: former.family, given: former.given } : null
		)
	});
}

/** Adapts a wire Appointment for the board. */
export function toBoardAppointment(appointment: WireAppointment): BoardAppointment {
	return {
		appointmentId: appointment.appointmentId,
		patientId: appointment.patientId,
		token: appointment.token,
		status: queueStatuses[appointment.status] ?? 'scheduled',
		priority: priorities[appointment.priority] ?? 'standard',
		priorityReason: appointment.priorityReason,
		arrivalMode: arrivalModes[appointment.arrivalMode] ?? 'scheduled',
		// A missing start time would sort to 1970 and put the row at the top of
		// the board. The epoch is at least obviously wrong; a silent `now` is
		// not.
		startsAt: toDate(appointment.startsAt) ?? new Date(0),
		checkedInAt: toDate(appointment.checkedInAt),
		version: appointment.version
	};
}

/** Adapts a wire QueuePosition for the board. */
export function toBoardPosition(position: WireQueuePosition): BoardPosition | null {
	if (!position.appointment) {
		// A position with no appointment cannot be rendered or acted on. Dropped
		// rather than rendered as a blank row, which reads as a patient whose
		// details failed to load.
		return null;
	}
	return {
		appointment: toBoardAppointment(position.appointment),
		position: position.position,
		estimatedWaitSeconds: Number(position.estimatedWaitSeconds)
	};
}
