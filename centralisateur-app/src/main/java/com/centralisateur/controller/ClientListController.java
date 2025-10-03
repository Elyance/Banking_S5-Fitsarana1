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
import java.util.List;

/**
 * Contrôleur pour l'affichage de la liste des clients
 */
@WebServlet(name = "ClientListController", urlPatterns = {"/clients/list"})
public class ClientListController extends HttpServlet {

    @EJB
    private ClientService clientService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Récupérer tous les clients
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Récupération des filtres
            String nomFiltre = request.getParameter("nomFiltre");
            String emailFiltre = request.getParameter("emailFiltre");
            String numeroClientFiltre = request.getParameter("numeroClientFiltre");
            
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
            } else if (numeroClientFiltre != null && !numeroClientFiltre.trim().isEmpty()) {
                Client client = clientService.findClientByNumeroClient(numeroClientFiltre);
                clients = client != null ? List.of(client) : List.of();
                request.setAttribute("numeroClientFiltre", numeroClientFiltre);
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