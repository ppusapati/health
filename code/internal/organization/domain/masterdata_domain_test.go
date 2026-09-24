package domain_test

import (
	"encoding/json"
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/organization/domain"
)

var mdNow = time.Date(2026, 9, 11, 9, 0, 0, 0, time.UTC)

func mdDay(y int, m time.Month, d int) time.Time {
	return time.Date(y, m, d, 0, 0, 0, 0, time.UTC)
}

// --- Organizational units (SRS-PLT-005) ---

func unit(t *testing.T, from, until time.Time, acceptsWhenInactive bool) domain.OrgUnit {
	t.Helper()
	u, err := domain.NewOrgUnit("unit-1", "tenant-a", "fac-1", domain.UnitDepartment,
		"CARD", "Cardiology", "", from, until, acceptsWhenInactive, mdNow)
	if err != nil {
		t.Fatalf("NewOrgUnit: %v", err)
	}
	return u
}

// SRS-PLT-005's verification clause: an inactive unit cannot accept new
// transactional activity unless explicitly allowed.
func TestInactiveUnitRefusesActivity(t *testing.T) {
	closed := unit(t, mdDay(2024, time.January, 1), mdDay(2026, time.January, 1), false)

	if err := closed.AuthorizeActivity(mdDay(2025, time.June, 1)); err != nil {
		t.Fatalf("activity while the unit was open was refused: %v", err)
	}
	err := closed.AuthorizeActivity(mdDay(2026, time.June, 1))
	if !errors.Is(err, domain.ErrUnitNotAcceptingActivity) {
		t.Fatalf("want ErrUnitNotAcceptingActivity after closure, got %v", err)
	}
	// The message has to name the unit; "not allowed" is not actionable at a
	// reception desk.
	if err != nil && !strings.Contains(err.Error(), "CARD") {
		t.Errorf("the refusal does not name the unit: %v", err)
	}
}

func TestExplicitlyAllowedUnitStillAcceptsActivity(t *testing.T) {
	// A ward being decommissioned still receives late documentation for
	// patients it treated.
	decommissioning := unit(t, mdDay(2024, time.January, 1), mdDay(2026, time.January, 1), true)
	if err := decommissioning.AuthorizeActivity(mdDay(2026, time.June, 1)); err != nil {
		t.Fatalf("an explicitly allowed unit refused activity: %v", err)
	}
}

// Backdated documentation is routine in a hospital. Judging it against today
// would reject a note about a ward that closed last week.
func TestActivityIsJudgedAtEventTimeNotNow(t *testing.T) {
	closed := unit(t, mdDay(2024, time.January, 1), mdDay(2026, time.January, 1), false)
	if err := closed.AuthorizeActivity(mdDay(2025, time.December, 31)); err != nil {
		t.Fatalf("a backdated note about an open period was refused: %v", err)
	}
}

// Closing retroactively would invalidate transactions legitimately accepted
// while the unit was open.
// SRS-PLT-002 in part: the hierarchy below a facility is effective-dated, so a
// unit that closed last month cannot be made to have closed last year and
// invalidate what was recorded in between. The levels the requirement names
// above and below this one — legal entity, region, room, bed, store — are not
// modelled; see docs/engineering/wave-0-status.md.
func TestUnitCannotBeClosedRetroactively(t *testing.T) {
	u := unit(t, mdDay(2024, time.January, 1), time.Time{}, false)
	if err := u.Close(mdDay(2026, time.January, 1), mdNow); !errors.Is(err, domain.ErrInvalidOrgUnit) {
		t.Fatalf("want refusal of a retroactive closure, got %v", err)
	}
	if err := u.Close(mdDay(2027, time.January, 1), mdNow); err != nil {
		t.Fatalf("a future closure was refused: %v", err)
	}
	if !u.EffectiveUntil.Equal(mdDay(2027, time.January, 1)) {
		t.Fatalf("closure date not recorded: %s", u.EffectiveUntil)
	}
}

