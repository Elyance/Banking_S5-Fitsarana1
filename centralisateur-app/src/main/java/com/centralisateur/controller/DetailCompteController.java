package com.centralisateur.controller;

import com.centralisateur.service.CompteCourantIntegrationService;
import com.centralisateur.service.ClientService;
import com.centralisateur.entity.Client;
import com.centralisateur.dto.CompteAffichageDTO;
import com.compteCourant.entity.CompteCourant;
import jakarta.inject.Inject;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * Contrôleur pour l'affichage des détails d'un compte courant
 */
@WebServlet("/compte-courant/detail")
public class DetailCompteController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DetailCompteController.class.getName());

    @Inject
    private CompteCourantIntegrationService compteCourantService;
    
    @EJB
    private ClientService clientService;

    /**
     * Affiche les détails d'un compte courant
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Récupérer l'ID du compte depuis les paramètres
            String compteIdParam = request.getParameter("id");
            if (compteIdParam == null || compteIdParam.isEmpty()) {
                throw new IllegalArgumentException("ID du compte manquant");
            }
            
            Long compteId = Long.parseLong(compteIdParam);
            LOGGER.info("=== Récupération des détails du compte ID: " + compteId + " ===");
            
            // Récupérer les détails du compte
            CompteCourant compte = compteCourantService.getCompteParId(compteId);
            if (compte == null) {
                throw new IllegalArgumentException("Compte introuvable avec l'ID: " + compteId);
            }
            
            // Créer le DTO pour l'affichage
            CompteAffichageDTO dto = new CompteAffichageDTO();
            
            // Informations du compte
            dto.setCompteId(compte.getId());
            dto.setNumeroCompte(compte.getNumeroCompte());
            dto.setClientId(compte.getClientId());
            dto.setSolde(compte.getSolde());
            dto.setDecouvertAutorise(compte.getDecouvertAutorise());
            dto.setDateCreation(compte.getDateCreation());
            
            // Récupérer le statut réel du compte
            try {
                String statutReel = compteCourantService.getStatutActuelCompte(compteId);
                dto.setStatutCompte(statutReel);
            } catch (Exception e) {
                LOGGER.warning("Erreur lors de la récupération du statut : " + e.getMessage());
                dto.setStatutCompte("ACTIF"); // Par défaut
            }
            
            // Récupérer les informations du client
            try {
                if (compte.getClientId() != null) {
                    Client client = clientService.getClientById(compte.getClientId());
                    if (client != null) {
                        dto.setNomClient(client.getNom());
                        dto.setPrenomClient(client.getPrenom());
                        dto.setEmailClient(client.getEmail());
                    } else {
                        dto.setNomClient("Client introuvable");
                        dto.setPrenomClient("");
                        dto.setEmailClient("");
                    }
                } else {
                    dto.setNomClient("Client non défini");
                    dto.setPrenomClient("");
                    dto.setEmailClient("");
                }
            } catch (Exception e) {
                LOGGER.warning("Erreur lors de la récupération du client " + compte.getClientId() + ": " + e.getMessage());
                dto.setNomClient("Erreur client");
                dto.setPrenomClient("");
                dto.setEmailClient("");
            }
            
            // Calculer des informations supplémentaires
            // Les méthodes getSoldeDisponible() et isEnDecouvert() sont déjà dans le DTO
            
            // Ajouter les données à la requête
            request.setAttribute("compte", dto);
            request.setAttribute("pageTitle", "Détails du compte " + compte.getNumeroCompte());

            LOGGER.info("=== Envoi vers JSP détail: compte " + compte.getNumeroCompte() + " ===");

            // Rediriger vers la page de détail
            request.getRequestDispatcher("/compte_courant/detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            LOGGER.severe("Format d'ID invalide : " + e.getMessage());
            request.setAttribute("error", "Format d'ID invalide");
            request.getRequestDispatcher("/compte_courant/liste").forward(request, response);
        } catch (IllegalArgumentException e) {
            LOGGER.severe("Erreur de paramètre : " + e.getMessage());
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/compte_courant/liste").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Erreur lors du chargement des détails du compte : " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des détails du compte : " + e.getMessage());
            request.getRequestDispatcher("/compte_courant/liste").forward(request, response);
        }
    }
}