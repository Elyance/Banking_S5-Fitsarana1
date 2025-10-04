<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Comptes Courants - Banque Centralisateur</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-12">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h4 class="mb-0">
                            <i class="fas fa-university me-2"></i>
                            Liste des Comptes Courants
                        </h4>
                        <a href="${pageContext.request.contextPath}/compte-courant/creer" 
                           class="btn btn-light btn-sm">
                            <i class="fas fa-plus me-1"></i>
                            Nouveau compte
                        </a>
                    </div>
                    <div class="card-body">
                        <!-- Messages -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                ${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Statistiques -->
                        <div class="row mb-4">
                            <div class="col-md-3">
                                <div class="card bg-info text-white">
                                    <div class="card-body text-center">
                                        <h5>${totalComptes}</h5>
                                        <small>Total Comptes</small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card bg-success text-white">
                                    <div class="card-body text-center">
                                        <h5>${comptesActifs}</h5>
                                        <small>Comptes Actifs</small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card bg-warning text-dark">
                                    <div class="card-body text-center">
                                        <h5>
                                            <fmt:formatNumber value="${soldeTotal}" type="currency" currencySymbol="€"/>
                                        </h5>
                                        <small>Solde Total</small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card bg-secondary text-white">
                                    <div class="card-body text-center">
                                        <h5>${comptesEnDecouvert}</h5>
                                        <small>En Découvert</small>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Tableau des comptes -->
                        <c:choose>
                            <c:when test="${empty comptes}">
                                <div class="text-center py-5">
                                    <i class="fas fa-university fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">Aucun compte courant trouvé</h5>
                                    <p class="text-muted">Commencez par créer votre premier compte courant.</p>
                                    <a href="${pageContext.request.contextPath}/compte-courant/creer" 
                                       class="btn btn-primary">
                                        <i class="fas fa-plus me-1"></i>
                                        Créer un compte
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead class="table-dark">
                                            <tr>
                                                <th><i class="fas fa-hashtag me-1"></i>N° Compte</th>
                                                <th><i class="fas fa-user me-1"></i>Client</th>
                                                <th><i class="fas fa-coins me-1"></i>Solde</th>
                                                <th><i class="fas fa-chart-line me-1"></i>Découvert</th>
                                                <th><i class="fas fa-calendar me-1"></i>Créé le</th>
                                                <th><i class="fas fa-info-circle me-1"></i>Statut</th>
                                                <th><i class="fas fa-cogs me-1"></i>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="compte" items="${comptes}">
                                                <tr>
                                                    <td>
                                                        <strong>${compte.numeroCompte}</strong>
                                                    </td>
                                                    <td>
                                                        <c:if test="${not empty compte.client}">
                                                            ${compte.client.nomComplet}
                                                            <br>
                                                            <small class="text-muted">${compte.client.email}</small>
                                                        </c:if>
                                                        <c:if test="${empty compte.client}">
                                                            <span class="text-muted">Client ID: ${compte.clientId}</span>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <span class="badge ${compte.solde >= 0 ? 'bg-success' : 'bg-danger'}">
                                                            <fmt:formatNumber value="${compte.solde}" type="currency" currencySymbol="€"/>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <fmt:formatNumber value="${compte.decouvertAutorise}" type="currency" currencySymbol="€"/>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${compte.dateCreation}" pattern="dd/MM/yyyy"/>
                                                        <br>
                                                        <small class="text-muted">
                                                            <fmt:formatDate value="${compte.dateCreation}" pattern="HH:mm"/>
                                                        </small>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${compte.estEnDecouvert}">
                                                                <span class="badge bg-warning">En découvert</span>
                                                            </c:when>
                                                            <c:when test="${compte.depasseDecouvertAutorise}">
                                                                <span class="badge bg-danger">Découvert dépassé</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-success">Actif</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group btn-group-sm" role="group">
                                                            <a href="${pageContext.request.contextPath}/compte-courant/details?id=${compte.id}" 
                                                               class="btn btn-outline-info" title="Voir détails">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/compte-courant/operations?id=${compte.id}" 
                                                               class="btn btn-outline-primary" title="Opérations">
                                                                <i class="fas fa-exchange-alt"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/compte-courant/transactions?id=${compte.id}" 
                                                               class="btn btn-outline-secondary" title="Historique">
                                                                <i class="fas fa-history"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination (si nécessaire) -->
                                <c:if test="${totalPages > 1}">
                                    <nav aria-label="Pagination des comptes">
                                        <ul class="pagination justify-content-center">
                                            <c:if test="${currentPage > 1}">
                                                <li class="page-item">
                                                    <a class="page-link" href="?page=${currentPage - 1}">Précédent</a>
                                                </li>
                                            </c:if>
                                            
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="?page=${i}">${i}</a>
                                                </li>
                                            </c:forEach>
                                            
                                            <c:if test="${currentPage < totalPages}">
                                                <li class="page-item">
                                                    <a class="page-link" href="?page=${currentPage + 1}">Suivant</a>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </nav>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>