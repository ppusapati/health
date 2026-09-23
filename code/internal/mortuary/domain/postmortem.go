package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Postmortem (SRS-MORT-005).
//
// The workflow is configurable, which the requirement asks for and which here
// means the deployment says which authority must authorise which kind of
// examination rather than the code deciding. What the code does decide is
// that an examination nobody authorised cannot be recorded as performed, and
// that the authority's own reference travels with it — because the question
// asked afterwards is always "under whose authority", and a hospital that
// answers it with a name and no reference has not answered it.

// PostmortemKind is what sort of examination is being asked for
// (SRS-MORT-005).
type PostmortemKind string

const (
	// PostmortemClinical is asked for by the treating team, with the
	// family's consent, to find out what happened.
	PostmortemClinical PostmortemKind = "clinical"
	// PostmortemMedicoLegal is ordered by a coroner, a magistrate or the
	// police. The family's consent is not what authorises it.
	PostmortemMedicoLegal PostmortemKind = "medico_legal"
)

var knownPostmortemKind = map[PostmortemKind]bool{
	PostmortemClinical: true, PostmortemMedicoLegal: true,
}

// NeedsAuthority reports the kinds an external authority must authorise.
func (k PostmortemKind) NeedsAuthority() bool {
	return k == PostmortemMedicoLegal
}

// PostmortemState is where a request stands (SRS-MORT-005).
type PostmortemState string

const (
	PostmortemRequested  PostmortemState = "requested"
	PostmortemAuthorised PostmortemState = "authorised"
	PostmortemPerformed  PostmortemState = "performed"
	PostmortemReported   PostmortemState = "reported"
	// PostmortemDeclined is a request that will not happen: the coroner
	// decided against it, or the family withheld consent for a clinical
	// one. Kept rather than deleted, because "we asked and were refused"
	// is a different record from never having asked.
	PostmortemDeclined PostmortemState = "declined"
)

// Postmortem is one examination request and what became of it
// (SRS-MORT-005).
type Postmortem struct {
	ID       string
	TenantID string
	CaseID   string

	Kind   PostmortemKind
	Reason string

	State PostmortemState

	// Authority is the body that authorised it — a coroner's court, a
	// police station, the family for a clinical examination. Authority and
	// AuthorityReference travel together: a name with no reference is not
	// something anybody can check.
	Authority          string
	AuthorityReference string
	AuthorisedBy       string
	AuthorisedAt       time.Time

	PerformedBy string
	PerformedAt time.Time

	// ReportRef points at the report where reports live. A reference
	// rather than the text, because a postmortem report is a clinical
	// document with its own access rules and copying it here would put it
	// behind the mortuary's.
	ReportRef  string
	ReportedAt time.Time

	DeclineReason string

	RequestedAt time.Time
	RequestedBy string
	Version     int64
}

// NewPostmortemInput asks for an examination.
type NewPostmortemInput struct {
	Kind   PostmortemKind
	Reason string
}

// RequestPostmortem records the ask (SRS-MORT-005).
func RequestPostmortem(id, tenantID string, c Case,
	in NewPostmortemInput, by string, now time.Time) (Postmortem, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Postmortem{}, fmt.Errorf("%w: a request needs an id",
			ErrInvalidMortuary)
	case c.State == CaseReleased:
		// A body that has gone cannot be examined, and a request against
		// one is a request somebody will chase for a week.
		return Postmortem{}, fmt.Errorf(
			"%w: this case has been released", ErrInvalidMortuary)
	case !knownPostmortemKind[in.Kind]:
		return Postmortem{}, fmt.Errorf("%w: unknown postmortem kind %q",
			ErrInvalidMortuary, in.Kind)
	case strings.TrimSpace(in.Reason) == "":
		return Postmortem{}, fmt.Errorf("%w: a request says why",
			ErrInvalidMortuary)
	case strings.TrimSpace(by) == "":
		return Postmortem{}, fmt.Errorf("%w: a request names who made it",
			ErrInvalidMortuary)
	case in.Kind == PostmortemMedicoLegal && !c.MedicoLegal:
		// A medico-legal examination on a case nobody marked medico-legal
		// is one of two mistakes, and both are worth stopping: either the
		// case flag is missing, in which case the release rules are not
		// applying either, or the request is on the wrong case.
		return Postmortem{}, fmt.Errorf(
			"%w: this case is not marked medico-legal",
			ErrInvalidMortuary)
	}

	return Postmortem{
		ID: id, TenantID: tenantID, CaseID: c.ID,
		Kind: in.Kind, Reason: strings.TrimSpace(in.Reason),
		State:       PostmortemRequested,
		RequestedAt: now.UTC(), RequestedBy: by, Version: 1,
	}, nil
}

