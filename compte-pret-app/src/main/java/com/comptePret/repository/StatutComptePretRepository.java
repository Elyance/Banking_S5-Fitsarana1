package com.comptePret.repository;

import com.comptePret.entity.StatutComptePret;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 * Repository pour la gestion des Statuts de Compte Prêt
 */
@ApplicationScoped
public class StatutComptePretRepository {

    @PersistenceContext
    private EntityManager em;

    /**
     * Trouve un statut par son ID
     */
    public StatutComptePret findById(Long id) {
        return em.find(StatutComptePret.class, id);
    }

    /**
     * Trouve un statut par son libellé
     */
    public StatutComptePret findByLibelle(String libelle) {
        TypedQuery<StatutComptePret> query = em.createQuery(
            "SELECT s FROM StatutComptePret s WHERE s.libelle = :libelle", 
            StatutComptePret.class
        );
        query.setParameter("libelle", libelle);
        
        List<StatutComptePret> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Trouve un statut par son libellé (ignore la casse)
     */
    public StatutComptePret findByLibelleIgnoreCase(String libelle) {
        TypedQuery<StatutComptePret> query = em.createQuery(
            "SELECT s FROM StatutComptePret s WHERE LOWER(s.libelle) = LOWER(:libelle)", 
            StatutComptePret.class
        );
        query.setParameter("libelle", libelle);
        
        List<StatutComptePret> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Trouve tous les statuts
     */
    public List<StatutComptePret> findAll() {
        TypedQuery<StatutComptePret> query = em.createQuery(
            "SELECT s FROM StatutComptePret s ORDER BY s.libelle", 
            StatutComptePret.class
        );
        return query.getResultList();
    }

    /**
     * Sauvegarde un statut (create ou update)
     */
    public StatutComptePret save(StatutComptePret statutComptePret) {
        if (statutComptePret.getId() == null) {
            em.persist(statutComptePret);
            return statutComptePret;
        } else {
            return em.merge(statutComptePret);
        }
    }

    /**
     * Supprime un statut
     */
    public void delete(StatutComptePret statutComptePret) {
        if (em.contains(statutComptePret)) {
            em.remove(statutComptePret);
        } else {
            em.remove(em.merge(statutComptePret));
        }
    }
}