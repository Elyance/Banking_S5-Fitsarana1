<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    /* Copied and adapted from compte_courant/detail.jsp for consistency */
    .page-container { padding: 2rem; max-width: 1200px; margin: 0 auto; }
    .page-header { margin-bottom: 2rem; padding-bottom: 1rem; border-bottom: 2px solid var(--border-light); }
    .page-title { font-size: 2rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; display: flex; align-items: center; gap: 0.75rem; }
    .page-subtitle { color: var(--text-secondary); font-size: 1rem; }
    .detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-bottom: 2rem; }
    .detail-card { background: var(--bg-white); border-radius: var(--radius-lg); padding: 2rem; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); }
    .detail-card-title { font-size: 1.25rem; font-weight: 600; color: var(--text-primary); margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.5rem; padding-bottom: 0.75rem; border-bottom: 1px solid var(--border-light); }
    .detail-item { display: flex; justify-content: space-between; align-items: center; padding: 0.75rem 0; border-bottom: 1px solid var(--border-light); }
    .detail-item:last-child { border-bottom: none; }
    .detail-label { font-weight: 500; color: var(--text-secondary); font-size: 0.875rem; }
    .detail-value { font-weight: 600; color: var(--text-primary); text-align: right; }
    .status-badge { padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
    .status-actif { background: rgba(34, 197, 94, 0.1); color: #059669; }
    .status-inactif { background: rgba(239, 68, 68, 0.1); color: var(--danger-color); }
    .status-en-attente { background: rgba(251, 191, 36, 0.1); color: #d97706; }
    .back-button { margin-top: 2rem; text-align: center; }
    .btn { padding: 0.75rem 1.5rem; border-radius: var(--radius-sm); font-weight: 500; text-decoration: none; display: inline-flex; align-items: center; gap: 0.5rem; transition: all var(--transition-fast); border: none; cursor: pointer; font-size: 0.875rem; }
    .btn-secondary { background: var(--bg-light); color: var(--text-secondary); border: 1px solid var(--border-color); }
    .btn-secondary:hover { background: var(--bg-primary); color: var(--text-primary); text-decoration: none; }
    @media (max-width: 768px) { .page-container { padding: 1rem; } .detail-grid { grid-template-columns: 1fr; } .detail-card { padding: 1.5rem; } }
</style>

<div class="page-container">
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-triangle"></i>
            ${error}
        </div>
    </c:if>

    <c:if test="${not empty compte}">
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-hand-holding-usd"></i>
                Détails du Compte Prêt
            </h1>
            <p class="page-subtitle">Informations complètes et gestion du compte de prêt</p>
        </div>

        <div class="detail-grid">
            <div class="detail-card">
                <h3 class="detail-card-title">
                    <i class="fas fa-university"></i>
                    Informations du Compte Prêt
                </h3>
                <div class="detail-item">
                    <span class="detail-label"><i class="fas fa-hashtag"></i> Numéro de compte</span>
                    <span class="detail-value">${compte.numeroCompte}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label"><i class="fas fa-key"></i> ID Compte</span>
                    <span class="detail-value">${compte.compteId}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label"><i class="fas fa-euro-sign"></i> Montant Emprunté</span>
                    <span class="detail-value"><fmt:formatNumber value="${compte.montantEmprunte}" type="currency" currencySymbol="Ar" /></span>
                </div>
                <div class="detail-item">
                    <span class="detail-label"><i class="fas fa-wallet"></i> Solde Restant</span>
                    <span class="detail-value"><fmt:formatNumber value="${compte.soldeRestantDu}" type="currency" currencySymbol="Ar" /></span>
                </div>
                <div class="detail-item">
                    <span class="detail-label"><i class="fas fa-percentage"></i> Taux d'intérêt</span>
                    <span class="detail-value"><fmt:formatNumber value="${compte.tauxInteret}" type="percent" maxFractionDigits="2" /></span>
                </div>
                <div class="detail-item">
                    <span class="detail-label"><i class="fas fa-calendar-alt"></i> Durée</span>
                    <span class="detail-value">${compte.dureeEnMois} mois</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label"><i class="fas fa-calendar"></i> Date de début</span>
                    <span class="detail-value">${compte.dateDebutFormatee}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label"><i class="fas fa-money-check"></i> Type de paiement</span>
                    <span class="detail-value">${compte.typePaiement}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label"><i class="fas fa-info-circle"></i> Statut</span>
                    <span class="detail-value">
                        <c:choose>
                            <c:when test="${compte.statutCompte == 'ACTIF'}">
                                <span class="status-badge status-actif"><i class="fas fa-check-circle"></i> Actif</span>
                            </c:when>
                            <c:when test="${compte.statutCompte == 'INACTIF'}">
                                <span class="status-badge status-inactif"><i class="fas fa-times-circle"></i> Inactif</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-en-attente">${compte.statutCompte}</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
            <div class="detail-card">
                <h3 class="detail-card-title">
                    <i class="fas fa-user"></i>
                    Informations du Client
                </h3>
                <div class="detail-item">
                    <span class="detail-label"><i class="fas fa-key"></i> ID Client</span>
                    <span class="detail-value">${compte.clientId}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label"><i class="fas fa-user"></i> Nom</span>
                    <span class="detail-value">${compte.nomClient}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label"><i class="fas fa-user"></i> Prénom</span>
                    <span class="detail-value">${compte.prenomClient}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label"><i class="fas fa-envelope"></i> Email</span>
                    <span class="detail-value">${compte.emailClient}</span>
                </div>
            </div>
        </div>
    </c:if>
    <div class="back-button">
        <a href="${pageContext.request.contextPath}/compte-pret/liste" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i>
            Retour à la liste des comptes de prêt
        </a>
    </div>
</div>
