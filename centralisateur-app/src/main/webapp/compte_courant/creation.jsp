<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    .form-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 2rem;
    }

    .form-card {
        background: var(--bg-white);
        border-radius: var(--radius-lg);
        padding: 2rem;
        box-shadow: var(--shadow-md);
        border: 1px solid var(--border-light);
    }

    .form-header {
        text-align: center;
        margin-bottom: 2rem;
        padding-bottom: 1rem;
        border-bottom: 2px solid var(--border-light);
    }

    .form-title {
        font-size: 2rem;
        font-weight: 700;
        color: var(--text-primary);
        margin-bottom: 0.5rem;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.75rem;
    }

    .form-subtitle {
        color: var(--text-secondary);
        font-size: 1rem;
    }

    .form-section {
        margin-bottom: 2rem;
    }

    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;
        margin-bottom: 1rem;
    }

    .form-group {
        display: flex;
        flex-direction: column;
        margin-bottom: 1rem;
    }

    .form-group.full-width {
        grid-column: span 2;
    }

    .form-label {
        font-weight: 500;
        color: var(--text-secondary);
        margin-bottom: 0.5rem;
        font-size: 0.875rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .form-label.required::after {
        content: ' *';
        color: var(--danger-color);
    }

    .form-control {
        padding: 0.75rem;
        border: 2px solid var(--border-color);
        border-radius: var(--radius-sm);
        font-size: 0.875rem;
        transition: all var(--transition-fast);
        background: var(--bg-white);
    }

    .form-control:focus {
        outline: none;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    }

    .form-control.error {
        border-color: var(--danger-color);
    }

    .form-text {
        font-size: 0.75rem;
        color: var(--text-muted);
        margin-top: 0.25rem;
    }

    .invalid-feedback {
        font-size: 0.75rem;
        color: var(--danger-color);
        margin-top: 0.25rem;
        display: none;
    }

    .was-validated .form-control:invalid ~ .invalid-feedback {
        display: block;
    }

    .info-card {
        background: linear-gradient(135deg, var(--bg-primary), var(--bg-light));
        border: 1px solid var(--border-light);
        border-radius: var(--radius-md);
        padding: 1.5rem;
        margin-bottom: 2rem;
    }

    .info-card h6 {
        color: var(--text-primary);
        font-weight: 600;
        margin-bottom: 1rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .info-card ul {
        margin: 0;
        padding-left: 1.5rem;
    }

    .info-card li {
        color: var(--text-secondary);
        margin-bottom: 0.5rem;
        font-size: 0.875rem;
    }

    .form-actions {
        display: flex;
        justify-content: flex-end;
        gap: 1rem;
        margin-top: 2rem;
        padding-top: 1rem;
        border-top: 1px solid var(--border-light);
    }

    .btn {
        padding: 0.75rem 1.5rem;
        border-radius: var(--radius-sm);
        font-weight: 500;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        transition: all var(--transition-fast);
        border: none;
        cursor: pointer;
        font-size: 0.875rem;
    }

    .btn-primary {
        background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
        color: white;
    }

    .btn-primary:hover {
        background: linear-gradient(135deg, var(--primary-dark), #1e40af);
        transform: translateY(-1px);
        box-shadow: var(--shadow-md);
        color: white;
        text-decoration: none;
    }

    .btn-secondary {
        background: var(--bg-light);
        color: var(--text-secondary);
        border: 1px solid var(--border-color);
    }

    .btn-secondary:hover {
        background: var(--bg-primary);
        color: var(--text-primary);
        text-decoration: none;
    }

    .alert {
        padding: 1rem;
        border-radius: var(--radius-sm);
        margin-bottom: 1rem;
        border: 1px solid transparent;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .alert-danger {
        background: rgba(239, 68, 68, 0.1);
        border-color: rgba(239, 68, 68, 0.2);
        color: var(--danger-color);
    }

    .alert-success {
        background: rgba(34, 197, 94, 0.1);
        border-color: rgba(34, 197, 94, 0.2);
        color: #059669;
    }

    .btn-close {
        background: none;
        border: none;
        font-size: 1.5rem;
        cursor: pointer;
        opacity: 0.5;
        margin-left: auto;
    }

    .btn-close:hover {
        opacity: 1;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .form-container {
            padding: 1rem;
        }

        .form-card {
            padding: 1.5rem;
        }

        .form-row {
            grid-template-columns: 1fr;
        }

        .form-actions {
            flex-direction: column;
        }

        .btn {
            justify-content: center;
        }
    }
</style>

<div class="form-container">
    <div class="form-card">
        <div class="form-header">
            <h2 class="form-title">
                <i class="fas fa-university"></i>
                Création de Compte Courant
            </h2>
            <p class="form-subtitle">Nouveau compte de dépôt avec découvert autorisé</p>
        </div>

        <!-- Messages d'erreur -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle"></i>
                <strong>Erreur :</strong> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close">&times;</button>
            </div>
        </c:if>

        <!-- Messages de succès -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle"></i>
                <strong>Succès :</strong> ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close">&times;</button>
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/compte-courant/creer" class="needs-validation" novalidate>
            <!-- Sélection du client -->
            <div class="form-group full-width">
                <label for="clientId" class="form-label required">
                    <i class="fas fa-user"></i>
                    Client
                </label>
                <select class="form-control" id="clientId" name="clientId" required>
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

            <div class="form-row">
                <!-- Numéro de compte -->
                <div class="form-group">
                    <label for="numeroCompte" class="form-label required">
                        <i class="fas fa-hashtag"></i>
                        Numéro de compte
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
                        Entre 10 et 20 caractères alphanumériques
                    </div>
                    <div class="invalid-feedback">
                        Veuillez saisir un numéro de compte valide.
                    </div>
                </div>

                <!-- Découvert autorisé -->
                <div class="form-group">
                    <label for="decouvertAutorise" class="form-label">
                        <i class="fas fa-coins"></i>
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
                        Montant maximum en découvert (optionnel)
                    </div>
                    <div class="invalid-feedback">
                        Le découvert doit être entre 0 et 10 000€.
                    </div>
                </div>
            </div>

            <!-- Informations importantes -->
            <div class="info-card">
                <h6>
                    <i class="fas fa-info-circle"></i>
                    Informations importantes
                </h6>
                <ul>
                    <li>Le solde initial du compte sera de 0,00€</li>
                    <li>Le compte sera créé avec le statut "ACTIF"</li>
                    <li>Un client ne peut avoir qu'un seul compte courant</li>
                    <li>Le numéro de compte doit être unique dans le système</li>
                </ul>
            </div>

            <!-- Boutons d'action -->
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/clients/list" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i>
                    Retour aux clients
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i>
                    Créer le compte
                </button>
            </div>
        </form>
    </div>
</div>

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