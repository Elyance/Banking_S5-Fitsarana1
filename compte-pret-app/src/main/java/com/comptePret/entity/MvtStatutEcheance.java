package com.comptePret.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.sql.Timestamp;

@Entity
@Table(name = "mvt_statut_echeance")
public class MvtStatutEcheance implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "echeance_id", nullable = false)
    private Echeances echeance;

    @ManyToOne
    @JoinColumn(name = "statut_echeance_id", nullable = false)
    private StatutEcheance statutEcheance;

    @Column(name = "date_changement")
    private Timestamp dateChangement;

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Echeances getEcheance() { return echeance; }
    public void setEcheance(Echeances echeance) { this.echeance = echeance; }
    public StatutEcheance getStatutEcheance() { return statutEcheance; }
    public void setStatutEcheance(StatutEcheance statutEcheance) { this.statutEcheance = statutEcheance; }
    public Timestamp getDateChangement() { return dateChangement; }
    public void setDateChangement(Timestamp dateChangement) { this.dateChangement = dateChangement; }
}
