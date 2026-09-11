/**
 * Browser-visible configuration.
 *
 * Only non-secret values belong here: a browser bundle is public, so it never
 * receives server secrets (Domain/Data spec §13.1).
 */

/** Base URL of the core ConnectRPC service. */
export const PUBLIC_API_BASE_URL = import.meta.env?.VITE_API_BASE_URL ?? 'http://localhost:8080';

/** Deployment environment name, surfaced in the shell banner (SRS-WEB-003). */
export const PUBLIC_ENVIRONMENT = import.meta.env?.VITE_ENVIRONMENT ?? 'development';
