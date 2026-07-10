# Résultat final pour l'entrepot.sql avec TRUNCATE ---> run_sql.py ---> count (*)

![Description de l’image](images/entrepot.png)


# Avec DROP CASCADE : (test dans psql)
# Premier fois:

- (.env) PS C:\Users\Utilisateur\Desktop\cours\corrige0> psql -U postgres -d megabase0 -f entrepot.sql
Password for user postgres: 

CREATE SCHEMA
psql:entrepot.sql:11: NOTICE:  la table « dim_commune » n'existe pas, poursuite du traitement
DROP TABLE
CREATE TABLE
INSERT 0 34968
psql:entrepot.sql:34: NOTICE:  la table « dim_type » n'existe pas, poursuite du traitement
DROP TABLE
CREATE TABLE
INSERT 0 7
psql:entrepot.sql:52: NOTICE:  la table « fait_etablissement » n'existe pas, poursuite du traitement
DROP TABLE
CREATE TABLE
INSERT 0 50120
(.env) PS C:\Users\Utilisateur\Desktop\cours\corrige0> psql -U postgres -d megabase0 -f entrepot.sql
Password for user postgres: 

# Deuxième fois:
- psql:entrepot.sql:6: NOTICE:  le schéma « entrepot » existe déjà, poursuite du traitement
CREATE SCHEMA
psql:entrepot.sql:11: NOTICE:  DROP cascade sur contrainte fait_etablissement_insee_code_fkey sur table entrepot.fait_etablissement
DROP TABLE
CREATE TABLE
INSERT 0 34968
psql:entrepot.sql:34: NOTICE:  DROP cascade sur contrainte fait_etablissement_type_fkey sur table entrepot.fait_etablissement
DROP TABLE
CREATE TABLE
INSERT 0 7
DROP TABLE
CREATE TABLE
INSERT 0 50120
(.env) PS C:\Users\Utilisateur\Desktop\cours\corrige0> psql -U postgres -d megabase0

megabase0=# \dt entrepot.*
                  List of tables                                                                                                                                                        
  Schema  |        Name        | Type  |  Owner   
----------+--------------------+-------+----------
 entrepot | dim_commune        | table | postgres
 entrepot | dim_type           | table | postgres
 entrepot | fait_etablissement | table | postgres
(3 rows)


megabase0=# SELECT COUNT(*) FROM entrepot.dim_type;
 count                                                                                                                                                                                  
-------
     7
(1 row)


megabase0=# SELECT COUNT(*) FROM entrepot.fait_etablissement;
 count                                                                                                                                                                                  
-------
 50120
(1 row)


megabase0=# 

******************************
# Avec TRUNCATE:
******************************
- 1er fois:
--------------
(.env) PS C:\Users\Utilisateur\Desktop\cours\corrige0> psql -U postgres -d megabase0 -f entrepot.sql
Password for user postgres: 

psql:entrepot.sql:6: NOTICE:  le schéma « entrepot » existe déjà, poursuite du traitement
CREATE SCHEMA
psql:entrepot.sql:17: NOTICE:  la relation « dim_commune » existe déjà, poursuite du traitement
CREATE TABLE
psql:entrepot.sql:25: NOTICE:  la relation « dim_type » existe déjà, poursuite du traitement
CREATE TABLE
psql:entrepot.sql:34: NOTICE:  la relation « fait_etablissement » existe déjà, poursuite du traitement
CREATE TABLE
TRUNCATE TABLE
psql:entrepot.sql:42: NOTICE:  TRUNCATE cascade sur la table « fait_etablissement »
TRUNCATE TABLE
psql:entrepot.sql:43: NOTICE:  TRUNCATE cascade sur la table « fait_etablissement »
TRUNCATE TABLE
INSERT 0 34968
INSERT 0 7
INSERT 0 50120

