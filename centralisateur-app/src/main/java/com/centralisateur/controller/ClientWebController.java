package com.centralisateur.controller;package com.centralisateur.controller;



import com.centralisateur.entity.Client;import com.centralisateur.entity.Client;

import com.centralisateur.service.ClientService;import com.centralisateur.service.ClientService;



import jakarta.ejb.EJB;import jakarta.ejb.EJB;

import jakarta.servlet.ServletException;import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;import jakarta.servlet.http.HttpServlet;

import jakarta.servlet.http.HttpServletRequest;import jakarta.servlet.http.HttpServletRequest;

import jakarta.servlet.http.HttpServletResponse;import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;import java.io.IOException;

import java.time.LocalDate;import java.time.LocalDate;



/**/**

 * Contrôleur web pour la gestion des clients via formulaires HTML * Contrôleur web pour la gestion des clients via formulaires HTML

 * Gère l'affichage du formulaire et le traitement des soumissions */

 */@WebServlet("/clients/register")

@WebServlet(urlPatterns = {"/clients/register", "/clients/form"})public class ClientWebController extends HttpServlet {

public class ClientWebController extends HttpServlet {

    @EJB

    @EJB    private ClientService clientService;

    private ClientService clientService;

    @Override

    /**    protected void doPost(HttpServletRequest request, HttpServletResponse response) 

     * GET /clients/register - Affiche le formulaire d'enregistrement            throws ServletException, IOException {

     */        

    @Override        System.out.println("DEBUG: ClientWebController.doPost() appelé");

    protected void doGet(HttpServletRequest request, HttpServletResponse response)         

            throws ServletException, IOException {        // Définir l'encodage pour les caractères spéciaux

                request.setCharacterEncoding("UTF-8");

        System.out.println("DEBUG: GET appelé sur " + request.getServletPath());        response.setContentType("text/html;charset=UTF-8");

                

        // Afficher le formulaire d'enregistrement        try {

        request.getRequestDispatcher("/client-form.jsp").forward(request, response);            // Récupérer les paramètres du formulaire

    }            String nom = request.getParameter("nom");

            String prenom = request.getParameter("prenom");

    /**            String email = request.getParameter("email");

     * POST /clients/register - Traite l'enregistrement du formulaire            String telephone = request.getParameter("telephone");

     */            String adresse = request.getParameter("adresse");

    @Override            String profession = request.getParameter("profession");

    protected void doPost(HttpServletRequest request, HttpServletResponse response)             String dateNaissanceStr = request.getParameter("dateNaissance");

            throws ServletException, IOException {

                    // Créer l'objet Client

        System.out.println("DEBUG: POST appelé sur " + request.getServletPath());            Client client = new Client();

                    client.setNom(nom);

        // Définir l'encodage pour les caractères spéciaux            client.setPrenom(prenom);

        request.setCharacterEncoding("UTF-8");            client.setEmail(email);

        response.setContentType("text/html;charset=UTF-8");            client.setTelephone(telephone);

                    

        try {            // Champs optionnels

            // Récupérer les paramètres du formulaire            if (adresse != null && !adresse.trim().isEmpty()) {

            String nom = request.getParameter("nom");                client.setAdresse(adresse);

            String prenom = request.getParameter("prenom");            }

            String email = request.getParameter("email");            if (profession != null && !profession.trim().isEmpty()) {

            String telephone = request.getParameter("telephone");                client.setProfession(profession);

            String adresse = request.getParameter("adresse");            }

            String profession = request.getParameter("profession");            if (dateNaissanceStr != null && !dateNaissanceStr.trim().isEmpty()) {

            String dateNaissanceStr = request.getParameter("dateNaissance");                client.setDateNaissance(LocalDate.parse(dateNaissanceStr));

            }

            // Créer l'objet Client

            Client client = new Client();            // Enregistrer le client via le service

            client.setNom(nom);            Client clientEnregistre = clientService.enregistrerNouveauClient(client);

            client.setPrenom(prenom);

            client.setEmail(email);            // Rediriger vers la page de succès avec les informations du client

            client.setTelephone(telephone);            request.setAttribute("client", clientEnregistre);

                        request.setAttribute("message", "Client enregistré avec succès!");

            // Champs optionnels            request.getRequestDispatcher("/client-success.jsp").forward(request, response);

            if (adresse != null && !adresse.trim().isEmpty()) {

                client.setAdresse(adresse);        } catch (IllegalArgumentException e) {

            }            // Erreur de validation

            if (profession != null && !profession.trim().isEmpty()) {            request.setAttribute("error", e.getMessage());

                client.setProfession(profession);            request.setAttribute("nom", request.getParameter("nom"));

            }            request.setAttribute("prenom", request.getParameter("prenom"));

            if (dateNaissanceStr != null && !dateNaissanceStr.trim().isEmpty()) {            request.setAttribute("email", request.getParameter("email"));

                client.setDateNaissance(LocalDate.parse(dateNaissanceStr));            request.setAttribute("telephone", request.getParameter("telephone"));

            }            request.setAttribute("adresse", request.getParameter("adresse"));

            request.setAttribute("profession", request.getParameter("profession"));

            // Enregistrer le client via le service            request.setAttribute("dateNaissance", request.getParameter("dateNaissance"));

            Client clientEnregistre = clientService.enregistrerNouveauClient(client);            

            request.getRequestDispatcher("/client-registration.jsp").forward(request, response);

            // Rediriger vers la page de succès avec les informations du client            

            request.setAttribute("client", clientEnregistre);        } catch (Exception e) {

            request.setAttribute("message", "Client enregistré avec succès!");            // Erreur système - afficher les détails dans les logs

            request.getRequestDispatcher("/client-success.jsp").forward(request, response);            System.err.println("ERREUR dans ClientWebController.doPost():");

            System.err.println("Message: " + e.getMessage());

        } catch (IllegalArgumentException e) {            System.err.println("Type: " + e.getClass().getSimpleName());

            // Erreur de validation - retourner au formulaire avec l'erreur            e.printStackTrace();

            request.setAttribute("error", e.getMessage());            

            request.setAttribute("nom", request.getParameter("nom"));            request.setAttribute("error", "Erreur interne du serveur: " + e.getMessage());

            request.setAttribute("prenom", request.getParameter("prenom"));            request.getRequestDispatcher("/client-registration.jsp").forward(request, response);

            request.setAttribute("email", request.getParameter("email"));        }

            request.setAttribute("telephone", request.getParameter("telephone"));    }

            request.setAttribute("adresse", request.getParameter("adresse"));

            request.setAttribute("profession", request.getParameter("profession"));    @Override

            request.setAttribute("dateNaissance", request.getParameter("dateNaissance"));    protected void doGet(HttpServletRequest request, HttpServletResponse response) 

                        throws ServletException, IOException {

            request.getRequestDispatcher("/client-form.jsp").forward(request, response);        

                    // Debug : Afficher dans les logs que la méthode est appelée

        } catch (Exception e) {        System.out.println("DEBUG: ClientWebController.doGet() appelé");

            // Erreur système        

            System.err.println("ERREUR dans ClientWebController:");        // Afficher le formulaire d'enregistrement

            e.printStackTrace();        request.getRequestDispatcher("/client-registration.jsp").forward(request, response);

                }

            request.setAttribute("error", "Erreur interne du serveur: " + e.getMessage());}
            request.getRequestDispatcher("/client-form.jsp").forward(request, response);
        }
    }
}