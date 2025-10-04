package com.compteCourant.repository;

import com.compteCourant.entity.TypeOperation;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceContextType;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 * Repository pour la gestion des Types d'Opération
 */
@ApplicationScoped
public class TypeOperationRepository {

    @PersistenceContext(unitName = "CompteCourantPU", type = PersistenceContextType.TRANSACTION)
    private EntityManager em;

    /**
     * Recherche un type d'opération par son ID
     */
    public TypeOperation findById(Long id) {
        return em.find(TypeOperation.class, id);
    }

    /**
     * Récupère tous les types d'opération
     */
    public List<TypeOperation> findAll() {
        TypedQuery<TypeOperation> query = em.createQuery(
            "SELECT t FROM TypeOperation t ORDER BY t.code", 
            TypeOperation.class
        );
        return query.getResultList();
    }

    /**
     * Recherche un type d'opération par son code
     */
    public TypeOperation findByCode(String code) {
        TypedQuery<TypeOperation> query = em.createQuery(
            "SELECT t FROM TypeOperation t WHERE t.code = :code", 
            TypeOperation.class
        );
        query.setParameter("code", code);
        
        List<TypeOperation> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Recherche des types d'opération par libellé (recherche partielle)
     */
    public List<TypeOperation> findByLibelleContaining(String libelle) {
        TypedQuery<TypeOperation> query = em.createQuery(
            "SELECT t FROM TypeOperation t WHERE LOWER(t.libelle) LIKE LOWER(:libelle) ORDER BY t.libelle", 
            TypeOperation.class
        );
        query.setParameter("libelle", "%" + libelle + "%");
        return query.getResultList();
    }

    /**
     * Recherche des types d'opération par description (recherche partielle)
     */
    public List<TypeOperation> findByDescriptionContaining(String description) {
        TypedQuery<TypeOperation> query = em.createQuery(
            "SELECT t FROM TypeOperation t WHERE LOWER(t.description) LIKE LOWER(:description) ORDER BY t.libelle", 
            TypeOperation.class
        );
        query.setParameter("description", "%" + description + "%");
        return query.getResultList();
    }

    public List<TypeOperation> findByCodeStartingWith(String prefix) {
        TypedQuery<TypeOperation> query = em.createQuery(
            "SELECT t FROM TypeOperation t WHERE t.code LIKE :prefix ORDER BY t.code", 
            TypeOperation.class
        );
        query.setParameter("prefix", prefix + "%");
        return query.getResultList();
    }

}