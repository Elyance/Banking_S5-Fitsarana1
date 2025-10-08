<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.centralisateur.entity.Client" %>
<%@ page import="com.banque.dto.TypePaiementDTO" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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

    .section-title {
        font-size: 1.1rem;
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: 1rem;
        padding-bottom: 0.5rem;
        border-bottom: 1px solid var(--border-light);
        display: flex;
        align-items: center;
        gap: 0.5rem;
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

    .form-help {
        font-size: 0.75rem;
        color: var(--text-muted);
        margin-top: 0.25rem;
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

    .info-card-content {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1rem;
    }

    .info-item {
        background: rgba(255, 255, 255, 0.5);
        padding: 1rem;
        border-radius: var(--radius-sm);
        text-align: center;
    }

    .info-item-value {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--primary-color);
        margin-bottom: 0.25rem;
    }

    .info-item-label {
        font-size: 0.75rem;
        color: var(--text-secondary);
        text-transform: uppercase;
        letter-spacing: 0.5px;
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

        .info-card-content {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="form-container">
    <div class="form-card">
        <div class="form-header">
            <h2 class="form-title">
                <i class="fas fa-hand-holding-usd"></i>
                Création de Compte Prêt
            </h2>
            <p class="form-subtitle">Formulaire de demande de prêt bancaire</p>
        </div>

        <%-- Messages d'erreur --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i>
                <strong>Erreur :</strong> <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <%-- Messages de succès --%>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <strong>Succès :</strong> <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/compte-pret/creer">
            <!-- Section Client -->
            <div class="form-section">
                <h5 class="section-title">
                    <i class="fas fa-user"></i>
                    Informations Client
                </h5>
                
                <div class="form-group full-width">
                    <label class="form-label required" for="clientId">
                        <i class="fas fa-user"></i>
                        Client
                    </label>
                    <select class="form-control" id="clientId" name="clientId" required>
                        <option value="">-- Sélectionner un client --</option>
                        <% 
                        List<Client> clients = (List<Client>) request.getAttribute("clients");
                        if (clients != null) {
                            for (Client client : clients) {
                        %>
                        <option value="<%= client.getId() %>"><%= client.getNomComplet() %> - <%= client.getEmail() %></option>
                        <% 
                            }
                        }
                        %>
                    </select>
                    <div class="form-help">Client pour lequel créer le compte prêt</div>
                </div>

                <div class="form-group full-width">
                    <label class="form-label required" for="numeroCompte">
                        <i class="fas fa-hashtag"></i>
                        Numéro de compte
                    </label>
                    <input type="text" class="form-control" id="numeroCompte" name="numeroCompte" 
                           placeholder="Généré automatiquement" readonly required>
                    <div class="form-help">Numéro unique du compte (généré automatiquement)</div>
                </div>
            </div>

            <!-- Section Prêt -->
            <div class="form-section">
                <h5 class="section-title">
                    <i class="fas fa-money-bill-wave"></i>
                    Conditions du Prêt
                </h5>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required" for="montantEmprunte">
                            <i class="fas fa-euro-sign"></i>
                            Montant emprunté
                        </label>
                        <input type="number" class="form-control" id="montantEmprunte" name="montantEmprunte" 
                               min="1000" max="1000000" step="100" required 
                               placeholder="Ex: 50000">
                        <div class="form-help">Montant entre 1 000€ et 1 000 000€</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label required" for="tauxInteret">
                            <i class="fas fa-percentage"></i>
                            Taux d'intérêt
                        </label>
                        <input type="number" class="form-control" id="tauxInteret" name="tauxInteret" 
                               min="0.1" max="25" step="0.1" required 
                               placeholder="Ex: 3.5">
                        <div class="form-help">Taux annuel en % (ex: 3.50 pour 3,50%)</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required" for="dureeAnnees">
                            <i class="fas fa-calendar-alt"></i>
                            Durée (années)
                        </label>
                        <input type="number" class="form-control" id="dureeAnnees" name="dureeAnnees" 
                               min="1" max="35" required 
                               placeholder="Ex: 20">
                        <div class="form-help">Durée entre 1 et 35 ans</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label required" for="typePaiementId">
                            <i class="fas fa-credit-card"></i>
                            Type de paiement
                        </label>
                        <select class="form-control" id="typePaiementId" name="typePaiementId" required>
                            <option value="">-- Sélectionner un type --</option>
                            <% 
                            List<TypePaiementDTO> typesPaiement = (List<TypePaiementDTO>) request.getAttribute("typesPaiement");
                            if (typesPaiement != null) {
                                for (TypePaiementDTO type : typesPaiement) {
                            %>
                            <option value="<%= type.getId() %>"><%= type.getLibelle() %> - <%= type.getDescription() %></option>
                            <% 
                                }
                            }
                            %>
                        </select>
                        <div class="form-help">Mode de remboursement du prêt</div>
                    </div>
                </div>
            </div>

            <!-- Calculs automatiques -->
            <div class="info-card">
                <h6>
                    <i class="fas fa-calculator"></i>
                    Calculs Prévisionnels
                </h6>
                <div class="info-card-content">
                    <div class="info-item">
                        <div class="info-item-value" id="mensualiteCalculee">--</div>
                        <div class="info-item-label">Mensualité</div>
                    </div>
                    <div class="info-item">
                        <div class="info-item-value" id="coutTotalCalcule">--</div>
                        <div class="info-item-label">Coût Total</div>
                    </div>
                    <div class="info-item">
                        <div class="info-item-value" id="interetsCalcules">--</div>
                        <div class="info-item-label">Intérêts</div>
                    </div>
                </div>
            </div>

            <!-- Boutons d'action -->
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i>
                    Retour au tableau de bord
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i>
                    Créer le compte prêt
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // Auto-génération du numéro de compte
    document.getElementById('clientId').addEventListener('change', function() {
        const numeroCompteInput = document.getElementById('numeroCompte');
        if (this.value) {
            const timestamp = Date.now().toString().slice(-6);
            const clientId = this.value.padStart(4, '0');
            numeroCompteInput.value = 'PR' + clientId + timestamp;
        } else {
            numeroCompteInput.value = '';
        }
    });

    // Calcul automatique des mensualités
    function calculerMensualite() {
        const montant = parseFloat(document.getElementById('montantEmprunte').value) || 0;
        const taux = parseFloat(document.getElementById('tauxInteret').value) || 0;
        const duree = parseInt(document.getElementById('dureeAnnees').value) || 0;

        if (montant > 0 && taux > 0 && duree > 0) {
            const tauxMensuel = taux / 100 / 12;
            const nbMensualites = duree * 12;
            
            const mensualite = montant * (tauxMensuel * Math.pow(1 + tauxMensuel, nbMensualites)) / 
                             (Math.pow(1 + tauxMensuel, nbMensualites) - 1);
            
            const coutTotal = mensualite * nbMensualites;
            const interets = coutTotal - montant;

            document.getElementById('mensualiteCalculee').textContent = mensualite.toFixed(2) + '€';
            document.getElementById('coutTotalCalcule').textContent = coutTotal.toFixed(2) + '€';
            document.getElementById('interetsCalcules').textContent = interets.toFixed(2) + '€';
        } else {
            document.getElementById('mensualiteCalculee').textContent = '--';
            document.getElementById('coutTotalCalcule').textContent = '--';
            document.getElementById('interetsCalcules').textContent = '--';
        }
    }

    // Écouteurs pour les calculs automatiques
    ['montantEmprunte', 'tauxInteret', 'dureeAnnees'].forEach(id => {
        document.getElementById(id).addEventListener('input', calculerMensualite);
    });
</script>
       