package postgres_test

import (
	"context"
	"encoding/json"
	"sync"
	"testing"
	"time"

	"github.com/google/uuid"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

type mdFixture struct {
	repoFixture
	repo *orgpostgres.Repository
}

func newMasterDataFixture(t *testing.T) mdFixture {
	t.Helper()
	base := newRepoFixture(t)
	return mdFixture{repoFixture: base, repo: orgpostgres.New(pgtx.NewManager(base.pool))}
}

func otherTenantScope() authctx.TenantScope {
	return authctx.NewSession(authctx.Session{
		SubjectID: "intruder", TenantID: uuid.NewString(),
	}).TenantScope()
}

// --- Numbering (SRS-PLT-014) ---

func (f mdFixture) seedSequence(t *testing.T, scope domain.NumberScope, prefix string, pad int32, start int64) {
	t.Helper()
	seq, err := domain.NewNumberSequence(uuid.NewString(), f.tenantID, "", scope, prefix, pad, start, "", at)
	if err != nil {
		t.Fatalf("NewNumberSequence: %v", err)
	}
	if err := f.repo.EnsureSequence(context.Background(), f.scope, seq); err != nil {
		t.Fatalf("EnsureSequence: %v", err)
	}
}

// SRS-PLT-014's verification clause: sequences are atomic and collision-free
// under concurrency. Driven with real concurrent transactions against a real
// database, because that is the only place the property exists — no amount of
// Go-level care would make a non-locking statement safe.
func TestNumbersAreCollisionFreeUnderConcurrency(t *testing.T) {
	f := newMasterDataFixture(t)
	f.seedSequence(t, domain.ScopeMRN, "MRN-", 6, 1)

	const callers = 24
	issued := make([]string, callers)
	errs := make([]error, callers)

	var wg sync.WaitGroup
	start := make(chan struct{})
	for i := range callers {
		wg.Add(1)
		go func() {
			defer wg.Done()
			<-start
			issued[i], errs[i] = f.repo.IssueNumber(
				context.Background(), f.scope, domain.ScopeMRN, "", "", at)
		}()
	}
	close(start)
	wg.Wait()

	seen := make(map[string]bool, callers)
	for i, err := range errs {
		if err != nil {
			t.Fatalf("caller %d: %v", i, err)
		}
		if seen[issued[i]] {
			t.Fatalf("number %s was issued twice", issued[i])
		}
		seen[issued[i]] = true
	}
	if len(seen) != callers {
		t.Fatalf("%d callers received %d distinct numbers", callers, len(seen))
	}

	// And the numbers are the contiguous run 1..24, not just distinct: a
	// sequence that skipped values would still pass a uniqueness check while
	// producing gaps a tax authority rejects.
	for n := 1; n <= callers; n++ {
		want := domain.Format("MRN-", 6, int64(n))
		if !seen[want] {
			t.Errorf("%s was never issued; the run has a gap", want)
		}
	}
}

// The property a PostgreSQL SEQUENCE would not give: a caller whose
// transaction rolls back returns its number rather than burning it. An invoice
// series a tax authority expects to be gapless depends on this.
func TestARolledBackTransactionReturnsItsNumber(t *testing.T) {
	f := newMasterDataFixture(t)
	f.seedSequence(t, domain.ScopeInvoice, "INV-", 4, 1)
	tx := pgtx.NewManager(f.pool)
	repo := orgpostgres.New(tx)
	ctx := context.Background()

	first, err := repo.IssueNumber(ctx, f.scope, domain.ScopeInvoice, "", "", at)
	if err != nil {
		t.Fatalf("IssueNumber: %v", err)
	}
	if first != "INV-0001" {
		t.Fatalf("first number %s, want INV-0001", first)
	}

	// A transaction that issues a number and then fails.
	abandoned := errorAfterIssue(t, tx, repo, f.scope)
	if abandoned == "" {
		t.Fatal("the aborted transaction issued nothing")
	}

	next, err := repo.IssueNumber(ctx, f.scope, domain.ScopeInvoice, "", "", at)
	if err != nil {
		t.Fatalf("IssueNumber: %v", err)
	}
	if next != "INV-0002" {
		t.Fatalf("after a rollback the next number was %s, want INV-0002 — the "+
			"number the abandoned transaction took was burned", next)
	}
}

// errorAfterIssue issues a number inside a transaction that then fails,
// returning what it had been given.
func errorAfterIssue(t *testing.T, tx *pgtx.Manager, repo *orgpostgres.Repository,
	scope authctx.TenantScope) string {
	t.Helper()

	var issued string
	err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		var err error
		issued, err = repo.IssueNumber(ctx, scope, domain.ScopeInvoice, "", "", at)
		if err != nil {
			return err
		}
		return errDeliberate
	})
	if err == nil {
		t.Fatal("the transaction was expected to fail")
	}
	return issued
}

