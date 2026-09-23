// Package transport translates between the mortuary contract and the domain.
//
// The enum maps are one-way tables in both directions rather than casts,
// because the wire enum and the domain constant are allowed to diverge and a
// cast would hide it. Reverse maps are built in init() from the forward ones,
// so a value added to one direction cannot be forgotten in the other.
//
// Every default fails in the safe direction. An unrecognised identity stays
// empty and the domain refuses it rather than defaulting to "confirmed",
// which would let a body be released on a hypothesis; an unrecognised source
// stays empty rather than becoming "brought_in", which would let an
// in-hospital death lose its link to the encounter that explains it; an
// unrecognised item kind stays empty rather than becoming "other", which
// would let a gold ring be listed without a witness or a seal.
package transport

import (
	"time"

	"google.golang.org/protobuf/types/known/timestamppb"

	mortuaryv1 "github.com/ppusapati/health/code/gen/go/healthcare/mortuary/v1"
	"github.com/ppusapati/health/code/internal/mortuary/domain"
)

func stamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		// Absent rather than the epoch: a zero timestamp reads as 1970 on
		// the wire, and a body received in 1970 is one every board shows
		// as held for fifty years.
		return nil
	}
	return timestamppb.New(t.UTC())
}

func timeOf(t *timestamppb.Timestamp) time.Time {
	if t == nil {
		return time.Time{}
	}
	return t.AsTime().UTC()
}

var sourceFromWire = map[mortuaryv1.Source]domain.Source{
	mortuaryv1.Source_SOURCE_IN_HOSPITAL: domain.SourceInHospital,
	mortuaryv1.Source_SOURCE_BROUGHT_IN:  domain.SourceBroughtIn,
}

var identityFromWire = map[mortuaryv1.Identity]domain.Identity{
	mortuaryv1.Identity_IDENTITY_UNIDENTIFIED: domain.IdentityUnidentified,
	mortuaryv1.Identity_IDENTITY_PRESUMED:     domain.IdentityPresumed,
	mortuaryv1.Identity_IDENTITY_CONFIRMED:    domain.IdentityConfirmed,
}

var caseStateFromWire = map[mortuaryv1.CaseState]domain.CaseState{
	mortuaryv1.CaseState_CASE_STATE_RECEIVED: domain.CaseReceived,
	mortuaryv1.CaseState_CASE_STATE_STORED:   domain.CaseStored,
	mortuaryv1.CaseState_CASE_STATE_RELEASED: domain.CaseReleased,
}

var spaceKindFromWire = map[mortuaryv1.SpaceKind]domain.SpaceKind{
	mortuaryv1.SpaceKind_SPACE_KIND_REFRIGERATED: domain.SpaceRefrigerated,
	mortuaryv1.SpaceKind_SPACE_KIND_FREEZER:      domain.SpaceFreezer,
	mortuaryv1.SpaceKind_SPACE_KIND_VIEWING:      domain.SpaceViewing,
	mortuaryv1.SpaceKind_SPACE_KIND_POSTMORTEM:   domain.SpacePostmortem,
}

var placementStateFromWire = map[mortuaryv1.PlacementState]domain.PlacementState{
	mortuaryv1.PlacementState_PLACEMENT_STATE_CURRENT: domain.PlacementCurrent,
	mortuaryv1.PlacementState_PLACEMENT_STATE_ENDED:   domain.PlacementEnded,
}

var itemKindFromWire = map[mortuaryv1.ItemKind]domain.ItemKind{
	mortuaryv1.ItemKind_ITEM_KIND_VALUABLE: domain.ItemValuable,
	mortuaryv1.ItemKind_ITEM_KIND_DOCUMENT: domain.ItemDocument,
	mortuaryv1.ItemKind_ITEM_KIND_CLOTHING: domain.ItemClothing,
	mortuaryv1.ItemKind_ITEM_KIND_OTHER:    domain.ItemOther,
}

