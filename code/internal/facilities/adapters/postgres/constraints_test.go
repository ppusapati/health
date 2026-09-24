package postgres_test

import (
	"sort"
	"strings"
	"testing"

	"github.com/google/uuid"

	"github.com/ppusapati/health/code/internal/facilities/domain"
)

const (
	domainPreventive = domain.MaintenancePreventive
	domainElectrical = domain.SystemElectrical
)

// Every named rule in the facilities schema, broken one at a time.
//
// The tests in repository_test.go break the rules that are interesting to
// read about — the four composite keys, the permit contract, the life-safety
// visibility rule. These break the rest: the enums, the "say why" columns and
// the state-dependent requirements. They are dull individually and the set is
// the point, because a CHECK nothing tests is a CHECK the next person to edit
// this migration will delete without noticing.
//
// Each case starts from a row the database would accept and changes one
// thing, so the constraint named in the assertion is the one that fires. Two
// constraints going off at once is a test that cannot say which rule held.

// insertSQL builds an INSERT from a column-to-expression map. Hand-written
// statements would drift from the schema and start passing for the wrong
// reason; this way a column added with a NOT NULL and no default breaks every
// case at once, which is the right kind of loud.
func insertSQL(table string, values map[string]string) string {
	columns := make([]string, 0, len(values))
	for column := range values {
		columns = append(columns, column)
	}
	sort.Strings(columns)

	expressions := make([]string, 0, len(columns))
	for _, column := range columns {
		expressions = append(expressions, values[column])
	}
	return "INSERT INTO " + table + " (" + strings.Join(columns, ", ") +
		") VALUES (" + strings.Join(expressions, ", ") + ")"
}

func with(base map[string]string,
	overrides map[string]string) map[string]string {

	out := make(map[string]string, len(base)+len(overrides))
	for key, value := range base {
		out[key] = value
	}
	for key, value := range overrides {
		out[key] = value
	}
	return out
}

func literal(id string) string { return "'" + id + "'::uuid" }

// refuses asserts the database rejects one row, naming the constraint.
func (f fixture) refuses(t *testing.T, constraint, table string,
	values map[string]string) {

	t.Helper()
	f.mustFail(t, constraint, insertSQL(table, values))
}

func (f fixture) assetRow() map[string]string {
	return map[string]string{
		"id":            "gen_random_uuid()",
		"tenant_id":     literal(f.tenantID),
		"tag":           "'ZZ-' || substr(gen_random_uuid()::text, 1, 8)",
		"name":          "'A thing'",
		"system":        "'hvac'",
		"criticality":   "'normal'",
		"location_note": "'roof plant room'",
		"status":        "'in_service'",
		"status_at":     "now()",
		"created_by":    "'u-est'",
	}
}

func TestTheDatabaseRefusesAnAssetTheDomainWouldRefuse(t *testing.T) {
	f := newFixture(t)
	base := f.assetRow()
	const table = "facilities.asset"

	f.refuses(t, "an_asset_carries_its_tag", table,
		with(base, map[string]string{"tag": "''"}))
	f.refuses(t, "an_asset_carries_its_tag", table,
		with(base, map[string]string{"name": "''"}))
	f.refuses(t, "an_asset_system_is_known", table,
		with(base, map[string]string{"system": "'air conditioning'"}))
	f.refuses(t, "an_asset_criticality_is_known", table,
		with(base, map[string]string{"criticality": "'very'"}))
	f.refuses(t, "an_asset_status_is_known", table,
		with(base, map[string]string{
			"status": "'broken-ish'", "status_reason": "'x'"}))
	f.refuses(t, "an_asset_names_who_registered_it", table,
		with(base, map[string]string{"created_by": "''"}))
	f.refuses(t, "runtime_hours_are_not_negative", table,
		with(base, map[string]string{"runtime_hours": "-1"}))

	// An asset inside itself is a hierarchy read that never terminates.
	self := uuid.NewString()
	f.refuses(t, "an_asset_is_not_its_own_parent", table,
		with(base, map[string]string{
			"id": literal(self), "parent_id": literal(self)}))
}

func (f fixture) classRow() map[string]string {
	return map[string]string{
		"tenant_id": literal(f.tenantID),
		"code":      "'c-' || substr(gen_random_uuid()::text, 1, 8)",
		"name":      "'A class'",
	}
}

