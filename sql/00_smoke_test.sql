-- Cek skema kolom
DESCRIBE SELECT * FROM read_csv_auto('data/raw/marketing_AB.csv');

-- Cek jumlah baris
SELECT COUNT(*) AS n_rows
FROM read_csv_auto('data/raw/marketing_AB.csv')