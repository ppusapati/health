package application

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Numbering, calendars and labels (SRS-PLT-014, 016, 017).

// ConfigPorts are the stores these use cases need.
type ConfigPorts struct {
	Numbers   ports.NumberIssuer
	Calendars ports.CalendarRepository
	Labels    ports.LabelRepository
	Tenants   ports.TenantRepository
}

// IssueNumberInput asks for the next document number.
type IssueNumberInput struct {
	Scope      domain.NumberScope
	FacilityID string
	// ResetPolicy is "", "never", "yearly", "monthly" or "daily". It is
	// supplied per call rather than stored on the sequence because the period
	// key it produces is part of the sequence's identity: a yearly sequence is
	// a different row each year.
	ResetPolicy string
}

// IssueNumber allocates an MRN, encounter, invoice or receipt number
// (SRS-PLT-014).
//
// The caller's transaction is the unit of atomicity: called inside one, a
// rollback returns the number rather than burning it, which is what an invoice
// series a tax authority expects to be gapless requires.
func (s *Service) IssueNumber(ctx context.Context, p ConfigPorts, in IssueNumberInput) (string, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return "", rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermNumberIssue,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		return "", rpcerr.PermissionDenied("ORG_NUMBER_DENIED", decision.Reason)
	}

	now := s.clock.Now()
	// The reset period must be judged in the tenant's own timezone. A hospital
	// in Kolkata issuing an invoice at 02:00 local on 1 April is in the new
	// fiscal year; UTC would still say 31 March and put it in the old series.
	loc, err := s.tenantLocation(ctx, p, session)
	if err != nil {
		return "", err
	}
	periodKey, err := domain.PeriodKeyFor(in.ResetPolicy, now, loc)
	if err != nil {
		return "", rpcerr.Invalid("ORG_RESET_POLICY_INVALID", err.Error())
	}

	return p.Numbers.IssueNumber(ctx, session.TenantScope(), in.Scope, in.FacilityID, periodKey, now)
}

// tenantLocation resolves the tenant's configured timezone.
//
// A failure to load it is an error rather than a fallback to UTC: falling back
// would put a document in the wrong period silently, and the number is then
// wrong in a way nobody notices until an auditor counts the series.
func (s *Service) tenantLocation(ctx context.Context, p ConfigPorts, session authctx.Session) (*time.Location, error) {
	tenant, err := p.Tenants.GetByID(ctx, session.TenantID)
	if err != nil {
		return nil, err
	}
	loc, err := time.LoadLocation(tenant.TimeZone)
	if err != nil {
		return nil, rpcerr.Internal("ORG_TENANT_TIMEZONE_INVALID",
			fmt.Sprintf("tenant timezone %q is not a known IANA zone", tenant.TimeZone)).WithCause(err)
	}
	return loc, nil
}

// AuthorizeSchedulingInput asks whether a facility is open on a date.
type AuthorizeSchedulingInput struct {
	FacilityID string
	Date       time.Time
	// Override is the caller's request to book through a closure. It is
	// honoured only when the caller also holds the permission and the calendar
	// entry permits one — asking is not the same as being allowed.
	Override bool
}

// AuthorizeScheduling decides whether something may be booked on a date
// (SRS-PLT-016).
func (s *Service) AuthorizeScheduling(ctx context.Context, p ConfigPorts,
	in AuthorizeSchedulingInput) (domain.SchedulingDecision, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.SchedulingDecision{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	entries, err := p.Calendars.CalendarEntriesOn(ctx, session.TenantScope(), in.FacilityID, in.Date)
	if err != nil {
		return domain.SchedulingDecision{}, err
	}

	// Two separate conditions, deliberately not collapsed: the caller asked to
	// override, and the caller is allowed to. Collapsing them would let the
	// request itself confer the permission.
	mayOverride := in.Override && session.HasPermission(PermCalendarManage)

	return domain.AuthorizeScheduling(entries, in.Date, mayOverride), nil
}

// AddCalendarEntryInput records a holiday, closure or special opening.
type AddCalendarEntryInput struct {
	FacilityID        string
	Type              domain.CalendarEntryType
	StartsOn          time.Time
	EndsOn            time.Time
	Label             string
	OverridePermitted bool
}

// AddCalendarEntry records a calendar period for a facility (SRS-PLT-016).
func (s *Service) AddCalendarEntry(ctx context.Context, p ConfigPorts,
	in AddCalendarEntryInput) (domain.CalendarEntry, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.CalendarEntry{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission:           PermCalendarManage,
		Mutating:             true,
		ResourceFacilityID:   in.FacilityID,
		RequireFacilityMatch: true,
		TenantMode:           policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermCalendarManage, "calendar_entry", in.FacilityID, decision.Reason)
		return domain.CalendarEntry{}, rpcerr.PermissionDenied("ORG_CALENDAR_DENIED", decision.Reason)
	}

	now := s.clock.Now()
	entry, err := domain.NewCalendarEntry(s.ids.NewID(), session.TenantID, in.FacilityID,
		in.Type, in.StartsOn, in.EndsOn, in.Label, in.OverridePermitted, now)
	if errors.Is(err, domain.ErrInvalidCalendarEntry) {
		return domain.CalendarEntry{}, rpcerr.Invalid("ORG_CALENDAR_INVALID", err.Error())
	}
	if err != nil {
		return domain.CalendarEntry{}, err
	}

	scope := session.TenantScope()
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := p.Calendars.InsertCalendarEntry(ctx, scope, entry); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: entry.TenantID, Action: PermCalendarManage,
			ResourceType: "calendar_entry", ResourceID: entry.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return domain.CalendarEntry{}, err
	}
	return entry, nil
}

// PutLabelInput configures a locale's rendering of a code.
type PutLabelInput struct {
	CodeSystem   string
	Code         string
	Locale       string
	Display      string
	ShortDisplay string
}

// PutLabel configures a display label (SRS-PLT-017).
func (s *Service) PutLabel(ctx context.Context, p ConfigPorts, in PutLabelInput) (domain.DisplayLabel, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.DisplayLabel{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermLabelManage,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		return domain.DisplayLabel{}, rpcerr.PermissionDenied("ORG_LABEL_DENIED", decision.Reason)
	}

	now := s.clock.Now()
	label, err := domain.NewDisplayLabel(s.ids.NewID(), session.TenantID,
		in.CodeSystem, in.Code, in.Locale, in.Display, in.ShortDisplay, now)
	if errors.Is(err, domain.ErrInvalidLabel) {
		return domain.DisplayLabel{}, rpcerr.Invalid("ORG_LABEL_INVALID", err.Error())
	}
	if err != nil {
		return domain.DisplayLabel{}, err
	}

	if err := p.Labels.PutLabel(ctx, session.TenantScope(), label); err != nil {
		return domain.DisplayLabel{}, err
	}
	return label, nil
}

// RenderCode returns a code's display text for a locale (SRS-PLT-017).
//
// The canonical code always comes back alongside the label. A renderer that
// returns only the label turns a record into something that cannot be looked
// up again, and an untranslated code renders as itself rather than blank.
func (s *Service) RenderCode(ctx context.Context, p ConfigPorts,
	codeSystem, code, locale string) (domain.Rendering, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.Rendering{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	labels, err := p.Labels.LabelsFor(ctx, session.TenantScope(), codeSystem, code)
	if err != nil {
		return domain.Rendering{}, err
	}
	return domain.Render(labels, code, locale), nil
}
