<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Header de bienvenue -->
<div class="page-header">
    <div class="d-flex justify-content-between align-items-center">
        <div>
            <h1 class="page-title">
                <i class="fas fa-tachometer-alt text-primary me-3"></i>
                Tableau de bord
            </h1>
            <p class="page-subtitle">Vue d'ensemble de votre système bancaire</p>
        </div>
        <div class="page-actions">
            <button class="btn btn-outline-primary btn-sm">
                <i class="fas fa-sync-alt me-2"></i>
                Actualiser
            </button>
        </div>
    </div>
</div>

<!-- Statistiques principales -->
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-icon primary">
            <i class="fas fa-users"></i>
        </div>
        <div class="stat-content">
            <div class="stat-value">${nombreClients != null ? nombreClients : 0}</div>
            <div class="stat-label">Clients enregistrés</div>
        </div>
    </div>
    
    <div class="stat-card">
        <div class="stat-icon success">
            <i class="fas fa-credit-card"></i>
        </div>
        <div class="stat-content">
            <div class="stat-value">${nombreComptesCourants != null ? nombreComptesCourants : 0}</div>
            <div class="stat-label">Comptes courants</div>
        </div>
    </div>
    
    <div class="stat-card">
        <div class="stat-icon warning">
            <i class="fas fa-euro-sign"></i>
        </div>
        <div class="stat-content">
            <div class="stat-value">
                <fmt:formatNumber value="${soldeTotal != null ? soldeTotal : 0}" pattern="#,##0.00"/>€
            </div>
            <div class="stat-label">Solde total</div>
        </div>
    </div>
    
    <div class="stat-card">
        <div class="stat-icon danger">
            <i class="fas fa-chart-line"></i>
        </div>
        <div class="stat-content">
            <div class="stat-value">
                <fmt:formatNumber value="${decouvertTotal != null ? decouvertTotal : 0}" pattern="#,##0.00"/>€
            </div>
            <div class="stat-label">Découvert autorisé</div>
        </div>
    </div>
</div>

<!-- Graphiques et données -->
<div class="row g-4 mt-4">
    <!-- Répartition des comptes -->
    <div class="col-lg-4">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title">
                    <i class="fas fa-chart-pie text-primary me-2"></i>
                    Répartition des comptes
                </h5>
            </div>
            <div class="card-body">
                <canvas id="comptesChart" width="300" height="300"></canvas>
            </div>
        </div>
    </div>
    
    <!-- Aperçu des modules futurs -->
    <div class="col-lg-8">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title">
                    <i class="fas fa-road text-primary me-2"></i>
                    Modules en développement
                </h5>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <!-- Module Prêts -->
                    <div class="col-md-6">
                        <div class="card border-warning">
                            <div class="card-body text-center">
                                <div class="stat-icon warning mx-auto mb-3">
                                    <i class="fas fa-hand-holding-usd"></i>
                                </div>
                                <h6 class="fw-bold">Comptes de Prêt</h6>
                                <p class="text-muted small mb-3">
                                    Gestion complète des prêts bancaires avec calcul d'intérêts
                                </p>
                                <div class="d-flex justify-content-between text-small mb-2">
                                    <span class="text-muted">Prêts actifs:</span>
                                    <span class="badge bg-warning">0</span>
                                </div>
                                <div class="d-flex justify-content-between text-small mb-3">
                                    <span class="text-muted">Capital prêté:</span>
                                    <span class="fw-bold">0 €</span>
                                </div>
                                <div class="progress mb-2" style="height: 4px;">
                                    <div class="progress-bar bg-warning" style="width: 25%"></div>
                                </div>
                                <small class="text-muted">Développement: 25%</small>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Module Dépôts -->
                    <div class="col-md-6">
                        <div class="card border-success">
                            <div class="card-body text-center">
                                <div class="stat-icon success mx-auto mb-3">
                                    <i class="fas fa-piggy-bank"></i>
                                </div>
                                <h6 class="fw-bold">Comptes de Dépôt</h6>
                                <p class="text-muted small mb-3">
                                    Produits d'épargne avec calcul automatique des intérêts
                                </p>
                                <div class="d-flex justify-content-between text-small mb-2">
                                    <span class="text-muted">Dépôts actifs:</span>
                                    <span class="badge bg-success">0</span>
                                </div>
                                <div class="d-flex justify-content-between text-small mb-3">
                                    <span class="text-muted">Capital épargné:</span>
                                    <span class="fw-bold">0 €</span>
                                </div>
                                <div class="progress mb-2" style="height: 4px;">
                                    <div class="progress-bar bg-success" style="width: 15%"></div>
                                </div>
                                <small class="text-muted">Développement: 15%</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Activité récente -->
