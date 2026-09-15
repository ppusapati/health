/**
 * Billing protobuf messages to the desk's models.
 *
 * The one thing this layer must not do is turn money into a number. The wire
 * carries int64 minor units, which arrive as a bigint; everything above keeps
 * them as a bigint, and there is no point in this file where an amount becomes
 * a float.
 */
import { timestampDate } from '@bufbuild/protobuf/wkt';
import type { Timestamp } from '@bufbuild/protobuf/wkt';
import {
	ChargeStatus as WireChargeStatus,
	EntryKind as WireEntryKind,
	InvoiceStatus as WireInvoiceStatus,
	PaymentMethod as WirePaymentMethod,
	type Charge as WireCharge,
	type CloseException as WireCloseException,
	type Invoice as WireInvoice,
	type LedgerEntry as WireLedgerEntry,
	type Money as WireMoney
} from '$gen/healthcare/billing/v1/billing_pb.js';
import {
	presentCharge,
	presentEntry,
	presentInvoice,
	type ChargeStatus,
	type CloseException,
	type EntryKind,
	type InvoiceStatus,
	type PaymentMethod,
	type PresentedCharge,
	type PresentedEntry,
	type PresentedInvoice
} from './account.js';
import type { Money } from './money.js';

function toDate(timestamp: Timestamp | undefined): Date | null {
	return timestamp ? timestampDate(timestamp) : null;
}

/**
 * An amount off the wire.
 *
 * A missing Money message becomes zero *in the account's currency*, supplied by
 * the caller — never an empty currency string, which would then refuse to sum
 * with everything else and turn a blank field into a screen-wide failure.
 */
export function toMoney(amount: WireMoney | undefined, fallbackCurrency: string): Money {
	if (!amount) {
		return { minor: 0n, currency: fallbackCurrency.toUpperCase() };
	}
	return {
		minor: amount.minor,
		currency: (amount.currency || fallbackCurrency).toUpperCase()
	};
}

/** The wire shape for an amount, for building a request. */
export function fromMoney(amount: Money): { minor: bigint; currency: string } {
	return { minor: amount.minor, currency: amount.currency };
}

const entryKinds: Record<WireEntryKind, EntryKind> = {
	[WireEntryKind.UNSPECIFIED]: 'unspecified',
	[WireEntryKind.INVOICE]: 'invoice',
	[WireEntryKind.PAYMENT]: 'payment',
	[WireEntryKind.REFUND]: 'refund',
	[WireEntryKind.DEPOSIT]: 'deposit',
	[WireEntryKind.DEPOSIT_APPLIED]: 'deposit_applied',
	[WireEntryKind.WRITE_OFF]: 'write_off',
	[WireEntryKind.ADJUSTMENT]: 'adjustment'
};

const invoiceStatuses: Record<WireInvoiceStatus, InvoiceStatus> = {
	[WireInvoiceStatus.UNSPECIFIED]: 'unspecified',
	[WireInvoiceStatus.DRAFT]: 'draft',
	[WireInvoiceStatus.ISSUED]: 'issued',
	[WireInvoiceStatus.SUPERSEDED]: 'superseded',
	[WireInvoiceStatus.CANCELLED]: 'cancelled'
};

const chargeStatuses: Record<WireChargeStatus, ChargeStatus> = {
	[WireChargeStatus.UNSPECIFIED]: 'unspecified',
	[WireChargeStatus.POSTED]: 'posted',
	[WireChargeStatus.INVOICED]: 'invoiced',
	[WireChargeStatus.VOIDED]: 'voided',
	[WireChargeStatus.HELD]: 'held'
};

const methods: Record<WirePaymentMethod, PaymentMethod> = {
	[WirePaymentMethod.UNSPECIFIED]: 'unspecified',
	[WirePaymentMethod.CASH]: 'cash',
	[WirePaymentMethod.CARD]: 'card',
	[WirePaymentMethod.UPI]: 'upi',
	[WirePaymentMethod.BANK_TRANSFER]: 'bank_transfer',
	[WirePaymentMethod.CHEQUE]: 'cheque',
	[WirePaymentMethod.PAYER_SETTLEMENT]: 'payer_settlement'
};

/** The wire enum for a payment method, for building a request. */
export const wireMethods: Record<PaymentMethod, WirePaymentMethod> = {
	unspecified: WirePaymentMethod.UNSPECIFIED,
	cash: WirePaymentMethod.CASH,
	card: WirePaymentMethod.CARD,
	upi: WirePaymentMethod.UPI,
	bank_transfer: WirePaymentMethod.BANK_TRANSFER,
	cheque: WirePaymentMethod.CHEQUE,
	payer_settlement: WirePaymentMethod.PAYER_SETTLEMENT
};

/** Adapts a wire LedgerEntry. */
export function toPresentedEntry(entry: WireLedgerEntry, currency: string): PresentedEntry {
	return presentEntry({
		entryId: entry.entryId,
		kind: entryKinds[entry.kind] ?? 'unspecified',
		amount: toMoney(entry.amount, currency),
		receiptNumber: entry.receiptNumber,
		method: methods[entry.method] ?? 'unspecified',
		reason: entry.reason,
		occurredAt: toDate(entry.occurredAt) ?? new Date(0),
		recordedBy: entry.recordedBy
	});
}

/** Adapts a wire Invoice. */
export function toPresentedInvoice(invoice: WireInvoice, currency: string): PresentedInvoice {
	return presentInvoice({
		invoiceId: invoice.invoiceId,
		number: invoice.number || invoice.invoiceId.slice(0, 8),
		status: invoiceStatuses[invoice.status] ?? 'unspecified',
		total: toMoney(invoice.total, currency),
		issuedAt: toDate(invoice.issuedAt),
		supersededBy: invoice.supersededBy,
		correctsInvoiceId: invoice.correctsInvoiceId,
		lineCount: invoice.lines.length
	});
}

/** Adapts a wire Charge. */
export function toPresentedCharge(charge: WireCharge, currency: string): PresentedCharge {
	return presentCharge({
		chargeId: charge.chargeId,
		description: charge.description || charge.serviceCode || 'Charge',
		department: charge.department,
		quantity: charge.quantity,
		total: toMoney(charge.total, currency),
		status: chargeStatuses[charge.status] ?? 'unspecified',
		covered: charge.covered,
		coverageNote: charge.coverageNote,
		occurredAt: toDate(charge.occurredAt) ?? toDate(charge.postedAt) ?? new Date(0)
	});
}

/** Adapts a wire CloseException. */
export function toCloseException(
	exception: WireCloseException,
	currency: string
): CloseException {
	return {
		check: exception.check,
		detail: exception.detail,
		// Only when the server actually sent one. A zero rendered beside "two
		// services are not yet invoiced" reads as "nothing outstanding", which
		// is the opposite of what the exception says.
		amount: exception.amount ? toMoney(exception.amount, currency) : null,
		references: exception.references
	};
}
