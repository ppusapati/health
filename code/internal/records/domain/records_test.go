package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/records/domain"
)

var (
	at        = time.Date(2026, 9, 19, 10, 0, 0, 0, time.UTC)
	discharge = time.Date(2026, 9, 15, 12, 0, 0, 0, time.UTC)
)

func refused(t *testing.T, err error, contains string) {
	t.Helper()
	if err == nil {
		t.Fatalf("want a refusal mentioning %q, got none", contains)
	}
	if !errors.Is(err, domain.ErrInvalidRecord) {
		t.Fatalf("want ErrInvalidRecord, got %v", err)
	}
	if !strings.Contains(err.Error(), contains) {
		t.Fatalf("want a refusal mentioning %q, got %v", contains, err)
	}
}

func inpatientChecklist(t *testing.T,
	mutate func(*domain.NewChecklistInput)) domain.ChartChecklist {

	t.Helper()
	in := domain.NewChecklistInput{
		Code: "INPATIENT", Name: "Inpatient chart", Revision: 1,
		EncounterClass: "inpatient",
		Items: []domain.ChecklistItem{
			{Kind: "discharge_summary", Label: "Discharge summary",
				Requirement: domain.RequirementSigned,
				DueWithin:   24 * time.Hour},
			{Kind: "operation_note", Label: "Operation note",
				Requirement:   domain.RequirementConditional,
				ConditionCode: "had_operation"},
			{Kind: "consent_form", Label: "Consent form",
				Requirement: domain.RequirementPresent,
				DueWithin:   7 * 24 * time.Hour},
		},
	}
	if mutate != nil {
		mutate(&in)
	}
	checklist, err := domain.NewChecklist("cl-1", "t1", in, "mrd-author", at)
	if err != nil {
		t.Fatalf("NewChecklist: %v", err)
	}
	return checklist
}

