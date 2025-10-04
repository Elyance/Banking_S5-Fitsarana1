-- =====================================================
-- INSERTION DES STATUTS DE COMPTE
-- =====================================================

INSERT INTO statut_compte (libelle, description) VALUES 
('ACTIF', 'Compte courant actif et opérationnel'),
('SUSPENDU', 'Compte temporairement suspendu - opérations bloquées'),
('FERME', 'Compte fermé définitivement - aucune opération possible');

-- =====================================================
-- INSERTION DES TYPES D'OPÉRATION
-- =====================================================

INSERT INTO type_operation (code, libelle, description, frais) VALUES 
('DEPOT', 'Dépôt despèces', 'Versement d argent sur le compte', 0.00),
('RETRAIT', 'Retrait despèces', 'Retrait d argent du compte', 0.00);

-- =====================================================
-- VÉRIFICATION DES DONNÉES INSÉRÉES
-- =====================================================

SELECT * FROM statut_compte ORDER BY id;
SELECT * FROM type_operation ORDER BY id;