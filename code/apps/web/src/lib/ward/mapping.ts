/**
 * Nursing protobuf messages to the models the ward screen uses.
 *
 * Same discipline as the other mapping layers: every enum exhaustively, no
 * `default:`.
 */
import { timestampDate } from '@bufbuild/protobuf/wkt';
import type { Timestamp } from '@bufbuild/protobuf/wkt';
import {
	EntrySource as WireEntrySource,
	RiskDomain as WireRiskDomain,
	TaskPriority as WireTaskPriority,
	TaskStatus as WireTaskStatus,
	type FlowsheetEntry as WireEntry,
	type NursingTask as WireTask,
	type RiskAssessment as WireRisk
} from '$gen/healthcare/nursing/v1/nursing_pb.js';
import {
	presentEntry,
	presentRisk,
	presentTask,
	type EntrySource,
	type PresentedEntry,
	type PresentedRisk,
	type PresentedTask,
	type TaskPriority,
	type TaskStatus
} from './worklist.js';

function toDate(timestamp: Timestamp | undefined): Date | null {
	return timestamp ? timestampDate(timestamp) : null;
}

const priorities: Record<WireTaskPriority, TaskPriority> = {
	[WireTaskPriority.UNSPECIFIED]: 'unspecified',
	[WireTaskPriority.ROUTINE]: 'routine',
	[WireTaskPriority.URGENT]: 'urgent',
	[WireTaskPriority.CRITICAL]: 'critical'
};

const statuses: Record<WireTaskStatus, TaskStatus> = {
	[WireTaskStatus.UNSPECIFIED]: 'unspecified',
	[WireTaskStatus.PENDING]: 'pending',
	[WireTaskStatus.DONE]: 'done',
	// Not the same as cancelled: not-done records that somebody decided against
	// it and why, which is the fact an incident review needs.
	[WireTaskStatus.NOT_DONE]: 'not_done',
	[WireTaskStatus.CANCELLED]: 'cancelled'
};

const sources: Record<WireEntrySource, EntrySource> = {
	[WireEntrySource.UNSPECIFIED]: 'unspecified',
	[WireEntrySource.MANUAL]: 'manual',
	[WireEntrySource.DEVICE]: 'device',
	[WireEntrySource.PAPER]: 'paper',
	[WireEntrySource.PATIENT]: 'patient'
};

const riskDomains: Record<WireRiskDomain, string> = {
	[WireRiskDomain.UNSPECIFIED]: 'Risk',
	[WireRiskDomain.FALLS]: 'Falls',
	[WireRiskDomain.PRESSURE_INJURY]: 'Pressure injury',
	[WireRiskDomain.PAIN]: 'Pain',
	[WireRiskDomain.NUTRITION]: 'Nutrition',
	[WireRiskDomain.DETERIORATION]: 'Deterioration'
};

/** Adapts a wire NursingTask for the worklist. */
export function toPresentedTask(task: WireTask, now: Date): PresentedTask {
	return presentTask(
		{
			taskId: task.taskId,
			patientId: task.patientId,
			description: task.description,
			priority: priorities[task.priority] ?? 'unspecified',
			status: statuses[task.status] ?? 'unspecified',
			dueAt: toDate(task.dueAt),
			// Straight through. See presentTask: recomputing it against the
			// browser's clock would put the screen at odds with the escalation
			// the server actually performed.
			overdue: task.overdue,
			escalatedTo: task.escalatedTo,
			sourceKind: task.sourceKind,
			version: task.version
		},
		now
	);
}

/** Adapts a wire FlowsheetEntry. */
export function toPresentedEntry(entry: WireEntry): PresentedEntry {
	return presentEntry({
		entryId: entry.entryId,
		display: entry.code?.display || entry.code?.code || 'Observation',
		// Presence of the quantity decides, not truthiness: a fluid balance of
		// zero is a real measurement.
		value: entry.value ? entry.value.value : null,
		unit: entry.value?.unit ?? '',
		textValue: entry.textValue || entry.codedValue?.display || '',
		observedAt: toDate(entry.observedAt) ?? new Date(0),
		recordedAt: toDate(entry.recordedAt) ?? new Date(0),
		late: entry.late,
		lateReason: entry.lateEntryReason,
		source: sources[entry.source] ?? 'unspecified',
		recordedBy: entry.recordedBy
	});
}

/** Adapts a wire RiskAssessment. */
export function toPresentedRisk(risk: WireRisk, now: Date): PresentedRisk {
	return presentRisk(
		{
			riskId: risk.riskId,
			patientId: risk.patientId,
			domain: riskDomains[risk.domain] ?? 'Risk',
			scaleVersion: risk.scaleVersion,
			total: risk.total,
			band: risk.band,
			escalate: risk.escalate,
			assessedAt: toDate(risk.assessedAt) ?? new Date(0),
			dueAt: toDate(risk.dueAt)
		},
		now
	);
}
