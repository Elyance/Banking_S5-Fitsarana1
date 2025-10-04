package com.compteCourant.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

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

    @Column(name = "date_creation", nullable = false)
    private LocalDateTime dateCreation;

    // Constructeurs
    public StatutCompte() {
        this.dateCreation = LocalDateTime.now();
    }

    public StatutCompte(String libelle, String description) {
        this();
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

    public LocalDateTime getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
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