<div class="row g-4 mt-4">
    <!-- Clients récents -->
    <div class="col-lg-6">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title">
                    <i class="fas fa-user-clock text-primary me-2"></i>
                    Clients récents
                </h5>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty clientsRecents}">
                        <c:forEach var="client" items="${clientsRecents}" varStatus="status">
                            <div class="d-flex align-items-center py-3 ${not status.last ? 'border-bottom' : ''}">
                                <div class="avatar-circle me-3">
                                    ${client.prenom.substring(0,1)}${client.nom.substring(0,1)}
                                </div>
                                <div class="flex-grow-1">
                                    <h6 class="mb-1 fw-semibold">${client.prenom} ${client.nom}</h6>
                                    <small class="text-muted">
                                        <c:choose>
                                            <c:when test="${client.dateCreation != null}">
                                                ${client.dateCreationFormatee}
                                            </c:when>
                                            <c:otherwise>Récent</c:otherwise>
                                        </c:choose>
                                    </small>
                                </div>
                                <a href="${pageContext.request.contextPath}/clients/details?id=${client.id}" 
                                   class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-eye"></i>
                                </a>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-users"></i>
                            <h3>Aucun client récent</h3>
                            <p>Les nouveaux clients apparaîtront ici</p>
                        </div>
                    </c:otherwise>
                </c:choose>
                
                <div class="text-center mt-3">
                    <a href="${pageContext.request.contextPath}/clients/liste" class="btn btn-primary">
                        <i class="fas fa-users me-2"></i>
                        Voir tous les clients
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Comptes récents -->
    <div class="col-lg-6">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title">
                    <i class="fas fa-credit-card text-primary me-2"></i>
                    Comptes récents
                </h5>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty comptesRecents}">
                        <c:forEach var="compte" items="${comptesRecents}" varStatus="status">
                            <div class="d-flex align-items-center py-3 ${not status.last ? 'border-bottom' : ''}">
                                <div class="avatar-circle me-3" style="background: linear-gradient(135deg, var(--accent-color), var(--primary-color));">
                                    <i class="fas fa-credit-card"></i>
                                </div>
                                <div class="flex-grow-1">
                                    <h6 class="mb-1 fw-semibold font-monospace">${compte.numeroCompte}</h6>
                                    <small class="text-muted">
                                        Solde: <fmt:formatNumber value="${compte.solde}" pattern="#,##0.00"/>€
                                    </small>
                                </div>
                                <div class="text-end">
                                    <c:choose>
                                        <c:when test="${compte.statutId == 1}">
                                            <span class="badge bg-success">Actif</span>
                                        </c:when>
                                        <c:when test="${compte.statutId == 2}">
                                            <span class="badge bg-warning">Suspendu</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">Fermé</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-credit-card"></i>
                            <h3>Aucun compte récent</h3>
                            <p>Les nouveaux comptes apparaîtront ici</p>
                        </div>
                    </c:otherwise>
                </c:choose>
                
                <div class="text-center mt-3">
                    <a href="${pageContext.request.contextPath}/compte-courant/liste" class="btn btn-success">
                        <i class="fas fa-list me-2"></i>
                        Voir tous les comptes
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Actions rapides -->
<div class="card mt-4">
    <div class="card-header">
        <h5 class="card-title">
            <i class="fas fa-bolt text-primary me-2"></i>
            Actions rapides
        </h5>
    </div>
    <div class="card-body">
        <div class="row g-3">
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/clients/nouveau" 
                   class="btn btn-outline-primary w-100 h-100 d-flex flex-column align-items-center justify-content-center py-4">
                    <i class="fas fa-user-plus fa-2x mb-2"></i>
                    <span class="fw-semibold">Nouveau Client</span>
                </a>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/compte-courant/creation" 
                   class="btn btn-outline-success w-100 h-100 d-flex flex-column align-items-center justify-content-center py-4">
                    <i class="fas fa-plus-circle fa-2x mb-2"></i>
                    <span class="fw-semibold">Nouveau Compte</span>
                </a>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/transaction/nouvelle" 
                   class="btn btn-outline-warning w-100 h-100 d-flex flex-column align-items-center justify-content-center py-4">
                    <i class="fas fa-exchange-alt fa-2x mb-2"></i>
                    <span class="fw-semibold">Transaction</span>
                </a>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/rapports" 
                   class="btn btn-outline-info w-100 h-100 d-flex flex-column align-items-center justify-content-center py-4">
                    <i class="fas fa-chart-bar fa-2x mb-2"></i>
                    <span class="fw-semibold">Rapports</span>
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Script pour le graphique -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Graphique en camembert pour la répartition des comptes
    const ctx = document.getElementById('comptesChart').getContext('2d');
    
    const comptesActifs = <c:out value="${comptesActifs}" default="0"/>;
    const comptesSuspendus = <c:out value="${comptesSuspendus}" default="0"/>;
    const comptesFermes = <c:out value="${comptesFermes}" default="0"/>;
    
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Comptes Actifs', 'Comptes Suspendus', 'Comptes Fermés'],
            datasets: [{
                data: [comptesActifs, comptesSuspendus, comptesFermes],
                backgroundColor: [
                    '#06d6a0',
                    '#fbbf24',
                    '#ef4444'
                ],
                borderWidth: 0,
                hoverBorderWidth: 2,
                hoverBorderColor: '#fff'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 20,
                        usePointStyle: true,
                        font: {
                            size: 12
                        }
                    }
                }
            },
            cutout: '60%'
        }
    });
});
</script>