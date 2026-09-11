package domain

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// Emergency and downtime access (SRS-SEC-014).
//
// Two different failures need two different mechanisms, and conflating them is
// how "break glass" becomes a login everyone uses:
//
//   EmergencyGrant   the system is up, but the clinician's normal
//                    authorization does not reach the record in front of them
//                    — the unconscious patient admitted to another facility.
//                    Access is granted, widely logged, and reviewed afterwards.
//
//   DowntimeEpisode  the system is down. Care continues on paper, and what
//                    happened has to be reconciled back into the record once
//                    the system returns, with its true clinical time and the
//                    person who actually did it.
//
// The requirement's phrase "does not normalize bypass credentials" is the
// design constraint that shapes both. A grant is therefore bounded in time,
// tied to one declared incident, refused when one is already open for the
// same subject, and — the part that matters most — grants no permission the
// subject does not already hold. It widens the *scope* a permission reaches,
// under audit, and nothing else. A break-glass session cannot delete a tenant
// if the clinician could not delete a tenant on Tuesday.

// MaxEmergencyGrantTTL bounds a single activation.
//
// Four hours is roughly a shift handover. Long enough that a clinician is not
// re-justifying mid-resuscitation; short enough that nobody keeps one open as
// a convenience. Extension is deliberately not modelled: a second emergency is
// a second declaration.
const MaxEmergencyGrantTTL = 4 * time.Hour

// EmergencyReviewWindow is how long the organisation has to review access
// taken under a grant before the review is overdue. Review is what makes the
// mechanism accountable rather than merely logged.
const EmergencyReviewWindow = 7 * 24 * time.Hour

// EmergencyGrantStatus is the lifecycle of one activation.
type EmergencyGrantStatus string

const (
	EmergencyActive         EmergencyGrantStatus = "active"
	EmergencyClosed         EmergencyGrantStatus = "closed"
	EmergencyExpired        EmergencyGrantStatus = "expired"
	EmergencyReviewed       EmergencyGrantStatus = "reviewed"
	EmergencyReviewedAbused EmergencyGrantStatus = "reviewed_abused"
)

// EmergencyGrant is one time-boxed break-glass activation.
type EmergencyGrant struct {
	ID            string
	TenantID      string
	SubjectID     string
	FacilityID    string
	IncidentRef   string
	Justification string
	// Permissions the grant may be exercised with. Always a subset of what the
	// subject already holds — see NewEmergencyGrant.
	Permissions []string
	Status      EmergencyGrantStatus
	ActivatedAt time.Time
	ExpiresAt   time.Time
	ClosedAt    time.Time
	// AccessedResources is what was actually reached under the grant. An empty
	// list at review time is itself a finding: a declaration that touched
	// nothing was probably a mistaken activation.
	AccessedResources []string
	ReviewedBy        string
	ReviewedAt        time.Time
	ReviewNote        string
	CorrelationID     string
}

var (
	// ErrInvalidEmergencyGrant reports an activation that must be refused.
	ErrInvalidEmergencyGrant = errors.New("security: invalid emergency access grant")
	// ErrGrantAlreadyActive reports a second activation for a subject who
	// already has one open. Stacking grants is how a bounded TTL is defeated.
	ErrGrantAlreadyActive = errors.New("security: an emergency grant is already active for this subject")
	// ErrEscalation reports a grant that asked for a permission the subject
	// does not hold. Emergency access widens reach, never privilege.
	ErrEscalation = errors.New("security: emergency access cannot grant a permission the subject does not hold")
	// ErrGrantNotActive reports use of a grant that has been closed or expired.
	ErrGrantNotActive = errors.New("security: emergency grant is not active")
	// ErrSelfReview reports a grant reviewed by the person who activated it.
	ErrSelfReview = errors.New("security: an emergency grant cannot be reviewed by its activator")
)

