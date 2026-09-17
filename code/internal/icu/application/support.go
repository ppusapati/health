package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/icu/domain"
	"github.com/ppusapati/health/code/internal/icu/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Organ support (SRS-ICU-011), ventilation (SRS-ICU-004), infusions
// (SRS-ICU-005) and invasive devices (SRS-ICU-006).

// StartSupportInput begins organ support.
type StartSupportInput struct {
	EpisodeID string
	Kind      domain.SupportKind
	Label     string
	Modality  string
	StartedAt time.Time
}

// StartSupport records the beginning of organ support (SRS-ICU-011).
func (s *Service) StartSupport(ctx context.Context, in StartSupportInput) (
	domain.Support, error) {

	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return domain.Support{}, err
	}

	now := s.clock.Now()
	var out domain.Support

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.openEpisode(ctx, scope, in.EpisodeID)
		if err != nil {
			return err
		}

		support, err := domain.StartSupport(s.ids.NewID(), scope.TenantID(),
			domain.NewSupportInput{
				EpisodeID: episode.ID, Kind: in.Kind, Label: in.Label,
				Modality: in.Modality, StartedAt: in.StartedAt,
			}, session.SubjectID, now)
		if err != nil {
			return icuError(err)
		}
		if err := s.support.InsertSupport(ctx, scope, support); err != nil {
			return err
		}

		if err := s.appendEvent(ctx, session, EventSupportStarted,
			"icu_support", support.ID, map[string]any{
				"support_id": support.ID,
				"episode_id": episode.ID,
				"patient_id": episode.PatientID,
				"unit_id":    episode.UnitID,
				"kind":       string(support.Kind),
				"started_at": support.StartedAt.Format(time.RFC3339),
			}, now); err != nil {
			return err
		}

		out = support
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIcuWrite,
			ResourceType: "icu_support", ResourceID: support.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(support.Kind) + " started",
		}, now)
	})
	if err != nil {
		return domain.Support{}, err
	}
	return out, nil
}

// StopSupportInput ends organ support.
type StopSupportInput struct {
	SupportID string
	Note      string
	StoppedAt time.Time
}

// StopSupport ends a run of organ support.
func (s *Service) StopSupport(ctx context.Context, in StopSupportInput) error {
	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	stoppedAt := in.StoppedAt
	if stoppedAt.IsZero() {
		stoppedAt = now
	}

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		stopped, err := s.support.StopSupport(ctx, scope, in.SupportID,
			session.SubjectID, in.Note, stoppedAt)
		if err != nil {
			return err
		}
		if !stopped {
			return rpcerr.FailedPrecondition("ICU_SUPPORT_ALREADY_STOPPED",
				"this support was already stopped, or there is no such run")
		}

		if err := s.appendEvent(ctx, session, EventSupportStopped,
			"icu_support", in.SupportID, map[string]any{
				"support_id": in.SupportID,
				"stopped_at": stoppedAt.Format(time.RFC3339),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIcuWrite,
			ResourceType: "icu_support", ResourceID: in.SupportID,
			Outcome: audit.OutcomeSuccess, Reason: "organ support stopped",
		}, now)
	})
}

// VentSettingInput records ventilator settings.
type VentSettingInput struct {
	EpisodeID    string
	SupportID    string
	Mode         string
	Parameters   map[string]float64
	Measured     map[string]float64
	Units        map[string]string
	DeviceID     string
	EffectiveAt  time.Time
	ChangeReason string
}

// RecordVentSetting records ventilator settings (SRS-ICU-004).
func (s *Service) RecordVentSetting(ctx context.Context, in VentSettingInput) (
	domain.VentSetting, error) {

	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return domain.VentSetting{}, err
	}

	now := s.clock.Now()
	var out domain.VentSetting

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.openEpisode(ctx, scope, in.EpisodeID)
		if err != nil {
			return err
		}

		recordedBy := session.SubjectID
		if in.DeviceID != "" && len(in.Measured) > 0 && len(in.Parameters) == 0 {
			// A pure device report — measured values and no settings anybody
			// typed — is attributed to the ventilator rather than to the
			// service account that delivered it.
			recordedBy = ""
		}

		setting, err := domain.RecordVentSetting(s.ids.NewID(), scope.TenantID(),
			domain.NewVentSettingInput{
				EpisodeID: episode.ID, SupportID: in.SupportID, Mode: in.Mode,
				Parameters: in.Parameters, Measured: in.Measured, Units: in.Units,
				DeviceID: in.DeviceID, EffectiveAt: in.EffectiveAt,
				ChangeReason: in.ChangeReason,
			}, recordedBy, now)
		if err != nil {
			return icuError(err)
		}
		if err := s.support.InsertVentSetting(ctx, scope, setting); err != nil {
			return err
		}
		out = setting
		return nil
	})
	if err != nil {
		return domain.VentSetting{}, err
	}
	return out, nil
}

