--Brief 09:

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
CREATE TABLE emp (
    nom_employe          text,
    salaire              integer,
    date_dermodif        timestamp,
    utilisateur_dermodif text
);

CREATE TABLE emp (
    nom_employe          text,
    salaire              integer,
    date_dermodif        timestamp,
    utilisateur_dermodif text
);

CREATE FUNCTION emp_stamp() RETURNS trigger AS $emp_stamp$
    BEGIN
        -- Verifie que nom_employe et salary sont donnés
        IF NEW.nom_employe IS NULL THEN
            RAISE EXCEPTION 'nom_employe ne peut pas être NULL';
        END IF;
        IF NEW.salaire IS NULL THEN
            RAISE EXCEPTION '% ne peut pas avoir un salaire', NEW.nom_employe;
        END IF;

        -- Qui travaille pour nous si la personne doit payer pour cela ?
        IF NEW.salaire < 0 THEN
            RAISE EXCEPTION '% ne peut pas avoir un salaire négatif', NEW.nom_employe;
        END IF;

        -- Rappelons-nous qui a changé le salaire et quand
        NEW.date_dermodif := current_timestamp;
        NEW.utilisateur_dermodif := current_user;
        RETURN NEW;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER emp_stamp BEFORE INSERT OR UPDATE ON emp
    FOR EACH ROW EXECUTE FUNCTION emp_stamp();