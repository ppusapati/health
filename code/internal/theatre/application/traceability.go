package application

import (
	"context"
	"strconv"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/theatre/domain"
	"github.com/ppusapati/health/code/internal/theatre/ports"
)

// Consumables and implants (SRS-OT-010), specimens (SRS-OT-011), instrument
// trays (SRS-OT-012), the command board (SRS-OT-013), utilisation
// (SRS-OT-015) and preference cards (SRS-OT-016).

// UsageInput records an item used in a case.
type UsageInput struct {
	CaseID       string
	Kind         domain.UsageKind
	ItemCode     string
	ItemName     string
	LotNumber    string
	SerialNumber string
	Quantity     int
	ExpiryDate   time.Time
	Scanned      bool
	ScanData     string
}

// RecordUsage records a consumable or implant (SRS-OT-010).
func (s *Service) RecordUsage(ctx context.Context, in UsageInput) (domain.Usage, error) {
	session, scope, err := s.authorize(ctx, PermRecord)
	if err != nil {
		return domain.Usage{}, err
	}

	now := s.clock.Now()
	var out domain.Usage

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		c, err := s.schedule.Case(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}

		usage, err := domain.RecordUsage(s.ids.NewID(), scope.TenantID(),
			domain.NewUsageInput{
				CaseID: c.ID, Kind: in.Kind, ItemCode: in.ItemCode,
				ItemName: in.ItemName, LotNumber: in.LotNumber,
				SerialNumber: in.SerialNumber, Quantity: in.Quantity,
				ExpiryDate: in.ExpiryDate, Scanned: in.Scanned,
				ScanData: in.ScanData,
			}, session.SubjectID, now)
		if err != nil {
			return theatreError(err)
		}
		if err := s.cases.InsertUsage(ctx, scope, usage); err != nil {
			return err
		}

		// An implant is announced. Materials decrements stock from it
		// (SRS-MAT), billing raises the charge (SRS-BIL), and the implant
		// registry is what a recall is worked from — three contexts, none of
		// which should be reading the theatre schema.
		if usage.Kind == domain.UsageImplant {
			if err := s.appendEvent(ctx, session, EventImplantUsed,
				"theatre_usage", usage.ID, map[string]any{
					"usage_id":      usage.ID,
					"case_id":       c.ID,
					"patient_id":    c.PatientID,
					"encounter_id":  c.EncounterID,
					"facility_id":   c.FacilityID,
					"item_code":     usage.ItemCode,
					"lot_number":    usage.LotNumber,
					"serial_number": usage.SerialNumber,
					"scanned":       usage.Scanned,
					"used_at":       usage.RecordedAt.Format(time.RFC3339),
				}, now); err != nil {
				return err
			}
		}

		out = usage
		// An implant, or an item used past its expiry date, is audited. An
		// expired item used in an emergency is a governance event that has to
		// be findable afterwards; an ordinary swab is not.
		if usage.Kind != domain.UsageImplant && !usage.Expired(now) {
			return nil
		}
		reason := "implant recorded: " + usage.ItemCode
		if usage.Expired(now) {
			reason = "EXPIRED item used: " + usage.ItemCode +
				", expired " + usage.ExpiryDate.Format(time.DateOnly)
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermRecord,
			ResourceType: "theatre_usage", ResourceID: usage.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.Usage{}, err
	}
	return out, nil
}

// Usage reads what a case used.
func (s *Service) Usage(ctx context.Context, caseID string) ([]domain.Usage, error) {
	_, scope, err := s.authorize(ctx, PermTheatreRead)
	if err != nil {
		return nil, err
	}
	return s.cases.Usage(ctx, scope, caseID)
}

