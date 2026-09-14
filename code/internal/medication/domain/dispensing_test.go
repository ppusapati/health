package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/medication/domain"
)

// SRS-MED-006: verification is a second person reading the prescription.
func TestAPharmacistCannotVerifyTheirOwnPrescription(t *testing.T) {
	p := newLive(t, simpleInput())

	if err := p.Verify("dr-rao", "", at(2026, time.March, 2, 5, 0)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("a prescriber verified their own prescription: %v", err)
	}
	if err := p.Verify("pharm-nair", "checked", at(2026, time.March, 2, 5, 0)); err != nil {
		t.Fatalf("Verify: %v", err)
	}
	if !p.Verification.Done() {
		t.Fatal("verification was not recorded")
	}
	if p.Verification.By != "pharm-nair" {
		t.Fatalf("verified by %q", p.Verification.By)
	}
}

func TestRepeatingAVerificationDoesNotMoveItsTimestamp(t *testing.T) {
	p := newLive(t, simpleInput())
	first := at(2026, time.March, 2, 5, 0)
	if err := p.Verify("pharm-nair", "checked", first); err != nil {
		t.Fatalf("Verify: %v", err)
	}
	if err := p.Verify("pharm-nair", "checked again", at(2026, time.March, 2, 9, 0)); err != nil {
		t.Fatalf("second Verify: %v", err)
	}
	if !p.Verification.At.Equal(first) {
		t.Fatalf("verification time moved to %s", p.Verification.At)
	}
}

func TestADraftPrescriptionCannotBeVerified(t *testing.T) {
	p, err := domain.NewPrescription("rx1", "t1", simpleInput(), at(2026, time.March, 2, 3, 0))
	if err != nil {
		t.Fatalf("NewPrescription: %v", err)
	}
	if err := p.Verify("pharm-nair", "", at(2026, time.March, 2, 5, 0)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("a draft was verified: %v", err)
	}
}

// SRS-MED-006: the policy can be narrowed rather than only switched off.
func TestVerificationCanBeRequiredForSomeClassesOnly(t *testing.T) {
	cytotoxics := domain.Coding{System: "atc", Code: "L01", Display: "Cytotoxics"}
	policy := domain.VerificationPolicy{
		RequiredForClasses: map[string]bool{cytotoxics.Key(): true},
	}

	if policy.RequiresVerification(domain.MedicationProfile{
		Classes: []domain.Coding{penicillinClass()},
	}) {
		t.Fatal("an antibiotic required verification under a cytotoxics-only policy")
	}
	if !policy.RequiresVerification(domain.MedicationProfile{
		Classes: []domain.Coding{cytotoxics},
	}) {
		t.Fatal("a cytotoxic did not require verification")
	}
}

func TestVerificationIsRequiredByDefault(t *testing.T) {
	if !domain.DefaultVerificationPolicy().RequiresVerification(
		domain.MedicationProfile{}) {
		t.Fatal("the default policy does not require pharmacist verification")
	}
}

func paracetamol() domain.Coding {
	return domain.Coding{System: "rxnorm", Code: "161", Display: "Paracetamol 500mg tablet"}
}

func generic() domain.Coding {
	return domain.Coding{System: "rxnorm", Code: "162", Display: "Acetaminophen 500mg tablet"}
}

// SRS-MED-011: the dispensed product is recorded beside the prescribed one,
// never over it.
func TestASubstitutionLeavesThePrescribedProductAlone(t *testing.T) {
	s, err := domain.NewSubstitution("sub1", "t1", "rx1", paracetamol(), generic(),
		domain.SubstitutionGeneric, "stocked brand", "pharm-nair",
		at(2026, time.March, 2, 5, 0))
	if err != nil {
		t.Fatalf("NewSubstitution: %v", err)
	}
	if s.Prescribed.Key() != paracetamol().Key() {
		t.Fatal("the substitution does not carry what was prescribed")
	}
	if s.Dispensed.Key() != generic().Key() {
		t.Fatal("the substitution does not carry what was dispensed")
	}
	if s.Status != domain.SubstitutionProposed {
		t.Fatalf("status = %q, want proposed", s.Status)
	}
}

func TestASubstitutionNeedsAReason(t *testing.T) {
	_, err := domain.NewSubstitution("sub1", "t1", "rx1", paracetamol(), generic(),
		domain.SubstitutionGeneric, "  ", "pharm-nair", at(2026, time.March, 2, 5, 0))
	if !errors.Is(err, domain.ErrInvalidPrescription) {
		t.Fatalf("a reasonless substitution was accepted: %v", err)
	}
}