// NewEmergencyGrant validates and opens an activation.
//
// heldPermissions is what the subject's own roles already give them; anything
// requested outside it is an escalation attempt and the whole activation is
// refused rather than silently trimmed. Trimming would leave the clinician
// believing they have access they do not, which in an emergency is worse than
// a clear refusal.
//
// activeGrantExists is passed in rather than queried here so the domain stays
// free of I/O; the caller must read it inside the same transaction that
// inserts the grant, or the check races.
func NewEmergencyGrant(
	id, tenantID, subjectID, facilityID, incidentRef, justification, correlationID string,
	requested, heldPermissions []string,
	ttl time.Duration,
	activeGrantExists bool,
	now time.Time,
) (EmergencyGrant, error) {
	switch {
	case strings.TrimSpace(id) == "":
		return EmergencyGrant{}, fmt.Errorf("%w: id is required", ErrInvalidEmergencyGrant)
	case strings.TrimSpace(tenantID) == "":
		return EmergencyGrant{}, fmt.Errorf("%w: tenant is required", ErrInvalidEmergencyGrant)
	case strings.TrimSpace(subjectID) == "":
		return EmergencyGrant{}, fmt.Errorf("%w: subject is required", ErrInvalidEmergencyGrant)
	case strings.TrimSpace(incidentRef) == "":
		// Without an incident reference the review has nothing to check the
		// justification against.
		return EmergencyGrant{}, fmt.Errorf("%w: incident reference is required", ErrInvalidEmergencyGrant)
	case len(strings.TrimSpace(justification)) < MinJustificationLength:
		return EmergencyGrant{}, fmt.Errorf("%w: justification must be at least %d characters",
			ErrInvalidEmergencyGrant, MinJustificationLength)
	case len(requested) == 0:
		return EmergencyGrant{}, fmt.Errorf("%w: at least one permission is required", ErrInvalidEmergencyGrant)
	case ttl <= 0:
		return EmergencyGrant{}, fmt.Errorf("%w: ttl must be positive", ErrInvalidEmergencyGrant)
	case ttl > MaxEmergencyGrantTTL:
		return EmergencyGrant{}, fmt.Errorf("%w: ttl %v exceeds the %v maximum",
			ErrInvalidEmergencyGrant, ttl, MaxEmergencyGrantTTL)
	case activeGrantExists:
		return EmergencyGrant{}, ErrGrantAlreadyActive
	}

	held := make(map[string]bool, len(heldPermissions))
	for _, p := range heldPermissions {
		held[p] = true
	}
	granted := make([]string, 0, len(requested))
	for _, p := range requested {
		if !held[p] {
			return EmergencyGrant{}, fmt.Errorf("%w: %q", ErrEscalation, p)
		}
		granted = append(granted, p)
	}

	now = now.UTC()
	return EmergencyGrant{
		ID:            id,
		TenantID:      tenantID,
		SubjectID:     subjectID,
		FacilityID:    facilityID,
		IncidentRef:   incidentRef,
		Justification: justification,
		Permissions:   granted,
		Status:        EmergencyActive,
		ActivatedAt:   now,
		ExpiresAt:     now.Add(ttl),
		CorrelationID: correlationID,
	}, nil
}

// Authorize reports whether the grant may be exercised for a permission now.
//
// Expiry is evaluated against the clock rather than the stored status: a grant
// whose sweeper has not run yet is still expired, and a caller must not be
// able to use one because a background job is behind.
func (g EmergencyGrant) Authorize(permission string, now time.Time) error {
	if err := g.checkLive(now); err != nil {
		return err
	}
	for _, p := range g.Permissions {
		if p == permission {
			return nil
		}
	}
	return fmt.Errorf("%w: %q is outside this grant", ErrGrantNotActive, permission)
}

