CREATE VIEW flipped AS
SELECT id, nickname, body, timestamp, tsv
  FROM flips
  LEFT JOIN ignored
    ON flips.nickname = ignored.ignored_nick
 WHERE ignored.ignored_nick IS NULL;
