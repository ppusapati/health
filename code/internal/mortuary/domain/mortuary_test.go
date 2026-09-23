package domain_test

import (
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/mortuary/domain"
)

// The mortuary rules.
//
// Every refusal below is a rule somebody could otherwise remove, so each is
// tested by weakening it: the assertion is that the domain says no, and the
// comment says what happens in a mortuary when it says yes.

var at = time.Date(2026, 9, 23, 6, 0, 0, 0, time.UTC)

func refused(t *testing.T, err error, contains string) {
	t.Helper()
	if err == nil {
		t.Fatalf("want a refusal mentioning %q, got none", contains)
	}
	if !strings.Contains(err.Error(), contains) {
		t.Fatalf("want a refusal mentioning %q, got %v", contains, err)
	}
}

// ------------------------------------------------------ cases (SRS-MORT-001)

func caseInput() domain.NewCaseInput {
	return domain.NewCaseInput{
		Reference: "M-2026-014", Source: domain.SourceInHospital,
		EncounterID: "enc-1", PatientID: "p1",
		Identity: domain.IdentityConfirmed, DisplayName: "A Patient",
		IdentificationNote: "wristband checked against the notes",
		DiedAt:             at.Add(-2 * time.Hour), FacilityID: "f1",
	}
}

func openCase(t *testing.T, id string,
	mutate func(*domain.NewCaseInput)) domain.Case {

	t.Helper()
	in := caseInput()
	if mutate != nil {
		mutate(&in)
	}
	out, err := domain.OpenCase(id, "t1", in, "mort-1", at)
	if err != nil {
		t.Fatalf("OpenCase: %v", err)
	}
	return out
}

func TestACaseIsLinkedToADeathOrPlainlyFromOutside(t *testing.T) {
	linked := openCase(t, "c1", nil)
	if linked.State != domain.CaseReceived ||
		linked.EncounterID != "enc-1" {
		t.Fatalf("the case did not open linked: %+v", linked)
	}

	// "Which death is this?" is the first question a registrar asks, and a
	// case that cannot answer it is one where somebody answers it from
	// memory.
	in := caseInput()
	in.EncounterID = ""
	_, err := domain.OpenCase("c1", "t1", in, "mort-1", at)
	refused(t, err, "names its encounter")

	// And a body brought in says who brought it: one that arrived from
	// nowhere is one nobody can ask about.
	in = caseInput()
	in.Source, in.EncounterID = domain.SourceBroughtIn, ""
	_, err = domain.OpenCase("c1", "t1", in, "mort-1", at)
	refused(t, err, "says where it came from")

	// A brought-in body with an encounter is either the wrong source or
	// somebody else's encounter. Both are worth stopping at the door.
	in = caseInput()
	in.Source, in.ExternalSource = domain.SourceBroughtIn, "city police"
	_, err = domain.OpenCase("c1", "t1", in, "mort-1", at)
	refused(t, err, "has no encounter here")

	// A name on an unidentified body is the name somebody guessed, and it
	// will be read as the name somebody established.
	in = caseInput()
	in.Identity = domain.IdentityUnidentified
	_, err = domain.OpenCase("c1", "t1", in, "mort-1", at)
	refused(t, err, "carries no name")

	in = caseInput()
	in.Reference = " "
	_, err = domain.OpenCase("c1", "t1", in, "mort-1", at)
	refused(t, err, "needs its reference")

	in = caseInput()
	in.Source = "somewhere"
	_, err = domain.OpenCase("c1", "t1", in, "mort-1", at)
	refused(t, err, "unknown source")

	in = caseInput()
	in.Identity = "probably"
	_, err = domain.OpenCase("c1", "t1", in, "mort-1", at)
	refused(t, err, "unknown identity state")

	_, err = domain.OpenCase("c1", "t1", caseInput(), "", at)
	refused(t, err, "names who opened it")

	_, err = domain.OpenCase("", "t1", caseInput(), "mort-1", at)
	refused(t, err, "needs an id")

	// A body brought in with a source and no encounter is the ordinary
	// case, and it opens.
	brought := openCase(t, "c2", func(in *domain.NewCaseInput) {
		in.Source, in.EncounterID = domain.SourceBroughtIn, ""
		in.ExternalSource = "city police"
		in.Identity, in.DisplayName = domain.IdentityUnidentified, ""
	})
	if brought.Source != domain.SourceBroughtIn ||
		brought.ExternalSource == "" {
		t.Fatalf("the brought-in case did not open: %+v", brought)
	}
}

