import subprocess
import psycopg2
import time


# CONFIGURATION DE LA BASE
# ---------------------------------------------------------
DB_NAME = "megabase0"
DB_USER = "postgres"
DB_PASSWORD = "Mkilo1990"   
DB_HOST = "localhost"
DB_PORT = 5432


# LISTE DES TABLES À VÉRIFIER
# ---------------------------------------------------------
TABLES = [
    "region",
    "departement",
    "commune",
    "lycee",
    "college",
    "pharmacie",
    "gare",
    "ehpad",
    "bibliotheque",
    "mairie",
    "entreprise_btp",
    "festivals"   
]


# FONCTION : récupérer les COUNT(*) de toutes les tables
# ---------------------------------------------------------
def get_counts():
    conn = psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        host=DB_HOST,
        port=DB_PORT
    )
    cur = conn.cursor()

    counts = {}
    for table in TABLES:
        cur.execute(f"SELECT COUNT(*) FROM {table};")
        counts[table] = cur.fetchone()[0]

    conn.close()
    return counts


# FONCTION : lancer le pipeline corrige0 (main.py)
# ---------------------------------------------------------
def run_pipeline():
    print("→ Lancement du pipeline…")
    subprocess.run(["python", "main.py"], check=True)
    print("→ Pipeline terminé.\n")


# FONCTION : comparer les volumétries
# ---------------------------------------------------------
def compare_counts(c1, c2):
    print("Comparaison des volumétries :\n")
    ok = True

    for table in TABLES:
        v1 = c1[table]
        v2 = c2[table]

        if v1 == v2:
            print(f"✔ {table} : identique ({v1})")
        else:
            print(f"❌ {table} : différent ({v1} → {v2})")
            ok = False

    print("\nRésultat final :")
    if ok:
        print("🎉 OK : Le chargement est rejouable, toutes les volumétries sont identiques.")
    else:
        print("⚠️ ERREUR : Le chargement n'est pas idempotent, des différences existent.")



# PROGRAMME PRINCIPAL
# ---------------------------------------------------------
print("\n==============================")
print("   Vérification de rejouabilité")
print("==============================\n")

print("1️⃣ Première exécution du pipeline")
run_pipeline()
counts1 = get_counts()

print("2️⃣ Deuxième exécution du pipeline")
run_pipeline()
counts2 = get_counts()

print("3️⃣ Comparaison")
compare_counts(counts1, counts2)
