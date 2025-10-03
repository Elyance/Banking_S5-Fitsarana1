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
 * Contrôleur pour la gestion des clients
 * Utilise EJB avec WildFly pour l'injection de dépendances
 */
@WebServlet(name = "ClientRegistrationController", urlPatterns = {"/clients/register"})
public class ClientRegistrationController extends HttpServlet {

    @EJB
    private ClientService clientService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Rediriger vers la page JSP du formulaire d'enregistrement
        request.getRequestDispatcher("/client/client-registration.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
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
}
