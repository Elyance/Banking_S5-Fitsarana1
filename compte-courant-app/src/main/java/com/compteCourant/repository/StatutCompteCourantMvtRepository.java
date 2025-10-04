package com.compteCourant.repository;

import com.compteCourant.entity.StatutCompteCourantMvt;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceContextType;
import jakarta.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Repository pour la gestion des Mouvements de Statut de Compte Courant
 */
@ApplicationScoped
public class StatutCompteCourantMvtRepository {

    @PersistenceContext(unitName = "CompteCourantPU", type = PersistenceContextType.TRANSACTION)
    private EntityManager em;

    /**
     * Recherche un mouvement de statut par son ID
     */
    public StatutCompteCourantMvt findById(Long id) {
        return em.find(StatutCompteCourantMvt.class, id);
    }

    /**
     * Récupère tous les mouvements de statut
     */
    public List<StatutCompteCourantMvt> findAll() {
        TypedQuery<StatutCompteCourantMvt> query = em.createQuery(
            "SELECT m FROM StatutCompteCourantMvt m ORDER BY m.dateMvt DESC", 
            StatutCompteCourantMvt.class
        );
        return query.getResultList();
    }

    /**
     * Recherche les mouvements de statut d'un compte courant
     */
    public List<StatutCompteCourantMvt> findByCompteCourantId(Long compteCourantId) {
        TypedQuery<StatutCompteCourantMvt> query = em.createQuery(
            "SELECT m FROM StatutCompteCourantMvt m WHERE m.compteCourantId = :compteCourantId ORDER BY m.dateMvt DESC", 
            StatutCompteCourantMvt.class
        );
        query.setParameter("compteCourantId", compteCourantId);
        return query.getResultList();
    }

    /**
     * Recherche les mouvements de statut d'un compte courant avec pagination
     */
    public List<StatutCompteCourantMvt> findByCompteCourantId(Long compteCourantId, int offset, int limit) {
        TypedQuery<StatutCompteCourantMvt> query = em.createQuery(
            "SELECT m FROM StatutCompteCourantMvt m WHERE m.compteCourantId = :compteCourantId ORDER BY m.dateMvt DESC", 
            StatutCompteCourantMvt.class
        );
        query.setParameter("compteCourantId", compteCourantId);
        query.setFirstResult(offset);
        query.setMaxResults(limit);
        return query.getResultList();
    }

    /**
     * Trouve le dernier mouvement de statut d'un compte
     */
    public StatutCompteCourantMvt findLatestByCompteCourantId(Long compteCourantId) {
        TypedQuery<StatutCompteCourantMvt> query = em.createQuery(
            "SELECT m FROM StatutCompteCourantMvt m WHERE m.compteCourantId = :compteCourantId ORDER BY m.dateMvt DESC", 
            StatutCompteCourantMvt.class
        );
        query.setParameter("compteCourantId", compteCourantId);
        query.setMaxResults(1);
        
        List<StatutCompteCourantMvt> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Trouve le premier mouvement de statut d'un compte
     */
    public StatutCompteCourantMvt findFirstByCompteCourantId(Long compteCourantId) {
        TypedQuery<StatutCompteCourantMvt> query = em.createQuery(
            "SELECT m FROM StatutCompteCourantMvt m WHERE m.compteCourantId = :compteCourantId ORDER BY m.dateMvt ASC", 
            StatutCompteCourantMvt.class
        );
        query.setParameter("compteCourantId", compteCourantId);
        query.setMaxResults(1);
        
        List<StatutCompteCourantMvt> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Recherche les mouvements les plus récents
     */
    public List<StatutCompteCourantMvt> findMostRecent(int limit) {
        TypedQuery<StatutCompteCourantMvt> query = em.createQuery(
            "SELECT m FROM StatutCompteCourantMvt m ORDER BY m.dateMvt DESC", 
            StatutCompteCourantMvt.class
        );
        query.setMaxResults(limit);
        return query.getResultList();
    }

    /**
     * Recherche les comptes ayant changé de statut vers un statut spécifique
     */
    public List<StatutCompteCourantMvt> findComptesChangedToStatut(Long statutCompteId) {
        TypedQuery<StatutCompteCourantMvt> query = em.createQuery(
            "SELECT m FROM StatutCompteCourantMvt m WHERE m.statutCompteId = :statutId ORDER BY m.dateMvt DESC", 
            StatutCompteCourantMvt.class
        );
        query.setParameter("statutId", statutCompteId);
        return query.getResultList();
    }

    /**
     * Recherche les comptes ayant changé de statut vers un statut spécifique dans une période
     */
    public List<StatutCompteCourantMvt> findComptesChangedToStatutBetween(Long statutCompteId, LocalDateTime dateDebut, LocalDateTime dateFin) {
        TypedQuery<StatutCompteCourantMvt> query = em.createQuery(
            "SELECT m FROM StatutCompteCourantMvt m WHERE m.statutCompteId = :statutId " +
            "AND m.dateMvt BETWEEN :dateDebut AND :dateFin ORDER BY m.dateMvt DESC", 
            StatutCompteCourantMvt.class
        );
        query.setParameter("statutId", statutCompteId);
        query.setParameter("dateDebut", dateDebut);
        query.setParameter("dateFin", dateFin);
        return query.getResultList();
    }

    /**
     * Recherche l'historique complet des statuts d'un compte avec les détails
     */
    public List<Object[]> findStatutHistoryWithDetails(Long compteCourantId) {
        TypedQuery<Object[]> query = em.createQuery(
            "SELECT m, s.libelle, s.description FROM StatutCompteCourantMvt m " +
            "JOIN m.statutCompte s WHERE m.compteCourantId = :compteCourantId ORDER BY m.dateMvt DESC", 
            Object[].class
        );
        query.setParameter("compteCourantId", compteCourantId);
        return query.getResultList();
    }

    /**
     * Sauvegarde un mouvement de statut (create ou update)
     */
    public StatutCompteCourantMvt save(StatutCompteCourantMvt mouvement) {
        if (mouvement.getId() == null) {
            em.persist(mouvement);
            return mouvement;
        } else {
            return em.merge(mouvement);
        }
    }

    /**
     * Supprime un mouvement de statut
     */
    public void delete(StatutCompteCourantMvt mouvement) {
        if (em.contains(mouvement)) {
            em.remove(mouvement);
        } else {
            em.remove(em.merge(mouvement));
        }
    }

    /**
     * Supprime un mouvement de statut par son ID
     */
    public boolean deleteById(Long id) {
        StatutCompteCourantMvt mouvement = findById(id);
        if (mouvement != null) {
            delete(mouvement);
            return true;
        }
        return false;
    }

}