func TestTheDatabaseRefusesAWorkClassTheDomainWouldRefuse(t *testing.T) {
	f := newFixture(t)
	base := f.classRow()
	const table = "facilities.work_class"

	f.refuses(t, "a_work_class_names_itself", table,
		with(base, map[string]string{"code": "''"}))
	f.refuses(t, "a_work_class_names_itself", table,
		with(base, map[string]string{"name": "''"}))
	// A class somebody marked unsafe without saying why is one the next
	// person to review the list will quietly unmark.
	f.refuses(t, "an_unsafe_class_says_why", table,
		with(base, map[string]string{"requires_permit": "true"}))
	f.refuses(t, "an_unsafe_class_says_why", table,
		with(base, map[string]string{"requires_loto": "true"}))
}

func (f fixture) workRow(t *testing.T) map[string]string {
	t.Helper()
	f.workClass(t, "general", false, false)
	return map[string]string{
		"id":                    "gen_random_uuid()",
		"tenant_id":             literal(f.tenantID),
		"number":                "'WO-' || substr(gen_random_uuid()::text, 1, 8)",
		"system":                "'hvac'",
		"location_note":         "'ward 5'",
		"fault":                 "'leak'",
		"impact":                "'bay closed'",
		"priority":              "'routine'",
		"class_code":            "'general'",
		"class_requires_permit": "false",
		"class_requires_loto":   "false",
		"owner_team":            "'estates'",
		"state":                 "'raised'",
		"raised_at":             "now()",
		"raised_by":             "'u-ward'",
		"respond_by":            "now() + interval '1 hour'",
		"resolve_by":            "now() + interval '1 day'",
	}
}

func TestTheDatabaseRefusesAWorkOrderTheDomainWouldRefuse(t *testing.T) {
	f := newFixture(t)
	base := f.workRow(t)
	const table = "facilities.work_order"

	f.refuses(t, "a_work_order_has_a_number", table,
		with(base, map[string]string{"number": "''"}))
	f.refuses(t, "a_work_order_says_what_is_wrong", table,
		with(base, map[string]string{"fault": "''"}))
	// Without impact every ticket is urgent, because every ticket matters
	// to whoever raised it.
	f.refuses(t, "a_work_order_says_what_it_is_stopping", table,
		with(base, map[string]string{"impact": "''"}))
	f.refuses(t, "a_work_order_says_where_the_fault_is", table,
		with(base, map[string]string{"location_note": "''"}))
	f.refuses(t, "a_work_order_state_is_known", table,
		with(base, map[string]string{"state": "'nearly'"}))
	f.refuses(t, "a_work_order_priority_is_known", table,
		with(base, map[string]string{"priority": "'asap'"}))
	f.refuses(t, "a_work_order_system_is_known", table,
		with(base, map[string]string{"system": "'aircon'"}))
	// SRS-FAC-002's acceptance: the ticket receives an owner.
	f.refuses(t, "a_work_order_is_routed", table,
		with(base, map[string]string{"owner_team": "''"}))
	f.refuses(t, "a_work_order_names_who_raised_it", table,
		with(base, map[string]string{"raised_by": "''"}))
	// A ticket in progress with nobody against it is work nobody is doing.
	f.refuses(t, "work_being_done_names_who_took_it", table,
		with(base, map[string]string{"state": "'in_progress'"}))
	// An unsigned permit is a form. Who issued it is what makes somebody
	// answerable for the isolation being real.
	f.refuses(t, "a_permit_names_who_issued_it", table,
		with(base, map[string]string{"permit_ref": "'PTW-1'"}))
	f.refuses(t, "an_isolation_names_who_applied_it", table,
		with(base, map[string]string{"loto_ref": "'LOTO-1'"}))
	f.refuses(t, "resolved_work_says_what_was_done", table,
		with(base, map[string]string{
			"state": "'resolved'", "owner_user_id": "'u-fitter'"}))
	f.refuses(t, "a_closed_work_order_names_who_closed_it", table,
		with(base, map[string]string{
			"state": "'closed'", "owner_user_id": "'u-fitter'",
			"completion_note": "'done'"}))
	f.refuses(t, "a_held_work_order_says_what_it_waits_for", table,
		with(base, map[string]string{
			"state": "'on_hold'", "owner_user_id": "'u-fitter'"}))
	f.refuses(t, "a_cancelled_work_order_says_why", table,
		with(base, map[string]string{"state": "'cancelled'"}))
	f.refuses(t, "downtime_is_not_negative", table,
		with(base, map[string]string{"downtime_minutes": "-1"}))
	// A resolution target inside the response target is breached the
	// moment it is met.
	f.refuses(t, "sla_targets_are_ordered", table,
		with(base, map[string]string{
			"resolve_by": "now() - interval '1 day'"}))
}

