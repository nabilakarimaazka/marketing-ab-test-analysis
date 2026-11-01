CREATE OR REPLACE TABLE ab_test AS
SELECT
    "user id"       AS user_id,
    "test group"    AS test_group,
    converted,
    "total ads"     AS total_ads,
    "most ads day"  AS most_ads_day,
    "most ads hour" AS most_ads_hour
FROM read_csv_auto('data/raw/marketing_AB.csv');