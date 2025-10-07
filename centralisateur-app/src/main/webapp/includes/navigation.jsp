<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Navigation principale extensible -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow">
    <div class="container-fluid">
        <!-- Logo et nom de l'application -->
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/">
            <i class="fas fa-university me-2"></i>
            Banking System
        </a>
        
        <!-- Bouton responsive -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <!-- Menu principal -->
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <!-- Dashboard -->
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.endsWith('/') ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/">
                        <i class="fas fa-tachometer-alt me-1"></i>
                        Dashboard
                    </a>
                </li>
                
                <!-- Gestion des Clients -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="clientsDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-users me-1"></i>
                        Clients
                    </a>
                    <ul class="dropdown-menu">
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/clients/liste">
                                <i class="fas fa-list me-2"></i>
                                Liste des clients
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/clients/nouveau">
                                <i class="fas fa-user-plus me-2"></i>
                                Nouveau client
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/clients/recherche">
                                <i class="fas fa-search me-2"></i>
                                Rechercher
                            </a>
                        </li>
                    </ul>
                </li>
                
                <!-- Comptes Courants -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="comptesCourantsDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-credit-card me-1"></i>
                        Comptes Courants
                    </a>
                    <ul class="dropdown-menu">
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/compte-courant/liste">
                                <i class="fas fa-list me-2"></i>
                                Liste des comptes
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/compte-courant/creation">
                                <i class="fas fa-plus me-2"></i>
                                Nouveau compte
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/transaction/nouvelle">
                                <i class="fas fa-exchange-alt me-2"></i>
                                Nouvelle transaction
                            </a>
                        </li>
                    </ul>
                </li>
                
                <!-- Comptes de Prêt (à venir) -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-muted" href="#" id="comptesPretsDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-hand-holding-usd me-1"></i>
                        Comptes de Prêt
                        <small class="badge bg-warning ms-1">Bientôt</small>
                    </a>
                    <ul class="dropdown-menu">
                        <li>
                            <a class="dropdown-item disabled" href="#">
                                <i class="fas fa-list me-2"></i>
                                Liste des prêts
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item disabled" href="#">
                                <i class="fas fa-plus me-2"></i>
                                Nouveau prêt
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item disabled" href="#">
                                <i class="fas fa-calculator me-2"></i>
                                Simulateur
                            </a>
                        </li>
                    </ul>
                </li>
                
                <!-- Comptes de Dépôt (à venir) -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-muted" href="#" id="comptesDepotsDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-piggy-bank me-1"></i>
                        Comptes de Dépôt
                        <small class="badge bg-warning ms-1">Bientôt</small>
                    </a>
                    <ul class="dropdown-menu">
                        <li>
                            <a class="dropdown-item disabled" href="#">
                                <i class="fas fa-list me-2"></i>
                                Liste des dépôts
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item disabled" href="#">
                                <i class="fas fa-plus me-2"></i>
                                Nouveau dépôt
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item disabled" href="#">
                                <i class="fas fa-chart-line me-2"></i>
                                Rendements
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
            
            <!-- Outils et informations -->
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="toolsDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-cog me-1"></i>
                        Outils
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/rapports">
                                <i class="fas fa-chart-bar me-2"></i>
                                Rapports
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/api-docs">
                                <i class="fas fa-code me-2"></i>
                                API Documentation
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item" href="#" onclick="window.print()">
                                <i class="fas fa-print me-2"></i>
                                Imprimer
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Fil d'Ariane -->
<nav aria-label="breadcrumb" class="bg-light border-bottom">
    <div class="container-fluid">
        <ol class="breadcrumb mb-0 py-2">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/" class="text-decoration-none">
                    <i class="fas fa-home"></i> Accueil
                </a>
            </li>
            <c:if test="${not empty breadcrumbs}">
                <c:forEach var="breadcrumb" items="${breadcrumbs}" varStatus="status">
                    <c:choose>
                        <c:when test="${status.last}">
                            <li class="breadcrumb-item active" aria-current="page">
                                ${breadcrumb.label}
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="breadcrumb-item">
                                <a href="${breadcrumb.url}" class="text-decoration-none">
                                    ${breadcrumb.label}
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </c:if>
        </ol>
    </div>
</nav>

<style>
    .navbar-nav .dropdown-menu {
        border: none;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        border-radius: 8px;
    }
    
    .dropdown-item {
        padding: 8px 16px;
        border-radius: 4px;
        margin: 2px 8px;
        transition: all 0.2s ease;
    }
    
    .dropdown-item:hover {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        transform: translateX(4px);
    }
    
    .dropdown-item.disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }
    
    .nav-link.active {
        background: rgba(255,255,255,0.2);
        border-radius: 6px;
    }
    
    .breadcrumb-item + .breadcrumb-item::before {
        content: ">";
        font-weight: bold;
        color: #6c757d;
    }
</style>