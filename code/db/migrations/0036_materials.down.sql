-- Rollback for 0036.
--
-- Drops every item, supplier, lot, stock movement, order, receipt, transfer,
-- count, invoice and liability. The movement table is the only record of what
-- the hospital holds — there is no maintained balance to fall back on — so
-- this is a disaster-recovery action, never a deployment step.
DROP SCHEMA IF EXISTS materials CASCADE;
