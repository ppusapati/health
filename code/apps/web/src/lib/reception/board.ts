/**
 * The reception board (UX-W1-01, SRS-SCH-007 … SRS-SCH-011).
 *
 * What a receptionist actually looks at: who has arrived, who is still
 * expected, where each person is in the queue, and how long they have been
 * waiting. The server owns the queue and its estimates (SRS-SCH-009); this
 * turns that into rows and decides what the screen is allowed to imply.
 *
 * Two of those decisions matter more than they look.
 *
 * A board is a snapshot, and a stale snapshot is worse than a blank one. The
 * numbers on this screen change continuously as people are called through, and
 * a receptionist reading a five-minute-old position as current tells a patient
 * something untrue. So staleness is computed and shown rather than left to a
 * polling interval nobody can see.
 *
 * Waiting time is measured from arrival, not from the appointment. A patient
 * who arrived an hour early has not been waiting an hour, and a patient whose
 * appointment was at nine and who arrived at ten has been waiting since ten.
 * Measuring from the scheduled time produces a board that sorts the wrong
 * people to the top.
 */
import type { WorklistDefinition } from '../prefs/views.js';

/** Mirrors scheduling.v1.AppointmentStatus. */
export type QueueStatus =
	| 'scheduled'
	| 'arrived'
	| 'triaged'
	| 'waiting_clinician'
	| 'in_consultation'
	| 'post_consultation'
	| 'completed'
	| 'no_show'
	| 'cancelled';

/** Mirrors scheduling.v1.Priority. */
export type Priority = 'immediate' | 'very_urgent' | 'urgent' | 'standard' | 'non_urgent';

/** Mirrors scheduling.v1.ArrivalMode. */
export type ArrivalMode = 'walk_in' | 'scheduled' | 'ambulance' | 'referral' | 'telehealth';

/** One appointment as the board reads it. */
export interface BoardAppointment {
	readonly appointmentId: string;
	readonly patientId: string;
	readonly token: string;
	readonly status: QueueStatus;
	readonly priority: Priority;
	readonly priorityReason: string;
	readonly arrivalMode: ArrivalMode;
	readonly startsAt: Date;
	readonly checkedInAt: Date | null;
	readonly version: bigint;
}

/** A queue position as the server reported it. */
export interface BoardPosition {
	readonly appointment: BoardAppointment;
	readonly position: number;
	readonly estimatedWaitSeconds: number;
}

/** One row on the board. */
export interface BoardRow {
	readonly appointmentId: string;
	readonly patientId: string;
	readonly token: string;
	readonly status: QueueStatus;
	readonly statusLabel: string;
	readonly priority: Priority;
	/** Non-empty only when the priority was raised, and then it is required. */
	readonly priorityReason: string;
	readonly arrivalMode: ArrivalMode;
	readonly scheduledAt: Date;
	/** Position in the queue, or null for someone who has not arrived. */
	readonly position: number | null;
	/** Minutes since arrival, or null for someone who has not arrived. */
	readonly waitedMinutes: number | null;
	/** The server's estimate, in minutes, or null when it gave none. */
	readonly estimatedWaitMinutes: number | null;
	/** True when this row is waiting on a clinician rather than on reception. */
	readonly withClinician: boolean;
	/** The check-in action is offered only for someone expected and not yet arrived. */
	readonly canCheckIn: boolean;
	/**
	 * The version this row was read at.
	 *
	 * Not sent with an action — CheckIn takes no expected version, because the
	 * server guards the transition itself: the appointment's state machine
	 * refuses a second check-in and the repository writes under the version it
	 * read. It is kept here so the screen can tell that a row changed under it
	 * between refreshes, which is the difference between "nothing happened" and
	 * "somebody else did this while you were looking".
	 */
	readonly version: bigint;
}

/** The whole board. */
export interface Board {
	readonly rows: readonly BoardRow[];
	/** How many have arrived and are still waiting to be seen. */
	readonly waiting: number;
	/** The service rate the estimate is based on, in minutes. */
	readonly serviceMinutes: number | null;
	/**
	 * True when the estimate is derived from what this clinic actually did
	 * today rather than from a configured default. A configured default shown
	 * as though it were observed is a wait time a receptionist will quote.
	 */
	readonly estimateObserved: boolean;
	readonly activeClinicians: number;
	/** True when nothing is expected and nobody is waiting. */
	readonly empty: boolean;
	/** Age of the snapshot, in seconds. */
	readonly ageSeconds: number;
	/** True when the snapshot is too old to be quoted to a patient. */
	readonly stale: boolean;
}

/**
 * How old a board may be before it is called stale.
 *
 * Thirty seconds, because that is roughly how long it takes for a position to
 * be wrong once a clinic is moving: one patient called through shifts every
 * number below them.
 */
export const STALE_AFTER_SECONDS = 30;

const statusLabels: Record<QueueStatus, string> = {
	scheduled: 'Expected',
	arrived: 'Arrived',
	triaged: 'Triaged',
	waiting_clinician: 'Waiting for clinician',
	in_consultation: 'In consultation',
	post_consultation: 'After consultation',
	completed: 'Completed',
	no_show: 'Did not attend',
	cancelled: 'Cancelled'
};

/** Rank for sorting. Lower is more urgent. */
const priorityRank: Record<Priority, number> = {
	immediate: 0,
	very_urgent: 1,
	urgent: 2,
	standard: 3,
	non_urgent: 4
};

