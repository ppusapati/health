import { describe, expect, it, vi } from 'vitest';
import {
	confirmed,
	mayBeOptimistic,
	optimistic,
	OptimismForbiddenError,
	type OptimisticResult
} from './optimistic.js';

describe('optimistic UI (SRS-WEB-007)', () => {
	it('shows the optimistic value while the server is deciding', async () => {
		const seen: OptimisticResult<string>[] = [];

		const result = await optimistic({
			operation: 'rename saved view',
			kind: 'reversible',
			current: 'Old name',
			optimistic: 'New name',
			commit: async () => 'New name',
			onChange: (r) => seen.push(r)
		});

		expect(seen.map((s) => s.state)).toEqual(['pending', 'confirmed']);
		expect(seen[0].value).toBe('New name');
		expect(result.state).toBe('confirmed');
	});

	it('rolls back visibly when the server refuses', async () => {
		// A rollback the user never sees is indistinguishable from the
		// operation having worked, which is why every transition is reported.
		const seen: OptimisticResult<string>[] = [];

		const result = await optimistic({
			operation: 'rename saved view',
			kind: 'reversible',
			current: 'Old name',
			optimistic: 'New name',
			commit: async () => {
				throw new Error('permission denied');
			},
			onChange: (r) => seen.push(r)
		});

		expect(seen.map((s) => s.state)).toEqual(['pending', 'rolled-back']);
		// Back to the value from before the attempt, not left on the optimistic
		// one: that is the specific harm being prevented.
		expect(result.value).toBe('Old name');
		expect(result.error?.message).toBe('permission denied');
	});
});

describe('finalizations are never optimistic', () => {
	it('refuses at runtime, not only in review', async () => {
		// A rule that lives in a code review is a rule that lasts until the
		// first deadline.
		await expect(
			optimistic({
				operation: 'administer medication',
				kind: 'finalization',
				current: 'not administered',
				optimistic: 'administered',
				commit: async () => 'administered',
				onChange: () => {}
			})
		).rejects.toBeInstanceOf(OptimismForbiddenError);
	});

	it('names the operation so the error is actionable', async () => {
		let thrown: unknown;
		try {
			await optimistic({
				operation: 'take payment',
				kind: 'finalization',
				current: 0,
				optimistic: 100,
				commit: async () => 100,
				onChange: () => {}
			});
		} catch (error) {
			thrown = error;
		}

		expect(thrown).toBeInstanceOf(OptimismForbiddenError);
		expect((thrown as OptimismForbiddenError).message).toContain('take payment');
		expect((thrown as OptimismForbiddenError).message).toContain('SRS-WEB-007');
	});

	it('shows no outcome until the server confirms', async () => {
		const seen: OptimisticResult<string | null>[] = [];
		let resolveCommit: ((value: string) => void) | null = null;

		const running = confirmed<string>({
			operation: 'sign progress note',
			commit: () =>
				new Promise<string>((resolve) => {
					resolveCommit = resolve;
				}),
			onChange: (r) => seen.push(r)
		});

		// While in flight the UI has a pending state to disable the button
		// with, and no value to render as success.
		expect(seen).toHaveLength(1);
		expect(seen[0].state).toBe('pending');
		expect(seen[0].value).toBeNull();

		resolveCommit!('signed');
		const result = await running;

		expect(result.state).toBe('confirmed');
		expect(result.value).toBe('signed');
	});

	it('reports a failed finalization as failed, with no value', async () => {
		const result = await confirmed<string>({
			operation: 'sign progress note',
			commit: async () => {
				throw new Error('the note was modified by another user');
			},
			onChange: () => {}
		});

		expect(result.state).toBe('rolled-back');
		expect(result.value).toBeNull();
		expect(result.error?.message).toContain('modified by another user');
	});
});

describe('classification', () => {
	it('is exported so components need not duplicate the rule', () => {
		expect(mayBeOptimistic('reversible')).toBe(true);
		expect(mayBeOptimistic('finalization')).toBe(false);
	});

	it('does not call commit for a forbidden operation', async () => {
		// The refusal must come before any request is sent, or a rejected
		// optimistic finalization would still have finalized on the server.
		const commit = vi.fn(async () => 'x');
		await optimistic({
			operation: 'sign note',
			kind: 'finalization',
			current: 'a',
			optimistic: 'b',
			commit,
			onChange: () => {}
		}).catch(() => {});
		expect(commit).not.toHaveBeenCalled();
	});
});
