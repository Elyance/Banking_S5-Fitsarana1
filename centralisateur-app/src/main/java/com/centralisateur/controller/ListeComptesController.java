package com.centralisateur.controller;

import com.centralisateur.entity.Client;
import com.centralisateur.service.ClientService;
import com.centralisateur.service.CompteCourantIntegrationService;
import com.compteCourant.entity.CompteCourant;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Contrôleur pour l'affichage de la liste des comptes courants
 */
@WebServlet("/compte-courant/liste")
public class ListeComptesController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ListeComptesController.class.getName());

    @Inject
    private CompteCourantIntegrationService compteCourantService;

    @Inject
    private ClientService clientService;

    /**
     * Affiche la liste de tous les comptes courants
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            LOGGER.info("=== DÉBUT - Récupération de la liste des comptes courants ===");
            
            // Test de connexion au service distant
            LOGGER.info("Test de la connexion au service compte-courant...");
            boolean connexionOk = compteCourantService.testerConnexion();
            LOGGER.info("Connexion au service compte-courant : " + (connexionOk ? "OK" : "ÉCHEC"));

            // Récupérer tous les comptes courants
            LOGGER.info("Appel du service pour récupérer tous les comptes...");
            List<CompteCourant> comptes = compteCourantService.getTousLesComptes();
            LOGGER.info("Service appelé - Nombre de comptes retournés : " + (comptes != null ? comptes.size() : "NULL"));
            
            // Log détaillé des comptes
            if (comptes != null && !comptes.isEmpty()) {
                LOGGER.info("=== DÉTAILS DES COMPTES ===");
                for (int i = 0; i < comptes.size(); i++) {
                    CompteCourant compte = comptes.get(i);
                    LOGGER.info(String.format("Compte %d: ID=%s, Numéro=%s, ClientID=%s, Solde=%s, Découvert=%s, DateCréation=%s", 
                        i+1, 
                        compte.getId(), 
                        compte.getNumeroCompte(), 
                        compte.getClientId(), 
                        compte.getSolde(), 
                        compte.getDecouvertAutorise(),
                        compte.getDateCreation()));
                }
                LOGGER.info("=== FIN DÉTAILS DES COMPTES ===");
            } else {
                LOGGER.warning("AUCUN COMPTE TROUVÉ OU LISTE NULL !");
            }
            
            // Créer une map pour associer les ID clients aux objets Client
            LOGGER.info("Récupération de la liste des clients...");
            Map<Long, Client> clientsMap = new HashMap<>();
            try {
                List<Client> clients = clientService.getAllClients();
                LOGGER.info("Nombre de clients récupérés : " + (clients != null ? clients.size() : "NULL"));
                
                if (clients != null) {
                    for (Client client : clients) {
                        clientsMap.put(client.getId(), client);
                        LOGGER.info(String.format("Client ajouté à la map: ID=%s, Nom=%s", 
                            client.getId(), client.getNomComplet()));
                    }
                }
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Erreur lors du chargement des clients", e);
            }

            // Statistiques
            LOGGER.info("Récupération du nombre total de comptes...");
            long nombreTotalComptes = compteCourantService.getNombreTotalComptes();
            LOGGER.info("Nombre total de comptes (statistique) : " + nombreTotalComptes);
            
            // Ajouter les données à la requête
            LOGGER.info("Ajout des attributs à la requête...");
            request.setAttribute("comptes", comptes);
            request.setAttribute("clientsMap", clientsMap);
            request.setAttribute("nombreTotalComptes", nombreTotalComptes);
            
            LOGGER.info("Attributs ajoutés:");
            LOGGER.info("- comptes: " + (comptes != null ? comptes.size() + " éléments" : "NULL"));
            LOGGER.info("- clientsMap: " + clientsMap.size() + " éléments");
            LOGGER.info("- nombreTotalComptes: " + nombreTotalComptes);

            LOGGER.info("Redirection vers la JSP...");
            // Rediriger vers la page de liste
            request.getRequestDispatcher("/compte_courant/liste.jsp").forward(request, response);
            LOGGER.info("=== FIN - Liste des comptes traitée avec succès ===");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "ERREUR CRITIQUE lors de la récupération de la liste des comptes", e);
            LOGGER.severe("Type d'erreur: " + e.getClass().getSimpleName());
            LOGGER.severe("Message d'erreur: " + e.getMessage());
            if (e.getCause() != null) {
                LOGGER.severe("Cause: " + e.getCause().getMessage());
            }
            
            request.setAttribute("error", "Erreur lors du chargement de la liste des comptes : " + e.getMessage());
            request.getRequestDispatcher("/compte_courant/liste.jsp").forward(request, response);
        }
    }

    /**
     * Cette méthode POST n'est plus nécessaire car nous n'avons pas de fonctionnalité de fermeture
     * Mais on peut la garder pour de futures fonctionnalités
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Pour l'instant, rediriger simplement vers la liste
        doGet(request, response);
    }
}