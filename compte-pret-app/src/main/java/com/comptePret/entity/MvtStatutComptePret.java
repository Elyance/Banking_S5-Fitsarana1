package com.comptePret.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Entité représentant un mouvement de statut de compte prêt
 */
@Entity
@Table(name = "mvt_statut_compte_pret")
public class MvtStatutComptePret implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "compte_pret_id", nullable = false)
    private ComptePret comptePret;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "statut_compte_pret_id", nullable = false)
    private StatutComptePret statutComptePret;

    @Column(name = "date_changement", nullable = false)
    private LocalDateTime dateChangement;

    @Column(name = "commentaire")
    private String commentaire;

    // Constructeurs
    public MvtStatutComptePret() {
        this.dateChangement = LocalDateTime.now();
    }

    public MvtStatutComptePret(ComptePret comptePret, StatutComptePret statutComptePret, String commentaire) {
        this();
        this.comptePret = comptePret;
        this.statutComptePret = statutComptePret;
        this.commentaire = commentaire;
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public ComptePret getComptePret() {
        return comptePret;
    }

    public void setComptePret(ComptePret comptePret) {
        this.comptePret = comptePret;
    }

    public StatutComptePret getStatutComptePret() {
        return statutComptePret;
    }

    public void setStatutComptePret(StatutComptePret statutComptePret) {
        this.statutComptePret = statutComptePret;
    }

    public LocalDateTime getDateChangement() {
        return dateChangement;
    }

    public void setDateChangement(LocalDateTime dateChangement) {
        this.dateChangement = dateChangement;
    }

    public String getCommentaire() {
        return commentaire;
    }

    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }

    @PrePersist
    protected void onCreate() {
        if (dateChangement == null) {
            dateChangement = LocalDateTime.now();
        }
    }

    // Méthodes utilitaires
    @Override
    public String toString() {
        return "MvtStatutComptePret{" +
                "id=" + id +
                ", comptePretId=" + (comptePret != null ? comptePret.getId() : null) +
                ", statutComptePretId=" + (statutComptePret != null ? statutComptePret.getId() : null) +
                ", dateChangement=" + dateChangement +
                ", commentaire='" + commentaire + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof MvtStatutComptePret)) return false;
        MvtStatutComptePret that = (MvtStatutComptePret) o;
        return id != null && id.equals(that.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}