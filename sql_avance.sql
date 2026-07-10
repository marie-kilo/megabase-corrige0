-- terminal: psql -U postgres -d megabase0 -h localhost -p 5432

---1.Lire un plan d'exécution:
--EXPLAIN ANALYZE SELECT * FROM entrepot.fait_etablissement WHERE type = 'insee_code';
--Planning Time: 0.336 ms / Execution Time: 3.252 ms

--EXPLAIN ANALYZE SELECT sum(nb) FROM entrepot.fait_etablissement WHERE insee_code = '69123'
--Planning Time: 0.070 ms / Execution Time: 3.331 ms

--EXPLAIN ANALYZE SELECT * FROM entrepot.fait_etablissement WHERE type = 'lycee';
--Planning Time: 0.076 ms / Execution Time: 3.457 ms

--Q.1. pourquoi l'index de la clé primaire sert au premier cas et pas au second.
---- Parce que insee_code est indexé (clé primaire), donc PostgreSQL peut chercher directement la ligne,
---- alors que type n’a pas d’index, donc PostgreSQL doit lire toute la table (Lire un plan d'exécution).


---2.Créer un index:

CREATE INDEX IF NOT EXISTS idx_fait_etablissement_type
       ON entrepot.fait_etablissement(type);


--EXPLAIN ANALYZE SELECT * FROM entrepot.fait_etablissement WHERE type = 'insee_code';
--resultat : Planning Time: 0.110 ms / Execution Time: 0.047 ms

--EXPLAIN ANALYZE SELECT sum(nb) FROM entrepot.fait_etablissement WHERE insee_code = '69123'
--resultat : Planning Time: 0.115 ms / Execution Time: 3.428 ms

--EXPLAIN ANALYZE SELECT * FROM entrepot.fait_etablissement WHERE type = 'lycee';
--resultat : Planning Time: 0.080 ms / Execution Time: 0.289 ms

---Q.2. Pourquoi ne pas indexer toutes les colonnes ?
-- Q1 sans  index             121.51 ms
-- Q1 avec index                5.33 ms
-- Parce que chaque index doit être mis à jour à chaque INSERT et entièrement reconstruit
-- à chaque TRUNCATE + INSERT de l'entrepôt. Trop d'index ralentiraient fortement la reconstruction.
-- On indexe seulement les colonnes souvent utilisées dans les WHERE et les JOIN.


---3. Encapsuler dans des fonctions

CREATE OR REPLACE FUNCTION entrepot.top_communes(
    p_type text,
    p_n integer
)
RETURNS TABLE (
    insee_code text,
    commune text,
    departement text,
    nb integer
)
LANGUAGE sql AS $$
    SELECT 
        f.insee_code,
        c.commune,
        c.departement,
        f.nb
    FROM entrepot.fait_etablissement f
    JOIN entrepot.dim_commune c USING (insee_code)
    WHERE f.type = p_type
    ORDER BY f.nb DESC
    LIMIT p_n;
$$;
SELECT * FROM entrepot.top_communes('pharmacie', 5);

  CREATE OR REPLACE FUNCTION entrepot.habitants_par(
    p_type text
)
RETURNS TABLE (
    departement text,
    habitants integer,
    nb_etablissements integer,
    ratio numeric
)
LANGUAGE sql AS $$
    SELECT 
        c.departement,
        SUM(c.population) AS habitants,
        SUM(f.nb) AS nb_etablissements,
        ROUND(SUM(c.population)::numeric / NULLIF(SUM(f.nb), 0), 2) AS ratio
    FROM entrepot.fait_etablissement f
    JOIN entrepot.dim_commune c USING (insee_code)
    WHERE f.type = p_type
    GROUP BY c.departement
    ORDER BY ratio DESC;
$$;

SELECT * FROM entrepot.habitants_par('pharmacie');

--4.Deux triggers
-- 4.1 Trigger de protection : empêcher DELETE sur dim_commune

-- Fonction qui lève une exception
CREATE OR REPLACE FUNCTION entrepot.no_delete_dim_commune()
RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'Suppression interdite sur entrepot.dim_commune';
END;
$$;

-- Si le trigger existe déjà, on le supprime pour rendre le fichier ré-exécutable
DROP TRIGGER IF EXISTS trg_no_delete_dim_commune ON entrepot.dim_commune;

-- Trigger BEFORE DELETE
CREATE TRIGGER trg_no_delete_dim_commune
BEFORE DELETE ON entrepot.dim_commune
FOR EACH ROW
EXECUTE FUNCTION entrepot.no_delete_dim_commune();

-- DELETE FROM entrepot.dim_commune WHERE insee_code='69123'; --> doit échouer
-- TRUNCATE entrepot.dim_commune CASCADE; --> doit fonctionner

-- TEST 1): megabase0=# DELETE FROM entrepot.dim_commune WHERE insee_code = '69123';
--ERREUR:  Suppression interdite sur entrepot.dim_commune
--CONTEXT:  fonction PL/pgSQL entrepot.no_delete_dim_commune(), ligne 3 à RAISE
 
 --TEST 2): megabase0=# TRUNCATE entrepot.dim_commune CASCADE;
