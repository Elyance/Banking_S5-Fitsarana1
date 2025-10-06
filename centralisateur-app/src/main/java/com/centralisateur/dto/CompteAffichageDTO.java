package com.centralisateur.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * DTO pour l'affichage professionnel des comptes avec informations client
 */
public class CompteAffichageDTO {
    
    private Long compteId;
    private String numeroCompte;
    private Long clientId;
    private String nomClient;
    private String prenomClient;
    private String emailClient;
    private BigDecimal solde;
    private BigDecimal decouvertAutorise;
    private LocalDateTime dateCreation;
    private String statutCompte;
    
    // Constructeurs
    public CompteAffichageDTO() {}
    
    public CompteAffichageDTO(Long compteId, String numeroCompte, Long clientId, 
                             String nomClient, String prenomClient, String emailClient,
                             BigDecimal solde, BigDecimal decouvertAutorise, 
                             LocalDateTime dateCreation, String statutCompte) {
        this.compteId = compteId;
        this.numeroCompte = numeroCompte;
        this.clientId = clientId;
        this.nomClient = nomClient;
        this.prenomClient = prenomClient;
        this.emailClient = emailClient;
        this.solde = solde;
        this.decouvertAutorise = decouvertAutorise;
        this.dateCreation = dateCreation;
        this.statutCompte = statutCompte;
    }
    
    // Getters et Setters
    public Long getCompteId() { return compteId; }
    public void setCompteId(Long compteId) { this.compteId = compteId; }
    
    public String getNumeroCompte() { return numeroCompte; }
    public void setNumeroCompte(String numeroCompte) { this.numeroCompte = numeroCompte; }
    
    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }
    
    public String getNomClient() { return nomClient; }
    public void setNomClient(String nomClient) { this.nomClient = nomClient; }
    
    public String getPrenomClient() { return prenomClient; }
    public void setPrenomClient(String prenomClient) { this.prenomClient = prenomClient; }
    
    public String getEmailClient() { return emailClient; }
    public void setEmailClient(String emailClient) { this.emailClient = emailClient; }
    
    public BigDecimal getSolde() { return solde; }
    public void setSolde(BigDecimal solde) { this.solde = solde; }
    
    public BigDecimal getDecouvertAutorise() { return decouvertAutorise; }
    public void setDecouvertAutorise(BigDecimal decouvertAutorise) { this.decouvertAutorise = decouvertAutorise; }
    
    public LocalDateTime getDateCreation() { return dateCreation; }
    public void setDateCreation(LocalDateTime dateCreation) { this.dateCreation = dateCreation; }
    
    public String getStatutCompte() { return statutCompte; }
    public void setStatutCompte(String statutCompte) { this.statutCompte = statutCompte; }
    
    // Méthodes utilitaires pour l'affichage
    public String getNomComplet() {
        return (prenomClient != null ? prenomClient : "") + " " + (nomClient != null ? nomClient : "");
    }
    
    public String getDateCreationFormatee() {
        if (dateCreation != null) {
            return dateCreation.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        }
        return "";
    }
    
    public boolean isEnDecouvert() {
        return solde != null && solde.compareTo(BigDecimal.ZERO) < 0;
    }
    
    public BigDecimal getSoldeDisponible() {
        if (solde != null && decouvertAutorise != null) {
            return solde.add(decouvertAutorise);
        }
        return solde != null ? solde : BigDecimal.ZERO;
    }
    
    public String getClasseSolde() {
        if (isEnDecouvert()) {
            return "solde-negatif";
        }
        return "solde-positif";
    }
    
    public String getClasseStatut() {
        if ("ACTIF".equals(statutCompte)) {
            return "statut-actif";
        } else if ("SUSPENDU".equals(statutCompte)) {
            return "statut-suspendu";
        } else if ("FERME".equals(statutCompte)) {
            return "statut-ferme";
        }
        return "statut-inconnu";
    }
}