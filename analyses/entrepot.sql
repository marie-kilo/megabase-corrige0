
-- ENTREPOT EN ÉTOILE (Brief 07)
-- Grain : une ligne de fait = nb d’établissements d’un type dans une commune
-- ============================================================

CREATE SCHEMA IF NOT EXISTS entrepot;

-- ------------------------------------------------------------
-- DIMENSION COMMUNE
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS entrepot.dim_commune (
    insee_code  TEXT PRIMARY KEY,
    commune     TEXT,
    departement TEXT,
    region      TEXT,
    population  INTEGER
);

-- ------------------------------------------------------------
-- DIMENSION TYPE
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS entrepot.dim_type (
    type    TEXT PRIMARY KEY,
    libelle TEXT
);

-- ------------------------------------------------------------
-- TABLE DE FAITS
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS entrepot.fait_etablissement (
    insee_code TEXT REFERENCES entrepot.dim_commune(insee_code),
    type       TEXT REFERENCES entrepot.dim_type(type),
    nb         INTEGER
);

-- ------------------------------------------------------------
-- RECONSTRUCTION (TRUNCATE)
-- ------------------------------------------------------------

TRUNCATE entrepot.fait_etablissement;

TRUNCATE entrepot.dim_commune CASCADE;
TRUNCATE entrepot.dim_type CASCADE;

-- ------------------------------------------------------------
-- ALIMENTATION DIM_COMMUNE
-- ------------------------------------------------------------
INSERT INTO entrepot.dim_commune (insee_code, commune, departement, region, population)
SELECT
    c.insee_code,
    c.name AS commune,
    d.name AS departement,
    r.name AS region,
    c.population
FROM commune c
JOIN departement d ON d.code_departement = c.code_departement
JOIN region r ON r.code_region = d.code_region;

-- ------------------------------------------------------------
-- ALIMENTATION DIM_TYPE
-- ------------------------------------------------------------
INSERT INTO entrepot.dim_type (type, libelle) VALUES
    ('lycee',         'Lycée'),
    ('college',       'Collège'),
    ('pharmacie',     'Pharmacie'),
    ('ehpad',         'EHPAD'),
    ('bibliotheque',  'Bibliothèque'),
    ('entreprise_btp','Entreprise BTP'),
    ('festivals',     'Festival');

-- ------------------------------------------------------------
-- ALIMENTATION FAIT_ETABLISSEMENT
-- ------------------------------------------------------------
INSERT INTO entrepot.fait_etablissement (insee_code, type, nb)
SELECT insee_code, 'lycee', COUNT(*) FROM lycee GROUP BY insee_code
UNION ALL
SELECT insee_code, 'college', COUNT(*) FROM college GROUP BY insee_code
UNION ALL
SELECT insee_code, 'pharmacie', COUNT(*) FROM pharmacie GROUP BY insee_code
UNION ALL
SELECT insee_code, 'ehpad', COUNT(*) FROM ehpad GROUP BY insee_code
UNION ALL
SELECT insee_code, 'bibliotheque', COUNT(*) FROM bibliotheque GROUP BY insee_code
UNION ALL
SELECT insee_code, 'entreprise_btp', COUNT(*) FROM entreprise_btp GROUP BY insee_code
UNION ALL
SELECT insee_code, 'festivals', COUNT(*) FROM festivals GROUP BY insee_code;
