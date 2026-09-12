package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/scheduling/domain"
	"github.com/ppusapati/health/code/internal/scheduling/ports"
)

// Availability: resources, rosters, exceptions and slot search
// (SRS-SCH-001, SRS-SCH-002, SRS-SCH-003).

// DefineResourceInput describes something patients can be booked with.
type DefineResourceInput struct {
	FacilityID  string
	OrgUnitID   string
	Type        domain.ResourceType
	SubjectID   string
	DisplayName string
	TimeZone    string
}

// DefineResource registers a bookable resource.
func (s *Service) DefineResource(ctx context.Context, in DefineResourceInput) (domain.Resource, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.Resource{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermScheduleConfigure,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermScheduleConfigure, "resource", "", decision.Reason)
		return domain.Resource{}, rpcerr.PermissionDenied("SCH_CONFIGURE_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var created domain.Resource
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// A resource in a decommissioned building is one nobody can attend.
		active, err := s.calendar.Active(ctx, scope, in.FacilityID)
		if err != nil {
			return err
		}
		if !active {
			return scheduleError(domain.ErrNotBookable{
				Kind: "facility", ID: in.FacilityID, Why: "the facility is not active",
			})
		}

		resource, err := domain.NewResource(s.ids.NewID(), scope.TenantID(), in.FacilityID,
			in.OrgUnitID, in.Type, in.SubjectID, in.DisplayName, in.TimeZone, now)
		if err != nil {
			return scheduleError(err)
		}
		if err := s.resources.Insert(ctx, scope, resource); err != nil {
			return err
		}

		created = resource
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermScheduleConfigure,
			ResourceType: "resource", ResourceID: resource.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(resource.Type) + ": " + resource.DisplayName,
		}, now)
	})
	if err != nil {
		return domain.Resource{}, err
	}
	return created, nil
}

// SetResourceStatus takes a resource in or out of service (SRS-SCH-014).
//
// Existing appointments are deliberately left alone. A clinician who leaves has
// still seen the patients they saw, and a future appointment against them is a
// problem for a human to resolve — cancelling a hundred bookings automatically
// is how a hundred patients are told not to come without anybody deciding that.
func (s *Service) SetResourceStatus(ctx context.Context, resourceID string,
	status domain.ResourceStatus) error {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermScheduleConfigure,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermScheduleConfigure, "resource", resourceID, decision.Reason)
		return rpcerr.PermissionDenied("SCH_CONFIGURE_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.resources.SetStatus(ctx, scope, resourceID, status, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermScheduleConfigure,
			ResourceType: "resource", ResourceID: resourceID,
			Outcome: audit.OutcomeSuccess, Reason: "status: " + string(status),
		}, now)
	})
}

// DefineScheduleInput is one recurring availability rule (SRS-SCH-001).
type DefineScheduleInput struct {
	ResourceID  string
	VisitType   domain.VisitType
	VisitMode   domain.VisitMode
	Weekday     time.Weekday
	StartMinute int
	EndMinute   int
	SlotMinutes int
	Capacity    int
	From        time.Time
	Until       time.Time
}

// DefineSchedule publishes an availability rule.
func (s *Service) DefineSchedule(ctx context.Context, in DefineScheduleInput) (domain.Schedule, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.Schedule{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermScheduleConfigure,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermScheduleConfigure, "schedule", "", decision.Reason)
		return domain.Schedule{}, rpcerr.PermissionDenied("SCH_CONFIGURE_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var created domain.Schedule
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		resource, err := s.resources.Get(ctx, scope, in.ResourceID)
		if err != nil {
			return err
		}
		if !resource.Bookable() {
			// A roster on a resource out of service generates slots nobody can
			// attend, and the first anybody knows is a patient at a locked door.
			return scheduleError(domain.ErrNotBookable{
				Kind: "resource", ID: resource.ID, Why: "the resource is not active",
			})
		}

		schedule, err := domain.NewSchedule(s.ids.NewID(), scope.TenantID(), resource.ID,
			resource.FacilityID, in.VisitType, in.VisitMode, in.Weekday,
			in.StartMinute, in.EndMinute, in.SlotMinutes, in.Capacity,
			in.From, in.Until, now)
		if err != nil {
			return scheduleError(err)
		}
		if err := s.schedules.InsertSchedule(ctx, scope, schedule); err != nil {
			return err
		}

		created = schedule
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermScheduleConfigure,
			ResourceType: "schedule", ResourceID: schedule.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "roster for " + resource.DisplayName,
		}, now)
	})
	if err != nil {
		return domain.Schedule{}, err
	}
	return created, nil
}

