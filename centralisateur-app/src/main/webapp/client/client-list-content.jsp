<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.centralisateur.entity.Client" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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

    .filter-options {
        display: flex;
        flex-direction: column;
        justify-content: end;
        gap: 0.5rem;
    }

    .filter-checkbox {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.875rem;
        color: var(--text-secondary);
        cursor: pointer;
        user-select: none;
    }

    .filter-checkbox input[type="checkbox"] {
        width: 16px;
        height: 16px;
        accent-color: var(--primary-color);
    }

    .filter-counter {
        font-size: 0.75rem;
        color: var(--text-muted);
        font-weight: normal;
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
            cursor: pointer;
            transition: background-color var(--transition-fast);
            position: relative;
        }

        .clients-table th:hover {
            background: var(--border-color);
        }

        .clients-table th:last-child {
            cursor: default;
        }

        .clients-table th:last-child:hover {
            background: var(--bg-light);
        }

        .sort-icon {
            font-size: 0.75rem;
            margin-left: 0.5rem;
            opacity: 0.5;
            transition: all var(--transition-fast);
        }

        .clients-table th:hover .sort-icon {
            opacity: 1;
        }

        .client-row.hidden {
            display: none;
        }

        .client-row.highlight {
            background: rgba(37, 99, 235, 0.1) !important;
            border-left: 4px solid var(--primary-color);
        }    .clients-table td {
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
            grid-column: span 1;
        }
        
        .filter-options {
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
        
        .filter-form .btn,
        .filter-options {
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
        
        .clients-table th {
            cursor: default;
        }
        
        .sort-icon {
            display: none;
        }
    }
</style>

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
        <div class="client-stat-number" id="totalClientsCount"><%= request.getAttribute("totalClients") != null ? request.getAttribute("totalClients") : 0 %></div>
        <div class="client-stat-label">Clients Total</div>
    </div>
    <div class="client-stat-card">
        <div class="client-stat-number" id="visibleClientsCount"><%= request.getAttribute("clients") != null ? ((List<Client>) request.getAttribute("clients")).size() : 0 %></div>
        <div class="client-stat-label">Affichés</div>
    </div>
    <div class="client-stat-card">
        <div class="client-stat-number">
            <span class="client-badge" id="filterStatusBadge">
                <span id="filterStatusText">Tous</span>
            </span>
        </div>
        <div class="client-stat-label">Statut Filtre</div>
    </div>
</div>

<!-- Filtres de recherche -->
<div class="filters-card">
    <h3 class="filters-title">
        <i class="fas fa-search"></i>
        Filtres de recherche
        <small class="filter-counter ms-auto" id="filterCounter"></small>
    </h3>
    <div class="filter-form">
        <div class="filter-group">
            <label for="nomFiltre">Recherche par nom :</label>
            <input type="text" id="nomFiltre" name="nomFiltre" 
                   placeholder="Tapez le nom du client...">
        </div>
        
        <div class="filter-group">
            <label for="emailFiltre">Recherche par email :</label>
            <input type="email" id="emailFiltre" name="emailFiltre" 
                   placeholder="email@exemple.com">
        </div>

        <div class="filter-group">
            <label for="numeroClientFiltre">Recherche par N° client :</label>
            <input type="text" id="numeroClientFiltre" name="numeroClientFiltre" 
                   placeholder="CLI-20251003-00001">
        </div>
        
        <button type="button" class="btn btn-outline-secondary" onclick="clearFilters()">
            <i class="fas fa-undo me-1"></i>
            Réinitialiser
        </button>
        
        <div class="filter-options">
            <label class="filter-checkbox">
                <input type="checkbox" id="showActiveOnly">
                <span class="checkmark"></span>
                Clients avec N° seulement
            </label>
        </div>
    </div>
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
            <table class="clients-table" id="clientsTable">
                <thead>
                    <tr>
                        <th onclick="sortTable(0)">
                            ID <i class="fas fa-sort sort-icon"></i>
                        </th>
                        <th onclick="sortTable(1)">
                            N° Client <i class="fas fa-sort sort-icon"></i>
                        </th>
                        <th onclick="sortTable(2)">
                            Nom Complet <i class="fas fa-sort sort-icon"></i>
                        </th>
                        <th onclick="sortTable(3)">
                            Email <i class="fas fa-sort sort-icon"></i>
                        </th>
                        <th onclick="sortTable(4)">
                            Téléphone <i class="fas fa-sort sort-icon"></i>
                        </th>
                        <th onclick="sortTable(5)">
                            Date de Création <i class="fas fa-sort sort-icon"></i>
                        </th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="clientsTableBody">
                    <%
                    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                    for (Client client : clients) {
                    %>
                        <tr class="client-row" 
                            data-nom="<%= client.getPrenom().toLowerCase() %> <%= client.getNom().toLowerCase() %>"
                            data-email="<%= client.getEmail().toLowerCase() %>"
                            data-numero="<%= client.getNumeroClient() != null ? client.getNumeroClient().toLowerCase() : "" %>"
                            data-has-numero="<%= client.getNumeroClient() != null ? "true" : "false" %>">
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

<script>
// Variables globales pour le filtrage et le tri
let allRows = [];
let currentSortColumn = -1;
let sortDirection = 'asc';

// Initialisation
document.addEventListener('DOMContentLoaded', function() {
    initializeClientList();
    updateFilterCounter();
});

// Initialiser la liste des clients
function initializeClientList() {
    const tableBody = document.getElementById('clientsTableBody');
    if (tableBody) {
        allRows = Array.from(tableBody.querySelectorAll('.client-row'));
    }
}

// Fonction de filtrage principal
function filterClients() {
    const nomFilter = document.getElementById('nomFiltre').value.toLowerCase().trim();
    const emailFilter = document.getElementById('emailFiltre').value.toLowerCase().trim();
    const numeroFilter = document.getElementById('numeroClientFiltre').value.toLowerCase().trim();
    const showActiveOnly = document.getElementById('showActiveOnly').checked;
    
    let visibleCount = 0;
    
    allRows.forEach(row => {
        const nomData = row.getAttribute('data-nom') || '';
        const emailData = row.getAttribute('data-email') || '';
        const numeroData = row.getAttribute('data-numero') || '';
        const hasNumero = row.getAttribute('data-has-numero') === 'true';
        
        let shouldShow = true;
        
        // Filtre par nom
        if (nomFilter && !nomData.includes(nomFilter)) {
            shouldShow = false;
        }
        
        // Filtre par email
        if (emailFilter && !emailData.includes(emailFilter)) {
            shouldShow = false;
        }
        
        // Filtre par numéro client
        if (numeroFilter && !numeroData.includes(numeroFilter)) {
            shouldShow = false;
        }
        
        // Filtre "Clients avec N° seulement"
        if (showActiveOnly && !hasNumero) {
            shouldShow = false;
        }
        
        // Appliquer la visibilité
        if (shouldShow) {
            row.classList.remove('hidden');
            row.classList.add('highlight');
            visibleCount++;
            
            // Retirer le highlight après un délai
            setTimeout(() => {
                row.classList.remove('highlight');
            }, 300);
        } else {
            row.classList.add('hidden');
            row.classList.remove('highlight');
        }
    });
    
    updateFilterCounter(visibleCount);
    updateEmptyState(visibleCount);
}

// Fonction pour effacer tous les filtres
function clearFilters() {
    document.getElementById('nomFiltre').value = '';
    document.getElementById('emailFiltre').value = '';
    document.getElementById('numeroClientFiltre').value = '';
    document.getElementById('showActiveOnly').checked = false;
    
    // Montrer toutes les lignes
    allRows.forEach(row => {
        row.classList.remove('hidden', 'highlight');
    });
    
    updateFilterCounter();
    updateEmptyState(allRows.length);
}

// Mettre à jour le compteur de filtres
function updateFilterCounter(visibleCount = null) {
    const counter = document.getElementById('filterCounter');
    const visibleClientsCount = document.getElementById('visibleClientsCount');
    const filterStatusBadge = document.getElementById('filterStatusBadge');
    const filterStatusText = document.getElementById('filterStatusText');
    
    if (visibleCount === null) {
        visibleCount = allRows.filter(row => !row.classList.contains('hidden')).length;
    }
    
    // Mettre à jour le compteur principal
    if (counter) {
        counter.textContent = `${visibleCount} sur ${allRows.length} clients affichés`;
    }
    
    // Mettre à jour les statistiques
    if (visibleClientsCount) {
        visibleClientsCount.textContent = visibleCount;
    }
    
    // Mettre à jour le statut du filtre
    const isFiltered = hasActiveFilters();
    if (filterStatusBadge && filterStatusText) {
        if (isFiltered) {
            filterStatusBadge.className = 'client-badge active';
            filterStatusText.textContent = 'Filtré';
        } else {
            filterStatusBadge.className = 'client-badge inactive';
            filterStatusText.textContent = 'Tous';
        }
    }
}

// Vérifier si des filtres sont actifs
function hasActiveFilters() {
    const nomFilter = document.getElementById('nomFiltre').value.trim();
    const emailFilter = document.getElementById('emailFiltre').value.trim();
    const numeroFilter = document.getElementById('numeroClientFiltre').value.trim();
    const showActiveOnly = document.getElementById('showActiveOnly').checked;
    
    return nomFilter !== '' || emailFilter !== '' || numeroFilter !== '' || showActiveOnly;
}

// Mettre à jour l'état vide
function updateEmptyState(visibleCount) {
    const tableCard = document.querySelector('.table-card');
    let emptyState = document.querySelector('.filter-empty-state');
    
    if (visibleCount === 0) {
        if (!emptyState) {
            emptyState = document.createElement('div');
            emptyState.className = 'filter-empty-state empty-state-card';
            emptyState.innerHTML = `
                <div class="empty-state-icon">
                    <i class="fas fa-search"></i>
                </div>
                <h3 class="empty-state-title">Aucun client trouvé</h3>
                <p class="empty-state-text">
                    Aucun client ne correspond aux critères de recherche actuels.<br>
                    Essayez de modifier vos filtres ou de les réinitialiser.
                </p>
                <button class="btn btn-outline-secondary mt-3" onclick="clearFilters()">
                    <i class="fas fa-undo me-1"></i>
                    Réinitialiser les filtres
                </button>
            `;
            tableCard.appendChild(emptyState);
        }
        document.querySelector('.table-responsive').style.display = 'none';
    } else {
        if (emptyState) {
            emptyState.remove();
        }
        document.querySelector('.table-responsive').style.display = 'block';
    }
}

// Fonction de tri des colonnes
function sortTable(columnIndex) {
    const table = document.getElementById('clientsTable');
    const tbody = document.getElementById('clientsTableBody');
    const rows = Array.from(tbody.querySelectorAll('.client-row:not(.hidden)'));
    
    // Déterminer la direction du tri
    if (currentSortColumn === columnIndex) {
        sortDirection = sortDirection === 'asc' ? 'desc' : 'asc';
    } else {
        sortDirection = 'asc';
        currentSortColumn = columnIndex;
    }
    
    // Mettre à jour les icônes de tri
    updateSortIcons(columnIndex, sortDirection);
    
    // Trier les lignes
    rows.sort((a, b) => {
        const aText = getCellText(a, columnIndex);
        const bText = getCellText(b, columnIndex);
        
        // Tri numérique pour l'ID
        if (columnIndex === 0) {
            const aNum = parseInt(aText.replace('#', ''));
            const bNum = parseInt(bText.replace('#', ''));
            return sortDirection === 'asc' ? aNum - bNum : bNum - aNum;
        }
        
        // Tri par date
        if (columnIndex === 5) {
            const aDate = parseDate(aText);
            const bDate = parseDate(bText);
            return sortDirection === 'asc' ? aDate - bDate : bDate - aDate;
        }
        
        // Tri alphabétique
        return sortDirection === 'asc' ? 
            aText.localeCompare(bText) : 
            bText.localeCompare(aText);
    });
    
    // Réorganiser les lignes dans le tableau
    rows.forEach(row => tbody.appendChild(row));
}

// Obtenir le texte d'une cellule pour le tri
function getCellText(row, columnIndex) {
    const cell = row.cells[columnIndex];
    return cell ? cell.textContent.trim() : '';
}

// Parser une date au format dd/MM/yyyy
function parseDate(dateStr) {
    const parts = dateStr.split('/');
    if (parts.length === 3) {
        return new Date(parts[2], parts[1] - 1, parts[0]);
    }
    return new Date(0);
}

// Mettre à jour les icônes de tri
function updateSortIcons(activeColumn, direction) {
    const headers = document.querySelectorAll('.clients-table th');
    
    headers.forEach((header, index) => {
        const icon = header.querySelector('.sort-icon');
        if (icon) {
            if (index === activeColumn) {
                icon.className = `fas fa-sort-${direction === 'asc' ? 'up' : 'down'} sort-icon`;
                icon.style.opacity = '1';
            } else {
                icon.className = 'fas fa-sort sort-icon';
                icon.style.opacity = '0.5';
            }
        }
    });
}

// Fonction pour highlight temporaire
function highlightRow(row) {
    row.classList.add('highlight');
    setTimeout(() => {
        row.classList.remove('highlight');
    }, 1000);
}

// Recherche rapide avec raccourcis clavier
document.addEventListener('keydown', function(e) {
    // Ctrl + F pour focus sur le premier filtre
    if (e.ctrlKey && e.key === 'f') {
        e.preventDefault();
        document.getElementById('nomFiltre').focus();
    }
    
    // Escape pour effacer les filtres
    if (e.key === 'Escape') {
        clearFilters();
    }
});

// Debounce pour optimiser les performances
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Optimiser le filtrage avec debounce
const debouncedFilter = debounce(filterClients, 300);

// Remplacer les événements oninput par des événements optimisés
document.addEventListener('DOMContentLoaded', function() {
    const filterInputs = ['nomFiltre', 'emailFiltre', 'numeroClientFiltre'];
    
    filterInputs.forEach(id => {
        const input = document.getElementById(id);
        if (input) {
            input.removeAttribute('oninput');
            input.addEventListener('input', debouncedFilter);
        }
    });
    
    const checkbox = document.getElementById('showActiveOnly');
    if (checkbox) {
        checkbox.removeAttribute('onchange');
        checkbox.addEventListener('change', filterClients);
    }
});
</script>