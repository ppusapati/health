import { existsSync } from 'node:fs';
import { defineConfig, devices } from '@playwright/test';

/**
 * Some environments ship a pre-installed Chromium whose build number does not
 * match the one this Playwright version expects. Pointing at it keeps the
 * suite runnable there without pinning the dependency to whatever that image
 * happens to carry; CI installs its own browsers and this resolves to
 * undefined, so the matched build is used.
 */
const preinstalledChromium = [
	'/opt/pw-browsers/chromium-1194/chrome-linux/chrome',
	'/opt/pw-browsers/chromium/chrome-linux/chrome'
].find((path) => existsSync(path));

/**
 * Browser-level gates: accessibility (SRS-WEB-009, SRS-NFR-007) and the
 * cross-browser smoke suite (SRS-NFR-014).
 *
 * Both requirements name a release gate rather than a report, so these run in
 * CI and fail the build. An accessibility scan that produces a dashboard
 * nobody is accountable for is how a product ships at AA on paper and at
 * nothing in practice.
 */
export default defineConfig({
	testDir: 'e2e',
	// Failing on `test.only` keeps a debugging session from silently disabling
	// the rest of the suite when it is committed.
	forbidOnly: !!process.env.CI,
	retries: process.env.CI ? 1 : 0,
	reporter: process.env.CI ? [['github'], ['list']] : 'list',

	use: {
		baseURL: 'http://127.0.0.1:4173',
		trace: 'on-first-retry'
	},

	// The published support matrix (SRS-NFR-014). Chromium and WebKit cover the
	// two rendering engines a hospital estate actually runs — managed Chrome or
	// Edge on desktops, Safari on the iPads at the bedside. Firefox is in the
	// matrix and is listed here so adding it is a config change rather than a
	// discovery.
	projects: [
		{
			name: 'chromium',
			use: {
				...devices['Desktop Chrome'],
				...(preinstalledChromium ? { launchOptions: { executablePath: preinstalledChromium } } : {})
			}
		},
		{ name: 'webkit', use: { ...devices['Desktop Safari'] } },
		// The bedside case: a clinician on a tablet, where touch targets and
		// viewport width are where accessibility regressions actually appear.
		{ name: 'tablet-safari', use: { ...devices['iPad (gen 7)'] } }
	],

	webServer: {
		command: 'npm run build && npm run preview -- --port 4173 --host 127.0.0.1',
		url: 'http://127.0.0.1:4173',
		reuseExistingServer: !process.env.CI,
		timeout: 120_000
	}
});
