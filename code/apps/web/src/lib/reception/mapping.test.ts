import { describe, expect, it } from 'vitest';
import { create } from '@bufbuild/protobuf';
import { timestampFromDate } from '@bufbuild/protobuf/wkt';
import {
	DatePrecision,
	IdentifierType,
	MatchOutcome,
	PatientSchema,
	PatientMatchSchema,
	PatientStatus,
	Sex
} from '$gen/healthcare/empi/v1/patient_pb.js';
import {
	AppointmentSchema,
	AppointmentStatus,
	ArrivalMode,
	Priority,
	QueuePositionSchema
} from '$gen/healthcare/scheduling/v1/appointment_pb.js';
import {
	toBoardAppointment,
	toBoardPosition,
	toPatientLike,
	toPresentedMatch
} from './mapping.js';
import { bannerFor } from '../patient/banner.js';

const now = new Date('2026-09-14T10:00:00Z');

describe('a patient off the wire', () => {
	it('carries its name, identifiers and birth-date precision through', () => {
		const patient = create(PatientSchema, {
			patientId: 'pat-1',
			status: PatientStatus.ACTIVE,
			demographics: {
				name: { family: 'Iyer', given: ['Meera'] },
				sex: Sex.FEMALE,
				birthDate: {
					date: timestampFromDate(new Date('1986-01-01T00:00:00Z')),
					precision: DatePrecision.YEAR
				}
			},
			identifiers: [
				{ type: IdentifierType.MRN, value: 'MRN-000123', primary: true },
				{ type: IdentifierType.NATIONAL_HEALTH, value: '11-2222', primary: false }
			]
		});

		const banner = bannerFor(toPatientLike(patient), now);
		expect(banner.displayName).toBe('Meera Iyer');
		// The precision survives the crossing. Losing it here would produce a
		// precise age from a year-only date, which is the claim the banner
		// exists not to make.
		expect(banner.age).toBe('about 40y');
		expect(banner.identifiers.map((i) => i.label)).toEqual(['MRN', 'National health ID']);
	});

	it('produces no birth date rather than the epoch when none was sent', () => {
		const patient = create(PatientSchema, {
			patientId: 'pat-1',
			status: PatientStatus.ACTIVE,
			demographics: { name: { family: 'Iyer', given: ['Meera'] } }
		});
		expect(toPatientLike(patient).birthDate).toBeNull();
		expect(bannerFor(toPatientLike(patient), now).age).toBe('age unknown');
	});

	it('translates a merged record into the alert that names the survivor', () => {
		const patient = create(PatientSchema, {
			patientId: 'pat-1',
			status: PatientStatus.MERGED,
			mergedIntoPatientId: 'pat-2'
		});
		const banner = bannerFor(toPatientLike(patient), now);
		expect(banner.readOnly).toBe(true);
		expect(banner.alerts[0].text).toContain('pat-2');
	});
});

describe('a match off the wire', () => {
	it('keeps the outcome, the mask and the former name', () => {
		const match = create(PatientMatchSchema, {
			patient: {
				patientId: 'pat-9',
				demographics: { name: { family: 'Iyer', given: ['Meera'] } }
			},
			confidence: 0.91,
			outcome: MatchOutcome.REVIEW,
			masked: true,
			matchedFormerName: { name: { family: 'Raman', given: ['Meera'] } }
		});

		const presented = toPresentedMatch(match);
		expect(presented.patientId).toBe('pat-9');
		expect(presented.outcome).toBe('review');
		expect(presented.blocksRegistration).toBe(true);
		expect(presented.masked).toBe(true);
		expect(presented.matchedFormerName).toBe('Meera Raman');
		expect(presented.confidencePercent).toBe(91);
	});
});

describe('an appointment off the wire', () => {
	it('translates every status rather than defaulting', () => {
		// A default that picks a sensible-looking value is how a new server enum
		// arrives in the browser as something it is not.
		const expected: Record<number, string> = {
			[AppointmentStatus.SCHEDULED]: 'scheduled',
			[AppointmentStatus.ARRIVED]: 'arrived',
			[AppointmentStatus.TRIAGED]: 'triaged',
			[AppointmentStatus.WAITING_CLINICIAN]: 'waiting_clinician',
			[AppointmentStatus.IN_CONSULTATION]: 'in_consultation',
			[AppointmentStatus.POST_CONSULTATION]: 'post_consultation',
			[AppointmentStatus.COMPLETED]: 'completed',
			[AppointmentStatus.NO_SHOW]: 'no_show',
			[AppointmentStatus.CANCELLED]: 'cancelled'
		};
		for (const [wire, want] of Object.entries(expected)) {
			const appointment = create(AppointmentSchema, { status: Number(wire) });
			expect(toBoardAppointment(appointment).status).toBe(want);
		}
	});

	it('reads an unset priority as standard, never as immediate', () => {
		// A board that promotes every unset priority to the top makes the real
		// ones invisible.
		const appointment = create(AppointmentSchema, { priority: Priority.UNSPECIFIED });
		expect(toBoardAppointment(appointment).priority).toBe('standard');
	});

	it('keeps the version so a row that moved can be spotted between refreshes', () => {
		const appointment = create(AppointmentSchema, { version: 7n });
		expect(toBoardAppointment(appointment).version).toBe(7n);
	});

	it('keeps a walk-in distinguishable from a booked arrival', () => {
		const appointment = create(AppointmentSchema, { arrivalMode: ArrivalMode.WALK_IN });
		expect(toBoardAppointment(appointment).arrivalMode).toBe('walk_in');
	});

	it('leaves an absent check-in time absent', () => {
		const appointment = create(AppointmentSchema, {});
		expect(toBoardAppointment(appointment).checkedInAt).toBeNull();
	});
});

describe('a queue position off the wire', () => {
	it('drops one with no appointment rather than rendering a blank row', () => {
		// A blank row reads as a patient whose details failed to load, which is
		// a different thing from a malformed response.
		expect(toBoardPosition(create(QueuePositionSchema, { position: 3 }))).toBeNull();
	});

	it('carries the position and the estimate', () => {
		const position = create(QueuePositionSchema, {
			appointment: { appointmentId: 'apt-1' },
			position: 3,
			estimatedWaitSeconds: 900n
		});
		const mapped = toBoardPosition(position);
		expect(mapped?.position).toBe(3);
		expect(mapped?.estimatedWaitSeconds).toBe(900);
	});
});
