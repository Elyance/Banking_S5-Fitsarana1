package com.centralisateur.service;

import com.compteCourant.interfaceRemote.CompteCourantServiceRemote;
import com.compteCourant.entity.CompteCourant;
import com.compteCourant.entity.Transaction;
import jakarta.ejb.EJB;
import jakarta.enterprise.context.ApplicationScoped;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Service d'intégration avec le module compte-courant
 * Utilise l'EJB distant pour les opérations sur les comptes courants
 */
@ApplicationScoped
public class CompteCourantIntegrationService {

    // Injection de l'EJB distant via lookup JNDI
    @EJB(lookup = "java:global/compte-courant-app/CompteCourantService!com.compteCourant.interfaceRemote.CompteCourantServiceRemote")
    private CompteCourantServiceRemote compteCourantService;

    /**
     * Crée un nouveau compte courant pour un client
     */
    public CompteCourant creerCompteCourant(String numeroCompte, Long clientId, BigDecimal decouvertAutorise) {
        try {
            return compteCourantService.creerCompteCourant(numeroCompte, clientId, decouvertAutorise);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la création du compte courant: " + e.getMessage(), e);
        }
    }

    /**
     * Ferme un compte courant (changement de statut)
     */
    public boolean fermerCompteCourant(Long compteId) {
        try {
            return compteCourantService.supprimerCompteCourant(compteId);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la fermeture du compte courant: " + e.getMessage(), e);
        }
    }

    /**
     * Effectue un dépôt sur un compte
     */
    public Transaction deposer(Long compteId, BigDecimal montant, String description) {
        try {
            return compteCourantService.deposer(compteId, montant, description);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du dépôt: " + e.getMessage(), e);
        }
    }

    /**
     * Effectue un retrait sur un compte
     */
    public Transaction retirer(Long compteId, BigDecimal montant, String description) {
        try {
            return compteCourantService.retirer(compteId, montant, description);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du retrait: " + e.getMessage(), e);
        }
    }

    /**
     * Récupère le solde d'un compte
     */
    public BigDecimal getSolde(Long compteId) {
        try {
            return compteCourantService.getSolde(compteId);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération du solde: " + e.getMessage(), e);
        }
    }

    /**
     * Récupère les transactions d'un compte
     */
    public List<Transaction> getTransactions(Long compteId) {
        try {
            return compteCourantService.getTransactionsParCompte(compteId);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération des transactions: " + e.getMessage(), e);
        }
    }

    /**
     * Récupère tous les comptes courants
     */
    public List<CompteCourant> getTousLesComptes() {
        try {
            return compteCourantService.getTousLesComptes();
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération des comptes: " + e.getMessage(), e);
        }
    }

    /**
     * Récupère tous les comptes courants sous forme de tableau d'objets
     */
    public List<CompteCourant> getTousLesComptesAsArray() {
        try {
            List<Object[]> data = compteCourantService.getTousLesComptesAsArray();
            List<CompteCourant> comptes = new ArrayList<>();
            
            for (Object[] row : data) {
                CompteCourant compte = new CompteCourant();
                compte.setId((Long) row[0]);
                compte.setNumeroCompte((String) row[1]);
                compte.setClientId((Long) row[2]);
                compte.setSolde((java.math.BigDecimal) row[3]);
                compte.setDecouvertAutorise((java.math.BigDecimal) row[4]);
                compte.setDateCreation((java.time.LocalDateTime) row[5]);
                compte.setDateModification((java.time.LocalDateTime) row[6]);
                comptes.add(compte);
            }
            
            return comptes;
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération des comptes: " + e.getMessage(), e);
        }
    }

    /**
     * Récupère un compte par son ID
     */
    public CompteCourant getCompteParId(Long compteId) {
        try {
            return compteCourantService.getCompteParId(compteId);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération du compte: " + e.getMessage(), e);
        }
    }

    /**
     * Récupère un compte par son numéro
     */
    public CompteCourant getCompteParNumero(String numeroCompte) {
        try {
            return compteCourantService.getCompteParNumero(numeroCompte);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération du compte: " + e.getMessage(), e);
        }
    }

    /**
     * Récupère les comptes d'un client
     */
    public List<CompteCourant> getComptesParClient(Long clientId) {
        try {
            return compteCourantService.getComptesParClient(clientId);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération des comptes du client: " + e.getMessage(), e);
        }
    }

    /**
     * Vérifie si un retrait est possible
     */
    public boolean peutRetirerMontant(Long compteId, BigDecimal montant) {
        try {
            return compteCourantService.peutRetirerMontant(compteId, montant);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la vérification du retrait: " + e.getMessage(), e);
        }
    }

    /**
     * Récupère le solde disponible (solde + découvert)
     */
    public BigDecimal getSoldeDisponible(Long compteId) {
        try {
            return compteCourantService.getSoldeDisponible(compteId);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération du solde disponible: " + e.getMessage(), e);
        }
    }

    /**
     * Vérifie si un compte est en découvert
     */
    public boolean estEnDecouvert(Long compteId) {
        try {
            return compteCourantService.estEnDecouvert(compteId);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la vérification du découvert: " + e.getMessage(), e);
        }
    }

    /**
     * Modifie le découvert autorisé d'un compte
     */
    public CompteCourant modifierDecouvertAutorise(Long compteId, BigDecimal nouveauDecouvert) {
        try {
            return compteCourantService.modifierDecouvertAutorise(compteId, nouveauDecouvert);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la modification du découvert: " + e.getMessage(), e);
        }
    }

    /**
     * Compte le nombre total de comptes
     */
    public long getNombreTotalComptes() {
        try {
            return compteCourantService.getNombreTotalComptes();
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du comptage des comptes: " + e.getMessage(), e);
        }
    }

    /**
     * Compte le nombre de transactions d'un compte
     */
    public long getNombreTransactions(Long compteId) {
        try {
            return compteCourantService.getNombreTransactions(compteId);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du comptage des transactions: " + e.getMessage(), e);
        }
    }
}