func TestAnIdentificationSaysWhoMadeItAndHow(t *testing.T) {
	unknown := openCase(t, "c1", func(in *domain.NewCaseInput) {
		in.Source, in.EncounterID = domain.SourceBroughtIn, ""
		in.ExternalSource = "city police"
		in.Identity, in.DisplayName = domain.IdentityUnidentified, ""
	})

	// A presumed identity is a hypothesis. Handing a body over on one is
	// how the wrong funeral happens, so the two are different states.
	if unknown.Identity.Positive() {
		t.Fatal("an unidentified body reads as positively identified")
	}
	if err := unknown.Identify(domain.IdentityPresumed, "A Person",
		"wallet in the jacket", "mort-1", at); err != nil {
		t.Fatalf("Identify: %v", err)
	}
	if unknown.Identity.Positive() {
		t.Fatal("a presumed identity reads as positive")
	}

	// "Confirmed" with nothing behind it is a word somebody typed. How it
	// was confirmed is what makes it reviewable.
	refused(t, unknown.Identify(domain.IdentityConfirmed, "A Person", "",
		"mort-1", at), "says how")
	refused(t, unknown.Identify(domain.IdentityConfirmed, "", "by his son",
		"mort-1", at), "says who this is")
	refused(t, unknown.Identify(domain.IdentityConfirmed, "A Person",
		"by his son", "", at), "names who made it")
	refused(t, unknown.Identify("guessed", "A Person", "x", "mort-1", at),
		"unknown identity state")

	// Naming a body and then un-naming it is not an identification.
	refused(t, unknown.Identify(domain.IdentityUnidentified, "A Person",
		"x", "mort-1", at), "does not make a body unidentified")

	if err := unknown.Identify(domain.IdentityConfirmed, "A Person",
		"identified by his son, who knew him", "mort-2",
		at.Add(time.Hour)); err != nil {
		t.Fatalf("Identify: %v", err)
	}
	// Confirmed by whom is the question asked when the wrong family is in
	// the corridor.
	if !unknown.Identity.Positive() || unknown.IdentifiedBy != "mort-2" ||
		unknown.IdentifiedNote == "" {
		t.Fatalf("the identification did not stick: %+v", unknown)
	}

	// A case that has gone cannot be re-identified.
	unknown.State = domain.CaseReleased
	refused(t, unknown.Identify(domain.IdentityConfirmed, "Somebody Else",
		"x", "mort-1", at), "has been released")
	refused(t, unknown.MarkMedicoLegal("ref", "mort-1"), "has been released")
	refused(t, unknown.RecordCause("myocardial infarction", "coroner-1"),
		"has been released")
	refused(t, unknown.RecordDeathCertificate("D-1", "mort-1", at),
		"has been released")
}

func TestACertificateAndAMedicoLegalMarkBothNameWhoRecordedThem(t *testing.T) {
	opened := openCase(t, "c1", nil)

	refused(t, opened.RecordDeathCertificate("", "mort-1", at),
		"needs its reference")
	refused(t, opened.RecordDeathCertificate("D-1", "", at),
		"names who recorded it")
	if err := opened.RecordDeathCertificate("D-2026-0091", "mort-1",
		at); err != nil {
		t.Fatalf("RecordDeathCertificate: %v", err)
	}
	if opened.DeathCertificateRef == "" ||
		opened.CertificateRecordedAt.IsZero() {
		t.Fatalf("the certificate did not stick: %+v", opened)
	}

	// The cause is its own act, recorded when it is known rather than
	// guessed at the door.
	refused(t, opened.RecordCause("", "coroner-1"), "says what it was")
	refused(t, opened.RecordCause("myocardial infarction", ""),
		"names who recorded it")
	if err := opened.RecordCause("myocardial infarction",
		"coroner-1"); err != nil {
		t.Fatalf("RecordCause: %v", err)
	}
	if opened.CauseSummary != "myocardial infarction" {
		t.Fatalf("the cause did not stick: %+v", opened)
	}

	refused(t, opened.MarkMedicoLegal("PS-14/2026", ""),
		"names who marked it")
	if err := opened.MarkMedicoLegal("PS-14/2026", "mort-1"); err != nil {
		t.Fatalf("MarkMedicoLegal: %v", err)
	}
	if !opened.MedicoLegal || opened.MLCReference != "PS-14/2026" {
		t.Fatalf("the mark did not stick: %+v", opened)
	}

	// There is no method that clears it. A case that was medico-legal and
	// is no longer is one where somebody decided the coroner has lost
	// interest, and that is the coroner's decision.
	if err := opened.MarkMedicoLegal("", "mort-2"); err != nil {
		t.Fatalf("MarkMedicoLegal: %v", err)
	}
	if !opened.MedicoLegal || opened.MLCReference != "PS-14/2026" {
		t.Fatalf("a re-mark cleared the reference: %+v", opened)
	}
}

// --------------------------------------------------- storage (SRS-MORT-002)

func location(t *testing.T, id, code string,
	kind domain.SpaceKind) domain.Location {

	t.Helper()
	out, err := domain.NewLocation(id, "t1", domain.NewLocationInput{
		Code: code, Kind: kind, FacilityID: "f1", Zone: "main",
	}, "mort-1", at)
	if err != nil {
		t.Fatalf("NewLocation: %v", err)
	}
	return out
}

func TestASpaceIsNamedAndCanBeTakenOutOfServiceWithoutLosingItsHistory(
	t *testing.T) {

	_, err := domain.NewLocation("l1", "t1", domain.NewLocationInput{
		Kind: domain.SpaceRefrigerated,
	}, "mort-1", at)
	refused(t, err, "needs its code")

	_, err = domain.NewLocation("l1", "t1", domain.NewLocationInput{
		Code: "F2-14", Kind: "drawer",
	}, "mort-1", at)
	refused(t, err, "unknown space kind")

	_, err = domain.NewLocation("l1", "t1", domain.NewLocationInput{
		Code: "F2-14", Kind: domain.SpaceRefrigerated,
	}, "", at)
	refused(t, err, "names who added it")

	_, err = domain.NewLocation("", "t1", domain.NewLocationInput{
		Code: "F2-14", Kind: domain.SpaceRefrigerated,
	}, "mort-1", at)
	refused(t, err, "needs an id")

	space := location(t, "l1", "f2-14", domain.SpaceRefrigerated)
	// The code is what is painted on the door, and "f2-14" and "F2-14" are
	// the same door.
	if space.Code != "F2-14" {
		t.Fatalf("the code was not canonicalised: %q", space.Code)
	}

	// A broken unit is still a space, and the bodies that were in it last
	// month were in it.
	refused(t, space.TakeOutOfService(""), "say why")
	if err := space.TakeOutOfService("refrigeration failed"); err != nil {
		t.Fatalf("TakeOutOfService: %v", err)
	}
	if !space.OutOfService || space.OutOfServiceReason == "" {
		t.Fatalf("the space is still in service: %+v", space)
	}
	space.ReturnToService()
	if space.OutOfService || space.OutOfServiceReason != "" {
		t.Fatalf("the space did not come back: %+v", space)
	}
}

