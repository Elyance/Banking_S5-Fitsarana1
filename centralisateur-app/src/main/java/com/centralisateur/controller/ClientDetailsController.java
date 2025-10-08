package com.centralisateur.controller;

import com.centralisateur.entity.Client;
import com.centralisateur.entity.StatutClient;
import com.centralisateur.service.ClientService;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Contrôleur pour l'affichage des détails d'un client
 */
@WebServlet(name = "ClientDetailsController", urlPatterns = {"/clients/details"})
public class ClientDetailsController extends HttpServlet {

    @EJB
    private ClientService clientService;

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
            StatutClient statut = clientService.getStatutActuelClient(clientId);
            
            request.setAttribute("client", client);
            request.setAttribute("statut", statut);
            request.setAttribute("pageTitle", "Détails du client");
            request.setAttribute("contentPage", "/client/client-details-content.jsp");
            
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);
            
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
}