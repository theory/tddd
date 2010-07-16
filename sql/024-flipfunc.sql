CREATE OR REPLACE FUNCTION get_random_string(
    string_length INTEGER
) RETURNS TEXT LANGUAGE 'plpgsql' STRICT AS $$
DECLARE
    chars TEXT = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    ret   TEXT = '';
    pos   INTEGER;
BEGIN
    FOR i IN 1..string_length LOOP
        pos := 1 + ( random() * ( length(chars) - 1) )::INTEGER;
        ret := ret || substr(chars, pos, 1);
    END LOOP;
    RETURN ret;
END;
$$;

CREATE OR REPLACE FUNCTION ins_flip(
   nick TEXT,
   bod  TEXT
) RETURNS TEXT LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    id_len  INT := 1;
    flip_id TEXT;
BEGIN
    LOOP BEGIN
        flip_id := get_random_string(id_len);
        INSERT INTO flips (id, body, nickname, timestamp)
        VALUES (flip_id, bod, nick, clock_timestamp());
        RETURN flip_id;
    EXCEPTION WHEN unique_violation THEN
        id_len := id_len + 1;
        IF id_len >= 30 THEN
            RAISE EXCEPTION '30-character id requested; something is wrong';
        END IF;
    END; END LOOP;
END;
$$;

\q


CREATE OR REPLACE FUNCTION del_flip(
   flip_id TEXT
) RETURNS BOOLEAN LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM flips WHERE id = flip_id;
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

CREATE OR REPLACE FUNCTION get_flips_for(
    nickname TEXT,
    offset   int,
    limit    int,
) RETURNS SETOF flips LANGUAGE sql SECURITY DEFINER AS $$
    SELECT *
      FROM flips
      LEFT JOIN ignored ON flips.nickname = ignored.ignored_nick
     WHERE ignored.user_nick = $1
       AND ignored.ignored_nick IS NULL
     ORDER BY timestamp DESC
    OFFSET COALESCE($2, 0),
     LIMIT COALESCE($3, 25);
$$;