// SRS-MRD-001. A checklist that finds every chart complete is refused, and
// its author cannot approve it.
func TestAChecklistSaysSomethingAndIsApprovedBySomebodyElse(t *testing.T) {
	_, err := domain.NewChecklist("cl-x", "t1", domain.NewChecklistInput{
		Code: "EMPTY", Revision: 1, EncounterClass: "inpatient",
	}, "mrd-author", at)
	refused(t, err, "finds every chart complete")

	_, err = domain.NewChecklist("cl-x", "t1", domain.NewChecklistInput{
		Code: "DUP", Revision: 1, EncounterClass: "inpatient",
		Items: []domain.ChecklistItem{
			{Kind: "discharge_summary", Requirement: domain.RequirementSigned},
			{Kind: "discharge_summary", Requirement: domain.RequirementPresent},
		},
	}, "mrd-author", at)
	refused(t, err, "appears twice")

	_, err = domain.NewChecklist("cl-x", "t1", domain.NewChecklistInput{
		Code: "COND", Revision: 1, EncounterClass: "inpatient",
		Items: []domain.ChecklistItem{
			{Kind: "operation_note",
				Requirement: domain.RequirementConditional},
		},
	}, "mrd-author", at)
	refused(t, err, "names the condition")

	checklist := inpatientChecklist(t, nil)
	err = checklist.Approve("mrd-author", at, at)
	refused(t, err, "author of a checklist cannot approve it")

	if err := checklist.Approve("mrd-lead", at, at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if !checklist.Live(at.Add(time.Hour)) {
		t.Fatal("an approved checklist is not in force")
	}
}

// SRS-MRD-001. The most specific checklist in force wins, and an encounter
// class nobody wrote one for is judged against nothing.
func TestTheMostSpecificChecklistInForceApplies(t *testing.T) {
	base := inpatientChecklist(t, nil)
	if err := base.Approve("mrd-lead", at.AddDate(0, -6, 0), at); err != nil {
		t.Fatalf("Approve: %v", err)
	}

	// Effective earlier than the baseline, so recency cannot be what picks
	// it: only the specialty can.
	obstetric := inpatientChecklist(t, func(in *domain.NewChecklistInput) {
		in.Code, in.Specialty = "OBSTETRIC", "obstetrics"
	})
	if err := obstetric.Approve("mrd-lead", at.AddDate(-1, 0, 0),
		at); err != nil {
		t.Fatalf("Approve: %v", err)
	}

	checklists := []domain.ChartChecklist{base, obstetric}

	got, ok := domain.ChecklistFor(checklists, "inpatient", "obstetrics", at)
	if !ok || got.Code != "OBSTETRIC" {
		t.Fatalf("checklist = %q, want the specialty's", got.Code)
	}
	got, ok = domain.ChecklistFor(checklists, "inpatient", "surgery", at)
	if !ok || got.Code != "INPATIENT" {
		t.Fatalf("checklist = %q, want the class baseline", got.Code)
	}
	// A class nobody has written a checklist for produces no deficiencies
	// rather than being judged against somebody else's list.
	if _, ok := domain.ChecklistFor(checklists, "day_case", "", at); ok {
		t.Fatal("a day case was judged against an inpatient checklist")
	}
	// Before either took effect, neither applies.
	if _, ok := domain.ChecklistFor(checklists, "inpatient", "obstetrics",
		at.AddDate(-2, 0, 0)); ok {
		t.Fatal("a checklist applied before it took effect")
	}
}

// SRS-MRD-001. Missing and unsigned are different gaps, a retracted note
// satisfies nothing, and a conditional item applies only when it applies.
func TestChartGapsDistinguishMissingFromUnsigned(t *testing.T) {
	checklist := inpatientChecklist(t, nil)

	documents := []domain.ChartDocument{
		{DocumentID: "doc-1", Kind: "discharge_summary",
			AuthoredBy: "reg-1", CreatedAt: discharge.Add(time.Hour)},
		{DocumentID: "doc-0", Kind: "discharge_summary",
			AuthoredBy: "reg-0", CreatedAt: discharge,
			Retracted: true},
		{DocumentID: "doc-2", Kind: "consent_form",
			AuthoredBy: "nurse-1", CreatedAt: discharge},
	}

	gaps := domain.ChartGaps(checklist, documents,
		map[string]bool{"had_operation": false}, discharge)

	if len(gaps) != 1 {
		t.Fatalf("gaps = %+v, want the unsigned discharge summary only", gaps)
	}
	gap := gaps[0]
	switch {
	case gap.Missing:
		t.Fatal("an unsigned document was reported as missing")
	case gap.DocumentID != "doc-1":
		t.Fatalf("gap names %q; the retracted note satisfies nothing and the "+
			"live one owns the deficiency", gap.DocumentID)
	case gap.OwnerID != "reg-1":
		t.Fatalf("owner = %q, want the author of the unsigned note",
			gap.OwnerID)
	case !gap.DueBy.Equal(discharge.Add(24 * time.Hour)):
		t.Fatalf("due %s, want 24 hours after discharge", gap.DueBy)
	}

	// The operation note appears once the encounter says there was one.
	gaps = domain.ChartGaps(checklist, documents,
		map[string]bool{"had_operation": true}, discharge)
	if len(gaps) != 2 {
		t.Fatalf("gaps = %+v, want the operation note too", gaps)
	}
	// Due immediately, so it sorts first.
	if gaps[0].Kind != "operation_note" || !gaps[0].Missing {
		t.Fatalf("gaps[0] = %+v, want the missing operation note first",
			gaps[0])
	}

	// A signed discharge summary closes the gap; the consent form was never
	// one, because it only has to be present.
	signed := append([]domain.ChartDocument{}, documents...)
	signed[0].Signed, signed[0].SignedBy = true, "consultant-1"
	if got := domain.ChartGaps(checklist, signed,
		map[string]bool{"had_operation": false}, discharge); len(got) != 0 {
		t.Fatalf("gaps = %+v, want none", got)
	}
}

func openDeficiency(t *testing.T,
	mutate func(*domain.NewDeficiencyInput)) domain.Deficiency {

	t.Helper()
	in := domain.NewDeficiencyInput{
		PatientID: "p1", EncounterID: "enc-1", FacilityID: "f1",
		Kind: domain.DeficiencyUnsigned, DocumentKind: "discharge_summary",
		Label: "Discharge summary", DocumentID: "doc-1",
		OwnerID: "reg-1", ChecklistCode: "INPATIENT", ChecklistRevision: 1,
		DueBy: discharge.Add(24 * time.Hour),
	}
	if mutate != nil {
		mutate(&in)
	}
	deficiency, err := domain.RaiseDeficiency("def-1", "t1", in, "mrd-1",
		discharge.Add(2*time.Hour))
	if err != nil {
		t.Fatalf("RaiseDeficiency: %v", err)
	}
	return deficiency
}

// SRS-MRD-002. A deficiency belongs to a person and knows what it is about.
func TestADeficiencyNamesItsOwnerAndItsSubject(t *testing.T) {
	_, err := domain.RaiseDeficiency("def-x", "t1",
		domain.NewDeficiencyInput{
			EncounterID: "enc-1", Kind: domain.DeficiencyMissing,
			DocumentKind: "discharge_summary",
		}, "mrd-1", at)
	refused(t, err, "names the clinician who owes it")

	// A missing document has no document to name, and naming one would make
	// the two kinds indistinguishable in every report.
	_, err = domain.RaiseDeficiency("def-x", "t1",
		domain.NewDeficiencyInput{
			EncounterID: "enc-1", Kind: domain.DeficiencyMissing,
			DocumentKind: "discharge_summary", DocumentID: "doc-1",
			OwnerID: "reg-1",
		}, "mrd-1", at)
	refused(t, err, "no document to name")

	_, err = domain.RaiseDeficiency("def-x", "t1",
		domain.NewDeficiencyInput{
			EncounterID: "enc-1", Kind: domain.DeficiencyUnsigned,
			DocumentKind: "discharge_summary", OwnerID: "reg-1",
		}, "mrd-1", at)
	refused(t, err, "names the document")

	_, err = domain.RaiseDeficiency("def-x", "t1",
		domain.NewDeficiencyInput{
			EncounterID: "enc-1", Kind: domain.DeficiencyIncomplete,
			DocumentKind: "discharge_summary", DocumentID: "doc-1",
			OwnerID: "reg-1",
		}, "mrd-1", at)
	refused(t, err, "what is inadequate")
}

// SRS-MRD-008. A deficiency is answered by new clinical content, never by
// editing what was signed.
func TestADeficiencyIsResolvedWithoutAlteringSignedHistory(t *testing.T) {
	inadequate := openDeficiency(t, func(in *domain.NewDeficiencyInput) {
		in.Kind = domain.DeficiencyIncomplete
		in.Detail = "no medication list on discharge"
	})

	err := inadequate.Resolve("", "reg-1", at)
	refused(t, err, "name the document that answered")

	// Pointing back at the signed document is the edit-in-place this
	// requirement exists to prevent: the answer is an addendum, which has its
	// own identifier.
	err = inadequate.Resolve("doc-1", "reg-1", at)
	refused(t, err, "addendum or an amendment")

	if err := inadequate.Resolve("doc-1-addendum", "reg-1", at); err != nil {
		t.Fatalf("Resolve: %v", err)
	}
	if inadequate.State != domain.DeficiencyResolved ||
		inadequate.ResolvedByDocumentID != "doc-1-addendum" {
		t.Fatalf("resolution not recorded: %+v", inadequate)
	}

	// An unsigned note is answered by the signature on that same document,
	// which is not an edit of signed history — there was none.
	unsigned := openDeficiency(t, nil)
	if err := unsigned.Resolve("doc-1", "consultant-1", at); err != nil {
		t.Fatalf("Resolve: %v", err)
	}
}

// SRS-MRD-002. A waiver is not a completion, and a reassignment does not
// restart the clock.
func TestAWaiverIsNotACompletionAndAReassignmentKeepsTheAge(t *testing.T) {
	deficiency := openDeficiency(t, nil)

	err := deficiency.Reassign("consultant-1", "", "mrd-1", at)
	refused(t, err, "why this deficiency is being reassigned")
	err = deficiency.Reassign("reg-1", "same person", "mrd-1", at)
	refused(t, err, "already the owner")

	before := deficiency.AgeDays(at)
	if err := deficiency.Reassign("consultant-1",
		"the registrar has rotated", "mrd-1", at); err != nil {
		t.Fatalf("Reassign: %v", err)
	}
	if deficiency.AgeDays(at) != before {
		t.Fatalf("age %d -> %d: a reassignment reset the clock",
			before, deficiency.AgeDays(at))
	}
	if deficiency.OwnerID != "consultant-1" {
		t.Fatalf("owner = %q", deficiency.OwnerID)
	}

	waived := openDeficiency(t, nil)
	waived.EncounterID = "enc-2"
	err = waived.Waive("", "mrd-1", at)
	refused(t, err, "why this deficiency will not be chased")
	if err := waived.Waive("the clinician left in 2024", "mrd-1",
		at); err != nil {
		t.Fatalf("Waive: %v", err)
	}

	summary := domain.SummariseCompletion(
		[]string{"enc-1", "enc-2", "enc-3"},
		[]domain.Deficiency{deficiency, waived}, at)
	switch {
	case summary.Complete != 1:
		t.Fatalf("complete = %d, want only the encounter with nothing on it",
			summary.Complete)
	case summary.Incompletable != 1:
		t.Fatalf("incompletable = %d, want the waived encounter",
			summary.Incompletable)
	case summary.Waived != 1 || summary.Open != 1:
		t.Fatalf("summary = %+v", summary)
	case summary.CompletePermille != 333:
		t.Fatalf("completion = %d permille, want one in three",
			summary.CompletePermille)
	}

	// A period with no encounters has no completion rate.
	if got := domain.SummariseCompletion(nil, nil, at); !got.Unanswerable {
		t.Fatalf("summary = %+v, want unanswerable", got)
	}
}

// SRS-MRD-002. Aging bands and an escalation that does not page the same
// consultant every night.
func TestDeficienciesAgeAndEscalateOnce(t *testing.T) {
	old := openDeficiency(t, nil)
	old.RaisedAt = at.AddDate(0, 0, -40)
	old.DueBy = at.AddDate(0, 0, -35)

	recent := openDeficiency(t, nil)
	recent.RaisedAt = at.AddDate(0, 0, -3)
	recent.DueBy = at.AddDate(0, 0, 4)

	resolved := openDeficiency(t, nil)
	resolved.RaisedAt = at.AddDate(0, 0, -50)
	if err := resolved.Resolve("doc-9", "reg-1", at); err != nil {
		t.Fatalf("Resolve: %v", err)
	}

	bands := domain.AgingReport([]domain.Deficiency{old, recent, resolved},
		[]domain.AgeBucket{
			{From: 0, To: 7, Label: "0-7 days"},
			{From: 7, To: 30, Label: "7-30 days"},
			{From: 30, Label: "30+ days"},
		}, at)

	if bands[0].Count != 1 || bands[2].Count != 1 {
		t.Fatalf("bands = %+v", bands)
	}
	if bands[1].Count != 0 {
		t.Fatalf("the resolved deficiency is on a worklist: %+v", bands)
	}
	if bands[2].Overdue != 1 || bands[0].Overdue != 0 {
		t.Fatalf("overdue counts = %+v", bands)
	}

	// Overdue by three days, which is inside a seven-day grace period: a
	// consultant is not paged the moment a deadline passes.
	justLate := openDeficiency(t, nil)
	justLate.RaisedAt = at.AddDate(0, 0, -10)
	justLate.DueBy = at.AddDate(0, 0, -3)

	candidates := domain.EscalationCandidates(
		[]domain.Deficiency{old, recent, justLate}, 7*24*time.Hour, at)
	if len(candidates) != 1 || candidates[0].DueBy != old.DueBy {
		t.Fatalf("candidates = %+v, want only the one past its grace period",
			candidates)
	}

	old.MarkEscalated(at)
	if got := domain.EscalationCandidates([]domain.Deficiency{old, recent},
		7*24*time.Hour, at); len(got) != 0 {
		t.Fatalf("candidates = %+v, want none: it has been escalated", got)
	}
}

func icdCode(code string, role domain.CodeRole,
	poa domain.PresentOnAdmission) domain.AssignedCode {

	return domain.AssignedCode{
		System: "icd-10", Version: "2026", Code: code, Display: code,
		Role: role, POA: poa, SourceDocumentID: "doc-1",
	}
}

// SRS-MRD-003. What makes a coded episode groupable, and what a code has to
// say about itself.
func TestACodedEpisodeHasOnePrincipalDiagnosisAndKnowsItsEdition(t *testing.T) {
	episode, err := domain.StartCoding("ep-1", "t1", "p1", "enc-1", "f1",
		"coder-1", at)
	if err != nil {
		t.Fatalf("StartCoding: %v", err)
	}

	err = episode.AssignCodes(nil, "", "coder-1", at)
	refused(t, err, "at least one code")

	err = episode.AssignCodes([]domain.AssignedCode{
		{System: "icd-10", Code: "J18.9", Role: domain.CodePrincipalDiagnosis,
			POA: domain.POAYes},
	}, "", "coder-1", at)
	refused(t, err, "names no edition")

	err = episode.AssignCodes([]domain.AssignedCode{
		{Version: "2026", Code: "J18.9",
			Role: domain.CodePrincipalDiagnosis, POA: domain.POAYes},
	}, "", "coder-1", at)
	refused(t, err, "names no terminology")

	err = episode.AssignCodes([]domain.AssignedCode{
		icdCode("E11.9", domain.CodeSecondaryDiagnosis, domain.POAYes),
	}, "", "coder-1", at)
	refused(t, err, "one principal diagnosis")

	err = episode.AssignCodes([]domain.AssignedCode{
		icdCode("J18.9", domain.CodePrincipalDiagnosis, domain.POAYes),
		icdCode("E11.9", domain.CodePrincipalDiagnosis, domain.POAYes),
	}, "", "coder-1", at)
	refused(t, err, "2 principal diagnoses")

	// A diagnosis that does not say whether it was there on arrival would
	// bias every complication rate computed from this data.
	err = episode.AssignCodes([]domain.AssignedCode{
		icdCode("J18.9", domain.CodePrincipalDiagnosis, ""),
	}, "", "coder-1", at)
	refused(t, err, "present on admission")

	err = episode.AssignCodes([]domain.AssignedCode{
		icdCode("J18.9", domain.CodePrincipalDiagnosis, domain.POAYes),
		{System: "opcs-4", Version: "2026", Code: "E85.2",
			Role: domain.CodePrincipalProcedure, POA: domain.POAYes},
	}, "", "coder-1", at)
	refused(t, err, "no meaning for procedure")

	if err := episode.AssignCodes([]domain.AssignedCode{
		icdCode("J18.9", domain.CodePrincipalDiagnosis, domain.POAYes),
		icdCode("E11.9", domain.CodeSecondaryDiagnosis, domain.POANo),
	}, "", "coder-1", at); err != nil {
		t.Fatalf("AssignCodes: %v", err)
	}
	current, _ := episode.Current()
	if current.Revision != 1 || len(current.Codes) != 2 {
		t.Fatalf("revision = %+v", current)
	}
	if current.Codes[0].Role != domain.CodePrincipalDiagnosis {
		t.Fatal("the principal diagnosis does not sort first")
	}
}

// SRS-MRD-003. Coding is append-only and the second read is a second person.
func TestCodingKeepsItsHistoryAndNeedsASecondReader(t *testing.T) {
	episode, err := domain.StartCoding("ep-2", "t1", "p1", "enc-1", "f1",
		"coder-1", at)
	if err != nil {
		t.Fatalf("StartCoding: %v", err)
	}
	first := []domain.AssignedCode{
		icdCode("J18.9", domain.CodePrincipalDiagnosis, domain.POAYes),
		icdCode("E11.9", domain.CodeSecondaryDiagnosis, domain.POAYes),
	}
	if err := episode.AssignCodes(first, "", "coder-1", at); err != nil {
		t.Fatalf("AssignCodes: %v", err)
	}

	err = episode.Finalise("coder-1", at)
	refused(t, err, "cannot be the second read")

	if err := episode.Finalise("coder-2", at); err != nil {
		t.Fatalf("Finalise: %v", err)
	}
	if episode.State() != domain.CodingFinal {
		t.Fatalf("state = %s", episode.State())
	}

	// Re-coding a finalised episode changes what was reported and billed.
	second := []domain.AssignedCode{
		icdCode("A41.9", domain.CodePrincipalDiagnosis, domain.POANo),
		icdCode("E11.9", domain.CodeSecondaryDiagnosis, domain.POAYes),
	}
	err = episode.AssignCodes(second, "", "coder-3", at.AddDate(0, 1, 0))
	refused(t, err, "why a finalised episode is being re-coded")

	if err := episode.AssignCodes(second,
		"clinical audit: sepsis was the reason for admission", "coder-3",
		at.AddDate(0, 1, 0)); err != nil {
		t.Fatalf("AssignCodes: %v", err)
	}
	if len(episode.Revisions) != 2 {
		t.Fatalf("%d revisions: the first coding was overwritten",
			len(episode.Revisions))
	}
	if episode.Revisions[0].Codes[0].Code != "J18.9" {
		t.Fatalf("the first revision changed: %+v", episode.Revisions[0])
	}

	changes := domain.Diff(episode.Revisions[0], episode.Revisions[1])
	if len(changes) != 2 {
		t.Fatalf("changes = %+v, want the one added and the one removed",
			changes)
	}
	byCode := map[string]domain.CodingChange{}
	for _, change := range changes {
		byCode[change.Code] = change
	}
	if byCode["A41.9"].Was != "" ||
		byCode["A41.9"].Now != domain.CodePrincipalDiagnosis {
		t.Fatalf("A41.9 = %+v, want an addition", byCode["A41.9"])
	}
	if byCode["J18.9"].Now != "" {
		t.Fatalf("J18.9 = %+v, want a removal", byCode["J18.9"])
	}
}

// SRS-MRD-003. A query holds the episode until a clinician answers.
func TestAQueriedEpisodeCannotBeFinalised(t *testing.T) {
	episode, err := domain.StartCoding("ep-3", "t1", "p1", "enc-1", "f1",
		"coder-1", at)
	if err != nil {
		t.Fatalf("StartCoding: %v", err)
	}
	if err := episode.AssignCodes([]domain.AssignedCode{
		icdCode("J18.9", domain.CodePrincipalDiagnosis, domain.POAUndetermined),
	}, "", "coder-1", at); err != nil {
		t.Fatalf("AssignCodes: %v", err)
	}
	if err := episode.Query("coder-1", at); err != nil {
		t.Fatalf("Query: %v", err)
	}
	err = episode.Finalise("coder-2", at)
	refused(t, err, "coding query is outstanding")
}

func consentedRequest(t *testing.T,
	mutate func(*domain.NewReleaseInput)) domain.ReleaseRequest {

	t.Helper()
	in := domain.NewReleaseInput{
		Reference: "REL-1", PatientID: "p1",
		Purpose: "insurance claim",
		Authorisation: domain.Authorisation{
			Kind: domain.AuthorityPatientConsent, Reference: "CONSENT-77",
			SignedBy: "p1", SignedAt: at.AddDate(0, 0, -1),
			ExpiresAt: at.AddDate(0, 3, 0),
		},
		Recipient: domain.Recipient{
			Kind: domain.RecipientInsurer, Name: "Acme Health",
			Reference: "CLAIM-2026-4412", DeliveryMethod: "secure transfer",
		},
		Scope: domain.ReleaseScope{EncounterIDs: []string{"enc-1"}},
	}
	if mutate != nil {
		mutate(&in)
	}
	request, err := domain.RequestRelease("rel-1", "t1", in, "mrd-1", at)
	if err != nil {
		t.Fatalf("RequestRelease: %v", err)
	}
	return request
}

// SRS-MRD-004. All four of authority, purpose, scope and recipient, and a
// scope that says what it wants.
func TestAReleaseNeedsAuthorityPurposeScopeAndRecipient(t *testing.T) {
	_, err := domain.RequestRelease("rel-x", "t1", domain.NewReleaseInput{
		PatientID: "p1",
	}, "mrd-1", at)
	refused(t, err, "what the record is wanted for")

	_, err = domain.RequestRelease("rel-x", "t1", domain.NewReleaseInput{
		PatientID: "p1", Purpose: "claim",
		Authorisation: domain.Authorisation{
			Kind: domain.AuthorityPatientConsent,
		},
	}, "mrd-1", at)
	refused(t, err, "consent, order or statute")

	_, err = domain.RequestRelease("rel-x", "t1", domain.NewReleaseInput{
		PatientID: "p1", Purpose: "claim",
		Authorisation: domain.Authorisation{
			Kind: domain.AuthorityPatientConsent, Reference: "C-1",
		},
		Recipient: domain.Recipient{
			Kind: domain.RecipientInsurer, Name: "Acme Health",
		},
		Scope: domain.ReleaseScope{EncounterIDs: []string{"enc-1"}},
	}, "mrd-1", at)
	refused(t, err, "reference a later enquiry can use")

	// A scope with nothing in it is a request for everything ever recorded
	// about a person, and it has to be asked for rather than fallen into.
	_, err = domain.RequestRelease("rel-x", "t1", domain.NewReleaseInput{
		PatientID: "p1", Purpose: "claim",
		Authorisation: domain.Authorisation{
			Kind: domain.AuthorityPatientConsent, Reference: "C-1",
		},
		Recipient: domain.Recipient{
			Kind: domain.RecipientInsurer, Name: "Acme", Reference: "R-1",
		},
	}, "mrd-1", at)
	refused(t, err, "ask for the whole record explicitly")

	whole := consentedRequest(t, func(in *domain.NewReleaseInput) {
		in.Scope = domain.ReleaseScope{WholeRecord: true}
	})
	if !whole.Scope.Bounded() {
		t.Fatal("an explicit whole-record request is not bounded")
	}
}

// SRS-MRD-004. The four checks hold at approval and again at release, and a
// package cannot carry what was not approved.
func TestAReleasePackageCannotCarryWhatWasNotApproved(t *testing.T) {
	request := consentedRequest(t, nil)

	err := request.Approve("mrd-1", at)
	refused(t, err, "cannot approve it")

	// A consent that expired between the request and the approval is the
	// case a request-time check alone would miss.
	stale := consentedRequest(t, func(in *domain.NewReleaseInput) {
		in.Authorisation.ExpiresAt = at.AddDate(0, 0, 1)
	})
	err = stale.Approve("mrd-lead", at.AddDate(0, 0, 2))
	refused(t, err, "expired or is incomplete")

	if err := request.Approve("mrd-lead", at); err != nil {
		t.Fatalf("Approve: %v", err)
	}

	inScope := domain.ReleaseItem{
		DocumentID: "doc-1", EncounterID: "enc-1",
		Kind: "discharge_summary", RecordClass: "inpatient",
		OccurredAt: at.AddDate(0, -1, 0), Pages: 3,
	}
	outOfScope := domain.ReleaseItem{
		DocumentID: "doc-2", EncounterID: "enc-9",
		Kind: "discharge_summary", RecordClass: "inpatient",
		OccurredAt: at.AddDate(0, -2, 0), Pages: 2,
	}

	err = request.Assemble(nil, "", "mrd-1", at)
	refused(t, err, "nothing in it")

	err = request.Assemble([]domain.ReleaseItem{inScope, outOfScope},
		"sha256:abc", "mrd-1", at)
	refused(t, err, "outside the scope")

	err = request.Assemble([]domain.ReleaseItem{inScope, inScope},
		"sha256:abc", "mrd-1", at)
	refused(t, err, "in the package twice")

	if err := request.Assemble([]domain.ReleaseItem{inScope}, "sha256:abc",
		"mrd-1", at); err != nil {
		t.Fatalf("Assemble: %v", err)
	}
	if request.Package.Pages != 3 || len(request.Package.Items) != 1 {
		t.Fatalf("package = %+v", request.Package)
	}

	// The consent expired while the package sat in the out-tray.
	err = request.Release("mrd-1", at.AddDate(0, 4, 0))
	refused(t, err, "expired before it went")

	if err := request.Release("mrd-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Release: %v", err)
	}
	if request.State != domain.ReleaseReleased ||
		request.Package.ReleasedBy != "mrd-1" {
		t.Fatalf("release not recorded: %+v", request)
	}
}

