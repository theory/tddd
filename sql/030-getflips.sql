CREATE OR REPLACE FUNCTION get_flips_for(
    nickname TEXT,
    offsett  INT,
    limitt   INT
) RETURNS SETOF flips LANGUAGE sql STABLE SECURITY DEFINER AS $$
    SELECT flips.*
      FROM flips
      LEFT JOIN ignored
        ON flips.nickname    = ignored.ignored_nick
       AND ignored.user_nick = $1
     WHERE ignored.ignored_nick IS NULL
     ORDER BY timestamp DESC;
$$;
