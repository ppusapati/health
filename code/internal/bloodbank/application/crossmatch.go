package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/bloodbank/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// AddComponent brings a component into inventory (SRS-BLD-003, SRS-BLD-005).
//
// It starts quarantined unless the caller says testing is already complete,
// and saying so needs the release permission: a unit that arrives available is
// a unit nobody in this hospital tested, and only somebody trusted to release
// may assert that the supplier did.
func (s *Service) AddComponent(ctx context.Context, in domain.NewComponentInput) (
	domain.Component, error) {

	permission := PermInventory
	if in.Released {
		permission = PermRelease
	}
	session, scope, err := s.authorize(ctx, permission)
	if err != nil {
		return domain.Component{}, err
	}
	now := s.clock.Now()

	var component domain.Component
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		collection, err := s.donors.Collection(ctx, scope, in.CollectionID)
		if err != nil {
			return err
		}
		// The donor comes from the donation rather than from the caller. A
		// component is made from one collection and that collection has one
		// donor, so asking for it again is only a chance to disagree — and the
		// look-back that a positive test starts runs along this link.
		if in.DonorID == "" {
			in.DonorID = collection.DonorID
		}

		component, err = domain.NewComponent(
			s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
		if err != nil {
			return bloodbankError(err)
		}
		if err := s.inventory.InsertComponent(ctx, scope, component); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: permission,
			ResourceType: "bloodbank_component", ResourceID: component.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: "unit " + component.UnitNumber + " " +
				string(component.Class) + " " + component.Group.String(),
		}, now)
	})
	if err != nil {
		return domain.Component{}, err
	}
	return component, nil
}

// Component reads one unit.
func (s *Service) Component(ctx context.Context, componentID string) (
	domain.Component, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Component{}, err
	}
	return s.inventory.Component(ctx, scope, componentID)
}

// ComponentByNumber reads the unit a label names, which is what a scan has.
func (s *Service) ComponentByNumber(ctx context.Context, unitNumber string) (
	domain.Component, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Component{}, err
	}
	return s.inventory.ComponentByNumber(ctx, scope, unitNumber)
}

// DiscardComponent takes a unit out of inventory for good (SRS-BLD-013).
func (s *Service) DiscardComponent(ctx context.Context, componentID string,
	reason domain.DiscardReason) (domain.Component, error) {

	session, scope, err := s.authorize(ctx, PermInventory)
	if err != nil {
		return domain.Component{}, err
	}
	now := s.clock.Now()

	var out domain.Component
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		component, err := s.inventory.Component(ctx, scope, componentID)
		if err != nil {
			return err
		}
		if err := component.Discard(reason); err != nil {
			return bloodbankError(err)
		}
		if err := s.inventory.UpdateStatus(
			ctx, scope, component, component.Version); err != nil {
			return bloodbankError(err)
		}
		out = component

		if err := s.appendEvent(ctx, session, EventComponentDiscarded,
			"bloodbank_component", component.ID, map[string]any{
				"unit_number": component.UnitNumber,
				"class":       string(component.Class),
				"group":       component.Group.String(),
				"reason":      string(reason),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermInventory,
			ResourceType: "bloodbank_component", ResourceID: component.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "discarded: " + string(reason),
		}, now)
	})
	if err != nil {
		return domain.Component{}, err
	}
	return out, nil
}

// PlaceRequest raises a request for blood (SRS-BLD-006).
func (s *Service) PlaceRequest(ctx context.Context, in domain.NewRequestInput) (
	domain.Request, error) {

	session, scope, err := s.authorize(ctx, PermRequest)
	if err != nil {
		return domain.Request{}, err
	}
	now := s.clock.Now()

	if err := s.knownPatient(ctx, scope, in.PatientID); err != nil {
		return domain.Request{}, err
	}

	request, err := domain.NewRequest(
		s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return domain.Request{}, bloodbankError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.crossmatch.InsertRequest(ctx, scope, request); err != nil {
			return err
		}
		// The blood bank's worklist is a query, but an emergency request is
		// worth telling other systems about: the bank may not be looking at
		// the screen.
		if err := s.appendEvent(ctx, session, EventRequestPlaced,
			"bloodbank_request", request.ID, map[string]any{
				"patient_id":  request.PatientID,
				"class":       string(request.Class),
				"quantity":    request.Quantity,
				"urgency":     string(request.Urgency),
				"required_by": request.RequiredBy,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermRequest,
			ResourceType: "bloodbank_request", ResourceID: request.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: itoa(request.Quantity) + " " + string(request.Class) +
				", " + string(request.Urgency),
		}, now)
	})
	if err != nil {
		return domain.Request{}, err
	}
	return request, nil
}

