<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste des Comptes de Prêt</title>
</head>
<body>
    
    <div class="container mt-4">
        <h2>Liste des Comptes de Prêt</h2>
        
        <c:if test="${not empty message}">
            <div class="alert alert-${messageType}">${message}</div>
        </c:if>
        
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>Numéro de Compte</th>
                        <th>Client ID</th>
                        <th>Montant Emprunté</th>
                        <th>Taux d'Intérêt</th>
                        <th>Durée (Mois)</th>
                        <th>Type de Paiement</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${comptesPret}" var="compte">
                        <tr>
                            <td>${compte.numeroCompte}</td>
                            <td>${compte.clientId}</td>
                            <td><fmt:formatNumber value="${compte.montantEmprunte}" type="currency" currencySymbol="Ar" /></td>
                            <td><fmt:formatNumber value="${compte.tauxInteret}" type="percent" maxFractionDigits="2"/></td>
                            <td>${compte.dureeEnMois}</td>
                            <td>${compte.typePaiement.libelle}</td>
                            <td>${compte.statutCourant.libelle}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/compte-pret/details?id=${compte.id}" 
                                   class="btn btn-info btn-sm">
                                    Détails
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <c:if test="${empty comptesPret}">
            <div class="alert alert-info">Aucun compte de prêt trouvé.</div>
        </c:if>
        
        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/compte-pret/creer" class="btn btn-primary">
                Créer un nouveau compte de prêt
            </a>
        </div>
    </div>
</body>
</html>