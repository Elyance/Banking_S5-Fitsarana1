-- Script pour ajouter la colonne numeroClient à la table client
-- À exécuter sur la base de données centralisateur

-- Ajouter la colonne numeroClient
ALTER TABLE client 
ADD COLUMN numero_client VARCHAR(20) UNIQUE;

-- Ajouter un commentaire pour documenter la colonne
COMMENT ON COLUMN client.numero_client IS 'Numéro unique du client généré automatiquement (format: CLI-YYYYMMDD-XXXXX)';

-- Générer des numéros pour les clients existants (optionnel)
-- Format: CLI-YYYYMMDD-XXXXX où XXXXX est l'ID avec padding
UPDATE client 
SET numero_client = CONCAT('CLI-', DATE_FORMAT(date_creation, '%Y%m%d'), '-', LPAD(id, 5, '0'))
WHERE numero_client IS NULL;

-- Créer un index sur numero_client pour optimiser les recherches
CREATE INDEX idx_client_numero_client ON client(numero_client);

-- Vérifier les résultats
SELECT id, nom, prenom, numero_client, date_creation 
FROM client 
ORDER BY id;