// Worklist is the blood bank's open requests (SRS-BLD-006).
func (s *Service) Worklist(ctx context.Context, facilityID string, limit int32) (
	[]domain.Request, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.crossmatch.OpenRequests(
		ctx, scope, facilityID, clampPageSize(limit))
}

// PatientRequests reads a patient's requests.
func (s *Service) PatientRequests(ctx context.Context, patientID string,
	limit int32) ([]domain.Request, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.crossmatch.PatientRequests(
		ctx, scope, patientID, clampPageSize(limit))
}

// GroupPatient records a patient's group and antibody screen (SRS-BLD-007).
func (s *Service) GroupPatient(ctx context.Context, in domain.NewSampleInput) (
	domain.PatientSample, error) {

	session, scope, err := s.authorize(ctx, PermCrossmatch)
	if err != nil {
		return domain.PatientSample{}, err
	}
	now := s.clock.Now()

	if err := s.knownPatient(ctx, scope, in.PatientID); err != nil {
		return domain.PatientSample{}, err
	}
	if in.ValidFor <= 0 {
		in.ValidFor = s.config.SampleValidity
	}

	sample, err := domain.RecordSample(
		s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return domain.PatientSample{}, bloodbankError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.crossmatch.InsertSample(ctx, scope, sample); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermCrossmatch,
			ResourceType: "bloodbank_sample", ResourceID: sample.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "grouped " + sample.Group.String(),
		}, now)
	})
	if err != nil {
		return domain.PatientSample{}, err
	}
	return sample, nil
}

// Candidate is one unit offered against a request, with the verdict.
type Candidate struct {
	Component domain.Component
	Decision  domain.MatchDecision
}

// FindCompatible offers the units that could be given against a request
// (SRS-BLD-007).
//
// Every candidate carries its verdict rather than the list being pre-filtered.
// A scientist looking at a near-miss — the right group, the wrong special
// requirement — needs to see it and why, because the alternative is a screen
// that says "no units available" with a fridge full of blood.
func (s *Service) FindCompatible(ctx context.Context, requestID string,
	limit int32) ([]Candidate, error) {

	_, scope, err := s.authorize(ctx, PermCrossmatch)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	request, err := s.crossmatch.Request(ctx, scope, requestID)
	if err != nil {
		return nil, err
	}
	sample, hasSample, err := s.crossmatch.CurrentSample(
		ctx, scope, request.PatientID, now)
	if err != nil {
		return nil, err
	}
	if !hasSample {
		// Reported rather than returning an empty list: "no valid sample" and
		// "no compatible blood" send somebody to different places.
		return nil, rpcerr.FailedPrecondition("BLD_NO_SAMPLE",
			"this patient has no valid grouping sample")
	}

	units, err := s.inventory.Allocatable(
		ctx, scope, request.Class, now, clampPageSize(limit))
	if err != nil {
		return nil, err
	}

	out := make([]Candidate, 0, len(units))
	for _, unit := range units {
		out = append(out, Candidate{
			Component: unit,
			Decision:  domain.EvaluateMatch(unit, request, sample, now),
		})
	}
	return out, nil
}

