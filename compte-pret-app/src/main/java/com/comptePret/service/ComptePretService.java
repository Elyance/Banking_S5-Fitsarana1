package com.comptePret.service;

import com.comptePret.entity.*;
import com.comptePret.interfaceRemote.ComptePretServiceRemote;
import com.comptePret.repository.*;
import com.banque.dto.ComptePretStatutDTO;
import com.banque.dto.TypePaiementDTO;
import java.util.ArrayList;
import jakarta.ejb.Remote;
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;

/**
 * Service pour la gestion des opérations sur les comptes prêts
 */
@Stateless
@Remote(ComptePretServiceRemote.class)
public class ComptePretService implements ComptePretServiceRemote {

    @Inject
    private ComptePretRepository comptePretRepository;

    @Inject
    private StatutComptePretRepository statutComptePretRepository;

    @Inject
    private MvtStatutComptePretRepository mvtStatutComptePretRepository;

    @Inject
    private TypePaiementRepository typePaiementRepository;

    /**
     * Crée un nouveau compte prêt
     */
    @Transactional
    public ComptePret creerComptePret(String numeroCompte, Long clientId, BigDecimal montantEmprunte,
                                     BigDecimal tauxInteret, Integer dureeTotaleMois, LocalDate dateDebut,
                                     Long typePaiementId) {
        

                                        
        // Vérifications préalables
        if (numeroCompte == null || numeroCompte.trim().isEmpty()) {
            throw new IllegalArgumentException("Le numéro de compte ne peut pas être vide");
        }

        if (comptePretRepository.existsByNumeroCompte(numeroCompte)) {
            throw new IllegalArgumentException("Le numéro de compte " + numeroCompte + " existe déjà");
        }

        if (clientId == null) {
            throw new IllegalArgumentException("L'identifiant du client ne peut pas être nul");
        }

        if (montantEmprunte == null) {
            throw new IllegalArgumentException("Le montant emprunté ne peut pas être nul");
        }

        if (montantEmprunte.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Le montant emprunté (" + montantEmprunte + 
                " €) doit être supérieur à 0");
        }

        if (tauxInteret == null) {
            throw new IllegalArgumentException("Le taux d'intérêt ne peut pas être nul");
        }

        if (tauxInteret.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Le taux d'intérêt (" + tauxInteret + 
                " %) ne peut pas être négatif");
        }

        if (dureeTotaleMois == null) {
            throw new IllegalArgumentException("La durée ne peut pas être nulle");
        }

        if (dureeTotaleMois <= 0) {
            throw new IllegalArgumentException("La durée (" + dureeTotaleMois + 
                " mois) doit être supérieure à 0");
        }

        if (dateDebut == null) {
            throw new IllegalArgumentException("La date de début ne peut pas être nulle");
        }

        if (dateDebut.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("La date de début (" + dateDebut + 
                ") ne peut pas être antérieure à la date du jour");
        }

        // Création du compte prêt
        ComptePret comptePret = new ComptePret(numeroCompte, clientId, montantEmprunte, 
                                               tauxInteret, dureeTotaleMois, dateDebut);

        // Association du type de paiement si spécifié
        if (typePaiementId != null) {
            TypePaiement typePaiement = typePaiementRepository.findById(typePaiementId);
            if (typePaiement != null) {
                comptePret.setTypePaiement(typePaiement);
            }
        }

        // Sauvegarde du compte prêt
        comptePret = comptePretRepository.save(comptePret);


        // Création du mouvement de statut initial (ACTIF)
        StatutComptePret statutActif = statutComptePretRepository.findById(1L); // ID 1 = ACTIF
        if (statutActif == null) {
            throw new IllegalStateException("Le statut ACTIF (ID=1) n'existe pas dans la base de données");
        }

        MvtStatutComptePret mouvementInitial = new MvtStatutComptePret(comptePret, statutActif, 
                                                                       "Création du compte prêt");
        mvtStatutComptePretRepository.save(mouvementInitial);

