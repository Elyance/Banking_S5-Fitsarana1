package com.comptePret.repository;

import com.comptePret.entity.MvtStatutComptePret;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 * Repository pour la gestion des Mouvements de Statut de Compte Prêt
 */
@ApplicationScoped
public class MvtStatutComptePretRepository {

    @PersistenceContext
    private EntityManager em;

    /**
     * Trouve un mouvement par son ID
     */
    public MvtStatutComptePret findById(Long id) {
        return em.find(MvtStatutComptePret.class, id);
    }

    /**
     * Trouve tous les mouvements d'un compte prêt
     */
    public List<MvtStatutComptePret> findByComptePretId(Long comptePretId) {
        TypedQuery<MvtStatutComptePret> query = em.createQuery(
            "SELECT m FROM MvtStatutComptePret m WHERE m.comptePret.id = :comptePretId ORDER BY m.dateChangement DESC", 
            MvtStatutComptePret.class
        );
        query.setParameter("comptePretId", comptePretId);
        return query.getResultList();
    }

    /**
     * Trouve le mouvement de statut le plus récent d'un compte prêt
     */
    public MvtStatutComptePret findLatestByComptePretId(Long comptePretId) {
        TypedQuery<MvtStatutComptePret> query = em.createQuery(
            "SELECT m FROM MvtStatutComptePret m WHERE m.comptePret.id = :comptePretId ORDER BY m.dateChangement DESC", 
            MvtStatutComptePret.class
        );
        query.setParameter("comptePretId", comptePretId);
        query.setMaxResults(1);
        
        List<MvtStatutComptePret> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Trouve tous les mouvements
     */
    public List<MvtStatutComptePret> findAll() {
        TypedQuery<MvtStatutComptePret> query = em.createQuery(
            "SELECT m FROM MvtStatutComptePret m ORDER BY m.dateChangement DESC", 
            MvtStatutComptePret.class
        );
        return query.getResultList();
    }

    /**
     * Sauvegarde un mouvement (create ou update)
     */
    public MvtStatutComptePret save(MvtStatutComptePret mvtStatutComptePret) {
        if (mvtStatutComptePret.getId() == null) {
            em.persist(mvtStatutComptePret);
            return mvtStatutComptePret;
        } else {
            return em.merge(mvtStatutComptePret);
        }
    }

    /**
     * Supprime un mouvement
     */
    public void delete(MvtStatutComptePret mvtStatutComptePret) {
        if (em.contains(mvtStatutComptePret)) {
            em.remove(mvtStatutComptePret);
        } else {
            em.remove(em.merge(mvtStatutComptePret));
        }
    }
}