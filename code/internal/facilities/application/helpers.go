package application

import (
	"time"

	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// parseTime reads an optional RFC 3339 timestamp from the wire.
//
// An empty string is absent, which is different from a zero time somebody
// meant: a commissioning date nobody knows and one somebody set to the epoch
// are different facts and only the first is honest.
func parseTime(value string) (time.Time, error) {
	if value == "" {
		return time.Time{}, nil
	}
	parsed, err := time.Parse(time.RFC3339, value)
	if err != nil {
		return time.Time{}, rpcerr.Invalid("FAC_BAD_TIME",
			"timestamps are RFC 3339").WithCause(err)
	}
	return parsed.UTC(), nil
}

// expected resolves the optimistic-concurrency version a caller supplied.
//
// Zero means the caller did not track one, in which case the version just
// read is used. That is deliberately weaker than demanding one: a screen that
// does not round-trip the version would otherwise be unable to write at all,
// and the lost update it risks is bounded by the transaction.
func expected(supplied, current int64) int64 {
	if supplied <= 0 {
		return current
	}
	return supplied
}

// applied is the version a successful update produced.
//
// Every UPDATE in the adapter is "version = version + 1 WHERE version =
// @expected_version", so a write that succeeded produced exactly expected+1.
// Without putting it back on the entity, every mutating response carries the
// version the row had *before* the call — and a client that round-trips it,
// which the contract invites since every mutating request has a version
// field, gets a conflict on its second call with no way to tell that from a
// real concurrent edit.
func applied(expectedVersion int64) int64 { return expectedVersion + 1 }

func boolText(value bool) string {
	if value {
		return "true"
	}
	return "false"
}

// timeNow is the clock's reading, named so the shared read-change-write
// signatures below read as English rather than as a wall of time.Time.
type timeNow = time.Time
