package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/biomedical/domain"
	"github.com/ppusapati/health/code/internal/biomedical/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// RaiseNotice records a recall or field safety notice and matches it against
// the register (SRS-BIO-008).
//
// Matching and holding happen in the same transaction as the notice. A recall
// recorded now and matched by a sweep later is a window in which the hospital
// has been told and the equipment is still in use, and that window is exactly
// what the requirement exists to close.
func (s *Service) RaiseNotice(ctx context.Context, in domain.NewNoticeInput) (
	domain.SafetyNotice, []domain.NoticeTask, error) {

	session, scope, err := s.authorize(ctx, PermNotice)
	if err != nil {
		return domain.SafetyNotice{}, nil, err
	}
	now := s.clock.Now()

	notice, err := domain.NewSafetyNotice(s.ids.NewID(), session.TenantID, in,
		session.SubjectID, now)
	if err != nil {
		return domain.SafetyNotice{}, nil, biomedicalError(err)
	}

	var tasks []domain.NoticeTask
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.notices.InsertNotice(ctx, scope, notice); err != nil {
			return err
		}

		// Narrowed in the database before the domain matches, so a notice
		// naming a common make does not read the register into memory. The
		// domain still decides: the UDI, the model and the serial range are
		// its rules, not the query's.
		candidates, err := s.assets.ByMake(ctx, scope, notice.Make,
			notice.AffectedUDI, recallCandidates)
		if err != nil {
			return err
		}
		tasks = notice.Match(candidates, s.ids.NewID)
		if len(tasks) > 0 {
			if err := s.notices.InsertTasks(ctx, scope, tasks); err != nil {
				return err
			}
		}

		held := 0
		if notice.HoldAffected {
			byID := make(map[string]domain.Asset, len(candidates))
			for _, asset := range candidates {
				byID[asset.ID] = asset
			}
			rooms := map[string]bool{}
			for _, task := range tasks {
				asset, known := byID[task.AssetID]
				if !known || asset.SafetyHold {
					continue
				}
				if err := asset.Hold(notice.Reference + ": " +
					notice.RequiredAction); err != nil {
					return err
				}
				if err := s.assets.UpdateAsset(ctx, scope, asset,
					asset.Version); err != nil {
					return err
				}
				held++
				rooms[asset.LocationID] = true
			}
			for room := range rooms {
				if err := s.publishCapabilities(ctx, session, scope, room,
					now); err != nil {
					return err
				}
			}
		}

		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "biomedical.notice.raise", ResourceType: "biomedical_notice",
			ResourceID: notice.ID, Outcome: audit.OutcomeSuccess,
			Reason: notice.Reference + ": " + itoa(len(tasks)) +
				" asset(s) matched, " + itoa(held) + " held",
		}, now); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventNoticeRaised,
			"biomedical_notice", notice.ID, map[string]any{
				"notice_id": notice.ID,
				"reference": notice.Reference,
				"kind":      string(notice.Kind),
				"issuer":    notice.Issuer,
				"matched":   len(tasks),
				"held":      held,
			}, now); err != nil {
			return err
		}

		// A recall has to reach the wards holding the equipment. One that
		// only appeared on a screen nobody opened is a recall that did not
		// happen.
		if s.escalations != nil && len(tasks) > 0 {
			_, err := s.escalations.Raise(ctx, scope, ports.Notice{
				Kind: EscalationRecall,
				// The notice reference, never a patient: nothing here is
				// about one, and this travels further than the record does.
				Subject: notice.Reference,
				Summary: notice.Summary + " — " + itoa(len(tasks)) +
					" asset(s) affected: " + notice.RequiredAction,
			}, now)
			if err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		return domain.SafetyNotice{}, nil, biomedicalError(err)
	}
	return notice, tasks, nil
}

// Notice reads one safety notice.
func (s *Service) Notice(ctx context.Context, id string) (
	domain.SafetyNotice, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.SafetyNotice{}, err
	}
	notice, err := s.notices.Notice(ctx, scope, id)
	if err != nil {
		return domain.SafetyNotice{}, biomedicalError(err)
	}
	return notice, nil
}

// Notices lists safety notices.
func (s *Service) Notices(ctx context.Context, openOnly bool, pageSize int32) (
	[]domain.SafetyNotice, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	notices, err := s.notices.Notices(ctx, scope, openOnly,
		clampPageSize(pageSize))
	if err != nil {
		return nil, biomedicalError(err)
	}
	return notices, nil
}

// NoticeTasks lists the per-asset work a notice produced.
func (s *Service) NoticeTasks(ctx context.Context, noticeID string) (
	[]domain.NoticeTask, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	tasks, err := s.notices.Tasks(ctx, scope, noticeID)
	if err != nil {
		return nil, biomedicalError(err)
	}
	return tasks, nil
}

