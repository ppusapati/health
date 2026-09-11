// Package edge is the hospital edge prototype (P0-13).
//
// The architectural rule it exists to demonstrate: hospital operation must not
// depend on cloud availability (Blueprint §12). A ward does not stop admitting
// patients because a WAN link is down, so the edge has to keep working and
// reconcile afterwards — which means local durable storage, not an in-memory
// buffer that a power cut erases.
//
// Storage is SQLite on local disk via a pure-Go driver, so the edge bundle has
// no cgo toolchain requirement and no server process to operate.
//
// SCOPE: Wave-0 prototype. It does not claim SRS-ONB-DEV (Wave 9 device and
// SCADA commissioning) or the Wave-7 SCADA families.
package edge

import (
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	_ "modernc.org/sqlite"
)

// OperationStatus is the lifecycle of a queued operation.
type OperationStatus string

const (
	// StatusPending has not been accepted by the cloud.
	StatusPending OperationStatus = "pending"
	// StatusForwarded has been acknowledged and needs no further action.
	StatusForwarded OperationStatus = "forwarded"
	// StatusRejected was refused permanently and needs a human.
	StatusRejected OperationStatus = "rejected"
)

// Operation is one locally-captured action awaiting forwarding.
type Operation struct {
	// ID is generated at the edge and is the idempotency key the cloud
	// deduplicates on. Generating it locally is what lets the edge retry
	// safely without ever asking the cloud whether a previous attempt landed.
	ID         string
	TenantID   string
	Type       string
	Payload    json.RawMessage
	OccurredAt time.Time
	Status     OperationStatus
	Attempts   int
	LastError  string
}

// Queue is the durable store-and-forward buffer.
type Queue struct {
	db *sql.DB
}

const schema = `
CREATE TABLE IF NOT EXISTS operation (
    operation_id TEXT PRIMARY KEY,
    tenant_id    TEXT NOT NULL,
    type         TEXT NOT NULL,
    payload      TEXT NOT NULL,
    occurred_at  TEXT NOT NULL,
    status       TEXT NOT NULL,
    attempts     INTEGER NOT NULL DEFAULT 0,
    last_error   TEXT NOT NULL DEFAULT '',
    created_at   TEXT NOT NULL
);

-- The forwarder drains oldest-first so the cloud sees operations in the order
-- they happened at the bedside.
CREATE INDEX IF NOT EXISTS operation_pending_idx
    ON operation (status, occurred_at, operation_id);
`

// OpenQueue opens or creates the local queue at path.
func OpenQueue(path string) (*Queue, error) {
	// WAL keeps reads non-blocking while the forwarder writes, and
	// synchronous=FULL means an acknowledged enqueue has actually reached the
	// disk. An edge node loses power; that is the whole point of it.
	dsn := fmt.Sprintf("file:%s?_pragma=journal_mode(WAL)&_pragma=synchronous(FULL)&_pragma=busy_timeout(5000)", path)

	db, err := sql.Open("sqlite", dsn)
	if err != nil {
		return nil, err
	}
	// SQLite tolerates one writer. Constraining the pool avoids spurious
	// lock contention rather than relying on the busy timeout.
	db.SetMaxOpenConns(1)

	if _, err := db.ExecContext(context.Background(), schema); err != nil {
		db.Close()
		return nil, err
	}
	return &Queue{db: db}, nil
}

// Close releases the queue.
func (q *Queue) Close() error { return q.db.Close() }

// ErrInvalidOperation reports an operation that could never be forwarded.
var ErrInvalidOperation = errors.New("edge: invalid operation")

