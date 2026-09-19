package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/infection/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// OpenCaseInput records a suspected infection (SRS-IPC-001).
//
// There is no onset classification on this input. It is derived from the
// dates and the configured window, and the only way to disagree with the
// derivation is OverrideOnset, which needs its own permission and a reason.
type OpenCaseInput struct {
	Reference    string
	PatientID    string
	EncounterID  string
	FacilityID   string
	LocationID   string
	Organism     string
	OrganismCode string
	Site         domain.InfectionSite
	AdmittedAt   time.Time
	OnsetAt      time.Time
	DeviceInSitu bool
	DeviceDays   int
	Criteria     string
	Notes        string
}

// OpenCase records a suspected infection (SRS-IPC-001).
func (s *Service) OpenCase(ctx context.Context, in OpenCaseInput) (
	domain.SurveillanceCase, error) {

	session, scope, err := s.authorize(ctx, PermCase)
	if err != nil {
		return domain.SurveillanceCase{}, err
	}
	now := s.clock.Now()

	one, err := domain.OpenCase(s.ids.NewID(), session.TenantID,
		domain.NewCaseInput{
			Reference: in.Reference, PatientID: in.PatientID,
			EncounterID: in.EncounterID, FacilityID: in.FacilityID,
			LocationID: in.LocationID, Organism: in.Organism,
			OrganismCode: in.OrganismCode, Site: in.Site,
			AdmittedAt: in.AdmittedAt, OnsetAt: in.OnsetAt,
			DeviceInSitu: in.DeviceInSitu, DeviceDays: in.DeviceDays,
			Criteria: in.Criteria, Notes: in.Notes,
		}, s.config.SurveillanceWindowHours,
		s.multidrugResistant(in.OrganismCode), session.SubjectID, now)
	if err != nil {
		return domain.SurveillanceCase{}, infectionError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.cases.InsertCase(ctx, scope, one); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "infection.case.opened", ResourceType: "ipc_case",
			ResourceID: one.ID, Outcome: audit.OutcomeSuccess,
			Reason: "opened a surveillance case",
		}, now); err != nil {
			return err
		}
		// The organism and the derived classification, never the patient:
		// "patient 41 has MRSA" is the sentence an event stream must not
		// carry.
		return s.appendEvent(ctx, session, EventCaseOpened, "ipc_case",
			one.ID, map[string]any{
				"site": string(one.Site), "organism_code": one.OrganismCode,
				"onset": string(one.Onset), "location_id": one.LocationID,
				"multidrug_resistant": one.MultidrugResistant,
			}, now)
	})
	if err != nil {
		return domain.SurveillanceCase{}, infectionError(err)
	}
	return one, nil
}

// ReviewCase judges a case against the surveillance definition
// (SRS-IPC-001).
func (s *Service) ReviewCase(ctx context.Context, caseID string,
	to domain.CaseState, criteria string) (domain.SurveillanceCase, error) {

	session, scope, err := s.authorize(ctx, PermCase)
	if err != nil {
		return domain.SurveillanceCase{}, err
	}
	now := s.clock.Now()

	var reviewed domain.SurveillanceCase
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		one, err := s.cases.Case(ctx, scope, caseID)
		if err != nil {
			return err
		}
		version := one.Version
		if err := one.Review(to, criteria, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.cases.UpdateCase(ctx, scope, one, version); err != nil {
			return err
		}
		reviewed = one

		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "infection.case.reviewed", ResourceType: "ipc_case",
			ResourceID: one.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{"state": string(to)}),
			Reason:  "judged a case against the surveillance definition",
		}, now); err != nil {
			return err
		}
		if to != domain.CaseConfirmed {
			return nil
		}
		return s.appendEvent(ctx, session, EventCaseConfirmed, "ipc_case",
			one.ID, map[string]any{
				"site": string(one.Site), "organism_code": one.OrganismCode,
				"onset":       string(one.EffectiveOnset()),
				"location_id": one.LocationID,
			}, now)
	})
	if err != nil {
		return domain.SurveillanceCase{}, infectionError(err)
	}
	return reviewed, nil
}

