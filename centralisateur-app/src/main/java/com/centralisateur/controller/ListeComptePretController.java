package com.centralisateur.controller;

import com.centralisateur.service.ComptePretIntegrationService;
import com.centralisateur.service.ClientService;
import com.centralisateur.entity.Client;
import com.banque.dto.ComptePretStatutDTO;
import com.centralisateur.dto.ComptePretAffichageDTO;

import jakarta.inject.Inject;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/compte-pret/liste")
public class ListeComptePretController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(ListeComptePretController.class.getName());

    @Inject
    private ComptePretIntegrationService comptePretService;
    
    @EJB
    private ClientService clientService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            LOGGER.info("=== Récupération de la liste des comptes prêt avec informations client ===");
            
            // Récupérer tous les comptes prêt
            List<ComptePretStatutDTO> comptesPret = comptePretService.getAllComptePretWithTypeAndStatut();
            LOGGER.info("Comptes prêt récupérés: " + comptesPret.size());
            System.out.println("Comptes prêt: " + comptesPret.size());
            
            // Créer la liste des DTO pour l'affichage
            List<ComptePretAffichageDTO> comptesAffichage = new ArrayList<>();
            
            for (ComptePretStatutDTO compte : comptesPret) {
                ComptePretAffichageDTO dto = new ComptePretAffichageDTO();
                
                // Informations du compte
                dto.setCompteId(compte.getCompteId());
                dto.setNumeroCompte(compte.getNumeroCompte());
                dto.setClientId(compte.getClientId());
                dto.setMontantEmprunte(compte.getMontantEmprunte());
                dto.setTauxInteret(compte.getTauxInteret());
                dto.setDureeEnMois(compte.getDureeTotaleMois());
                dto.setDateDebut(compte.getDateDebut());
                dto.setSoldeRestantDu(compte.getSoldeRestantDu());
                
                // Type de paiement
                if (compte.getTypePaiementLibelle() != null) {
                    dto.setTypePaiement(compte.getTypePaiementLibelle());
                } else {
                    dto.setTypePaiement("Non défini");
                }
                
                // Statut du compte
                String statut = comptePretService.getStatutActuelComptePret(compte.getCompteId());
                dto.setStatutCompte(statut != null ? statut : "ACTIF");
                
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
                
                comptesAffichage.add(dto);
            }
            
            // Ajouter les données à la requête
            request.setAttribute("comptes", comptesAffichage);
            System.out.println("DTO pour affichage: " + comptesAffichage.size());
            request.setAttribute("nombreComptes", comptesAffichage.size());

            LOGGER.info("=== Envoi vers JSP: " + comptesAffichage.size() + " comptes prêt ===");
            for (ComptePretAffichageDTO comptePretAffichageDTO : comptesAffichage) {
                System.out.println("DTO pour affichage: " + comptePretAffichageDTO.toString());
            }

            // Utiliser le layout principal pour la page de liste
            request.setAttribute("pageTitle", "Liste des Comptes Prêt");
            request.setAttribute("contentPage", "/compte_pret/liste-comptes-pret.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.severe("Erreur lors du chargement de la liste des comptes prêt: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement de la liste des comptes prêt : " + e.getMessage());
            request.setAttribute("comptes", new ArrayList<>());
            
            // Utiliser le layout principal même en cas d'erreur
            request.setAttribute("pageTitle", "Erreur - Liste des Comptes Prêt");
            request.setAttribute("contentPage", "/compte_pret/liste-comptes-pret.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);
        }
    }
}