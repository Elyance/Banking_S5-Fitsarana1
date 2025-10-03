-- Script d'insertion des données de base pour les statuts clients
-- Base de données: centralisateur_db

-- Insertion des statuts de base
INSERT INTO statut_client (libelle, description) VALUES 
('ACTIF', 'Client actif avec compte opérationnel'),
('NON_ACTIF', 'Client non actif - compte suspendu ou fermé');

-- Vérification des données insérées
SELECT * FROM statut_client;