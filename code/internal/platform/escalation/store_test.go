package escalation_test

import (
	"context"
	"errors"
	"log/slog"
	"sync"
	"testing"
	"time"

	"github.com/google/uuid"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

const tenant = "11111111-1111-1111-1111-111111111111"

func scope() authctx.TenantScope { return authctx.SystemScope(tenant) }

func harness(t *testing.T) (*escalation.Store, *pgtx.Manager) {
	t.Helper()
	manager := pgtx.NewManager(pgtest.New(t))
	return escalation.NewStore(manager, nil), manager
}

// recorder is a channel that remembers who it was asked to tell.
type recorder struct {
	mu   sync.Mutex
	sent []string
	fail error
}

func (r *recorder) Name() string { return "task" }

func (r *recorder) Deliver(_ context.Context, notice escalation.Notice,
	to escalation.Recipient) error {

	r.mu.Lock()
	defer r.mu.Unlock()
	if r.fail != nil {
		return r.fail
	}
	r.sent = append(r.sent, to.UserID)
	return nil
}

func (r *recorder) told() []string {
	r.mu.Lock()
	defer r.mu.Unlock()
	return append([]string(nil), r.sent...)
}

type roster map[string][]string

func (r roster) OnDuty(_ context.Context, _ authctx.TenantScope, role, _ string) (
	[]string, error) {
	return r[role], nil
}

func saveChain(t *testing.T, store *escalation.Store, tx *pgtx.Manager, now time.Time) {
	t.Helper()
	matrix := escalation.Matrix{
		FacilityID: "f1", Kind: "critical_result",
		Rungs: []escalation.Rung{
			{Level: 0, Recipients: []escalation.Recipient{{UserID: "ordering-clinician"}}},
			{Level: 1, Recipients: []escalation.Recipient{
				{Role: "ed_registrar", FacilityID: "f1"}}},
			{Level: 2, Recipients: []escalation.Recipient{{UserID: "duty-manager"}}},
		},
	}
	if err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		return store.SaveMatrix(ctx, scope(), matrix, now)
	}); err != nil {
		t.Fatalf("save matrix: %v", err)
	}
}

func raise(t *testing.T, store *escalation.Store, tx *pgtx.Manager, now time.Time) escalation.Notice {
	t.Helper()
	var notice escalation.Notice
	err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		var err error
		notice, _, err = store.Raise(ctx, scope(), escalation.Subject{
			Kind: "critical_result", ID: "obs-1", PatientID: "p1", FacilityID: "f1",
		}, "Potassium 7.1 mmol/L — critically high", now)
		return err
	})
	if err != nil {
		t.Fatalf("raise: %v", err)
	}
	return notice
}

func TestAMatrixSurvivesAStorageRoundTrip(t *testing.T) {
	store, tx := harness(t)
	now := time.Date(2026, time.September, 17, 9, 0, 0, 0, time.UTC)
	saveChain(t, store, tx, now)

	var read escalation.Matrix
	if err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		var err error
		read, err = store.Matrix(ctx, scope(), "f1", "critical_result")
		return err
	}); err != nil {
		t.Fatalf("read matrix: %v", err)
	}

	if err := read.Validate(); err != nil {
		t.Fatalf("the stored matrix does not validate: %v", err)
	}
	if read.Top() != 2 {
		t.Fatalf("top rung %d, want 2", read.Top())
	}
	recipients, level, ok := read.At(1)
	if !ok || level != 1 || len(recipients) != 1 || recipients[0].Role != "ed_registrar" {
		t.Fatalf("rung 1 came back as %+v at level %d (ok=%v)", recipients, level, ok)
	}
}

func TestSavingAMatrixReplacesRatherThanAccumulates(t *testing.T) {
	// A chain edited by adding rows and never removing them keeps the rung
	// that still pages a consultant who left, and nobody notices until it
	// fires.
	store, tx := harness(t)
	now := time.Date(2026, time.September, 17, 9, 0, 0, 0, time.UTC)
	saveChain(t, store, tx, now)

	shorter := escalation.Matrix{
		FacilityID: "f1", Kind: "critical_result",
		Rungs: []escalation.Rung{
			{Level: 0, Recipients: []escalation.Recipient{{UserID: "new-clinician"}}},
		},
	}
	if err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		return store.SaveMatrix(ctx, scope(), shorter, now.Add(time.Hour))
	}); err != nil {
		t.Fatalf("resave: %v", err)
	}

	var read escalation.Matrix
	_ = tx.WithinTx(context.Background(), func(ctx context.Context) error {
		var err error
		read, err = store.Matrix(ctx, scope(), "f1", "critical_result")
		return err
	})
	if read.Top() != 0 {
		t.Fatalf("the old rungs survived: top is %d", read.Top())
	}
	if recipients, _, _ := read.At(0); recipients[0].UserID != "new-clinician" {
		t.Fatalf("level 0 is %+v", recipients)
	}
}

