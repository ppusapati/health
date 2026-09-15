import { describe, expect, it } from 'vitest';
import {
	buildStatement,
	closeReadiness,
	describeAccountHeader,
	describeChargeStatus,
	describeEntryKind,
	presentCharge,
	presentEntry,
	presentInvoice,
	unbilledTotal,
	validatePayment,
	type EntryKind,
	type InvoiceStatus
} from './account.js';
import type { Money } from './money.js';

function inr(minor: bigint): Money {
	return { minor, currency: 'INR' };
}

function entry(overrides: Partial<Parameters<typeof presentEntry>[0]> = {}) {
	return presentEntry({
		entryId: 'led-1',
		kind: 'invoice',
		amount: inr(150000n),
		receiptNumber: '',
		method: 'unspecified',
		reason: '',
		occurredAt: new Date('2026-09-15T09:00:00Z'),
		recordedBy: 'clerk-1',
		...overrides
	});
}

describe('the balance', () => {
	it('is derived from the ledger, and a disagreement is visible', () => {
		// SRS-BIL-012's acceptance is "balance derives from ledger and
		// reconciles", and the second half is the interesting one: the
		// derivation is worth nothing unless a disagreement shows.
		const entries = [
			entry({ entryId: 'a', kind: 'invoice', amount: inr(150000n) }),
			entry({ entryId: 'b', kind: 'payment', amount: inr(-50000n) })
		];

		const agreeing = buildStatement({
			entries,
			reportedBalance: inr(100000n),
			deposits: inr(0n),
			currency: 'INR'
		});
		expect(agreeing.derivedBalance).toEqual(inr(100000n));
		expect(agreeing.reconciles).toBe(true);

		const disagreeing = buildStatement({
			entries,
			reportedBalance: inr(99999n),
			deposits: inr(0n),
			currency: 'INR'
		});
		expect(disagreeing.reconciles).toBe(false);
	});

	it('shows the derived figure when the two disagree', () => {
		// It is the one this screen can account for line by line.
		const statement = buildStatement({
			entries: [entry({ amount: inr(100000n) })],
			reportedBalance: inr(1n),
			deposits: inr(0n),
			currency: 'INR'
		});
		expect(describeAccountHeader(statement, 'en-US')).toMatch(/1,000\.00 outstanding/);
	});

	it('orders the statement most recent first', () => {
		const statement = buildStatement({
			entries: [
				entry({ entryId: 'old', occurredAt: new Date('2026-09-14T09:00:00Z') }),
				entry({ entryId: 'new', occurredAt: new Date('2026-09-15T09:00:00Z') })
			],
			reportedBalance: inr(300000n),
			deposits: inr(0n),
			currency: 'INR'
		});
		expect(statement.entries.map((e) => e.entryId)).toEqual(['new', 'old']);
	});

	it('reports deposits held alongside the balance', () => {
		const statement = buildStatement({
			entries: [entry({ amount: inr(50000n) })],
			reportedBalance: inr(50000n),
			deposits: inr(20000n),
			currency: 'INR'
		});
		expect(describeAccountHeader(statement, 'en-US')).toMatch(/200\.00 on deposit/);
	});

	it('says settled rather than showing a zero', () => {
		const statement = buildStatement({
			entries: [],
			reportedBalance: inr(0n),
			deposits: inr(0n),
			currency: 'INR'
		});
		expect(describeAccountHeader(statement)).toBe('settled');
	});
});

describe('ledger entries', () => {
	it('takes direction from the sign, not from the kind', () => {
		// The ledger is signed. A screen deciding direction from the kind would
		// disagree with it the first time an adjustment went the other way.
		expect(entry({ kind: 'adjustment', amount: inr(-500n) }).increasesDebt).toBe(false);
		expect(entry({ kind: 'adjustment', amount: inr(500n) }).increasesDebt).toBe(true);
		expect(entry({ kind: 'payment', amount: inr(-500n) }).increasesDebt).toBe(false);
	});

	it('keeps an applied deposit distinct from a payment', () => {
		// The money was already held; applying it is a movement within the
		// account rather than a new receipt.
		expect(describeEntryKind('deposit_applied')).toMatch(/deposit applied/i);
		expect(describeEntryKind('payment')).toBe('Payment');
		for (const kind of [
			'invoice',
			'payment',
			'refund',
			'deposit',
			'deposit_applied',
			'write_off',
			'adjustment',
			'unspecified'
		] as EntryKind[]) {
			expect(describeEntryKind(kind)).not.toBe('');
		}
	});
});

