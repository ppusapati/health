#!/usr/bin/env bash
# Disaster-recovery drill (SRS-NFR-005: RPO <= 5 min, RTO <= 60 min).
#
# Runs the procedure in docs/engineering/runbooks/disaster-recovery.md. The
# requirement's verification clause is "scheduled DR test meets targets or
# records remediation", and the second half is the load-bearing one: this
# script prints the numbers it measured whether or not they pass, because a
# drill that is only ever run when it will pass is not a drill.
#
# The failure is a hard kill, not a shutdown. A graceful stop flushes WAL that
# a real failure would not, so a drill that practises the polite case measures
# a recovery that will not happen.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$HERE/lib.sh"

DRILL_BIN="${DRILL_BIN:-/tmp/drill-core}"
PASSWORD="${PASSWORD:-drillpass1}"
RPO_TARGET_SECONDS="${RPO_TARGET_SECONDS:-300}"
RTO_TARGET_SECONDS="${RTO_TARGET_SECONDS:-3600}"
# How long to write before pulling the plug. Long enough that there is real
# in-flight work to lose, short enough to run in a maintenance window.
LOAD_SECONDS="${LOAD_SECONDS:-15}"

# A steady stream of real clinical writes through the whole stack, each one
# recording the moment the server confirmed it. The last confirmed write is
# what the RPO is measured against: the question is not what the database had,
# it is what a user was told had been saved.
start_writes() {
    local token="$1"
    : > "$DRILL_ROOT/confirmed.log"
    (
        local n=0
        local deadline=$(( $(date +%s) + LOAD_SECONDS ))
        while [ "$(date +%s)" -lt "$deadline" ]; do
            n=$(( n + 1 ))
            if curl -sf -m 3 -X POST \
                -H 'Content-Type: application/json' \
                -H "Authorization: Bearer $token" \
                -d "{\"code\":\"w$n\",\"displayName\":\"Ward $n\",\"type\":\"FACILITY_TYPE_CLINIC\",\"timeZone\":\"Asia/Kolkata\"}" \
                "http://127.0.0.1:$APP_PORT/healthcare.organization.v1.OrganizationService/CreateFacility" \
                >/dev/null 2>&1; then
                printf '%s %s\n' "$(now_ms)" "w$n" >> "$DRILL_ROOT/confirmed.log"
            fi
        done
    ) &
    echo $! > "$DRILL_ROOT/writes.pid"
}

