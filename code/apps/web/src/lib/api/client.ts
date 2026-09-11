/**
 * Canonical API client.
 *
 * Every browser call goes through the generated ConnectRPC client
 * (SRS-WEB-002). Handwritten wire types are prohibited, so nothing in this file
 * constructs a request body by hand.
 */
import { createClient, type Client, type Interceptor } from '@connectrpc/connect';
import { createConnectTransport } from '@connectrpc/connect-web';
import { OrganizationService } from '$gen/healthcare/organization/v1/organization_pb.js';
import { IdentityService } from '$gen/healthcare/identity_access/v1/identity_pb.js';

/** Header names shared with the Go transport layer. */
export const Headers = {
	authorization: 'Authorization',
	correlationId: 'X-Correlation-Id',
	facilityId: 'X-Facility-Id',
	purposeOfUse: 'X-Purpose-Of-Use'
} as const;

export interface SessionCredentials {
	/** Opaque bearer token. Never persisted to localStorage (SRS-IAM-002). */
	readonly token: string;
	readonly activeFacilityId?: string;
	readonly purposeOfUse?: string;
}

/**
 * Attaches credentials and a fresh correlation ID to every request.
 *
 * The correlation ID is generated client-side so a user can quote it from an
 * error banner and support can find the exact server trace (SRS-WEB-011).
 */
export function authInterceptor(getCredentials: () => SessionCredentials | null): Interceptor {
	return (next) => async (req) => {
		const credentials = getCredentials();
		if (credentials) {
			req.header.set(Headers.authorization, `Bearer ${credentials.token}`);
			if (credentials.activeFacilityId) {
				req.header.set(Headers.facilityId, credentials.activeFacilityId);
			}
			if (credentials.purposeOfUse) {
				req.header.set(Headers.purposeOfUse, credentials.purposeOfUse);
			}
		}
		if (!req.header.has(Headers.correlationId)) {
			req.header.set(Headers.correlationId, newCorrelationId());
		}
		return next(req);
	};
}

/** Generates a correlation ID, falling back where crypto.randomUUID is absent. */
export function newCorrelationId(): string {
	if (typeof crypto !== 'undefined' && typeof crypto.randomUUID === 'function') {
		return crypto.randomUUID();
	}
	return `cid-${Date.now().toString(16)}-${Math.random().toString(16).slice(2, 10)}`;
}

export interface ApiClients {
	readonly organization: Client<typeof OrganizationService>;
	readonly identity: Client<typeof IdentityService>;
}

/** Builds the clients for one base URL and credential source. */
export function createApiClients(
	baseUrl: string,
	getCredentials: () => SessionCredentials | null
): ApiClients {
	const transport = createConnectTransport({
		baseUrl,
		interceptors: [authInterceptor(getCredentials)]
	});

	return {
		organization: createClient(OrganizationService, transport),
		identity: createClient(IdentityService, transport)
	};
}
