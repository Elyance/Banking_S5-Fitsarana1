package com.compteCourant.repository;

import com.compteCourant.entity.Transaction;
import com.banque.dto.TransactionTypeOperationDTO;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceContextType;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.Query;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

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

    /**
     * Récupère les transactions d'un compte avec type d'opération via JOIN optimisé
     * Évite les requêtes N+1 et les problèmes de sérialisation JPA
     */
    public List<TransactionTypeOperationDTO> findTransactionsAvecTypeOperationByCompteCourantId(Long compteCourantId) {
        // Requête native pour faire le JOIN avec les types d'opération
        String sql = """
            SELECT 
                t.id as transaction_id,
                t.compte_courant_id,
                t.montant,
                t.description,
                t.reference_externe,
                t.date_transaction,
                t.type_operation_id,
                COALESCE(top.libelle, 'Opération inconnue') as type_operation_libelle,
                top.description as type_operation_description
            FROM transactions t
            LEFT JOIN type_operation top ON t.type_operation_id = top.id
            WHERE t.compte_courant_id = :compteCourantId
            ORDER BY t.date_transaction DESC
            """;

        Query query = em.createNativeQuery(sql);
        query.setParameter("compteCourantId", compteCourantId);
        
        @SuppressWarnings("unchecked")
        List<Object[]> resultList = (List<Object[]>) query.getResultList();
        
        List<com.banque.dto.TransactionTypeOperationDTO> transactions = new ArrayList<>();
        
        for (Object[] row : resultList) {
            com.banque.dto.TransactionTypeOperationDTO dto = new com.banque.dto.TransactionTypeOperationDTO();
            dto.setTransactionId(((Number) row[0]).longValue());
            dto.setCompteCourantId(((Number) row[1]).longValue());
            dto.setMontant((BigDecimal) row[2]);
            dto.setDescription((String) row[3]);
            dto.setReferenceExterne((String) row[4]);
            dto.setDateTransaction(row[5] != null ? ((java.sql.Timestamp) row[5]).toLocalDateTime() : null);
            dto.setTypeOperationId(row[6] != null ? ((Number) row[6]).longValue() : null);
            dto.setTypeOperationLibelle((String) row[7]);
            dto.setTypeOperationDescription((String) row[8]);
            // Pas de code car la colonne n'existe pas dans type_operation
            
            transactions.add(dto);
        }
        
        return transactions;
    }
}