-- Blood bank and transfusion medicine (SRS-BLD-001 … 017).

-- name: InsertDonor :exec
INSERT INTO bloodbank.donor (
    donor_id, tenant_id, donor_number, patient_id, display_name, birth_date,
    contact_phone, abo, rhd, registered_at, registered_by
) VALUES (
    @donor_id, @tenant_id, @donor_number, @patient_id, @display_name,
    @birth_date, @contact_phone, @abo, @rhd, @registered_at, @registered_by
);

-- name: GetDonor :one
SELECT * FROM bloodbank.donor WHERE tenant_id = $1 AND donor_id = $2;

-- name: GetDonorByNumber :one
SELECT * FROM bloodbank.donor WHERE tenant_id = $1 AND donor_number = $2;

-- name: UpdateDonorDeferral :execrows
UPDATE bloodbank.donor
SET deferral = @deferral, deferral_code = @deferral_code,
    deferral_note = @deferral_note, deferred_at = @deferred_at,
    deferred_by = @deferred_by, deferred_until = @deferred_until,
    abo = @abo, rhd = @rhd,
    version = version + 1
WHERE tenant_id = @tenant_id AND donor_id = @donor_id
  AND version = @expected_version;

-- The deferred list a screening desk reads. A permanent deferral has no end
-- date and is always current; a temporary one is current until its date.
-- name: ListDeferredDonors :many
SELECT * FROM bloodbank.donor
WHERE tenant_id = @tenant_id
  AND deferral IS NOT NULL
  AND (deferred_until IS NULL OR deferred_until > @as_of)
ORDER BY deferred_at DESC
LIMIT @row_limit;

-- name: InsertScreening :exec
INSERT INTO bloodbank.screening (
    screening_id, tenant_id, donor_id, answers, measurements, consented,
    consent_note, accepted, deferral, deferral_code, screened_at, screened_by
) VALUES (
    @screening_id, @tenant_id, @donor_id, @answers, @measurements, @consented,
    @consent_note, @accepted, @deferral, @deferral_code, @screened_at,
    @screened_by
);

-- name: GetScreening :one
SELECT * FROM bloodbank.screening
WHERE tenant_id = $1 AND screening_id = $2;

-- name: ListDonorScreenings :many
SELECT * FROM bloodbank.screening
WHERE tenant_id = @tenant_id AND donor_id = @donor_id
ORDER BY screened_at DESC
LIMIT @row_limit;

-- name: InsertCollection :exec
INSERT INTO bloodbank.collection (
    collection_id, tenant_id, donor_id, screening_id, donation_number, kind,
    volume_ml, abo, rhd, collected_at, collected_by, adverse_event, adverse_note
) VALUES (
    @collection_id, @tenant_id, @donor_id, @screening_id, @donation_number,
    @kind, @volume_ml, @abo, @rhd, @collected_at, @collected_by,
    @adverse_event, @adverse_note
);

-- name: GetCollection :one
SELECT * FROM bloodbank.collection
WHERE tenant_id = $1 AND collection_id = $2;

-- name: InsertTestResult :exec
INSERT INTO bloodbank.test_result (
    test_id, tenant_id, collection_id, code, display, reactive, value, method,
    tested_at, tested_by
) VALUES (
    @test_id, @tenant_id, @collection_id, @code, @display, @reactive, @value,
    @method, @tested_at, @tested_by
);

-- name: ListTestResults :many
SELECT * FROM bloodbank.test_result
WHERE tenant_id = @tenant_id AND collection_id = @collection_id
ORDER BY tested_at;

-- name: InsertComponent :exec
INSERT INTO bloodbank.component (
    component_id, tenant_id, unit_number, collection_id, donor_id, source,
    component_class, abo, rhd, status, volume_ml, attributes, location,
    collected_at, expires_at, created_at, created_by
) VALUES (
    @component_id, @tenant_id, @unit_number, @collection_id, @donor_id, @source,
    @component_class, @abo, @rhd, @status, @volume_ml, @attributes, @location,
    @collected_at, @expires_at, @created_at, @created_by
);

-- name: GetComponent :one
SELECT * FROM bloodbank.component
WHERE tenant_id = $1 AND component_id = $2;

-- name: GetComponentByNumber :one
SELECT * FROM bloodbank.component
WHERE tenant_id = $1 AND unit_number = $2;

-- name: UpdateComponentStatus :execrows
UPDATE bloodbank.component
SET status = @status, discard_reason = @discard_reason,
    location = @location, version = version + 1
