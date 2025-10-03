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
import java.util.List;

/**
 * Contrôleur unique gérant toutes les actions clients via un paramètre 'action'
 * Usage: /clients?action=register, /clients?action=list, /clients?action=details&id=123
 */
@WebServlet(name = "ClientMainController", urlPatterns = {"/clients"})
public class ClientMainController extends HttpServlet {

    @EJB
    private ClientService clientService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list"; // Action par défaut
        }
        
        switch (action) {
            case "register":
                showRegisterForm(request, response);
                break;
            case "list":
                showClientsList(request, response);
                break;
            case "details":
                showClientDetails(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action non reconnue: " + action);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action manquante");
            return;
        }
        
        switch (action) {
            case "register":
                processRegisterClient(request, response);
                break;
            case "filter":
                processFilterClients(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action POST non reconnue: " + action);
                break;
        }
    }

    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/client/client-registration.jsp").forward(request, response);
    }

    private void showClientsList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Client> clients = clientService.getAllClients();
            long totalClients = clientService.countClients();
            
            request.setAttribute("clients", clients);
            request.setAttribute("totalClients", totalClients);
            request.setAttribute("filtreApplique", false);
            
            request.getRequestDispatcher("/client/client-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération des clients : " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la récupération des clients");
            request.getRequestDispatcher("/client/client-list.jsp").forward(request, response);
        }
    }

    private void showClientDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String clientIdStr = request.getParameter("id");
            
            if (clientIdStr == null || clientIdStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID client manquant");
                return;
            }
            
            Long clientId = Long.parseLong(clientIdStr);
            Client client = clientService.getClientById(clientId);
            
            request.setAttribute("client", client);
            
            request.getRequestDispatcher("/client/client-details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Format ID client invalide");
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, e.getMessage());
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération des détails du client : " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur interne du serveur");
        }
    }

    private void processRegisterClient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
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

            // Création de l'objet Client
            Client nouveauClient = new Client();
            nouveauClient.setNom(nom.trim());
            nouveauClient.setPrenom(prenom.trim());
            nouveauClient.setEmail(email.trim().toLowerCase());
            nouveauClient.setTelephone(telephone.trim());

            // Gestion de la date de naissance (optionnelle)
            if (dateNaissanceStr != null && !dateNaissanceStr.trim().isEmpty()) {
                try {
                    LocalDate dateNaissance = LocalDate.parse(dateNaissanceStr);
                    nouveauClient.setDateNaissance(dateNaissance);
                } catch (DateTimeParseException e) {
                    throw new IllegalArgumentException("Format de date invalide. Utilisez le format YYYY-MM-DD");
                }
            }

            // Gestion des champs optionnels
            if (profession != null && !profession.trim().isEmpty()) {
                nouveauClient.setProfession(profession.trim());
            }
            if (adresse != null && !adresse.trim().isEmpty()) {
                nouveauClient.setAdresse(adresse.trim());
            }

            // Enregistrement du client via le service EJB
            Client clientEnregistre = clientService.enregistrerNouveauClient(nouveauClient);

            // Redirection vers la page de succès avec les informations du client
            request.setAttribute("client", clientEnregistre);
            request.setAttribute("message", "Le client " + clientEnregistre.getNomComplet() + 
                               " a été enregistré avec succès !");

            request.getRequestDispatcher("/client/client-success.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            // Erreur de validation - rediriger vers le formulaire avec les données et le message d'erreur
            request.setAttribute("error", e.getMessage());
            request.setAttribute("nom", request.getParameter("nom"));
            request.setAttribute("prenom", request.getParameter("prenom"));
            request.setAttribute("email", request.getParameter("email"));
            request.setAttribute("telephone", request.getParameter("telephone"));
            request.setAttribute("dateNaissance", request.getParameter("dateNaissance"));
            request.setAttribute("profession", request.getParameter("profession"));
            request.setAttribute("adresse", request.getParameter("adresse"));

            request.getRequestDispatcher("/client/client-registration.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Erreur technique - rediriger vers le formulaire avec un message générique
            System.err.println("Erreur lors de l'enregistrement du client : " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Une erreur technique s'est produite lors de l'enregistrement. Veuillez réessayer.");
            request.setAttribute("nom", request.getParameter("nom"));
            request.setAttribute("prenom", request.getParameter("prenom"));
            request.setAttribute("email", request.getParameter("email"));
            request.setAttribute("telephone", request.getParameter("telephone"));
            request.setAttribute("dateNaissance", request.getParameter("dateNaissance"));
            request.setAttribute("profession", request.getParameter("profession"));
            request.setAttribute("adresse", request.getParameter("adresse"));

            request.getRequestDispatcher("/client/client-registration.jsp").forward(request, response);
        }
    }

    private void processFilterClients(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Récupération des filtres
            String nomFiltre = request.getParameter("nomFiltre");
            String emailFiltre = request.getParameter("emailFiltre");
            
            List<Client> clients;
            
            // Appliquer les filtres
            if (nomFiltre != null && !nomFiltre.trim().isEmpty()) {
                clients = clientService.searchClientsByNom(nomFiltre);
                request.setAttribute("nomFiltre", nomFiltre);
                request.setAttribute("filtreApplique", true);
            } else if (emailFiltre != null && !emailFiltre.trim().isEmpty()) {
                Client client = clientService.findClientByEmail(emailFiltre);
                clients = client != null ? List.of(client) : List.of();
                request.setAttribute("emailFiltre", emailFiltre);
                request.setAttribute("filtreApplique", true);
            } else {
                clients = clientService.getAllClients();
                request.setAttribute("filtreApplique", false);
            }
            
            request.setAttribute("clients", clients);
            request.setAttribute("totalClients", clients.size());
            
            request.getRequestDispatcher("/client/client-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Erreur lors du filtrage des clients : " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du filtrage des clients");
            request.getRequestDispatcher("/client/client-list.jsp").forward(request, response);
        }
    }
}