/**
 * The patient account as the cashier's desk reads it
 * (SRS-BIL-006, SRS-BIL-008, SRS-BIL-010, SRS-BIL-012, SRS-BIL-013, UX-W1-06).
 *
 * Two rules carry this screen.
 *
 * The balance derives from the ledger. SRS-BIL-012 says so, and the reason is
 * that a balance column kept in step by every writer drifts the first time one
 * of them fails between its two writes — with nothing to reconcile against,
 * because the ledger was never the truth. So the screen recomputes the balance
 * from the entries it was given and says so if that disagrees with the server's
 * figure, rather than displaying whichever arrived last.
 *
 * A finalised invoice is never edited. There is no edit control anywhere near
 * one (SRS-BIL-010). The patient is holding a copy, and a system that can
 * quietly change what a document said is a system whose documents prove
 * nothing. A correction is a credit or debit note that references the original,
 * which is what every finance department already does and every auditor expects
 * to find.
 */
import { addMoney, formatMoney, isZero, sumMoney, type Money } from './money.js';

/** Mirrors billing.v1.EntryKind. */
export type EntryKind =
	| 'invoice'
	| 'payment'
	| 'refund'
	| 'deposit'
	| 'deposit_applied'
	| 'write_off'
	| 'adjustment'
	| 'unspecified';

/** Mirrors billing.v1.InvoiceStatus. */
export type InvoiceStatus = 'draft' | 'issued' | 'superseded' | 'cancelled' | 'unspecified';

/** Mirrors billing.v1.ChargeStatus. */
export type ChargeStatus = 'posted' | 'invoiced' | 'voided' | 'held' | 'unspecified';

/** Mirrors billing.v1.PaymentMethod. */
export type PaymentMethod =
	| 'cash'
	| 'card'
	| 'upi'
	| 'bank_transfer'
	| 'cheque'
	| 'payer_settlement'
	| 'unspecified';

/** One ledger entry as the statement shows it. */
export interface PresentedEntry {
	readonly entryId: string;
	readonly kind: EntryKind;
	readonly kindLabel: string;
	readonly amount: Money;
	/** True when the entry increases what the patient owes. */
	readonly increasesDebt: boolean;
	readonly receiptNumber: string;
	readonly method: PaymentMethod;
	readonly methodLabel: string;
	readonly reason: string;
	readonly occurredAt: Date;
	readonly recordedBy: string;
}

const entryLabels: Record<EntryKind, string> = {
	invoice: 'Invoice',
	payment: 'Payment',
	refund: 'Refund',
	deposit: 'Deposit',
	// Distinct from a payment: the money was already held, and applying it is a
	// movement within the account rather than a new receipt.
	deposit_applied: 'Deposit applied',
	write_off: 'Write-off',
	adjustment: 'Adjustment',
	unspecified: 'Entry'
};

const methodLabels: Record<PaymentMethod, string> = {
	cash: 'Cash',
	card: 'Card',
	upi: 'UPI',
	bank_transfer: 'Bank transfer',
	cheque: 'Cheque',
	payer_settlement: 'Payer settlement',
	unspecified: ''
};

/** Human label for a ledger entry kind. */
export function describeEntryKind(kind: EntryKind): string {
	return entryLabels[kind];
}

/** Human label for a payment method. */
export function describeMethod(method: PaymentMethod): string {
	return methodLabels[method];
}

/** Presents one ledger entry. */
export function presentEntry(entry: {
	readonly entryId: string;
	readonly kind: EntryKind;
	readonly amount: Money;
	readonly receiptNumber: string;
	readonly method: PaymentMethod;
	readonly reason: string;
	readonly occurredAt: Date;
	readonly recordedBy: string;
}): PresentedEntry {
	return {
		entryId: entry.entryId,
		kind: entry.kind,
		kindLabel: entryLabels[entry.kind],
		amount: entry.amount,
		// Taken from the sign, not from the kind. The ledger is signed —
		// positive increases what the patient owes — and a screen that decided
		// direction from the kind would disagree with the ledger the first time
		// an adjustment went the other way.
		increasesDebt: entry.amount.minor > 0n,
		receiptNumber: entry.receiptNumber,
		method: entry.method,
		methodLabel: methodLabels[entry.method],
		reason: entry.reason,
		occurredAt: entry.occurredAt,
		recordedBy: entry.recordedBy
	};
}

