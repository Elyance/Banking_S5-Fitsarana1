package com.centralisateur.controller;

import com.centralisateur.service.CompteCourantIntegrationService;
import com.centralisateur.service.ClientService;
import com.centralisateur.entity.Client;
import com.centralisateur.dto.TransactionAffichageDTO;
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
import java.util.List;
import java.util.ArrayList;
import java.util.logging.Logger;

/**
 * Contrôleur pour l'affichage des transactions d'un compte courant
 */
@WebServlet("/compte-courant/transactions")
public class TransactionsController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(TransactionsController.class.getName());

    @Inject
    private CompteCourantIntegrationService compteCourantService;
    
    @EJB
    private ClientService clientService;

    /**
     * Affiche la liste des transactions d'un compte
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
            LOGGER.info("=== Récupération des transactions du compte ID: " + compteId + " ===");
            
            // Récupérer les informations du compte
            CompteCourant compte = compteCourantService.getCompteParId(compteId);
            if (compte == null) {
                throw new IllegalArgumentException("Compte introuvable avec l'ID: " + compteId);
            }
            
            // Récupérer les informations du client
            String nomClient = "Client inconnu";
            String prenomClient = "";
            try {
                if (compte.getClientId() != null) {
                    Client client = clientService.getClientById(compte.getClientId());
                    if (client != null) {
                        nomClient = client.getNom();
                        prenomClient = client.getPrenom();
                    }
                }
            } catch (Exception e) {
                LOGGER.warning("Erreur lors de la récupération du client " + compte.getClientId() + ": " + e.getMessage());
            }
            
            // Récupérer les transactions du compte
            List<Transaction> transactions = compteCourantService.getTransactions(compteId);
            LOGGER.info("Transactions récupérées: " + transactions.size());
            
            // Convertir les transactions en DTOs d'affichage
            List<TransactionAffichageDTO> transactionsAffichage = new ArrayList<>();
            for (Transaction transaction : transactions) {
                TransactionAffichageDTO dto = new TransactionAffichageDTO();
                dto.setTransactionId(transaction.getId());
                dto.setCompteId(transaction.getCompteCourantId());
                dto.setNumeroCompte(compte.getNumeroCompte());
                dto.setTypeOperationId(transaction.getTypeOperationId());
                dto.setMontant(transaction.getMontant());
                dto.setDescription(transaction.getDescription());
                dto.setReferenceExterne("TXN-" + transaction.getId()); // Générer une référence
                dto.setDateTransaction(transaction.getDateTransaction());
                
                // Le DTO calcule automatiquement les propriétés d'affichage
                transactionsAffichage.add(dto);
            }
            
            LOGGER.info("DTOs créés: " + transactionsAffichage.size());
            
            // Ajouter les données à la requête
            request.setAttribute("compte", compte);
            request.setAttribute("nomClient", nomClient);
            request.setAttribute("prenomClient", prenomClient);
            request.setAttribute("transactions", transactionsAffichage);
            request.setAttribute("nombreTransactions", transactionsAffichage.size());
            request.setAttribute("pageTitle", "Transactions du compte " + compte.getNumeroCompte());

            LOGGER.info("=== Envoi vers JSP transactions: " + transactionsAffichage.size() + " transactions ===");

            // Rediriger vers la page de transactions
            request.getRequestDispatcher("/compte_courant/transactions.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            LOGGER.severe("Format d'ID invalide : " + e.getMessage());
            request.setAttribute("error", "Format d'ID invalide");
            request.getRequestDispatcher("/compte_courant/liste").forward(request, response);
        } catch (IllegalArgumentException e) {
            LOGGER.severe("Erreur de paramètre : " + e.getMessage());
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/compte_courant/liste").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Erreur lors du chargement des transactions : " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des transactions : " + e.getMessage());
            request.getRequestDispatcher("/compte_courant/liste").forward(request, response);
        }
    }
}