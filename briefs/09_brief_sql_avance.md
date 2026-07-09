# Brief 09 : index, fonctions et triggers sur l'entrepôt

> Objectif : "outiller" l'entrepôt du [brief 07](07_brief_entrepot.md) avec trois
> mécanismes PostgreSQL : les index (pour accélérer les lectures), les fonctions
> (pour encapsuler les requêtes) et les triggers (pour protéger les tables ou les maintenir).
> Puis vérifier l'état de l'entrepôt avec pandas.

> Compétences visées (RNCP-37638) : **C9, niveau 2-3** (requêtes d'extraction),
> **C16, niveau 1-2** (gérer l'entrepôt), **C10, niveau 2** (agréger, ici en
> pandas).

## Contexte

On part de l'entrepôt du [brief 07](07_brief_entrepot.md). 
Ses tables sont lues par les analyses, et **personne ne les protège ni ne les accélère**. Donc :

- Si l'entrepôt "diverge", on ne le remarque pas.
- Les requêtes peuvent être inutilement longues.


> Ce brief ajoute une couche **d'exploitation**. Tout peut être écrit dans un fichier `sql_avance.sql`, que l'on doit pouvoir ré-exécuter.


> 💡 Rappel : Un mart (data mart) est une table de résultats prête à consommer, construite au-dessus de l'entrepôt pour répondre à une question métier précise. Là où les faits et les dimensions sont le rangement générique (toutes les questions possibles), le mart est la réponse déjà calculée à une question donnée : le client la lit telle quelle, sans écrire de jointure ni d'agrégat.


## 1. Lire un plan d'exécution

`EXPLAIN` affiche comment PostgreSQL compte exécuter une requête ;
`EXPLAIN ANALYZE` l'exécute et mesure.

- `EXPLAIN ANALYZE` sur `SELECT sum(nb) FROM entrepot.fait_etablissement WHERE insee_code = '69123'` : le plan montre un `Index Scan`.  
  - La clé primaire est un index, et PostgreSQL s'en sert lors de la requête.
- Même chose avec `WHERE type = 'lycee'` : le plan montre un Seq Scan (lecture de toute la table). 

**💵 Expliquez en une phrase pourquoi l'index de la clé primaire sert au premier cas et pas au second.**

## 2. Créer un index

- `CREATE INDEX` sur `fait_etablissement (type)`.
- Relancez le `EXPLAIN ANALYZE` du cas `type = 'lycee'` : le plan change les temps (d'exécution) avant et après.
- Répondez en une/deux phrase(s) : pourquoi ne pas indexer toutes les colonnes de toutes les tables ? Tenez compte du fait que l'entrepôt se reconstruit (chaque `TRUNCATE` + `INSERT` réécrit aussi les index!!!).

## 3. Encapsuler dans des fonctions

Une fonction SQL donne un nom et des paramètres à une requête. Écrivez :

- `entrepot.top_communes(p_type text, p_n integer)` : les N communes qui ont le
  plus d'établissements de ce type, avec leur département. 
  - Usage : `SELECT * FROM entrepot.top_communes('pharmacie', 5);`

- `entrepot.habitants_par(p_type text)` : par département, les habitants, le
  nombre d'établissements du type, et le ratio habitants par établissement.

> 💡Les deux se déclarent avec `CREATE OR REPLACE FUNCTION ... RETURNS TABLE (...) LANGUAGE sql`.

## 4. Deux triggers

Un trigger exécute une fonction quand un événement touche une table (`INSERT`, `UPDATE`, `DELETE`).

### 1. Protection

> L'entrepôt se reconstruit, il ne se modifie pas à la main. Écrivez un trigger `BEFORE DELETE` sur `entrepot.dim_commune` qui lève une
exception (`RAISE EXCEPTION`, fonction en `LANGUAGE plpgsql`). 

Vérifiez :

- un `DELETE` sur la dimension échoue 
- `psql -f entrepot.sql` fonctionne toujours. Un trigger `FOR EACH ROW` sur
  `DELETE` ne se déclenche pas sur `TRUNCATE` : la reconstruction reste
  possible.

## 2. Maintenance au fil de l'eau. 

> L'alternative à la reconstruction est de tenir les faits à jour à chaque insertion dans la base de collecte. Écrivez un trigger
`AFTER INSERT` sur `pharmacie` qui incrémente le fait correspondant
(`INSERT ... ON CONFLICT ... DO UPDATE SET nb = nb + 1`). 

La démonstration se fait entièrement sous transaction : dans PostgreSQL, même
un `CREATE TRIGGER` s'annule au `ROLLBACK`, donc l'expérience ne laissera
aucune trace.

- 1. `BEGIN;` puis créez la fonction et le trigger.
- 2. Relevez le `nb` de pharmacies d'une commune dans les faits (Lyon, `insee_code = '69123'`).
- 3. Insérez une pharmacie fictive dans la table `pharmacie` de la base de collecte.
- 4. Relisez le même `nb` : il a augmenté de 1 sans aucune reconstruction. C'est le trigger qui a fait le travail.
- 5. `ROLLBACK;` : le trigger, la fonction, la pharmacie fictive et la mise à jour du fait ont tous disparu. Vérifiez que le `nb` est revenu à sa valeur initiale.

Pour conclure, deux questions, en une/deux phrases chacune :

- Quand la maintenance par trigger se justifie-t-elle, et quand la
  reconstruction suffit-elle ? Raisonnez sur le rythme d'arrivée des données :
  flux continu ou campagnes de chargement.
- Combien faudrait-il de triggers pour maintenir l'entrepôt complet ?
  Comptez : une typologie par table de collecte, trois opérations à couvrir
  (`INSERT`, `UPDATE`, `DELETE`). C'est ce nombre qui explique pourquoi la
  reconstruction reste la méthode de référence ici.

## 5. Vérification croisée avec pandas

Un script `verification_pandas.py` qui refait le calcul du mart en pandas et compare avec le SQL :

- charger `entrepot.fait_etablissement` et `entrepot.dim_commune` avec `pd.read_sql` 
- refaire le mart : `merge` (l'équivalent du `JOIN`) puis `groupby` + `sum`
  (l'équivalent du `GROUP BY`) ;
- comparer avec le même calcul fait en SQL :
  `pd.testing.assert_frame_equal`, et afficher le nombre de lignes comparées ;
- produire le tableau large du brief 04 (une colonne par type) avec `pivot_table` ;
- la connexion lit `DATABASE_URL` si elle existe, et retombe sur la base locale
  sinon (même convention que `corrige0`, brief 05).

## 6. Sur la base Scalingo

Index, fonctions et triggers vivent **dans** la base : posés sur la base
Scalingo (celle du [brief 05](05_brief_deploiement_scalingo.md), avec
l'entrepôt du brief 07 construit dessus, étape 6), ils restent en place et
servent tous les clients qui s'y connectent.

```bash
export DATABASE_URL="postgres://..."
python3 ../outils/run_sql.py sql_avance.sql
python3 verification_pandas.py
```

Le même `sql_avance.sql` et le même `verification_pandas.py` passent en local
et sur Scalingo : seule `DATABASE_URL` change.

## Bonus

- une vue matérialisée (`CREATE MATERIALIZED VIEW` + `REFRESH`) sur le mart :
  l'intermédiaire entre la vue (recalculée à chaque lecture) et la table
  (reconstruite par vous) ;
- un index partiel (`CREATE INDEX ... WHERE type = 'pharmacie'`) et son plan ;
- `EXPLAIN (ANALYZE, BUFFERS)` : les lectures de pages, pas seulement le temps.

## Livrables

| Livrable | Forme |
|---|---|
| Index, fonctions, triggers et leurs vérifications | `sql_avance.sql`, ré-exécutable |
| Les plans d'exécution avant / après index | en commentaire dans le fichier |
| Les réponses aux trois questions (préfixe gauche, coût des index, trigger contre reconstruction) | en commentaire dans le fichier |
| La vérification pandas | `verification_pandas.py`, affiche le résultat de la comparaison |

## Indicateurs de performance

- `psql -f sql_avance.sql` passe deux fois de suite sans erreur (les
  démonstrations destructives sont sous transaction) ;
- le changement de plan est constaté et expliqué (préfixe gauche de l'index
  composé) ;
- les fonctions s'appellent avec des paramètres et rendent les mêmes chiffres
  que les requêtes du brief 07 ;
- le `DELETE` est bloqué, la reconstruction ne l'est pas, et l'étudiant sait
  dire pourquoi ;
- pandas et SQL donnent exactement les mêmes agrégats ;
- les mêmes fichiers passent sur la base Scalingo grâce à la variable environnementale `DATABASE_URL`.

## Modalités

- Travail individuel.
- Prérequis : le [brief 07](07_brief_entrepot.md) (l'entrepôt construit). Le
  [brief 08](08_brief_dbt.md) n'est pas nécessaire.
- Durée indicative : une journée + une demi journée pour les bonus.
