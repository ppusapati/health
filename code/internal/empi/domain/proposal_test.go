package domain_test

import (
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/empi/domain"
)

func moment(y int, m time.Month, d int) time.Time {
	return time.Date(y, m, d, 0, 0, 0, 0, time.UTC)
}

func withBirthDate(d domain.Demographics, y int, m time.Month, day int,
	precision domain.DatePrecision) domain.Demographics {
	d.BirthDate = domain.BirthDate{Date: moment(y, m, day), Precision: precision}
	return d
}

func onFile() domain.Demographics {
	return withBirthDate(domain.Demographics{
		Name: domain.HumanName{Family: "Iyer", Given: []string{"Meera"}},
		Sex:  domain.SexFemale,
		Phones: []domain.ContactPoint{
			{System: domain.ContactPhone, Value: "9876543210"},
		},
	}, 1984, time.March, 12, domain.PrecisionDay)
}

// A source that agrees raises nothing. If agreement produced a worklist item,
// every routine feed would fill the queue and a reviewer would stop reading it
// — which is how a real conflict gets waved through.
func TestAgreementIsNotAConflict(t *testing.T) {
	if got := domain.DetectConflicts(onFile(), onFile(), domain.ProposeOnlyConflicts); len(got) != 0 {
		t.Fatalf("identical demographics produced %d conflicts: %+v", len(got), got)
	}
}

// The same number written differently is the same number. A conflict here would
// be noise a human has to dismiss on every feed.
func TestFormattingIsNotAConflict(t *testing.T) {
	incoming := onFile()
	incoming.Phones = []domain.ContactPoint{
		{System: domain.ContactPhone, Value: "+91 98765 43210"},
	}

	if got := domain.DetectConflicts(onFile(), incoming, domain.ProposeOnlyConflicts); len(got) != 0 {
		t.Fatalf("a reformatted phone number was reported as a conflict: %+v", got)
	}
}

// A field the source does not carry is not a claim that the patient has none.
func TestAMissingIncomingFieldIsNotAConflict(t *testing.T) {
	incoming := domain.Demographics{
		Name: domain.HumanName{Family: "Iyer", Given: []string{"Meera"}},
	}

	for _, f := range domain.DetectConflicts(onFile(), incoming, domain.ProposeOnlyConflicts) {
		if f.Field == domain.FieldBirthDate || f.Field == domain.FieldPhone {
			t.Fatalf("a field the source omitted was reported as a conflict: %+v", f)
		}
	}
}

// A registry holding only a year does not contradict a record holding a full
// date. Rendering both as a day-precision date would make it look as if it did.
func TestALessPreciseDateIsStillReportedButNotAsTheSameValue(t *testing.T) {
	incoming := withBirthDate(onFile(), 1984, time.January, 1, domain.PrecisionYear)

	got := domain.DetectConflicts(onFile(), incoming, domain.ProposeOnlyConflicts)
	var birth *domain.FieldProposal
	for i := range got {
		if got[i].Field == domain.FieldBirthDate {
			birth = &got[i]
		}
	}
	if birth == nil {
		t.Fatalf("a differing birth date was not reported: %+v", got)
	}
	if birth.ProposedValue != "1984" {
		t.Fatalf("proposed birth date = %q, want the year alone so a reviewer "+
			"sees the precision the source actually holds", birth.ProposedValue)
	}
	if birth.CurrentValue != "1984-03-12" {
		t.Fatalf("current birth date = %q, want the full date on file", birth.CurrentValue)
	}
}

// An estimated date must never read as a stated one.
func TestAnEstimatedDateIsMarkedAsEstimated(t *testing.T) {
	incoming := withBirthDate(onFile(), 1984, time.January, 1, domain.PrecisionEstimated)

	for _, f := range domain.DetectConflicts(onFile(), incoming, domain.ProposeOnlyConflicts) {
		if f.Field != domain.FieldBirthDate {
			continue
		}
		if f.ProposedValue != "1984 (estimated)" {
			t.Fatalf("an estimated date rendered as %q, which a reviewer would "+
				"read as a stated date", f.ProposedValue)
		}
		return
	}
	t.Fatal("the estimated date was not reported at all")
}

