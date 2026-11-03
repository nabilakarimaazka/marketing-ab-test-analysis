-- Batas kuantil dihitung dari SEMUA user (kedua grup)
WITH cutoffs AS (
    SELECT quantile_disc(total_ads, [0.2, 0.4, 0.6, 0.8]) AS q
    FROM ab_test
),
binned AS (
    SELECT
        a.*,
        CASE
            WHEN a.total_ads <= c.q[1] THEN 1
            WHEN a.total_ads <= c.q[2] THEN 2
            WHEN a.total_ads <= c.q[3] THEN 3
            WHEN a.total_ads <= c.q[4] THEN 4
            ELSE 5
        END AS ads_bin
    FROM ab_test AS a
    CROSS JOIN cutoffs AS c
)
SELECT
    ads_bin,
    MIN(total_ads)                                          AS min_ads,
    MAX(total_ads)                                          AS max_ads,
    COUNT(*) FILTER (WHERE test_group = 'ad')               AS n_ad,
    COUNT(*) FILTER (WHERE test_group = 'ad' AND converted) AS x_ad,
    COUNT(*) FILTER (WHERE test_group = 'psa')              AS n_psa,
    COUNT(*) FILTER (WHERE test_group = 'psa' AND converted) AS x_psa,
FROM binned
GROUP BY ads_bin
ORDER BY ads_bin;