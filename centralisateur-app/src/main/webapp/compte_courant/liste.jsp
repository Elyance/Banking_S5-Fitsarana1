<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Comptes Courants - Banque Centralisateur</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2c5aa0;
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #2c5aa0;
            padding-bottom: 10px;
        }
        .header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 10px;
        }
        .stats {
            background-color: #e8f4f8;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .stats h3 {
            margin: 0 0 10px 0;
            color: #2c5aa0;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            transition: background-color 0.3s;
        }
        .btn-primary {
            background-color: #2c5aa0;
            color: white;
        }
        .btn-primary:hover {
            background-color: #1a3d73;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
            font-size: 12px;
            padding: 5px 10px;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }
        .btn-info {
            background-color: #17a2b8;
            color: white;
            font-size: 12px;
            padding: 5px 10px;
        }
        .btn-info:hover {
            background-color: #138496;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .table-container {
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #2c5aa0;
            color: white;
            font-weight: bold;
        }
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        tr:hover {
            background-color: #e8f4f8;
        }
        .status-actif {
            color: #28a745;
            font-weight: bold;
        }
        .status-ferme {
            color: #dc3545;
            font-weight: bold;
        }
        .solde-positif {
            color: #28a745;
            font-weight: bold;
        }
        .solde-negatif {
            color: #dc3545;
            font-weight: bold;
        }
        .actions {
            white-space: nowrap;
        }
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }
        .empty-state i {
            font-size: 48px;
            margin-bottom: 20px;
            display: block;
        }
        .navigation {
            margin-bottom: 20px;
        }
        .navigation a {
            color: #2c5aa0;
            text-decoration: none;
            margin-right: 10px;
        }
        .navigation a:hover {
            text-decoration: underline;
        }
        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            .header-actions {
                flex-direction: column;
                align-items: stretch;
            }
            table {
                font-size: 12px;
            }
            th, td {
                padding: 8px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Navigation -->
        <div class="navigation">
            <a href="${pageContext.request.contextPath}/">🏠 Accueil</a> |
            <a href="${pageContext.request.contextPath}/client/liste">👥 Clients</a> |
            <a href="${pageContext.request.contextPath}/compte-courant/creer">➕ Créer un compte</a>
        </div>

        <h1>📋 Liste des Comptes Courants</h1>

        <!-- Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                ✅ ${success}
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ❌ ${error}
            </div>
        </c:if>

        <!-- Statistiques -->
        <div class="stats">
            <h3>📊 Statistiques</h3>
            <p><strong>Nombre total de comptes :</strong> ${nombreTotalComptes}</p>
            <c:if test="${not empty comptes}">
                <p><strong>Comptes affichés :</strong> ${comptes.size()}</p>
            </c:if>
            
            <!-- DEBUG INFO -->
            <div style="background-color: #fff3cd; padding: 10px; margin: 10px 0; border-radius: 5px; font-size: 12px;">
                <strong>🐛 Debug Info:</strong><br>
                - comptes variable: ${comptes != null ? 'NOT NULL' : 'NULL'}<br>
                - comptes.size(): ${comptes.size()}<br>
                - clientsMap variable: ${clientsMap != null ? 'NOT NULL' : 'NULL'}<br>
                - clientsMap.size(): ${clientsMap.size()}<br>
                - nombreTotalComptes: ${nombreTotalComptes}<br>
                - empty comptes: ${empty comptes}<br>
                - not empty comptes: ${not empty comptes}
            </div>
        </div>

        <!-- Actions en en-tête -->
        <div class="header-actions">
            <div>
                <a href="${pageContext.request.contextPath}/compte-courant/creer" class="btn btn-primary">
                    ➕ Créer un nouveau compte
                </a>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/compte-courant/liste" class="btn btn-info">
                    🔄 Actualiser
                </a>
            </div>
        </div>

        <!-- Table des comptes -->
        <div class="table-container">
            <c:choose>
                <c:when test="${empty comptes}">
                    <div class="empty-state">
                        <i>💳</i>
                        <h3>Aucun compte courant trouvé</h3>
                        <p>Il n'y a actuellement aucun compte courant dans le système.</p>
                        <a href="${pageContext.request.contextPath}/compte-courant/creer" class="btn btn-primary">
                            Créer le premier compte
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>🆔 ID</th>
                                <th>🔢 Numéro de Compte</th>
                                <th>👤 Client</th>
                                <th>💰 Solde</th>
                                <th>🏦 Découvert Autorisé</th>
                                <th>💳 Solde Disponible</th>
                                <th>📊 Statut</th>
                                <th>📅 Date de Création</th>
                                <th>⚙️ Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="compte" items="${comptes}" varStatus="status">
                                <!-- 🐛 Debug pour chaque compte -->
                                <%
                                    System.out.println("🐛 JSP Debug - Compte " + pageContext.getAttribute("status"));
                                    Object compte = pageContext.getAttribute("compte");
                                    if (compte != null) {
                                        System.out.println("   - Objet compte: " + compte.getClass().getName());
                                        System.out.println("   - toString(): " + compte.toString());
                                    } else {
                                        System.out.println("   - Objet compte: NULL");
                                    }
                                %>
                                <tr>
                                    <td>
                                        🐛 [${compte.getId()}]
                                    </td>
                                    <td>
                                        🐛 <strong>[${compte.getNumeroCompte()}]</strong>
                                    </td>
                                    <td>
                                        🐛 <c:set var="client" value="${clientsMap[compte.getClientId()]}" />
                                        Client ID: [${compte.getClientId()}]
                                        <c:choose>
                                            <c:when test="${not empty client}">
                                                <br><strong>${client.getNomComplet()}</strong>
                                                <br><small>ID: ${compte.getClientId()}</small>
                                            </c:when>
                                            <c:otherwise>
                                                <br><span style="color: #dc3545;">Client introuvable (ID: ${compte.getClientId()})</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        🐛 Solde: [${compte.getSolde()}]
                                        <c:choose>
                                            <c:when test="${compte.getSolde() >= 0}">
                                                <br><span class="solde-positif">
                                                    <fmt:formatNumber value="${compte.getSolde()}" type="currency" currencySymbol="€" />
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <br><span class="solde-negatif">
                                                    <fmt:formatNumber value="${compte.getSolde()}" type="currency" currencySymbol="€" />
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        🐛 Découvert: [${compte.getDecouvertAutorise()}]
                                        <br><fmt:formatNumber value="${compte.getDecouvertAutorise()}" type="currency" currencySymbol="€" />
                                    </td>
                                    <td>
                                        🐛 <c:set var="soldeDisponible" value="${compte.getSoldeDisponible()}" />
                                        Disponible: [${soldeDisponible}]
                                        <br><fmt:formatNumber value="${soldeDisponible}" type="currency" currencySymbol="€" />
                                    </td>
                                    <td>
                                        🐛 <c:choose>
                                            <c:when test="${compte.estEnDecouvert()}">
                                                <span class="solde-negatif">⚠️ En découvert</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-actif">✅ Normal</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        🐛 Date: [${compte.getDateCreation()}]
                                        <br><fmt:formatDate value="${compte.getDateCreation()}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td class="actions">
                                        <a href="${pageContext.request.contextPath}/compte-courant/details?id=${compte.getId()}" class="btn btn-info">
                                            👁️ Détails
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Footer -->
        <div style="margin-top: 30px; text-align: center; color: #6c757d; border-top: 1px solid #eee; padding-top: 20px;">
            <p>© 2025 Banque Centralisateur - Système de Gestion des Comptes Courants</p>
        </div>
    </div>

    <script>
        // Auto-actualisation toutes les 30 secondes (optionnel)
        // setTimeout(function() {
        //     window.location.reload();
        // }, 30000);

        // Confirmation pour les actions critiques
        function confirmerAction(action, detail) {
            return confirm('Êtes-vous sûr de vouloir ' + action + ' ' + detail + ' ?');
        }
    </script>
</body>
</html>