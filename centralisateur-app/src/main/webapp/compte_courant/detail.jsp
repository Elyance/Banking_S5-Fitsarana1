<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails du Compte - Banque Centralisateur</title>
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
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #4CAF50, #45a049);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 2em;
            margin-bottom: 10px;
        }
        
        .header .subtitle {
            opacity: 0.9;
            font-size: 1.1em;
        }
        
        .content {
            padding: 40px;
        }
        
        .compte-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .info-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            border-left: 4px solid #4CAF50;
        }
        
        .info-section h3 {
            color: #333;
            margin-bottom: 20px;
            font-size: 1.3em;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding: 10px 0;
        }
        
        .info-label {
            font-weight: 600;
            color: #555;
            min-width: 150px;
        }
        
        .info-value {
            font-weight: 400;
            color: #333;
            text-align: right;
            flex: 1;
        }
        
        .solde-positif {
            color: #4CAF50;
            font-weight: bold;
            font-size: 1.1em;
        }
        
        .solde-negatif {
            color: #f44336;
            font-weight: bold;
            font-size: 1.1em;
        }
        
        .statut-actif {
            background: #4CAF50;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 500;
        }
        
        .statut-suspendu {
            background: #FF9800;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 500;
        }
        
        .statut-ferme {
            background: #f44336;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 500;
        }
        
        .actions {
            text-align: center;
            padding: 20px 0;
            border-top: 2px solid #eee;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 25px;
            margin: 0 10px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 1em;
        }
        
        .btn-primary {
            background: #4CAF50;
            color: white;
        }
        
        .btn-primary:hover {
            background: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.3);
        }
        
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        
        .btn-danger:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
        }
        
        .error {
            background: #ffebee;
            color: #c62828;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #f44336;
        }
        
        .highlight {
            background: #fff3e0;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #FF9800;
            margin: 20px 0;
        }
        
        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 10px;
            }
            
            .content {
                padding: 20px;
            }
            
            .compte-info {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .info-row {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .info-value {
                text-align: left;
                margin-top: 5px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Détails du Compte Courant</h1>
            <div class="subtitle">Informations complètes et gestion</div>
        </div>
        
        <div class="content">
            <c:if test="${not empty error}">
                <div class="error">
                    <strong>Erreur :</strong> ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty compte}">
                <div class="compte-info">
                    <!-- Informations du Compte -->
                    <div class="info-section">
                        <h3>🏦 Informations du Compte</h3>
                        
                        <div class="info-row">
                            <span class="info-label">Numéro de compte :</span>
                            <span class="info-value"><strong>${compte.numeroCompte}</strong></span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Solde actuel :</span>
                            <span class="info-value ${compte.classeSolde}">
                                <fmt:formatNumber value="${compte.solde}" type="currency" currencySymbol="€"/>
                            </span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Découvert autorisé :</span>
                            <span class="info-value">
                                <fmt:formatNumber value="${compte.decouvertAutorise}" type="currency" currencySymbol="€"/>
                            </span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Solde disponible :</span>
                            <span class="info-value">
                                <fmt:formatNumber value="${compte.soldeDisponible}" type="currency" currencySymbol="€"/>
                            </span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Statut :</span>
                            <span class="info-value">
                                <span class="${compte.classeStatut}">${compte.statutCompte}</span>
                            </span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Date de création :</span>
                            <span class="info-value">${compte.dateCreationFormatee}</span>
                        </div>
                    </div>
                    
                    <!-- Informations du Client -->
                    <div class="info-section">
                        <h3>👤 Informations du Titulaire</h3>
                        
                        <div class="info-row">
                            <span class="info-label">Nom complet :</span>
                            <span class="info-value"><strong>${compte.nomComplet}</strong></span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Nom :</span>
                            <span class="info-value">${compte.nomClient}</span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Prénom :</span>
                            <span class="info-value">${compte.prenomClient}</span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Email :</span>
                            <span class="info-value">${compte.emailClient}</span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">ID Client :</span>
                            <span class="info-value">#${compte.clientId}</span>
                        </div>
                    </div>
                </div>
                
                <c:if test="${compte.enDecouvert}">
                    <div class="highlight">
                        <strong>⚠️ Attention :</strong> Ce compte est actuellement en découvert. 
                        Le solde disponible tient compte du découvert autorisé.
                    </div>
                </c:if>
                
                <div class="actions">
                    <a href="${pageContext.request.contextPath}/compte-courant/liste" class="btn btn-secondary">
                        ← Retour à la liste
                    </a>
                    <a href="${pageContext.request.contextPath}/compte-courant/transactions?compteId=${compte.compteId}" class="btn btn-primary">
                        📊 Voir les transactions
                    </a>
                    <a href="${pageContext.request.contextPath}/compte-courant/transaction?compteId=${compte.compteId}" class="btn btn-primary">
                        💰 Nouvelle transaction
                    </a>
                    <button class="btn btn-danger" onclick="confirmerSuppression('${compte.compteId}', '${compte.numeroCompte}')">
                        🗑️ Supprimer le compte
                    </button>
                </div>
            </c:if>
            
            <c:if test="${empty compte && empty error}">
                <div class="error">
                    <strong>Aucun compte trouvé</strong><br>
                    Les informations du compte demandé ne sont pas disponibles.
                </div>
                <div class="actions">
                    <a href="${pageContext.request.contextPath}/compte-courant/liste" class="btn btn-secondary">
                        ← Retour à la liste
                    </a>
                </div>
            </c:if>
        </div>
    </div>
    
    <script>
        function confirmerSuppression(compteId, numeroCompte) {
            const confirmation = confirm(
                "Êtes-vous sûr de vouloir supprimer le compte " + numeroCompte + " ?\n\n" +
                "⚠️ ATTENTION : Cette action est irréversible !\n" +
                "• Toutes les transactions seront supprimées\n" +
                "• Le compte ne pourra pas être récupéré\n" +
                "• Cette action doit être validée par le client\n\n" +
                "Confirmez-vous la suppression ?"
            );
            
            if (confirmation) {
                // Créer un formulaire pour envoyer la requête POST
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/compte-courant/supprimer';
                
                // Ajouter l'ID du compte
                const inputId = document.createElement('input');
                inputId.type = 'hidden';
                inputId.name = 'compteId';
                inputId.value = compteId;
                form.appendChild(inputId);
                
                // Ajouter un token de confirmation
                const inputConfirm = document.createElement('input');
                inputConfirm.type = 'hidden';
                inputConfirm.name = 'confirme';
                inputConfirm.value = 'true';
                form.appendChild(inputConfirm);
                
                // Ajouter le formulaire à la page et le soumettre
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>