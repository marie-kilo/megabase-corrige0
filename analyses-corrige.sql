-- Requêtes analytiques (brief 04).

-- 1.1 Volumétrie : nombre de lignes par table
SELECT 'communes'   AS source, count(*) AS n FROM commune
UNION ALL SELECT 'lycees',     count(*) FROM lycee
UNION ALL SELECT 'colleges',   count(*) FROM college
UNION ALL SELECT 'pharmacies', count(*) FROM pharmacie
UNION ALL SELECT 'ehpad',      count(*) FROM ehpad
UNION ALL SELECT 'biblios',    count(*) FROM bibliotheque
UNION ALL SELECT 'gares',      count(*) FROM gare
ORDER BY n DESC;

-- 1.2 Nombre de communes par region
SELECT r.name AS region, count(*) AS communes
FROM commune c
JOIN departement d ON d.code_departement = c.code_departement
JOIN region r      ON r.code_region = d.code_region
GROUP BY r.name
ORDER BY communes DESC;

-- 1.3 Nombre de communes par département (avec sa region)
SELECT r.name AS region, d.name AS departement, count(*) AS communes
FROM commune c
JOIN departement d ON d.code_departement = c.code_departement
JOIN region r      ON r.code_region = d.code_region
GROUP BY r.name, d.name
ORDER BY communes DESC
LIMIT 15;

-- 1.4 Nombre d'établissements de chaque type, par département (avecpré-agregation)
SELECT d.name AS departement,
       coalesce(ly.n, 0) AS lycees,
       coalesce(co.n, 0) AS colleges,
       coalesce(ph.n, 0) AS pharmacies,
       coalesce(eh.n, 0) AS ehpad,
       coalesce(bi.n, 0) AS biblios
FROM departement d
LEFT JOIN (SELECT c.code_departement, count(*) n FROM lycee        x JOIN commune c ON c.insee_code = x.insee_code GROUP BY c.code_departement) ly ON ly.code_departement = d.code_departement
LEFT JOIN (SELECT c.code_departement, count(*) n FROM college      x JOIN commune c ON c.insee_code = x.insee_code GROUP BY c.code_departement) co ON co.code_departement = d.code_departement
LEFT JOIN (SELECT c.code_departement, count(*) n FROM pharmacie    x JOIN commune c ON c.insee_code = x.insee_code GROUP BY c.code_departement) ph ON ph.code_departement = d.code_departement
LEFT JOIN (SELECT c.code_departement, count(*) n FROM ehpad        x JOIN commune c ON c.insee_code = x.insee_code GROUP BY c.code_departement) eh ON eh.code_departement = d.code_departement
LEFT JOIN (SELECT c.code_departement, count(*) n FROM bibliotheque x JOIN commune c ON c.insee_code = x.insee_code GROUP BY c.code_departement) bi ON bi.code_departement = d.code_departement
ORDER BY pharmacies DESC
LIMIT 15;

-- 2.1 Population totale par dpt
SELECT r.name AS region, d.name AS departement, sum(c.population) AS population
FROM commune c
JOIN departement d ON d.code_departement = c.code_departement
JOIN region r      ON r.code_region = d.code_region
GROUP BY r.name, d.name
ORDER BY population DESC
LIMIT 15;


-- 2.1 Population totale avec ROLLUP (variation Théo)
SELECT r.name AS region_name, d.name AS dept_name, SUM(c.population) as total_population
FROM commune AS c
INNER JOIN departement AS d ON c.code_departement = d.code_departement
INNER JOIN region AS r ON d.code_region = r.code_region
GROUP BY ROLLUP(r.name, d.name)

-- 2.2 Classement des dpts par nombre de phamarcies (ordre décroissant)
SELECT d.name AS departement, count(p.finess) AS pharmacies
FROM pharmacie p
JOIN commune c     ON c.insee_code = p.insee_code
JOIN departement d ON d.code_departement = c.code_departement
GROUP BY d.name
ORDER BY pharmacies DESC
LIMIT 15;

