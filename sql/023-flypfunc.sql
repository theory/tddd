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

CREATE OR REPLACE FUNCTION ins_flyp(
   nick TEXT,
   bod  TEXT
) RETURNS TEXT LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    id_len  INT := 1;
    flyp_id TEXT;
BEGIN
    LOOP BEGIN
        flyp_id := get_random_string(id_len);
        INSERT INTO flyps (id, body, nickname)
        VALUES (flyp_id, bod, nick);
        RETURN flyp_id;
    EXCEPTION WHEN unique_violation THEN
        id_len := id_len + 1;
        IF id_len >= 30 THEN
            RAISE EXCEPTION '30-character id requested; something is wrong';
        END IF;
    END; END LOOP;
END;
$$;