/** What the statement header shows. */
export interface Statement {
	readonly entries: readonly PresentedEntry[];
	/** The balance this screen computed from the entries above. */
	readonly derivedBalance: Money;
	/** The balance the server reported. */
	readonly reportedBalance: Money;
	/**
	 * True when the two disagree.
	 *
	 * Surfaced rather than resolved. It means either the entry list is
	 * incomplete — a page boundary, most likely — or something is genuinely
	 * wrong; both are things a cashier should see before taking money against
	 * the figure.
	 */
	readonly reconciles: boolean;
	readonly deposits: Money;
}

/**
 * Builds the statement, deriving the balance rather than trusting one column.
 *
 * SRS-BIL-012's acceptance is "balance derives from ledger and reconciles", and
 * the second half is the interesting one: the derivation is only worth anything
 * if a disagreement is visible.
 */
export function buildStatement(params: {
	readonly entries: readonly PresentedEntry[];
	readonly reportedBalance: Money;
	readonly deposits: Money;
	readonly currency: string;
}): Statement {
	const derived = sumMoney(
		params.entries.map((entry) => entry.amount),
		params.currency
	);
	return {
		entries: [...params.entries].sort(
			(a, b) => b.occurredAt.getTime() - a.occurredAt.getTime()
		),
		derivedBalance: derived,
		reportedBalance: params.reportedBalance,
		reconciles: derived.minor === params.reportedBalance.minor,
		deposits: params.deposits
	};
}

/** An invoice as the list shows it. */
export interface PresentedInvoice {
	readonly invoiceId: string;
	readonly number: string;
	readonly status: InvoiceStatus;
	readonly statusLabel: string;
	readonly total: Money;
	readonly issuedAt: Date | null;
	/** Non-empty when a later document replaced this one. */
	readonly supersededBy: string;
	/** Non-empty when this document corrects an earlier one. */
	readonly correctsInvoiceId: string;
	/**
	 * False for anything finalised. There is no edit path on an issued invoice
	 * — a correction is a credit or debit note (SRS-BIL-010).
	 */
	readonly editable: boolean;
	/** True when a correction may be raised against it. */
	readonly correctable: boolean;
	readonly lineCount: number;
}

const invoiceLabels: Record<InvoiceStatus, string> = {
	draft: 'Draft',
	issued: 'Issued',
	// Retained and readable: the patient may be holding the superseded copy.
	superseded: 'Superseded',
	cancelled: 'Cancelled',
	unspecified: 'Unknown'
};

/** Human label for an invoice status. */
export function describeInvoiceStatus(status: InvoiceStatus): string {
	return invoiceLabels[status];
}

/** Presents one invoice. */
export function presentInvoice(invoice: {
	readonly invoiceId: string;
	readonly number: string;
	readonly status: InvoiceStatus;
	readonly total: Money;
	readonly issuedAt: Date | null;
	readonly supersededBy: string;
	readonly correctsInvoiceId: string;
	readonly lineCount: number;
}): PresentedInvoice {
	return {
		invoiceId: invoice.invoiceId,
		number: invoice.number,
		status: invoice.status,
		statusLabel: invoiceLabels[invoice.status],
		total: invoice.total,
		issuedAt: invoice.issuedAt,
		supersededBy: invoice.supersededBy,
		correctsInvoiceId: invoice.correctsInvoiceId,
		editable: invoice.status === 'draft',
		// A superseded or cancelled document is not corrected again; the
		// correction goes against whatever replaced it.
		correctable: invoice.status === 'issued',
		lineCount: invoice.lineCount
	};
}

/** A charge as the worklist shows it. */
export interface PresentedCharge {
	readonly chargeId: string;
	readonly description: string;
	readonly department: string;
	readonly quantity: number;
	readonly total: Money;
	readonly status: ChargeStatus;
	readonly statusLabel: string;
	/** True when the charge is still waiting to be invoiced. */
	readonly unbilled: boolean;
	/** True when a package covered it, so it appears at zero deliberately. */
	readonly covered: boolean;
	readonly coverageNote: string;
	readonly occurredAt: Date;
}

const chargeLabels: Record<ChargeStatus, string> = {
	posted: 'Unbilled',
	invoiced: 'Invoiced',
	// Retained rather than deleted: a voided charge is a service somebody
	// decided not to bill for, and that decision is part of the record.
	voided: 'Voided',
	held: 'On hold',
	unspecified: 'Unknown'
};

/** Human label for a charge status. */
export function describeChargeStatus(status: ChargeStatus): string {
	return chargeLabels[status];
}

