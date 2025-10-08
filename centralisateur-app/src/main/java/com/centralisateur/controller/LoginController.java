package com.centralisateur.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Vérifier si l'utilisateur est déjà connecté
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // Rediriger vers le tableau de bord si déjà connecté
            response.sendRedirect("dashboard");
            return;
        }
        
        // Afficher la page de login
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Validation des paramètres
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("error", "Veuillez remplir tous les champs");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        try {
            if (authenticateUser(email.trim(), password)) {
                // Créer une session
                HttpSession session = request.getSession(true);
                session.setAttribute("user", email);
                session.setAttribute("loginTime", System.currentTimeMillis());
                
                // Rediriger vers le tableau de bord
                response.sendRedirect("dashboard");
            } else {
                request.setAttribute("error", "Email ou mot de passe incorrect");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            
            request.setAttribute("error", "Une erreur est survenue lors de la connexion");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    private boolean authenticateUser(String email, String password) {
        return "admin@bank.com".equals(email) && "admin123".equals(password);
    }
}
