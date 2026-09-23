-- 0045 Mortuary operations (SRS-MORT-001 … 008).
--
-- Trace: SRS-MORT-001 … SRS-MORT-008.
--
-- Four shapes here are unusual and deliberate.
--
-- A medico-legal case cannot be released without its authority's clearance,
-- and that is a rule the database keeps. mortuary.release carries
-- case_medico_legal beside case_id, held by a composite foreign key ON UPDATE
-- CASCADE onto mortuary.case (case_id, medico_legal), with a CHECK that a
-- medico-legal release names both an authority and the authority's own
-- reference. SRS-MORT-007's acceptance is that the case cannot bypass
-- required authorization, and a rule the application is the only thing
-- enforcing is one a migration, a backfill or a second client walks straight
-- past. The cascade is the point: marking a case medico-legal after a release
-- was written without a clearance fails against the CHECK rather than quietly
-- leaving a body released under no authority at all. It follows that the flag
-- cannot be set on a case whose release was improper — which is the right way
-- round, because the alternative is a system that lets it happen and then
-- cannot say so.
--
-- A body is in one place at a time. mortuary.placement carries a partial
-- unique index on (tenant_id, location_id) WHERE state = 'current', and
-- another on (tenant_id, case_id) for the same reason from the other side.
-- Two cases in one refrigerated space is one body somebody will not find, and
-- a mortuary discovers this with a family standing in the corridor. The
-- storage tag is unique the same way: two bodies with the same tag cannot be
-- told apart at the point where telling them apart is the whole job.
--
-- The chain of custody is append-only. mortuary.custody_entry takes inserts
-- only and is registered with FIT-08. A chain somebody can edit says whatever
-- the last person to touch it wanted it to say, which is precisely what a
-- chain of custody exists not to be.
--
-- And the sensitive text lives in one column with nothing derived from it.
-- mortuary.case.cause_summary is what SRS-MORT-003 puts behind its own
-- permission; no index, no view and no event carries it, and the occupancy
-- board is a projection that has no field for it. A dashboard that could show
-- a cause of death is one that will, on a screen in a corridor.
--
-- Rollback: drops the schema. Every case, placement, belonging, custody line,
-- postmortem request and release goes with it. The encounters the in-hospital
-- cases point at survive, and so do the documents a release references, but
-- the mortuary's own account of who took which body and under whose authority
-- does not, and is not recoverable from either.
--
-- Reconciliation: the tables are new, so the previous version writes nothing
-- here and there is nothing to reconcile on the way back. Forward, a release
-- whose case predates this migration cannot exist: both are created here.

CREATE SCHEMA IF NOT EXISTS mortuary;

-- ----------------------------------------------------------------- cases

