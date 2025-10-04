package com.centralisateur.repository;

import com.centralisateur.entity.StatutClient;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 * Repository pour la gestion des StatutClient
 */
@ApplicationScoped
public class StatutClientRepository {

    @PersistenceContext(unitName = "CentralisateurPU")
    private EntityManager em;

    /**
     * Recherche un statut par son ID
     */
    public StatutClient findById(Long id) {
        return em.find(StatutClient.class, id);
    }

    /**
     * Récupère tous les statuts
     */
    public List<StatutClient> findAll() {
        TypedQuery<StatutClient> query = em.createQuery(
            "SELECT s FROM StatutClient s ORDER BY s.libelle", 
            StatutClient.class
        );
        return query.getResultList();
    }

    /**
     * Recherche un statut par son libellé
     */
    public StatutClient findByLibelle(String libelle) {
        TypedQuery<StatutClient> query = em.createQuery(
            "SELECT s FROM StatutClient s WHERE s.libelle = :libelle", 
            StatutClient.class
        );
        query.setParameter("libelle", libelle);
        
        List<StatutClient> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Sauvegarde un statut (create ou update)
     */
    public StatutClient save(StatutClient statut) {
        if (statut.getId() == null) {
            em.persist(statut);
            return statut;
        } else {
            return em.merge(statut);
        }
    }

    /**
     * Supprime un statut
     */
    public void delete(StatutClient statut) {
        if (em.contains(statut)) {
            em.remove(statut);
        } else {
            em.remove(em.merge(statut));
        }
    }

    /**
     * Supprime un statut par son ID
     */
    public boolean deleteById(Long id) {
        StatutClient statut = findById(id);
        if (statut != null) {
            delete(statut);
            return true;
        }
        return false;
    }

    /**
     * Vérifie si un statut existe par son ID
     */
    public boolean existsById(Long id) {
        return findById(id) != null;
    }

    /**
     * Compte le nombre total de statuts
     */
    public long count() {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(s) FROM StatutClient s", 
            Long.class
        );
        return query.getSingleResult();
    }
}