func TestAFacilityMatrixWinsOverTheTenantWideOne(t *testing.T) {
	store, tx := harness(t)
	now := time.Date(2026, time.September, 17, 9, 0, 0, 0, time.UTC)

	wide := escalation.Matrix{
		Kind: "critical_result",
		Rungs: []escalation.Rung{
			{Level: 0, Recipients: []escalation.Recipient{{UserID: "tenant-default"}}},
		},
	}
	if err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		return store.SaveMatrix(ctx, scope(), wide, now)
	}); err != nil {
		t.Fatalf("save tenant matrix: %v", err)
	}
	saveChain(t, store, tx, now)

	var facility, fallback escalation.Matrix
	_ = tx.WithinTx(context.Background(), func(ctx context.Context) error {
		var err error
		if facility, err = store.Matrix(ctx, scope(), "f1", "critical_result"); err != nil {
			return err
		}
		fallback, err = store.Matrix(ctx, scope(), "f2", "critical_result")
		return err
	})

	if r, _, _ := facility.At(0); r[0].UserID != "ordering-clinician" {
		t.Fatalf("the facility matrix was not preferred: %+v", r)
	}
	// A facility with no matrix of its own gets the tenant's rather than
	// nothing: a new ward should escalate by the hospital's default on its
	// first day, not silently fail to.
	if r, _, _ := fallback.At(0); r[0].UserID != "tenant-default" {
		t.Fatalf("the tenant fallback was not used: %+v", r)
	}
}

func TestRaisingIsRefusedWhereNoChainIsConfigured(t *testing.T) {
	// Refused rather than defaulted. A default chain has to invent a
	// recipient, and an escalation delivered to somebody the hospital did not
	// nominate is worse than one that fails at configuration time.
	store, tx := harness(t)
	err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		_, err := store.Matrix(ctx, scope(), "f1", "critical_result")
		return err
	})
	if !errors.Is(err, escalation.ErrNoMatrix) {
		t.Fatalf("an unconfigured kind returned %v", err)
	}
}

func TestRaisingTheSameSubjectTwiceProducesOneNotice(t *testing.T) {
	// Every retry, replay and restart re-runs the code that raised it. Two
	// chains racing each other to the same consultant is the outcome this
	// prevents.
	store, tx := harness(t)
	now := time.Date(2026, time.September, 17, 9, 0, 0, 0, time.UTC)
	saveChain(t, store, tx, now)

	first := raise(t, store, tx, now)

	var second escalation.Notice
	var created bool
	err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		var err error
		second, created, err = store.Raise(ctx, scope(), escalation.Subject{
			Kind: "critical_result", ID: "obs-1", PatientID: "p1", FacilityID: "f1",
		}, "Potassium 7.1 mmol/L — critically high", now.Add(time.Minute))
		return err
	})
	if err != nil {
		t.Fatalf("second raise: %v", err)
	}
	if created {
		t.Fatal("the second raise reported creating a notice")
	}
	if second.ID != first.ID {
		t.Fatalf("two notices for one subject: %s and %s", first.ID, second.ID)
	}
	if !second.RaisedAt.Equal(first.RaisedAt) {
		// A second raise that moved raised_at would restart the escalation
		// clock, which is how a retry loop keeps a notice permanently
		// fifteen minutes away from escalating.
		t.Fatalf("the second raise moved raised_at from %v to %v",
			first.RaisedAt, second.RaisedAt)
	}
}

