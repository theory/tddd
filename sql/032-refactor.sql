BEGIN;

 ALTER TABLE users
RENAME timestamp TO created_at;

ALTER TABLE users
  ADD birth_date DATE;

COMMIT;
