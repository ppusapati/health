-- 0016 Photographs, configured field access and unidentified registration
-- (SRS-EMPI-010, SRS-EMPI-014, SRS-EMPI-015).
--
-- Three requirements, one migration, because they meet at the same point: what
-- a hospital may record about somebody it cannot yet identify, and who may
-- then see it.
--
-- Trace: SRS-EMPI-010 (photo with consent, never sole identity proof),
--   SRS-EMPI-014 (field-level access where configured),
--   SRS-EMPI-015 (temporary/unknown registration reconciled later).
-- Rollback: drops the photo and field-access tables and the designation columns.
--   Photographs become unreferenced objects in the store with no record of the
--   consent under which they were taken — delete the objects before dropping
--   these rows, not after. Field restrictions revert to the built-in default,
--   which is a *widening* for any tenant that had configured more: check what
--   was configured before rolling back.
-- Reconciliation: the designation columns are nullable and default NULL, which
--   is the correct reading for every existing patient — none was registered
--   unidentified. Rows the previous version writes during the rollout window
--   likewise take NULL and need no backfill.

-- Registration of a patient whose identity is not yet known (SRS-EMPI-015).
--
-- On empi.patient rather than a side table: the designation is a property of
-- the record for as long as it exists, and a join to discover that a patient is
-- an unidentified trauma admission is a join somebody will forget.
--
-- Deliberately NOT in the name columns. A record whose family name is
-- "TRAUMA ALPHA" sorts into the name index, fuzzy-matches the next trauma
-- patient, and prints on a wristband looking exactly like a name.
ALTER TABLE empi.patient
    ADD COLUMN designation_label text;

ALTER TABLE empi.patient
    ADD COLUMN designation_circumstance text NOT NULL DEFAULT '';

-- Estimated at the bedside. Kept alongside the derived birth date because the
-- estimate is what a clinician actually said, and the date is this system's
-- rendering of it.
ALTER TABLE empi.patient
    ADD COLUMN designation_apparent_age integer;

-- When real demographics replaced the designation. NULL while still unknown.
ALTER TABLE empi.patient
    ADD COLUMN identified_at timestamptz;

-- A patient cannot be identified without ever having been unidentified, and an
-- apparent age of 400 is a typo rather than an estimate.
ALTER TABLE empi.patient
    ADD CONSTRAINT identification_follows_a_designation CHECK (
        identified_at IS NULL OR designation_label IS NOT NULL
    );

ALTER TABLE empi.patient
    ADD CONSTRAINT apparent_age_is_an_estimate CHECK (
        designation_apparent_age IS NULL
        OR (designation_apparent_age >= 0 AND designation_apparent_age <= 130)
    );

-- The worklist a ward clerk works: who is still unknown. Partial, because an
-- identified patient is not on it.
CREATE INDEX patient_unidentified_idx
    ON empi.patient (tenant_id, created_at)
    WHERE designation_label IS NOT NULL AND identified_at IS NULL;

-- Which demographic fields are restricted, and what reveals them
-- (SRS-EMPI-014).
--
-- The requirement's operative words are "where configured". Which elements are
-- sensitive is a jurisdiction and a facility question: in a clinic treating
-- people whose address is the thing that endangers them, the street address is
-- the most restricted field on the record; in an outpatient department it is
-- what the receptionist reads back to confirm they have the right person. Same
-- field, opposite handling, and no default serves both.
CREATE TABLE empi.field_access_policy (
    policy_id    uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    jurisdiction text        NOT NULL,
    -- NULL means every facility in the jurisdiction; a row naming one overrides.
    facility_id  uuid,
    field        text        NOT NULL CHECK (field IN (
                     'family_name', 'given_name', 'birth_date',
                     'sex', 'phone', 'email', 'address')),
    -- The permission that reveals this field in full. A field restricted behind
    -- an empty permission is restricted from everybody forever with nothing
    -- saying so.
    required_permission text NOT NULL CHECK (required_permission <> ''),
    created_at   timestamptz NOT NULL,
    updated_at   timestamptz NOT NULL
);

-- One rule per field per scope. Two rows restricting the same field behind
-- different permissions would make access depend on which the reader found
-- first.
CREATE UNIQUE INDEX field_access_policy_scope_key
    ON empi.field_access_policy (
        tenant_id, jurisdiction,
        COALESCE(facility_id, '00000000-0000-0000-0000-000000000000'::uuid),
        field
    );

-- Patient photographs (SRS-EMPI-010).
--
-- Held by reference. The bytes live in an object store behind a port; this is
-- the record that one exists, what it is, and on what basis it was taken. The
-- digest is kept so a stored object can be shown to be the one this row
-- describes — a store that silently returned a different object would otherwise
-- be indistinguishable from one that returned the right one.
CREATE TABLE empi.patient_photo (
    photo_id     uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    patient_id   uuid        NOT NULL,

    storage_key  text        NOT NULL CHECK (storage_key <> ''),
    content_type text        NOT NULL CHECK (content_type IN (
                     'image/jpeg', 'image/png', 'image/webp')),
    byte_size    bigint      NOT NULL CHECK (byte_size > 0),
    digest       text        NOT NULL CHECK (digest <> ''),

    -- Consent has a shape: somebody gave it, at a time, for a stated purpose.
    -- A boolean would record none of that, and "did this patient agree to their
    -- photograph being kept" is a question somebody will be asked to answer
    -- with evidence.
    consent_given_by   text  NOT NULL CHECK (consent_given_by <> ''),
    consent_on_behalf  text  NOT NULL DEFAULT '',
    consent_purpose    text  NOT NULL CHECK (consent_purpose <> ''),
    consent_given_at   timestamptz NOT NULL,
    consent_recorded_by text NOT NULL CHECK (consent_recorded_by <> ''),

    captured_at  timestamptz NOT NULL,
    captured_by  text        NOT NULL CHECK (captured_by <> ''),

    -- Withdrawal keeps the row and loses the bytes. A withdrawal that deleted
    -- the row would leave nobody able to answer whether a photograph ever
    -- existed, which is the question an audit asks after a complaint.
    withdrawn_at     timestamptz,
    withdrawn_reason text        NOT NULL DEFAULT '',

    CONSTRAINT withdrawals_explain_themselves CHECK (
        withdrawn_at IS NULL OR withdrawn_reason <> ''
    )
);

-- One current photograph per patient. A second would leave a nurse comparing
-- the patient against whichever the screen happened to load.
CREATE UNIQUE INDEX patient_photo_current_key
    ON empi.patient_photo (tenant_id, patient_id)
    WHERE withdrawn_at IS NULL;

CREATE INDEX patient_photo_patient_idx
    ON empi.patient_photo (tenant_id, patient_id, captured_at DESC);