func TestPlacingABodyRecordsTheIdentityCheckAndRefusesABrokenSpace(
	t *testing.T) {

	body := openCase(t, "c1", nil)
	space := location(t, "l1", "F2-14", domain.SpaceRefrigerated)

	// "Identity checked" with nothing behind it is a tick. What was
	// checked against what is the part somebody can review.
	_, err := domain.Place("p1", "t1", &body, space, "TAG-1", "",
		"mort-1", at)
	refused(t, err, "says what identity check was made")

	// The tag is what the person opening the drawer reads. A body without
	// one is identified by which drawer it is in, and drawers get
	// reorganised.
	_, err = domain.Place("p1", "t1", &body, space, "",
		"wristband against register", "mort-1", at)
	refused(t, err, "needs its tag")

	_, err = domain.Place("p1", "t1", &body, space, "TAG-1", "checked",
		"", at)
	refused(t, err, "names who made it")

	_, err = domain.Place("", "t1", &body, space, "TAG-1", "checked",
		"mort-1", at)
	refused(t, err, "needs an id")

	// A body put in a unit whose refrigeration has failed is a body
	// decomposing where the board says it is fine.
	broken := location(t, "l2", "F2-15", domain.SpaceRefrigerated)
	if err := broken.TakeOutOfService("refrigeration failed"); err != nil {
		t.Fatalf("TakeOutOfService: %v", err)
	}
	_, err = domain.Place("p1", "t1", &body, broken, "TAG-1", "checked",
		"mort-1", at)
	refused(t, err, "out of service")

	placed, err := domain.Place("p1", "t1", &body, space, "tag-1",
		"wristband checked against the register by two of us", "mort-1",
		at)
	if err != nil {
		t.Fatalf("Place: %v", err)
	}
	if body.State != domain.CaseStored || body.LocationID != space.ID ||
		body.StorageTag != "TAG-1" {
		t.Fatalf("the case did not move into the space: %+v", body)
	}
	if placed.IdentityCheckedBy != "mort-1" ||
		placed.IdentityCheckedNote == "" {
		t.Fatalf("the identity check was not kept: %+v", placed)
	}

	// A body that moved for no recorded reason is one nobody can follow.
	refused(t, placed.End("", "mort-1", at), "say why")
	refused(t, placed.End("to the table", "", at), "names who did it")
	if err := placed.End("to the postmortem table", "mort-2",
		at.Add(time.Hour)); err != nil {
		t.Fatalf("End: %v", err)
	}
	refused(t, placed.End("again", "mort-1", at), "already ended")

	// A released case is not placed in a drawer.
	body.State = domain.CaseReleased
	_, err = domain.Place("p2", "t1", &body, space, "TAG-1", "checked",
		"mort-1", at)
	refused(t, err, "has been released")
}

func TestOccupancyCountsWhatIsActuallyUsableAndTheHistoryIsOrdered(
	t *testing.T) {

	fridge := location(t, "l1", "F2-14", domain.SpaceRefrigerated)
	freezer := location(t, "l2", "Z1-01", domain.SpaceFreezer)
	viewing := location(t, "l3", "V-1", domain.SpaceViewing)
	broken := location(t, "l4", "F2-15", domain.SpaceRefrigerated)
	if err := broken.TakeOutOfService("refrigeration failed"); err != nil {
		t.Fatalf("TakeOutOfService: %v", err)
	}

	counted := domain.CountOccupancy(
		[]domain.Location{fridge, freezer, viewing, broken},
		map[string]bool{fridge.ID: true})

	// A mortuary running at nine tenths because a third of its units are
	// broken has a different problem from one that is simply full.
	if counted.Total != 4 || counted.InService != 3 ||
		counted.OutOfService != 1 {
		t.Fatalf("the service count is wrong: %+v", counted)
	}
	if counted.Occupied != 1 || counted.Free != 2 {
		t.Fatalf("the occupancy is wrong: %+v", counted)
	}
	// A free viewing room does not help somebody looking for a drawer.
	if counted.FreeByKind[domain.SpaceRefrigerated] != 0 ||
		counted.FreeByKind[domain.SpaceFreezer] != 1 ||
		counted.FreeByKind[domain.SpaceViewing] != 1 {
		t.Fatalf("the free spaces are miscounted: %+v", counted.FreeByKind)
	}

	// "Where was it on Tuesday" is a question asked by a family who came
	// and were told the wrong thing.
	history := domain.History([]domain.Placement{
		{ID: "p2", CaseID: "c1", PlacedAt: at.Add(time.Hour)},
		{ID: "p1", CaseID: "c1", PlacedAt: at},
		{ID: "p3", CaseID: "c2", PlacedAt: at},
	}, "c1")
	if len(history) != 2 || history[0].ID != "p1" {
		t.Fatalf("the history is out of order: %+v", history)
	}
}

// ------------------------------------------------- belongings (SRS-MORT-004)

func itemInput(kind domain.ItemKind) domain.NewItemInput {
	in := domain.NewItemInput{
		Kind: kind, Description: "a jacket", Quantity: 1,
	}
	if kind == domain.ItemValuable {
		in.Description = "a gold ring"
		in.WitnessedBy = "mort-2"
		in.SealNumber = "SEAL-0091"
	}
	return in
}

func listItem(t *testing.T, id string, c domain.Case,
	in domain.NewItemInput) domain.Item {

	t.Helper()
	out, err := domain.ListItem(id, "t1", c, in, "mort-1", at)
	if err != nil {
		t.Fatalf("ListItem: %v", err)
	}
	return out
}