/** Presents one charge. */
export function presentCharge(charge: {
	readonly chargeId: string;
	readonly description: string;
	readonly department: string;
	readonly quantity: number;
	readonly total: Money;
	readonly status: ChargeStatus;
	readonly covered: boolean;
	readonly coverageNote: string;
	readonly occurredAt: Date;
}): PresentedCharge {
	return {
		chargeId: charge.chargeId,
		description: charge.description,
		department: charge.department,
		quantity: charge.quantity,
		total: charge.total,
		status: charge.status,
		statusLabel: chargeLabels[charge.status],
		unbilled: charge.status === 'posted',
		covered: charge.covered,
		coverageNote: charge.coverageNote,
		occurredAt: charge.occurredAt
	};
}

/** Sums the charges that will appear on the next invoice. */
export function unbilledTotal(charges: readonly PresentedCharge[], currency: string): Money {
	return sumMoney(
		charges.filter((charge) => charge.unbilled).map((charge) => charge.total),
		currency
	);
}

/** One reason an account cannot be closed. */
export interface CloseException {
	readonly check: string;
	readonly detail: string;
	readonly amount: Money | null;
	readonly references: readonly string[];
}

/** Whether the account may be closed, and why not. */
export interface CloseReadiness {
	readonly ready: boolean;
	readonly exceptions: readonly CloseException[];
	readonly message: string;
}

/**
 * Reports whether the account may be closed (SRS-BIL-013).
 *
 * The exceptions come from the server and are listed, not summarised. "Cannot
 * close" with no list is a dead end for whoever is at the desk; the list is
 * what turns it into a task.
 */
export function closeReadiness(exceptions: readonly CloseException[]): CloseReadiness {
	if (exceptions.length === 0) {
		return { ready: true, exceptions: [], message: 'Everything is settled. The account can be closed.' };
	}
	return {
		ready: false,
		exceptions,
		message:
			exceptions.length === 1
				? 'One thing is outstanding before this account can be closed.'
				: `${exceptions.length} things are outstanding before this account can be closed.`
	};
}

/** Why a payment cannot be taken. */
export interface PaymentValidity {
	readonly ready: boolean;
	readonly problems: readonly string[];
}

/**
 * Checks a payment before taking it.
 *
 * The idempotency key is required rather than generated at submit time. A key
 * minted on the click changes on every retry, so a double submission produces
 * two receipts — the whole point of the key is that it is stable across the
 * retry (SRS-BIL-008).
 */
export function validatePayment(payment: {
	readonly amount: Money | null;
	readonly method: PaymentMethod;
	readonly idempotencyKey: string;
	readonly accountId: string;
}): PaymentValidity {
	const problems: string[] = [];

	if (payment.accountId.trim() === '') {
		problems.push('No account is open.');
	}
	if (!payment.amount) {
		// parseMoney returned null: what was typed could not be read as an
		// amount, and refusing is the only safe answer.
		problems.push('Enter an amount.');
	} else if (payment.amount.minor <= 0n) {
		// A refund is its own operation against the original payment
		// (SRS-BIL-009), not a negative payment.
		problems.push('A payment must be more than zero. Use a refund to return money.');
	}
	if (payment.method === 'unspecified') {
		problems.push('Choose how the money was taken.');
	}
	if (payment.idempotencyKey.trim() === '') {
		problems.push('This payment has no idempotency key.');
	}

	return { ready: problems.length === 0, problems };
}

/** A one-line summary of what the desk owes or holds. */
export function describeAccountHeader(statement: Statement, locale?: string): string {
	const parts: string[] = [];
	if (!isZero(statement.deposits)) {
		parts.push(`${formatMoney(statement.deposits, { locale })} on deposit`);
	}
	const balance = statement.reconciles
		? statement.reportedBalance
		: // When the two disagree, the derived figure is shown, because it is the
			// one this screen can account for line by line.
			statement.derivedBalance;
	parts.push(
		balance.minor > 0n
			? `${formatMoney(balance, { locale })} outstanding`
			: balance.minor < 0n
				? `${formatMoney({ minor: -balance.minor, currency: balance.currency }, { locale })} in credit`
				: 'settled'
	);
	return parts.join(', ');
}

/** Adds a single entry to a running balance, for an optimistic update. */
export function applyEntry(balance: Money, entry: PresentedEntry): Money {
	return addMoney(balance, entry.amount);
}
