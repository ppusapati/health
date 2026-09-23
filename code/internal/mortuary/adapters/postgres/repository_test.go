package postgres_test

import (
	"context"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/ppusapati/health/code/internal/mortuary/adapters/postgres"
	"github.com/ppusapati/health/code/internal/mortuary/domain"
	"github.com/ppusapati/health/code/internal/mortuary/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// The mortuary persistence adapter.
//
// Round-trip tests, because the defect they catch is invisible above the
// adapter: a dropped field reads back as a zero that looks like a decision
// nobody made. A lost medico-legal flag turns a case an authority has an
// interest in into an ordinary one; a lost identity state turns a presumed
// identification into a confirmed one; a lost seal number turns a valuable
// into something nobody can say was not opened.
//
// The assertions that bypass the adapter and write raw SQL are the rules that
// belong to the database rather than to Go: a rule the adapter is the only
// thing enforcing is one a migration, a backfill or the next context's
// repository can walk straight past. The one that matters most spans two
// rows — a medico-legal case cannot have a release without its authority's
// clearance — and is held by a composite foreign key rather than by this
// package remembering.

var at = time.Date(2026, 9, 23, 6, 0, 0, 0, time.UTC)

type fixture struct {
	pool     *pgxpool.Pool
	repo     *postgres.Repository
	scope    authctx.TenantScope
	tenantID string
}

func newFixture(t *testing.T) fixture {
	t.Helper()

	pool := pgtest.New(t)
	tenantID := uuid.NewString()

	return fixture{
		pool: pool,
		repo: postgres.New(pgtx.NewManager(pool)),
		scope: authctx.NewSession(authctx.Session{
			SubjectID: "mort-1", TenantID: tenantID,
		}).TenantScope(),
		tenantID: tenantID,
	}
}

// mustFail asserts the database refuses a write, naming the constraint it
// expects. A raw statement, because the point is that the rule holds against
// a caller that never went through the domain.
func (f fixture) mustFail(t *testing.T, constraint, sql string, args ...any) {
	t.Helper()
	_, err := f.pool.Exec(context.Background(), sql, args...)
	if err == nil {
		t.Fatalf("the database accepted a write %q should have refused",
			constraint)
	}
	if !strings.Contains(err.Error(), constraint) {
		t.Fatalf("want a violation of %q, got %v", constraint, err)
	}
}

func (f fixture) mustExec(t *testing.T, sql string, args ...any) {
	t.Helper()
	if _, err := f.pool.Exec(context.Background(), sql, args...); err != nil {
		t.Fatalf("exec: %v", err)
	}
}

func (f fixture) openCase(t *testing.T, reference string,
	mutate func(*domain.NewCaseInput)) domain.Case {

	t.Helper()
	in := domain.NewCaseInput{
		Reference: reference, Source: domain.SourceInHospital,
		EncounterID: uuid.NewString(), PatientID: uuid.NewString(),
		Identity: domain.IdentityConfirmed, DisplayName: "A Patient",
		IdentificationNote: "wristband checked against the notes",
		DiedAt:             at.Add(-2 * time.Hour),
	}
	if mutate != nil {
		mutate(&in)
	}
	c, err := domain.OpenCase(uuid.NewString(), f.tenantID, in, "mort-1",
		at)
	if err != nil {
		t.Fatalf("OpenCase: %v", err)
	}
	if err := f.repo.InsertCase(context.Background(), f.scope,
		c); err != nil {
		t.Fatalf("InsertCase: %v", err)
	}
	return c
}

func (f fixture) location(t *testing.T, code string,
	kind domain.SpaceKind) domain.Location {

	t.Helper()
	l, err := domain.NewLocation(uuid.NewString(), f.tenantID,
		domain.NewLocationInput{Code: code, Kind: kind, Zone: "main"},
		"mort-1", at)
	if err != nil {
		t.Fatalf("NewLocation: %v", err)
	}
	if err := f.repo.InsertLocation(context.Background(), f.scope,
		l); err != nil {
		t.Fatalf("InsertLocation: %v", err)
	}
	return l
}

func TestACaseSurvivesTheRoundTripAndKeepsWhatMakesItSensitive(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	stored := f.openCase(t, "M-2026-014", func(in *domain.NewCaseInput) {
		in.MedicoLegal, in.MLCReference = true, "PS-14/2026"
		in.Restricted = true
	})
	// The cause is recorded when it is known, which is not when the body
	// arrives.
	withCause := stored
	if err := withCause.RecordCause("the sensitive line",
		"coroner-1"); err != nil {
		t.Fatalf("RecordCause: %v", err)
	}
	if err := f.repo.UpdateCase(ctx, f.scope, withCause,
		stored.Version); err != nil {
		t.Fatalf("UpdateCase: %v", err)
	}

	back, err := f.repo.Case(ctx, f.scope, stored.ID)
	if err != nil {
		t.Fatalf("Case: %v", err)
	}
	// A lost medico-legal flag turns a case an authority has an interest
	// in into an ordinary one, and the release rules stop applying.
	if !back.MedicoLegal || back.MLCReference != "PS-14/2026" ||
		!back.Restricted {
		t.Fatalf("the sensitivity did not survive: %+v", back)
	}
	if back.Identity != domain.IdentityConfirmed ||
		back.CauseSummary != "the sensitive line" {
		t.Fatalf("the case did not survive: %+v", back)
	}
	if back.State != domain.CaseReceived || back.EncounterID == "" {
		t.Fatalf("the link did not survive: %+v", back)
	}

	// The desk finds a case from the number on the paperwork a family is
	// holding, whatever case they typed it in.
	byRef, err := f.repo.CaseByReference(ctx, f.scope, "m-2026-014")
	if err != nil {
		t.Fatalf("CaseByReference: %v", err)
	}
	if byRef.ID != stored.ID {
		t.Fatalf("the reference lookup found the wrong case: %+v", byRef)
	}

	updated := back
	if err := updated.RecordDeathCertificate("D-2026-0091", "mort-1",
		at); err != nil {
		t.Fatalf("RecordDeathCertificate: %v", err)
	}
	if err := f.repo.UpdateCase(ctx, f.scope, updated,
		back.Version); err != nil {
		t.Fatalf("UpdateCase: %v", err)
	}
	// A stale write loses rather than silently overwriting somebody else's.
	if err := f.repo.UpdateCase(ctx, f.scope, updated,
		back.Version); err != ports.ErrVersionConflict {
		t.Fatalf("want a version conflict, got %v", err)
	}

	back2, err := f.repo.Case(ctx, f.scope, stored.ID)
	if err != nil {
		t.Fatalf("Case: %v", err)
	}
	if back2.DeathCertificateRef != "D-2026-0091" ||
		back2.CertificateRecordedAt.IsZero() {
		t.Fatalf("the certificate did not survive: %+v", back2)
	}
}

func TestTheDatabaseRefusesACaseTheDomainWouldRefuse(t *testing.T) {
	f := newFixture(t)

	insert := `INSERT INTO mortuary.case (case_id, tenant_id, reference,
	    source, encounter_id, external_source, identity, identified_by,
	    identified_note, display_name, state, received_by, created_by)
	 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, 'mort-1',
	     'mort-1')`

	// "Which death is this?" is the first question a registrar asks.
	f.mustFail(t, "an_in_hospital_case_names_its_encounter",
		insert, uuid.NewString(), f.tenantID, "M-1", "in_hospital", nil,
		"", "confirmed", "mort-1", "by his son", "A Patient", "received")

	// A body that arrived from nowhere is one nobody can ask about.
	f.mustFail(t, "a_brought_in_case_says_where_from",
		insert, uuid.NewString(), f.tenantID, "M-2", "brought_in", nil,
		"", "unidentified", "", "", "", "received")

	// A brought-in body with an encounter is either the wrong source or
	// somebody else's encounter.
	f.mustFail(t, "a_brought_in_case_has_no_encounter_here",
		insert, uuid.NewString(), f.tenantID, "M-3", "brought_in",
		uuid.NewString(), "police", "unidentified", "", "", "",
		"received")

	// "Confirmed" with nothing behind it is a word somebody typed.
	f.mustFail(t, "a_confirmed_identification_says_how",
		insert, uuid.NewString(), f.tenantID, "M-4", "brought_in", nil,
		"police", "confirmed", "", "", "A Patient", "received")

	// A name on an unidentified body will be read as the name somebody
	// established.
	f.mustFail(t, "an_unidentified_case_carries_no_name",
		insert, uuid.NewString(), f.tenantID, "M-5", "brought_in", nil,
		"police", "unidentified", "", "", "A Guess", "received")

	// A stored case that names no space is one the board cannot find, and
	// a released one that names a space occupies a drawer nobody can open.
	f.mustFail(t, "a_stored_case_names_its_space",
		insert, uuid.NewString(), f.tenantID, "M-6", "brought_in", nil,
		"police", "unidentified", "", "", "", "stored")

	f.mustFail(t, "a_case_names_its_reference",
		insert, uuid.NewString(), f.tenantID, "", "brought_in", nil,
		"police", "unidentified", "", "", "", "received")

	// One reference is one case: two rows for one body means two
	// registers, and a family is told whichever the clerk opened.
	f.openCase(t, "M-2026-014", nil)
	f.mustFail(t, "case_reference_idx",
		insert, uuid.NewString(), f.tenantID, "m-2026-014", "brought_in",
		nil, "police", "unidentified", "", "", "", "received")

	f.mustFail(t, "a_case_names_who_received_it",
		`INSERT INTO mortuary.case (case_id, tenant_id, reference, source,
		    external_source, identity, state, received_by, created_by)
		 VALUES ($1, $2, 'M-7', 'brought_in', 'police', 'unidentified',
		     'received', '', 'mort-1')`,
		uuid.NewString(), f.tenantID)

	f.mustFail(t, "a_case_names_who_opened_it",
		`INSERT INTO mortuary.case (case_id, tenant_id, reference, source,
		    external_source, identity, state, received_by, created_by)
		 VALUES ($1, $2, 'M-8', 'brought_in', 'police', 'unidentified',
		     'received', 'mort-1', '')`,
		uuid.NewString(), f.tenantID)

	// An identity nobody defined is one the release checks cannot
	// classify: "not unidentified" is true of "probably".
	f.mustFail(t, "case_identity_check",
		insert, uuid.NewString(), f.tenantID, "M-10", "brought_in", nil,
		"police", "probably", "", "", "", "received")

	// A released case that still names a drawer occupies a space nobody
	// can open, and the board offers it to nobody for ever.
	f.mustFail(t, "a_released_case_is_in_no_space",
		`INSERT INTO mortuary.case (case_id, tenant_id, reference, source,
		    external_source, identity, state, storage_tag, received_by,
		    created_by)
		 VALUES ($1, $2, 'M-9', 'brought_in', 'police', 'unidentified',
		     'released', 'TAG-9', 'mort-1', 'mort-1')`,
		uuid.NewString(), f.tenantID)
}

func TestOneBodyPerSpaceAndOneTagPerBody(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	first := f.openCase(t, "M-1", nil)
	second := f.openCase(t, "M-2", func(in *domain.NewCaseInput) {
		in.EncounterID = uuid.NewString()
	})
	fridge := f.location(t, "F2-14", domain.SpaceRefrigerated)
	spare := f.location(t, "F2-15", domain.SpaceRefrigerated)

	placed, err := domain.Place(uuid.NewString(), f.tenantID, &first,
		fridge, "TAG-1", "wristband against the register", "mort-1", at)
	if err != nil {
		t.Fatalf("Place: %v", err)
	}
	if err := f.repo.InsertPlacement(ctx, f.scope, placed); err != nil {
		t.Fatalf("InsertPlacement: %v", err)
	}

	insert := `INSERT INTO mortuary.placement (placement_id, tenant_id,
	    case_id, location_id, storage_tag, state, identity_checked_by,
	    identity_checked_note, placed_by)
	 VALUES ($1, $2, $3, $4, $5, 'current', 'mort-1', 'checked', 'mort-1')`

	// Two cases in one refrigerated space is one body somebody will not
	// find, and a mortuary discovers this with a family in the corridor.
	f.mustFail(t, "placement_one_body_per_space_idx",
		insert, uuid.NewString(), f.tenantID, second.ID, fridge.ID,
		"TAG-2")

	// One case in two spaces is a mortuary that does not know where it
	// put somebody.
	f.mustFail(t, "placement_one_space_per_body_idx",
		insert, uuid.NewString(), f.tenantID, first.ID, spare.ID, "TAG-3")

	// And two bodies with the same tag cannot be told apart at the point
	// where telling them apart is the whole job.
	f.mustFail(t, "placement_tag_idx",
		insert, uuid.NewString(), f.tenantID, second.ID, spare.ID,
		"tag-1")

	// "Identity checked" with nothing behind it is a tick.
	f.mustFail(t, "a_placement_says_what_was_checked",
		`INSERT INTO mortuary.placement (placement_id, tenant_id, case_id,
		    location_id, storage_tag, state, identity_checked_by,
		    identity_checked_note, placed_by)
		 VALUES ($1, $2, $3, $4, 'TAG-9', 'current', 'mort-1', '',
		     'mort-1')`,
		uuid.NewString(), f.tenantID, second.ID, spare.ID)
	f.mustFail(t, "a_placement_names_who_checked",
		`INSERT INTO mortuary.placement (placement_id, tenant_id, case_id,
		    location_id, storage_tag, state, identity_checked_by,
		    identity_checked_note, placed_by)
		 VALUES ($1, $2, $3, $4, 'TAG-9', 'current', '', 'checked',
		     'mort-1')`,
		uuid.NewString(), f.tenantID, second.ID, spare.ID)
	f.mustFail(t, "a_placement_names_its_tag",
		`INSERT INTO mortuary.placement (placement_id, tenant_id, case_id,
		    location_id, storage_tag, state, identity_checked_by,
		    identity_checked_note, placed_by)
		 VALUES ($1, $2, $3, $4, '', 'current', 'mort-1', 'checked',
		     'mort-1')`,
		uuid.NewString(), f.tenantID, second.ID, spare.ID)

	// A body that moved for no recorded reason is one nobody can follow.
	f.mustFail(t, "an_ended_placement_says_who_and_why",
		`UPDATE mortuary.placement SET state = 'ended', ended_at = now()
		 WHERE placement_id = $1`, placed.ID)

	// The space frees when the placement ends, and then the next body goes
	// in — which is the rule above working rather than simply forbidding.
	ended := placed
	if err := ended.End("to the table", "mort-2", at.Add(time.Hour)); err != nil {
		t.Fatalf("End: %v", err)
	}
	if err := f.repo.EndPlacement(ctx, f.scope, ended); err != nil {
		t.Fatalf("EndPlacement: %v", err)
	}
	f.mustExec(t, insert, uuid.NewString(), f.tenantID, second.ID,
		fridge.ID, "TAG-1")

	// The identity check made at the moment of placing survives, which is
	// what makes it reviewable when the next person opens the drawer.
	history, err := f.repo.Placements(ctx, f.scope, []string{first.ID})
	if err != nil {
		t.Fatalf("Placements: %v", err)
	}
	if len(history) != 1 || history[0].IdentityCheckedNote == "" ||
		history[0].State != domain.PlacementEnded {
		t.Fatalf("the placement did not survive: %+v", history)
	}
	if history[0].EndedReason == "" || history[0].EndedBy == "" {
		t.Fatalf("the move lost its why: %+v", history[0])
	}

	occupied, err := f.repo.OccupiedLocations(ctx, f.scope)
	if err != nil {
		t.Fatalf("OccupiedLocations: %v", err)
	}
	if !occupied[fridge.ID] || occupied[spare.ID] {
		t.Fatalf("the occupancy is wrong: %+v", occupied)
	}

	// A space off the board says why.
	f.mustFail(t, "a_space_off_the_board_says_why",
		`UPDATE mortuary.location SET out_of_service = true
		 WHERE location_id = $1`, spare.ID)
	f.mustFail(t, "a_placement_names_who_made_it",
		`INSERT INTO mortuary.placement (placement_id, tenant_id, case_id,
		    location_id, storage_tag, state, identity_checked_by,
		    identity_checked_note, placed_by)
		 VALUES ($1, $2, $3, $4, 'TAG-9', 'current', 'mort-1', 'checked',
		     '')`,
		uuid.NewString(), f.tenantID, second.ID, spare.ID)

	// A space with no code is one nobody can be sent to.
	f.mustFail(t, "a_location_names_its_code",
		`INSERT INTO mortuary.location (location_id, tenant_id, code,
		    kind, created_by) VALUES ($1, $2, '', 'freezer', 'mort-1')`,
		uuid.NewString(), f.tenantID)
	// A space of a kind nobody defined is one the free-by-kind count
	// cannot place, and a mortuary looking for a drawer is offered it.
	f.mustFail(t, "location_kind_check",
		`INSERT INTO mortuary.location (location_id, tenant_id, code,
		    kind, created_by)
		 VALUES ($1, $2, 'Z9-02', 'drawer', 'mort-1')`,
		uuid.NewString(), f.tenantID)
	f.mustFail(t, "a_location_names_who_added_it",
		`INSERT INTO mortuary.location (location_id, tenant_id, code,
		    kind, created_by) VALUES ($1, $2, 'Z9-01', 'freezer', '')`,
		uuid.NewString(), f.tenantID)

	// And one code is one door.
	f.mustFail(t, "location_code_idx",
		`INSERT INTO mortuary.location (location_id, tenant_id, code,
		    kind, created_by)
		 VALUES ($1, $2, 'f2-14', 'refrigerated', 'mort-1')`,
		uuid.NewString(), f.tenantID)
}

func TestBelongingsKeepTheirControlsAndTheChainIsAppendOnly(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	body := f.openCase(t, "M-1", nil)

	ring, err := domain.ListItem(uuid.NewString(), f.tenantID, body,
		domain.NewItemInput{
			Kind: domain.ItemValuable, Description: "a gold ring",
			Quantity: 1, SealNumber: "SEAL-0091", WitnessedBy: "mort-2",
		}, "mort-1", at)
	if err != nil {
		t.Fatalf("ListItem: %v", err)
	}
	if err := f.repo.InsertItem(ctx, f.scope, ring); err != nil {
		t.Fatalf("InsertItem: %v", err)
	}

	back, err := f.repo.Item(ctx, f.scope, ring.ID)
	if err != nil {
		t.Fatalf("Item: %v", err)
	}
	// A lost seal number turns a valuable into something nobody can say
	// was not opened, and a lost witness into a list one person made alone.
	if back.SealNumber != "SEAL-0091" || back.WitnessedBy != "mort-2" ||
		back.Quantity != 1 {
		t.Fatalf("the controls did not survive: %+v", back)
	}

	// A list of what was in somebody's pockets, made by one person alone.
	f.mustFail(t, "a_valuable_is_listed_with_a_witness",
		`INSERT INTO mortuary.belonging (item_id, tenant_id, case_id,
		    kind, description, quantity, state, seal_number, listed_by)
		 VALUES ($1, $2, $3, 'valuable', 'a watch', 1, 'held', 'SEAL-2',
		     'mort-1')`,
		uuid.NewString(), f.tenantID, body.ID)
	// One person signing as both is the control not working.
	f.mustFail(t, "a_listing_witness_is_somebody_else",
		`INSERT INTO mortuary.belonging (item_id, tenant_id, case_id,
		    kind, description, quantity, state, seal_number, listed_by,
		    witnessed_by)
		 VALUES ($1, $2, $3, 'valuable', 'a watch', 1, 'held', 'SEAL-2',
		     'mort-1', 'mort-1')`,
		uuid.NewString(), f.tenantID, body.ID)
	f.mustFail(t, "a_valuable_goes_into_a_seal",
		`INSERT INTO mortuary.belonging (item_id, tenant_id, case_id,
		    kind, description, quantity, state, listed_by, witnessed_by)
		 VALUES ($1, $2, $3, 'valuable', 'a watch', 1, 'held', 'mort-1',
		     'mort-2')`,
		uuid.NewString(), f.tenantID, body.ID)
	// "Zero rings" is an item that will be signed for and was never there.
	f.mustFail(t, "an_item_says_how_many",
		`INSERT INTO mortuary.belonging (item_id, tenant_id, case_id,
		    kind, description, quantity, state, listed_by)
		 VALUES ($1, $2, $3, 'clothing', 'a jacket', 0, 'held', 'mort-1')`,
		uuid.NewString(), f.tenantID, body.ID)
	f.mustFail(t, "an_item_says_what_it_is",
		`INSERT INTO mortuary.belonging (item_id, tenant_id, case_id,
		    kind, description, quantity, state, listed_by)
		 VALUES ($1, $2, $3, 'clothing', '', 1, 'held', 'mort-1')`,
		uuid.NewString(), f.tenantID, body.ID)
	// An item marked handed over with no handover behind it is a ring
	// somebody signed for on a page that does not exist.
	f.mustFail(t, "a_handed_item_names_its_handover",
		`INSERT INTO mortuary.belonging (item_id, tenant_id, case_id,
		    kind, description, quantity, state, listed_by)
		 VALUES ($1, $2, $3, 'clothing', 'a jacket', 1, 'handed_over',
		     'mort-1')`,
		uuid.NewString(), f.tenantID, body.ID)

	jacket, err := domain.ListItem(uuid.NewString(), f.tenantID, body,
		domain.NewItemInput{
			Kind: domain.ItemClothing, Description: "a jacket",
			Quantity: 1,
		}, "mort-1", at)
	if err != nil {
		t.Fatalf("ListItem: %v", err)
	}
	if err := f.repo.InsertItem(ctx, f.scope, jacket); err != nil {
		t.Fatalf("InsertItem: %v", err)
	}

	handed, err := domain.HandOver(uuid.NewString(), f.tenantID, body,
		[]*domain.Item{&jacket}, domain.NewHandoverInput{
			RecipientName: "A Son", RecipientRelation: "son",
			RecipientIDType: "national id", RecipientIDRef: "XX-1234",
			SignatureRef: "reg-page-114", WitnessedBy: "mort-2",
		}, "mort-1", at)
	if err != nil {
		t.Fatalf("HandOver: %v", err)
	}
	if err := f.repo.InsertHandover(ctx, f.scope, handed); err != nil {
		t.Fatalf("InsertHandover: %v", err)
	}
	if err := f.repo.UpdateItemState(ctx, f.scope, jacket,
		domain.ItemHeld); err != nil {
		t.Fatalf("UpdateItemState: %v", err)
	}
	// An item handed over twice is a family signing for what they already
	// have, and the expected state is what stops it.
	if err := f.repo.UpdateItemState(ctx, f.scope, jacket,
		domain.ItemHeld); err != ports.ErrVersionConflict {
		t.Fatalf("want a state conflict, got %v", err)
	}

	// The handover's own controls hold in the database too.
	f.mustFail(t, "a_handover_witness_is_somebody_else",
		`INSERT INTO mortuary.handover (handover_id, tenant_id, case_id,
		    recipient_name, recipient_id_type, recipient_id_ref,
		    signature_ref, handed_by, witnessed_by)
		 VALUES ($1, $2, $3, 'A Son', 'national id', 'XX-1', 'page-2',
		     'mort-1', 'mort-1')`,
		uuid.NewString(), f.tenantID, body.ID)
	f.mustFail(t, "a_handover_records_the_signature",
		`INSERT INTO mortuary.handover (handover_id, tenant_id, case_id,
		    recipient_name, recipient_id_type, recipient_id_ref,
		    signature_ref, handed_by, witnessed_by)
		 VALUES ($1, $2, $3, 'A Son', 'national id', 'XX-1', '',
		     'mort-1', 'mort-2')`,
		uuid.NewString(), f.tenantID, body.ID)
	f.mustFail(t, "a_handover_names_who_took_them",
		`INSERT INTO mortuary.handover (handover_id, tenant_id, case_id,
		    recipient_name, recipient_id_type, recipient_id_ref,
		    signature_ref, handed_by, witnessed_by)
		 VALUES ($1, $2, $3, '', 'national id', 'XX-1', 'page-2',
		     'mort-1', 'mort-2')`,
		uuid.NewString(), f.tenantID, body.ID)
	f.mustFail(t, "a_handover_names_who_made_it",
		`INSERT INTO mortuary.handover (handover_id, tenant_id, case_id,
		    recipient_name, recipient_id_type, recipient_id_ref,
		    signature_ref, handed_by, witnessed_by)
		 VALUES ($1, $2, $3, 'A Son', 'national id', 'XX-1', 'page-2',
		     '', 'mort-2')`,
		uuid.NewString(), f.tenantID, body.ID)
	f.mustFail(t, "a_handover_is_witnessed",
		`INSERT INTO mortuary.handover (handover_id, tenant_id, case_id,
		    recipient_name, recipient_id_type, recipient_id_ref,
		    signature_ref, handed_by, witnessed_by)
		 VALUES ($1, $2, $3, 'A Son', 'national id', 'XX-1', 'page-2',
		     'mort-1', '')`,
		uuid.NewString(), f.tenantID, body.ID)
	f.mustFail(t, "a_handover_records_the_id_reference",
		`INSERT INTO mortuary.handover (handover_id, tenant_id, case_id,
		    recipient_name, recipient_id_type, recipient_id_ref,
		    signature_ref, handed_by, witnessed_by)
		 VALUES ($1, $2, $3, 'A Son', 'national id', '', 'page-2',
		     'mort-1', 'mort-2')`,
		uuid.NewString(), f.tenantID, body.ID)
	f.mustFail(t, "a_handover_records_the_recipients_id",
		`INSERT INTO mortuary.handover (handover_id, tenant_id, case_id,
		    recipient_name, recipient_id_type, recipient_id_ref,
		    signature_ref, handed_by, witnessed_by)
		 VALUES ($1, $2, $3, 'A Son', '', 'XX-1', 'page-2', 'mort-1',
		     'mort-2')`,
		uuid.NewString(), f.tenantID, body.ID)

	f.mustFail(t, "a_listing_names_who_made_it",
		`INSERT INTO mortuary.belonging (item_id, tenant_id, case_id,
		    kind, description, quantity, state, listed_by)
		 VALUES ($1, $2, $3, 'clothing', 'a jacket', 1, 'held', '')`,
		uuid.NewString(), f.tenantID, body.ID)
	// An item still held that names a handover is a jacket in the safe
	// that somebody already signed for.
	f.mustFail(t, "an_unhanded_item_names_no_handover",
		`INSERT INTO mortuary.belonging (item_id, tenant_id, case_id,
		    kind, description, quantity, state, listed_by, handover_id)
		 VALUES ($1, $2, $3, 'clothing', 'a scarf', 1, 'held', 'mort-1',
		     $4)`,
		uuid.NewString(), f.tenantID, body.ID, handed.ID)

	// The chain of custody.
	entry, err := domain.RecordCustody(uuid.NewString(), f.tenantID,
		body.ID, "received", "brought from ward 3", "ward 3",
		"mortuary attendant", "mort-1", at)
	if err != nil {
		t.Fatalf("RecordCustody: %v", err)
	}
	if err := f.repo.AppendCustody(ctx, f.scope, entry); err != nil {
		t.Fatalf("AppendCustody: %v", err)
	}
	chain, err := f.repo.Custody(ctx, f.scope, body.ID)
	if err != nil {
		t.Fatalf("Custody: %v", err)
	}
	if len(chain) != 1 || chain[0].FromParty == "" ||
		chain[0].ToParty == "" {
		t.Fatalf("the chain did not survive: %+v", chain)
	}
	// A chain attributed to nobody has a gap exactly where somebody would
	// want one.
	f.mustFail(t, "a_custody_entry_names_who_recorded_it",
		`INSERT INTO mortuary.custody_entry (entry_id, tenant_id, case_id,
		    event, recorded_by)
		 VALUES ($1, $2, $3, 'moved', '')`,
		uuid.NewString(), f.tenantID, body.ID)
	f.mustFail(t, "a_custody_entry_says_what_happened",
		`INSERT INTO mortuary.custody_entry (entry_id, tenant_id, case_id,
		    event, recorded_by)
		 VALUES ($1, $2, $3, '', 'mort-1')`,
		uuid.NewString(), f.tenantID, body.ID)
}

func TestAMedicoLegalCaseCannotHaveAReleaseWithoutItsAuthority(t *testing.T) {
	f := newFixture(t)

	legal := f.openCase(t, "M-1", func(in *domain.NewCaseInput) {
		in.MedicoLegal, in.MLCReference = true, "PS-14/2026"
	})
	ordinary := f.openCase(t, "M-2", func(in *domain.NewCaseInput) {
		in.EncounterID = uuid.NewString()
	})

	insert := `INSERT INTO mortuary.release (release_id, tenant_id, case_id,
	    case_medico_legal, recipient_name, verification_note,
	    signature_ref, authority, authority_reference, released_by,
	    witnessed_by)
	 VALUES ($1, $2, $3, $4, 'A Son', 'checked against the register',
	     'page-114', $5, $6, 'mort-1', 'mort-2')`

	// The rule the whole family exists to hold. A body an authority has an
	// interest in, released on the mortuary's own say-so, is evidence that
	// has left the building.
	f.mustFail(t, "a_medico_legal_release_names_its_authority",
		insert, uuid.NewString(), f.tenantID, legal.ID, true, "", "")
	f.mustFail(t, "a_medico_legal_release_names_its_authority",
		insert, uuid.NewString(), f.tenantID, legal.ID, true,
		"the coroner", "")

	// And the flag cannot be lied about: it is checked against the case it
	// was copied from.
	f.mustFail(t, "release_case_id_case_medico_legal_fkey",
		insert, uuid.NewString(), f.tenantID, legal.ID, false, "", "")

	// An ordinary case releases without one.
	f.mustExec(t, insert, uuid.NewString(), f.tenantID, ordinary.ID, false,
		"", "")

	// A body leaves once. Two releases for one case is two families who
	// were each told they had taken somebody home.
	f.mustFail(t, "release_case_id_key",
		insert, uuid.NewString(), f.tenantID, ordinary.ID, false, "", "")

	f.mustExec(t, insert, uuid.NewString(), f.tenantID, legal.ID, true,
		"the coroner", "CO-2026-0044")

	// The cascade is the point: marking a case medico-legal after a
	// release was written without a clearance fails against the CHECK
	// rather than quietly leaving a body released under no authority.
	f.mustFail(t, "a_medico_legal_release_names_its_authority",
		`UPDATE mortuary.case SET medico_legal = true WHERE case_id = $1`,
		ordinary.ID)

	// A body leaving on one person's word is the case every mortuary
	// inquiry turns out to be about.
	third := f.openCase(t, "M-3", func(in *domain.NewCaseInput) {
		in.EncounterID = uuid.NewString()
	})
	f.mustFail(t, "a_release_witness_is_somebody_else",
		`INSERT INTO mortuary.release (release_id, tenant_id, case_id,
		    case_medico_legal, recipient_name, verification_note,
		    signature_ref, released_by, witnessed_by)
		 VALUES ($1, $2, $3, false, 'A Son', 'checked', 'page-1',
		     'mort-1', 'mort-1')`,
		uuid.NewString(), f.tenantID, third.ID)
	// The acceptance asks for verification, and a tick is not one.
	f.mustFail(t, "a_release_says_what_was_verified",
		`INSERT INTO mortuary.release (release_id, tenant_id, case_id,
		    case_medico_legal, recipient_name, verification_note,
		    signature_ref, released_by, witnessed_by)
		 VALUES ($1, $2, $3, false, 'A Son', '', 'page-1', 'mort-1',
		     'mort-2')`,
		uuid.NewString(), f.tenantID, third.ID)
	f.mustFail(t, "a_release_records_the_signature",
		`INSERT INTO mortuary.release (release_id, tenant_id, case_id,
		    case_medico_legal, recipient_name, verification_note,
		    signature_ref, released_by, witnessed_by)
		 VALUES ($1, $2, $3, false, 'A Son', 'checked', '', 'mort-1',
		     'mort-2')`,
		uuid.NewString(), f.tenantID, third.ID)
	f.mustFail(t, "a_release_names_who_made_it",
		`INSERT INTO mortuary.release (release_id, tenant_id, case_id,
		    case_medico_legal, recipient_name, verification_note,
		    signature_ref, released_by, witnessed_by)
		 VALUES ($1, $2, $3, false, 'A Son', 'checked', 'page-1', '',
		     'mort-2')`,
		uuid.NewString(), f.tenantID, third.ID)
	f.mustFail(t, "a_release_is_witnessed",
		`INSERT INTO mortuary.release (release_id, tenant_id, case_id,
		    case_medico_legal, recipient_name, verification_note,
		    signature_ref, released_by, witnessed_by)
		 VALUES ($1, $2, $3, false, 'A Son', 'checked', 'page-1',
		     'mort-1', '')`,
		uuid.NewString(), f.tenantID, third.ID)
	f.mustFail(t, "a_release_names_who_took_the_body",
		`INSERT INTO mortuary.release (release_id, tenant_id, case_id,
		    case_medico_legal, recipient_name, verification_note,
		    signature_ref, released_by, witnessed_by)
		 VALUES ($1, $2, $3, false, '', 'checked', 'page-1', 'mort-1',
		     'mort-2')`,
		uuid.NewString(), f.tenantID, third.ID)
}

func TestAPostmortemRoundTripsAndCannotBePerformedUnauthorised(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	body := f.openCase(t, "M-1", func(in *domain.NewCaseInput) {
		in.MedicoLegal, in.MLCReference = true, "PS-14/2026"
	})

	request, err := domain.RequestPostmortem(uuid.NewString(), f.tenantID,
		body, domain.NewPostmortemInput{
			Kind: domain.PostmortemMedicoLegal, Reason: "death in custody",
		}, "doc-1", at)
	if err != nil {
		t.Fatalf("RequestPostmortem: %v", err)
	}
	if err := f.repo.InsertPostmortem(ctx, f.scope, request); err != nil {
		t.Fatalf("InsertPostmortem: %v", err)
	}

	// A body opened on a request alone is one somebody will answer for.
	// Checked on a clinical request, so the only rule in the way is the
	// authorisation one: a medico-legal request would also trip the
	// reference check and the assertion would not say which held.
	clinical := uuid.NewString()
	f.mustExec(t,
		`INSERT INTO mortuary.postmortem (postmortem_id, tenant_id,
		    case_id, kind, reason, state, requested_by)
		 VALUES ($1, $2, $3, 'clinical', 'unexplained', 'requested',
		     'doc-1')`,
		clinical, f.tenantID, body.ID)
	f.mustFail(t, "an_examination_follows_an_authorisation",
		`UPDATE mortuary.postmortem
		 SET state = 'performed', performed_by = 'path-1',
		     performed_at = now()
		 WHERE postmortem_id = $1`, clinical)

	// "Authorised by the coroner" with no reference is a sentence, and the
	// question asked at the inquest is which order.
	f.mustFail(t, "a_medico_legal_authorisation_is_referenced",
		`UPDATE mortuary.postmortem
		 SET state = 'authorised', authority = 'the coroner',
		     authorised_by = 'mort-1', authorised_at = now()
		 WHERE postmortem_id = $1`, request.ID)

	authorised := request
	if err := authorised.Authorise("the coroner", "CO-2026-0044", "mort-1",
		at); err != nil {
		t.Fatalf("Authorise: %v", err)
	}
	if err := f.repo.UpdatePostmortem(ctx, f.scope, authorised,
		request.Version); err != nil {
		t.Fatalf("UpdatePostmortem: %v", err)
	}

	back, err := f.repo.Postmortem(ctx, f.scope, request.ID)
	if err != nil {
		t.Fatalf("Postmortem: %v", err)
	}
	// "Under whose authority" is answered by the record rather than by
	// somebody's memory.
	if back.Authority != "the coroner" ||
		back.AuthorityReference != "CO-2026-0044" ||
		back.AuthorisedAt.IsZero() {
		t.Fatalf("the authorisation did not survive: %+v", back)
	}

	f.mustFail(t, "a_performed_examination_names_who",
		`UPDATE mortuary.postmortem SET state = 'performed'
		 WHERE postmortem_id = $1`, request.ID)
	f.mustFail(t, "a_reported_examination_names_its_report",
		`UPDATE mortuary.postmortem
		 SET state = 'reported', performed_by = 'path-1',
		     performed_at = now()
		 WHERE postmortem_id = $1`, request.ID)
	f.mustFail(t, "a_declined_request_says_why",
		`UPDATE mortuary.postmortem SET state = 'declined'
		 WHERE postmortem_id = $1`, request.ID)
	f.mustFail(t, "a_request_says_why",
		`INSERT INTO mortuary.postmortem (postmortem_id, tenant_id,
		    case_id, kind, reason, state, requested_by)
		 VALUES ($1, $2, $3, 'clinical', '', 'requested', 'doc-1')`,
		uuid.NewString(), f.tenantID, body.ID)

	// An authorisation is a named authority and their own reference.
	auth := domain.Authorisation{
		Authority: "the coroner", Reference: "CO-2026-0044",
		RecordedBy: "mort-1", RecordedAt: at,
	}
	if err := f.repo.InsertAuthorisation(ctx, f.scope, uuid.NewString(),
		body.ID, auth); err != nil {
		t.Fatalf("InsertAuthorisation: %v", err)
	}
	latest, err := f.repo.LatestAuthorisation(ctx, f.scope, body.ID)
	if err != nil {
		t.Fatalf("LatestAuthorisation: %v", err)
	}
	if !latest.Held() {
		t.Fatalf("the clearance did not survive: %+v", latest)
	}

	// No clearance is an answer rather than an error: it is the answer the
	// release checks act on.
	other := f.openCase(t, "M-2", func(in *domain.NewCaseInput) {
		in.EncounterID = uuid.NewString()
	})
	none, err := f.repo.LatestAuthorisation(ctx, f.scope, other.ID)
	if err != nil {
		t.Fatalf("LatestAuthorisation: %v", err)
	}
	if none.Held() {
		t.Fatalf("a case with no clearance has one: %+v", none)
	}

	f.mustFail(t, "a_request_names_who_made_it",
		`INSERT INTO mortuary.postmortem (postmortem_id, tenant_id,
		    case_id, kind, reason, state, requested_by)
		 VALUES ($1, $2, $3, 'clinical', 'unexplained', 'requested', '')`,
		uuid.NewString(), f.tenantID, body.ID)

	f.mustFail(t, "an_authorisation_names_the_authority",
		`INSERT INTO mortuary.authorisation (authorisation_id, tenant_id,
		    case_id, authority, reference, recorded_by)
		 VALUES ($1, $2, $3, '', 'CO-1', 'mort-1')`,
		uuid.NewString(), f.tenantID, other.ID)
	f.mustFail(t, "an_authorisation_names_the_reference",
		`INSERT INTO mortuary.authorisation (authorisation_id, tenant_id,
		    case_id, authority, reference, recorded_by)
		 VALUES ($1, $2, $3, 'the coroner', '', 'mort-1')`,
		uuid.NewString(), f.tenantID, other.ID)
	f.mustFail(t, "an_authorisation_names_who_took_it",
		`INSERT INTO mortuary.authorisation (authorisation_id, tenant_id,
		    case_id, authority, reference, recorded_by)
		 VALUES ($1, $2, $3, 'the coroner', 'CO-1', '')`,
		uuid.NewString(), f.tenantID, other.ID)
}

func TestAnotherTenantsRegisterIsNotReachable(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	stored := f.openCase(t, "M-2026-014", nil)
	other := authctx.NewSession(authctx.Session{
		SubjectID: "mort-2", TenantID: uuid.NewString(),
	}).TenantScope()

	// NOT_FOUND rather than PERMISSION_DENIED, so a probe cannot confirm
	// the identifier exists somewhere else.
	if _, err := f.repo.Case(ctx, other, stored.ID); err == nil {
		t.Fatal("another tenant read the case")
	}
	if _, err := f.repo.CaseByReference(ctx, other,
		"M-2026-014"); err == nil {
		t.Fatal("another tenant read the case by its reference")
	}
	list, err := f.repo.Cases(ctx, other, ports.CaseFilter{})
	if err != nil {
		t.Fatalf("Cases: %v", err)
	}
	if len(list) != 0 {
		t.Fatalf("another tenant listed %d cases", len(list))
	}
}
