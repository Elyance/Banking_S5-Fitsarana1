package com.centralisateur.repository;

import com.centralisateur.entity.Client;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceContextType;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 * Repository pour la gestion des Clients
 */
@Stateless
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
     * Recherche des clients par nom (contient)
     */
    public List<Client> findByNomContaining(String nom) {
        TypedQuery<Client> query = em.createQuery(
            "SELECT c FROM Client c WHERE LOWER(c.nom) LIKE LOWER(:nom) ORDER BY c.nom", 
            Client.class
        );
        query.setParameter("nom", "%" + nom + "%");
        return query.getResultList();
    }

    /**
     * Recherche des clients par téléphone
     */
    public Client findByTelephone(String telephone) {
        TypedQuery<Client> query = em.createQuery(
            "SELECT c FROM Client c WHERE c.telephone = :telephone", 
            Client.class
        );
        query.setParameter("telephone", telephone);
        
        List<Client> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
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
}