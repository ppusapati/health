import { describe, expect, it } from 'vitest';
import { create } from '@bufbuild/protobuf';
import { timestampFromDate } from '@bufbuild/protobuf/wkt';
import {
	OrderSchema,
	OrderStatus,
	OrderType,
	Priority
} from '$gen/healthcare/orders/v1/orders_pb.js';
import {
	CriticalResultSchema,
	Interpretation
} from '$gen/healthcare/clinical/v1/clinical_pb.js';
import {
	toDuplicateCandidate,
	toInboxItem,
	toPresentedOrder,
	wireOrderTypes,
	wirePriorities
} from './mapping.js';

const now = new Date('2026-09-15T10:00:00Z');

describe('an order off the wire', () => {
	it('translates every type and status', () => {
		for (const [wire, want] of Object.entries({
			[OrderType.LABORATORY]: 'laboratory',
			[OrderType.IMAGING]: 'imaging',
			[OrderType.MEDICATION]: 'medication',
			[OrderType.PROCEDURE]: 'procedure',
			[OrderType.DIET]: 'diet',
			[OrderType.NURSING]: 'nursing',
			[OrderType.BLOOD_PRODUCT]: 'blood_product',
			[OrderType.REFERRAL]: 'referral',
			[OrderType.ALLIED_HEALTH]: 'allied_health'
		})) {
			expect(toPresentedOrder(create(OrderSchema, { type: Number(wire) })).type).toBe(want);
		}
		for (const [wire, want] of Object.entries({
			[OrderStatus.DRAFT]: 'draft',
			[OrderStatus.REQUESTED]: 'requested',
			[OrderStatus.ACCEPTED]: 'accepted',
			[OrderStatus.SCHEDULED]: 'scheduled',
			[OrderStatus.IN_PROGRESS]: 'in_progress',
			[OrderStatus.COMPLETED]: 'completed',
			[OrderStatus.CANCELLED]: 'cancelled',
			[OrderStatus.ENTERED_IN_ERROR]: 'entered_in_error'
		})) {
			expect(toPresentedOrder(create(OrderSchema, { status: Number(wire) })).status).toBe(want);
		}
	});

	it('round-trips a type and a priority back to the wire', () => {
		// The composer builds requests from the same string unions it renders,
		// so the two directions have to agree or an order is placed as a
		// different type from the one on screen.
		for (const [key, wire] of Object.entries(wireOrderTypes)) {
			const order = create(OrderSchema, { type: wire });
			expect(toPresentedOrder(order).type).toBe(key);
		}
		for (const [key, wire] of Object.entries(wirePriorities)) {
			const order = create(OrderSchema, { priority: wire });
			expect(toPresentedOrder(order).priority).toBe(key);
		}
	});

	it('marks which statuses are still somebody’s work', () => {
		expect(toPresentedOrder(create(OrderSchema, { status: OrderStatus.IN_PROGRESS })).live).toBe(
			true
		);
		expect(toPresentedOrder(create(OrderSchema, { status: OrderStatus.COMPLETED })).live).toBe(
			false
		);
		expect(toPresentedOrder(create(OrderSchema, { status: OrderStatus.CANCELLED })).live).toBe(
			false
		);
	});

	it('shows a number a laboratory can quote on the phone', () => {
		expect(toPresentedOrder(create(OrderSchema, { number: 'LAB-0012' })).number).toBe('LAB-0012');
		// Falls back rather than rendering an empty cell.
		const unnumbered = create(OrderSchema, { orderId: 'abcdef0123456789' });
		expect(toPresentedOrder(unnumbered).number).toBe('abcdef01');
	});

	it('carries a recorded duplicate override through', () => {
		// SRS-ORD-009: the override and its reason are part of the record, and
		// a row that hides it makes the repeat look unexplained.
		const overridden = create(OrderSchema, {
			duplicateOverride: {
				againstOrderIds: ['ord-1'],
				reason: 'repeat after insulin-dextrose',
				by: 'dr-1'
			}
		});
		expect(toPresentedOrder(overridden).overrideReason).toMatch(/insulin/);
	});

	it('produces a duplicate candidate from the same order', () => {
		const order = create(OrderSchema, {
			orderId: 'ord-1',
			number: 'LAB-0012',
			code: { display: 'Serum potassium' },
			status: OrderStatus.REQUESTED,
			createdAt: timestampFromDate(new Date('2026-09-15T08:00:00Z'))
		});
		const candidate = toDuplicateCandidate(order);
		expect(candidate.orderId).toBe('ord-1');
		expect(candidate.statusLabel).toBe('Requested');
	});
});

describe('a critical result off the wire', () => {
	it('carries the escalation count and the waiting time', () => {
		const result = create(CriticalResultSchema, {
			observation: {
				observationId: 'obs-1',
				patientId: 'pat-1',
				code: { display: 'Serum potassium' },
				value: { value: 6.8, unit: 'mmol/L' },
				interpretation: Interpretation.CRITICAL_HIGH,
				effectiveAt: timestampFromDate(new Date('2026-09-15T08:30:00Z'))
			},
			dueEscalations: 2
		});
		const item = toInboxItem(result, now);
		expect(item?.dueEscalations).toBe(2);
		expect(item?.waitingMinutes).toBe(90);
		expect(item?.value).toBe('6.8 mmol/L');
	});

	it('drops a result with no observation rather than rendering a blank row', () => {
		expect(toInboxItem(create(CriticalResultSchema, { dueEscalations: 1 }), now)).toBeNull();
	});
});
