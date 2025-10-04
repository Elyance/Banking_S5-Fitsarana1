package com.compteCourant.repository;

import com.compteCourant.entity.CompteCourant;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceContextType;
import jakarta.persistence.TypedQuery;
import java.math.BigDecimal;
import java.util.List;

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
            "SELECT c FROM CompteCourant c WHERE c.client.id = :clientId ORDER BY c.numeroCompte", 
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
            "SELECT COUNT(c) FROM CompteCourant c WHERE c.client.id = :clientId", 
            Long.class
        );
        query.setParameter("clientId", clientId);
        return query.getSingleResult();
    }
}