var errDeliberate = deliberateError{}

type deliberateError struct{}

func (deliberateError) Error() string { return "deliberate rollback" }

// Asking for a number a tenant has not been configured for is a setup problem
// an administrator fixes, not a missing record.
func TestUnconfiguredSequenceReportsAPreconditionNotANotFound(t *testing.T) {
	f := newMasterDataFixture(t)
	_, err := f.repo.IssueNumber(context.Background(), f.scope, domain.ScopeMRN, "", "", at)
	if err == nil {
		t.Fatal("an unconfigured sequence issued a number")
	}
	e, ok := rpcerr.As(err)
	if !ok || e.Code != "ORG_SEQUENCE_NOT_CONFIGURED" {
		t.Fatalf("want ORG_SEQUENCE_NOT_CONFIGURED, got %v", err)
	}
}

// Counters are per tenant. Two hospitals both starting at MRN-000001 is
// correct; one continuing the other's series is not.
func TestSequencesAreTenantScoped(t *testing.T) {
	f := newMasterDataFixture(t)
	f.seedSequence(t, domain.ScopeMRN, "MRN-", 6, 1)
	ctx := context.Background()

	first, err := f.repo.IssueNumber(ctx, f.scope, domain.ScopeMRN, "", "", at)
	if err != nil {
		t.Fatalf("IssueNumber: %v", err)
	}
	if first != "MRN-000001" {
		t.Fatalf("first number %s", first)
	}

	// Another tenant's call must not advance or read this counter.
	if _, err := f.repo.IssueNumber(ctx, otherTenantScope(), domain.ScopeMRN, "", "", at); err == nil {
		t.Fatal("another tenant drew from this tenant's sequence")
	}

	next, err := f.repo.IssueNumber(ctx, f.scope, domain.ScopeMRN, "", "", at)
	if err != nil {
		t.Fatalf("IssueNumber: %v", err)
	}
	if next != "MRN-000002" {
		t.Fatalf("the counter moved unexpectedly: %s", next)
	}
}

// Re-running setup must not reset a live counter. Re-issuing an MRN already
// printed on a wristband is a patient-safety event.
func TestEnsureSequenceDoesNotResetALiveCounter(t *testing.T) {
	f := newMasterDataFixture(t)
	f.seedSequence(t, domain.ScopeMRN, "MRN-", 6, 1)
	ctx := context.Background()

	for range 3 {
		if _, err := f.repo.IssueNumber(ctx, f.scope, domain.ScopeMRN, "", "", at); err != nil {
			t.Fatalf("IssueNumber: %v", err)
		}
	}

	// Setup runs again, as it would on a redeploy.
	f.seedSequence(t, domain.ScopeMRN, "MRN-", 6, 1)

	next, err := f.repo.IssueNumber(ctx, f.scope, domain.ScopeMRN, "", "", at)
	if err != nil {
		t.Fatalf("IssueNumber: %v", err)
	}
	if next != "MRN-000004" {
		t.Fatalf("the counter was reset to %s; numbers already issued would repeat", next)
	}
}

// --- Master-data changes (SRS-PLT-008) ---

func (f mdFixture) proposeChange(t *testing.T, entityID, proposedBy string) domain.MasterDataChange {
	t.Helper()
	c, err := domain.NewMasterDataChange(uuid.NewString(), f.tenantID, "org_unit", entityID,
		json.RawMessage(`{"display_name":"Cardiology and Vascular"}`), 1,
		at.Add(24*time.Hour), "merging the vascular service into cardiology", proposedBy, at)
	if err != nil {
		t.Fatalf("NewMasterDataChange: %v", err)
	}
	if err := f.repo.InsertChange(context.Background(), f.scope, c); err != nil {
		t.Fatalf("InsertChange: %v", err)
	}
	return c
}

