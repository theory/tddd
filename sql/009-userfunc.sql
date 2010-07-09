CREATE OR REPLACE FUNCTION ins_user(
    nickname TEXT,
    password TEXT
) RETURNS VOID LANGUAGE SQL AS $$
    INSERT INTO users values($1, md5($2));
$$;
