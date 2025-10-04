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
import java.util.logging.Logger;

/**
 * Contrôleur simple pour lister les comptes courants
 */
@WebServlet("/compte-courant/liste")
public class ListeComptesCourantController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ListeComptesCourantController.class.getName());

    @Inject
    private CompteCourantIntegrationService compteCourantService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            LOGGER.info("Récupération de la liste des comptes courants");
            
            // Récupérer tous les comptes courants depuis le service distant
            List<CompteCourant> comptes = compteCourantService.getTousLesComptes();
            LOGGER.info("Nombre de comptes récupérés : " + comptes.size());
            
            // Passer la liste à la JSP
            request.setAttribute("comptes", comptes);
            
        } catch (Exception e) {
            LOGGER.severe("Erreur lors de la récupération des comptes : " + e.getMessage());
            request.setAttribute("error", e.getMessage());
        }
        
        request.getRequestDispatcher("/compte_courant/liste.jsp").forward(request, response);
    }
}