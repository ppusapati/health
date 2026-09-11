/**
 * Clinically material timestamp display (SRS-WEB-014).
 *
 * The verification clause is "UTC storage is converted consistently and DST
 * tests pass for supported regions", and the word doing the work is
 * *explicitly*. A timestamp rendered without saying which clock it is on is
 * the bug: "administered 01:30" means different things on a ward in Kolkata
 * and a reader in London, and the reader has no way to tell which they are
 * looking at.
 *
 * So every function here returns the zone alongside the time, and the zone is
 * a parameter rather than the browser's. The browser's timezone is a property
 * of where the *reader* is sitting, which for a clinician reviewing a transfer
 * from another site is exactly the wrong clock.
 */

/** A timestamp rendered for one specific clock. */
export interface DisplayedInstant {
	/** The wall-clock rendering, e.g. "12 Sep 2026, 01:30". */
	readonly text: string;
	/** The zone it was rendered in, e.g. "Asia/Kolkata". */
	readonly zone: string;
	/** The offset abbreviation in force, e.g. "IST", "GMT+5:30". */
	readonly abbreviation: string;
	/** The original instant, so a caller can re-render for another clock. */
	readonly instant: Date;
	/**
	 * True when the wall time occurs twice that day — the daylight-saving
	 * fallback. The UI should disambiguate rather than show an hour that
	 * appears twice in a sorted list with no explanation.
	 */
	readonly ambiguous: boolean;
}

/** Thrown when a zone is not one the platform knows. */
export class UnknownZoneError extends Error {
	constructor(readonly zone: string) {
		super(`unknown time zone: ${zone}`);
		this.name = 'UnknownZoneError';
	}
}

function assertZone(zone: string): void {
	if (!zone) {
		throw new UnknownZoneError(zone);
	}
	try {
		new Intl.DateTimeFormat('en', { timeZone: zone });
	} catch {
		throw new UnknownZoneError(zone);
	}
}

/**
 * Returns the UTC offset in minutes that a zone was on at an instant.
 *
 * Derived from Intl rather than from a table, so it follows the platform's
 * tzdata and stays correct across rule changes without this code shipping an
 * update.
 */
export function offsetMinutes(instant: Date, zone: string): number {
	assertZone(zone);
	// Format the instant in the target zone, read the parts back as if they
	// were UTC, and the difference is the offset. Clumsy, and the only way to
	// get an offset out of Intl without a dependency.
	const parts = new Intl.DateTimeFormat('en-US', {
		timeZone: zone,
		hour12: false,
		year: 'numeric',
		month: '2-digit',
		day: '2-digit',
		hour: '2-digit',
		minute: '2-digit',
		second: '2-digit'
	}).formatToParts(instant);

	const field = (type: Intl.DateTimeFormatPartTypes): number =>
		Number(parts.find((p) => p.type === type)?.value ?? '0');

	// Intl renders midnight as hour 24 on some platforms.
	const hour = field('hour') % 24;
	const asIfUTC = Date.UTC(
		field('year'),
		field('month') - 1,
		field('day'),
		hour,
		field('minute'),
		field('second')
	);
	return Math.round((asIfUTC - instant.getTime()) / 60000);
}

/**
 * Reports whether a wall time occurs twice in a zone — the fallback hour.
 *
 * Detected by comparing the offset an hour earlier: if it differs and the
 * earlier offset is larger, the clock went back and this hour repeats.
 */
function isAmbiguous(instant: Date, zone: string): boolean {
	const hourEarlier = new Date(instant.getTime() - 3600_000);
	return offsetMinutes(hourEarlier, zone) > offsetMinutes(instant, zone);
}

const DEFAULT_FORMAT: Intl.DateTimeFormatOptions = {
	day: '2-digit',
	month: 'short',
	year: 'numeric',
	hour: '2-digit',
	minute: '2-digit',
	hour12: false
};

/**
 * Renders an instant for a specific clock.
 *
 * zone is required and has no default. A default would be the browser's, and a
 * clinician reviewing a transfer from another site would silently read the
 * wrong clock — the failure this whole module exists to prevent.
 */
export function forZone(
	instant: Date,
	zone: string,
	options: Intl.DateTimeFormatOptions = DEFAULT_FORMAT,
	locale = 'en-GB'
): DisplayedInstant {
	assertZone(zone);

	const text = new Intl.DateTimeFormat(locale, { ...options, timeZone: zone }).format(instant);

	const abbreviationPart = new Intl.DateTimeFormat(locale, {
		timeZone: zone,
		timeZoneName: 'short'
	})
		.formatToParts(instant)
		.find((p) => p.type === 'timeZoneName');

	return {
		text,
		zone,
		abbreviation: abbreviationPart?.value ?? '',
		instant,
		ambiguous: isAmbiguous(instant, zone)
	};
}

/**
 * Renders a clinically material timestamp with its zone shown.
 *
 * This is what a chart, a MAR line or an audit row should call. The zone is
 * part of the string rather than a tooltip, because a printed page and a
 * screenshot both lose the tooltip and both end up in a case file.
 */
export function clinical(instant: Date, zone: string, locale = 'en-GB'): string {
	const displayed = forZone(instant, zone, DEFAULT_FORMAT, locale);
	const suffix = displayed.abbreviation ? ` ${displayed.abbreviation}` : '';
	// The ambiguity marker is not decoration: during a fallback hour two
	// different instants render identically, and a clinician comparing two
	// administrations an hour apart would otherwise see the same time twice.
	const marker = displayed.ambiguous ? ' (repeated hour)' : '';
	return `${displayed.text}${suffix}${marker}`;
}

/**
 * Renders the same instant on two clocks, for a transfer between sites.
 *
 * Returns null for the second rendering when both clocks agree, so the UI does
 * not show the same time twice for the common case of a single-site hospital.
 */
export function acrossSites(
	instant: Date,
	facilityZone: string,
	viewerZone: string,
	locale = 'en-GB'
): { readonly facility: string; readonly viewer: string | null } {
	const facility = clinical(instant, facilityZone, locale);
	if (offsetMinutes(instant, facilityZone) === offsetMinutes(instant, viewerZone)) {
		return { facility, viewer: null };
	}
	return { facility, viewer: clinical(instant, viewerZone, locale) };
}
