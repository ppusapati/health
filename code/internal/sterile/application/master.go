package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/sterile/domain"
)

// RegisterInstrument adds an instrument to the master (SRS-CSSD-001).
func (s *Service) RegisterInstrument(ctx context.Context,
	in domain.NewInstrumentInput) (domain.Instrument, error) {

	session, scope, err := s.authorize(ctx, PermConfigure)
	if err != nil {
		return domain.Instrument{}, err
	}
	now := s.clock.Now()

	instrument, err := domain.NewInstrument(
		s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return domain.Instrument{}, sterileError(err)
	}

	// The registration is the first row of the history, with no previous
	// status. Without it an instrument's history would start at its first
	// repair, and "moved into service on" would be unanswerable for
	// everything that never broke.
	arrival, err := domain.NewInstrumentEvent(s.ids.NewID(), instrument, "",
		"registered", session.SubjectID, now)
	if err != nil {
		return domain.Instrument{}, sterileError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.master.InsertInstrument(ctx, scope, instrument); err != nil {
			return err
		}
		if err := s.master.InsertInstrumentEvent(ctx, scope, arrival); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermConfigure,
			ResourceType: "sterile_instrument", ResourceID: instrument.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "instrument " + instrument.Code + " registered",
		}, now)
	})
	if err != nil {
		return domain.Instrument{}, err
	}
	return instrument, nil
}

// MoveInstrument changes an instrument's status (SRS-CSSD-012).
func (s *Service) MoveInstrument(ctx context.Context, instrumentID string,
	to domain.InstrumentStatus, note string) (domain.Instrument, error) {

	session, scope, err := s.authorize(ctx, PermConfigure)
	if err != nil {
		return domain.Instrument{}, err
	}
	now := s.clock.Now()

	var out domain.Instrument
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		instrument, err := s.master.Instrument(ctx, scope, instrumentID)
		if err != nil {
			return err
		}
		// Read before the move, because the row records what it left.
		from := instrument.Status
		if err := instrument.Move(to, note, now); err != nil {
			return sterileError(err)
		}
		if err := s.master.UpdateInstrument(
			ctx, scope, instrument, instrument.Version); err != nil {
			return sterileError(err)
		}
		out = instrument

		// In the same transaction as the move, so a status can never change
		// without the history recording it. A history with holes in it
		// answers the replacement question wrongly and says nothing about it.
		event, err := domain.NewInstrumentEvent(s.ids.NewID(), instrument, from,
			note, session.SubjectID, now)
		if err != nil {
			return sterileError(err)
		}
		if err := s.master.InsertInstrumentEvent(ctx, scope, event); err != nil {
			return err
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermConfigure,
			ResourceType: "sterile_instrument", ResourceID: instrument.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(to) + ": " + note,
		}, now)
	})
	if err != nil {
		return domain.Instrument{}, err
	}
	return out, nil
}

// Instrument reads one instrument.
func (s *Service) Instrument(ctx context.Context, instrumentID string) (
	domain.Instrument, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Instrument{}, err
	}
	return s.master.Instrument(ctx, scope, instrumentID)
}

// Instruments lists the master, optionally narrowed to one code.
func (s *Service) Instruments(ctx context.Context, code string, limit int32) (
	[]domain.Instrument, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.master.Instruments(ctx, scope, code, clampPageSize(limit))
}

// InstrumentsOutOfService is the lifecycle worklist (SRS-CSSD-012).
func (s *Service) InstrumentsOutOfService(ctx context.Context, limit int32) (
	[]domain.Instrument, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.master.OutOfService(ctx, scope, clampPageSize(limit))
}

// InstrumentHistory is one instrument's moves, most recent first
// (SRS-CSSD-012).
//
// The replacement question: how many times has this item been away, and for
// what. Behind the ordinary read permission, because it is one item in the
// department's own master and holds nothing about a patient.
func (s *Service) InstrumentHistory(ctx context.Context, instrumentID string,
	limit int32) ([]domain.InstrumentEvent, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.master.InstrumentHistory(
		ctx, scope, instrumentID, clampPageSize(limit))
}

// MovesByStatus is every move of one kind in a period (SRS-CSSD-012).
//
// The loss analysis: which instruments went missing this quarter and where
// they were when they did. An unbounded period is refused rather than
// silently reinterpreted, because "every instrument ever lost" and "the ones
// lost since April" are different reports and a caller who meant the second
// should not get the first.
func (s *Service) MovesByStatus(ctx context.Context,
	status domain.InstrumentStatus, from, to time.Time, limit int32) (
	[]domain.InstrumentEvent, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	if from.IsZero() || to.IsZero() || !from.Before(to) {
		return nil, rpcerr.Invalid("CSSD_INVALID",
			"a lifecycle report covers a period: give a start before an end")
	}
	return s.master.MovesByStatus(
		ctx, scope, status, from, to, clampPageSize(limit))
}

// DefineSet records a tray's packing list (SRS-CSSD-001).
//
// A set that already has a current version is revised rather than replaced:
// the earlier list is what earlier packs were checked against, and overwriting
// it makes every historical pack unauditable.
func (s *Service) DefineSet(ctx context.Context, in domain.NewTraySetInput) (
	domain.TraySet, error) {

	session, scope, err := s.authorize(ctx, PermConfigure)
	if err != nil {
		return domain.TraySet{}, err
	}
	now := s.clock.Now()

	var out domain.TraySet
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		current, exists, err := s.master.CurrentSet(ctx, scope, in.Code)
		if err != nil {
			return err
		}

		if !exists {
			first, err := domain.NewTraySet(
				s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
			if err != nil {
				return sterileError(err)
			}
			if err := s.master.InsertSet(ctx, scope, first); err != nil {
				return err
			}
			out = first
		} else {
			next, err := current.Revise(
				s.ids.NewID(), in, session.SubjectID, now)
			if err != nil {
				return sterileError(err)
			}
			if err := s.master.Supersede(
				ctx, scope, next, current.ID, now); err != nil {
				return sterileError(err)
			}
			out = next
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermConfigure,
			ResourceType: "sterile_set", ResourceID: out.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: "set " + out.Code + " version " + itoa(out.Version) +
				", " + itoa(len(out.Items)) + " item(s)",
		}, now)
	})
	if err != nil {
		return domain.TraySet{}, err
	}
	return out, nil
}

// Set reads one version of a tray.
func (s *Service) Set(ctx context.Context, setID string) (domain.TraySet, error) {
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.TraySet{}, err
	}
	return s.master.Set(ctx, scope, setID)
}

// CurrentSet reads the version in force for a code.
func (s *Service) CurrentSet(ctx context.Context, code string) (
	domain.TraySet, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.TraySet{}, err
	}
	set, ok, err := s.master.CurrentSet(ctx, scope, code)
	if err != nil {
		return domain.TraySet{}, err
	}
	if !ok {
		return domain.TraySet{}, rpcerr.NotFound("CSSD_NOT_FOUND",
			"no such set")
	}
	return set, nil
}

// SetVersions reads a set's history, which is how a pack assembled last month
// is read against the list as it was then (SRS-CSSD-001).
func (s *Service) SetVersions(ctx context.Context, code string) (
	[]domain.TraySet, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.master.SetVersions(ctx, scope, code)
}

// Sets lists the current version of every tray.
func (s *Service) Sets(ctx context.Context, limit int32) (
	[]domain.TraySet, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.master.Sets(ctx, scope, clampPageSize(limit))
}
