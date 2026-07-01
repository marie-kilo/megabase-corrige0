# Brief 03 : intégrer plusieurs sources

> Vous touchez ici au coeur du projet !! On ajoute des sources, une à une, toutes reliées par la
> commune, jusqu'à pouvoir poser des questions (et y répondre !!) qu'aucune source seule ne permet.

> Compétences visées (RNCP-37638) : **C10, niveau 2** (agréger des données issues
> de différentes sources) et **C15, niveau 1-2** (intégrer les ETL en entrée d'une
> base). C'est la compétence data engineer centrale : faire tenir ensemble des
> sources hétérogènes.

## Situation professionnelle

La première source est chargée. L'agence veut maintenant un vrai observatoire :
plusieurs sources dans la même base, comparables commune par commune. Chaque
nouvelle source arrive avec son propre format et sa propre façon de désigner la
commune. Votre travail : les faire toutes retomber sur le code INSEE.

## Pourquoi réunir plusieurs sources

Parce que les questions intéressantes mélangent les sources. Avec une seule, pas de
réponse. Avec plusieurs reliées par la commune, oui :

- Quelles communes ont un lycée mais aucune pharmacie ?
- Où y a-t-il une gare mais peu de bibliothèques ?
- Quelles communes cumulent beaucoup d'habitants et peu de services ?

## 1. Le catalogue des sources

> Intégrez-en le plus possible. Plus il y en a, mieux c'est (cf. `00_brief_modelisation.md` section `Le catalogue des typologies`).

| Source | D'où viennent les données | Ce qu'on mesure |
|---|---|---|
| Lycées | annuaire de l'éducation | nombre d'élèves |
| Collèges | annuaire de l'éducation | nombre d'élèves |
| Mairies | découpage administratif (communes) | population de la commune |
| Entreprises du BTP | base des entreprises (Sirene) | effectif salarié |
| Pharmacies | base FINESS | population de la commune |
| EHPAD | base FINESS | capacité d'accueil |
| Bibliothèques | base des bibliothèques publiques | inscrits ou population |
| Gares | fréquentation des gares (SNCF) | voyageurs par an |

## 2. Les trois façons de rattacher une source à la commune

Toutes les sources ne donnent pas le code INSEE de la même façon. C'est tout
l'enjeu :

- **Directement** : la source porte le code commune.
- **Par dérivation** : une mairie par commune, fabriquée depuis le référentiel des
  communes.
- **Par géocodage** : la source n'a pas le code.

## 3. Un chargement générique et rejouable

- Une fonction `collecter_<source>` par typologie dans `collecte.py`.
- Une table par typologie dans `schema.sql`, reliée à `commune` par clé étrangère.
- Un `chargement.py` générique : il relie chaque source à sa commune, écarte et compte ce qui ne se relie pas, déduplique.
- `main.py` enchaîne tout. **Le relancer deux fois donne le même résultat.**

## 4. Les premières analyses croisées

Écrivez dans `analyses.sql` au moins deux requêtes qui croisent deux sources ou
plus, par exemple le profil de service d'une commune (combien de chaque type) ou
les communes avec une gare mais sans pharmacie.

> Attention au piège de la jointure en éventail : joindre plusieurs tables en une
> seule fois puis compter multiplie les lignes entre elles. Pré-agrégez chaque source avant de
> joindre.

## Livrables

| Livrable | Forme |
|---|---|
| Le plus de sources intégrées possible, reliées par le code INSEE | `collecte.py`, `schema.sql`, `chargement.py` |
| Un chargement rejouable (deux runs, même résultat) | `main.py` |
| Des requêtes qui croisent au moins deux sources | `analyses.sql` |

## Indicateurs de performance

- plusieurs sources sont intégrées, toutes reliées par le code INSEE ;
- les trois techniques de rattachement sont comprises et appliquées selon la source ;
- le chargement est idempotent (deux exécutions, mêmes volumétries), les écarts sont comptés ;
- les requêtes croisées répondent à des questions impossibles avec une seule source ;
- le code reste découpé proprement (collecte, nettoyage, chargement séparés).
- vous vérifierez **programmatiquement** que deux exécutions du `main.py` renvoient les mêmes résultats.

## Modalités

- Travail en groupe, en sprint. C'est un bon moment pour répartir les sources entre
  les membres : chacun ajoute la sienne via une branche et une pull request relue
  par un autre.
- Prérequis : les briefs 00, 01 et 02.
- Durée indicative : deux journées.
