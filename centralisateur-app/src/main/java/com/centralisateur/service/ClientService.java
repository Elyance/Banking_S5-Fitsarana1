package com.centralisateur.service;

import com.centralisateur.entity.Client;
import com.centralisateur.entity.MvtClient;
import com.centralisateur.entity.StatutClient;
import com.centralisateur.repository.ClientRepository;
import com.centralisateur.repository.MvtClientRepository;
import com.centralisateur.repository.StatutClientRepository;

import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.inject.Inject;

import java.time.LocalDateTime;

@Stateless
public class ClientService {

    @Inject
    private ClientRepository clientRepository;

    @Inject
    private MvtClientRepository mvtClientRepository;

    @Inject
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

        // Générer le numéro client avant la sauvegarde
        String numeroClient = generateNumeroClient();
        client.setNumeroClient(numeroClient);

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
        mvtClient.setDateMvt(LocalDateTime.now());
        mvtClient.setDescription("Création du client");

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

        // Récupérer le dernier mouvement de statut pour ce client
        MvtClient dernierMouvement = mvtClientRepository.findTopByClientIdOrderByDateMvtDesc(clientId);
        if (dernierMouvement == null) {
            throw new IllegalStateException("Aucun statut trouvé pour le client ID: " + clientId);
        }

        // Récupérer le statut via l'ID du statut du dernier mouvement
        StatutClient statut = statutClientRepository.findById(dernierMouvement.getStatutClientId());
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

    /**
     * Récupère tous les clients
     * 
     * @return Liste de tous les clients
     */
    public java.util.List<Client> getAllClients() {
        return clientRepository.findAll();
    }

    /**
     * Recherche des clients par nom (contient)
     * 
     * @param nom Le nom à rechercher
     * @return Liste des clients trouvés
     */
    public java.util.List<Client> searchClientsByNom(String nom) {
        if (nom == null || nom.trim().isEmpty()) {
            return getAllClients();
        }
        return clientRepository.findByNomContaining(nom.trim());
    }

    /**
     * Recherche un client par email
     * 
     * @param email L'email à rechercher
     * @return Le client trouvé ou null
     */
    public Client findClientByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }
        return clientRepository.findByEmail(email.trim().toLowerCase());
    }

    /**
     * Recherche un client par numéro client
     * 
     * @param numeroClient Le numéro client à rechercher
     * @return Le client trouvé ou null
     */
    public Client findClientByNumeroClient(String numeroClient) {
        if (numeroClient == null || numeroClient.trim().isEmpty()) {
            return null;
        }
        return clientRepository.findByNumeroClient(numeroClient.trim().toUpperCase());
    }

    /**
     * Compte le nombre total de clients
     * 
     * @return Le nombre total de clients
     */
    public long countClients() {
        return clientRepository.count();
    }

    /**
     * Met à jour les informations d'un client existant
     * 
     * @param client Le client avec les nouvelles informations
     * @return Le client mis à jour
     * @throws IllegalArgumentException Si le client est null ou n'existe pas
     */
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public Client updateClient(Client client) {
        // Validation de l'objet client
        if (client == null) {
            throw new IllegalArgumentException("L'objet client est obligatoire");
        }
        
        if (client.getId() == null) {
            throw new IllegalArgumentException("L'ID du client est obligatoire pour la mise à jour");
        }
        
        // Vérifier que le client existe
        Client clientExistant = clientRepository.findById(client.getId());
        if (clientExistant == null) {
            throw new IllegalArgumentException("Client non trouvé avec l'ID: " + client.getId());
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

        // Vérifier que l'email n'existe pas déjà pour un autre client
        Client clientAvecEmail = clientRepository.findByEmail(client.getEmail());
        if (clientAvecEmail != null && !clientAvecEmail.getId().equals(client.getId())) {
            throw new IllegalArgumentException("Un autre client utilise déjà cet email");
        }

        // Mettre à jour la date de modification
        client.setDateModification(java.time.LocalDateTime.now());

        // Conserver les données système importantes du client existant
        client.setDateCreation(clientExistant.getDateCreation());
        client.setNumeroClient(clientExistant.getNumeroClient()); // Conserver le numéro client existant

        // Sauvegarder les modifications
        Client clientMisAJour = clientRepository.save(client);

        // Récupérer le statut actuel via les mouvements
        MvtClient dernierMouvement = mvtClientRepository.findTopByClientIdOrderByDateMvtDesc(clientMisAJour.getId());
        Long statutClientId = null;
        if (dernierMouvement != null) {
            statutClientId = dernierMouvement.getStatutClientId();
        } else {
            // Si aucun mouvement trouvé, utiliser le statut ACTIF par défaut
            StatutClient statutActif = statutClientRepository.findByLibelle("ACTIF");
            if (statutActif != null) {
                statutClientId = statutActif.getId();
            }
        }

        // Créer un mouvement pour tracer la modification
        if (statutClientId != null) {
            MvtClient mvtClient = new MvtClient();
            mvtClient.setClientId(clientMisAJour.getId());
            mvtClient.setStatutClientId(statutClientId);
            mvtClient.setDateMvt(java.time.LocalDateTime.now());
            mvtClient.setDescription("Modification des informations du client");

            mvtClientRepository.save(mvtClient);
        }

        return clientMisAJour;
    }

    /**
     * Génère un numéro client unique
     * Format: CLI-YYYYMMDD-XXXXX
     * 
     * @return Le numéro client généré
     */
    private String generateNumeroClient() {
        // Format de date pour le numéro client
        String dateStr = LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd"));
        
        // Compter le nombre de clients créés aujourd'hui pour générer un séquentiel
        long todayCount = clientRepository.count() + 1;
        
        // Format: CLI-YYYYMMDD-XXXXX (avec padding sur 5 chiffres)
        return String.format("CLI-%s-%05d", dateStr, todayCount);
    }

    
}
