<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transactions - Banque Centralisateur</title>
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
        
        .compte-info {
            background: #f8f9fa;
            padding: 20px;
            border-bottom: 2px solid #eee;
        }
        
        .compte-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .info-card {
            background: white;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #4CAF50;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .info-label {
            font-weight: 600;
            color: #555;
            font-size: 0.9em;
            margin-bottom: 5px;
        }
        
        .info-value {
            font-size: 1.1em;
            color: #333;
            font-weight: 500;
        }
        
        .content {
            padding: 30px;
        }
        
        .transactions-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #eee;
        }
        
        .transactions-header h3 {
            color: #333;
            font-size: 1.5em;
        }
        
        .transactions-count {
            background: #4CAF50;
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 500;
        }
        
        .transactions-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        
        .transactions-table th {
            background: #4CAF50;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            font-size: 0.95em;
        }
        
        .transactions-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }
        
        .transactions-table tr:nth-child(even) {
            background: #f8f9fa;
        }
        
        .transactions-table tr:hover {
            background: #e8f5e8;
            transform: scale(1.01);
            transition: all 0.2s ease;
        }
        
        .transaction-depot {
            color: #4CAF50;
            font-weight: bold;
        }
        
        .transaction-retrait {
            color: #f44336;
            font-weight: bold;
        }
        
        .transaction-credit {
            background: #f8f9fa;
        }
        
        .transaction-debit {
            background: #fff5f5;
        }
        
        .transaction-neutre {
            background: #f8f9fa;
        }
        
        .montant-positif {
            color: #4CAF50;
            font-weight: bold;
        }
        
        .montant-negatif {
            color: #f44336;
            font-weight: bold;
        }
        
        .montant-neutre {
            color: #666;
            font-weight: bold;
        }
        
        .transaction-montant {
            font-family: 'Courier New', monospace;
            font-size: 1.1em;
            text-align: right;
        }
        
        .transaction-description {
            font-style: italic;
            color: #666;
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .transaction-date {
            color: #666;
            font-size: 0.9em;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }
        
        .empty-state h4 {
            font-size: 1.3em;
            margin-bottom: 10px;
            color: #999;
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
        
        .error {
            background: #ffebee;
            color: #c62828;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #f44336;
        }
        
        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 10px;
            }
            
            .content {
                padding: 20px;
            }
            
            .compte-details {
                grid-template-columns: 1fr;
            }
            
            .transactions-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .transactions-table {
                font-size: 0.9em;
            }
            
            .transactions-table th,
            .transactions-table td {
                padding: 8px 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 Historique des Transactions</h1>
            <div class="subtitle">Relevé détaillé des opérations</div>
        </div>
        
        <c:if test="${not empty compte}">
            <div class="compte-info">
                <div class="compte-details">
                    <div class="info-card">
                        <div class="info-label">Numéro de compte</div>
                        <div class="info-value">${compte.numeroCompte}</div>
                    </div>
                    <div class="info-card">
                        <div class="info-label">Titulaire</div>
                        <div class="info-value">${prenomClient} ${nomClient}</div>
                    </div>
                    <div class="info-card">
                        <div class="info-label">Solde actuel</div>
                        <div class="info-value">
                            <fmt:formatNumber value="${compte.solde}" type="currency" currencySymbol="€"/>
                        </div>
                    </div>
                    <div class="info-card">
                        <div class="info-label">Solde disponible</div>
                        <div class="info-value">
                            <fmt:formatNumber value="${compte.solde + compte.decouvertAutorise}" type="currency" currencySymbol="€"/>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        
        <div class="content">
            <c:if test="${not empty error}">
                <div class="error">
                    <strong>Erreur :</strong> ${error}
                </div>
            </c:if>
            
            <div class="transactions-header">
                <h3>📋 Liste des Transactions</h3>
                <div class="transactions-count">
                    ${nombreTransactions} transaction(s)
                </div>
            </div>
            
            <c:choose>
                <c:when test="${empty transactions}">
                    <div class="empty-state">
                        <h4>🔍 Aucune transaction trouvée</h4>
                        <p>Il n'y a aucune transaction enregistrée pour ce compte.</p>
                        <p>Les nouvelles opérations apparaîtront ici.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="transactions-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Type</th>
                                <th>Montant</th>
                                <th>Description</th>
                                <th>Référence</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="transaction" items="${transactions}">
                                <tr class="${transaction.classeCss}">
                                    <td class="transaction-date">
                                        ${transaction.dateTransactionFormatee}
                                    </td>
                                    <td>
                                        <span style="color: '${transaction.typeOperationCouleur}'">
                                            ${transaction.typeOperationIcone} ${transaction.typeOperationLibelle}
                                        </span>
                                    </td>
                                    <td class="transaction-montant ${transaction.classeMontant}">
                                        ${transaction.montantAvecSigne}
                                    </td>
                                    <td class="transaction-description" title="${transaction.descriptionComplete}">
                                        ${transaction.descriptionCourte}
                                    </td>
                                    <td>
                                        ${transaction.referenceAffichage}
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
            
            <div class="actions">
                <a href="${pageContext.request.contextPath}/compte-courant/detail?id=${compte.id}" class="btn btn-secondary">
                    ← Retour aux détails
                </a>
                <a href="${pageContext.request.contextPath}/compte-courant/transaction?compteId=${compte.id}" class="btn btn-primary">
                    💰 Nouvelle transaction
                </a>
                <a href="${pageContext.request.contextPath}/compte-courant/liste" class="btn btn-secondary">
                    📋 Liste des comptes
                </a>
            </div>
        </div>
    </div>
</body>
</html>