var itemStateFromWire = map[mortuaryv1.ItemState]domain.ItemState{
	mortuaryv1.ItemState_ITEM_STATE_HELD:        domain.ItemHeld,
	mortuaryv1.ItemState_ITEM_STATE_HANDED_OVER: domain.ItemHandedOver,
	mortuaryv1.ItemState_ITEM_STATE_RETAINED:    domain.ItemRetained,
}

var postmortemKindFromWire = map[mortuaryv1.PostmortemKind]domain.PostmortemKind{
	mortuaryv1.PostmortemKind_POSTMORTEM_KIND_CLINICAL:     domain.PostmortemClinical,
	mortuaryv1.PostmortemKind_POSTMORTEM_KIND_MEDICO_LEGAL: domain.PostmortemMedicoLegal,
}

var postmortemStateFromWire = map[mortuaryv1.PostmortemState]domain.PostmortemState{
	mortuaryv1.PostmortemState_POSTMORTEM_STATE_REQUESTED:  domain.PostmortemRequested,
	mortuaryv1.PostmortemState_POSTMORTEM_STATE_AUTHORISED: domain.PostmortemAuthorised,
	mortuaryv1.PostmortemState_POSTMORTEM_STATE_PERFORMED:  domain.PostmortemPerformed,
	mortuaryv1.PostmortemState_POSTMORTEM_STATE_REPORTED:   domain.PostmortemReported,
	mortuaryv1.PostmortemState_POSTMORTEM_STATE_DECLINED:   domain.PostmortemDeclined,
}

var (
	sourceToWire          = map[domain.Source]mortuaryv1.Source{}
	identityToWire        = map[domain.Identity]mortuaryv1.Identity{}
	caseStateToWire       = map[domain.CaseState]mortuaryv1.CaseState{}
	spaceKindToWire       = map[domain.SpaceKind]mortuaryv1.SpaceKind{}
	placementStateToWire  = map[domain.PlacementState]mortuaryv1.PlacementState{}
	itemKindToWire        = map[domain.ItemKind]mortuaryv1.ItemKind{}
	itemStateToWire       = map[domain.ItemState]mortuaryv1.ItemState{}
	postmortemKindToWire  = map[domain.PostmortemKind]mortuaryv1.PostmortemKind{}
	postmortemStateToWire = map[domain.PostmortemState]mortuaryv1.PostmortemState{}
)

func init() {
	for wire, value := range sourceFromWire {
		sourceToWire[value] = wire
	}
	for wire, value := range identityFromWire {
		identityToWire[value] = wire
	}
	for wire, value := range caseStateFromWire {
		caseStateToWire[value] = wire
	}
	for wire, value := range spaceKindFromWire {
		spaceKindToWire[value] = wire
	}
	for wire, value := range placementStateFromWire {
		placementStateToWire[value] = wire
	}
	for wire, value := range itemKindFromWire {
		itemKindToWire[value] = wire
	}
	for wire, value := range itemStateFromWire {
		itemStateToWire[value] = wire
	}
	for wire, value := range postmortemKindFromWire {
		postmortemKindToWire[value] = wire
	}
	for wire, value := range postmortemStateFromWire {
		postmortemStateToWire[value] = wire
	}
}

