SELECT
    most_ads_day,
    COUNT(*) FILTER (WHERE test_group = 'ad')                   AS n_ad,
    COUNT(*) FILTER (WHERE test_group = 'ad' AND converted)     AS x_ad,
    COUNT(*) FILTER (WHERE test_group = 'psa')                  AS n_psa,
    COUNT(*) FILTER (WHERE test_group = 'psa' AND converted)    AS x_psa
FROM ab_test
GROUP BY most_ads_day
ORDER BY list_position(
    ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
    most_ads_day
);