WHERE tenant_id = @tenant_id AND component_id = @component_id
  AND version = @expected_version;

-- name: ListComponentsForCollection :many
SELECT * FROM bloodbank.component
WHERE tenant_id = @tenant_id AND collection_id = @collection_id
ORDER BY created_at;

-- The allocation search. Soonest to expire first, so the bank issues the unit
-- that would otherwise be wasted. Compatibility is the domain's to decide, so
-- this narrows by component and status and hands back candidates.
-- name: ListAllocatableComponents :many
SELECT * FROM bloodbank.component
WHERE tenant_id = @tenant_id
  AND component_class = @component_class
  AND status = 'available'
  AND expires_at > @as_of
ORDER BY expires_at
LIMIT @row_limit;

-- The whole inventory for the stock report, including the states that are not
-- allocatable: a bank short because everything is reserved has a different
-- problem from one short because nothing has been tested.
-- name: ListInventory :many
SELECT * FROM bloodbank.component
WHERE tenant_id = @tenant_id
  AND status IN ('quarantined', 'available', 'reserved')
ORDER BY component_class, abo, rhd, expires_at
LIMIT @row_limit;

-- name: CountDiscarded :one
SELECT count(*) FROM bloodbank.component
WHERE tenant_id = @tenant_id
  AND status = 'discarded'
  AND created_at >= @period_start AND created_at < @period_end;

-- name: InsertRequest :exec
INSERT INTO bloodbank.request (
    request_id, tenant_id, patient_id, encounter_id, facility_id,
    component_class, quantity, indication, urgency, requirements, required_by,
    status, requested_by, requested_at
) VALUES (
    @request_id, @tenant_id, @patient_id, @encounter_id, @facility_id,
    @component_class, @quantity, @indication, @urgency, @requirements,
    @required_by, @status, @requested_by, @requested_at
);

-- name: GetRequest :one
SELECT * FROM bloodbank.request WHERE tenant_id = $1 AND request_id = $2;

-- name: UpdateRequestStatus :execrows
UPDATE bloodbank.request
SET status = @status, version = version + 1
WHERE tenant_id = @tenant_id AND request_id = @request_id
  AND version = @expected_version;

-- name: ListPatientRequests :many
SELECT * FROM bloodbank.request
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
ORDER BY requested_at DESC
LIMIT @row_limit;

-- The blood bank's worklist. Emergency before urgent before routine, then
-- soonest needed; a request with no required-by time sorts last rather than
-- hiding.
-- name: ListOpenRequests :many
SELECT * FROM bloodbank.request
WHERE tenant_id = @tenant_id
  AND status = 'open'
  AND (@facility_id::text = '' OR facility_id = @facility_id)
ORDER BY CASE urgency
             WHEN 'emergency' THEN 0
             WHEN 'urgent' THEN 1
             ELSE 2
         END,
         required_by NULLS LAST,
         requested_at
LIMIT @row_limit;

-- name: InsertPatientSample :exec
INSERT INTO bloodbank.patient_sample (
    sample_id, tenant_id, patient_id, sample_number, abo, rhd,
    antibody_screen_positive, antibody_note, second_check,
    collected_at, collected_by, expires_at, tested_at, tested_by
) VALUES (
    @sample_id, @tenant_id, @patient_id, @sample_number, @abo, @rhd,
    @antibody_screen_positive, @antibody_note, @second_check,
    @collected_at, @collected_by, @expires_at, @tested_at, @tested_by
);

-- name: GetPatientSample :one
SELECT * FROM bloodbank.patient_sample
WHERE tenant_id = $1 AND sample_id = $2;

-- The sample a crossmatch runs against: the patient's latest that has not
-- expired. Latest rather than any, because a corrected group is on the newest
-- tube.
-- name: GetCurrentPatientSample :one
SELECT * FROM bloodbank.patient_sample
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
  AND expires_at > @as_of
ORDER BY collected_at DESC
LIMIT 1;

-- name: InsertReservation :exec
INSERT INTO bloodbank.reservation (
    reservation_id, tenant_id, component_id, request_id, patient_id, sample_id,
    crossmatched, crossmatch_note, status, expires_at, reserved_at, reserved_by
) VALUES (
    @reservation_id, @tenant_id, @component_id, @request_id, @patient_id,
    @sample_id, @crossmatched, @crossmatch_note, @status, @expires_at,
    @reserved_at, @reserved_by
);

