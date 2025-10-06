package com.compteCourant.interfaceRemote;

import com.compteCourant.entity.CompteCourant;
import com.compteCourant.entity.Transaction;
import jakarta.ejb.Remote;
import java.math.BigDecimal;
import java.util.List;

/**
 * Interface Remote pour le service CompteCourant
 * Permet l'appel distant depuis d'autres applications
 */
@Remote
public interface CompteCourantServiceRemote {
    
    /**
     * Crée un nouveau compte courant
     */
    CompteCourant creerCompteCourant(String numeroCompte, Long clientId, BigDecimal decouvertAutorise);
    
    /**
     * Supprime un compte courant (fermeture par changement de statut)
     */
    boolean supprimerCompteCourant(Long compteId);
    
    /**
     * Effectue un dépôt sur un compte courant
     */
    Transaction deposer(Long compteId, BigDecimal montant, String description);
    
    /**
     * Effectue un retrait sur un compte courant
     */
    Transaction retirer(Long compteId, BigDecimal montant, String description);
    
    /**
     * Calcule et retourne le solde d'un compte
     */
    BigDecimal getSolde(Long compteId);
    
    /**
     * Récupère la liste des transactions d'un compte
     */
    List<Transaction> getTransactionsParCompte(Long compteId);
    
    /**
     * Récupère la liste des transactions d'un compte avec pagination
     */
    List<Transaction> getTransactionsParCompte(Long compteId, int offset, int limit);
    
    /**
     * Récupère la liste de tous les comptes courants
     */
    List<CompteCourant> getTousLesComptes();
    
    /**
     * Récupère les données des comptes sous forme de tableau d'objets
     * [0] = id, [1] = numeroCompte, [2] = clientId, [3] = solde, [4] = decouvertAutorise, [5] = dateCreation, [6] = dateModification
     */
    List<Object[]> getTousLesComptesAsArray();
    
    /**
     * Récupère un compte par son ID
     */
    CompteCourant getCompteParId(Long compteId);
    
    /**
     * Récupère un compte par son numéro
     */
    CompteCourant getCompteParNumero(String numeroCompte);
    
    /**
     * Récupère les comptes d'un client
     */
    List<CompteCourant> getComptesParClient(Long clientId);
    
    /**
     * Vérifie si un compte peut effectuer un retrait
     */
    boolean peutRetirerMontant(Long compteId, BigDecimal montant);
    
    /**
     * Calcule le solde disponible d'un compte (solde + découvert autorisé)
     */
    BigDecimal getSoldeDisponible(Long compteId);
    
    /**
     * Vérifie si un compte est en découvert
     */
    boolean estEnDecouvert(Long compteId);
    
    /**
     * Met à jour le découvert autorisé d'un compte
     */
    CompteCourant modifierDecouvertAutorise(Long compteId, BigDecimal nouveauDecouvert);
    
    /**
     * Compte le nombre total de comptes
     */
    long getNombreTotalComptes();
    
    /**
     * Compte le nombre de transactions d'un compte
     */
    long getNombreTransactions(Long compteId);
    
}