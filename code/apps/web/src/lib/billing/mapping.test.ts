import { describe, expect, it } from 'vitest';
import { create } from '@bufbuild/protobuf';
import { timestampFromDate } from '@bufbuild/protobuf/wkt';
import {
	ChargeSchema,
	ChargeStatus,
	CloseExceptionSchema,
	EntryKind,
	InvoiceSchema,
	InvoiceStatus,
	LedgerEntrySchema,
	PaymentMethod
} from '$gen/healthcare/billing/v1/billing_pb.js';
import {
	fromMoney,
	toCloseException,
	toMoney,
	toPresentedCharge,
	toPresentedEntry,
	toPresentedInvoice,
	wireMethods
} from './mapping.js';
import { buildStatement, unbilledTotal } from './account.js';
import { formatMoney } from './money.js';

describe('money off the wire', () => {
	it('stays a bigint all the way through', () => {
		// The one thing this layer must not do is turn money into a number.
		const amount = toMoney({ $typeName: 'healthcare.billing.v1.Money', minor: 123450n, currency: 'INR' }, 'INR');
		expect(typeof amount.minor).toBe('bigint');
		expect(formatMoney(amount, { withCurrency: false, locale: 'en-US' })).toBe('1,234.50');
	});

	it('gives an absent amount the account currency, not an empty one', () => {
		// An empty currency string would refuse to sum with everything else and
		// turn one blank field into a screen-wide failure.
		const zero = toMoney(undefined, 'inr');
		expect(zero).toEqual({ minor: 0n, currency: 'INR' });
	});

	it('round-trips back to the wire shape', () => {
		const wire = fromMoney({ minor: -2500n, currency: 'INR' });
		expect(wire).toEqual({ minor: -2500n, currency: 'INR' });
	});
});

describe('a ledger entry off the wire', () => {
	it('translates every kind', () => {
		for (const [wire, want] of Object.entries({
			[EntryKind.INVOICE]: 'invoice',
			[EntryKind.PAYMENT]: 'payment',
			[EntryKind.REFUND]: 'refund',
			[EntryKind.DEPOSIT]: 'deposit',
			[EntryKind.DEPOSIT_APPLIED]: 'deposit_applied',
			[EntryKind.WRITE_OFF]: 'write_off',
			[EntryKind.ADJUSTMENT]: 'adjustment'
		})) {
			const entry = create(LedgerEntrySchema, { kind: Number(wire) });
			expect(toPresentedEntry(entry, 'INR').kind).toBe(want);
		}
	});

	it('translates every payment method, both ways', () => {
		for (const [key, wire] of Object.entries(wireMethods)) {
			const entry = create(LedgerEntrySchema, { method: wire });
			expect(toPresentedEntry(entry, 'INR').method).toBe(key);
		}
	});

	it('builds a statement whose derived balance matches the entries', () => {
		const entries = [
			create(LedgerEntrySchema, {
				entryId: 'a',
				kind: EntryKind.INVOICE,
				amount: { minor: 150000n, currency: 'INR' },
				occurredAt: timestampFromDate(new Date('2026-09-15T09:00:00Z'))
			}),
			create(LedgerEntrySchema, {
				entryId: 'b',
				kind: EntryKind.PAYMENT,
				method: PaymentMethod.CASH,
				amount: { minor: -50000n, currency: 'INR' },
				receiptNumber: 'RCP-00001',
				occurredAt: timestampFromDate(new Date('2026-09-15T10:00:00Z'))
			})
		];
		const statement = buildStatement({
			entries: entries.map((entry) => toPresentedEntry(entry, 'INR')),
			reportedBalance: { minor: 100000n, currency: 'INR' },
			deposits: { minor: 0n, currency: 'INR' },
			currency: 'INR'
		});
		expect(statement.reconciles).toBe(true);
		expect(statement.entries[0].receiptNumber).toBe('RCP-00001');
	});
});

describe('an invoice off the wire', () => {
	it('translates every status', () => {
		for (const [wire, want] of Object.entries({
			[InvoiceStatus.DRAFT]: 'draft',
			[InvoiceStatus.ISSUED]: 'issued',
			[InvoiceStatus.SUPERSEDED]: 'superseded',
			[InvoiceStatus.CANCELLED]: 'cancelled'
		})) {
			const invoice = create(InvoiceSchema, { status: Number(wire) });
			expect(toPresentedInvoice(invoice, 'INR').status).toBe(want);
		}
	});

	it('counts its lines and keeps its total exact', () => {
		const invoice = create(InvoiceSchema, {
			number: 'INV-00001',
			status: InvoiceStatus.ISSUED,
			total: { minor: 150000n, currency: 'INR' },
			lines: [{ sequence: 1 }, { sequence: 2 }]
		});
		const presented = toPresentedInvoice(invoice, 'INR');
		expect(presented.lineCount).toBe(2);
		expect(presented.total.minor).toBe(150000n);
		expect(presented.editable).toBe(false);
	});
});

describe('a charge off the wire', () => {
	it('translates every status and names itself', () => {
		for (const [wire, want] of Object.entries({
			[ChargeStatus.POSTED]: 'posted',
			[ChargeStatus.INVOICED]: 'invoiced',
			[ChargeStatus.VOIDED]: 'voided',
			[ChargeStatus.HELD]: 'held'
		})) {
			const charge = create(ChargeSchema, { status: Number(wire) });
			expect(toPresentedCharge(charge, 'INR').status).toBe(want);
		}
		const coded = create(ChargeSchema, { serviceCode: 'FBC', description: '' });
		expect(toPresentedCharge(coded, 'INR').description).toBe('FBC');
	});

	it('sums the unbilled ones exactly', () => {
		const charges = [
			create(ChargeSchema, { status: ChargeStatus.POSTED, total: { minor: 45000n, currency: 'INR' } }),
			create(ChargeSchema, { status: ChargeStatus.INVOICED, total: { minor: 30000n, currency: 'INR' } }),
			create(ChargeSchema, { status: ChargeStatus.POSTED, total: { minor: 5000n, currency: 'INR' } })
		];
		const total = unbilledTotal(
			charges.map((charge) => toPresentedCharge(charge, 'INR')),
			'INR'
		);
		expect(total.minor).toBe(50000n);
	});
});

describe('a close exception off the wire', () => {
	it('carries no amount when the server sent none', () => {
		// A zero rendered beside "two services are not yet invoiced" reads as
		// "nothing outstanding", which is the opposite of what it says.
		const exception = create(CloseExceptionSchema, {
			check: 'unbilled_charges',
			detail: 'Two services are not yet invoiced'
		});
		expect(toCloseException(exception, 'INR').amount).toBeNull();
	});

	it('carries the amount when there is one', () => {
		const exception = create(CloseExceptionSchema, {
			check: 'outstanding_balance',
			amount: { minor: 50000n, currency: 'INR' }
		});
		expect(toCloseException(exception, 'INR').amount?.minor).toBe(50000n);
	});
});
