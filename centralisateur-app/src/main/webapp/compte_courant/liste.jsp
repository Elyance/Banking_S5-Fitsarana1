<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Comptes Courants - Banking S5</title>
</head>
<body>
    <header>
        <h1>🏦 Gestion des Comptes Courants</h1>
        <nav>
            <a href="${pageContext.request.contextPath}/">🏠 Accueil</a> |
            <a href="${pageContext.request.contextPath}/clients">👥 Clients</a> |
            <a href="${pageContext.request.contextPath}/compte-courant/creer">➕ Nouveau Compte</a>
        </nav>
    </header>

    <main>
        <!-- Messages d'état -->
        <c:if test="${not empty success}">
            <div class="alert-success">
                ✅ ${success}
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert-error">
                ❌ ${error}
            </div>
        </c:if>

        <!-- Informations générales -->
        <section>
            <h2>📊 Tableau de Bord</h2>
            <div>
                <p><strong>Nombre total de comptes :</strong> ${nombreComptes}</p>
                <p><strong>Source des données :</strong> ${sourceData}</p>
                <p><strong>Dernière mise à jour :</strong> <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm:ss" /></p>
            </div>
        </section>

        <!-- Actions rapides -->
        <section>
            <h3>⚡ Actions Rapides</h3>
            <a href="${pageContext.request.contextPath}/compte-courant/creer">➕ Créer un nouveau compte</a> |
            <a href="${pageContext.request.contextPath}/compte_courant/transaction">💰 Effectuer une transaction</a> |
            <a href="javascript:window.location.reload()">🔄 Actualiser la liste</a>
        </section>

        <!-- Liste des comptes -->
        <section>
            <h3>📋 Liste des Comptes Courants</h3>
            
            <!-- Messages de succès et d'erreur -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div style="background: #d4edda; color: #155724; padding: 15px; border-radius: 8px; margin: 15px 0; border-left: 4px solid #28a745;">
                    <strong>✅ Succès :</strong> ${sessionScope.successMessage}
                </div>
                <%-- Supprimer le message après affichage --%>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            
            <c:if test="${not empty sessionScope.errorMessage}">
                <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin: 15px 0; border-left: 4px solid #dc3545;">
                    <strong>❌ Erreur :</strong> ${sessionScope.errorMessage}
                </div>
                <%-- Supprimer le message après affichage --%>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>
            
            <c:choose>
                <c:when test="${empty comptes}">
                    <div class="empty-state">
                        <h4>Aucun compte courant trouvé</h4>
                        <p>Il n'y a actuellement aucun compte courant dans le système.</p>
                        <a href="${pageContext.request.contextPath}/compte-courant/creer">Créer le premier compte</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <table border="1" cellpadding="8" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>N° Compte</th>
                                <th>Client</th>
                                <th>Email</th>
                                <th>Solde Actuel</th>
                                <th>Découvert Autorisé</th>
                                <th>Solde Disponible</th>
                                <th>Statut</th>
                                <th>Date Ouverture</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="compte" items="${comptes}" varStatus="status">
                                <tr>
                                    <!-- Numéro de compte -->
                                    <td>
                                        <strong>${compte.numeroCompte}</strong>
                                        <br><small>ID: ${compte.compteId}</small>
                                    </td>
                                    
                                    <!-- Client -->
                                    <td>
                                        <strong>${compte.nomComplet}</strong>
                                        <br><small>ID Client: ${compte.clientId}</small>
                                    </td>
                                    
                                    <!-- Email -->
                                    <td>${compte.emailClient}</td>
                                    
                                    <!-- Solde -->
                                    <td class="${compte.classeSolde}">
                                        <c:choose>
                                            <c:when test="${compte.enDecouvert}">
                                                <span style="color: red;">
                                                    <fmt:formatNumber value="${compte.solde}" type="currency" currencySymbol="€" />
                                                    <br><small>⚠️ En découvert</small>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: green;">
                                                    <fmt:formatNumber value="${compte.solde}" type="currency" currencySymbol="€" />
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <!-- Découvert autorisé -->
                                    <td>
                                        <fmt:formatNumber value="${compte.decouvertAutorise}" type="currency" currencySymbol="€" />
                                    </td>
                                    
                                    <!-- Solde disponible -->
                                    <td>
                                        <strong>
                                            <fmt:formatNumber value="${compte.soldeDisponible}" type="currency" currencySymbol="€" />
                                        </strong>
                                    </td>
                                    
                                    <!-- Statut -->
                                    <td class="${compte.classeStatut}">
                                        <c:choose>
                                            <c:when test="${compte.statutCompte == 'ACTIF'}">
                                                <span style="color: green;">✅ ${compte.statutCompte}</span>
                                            </c:when>
                                            <c:when test="${compte.statutCompte == 'SUSPENDU'}">
                                                <span style="color: orange;">⏸️ ${compte.statutCompte}</span>
                                            </c:when>
                                            <c:when test="${compte.statutCompte == 'FERME'}">
                                                <span style="color: red;">❌ ${compte.statutCompte}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: gray;">❓ ${compte.statutCompte}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <!-- Date ouverture -->
                                    <td>
                                        ${compte.dateCreationFormatee}
                                    </td>
                                    
                                    <!-- Actions -->
                                    <td>
                                        <a href="${pageContext.request.contextPath}/compte-courant/transaction?compteId=${compte.compteId}">💰 Transaction</a>
                                        <br>
                                        <a href="${pageContext.request.contextPath}/compte-courant/transactions?compteId=${compte.compteId}">📊 Historique</a>
                                        <br>
                                        <a href="${pageContext.request.contextPath}/compte-courant/detail?id=${compte.compteId}">👁️ Détails</a>
                                        <br>
                                        <a href="${pageContext.request.contextPath}/clients?action=details&id=${compte.clientId}">👤 Client</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- Statistiques résumées -->
        <section>
            <h3>📈 Résumé</h3>
            <c:if test="${not empty comptes}">
                <c:set var="totalSoldes" value="0" />
                <c:set var="comptesEnDecouvert" value="0" />
                <c:forEach var="compte" items="${comptes}">
                    <c:set var="totalSoldes" value="${totalSoldes + compte.solde}" />
                    <c:if test="${compte.enDecouvert}">
                        <c:set var="comptesEnDecouvert" value="${comptesEnDecouvert + 1}" />
                    </c:if>
                </c:forEach>
                <p><strong>Total des soldes :</strong> <fmt:formatNumber value="${totalSoldes}" type="currency" currencySymbol="€" /></p>
                <p><strong>Comptes en découvert :</strong> ${comptesEnDecouvert} / ${nombreComptes}</p>
            </c:if>
        </section>
    </main>

    <footer>
        <hr>
        <p><em>Banking S5 - Système de Gestion Bancaire - ${sourceData}</em></p>
    </footer>
</body>
</html>