CREATE TABLE mortuary.case (
    case_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    -- What everybody says out loud: the number on the tag, on the register
    -- and on the paperwork the family carries away.
    reference text NOT NULL
        CONSTRAINT a_case_names_its_reference CHECK (reference <> ''),

    source text NOT NULL
        CHECK (source IN ('in_hospital', 'brought_in')),
    encounter_id uuid,
    patient_id   uuid,
    -- Who brought the body in. Required for a brought-in case: a body that
    -- arrived from nowhere is one nobody can ask about.
    external_source text NOT NULL DEFAULT '',

    -- A case is linked to a death this hospital recorded or it is plainly
    -- marked as external, and there is no third state.
    CONSTRAINT an_in_hospital_case_names_its_encounter
        CHECK (source <> 'in_hospital' OR encounter_id IS NOT NULL),
    CONSTRAINT a_brought_in_case_says_where_from
        CHECK (source <> 'brought_in' OR external_source <> ''),
    CONSTRAINT a_brought_in_case_has_no_encounter_here
        CHECK (source <> 'brought_in' OR encounter_id IS NULL),

    identity text NOT NULL
        CHECK (identity IN ('unidentified', 'presumed', 'confirmed')),
    identified_by   text NOT NULL DEFAULT '',
    identified_at   timestamptz,
    identified_note text NOT NULL DEFAULT '',
    -- "Confirmed" with nothing behind it is a word somebody typed. How it
    -- was confirmed is what makes the confirmation reviewable.
    CONSTRAINT a_confirmed_identification_says_how
        CHECK (identity <> 'confirmed'
               OR (identified_by <> '' AND identified_note <> '')),

    display_name text NOT NULL DEFAULT '',
    -- A name on an unidentified body is the name somebody guessed, and it
    -- will be read as the name somebody established.
    CONSTRAINT an_unidentified_case_carries_no_name
        CHECK (identity <> 'unidentified' OR display_name = ''),

    medico_legal  boolean NOT NULL DEFAULT false,
    mlc_reference text NOT NULL DEFAULT '',
    restricted    boolean NOT NULL DEFAULT false,

    -- The sensitive text SRS-MORT-003 puts behind its own permission. No
    -- index and nothing derived from it.
    cause_summary text NOT NULL DEFAULT '',

    death_certificate_ref   text NOT NULL DEFAULT '',
    certificate_recorded_by text NOT NULL DEFAULT '',
    certificate_recorded_at timestamptz,

    state text NOT NULL
        CHECK (state IN ('received', 'stored', 'released')),
    location_id uuid,
    storage_tag text NOT NULL DEFAULT '',
    -- A released body is in no drawer. A case that says otherwise is one the
    -- board will show as occupying a space nobody can open.
    CONSTRAINT a_released_case_is_in_no_space
        CHECK (state <> 'released'
               OR (location_id IS NULL AND storage_tag = '')),
    CONSTRAINT a_stored_case_names_its_space
        CHECK (state <> 'stored'
               OR (location_id IS NOT NULL AND storage_tag <> '')),

    died_at     timestamptz,
    received_at timestamptz NOT NULL DEFAULT now(),
    received_by text NOT NULL
        CONSTRAINT a_case_names_who_received_it CHECK (received_by <> ''),
    facility_id uuid,

    created_at timestamptz NOT NULL DEFAULT now(),
    created_by text NOT NULL
        CONSTRAINT a_case_names_who_opened_it CHECK (created_by <> ''),
    version bigint NOT NULL DEFAULT 1,

    -- The composite key the release's authority check hangs off.
    UNIQUE (case_id, medico_legal)
);

-- One reference is one case. Two rows for one body means two registers, and
-- a family asking at the desk is told whichever the clerk opened.
CREATE UNIQUE INDEX case_reference_idx
    ON mortuary.case (tenant_id, upper(reference));

CREATE INDEX case_open_idx
    ON mortuary.case (tenant_id, received_at)
    WHERE state <> 'released';

CREATE INDEX case_encounter_idx
    ON mortuary.case (tenant_id, encounter_id)
    WHERE encounter_id IS NOT NULL;

-- --------------------------------------------------------------- storage

CREATE TABLE mortuary.location (
    location_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,

    -- What is painted on the door.
    code text NOT NULL
        CONSTRAINT a_location_names_its_code CHECK (code <> ''),
    kind text NOT NULL
        CHECK (kind IN ('refrigerated', 'freezer', 'viewing',
                        'postmortem')),
    facility_id uuid,
    zone        text NOT NULL DEFAULT '',

    -- A broken unit is still a space, and the bodies that were in it last
    -- month were in it. Taken off the board rather than deleted.
    out_of_service        boolean NOT NULL DEFAULT false,
    out_of_service_reason text NOT NULL DEFAULT ''
        CONSTRAINT a_space_off_the_board_says_why
        CHECK (NOT out_of_service OR out_of_service_reason <> ''),

    created_at timestamptz NOT NULL DEFAULT now(),
    created_by text NOT NULL
        CONSTRAINT a_location_names_who_added_it CHECK (created_by <> ''),
    version bigint NOT NULL DEFAULT 1
);

CREATE UNIQUE INDEX location_code_idx
    ON mortuary.location (tenant_id, upper(code));

CREATE TABLE mortuary.placement (
    placement_id uuid PRIMARY KEY,
    tenant_id    uuid NOT NULL,

    case_id uuid NOT NULL
        REFERENCES mortuary.case (case_id) ON DELETE CASCADE,
    location_id uuid NOT NULL
        REFERENCES mortuary.location (location_id),
    -- What the person opening the drawer actually reads.
    storage_tag text NOT NULL
        CONSTRAINT a_placement_names_its_tag CHECK (storage_tag <> ''),

    state text NOT NULL CHECK (state IN ('current', 'ended')),

    -- The positive identity check made at the moment of placing.
    -- SRS-MORT-002 asks for it here rather than only at release: a body put
    -- in the wrong drawer is found by the next person who opens it, and by
    -- then nobody remembers.
    identity_checked_by text NOT NULL
        CONSTRAINT a_placement_names_who_checked CHECK (
            identity_checked_by <> ''),
    identity_checked_note text NOT NULL
        CONSTRAINT a_placement_says_what_was_checked CHECK (
            identity_checked_note <> ''),

    placed_at timestamptz NOT NULL DEFAULT now(),
    placed_by text NOT NULL
        CONSTRAINT a_placement_names_who_made_it CHECK (placed_by <> ''),
    ended_at   timestamptz,
    ended_by   text NOT NULL DEFAULT '',
    -- A body that moved for no recorded reason is one nobody can follow.
    ended_reason text NOT NULL DEFAULT '',
    CONSTRAINT an_ended_placement_says_who_and_why
        CHECK (state <> 'ended'
               OR (ended_at IS NOT NULL AND ended_by <> ''
                   AND ended_reason <> ''))
);

