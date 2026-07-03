-- ANALYSES SUR L'ENTREPOT EN ÉTOILE (Brief 07)
-- ============================================================
-- Rappel : l'entrepôt contient :
--   - entrepot.dim_commune (géographie à plat)
--   - entrepot.dim_type (liste des types)
--   - entrepot.fait_etablissement (nb d'établissements par commune × type)
-- Toutes les requêtes ci-dessous sont plus courtes que celles du Brief 04
-- car la pré-agrégation est déjà faite dans fait_etablissement.

---------------------------------------------------------------
-- 1) Classement des départements par nombre de pharmacies
---------------------------------------------------------------
-- Version Brief 04 : ~8 lignes, 1 sous-requête, 1 LEFT JOIN
-- Version Étoile   : 3 lignes, aucune sous-requête

SELECT d.departement, SUM(f.nb) AS pharmacies
FROM entrepot.fait_etablissement f
JOIN entrepot.dim_commune d ON d.insee_code = f.insee_code
WHERE f.type = 'pharmacie'
GROUP BY d.departement
ORDER BY pharmacies DESC;


---------------------------------------------------------------
-- 2) Population par région et par département
---------------------------------------------------------------
-- Version Brief 04 : ~6 lignes, jointures commune → departement → region
-- Version Étoile   : 3 lignes, géographie à plat

SELECT region, departement, SUM(population) AS population_totale
FROM entrepot.dim_commune
GROUP BY region, departement
ORDER BY region, population_totale DESC;


---------------------------------------------------------------
-- 3) Nombre d'établissements par type et par département
---------------------------------------------------------------
-- Version Brief 04 : 14 lignes, 5 sous-requêtes, 5 LEFT JOIN
-- Version Étoile   : 4 lignes, aucune sous-requête

SELECT d.departement, f.type, SUM(f.nb) AS n
FROM entrepot.fait_etablissement f
JOIN entrepot.dim_commune d ON d.insee_code = f.insee_code
GROUP BY d.departement, f.type
ORDER BY d.departement, n DESC;