func TestListingAValuableNeedsASecondPersonAndASeal(t *testing.T) {
	body := openCase(t, "c1", nil)

	// A list of what was in somebody's pockets, made by one person alone,
	// is a list nobody can stand behind.
	in := itemInput(domain.ItemValuable)
	in.WitnessedBy = ""
	_, err := domain.ListItem("i1", "t1", body, in, "mort-1", at)
	refused(t, err, "needs a second person present")

	// One person signing as both is the control not working.
	in = itemInput(domain.ItemValuable)
	in.WitnessedBy = "mort-1"
	_, err = domain.ListItem("i1", "t1", body, in, "mort-1", at)
	refused(t, err, "witness to a valuable is somebody else")

	// A valuable in an unsealed bag is one nobody can say was not opened.
	in = itemInput(domain.ItemValuable)
	in.SealNumber = ""
	_, err = domain.ListItem("i1", "t1", body, in, "mort-1", at)
	refused(t, err, "numbered seal")

	// "Zero rings" is not a listing: an item that will be signed for and
	// was never there.
	in = itemInput(domain.ItemOther)
	in.Quantity = 0
	_, err = domain.ListItem("i1", "t1", body, in, "mort-1", at)
	refused(t, err, "says how many")

	in = itemInput(domain.ItemOther)
	in.Description = " "
	_, err = domain.ListItem("i1", "t1", body, in, "mort-1", at)
	refused(t, err, "says what it is")

	in = itemInput(domain.ItemOther)
	in.Kind = "treasure"
	_, err = domain.ListItem("i1", "t1", body, in, "mort-1", at)
	refused(t, err, "unknown item kind")

	_, err = domain.ListItem("i1", "t1", body, itemInput(domain.ItemOther),
		"", at)
	refused(t, err, "names who made it")

	_, err = domain.ListItem("", "t1", body, itemInput(domain.ItemOther),
		"mort-1", at)
	refused(t, err, "needs an id")

	// An ordinary jacket needs no witness and no seal.
	jacket := listItem(t, "i1", body, itemInput(domain.ItemClothing))
	if jacket.State != domain.ItemHeld {
		t.Fatalf("the item is not held: %+v", jacket)
	}

	ring := listItem(t, "i2", body, itemInput(domain.ItemValuable))
	if ring.WitnessedBy != "mort-2" || ring.SealNumber == "" {
		t.Fatalf("the valuable lost its controls: %+v", ring)
	}

	// The family cannot be told a watch the police took was handed to
	// them, so a retention is its own state.
	refused(t, ring.Retain("", "PS-14/2026"), "names the authority")
	refused(t, ring.Retain("city police", ""), "authority's reference")
	if err := ring.Retain("city police", "PS-14/2026"); err != nil {
		t.Fatalf("Retain: %v", err)
	}
	if ring.State != domain.ItemRetained {
		t.Fatalf("the retention did not stick: %+v", ring)
	}
	refused(t, ring.Retain("city police", "PS-14/2026"), "this item is")
}

func TestAHandoverNamesTheRecipientAndCannotMoveSomebodyElsesProperty(
	t *testing.T) {

	body := openCase(t, "c1", nil)
	other := openCase(t, "c2", nil)

	jacket := listItem(t, "i1", body, itemInput(domain.ItemClothing))
	ring := listItem(t, "i2", body, itemInput(domain.ItemValuable))
	theirs := listItem(t, "i3", other, itemInput(domain.ItemClothing))

	in := domain.NewHandoverInput{
		RecipientName: "A Son", RecipientRelation: "son",
		RecipientIDType: "national id", RecipientIDRef: "XX-1234",
		SignatureRef: "reg-page-114", WitnessedBy: "mort-2",
	}

	// Somebody else's wedding ring going out of the door.
	_, err := domain.HandOver("h1", "t1", body,
		[]*domain.Item{&jacket, &theirs}, in, "mort-1", at)
	refused(t, err, "belongs to another case")

	// A handover that names nothing moved nothing.
	_, err = domain.HandOver("h1", "t1", body, nil, in, "mort-1", at)
	refused(t, err, "names what was given")

	// An item the caller could not resolve arrives as a nil, which is a
	// handover listing something that is not in the register. Signing for
	// it would mean the family signed for a ring nobody can find.
	_, err = domain.HandOver("h1", "t1", body,
		[]*domain.Item{&jacket, nil}, in, "mort-1", at)
	refused(t, err, "names an item")

	bad := in
	bad.RecipientName = ""
	_, err = domain.HandOver("h1", "t1", body, []*domain.Item{&jacket},
		bad, "mort-1", at)
	refused(t, err, "names who took them")

	// Belongings handed to somebody nobody asked for identification from
	// is the story that ends in a complaint.
	bad = in
	bad.RecipientIDRef = ""
	_, err = domain.HandOver("h1", "t1", body, []*domain.Item{&jacket},
		bad, "mort-1", at)
	refused(t, err, "recipient's identification")

	// The acceptance names the signature reference, and it is the only
	// part of this a family can be shown afterwards.
	bad = in
	bad.SignatureRef = ""
	_, err = domain.HandOver("h1", "t1", body, []*domain.Item{&jacket},
		bad, "mort-1", at)
	refused(t, err, "signature reference")

	bad = in
	bad.WitnessedBy = ""
	_, err = domain.HandOver("h1", "t1", body, []*domain.Item{&jacket},
		bad, "mort-1", at)
	refused(t, err, "second member of staff")

	bad = in
	bad.WitnessedBy = "mort-1"
	_, err = domain.HandOver("h1", "t1", body, []*domain.Item{&jacket},
		bad, "mort-1", at)
	refused(t, err, "witness to a handover is somebody else")

	_, err = domain.HandOver("h1", "t1", body, []*domain.Item{&jacket},
		in, "", at)
	refused(t, err, "names who made it")

	_, err = domain.HandOver("", "t1", body, []*domain.Item{&jacket},
		in, "mort-1", at)
	refused(t, err, "needs an id")

	// The family cannot be given what the coroner has.
	if err := ring.Retain("city police", "PS-14/2026"); err != nil {
		t.Fatalf("Retain: %v", err)
	}
	_, err = domain.HandOver("h1", "t1", body,
		[]*domain.Item{&jacket, &ring}, in, "mort-1", at)
	refused(t, err, "retained by an authority")

	handed, err := domain.HandOver("h1", "t1", body,
		[]*domain.Item{&jacket}, in, "mort-1", at)
	if err != nil {
		t.Fatalf("HandOver: %v", err)
	}
	if jacket.State != domain.ItemHandedOver ||
		jacket.HandoverID != "h1" {
		t.Fatalf("the item did not move: %+v", jacket)
	}
	if len(handed.ItemIDs) != 1 || handed.SignatureRef == "" {
		t.Fatalf("the handover did not record what it moved: %+v", handed)
	}

	// The same item twice is a family signing for what they already have.
	_, err = domain.HandOver("h2", "t1", body, []*domain.Item{&jacket},
		in, "mort-1", at)
	refused(t, err, "is handed_over")

	// What the mortuary still holds is what a release is checked against:
	// a body released while the effects are in the safe is a second visit
	// nobody wants to make. A retained item is not held for the family.
	left := domain.Outstanding([]domain.Item{jacket, ring}, "c1")
	if len(left) != 0 {
		t.Fatalf("a handed-over or retained item is still outstanding: %+v",
			left)
	}
	socks := listItem(t, "i4", body, itemInput(domain.ItemClothing))
	watch := listItem(t, "i5", body, itemInput(domain.ItemValuable))
	left = domain.Outstanding([]domain.Item{socks, watch}, "c1")
	// Valuables first: they are what somebody comes back for.
	if len(left) != 2 || left[0].ID != "i5" {
		t.Fatalf("the outstanding list is wrong: %+v", left)
	}
}

