package com.compteCourant.repository;

import com.compteCourant.entity.Client;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceContextType;
import jakarta.persistence.TypedQuery;
import java.time.LocalDate;
import java.util.List;

/**
 * Repository pour la gestion des Clients
 */
@ApplicationScoped
public class ClientRepository {

    @PersistenceContext(unitName = "CentralisateurPU", type = PersistenceContextType.TRANSACTION)
    private EntityManager em;

    /**
     * Recherche un client par son ID
     */
    public Client findById(Long id) {
        return em.find(Client.class, id);
    }

    /**
     * Récupère tous les clients
     */
    public List<Client> findAll() {
        TypedQuery<Client> query = em.createQuery(
            "SELECT c FROM Client c ORDER BY c.nom, c.prenom", 
            Client.class
        );
        return query.getResultList();
    }

    /**
     * Recherche un client par son email
     */
    public Client findByEmail(String email) {
        TypedQuery<Client> query = em.createQuery(
            "SELECT c FROM Client c WHERE c.email = :email", 
            Client.class
        );
        query.setParameter("email", email);
        
        List<Client> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Recherche un client par son numéro client
     */
    public Client findByNumeroClient(String numeroClient) {
        TypedQuery<Client> query = em.createQuery(
            "SELECT c FROM Client c WHERE c.numeroClient = :numeroClient", 
            Client.class
        );
        query.setParameter("numeroClient", numeroClient);
        
        List<Client> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Recherche des clients par nom (recherche partielle)
     */
    public List<Client> findByNomContaining(String nom) {
        TypedQuery<Client> query = em.createQuery(
            "SELECT c FROM Client c WHERE LOWER(c.nom) LIKE LOWER(:nom) ORDER BY c.nom, c.prenom", 
            Client.class
        );
        query.setParameter("nom", "%" + nom + "%");
        return query.getResultList();
    }

    /**
     * Recherche des clients par prénom (recherche partielle)
     */
    public List<Client> findByPrenomContaining(String prenom) {
        TypedQuery<Client> query = em.createQuery(
            "SELECT c FROM Client c WHERE LOWER(c.prenom) LIKE LOWER(:prenom) ORDER BY c.nom, c.prenom", 
            Client.class
        );
        query.setParameter("prenom", "%" + prenom + "%");
        return query.getResultList();
    }

    /**
     * Recherche des clients par nom ET prénom (recherche partielle)
     */
    public List<Client> findByNomAndPrenomContaining(String nom, String prenom) {
        TypedQuery<Client> query = em.createQuery(
            "SELECT c FROM Client c WHERE LOWER(c.nom) LIKE LOWER(:nom) AND LOWER(c.prenom) LIKE LOWER(:prenom) ORDER BY c.nom, c.prenom", 
            Client.class
        );
        query.setParameter("nom", "%" + nom + "%");
        query.setParameter("prenom", "%" + prenom + "%");
        return query.getResultList();
    }

    /**
     * Recherche des clients par statut
     */
    public List<Client> findByStatutClientId(Long statutClientId) {
        TypedQuery<Client> query = em.createQuery(
            "SELECT c FROM Client c WHERE c.statutClientId = :statutId ORDER BY c.nom, c.prenom", 
            Client.class
        );
        query.setParameter("statutId", statutClientId);
        return query.getResultList();
    }

    /**
     * Recherche des clients par profession
     */
    public List<Client> findByProfession(String profession) {
        TypedQuery<Client> query = em.createQuery(
            "SELECT c FROM Client c WHERE LOWER(c.profession) LIKE LOWER(:profession) ORDER BY c.nom, c.prenom", 
            Client.class
        );
        query.setParameter("profession", "%" + profession + "%");
        return query.getResultList();
    }

    /**
     * Recherche des clients nés entre deux dates
     */
    public List<Client> findByDateNaissanceBetween(LocalDate dateDebut, LocalDate dateFin) {
        TypedQuery<Client> query = em.createQuery(
            "SELECT c FROM Client c WHERE c.dateNaissance BETWEEN :dateDebut AND :dateFin ORDER BY c.dateNaissance", 
            Client.class
        );
        query.setParameter("dateDebut", dateDebut);
        query.setParameter("dateFin", dateFin);
        return query.getResultList();
    }

    /**
     * Recherche des clients créés entre deux dates
     */
    public List<Client> findByDateCreationBetween(LocalDate dateDebut, LocalDate dateFin) {
        TypedQuery<Client> query = em.createQuery(
            "SELECT c FROM Client c WHERE DATE(c.dateCreation) BETWEEN :dateDebut AND :dateFin ORDER BY c.dateCreation DESC", 
            Client.class
        );
        query.setParameter("dateDebut", dateDebut);
        query.setParameter("dateFin", dateFin);
        return query.getResultList();
    }

    /**
     * Sauvegarde un client (create ou update)
     */
    public Client save(Client client) {
        if (client.getId() == null) {
            em.persist(client);
            return client;
        } else {
            return em.merge(client);
        }
    }

    /**
     * Supprime un client
     */
    public void delete(Client client) {
        if (em.contains(client)) {
            em.remove(client);
        } else {
            em.remove(em.merge(client));
        }
    }

    /**
     * Supprime un client par son ID
     */
    public boolean deleteById(Long id) {
        Client client = findById(id);
        if (client != null) {
            delete(client);
            return true;
        }
        return false;
    }

    /**
     * Vérifie si un client existe par son ID
     */
    public boolean existsById(Long id) {
        return findById(id) != null;
    }

    /**
     * Vérifie si un email existe déjà
     */
    public boolean existsByEmail(String email) {
        return findByEmail(email) != null;
    }

    /**
     * Vérifie si un numéro client existe déjà
     */
    public boolean existsByNumeroClient(String numeroClient) {
        return findByNumeroClient(numeroClient) != null;
    }

    /**
     * Compte le nombre total de clients
     */
    public long count() {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(c) FROM Client c", 
            Long.class
        );
        return query.getSingleResult();
    }

    /**
     * Compte le nombre de clients par statut
     */
    public long countByStatutClientId(Long statutClientId) {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(c) FROM Client c WHERE c.statutClientId = :statutId", 
            Long.class
        );
        query.setParameter("statutId", statutClientId);
        return query.getSingleResult();
    }
}