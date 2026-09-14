import { describe, expect, it } from 'vitest';
import {
	STALE_AFTER_SECONDS,
	buildBoard,
	receptionWorklist,
	type BoardAppointment,
	type BoardPosition
} from './board.js';
import { applyPreferences, validateView, InvalidViewError } from '../prefs/views.js';

const now = new Date('2026-09-14T10:00:00Z');

function appointment(overrides: Partial<BoardAppointment> = {}): BoardAppointment {
	return {
		appointmentId: 'apt-1',
		patientId: 'pat-1',
		token: 'A-001',
		status: 'scheduled',
		priority: 'standard',
		priorityReason: '',
		arrivalMode: 'scheduled',
		startsAt: new Date('2026-09-14T10:30:00Z'),
		checkedInAt: null,
		version: 1n,
		...overrides
	};
}

function position(a: BoardAppointment, p: number, waitSeconds = 0): BoardPosition {
	return { appointment: a, position: p, estimatedWaitSeconds: waitSeconds };
}

function board(params: {
	positions?: readonly BoardPosition[];
	expected?: readonly BoardAppointment[];
	fetchedAt?: Date;
}) {
	return buildBoard({
		positions: params.positions ?? [],
		expected: params.expected ?? [],
		serviceMinutes: 12,
		estimateObserved: true,
		activeClinicians: 2,
		fetchedAt: params.fetchedAt ?? now,
		now
	});
}

describe('what the board shows', () => {
	it('includes people who have not arrived yet', () => {
		// Built from the queue alone, the board is empty at nine in the morning
		// — which is exactly when a receptionist needs to see who is coming.
		const b = board({ expected: [appointment()] });
		expect(b.rows).toHaveLength(1);
		expect(b.rows[0].position).toBeNull();
		expect(b.rows[0].canCheckIn).toBe(true);
	});

	it('drops appointments reception has nothing left to do about', () => {
		const b = board({
			expected: [
				appointment({ appointmentId: 'a', status: 'completed' }),
				appointment({ appointmentId: 'b', status: 'cancelled' }),
				appointment({ appointmentId: 'c', status: 'no_show' }),
				appointment({ appointmentId: 'd', status: 'scheduled' })
			]
		});
		expect(b.rows.map((r) => r.appointmentId)).toEqual(['d']);
	});

	it('does not list a queued patient twice', () => {
		// The appointment list and the queue overlap: somebody who arrived is in
		// both, and a naive concatenation shows them on two rows with different
		// numbers.
		const arrived = appointment({ status: 'arrived', checkedInAt: now });
		const b = board({ positions: [position(arrived, 1)], expected: [arrived] });
		expect(b.rows).toHaveLength(1);
		expect(b.rows[0].position).toBe(1);
	});

	it('offers check-in only for someone expected', () => {
		const arrived = appointment({ status: 'arrived', checkedInAt: now });
		const b = board({ positions: [position(arrived, 1)] });
		expect(b.rows[0].canCheckIn).toBe(false);
	});
});

describe('waiting time', () => {
	it('is measured from arrival, not from the appointment', () => {
		// A patient who arrived an hour early has not been waiting an hour, and
		// one whose nine o'clock appointment started at ten has been waiting
		// since ten. Measured from the scheduled time, the board sorts the wrong
		// people to the top.
		const early = appointment({
			startsAt: new Date('2026-09-14T11:00:00Z'),
			checkedInAt: new Date('2026-09-14T09:50:00Z'),
			status: 'arrived'
		});
		const b = board({ positions: [position(early, 1)] });
		expect(b.rows[0].waitedMinutes).toBe(10);
	});

	it('is absent for someone who has not arrived', () => {
		const b = board({ expected: [appointment()] });
		expect(b.rows[0].waitedMinutes).toBeNull();
	});

	it('reports the server estimate in minutes and nothing when there is none', () => {
		const arrived = appointment({ status: 'arrived', checkedInAt: now });
		expect(board({ positions: [position(arrived, 1, 900)] }).rows[0].estimatedWaitMinutes).toBe(
			15
		);
		expect(board({ positions: [position(arrived, 1, 0)] }).rows[0].estimatedWaitMinutes).toBeNull();
	});
});