-- 2.2  
SELECT
    departement,
    nombre_etablissements,
    RANK() OVER (ORDER BY nombre_etablissements DESC) AS rang
FROM (
    SELECT 
        d.name AS departement,
        COUNT(l.uai) AS nombre_etablissements
    FROM lycee l
    JOIN commune c ON l.insee_code = c.insee_code
    JOIN departement d ON c.code_departement = d.code_departement
    GROUP BY d.name
) t
ORDER BY rang;


-- 2.3 Pharmacies par région puis dpt + les sous totaux
SELECT r.name AS region, d.name AS departement, count(p.finess) AS pharmacies
FROM pharmacie p
JOIN commune c     ON c.insee_code = p.insee_code
JOIN departement d ON d.code_departement = c.code_departement
JOIN region r      ON r.code_region = d.code_region
GROUP BY ROLLUP (r.name, d.name)
ORDER BY r.name NULLS LAST, d.name NULLS FIRST;

-- 2.4 Moyenne pharmacies par commune
SELECT d.name AS departement,
       round(count(p.finess)::numeric / count(DISTINCT c.insee_code), 2) AS pharmacies_par_commune
FROM departement d
JOIN commune c        ON c.code_departement = d.code_departement
LEFT JOIN pharmacie p ON p.insee_code = c.insee_code
GROUP BY d.name
ORDER BY pharmacies_par_commune DESC
LIMIT 15;

-- 3.1 Communes avec au moins un lycée mais aucune pharmacie
SELECT c.name AS commune, c.population
FROM commune c
WHERE EXISTS     (SELECT 1 FROM lycee l     WHERE l.insee_code = c.insee_code)
  AND NOT EXISTS (SELECT 1 FROM pharmacie p WHERE p.insee_code = c.insee_code)
ORDER BY c.population DESC NULLS LAST
LIMIT 15;



-- 3.2 Profil de service par commune (ratios)

SELECT c.name AS commune,
       c.population,
       coalesce(ly.n, 0) AS lycees,
       coalesce(co.n, 0) AS colleges,
       coalesce(ph.n, 0) AS pharmacies,
       round(coalesce(ly.n, 0) * 10000.0 / nullif(c.population, 0), 2) AS lycees_10k_hab,
       round(coalesce(co.n, 0) * 10000.0 / nullif(c.population, 0), 2) AS colleges_10k_hab,
       round(coalesce(ph.n, 0) * 10000.0 / nullif(c.population, 0), 2) AS pharmacies_10k_hab
FROM commune c
LEFT JOIN (SELECT insee_code, count(*) n FROM lycee     GROUP BY insee_code) ly ON ly.insee_code = c.insee_code
LEFT JOIN (SELECT insee_code, count(*) n FROM college   GROUP BY insee_code) co ON co.insee_code = c.insee_code
LEFT JOIN (SELECT insee_code, count(*) n FROM pharmacie GROUP BY insee_code) ph ON ph.insee_code = c.insee_code
ORDER BY c.population DESC NULLS LAST
LIMIT 10;


-- 3.2 Profil de service par commune (avec des comptes cette fois-ci)
SELECT c.name AS commune,
       c.population,
       coalesce(ly.n, 0) AS lycees,
       coalesce(co.n, 0) AS colleges,
       coalesce(ph.n, 0) AS pharmacies
FROM commune c
LEFT JOIN (SELECT insee_code, count(*) n FROM lycee     GROUP BY insee_code) ly ON ly.insee_code = c.insee_code
LEFT JOIN (SELECT insee_code, count(*) n FROM college   GROUP BY insee_code) co ON co.insee_code = c.insee_code
LEFT JOIN (SELECT insee_code, count(*) n FROM pharmacie GROUP BY insee_code) ph ON ph.insee_code = c.insee_code
ORDER BY c.population DESC NULLS LAST
LIMIT 10;

