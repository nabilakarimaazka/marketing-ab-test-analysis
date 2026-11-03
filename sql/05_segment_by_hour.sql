SELECT
    most_ads_hour,
    COUNT(*) FILTER (WHERE test_group = 'ad')                   AS n_ad,
    COUNT(*) FILTER (WHERE test_group = 'ad' AND converted)     AS x_ad,
    COUNT(*) FILTER (WHERE test_group = 'psa')                  AS n_psa,
    COUNT(*) FILTER (WHERE test_group = 'psa' AND converted)    AS x_psa
FROM ab_test
GROUP BY most_ads_hour
ORDER BY most_ads_hour;