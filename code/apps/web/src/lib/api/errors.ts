/**
 * Error presentation.
 *
 * The server returns a stable machine code plus field violations
 * (SRS-API-004); the browser is responsible for turning those into language a
 * user can act on. Display strings live here and nowhere else, so wording stays
 * consistent and remains translatable (SRS-NFR-008).
 */
import { ConnectError, Code } from '@connectrpc/connect';
import { ErrorDetailSchema, type ErrorDetail } from '$gen/healthcare/common/v1/common_pb.js';

/** What a screen needs in order to render a failure. */
export interface PresentedError {
	/** Short, user-facing sentence. Never a stack trace or driver message. */
	readonly message: string;
	/** Stable machine code for support and telemetry. */
	readonly code: string;
	/** Correlation ID to quote to support (SRS-WEB-011). */
	readonly correlationId: string;
	/** Field path to reason code, for inline form errors. */
	readonly fieldViolations: Record<string, string>;
	/** Whether an identical retry is safe. */
	readonly retryable: boolean;
}

const messageByCode: Record<Code, string> = {
	[Code.Canceled]: 'The request was cancelled.',
	[Code.Unknown]: 'Something went wrong. Please try again.',
	[Code.InvalidArgument]: 'Please correct the highlighted fields.',
	[Code.DeadlineExceeded]: 'The request took too long. Please try again.',
	[Code.NotFound]: 'That record could not be found.',
	[Code.AlreadyExists]: 'That record already exists.',
	[Code.PermissionDenied]: 'You do not have permission to do that.',
	[Code.ResourceExhausted]: 'Too many requests. Please wait and try again.',
	[Code.FailedPrecondition]: 'That action is not available in the current state.',
	[Code.Aborted]: 'The record changed while you were editing. Reload and try again.',
	[Code.OutOfRange]: 'That value is out of range.',
	[Code.Unimplemented]: 'That feature is not available.',
	[Code.Internal]: 'Something went wrong. Please try again.',
	[Code.Unavailable]: 'The service is temporarily unavailable. Please try again.',
	[Code.DataLoss]: 'Something went wrong. Please try again.',
	[Code.Unauthenticated]: 'Your session has expired. Please sign in again.'
};

/** Field reason codes rendered as guidance next to the input. */
const messageByReason: Record<string, string> = {
	REQUIRED: 'This field is required.',
	INVALID_FORMAT: 'Use 2–32 characters: letters, digits, hyphen or underscore.',
	UNSUPPORTED: 'Choose one of the available options.',
	UNKNOWN_IANA_ZONE: 'Choose a valid time zone.',
	MUST_BE_ISO_3166_ALPHA2: 'Use a two-letter country code.',
	MALFORMED: 'This value is not valid.'
};

/** Returns the guidance for a field reason code, or the code itself. */
export function describeFieldReason(reason: string): string {
	return messageByReason[reason] ?? reason;
}

/** Converts any thrown value into something a screen can render. */
export function presentError(error: unknown): PresentedError {
	if (!(error instanceof ConnectError)) {
		return {
			message: messageByCode[Code.Unknown],
			code: 'UNKNOWN',
			correlationId: '',
			fieldViolations: {},
			retryable: false
		};
	}

	const detail = findErrorDetail(error);
	const fieldViolations: Record<string, string> = {};
	for (const violation of detail?.fieldViolations ?? []) {
		fieldViolations[violation.field] = violation.reason;
	}

	return {
		message: messageByCode[error.code] ?? messageByCode[Code.Unknown],
		code: detail?.code ?? Code[error.code],
		correlationId: detail?.correlationId ?? '',
		fieldViolations,
		retryable: detail?.retryable ?? false
	};
}

function findErrorDetail(error: ConnectError): ErrorDetail | undefined {
	for (const detail of error.findDetails(ErrorDetailSchema)) {
		return detail;
	}
	return undefined;
}
