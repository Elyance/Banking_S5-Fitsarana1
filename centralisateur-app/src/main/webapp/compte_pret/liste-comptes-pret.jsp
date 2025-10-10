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

    .montant-emprunte {
        color: var(--danger-color);
        font-weight: 600;
    }

    .montant-restant {
        color: #059669;
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

    .status-actif {
        background: rgba(34, 197, 94, 0.1);
        color: #059669;
    }

    .status-inactif {
        background: rgba(239, 68, 68, 0.1);
        color: var(--danger-color);
    }

    .status-en-attente {
        background: rgba(251, 191, 36, 0.1);
        color: #d97706;
    }

    .action-buttons {
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
</style>
    <div class="page-container">
        <!-- En-tête de page -->
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-hand-holding-usd"></i>
                Liste des Comptes de Prêt
            </h1>
            <p class="page-subtitle">Gestion et supervision des prêts bancaires</p>
        </div>

        <!-- Messages d'état -->
        <c:if test="${not empty message}">
            <div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
                <i class="fas fa-info-circle"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Statistiques rapides -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value">${nombreComptes}</div>
                <div class="stat-label">Prêts Total</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <%= java.time.LocalTime.now().format(java.time.format.DateTimeFormatter.ofPattern("HH:mm")) %>
                </div>
                <div class="stat-label">Dernière MAJ</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <c:set var="pretsActifs" value="0" />
                    <c:forEach var="compte" items="${comptes}">
                        <c:if test="${compte.statutCompte == 'ACTIF'}">
                            <c:set var="pretsActifs" value="${pretsActifs + 1}" />
                        </c:if>
                    </c:forEach>
                    ${pretsActifs}
                </div>
                <div class="stat-label">Prêts Actifs</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <c:set var="totalMontant" value="0" />
                    <c:forEach var="compte" items="${comptes}">
                        <c:set var="totalMontant" value="${totalMontant + compte.montantEmprunte}" />
                    </c:forEach>
                    <fmt:formatNumber value="${totalMontant}" type="currency" currencySymbol="Ar" maxFractionDigits="0"/>
                </div>
                <div class="stat-label">Total Prêts</div>
            </div>
        </div>

        <!-- Barre d'actions -->
        <div class="actions-bar">
            <div class="quick-actions">
                <a href="${pageContext.request.contextPath}/compte-pret/creer" class="btn btn-primary">
                    <i class="fas fa-plus"></i>
                    Nouveau Prêt
                </a>
                <a href="javascript:window.location.reload()" class="btn btn-secondary">
                    <i class="fas fa-sync-alt"></i>
                    Actualiser
                </a>
            </div>
        </div>

        <!-- Table des comptes -->
        <div class="table-container">
            <table class="accounts-table">
                <thead>
                    <tr>
                        <th><i class="fas fa-hashtag"></i> N° Compte</th>
                        <th><i class="fas fa-user"></i> Client</th>
                        <th><i class="fas fa-money-bill"></i> Montant Emprunté</th>
                        <th><i class="fas fa-wallet"></i> Solde Restant</th>
                        <th><i class="fas fa-percentage"></i> Taux</th>
                        <th><i class="fas fa-calendar-alt"></i> Durée</th>
                        <th><i class="fas fa-clock"></i> Début</th>
                        <th><i class="fas fa-money-check"></i> Paiement</th>
                        <th><i class="fas fa-info-circle"></i> Statut</th>
                        <th><i class="fas fa-cogs"></i> Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${comptes}" var="compte">
                        <tr>
                            <td>
                                <div class="account-number">${compte.numeroCompte}</div>
                                <div class="account-id">ID: ${compte.compteId}</div>
                            </td>
                            <td>
                                <div class="client-name">${compte.nomClient} ${compte.prenomClient}</div>
                                <div class="client-email">${compte.emailClient}</div>
                            </td>
                            <td>
                                <div class="montant-emprunte">
                                    <fmt:formatNumber value="${compte.montantEmprunte}" type="currency" currencySymbol="Ar" maxFractionDigits="0"/>
                                </div>
                            </td>
                            <td>
                                <div class="montant-restant">
                                    <fmt:formatNumber value="${compte.soldeRestantDu}" type="currency" currencySymbol="Ar" maxFractionDigits="0"/>
                                </div>
                                <div style="font-size: 0.75rem; color: var(--text-muted);">
                                    <fmt:formatNumber value="${(compte.montantEmprunte - compte.soldeRestantDu) / compte.montantEmprunte * 100}" type="number" maxFractionDigits="1"/>% remboursé
                                </div>
                            </td>
                            <td>
                                <div style="font-weight: 600; color: #0891b2;">
                                    <fmt:formatNumber value="${compte.tauxInteret}" type="percent" maxFractionDigits="2"/>
                                </div>
                            </td>
                            <td>
                                <div style="font-weight: 600;">${compte.dureeEnMois} mois</div>
                                <div style="font-size: 0.75rem; color: var(--text-muted);">
                                    <c:set var="moisRestants" value="${compte.dureeEnMois - 0}" />
                                    ${moisRestants} restants
                                </div>
                            </td>
                            <td>
                                <div style="font-weight: 500;">
                                    ${compte.dateDebutFormatee}
                                </div>
                            </td>
                            <td>
                                <span class="status-badge" style="background: rgba(6, 182, 212, 0.1); color: #0891b2;">
                                    ${compte.typePaiement}
                                </span>
                            </td>
                            <td>
                                <span class="status-badge ${compte.statutCompte == 'ACTIF' ? 'status-actif' : compte.statutCompte == 'INACTIF' ? 'status-inactif' : 'status-en-attente'}">
                                    <i class="fas fa-circle" style="font-size: 0.5rem; margin-right: 0.5rem;"></i>
                                    ${compte.statutCompte}
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/compte-pret/paiements?id=${compte.compteId}" 
                                       class="action-btn action-btn-primary" title="Gérer les paiements">
                                        <i class="fas fa-money-bill-wave"></i> Paiements
                                    </a>
                                    <a href="${pageContext.request.contextPath}/compte-pret/historiques?id=${compte.compteId}"
                                       class="action-btn action-btn-success" title="Voir les historiques de paiements">
                                        <i class="fas fa-history"></i> Historiques
                                    </a>
                                    <a href="${pageContext.request.contextPath}/compte-pret/details?id=${compte.compteId}" 
                                       class="action-btn action-btn-info" title="Voir les détails">
                                        <i class="fas fa-eye"></i> Détails
                                    </a>
                                    <a href="javascript:void(0)" onclick="confirmDelete('${compte.compteId}')"
                                       class="action-btn" style="background-color: #fee2e2; color: #dc2626; border-color: #fca5a5;"
                                       title="Supprimer le compte">
                                        <i class="fas fa-trash-alt"></i> Supprimer
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <c:if test="${empty comptes}">
            <div class="empty-state">
                <div class="empty-state-icon">
                    <i class="fas fa-hand-holding-usd"></i>
                </div>
                <h3>Aucun compte de prêt trouvé</h3>
                <p>Il n'y a actuellement aucun prêt dans le système.</p>
                <a href="${pageContext.request.contextPath}/compte-pret/creer" class="btn btn-primary">
                    <i class="fas fa-plus"></i>
                    Créer le premier prêt
                </a>
            </div>
        </c:if>
        
        <script>
            function confirmDelete(compteId) {
                if (confirm('Êtes-vous sûr de vouloir supprimer ce compte de prêt ?')) {
                    window.location.href = '${pageContext.request.contextPath}/compte-pret/supprimer?id=' + compteId;
                }
            }
        </script>
        
        <c:if test="${empty comptes}">
            <div class="alert alert-info d-flex align-items-center">
                <i class="fas fa-info-circle me-2"></i>
                <div>
                    Aucun compte de prêt n'a été trouvé. Vous pouvez en créer un nouveau en utilisant le bouton ci-dessus.
                </div>
            </div>
        </c:if>

        <div class="card mt-4">
            <div class="card-body">
                <h5 class="card-title">
                    <i class="fas fa-lightbulb me-2"></i>
                    Actions rapides
                </h5>
                <div class="btn-group">
                    <button type="button" class="btn btn-outline-primary" onclick="window.location.href='${pageContext.request.contextPath}/compte-pret/rapport'">
                        <i class="fas fa-chart-bar me-2"></i>
                        Générer un rapport
                    </button>
                    <button type="button" class="btn btn-outline-success" onclick="exportToExcel()">
                        <i class="fas fa-file-excel me-2"></i>
                        Exporter vers Excel
                    </button>
                    <button type="button" class="btn btn-outline-secondary" onclick="window.print()">
                        <i class="fas fa-print me-2"></i>
                        Imprimer la liste
                    </button>
                </div>
            </div>
        </div>
    </div>

<script>
    function exportToExcel() {
        alert('Fonctionnalité d\'exportation vers Excel à implémenter');
    }
</script>