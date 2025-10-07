package com.comptePret.repository;

import com.comptePret.entity.ComptePret;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 * Repository pour la gestion des Comptes Prêts
 */
@ApplicationScoped
public class ComptePretRepository {

    @PersistenceContext
    private EntityManager em;

    /**
     * Trouve un compte prêt par son ID
     */
    public ComptePret findById(Long id) {
        return em.find(ComptePret.class, id);
    }

    /**
     * Trouve un compte prêt par son numéro de compte
     */
    public ComptePret findByNumeroCompte(String numeroCompte) {
        TypedQuery<ComptePret> query = em.createQuery(
            "SELECT cp FROM ComptePret cp WHERE cp.numeroCompte = :numeroCompte", 
            ComptePret.class
        );
        query.setParameter("numeroCompte", numeroCompte);
        
        List<ComptePret> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Trouve tous les comptes prêts d'un client
     */
    public List<ComptePret> findByClientId(Long clientId) {
        TypedQuery<ComptePret> query = em.createQuery(
            "SELECT cp FROM ComptePret cp WHERE cp.clientId = :clientId ORDER BY cp.dateCreation DESC", 
            ComptePret.class
        );
        query.setParameter("clientId", clientId);
        return query.getResultList();
    }

    /**
     * Trouve tous les comptes prêts
     */
    public List<ComptePret> findAll() {
        TypedQuery<ComptePret> query = em.createQuery(
            "SELECT cp FROM ComptePret cp ORDER BY cp.dateCreation DESC", 
            ComptePret.class
        );
        return query.getResultList();
    }

    /**
     * Sauvegarde un compte prêt (create ou update)
     */
    public ComptePret save(ComptePret comptePret) {
        if (comptePret.getId() == null) {
            em.persist(comptePret);
            return comptePret;
        } else {
            return em.merge(comptePret);
        }
    }

    /**
     * Supprime un compte prêt
     */
    public void delete(ComptePret comptePret) {
        if (em.contains(comptePret)) {
            em.remove(comptePret);
        } else {
            em.remove(em.merge(comptePret));
        }
    }

    /**
     * Supprime un compte prêt par ID
     */
    public void deleteById(Long id) {
        ComptePret comptePret = findById(id);
        if (comptePret != null) {
            delete(comptePret);
        }
    }

    /**
     * Vérifie si un numéro de compte existe déjà
     */
    public boolean existsByNumeroCompte(String numeroCompte) {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(cp) FROM ComptePret cp WHERE cp.numeroCompte = :numeroCompte", 
            Long.class
        );
        query.setParameter("numeroCompte", numeroCompte);
        return query.getSingleResult() > 0;
    }

    /**
     * Compte le nombre de comptes prêts d'un client
     */
    public long countByClientId(Long clientId) {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(cp) FROM ComptePret cp WHERE cp.clientId = :clientId", 
            Long.class
        );
        query.setParameter("clientId", clientId);
        return query.getSingleResult();
    }
}