// Recall finds every patient who received an implant (SRS-OT-010).
//
// Its own permission and its own audit entry, because it reaches across
// patients rather than into one chart. A recall is a legitimate reason to do
// that and a fishing expedition looks identical, so the entry names the item
// and how many patients it reached.
func (s *Service) Recall(ctx context.Context, itemCode, lotNumber string) (
	[]ports.Recipient, error) {

	session, scope, err := s.authorize(ctx, PermTrace)
	if err != nil {
		return nil, err
	}
	if trimmed(itemCode) == "" {
		return nil, rpcerr.Invalid("OT_RECALL_NEEDS_AN_ITEM",
			"a recall names the item")
	}

	now := s.clock.Now()
	var out []ports.Recipient

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		recipients, err := s.cases.ImplantRecipients(ctx, scope, itemCode, lotNumber)
		if err != nil {
			return err
		}
		out = recipients

		reason := "implant recall search: " + itemCode
		if lotNumber != "" {
			reason += " lot " + lotNumber
		}
		reason += ", " + countWord(len(recipients)) + " reached"
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermTrace,
			ResourceType: "theatre_implant", ResourceID: itemCode,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// countWord renders how many patients a trace reached, for the audit entry.
func countWord(n int) string {
	if n == 1 {
		return "1 patient"
	}
	return strconv.Itoa(n) + " patients"
}

// SpecimenInput records a specimen taken in theatre.
type SpecimenInput struct {
	CaseID    string
	Label     string
	Site      string
	Container string
	Fixative  string
	TakenAt   time.Time
}

// TakeSpecimen records a specimen (SRS-OT-011).
//
// The patient and the laterality come from the case rather than the caller, so
// a left-sided case cannot produce a right-sided specimen and a pot cannot be
// labelled with somebody else's patient.
func (s *Service) TakeSpecimen(ctx context.Context, in SpecimenInput) (
	domain.Specimen, error) {

	session, scope, err := s.authorize(ctx, PermRecord)
	if err != nil {
		return domain.Specimen{}, err
	}

	now := s.clock.Now()
	var out domain.Specimen

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		c, err := s.schedule.Case(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}

		specimen, err := domain.TakeSpecimen(s.ids.NewID(), scope.TenantID(),
			domain.NewSpecimenInput{
				CaseID: c.ID, PatientID: c.PatientID, Label: in.Label,
				Site: trimmed(in.Site, c.Site), Laterality: c.Laterality,
				Container: in.Container, Fixative: in.Fixative,
				TakenAt: in.TakenAt,
			}, session.SubjectID, now)
		if err != nil {
			return theatreError(err)
		}
		if err := s.cases.InsertSpecimen(ctx, scope, specimen); err != nil {
			return err
		}

		// The diagnostics context raises the order from this. SRS-OT-011's
		// clause is that the chain starts from the procedure with the correct
		// patient and site, and an event is how it starts without the
		// laboratory reading the theatre schema.
		if err := s.appendEvent(ctx, session, EventSpecimenTaken,
			"theatre_specimen", specimen.ID, map[string]any{
				"specimen_id":  specimen.ID,
				"case_id":      c.ID,
				"patient_id":   c.PatientID,
				"encounter_id": c.EncounterID,
				"facility_id":  c.FacilityID,
				"site":         specimen.Site,
				"laterality":   string(specimen.Laterality),
				"taken_at":     specimen.TakenAt.Format(time.RFC3339),
			}, now); err != nil {
			return err
		}

		out = specimen
		return nil
	})
	if err != nil {
		return domain.Specimen{}, err
	}
	return out, nil
}

// Accession links a specimen to the diagnostic order raised for it
// (SRS-OT-011).
func (s *Service) Accession(ctx context.Context, specimenID, orderID string) error {
	session, scope, err := s.authorize(ctx, PermRecord)
	if err != nil {
		return err
	}
	if trimmed(orderID) == "" {
		return rpcerr.Invalid("OT_ACCESSION_NEEDS_AN_ORDER",
			"an accession names the order")
	}

	now := s.clock.Now()
	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		linked, err := s.cases.Accession(ctx, scope, specimenID, orderID)
		if err != nil {
			return err
		}
		if !linked {
			// Already linked, or no such specimen. Refused rather than
			// silently accepted, because two orders claiming one pot is how a
			// result is reported against the wrong request.
			return rpcerr.FailedPrecondition("OT_SPECIMEN_ALREADY_ACCESSIONED",
				"this specimen already has an order, or there is no such specimen")
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermRecord,
			ResourceType: "theatre_specimen", ResourceID: specimenID,
			Outcome: audit.OutcomeSuccess, Reason: "accessioned to order " + orderID,
		}, now)
	})
}

// Specimens reads a case's specimens.
func (s *Service) Specimens(ctx context.Context, caseID string) (
	[]domain.Specimen, error) {

	_, scope, err := s.authorize(ctx, PermTheatreRead)
	if err != nil {
		return nil, err
	}
	return s.cases.Specimens(ctx, scope, caseID)
}

// OutstandingSpecimens is the theatre's unstarted chain (SRS-OT-011).
func (s *Service) OutstandingSpecimens(ctx context.Context, facilityID string,
	pageSize int32) ([]domain.Specimen, error) {

	session, scope, err := s.authorize(ctx, PermTheatreRead)
	if err != nil {
		return nil, err
	}
	return s.cases.UnaccessionedSpecimens(ctx, scope,
		trimmed(facilityID, session.ActiveFacilityID), clampPageSize(pageSize))
}

// TrayInput records a sterile set being opened.
type TrayInput struct {
	CaseID          string
	TrayID          string
	TrayName        string
	CycleID         string
	IndicatorPassed bool
	IndicatorNote   string
}

