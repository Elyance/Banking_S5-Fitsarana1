<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Banking S5 - Serveur Centralisateur</title>
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
            text-align: center;
            max-width: 500px;
            width: 100%;
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

        h1 {
            color: #333;
            font-size: 2.5rem;
            margin-bottom: 10px;
        }

        .subtitle {
            color: #666;
            font-size: 1.2rem;
            margin-bottom: 30px;
        }

        .description {
            color: #555;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .btn {
            display: inline-block;
            padding: 15px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            margin: 10px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
        }

        .api-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-top: 30px;
            text-align: left;
        }

        .api-info h3 {
            color: #333;
            margin-bottom: 15px;
        }

        .endpoint {
            font-family: 'Courier New', monospace;
            background: #e9ecef;
            padding: 8px 12px;
            border-radius: 4px;
            margin: 5px 0;
            font-size: 14px;
        }

        .method {
            display: inline-block;
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: bold;
            margin-right: 10px;
        }

        .method.post { background: #28a745; color: white; }
        .method.get { background: #007bff; color: white; }

        .status {
            background: #d4edda;
            color: #155724;
            padding: 10px;
            border-radius: 5px;
            margin-top: 20px;
            border-left: 4px solid #28a745;
        }

        @media (max-width: 768px) {
            .container {
                padding: 30px 20px;
            }

            h1 {
                font-size: 2rem;
            }

            .btn {
                display: block;
                margin: 10px 0;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🏦 Banking S5</h1>
        <p class="subtitle">Serveur Centralisateur</p>
        
        <div class="description">
            <p>Système de gestion bancaire avec architecture distribuée.<br>
            Service de centralisation des données clients.</p>
        </div>

        <div class="status">
            <strong>✅ Serveur opérationnel</strong><br>
            Application déployée avec succès sur WildFly
        </div>

        <div style="margin: 30px 0;">
            <a href="clients/register" class="btn">
                ➕ Enregistrer un Client
            </a>
            <a href="clients/list" class="btn">
                � Liste des Clients
            </a>
        </div>

        <div class="api-info">
            <h3>🔗 Routes disponibles</h3>
            <div class="endpoint">
                <span class="method get">GET</span> /clients/register - Formulaire d'enregistrement
            </div>
            <div class="endpoint">
                <span class="method post">POST</span> /clients/register - Traitement enregistrement
            </div>
            <div class="endpoint">
                <span class="method get">GET</span> /clients/list - Liste des clients
            </div>
            <div class="endpoint">
                <span class="method post">POST</span> /clients/list - Filtrer les clients
            </div>
            <div class="endpoint">
                <span class="method get">GET</span> /clients/details?id={id} - Détails d'un client
            </div>
            <div class="endpoint">
                <span class="method get">GET</span> /clients/edit?id={id} - Formulaire de modification
            </div>
            <div class="endpoint">
                <span class="method post">POST</span> /clients/edit - Traitement modification
            </div>
        </div>

    </div>
</body>
</html>