-- One body per space, and one space per body. Two cases in one refrigerated
-- unit is one body somebody will not find; one case in two spaces is a
-- mortuary that does not know where it put somebody.
CREATE UNIQUE INDEX placement_one_body_per_space_idx
    ON mortuary.placement (tenant_id, location_id)
    WHERE state = 'current';

CREATE UNIQUE INDEX placement_one_space_per_body_idx
    ON mortuary.placement (tenant_id, case_id)
    WHERE state = 'current';

-- And one tag is on one body. Two bodies with the same tag cannot be told
-- apart at the point where telling them apart is the whole job.
CREATE UNIQUE INDEX placement_tag_idx
    ON mortuary.placement (tenant_id, upper(storage_tag))
    WHERE state = 'current';

CREATE INDEX placement_case_idx
    ON mortuary.placement (tenant_id, case_id, placed_at);

-- ------------------------------------------------------------ belongings

CREATE TABLE mortuary.handover (
    handover_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,
    case_id     uuid NOT NULL
        REFERENCES mortuary.case (case_id) ON DELETE CASCADE,

    recipient_name text NOT NULL
        CONSTRAINT a_handover_names_who_took_them
        CHECK (recipient_name <> ''),
    recipient_relation text NOT NULL DEFAULT '',
    -- Belongings handed to somebody nobody asked for identification from is
    -- the story that ends in a complaint.
    recipient_id_type text NOT NULL
        CONSTRAINT a_handover_records_the_recipients_id
        CHECK (recipient_id_type <> ''),
    recipient_id_ref text NOT NULL
        CONSTRAINT a_handover_records_the_id_reference
        CHECK (recipient_id_ref <> ''),

    -- The acceptance names the signature reference, and it is the only part
    -- of this a family can be shown afterwards. A reference rather than an
    -- image: the document lives where documents live.
    signature_ref text NOT NULL
        CONSTRAINT a_handover_records_the_signature
        CHECK (signature_ref <> ''),

    handed_at timestamptz NOT NULL DEFAULT now(),
    handed_by text NOT NULL
        CONSTRAINT a_handover_names_who_made_it CHECK (handed_by <> ''),
    -- One person signing as both is the control not working.
    witnessed_by text NOT NULL
        CONSTRAINT a_handover_is_witnessed CHECK (witnessed_by <> ''),
    CONSTRAINT a_handover_witness_is_somebody_else
        CHECK (witnessed_by <> handed_by),
    note text NOT NULL DEFAULT ''
);

CREATE INDEX handover_case_idx
    ON mortuary.handover (tenant_id, case_id, handed_at);