func TestOrgUnitValidation(t *testing.T) {
	from := mdDay(2024, time.January, 1)
	cases := map[string]func() error{
		"no code": func() error {
			_, err := domain.NewOrgUnit("u", "t", "f", domain.UnitDepartment, "", "Cardiology", "", from, time.Time{}, false, mdNow)
			return err
		},
		"unknown type": func() error {
			_, err := domain.NewOrgUnit("u", "t", "f", domain.UnitType("ward"), "C", "Cardiology", "", from, time.Time{}, false, mdNow)
			return err
		},
		"self parent": func() error {
			_, err := domain.NewOrgUnit("u", "t", "f", domain.UnitDepartment, "C", "Cardiology", "u", from, time.Time{}, false, mdNow)
			return err
		},
		"until before from": func() error {
			_, err := domain.NewOrgUnit("u", "t", "f", domain.UnitDepartment, "C", "Cardiology", "",
				from, mdDay(2023, time.January, 1), false, mdNow)
			return err
		},
	}
	for name, build := range cases {
		t.Run(name, func(t *testing.T) {
			if err := build(); !errors.Is(err, domain.ErrInvalidOrgUnit) {
				t.Fatalf("want ErrInvalidOrgUnit, got %v", err)
			}
		})
	}
}

// --- Maker/checker (SRS-PLT-008) ---

func change(t *testing.T, effectiveFrom time.Time) domain.MasterDataChange {
	t.Helper()
	c, err := domain.NewMasterDataChange("chg-1", "tenant-a", "org_unit", "unit-1",
		json.RawMessage(`{"display_name":"Cardiology and Vascular"}`), 3,
		effectiveFrom, "merging the vascular service into cardiology", "maker-1", mdNow)
	if err != nil {
		t.Fatalf("NewMasterDataChange: %v", err)
	}
	return c
}

// SRS-PLT-008's verification clause, first half: a pending version does not
// affect production transactions.
func TestPendingChangeIsNotInForce(t *testing.T) {
	c := change(t, mdDay(2026, time.January, 1))
	if c.Status != domain.ChangePendingApproval {
		t.Fatalf("a new change started as %s", c.Status)
	}
	if c.InForceAt(mdNow) {
		t.Fatal("a pending change reported itself in force")
	}
}

// Second half: approval is necessary and not sufficient. A change approved
// today but effective next month must not affect today's transactions.
func TestApprovedChangeIsOnlyInForceFromItsEffectiveDate(t *testing.T) {
	c := change(t, mdDay(2026, time.December, 1))
	if err := c.Approve("checker-1", "agreed with the clinical director", 3, mdNow); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if c.InForceAt(mdNow) {
		t.Fatal("an approved but not-yet-effective change reported itself in force")
	}
	if !c.InForceAt(mdDay(2026, time.December, 2)) {
		t.Fatal("the change is not in force after its effective date")
	}
}

// SRS-PLT-018's verification clause: the audit reveals the full configuration
// history, which means a change records all five of creator, approver,
// timestamps, reason and the state it was proposed against. A record missing
// any one of them cannot answer "who changed this, when, why, and from what".
func TestAConfigurationChangeRecordsItsProvenance(t *testing.T) {
	c := change(t, mdDay(2026, time.January, 1))
	if err := c.Approve("checker-1", "agreed with the clinical director", 3,
		mdNow.Add(time.Hour)); err != nil {
		t.Fatalf("Approve: %v", err)
	}

	for _, missing := range []struct {
		what  string
		empty bool
	}{
		{"the proposer", c.ProposedBy == ""},
		{"when it was proposed", c.ProposedAt.IsZero()},
		{"the approver", c.DecidedBy == ""},
		{"when it was decided", c.DecidedAt.IsZero()},
		{"the reason it was proposed", c.Justification == ""},
		{"the reason it was approved", c.DecisionNote == ""},
		{"the state it was proposed against", c.BaseVersion == 0},
		{"the state it proposes", len(c.Proposed) == 0},
	} {
		if missing.empty {
			t.Errorf("the change does not record %s", missing.what)
		}
	}

	// The prior version is the one the proposer saw, not the one approval
	// happened to find. Recording the latter would make the history read as
	// though the proposer had seen a row they never saw.
	if c.BaseVersion != 3 {
		t.Errorf("base version = %d, want the version the proposer saw",
			c.BaseVersion)
	}
}

