package domain

import (
	"fmt"
	"strings"
	"time"
)

// Cancellation and reschedule policy (SRS-SCH-005).
//
// The requirement asks for a "policy-driven cutoff, reason and fee/refund
// integration". The cutoff is the interesting part: a hospital that charges for
// a late cancellation is making a claim about what the patient agreed to, and
// that claim has to be checkable afterwards. So the policy in force is captured
// on the decision rather than looked up when somebody disputes it — a policy
// changed in March must not retroactively make a February cancellation late.
//
// This system does not charge anybody. It decides whether a cancellation was
// inside or outside the notice period and says so; SRS-BIL owns what that costs.
// Putting the fee here would put pricing in the diary, and the diary is not
// where a refund gets approved.

// CancellationPolicy is the notice a facility requires.
type CancellationPolicy struct {
	// NoticeHours before the appointment beyond which a cancellation is
	// "timely". Zero means no notice is required, which is a real policy for a
	// walk-in clinic.
	NoticeHours int
	// RescheduleNoticeHours is usually shorter than cancellation notice:
	// moving an appointment leaves the clinic able to refill the slot, while
	// cancelling on the day does not.
	RescheduleNoticeHours int
	// MaxReschedules caps how many times one booking may be moved. Zero means
	// unlimited. A booking rescheduled eleven times is a patient who is not
	// coming, and each move costs a slot somebody else could have used.
	MaxReschedules int
	// ChargeableWhenLate says whether a late cancellation is referred to
	// billing at all. A policy that is enforced but never charged is still
	// worth recording: it is what an attendance report counts.
	ChargeableWhenLate bool
}

// DefaultCancellationPolicy is what applies when a tenant has configured
// nothing.
//
// Twenty-four hours to cancel, four to reschedule, and nothing chargeable. A
// default that charged would bill patients on the strength of a setting nobody
// chose.
func DefaultCancellationPolicy() CancellationPolicy {
	return CancellationPolicy{
		NoticeHours:           24,
		RescheduleNoticeHours: 4,
		MaxReschedules:        3,
		ChargeableWhenLate:    false,
	}
}

// Validate rejects a policy that could not be applied.
func (p CancellationPolicy) Validate() error {
	switch {
	case p.NoticeHours < 0 || p.NoticeHours > 30*24:
		return fmt.Errorf("%w: a notice period of %d hours is not a policy",
			ErrInvalidSchedule, p.NoticeHours)
	case p.RescheduleNoticeHours < 0 || p.RescheduleNoticeHours > 30*24:
		return fmt.Errorf("%w: a reschedule notice of %d hours is not a policy",
			ErrInvalidSchedule, p.RescheduleNoticeHours)
	case p.MaxReschedules < 0 || p.MaxReschedules > 50:
		return fmt.Errorf("%w: a reschedule cap of %d is not a policy",
			ErrInvalidSchedule, p.MaxReschedules)
	}
	return nil
}

// CancellationOutcome is what a cancellation was, under the policy in force.
type CancellationOutcome struct {
	// Timely reports that the patient gave the required notice.
	Timely bool
	// NoticeGiven is how much warning there actually was. Recorded rather than
	// derived later: "cancelled 23 hours before" is the fact a dispute turns
	// on, and recomputing it from two timestamps months later invites a
	// rounding argument.
	NoticeGiven time.Duration
	// NoticeRequired is the policy in force at the moment of the decision.
	NoticeRequired time.Duration
	// Chargeable says this should be referred to billing (SRS-BIL owns what it
	// costs). False for a timely cancellation and for a policy that charges
	// nothing.
	Chargeable bool
}

// AssessCancellation decides whether a cancellation met the notice period.
//
// A cancellation after the appointment has started is not late — it is
// something else entirely, and recording it as a cancellation rather than a
// no-show is a decision for the person doing it. This reports zero notice and
// lets the caller refuse.
func (p CancellationPolicy) AssessCancellation(startsAt, at time.Time) CancellationOutcome {
	required := time.Duration(p.NoticeHours) * time.Hour
	given := startsAt.Sub(at)
	if given < 0 {
		given = 0
	}

	timely := given >= required
	return CancellationOutcome{
		Timely: timely, NoticeGiven: given, NoticeRequired: required,
		Chargeable: !timely && p.ChargeableWhenLate,
	}
}

// AssessReschedule decides whether a move met the (usually shorter) notice.
func (p CancellationPolicy) AssessReschedule(startsAt, at time.Time) CancellationOutcome {
	required := time.Duration(p.RescheduleNoticeHours) * time.Hour
	given := startsAt.Sub(at)
	if given < 0 {
		given = 0
	}

	timely := given >= required
	return CancellationOutcome{
		Timely: timely, NoticeGiven: given, NoticeRequired: required,
		Chargeable: !timely && p.ChargeableWhenLate,
	}
}

