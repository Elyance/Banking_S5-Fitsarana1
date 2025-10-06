package com.compteCourant.repository;

import com.compteCourant.entity.CompteCourant;
import com.banque.dto.CompteStatutDTO;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceContextType;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

/**
 * Repository pour la gestion des Comptes Courants
 */
@ApplicationScoped
public class CompteCourantRepository {

    @PersistenceContext(unitName = "CompteCourantPU", type = PersistenceContextType.TRANSACTION)
    private EntityManager em;

    /**
     * Recherche un compte par son ID
     */
    public CompteCourant findById(Long id) {
        return em.find(CompteCourant.class, id);
    }

    /**
     * Récupère tous les comptes
     */
    public List<CompteCourant> findAll() {
        TypedQuery<CompteCourant> query = em.createQuery(
            "SELECT c FROM CompteCourant c ORDER BY c.numeroCompte", 
            CompteCourant.class
        );
        return query.getResultList();
    }

    /**
     * Recherche un compte par son numéro
     */
    public CompteCourant findByNumeroCompte(String numeroCompte) {
        TypedQuery<CompteCourant> query = em.createQuery(
            "SELECT c FROM CompteCourant c WHERE c.numeroCompte = :numeroCompte", 
            CompteCourant.class
        );
        query.setParameter("numeroCompte", numeroCompte);
        
        List<CompteCourant> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Recherche les comptes d'un client
     */
    public List<CompteCourant> findByClientId(Long clientId) {
        TypedQuery<CompteCourant> query = em.createQuery(
            "SELECT c FROM CompteCourant c WHERE c.clientId = :clientId ORDER BY c.numeroCompte", 
            CompteCourant.class
        );
        query.setParameter("clientId", clientId);
        return query.getResultList();
    }

    /**
     * Recherche les comptes par statut
     */
    public List<CompteCourant> findByStatut(String statutLibelle) {
        TypedQuery<CompteCourant> query = em.createQuery(
            "SELECT c FROM CompteCourant c WHERE c.statutCompte.libelle = :statut ORDER BY c.numeroCompte", 
            CompteCourant.class
        );
        query.setParameter("statut", statutLibelle);
        return query.getResultList();
    }

    /**
     * Recherche les comptes avec solde supérieur à un montant
     */
    public List<CompteCourant> findBySoldeGreaterThan(BigDecimal montant) {
        TypedQuery<CompteCourant> query = em.createQuery(
            "SELECT c FROM CompteCourant c WHERE c.solde > :montant ORDER BY c.solde DESC", 
            CompteCourant.class
        );
        query.setParameter("montant", montant);
        return query.getResultList();
    }

    /**
     * Recherche les comptes en découvert
     */
    public List<CompteCourant> findComptesEnDecouvert() {
        TypedQuery<CompteCourant> query = em.createQuery(
            "SELECT c FROM CompteCourant c WHERE c.solde < 0 ORDER BY c.solde ASC", 
            CompteCourant.class
        );
        return query.getResultList();
    }

    /**
     * Sauvegarde un compte (create ou update)
     */
    public CompteCourant save(CompteCourant compte) {
        if (compte.getId() == null) {
            em.persist(compte);
            return compte;
        } else {
            return em.merge(compte);
        }
    }

    /**
     * Supprime un compte
     */
    public void delete(CompteCourant compte) {
        if (em.contains(compte)) {
            em.remove(compte);
        } else {
            em.remove(em.merge(compte));
        }
    }

    /**
     * Supprime un compte par son ID
     */
    public boolean deleteById(Long id) {
        CompteCourant compte = findById(id);
        if (compte != null) {
            delete(compte);
            return true;
        }
        return false;
    }

    /**
     * Vérifie si un compte existe par son ID
     */
    public boolean existsById(Long id) {
        return findById(id) != null;
    }

    /**
     * Vérifie si un numéro de compte existe déjà
     */
    public boolean existsByNumeroCompte(String numeroCompte) {
        return findByNumeroCompte(numeroCompte) != null;
    }

    /**
     * Compte le nombre total de comptes
     */
    public long count() {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(c) FROM CompteCourant c", 
            Long.class
        );
        return query.getSingleResult();
    }