func (f fixture) scheduleRow() map[string]string {
	return map[string]string{
		"id":            "gen_random_uuid()",
		"tenant_id":     literal(f.tenantID),
		"title":         "'A schedule'",
		"kind":          "'preventive'",
		"trigger_kind":  "'calendar'",
		"interval_days": "90",
		"created_at":    "now()",
		"created_by":    "'u-est'",
	}
}

func TestTheDatabaseRefusesAScheduleTheDomainWouldRefuse(t *testing.T) {
	f := newFixture(t)
	base := f.scheduleRow()
	const table = "facilities.schedule"

	f.refuses(t, "a_schedule_has_a_title", table,
		with(base, map[string]string{"title": "''"}))
	f.refuses(t, "a_schedule_kind_is_known", table,
		with(base, map[string]string{"kind": "'when we remember'"}))
	// Both interval rules are satisfied here so that the unknown trigger
	// is the only thing left to fire.
	f.refuses(t, "a_schedule_trigger_is_known", table,
		with(base, map[string]string{
			"trigger_kind":           "'vibes'",
			"interval_runtime_hours": "250",
			"asset_id":               literal(f.asset(t, "SCH-2", nil).ID)}))
	f.refuses(t, "a_calendar_schedule_has_an_interval", table,
		with(base, map[string]string{"interval_days": "0"}))
	f.refuses(t, "a_runtime_schedule_has_an_interval", table,
		with(base, map[string]string{
			"trigger_kind": "'runtime'", "interval_days": "0",
			"asset_id": literal(f.asset(t, "SCH-1", nil).ID)}))
	// Running hours belong to a machine. A runtime schedule against a
	// building can never come due.
	f.refuses(t, "a_runtime_schedule_names_its_asset", table,
		with(base, map[string]string{
			"trigger_kind": "'runtime'", "interval_days": "0",
			"interval_runtime_hours": "250"}))
	// "Statutory" with nobody named is a schedule that will be deferred
	// like any other.
	f.refuses(t, "a_statutory_inspection_names_its_authority", table,
		with(base, map[string]string{
			"kind": "'statutory'", "requires_evidence": "true"}))
	// And one whose evidence is optional is one that will be marked done
	// on the day the inspector did not come.
	f.refuses(t, "a_statutory_inspection_is_evidenced", table,
		with(base, map[string]string{
			"kind": "'statutory'", "authority": "'Inspectorate'"}))
	f.refuses(t, "grace_is_not_negative", table,
		with(base, map[string]string{"grace_days": "-1"}))
	f.refuses(t, "a_schedule_names_who_created_it", table,
		with(base, map[string]string{"created_by": "''"}))
}

func (f fixture) taskRow(t *testing.T) map[string]string {
	t.Helper()
	s := f.schedule(t, domainPreventive, nil)
	return map[string]string{
		"id":                         "gen_random_uuid()",
		"tenant_id":                  literal(f.tenantID),
		"schedule_id":                literal(s.ID),
		"title":                      "'A task'",
		"schedule_kind":              "'preventive'",
		"schedule_requires_evidence": "false",
		"due_at":                     "now()",
		"triggered_by":               "'calendar'",
		"state":                      "'planned'",
	}
}