// OpenTray records a sterile set opened for a case (SRS-OT-012).
func (s *Service) OpenTray(ctx context.Context, in TrayInput) (domain.TrayUse, error) {
	session, scope, err := s.authorize(ctx, PermRecord)
	if err != nil {
		return domain.TrayUse{}, err
	}

	now := s.clock.Now()
	var out domain.TrayUse

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		c, err := s.schedule.Case(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}

		use, err := domain.OpenTray(s.ids.NewID(), scope.TenantID(), c.ID,
			in.TrayID, in.TrayName, in.CycleID, in.IndicatorPassed,
			in.IndicatorNote, session.SubjectID, now)
		if err != nil {
			return theatreError(err)
		}
		if err := s.cases.InsertTrayUse(ctx, scope, use); err != nil {
			return err
		}

		eventType := EventTrayOpened
		if !use.IndicatorPassed {
			// A failed sterilisation indicator is CSSD's business and
			// infection prevention's, and both need to hear it without
			// reading the theatre schema.
			eventType = EventIndicatorFailed
		}
		if err := s.appendEvent(ctx, session, eventType,
			"theatre_tray_use", use.ID, map[string]any{
				"tray_use_id":      use.ID,
				"case_id":          c.ID,
				"patient_id":       c.PatientID,
				"facility_id":      c.FacilityID,
				"tray_id":          use.TrayID,
				"cycle_id":         use.CycleID,
				"indicator_passed": use.IndicatorPassed,
				"opened_at":        use.OpenedAt.Format(time.RFC3339),
			}, now); err != nil {
			return err
		}

		out = use
		if use.IndicatorPassed {
			return nil
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermRecord,
			ResourceType: "theatre_tray_use", ResourceID: use.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: "sterilisation indicator FAILED on tray " + use.TrayID +
				" from cycle " + use.CycleID + ": " + use.IndicatorNote,
		}, now)
	})
	if err != nil {
		return domain.TrayUse{}, err
	}
	return out, nil
}

// TrayUses reads a case's opened sets.
func (s *Service) TrayUses(ctx context.Context, caseID string) (
	[]domain.TrayUse, error) {

	_, scope, err := s.authorize(ctx, PermTheatreRead)
	if err != nil {
		return nil, err
	}
	return s.cases.TrayUses(ctx, scope, caseID)
}

// TraceCycle finds every patient a sterilisation cycle reached (SRS-OT-012).
//
// The direction an infection investigation runs, and audited for the same
// reason a recall is: it reaches across patients rather than into one chart.
func (s *Service) TraceCycle(ctx context.Context, cycleID string) (
	[]ports.Recipient, error) {

	session, scope, err := s.authorize(ctx, PermTrace)
	if err != nil {
		return nil, err
	}
	if trimmed(cycleID) == "" {
		return nil, rpcerr.Invalid("OT_TRACE_NEEDS_A_CYCLE",
			"a trace names the sterilisation cycle")
	}

	now := s.clock.Now()
	var out []ports.Recipient

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		recipients, err := s.cases.CycleRecipients(ctx, scope, cycleID)
		if err != nil {
			return err
		}
		out = recipients
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermTrace,
			ResourceType: "theatre_cycle", ResourceID: cycleID,
			Outcome: audit.OutcomeSuccess,
			Reason: "sterilisation cycle trace: " + cycleID + ", " +
				countWord(len(recipients)) + " reached",
		}, now)
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// CardInput saves a preference card.
type CardInput struct {
	SurgeonID     string
	ProcedureCode string
	Name          string
	Equipment     []string
	Consumables   []domain.CardItem
	Trays         []string
	Notes         string
}

// SaveCard saves a surgeon's preference card (SRS-OT-016).
func (s *Service) SaveCard(ctx context.Context, in CardInput) (
	domain.PreferenceCard, error) {

	session, scope, err := s.authorize(ctx, PermConfigure)
	if err != nil {
		return domain.PreferenceCard{}, err
	}
	if trimmed(in.SurgeonID) == "" || trimmed(in.ProcedureCode) == "" {
		return domain.PreferenceCard{}, rpcerr.Invalid("OT_CARD_NEEDS_A_KEY",
			"a preference card names a surgeon and a procedure")
	}

	now := s.clock.Now()
	card := domain.PreferenceCard{
		ID: s.ids.NewID(), TenantID: scope.TenantID(),
		SurgeonID: in.SurgeonID, ProcedureCode: in.ProcedureCode, Name: in.Name,
		Equipment: in.Equipment, Consumables: in.Consumables, Trays: in.Trays,
		Notes: in.Notes, UpdatedAt: now, UpdatedBy: session.SubjectID,
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		return s.cases.SaveCard(ctx, scope, card)
	})
	if err != nil {
		return domain.PreferenceCard{}, err
	}
	return card, nil
}

