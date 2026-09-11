#!/usr/bin/env bash
# Local PostgreSQL for repository integration tests.
#
# Repository tests run against a real database rather than a mocked SQL layer
# (Testing Master Plan §9), so a developer needs one instance running. This
# script keeps that a one-liner without requiring Docker.
set -euo pipefail

PGBIN="${PGBIN:-/usr/lib/postgresql/16/bin}"
PGDATA="${PGDATA:-/tmp/health-pgdata}"
PGPORT="${PGPORT:-55432}"
PGSOCKET="${PGSOCKET:-/tmp/health-pgrun}"
PGUSER_NAME="${PGUSER_NAME:-postgres}"

run_as_postgres() {
    if [ "$(id -u)" = "0" ]; then
        su "$PGUSER_NAME" -c "$1"
    else
        bash -c "$1"
    fi
}

start() {
    if [ ! -d "$PGDATA/base" ]; then
        mkdir -p "$PGDATA" "$PGSOCKET"
        if [ "$(id -u)" = "0" ]; then
            id -u "$PGUSER_NAME" >/dev/null 2>&1 || useradd -r -s /bin/false "$PGUSER_NAME"
            chown "$PGUSER_NAME:$PGUSER_NAME" "$PGDATA" "$PGSOCKET"
        fi
        run_as_postgres "$PGBIN/initdb -D $PGDATA -U postgres --auth=trust -E UTF8" >/dev/null
    fi

    run_as_postgres "$PGBIN/pg_ctl -D $PGDATA \
        -o '-p $PGPORT -k $PGSOCKET -c listen_addresses=127.0.0.1' \
        -l $PGDATA/server.log -w start"

    echo "PostgreSQL listening on 127.0.0.1:$PGPORT"
    echo "export TEST_DATABASE_URL='postgres://postgres@127.0.0.1:$PGPORT/postgres?sslmode=disable'"
}

stop() {
    run_as_postgres "$PGBIN/pg_ctl -D $PGDATA -w stop" || true
}

case "${1:-start}" in
    start) start ;;
    stop) stop ;;
    restart) stop; start ;;
    *) echo "usage: $0 {start|stop|restart}" >&2; exit 1 ;;
esac
