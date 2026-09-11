package application

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Master-data use cases (SRS-PLT-005, 008, 010, 011).

// Master-data permissions.
const (
	PermUnitManage      = "organization.unit.manage"
	PermUnitRead        = "organization.unit.read"
	PermChangePropose   = "organization.master_data.propose"
	PermChangeApprove   = "organization.master_data.approve"
	PermEntitlementRead = "organization.entitlement.read"
	PermEntitlementSet  = "organization.entitlement.manage"
	PermNumberIssue     = "organization.number.issue"
	PermCalendarManage  = "organization.calendar.manage"
	PermLabelManage     = "organization.label.manage"
)

// Event types emitted when master data changes (SRS-PLT-010).
const (
	// EventMasterDataApproved is emitted once an approval is committed, and
	// only then. Downstream caches and search indexes rebuild from it, so
	// emitting on proposal would publish a change that may never happen.
	EventMasterDataApproved = "organization.master_data_approved"
	// EventOrgUnitCreated is emitted when a unit is created.
	EventOrgUnitCreated = "organization.org_unit_created"
)

// MasterDataPorts are the stores these use cases need.
//
// Grouped rather than threaded through NewService: the master-data use cases
// are a distinct slice of the organization context, and widening the common
// constructor for them would make every caller pass stores it does not use.
type MasterDataPorts struct {
	Units        ports.OrgUnitRepository
	Changes      ports.MasterDataChangeRepository
	Entitlements ports.EntitlementRepository
}

// CreateOrgUnitInput is the command payload for a new unit.
type CreateOrgUnitInput struct {
	FacilityID                  string
	Type                        domain.UnitType
	Code                        string
	DisplayName                 string
	ParentUnitID                string
	EffectiveFrom               time.Time
	EffectiveUntil              time.Time
	AcceptsActivityWhenInactive bool
}

// CreateOrgUnit creates a department, specialty, cost centre, service unit or
// care location (SRS-PLT-005).
func (s *Service) CreateOrgUnit(ctx context.Context, p MasterDataPorts, in CreateOrgUnitInput) (domain.OrgUnit, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.OrgUnit{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermUnitManage,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermUnitManage, "org_unit", in.Code, decision.Reason)
		return domain.OrgUnit{}, rpcerr.PermissionDenied("ORG_UNIT_CREATE_DENIED", decision.Reason)
	}

	now := s.clock.Now()
	unit, err := domain.NewOrgUnit(s.ids.NewID(), session.TenantID, in.FacilityID,
		in.Type, in.Code, in.DisplayName, in.ParentUnitID,
		in.EffectiveFrom, in.EffectiveUntil, in.AcceptsActivityWhenInactive, now)
	if errors.Is(err, domain.ErrInvalidOrgUnit) {
		return domain.OrgUnit{}, rpcerr.Invalid("ORG_UNIT_INVALID", err.Error())
	}
	if err != nil {
		return domain.OrgUnit{}, err
	}

	scope := session.TenantScope()
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := p.Units.InsertOrgUnit(ctx, scope, unit); err != nil {
			return err
		}
		payload, err := json.Marshal(map[string]any{
			"unit_id":        unit.ID,
			"unit_type":      string(unit.Type),
			"code":           unit.Code,
			"facility_id":    unit.FacilityID,
			"effective_from": unit.EffectiveFrom.Format(time.RFC3339),
		})
		if err != nil {
			return rpcerr.Internal("ORG_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, unit.TenantID, EventOrgUnitCreated,
			"org_unit", unit.ID, payload, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: unit.TenantID, Action: PermUnitManage,
			ResourceType: "org_unit", ResourceID: unit.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return domain.OrgUnit{}, err
	}
	return unit, nil
}

