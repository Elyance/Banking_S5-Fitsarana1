package com.banque.dto;

import java.io.Serializable;

/**
 * DTO pour les types de paiement
 * Utilisé pour la communication entre applications
 */
public class TypePaiementDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String libelle;
    private Integer valeur; // Nombre de mois dans la période
    private String description;

    // Constructeurs
    public TypePaiementDTO() {}

    public TypePaiementDTO(Long id, String libelle, Integer valeur, String description) {
        this.id = id;
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

    // Méthodes utilitaires
    @Override
    public String toString() {
        return "TypePaiementDTO{" +
                "id=" + id +
                ", libelle='" + libelle + '\'' +
                ", valeur=" + valeur +
                ", description='" + description + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof TypePaiementDTO)) return false;
        TypePaiementDTO that = (TypePaiementDTO) o;
        return id != null && id.equals(that.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }

    /**
     * Méthode utilitaire pour formater l'affichage
     */
    public String getAffichage() {
        return libelle + " (" + valeur + " mois)";
    }

    /**
     * Méthode utilitaire pour obtenir la fréquence par an
     */
    public int getFrequenceParAn() {
        if (valeur == null || valeur <= 0) {
            return 0;
        }
        return 12 / valeur;
    }
}