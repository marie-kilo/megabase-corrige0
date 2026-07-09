import os
import time

import psycopg2

def chrono(label, sql):
    """Exécute la requête et affiche son temps et son plan d'exécution

    ⚠️ Une première exécution non mesurée cache (au sens du caching!) les pages :
    il faut donc éviter que la toute première requête paie seule la lecture disque et fausse la comparaison.
    """
    debut = time.perf_counter()
    cur.execute(sql)
    cur.fetchall()
    ms = (time.perf_counter() - debut) * 1000
    print(f"  {label:24s} {ms:8.2f} ms")


DB_URL = (
    "dbname=megabase0 "
    "user=postgres "
    "password=Mkilo1990 "
    "host=localhost "
    "port=5432"
)

Q1 = "SELECT sum(nb) FROM demo_index.fait_etablissement WHERE type = '22'"

conn = psycopg2.connect(os.environ.get("DATABASE_URL", DB_URL))
conn.autocommit = True
cur = conn.cursor()

#réinitialisation du schéma demo_index
cur.execute("DROP SCHEMA IF EXISTS demo_index CASCADE")
cur.execute("CREATE SCHEMA demo_index")


cur.execute("""
    CREATE TABLE demo_index.fait_etablissement AS
    SELECT lpad(c::text, 5, '0') AS insee_code,
           a::text AS type,
           (random() * 1000)::int AS nb
    FROM generate_series(1, 36000) c,
         generate_series(1,55) a
""")

chrono("Q1 sans  index", Q1)

cur.execute("""
    CREATE INDEX idx_fait_etablissement_type
    ON demo_index.fait_etablissement (type)
""")

chrono("Q1 avec index", Q1)