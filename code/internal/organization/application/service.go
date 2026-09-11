// Package application holds the organization context's use cases.
//
// Each use case owns its transaction boundary, evaluates authorization, writes
// the aggregate, appends the outbox event and appends the audit record — all in
// one transaction (Blueprint §4.2, SRS-API-008, SRS-SEC-004).
package application

import (
	"context"
	"encoding/json"
	"time"

	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Canonical permission names. They name bounded-context actions, not menus
// (SRS-IAM-003).
const (
	PermTenantCreate   = "organization.tenant.create"
	PermTenantRead     = "organization.tenant.read"
	PermFacilityCreate = "organization.facility.create"
	PermFacilityRead   = "organization.facility.read"
)

const (
	eventSource        = "organization"
	eventSchemaVersion = 1

	// EventTenantProvisioned is emitted once a tenant row is committed.
	EventTenantProvisioned = "organization.tenant_provisioned"
	// EventFacilityCreated is emitted once a facility row is committed.
	EventFacilityCreated = "organization.facility_created"
)

// maxPageSize caps a listing regardless of what the client asks for, so one
// caller cannot pull an entire tenant's master data in a single round trip.
const (
	defaultPageSize = 50
	maxPageSize     = 200
)

// Service is the organization use-case façade.
type Service struct {
	uow        ports.UnitOfWork
	tenants    ports.TenantRepository
	facilities ports.FacilityRepository
	events     ports.EventAppender
	audits     ports.AuditAppender
	ids        ports.IDGenerator
	clock      ports.Clock
}

// NewService wires the use cases to their ports.
func NewService(
	uow ports.UnitOfWork,
	tenants ports.TenantRepository,
	facilities ports.FacilityRepository,
	events ports.EventAppender,
	audits ports.AuditAppender,
	ids ports.IDGenerator,
	clock ports.Clock,
) *Service {
	return &Service{uow: uow, tenants: tenants, facilities: facilities,
		events: events, audits: audits, ids: ids, clock: clock}
}

// CreateTenantInput is the command payload for tenant provisioning.
type CreateTenantInput struct {
	DisplayName       string
	LegalJurisdiction string
	DefaultLocale     string
	TimeZone          string
}

// CreateTenant provisions a tenant (SRS-PLT-001).
//
// This is a platform-operator action: the new tenant does not yet exist, so the
// policy check is a pure permission check with no resource tenant to compare.
func (s *Service) CreateTenant(ctx context.Context, in CreateTenantInput) (*domain.Tenant, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return nil, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermTenantCreate,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermTenantCreate, "tenant", "", decision.Reason)
		return nil, rpcerr.PermissionDenied("ORG_TENANT_CREATE_DENIED", decision.Reason)
	}

	now := s.clock.Now()
	tenant, err := domain.NewTenant(s.ids.NewID(), in.DisplayName, in.LegalJurisdiction,
		in.DefaultLocale, in.TimeZone, now)
	if err != nil {
		return nil, err
	}

	// A tenant that cannot be used is not worth provisioning, so activation is
	// part of the same transaction rather than a second operator step.
	if err := tenant.TransitionTo(domain.TenantActive, now); err != nil {
		return nil, err
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.tenants.Insert(ctx, tenant); err != nil {
			return err
		}
		payload, err := json.Marshal(map[string]string{
			"tenant_id":          tenant.ID,
			"legal_jurisdiction": tenant.LegalJurisdiction,
			"status":             string(tenant.Status),
		})
		if err != nil {
			return rpcerr.Internal("ORG_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, tenant.ID, EventTenantProvisioned, "tenant", tenant.ID, payload, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID:     tenant.ID,
			Action:       PermTenantCreate,
			ResourceType: "tenant",
			ResourceID:   tenant.ID,
			Outcome:      audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, err
	}
	return tenant, nil
}

// GetTenant reads a tenant (SRS-PLT-001). A caller may only read its own tenant
// unless it holds cross-tenant platform authority.
func (s *Service) GetTenant(ctx context.Context, tenantID string) (*domain.Tenant, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return nil, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission:       PermTenantRead,
		ResourceTenantID: tenantID,
		TenantMode:       policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermTenantRead, "tenant", tenantID, decision.Reason)
		// Concealed rather than denied: a cross-tenant probe must not be able
		// to distinguish "exists but forbidden" from "does not exist"
		// (Domain/Data §7, SRS-SEC-011).
		return nil, rpcerr.NotFound("ORG_TENANT_NOT_FOUND", "tenant not found")
	}

	return s.tenants.GetByID(ctx, tenantID)
}

// CreateFacilityInput is the command payload for facility creation.
type CreateFacilityInput struct {
	Code        string
	DisplayName string
	Type        domain.FacilityType
	TimeZone    string
}

