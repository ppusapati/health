/**
 * Orders protobuf messages to the composer's models.
 */
import { timestampDate } from '@bufbuild/protobuf/wkt';
import type { Timestamp } from '@bufbuild/protobuf/wkt';
import {
	OrderStatus as WireOrderStatus,
	OrderType as WireOrderType,
	Priority as WirePriority,
	type Order as WireOrder
} from '$gen/healthcare/orders/v1/orders_pb.js';
import type { CriticalResult as WireCriticalResult } from '$gen/healthcare/clinical/v1/clinical_pb.js';
import {
	describeOrderStatus,
	type DuplicateCandidate,
	type InboxItem,
	type OrderPriority,
	type OrderStatus,
	type OrderType
} from './composer.js';
import { toPresentedObservation } from '../chart/mapping.js';

function toDate(timestamp: Timestamp | undefined): Date | null {
	return timestamp ? timestampDate(timestamp) : null;
}

const types: Record<WireOrderType, OrderType> = {
	[WireOrderType.UNSPECIFIED]: 'unspecified',
	[WireOrderType.LABORATORY]: 'laboratory',
	[WireOrderType.IMAGING]: 'imaging',
	[WireOrderType.MEDICATION]: 'medication',
	[WireOrderType.PROCEDURE]: 'procedure',
	[WireOrderType.DIET]: 'diet',
	[WireOrderType.NURSING]: 'nursing',
	[WireOrderType.BLOOD_PRODUCT]: 'blood_product',
	[WireOrderType.REFERRAL]: 'referral',
	[WireOrderType.ALLIED_HEALTH]: 'allied_health'
};

const statuses: Record<WireOrderStatus, OrderStatus> = {
	[WireOrderStatus.UNSPECIFIED]: 'unspecified',
	[WireOrderStatus.DRAFT]: 'draft',
	[WireOrderStatus.REQUESTED]: 'requested',
	[WireOrderStatus.ACCEPTED]: 'accepted',
	[WireOrderStatus.SCHEDULED]: 'scheduled',
	[WireOrderStatus.IN_PROGRESS]: 'in_progress',
	[WireOrderStatus.COMPLETED]: 'completed',
	[WireOrderStatus.CANCELLED]: 'cancelled',
	[WireOrderStatus.ENTERED_IN_ERROR]: 'entered_in_error'
};

const priorities: Record<WirePriority, OrderPriority> = {
	[WirePriority.UNSPECIFIED]: 'unspecified',
	[WirePriority.ROUTINE]: 'routine',
	[WirePriority.URGENT]: 'urgent',
	[WirePriority.STAT]: 'stat',
	[WirePriority.TIMING_CRITICAL]: 'timing_critical'
};

/** The wire enum for an order type, for building a request. */
export const wireOrderTypes: Record<OrderType, WireOrderType> = {
	unspecified: WireOrderType.UNSPECIFIED,
	laboratory: WireOrderType.LABORATORY,
	imaging: WireOrderType.IMAGING,
	medication: WireOrderType.MEDICATION,
	procedure: WireOrderType.PROCEDURE,
	diet: WireOrderType.DIET,
	nursing: WireOrderType.NURSING,
	blood_product: WireOrderType.BLOOD_PRODUCT,
	referral: WireOrderType.REFERRAL,
	allied_health: WireOrderType.ALLIED_HEALTH
};

/** The wire enum for a priority, for building a request. */
export const wirePriorities: Record<OrderPriority, WirePriority> = {
	unspecified: WirePriority.UNSPECIFIED,
	routine: WirePriority.ROUTINE,
	urgent: WirePriority.URGENT,
	stat: WirePriority.STAT,
	timing_critical: WirePriority.TIMING_CRITICAL
};

/** What an order row shows. */
export interface PresentedOrder {
	readonly orderId: string;
	readonly number: string;
	readonly display: string;
	readonly type: OrderType;
	readonly status: OrderStatus;
	readonly statusLabel: string;
	readonly priority: OrderPriority;
	readonly indication: string;
	readonly placedAt: Date;
	readonly requesterId: string;
	/** True while the order can still be acted on downstream. */
	readonly live: boolean;
	/** Set when a duplicate override was recorded against this order. */
	readonly overrideReason: string;
	readonly version: bigint;
}

/** Statuses where the order is still somebody's work. */
const liveStatuses = new Set<OrderStatus>([
	'draft',
	'requested',
	'accepted',
	'scheduled',
	'in_progress'
]);

/** Adapts a wire Order. */
export function toPresentedOrder(order: WireOrder): PresentedOrder {
	const status = statuses[order.status] ?? 'unspecified';
	return {
		orderId: order.orderId,
		// The human-facing number, which is what a laboratory quotes on the
		// phone. Falls back to the id rather than showing nothing.
		number: order.number || order.orderId.slice(0, 8),
		display: order.code?.display || order.code?.code || 'Order',
		type: types[order.type] ?? 'unspecified',
		status,
		statusLabel: describeOrderStatus(status),
		priority: priorities[order.priority] ?? 'unspecified',
		indication: order.indication,
		placedAt: toDate(order.createdAt) ?? new Date(0),
		requesterId: order.requesterId,
		live: liveStatuses.has(status),
		overrideReason: order.duplicateOverride?.reason ?? '',
		version: order.version
	};
}

/** Adapts a wire Order into a duplicate candidate row. */
export function toDuplicateCandidate(order: WireOrder): DuplicateCandidate {
	const presented = toPresentedOrder(order);
	return {
		orderId: presented.orderId,
		number: presented.number,
		display: presented.display,
		status: presented.status,
		statusLabel: presented.statusLabel,
		placedAt: presented.placedAt,
		requesterId: presented.requesterId
	};
}

/** Adapts a wire CriticalResult for the inbox. */
export function toInboxItem(result: WireCriticalResult, now: Date): InboxItem | null {
	const observation = result.observation;
	if (!observation) {
		// Nothing to render or act on. Dropped rather than shown as a blank
		// row, which reads as a result whose details failed to load.
		return null;
	}
	const presented = toPresentedObservation(observation);
	return {
		observationId: presented.observationId,
		patientId: observation.patientId,
		display: presented.display,
		value: presented.value,
		interpretationLabel: presented.interpretationLabel,
		effectiveAt: presented.effectiveAt,
		dueEscalations: result.dueEscalations,
		waitingMinutes: Math.max(
			0,
			Math.floor((now.getTime() - presented.effectiveAt.getTime()) / 60_000)
		)
	};
}
