import { describe, expect, it } from 'vitest';
import {
	LATE_ENTRY_AFTER_MINUTES,
	describeSource,
	isLate,
	orderEntries,
	orderTasks,
	presentEntry,
	presentRisk,
	presentTask,
	summarise,
	validateChartEntry,
	type EntrySource,
	type TaskPriority
} from './worklist.js';

const now = new Date('2026-09-15T14:00:00Z');

function task(overrides: Partial<Parameters<typeof presentTask>[0]> = {}) {
	return presentTask(
		{
			taskId: 'task-1',
			patientId: 'pat-1',
			description: 'Four-hourly observations',
			priority: 'routine',
			status: 'pending',
			dueAt: new Date('2026-09-15T13:00:00Z'),
			overdue: true,
			escalatedTo: '',
			sourceKind: 'care_plan',
			version: 1n,
			...overrides
		},
		now
	);
}

describe('overdue', () => {
	it('is taken from the server, not recomputed against the browser clock', () => {
		// A ward terminal whose clock is ten minutes fast would otherwise show
		// work as overdue that is not, escalate nothing, and be the thing that
		// is lying — the escalation is server-side.
		const notOverdueYet = task({ dueAt: new Date('2026-09-15T13:00:00Z'), overdue: false });
		expect(notOverdueYet.overdue).toBe(false);
		// The minutes are still computed locally, to say how late.
		expect(notOverdueYet.overdueMinutes).toBe(60);
	});

	it('reports negative minutes for work that is not due yet', () => {
		const later = task({ dueAt: new Date('2026-09-15T15:00:00Z'), overdue: false });
		expect(later.overdueMinutes).toBe(-60);
	});

	it('has no minutes when there is no due time', () => {
		expect(task({ dueAt: null }).overdueMinutes).toBeNull();
	});
});

describe('ordering the worklist', () => {
	it('puts open work above finished work', () => {
		const rows = orderTasks([
			task({ taskId: 'done', status: 'done' }),
			task({ taskId: 'open', status: 'pending' })
		]);
		expect(rows.map((r) => r.taskId)).toEqual(['open', 'done']);
	});

	it('keeps escalated work at the top even when it is only routine', () => {
		// An escalation means somebody else has already been told this is not
		// being done. It stays visible until it is closed rather than sinking
		// back down the list.
		const rows = orderTasks([
			task({ taskId: 'critical', priority: 'critical' }),
			task({ taskId: 'escalated', priority: 'routine', escalatedTo: 'nurse-in-charge' })
		]);
		expect(rows.map((r) => r.taskId)).toEqual(['escalated', 'critical']);
	});

	it('sorts by priority then by due time', () => {
		const rows = orderTasks([
			task({ taskId: 'routine-early', priority: 'routine', dueAt: new Date('2026-09-15T09:00:00Z') }),
			task({ taskId: 'urgent-late', priority: 'urgent', dueAt: new Date('2026-09-15T13:50:00Z') }),
			task({ taskId: 'urgent-early', priority: 'urgent', dueAt: new Date('2026-09-15T12:00:00Z') })
		]);
		expect(rows.map((r) => r.taskId)).toEqual(['urgent-early', 'urgent-late', 'routine-early']);
	});
});

describe('the worklist summary', () => {
	it('counts overdue critical work separately', () => {
		// The number a nurse in charge acts on. Folded into "overdue" it hides
		// behind a pile of late routine observations.
		const summary = summarise([
			task({ taskId: 'a', priority: 'critical', overdue: true }),
			task({ taskId: 'b', priority: 'routine', overdue: true }),
			task({ taskId: 'c', priority: 'routine', overdue: false }),
			task({ taskId: 'd', priority: 'urgent', overdue: true, escalatedTo: 'charge' }),
			task({ taskId: 'e', status: 'done', overdue: true })
		]);
		expect(summary.open).toBe(4);
		expect(summary.overdue).toBe(3);
		expect(summary.overdueCritical).toBe(1);
		expect(summary.escalated).toBe(1);
	});
});

function entry(overrides: Partial<Parameters<typeof presentEntry>[0]> = {}) {
	return presentEntry({
		entryId: 'entry-1',
		display: 'Systolic blood pressure',
		value: 118,
		unit: 'mmHg',
		textValue: '',
		observedAt: new Date('2026-09-15T13:55:00Z'),
		recordedAt: new Date('2026-09-15T13:56:00Z'),
		late: false,
		lateReason: '',
		source: 'manual',
		recordedBy: 'nurse-1',
		...overrides
	});
}

