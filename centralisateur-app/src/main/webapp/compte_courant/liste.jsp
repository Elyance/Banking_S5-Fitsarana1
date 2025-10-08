<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .page-container {
        padding: 2rem;
        max-width: 1400px;
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

    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1rem;
        margin-bottom: 2rem;
    }

    .stat-card {
        background: linear-gradient(135deg, var(--bg-primary), var(--bg-light));
        border: 1px solid var(--border-light);
        border-radius: var(--radius-md);
        padding: 1.5rem;
        text-align: center;
    }

    .stat-value {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--primary-color);
        margin-bottom: 0.25rem;
    }

    .stat-label {
        font-size: 0.875rem;
        color: var(--text-secondary);
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .actions-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
        gap: 1rem;
        flex-wrap: wrap;
    }

    .search-filters {
        display: flex;
        gap: 1rem;
        align-items: center;
        flex-wrap: wrap;
    }

    .quick-actions {
        display: flex;
        gap: 0.5rem;
        flex-wrap: wrap;
    }

    .btn {
        padding: 0.5rem 1rem;
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

    .btn-primary {
        background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
        color: white;
    }

    .btn-primary:hover {
        background: linear-gradient(135deg, var(--primary-dark), #1e40af);
        transform: translateY(-1px);
        box-shadow: var(--shadow-md);
        color: white;
        text-decoration: none;
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

    .table-container {
        background: var(--bg-white);
        border-radius: var(--radius-lg);
        padding: 1.5rem;
        box-shadow: var(--shadow-md);
        border: 1px solid var(--border-light);
        overflow-x: auto;
    }

    .accounts-table {
        width: 100%;
        border-collapse: collapse;
        margin: 0;
    }

    .accounts-table th {
        background: linear-gradient(135deg, var(--bg-primary), var(--bg-light));
        color: var(--text-primary);
        font-weight: 600;
        padding: 1rem;
        text-align: left;
        border-bottom: 2px solid var(--border-color);
        font-size: 0.875rem;
        white-space: nowrap;
    }

    .accounts-table td {
        padding: 1rem;
        border-bottom: 1px solid var(--border-light);
        vertical-align: top;
    }

    .accounts-table tr:hover {
        background: var(--bg-primary);
    }

    .account-number {
        font-weight: 600;
        color: var(--primary-color);
        font-family: 'Courier New', monospace;
    }

    .account-id {
        font-size: 0.75rem;
        color: var(--text-muted);
    }

    .client-name {
        font-weight: 600;
        color: var(--text-primary);
    }

    .client-email {
        font-size: 0.875rem;
        color: var(--text-secondary);
    }

    .balance-positive {
        color: #059669;
        font-weight: 600;
    }

    .balance-negative {
        color: var(--danger-color);
        font-weight: 600;
    }

    .status-badge {
        padding: 0.25rem 0.75rem;
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

    .accounts-table th:last-child,
    .accounts-table td:last-child {
        width: 160px;
        min-width: 160px;
    }

    .action-links {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .action-btn {
        font-size: 0.75rem;
        padding: 0.375rem 0.75rem;
        border-radius: var(--radius-sm);
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 0.375rem;
        transition: all var(--transition-fast);
        border: 1px solid;
        font-weight: 500;
        justify-content: flex-start;
        white-space: nowrap;
    }

    .action-btn-primary {
        background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
        color: white;
        border-color: var(--primary-color);
    }

    .action-btn-primary:hover {
        background: linear-gradient(135deg, var(--primary-dark), #1e40af);
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(37, 99, 235, 0.3);
        color: white;
        text-decoration: none;
    }

    .action-btn-secondary {
        background: var(--bg-light);
        color: var(--text-secondary);
        border-color: var(--border-color);
    }

    .action-btn-secondary:hover {
        background: var(--bg-primary);
        color: var(--primary-color);
        border-color: var(--primary-color);
        text-decoration: none;
        transform: translateY(-1px);
    }

    .action-btn-info {
        background: linear-gradient(135deg, #06b6d4, #0891b2);
        color: white;
        border-color: #06b6d4;
    }

    .action-btn-info:hover {
        background: linear-gradient(135deg, #0891b2, #0e7490);
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(6, 182, 212, 0.3);
        color: white;
        text-decoration: none;
    }

    .action-btn-success {
        background: linear-gradient(135deg, #059669, #047857);
        color: white;
        border-color: #059669;
    }

    .action-btn-success:hover {
        background: linear-gradient(135deg, #047857, #065f46);
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(5, 150, 105, 0.3);
        color: white;
        text-decoration: none;
    }

    .empty-state {
        text-align: center;
        padding: 3rem;
        color: var(--text-secondary);
    }

    .empty-state-icon {
        font-size: 4rem;
        margin-bottom: 1rem;
        opacity: 0.5;
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

    .alert-success {
        background: rgba(34, 197, 94, 0.1);
        border-color: rgba(34, 197, 94, 0.2);
        color: #059669;
    }

    .alert-error {
        background: rgba(239, 68, 68, 0.1);
        border-color: rgba(239, 68, 68, 0.2);
        color: var(--danger-color);
    }

    .summary-section {
        margin-top: 2rem;
        padding: 1.5rem;
        background: linear-gradient(135deg, var(--bg-primary), var(--bg-light));
        border-radius: var(--radius-md);
        border: 1px solid var(--border-light);
    }

    .summary-title {
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: 1rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .summary-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1rem;
    }

    .summary-item {
        text-align: center;
    }

    .summary-value {
        font-size: 1.25rem;
        font-weight: 700;
        color: var(--primary-color);
    }

    .summary-label {
        font-size: 0.875rem;
        color: var(--text-secondary);
    }

    /* Responsive */
    @media (max-width: 768px) {
        .page-container {
            padding: 1rem;
        }

        .actions-bar {
            flex-direction: column;
            align-items: stretch;
        }

        .search-filters,
        .quick-actions {
            justify-content: center;
        }

        .accounts-table {
            font-size: 0.875rem;
        }

        .accounts-table th,
        .accounts-table td {
            padding: 0.75rem 0.5rem;
        }
    }
</style>

<div class="page-container">
    <!-- En-tête de page -->
    <div class="page-header">
        <h1 class="page-title">
            <i class="fas fa-university"></i>
            Liste des Comptes Courants
        </h1>
        <p class="page-subtitle">Gestion et supervision de tous les comptes courants</p>
    </div>

    <!-- Messages d'état -->
    <c:if test="${not empty success}">
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            ${success}
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-error">
            <i class="fas fa-exclamation-triangle"></i>
            ${error}
        </div>
    </c:if>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            ${sessionScope.successMessage}
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-error">
            <i class="fas fa-exclamation-triangle"></i>
            ${sessionScope.errorMessage}
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <!-- Statistiques rapides -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-value">${nombreComptes}</div>
            <div class="stat-label">Comptes Total</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">
                <fmt:formatDate value="<%= new java.util.Date() %>" pattern="HH:mm" />
            </div>
            <div class="stat-label">Dernière MAJ</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">
                <c:set var="comptesActifs" value="0" />
                <c:forEach var="compte" items="${comptes}">
                    <c:if test="${compte.statutCompte == 'ACTIF'}">
                        <c:set var="comptesActifs" value="${comptesActifs + 1}" />
                    </c:if>
                </c:forEach>
                ${comptesActifs}
            </div>
            <div class="stat-label">Comptes Actifs</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">
                <c:set var="comptesEnDecouvert" value="0" />
                <c:forEach var="compte" items="${comptes}">
                    <c:if test="${compte.enDecouvert}">
                        <c:set var="comptesEnDecouvert" value="${comptesEnDecouvert + 1}" />
                    </c:if>
                </c:forEach>
                ${comptesEnDecouvert}
            </div>
            <div class="stat-label">En Découvert</div>
        </div>
    </div>

    <!-- Barre d'actions -->
    <div class="actions-bar">
        <div class="search-filters">
            <!-- Futur : filtres de recherche -->
        </div>
        <div class="quick-actions">
            <a href="${pageContext.request.contextPath}/compte-courant/creer" class="btn btn-primary">
                <i class="fas fa-plus"></i>
                Nouveau Compte
            </a>
            <a href="javascript:window.location.reload()" class="btn btn-secondary">
                <i class="fas fa-sync-alt"></i>
                Actualiser
            </a>
        </div>
    </div>

    <!-- Table des comptes -->
    <div class="table-container">
        <c:choose>
            <c:when test="${empty comptes}">
                <div class="empty-state">
                    <div class="empty-state-icon">
                        <i class="fas fa-university"></i>
                    </div>
                    <h3>Aucun compte courant trouvé</h3>
                    <p>Il n'y a actuellement aucun compte courant dans le système.</p>
                    <a href="${pageContext.request.contextPath}/compte-courant/creer" class="btn btn-primary">
                        <i class="fas fa-plus"></i>
                        Créer le premier compte
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <table class="accounts-table">
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag"></i> N° Compte</th>
                            <th><i class="fas fa-user"></i> Client</th>
                            <th><i class="fas fa-envelope"></i> Email</th>
                            <th><i class="fas fa-euro-sign"></i> Solde</th>
                            <th><i class="fas fa-coins"></i> Découvert</th>
                            <th><i class="fas fa-wallet"></i> Disponible</th>
                            <th><i class="fas fa-info-circle"></i> Statut</th>
                            <th><i class="fas fa-calendar"></i> Ouverture</th>
                            <th><i class="fas fa-cogs"></i> Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="compte" items="${comptes}">
                            <tr>
                                <!-- Numéro de compte -->
                                <td>
                                    <div class="account-number">${compte.numeroCompte}</div>
                                    <div class="account-id">ID: ${compte.compteId}</div>
                                </td>
                                
                                <!-- Client -->
                                <td>
                                    <div class="client-name">${compte.nomComplet}</div>
                                    <div class="account-id">ID: ${compte.clientId}</div>
                                </td>
                                
                                <!-- Email -->
                                <td>
                                    <div class="client-email">${compte.emailClient}</div>
                                </td>
                                
                                <!-- Solde -->
                                <td>
                                    <div class="${compte.enDecouvert ? 'balance-negative' : 'balance-positive'}">
                                        <fmt:formatNumber value="${compte.solde}" type="currency" currencySymbol="€" />
                                        <c:if test="${compte.enDecouvert}">
                                            <div style="font-size: 0.75rem; font-weight: normal;">
                                                <i class="fas fa-exclamation-triangle"></i> En découvert
                                            </div>
                                        </c:if>
                                    </div>
                                </td>
                                
                                <!-- Découvert autorisé -->
                                <td>
                                    <fmt:formatNumber value="${compte.decouvertAutorise}" type="currency" currencySymbol="€" />
                                </td>
                                
                                <!-- Solde disponible -->
                                <td>
                                    <div style="font-weight: 600;">
                                        <fmt:formatNumber value="${compte.soldeDisponible}" type="currency" currencySymbol="€" />
                                    </div>
                                </td>
                                
                                <!-- Statut -->
                                <td>
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
                                                <i class="fas fa-question-circle"></i> ${compte.statutCompte}
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <!-- Date ouverture -->
                                <td>
                                    ${compte.dateCreationFormatee}
                                </td>
                                
                                <!-- Actions -->
                                <td>
                                    <div class="action-links">
                                        <a href="${pageContext.request.contextPath}/compte-courant/transaction?compteId=${compte.compteId}" 
                                           class="action-btn action-btn-primary" 
                                           title="Effectuer une transaction">
                                            <i class="fas fa-exchange-alt"></i> Transaction
                                        </a>
                                        <a href="${pageContext.request.contextPath}/compte-courant/transactions?compteId=${compte.compteId}" 
                                           class="action-btn action-btn-info" 
                                           title="Voir l'historique des transactions">
                                            <i class="fas fa-history"></i> Historique
                                        </a>
                                        <a href="${pageContext.request.contextPath}/compte-courant/detail?id=${compte.compteId}" 
                                           class="action-btn action-btn-secondary" 
                                           title="Voir les détails du compte">
                                            <i class="fas fa-eye"></i> Détails
                                        </a>
                                        <a href="${pageContext.request.contextPath}/clients/details?id=${compte.clientId}" 
                                           class="action-btn action-btn-success" 
                                           title="Voir les détails du client">
                                            <i class="fas fa-user"></i> Client
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Résumé financier -->
    <c:if test="${not empty comptes}">
        <div class="summary-section">
            <h3 class="summary-title">
                <i class="fas fa-chart-line"></i>
                Résumé Financier
            </h3>
            <div class="summary-grid">
                <div class="summary-item">
                    <c:set var="totalSoldes" value="0" />
                    <c:forEach var="compte" items="${comptes}">
                        <c:set var="totalSoldes" value="${totalSoldes + compte.solde}" />
                    </c:forEach>
                    <div class="summary-value">
                        <fmt:formatNumber value="${totalSoldes}" type="currency" currencySymbol="€" />
                    </div>
                    <div class="summary-label">Total des Soldes</div>
                </div>
                <div class="summary-item">
                    <div class="summary-value">${comptesEnDecouvert} / ${nombreComptes}</div>
                    <div class="summary-label">Comptes en Découvert</div>
                </div>
                <div class="summary-item">
                    <c:set var="totalDecouvert" value="0" />
                    <c:forEach var="compte" items="${comptes}">
                        <c:set var="totalDecouvert" value="${totalDecouvert + compte.decouvertAutorise}" />
                    </c:forEach>
                    <div class="summary-value">
                        <fmt:formatNumber value="${totalDecouvert}" type="currency" currencySymbol="€" />
                    </div>
                    <div class="summary-label">Total Découvert Autorisé</div>
                </div>
            </div>
        </div>
    </c:if>
</div>