// Filling a blank is a different act from contradicting a value, and the caller
// chooses which it wants.
func TestFillingABlankIsOptional(t *testing.T) {
	current := onFile()
	current.BirthDate = domain.BirthDate{}

	incoming := withBirthDate(onFile(), 1984, time.March, 12, domain.PrecisionDay)

	conflictsOnly := domain.DetectConflicts(current, incoming, domain.ProposeOnlyConflicts)
	for _, f := range conflictsOnly {
		if f.Field == domain.FieldBirthDate {
			t.Fatalf("filling a blank was reported as a conflict: %+v", f)
		}
	}

	withBlanks := domain.DetectConflicts(current, incoming, domain.ProposeFillingBlanks)
	for _, f := range withBlanks {
		if f.Field == domain.FieldBirthDate {
			return
		}
	}
	t.Fatalf("filling a blank was not proposed even when asked for: %+v", withBlanks)
}

func proposal(t *testing.T, fields []domain.FieldProposal) domain.Proposal {
	t.Helper()

	p, err := domain.NewProposal("p-1", "patient-1", domain.OriginExternalSource,
		"ABDM", "feed-service", "", fields, 3, moment(2026, time.September, 1))
	if err != nil {
		t.Fatalf("NewProposal: %v", err)
	}
	return p
}

// A proposal that changes nothing is a bug in the caller, not an empty queue
// item for somebody to close.
func TestAProposalMustProposeSomething(t *testing.T) {
	if _, err := domain.NewProposal("p-1", "patient-1", domain.OriginExternalSource,
		"ABDM", "feed", "", nil, 1, moment(2026, time.September, 1)); err == nil {
		t.Fatal("a proposal with no fields was accepted")
	}
}

// A proposal must say what claimed it; SRS-EMPI-012 is about reconciling
// disagreements between sources, and one with no source reconciles against
// nothing.
func TestAProposalMustNameItsSource(t *testing.T) {
	fields := []domain.FieldProposal{{
		Field: domain.FieldFamilyName, CurrentValue: "Iyer", ProposedValue: "Rao",
	}}
	if _, err := domain.NewProposal("p-1", "patient-1", domain.OriginExternalSource,
		"", "feed", "", fields, 1, moment(2026, time.September, 1)); err == nil {
		t.Fatal("a proposal with no source was accepted")
	}
}

// "The spelling on my passport" and "I would prefer a different name" are
// different requests with the same proposed value.
func TestACorrectionRequestNeedsAReason(t *testing.T) {
	fields := []domain.FieldProposal{{
		Field: domain.FieldFamilyName, CurrentValue: "Iyer", ProposedValue: "Iyyer",
	}}
	if _, err := domain.NewProposal("p-1", "patient-1", domain.OriginCorrectionRequest,
		"patient", "patient-1", "", fields, 1, moment(2026, time.September, 1)); err == nil {
		t.Fatal("a correction request with no reason was accepted")
	}
}

// A reviewer takes the correction and refuses the conflict. That is the whole
// reason proposals are per field rather than per submission.
func TestFieldsAreAcceptedIndividually(t *testing.T) {
	p := proposal(t, []domain.FieldProposal{
		{Field: domain.FieldFamilyName, CurrentValue: "Iyer", ProposedValue: "Iyyer"},
		{Field: domain.FieldBirthDate, CurrentValue: "1984-03-12", ProposedValue: "1984-12-03"},
	})

	if err := p.Resolve([]domain.Field{domain.FieldFamilyName}, "him-1",
		"spelling confirmed against passport; birth date disagrees with the chart",
		moment(2026, time.September, 2)); err != nil {
		t.Fatalf("Resolve: %v", err)
	}

	if p.Status != domain.ProposalAccepted {
		t.Fatalf("status = %q, want accepted", p.Status)
	}
	accepted := p.AcceptedFields()
	if len(accepted) != 1 || accepted[0] != domain.FieldFamilyName {
		t.Fatalf("accepted = %+v, want only the family name", accepted)
	}

	applied, err := onFile().Apply(p)
	if err != nil {
		t.Fatalf("Apply: %v", err)
	}
	if applied.Name.Family != "Iyyer" {
		t.Fatalf("family name = %q, want the accepted correction", applied.Name.Family)
	}
	// The refused field must not travel across as a side effect.
	if got := applied.BirthDate.Compare(); got != "1984-03-12" {
		t.Fatalf("birth date = %q; a refused field was applied anyway", got)
	}
}

