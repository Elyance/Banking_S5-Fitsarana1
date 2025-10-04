<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Création de Compte Courant - Banque Centralisateur</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">
                            <i class="fas fa-university me-2"></i>
                            Création de Compte Courant
                        </h4>
                    </div>
                    <div class="card-body">
                        <!-- Messages d'erreur -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <strong>Erreur :</strong> ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Messages de succès -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                <strong>Succès :</strong> ${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form method="post" action="${pageContext.request.contextPath}/compte-courant/creer" class="needs-validation" novalidate>
                            <!-- Sélection du client -->
                            <div class="mb-3">
                                <label for="clientId" class="form-label">
                                    <i class="fas fa-user me-1"></i>
                                    Client <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="clientId" name="clientId" required>
                                    <option value="">-- Sélectionner un client --</option>
                                    <c:forEach var="client" items="${clients}">
                                        <option value="${client.id}" 
                                                ${param.clientId == client.id ? 'selected' : ''}>
                                            ${client.nomComplet} - ${client.email}
                                            <c:if test="${not empty client.numeroClient}">
                                                (N° ${client.numeroClient})
                                            </c:if>
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    Veuillez sélectionner un client.
                                </div>
                            </div>

                            <!-- Numéro de compte -->
                            <div class="mb-3">
                                <label for="numeroCompte" class="form-label">
                                    <i class="fas fa-hashtag me-1"></i>
                                    Numéro de compte <span class="text-danger">*</span>
                                </label>
                                <input type="text" 
                                       class="form-control" 
                                       id="numeroCompte" 
                                       name="numeroCompte" 
                                       value="${param.numeroCompte}"
                                       placeholder="Ex: CC001234567890"
                                       pattern="[A-Za-z0-9]{10,20}"
                                       required>
                                <div class="form-text">
                                    Le numéro de compte doit contenir entre 10 et 20 caractères alphanumériques.
                                </div>
                                <div class="invalid-feedback">
                                    Veuillez saisir un numéro de compte valide (10-20 caractères alphanumériques).
                                </div>
                            </div>

                            <!-- Découvert autorisé -->
                            <div class="mb-3">
                                <label for="decouvertAutorise" class="form-label">
                                    <i class="fas fa-coins me-1"></i>
                                    Découvert autorisé (€)
                                </label>
                                <input type="number" 
                                       class="form-control" 
                                       id="decouvertAutorise" 
                                       name="decouvertAutorise" 
                                       value="${param.decouvertAutorise != null ? param.decouvertAutorise : '0.00'}"
                                       step="0.01" 
                                       min="0" 
                                       max="10000"
                                       placeholder="0.00">
                                <div class="form-text">
                                    Montant maximum autorisé en découvert (optionnel, par défaut : 0€).
                                </div>
                                <div class="invalid-feedback">
                                    Le découvert autorisé doit être entre 0 et 10 000€.
                                </div>
                            </div>

                            <!-- Informations affichées -->
                            <div class="mb-4">
                                <div class="card bg-light">
                                    <div class="card-body py-2">
                                        <h6 class="card-title mb-2">
                                            <i class="fas fa-info-circle me-1"></i>
                                            Informations importantes
                                        </h6>
                                        <ul class="mb-0 small">
                                            <li>Le solde initial du compte sera de 0,00€</li>
                                            <li>Le compte sera créé avec le statut "ACTIF"</li>
                                            <li>Un client ne peut avoir qu'un seul compte courant</li>
                                            <li>Le numéro de compte doit être unique dans le système</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Boutons d'action -->
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="${pageContext.request.contextPath}/client/list" 
                                   class="btn btn-secondary me-md-2">
                                    <i class="fas fa-arrow-left me-1"></i>
                                    Retour aux clients
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-1"></i>
                                    Créer le compte
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Affichage du compte créé (si succès) -->
                <c:if test="${not empty compteCreé}">
                    <div class="card shadow mt-4">
                        <div class="card-header bg-success text-white">
                            <h5 class="mb-0">
                                <i class="fas fa-check-circle me-2"></i>
                                Compte créé avec succès
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <strong>Numéro de compte :</strong> ${compteCreé.numeroCompte}
                                </div>
                                <div class="col-md-6">
                                    <strong>Client ID :</strong> ${compteCreé.clientId}
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col-md-6">
                                    <strong>Solde initial :</strong> 
                                    <fmt:formatNumber value="${compteCreé.solde}" type="currency" currencySymbol="€"/>
                                </div>
                                <div class="col-md-6">
                                    <strong>Découvert autorisé :</strong> 
                                    <fmt:formatNumber value="${compteCreé.decouvertAutorise}" type="currency" currencySymbol="€"/>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col-12">
                                    <strong>Date de création :</strong> 
                                    <fmt:formatDate value="${compteCreé.dateCreation}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                </div>
                            </div>
                            <div class="mt-3">
                                <a href="${pageContext.request.contextPath}/compte-courant/details?id=${compteCreé.id}" 
                                   class="btn btn-info">
                                    <i class="fas fa-eye me-1"></i>
                                    Voir les détails du compte
                                </a>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Validation Bootstrap
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByClassName('needs-validation');
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();

        // Auto-génération du numéro de compte
        document.getElementById('clientId').addEventListener('change', function() {
            const numeroCompteInput = document.getElementById('numeroCompte');
            if (this.value && !numeroCompteInput.value) {
                const timestamp = Date.now().toString().slice(-6);
                const clientId = this.value.padStart(4, '0');
                numeroCompteInput.value = 'CC' + clientId + timestamp;
            }
        });
    </script>
</body>
</html>