-- Reverses 0031. See the up migration's rollback note: this destroys every
-- case, checklist, safety check, operative note, implant record, specimen and
-- tray link the theatre has recorded. The operative note and the implant
-- register are both records a hospital is required to keep for years.
DROP SCHEMA IF EXISTS theatre CASCADE;
