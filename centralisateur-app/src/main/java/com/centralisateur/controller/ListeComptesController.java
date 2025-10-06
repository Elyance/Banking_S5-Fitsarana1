package com.centralisateur.controller;

import com.centralisateur.service.CompteCourantIntegrationService;
import com.compteCourant.entity.CompteCourant;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Contrôleur pour l'affichage de la liste des comptes courants
 */
@WebServlet("/compte-courant/liste")
public class ListeComptesController extends HttpServlet {

    @Inject
    private CompteCourantIntegrationService compteCourantService;

    /**
     * Affiche la liste de tous les comptes courants
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Récupérer tous les comptes courants via la méthode Array
            List<CompteCourant> comptes = compteCourantService.getTousLesComptesAsArray();
            
            // Ajouter les données à la requête
            request.setAttribute("comptes", comptes);

            // Rediriger vers la page de liste
            request.getRequestDispatcher("/compte_courant/liste.jsp").forward(request, response);
            
        } catch (Exception e) {
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