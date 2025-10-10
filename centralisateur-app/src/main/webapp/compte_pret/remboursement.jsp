<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="page-container" style="max-width: 600px; margin: 2rem auto;">
    <div class="page-header">
        <h1 class="page-title">
            <i class="fas fa-money-bill-wave"></i>
            Effectuer un remboursement de prêt
        </h1>
        <p class="page-subtitle">Saisissez le montant à rembourser pour ce compte de prêt</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-triangle"></i> ${error}
        </div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i> ${message}
        </div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/compte-pret/remboursement">
        <input type="hidden" name="compteId" value="${compte.compteId}" />
        <div class="mb-3">
            <label for="montant" class="form-label">Montant à rembourser <span style="color:red">*</span></label>
            <input type="number" step="0.01" min="0.01" max="${compte.soldeRestantDu}" class="form-control" id="montant" name="montant" required placeholder="Ex: 10000" />
            <div class="form-text">Solde restant dû : <fmt:formatNumber value="${compte.soldeRestantDu}" type="currency" currencySymbol="Ar" maxFractionDigits="0"/></div>
        </div>
        <div class="mb-3">
            <label for="commentaire" class="form-label">Commentaire (optionnel)</label>
            <textarea class="form-control" id="commentaire" name="commentaire" rows="2" placeholder="Ex: Paiement partiel, avance, ..."></textarea>
        </div>
        <button type="submit" class="btn btn-success">
            <i class="fas fa-paper-plane"></i> Valider le remboursement
        </button>
        <a href="${pageContext.request.contextPath}/compte-pret/details?id=${compte.compteId}" class="btn btn-secondary">Annuler</a>
    </form>
</div>

<style>
.page-container { background: #fff; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.07); padding: 2rem; }
.page-header { margin-bottom: 2rem; }
.page-title { font-size: 1.5rem; font-weight: 700; color: var(--primary-color); }
.page-subtitle { color: var(--text-secondary); font-size: 1rem; }
.btn { margin-right: 0.5rem; }
</style>
