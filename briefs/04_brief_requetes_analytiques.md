# Brief 04 : requêtes analytiques

> Après ces étapes de collection, de nettoyage et de chargement, nous pouvons
> passer à une étape d'écriture de requêtes SQL qui répondent à des questions de territoire,
> source par source puis en les croisant.

> Compétences visées (RNCP-37638) : **C9, niveau 2** (développer des requêtes SQL
> d'extraction) et **C10, niveau 2** (agréger des données issues de différentes
> sources).

## Situation professionnelle

Nous avons bâti lors des précédents brief un observatoire des territoires. Le client ne veut pas voir la base,
il veut des réponses : combien d'établissements par département, quelles communes
sont bien ou mal dotées, où manque-t-il des services. Votre travail : écrire les
requêtes SQL qui répondent, et présenter les résultats lisiblement.

Toutes les requêtes se lancent sur votre base, par exemple :

```bash
$env:PATH += ";C:\Program Files\PostgreSQL\18\bin"
psql -d megabase -f analyses.sql
```

Rappel du modèle : la **commune** est au centre (clé `insee_code`), chaque typologie
s'y rattache par cette clé, et la commune remonte vers son **département** puis sa
**région**.

## 1. État des lieux (volumétrie)

Requêtes plutôt simple pour se repérer dans les données :

- le nombre de lignes de chaque table (`count(*)`) ;
- le nombre de communes **par région** et **par département** (jointures
  `commune -> departement -> region`, `GROUP BY`) ;
- le nombre d'établissements d'un type (pharmacies, lycées...) **par département**.

Outils : `COUNT`, `GROUP BY`, `JOIN`, `ORDER BY`.

## 2. Agréger par territoire

Plus difficile : des agrégats qui suivent la hiérarchie géographique.

- la **population totale** par région et par département ;
- le **classement** des départements par nombre de pharmacies (ou de lycées) ;
- la **moyenne** d'établissements par commune dans un département.

> Attention *au piège* de la jointure en éventail : si vous joignez plusieurs tables
> de typologies d'un coup avant de compter, les lignes se multiplient entre elles.
> Pré-agrégez chaque source (une sous-requête `GROUP BY` par typologie), puis joignez
> les comptes.

## 3. Croiser les sources

C'est là que la base multi-sources devient intéressante. Écrivez au moins **deux**
requêtes qui mêlent plusieurs typologies, par exemple :

- les communes qui ont **un lycée mais aucune pharmacie** (`LEFT JOIN ... IS NULL`
  ou `NOT EXISTS`) ;
- le **profil de service** d'une commune : combien de chaque type d'établissement,
  une colonne par typologie ;
- les communes qui cumulent **beaucoup d'habitants et peu de services**.

*(le code INSEE permet de répondre à ces questions)*

## 4. Des indicateurs

Enfin, des chiffres qui veulent dire quelque chose pour le client :

- le nombre d'**habitants par pharmacie**, par département (`population / count`) :
  un repère des zones sous-dotées ;
- le **taux d'inscription** des bibliothèques (emprunteurs rapporté à la population),
  là où la donnée existe ;
- un **classement** des départements par densité de l'un des services.

## Bonus (si vous avez le temps)

- un **top N par groupe** avec une window function : les 3 communes les mieux dotées
  de chaque département (`ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)`) ;
- l'**évolution de fréquentation des gares** entre 2023 et 2024
  (`travelers_2024 - travelers_2023`), les plus fortes hausses et baisses.

## Livrables

| Livrable | Forme |
|---|---|
| Les requêtes, regroupées et commentées | un fichier `analyses.sql` |
| Au moins une requête par étape (1 à 4), dont **deux qui croisent les sources** | dans `analyses.sql` |
| Les résultats présentés lisiblement | sortie `psql` copiée, ou un court tableau dans un `.md` |

## Indicateurs de performance

- les requêtes tournent sans erreur et répondent vraiment à la question posée ;
- les agrégats géographiques passent par les jointures `commune -> departement -> region` ;
- au moins deux requêtes croisent plusieurs typologies, et le piège de la jointure
  en éventail est évité (pré-agrégation) ;
- au moins un indicateur (ratio ou densité) est calculé, pas seulement des comptes ;
- les résultats sont lisibles et brièvement interprétés (une phrase par requête).

## Modalités

- Travail individuel
- Prérequis : la base chargée (`corrige0`), SQL (`SELECT`, `JOIN`, `GROUP BY`).
- Durée indicative : une demi-journée.
