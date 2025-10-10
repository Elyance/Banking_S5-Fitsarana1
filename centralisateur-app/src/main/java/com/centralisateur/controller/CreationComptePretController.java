package com.centralisateur.controller;

import com.centralisateur.entity.Client;
import com.centralisateur.service.ClientService;
import com.centralisateur.service.ComptePretIntegrationService;
import com.comptePret.entity.ComptePret;
import com.banque.dto.TypePaiementDTO;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Contrôleur pour la création de comptes prêts
 */
@WebServlet("/compte-pret/creer")
public class CreationComptePretController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CreationComptePretController.class.getName());

    @Inject
    private ClientService clientService;

    @Inject
    private ComptePretIntegrationService comptePretService;

    /**
     * Affiche le formulaire de création de compte prêt
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Récupérer la liste des clients
            List<Client> clients = clientService.getAllClients();
            request.setAttribute("clients", clients);

            // Récupérer les types de paiement
            List<TypePaiementDTO> typesPaiement = comptePretService.getAllTypesPaiement();
            request.setAttribute("typesPaiement", typesPaiement);

            // Vérifier s'il y a un client pré-sélectionné
            String clientIdParam = request.getParameter("clientId");
            if (clientIdParam != null && !clientIdParam.trim().isEmpty()) {
                try {
                    Long clientId = Long.parseLong(clientIdParam);
                    Client selectedClient = clientService.getClientById(clientId);
                    if (selectedClient != null) {
                        request.setAttribute("selectedClientId", clientId);
                        request.setAttribute("selectedClient", selectedClient);
                    }
                } catch (NumberFormatException e) {
                    LOGGER.warning("ID client invalide : " + clientIdParam);
                }
            }

            LOGGER.info("Affichage du formulaire de création de compte prêt");

            // Afficher le formulaire
            request.setAttribute("pageTitle", "Création de Compte Prêt");
            request.setAttribute("contentPage", "/compte_pret/creation-compte-pret.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de l'affichage du formulaire de création de compte prêt", e);
            request.setAttribute("error", "Erreur lors du chargement du formulaire : " + e.getMessage());
            request.setAttribute("pageTitle", "Erreur - Création de Compte Prêt");
            request.setAttribute("contentPage", "/compte_pret/creation-compte-pret.jsp");
            request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);
        }
    }

    /**
     * Traite la création d'un nouveau compte prêt
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Récupération et validation des paramètres
            Long clientId = Long.parseLong(request.getParameter("clientId"));
            String numeroCompte = request.getParameter("numeroCompte");
            BigDecimal montantEmprunte = new BigDecimal(request.getParameter("montantEmprunte"));
            BigDecimal tauxInteret = new BigDecimal(request.getParameter("tauxInteret"));
            Integer dureeMois = Integer.parseInt(request.getParameter("dureeMois"));
            Long typePaiementId = Long.parseLong(request.getParameter("typePaiementId"));
            LocalDate dateDebut = LocalDate.now();

            LOGGER.info(String.format("Création de compte prêt - Client: %d, Montant: %s, Durée: %d mois",
                    clientId, montantEmprunte, dureeMois));

            // Validations métier
            StringBuilder errors = new StringBuilder();

            if (montantEmprunte.compareTo(BigDecimal.ZERO) <= 0) {
                errors.append("Le montant emprunté doit être positif. ");
            }

            if (montantEmprunte.compareTo(new BigDecimal("1000000")) > 0) {
                errors.append("Le montant emprunté ne peut pas dépasser 1 000 000€. ");
            }

            if (tauxInteret.compareTo(BigDecimal.ZERO) < 0 || tauxInteret.compareTo(new BigDecimal("50")) > 0) {
                errors.append("Le taux d'intérêt doit être entre 0% et 50%. ");
            }

            // Vérifier que le client existe
            Client client = clientService.getClientById(clientId);
            if (client == null) {
                errors.append("Client introuvable. ");
            } else if (clientService.getStatutActuelClient(clientId).getId() != 1) {
                errors.append("Le client n'est pas actif. ");
            } else {
                // Vérifier le nombre de comptes prêt du client
                long nombreComptes = comptePretService.getNombreComptesPretActifsClient(clientId);
                if (nombreComptes >= 1) {
                    errors.append("Le client a déjà un compte prêt actif. ");
                }
            }

            // Si des erreurs, retourner au formulaire
            if (errors.length() > 0) {
                request.setAttribute("error", errors.toString());
                request.setAttribute("clientId", clientId);
                request.setAttribute("numeroCompte", numeroCompte);
                request.setAttribute("montantEmprunte", montantEmprunte);
                request.setAttribute("tauxInteret", tauxInteret);
                request.setAttribute("dureeMois", dureeMois);
                request.setAttribute("dateDebut", dateDebut);
                request.setAttribute("typePaiementId", typePaiementId);
                doGet(request, response);
                return;
            }

            // Créer le compte prêt
            ComptePret comptePret = new ComptePret();
            comptePret = comptePretService.creerComptePret(numeroCompte, clientId, montantEmprunte,
                                                          tauxInteret, dureeMois, dateDebut,
                                                          typePaiementId);

            if (comptePret != null) {
                // Succès
                LOGGER.info("Compte prêt créé avec succès : " + numeroCompte);

                // Récupérer les détails du compte créé via réflexion
                try {

                    Long compteId = comptePret.getId();
                    BigDecimal montant = comptePret.getMontantEmprunte();
                    LocalDate dateCreation = comptePret.getDateDebut();

                    request.setAttribute("success", true);
                    request.setAttribute("message", "Compte prêt créé avec succès !");
                    request.setAttribute("numeroCompte", numeroCompte);
                    request.setAttribute("clientNom", client.getNomComplet());
                    request.setAttribute("montantEmprunte", montant);
                    request.setAttribute("compteId", compteId);
                    request.setAttribute("dateCreation", dateCreation);

                } catch (Exception reflectException) {
                    LOGGER.log(Level.WARNING, "Erreur lors de l'extraction des détails du compte", reflectException);
                    request.setAttribute("success", true);
                    request.setAttribute("message", "Compte prêt créé avec succès !");
                    request.setAttribute("numeroCompte", numeroCompte);
                    request.setAttribute("clientNom", client.getNomComplet());
                }

                // Rediriger vers la page de succès
                request.setAttribute("pageTitle", "Compte Prêt Créé");
                request.setAttribute("contentPage", "/compte_pret/compte-pret-succes.jsp");
                request.getRequestDispatcher("/includes/layout.jsp").forward(request, response);

            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Erreur de format dans les paramètres", e);
            request.setAttribute("error", "Erreur dans les données saisies. Vérifiez les montants et les dates."+ e.getMessage());
            doGet(request, response);

        } catch (DateTimeParseException e) {
            LOGGER.log(Level.WARNING, "Erreur de format de date", e);
            request.setAttribute("error", "Format de date invalide. Utilisez le format JJ/MM/AAAA.");
            doGet(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la création du compte prêt", e);
            request.setAttribute("error", "Erreur technique lors de la création du compte : " + e.getMessage());
            doGet(request, response);
        }
    }
}
