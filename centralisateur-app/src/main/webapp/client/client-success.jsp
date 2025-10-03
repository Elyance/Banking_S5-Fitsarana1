<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.centralisateur.entity.Client" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Client Enregistré - Banking S5</title>
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
            max-width: 600px;
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
        }

        .header h1 {
            color: #28a745;
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .header p {
            color: #666;
            font-size: 1rem;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 30px;
            text-align: center;
            border: 1px solid #c3e6cb;
        }

        .client-info {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
            margin-bottom: 30px;
        }

        .client-info h3 {
            color: #333;
            margin-bottom: 20px;
            font-size: 1.3rem;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            padding-bottom: 8px;
            border-bottom: 1px solid #e1e8ed;
        }

        .info-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .info-label {
            font-weight: 600;
            color: #555;
            min-width: 150px;
        }

        .info-value {
            color: #333;
            text-align: right;
            flex: 1;
        }

        .actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
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

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .btn:active {
            transform: translateY(0);
        }

        @media (max-width: 768px) {
            .container {
                padding: 30px 20px;
            }

            .actions {
                flex-direction: column;
            }

            .info-item {
                flex-direction: column;
                text-align: left;
            }

            .info-value {
                text-align: left;
                margin-top: 5px;
                font-weight: 500;
            }

            .header h1 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>✅ Client Enregistré</h1>
            <p>Le nouveau client a été créé avec succès dans le système</p>
        </div>

        <div class="success-message">
            <strong><%= request.getAttribute("message") %></strong>
        </div>

        <%
        Client client = (Client) request.getAttribute("client");
        if (client != null) {
        %>
        <div class="client-info">
            <h3>📋 Informations du client</h3>
            
            <div class="info-item">
                <span class="info-label">ID Client:</span>
                <span class="info-value"><%= client.getId() %></span>
            </div>

            <div class="info-item">
                <span class="info-label">N° Client:</span>
                <span class="info-value">
                    <% if (client.getNumeroClient() != null) { %>
                        <strong style="color: #667eea;"><%= client.getNumeroClient() %></strong>
                    <% } else { %>
                        <span style="color: #999;">Non assigné</span>
                    <% } %>
                </span>
            </div>
            
            <div class="info-item">
                <span class="info-label">Nom complet:</span>
                <span class="info-value"><%= client.getPrenom() %> <%= client.getNom() %></span>
            </div>
            
            <div class="info-item">
                <span class="info-label">Email:</span>
                <span class="info-value"><%= client.getEmail() %></span>
            </div>
            
            <div class="info-item">
                <span class="info-label">Téléphone:</span>
                <span class="info-value"><%= client.getTelephone() %></span>
            </div>
            
            <% if (client.getDateNaissance() != null) { %>
                <div class="info-item">
                    <span class="info-label">Date de naissance:</span>
                    <span class="info-value">
                        <%= new SimpleDateFormat("dd/MM/yyyy").format(java.sql.Date.valueOf(client.getDateNaissance())) %>
                    </span>
                </div>
            <% } %>
            
            <% if (client.getProfession() != null && !client.getProfession().isEmpty()) { %>
                <div class="info-item">
                    <span class="info-label">Profession:</span>
                    <span class="info-value"><%= client.getProfession() %></span>
                </div>
            <% } %>
            
            <% if (client.getAdresse() != null && !client.getAdresse().isEmpty()) { %>
                <div class="info-item">
                    <span class="info-label">Adresse:</span>
                    <span class="info-value"><%= client.getAdresse() %></span>
                </div>
            <% } %>
            
            <div class="info-item">
                <span class="info-label">Date de création:</span>
                <span class="info-value">
                    <%= new SimpleDateFormat("dd/MM/yyyy 'à' HH:mm").format(java.sql.Timestamp.valueOf(client.getDateCreation())) %>
                </span>
            </div>
        </div>
        <% } %>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/clients/register" class="btn btn-primary">
                👥 Enregistrer un autre client
            </a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                🏠 Retour à l'accueil
            </a>
        </div>
    </div>
</body>
</html>