# Runbook: backup and restore verification

| | |
|---|---|
| Job | `core-backup-verify` CronJob, 01:00 UTC daily |
| Owning team | Platform |
| Requirement | SRS-DAT-011, SRS-NFR-016 |

## What the job does

Dump → restore into a scratch database → compare row counts → upload only if
the comparison matches.

SRS-NFR-016 is explicit that backup success alone is insufficient evidence. An
unverified dump in a bucket produces false confidence at exactly the moment it
matters, so this job refuses to publish a dump it could not restore.

## Alert: `core-backup-verify` Job failed

The failure message names which half failed.

### `RESTORE VERIFICATION FAILED`

The dump restored but row counts differ from the source.

This is the serious case. Do not re-run and hope. Treat the most recent
*verified* dump as the current recovery point, and investigate:

- Was the source changing during the dump? `pg_dump` is consistent, so drift
  points at the comparison, not the backup.
- Did a migration add or drop a table between dump and compare?

### `pg_dump` or `pg_restore` failed

Usually credentials, disk on the `work` volume, or the destination being
unreachable. The previous verified dump remains valid; recovery capability is
degraded, not lost.

## Manual restore

```bash
# 1. Confirm the dump verified. Only verified dumps reach the bucket.
# 2. Restore into a NEW database. Never restore over a live one.
createdb -T template0 core_restore_$(date -u +%Y%m%dT%H%M%SZ)
pg_restore --no-owner --no-acl --dbname="$TARGET_URL" core-<stamp>.dump

# 3. Verify before cutting over.
psql "$TARGET_URL" -c "SELECT count(*) FROM organization.tenant"
psql "$TARGET_URL" -c "SELECT count(*) FROM platform_data.outbox_event WHERE published_at IS NULL"
```

Unpublished outbox rows in a restored database will be published again on
startup. Consumers deduplicate on `event_id` through the inbox, so this is safe
— which is precisely why the inbox exists.

## Recovery objectives

Wave-0 engineering baselines, not contractual SLAs (Wave-0 spec §10):

| Tier | RTO | RPO |
|---|---|---|
| Tier 0 | ≤ 15 min | ≤ 5 min |
| Tier 1 | ≤ 60 min | ≤ 15 min |
| Tier 2 | ≤ 4 h | ≤ 24 h |

A daily logical backup alone does **not** meet Tier 0 or Tier 1 RPO. Continuous
archiving and point-in-time recovery are required before any Tier 0/1 workload
goes live, and are outstanding work — see `wave-0-status.md`.