-- name: GetReservation :one
SELECT * FROM bloodbank.reservation
WHERE tenant_id = $1 AND reservation_id = $2;

-- name: UpdateReservationStatus :execrows
UPDATE bloodbank.reservation
SET status = @status, released_reason = @released_reason
WHERE tenant_id = @tenant_id AND reservation_id = @reservation_id
  AND status = 'held';

-- name: ListReservationsForComponent :many
SELECT * FROM bloodbank.reservation
WHERE tenant_id = @tenant_id AND component_id = @component_id
ORDER BY reserved_at;

-- name: ListPatientReservations :many
SELECT * FROM bloodbank.reservation
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
ORDER BY reserved_at DESC
LIMIT @row_limit;

-- Reservations past their window, for the sweep that returns held blood to the
-- shelf. Blood held for a patient who did not need it is blood the next
-- patient could not have.
-- name: ListLapsedReservations :many
SELECT * FROM bloodbank.reservation
WHERE tenant_id = @tenant_id AND status = 'held' AND expires_at <= @as_of
ORDER BY expires_at
LIMIT @row_limit;

-- name: CountReservationsInPeriod :one
SELECT count(*) FROM bloodbank.reservation
WHERE tenant_id = @tenant_id
  AND reserved_at >= @period_start AND reserved_at < @period_end;

-- name: InsertIssue :exec
INSERT INTO bloodbank.issue (
    issue_id, tenant_id, component_id, reservation_id, patient_id, request_id,
    destination, emergency, emergency_authoriser, emergency_reason,
    issued_at, issued_by, issued_to, checked_by
) VALUES (
    @issue_id, @tenant_id, @component_id, @reservation_id, @patient_id,
    @request_id, @destination, @emergency, @emergency_authoriser,
    @emergency_reason, @issued_at, @issued_by, @issued_to, @checked_by
);

-- name: GetIssue :one
SELECT * FROM bloodbank.issue WHERE tenant_id = $1 AND issue_id = $2;

-- name: GetIssueForComponent :one
SELECT * FROM bloodbank.issue
WHERE tenant_id = @tenant_id AND component_id = @component_id
ORDER BY issued_at DESC
LIMIT 1;

-- name: ReconcileIssue :execrows
UPDATE bloodbank.issue
SET reconciled = true, reconciled_at = @reconciled_at,
    reconciled_by = @reconciled_by, reconcile_note = @reconcile_note
WHERE tenant_id = @tenant_id AND issue_id = @issue_id
  AND emergency AND NOT reconciled;

-- The outstanding reconciliation list: SRS-BLD-016's "later reconciled" is
-- read against this.
-- name: ListUnreconciledIssues :many
SELECT * FROM bloodbank.issue
WHERE tenant_id = @tenant_id AND emergency AND NOT reconciled
ORDER BY issued_at
LIMIT @row_limit;

-- name: ListIssuesForComponent :many
SELECT * FROM bloodbank.issue
WHERE tenant_id = @tenant_id AND component_id = @component_id
ORDER BY issued_at;

-- name: ListIssuesInPeriod :many
SELECT * FROM bloodbank.issue
WHERE tenant_id = @tenant_id
  AND issued_at >= @period_start AND issued_at < @period_end
ORDER BY issued_at
LIMIT @row_limit;

-- name: InsertTransfusionEpisode :exec
INSERT INTO bloodbank.episode (
    episode_id, tenant_id, component_id, issue_id, patient_id, encounter_id,
    status, started_at, started_by, volume_given_ml, checked_by, checked_with
) VALUES (
    @episode_id, @tenant_id, @component_id, @issue_id, @patient_id,
    @encounter_id, @status, @started_at, @started_by, @volume_given_ml,
    @checked_by, @checked_with
);

-- name: GetTransfusionEpisode :one
SELECT * FROM bloodbank.episode WHERE tenant_id = $1 AND episode_id = $2;

-- name: UpdateTransfusionEpisode :execrows
UPDATE bloodbank.episode
SET status = @status, ended_at = @ended_at,
    volume_given_ml = @volume_given_ml, stop_reason = @stop_reason
WHERE tenant_id = @tenant_id AND episode_id = @episode_id;

-- name: ListEpisodesForComponent :many
SELECT * FROM bloodbank.episode
WHERE tenant_id = @tenant_id AND component_id = @component_id
ORDER BY started_at;

