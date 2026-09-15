#!/usr/bin/env bash
# Database credential rotation drill (SRS-SEC-002).
#
# Runs the procedure in docs/engineering/runbooks/key-rotation.md against a
# running service under load. The pass criterion is the runbook's: zero failed
# requests. A drill with a visible error blip has found a defect in the
# rotation path, and recording it as a pass with a caveat is how the defect
# survives to the real rotation.
#
# Two instances rather than one, because the property being tested is that a
# credential can be replaced without callers noticing, and that property comes
# from replacing them one at a time while the other serves. A single instance
# would measure the length of a restart, which is not the question.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$HERE/lib.sh"

DRILL_BIN="${DRILL_BIN:-/tmp/drill-core}"
OLD_PASSWORD="${OLD_PASSWORD:-drillpass1}"
NEW_PASSWORD="${NEW_PASSWORD:-drillpass2}"
PORT_A="${PORT_A:-18080}"
PORT_B="${PORT_B:-18081}"
DURATION="${DURATION:-40}"
# Seconds between requests, which sets a rate comfortably inside the 20/s the
# platform grants an authenticated caller (transport.DefaultRateLimit).
#
# The drill measures whether a rotation is visible to callers. Driving the
# tenant into its own rate limit measures the rate limiter instead, and the
# first run of this drill did exactly that: 401 "failures" that were all 429s.
# The run reports rate-limited requests separately and refuses to record a
# result when there are any, so a generator set too fast produces an invalid
# drill rather than a false one.
INTERVAL="${INTERVAL:-0.05}"

# Alternates between the two instances and, on a failure, immediately tries the
# other one.
#
# That second half is what makes this a model of a Service rather than of two
# unrelated endpoints: the endpoint controller takes a pod out of rotation the
# moment its readiness probe fails, so a caller never sends to the instance
# being replaced. A generator without it would count the restart window as
# downtime and report a failed drill for a rollout that was, in the cluster,
# invisible. A request is failed only when neither instance could serve it,
# which is the event a caller would actually experience.
# One request. Records what came back rather than only whether it worked: a
# failure log that says "it failed" tells whoever reads it nothing about
# whether the rotation or the drill was at fault.
call() {
    local port="$1" token="$2"
    local response
    response="$(curl -s -m 3 -w '\n%{http_code}' -X POST \
        -H 'Content-Type: application/json' \
        -H "Authorization: Bearer $token" \
        -d '{"pageSize":5}' \
        "http://127.0.0.1:$port/healthcare.organization.v1.OrganizationService/ListFacilities" 2>&1)"
    LAST_STATUS="$(printf '%s' "$response" | tail -1)"
    LAST_BODY="$(printf '%s' "$response" | head -c 200 | tr '\n' ' ')"
    [ "$LAST_STATUS" = "200" ]
}

start_load() {
    local token="$1"
    : > "$DRILL_ROOT/load.failures"
    : > "$DRILL_ROOT/load.throttled"
    : > "$DRILL_ROOT/load.total"
    (
        local port="$PORT_A" total=0 failures=0
        local deadline=$(( $(date +%s) + DURATION ))
        while [ "$(date +%s)" -lt "$deadline" ]; do
            if [ "$port" = "$PORT_A" ]; then port="$PORT_B"; else port="$PORT_A"; fi
            local other
            if [ "$port" = "$PORT_A" ]; then other="$PORT_B"; else other="$PORT_A"; fi

            total=$(( total + 1 ))
            if ! call "$port" "$token" && ! call "$other" "$token"; then
                # A 429 is the rate limiter working, not the rotation failing.
                # Counted separately and loudly: folded into the failure count
                # it would condemn a clean rotation, and ignored it would hide a
                # generator driving the system past its contract.
                if [ "$LAST_STATUS" = "429" ]; then
                    printf '%s\n' "$(date -u +%H:%M:%S.%3N)" >> "$DRILL_ROOT/load.throttled"
                else
                    failures=$(( failures + 1 ))
                    printf '%s ports=%s,%s status=%s body=%s\n' \
                        "$(date -u +%H:%M:%S.%3N)" "$port" "$other" "$LAST_STATUS" "$LAST_BODY" \
                        >> "$DRILL_ROOT/load.failures"
                fi
            fi
            sleep "$INTERVAL"
        done
        echo "$total" > "$DRILL_ROOT/load.total"
    ) &
    echo $! > "$DRILL_ROOT/load.pid"
}

wait_load() {
    [ -f "$DRILL_ROOT/load.pid" ] && wait "$(cat "$DRILL_ROOT/load.pid")" 2>/dev/null || true
}

connected_roles() {
    as_owner "$PGBIN/psql -h $DRILL_ROOT/run -p $PRIMARY_PORT -U postgres -d core -tAc \
        \"SELECT DISTINCT usename FROM pg_stat_activity WHERE datname = 'core' AND usename LIKE 'core%' ORDER BY 1\""
}

