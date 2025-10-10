package com.comptePret.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Entité représentant un compte prêt
 */
@Entity
@Table(name = "compte_pret")
public class ComptePret implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "numero_compte", length = 30, nullable = false, unique = true)
    private String numeroCompte;

    @Column(name = "client_id", nullable = false)
    private Long clientId; // Référence vers centralisateur (pas de FK)

    // Informations du prêt
    @Column(name = "montant_emprunte", precision = 15, scale = 2, nullable = false)
    private BigDecimal montantEmprunte;

    @Column(name = "solde_restant_du", precision = 15, scale = 2, nullable = false)
    private BigDecimal soldeRestantDu;

    @Column(name = "taux_interet", precision = 8, scale = 4, nullable = false)
    private BigDecimal tauxInteret; // Taux annuel en %

    @Column(name = "duree_totale_mois", nullable = false)
    private Integer dureeTotaleMois;

    // Dates importantes
    @Column(name = "date_debut", nullable = false)
    private LocalDate dateDebut;

    @Column(name = "date_fin_theorique", nullable = false)
    private LocalDate dateFinTheorique;

    @Column(name = "date_creation", nullable = false)
    private LocalDateTime dateCreation;

    // Relations
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "type_paiement_id")
    private TypePaiement typePaiement;

    @OneToMany(mappedBy = "comptePret", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<MvtStatutComptePret> mouvementsStatut;

    // Constructeurs
    public ComptePret() {
        this.dateCreation = LocalDateTime.now();
    }

    public ComptePret(String numeroCompte, Long clientId, BigDecimal montantEmprunte, 
                     BigDecimal tauxInteret, Integer dureeTotaleMois, LocalDate dateDebut) {
        this();
        this.numeroCompte = numeroCompte;
        this.clientId = clientId;
        this.montantEmprunte = montantEmprunte;
        this.soldeRestantDu = montantEmprunte; // Initialement égal au montant emprunté
        this.tauxInteret = tauxInteret;
        this.dureeTotaleMois = dureeTotaleMois;
        this.dateDebut = dateDebut;
        // Calcul de la date de fin théorique
        this.dateFinTheorique = dateDebut.plusMonths(dureeTotaleMois);
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

    public TypePaiement getTypePaiement() {
        return typePaiement;
    }

    public void setTypePaiement(TypePaiement typePaiement) {
        this.typePaiement = typePaiement;
    }

    public List<MvtStatutComptePret> getMouvementsStatut() {
        return mouvementsStatut;
    }

    public void setMouvementsStatut(List<MvtStatutComptePret> mouvementsStatut) {
        this.mouvementsStatut = mouvementsStatut;
    }

    // Méthodes métier
    public BigDecimal getMontantRembourse() {
        return montantEmprunte.subtract(soldeRestantDu);
    }

    public BigDecimal getPourcentageRembourse() {
        if (montantEmprunte.compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO;
        }
        return getMontantRembourse()
                .divide(montantEmprunte, 4, RoundingMode.HALF_UP)
                .multiply(BigDecimal.valueOf(100));
    }

    public boolean isEntierementRembourse() {
        return soldeRestantDu.compareTo(BigDecimal.ZERO) == 0;
    }

    @PrePersist
    protected void onCreate() {
        if (dateCreation == null) {
            dateCreation = LocalDateTime.now();
        }
    }

    // Méthodes utilitaires
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
                ", dateFinTheorique=" + dateFinTheorique +
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