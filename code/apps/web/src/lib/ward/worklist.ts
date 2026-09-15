/**
 * The nursing worklist and flowsheet (SRS-NUR-003, SRS-NUR-005, SRS-NUR-011,
 * UX-W1-03).
 *
 * A ward screen is read in gaps: between a drug round and a call bell, on a
 * shared terminal, by somebody who has been on shift for nine hours. So the
 * presentation rules here are all about what happens when it is read quickly
 * and wrongly.
 *
 * A late entry is marked late, and carries both times. A nurse charting at
 * 14:00 an observation taken at 11:30 is recording a real measurement, not a
 * current one; a flowsheet that shows only the recorded time turns a
 * three-hour-old blood pressure into a fresh reading. Both times, always, and
 * the row says which is which.
 *
 * An overdue critical task is not "a task with a red chip". Overdue and
 * critical are separate facts, and a routine task that is four hours late and
 * a critical task due in ten minutes are both things the screen has to
 * surface without either hiding the other.
 *
 * Nothing on this screen infers a risk band from a score. The scale defines
 * its bands and the server applies them (SRS-NUR-005); a screen that
 * re-derived "high risk" from a total would be a second scale, and the
 * two would disagree the day somebody edits the first.
 */

/** Mirrors nursing.v1.TaskPriority. */
export type TaskPriority = 'routine' | 'urgent' | 'critical' | 'unspecified';

/** Mirrors nursing.v1.TaskStatus. */
export type TaskStatus = 'pending' | 'done' | 'not_done' | 'cancelled' | 'unspecified';

/** Mirrors nursing.v1.EntrySource. */
export type EntrySource = 'manual' | 'device' | 'paper' | 'patient' | 'unspecified';

/** One task as the worklist shows it. */
export interface PresentedTask {
	readonly taskId: string;
	readonly patientId: string;
	readonly description: string;
	readonly priority: TaskPriority;
	readonly priorityLabel: string;
	readonly status: TaskStatus;
	readonly dueAt: Date | null;
	/** Minutes past due; negative when it is not due yet. Null with no due time. */
	readonly overdueMinutes: number | null;
	/** True when the server says it is overdue. Not recomputed here — see below. */
	readonly overdue: boolean;
	/** True when it has been escalated, with who it went to. */
	readonly escalated: boolean;
	readonly escalatedTo: string;
	/** Where the task came from — a care plan, a protocol, a nurse. */
	readonly source: string;
	/** True when the task still needs doing. */
	readonly open: boolean;
	readonly version: bigint;
}

const priorityLabels: Record<TaskPriority, string> = {
	critical: 'Critical',
	urgent: 'Urgent',
	routine: 'Routine',
	unspecified: 'Not prioritised'
};

const priorityRank: Record<TaskPriority, number> = {
	critical: 0,
	urgent: 1,
	routine: 2,
	unspecified: 3
};

/** Human label for a task priority. */
export function describePriority(priority: TaskPriority): string {
	return priorityLabels[priority];
}

/**
 * Presents one task.
 *
 * `overdue` is taken from the server rather than derived from `dueAt` against
 * the browser's clock. A ward terminal with a clock ten minutes fast would
 * otherwise show work as overdue that is not, and escalate nothing — the
 * escalation is server-side, so the two would disagree and the screen would be
 * the one lying. The minutes are computed locally only to say *how* late.
 */
export function presentTask(
	task: {
		readonly taskId: string;
		readonly patientId: string;
		readonly description: string;
		readonly priority: TaskPriority;
		readonly status: TaskStatus;
		readonly dueAt: Date | null;
		readonly overdue: boolean;
		readonly escalatedTo: string;
		readonly sourceKind: string;
		readonly version: bigint;
	},
	now: Date
): PresentedTask {
	return {
		taskId: task.taskId,
		patientId: task.patientId,
		description: task.description,
		priority: task.priority,
		priorityLabel: priorityLabels[task.priority],
		status: task.status,
		dueAt: task.dueAt,
		overdueMinutes: task.dueAt
			? Math.floor((now.getTime() - task.dueAt.getTime()) / 60_000)
			: null,
		overdue: task.overdue,
		escalated: task.escalatedTo !== '',
		escalatedTo: task.escalatedTo,
		source: task.sourceKind,
		open: task.status === 'pending',
		version: task.version
	};
}