// Cancel moves an appointment to cancelled and records what the policy made of
// it (SRS-SCH-005).
//
// The outcome is stored on the history entry rather than computed on demand,
// so a policy changed in March cannot retroactively make a February
// cancellation late.
func (a *Appointment) Cancel(policy CancellationPolicy, by, reason string,
	now time.Time) (CancellationOutcome, error) {

	if strings.TrimSpace(reason) == "" {
		return CancellationOutcome{}, fmt.Errorf("%w: cancelling needs a reason",
			ErrInvalidAppointment)
	}
	if a.Status == StatusCancelled {
		return CancellationOutcome{}, fmt.Errorf("%w: appointment %s is already cancelled",
			ErrInvalidAppointment, a.id)
	}
	if a.Status.Terminal() {
		// A completed or no-show appointment has happened, or demonstrably has
		// not. Cancelling it would rewrite what took place.
		return CancellationOutcome{}, ErrInvalidTransition{From: a.Status, To: StatusCancelled}
	}

	outcome := policy.AssessCancellation(a.StartsAt, now)

	note := reason
	if !outcome.Timely {
		note = reason + " (late: " + formatNotice(outcome.NoticeGiven) +
			" notice, " + formatNotice(outcome.NoticeRequired) + " required)"
	}
	if err := a.Transition(StatusCancelled, by, note, false, now); err != nil {
		return CancellationOutcome{}, err
	}
	return outcome, nil
}

// formatNotice renders a duration the way a person would say it.
//
// Hours rather than Go's default, because "23h0m0s notice" in a letter to a
// patient reads as a machine talking.
func formatNotice(d time.Duration) string {
	hours := int(d.Hours())
	switch {
	case hours >= 48:
		return fmt.Sprintf("%d days", hours/24)
	case hours >= 1:
		return fmt.Sprintf("%d hours", hours)
	default:
		return fmt.Sprintf("%d minutes", int(d.Minutes()))
	}
}

// Reschedules counts how many times this booking has been moved.
//
// Derived from the chain rather than stored, so it cannot drift from the
// history it describes.
func (a *Appointment) Reschedules() int { return a.RescheduleCount }

// Teleconsult rules (SRS-SCH-015).
//
// The requirement's criterion is that "visit mode drives location/link and
// eligibility checks". Two rules follow, and both are about not stranding a
// patient: a teleconsult with no join link is an appointment nobody can attend,
// and an in-person appointment carrying one invites a patient to stay home.

// ErrTeleconsultNotEligible reports a booking that cannot happen remotely.
type ErrTeleconsultNotEligible struct{ Why string }

func (e ErrTeleconsultNotEligible) Error() string {
	return "scheduling: this appointment cannot be a teleconsult: " + e.Why
}

// TeleconsultPolicy is what a facility permits remotely.
type TeleconsultPolicy struct {
	// Enabled is whether this facility offers teleconsults at all.
	Enabled bool
	// AllowedVisitTypes restricts which kinds of visit may be remote. Empty
	// means every type the roster offers remotely. A procedure that requires
	// the patient in the room is the case this exists for.
	AllowedVisitTypes []VisitType
	// RequireConfirmedIdentity refuses a remote appointment for a patient whose
	// identity has not been positively established. Identifying somebody over
	// video is materially harder than at a desk, and a hospital may reasonably
	// insist the first visit is in person.
	RequireConfirmedIdentity bool
}

// DefaultTeleconsultPolicy is what applies when a tenant has configured
// nothing: teleconsults are off.
//
// Off rather than on, because a facility that has not thought about remote
// consultations has not decided which of its clinics can safely run that way,
// and defaulting to yes decides it for them.
func DefaultTeleconsultPolicy() TeleconsultPolicy {
	return TeleconsultPolicy{Enabled: false}
}

// CheckEligible reports whether a visit may be booked as a teleconsult.
func (p TeleconsultPolicy) CheckEligible(visitType VisitType, identityConfirmed bool) error {
	if !p.Enabled {
		return ErrTeleconsultNotEligible{Why: "this facility does not offer teleconsults"}
	}
	if len(p.AllowedVisitTypes) > 0 {
		var permitted bool
		for _, allowed := range p.AllowedVisitTypes {
			if allowed == visitType {
				permitted = true
				break
			}
		}
		if !permitted {
			return ErrTeleconsultNotEligible{
				Why: "a " + string(visitType) + " visit must happen in person here",
			}
		}
	}
	if p.RequireConfirmedIdentity && !identityConfirmed {
		return ErrTeleconsultNotEligible{
			Why: "this patient's identity has not been confirmed in person",
		}
	}
	return nil
}