func TestTheDatabaseRefusesATaskTheDomainWouldRefuse(t *testing.T) {
	f := newFixture(t)
	base := f.taskRow(t)
	const table = "facilities.task"

	f.refuses(t, "a_task_state_is_known", table,
		with(base, map[string]string{"state": "'sort of'"}))
	f.refuses(t, "a_task_trigger_is_known", table,
		with(base, map[string]string{"triggered_by": "'guesswork'"}))
	// A task due neither on a date nor at a reading never appears on any
	// list.
	f.refuses(t, "a_task_is_due_on_a_date_or_a_reading", table,
		with(base, map[string]string{"due_at": "NULL"}))
	// "Done" is not a finding.
	f.refuses(t, "a_completed_task_records_what_was_found", table,
		with(base, map[string]string{
			"state": "'done'", "done_by": "'u-fitter'"}))
	f.refuses(t, "a_completed_task_names_who_did_it", table,
		with(base, map[string]string{
			"state": "'done'", "findings": "'filters replaced'"}))
	f.refuses(t, "a_waived_task_says_why", table,
		with(base, map[string]string{
			"state": "'waived'", "done_by": "'u-est'"}))
	f.refuses(t, "a_waived_task_says_why", table,
		with(base, map[string]string{
			"state": "'waived'", "waived_reason": "'ward closed'"}))
}

func (f fixture) runtimeRow(t *testing.T) map[string]string {
	t.Helper()
	return map[string]string{
		"id":          "gen_random_uuid()",
		"tenant_id":   literal(f.tenantID),
		"asset_id":    literal(f.asset(t, "RT-1", nil).ID),
		"hours":       "100",
		"read_at":     "now()",
		"source":      "'manual'",
		"recorded_by": "'u-fitter'",
	}
}

func TestTheDatabaseRefusesARuntimeReadingTheDomainWouldRefuse(t *testing.T) {
	f := newFixture(t)
	base := f.runtimeRow(t)
	const table = "facilities.runtime_reading"

	f.refuses(t, "a_runtime_reading_is_not_negative", table,
		with(base, map[string]string{"hours": "-1"}))
	f.refuses(t, "a_runtime_source_is_known", table,
		with(base, map[string]string{"source": "'guess'"}))
	f.refuses(t, "a_runtime_reading_names_who_recorded_it", table,
		with(base, map[string]string{"recorded_by": "''"}))
	// The one legitimate reason a cumulative reading goes backwards, and
	// it has to say what happened.
	f.refuses(t, "a_replaced_counter_says_what_happened", table,
		with(base, map[string]string{"counter_replaced": "true"}))
}

func (f fixture) meterRow() map[string]string {
	return map[string]string{
		"id":         "gen_random_uuid()",
		"tenant_id":  literal(f.tenantID),
		"code":       "'M-' || substr(gen_random_uuid()::text, 1, 8)",
		"utility":    "'electricity'",
		"unit":       "'kWh'",
		"source":     "'manual'",
		"created_by": "'u-est'",
	}
}

func TestTheDatabaseRefusesAMeterTheDomainWouldRefuse(t *testing.T) {
	f := newFixture(t)
	base := f.meterRow()
	const table = "facilities.meter"

	f.refuses(t, "a_meter_has_a_code", table,
		with(base, map[string]string{"code": "''"}))
	f.refuses(t, "a_meter_utility_is_known", table,
		with(base, map[string]string{"utility": "'electric'"}))
	f.refuses(t, "a_meter_source_is_known", table,
		with(base, map[string]string{"source": "'somewhere'"}))
	f.refuses(t, "a_register_maximum_is_not_negative", table,
		with(base, map[string]string{"register_max": "-1"}))
}

func TestTheDatabaseRefusesAMeterReadingTheDomainWouldRefuse(t *testing.T) {
	f := newFixture(t)
	m := f.meter(t, "MR-1", nil)
	base := map[string]string{
		"id":          "gen_random_uuid()",
		"tenant_id":   literal(f.tenantID),
		"meter_id":    literal(m.ID),
		"value":       "100",
		"read_at":     "now()",
		"source":      "'manual'",
		"recorded_by": "'u-fitter'",
	}
	const table = "facilities.meter_reading"

	f.refuses(t, "a_reading_is_not_negative", table,
		with(base, map[string]string{"value": "-1"}))
	f.refuses(t, "a_reading_source_is_known", table,
		with(base, map[string]string{"source": "'guess'"}))
	f.refuses(t, "a_reading_names_who_recorded_it", table,
		with(base, map[string]string{"recorded_by": "''"}))
}

