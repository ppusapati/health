import { describe, expect, it } from 'vitest';
import { acrossSites, clinical, forZone, offsetMinutes, UnknownZoneError } from './display.js';

describe('clinically material timestamp display (SRS-WEB-014)', () => {
	it('converts a UTC instant to the facility clock', () => {
		// 2026-09-11 20:00 UTC is 2026-09-12 01:30 IST.
		const instant = new Date('2026-09-11T20:00:00Z');
		const displayed = forZone(instant, 'Asia/Kolkata');

		// Matched loosely on the month: ICU renders en-GB's short month as
		// "Sep" or "Sept" depending on the Node build, and pinning one spelling
		// would make this fail on a version bump rather than on a real defect.
		expect(displayed.text).toMatch(/12 Sept? 2026/);
		expect(displayed.text).toContain('01:30');
		expect(displayed.zone).toBe('Asia/Kolkata');
	});

	it('always shows which clock the time is on', () => {
		// The zone is part of the string rather than a tooltip: a printed page
		// and a screenshot both lose the tooltip and both end up in a case file.
		const rendered = clinical(new Date('2026-09-11T20:00:00Z'), 'Asia/Kolkata');
		expect(rendered).toMatch(/GMT\+5:30|IST/);
	});

	it('renders the same instant differently on two clocks', () => {
		const instant = new Date('2026-01-15T12:00:00Z');
		const kolkata = clinical(instant, 'Asia/Kolkata');
		const london = clinical(instant, 'Europe/London');

		expect(kolkata).not.toBe(london);
		expect(kolkata).toContain('17:30');
		expect(london).toContain('12:00');
	});

	it('refuses a zone the platform does not know', () => {
		expect(() => forZone(new Date(), 'Mars/Olympus_Mons')).toThrow(UnknownZoneError);
		expect(() => forZone(new Date(), '')).toThrow(UnknownZoneError);
	});
});

describe('daylight saving (SRS-WEB-014 verification)', () => {
	it('follows the spring-forward transition in Europe/London', () => {
		// 2026-03-29 01:00 UTC: clocks go forward to 02:00 BST.
		const before = new Date('2026-03-29T00:30:00Z');
		const after = new Date('2026-03-29T01:30:00Z');

		expect(offsetMinutes(before, 'Europe/London')).toBe(0);
		expect(offsetMinutes(after, 'Europe/London')).toBe(60);

		expect(forZone(before, 'Europe/London').text).toContain('00:30');
		expect(forZone(after, 'Europe/London').text).toContain('02:30');
	});

	it('follows the autumn fallback and marks the repeated hour', () => {
		// 2026-10-25: clocks go back at 02:00 BST. 00:30 and 01:30 UTC are
		// both 01:30 local — the first in BST, the second in GMT.
		const first = new Date('2026-10-25T00:30:00Z');
		const second = new Date('2026-10-25T01:30:00Z');

		expect(forZone(first, 'Europe/London').text).toContain('01:30');
		expect(forZone(second, 'Europe/London').text).toContain('01:30');

		// The offsets differ, which is the information a zone name alone loses.
		expect(offsetMinutes(first, 'Europe/London')).toBe(60);
		expect(offsetMinutes(second, 'Europe/London')).toBe(0);

		// A clinician comparing two administrations an hour apart would
		// otherwise see the same time twice with nothing to distinguish them.
		expect(clinical(second, 'Europe/London')).toContain('repeated hour');
	});

	it('handles a region with no daylight saving', () => {
		// India does not observe DST, so the offset is the same in both halves
		// of the year — and a test that only covered Europe would not notice a
		// change that broke this.
		const winter = new Date('2026-01-15T12:00:00Z');
		const summer = new Date('2026-07-15T12:00:00Z');

		expect(offsetMinutes(winter, 'Asia/Kolkata')).toBe(330);
		expect(offsetMinutes(summer, 'Asia/Kolkata')).toBe(330);
		expect(forZone(winter, 'Asia/Kolkata').ambiguous).toBe(false);
	});

	it('handles a southern-hemisphere region, where the transitions invert', () => {
		const januaryOffset = offsetMinutes(new Date('2026-01-15T00:00:00Z'), 'Australia/Sydney');
		const julyOffset = offsetMinutes(new Date('2026-07-15T00:00:00Z'), 'Australia/Sydney');

		// Summer time in January, standard in July — the opposite of Europe.
		expect(januaryOffset).toBeGreaterThan(julyOffset);
	});

	it('handles a half-hour offset zone', () => {
		// Half-hour and 45-minute offsets are where naive offset arithmetic
		// breaks, and a hospital group operating in India hits this daily.
		expect(offsetMinutes(new Date('2026-06-01T00:00:00Z'), 'Asia/Kolkata')).toBe(330);
		expect(offsetMinutes(new Date('2026-06-01T00:00:00Z'), 'Asia/Kathmandu')).toBe(345);
	});
});

describe('cross-site display', () => {
	it('shows both clocks when they differ', () => {
		const both = acrossSites(new Date('2026-01-15T12:00:00Z'), 'Asia/Kolkata', 'Europe/London');
		expect(both.facility).toContain('17:30');
		expect(both.viewer).toContain('12:00');
	});

	it('shows one clock when they agree, so a single-site hospital is not cluttered', () => {
		const same = acrossSites(new Date('2026-01-15T12:00:00Z'), 'Asia/Kolkata', 'Asia/Kolkata');
		expect(same.viewer).toBeNull();
	});
});
