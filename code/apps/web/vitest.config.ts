import { defineConfig } from 'vitest/config';
import { resolve } from 'node:path';

/**
 * Unit tests run without the SvelteKit plugin so they stay fast and do not need
 * a build. The $gen and $lib aliases are mirrored here to match svelte.config.js.
 */
export default defineConfig({
	resolve: {
		alias: {
			$gen: resolve('./src/lib/gen'),
			$lib: resolve('./src/lib')
		}
	},
	test: {
		include: ['src/**/*.test.ts'],
		environment: 'node'
	}
});
