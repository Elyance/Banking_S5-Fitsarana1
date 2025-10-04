package com.compteCourant.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Entité représentant un compte courant bancaire
 */
@Entity
@Table(name = "compte_courant")
public class CompteCourant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "numero_compte", length = 20, unique = true, nullable = false)
    private String numeroCompte;

    @Column(name = "client_id", nullable = false)
    private Long clientId;

    @Column(name = "solde", precision = 15, scale = 2, nullable = false)
    private BigDecimal solde;

    @Column(name = "decouvert_autorise", precision = 15, scale = 2)
    private BigDecimal decouvertAutorise;

    @Column(name = "date_creation", nullable = false)
    private LocalDateTime dateCreation;

    @Column(name = "date_modification")
    private LocalDateTime dateModification;

    // Relations JPA
    @OneToMany(mappedBy = "compteCourant", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<Transaction> transactions;

    @OneToMany(mappedBy = "compteCourant", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<StatutCompteCourantMvt> mouvementsStatut;

    // Constructeurs
    public CompteCourant() {
        this.dateCreation = LocalDateTime.now();
        this.dateModification = LocalDateTime.now();
        this.solde = BigDecimal.ZERO;
        this.decouvertAutorise = BigDecimal.ZERO;
    }

    public CompteCourant(String numeroCompte, Long clientId) {
        this();
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

    public List<Transaction> getTransactions() {
        return transactions;
    }

    public void setTransactions(List<Transaction> transactions) {
        this.transactions = transactions;
    }

    public List<StatutCompteCourantMvt> getMouvementsStatut() {
        return mouvementsStatut;
    }

    public void setMouvementsStatut(List<StatutCompteCourantMvt> mouvementsStatut) {
        this.mouvementsStatut = mouvementsStatut;
    }

    // Méthodes utilitaires
    public boolean estEnDecouvert() {
        return solde.compareTo(BigDecimal.ZERO) < 0;
    }

    public boolean depasseDecouvertAutorise() {
        return solde.abs().compareTo(decouvertAutorise) > 0 && estEnDecouvert();
    }

    public BigDecimal getSoldeDisponible() {
        return solde.add(decouvertAutorise);
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