// caseToWire carries whatever the service handed back. The service is what
// redacts, so a caller without mort.sensitive.read gets a case whose cause
// and medico-legal reference are already empty — the mapping does not decide,
// because two places deciding is one place forgetting.
func caseToWire(c domain.Case) *mortuaryv1.Case {
	return &mortuaryv1.Case{
		CaseId: c.ID, Reference: c.Reference,
		Source: sourceToWire[c.Source], EncounterId: c.EncounterID,
		PatientId: c.PatientID, ExternalSource: c.ExternalSource,
		Identity:       identityToWire[c.Identity],
		IdentifiedBy:   c.IdentifiedBy,
		IdentifiedAt:   stamp(c.IdentifiedAt),
		IdentifiedNote: c.IdentifiedNote,
		DisplayName:    c.DisplayName,
		MedicoLegal:    c.MedicoLegal, MlcReference: c.MLCReference,
		Restricted: c.Restricted, CauseSummary: c.CauseSummary,
		DeathCertificateRef:   c.DeathCertificateRef,
		CertificateRecordedBy: c.CertificateRecordedBy,
		CertificateRecordedAt: stamp(c.CertificateRecordedAt),
		State:                 caseStateToWire[c.State],
		LocationId:            c.LocationID, StorageTag: c.StorageTag,
		DiedAt: stamp(c.DiedAt), ReceivedAt: stamp(c.ReceivedAt),
		ReceivedBy: c.ReceivedBy, FacilityId: c.FacilityID,
		Version: c.Version,
	}
}

func casesToWire(cases []domain.Case) []*mortuaryv1.Case {
	out := make([]*mortuaryv1.Case, 0, len(cases))
	for _, c := range cases {
		out = append(out, caseToWire(c))
	}
	return out
}

func locationToWire(l domain.Location) *mortuaryv1.Location {
	return &mortuaryv1.Location{
		LocationId: l.ID, Code: l.Code,
		Kind: spaceKindToWire[l.Kind], FacilityId: l.FacilityID,
		Zone: l.Zone, OutOfService: l.OutOfService,
		OutOfServiceReason: l.OutOfServiceReason, Version: l.Version,
	}
}

func placementToWire(p domain.Placement) *mortuaryv1.Placement {
	return &mortuaryv1.Placement{
		PlacementId: p.ID, CaseId: p.CaseID,
		LocationId: p.LocationID, StorageTag: p.StorageTag,
		State:               placementStateToWire[p.State],
		IdentityCheckedBy:   p.IdentityCheckedBy,
		IdentityCheckedNote: p.IdentityCheckedNote,
		PlacedAt:            stamp(p.PlacedAt), PlacedBy: p.PlacedBy,
		EndedAt: stamp(p.EndedAt), EndedBy: p.EndedBy,
		EndedReason: p.EndedReason,
	}
}

func itemToWire(i domain.Item) *mortuaryv1.Item {
	return &mortuaryv1.Item{
		ItemId: i.ID, CaseId: i.CaseID,
		Kind: itemKindToWire[i.Kind], Description: i.Description,
		Quantity: int32(i.Quantity), State: itemStateToWire[i.State],
		SealNumber: i.SealNumber,
		ListedAt:   stamp(i.ListedAt), ListedBy: i.ListedBy,
		WitnessedBy: i.WitnessedBy, HandoverId: i.HandoverID,
	}
}

func handoverToWire(h domain.Handover) *mortuaryv1.Handover {
	return &mortuaryv1.Handover{
		HandoverId: h.ID, CaseId: h.CaseID,
		RecipientName:     h.RecipientName,
		RecipientRelation: h.RecipientRelation,
		RecipientIdType:   h.RecipientIDType,
		RecipientIdRef:    h.RecipientIDRef,
		SignatureRef:      h.SignatureRef, ItemIds: h.ItemIDs,
		HandedAt: stamp(h.HandedAt), HandedBy: h.HandedBy,
		WitnessedBy: h.WitnessedBy, Note: h.Note,
	}
}

func custodyToWire(e domain.CustodyEntry) *mortuaryv1.CustodyEntry {
	return &mortuaryv1.CustodyEntry{
		EntryId: e.ID, CaseId: e.CaseID, Event: e.Event,
		Detail: e.Detail, FromParty: e.FromParty, ToParty: e.ToParty,
		RecordedAt: stamp(e.RecordedAt), RecordedBy: e.RecordedBy,
	}
}