func TestTheChainOfCustodyNamesWhoRecordedEachLineAndIsOrdered(t *testing.T) {
	_, err := domain.RecordCustody("e1", "t1", "c1", "received", "", "",
		"", "", at)
	refused(t, err, "names who recorded it")

	_, err = domain.RecordCustody("e1", "t1", "c1", "", "", "", "",
		"mort-1", at)
	refused(t, err, "says what happened")

	_, err = domain.RecordCustody("e1", "t1", "", "received", "", "", "",
		"mort-1", at)
	refused(t, err, "names its case")

	_, err = domain.RecordCustody("", "t1", "c1", "received", "", "", "",
		"mort-1", at)
	refused(t, err, "needs an id")

	entry, err := domain.RecordCustody("e1", "t1", "c1", "received",
		"brought from ward 3", "ward 3", "mortuary attendant", "mort-1",
		at)
	if err != nil {
		t.Fatalf("RecordCustody: %v", err)
	}
	if entry.FromParty == "" || entry.ToParty == "" {
		t.Fatalf("the two ends were lost: %+v", entry)
	}

	chain := domain.Chain([]domain.CustodyEntry{
		{ID: "e2", CaseID: "c1", RecordedAt: at.Add(time.Hour)},
		entry,
		{ID: "e3", CaseID: "c2", RecordedAt: at},
	}, "c1")
	if len(chain) != 2 || chain[0].ID != "e1" {
		t.Fatalf("the chain is out of order: %+v", chain)
	}
}

// ------------------------------------------------- postmortem (SRS-MORT-005)

func TestAnExaminationFollowsAnAuthorisationAndNeverARequestAlone(
	t *testing.T) {

	body := openCase(t, "c1", nil)

	// A medico-legal examination on a case nobody marked medico-legal is
	// either a missing flag — in which case the release rules are not
	// applying either — or the wrong case.
	_, err := domain.RequestPostmortem("pm1", "t1", body,
		domain.NewPostmortemInput{
			Kind: domain.PostmortemMedicoLegal, Reason: "unexplained",
		}, "doc-1", at)
	refused(t, err, "not marked medico-legal")

	_, err = domain.RequestPostmortem("pm1", "t1", body,
		domain.NewPostmortemInput{Kind: domain.PostmortemClinical},
		"doc-1", at)
	refused(t, err, "says why")

	_, err = domain.RequestPostmortem("pm1", "t1", body,
		domain.NewPostmortemInput{Kind: "exploratory", Reason: "x"},
		"doc-1", at)
	refused(t, err, "unknown postmortem kind")

	_, err = domain.RequestPostmortem("pm1", "t1", body,
		domain.NewPostmortemInput{
			Kind: domain.PostmortemClinical, Reason: "x",
		}, "", at)
	refused(t, err, "names who made it")

	_, err = domain.RequestPostmortem("", "t1", body,
		domain.NewPostmortemInput{
			Kind: domain.PostmortemClinical, Reason: "x",
		}, "doc-1", at)
	refused(t, err, "needs an id")

	// A body that has gone cannot be examined, and a request against one
	// is a request somebody chases for a week.
	gone := openCase(t, "c2", nil)
	gone.State = domain.CaseReleased
	_, err = domain.RequestPostmortem("pm1", "t1", gone,
		domain.NewPostmortemInput{
			Kind: domain.PostmortemClinical, Reason: "x",
		}, "doc-1", at)
	refused(t, err, "has been released")

	clinical, err := domain.RequestPostmortem("pm1", "t1", body,
		domain.NewPostmortemInput{
			Kind: domain.PostmortemClinical, Reason: "unexplained collapse",
		}, "doc-1", at)
	if err != nil {
		t.Fatalf("RequestPostmortem: %v", err)
	}

	// A body opened on a request alone is one somebody will answer for.
	refused(t, clinical.Perform("path-1", at), "follows an authorisation")

	refused(t, clinical.Authorise("", "", "mort-1", at),
		"names the authority")
	refused(t, clinical.Authorise("the family", "", "", at),
		"names who recorded it")
	// A clinical examination needs the authority named and no external
	// reference: the family consenting has no case number.
	if err := clinical.Authorise("the family", "", "mort-1",
		at); err != nil {
		t.Fatalf("Authorise: %v", err)
	}
	refused(t, clinical.Authorise("again", "", "mort-1", at),
		"this request is authorised")

	refused(t, clinical.Perform("", at), "names who performed it")
	if err := clinical.Perform("path-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Perform: %v", err)
	}
	refused(t, clinical.Report("", at), "names where it is")
	if err := clinical.Report("doc-9912", at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Report: %v", err)
	}
	refused(t, clinical.Report("doc-9913", at), "this request is reported")
	refused(t, clinical.Decline("too late", "mort-1", at),
		"this request is reported")
}

