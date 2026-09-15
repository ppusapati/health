# Runbook: key and credential rotation

Covers SRS-SEC-002 ("key rotation procedure tested") and SRS-SEC-003.

Three things rotate on different schedules for different reasons, and
conflating them is how a rotation drill turns into an outage:

| What | Cadence | Blast radius if it goes wrong |
| --- | --- | --- |
| KMS data keys (database, object store, backup) | 90 days, automatic | None if envelope encryption is used correctly; total data loss if a key is deleted while ciphertext still references it |
| Database credentials | 90 days, or immediately on suspicion | Every pod loses its connection until the new value propagates |
| Service-to-service credentials | Issued by the mesh, hours | Requests fail closed |

## The rule that makes rotation safe

Never delete a key. Disable it, wait a full backup retention period, then
schedule deletion. A key is referenced by every ciphertext ever written under
it, including backups taken months ago and the one you will need during the
incident that made you rotate in the first place.

## The arrangement that makes a credential rotation possible at all

**The role that owns the schema is not the role the application logs in as.**
`core_owner` owns every object and cannot log in; `core`, `core_v2` and the
backup job's role are login roles that are members of it.

This is not tidiness. Two steps below are impossible without it, and both were
found by running the drill rather than by reading it (see
`docs/engineering/drill-log.md`, DRILL-2026-001):

* **Step 7 cannot drop a role that owns objects.** PostgreSQL refuses, and the
  alternative — reassigning ownership mid-rotation — takes exclusive locks
  across the whole schema during a procedure whose entire promise is that
  callers do not notice.
* **The new role must be a member of `core_owner`, not of the outgoing role.**
  Granting `IN ROLE core` is the obvious reading of "same privileges" and it is
  fatal: the new role's only path to the data then runs through the role step 7
  drops, so the rotation appears to succeed and every request afterwards fails
  with a permission error. The drill produced exactly that outage.

## Drill: database credential rotation (run quarterly)

Run in pre-production. The drill is what SRS-SEC-002's "tested" means; a
procedure nobody has executed is a document, not a control.

1. Record the current state so the drill has a baseline.

   ```bash
   kubectl -n healthcare-preprod get externalsecret core-database \
     -o jsonpath='{.status.refreshTime}{"\n"}'
   kubectl -n healthcare-preprod get pods -l app.kubernetes.io/name=core
   ```

2. Start a request generator against the pre-production endpoint, at a rate
   high enough that a gap of even a few seconds is visible in the error rate.
   The drill measures whether callers noticed, not whether the secret changed.

3. Create the new credential in PostgreSQL *alongside* the old one. Both are
   valid at once; this is what makes the rotation non-disruptive.

   ```sql
   -- IN ROLE core_owner, never IN ROLE core. See the arrangement above.
   CREATE ROLE core_v2 LOGIN PASSWORD '<generated>' IN ROLE core_owner;
   ```

4. Update the value in the secret store. Do not touch the cluster.

   ```bash
   vault kv put healthcare/core/database \
     username=core_v2 password='<generated>' host=<host> database=core
   ```

5. Wait for the external-secrets operator to refresh. `refreshInterval` is
   15 minutes, so this is the window the drill exists to measure. Watch:

   ```bash
   kubectl -n healthcare-preprod get externalsecret core-database -w
   ```

6. Roll the deployment once the Secret has changed. pgxpool holds the DSN it
   started with; existing pods keep using the old credential until they
   restart, which is why step 3 leaves both valid.

   ```bash
   kubectl -n healthcare-preprod rollout restart deployment/core
   kubectl -n healthcare-preprod rollout status deployment/core --timeout=5m
   ```

7. Confirm the new credential is in use, then revoke the old one.

   ```sql
   SELECT DISTINCT usename FROM pg_stat_activity WHERE datname = 'core';
   -- expect only core_v2
   DROP ROLE core;
   ```

8. Record the observed error rate and the total elapsed time in the drill log
   (`security/drill-register.yaml`, narrated in
   `docs/engineering/drill-log.md`). **Pass criterion: zero failed requests.**
   A drill with a visible error blip has found a real defect in the rotation
   path — report it rather than recording a pass with a caveat.

   `scripts/drills/rotation-drill.sh` runs this procedure end to end against a
   disposable PostgreSQL and two service instances, and prints the failure
   count. It is not a substitute for the pre-production drill — it does not
   exercise external-secrets, the mesh, or a rollout — but it is what keeps the
   procedure from rotting between quarters, and it is what found the two
   defects above.

### If step 7 shows the old role still connected

A pod did not restart. Do not drop the role: dropping it takes that pod's
connections down. Find the pod, restart it, and re-check. Dropping a role that
is still in use is the most common way a rotation drill becomes an incident.

## Drill: KMS key rotation

KMS rotation is automatic on the 90-day schedule; the drill verifies that
ciphertext written under the previous key version is still readable, which is
the property that actually matters.

1. Note the current key version:
   `aws kms describe-key --key-id alias/healthcare/preprod/database`
2. Force a rotation: `aws kms rotate-key-on-demand --key-id <id>`
3. Restore last night's backup into a scratch database. The backup was
   encrypted under the previous key version, so a successful restore is the
   evidence. The nightly verify job (`core-backup-verify`) already performs a
   restore-and-compare; running it after a rotation is the whole drill.
4. Confirm `KMS_KEY_ALIAS_BACKUP` and `KMS_KEY_ALIAS_DATABASE` are still
   distinct aliases. `tools/infra` asserts this in CI, but the drill is where
   someone would have "simplified" it.

## Emergency rotation (credential believed compromised)

Skip the 15-minute refresh window: patch the Secret directly, then let the
operator reconcile back to the store afterwards.

```bash
kubectl -n healthcare create secret generic core-database \
  --from-literal=url='postgres://...?sslmode=verify-full' \
  --dry-run=client -o yaml | kubectl apply -f -
kubectl -n healthcare rollout restart deployment/core
```

Then revoke the old credential **immediately** rather than waiting for pods to
drain — in a compromise the old credential is the threat, and a few failed
requests are cheaper than continued access. Record the event in the security
event chain with class `credential.rotated` and open an incident.
