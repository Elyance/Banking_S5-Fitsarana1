<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Template de base avec sidebar moderne -->
<!DOCTYPE html>
<html lang="fr" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'Banking System'}</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- CSS personnalisés -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    
    <!-- Chart.js pour les graphiques -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <!-- Sidebar -->
    <nav class="sidebar" id="sidebar">
        <!-- Header de la sidebar -->
        <div class="sidebar-header">
            <a href="${pageContext.request.contextPath}/" class="logo">
                <i class="fas fa-university"></i>
                <span class="logo-text">BankingApp</span>
            </a>
        </div>
        
        <!-- Navigation -->
        <div class="sidebar-nav">
            <!-- Tableau de bord -->
            <div class="nav-section">
                <div class="nav-section-title">Tableau de bord</div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/" 
                       class="nav-link ${pageContext.request.requestURI.endsWith('/') ? 'active' : ''}"
                       data-tooltip="Dashboard">
                        <i class="fas fa-tachometer-alt"></i>
                        <span class="nav-link-text">Dashboard</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/rapports" 
                       class="nav-link"
                       data-tooltip="Rapports">
                        <i class="fas fa-chart-line"></i>
                        <span class="nav-link-text">Rapports</span>
                    </a>
                </div>
            </div>
            
            <!-- Gestion des clients -->
            <div class="nav-section">
                <div class="nav-section-title">Clients</div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/clients/liste" 
                       class="nav-link ${pageContext.request.requestURI.contains('/clients/liste') ? 'active' : ''}"
                       data-tooltip="Liste des clients">
                        <i class="fas fa-users"></i>
                        <span class="nav-link-text">Tous les clients</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/clients/nouveau" 
                       class="nav-link ${pageContext.request.requestURI.contains('/clients/nouveau') ? 'active' : ''}"
                       data-tooltip="Nouveau client">
                        <i class="fas fa-user-plus"></i>
                        <span class="nav-link-text">Nouveau client</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/clients/recherche" 
                       class="nav-link"
                       data-tooltip="Rechercher">
                        <i class="fas fa-search"></i>
                        <span class="nav-link-text">Rechercher</span>
                    </a>
                </div>
            </div>
            
            <!-- Comptes Courants -->
            <div class="nav-section">
                <div class="nav-section-title">Comptes Courants</div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/compte-courant/liste" 
                       class="nav-link ${pageContext.request.requestURI.contains('/compte-courant/liste') ? 'active' : ''}"
                       data-tooltip="Liste des comptes">
                        <i class="fas fa-credit-card"></i>
                        <span class="nav-link-text">Tous les comptes</span>
                        <c:if test="${nombreComptesCourants != null && nombreComptesCourants > 0}">
                            <span class="nav-badge">${nombreComptesCourants}</span>
                        </c:if>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/compte-courant/creation" 
                       class="nav-link ${pageContext.request.requestURI.contains('/compte-courant/creation') ? 'active' : ''}"
                       data-tooltip="Nouveau compte">
                        <i class="fas fa-plus-circle"></i>
                        <span class="nav-link-text">Nouveau compte</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/transaction/nouvelle" 
                       class="nav-link ${pageContext.request.requestURI.contains('/transaction/nouvelle') ? 'active' : ''}"
                       data-tooltip="Nouvelle transaction">
                        <i class="fas fa-exchange-alt"></i>
                        <span class="nav-link-text">Transaction</span>
                    </a>
                </div>
            </div>
            
            <!-- Comptes de Prêt (à venir) -->
            <div class="nav-section">
                <div class="nav-section-title">Prêts <small class="text-warning">(Bientôt)</small></div>
                <div class="nav-item">
                    <a href="#" class="nav-link text-muted" style="opacity: 0.5; cursor: not-allowed;"
                       data-tooltip="Bientôt disponible">
                        <i class="fas fa-hand-holding-usd"></i>
                        <span class="nav-link-text">Mes prêts</span>
                        <span class="nav-badge bg-warning">0</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="#" class="nav-link text-muted" style="opacity: 0.5; cursor: not-allowed;"
                       data-tooltip="Bientôt disponible">
                        <i class="fas fa-calculator"></i>
                        <span class="nav-link-text">Simulateur</span>
                    </a>
                </div>
            </div>
            
            <!-- Comptes de Dépôt (à venir) -->
            <div class="nav-section">
                <div class="nav-section-title">Épargne <small class="text-warning">(Bientôt)</small></div>
                <div class="nav-item">
                    <a href="#" class="nav-link text-muted" style="opacity: 0.5; cursor: not-allowed;"
                       data-tooltip="Bientôt disponible">
                        <i class="fas fa-piggy-bank"></i>
                        <span class="nav-link-text">Mes épargnes</span>
                        <span class="nav-badge bg-warning">0</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="#" class="nav-link text-muted" style="opacity: 0.5; cursor: not-allowed;"
                       data-tooltip="Bientôt disponible">
                        <i class="fas fa-chart-pie"></i>
                        <span class="nav-link-text">Rendements</span>
                    </a>
                </div>
            </div>
            
            <!-- Outils -->
            <div class="nav-section">
                <div class="nav-section-title">Outils</div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/api-docs" 
                       class="nav-link"
                       data-tooltip="Documentation API">
                        <i class="fas fa-code"></i>
                        <span class="nav-link-text">API Docs</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="#" onclick="window.print(); return false;" 
                       class="nav-link"
                       data-tooltip="Imprimer">
                        <i class="fas fa-print"></i>
                        <span class="nav-link-text">Imprimer</span>
                    </a>
                </div>
            </div>
        </div>
    </nav>
    
    <!-- Contenu principal -->
    <div class="main-content" id="mainContent">
        <!-- Header du contenu -->
        <header class="content-header">
            <button class="sidebar-toggle" id="sidebarToggle">
                <i class="fas fa-bars"></i>
            </button>
            
            <h1 class="page-title">${pageTitle != null ? pageTitle : 'Dashboard'}</h1>
            
            <div class="header-actions">
                <button class="btn btn-outline-primary btn-sm">
                    <i class="fas fa-bell me-1"></i>
                    Notifications
                </button>
                <button class="btn btn-primary btn-sm">
                    <i class="fas fa-user me-1"></i>
                    Admin
                </button>
            </div>
        </header>
        
        <!-- Breadcrumbs -->
        <c:if test="${not empty breadcrumbs}">
            <div class="breadcrumb-container">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i></a>
                        </li>
                        <c:forEach var="breadcrumb" items="${breadcrumbs}" varStatus="status">
                            <c:choose>
                                <c:when test="${status.last}">
                                    <li class="breadcrumb-item active" aria-current="page">${breadcrumb.label}</li>
                                </c:when>
                                <c:otherwise>
                                    <li class="breadcrumb-item">
                                        <a href="${breadcrumb.url}">${breadcrumb.label}</a>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </ol>
                </nav>
            </div>
        </c:if>
        
        <!-- Corps du contenu -->
        <main class="content-body">
            <!-- Le contenu spécifique sera inséré ici -->
            
        </main>
    </div>
    
    <!-- Scripts -->
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Script pour la sidebar -->
    <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
    
    <!-- Scripts personnalisés -->
    <c:if test="${not empty customScripts}">
        <c:forEach var="script" items="${customScripts}">
            <script src="${script}"></script>
        </c:forEach>
    </c:if>
</body>
</html>