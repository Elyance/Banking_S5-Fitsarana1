package com.comptePret.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

/**
 * Entité représentant un statut de compte prêt
 */
@Entity
@Table(name = "statut_compte_pret")
public class StatutComptePret implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "libelle", length = 50, nullable = false, unique = true)
    private String libelle;

    @Column(name = "description")
    private String description;

    // Relation bidirectionnelle avec MvtStatutComptePret
    @OneToMany(mappedBy = "statutComptePret", fetch = FetchType.LAZY)
    private List<MvtStatutComptePret> mouvements;

    // Constructeurs
    public StatutComptePret() {}

    public StatutComptePret(String libelle, String description) {
        this.libelle = libelle;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<MvtStatutComptePret> getMouvements() {
        return mouvements;
    }

    public void setMouvements(List<MvtStatutComptePret> mouvements) {
        this.mouvements = mouvements;
    }

    // Méthodes utilitaires
    @Override
    public String toString() {
        return "StatutComptePret{" +
                "id=" + id +
                ", libelle='" + libelle + '\'' +
                ", description='" + description + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof StatutComptePret)) return false;
        StatutComptePret that = (StatutComptePret) o;
        return id != null && id.equals(that.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}