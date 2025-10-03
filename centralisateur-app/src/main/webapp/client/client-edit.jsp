<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.centralisateur.entity.Client" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Client - Banking S5</title>
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
            color: #333;
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .header p {
            color: #666;
            font-size: 1rem;
        }

        .client-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            border-left: 4px solid #667eea;
        }

        .client-info h3 {
            color: #333;
            margin-bottom: 5px;
        }

        .client-id {
            color: #666;
            font-size: 0.9rem;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-row {
            display: flex;
            gap: 15px;
        }

        .form-row .form-group {
            flex: 1;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }

        .required {
            color: #e74c3c;
        }

        input[type="text"],
        input[type="email"],
        input[type="tel"],
        input[type="date"],
        input[type="hidden"],
        textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e8ed;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="tel"]:focus,
        input[type="date"]:focus,
        textarea:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        textarea {
            resize: vertical;
            min-height: 80px;
        }

        .btn {
            padding: 15px 25px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin: 5px;
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
            width: 100%;
            margin-top: 10px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .btn:active {
            transform: translateY(0);
        }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .actions {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        .form-note {
            background: #e3f2fd;
            color: #1565c0;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            border-left: 4px solid #2196f3;
        }

        @media (max-width: 768px) {
            .container {
                padding: 30px 20px;
            }

            .form-row {
                flex-direction: column;
                gap: 0;
            }

            .header h1 {
                font-size: 1.5rem;
            }

            .actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                margin: 5px 0;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>✏️ Modifier Client</h1>
            <p>Mise à jour des informations du client</p>
        </div>

        <%
        Client client = (Client) request.getAttribute("client");
        if (client != null) {
        %>
            <div class="client-info">
                <h3><%= client.getPrenom() %> <%= client.getNom() %></h3>
                <div class="client-id">ID Client: #<%= client.getId() %></div>
            </div>

            <div class="form-note">
                <strong>ℹ️ Information :</strong> Modifiez les informations que vous souhaitez mettre à jour. 
                Les champs marqués d'un astérisque (*) sont obligatoires.
            </div>
        <% } %>

        <!-- Message d'erreur -->
        <% 
        String error = (String) request.getAttribute("error");
        if (error != null) { 
        %>
            <div class="alert alert-error">
                <%= error %>
            </div>
        <% } %>

        <!-- Formulaire de modification -->
        <form action="${pageContext.request.contextPath}/clients/edit" method="post">
            <!-- ID du client (champ caché) -->
            <input type="hidden" name="clientId" value="<%= client != null ? client.getId() : request.getAttribute("clientId") %>">

            <div class="form-row">
                <div class="form-group">
                    <label for="nom">Nom <span class="required">*</span></label>
                    <input type="text" id="nom" name="nom" 
                           value="<%= request.getAttribute("nom") != null ? request.getAttribute("nom") : (client != null ? client.getNom() : "") %>" 
                           required>
                </div>
                <div class="form-group">
                    <label for="prenom">Prénom <span class="required">*</span></label>
                    <input type="text" id="prenom" name="prenom" 
                           value="<%= request.getAttribute("prenom") != null ? request.getAttribute("prenom") : (client != null ? client.getPrenom() : "") %>" 
                           required>
                </div>
            </div>

            <div class="form-group">
                <label for="email">Email <span class="required">*</span></label>
                <input type="email" id="email" name="email" 
                       value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : (client != null ? client.getEmail() : "") %>" 
                       required>
            </div>

            <div class="form-group">
                <label for="telephone">Téléphone <span class="required">*</span></label>
                <input type="tel" id="telephone" name="telephone" 
                       value="<%= request.getAttribute("telephone") != null ? request.getAttribute("telephone") : (client != null ? client.getTelephone() : "") %>" 
                       required>
            </div>

            <div class="form-group">
                <label for="dateNaissance">Date de naissance</label>
                <%
                String dateNaissance = "";
                if (request.getAttribute("dateNaissance") != null) {
                    dateNaissance = (String) request.getAttribute("dateNaissance");
                } else if (client != null && client.getDateNaissance() != null) {
                    dateNaissance = client.getDateNaissance().toString();
                }
                %>
                <input type="date" id="dateNaissance" name="dateNaissance" value="<%= dateNaissance %>">
            </div>

            <div class="form-group">
                <label for="profession">Profession</label>
                <input type="text" id="profession" name="profession" 
                       value="<%= request.getAttribute("profession") != null ? request.getAttribute("profession") : (client != null && client.getProfession() != null ? client.getProfession() : "") %>">
            </div>

            <div class="form-group">
                <label for="adresse">Adresse</label>
                <textarea id="adresse" name="adresse" placeholder="Adresse complète..."><%= request.getAttribute("adresse") != null ? request.getAttribute("adresse") : (client != null && client.getAdresse() != null ? client.getAdresse() : "") %></textarea>
            </div>

            <button type="submit" class="btn btn-success">
                💾 Enregistrer les modifications
            </button>
        </form>

        <div class="actions">
            <% if (client != null) { %>
                <a href="${pageContext.request.contextPath}/clients/details?id=<%= client.getId() %>" class="btn btn-secondary">
                    ↩️ Retour aux détails
                </a>
            <% } %>
            <a href="${pageContext.request.contextPath}/clients/list" class="btn btn-primary">
                📋 Liste des clients
            </a>
        </div>
    </div>
</body>
</html>