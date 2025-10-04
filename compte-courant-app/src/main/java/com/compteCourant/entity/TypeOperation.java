package com.compteCourant.entity;

import jakarta.persistence.*;

/**
 * Entité représentant un type d'opération bancaire
 * Exemple: DEPOT, RETRAIT, VIREMENT, CHEQUE, etc.
 */
@Entity
@Table(name = "type_operation")
public class TypeOperation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "libelle", length = 100, nullable = false)
    private String libelle;

    @Column(name = "description")
    private String description;

    // Constructeurs
    public TypeOperation() {
    }

    public TypeOperation(String libelle) {
        this.libelle = libelle;
    }

    public TypeOperation(String libelle, String description) {
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
        return "TypeOperation{" +
                "id=" + id +
                ", libelle='" + libelle + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}