// Reserve holds a unit for a patient (SRS-BLD-008).
//
// The match is evaluated here, inside the transaction, from rows read here.
// A caller cannot reserve by asserting compatibility, and a unit that became
// unavailable between the search and the hold is caught.
func (s *Service) Reserve(ctx context.Context, requestID, componentID string,
	crossmatched bool, note string) (domain.Reservation, error) {

	session, scope, err := s.authorize(ctx, PermCrossmatch)
	if err != nil {
		return domain.Reservation{}, err
	}
	now := s.clock.Now()

	var out domain.Reservation
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		request, err := s.crossmatch.Request(ctx, scope, requestID)
		if err != nil {
			return err
		}
		component, err := s.inventory.Component(ctx, scope, componentID)
		if err != nil {
			return err
		}
		sample, hasSample, err := s.crossmatch.CurrentSample(
			ctx, scope, request.PatientID, now)
		if err != nil {
			return err
		}
		if !hasSample {
			return rpcerr.FailedPrecondition("BLD_NO_SAMPLE",
				"this patient has no valid grouping sample")
		}

		decision := domain.EvaluateMatch(component, request, sample, now)
		reservation, err := domain.Reserve(s.ids.NewID(), session.TenantID,
			domain.NewReservationInput{
				ComponentID: component.ID, RequestID: request.ID,
				PatientID: request.PatientID, SampleID: sample.ID,
				Crossmatched: crossmatched, CrossmatchNote: note,
				HoldFor: s.config.ReservationWindow,
			}, decision, session.SubjectID, now)
		if err != nil {
			return bloodbankError(err)
		}
		if err := s.crossmatch.InsertReservation(ctx, scope, reservation); err != nil {
			return err
		}
		out = reservation

		// The unit moves to reserved, so the next search does not offer it.
		component.Status = domain.UnitReserved
		if err := s.inventory.UpdateStatus(
			ctx, scope, component, component.Version); err != nil {
			return bloodbankError(err)
		}

		if err := s.appendEvent(ctx, session, EventUnitReserved,
			"bloodbank_component", component.ID, map[string]any{
				"unit_number":  component.UnitNumber,
				"patient_id":   request.PatientID,
				"request_id":   request.ID,
				"crossmatched": crossmatched,
				"expires_at":   reservation.ExpiresAt,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermCrossmatch,
			ResourceType: "bloodbank_component", ResourceID: component.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "reserved unit " + component.UnitNumber,
		}, now)
	})
	if err != nil {
		return domain.Reservation{}, err
	}
	return out, nil
}

// ReleaseReservation returns a held unit to the shelf (SRS-BLD-008).
func (s *Service) ReleaseReservation(ctx context.Context, reservationID,
	reason string) error {

	session, scope, err := s.authorize(ctx, PermCrossmatch)
	if err != nil {
		return err
	}
	now := s.clock.Now()

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		reservation, err := s.crossmatch.Reservation(ctx, scope, reservationID)
		if err != nil {
			return err
		}
		closed, err := s.crossmatch.CloseReservation(ctx, scope, reservationID,
			domain.ReservationReleased, reason)
		if err != nil {
			return err
		}
		if !closed {
			return rpcerr.FailedPrecondition("BLD_RESERVATION_CLOSED",
				"this reservation is no longer held")
		}

		component, err := s.inventory.Component(
			ctx, scope, reservation.ComponentID)
		if err != nil {
			return err
		}
		if component.Status == domain.UnitReserved {
			// Back to available, unless something else moved it — a recall
			// between the hold and the release quarantines it, and returning
			// that unit to the shelf would undo the recall.
			component.Status = domain.UnitAvailable
			if err := s.inventory.UpdateStatus(
				ctx, scope, component, component.Version); err != nil {
				return bloodbankError(err)
			}
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermCrossmatch,
			ResourceType: "bloodbank_component", ResourceID: component.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "reservation released: " + reason,
		}, now)
	})
}

// SweepLapsedReservations returns blood held past its window to the shelf.
//
// Blood held for a patient who did not need it is blood the next patient could
// not have, so this runs rather than waiting for somebody to notice.
func (s *Service) SweepLapsedReservations(ctx context.Context, limit int32) (
	int, error) {

	session, scope, err := s.authorize(ctx, PermCrossmatch)
	if err != nil {
		return 0, err
	}
	now := s.clock.Now()

	swept := 0
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		lapsed, err := s.crossmatch.Lapsed(ctx, scope, now, clampPageSize(limit))
		if err != nil {
			return err
		}
		for _, reservation := range lapsed {
			closed, err := s.crossmatch.CloseReservation(ctx, scope,
				reservation.ID, domain.ReservationExpired, "hold expired")
			if err != nil {
				return err
			}
			if !closed {
				continue
			}
			component, err := s.inventory.Component(
				ctx, scope, reservation.ComponentID)
			if err != nil {
				return err
			}
			if component.Status != domain.UnitReserved {
				continue
			}
			component.Status = domain.UnitAvailable
			if err := s.inventory.UpdateStatus(
				ctx, scope, component, component.Version); err != nil {
				return bloodbankError(err)
			}
			swept++
		}
		if swept == 0 {
			return nil
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermCrossmatch,
			ResourceType: "bloodbank_inventory", ResourceID: "sweep",
			Outcome: audit.OutcomeSuccess,
			Reason:  itoa(swept) + " lapsed reservation(s) returned to stock",
		}, now)
	})
	if err != nil {
		return 0, err
	}
	return swept, nil
}

