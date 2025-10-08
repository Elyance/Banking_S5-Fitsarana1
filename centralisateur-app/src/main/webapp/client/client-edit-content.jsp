<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.centralisateur.entity.Client" %>

<style>
    .edit-container {
        max-width: 1000px;
        margin: 0 auto;
    }

    .form-card {
        background: white;
        border-radius: 16px;
        padding: 2rem;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        border: 1px solid #e2e8f0;
    }

    .form-header {
        text-align: center;
        margin-bottom: 2rem;
        padding-bottom: 1rem;
        border-bottom: 2px solid #f1f5f9;
    }

    .form-header h2 {
        font-size: 1.75rem;
        font-weight: 700;
        color: #1e293b;
        margin-bottom: 0.5rem;
    }

    .form-header .subtitle {
        color: #64748b;
        font-size: 0.95rem;
    }

    .form-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 2rem;
        margin-bottom: 1.5rem;
    }

    .form-group {
        display: flex;
        flex-direction: column;
    }

    .form-group.full-width {
        grid-column: span 2;
    }

    .form-label {
        font-weight: 600;
        color: #374151;
        margin-bottom: 0.5rem;
        font-size: 0.925rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .form-label.required::after {
        content: '*';
        color: #ef4444;
        font-weight: 700;
        margin-left: 0.25rem;
    }

    .form-control {
        padding: 0.875rem 1rem;
        border: 2px solid #e5e7eb;
        border-radius: 8px;
        font-size: 0.95rem;
        transition: all 0.2s ease;
        background: #ffffff;
        font-family: inherit;
    }

    .form-control:focus {
        outline: none;
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        background: #fafbff;
    }

    .form-control.error {
        border-color: #ef4444;
        background: rgba(239, 68, 68, 0.05);
        box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
    }

    .form-help {
        font-size: 0.8rem;
        color: #6b7280;
        margin-top: 0.4rem;
        font-style: italic;
    }

    .error-alert {
        background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(220, 38, 38, 0.05));
        border: 1px solid rgba(239, 68, 68, 0.3);
        border-radius: 8px;
        padding: 1rem;
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .error-alert i {
        color: #ef4444;
        font-size: 1.1rem;
    }

    .error-alert-text {
        color: #dc2626;
        font-weight: 500;
        font-size: 0.9rem;
    }

    .form-actions {
        display: flex;
        gap: 1rem;
        justify-content: center;
        margin-top: 2rem;
        padding-top: 1.5rem;
        border-top: 1px solid #e5e7eb;
    }

    .btn {
        padding: 0.875rem 1.75rem;
        border-radius: 8px;
        font-weight: 600;
        text-decoration: none;
        border: none;
        cursor: pointer;
        transition: all 0.2s ease;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.9rem;
    }

    .btn-primary {
        background: linear-gradient(135deg, #2563eb, #1d4ed8);
        color: white;
        box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
    }

    .btn-primary:hover {
        background: linear-gradient(135deg, #1d4ed8, #1e40af);
        transform: translateY(-1px);
        box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4);
        color: white;
    }

    .btn-secondary {
        background: #ffffff;
        color: #6b7280;
        border: 2px solid #e5e7eb;
    }

    .btn-secondary:hover {
        background: #f8fafc;
        border-color: #2563eb;
        color: #2563eb;
        transform: translateY(-1px);
    }

    .btn-outline {
        background: rgba(37, 99, 235, 0.05);
        color: #2563eb;
        border: 2px solid #2563eb;
    }

    .btn-outline:hover {
        background: #2563eb;
        color: white;
        transform: translateY(-1px);
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .form-grid {
            grid-template-columns: 1fr;
            gap: 1rem;
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
        
        .form-card {
            padding: 1.5rem;
        }
    }

    @media (max-width: 480px) {
        .edit-container {
            padding: 0 1rem;
        }
        
        .form-header h2 {
            font-size: 1.5rem;
        }
    }
</style>

<!-- Page Header -->
<div class="page-header mb-4">
    <div class="d-flex justify-content-between align-items-center">
        <div>
            <h1 class="page-title">
                <i class="fas fa-user-edit text-primary me-3"></i>
                Modifier le Client
            </h1>
            <p class="page-subtitle mb-0">Mettre à jour les informations du client</p>
        </div>
        <div class="page-actions">
            <% 
            Client client = (Client) request.getAttribute("client");
            if (client != null) {
            %>
                <a href="${pageContext.request.contextPath}/clients/details?id=<%= client.getId() %>" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i>
                    Retour aux détails
                </a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/clients/list" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i>
                    Retour à la liste
                </a>
            <% } %>
        </div>
    </div>
</div>

<div class="edit-container">
    <!-- Messages d'erreur -->
    <% 
    String error = (String) request.getAttribute("error");
    if (error != null) { 
    %>
        <div class="error-alert">
            <i class="fas fa-exclamation-triangle"></i>
            <div class="error-alert-text"><%= error %></div>
        </div>
    <% } %>

    <% 
    if (client != null) {
        String initials = client.getPrenom().substring(0,1) + client.getNom().substring(0,1);
    %>
        <!-- Formulaire compact en deux colonnes -->
        <div class="form-card">
            <div class="form-header">
                <h2>Modifier <%= client.getPrenom() %> <%= client.getNom() %></h2>
                <div class="subtitle">
                    <% if (client.getNumeroClient() != null) { %>
                        Client <%= client.getNumeroClient() %>
                    <% } else { %>
                        Client ID #<%= client.getId() %>
                    <% } %>
                </div>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/clients/edit">
                <input type="hidden" name="clientId" value="<%= client.getId() %>">
                
                <!-- Formulaire en grille deux colonnes -->
                <div class="form-grid">
                    <!-- Nom -->
                    <div class="form-group">
                        <label class="form-label required" for="nom">
                            <i class="fas fa-id-badge"></i>
                            Nom de famille
                        </label>
                        <input type="text" 
                               id="nom" 
                               name="nom" 
                               class="form-control" 
                               value="<%= request.getAttribute("nom") != null ? request.getAttribute("nom") : client.getNom() %>"
                               placeholder="Entrez le nom de famille"
                               required>
                    </div>
                    
                    <!-- Prénom -->
                    <div class="form-group">
                        <label class="form-label required" for="prenom">
                            <i class="fas fa-user-tag"></i>
                            Prénom(s)
                        </label>
                        <input type="text" 
                               id="prenom" 
                               name="prenom" 
                               class="form-control" 
                               value="<%= request.getAttribute("prenom") != null ? request.getAttribute("prenom") : client.getPrenom() %>"
                               placeholder="Entrez le(s) prénom(s)"
                               required>
                    </div>

                    <!-- Email -->
                    <div class="form-group">
                        <label class="form-label required" for="email">
                            <i class="fas fa-envelope"></i>
                            Adresse email
                        </label>
                        <input type="email" 
                               id="email" 
                               name="email" 
                               class="form-control" 
                               value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : client.getEmail() %>"
                               placeholder="exemple@email.com"
                               required>
                    </div>
                    
                    <!-- Téléphone -->
                    <div class="form-group">
                        <label class="form-label required" for="telephone">
                            <i class="fas fa-phone"></i>
                            Numéro de téléphone
                        </label>
                        <input type="tel" 
                               id="telephone" 
                               name="telephone" 
                               class="form-control" 
                               value="<%= request.getAttribute("telephone") != null ? request.getAttribute("telephone") : client.getTelephone() %>"
                               placeholder="+261 34 12 345 67"
                               required>
                    </div>

                    <!-- Date de naissance -->
                    <div class="form-group">
                        <label class="form-label" for="dateNaissance">
                            <i class="fas fa-calendar-alt"></i>
                            Date de naissance
                        </label>
                        <input type="date" 
                               id="dateNaissance" 
                               name="dateNaissance" 
                               class="form-control" 
                               value="<%= request.getAttribute("dateNaissance") != null ? request.getAttribute("dateNaissance") : (client.getDateNaissance() != null ? client.getDateNaissance() : "") %>">
                        <div class="form-help">Optionnel</div>
                    </div>
                    
                    <!-- Profession -->
                    <div class="form-group">
                        <label class="form-label" for="profession">
                            <i class="fas fa-briefcase"></i>
                            Profession
                        </label>
                        <input type="text" 
                               id="profession" 
                               name="profession" 
                               class="form-control" 
                               value="<%= request.getAttribute("profession") != null ? request.getAttribute("profession") : (client.getProfession() != null ? client.getProfession() : "") %>"
                               placeholder="Ex: Ingénieur, Médecin...">
                        <div class="form-help">Optionnel</div>
                    </div>

                    <!-- Adresse -->
                    <div class="form-group full-width">
                        <label class="form-label" for="adresse">
                            <i class="fas fa-map-marker-alt"></i>
                            Adresse complète
                        </label>
                        <textarea id="adresse" 
                                  name="adresse" 
                                  class="form-control" 
                                  rows="3"
                                  placeholder="Ex: Lot ABC Quartier XYZ, Antananarivo 101, Madagascar"><%= request.getAttribute("adresse") != null ? request.getAttribute("adresse") : (client.getAdresse() != null ? client.getAdresse() : "") %></textarea>
                        <div class="form-help">Optionnel - Adresse résidentielle complète</div>
                    </div>
                </div>

                <!-- Actions du formulaire -->
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/clients/details?id=<%= client.getId() %>" class="btn btn-secondary">
                        <i class="fas fa-times"></i>
                        Annuler
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i>
                        Sauvegarder les modifications
                    </button>
                    <a href="${pageContext.request.contextPath}/clients/details?id=<%= client.getId() %>" class="btn btn-outline">
                        <i class="fas fa-eye"></i>
                        Voir les détails
                    </a>
                </div>
            </form>
        </div>
    <% } else { %>
        <div class="text-center py-5">
            <i class="fas fa-user-slash display-1 text-danger mb-3"></i>
            <h3>Client non trouvé</h3>
            <p class="text-muted">Le client à modifier n'existe pas ou a été supprimé.</p>
            <a href="${pageContext.request.contextPath}/clients/list" class="btn btn-primary">
                <i class="fas fa-arrow-left"></i>
                Retour à la liste
            </a>
        </div>
    <% } %>
</div>

<script>
// Validation côté client et améliorations UX
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
        } else {
            // Confirmation avant sauvegarde
            if (!confirm('Êtes-vous sûr de vouloir sauvegarder ces modifications ?')) {
                e.preventDefault();
            }
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
    
    // Détection des modifications non sauvegardées
    let formModified = false;
    const originalValues = {};
    
    inputs.forEach(input => {
        originalValues[input.name] = input.value;
        input.addEventListener('input', function() {
            formModified = (this.value !== originalValues[this.name]);
        });
    });
    
    window.addEventListener('beforeunload', function(e) {
        if (formModified) {
            e.preventDefault();
            e.returnValue = '';
        }
    });
    
    // Désactiver l'alerte lors de la soumission du formulaire
    form.addEventListener('submit', function() {
        formModified = false;
    });
});
</script>