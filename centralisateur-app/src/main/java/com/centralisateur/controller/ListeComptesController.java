package com.centralisateur.controller;

import com.centralisateur.service.CompteCourantIntegrationService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Contrôleur pour lister les comptes courants
 */
@WebServlet("/compte-courant/liste")
public class ListeComptesController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ListeComptesController.class.getName());

    @Inject
    private CompteCourantIntegrationService compteCourantService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Récupérer tous les comptes courants
            List<?> comptes = compteCourantService.getTousLesComptes();
            request.setAttribute("comptes", comptes);

            // Calculer les statistiques
            long totalComptes = compteCourantService.getNombreTotalComptes();
            request.setAttribute("totalComptes", totalComptes);

            // Note: Ces statistiques nécessiteraient des méthodes supplémentaires dans le service
            request.setAttribute("comptesActifs", totalComptes); // Temporaire
            request.setAttribute("soldeTotal", 0.0); // Temporaire
            request.setAttribute("comptesEnDecouvert", 0); // Temporaire

            LOGGER.info("Affichage de la liste des comptes courants. Total : " + totalComptes);

            request.getRequestDispatcher("/compte_courant/liste-comptes.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la récupération de la liste des comptes", e);
            request.setAttribute("error", "Erreur lors du chargement des comptes : " + e.getMessage());
            request.getRequestDispatcher("/compte_courant/liste-comptes.jsp").forward(request, response);
        }
    }
}