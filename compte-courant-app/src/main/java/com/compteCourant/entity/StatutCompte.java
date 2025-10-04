package com.compteCourant.entity;

import jakarta.persistence.*;

/**
 * Entité représentant un statut de compte courant
 * Exemple: ACTIF, FERMÉ, SUSPENDU, BLOQUÉ
 */
@Entity
@Table(name = "statut_compte")
public class StatutCompte {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "libelle", length = 50, unique = true, nullable = false)
    private String libelle;

    @Column(name = "description")
    private String description;

    // Constructeurs
    public StatutCompte() {
    }

    public StatutCompte(String libelle, String description) {
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

    @Override
    public String toString() {
        return "StatutCompte{" +
                "id=" + id +
                ", libelle='" + libelle + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}