// CreateFacility creates a facility inside the caller's verified tenant
// (SRS-PLT-004). The tenant is taken from the session, never from the request.
func (s *Service) CreateFacility(ctx context.Context, in CreateFacilityInput) (*domain.Facility, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return nil, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	tenant, err := s.tenants.GetByID(ctx, session.TenantID)
	if err != nil {
		return nil, err
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermFacilityCreate,
		Mutating:   true,
		TenantMode: tenantMode(tenant),
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermFacilityCreate, "facility", "", decision.Reason)
		return nil, rpcerr.PermissionDenied("ORG_FACILITY_CREATE_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	facility, err := domain.NewFacility(s.ids.NewID(), scope.TenantID(), in.Code,
		in.DisplayName, in.Type, in.TimeZone, now)
	if err != nil {
		return nil, err
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// Checked here for a clear error; the database also carries a unique
		// constraint, which is what actually holds under concurrency.
		exists, err := s.facilities.ExistsByCode(ctx, scope, facility.Code)
		if err != nil {
			return err
		}
		if exists {
			return rpcerr.AlreadyExists("ORG_FACILITY_CODE_TAKEN",
				"facility code already exists in this tenant")
		}
		if err := s.facilities.Insert(ctx, scope, facility); err != nil {
			return err
		}
		payload, err := json.Marshal(map[string]string{
			"facility_id": facility.ID,
			"code":        facility.Code,
			"type":        string(facility.Type),
			"status":      string(facility.Status),
		})
		if err != nil {
			return rpcerr.Internal("ORG_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, scope.TenantID(), EventFacilityCreated, "facility", facility.ID, payload, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID:     scope.TenantID(),
			Action:       PermFacilityCreate,
			ResourceType: "facility",
			ResourceID:   facility.ID,
			Outcome:      audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, err
	}
	return facility, nil
}

// GetFacility reads one facility within the caller's tenant.
func (s *Service) GetFacility(ctx context.Context, facilityID string) (*domain.Facility, error) {
	session, scope, err := s.authorizeRead(ctx, PermFacilityRead)
	if err != nil {
		return nil, err
	}
	_ = session
	return s.facilities.GetByID(ctx, scope, facilityID)
}

// ListFacilitiesInput narrows a facility listing.
type ListFacilitiesInput struct {
	Status    domain.FacilityStatus
	PageSize  int32
	PageToken string
}

// ListFacilities returns a page of facilities for the caller's tenant.
func (s *Service) ListFacilities(ctx context.Context, in ListFacilitiesInput) ([]*domain.Facility, string, error) {
	_, scope, err := s.authorizeRead(ctx, PermFacilityRead)
	if err != nil {
		return nil, "", err
	}

	size := in.PageSize
	if size <= 0 {
		size = defaultPageSize
	}
	if size > maxPageSize {
		size = maxPageSize
	}

	return s.facilities.List(ctx, scope, ports.FacilityFilter{
		Status:    in.Status,
		PageSize:  size,
		PageToken: in.PageToken,
	})
}

// authorizeRead resolves the session, checks the tenant is accessible and the
// permission is held, and returns the verified scope.
func (s *Service) authorizeRead(ctx context.Context, permission string) (authctx.Session, authctx.TenantScope, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	tenant, err := s.tenants.GetByID(ctx, session.TenantID)
	if err != nil {
		return authctx.Session{}, authctx.TenantScope{}, err
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: permission,
		TenantMode: tenantMode(tenant),
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, permission, "facility", "", decision.Reason)
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.PermissionDenied("ORG_READ_DENIED", decision.Reason)
	}
	return session, session.TenantScope(), nil
}

// TenantMode reports a tenant's lifecycle posture.
//
// Exposed so other contexts can ask the owning context rather than reading its
// tables (Domain/Data spec §2.1). A tenant that does not exist has no access.
func (s *Service) TenantMode(ctx context.Context, tenantID string) (policy.TenantMode, error) {
	tenant, err := s.tenants.GetByID(ctx, tenantID)
	if err != nil {
		if e, ok := rpcerr.As(err); ok && e.Category == rpcerr.CategoryNotFound {
			return policy.TenantModeNoAccess, nil
		}
		return policy.TenantModeNoAccess, err
	}
	return tenantMode(tenant), nil
}

// tenantMode maps tenant lifecycle onto the policy engine's posture.
func tenantMode(t *domain.Tenant) policy.TenantMode {
	switch {
	case !t.IsAccessible():
		return policy.TenantModeNoAccess
	case !t.AcceptsWrites():
		return policy.TenantModeReadOnly
	default:
		return policy.TenantModeReadWrite
	}
}

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	tenantID, eventType, aggregateType, aggregateID string, payload json.RawMessage, now time.Time) error {
	return s.events.Append(ctx, outbox.Event{
		EventID:       s.ids.NewID(),
		EventType:     eventType,
		SchemaVersion: eventSchemaVersion,
		OccurredAt:    now.UTC(),
		TenantID:      tenantID,
		Source:        eventSource,
		AggregateType: aggregateType,
		AggregateID:   aggregateID,
		CorrelationID: session.CorrelationID,
		CausationID:   session.RequestID,
		Actor:         session.SubjectID,
		Payload:       payload,
	})
}

func (s *Service) appendAudit(ctx context.Context, session authctx.Session, r audit.Record, now time.Time) error {
	r.AuditID = s.ids.NewID()
	r.ActorID = session.SubjectID
	r.CorrelationID = session.CorrelationID
	r.RequestID = session.RequestID
	r.PurposeOfUse = string(session.Purpose)
	r.BreakGlass = session.BreakGlass
	r.OccurredAt = now.UTC()
	return s.audits.Append(ctx, r)
}

// auditDenied records a refused attempt. It runs outside the caller's
// transaction deliberately: the transaction is about to be abandoned, and a
// denial must survive that rollback to be reviewable.
func (s *Service) auditDenied(ctx context.Context, session authctx.Session,
	action, resourceType, resourceID, reason string) {
	_ = s.appendAudit(ctx, session, audit.Record{
		TenantID:     session.TenantID,
		Action:       action,
		ResourceType: resourceType,
		ResourceID:   resourceID,
		Outcome:      audit.OutcomeDenied,
		Reason:       reason,
	}, s.clock.Now())
}
