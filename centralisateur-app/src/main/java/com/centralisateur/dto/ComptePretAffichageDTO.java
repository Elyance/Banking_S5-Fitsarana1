package com.centralisateur.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * DTO pour l'affichage des comptes prêt avec les informations client
 */
public class ComptePretAffichageDTO {
    private Long compteId;
    private String numeroCompte;
    private Long clientId;
    private String nomClient;
    private String prenomClient;
    private String emailClient;
    private BigDecimal montantEmprunte;
    private BigDecimal tauxInteret;
    private Integer dureeEnMois;
    private String typePaiement;
    private String statutCompte;
    private LocalDate dateDebut;
    private BigDecimal soldeRestantDu;

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

    public Long getClientId() {
        return clientId;
    }

    public void setClientId(Long clientId) {
        this.clientId = clientId;
    }

    public String getNomClient() {
        return nomClient;
    }

    public void setNomClient(String nomClient) {
        this.nomClient = nomClient;
    }

    public String getPrenomClient() {
        return prenomClient;
    }

    public void setPrenomClient(String prenomClient) {
        this.prenomClient = prenomClient;
    }

    public String getEmailClient() {
        return emailClient;
    }

    public void setEmailClient(String emailClient) {
        this.emailClient = emailClient;
    }

    public BigDecimal getMontantEmprunte() {
        return montantEmprunte;
    }

    public void setMontantEmprunte(BigDecimal montantEmprunte) {
        this.montantEmprunte = montantEmprunte;
    }

    public BigDecimal getTauxInteret() {
        return tauxInteret;
    }

    public void setTauxInteret(BigDecimal tauxInteret) {
        this.tauxInteret = tauxInteret;
    }

    public Integer getDureeEnMois() {
        return dureeEnMois;
    }

    public void setDureeEnMois(Integer dureeEnMois) {
        this.dureeEnMois = dureeEnMois;
    }

    public String getTypePaiement() {
        return typePaiement;
    }

    public void setTypePaiement(String typePaiement) {
        this.typePaiement = typePaiement;
    }

    public String getStatutCompte() {
        return statutCompte;
    }

    public void setStatutCompte(String statutCompte) {
        this.statutCompte = statutCompte;
    }

    public LocalDate getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(LocalDate dateDebut) {
        this.dateDebut = dateDebut;
    }

    public BigDecimal getSoldeRestantDu() {
        return soldeRestantDu;
    }

    public void setSoldeRestantDu(BigDecimal soldeRestantDu) {
        this.soldeRestantDu = soldeRestantDu;
    }

    public String getDateDebutFormatee() {
        if (dateDebut != null) {
            return dateDebut.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }
        return "";
    }

    @Override
    public String toString() {
        return "ComptePretAffichageDTO{" +
                "compteId=" + compteId +
                ", numeroCompte='" + numeroCompte + '\'' +
                ", clientId=" + clientId +
                ", nomClient='" + nomClient + '\'' +
                ", prenomClient='" + prenomClient + '\'' +
                ", emailClient='" + emailClient + '\'' +
                ", montantEmprunte=" + montantEmprunte +
                ", tauxInteret=" + tauxInteret +
                ", dureeEnMois=" + dureeEnMois +
                ", typePaiement='" + typePaiement + '\'' +
                ", statutCompte='" + statutCompte + '\'' +
                ", dateDebut=" + dateDebut +
                ", soldeRestantDu=" + soldeRestantDu +
                '}';
    }
}