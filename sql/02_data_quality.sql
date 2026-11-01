-- 1. Check Jumlah Baris vs Jumlah User Unique
SELECT 
    COUNT (*)                   AS n_rows,
    COUNT (DISTINCT user_id)    AS n_unique_users
FROM ab_test;

-- 2. Check User Yang Muncul Lebih Dari Satu Group
SELECT COUNT(*) AS n_users_in_both_groups
FROM (
    SELECT user_id
    FROM ab_test
    GROUP BY user_id
    HAVING COUNT(DISTINCT test_group) > 1
);

-- 3. Check Jumlah nilai kosong per kolom
SELECT
    COUNT(*) - COUNT(user_id)       AS null_user_id,
    COUNT(*) - COUNT(test_group)    AS null_test_group,
    COUNT(*) - COUNT(converted)     AS null_converted,
    COUNT(*) - COUNT(total_ads)     AS null_total_ads,
    COUNT(*) - COUNT(most_ads_day)  AS null_most_ads_day,
    COUNT(*) - COUNT(most_ads_hour) AS null_most_ads_hour
FROM ab_test;

-- 4. Rentang nilai numerik (jam seharusnya 0 sampai 23)
SELECT
    MIN(total_ads)      AS min_total_ads,
    MAX(total_ads)      AS max_total_ads,
    MIN(most_ads_hour)  AS min_hour,
    MAX(most_ads_hour)  AS max_hour
FROM ab_test;

-- 5. Nilai unik hari
SELECT most_ads_day, COUNT(*) AS n_users
FROM ab_test
GROUP BY most_ads_day
ORDER BY n_users DESC;

-- 6. Alokasi group (jumla dan persentase)
SELECT
    test_group,
    COUNT(*) AS n_users,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_users
FROM ab_test
GROUP BY test_group;