// Four eyes must hold in the statement, not only in the domain, so a caller
// that reached the store directly still cannot approve its own proposal.
func TestDatabaseRefusesSelfApproval(t *testing.T) {
	f := newMasterDataFixture(t)
	entityID := uuid.NewString()
	c := f.proposeChange(t, entityID, "maker-1")
	ctx := context.Background()

	c.Status = domain.ChangeApproved
	c.DecidedBy = "maker-1"
	c.DecidedAt = at.Add(time.Hour)
	c.DecisionNote = "looks fine to me"
	if err := f.repo.DecideChange(ctx, f.scope, c); err == nil {
		t.Fatal("the database accepted a self-approval")
	}

	c.DecidedBy = "checker-1"
	c.DecisionNote = "agreed with the clinical director"
	if err := f.repo.DecideChange(ctx, f.scope, c); err != nil {
		t.Fatalf("DecideChange: %v", err)
	}

	stored, err := f.repo.GetChange(ctx, f.scope, c.ID)
	if err != nil {
		t.Fatalf("GetChange: %v", err)
	}
	if stored.Status != domain.ChangeApproved || stored.DecidedBy != "checker-1" {
		t.Fatalf("decision not recorded: %+v", stored)
	}
}

// A queue of pending changes against one entity would apply in an order
// nobody chose, each computed against a base the next invalidates.
func TestOnePendingChangePerEntity(t *testing.T) {
	f := newMasterDataFixture(t)
	entityID := uuid.NewString()
	f.proposeChange(t, entityID, "maker-1")

	second, err := domain.NewMasterDataChange(uuid.NewString(), f.tenantID, "org_unit", entityID,
		json.RawMessage(`{"display_name":"Something else"}`), 1,
		at.Add(24*time.Hour), "a competing proposal for the same unit", "maker-2", at)
	if err != nil {
		t.Fatalf("NewMasterDataChange: %v", err)
	}
	if err := f.repo.InsertChange(context.Background(), f.scope, second); err == nil {
		t.Fatal("a second pending change was accepted for the same entity")
	}

	// A different entity is unaffected.
	f.proposeChange(t, uuid.NewString(), "maker-1")
}

// A decided change frees the entity for the next proposal, which is what makes
// the index partial rather than absolute.
func TestDecidingAChangeFreesTheEntity(t *testing.T) {
	f := newMasterDataFixture(t)
	entityID := uuid.NewString()
	c := f.proposeChange(t, entityID, "maker-1")
	ctx := context.Background()

	c.Status = domain.ChangeRejected
	c.DecidedBy = "checker-1"
	c.DecidedAt = at.Add(time.Hour)
	c.DecisionNote = "the cost centre mapping is wrong"
	if err := f.repo.DecideChange(ctx, f.scope, c); err != nil {
		t.Fatalf("DecideChange: %v", err)
	}

	f.proposeChange(t, entityID, "maker-1")
}

func TestChangesAreTenantScoped(t *testing.T) {
	f := newMasterDataFixture(t)
	c := f.proposeChange(t, uuid.NewString(), "maker-1")
	ctx := context.Background()
	other := otherTenantScope()

	if _, err := f.repo.GetChange(ctx, other, c.ID); err == nil {
		t.Fatal("tenant B read tenant A's pending change")
	}

	c.Status = domain.ChangeApproved
	c.DecidedBy = "checker-1"
	c.DecidedAt = at.Add(time.Hour)
	c.DecisionNote = "approved from the wrong tenant"
	if err := f.repo.DecideChange(ctx, other, c); err == nil {
		t.Fatal("tenant B approved tenant A's change")
	}

	stored, err := f.repo.GetChange(ctx, f.scope, c.ID)
	if err != nil {
		t.Fatalf("GetChange: %v", err)
	}
	if stored.Status != domain.ChangePendingApproval {
		t.Fatalf("tenant A's change was modified: %s", stored.Status)
	}
}

// --- Calendars and labels (SRS-PLT-016, 017) ---

func (f mdFixture) seedFacility(t *testing.T) string {
	t.Helper()
	fac, err := domain.NewFacility(uuid.NewString(), f.tenantID, "FAC-CAL", "Calendar Facility",
		domain.FacilityHospital, "Asia/Kolkata", at)
	if err != nil {
		t.Fatalf("NewFacility: %v", err)
	}
	if err := f.fac.Insert(context.Background(), f.scope, fac); err != nil {
		t.Fatalf("insert facility: %v", err)
	}
	return fac.ID
}