// RecordAccess notes a resource reached under the grant.
//
// This list is the review's subject matter, so it is append-only and
// deduplicated rather than counted: a reviewer needs to see *which* records a
// clinician opened, not how many.
func (g *EmergencyGrant) RecordAccess(resourceRef string, now time.Time) error {
	if err := g.checkLive(now); err != nil {
		return err
	}
	for _, r := range g.AccessedResources {
		if r == resourceRef {
			return nil
		}
	}
	g.AccessedResources = append(g.AccessedResources, resourceRef)
	return nil
}

// checkLive reports whether the grant is still open, independently of any
// particular permission.
func (g EmergencyGrant) checkLive(now time.Time) error {
	if g.Status != EmergencyActive {
		return fmt.Errorf("%w: status is %s", ErrGrantNotActive, g.Status)
	}
	if !now.UTC().Before(g.ExpiresAt) {
		return fmt.Errorf("%w: expired at %s", ErrGrantNotActive, g.ExpiresAt.Format(time.RFC3339))
	}
	return nil
}

// Close ends an activation early, when the emergency is over.
func (g *EmergencyGrant) Close(now time.Time) error {
	if g.Status != EmergencyActive {
		return fmt.Errorf("%w: status is %s", ErrGrantNotActive, g.Status)
	}
	g.Status = EmergencyClosed
	g.ClosedAt = now.UTC()
	return nil
}

// Expire marks a grant whose window has passed. Idempotent, because the
// sweeper that calls it is at-least-once.
func (g *EmergencyGrant) Expire(now time.Time) {
	if g.Status == EmergencyActive && !now.UTC().Before(g.ExpiresAt) {
		g.Status = EmergencyExpired
		g.ClosedAt = g.ExpiresAt
	}
}

// Review closes the accountability loop.
//
// abused records the reviewer's finding that the access was not justified.
// That verdict is kept as a distinct status rather than a note, because it is
// the one outcome something downstream must act on.
func (g *EmergencyGrant) Review(reviewedBy, note string, abused bool, now time.Time) error {
	switch {
	case g.Status != EmergencyClosed && g.Status != EmergencyExpired:
		return fmt.Errorf("%w: a grant is reviewed after it ends, not while %s",
			ErrInvalidEmergencyGrant, g.Status)
	case strings.TrimSpace(reviewedBy) == "":
		return fmt.Errorf("%w: reviewer is required", ErrInvalidEmergencyGrant)
	case reviewedBy == g.SubjectID:
		return ErrSelfReview
	case len(strings.TrimSpace(note)) < MinJustificationLength:
		return fmt.Errorf("%w: review note must be at least %d characters",
			ErrInvalidEmergencyGrant, MinJustificationLength)
	}
	g.ReviewedBy = reviewedBy
	g.ReviewedAt = now.UTC()
	g.ReviewNote = note
	if abused {
		g.Status = EmergencyReviewedAbused
	} else {
		g.Status = EmergencyReviewed
	}
	return nil
}

// ReviewOverdue reports a finished grant nobody has reviewed in time.
func (g EmergencyGrant) ReviewOverdue(now time.Time) bool {
	if g.Status != EmergencyClosed && g.Status != EmergencyExpired {
		return false
	}
	return now.UTC().After(g.ClosedAt.Add(EmergencyReviewWindow))
}

// DowntimeStatus is the lifecycle of a planned or unplanned outage during
// which care was delivered without the system.
type DowntimeStatus string

const (
	DowntimeOpen       DowntimeStatus = "open"
	DowntimeRecovering DowntimeStatus = "recovering"
	DowntimeReconciled DowntimeStatus = "reconciled"
)

// DowntimeAction is one thing that happened on paper while the system was
// unavailable, and its reconciliation back into the record.
type DowntimeAction struct {
	ID string
	// PerformedBy and PerformedAt are the clinical truth: who actually did it
	// and when. They are not the person who typed it in afterwards, and not
	// the time they typed it. Recording the transcription as if it were the
	// care is the failure mode this type exists to prevent.
	PerformedBy string
	PerformedAt time.Time
	ActionType  string
	SubjectRef  string
	Summary     string
	// PaperFormRef ties the entry back to the physical record, so a dispute
	// can be settled against the form rather than against the database.
	PaperFormRef string

	ReconciledBy string
	ReconciledAt time.Time
	// ResourceRef is what the action became in the system once reconciled.
	ResourceRef string
}

