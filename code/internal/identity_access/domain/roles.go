// Package domain holds the identity & access context's authorization model.
//
// Roles map to permissions over bounded-context actions, not to menus
// (SRS-IAM-003). The catalogue lives in code for Wave 0 and moves to
// tenant-configurable storage in Wave 7 alongside SRS-CFG; the shape of the
// lookup is deliberately the same either way.
package domain

import (
	"sort"

	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// Role is a named bundle of permissions.
type Role string

const (
	// RolePlatformOperator provisions tenants. Deliberately separate from any
	// tenant-level admin role: provisioning is cross-tenant authority and must
	// not be reachable by escalating inside a tenant.
	RolePlatformOperator Role = "platform_operator"

	// RoleTenantAdmin configures one tenant's organization master data.
	RoleTenantAdmin Role = "tenant_admin"

	// RoleFacilityViewer reads organization master data.
	RoleFacilityViewer Role = "facility_viewer"

	// RoleAuditor reads audit trails and cannot mutate clinical or financial
	// records (SRS-IAM-014).
	RoleAuditor Role = "auditor"

	// RoleRegistrationClerk registers patients and corrects their details at a
	// front desk (Wave-1 actor "Registration").
	RoleRegistrationClerk Role = "registration_clerk"

	// RoleHIMOfficer is health information management: the people who resolve
	// duplicate identities. The Wave-1 backlog names them "Authorized HIM", and
	// merge authority is theirs alone.
	RoleHIMOfficer Role = "him_officer"

	// RoleClinician reads patient identity in the course of care.
	RoleClinician Role = "clinician"

	// RolePerformingService is a downstream context's service account
	// (SRS-ORD-006).
	//
	// A role rather than an exemption, because a laboratory information system
	// advancing an order is a subject like any other and its actions belong in
	// the same audit trail. Note what it cannot do: place an order. A
	// performing service that could place one could manufacture the work it
	// then bills for.
	RolePerformingService Role = "performing_service"

	// RoleNurse delivers and records nursing care (SRS-NUR, Wave-1 actor
	// "Nurse").
	//
	// A role of its own rather than a variant of clinician, because the two
	// permission sets are genuinely different in both directions. A nurse gives
	// medication and a doctor prescribes it; a nurse charts observations hourly
	// and a doctor rarely does; a doctor records diagnoses and signs clinical
	// documents and a nurse does not. Folding nursing into clinician would give
	// every junior doctor the restraint and administration permissions and
	// every nurse the diagnosis one, and both directions are wrong.
	RoleNurse Role = "nurse"

	// RoleNurseManager runs a ward: assignment and the acuity dashboard
	// (SRS-NUR-016, SRS-NUR-017, Wave-1 actor "Nurse Manager").
	RoleNurseManager Role = "nurse_manager"

	// RoleScheduler runs the diary: rosters, leave, theatre blocks, and the
	// authority to book into a provisional block when the list is agreed
	// (SRS-SCH-002). The Wave-1 backlog actor is "Scheduler".
	RoleScheduler Role = "scheduler"
)

// rolePermissions is the catalogue. A role absent from this table grants
// nothing, which keeps an unknown or retired role fail-closed.
var rolePermissions = map[Role][]string{
	RolePlatformOperator: {
		"organization.tenant.create",
		"organization.tenant.read",
	},
	RoleTenantAdmin: {
		"organization.tenant.read",
		"organization.facility.create",
		"organization.facility.read",
		// Configuring the demographic minimum set and the duplicate-matching
		// thresholds is tenant administration. Note what is absent: no
		// empi.patient.read. Tuning how the register behaves and looking
		// inside it are different jobs, and bundling them would put every
		// tenant admin in the patient index.
		"empi.patient.configure",
		// Note templates, shared smart phrases and the escalation policy are
		// configuration (SRS-CLN-002, SRS-CLN-012, SRS-CLN-015). Note what is
		// absent: no cln.record.read. Deciding what a note asks and reading
		// what it says are different jobs.
		"cln.record.configure",
		// Order sets, the order policy and the duplicate rules (SRS-ORD-003,
		// SRS-ORD-007, SRS-ORD-009). Institutional governance, and again not
		// bundled with reading the orders themselves: deciding what a set
		// offers and looking at who was ordered what are different jobs.
		"ord.order.configure",
		// Assessment templates, risk scales, the administration policy and the
		// acuity weights (SRS-NUR-001, SRS-NUR-005, SRS-NUR-008, SRS-NUR-016).
		// Note what is absent again: no nur.record.read. Deciding what a ward
		// measures and reading what it measured are different jobs.
		"nur.record.configure",
		// Rosters are tenant administration for the same reason: deciding when
		// a clinic runs is configuration, and it is deliberately not bundled
		// with the ability to look inside the diary at who is coming.
		"sch.schedule.configure",
		// What a facility requires before an encounter can be closed
		// (SRS-ENC-008). Configuration, and again not bundled with reading the
		// encounters themselves.
		"enc.encounter.configure",
	},
	RoleScheduler: {
		"organization.facility.read",
		"empi.patient.read",
		"sch.schedule.configure",
		"sch.schedule.read",
		"sch.appointment.book",
		"sch.appointment.manage",
		// Booking into a provisional block, which is what a scheduler does
		// when a theatre list is agreed. It never reaches annual leave: that
		// block is not overridable at all, whoever asks.
		"sch.schedule.override",
	},
	RoleFacilityViewer: {
		"organization.facility.read",
	},
	RoleAuditor: {
		"platform.audit.read",
		"organization.tenant.read",
		"organization.facility.read",
	},

	// A clerk registers, searches and corrects. Deliberately no merge: merging
	// fuses two people's records, and the person who created a duplicate at a
	// busy desk is the last one who should resolve it unreviewed.
	//
	// Also no read_restricted. A clerk comparing duplicates sees a masked
	// candidate — enough to confirm the phone number the patient just read out,
	// not enough to use the screen as a directory (SRS-EMPI-003).
	RoleRegistrationClerk: {
		"empi.patient.create",
		"empi.patient.read",
		"empi.patient.update",
		"empi.patient.manage",
		"organization.facility.read",
		// The front desk books, reschedules and checks patients in. It does
		// not define rosters: a receptionist who could rewrite the clinic's
		// availability is one mis-click from a clinician's Tuesday vanishing.
		"sch.schedule.read",
		"sch.appointment.book",
		"sch.appointment.manage",
		// The desk opens the visit when the patient arrives and reads the list
		// of who is in. It never records a diagnosis: what is wrong with the
		// patient is a clinical act, and behind one permission every
		// receptionist could enter one under their own name.
		"enc.encounter.read",
		"enc.encounter.manage",
		// Typing a dictated note is data entry, and a ward clerk does it.
		// Signing it is not: that is the clinician's assertion, and it is a
		// separate permission the desk does not hold (SRS-CLN-009).
		//
		// Deliberately no cln.record.read: a clerk who could read the chart
		// would have the whole clinical record of every patient they book.
		"cln.record.write",
	},

	// HIM resolves identities. They hold merge and unrestricted read, because
	// deciding whether two records are one person needs the unmasked detail
	// that a clerk is deliberately denied.
	RoleHIMOfficer: {
		"empi.patient.read",
		"empi.patient.read_restricted",
		"empi.patient.update",
		"empi.patient.manage",
		"empi.patient.merge",
		"organization.facility.read",
		// Marking an order entered-in-error (SRS-ORD-005). Health information
		// management's, not the ward's: saying a record was never true is a
		// statement about the record rather than about the patient, and it is
		// the same authority that resolves a merge.
		"ord.order.read",
		"ord.order.retract",
	},

	// A clinician reads identity to confirm they have the right patient in
	// front of them, unmasked, and does not administer it.
	RoleClinician: {
		"empi.patient.read",
		"empi.patient.read_restricted",
		"organization.facility.read",
		// A clinician reads their own diary and drives the queue in front of
		// them — calling the next patient in, ending a consultation. They do
		// not book: that is the desk's job and the patient's.
		"sch.schedule.read",
		"sch.appointment.manage",
		// Reprioritising a queue on medical grounds is theirs alone
		// (SRS-SCH-011), and a correction to a status recorded in error is a
		// clinical judgement about what actually happened.
		"sch.appointment.correct",
		// The consultation itself: run the encounter, record what is wrong,
		// and close it with a summary.
		"enc.encounter.read",
		"enc.encounter.manage",
		"enc.diagnosis.record",
		"enc.encounter.close",
		// Closing over an incomplete record where policy allows it
		// (SRS-ENC-008). A separate permission so a hospital can withhold it
		// from junior staff, but the control that actually bites is the
		// mandatory reason and the report it feeds: an emergency department
		// that cannot close a resuscitation until the notes are perfect will
		// leave it open, and an open encounter reads as a patient still under
		// care.
		"enc.encounter.override",
		// Restricted clinical entries — mental health, sexual health,
		// safeguarding (SRS-CLN-019). A clinician treating the patient needs
		// them; the read is separately audited every time.
		"enc.restricted.read",

		// The clinical record: write it, sign it, read it back.
		"cln.record.read",
		"cln.record.write",
		// Signing asserts clinical responsibility rather than data entry
		// (SRS-CLN-009). A ward clerk typing a dictated note saves the draft
		// and must not be able to finalise it.
		"cln.document.sign",
		"cln.record.read_restricted",
		// Acknowledging a critical result means somebody has taken clinical
		// action (SRS-CLN-012). A permission the whole hospital held would let
		// the desk clear the safety worklist by clicking through it.
		"cln.result.acknowledge",

		// Orders (SRS-ORD). Placing is the clinical act the whole CPOE
		// framework exists to record, and cancelling one's own mistake comes
		// with it.
		"ord.order.read",
		"ord.order.place",
		"ord.order.cancel",
		// Blood products are gated separately (SRS-ORD-002's requester
		// privilege): a unit of blood is traced unit by unit, and a hospital
		// that wants the authority restricted to senior staff must be able to
		// say so. Granted here because a consultant is who orders one; a
		// tenant that disagrees withholds it from the role.
		"ord.blood_product.order",

		// Nursing content is readable by the medical team — a ward round is
		// read from the flowsheet — but a doctor does not chart observations,
		// give medication or apply restraints, so only the read is here.
		"nur.record.read",
	},

	// A nurse delivers care. Note what is absent: no cln.document.sign and no
	// enc.diagnosis.record. Signing a clinical document and recording a
	// diagnosis are the medical team's assertions, and a nurse writing a
	// nursing note does neither.
	RoleNurse: {
		"empi.patient.read",
		// Nursing happens inside an encounter and needs to know it is open.
		"enc.encounter.read",
		// The nursing note is a clinical document; writing one is nursing work
		// and signing it is not the same act (SRS-CLN-009).
		"cln.record.read",
		"cln.record.write",
		// A nurse takes the observations a critical result is acted on by, and
		// acknowledging one means somebody has taken clinical action
		// (SRS-CLN-012).
		"cln.result.acknowledge",

		// A nurse reads the order list — it is what the ward round works
		// from — and does not place orders. Deliberately no ord.order.place:
		// a nurse taking a verbal order records it under the doctor's name
		// through the entered-by field, which keeps who is answerable separate
		// from who typed it.
		"ord.order.read",

		"nur.record.read",
		"nur.record.write",
		// Giving a drug is the act the whole eMAR exists to record
		// (SRS-NUR-009). Its own permission, so the ward clerk who transcribes
		// a note cannot chart a dose under their own name.
		"nur.medication.administer",
		// Completing an administration past a failed barcode check
		// (SRS-NUR-008). Granted, because a scanner breaks at 03:00 and a
		// medication round that stops is worse than one that is documented;
		// the control that bites is the mandatory reason and the stored report,
		// not scarcity of the permission.
		"nur.medication.override",
		// Restraints and transfusion are nursing acts carried out under a
		// clinician's authorization, and the authorization is checked in the
		// record rather than in the permission (SRS-NUR-013, SRS-NUR-014).
		"nur.restraint.manage",
		"nur.transfusion.manage",
		// Declaring downtime and reconciling the paper chart afterwards is the
		// ward's job, and the ward is who knows the system has gone
		// (SRS-NUR-018).
		"nur.downtime.manage",
	},

	// A downstream service moves orders through their lifecycle and does
	// nothing else (SRS-ORD-006).
	RolePerformingService: {
		"ord.order.read",
		"ord.order.acknowledge",
		// Deliberately no ord.order.place and no patient read: a laboratory
		// system needs to know what was asked of it, not who the patient is.
		// The dispatch carries the identifiers it needs.
	},

	// A nurse manager runs the ward rather than the bedside.
	RoleNurseManager: {
		"empi.patient.read",
		"enc.encounter.read",
		"nur.record.read",
		// Assignment and the acuity dashboard (SRS-NUR-016, SRS-NUR-017).
		"nur.assignment.manage",
		// Note what is absent: no nur.medication.administer. A manager who is
		// also rostered to give medication holds the nurse role as well; the
		// management role does not carry it, so "who may give a drug" stays
		// answerable from the roles alone.
	},
}

// PermissionsFor flattens the union of permissions for the given roles,
// deduplicated and sorted so the result is stable for caching and comparison.
func PermissionsFor(roles []Role) []string {
	set := make(map[string]struct{})
	for _, r := range roles {
		for _, p := range rolePermissions[r] {
			set[p] = struct{}{}
		}
	}

	out := make([]string, 0, len(set))
	for p := range set {
		out = append(out, p)
	}
	sort.Strings(out)
	return out
}

// KnownRole reports whether a role exists in the catalogue.
func KnownRole(r Role) bool {
	_, ok := rolePermissions[r]
	return ok
}

// rolePurposes is the purpose-of-use catalogue (SRS-IAM-004, SRS-SEC-009).
//
// Deliberately separate from permissions and deliberately *not* asserted by
// the identity provider. A customer's directory says who somebody is and what
// they do; what they may use patient data *for* is this system's policy, and
// letting a provider claim a purpose would let a customer's IdP grant research
// access by adding a group.
//
// A role absent here permits no purpose, so a caller holding it can assert
// none through the X-Purpose-Of-Use header. That is the fail-closed direction:
// an unstated purpose narrows nothing and reaches nothing that requires one.
var rolePurposes = map[Role][]authctx.PurposeOfUse{
	// Operational roles act on configuration, never on a clinical record, so
	// "operations" is the only purpose that makes sense for them. Granting
	// treatment here would let a platform operator read a chart with a purpose
	// that looks clinical in the audit trail.
	RolePlatformOperator: {authctx.PurposeOperations},
	RoleTenantAdmin:      {authctx.PurposeOperations},
	RoleFacilityViewer:   {authctx.PurposeOperations},
	// An auditor reviews the trail rather than delivering care. Support rather
	// than treatment, so their reads are distinguishable in the audit trail
	// from a clinician's.
	RoleAuditor: {authctx.PurposeOperations, authctx.PurposeSupport},

	// Registration and HIM act on the identity record in the course of
	// delivering and administering care. Treatment because a clerk registering
	// a patient is part of that patient receiving care; payment because the
	// same desk resolves the identity an invoice is raised against.
	RoleRegistrationClerk: {authctx.PurposeTreatment, authctx.PurposePayment},
	RoleHIMOfficer:        {authctx.PurposeTreatment, authctx.PurposeOperations},
	// A clinician reads a chart to treat somebody. Nothing else.
	RoleClinician: {authctx.PurposeTreatment},
	RoleScheduler: {authctx.PurposeTreatment, authctx.PurposeOperations},
}

// PurposesFor returns the purposes-of-use the given roles may assert,
// deduplicated and in a stable order.
func PurposesFor(roles []Role) []authctx.PurposeOfUse {
	set := map[authctx.PurposeOfUse]bool{}
	for _, r := range roles {
		for _, p := range rolePurposes[r] {
			set[p] = true
		}
	}

	out := make([]authctx.PurposeOfUse, 0, len(set))
	for p := range set {
		out = append(out, p)
	}
	sort.Slice(out, func(i, j int) bool { return out[i] < out[j] })
	return out
}