// TestRestartDoesNotLosePendingEscalation is SRS-OPSNFR-003's acceptance
// criterion, executed rather than asserted about.
//
// The first driver raises and delivers level zero, then is discarded entirely —
// no shutdown, no handover, nothing flushed. A second driver built from nothing
// but the database picks the notice up and escalates it, which is the whole
// claim: the escalation lives in a row, not in a process.
func TestRestartDoesNotLosePendingEscalation(t *testing.T) {
	store, tx := harness(t)
	start := time.Date(2026, time.September, 17, 9, 0, 0, 0, time.UTC)
	saveChain(t, store, tx, start)

	first := &recorder{}
	clock := start
	before, err := escalation.NewDriver(escalation.DriverOptions{
		Transactions: tx, Store: store, Channels: []escalation.Channel{first},
		Roster: roster{"ed_registrar": {"registrar-on-call"}},
		Now:    func() time.Time { return clock },
		Logger: slog.New(slog.DiscardHandler),
	})
	if err != nil {
		t.Fatalf("driver: %v", err)
	}

	notice := raise(t, store, tx, start)
	if err := before.Deliver(context.Background(), scope(), notice); err != nil {
		t.Fatalf("deliver: %v", err)
	}
	if got := first.told(); len(got) != 1 || got[0] != "ordering-clinician" {
		t.Fatalf("level zero told %v", got)
	}

	// The process ends here. Nothing is flushed, nothing is handed over, and
	// the driver and its channel go out of scope.
	before, first = nil, nil
	_ = before

	after := &recorder{}
	clock = start.Add(16 * time.Minute)
	resumed, err := escalation.NewDriver(escalation.DriverOptions{
		Transactions: tx, Store: store, Channels: []escalation.Channel{after},
		Roster: roster{"ed_registrar": {"registrar-on-call"}},
		Now:    func() time.Time { return clock },
		Logger: slog.New(slog.DiscardHandler),
	})
	if err != nil {
		t.Fatalf("driver: %v", err)
	}

	escalated, err := resumed.Sweep(context.Background(), 10)
	if err != nil {
		t.Fatalf("sweep: %v", err)
	}
	if escalated != 1 {
		t.Fatalf("%d notices escalated after the restart, want 1", escalated)
	}
	if got := after.told(); len(got) != 1 || got[0] != "registrar-on-call" {
		t.Fatalf("the resumed driver told %v, want the on-call registrar", got)
	}

	var reread escalation.Notice
	_ = tx.WithinTx(context.Background(), func(ctx context.Context) error {
		var err error
		reread, err = store.Notice(ctx, scope(), notice.ID)
		return err
	})
	if reread.Level != 1 {
		t.Fatalf("the notice is at level %d after the restart, want 1", reread.Level)
	}
	if len(reread.Deliveries) != 2 {
		t.Fatalf("%d deliveries recorded across the restart, want 2", len(reread.Deliveries))
	}
}

func TestASweepDoesNotEscalateBeforeItIsDue(t *testing.T) {
	// The guard on the test above: a sweep that escalated everything it found
	// would pass that one while proving nothing about timing.
	store, tx := harness(t)
	start := time.Date(2026, time.September, 17, 9, 0, 0, 0, time.UTC)
	saveChain(t, store, tx, start)
	raise(t, store, tx, start)

	channel := &recorder{}
	driver, err := escalation.NewDriver(escalation.DriverOptions{
		Transactions: tx, Store: store, Channels: []escalation.Channel{channel},
		Now:    func() time.Time { return start.Add(14 * time.Minute) },
		Logger: slog.New(slog.DiscardHandler),
	})
	if err != nil {
		t.Fatalf("driver: %v", err)
	}

	escalated, err := driver.Sweep(context.Background(), 10)
	if err != nil {
		t.Fatalf("sweep: %v", err)
	}
	if escalated != 0 {
		t.Fatalf("%d escalated after fourteen minutes", escalated)
	}
	if len(channel.told()) != 0 {
		t.Fatalf("somebody was told early: %v", channel.told())
	}
}

func TestAnAcknowledgedNoticeStopsBeingSwept(t *testing.T) {
	store, tx := harness(t)
	start := time.Date(2026, time.September, 17, 9, 0, 0, 0, time.UTC)
	saveChain(t, store, tx, start)
	notice := raise(t, store, tx, start)

	if err := notice.Acknowledge("registrar", start.Add(5*time.Minute)); err != nil {
		t.Fatalf("acknowledge: %v", err)
	}
	if err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		return store.Save(ctx, scope(), notice)
	}); err != nil {
		t.Fatalf("save: %v", err)
	}

	channel := &recorder{}
	driver, err := escalation.NewDriver(escalation.DriverOptions{
		Transactions: tx, Store: store, Channels: []escalation.Channel{channel},
		Now:    func() time.Time { return start.Add(time.Hour) },
		Logger: slog.New(slog.DiscardHandler),
	})
	if err != nil {
		t.Fatalf("driver: %v", err)
	}
	if escalated, err := driver.Sweep(context.Background(), 10); err != nil || escalated != 0 {
		t.Fatalf("an acknowledged notice escalated: %d, %v", escalated, err)
	}

	var reread escalation.Notice
	_ = tx.WithinTx(context.Background(), func(ctx context.Context) error {
		var err error
		reread, err = store.Notice(ctx, scope(), notice.ID)
		return err
	})
	if reread.State != escalation.StateAcknowledged || reread.AcknowledgedBy != "registrar" {
		t.Fatalf("the acknowledgement did not survive: %+v", reread)
	}
}

