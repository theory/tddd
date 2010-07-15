CREATE OR REPLACE FUNCTION get_random_string(
    string_length INT4
) RETURNS TEXT LANGUAGE 'plpgsql' STRICT AS $$
DECLARE
    possible_chars TEXT = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    output TEXT = '';
    pos    INT4;
BEGIN
    FOR i IN 1..string_length LOOP
        pos := 1 + cast( random() * ( length(possible_chars) - 1) as INT4 );
        output := output || substr(possible_chars, pos, 1);
    END LOOP;
    RETURN output;
END;
$$;

CREATE OR REPLACE FUNCTION ins_flyp(
   nick TEXT,
   bod  TEXT
) RETURNS TEXT LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    id_len int := 1;
    flyp_id TEXT;
BEGIN
    LOOP
        BEGIN
            flyp_id := get_random_string(id_len);
            INSERT INTO flyps (id, body, nickname)
            VALUES (flyp_id, bod, nick);
            RETURN flyp_id;
        EXCEPTION WHEN unique_violation THEN
            -- do nothing.
        END;
        id_len := id_len + 1;
        IF id_len >= 30 THEN
            RAISE EXCEPTION 'random string of length == 30 requested. something''s wrong.';
        END IF;
    END LOOP;
END;
$$;

\q


CREATE OR REPLACE FUNCTION del_flyp(
   flyp_id TEXT
) RETURNS BOOLEAN LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM flyps WHERE id = flyp_id;
    RETURN FOUND;
END;
$$;

CREATE OR REPLACE FUNCTION ins_ignore(
    nick        TEXT,
    ignore_nick TEXT
) RETURNS BOOLEAN LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    INSERT INTO ignored (user_nick, ignored_nick)
    VALUES (nick, ignore_nick);
    RETURN true;
EXCEPTION WHEN unique_violation THEN
    RETURN false;
END;
$$;

CREATE OR REPLACE FUNCTION del_ignore(
    nick        TEXT,
    ignore_nick TEXT
) RETURNS BOOLEAN LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM ignored
     WHERE user_nick    = nick
       AND ignored_nick = ignore_nick;
    RETURN FOUND;
END;
$$;

CREATE OR REPLACE FUNCTION get_flyps_for(
    nickname TEXT,
    offset   int,
    limit    int,
) RETURNS SETOF flyps LANGUAGE sql SECURITY DEFINER AS $$
    SELECT *
      FROM flyps
      LEFT JOIN ignored ON flyps.nickname = ignored.ignored_nick
     WHERE ignored.user_nick = $1
       AND ignored.ignored_nick IS NULL
     ORDER BY timestamp DESC
    OFFSET COALESCE($2, 0),
     LIMIT COALESCE($3, 25);
$$;