// AuthorizeUnitActivity decides whether a transaction may attach to a unit.
//
// The event time is a parameter rather than the clock: backdated documentation
// is routine in a hospital, and judging it against today would reject a note
// about a ward that closed last week (SRS-PLT-005).
func (s *Service) AuthorizeUnitActivity(ctx context.Context, p MasterDataPorts,
	unitID string, eventTime time.Time) error {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}
	unit, err := p.Units.GetOrgUnit(ctx, session.TenantScope(), unitID)
	if err != nil {
		return err
	}
	if err := unit.AuthorizeActivity(eventTime); err != nil {
		return rpcerr.FailedPrecondition("ORG_UNIT_NOT_ACCEPTING_ACTIVITY", err.Error())
	}
	return nil
}

// ProposeChangeInput is a master-data change awaiting approval.
type ProposeChangeInput struct {
	EntityType    string
	EntityID      string
	Proposed      json.RawMessage
	BaseVersion   int64
	EffectiveFrom time.Time
	Justification string
}

// ProposeMasterDataChange records a change for a second pair of eyes
// (SRS-PLT-008).
//
// It writes no event. Downstream caches must not learn about a change that may
// be rejected — SRS-PLT-010 is explicit that events are for *approved*
// changes, and a subscriber that acted on a proposal would have to be told to
// undo it.
func (s *Service) ProposeMasterDataChange(ctx context.Context, p MasterDataPorts,
	in ProposeChangeInput) (domain.MasterDataChange, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.MasterDataChange{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermChangePropose,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermChangePropose, in.EntityType, in.EntityID, decision.Reason)
		return domain.MasterDataChange{}, rpcerr.PermissionDenied("ORG_CHANGE_PROPOSE_DENIED", decision.Reason)
	}

	now := s.clock.Now()
	change, err := domain.NewMasterDataChange(s.ids.NewID(), session.TenantID,
		in.EntityType, in.EntityID, in.Proposed, in.BaseVersion,
		in.EffectiveFrom, in.Justification, session.SubjectID, now)
	if errors.Is(err, domain.ErrInvalidChange) {
		return domain.MasterDataChange{}, rpcerr.Invalid("ORG_CHANGE_INVALID", err.Error())
	}
	if err != nil {
		return domain.MasterDataChange{}, err
	}

	scope := session.TenantScope()
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := p.Changes.InsertChange(ctx, scope, change); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: change.TenantID, Action: PermChangePropose,
			ResourceType: change.EntityType, ResourceID: change.EntityID,
			Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return domain.MasterDataChange{}, err
	}
	return change, nil
}

// DecideChangeInput is an approval or rejection.
type DecideChangeInput struct {
	ChangeID string
	Approve  bool
	Note     string
	// CurrentEntityVersion is what the entity is at now. Supplied by the
	// caller that read it, so the staleness check compares against the version
	// the approver was actually shown.
	CurrentEntityVersion int64
}

