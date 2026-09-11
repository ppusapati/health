/**
 * Session state for the workspace shell.
 *
 * The token is held in memory only. Persisting it to localStorage would leave a
 * long-lived credential where any script on the origin can read it, which
 * SRS-IAM-002 forbids.
 *
 * Everything here is presentation input. The server re-evaluates authorization
 * on every call regardless of what the UI chose to show: UI visibility is never
 * authorization (SRS-IAM-003).
 */
import type { SessionContext } from '$gen/healthcare/identity_access/v1/identity_pb.js';
import type { SessionCredentials } from './api/client.js';

export interface WorkspaceSession {
	readonly credentials: SessionCredentials;
	readonly context: SessionContext;
}

let current: WorkspaceSession | null = null;
const subscribers = new Set<(s: WorkspaceSession | null) => void>();

/** Svelte store contract, so components can use `$session`. */
export const session = {
	subscribe(run: (value: WorkspaceSession | null) => void): () => void {
		subscribers.add(run);
		run(current);
		return () => subscribers.delete(run);
	}
};

/** Replaces the active session and notifies subscribers. */
export function setSession(next: WorkspaceSession | null): void {
	current = next;
	for (const run of subscribers) {
		run(current);
	}
}

/** Returns the credentials for the API client, or null when signed out. */
export function currentCredentials(): SessionCredentials | null {
	return current?.credentials ?? null;
}

/**
 * Reports whether the signed-in user holds a permission.
 *
 * Used only to hide actions the user cannot take, so the UI does not offer
 * buttons that will fail. It is never the access control itself.
 */
export function can(permission: string): boolean {
	return current?.context.permissions.includes(permission) ?? false;
}
