/**
 * Money on screen (SRS-BIL-006, SRS-BIL-008, SRS-BIL-012, UX-W1-06).
 *
 * The server carries money as integer minor units with a currency beside it,
 * and never as a float — a float cannot represent 0.10 exactly, so a hundred
 * lines summed as floats do not equal the invoice total, and an invoice that
 * does not add up is one a patient is right to dispute.
 *
 * The browser is where that discipline usually breaks. `value / 100` produces a
 * float; formatting it back rounds; and the number a cashier reads on screen
 * drifts from the number in the ledger. So nothing here divides. Formatting
 * splits the integer into whole and fractional parts with integer arithmetic,
 * and parsing goes the other way — a typed "1,234.50" becomes 123450 minor
 * units without ever being a float.
 *
 * Two amounts in different currencies are never added, compared or rendered as
 * one figure. A ward that takes a deposit in one currency and bills in another
 * is unusual; a screen that silently sums them is a reconciliation failure that
 * nobody finds until year end.
 */

/** An amount, as the server carries it. */
export interface Money {
	/** Integer minor units. Negative means the other direction. */
	readonly minor: bigint;
	/** ISO 4217 alphabetic code. */
	readonly currency: string;
}

/** Thrown when two amounts cannot be combined. */
export class CurrencyMismatchError extends Error {
	constructor(left: string, right: string) {
		super(`cannot combine ${left} and ${right}`);
		this.name = 'CurrencyMismatchError';
	}
}

/**
 * How many minor units make one major unit.
 *
 * Not universally 100: the dinar currencies use three decimal places and the
 * yen uses none. Getting this wrong renders ¥1,200 as ¥12.00, which is a
 * hundredfold error on a receipt.
 */
const minorUnitsByCurrency: Record<string, number> = {
	JPY: 0,
	KRW: 0,
	VND: 0,
	BHD: 3,
	IQD: 3,
	JOD: 3,
	KWD: 3,
	OMR: 3,
	TND: 3
};

/** Decimal places for a currency. Two unless it is one of the exceptions. */
export function decimalsFor(currency: string): number {
	return minorUnitsByCurrency[currency.toUpperCase()] ?? 2;
}

/**
 * Renders an amount.
 *
 * Integer arithmetic throughout: the whole part and the fractional part are
 * split with division and remainder on a bigint, never by dividing into a
 * float. `1234567n` in a two-decimal currency is "12,345.67" exactly, and stays
 * exact at any magnitude a hospital's ledger reaches.
 */
export function formatMoney(
	amount: Money,
	options: { readonly withCurrency?: boolean; readonly locale?: string } = {}
): string {
	const decimals = decimalsFor(amount.currency);
	const negative = amount.minor < 0n;
	const magnitude = negative ? -amount.minor : amount.minor;

	const scale = 10n ** BigInt(decimals);
	const whole = magnitude / scale;
	const fraction = magnitude % scale;

	const groupedWhole = groupDigits(whole.toString(), options.locale);
	const rendered =
		decimals === 0
			? groupedWhole
			: `${groupedWhole}.${fraction.toString().padStart(decimals, '0')}`;

	const signed = negative ? `-${rendered}` : rendered;
	// The currency code, not a symbol. A symbol is ambiguous across the several
	// currencies that use "$", and a receipt has to be unambiguous.
	return options.withCurrency === false ? signed : `${amount.currency} ${signed}`;
}

/** Groups the whole part into thousands. */
function groupDigits(digits: string, locale?: string): string {
	// Intl handles locale grouping (lakh/crore in en-IN, for instance) and takes
	// a bigint without losing precision.
	try {
		return new Intl.NumberFormat(locale ?? undefined, { useGrouping: true }).format(
			BigInt(digits)
		);
	} catch {
		return digits;
	}
}

/**
 * Parses what a cashier typed into minor units.
 *
 * Returns null rather than guessing. A typed amount that cannot be read is a
 * refusal to accept the payment, not an amount of zero — and zero is the value
 * a lenient parser produces from a typing slip.
 */
