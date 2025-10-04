package com.compteCourant.repository;

import com.compteCourant.entity.Transaction;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceContextType;
import jakarta.persistence.TypedQuery;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Repository pour la gestion des Transactions
 */
@ApplicationScoped
public class TransactionRepository {

    @PersistenceContext(unitName = "CompteCourantPU", type = PersistenceContextType.TRANSACTION)
    private EntityManager em;

    /**
     * Recherche une transaction par son ID
     */
    public Transaction findById(Long id) {
        return em.find(Transaction.class, id);
    }

    /**
     * Récupère toutes les transactions
     */
    public List<Transaction> findAll() {
        TypedQuery<Transaction> query = em.createQuery(
            "SELECT t FROM Transaction t ORDER BY t.dateTransaction DESC", 
            Transaction.class
        );
        return query.getResultList();
    }

    /**
     * Recherche les transactions d'un compte courant
     */
    public List<Transaction> findByCompteCourantId(Long compteCourantId) {
        TypedQuery<Transaction> query = em.createQuery(
            "SELECT t FROM Transaction t WHERE t.compteCourantId = :compteCourantId ORDER BY t.dateTransaction DESC", 
            Transaction.class
        );
        query.setParameter("compteCourantId", compteCourantId);
        return query.getResultList();
    }

    /**
     * Recherche les transactions d'un compte courant avec pagination
     */
    public List<Transaction> findByCompteCourantId(Long compteCourantId, int offset, int limit) {
        TypedQuery<Transaction> query = em.createQuery(
            "SELECT t FROM Transaction t WHERE t.compteCourantId = :compteCourantId ORDER BY t.dateTransaction DESC", 
            Transaction.class
        );
        query.setParameter("compteCourantId", compteCourantId);
        query.setFirstResult(offset);
        query.setMaxResults(limit);
        return query.getResultList();
    }

    /**
     * Recherche les transactions par type d'opération
     */
    public List<Transaction> findByTypeOperationId(Long typeOperationId) {
        TypedQuery<Transaction> query = em.createQuery(
            "SELECT t FROM Transaction t WHERE t.typeOperationId = :typeOperationId ORDER BY t.dateTransaction DESC", 
            Transaction.class
        );
        query.setParameter("typeOperationId", typeOperationId);
        return query.getResultList();
    }

    /**
     * Recherche les transactions d'un compte entre deux dates
     */
    public List<Transaction> findByCompteCourantIdAndDateTransactionBetween(Long compteCourantId, LocalDateTime dateDebut, LocalDateTime dateFin) {
        TypedQuery<Transaction> query = em.createQuery(
            "SELECT t FROM Transaction t WHERE t.compteCourantId = :compteCourantId " +
            "AND t.dateTransaction BETWEEN :dateDebut AND :dateFin ORDER BY t.dateTransaction DESC", 
            Transaction.class
        );
        query.setParameter("compteCourantId", compteCourantId);
        query.setParameter("dateDebut", dateDebut);
        query.setParameter("dateFin", dateFin);
        return query.getResultList();
    }


    /**
     * Recherche les transactions par description (recherche partielle)
     */
    public List<Transaction> findByDescriptionContaining(String description) {
        TypedQuery<Transaction> query = em.createQuery(
            "SELECT t FROM Transaction t WHERE LOWER(t.description) LIKE LOWER(:description) ORDER BY t.dateTransaction DESC", 
            Transaction.class
        );
        query.setParameter("description", "%" + description + "%");
        return query.getResultList();
    }


    /**
     * Sauvegarde une transaction (create ou update)
     */
    public Transaction save(Transaction transaction) {
        if (transaction.getId() == null) {
            em.persist(transaction);
            return transaction;
        } else {
            return em.merge(transaction);
        }
    }

    /**
     * Supprime une transaction
     */
    public void delete(Transaction transaction) {
        if (em.contains(transaction)) {
            em.remove(transaction);
        } else {
            em.remove(em.merge(transaction));
        }
    }

    /**
     * Supprime une transaction par son ID
     */
    public boolean deleteById(Long id) {
        Transaction transaction = findById(id);
        if (transaction != null) {
            delete(transaction);
            return true;
        }
        return false;
    }

    /**
     * Vérifie si une transaction existe par son ID
     */
    public boolean existsById(Long id) {
        return findById(id) != null;
    }

    /**
     * Compte le nombre de transactions d'un compte
     */
    public long countByCompteCourantId(Long compteCourantId) {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(t) FROM Transaction t WHERE t.compteCourantId = :compteCourantId", 
            Long.class
        );
        query.setParameter("compteCourantId", compteCourantId);
        return query.getSingleResult();
    }

    /**
     * Calcule la somme des transactions d'un compte
     */
    public BigDecimal sumMontantByCompteCourantId(Long compteCourantId) {
        TypedQuery<BigDecimal> query = em.createQuery(
            "SELECT COALESCE(SUM(t.montant), 0) FROM Transaction t WHERE t.compteCourantId = :compteCourantId", 
            BigDecimal.class
        );
        query.setParameter("compteCourantId", compteCourantId);
        return query.getSingleResult();
    }

    /**
     * Calcule la somme des débits d'un compte (montants négatifs)
     */
    public BigDecimal sumDebitsByCompteCourantId(Long compteCourantId) {
        TypedQuery<BigDecimal> query = em.createQuery(
            "SELECT COALESCE(SUM(t.montant), 0) FROM Transaction t WHERE t.compteCourantId = :compteCourantId AND t.montant < 0", 
            BigDecimal.class
        );
        query.setParameter("compteCourantId", compteCourantId);
        return query.getSingleResult();
    }

    /**
     * Calcule la somme des crédits d'un compte (montants positifs)
     */
    public BigDecimal sumCreditsByCompteCourantId(Long compteCourantId) {
        TypedQuery<BigDecimal> query = em.createQuery(
            "SELECT COALESCE(SUM(t.montant), 0) FROM Transaction t WHERE t.compteCourantId = :compteCourantId AND t.montant > 0", 
            BigDecimal.class
        );
        query.setParameter("compteCourantId", compteCourantId);
        return query.getSingleResult();
    }
}