// A public holiday and a planned closure can overlap and differ on whether an
// override is permitted, and a special opening within a closure period is the
// case the type exists for — so the query must return every entry covering a
// date, not the first.
func TestCalendarReturnsEveryEntryCoveringADate(t *testing.T) {
	f := newMasterDataFixture(t)
	facility := f.seedFacility(t)
	ctx := context.Background()

	closure, err := domain.NewCalendarEntry(uuid.NewString(), f.tenantID, facility,
		domain.EntryClosure, calDay(2026, time.December, 24), calDay(2026, time.December, 31),
		"Winter closure", true, at)
	if err != nil {
		t.Fatalf("NewCalendarEntry: %v", err)
	}
	opening, err := domain.NewCalendarEntry(uuid.NewString(), f.tenantID, facility,
		domain.EntrySpecialOpening, calDay(2026, time.December, 29), calDay(2026, time.December, 29),
		"Fracture clinic", false, at)
	if err != nil {
		t.Fatalf("NewCalendarEntry: %v", err)
	}
	for _, e := range []domain.CalendarEntry{closure, opening} {
		if err := f.repo.InsertCalendarEntry(ctx, f.scope, e); err != nil {
			t.Fatalf("InsertCalendarEntry: %v", err)
		}
	}

	onClinicDay, err := f.repo.CalendarEntriesOn(ctx, f.scope, facility, calDay(2026, time.December, 29))
	if err != nil {
		t.Fatalf("CalendarEntriesOn: %v", err)
	}
	if len(onClinicDay) != 2 {
		t.Fatalf("want both entries on the clinic day, got %d", len(onClinicDay))
	}
	// And the domain resolves them the right way round.
	if d := domain.AuthorizeScheduling(onClinicDay, calDay(2026, time.December, 29), false); !d.Permitted {
		t.Fatalf("the special opening did not beat the closure: %s", d.Reason)
	}

	onClosedDay, err := f.repo.CalendarEntriesOn(ctx, f.scope, facility, calDay(2026, time.December, 28))
	if err != nil {
		t.Fatalf("CalendarEntriesOn: %v", err)
	}
	if len(onClosedDay) != 1 {
		t.Fatalf("want 1 entry on a closed day, got %d", len(onClosedDay))
	}

	// A date outside every entry returns nothing, which the domain reads as
	// open.
	clear, err := f.repo.CalendarEntriesOn(ctx, f.scope, facility, calDay(2026, time.November, 1))
	if err != nil {
		t.Fatalf("CalendarEntriesOn: %v", err)
	}
	if len(clear) != 0 {
		t.Fatalf("an ordinary day returned %d entries", len(clear))
	}
}

func calDay(y int, m time.Month, d int) time.Time {
	return time.Date(y, m, d, 0, 0, 0, 0, time.UTC)
}

func TestCalendarIsTenantScoped(t *testing.T) {
	f := newMasterDataFixture(t)
	facility := f.seedFacility(t)
	ctx := context.Background()

	entry, err := domain.NewCalendarEntry(uuid.NewString(), f.tenantID, facility,
		domain.EntryHoliday, calDay(2026, time.November, 8), calDay(2026, time.November, 8),
		"Diwali", false, at)
	if err != nil {
		t.Fatalf("NewCalendarEntry: %v", err)
	}
	if err := f.repo.InsertCalendarEntry(ctx, f.scope, entry); err != nil {
		t.Fatalf("InsertCalendarEntry: %v", err)
	}

	entries, err := f.repo.CalendarEntriesOn(ctx, otherTenantScope(), facility, calDay(2026, time.November, 8))
	if err != nil {
		t.Fatalf("CalendarEntriesOn: %v", err)
	}
	if len(entries) != 0 {
		t.Fatal("another tenant read this facility's calendar")
	}
}