/** Statuses where the patient is in the department but not yet finished. */
const present = new Set<QueueStatus>([
	'arrived',
	'triaged',
	'waiting_clinician',
	'in_consultation',
	'post_consultation'
]);

/** Statuses where reception has nothing left to do. */
const withClinicianStatuses = new Set<QueueStatus>([
	'waiting_clinician',
	'in_consultation',
	'post_consultation'
]);

/** Human label for a queue status. */
export function describeStatus(status: QueueStatus): string {
	return statusLabels[status];
}

/**
 * Builds the board from the queue and the appointments expected today.
 *
 * Both are needed. The queue holds people who have arrived; the appointment
 * list holds people who have not. A board built from the queue alone shows an
 * empty clinic at nine in the morning, which is exactly when a receptionist
 * needs to see who is coming.
 */
export function buildBoard(params: {
	readonly positions: readonly BoardPosition[];
	readonly expected: readonly BoardAppointment[];
	readonly serviceMinutes: number | null;
	readonly estimateObserved: boolean;
	readonly activeClinicians: number;
	/** When the server produced this snapshot. */
	readonly fetchedAt: Date;
	readonly now: Date;
}): Board {
	const queued = new Map(params.positions.map((p) => [p.appointment.appointmentId, p]));

	const rows: BoardRow[] = [];

	for (const position of params.positions) {
		rows.push(toRow(position.appointment, position, params.now));
	}
	for (const appointment of params.expected) {
		if (queued.has(appointment.appointmentId)) {
			continue;
		}
		// Finished and abandoned appointments are not the reception desk's
		// work. Leaving them on the board is how a busy clinic's screen fills
		// with rows nobody acts on and the live ones stop being noticed.
		if (
			appointment.status === 'completed' ||
			appointment.status === 'cancelled' ||
			appointment.status === 'no_show'
		) {
			continue;
		}
		rows.push(toRow(appointment, null, params.now));
	}

	rows.sort(compareRows);

	const ageSeconds = Math.max(
		0,
		Math.floor((params.now.getTime() - params.fetchedAt.getTime()) / 1000)
	);

	return {
		rows,
		waiting: rows.filter((r) => r.position !== null && !r.withClinician).length,
		serviceMinutes: params.serviceMinutes,
		estimateObserved: params.estimateObserved,
		activeClinicians: params.activeClinicians,
		empty: rows.length === 0,
		ageSeconds,
		stale: ageSeconds > STALE_AFTER_SECONDS
	};
}

function toRow(
	appointment: BoardAppointment,
	position: BoardPosition | null,
	now: Date
): BoardRow {
	const waitedMinutes = appointment.checkedInAt
		? Math.max(0, Math.floor((now.getTime() - appointment.checkedInAt.getTime()) / 60_000))
		: null;

	return {
		appointmentId: appointment.appointmentId,
		patientId: appointment.patientId,
		token: appointment.token,
		status: appointment.status,
		statusLabel: statusLabels[appointment.status],
		priority: appointment.priority,
		priorityReason: appointment.priorityReason,
		arrivalMode: appointment.arrivalMode,
		scheduledAt: appointment.startsAt,
		position: position?.position ?? null,
		waitedMinutes,
		estimatedWaitMinutes:
			position && position.estimatedWaitSeconds > 0
				? Math.round(position.estimatedWaitSeconds / 60)
				: null,
		withClinician: withClinicianStatuses.has(appointment.status),
		// Only for someone expected and not yet here. Offering it for an
		// arrived patient invites a second check-in that the server refuses,
		// and offering it for a cancelled one is just noise.
		canCheckIn: appointment.status === 'scheduled',
		version: appointment.version
	};
}

/**
 * Orders the board the way a receptionist reads it.
 *
 * Present patients first, because they are standing at the desk. Within those,
 * clinical priority, then queue position. Expected patients follow in
 * appointment order, which is the order they will arrive in.
 */
function compareRows(a: BoardRow, b: BoardRow): number {
	const aPresent = present.has(a.status);
	const bPresent = present.has(b.status);
	if (aPresent !== bPresent) {
		return aPresent ? -1 : 1;
	}
	if (aPresent) {
		const byPriority = priorityRank[a.priority] - priorityRank[b.priority];
		if (byPriority !== 0) {
			return byPriority;
		}
		const aPosition = a.position ?? Number.MAX_SAFE_INTEGER;
		const bPosition = b.position ?? Number.MAX_SAFE_INTEGER;
		if (aPosition !== bPosition) {
			return aPosition - bPosition;
		}
	}
	return a.scheduledAt.getTime() - b.scheduledAt.getTime();
}

/**
 * The board's columns.
 *
 * Token, patient and priority are mandatory. A saved view that hides the token
 * makes it impossible to call the next patient; one that hides the priority
 * hides the reason somebody was moved up the queue, which is the thing
 * SRS-SCH-011 requires to stay visible.
 */
export const receptionWorklist: WorklistDefinition = {
	worklist: 'reception-board',
	columns: [
		{ key: 'token', visible: true, position: 0, width: 80 },
		{ key: 'patient', visible: true, position: 1, width: null },
		{ key: 'status', visible: true, position: 2, width: 160 },
		{ key: 'priority', visible: true, position: 3, width: 120 },
		{ key: 'scheduled', visible: true, position: 4, width: 100 },
		{ key: 'waited', visible: true, position: 5, width: 100 },
		{ key: 'estimate', visible: true, position: 6, width: 120 },
		{ key: 'arrival', visible: false, position: 7, width: 120 }
	],
	mandatoryColumns: ['token', 'patient', 'priority']
};
