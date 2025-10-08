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
    
    <!-- Chart.js pour les graphiques -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- CSS complet intégré pour garantir le style -->
    <style type="text/css">
        /* ===== VARIABLES CSS COMPLÈTES ===== */
        :root {
            --primary-color: #2563eb;
            --primary-dark: #1d4ed8;
            --secondary-color: #64748b;
            --accent-color: #06d6a0;
            --warning-color: #fbbf24;
            --danger-color: #ef4444;
            --sidebar-width: 280px;
            --sidebar-collapsed-width: 80px;
            --header-height: 70px;
            --bg-primary: #f8fafc;
            --bg-white: #ffffff;
            --bg-light: #f1f5f9;
            --text-primary: #1e293b;
            --text-secondary: #64748b;
            --text-muted: #94a3b8;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.1);
            --shadow-md: 0 4px 12px rgba(0,0,0,0.1);
            --shadow-lg: 0 4px 20px rgba(0,0,0,0.1);
            --border-color: #e2e8f0;
            --border-light: #f1f5f9;
            --radius-sm: 6px;
            --radius-md: 12px;
            --radius-lg: 16px;
            --transition-fast: 0.2s ease;
            --transition-normal: 0.3s ease;
            --transition-slow: 0.5s ease;
        }

        /* ===== BASE STYLES ===== */
        * { box-sizing: border-box; }
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-primary);
            margin: 0;
            padding: 0;
            line-height: 1.6;
        }

        /* ===== SIDEBAR COMPLET ===== */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: var(--sidebar-width);
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            transition: all var(--transition-normal);
            z-index: 1000;
            box-shadow: var(--shadow-lg);
            overflow: hidden;
        }

        .sidebar.collapsed { width: var(--sidebar-collapsed-width); }

        .sidebar-header {
            height: var(--header-height);
            display: flex;
            align-items: center;
            padding: 0 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            background: rgba(255,255,255,0.05);
        }

        .sidebar-header .logo {
            font-size: 24px;
            font-weight: 700;
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all var(--transition-normal);
        }

        .sidebar-header .logo:hover {
            color: var(--accent-color);
            transform: scale(1.02);
        }

        .sidebar-header .logo i {
            font-size: 28px;
            color: var(--accent-color);
            transition: all var(--transition-normal);
        }

        .sidebar-header .logo-text {
            transition: opacity var(--transition-normal);
            white-space: nowrap;
            overflow: hidden;
        }

        .sidebar.collapsed .logo-text {
            opacity: 0;
            width: 0;
        }

        .sidebar-nav {
            padding: 20px 0;
            height: calc(100vh - var(--header-height));
            overflow-y: auto;
            overflow-x: hidden;
        }

        .nav-section {
            margin-bottom: 30px;
        }

        .nav-section-title {
            padding: 0 20px 10px;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            opacity: 0.7;
            font-weight: 600;
            transition: all var(--transition-normal);
            color: rgba(255,255,255,0.8);
        }

        .sidebar.collapsed .nav-section-title {
            opacity: 0;
            height: 0;
            padding: 0;
            margin: 0;
            overflow: hidden;
        }

        .nav-item {
            margin: 4px 12px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            border-radius: var(--radius-md);
            transition: all var(--transition-normal);
            font-weight: 500;
            position: relative;
            overflow: hidden;
        }

        .nav-link:hover {
            color: white;
            background: rgba(255,255,255,0.15);
            transform: translateX(4px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .nav-link.active {
            background: rgba(255,255,255,0.2);
            color: white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            font-weight: 600;
        }

        .nav-link.active::after {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            background: var(--accent-color);
            border-radius: 0 2px 2px 0;
        }

        .nav-link.text-muted {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }

        .nav-link i {
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            font-size: 18px;
            transition: all var(--transition-normal);
            flex-shrink: 0;
        }

        .nav-link:hover i {
            transform: scale(1.1);
        }

        .nav-link.active i {
            color: var(--accent-color);
        }

        .nav-link-text {
            flex: 1;
            transition: opacity var(--transition-normal);
            white-space: nowrap;
            overflow: hidden;
        }

        .sidebar.collapsed .nav-link-text {
            opacity: 0;
            width: 0;
        }

        .sidebar.collapsed .nav-link {
            justify-content: center;
            padding: 12px;
        }

        .sidebar.collapsed .nav-link i {
            margin-right: 0;
        }

        .nav-badge {
            background: var(--accent-color);
            color: white;
            font-size: 10px;
            padding: 3px 7px;
            border-radius: 12px;
            font-weight: 600;
            min-width: 20px;
            text-align: center;
            transition: all var(--transition-normal);
            margin-left: auto;
        }

        .nav-badge.bg-warning {
            background: var(--warning-color);
            color: #000;
        }

        .sidebar.collapsed .nav-badge {
            position: absolute;
            top: 8px;
            right: 8px;
            font-size: 8px;
            padding: 2px 5px;
            min-width: 16px;
        }

        /* ===== LAYOUT PRINCIPAL ===== */
        .main-content {
            margin-left: var(--sidebar-width);
            min-height: 100vh;
            transition: margin-left var(--transition-normal);
            display: flex;
            flex-direction: column;
        }

        .main-content.expanded {
            margin-left: var(--sidebar-collapsed-width);
        }

        .content-header {
            height: var(--header-height);
            background: var(--bg-white);
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            padding: 0 30px;
            box-shadow: var(--shadow-sm);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .sidebar-toggle {
            background: none;
            border: none;
            font-size: 20px;
            color: var(--text-secondary);
            cursor: pointer;
            padding: 10px;
            border-radius: var(--radius-sm);
            transition: all var(--transition-fast);
            margin-right: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
        }

        .sidebar-toggle:hover {
            background: var(--bg-light);
            color: var(--primary-color);
            transform: scale(1.05);
        }

        .page-title {
            font-size: 24px;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
            flex: 1;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .breadcrumb-container {
            padding: 20px 30px;
            background: var(--bg-white);
            border-bottom: 1px solid var(--border-light);
        }

        .breadcrumb {
            background: none;
            padding: 0;
            margin: 0;
            font-size: 14px;
        }

        .breadcrumb-item a {
            color: var(--text-secondary);
            text-decoration: none;
            transition: color var(--transition-fast);
        }

        .breadcrumb-item a:hover {
            color: var(--primary-color);
        }

        .breadcrumb-item.active {
            color: var(--primary-color);
            font-weight: 500;
        }

        .content-body {
            padding: 30px;
            flex: 1;
            background: var(--bg-primary);
        }

        /* ===== COMPOSANTS ===== */
        .card {
            background: var(--bg-white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-light);
            transition: all var(--transition-normal);
            overflow: hidden;
        }

        .card:hover {
            box-shadow: var(--shadow-lg);
            transform: translateY(-2px);
        }

        .btn {
            border-radius: var(--radius-sm);
            font-weight: 500;
            transition: all var(--transition-fast);
            border: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }

        .btn-outline-primary {
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
            background: transparent;
        }

        .btn-outline-primary:hover {
            background: var(--primary-color);
            color: white;
        }

        /* ===== STYLES SPÉCIFIQUES AU DASHBOARD ===== */
        
        /* Page Header du Dashboard */
        .page-header {
            background: linear-gradient(135deg, var(--bg-white) 0%, var(--bg-light) 100%);
            border-radius: var(--radius-lg);
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-light);
            position: relative;
            overflow: hidden;
        }
        
        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
        }
        
        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
        }
        
        .page-subtitle {
            color: var(--text-secondary);
            font-size: 1.1rem;
            margin: 0;
            font-weight: 400;
        }
        
        .page-actions {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: var(--bg-white);
            border-radius: var(--radius-lg);
            padding: 1.75rem;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-light);
            transition: all var(--transition-normal);
            display: flex;
            align-items: flex-start;
            gap: 1.25rem;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
            opacity: 0;
            transition: opacity var(--transition-normal);
        }

        .stat-card:hover {
            box-shadow: var(--shadow-lg);
            transform: translateY(-8px);
            border-color: var(--primary-color);
        }

        .stat-card:hover::before {
            opacity: 1;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            flex-shrink: 0;
            transition: all var(--transition-normal);
            position: relative;
        }

        .stat-card:hover .stat-icon {
            transform: scale(1.15) rotate(5deg);
        }

        .stat-icon.primary {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.15), rgba(37, 99, 235, 0.25));
            color: var(--primary-color);
            border: 2px solid rgba(37, 99, 235, 0.2);
        }

        .stat-icon.success {
            background: linear-gradient(135deg, rgba(6, 214, 160, 0.15), rgba(6, 214, 160, 0.25));
            color: var(--accent-color);
            border: 2px solid rgba(6, 214, 160, 0.2);
        }

        .stat-icon.warning {
            background: linear-gradient(135deg, rgba(251, 191, 36, 0.15), rgba(251, 191, 36, 0.25));
            color: var(--warning-color);
            border: 2px solid rgba(251, 191, 36, 0.2);
        }

        .stat-icon.danger {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.15), rgba(239, 68, 68, 0.25));
            color: var(--danger-color);
            border: 2px solid rgba(239, 68, 68, 0.2);
        }

        .stat-content {
            flex: 1;
        }

        .stat-value {
            font-size: 2.25rem;
            font-weight: 800;
            color: var(--text-primary);
            line-height: 1;
            margin-bottom: 0.5rem;
            font-family: 'Inter', monospace;
        }

        .stat-label {
            font-size: 0.95rem;
            color: var(--text-secondary);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Card Enhancements */
        .card-header {
            background: linear-gradient(135deg, var(--bg-light), var(--bg-white));
            border-bottom: 2px solid var(--border-color);
            padding: 1.5rem;
            border-radius: var(--radius-lg) var(--radius-lg) 0 0;
        }

        .card-title {
            margin: 0;
            font-weight: 700;
            color: var(--text-primary);
            font-size: 1.15rem;
            display: flex;
            align-items: center;
        }

        .card-body {
            padding: 1.5rem;
        }

        /* Avatar Circle */
        .avatar-circle {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 0.9rem;
            text-transform: uppercase;
            flex-shrink: 0;
            border: 3px solid rgba(255,255,255,0.2);
            transition: all var(--transition-normal);
        }

        .avatar-circle:hover {
            transform: scale(1.1);
            box-shadow: 0 8px 25px rgba(37, 99, 235, 0.3);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem 1.5rem;
            background: linear-gradient(135deg, var(--bg-white), var(--bg-light));
            border-radius: var(--radius-lg);
            border: 2px dashed var(--border-color);
            margin: 1rem 0;
        }

        .empty-state i {
            font-size: 3.5rem;
            color: var(--text-muted);
            margin-bottom: 1.5rem;
            opacity: 0.7;
        }

        .empty-state h3 {
            color: var(--text-secondary);
            margin-bottom: 1rem;
            font-weight: 600;
            font-size: 1.3rem;
        }

        .empty-state p {
            color: var(--text-muted);
            max-width: 400px;
            margin: 0 auto;
            line-height: 1.6;
            font-size: 0.95rem;
        }

        /* Badges */
        .badge {
            border-radius: var(--radius-sm);
            font-weight: 600;
            font-size: 0.75rem;
            padding: 0.5rem 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: 2px solid transparent;
        }

        .bg-success {
            background: var(--accent-color) !important;
            border-color: var(--accent-color) !important;
        }

        .bg-danger {
            background: var(--danger-color) !important;
            border-color: var(--danger-color) !important;
        }

        .bg-warning {
            background: var(--warning-color) !important;
            color: #000 !important;
            border-color: var(--warning-color) !important;
        }

        /* Progress Bars */
        .progress {
            height: 8px;
            border-radius: var(--radius-sm);
            background: var(--bg-light);
            box-shadow: inset 0 1px 2px rgba(0,0,0,0.1);
        }

        .progress-bar {
            border-radius: var(--radius-sm);
            transition: width 0.6s ease;
        }

        .progress-bar.bg-warning {
            background: linear-gradient(90deg, var(--warning-color), #f59e0b) !important;
        }

        .progress-bar.bg-success {
            background: linear-gradient(90deg, var(--accent-color), #059669) !important;
        }

        /* Module Cards (Prêts et Dépôts) */
        .card.border-warning {
            border-color: var(--warning-color) !important;
            background: linear-gradient(135deg, rgba(251, 191, 36, 0.03), var(--bg-white));
            transition: all var(--transition-normal);
        }

        .card.border-warning:hover {
            box-shadow: 0 8px 25px rgba(251, 191, 36, 0.15);
            transform: translateY(-5px);
        }

        .card.border-success {
            border-color: var(--accent-color) !important;
            background: linear-gradient(135deg, rgba(6, 214, 160, 0.03), var(--bg-white));
            transition: all var(--transition-normal);
        }

        .card.border-success:hover {
            box-shadow: 0 8px 25px rgba(6, 214, 160, 0.15);
            transform: translateY(-5px);
        }

        /* Actions Rapides */
        .btn.w-100.h-100 {
            min-height: 120px;
            border: 2px solid;
            border-radius: var(--radius-lg);
            transition: all var(--transition-normal);
            position: relative;
            overflow: hidden;
        }

        .btn.w-100.h-100::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.6s;
        }

        .btn.w-100.h-100:hover::before {
            left: 100%;
        }

        .btn.w-100.h-100:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 12px 30px rgba(0,0,0,0.15);
        }

        .btn-outline-success {
            border-color: var(--accent-color);
            color: var(--accent-color);
        }

        .btn-outline-success:hover {
            background: var(--accent-color);
            border-color: var(--accent-color);
        }

        .btn-outline-warning {
            border-color: var(--warning-color);
            color: var(--warning-color);
        }

        .btn-outline-warning:hover {
            background: var(--warning-color);
            border-color: var(--warning-color);
            color: #000;
        }

        .btn-outline-info {
            border-color: var(--primary-color);
            color: var(--primary-color);
        }

        .btn-outline-info:hover {
            background: var(--primary-color);
            border-color: var(--primary-color);
        }

        /* Animation pour le tableau de bord */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .stats-grid .stat-card {
            animation: fadeInUp 0.6s ease;
            animation-fill-mode: both;
        }

        .stats-grid .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stats-grid .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stats-grid .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .stats-grid .stat-card:nth-child(4) { animation-delay: 0.4s; }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                transition: transform var(--transition-normal);
            }
            
            .sidebar.show {
                transform: translateX(0);
            }
            
            .main-content {
                margin-left: 0;
            }
            
            .content-header {
                padding: 0 15px;
            }
            
            .content-body {
                padding: 15px;
            }
            
            .page-title {
                font-size: 20px;
            }
            
            .stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1rem;
            }
            
            .stat-card {
                padding: 1.25rem;
            }
            
            .stat-value {
                font-size: 1.8rem;
            }
            
            .page-header {
                padding: 1.5rem;
            }
            
            .page-title {
                font-size: 2rem;
            }
            
            .page-header .d-flex {
                flex-direction: column;
                align-items: stretch !important;
            }
            
            .page-actions {
                margin-top: 1.5rem;
                justify-content: center;
            }
            
            .stat-icon {
                width: 50px;
                height: 50px;
                font-size: 24px;
            }
            
            .btn.w-100.h-100 {
                min-height: 100px;
            }
        }

        @media (max-width: 992px) {
            .stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1rem;
            }
        }
    </style>
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
                    <a href="${pageContext.request.contextPath}/clients/list" 
                       class="nav-link ${pageContext.request.requestURI.contains('/clients/list') ? 'active' : ''}"
                       data-tooltip="Liste des clients">
                        <i class="fas fa-users"></i>
                        <span class="nav-link-text">Tous les clients</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/clients/register" 
                       class="nav-link ${pageContext.request.requestURI.contains('/clients/register') ? 'active' : ''}"
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
                    <a href="${pageContext.request.contextPath}/compte-courant/creer" 
                       class="nav-link ${pageContext.request.requestURI.contains('/compte-courant/creer') ? 'active' : ''}"
                       data-tooltip="Nouveau compte">
                        <i class="fas fa-plus-circle"></i>
                        <span class="nav-link-text">Nouveau compte</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/compte-courant/transaction" 
                       class="nav-link ${pageContext.request.requestURI.contains('/compte-courant/transaction') ? 'active' : ''}"
                       data-tooltip="Nouvelle transaction">
                        <i class="fas fa-exchange-alt"></i>
                        <span class="nav-link-text">Transaction</span>
                    </a>
                </div>
            </div>

            <!-- Comptes Prêt -->
            <div class="nav-section">
                <div class="nav-section-title">Comptes Prêt</div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/compte-pret/liste" 
                       class="nav-link ${pageContext.request.requestURI.contains('/compte-pret/liste') ? 'active' : ''}"
                       data-tooltip="Liste des prêts">
                        <i class="fas fa-hand-holding-usd"></i>
                        <span class="nav-link-text">Tous les prêts</span>
                        <c:if test="${nombreComptesPret != null && nombreComptesPret > 0}">
                            <span class="nav-badge">${nombreComptesPret}</span>
                        </c:if>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/compte-pret/creer" 
                       class="nav-link ${pageContext.request.requestURI.contains('/compte-pret/creer') ? 'active' : ''}"
                       data-tooltip="Nouveau prêt">
                        <i class="fas fa-plus-circle"></i>
                        <span class="nav-link-text">Nouveau prêt</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/compte-pret/transaction" 
                       class="nav-link ${pageContext.request.requestURI.contains('/compte-pret/transaction') ? 'active' : ''}"
                       data-tooltip="Nouvelle transaction">
                        <i class="fas fa-exchange-alt"></i>
                        <span class="nav-link-text">Transaction</span>
                    </a>
                </div>
            </div>

                       data-tooltip="Liste des comptes">
                        <i class="fas fa-credit-card"></i>
                        <span class="nav-link-text">Tous les comptes</span>
                        <c:if test="${nombreComptesCourants != null && nombreComptesCourants > 0}">
                            <span class="nav-badge">${nombreComptesCourants}</span>
                        </c:if>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/compte-courant/creer" 
                       class="nav-link ${pageContext.request.requestURI.contains('/compte-courant/creer') ? 'active' : ''}"
                       data-tooltip="Nouveau compte">
                        <i class="fas fa-plus-circle"></i>
                        <span class="nav-link-text">Nouveau compte</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/compte-courant/transaction" 
                       class="nav-link ${pageContext.request.requestURI.contains('/compte-courant/transaction') ? 'active' : ''}"
                       data-tooltip="Nouvelle transaction">
                        <i class="fas fa-exchange-alt"></i>
                        <span class="nav-link-text">Transaction</span>
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
            <jsp:include page="${contentPage}" />
        </main>
    </div>
    
    <!-- Scripts -->
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Script pour la sidebar -->
    <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
    
    <!-- Script de base intégré pour garantir le fonctionnement -->
    <script type="text/javascript">
        // Fonction de base pour le toggle de la sidebar
        function initBasicSidebar() {
            const sidebarToggle = document.getElementById('sidebarToggle');
            const sidebar = document.getElementById('sidebar');
            const mainContent = document.getElementById('mainContent');
            
            if (sidebarToggle && sidebar && mainContent) {
                sidebarToggle.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    const isMobile = window.innerWidth <= 768;
                    
                    if (isMobile) {
                        // Mobile: show/hide sidebar
                        if (sidebar.classList.contains('show')) {
                            sidebar.classList.remove('show');
                            sidebar.style.transform = 'translateX(-100%)';
                        } else {
                            sidebar.classList.add('show');
                            sidebar.style.transform = 'translateX(0)';
                        }
                    } else {
                        // Desktop: collapse/expand
                        sidebar.classList.toggle('collapsed');
                        mainContent.classList.toggle('expanded');
                    }
                });
            }
        }
        
        // Initialiser dès que le DOM est prêt
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initBasicSidebar);
        } else {
            initBasicSidebar();
        }
    </script>
    
    <!-- Scripts personnalisés -->
    <c:if test="${not empty customScripts}">
        <c:forEach var="script" items="${customScripts}">
            <script src="${script}"></script>
        </c:forEach>
    </c:if>
</body>
</html>