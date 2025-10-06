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
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Contrôleur pour tester la méthode getTousLesComptesAsArray()
 */
@WebServlet("/test/array")
public class TestArrayController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(TestArrayController.class.getName());

    @Inject
    private CompteCourantIntegrationService compteCourantService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            LOGGER.info("=== TEST MÉTHODE getTousLesComptesAsArray() ===");
            
            // Test avec la méthode Array qui retourne des objets reconstruits
            List<CompteCourant> comptesArray = compteCourantService.getTousLesComptesAsArray();
            
            LOGGER.info("Comptes récupérés via Array: " + comptesArray.size());
            
            for (CompteCourant compte : comptesArray) {
                LOGGER.info("Array - Compte: " + compte.toString());
            }
            
            // Créer aussi des données de test pour comparaison
            List<CompteCourant> comptesTest = new ArrayList<>();
            
            CompteCourant compte1 = new CompteCourant();
            compte1.setId(999L);
            compte1.setNumeroCompte("TEST-999");
            compte1.setClientId(999L);
            compte1.setSolde(new BigDecimal("999.99"));
            compte1.setDecouvertAutorise(new BigDecimal("100.00"));
            compte1.setDateCreation(LocalDateTime.now());
            compte1.setDateModification(LocalDateTime.now());
            comptesTest.add(compte1);
            
            // Ajouter les deux listes à la JSP
            request.setAttribute("comptes", comptesTest);
            request.setAttribute("comptesReels", comptesArray);
            request.setAttribute("sourceData", "Test méthode Array vs données statiques");
            request.setAttribute("nombreComptes", comptesTest.size());
            request.setAttribute("nombreComptesReels", comptesArray.size());
            request.setAttribute("testMode", true);
            
            LOGGER.info("=== Envoi vers JSP ===");
            
            // Rediriger vers la JSP
            request.getRequestDispatcher("/compte_courant/liste.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur dans TestArrayController", e);
            request.setAttribute("error", "Erreur lors du test Array: " + e.getMessage());
            request.setAttribute("comptes", new ArrayList<>());
            request.getRequestDispatcher("/compte_courant/liste.jsp").forward(request, response);
        }
    }
}