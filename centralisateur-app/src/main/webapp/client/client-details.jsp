<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.centralisateur.entity.Client" %>
<%@ page import="com.centralisateur.entity.StatutClient" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails Client - Banking S5</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 800px;
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e1e8ed;
        }

        .header h1 {
            color: #333;
            font-size: 2.2rem;
            margin-bottom: 10px;
        }

        .header p {
            color: #666;
            font-size: 1rem;
        }

        .client-card {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 12px;
            border-left: 5px solid #667eea;
            margin-bottom: 30px;
        }

        .client-header {
            text-align: center;
            margin-bottom: 25px;
        }

        .client-name {
            font-size: 1.8rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        .client-id {
            color: #666;
            font-size: 1rem;
            margin-bottom: 15px;
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status-inactive {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 30px;
        }

        .detail-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            border-left: 3px solid #667eea;
        }

        .detail-section h3 {
            color: #333;
            font-size: 1.2rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            padding-bottom: 8px;
            border-bottom: 1px solid #e9ecef;
        }

        .detail-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .detail-label {
            font-weight: 600;
            color: #555;
            min-width: 120px;
        }

        .detail-value {
            color: #333;
            text-align: right;
            flex: 1;
            word-break: break-word;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
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
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }

        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .btn:active {
            transform: translateY(0);
        }

        .empty-value {
            color: #999;
            font-style: italic;
        }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        @media (max-width: 768px) {
            .container {
                padding: 30px 20px;
            }

            .details-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .detail-item {
                flex-direction: column;
                text-align: left;
            }

            .detail-value {
                text-align: left;
                margin-top: 5px;
                font-weight: 500;
            }

            .header h1 {
                font-size: 1.8rem;
            }

            .client-name {
                font-size: 1.5rem;
            }

            .actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>👤 Détails du Client</h1>
            <p>Informations complètes du client</p>
        </div>

        <!-- Message de succès -->
        <% 
        String successMessage = (String) request.getAttribute("successMessage");
        if (successMessage != null) { 
        %>
            <div class="alert alert-success">
                <%= successMessage %>
            </div>
        <% } %>

        <%
        Client client = (Client) request.getAttribute("client");
        StatutClient statut = (StatutClient) request.getAttribute("statut");
        
        if (client != null) {
        %>
            <div class="client-card">
                <div class="client-header">
                    <div class="client-name">
                        <%= client.getPrenom() %> <%= client.getNom() %>
                    </div>
                    <div class="client-id">
                        ID Client: #<%= client.getId() %>
                    </div>
                    <% if (statut != null) { %>
                        <span class="status-badge <%= "ACTIF".equals(statut.getLibelle()) ? "status-active" : "status-inactive" %>">
                            <%= statut.getLibelle() %>
                        </span>
                    <% } %>
                </div>
            </div>

            <div class="details-grid">
                <!-- Informations personnelles -->
                <div class="detail-section">
                    <h3>📋 Informations Personnelles</h3>
                    
                    <div class="detail-item">
                        <span class="detail-label">Nom :</span>
                        <span class="detail-value"><%= client.getNom() %></span>
                    </div>
                    
                    <div class="detail-item">
                        <span class="detail-label">Prénom :</span>
                        <span class="detail-value"><%= client.getPrenom() %></span>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">N° Client :</span>
                        <span class="detail-value">
                            <% if (client.getNumeroClient() != null) { %>
                                <strong style="color: #667eea;"><%= client.getNumeroClient() %></strong>
                            <% } else { %>
                                <span class="empty-value">Non assigné</span>
                            <% } %>
                        </span>
                    </div>
                    
                    <div class="detail-item">
                        <span class="detail-label">Date de naissance :</span>
                        <span class="detail-value">
                            <% if (client.getDateNaissance() != null) { %>
                                <%= new SimpleDateFormat("dd/MM/yyyy").format(java.sql.Date.valueOf(client.getDateNaissance())) %>
                            <% } else { %>
                                <span class="empty-value">Non renseignée</span>
                            <% } %>
                        </span>
                    </div>
                    
                    <div class="detail-item">
                        <span class="detail-label">Profession :</span>
                        <span class="detail-value">
                            <% if (client.getProfession() != null && !client.getProfession().isEmpty()) { %>
                                <%= client.getProfession() %>
                            <% } else { %>
                                <span class="empty-value">Non renseignée</span>
                            <% } %>
                        </span>
                    </div>
                </div>

                <!-- Informations de contact -->
                <div class="detail-section">
                    <h3>📞 Contact</h3>
                    
                    <div class="detail-item">
                        <span class="detail-label">Email :</span>
                        <span class="detail-value">
                            <a href="mailto:<%= client.getEmail() %>" style="color: #667eea; text-decoration: none;">
                                <%= client.getEmail() %>
                            </a>
                        </span>
                    </div>
                    
                    <div class="detail-item">
                        <span class="detail-label">Téléphone :</span>
                        <span class="detail-value">
                            <a href="tel:<%= client.getTelephone() %>" style="color: #667eea; text-decoration: none;">
                                <%= client.getTelephone() %>
                            </a>
                        </span>
                    </div>
                    
                    <div class="detail-item">
                        <span class="detail-label">Adresse :</span>
                        <span class="detail-value">
                            <% if (client.getAdresse() != null && !client.getAdresse().isEmpty()) { %>
                                <%= client.getAdresse() %>
                            <% } else { %>
                                <span class="empty-value">Non renseignée</span>
                            <% } %>
                        </span>
                    </div>
                </div>

                <!-- Informations système -->
                <div class="detail-section full-width">
                    <h3>⚙️ Informations Système</h3>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="detail-item">
                            <span class="detail-label">Date de création :</span>
                            <span class="detail-value">
                                <%= new SimpleDateFormat("dd/MM/yyyy 'à' HH:mm").format(java.sql.Timestamp.valueOf(client.getDateCreation())) %>
                            </span>
                        </div>
                        
                        <div class="detail-item">
                            <span class="detail-label">Dernière modification :</span>
                            <span class="detail-value">
                                <% if (client.getDateModification() != null) { %>
                                    <%= new SimpleDateFormat("dd/MM/yyyy 'à' HH:mm").format(java.sql.Timestamp.valueOf(client.getDateModification())) %>
                                <% } else { %>
                                    <span class="empty-value">Jamais modifié</span>
                                <% } %>
                            </span>
                        </div>
                    </div>
                    
                    <% if (statut != null) { %>
                        <div class="detail-item">
                            <span class="detail-label">Statut :</span>
                            <span class="detail-value">
                                <%= statut.getLibelle() %>
                                <% if (statut.getDescription() != null && !statut.getDescription().isEmpty()) { %>
                                    <br><small style="color: #666;">(<%= statut.getDescription() %>)</small>
                                <% } %>
                            </span>
                        </div>
                    <% } %>
                </div>
            </div>

        <% } else { %>
            <div style="text-align: center; padding: 40px; color: #666;">
                <h3>😔 Client non trouvé</h3>
                <p>Les informations du client demandé ne sont pas disponibles.</p>
            </div>
        <% } %>

        <div class="actions">
            <% if (client != null) { %>
                <a href="${pageContext.request.contextPath}/clients/edit?id=<%= client.getId() %>" class="btn btn-primary">
                    ✏️ Modifier ce Client
                </a>
            <% } %>
            <a href="${pageContext.request.contextPath}/clients/list" class="btn btn-secondary">
                📋 Liste des Clients
            </a>
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