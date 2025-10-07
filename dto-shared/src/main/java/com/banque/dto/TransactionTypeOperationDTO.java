package com.banque.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * DTO partagé pour les informations de transaction avec type d'opération
 * Utilisé pour la communication EJB entre centralisateur-app et compte-courant-app
 * Évite les requêtes N+1 et les problèmes de sérialisation JPA
 */
public class TransactionTypeOperationDTO implements Serializable {
    private static final long serialVersionUID = 1L;
    
    // Informations de la transaction
    private Long transactionId;
    private Long compteCourantId;
    private BigDecimal montant;
    private String description;
    private String referenceExterne;
    private LocalDateTime dateTransaction;
    
    // Informations du type d'opération (via JOIN)
    private Long typeOperationId;
    private String typeOperationLibelle;
    private String typeOperationDescription;
    
    // Constructeurs
    public TransactionTypeOperationDTO() {}
    
    public TransactionTypeOperationDTO(Long transactionId, Long compteCourantId, BigDecimal montant,
                                     String description, String referenceExterne, LocalDateTime dateTransaction,
                                     Long typeOperationId, String typeOperationLibelle, String typeOperationDescription) {
        this.transactionId = transactionId;
        this.compteCourantId = compteCourantId;
        this.montant = montant;
        this.description = description;
        this.referenceExterne = referenceExterne;
        this.dateTransaction = dateTransaction;
        this.typeOperationId = typeOperationId;
        this.typeOperationLibelle = typeOperationLibelle;
        this.typeOperationDescription = typeOperationDescription;
    }
    
    // Getters et Setters
    public Long getTransactionId() {
        return transactionId;
    }
    
    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }
    
    public Long getCompteCourantId() {
        return compteCourantId;
    }
    
    public void setCompteCourantId(Long compteCourantId) {
        this.compteCourantId = compteCourantId;
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
    
    public Long getTypeOperationId() {
        return typeOperationId;
    }
    
    public void setTypeOperationId(Long typeOperationId) {
        this.typeOperationId = typeOperationId;
    }
    
    public String getTypeOperationLibelle() {
        return typeOperationLibelle;
    }
    
    public void setTypeOperationLibelle(String typeOperationLibelle) {
        this.typeOperationLibelle = typeOperationLibelle;
    }
    
    public String getTypeOperationDescription() {
        return typeOperationDescription;
    }
    
    public void setTypeOperationDescription(String typeOperationDescription) {
        this.typeOperationDescription = typeOperationDescription;
    }
    
    // Méthodes utilitaires
    public boolean isDebit() {
        if (montant == null) {
            return false;
        }
        return montant.compareTo(BigDecimal.ZERO) < 0;
    }
    
    public boolean isCredit() {
        if (montant == null) {
            return false;
        }
        return montant.compareTo(BigDecimal.ZERO) > 0;
    }
    
    public BigDecimal getMontantAbsolu() {
        if (montant == null) {
            return BigDecimal.ZERO;
        }
        return montant.abs();
    }
    
    public String getTypeOperationLibelleComplet() {
        return typeOperationLibelle != null ? typeOperationLibelle : "Opération inconnue";
    }
    
    public String getReferenceAffichage() {
        return referenceExterne != null && !referenceExterne.isEmpty() ? referenceExterne : "TXN-" + transactionId;
    }
    
    @Override
    public String toString() {
        return "TransactionTypeOperationDTO{" +
                "transactionId=" + transactionId +
                ", compteCourantId=" + compteCourantId +
                ", montant=" + montant +
                ", description='" + description + '\'' +
                ", dateTransaction=" + dateTransaction +
                ", typeOperationId=" + typeOperationId +
                ", typeOperationLibelle='" + typeOperationLibelle + '\'' +
                '}';
    }
}