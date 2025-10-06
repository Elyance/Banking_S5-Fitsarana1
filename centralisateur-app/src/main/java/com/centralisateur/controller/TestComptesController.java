package com.centralisateur.controller;

import com.compteCourant.entity.CompteCourant;
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
 * Contrôleur de test pour déboguer les problèmes de liste des comptes
 */
@WebServlet("/test/comptes")
public class TestComptesController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(TestComptesController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            LOGGER.info("=== TEST DONNÉES STATIQUES UNIQUEMENT ===");
            
            // Créer des comptes de test avec des données statiques
            List<CompteCourant> comptesTest = new ArrayList<>();
            
            CompteCourant compte1 = new CompteCourant();
            compte1.setId(1L);
            compte1.setNumeroCompte("CC-001-2025");
            compte1.setClientId(101L);
            compte1.setSolde(new BigDecimal("2500.75"));
            compte1.setDecouvertAutorise(new BigDecimal("500.00"));
            compte1.setDateCreation(LocalDateTime.now().minusDays(30));
            compte1.setDateModification(LocalDateTime.now().minusDays(1));
            comptesTest.add(compte1);
            
            CompteCourant compte2 = new CompteCourant();
            compte2.setId(2L);
            compte2.setNumeroCompte("CC-002-2025");
            compte2.setClientId(102L);
            compte2.setSolde(new BigDecimal("-150.25"));
            compte2.setDecouvertAutorise(new BigDecimal("1000.00"));
            compte2.setDateCreation(LocalDateTime.now().minusDays(20));
            compte2.setDateModification(LocalDateTime.now().minusHours(3));
            comptesTest.add(compte2);
            
            CompteCourant compte3 = new CompteCourant();
            compte3.setId(3L);
            compte3.setNumeroCompte("CC-003-2025");
            compte3.setClientId(103L);
            compte3.setSolde(new BigDecimal("10000.00"));
            compte3.setDecouvertAutorise(new BigDecimal("0.00"));
            compte3.setDateCreation(LocalDateTime.now().minusDays(10));
            compte3.setDateModification(LocalDateTime.now());
            comptesTest.add(compte3);
            
            LOGGER.info("Comptes statiques créés: " + comptesTest.size());
            
            // Log des données pour vérification
            for (CompteCourant compte : comptesTest) {
                LOGGER.info("Compte ID=" + compte.getId() + 
                           ", Numéro=" + compte.getNumeroCompte() + 
                           ", ClientId=" + compte.getClientId() + 
                           ", Solde=" + compte.getSolde() + 
                           ", Découvert=" + compte.getDecouvertAutorise());
            }
            
            // Ajouter les attributs pour la JSP
            request.setAttribute("comptes", comptesTest);
            request.setAttribute("sourceData", "Données statiques de test UNIQUEMENT");
            request.setAttribute("nombreComptes", comptesTest.size());
            request.setAttribute("testMode", true);
            
            LOGGER.info("=== Envoi vers JSP: " + comptesTest.size() + " comptes statiques ===");
            
            // Rediriger vers la JSP
            request.getRequestDispatcher("/compte_courant/liste.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur dans TestComptesController", e);
            request.setAttribute("error", "Erreur lors du test: " + e.getMessage());
            request.setAttribute("comptes", new ArrayList<>());
            request.getRequestDispatcher("/compte_courant/liste.jsp").forward(request, response);
        }
    }
}