// Re-configuring a label replaces it rather than adding a second row for the
// same locale, which would shadow unpredictably depending on query order.
func TestLabelUpsertReplacesRatherThanDuplicates(t *testing.T) {
	f := newMasterDataFixture(t)
	ctx := context.Background()

	first, err := domain.NewDisplayLabel(uuid.NewString(), f.tenantID, "org_unit", "CARD",
		"en", "Cardiology", "Cardio", at)
	if err != nil {
		t.Fatalf("NewDisplayLabel: %v", err)
	}
	if err := f.repo.PutLabel(ctx, f.scope, first); err != nil {
		t.Fatalf("PutLabel: %v", err)
	}

	// A different row id for the same (system, code, locale): the upsert must
	// update the existing row, not insert a rival.
	revised, err := domain.NewDisplayLabel(uuid.NewString(), f.tenantID, "org_unit", "CARD",
		"en", "Cardiology and Vascular", "Cardio-Vasc", at.Add(time.Hour))
	if err != nil {
		t.Fatalf("NewDisplayLabel: %v", err)
	}
	if err := f.repo.PutLabel(ctx, f.scope, revised); err != nil {
		t.Fatalf("PutLabel: %v", err)
	}

	labels, err := f.repo.LabelsFor(ctx, f.scope, "org_unit", "CARD")
	if err != nil {
		t.Fatalf("LabelsFor: %v", err)
	}
	if len(labels) != 1 {
		t.Fatalf("want 1 label for en, got %d", len(labels))
	}
	if labels[0].Display != "Cardiology and Vascular" {
		t.Fatalf("the label was not updated: %q", labels[0].Display)
	}

	// A second locale is a second row, not a replacement.
	hindi, err := domain.NewDisplayLabel(uuid.NewString(), f.tenantID, "org_unit", "CARD",
		"hi", "हृदय रोग विज्ञान", "", at)
	if err != nil {
		t.Fatalf("NewDisplayLabel: %v", err)
	}
	if err := f.repo.PutLabel(ctx, f.scope, hindi); err != nil {
		t.Fatalf("PutLabel: %v", err)
	}
	labels, err = f.repo.LabelsFor(ctx, f.scope, "org_unit", "CARD")
	if err != nil {
		t.Fatalf("LabelsFor: %v", err)
	}
	if len(labels) != 2 {
		t.Fatalf("want 2 locales, got %d", len(labels))
	}

	// And the canonical code is unchanged by any of it (SRS-PLT-017).
	if r := domain.Render(labels, "CARD", "hi"); r.Code != "CARD" {
		t.Fatalf("rendering altered the canonical code to %q", r.Code)
	}
}

func TestLabelsAreTenantScoped(t *testing.T) {
	f := newMasterDataFixture(t)
	ctx := context.Background()

	l, err := domain.NewDisplayLabel(uuid.NewString(), f.tenantID, "org_unit", "CARD",
		"en", "Cardiology", "", at)
	if err != nil {
		t.Fatalf("NewDisplayLabel: %v", err)
	}
	if err := f.repo.PutLabel(ctx, f.scope, l); err != nil {
		t.Fatalf("PutLabel: %v", err)
	}

	labels, err := f.repo.LabelsFor(ctx, otherTenantScope(), "org_unit", "CARD")
	if err != nil {
		t.Fatalf("LabelsFor: %v", err)
	}
	if len(labels) != 0 {
		t.Fatal("another tenant read this tenant's labels")
	}
}

// Keyset pagination, no OFFSET: a page must not be skewed by rows inserted
// while the caller is paging.
func TestOrgUnitListingPagesByKeyset(t *testing.T) {
	f := newMasterDataFixture(t)
	ctx := context.Background()

	for _, code := range []string{"A", "B", "C", "D", "E"} {
		u, err := domain.NewOrgUnit(uuid.NewString(), f.tenantID, "", domain.UnitDepartment,
			code, "Department "+code, "", at, time.Time{}, false, at)
		if err != nil {
			t.Fatalf("NewOrgUnit: %v", err)
		}
		if err := f.repo.InsertOrgUnit(ctx, f.scope, u); err != nil {
			t.Fatalf("InsertOrgUnit: %v", err)
		}
	}

	first, err := f.repo.ListOrgUnits(ctx, f.scope, domain.UnitDepartment, "", 2)
	if err != nil {
		t.Fatalf("ListOrgUnits: %v", err)
	}
	if len(first) != 2 || first[0].Code != "A" || first[1].Code != "B" {
		t.Fatalf("first page: %v", codesOf(first))
	}

	// A row inserted before the code cursor must not shift the next page.
	early, err := domain.NewOrgUnit(uuid.NewString(), f.tenantID, "", domain.UnitDepartment,
		"AA", "Department AA", "", at, time.Time{}, false, at)
	if err != nil {
		t.Fatalf("NewOrgUnit: %v", err)
	}
	if err := f.repo.InsertOrgUnit(ctx, f.scope, early); err != nil {
		t.Fatalf("InsertOrgUnit: %v", err)
	}

	second, err := f.repo.ListOrgUnits(ctx, f.scope, domain.UnitDepartment, first[1].Code, 2)
	if err != nil {
		t.Fatalf("ListOrgUnits: %v", err)
	}
	if len(second) != 2 || second[0].Code != "C" || second[1].Code != "D" {
		t.Fatalf("the second page shifted after an insert: %v", codesOf(second))
	}
}

func codesOf(units []domain.OrgUnit) []string {
	out := make([]string, 0, len(units))
	for _, u := range units {
		out = append(out, u.Code)
	}
	return out
}
