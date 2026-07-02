# Brief 05 : déployer l'acquisition sur Scalingo

> Hier, nous avons déployé ensemble un script minimal sur Scalingo : un `Procfile`,
> un `requirements.txt`, et un script qui affiche `DATABASE_URL`. Vous êtes donc
> tout près de pouvoir faire tourner le pipeline d'acquisition complet (le `corrige0`)
> sur Scalingo, et charger les données pour toute la France.

> Compétences visées (RNCP-37638) : **C14, niveau 1** (base de données dans un
> contexte hébergé) et **C16, niveau 1** (gérer les accès et les secrets).

## Situation professionnelle

Le pipeline tourne sur votre postee, mais l'agence veut une base qui se charge
toute seule, sur une machine qui n'est pas la vôtre. Vous déployez le code
d'acquisition sur Scalingo, vous le validez sur un département, puis vous lancez
la France entière.

## 1. Créer une nouvelle app

- Sur le dashboard Scalingo, créez une **nouvelle application** (ne réutilisez pas
  celle d'hier).
- Attachez-lui l'**addon PostgreSQL** (le plus petit plan - nous avons vu qu'il était bien gratuit).
- Dans les variables d'environnement de l'app, vérifiez que `DATABASE_URL` existe (comme hier, c'est l'addon qui la fournit, elle apparaît toute seule).

## 2. Redéployer le script d'hier

Avant de toucher au pipeline, validez la nouvelle app avec ce que vous avez déjà :

- reprenez le dépôt d'hier (`Procfile`, `requirements.txt`, le script qui affiche
  `DATABASE_URL`) ;
- déployez-le sur la nouvelle app, comme hier ;
- dans les logs, vous devez voir s'afficher une URL `postgres://...` : la connexion
  vers la base de l'addon.


## 3. Embarquer le pipeline


- 🔴 si le `main.py` devotre version de `corrige0` ne fonctionne pas, parce que vous n'avez pas fini l'intégration des deux nouvelles sources, utilisez la version que je vous ai fournie dans le dépôt.

- Copiez les fichiers du `corrige0` dans le dépôt : `collect.py`, `clean.py`,
  `load.py`, `main.py`, `schema.sql` (pas besoin de `gares.py`, `btp.py`).
- `requirements.txt` doit contenir `requests` et `psycopg2-binary`.
- Regardez `load.py` : la connexion lit **déjà** `DATABASE_URL` et ne retombe sur la
  base locale que si la variable n'existe pas. Il n'y a **rien à changer dans le
  code** pour déployer. Si vous deviez en changer, ce serait un défaut du code, pas
  du déploiement.
- Si vous partez de **votre** code plutôt que du corrigé, adaptez la connexion sur
  ce modèle : `os.environ.get("DATABASE_URL", "dbname=votre_base_locale")`. Le même
  code doit tourner **en local et sur Scalingo**, sans modification entre les deux.
- Vérifiez-le : lancez `python3 main.py 01` sur votre poste avant de pousser. Si ça
  ne marche plus en local, l'adaptation est ratée.

> 🔴 Aucun secret dans le dépôt : `DATABASE_URL` vit dans l'environnement de l'app,
> jamais dans un fichier versionné.

## 4. Un seul département d'abord

- Dans le `Procfile` :

  ```
  worker: python3 main.py 69
  ```

- Déployez, puis suivez les logs : vous devez voir défiler les mêmes lignes qu'en
  local (géographie, puis chaque source page par page).
- Vérifiez les données depuis le dashboard de l'addon (ou la console PostgreSQL) :
  un `count(*)` sur `commune` et `pharmacie`.

## 5. Observer la reprise en conditions réelles

Sur Scalingo, un worker qui se termine est **relancé automatiquement**. C'est
exactement le scénario pour lequel la reprise a été conçue :

- au deuxième passage, `count_rows` voit que le 69 est déjà chargé, et le run ne
  fait (presque) rien ;
- regardez-le dans les logs, et dites en une phrase pourquoi rien n'est dupliqué.

## 6. Toute la France

- Remplacez le worker par une boucle sur les 101 départements. Par exemple un
  `run_all.py` qui reprend la liste du README du `corrige0` et enchaîne les
  départements (ou toute autre solution qui vous convient et qui est raisonnable et efficace), puis :

  ```
  worker: python3 run_all.py
  ```

- Si le worker est interrompu ou relancé en cours de route, la reprise repart où
  c'était : c'est ce qui rend ce déploiement tranquille.
- Suivez l'avancement avec la requête de volumétrie du README (les `count(*)` par
  table).

## 7. Éteindre ce qui a fini

Un worker qui tourne consomme (et se relance en boucle une fois tout chargé).
Quand la France est chargée : passez le worker à **0 conteneur**. La base, elle,
reste allumée et interrogeable.



## Livrables

| Livrable | Forme |
|---|---|
| L'app Scalingo avec l'addon PostgreSQL | app en ligne |
| Le pipeline déployé, sans secret dans le dépôt | dépôt Git + `Procfile` |
| Le 69 chargé, puis la France entière | `count(*)` copiés dans un `.md` |
| La reprise constatée sur la platefrme (via les logs)| deux lignes d'explication |

## Indicateurs de performance

- le déploiement n'a demandé **aucune modification du code** (seulement `Procfile`
  et `requirements.txt`) ;
- aucun secret n'apparaît dans le dépôt ;
- le même code tourne en local et sur Scalingo, seule la variable d'environnement
  change ;
- la volumétrie distante est cohérente avec le local pour le département testé ;
- le worker relancé ne duplique rien, et l'étudiant sait expliquer pourquoi ;
- le worker est éteint une fois le chargement terminé.

## Modalités

- Travail individuel.
- Prérequis : le brief 03 (le pipeline), le déploiement d'hier sur Scalingo.
- Durée indicative : une demi-journée.