describe('ordering', () => {
	it('puts people who are here above people who are not', () => {
		const waiting = appointment({
			appointmentId: 'here',
			status: 'arrived',
			checkedInAt: now,
			startsAt: new Date('2026-09-14T14:00:00Z')
		});
		const soon = appointment({
			appointmentId: 'later',
			startsAt: new Date('2026-09-14T10:05:00Z')
		});
		const b = board({ positions: [position(waiting, 1)], expected: [soon] });
		expect(b.rows.map((r) => r.appointmentId)).toEqual(['here', 'later']);
	});

	it('sorts present patients by clinical priority before queue position', () => {
		// A reprioritisation that does not move the row up the screen has not
		// done anything (SRS-SCH-011).
		const routine = appointment({ appointmentId: 'routine', status: 'arrived', checkedInAt: now });
		const urgent = appointment({
			appointmentId: 'urgent',
			status: 'arrived',
			checkedInAt: now,
			priority: 'very_urgent',
			priorityReason: 'chest pain at the desk'
		});
		const b = board({ positions: [position(routine, 1), position(urgent, 7)] });
		expect(b.rows.map((r) => r.appointmentId)).toEqual(['urgent', 'routine']);
		expect(b.rows[0].priorityReason).toBe('chest pain at the desk');
	});

	it('keeps expected patients in the order they will arrive', () => {
		const b = board({
			expected: [
				appointment({ appointmentId: 'noon', startsAt: new Date('2026-09-14T12:00:00Z') }),
				appointment({ appointmentId: 'ten', startsAt: new Date('2026-09-14T10:10:00Z') })
			]
		});
		expect(b.rows.map((r) => r.appointmentId)).toEqual(['ten', 'noon']);
	});
});

describe('the snapshot', () => {
	it('is called stale once the numbers can no longer be quoted', () => {
		// One patient called through shifts every position below them, so a
		// board read as current after half a minute tells a patient something
		// untrue.
		const fresh = board({ fetchedAt: new Date(now.getTime() - 5_000) });
		expect(fresh.stale).toBe(false);

		const old = board({
			fetchedAt: new Date(now.getTime() - (STALE_AFTER_SECONDS + 1) * 1000)
		});
		expect(old.stale).toBe(true);
		expect(old.ageSeconds).toBe(STALE_AFTER_SECONDS + 1);
	});

	it('reports whether the estimate was observed or configured', () => {
		// A configured default shown as though it were measured is a wait time a
		// receptionist will quote to a waiting room.
		const b = buildBoard({
			positions: [],
			expected: [],
			serviceMinutes: 15,
			estimateObserved: false,
			activeClinicians: 0,
			fetchedAt: now,
			now
		});
		expect(b.estimateObserved).toBe(false);
		expect(b.serviceMinutes).toBe(15);
	});
});

describe('counts and empty state', () => {
	it('counts only those still waiting on reception, not those with a clinician', () => {
		const waiting = appointment({ appointmentId: 'w', status: 'arrived', checkedInAt: now });
		const seen = appointment({
			appointmentId: 's',
			status: 'in_consultation',
			checkedInAt: now
		});
		const b = board({ positions: [position(waiting, 1), position(seen, 2)] });
		expect(b.waiting).toBe(1);
		expect(b.rows.find((r) => r.appointmentId === 's')?.withClinician).toBe(true);
	});

	it('is empty when there is nothing to do', () => {
		expect(board({}).empty).toBe(true);
	});
});

describe('the worklist definition', () => {
	it('refuses to hide the columns the desk cannot work without', () => {
		// Hiding the token makes it impossible to call the next patient; hiding
		// the priority hides why somebody was moved up, which SRS-SCH-011
		// requires to stay visible.
		for (const key of receptionWorklist.mandatoryColumns) {
			expect(() =>
				validateView(receptionWorklist, {
					id: 'v1',
					name: 'Mine',
					worklist: 'reception-board',
					columns: receptionWorklist.columns.map((c) =>
						c.key === key ? { ...c, visible: false } : c
					),
					filters: {},
					sortKey: null,
					sortDescending: false
				})
			).toThrow(InvalidViewError);
		}
	});

	it('applies cleanly with no saved view', () => {
		const columns = applyPreferences(receptionWorklist, null);
		expect(columns.map((c) => c.key)[0]).toBe('token');
	});
});
