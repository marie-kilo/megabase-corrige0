"""Build the megabase:
- on boucle sur les sources
    - on "pagine" sur chaque (i.e. on boucle sur les pages=chunks)
        - on recupère les chunks un par un
        - on nettoie chunk par chunk
        - on charge chunk par chunk
createdb megabase0
python3 main.py

- collect / clean / load logic : 3 fichiers
- ici, on agence juste la logique : i.e l'orchestration chunk par chunk
"""

import sys

import requests

import collect
import clean
import load

#def normalize_dept(d):pour la france métropolitaine, on peut se contenter de .upper().zfill(2) pour avoir "01"..."95" et "2A"/"2B".
#Pour les DOM, il faut un peu plus de logique (971...976, 977, 978, 984, 986, 987, 988). 
#On peut aussi lever une exception si le département est invalide.

def normalize_dept(d):
    d = d.upper()
    # Métropole 01–95
    if d.isdigit() and len(d) <= 2:
        return d.zfill(2)
    # DOM 971–976
    if d.isdigit() and len(d) == 3:
        return d
    # Corse 2A / 2B
    if d in ("2A", "2B"):
        return d
    # COM 977, 978, 984, 986, 987, 988
    if d in ("977", "978", "984", "986", "987", "988"):
        return d
    raise ValueError(f"Département invalide : {d}")

DEPT = normalize_dept(sys.argv[1] if len(sys.argv) > 1 else "69")


# Le département est passé en argument : python main.py 38  (défaut 69).
# .upper().zfill(2) couvre tous les cas : "1" -> "01", "69" -> "69",
# la Corse "2A"/"2B" et l'outre-mer "971"... restent tels quels.
#DEPT = (sys.argv[1] if len(sys.argv) > 1 else "69").upper().zfill(2)

EDUCATION = "https://data.education.gouv.fr/api/explore/v2.1/catalog/datasets"
FINESS = "https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets"
CULTURE = "https://data.culture.gouv.fr/api/explore/v2.1/catalog/datasets"
FESTIVALS = "https://data.culture.gouv.fr/api/explore/v2.1/catalog/datasets/festivals-global-festivals-_-pl/records"

SOURCES = [
        {
        "table": "lycee",
        "key": "uai",
        "url": f"{EDUCATION}/fr-en-annuaire-education/records",
        "where": f'code_departement="{DEPT.zfill(3)}" and type_etablissement="Lycée"',
        "select": "identifiant_de_l_etablissement,nom_etablissement,statut_public_prive,libelle_nature,adresse_1,code_postal,nom_commune,telephone,mail,latitude,longitude,code_commune",
        "order_by": "identifiant_de_l_etablissement",
        "clean": clean.clean_education,
    },
    {
        "table": "college",
        "key": "uai",
        "url": f"{EDUCATION}/fr-en-annuaire-education/records",
        "where": f'code_departement="{DEPT.zfill(3)}" and type_etablissement="Collège"',
        "select": "identifiant_de_l_etablissement,nom_etablissement,statut_public_prive,libelle_nature,adresse_1,code_postal,nom_commune,telephone,mail,latitude,longitude,code_commune",
        "order_by": "identifiant_de_l_etablissement",
        "clean": clean.clean_education,
    },
    {
        "table": "pharmacie",
        "key": "finess",
        "url": f"{FINESS}/healthref-france-finess/records",
        # FINESS a un dep_code non standard pour les DOM (Guadeloupe = "9A").
        # On filtre donc sur le préfixe du code commune (le vrai code INSEE), ce qui
        # marche uniformément pour la métropole, la Corse et l'outre-mer.
        "where": f'startswith(com_code, "{DEPT}") and libcategetab like "Pharmacie"',
        "select": "nofinesset,rs,libcategetab,numvoie,typvoie,voie,ligneacheminement,com_name,telephone,siret,coord,com_code",
        "order_by": "nofinesset",
        "clean": clean.clean_finess,
    },
    {
        # EHPAD : même dataset FINESS que les pharmacies, autre catégorie. clean_finess réutilisé.
        "table": "ehpad",
        "key": "finess",
        "url": f"{FINESS}/healthref-france-finess/records",
        "where": f'startswith(com_code, "{DEPT}") and libcategetab like "hébergement pour personnes âgées dépendantes"',
        "select": "nofinesset,rs,libcategetab,numvoie,typvoie,voie,ligneacheminement,com_name,telephone,siret,coord,com_code",
        "order_by": "nofinesset",
        "clean": clean.clean_finess,
    },
    {
        # Bibliothèques : dataset Opendatasoft de data.culture, avec code_insee_commune.
        "table": "bibliotheque",
        "key": "code_bib",
        "url": f"{CULTURE}/adresses-des-bibliotheques-publiques/records",
        "where": f'startswith(code_insee_commune, "{DEPT}")',
        "select": "code_bib,nom_de_l_etablissement,statut,adresse,cp,ville,code_insee_commune,population_commune,telephone,nombre_d_emprunteurs,nombre_de_prets,latitude,longitude",
        "order_by": "code_bib",
        "clean": clean.clean_culture,
    },

    {
        # Festivals : dataset Opendatasoft de data.culture, avec code_insee_commune.
        "table": "festivals",
        "key": "identifiant",
        "url": f"{FESTIVALS}",
        "where": f'startswith(code_insee_commune, "{DEPT}")',
        "select": "identifiant, nom_du_festival,region_principale_de_deroulement,departement_principal_de_deroulement,commune_principale_de_deroulement,code_postal_de_la_commune_principale_de_deroulement,code_insee_commune,adresse_postale,site_internet_du_festival,discipline_dominante,annee_de_creation_du_festival,periode_principale_de_deroulement_du_festival,geocodage_xy",
        "order_by": "identifiant",
        "clean": clean.clean_festivals,
    }
]

