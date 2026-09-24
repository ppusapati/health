package domain

import (
	"sort"
	"strings"
	"time"
)

// Restraints and transfusion monitoring (SRS-NUR-013, SRS-NUR-014).
//
// Two workflows that have nothing clinically in common and one property in
// common: both are time-bound observations of something that is actively being
// done to a patient, where the record's job is to prove the observation
// happened on time rather than to describe it afterwards.
//
// SRS-NUR-013's acceptance is that an expired authorization triggers an alert.
// Note what it does not say: that the restraint ends. The patient is still
// restrained when the paperwork lapses, and a system that "removed" the
// restraint at expiry would produce a record showing a patient free while they
// were tied to a bed. So expiry raises an alarm and the restraint stays open
// until somebody discontinues it.

// RestraintKind is what is being used.
type RestraintKind string

const (
	RestraintPhysical  RestraintKind = "physical"
	RestraintChemical  RestraintKind = "chemical"
	RestraintSeclusion RestraintKind = "seclusion"
)

var knownRestraintKinds = map[RestraintKind]bool{
	RestraintPhysical: true, RestraintChemical: true, RestraintSeclusion: true,
}

// RestraintAuthorization is the clinician's order for a restraint.
//
// Time-bounded by construction: a restraint authorization with no expiry is
// the failure mode the requirement exists to prevent, so ExpiresAt is not
// optional and is validated against a maximum.
type RestraintAuthorization struct {
	AuthorizedBy string
	AuthorizedAt time.Time
	ExpiresAt    time.Time
	// Indication is the behaviour that justified it. Required, because
	// "agitated" is not an indication and a blank field is how a restraint
	// becomes routine.
	Indication string
}

// MaxRestraintAuthorization bounds a single authorization.
//
// Twenty-four hours. Jurisdictions differ and several are considerably
// shorter, so this is a ceiling the tenant can lower rather than a clinical
// rule — but a ceiling has to exist, because the alternative is an
// authorization written once on admission that never expires.
const MaxRestraintAuthorization = 24 * time.Hour

// Restraint is one episode of restraint (SRS-NUR-013).
type Restraint struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	Kind        RestraintKind
	// Description is what was applied, and where.
	Description string

	Authorization RestraintAuthorization
	// Renewals are subsequent authorizations. Appended rather than replacing
	// the first, because how many times a restraint has been renewed is the
	// number a review board asks for.
	Renewals []RestraintAuthorization

	StartedAt time.Time
	StartedBy string
	// MonitorEvery is how often the patient must be checked while restrained.
	MonitorEvery time.Duration
	Monitoring   []RestraintCheck

	DiscontinuedAt     time.Time
	DiscontinuedBy     string
	DiscontinuedReason string

	Version int64
}

// RestraintCheck is one observation of a restrained patient.
type RestraintCheck struct {
	ID         string
	ObservedAt time.Time
	ObservedBy string
	// Findings covers circulation, skin integrity, hydration, toileting and
	// behaviour — the checks that make a restraint survivable.
	Findings string
	// ContinuedReason is why the restraint was not removed at this check. A
	// check that records observations but never asks whether the restraint is
	// still needed is a check that keeps patients restrained.
	ContinuedReason string
}

// NewRestraintInput is what starting a restraint needs.
type NewRestraintInput struct {
	PatientID     string
	EncounterID   string
	Kind          RestraintKind
	Description   string
	Authorization RestraintAuthorization
	StartedAt     time.Time
	MonitorEvery  time.Duration
}

// NewRestraint records the start of a restraint episode.
func NewRestraint(id, tenantID string, in NewRestraintInput, startedBy string,
	now time.Time) (*Restraint, error) {

	if strings.TrimSpace(in.PatientID) == "" {
		return nil, invalidf("a restraint needs a patient")
	}
	if strings.TrimSpace(in.EncounterID) == "" {
		return nil, invalidf("a restraint needs an encounter")
	}
	if !knownRestraintKinds[in.Kind] {
		return nil, invalidf("unknown restraint kind %q", in.Kind)
	}
	if strings.TrimSpace(in.Description) == "" {
		return nil, invalidf("a restraint needs to say what was applied")
	}
	if strings.TrimSpace(startedBy) == "" {
		return nil, invalidf("a restraint must record who applied it")
	}
	if err := validateAuthorization(in.Authorization, now); err != nil {
		return nil, err
	}
	if in.MonitorEvery <= 0 {
		return nil, invalidf("a restraint must say how often the patient is checked")
	}
	if in.StartedAt.IsZero() {
		return nil, invalidf("a restraint needs the time it was applied")
	}
	started := in.StartedAt.UTC()
	if started.After(now.UTC()) {
		return nil, invalidf("a restraint cannot have been applied in the future")
	}

	return &Restraint{
		ID: id, TenantID: tenantID,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		Kind: in.Kind, Description: strings.TrimSpace(in.Description),
		Authorization: in.Authorization,
		StartedAt:     started, StartedBy: startedBy,
		MonitorEvery: in.MonitorEvery, Version: 1,
	}, nil
}