func TestAMedicoLegalAuthorisationCarriesTheAuthoritysOwnReference(
	t *testing.T) {

	body := openCase(t, "c1", nil)
	if err := body.MarkMedicoLegal("PS-14/2026", "mort-1"); err != nil {
		t.Fatalf("MarkMedicoLegal: %v", err)
	}

	legal, err := domain.RequestPostmortem("pm1", "t1", body,
		domain.NewPostmortemInput{
			Kind: domain.PostmortemMedicoLegal, Reason: "death in custody",
		}, "doc-1", at)
	if err != nil {
		t.Fatalf("RequestPostmortem: %v", err)
	}

	// "Authorised by the coroner" with no reference is a sentence, and the
	// question asked at the inquest is which order.
	refused(t, legal.Authorise("the coroner", "", "mort-1", at),
		"authority's reference")
	if err := legal.Authorise("the coroner", "CO-2026-0044", "mort-1",
		at); err != nil {
		t.Fatalf("Authorise: %v", err)
	}

	// A declined request is kept: "we asked and were refused" is a
	// different record from never having asked.
	second, err := domain.RequestPostmortem("pm2", "t1", body,
		domain.NewPostmortemInput{
			Kind: domain.PostmortemClinical, Reason: "family asked",
		}, "doc-1", at)
	if err != nil {
		t.Fatalf("RequestPostmortem: %v", err)
	}
	refused(t, second.Decline("", "mort-1", at), "says why")
	refused(t, second.Decline("family withdrew consent", "", at),
		"names who recorded it")
	if err := second.Decline("family withdrew consent", "mort-1",
		at); err != nil {
		t.Fatalf("Decline: %v", err)
	}
	if second.State != domain.PostmortemDeclined {
		t.Fatalf("the decline did not stick: %+v", second)
	}

	// An examination asked for and not finished holds the body. A clinical
	// one already performed does not: the report can follow the funeral,
	// and holding a family for it is a cruelty with no purpose.
	if err := legal.Perform("path-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Perform: %v", err)
	}
	blocking := domain.Blocking([]domain.Postmortem{legal, second}, "c1")
	if len(blocking) != 1 || blocking[0].ID != "pm1" {
		t.Fatalf("the blocking set is wrong: %+v", blocking)
	}
	if err := legal.Report("doc-9912", at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Report: %v", err)
	}
	if got := domain.Blocking([]domain.Postmortem{legal, second},
		"c1"); len(got) != 0 {
		t.Fatalf("a reported examination still blocks: %+v", got)
	}
}

// ---------------------------------------------------- release (SRS-MORT-006)

func releaseInput() domain.ReleaseInput {
	return domain.ReleaseInput{
		RecipientName: "A Son", RecipientRelation: "son",
		RecipientIDType: "national id", RecipientIDRef: "XX-1234",
		VerificationNote: "identity confirmed against the register and " +
			"the son's identity card",
		SignatureRef: "reg-page-114", Destination: "a funeral director",
		WitnessedBy: "mort-2",
	}
}

func codes(checks []domain.ReleaseCheck) map[string]bool {
	out := map[string]bool{}
	for _, check := range checks {
		out[check.Code] = true
	}
	return out
}

func TestAMedicoLegalCaseIsNotReleasedWithoutTheAuthoritysClearance(
	t *testing.T) {

	body := openCase(t, "c1", nil)
	if err := body.MarkMedicoLegal("PS-14/2026", "mort-1"); err != nil {
		t.Fatalf("MarkMedicoLegal: %v", err)
	}

	// No policy setting switches this off. A body an authority has an
	// interest in, released on the mortuary's own say-so, is evidence that
	// has left the building.
	checks := domain.ReleaseChecks(body, domain.ReleasePolicy{},
		domain.Authorisation{}, nil, nil, releaseInput())
	if !codes(checks)[domain.CheckAuthority] {
		t.Fatalf("a medico-legal case released with no clearance: %+v",
			checks)
	}
	for _, check := range checks {
		if check.Code == domain.CheckAuthority && !check.Mandatory {
			t.Fatal("the authority check is not mandatory")
		}
	}

	_, err := domain.ReleaseBody("r1", "t1", &body, domain.ReleasePolicy{},
		domain.Authorisation{}, nil, nil, releaseInput(), "mort-1", at)
	refused(t, err, "authority's clearance")

	// A clearance is a named authority and their own reference. Either
	// alone is not something anybody can check.
	half := domain.Authorisation{Authority: "the coroner"}
	_, err = domain.ReleaseBody("r1", "t1", &body, domain.ReleasePolicy{},
		half, nil, nil, releaseInput(), "mort-1", at)
	refused(t, err, "authority's clearance")

	cleared := domain.Authorisation{
		Authority: "the coroner", Reference: "CO-2026-0044",
		RecordedBy: "mort-1", RecordedAt: at,
	}
	released, err := domain.ReleaseBody("r1", "t1", &body,
		domain.ReleasePolicy{}, cleared, nil, nil, releaseInput(),
		"mort-1", at)
	if err != nil {
		t.Fatalf("ReleaseBody: %v", err)
	}
	// The release carries the clearance, so the question "under whose
	// authority" is answered by the record rather than by somebody's
	// memory.
	if released.Authority != "the coroner" ||
		released.AuthorityReference != "CO-2026-0044" ||
		!released.MedicoLegal {
		t.Fatalf("the clearance was not kept: %+v", released)
	}
	if body.State != domain.CaseReleased || body.LocationID != "" {
		t.Fatalf("the case did not close: %+v", body)
	}

	// A body leaves once.
	_, err = domain.ReleaseBody("r2", "t1", &body, domain.ReleasePolicy{},
		cleared, nil, nil, releaseInput(), "mort-1", at)
	refused(t, err, "already been released")
}

