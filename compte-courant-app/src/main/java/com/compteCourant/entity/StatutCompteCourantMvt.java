package com.compteCourant.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entité représentant un mouvement de statut de compte courant
 * Permet de tracer l'historique des changements de statut
 */
@Entity
@Table(name = "statut_compte_courant_mvt")
public class StatutCompteCourantMvt {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "compte_courant_id", nullable = false)
    private Long compteCourantId;

    @Column(name = "statut_compte_id", nullable = false)
    private Long statutCompteId;

    @Column(name = "date_mvt", nullable = false)
    private LocalDateTime dateMvt;

    // Relations JPA
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "compte_courant_id", insertable = false, updatable = false)
    private CompteCourant compteCourant;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "statut_compte_id", insertable = false, updatable = false)
    private StatutCompte statutCompte;

    // Constructeurs
    public StatutCompteCourantMvt() {
        this.dateMvt = LocalDateTime.now();
    }

    public StatutCompteCourantMvt(Long compteCourantId, Long statutCompteId) {
        this();
        this.compteCourantId = compteCourantId;
        this.statutCompteId = statutCompteId;
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCompteCourantId() {
        return compteCourantId;
    }

    public void setCompteCourantId(Long compteCourantId) {
        this.compteCourantId = compteCourantId;
    }

    public Long getStatutCompteId() {
        return statutCompteId;
    }

    public void setStatutCompteId(Long statutCompteId) {
        this.statutCompteId = statutCompteId;
    }

    public LocalDateTime getDateMvt() {
        return dateMvt;
    }

    public void setDateMvt(LocalDateTime dateMvt) {
        this.dateMvt = dateMvt;
    }

    public CompteCourant getCompteCourant() {
        return compteCourant;
    }

    public void setCompteCourant(CompteCourant compteCourant) {
        this.compteCourant = compteCourant;
        if (compteCourant != null) {
            this.compteCourantId = compteCourant.getId();
        }
    }

    public StatutCompte getStatutCompte() {
        return statutCompte;
    }

    public void setStatutCompte(StatutCompte statutCompte) {
        this.statutCompte = statutCompte;
        if (statutCompte != null) {
            this.statutCompteId = statutCompte.getId();
        }
    }

    @Override
    public String toString() {
        return "StatutCompteCourantMvt{" +
                "id=" + id +
                ", compteCourantId=" + compteCourantId +
                ", statutCompteId=" + statutCompteId +
                ", dateMvt=" + dateMvt +
                '}';
    }
}