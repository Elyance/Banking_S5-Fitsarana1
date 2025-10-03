package com.centralisateur.entity;

import jakarta.persistence.*;

/**
 * Entité représentant un statut de client
 * Exemple: ACTIF, INACTIF, SUSPENDU
 */
@Entity
@Table(name = "statut_client")
public class StatutClient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "libelle", length = 50, unique = true, nullable = false)
    private String libelle;

    @Column(name = "description")
    private String description;

    // Constructeur par défaut requis par JPA/Hibernate
    public StatutClient() {
    }

    public StatutClient(String libelle, String description) {
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

    // Méthodes utilitaires
    @Override
    public String toString() {
        return "StatutClient{" +
                "id=" + id +
                ", libelle='" + libelle + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}