// OverrideOnset records a reviewer disagreeing with the derivation
// (SRS-IPC-001).
//
// Its own permission, its own audit entry and its own event. A hospital whose
// healthcare-associated infections are quietly reclassified as
// community-acquired reports a falling rate and has no way to see it
// happening; this is the one call that can do it, and it leaves three traces.
func (s *Service) OverrideOnset(ctx context.Context, caseID string,
	to domain.Onset, reason string) (domain.SurveillanceCase, error) {

	session, scope, err := s.authorize(ctx, PermOverrideOnset)
	if err != nil {
		return domain.SurveillanceCase{}, err
	}
	now := s.clock.Now()

	var overridden domain.SurveillanceCase
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		one, err := s.cases.Case(ctx, scope, caseID)
		if err != nil {
			return err
		}
		version := one.Version
		from := one.Onset
		if err := one.OverrideOnset(to, reason, session.SubjectID); err != nil {
			return err
		}
		if err := s.cases.UpdateCase(ctx, scope, one, version); err != nil {
			return err
		}
		overridden = one

		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "infection.case.onset_overridden", ResourceType: "ipc_case",
			ResourceID: one.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"from": string(from), "to": string(to),
			}),
			Reason: reason,
		}, now); err != nil {
			return err
		}
		return s.appendEvent(ctx, session, EventOnsetOverridden, "ipc_case",
			one.ID, map[string]any{
				"from": string(from), "to": string(to),
				"site": string(one.Site), "location_id": one.LocationID,
			}, now)
	})
	if err != nil {
		return domain.SurveillanceCase{}, infectionError(err)
	}
	return overridden, nil
}

// Cases lists surveillance cases (SRS-IPC-001).
func (s *Service) Cases(ctx context.Context, f ports.CaseFilter) (
	[]domain.SurveillanceCase, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	f.Limit = clampPageSize(f.Limit)
	return s.cases.Cases(ctx, scope, f)
}

// RecordDeviceDays files one day's census (SRS-IPC-002).
//
// Counted at the bedside rather than estimated from anything, which is what
// makes the rates reproducible. Re-filing a day corrects it; the unique index
// stops it doubling.
func (s *Service) RecordDeviceDays(ctx context.Context, facilityID,
	locationID string, device domain.DeviceKind, on time.Time,
	patientDays, deviceDays int) (domain.DeviceDayCount, error) {

	session, scope, err := s.authorize(ctx, PermDenominator)
	if err != nil {
		return domain.DeviceDayCount{}, err
	}
	now := s.clock.Now()

	count, err := domain.NewDeviceDayCount(s.ids.NewID(), session.TenantID,
		facilityID, locationID, device, on, patientDays, deviceDays,
		session.SubjectID, now)
	if err != nil {
		return domain.DeviceDayCount{}, infectionError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.deviceDays.UpsertDeviceDays(ctx, scope, count); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.device_days.recorded",
			ResourceType: "ipc_device_day_count", ResourceID: count.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"location_id": locationID, "device": string(device),
				"device_days":  itoa(deviceDays),
				"patient_days": itoa(patientDays),
			}),
			Reason: "recorded a daily device census",
		}, now)
	})
	if err != nil {
		return domain.DeviceDayCount{}, infectionError(err)
	}
	return count, nil
}

// Rate computes one device-associated infection rate (SRS-IPC-002,
// SRS-IPC-010).
//
// Where the site has an indicator configured, the numerator and denominator
// are also filed against the quality context's versioned dictionary, and the
// revision it was recorded under comes back on the rate. Two dictionaries
// would disagree, and the argument would then be about which report was right
// rather than about the infection rate.
func (s *Service) Rate(ctx context.Context, site domain.InfectionSite,
	locationID string, from, to time.Time) (Rate, error) {

	session, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return Rate{}, err
	}
	if !to.After(from) {
		return Rate{}, rpcerr.Invalid("IPC_INVALID",
			"a rate needs a period that ends after it starts")
	}
	now := s.clock.Now()

	cases, err := s.cases.Cases(ctx, scope, ports.CaseFilter{
		Site: site, LocationID: locationID, From: from, To: to,
		Limit: reportPageSize,
	})
	if err != nil {
		return Rate{}, err
	}
	device, _ := domain.DeviceFor(site)
	counts, err := s.deviceDays.DeviceDays(ctx, scope, ports.DeviceDayFilter{
		Device: device, LocationID: locationID, From: from, To: to,
	})
	if err != nil {
		return Rate{}, err
	}

	out := Rate{Rate: domain.ComputeRate(domain.RateInput{
		Site: site, Location: locationID, From: from, To: to,
		Cases: cases, Counts: counts,
	})}
	// Counted here and reported beside the rate: a month in which eleven
	// cases were reclassified by hand is a month somebody should look at, and
	// a rate alone hides exactly that.
	out.Onsets = domain.SummariseOnset(cases)

	code := s.config.IndicatorForSite[site]
	if code == "" || s.indicators == nil {
		return out, nil
	}
	revision, err := s.indicators.Record(ctx, scope, code, from, to,
		out.Infections, out.DeviceDays, session.SubjectID, now)
	if err != nil {
		return Rate{}, err
	}
	out.IndicatorCode, out.IndicatorRevision = code, revision
	return out, nil
}

// Rate is a computed rate and what a reader needs to judge it
// (SRS-IPC-010).
type Rate struct {
	domain.Rate
	// Onsets counts how the period's cases were classified, overrides
	// separately.
	Onsets domain.OnsetSummary
	// IndicatorCode and IndicatorRevision name the versioned definition this
	// was filed against, where one is configured.
	IndicatorCode     string
	IndicatorRevision int
}