func TestSelfApprovalIsRefused(t *testing.T) {
	c := change(t, mdDay(2026, time.January, 1))
	if err := c.Approve("maker-1", "looks fine to me", 3, mdNow); !errors.Is(err, domain.ErrSelfApproval) {
		t.Fatalf("want ErrSelfApproval, got %v", err)
	}
	if err := c.Reject("maker-1", "changed my mind about this", mdNow); !errors.Is(err, domain.ErrSelfApproval) {
		t.Fatalf("self-rejection: want ErrSelfApproval, got %v", err)
	}
}

// A proposal computed against an older version is refused: the proposer was
// looking at different data, and approving would discard whatever changed.
func TestStaleProposalIsRefused(t *testing.T) {
	c := change(t, mdDay(2026, time.January, 1))
	err := c.Approve("checker-1", "approved", 5, mdNow) // entity moved 3 -> 5
	if !errors.Is(err, domain.ErrStaleProposal) {
		t.Fatalf("want ErrStaleProposal, got %v", err)
	}
	if c.Status != domain.ChangePendingApproval {
		t.Fatalf("a refused approval changed the status to %s", c.Status)
	}
}

func TestOnlyPendingChangesCanBeDecided(t *testing.T) {
	c := change(t, mdDay(2026, time.January, 1))
	if err := c.Approve("checker-1", "agreed", 3, mdNow); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if err := c.Approve("checker-2", "agreed again", 3, mdNow); !errors.Is(err, domain.ErrNotPending) {
		t.Fatalf("want ErrNotPending on a second decision, got %v", err)
	}
	if err := c.Reject("checker-2", "actually no, reverse it", mdNow); !errors.Is(err, domain.ErrNotPending) {
		t.Fatalf("want ErrNotPending, got %v", err)
	}
}

// The proposer has to know what to change.
func TestRejectionRequiresAReason(t *testing.T) {
	c := change(t, mdDay(2026, time.January, 1))
	if err := c.Reject("checker-1", "no", mdNow); !errors.Is(err, domain.ErrInvalidChange) {
		t.Fatalf("want ErrInvalidChange for a terse rejection, got %v", err)
	}
}

func TestChangeValidation(t *testing.T) {
	valid := json.RawMessage(`{"a":1}`)
	cases := map[string]func() error{
		"invalid json": func() error {
			_, err := domain.NewMasterDataChange("c", "t", "org_unit", "u", json.RawMessage(`{not json`),
				1, mdNow, "a good enough justification", "maker", mdNow)
			return err
		},
		"terse justification": func() error {
			_, err := domain.NewMasterDataChange("c", "t", "org_unit", "u", valid, 1, mdNow, "fix", "maker", mdNow)
			return err
		},
		"no effective date": func() error {
			_, err := domain.NewMasterDataChange("c", "t", "org_unit", "u", valid, 1, time.Time{},
				"a good enough justification", "maker", mdNow)
			return err
		},
		"no proposer": func() error {
			_, err := domain.NewMasterDataChange("c", "t", "org_unit", "u", valid, 1, mdNow,
				"a good enough justification", "", mdNow)
			return err
		},
	}
	for name, build := range cases {
		t.Run(name, func(t *testing.T) {
			if err := build(); !errors.Is(err, domain.ErrInvalidChange) {
				t.Fatalf("want ErrInvalidChange, got %v", err)
			}
		})
	}
}
