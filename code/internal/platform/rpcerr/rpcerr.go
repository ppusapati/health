// Package rpcerr defines the platform's structured error contract.
//
// Domain and application layers return *Error values carrying a stable machine
// code; only the transport layer translates them to Connect statuses. This
// keeps SRS-API-004 ("structured domain error codes independent of display
// message") true by construction — the domain never imports connect.
package rpcerr

import (
	"errors"
	"fmt"
)

// Category maps onto the Connect/gRPC status taxonomy from the Domain, Data,
// API, Event & Security Architecture Specification §7.
type Category string

const (
	CategoryInvalidArgument    Category = "INVALID_ARGUMENT"
	CategoryUnauthenticated    Category = "UNAUTHENTICATED"
	CategoryPermissionDenied   Category = "PERMISSION_DENIED"
	CategoryNotFound           Category = "NOT_FOUND"
	CategoryAlreadyExists      Category = "ALREADY_EXISTS"
	CategoryFailedPrecondition Category = "FAILED_PRECONDITION"
	CategoryAborted            Category = "ABORTED"
	CategoryResourceExhausted  Category = "RESOURCE_EXHAUSTED"
	CategoryInternal           Category = "INTERNAL"
)

// FieldViolation is a stable reason code against a dotted field path. The
// reason is never prose: clients localise from the code.
type FieldViolation struct {
	Field  string
	Reason string
}

// Error is the platform error type.
type Error struct {
	Category   Category
	Code       string
	Message    string
	Violations []FieldViolation
	Retryable  bool
	cause      error
}

func (e *Error) Error() string {
	if e.cause != nil {
		return fmt.Sprintf("%s/%s: %s: %v", e.Category, e.Code, e.Message, e.cause)
	}
	return fmt.Sprintf("%s/%s: %s", e.Category, e.Code, e.Message)
}

func (e *Error) Unwrap() error { return e.cause }

// WithCause attaches an underlying error for logging without exposing it to
// clients.
func (e *Error) WithCause(err error) *Error {
	clone := *e
	clone.cause = err
	return &clone
}

// As extracts a *Error from an error chain.
func As(err error) (*Error, bool) {
	var target *Error
	ok := errors.As(err, &target)
	return target, ok
}

// Invalid builds an INVALID_ARGUMENT error. Not retryable: the caller must
// change the request.
func Invalid(code, message string, violations ...FieldViolation) *Error {
	return &Error{Category: CategoryInvalidArgument, Code: code, Message: message, Violations: violations}
}

// Unauthenticated builds an UNAUTHENTICATED error.
func Unauthenticated(code, message string) *Error {
	return &Error{Category: CategoryUnauthenticated, Code: code, Message: message}
}

// PermissionDenied builds a PERMISSION_DENIED error. Never retryable without a
// change in authority.
func PermissionDenied(code, message string) *Error {
	return &Error{Category: CategoryPermissionDenied, Code: code, Message: message}
}

// NotFound builds a NOT_FOUND error. Also used to conceal resources the caller
// is not entitled to know exist.
func NotFound(code, message string) *Error {
	return &Error{Category: CategoryNotFound, Code: code, Message: message}
}

// AlreadyExists builds an ALREADY_EXISTS error for uniqueness conflicts.
func AlreadyExists(code, message string) *Error {
	return &Error{Category: CategoryAlreadyExists, Code: code, Message: message}
}

// FailedPrecondition builds a FAILED_PRECONDITION error for blocked state
// transitions.
func FailedPrecondition(code, message string) *Error {
	return &Error{Category: CategoryFailedPrecondition, Code: code, Message: message}
}

// ResourceExhausted builds a RESOURCE_EXHAUSTED error. Retryable by
// definition: the caller should back off, unlike a permission failure.
func ResourceExhausted(code, message string) *Error {
	return &Error{Category: CategoryResourceExhausted, Code: code, Message: message, Retryable: true}
}

// Internal builds an INTERNAL error. Retryable is left false: an unexpected
// fault must not invite a hot retry loop.
func Internal(code, message string) *Error {
	return &Error{Category: CategoryInternal, Code: code, Message: message}
}
