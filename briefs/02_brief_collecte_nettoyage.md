# Brief 02 : collecter et nettoyer une source

> On part d'une source open data, on récupère les données via son API, on la nettoie, et on
> la charge dans la base. 

> Compétences visées (RNCP-37638) : **C8, niveau 2** (automatiser l'extraction de
> données depuis un service web) et **C10, niveau 1-2** (homogénéiser et nettoyer
> les données). Réinvestit le module numérique responsable (sobriété de la collecte).

## Situation professionnelle

Votre agence veut intégrer une première source dans l'observatoire (par exemple les
lycées, ou les pharmacies). La source est une API publique qui renvoie des milliers
de lignes de qualité inégale. On vous demande un script de collecte propre, et
surtout des données nettoyées : un code commune mal normalisé, et la source ne se
reliera à rien.

## 1. Collecter avec un script paramétré (`collecte.py`)

- Un seul script, **paramétré par le département** (`--departement 69`), pas un
  script par ville. Plus précisément, on l'appellera ainsi : `python collecte.py --departement 69`
- Les appels passent par l'API de la source. Documentez chaque appel : l'URL, les
  paramètres, la pagination, la forme de la réponse.
- Règles de sobriété (module numérique responsable) : un périmètre raisonnable (un
  département), et un **User-Agent qui vous identifie poliment dans les requêtes**.

> Une fonction `collecter_<source>` par typologie. Elle renvoie une liste de lignes
> prêtes à nettoyer, dont le code commune de chaque établissement.

## 2. Profiler la source avant de nettoyer

**On fait toujours des vérifications manuelles**, par exemple via un notebook. Ce profilage sert à décider des règles de nettoyage et à les justifier par des chiffres. Sur les données **brutes** de la source, calculez et notez :

- la **volumétrie** : nombre de lignes brutes ;
- les **valeurs manquantes** : taux de null par colonne (`isna().sum()`) ;
- les **doublons** : combien de lignes partagent la même clé métier ;
- la **répartition** des variables catégorielles (`value_counts` : par département,
  par statut public/privé...) ;
- sur une variable numérique (par exemple la population de la commune, ou la mesure
  d'activité), la batterie de statistiques descriptives :
  - **effectif**, **minimum**, **maximum**, **étendue** (max moins min) ;
  - **moyenne** et **médiane** ;
  - **moyenne censurée** (tronquée hors des déciles D1 et D9), plus robuste aux valeurs aberrantes que la moyenne simple ;
  - **quantiles** : Q1 (25 %), Q3 (75 %), déciles D1 (10 %) et D9 (90 %) ;
  - **écart interquartile** (Q3 moins Q1) et **écart interdécile** (D9 moins D1) ;
  - **écart-type**.

Ces chiffres révèlent les anomalies à traiter : un code commune manquant, une population à zéro, une valeur aberrante très au-dessus du D9. Chaque règle de nettoyage de l'étape suivante doit s'appuyer sur un de ces constats.

## 3. Nettoyer le code INSEE (`nettoyage.py`)

C'est le coeur du projet. Trois règles obligatoires :

1. **On relie toujours par le code INSEE, jamais par le nom de la commune.** "Lyon",
   "LYON" et "lyon" sont trois textes différents ; le code INSEE est unique.
2. **On lit le code comme du texte**, pour ne pas perdre le zéro du début (le code de
   l'Ain est 01, pas 1).
3. **On gère les cas particuliers** : les arrondissements de Lyon, Marseille et
   Paris ont des codes à part qu'il faut ramener à la commune principale (Lyon
   entier = 69123).

Écrivez les fonctions de nettoyage : `normaliser_insee` (texte, sans espace,
arrondissements ramenés), et une règle qui **écarte** les établissements dont la
commune est inconnue, en les **comptant** au lieu de les charger en base de données.

## 4. Charger et vérifier

- Chargez les communes d'abord (la table que les autres référencent), puis la
  source.
- Vérifiez : volumétrie par table, zéro clé étrangère orpheline, et le nombre
  d'établissements écartés (il doit être expliqué, pas subi).
- Un `assert` sur une règle critique (zéro doublon en sortie, zéro code INSEE
  inconnu accepté) : un nettoyage qui échoue bruyamment vaut mieux qu'un chargement
  silencieusement faux.

## Livrables

| Livrable | Forme |
|---|---|
| Le script de collecte paramétré, API documentées | `collecte.py` |
| Les fonctions de nettoyage du code INSEE | `nettoyage.py` |
| Une source chargée et vérifiée, écarts comptés | base + sortie de contrôle |

## Indicateurs de performance

- la collecte est paramétrée (le département en argument), sobre, et chaque appel
  API est documenté (URL, paramètres, pagination) ;
- la source est **profilée avant nettoyage** (volumétrie, manquants, doublons,
  statistiques descriptives : médiane, moyenne, moyenne censurée, quantiles, écarts
  interquartile et interdécile, écart-type), et chaque règle de nettoyage s'appuie
  sur un constat chiffré ;
- le code INSEE est lu en texte, normalisé, et les arrondissements sont traités ;
- aucun établissement sans commune connue n'est chargé : ils sont écartés et comptés ;
- des `assert` font échouer le run plutôt que de charger des données fausses ;
- la source chargée passe les contrôles (volumétrie, zéro orphelin).

## Modalités

- Travail en groupe, en sprint, avec point quotidien et tickets sur le tableau.
- Prérequis : `requests` et `psycopg2` les briefs 00 et 01.
- Durée indicative : une journée.