main() {
    trap teardown EXIT

    start_primary
    seed_database "$OLD_PASSWORD"

    local old_dsn new_dsn
    old_dsn="$(core_dsn core "$OLD_PASSWORD" "$PRIMARY_PORT")"
    new_dsn="$(core_dsn core_v2 "$NEW_PASSWORD" "$PRIMARY_PORT")"

    start_core "$old_dsn" "$PORT_A" core-a
    start_core "$old_dsn" "$PORT_B" core-b
    wait_ready "$PORT_A" 60
    wait_ready "$PORT_B" 60
    log "two instances serving on $PORT_A and $PORT_B as role core"

    # A tenant to read, so the load is a real authorized query through the whole
    # stack rather than a health check that never touches a table.
    local ops tenant token
    ops="$(python3 -c 'import uuid; print(uuid.uuid4())'):ops-1:platform_operator"
    tenant="$(curl -sf -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $ops" \
        -d '{"displayName":"Rotation Drill","legalJurisdiction":"IN","defaultLocale":"en-IN","timeZone":"Asia/Kolkata"}' \
        "http://127.0.0.1:$PORT_A/healthcare.organization.v1.OrganizationService/CreateTenant" \
        | python3 -c 'import sys, json; print(json.load(sys.stdin)["tenant"]["tenantId"])')"
    token="$tenant:admin-${tenant:0:8}:tenant_admin"

    log "T0 load starts"
    start_load "$token"
    local t0; t0="$(now_ms)"

    # Step 3: both credentials valid at once. This is what makes the rotation
    # non-disruptive -- an instance still holding the old DSN keeps working
    # until it is restarted.
    #
    # IN ROLE core_owner, not IN ROLE core. Granting membership of the outgoing
    # login role is the obvious reading and it is fatal: the new role's only
    # path to the data would run through the role step 7 drops, so the rotation
    # succeeds and then every request fails. The drill found this by producing
    # exactly that outage (docs/engineering/drill-log.md, DRILL-2026-001).
    as_owner "$PGBIN/psql -h $DRILL_ROOT/run -p $PRIMARY_PORT -U postgres -d core -v ON_ERROR_STOP=1 -c \
        \"CREATE ROLE core_v2 LOGIN PASSWORD '$NEW_PASSWORD' IN ROLE core_owner\"" >/dev/null
    log "core_v2 created alongside core"

    # Steps 4-6: the new value reaches the workload and the instances are
    # replaced one at a time. Restarting both at once is the mistake this
    # ordering exists to prevent.
    stop_core core-a
    start_core "$new_dsn" "$PORT_A" core-a
    wait_ready "$PORT_A" 60 || { log "instance A did not come back"; exit 1; }
    log "instance A rotated"

    stop_core core-b
    start_core "$new_dsn" "$PORT_B" core-b
    wait_ready "$PORT_B" 60 || { log "instance B did not come back"; exit 1; }
    log "instance B rotated"

    # Step 7: confirm before revoking. Dropping a role that is still in use is
    # the most common way a rotation drill becomes an incident.
    local roles; roles="$(connected_roles | tr '\n' ' ')"
    log "roles connected: $roles"
    if echo "$roles" | grep -qw core; then
        log "FAIL: the old role is still connected; not dropping it"
        wait_load
        exit 1
    fi

    as_owner "$PGBIN/psql -h $DRILL_ROOT/run -p $PRIMARY_PORT -U postgres -d core -v ON_ERROR_STOP=1 -c \
        'DROP ROLE core'" >/dev/null
    log "old role dropped"

    wait_load
    local t1; t1="$(now_ms)"

    local total failures throttled
    total="$(cat "$DRILL_ROOT/load.total" 2>/dev/null || echo 0)"
    failures="$(wc -l < "$DRILL_ROOT/load.failures" | tr -d ' ')"
    throttled="$(wc -l < "$DRILL_ROOT/load.throttled" | tr -d ' ')"

    echo
    echo "rotation drill result"
    echo "  elapsed:        $(( (t1 - t0) / 1000 ))s"
    echo "  requests:       $total"
    echo "  failed:         $failures"
    echo "  rate-limited:   $throttled"
    echo "  pass criterion: zero failed requests"

    if [ "$throttled" -gt 0 ]; then
        echo "  outcome:        invalid"
        echo "    The generator was throttled, so it was measuring the rate"
        echo "    limiter rather than the rotation. Lower the rate (INTERVAL)"
        echo "    and run it again; do not record this run as a result."
        return 1
    fi
    if [ "$failures" -eq 0 ]; then
        echo "  outcome:        met"
    else
        echo "  outcome:        missed"
        sed 's/^/    /' "$DRILL_ROOT/load.failures" | head -10
    fi
    [ "$failures" -eq 0 ]
}

main "$@"