// Enqueue records an operation locally and returns once it is durable.
//
// It is idempotent on the operation ID: a caller that retries after a crash
// mid-write does not create a second copy.
func (q *Queue) Enqueue(ctx context.Context, op Operation) error {
	switch {
	case op.ID == "":
		return fmt.Errorf("%w: id is required", ErrInvalidOperation)
	case op.TenantID == "":
		return fmt.Errorf("%w: tenant_id is required", ErrInvalidOperation)
	case op.Type == "":
		return fmt.Errorf("%w: type is required", ErrInvalidOperation)
	case op.OccurredAt.IsZero():
		return fmt.Errorf("%w: occurred_at is required", ErrInvalidOperation)
	}

	payload := op.Payload
	if len(payload) == 0 {
		payload = json.RawMessage(`{}`)
	}

	_, err := q.db.ExecContext(ctx, `
		INSERT INTO operation (operation_id, tenant_id, type, payload, occurred_at, status, created_at)
		VALUES (?, ?, ?, ?, ?, ?, ?)
		ON CONFLICT (operation_id) DO NOTHING`,
		op.ID, op.TenantID, op.Type, string(payload),
		op.OccurredAt.UTC().Format(time.RFC3339Nano),
		string(StatusPending),
		time.Now().UTC().Format(time.RFC3339Nano),
	)
	return err
}

// Pending returns up to limit operations awaiting forwarding, oldest first.
func (q *Queue) Pending(ctx context.Context, limit int) ([]Operation, error) {
	rows, err := q.db.QueryContext(ctx, `
		SELECT operation_id, tenant_id, type, payload, occurred_at, status, attempts, last_error
		FROM operation
		WHERE status = ?
		ORDER BY occurred_at, operation_id
		LIMIT ?`, string(StatusPending), limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []Operation
	for rows.Next() {
		var op Operation
		var payload, occurredAt, status string

		if err := rows.Scan(&op.ID, &op.TenantID, &op.Type, &payload,
			&occurredAt, &status, &op.Attempts, &op.LastError); err != nil {
			return nil, err
		}

		parsed, err := time.Parse(time.RFC3339Nano, occurredAt)
		if err != nil {
			return nil, err
		}
		op.Payload = json.RawMessage(payload)
		op.OccurredAt = parsed
		op.Status = OperationStatus(status)
		out = append(out, op)
	}
	return out, rows.Err()
}

// MarkForwarded records cloud acknowledgement.
func (q *Queue) MarkForwarded(ctx context.Context, operationID string) error {
	_, err := q.db.ExecContext(ctx,
		`UPDATE operation SET status = ?, last_error = '' WHERE operation_id = ?`,
		string(StatusForwarded), operationID)
	return err
}

// MarkRejected records a permanent refusal. The row is kept, not deleted: an
// operation the cloud refused is exactly what an operator needs to see.
func (q *Queue) MarkRejected(ctx context.Context, operationID, reason string) error {
	_, err := q.db.ExecContext(ctx,
		`UPDATE operation SET status = ?, last_error = ? WHERE operation_id = ?`,
		string(StatusRejected), reason, operationID)
	return err
}

// RecordFailure increments the attempt counter and keeps the operation pending.
func (q *Queue) RecordFailure(ctx context.Context, operationID, reason string) error {
	_, err := q.db.ExecContext(ctx,
		`UPDATE operation SET attempts = attempts + 1, last_error = ? WHERE operation_id = ?`,
		reason, operationID)
	return err
}

// Counts summarises the queue for the local operator display.
type Counts struct {
	Pending   int
	Forwarded int
	Rejected  int
}

// Counts returns the queue summary.
func (q *Queue) Counts(ctx context.Context) (Counts, error) {
	rows, err := q.db.QueryContext(ctx, `SELECT status, count(*) FROM operation GROUP BY status`)
	if err != nil {
		return Counts{}, err
	}
	defer rows.Close()

	var counts Counts
	for rows.Next() {
		var status string
		var n int
		if err := rows.Scan(&status, &n); err != nil {
			return Counts{}, err
		}
		switch OperationStatus(status) {
		case StatusPending:
			counts.Pending = n
		case StatusForwarded:
			counts.Forwarded = n
		case StatusRejected:
			counts.Rejected = n
		}
	}
	return counts, rows.Err()
}
