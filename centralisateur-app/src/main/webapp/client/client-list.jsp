<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.centralisateur.entity.Client" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Clients - Banking S5</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            background: white;
            padding: 30px;
            border-radius: 15px 15px 0 0;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .header h1 {
            color: #333;
            font-size: 2.2rem;
            margin-bottom: 10px;
        }

        .header p {
            color: #666;
            font-size: 1.1rem;
        }

        .stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 1.8rem;
            font-weight: bold;
            color: #667eea;
        }

        .stat-label {
            color: #666;
            font-size: 0.9rem;
        }

        .filters {
            background: white;
            padding: 25px;
            border-left: 4px solid #667eea;
        }

        .filters h3 {
            color: #333;
            margin-bottom: 20px;
            font-size: 1.3rem;
        }

        .filter-form {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr auto auto;
            gap: 15px;
            align-items: end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            margin-bottom: 5px;
            color: #555;
            font-weight: 500;
        }

        .form-group input {
            padding: 10px 12px;
            border: 2px solid #e1e8ed;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-success {
            background: #28a745;
            color: white;
        }

        .btn-info {
            background: #17a2b8;
            color: white;
            padding: 8px 12px;
            font-size: 12px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .table-container {
            background: white;
            border-radius: 0 0 15px 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th {
            background: #f8f9fa;
            padding: 15px 12px;
            text-align: left;
            font-weight: 600;
            color: #333;
            border-bottom: 2px solid #dee2e6;
        }

        .table td {
            padding: 12px;
            border-bottom: 1px solid #e9ecef;
            vertical-align: middle;
        }

        .table tbody tr:hover {
            background: #f8f9fa;
        }

        .table tbody tr:nth-child(even) {
            background: #fdfdfd;
        }

        .table tbody tr:nth-child(even):hover {
            background: #f8f9fa;
        }

        .alert {
            padding: 15px;
            margin: 20px 0;
            border-radius: 8px;
            font-weight: 500;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-warning {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .actions {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin: 20px 0;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
        }

        .badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .badge-active {
            background: #d4edda;
            color: #155724;
        }

        .badge-inactive {
            background: #f8d7da;
            color: #721c24;
        }

        @media (max-width: 768px) {
            .filter-form {
                grid-template-columns: 1fr;
            }
            
            .stats {
                flex-direction: column;
                gap: 15px;
            }

            .table-container {
                overflow-x: auto;
            }

            .table {
                min-width: 600px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>👥 Liste des Clients</h1>
            <p>Gestion et consultation des clients de la banque</p>
            
            <div class="stats">
                <div class="stat-item">
                    <div class="stat-number"><%= request.getAttribute("totalClients") != null ? request.getAttribute("totalClients") : 0 %></div>
                    <div class="stat-label">Clients Total</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number"><%= request.getAttribute("clients") != null ? ((List<Client>) request.getAttribute("clients")).size() : 0 %></div>
                    <div class="stat-label">Affichés</div>
                </div>
                <div class="stat-item">
                    <% if (Boolean.TRUE.equals(request.getAttribute("filtreApplique"))) { %>
                        <span class="badge badge-active">Filtre Actif</span>
                    <% } else { %>
                        <span class="badge badge-inactive">Tous</span>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="filters">
            <h3>🔍 Filtres de recherche</h3>
            <form class="filter-form" method="post" action="${pageContext.request.contextPath}/clients/list">
                <div class="form-group">
                    <label for="nomFiltre">Recherche par nom :</label>
                    <input type="text" id="nomFiltre" name="nomFiltre" 
                           value="<%= request.getAttribute("nomFiltre") != null ? request.getAttribute("nomFiltre") : "" %>"
                           placeholder="Tapez le nom du client...">
                </div>
                
                <div class="form-group">
                    <label for="emailFiltre">Recherche par email :</label>
                    <input type="email" id="emailFiltre" name="emailFiltre" 
                           value="<%= request.getAttribute("emailFiltre") != null ? request.getAttribute("emailFiltre") : "" %>"
                           placeholder="email@exemple.com">
                </div>

                <div class="form-group">
                    <label for="numeroClientFiltre">Recherche par N° client :</label>
                    <input type="text" id="numeroClientFiltre" name="numeroClientFiltre" 
                           value="<%= request.getAttribute("numeroClientFiltre") != null ? request.getAttribute("numeroClientFiltre") : "" %>"
                           placeholder="CLI-20251003-00001">
                </div>
                
                <button type="submit" class="btn btn-primary">Filtrer</button>
                <a href="${pageContext.request.contextPath}/clients/list" class="btn btn-secondary">Réinitialiser</a>
            </form>
        </div>

        <!-- Messages d'erreur ou d'information -->
        <% 
        String error = (String) request.getAttribute("error");
        if (error != null) { 
        %>
            <div class="alert alert-error">
                <%= error %>
            </div>
        <% } %>

        <div class="table-container">
            <%
            List<Client> clients = (List<Client>) request.getAttribute("clients");
            if (clients != null && !clients.isEmpty()) {
            %>
                <table class="table">
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
                                        <strong style="color: #667eea;"><%= client.getNumeroClient() %></strong>
                                    <% } else { %>
                                        <span style="color: #999; font-style: italic;">Non assigné</span>
                                    <% } %>
                                </td>
                                <td>
                                    <strong><%= client.getPrenom() %> <%= client.getNom() %></strong>
                                    <% if (client.getProfession() != null && !client.getProfession().isEmpty()) { %>
                                        <br><small style="color: #666;"><%= client.getProfession() %></small>
                                    <% } %>
                                </td>
                                <td><%= client.getEmail() %></td>
                                <td><%= client.getTelephone() %></td>
                                <td>
                                    <%= dateFormat.format(java.sql.Timestamp.valueOf(client.getDateCreation())) %>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/clients/details?id=<%= client.getId() %>" 
                                       class="btn btn-info">
                                        👁️ Détails
                                    </a>
                                    <a href="${pageContext.request.contextPath}/clients/edit?id=<%= client.getId() %>" 
                                       class="btn btn-primary" style="margin-left: 5px;">
                                        ✏️ Modifier
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="no-data">
                    <h3>😔 Aucun client trouvé</h3>
                    <p>
                        <% if (Boolean.TRUE.equals(request.getAttribute("filtreApplique"))) { %>
                            Aucun client ne correspond aux critères de recherche.
                        <% } else { %>
                            Il n'y a encore aucun client enregistré dans le système.
                        <% } %>
                    </p>
                </div>
            <% } %>
        </div>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/clients/register" class="btn btn-success">
                ➕ Nouveau Client
            </a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                🏠 Retour à l'accueil
            </a>
        </div>
    </div>
</body>
</html>