func TestAnUnidentifiedBodyNeedsAClearanceAndAReleaseNeedsTwoPeople(
	t *testing.T) {

	unknown := openCase(t, "c1", func(in *domain.NewCaseInput) {
		in.Source, in.EncounterID = domain.SourceBroughtIn, ""
		in.ExternalSource = "city police"
		in.Identity, in.DisplayName = domain.IdentityUnidentified, ""
	})

	// Handing over a body nobody has named, to somebody who says it is
	// theirs, is the failure this exists to prevent.
	_, err := domain.ReleaseBody("r1", "t1", &unknown,
		domain.ReleasePolicy{}, domain.Authorisation{}, nil, nil,
		releaseInput(), "mort-1", at)
	refused(t, err, "unidentified body is released on an authority")

	cleared := domain.Authorisation{
		Authority: "the coroner", Reference: "CO-2026-0044",
	}

	// A body leaving on one person's word is the case every mortuary
	// inquiry turns out to be about.
	in := releaseInput()
	in.WitnessedBy = ""
	_, err = domain.ReleaseBody("r1", "t1", &unknown,
		domain.ReleasePolicy{}, cleared, nil, nil, in, "mort-1", at)
	refused(t, err, "second member of staff")

	in = releaseInput()
	in.WitnessedBy = "mort-1"
	_, err = domain.ReleaseBody("r1", "t1", &unknown,
		domain.ReleasePolicy{}, cleared, nil, nil, in, "mort-1", at)
	refused(t, err, "witness to a release is somebody else")

	_, err = domain.ReleaseBody("r1", "t1", &unknown,
		domain.ReleasePolicy{}, cleared, nil, nil, releaseInput(), "", at)
	refused(t, err, "names who made it")

	_, err = domain.ReleaseBody("", "t1", &unknown, domain.ReleasePolicy{},
		cleared, nil, nil, releaseInput(), "mort-1", at)
	refused(t, err, "needs an id")

	// The recipient, the signature and what was verified are the record of
	// where the body went.
	for _, bad := range []struct {
		mutate func(*domain.ReleaseInput)
		want   string
	}{
		{func(in *domain.ReleaseInput) { in.RecipientName = "" },
			"name who is taking the body"},
		{func(in *domain.ReleaseInput) { in.SignatureRef = "" },
			"signature reference"},
		{func(in *domain.ReleaseInput) { in.VerificationNote = "" },
			"what was verified"},
	} {
		in := releaseInput()
		bad.mutate(&in)
		_, err := domain.ReleaseBody("r1", "t1", &unknown,
			domain.ReleasePolicy{}, cleared, nil, nil, in, "mort-1", at)
		refused(t, err, bad.want)
	}
}

// SRS-MORT-007: the policy is configuration with a floor, and the whole list
// comes back at once.
func TestThePolicyTightensTheChecksAndTheyComeBackAsAList(t *testing.T) {
	body := openCase(t, "c1", func(in *domain.NewCaseInput) {
		in.Identity = domain.IdentityPresumed
	})
	ring := listItem(t, "i1", body, itemInput(domain.ItemValuable))
	pending, err := domain.RequestPostmortem("pm1", "t1", body,
		domain.NewPostmortemInput{
			Kind: domain.PostmortemClinical, Reason: "unexplained",
		}, "doc-1", at)
	if err != nil {
		t.Fatalf("RequestPostmortem: %v", err)
	}

	strict := domain.ReleasePolicy{
		RequireDeathCertificate:        true,
		RequireConfirmedIdentity:       true,
		RequireBelongingsSettled:       true,
		RequireRecipientIdentification: true,
	}

	in := releaseInput()
	in.RecipientIDType, in.RecipientIDRef = "", ""
	checks := domain.ReleaseChecks(body, strict, domain.Authorisation{},
		[]domain.Item{ring}, []domain.Postmortem{pending}, in)

	// A mortuary told "no identity check" will do the identity check and
	// come back to be told "no death certificate". The whole list comes
	// back at once.
	got := codes(checks)
	for _, want := range []string{
		domain.CheckIdentity, domain.CheckDeathCertificate,
		domain.CheckPostmortem, domain.CheckBelongings,
		domain.CheckRecipient,
	} {
		if !got[want] {
			t.Fatalf("check %q is missing: %+v", want, checks)
		}
	}
	// Mandatory first: clear the ones no policy can waive before the ones
	// somebody might.
	if !checks[0].Mandatory {
		t.Fatalf("the list does not lead with the mandatory checks: %+v",
			checks)
	}

	// A released examination no longer blocks, a settled belonging no
	// longer blocks, and a recorded certificate satisfies the policy from
	// the case rather than from the release form.
	if err := pending.Authorise("the family", "", "mort-1", at); err != nil {
		t.Fatalf("Authorise: %v", err)
	}
	if err := pending.Perform("path-1", at); err != nil {
		t.Fatalf("Perform: %v", err)
	}
	if err := body.RecordDeathCertificate("D-2026-0091", "mort-1",
		at); err != nil {
		t.Fatalf("RecordDeathCertificate: %v", err)
	}
	if err := body.Identify(domain.IdentityConfirmed, "A Patient",
		"identified by his son", "mort-2", at); err != nil {
		t.Fatalf("Identify: %v", err)
	}
	if err := ring.Retain("city police", "PS-14/2026"); err != nil {
		t.Fatalf("Retain: %v", err)
	}

	checks = domain.ReleaseChecks(body, strict, domain.Authorisation{},
		domain.Outstanding([]domain.Item{ring}, "c1"),
		domain.Blocking([]domain.Postmortem{pending}, "c1"),
		releaseInput())
	if len(checks) != 0 {
		t.Fatalf("the checks did not clear: %+v", checks)
	}

	released, err := domain.ReleaseBody("r1", "t1", &body, strict,
		domain.Authorisation{},
		domain.Outstanding([]domain.Item{ring}, "c1"),
		domain.Blocking([]domain.Postmortem{pending}, "c1"),
		releaseInput(), "mort-1", at)
	if err != nil {
		t.Fatalf("ReleaseBody: %v", err)
	}
	// The certificate came from the case, which is where it was recorded.
	if released.DeathCertificateRef != "D-2026-0091" {
		t.Fatalf("the certificate did not travel: %+v", released)
	}
}

