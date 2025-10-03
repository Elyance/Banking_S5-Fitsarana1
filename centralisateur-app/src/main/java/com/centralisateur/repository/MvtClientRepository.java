package com.centralisateur.repository;

import com.centralisateur.entity.MvtClient;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Repository pour la gestion des mouvements de statut client
 */
@Stateless
public class MvtClientRepository {

    @PersistenceContext(unitName = "CentralisateurPU")
    private EntityManager em;

    /**
     * Recherche un mouvement par son ID
     */
    public MvtClient findById(Long id) {
        return em.find(MvtClient.class, id);
    }

    /**
     * Récupère tous les mouvements
     */
    public List<MvtClient> findAll() {
        TypedQuery<MvtClient> query = em.createQuery(
            "SELECT m FROM MvtClient m ORDER BY m.dateMvt DESC", 
            MvtClient.class
        );
        return query.getResultList();
    }

    /**
     * Récupère tous les mouvements d'un client
     */
    public List<MvtClient> findByClientId(Long clientId) {
        TypedQuery<MvtClient> query = em.createQuery(
            "SELECT m FROM MvtClient m WHERE m.clientId = :clientId ORDER BY m.dateMvt DESC", 
            MvtClient.class
        );
        query.setParameter("clientId", clientId);
        return query.getResultList();
    }

    /**
     * Récupère le dernier mouvement d'un client (statut actuel)
     */
    public MvtClient findLastByClientId(Long clientId) {
        TypedQuery<MvtClient> query = em.createQuery(
            "SELECT m FROM MvtClient m WHERE m.clientId = :clientId ORDER BY m.dateMvt DESC", 
            MvtClient.class
        );
        query.setParameter("clientId", clientId);
        query.setMaxResults(1);
        
        List<MvtClient> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Récupère tous les mouvements pour un statut donné
     */
    public List<MvtClient> findByStatutClientId(Long statutClientId) {
        TypedQuery<MvtClient> query = em.createQuery(
            "SELECT m FROM MvtClient m WHERE m.statutClientId = :statutClientId ORDER BY m.dateMvt DESC", 
            MvtClient.class
        );
        query.setParameter("statutClientId", statutClientId);
        return query.getResultList();
    }

    /**
     * Récupère les mouvements dans une période
     */
    public List<MvtClient> findByDateMvtBetween(LocalDateTime dateDebut, LocalDateTime dateFin) {
        TypedQuery<MvtClient> query = em.createQuery(
            "SELECT m FROM MvtClient m WHERE m.dateMvt BETWEEN :dateDebut AND :dateFin ORDER BY m.dateMvt DESC", 
            MvtClient.class
        );
        query.setParameter("dateDebut", dateDebut);
        query.setParameter("dateFin", dateFin);
        return query.getResultList();
    }

    /**
     * Sauvegarde un mouvement
     */
    public MvtClient save(MvtClient mvt) {
        if (mvt.getId() == null) {
            em.persist(mvt);
            return mvt;
        } else {
            return em.merge(mvt);
        }
    }

    /**
     * Supprime un mouvement
     */
    public void delete(MvtClient mvt) {
        if (em.contains(mvt)) {
            em.remove(mvt);
        } else {
            em.remove(em.merge(mvt));
        }
    }

    /**
     * Supprime un mouvement par son ID
     */
    public boolean deleteById(Long id) {
        MvtClient mvt = findById(id);
        if (mvt != null) {
            delete(mvt);
            return true;
        }
        return false;
    }

    /**
     * Compte le nombre total de mouvements
     */
    public long count() {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(m) FROM MvtClient m", 
            Long.class
        );
        return query.getSingleResult();
    }

    /**
     * Compte le nombre de mouvements pour un client
     */
    public long countByClientId(Long clientId) {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(m) FROM MvtClient m WHERE m.clientId = :clientId", 
            Long.class
        );
        query.setParameter("clientId", clientId);
        return query.getSingleResult();
    }
}