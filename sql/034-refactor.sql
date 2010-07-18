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

CREATE OR REPLACE FUNCTION ins_user(
    nickname TEXT,
    password TEXT
) RETURNS VOID LANGUAGE SQL SECURITY DEFINER AS $$
    INSERT INTO users_ values($1, crypt($2, gen_salt('md5')));
$$;

CREATE OR REPLACE FUNCTION upd_pass(
    nick    TEXT,
    oldpass TEXT,
    newpass TEXT
) RETURNS BOOLEAN LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    UPDATE users_
       SET password = crypt($3, gen_salt('md5'))
     WHERE nickname = $1
       AND password = crypt($2, password);
    RETURN FOUND;
END;
$$;

COMMIT;
