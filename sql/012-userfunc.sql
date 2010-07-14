CREATE OR REPLACE FUNCTION ins_user(
    nickname TEXT,
    password TEXT
) RETURNS VOID LANGUAGE SQL AS $$
    INSERT INTO users values($1, crypt($2, gen_salt('md5')));
$$;

CREATE OR REPLACE FUNCTION upd_pass(
    nick    TEXT,
    oldpass TEXT,
    newpass TEXT
) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
    UPDATE users
       SET password = crypt($3, gen_salt('md5'))
     WHERE nickname = $1
       AND password = crypt($2, password);
    RETURN FOUND;
END;
$$;
