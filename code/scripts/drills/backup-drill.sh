#!/usr/bin/env bash
# Backup restore-verification drill (Gate A8, SRS-NFR-016).
#
# SRS-NFR-016 is explicit that a successful backup proves nothing: the evidence
# is a restore. The nightly CronJob runs backup-verify.sh from
# infra/k8s/base/backup-scripts.yaml, and this drill runs THAT script -- read
# out of the manifest rather than copied -- so what is exercised is what is
# deployed.
#
# Two cases:
#   quiet     the database is idle; the restore must verify and publish
#   busy      writes continue during the dump; the job must still verify,
#             because a nightly job that fails whenever the hospital is awake
#             is a job whose alert nobody reads
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$HERE/lib.sh"

DRILL_BIN="${DRILL_BIN:-/tmp/drill-core}"
PASSWORD="${PASSWORD:-drillpass1}"

# The script under test comes out of the manifest, so a drift between the drill
# and the deployed CronJob is impossible rather than merely unlikely.
extract_script() {
    python3 - "$CODE_ROOT/infra/k8s/base/backup-scripts.yaml" > "$DRILL_ROOT/backup-verify.sh" <<'PY'
import sys, yaml
with open(sys.argv[1]) as fh:
    doc = yaml.safe_load(fh)
sys.stdout.write(doc["data"]["backup-verify.sh"])
PY
    chmod +x "$DRILL_ROOT/backup-verify.sh"
}

# Writes at a steady rate for the duration of the dump. Not a stress test: the
# point is that the database is not frozen, which is the normal state of a
# hospital system at the hour a nightly backup runs.
start_writer() {
    local url="$1"
    (
        while :; do
            as_owner "$PGBIN/psql '$url' -qtAc \"INSERT INTO platform_data.audit_record
                (audit_id, tenant_id, actor_id, action, resource_type, resource_id,
                 outcome, correlation_id, occurred_at)
                VALUES (gen_random_uuid(), gen_random_uuid(), 'drill', 'backup.drill.write',
                        'drill', gen_random_uuid()::text, 'success', gen_random_uuid()::text, now())\"" >/dev/null 2>&1 || true
            sleep 0.05
        done
    ) &
    echo $! > "$DRILL_ROOT/writer.pid"
}

stop_writer() {
    if [ -f "$DRILL_ROOT/writer.pid" ]; then
        pkill -P "$(cat "$DRILL_ROOT/writer.pid")" 2>/dev/null || true
        kill "$(cat "$DRILL_ROOT/writer.pid")" 2>/dev/null || true
        rm -f "$DRILL_ROOT/writer.pid"
    fi
}

# The CronJob mounts an emptyDir at /work and the script writes its dump there
# by that absolute path. The drill provides the same path rather than editing
# the script, because the script is the artefact under test.
WORK_DIR="${WORK_DIR:-/work}"
# Only a directory this drill created is removed on the way out. A machine that
# already had /work keeps it: a cleanup step that deletes somebody else's data
# is worse than one that leaves a dump behind.
WORK_DIR_WAS_OURS=false

