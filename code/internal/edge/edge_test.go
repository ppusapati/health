package edge_test

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"path/filepath"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/edge"
)

var at = time.Date(2026, 9, 11, 9, 0, 0, 0, time.UTC)

func newQueue(t *testing.T) *edge.Queue {
	t.Helper()
	q, err := edge.OpenQueue(filepath.Join(t.TempDir(), "edge.db"))
	if err != nil {
		t.Fatalf("OpenQueue: %v", err)
	}
	t.Cleanup(func() { _ = q.Close() })
	return q
}

// fakeUplink models the WAN. Flipping `up` is exactly a link failure.
type fakeUplink struct {
	mu       sync.Mutex
	up       bool
	received []edge.Operation
	// seen tracks operation IDs so the fake can behave like the real cloud:
	// idempotent on the client-supplied ID.
	seen   map[string]bool
	reject map[string]string
}

func newUplink() *fakeUplink {
	return &fakeUplink{up: true, seen: map[string]bool{}, reject: map[string]string{}}
}

func (f *fakeUplink) Forward(_ context.Context, op edge.Operation) error {
	f.mu.Lock()
	defer f.mu.Unlock()

	if !f.up {
		return edge.ErrUnreachable
	}
	if reason, rejected := f.reject[op.ID]; rejected {
		return edge.PermanentRejection{Reason: reason}
	}
	if f.seen[op.ID] {
		// A duplicate is acknowledged without a second side effect, which is
		// what makes edge retries safe.
		return nil
	}
	f.seen[op.ID] = true
	f.received = append(f.received, op)
	return nil
}

func (f *fakeUplink) setUp(up bool) {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.up = up
}

func (f *fakeUplink) count() int {
	f.mu.Lock()
	defer f.mu.Unlock()
	return len(f.received)
}

func (f *fakeUplink) operations() []edge.Operation {
	f.mu.Lock()
	defer f.mu.Unlock()
	return append([]edge.Operation(nil), f.received...)
}

// recordingPrinter stands in for the local label printer.
type recordingPrinter struct {
	mu      sync.Mutex
	printed [][]byte
	fail    error
}

func (p *recordingPrinter) Print(_ context.Context, payload []byte) error {
	p.mu.Lock()
	defer p.mu.Unlock()
	if p.fail != nil {
		return p.fail
	}
	p.printed = append(p.printed, payload)
	return nil
}

func (p *recordingPrinter) count() int {
	p.mu.Lock()
	defer p.mu.Unlock()
	return len(p.printed)
}

func op(id string, offset time.Duration) edge.Operation {
	return edge.Operation{
		ID:         id,
		TenantID:   "tenant-a",
		Type:       "edge.label_printed",
		Payload:    json.RawMessage(`{"kind":"specimen"}`),
		OccurredAt: at.Add(offset),
	}
}

