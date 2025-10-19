CREATE TABLE Employe(
   Matricule INT,
   nom_emp VARCHAR(50),
   prenom_emp VARCHAR(50),
   fonction_emp VARCHAR(50),
   service_emp VARCHAR(50),
   Matricule_supervise INT NOT NULL,
   PRIMARY KEY(Matricule),
   FOREIGN KEY(Matricule_supervise) REFERENCES Employe(Matricule)
);

CREATE TABLE Molecule(
   code_mol INT,
   Nom_scientifique VARCHAR(50),
   nom_commercial VARCHAR(50),
   PRIMARY KEY(code_mol)
);

CREATE TABLE projet_recherche(
   code_projet_recherche INT,
   titre_projet VARCHAR(50),
   responsable VARCHAR(50),
   code_mol INT NOT NULL,
   PRIMARY KEY(code_projet_recherche),
   FOREIGN KEY(code_mol) REFERENCES Molecule(code_mol)
);

CREATE TABLE chercheur(
   id_chercheur INT,
   nom_chercheur VARCHAR(50),
   prenom_chercheur VARCHAR(50),
   code_projet_recherche INT NOT NULL,
   PRIMARY KEY(id_chercheur),
   FOREIGN KEY(code_projet_recherche) REFERENCES projet_recherche(code_projet_recherche)
);

CREATE TABLE partenaire(
   nom_partenaire VARCHAR(50),
   type_partenaire VARCHAR(50),
   duree_partenariat VARCHAR(50),
   PRIMARY KEY(nom_partenaire)
);

CREATE TABLE essai_clinique(
   code_essai INT,
   phase_clinique INT,
   date_debut DATE,
   date_fin DATE,
   code_projet_recherche INT NOT NULL,
   PRIMARY KEY(code_essai),
   FOREIGN KEY(code_projet_recherche) REFERENCES projet_recherche(code_projet_recherche)
);

CREATE TABLE patient(
   id_patient INT,
   date_naissance DATE,
   sexe VARCHAR(1),
   nom_patient VARCHAR(50),
   prenom_patient VARCHAR(50),
   code_essai INT NOT NULL,
   PRIMARY KEY(id_patient),
   FOREIGN KEY(code_essai) REFERENCES essai_clinique(code_essai)
);

CREATE TABLE medecin_investigateur(
   id_medecin INT,
   nom_medecin VARCHAR(50),
   centre_hospitalier VARCHAR(50),
   id_patient INT NOT NULL,
   PRIMARY KEY(id_medecin),
   FOREIGN KEY(id_patient) REFERENCES patient(id_patient)
);

CREATE TABLE medicament(
   num_AMM INT,
   date_AMM DATE,
   nom_marque VARCHAR(50),
   forme_galenique VARCHAR(50),
   PRIMARY KEY(num_AMM)
);

CREATE TABLE lot_production(
   num_lot INT,
   date_fabrication DATE,
   date_peremption DATE,
   PRIMARY KEY(num_lot)
);

CREATE TABLE site_fabrication(
   code_site INT,
   localisation VARCHAR(50),
   PRIMARY KEY(code_site)
);

CREATE TABLE pays(
   nom_pays VARCHAR(50),
   ventes INT,
   PRIMARY KEY(nom_pays)
);

CREATE TABLE rapport_scientifique(
   code_rapport_scient INT,
   date_rapport_scient DATE,
   resultats_essai VARCHAR(50),
   code_essai INT NOT NULL,
   PRIMARY KEY(code_rapport_scient),
   FOREIGN KEY(code_essai) REFERENCES essai_clinique(code_essai)
);

CREATE TABLE investissement_R_D(
   code_projet_recherche INT,
   code_projet_R_D VARCHAR(50),
   budget_alloué DECIMAL(15,2),
   budget_consommé DECIMAL(15,2),
   PRIMARY KEY(code_projet_recherche, code_projet_R_D),
   FOREIGN KEY(code_projet_recherche) REFERENCES projet_recherche(code_projet_recherche)
);

CREATE TABLE rapport_réglementaire(
   num_AMM INT,
   code_rapport_regle INT,
   date_rapport_regle DATE,
   PRIMARY KEY(num_AMM, code_rapport_regle),
   FOREIGN KEY(num_AMM) REFERENCES medicament(num_AMM)
);

CREATE TABLE brevet(
   num_brevet INT,
   date_de_depot DATE,
   date_dexpiration DATE,
   num_AMM INT NOT NULL,
   code_mol INT NOT NULL,
   PRIMARY KEY(num_brevet),
   FOREIGN KEY(num_AMM) REFERENCES medicament(num_AMM),
   FOREIGN KEY(code_mol) REFERENCES Molecule(code_mol)
);

CREATE TABLE collaborer(
   Matricule INT,
   code_projet_recherche INT,
   nom_partenaire VARCHAR(50),
   PRIMARY KEY(Matricule, code_projet_recherche, nom_partenaire),
   FOREIGN KEY(Matricule) REFERENCES Employe(Matricule),
   FOREIGN KEY(code_projet_recherche) REFERENCES projet_recherche(code_projet_recherche),
   FOREIGN KEY(nom_partenaire) REFERENCES partenaire(nom_partenaire)
);

CREATE TABLE production(
   num_AMM INT,
   num_lot INT,
   code_site INT,
   PRIMARY KEY(num_AMM, num_lot, code_site),
   FOREIGN KEY(num_AMM) REFERENCES medicament(num_AMM),
   FOREIGN KEY(num_lot) REFERENCES lot_production(num_lot),
   FOREIGN KEY(code_site) REFERENCES site_fabrication(code_site)
);

CREATE TABLE est_distribué(
   num_AMM INT,
   nom_pays VARCHAR(50),
   PRIMARY KEY(num_AMM, nom_pays),
   FOREIGN KEY(num_AMM) REFERENCES medicament(num_AMM),
   FOREIGN KEY(nom_pays) REFERENCES pays(nom_pays)
);
