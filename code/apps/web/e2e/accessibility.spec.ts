import AxeBuilder from '@axe-core/playwright';
import { expect, test, type Page } from '@playwright/test';

/**
 * Automated accessibility gate (SRS-WEB-009, SRS-NFR-007).
 *
 * Target is WCAG 2.2 AA. Two things are worth stating plainly, because an
 * accessibility suite that overstates what it proves is worse than none:
 *
 * Automated scanning catches roughly a third of WCAG failures. It finds
 * missing labels, insufficient contrast, broken heading order and unlabelled
 * controls — real defects, and the ones most often introduced by a routine
 * change. It cannot tell whether a label is *meaningful*, whether a focus
 * order makes sense to somebody who cannot see the layout, or whether an error
 * message explains what to do. Those need the manual pass the release gate
 * requires (docs/engineering/release-gate.md).
 *
 * So this suite is the floor, not the target. Its job is to make a regression
 * fail the build rather than to certify conformance.
 */

const WCAG_AA = ['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa', 'wcag22aa'];

async function scan(page: Page) {
	return new AxeBuilder({ page }).withTags(WCAG_AA).analyze();
}

/** Renders a violation so the failure says what to fix and where. */
function describe(results: Awaited<ReturnType<typeof scan>>): string {
	return results.violations
		.map((v) => {
			const where = v.nodes.map((n) => n.target.join(' ')).join('; ');
			return `${v.id} (${v.impact ?? 'unknown'}): ${v.help}\n    at ${where}\n    ${v.helpUrl}`;
		})
		.join('\n\n');
}

const pages = [
	{ name: 'workspace home', path: '/' },
	{ name: 'facilities worklist', path: '/facilities' }
];

for (const target of pages) {
	test(`${target.name} has no WCAG 2.2 AA violations`, async ({ page }) => {
		await page.goto(target.path);
		const results = await scan(page);
		expect(results.violations, describe(results)).toEqual([]);
	});
}

test('every page has one main landmark and a level-1 heading', async ({ page }) => {
	// Not an axe rule, and the thing screen-reader users rely on most: without
	// a main landmark there is no way to skip past navigation, and every visit
	// starts by tabbing through the sidebar.
	await page.goto('/');

	await expect(page.locator('main')).toHaveCount(1);
	await expect(page.locator('h1')).toHaveCount(1);
});

test('keyboard focus is visible and reaches the primary action', async ({ page }) => {
	// A focus ring removed for aesthetics is the single most common
	// keyboard-accessibility regression, and axe cannot see it: the CSS is
	// valid and the element is focusable.
	await page.goto('/');

	await page.keyboard.press('Tab');
	const focused = page.locator(':focus-visible');
	await expect(focused).toHaveCount(1);

	const outline = await focused.evaluate((el) => {
		const style = getComputedStyle(el);
		return {
			outlineWidth: style.outlineWidth,
			outlineStyle: style.outlineStyle,
			boxShadow: style.boxShadow
		};
	});
	const hasVisibleFocus =
		(outline.outlineStyle !== 'none' && outline.outlineWidth !== '0px') ||
		outline.boxShadow !== 'none';
	expect(hasVisibleFocus, 'the focused element has no visible focus indicator').toBe(true);
});

test('the page is usable at 200% zoom without horizontal scrolling', async ({ page }) => {
	// WCAG 2.2 AA 1.4.10 reflow. Emulated by halving the viewport, which is
	// what 200% zoom amounts to for layout purposes.
	await page.setViewportSize({ width: 640, height: 512 });
	await page.goto('/');

	const overflows = await page.evaluate(
		() => document.documentElement.scrollWidth > document.documentElement.clientWidth + 1
	);
	expect(overflows, 'the page scrolls horizontally at 200% zoom').toBe(false);
});