func (f fixture) outageRow() map[string]string {
	return map[string]string{
		"id":           "gen_random_uuid()",
		"tenant_id":    literal(f.tenantID),
		"reference":    "'SD-' || substr(gen_random_uuid()::text, 1, 8)",
		"system":       "'electrical'",
		"title":        "'A shutdown'",
		"reason":       "'hot joint'",
		"planned_from": "now()",
		"planned_to":   "now() + interval '4 hours'",
		"state":        "'planned'",
		"requested_by": "'u-est'",
		"requested_at": "now()",
	}
}

func TestTheDatabaseRefusesAnOutageTheDomainWouldRefuse(t *testing.T) {
	f := newFixture(t)
	base := f.outageRow()
	const table = "facilities.outage"

	f.refuses(t, "an_outage_has_a_reference", table,
		with(base, map[string]string{"reference": "''"}))
	f.refuses(t, "an_outage_has_a_reference", table,
		with(base, map[string]string{"title": "''"}))
	// The part a ward asks about when it objects.
	f.refuses(t, "an_outage_says_why_the_supply_goes_off", table,
		with(base, map[string]string{"reason": "''"}))
	f.refuses(t, "an_outage_system_is_known", table,
		with(base, map[string]string{"system": "'the mains'"}))
	// Named an approver, because every state outside planned and
	// cancelled needs one and that rule would otherwise fire first.
	f.refuses(t, "an_outage_state_is_known", table,
		with(base, map[string]string{
			"state": "'maybe'", "approved_by": "'u-mgr'"}))
	f.refuses(t, "an_outage_ends_after_it_starts", table,
		with(base, map[string]string{
			"planned_to": "now() - interval '1 hour'"}))
	f.refuses(t, "an_outage_names_who_requested_it", table,
		with(base, map[string]string{"requested_by": "''"}))
	f.refuses(t, "an_approved_outage_names_who_approved_it", table,
		with(base, map[string]string{"state": "'approved'"}))
	f.refuses(t, "an_outage_in_effect_records_when_it_started", table,
		with(base, map[string]string{
			"state": "'in_effect'", "approved_by": "'u-mgr'"}))
	f.refuses(t, "a_restored_outage_names_who_restored_it", table,
		with(base, map[string]string{
			"state": "'restored'", "approved_by": "'u-mgr'",
			"actual_from": "now()"}))
	f.refuses(t, "a_cancelled_outage_says_why", table,
		with(base, map[string]string{"state": "'cancelled'"}))
}

func TestTheDatabaseRefusesAnOutageAreaTheDomainWouldRefuse(t *testing.T) {
	f := newFixture(t)
	o, _ := f.outage(t, "SD-9001", domainElectrical)
	base := map[string]string{
		"id":            "gen_random_uuid()",
		"tenant_id":     literal(f.tenantID),
		"outage_id":     literal(o.ID),
		"name":          "'Ward 9'",
		"outage_system": "'electrical'",
		"outage_state":  "'planned'",
	}
	const table = "facilities.outage_area"

	f.refuses(t, "an_area_names_a_department_or_itself", table,
		with(base, map[string]string{"name": "''"}))
	f.refuses(t, "an_acknowledged_area_names_who_answered", table,
		with(base, map[string]string{
			"notified_at": "now()", "acknowledged_at": "now()"}))
}

func TestTwoOutagesCannotShareAReference(t *testing.T) {
	// Two permits with one number is an estates book where the second
	// entry overwrites the first.
	f := newFixture(t)
	f.mustExec(t, insertSQL("facilities.outage",
		with(f.outageRow(), map[string]string{"reference": "'SD-DUP'"})))
	f.refuses(t, "outage_reference_idx", "facilities.outage",
		with(f.outageRow(), map[string]string{"reference": "'SD-DUP'"}))
}

func (f fixture) alarmRow() map[string]string {
	return map[string]string{
		"id":          "gen_random_uuid()",
		"tenant_id":   literal(f.tenantID),
		"gateway_id":  "'gw-1'",
		"point_ref":   "'P.1'",
		"external_id": "'e-' || substr(gen_random_uuid()::text, 1, 8)",
		"system":      "'hvac'",
		"severity":    "'major'",
		"message":     "'something'",
		"source":      "'scada'",
		"raised_at":   "now()",
		"state":       "'active'",
	}
}

