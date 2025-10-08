package com.comptePret.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Entité ComptePret pour le centralisateur
 * Version simplifiée pour les transferts de données
 */
public class ComptePret implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String numeroCompte;
    private Long clientId;
    
    // Informations du prêt
    private BigDecimal montantEmprunte;
    private BigDecimal soldeRestantDu;
    private BigDecimal tauxInteret; // Taux annuel en %
    private Integer dureeTotaleMois;
    private Long typePaiementId;
    
    // Dates importantes
    private LocalDate dateDebut;
    private LocalDate dateFinTheorique;
    private LocalDateTime dateCreation;
    private LocalDateTime dateModification;
    
    // Statut actuel
    private String statutActuel;
    private Long statutActuelId;

    // Constructeurs
    public ComptePret() {}

    public ComptePret(String numeroCompte, Long clientId, BigDecimal montantEmprunte,
                     BigDecimal tauxInteret, Integer dureeTotaleMois, LocalDate dateDebut,
                     Long typePaiementId) {
        this.numeroCompte = numeroCompte;
        this.clientId = clientId;
        this.montantEmprunte = montantEmprunte;
        this.soldeRestantDu = montantEmprunte; // Initialement, tout reste à rembourser
        this.tauxInteret = tauxInteret;
        this.dureeTotaleMois = dureeTotaleMois;
        this.dateDebut = dateDebut;
        this.typePaiementId = typePaiementId;
        this.dateCreation = LocalDateTime.now();
        this.dateModification = LocalDateTime.now();
        
        // Calcul de la date de fin théorique
        if (dateDebut != null && dureeTotaleMois != null) {
            this.dateFinTheorique = dateDebut.plusMonths(dureeTotaleMois);
        }
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

    public BigDecimal getMontantEmprunte() {
        return montantEmprunte;
    }

    public void setMontantEmprunte(BigDecimal montantEmprunte) {
        this.montantEmprunte = montantEmprunte;
    }

    public BigDecimal getSoldeRestantDu() {
        return soldeRestantDu;
    }

    public void setSoldeRestantDu(BigDecimal soldeRestantDu) {
        this.soldeRestantDu = soldeRestantDu;
    }

    public BigDecimal getTauxInteret() {
        return tauxInteret;
    }

    public void setTauxInteret(BigDecimal tauxInteret) {
        this.tauxInteret = tauxInteret;
    }

    public Integer getDureeTotaleMois() {
        return dureeTotaleMois;
    }

    public void setDureeTotaleMois(Integer dureeTotaleMois) {
        this.dureeTotaleMois = dureeTotaleMois;
    }

    public Long getTypePaiementId() {
        return typePaiementId;
    }

    public void setTypePaiementId(Long typePaiementId) {
        this.typePaiementId = typePaiementId;
    }

    public LocalDate getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(LocalDate dateDebut) {
        this.dateDebut = dateDebut;
    }

    public LocalDate getDateFinTheorique() {
        return dateFinTheorique;
    }

    public void setDateFinTheorique(LocalDate dateFinTheorique) {
        this.dateFinTheorique = dateFinTheorique;
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

    public String getStatutActuel() {
        return statutActuel;
    }

    public void setStatutActuel(String statutActuel) {
        this.statutActuel = statutActuel;
    }

    public Long getStatutActuelId() {
        return statutActuelId;
    }

    public void setStatutActuelId(Long statutActuelId) {
        this.statutActuelId = statutActuelId;
    }

    // Méthodes utilitaires
    
    /**
     * Calcule le pourcentage remboursé
     */
    public BigDecimal getPourcentageRembourse() {
        if (montantEmprunte == null || montantEmprunte.compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO;
        }
        
        BigDecimal montantRembourse = montantEmprunte.subtract(soldeRestantDu != null ? soldeRestantDu : BigDecimal.ZERO);
        return montantRembourse.multiply(BigDecimal.valueOf(100))
                              .divide(montantEmprunte, 2, RoundingMode.HALF_UP);
    }

    /**
     * Calcule le montant total remboursé
     */
    public BigDecimal getMontantRembourse() {
        if (montantEmprunte == null) {
            return BigDecimal.ZERO;
        }
        return montantEmprunte.subtract(soldeRestantDu != null ? soldeRestantDu : BigDecimal.ZERO);
    }

    /**
     * Vérifie si le prêt est entièrement remboursé
     */
    public boolean isEntierementRembourse() {
        return soldeRestantDu != null && soldeRestantDu.compareTo(BigDecimal.ZERO) <= 0;
    }

    /**
     * Vérifie si le prêt est actif
     */
    public boolean isActif() {
        return "ACTIF".equalsIgnoreCase(statutActuel) || 
               (statutActuelId != null && statutActuelId.equals(1L));
    }

    /**
     * Calcule la durée restante en mois
     */
    public Integer getDureeRestanteMois() {
        if (dateFinTheorique == null) {
            return null;
        }
        
        LocalDate maintenant = LocalDate.now();
        if (maintenant.isAfter(dateFinTheorique)) {
            return 0; // Prêt échu
        }
        
        return (int) maintenant.until(dateFinTheorique).toTotalMonths();
    }

    /**
     * Formatage pour l'affichage
     */
    public String getAffichageComplet() {
        return String.format("Prêt %s - %.2f€ (%.2f%% remboursé)", 
                           numeroCompte, 
                           montantEmprunte != null ? montantEmprunte : BigDecimal.ZERO,
                           getPourcentageRembourse());
    }

    @Override
    public String toString() {
        return "ComptePret{" +
                "id=" + id +
                ", numeroCompte='" + numeroCompte + '\'' +
                ", clientId=" + clientId +
                ", montantEmprunte=" + montantEmprunte +
                ", soldeRestantDu=" + soldeRestantDu +
                ", tauxInteret=" + tauxInteret +
                ", dureeTotaleMois=" + dureeTotaleMois +
                ", dateDebut=" + dateDebut +
                ", statutActuel='" + statutActuel + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ComptePret)) return false;
        ComptePret that = (ComptePret) o;
        return id != null && id.equals(that.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}
