package jobs_test

import (
	"encoding/json"
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/platform/jobs"
)

var jobNow = time.Date(2026, 9, 11, 10, 0, 0, 0, time.UTC)

func newJob(t *testing.T) jobs.Job {
	t.Helper()
	j, err := jobs.New("job-1", "tenant-a", "security.export", "idem-1",
		"analyst-1", "corr-1", json.RawMessage(`{"from":"2026-01-01"}`), jobNow)
	if err != nil {
		t.Fatalf("New: %v", err)
	}
	return j
}

// SRS-API-011's verification clause: the caller receives a job id and can ask
// about its status. Both are true the instant the job is created, before any
// work has started.
func TestCallerGetsAnIdAndAStatusImmediately(t *testing.T) {
	j := newJob(t)

	if j.ID == "" {
		t.Fatal("the job has no id to give the caller")
	}
	if j.Status != jobs.StatusQueued {
		t.Fatalf("a new job is %s; the caller should see it queued", j.Status)
	}

	r := j.Response()
	if r.JobID != j.ID || r.Status != jobs.StatusQueued {
		t.Fatalf("the status response does not describe the job: %+v", r)
	}
	// The client is told when to ask again rather than inventing its own
	// interval, which in aggregate is what hammers a status endpoint.
	if r.RetryAfterSeconds <= 0 {
		t.Fatal("a queued job tells the caller nothing about when to poll")
	}
}

// A job's request can carry the filters of a PHI export, and the attempt count
// is nobody's business outside the service.
func TestTheStatusResponseWithholdsTheRequest(t *testing.T) {
	j := newJob(t)
	if err := j.Start(jobNow.Add(time.Second)); err != nil {
		t.Fatalf("Start: %v", err)
	}

	encoded, err := json.Marshal(j.Response())
	if err != nil {
		t.Fatalf("marshal: %v", err)
	}
	if strings.Contains(string(encoded), "2026-01-01") {
		t.Fatalf("the request payload leaked into the status response: %s", encoded)
	}
	if strings.Contains(string(encoded), "attempt") {
		t.Fatalf("the attempt count leaked into the status response: %s", encoded)
	}
}

func TestLifecycle(t *testing.T) {
	j := newJob(t)

	if err := j.Start(jobNow.Add(time.Second)); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if j.Status != jobs.StatusRunning || j.Attempt != 1 {
		t.Fatalf("after Start: status=%s attempt=%d", j.Status, j.Attempt)
	}

	if err := j.Progressing(40, "reading rows", jobNow.Add(2*time.Second)); err != nil {
		t.Fatalf("Progressing: %v", err)
	}
	if j.Progress != 40 {
		t.Fatalf("progress %d", j.Progress)
	}

	if err := j.Succeed(json.RawMessage(`{"object_key":"exports/x.csv"}`), jobNow.Add(time.Minute)); err != nil {
		t.Fatalf("Succeed: %v", err)
	}
	if j.Status != jobs.StatusSucceeded || j.Progress != 100 {
		t.Fatalf("after Succeed: status=%s progress=%d", j.Status, j.Progress)
	}
	// A terminal job tells the client to stop polling.
	if j.Response().RetryAfterSeconds != 0 {
		t.Fatal("a finished job still asks the client to poll")
	}
}

// A worker recomputing an estimate downward would make a progress bar jump
// back, which users read as a fault.
func TestProgressNeverGoesBackwards(t *testing.T) {
	j := newJob(t)
	if err := j.Start(jobNow); err != nil {
		t.Fatalf("Start: %v", err)
	}

	if err := j.Progressing(70, "most of the way", jobNow); err != nil {
		t.Fatalf("Progressing: %v", err)
	}
	if err := j.Progressing(30, "recomputed", jobNow); err != nil {
		t.Fatalf("Progressing: %v", err)
	}
	if j.Progress != 70 {
		t.Fatalf("progress went backwards to %d", j.Progress)
	}

	// Out-of-range values are clamped, not refused: failing a job because its
	// own estimate overshot would be absurd.
	if err := j.Progressing(150, "overshoot", jobNow); err != nil {
		t.Fatalf("Progressing: %v", err)
	}
	if j.Progress != 100 {
		t.Fatalf("progress %d, want the clamp at 100", j.Progress)
	}
}

// A partially written result must not be readable as the output of a job that
// failed.
func TestFailureClearsAnyPartialResult(t *testing.T) {
	j := newJob(t)
	if err := j.Start(jobNow); err != nil {
		t.Fatalf("Start: %v", err)
	}
	j.Result = json.RawMessage(`{"rows":5000}`)

	if err := j.Fail(jobs.Failure{
		Code: "EXPORT_QUERY_TIMEOUT", Message: "the export query timed out", Retryable: true,
	}, jobNow.Add(time.Minute)); err != nil {
		t.Fatalf("Fail: %v", err)
	}
	if j.Result != nil {
		t.Fatalf("a failed job still carries a result: %s", j.Result)
	}
	if j.Failure == nil || !j.Failure.Retryable {
		t.Fatalf("failure not recorded: %+v", j.Failure)
	}
}