// Reconciled reports whether this action has been entered into the record.
func (a DowntimeAction) Reconciled() bool { return !a.ReconciledAt.IsZero() }

// DowntimeEpisode is one outage and everything owed to the record because of it.
type DowntimeEpisode struct {
	ID            string
	TenantID      string
	FacilityID    string
	Planned       bool
	DeclaredBy    string
	DeclaredAt    time.Time
	Reason        string
	RestoredAt    time.Time
	Status        DowntimeStatus
	Actions       []DowntimeAction
	ClosedBy      string
	ClosedAt      time.Time
	CorrelationID string
}

var (
	// ErrInvalidDowntime reports an episode or action that must be refused.
	ErrInvalidDowntime = errors.New("security: invalid downtime record")
	// ErrUnreconciled reports an attempt to close an episode that still owes
	// entries to the record.
	ErrUnreconciled = errors.New("security: downtime episode has unreconciled actions")
)

// NewDowntimeEpisode declares an outage.
func NewDowntimeEpisode(id, tenantID, facilityID, declaredBy, reason, correlationID string,
	planned bool, now time.Time) (DowntimeEpisode, error) {
	switch {
	case strings.TrimSpace(id) == "":
		return DowntimeEpisode{}, fmt.Errorf("%w: id is required", ErrInvalidDowntime)
	case strings.TrimSpace(tenantID) == "":
		return DowntimeEpisode{}, fmt.Errorf("%w: tenant is required", ErrInvalidDowntime)
	case strings.TrimSpace(facilityID) == "":
		// Downtime is local: one ward loses the network while the rest of the
		// hospital keeps working, and the reconciliation queue belongs to that
		// ward.
		return DowntimeEpisode{}, fmt.Errorf("%w: facility is required", ErrInvalidDowntime)
	case strings.TrimSpace(declaredBy) == "":
		return DowntimeEpisode{}, fmt.Errorf("%w: declaring user is required", ErrInvalidDowntime)
	case len(strings.TrimSpace(reason)) < MinJustificationLength:
		return DowntimeEpisode{}, fmt.Errorf("%w: reason must be at least %d characters",
			ErrInvalidDowntime, MinJustificationLength)
	}
	return DowntimeEpisode{
		ID: id, TenantID: tenantID, FacilityID: facilityID,
		Planned: planned, DeclaredBy: declaredBy, Reason: reason,
		DeclaredAt: now.UTC(), Status: DowntimeOpen, CorrelationID: correlationID,
	}, nil
}

// RecordAction logs something done on paper during the outage.
//
// Actions may still be recorded while recovering: the queue is worked through
// after the system returns, and a ward will find forms it had not yet entered.
func (e *DowntimeEpisode) RecordAction(a DowntimeAction, now time.Time) error {
	switch {
	case e.Status == DowntimeReconciled:
		return fmt.Errorf("%w: episode is already reconciled", ErrInvalidDowntime)
	case strings.TrimSpace(a.ID) == "":
		return fmt.Errorf("%w: action id is required", ErrInvalidDowntime)
	case strings.TrimSpace(a.PerformedBy) == "":
		return fmt.Errorf("%w: the clinician who performed the action is required", ErrInvalidDowntime)
	case a.PerformedAt.IsZero():
		return fmt.Errorf("%w: the time the action was performed is required", ErrInvalidDowntime)
	case a.PerformedAt.UTC().Before(e.DeclaredAt):
		// An action before the outage began belongs in the record directly;
		// backdating it through the downtime queue evades the normal controls.
		return fmt.Errorf("%w: action at %s predates the episode declared at %s",
			ErrInvalidDowntime, a.PerformedAt.UTC().Format(time.RFC3339), e.DeclaredAt.Format(time.RFC3339))
	case a.PerformedAt.UTC().After(now.UTC()):
		return fmt.Errorf("%w: action is in the future", ErrInvalidDowntime)
	case strings.TrimSpace(a.PaperFormRef) == "":
		return fmt.Errorf("%w: paper form reference is required", ErrInvalidDowntime)
	case strings.TrimSpace(a.SubjectRef) == "":
		return fmt.Errorf("%w: subject reference is required", ErrInvalidDowntime)
	}
	for _, existing := range e.Actions {
		if existing.ID == a.ID {
			// Idempotent: a retried submission from a ward terminal that lost
			// its response must not duplicate a clinical entry.
			return nil
		}
	}
	a.ReconciledAt = time.Time{}
	a.ReconciledBy = ""
	a.ResourceRef = ""
	e.Actions = append(e.Actions, a)
	return nil
}