        return comptePret;
    }

    /**
     * Supprime un compte prêt (fermeture par changement de statut)
     */
    @Transactional
    public boolean supprimerComptePret(Long comptePretId) {
        ComptePret comptePret = comptePretRepository.findById(comptePretId);
        if (comptePret == null) {
            return false;
        }

        // Vérifier si le compte est entièrement remboursé
        if (!isEntierementRembourse(comptePretId)) {
            throw new IllegalStateException("Impossible de fermer un compte prêt non entièrement remboursé");
        }

        // Changer le statut à FERMÉ (ID 3)
        return changerStatutComptePret(comptePretId, 3L, "Fermeture du compte prêt");
    }

    /**
     * Calcule et retourne le solde restant dû d'un compte prêt
     */
    public BigDecimal getSoldeRestantDu(Long comptePretId) {
        ComptePret comptePret = comptePretRepository.findById(comptePretId);
        return comptePret != null ? comptePret.getSoldeRestantDu() : BigDecimal.ZERO;
    }

    /**
     * Trouve un compte prêt par son ID
     */
    public ComptePret getComptePretById(Long comptePretId) {
        return comptePretRepository.findById(comptePretId);
    }

    /**
     * Trouve un compte prêt par son numéro de compte
     */
    public ComptePret getComptePretByNumeroCompte(String numeroCompte) {
        return comptePretRepository.findByNumeroCompte(numeroCompte);
    }

    /**
     * Trouve tous les comptes prêts d'un client
     */
    public List<ComptePret> getComptePretsByClientId(Long clientId) {
        return comptePretRepository.findByClientId(clientId);
    }

    /**
     * Trouve tous les comptes prêts
     */
    public List<ComptePret> getAllComptesPret() {
        return comptePretRepository.findAll();
    }

    /**
     * Calcule le pourcentage remboursé pour un compte prêt
     */
    public BigDecimal getPourcentageRembourse(Long comptePretId) {
        ComptePret comptePret = comptePretRepository.findById(comptePretId);
        if (comptePret != null) {
            return comptePret.getPourcentageRembourse();
        }
        return BigDecimal.ZERO;
    }

    /**
     * Vérifie si un compte prêt est entièrement remboursé
     */
    public boolean isEntierementRembourse(Long comptePretId) {
        ComptePret comptePret = comptePretRepository.findById(comptePretId);
        return comptePret != null && comptePret.isEntierementRembourse();
    }

    /**
     * Change le statut d'un compte prêt par ID de statut
     */
    @Transactional
    public boolean changerStatutComptePret(Long comptePretId, Long statutId, String commentaire) {
        ComptePret comptePret = comptePretRepository.findById(comptePretId);
        if (comptePret == null) {
            return false;
        }

        StatutComptePret statut = statutComptePretRepository.findById(statutId);
        if (statut == null) {
            throw new IllegalArgumentException("Le statut avec l'ID " + statutId + " n'existe pas dans la base de données");
        }

        // Créer le mouvement de statut
        MvtStatutComptePret mouvement = new MvtStatutComptePret(comptePret, statut, commentaire);
        mvtStatutComptePretRepository.save(mouvement);

        return true;
    }

    /**
     * Change le statut d'un compte prêt par libellé (méthode de compatibilité)
     */
    @Transactional
    public boolean changerStatutComptePret(Long comptePretId, String nouveauStatut, String commentaire) {
        // Conversion du libellé vers l'ID correspondant
        Long statutId;
        switch (nouveauStatut.toUpperCase()) {
            case "ACTIF":
                statutId = 1L;
                break;
            case "SUSPENDU":
                statutId = 2L;
                break;
            case "FERMÉ":
            case "FERME":
                statutId = 3L;
                break;
            default:
                throw new IllegalArgumentException("Statut non reconnu : " + nouveauStatut);
        }
        
        return changerStatutComptePret(comptePretId, statutId, commentaire);
    }

    /**
     * Récupère le statut actuel d'un compte prêt
     */
    public String getStatutActuelComptePret(Long comptePretId) {
        MvtStatutComptePret dernierMouvement = mvtStatutComptePretRepository.findLatestByComptePretId(comptePretId);
        if (dernierMouvement != null && dernierMouvement.getStatutComptePret() != null) {
            return dernierMouvement.getStatutComptePret().getLibelle();
        }
        return "INCONNU";
    }

    /**
     * Vérifie si un numéro de compte prêt existe déjà
     */
    public boolean numeroCompteExiste(String numeroCompte) {
        return comptePretRepository.existsByNumeroCompte(numeroCompte);
    }

    /**
     * Calcule les intérêts dus pour un compte prêt à une date donnée
     */
    public BigDecimal calculerInteretsDus(Long comptePretId, LocalDate dateCalcul) {
        ComptePret comptePret = comptePretRepository.findById(comptePretId);
        if (comptePret == null) {
            return BigDecimal.ZERO;
        }

        // Calcul simple des intérêts mensuels
        BigDecimal tauxMensuel = comptePret.getTauxInteret().divide(BigDecimal.valueOf(12), 6, RoundingMode.HALF_UP);
        return comptePret.getSoldeRestantDu().multiply(tauxMensuel).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
    }

    /**
     * Compte le nombre de comptes prêts d'un client
     */
    public long getNombreComptesPretClient(Long clientId) {
        return comptePretRepository.countByClientId(clientId);
    }

    /**
     * Calcule la mensualité théorique d'un prêt (formule classique d'amortissement)
     */
    public BigDecimal calculerMensualiteSansInteret(BigDecimal montant, BigDecimal tauxAnnuel, Integer dureeMois) {
        if (montant.compareTo(BigDecimal.ZERO) <= 0 || dureeMois <= 0) {
            return BigDecimal.ZERO;
        }
        return montant.divide(BigDecimal.valueOf(dureeMois), 2, RoundingMode.HALF_UP);
    }

    /**
     * Récupère l'ID du statut actuel d'un compte prêt
     */
    public Long getIdStatutActuelComptePret(Long comptePretId) {
        MvtStatutComptePret dernierMouvement = mvtStatutComptePretRepository.findLatestByComptePretId(comptePretId);
        if (dernierMouvement != null && dernierMouvement.getStatutComptePret() != null) {
            return dernierMouvement.getStatutComptePret().getId();
        }
        return null;
    }

    /**
     * Vérifie si un compte prêt a un statut spécifique par ID
     */
    public boolean hasStatut(Long comptePretId, Long statutId) {
        Long statutActuel = getIdStatutActuelComptePret(comptePretId);
        return statutActuel != null && statutActuel.equals(statutId);
    }

    /**
     * Vérifie si un compte prêt est actif (statut ID = 1)
     */
    public boolean isComptePretActif(Long comptePretId) {
        return hasStatut(comptePretId, 1L);
    }

    /**
     * Vérifie si un compte prêt est suspendu (statut ID = 2)
     */
    public boolean isComptePretSuspendu(Long comptePretId) {
        return hasStatut(comptePretId, 2L);
    }

    /**
     * Vérifie si un compte prêt est fermé (statut ID = 3)
     */
    public boolean isComptePretFerme(Long comptePretId) {
        return hasStatut(comptePretId, 3L);
    }

    /**
     * Récupère tous les types de paiement disponibles
     */
    @Override
    public List<TypePaiementDTO> getAllTypesPaiement() {
        List<TypePaiement> typePaiements = typePaiementRepository.findAll();
        List<TypePaiementDTO> dtos = new ArrayList<>();

        for (TypePaiement tp : typePaiements) {
            TypePaiementDTO dto = new TypePaiementDTO();
            dto.setId(tp.getId());
            dto.setLibelle(tp.getLibelle());
            dto.setValeur(tp.getValeur());
            dto.setDescription(tp.getDescription());
            dtos.add(dto);
        }

        return dtos;
    }

    /**
     * Récupère tous les comptes prêts avec leurs types de paiement et statuts via JOIN
     */
    @Override
    public List<ComptePretStatutDTO> getAllComptePretWithTypeAndStatut() {
        List<Object[]> results = comptePretRepository.findAllWithTypeAndStatut();
        List<ComptePretStatutDTO> dtos = new ArrayList<>();

        for (Object[] result : results) {
            ComptePretStatutDTO dto = new ComptePretStatutDTO();
            
            // Mapping des résultats vers le DTO
            dto.setCompteId((Long) result[0]);
            dto.setNumeroCompte((String) result[1]);
            dto.setClientId((Long) result[2]);
            dto.setMontantEmprunte((BigDecimal) result[3]);
            dto.setSoldeRestantDu((BigDecimal) result[4]);
            dto.setTauxInteret((BigDecimal) result[5]);
            dto.setDureeTotaleMois((Integer) result[6]);
            dto.setDateDebut((LocalDate) result[7]);
            dto.setDateFinTheorique((LocalDate) result[8]);
            dto.setTypePaiementLibelle((String) result[9]);
            dto.setStatutId((Long) result[10]);
            dto.setStatutLibelle((String) result[11]);

            dtos.add(dto);
        }

        System.out.println("DEBUG: Récupérés " + dtos.size() + " comptes prêts avec types et statuts");

        return dtos;
    }

    // Compte pret actif par client
    @Override
    public long countActiveComptesPretByClientId(Long clientId) {
        return comptePretRepository.countActiveByClientId(clientId);
    }
}