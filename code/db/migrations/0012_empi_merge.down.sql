-- Reverses 0012.
--
-- Dropping merge_journal makes every existing merge permanent: the record of
-- which identifier moved from whom, and what the losing record's status was
-- before, exists nowhere else. For a failed deploy against an empty database
-- only; anywhere with data, restore.

DROP TABLE IF EXISTS empi.duplicate_candidate;
DROP TABLE IF EXISTS empi.merge_journal;
