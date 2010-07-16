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

CREATE OR REPLACE FUNCTION del_ignores(
    nick             TEXT,
    VARIADIC ignores TEXT[]
) RETURNS BOOLEAN LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM ignored
     WHERE user_nick    = nick
       AND ignored_nick = ANY(ignores);
    RETURN FOUND;
END;
$$;
