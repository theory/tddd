CREATE OR REPLACE FUNCTION get_flips_for(
    nickname TEXT,
    offsett  INT,
    limitt   INT
) RETURNS SETOF flips LANGUAGE sql STABLE SECURITY DEFINER AS $$
    SELECT *
      FROM flips
     ORDER BY timestamp DESC;
$$;
