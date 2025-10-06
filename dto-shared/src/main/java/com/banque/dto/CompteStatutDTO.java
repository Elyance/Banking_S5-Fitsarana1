package com.banque.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * DTO partagé pour les informations de compte avec statut
 * Utilisé pour la communication EJB entre centralisateur-app et compte-courant-app
 */
public class CompteStatutDTO implements Serializable {
    private static final long serialVersionUID = 1L;
    
    // Informations du compte
    private Long compteId;
    private String numeroCompte;
    private BigDecimal solde;
    private Long clientId;
    private LocalDateTime dateCreation;
    
    // Informations du statut
    private Long statutId;
    private BigDecimal soldeMinimum;
    private BigDecimal decouvertAutorise;
    private LocalDateTime dateStatut;
    
    // Constructeurs
    public CompteStatutDTO() {}
    
    public CompteStatutDTO(Long compteId, String numeroCompte, BigDecimal solde, Long clientId, 
                          LocalDateTime dateCreation, Long statutId, BigDecimal soldeMinimum, 
                          BigDecimal decouvertAutorise, LocalDateTime dateStatut) {
        this.compteId = compteId;
        this.numeroCompte = numeroCompte;
        this.solde = solde;
        this.clientId = clientId;
        this.dateCreation = dateCreation;
        this.statutId = statutId;
        this.soldeMinimum = soldeMinimum;
        this.decouvertAutorise = decouvertAutorise;
        this.dateStatut = dateStatut;
    }
    
    // Getters et Setters
    public Long getCompteId() {
        return compteId;
    }
    
    public void setCompteId(Long compteId) {
        this.compteId = compteId;
    }
    
    public String getNumeroCompte() {
        return numeroCompte;
    }
    
    public void setNumeroCompte(String numeroCompte) {
        this.numeroCompte = numeroCompte;
    }
    
    public BigDecimal getSolde() {
        return solde;
    }
    
    public void setSolde(BigDecimal solde) {
        this.solde = solde;
    }
    
    public Long getClientId() {
        return clientId;
    }
    
    public void setClientId(Long clientId) {
        this.clientId = clientId;
    }
    
    public LocalDateTime getDateCreation() {
        return dateCreation;
    }
    
    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
    }
    
    public Long getStatutId() {
        return statutId;
    }
    
    public void setStatutId(Long statutId) {
        this.statutId = statutId;
    }
    
    public BigDecimal getSoldeMinimum() {
        return soldeMinimum;
    }
    
    public void setSoldeMinimum(BigDecimal soldeMinimum) {
        this.soldeMinimum = soldeMinimum;
    }
    
    public BigDecimal getDecouvertAutorise() {
        return decouvertAutorise;
    }
    
    public void setDecouvertAutorise(BigDecimal decouvertAutorise) {
        this.decouvertAutorise = decouvertAutorise;
    }
    
    public LocalDateTime getDateStatut() {
        return dateStatut;
    }
    
    public void setDateStatut(LocalDateTime dateStatut) {
        this.dateStatut = dateStatut;
    }
    
    // Méthodes utilitaires
    public boolean isEnDecouvert() {
        if (solde == null || decouvertAutorise == null) {
            return false;
        }
        return solde.add(decouvertAutorise).compareTo(BigDecimal.ZERO) < 0;
    }
    
    public BigDecimal getSoldeDisponible() {
        if (solde == null || decouvertAutorise == null) {
            return solde != null ? solde : BigDecimal.ZERO;
        }
        return solde.add(decouvertAutorise);
    }
    
    @Override
    public String toString() {
        return "CompteStatutDTO{" +
                "compteId=" + compteId +
                ", numeroCompte='" + numeroCompte + '\'' +
                ", solde=" + solde +
                ", clientId=" + clientId +
                ", dateCreation=" + dateCreation +
                ", statutId=" + statutId +
                ", soldeMinimum=" + soldeMinimum +
                ", decouvertAutorise=" + decouvertAutorise +
                ", dateStatut=" + dateStatut +
                '}';
    }
}