func TestTheDatabaseRefusesAnAlarmTheDomainWouldRefuse(t *testing.T) {
	f := newFixture(t)
	base := f.alarmRow()
	const table = "facilities.alarm"

	f.refuses(t, "an_alarm_names_its_origin", table,
		with(base, map[string]string{"gateway_id": "''"}))
	f.refuses(t, "an_alarm_names_its_origin", table,
		with(base, map[string]string{"point_ref": "''"}))
	f.refuses(t, "an_alarm_names_its_origin", table,
		with(base, map[string]string{"message": "''"}))
	// Without the gateway's own identifier there is no way to recognise a
	// replayed event, and a gateway reconnecting replays its buffer.
	f.refuses(t, "an_alarm_carries_the_gateways_event_id", table,
		with(base, map[string]string{"external_id": "''"}))
	f.refuses(t, "an_alarm_system_is_known", table,
		with(base, map[string]string{"system": "'gas'"}))
	f.refuses(t, "an_alarm_severity_is_known", table,
		with(base, map[string]string{"severity": "'loud'"}))
	f.refuses(t, "an_alarm_state_is_known", table,
		with(base, map[string]string{"state": "'ringing'"}))
	f.refuses(t, "an_alarm_source_is_known", table,
		with(base, map[string]string{"source": "'somewhere'"}))
	f.refuses(t, "a_cleared_alarm_says_when", table,
		with(base, map[string]string{"state": "'cleared'"}))
	f.refuses(t, "an_acknowledged_alarm_names_who", table,
		with(base, map[string]string{"acknowledged_at": "now()"}))
}

func TestALinkedAlarmSaysWhoLinkedIt(t *testing.T) {
	// A link with nobody's name on it cannot be questioned afterwards.
	f := newFixture(t)
	class := f.workClass(t, "general", false, false)
	w := f.workOrder(t, "WO-7001", class, nil)

	f.refuses(t, "a_linked_alarm_says_who_linked_it", "facilities.alarm",
		with(f.alarmRow(), map[string]string{
			"work_order_id": literal(w.ID)}))
}

func TestTheDatabaseRefusesAnAlarmRuleTheDomainWouldRefuse(t *testing.T) {
	f := newFixture(t)
	base := map[string]string{
		"id":           "gen_random_uuid()",
		"tenant_id":    literal(f.tenantID),
		"system":       "'medical_gas'",
		"min_severity": "'major'",
		"priority":     "'emergency'",
		"class_code":   "'gas_work'",
		"owner_team":   "'estates-gas'",
		"created_by":   "'u-est'",
	}
	const table = "facilities.alarm_rule"

	f.refuses(t, "an_alarm_rule_system_is_known", table,
		with(base, map[string]string{"system": "'gas'"}))
	f.refuses(t, "an_alarm_rule_severity_is_known", table,
		with(base, map[string]string{"min_severity": "'loud'"}))
	f.refuses(t, "an_alarm_rule_priority_is_known", table,
		with(base, map[string]string{"priority": "'now'"}))
	// A rule whose class or team is empty raises a ticket that goes
	// nowhere, at three in the morning.
	f.refuses(t, "an_alarm_rule_names_its_work", table,
		with(base, map[string]string{"class_code": "''"}))
	f.refuses(t, "an_alarm_rule_names_its_work", table,
		with(base, map[string]string{"owner_team": "''"}))
}

func (f fixture) deficiencyRow() map[string]string {
	return map[string]string{
		"id":            "gen_random_uuid()",
		"tenant_id":     literal(f.tenantID),
		"location_note": "'stair core B'",
		"system":        "'fire'",
		"severity":      "'minor'",
		"finding":       "'sign faded'",
		"state":         "'open'",
		"raised_at":     "now()",
		"raised_by":     "'u-fire'",
	}
}