CREATE TABLE mortuary.belonging (
    item_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    case_id   uuid NOT NULL
        REFERENCES mortuary.case (case_id) ON DELETE CASCADE,

    kind text NOT NULL
        CHECK (kind IN ('valuable', 'document', 'clothing', 'other')),
    description text NOT NULL
        CONSTRAINT an_item_says_what_it_is CHECK (description <> ''),
    -- "Three rings" is a different listing from "a ring", and a family that
    -- gets two back needs the first to have been written down.
    quantity int NOT NULL
        CONSTRAINT an_item_says_how_many CHECK (quantity > 0),

    state text NOT NULL
        CHECK (state IN ('held', 'handed_over', 'retained')),

    -- A valuable in an unsealed bag is one nobody can say was not opened.
    seal_number text NOT NULL DEFAULT ''
        CONSTRAINT a_valuable_goes_into_a_seal
        CHECK (kind <> 'valuable' OR seal_number <> ''),

    listed_at timestamptz NOT NULL DEFAULT now(),
    listed_by text NOT NULL
        CONSTRAINT a_listing_names_who_made_it CHECK (listed_by <> ''),
    -- A list of what was in somebody's pockets, made by one person alone, is
    -- a list nobody can stand behind.
    witnessed_by text NOT NULL DEFAULT ''
        CONSTRAINT a_valuable_is_listed_with_a_witness
        CHECK (kind <> 'valuable' OR witnessed_by <> ''),
    CONSTRAINT a_listing_witness_is_somebody_else
        CHECK (witnessed_by = '' OR witnessed_by <> listed_by),

    handover_id uuid
        REFERENCES mortuary.handover (handover_id),
    -- An item marked as handed over with no handover behind it is a ring
    -- somebody signed for on a page that does not exist.
    CONSTRAINT a_handed_item_names_its_handover
        CHECK (state <> 'handed_over' OR handover_id IS NOT NULL),
    CONSTRAINT an_unhanded_item_names_no_handover
        CHECK (state = 'handed_over' OR handover_id IS NULL)
);

CREATE INDEX belonging_case_idx
    ON mortuary.belonging (tenant_id, case_id, listed_at);

CREATE INDEX belonging_held_idx
    ON mortuary.belonging (tenant_id, case_id)
    WHERE state = 'held';

-- Append-only (FIT-08). A chain somebody can edit says whatever the last
-- person to touch it wanted it to say, which is what a chain of custody
-- exists not to be.
CREATE TABLE mortuary.custody_entry (
    entry_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    case_id   uuid NOT NULL
        REFERENCES mortuary.case (case_id) ON DELETE CASCADE,

    event text NOT NULL
        CONSTRAINT a_custody_entry_says_what_happened CHECK (event <> ''),
    -- The short human line beside it. No cause of death and no medico-legal
    -- narrative: the chain is read more widely than the case.
    detail text NOT NULL DEFAULT '',

    from_party text NOT NULL DEFAULT '',
    to_party   text NOT NULL DEFAULT '',

    recorded_at timestamptz NOT NULL DEFAULT now(),
    -- A chain attributed to nobody has a gap in it exactly where somebody
    -- would want one.
    recorded_by text NOT NULL
        CONSTRAINT a_custody_entry_names_who_recorded_it
        CHECK (recorded_by <> '')
);

CREATE INDEX custody_entry_case_idx
    ON mortuary.custody_entry (tenant_id, case_id, recorded_at);

-- ------------------------------------------------------------ postmortem

CREATE TABLE mortuary.postmortem (
    postmortem_id uuid PRIMARY KEY,
    tenant_id     uuid NOT NULL,
    case_id       uuid NOT NULL
        REFERENCES mortuary.case (case_id) ON DELETE CASCADE,

    kind text NOT NULL
        CHECK (kind IN ('clinical', 'medico_legal')),
    reason text NOT NULL
        CONSTRAINT a_request_says_why CHECK (reason <> ''),

    state text NOT NULL
        CHECK (state IN ('requested', 'authorised', 'performed',
                         'reported', 'declined')),

    authority           text NOT NULL DEFAULT '',
    authority_reference text NOT NULL DEFAULT '',
    authorised_by       text NOT NULL DEFAULT '',
    authorised_at       timestamptz,
    -- An examination nobody authorised is what this workflow exists to
    -- prevent. A body opened on a request alone is one somebody answers for.
    CONSTRAINT an_examination_follows_an_authorisation
        CHECK (state NOT IN ('performed', 'reported')
               OR (authority <> '' AND authorised_at IS NOT NULL)),
    -- "Authorised by the coroner" with no reference is a sentence, and the
    -- question asked at the inquest is which order.
    CONSTRAINT a_medico_legal_authorisation_is_referenced
        CHECK (kind <> 'medico_legal'
               OR state NOT IN ('authorised', 'performed', 'reported')
               OR authority_reference <> ''),

    performed_by text NOT NULL DEFAULT '',
    performed_at timestamptz,
    CONSTRAINT a_performed_examination_names_who
        CHECK (state NOT IN ('performed', 'reported')
               OR (performed_by <> '' AND performed_at IS NOT NULL)),

    -- A reference rather than the text: a postmortem report is a clinical
    -- document with its own access rules, and copying it here would put it
    -- behind the mortuary's instead.
    report_ref  text NOT NULL DEFAULT '',
    reported_at timestamptz,
    CONSTRAINT a_reported_examination_names_its_report
        CHECK (state <> 'reported'
               OR (report_ref <> '' AND reported_at IS NOT NULL)),

    decline_reason text NOT NULL DEFAULT ''
        CONSTRAINT a_declined_request_says_why
        CHECK (state <> 'declined' OR decline_reason <> ''),

    requested_at timestamptz NOT NULL DEFAULT now(),
    requested_by text NOT NULL
        CONSTRAINT a_request_names_who_made_it CHECK (requested_by <> ''),
    version bigint NOT NULL DEFAULT 1
);

