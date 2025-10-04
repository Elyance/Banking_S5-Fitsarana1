package com.compteCourant.service;

import com.compteCourant.entity.CompteCourant;
import com.compteCourant.entity.StatutCompte;
import com.compteCourant.entity.StatutCompteCourantMvt;
import com.compteCourant.entity.Transaction;
import com.compteCourant.entity.TypeOperation;
import com.compteCourant.repository.CompteCourantRepository;
import com.compteCourant.repository.StatutCompteRepository;
import com.compteCourant.repository.StatutCompteCourantMvtRepository;
import com.compteCourant.repository.TransactionRepository;
import com.compteCourant.repository.TypeOperationRepository;
import com.compteCourant.interfaceRemote.CompteCourantServiceRemote;

import jakarta.ejb.Remote;
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Service pour la gestion des opérations sur les comptes courants
 */
@Stateless
@Remote(CompteCourantServiceRemote.class)
public class CompteCourantService implements CompteCourantServiceRemote {

    @Inject
    private CompteCourantRepository compteCourantRepository;

    @Inject
    private TransactionRepository transactionRepository;

    @Inject
    private TypeOperationRepository typeOperationRepository;

    @Inject
    private StatutCompteRepository statutCompteRepository;

    @Inject
    private StatutCompteCourantMvtRepository statutCompteCourantMvtRepository;


    // Libellés des statuts de compte
    private static final String STATUT_ACTIF = "ACTIF";
    private static final String STATUT_FERME = "FERME";


    /**
     * Crée un nouveau compte courant
     */
    @Transactional
    public CompteCourant creerCompteCourant(String numeroCompte, Long clientId, BigDecimal decouvertAutorise) {
        // Vérifier si le numéro de compte existe déjà
        if (compteCourantRepository.existsByNumeroCompte(numeroCompte)) {
            throw new IllegalArgumentException("Un compte avec ce numéro existe déjà : " + numeroCompte);
        }

        // Vérifier si le client a déjà un compte courant
        List<CompteCourant> comptesExistants = compteCourantRepository.findByClientId(clientId);
        if (!comptesExistants.isEmpty()) {
            throw new IllegalArgumentException("Le client avec l'ID " + clientId + " possède déjà un compte courant. Numéro de compte existant : " + comptesExistants.get(0).getNumeroCompte());
        }

        // Créer le nouveau compte
        CompteCourant compte = new CompteCourant();
        compte.setNumeroCompte(numeroCompte);
        compte.setClientId(clientId);
        compte.setSolde(BigDecimal.ZERO);
        compte.setDecouvertAutorise(decouvertAutorise != null ? decouvertAutorise : BigDecimal.ZERO);
        compte.setDateCreation(LocalDateTime.now());
        compte.setDateModification(LocalDateTime.now());

        // Sauvegarder le compte
        compte = compteCourantRepository.save(compte);

        // Créer un mouvement de statut initial (ACTIF)
        StatutCompte statutActif = statutCompteRepository.findByLibelle(STATUT_ACTIF);
        if (statutActif != null) {
            StatutCompteCourantMvt mouvementInitial = new StatutCompteCourantMvt();
            mouvementInitial.setCompteCourantId(compte.getId());
            mouvementInitial.setStatutCompteId(statutActif.getId());
            mouvementInitial.setDateMvt(LocalDateTime.now());
            statutCompteCourantMvtRepository.save(mouvementInitial);
        }

        return compte;
    }

    /**
     * Supprime un compte courant (fermeture par changement de statut)
     */
    @Transactional
    public boolean supprimerCompteCourant(Long compteId) {
        CompteCourant compte = compteCourantRepository.findById(compteId);
        if (compte == null) {
            throw new IllegalArgumentException("Compte introuvable avec l'ID : " + compteId);
        }

        // Vérifier si le compte a un solde
        if (compte.getSolde().compareTo(BigDecimal.ZERO) != 0) {
            throw new IllegalStateException("Impossible de fermer un compte avec un solde non nul. Solde actuel : " + compte.getSolde());
        }

        // Récupérer le statut FERME
        StatutCompte statutFerme = statutCompteRepository.findByLibelle(STATUT_FERME);
        if (statutFerme == null) {
            throw new IllegalStateException("Statut FERME non configuré dans la base de données");
        }

        // Créer un mouvement de statut pour tracer la fermeture
        StatutCompteCourantMvt mouvement = new StatutCompteCourantMvt();
        mouvement.setCompteCourantId(compteId);
        mouvement.setStatutCompteId(statutFerme.getId());
        mouvement.setDateMvt(LocalDateTime.now());
        
        // Sauvegarder le mouvement de statut
        statutCompteCourantMvtRepository.save(mouvement);

        // Mettre à jour la date de modification du compte
        compte.setDateModification(LocalDateTime.now());
        compteCourantRepository.save(compte);

        return true;
    }