func TestASubstitutionMustDispenseSomethingDifferent(t *testing.T) {
	_, err := domain.NewSubstitution("sub1", "t1", "rx1", paracetamol(), paracetamol(),
		domain.SubstitutionGeneric, "stock", "pharm-nair", at(2026, time.March, 2, 5, 0))
	if !errors.Is(err, domain.ErrInvalidPrescription) {
		t.Fatalf("a substitution for the same product was accepted: %v", err)
	}
}

// SRS-MED-011: a therapeutic swap is a prescribing decision and needs somebody
// other than the pharmacist proposing it.
func TestATherapeuticSubstitutionNeedsSomebodyElseToAuthoriseIt(t *testing.T) {
	s, err := domain.NewSubstitution("sub1", "t1", "rx1", paracetamol(),
		domain.Coding{System: "rxnorm", Code: "5640", Display: "Ibuprofen 400mg tablet"},
		domain.SubstitutionTherapeutic, "paracetamol unavailable", "pharm-nair",
		at(2026, time.March, 2, 5, 0))
	if err != nil {
		t.Fatalf("NewSubstitution: %v", err)
	}

	if err := s.Authorize("pharm-nair", at(2026, time.March, 2, 6, 0)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("a pharmacist authorised their own therapeutic substitution: %v", err)
	}
	if err := s.Authorize("dr-rao", at(2026, time.March, 2, 6, 0)); err != nil {
		t.Fatalf("Authorize: %v", err)
	}
	if s.AuthorizedBy != "dr-rao" {
		t.Fatalf("authorised by %q", s.AuthorizedBy)
	}
}

// A generic swap is the pharmacist's own call.
func TestAGenericSubstitutionIsThePharmacistsOwnCall(t *testing.T) {
	s, _ := domain.NewSubstitution("sub1", "t1", "rx1", paracetamol(), generic(),
		domain.SubstitutionGeneric, "stocked brand", "pharm-nair",
		at(2026, time.March, 2, 5, 0))
	if err := s.Authorize("pharm-nair", at(2026, time.March, 2, 6, 0)); err != nil {
		t.Fatalf("a pharmacist could not authorise a generic swap: %v", err)
	}
}

// SRS-MED-011: nothing is dispensed on an unauthorised substitution.
func TestAnUnauthorisedSubstitutionIsNotDispensed(t *testing.T) {
	s, _ := domain.NewSubstitution("sub1", "t1", "rx1", paracetamol(), generic(),
		domain.SubstitutionGeneric, "stocked brand", "pharm-nair",
		at(2026, time.March, 2, 5, 0))

	if err := s.Dispense(at(2026, time.March, 2, 7, 0)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("an unauthorised substitution was dispensed: %v", err)
	}
	_ = s.Authorize("pharm-nair", at(2026, time.March, 2, 6, 0))
	if err := s.Dispense(at(2026, time.March, 2, 7, 0)); err != nil {
		t.Fatalf("Dispense: %v", err)
	}
	if s.DispensedAt.IsZero() {
		t.Fatal("the dispensing time was not recorded")
	}
}

func TestARejectedSubstitutionCannotBeAuthorisedLater(t *testing.T) {
	s, _ := domain.NewSubstitution("sub1", "t1", "rx1", paracetamol(), generic(),
		domain.SubstitutionGeneric, "stocked brand", "pharm-nair",
		at(2026, time.March, 2, 5, 0))
	if err := s.Reject("dr-rao", "patient reacted to the generic", at(2026, time.March, 2, 6, 0)); err != nil {
		t.Fatalf("Reject: %v", err)
	}
	if err := s.Authorize("dr-rao", at(2026, time.March, 2, 7, 0)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("a rejected substitution was authorised: %v", err)
	}
}

// SRS-MED-012: a non-formulary choice shows the approval path rather than
// refusing.
func TestANonFormularyMedicationShowsItsApprovalPathRatherThanRefusing(t *testing.T) {
	entries := []domain.FormularyEntry{{
		Medication: paracetamol(), Scope: domain.FormularyScopeTenant,
		Status:       domain.FormularyNonFormulary,
		ApprovalPath: "drugs and therapeutics committee, weekly",
	}}

	decision := domain.CheckFormulary(entries, paracetamol(),
		domain.MedicationProfile{}, domain.FormularyQuery{})
	if decision.Status != domain.FormularyNonFormulary {
		t.Fatalf("status = %q", decision.Status)
	}
	if decision.ApprovalPath == "" {
		t.Fatal("a non-formulary decision came back with no approval path")
	}
	if !decision.NeedsApproval() {
		t.Fatal("a non-formulary decision does not need approval")
	}
}

