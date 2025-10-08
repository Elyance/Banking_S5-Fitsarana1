package com.centralisateur.controller;

import com.centralisateur.service.ClientService;
import com.centralisateur.service.CompteCourantIntegrationService;
import com.centralisateur.entity.Client;
import com.banque.dto.CompteStatutDTO;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.logging.Logger;

/**
 * Contrôleur pour le dashboard principal
 * Affiche les statistiques globales de l'application bancaire
 */
@WebServlet({"/dashboard"})
public class DashboardController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DashboardController.class.getName());

    @Inject
    private ClientService clientService;
    
    @Inject
    private CompteCourantIntegrationService compteCourantService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            LOGGER.info("=== Chargement du Dashboard ===");
            
            // Statistiques clients
            List<Client> clients = clientService.getAllClients();
            long nombreClients = clients.size();
            
            // Statistiques comptes courants
            List<CompteStatutDTO> comptesCourants = compteCourantService.getTousLesComptesAvecStatut();
            long nombreComptesCourants = comptesCourants.size();
            
            // Calculer les totaux et moyennes
            BigDecimal soldeTotal = BigDecimal.ZERO;
            BigDecimal decouvertTotal = BigDecimal.ZERO;
            long comptesActifs = 0;
            long comptesSuspendus = 0;
            long comptesFermes = 0;
            
            for (CompteStatutDTO compte : comptesCourants) {
                if (compte.getSolde() != null) {
                    soldeTotal = soldeTotal.add(compte.getSolde());
                }
                if (compte.getDecouvertAutorise() != null) {
                    decouvertTotal = decouvertTotal.add(compte.getDecouvertAutorise());
                }
                
                // Compter par statut (1=ACTIF, 2=SUSPENDU, 3=FERME)
                Long statutId = compte.getStatutId();
                if (statutId != null) {
                    if (statutId == 1L) {
                        comptesActifs++;
                    } else if (statutId == 2L) {
                        comptesSuspendus++;
                    } else if (statutId == 3L) {
                        comptesFermes++;
                    }
                }
            }
            
            // Statistiques par type de compte (prêt pour extension)
            Map<String, Map<String, Object>> statistiquesParType = new HashMap<>();
            
            // Comptes Courants
            Map<String, Object> statsCourants = new HashMap<>();
            statsCourants.put("nombre", nombreComptesCourants);
            statsCourants.put("soldeTotal", soldeTotal);
            statsCourants.put("decouvertTotal", decouvertTotal);
            statsCourants.put("actifs", comptesActifs);
            statsCourants.put("suspendus", comptesSuspendus);
            statsCourants.put("fermes", comptesFermes);
            statistiquesParType.put("courants", statsCourants);
            
            // Comptes de Prêt (à venir)
            Map<String, Object> statsPrets = new HashMap<>();
            statsPrets.put("nombre", 0L);
            statsPrets.put("montantTotal", BigDecimal.ZERO);
            statsPrets.put("enCours", 0L);
            statsPrets.put("rembourses", 0L);
            statsPrets.put("enRetard", 0L);
            statistiquesParType.put("prets", statsPrets);
            
            // Comptes de Dépôt (à venir)
            Map<String, Object> statsDepots = new HashMap<>();
            statsDepots.put("nombre", 0L);
            statsDepots.put("capitalTotal", BigDecimal.ZERO);
            statsDepots.put("interessTotal", BigDecimal.ZERO);
            statsDepots.put("actifs", 0L);
            statsDepots.put("arrives", 0L);
            statistiquesParType.put("depots", statsDepots);
            
            // Activité récente (exemple avec clients récents)
            List<Client> clientsRecents = clients.stream()
                .sorted((c1, c2) -> {
                    if (c1.getDateCreation() == null && c2.getDateCreation() == null) return 0;
                    if (c1.getDateCreation() == null) return 1;
                    if (c2.getDateCreation() == null) return -1;
                    return c2.getDateCreation().compareTo(c1.getDateCreation());
                })
                .limit(5)
                .toList();
            
            // Comptes récents
            List<CompteStatutDTO> comptesRecents = comptesCourants.stream()
                .sorted((c1, c2) -> {
                    if (c1.getDateCreation() == null && c2.getDateCreation() == null) return 0;
                    if (c1.getDateCreation() == null) return 1;
                    if (c2.getDateCreation() == null) return -1;
                    return c2.getDateCreation().compareTo(c1.getDateCreation());
                })
                .limit(5)
                .toList();
            
            // Ajouter les données à la requête
            request.setAttribute("nombreClients", nombreClients);
            request.setAttribute("nombreComptesCourants", nombreComptesCourants);
            request.setAttribute("soldeTotal", soldeTotal);
            request.setAttribute("decouvertTotal", decouvertTotal);
            request.setAttribute("statistiquesParType", statistiquesParType);
            request.setAttribute("clientsRecents", clientsRecents);
            request.setAttribute("comptesRecents", comptesRecents);
            
            // Données pour les graphiques
            request.setAttribute("comptesActifs", comptesActifs);
            request.setAttribute("comptesSuspendus", comptesSuspendus);
            request.setAttribute("comptesFermes", comptesFermes);
            
            // Configuration du layout
            request.setAttribute("pageTitle", "Dashboard - Vue d'ensemble");
             request.setAttribute("contentPage", "/dashboard-content.jsp");
            
            LOGGER.info("Dashboard chargé avec succès - " + nombreClients + " clients, " + nombreComptesCourants + " comptes");
            
            // Rediriger directement vers le layout
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.severe("Erreur lors du chargement du dashboard : " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement du dashboard : " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}