// P0-13 exit criterion: a WAN-loss scenario retains approved local functions
// and reconciles safely on recovery.
func TestWanLossRetainsLocalFunctionAndReconciles(t *testing.T) {
	ctx := context.Background()
	queue := newQueue(t)
	uplink := newUplink()
	printer := &recordingPrinter{}

	var seq int
	ids := func() string { seq++; return fmt.Sprintf("op-%03d", seq) }
	clock := at
	now := func() time.Time { clock = clock.Add(time.Minute); return clock }

	labels := edge.NewLabelService(printer, queue, ids, now)
	forwarder := edge.NewForwarder(queue, uplink, 10)

	// --- link up: one label, forwarded normally -------------------------
	if err := labels.Print(ctx, edge.LabelRequest{
		TenantID: "tenant-a", FacilityID: "facility-1",
		Kind: "specimen", Barcode: "ACC-0001", Lines: []string{"SMITH, JOHN"},
	}); err != nil {
		t.Fatalf("print while online: %v", err)
	}
	if _, err := forwarder.Drain(ctx); err != nil {
		t.Fatalf("drain while online: %v", err)
	}
	if uplink.count() != 1 {
		t.Fatalf("cloud received %d operations, want 1", uplink.count())
	}

	// --- WAN goes down --------------------------------------------------
	uplink.setUp(false)

	// The ward keeps labelling. This is the behaviour that matters: local
	// function must not depend on the cloud.
	for i := 0; i < 5; i++ {
		if err := labels.Print(ctx, edge.LabelRequest{
			TenantID: "tenant-a", FacilityID: "facility-1",
			Kind: "specimen", Barcode: fmt.Sprintf("ACC-%04d", i+2),
			Lines: []string{"SMITH, JOHN"},
		}); err != nil {
			t.Fatalf("print during outage %d: %v", i, err)
		}
	}
	if printer.count() != 6 {
		t.Fatalf("printer produced %d labels, want 6 — local function degraded during WAN loss", printer.count())
	}

	result, err := forwarder.Drain(ctx)
	if err != nil {
		t.Fatalf("drain during outage: %v", err)
	}
	if result.Forwarded != 0 {
		t.Fatalf("forwarded %d operations with the link down", result.Forwarded)
	}
	if result.Deferred != 5 {
		t.Fatalf("deferred %d, want 5", result.Deferred)
	}

	counts, err := queue.Counts(ctx)
	if err != nil {
		t.Fatalf("Counts: %v", err)
	}
	if counts.Pending != 5 {
		t.Fatalf("pending = %d, want 5 — work must be retained, never dropped", counts.Pending)
	}

	// --- link recovers --------------------------------------------------
	uplink.setUp(true)

	result, err = forwarder.Drain(ctx)
	if err != nil {
		t.Fatalf("drain after recovery: %v", err)
	}
	if result.Forwarded != 5 {
		t.Fatalf("forwarded %d after recovery, want 5", result.Forwarded)
	}

	counts, _ = queue.Counts(ctx)
	if counts.Pending != 0 {
		t.Fatalf("%d operations still pending after reconciliation", counts.Pending)
	}
	if uplink.count() != 6 {
		t.Fatalf("cloud received %d operations in total, want 6", uplink.count())
	}

	// Operations reach the cloud in the order they happened at the bedside,
	// not in the order the link happened to recover.
	received := uplink.operations()
	for i := 1; i < len(received); i++ {
		if received[i].OccurredAt.Before(received[i-1].OccurredAt) {
			t.Fatalf("operations arrived out of order at index %d", i)
		}
	}
}

// The cloud may acknowledge and the edge may never hear it. Re-forwarding must
// not produce a second effect.
func TestRedeliveryAfterLostAcknowledgementIsIdempotent(t *testing.T) {
	ctx := context.Background()
	queue := newQueue(t)
	uplink := newUplink()

	if err := queue.Enqueue(ctx, op("op-1", 0)); err != nil {
		t.Fatalf("Enqueue: %v", err)
	}

	// Cloud accepts, but the acknowledgement is lost, so the edge still has it
	// pending.
	if err := uplink.Forward(ctx, op("op-1", 0)); err != nil {
		t.Fatalf("first forward: %v", err)
	}

	forwarder := edge.NewForwarder(queue, uplink, 10)
	if _, err := forwarder.Drain(ctx); err != nil {
		t.Fatalf("Drain: %v", err)
	}

	if uplink.count() != 1 {
		t.Fatalf("cloud applied the operation %d times, want 1", uplink.count())
	}

	counts, _ := queue.Counts(ctx)
	if counts.Forwarded != 1 || counts.Pending != 0 {
		t.Fatalf("counts = %+v", counts)
	}
}

// Enqueue is idempotent so a crash between print and record cannot double-book.
func TestEnqueueIsIdempotent(t *testing.T) {
	ctx := context.Background()
	queue := newQueue(t)

	for i := 0; i < 3; i++ {
		if err := queue.Enqueue(ctx, op("op-1", 0)); err != nil {
			t.Fatalf("Enqueue %d: %v", i, err)
		}
	}

	pending, err := queue.Pending(ctx, 10)
	if err != nil {
		t.Fatalf("Pending: %v", err)
	}
	if len(pending) != 1 {
		t.Fatalf("%d copies queued, want 1", len(pending))
	}
}