conn = load.connect()
cur = conn.cursor()
load.create_schema(cur)

print(f"=== département {DEPT} ===")

# Géographie en 1 call : région, département, communes. On garde les codes connus.
# Si l'API tombe ici, on s'arrête proprement : sans communes, on ne peut rien relier.
try:
    raw_communes = collect.fetch_communes(DEPT)
except requests.RequestException as e:
    print(f"  géographie indisponible ({type(e).__name__}), relance le département {DEPT}")
    raise SystemExit
known_communes = load.insert_geography(cur, raw_communes)
load.insert_mairies(cur, raw_communes)  # une mairie par commune, dérivée du référentiel
conn.commit()
print(f"commune  : {len(known_communes)}")
print(f"mairie   : {len(known_communes)}")

# Loop of loops: loop sur les sources, puis loop sur les pages
for source in SOURCES:
    # reprise par département : on repart de là où un run précédent s'est arrêté,
    # en comptant les lignes de CE département déjà présentes dans la table
    offset = load.count_rows(cur, source["table"], DEPT)
    seen = set()  # keys déjà vues (deduplication)
    while True:
        try:
            rows = collect.fetch_page(
                source["url"],
                source["where"],
                source["select"],
                source["order_by"],
                offset,
            )
        except requests.RequestException as e:
            
            # l'API bloque (429), timeout ou est en panne : on s'arrête proprement
            # pour cette source. Ce qui est chargé est gardé (commit par page), on
            # relancera le département pour reprendre.
            print(f"  {source['table']:9}: API indisponible ({type(e).__name__}), "
                  f"relance le département {DEPT} pour reprendre")
            break
        if not rows:
            break  # plus de pages

        # on nettoie le chunk, on garde les rows avec une key, une commune connue, pas encore vues
        print(f"  {source['table']:9}: page {offset//100 + 1} ({len(rows)} lignes)")
        chunk = []
        for row in rows:
            # Option 1 : un if/elif sur source["table"] pour choisir la fonction
            # Option 2 (retenue) : la fonction de nettoyage est portée par la source
            record = source["clean"](row)  # un dict, ses clés = les colonnes SQL
            key = record[source["key"]]
            insee = record["insee_code"]
            if key and insee in known_communes and key not in seen:
                seen.add(key)
                chunk.append(record)

        load.insert_chunk(cur, source["table"], chunk)
        conn.commit()  # on valide chaque page : si ça s'interrompt, c'est gardé

        offset += 100
        # Limite Opendatasoft : offset + limit doit rester <= 10000 (offset max 9900).
        # Doc : https://help.opendatasoft.com/apis/ods-explore-v2/
        if offset >= 10_000:
            break

    print(f"{source['table']:9}: {load.count_rows(cur, source['table'], DEPT)}")

conn.commit()
conn.close()
