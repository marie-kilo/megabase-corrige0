import requests

HEADERS = {
    "User-Agent": "megabase-projet-formation"
}

TIMEOUT = 30

url = "https://data.culture.gouv.fr/api/explore/v2.1/catalog/datasets/festivals-global-festivals-_-pl/records"

all_festivals = []
offset = 0
limit = 100   # IMPORTANT : 100 fonctionne, 1000 provoque une erreur 400

while True:
    params = {
        "limit": limit,
        "offset": offset
    }

    response = requests.get(url, params=params, headers=HEADERS, timeout=TIMEOUT)
    response.raise_for_status()

    batch = response.json().get("results", [])

    if not batch:
        break

    all_festivals.extend(batch)
    offset += limit

print("Nombre total de festivals récupérés :", len(all_festivals))

# Affichage des 5 premiers festivals
for f in all_festivals[:5]:

    identifiant_festival = f.get("identifiant")
    nom = f.get("nom_du_festival")
    region = f.get("region_principale_de_deroulement")
    departement = f.get("departement_principal_de_deroulement")
    commune = f.get("commune_principale_de_deroulement")
    code_postal = f.get("code_postal_de_la_commune_principale")  
    code_insee = f.get("code_insee_commune")  
    adresse = f.get("adresse_postale")
    discipline = f.get("discipline_dominante")
    site = f.get("site_internet_du_festival")
    

    geo = f.get("geocodage_xy", {})
    lat = geo.get("lat")
    lon = geo.get("lon")


    print("\nIdentifiant :", identifiant_festival)
    print("Nom :", nom)
    print("Région :", region)
    print("Département :", departement)
    print("Commune :", commune)
    print("Code postal :", code_postal)
    print("Code INSEE :", code_insee)
    print("Adresse :", adresse)
    print("Discipline :", discipline)
    print("Site :", site)
    print(f"Latitude : {lat} | Longitude : {lon}")