// AdvanceTaskInput moves one asset's recall work forward.
type AdvanceTaskInput struct {
	TaskID string
	To     domain.TaskState
	Note   string
	// ReleaseHold lifts the asset's safety hold as part of the step. Only
	// meaningful once the work is done, and the domain's state rules decide
	// whether it is — this only says the caller wants it.
	ReleaseHold bool
}

// AdvanceTask records what was done to one asset under a notice
// (SRS-BIO-008).
func (s *Service) AdvanceTask(ctx context.Context, in AdvanceTaskInput) (
	domain.NoticeTask, error) {

	session, scope, err := s.authorize(ctx, PermNotice)
	if err != nil {
		return domain.NoticeTask{}, err
	}
	now := s.clock.Now()

	var updated domain.NoticeTask
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		task, err := s.notices.Task(ctx, scope, in.TaskID)
		if err != nil {
			return err
		}
		if err := task.Advance(in.To, in.Note, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.notices.UpdateTask(ctx, scope, task); err != nil {
			return err
		}
		updated = task

		// The hold is lifted only once nothing else holds the asset. A
		// machine covered by two recalls that came back from the first one is
		// still recalled.
		if in.ReleaseHold && task.State.Complete() {
			asset, err := s.assets.Asset(ctx, scope, task.AssetID)
			if err != nil {
				return err
			}
			if asset.SafetyHold {
				others, err := s.notices.TasksForAsset(ctx, scope, task.AssetID)
				if err != nil {
					return err
				}
				outstanding := false
				for _, other := range others {
					if other.ID != task.ID && !other.State.Complete() {
						outstanding = true
						break
					}
				}
				if !outstanding {
					if err := asset.Clear(); err != nil {
						return err
					}
					if err := s.assets.UpdateAsset(ctx, scope, asset,
						asset.Version); err != nil {
						return err
					}
					if err := s.publishCapabilities(ctx, session, scope,
						asset.LocationID, now); err != nil {
						return err
					}
				}
			}
		}

		return s.appendAudit(ctx, session, audit.Record{
			Action:       "biomedical.notice.task_advance",
			ResourceType: "biomedical_notice_task", ResourceID: task.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(task.State) + ": " + in.Note,
		}, now)
	})
	if err != nil {
		return domain.NoticeTask{}, biomedicalError(err)
	}
	return updated, nil
}

// TrackNotice reports how far a recall has got (SRS-BIO-008).
func (s *Service) TrackNotice(ctx context.Context, noticeID string) (
	domain.Progress, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Progress{}, err
	}
	notice, err := s.notices.Notice(ctx, scope, noticeID)
	if err != nil {
		return domain.Progress{}, biomedicalError(err)
	}
	tasks, err := s.notices.Tasks(ctx, scope, noticeID)
	if err != nil {
		return domain.Progress{}, biomedicalError(err)
	}
	return domain.Track(notice, tasks, s.clock.Now()), nil
}

// CloseNotice signs a recall off (SRS-BIO-008).
//
// Refused while any asset still has work outstanding: a notice closed over
// unfinished work is a hospital that believes a recall was completed when it
// was not.
func (s *Service) CloseNotice(ctx context.Context, noticeID, note string,
	expectedVersion int64) (domain.SafetyNotice, error) {

	session, scope, err := s.authorize(ctx, PermNotice)
	if err != nil {
		return domain.SafetyNotice{}, err
	}
	now := s.clock.Now()

	var updated domain.SafetyNotice
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		notice, err := s.notices.Notice(ctx, scope, noticeID)
		if err != nil {
			return err
		}
		tasks, err := s.notices.Tasks(ctx, scope, noticeID)
		if err != nil {
			return err
		}
		progress := domain.Track(notice, tasks, now)
		if err := notice.CloseNotice(progress, session.SubjectID, note,
			now); err != nil {
			return err
		}
		if err := s.notices.CloseNotice(ctx, scope, notice,
			expectedVersion); err != nil {
			return err
		}
		notice.Version = expectedVersion + 1
		updated = notice

		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "biomedical.notice.close", ResourceType: "biomedical_notice",
			ResourceID: notice.ID, Outcome: audit.OutcomeSuccess, Reason: note,
		}, now); err != nil {
			return err
		}
		return s.appendEvent(ctx, session, EventNoticeClosed,
			"biomedical_notice", notice.ID, map[string]any{
				"notice_id": notice.ID,
				"reference": notice.Reference,
				"completed": progress.Complete,
				"total":     progress.Total,
			}, now)
	})
	if err != nil {
		return domain.SafetyNotice{}, biomedicalError(err)
	}
	return updated, nil
}
