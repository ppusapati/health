package domain

import (
	"strings"
	"time"
)

// Pharmacy: verification (SRS-MED-006), substitution (SRS-MED-011) and
// formulary (SRS-MED-012).
//
// The thread running through all three is that the pharmacist's work is
// recorded *beside* the prescription rather than written into it. A
// verification that set a flag, a substitution that replaced the product and a
// formulary decision that edited the drug would each leave the record saying
// something the prescriber never wrote — and the question asked afterwards is
// always which of the two people made the choice.

// Verification is a pharmacist's check of a prescription (SRS-MED-006).
type Verification struct {
	By string
	At time.Time
	// Note carries what the pharmacist changed their mind about, or the
	// condition attached to the verification.
	Note string
}

// Done reports a prescription a pharmacist has verified.
func (v Verification) Done() bool {
	return strings.TrimSpace(v.By) != "" && !v.At.IsZero()
}

// VerificationPolicy is when a tenant requires a pharmacist's check
// (SRS-MED-006).
//
// "When policy requires" is the requirement's own wording, and the shape that
// matters is that it can be narrowed rather than only switched off: a hospital
// that cannot staff overnight pharmacy still wants every cytotoxic verified.
type VerificationPolicy struct {
	// Required turns the gate on for everything.
	Required bool
	// RequiredForClasses always require verification, whatever Required says.
	// Keyed by the class coding's Key.
	RequiredForClasses map[string]bool
}

// DefaultVerificationPolicy requires verification.
//
// On by default, because the failure modes point opposite ways: a hospital that
// has not thought about pharmacy verification is one where nobody is checking
// prescriptions, and the cost of the default being wrong is a delay somebody
// notices immediately.
func DefaultVerificationPolicy() VerificationPolicy {
	return VerificationPolicy{Required: true}
}

// RequiresVerification reports whether this prescription needs a pharmacist.
func (p VerificationPolicy) RequiresVerification(profile MedicationProfile) bool {
	if p.Required {
		return true
	}
	for _, class := range profile.Classes {
		if p.RequiredForClasses[class.Key()] {
			return true
		}
	}
	return false
}

// Verify records a pharmacist's check (SRS-MED-006).
//
// The pharmacist may not be the prescriber. Verification is a second person
// reading the prescription, and a self-verification is the control absent with
// a record saying it happened — the same reasoning that stops a nurse
// acknowledging their own handover.
func (p *Prescription) Verify(pharmacistID, note string, now time.Time) error {
	if strings.TrimSpace(pharmacistID) == "" {
		return invalidf("verification needs the pharmacist")
	}
	if strings.EqualFold(strings.TrimSpace(pharmacistID), p.PrescriberID) {
		return notAllowedf("a prescription cannot be verified by the person who wrote it")
	}
	if p.Status == TherapyDraft {
		return notAllowedf("a draft prescription has not been written yet")
	}
	if p.Status.Final() {
		return notAllowedf("this prescription is already %s", p.Status)
	}
	if p.Verification.Done() {
		// Idempotent: a retried verification must not move the timestamp, which
		// is evidence about when the check happened.
		return nil
	}

	p.Verification = Verification{
		By: strings.TrimSpace(pharmacistID), At: now.UTC(),
		Note: strings.TrimSpace(note),
	}
	p.UpdatedAt = now.UTC()
	p.Version++
	return nil
}

// SubstitutionKind is what sort of swap was made (SRS-MED-011).
type SubstitutionKind string

const (
	// SubstitutionGeneric is the same molecule under a different label.
	SubstitutionGeneric SubstitutionKind = "generic"
	// SubstitutionTherapeutic is a different molecule doing the same job, which
	// is a clinical decision rather than a stock one and is why the
	// authorisation is recorded separately.
	SubstitutionTherapeutic SubstitutionKind = "therapeutic"
	// SubstitutionFormulary is a swap to the stocked equivalent.
	SubstitutionFormulary SubstitutionKind = "formulary"
	// SubstitutionStock is a swap because the prescribed product is
	// unavailable.
	SubstitutionStock SubstitutionKind = "stock"
)

