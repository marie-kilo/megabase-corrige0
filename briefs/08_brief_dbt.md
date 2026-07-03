# Brief 08 : reconstruire l'entrepôt avec dbt

> Objectif : reconstruire l'entrepôt du [brief 07](07_brief_entrepot.md) avec dbt.
> Les transformations des données sont les mêmes. dbt permet de les renseigner (et de les découper) en fichiers versionnés.
> De plus, dbt déduit l'ordre d'exécution et exécute des tests.

> Compétences visées (RNCP-37638) : **C15, niveau 2** (intégrer les ETL, ici en
> ELT) et **C16, niveau 1** (gérer l'entrepôt : tests, documentation).

## Contexte

Au [brief 07](07_brief_entrepot.md), l'entrepôt tient dans un `entrepot.sql` :
nous avons écrit les `CREATE`, `TRUNCATE` et `INSERT` à la main (et l'ordre des étapes
aussi!!), et rien ne vérifie automatiquement les données après reconstruction : toute vérification programmatique devrait être
implémentée par nos soins. dbt prend ces trois points en charge :

- un modèle dbt est un fichier qui contient un `SELECT` ; dbt crée la table
  correspondante ;
- les dépendances entre modèles sont déclarées par `ref()` ; dbt en déduit l'ordre
  d'exécution ;
- des tests de données se déclarent en YAML et se lancent par une commande.

🟢 Les `SELECT` nécessaires ont déjà été écrits au brief 07.

## 1. L'environnement virtuel

dbt est une librairie Python et s'installe avec pip. Comme toute dépendance de projet, il va dans un
environnement virtuel dédié, pas dans le Python global :

```bash
# dans le dossier du projet
~/.pyenv/.../python -m venv env
source env/bin/activate
pip install dbt-postgres

dbt --version
```

Rappels :

- avec pyenv, créez d'abord l'environnement
- `source env/bin/activate` est à refaire à chaque nouveau terminal (le prompt
  affiche `(env)` quand c'est actif) ;
- `env/` va dans le `.gitignore`, `requirements.txt` dans le dépôt.

## 2. Le squelette fourni

Le dossier [dbt_start](../dbt_start/) contient un projet dbt minimal, prêt à
lancer :

| Fichier | Rôle |
|---|---|
| `dbt_project.yml` | le projet : nom, dossier des modèles, matérialisation en table |
| `profiles.yml` | la connexion à `megabase0`, schéma cible `dbt` |
| `requirements.txt` | `dbt-postgres` |
| `models/sources.yml` | les tables de la base de collecte, à compléter |
| `models/exemple.sql` | un modèle témoin, à supprimer ensuite |

Copiez-le, puis suivez son README :

```bash
dbt debug   # attendu : "All checks passed"
dbt run     # attendu : "1 of 1 OK created sql table model dbt.exemple"
```

`dbt debug` lit `profiles.yml` dans le dossier du projet et teste la connexion.
`dbt run` construit le modèle témoin : vérifiez dans psql que `dbt.exemple`
existe et contient le nombre de communes. Ces commandes permettent de valider que l'outillage fonctionne bien.
Dans le reste du brief, il faudra écrire des **modèles**.

> Pour créer un projet de zéro (hors brief) : `dbt init nom_du_projet` pose les
> questions de connexion et écrit le profil dans `~/.dbt/profiles.yml`.

## 3. Compléter les sources

dbt ne lit pas les tables de la base directement : elles se déclarent d'abord
comme **sources**. Le squelette en déclare quatre dans `models/sources.yml` :

```yaml
version: 2

sources:
  - name: megabase0
    schema: public
    tables:
      - name: commune
      - name: departement
      - name: region
      - name: lycee
```

Complétez la liste avec vos typologies (`college`, `pharmacie`, `ehpad`,
`bibliotheque`...).

Dans un modèle, une table déclarée s'écrit
`{{ source('megabase0', 'commune') }}` au lieu de `commune`. Deux effets :

- dbt sait de quelles tables dépend chaque modèle (il en déduit le graphe et la
  documentation) ;
- si la base ou le schéma change, on modifie `sources.yml`, pas les modèles.

## 4. Premier modèle : dim_commune

Un modèle dbt contient un `SELECT` et rien d'autre : pas de `CREATE`, pas de
`INSERT`, pas de `TRUNCATE`. dbt crée la table, nommée d'après le fichier.

Créez `models/dim_commune.sql` : le `SELECT` de l'`INSERT dim_commune` du brief
07, avec les noms de tables remplacés par `source(...)`. Puis :

```bash
dbt run
```

Vérification dans psql : la table `dbt.dim_commune` existe, avec le même
`count(*)` que `entrepot.dim_commune` du brief 07. Le modèle témoin
`exemple.sql` peut être supprimé.

## 5. L'étoile complète

Deux modèles de plus :

- `models/fait_etablissement.sql` : le `UNION ALL` de `GROUP BY insee_code` du
  brief 07, sur les `source(...)` ;
- `models/mart_etablissements_departement.sql` : le nombre d'établissements par
  type et par département. Ce modèle lit les deux précédents ; un modèle se
  référence avec `ref()` :

```sql
SELECT d.departement, f.type, sum(f.nb) AS n
FROM {{ ref('fait_etablissement') }} f
JOIN {{ ref('dim_commune') }} d ON d.insee_code = f.insee_code
GROUP BY d.departement, f.type
```

Relancez `dbt run` : les trois modèles sont construits dans l'ordre déduit des
`ref()`. L'ordre n'est écrit nulle part.

## 6. Tester les données

Créez `models/schema.yml` et déclarez :

- `insee_code` de `dim_commune` : `unique` et `not_null` ;
- `insee_code` de `fait_etablissement` : `relationships` vers `dim_commune`
  (chaque fait pointe vers une commune existante).

```bash
dbt test
```

- Les tests doivent passer. 

- 🔴 Cassez ensuite un test volontairement. 
  - Par exemple, déclarez `type` de `fait_etablissement` en `unique`. 
  - Il échoue forcément (cinq valeurs de type pour envuron 33 000 lignes de faits). 
  - Lancez `dbt test`, lisez la sortie (`FAIL 5`, cinq valeurs en double), puis retirez le test cassé.

## 7. Reconstruire depuis zéro

Videz le schéma `dbt`, puis :

```bash
dbt run && dbt test
```

L'entrepôt est reconstruit et les tests passent. Comparez les `count(*)` avec le
brief 07 : mêmes tables, mêmes comptes.

## 8. L'entrepôt dbt sur la base Scalingo

La base de collecte tourne sur Scalingo depuis le
[brief 05](05_brief_deploiement_scalingo.md). On construit le même entrepôt
dessus, avec les mêmes modèles : seule la connexion change.

Côté dashboard de l'addon, deux réglages :

- **Internet accessibility** : par défaut la base n'est joignable que depuis le
  réseau Scalingo, activez l'accès internet ;
- **Force TLS connections** : activez-le, la connexion se fera chiffrée
  (`sslmode: require` côté dbt).

Côté projet, les identifiants vont dans un fichier `.env`, jamais dans
`profiles.yml`. Découpez `DATABASE_URL`
(`postgres://user:motdepasse@hote:port/base`) en cinq variables
(`.env.example` fourni dans [dbt_start](../dbt_start/)) :

```
SCALINGO_PG_HOST=...
SCALINGO_PG_PORT=...
SCALINGO_PG_USER=...
SCALINGO_PG_DB=...
SCALINGO_PG_PASSWORD=...
```

`.env` est dans le `.gitignore`. La sortie `prod` de `profiles.yml` lit ces
variables (bloc prêt à décommenter dans le squelette) :

```yaml
    prod:
      type: postgres
      host: "{{ env_var('SCALINGO_PG_HOST') }}"
      port: "{{ env_var('SCALINGO_PG_PORT') | as_number }}"
      user: "{{ env_var('SCALINGO_PG_USER') }}"
      password: "{{ env_var('SCALINGO_PG_PASSWORD') }}"
      dbname: "{{ env_var('SCALINGO_PG_DB') }}"
      schema: dbt
      sslmode: require
      threads: 4
```

Pour charger le `.env` avant chaque commande, `dotenv` (installé avec
`pip install "python-dotenv[cli]"`) : il lit le fichier et lance la commande
avec ces variables, pareil sous Windows.

```bash
dotenv run -- dbt debug --target prod
dotenv run -- dbt run --target prod
dotenv run -- dbt test --target prod
```

Attendu : les mêmes trois tables et les mêmes tests au vert que sur la cible
locale, dans le schéma `dbt` de la base distante (dbt crée le schéma
lui-même). Prérequis évident mais vérifiez-le : les tables de collecte
existent sur la base distante (chargées au brief 05).

## Bonus

- `dbt docs generate` puis `dbt docs serve` : documentation et graphe de
  dépendances, générés depuis les `ref()` et `source()` ;
- un second mart (habitants par pharmacie, top communes) ;
- un modèle de statistiques par type (médiane du nombre d'établissements par
  commune, avec `percentile_cont`).

## Livrables

| Livrable | Forme |
|---|---|
| Le projet dbt dans un environnement virtuel | `requirements.txt`, `env` ignoré |
| Les sources complétées | `models/sources.yml` |
| L'étoile en modèles reliés par `ref()` | `models/*.sql` |
| Les tests qui passent | `models/schema.yml` + sortie de `dbt test` |

## Indicateurs de performance

- `dbt debug` et `dbt run` passent depuis le squelette fourni ;
- les modèles ne contiennent que des `SELECT` (aucun `CREATE`, `INSERT` ou
  `TRUNCATE` écrit à la main) ;
- les dépendances passent par `ref()` et `source()`, (l'ordre d'exécution n'est
  écrit nulle part !! Sinon ça perd de son intérêt) ;
- `dbt test` passe, avec au moins un test `relationships` ;
- l'entrepôt se reconstruit depuis un schéma vide avec `dbt run && dbt test` + les volumétries identiques au brief 07 ;
- `dbt run --target prod` construit le même entrepôt sur la base Scalingo, le
  mot de passe restant dans une variable d'environnement ;
- ni `env` ni secret dans le dépôt.

## Modalités

- Travail individuel.
- Prérequis : le [brief 07](07_brief_entrepot.md) (les `SELECT` de l'entrepôt
  sont déjà écrits), le squelette [dbt_start](../dbt_start/).
- Durée indicative : une journée.
