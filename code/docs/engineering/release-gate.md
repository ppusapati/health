# Release gate

The human half of the checks in `tools/security`. Covers SRS-SEC-006
(critical findings block release unless formally risk accepted) and
SRS-SEC-013 (penetration test before major production launch).

## What the machine checks

Run by CI on every change:

| Check | Where | Blocks on |
| --- | --- | --- |
| Secret scanning | `.github/workflows/security.yml` → `secrets` | any hit in history |
| SAST | → `sast` | medium+ at medium+ confidence |
| Dependency vulnerabilities | → `dependencies` | any reachable Go vuln; high+ npm |
| SBOM | → `sbom` | generation failure |
| Container scan | → `container` | fixable critical/high |
| IaC scan | → `iac` | critical/high misconfiguration |
| Risk acceptance register | → `risk-acceptances` | malformed or expired entry |
| Threat model actions | `tools/security` | an open action past its due date |
| Manifest invariants | `tools/infra` | a weakened security control |
| Architecture fitness | `tools/fitness` | a crossed layer boundary |

Run only for a production release:

```bash
RELEASE_CHANNEL=production go test ./tools/security/ -count=1
```

This adds the penetration-test gate. **It fails today, and correctly so:**
no engagement is registered, and Wave 0 is pre-production.

## What a person checks

Before a production release, in this order. Steps 1–3 are the ones that cannot
be automated because they are judgements, not conditions.

1. **Has the security architecture materially changed since the last
   engagement?** SRS-SEC-013 requires a new test after a material change, and
   only a person can decide what is material. The bar: a change to
   authentication, authorization, tenant scoping, the cryptographic story, or
   any new externally reachable surface. Compare against
   `architecture_revision` on the covering engagement in
   `security/pentest-register.yaml`.

2. **Does the threat model still describe the system?** Re-read
   `docs/engineering/threat-model.md` against the diff since the last release.
   A new bounded context handling PHI, a closed ADR that moves a trust
   boundary, or a new integration each require the model to be revisited
   (SRS-SEC-007). If it does, that work happens before the release, not after.

3. **Is every risk acceptance still true?** The register enforces that
   acceptances have not expired. It cannot tell you that the compensating
   control named in one is still in place. Check each live entry.

4. Confirm the backup restore verification passed last night
   (`core-backup-verify`). Backup success alone proves nothing; the job
   restores and compares row counts, and that result is the evidence
   (SRS-NFR-016).

5. Confirm the rotation drill is within its quarter
   (`docs/engineering/runbooks/key-rotation.md`).

## Accepting a risk

Do not edit a scanner ignore file on its own — `tools/security` rejects an
uncited suppression. Add the acceptance first:

1. Add an entry to `security/risk-acceptances.yaml` with an owner, a
   justification that argues why the finding does not apply *to this system*,
   a compensating control (or the word `none`, honestly), and an expiry no more
   than a year out.
2. Reference its id from the scanner's ignore file: `CVE-2025-00000  # RA-0001`.
3. Get review from the accountable authority named for SRS-SEC-013.

The expiry is the part that matters. An acceptance without one is a permanent
hole with a paper trail.

## Accepting a penetration test finding

High and critical findings block the release. To accept one instead of fixing
it, set `state: accepted` in `security/pentest-register.yaml` with:

- `accepted_by` — must be one of the accountable authorities the gate
  recognises; the list is in `tools/security/pentest_test.go`
- `expires_on` — when the acceptance lapses and the finding blocks again
- `justification` — why this is tolerable, specifically

Medium and low findings do not block, which does not mean they are ignored:
they become threat-model actions with due dates.
