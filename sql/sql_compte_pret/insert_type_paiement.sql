-- =====================================================
-- DONNÉES DE RÉFÉRENCE - TYPES DE PAIEMENT
-- Gestion des fréquences de remboursement pour les prêts
-- =====================================================

-- Suppression des données existantes (pour réinitialisation)
DELETE FROM type_paiement;

-- Réinitialisation de la séquence
ALTER SEQUENCE type_paiement_id_seq RESTART WITH 1;

-- =====================================================
-- INSERTION DES TYPES DE PAIEMENT
-- =====================================================

INSERT INTO type_paiement (libelle, valeur, description) VALUES
-- Paiements fréquents
('Mensuel', 1, 'Remboursement tous les mois (12 fois par an)'),
('Bimensuel', 2, 'Remboursement tous les deux mois (6 fois par an)'),
('Trimestriel', 3, 'Remboursement tous les trois mois (4 fois par an)'),
('Quadrimestriel', 4, 'Remboursement tous les quatre mois (3 fois par an)'),
('Semestriel', 6, 'Remboursement tous les six mois (2 fois par an)'),
('Annuel', 12, 'Remboursement une fois par an');

-- =====================================================
-- VÉRIFICATION DES DONNÉES
-- =====================================================

-- Affichage des types de paiement créés
SELECT 
    id,
    libelle,
    valeur as "Fréquence (mois)",
    description
FROM type_paiement 
ORDER BY valeur, libelle;

-- Statistiques
SELECT 
    COUNT(*) as "Nombre de types de paiement",
    MIN(valeur) as "Fréquence min (mois)",
    MAX(valeur) as "Fréquence max (mois)"
FROM type_paiement;

COMMIT;