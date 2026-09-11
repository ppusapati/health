import { describe, expect, it } from 'vitest';
import { Code, ConnectError } from '@connectrpc/connect';
import { create } from '@bufbuild/protobuf';
import { ErrorDetailSchema } from '$gen/healthcare/common/v1/common_pb.js';
import { describeFieldReason, presentError } from './errors.js';

function connectErrorWithDetail(code: Code, detail: Record<string, unknown>) {
	return new ConnectError('server message', code, undefined, [
		{ desc: ErrorDetailSchema, value: create(ErrorDetailSchema, detail) }
	]);
}

describe('presentError', () => {
	it('surfaces the machine code and correlation ID for support', () => {
		const err = connectErrorWithDetail(Code.InvalidArgument, {
			code: 'ORG_FACILITY_INVALID',
			correlationId: 'corr-123',
			retryable: false,
			fieldViolations: [
				{ field: 'code', reason: 'INVALID_FORMAT' },
				{ field: 'display_name', reason: 'REQUIRED' }
			]
		});

		const presented = presentError(err);

		expect(presented.code).toBe('ORG_FACILITY_INVALID');
		expect(presented.correlationId).toBe('corr-123');
		expect(presented.fieldViolations).toEqual({
			code: 'INVALID_FORMAT',
			display_name: 'REQUIRED'
		});
	});

	// The server's message may quote user input or internal detail; the browser
	// shows its own wording instead (SRS-WEB-011).
	it('does not display the raw server message', () => {
		const err = connectErrorWithDetail(Code.Internal, {
			code: 'ORG_WRITE_FAILED',
			correlationId: 'corr-9'
		});

		const presented = presentError(err);

		expect(presented.message).not.toContain('server message');
		expect(presented.message).toBe('Something went wrong. Please try again.');
	});

	it('maps each status to distinct user guidance', () => {
		const denied = presentError(connectErrorWithDetail(Code.PermissionDenied, { code: 'X' }));
		const notFound = presentError(connectErrorWithDetail(Code.NotFound, { code: 'Y' }));
		const expired = presentError(connectErrorWithDetail(Code.Unauthenticated, { code: 'Z' }));

		expect(denied.message).toBe('You do not have permission to do that.');
		expect(notFound.message).toBe('That record could not be found.');
		expect(expired.message).toBe('Your session has expired. Please sign in again.');
	});

	it('carries the retryable flag through', () => {
		const err = connectErrorWithDetail(Code.Unavailable, { code: 'X', retryable: true });
		expect(presentError(err).retryable).toBe(true);
	});

	// A network failure or a thrown string must still render something sane
	// rather than crashing the screen.
	it('handles non-Connect failures', () => {
		const presented = presentError(new TypeError('network down'));

		expect(presented.code).toBe('UNKNOWN');
		expect(presented.message).toBe('Something went wrong. Please try again.');
		expect(presented.fieldViolations).toEqual({});
	});

	it('tolerates an error with no detail attached', () => {
		const presented = presentError(new ConnectError('boom', Code.Internal));

		expect(presented.correlationId).toBe('');
		expect(presented.code).toBe('Internal');
	});
});

describe('describeFieldReason', () => {
	it('translates known reason codes into guidance', () => {
		expect(describeFieldReason('REQUIRED')).toBe('This field is required.');
		expect(describeFieldReason('UNKNOWN_IANA_ZONE')).toBe('Choose a valid time zone.');
	});

	// An unmapped code must still render something rather than "undefined".
	it('falls back to the raw code', () => {
		expect(describeFieldReason('SOME_NEW_REASON')).toBe('SOME_NEW_REASON');
	});
});