func TestTheDatabaseRefusesADeficiencyTheDomainWouldRefuse(t *testing.T) {
	f := newFixture(t)
	base := f.deficiencyRow()
	const table = "facilities.deficiency"

	f.refuses(t, "a_deficiency_says_what_is_deficient", table,
		with(base, map[string]string{"finding": "''"}))
	f.refuses(t, "a_deficiency_says_where_it_is", table,
		with(base, map[string]string{"location_note": "''"}))
	f.refuses(t, "a_deficiency_system_is_known", table,
		with(base, map[string]string{"system": "'fire doors'"}))
	f.refuses(t, "a_deficiency_state_is_known", table,
		with(base, map[string]string{"state": "'being looked at'"}))
	f.refuses(t, "a_deficiency_names_who_raised_it", table,
		with(base, map[string]string{"raised_by": "''"}))

	// A critical finding with no date is one that is never late. Work is
	// supplied here so that the other critical rule cannot be the one
	// firing.
	class := f.workClass(t, "general", false, false)
	w := f.workOrder(t, "WO-8001", class, nil)
	f.refuses(t, "a_critical_deficiency_has_a_date", table,
		with(base, map[string]string{
			"severity": "'critical'", "work_order_id": literal(w.ID)}))

	// "Mitigated" with nothing said is a deficiency that has been
	// downgraded rather than managed.
	f.refuses(t, "a_mitigated_deficiency_says_what_is_in_place", table,
		with(base, map[string]string{
			"state": "'mitigated'", "mitigated_by": "'u-fire'"}))
	f.refuses(t, "a_mitigated_deficiency_says_what_is_in_place", table,
		with(base, map[string]string{
			"state": "'mitigated'", "mitigation_note": "'fire watch'"}))
	f.refuses(t, "a_closed_deficiency_names_who_closed_it", table,
		with(base, map[string]string{"state": "'closed'"}))
}

func TestTheDatabaseRefusesAVendorVisitTheDomainWouldRefuse(t *testing.T) {
	f := newFixture(t)
	class := f.workClass(t, "general", false, false)
	w := f.workOrder(t, "WO-9001", class, nil)
	base := map[string]string{
		"id":            "gen_random_uuid()",
		"tenant_id":     literal(f.tenantID),
		"vendor_name":   "'Coolair'",
		"technicians":   "ARRAY['S Kumar']",
		"work_order_id": literal(w.ID),
		"purpose":       "'service'",
		"state":         "'on_site'",
		"signed_in_at":  "now()",
		"signed_in_by":  "'u-security'",
	}
	const table = "facilities.vendor_visit"

	f.refuses(t, "a_visit_names_the_contractor", table,
		with(base, map[string]string{"vendor_name": "''"}))
	f.refuses(t, "a_visit_says_what_it_is_for", table,
		with(base, map[string]string{"purpose": "''"}))
	f.refuses(t, "a_visit_state_is_known", table,
		with(base, map[string]string{"state": "'around somewhere'"}))
	f.refuses(t, "a_visit_names_who_signed_it_in", table,
		with(base, map[string]string{"signed_in_by": "''"}))
	f.refuses(t, "a_departed_visit_names_who_signed_it_out", table,
		with(base, map[string]string{
			"state": "'departed'", "signed_out_at": "now()",
			"service_report_ref": "'sr-1'",
			"report_summary":     "'serviced'"}))
	// The flag is copied from a work order, so setting it without one
	// would leave a foreign key with nothing on the other end.
	f.refuses(t, "permit_work_names_its_work_order", table,
		with(base, map[string]string{
			"work_requires_permit": "true",
			"induction_ref":        "'IND-1'",
			"work_order_id":        "NULL",
			"asset_id":             literal(f.asset(t, "VV-1", nil).ID)}))
}

func TestAMeterCodeIsUniqueWhileInUse(t *testing.T) {
	// Two live meters with one code is a consumption figure that reads
	// whichever the query returned first.
	f := newFixture(t)
	f.mustExec(t, insertSQL("facilities.meter",
		with(f.meterRow(), map[string]string{"code": "'M-DUP'"})))
	f.refuses(t, "meter_code_idx", "facilities.meter",
		with(f.meterRow(), map[string]string{"code": "'M-DUP'"}))

	// A retired meter releases its code, because the replacement usually
	// inherits the cupboard label.
	f.mustExec(t, `UPDATE facilities.meter SET active = false
		WHERE tenant_id = $1 AND code = 'M-DUP'`,
		uuid.MustParse(f.tenantID))
	f.mustExec(t, insertSQL("facilities.meter",
		with(f.meterRow(), map[string]string{"code": "'M-DUP'"})))
}
