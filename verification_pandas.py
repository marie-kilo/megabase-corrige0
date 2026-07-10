import os

import pandas as pd
import psycopg2

DB_URL =(
        "dbname=megabase0 "
        "user=postgres "
        "password=Mkilo1990 "
        "host=localhost "
        "port=5432"
 
)
conn = psycopg2.connect(os.environ.get("DATABASE_URL", DB_URL ))
#conn = psycopg2.connect(os.environ.get("DATABASE_URL", "dbname=megabase0" ))


# sql (directement)
mart_sql = pd.read_sql(
    """
    SELECT d.departement, f.type, sum(f.nb) AS n
    FROM entrepot.fait_etablissement f
    JOIN entrepot.dim_commune d ON d.insee_code = f.insee_code
    GROUP BY d.departement, f.type
    """,
    conn,
)

# pandas
fait = pd.read_sql("SELECT insee_code, type, nb FROM entrepot.fait_etablissement", conn)
dim = pd.read_sql("SELECT insee_code, departement FROM entrepot.dim_commune", conn)
conn.close()

mart_pandas = (
    fait.merge(dim, on="insee_code")
    .groupby(["departement", "type"], as_index=False)["nb"]
    .sum()
    .rename(columns={"nb": "n"})
)

# comparaison stricte
a = mart_sql.sort_values(["departement", "type"]).reset_index(drop=True)
b = mart_pandas.sort_values(["departement", "type"]).reset_index(drop=True)
pd.testing.assert_frame_equal(a, b, check_dtype=False)
print("Vérification réussie : SQL == pandas")

