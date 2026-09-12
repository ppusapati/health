-- 0013 Demographic history, communication preferences and related persons
-- (SRS-EMPI-007, SRS-EMPI-009).
--
-- Everything here is effective-dated, and the reason is one failure repeated in
-- three forms.
--
-- A patient marries and the desk overwrites the surname. Six months later a
-- laboratory result addressed to the maiden name arrives, a clerk searches,
-- finds nobody, and files it under a new record. Now there are two.
--
-- A guardian's authority ends when a child turns eighteen. Without an end date
-- the grant stands, and the person who needed it in 2019 still has it.
--
-- A patient agrees to appointment reminders by SMS. Stored as "reachable by
-- SMS", that agreement sends them their test results.
--
-- So: names are never overwritten, authorities always expire, and preferences
-- are held per purpose rather than per channel.
--
-- Note what is NOT here: the current name stays on empi.patient as columns.
-- That is what the matcher reads and what the search index is built over, and
-- reconstructing it from history would be a join per candidate on every
-- registration. The columns are the aggregate's current state; these tables
-- are the record. Both are written in one transaction.
--
-- Trace: SRS-EMPI-007, SRS-EMPI-009, SRS-PLT-013 (effective dating).
--
-- Rollback: drops the history. Prior names stop being searchable, which
--   re-opens the duplicate-creation path above, and caregiver authorities
--   vanish rather than expiring. Restore rather than run this anywhere with
--   data.
-- Reconciliation: none for the forward direction; these tables are new.

CREATE TABLE empi.patient_name (
    name_id      uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    patient_id   uuid        NOT NULL REFERENCES empi.patient (patient_id),

    -- legal is the name on the identity document; preferred is what the patient
    -- asks to be called; alias is another name they are known by. A preferred
    -- name is an addition, never a replacement for the paperwork.
    kind         text        NOT NULL CHECK (kind IN ('legal', 'preferred', 'alias')),

    family_name  text        NOT NULL DEFAULT '',
    given_names  text[]      NOT NULL DEFAULT '{}',
    name_prefix  text        NOT NULL DEFAULT '',
    name_suffix  text        NOT NULL DEFAULT '',
    CONSTRAINT recorded_names_have_content CHECK (
        family_name <> '' OR cardinality(given_names) > 0),

    -- Half-open [from, until). Closed intervals make the changeover day
    -- ambiguous, and somebody always ends up in both.
    effective_from  timestamptz NOT NULL,
    effective_until timestamptz,
    CONSTRAINT name_window_is_ordered CHECK (
        effective_until IS NULL OR effective_until > effective_from),

    recorded_by  text        NOT NULL CHECK (recorded_by <> ''),
    recorded_at  timestamptz NOT NULL,
    source       text        NOT NULL DEFAULT ''
);

-- Searching every name a patient was ever known by is the whole point, so the
-- index covers closed windows too.
CREATE INDEX patient_name_search_idx
    ON empi.patient_name (tenant_id, lower(family_name));

CREATE INDEX patient_name_patient_idx
    ON empi.patient_name (tenant_id, patient_id, kind, effective_from DESC);

-- One open legal name at a time. Two would give a wristband two answers, and
-- the printer would pick whichever row came back first.
CREATE UNIQUE INDEX patient_name_one_open_legal_key
    ON empi.patient_name (tenant_id, patient_id)
    WHERE kind = 'legal' AND effective_until IS NULL;

CREATE TABLE empi.communication_preference (
    preference_id uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    patient_id    uuid        NOT NULL REFERENCES empi.patient (patient_id),

    channel       text        NOT NULL CHECK (channel IN ('sms', 'email', 'phone', 'post')),
    -- Per purpose, not per channel. A patient who wants appointment reminders
    -- by SMS may want nothing else by SMS.
    purpose       text        NOT NULL CHECK (purpose IN (
                      'appointment_reminder', 'results', 'billing', 'health_promotion')),
    -- false is a recorded refusal, which is not the same as an absent row: one
    -- says the patient declined, the other says nobody asked.
    allowed       boolean     NOT NULL,

    effective_from  timestamptz NOT NULL,
    effective_until timestamptz,
    CONSTRAINT preference_window_is_ordered CHECK (
        effective_until IS NULL OR effective_until > effective_from),

    recorded_by   text        NOT NULL CHECK (recorded_by <> ''),
    recorded_at   timestamptz NOT NULL
);

CREATE INDEX communication_preference_patient_idx
    ON empi.communication_preference (tenant_id, patient_id, channel, purpose, effective_from DESC);

-- One open answer per channel and purpose.
CREATE UNIQUE INDEX communication_preference_one_open_key
    ON empi.communication_preference (tenant_id, patient_id, channel, purpose)
    WHERE effective_until IS NULL;

CREATE TABLE empi.related_person (
    relationship_id uuid      PRIMARY KEY,
    tenant_id       uuid      NOT NULL,
    patient_id      uuid      NOT NULL REFERENCES empi.patient (patient_id),

    -- Either a record in this index — a parent usually is one — or a name and a
    -- way to reach somebody who will never be a patient here, such as a
    -- care-home key worker. Refusing the second would push staff to write the
    -- name in a free-text note.
    related_patient_id uuid   REFERENCES empi.patient (patient_id),
    family_name     text      NOT NULL DEFAULT '',
    given_names     text[]    NOT NULL DEFAULT '{}',
    contact         jsonb     NOT NULL DEFAULT '[]'::jsonb,
    CONSTRAINT related_person_is_identified CHECK (
        related_patient_id IS NOT NULL OR family_name <> '' OR cardinality(given_names) > 0),
    CONSTRAINT related_person_is_not_the_patient CHECK (
        related_patient_id IS NULL OR related_patient_id <> patient_id),

    relationship    text      NOT NULL CHECK (relationship IN (
                        'parent', 'guardian', 'spouse', 'child', 'sibling',
                        'caregiver', 'emergency_contact')),
    -- What this person may do. Empty is legitimate and common: an emergency
    -- contact is somebody to telephone, not somebody with rights over the
    -- record.
    authorities     text[]    NOT NULL DEFAULT '{}',
    CONSTRAINT emergency_contacts_hold_no_authority CHECK (
        relationship <> 'emergency_contact' OR cardinality(authorities) = 0),

    effective_from  timestamptz NOT NULL,
    effective_until timestamptz,
    CONSTRAINT relationship_window_is_ordered CHECK (
        effective_until IS NULL OR effective_until > effective_from),

    -- An unverified relationship carries no authority. "I am her son" is a
    -- sentence anybody can say at a reception desk, and the note says what was
    -- actually checked — a birth certificate, a court order — rather than that
    -- something was.
    verified_by       text        NOT NULL DEFAULT '',
    verified_at       timestamptz,
    verification_note text        NOT NULL DEFAULT '',
    CONSTRAINT verification_says_what_was_checked CHECK (
        verified_at IS NULL OR (verified_by <> '' AND verification_note <> '')),

    recorded_by     text        NOT NULL CHECK (recorded_by <> ''),
    recorded_at     timestamptz NOT NULL
);

CREATE INDEX related_person_patient_idx
    ON empi.related_person (tenant_id, patient_id, effective_from DESC);

-- "What may this person do for that patient right now", which is the question
-- an authorization check asks.
CREATE INDEX related_person_reverse_idx
    ON empi.related_person (tenant_id, related_patient_id, patient_id)
    WHERE related_patient_id IS NOT NULL;
