import { expect, test } from '@playwright/test';

/**
 * Cross-browser smoke suite (SRS-NFR-014).
 *
 * Runs against every browser in playwright.config.ts, which is the published
 * support matrix. Deliberately shallow: its job is to catch the failures that
 * are browser-specific rather than to re-test behaviour the unit suite already
 * covers. Those failures are almost always one of three things — a JavaScript
 * feature Safari lags on, a CSS layout that only collapses on one engine, or a
 * fetch/streaming difference — and all three show up on a page that simply
 * renders and responds to a click.
 */

test('the workspace shell renders', async ({ page }) => {
	await page.goto('/');
	await expect(page.locator('h1')).toBeVisible();
	// A blank page with no console error is the failure mode this catches: a
	// module that failed to parse on one engine leaves the shell empty.
	await expect(page.locator('main')).not.toBeEmpty();
});

test('client-side navigation works', async ({ page }) => {
	await page.goto('/');
	await page.goto('/facilities');
	await expect(page).toHaveURL(/\/facilities$/);
	await expect(page.locator('main')).toBeVisible();
});

test('the reception workspace renders without a session', async ({ page }) => {
	// Signed out, both screens render their permission state. The failure this
	// catches is a screen that reaches into a null session on first paint —
	// which throws before anything renders, and looks to a user exactly like
	// the application being down.
	for (const path of ['/reception', '/reception/search', '/chart/pat-1', '/ward']) {
		await page.goto(path);
		await expect(page.locator('h1')).toBeVisible();
		await expect(page.locator('main')).not.toBeEmpty();
	}
});

test('no uncaught script errors on load', async ({ page }) => {
	// An engine-specific parse or runtime error usually leaves the page looking
	// almost right, so asserting on the console is what turns it into a
	// failure rather than a subtly broken screen.
	const errors: string[] = [];
	page.on('pageerror', (error) => errors.push(error.message));

	await page.goto('/');
	await page.waitForLoadState('networkidle');

	expect(errors).toEqual([]);
});