// DecideMasterDataChange approves or rejects a proposal (SRS-PLT-008), and on
// approval emits the domain event downstream caches rebuild from
// (SRS-PLT-010).
func (s *Service) DecideMasterDataChange(ctx context.Context, p MasterDataPorts,
	in DecideChangeInput) (domain.MasterDataChange, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.MasterDataChange{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermChangeApprove,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermChangeApprove, "master_data_change", in.ChangeID, decision.Reason)
		return domain.MasterDataChange{}, rpcerr.PermissionDenied("ORG_CHANGE_APPROVE_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	change, err := p.Changes.GetChange(ctx, scope, in.ChangeID)
	if err != nil {
		return domain.MasterDataChange{}, err
	}

	now := s.clock.Now()
	if in.Approve {
		err = change.Approve(session.SubjectID, in.Note, in.CurrentEntityVersion, now)
	} else {
		err = change.Reject(session.SubjectID, in.Note, now)
	}
	switch {
	case errors.Is(err, domain.ErrSelfApproval):
		return domain.MasterDataChange{}, rpcerr.PermissionDenied("ORG_SELF_APPROVAL",
			"a change cannot be decided by the person who proposed it")
	case errors.Is(err, domain.ErrStaleProposal):
		return domain.MasterDataChange{}, rpcerr.FailedPrecondition("ORG_CHANGE_STALE", err.Error())
	case errors.Is(err, domain.ErrNotPending):
		return domain.MasterDataChange{}, rpcerr.FailedPrecondition("ORG_CHANGE_NOT_PENDING", err.Error())
	case errors.Is(err, domain.ErrInvalidChange):
		return domain.MasterDataChange{}, rpcerr.Invalid("ORG_CHANGE_INVALID", err.Error())
	case err != nil:
		return domain.MasterDataChange{}, err
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := p.Changes.DecideChange(ctx, scope, change); err != nil {
			return err
		}
		if change.Status == domain.ChangeApproved {
			payload, err := json.Marshal(map[string]any{
				"change_id":      change.ID,
				"entity_type":    change.EntityType,
				"entity_id":      change.EntityID,
				"entity_version": change.BaseVersion + 1,
				"effective_from": change.EffectiveFrom.Format(time.RFC3339),
				"proposed":       json.RawMessage(change.Proposed),
			})
			if err != nil {
				return rpcerr.Internal("ORG_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
			}
			// The event carries the entity version so a subscriber can
			// discard one that arrives after a newer change — delivery is
			// at-least-once and out of order, and a cache that applies
			// whatever came last will sometimes apply the older one
			// (SRS-PLT-010, SRS-DAT-008).
			if err := s.appendEvent(ctx, session, change.TenantID, EventMasterDataApproved,
				change.EntityType, change.EntityID, payload, now); err != nil {
				return err
			}
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: change.TenantID, Action: PermChangeApprove,
			ResourceType: change.EntityType, ResourceID: change.EntityID,
			Outcome: audit.OutcomeSuccess, Reason: string(change.Status),
		}, now)
	})
	if err != nil {
		return domain.MasterDataChange{}, err
	}
	return change, nil
}

// ModuleEnabled implements transport.EntitlementChecker (SRS-PLT-011).
//
// A method on a small adapter type rather than on Service, so the transport
// interceptor depends on an interface this context happens to satisfy instead
// of on the whole service.
type EntitlementChecker struct {
	Entitlements ports.EntitlementRepository
	Clock        ports.Clock
}

// ModuleEnabled answers whether a caller's tenant and facility have a module.
func (c EntitlementChecker) ModuleEnabled(ctx context.Context, session authctx.Session,
	module string) (bool, string, error) {

	rows, err := c.Entitlements.EntitlementsForModule(ctx, session.TenantScope(),
		module, session.ActiveFacilityID)
	if err != nil {
		return false, "", err
	}
	decision := domain.ResolveEntitlement(rows, session.ActiveFacilityID, c.Clock.Now())
	return decision.Enabled, decision.Reason, nil
}

// SetEntitlementInput grants or withholds a module.
type SetEntitlementInput struct {
	FacilityID     string
	Module         string
	Enabled        bool
	EffectiveFrom  time.Time
	EffectiveUntil time.Time
}

// SetEntitlement configures a module for a tenant or facility (SRS-PLT-011).
func (s *Service) SetEntitlement(ctx context.Context, p MasterDataPorts,
	in SetEntitlementInput) (domain.Entitlement, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.Entitlement{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermEntitlementSet,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermEntitlementSet, "entitlement", in.Module, decision.Reason)
		return domain.Entitlement{}, rpcerr.PermissionDenied("ORG_ENTITLEMENT_DENIED", decision.Reason)
	}

	now := s.clock.Now()
	entitlement, err := domain.NewEntitlement(s.ids.NewID(), session.TenantID, in.FacilityID,
		in.Module, in.Enabled, in.EffectiveFrom, in.EffectiveUntil, session.SubjectID, now)
	if errors.Is(err, domain.ErrInvalidEntitlement) {
		return domain.Entitlement{}, rpcerr.Invalid("ORG_ENTITLEMENT_INVALID", err.Error())
	}
	if err != nil {
		return domain.Entitlement{}, err
	}

	scope := session.TenantScope()
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := p.Entitlements.InsertEntitlement(ctx, scope, entitlement); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: entitlement.TenantID, Action: PermEntitlementSet,
			ResourceType: "entitlement", ResourceID: entitlement.Module,
			Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return domain.Entitlement{}, err
	}
	return entitlement, nil
}