    /**
     * Effectue un dépôt sur un compte courant
     */
    @Transactional
    public Transaction deposer(Long compteId, BigDecimal montant, String description) {
        // Validation du montant
        if (montant == null || montant.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Le montant du dépôt doit être positif");
        }

        // Récupérer le compte
        CompteCourant compte = compteCourantRepository.findById(compteId);
        if (compte == null) {
            throw new IllegalArgumentException("Compte introuvable avec l'ID : " + compteId);
        }

        // Vérifier que le compte est actif
        if (estCompteFerme(compteId) || estCompteSuspendu(compteId)) {
            throw new IllegalStateException("Impossible d'effectuer un dépôt sur un compte fermé");
        }

        // Récupérer le type d'opération DEPOT
        TypeOperation typeDepot = typeOperationRepository.findById(1L);
        if (typeDepot == null) {
            throw new IllegalStateException("Type d'opération DEPOT non configuré");
        }

        // Créer la transaction de dépôt (montant positif)
        Transaction transaction = new Transaction();
        transaction.setCompteCourantId(compteId);
        transaction.setTypeOperationId(typeDepot.getId());
        transaction.setMontant(montant); // Montant positif pour un dépôt
        transaction.setDescription(description != null ? description : "Dépôt");
        transaction.setDateTransaction(LocalDateTime.now());

        // Sauvegarder la transaction
        transaction = transactionRepository.save(transaction);

        // Mettre à jour le solde du compte
        BigDecimal nouveauSolde = compte.getSolde().add(montant);
        compte.setSolde(nouveauSolde);
        compte.setDateModification(LocalDateTime.now());
        compteCourantRepository.save(compte);

        return transaction;
    }

    /**
     * Effectue un retrait sur un compte courant
     */
    @Transactional
    public Transaction retirer(Long compteId, BigDecimal montant, String description) {
        // Validation du montant
        if (montant == null || montant.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Le montant du retrait doit être positif");
        }

        // Récupérer le compte
        CompteCourant compte = compteCourantRepository.findById(compteId);
        if (compte == null) {
            throw new IllegalArgumentException("Compte introuvable avec l'ID : " + compteId);
        }

        // Vérifier que le compte est actif
        if (estCompteFerme(compteId) || estCompteSuspendu(compteId)) {
            throw new IllegalStateException("Impossible d'effectuer un retrait sur un compte fermé");
        }

        // Vérifier si le retrait est possible (solde + découvert autorisé)
        BigDecimal soldeDisponible = compte.getSolde().add(compte.getDecouvertAutorise());
        if (montant.compareTo(soldeDisponible) > 0) {
            throw new IllegalStateException(
                "Solde insuffisant. Solde actuel : " + compte.getSolde() + 
                ", Découvert autorisé : " + compte.getDecouvertAutorise() + 
                ", Montant demandé : " + montant
            );
        }

        // Récupérer le type d'opération RETRAIT
        TypeOperation typeRetrait = typeOperationRepository.findById(2L);
        if (typeRetrait == null) {
            throw new IllegalStateException("Type d'opération RETRAIT non configuré");
        }

        // Créer la transaction de retrait (montant négatif)
        Transaction transaction = new Transaction();
        transaction.setCompteCourantId(compteId);
        transaction.setTypeOperationId(typeRetrait.getId());
        transaction.setMontant(montant);
        transaction.setDescription(description != null ? description : "Retrait");
        transaction.setDateTransaction(LocalDateTime.now());

        // Sauvegarder la transaction
        transaction = transactionRepository.save(transaction);

        // Mettre à jour le solde du compte
        BigDecimal nouveauSolde = compte.getSolde().subtract(montant);
        compte.setSolde(nouveauSolde);
        compte.setDateModification(LocalDateTime.now());
        compteCourantRepository.save(compte);

        return transaction;
    }

    /**
     * Calcule et retourne le solde d'un compte
     * Le solde est calculé comme : Crédits - Débits
     */
    public BigDecimal getSolde(Long compteId) {
        CompteCourant compte = compteCourantRepository.findById(compteId);
        if (compte == null) {
            throw new IllegalArgumentException("Compte introuvable avec l'ID : " + compteId);
        }

        // Option 1 : Retourner le solde maintenu dans la table compte_courant
        return compte.getSolde();

        // Option 2 : Recalculer à partir des transactions (plus sûr mais plus lent)
        // BigDecimal soldeCalcule = transactionRepository.sumMontantByCompteCourantId(compteId);
        // return soldeCalcule != null ? soldeCalcule : BigDecimal.ZERO;
    }

