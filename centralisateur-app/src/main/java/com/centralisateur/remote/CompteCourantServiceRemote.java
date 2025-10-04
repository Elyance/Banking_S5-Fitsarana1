package com.centralisateur.remote;

import jakarta.ejb.Remote;
import java.math.BigDecimal;
import java.util.List;

/**
 * Interface Remote pour le service CompteCourant
 * Copie de l'interface du module compte-courant pour l'intégration
 */
@Remote
public interface CompteCourantServiceRemote {
    
    /**
     * Crée un nouveau compte courant
     */
    Object creerCompteCourant(String numeroCompte, Long clientId, BigDecimal decouvertAutorise);
    
    /**
     * Supprime un compte courant (fermeture par changement de statut)
     */
    boolean supprimerCompteCourant(Long compteId);
    
    /**
     * Effectue un dépôt sur un compte courant
     */
    Object deposer(Long compteId, BigDecimal montant, String description);
    
    /**
     * Effectue un retrait sur un compte courant
     */
    Object retirer(Long compteId, BigDecimal montant, String description);
    
    /**
     * Calcule et retourne le solde d'un compte
     */
    BigDecimal getSolde(Long compteId);
    
    /**
     * Récupère la liste des transactions d'un compte
     */
    List<?> getTransactionsParCompte(Long compteId);
    
    /**
     * Récupère la liste des transactions d'un compte avec pagination
     */
    List<?> getTransactionsParCompte(Long compteId, int offset, int limit);
    
    /**
     * Récupère la liste de tous les comptes courants
     */
    List<?> getTousLesComptes();
    
    /**
     * Récupère un compte par son ID
     */
    Object getCompteParId(Long compteId);
    
    /**
     * Récupère un compte par son numéro
     */
    Object getCompteParNumero(String numeroCompte);
    
    /**
     * Récupère les comptes d'un client
     */
    List<?> getComptesParClient(Long clientId);
    
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
    Object modifierDecouvertAutorise(Long compteId, BigDecimal nouveauDecouvert);
    
    /**
     * Compte le nombre total de comptes
     */
    long getNombreTotalComptes();
    
    /**
     * Compte le nombre de transactions d'un compte
     */
    long getNombreTransactions(Long compteId);
}