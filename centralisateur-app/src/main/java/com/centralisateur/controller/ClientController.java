package com.centralisateur.controller;

import com.centralisateur.entity.Client;
import com.centralisateur.entity.StatutClient;
import com.centralisateur.service.ClientService;

import jakarta.ejb.EJB;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.UriInfo;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Contrôleur REST pour la gestion des clients
 * Endpoints pour créer, consulter et gérer les clients
 */
@Path("/clients")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ClientController {

    @EJB
    private ClientService clientService;

    @Context
    private UriInfo uriInfo;

    @GET
    @Path("/{id}")
    public Response getClientById(@PathParam("id") Long id) {
        try {
            Client client = clientService.getClientById(id);
            ClientResponse response = new ClientResponse(client);
            return Response.ok(response).build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.NOT_FOUND)
                .entity(new ErrorResponse(e.getMessage()))
                .build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Erreur interne du serveur"))
                .build();
        }
    }

    /**
     * Récupérer le statut actuel d'un client
     * GET /api/clients/{id}/statut
     */
    @GET
    @Path("/{id}/statut")
    public Response getStatutClient(@PathParam("id") Long id) {
        try {
            StatutClient statut = clientService.getStatutActuelClient(id);
            StatutResponse response = new StatutResponse(statut);
            return Response.ok(response).build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.NOT_FOUND)
                .entity(new ErrorResponse(e.getMessage()))
                .build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Erreur interne du serveur"))
                .build();
        }
    }

    /**
     * Classe pour la requête de création de client
     */
    public static class ClientRequest {
        private String nom;
        private String prenom;
        private String email;
        private String telephone;
        private String adresse;
        private String profession;
        private LocalDate dateNaissance;

        // Constructeurs
        public ClientRequest() {}

        // Getters et Setters
        public String getNom() { return nom; }
        public void setNom(String nom) { this.nom = nom; }

        public String getPrenom() { return prenom; }
        public void setPrenom(String prenom) { this.prenom = prenom; }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getTelephone() { return telephone; }
        public void setTelephone(String telephone) { this.telephone = telephone; }

        public String getAdresse() { return adresse; }
        public void setAdresse(String adresse) { this.adresse = adresse; }

        public String getProfession() { return profession; }
        public void setProfession(String profession) { this.profession = profession; }

        public LocalDate getDateNaissance() { return dateNaissance; }
        public void setDateNaissance(LocalDate dateNaissance) { this.dateNaissance = dateNaissance; }
    }

    /**
     * Classe pour la réponse de client
     */
    public static class ClientResponse {
        private Long id;
        private String nom;
        private String prenom;
        private String email;
        private String telephone;
        private String adresse;
        private String profession;
        private LocalDate dateNaissance;
        private LocalDateTime dateCreation;
        private String message;

        public ClientResponse() {}

        public ClientResponse(Client client) {
            this.id = client.getId();
            this.nom = client.getNom();
            this.prenom = client.getPrenom();
            this.email = client.getEmail();
            this.telephone = client.getTelephone();
            this.adresse = client.getAdresse();
            this.profession = client.getProfession();
            this.dateNaissance = client.getDateNaissance();
            this.dateCreation = client.getDateCreation();
            this.message = "Client enregistré avec succès";
        }

        // Getters et Setters
        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public String getNom() { return nom; }
        public void setNom(String nom) { this.nom = nom; }

        public String getPrenom() { return prenom; }
        public void setPrenom(String prenom) { this.prenom = prenom; }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getTelephone() { return telephone; }
        public void setTelephone(String telephone) { this.telephone = telephone; }

        public String getAdresse() { return adresse; }
        public void setAdresse(String adresse) { this.adresse = adresse; }

        public String getProfession() { return profession; }
        public void setProfession(String profession) { this.profession = profession; }

        public LocalDate getDateNaissance() { return dateNaissance; }
        public void setDateNaissance(LocalDate dateNaissance) { this.dateNaissance = dateNaissance; }

        public LocalDateTime getDateCreation() { return dateCreation; }
        public void setDateCreation(LocalDateTime dateCreation) { this.dateCreation = dateCreation; }

        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
    }

    /**
     * Classe pour la réponse de statut
     */
    public static class StatutResponse {
        private Long id;
        private String libelle;
        private String description;

        public StatutResponse() {}

        public StatutResponse(StatutClient statut) {
            this.id = statut.getId();
            this.libelle = statut.getLibelle();
            this.description = statut.getDescription();
        }

        // Getters et Setters
        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public String getLibelle() { return libelle; }
        public void setLibelle(String libelle) { this.libelle = libelle; }

        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
    }

    /**
     * Classe pour les réponses d'erreur
     */
    public static class ErrorResponse {
        private String error;
        private LocalDateTime timestamp;

        public ErrorResponse() {
            this.timestamp = LocalDateTime.now();
        }

        public ErrorResponse(String error) {
            this();
            this.error = error;
        }

        // Getters et Setters
        public String getError() { return error; }
        public void setError(String error) { this.error = error; }

        public LocalDateTime getTimestamp() { return timestamp; }
        public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
    }
}