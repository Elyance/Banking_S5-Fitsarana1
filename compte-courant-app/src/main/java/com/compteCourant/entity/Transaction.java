package com.compteCourant.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entité représentant une transaction bancaire
 */
@Entity
@Table(name = "transactions")
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "compte_courant_id", nullable = false)
    private Long compteCourantId;

    @Column(name = "type_operation_id", nullable = false)
    private Long typeOperationId;

    @Column(name = "montant", precision = 15, scale = 2, nullable = false)
    private BigDecimal montant;

    @Column(name = "description")
    private String description;

    @Column(name = "reference_externe", length = 100)
    private String referenceExterne;

    @Column(name = "date_transaction", nullable = false)
    private LocalDateTime dateTransaction;

    // Relations JPA
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "compte_courant_id", insertable = false, updatable = false)
    private CompteCourant compteCourant;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "type_operation_id", insertable = false, updatable = false)
    private TypeOperation typeOperation;

    // Constructeurs
    public Transaction() {
        this.dateTransaction = LocalDateTime.now();
    }

    public Transaction(Long compteCourantId, Long typeOperationId, BigDecimal montant) {
        this();
        this.compteCourantId = compteCourantId;
        this.typeOperationId = typeOperationId;
        this.montant = montant;
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

    public String getReferenceExterne() {
        return referenceExterne;
    }

    public void setReferenceExterne(String referenceExterne) {
        this.referenceExterne = referenceExterne;
    }

    public LocalDateTime getDateTransaction() {
        return dateTransaction;
    }

    public void setDateTransaction(LocalDateTime dateTransaction) {
        this.dateTransaction = dateTransaction;
    }

    public CompteCourant getCompteCourant() {
        return compteCourant;
    }

    public void setCompteCourant(CompteCourant compteCourant) {
        this.compteCourant = compteCourant;
        if (compteCourant != null) {
            this.compteCourantId = compteCourant.getId();
        }
    }

    public TypeOperation getTypeOperation() {
        return typeOperation;
    }

    public void setTypeOperation(TypeOperation typeOperation) {
        this.typeOperation = typeOperation;
        if (typeOperation != null) {
            this.typeOperationId = typeOperation.getId();
        }
    }

    // Méthodes utilitaires
    public boolean estDebit() {
        return montant.compareTo(BigDecimal.ZERO) < 0;
    }

    public boolean estCredit() {
        return montant.compareTo(BigDecimal.ZERO) > 0;
    }

    public BigDecimal getMontantAbsolu() {
        return montant.abs();
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