/**
 * Orders the worklist.
 *
 * Open work first, then escalated, then priority, then due time. Escalated
 * above priority on purpose: an escalation means somebody else has already been
 * told this is not being done, and it stays at the top until it is closed
 * rather than sinking back down because it was only routine.
 */
export function orderTasks(tasks: readonly PresentedTask[]): readonly PresentedTask[] {
	return [...tasks].sort((a, b) => {
		if (a.open !== b.open) {
			return a.open ? -1 : 1;
		}
		if (a.open) {
			if (a.escalated !== b.escalated) {
				return a.escalated ? -1 : 1;
			}
			const byPriority = priorityRank[a.priority] - priorityRank[b.priority];
			if (byPriority !== 0) {
				return byPriority;
			}
		}
		const aDue = a.dueAt?.getTime() ?? Number.MAX_SAFE_INTEGER;
		const bDue = b.dueAt?.getTime() ?? Number.MAX_SAFE_INTEGER;
		return aDue - bDue;
	});
}

/** What the worklist header reports. */
export interface WorklistSummary {
	readonly open: number;
	readonly overdue: number;
	/**
	 * Overdue work that is also critical. Counted separately because it is the
	 * number a nurse in charge acts on, and folding it into "overdue" hides it
	 * behind a pile of late routine observations.
	 */
	readonly overdueCritical: number;
	readonly escalated: number;
}

/** Summarises the worklist. */
export function summarise(tasks: readonly PresentedTask[]): WorklistSummary {
	const open = tasks.filter((t) => t.open);
	return {
		open: open.length,
		overdue: open.filter((t) => t.overdue).length,
		overdueCritical: open.filter((t) => t.overdue && t.priority === 'critical').length,
		escalated: open.filter((t) => t.escalated).length
	};
}

/** One flowsheet row. */
export interface PresentedEntry {
	readonly entryId: string;
	readonly display: string;
	readonly value: string;
	readonly unit: string;
	/** When the measurement was taken. */
	readonly observedAt: Date;
	/** When it reached the record. */
	readonly recordedAt: Date;
	/** True when it was charted materially after it was taken. */
	readonly late: boolean;
	/** Minutes between the two, when late. */
	readonly lateByMinutes: number;
	readonly lateReason: string;
	readonly source: EntrySource;
	readonly sourceLabel: string;
	readonly recordedBy: string;
}

const sourceLabels: Record<EntrySource, string> = {
	manual: 'Charted by hand',
	// Worth distinguishing: a monitor reading and a nurse's reading of the same
	// monitor are different evidence, and only one of them was looked at.
	device: 'From a device',
	paper: 'Transcribed from paper',
	patient: 'Reported by the patient',
	unspecified: 'Source not recorded'
};

/** Human label for an entry source. */
export function describeSource(source: EntrySource): string {
	return sourceLabels[source];
}

/** Presents one flowsheet entry. */
export function presentEntry(entry: {
	readonly entryId: string;
	readonly display: string;
	readonly value: number | null;
	readonly unit: string;
	readonly textValue: string;
	readonly observedAt: Date;
	readonly recordedAt: Date;
	readonly late: boolean;
	readonly lateReason: string;
	readonly source: EntrySource;
	readonly recordedBy: string;
}): PresentedEntry {
	return {
		entryId: entry.entryId,
		display: entry.display,
		value:
			entry.value !== null
				? `${entry.value}${entry.unit ? ` ${entry.unit}` : ''}`
				: entry.textValue,
		unit: entry.unit,
		observedAt: entry.observedAt,
		recordedAt: entry.recordedAt,
		late: entry.late,
		lateByMinutes: Math.max(
			0,
			Math.floor((entry.recordedAt.getTime() - entry.observedAt.getTime()) / 60_000)
		),
		lateReason: entry.lateReason,
		source: entry.source,
		sourceLabel: sourceLabels[entry.source],
		recordedBy: entry.recordedBy
	};
}