func postmortemToWire(p domain.Postmortem) *mortuaryv1.Postmortem {
	return &mortuaryv1.Postmortem{
		PostmortemId: p.ID, CaseId: p.CaseID,
		Kind: postmortemKindToWire[p.Kind], Reason: p.Reason,
		State: postmortemStateToWire[p.State], Authority: p.Authority,
		AuthorityReference: p.AuthorityReference,
		AuthorisedBy:       p.AuthorisedBy,
		AuthorisedAt:       stamp(p.AuthorisedAt),
		PerformedBy:        p.PerformedBy,
		PerformedAt:        stamp(p.PerformedAt),
		ReportRef:          p.ReportRef,
		ReportedAt:         stamp(p.ReportedAt),
		DeclineReason:      p.DeclineReason,
		RequestedAt:        stamp(p.RequestedAt),
		RequestedBy:        p.RequestedBy, Version: p.Version,
	}
}

func authorisationToWire(a domain.Authorisation) *mortuaryv1.Authorisation {
	return &mortuaryv1.Authorisation{
		Authority: a.Authority, Reference: a.Reference,
		RecordedBy: a.RecordedBy, RecordedAt: stamp(a.RecordedAt),
		Note: a.Note,
	}
}

func checksToWire(checks []domain.ReleaseCheck) []*mortuaryv1.ReleaseCheck {
	out := make([]*mortuaryv1.ReleaseCheck, 0, len(checks))
	for _, check := range checks {
		out = append(out, &mortuaryv1.ReleaseCheck{
			Code: check.Code, Detail: check.Detail,
			Mandatory: check.Mandatory,
		})
	}
	return out
}

func releaseToWire(r domain.Release) *mortuaryv1.Release {
	return &mortuaryv1.Release{
		ReleaseId: r.ID, CaseId: r.CaseID,
		RecipientName:     r.RecipientName,
		RecipientRelation: r.RecipientRelation,
		RecipientIdType:   r.RecipientIDType,
		RecipientIdRef:    r.RecipientIDRef,
		VerificationNote:  r.VerificationNote,
		SignatureRef:      r.SignatureRef, Destination: r.Destination,
		DeathCertificateRef: r.DeathCertificateRef,
		MedicoLegal:         r.MedicoLegal, Authority: r.Authority,
		AuthorityReference: r.AuthorityReference,
		ReleasedAt:         stamp(r.ReleasedAt), ReleasedBy: r.ReleasedBy,
		WitnessedBy: r.WitnessedBy, Note: r.Note,
	}
}

// boardToWire projects the board. The message has no field for a cause of
// death, which is the point: a screen cannot show what the contract does not
// carry.
func boardToWire(rows []domain.Board) []*mortuaryv1.BoardRow {
	out := make([]*mortuaryv1.BoardRow, 0, len(rows))
	for _, row := range rows {
		out = append(out, &mortuaryv1.BoardRow{
			CaseId: row.CaseID, Reference: row.Reference,
			LocationId: row.LocationID, StorageTag: row.StorageTag,
			State:          caseStateToWire[row.State],
			DisplayName:    row.DisplayName,
			MedicoLegal:    row.MedicoLegal,
			Identity:       identityToWire[row.Identity],
			ReceivedAt:     stamp(row.ReceivedAt),
			HeldHours:      int32(row.HeldHours),
			PendingRelease: row.PendingRelease,
		})
	}
	return out
}

func occupancyToWire(o domain.Occupancy) *mortuaryv1.Occupancy {
	free := make(map[string]int32, len(o.FreeByKind))
	for kind, count := range o.FreeByKind {
		free[string(kind)] = int32(count)
	}
	return &mortuaryv1.Occupancy{
		Total: int32(o.Total), InService: int32(o.InService),
		Occupied: int32(o.Occupied), Free: int32(o.Free),
		FreeByKind: free, OutOfService: int32(o.OutOfService),
	}
}

func textsFromWire[W comparable, D ~string](wire []W,
	table map[W]D) []string {

	out := make([]string, 0, len(wire))
	for _, value := range wire {
		out = append(out, string(table[value]))
	}
	return out
}