    /**
     * Calcule le solde basé sur les transactions (méthode alternative)
     */
    public BigDecimal getSoldeCalcule(Long compteId) {
        CompteCourant compte = compteCourantRepository.findById(compteId);
        if (compte == null) {
            throw new IllegalArgumentException("Compte introuvable avec l'ID : " + compteId);
        }

        // Calculer le solde à partir des transactions
        BigDecimal soldeCalcule = transactionRepository.sumCreditsByCompteCourantId(compteId);
        soldeCalcule = soldeCalcule.subtract(transactionRepository.sumDebitsByCompteCourantId(compteId));
        return soldeCalcule != null ? soldeCalcule : BigDecimal.ZERO;
    }

    /**
     * Récupère la liste des transactions d'un compte
     */
    public List<Transaction> getTransactionsParCompte(Long compteId) {
        CompteCourant compte = compteCourantRepository.findById(compteId);
        if (compte == null) {
            throw new IllegalArgumentException("Compte introuvable avec l'ID : " + compteId);
        }

        return transactionRepository.findByCompteCourantId(compteId);
    }

    /**
     * Récupère la liste des transactions d'un compte avec pagination
     */
    public List<Transaction> getTransactionsParCompte(Long compteId, int offset, int limit) {
        CompteCourant compte = compteCourantRepository.findById(compteId);
        if (compte == null) {
            throw new IllegalArgumentException("Compte introuvable avec l'ID : " + compteId);
        }

        return transactionRepository.findByCompteCourantId(compteId, offset, limit);
    }

    /**
     * Récupère la liste de tous les comptes courants
     */
    public List<CompteCourant> getTousLesComptes() {
        return compteCourantRepository.findAll();
    }

    /**
     * Récupère un compte par son ID
     */
    public CompteCourant getCompteParId(Long compteId) {
        return compteCourantRepository.findById(compteId);
    }

    /**
     * Récupère un compte par son numéro
     */
    public CompteCourant getCompteParNumero(String numeroCompte) {
        return compteCourantRepository.findByNumeroCompte(numeroCompte);
    }

    /**
     * Récupère les comptes d'un client
     */
    public List<CompteCourant> getComptesParClient(Long clientId) {
        return compteCourantRepository.findByClientId(clientId);
    }

    /**
     * Vérifie si un compte est en découvert
     */
    public boolean estEnDecouvert(Long compteId) {
        CompteCourant compte = compteCourantRepository.findById(compteId);
        if (compte == null) {
            throw new IllegalArgumentException("Compte introuvable avec l'ID : " + compteId);
        }

        return compte.estEnDecouvert();
    }

    /**
     * Vérifie si un compte dépasse son découvert autorisé
     */
    public boolean depasseDecouvertAutorise(Long compteId) {
        CompteCourant compte = compteCourantRepository.findById(compteId);
        if (compte == null) {
            throw new IllegalArgumentException("Compte introuvable avec l'ID : " + compteId);
        }

        return compte.depasseDecouvertAutorise();
    }

    public StatutCompteCourantMvt getStatutActuel(Long compteId) {
        return statutCompteCourantMvtRepository.findLatestByCompteCourantId(compteId);
    }

    public boolean estCompteSuspendu(Long compteId) {
        StatutCompteCourantMvt statutActuel = getStatutActuel(compteId);
        if (statutActuel == null) {
            return false;
        }
        
        StatutCompte statut = statutCompteRepository.findById(statutActuel.getStatutCompteId());
        if (statut.equals(statutCompteRepository.findById(2L))) {
            return true;
        }
        return false;
    }

    public boolean estCompteFerme(Long compteId) {
        StatutCompteCourantMvt statutActuel = getStatutActuel(compteId);
        if (statutActuel == null) {
            return false;
        }
        
        StatutCompte statut = statutCompteRepository.findById(statutActuel.getStatutCompteId());
        if (statut.equals(statutCompteRepository.findById(3L))) {
            return true;
        }
        return false;
    }

    public boolean estCompteActif(Long compteId) {
        StatutCompteCourantMvt statutActuel = getStatutActuel(compteId);
        if (statutActuel == null) {
            return false;
        }
        
        StatutCompte statut = statutCompteRepository.findById(statutActuel.getStatutCompteId());
        if (statut.equals(statutCompteRepository.findById(1L))) {
            return true;
        }
        return false;
    }
   
}