/**
 * Orders a flowsheet.
 *
 * By when the measurement was taken, not when it was charted. A late entry
 * belongs where the observation happened — putting it at the top because it
 * arrived last is what turns a three-hour-old blood pressure into the latest
 * reading.
 */
export function orderEntries(entries: readonly PresentedEntry[]): readonly PresentedEntry[] {
	return [...entries].sort((a, b) => b.observedAt.getTime() - a.observedAt.getTime());
}

/** Why a chart entry cannot be submitted. */
export interface ChartValidity {
	readonly ready: boolean;
	readonly problems: readonly string[];
}

/**
 * Checks an observation before charting it.
 *
 * The one rule that is not obvious: an observation taken materially in the past
 * needs a reason. SRS-NUR-003 requires a late entry to be identified as late
 * and carry the actual observation time, and the reason is what makes the late
 * entry auditable rather than merely labelled — "the monitor was not connected"
 * and "I forgot until the end of the shift" are different facts about the ward.
 */
export const LATE_ENTRY_AFTER_MINUTES = 15;

/** Validates a chart entry. */
export function validateChartEntry(
	entry: {
		readonly code: string;
		readonly value: string;
		readonly observedAt: Date | null;
		readonly lateReason: string;
	},
	now: Date
): ChartValidity {
	const problems: string[] = [];

	if (entry.code.trim() === '') {
		problems.push('Choose what is being recorded.');
	}
	if (entry.value.trim() === '') {
		problems.push('Enter a value.');
	}
	if (!entry.observedAt) {
		problems.push('Enter the time the observation was taken.');
	} else {
		if (entry.observedAt.getTime() > now.getTime() + 60_000) {
			// A minute of tolerance for a terminal clock that runs fast. Beyond
			// that it is a typing error, and a future observation time makes
			// every trend that includes it wrong.
			problems.push('The observation time is in the future.');
		} else if (isLate(entry.observedAt, now) && entry.lateReason.trim() === '') {
			problems.push(
				'This observation was taken more than ' +
					`${LATE_ENTRY_AFTER_MINUTES} minutes ago. Say why it is being charted now.`
			);
		}
	}

	return { ready: problems.length === 0, problems };
}

/** True when an observation is being charted materially after it was taken. */
export function isLate(observedAt: Date, now: Date): boolean {
	return now.getTime() - observedAt.getTime() > LATE_ENTRY_AFTER_MINUTES * 60_000;
}

/** A risk assessment as the panel shows it. */
export interface PresentedRisk {
	readonly riskId: string;
	readonly patientId: string;
	readonly domain: string;
	readonly scaleVersion: string;
	readonly total: number;
	/** The band the scale assigned. Never derived here. */
	readonly band: string;
	/** True when the scale says this score requires escalation. */
	readonly escalate: boolean;
	readonly assessedAt: Date;
	readonly dueAt: Date | null;
	/** True when the next assessment is due or past due. */
	readonly reassessmentDue: boolean;
}

/**
 * Presents one risk assessment.
 *
 * The band and the escalation flag are passed through untouched. The scale
 * owns them (SRS-NUR-005) and a screen that re-derived either would be a second
 * scale that disagrees with the first the day somebody edits it.
 */
export function presentRisk(
	risk: {
		readonly riskId: string;
		readonly patientId: string;
		readonly domain: string;
		readonly scaleVersion: string;
		readonly total: number;
		readonly band: string;
		readonly escalate: boolean;
		readonly assessedAt: Date;
		readonly dueAt: Date | null;
	},
	now: Date
): PresentedRisk {
	return {
		riskId: risk.riskId,
		patientId: risk.patientId,
		domain: risk.domain,
		scaleVersion: risk.scaleVersion,
		total: risk.total,
		band: risk.band || 'Not banded',
		escalate: risk.escalate,
		assessedAt: risk.assessedAt,
		dueAt: risk.dueAt,
		reassessmentDue: risk.dueAt !== null && risk.dueAt.getTime() <= now.getTime()
	};
}
