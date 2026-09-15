import { describe, expect, it } from 'vitest';
import { create } from '@bufbuild/protobuf';
import { timestampFromDate } from '@bufbuild/protobuf/wkt';
import {
	EntrySource,
	FlowsheetEntrySchema,
	NursingTaskSchema,
	RiskAssessmentSchema,
	RiskDomain,
	TaskPriority,
	TaskStatus
} from '$gen/healthcare/nursing/v1/nursing_pb.js';
import { toPresentedEntry, toPresentedRisk, toPresentedTask } from './mapping.js';

const now = new Date('2026-09-15T14:00:00Z');

describe('a task off the wire', () => {
	it('translates every priority and status', () => {
		for (const [wire, want] of Object.entries({
			[TaskPriority.ROUTINE]: 'routine',
			[TaskPriority.URGENT]: 'urgent',
			[TaskPriority.CRITICAL]: 'critical'
		})) {
			const task = create(NursingTaskSchema, { priority: Number(wire) });
			expect(toPresentedTask(task, now).priority).toBe(want);
		}
		for (const [wire, want] of Object.entries({
			[TaskStatus.PENDING]: 'pending',
			[TaskStatus.DONE]: 'done',
			[TaskStatus.NOT_DONE]: 'not_done',
			[TaskStatus.CANCELLED]: 'cancelled'
		})) {
			const task = create(NursingTaskSchema, { status: Number(wire) });
			expect(toPresentedTask(task, now).status).toBe(want);
		}
	});

	it('keeps not-done distinct from cancelled', () => {
		// Not-done records that somebody decided against it and why, which is
		// the fact an incident review needs; cancelled says the work went away.
		const refused = create(NursingTaskSchema, {
			status: TaskStatus.NOT_DONE,
			notDoneReason: 'patient asleep, reviewed with nurse in charge'
		});
		expect(toPresentedTask(refused, now).status).toBe('not_done');
		expect(toPresentedTask(refused, now).open).toBe(false);
	});

	it('passes the server’s overdue verdict through untouched', () => {
		const notOverdue = create(NursingTaskSchema, {
			dueAt: timestampFromDate(new Date('2026-09-15T10:00:00Z')),
			overdue: false
		});
		expect(toPresentedTask(notOverdue, now).overdue).toBe(false);
	});
});

describe('a flowsheet entry off the wire', () => {
	it('treats a measured zero as a value', () => {
		const zero = create(FlowsheetEntrySchema, {
			code: { display: 'Net fluid balance' },
			value: { value: 0, unit: 'mL' },
			observedAt: timestampFromDate(now),
			recordedAt: timestampFromDate(now)
		});
		expect(toPresentedEntry(zero).value).toBe('0 mL');
	});

	it('carries the late flag, the reason and both times', () => {
		const late = create(FlowsheetEntrySchema, {
			code: { display: 'Systolic blood pressure' },
			value: { value: 96, unit: 'mmHg' },
			observedAt: timestampFromDate(new Date('2026-09-15T11:30:00Z')),
			recordedAt: timestampFromDate(new Date('2026-09-15T14:00:00Z')),
			late: true,
			lateEntryReason: 'monitor disconnected during transfer',
			source: EntrySource.MANUAL
		});
		const presented = toPresentedEntry(late);
		expect(presented.late).toBe(true);
		expect(presented.lateByMinutes).toBe(150);
		expect(presented.lateReason).toMatch(/monitor/);
	});

	it('names the observation rather than rendering a blank row', () => {
		const bare = create(FlowsheetEntrySchema, {});
		expect(toPresentedEntry(bare).display).toBe('Observation');
	});
});

describe('a risk assessment off the wire', () => {
	it('names every domain', () => {
		for (const [wire, want] of Object.entries({
			[RiskDomain.FALLS]: 'Falls',
			[RiskDomain.PRESSURE_INJURY]: 'Pressure injury',
			[RiskDomain.PAIN]: 'Pain',
			[RiskDomain.NUTRITION]: 'Nutrition',
			[RiskDomain.DETERIORATION]: 'Deterioration'
		})) {
			const risk = create(RiskAssessmentSchema, { domain: Number(wire) });
			expect(toPresentedRisk(risk, now).domain).toBe(want);
		}
	});

	it('does not derive the band or the escalation from the score', () => {
		// The scale owns both (SRS-NUR-005). A high total with no escalation
		// flag must stay un-escalated on screen.
		const risk = create(RiskAssessmentSchema, {
			total: 95,
			band: 'Low risk',
			escalate: false,
			scaleVersion: 'local-v4'
		});
		const presented = toPresentedRisk(risk, now);
		expect(presented.band).toBe('Low risk');
		expect(presented.escalate).toBe(false);
	});
});