// A permanent rejection must be parked for a human, not retried forever.
func TestPermanentRejectionIsParkedNotRetried(t *testing.T) {
	ctx := context.Background()
	queue := newQueue(t)
	uplink := newUplink()
	uplink.reject["op-2"] = "FACILITY_RETIRED"

	for _, o := range []edge.Operation{op("op-1", 0), op("op-2", time.Minute), op("op-3", 2*time.Minute)} {
		if err := queue.Enqueue(ctx, o); err != nil {
			t.Fatalf("Enqueue: %v", err)
		}
	}

	forwarder := edge.NewForwarder(queue, uplink, 10)
	result, err := forwarder.Drain(ctx)
	if err != nil {
		t.Fatalf("Drain: %v", err)
	}

	// The rejected one must not block the others.
	if result.Forwarded != 2 || result.Rejected != 1 {
		t.Fatalf("result = %+v", result)
	}

	counts, _ := queue.Counts(ctx)
	if counts.Rejected != 1 || counts.Pending != 0 {
		t.Fatalf("counts = %+v", counts)
	}

	// A second drain must not retry it.
	again, err := forwarder.Drain(ctx)
	if err != nil {
		t.Fatalf("second Drain: %v", err)
	}
	if again.Forwarded != 0 || again.Rejected != 0 {
		t.Fatalf("rejected operation was retried: %+v", again)
	}
}

// The queue is on disk, so a power cut does not erase unforwarded work.
func TestQueueSurvivesProcessRestart(t *testing.T) {
	ctx := context.Background()
	dir := t.TempDir()
	path := filepath.Join(dir, "edge.db")

	first, err := edge.OpenQueue(path)
	if err != nil {
		t.Fatalf("OpenQueue: %v", err)
	}
	for i := 0; i < 3; i++ {
		if err := first.Enqueue(ctx, op(fmt.Sprintf("op-%d", i), time.Duration(i)*time.Minute)); err != nil {
			t.Fatalf("Enqueue: %v", err)
		}
	}
	if err := first.Close(); err != nil {
		t.Fatalf("Close: %v", err)
	}

	// Simulates the node losing power and coming back.
	second, err := edge.OpenQueue(path)
	if err != nil {
		t.Fatalf("reopen: %v", err)
	}
	defer second.Close()

	pending, err := second.Pending(ctx, 10)
	if err != nil {
		t.Fatalf("Pending: %v", err)
	}
	if len(pending) != 3 {
		t.Fatalf("%d operations survived the restart, want 3", len(pending))
	}
}

// A label with no scannable identifier defeats the purpose of the label.
func TestLabelValidation(t *testing.T) {
	ctx := context.Background()
	queue := newQueue(t)
	printer := &recordingPrinter{}
	labels := edge.NewLabelService(printer, queue, func() string { return "op-1" }, func() time.Time { return at })

	cases := map[string]edge.LabelRequest{
		"no tenant":   {FacilityID: "f", Kind: "specimen", Barcode: "B"},
		"no facility": {TenantID: "t", Kind: "specimen", Barcode: "B"},
		"bad kind":    {TenantID: "t", FacilityID: "f", Kind: "poster", Barcode: "B"},
		"no barcode":  {TenantID: "t", FacilityID: "f", Kind: "specimen", Barcode: "  "},
	}
	for name, req := range cases {
		t.Run(name, func(t *testing.T) {
			if err := labels.Print(ctx, req); !errors.Is(err, edge.ErrInvalidLabel) {
				t.Fatalf("invalid label accepted: %v", err)
			}
		})
	}
	if printer.count() != 0 {
		t.Fatalf("invalid labels reached the printer %d times", printer.count())
	}
}

