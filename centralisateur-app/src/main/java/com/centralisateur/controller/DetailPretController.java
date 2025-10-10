package com.centralisateur.controller;

import com.centralisateur.dto.ComptePretAffichageDTO;
import com.centralisateur.service.ComptePretIntegrationService;
import com.centralisateur.service.ClientService;
import com.centralisateur.entity.Client;
import com.banque.dto.ComptePretStatutDTO;
import jakarta.inject.Inject;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * Contrôleur pour l'affichage des détails d'un compte prêt
 */
@WebServlet("/compte-pret/details")
public class DetailPretController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DetailPretController.class.getName());

    @Inject
    private ComptePretIntegrationService comptePretService;

    @EJB
    private ClientService clientService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String compteIdParam = request.getParameter("id");
            if (compteIdParam == null || compteIdParam.isEmpty()) {
                throw new IllegalArgumentException("ID du compte prêt manquant");
            }
            Long compteId = Long.parseLong(compteIdParam);
            LOGGER.info("=== Récupération des détails du compte prêt ID: " + compteId + " ===");

            // Récupérer les détails du compte prêt

            // Récupérer la liste des comptes prêt avec type et statut
            ComptePretStatutDTO compte = null;
            for (ComptePretStatutDTO c : comptePretService.getAllComptePretWithTypeAndStatut()) {
                if (c.getCompteId() != null && c.getCompteId().equals(compteId)) {
                    compte = c;
                    break;
                }
            }
            if (compte == null) {
                throw new IllegalArgumentException("Compte prêt introuvable avec l'ID: " + compteId);
            }

            // Créer le DTO pour l'affichage (ou utiliser directement ComptePretStatutDTO)
            ComptePretAffichageDTO dto = new ComptePretAffichageDTO();
            dto.setCompteId(compte.getCompteId());
            dto.setNumeroCompte(compte.getNumeroCompte());
            dto.setClientId(compte.getClientId());
            dto.setMontantEmprunte(compte.getMontantEmprunte());
            dto.setTauxInteret(compte.getTauxInteret());
            dto.setDureeEnMois(compte.getDureeTotaleMois());
            dto.setDateDebut(compte.getDateDebut());
            dto.setSoldeRestantDu(compte.getSoldeRestantDu());
            dto.setStatutCompte(compte.getStatutLibelle());
            if (compte.getTypePaiementLibelle() != null) {
                dto.setTypePaiement(compte.getTypePaiementLibelle());
            } else {
                dto.setTypePaiement("Non défini");
            }

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

            // Ajouter les données à la requête
            request.setAttribute("compte", dto);
            request.setAttribute("pageTitle", "Détails du compte prêt " + compte.getNumeroCompte());
            request.setAttribute("contentPage", "/compte_pret/detail-pret.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.severe("Format d'ID invalide : " + e.getMessage());
            request.setAttribute("error", "Format d'ID invalide");
            request.getRequestDispatcher("/compte-pret/liste").forward(request, response);
        } catch (IllegalArgumentException e) {
            LOGGER.severe("Erreur de paramètre : " + e.getMessage());
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/compte-pret/liste").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Erreur lors du chargement des détails du compte prêt : " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des détails du compte prêt : " + e.getMessage());
            request.getRequestDispatcher("/compte-pret/liste").forward(request, response);
        }
    }
}
