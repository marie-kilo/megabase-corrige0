# Brief 06 : intégrer deux nouvelles sources

> Objectif : partir du corrigé fourni ([corrige0](../corrige0/README.md)) et y
> intégrer deux nouvelles sources de données, chacune reliée à la région, au
> département ou à la commune par une clé étrangère. Une source suit le
> standard Opendatasoft et entre dans `SOURCES` de `main.py`, l'autre est d'un
> type différent et se gère dans un fichier indépendant.

> Compétences visées (RNCP-37638) : **C8, niveau 2** (automatiser l'extraction
> depuis un service web) et **C10, niveau 2** (agréger des données de sources
> différentes).

## Contexte

Le pipeline de `corrige0` charge la géographie et sept typologies, avec une
reprise par département. Son architecture sépare la collecte (`collect.py`), le
nettoyage (`clean.py`) et le chargement (`load.py`) ; les sources Opendatasoft
sont déclarées dans la liste `SOURCES` de `main.py`, les autres ont leur propre
fichier (`gares.py`, `btp.py`). Vous ajoutez deux sources dans cette
architecture, sans la casser.

## 1. Choisir les deux sources

- Une source **Opendatasoft** : un dataset de data.education.gouv.fr,
  public.opendatasoft.com, data.culture.gouv.fr ou d'un autre portail
  Opendatasoft (l'API Explore v2.1, celle qu'appelle `collect.fetch_page`).
- Une source **différente** : une API qui n'est pas Opendatasoft (pagination,
  format et filtres à étudier), sur le modèle de `btp.py` ou `gares.py`.

Critère de choix, avant d'écrire du code : la donnée doit se rattacher au
territoire. Vérifiez dans les premiers enregistrements qu'un champ porte le
code INSEE de la commune, ou le code du département ou de la région (les
façons de se rattacher sont décrites dans le
[brief 03](03_brief_integration.md)).

## 2. Intégrer la source Opendatasoft

Trois modifications, pas plus :

- une table dans `schema.sql`, reliée à la géographie par clé étrangère ;
- une fonction de nettoyage dans `clean.py` (une ligne brute devient un dict
  dont les clés sont les colonnes SQL) ;
- une entrée dans `SOURCES` (`main.py`) : url, `where` par département,
  `select`, `order_by`, fonction de nettoyage.

La double boucle de `main.py` (sources x pages) et la reprise par département
fonctionnent alors sans autre modification.

## 3. Intégrer la source différente

Un fichier dédié, sur le modèle de `btp.py` : son propre fetch (l'API impose sa
pagination), le nettoyage dans `clean.py`, l'insertion par
`load.insert_chunk`, et idéalement avec un mécanisme de reprise (i.e. le code permet de reprendre l'exécution "là où on s'est arrêté" lorsqu'il est relancé).

## 4. Vérifier la rejouabilité

Le chargement reste rejouable : deux exécutions donnent le même résultat.
Vérifiez-le **programmatiquement** : un script qui lance deux fois le
chargement, relève les `count(*)` après chaque passage, et affiche si les
volumétries sont identiques.

## Livrables

| Livrable | Forme |
|---|---|
| Le code de `corrige0` mis à jour (source Opendatasoft dans `SOURCES`) | `schema.sql`, `clean.py`, `main.py` |
| La seconde source dans son fichier indépendant | un fichier dédié |
| Le chargement rejouable, vérifié programmatiquement | script de vérification + sa sortie |

## Indicateurs de performance

- les deux nouvelles tables sont reliées à la géographie par clé étrangère ;
- la source Opendatasoft passe par la boucle générique de `main.py`, (sans code
  ad hoc !!);
- la source différente a son fichier dédié (avec sa propre reprise si possible, sinon tant pis) ;
- le chargement est idempotent (deux exécutions, mêmes volumétries) et les
  lignes écartées sont comptées ;
- la vérification est programmatique, pas visuelle.

## Modalités

- Travail individuel. Relecture croisée possible et encouragée :))
- Prérequis : le [brief 03](03_brief_integration.md) et le
  [corrige0](../corrige0/README.md) fonctionnel.
- Durée indicative : une journée.