run_verify() {
    local label="$1" url="$2"
    if [ ! -d "$WORK_DIR" ]; then
        WORK_DIR_WAS_OURS=true
    fi
    mkdir -p "$WORK_DIR" "$DRILL_ROOT/published"
    if [ "$(id -u)" = "0" ]; then chown -R "$PG_OWNER:$PG_OWNER" "$WORK_DIR" "$DRILL_ROOT/published"; fi
    rm -f "$DRILL_ROOT/published"/*.dump "$WORK_DIR"/*.dump

    set +e
    as_owner "PATH=$PGBIN:\$PATH DATABASE_URL='$url' BACKUP_DESTINATION=$DRILL_ROOT/published \
        sh $DRILL_ROOT/backup-verify.sh" > "$DRILL_ROOT/$label.log" 2>&1
    local status=$?
    set -e

    local published
    published="$(find "$DRILL_ROOT/published" -name '*.dump' | wc -l)"
    printf '%s exit=%s published=%s\n' "$label" "$status" "$published"
    sed 's/^/    /' "$DRILL_ROOT/$label.log" | tail -6
    return 0
}

main() {
    trap 'stop_writer; teardown; if [ "$WORK_DIR_WAS_OURS" = true ]; then rm -rf "$WORK_DIR"; fi' EXIT

    start_primary
    seed_database "$PASSWORD"
    local url backup_url
    url="$(core_dsn core "$PASSWORD" "$PRIMARY_PORT")"
    # The job runs as the backup role, exactly as the CronJob does after the
    # finding this drill produced.
    backup_url="$(core_dsn core_backup "$PASSWORD" "$PRIMARY_PORT")"
    extract_script

    # Something to lose. A restore-verification drill against an empty database
    # compares zero with zero and passes whatever the script does.
    as_owner "$PGBIN/psql '$url' -qtAc \"INSERT INTO platform_data.audit_record
        (audit_id, tenant_id, actor_id, action, resource_type, resource_id,
         outcome, correlation_id, occurred_at)
        SELECT gen_random_uuid(), gen_random_uuid(), 'seed', 'backup.drill.seed', 'drill',
               gen_random_uuid()::text, 'success', gen_random_uuid()::text, now()
        FROM generate_series(1, 5000)\"" >/dev/null
    log "seeded 5000 audit records"

    log "case: quiet database"
    run_verify quiet "$backup_url"

    log "case: writes continuing through the dump"
    start_writer "$url"
    run_verify busy "$backup_url"
    stop_writer

    log "case: a restore that lost rows must be detected"
    detects_a_short_restore "$backup_url"
}

# The comparison is the whole control, so it is worth knowing that it bites.
#
# A short restore cannot be injected into the job from outside -- it dumps and
# restores in one process -- so this exercises the job's own comparison query,
# read out of its own script, against a restored copy that has deliberately
# lost rows. What it proves is that the query notices; what it does not prove
# is the job's control flow around it, which the two cases above cover.
detects_a_short_restore() {
    local url="$1"
    local query dump scratch scratch_url source_counts restored_counts

    query="$(sed -n '/^COUNT_QUERY="/,/^  ) s"$/p' "$DRILL_ROOT/backup-verify.sh" \
        | sed '1s/^COUNT_QUERY="//; $s/"$//')"

    dump="$WORK_DIR/short-restore.dump"
    scratch="short_restore_check"
    scratch_url="$(echo "$url" | sed "s#/core?#/$scratch?#")"

    as_owner "$PGBIN/pg_dump --format=custom --no-owner --no-acl --file=$dump '$url'"
    source_counts="$(as_owner "$PGBIN/psql -qtA '$url' -c \"$query\"")"

    as_owner "$PGBIN/psql -qtA '$(echo "$url" | sed 's#/core?#/postgres?#')' \
        -c 'DROP DATABASE IF EXISTS $scratch WITH (FORCE)'" >/dev/null
    as_owner "$PGBIN/psql -qtA '$(echo "$url" | sed 's#/core?#/postgres?#')' \
        -c 'CREATE DATABASE $scratch'" >/dev/null
    as_owner "$PGBIN/pg_restore --no-owner --no-acl --dbname='$scratch_url' $dump" >/dev/null 2>&1

    # A hundred rows short. Small on purpose: a control that only notices a
    # catastrophic loss is not much of a control.
    as_owner "$PGBIN/psql -qtA '$scratch_url' -c \
        'DELETE FROM platform_data.audit_record WHERE ctid IN (
            SELECT ctid FROM platform_data.audit_record LIMIT 100)'" >/dev/null
    restored_counts="$(as_owner "$PGBIN/psql -qtA '$scratch_url' -c \"$query\"")"

    as_owner "$PGBIN/psql -qtA '$(echo "$url" | sed 's#/core?#/postgres?#')' \
        -c 'DROP DATABASE IF EXISTS $scratch WITH (FORCE)'" >/dev/null

    if [ "$source_counts" = "$restored_counts" ]; then
        echo "short-restore FAILED TO DETECT: the comparison passed a copy missing 100 rows"
        return 1
    fi
    echo "short-restore detected"
    echo "    source:   $(echo "$source_counts" | grep -o 'platform_data.audit_record=[0-9]*')"
    echo "    restored: $(echo "$restored_counts" | grep -o 'platform_data.audit_record=[0-9]*')"
}

main "$@"
