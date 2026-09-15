import { describe, expect, it } from 'vitest';
import {
	CurrencyMismatchError,
	addMoney,
	decimalsFor,
	describeBalance,
	formatMoney,
	formatRate,
	isOwed,
	isZero,
	parseMoney,
	subtractMoney,
	sumMoney,
	type Money
} from './money.js';

function inr(minor: bigint): Money {
	return { minor, currency: 'INR' };
}

describe('formatting', () => {
	it('never divides into a float', () => {
		// The classic failure: 1234567 / 100 is 12345.67 in a float and
		// formats back correctly here, but the same arithmetic on larger
		// ledgers drifts. Integer split, so it is exact at any magnitude.
		expect(formatMoney(inr(1234567n), { withCurrency: false })).toBe('12,345.67');
		expect(formatMoney(inr(1n), { withCurrency: false })).toBe('0.01');
		expect(formatMoney(inr(0n), { withCurrency: false })).toBe('0.00');
		expect(formatMoney(inr(10n), { withCurrency: false })).toBe('0.10');
	});

	it('stays exact past the range of a float', () => {
		// 2^53 minor units is about ninety trillion rupees — larger than any
		// real ledger, and the point is that the arithmetic does not care.
		const huge = inr(90071992547409919n);
		expect(formatMoney(huge, { withCurrency: false, locale: 'en-US' })).toBe(
			'900,719,925,474,099.19'
		);
	});

	it('renders a negative amount with one leading minus', () => {
		expect(formatMoney(inr(-50n), { withCurrency: false })).toBe('-0.50');
	});

	it('uses the currency code rather than a symbol', () => {
		// A symbol is ambiguous across the several currencies using "$", and a
		// receipt has to be unambiguous.
		expect(formatMoney(inr(1000n))).toBe('INR 10.00');
	});

	it('respects currencies that do not have two decimal places', () => {
		// Rendering ¥1,200 as ¥12.00 is a hundredfold error on a receipt.
		expect(decimalsFor('JPY')).toBe(0);
		expect(decimalsFor('KWD')).toBe(3);
		expect(decimalsFor('inr')).toBe(2);

		expect(formatMoney({ minor: 1200n, currency: 'JPY' }, { withCurrency: false })).toBe('1,200');
		expect(formatMoney({ minor: 1234n, currency: 'KWD' }, { withCurrency: false })).toBe('1.234');
	});
});

describe('parsing what a cashier typed', () => {
	it('produces exact minor units', () => {
		expect(parseMoney('1234.50', 'INR')).toEqual(inr(123450n));
		expect(parseMoney('1,234.50', 'INR')).toEqual(inr(123450n));
		expect(parseMoney('0.01', 'INR')).toEqual(inr(1n));
		expect(parseMoney('10', 'INR')).toEqual(inr(1000n));
		expect(parseMoney('.5', 'INR')).toEqual(inr(50n));
		expect(parseMoney('7.', 'INR')).toEqual(inr(700n));
	});

	it('refuses rather than guessing', () => {
		// A typed amount that cannot be read is a refusal to accept the
		// payment, not an amount of zero — and zero is what a lenient parser
		// produces from a typing slip.
		for (const bad of ['', '   ', 'abc', '1.2.3', '-', '.', '1e3', '£10', '10-']) {
			expect(parseMoney(bad, 'INR')).toBeNull();
		}
	});

	it('refuses more precision than the currency has', () => {
		// Silently turning 10.005 into 10.01 on a receipt is a discrepancy
		// somebody has to reconcile later.
		expect(parseMoney('10.005', 'INR')).toBeNull();
		expect(parseMoney('10.005', 'KWD')).toEqual({ minor: 10005n, currency: 'KWD' });
		expect(parseMoney('12.5', 'JPY')).toBeNull();
	});

	it('round-trips through formatting', () => {
		for (const typed of ['0.01', '1234.50', '99999.99']) {
			const parsed = parseMoney(typed, 'INR');
			expect(parsed).not.toBeNull();
			expect(formatMoney(parsed as Money, { withCurrency: false, locale: 'en-US' })).toBe(
				Number(typed).toLocaleString('en-US', { minimumFractionDigits: 2 })
			);
		}
	});

	it('accepts a negative amount, for a refund line', () => {
		expect(parseMoney('-25.00', 'INR')).toEqual(inr(-2500n));
	});
});

describe('arithmetic', () => {
	it('adds and subtracts exactly', () => {
		expect(addMoney(inr(1n), inr(2n))).toEqual(inr(3n));
		expect(subtractMoney(inr(1000n), inr(1n))).toEqual(inr(999n));
	});

	it('sums a hundred ten-paise lines to exactly ten rupees', () => {
		// The float version of this is 9.999999999999998, and an invoice that
		// does not add up is one a patient is right to dispute.
		const lines = Array.from({ length: 100 }, () => inr(10n));
		expect(sumMoney(lines, 'INR')).toEqual(inr(1000n));
	});

	it('returns zero of the right currency for an empty sum', () => {
		expect(sumMoney([], 'INR')).toEqual(inr(0n));
	});

	it('refuses to mix currencies', () => {
		// A screen that silently sums two currencies is a reconciliation
		// failure nobody finds until year end.
		expect(() => addMoney(inr(100n), { minor: 100n, currency: 'USD' })).toThrow(
			CurrencyMismatchError
		);
		expect(() => sumMoney([inr(100n), { minor: 1n, currency: 'USD' }], 'INR')).toThrow(
			CurrencyMismatchError
		);
	});

	it('treats currency codes case-insensitively when comparing', () => {
		expect(addMoney(inr(100n), { minor: 1n, currency: 'inr' })).toEqual(inr(101n));
	});
});

describe('describing a balance', () => {
	it('says which way round it is rather than showing a sign', () => {
		// A negative balance on a screen reads as an error to most people, and
		// which way round it is is the one thing a patient at a desk needs.
		expect(describeBalance(inr(150000n), 'en-US')).toBe('Owes INR 1,500.00');
		expect(describeBalance(inr(-25000n), 'en-US')).toBe('In credit INR 250.00');
		expect(describeBalance(inr(0n))).toBe('Settled');
	});

	it('reports whether anything is owed', () => {
		expect(isOwed(inr(1n))).toBe(true);
		expect(isOwed(inr(0n))).toBe(false);
		expect(isOwed(inr(-1n))).toBe(false);
		expect(isZero(inr(0n))).toBe(true);
	});
});

describe('tax rates in basis points', () => {
	it('renders whole and fractional percentages', () => {
		// Basis points because a rate held as a float has money's problem: 0.18
		// is not representable, and a tax line computed from it does not
		// reconcile against the server's.
		expect(formatRate(1800)).toBe('18%');
		expect(formatRate(0)).toBe('0%');
		expect(formatRate(1250)).toBe('12.5%');
		expect(formatRate(505)).toBe('5.05%');
	});
});
