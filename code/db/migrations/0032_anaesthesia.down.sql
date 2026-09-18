-- Reverses 0032. See the up migration's rollback note: this destroys every
-- pre-assessment, intraoperative chart, airway record, fluid balance, recovery
-- score and pain plan. An anaesthetic record is read in a complaint and a
-- claim, and a difficult-airway record is what keeps the next anaesthetist
-- safe.
DROP SCHEMA IF EXISTS anaesthesia CASCADE;