var knownSubstitutionKinds = map[SubstitutionKind]bool{
	SubstitutionGeneric: true, SubstitutionTherapeutic: true,
	SubstitutionFormulary: true, SubstitutionStock: true,
}

// SubstitutionStatus is where a substitution stands.
type SubstitutionStatus string

const (
	// SubstitutionProposed is the pharmacist's suggestion, not yet acted on.
	// SRS-MED-011 names the proposal and the dispensed product separately, and
	// the gap between them is where a therapeutic substitution waits for the
	// prescriber.
	SubstitutionProposed SubstitutionStatus = "proposed"
	SubstitutionAccepted SubstitutionStatus = "accepted"
	SubstitutionRejected SubstitutionStatus = "rejected"
	// SubstitutionDispensed is the product that actually went to the ward.
	SubstitutionDispensed SubstitutionStatus = "dispensed"
)

var knownSubstitutionStatuses = map[SubstitutionStatus]bool{
	SubstitutionProposed: true, SubstitutionAccepted: true,
	SubstitutionRejected: true, SubstitutionDispensed: true,
}

// Substitution is a dispensed product that differs from the prescribed one
// (SRS-MED-011).
//
// A record of its own rather than an edit to the prescription. The requirement
// says "separately from prescribed product" and the reason is that the
// prescription is evidence of what a named clinician decided: a substitution
// written over the top would leave the chart saying the prescriber chose a drug
// they never saw.
type Substitution struct {
	ID             string
	TenantID       string
	PrescriptionID string
	// Prescribed is copied here so the record stands alone. A reader of the
	// substitution should not have to fetch the prescription to know what was
	// swapped — and the prescription may itself have been superseded.
	Prescribed Coding
	Dispensed  Coding
	Kind       SubstitutionKind
	Status     SubstitutionStatus
	// Reason is mandatory: "out of stock" and "cheaper" are different facts,
	// and only one of them is a clinical governance question.
	Reason string
	// ProposedBy is the pharmacist. AuthorizedBy is whoever agreed, which for a
	// therapeutic substitution must be a prescriber.
	ProposedBy   string
	ProposedAt   time.Time
	AuthorizedBy string
	AuthorizedAt time.Time
	DispensedAt  time.Time
}

// NewSubstitution proposes a swap (SRS-MED-011).
func NewSubstitution(id, tenantID, prescriptionID string, prescribed, dispensed Coding,
	kind SubstitutionKind, reason, proposedBy string, now time.Time) (
	*Substitution, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return nil, invalidf("a substitution needs an identifier")
	case strings.TrimSpace(prescriptionID) == "":
		return nil, invalidf("a substitution needs a prescription")
	case !knownSubstitutionKinds[kind]:
		return nil, invalidf("unknown substitution kind %q", kind)
	case strings.TrimSpace(reason) == "":
		return nil, invalidf("a substitution needs a reason")
	case strings.TrimSpace(proposedBy) == "":
		return nil, invalidf("a substitution needs the pharmacist proposing it")
	}
	if err := prescribed.Validate(); err != nil {
		return nil, err
	}
	if err := dispensed.Validate(); err != nil {
		return nil, err
	}
	if prescribed.Key() == dispensed.Key() {
		return nil, invalidf("a substitution must dispense something different")
	}

	return &Substitution{
		ID: id, TenantID: tenantID, PrescriptionID: prescriptionID,
		Prescribed: prescribed, Dispensed: dispensed,
		Kind: kind, Status: SubstitutionProposed,
		Reason:     strings.TrimSpace(reason),
		ProposedBy: strings.TrimSpace(proposedBy), ProposedAt: now.UTC(),
	}, nil
}

