 BEGIN;

 ALTER TABLE users
RENAME timestamp TO created_at;

ALTER TABLE users
  ADD birth_date DATE;

UPDATE users
   SET birth_date = created_at,
       created_at = '2010-07-19 15:30:00+00'
 WHERE created_at < '2010-07-19 15:30:00+00';

COMMIT;