// Restore marks the system available again. The episode is not finished: it
// moves to recovering, because the reconciliation work starts now.
func (e *DowntimeEpisode) Restore(now time.Time) error {
	if e.Status != DowntimeOpen {
		return fmt.Errorf("%w: episode is %s", ErrInvalidDowntime, e.Status)
	}
	e.Status = DowntimeRecovering
	e.RestoredAt = now.UTC()
	return nil
}

// Reconcile records that one paper action is now in the system.
func (e *DowntimeEpisode) Reconcile(actionID, reconciledBy, resourceRef string, now time.Time) error {
	switch {
	case strings.TrimSpace(reconciledBy) == "":
		return fmt.Errorf("%w: reconciling user is required", ErrInvalidDowntime)
	case strings.TrimSpace(resourceRef) == "":
		return fmt.Errorf("%w: the resource the action became is required", ErrInvalidDowntime)
	}
	for i := range e.Actions {
		if e.Actions[i].ID != actionID {
			continue
		}
		if e.Actions[i].Reconciled() {
			// Idempotent, but only for the same target. Pointing one paper
			// action at a second resource would double it in the record.
			if e.Actions[i].ResourceRef == resourceRef {
				return nil
			}
			return fmt.Errorf("%w: action %s is already reconciled to %s",
				ErrInvalidDowntime, actionID, e.Actions[i].ResourceRef)
		}
		e.Actions[i].ReconciledBy = reconciledBy
		e.Actions[i].ReconciledAt = now.UTC()
		e.Actions[i].ResourceRef = resourceRef
		return nil
	}
	return fmt.Errorf("%w: no action %s in this episode", ErrInvalidDowntime, actionID)
}

// Outstanding lists the actions still owed to the record.
func (e DowntimeEpisode) Outstanding() []DowntimeAction {
	var out []DowntimeAction
	for _, a := range e.Actions {
		if !a.Reconciled() {
			out = append(out, a)
		}
	}
	return out
}

// Close finishes an episode.
//
// It refuses while anything is outstanding. This is the whole control: an
// episode that can be closed with unreconciled actions is an episode whose
// paper records quietly never reach the chart, and that is a patient-safety
// failure rather than a bookkeeping one.
func (e *DowntimeEpisode) Close(closedBy string, now time.Time) error {
	switch {
	case e.Status != DowntimeRecovering:
		return fmt.Errorf("%w: close an episode after restore, not while %s", ErrInvalidDowntime, e.Status)
	case strings.TrimSpace(closedBy) == "":
		return fmt.Errorf("%w: closing user is required", ErrInvalidDowntime)
	}
	if outstanding := e.Outstanding(); len(outstanding) > 0 {
		return fmt.Errorf("%w: %d of %d actions not entered into the record",
			ErrUnreconciled, len(outstanding), len(e.Actions))
	}
	e.Status = DowntimeReconciled
	e.ClosedBy = closedBy
	e.ClosedAt = now.UTC()
	return nil
}
