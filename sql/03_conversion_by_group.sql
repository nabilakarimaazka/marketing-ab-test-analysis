SELECT
    test_group,
    COUNT(*)                                    AS n_users,
    COUNT(*) FILTER (WHERE converted)           AS n_converted,
    ROUND(100.0 * AVG(converted::INTEGER), 3)   AS conversion_rate_pct
FROM ab_test
GROUP BY test_group
ORDER BY test_group;