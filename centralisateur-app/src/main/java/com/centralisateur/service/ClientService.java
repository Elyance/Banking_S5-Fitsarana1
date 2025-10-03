package com.centralisateur.service;

import com.centralisateur.entity.Client;
import com.centralisateur.entity.MvtClient;
import com.centralisateur.entity.StatutClient;
import com.centralisateur.repository.ClientRepository;
import com.centralisateur.repository.MvtClientRepository;
import com.centralisateur.repository.StatutClientRepository;


import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import java.time.LocalDateTime;

@Stateless
public class ClientService {

    @EJB
    private ClientRepository clientRepository;

    @EJB
    private MvtClientRepository mvtClientRepository;

    @EJB
    private StatutClientRepository statutClientRepository;

    
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public Client enregistrerNouveauClient(Client client) {
        // Validation de l'objet client
        if (client == null) {
            throw new IllegalArgumentException("L'objet client est obligatoire");
        }
        
        // Validation des propriétés obligatoires
        if (client.getNom() == null || client.getNom().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom est obligatoire");
        }
        if (client.getPrenom() == null || client.getPrenom().trim().isEmpty()) {
            throw new IllegalArgumentException("Le prénom est obligatoire");
        }
        if (client.getEmail() == null || client.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("L'email est obligatoire");
        }
        if (client.getTelephone() == null || client.getTelephone().trim().isEmpty()) {
            throw new IllegalArgumentException("Le téléphone est obligatoire");
        }

        // Nettoyer les données
        client.setNom(client.getNom().trim());
        client.setPrenom(client.getPrenom().trim());
        client.setEmail(client.getEmail().trim().toLowerCase());
        client.setTelephone(client.getTelephone().trim());

        // Vérifier que l'email n'existe pas déjà
        Client existingClient = clientRepository.findByEmail(client.getEmail());
        if (existingClient != null) {
            throw new IllegalArgumentException("Un client avec cet email existe déjà");
        }

        // Récupérer le statut ACTIF
        StatutClient statutActif = statutClientRepository.findByLibelle("ACTIF");
        if (statutActif == null) {
            throw new IllegalStateException("Le statut ACTIF n'existe pas dans la base de données");
        }

        // Assigner le statut ACTIF au client
        client.setStatutClientId(statutActif.getId());

        // S'assurer que les dates sont définies
        if (client.getDateCreation() == null) {
            client.setDateCreation(LocalDateTime.now());
        }
        if (client.getDateModification() == null) {
            client.setDateModification(LocalDateTime.now());
        }

        // Sauvegarder le client
        Client clientSauvegarde = clientRepository.save(client);

        // Créer le mouvement de statut client
        MvtClient mvtClient = new MvtClient();
        mvtClient.setClientId(clientSauvegarde.getId());
        mvtClient.setStatutClientId(statutActif.getId());
        mvtClient.setDateMouvement(LocalDateTime.now());
        mvtClient.setMotif("Création du client");

        mvtClientRepository.save(mvtClient);

        return clientSauvegarde;
    }
    
    public StatutClient getStatutActuelClient(Long clientId) {
        if (clientId == null) {
            throw new IllegalArgumentException("L'ID du client est obligatoire");
        }

        Client client = clientRepository.findById(clientId);
        if (client == null) {
            throw new IllegalArgumentException("Client non trouvé avec l'ID: " + clientId);
        }

        // Récupérer le statut via l'ID du statut
        StatutClient statut = statutClientRepository.findById(client.getStatutClientId());
        if (statut == null) {
            throw new IllegalStateException("Statut client non trouvé pour le client ID: " + clientId);
        }

        return statut;
    }

    /**
     * Récupère un client par son ID
     * 
     * @param clientId L'ID du client
     * @return Le client trouvé
     * @throws IllegalArgumentException Si le client n'existe pas
     */
    public Client getClientById(Long clientId) {
        if (clientId == null) {
            throw new IllegalArgumentException("L'ID du client est obligatoire");
        }

        Client client = clientRepository.findById(clientId);
        if (client == null) {
            throw new IllegalArgumentException("Client non trouvé avec l'ID: " + clientId);
        }

        return client;
    }

    
}