--NOTICE:  TRUNCATE cascade sur la table « fait_etablissement »
--TRUNCATE TABLE

--4.2 — Trigger de MAINTENANCE (AFTER INSERT sur pharmacie)
BEGIN;
-- Supprimer le trigger s'il existe déjà (sinon la transaction échoue)
DROP TRIGGER IF EXISTS trg_maj_fait_pharmacie ON pharmacie;

-- Supprimer la fonction si elle existe déjà
DROP FUNCTION IF EXISTS entrepot.maj_fait_pharmacie();



-- Fonction de maintenance
CREATE OR REPLACE FUNCTION entrepot.maj_fait_pharmacie()
RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
    -- Logique de maintenance ici
    INSERT INTO entrepot.fait_etablissement(insee_code, type, nb)
    VALUES (NEW.insee_code, 'pharmacie', 1)
    ON CONFLICT (insee_code, type)
    DO UPDATE SET nb = entrepot.fait_etablissement.nb + 1;

    RETURN NEW;
END;
$$;
-- Trigger AFTER INSERT sur la table de collecte "pharmacie":
CREATE TRIGGER trg_maj_fait_pharmacie
AFTER INSERT ON pharmacie
FOR EACH ROW
EXECUTE FUNCTION entrepot.maj_fait_pharmacie();

-- Vérification : lire le nb initial
--SELECT nb FROM entrepot.fait_etablissement
--WHERE insee_code = '69123' AND type = 'pharmacie';

-- Insérer une pharmacie fictive
--INSERT INTO pharmacie(insee_code, finess)
--VALUES ('69123', 'FAKE123');

-- Vérification : lire le nb après insertion
--SELECT nb FROM entrepot.fait_etablissement
--WHERE insee_code = '69123' AND type = 'pharmacie';

ROLLBACK;

-- Démonstration :
-- 1. BEGIN
-- 2. Création fonction + trigger
-- 3. Lecture du nb initial
-- 4. Insertion d'une pharmacie fictive
-- 5. Lecture du nb : +1 grâce au trigger
-- 6. ROLLBACK : tout disparaît, nb revient à sa valeur initiale

--Q1. Quand la maintenance par trigger se justifie-t-elle ?
--La maintenance par trigger est utile quand les données arrivent en flux continu et doivent être mises à jour en temps réel.
--La reconstruction suffit quand les données arrivent par campagnes de chargement (batch), car elle est plus simple et plus fiable.

--Q2. Combien faudrait-il de triggers pour maintenir l’entrepôt complet ?
--Il faudrait un trigger INSERT, UPDATE et DELETE pour chaque table de collecte et chaque typologie.
--Cela ferait des dizaines de triggers, trop complexe à maintenir, ce qui explique pourquoi la reconstruction reste la méthode principale.