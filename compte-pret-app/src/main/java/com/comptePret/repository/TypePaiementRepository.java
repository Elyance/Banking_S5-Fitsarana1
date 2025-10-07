package com.comptePret.repository;

import com.comptePret.entity.TypePaiement;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 * Repository pour la gestion des Types de Paiement
 */
@ApplicationScoped
public class TypePaiementRepository {

    @PersistenceContext
    private EntityManager em;

    /**
     * Trouve un type de paiement par son ID
     */
    public TypePaiement findById(Long id) {
        return em.find(TypePaiement.class, id);
    }

    /**
     * Trouve un type de paiement par son libellé
     */
    public TypePaiement findByLibelle(String libelle) {
        TypedQuery<TypePaiement> query = em.createQuery(
            "SELECT tp FROM TypePaiement tp WHERE tp.libelle = :libelle", 
            TypePaiement.class
        );
        query.setParameter("libelle", libelle);
        
        List<TypePaiement> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Trouve un type de paiement par sa valeur (nombre de mois)
     */
    public TypePaiement findByValeur(Integer valeur) {
        TypedQuery<TypePaiement> query = em.createQuery(
            "SELECT tp FROM TypePaiement tp WHERE tp.valeur = :valeur", 
            TypePaiement.class
        );
        query.setParameter("valeur", valeur);
        
        List<TypePaiement> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Trouve tous les types de paiement
     */
    public List<TypePaiement> findAll() {
        TypedQuery<TypePaiement> query = em.createQuery(
            "SELECT tp FROM TypePaiement tp ORDER BY tp.valeur", 
            TypePaiement.class
        );
        return query.getResultList();
    }

    /**
     * Sauvegarde un type de paiement (create ou update)
     */
    public TypePaiement save(TypePaiement typePaiement) {
        if (typePaiement.getId() == null) {
            em.persist(typePaiement);
            return typePaiement;
        } else {
            return em.merge(typePaiement);
        }
    }

    /**
     * Supprime un type de paiement
     */
    public void delete(TypePaiement typePaiement) {
        if (em.contains(typePaiement)) {
            em.remove(typePaiement);
        } else {
            em.remove(em.merge(typePaiement));
        }
    }
}