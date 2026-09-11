// Package transport holds the shared ConnectRPC plumbing: authentication,
// correlation, tracing and the single place where domain errors become wire
// statuses.
//
// Handlers do transport mapping and validation only; business rules stay in the
// application and domain layers (SRS-API-006).
package transport

import (
	"errors"
	"log/slog"

	"connectrpc.com/connect"
	commonv1 "github.com/ppusapati/health/code/gen/go/healthcare/common/v1"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// codeFor maps the platform error taxonomy onto Connect codes. Keeping the
// mapping in one table means a new category cannot silently default to
// "unknown" in one handler and "internal" in another.
var codeFor = map[rpcerr.Category]connect.Code{
	rpcerr.CategoryInvalidArgument:    connect.CodeInvalidArgument,
	rpcerr.CategoryUnauthenticated:    connect.CodeUnauthenticated,
	rpcerr.CategoryPermissionDenied:   connect.CodePermissionDenied,
	rpcerr.CategoryNotFound:           connect.CodeNotFound,
	rpcerr.CategoryAlreadyExists:      connect.CodeAlreadyExists,
	rpcerr.CategoryFailedPrecondition: connect.CodeFailedPrecondition,
	rpcerr.CategoryAborted:            connect.CodeAborted,
	rpcerr.CategoryInternal:           connect.CodeInternal,
}

// ToConnect converts an application error into a Connect error carrying a
// structured ErrorDetail.
//
// An unrecognised error is reported as INTERNAL with a generic message: an
// unexpected fault must never leak a driver string or a stack trace to the
// caller (Domain/Data spec §7). The detail still carries the correlation ID so
// support can find the matching log line.
func ToConnect(err error, correlationID string) error {
	if err == nil {
		return nil
	}

	domainErr, ok := rpcerr.As(err)
	if !ok {
		slog.Error("unhandled error",
			slog.String("correlation_id", correlationID),
			slog.String("error", err.Error()))
		domainErr = rpcerr.Internal("INTERNAL", "an unexpected error occurred")
	}

	code, known := codeFor[domainErr.Category]
	if !known {
		code = connect.CodeInternal
	}

	// Internal faults are logged with their cause and returned without it.
	if domainErr.Category == rpcerr.CategoryInternal {
		if cause := errors.Unwrap(domainErr); cause != nil {
			slog.Error("internal error",
				slog.String("correlation_id", correlationID),
				slog.String("code", domainErr.Code),
				slog.String("cause", cause.Error()))
		}
	}

	connectErr := connect.NewError(code, errors.New(domainErr.Message))

	detail := &commonv1.ErrorDetail{
		Code:          domainErr.Code,
		Retryable:     domainErr.Retryable,
		CorrelationId: correlationID,
	}
	for _, v := range domainErr.Violations {
		detail.FieldViolations = append(detail.FieldViolations, &commonv1.FieldViolation{
			Field:  v.Field,
			Reason: v.Reason,
		})
	}

	if d, detailErr := connect.NewErrorDetail(detail); detailErr == nil {
		connectErr.AddDetail(d)
	}
	return connectErr
}
