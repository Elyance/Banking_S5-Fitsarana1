<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    .registration-container {
        max-width: 800px;
        margin: 0 auto;
    }

    .registration-card {
        background: var(--bg-white);
        border-radius: var(--radius-lg);
        padding: 2rem;
        box-shadow: var(--shadow-md);
        border: 1px solid var(--border-light);
        margin-bottom: 2rem;
    }

    .registration-header {
        text-align: center;
        margin-bottom: 2rem;
        padding-bottom: 1rem;
        border-bottom: 2px solid var(--border-light);
    }

    .registration-title {
        font-size: 2rem;
        font-weight: 700;
        color: var(--text-primary);
        margin-bottom: 0.5rem;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.75rem;
    }

    .registration-subtitle {
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
    }

    .form-group.full-width {
        grid-column: span 2;
    }

    .form-label {
        font-weight: 500;
        color: var(--text-secondary);
        margin-bottom: 0.5rem;
        font-size: 0.875rem;
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
        background: rgba(239, 68, 68, 0.05);
    }

    .error-message {
        background: rgba(239, 68, 68, 0.1);
        color: var(--danger-color);
        padding: 1rem;
        border-radius: var(--radius-sm);
        margin-bottom: 1.5rem;
        border: 1px solid rgba(239, 68, 68, 0.2);
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .form-actions {
        display: flex;
        gap: 1rem;
        justify-content: flex-end;
        margin-top: 2rem;
        padding-top: 1.5rem;
        border-top: 1px solid var(--border-light);
    }

    .btn {
        padding: 0.75rem 1.5rem;
        border-radius: var(--radius-sm);
        font-weight: 500;
        text-decoration: none;
        border: none;
        cursor: pointer;
        transition: all var(--transition-fast);
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .btn-primary {
        background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
        color: white;
    }

    .btn-primary:hover {
        background: var(--primary-dark);
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
    }

    .btn-secondary {
        background: var(--bg-white);
        color: var(--text-secondary);
        border: 2px solid var(--border-color);
    }

    .btn-secondary:hover {
        background: var(--bg-light);
        border-color: var(--primary-color);
        color: var(--primary-color);
    }

    .form-help {
        font-size: 0.75rem;
        color: var(--text-muted);
        margin-top: 0.25rem;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .form-row {
            grid-template-columns: 1fr;
        }
        
        .form-group.full-width {
            grid-column: span 1;
        }
        
        .form-actions {
            flex-direction: column;
        }
        
        .btn {
            justify-content: center;
        }
    }
</style>

<!-- Page Header -->
<div class="page-header">
    <div class="d-flex justify-content-between align-items-center">
        <div>
            <h1 class="page-title">
                <i class="fas fa-user-plus text-primary me-3"></i>
                Nouveau Client
            </h1>
            <p class="page-subtitle">Enregistrer un nouveau client dans le système</p>
        </div>
        <div class="page-actions">
            <a href="${pageContext.request.contextPath}/clients/list" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left"></i>
                Retour à la liste
            </a>
        </div>
    </div>
</div>

<div class="registration-container">
    <div class="registration-card">
        <!-- Messages d'erreur -->
        <% 
        String error = (String) request.getAttribute("error");
        if (error != null) { 
        %>
            <div class="error-message">
                <i class="fas fa-exclamation-triangle"></i>
                <%= error %>
            </div>
        <% } %>

        <!-- Formulaire d'enregistrement -->
        <form method="post" action="${pageContext.request.contextPath}/clients/register">
            <!-- Informations personnelles -->
            <div class="form-section">
                <h3 class="section-title">
                    <i class="fas fa-user"></i>
                    Informations personnelles
                </h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required" for="nom">Nom</label>
                        <input type="text" 
                               id="nom" 
                               name="nom" 
                               class="form-control" 
                               value="<%= request.getAttribute("nom") != null ? request.getAttribute("nom") : "" %>"
                               required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label required" for="prenom">Prénom</label>
                        <input type="text" 
                               id="prenom" 
                               name="prenom" 
                               class="form-control" 
                               value="<%= request.getAttribute("prenom") != null ? request.getAttribute("prenom") : "" %>"
                               required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="dateNaissance">Date de naissance</label>
                        <input type="date" 
                               id="dateNaissance" 
                               name="dateNaissance" 
                               class="form-control" 
                               value="<%= request.getAttribute("dateNaissance") != null ? request.getAttribute("dateNaissance") : "" %>">
                        <div class="form-help">Optionnel</div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="profession">Profession</label>
                        <input type="text" 
                               id="profession" 
                               name="profession" 
                               class="form-control" 
                               value="<%= request.getAttribute("profession") != null ? request.getAttribute("profession") : "" %>"
                               placeholder="Ex: Ingénieur, Médecin...">
                        <div class="form-help">Optionnel</div>
                    </div>
                </div>
            </div>

            <!-- Informations de contact -->
            <div class="form-section">
                <h3 class="section-title">
                    <i class="fas fa-address-book"></i>
                    Informations de contact
                </h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required" for="email">Email</label>
                        <input type="email" 
                               id="email" 
                               name="email" 
                               class="form-control" 
                               value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                               required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label required" for="telephone">Téléphone</label>
                        <input type="tel" 
                               id="telephone" 
                               name="telephone" 
                               class="form-control" 
                               value="<%= request.getAttribute("telephone") != null ? request.getAttribute("telephone") : "" %>"
                               placeholder="Ex: +261 34 12 345 67"
                               required>
                    </div>
                </div>

                <div class="form-group full-width">
                    <label class="form-label" for="adresse">Adresse complète</label>
                    <textarea id="adresse" 
                              name="adresse" 
                              class="form-control" 
                              rows="3"
                              placeholder="Ex: Lot ABC Quartier XYZ, Antananarivo 101"><%= request.getAttribute("adresse") != null ? request.getAttribute("adresse") : "" %></textarea>
                    <div class="form-help">Optionnel - Adresse complète du client</div>
                </div>
            </div>

            <!-- Actions -->
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/clients/list" class="btn btn-secondary">
                    <i class="fas fa-times"></i>
                    Annuler
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i>
                    Enregistrer le client
                </button>
            </div>
        </form>
    </div>
</div>

<script>
// Validation côté client
document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('form');
    const inputs = form.querySelectorAll('.form-control[required]');
    
    // Validation en temps réel
    inputs.forEach(input => {
        input.addEventListener('blur', function() {
            validateField(this);
        });
        
        input.addEventListener('input', function() {
            if (this.classList.contains('error')) {
                validateField(this);
            }
        });
    });
    
    // Validation lors de la soumission
    form.addEventListener('submit', function(e) {
        let isValid = true;
        
        inputs.forEach(input => {
            if (!validateField(input)) {
                isValid = false;
            }
        });
        
        // Validation spécifique pour l'email
        const emailInput = document.getElementById('email');
        if (!validateEmail(emailInput.value)) {
            emailInput.classList.add('error');
            isValid = false;
        }
        
        if (!isValid) {
            e.preventDefault();
            scrollToFirstError();
        }
    });
    
    function validateField(field) {
        const value = field.value.trim();
        
        if (field.hasAttribute('required') && !value) {
            field.classList.add('error');
            return false;
        } else {
            field.classList.remove('error');
            return true;
        }
    }
    
    function validateEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }
    
    function scrollToFirstError() {
        const firstError = document.querySelector('.form-control.error');
        if (firstError) {
            firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
            firstError.focus();
        }
    }
});
</script>