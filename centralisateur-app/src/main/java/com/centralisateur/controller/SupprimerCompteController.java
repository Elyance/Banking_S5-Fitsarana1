package com.centralisateur.controller;

import com.centralisateur.service.CompteCourantIntegrationService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * Contrôleur pour la suppression d'un compte courant
 */
@WebServlet("/compte-courant/supprimer")
public class SupprimerCompteController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SupprimerCompteController.class.getName());

    @Inject
    private CompteCourantIntegrationService compteCourantService;

    /**
     * Gère la suppression d'un compte courant
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Récupérer les paramètres
            String compteIdParam = request.getParameter("compteId");
            String confirmeParam = request.getParameter("confirme");
            
            // Vérifications de sécurité
            if (compteIdParam == null || compteIdParam.isEmpty()) {
                throw new IllegalArgumentException("ID du compte manquant");
            }
            
            if (!"true".equals(confirmeParam)) {
                throw new IllegalArgumentException("Suppression non confirmée");
            }
            
            Long compteId = Long.parseLong(compteIdParam);
            LOGGER.info("=== Tentative de suppression du compte ID: " + compteId + " ===");
            
            // Vérifier que le compte existe avant de le supprimer
            var compte = compteCourantService.getCompteParId(compteId);
            if (compte == null) {
                throw new IllegalArgumentException("Compte introuvable avec l'ID: " + compteId);
            }
            
            String numeroCompte = compte.getNumeroCompte();
            LOGGER.info("Suppression du compte: " + numeroCompte);
            
            // Effectuer la suppression
            boolean resultat = compteCourantService.supprimerCompteCourant(compteId);
            
            if (resultat) {
                LOGGER.info("=== Suppression réussie du compte " + numeroCompte + " ===");
                
                // Rediriger vers la liste avec un message de succès
                request.getSession().setAttribute("successMessage", 
                    "Le compte " + numeroCompte + " a été supprimé avec succès.");
                response.sendRedirect(request.getContextPath() + "/compte-courant/liste");
                
            } else {
                LOGGER.warning("=== Échec de la suppression du compte " + numeroCompte + " ===");
                
                // Rediriger vers les détails avec un message d'erreur
                request.getSession().setAttribute("errorMessage", 
                    "Impossible de supprimer le compte " + numeroCompte + ". Veuillez réessayer.");
                response.sendRedirect(request.getContextPath() + "/compte-courant/detail?id=" + compteId);
            }
            
        } catch (NumberFormatException e) {
            LOGGER.severe("Format d'ID invalide : " + e.getMessage());
            request.getSession().setAttribute("errorMessage", "Format d'ID invalide");
            response.sendRedirect(request.getContextPath() + "/compte-courant/liste");
            
        } catch (IllegalArgumentException e) {
            LOGGER.severe("Erreur de paramètre : " + e.getMessage());
            request.getSession().setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/compte-courant/liste");
            
        } catch (Exception e) {
            LOGGER.severe("Erreur lors de la suppression du compte : " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", 
                "Erreur technique lors de la suppression : " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/compte-courant/liste");
        }
    }
    
    /**
     * Rediriger les requêtes GET vers la liste des comptes
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Les suppressions doivent se faire uniquement en POST
        request.getSession().setAttribute("errorMessage", 
            "Action non autorisée. Utilisez le bouton de suppression depuis la page de détail.");
        response.sendRedirect(request.getContextPath() + "/compte-courant/liste");
    }
}