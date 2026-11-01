import duckdb
from pathlib import Path

con = duckdb.connect()

# baca file SQL
query_file = Path("sql/00_smoke_test.sql")
sql_text = query_file.read_text()

# file berisi 2 query yang dipisah titik koma,
# jadi dipecah dan dijalankan satu per satu
for query in sql_text.split(";"):
    if query.strip():          # lewati bagian kosong
        con.sql(query).show()