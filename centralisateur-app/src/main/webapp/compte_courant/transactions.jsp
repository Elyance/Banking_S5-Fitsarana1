<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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

    .compte-info {
        background: var(--bg-white);
        border: 1px solid var(--border-light);
        border-radius: var(--radius-lg);
        margin-bottom: 2rem;
        box-shadow: var(--shadow-sm);
        overflow: hidden;
    }

    .compte-details {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 0;
    }

    .info-card {
        padding: 1.5rem;
        border-right: 1px solid var(--border-light);
        display: flex;
        flex-direction: column;
        justify-content: center;
    }

    .info-card:last-child {
        border-right: none;
    }

    .info-label {
        font-weight: 500;
        color: var(--text-secondary);
        font-size: 0.875rem;
        margin-bottom: 0.5rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .info-value {
        font-size: 1.125rem;
        color: var(--text-primary);
        font-weight: 600;
    }

    .transactions-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
        padding: 1.5rem 2rem;
        background: var(--bg-white);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-sm);
        border: 1px solid var(--border-light);
    }

    .transactions-title {
        color: var(--text-primary);
        font-size: 1.5rem;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .transactions-count {
        background: var(--success-color);
        color: white;
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-weight: 500;
        font-size: 0.875rem;
    }

    .transactions-table-container {
        background: var(--bg-white);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-sm);
        border: 1px solid var(--border-light);
        overflow: hidden;
        margin-bottom: 2rem;
    }

    .transactions-table {
        width: 100%;
        border-collapse: collapse;
    }

    .transactions-table th {
        background: var(--bg-primary);
        color: var(--text-primary);
        padding: 1rem;
        text-align: left;
        font-weight: 600;
        font-size: 0.875rem;
        border-bottom: 2px solid var(--border-light);
    }

    .transactions-table td {
        padding: 1rem;
        border-bottom: 1px solid var(--border-light);
        vertical-align: middle;
    }

    .transactions-table tr:nth-child(even) {
        background: var(--bg-light);
    }

    .transactions-table tr:hover {
        background: var(--bg-primary);
        transition: all var(--transition-fast);
    }

    .transactions-table tbody tr:last-child td {
        border-bottom: none;
    }

    .transaction-depot {
        color: var(--success-color);
        font-weight: 600;
    }

    .transaction-retrait {
        color: var(--danger-color);
        font-weight: 600;
    }

    .montant-positif {
        color: var(--success-color);
        font-weight: 700;
    }

    .montant-negatif {
        color: var(--danger-color);
        font-weight: 700;
    }

    .montant-neutre {
        color: var(--text-secondary);
        font-weight: 600;
    }

    .transaction-montant {
        font-family: 'JetBrains Mono', 'Fira Code', 'Courier New', monospace;
        font-size: 1rem;
        text-align: right;
    }

    .transaction-description {
        color: var(--text-secondary);
        max-width: 200px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        font-style: italic;
    }

    .transaction-date {
        color: var(--text-secondary);
        font-size: 0.875rem;
        font-weight: 500;
    }

    .transaction-type {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-weight: 500;
    }

    .transaction-reference {
        color: var(--text-secondary);
        font-family: 'JetBrains Mono', 'Fira Code', 'Courier New', monospace;
        font-size: 0.75rem;
    }

    .empty-state {
        text-align: center;
        padding: 4rem 2rem;
        color: var(--text-secondary);
        background: var(--bg-white);
        border-radius: var(--radius-lg);
        border: 1px solid var(--border-light);
        margin-bottom: 2rem;
    }

    .empty-state h4 {
        font-size: 1.25rem;
        margin-bottom: 1rem;
        color: var(--text-primary);
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
    }

    .empty-state p {
        margin-bottom: 0.5rem;
        line-height: 1.6;
    }

    .actions {
        display: flex;
        justify-content: center;
        gap: 1rem;
        margin-top: 2rem;
        padding: 2rem;
        background: var(--bg-white);
        border-radius: var(--radius-lg);
        border: 1px solid var(--border-light);
        box-shadow: var(--shadow-sm);
    }

    .btn {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.75rem 1.5rem;
        text-decoration: none;
        border-radius: var(--radius-sm);
        font-weight: 500;
        transition: all var(--transition-fast);
        border: none;
        cursor: pointer;
        font-size: 0.875rem;
    }

    .btn-primary {
        background: var(--primary-color);
        color: white;
    }

    .btn-primary:hover {
        background: var(--primary-dark);
        transform: translateY(-2px);
        box-shadow: var(--shadow-lg);
        text-decoration: none;
        color: white;
    }

    .btn-secondary {
        background: var(--bg-light);
        color: var(--text-secondary);
        border: 1px solid var(--border-color);
    }

    .btn-secondary:hover {
        background: var(--bg-primary);
        color: var(--text-primary);
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
        text-decoration: none;
    }

    .btn-success {
        background: var(--success-color);
        color: white;
    }

    .btn-success:hover {
        background: #059669;
        transform: translateY(-2px);
        box-shadow: var(--shadow-lg);
        text-decoration: none;
        color: white;
    }

    .alert {
        padding: 1rem;
        border-radius: var(--radius-sm);
        margin-bottom: 2rem;
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

        .compte-details {
            grid-template-columns: 1fr;
        }

        .info-card {
            border-right: none;
            border-bottom: 1px solid var(--border-light);
        }

        .info-card:last-child {
            border-bottom: none;
        }

        .transactions-header {
            flex-direction: column;
            align-items: stretch;
            gap: 1rem;
            padding: 1rem;
        }

        .transactions-table {
            font-size: 0.875rem;
        }

        .transactions-table th,
        .transactions-table td {
            padding: 0.75rem 0.5rem;
        }

        .transaction-description {
            max-width: 150px;
        }

        .actions {
            flex-direction: column;
            padding: 1rem;
        }
    }

    @media (max-width: 480px) {
        .transactions-table th:nth-child(4),
        .transactions-table td:nth-child(4),
        .transactions-table th:nth-child(5),
        .transactions-table td:nth-child(5) {
            display: none;
        }

        .transaction-montant {
            font-size: 0.875rem;
        }
    }
