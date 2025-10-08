<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    .page-container {
        padding: 2rem;
        max-width: 1200px;
        margin: 0 auto;
    }

    .page-header {
        margin-bottom: 2rem;
        padding-bottom: 1rem;
        border-bottom: 2px solid var(--border-light);
    }

    .page-title {
        font-size: 2rem;
        font-weight: 700;
        color: var(--text-primary);
        margin-bottom: 0.5rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .page-subtitle {
        color: var(--text-secondary);
        font-size: 1rem;
    }

    .detail-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 2rem;
        margin-bottom: 2rem;
    }

    .detail-card {
        background: var(--bg-white);
        border-radius: var(--radius-lg);
        padding: 2rem;
        box-shadow: var(--shadow-md);
        border: 1px solid var(--border-light);
    }

    .detail-card-title {
        font-size: 1.25rem;
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        padding-bottom: 0.75rem;
        border-bottom: 1px solid var(--border-light);
    }

    .detail-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0.75rem 0;
        border-bottom: 1px solid var(--border-light);
    }

    .detail-item:last-child {
        border-bottom: none;
    }

    .detail-label {
        font-weight: 500;
        color: var(--text-secondary);
        font-size: 0.875rem;
    }

    .detail-value {
        font-weight: 600;
        color: var(--text-primary);
        text-align: right;
    }

    .detail-value.positive {
        color: #059669;
    }

    .detail-value.negative {
        color: var(--danger-color);
    }

    .status-badge {
        padding: 0.375rem 0.75rem;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .status-active {
        background: rgba(34, 197, 94, 0.1);
        color: #059669;
    }

    .status-suspended {
        background: rgba(251, 191, 36, 0.1);
        color: #d97706;
    }

    .status-closed {
        background: rgba(239, 68, 68, 0.1);
        color: var(--danger-color);
    }

    .account-summary {
        background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
        color: white;
        border-radius: var(--radius-lg);
        padding: 2rem;
        text-align: center;
        margin-bottom: 2rem;
        box-shadow: var(--shadow-lg);
    }

    .account-number {
        font-size: 2rem;
        font-weight: 700;
        margin-bottom: 0.5rem;
        font-family: 'Courier New', monospace;
    }

    .account-client {
        font-size: 1.25rem;
        margin-bottom: 1rem;
        opacity: 0.9;
    }

    .balance-display {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
        gap: 1rem;
        margin-top: 1.5rem;
    }

    .balance-item {
        background: rgba(255, 255, 255, 0.1);
        padding: 1rem;
        border-radius: var(--radius-md);
        backdrop-filter: blur(10px);
    }

    .balance-value {
        font-size: 1.5rem;
        font-weight: 700;
        margin-bottom: 0.25rem;
    }

    .balance-label {
        font-size: 0.875rem;
        opacity: 0.8;
    }

    .actions-section {
        margin-top: 2rem;
    }

    .actions-title {
        font-size: 1.25rem;
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: 1rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .actions-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1rem;
    }

    .action-card {
        background: var(--bg-white);
        border: 2px solid var(--border-color);
        border-radius: var(--radius-md);
        padding: 1.5rem;
        text-align: center;
        transition: all var(--transition-fast);
        text-decoration: none;
        color: var(--text-primary);
    }

    .action-card:hover {
        border-color: var(--primary-color);
        box-shadow: var(--shadow-md);
        transform: translateY(-2px);
        text-decoration: none;
        color: var(--text-primary);
    }

    .action-icon {
        font-size: 2rem;
        color: var(--primary-color);
        margin-bottom: 0.75rem;
    }

    .action-title {
        font-weight: 600;
        margin-bottom: 0.5rem;
    }

    .action-description {
        font-size: 0.875rem;
        color: var(--text-secondary);
    }

    .back-button {
        margin-top: 2rem;
        text-align: center;
    }

    .btn {
        padding: 0.75rem 1.5rem;
        border-radius: var(--radius-sm);
        font-weight: 500;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        transition: all var(--transition-fast);
        border: none;
        cursor: pointer;
        font-size: 0.875rem;
    }

    .btn-secondary {
        background: var(--bg-light);
        color: var(--text-secondary);
        border: 1px solid var(--border-color);
    }

    .btn-secondary:hover {
        background: var(--bg-primary);
        color: var(--text-primary);
        text-decoration: none;
    }

    .alert {
        padding: 1rem;
        border-radius: var(--radius-sm);
        margin-bottom: 1rem;
        border: 1px solid transparent;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .alert-danger {
        background: rgba(239, 68, 68, 0.1);
        border-color: rgba(239, 68, 68, 0.2);
        color: var(--danger-color);
    }

    /* Responsive */
    @media (max-width: 768px) {
        .page-container {
            padding: 1rem;
        }

        .detail-grid {
            grid-template-columns: 1fr;
        }

        .balance-display {
            grid-template-columns: 1fr;
        }

        .actions-grid {
            grid-template-columns: 1fr;
        }

        .account-summary {
            padding: 1.5rem;
        }

        .detail-card {
            padding: 1.5rem;
        }
    }
</style>

<div class="page-container">
    <!-- Messages d'erreur -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-triangle"></i>
            ${error}
        </div>
    </c:if>

    <c:if test="${not empty compte}">
        <!-- En-tête de page -->
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-university"></i>
                Détails du Compte
            </h1>
            <p class="page-subtitle">Informations complètes et gestion du compte courant</p>
        </div>

        <!-- Résumé du compte -->
        <div class="account-summary">
            <div class="account-number">${compte.numeroCompte}</div>
            <div class="account-client">${compte.nomComplet}</div>
            
            <div class="balance-display">
                <div class="balance-item">
                    <div class="balance-value">
                        <fmt:formatNumber value="${compte.solde}" type="currency" currencySymbol="€" />
                    </div>
                    <div class="balance-label">Solde Actuel</div>
                </div>
                <div class="balance-item">
                    <div class="balance-value">
                        <fmt:formatNumber value="${compte.decouvertAutorise}" type="currency" currencySymbol="€" />
                    </div>
                    <div class="balance-label">Découvert Autorisé</div>
                </div>
                <div class="balance-item">
                    <div class="balance-value">
                        <fmt:formatNumber value="${compte.soldeDisponible}" type="currency" currencySymbol="€" />
                    </div>
                    <div class="balance-label">Solde Disponible</div>
                </div>
            </div>
        </div>

        <!-- Détails en grille -->
        <div class="detail-grid">
            <!-- Informations du compte -->
            <div class="detail-card">
                <h3 class="detail-card-title">
                    <i class="fas fa-university"></i>
                    Informations du Compte
                </h3>
                
                <div class="detail-item">
                    <span class="detail-label">
                        <i class="fas fa-hashtag"></i>
                        Numéro de compte
                    </span>
                    <span class="detail-value">${compte.numeroCompte}</span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">
                        <i class="fas fa-key"></i>
                        ID Compte
                    </span>
                    <span class="detail-value">${compte.compteId}</span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">
                        <i class="fas fa-euro-sign"></i>
                        Solde actuel
                    </span>
                    <span class="detail-value ${compte.enDecouvert ? 'negative' : 'positive'}">
                        <fmt:formatNumber value="${compte.solde}" type="currency" currencySymbol="€" />
                        <c:if test="${compte.enDecouvert}">
                            <br><small><i class="fas fa-exclamation-triangle"></i> En découvert</small>
                        </c:if>
                    </span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">
                        <i class="fas fa-coins"></i>
                        Découvert autorisé
                    </span>
                    <span class="detail-value">
                        <fmt:formatNumber value="${compte.decouvertAutorise}" type="currency" currencySymbol="€" />
                    </span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">
                        <i class="fas fa-wallet"></i>
                        Solde disponible
                    </span>
                    <span class="detail-value">
                        <fmt:formatNumber value="${compte.soldeDisponible}" type="currency" currencySymbol="€" />
                    </span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">
                        <i class="fas fa-info-circle"></i>
                        Statut
                    </span>
                    <span class="detail-value">
                        <c:choose>
                            <c:when test="${compte.statutCompte == 'ACTIF'}">
                                <span class="status-badge status-active">
                                    <i class="fas fa-check-circle"></i> Actif
                                </span>
                            </c:when>
                            <c:when test="${compte.statutCompte == 'SUSPENDU'}">
                                <span class="status-badge status-suspended">
                                    <i class="fas fa-pause-circle"></i> Suspendu
                                </span>
                            </c:when>
                            <c:when test="${compte.statutCompte == 'FERME'}">
                                <span class="status-badge status-closed">
                                    <i class="fas fa-times-circle"></i> Fermé
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge">
                                    ${compte.statutCompte}
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">
                        <i class="fas fa-calendar"></i>
                        Date d'ouverture
                    </span>
                    <span class="detail-value">
                        ${compte.dateCreationFormatee}
                    </span>
                </div>
            </div>

            <!-- Informations du client -->
            <div class="detail-card">
                <h3 class="detail-card-title">
                    <i class="fas fa-user"></i>
                    Informations du Client
                </h3>
                
                <div class="detail-item">
                    <span class="detail-label">
                        <i class="fas fa-key"></i>
                        ID Client
                    </span>
                    <span class="detail-value">${compte.clientId}</span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">
                        <i class="fas fa-user"></i>
                        Nom complet
                    </span>
                    <span class="detail-value">${compte.nomComplet}</span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">
                        <i class="fas fa-signature"></i>
                        Nom
                    </span>
                    <span class="detail-value">${compte.nomClient}</span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">
                        <i class="fas fa-signature"></i>
                        Prénom
                    </span>
                    <span class="detail-value">${compte.prenomClient}</span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">
                        <i class="fas fa-envelope"></i>
                        Email
                    </span>
                    <span class="detail-value">${compte.emailClient}</span>
                </div>
            </div>
        </div>

        <!-- Actions disponibles -->
        <div class="actions-section">
            <h3 class="actions-title">
                <i class="fas fa-cogs"></i>
                Actions Disponibles
            </h3>
            
            <div class="actions-grid">
                <a href="${pageContext.request.contextPath}/compte-courant/transaction?compteId=${compte.compteId}" class="action-card">
                    <div class="action-icon">
                        <i class="fas fa-exchange-alt"></i>
                    </div>
                    <div class="action-title">Effectuer une Transaction</div>
                    <div class="action-description">Dépôt ou retrait sur ce compte</div>
                </a>
                
                <a href="${pageContext.request.contextPath}/compte-courant/transactions?compteId=${compte.compteId}" class="action-card">
                    <div class="action-icon">
                        <i class="fas fa-history"></i>
                    </div>
                    <div class="action-title">Historique des Transactions</div>
                    <div class="action-description">Consulter toutes les opérations</div>
                </a>
                
                <a href="${pageContext.request.contextPath}/clients/details?id=${compte.clientId}" class="action-card">
                    <div class="action-icon">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="action-title">Profil du Client</div>
                    <div class="action-description">Voir les détails du client</div>
                </a>
                
                <a href="${pageContext.request.contextPath}/compte-courant/liste" class="action-card">
                    <div class="action-icon">
                        <i class="fas fa-list"></i>
                    </div>
                    <div class="action-title">Liste des Comptes</div>
                    <div class="action-description">Retour à la liste complète</div>
                </a>
            </div>
        </div>
    </c:if>

    <!-- Bouton de retour -->
    <div class="back-button">
        <a href="${pageContext.request.contextPath}/compte-courant/liste" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i>
            Retour à la liste des comptes
        </a>
    </div>
</div>