// Authorize records who agreed to the swap (SRS-MED-011).
//
// A therapeutic substitution needs somebody other than the proposing
// pharmacist, because swapping one molecule for another is a prescribing
// decision and the requirement asks for the authorisation to be retained. A
// generic or stock swap is the pharmacist's own call and they may authorise it.
func (s *Substitution) Authorize(by string, now time.Time) error {
	if strings.TrimSpace(by) == "" {
		return invalidf("an authorisation needs the person giving it")
	}
	if s.Status != SubstitutionProposed {
		return notAllowedf("this substitution is already %s", s.Status)
	}
	if s.Kind == SubstitutionTherapeutic &&
		strings.EqualFold(strings.TrimSpace(by), s.ProposedBy) {
		return notAllowedf(
			"a therapeutic substitution must be authorised by somebody other than the pharmacist proposing it")
	}

	s.Status = SubstitutionAccepted
	s.AuthorizedBy = strings.TrimSpace(by)
	s.AuthorizedAt = now.UTC()
	return nil
}

// Reject records a refused proposal.
func (s *Substitution) Reject(by, reason string, now time.Time) error {
	if strings.TrimSpace(by) == "" {
		return invalidf("a rejection needs the person making it")
	}
	if s.Status != SubstitutionProposed {
		return notAllowedf("this substitution is already %s", s.Status)
	}
	s.Status = SubstitutionRejected
	s.AuthorizedBy = strings.TrimSpace(by)
	s.AuthorizedAt = now.UTC()
	if trimmed := strings.TrimSpace(reason); trimmed != "" {
		s.Reason = s.Reason + "; rejected: " + trimmed
	}
	return nil
}

// Dispense records the product that actually went out (SRS-MED-011).
func (s *Substitution) Dispense(now time.Time) error {
	if s.Status != SubstitutionAccepted {
		// Dispensing an unauthorised substitution is the case the requirement
		// exists to make visible, so it is refused rather than recorded with a
		// missing authorisation.
		return notAllowedf("a substitution is dispensed only once authorised; this one is %s",
			s.Status)
	}
	s.Status = SubstitutionDispensed
	s.DispensedAt = now.UTC()
	return nil
}

// FormularyStatus is where a medication stands with a formulary (SRS-MED-012).
type FormularyStatus string

const (
	FormularyIncluded FormularyStatus = "formulary"
	// FormularyRestricted is stocked but conditional — a named specialty, an
	// indication, an approval.
	FormularyRestricted FormularyStatus = "restricted"
	// FormularyNonFormulary is not stocked. Never a refusal: SRS-MED-012 asks
	// for the "policy action/approval path" to be shown, which is a different
	// thing from blocking, and a formulary that blocked would be one clinicians
	// route around by prescribing on paper.
	FormularyNonFormulary FormularyStatus = "non_formulary"
	// FormularyUnknown is a medication nobody has classified. Distinct from
	// non-formulary, because "we have decided not to stock this" and "nobody
	// has looked" are different answers and only one of them is a decision.
	FormularyUnknown FormularyStatus = "unknown"
)

var knownFormularyStatuses = map[FormularyStatus]bool{
	FormularyIncluded: true, FormularyRestricted: true,
	FormularyNonFormulary: true, FormularyUnknown: true,
}

// FormularyScopeKind is what a formulary entry is scoped to (SRS-MED-012).
type FormularyScopeKind string

const (
	FormularyScopeTenant     FormularyScopeKind = "tenant"
	FormularyScopeFacility   FormularyScopeKind = "facility"
	FormularyScopeDepartment FormularyScopeKind = "department"
	FormularyScopePayer      FormularyScopeKind = "payer"
)

var knownFormularyScopes = map[FormularyScopeKind]bool{
	FormularyScopeTenant: true, FormularyScopeFacility: true,
	FormularyScopeDepartment: true, FormularyScopePayer: true,
}

// specificity orders the scopes from broadest to narrowest. The narrowest
// matching entry wins: a department that has negotiated its own position on a
// drug has done so precisely because the hospital-wide answer is wrong for it.
var formularyScopeSpecificity = map[FormularyScopeKind]int{
	FormularyScopeTenant: 0, FormularyScopeFacility: 1,
	FormularyScopeDepartment: 2, FormularyScopePayer: 3,
}

