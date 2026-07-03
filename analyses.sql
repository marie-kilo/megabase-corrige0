
---- 1. État des lieux (volumétrie):


----1.1 Nombre de lignes dans chaque table
    SELECT 'commune' AS table_name, COUNT(*) FROM commune
    UNION ALL SELECT 'departement', COUNT(*) FROM departement
    UNION ALL SELECT 'region', COUNT(*) FROM region
    UNION ALL SELECT 'lycee', COUNT(*) FROM lycee
    UNION ALL SELECT 'college', COUNT(*) FROM college
    UNION ALL SELECT 'pharmacie', COUNT(*) FROM pharmacie
    UNION ALL SELECT 'ehpad', COUNT(*) FROM ehpad
    UNION ALL SELECT 'bibliotheque', COUNT(*) FROM bibliotheque
    UNION ALL SELECT 'mairie', COUNT(*) FROM mairie
    UNION ALL SELECT 'entreprise_btp', COUNT(*) FROM entreprise_btp
    UNION ALL SELECT 'festivals', COUNT(*) FROM festivals
    ORDER BY table_name;
    


----- 1.2 Nombre de communes par région

    SELECT r.name AS region,
        COUNT(*) AS nb_communes
    FROM commune c
    JOIN departement d ON c.code_departement = d.code_departement
    JOIN region r ON d.code_region = r.code_region
    GROUP BY r.name
    ORDER BY nb_communes DESC;


----- 1.3 Nombre de communes par département

    SELECT d.name AS departement,
        COUNT(*) AS nb_communes
    FROM commune c
    JOIN departement d ON c.code_departement = d.code_departement
    GROUP BY d.name
    ORDER BY nb_communes DESC;


----- 1.4 le nombre d'établissements d'un type (pharmacies, lycées...) **par département**
-----(jointures:`commune -> departement -> region`, `GROUP BY`)
SELECT 
    d.name AS departement,

    COALESCE(bib.nb, 0) AS nb_bibliotheques,
    COALESCE(col.nb, 0) AS nb_colleges,
    COALESCE(ehp.nb, 0) AS nb_ehpads,
    COALESCE(btp.nb, 0) AS nb_entreprises_btp,
    COALESCE(fes.nb, 0) AS nb_festivals,
    COALESCE(lyc.nb, 0) AS nb_lycees,
    COALESCE(mai.nb, 0) AS nb_mairies,
    COALESCE(pha.nb, 0) AS nb_pharmacies

FROM departement d

LEFT JOIN (SELECT c.code_departement, COUNT(*) AS nb  FROM bibliotheque b  JOIN commune c ON b.insee_code = c.insee_code  GROUP BY c.code_departement) bib ON bib.code_departement = d.code_departement

LEFT JOIN (SELECT c.code_departement, COUNT(*) AS nb  FROM college col  JOIN commune c ON col.insee_code = c.insee_code  GROUP BY c.code_departement) col ON col.code_departement = d.code_departement

LEFT JOIN (SELECT c.code_departement, COUNT(*) AS nb  FROM ehpad e  JOIN commune c ON e.insee_code = c.insee_code  GROUP BY c.code_departement) ehp ON ehp.code_departement = d.code_departement

LEFT JOIN (SELECT c.code_departement, COUNT(*) AS nb  FROM entreprise_btp b  JOIN commune c ON b.insee_code = c.insee_code  GROUP BY c.code_departement) btp ON btp.code_departement = d.code_departement

LEFT JOIN (SELECT c.code_departement, COUNT(*) AS nb  FROM festivals f  JOIN commune c ON f.insee_code = c.insee_code  GROUP BY c.code_departement) fes ON fes.code_departement = d.code_departement

LEFT JOIN (SELECT c.code_departement, COUNT(*) AS nb  FROM lycee l  JOIN commune c ON l.insee_code = c.insee_code GROUP BY c.code_departement) lyc ON lyc.code_departement = d.code_departement

LEFT JOIN (SELECT c.code_departement, COUNT(*) AS nb  FROM mairie m  JOIN commune c ON m.insee_code = c.insee_code  GROUP BY c.code_departement) mai ON mai.code_departement = d.code_departement

LEFT JOIN (SELECT c.code_departement, COUNT(*) AS nb  FROM pharmacie p  JOIN commune c ON p.insee_code = c.insee_code  GROUP BY c.code_departement) pha ON pha.code_departement = d.code_departement

ORDER BY departement;




-- 2. AGRÉGER PAR TERRITOIRE
------------------------------------------------------------

-- 2.1 Population totale par région
SELECT r.name AS region,
       SUM(c.population) AS population_totale
