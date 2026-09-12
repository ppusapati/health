// Package application holds the patient index use cases.
//
// Authorization, audit and the transaction boundary live here — never in the
// transport, which must not be the only thing standing between a caller and a
// patient record (SRS-IAM-003).
package application

// Permissions for the patient index.
//
// Named `<context>.<resource>.<action>` to match the rest of the codebase. The
// Wave-1 backlog spells them `empi.create`, `empi.read` and so on; the mapping
// is one-to-one and the longer form is kept because a permission that does not
// say what it is about becomes ambiguous the moment a second resource arrives
// in this context.
const (
	// PermPatientCreate registers a patient (SRS-EMPI-001, backlog empi.create).
	PermPatientCreate = "empi.patient.create"
	// PermPatientRead reads and searches (SRS-EMPI-003, backlog empi.read).
	PermPatientRead = "empi.patient.read"
	// PermPatientUpdate corrects demographics (backlog empi.write).
	PermPatientUpdate = "empi.patient.update"
	// PermPatientManage maintains identifiers, relationships and deceased
	// status (backlog empi.manage).
	PermPatientManage = "empi.patient.manage"
	// PermPatientMerge merges and unmerges (SRS-EMPI-005, SRS-EMPI-006,
	// backlog empi.merge).
	//
	// Deliberately distinct from PermPatientManage. The Wave-1 backlog lists
	// SRS-EMPI-005 under `empi.read`, which cannot be right: merging is the
	// most destructive action in this context — it fuses two people's records
	// — and putting it behind a read permission would grant it to every clerk
	// who can search. Read as a transcription slip in the backlog rather than
	// as a requirement, and raised as such.
	PermPatientMerge = "empi.patient.merge"
	// PermPatientReadRestricted reveals protected demographic fields that are
	// otherwise masked (SRS-EMPI-003, SRS-EMPI-014).
	PermPatientReadRestricted = "empi.patient.read_restricted"
	// PermPatientConfigure edits the demographic policy and match tuning
	// (backlog empi.configure).
	PermPatientConfigure = "empi.patient.configure"
)

// Event types emitted by this context (SRS-EMPI-018).
const (
	eventSource        = "empi"
	eventSchemaVersion = 1

	// EventPatientCreated is emitted once a patient row is committed.
	EventPatientCreated = "patient.created"
	// EventPatientDemographicsUpdated is emitted on an applied correction.
	EventPatientDemographicsUpdated = "patient.demographics_updated"
	// EventPatientIdentityConfirmed is emitted when a candidate becomes active.
	EventPatientIdentityConfirmed = "patient.identity_confirmed"
)
