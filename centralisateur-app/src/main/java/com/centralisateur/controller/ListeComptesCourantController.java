package com.centralisateur.controller;

import com.centralisateur.service.CompteCourantIntegrationService;
import com.centralisateur.service.ClientService;
import com.centralisateur.entity.Client;
import com.centralisateur.dto.CompteAffichageDTO;
import com.banque.dto.CompteStatutDTO;
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

/**
 * Contrôleur pour l'affichage professionnel de la liste des comptes courants
 */
@WebServlet("/compte-courant/liste")
public class ListeComptesCourantController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ListeComptesCourantController.class.getName());

    @Inject
    private CompteCourantIntegrationService compteCourantService;
    
    @EJB
    private ClientService clientService;

    /**
     * Affiche la liste de tous les comptes courants avec informations client
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            LOGGER.info("=== Récupération de la liste des comptes avec informations client ===");
            
            // Récupérer tous les comptes avec leurs statuts via JOIN optimisé
            List<CompteStatutDTO> comptesAvecStatut = compteCourantService.getTousLesComptesAvecStatut();
            LOGGER.info("Comptes avec statuts récupérés: " + comptesAvecStatut.size());
            
            // Créer la liste des DTO pour l'affichage
            List<CompteAffichageDTO> comptesAffichage = new ArrayList<>();
            
            for (CompteStatutDTO compteStatut : comptesAvecStatut) {
                CompteAffichageDTO dto = new CompteAffichageDTO();
                
                // Informations du compte (depuis le JOIN)
                dto.setCompteId(compteStatut.getCompteId());
                dto.setNumeroCompte(compteStatut.getNumeroCompte());
                dto.setClientId(compteStatut.getClientId());
                dto.setSolde(compteStatut.getSolde());
                dto.setDecouvertAutorise(compteStatut.getDecouvertAutorise());
                dto.setDateCreation(compteStatut.getDateCreation());
                
                // Informations du statut (depuis le JOIN)
                dto.setStatutCompte(getStatutLibelle(compteStatut.getStatutId()));
                
                // Récupérer les informations du client
                try {
                    if (compteStatut.getClientId() != null) {
                        Client client = clientService.getClientById(compteStatut.getClientId());
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
                    LOGGER.warning("Erreur lors de la récupération du client " + compteStatut.getClientId() + ": " + e.getMessage());
                    dto.setNomClient("Erreur client");
                    dto.setPrenomClient("");
                    dto.setEmailClient("");
                }
                
                comptesAffichage.add(dto);
            }
            
            // Ajouter les données à la requête
            request.setAttribute("comptes", comptesAffichage);
            request.setAttribute("nombreComptes", comptesAffichage.size());
            request.setAttribute("sourceData", "Données optimisées avec JOIN compte-statut + lookup client");

            LOGGER.info("=== Envoi vers JSP: " + comptesAffichage.size() + " comptes avec JOIN optimisé ===");

            // Utiliser le layout principal pour la page de liste
            request.setAttribute("pageTitle", "Liste des Comptes Courants");
            request.setAttribute("contentPage", "/compte_courant/liste.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.severe("Erreur lors du chargement de la liste des comptes courants: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement de la liste des comptes courants : " + e.getMessage());
            request.setAttribute("comptes", new ArrayList<>());
            
            // Utiliser le layout principal même en cas d'erreur
            request.setAttribute("pageTitle", "Erreur - Liste des Comptes courants");
            request.setAttribute("contentPage", "/compte_courant/liste.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);
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
    
    /**
     * Convertit un ID de statut en libellé lisible
     */
    private String getStatutLibelle(Long statutId) {
        if (statutId == null) {
            return "ACTIF";
        }
        
        return switch (statutId.intValue()) {
            case 1 -> "ACTIF";
            case 2 -> "INACTIF";
            case 3 -> "FERME";
            case 4 -> "SUSPENDU";
            default -> "ACTIF";
        };
    }
}