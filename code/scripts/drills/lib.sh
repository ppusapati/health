#!/usr/bin/env bash
# Shared harness for the Wave-0 operational drills.
#
# SRS-SEC-002 and SRS-NFR-005 both say "tested", and a procedure nobody has
# executed is a document rather than a control. These scripts exist so the
# drills are reproducible by someone who was not there: a drill whose evidence
# is a transcript in a chat window cannot be re-run, and a drill that cannot be
# re-run is a one-off.
#
# The topology below is a stand-in for the managed database, not a model of it.
# It gives the drills the two properties the targets actually depend on —
# continuous WAL archiving and a streaming replica that can be promoted — using
# ordinary PostgreSQL processes so no cluster is required. What it does not
# exercise is named in docs/engineering/drill-log.md rather than glossed over.
set -euo pipefail

PGBIN="${PGBIN:-/usr/lib/postgresql/16/bin}"
DRILL_ROOT="${DRILL_ROOT:-/tmp/health-drill}"
PRIMARY_DATA="$DRILL_ROOT/primary"
REPLICA_DATA="$DRILL_ROOT/replica"
WAL_ARCHIVE="$DRILL_ROOT/wal-archive"
PRIMARY_PORT="${PRIMARY_PORT:-55501}"
REPLICA_PORT="${REPLICA_PORT:-55502}"
APP_PORT="${APP_PORT:-18080}"

CODE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Every drill runs as an unprivileged user for the same reason production does.
PG_OWNER="${PG_OWNER:-postgres}"

as_owner() {
    if [ "$(id -u)" = "0" ]; then
        su "$PG_OWNER" -c "$1"
    else
        bash -c "$1"
    fi
}

log() { printf '%s  %s\n' "$(date -u +%H:%M:%S)" "$*"; }

# Milliseconds since the epoch. The drills measure intervals that are shorter
# than the second-resolution timestamps a runbook usually records, and rounding
# an RTO up to the nearest second flatters it.
now_ms() { date -u +%s%3N; }

ensure_owner() {
    if [ "$(id -u)" = "0" ]; then
        id -u "$PG_OWNER" >/dev/null 2>&1 || useradd -r -s /bin/false "$PG_OWNER"
    fi
}

start_primary() {
    ensure_owner
    # A previous drill that was interrupted leaves its service processes behind,
    # and they answer on the drill's ports. Matched on the drill binary's exact
    # path so nothing else on the machine is in scope.
    pkill -f "^$DRILL_BIN\$" 2>/dev/null || true
    # A previous drill that was interrupted leaves a postmaster holding the
    # port. Removing the data directory under a running server would leave it
    # writing into deleted files, so the server is stopped first.
    as_owner "$PGBIN/pg_ctl -D $REPLICA_DATA -m immediate -w stop" >/dev/null 2>&1 || true
    as_owner "$PGBIN/pg_ctl -D $PRIMARY_DATA -m immediate -w stop" >/dev/null 2>&1 || true
    rm -rf "$DRILL_ROOT"
    mkdir -p "$PRIMARY_DATA" "$WAL_ARCHIVE" "$DRILL_ROOT/run"
    if [ "$(id -u)" = "0" ]; then
        chown -R "$PG_OWNER:$PG_OWNER" "$DRILL_ROOT"
    fi

    as_owner "$PGBIN/initdb -D $PRIMARY_DATA -U postgres --auth=scram-sha-256 --auth-local=trust -E UTF8" >/dev/null

    # Archiving is what makes the RPO target achievable at all. A nightly dump
    # cannot deliver five minutes, and treating it as though it could is the
    # usual way this target is missed on paper rather than in practice.
    cat >> "$PRIMARY_DATA/postgresql.conf" <<CONF
port = $PRIMARY_PORT
unix_socket_directories = '$DRILL_ROOT/run'
listen_addresses = '127.0.0.1'
wal_level = replica
archive_mode = on
archive_command = 'test ! -f $WAL_ARCHIVE/%f && cp %p $WAL_ARCHIVE/%f'
archive_timeout = 60
max_wal_senders = 4
wal_keep_size = 64MB
hot_standby = on
# Asynchronous replication on purpose. Synchronous would make the measured RPO
# zero by construction, which is a number about the configuration rather than
# about the recovery -- and it is not what a cross-zone deployment runs, because
# every commit would then wait on the far zone. Async is the case where a hard
# failure can actually lose committed work, so it is the case worth measuring.
CONF
    echo "host replication all 127.0.0.1/32 scram-sha-256" >> "$PRIMARY_DATA/pg_hba.conf"
    echo "host all all 127.0.0.1/32 scram-sha-256" >> "$PRIMARY_DATA/pg_hba.conf"

    as_owner "$PGBIN/pg_ctl -D $PRIMARY_DATA -l $DRILL_ROOT/primary.log -w start" >/dev/null
    log "primary up on $PRIMARY_PORT"
}

