package com.compteCourant.repository;

import com.compteCourant.entity.StatutCompte;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceContextType;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 * Repository pour la gestion des Statuts de Compte
 */
@ApplicationScoped
public class StatutCompteRepository {

    @PersistenceContext(unitName = "CompteCourantPU", type = PersistenceContextType.TRANSACTION)
    private EntityManager em;

    /**
     * Recherche un statut de compte par son ID
     */
    public StatutCompte findById(Long id) {
        return em.find(StatutCompte.class, id);
    }

    /**
     * Récupère tous les statuts de compte
     */
    public List<StatutCompte> findAll() {
        TypedQuery<StatutCompte> query = em.createQuery(
            "SELECT s FROM StatutCompte s ORDER BY s.libelle", 
            StatutCompte.class
        );
        return query.getResultList();
    }

    /**
     * Recherche un statut de compte par son libellé
     */
    public StatutCompte findByLibelle(String libelle) {
        TypedQuery<StatutCompte> query = em.createQuery(
            "SELECT s FROM StatutCompte s WHERE s.libelle = :libelle", 
            StatutCompte.class
        );
        query.setParameter("libelle", libelle);
        
        List<StatutCompte> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Recherche des statuts de compte par libellé (recherche partielle)
     */
    public List<StatutCompte> findByLibelleContaining(String libelle) {
        TypedQuery<StatutCompte> query = em.createQuery(
            "SELECT s FROM StatutCompte s WHERE LOWER(s.libelle) LIKE LOWER(:libelle) ORDER BY s.libelle", 
            StatutCompte.class
        );
        query.setParameter("libelle", "%" + libelle + "%");
        return query.getResultList();
    }

    public StatutCompte findByLibelleIgnoreCase(String libelle) {
        TypedQuery<StatutCompte> query = em.createQuery(
            "SELECT s FROM StatutCompte s WHERE LOWER(s.libelle) = LOWER(:libelle)", 
            StatutCompte.class
        );
        query.setParameter("libelle", libelle);
        
        List<StatutCompte> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Sauvegarde un statut de compte (create ou update)
     */
    public StatutCompte save(StatutCompte statutCompte) {
        if (statutCompte.getId() == null) {
            em.persist(statutCompte);
            return statutCompte;
        } else {
            return em.merge(statutCompte);
        }
    }

    /**
     * Vérifie si un statut de compte existe par son ID
     */
    public boolean existsById(Long id) {
        return findById(id) != null;
    }

    /**
     * Vérifie si un libellé de statut existe déjà
     */
    public boolean existsByLibelle(String libelle) {
        return findByLibelle(libelle) != null;
    }

}