// Refusing everything is the decision that needs explaining most: the same
// value will arrive again, and the next reviewer needs to know this one was
// considered rather than missed.
func TestRejectingEverythingNeedsANote(t *testing.T) {
	p := proposal(t, []domain.FieldProposal{
		{Field: domain.FieldBirthDate, CurrentValue: "1984-03-12", ProposedValue: "1984-12-03"},
	})

	if err := p.Resolve(nil, "him-1", "", moment(2026, time.September, 2)); err == nil {
		t.Fatal("a proposal was rejected in full with no reason recorded")
	}
	if p.Status != domain.ProposalOpen {
		t.Fatalf("a refused resolution changed the status to %q", p.Status)
	}
}

// Accepting a field nobody proposed would apply a value nobody reviewed.
func TestOnlyProposedFieldsCanBeAccepted(t *testing.T) {
	p := proposal(t, []domain.FieldProposal{
		{Field: domain.FieldFamilyName, CurrentValue: "Iyer", ProposedValue: "Rao"},
	})

	if err := p.Resolve([]domain.Field{domain.FieldSex}, "him-1", "",
		moment(2026, time.September, 2)); err == nil {
		t.Fatal("a field outside the proposal was accepted")
	}
}

// A decision taken twice is a decision taken against a record that has already
// moved.
func TestAResolvedProposalCannotBeResolvedAgain(t *testing.T) {
	p := proposal(t, []domain.FieldProposal{
		{Field: domain.FieldFamilyName, CurrentValue: "Iyer", ProposedValue: "Rao"},
	})

	if err := p.Resolve([]domain.Field{domain.FieldFamilyName}, "him-1", "",
		moment(2026, time.September, 2)); err != nil {
		t.Fatalf("Resolve: %v", err)
	}
	if err := p.Resolve(nil, "him-2", "changed my mind", moment(2026, time.September, 3)); err == nil {
		t.Fatal("a resolved proposal was resolved a second time")
	}
}

// A reviewer decides on the comparison they were shown. If the record moved
// underneath, accepting would overwrite a value nobody reviewed — the silent
// overwrite SRS-EMPI-012 exists to prevent, arriving through the mechanism
// meant to prevent it.
func TestAProposalIsStaleWhenTheRecordMoved(t *testing.T) {
	p := proposal(t, []domain.FieldProposal{
		{Field: domain.FieldFamilyName, CurrentValue: "Iyer", ProposedValue: "Rao"},
	})

	if p.Stale(3) {
		t.Fatal("a proposal against the version it was raised on reads as stale")
	}
	if !p.Stale(4) {
		t.Fatal("a proposal against a record that has since changed does not read as stale")
	}
}

// Proposing the value already on file is a no-op somebody has to close.
func TestAFieldCannotProposeTheValueItAlreadyHas(t *testing.T) {
	if _, err := domain.NewProposal("p-1", "patient-1", domain.OriginExternalSource,
		"ABDM", "feed", "", []domain.FieldProposal{{
			Field: domain.FieldFamilyName, CurrentValue: "Iyer", ProposedValue: "Iyer",
		}}, 1, moment(2026, time.September, 1)); err == nil {
		t.Fatal("a field proposed the value it already holds")
	}
}
