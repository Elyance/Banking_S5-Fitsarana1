package com.comptePret.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

/**
 * Entité représentant un type de paiement (fréquence de remboursement)
 */
@Entity
@Table(name = "type_paiement")
public class TypePaiement implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "libelle", length = 50, nullable = false, unique = true)
    private String libelle;

    @Column(name = "valeur", nullable = false)
    private Integer valeur; // Nombre de mois dans la période

    @Column(name = "description")
    private String description;

    // Relation bidirectionnelle avec ComptePret
    @OneToMany(mappedBy = "typePaiement", fetch = FetchType.LAZY)
    private List<ComptePret> comptesPret;

    // Constructeurs
    public TypePaiement() {}

    public TypePaiement(String libelle, Integer valeur, String description) {
        this.libelle = libelle;
        this.valeur = valeur;
        this.description = description;
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public Integer getValeur() {
        return valeur;
    }

    public void setValeur(Integer valeur) {
        this.valeur = valeur;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<ComptePret> getComptesPret() {
        return comptesPret;
    }

    public void setComptesPret(List<ComptePret> comptesPret) {
        this.comptesPret = comptesPret;
    }

    // Méthodes utilitaires
    @Override
    public String toString() {
        return "TypePaiement{" +
                "id=" + id +
                ", libelle='" + libelle + '\'' +
                ", valeur=" + valeur +
                ", description='" + description + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof TypePaiement)) return false;
        TypePaiement that = (TypePaiement) o;
        return id != null && id.equals(that.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}