// SRS-MRD-004. Restricted material is held back unless it was asked for.
func TestRestrictedMaterialIsHeldBackUnlessAskedFor(t *testing.T) {
	request := consentedRequest(t, nil)
	if err := request.Approve("mrd-lead", at); err != nil {
		t.Fatalf("Approve: %v", err)
	}

	restricted := domain.ReleaseItem{
		DocumentID: "doc-3", EncounterID: "enc-1",
		Kind: "psychotherapy_note", RecordClass: "inpatient",
		Restricted: true, Pages: 4,
	}
	err := request.Assemble([]domain.ReleaseItem{restricted}, "", "mrd-1", at)
	refused(t, err, "outside the scope")

	wanted := consentedRequest(t, func(in *domain.NewReleaseInput) {
		in.Scope.IncludeRestricted = true
	})
	if err := wanted.Approve("mrd-lead", at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if err := wanted.Assemble([]domain.ReleaseItem{restricted}, "",
		"mrd-1", at); err != nil {
		t.Fatalf("Assemble: %v", err)
	}
}

// SRS-MRD-010. A disclosure carries the five things a later enquiry needs.
func TestADisclosureNamesActorPurposeScopeAndRecipient(t *testing.T) {
	recipient := domain.Recipient{
		Kind: domain.RecipientInsurer, Name: "Acme Health",
		Reference: "CLAIM-2026-4412",
	}

	_, err := domain.RecordDisclosure("dis-1", "t1", "p1",
		domain.DisclosureExport, "", "", "claim", "one encounter",
		recipient, 1, 3, at)
	refused(t, err, "names who made it")

	_, err = domain.RecordDisclosure("dis-1", "t1", "p1",
		domain.DisclosureExport, "", "mrd-1", "claim", "one encounter",
		domain.Recipient{Kind: domain.RecipientInsurer, Name: "Acme"}, 1, 3,
		at)
	refused(t, err, "recipient reference")

	disclosure, err := domain.RecordDisclosure("dis-1", "t1", "p1",
		domain.DisclosureExport, "", "mrd-1", "insurance claim",
		"the admission of 3 March 2026", recipient, 1, 3, at)
	if err != nil {
		t.Fatalf("RecordDisclosure: %v", err)
	}
	if disclosure.RecipientReference != "CLAIM-2026-4412" ||
		disclosure.ActorID != "mrd-1" || disclosure.Purpose == "" ||
		disclosure.ScopeSummary == "" {
		t.Fatalf("disclosure = %+v", disclosure)
	}

	// The summary is read by a patient, so it reads as words.
	scope := domain.ReleaseScope{
		From: time.Date(2026, 3, 1, 0, 0, 0, 0, time.UTC),
		To:   time.Date(2026, 3, 31, 0, 0, 0, 0, time.UTC),
	}
	if got := scope.ScopeSummary(); !strings.Contains(got, "March 2026") {
		t.Fatalf("summary = %q", got)
	}
	if got := (domain.ReleaseScope{WholeRecord: true}).ScopeSummary(); got !=
		"the whole record" {
		t.Fatalf("summary = %q", got)
	}
}

func liveRetentionRule(t *testing.T,
	mutate func(*domain.NewRetentionRuleInput)) domain.RetentionRule {

	t.Helper()
	in := domain.NewRetentionRuleInput{
		Code: "INPATIENT-8Y", Name: "Inpatient episodes", Revision: 1,
		RecordClass: "inpatient", Jurisdiction: "IN",
		Anchor: domain.AnchorDischarge, RetainYears: 8,
		Disposition: domain.DispositionDestroy,
		Authority:   "Medical Council of India regulations",
	}
	if mutate != nil {
		mutate(&in)
	}
	rule, err := domain.NewRetentionRule("rr-"+in.Code, "t1", in,
		"mrd-author", at)
	if err != nil {
		t.Fatalf("NewRetentionRule: %v", err)
	}
	if err := rule.Approve("mrd-lead", at.AddDate(-1, 0, 0), at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	return rule
}

// SRS-MRD-009. A retention rule says whose law it follows and what it rests
// on.
func TestARetentionRuleNamesItsJurisdictionAndAuthority(t *testing.T) {
	_, err := domain.NewRetentionRule("rr-x", "t1",
		domain.NewRetentionRuleInput{
			Code: "X", Revision: 1, RecordClass: "inpatient",
			Anchor: domain.AnchorDischarge, RetainYears: 8,
			Disposition: domain.DispositionDestroy, Authority: "a statute",
		}, "mrd-author", at)
	refused(t, err, "jurisdiction whose law it follows")

	_, err = domain.NewRetentionRule("rr-x", "t1",
		domain.NewRetentionRuleInput{
			Code: "X", Revision: 1, RecordClass: "inpatient",
			Jurisdiction: "IN", Anchor: domain.AnchorDischarge,
			RetainYears: 8, Disposition: domain.DispositionDestroy,
		}, "mrd-author", at)
	refused(t, err, "statute or standard")

	// Zero years with a destroy disposition destroys on the anchor date.
	_, err = domain.NewRetentionRule("rr-x", "t1",
		domain.NewRetentionRuleInput{
			Code: "X", Revision: 1, RecordClass: "inpatient",
			Jurisdiction: "IN", Anchor: domain.AnchorDischarge,
			Disposition: domain.DispositionDestroy, Authority: "a statute",
		}, "mrd-author", at)
	refused(t, err, "how long the record is kept")

	draft, err := domain.NewRetentionRule("rr-draft", "t1",
		domain.NewRetentionRuleInput{
			Code: "DRAFT", Revision: 1, RecordClass: "inpatient",
			Jurisdiction: "IN", Anchor: domain.AnchorDischarge,
			RetainYears: 8, Disposition: domain.DispositionDestroy,
			Authority: "a statute",
		}, "mrd-author", at)
	if err != nil {
		t.Fatalf("NewRetentionRule: %v", err)
	}
	err = draft.Approve("mrd-author", at, at)
	refused(t, err, "author of a retention rule cannot approve it")

	rule := liveRetentionRule(t, nil)
	err = rule.Approve("mrd-lead", at, at)
	refused(t, err, "already approved")
}

// SRS-MRD-005, SRS-MRD-009. A held record is never eligible, and every record
// passed over says why.
func TestAHeldRecordIsNeverEligibleAndEveryPassOverSaysWhy(t *testing.T) {
	rules := []domain.RetentionRule{
		liveRetentionRule(t, nil),
		liveRetentionRule(t, func(in *domain.NewRetentionRuleInput) {
			in.Code, in.RecordClass = "REGISTER", "birth_register"
			in.Disposition = domain.DispositionPermanent
			in.RetainYears = 0
		}),
	}

	discharged := at.AddDate(-10, 0, 0)
	records := []domain.RetainedRecord{
		{RecordID: "r-due", RecordClass: "inpatient", Jurisdiction: "IN",
			AnchorDates: map[domain.RetentionAnchor]time.Time{
				domain.AnchorDischarge: discharged,
			}},
		{RecordID: "r-held", RecordClass: "inpatient", Jurisdiction: "IN",
			AnchorDates: map[domain.RetentionAnchor]time.Time{
				domain.AnchorDischarge: discharged,
			}},
		{RecordID: "r-young", RecordClass: "inpatient", Jurisdiction: "IN",
			AnchorDates: map[domain.RetentionAnchor]time.Time{
				domain.AnchorDischarge: at.AddDate(-2, 0, 0),
			}},
		{RecordID: "r-undated", RecordClass: "inpatient", Jurisdiction: "IN"},
		{RecordID: "r-norule", RecordClass: "imaging", Jurisdiction: "IN"},
		{RecordID: "r-permanent", RecordClass: "birth_register",
			Jurisdiction: "IN",
			AnchorDates: map[domain.RetentionAnchor]time.Time{
				domain.AnchorCreation: discharged,
			}},
		// Held and in a class with no rule: the hold is the reason reported,
		// so the two cannot mask each other.
		{RecordID: "r-held-norule", RecordClass: "imaging",
			Jurisdiction: "IN"},
	}

	held := func(id string) bool {
		return id == "r-held" || id == "r-held-norule"
	}

	candidates, passed := domain.EligibleForDisposition(records, rules, held,
		at)

	if len(candidates) != 1 || candidates[0].RecordID != "r-due" {
		t.Fatalf("candidates = %+v, want only the one that is due", candidates)
	}
	if candidates[0].RuleCode != "INPATIENT-8Y" ||
		candidates[0].Authority == "" {
		t.Fatalf("a candidate does not name the rule that allowed it: %+v",
			candidates[0])
	}

	reasons := map[string]string{}
	for _, one := range passed {
		reasons[one.RecordID] = one.Reason
	}
	want := map[string]string{
		"r-held":        domain.IneligibleHeld,
		"r-held-norule": domain.IneligibleHeld,
		"r-young":       domain.IneligibleNotDue,
		"r-undated":     domain.IneligibleNoAnchor,
		"r-norule":      domain.IneligibleNoRule,
		"r-permanent":   domain.IneligiblePermanent,
	}
	for id, reason := range want {
		if reasons[id] != reason {
			t.Fatalf("%s passed over as %q, want %q", id, reasons[id], reason)
		}
	}
}

// SRS-MRD-009. Destruction is approval controlled, by a second person, and
// checked again at execution.
func TestADispositionListIsApprovedBySomebodyElseAndRecheckedAtExecution(
	t *testing.T) {

	candidates := []domain.DispositionCandidate{
		{RecordID: "r-1", RecordClass: "inpatient", RuleCode: "INPATIENT-8Y",
			RuleRevision: 1, Authority: "MCI", Disposition: domain.DispositionDestroy,
			EligibleFrom: at.AddDate(0, -1, 0)},
		{RecordID: "r-2", RecordClass: "inpatient", RuleCode: "INPATIENT-8Y",
			RuleRevision: 1, Authority: "MCI", Disposition: domain.DispositionDestroy,
			EligibleFrom: at.AddDate(0, -2, 0)},
	}

	_, err := domain.PrepareDisposition("dl-x", "t1", "DL-1", "IN",
		domain.DispositionDestroy, append(candidates,
			domain.DispositionCandidate{
				RecordID: "r-3", RuleCode: "X",
				Disposition: domain.DispositionArchive,
			}), "mrd-1", at)
	refused(t, err, "is for archive, not destroy")

	_, err = domain.PrepareDisposition("dl-x", "t1", "DL-1", "IN",
		domain.DispositionDestroy, append(candidates, candidates[0]),
		"mrd-1", at)
	refused(t, err, "on the list twice")

	// A candidate that does not name the rule that made it eligible cannot
	// answer the first question anybody asks about a destruction.
	_, err = domain.PrepareDisposition("dl-x", "t1", "DL-1", "IN",
		domain.DispositionDestroy, []domain.DispositionCandidate{
			{RecordID: "r-9", Disposition: domain.DispositionDestroy},
		}, "mrd-1", at)
	refused(t, err, "does not name the rule")

	list, err := domain.PrepareDisposition("dl-1", "t1", "DL-1", "IN",
		domain.DispositionDestroy, candidates, "mrd-1", at)
	if err != nil {
		t.Fatalf("PrepareDisposition: %v", err)
	}

	err = list.Execute(nil, "", "mrd-1", at)
	refused(t, err, "has not been approved")

	err = list.ApproveDisposition("mrd-1", at)
	refused(t, err, "cannot approve it")

	if err := list.ApproveDisposition("mrd-lead", at); err != nil {
		t.Fatalf("ApproveDisposition: %v", err)
	}

	// A hold placed between approval and execution: the list was lawful when
	// it was approved and one of its records is now evidence.
	err = list.Execute(func(id string) bool { return id == "r-2" },
		"CERT-1", "mrd-1", at.AddDate(0, 0, 1))
	refused(t, err, "came under legal hold after it was approved")

	if err := list.Execute(func(string) bool { return false }, "CERT-1",
		"mrd-1", at.AddDate(0, 0, 1)); err != nil {
		t.Fatalf("Execute: %v", err)
	}
	if list.State != domain.DispositionExecuted ||
		list.Certificate != "CERT-1" {
		t.Fatalf("list = %+v", list)
	}
}

// SRS-MRD-006. A record goes out to one named custodian, and comes back.
func TestAPhysicalRecordGoesOutToOneNamedCustodian(t *testing.T) {
	record, err := domain.RegisterPhysicalRecord("pr-1", "t1",
		domain.NewPhysicalRecordInput{
			Reference: "MRN-4412/1", PatientID: "p1",
			RecordClass: "inpatient", Jurisdiction: "IN",
			HomeLocation: "library bay 4",
		}, "mrd-1", at)
	if err != nil {
		t.Fatalf("RegisterPhysicalRecord: %v", err)
	}
	if record.Volume != 1 || record.CurrentLocation != "library bay 4" {
		t.Fatalf("record = %+v", record)
	}

	err = record.CheckOut("", "ward A", "clinic review",
		at.AddDate(0, 0, 7), "mrd-1", at)
	refused(t, err, "named custodian")

	err = record.CheckOut("dr-1", "ward A", "", at.AddDate(0, 0, 7),
		"mrd-1", at)
	refused(t, err, "what the record is wanted for")

	err = record.CheckOut("dr-1", "ward A", "clinic review",
		at.AddDate(0, 0, -1), "mrd-1", at)
	refused(t, err, "due back before it goes out")

	if err := record.CheckOut("dr-1", "ward A", "clinic review",
		at.AddDate(0, 0, 7), "mrd-1", at); err != nil {
		t.Fatalf("CheckOut: %v", err)
	}

	// Two people each believing they have the notes is how a record goes
	// missing.
	err = record.CheckOut("dr-2", "clinic B", "second opinion",
		at.AddDate(0, 0, 7), "mrd-1", at)
	refused(t, err, "already with dr-1")

	if got := domain.Outstanding([]domain.PhysicalRecord{record}, true,
		at.AddDate(0, 0, 3)); len(got) != 0 {
		t.Fatalf("outstanding overdue = %+v, want none yet", got)
	}
	if got := domain.Outstanding([]domain.PhysicalRecord{record}, true,
		at.AddDate(0, 0, 10)); len(got) != 1 {
		t.Fatalf("outstanding overdue = %+v, want the one past its date", got)
	}

	if err := record.CheckIn("library bay 4", "mrd-1",
		at.AddDate(0, 0, 8)); err != nil {
		t.Fatalf("CheckIn: %v", err)
	}
	if record.Custodian != "" || record.State != domain.PhysicalFiled {
		t.Fatalf("record = %+v", record)
	}
}

// SRS-MRD-006, SRS-MRD-009. A destroyed record keeps its row and names the
// list that allowed it.
func TestADestroyedRecordNamesTheListThatAllowedIt(t *testing.T) {
	record, err := domain.RegisterPhysicalRecord("pr-2", "t1",
		domain.NewPhysicalRecordInput{
			Reference: "MRN-1/1", PatientID: "p1",
			HomeLocation: "library bay 1",
		}, "mrd-1", at)
	if err != nil {
		t.Fatalf("RegisterPhysicalRecord: %v", err)
	}

	err = record.MarkDestroyed("", "CERT-1", "mrd-1", at)
	refused(t, err, "names the approved disposition list")

	if err := record.MarkDestroyed("dl-1", "CERT-1", "mrd-1", at); err != nil {
		t.Fatalf("MarkDestroyed: %v", err)
	}
	if record.State != domain.PhysicalDestroyed {
		t.Fatalf("state = %s", record.State)
	}
	if !strings.Contains(record.CurrentLocation, "dl-1") {
		t.Fatalf("location = %q, want the list it was destroyed under",
			record.CurrentLocation)
	}

	// A record with somebody cannot be archived out from under them.
	out, err := domain.RegisterPhysicalRecord("pr-3", "t1",
		domain.NewPhysicalRecordInput{
			Reference: "MRN-2/1", PatientID: "p2",
			HomeLocation: "library bay 2",
		}, "mrd-1", at)
	if err != nil {
		t.Fatalf("RegisterPhysicalRecord: %v", err)
	}
	if err := out.CheckOut("dr-1", "ward A", "review", time.Time{},
		"mrd-1", at); err != nil {
		t.Fatalf("CheckOut: %v", err)
	}
	err = out.Archive("off-site", "mrd-1", at)
	refused(t, err, "with dr-1")
}

func deathForm(t *testing.T,
	mutate func(*domain.NewCertificateFormInput)) domain.CertificateForm {

	t.Helper()
	in := domain.NewCertificateFormInput{
		Code: "DEATH-IN", Name: "Medical certificate of cause of death",
		Revision: 1, Kind: domain.CertificateDeath, Jurisdiction: "IN",
		IssuerRole: "registered_medical_practitioner",
		Fields: []domain.CertificateField{
			{Code: "deceased_name", Label: "Name of deceased",
				Required: true, SourcePath: "patient.name"},
			{Code: "date_of_death", Label: "Date of death", Required: true,
				SourcePath: "encounter.death_recorded_at"},
			{Code: "cause_i_a", Label: "Immediate cause", Required: true,
				SourcePath: "document.cause_of_death"},
			{Code: "antecedent", Label: "Antecedent cause"},
		},
	}
	if mutate != nil {
		mutate(&in)
	}
	form, err := domain.NewCertificateForm("cf-1", "t1", in, "mrd-author", at)
	if err != nil {
		t.Fatalf("NewCertificateForm: %v", err)
	}
	if err := form.Approve("mrd-lead", at.AddDate(0, -1, 0), at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	return form
}

// SRS-MRD-007. A certificate carries source data, an issuer with the right
// standing, and a version.
func TestACertificateNamesItsSourcesAndItsIssuersStanding(t *testing.T) {
	form := deathForm(t, nil)
	values := map[string]string{
		"deceased_name": "Meera Iyer",
		"date_of_death": "2026-09-14",
		"cause_i_a":     "acute myocardial infarction",
	}
	sources := map[string]string{
		"deceased_name": "patient:p1",
		"date_of_death": "encounter:enc-1",
		"cause_i_a":     "document:doc-7",
	}
	practitioner := domain.Issuer{
		SubjectID: "dr-1", Name: "Dr Rao",
		Role: "registered_medical_practitioner",
	}

	// A hospital cannot make somebody eligible to sign a death certificate by
	// giving them a permission.
	_, err := domain.IssueCertificate("cert-x", "t1", form, "p1", "enc-1",
		values, sources,
		domain.Issuer{SubjectID: "mrd-1", Role: "records_officer"}, "", at)
	refused(t, err, "issued by a registered_medical_practitioner")

	missing := map[string]string{"deceased_name": "Meera Iyer"}
	_, err = domain.IssueCertificate("cert-x", "t1", form, "p1", "enc-1",
		missing, sources, practitioner, "", at)
	refused(t, err, "Date of death is required")

	// A field the form declares a source for, supplied with no source, is a
	// fact nobody can trace at an inquest.
	_, err = domain.IssueCertificate("cert-x", "t1", form, "p1", "enc-1",
		values, map[string]string{"deceased_name": "patient:p1"},
		practitioner, "", at)
	refused(t, err, "no source was named")

	// A value the form has no field for would be dropped silently.
	extra := map[string]string{}
	for k, v := range values {
		extra[k] = v
	}
	extra["favourite_colour"] = "blue"
	_, err = domain.IssueCertificate("cert-x", "t1", form, "p1", "enc-1",
		extra, sources, practitioner, "", at)
	refused(t, err, "has no field")

	certificate, err := domain.IssueCertificate("cert-1", "t1", form, "p1",
		"enc-1", values, sources, practitioner, "SERIAL-9", at)
	if err != nil {
		t.Fatalf("IssueCertificate: %v", err)
	}
	current, _ := certificate.Current()
	switch {
	case current.Version != 1:
		t.Fatalf("version = %d", current.Version)
	case current.SourceRefs["cause_i_a"] != "document:doc-7":
		t.Fatalf("source refs lost: %+v", current.SourceRefs)
	case certificate.FormRevision != 1:
		t.Fatalf("the form revision was not pinned: %+v", certificate)
	case current.IssuerID != "dr-1":
		t.Fatalf("issuer = %q", current.IssuerID)
	}
}

// SRS-MRD-007. A correction is a new version and the first one survives.
func TestACorrectedCertificateKeepsTheOneThatWasIssued(t *testing.T) {
	form := deathForm(t, nil)
	values := map[string]string{
		"deceased_name": "Meera Iyer",
		"date_of_death": "2026-09-14",
		"cause_i_a":     "acute myocardial infarction",
	}
	sources := map[string]string{
		"deceased_name": "patient:p1",
		"date_of_death": "encounter:enc-1",
		"cause_i_a":     "document:doc-7",
	}
	practitioner := domain.Issuer{
		SubjectID: "dr-1", Role: "registered_medical_practitioner",
	}

	certificate, err := domain.IssueCertificate("cert-2", "t1", form, "p1",
		"enc-1", values, sources, practitioner, "SERIAL-9", at)
	if err != nil {
		t.Fatalf("IssueCertificate: %v", err)
	}

	corrected := map[string]string{}
	for k, v := range values {
		corrected[k] = v
	}
	corrected["cause_i_a"] = "pulmonary embolism"

	err = certificate.Correct(form, corrected, sources, practitioner, "",
		"", at.AddDate(0, 0, 3))
	refused(t, err, "why the certificate is being corrected")

	if err := certificate.Correct(form, corrected, sources, practitioner,
		"post-mortem findings", "", at.AddDate(0, 0, 3)); err != nil {
		t.Fatalf("Correct: %v", err)
	}

	if len(certificate.Versions) != 2 {
		t.Fatalf("%d versions: the issued certificate was overwritten",
			len(certificate.Versions))
	}
	if certificate.Versions[0].Values["cause_i_a"] !=
		"acute myocardial infarction" {
		t.Fatalf("the first version changed: %+v", certificate.Versions[0])
	}
	current, _ := certificate.Current()
	if current.SerialNumber != "SERIAL-9" {
		t.Fatalf("serial = %q, want the original's", current.SerialNumber)
	}
	if current.Reason == "" {
		t.Fatal("the correction does not say why")
	}

	// Voiding keeps everything: a family and a registrar hold these.
	if err := certificate.Void("issued against the wrong patient", "mrd-lead",
		at.AddDate(0, 0, 5)); err != nil {
		t.Fatalf("Void: %v", err)
	}
	if len(certificate.Versions) != 2 ||
		certificate.State != domain.CertificateVoided {
		t.Fatalf("certificate = %+v", certificate)
	}
	err = certificate.Correct(form, corrected, sources, practitioner,
		"another go", "", at.AddDate(0, 0, 6))
	refused(t, err, "has been voided")
}

// SRS-MRD-007. An unapproved form issues nothing.
func TestAnUnapprovedFormIssuesNothing(t *testing.T) {
	form, err := domain.NewCertificateForm("cf-2", "t1",
		domain.NewCertificateFormInput{
			Code: "DRAFT", Revision: 1, Kind: domain.CertificateBirth,
			Jurisdiction: "IN", IssuerRole: "registered_medical_practitioner",
			Fields: []domain.CertificateField{
				{Code: "child_name", Required: true},
			},
		}, "mrd-author", at)
	if err != nil {
		t.Fatalf("NewCertificateForm: %v", err)
	}

	_, err = domain.NewCertificateForm("cf-x", "t1",
		domain.NewCertificateFormInput{
			Code: "NOROLE", Revision: 1, Kind: domain.CertificateBirth,
			Jurisdiction: "IN",
			Fields:       []domain.CertificateField{{Code: "child_name"}},
		}, "mrd-author", at)
	refused(t, err, "names the role that may issue it")

	_, err = domain.NewCertificateForm("cf-x", "t1",
		domain.NewCertificateFormInput{
			Code: "DUPFIELD", Revision: 1, Kind: domain.CertificateBirth,
			Jurisdiction: "IN", IssuerRole: "registered_medical_practitioner",
			Fields: []domain.CertificateField{
				{Code: "child_name"}, {Code: "Child_Name"},
			},
		}, "mrd-author", at)
	refused(t, err, "appears twice")

	_, err = domain.IssueCertificate("cert-3", "t1", form, "p1", "enc-1",
		map[string]string{"child_name": "Baby Iyer"}, nil,
		domain.Issuer{SubjectID: "dr-1",
			Role: "registered_medical_practitioner"}, "", at)
	refused(t, err, "not approved and in force")

	if _, ok := domain.FormFor([]domain.CertificateForm{form},
		domain.CertificateBirth, "IN", at); ok {
		t.Fatal("an unapproved form was picked as the one in force")
	}
}
