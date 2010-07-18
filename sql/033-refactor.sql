BEGIN;

 ALTER TABLE users
RENAME timestamp TO created_at;

ALTER TABLE users
  ADD birth_date DATE;

 ALTER TABLE users
RENAME TO users_;

CREATE VIEW users AS
SELECT *, COALESCE(birth_date::timestamptz, created_at) AS timestamp
  FROM users_;

COMMIT;
