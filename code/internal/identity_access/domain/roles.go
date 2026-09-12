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
