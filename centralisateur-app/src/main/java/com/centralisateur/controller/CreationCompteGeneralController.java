package com.centralisateur.controller;

import com.centralisateur.entity.Client;
import com.centralisateur.service.ClientService;
import com.centralisateur.service.ComptePretIntegrationService;
import com.banque.dto.TypePaiementDTO;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Contrôleur généralisé pour la création de comptes bancaires
 * Gère l'affichage du formulaire de sélection de type de compte
 */
@WebServlet("/comptes/creer")
public class CreationCompteGeneralController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CreationCompteGeneralController.class.getName());

    @Inject
    private ClientService clientService;

    @Inject
    private ComptePretIntegrationService comptePretService;

    /**
     * Affiche le formulaire de création de compte généralisé
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Récupérer la liste des clients pour le formulaire
            List<Client> clients = clientService.getAllClients();
            request.setAttribute("clients", clients);

            // Récupérer les types de paiement pour le formulaire de prêt
            try {
                List<TypePaiementDTO> typesPaiement = comptePretService.getAllTypesPaiement();
                request.setAttribute("typesPaiement", typesPaiement);
                LOGGER.info("Types de paiement chargés : " + typesPaiement.size());
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Erreur lors du chargement des types de paiement", e);
                // Continuer sans les types de paiement (formulaire de prêt désactivé)
                request.setAttribute("typesPaiement", new ArrayList<TypePaiementDTO>());
            }

            // Vérifier s'il y a un client pré-sélectionné
            String clientIdParam = request.getParameter("clientId");
            if (clientIdParam != null && !clientIdParam.trim().isEmpty()) {
                try {
                    Long clientId = Long.parseLong(clientIdParam);
                    Client selectedClient = clientService.getClientById(clientId);
                    if (selectedClient != null) {
                        request.setAttribute("selectedClientId", clientId);
                        request.setAttribute("selectedClient", selectedClient);
                        LOGGER.info("Client pré-sélectionné : " + selectedClient.getNomComplet());
                    }
                } catch (NumberFormatException e) {
                    LOGGER.warning("ID client invalide fourni : " + clientIdParam);
                }
            }

            LOGGER.info("Affichage du formulaire de création de compte généralisé. Nombre de clients : " + clients.size());

            // Utiliser le nouveau JSP généralisé avec le layout
            request.setAttribute("pageTitle", "Création de Compte");
            request.setAttribute("contentPage", "/creation-compte.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de l'affichage du formulaire de création de compte", e);
            request.setAttribute("error", "Erreur lors du chargement des données : " + e.getMessage());
            request.setAttribute("pageTitle", "Erreur - Création de Compte");
            request.setAttribute("contentPage", "/creation-compte.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);
        }
    }

    /**
     * Redirection des requêtes POST vers les contrôleurs spécialisés
     * (Cette méthode ne devrait pas être appelée directement)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Les formulaires pointent directement vers les contrôleurs spécialisés
        // Cette méthode est un fallback au cas où
        
        String accountType = request.getParameter("accountType");
        LOGGER.warning("Requête POST reçue sur le contrôleur général pour le type : " + accountType);
        
        if ("courant".equals(accountType)) {
            request.getRequestDispatcher("/compte-courant/creer").forward(request, response);
        } else if ("pret".equals(accountType)) {
            request.getRequestDispatcher("/compte-pret/creer").forward(request, response);
        } else {
            // Type de compte non reconnu
            request.setAttribute("error", "Type de compte non reconnu : " + accountType);
            doGet(request, response);
        }
    }

    
}