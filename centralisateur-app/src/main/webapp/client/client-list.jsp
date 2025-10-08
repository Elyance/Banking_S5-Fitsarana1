<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.centralisateur.entity.Client" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Liste des Clients" scope="request"/>

<!DOCTYPE html>
<html lang="fr" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Clients - Banking System</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- CSS du layout inclus -->
    <style type="text/css">
        /* Variables CSS du layout */
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

        * { box-sizing: border-box; }
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-primary);
            margin: 0;
            padding: 0;
            line-height: 1.6;
        }

        /* Layout de base sans sidebar pour cette page */
        .container-fluid {
            padding: 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        /* Header de navigation simple */
        .nav-header {
            background: var(--bg-white);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-light);
            display: flex;
            justify-content: between;
            align-items: center;
        }

        .nav-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .nav-actions {
            display: flex;
            gap: 1rem;
        }

        /* Styles pour la page client-list */
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

        .client-stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .client-stat-card {
            background: var(--bg-white);
            border-radius: var(--radius-md);
            padding: 1.25rem;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-light);
            transition: all var(--transition-normal);
            text-align: center;
        }

        .client-stat-card:hover {
            box-shadow: var(--shadow-md);
            transform: translateY(-2px);
        }

        .client-stat-number {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.25rem;
        }

        .client-stat-label {
            color: var(--text-secondary);
            font-size: 0.875rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .filters-card {
            background: var(--bg-white);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-light);
            margin-bottom: 2rem;
            border-left: 4px solid var(--primary-color);
        }

        .filters-title {
            color: var(--text-primary);
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .filter-form {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr auto auto;
            gap: 1rem;
            align-items: end;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
        }

        .filter-group label {
            margin-bottom: 0.5rem;
            color: var(--text-secondary);
            font-weight: 500;
            font-size: 0.875rem;
        }

        .filter-group input {
            padding: 0.75rem;
            border: 2px solid var(--border-color);
            border-radius: var(--radius-sm);
            font-size: 0.875rem;
            transition: border-color var(--transition-fast);
            background: var(--bg-white);
        }

        .filter-group input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .table-card {
            background: var(--bg-white);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-light);
        }

        .table-responsive {
            border-radius: var(--radius-lg);
            overflow: hidden;
        }

        .clients-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }

        .clients-table th {
            background: var(--bg-light);
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: var(--text-primary);
            border-bottom: 2px solid var(--border-color);
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .clients-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border-light);
            vertical-align: middle;
            color: var(--text-primary);
        }

        .clients-table tbody tr {
            transition: background-color var(--transition-fast);
        }

        .clients-table tbody tr:hover {
            background: var(--bg-light);
        }

        .client-numero {
            font-family: 'Inter', monospace;
            font-weight: 600;
            color: var(--primary-color);
            font-size: 0.875rem;
        }

        .client-name {
            font-weight: 600;
            color: var(--text-primary);
        }

        .client-profession {
            color: var(--text-secondary);
            font-size: 0.8rem;
            margin-top: 0.25rem;
        }

        .client-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .client-badge.active {
            background: rgba(6, 214, 160, 0.1);
            color: var(--accent-color);
            border: 1px solid rgba(6, 214, 160, 0.2);
        }

        .client-badge.inactive {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger-color);
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
            justify-content: center;
        }

        .btn {
            border-radius: var(--radius-sm);
            font-weight: 500;
            transition: all var(--transition-fast);
            border: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-action {
            padding: 0.5rem 0.75rem;
            font-size: 0.75rem;
            border: 1px solid transparent;
        }

        .btn-action.btn-info {
            background: rgba(37, 99, 235, 0.1);
            color: var(--primary-color);
            border-color: rgba(37, 99, 235, 0.2);
        }

        .btn-action.btn-info:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-1px);
        }

        .btn-action.btn-edit {
            background: rgba(6, 214, 160, 0.1);
            color: var(--accent-color);
            border-color: rgba(6, 214, 160, 0.2);
        }

        .btn-action.btn-edit:hover {
            background: var(--accent-color);
            color: white;
            transform: translateY(-1px);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            padding: 0.75rem 1rem;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
            color: white;
        }

        .btn-outline-secondary {
            border: 2px solid var(--border-color);
            color: var(--text-secondary);
            background: transparent;
            padding: 0.75rem 1rem;
        }

        .btn-outline-secondary:hover {
            background: var(--bg-light);
            border-color: var(--primary-color);
            color: var(--primary-color);
        }

        .btn-success {
            background: linear-gradient(135deg, var(--accent-color), #059669);
            color: white;
            padding: 0.75rem 1.5rem;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(6, 214, 160, 0.3);
            color: white;
        }

        .empty-state-card {
            background: var(--bg-white);
            border-radius: var(--radius-lg);
            padding: 3rem;
            text-align: center;
            border: 2px dashed var(--border-color);
            margin: 2rem 0;
        }

        .empty-state-icon {
            font-size: 3rem;
            color: var(--text-muted);
            margin-bottom: 1.5rem;
            opacity: 0.7;
        }

        .empty-state-title {
            color: var(--text-secondary);
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .empty-state-text {
            color: var(--text-muted);
            margin-bottom: 0;
            line-height: 1.6;
        }

        .final-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
        }

        .alert {
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: var(--radius-sm);
            border: 1px solid transparent;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger-color);
            border-color: rgba(239, 68, 68, 0.2);
        }

        /* Responsive */
        @media (max-width: 992px) {
            .filter-form {
                grid-template-columns: 1fr 1fr;
                gap: 1rem;
            }
            
            .filter-form .btn {
                grid-column: span 2;
            }
            
            .client-stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .container-fluid {
                padding: 1rem;
            }

            .filter-form {
                grid-template-columns: 1fr;
            }
            
            .filter-form .btn {
                grid-column: span 1;
            }
            
            .client-stats-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .final-actions {
                flex-direction: column;
            }
            
            .page-header .d-flex {
                flex-direction: column;
                align-items: stretch !important;
            }
            
            .page-actions {
                margin-top: 1.5rem;
                justify-content: center;
            }
            
            .clients-table {
                font-size: 0.8rem;
            }
            
            .clients-table th,
            .clients-table td {
                padding: 0.75rem 0.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <!-- Navigation simple -->
        <div class="nav-header">
            <h1 class="nav-title">
                <i class="fas fa-university text-primary"></i>
                Banking System
            </h1>
            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">
                    <i class="fas fa-home"></i>
                    Accueil
                </a>
            </div>
        </div>
<style>
    /* Styles pour la page client-list qui complètent le layout */
    .client-stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1rem;
        margin-bottom: 2rem;
    }

    .client-stat-card {
        background: var(--bg-white);
        border-radius: var(--radius-md);
        padding: 1.25rem;
        box-shadow: var(--shadow-sm);
        border: 1px solid var(--border-light);
        transition: all var(--transition-normal);
        text-align: center;
    }

    .client-stat-card:hover {
        box-shadow: var(--shadow-md);
        transform: translateY(-2px);
    }

    .client-stat-number {
        font-size: 1.75rem;
        font-weight: 700;
        color: var(--primary-color);
        margin-bottom: 0.25rem;
    }

    .client-stat-label {
        color: var(--text-secondary);
        font-size: 0.875rem;
        font-weight: 500;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .filters-card {
        background: var(--bg-white);
        border-radius: var(--radius-lg);
        padding: 1.5rem;
        box-shadow: var(--shadow-sm);
        border: 1px solid var(--border-light);
        margin-bottom: 2rem;
        border-left: 4px solid var(--primary-color);
    }

    .filters-title {
        color: var(--text-primary);
        font-size: 1.1rem;
        font-weight: 600;
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .filter-form {
        display: grid;
        grid-template-columns: 1fr 1fr 1fr auto auto;
        gap: 1rem;
        align-items: end;
    }

    .filter-group {
        display: flex;
        flex-direction: column;
    }

    .filter-group label {
        margin-bottom: 0.5rem;
        color: var(--text-secondary);
        font-weight: 500;
        font-size: 0.875rem;
    }

    .filter-group input {
        padding: 0.75rem;
        border: 2px solid var(--border-color);
        border-radius: var(--radius-sm);
        font-size: 0.875rem;
        transition: border-color var(--transition-fast);
        background: var(--bg-white);
    }

    .filter-group input:focus {
        outline: none;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    }

    .table-card {
        background: var(--bg-white);
        border-radius: var(--radius-lg);
        overflow: hidden;
        box-shadow: var(--shadow-sm);
        border: 1px solid var(--border-light);
    }

    .table-responsive {
        border-radius: var(--radius-lg);
        overflow: hidden;
    }

    .clients-table {
        width: 100%;
        border-collapse: collapse;
        margin: 0;
    }

    .clients-table th {
        background: var(--bg-light);
        padding: 1rem;
        text-align: left;
        font-weight: 600;
        color: var(--text-primary);
        border-bottom: 2px solid var(--border-color);
        font-size: 0.875rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .clients-table td {
        padding: 1rem;
        border-bottom: 1px solid var(--border-light);
        vertical-align: middle;
        color: var(--text-primary);
    }

    .clients-table tbody tr {
        transition: background-color var(--transition-fast);
    }

    .clients-table tbody tr:hover {
        background: var(--bg-light);
    }

    .clients-table tbody tr:nth-child(even) {
        background: rgba(248, 250, 252, 0.5);
    }

    .clients-table tbody tr:nth-child(even):hover {
        background: var(--bg-light);
    }

    .client-numero {
        font-family: 'Inter', monospace;
        font-weight: 600;
        color: var(--primary-color);
        font-size: 0.875rem;
    }

    .client-name {
        font-weight: 600;
        color: var(--text-primary);
    }

    .client-profession {
        color: var(--text-secondary);
        font-size: 0.8rem;
        margin-top: 0.25rem;
    }

    .client-badge {
        display: inline-block;
        padding: 0.25rem 0.75rem;
        border-radius: var(--radius-sm);
        font-size: 0.75rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .client-badge.active {
        background: rgba(6, 214, 160, 0.1);
        color: var(--accent-color);
        border: 1px solid rgba(6, 214, 160, 0.2);
    }

    .client-badge.inactive {
        background: rgba(239, 68, 68, 0.1);
        color: var(--danger-color);
        border: 1px solid rgba(239, 68, 68, 0.2);
    }

    .action-buttons {
        display: flex;
        gap: 0.5rem;
        justify-content: center;
    }

    .btn-action {
        padding: 0.5rem 0.75rem;
        border-radius: var(--radius-sm);
        font-size: 0.75rem;
        font-weight: 500;
        text-decoration: none;
        transition: all var(--transition-fast);
        border: 1px solid transparent;
    }

    .btn-action.btn-info {
        background: rgba(37, 99, 235, 0.1);
        color: var(--primary-color);
        border-color: rgba(37, 99, 235, 0.2);
    }

    .btn-action.btn-info:hover {
        background: var(--primary-color);
        color: white;
        transform: translateY(-1px);
    }

    .btn-action.btn-edit {
        background: rgba(6, 214, 160, 0.1);
        color: var(--accent-color);
        border-color: rgba(6, 214, 160, 0.2);
    }

    .btn-action.btn-edit:hover {
        background: var(--accent-color);
        color: white;
        transform: translateY(-1px);
    }

    .empty-state-card {
        background: var(--bg-white);
        border-radius: var(--radius-lg);
        padding: 3rem;
        text-align: center;
        border: 2px dashed var(--border-color);
        margin: 2rem 0;
    }

    .empty-state-icon {
        font-size: 3rem;
        color: var(--text-muted);
        margin-bottom: 1.5rem;
        opacity: 0.7;
    }

    .empty-state-title {
        color: var(--text-secondary);
        font-size: 1.25rem;
        font-weight: 600;
        margin-bottom: 1rem;
    }

    .empty-state-text {
        color: var(--text-muted);
        margin-bottom: 0;
        line-height: 1.6;
    }

    .page-actions {
        display: flex;
        gap: 1rem;
        justify-content: center;
        margin-top: 2rem;
    }

    .btn-new-client {
        background: linear-gradient(135deg, var(--accent-color), #059669);
        color: white;
        padding: 0.75rem 1.5rem;
        border-radius: var(--radius-sm);
        text-decoration: none;
        font-weight: 600;
        transition: all var(--transition-normal);
        border: none;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .btn-new-client:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(6, 214, 160, 0.3);
        color: white;
    }

    .btn-back {
        background: var(--bg-white);
        color: var(--text-secondary);
        padding: 0.75rem 1.5rem;
        border-radius: var(--radius-sm);
        text-decoration: none;
        font-weight: 500;
        transition: all var(--transition-normal);
        border: 2px solid var(--border-color);
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .btn-back:hover {
        background: var(--bg-light);
        border-color: var(--primary-color);
        color: var(--primary-color);
        transform: translateY(-1px);
    }

    /* Responsive */
    @media (max-width: 992px) {
        .filter-form {
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        
        .filter-form .btn {
            grid-column: span 2;
        }
        
        .client-stats-grid {
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
        }
    }

    @media (max-width: 768px) {
        .filter-form {
            grid-template-columns: 1fr;
        }
        
        .filter-form .btn {
            grid-column: span 1;
        }
        
        .client-stats-grid {
            grid-template-columns: 1fr;
        }
        
        .action-buttons {
            flex-direction: column;
        }
        
        .page-actions {
            flex-direction: column;
        }
        
        .clients-table {
            font-size: 0.8rem;
        }
        
        .clients-table th,
        .clients-table td {
            padding: 0.75rem 0.5rem;
        }
    }
</style>

        <!-- Contenu principal -->
        <!-- Page Header -->
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">
                        <i class="fas fa-users text-primary me-3"></i>
                        Liste des Clients
                    </h1>
                    <p class="page-subtitle">Gestion et consultation des clients de la banque</p>
                </div>
                <div class="page-actions">
                    <a href="${pageContext.request.contextPath}/clients/register" class="btn btn-success">
                        <i class="fas fa-user-plus"></i>
                        Nouveau Client
                    </a>
                </div>
            </div>
        </div>

        <!-- Statistiques -->
        <div class="client-stats-grid">
            <div class="client-stat-card">
                <div class="client-stat-number"><%= request.getAttribute("totalClients") != null ? request.getAttribute("totalClients") : 0 %></div>
                <div class="client-stat-label">Clients Total</div>
            </div>
            <div class="client-stat-card">
                <div class="client-stat-number"><%= request.getAttribute("clients") != null ? ((List<Client>) request.getAttribute("clients")).size() : 0 %></div>
                <div class="client-stat-label">Affichés</div>
            </div>
            <div class="client-stat-card">
                <div class="client-stat-number">
                    <% if (Boolean.TRUE.equals(request.getAttribute("filtreApplique"))) { %>
                        <span class="client-badge active">Filtre Actif</span>
                    <% } else { %>
                        <span class="client-badge inactive">Tous</span>
                    <% } %>
                </div>
                <div class="client-stat-label">Statut Filtre</div>
            </div>
        </div>

        <!-- Filtres de recherche -->
        <div class="filters-card">
            <h3 class="filters-title">
                <i class="fas fa-search"></i>
                Filtres de recherche
            </h3>
            <form class="filter-form" method="post" action="${pageContext.request.contextPath}/clients/list">
                <div class="filter-group">
                    <label for="nomFiltre">Recherche par nom :</label>
                    <input type="text" id="nomFiltre" name="nomFiltre" 
                           value="<%= request.getAttribute("nomFiltre") != null ? request.getAttribute("nomFiltre") : "" %>"
                           placeholder="Tapez le nom du client...">
                </div>
                
                <div class="filter-group">
                    <label for="emailFiltre">Recherche par email :</label>
                    <input type="email" id="emailFiltre" name="emailFiltre" 
                           value="<%= request.getAttribute("emailFiltre") != null ? request.getAttribute("emailFiltre") : "" %>"
                           placeholder="email@exemple.com">
                </div>

                <div class="filter-group">
                    <label for="numeroClientFiltre">Recherche par N° client :</label>
                    <input type="text" id="numeroClientFiltre" name="numeroClientFiltre" 
                           value="<%= request.getAttribute("numeroClientFiltre") != null ? request.getAttribute("numeroClientFiltre") : "" %>"
                           placeholder="CLI-20251003-00001">
                </div>
                
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-filter"></i>
                    Filtrer
                </button>
                <a href="${pageContext.request.contextPath}/clients/list" class="btn btn-outline-secondary">
                    <i class="fas fa-undo"></i>
                    Réinitialiser
                </a>
            </form>
        </div>

        <!-- Messages d'erreur ou d'information -->
        <% 
        String error = (String) request.getAttribute("error");
        if (error != null) { 
        %>
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle"></i>
                <%= error %>
            </div>
        <% } %>

        <!-- Tableau des clients -->
        <div class="table-card">
            <%
            List<Client> clients = (List<Client>) request.getAttribute("clients");
            if (clients != null && !clients.isEmpty()) {
            %>
                <div class="table-responsive">
                    <table class="clients-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>N° Client</th>
                                <th>Nom Complet</th>
                                <th>Email</th>
                                <th>Téléphone</th>
                                <th>Date de Création</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                            for (Client client : clients) {
                            %>
                                <tr>
                                    <td><strong>#<%= client.getId() %></strong></td>
                                    <td>
                                        <% if (client.getNumeroClient() != null) { %>
                                            <span class="client-numero"><%= client.getNumeroClient() %></span>
                                        <% } else { %>
                                            <span class="text-muted font-italic">Non assigné</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <div class="client-name"><%= client.getPrenom() %> <%= client.getNom() %></div>
                                        <% if (client.getProfession() != null && !client.getProfession().isEmpty()) { %>
                                            <div class="client-profession"><%= client.getProfession() %></div>
                                        <% } %>
                                    </td>
                                    <td><%= client.getEmail() %></td>
                                    <td><%= client.getTelephone() %></td>
                                    <td>
                                        <%= dateFormat.format(java.sql.Timestamp.valueOf(client.getDateCreation())) %>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/clients/details?id=<%= client.getId() %>" 
                                               class="btn-action btn-info">
                                                <i class="fas fa-eye"></i>
                                                Détails
                                            </a>
                                            <a href="${pageContext.request.contextPath}/clients/edit?id=<%= client.getId() %>" 
                                               class="btn-action btn-edit">
                                                <i class="fas fa-edit"></i>
                                                Modifier
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="empty-state-card">
                    <div class="empty-state-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3 class="empty-state-title">Aucun client trouvé</h3>
                    <p class="empty-state-text">
                        <% if (Boolean.TRUE.equals(request.getAttribute("filtreApplique"))) { %>
                            Aucun client ne correspond aux critères de recherche.
                            <br>Essayez de modifier vos filtres ou de les réinitialiser.
                        <% } else { %>
                            Il n'y a encore aucun client enregistré dans le système.
                            <br>Commencez par créer votre premier client !
                        <% } %>
                    </p>
                </div>
            <% } %>
        </div>

        <div class="final-actions">
            <a href="${pageContext.request.contextPath}/clients/register" class="btn btn-success">
                <i class="fas fa-user-plus"></i>
                Nouveau Client
            </a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">
                <i class="fas fa-home"></i>
                Retour à l'accueil
            </a>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<!-- Filtres de recherche -->
<div class="filters-card">
    <h3 class="filters-title">
        <i class="fas fa-search"></i>
        Filtres de recherche
    </h3>
    <form class="filter-form" method="post" action="${pageContext.request.contextPath}/clients/list">
        <div class="filter-group">
            <label for="nomFiltre">Recherche par nom :</label>
            <input type="text" id="nomFiltre" name="nomFiltre" 
                   value="<%= request.getAttribute("nomFiltre") != null ? request.getAttribute("nomFiltre") : "" %>"
                   placeholder="Tapez le nom du client...">
        </div>
        
        <div class="filter-group">
            <label for="emailFiltre">Recherche par email :</label>
            <input type="email" id="emailFiltre" name="emailFiltre" 
                   value="<%= request.getAttribute("emailFiltre") != null ? request.getAttribute("emailFiltre") : "" %>"
                   placeholder="email@exemple.com">
        </div>

        <div class="filter-group">
            <label for="numeroClientFiltre">Recherche par N° client :</label>
            <input type="text" id="numeroClientFiltre" name="numeroClientFiltre" 
                   value="<%= request.getAttribute("numeroClientFiltre") != null ? request.getAttribute("numeroClientFiltre") : "" %>"
                   placeholder="CLI-20251003-00001">
        </div>
        
        <button type="submit" class="btn btn-primary">
            <i class="fas fa-filter me-1"></i>
            Filtrer
        </button>
        <a href="${pageContext.request.contextPath}/clients/list" class="btn btn-outline-secondary">
            <i class="fas fa-undo me-1"></i>
            Réinitialiser
        </a>
    </form>
</div>

<!-- Messages d'erreur ou d'information -->
<% 
String error = (String) request.getAttribute("error");
if (error != null) { 
%>
    <div class="alert alert-danger" role="alert">
        <i class="fas fa-exclamation-triangle me-2"></i>
        <%= error %>
    </div>
<% } %>

<!-- Tableau des clients -->
<div class="table-card">
    <%
    List<Client> clients = (List<Client>) request.getAttribute("clients");
    if (clients != null && !clients.isEmpty()) {
    %>
        <div class="table-responsive">
            <table class="clients-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>N° Client</th>
                        <th>Nom Complet</th>
                        <th>Email</th>
                        <th>Téléphone</th>
                        <th>Date de Création</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                    for (Client client : clients) {
                    %>
                        <tr>
                            <td><strong>#<%= client.getId() %></strong></td>
                            <td>
                                <% if (client.getNumeroClient() != null) { %>
                                    <span class="client-numero"><%= client.getNumeroClient() %></span>
                                <% } else { %>
                                    <span class="text-muted font-italic">Non assigné</span>
                                <% } %>
                            </td>
                            <td>
                                <div class="client-name"><%= client.getPrenom() %> <%= client.getNom() %></div>
                                <% if (client.getProfession() != null && !client.getProfession().isEmpty()) { %>
                                    <div class="client-profession"><%= client.getProfession() %></div>
                                <% } %>
                            </td>
                            <td><%= client.getEmail() %></td>
                            <td><%= client.getTelephone() %></td>
                            <td>
                                <%= dateFormat.format(java.sql.Timestamp.valueOf(client.getDateCreation())) %>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/clients/details?id=<%= client.getId() %>" 
                                       class="btn-action btn-info">
                                        <i class="fas fa-eye"></i>
                                        Détails
                                    </a>
                                    <a href="${pageContext.request.contextPath}/clients/edit?id=<%= client.getId() %>" 
                                       class="btn-action btn-edit">
                                        <i class="fas fa-edit"></i>
                                        Modifier
                                    </a>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } else { %>
        <div class="empty-state-card">
            <div class="empty-state-icon">
                <i class="fas fa-users"></i>
            </div>
            <h3 class="empty-state-title">Aucun client trouvé</h3>
            <p class="empty-state-text">
                <% if (Boolean.TRUE.equals(request.getAttribute("filtreApplique"))) { %>
                    Aucun client ne correspond aux critères de recherche.
                    <br>Essayez de modifier vos filtres ou de les réinitialiser.
                <% } else { %>
                    Il n'y a encore aucun client enregistré dans le système.
                    <br>Commencez par créer votre premier client !
                <% } %>
            </p>
        </div>
    <% } %>
</div>

<div class="page-actions">
    <a href="${pageContext.request.contextPath}/clients/register" class="btn-new-client">
        <i class="fas fa-user-plus"></i>
        Nouveau Client
    </a>
    <a href="${pageContext.request.contextPath}/" class="btn-back">
        <i class="fas fa-home"></i>
        Retour à l'accueil
    </a>
</div>