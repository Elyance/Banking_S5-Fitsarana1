package com.compteCourant.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entité DTO représentant une transaction pour les appels distants
 * Copie simplifiée de l'entité du module compte-courant
 */
public class Transaction implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long compteCourantId;
    private Long typeOperationId;
    private BigDecimal montant;
    private String description;
    private LocalDateTime dateTransaction;

    // Constructeurs
    public Transaction() {
    }

    public Transaction(Long compteCourantId, Long typeOperationId, BigDecimal montant, String description) {
        this.compteCourantId = compteCourantId;
        this.typeOperationId = typeOperationId;
        this.montant = montant;
        this.description = description;
        this.dateTransaction = LocalDateTime.now();
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCompteCourantId() {
        return compteCourantId;
    }

    public void setCompteCourantId(Long compteCourantId) {
        this.compteCourantId = compteCourantId;
    }

    public Long getTypeOperationId() {
        return typeOperationId;
    }

    public void setTypeOperationId(Long typeOperationId) {
        this.typeOperationId = typeOperationId;
    }

    public BigDecimal getMontant() {
        return montant;
    }

    public void setMontant(BigDecimal montant) {
        this.montant = montant;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getDateTransaction() {
        return dateTransaction;
    }

    public void setDateTransaction(LocalDateTime dateTransaction) {
        this.dateTransaction = dateTransaction;
    }

    @Override
    public String toString() {
        return "Transaction{" +
                "id=" + id +
                ", compteCourantId=" + compteCourantId +
                ", typeOperationId=" + typeOperationId +
                ", montant=" + montant +
                ", description='" + description + '\'' +
                ", dateTransaction=" + dateTransaction +
                '}';
    }
}