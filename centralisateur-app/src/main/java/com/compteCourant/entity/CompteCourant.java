package com.compteCourant.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entité DTO représentant un compte courant pour les appels distants
 * Copie simplifiée de l'entité du module compte-courant
 */
public class CompteCourant implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String numeroCompte;
    private Long clientId;
    private BigDecimal solde;
    private BigDecimal decouvertAutorise;
    private LocalDateTime dateCreation;
    private LocalDateTime dateModification;

    // Constructeurs
    public CompteCourant() {
    }

    public CompteCourant(String numeroCompte, Long clientId) {
        this.numeroCompte = numeroCompte;
        this.clientId = clientId;
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public BigDecimal getSolde() {
        return solde;
    }

    public void setSolde(BigDecimal solde) {
        this.solde = solde;
    }

    public BigDecimal getDecouvertAutorise() {
        return decouvertAutorise;
    }

    public void setDecouvertAutorise(BigDecimal decouvertAutorise) {
        this.decouvertAutorise = decouvertAutorise;
    }

    public LocalDateTime getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
    }

    public LocalDateTime getDateModification() {
        return dateModification;
    }

    public void setDateModification(LocalDateTime dateModification) {
        this.dateModification = dateModification;
    }

    // Méthodes utilitaires
    public boolean estEnDecouvert() {
        return solde != null && solde.compareTo(BigDecimal.ZERO) < 0;
    }

    public boolean depasseDecouvertAutorise() {
        return estEnDecouvert() && decouvertAutorise != null && 
               solde.abs().compareTo(decouvertAutorise) > 0;
    }

    public BigDecimal getSoldeDisponible() {
        BigDecimal soldeActuel = solde != null ? solde : BigDecimal.ZERO;
        BigDecimal decouvert = decouvertAutorise != null ? decouvertAutorise : BigDecimal.ZERO;
        return soldeActuel.add(decouvert);
    }

    @Override
    public String toString() {
        return "CompteCourant{" +
                "id=" + id +
                ", numeroCompte='" + numeroCompte + '\'' +
                ", clientId=" + clientId +
                ", solde=" + solde +
                ", decouvertAutorise=" + decouvertAutorise +
                '}';
    }
}