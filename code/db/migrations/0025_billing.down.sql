-- Rollback for 0025. See the forward migration: this discards every invoice,
-- receipt and ledger entry, and a hospital's books are not reconstructable from
-- the clinical record. Export first, with the finance department in the room;
-- this is a disaster-recovery action, not a deployment step.
DROP SCHEMA IF EXISTS billing CASCADE;
