<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste Simple des Comptes</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .error { color: red; background: #ffe6e6; padding: 10px; border: 1px solid red; }
    </style>
</head>
<body>
    <h1>Liste des Comptes Courants</h1>
    
    <c:if test="${not empty error}">
        <div class="error">
            Erreur: ${error}
        </div>
    </c:if>
    
    <c:choose>
        <c:when test="${empty comptes}">
            <p>Aucun compte trouvé dans la base de données.</p>
        </c:when>
        <c:otherwise>
            <p>Nombre de comptes trouvés : ${comptes.size()}</p>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Numéro de Compte</th>
                        <th>ID Client</th>
                        <th>Solde</th>
                        <th>Découvert Autorisé</th>
                        <th>Date Création</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="compte" items="${comptes}">
                        <tr>
                            <td>${compte.id}</td>
                            <td>${compte.numeroCompte}</td>
                            <td>${compte.clientId}</td>
                            <td>${compte.solde} €</td>
                            <td>${compte.decouvertAutorise} €</td>
                            <td>${compte.dateCreation}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    
    <br>
    <a href="${pageContext.request.contextPath}/">Retour à l'accueil</a>
</body>
</html>