export function parseMoney(input: string, currency: string): Money | null {
	const decimals = decimalsFor(currency);
	// Grouping separators are stripped; everything else must be digits, at most
	// one decimal point, and an optional leading minus.
	const cleaned = input.trim().replace(/[\s, ]/g, '');
	if (cleaned === '') {
		return null;
	}
	if (!/^-?\d*(\.\d*)?$/.test(cleaned) || cleaned === '-' || cleaned === '.') {
		return null;
	}

	const negative = cleaned.startsWith('-');
	const unsigned = negative ? cleaned.slice(1) : cleaned;
	const [wholePart = '', fractionPart = ''] = unsigned.split('.');

	if (wholePart === '' && fractionPart === '') {
		// "-." reaches here: the regex above allows an empty whole part and an
		// empty fraction, and the explicit checks catch "-" and "." but not the
		// two together. Without this it parsed as zero — which is exactly the
		// outcome this function's contract exists to refuse, since zero is what
		// a lenient parser produces from a typing slip. Found by the web/mobile
		// parity harness in tools/parity.
		return null;
	}

	if (fractionPart.length > decimals) {
		// More precision than the currency has. Refused rather than rounded:
		// silently turning 10.005 into 10.01 on a receipt is a discrepancy
		// somebody has to reconcile later.
		return null;
	}

	const scale = 10n ** BigInt(decimals);
	const whole = wholePart === '' ? 0n : BigInt(wholePart);
	const fraction = fractionPart === '' ? 0n : BigInt(fractionPart.padEnd(decimals, '0'));
	const minor = whole * scale + fraction;

	return { minor: negative ? -minor : minor, currency: currency.toUpperCase() };
}

/** Adds two amounts, refusing to mix currencies. */
export function addMoney(left: Money, right: Money): Money {
	requireSameCurrency(left, right);
	return { minor: left.minor + right.minor, currency: left.currency };
}

/** Subtracts the second amount from the first. */
export function subtractMoney(left: Money, right: Money): Money {
	requireSameCurrency(left, right);
	return { minor: left.minor - right.minor, currency: left.currency };
}

/** Sums a list, refusing to mix currencies. Zero of `currency` when empty. */
export function sumMoney(amounts: readonly Money[], currency: string): Money {
	let total: Money = { minor: 0n, currency: currency.toUpperCase() };
	for (const amount of amounts) {
		total = addMoney(total, amount);
	}
	return total;
}

function requireSameCurrency(left: Money, right: Money): void {
	if (left.currency.toUpperCase() !== right.currency.toUpperCase()) {
		// A screen that silently sums two currencies is a reconciliation
		// failure nobody finds until year end.
		throw new CurrencyMismatchError(left.currency, right.currency);
	}
}

/** True when the amount is exactly zero. */
export function isZero(amount: Money): boolean {
	return amount.minor === 0n;
}

/** True when the patient owes money. */
export function isOwed(balance: Money): boolean {
	return balance.minor > 0n;
}

/**
 * Describes a balance in the terms a cashier speaks.
 *
 * "Owes" and "in credit" rather than a signed number. A negative balance on a
 * screen reads as an error to most people, and the one number a patient at a
 * desk actually needs is which way round it is.
 */
export function describeBalance(balance: Money, locale?: string): string {
	if (isZero(balance)) {
		return 'Settled';
	}
	const magnitude: Money = {
		minor: balance.minor < 0n ? -balance.minor : balance.minor,
		currency: balance.currency
	};
	return balance.minor > 0n
		? `Owes ${formatMoney(magnitude, { locale })}`
		: `In credit ${formatMoney(magnitude, { locale })}`;
}

/**
 * Renders a tax rate held in basis points.
 *
 * Basis points because a rate held as a float has the same problem money does:
 * 0.18 is not representable, and a tax line computed from it does not reconcile
 * against one computed by the server.
 */
export function formatRate(basisPoints: number): string {
	const whole = Math.trunc(basisPoints / 100);
	const fraction = Math.abs(basisPoints % 100);
	return fraction === 0
		? `${whole}%`
		: `${whole}.${fraction.toString().padStart(2, '0').replace(/0$/, '')}%`;
}
