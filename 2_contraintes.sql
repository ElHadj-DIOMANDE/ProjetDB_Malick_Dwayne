ALTER TABLE Employe
  ADD CONSTRAINT chk_employe_supervise CHECK (Matricule <> Matricule_supervise);

ALTER TABLE projet_recherche
  ADD CONSTRAINT chk_titre_projet CHECK (trim(titre_projet) <> '');

ALTER TABLE chercheur
  ADD CONSTRAINT chk_nom_chercheur CHECK (trim(nom_chercheur) <> '');

ALTER TABLE partenaire
  ADD CONSTRAINT chk_type_partenaire CHECK (type_partenaire IN ('Université','Entreprise','ONG','Autre'));

ALTER TABLE essai_clinique
  ADD CONSTRAINT chk_phase CHECK (phase_clinique BETWEEN 1 AND 4),
  ADD CONSTRAINT chk_dates_essai CHECK (date_debut < date_fin);

ALTER TABLE patient
  ADD CONSTRAINT chk_sexe CHECK (sexe IN ('M','F','O'));

ALTER TABLE lot_production
  ADD CONSTRAINT chk_lot_dates CHECK (date_peremption > date_fabrication);

ALTER TABLE pays
  ADD CONSTRAINT chk_ventes CHECK (ventes >= 0);

ALTER TABLE investissement_R_D
  ADD CONSTRAINT chk_budget_nonneg CHECK (budget_alloué >= 0 AND budget_consommé >= 0),
  ADD CONSTRAINT chk_budget_consomme CHECK (budget_consommé <= budget_alloué);

ALTER TABLE brevet
  ADD CONSTRAINT chk_brevet_dates CHECK (date_de_depot < date_dexpiration);

ALTER TABLE employe MODIFY Matricule_supervise INT;