</style>

<div class="page-container">
    <!-- En-tête de page -->
    <div class="page-header">
        <h1 class="page-title">
            <i class="fas fa-history"></i>
            Historique des Transactions
        </h1>
        <p class="page-subtitle">Relevé détaillé des opérations du compte</p>
    </div>

    <c:if test="${not empty compte}">
        <!-- Informations du compte -->
        <div class="compte-info">
            <div class="compte-details">
                <div class="info-card">
                    <div class="info-label">
                        <i class="fas fa-hashtag"></i>
                        Numéro de compte
                    </div>
                    <div class="info-value">${compte.numeroCompte}</div>
                </div>
                <div class="info-card">
                    <div class="info-label">
                        <i class="fas fa-user"></i>
                        Titulaire
                    </div>
                    <div class="info-value">${prenomClient} ${nomClient}</div>
                </div>
                <div class="info-card">
                    <div class="info-label">
                        <i class="fas fa-euro-sign"></i>
                        Solde actuel
                    </div>
                    <div class="info-value">
                        <fmt:formatNumber value="${compte.solde}" type="currency" currencySymbol="€"/>
                    </div>
                </div>
                <div class="info-card">
                    <div class="info-label">
                        <i class="fas fa-wallet"></i>
                        Solde disponible
                    </div>
                    <div class="info-value">
                        <fmt:formatNumber value="${compte.solde + compte.decouvertAutorise}" type="currency" currencySymbol="€"/>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Messages d'erreur -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-triangle"></i>
            <strong>Erreur :</strong> ${error}
        </div>
    </c:if>

    <!-- En-tête des transactions -->
    <div class="transactions-header">
        <h3 class="transactions-title">
            <i class="fas fa-list"></i>
            Liste des Transactions
        </h3>
        <div class="transactions-count">
            <i class="fas fa-calculator"></i>
            ${nombreTransactions} transaction(s)
        </div>
    </div>

    <c:choose>
        <c:when test="${empty transactions}">
            <!-- État vide -->
            <div class="empty-state">
                <h4>
                    <i class="fas fa-search"></i>
                    Aucune transaction trouvée
                </h4>
                <p>Il n'y a aucune transaction enregistrée pour ce compte.</p>
                <p>Les nouvelles opérations apparaîtront ici automatiquement.</p>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Tableau des transactions -->
            <div class="transactions-table-container">
                <table class="transactions-table">
                    <thead>
                        <tr>
                            <th>
                                <i class="fas fa-calendar"></i>
                                Date
                            </th>
                            <th>
                                <i class="fas fa-tag"></i>
                                Type
                            </th>
                            <th>
                                <i class="fas fa-euro-sign"></i>
                                Montant
                            </th>
                            <th>
                                <i class="fas fa-comment"></i>
                                Description
                            </th>
                            <th>
                                <i class="fas fa-barcode"></i>
                                Référence
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="transaction" items="${transactions}">
                            <tr>
                                <td class="transaction-date">
                                    <i class="fas fa-clock"></i>
                                    ${transaction.dateTransactionFormatee}
                                </td>
                                <td class="transaction-type">
                                    <c:choose>
                                        <c:when test="${transaction.typeOperationLibelle == 'Dépôt'}">
                                            <i class="fas fa-plus-circle" style="color: var(--success-color);"></i>
                                            <span class="transaction-depot">${transaction.typeOperationLibelle}</span>
                                        </c:when>
                                        <c:when test="${transaction.typeOperationLibelle == 'Retrait'}">
                                            <i class="fas fa-minus-circle" style="color: var(--danger-color);"></i>
                                            <span class="transaction-retrait">${transaction.typeOperationLibelle}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-exchange-alt"></i>
                                            <span>${transaction.typeOperationLibelle}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="transaction-montant ${transaction.classeMontant}">
                                    ${transaction.montantAvecSigne}
                                </td>
                                <td class="transaction-description" title="${transaction.descriptionComplete}">
                                    <c:choose>
                                        <c:when test="${not empty transaction.descriptionCourte}">
                                            <i class="fas fa-sticky-note"></i>
                                            ${transaction.descriptionCourte}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: var(--text-muted);">
                                                <i class="fas fa-minus"></i>
                                                Aucune description
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="transaction-reference">
                                    ${transaction.referenceAffichage}
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Actions -->
    <div class="actions">
        <a href="${pageContext.request.contextPath}/compte-courant/detail?id=${compte.id}" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i>
            Retour aux détails
        </a>
        <a href="${pageContext.request.contextPath}/compte-courant/transaction?compteId=${compte.id}" class="btn btn-success">
            <i class="fas fa-plus"></i>
            Nouvelle transaction
        </a>
        <a href="${pageContext.request.contextPath}/compte-courant/liste" class="btn btn-secondary">
            <i class="fas fa-list"></i>
            Liste des comptes
        </a>
    </div>
</div>