func validateAuthorization(a RestraintAuthorization, now time.Time) error {
	if strings.TrimSpace(a.AuthorizedBy) == "" {
		return invalidf("a restraint needs a named clinician's authorization")
	}
	if strings.TrimSpace(a.Indication) == "" {
		return invalidf("a restraint authorization needs an indication")
	}
	if a.AuthorizedAt.IsZero() {
		return invalidf("a restraint authorization needs the time it was given")
	}
	if a.ExpiresAt.IsZero() {
		return invalidf("a restraint authorization must expire")
	}
	if !a.ExpiresAt.After(a.AuthorizedAt) {
		return invalidf("a restraint authorization cannot expire before it was given")
	}
	if a.ExpiresAt.Sub(a.AuthorizedAt) > MaxRestraintAuthorization {
		return invalidf("a restraint authorization cannot run longer than %s",
			MaxRestraintAuthorization)
	}
	if a.AuthorizedAt.UTC().After(now.UTC()) {
		return invalidf("a restraint authorization cannot have been given in the future")
	}
	return nil
}

// Current returns the authorization in force.
func (r *Restraint) Current() RestraintAuthorization {
	if len(r.Renewals) == 0 {
		return r.Authorization
	}
	return r.Renewals[len(r.Renewals)-1]
}

// Renew extends a restraint with a fresh authorization (SRS-NUR-013).
func (r *Restraint) Renew(a RestraintAuthorization, now time.Time) error {
	if !r.Active() {
		return notAllowedf("this restraint has been discontinued")
	}
	if err := validateAuthorization(a, now); err != nil {
		return err
	}
	if !a.ExpiresAt.After(r.Current().ExpiresAt) {
		return invalidf("a renewal must extend the authorization")
	}
	r.Renewals = append(r.Renewals, a)
	r.Version++
	return nil
}

// Active reports whether the patient is still restrained.
//
// Note that an expired authorization does not make a restraint inactive. The
// patient is still restrained; what has lapsed is the permission, and that is
// an alert, not a state change.
func (r *Restraint) Active() bool { return r.DiscontinuedAt.IsZero() }

// AuthorizationExpired reports a restraint running past its authorization
// (SRS-NUR-013).
func (r *Restraint) AuthorizationExpired(now time.Time) bool {
	return r.Active() && !now.UTC().Before(r.Current().ExpiresAt.UTC())
}

// MonitoringOverdue reports a restrained patient who has not been checked
// within the interval.
func (r *Restraint) MonitoringOverdue(now time.Time) bool {
	if !r.Active() || r.MonitorEvery <= 0 {
		return false
	}
	last := r.StartedAt
	for _, c := range r.Monitoring {
		if c.ObservedAt.After(last) {
			last = c.ObservedAt
		}
	}
	return now.UTC().Sub(last.UTC()) > r.MonitorEvery
}

// Check records an observation of a restrained patient.
func (r *Restraint) Check(c RestraintCheck, now time.Time) error {
	if !r.Active() {
		return notAllowedf("this restraint has been discontinued")
	}
	if strings.TrimSpace(c.ObservedBy) == "" {
		return invalidf("a restraint check must record who carried it out")
	}
	if strings.TrimSpace(c.Findings) == "" {
		return invalidf("a restraint check needs its findings")
	}
	if strings.TrimSpace(c.ContinuedReason) == "" {
		return invalidf("a restraint check must say why the restraint is still needed")
	}
	if c.ObservedAt.IsZero() {
		return invalidf("a restraint check needs the time it was carried out")
	}
	observed := c.ObservedAt.UTC()
	if observed.After(now.UTC()) {
		return invalidf("a restraint check cannot have been carried out in the future")
	}
	if observed.Before(r.StartedAt) {
		return invalidf("a restraint check cannot precede the restraint")
	}
	c.ObservedAt = observed
	r.Monitoring = append(r.Monitoring, c)
	sort.SliceStable(r.Monitoring, func(i, j int) bool {
		return r.Monitoring[i].ObservedAt.Before(r.Monitoring[j].ObservedAt)
	})
	r.Version++
	return nil
}

// Discontinue ends a restraint episode.
func (r *Restraint) Discontinue(at time.Time, reason, by string, now time.Time) error {
	if !r.Active() {
		return notAllowedf("this restraint has already been discontinued")
	}
	if at.IsZero() {
		return invalidf("discontinuing a restraint needs the time it was removed")
	}
	ended := at.UTC()
	if ended.Before(r.StartedAt) {
		return invalidf("a restraint cannot end before it began")
	}
	if ended.After(now.UTC()) {
		return invalidf("a restraint cannot have ended in the future")
	}
	if strings.TrimSpace(reason) == "" {
		return invalidf("discontinuing a restraint needs a reason")
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("discontinuing a restraint must record who removed it")
	}
	r.DiscontinuedAt = ended
	r.DiscontinuedBy = by
	r.DiscontinuedReason = strings.TrimSpace(reason)
	r.Version++
	return nil
}

// Duration is how long the patient was restrained.
func (r *Restraint) Duration(asOf time.Time) time.Duration {
	end := asOf.UTC()
	if !r.Active() {
		end = r.DiscontinuedAt.UTC()
	}
	if end.Before(r.StartedAt.UTC()) {
		return 0
	}
	return end.Sub(r.StartedAt.UTC())
}

// The transfusion types are gone.
//
// SRS-NUR-014 modelled a transfusion here in Wave 1, before the blood bank
// context existed. SRS-BLD-010 models the same event, and it is the one that
// survives: bloodbank.episode is linked to the issue, the component and the
// collection, so a look-back can run along it. Two models of one transfusion
// would disagree, and the one that cannot answer "who else received blood
// from this donation" is the one to lose.
//
// What went with them: a derived temperature rise against the baseline
// observation. Nothing called it — no use case, no handler, no screen — so
// nothing that ran is lost. The blood bank keeps the same observations, with
// a timing and a set of values, so the same figure is derivable there when
// something needs it. Said plainly here rather than left for somebody to
// discover from an empty grep.