    /**
     * Compte le nombre de comptes d'un client
     */
    public long countByClientId(Long clientId) {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(c) FROM CompteCourant c WHERE c.clientId = :clientId", 
            Long.class
        );
        query.setParameter("clientId", clientId);
        return query.getSingleResult();
    }

    /**
     * Récupère tous les comptes avec informations client (via JOIN)
     * Retourne directement des CompteClientDTO
     */
    /**
     * Récupère tous les comptes avec leur statut actuel via JOIN
     */
    public List<CompteStatutDTO> findAllComptesAvecStatut() {
        // Requête native pour faire le JOIN avec les statuts
        String sql = """
            SELECT 
                c.id as compte_id,
                c.numero_compte,
                c.solde,
                c.client_id,
                c.date_creation,
                COALESCE(sc.id, 1) as statut_id,
                CAST(0 AS DECIMAL(15,2)) as solde_minimum,
                c.decouvert_autorise,
                COALESCE(sccm.date_mvt, c.date_creation) as date_statut
            FROM compte_courant c
            LEFT JOIN statut_compte_courant_mvt sccm ON c.id = sccm.compte_courant_id 
                AND sccm.date_mvt = (
                    SELECT MAX(sccm2.date_mvt) 
                    FROM statut_compte_courant_mvt sccm2 
                    WHERE sccm2.compte_courant_id = c.id
                )
            LEFT JOIN statut_compte sc ON sccm.statut_compte_id = sc.id
            ORDER BY c.numero_compte
            """;

        Query query = em.createNativeQuery(sql);
        @SuppressWarnings("unchecked")
        List<Object[]> resultList = (List<Object[]>) query.getResultList();
        
        List<CompteStatutDTO> comptes = new ArrayList<>();
        for (Object[] row : resultList) {
            CompteStatutDTO dto = new CompteStatutDTO();
            dto.setCompteId(((Number) row[0]).longValue());
            dto.setNumeroCompte((String) row[1]);
            dto.setSolde((BigDecimal) row[2]);
            dto.setClientId(row[3] != null ? ((Number) row[3]).longValue() : null);
            dto.setDateCreation(((java.sql.Timestamp) row[4]).toLocalDateTime());
            dto.setStatutId(((Number) row[5]).longValue());
            dto.setSoldeMinimum((BigDecimal) row[6]);
            dto.setDecouvertAutorise((BigDecimal) row[7]);
            dto.setDateStatut(row[8] != null ? ((java.sql.Timestamp) row[8]).toLocalDateTime() : null);
            
            comptes.add(dto);
        }
        
        return comptes;
    }
    
    /**
     * Vérifie si un client a des comptes courants actifs ou suspendus
     */
    public boolean clientADesComptesActifsOuSuspendus(Long clientId) {
        String sql = """
            SELECT COUNT(*)
            FROM compte_courant c
            LEFT JOIN statut_compte_courant_mvt sccm ON c.id = sccm.compte_courant_id 
                AND sccm.date_mvt = (
                    SELECT MAX(sccm2.date_mvt) 
                    FROM statut_compte_courant_mvt sccm2 
                    WHERE sccm2.compte_courant_id = c.id
                )
            LEFT JOIN statut_compte sc ON sccm.statut_compte_id = sc.id
            WHERE c.client_id = :clientId
                AND (sc.libelle IS NULL OR sc.libelle IN ('ACTIF', 'SUSPENDU'))
            """;
            
        Query query = em.createNativeQuery(sql);
        query.setParameter("clientId", clientId);
        
        Number count = (Number) query.getSingleResult();
        return count.longValue() > 0;
    }
    
    /**
     * Récupère les comptes actifs ou suspendus d'un client avec leurs statuts
     */
    public List<String> getComptesActifsOuSuspendusAvecStatuts(Long clientId) {
        String sql = """
            SELECT c.numero_compte, COALESCE(sc.libelle, 'ACTIF') as statut
            FROM compte_courant c
            LEFT JOIN statut_compte_courant_mvt sccm ON c.id = sccm.compte_courant_id 
                AND sccm.date_mvt = (
                    SELECT MAX(sccm2.date_mvt) 
                    FROM statut_compte_courant_mvt sccm2 
                    WHERE sccm2.compte_courant_id = c.id
                )
            LEFT JOIN statut_compte sc ON sccm.statut_compte_id = sc.id
            WHERE c.client_id = :clientId
                AND (sc.libelle IS NULL OR sc.libelle IN ('ACTIF', 'SUSPENDU'))
            """;
            
        Query query = em.createNativeQuery(sql);
        query.setParameter("clientId", clientId);
        
        @SuppressWarnings("unchecked")
        List<Object[]> resultList = (List<Object[]>) query.getResultList();
        
        List<String> comptes = new ArrayList<>();
        for (Object[] row : resultList) {
            String numeroCompte = (String) row[0];
            String statut = (String) row[1];
            comptes.add(numeroCompte + " (" + statut + ")");
        }
        
        return comptes;
    }
    
    /**
     * Récupère le statut actuel d'un compte courant
     */
    public String getStatutActuelCompte(Long compteId) {
        String sql = """
            SELECT COALESCE(sc.libelle, 'ACTIF') as statut
            FROM compte_courant c
            LEFT JOIN statut_compte_courant_mvt sccm ON c.id = sccm.compte_courant_id 
                AND sccm.date_mvt = (
                    SELECT MAX(sccm2.date_mvt) 
                    FROM statut_compte_courant_mvt sccm2 
                    WHERE sccm2.compte_courant_id = c.id
                )
            LEFT JOIN statut_compte sc ON sccm.statut_compte_id = sc.id
            WHERE c.id = :compteId
            """;
            
        Query query = em.createNativeQuery(sql);
        query.setParameter("compteId", compteId);
        
        try {
            return (String) query.getSingleResult();
        } catch (Exception e) {
            return "ACTIF"; // Statut par défaut si aucun statut trouvé
        }
    }
}