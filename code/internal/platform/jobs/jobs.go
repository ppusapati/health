// Package jobs runs work that must not happen inside a request.
//
// SRS-API-011: exports, bulk imports and long-running integrations use an
// asynchronous job, verified by "caller receives job/workflow ID and status
// endpoint". The requirement is about the contract, not the executor: whatever
// runs the work, the caller gets an identifier immediately and can ask about
// it later.
//
// This is deliberately not the workflow engine. A workflow (ADR-006)
// coordinates steps across contexts with compensation and human tasks; a job
// is one unit of work with a result. Using the workflow engine for an export
// would put durable timers and compensation in the way of "run this query and
// put the file somewhere", and using a job for a clinical process would lose
// the compensation a clinical process needs.
package jobs

import (
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"
)

// Status is where a job is.
type Status string

const (
	// StatusQueued is accepted and not yet started. This is what the caller
	// sees in the response to their submission.
	StatusQueued    Status = "queued"
	StatusRunning   Status = "running"
	StatusSucceeded Status = "succeeded"
	StatusFailed    Status = "failed"
	// StatusCancelled was stopped on request. Distinct from failed: nothing
	// went wrong, and an operator looking at a failure rate should not see it.
	StatusCancelled Status = "cancelled"
)

// Terminal reports whether a status can still change.
func (s Status) Terminal() bool {
	return s == StatusSucceeded || s == StatusFailed || s == StatusCancelled
}

// Job is one unit of asynchronous work.
type Job struct {
	ID       string
	TenantID string
	// Kind names what the job does: "security.export", "organization.import".
	Kind string
	// IdempotencyKey lets a caller retry a submission without starting the
	// work twice. A network timeout on submission is indistinguishable from a
	// rejection, so without this a retried bulk import runs twice.
	IdempotencyKey string

	Status  Status
	Request json.RawMessage

	// Progress is 0-100. Advisory only: a caller must not infer completion
	// from it, because a job that dies at 99 never reaches 100 and a caller
	// waiting for the number would wait forever. Status is the truth.
	Progress int
	// Message is a human-readable note about the current step.
	Message string

	// Result is set on success, Failure on failure. Never both.
	Result  json.RawMessage
	Failure *Failure

	SubmittedBy string
	SubmittedAt time.Time
	StartedAt   time.Time
	FinishedAt  time.Time
	// Attempt counts starts, so a job retried by a worker that died mid-run is
	// distinguishable from one retried because the work itself failed.
	Attempt int
	// CorrelationID ties the job back to the request that submitted it, so a
	// trace spans the submission and the execution.
	CorrelationID string
	Version       int64
}

// Failure describes why a job did not succeed.
type Failure struct {
	// Code is stable and machine-readable.
	Code string
	// Message is safe to show a user: no PHI, no internal detail.
	Message string
	// Retryable says whether submitting the same work again might succeed. A
	// malformed import file is not retryable; a database timeout is.
	Retryable bool
}

// Errors returned by this package.
var (
	// ErrInvalidJob reports a job that must not be queued.
	ErrInvalidJob = errors.New("jobs: invalid job")
	// ErrNotRunnable reports a transition from a state that does not allow it.
	ErrNotRunnable = errors.New("jobs: job is not in a state that allows this")
)

// MaxRequestBytes bounds a job's stored request.
//
// A job request is a description of work — a query, a file reference, a set of
// filters — not the data itself. A caller sending a megabyte of inline rows is
// a caller who should have uploaded a file, and storing it would make the job
// table grow like a blob store.
const MaxRequestBytes = 64 << 10

// New queues a job.
//
// It always starts queued. There is no constructor for a running or completed
// job, so a caller cannot fabricate a finished one — which matters because a
// job's result is evidence that work happened.
func New(id, tenantID, kind, idempotencyKey, submittedBy, correlationID string,
	request json.RawMessage, now time.Time) (Job, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Job{}, fmt.Errorf("%w: id is required", ErrInvalidJob)
	case strings.TrimSpace(tenantID) == "":
		return Job{}, fmt.Errorf("%w: tenant is required", ErrInvalidJob)
	case strings.TrimSpace(kind) == "":
		return Job{}, fmt.Errorf("%w: kind is required", ErrInvalidJob)
	case strings.TrimSpace(submittedBy) == "":
		return Job{}, fmt.Errorf("%w: submitting user is required", ErrInvalidJob)
	case strings.TrimSpace(correlationID) == "":
		// Without it the submission and the execution are two unrelated events
		// in the trace, and nobody can answer "what happened to my export?".
		return Job{}, fmt.Errorf("%w: correlation id is required", ErrInvalidJob)
	case len(request) > MaxRequestBytes:
		return Job{}, fmt.Errorf("%w: request is %d bytes, over the %d limit; "+
			"a job describes work rather than carrying its data",
			ErrInvalidJob, len(request), MaxRequestBytes)
	}
	if len(request) > 0 && !json.Valid(request) {
		return Job{}, fmt.Errorf("%w: request must be valid JSON", ErrInvalidJob)
	}
	if len(request) == 0 {
		request = json.RawMessage(`{}`)
	}

	return Job{
		ID: id, TenantID: tenantID, Kind: kind, IdempotencyKey: idempotencyKey,
		Status: StatusQueued, Request: request,
		SubmittedBy: submittedBy, SubmittedAt: now.UTC(),
		CorrelationID: correlationID, Version: 1,
	}, nil
}