// --------------------------------------------------- the board (SRS-MORT-008)

// SRS-MORT-003 and SRS-MORT-008: the board redacts a restricted case's name
// and has no field for a cause at all.
func TestTheBoardShowsNoNameForARestrictedCaseAndLeadsWithTheOldest(
	t *testing.T) {

	ordinary := openCase(t, "c1", nil)
	ordinary.ReceivedAt = at.Add(-72 * time.Hour)
	ordinary.State = domain.CaseStored
	ordinary.LocationID, ordinary.StorageTag = "l1", "TAG-1"

	restricted := openCase(t, "c2", func(in *domain.NewCaseInput) {
		in.Restricted = true
		in.DisplayName = "A Public Figure"
		in.MedicoLegal = true
	})
	if err := restricted.RecordCause("the sensitive line",
		"coroner-1"); err != nil {
		t.Fatalf("RecordCause: %v", err)
	}
	restricted.ReceivedAt = at.Add(-2 * time.Hour)

	gone := openCase(t, "c3", nil)
	gone.State = domain.CaseReleased

	board := domain.Summarise([]domain.Case{ordinary, restricted, gone},
		map[string]bool{ordinary.ID: true}, at)

	if len(board) != 2 {
		t.Fatalf("a released case is still on the board: %+v", board)
	}
	// A mortuary's problem is the body that has been there three weeks,
	// and a list in arrival order puts it at the bottom.
	if board[0].CaseID != "c1" || board[0].HeldHours != 72 {
		t.Fatalf("the board does not lead with the oldest: %+v", board)
	}
	if !board[0].PendingRelease {
		t.Fatalf("the pending release was lost: %+v", board[0])
	}

	// The board is read in a corridor and on a shared screen.
	if board[1].DisplayName != "" {
		t.Fatalf("a restricted case shows its name: %+v", board[1])
	}
	if board[1].Reference == "" {
		t.Fatalf("a restricted case shows nothing to find it by: %+v",
			board[1])
	}
	// An attendant needs to know a case needs clearance before they move
	// it, and does not need the police number to know that.
	if !board[1].MedicoLegal {
		t.Fatalf("the board hides that a case is medico-legal: %+v",
			board[1])
	}

	// And nothing on the board carries the cause. The projection has no
	// field for it, which is the point: a second screen cannot be written
	// that forgets to redact it.
	for _, row := range board {
		if strings.Contains(row.Reference+row.DisplayName,
			"the sensitive line") {
			t.Fatalf("the cause reached the board: %+v", row)
		}
	}
}

func TestPendingReleaseIsComputedFromTheChecksRatherThanAFlag(t *testing.T) {
	ready := openCase(t, "c1", nil)
	held := openCase(t, "c2", nil)
	if err := held.MarkMedicoLegal("PS-14/2026", "mort-1"); err != nil {
		t.Fatalf("MarkMedicoLegal: %v", err)
	}

	pending := domain.PendingRelease([]domain.Case{ready, held},
		domain.ReleasePolicy{}, nil, nil, nil)
	if !pending[ready.ID] {
		t.Fatalf("a clear case is not pending release: %+v", pending)
	}
	// A flag set when the paperwork arrived goes stale the moment a
	// coroner takes an interest.
	if pending[held.ID] {
		t.Fatalf("a medico-legal case with no clearance is pending: %+v",
			pending)
	}

	cleared := map[string]domain.Authorisation{
		held.ID: {Authority: "the coroner", Reference: "CO-2026-0044"},
	}
	pending = domain.PendingRelease([]domain.Case{ready, held},
		domain.ReleasePolicy{}, cleared, nil, nil)
	if !pending[held.ID] {
		t.Fatalf("a cleared case is not pending release: %+v", pending)
	}

	// The certificate the policy asks for is read from the case, so a
	// mortuary can see which bodies are waiting on paperwork.
	strict := domain.ReleasePolicy{RequireDeathCertificate: true}
	pending = domain.PendingRelease([]domain.Case{ready},
		strict, nil, nil, nil)
	if pending[ready.ID] {
		t.Fatalf("a case with no certificate is pending: %+v", pending)
	}
	if err := ready.RecordDeathCertificate("D-1", "mort-1", at); err != nil {
		t.Fatalf("RecordDeathCertificate: %v", err)
	}
	pending = domain.PendingRelease([]domain.Case{ready}, strict, nil, nil,
		nil)
	if !pending[ready.ID] {
		t.Fatalf("a case with its certificate is not pending: %+v", pending)
	}

	// A released case is never pending.
	ready.State = domain.CaseReleased
	if got := domain.PendingRelease([]domain.Case{ready}, strict, nil, nil,
		nil); got[ready.ID] {
		t.Fatalf("a released case is pending release: %+v", got)
	}
}
