package com.comptePret.interfaceRemote;

import jakarta.ejb.Remote;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import com.comptePret.entity.ComptePret;
import com.banque.dto.ComptePretStatutDTO;
import com.banque.dto.TypePaiementDTO;

/**
 * Interface Remote pour le service ComptePret
 * Version centralisateur - utilise des types génériques pour éviter les dépendances
 */
@Remote
public interface ComptePretServiceRemote {
    
    /**
     * Crée un nouveau compte prêt
     */
    ComptePret creerComptePret(String numeroCompte, Long clientId, BigDecimal montantEmprunte,
                          BigDecimal tauxInteret, Integer dureeTotaleMois, LocalDate dateDebut,
                          Long typePaiementId);
    
    /**
     * Supprime un compte prêt (fermeture par changement de statut)
     */
    boolean supprimerComptePret(Long comptePretId);
    
    /**
     * Effectue un remboursement sur un compte prêt
     */
    Object effectuerRemboursement(Long comptePretId, BigDecimal montant, String commentaire);
    
    /**
     * Calcule et retourne le solde restant dû d'un compte prêt
     */
    BigDecimal getSoldeRestantDu(Long comptePretId);
    
    /**
     * Trouve un compte prêt par son ID
     */
    Object getComptePretById(Long comptePretId);
    
    /**
     * Trouve un compte prêt par son numéro de compte
     */
    Object getComptePretByNumeroCompte(String numeroCompte);
    
    /**
     * Trouve tous les comptes prêts d'un client
     */
    List<?> getComptePretsByClientId(Long clientId);
    
    /**
     * Trouve tous les comptes prêts
     */
    List<ComptePret> getAllComptesPret();
    
    /**
     * Calcule le montant total remboursé pour un compte prêt
     */
    BigDecimal getTotalRembourse(Long comptePretId);
    
    /**
     * Calcule le pourcentage remboursé pour un compte prêt
     */
    BigDecimal getPourcentageRembourse(Long comptePretId);
    
    /**
     * Vérifie si un compte prêt est entièrement remboursé
     */
    boolean isEntierementRembourse(Long comptePretId);
    
    /**
     * Trouve tous les remboursements d'un compte prêt
     */
    List<?> getRemboursementsByComptePretId(Long comptePretId);
    
    /**
     * Change le statut d'un compte prêt par libellé
     */
    boolean changerStatutComptePret(Long comptePretId, String nouveauStatut, String commentaire);
    
    /**
     * Change le statut d'un compte prêt par ID de statut
     */
    boolean changerStatutComptePret(Long comptePretId, Long statutId, String commentaire);
    
    /**
     * Récupère le statut actuel d'un compte prêt
     */
    String getStatutActuelComptePret(Long comptePretId);
    
    /**
     * Récupère l'ID du statut actuel d'un compte prêt
     */
    Long getIdStatutActuelComptePret(Long comptePretId);
    
    /**
     * Vérifie si un compte prêt a un statut spécifique par ID
     */
    boolean hasStatut(Long comptePretId, Long statutId);
    
    /**
     * Vérifie si un compte prêt est actif (statut ID = 1)
     */
    boolean isComptePretActif(Long comptePretId);
    
    /**
     * Vérifie si un compte prêt est suspendu (statut ID = 2)
     */
    boolean isComptePretSuspendu(Long comptePretId);
    
    /**
     * Vérifie si un compte prêt est fermé (statut ID = 3)
     */
    boolean isComptePretFerme(Long comptePretId);
    
    /**
     * Vérifie si un numéro de compte prêt existe déjà
     */
    boolean numeroCompteExiste(String numeroCompte);
    
    /**
     * Calcule les intérêts dus pour un compte prêt à une date donnée
     */
    BigDecimal calculerInteretsDus(Long comptePretId, LocalDate dateCalcul);
    
    /**
     * Compte le nombre de comptes prêts d'un client
     */
    long getNombreComptesPretClient(Long clientId);
    
    /**
     * Calcule la mensualité théorique d'un prêt
     */
    BigDecimal calculerMensualiteSansInteret(BigDecimal montant, BigDecimal tauxAnnuel, Integer dureeMois);
    
    /**
     * Récupère tous les types de paiement disponibles
     * Retourne une liste d'objets qui seront convertis via réflexion
     */

    List<ComptePretStatutDTO> getAllComptePretWithTypeAndStatut();

    List<TypePaiementDTO> getAllTypesPaiement();

    long countActiveComptesPretByClientId(Long clientId);

}
