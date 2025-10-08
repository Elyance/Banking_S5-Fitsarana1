<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    .page-container {
        padding: 2rem;
        max-width: 1000px;
        margin: 0 auto;
    }

    .page-header {
        margin-bottom: 2rem;
        padding-bottom: 1rem;
        border-bottom: 2px solid var(--border-light);
    }

    .page-title {
        font-size: 2rem;
        font-weight: 700;
        color: var(--text-primary);
        margin-bottom: 0.5rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .page-subtitle {
        color: var(--text-secondary);
        font-size: 1rem;
    }

    .compte-info {
        background: var(--bg-white);
        border: 1px solid var(--border-light);
        border-left: 4px solid var(--primary-color);
        border-radius: var(--radius-lg);
        padding: 2rem;
        margin-bottom: 2rem;
        box-shadow: var(--shadow-sm);
    }

    .compte-info h3 {
        color: var(--text-primary);
        margin-bottom: 1.5rem;
        font-size: 1.25rem;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 1rem;
    }

    .info-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0.75rem 0;
        border-bottom: 1px solid var(--border-light);
    }

    .info-item:last-child {
        border-bottom: none;
    }

    .info-label {
        font-weight: 500;
        color: var(--text-secondary);
        font-size: 0.875rem;
    }

    .info-value {
        color: var(--text-primary);
        font-weight: 600;
        text-align: right;
    }

    .solde-positif {
        color: #059669;
    }

    .solde-negatif {
        color: var(--danger-color);
    }

    .form-section {
        background: var(--bg-white);
        border: 1px solid var(--border-light);
        border-radius: var(--radius-lg);
        padding: 2rem;
        margin-bottom: 2rem;
        box-shadow: var(--shadow-sm);
    }

    .form-section h3 {
        color: var(--text-primary);
        margin-bottom: 2rem;
        font-size: 1.25rem;
        font-weight: 600;
        text-align: center;
        border-bottom: 2px solid var(--primary-color);
        padding-bottom: 0.75rem;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
    }

    .form-group {
        margin-bottom: 2rem;
    }

    .form-group label {
        display: block;
        margin-bottom: 0.75rem;
        font-weight: 600;
        color: var(--text-primary);
        font-size: 1rem;
    }

    .form-group select,
    .form-group input,
    .form-group textarea {
        width: 100%;
        padding: 0.875rem 1rem;
        border: 2px solid var(--border-color);
        border-radius: var(--radius-sm);
        font-size: 1rem;
        transition: all var(--transition-fast);
        background: var(--bg-white);
        color: var(--text-primary);
    }

    .form-group select:focus,
    .form-group input:focus,
    .form-group textarea:focus {
        outline: none;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    }

    .form-group textarea {
        resize: vertical;
        min-height: 80px;
    }

    .type-operation {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;
    }

    .operation-option {
        position: relative;
    }

    .operation-option input[type="radio"] {
        position: absolute;
        opacity: 0;
        width: 0;
        height: 0;
    }

    .operation-option label {
        display: block;
        padding: 1.25rem;
        border: 2px solid var(--border-color);
        border-radius: var(--radius-md);
        text-align: center;
        cursor: pointer;
        transition: all var(--transition-fast);
        font-weight: 600;
        background: var(--bg-white);
        color: var(--text-primary);
    }

    .operation-option input[type="radio"]:checked + label {
        border-color: var(--primary-color);
        background: var(--bg-primary);
        color: var(--primary-color);
        box-shadow: var(--shadow-md);
    }

    .operation-option label:hover {
        border-color: var(--primary-color);
        background: var(--bg-primary);
        box-shadow: var(--shadow-sm);
    }

    .operation-option small {
        display: block;
        margin-top: 0.5rem;
        font-size: 0.75rem;
        opacity: 0.8;
        font-weight: 400;
    }

    .montant-info {
        background: var(--bg-info);
        padding: 1rem;
        border-radius: var(--radius-sm);
        margin-top: 0.75rem;
        border-left: 4px solid var(--info-color);
    }

    .montant-info small {
        color: var(--info-dark);
        font-weight: 500;
        font-size: 0.875rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .actions {
        display: flex;
        gap: 1rem;
        justify-content: center;
        margin-top: 2rem;
    }

    .btn {
        padding: 0.875rem 1.5rem;
        border: none;
        border-radius: var(--radius-sm);
        font-size: 1rem;
        font-weight: 600;
        cursor: pointer;
        transition: all var(--transition-fast);
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        min-width: 150px;
    }

    .btn-primary {
        background: var(--primary-color);
        color: white;
    }

    .btn-primary:hover {
        background: var(--primary-dark);
        transform: translateY(-2px);
        box-shadow: var(--shadow-lg);
        text-decoration: none;
        color: white;
    }

    .btn-secondary {
        background: var(--bg-light);
        color: var(--text-secondary);
        border: 1px solid var(--border-color);
    }

    .btn-secondary:hover {
        background: var(--bg-primary);
        color: var(--text-primary);
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
        text-decoration: none;
    }

    .alert {
        padding: 1rem;
        border-radius: var(--radius-sm);
        margin-bottom: 1.5rem;
        border: 1px solid transparent;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .alert-success {
        background: rgba(34, 197, 94, 0.1);
        border-color: rgba(34, 197, 94, 0.2);
        color: #059669;
    }

    .alert-danger {
        background: rgba(239, 68, 68, 0.1);
        border-color: rgba(239, 68, 68, 0.2);
        color: var(--danger-color);
    }

    .alert-warning {
        background: rgba(245, 158, 11, 0.1);
        border-color: rgba(245, 158, 11, 0.2);
        color: #d97706;
        margin: 1rem 0;
        padding: 1rem;
    }

    .alert-warning strong {
        font-weight: 600;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .page-container {
            padding: 1rem;
        }

        .type-operation {
            grid-template-columns: 1fr;
        }

        .actions {
            flex-direction: column;
        }

        .info-grid {
            grid-template-columns: 1fr;
        }

        .form-section {
            padding: 1.5rem;
        }

        .compte-info {
            padding: 1.5rem;
        }
    }
</style>

<div class="page-container">
    <!-- En-tête de page -->
    <div class="page-header">
        <h1 class="page-title">
            <i class="fas fa-exchange-alt"></i>
            Nouvelle Transaction
        </h1>
        <p class="page-subtitle">Dépôt ou retrait sur compte courant</p>
    </div>

    <!-- Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <strong>Succès :</strong> ${sessionScope.successMessage}
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-triangle"></i>
            <strong>Erreur :</strong> ${sessionScope.errorMessage}
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <i class="fas fa-times-circle"></i>
            <strong>Erreur :</strong> ${error}
        </div>
    </c:if>

    <c:if test="${not empty compte}">
        <!-- Informations du compte -->
        <div class="compte-info">
            <h3>
                <i class="fas fa-university"></i>
                Informations du Compte
            </h3>
            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">
                        <i class="fas fa-hashtag"></i>
                        Numéro de compte
                    </span>
                    <span class="info-value"><strong>${compte.numeroCompte}</strong></span>
                </div>
                <div class="info-item">
                    <span class="info-label">
                        <i class="fas fa-user"></i>
                        Titulaire
                    </span>
                    <span class="info-value">${compte.nomComplet}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">
                        <i class="fas fa-euro-sign"></i>
                        Solde actuel
                    </span>
                    <span class="info-value ${compte.classeSolde}">
                        <fmt:formatNumber value="${compte.solde}" type="currency" currencySymbol="€"/>
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">
                        <i class="fas fa-wallet"></i>
                        Solde disponible
                    </span>
                    <span class="info-value">
                        <fmt:formatNumber value="${compte.soldeDisponible}" type="currency" currencySymbol="€"/>
                    </span>
                </div>
            </div>
        </div>

        <!-- Formulaire de transaction -->
        <form method="post" action="${pageContext.request.contextPath}/compte-courant/transaction" 
              onsubmit="return validerFormulaire()">

            <input type="hidden" name="compteId" value="${compte.compteId}">

            <div class="form-section">
                <h3>
                    <i class="fas fa-edit"></i>
                    Détails de la Transaction
                </h3>

                <!-- Type d'opération -->
                <div class="form-group">
                    <label>Type d'opération :</label>
                    <div class="type-operation">
                        <div class="operation-option">
                            <input type="radio" id="depot" name="typeOperation" value="1" checked>
                            <label for="depot">
                                <i class="fas fa-plus-circle" style="font-size: 1.5rem; color: #059669; margin-bottom: 0.5rem;"></i><br>
                                <strong>Dépôt</strong>
                                <small>Ajouter de l'argent</small>
                            </label>
                        </div>
                        <div class="operation-option">
                            <input type="radio" id="retrait" name="typeOperation" value="2">
                            <label for="retrait">
                                <i class="fas fa-minus-circle" style="font-size: 1.5rem; color: #ef4444; margin-bottom: 0.5rem;"></i><br>
                                <strong>Retrait</strong>
                                <small>Prélever de l'argent</small>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Montant -->
                <div class="form-group">
                    <label for="montant">
                        <i class="fas fa-euro-sign"></i>
                        Montant (€) :
                    </label>
                    <input type="number" id="montant" name="montant" 
                           step="0.01" min="0.01" max="999999.99" 
                           placeholder="Ex: 150.50" required>
                    <div class="montant-info">
                        <small>
                            <i class="fas fa-info-circle"></i>
                            Le montant doit être positif et ne peut pas dépasser 999 999,99 €
                        </small>
                    </div>
                </div>

                <!-- Description -->
                <div class="form-group">
                    <label for="description">
                        <i class="fas fa-comment"></i>
                        Description :
                    </label>
                    <textarea id="description" name="description" 
                            placeholder="Décrivez brièvement la transaction (optionnel)"></textarea>
                </div>

                <c:if test="${compte.enDecouvert}">
                    <div class="alert-warning">
                        <strong>
                            <i class="fas fa-exclamation-triangle"></i>
                            Attention :
                        </strong> 
                        Ce compte est actuellement en découvert. 
                        Vérifiez le montant autorisé avant d'effectuer un retrait.
                    </div>
                </c:if>
            </div>

            <div class="actions">
                <a href="${pageContext.request.contextPath}/compte-courant/detail?id=${compte.compteId}" 
                   class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i>
                    Annuler
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-check"></i>
                    Exécuter la transaction
                </button>
            </div>
        </form>
    </c:if>

    <c:if test="${empty compte && empty error}">
        <div class="alert alert-danger">
            <i class="fas fa-times-circle"></i>
            <strong>Compte introuvable</strong><br>
            Les informations du compte ne sont pas disponibles.
        </div>
        <div class="actions">
            <a href="${pageContext.request.contextPath}/compte-courant/liste" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i>
                Retour à la liste
            </a>
        </div>
    </c:if>
</div>

<script>
    function validerFormulaire() {
        const montant = document.getElementById('montant').value;
        const typeOperation = document.querySelector('input[name="typeOperation"]:checked').value;

        // Validation du montant
        if (!montant || parseFloat(montant) <= 0) {
            alert('⚠️ Veuillez saisir un montant positif');
            return false;
        }

        // Confirmation pour les gros montants
        if (parseFloat(montant) > 10000) {
            const confirmation = confirm(
                'Transaction importante détectée !\n\n' +
                'Montant : ' + montant + ' €\n' +
                'Type : ' + (typeOperation === '1' ? 'Dépôt' : 'Retrait') + '\n\n' +
                'Confirmez-vous cette transaction ?'
            );
            if (!confirmation) {
                return false;
            }
        }

        // Confirmation pour les retraits
        if (typeOperation === '2') {
            const confirmation = confirm(
                'Confirmer le retrait ?\n\n' +
                'Montant à retirer : ' + montant + ' €\n\n' +
                'Cette opération sera immédiatement appliquée au compte.'
            );
            if (!confirmation) {
                return false;
            }
        }

        return true;
    }

    // Mettre à jour l'affichage selon le type d'opération sélectionné
    document.querySelectorAll('input[name="typeOperation"]').forEach(radio => {
        radio.addEventListener('change', function() {
            const montantInput = document.getElementById('montant');
            const descriptionInput = document.getElementById('description');

            if (this.value === '1') {
                // Dépôt
                montantInput.placeholder = 'Montant à déposer (ex: 150.50)';
                if (!descriptionInput.value) {
                    descriptionInput.placeholder = 'Ex: Dépôt espèces, Virement reçu...';
                }
            } else {
                // Retrait
                montantInput.placeholder = 'Montant à retirer (ex: 100.00)';
                if (!descriptionInput.value) {
                    descriptionInput.placeholder = 'Ex: Retrait DAB, Chèque émis...';
                }
            }
        });
    });
</script>