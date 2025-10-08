package com.banque.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * DTO pour transporter les informations de compte prêt avec son type de paiement et son statut
 */
public class ComptePretStatutDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long compteId;
    private String numeroCompte;
    private Long clientId;
    private BigDecimal montantEmprunte;
    private BigDecimal soldeRestantDu;
    private BigDecimal tauxInteret;
    private Integer dureeTotaleMois;
    private LocalDate dateDebut;
    private LocalDate dateFinTheorique;
    private String typePaiementLibelle;
    private Long statutId;
    private String statutLibelle;

    // Constructeurs
    public ComptePretStatutDTO() {}

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

    public String getTypePaiementLibelle() {
        return typePaiementLibelle;
    }

    public void setTypePaiementLibelle(String typePaiementLibelle) {
        this.typePaiementLibelle = typePaiementLibelle;
    }

    public Long getStatutId() {
        return statutId;
    }

    public void setStatutId(Long statutId) {
        this.statutId = statutId;
    }

    public String getStatutLibelle() {
        return statutLibelle;
    }

    public void setStatutLibelle(String statutLibelle) {
        this.statutLibelle = statutLibelle;
    }
}