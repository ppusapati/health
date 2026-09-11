package application

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/security/domain"
	"github.com/ppusapati/health/code/internal/security/ports"
)

// Retention sweep (SRS-DAT-009).
//
// The requirement's verification is one sentence — "deletion/archival job skips
// legal-held records" — and it is the sentence that decides the shape of this
// code. Two designs are possible:
//
//	(a) select the expired rows, then filter out the held ones
//	(b) ask which rows are held, then select the expired rows excluding them
//
// They look equivalent and are not. In (a) the deletion is the default and the
// hold is a filter someone can forget, reorder, or short-circuit on an empty
// result. In (b) the hold list is an input the sweep cannot run without. This
// is (b): HeldResourceIDs is fetched first, and a failure to fetch it aborts
// the sweep rather than proceeding with an empty exclusion set — the one
// behaviour that would delete held records while reporting success.

// Candidate is a record the sweep is considering.
type Candidate struct {
	ResourceType string
	ResourceID   string
	CreatedAt    time.Time
}

// SweepOutcome is what the sweep decided about one candidate.
type SweepOutcome struct {
	Candidate Candidate
	MayDelete bool
	Reason    string
}

// SweepReport summarises a run, for the operator and for the evidence trail.
type SweepReport struct {
	Class      string
	Considered int
	Deletable  int
	// Held is reported separately from merely retained because it is the
	// number a compliance reviewer asks about, and because a sudden drop in it
	// means a hold was released, which somebody should have noticed.
	Held        int
	Retained    int
	Outcomes    []SweepOutcome
	EvaluatedAt time.Time
}

// RetentionPorts are the stores the sweep needs. Grouped into their own type
// because the sweep is the only use case that touches retention classes, and
// threading two more fields through NewService for it would make the common
// construction worse.
type RetentionPorts struct {
	Retention ports.RetentionStore
	Holds     ports.LegalHoldStore
}

// EvaluateRetention decides what may be deleted, and records the decision.
//
// It returns decisions rather than performing deletions. The records live in
// other bounded contexts, which own their own deletion, and a sweep that
// reached across contexts to delete rows would be exactly the coupling the
// modular monolith exists to avoid. What this owns is the *judgement*, and the
// security event that proves the judgement was made.
func (s *Service) EvaluateRetention(ctx context.Context, p RetentionPorts,
	className string, candidates []Candidate) (SweepReport, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return SweepReport{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}
	scope := session.TenantScope()

	class, err := p.Retention.GetClass(ctx, scope, className)
	if err != nil {
		return SweepReport{}, err
	}

	// Fetched before anything is evaluated, and a failure aborts. Continuing
	// with an empty hold set is the one failure mode that deletes held records
	// while reporting success, so it must not be reachable.
	held := map[string]bool{}
	byType := map[string]bool{}
	for _, c := range candidates {
		byType[c.ResourceType] = true
	}
	for resourceType := range byType {
		ids, err := p.Holds.HeldResourceIDs(ctx, scope, resourceType)
		if err != nil {
			return SweepReport{}, fmt.Errorf("retention sweep aborted: could not read legal holds "+
				"for %s: %w", resourceType, err)
		}
		for _, id := range ids {
			held[resourceType+"/"+id] = true
		}
	}

	now := s.clock.Now()
	report := SweepReport{
		Class:       class.Name,
		Considered:  len(candidates),
		Outcomes:    make([]SweepOutcome, 0, len(candidates)),
		EvaluatedAt: now,
	}

	for _, c := range candidates {
		underHold := held[c.ResourceType+"/"+c.ResourceID]
		decision := domain.EvaluateDeletion(class, c.CreatedAt, now, underHold)

		switch {
		case decision.MayDelete:
			report.Deletable++
		case decision.Reason == domain.ReasonLegalHeld:
			report.Held++
		default:
			report.Retained++
		}
		report.Outcomes = append(report.Outcomes, SweepOutcome{
			Candidate: c, MayDelete: decision.MayDelete, Reason: decision.Reason,
		})
	}

	detail, err := json.Marshal(map[string]any{
		"retention_class": class.Name,
		"data_class":      class.DataClass,
		"considered":      report.Considered,
		"deletable":       report.Deletable,
		"legal_held":      report.Held,
		"retained":        report.Retained,
	})
	if err != nil {
		return SweepReport{}, rpcerr.Internal("SEC_EVENT_ENCODE_FAILED", "could not encode security event").WithCause(err)
	}
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		return s.appendEvent(ctx, session, domain.SecurityEvent{
			Class:        domain.ClassRetentionChange,
			Severity:     domain.SeverityInfo,
			ResourceType: "retention_class",
			ResourceID:   class.Name,
			Outcome:      domain.OutcomeSuccess,
			Detail:       detail,
		}, now)
	})
	if err != nil {
		return SweepReport{}, err
	}
	return report, nil
}

// Deletable lists the candidates the sweep cleared, for the context that owns
// them to act on. Nothing else in the report is actionable by a caller.
func (r SweepReport) Deletions() []Candidate {
	out := make([]Candidate, 0, r.Deletable)
	for _, o := range r.Outcomes {
		if o.MayDelete {
			out = append(out, o.Candidate)
		}
	}
	return out
}
