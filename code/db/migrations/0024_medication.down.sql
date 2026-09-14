-- Rollback for 0024. See the forward migration: this discards every live
-- prescription, the therapy ledger they are reconstructed from, and the
-- overrides that record who accepted which risk. The eMAR's administrations
-- survive in the nursing schema and point at orders whose clinical detail is
-- gone. Export first; this is a disaster-recovery action, not a deployment step.
DROP SCHEMA IF EXISTS medication CASCADE;
