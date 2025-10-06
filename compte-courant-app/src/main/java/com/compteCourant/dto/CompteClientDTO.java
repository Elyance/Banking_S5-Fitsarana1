package com.compteCourant.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * DTO pour les comptes courants avec informations client (via JOIN)
 * Sérialisable pour la communication EJB
 */
public class CompteClientDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    // Informations du compte
    private Long compteId;
    private String numeroCompte;
    private BigDecimal solde;
    private BigDecimal decouvertAutorise;
    private LocalDateTime dateCreation;
    private LocalDateTime dateModification;
    
    // Informations du client (via JOIN)
    private Long clientId;
    private String nomClient;
    private String prenomClient;
    private String emailClient;
    private String telephoneClient;
    private String adresseClient;
    
    // Informations de statut (via JOIN)
    private String statutCompte;
    private LocalDateTime dateStatut;

    // Constructeurs
    public CompteClientDTO() {}

    public CompteClientDTO(Long compteId, String numeroCompte, BigDecimal solde, 
                          BigDecimal decouvertAutorise, LocalDateTime dateCreation, 
                          LocalDateTime dateModification, Long clientId, String nomClient, 
                          String prenomClient, String emailClient, String telephoneClient, 
                          String adresseClient, String statutCompte, LocalDateTime dateStatut) {
        this.compteId = compteId;
        this.numeroCompte = numeroCompte;
        this.solde = solde;
        this.decouvertAutorise = decouvertAutorise;
        this.dateCreation = dateCreation;
        this.dateModification = dateModification;
        this.clientId = clientId;
        this.nomClient = nomClient;
        this.prenomClient = prenomClient;
        this.emailClient = emailClient;
        this.telephoneClient = telephoneClient;
        this.adresseClient = adresseClient;
        this.statutCompte = statutCompte;
        this.dateStatut = dateStatut;
    }

    // Getters et Setters
    public Long getCompteId() { return compteId; }
    public void setCompteId(Long compteId) { this.compteId = compteId; }

    public String getNumeroCompte() { return numeroCompte; }
    public void setNumeroCompte(String numeroCompte) { this.numeroCompte = numeroCompte; }

    public BigDecimal getSolde() { return solde; }
    public void setSolde(BigDecimal solde) { this.solde = solde; }

    public BigDecimal getDecouvertAutorise() { return decouvertAutorise; }
    public void setDecouvertAutorise(BigDecimal decouvertAutorise) { this.decouvertAutorise = decouvertAutorise; }

    public LocalDateTime getDateCreation() { return dateCreation; }
    public void setDateCreation(LocalDateTime dateCreation) { this.dateCreation = dateCreation; }

    public LocalDateTime getDateModification() { return dateModification; }
    public void setDateModification(LocalDateTime dateModification) { this.dateModification = dateModification; }

    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }

    public String getNomClient() { return nomClient; }
    public void setNomClient(String nomClient) { this.nomClient = nomClient; }

    public String getPrenomClient() { return prenomClient; }
    public void setPrenomClient(String prenomClient) { this.prenomClient = prenomClient; }

    public String getEmailClient() { return emailClient; }
    public void setEmailClient(String emailClient) { this.emailClient = emailClient; }

    public String getTelephoneClient() { return telephoneClient; }
    public void setTelephoneClient(String telephoneClient) { this.telephoneClient = telephoneClient; }

    public String getAdresseClient() { return adresseClient; }
    public void setAdresseClient(String adresseClient) { this.adresseClient = adresseClient; }

    public String getStatutCompte() { return statutCompte; }
    public void setStatutCompte(String statutCompte) { this.statutCompte = statutCompte; }

    public LocalDateTime getDateStatut() { return dateStatut; }
    public void setDateStatut(LocalDateTime dateStatut) { this.dateStatut = dateStatut; }

    // Méthodes utilitaires
    public String getNomComplet() {
        return (prenomClient != null ? prenomClient : "") + " " + (nomClient != null ? nomClient : "");
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

    @Override
    public String toString() {
        return "CompteClientDTO{" +
                "compteId=" + compteId +
                ", numeroCompte='" + numeroCompte + '\'' +
                ", solde=" + solde +
                ", clientId=" + clientId +
                ", nomComplet='" + getNomComplet() + '\'' +
                ", statutCompte='" + statutCompte + '\'' +
                '}';
    }
}