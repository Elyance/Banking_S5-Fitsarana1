<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction - Banque Centralisateur</title>
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
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #FF9800, #F57C00);
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
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #FF9800;
            margin-bottom: 30px;
        }
        
        .compte-info h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 1.2em;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        
        .info-label {
            font-weight: 600;
            color: #555;
        }
        
        .info-value {
            color: #333;
            font-weight: 500;
        }
        
        .solde-positif {
            color: #4CAF50;
            font-weight: bold;
        }
        
        .solde-negatif {
            color: #f44336;
            font-weight: bold;
        }
        
        .form-section {
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 30px;
            margin-bottom: 20px;
        }
        
        .form-section h3 {
            color: #333;
            margin-bottom: 25px;
            font-size: 1.3em;
            text-align: center;
            border-bottom: 2px solid #FF9800;
            padding-bottom: 10px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 1.1em;
        }
        
        .form-group select,
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s ease;
        }
        
        .form-group select:focus,
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #FF9800;
            box-shadow: 0 0 0 3px rgba(255, 152, 0, 0.1);
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .type-operation {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        
        .operation-option {
            position: relative;
        }
        
        .operation-option input[type="radio"] {
            position: absolute;
            opacity: 0;
        }
        
        .operation-option label {
            display: block;
            padding: 15px;
            border: 2px solid #ddd;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
        }
        
        .operation-option input[type="radio"]:checked + label {
            border-color: #FF9800;
            background: #fff3e0;
            color: #F57C00;
        }
        
        .operation-option label:hover {
            border-color: #FF9800;
            background: #fafafa;
        }
        
        .montant-info {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 8px;
            margin-top: 10px;
            border-left: 4px solid #2196F3;
        }
        
        .montant-info small {
            color: #1565C0;
            font-weight: 500;
        }
        
        .actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            min-width: 150px;
        }
        
        .btn-primary {
            background: #FF9800;
            color: white;
        }
        
        .btn-primary:hover {
            background: #F57C00;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 152, 0, 0.3);
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
        
        .error, .success {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .error {
            background: #ffebee;
            color: #c62828;
            border-left: 4px solid #f44336;
        }
        
        .success {
            background: #e8f5e8;
            color: #2e7d32;
            border-left: 4px solid #4caf50;
        }
        
        .warning {
            background: #fff3e0;
            color: #f57c00;
            padding: 15px;
            border-radius: 8px;
            margin: 15px 0;
            border-left: 4px solid #ff9800;
        }
        
        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 10px;
            }
            
            .content {
                padding: 20px;
            }
            
            .type-operation {
                grid-template-columns: 1fr;
            }
            
            .actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>💰 Nouvelle Transaction</h1>
            <div class="subtitle">Dépôt ou Retrait sur compte courant</div>
        </div>
        
        <div class="content">
            <!-- Messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="success">
                    <strong>✅ Succès :</strong> ${sessionScope.successMessage}
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="error">
                    <strong>❌ Erreur :</strong> ${sessionScope.errorMessage}
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="error">
                    <strong>Erreur :</strong> ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty compte}">
                <!-- Informations du compte -->
                <div class="compte-info">
                    <h3>📊 Informations du Compte</h3>
                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-label">Numéro de compte :</span>
                            <span class="info-value"><strong>${compte.numeroCompte}</strong></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Titulaire :</span>
                            <span class="info-value">${compte.nomComplet}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Solde actuel :</span>
                            <span class="info-value ${compte.classeSolde}">
                                <fmt:formatNumber value="${compte.solde}" type="currency" currencySymbol="€"/>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Solde disponible :</span>
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
                        <h3>🔄 Détails de la Transaction</h3>
                        
                        <!-- Type d'opération -->
                        <div class="form-group">
                            <label>Type d'opération :</label>
                            <div class="type-operation">
                                <div class="operation-option">
                                    <input type="radio" id="depot" name="typeOperation" value="1" checked>
                                    <label for="depot">
                                        💵 Dépôt<br>
                                        <small>Ajouter de l'argent</small>
                                    </label>
                                </div>
                                <div class="operation-option">
                                    <input type="radio" id="retrait" name="typeOperation" value="2">
                                    <label for="retrait">
                                        💸 Retrait<br>
                                        <small>Prélever de l'argent</small>
                                    </label>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Montant -->
                        <div class="form-group">
                            <label for="montant">Montant (€) :</label>
                            <input type="number" id="montant" name="montant" 
                                   step="0.01" min="0.01" max="999999.99" 
                                   placeholder="Ex: 150.50" required>
                            <div class="montant-info">
                                <small>💡 Le montant doit être positif et ne peut pas dépasser 999 999,99 €</small>
                            </div>
                        </div>
                        
                        <!-- Description -->
                        <div class="form-group">
                            <label for="description">Description :</label>
                            <textarea id="description" name="description" 
                                    placeholder="Décrivez brièvement la transaction (optionnel)"></textarea>
                        </div>
                        
                        <c:if test="${compte.enDecouvert}">
                            <div class="warning">
                                <strong>⚠️ Attention :</strong> Ce compte est actuellement en découvert. 
                                Vérifiez le montant autorisé avant d'effectuer un retrait.
                            </div>
                        </c:if>
                    </div>
                    
                    <div class="actions">
                        <a href="${pageContext.request.contextPath}/compte-courant/detail?id=${compte.compteId}" 
                           class="btn btn-secondary">
                            ← Annuler
                        </a>
                        <button type="submit" class="btn btn-primary">
                            ✅ Exécuter la transaction
                        </button>
                    </div>
                </form>
            </c:if>
            
            <c:if test="${empty compte && empty error}">
                <div class="error">
                    <strong>Compte introuvable</strong><br>
                    Les informations du compte ne sont pas disponibles.
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
</body>
</html>