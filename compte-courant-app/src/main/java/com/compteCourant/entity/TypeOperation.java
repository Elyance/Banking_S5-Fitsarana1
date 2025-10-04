package com.compteCourant.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

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

    @Column(name = "code", length = 20, unique = true, nullable = false)
    private String code;

    @Column(name = "libelle", length = 100, nullable = false)
    private String libelle;

    @Column(name = "description")
    private String description;

    @Column(name = "frais", precision = 10, scale = 2)
    private BigDecimal frais;

    @Column(name = "date_creation", nullable = false)
    private LocalDateTime dateCreation;

    // Constructeurs
    public TypeOperation() {
        this.dateCreation = LocalDateTime.now();
        this.frais = BigDecimal.ZERO;
    }

    public TypeOperation(String code, String libelle) {
        this();
        this.code = code;
        this.libelle = libelle;
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
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

    public BigDecimal getFrais() {
        return frais;
    }

    public void setFrais(BigDecimal frais) {
        this.frais = frais;
    }

    public LocalDateTime getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
    }

    @Override
    public String toString() {
        return "TypeOperation{" +
                "id=" + id +
                ", code='" + code + '\'' +
                ", libelle='" + libelle + '\'' +
                ", frais=" + frais +
                '}';
    }
}