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

// TransfusionStatus is where a transfusion episode stands.
type TransfusionStatus string

const (
	TransfusionInProgress TransfusionStatus = "in_progress"
	TransfusionCompleted  TransfusionStatus = "completed"
	// TransfusionStopped is a transfusion halted for a suspected reaction.
	// Distinct from completed, because the unit did not go in and the
	// remainder has to be returned to the laboratory with the reaction report.
	TransfusionStopped TransfusionStatus = "stopped"
)

// Transfusion is one blood-product episode (SRS-NUR-014).
type Transfusion struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	// UnitNumber is the pack's own identifier, which is what links this record
	// back to the blood bank and forward to a look-back investigation.
	UnitNumber string
	Product    Coding
	// ABOGroup and RhD as issued. Stored on the episode rather than read from
	// the patient, because what matters in a reaction investigation is what
	// was hung, not what should have been.
	ABOGroup string
	RhD      string
	// VolumeML issued.
	VolumeML float64

	StartedAt time.Time
	StartedBy string
	// CheckedBy is the second person at the bedside check. Blood is the one
	// administration where a two-person check is near-universal, so unlike the
	// medication witness it is required here.
	CheckedBy string

	Observations []TransfusionObservation
	Status       TransfusionStatus
	EndedAt      time.Time

	Reaction *TransfusionReaction
	Version  int64
}

// TransfusionObservation is one set of monitoring observations
// (SRS-NUR-014).
type TransfusionObservation struct {
	ID         string
	ObservedAt time.Time
	ObservedBy string
	// TemperatureC, Pulse, SystolicBP and RespiratoryRate are the observations
	// a transfusion protocol requires. Modelled explicitly rather than as a
	// free flowsheet, because a reaction is detected by comparing them against
	// the baseline and a free-form set cannot be compared.
	TemperatureC    float64
	Pulse           int32
	SystolicBP      int32
	RespiratoryRate int32
	// Baseline marks the pre-transfusion set.
	Baseline bool
	Notes    string
}

// TransfusionReaction is a suspected reaction (SRS-NUR-014).
type TransfusionReaction struct {
	ReportedAt time.Time
	ReportedBy string
	Features   string
	// ActionTaken is what was done at the bedside. Required, because the first
	// action — stop the transfusion, keep the line open — is the one that
	// matters and a reaction report without it is a report of an unhandled
	// reaction.
	ActionTaken string
	// UnitReturned records whether the pack went back to the laboratory, which
	// is the step that gets forgotten and the one the investigation needs.
	UnitReturned bool
}

// NewTransfusionInput is what starting a transfusion needs.
type NewTransfusionInput struct {
	PatientID   string
	EncounterID string
	UnitNumber  string
	Product     Coding
	ABOGroup    string
	RhD         string
	VolumeML    float64
	StartedAt   time.Time
	CheckedBy   string
	Baseline    TransfusionObservation
}

// NewTransfusion starts a transfusion episode.
func NewTransfusion(id, tenantID string, in NewTransfusionInput, startedBy string,
	now time.Time) (*Transfusion, error) {

	if strings.TrimSpace(in.PatientID) == "" {
		return nil, invalidf("a transfusion needs a patient")
	}
	if strings.TrimSpace(in.EncounterID) == "" {
		return nil, invalidf("a transfusion needs an encounter")
	}
	if strings.TrimSpace(in.UnitNumber) == "" {
		return nil, invalidf("a transfusion needs the unit number of the pack")
	}
	if err := in.Product.Validate(); err != nil {
		return nil, err
	}
	if strings.TrimSpace(startedBy) == "" {
		return nil, invalidf("a transfusion must record who started it")
	}
	if strings.TrimSpace(in.CheckedBy) == "" {
		return nil, invalidf("a transfusion needs a second person's bedside check")
	}
	if strings.EqualFold(strings.TrimSpace(in.CheckedBy), strings.TrimSpace(startedBy)) {
		// One person checking their own work is not a two-person check, and a
		// system that accepts it has the paperwork without the control.
		return nil, invalidf("the bedside check must be by a second person")
	}
	if in.StartedAt.IsZero() {
		return nil, invalidf("a transfusion needs the time it was started")
	}
	started := in.StartedAt.UTC()
	if started.After(now.UTC()) {
		return nil, invalidf("a transfusion cannot have been started in the future")
	}
	if in.Baseline.ObservedAt.IsZero() {
		// Without a baseline, a temperature of 38.1 twenty minutes in cannot be
		// read as a rise or as where the patient already was.
		return nil, invalidf("a transfusion needs baseline observations before it starts")
	}

	baseline := in.Baseline
	baseline.Baseline = true
	baseline.ObservedAt = baseline.ObservedAt.UTC()
	if baseline.ObservedAt.After(started) {
		return nil, invalidf("baseline observations must precede the transfusion")
	}
	if strings.TrimSpace(baseline.ObservedBy) == "" {
		return nil, invalidf("baseline observations must record who took them")
	}

	return &Transfusion{
		ID: id, TenantID: tenantID,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		UnitNumber: strings.TrimSpace(in.UnitNumber), Product: in.Product,
		ABOGroup: strings.TrimSpace(in.ABOGroup), RhD: strings.TrimSpace(in.RhD),
		VolumeML:  in.VolumeML,
		StartedAt: started, StartedBy: startedBy,
		CheckedBy:    strings.TrimSpace(in.CheckedBy),
		Observations: []TransfusionObservation{baseline},
		Status:       TransfusionInProgress, Version: 1,
	}, nil
}