func TestANonFormularyEntryMustSayHowToGetApproval(t *testing.T) {
	e := domain.FormularyEntry{
		Medication: paracetamol(), Scope: domain.FormularyScopeTenant,
		Status: domain.FormularyNonFormulary,
	}
	if err := e.Validate(); !errors.Is(err, domain.ErrInvalidPrescription) {
		t.Fatalf("a dead-end non-formulary entry was accepted: %v", err)
	}
}

func TestARestrictedEntryMustSayWhatTheRestrictionIs(t *testing.T) {
	e := domain.FormularyEntry{
		Medication: paracetamol(), Scope: domain.FormularyScopeTenant,
		Status: domain.FormularyRestricted,
	}
	if err := e.Validate(); !errors.Is(err, domain.ErrInvalidPrescription) {
		t.Fatalf("a restricted entry with no restriction was accepted: %v", err)
	}
}

// SRS-MED-012: the narrowest scope wins.
func TestTheNarrowestFormularyScopeWins(t *testing.T) {
	entries := []domain.FormularyEntry{
		{Medication: paracetamol(), Scope: domain.FormularyScopeTenant,
			Status: domain.FormularyIncluded},
		{Medication: paracetamol(), Scope: domain.FormularyScopeDepartment,
			ScopeID: "onc", Status: domain.FormularyRestricted,
			Restriction: "consultant oncologist only"},
	}

	wide := domain.CheckFormulary(entries, paracetamol(), domain.MedicationProfile{},
		domain.FormularyQuery{FacilityID: "f1"})
	if wide.Status != domain.FormularyIncluded {
		t.Fatalf("outside oncology the status is %q", wide.Status)
	}

	narrow := domain.CheckFormulary(entries, paracetamol(), domain.MedicationProfile{},
		domain.FormularyQuery{FacilityID: "f1", DepartmentID: "onc"})
	if narrow.Status != domain.FormularyRestricted {
		t.Fatalf("in oncology the status is %q, want restricted", narrow.Status)
	}
	if narrow.Restriction == "" {
		t.Fatal("the restriction is not carried")
	}
}

// A payer's list does not bind a patient that payer is not paying for.
func TestAPayersListDoesNotBindAPatientTheyAreNotPayingFor(t *testing.T) {
	entries := []domain.FormularyEntry{{
		Medication: paracetamol(), Scope: domain.FormularyScopePayer,
		ScopeID: "insurer-a", Status: domain.FormularyNonFormulary,
		ApprovalPath: "prior authorisation",
	}}

	selfPaying := domain.CheckFormulary(entries, paracetamol(),
		domain.MedicationProfile{}, domain.FormularyQuery{FacilityID: "f1"})
	if selfPaying.Status != domain.FormularyUnknown {
		t.Fatalf("a self-paying patient was bound by an insurer's list: %q", selfPaying.Status)
	}

	insured := domain.CheckFormulary(entries, paracetamol(),
		domain.MedicationProfile{}, domain.FormularyQuery{PayerID: "insurer-a"})
	if insured.Status != domain.FormularyNonFormulary {
		t.Fatalf("the insurer's own patient was not bound: %q", insured.Status)
	}
}

// "Nobody has classified this" is a different answer from "we do not stock it".
func TestAnUnclassifiedMedicationIsUnknownRatherThanNonFormulary(t *testing.T) {
	decision := domain.CheckFormulary(nil, paracetamol(), domain.MedicationProfile{},
		domain.FormularyQuery{})
	if decision.Status != domain.FormularyUnknown {
		t.Fatalf("status = %q, want unknown", decision.Status)
	}
	if decision.NeedsApproval() {
		t.Fatal("an unclassified medication was treated as needing approval")
	}
}

// A formulary entry may be written against a class rather than a product.
func TestAFormularyEntryCanBeWrittenAgainstAClass(t *testing.T) {
	entries := []domain.FormularyEntry{{
		Medication: penicillinClass(), Scope: domain.FormularyScopeTenant,
		Status: domain.FormularyRestricted, Restriction: "microbiology approval",
	}}

	decision := domain.CheckFormulary(entries,
		domain.Coding{System: "rxnorm", Code: "19711", Display: "Co-amoxiclav"},
		coAmoxiclavProfile(), domain.FormularyQuery{})
	if decision.Status != domain.FormularyRestricted {
		t.Fatalf("a class-level entry did not catch a member of the class: %q", decision.Status)
	}
}
