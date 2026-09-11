import { describe, expect, it } from 'vitest';
import { Headers, authInterceptor, newCorrelationId } from './client.js';
import type { SessionCredentials } from './client.js';

/** Minimal stand-in for a Connect request. */
function fakeRequest() {
	return { header: new globalThis.Headers() };
}

async function runInterceptor(credentials: SessionCredentials | null) {
	const interceptor = authInterceptor(() => credentials);
	const req = fakeRequest();
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	await interceptor((async (r: any) => r) as any)(req as any);
	return req.header;
}

describe('authInterceptor', () => {
	it('attaches the bearer token and optional context headers', async () => {
		const header = await runInterceptor({
			token: 'tenant-a:user-1:tenant_admin',
			activeFacilityId: 'facility-1',
			purposeOfUse: 'treatment'
		});

		expect(header.get(Headers.authorization)).toBe('Bearer tenant-a:user-1:tenant_admin');
		expect(header.get(Headers.facilityId)).toBe('facility-1');
		expect(header.get(Headers.purposeOfUse)).toBe('treatment');
	});

	it('omits optional headers that were not supplied', async () => {
		const header = await runInterceptor({ token: 'tenant-a:user-1:tenant_admin' });

		expect(header.has(Headers.facilityId)).toBe(false);
		expect(header.has(Headers.purposeOfUse)).toBe(false);
	});

	// Every request carries a correlation ID so an error banner can quote one
	// even when the call fails before reaching a handler.
	it('always sets a correlation ID', async () => {
		const header = await runInterceptor(null);
		expect(header.get(Headers.correlationId)).toBeTruthy();
	});

	it('preserves a correlation ID the caller already set', async () => {
		const interceptor = authInterceptor(() => null);
		const req = fakeRequest();
		req.header.set(Headers.correlationId, 'caller-supplied');

		// eslint-disable-next-line @typescript-eslint/no-explicit-any
		await interceptor((async (r: any) => r) as any)(req as any);

		expect(req.header.get(Headers.correlationId)).toBe('caller-supplied');
	});

	// Signed out means no Authorization header at all; the server then applies
	// deny-by-default rather than seeing an empty credential.
	it('sends no authorization header when signed out', async () => {
		const header = await runInterceptor(null);
		expect(header.has(Headers.authorization)).toBe(false);
	});
});

describe('newCorrelationId', () => {
	it('produces distinct non-empty identifiers', () => {
		const a = newCorrelationId();
		const b = newCorrelationId();

		expect(a).toBeTruthy();
		expect(a).not.toBe(b);
	});
});