describe('the flowsheet', () => {
	it('carries both times and says how late an entry was', () => {
		// A nurse charting at 14:00 an observation taken at 11:30 is recording
		// a real measurement, not a current one. A flowsheet showing only the
		// recorded time turns a three-hour-old blood pressure into a fresh one.
		const late = entry({
			observedAt: new Date('2026-09-15T11:30:00Z'),
			recordedAt: new Date('2026-09-15T14:00:00Z'),
			late: true,
			lateReason: 'monitor was disconnected during transfer'
		});
		expect(late.late).toBe(true);
		expect(late.lateByMinutes).toBe(150);
		expect(late.observedAt.getUTCHours()).toBe(11);
		expect(late.recordedAt.getUTCHours()).toBe(14);
		expect(late.lateReason).not.toBe('');
	});

	it('orders by when the measurement was taken, not when it was charted', () => {
		const lateOld = entry({
			entryId: 'old',
			observedAt: new Date('2026-09-15T11:30:00Z'),
			recordedAt: new Date('2026-09-15T14:00:00Z'),
			late: true
		});
		const fresh = entry({
			entryId: 'fresh',
			observedAt: new Date('2026-09-15T13:55:00Z'),
			recordedAt: new Date('2026-09-15T13:56:00Z')
		});
		expect(orderEntries([lateOld, fresh]).map((e) => e.entryId)).toEqual(['fresh', 'old']);
	});

	it('distinguishes a device reading from a nurse charting one', () => {
		// Different evidence: only one of them was looked at.
		expect(describeSource('device')).toMatch(/device/i);
		expect(describeSource('manual')).toMatch(/by hand/i);
		for (const source of ['manual', 'device', 'paper', 'patient', 'unspecified'] as EntrySource[]) {
			expect(entry({ source }).sourceLabel).not.toBe('');
		}
	});

	it('falls back to a text value where there is no quantity', () => {
		expect(entry({ value: null, unit: '', textValue: 'Refused' }).value).toBe('Refused');
	});
});

describe('charting an observation', () => {
	const fresh = {
		code: 'BP-SYS',
		value: '118',
		observedAt: new Date('2026-09-15T13:55:00Z'),
		lateReason: ''
	};

	it('accepts a current observation with no reason', () => {
		expect(validateChartEntry(fresh, now).ready).toBe(true);
	});

	it('requires a reason for an observation taken materially earlier', () => {
		// The reason is what makes a late entry auditable rather than merely
		// labelled: "the monitor was not connected" and "I forgot until the end
		// of the shift" are different facts about the ward.
		const late = { ...fresh, observedAt: new Date('2026-09-15T11:30:00Z') };
		const refused = validateChartEntry(late, now);
		expect(refused.ready).toBe(false);
		expect(refused.problems.join(' ')).toMatch(/say why/i);

		const withReason = validateChartEntry({ ...late, lateReason: 'monitor disconnected' }, now);
		expect(withReason.ready).toBe(true);
	});

	it('refuses an observation timed in the future', () => {
		// A typing error, and one that makes every trend including it wrong.
		const future = { ...fresh, observedAt: new Date('2026-09-15T16:00:00Z') };
		expect(validateChartEntry(future, now).ready).toBe(false);
	});

	it('tolerates a terminal clock that runs slightly fast', () => {
		const slightlyAhead = { ...fresh, observedAt: new Date('2026-09-15T14:00:30Z') };
		expect(validateChartEntry(slightlyAhead, now).ready).toBe(true);
	});

	it('refuses an entry with no code or no value', () => {
		expect(validateChartEntry({ ...fresh, code: '' }, now).ready).toBe(false);
		expect(validateChartEntry({ ...fresh, value: '  ' }, now).ready).toBe(false);
	});

	it('agrees with isLate about where the boundary is', () => {
		const justInside = new Date(now.getTime() - (LATE_ENTRY_AFTER_MINUTES - 1) * 60_000);
		const justOutside = new Date(now.getTime() - (LATE_ENTRY_AFTER_MINUTES + 1) * 60_000);
		expect(isLate(justInside, now)).toBe(false);
		expect(isLate(justOutside, now)).toBe(true);
		expect(validateChartEntry({ ...fresh, observedAt: justOutside }, now).ready).toBe(false);
	});
});

describe('risk assessments', () => {
	it('passes the band and the escalation flag through untouched', () => {
		// The scale owns them (SRS-NUR-005). A screen that re-derived either
		// would be a second scale, disagreeing with the first the day somebody
		// edits it.
		const risk = presentRisk(
			{
				riskId: 'risk-1',
				patientId: 'pat-1',
				domain: 'pressure_injury',
				scaleVersion: 'braden-v2',
				total: 12,
				band: 'High risk',
				escalate: true,
				assessedAt: new Date('2026-09-15T08:00:00Z'),
				dueAt: new Date('2026-09-15T20:00:00Z')
			},
			now
		);
		expect(risk.band).toBe('High risk');
		expect(risk.escalate).toBe(true);
		expect(risk.scaleVersion).toBe('braden-v2');
		expect(risk.reassessmentDue).toBe(false);
	});

	it('flags a reassessment that is due', () => {
		const overdue = presentRisk(
			{
				riskId: 'risk-1',
				patientId: 'pat-1',
				domain: 'falls',
				scaleVersion: 'morse-v1',
				total: 45,
				band: '',
				escalate: false,
				assessedAt: new Date('2026-09-15T02:00:00Z'),
				dueAt: new Date('2026-09-15T10:00:00Z')
			},
			now
		);
		expect(overdue.reassessmentDue).toBe(true);
		// An unbanded score says so rather than rendering blank.
		expect(overdue.band).toBe('Not banded');
	});
});
