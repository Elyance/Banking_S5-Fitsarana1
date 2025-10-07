package com.comptePret.repository;

import com.comptePret.entity.Remboursement;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.math.BigDecimal;
import java.util.List;

/**
 * Repository pour la gestion des Remboursements
 */
@ApplicationScoped
public class RemboursementRepository {

    @PersistenceContext
    private EntityManager em;

    /**
     * Trouve un remboursement par son ID
     */
    public Remboursement findById(Long id) {
        return em.find(Remboursement.class, id);
    }

    /**
     * Trouve tous les remboursements d'un compte prêt
     */
    public List<Remboursement> findByComptePretId(Long comptePretId) {
        TypedQuery<Remboursement> query = em.createQuery(
            "SELECT r FROM Remboursement r WHERE r.comptePret.id = :comptePretId ORDER BY r.dateRemboursement DESC", 
            Remboursement.class
        );
        query.setParameter("comptePretId", comptePretId);
        return query.getResultList();
    }

    /**
     * Trouve le dernier remboursement d'un compte prêt
     */
    public Remboursement findLatestByComptePretId(Long comptePretId) {
        TypedQuery<Remboursement> query = em.createQuery(
            "SELECT r FROM Remboursement r WHERE r.comptePret.id = :comptePretId ORDER BY r.dateRemboursement DESC", 
            Remboursement.class
        );
        query.setParameter("comptePretId", comptePretId);
        query.setMaxResults(1);
        
        List<Remboursement> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Calcule le total remboursé pour un compte prêt
     */
    public BigDecimal getTotalRemboursePourCompte(Long comptePretId) {
        TypedQuery<BigDecimal> query = em.createQuery(
            "SELECT COALESCE(SUM(r.montantTotalPaye), 0) FROM Remboursement r WHERE r.comptePret.id = :comptePretId", 
            BigDecimal.class
        );
        query.setParameter("comptePretId", comptePretId);
        return query.getSingleResult();
    }

    /**
     * Calcule le total du capital remboursé pour un compte prêt
     */
    public BigDecimal getTotalCapitalRemboursePourCompte(Long comptePretId) {
        TypedQuery<BigDecimal> query = em.createQuery(
            "SELECT COALESCE(SUM(r.montantCapital), 0) FROM Remboursement r WHERE r.comptePret.id = :comptePretId", 
            BigDecimal.class
        );
        query.setParameter("comptePretId", comptePretId);
        return query.getSingleResult();
    }

    /**
     * Trouve tous les remboursements
     */
    public List<Remboursement> findAll() {
        TypedQuery<Remboursement> query = em.createQuery(
            "SELECT r FROM Remboursement r ORDER BY r.dateRemboursement DESC", 
            Remboursement.class
        );
        return query.getResultList();
    }

    /**
     * Sauvegarde un remboursement (create ou update)
     */
    public Remboursement save(Remboursement remboursement) {
        if (remboursement.getId() == null) {
            em.persist(remboursement);
            return remboursement;
        } else {
            return em.merge(remboursement);
        }
    }

    /**
     * Supprime un remboursement
     */
    public void delete(Remboursement remboursement) {
        if (em.contains(remboursement)) {
            em.remove(remboursement);
        } else {
            em.remove(em.merge(remboursement));
        }
    }

    /**
     * Compte le nombre de remboursements pour un compte prêt
     */
    public long countByComptePretId(Long comptePretId) {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(r) FROM Remboursement r WHERE r.comptePret.id = :comptePretId", 
            Long.class
        );
        query.setParameter("comptePretId", comptePretId);
        return query.getSingleResult();
    }
}