// BlockPeriodInput removes capacity (SRS-SCH-002).
type BlockPeriodInput struct {
	ResourceID string
	Kind       domain.ExceptionKind
	StartsAt   time.Time
	EndsAt     time.Time
	Reason     string
	// Overridable permits booking into the period by somebody holding the
	// override permission. Annual leave is not overridable; a provisional
	// theatre block often is.
	Overridable bool
}

// BlockPeriod records leave, a meeting, a theatre list or a procedure.
func (s *Service) BlockPeriod(ctx context.Context, in BlockPeriodInput) (domain.Exception, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.Exception{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermScheduleConfigure,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermScheduleConfigure, "exception", in.ResourceID, decision.Reason)
		return domain.Exception{}, rpcerr.PermissionDenied("SCH_CONFIGURE_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var created domain.Exception
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if _, err := s.resources.Get(ctx, scope, in.ResourceID); err != nil {
			return err
		}

		exception, err := domain.NewException(s.ids.NewID(), scope.TenantID(), in.ResourceID,
			in.Kind, in.StartsAt, in.EndsAt, in.Reason, in.Overridable,
			session.SubjectID, now)
		if err != nil {
			return scheduleError(err)
		}
		if err := s.schedules.InsertException(ctx, scope, exception); err != nil {
			return err
		}

		created = exception
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermScheduleConfigure,
			ResourceType: "exception", ResourceID: exception.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(exception.Kind) + ": " + exception.Reason,
		}, now)
	})
	if err != nil {
		return domain.Exception{}, err
	}
	return created, nil
}

// UnblockPeriod removes an exception.
func (s *Service) UnblockPeriod(ctx context.Context, exceptionID string) error {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermScheduleConfigure,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermScheduleConfigure, "exception", exceptionID, decision.Reason)
		return rpcerr.PermissionDenied("SCH_CONFIGURE_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.schedules.DeleteException(ctx, scope, exceptionID); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermScheduleConfigure,
			ResourceType: "exception", ResourceID: exceptionID,
			Outcome: audit.OutcomeSuccess, Reason: "unblocked",
		}, now)
	})
}

// SearchSlotsInput narrows a slot search (SRS-SCH-003).
type SearchSlotsInput struct {
	FacilityID string
	// OrgUnitID is the specialty or department, which is how a patient who does
	// not know a clinician's name searches.
	OrgUnitID  string
	ResourceID string
	VisitType  domain.VisitType
	VisitMode  domain.VisitMode
	// From and Until are local dates; Until is exclusive.
	From     time.Time
	Until    time.Time
	PageSize int32
}

// SearchSlotsResult is one page of bookable capacity.
type SearchSlotsResult struct {
	Slots []domain.Slot
	// Truncated reports that the page limit cut the result, so a UI can say so
	// rather than implying the clinic has nothing later.
	Truncated bool
}

