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
	numbers    ports.NumberIssuer
	events     ports.EventAppender
	audits     ports.AuditAppender
	ids        ports.IDGenerator
	clock      ports.Clock
}

// Deps are the collaborators the service needs.
//
// A struct rather than eight positional parameters: four of them are
// repositories of similar shape, and the only thing protecting their order
// would be convention.
type Deps struct {
	UnitOfWork ports.UnitOfWork
	Tenants    ports.TenantRepository
	Facilities ports.FacilityRepository
	// Numbers provisions and issues document numbers. Optional: a deployment
	// that wires no issuer creates facilities that cannot yet issue an MRN, and
	// says so at the point of issue rather than at commissioning.
	Numbers ports.NumberIssuer
	Events  ports.EventAppender
	Audits  ports.AuditAppender
	IDs     ports.IDGenerator
	Clock   ports.Clock
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, tenants: d.Tenants, facilities: d.Facilities,
		numbers: d.Numbers, events: d.Events, audits: d.Audits,
		ids: d.IDs, clock: d.Clock,
	}
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
		if err := s.provisionMRNSequence(ctx, scope, facility, now); err != nil {
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

// DefaultMRNPadWidth is the numeric width of a newly commissioned facility's
// MRN. Seven digits is ten million records — longer than any single site's
// life — and a fixed width is what stops "MRN 42" and "MRN 042" being read as
// two different numbers on two different printouts.
const DefaultMRNPadWidth = 7

// provisionMRNSequence gives a new facility the counter its registrations need.
//
// Done at commissioning, inside the same transaction as the facility row, so
// there is no window in which a facility exists but cannot register a patient.
// Lazily creating the sequence on first use would put that window at the worst
// possible moment — the first patient through the door of a new site — and
// would have to invent a starting value under concurrency, which is exactly the
// race SRS-EMPI-016 forbids.
//
// The sequence is per-facility and never resets: an MRN identifies a person for
// life, so it carries no period key. The facility code becomes the prefix, so a
// number says which site registered the patient without a lookup.
func (s *Service) provisionMRNSequence(ctx context.Context, scope authctx.TenantScope,
	facility *domain.Facility, now time.Time) error {

	if s.numbers == nil {
		// A deployment that wires no issuer is valid — the organization context
		// does not require one — and the failure surfaces at the first attempt
		// to issue, naming the missing sequence.
		return nil
	}

	// The tenant's clinical-order counter goes in alongside (SRS-ORD-001).
	// Here rather than at tenant creation, because this is where a verified
	// tenant scope exists — a service that minted one for itself would hold an
	// unforgeable credential, which is what ADR-001 and FIT-03 exist to
	// prevent — and because a tenant with no facility places no orders.
	if err := s.provisionOrderSequence(ctx, scope, now); err != nil {
		return err
	}

	// And the finance counters (SRS-BIL-006, SRS-BIL-008). Per tenant for the
	// same reason as the order counter and one of its own: a hospital group
	// keeps one invoice series across its sites, so a number identifies a
	// document without also having to say which site issued it. Gapless matters
	// more here than anywhere else in the system — a gap in an invoice series is
	// a question an auditor asks, and "the transaction rolled back" is not an
	// answer they accept.
	if err := s.provisionFinanceSequences(ctx, scope, now); err != nil {
		return err
	}

	// EnsureSequence is ON CONFLICT DO NOTHING, so re-commissioning a facility
	// code that once existed cannot reset a live counter back to 1 and re-issue
	// an MRN already printed on a wristband.
	return s.numbers.EnsureSequence(ctx, scope, domain.NumberSequence{
		ID:         s.ids.NewID(),
		TenantID:   scope.TenantID(),
		Scope:      domain.ScopeMRN,
		FacilityID: facility.ID,
		Prefix:     facility.Code + "-",
		PadWidth:   DefaultMRNPadWidth,
		NextValue:  1,
		PeriodKey:  "",
		CreatedAt:  now,
		UpdatedAt:  now,
	})
}

// DefaultOrderPadWidth zero-pads an order number to eight digits.
//
// Wide enough that a busy group does not reach it, and fixed-width so the
// numbers sort and line up on a requisition.
const DefaultOrderPadWidth = 8

// DefaultFinancePadWidth zero-pads an invoice or receipt number to eight
// digits.
//
// Fixed-width so the numbers sort, and wide enough that a busy group does not
// reach the end of the series inside a financial year.
const DefaultFinancePadWidth = 8

// provisionFinanceSequences gives a tenant its invoice and receipt counters
// (SRS-BIL-006, SRS-BIL-008, SRS-PLT-014).
//
// Two sequences rather than one, because an invoice number and a receipt number
// are read by different people for different reasons: a patient quotes the
// invoice when they query a charge and the receipt when they prove they paid,
// and interleaving them into one series makes both harder to search for.
//
// ON CONFLICT DO NOTHING, so commissioning a second facility cannot reset a
// live counter back to 1 and re-issue an invoice number a patient is already
// holding a copy of.
func (s *Service) provisionFinanceSequences(ctx context.Context,
	scope authctx.TenantScope, now time.Time) error {

	if s.numbers == nil {
		return nil
	}
	for _, sequence := range []struct {
		scope  domain.NumberScope
		prefix string
	}{
		{domain.ScopeInvoice, "INV-"},
		{domain.ScopeReceipt, "RCP-"},
	} {
		if err := s.numbers.EnsureSequence(ctx, scope, domain.NumberSequence{
			ID:        s.ids.NewID(),
			TenantID:  scope.TenantID(),
			Scope:     sequence.scope,
			Prefix:    sequence.prefix,
			PadWidth:  DefaultFinancePadWidth,
			NextValue: 1,
			CreatedAt: now,
			UpdatedAt: now,
		}); err != nil {
			return err
		}
	}
	return nil
}

// provisionOrderSequence gives a tenant its clinical-order counter
// (SRS-ORD-001, SRS-PLT-014).
//
// Per tenant rather than per facility, unlike the MRN: a laboratory serving
// three sites reads order numbers off requisitions from all three, and
// per-facility counters would put two different orders under one number on the
// bench. ON CONFLICT DO NOTHING, so commissioning a second facility is a no-op
// and cannot reset a live counter back to 1 and re-issue an order number a
// laboratory already holds.
func (s *Service) provisionOrderSequence(ctx context.Context,
	scope authctx.TenantScope, now time.Time) error {

	if s.numbers == nil {
		return nil
	}
	return s.numbers.EnsureSequence(ctx, scope, domain.NumberSequence{
		ID:        s.ids.NewID(),
		TenantID:  scope.TenantID(),
		Scope:     domain.ScopeOrder,
		Prefix:    "ORD-",
		PadWidth:  DefaultOrderPadWidth,
		NextValue: 1,
		CreatedAt: now,
		UpdatedAt: now,
	})
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
