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
     ORDER BY timestamp DESC
    OFFSET COALESCE($2, 0)
     LIMIT COALESCE($3, 25);
$$;

\q

CREATE OR REPLACE FUNCTION search_flips(
    nickname TEXT,
    query    TEXT,
    offset   INT,
    limit    INT
) RETURNS SETOF flips LANGUAGE sql SECURITY DEFINER AS $$
    SELECT flips.*
      FROM flips
      LEFT JOIN ignored ON flips.nickname = ignored.ignored_nick
     WHERE ignored.user_nick = $1
       AND ignored.ignored_nick IS NULL
       AND tsv @@ plainto_tsquery('pg_catalog.english', $2)
     ORDER BY ts_rank(tsv, plainto_tsquery($2))
    OFFSET COALESCE($3, 0),
     LIMIT COALESCE($4, 25);
$$;

CREATE OR REPLACE FUNCTION search_flips(
    query    TEXT,
    offset   INT,
    limit    INT
) RETURNS SETOF flips LANGUAGE sql SECURITY DEFINER AS $$
    SELECT *
      FROM flips
     WHERE tsv @@ plainto_tsquery('pg_catalog.english', $1)
     ORDER BY ts_rank(tsv, plainto_tsquery($1))
    OFFSET COALESCE($2, 0),
     LIMIT COALESCE($3, 25);
$$;
