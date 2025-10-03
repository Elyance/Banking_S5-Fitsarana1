package com.centralisateur.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entité représentant l'historique des changements de statut d'un client
 * Permet de tracer tous les changements (ACTIF -> SUSPENDU par exemple)
 */
@Entity
@Table(name = "mvt_client")
public class MvtClient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "client_id", nullable = false)
    private Long clientId;

    @Column(name = "statut_client_id", nullable = false)
    private Long statutClientId;

    @Column(name = "description")
    private String description;

    @Column(name = "date_mvt", nullable = false)
    private LocalDateTime dateMvt;

    // Relations JPA (optionnelles - pour plus de simplicité on peut utiliser les IDs)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "client_id", insertable = false, updatable = false)
    private Client client;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "statut_client_id", insertable = false, updatable = false)
    private StatutClient statutClient;

    // Constructeurs
    public MvtClient() {
        this.dateMvt = LocalDateTime.now();
    }

    public MvtClient(Long clientId, Long statutClientId, String description) {
        this();
        this.clientId = clientId;
        this.statutClientId = statutClientId;
        this.description = description;
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getClientId() {
        return clientId;
    }

    public void setClientId(Long clientId) {
        this.clientId = clientId;
    }

    public Long getStatutClientId() {
        return statutClientId;
    }

    public void setStatutClientId(Long statutClientId) {
        this.statutClientId = statutClientId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getDateMvt() {
        return dateMvt;
    }

    public void setDateMvt(LocalDateTime dateMvt) {
        this.dateMvt = dateMvt;
    }

    public Client getClient() {
        return client;
    }

    public void setClient(Client client) {
        this.client = client;
    }

    public StatutClient getStatutClient() {
        return statutClient;
    }

    public void setStatutClient(StatutClient statutClient) {
        this.statutClient = statutClient;
        if (statutClient != null) {
            this.statutClientId = statutClient.getId();
        }
    }

    // Méthodes utilitaires pour compatibilité
    public LocalDateTime getDateMouvement() {
        return dateMvt;
    }

    public void setDateMouvement(LocalDateTime dateMouvement) {
        this.dateMvt = dateMouvement;
    }

    public String getMotif() {
        return description;
    }

    public void setMotif(String motif) {
        this.description = motif;
    }

    // Méthodes utilitaires
    @Override
    public String toString() {
        return "MvtClient{" +
                "id=" + id +
                ", clientId=" + clientId +
                ", statutClientId=" + statutClientId +
                ", description='" + description + '\'' +
                ", dateMvt=" + dateMvt +
                '}';
    }
}