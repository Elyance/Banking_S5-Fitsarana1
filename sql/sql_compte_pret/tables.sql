-- =====================================================
-- SCRIPT POSTGRESQL - GESTION DES COMPTES PRÊTS
-- Tables essentielles uniquement
-- =====================================================

CREATE DATABASE compte_pret_db;
\c compte_pret_db;

-- =====================================================
-- TABLES DE RÉFÉRENCE
-- =====================================================

-- Table des types de paiement (fréquence de remboursement)
CREATE TABLE type_paiement (
    id BIGSERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    valeur INTEGER NOT NULL CHECK (valeur > 0), -- Nombre de mois dans la période
    description TEXT
);

-- Table des statuts de compte prêt
CREATE TABLE statut_compte_pret (
    id BIGSERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- =====================================================
-- TABLE PRINCIPALE DES COMPTES PRÊTS
-- =====================================================

CREATE TABLE compte_pret (
    id BIGSERIAL PRIMARY KEY,
    numero_compte VARCHAR(30) UNIQUE NOT NULL,
    client_id BIGINT NOT NULL, -- Référence vers centralisateur (pas de FK)
    
    -- Informations du prêt
    montant_emprunte DECIMAL(15,2) NOT NULL CHECK (montant_emprunte > 0),
    solde_restant_du DECIMAL(15,2) NOT NULL CHECK (solde_restant_du >= 0),
    taux_interet DECIMAL(8,4) NOT NULL CHECK (taux_interet >= 0), -- Taux annuel en %
    duree_totale_mois INTEGER NOT NULL CHECK (duree_totale_mois > 0),
    type_paiement_id BIGINT NOT NULL REFERENCES type_paiement(id),
    
    -- Dates importantes
    date_debut DATE NOT NULL,
    date_fin_theorique DATE NOT NULL,
    date_creation TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Contraintes métier
    CHECK (solde_restant_du <= montant_emprunte),
    CHECK (date_fin_theorique > date_debut)
);

-- =====================================================
-- TABLE DES MOUVEMENTS DE STATUT
-- =====================================================

CREATE TABLE mvt_statut_compte_pret (
    id BIGSERIAL PRIMARY KEY,
    compte_pret_id BIGINT NOT NULL REFERENCES compte_pret(id) ON DELETE CASCADE,
    statut_compte_pret_id BIGINT NOT NULL REFERENCES statut_compte_pret(id),
    date_changement TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    commentaire TEXT
);

-- =====================================================
-- TABLE DES REMBOURSEMENTS (TRANSACTIONS RÉELLES)
-- =====================================================

CREATE TABLE remboursement (
    id BIGSERIAL PRIMARY KEY,
    compte_pret_id BIGINT NOT NULL REFERENCES compte_pret(id) ON DELETE CASCADE,
    
    -- Informations du remboursement
    date_remboursement TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    montant_total_paye DECIMAL(12,2) NOT NULL CHECK (montant_total_paye > 0),
    montant_capital DECIMAL(12,2) NOT NULL CHECK (montant_capital >= 0),
    montant_interet DECIMAL(12,2) NOT NULL CHECK (montant_interet >= 0),
    
    -- État après remboursement
    solde_restant_apres DECIMAL(15,2) NOT NULL CHECK (solde_restant_apres >= 0),
    
    -- Métadonnées
    reference_transaction VARCHAR(100),
    commentaire TEXT,
    
    -- Contrainte de cohérence
    CHECK (montant_total_paye = montant_capital + montant_interet)
);