describe('invoices', () => {
	function invoice(overrides: Partial<Parameters<typeof presentInvoice>[0]> = {}) {
		return presentInvoice({
			invoiceId: 'inv-1',
			number: 'INV-00001',
			status: 'issued',
			total: inr(150000n),
			issuedAt: new Date('2026-09-15T09:00:00Z'),
			supersededBy: '',
			correctsInvoiceId: '',
			lineCount: 4,
			...overrides
		});
	}

	it('offers no edit path on anything finalised', () => {
		// SRS-BIL-010. The patient is holding a copy, and a system that can
		// quietly change what a document said proves nothing.
		for (const status of ['issued', 'superseded', 'cancelled'] as InvoiceStatus[]) {
			expect(invoice({ status }).editable).toBe(false);
		}
		expect(invoice({ status: 'draft' }).editable).toBe(true);
	});

	it('allows a correction only against a live issued invoice', () => {
		// A superseded or cancelled document is not corrected again; the
		// correction goes against whatever replaced it.
		expect(invoice({ status: 'issued' }).correctable).toBe(true);
		expect(invoice({ status: 'superseded' }).correctable).toBe(false);
		expect(invoice({ status: 'cancelled' }).correctable).toBe(false);
		expect(invoice({ status: 'draft' }).correctable).toBe(false);
	});

	it('keeps the link to what replaced it, or what it corrects', () => {
		expect(invoice({ supersededBy: 'inv-2' }).supersededBy).toBe('inv-2');
		expect(invoice({ correctsInvoiceId: 'inv-0' }).correctsInvoiceId).toBe('inv-0');
	});
});

describe('charges', () => {
	function charge(overrides: Partial<Parameters<typeof presentCharge>[0]> = {}) {
		return presentCharge({
			chargeId: 'chg-1',
			description: 'Full blood count',
			department: 'Laboratory',
			quantity: 1,
			total: inr(45000n),
			status: 'posted',
			covered: false,
			coverageNote: '',
			occurredAt: new Date('2026-09-15T09:00:00Z'),
			...overrides
		});
	}

	it('calls a posted charge unbilled, in the words the desk uses', () => {
		expect(charge({ status: 'posted' }).statusLabel).toBe('Unbilled');
		expect(charge({ status: 'posted' }).unbilled).toBe(true);
		expect(charge({ status: 'invoiced' }).unbilled).toBe(false);
	});

	it('keeps a voided charge on the list', () => {
		// A service somebody decided not to bill for, and that decision is part
		// of the record.
		expect(describeChargeStatus('voided')).toBe('Voided');
	});

	it('sums only the unbilled charges', () => {
		const total = unbilledTotal(
			[
				charge({ chargeId: 'a', status: 'posted', total: inr(45000n) }),
				charge({ chargeId: 'b', status: 'invoiced', total: inr(30000n) }),
				charge({ chargeId: 'c', status: 'posted', total: inr(5000n) }),
				charge({ chargeId: 'd', status: 'voided', total: inr(99999n) })
			],
			'INR'
		);
		expect(total).toEqual(inr(50000n));
	});

	it('explains a charge a package covered rather than showing a bare zero', () => {
		const covered = charge({ covered: true, coverageNote: 'included in the maternity package' });
		expect(covered.covered).toBe(true);
		expect(covered.coverageNote).toMatch(/maternity/);
	});
});

describe('closing an account', () => {
	it('lists what is outstanding rather than only refusing', () => {
		// "Cannot close" with no list is a dead end for whoever is at the desk.
		const readiness = closeReadiness([
			{ check: 'unbilled_charges', detail: 'Two services are not yet invoiced', amount: inr(50000n), references: ['chg-1', 'chg-3'] }
		]);
		expect(readiness.ready).toBe(false);
		expect(readiness.exceptions).toHaveLength(1);
		expect(readiness.message).toMatch(/one thing/i);
	});

	it('is ready when nothing is outstanding', () => {
		const readiness = closeReadiness([]);
		expect(readiness.ready).toBe(true);
		expect(readiness.message).toMatch(/settled/i);
	});
});

describe('taking a payment', () => {
	const good = {
		amount: inr(50000n),
		method: 'cash' as const,
		idempotencyKey: 'key-1',
		accountId: 'acc-1'
	};

	it('accepts a complete one', () => {
		expect(validatePayment(good).ready).toBe(true);
	});

	it('refuses an amount that could not be read', () => {
		// parseMoney returned null; refusing is the only safe answer, and zero
		// is what a lenient parser would have produced.
		expect(validatePayment({ ...good, amount: null }).ready).toBe(false);
	});

	it('refuses a negative payment and points at the refund path', () => {
		// A refund is its own operation against the original payment
		// (SRS-BIL-009), not a payment with a minus sign.
		const refused = validatePayment({ ...good, amount: inr(-100n) });
		expect(refused.ready).toBe(false);
		expect(refused.problems.join(' ')).toMatch(/refund/i);
	});

	it('refuses a payment with no idempotency key', () => {
		// A key minted on the click changes on every retry, so a double
		// submission produces two receipts — the whole point is that it is
		// stable across the retry (SRS-BIL-008).
		expect(validatePayment({ ...good, idempotencyKey: '' }).ready).toBe(false);
	});

	it('refuses a payment with no method', () => {
		expect(validatePayment({ ...good, method: 'unspecified' }).ready).toBe(false);
	});
});