// FormularyEntry is one medication's position in one scope (SRS-MED-012).
type FormularyEntry struct {
	TenantID   string
	Medication Coding
	Scope      FormularyScopeKind
	// ScopeID is the facility, department or payer. Empty for tenant scope.
	ScopeID string
	Status  FormularyStatus
	// Restriction says what the condition is, for a restricted medication.
	Restriction string
	// ApprovalPath is what SRS-MED-012's acceptance asks for by name: where the
	// clinician goes to get this approved. A non-formulary warning with no path
	// is a dead end, and the prescriber's next move is a phone call to find out
	// something the system already knew.
	ApprovalPath string
	UpdatedBy    string
	UpdatedAt    time.Time
}

// Validate rejects a formulary entry that could not be applied or shown.
func (e FormularyEntry) Validate() error {
	if err := e.Medication.Validate(); err != nil {
		return err
	}
	switch {
	case !knownFormularyScopes[e.Scope]:
		return invalidf("unknown formulary scope %q", e.Scope)
	case !knownFormularyStatuses[e.Status]:
		return invalidf("unknown formulary status %q", e.Status)
	case e.Scope != FormularyScopeTenant && strings.TrimSpace(e.ScopeID) == "":
		return invalidf("a %s formulary entry needs the %s it applies to", e.Scope, e.Scope)
	case e.Status == FormularyRestricted && strings.TrimSpace(e.Restriction) == "":
		return invalidf("a restricted medication must say what the restriction is")
	case e.Status == FormularyNonFormulary && strings.TrimSpace(e.ApprovalPath) == "":
		// A non-formulary entry with no approval path is the dead end the
		// acceptance criterion exists to prevent.
		return invalidf("a non-formulary medication must say how to get it approved")
	}
	return nil
}

// FormularyDecision is where a medication stood when it was prescribed.
type FormularyDecision struct {
	Status       FormularyStatus
	Scope        FormularyScopeKind
	ScopeID      string
	Restriction  string
	ApprovalPath string
}

// NeedsApproval reports a prescription the formulary asks somebody to approve.
func (d FormularyDecision) NeedsApproval() bool {
	return d.Status == FormularyNonFormulary || d.Status == FormularyRestricted
}

// FormularyQuery is the scope a prescription is being checked in.
type FormularyQuery struct {
	FacilityID   string
	DepartmentID string
	PayerID      string
}

// CheckFormulary finds the narrowest entry that applies (SRS-MED-012).
//
// Narrowest wins, and a scope the query does not name is skipped entirely: a
// self-paying patient is not bound by an insurer's list, and applying one
// because it happened to be the only entry would refuse a drug on grounds that
// do not apply to them.
func CheckFormulary(entries []FormularyEntry, medication Coding,
	profile MedicationProfile, q FormularyQuery) FormularyDecision {

	best := FormularyDecision{Status: FormularyUnknown}
	bestRank := -1

	for _, e := range entries {
		if !matchesMedication(e.Medication, medication, profile) {
			continue
		}
		switch e.Scope {
		case FormularyScopeFacility:
			if q.FacilityID == "" || e.ScopeID != q.FacilityID {
				continue
			}
		case FormularyScopeDepartment:
			if q.DepartmentID == "" || e.ScopeID != q.DepartmentID {
				continue
			}
		case FormularyScopePayer:
			if q.PayerID == "" || e.ScopeID != q.PayerID {
				continue
			}
		}

		if rank := formularyScopeSpecificity[e.Scope]; rank > bestRank {
			bestRank = rank
			best = FormularyDecision{
				Status: e.Status, Scope: e.Scope, ScopeID: e.ScopeID,
				Restriction: e.Restriction, ApprovalPath: e.ApprovalPath,
			}
		}
	}
	return best
}

func matchesMedication(entry, medication Coding, profile MedicationProfile) bool {
	if entry.Key() == medication.Key() {
		return true
	}
	return profileHas(profile, entry)
}
