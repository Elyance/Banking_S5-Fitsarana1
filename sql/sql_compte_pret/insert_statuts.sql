-- Script pour insérer les statuts de compte prêt avec les IDs spécifiés
-- ACTIF: 1, SUSPENDU: 2, FERMÉ: 3

-- Supprimer les statuts existants pour éviter les conflits
DELETE FROM statut_compte_pret;

-- Insérer les statuts avec les IDs spécifiés
INSERT INTO statut_compte_pret (id, libelle, description) VALUES 
(1, 'ACTIF', 'Compte prêt actif'),
(2, 'SUSPENDU', 'Compte prêt suspendu'),
(3, 'FERMÉ', 'Compte prêt fermé');

-- Réinitialiser la séquence pour éviter les conflits futurs
SELECT setval('statut_compte_pret_id_seq', 3, true);