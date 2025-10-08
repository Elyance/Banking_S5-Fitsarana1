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
            
            request.setAttribute("pageTitle", "Liste des clients");
            request.setAttribute("contentPage", "/client/client-list-content.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération des clients : " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la récupération des clients");
            request.setAttribute("pageTitle", "Liste des clients");
            request.setAttribute("contentPage", "/client/client-list-content.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);
        }
    }
}