- 2è fois: 
---------------
(.env) PS C:\Users\Utilisateur\Desktop\cours\corrige0> psql -U postgres -d megabase0 -f entrepot.sql
Password for user postgres: 

psql:entrepot.sql:6: NOTICE:  le schéma « entrepot » existe déjà, poursuite du traitement
CREATE SCHEMA
psql:entrepot.sql:17: NOTICE:  la relation « dim_commune » existe déjà, poursuite du traitement
CREATE TABLE
psql:entrepot.sql:25: NOTICE:  la relation « dim_type » existe déjà, poursuite du traitement
CREATE TABLE
psql:entrepot.sql:34: NOTICE:  la relation « fait_etablissement » existe déjà, poursuite du traitement
CREATE TABLE
TRUNCATE TABLE
psql:entrepot.sql:42: NOTICE:  TRUNCATE cascade sur la table « fait_etablissement »
TRUNCATE TABLE
psql:entrepot.sql:43: NOTICE:  TRUNCATE cascade sur la table « fait_etablissement »
TRUNCATE TABLE
INSERT 0 34968
INSERT 0 7
INSERT 0 50120

# Vérifié
(.env) PS C:\Users\Utilisateur\Desktop\cours\corrige0> psql -U postgres -d megabase0


megabase0=# \dt entrepot.*
                  List of tables                                                                                                                                                        
  Schema  |        Name        | Type  |  Owner   
----------+--------------------+-------+----------
 entrepot | dim_commune        | table | postgres
 entrepot | dim_type           | table | postgres
 entrepot | fait_etablissement | table | postgres
(3 rows)


**********************
megabase0=# SELECT COUNT(*) FROM entrepot.dim_commune;
 count                                                                                                                                                                                  
-------
 34968
(1 row)


megabase0=# SELECT COUNT(*) FROM entrepot.dim_type;
 count                                                                                                                                                                                  
-------
     7
(1 row)


megabase0=# SELECT COUNT(*) FROM entrepot.fait_etablissement;
 count                                                                                                                                                                                  
-------
 50120
(1 row)


******************************************
# Avec le fichier run_sql.py:
(.env) PS C:\Users\Utilisateur\Desktop\cours\corrige0> $env:DATABASE_URL = "dbname=megabase0 user=postgres password=Mkilo1990 host=localhost port=5432"       
(.env) PS C:\Users\Utilisateur\Desktop\cours\corrige0> python run_sql.py entrepot.sql                                                          
NOTICE:  le schéma « entrepot » existe déjà, poursuite du traitement
NOTICE:  la relation « dim_commune » existe déjà, poursuite du traitement
NOTICE:  la relation « dim_type » existe déjà, poursuite du traitement
NOTICE:  la relation « fait_etablissement » existe déjà, poursuite du traitement
NOTICE:  TRUNCATE cascade sur la table « fait_etablissement »
NOTICE:  TRUNCATE cascade sur la table « fait_etablissement »
OK : entrepot.sql execute sur dbname=megabase0 user=postgres password=Mkilo1990 host=localhost port=5432
(.env) PS C:\Users\Utilisateur\Desktop\cours\corrige0> 
# **************** (2è fois:)
(.env) PS C:\Users\Utilisateur\Desktop\cours\corrige0> python run_sql.py entrepot.sql
NOTICE:  le schéma « entrepot » existe déjà, poursuite du traitement
NOTICE:  la relation « dim_commune » existe déjà, poursuite du traitement
NOTICE:  la relation « dim_type » existe déjà, poursuite du traitement
NOTICE:  la relation « fait_etablissement » existe déjà, poursuite du traitement
NOTICE:  TRUNCATE cascade sur la table « fait_etablissement »
NOTICE:  TRUNCATE cascade sur la table « fait_etablissement »
OK : entrepot.sql execute sur dbname=megabase0 user=postgres password=Mkilo1990 host=localhost port=5432
(.env) PS C:\Users\Utilisateur\Desktop\cours\corrige0> 