// Authorise records the authority that allowed it (SRS-MORT-005).
func (p *Postmortem) Authorise(authority, reference, by string,
	now time.Time) error {

	switch {
	case p.State != PostmortemRequested:
		return fmt.Errorf("%w: this request is %s", ErrInvalidMortuary,
			p.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an authorisation names who recorded it",
			ErrInvalidMortuary)
	case strings.TrimSpace(authority) == "":
		return fmt.Errorf("%w: an authorisation names the authority",
			ErrInvalidMortuary)
	case p.Kind.NeedsAuthority() &&
		strings.TrimSpace(reference) == "":
		// The coroner's own number. "Authorised by the coroner" with no
		// reference is a sentence, and the question asked at the inquest
		// is which order.
		return fmt.Errorf(
			"%w: a medico-legal authorisation names the authority's "+
				"reference", ErrInvalidMortuary)
	}

	p.State = PostmortemAuthorised
	p.Authority = strings.TrimSpace(authority)
	p.AuthorityReference = strings.TrimSpace(reference)
	p.AuthorisedBy, p.AuthorisedAt = by, now.UTC()
	return nil
}

// Perform records the examination happening (SRS-MORT-005).
func (p *Postmortem) Perform(pathologist string, now time.Time) error {
	switch {
	case p.State != PostmortemAuthorised:
		// An examination nobody authorised is the thing this workflow
		// exists to prevent. A body opened on a request alone is one
		// somebody will answer for.
		return fmt.Errorf(
			"%w: this request is %s; an examination follows an "+
				"authorisation", ErrInvalidMortuary, p.State)
	case strings.TrimSpace(pathologist) == "":
		return fmt.Errorf("%w: an examination names who performed it",
			ErrInvalidMortuary)
	}
	p.State = PostmortemPerformed
	p.PerformedBy = strings.TrimSpace(pathologist)
	p.PerformedAt = now.UTC()
	return nil
}

// Report attaches the report reference (SRS-MORT-005).
func (p *Postmortem) Report(reportRef string, now time.Time) error {
	switch {
	case p.State != PostmortemPerformed:
		return fmt.Errorf("%w: this request is %s", ErrInvalidMortuary,
			p.State)
	case strings.TrimSpace(reportRef) == "":
		return fmt.Errorf("%w: a report names where it is",
			ErrInvalidMortuary)
	}
	p.State = PostmortemReported
	p.ReportRef = strings.TrimSpace(reportRef)
	p.ReportedAt = now.UTC()
	return nil
}

// Decline records a request that will not happen (SRS-MORT-005).
func (p *Postmortem) Decline(reason, by string, now time.Time) error {
	switch {
	case p.State != PostmortemRequested &&
		p.State != PostmortemAuthorised:
		return fmt.Errorf("%w: this request is %s", ErrInvalidMortuary,
			p.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a decline names who recorded it",
			ErrInvalidMortuary)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: a decline says why", ErrInvalidMortuary)
	}
	p.State = PostmortemDeclined
	p.DeclineReason = strings.TrimSpace(reason)
	p.AuthorisedBy, p.AuthorisedAt = by, now.UTC()
	return nil
}

// Blocking reports the postmortems that stand between a case and its release
// (SRS-MORT-005, SRS-MORT-006).
//
// An examination that has been asked for and not yet done, or done and not
// yet reported on a medico-legal case, is a body that cannot go. A clinical
// examination that has been performed does not hold the body: the report can
// follow the funeral, and holding a family up for it is a cruelty with no
// purpose.
func Blocking(postmortems []Postmortem, caseID string) []Postmortem {
	out := make([]Postmortem, 0, len(postmortems))
	for _, p := range postmortems {
		if p.CaseID != caseID {
			continue
		}
		switch p.State {
		case PostmortemRequested, PostmortemAuthorised:
			out = append(out, p)
		case PostmortemPerformed:
			if p.Kind.NeedsAuthority() {
				out = append(out, p)
			}
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		return out[i].RequestedAt.Before(out[j].RequestedAt)
	})
	return out
}
