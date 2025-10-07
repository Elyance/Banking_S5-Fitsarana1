package com.comptePret.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entité représentant un remboursement de prêt
 */
@Entity
@Table(name = "remboursement")
public class Remboursement implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "compte_pret_id", nullable = false)
    private ComptePret comptePret;

    // Informations du remboursement
    @Column(name = "date_remboursement", nullable = false)
    private LocalDateTime dateRemboursement;

    @Column(name = "montant_total_paye", precision = 12, scale = 2, nullable = false)
    private BigDecimal montantTotalPaye;

    @Column(name = "montant_capital", precision = 12, scale = 2, nullable = false)
    private BigDecimal montantCapital;

    @Column(name = "montant_interet", precision = 12, scale = 2, nullable = false)
    private BigDecimal montantInteret;

    // État après remboursement
    @Column(name = "solde_restant_apres", precision = 15, scale = 2, nullable = false)
    private BigDecimal soldeRestantApres;

    // Métadonnées
    @Column(name = "reference_transaction", length = 100)
    private String referenceTransaction;

    @Column(name = "commentaire")
    private String commentaire;

    // Constructeurs
    public Remboursement() {
        this.dateRemboursement = LocalDateTime.now();
    }

    public Remboursement(ComptePret comptePret, BigDecimal montantCapital, 
                        BigDecimal montantInteret, BigDecimal soldeRestantApres) {
        this();
        this.comptePret = comptePret;
        this.montantCapital = montantCapital;
        this.montantInteret = montantInteret;
        this.montantTotalPaye = montantCapital.add(montantInteret);
        this.soldeRestantApres = soldeRestantApres;
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public ComptePret getComptePret() {
        return comptePret;
    }

    public void setComptePret(ComptePret comptePret) {
        this.comptePret = comptePret;
    }

    public LocalDateTime getDateRemboursement() {
        return dateRemboursement;
    }

    public void setDateRemboursement(LocalDateTime dateRemboursement) {
        this.dateRemboursement = dateRemboursement;
    }

    public BigDecimal getMontantTotalPaye() {
        return montantTotalPaye;
    }

    public void setMontantTotalPaye(BigDecimal montantTotalPaye) {
        this.montantTotalPaye = montantTotalPaye;
    }

    public BigDecimal getMontantCapital() {
        return montantCapital;
    }

    public void setMontantCapital(BigDecimal montantCapital) {
        this.montantCapital = montantCapital;
    }

    public BigDecimal getMontantInteret() {
        return montantInteret;
    }

    public void setMontantInteret(BigDecimal montantInteret) {
        this.montantInteret = montantInteret;
    }

    public BigDecimal getSoldeRestantApres() {
        return soldeRestantApres;
    }

    public void setSoldeRestantApres(BigDecimal soldeRestantApres) {
        this.soldeRestantApres = soldeRestantApres;
    }

    public String getReferenceTransaction() {
        return referenceTransaction;
    }

    public void setReferenceTransaction(String referenceTransaction) {
        this.referenceTransaction = referenceTransaction;
    }

    public String getCommentaire() {
        return commentaire;
    }

    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }

    // Méthodes métier
    public void calculerMontantTotal() {
        if (montantCapital != null && montantInteret != null) {
            this.montantTotalPaye = montantCapital.add(montantInteret);
        }
    }

    @PrePersist
    @PreUpdate
    protected void validateAndCalculate() {
        if (dateRemboursement == null) {
            dateRemboursement = LocalDateTime.now();
        }
        calculerMontantTotal();
    }

    // Méthodes utilitaires
    @Override
    public String toString() {
        return "Remboursement{" +
                "id=" + id +
                ", comptePretId=" + (comptePret != null ? comptePret.getId() : null) +
                ", dateRemboursement=" + dateRemboursement +
                ", montantTotalPaye=" + montantTotalPaye +
                ", montantCapital=" + montantCapital +
                ", montantInteret=" + montantInteret +
                ", soldeRestantApres=" + soldeRestantApres +
                ", referenceTransaction='" + referenceTransaction + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Remboursement)) return false;
        Remboursement that = (Remboursement) o;
        return id != null && id.equals(that.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}