FROM commune c
JOIN departement d ON c.code_departement = d.code_departement
JOIN region r ON d.code_region = r.code_region
GROUP BY r.name
ORDER BY population_totale DESC;



-- 2.2 Classement des départements par nombre de lycées
SELECT d.name AS departement,
       COUNT(*) AS nb_lycees
FROM lycee l
JOIN commune c ON l.insee_code = c.insee_code
JOIN departement d ON c.code_departement = d.code_departement
GROUP BY d.name
ORDER BY nb_lycees DESC;



-- 2.3 Moyenne d’établissements (pharmacies) par commune dans un département
SELECT d.name AS departement,
       AVG(ph.nb) AS moyenne_pharmacies_par_commune
FROM (
    SELECT c.insee_code, COUNT(*) AS nb
    FROM pharmacie p
    JOIN commune c ON p.insee_code = c.insee_code
    GROUP BY c.insee_code
) ph
JOIN commune c ON ph.insee_code = c.insee_code
JOIN departement d ON c.code_departement = d.code_departement
GROUP BY d.name
ORDER BY moyenne_pharmacies_par_commune DESC;



-- 3. CROISER LES SOURCES
------------------------------------------------------------

-- 3.1 Communes qui ont un lycée mais aucune pharmacie
SELECT c.name AS commune,
       d.name AS departement
FROM commune c
JOIN departement d ON c.code_departement = d.code_departement
LEFT JOIN lycee l ON c.insee_code = l.insee_code
LEFT JOIN pharmacie p ON c.insee_code = p.insee_code
WHERE l.uai IS NOT NULL
  AND p.finess IS NULL
ORDER BY d.name, c.name;


-- 3.2 Profil de service d’une commune (lycées, collèges, pharmacies, ehpad)
SELECT c.name AS commune,
       d.name AS departement,
       COALESCE(l.nb_lycees, 0) AS lycees,
       COALESCE(co.nb_colleges, 0) AS colleges,
       COALESCE(ph.nb_pharmacies, 0) AS pharmacies,
       COALESCE(eh.nb_ehpad, 0) AS ehpad
FROM commune c
JOIN departement d ON c.code_departement = d.code_departement

LEFT JOIN (
    SELECT insee_code, COUNT(*) AS nb_lycees
    FROM lycee GROUP BY insee_code
) l ON c.insee_code = l.insee_code

LEFT JOIN (
    SELECT insee_code, COUNT(*) AS nb_colleges
    FROM college GROUP BY insee_code
) co ON c.insee_code = co.insee_code

LEFT JOIN (
    SELECT insee_code, COUNT(*) AS nb_pharmacies
    FROM pharmacie GROUP BY insee_code
) ph ON c.insee_code = ph.insee_code

LEFT JOIN (
    SELECT insee_code, COUNT(*) AS nb_ehpad
    FROM ehpad GROUP BY insee_code
) eh ON c.insee_code = eh.insee_code

ORDER BY d.name, c.name;


----4. INDICATEURS


----4.1 Habitants par pharmacie (zones sous-dotées)

            
SELECT d.name AS departement,
       SUM(c.population) AS population_totale,
       COUNT(p.finess) AS nb_pharmacies,
       ROUND(SUM(c.population)::numeric / NULLIF(COUNT(p.finess),0), 2)
           AS habitants_par_pharmacie
FROM commune c
JOIN departement d ON c.code_departement = d.code_departement
LEFT JOIN pharmacie p ON c.insee_code = p.insee_code
GROUP BY d.name
ORDER BY habitants_par_pharmacie DESC;
      

-- 4.2 Taux d’inscription aux bibliothèques
SELECT d.name AS departement,
       SUM(b.population) AS population_totale,
       SUM(b.borrowers) AS emprunteurs,
       ROUND(SUM(b.borrowers)::numeric / NULLIF(SUM(b.population),0), 4)
           AS taux_inscription
FROM bibliotheque b
JOIN commune c ON b.insee_code = c.insee_code
JOIN departement d ON c.code_departement = d.code_departement
GROUP BY d.name
ORDER BY taux_inscription DESC;


-- 4.3 Classement des départements par densité de lycées
SELECT d.name AS departement,
       COUNT(l.uai) AS nb_lycees,
       SUM(c.population) AS population_totale,
       ROUND(COUNT(l.uai)::numeric / NULLIF(SUM(c.population),0), 6)
           AS lycees_par_habitant
FROM lycee l
JOIN commune c ON l.insee_code = c.insee_code
JOIN departement d ON c.code_departement = d.code_departement
GROUP BY d.name
ORDER BY lycees_par_habitant DESC;