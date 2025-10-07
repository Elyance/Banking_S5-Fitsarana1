package com.centralisateur.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * DTO pour l'affichage professionnel des transactions avec informations enrichies
 */
public class TransactionAffichageDTO {
    
    private Long transactionId;
    private Long compteId;
    private String numeroCompte;
    private Long typeOperationId;
    private String typeOperationLibelle;
    private BigDecimal montant;
    private String description;
    private String referenceExterne;
    private LocalDateTime dateTransaction;
    
    // Informations enrichies pour l'affichage
    private String typeOperationIcone;
    private String typeOperationCouleur;
    private String montantFormate;
    private String montantAvecSigne;
    private boolean estDebit;
    private boolean estCredit;
    
    // Constructeurs
    public TransactionAffichageDTO() {}
    
    public TransactionAffichageDTO(Long transactionId, Long compteId, String numeroCompte,
                                  Long typeOperationId, String typeOperationLibelle,
                                  BigDecimal montant, String description, String referenceExterne,
                                  LocalDateTime dateTransaction) {
        this.transactionId = transactionId;
        this.compteId = compteId;
        this.numeroCompte = numeroCompte;
        this.typeOperationId = typeOperationId;
        this.typeOperationLibelle = typeOperationLibelle;
        this.montant = montant;
        this.description = description;
        this.referenceExterne = referenceExterne;
        this.dateTransaction = dateTransaction;
        
        // Calculer les propriétés d'affichage
        this.calculerProprietesAffichage();
    }
    
    // Getters et Setters
    public Long getTransactionId() { return transactionId; }
    public void setTransactionId(Long transactionId) { this.transactionId = transactionId; }
    
    public Long getCompteId() { return compteId; }
    public void setCompteId(Long compteId) { this.compteId = compteId; }
    
    public String getNumeroCompte() { return numeroCompte; }
    public void setNumeroCompte(String numeroCompte) { this.numeroCompte = numeroCompte; }
    
    public Long getTypeOperationId() { return typeOperationId; }
    public void setTypeOperationId(Long typeOperationId) { 
        this.typeOperationId = typeOperationId;
        this.calculerProprietesAffichage();
    }
    
    public String getTypeOperationLibelle() { return typeOperationLibelle; }
    public void setTypeOperationLibelle(String typeOperationLibelle) { 
        this.typeOperationLibelle = typeOperationLibelle;
        this.calculerProprietesAffichage();
    }
    
    public BigDecimal getMontant() { return montant; }
    public void setMontant(BigDecimal montant) { 
        this.montant = montant;
        this.calculerProprietesAffichage();
    }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getReferenceExterne() { return referenceExterne; }
    public void setReferenceExterne(String referenceExterne) { this.referenceExterne = referenceExterne; }
    
    public LocalDateTime getDateTransaction() { return dateTransaction; }
    public void setDateTransaction(LocalDateTime dateTransaction) { this.dateTransaction = dateTransaction; }
    
    // Propriétés d'affichage calculées
    public String getTypeOperationIcone() { return typeOperationIcone; }
    public String getTypeOperationCouleur() { return typeOperationCouleur; }
    public String getMontantFormate() { return montantFormate; }
    public String getMontantAvecSigne() { return montantAvecSigne; }
    public boolean isEstDebit() { return estDebit; }
    public boolean isEstCredit() { return estCredit; }
    
    // Méthodes utilitaires pour l'affichage
    public String getDateTransactionFormatee() {
        if (dateTransaction != null) {
            return dateTransaction.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        }
        return "";
    }
    
    public String getDateTransactionCourte() {
        if (dateTransaction != null) {
            return dateTransaction.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }
        return "";
    }
    
    public String getHeureTransaction() {
        if (dateTransaction != null) {
            return dateTransaction.format(DateTimeFormatter.ofPattern("HH:mm"));
        }
        return "";
    }
    
    public String getDescriptionCourte() {
        if (description != null && description.length() > 50) {
            return description.substring(0, 47) + "...";
        }
        return description != null ? description : "Aucune description";
    }
    
    public String getDescriptionComplete() {
        return description != null ? description : "Aucune description";
    }
    
    public String getReferenceAffichage() {
        return referenceExterne != null && !referenceExterne.isEmpty() ? referenceExterne : "TXN-" + transactionId;
    }
    
    public String getClasseCss() {
        if (estCredit) {
            return "transaction-credit";
        } else if (estDebit) {
            return "transaction-debit";
        }
        return "transaction-neutre";
    }
    
    public String getClasseMontant() {
        if (estCredit) {
            return "montant-positif";
        } else if (estDebit) {
            return "montant-negatif";
        }
        return "montant-neutre";
    }
    
    /**
     * Calcule les propriétés d'affichage basées sur le type d'opération
     */
    private void calculerProprietesAffichage() {
        if (typeOperationId == null || montant == null) {
            return;
        }
        
        // Déterminer le type d'opération
        if (typeOperationId == 1L) { // Dépôt
            this.typeOperationIcone = "💰";
            this.typeOperationCouleur = "#4CAF50";
            this.estCredit = true;
            this.estDebit = false;
            this.montantAvecSigne = "+" + String.format("%.2f €", montant);
            this.montantFormate = String.format("%.2f €", montant);
            
            if (typeOperationLibelle == null || typeOperationLibelle.isEmpty()) {
                this.typeOperationLibelle = "Dépôt";
            }
            
        } else if (typeOperationId == 2L) { // Retrait
            this.typeOperationIcone = "💸";
            this.typeOperationCouleur = "#f44336";
            this.estCredit = false;
            this.estDebit = true;
            this.montantAvecSigne = "-" + String.format("%.2f €", montant);
            this.montantFormate = String.format("%.2f €", montant);
            
            if (typeOperationLibelle == null || typeOperationLibelle.isEmpty()) {
                this.typeOperationLibelle = "Retrait";
            }
            
        } else { // Autre type d'opération
            this.typeOperationIcone = "🔄";
            this.typeOperationCouleur = "#FF9800";
            this.estCredit = false;
            this.estDebit = false;
            this.montantAvecSigne = String.format("%.2f €", montant);
            this.montantFormate = String.format("%.2f €", montant);
            
            if (typeOperationLibelle == null || typeOperationLibelle.isEmpty()) {
                this.typeOperationLibelle = "Opération";
            }
        }
    }
    
    @Override
    public String toString() {
        return "TransactionAffichageDTO{" +
                "transactionId=" + transactionId +
                ", numeroCompte='" + numeroCompte + '\'' +
                ", typeOperationLibelle='" + typeOperationLibelle + '\'' +
                ", montant=" + montant +
                ", dateTransaction=" + dateTransaction +
                ", description='" + description + '\'' +
                '}';
    }
}