// Start marks a job as running.
//
// Also callable on a job that is already running, which is what a worker
// picking up an abandoned job does: the previous worker died without
// finishing, and the attempt counter is how that is told apart from a retry
// caused by the work itself failing.
func (j *Job) Start(now time.Time) error {
	if j.Status.Terminal() {
		return fmt.Errorf("%w: job is %s", ErrNotRunnable, j.Status)
	}
	j.Status = StatusRunning
	j.StartedAt = now.UTC()
	j.Attempt++
	j.Version++
	return nil
}

// Progressing records advancement without changing status.
func (j *Job) Progressing(percent int, message string, now time.Time) error {
	if j.Status != StatusRunning {
		return fmt.Errorf("%w: job is %s", ErrNotRunnable, j.Status)
	}
	switch {
	case percent < 0:
		percent = 0
	case percent > 100:
		// Clamped rather than refused: a progress report is advisory, and
		// failing a job because its own estimate overshot would be absurd.
		percent = 100
	}
	// Never goes backwards. A worker recomputing an estimate downward would
	// otherwise make a progress bar jump back, which users read as a fault.
	if percent > j.Progress {
		j.Progress = percent
	}
	j.Message = message
	j.Version++
	return nil
}

// Succeed completes a job with its result.
func (j *Job) Succeed(result json.RawMessage, now time.Time) error {
	if j.Status != StatusRunning {
		return fmt.Errorf("%w: job is %s", ErrNotRunnable, j.Status)
	}
	if len(result) > 0 && !json.Valid(result) {
		return fmt.Errorf("%w: result must be valid JSON", ErrInvalidJob)
	}
	j.Status = StatusSucceeded
	j.Result = result
	j.Failure = nil
	j.Progress = 100
	j.FinishedAt = now.UTC()
	j.Version++
	return nil
}

// Fail completes a job with a reason.
func (j *Job) Fail(f Failure, now time.Time) error {
	if j.Status.Terminal() {
		return fmt.Errorf("%w: job is already %s", ErrNotRunnable, j.Status)
	}
	if strings.TrimSpace(f.Code) == "" {
		return fmt.Errorf("%w: a failure needs a stable code", ErrInvalidJob)
	}
	j.Status = StatusFailed
	j.Failure = &f
	// The result is cleared, so a partially written result cannot be read as
	// the output of a job that failed.
	j.Result = nil
	j.FinishedAt = now.UTC()
	j.Version++
	return nil
}

// Cancel stops a job on request.
//
// A queued job cancels cleanly. A running one is marked cancelled and the
// worker is expected to notice through its context — this records the
// intention, and the worker's own cancellation is what stops the work.
func (j *Job) Cancel(now time.Time) error {
	if j.Status.Terminal() {
		return fmt.Errorf("%w: job is already %s", ErrNotRunnable, j.Status)
	}
	j.Status = StatusCancelled
	j.FinishedAt = now.UTC()
	j.Version++
	return nil
}

// StatusResponse is what a caller polling the status endpoint receives.
//
// A distinct type from Job because the request payload and the internal
// attempt count are nobody's business outside the service, and a job's request
// can contain the filters of a PHI export.
type StatusResponse struct {
	JobID       string          `json:"job_id"`
	Kind        string          `json:"kind"`
	Status      Status          `json:"status"`
	Progress    int             `json:"progress"`
	Message     string          `json:"message,omitempty"`
	Result      json.RawMessage `json:"result,omitempty"`
	Failure     *Failure        `json:"failure,omitempty"`
	SubmittedAt time.Time       `json:"submitted_at"`
	FinishedAt  *time.Time      `json:"finished_at,omitempty"`
	// RetryAfterSeconds tells a polling caller when to ask again, so clients
	// do not each invent their own interval and collectively hammer the
	// endpoint.
	RetryAfterSeconds int `json:"retry_after_seconds,omitempty"`
}

// pollInterval spaces out polling by how far along the job is.
//
// A queued job is unlikely to finish in the next second, so there is no point
// asking; a running one may finish at any moment. Returning the interval to
// the client is what stops every client inventing its own and hammering the
// endpoint in aggregate.
func pollInterval(status Status) int {
	switch status {
	case StatusQueued:
		return 5
	case StatusRunning:
		return 2
	default:
		return 0 // terminal: do not poll again
	}
}

// Response projects a job into what a caller may see.
func (j Job) Response() StatusResponse {
	r := StatusResponse{
		JobID: j.ID, Kind: j.Kind, Status: j.Status,
		Progress: j.Progress, Message: j.Message,
		Result: j.Result, Failure: j.Failure,
		SubmittedAt:       j.SubmittedAt,
		RetryAfterSeconds: pollInterval(j.Status),
	}
	if !j.FinishedAt.IsZero() {
		finished := j.FinishedAt
		r.FinishedAt = &finished
	}
	return r
}
