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

conn.commit()
conn.close()