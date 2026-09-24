package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/facilities/domain"
	"github.com/ppusapati/health/code/internal/facilities/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// SignInVendorInput records a contractor arriving (SRS-FAC-011).
type SignInVendorInput struct {
	VendorName   string
	VendorRef    string
	ContactName  string
	Technicians  []string
	FacilityID   string
	WorkOrderID  string
	AssetID      string
	TaskID       string
	InductionRef string
	Purpose      string
}

// SignInVendor records a contractor arriving on site (SRS-FAC-011).
//
// Whether the work needs a permit is read from the work order rather than
// taken from the caller. A contractor asked "does your work need a permit"
// at the gate will answer no, and the record would then carry a flag that
// disagrees with the class the hospital configured.
func (s *Service) SignInVendor(ctx context.Context, in SignInVendorInput) (
	domain.Visit, error) {

	session, scope, err := s.authorize(ctx, PermVendorManage)
	if err != nil {
		return domain.Visit{}, err
	}
	now := s.clock.Now()

	var out domain.Visit
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		requiresPermit := false
		if in.WorkOrderID != "" {
			order, err := s.work.WorkOrder(ctx, scope, in.WorkOrderID)
			if err != nil {
				return err
			}
			requiresPermit = order.ClassRequiresPermit
		}
		if in.AssetID != "" {
			if _, err := s.assets.Asset(ctx, scope,
				in.AssetID); err != nil {
				return err
			}
		}
		if in.TaskID != "" {
			if _, err := s.maintenance.Task(ctx, scope,
				in.TaskID); err != nil {
				return err
			}
		}

		visit, err := domain.SignIn(s.ids.NewID(), session.TenantID,
			domain.SignInInput{
				VendorName: in.VendorName, VendorRef: in.VendorRef,
				ContactName: in.ContactName,
				Technicians: in.Technicians,
				FacilityID:  in.FacilityID,
				WorkOrderID: in.WorkOrderID,
				AssetID:     in.AssetID, TaskID: in.TaskID,
				WorkRequiresPermit: requiresPermit,
				InductionRef:       in.InductionRef,
				Purpose:            in.Purpose,
			}, session.SubjectID, now)
		if err != nil {
			return facilitiesError(err)
		}
		if err := s.visits.InsertVisit(ctx, scope, visit); err != nil {
			return err
		}
		out = visit
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.vendor_visit.signed_in",
			ResourceType: "facilities.vendor_visit",
			ResourceID:   visit.ID,
			Outcome:      audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"vendor":          visit.VendorName,
				"work_order_id":   visit.WorkOrderID,
				"asset_id":        visit.AssetID,
				"requires_permit": boolText(visit.WorkRequiresPermit),
				"technicians":     itoa(len(visit.Technicians)),
			}),
			Reason: visit.Purpose,
		}, now)
	})
	if err != nil {
		return domain.Visit{}, err
	}
	return out, nil
}

// SignOutVendorInput records a contractor leaving with their report.
type SignOutVendorInput struct {
	VisitID          string
	ServiceReportRef string
	ReportSummary    string
	PartsUsed        []string
	FollowUp         string
	Version          int64
}

// SignOutVendor records a contractor leaving (SRS-FAC-011).
func (s *Service) SignOutVendor(ctx context.Context,
	in SignOutVendorInput) (domain.Visit, error) {

	session, scope, err := s.authorize(ctx, PermVendorManage)
	if err != nil {
		return domain.Visit{}, err
	}
	now := s.clock.Now()

	var out domain.Visit
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		visit, err := s.visits.Visit(ctx, scope, in.VisitID)
		if err != nil {
			return err
		}
		if err := visit.SignOut(domain.SignOutInput{
			ServiceReportRef: in.ServiceReportRef,
			ReportSummary:    in.ReportSummary,
			PartsUsed:        in.PartsUsed,
			FollowUp:         in.FollowUp,
		}, session.SubjectID, now); err != nil {
			return facilitiesError(err)
		}
		versionSeen := expected(in.Version, visit.Version)
		if err := s.visits.UpdateVisit(ctx, scope, visit,
			versionSeen); err != nil {
			return facilitiesError(err)
		}
		visit.Version = applied(versionSeen)
		out = visit
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.vendor_visit.signed_out",
			ResourceType: "facilities.vendor_visit",
			ResourceID:   visit.ID,
			Outcome:      audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"service_report_ref": visit.ServiceReportRef,
				"parts_used":         itoa(len(visit.PartsUsed)),
			}),
			Reason: visit.ReportSummary,
		}, now)
	})
	if err != nil {
		return domain.Visit{}, err
	}
	return out, nil
}

// VisitFilterInput narrows a contractor visit list.
type VisitFilterInput struct {
	FacilityID  string
	WorkOrderID string
	AssetID     string
	OnSiteOnly  bool
	PageSize    int32
}

// ListVendorVisits reads contractor attendances (SRS-FAC-011).
func (s *Service) ListVendorVisits(ctx context.Context,
	in VisitFilterInput) ([]domain.Visit, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	found, err := s.visits.Visits(ctx, scope, ports.VisitFilter{
		FacilityID: in.FacilityID, WorkOrderID: in.WorkOrderID,
		AssetID: in.AssetID, OnSiteOnly: in.OnSiteOnly,
		Limit: clampPageSize(in.PageSize),
	})
	if err != nil {
		return nil, err
	}
	if in.OnSiteOnly {
		// Longest on site first: the order that surfaces the visit
		// somebody forgot to sign out, and the list a roll call needs.
		return domain.OnSite(found), nil
	}
	return found, nil
}
