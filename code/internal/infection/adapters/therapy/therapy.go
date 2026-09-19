// Package therapy implements the infection control Therapy port against the
// medication context.
//
// Read-only by construction, and that is the requirement rather than a
// convenience. SRS-IPC-008's acceptance is that a stewardship review appears
// in a worklist "without autonomous medication change", so this adapter holds
// a prescription *reader* and nothing that writes: there is no method here
// that could stop, change or substitute a drug, and adding one would mean
// widening the port first.
package therapy

import (
	"context"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/infection/ports"
	medicationdomain "github.com/ppusapati/health/code/internal/medication/domain"
	medicationports "github.com/ppusapati/health/code/internal/medication/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// Config is what a deployment has classified.
type Config struct {
	// AntimicrobialCodes are the ingredient codes the hospital treats as
	// antimicrobials. Empty classifies nothing, so no review is ever raised —
	// named in the status document rather than guessed at from a drug's
	// display name, because a stewardship programme that matched on "-cillin"
	// would miss half the formulary and invent the other half.
	AntimicrobialCodes []string
	// RestrictedCodes are the reserved agents (SRS-IPC-008). A subset of the
	// above in every hospital that has thought about it.
	RestrictedCodes []string
}

// Adapter reads what a patient is on.
type Adapter struct {
	prescriptions medicationports.PrescriptionRepository
	counts        ports.DeviceDayRepository
	clock         ports.Clock
	config        Config
}

// New constructs an adapter.
func New(prescriptions medicationports.PrescriptionRepository,
	counts ports.DeviceDayRepository, clock ports.Clock,
	config Config) *Adapter {

	return &Adapter{
		prescriptions: prescriptions, counts: counts, clock: clock,
		config: config,
	}
}

var _ ports.Therapy = (*Adapter)(nil)

// Current reads the antimicrobials a patient is actually on (SRS-IPC-008).
//
// Two fields of the signal are deliberately left empty, and the gaps are real
// rather than hidden:
//
//   - Culture is nil, because this deployment has no laboratory context yet.
//     The bug-drug mismatch and de-escalation triggers therefore never fire,
//     which is visible as a worklist with only duration, restricted-agent and
//     route reviews on it — not as a stewardship programme that quietly
//     believes every organism is susceptible.
//   - OralRouteAvailable is false, because whether a patient is absorbing is
//     a ward assessment and no drug record answers it. A default of true
//     would raise an intravenous-to-oral review on every patient who is nil
//     by mouth.
func (a *Adapter) Current(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (domain.TherapySignal, error) {

	if a == nil || a.prescriptions == nil {
		return domain.TherapySignal{}, nil
	}

	live, err := a.prescriptions.ForEncounter(ctx, scope, encounterID, true,
		200)
	if err != nil {
		return domain.TherapySignal{}, err
	}

	now := a.clock.Now()
	signal := domain.TherapySignal{EncounterID: encounterID}
	for _, prescription := range live {
		if prescription == nil ||
			prescription.Status != medicationdomain.TherapyActive {
			continue
		}
		code := prescription.Ingredient.Code
		if !contains(a.config.AntimicrobialCodes, code) {
			continue
		}
		signal.PatientID = prescription.PatientID
		signal.Therapy = append(signal.Therapy, domain.AgentInUse{
			OrderID: prescription.OrderID,
			Agent:   agentName(prescription),
			Route:   prescription.Route,
			// Day 1 is the first day, so a therapy started this morning is on
			// day 1 rather than day 0. A duration rule set to three days
			// should fire on the third calendar day of treatment.
			DayOfTherapy: daysOfTherapy(prescription.StartsAt, now),
			Restricted:   contains(a.config.RestrictedCodes, code),
			StartedAt:    prescription.StartsAt,
		})
	}
	return signal, nil
}

// PatientDays sums a location's census over a period (SRS-IPC-010).
//
// Read from the device-day counts the wards already file, taking the largest
// patient-day figure recorded for a day rather than adding them up: the same
// census is filed against each device that day, so summing would multiply the
// denominator by the number of devices a ward happens to track.
func (a *Adapter) PatientDays(ctx context.Context, scope authctx.TenantScope,
	locationID string, from, to time.Time) (int, error) {

	if a == nil || a.counts == nil {
		return 0, nil
	}
	counts, err := a.counts.DeviceDays(ctx, scope, ports.DeviceDayFilter{
		LocationID: locationID, From: from, To: to,
	})
	if err != nil {
		return 0, err
	}

	byDay := map[time.Time]int{}
	for _, count := range counts {
		day := count.On.UTC().Truncate(24 * time.Hour)
		if count.PatientDays > byDay[day] {
			byDay[day] = count.PatientDays
		}
	}
	total := 0
	for _, patients := range byDay {
		total += patients
	}
	return total, nil
}

func agentName(p *medicationdomain.Prescription) string {
	if display := strings.TrimSpace(p.Ingredient.Display); display != "" {
		return display
	}
	return p.Ingredient.Code
}

func daysOfTherapy(startsAt, now time.Time) int {
	if startsAt.IsZero() || now.Before(startsAt) {
		return 0
	}
	start := startsAt.UTC().Truncate(24 * time.Hour)
	today := now.UTC().Truncate(24 * time.Hour)
	return int(today.Sub(start).Hours()/24) + 1
}

func contains(codes []string, code string) bool {
	for _, one := range codes {
		if strings.EqualFold(one, code) {
			return true
		}
	}
	return false
}