// A printer failure must not leave a queued record claiming a label exists.
func TestPrinterFailureDoesNotQueueAPhantomLabel(t *testing.T) {
	ctx := context.Background()
	queue := newQueue(t)
	printer := &recordingPrinter{fail: errors.New("printer offline")}
	labels := edge.NewLabelService(printer, queue, func() string { return "op-1" }, func() time.Time { return at })

	err := labels.Print(ctx, edge.LabelRequest{
		TenantID: "tenant-a", FacilityID: "facility-1",
		Kind: "wristband", Barcode: "MRN-1",
	})
	if err == nil {
		t.Fatal("print reported success with an offline printer")
	}

	counts, _ := queue.Counts(ctx)
	if counts.Pending != 0 {
		t.Fatalf("a phantom label was queued: %+v", counts)
	}
}

// The rendered payload must carry the barcode, or the scan that provides
// positive identification cannot happen.
func TestRenderedLabelContainsTheBarcode(t *testing.T) {
	ctx := context.Background()
	queue := newQueue(t)
	printer := &recordingPrinter{}
	labels := edge.NewLabelService(printer, queue, func() string { return "op-1" }, func() time.Time { return at })

	if err := labels.Print(ctx, edge.LabelRequest{
		TenantID: "tenant-a", FacilityID: "facility-1",
		Kind: "wristband", Barcode: "MRN-12345", Lines: []string{"SMITH, JOHN", "1980-01-01"},
	}); err != nil {
		t.Fatalf("Print: %v", err)
	}

	payload := string(printer.printed[0])
	for _, want := range []string{"MRN-12345", "SMITH, JOHN", "1980-01-01"} {
		if !strings.Contains(payload, want) {
			t.Fatalf("rendered label missing %q:\n%s", want, payload)
		}
	}
}

func TestEnqueueRejectsIncompleteOperations(t *testing.T) {
	ctx := context.Background()
	queue := newQueue(t)

	cases := map[string]edge.Operation{
		"no id":       {TenantID: "t", Type: "x", OccurredAt: at},
		"no tenant":   {ID: "1", Type: "x", OccurredAt: at},
		"no type":     {ID: "1", TenantID: "t", OccurredAt: at},
		"no occurred": {ID: "1", TenantID: "t", Type: "x"},
	}
	for name, o := range cases {
		t.Run(name, func(t *testing.T) {
			if err := queue.Enqueue(ctx, o); !errors.Is(err, edge.ErrInvalidOperation) {
				t.Fatalf("invalid operation accepted: %v", err)
			}
		})
	}
}

// A barcode or line containing ZPL control prefixes must not be able to close
// the current label and start an attacker-chosen one. A forged wristband is a
// wrong-patient hazard, not a cosmetic defect.
func TestLabelTextCannotInjectPrinterCommands(t *testing.T) {
	ctx := context.Background()
	queue := newQueue(t)
	printer := &recordingPrinter{}
	labels := edge.NewLabelService(printer, queue, func() string { return "op-1" }, func() time.Time { return at })

	if err := labels.Print(ctx, edge.LabelRequest{
		TenantID: "tenant-a", FacilityID: "facility-1", Kind: "wristband",
		Barcode: "MRN-1^FS^XZ^XA^FO20,20^FDFORGED^FS",
		Lines:   []string{"SMITH, JOHN^XZ^XA^FDALSO FORGED^FS"},
	}); err != nil {
		t.Fatalf("Print: %v", err)
	}

	payload := string(printer.printed[0])

	// Exactly one label: one ^XA and one ^XZ.
	if got := strings.Count(payload, "^XA"); got != 1 {
		t.Fatalf("payload opens %d labels, want 1:\n%s", got, payload)
	}
	if got := strings.Count(payload, "^XZ"); got != 1 {
		t.Fatalf("payload closes %d labels, want 1:\n%s", got, payload)
	}
	if strings.Contains(payload, "FORGED") && strings.Contains(payload, "^FDFORGED") {
		t.Fatalf("injected command survived escaping:\n%s", payload)
	}
}