func TestARotaWithNobodyOnItIsRecordedRatherThanSkipped(t *testing.T) {
	// A rung that reached nobody has to show up in the record as exactly that.
	// Skipping it silently is how an incident review concludes the chain was
	// followed.
	store, tx := harness(t)
	start := time.Date(2026, time.September, 17, 9, 0, 0, 0, time.UTC)
	saveChain(t, store, tx, start)
	notice := raise(t, store, tx, start)

	channel := &recorder{}
	driver, err := escalation.NewDriver(escalation.DriverOptions{
		Transactions: tx, Store: store, Channels: []escalation.Channel{channel},
		// Nobody on call.
		Roster: roster{},
		Now:    func() time.Time { return start.Add(16 * time.Minute) },
		Logger: slog.New(slog.DiscardHandler),
	})
	if err != nil {
		t.Fatalf("driver: %v", err)
	}
	if _, err := driver.Sweep(context.Background(), 10); err != nil {
		t.Fatalf("sweep: %v", err)
	}

	var reread escalation.Notice
	_ = tx.WithinTx(context.Background(), func(ctx context.Context) error {
		var err error
		reread, err = store.Notice(ctx, scope(), notice.ID)
		return err
	})
	if reread.Reached() {
		t.Fatal("an empty rota reported reaching somebody")
	}
	if len(reread.Deliveries) == 0 {
		t.Fatal("an empty rota left no record at all")
	}
	last := reread.Deliveries[len(reread.Deliveries)-1]
	if last.Delivered() {
		t.Fatalf("the failed attempt was recorded as delivered: %+v", last)
	}
}

func TestAnUnbuiltChannelRefusesLoudlyRatherThanSilently(t *testing.T) {
	// A hospital that configures SMS escalation for its ICU must not discover
	// at an incident review that nothing was ever sent.
	err := escalation.Unavailable{Channel: "sms", Owner: "SRS-PAT-ENG in Wave 5"}.
		Deliver(context.Background(), escalation.Notice{}, escalation.Recipient{UserID: "u1"})
	if err == nil {
		t.Fatal("an unimplemented channel reported success")
	}
	if got := err.Error(); got == "" {
		t.Fatal("the refusal says nothing")
	}
}

func TestTheInboxShowsAClinicianWhatTheyHaveNotAcknowledged(t *testing.T) {
	store, tx := harness(t)
	start := time.Date(2026, time.September, 17, 9, 0, 0, 0, time.UTC)
	saveChain(t, store, tx, start)
	notice := raise(t, store, tx, start)

	channel := &recorder{}
	driver, err := escalation.NewDriver(escalation.DriverOptions{
		Transactions: tx, Store: store, Channels: []escalation.Channel{channel},
		Now:    func() time.Time { return start },
		Logger: slog.New(slog.DiscardHandler),
	})
	if err != nil {
		t.Fatalf("driver: %v", err)
	}
	if err := driver.Deliver(context.Background(), scope(), notice); err != nil {
		t.Fatalf("deliver: %v", err)
	}

	var open []escalation.Notice
	_ = tx.WithinTx(context.Background(), func(ctx context.Context) error {
		var err error
		open, err = store.OpenFor(ctx, scope(), "ordering-clinician")
		return err
	})
	if len(open) != 1 || open[0].ID != notice.ID {
		t.Fatalf("the inbox holds %d notices", len(open))
	}

	// And it empties on acknowledgement rather than on delivery.
	acknowledged := open[0]
	if err := acknowledged.Acknowledge("ordering-clinician", start.Add(time.Minute)); err != nil {
		t.Fatalf("acknowledge: %v", err)
	}
	_ = tx.WithinTx(context.Background(), func(ctx context.Context) error {
		return store.Save(ctx, scope(), acknowledged)
	})
	_ = tx.WithinTx(context.Background(), func(ctx context.Context) error {
		var err error
		open, err = store.OpenFor(ctx, scope(), "ordering-clinician")
		return err
	})
	if len(open) != 0 {
		t.Fatalf("the inbox still holds %d after acknowledgement", len(open))
	}
}

func TestANoticeIsNotVisibleToAnotherTenant(t *testing.T) {
	store, tx := harness(t)
	start := time.Date(2026, time.September, 17, 9, 0, 0, 0, time.UTC)
	saveChain(t, store, tx, start)
	notice := raise(t, store, tx, start)

	other := authctx.SystemScope(uuid.NewString())
	err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		_, err := store.Notice(ctx, other, notice.ID)
		return err
	})
	if !errors.Is(err, escalation.ErrNoNotice) {
		t.Fatalf("a second tenant read the notice: %v", err)
	}
}
