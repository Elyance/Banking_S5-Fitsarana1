package com.centralisateur.controller;

import com.centralisateur.entity.Client;
import com.centralisateur.service.ClientService;
import com.centralisateur.service.CompteCourantIntegrationService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Contrôleur pour la création de comptes courants
 */
@WebServlet("/compte-courant/creer")
public class CreationCompteCourantController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CreationCompteCourantController.class.getName());

    @Inject
    private ClientService clientService;

    @Inject
    private CompteCourantIntegrationService compteCourantService;

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

            LOGGER.info("Affichage du formulaire de création de compte généralisé. Nombre de clients : " + clients.size());

            // Utiliser le nouveau JSP généralisé avec le layout
            request.setAttribute("pageTitle", "Création de Compte Courant");
            request.setAttribute("contentPage", "/compte_courant/creation.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de l'affichage du formulaire de création de compte", e);
            request.setAttribute("error", "Erreur lors du chargement des données : " + e.getMessage());
            request.setAttribute("pageTitle", "Erreur - Création de Compte Courant");
            request.setAttribute("contentPage", "/compte_courant/creation.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);    
        }
    }

    /**
     * Traite la création du compte courant
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Récupération des paramètres
        String clientIdStr = request.getParameter("clientId");
        String numeroCompte = request.getParameter("numeroCompte");
        String decouvertAutoriseStr = request.getParameter("decouvertAutorise");

        try {
            // Validation des paramètres
            if (clientIdStr == null || clientIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Veuillez sélectionner un client");
            }

            if (numeroCompte == null || numeroCompte.trim().isEmpty()) {
                throw new IllegalArgumentException("Le numéro de compte est obligatoire");
            }

            // Validation du numéro de compte
            numeroCompte = numeroCompte.trim().toUpperCase();
            if (!numeroCompte.matches("[A-Z0-9]{10,20}")) {
                throw new IllegalArgumentException("Le numéro de compte doit contenir entre 10 et 20 caractères alphanumériques");
            }

            // Conversion des paramètres
            Long clientId;
            try {
                clientId = Long.parseLong(clientIdStr);
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("ID client invalide");
            }

            // Vérifier que le client existe
            Client client = clientService.getClientById(clientId);
            if (client == null) {
                throw new IllegalArgumentException("Client introuvable avec l'ID : " + clientId);
            }
            if (clientService.getStatutActuelClient(clientId).getId() != 1) {
                throw new IllegalArgumentException("Le client n'est pas actif");
            }

            // Découvert autorisé (optionnel)
            BigDecimal decouvertAutorise = BigDecimal.ZERO;
            if (decouvertAutoriseStr != null && !decouvertAutoriseStr.trim().isEmpty()) {
                try {
                    decouvertAutorise = new BigDecimal(decouvertAutoriseStr);
                    if (decouvertAutorise.compareTo(BigDecimal.ZERO) < 0) {
                        throw new IllegalArgumentException("Le découvert autorisé ne peut pas être négatif");
                    }
                    if (decouvertAutorise.compareTo(new BigDecimal("10000")) > 0) {
                        throw new IllegalArgumentException("Le découvert autorisé ne peut pas dépasser 10 000€");
                    }
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException("Montant du découvert autorisé invalide");
                }
            }

            LOGGER.info(String.format("Tentative de création de compte : clientId=%d, numeroCompte=%s, decouvert=%.2f", 
                       clientId, numeroCompte, decouvertAutorise));

            // Créer le compte courant via le service d'intégration
            Object compteCreé = compteCourantService.creerCompteCourant(numeroCompte, clientId, decouvertAutorise);

            // Succès
            request.setAttribute("success", 
                String.format("Compte courant créé avec succès pour %s (N° %s)", 
                             client.getNomComplet(), numeroCompte));
            request.setAttribute("compteCreé", compteCreé);

            LOGGER.info(String.format("Compte courant créé avec succès : %s pour client %d", 
                       numeroCompte, clientId));

            // Recharger la liste des clients pour le formulaire
            List<Client> clients = clientService.getAllClients();
            request.setAttribute("clients", clients);

            // Rediriger vers la page avec le message de succès en utilisant le layout
            request.setAttribute("pageTitle", "Création de Compte - Succès");
            request.setAttribute("contentPage", "/compte_courant/creation.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            // Erreurs de validation
            LOGGER.log(Level.WARNING, "Erreur de validation lors de la création de compte", e);
            request.setAttribute("error", e.getMessage());
            
            // Recharger la liste des clients et garder les valeurs saisies
            try {
                List<Client> clients = clientService.getAllClients();
                request.setAttribute("clients", clients);
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Erreur lors du rechargement des clients", ex);
            }

            request.setAttribute("pageTitle", "Erreur - Création de Compte");
            request.setAttribute("contentPage", "/compte_courant/creation.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);

        } catch (Exception e) {
            // Erreurs techniques
            LOGGER.log(Level.SEVERE, "Erreur technique lors de la création de compte", e);
            
            String errorMessage = "Erreur technique lors de la création du compte";
            if (e.getMessage() != null && !e.getMessage().isEmpty()) {
                errorMessage += " : " + e.getMessage();
            }
            
            request.setAttribute("error", errorMessage);

            // Recharger la liste des clients
            try {
                List<Client> clients = clientService.getAllClients();
                request.setAttribute("clients", clients);
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Erreur lors du rechargement des clients", ex);
            }

            request.setAttribute("pageTitle", "Erreur - Création de Compte");
            request.setAttribute("contentPage", "/compte_courant/creation.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);
        }
    }
}