// VentTimeline reads the ventilator history (SRS-ICU-004).
func (s *Service) VentTimeline(ctx context.Context, episodeID string) (
	domain.VentTimeline, error) {

	_, scope, err := s.authorize(ctx, PermIcuRead)
	if err != nil {
		return nil, err
	}
	timeline, err := s.support.VentSettings(ctx, scope, episodeID)
	if err != nil {
		return nil, err
	}
	return timeline.Ordered(), nil
}

// StartInfusionInput begins a continuous infusion.
type StartInfusionInput struct {
	EpisodeID           string
	PrescriptionID      string
	DrugCode            string
	DrugDisplay         string
	ConcentrationAmount float64
	ConcentrationUnit   string
	ConcentrationVolume float64
	DoseUnit            string
	WeightKg            float64
	StartedAt           time.Time
}

// StartInfusion begins a continuous infusion (SRS-ICU-005).
func (s *Service) StartInfusion(ctx context.Context, in StartInfusionInput) (
	domain.Infusion, error) {

	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return domain.Infusion{}, err
	}

	now := s.clock.Now()
	var out domain.Infusion

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.openEpisode(ctx, scope, in.EpisodeID)
		if err != nil {
			return err
		}

		infusion, err := domain.StartInfusion(s.ids.NewID(), scope.TenantID(),
			domain.NewInfusionInput{
				EpisodeID: episode.ID, PrescriptionID: in.PrescriptionID,
				DrugCode: in.DrugCode, DrugDisplay: in.DrugDisplay,
				ConcentrationAmount: in.ConcentrationAmount,
				ConcentrationUnit:   in.ConcentrationUnit,
				ConcentrationVolume: in.ConcentrationVolume,
				DoseUnit:            in.DoseUnit, WeightKg: in.WeightKg,
				StartedAt: in.StartedAt,
			}, session.SubjectID, now)
		if err != nil {
			return icuError(err)
		}
		if err := s.support.InsertInfusion(ctx, scope, infusion); err != nil {
			return err
		}

		out = infusion
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIcuWrite,
			ResourceType: "icu_infusion", ResourceID: infusion.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "infusion started: " + infusion.DrugCode,
		}, now)
	})
	if err != nil {
		return domain.Infusion{}, err
	}
	return out, nil
}

// TitrateInput is one rate change.
type TitrateInput struct {
	InfusionID  string
	Rate        float64
	RateUnit    string
	Dose        float64
	EffectiveAt time.Time
	DeviceID    string
	Reason      string
}

// Titrate records a rate change (SRS-ICU-005).
func (s *Service) Titrate(ctx context.Context, in TitrateInput) (domain.Titration, error) {
	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return domain.Titration{}, err
	}

	now := s.clock.Now()
	var out domain.Titration

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		infusion, err := s.support.GetInfusion(ctx, scope, in.InfusionID)
		if err != nil {
			return err
		}

		recordedBy := session.SubjectID
		if in.DeviceID != "" {
			// A pump reporting its own rate change is attributed to the pump.
			recordedBy = ""
		}

		id := s.ids.NewID()
		if err := infusion.Titrate(id, domain.NewTitrationInput{
			Rate: in.Rate, RateUnit: in.RateUnit, Dose: in.Dose,
			EffectiveAt: in.EffectiveAt, DeviceID: in.DeviceID, Reason: in.Reason,
		}, recordedBy, now); err != nil {
			return icuError(err)
		}

		titration := infusion.Titrations[len(infusion.Titrations)-1]
		if err := s.support.InsertTitration(ctx, scope, infusion.ID, titration); err != nil {
			return err
		}
		out = titration
		return nil
	})
	if err != nil {
		return domain.Titration{}, err
	}
	return out, nil
}

// StopInfusion takes an infusion down.
func (s *Service) StopInfusion(ctx context.Context, infusionID string) error {
	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		stopped, err := s.support.StopInfusion(ctx, scope, infusionID,
			session.SubjectID, now)
		if err != nil {
			return err
		}
		if !stopped {
			return rpcerr.FailedPrecondition("ICU_INFUSION_ALREADY_STOPPED",
				"this infusion was already stopped, or there is no such infusion")
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIcuWrite,
			ResourceType: "icu_infusion", ResourceID: infusionID,
			Outcome: audit.OutcomeSuccess, Reason: "infusion stopped",
		}, now)
	})
}

// Infusions reads an episode's infusions with their dose timelines.
func (s *Service) Infusions(ctx context.Context, episodeID string) (
	[]domain.Infusion, error) {

	_, scope, err := s.authorize(ctx, PermIcuRead)
	if err != nil {
		return nil, err
	}
	return s.support.Infusions(ctx, scope, episodeID)
}

// InsertDeviceInput puts a line, tube or drain in.
type InsertDeviceInput struct {
	EpisodeID   string
	Kind        string
	Site        string
	Lumens      int
	InsertedAt  time.Time
	ReviewEvery time.Duration
}

