package com.centralisateur.controller;

import com.centralisateur.service.CompteCourantIntegrationService;
import com.centralisateur.service.ClientService;
import com.centralisateur.entity.Client;
import com.centralisateur.dto.CompteAffichageDTO;
import com.compteCourant.entity.CompteCourant;
import com.compteCourant.entity.Transaction;
import jakarta.inject.Inject;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.logging.Logger;

/**
 * Contrôleur pour la gestion des transactions (dépôts et retraits)
 */
@WebServlet("/compte-courant/transaction")
public class TransactionController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(TransactionController.class.getName());

    @Inject
    private CompteCourantIntegrationService compteCourantService;
    
    @EJB
    private ClientService clientService;

    /**
     * Affiche le formulaire de transaction
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Récupérer l'ID du compte depuis les paramètres
            String compteIdParam = request.getParameter("compteId");
            if (compteIdParam == null || compteIdParam.isEmpty()) {
                throw new IllegalArgumentException("ID du compte manquant");
            }
            
            Long compteId = Long.parseLong(compteIdParam);
            LOGGER.info("=== Affichage du formulaire de transaction pour le compte ID: " + compteId + " ===");
            
            // Récupérer les détails du compte
            CompteCourant compte = compteCourantService.getCompteParId(compteId);
            if (compte == null) {
                throw new IllegalArgumentException("Compte introuvable avec l'ID: " + compteId);
            }
            
            // Créer le DTO pour l'affichage
            CompteAffichageDTO dto = new CompteAffichageDTO();
            dto.setCompteId(compte.getId());
            dto.setNumeroCompte(compte.getNumeroCompte());
            dto.setClientId(compte.getClientId());
            dto.setSolde(compte.getSolde());
            dto.setDecouvertAutorise(compte.getDecouvertAutorise());
            dto.setDateCreation(compte.getDateCreation());
            dto.setStatutCompte("ACTIF"); // À améliorer avec le statut réel
            
            // Récupérer les informations du client
            try {
                if (compte.getClientId() != null) {
                    Client client = clientService.getClientById(compte.getClientId());
                    if (client != null) {
                        dto.setNomClient(client.getNom());
                        dto.setPrenomClient(client.getPrenom());
                        dto.setEmailClient(client.getEmail());
                    }
                }
            } catch (Exception e) {
                LOGGER.warning("Erreur lors de la récupération du client " + compte.getClientId() + ": " + e.getMessage());
            }
            
            // Ajouter les données à la requête
            request.setAttribute("compte", dto);
            request.setAttribute("pageTitle", "Transaction - Compte " + compte.getNumeroCompte());

            LOGGER.info("=== Envoi vers JSP transaction: compte " + compte.getNumeroCompte() + " ===");

            // Rediriger vers la page de transaction
            request.getRequestDispatcher("/compte_courant/transaction.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            LOGGER.severe("Format d'ID invalide : " + e.getMessage());
            request.setAttribute("error", "Format d'ID invalide");
            response.sendRedirect(request.getContextPath() + "/compte-courant/liste");
        } catch (IllegalArgumentException e) {
            LOGGER.severe("Erreur de paramètre : " + e.getMessage());
            request.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/compte-courant/liste");
        } catch (Exception e) {
            LOGGER.severe("Erreur lors du chargement du formulaire de transaction : " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement du formulaire : " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/compte-courant/liste");
        }
    }

    /**
     * Traite la soumission du formulaire de transaction
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Récupérer les paramètres du formulaire
            String compteIdParam = request.getParameter("compteId");
            String typeOperationParam = request.getParameter("typeOperation");
            String montantParam = request.getParameter("montant");
            String description = request.getParameter("description");
            
            // Validations
            if (compteIdParam == null || compteIdParam.isEmpty()) {
                throw new IllegalArgumentException("ID du compte manquant");
            }
            
            if (typeOperationParam == null || typeOperationParam.isEmpty()) {
                throw new IllegalArgumentException("Type d'opération manquant");
            }
            
            if (montantParam == null || montantParam.isEmpty()) {
                throw new IllegalArgumentException("Montant manquant");
            }
            
            Long compteId = Long.parseLong(compteIdParam);
            int typeOperation = Integer.parseInt(typeOperationParam);
            BigDecimal montant = new BigDecimal(montantParam);
            
            // Validation du montant
            if (montant.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Le montant doit être positif");
            }
            
            // Validation du type d'opération
            if (typeOperation != 1 && typeOperation != 2) {
                throw new IllegalArgumentException("Type d'opération invalide");
            }
            
            if (description == null || description.trim().isEmpty()) {
                description = typeOperation == 1 ? "Dépôt" : "Retrait";
            }
            
            LOGGER.info("=== Exécution transaction: Compte " + compteId + 
                       ", Type: " + (typeOperation == 1 ? "DEPOT" : "RETRAIT") + 
                       ", Montant: " + montant + " ===");
            
            // Exécuter la transaction
            Transaction transaction;
            if (typeOperation == 1) {
                // Dépôt
                transaction = compteCourantService.deposer(compteId, montant, description);
            } else {
                // Retrait
                transaction = compteCourantService.retirer(compteId, montant, description);
            }
            
            if (transaction != null) {
                LOGGER.info("=== Transaction réussie: ID " + transaction.getId() + " ===");
                
                // Message de succès
                request.getSession().setAttribute("successMessage", 
                    "Transaction réussie ! " + (typeOperation == 1 ? "Dépôt" : "Retrait") + 
                    " de " + montant + "€ effectué.");
                
                // Rediriger vers les détails du compte
                response.sendRedirect(request.getContextPath() + "/compte-courant/detail?id=" + compteId);
                
            } else {
                throw new RuntimeException("La transaction a échoué");
            }
            
        } catch (NumberFormatException e) {
            LOGGER.severe("Format de données invalide : " + e.getMessage());
            request.getSession().setAttribute("errorMessage", "Format de données invalide");
            String compteId = request.getParameter("compteId");
            if (compteId != null) {
                response.sendRedirect(request.getContextPath() + "/compte-courant/transaction?compteId=" + compteId);
            } else {
                response.sendRedirect(request.getContextPath() + "/compte-courant/liste");
            }
            
        } catch (IllegalArgumentException e) {
            LOGGER.severe("Erreur de validation : " + e.getMessage());
            request.getSession().setAttribute("errorMessage", e.getMessage());
            String compteId = request.getParameter("compteId");
            if (compteId != null) {
                response.sendRedirect(request.getContextPath() + "/compte-courant/transaction?compteId=" + compteId);
            } else {
                response.sendRedirect(request.getContextPath() + "/compte-courant/liste");
            }
            
        } catch (Exception e) {
            LOGGER.severe("Erreur lors de l'exécution de la transaction : " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", 
                "Erreur lors de l'exécution de la transaction : " + e.getMessage());
            String compteId = request.getParameter("compteId");
            if (compteId != null) {
                response.sendRedirect(request.getContextPath() + "/compte-courant/transaction?compteId=" + compteId);
            } else {
                response.sendRedirect(request.getContextPath() + "/compte-courant/liste");
            }
        }
    }
}