// Cancelled is not failed. An operator looking at a failure rate should not
// see jobs somebody deliberately stopped.
func TestCancellationIsNotFailure(t *testing.T) {
	j := newJob(t)
	if err := j.Cancel(jobNow.Add(time.Second)); err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	if j.Status != jobs.StatusCancelled {
		t.Fatalf("status %s", j.Status)
	}
	if j.Failure != nil {
		t.Fatal("a cancelled job recorded a failure")
	}

	// A running job can also be cancelled; the worker notices through its
	// context, and this records the intention.
	running := newJob(t)
	if err := running.Start(jobNow); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := running.Cancel(jobNow.Add(time.Second)); err != nil {
		t.Fatalf("Cancel while running: %v", err)
	}
}

func TestTerminalJobsDoNotChange(t *testing.T) {
	j := newJob(t)
	if err := j.Start(jobNow); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := j.Succeed(nil, jobNow.Add(time.Minute)); err != nil {
		t.Fatalf("Succeed: %v", err)
	}

	for name, attempt := range map[string]func() error{
		"restart": func() error { return j.Start(jobNow.Add(2 * time.Minute)) },
		"succeed again": func() error {
			return j.Succeed(json.RawMessage(`{}`), jobNow.Add(2*time.Minute))
		},
		"fail": func() error {
			return j.Fail(jobs.Failure{Code: "X"}, jobNow.Add(2*time.Minute))
		},
		"cancel":   func() error { return j.Cancel(jobNow.Add(2 * time.Minute)) },
		"progress": func() error { return j.Progressing(50, "still going", jobNow) },
	} {
		t.Run(name, func(t *testing.T) {
			if err := attempt(); !errors.Is(err, jobs.ErrNotRunnable) {
				t.Fatalf("want ErrNotRunnable, got %v", err)
			}
		})
	}
}

// A worker picking up a job whose previous worker died restarts it, and the
// attempt counter is how that is told apart from a retry caused by the work
// itself failing.
func TestAnAbandonedJobCanBeRestartedAndCountsAttempts(t *testing.T) {
	j := newJob(t)
	if err := j.Start(jobNow); err != nil {
		t.Fatalf("Start: %v", err)
	}
	// The worker dies. Another picks it up.
	if err := j.Start(jobNow.Add(5 * time.Minute)); err != nil {
		t.Fatalf("restart: %v", err)
	}
	if j.Attempt != 2 {
		t.Fatalf("attempt %d, want 2", j.Attempt)
	}
}

func TestValidation(t *testing.T) {
	cases := map[string]func() error{
		"no kind": func() error {
			_, err := jobs.New("j", "t", "", "", "user", "corr", nil, jobNow)
			return err
		},
		// Without a correlation id the submission and the execution are two
		// unrelated events in the trace.
		"no correlation id": func() error {
			_, err := jobs.New("j", "t", "kind", "", "user", "", nil, jobNow)
			return err
		},
		"invalid request json": func() error {
			_, err := jobs.New("j", "t", "kind", "", "user", "corr",
				json.RawMessage(`{not json`), jobNow)
			return err
		},
		// A job describes work rather than carrying its data; a caller sending
		// a megabyte of inline rows should have uploaded a file.
		"oversized request": func() error {
			big := make([]byte, jobs.MaxRequestBytes+1)
			for i := range big {
				big[i] = 'a'
			}
			_, err := jobs.New("j", "t", "kind", "", "user", "corr",
				json.RawMessage(`"`+string(big)+`"`), jobNow)
			return err
		},
	}
	for name, build := range cases {
		t.Run(name, func(t *testing.T) {
			if err := build(); !errors.Is(err, jobs.ErrInvalidJob) {
				t.Fatalf("want ErrInvalidJob, got %v", err)
			}
		})
	}
}

func TestAFailureNeedsAStableCode(t *testing.T) {
	j := newJob(t)
	if err := j.Start(jobNow); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := j.Fail(jobs.Failure{Message: "it broke"}, jobNow); !errors.Is(err, jobs.ErrInvalidJob) {
		t.Fatalf("want ErrInvalidJob for a failure with no code, got %v", err)
	}
}

// There is no constructor for a finished job, so a caller cannot fabricate
// one — which matters because a job's result is evidence that work happened.
func TestAJobCannotBeCreatedAlreadyFinished(t *testing.T) {
	j := newJob(t)
	if j.Status.Terminal() {
		t.Fatal("a new job is already terminal")
	}
	if j.Result != nil || j.Failure != nil {
		t.Fatal("a new job already carries an outcome")
	}
	// Succeeding requires passing through Start, so a result cannot appear
	// without the job having run.
	if err := j.Succeed(json.RawMessage(`{}`), jobNow); !errors.Is(err, jobs.ErrNotRunnable) {
		t.Fatalf("a queued job was completed without starting: %v", err)
	}
}