primary_psql() { as_owner "$PGBIN/psql -h $DRILL_ROOT/run -p $PRIMARY_PORT -U postgres $*"; }
replica_psql() { as_owner "$PGBIN/psql -h $DRILL_ROOT/run -p $REPLICA_PORT -U postgres $*"; }

seed_database() {
    local password="$1"

    # Objects are owned by a role that cannot log in, and the application
    # connects as a member of it.
    #
    # Found by running the rotation drill (docs/engineering/drill-log.md,
    # DRILL-2026-001): with the login role owning the schema, the runbook's
    # final step -- DROP ROLE core -- fails, because a role that owns objects
    # cannot be dropped. Reassigning ownership mid-rotation is not an option
    # either: it takes exclusive locks across the whole schema, during a
    # procedure whose entire promise is that callers do not notice. Separating
    # "who owns the data" from "who connects" makes a credential rotation a
    # create and a drop, which is what the runbook assumes it is.
    primary_psql "-v ON_ERROR_STOP=1 -c 'CREATE ROLE core_owner NOLOGIN'" >/dev/null
    primary_psql "-v ON_ERROR_STOP=1 -c \"CREATE ROLE core LOGIN PASSWORD '$password' IN ROLE core_owner\"" >/dev/null
    primary_psql "-v ON_ERROR_STOP=1 -c 'CREATE DATABASE core OWNER core_owner'" >/dev/null
    primary_psql "-v ON_ERROR_STOP=1 -c \"CREATE ROLE replicator REPLICATION LOGIN PASSWORD '$password'\"" >/dev/null
    # The restore-verification job needs CREATEDB to build its scratch database.
    # It gets its own role for that reason: the application's role serves
    # patient traffic and has no use for the privilege.
    primary_psql "-v ON_ERROR_STOP=1 -c \"CREATE ROLE core_backup LOGIN CREATEDB PASSWORD '$password' IN ROLE core_owner\"" >/dev/null

    # The migrations are applied exactly as the repository ships them, in
    # lexical order, with core_owner as the owner of everything they create. A
    # drill against a hand-built schema proves nothing about the schema that
    # would actually be restored.
    local file
    for file in "$CODE_ROOT"/db/migrations/*.up.sql; do
        as_owner "PGOPTIONS='-c role=core_owner' $PGBIN/psql -h $DRILL_ROOT/run -p $PRIMARY_PORT -U postgres -d core -v ON_ERROR_STOP=1 -q -f $file" >/dev/null
    done
    log "schema applied from db/migrations, owned by core_owner"
}

start_replica() {
    local password="$1"
    mkdir -p "$REPLICA_DATA"
    if [ "$(id -u)" = "0" ]; then chown "$PG_OWNER:$PG_OWNER" "$REPLICA_DATA"; fi
    chmod 700 "$REPLICA_DATA"

    as_owner "PGPASSWORD=$password $PGBIN/pg_basebackup -h 127.0.0.1 -p $PRIMARY_PORT -U replicator -D $REPLICA_DATA -R -X stream -c fast -C -S drill_replica" >/dev/null 2>&1

    cat >> "$REPLICA_DATA/postgresql.conf" <<CONF
port = $REPLICA_PORT
unix_socket_directories = '$DRILL_ROOT/run'
listen_addresses = '127.0.0.1'
primary_conninfo = 'host=127.0.0.1 port=$PRIMARY_PORT user=replicator password=$password application_name=replica'
restore_command = 'cp $WAL_ARCHIVE/%f %p'
hot_standby = on
CONF
    as_owner "$PGBIN/pg_ctl -D $REPLICA_DATA -l $DRILL_ROOT/replica.log -w start" >/dev/null
    log "replica up on $REPLICA_PORT, streaming from the primary"
}

core_dsn() {
    local user="$1" password="$2" port="$3"
    echo "postgres://$user:$password@127.0.0.1:$port/core?sslmode=disable"
}

start_core() {
    local dsn="$1" port="${2:-$APP_PORT}" name="${3:-core}"
    # Refuse to start on a port something is already answering on, so a stale
    # instance cannot stand in for the one being tested.
    if curl -sf -m 1 -X POST -H 'Content-Type: application/json' -d '{}' \
        "http://127.0.0.1:$port/healthcare.platform_api.v1.HealthService/CheckLiveness" \
        >/dev/null 2>&1; then
        echo "port $port is already serving; refusing to start $name" >&2
        return 1
    fi
    # ALLOW_LOCAL_PLAINTEXT_DB only ever excuses a loopback address, and the
    # drill uses one. TLS_MODE is still required: the binary refuses to start
    # without it, and a drill that patched that out would not be testing the
    # binary that ships.
    DATABASE_URL="$dsn" \
    ALLOW_LOCAL_PLAINTEXT_DB=true \
    AUTH_MODE=dev \
    TLS_MODE=mesh \
    LISTEN_ADDR="127.0.0.1:$port" \
    LOG_LEVEL=info \
    OTEL_EXPORTER_OTLP_ENDPOINT= \
        "$DRILL_BIN" > "$DRILL_ROOT/$name.log" 2>&1 &
    echo $! > "$DRILL_ROOT/$name.pid"
}

# Stops an instance and waits for it to be gone.
#
# Returning while the process is still listening is worse than not stopping it
# at all: the next instance fails to bind, the readiness probe is answered by
# the instance that was supposed to have stopped, and the drill reports a
# rotation that did not happen. This is a real trap -- the first run of the
# rotation drill hit exactly that and reported the old credential still
# connected.
stop_core() {
    local name="${1:-core}"
    [ -f "$DRILL_ROOT/$name.pid" ] || return 0

    local pid; pid="$(cat "$DRILL_ROOT/$name.pid")"
    kill "$pid" 2>/dev/null || true

    local deadline=$(( $(date +%s) + 30 ))
    while kill -0 "$pid" 2>/dev/null; do
        if [ "$(date +%s)" -ge "$deadline" ]; then
            kill -9 "$pid" 2>/dev/null || true
            break
        fi
        sleep 0.1
    done
    wait "$pid" 2>/dev/null || true
    rm -f "$DRILL_ROOT/$name.pid"
}

# Waits for an instance to answer a readiness probe, which touches the
# database. Liveness would answer while the database was gone, which is the
# whole reason the two probes are different.
wait_ready() {
    local port="${1:-$APP_PORT}" seconds="${2:-60}"
    local deadline=$(( $(date +%s) + seconds ))
    while [ "$(date +%s)" -lt "$deadline" ]; do
        if curl -sf -m 2 -X POST \
            -H 'Content-Type: application/json' -d '{}' \
            "http://127.0.0.1:$port/healthcare.platform_api.v1.HealthService/CheckReadiness" \
            >/dev/null 2>&1; then
            return 0
        fi
        sleep 0.2
    done
    return 1
}

teardown() {
    stop_core core-a
    stop_core core-b
    stop_core
    as_owner "$PGBIN/pg_ctl -D $REPLICA_DATA -m immediate -w stop" >/dev/null 2>&1 || true
    as_owner "$PGBIN/pg_ctl -D $PRIMARY_DATA -m immediate -w stop" >/dev/null 2>&1 || true
}