// Observe records a monitoring set.
func (t *Transfusion) Observe(o TransfusionObservation, now time.Time) error {
	if t.Status != TransfusionInProgress {
		return notAllowedf("this transfusion is no longer running")
	}
	if strings.TrimSpace(o.ObservedBy) == "" {
		return invalidf("a transfusion observation must record who took it")
	}
	if o.ObservedAt.IsZero() {
		return invalidf("a transfusion observation needs the time it was taken")
	}
	observed := o.ObservedAt.UTC()
	if observed.After(now.UTC()) {
		return invalidf("a transfusion observation cannot have been taken in the future")
	}
	o.ObservedAt = observed
	o.Baseline = false
	t.Observations = append(t.Observations, o)
	t.Version++
	return nil
}

// Baseline returns the pre-transfusion observations.
func (t *Transfusion) Baseline() (TransfusionObservation, bool) {
	for _, o := range t.Observations {
		if o.Baseline {
			return o, true
		}
	}
	return TransfusionObservation{}, false
}

// TemperatureRise is how far the patient's temperature has moved from
// baseline.
//
// Reported rather than interpreted. A rise of 1°C with rigors is a reaction
// and a rise of 1°C in a patient who was already septic may not be; this
// context supplies the number and the nurse at the bedside decides, which is
// the same argument SRS-CLN-011 makes about laboratory flags.
func (t *Transfusion) TemperatureRise() (float64, bool) {
	baseline, ok := t.Baseline()
	if !ok {
		return 0, false
	}
	var latest *TransfusionObservation
	for i := range t.Observations {
		if t.Observations[i].Baseline {
			continue
		}
		if latest == nil || t.Observations[i].ObservedAt.After(latest.ObservedAt) {
			latest = &t.Observations[i]
		}
	}
	if latest == nil {
		return 0, false
	}
	return latest.TemperatureC - baseline.TemperatureC, true
}

// ReportReaction stops the transfusion and records a suspected reaction
// (SRS-NUR-014).
//
// Stopping and reporting are one operation rather than two, because they are
// one act at the bedside and splitting them creates a window in which the
// system believes blood is still running into a patient having a reaction.
func (t *Transfusion) ReportReaction(r TransfusionReaction, now time.Time) error {
	if t.Status != TransfusionInProgress {
		return notAllowedf("this transfusion is no longer running")
	}
	if strings.TrimSpace(r.ReportedBy) == "" {
		return invalidf("a transfusion reaction must record who reported it")
	}
	if strings.TrimSpace(r.Features) == "" {
		return invalidf("a transfusion reaction needs its features")
	}
	if strings.TrimSpace(r.ActionTaken) == "" {
		return invalidf("a transfusion reaction needs the action taken")
	}
	r.ReportedAt = now.UTC()
	t.Reaction = &r
	t.Status = TransfusionStopped
	t.EndedAt = now.UTC()
	t.Version++
	return nil
}

// Complete ends a transfusion that finished normally.
func (t *Transfusion) Complete(at time.Time, now time.Time) error {
	if t.Status != TransfusionInProgress {
		return notAllowedf("this transfusion is no longer running")
	}
	if at.IsZero() {
		return invalidf("completing a transfusion needs the time it finished")
	}
	ended := at.UTC()
	if ended.Before(t.StartedAt) {
		return invalidf("a transfusion cannot end before it started")
	}
	if ended.After(now.UTC()) {
		return invalidf("a transfusion cannot have ended in the future")
	}
	t.Status = TransfusionCompleted
	t.EndedAt = ended
	t.Version++
	return nil
}
