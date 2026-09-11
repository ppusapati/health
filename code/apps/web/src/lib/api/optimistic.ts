/**
 * Optimistic UI, confined to where it is safe (SRS-WEB-007).
 *
 * The verification clause draws the line: "clinical/financial finalization is
 * server-confirmed before UI success". Optimistic UI makes an application feel
 * fast by showing the result before the server agrees, and in most software
 * the cost of being wrong is a flicker. In a hospital it is a clinician
 * reading "administered" for a dose that was never recorded, or a cashier
 * seeing a payment that did not settle.
 *
 * So this module does not offer a general optimistic wrapper. It offers one
 * for operations that are explicitly declared reversible, and it refuses at
 * runtime to apply optimism to anything marked as a finalization — because a
 * rule that lives only in a code review is a rule that lasts until the first
 * deadline.
 */

/** What kind of operation is being performed. */
export type OperationKind =
	/**
	 * Reversible and non-clinical: renaming a saved view, toggling a column,
	 * marking a task read. Rolling back is invisible to anyone but the user
	 * who did it.
	 */
	| 'reversible'
	/**
	 * Clinical or financial finalization: signing a note, administering a
	 * medication, taking a payment, issuing an invoice. Never optimistic.
	 */
	| 'finalization';

/** Thrown when optimism is applied where it must not be. */
export class OptimismForbiddenError extends Error {
	constructor(readonly operation: string) {
		super(
			`${operation} is a finalization: the UI must not show success before the ` +
				`server confirms it (SRS-WEB-007)`
		);
		this.name = 'OptimismForbiddenError';
	}
}

/** The visible state of an optimistic operation. */
export type OptimisticState = 'idle' | 'pending' | 'confirmed' | 'rolled-back';

/** What the caller sees while and after an operation runs. */
export interface OptimisticResult<T> {
	readonly state: OptimisticState;
	readonly value: T;
	/** Set when the operation failed and the value was rolled back. */
	readonly error: Error | null;
}

/**
 * Applies a change optimistically and rolls it back if the server refuses.
 *
 * kind is required and checked. There is no default, because a default would
 * be 'reversible' — the convenient one — and the first finalization written by
 * someone in a hurry would inherit it.
 *
 * onChange is called at every transition rather than only at the end, so the
 * rollback is visible: SRS-WEB-007 asks for optimism only where "rollback is
 * visible", and a rollback the user never sees is indistinguishable from the
 * operation having worked.
 */
export async function optimistic<T>(params: {
	readonly operation: string;
	readonly kind: OperationKind;
	readonly current: T;
	readonly optimistic: T;
	readonly commit: () => Promise<T>;
	readonly onChange: (result: OptimisticResult<T>) => void;
}): Promise<OptimisticResult<T>> {
	if (params.kind === 'finalization') {
		throw new OptimismForbiddenError(params.operation);
	}

	params.onChange({ state: 'pending', value: params.optimistic, error: null });

	try {
		const confirmed = await params.commit();
		const result: OptimisticResult<T> = { state: 'confirmed', value: confirmed, error: null };
		params.onChange(result);
		return result;
	} catch (cause) {
		// Rolled back to the value from before the attempt, not to the
		// optimistic one. Leaving the optimistic value on screen after a
		// failure is the specific harm this module exists to prevent.
		const result: OptimisticResult<T> = {
			state: 'rolled-back',
			value: params.current,
			error: cause instanceof Error ? cause : new Error(String(cause))
		};
		params.onChange(result);
		return result;
	}
}

/**
 * Runs a finalization, showing success only once the server has confirmed.
 *
 * Deliberately has no optimistic parameter. The pending state exists so the UI
 * can disable the button and show progress — what it must not do is show the
 * outcome.
 */
export async function confirmed<T>(params: {
	readonly operation: string;
	readonly commit: () => Promise<T>;
	readonly onChange: (result: OptimisticResult<T | null>) => void;
}): Promise<OptimisticResult<T | null>> {
	params.onChange({ state: 'pending', value: null, error: null });

	try {
		const value = await params.commit();
		const result: OptimisticResult<T | null> = { state: 'confirmed', value, error: null };
		params.onChange(result);
		return result;
	} catch (cause) {
		const result: OptimisticResult<T | null> = {
			state: 'rolled-back',
			value: null,
			error: cause instanceof Error ? cause : new Error(String(cause))
		};
		params.onChange(result);
		return result;
	}
}

/**
 * Reports whether an operation may be shown optimistically.
 *
 * Exported so a component can decide which helper to call without duplicating
 * the rule, and so a test can assert the classification of a specific
 * operation rather than only the behaviour of the wrapper.
 */
export function mayBeOptimistic(kind: OperationKind): boolean {
	return kind === 'reversible';
}
