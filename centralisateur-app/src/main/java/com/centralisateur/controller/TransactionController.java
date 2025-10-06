package com.centralisateur.controller;

import com.centralisateur.entity.Client;
import com.centralisateur.service.ClientService;
import com.centralisateur.service.CompteCourantIntegrationService;
import com.compteCourant.entity.CompteCourant;
import com.compteCourant.entity.Transaction;
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
 * Contrôleur pour la gestion des transactions (dépôts et retraits)
 */
@WebServlet("/compte_courant/transaction")
public class TransactionController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(TransactionController.class.getName());

    @Inject
    private CompteCourantIntegrationService compteCourantService;

    /**
     * Affiche le formulaire de transaction avec la liste des comptes
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            LOGGER.info("=== DÉBUT - Affichage du formulaire de transaction ===");
            // Récupérer tous les comptes courants pour le formulaire
            List<CompteCourant> comptes = compteCourantService.getTousLesComptes();
            request.setAttribute("comptes", comptes);
            request.getRequestDispatcher("/compte_courant/transaction.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de l'affichage du formulaire de transaction", e);
            request.setAttribute("error", "Erreur lors de l'affichage du formulaire de transaction");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    /**
     * Traite la soumission du formulaire de transaction
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            LOGGER.info("=== DÉBUT - Traitement de la transaction ===");
            
            // Récupérer les paramètres du formulaire
            String compteIdStr = request.getParameter("compteId");
            String montantStr = request.getParameter("montant");
            String description = request.getParameter("description");
            String typeOperation = request.getParameter("typeOperation");
            
            LOGGER.info("Paramètres reçus :");
            LOGGER.info("- Compte ID : " + compteIdStr);
            LOGGER.info("- Montant : " + montantStr);
            LOGGER.info("- Description : " + description);
            LOGGER.info("- Type d'opération : " + typeOperation);
            
            // Validation des paramètres
            if (compteIdStr == null || compteIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Veuillez sélectionner un compte");
            }
            
            if (montantStr == null || montantStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Veuillez saisir un montant");
            }
            
            if (typeOperation == null || (!typeOperation.equals("depot") && !typeOperation.equals("retrait"))) {
                throw new IllegalArgumentException("Veuillez sélectionner le type d'opération (dépôt ou retrait)");
            }
            
            // Conversion des paramètres
            Long compteId;
            BigDecimal montant;
            
            try {
                compteId = Long.parseLong(compteIdStr);
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("ID de compte invalide");
            }
            
            try {
                montant = new BigDecimal(montantStr);
                if (montant.compareTo(BigDecimal.ZERO) <= 0) {
                    throw new IllegalArgumentException("Le montant doit être positif");
                }
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Montant invalide");
            }
            
            // Vérifier que le compte existe
            CompteCourant compte = compteCourantService.getCompteParId(compteId);
            if (compte == null) {
                throw new IllegalArgumentException("Compte introuvable");
            }
            
            // Effectuer l'opération selon le type
            Transaction transaction;
            String messageSucces;
            
            if ("depot".equals(typeOperation)) {
                LOGGER.info("Exécution d'un dépôt de " + montant + " sur le compte " + compte.getNumeroCompte());
                transaction = compteCourantService.deposer(compteId, montant, description);
                messageSucces = "Dépôt de " + montant + " € effectué avec succès sur le compte " + compte.getNumeroCompte();
                
            } else { // retrait
                LOGGER.info("Exécution d'un retrait de " + montant + " sur le compte " + compte.getNumeroCompte());
                
                // Vérifier si le retrait est possible
                if (!compteCourantService.peutRetirerMontant(compteId, montant)) {
                    BigDecimal soldeDisponible = compteCourantService.getSoldeDisponible(compteId);
                    throw new IllegalArgumentException("Solde insuffisant. Solde disponible : " + soldeDisponible + " €");
                }
                
                transaction = compteCourantService.retirer(compteId, montant, description);
                messageSucces = "Retrait de " + montant + " € effectué avec succès sur le compte " + compte.getNumeroCompte();
            }
            
            LOGGER.info("Transaction créée avec l'ID : " + transaction.getId());
            LOGGER.info("=== FIN - Transaction traitée avec succès ===");
            
            // Rediriger avec message de succès
            request.setAttribute("success", messageSucces);
            request.setAttribute("transaction", transaction);
            
            // Recharger les données pour l'affichage
            doGet(request, response);
            
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Erreur de validation dans la transaction", e);
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "ERREUR CRITIQUE lors du traitement de la transaction", e);
            request.setAttribute("error", "Erreur lors du traitement de la transaction : " + e.getMessage());
            doGet(request, response);
        }
    }
}