// IssueInput is a unit leaving the blood bank.
type IssueInput struct {
	ComponentID   string
	ReservationID string
	Destination   string
	IssuedTo      string
	// Check is read at the counter from the unit and the request, and compared
	// against the record rather than trusted.
	CheckUnitNumber string
	CheckPatientID  string

	// Emergency and its authorisation (SRS-BLD-016).
	Emergency           bool
	EmergencyAuthoriser string
	EmergencyReason     string
}

// IssueUnit releases a unit from the blood bank (SRS-BLD-009, SRS-BLD-016).
func (s *Service) IssueUnit(ctx context.Context, in IssueInput) (
	domain.Issue, error) {

	permission := PermIssue
	if in.Emergency {
		permission = PermEmergencyIssue
	}
	session, scope, err := s.authorize(ctx, permission)
	if err != nil {
		return domain.Issue{}, err
	}
	now := s.clock.Now()

	var out domain.Issue
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		component, err := s.inventory.Component(ctx, scope, in.ComponentID)
		if err != nil {
			return err
		}

		var reservation *domain.Reservation
		if in.ReservationID != "" {
			held, err := s.crossmatch.Reservation(ctx, scope, in.ReservationID)
			if err != nil {
				return err
			}
			reservation = &held
		}

		issue, err := domain.IssueComponent(s.ids.NewID(), session.TenantID,
			domain.NewIssueInput{
				ComponentID: component.ID, ReservationID: in.ReservationID,
				Destination: in.Destination, IssuedTo: in.IssuedTo,
				Check: domain.IssueCheck{
					UnitNumber: in.CheckUnitNumber,
					PatientID:  in.CheckPatientID,
					CheckedBy:  session.SubjectID,
				},
				Emergency:           in.Emergency,
				EmergencyAuthoriser: in.EmergencyAuthoriser,
				EmergencyReason:     in.EmergencyReason,
			}, component, reservation, session.SubjectID, now)
		if err != nil {
			return bloodbankError(err)
		}
		if reservation != nil {
			issue.RequestID = reservation.RequestID
		}
		if err := s.crossmatch.InsertIssue(ctx, scope, issue); err != nil {
			return err
		}
		out = issue

		if reservation != nil {
			if _, err := s.crossmatch.CloseReservation(ctx, scope,
				reservation.ID, domain.ReservationIssued, ""); err != nil {
				return err
			}
		}
		component.Status = domain.UnitIssued
		if err := s.inventory.UpdateStatus(
			ctx, scope, component, component.Version); err != nil {
			return bloodbankError(err)
		}

		eventType := EventUnitIssued
		if issue.Emergency {
			eventType = EventEmergencyRelease
		}
		if err := s.appendEvent(ctx, session, eventType,
			"bloodbank_component", component.ID, map[string]any{
				"unit_number": component.UnitNumber,
				"patient_id":  issue.PatientID,
				"destination": issue.Destination,
				"emergency":   issue.Emergency,
				"authoriser":  issue.EmergencyAuthoriser,
			}, now); err != nil {
			return err
		}

		reason := "issued unit " + component.UnitNumber + " to " + issue.Destination
		if issue.Emergency {
			reason = "emergency release of unit " + component.UnitNumber +
				" authorised by " + issue.EmergencyAuthoriser + ": " +
				issue.EmergencyReason
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: permission,
			ResourceType: "bloodbank_component", ResourceID: component.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.Issue{}, err
	}
	return out, nil
}

// ReconcileRelease completes an emergency release's retrospective crossmatch
// (SRS-BLD-016).
func (s *Service) ReconcileRelease(ctx context.Context, issueID, note string) error {
	session, scope, err := s.authorize(ctx, PermCrossmatch)
	if err != nil {
		return err
	}
	now := s.clock.Now()

	if note == "" {
		return rpcerr.Invalid("BLD_INVALID",
			"reconciliation records the retrospective result")
	}

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		done, err := s.crossmatch.Reconcile(
			ctx, scope, issueID, note, session.SubjectID, now)
		if err != nil {
			return err
		}
		if !done {
			return rpcerr.FailedPrecondition("BLD_NOT_RECONCILABLE",
				"this is not an outstanding emergency release")
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermCrossmatch,
			ResourceType: "bloodbank_issue", ResourceID: issueID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "emergency release reconciled: " + note,
		}, now)
	})
}

// OutstandingReleases are the emergency releases nobody has reconciled
// (SRS-BLD-016).
func (s *Service) OutstandingReleases(ctx context.Context, limit int32) (
	[]domain.Issue, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.crossmatch.Unreconciled(ctx, scope, clampPageSize(limit))
}
