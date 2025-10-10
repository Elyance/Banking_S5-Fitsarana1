package com.comptePret.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Entity
@Table(name = "echeances")
public class Echeances implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "compte_pret_id", nullable = false)
    private ComptePret comptePret;

    @Column(name = "date_echeance", nullable = false)
    private java.sql.Date dateEcheance;

    @Column(name = "montant_capital", nullable = false)
    private Double montantCapital;

    @Column(name = "montant_interet", nullable = false)
    private Double montantInteret;

    @OneToMany(mappedBy = "echeance")
    private List<MvtStatutEcheance> mvtStatutEcheances;

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public ComptePret getComptePret() { return comptePret; }
    public void setComptePret(ComptePret comptePret) { this.comptePret = comptePret; }
    public java.sql.Date getDateEcheance() { return dateEcheance; }
    public void setDateEcheance(java.sql.Date dateEcheance) { this.dateEcheance = dateEcheance; }
    public Double getMontantCapital() { return montantCapital; }
    public void setMontantCapital(Double montantCapital) { this.montantCapital = montantCapital; }
    public Double getMontantInteret() { return montantInteret; }
    public void setMontantInteret(Double montantInteret) { this.montantInteret = montantInteret; }
    public List<MvtStatutEcheance> getMvtStatutEcheances() { return mvtStatutEcheances; }
    public void setMvtStatutEcheances(List<MvtStatutEcheance> mvtStatutEcheances) { this.mvtStatutEcheances = mvtStatutEcheances; }
}