// InsertDevice records a line, tube or drain going in (SRS-ICU-006).
func (s *Service) InsertDevice(ctx context.Context, in InsertDeviceInput) (
	domain.InvasiveDevice, error) {

	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return domain.InvasiveDevice{}, err
	}

	now := s.clock.Now()
	var out domain.InvasiveDevice

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.openEpisode(ctx, scope, in.EpisodeID)
		if err != nil {
			return err
		}

		device, err := domain.InsertDevice(s.ids.NewID(), scope.TenantID(),
			domain.NewDeviceInput{
				EpisodeID: episode.ID, Kind: in.Kind, Site: in.Site,
				Lumens: in.Lumens, InsertedAt: in.InsertedAt,
				ReviewEvery: in.ReviewEvery,
			}, session.SubjectID, now)
		if err != nil {
			return icuError(err)
		}
		if err := s.support.InsertDevice(ctx, scope, device); err != nil {
			return err
		}

		// Infection prevention counts device days from this (SRS-IPC), and it
		// is a different context: the event is how it hears, rather than by
		// reading the icu schema.
		if err := s.appendEvent(ctx, session, EventDeviceInserted,
			"icu_device", device.ID, map[string]any{
				"device_id":   device.ID,
				"episode_id":  episode.ID,
				"patient_id":  episode.PatientID,
				"facility_id": episode.FacilityID,
				"unit_id":     episode.UnitID,
				"kind":        device.Kind,
				"inserted_at": device.InsertedAt.Format(time.RFC3339),
			}, now); err != nil {
			return err
		}

		out = device
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIcuWrite,
			ResourceType: "icu_device", ResourceID: device.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  device.Kind + " inserted at " + device.Site,
		}, now)
	})
	if err != nil {
		return domain.InvasiveDevice{}, err
	}
	return out, nil
}

// RemoveDeviceInput takes a device out.
type RemoveDeviceInput struct {
	DeviceID  string
	Reason    string
	RemovedAt time.Time
}

// RemoveDevice takes a line, tube or drain out (SRS-ICU-006).
func (s *Service) RemoveDevice(ctx context.Context, in RemoveDeviceInput) error {
	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	removedAt := in.RemovedAt
	if removedAt.IsZero() {
		removedAt = now
	}

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		removed, err := s.support.RemoveDevice(ctx, scope, in.DeviceID,
			session.SubjectID, in.Reason, removedAt)
		if err != nil {
			return err
		}
		if !removed {
			return rpcerr.FailedPrecondition("ICU_DEVICE_ALREADY_OUT",
				"this device is already out, or there is no such device")
		}

		if err := s.appendEvent(ctx, session, EventDeviceRemoved,
			"icu_device", in.DeviceID, map[string]any{
				"device_id":  in.DeviceID,
				"removed_at": removedAt.Format(time.RFC3339),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIcuWrite,
			ResourceType: "icu_device", ResourceID: in.DeviceID,
			Outcome: audit.OutcomeSuccess, Reason: "device removed: " + in.Reason,
		}, now)
	})
}

// ReviewDevice records that somebody asked whether a device can come out
// (SRS-ICU-006).
func (s *Service) ReviewDevice(ctx context.Context, deviceID string) error {
	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		reviewed, err := s.support.ReviewDevice(ctx, scope, deviceID,
			session.SubjectID, now)
		if err != nil {
			return err
		}
		if !reviewed {
			return rpcerr.FailedPrecondition("ICU_DEVICE_NOT_IN",
				"this device is already out, or there is no such device")
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIcuWrite,
			ResourceType: "icu_device", ResourceID: deviceID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "device reviewed; still required",
		}, now)
	})
}

// Devices reads an episode's lines, tubes and drains.
func (s *Service) Devices(ctx context.Context, episodeID string) (
	[]domain.InvasiveDevice, error) {

	_, scope, err := s.authorize(ctx, PermIcuRead)
	if err != nil {
		return nil, err
	}
	return s.support.Devices(ctx, scope, episodeID)
}

// Support reads an episode's organ support.
func (s *Service) Support(ctx context.Context, episodeID string) ([]domain.Support, error) {
	_, scope, err := s.authorize(ctx, PermIcuRead)
	if err != nil {
		return nil, err
	}
	return s.support.Support(ctx, scope, episodeID)
}

// escalate carries an operational condition to somebody who can act on it.
//
// Advisory and operational only, which is SRS-ICU-013's constraint: this
// reaches an escalation inbox and a human being, never a bedside device.
func (s *Service) escalate(ctx context.Context, scope authctx.TenantScope,
	episode domain.Episode, kind, summary string, at time.Time) (string, error) {

	if s.escalations == nil {
		return "", nil
	}
	return s.escalations.RaiseAdvisory(ctx, scope, ports.AdvisoryNotice{
		EpisodeID: episode.ID, PatientID: episode.PatientID,
		FacilityID: episode.FacilityID, UnitID: episode.UnitID,
		BedID: episode.BedID, Kind: kind, Summary: summary, At: at,
	})
}
