-- Rollback for 0035.
--
-- Drops every recorded instrument move. The current status on
-- sterile.instrument survives, so the department keeps working — but the
-- replacement and loss analysis SRS-CSSD-012 exists for goes with the table.
-- A disaster-recovery action, never a deployment step.
DROP TABLE IF EXISTS sterile.instrument_event;
