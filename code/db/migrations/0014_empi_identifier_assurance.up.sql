-- Identifier assurance and verification (SRS-EMPI-011).
--
-- An identifier row already records what the value is, who issued it and where
-- this system learned it. What it does not record is whether anybody
-- authoritative ever confirmed it, and that is the difference between a number
-- a clerk read off a photocopy and one ABDM returned for this person.
--
-- SRS-EMPI-010 depends on the distinction: the identity workflow must include a
-- configured *positive* identifier, and an unconfirmed number is not one.
--
-- Trace: SRS-EMPI-011 (link/unlink history and source retained), SRS-EMPI-010
--   (positive identification), SRS-DAT-006 (expand only).
-- Rollback: drops both columns. Every identifier reverts to being indistinguish-
--   able from every other, so any check that required positive identification
--   silently stops being able to make the distinction rather than failing. Drop
--   only after the code reading `assurance` is gone.
-- Reconciliation: existing rows default to 'asserted', which is the honest
--   answer — nothing verified them. Rows the previous version inserts during
--   the rollout window also take the default, so no backfill is needed and none
--   of them is wrongly marked verified.

ALTER TABLE empi.patient_identifier
    ADD COLUMN assurance text NOT NULL DEFAULT 'asserted'
        CHECK (assurance IN ('asserted', 'verified'));

-- Nullable: an identifier nobody has confirmed has no verification moment, and
-- a zero timestamp would read as one that happened at the epoch.
ALTER TABLE empi.patient_identifier
    ADD COLUMN verified_at timestamptz;

-- Verified means somebody verified it, at a time, and said who.
--
-- Enforced here rather than only in the domain because this is the column a
-- later feature will read to decide whether identity was positively
-- established, and a row that claims verification without an author or a moment
-- would answer yes to a question it cannot support.
ALTER TABLE empi.patient_identifier
    ADD CONSTRAINT verified_identifiers_say_when_and_by_whom CHECK (
        assurance = 'asserted'
        OR (verified_at IS NOT NULL AND assigning_authority <> '')
    );

-- Finding the patients whose identity rests on an unverified identifier is a
-- data-quality worklist, not a rare audit: partial, because the verified rows
-- are not what anybody queries for.
CREATE INDEX patient_identifier_unverified_idx
    ON empi.patient_identifier (tenant_id, identifier_type)
    WHERE status = 'active' AND assurance = 'asserted';
