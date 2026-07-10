# Le strict minimum pour déployer un script Python sur Scalingo

Un exemple de **strict minimum** pour déployer un script Python sur Scalingo :

| Fichier | Rôle |
|---|---|
| `Procfile` | ce que Scalingo doit lancer (ici un `worker`, pas de serveur web) |
| `requirements.txt` | les dépendances Python à installer |
| `.python-version` | la version de Python à utiliser |
| `script.py` | le programme lui-même |

## Avant les commandes (une fois, sur le dashboard)

1. Créer l'application sur le dashboard Scalingo.
2. Lui attacher l'addon PostgreSQL : la variable `DATABASE_URL` apparaît toute
   seule dans l'environnement de l'app.
3. Récupérer l'URL git de l'app (onglet du dashboard, de la forme
   `git@ssh.osc-fr1.scalingo.com:nom-de-l-app.git`).

## Les commandes

```bash
# un dépôt git (si ce n'est pas déjà fait)
git init

git add Procfile requirements.txt .python-version script.py

git commit -m "premier deploiement scalingo"

# le remote GitHub : pour partager le code (facultatif)
git remote add origin <url-repo-github>
git push -u origin main

# 🟢 La deuxième des deux nouvelles commandes à exécuter :
# le remote Scalingo : celui qui déploie
git remote add production <url-repo-scalingo>

# pousser main (chaque push déclenche un déploiement)
git push production main

# OU pousser une autre branche, par exemple "two" :
# (🟢 la deuxième des deux nouvelles commandes à exécuter)
# Scalingo ne déploie que sa branche main, il faut donc la renommer au passage
git push production two:main
```

## Vérifier

- Le déploiement se suit en direct dans la sortie du `git push`, puis dans les
  logs de l'app sur le dashboard (i.e. l'onglet "Logs" de l'app, pas de la base de données !!).
- Ici, `script.py` affiche `DATABASE_URL` : la ligne `postgres://...` dans les
  logs prouve que l'app a accès à la variable environnementale (on test donc plus qu'avec un simple `print("Something")`).

## 💡 Pense bête

- On peut stopper un worker en le mettant à 0 conteneur sur le dashboard de l'app.
- Aucun secret dans le dépôt : `DATABASE_URL` vit **uniquement**dans l'environnement de l'app,
  jamais dans le code!! :)