CREATE INDEX postmortem_case_idx
    ON mortuary.postmortem (tenant_id, case_id, requested_at);

CREATE INDEX postmortem_open_idx
    ON mortuary.postmortem (tenant_id, requested_at)
    WHERE state IN ('requested', 'authorised');

-- --------------------------------------------------------------- release

CREATE TABLE mortuary.release (
    release_id uuid PRIMARY KEY,
    tenant_id  uuid NOT NULL,
    case_id    uuid NOT NULL,

    -- Denormalised and held by a composite foreign key. See the note at the
    -- top of this file: this is what makes "a medico-legal case cannot be
    -- released without its authority's clearance" a rule the database keeps
    -- rather than one the application remembers.
    case_medico_legal boolean NOT NULL,
    FOREIGN KEY (case_id, case_medico_legal)
        REFERENCES mortuary.case (case_id, medico_legal)
        ON UPDATE CASCADE,

    recipient_name text NOT NULL
        CONSTRAINT a_release_names_who_took_the_body
        CHECK (recipient_name <> ''),
    recipient_relation text NOT NULL DEFAULT '',
    recipient_id_type  text NOT NULL DEFAULT '',
    recipient_id_ref   text NOT NULL DEFAULT '',
    -- The acceptance asks for verification, and a tick is not one.
    verification_note text NOT NULL
        CONSTRAINT a_release_says_what_was_verified
        CHECK (verification_note <> ''),
    signature_ref text NOT NULL
        CONSTRAINT a_release_records_the_signature
        CHECK (signature_ref <> ''),
    destination text NOT NULL DEFAULT '',

    death_certificate_ref text NOT NULL DEFAULT '',

    authority           text NOT NULL DEFAULT '',
    authority_reference text NOT NULL DEFAULT '',
    -- The rule this table exists to hold.
    CONSTRAINT a_medico_legal_release_names_its_authority
        CHECK (NOT case_medico_legal
               OR (authority <> '' AND authority_reference <> '')),

    released_at timestamptz NOT NULL DEFAULT now(),
    released_by text NOT NULL
        CONSTRAINT a_release_names_who_made_it CHECK (released_by <> ''),
    -- A body leaving on one person's word is the case every mortuary
    -- inquiry turns out to be about.
    witnessed_by text NOT NULL
        CONSTRAINT a_release_is_witnessed CHECK (witnessed_by <> ''),
    CONSTRAINT a_release_witness_is_somebody_else
        CHECK (witnessed_by <> released_by),
    note text NOT NULL DEFAULT '',

    -- A body leaves once. Two releases for one case is two families who were
    -- each told they had taken somebody home.
    UNIQUE (case_id)
);

CREATE INDEX release_recent_idx
    ON mortuary.release (tenant_id, released_at DESC);

-- The clearance a mortuary has taken and not yet used. Its own row rather
-- than a column on the case, because an authority's clearance is a document
-- with a reference and a person who took it, and a boolean is none of those.
CREATE TABLE mortuary.authorisation (
    authorisation_id uuid PRIMARY KEY,
    tenant_id        uuid NOT NULL,
    case_id          uuid NOT NULL
        REFERENCES mortuary.case (case_id) ON DELETE CASCADE,

    authority text NOT NULL
        CONSTRAINT an_authorisation_names_the_authority
        CHECK (authority <> ''),
    reference text NOT NULL
        CONSTRAINT an_authorisation_names_the_reference
        CHECK (reference <> ''),

    recorded_at timestamptz NOT NULL DEFAULT now(),
    recorded_by text NOT NULL
        CONSTRAINT an_authorisation_names_who_took_it
        CHECK (recorded_by <> ''),
    note text NOT NULL DEFAULT ''
);

CREATE INDEX authorisation_case_idx
    ON mortuary.authorisation (tenant_id, case_id, recorded_at DESC);
