# Runbook: disaster recovery drill

Covers SRS-NFR-005: RPO ≤ 5 minutes, RTO ≤ 60 minutes, verified by "scheduled
DR test meets targets or records remediation".

The second half of that clause is the important one. A drill that is only ever
run when it will pass is not a drill. **A failed drill that produces a
remediation item is a successful drill**; the failure mode to avoid is a drill
that gets quietly rescheduled until conditions are favourable.

## What the targets mean

| Target | Meaning | Measured as |
| --- | --- | --- |
| RPO ≤ 5 min | At most five minutes of committed writes may be lost | Gap between the last recoverable WAL position and the moment of failure |
| RTO ≤ 60 min | Service restored within an hour of the decision to fail over | Wall clock from declaring the incident to the first successful clinical request |

RTO is measured from the **decision**, not from the outage. The time spent
deciding is real and is usually the largest single component — a drill that
starts its clock at "we began the restore" reports a number nobody will
experience.

## What makes the RPO achievable

Continuous WAL archiving, not nightly dumps. The nightly backup
(`core-backup-verify`) protects against corruption and gives a known-good
starting point; it cannot deliver a five-minute RPO on its own, and treating
it as if it could is the most common way this target is missed on paper.

```bash
# Confirm archiving is current before anything else. If this is behind, the
# RPO is already missed and the drill should record that rather than proceed
# as though it were not.
psql -c "SELECT last_archived_wal, last_archived_time,
                now() - last_archived_time AS lag
         FROM pg_stat_archiver;"
```

## The drill (quarterly, pre-production)

Book two hours. The drill itself should take under one; the rest is for the
thing that goes wrong, which is the part worth having.

1. **Start the clock and the load.** A request generator against the
   pre-production endpoint at a rate where a gap is visible. Note the wall time
   — this is T0, the moment of the simulated failure.

2. **Record the last committed transaction.** This is what the RPO is measured
   against.

   ```sql
   SELECT pg_current_wal_lsn(), now();
   ```

3. **Simulate the failure.** Stop the primary hard; do not drain it. A graceful
   shutdown flushes WAL that a real failure would not, and a drill that
   practises the polite case measures a recovery that will not happen.

   ```bash
   kubectl -n data delete pod postgres-primary-0 --grace-period=0 --force
   ```

4. **Declare.** Note the wall time — this is T1, and RTO is measured from here.
   Whoever is on call makes the call; the drill does not skip this step because
   deciding is the part that takes longest in a real incident.

5. **Promote the replica.**

   ```bash
   kubectl -n data exec postgres-replica-0 -- pg_ctl promote
   kubectl -n data patch svc postgres-primary \
     -p '{"spec":{"selector":{"role":"primary","instance":"replica-0"}}}'
   ```

6. **Restart the application** so the pool reconnects to the promoted instance.

   ```bash
   kubectl -n healthcare-preprod rollout restart deployment/core
   kubectl -n healthcare-preprod rollout status deployment/core --timeout=10m
   ```

7. **Record T2**: the first successful clinical request after the restart.
   **RTO = T2 − T1.**

8. **Measure the RPO.** On the promoted instance, find the last transaction
   that survived and compare it with step 2.

   ```sql
   SELECT pg_last_wal_replay_lsn(), now();
   ```

   **RPO = the interval between the last surviving commit and T0.**

9. **Verify data integrity, not just availability.** A service that is up on a
   database missing a day of writes has met its RTO and failed completely.

   ```sql
   -- Row counts against the pre-drill snapshot for the largest tables.
   SELECT 'facility' AS t, count(*) FROM organization.facility
   UNION ALL SELECT 'audit_event', count(*) FROM platform_data.audit_event
   UNION ALL SELECT 'outbox_event', count(*) FROM platform_data.outbox_event;
   ```

   Then verify the security event chain, which is the one structure a partial
   recovery can leave silently broken:

   ```bash
   go run ./cmd/core verify-security-chain --tenant <id>
   ```

   A chain that fails verification after a restore must be investigated before
   anything appends to it — extending a broken chain anchors every future
   event to a bad prefix.

10. **Record the result**, pass or fail, in the drill log with both numbers.

## Recording the outcome

Every drill produces an entry, including the ones that fail:

```
Date:        2026-09-11
Environment: pre-production
RPO:         measured / target 5 min
RTO:         measured / target 60 min
Outcome:     met | missed
Remediation: <ticket reference, for a missed target>
```

A missed target without a remediation reference is an incomplete drill. The
release gate checks for the drill's existence and currency, not its result —
because a team that must pass to release will stop running it in conditions
where it might not.

## If the drill fails

Do not extend the window and retry until it passes. Record the number that was
actually achieved, raise the remediation item, and run the next drill on
schedule. Three consecutive missed drills is an escalation to the accountable
authority named for SRS-SEC-013, not a fourth attempt.

## Emergency access during recovery

Between T0 and T2 the system is unavailable, and the ward is on paper. That is
a downtime episode (SRS-SEC-014): declare one, so the actions taken on paper
are reconciled back afterwards rather than lost. The drill should include
declaring and closing one, because the reconciliation queue is the part of a
real outage that takes longest and gets least practice.