// SearchSlots returns bookable capacity over a date range.
//
// Generated from the roster on every call, then reduced by exceptions, facility
// closures and capacity already consumed. Nothing is cached: a cached diary
// goes stale the moment a roster changes, and the stale entries are
// indistinguishable from the good ones.
func (s *Service) SearchSlots(ctx context.Context, in SearchSlotsInput) (SearchSlotsResult, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return SearchSlotsResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermScheduleRead,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermScheduleRead, "slot", "", decision.Reason)
		return SearchSlotsResult{}, rpcerr.PermissionDenied("SCH_SEARCH_DENIED", decision.Reason)
	}

	if in.From.IsZero() || in.Until.IsZero() {
		return SearchSlotsResult{}, rpcerr.Invalid("SCH_RANGE_REQUIRED",
			"a slot search needs a date range")
	}
	if in.FacilityID == "" && in.OrgUnitID == "" && in.ResourceID == "" {
		// An unfiltered search expands every diary in the tenant. That is a
		// capacity report, not a booking screen, and it has no legitimate
		// caller on this endpoint.
		return SearchSlotsResult{}, rpcerr.Invalid("SCH_SEARCH_UNFILTERED",
			"a slot search needs at least one of facility, department or resource")
	}

	scope := session.TenantScope()
	pageSize := clampPageSize(in.PageSize)
	canOverride := session.HasPermission(PermScheduleOverride)

	var result SearchSlotsResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		resources, err := s.resources.ForSearch(ctx, scope, ports.ResourceQuery{
			FacilityID: in.FacilityID, OrgUnitID: in.OrgUnitID,
			ResourceID: in.ResourceID, Limit: maxSearchResources,
		})
		if err != nil {
			return err
		}
		if len(resources) == 0 {
			return nil
		}

		ids := make([]string, 0, len(resources))
		for _, r := range resources {
			ids = append(ids, r.ID)
		}

		schedules, err := s.schedules.SchedulesFor(ctx, scope, ids, in.VisitType, in.From, in.Until)
		if err != nil {
			return err
		}
		exceptions, err := s.schedules.ExceptionsFor(ctx, scope, ids, in.From, in.Until)
		if err != nil {
			return err
		}
		booked, err := s.slots.BookedCounts(ctx, scope, ids, in.From, in.Until)
		if err != nil {
			return err
		}

		// Closures are read per facility rather than per resource: several
		// clinicians share a building, and asking once per diary would be the
		// same answer fetched twenty times.
		closuresByFacility := map[string]map[string]bool{}

		byResource := map[string][]domain.Schedule{}
		for _, schedule := range schedules {
			byResource[schedule.ResourceID] = append(byResource[schedule.ResourceID], schedule)
		}

		var all []domain.Slot
		for _, resource := range resources {
			rules := byResource[resource.ID]
			if len(rules) == 0 {
				continue
			}

			closures, cached := closuresByFacility[resource.FacilityID]
			if !cached {
				closures, err = s.calendar.ClosedDates(ctx, scope, resource.FacilityID,
					in.From, in.Until)
				if err != nil {
					return err
				}
				closuresByFacility[resource.FacilityID] = closures
			}

			generated, err := domain.GenerateSlots(resource, rules, exceptions,
				closures, in.From, in.Until)
			if err != nil {
				return scheduleError(err)
			}
			all = append(all, domain.ApplyBookings(generated, booked)...)
		}

		available := domain.Available(all, canOverride)
		if in.VisitMode != "" {
			// Filtered after generation rather than in the query, so a mode
			// filter cannot accidentally hide a blocked slot an overrider
			// should see.
			filtered := available[:0]
			for _, slot := range available {
				if slot.VisitMode == in.VisitMode {
					filtered = append(filtered, slot)
				}
			}
			available = filtered
		}

		if int32(len(available)) > pageSize {
			available = available[:pageSize]
			result.Truncated = true
		}
		result.Slots = available

		// The search is audited with a count, never the patient it is for: a
		// slot search is not a read of anybody's record, and recording who was
		// searched for would make the audit trail one.
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermScheduleRead,
			ResourceType: "slot", ResourceID: in.FacilityID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "slot search",
		}, s.clock.Now())
	})
	if err != nil {
		return SearchSlotsResult{}, err
	}
	return result, nil
}
