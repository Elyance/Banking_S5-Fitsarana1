package com.centralisateur.service;

import com.comptePret.interfaceRemote.ComptePretServiceRemote;
import com.banque.dto.TypePaiementDTO;
import com.banque.dto.ComptePretStatutDTO;
import com.comptePret.entity.ComptePret;
import jakarta.ejb.EJB;
import jakarta.enterprise.context.ApplicationScoped;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Service d'intégration avec le module compte-pret
 * Utilise l'EJB distant pour les opérations sur les comptes prêts
 */
@ApplicationScoped
public class ComptePretIntegrationService {

    // Injection de l'EJB distant via lookup JNDI
    @EJB(lookup = "java:global/compte-pret-app/ComptePretService!com.comptePret.interfaceRemote.ComptePretServiceRemote")
    private ComptePretServiceRemote comptePretService;

    /**
     * Récupère tous les types de paiement disponibles
     * Convertit les entités en DTO pour éviter les problèmes de sérialisation
     */
    public List<TypePaiementDTO> getAllTypesPaiement() {
        try {
            // Utilise Object car TypePaiement n'est pas accessible ici
            List<TypePaiementDTO> typesPaiement = comptePretService.getAllTypesPaiement();
            List<TypePaiementDTO> typesPaiementDTO = new ArrayList<>();

            for (TypePaiementDTO tp : typesPaiement) {
                // Utilise la réflexion pour accéder aux propriétés
                try {
                    Long id = tp.getId();
                    String libelle = tp.getLibelle();
                    Integer valeur = tp.getValeur();
                    String description = tp.getDescription();

                    TypePaiementDTO dto = new TypePaiementDTO(id, libelle, valeur, description);
                    typesPaiementDTO.add(dto);
                } catch (Exception reflectException) {
                    throw new RuntimeException("Erreur lors de la conversion des données TypePaiement", reflectException);
                }
            }

            return typesPaiementDTO;
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération des types de paiement: " + e.getMessage(), e);
        }
    }

    /**
     * Crée un nouveau compte prêt
     */
    public ComptePret creerComptePret(String numeroCompte, Long clientId, BigDecimal montantEmprunte,
                                BigDecimal tauxInteret, Integer dureeTotaleMois, LocalDate dateDebut,
                                Long typePaiementId) {
        try {
            return comptePretService.creerComptePret(numeroCompte, clientId, montantEmprunte,
                    tauxInteret, dureeTotaleMois, dateDebut, typePaiementId);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la création du compte prêt: " + e.getMessage(), e);
        }
    }

    /**
     * Récupère tous les comptes prêt avec leurs types de paiement et statuts
     */
    public List<ComptePretStatutDTO> getAllComptePretWithTypeAndStatut() {
        try {
            return comptePretService.getAllComptePretWithTypeAndStatut();
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération des comptes prêt: " + e.getMessage(), e);
        }
    }

    /**
     * Récupère le statut actuel d'un compte prêt
     */
    public String getStatutActuelComptePret(Long comptePretId) {
        try {
            return comptePretService.getStatutActuelComptePret(comptePretId);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération du statut du compte prêt: " + e.getMessage(), e);
        }
    }

    /**
     * Compte le nombre de comptes prêt d'un client
     */
    public long getNombreComptesPretClient(Long clientId) {
        try {
            return comptePretService.getNombreComptesPretClient(clientId);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du comptage des comptes prêt du client: " + e.getMessage(), e);
        }
    }

    /**
     * Compte le nombre de comptes prêt actifs d'un client
     */
    public long getNombreComptesPretActifsClient(Long clientId) {
        try {
            return comptePretService.countActiveComptesPretByClientId(clientId);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du comptage des comptes prêt actifs du client: " + e.getMessage(), e);
        }
    }
}