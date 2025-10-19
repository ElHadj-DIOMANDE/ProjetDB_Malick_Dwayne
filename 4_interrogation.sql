-- liste des patients triés par nom et prenom
SELECT DISTINCT nom_patient, prenom_patient, date_naissance
FROM patient
ORDER BY nom_patient, prenom_patient;

-- Patients nés entre 1970 et 1990, tri par date_naissance
SELECT id_patient, nom_patient, prenom_patient, date_naissance
FROM patient
WHERE date_naissance BETWEEN '1970-01-01' AND '1990-12-31'
ORDER BY date_naissance;

-- Patients féminins inscrits dans des essais démarrant entre deux dates
SELECT id_patient, nom_patient, prenom_patient, code_essai, date_naissance
FROM patient
WHERE sexe = 'F'
  AND code_essai IN (
    SELECT code_essai FROM essai_clinique WHERE date_debut BETWEEN DATE '2024-01-01' AND DATE '2025-12-31'
  )
ORDER BY date_naissance;

-- Employés contenant 'Chef'  sans doublons
SELECT DISTINCT nom_emp, prenom_emp, fonction_emp, service_emp
FROM Employe
WHERE fonction_emp LIKE '%Chef%'
ORDER BY service_emp, nom_emp;

-- Médicaments de marques données triés par date_AMM décroissante
SELECT num_AMM, nom_marque, date_AMM, forme_galenique
FROM medicament
WHERE nom_marque IN ('MedY','TheraX','MedZ')
ORDER BY date_AMM DESC;

-- projets avec leur molecule et budget alloué
SELECT pr.code_projet_recherche,
       pr.titre_projet,
       m.Nom_scientifique,
       ird.budget_alloué,
       ird.budget_consommé
FROM projet_recherche pr
JOIN Molecule m ON pr.code_mol = m.code_mol
LEFT JOIN investissement_R_D ird ON pr.code_projet_recherche = ird.code_projet_recherche;

-- Nombre de patients par essai supérieur à 5
SELECT p.code_essai, COUNT(*) AS nb_patients
FROM patient p
GROUP BY p.code_essai
HAVING COUNT(*) >= 5
ORDER BY nb_patients DESC;

-- Total alloué/consommé et taux de consommation par projet
SELECT pr.code_projet_recherche,
       COALESCE(SUM(ird.budget_alloué),0) AS total_alloue,
       COALESCE(SUM(ird.budget_consommé),0) AS total_consomme,
       CASE WHEN SUM(ird.budget_alloué) = 0 THEN NULL
            ELSE SUM(ird.budget_consommé) / SUM(ird.budget_alloué) END AS taux_consommation
FROM projet_recherche pr
LEFT JOIN investissement_R_D ird ON pr.code_projet_recherche = ird.code_projet_recherche
GROUP BY pr.code_projet_recherche
ORDER BY taux_consommation DESC;

-- Nombre de brevets par molécule superieur à 1
SELECT b.code_mol, COUNT(*) AS nb_brevets, MAX(b.date_dexpiration) AS derniere_expiration
FROM brevet b
GROUP BY b.code_mol
HAVING COUNT(*) > 1;

-- Ventes par pays, garder pays au-dessus de la moyenne globale
SELECT pa.nom_pays, SUM(pa.ventes) AS total_ventes
FROM pays pa
GROUP BY pa.nom_pays
HAVING SUM(pa.ventes) > (SELECT AVG(ventes) FROM pays);

-- Nombre d'employés par service (services avec >= 3 employés)
SELECT e.service_emp, COUNT(*) AS nb_employes
FROM Employe e
GROUP BY e.service_emp
HAVING COUNT(*) >= 3
ORDER BY nb_employes DESC;

-- Jointure interne simple : projet et molécule
SELECT pr.code_projet_recherche, pr.titre_projet, m.Nom_scientifique
FROM projet_recherche pr
JOIN Molecule m ON pr.code_mol = m.code_mol;

-- Left join : tous les projets et leurs investissements R&D s’ils existent
SELECT pr.code_projet_recherche, pr.titre_projet, ird.code_projet_R_D, ird.budget_alloué, ird.budget_consommé
FROM projet_recherche pr
LEFT JOIN investissement_R_D ird ON pr.code_projet_recherche = ird.code_projet_recherche;

-- Jointure multiple pour rapport production complet (medicament, lot, site)
SELECT prd.num_AMM, m.nom_marque, prd.num_lot, lp.date_peremption, prd.code_site, s.localisation
FROM production prd
JOIN medicament m ON prd.num_AMM = m.num_AMM
JOIN lot_production lp ON prd.num_lot = lp.num_lot
JOIN site_fabrication s ON prd.code_site = s.code_site;

-- Left join pour lister médicaments sans rapport réglementaire (IS NULL)
SELECT m.num_AMM, m.nom_marque, m.date_AMM
FROM medicament m
LEFT JOIN rapport_réglementaire rr ON m.num_AMM = rr.num_AMM
WHERE rr.num_AMM IS NULL
ORDER BY m.date_AMM DESC;

-- Tous les projets et partenaires associés (inclure projets sans partenaire) — LEFT JOIN via collaborer
SELECT pr.code_projet_recherche, pr.titre_projet, c.nom_partenaire, pa.type_partenaire
FROM projet_recherche pr
LEFT JOIN collaborer c ON pr.code_projet_recherche = c.code_projet_recherche
LEFT JOIN partenaire pa ON c.nom_partenaire = pa.nom_partenaire
ORDER BY pr.code_projet_recherche, c.nom_partenaire;

-- Projets sans chercheurs affectés
SELECT pr.code_projet_recherche, pr.titre_projet
FROM projet_recherche pr
WHERE NOT EXISTS (
  SELECT 1 FROM chercheur c WHERE c.code_projet_recherche = pr.code_projet_recherche
);

-- Employés qui ne collaborent avec aucun partenaire
SELECT e.Matricule, e.nom_emp, e.prenom_emp
FROM Employe e
WHERE e.Matricule NOT IN (SELECT DISTINCT c.Matricule FROM collaborer c)
ORDER BY e.nom_emp, e.prenom_emp;

-- Essais avec au moins un patient mineur
SELECT e.code_essai, e.phase_clinique, e.date_debut, e.date_fin
FROM essai_clinique e
WHERE EXISTS (
  SELECT 1 FROM patient p
  WHERE p.code_essai = e.code_essai
);

-- Médicaments dont la date_AMM est supérieure à toutes les dates_AMM d'autres marques
SELECT m.num_AMM, m.nom_marque, m.date_AMM
FROM medicament m
WHERE m.date_AMM > ALL (
  SELECT date_AMM FROM medicament m2 WHERE m2.nom_marque <> m.nom_marque
);

-- Chercheurs travaillant sur un projet ayant un budget_alloué supérieur à la moyenne
SELECT ch.id_chercheur, ch.nom_chercheur, ch.prenom_chercheur, ch.code_projet_recherche
FROM chercheur ch
WHERE ch.code_projet_recherche = ANY (
  SELECT ird.code_projet_recherche FROM investissement_R_D ird WHERE ird.budget_alloué > (SELECT AVG(budget_alloué) FROM investissement_R_D)
);