-- The patient's transfusion history, which is what "longitudinally visible"
-- means: every episode, across admissions, most recent first.
-- name: ListPatientEpisodes :many
SELECT * FROM bloodbank.episode
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
ORDER BY started_at DESC
LIMIT @row_limit;

-- name: ListEpisodesInPeriod :many
SELECT * FROM bloodbank.episode
WHERE tenant_id = @tenant_id
  AND started_at >= @period_start AND started_at < @period_end
ORDER BY started_at
LIMIT @row_limit;

-- name: InsertBloodBankObservation :exec
INSERT INTO bloodbank.observation (
    observation_id, tenant_id, episode_id, timing, values, note,
    observed_at, observed_by
) VALUES (
    @observation_id, @tenant_id, @episode_id, @timing, @values, @note,
    @observed_at, @observed_by
);

-- name: ListBloodBankObservations :many
SELECT * FROM bloodbank.observation
WHERE tenant_id = @tenant_id AND episode_id = @episode_id
ORDER BY observed_at;

-- name: InsertReaction :exec
INSERT INTO bloodbank.reaction (
    reaction_id, tenant_id, episode_id, component_id, patient_id, severity,
    features, note, reported_at, reported_by, state
) VALUES (
    @reaction_id, @tenant_id, @episode_id, @component_id, @patient_id,
    @severity, @features, @note, @reported_at, @reported_by, @state
);

-- name: GetReaction :one
SELECT * FROM bloodbank.reaction WHERE tenant_id = $1 AND reaction_id = $2;

-- name: ConcludeReaction :execrows
UPDATE bloodbank.reaction
SET state = 'concluded', classification = @classification,
    conclusion = @conclusion, concluded_at = @concluded_at,
    concluded_by = @concluded_by, unit_returned = @unit_returned
WHERE tenant_id = @tenant_id AND reaction_id = @reaction_id
  AND state = 'open';

-- name: ListReactionsForComponent :many
SELECT * FROM bloodbank.reaction
WHERE tenant_id = @tenant_id AND component_id = @component_id
ORDER BY reported_at;

-- name: ListOpenReactions :many
SELECT * FROM bloodbank.reaction
WHERE tenant_id = @tenant_id AND state = 'open'
ORDER BY reported_at
LIMIT @row_limit;

-- name: ListReactionsInPeriod :many
SELECT * FROM bloodbank.reaction
WHERE tenant_id = @tenant_id
  AND reported_at >= @period_start AND reported_at < @period_end
ORDER BY reported_at
LIMIT @row_limit;

-- The direction a look-back runs: from one component to every sibling made
-- from the same donation. A reactive test result arriving late, or a reaction,
-- means every other component from that collection has to be found.
-- name: ListSiblingComponents :many
SELECT sibling.* FROM bloodbank.component sibling
JOIN bloodbank.component origin
  ON origin.collection_id = sibling.collection_id
 AND origin.tenant_id = sibling.tenant_id
WHERE sibling.tenant_id = @tenant_id
  AND origin.component_id = @component_id
  AND sibling.component_id <> @component_id
ORDER BY sibling.created_at;

-- The other direction a look-back runs: from a donor to every patient who
-- received their blood. Deliberately thin — identifiers and times, no
-- clinical detail — because a look-back list is read outside the care team.
-- name: ListDonorRecipients :many
SELECT e.patient_id, e.episode_id, e.started_at,
       c.component_id, c.unit_number
FROM bloodbank.episode e
JOIN bloodbank.component c
  ON c.component_id = e.component_id AND c.tenant_id = e.tenant_id
JOIN bloodbank.collection col
  ON col.collection_id = c.collection_id AND col.tenant_id = c.tenant_id
WHERE e.tenant_id = @tenant_id AND col.donor_id = @donor_id
ORDER BY e.started_at DESC
LIMIT @row_limit;

-- name: UpsertStockThreshold :exec
INSERT INTO bloodbank.stock_threshold (
    threshold_id, tenant_id, facility_id, component_class, abo, rhd,
    minimum, set_by, set_at
) VALUES (
    @threshold_id, @tenant_id, @facility_id, @component_class, @abo, @rhd,
    @minimum, @set_by, @set_at
)
ON CONFLICT (tenant_id, facility_id, component_class, abo, rhd) DO UPDATE
SET minimum = EXCLUDED.minimum,
    set_by = EXCLUDED.set_by,
    set_at = EXCLUDED.set_at;

-- name: ListStockThresholds :many
SELECT * FROM bloodbank.stock_threshold
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id)
ORDER BY component_class, abo, rhd;
