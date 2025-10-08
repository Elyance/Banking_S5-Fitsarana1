package com.centralisateur.controller;

import com.centralisateur.entity.Client;
import com.centralisateur.service.ClientService;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

/**
 * Contrôleur pour l'édition des informations d'un client
 */
@WebServlet(name = "ClientEditController", urlPatterns = {"/clients/edit"})
public class ClientEditController extends HttpServlet {

    @EJB
    private ClientService clientService;

    /**
     * Affiche le formulaire d'édition pré-rempli avec les données du client
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String clientIdStr = request.getParameter("id");
            
            if (clientIdStr == null || clientIdStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID client manquant");
                return;
            }
            
            Long clientId = Long.parseLong(clientIdStr);
            Client client = clientService.getClientById(clientId);
            
            // Passer les données du client au formulaire
            request.setAttribute("client", client);
            request.setAttribute("mode", "edit");
            request.setAttribute("pageTitle", "Modifier le client");
            request.setAttribute("contentPage", "/client/client-edit-content.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Format ID client invalide");
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, e.getMessage());
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération du client pour édition : " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur interne du serveur");
        }
    }

    /**
     * Traite la mise à jour des informations du client
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Récupération de l'ID du client
            String clientIdStr = request.getParameter("clientId");
            if (clientIdStr == null || clientIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("ID client manquant");
            }
            
            Long clientId = Long.parseLong(clientIdStr);
            
            // Récupération des paramètres du formulaire
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String telephone = request.getParameter("telephone");
            String dateNaissanceStr = request.getParameter("dateNaissance");
            String profession = request.getParameter("profession");
            String adresse = request.getParameter("adresse");

            // Validation des champs obligatoires
            if (nom == null || nom.trim().isEmpty()) {
                throw new IllegalArgumentException("Le nom est obligatoire");
            }
            if (prenom == null || prenom.trim().isEmpty()) {
                throw new IllegalArgumentException("Le prénom est obligatoire");
            }
            if (email == null || email.trim().isEmpty()) {
                throw new IllegalArgumentException("L'email est obligatoire");
            }
            if (telephone == null || telephone.trim().isEmpty()) {
                throw new IllegalArgumentException("Le téléphone est obligatoire");
            }

            // Validation format email basique
            if (!email.contains("@") || !email.contains(".")) {
                throw new IllegalArgumentException("Format d'email invalide");
            }

            // Récupérer le client existant
            Client clientExistant = clientService.getClientById(clientId);
            
            // Mettre à jour les informations
            clientExistant.setNom(nom.trim());
            clientExistant.setPrenom(prenom.trim());
            clientExistant.setEmail(email.trim().toLowerCase());
            clientExistant.setTelephone(telephone.trim());

            // Gestion de la date de naissance (optionnelle)
            if (dateNaissanceStr != null && !dateNaissanceStr.trim().isEmpty()) {
                try {
                    LocalDate dateNaissance = LocalDate.parse(dateNaissanceStr);
                    clientExistant.setDateNaissance(dateNaissance);
                } catch (DateTimeParseException e) {
                    throw new IllegalArgumentException("Format de date invalide. Utilisez le format YYYY-MM-DD");
                }
            } else {
                clientExistant.setDateNaissance(null);
            }

            // Gestion des champs optionnels
            if (profession != null && !profession.trim().isEmpty()) {
                clientExistant.setProfession(profession.trim());
            } else {
                clientExistant.setProfession(null);
            }
            
            if (adresse != null && !adresse.trim().isEmpty()) {
                clientExistant.setAdresse(adresse.trim());
            } else {
                clientExistant.setAdresse(null);
            }

            // Mise à jour du client via le service EJB
            Client clientMisAJour = clientService.updateClient(clientExistant);

            // Redirection vers la page de détails avec message de succès
            request.setAttribute("client", clientMisAJour);
            request.setAttribute("successMessage", "Les informations du client ont été mises à jour avec succès !");
            request.setAttribute("pageTitle", "Détails du client");
            request.setAttribute("contentPage", "/client/client-details-content.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            handleEditError(request, response, "Format ID client invalide", request.getParameter("clientId"));
        } catch (IllegalArgumentException e) {
            handleEditError(request, response, e.getMessage(), request.getParameter("clientId"));
        } catch (Exception e) {
            System.err.println("Erreur lors de la mise à jour du client : " + e.getMessage());
            e.printStackTrace();
            handleEditError(request, response, "Une erreur technique s'est produite lors de la mise à jour. Veuillez réessayer.", request.getParameter("clientId"));
        }
    }

    /**
     * Gère les erreurs de validation en renvoyant vers le formulaire d'édition
     * avec les données saisies et le message d'erreur
     */
    private void handleEditError(HttpServletRequest request, HttpServletResponse response, 
                                String errorMessage, String clientId) 
            throws ServletException, IOException {
        
        try {
            // Récupérer les données originales du client pour pré-remplir le formulaire
            if (clientId != null && !clientId.trim().isEmpty()) {
                Long id = Long.parseLong(clientId);
                Client originalClient = clientService.getClientById(id);
                request.setAttribute("client", originalClient);
            }
        } catch (Exception e) {
            // Si on ne peut pas récupérer le client original, on utilise les données du formulaire
        }
        
        // Conserver les données saisies pour éviter de les perdre
        request.setAttribute("error", errorMessage);
        request.setAttribute("clientId", clientId);
        request.setAttribute("nom", request.getParameter("nom"));
        request.setAttribute("prenom", request.getParameter("prenom"));
        request.setAttribute("email", request.getParameter("email"));
        request.setAttribute("telephone", request.getParameter("telephone"));
        request.setAttribute("dateNaissance", request.getParameter("dateNaissance"));
        request.setAttribute("profession", request.getParameter("profession"));
        request.setAttribute("adresse", request.getParameter("adresse"));
        request.setAttribute("mode", "edit");

        // Rediriger vers le formulaire d'édition
        request.setAttribute("pageTitle", "Modifier le client");
        request.setAttribute("contentPage", "/client/client-edit-content.jsp");
        request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);
    }
}