main() {
    trap teardown EXIT

    start_primary
    seed_database "$PASSWORD"
    start_replica "$PASSWORD"
    start_core "$(core_dsn core "$PASSWORD" "$PRIMARY_PORT")" "$APP_PORT" core
    wait_ready "$APP_PORT" 60
    log "service up against the primary; replica streaming"

    local ops tenant token
    ops="$(python3 -c 'import uuid; print(uuid.uuid4())'):ops-1:platform_operator"
    tenant="$(curl -sf -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $ops" \
        -d '{"displayName":"DR Drill","legalJurisdiction":"IN","defaultLocale":"en-IN","timeZone":"Asia/Kolkata"}' \
        "http://127.0.0.1:$APP_PORT/healthcare.organization.v1.OrganizationService/CreateTenant" \
        | python3 -c 'import sys, json; print(json.load(sys.stdin)["tenant"]["tenantId"])')"
    token="$tenant:admin-${tenant:0:8}:tenant_admin"

    # --- step 1: start the clock and the load -----------------------------
    log "load starts"
    start_writes "$token"
    wait "$(cat "$DRILL_ROOT/writes.pid")" 2>/dev/null || true

    local confirmed_count last_confirmed_ms
    confirmed_count="$(wc -l < "$DRILL_ROOT/confirmed.log" | tr -d ' ')"
    last_confirmed_ms="$(tail -1 "$DRILL_ROOT/confirmed.log" | cut -d' ' -f1)"

    # --- step 2: record the last committed position ------------------------
    local lsn_before
    lsn_before="$(primary_psql "-tAc 'SELECT pg_current_wal_lsn()'" | tr -d ' ')"
    log "$confirmed_count writes confirmed; primary at $lsn_before"

    # --- step 3: simulate the failure --------------------------------------
    local t0; t0="$(now_ms)"
    local primary_pid; primary_pid="$(head -1 "$PRIMARY_DATA/postmaster.pid")"
    kill -9 "$primary_pid" 2>/dev/null || true
    # The whole process tree, as a machine losing power would.
    pkill -9 -f "postgres: .*$PRIMARY_PORT" 2>/dev/null || true
    pkill -9 -f "$PRIMARY_DATA" 2>/dev/null || true
    log "T0 primary killed"

    # --- step 4: declare ----------------------------------------------------
    # RTO runs from the decision, not from the outage. In a real incident this
    # is the largest single component and the one a drill most often skips.
    local t1; t1="$(now_ms)"
    log "T1 incident declared"

    # --- step 5: promote the replica ---------------------------------------
    as_owner "$PGBIN/pg_ctl -D $REPLICA_DATA promote" >/dev/null
    local deadline=$(( $(date +%s) + 120 ))
    while [ "$(date +%s)" -lt "$deadline" ]; do
        if [ "$(replica_psql "-tAc 'SELECT pg_is_in_recovery()'" | tr -d ' ')" = "f" ]; then break; fi
        sleep 0.2
    done
    log "replica promoted"

    # --- step 6: restart the application against the promoted instance ------
    # pgxpool holds the DSN it started with, which is why the runbook restarts
    # rather than waiting for a reconnect.
    stop_core core
    start_core "$(core_dsn core "$PASSWORD" "$REPLICA_PORT")" "$APP_PORT" core

    # --- step 7: first successful clinical request --------------------------
    local t2=""
    deadline=$(( $(date +%s) + 300 ))
    while [ "$(date +%s)" -lt "$deadline" ]; do
        if curl -sf -m 3 -X POST \
            -H 'Content-Type: application/json' \
            -H "Authorization: Bearer $token" \
            -d '{"code":"post-dr","displayName":"Post-recovery ward","type":"FACILITY_TYPE_CLINIC","timeZone":"Asia/Kolkata"}' \
            "http://127.0.0.1:$APP_PORT/healthcare.organization.v1.OrganizationService/CreateFacility" \
            >/dev/null 2>&1; then
            t2="$(now_ms)"
            break
        fi
        sleep 0.2
    done
    if [ -z "$t2" ]; then
        echo "RECOVERY FAILED: no clinical request succeeded after promotion"
        tail -20 "$DRILL_ROOT/core.log"
        exit 1
    fi
    log "T2 first clinical request served by the promoted instance"

    # --- step 8: measure the RPO -------------------------------------------
    # Which of the writes the user was told had been saved actually survived.
    local survived lost rpo_ms
    survived="$(replica_psql "-d core -tAc \"SELECT count(*) FROM organization.facility WHERE code LIKE 'W%'\"" | tr -d ' ')"
    lost=$(( confirmed_count - survived ))
    if [ "$lost" -le 0 ]; then
        lost=0
        rpo_ms=0
    else
        # The oldest confirmed write that did not survive sets the RPO: every
        # write from that point to the failure is gone.
        #
        # This assumes the losses are at the tail, which is what a WAL cut-off
        # produces: the replica has a prefix of the primary's history, so the
        # writes it is missing are the last ones. A loss in the middle would
        # mean something other than a replication lag, and would show up in the
        # integrity checks below rather than here.
        local first_lost_ms
        first_lost_ms="$(sed -n "$(( survived + 1 ))p" "$DRILL_ROOT/confirmed.log" | cut -d' ' -f1)"
        rpo_ms=$(( t0 - first_lost_ms ))
    fi

    # --- step 9: integrity, not just availability ---------------------------
    local facilities tenants audits
    facilities="$(replica_psql "-d core -tAc 'SELECT count(*) FROM organization.facility'" | tr -d ' ')"
    tenants="$(replica_psql "-d core -tAc 'SELECT count(*) FROM organization.tenant'" | tr -d ' ')"
    audits="$(replica_psql "-d core -tAc 'SELECT count(*) FROM platform_data.audit_record'" | tr -d ' ')"

    # An outbox row that committed with its state change must still be there:
    # the outbox is the structure a partial recovery leaves silently wrong, and
    # a lost event is a downstream system that never hears about a patient.
    local orphan_outbox
    orphan_outbox="$(replica_psql "-d core -tAc \"
        SELECT count(*) FROM organization.facility f
        WHERE NOT EXISTS (
            SELECT 1 FROM platform_data.outbox_event o
            WHERE o.aggregate_id = f.facility_id::text)\"" | tr -d ' ')"

    local rto_s=$(( (t2 - t1) / 1000 ))
    local rpo_s=$(( rpo_ms / 1000 ))
    local outcome="met"
    [ "$rpo_s" -gt "$RPO_TARGET_SECONDS" ] && outcome="missed"
    [ "$rto_s" -gt "$RTO_TARGET_SECONDS" ] && outcome="missed"
    [ "$orphan_outbox" -gt 0 ] && outcome="missed"

    echo
    echo "disaster-recovery drill result"
    echo "  writes confirmed to the user: $confirmed_count"
    echo "  writes that survived:         $survived"
    echo "  writes lost:                  $lost"
    echo "  RPO:                          ${rpo_s}s / target ${RPO_TARGET_SECONDS}s"
    echo "  RTO:                          ${rto_s}s / target ${RTO_TARGET_SECONDS}s"
    echo "    T0 failure -> T1 declared:  $(( (t1 - t0) )) ms"
    echo "    T1 declared -> T2 serving:  $(( (t2 - t1) )) ms"
    echo "  integrity after recovery:"
    echo "    tenants:                    $tenants"
    echo "    facilities:                 $facilities"
    echo "    audit records:              $audits"
    echo "    facilities with no outbox event: $orphan_outbox"
    echo "  outcome:                      $outcome"
    [ "$outcome" = "met" ]
}

main "$@"