// Card reads a surgeon's card for a procedure.
func (s *Service) Card(ctx context.Context, surgeonID, procedureCode string) (
	domain.PreferenceCard, bool, error) {

	_, scope, err := s.authorize(ctx, PermTheatreRead)
	if err != nil {
		return domain.PreferenceCard{}, false, err
	}
	return s.cases.Card(ctx, scope, surgeonID, procedureCode)
}

// Board assembles the command board (SRS-OT-013).
func (s *Service) Board(ctx context.Context, facilityID string, now time.Time) (
	[]domain.BoardRow, error) {

	session, scope, err := s.authorize(ctx, PermTheatreRead)
	if err != nil {
		return nil, err
	}
	facility := trimmed(facilityID, session.ActiveFacilityID)
	if now.IsZero() {
		now = s.clock.Now()
	}

	rooms, err := s.schedule.Rooms(ctx, scope, facility)
	if err != nil {
		return nil, err
	}

	// The theatre day, wide enough to hold a list that started early and one
	// that overran.
	from := now.Add(-16 * time.Hour)
	to := now.Add(16 * time.Hour)

	blocks, err := s.schedule.Blocks(ctx, scope, facility, from, to)
	if err != nil {
		return nil, err
	}

	inputs := make([]domain.BoardInput, 0, len(rooms))
	var everyCase []string

	perRoom := map[string][]domain.Case{}
	for _, room := range rooms {
		cases, err := s.schedule.RoomCases(ctx, scope, room.ID, from, to)
		if err != nil {
			return nil, err
		}
		perRoom[room.ID] = cases
		for _, c := range cases {
			everyCase = append(everyCase, c.ID)
		}
	}

	milestones, err := s.cases.MilestonesFor(ctx, scope, everyCase)
	if err != nil {
		return nil, err
	}
	delays, err := s.cases.DelaysFor(ctx, scope, everyCase)
	if err != nil {
		return nil, err
	}

	delayMinutes := map[string]int{}
	for id, list := range delays {
		for _, delay := range list {
			delayMinutes[id] += delay.Minutes
		}
	}

	items := s.config.preopItems()
	blockers := map[string][]domain.Blocker{}
	for _, cases := range perRoom {
		for _, c := range cases {
			// Only the cases that have not started: the board's blocker column
			// is about the next case, and reading a checklist per finished
			// case would be a query for nothing.
			if c.Status != domain.CaseScheduled && c.Status != domain.CaseReady {
				continue
			}
			checklist, err := s.cases.PreopChecklist(ctx, scope, c.ID)
			if err != nil {
				return nil, err
			}
			blockers[c.ID] = checklist.Blockers(items)
		}
	}

	for _, room := range rooms {
		closed := false
		for _, block := range blocks {
			if block.RoomID == room.ID && block.Kind == domain.BlockDowntime &&
				block.Covers(now) {
				closed = true
			}
		}
		inputs = append(inputs, domain.BoardInput{
			Room: room, Cases: perRoom[room.ID], Milestones: milestones,
			Delays: delayMinutes, Blockers: blockers, Closed: closed,
		})
	}

	return domain.BuildBoard(inputs, now), nil
}

// Utilisation reports a room's numbers for a period (SRS-OT-015).
func (s *Service) Utilisation(ctx context.Context, roomID string,
	from, to time.Time) (domain.Utilisation, error) {

	_, scope, err := s.authorize(ctx, PermTheatreRead)
	if err != nil {
		return domain.Utilisation{}, err
	}
	if !to.After(from) {
		return domain.Utilisation{}, rpcerr.Invalid("OT_BAD_PERIOD",
			"the period ends before it starts")
	}

	room, err := s.schedule.Room(ctx, scope, roomID)
	if err != nil {
		return domain.Utilisation{}, err
	}
	cases, err := s.schedule.RoomCases(ctx, scope, roomID, from, to)
	if err != nil {
		return domain.Utilisation{}, err
	}

	ids := make([]string, 0, len(cases))
	for _, c := range cases {
		ids = append(ids, c.ID)
	}
	milestones, err := s.cases.MilestonesFor(ctx, scope, ids)
	if err != nil {
		return domain.Utilisation{}, err
	}
	delays, err := s.cases.DelaysFor(ctx, scope, ids)
	if err != nil {
		return domain.Utilisation{}, err
	}
	blocks, err := s.schedule.Blocks(ctx, scope, room.FacilityID, from, to)
	if err != nil {
		return domain.Utilisation{}, err
	}

	return domain.ComputeUtilisation(roomID, from, to, cases, milestones, delays,
		blocks, s.config.OnTimeGrace), nil
}
