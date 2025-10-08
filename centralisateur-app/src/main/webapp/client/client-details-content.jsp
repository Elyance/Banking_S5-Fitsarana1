<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.centralisateur.entity.Client" %>
<%@ page import="com.centralisateur.entity.StatutClient" %>
<%@ page import="java.text.SimpleDateFormat" %>

<style>
    /* Adaptation au layout principal */
    .client-details-container {
        max-width: 100%;
        margin: 0;
        padding: 0;
    }

    .client-avatar-lg {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 2rem;
        font-weight: 700;
        text-transform: uppercase;
        border: 3px solid rgba(255,255,255,0.2);
        box-shadow: var(--shadow-md);
    }

    .info-card {
        background: var(--bg-white);
        border-radius: var(--radius-md);
        padding: 1.5rem;
        box-shadow: var(--shadow-sm);
        border: 1px solid var(--border-color);
        height: 100%;
        transition: var(--transition-fast);
        margin-bottom: 1.5rem;
    }

    .info-card:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
    }

    .info-card-header {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        margin-bottom: 1.5rem;
        padding-bottom: 1rem;
        border-bottom: 2px solid var(--border-light);
    }

    .info-card-icon {
        width: 40px;
        height: 40px;
        border-radius: var(--radius-sm);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.25rem;
        color: white;
    }

    .info-card-icon.primary { background: linear-gradient(135deg, var(--primary-color), var(--primary-dark)); }
    .info-card-icon.success { background: linear-gradient(135deg, var(--accent-color), #047857); }
    .info-card-icon.info { background: linear-gradient(135deg, #0891b2, #0e7490); }
    .info-card-icon.warning { background: linear-gradient(135deg, var(--warning-color), #d97706); }

    .info-card-title {
        font-size: 1.1rem;
        font-weight: 600;
        color: var(--text-primary);
        margin: 0;
    }

    .info-item {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        padding: 0.75rem 0;
        border-bottom: 1px solid var(--border-light);
    }

    .info-item:last-child {
        border-bottom: none;
        padding-bottom: 0;
    }

    .info-label {
        font-size: 0.875rem;
        color: var(--text-secondary);
        font-weight: 500;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        min-width: 120px;
    }

    .info-value {
        font-size: 1rem;
        color: var(--text-primary);
        font-weight: 500;
        text-align: right;
        flex: 1;
        word-break: break-word;
    }

    .info-value.highlight {
        color: var(--primary-color);
        font-weight: 600;
    }

    .info-value.empty {
        color: var(--text-muted);
        font-style: italic;
    }

    .main-client-card {
        background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
        color: white;
        border-radius: var(--radius-lg);
        padding: 2rem;
        margin-bottom: 2rem;
        box-shadow: var(--shadow-lg);
    }

    .client-main-info h2 {
        font-size: 2.5rem;
        font-weight: 700;
        margin-bottom: 0.5rem;
    }

    .client-subtitle {
        font-size: 1.1rem;
        opacity: 0.9;
        margin-bottom: 1rem;
    }

    .client-badge {
        display: inline-block;
        background: rgba(255, 255, 255, 0.2);
        color: white;
        padding: 0.5rem 1rem;
        border-radius: var(--radius-sm);
        font-size: 0.875rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        backdrop-filter: blur(10px);
    }

    .status-badge {
    .status-badge {
        display: inline-block;
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-size: 0.875rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .status-badge.active {
        background: rgba(6, 214, 160, 0.1);
        color: var(--accent-color);
        border: 1px solid rgba(6, 214, 160, 0.3);
    }

    .status-badge.inactive {
        background: rgba(239, 68, 68, 0.1);
        color: var(--danger-color);
        border: 1px solid rgba(239, 68, 68, 0.3);
    }

    .actions-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 1.25rem;
        margin-top: 1.5rem;
        width: 100%;
    }

    .action-btn {
        display: flex;
        align-items: center;
        justify-content: flex-start;
        gap: 1rem;
        padding: 1.25rem 1.75rem;
        border: 2px solid transparent;
        border-radius: var(--radius-lg);
        text-decoration: none;
        font-weight: 600;
        font-size: 1rem;
        transition: all var(--transition-fast);
        cursor: pointer;
        outline: none;
        position: relative;
        overflow: hidden;
        min-height: 64px;
        box-shadow: var(--shadow-sm);
    }

    .action-btn::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
        transition: left 0.6s ease;
    }

    .action-btn:hover::before {
        left: 100%;
    }

    .action-btn:hover {
        transform: translateY(-3px) scale(1.02);
        text-decoration: none;
        box-shadow: var(--shadow-lg);
    }

    .action-btn:active {
        transform: translateY(-1px) scale(1.01);
        transition: all 0.1s ease;
    }

    .action-btn i {
        font-size: 1.5rem;
        flex-shrink: 0;
        width: 24px;
        text-align: center;
    }

    .action-btn-content {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        flex: 1;
    }

    .action-btn-title {
        font-weight: 600;
        font-size: 1rem;
        line-height: 1.2;
        margin-bottom: 0.25rem;
    }

    .action-btn-desc {
        font-size: 0.875rem;
        opacity: 0.8;
        line-height: 1.3;
        font-weight: 400;
    }

    /* Variantes de couleurs modernes */
    .action-btn.primary {
        background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
        color: white;
        border-color: transparent;
    }

    .action-btn.primary:hover {
        color: white;
        background: linear-gradient(135deg, var(--primary-dark), #1e40af);
        box-shadow: 0 12px 32px rgba(59, 130, 246, 0.4);
    }

    .action-btn.success {
        background: linear-gradient(135deg, var(--success-color), #047857);
        color: white;
        border-color: transparent;
    }

    .action-btn.success:hover {
        color: white;
        background: linear-gradient(135deg, #047857, #065f46);
        box-shadow: 0 12px 32px rgba(34, 197, 94, 0.4);
    }

    .action-btn.warning {
        background: linear-gradient(135deg, var(--warning-color), #d97706);
        color: white;
        border-color: transparent;
    }

    .action-btn.warning:hover {
        color: white;
        background: linear-gradient(135deg, #d97706, #b45309);
        box-shadow: 0 12px 32px rgba(245, 158, 11, 0.4);
    }

    .action-btn.secondary {
        background: var(--bg-white);
        color: var(--text-primary);
        border: 2px solid var(--border-color);
    }

    .action-btn.secondary:hover {
        background: var(--bg-primary);
        border-color: var(--primary-color);
        color: var(--primary-color);
        box-shadow: 0 12px 32px rgba(59, 130, 246, 0.2);
    }

    .action-btn.info {
        background: linear-gradient(135deg, var(--info-color), #0e7490);
        color: white;
        border-color: transparent;
    }

    .action-btn.info:hover {
        color: white;
        background: linear-gradient(135deg, #0e7490, #155e75);
        box-shadow: 0 12px 32px rgba(6, 182, 212, 0.4);
    }

    /* Responsive amélioré */
    @media (max-width: 768px) {
        .actions-grid {
            grid-template-columns: 1fr;
            gap: 1rem;
        }
        
        .action-btn {
            padding: 1rem 1.25rem;
            min-height: 56px;
        }

        .action-btn i {
            font-size: 1.25rem;
        }

        .action-btn-title {
            font-size: 0.95rem;
        }

        .action-btn-desc {
            font-size: 0.8rem;
        }
    }

    @media (max-width: 480px) {
        .actions-grid {
            gap: 0.75rem;
        }
        
        .action-btn {
            padding: 0.875rem 1rem;
            flex-direction: row;
            min-height: 52px;
        }

        .action-btn-content {
            align-items: flex-start;
        }
    }

    .empty-state {
        text-align: center;
        padding: 4rem 2rem;
        background: var(--bg-white);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-sm);
    }

    .empty-state i {
        font-size: 4rem;
        color: var(--danger-color);
        margin-bottom: 1rem;
    }

    .empty-state h3 {
        font-size: 1.5rem;
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: 0.5rem;
    }

    .empty-state p {
        color: var(--text-secondary);
        margin-bottom: 2rem;
    }

    /* Animation d'entrée */
    .fade-in {
        animation: fadeInUp 0.5s ease-out forwards;
        opacity: 0;
        transform: translateY(20px);
    }

    .fade-in:nth-child(1) { animation-delay: 0.1s; }
    .fade-in:nth-child(2) { animation-delay: 0.2s; }
    .fade-in:nth-child(3) { animation-delay: 0.3s; }
    .fade-in:nth-child(4) { animation-delay: 0.4s; }

    @keyframes fadeInUp {
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* Responsive adapté au layout */
    @media (max-width: 768px) {
        .main-client-card {
            text-align: center;
            margin-bottom: 1.5rem;
            padding: 1.5rem;
        }
        
        .main-client-card .d-flex {
            flex-direction: column;
            gap: 1rem;
        }
        
        .info-item {
            flex-direction: column;
            align-items: flex-start;
            gap: 0.5rem;
        }
        
        .info-label {
            min-width: auto;
        }
        
        .info-value {
            text-align: left;
        }
        
        .actions-grid {
            grid-template-columns: 1fr;
        }
        
        .client-main-info h2 {
            font-size: 2rem;
        }
    }

    /* Intégration avec le layout existant */
    .content-wrapper {
        background: var(--bg-primary);
        min-height: calc(100vh - var(--header-height));
        padding: 1.5rem;
    }
    
    /* Amélioration pour mobile dans le contexte du layout */
    @media (max-width: 992px) {
        .content-wrapper {
            padding: 1rem;
        }
        
        .info-card {
            margin-bottom: 1rem;
        }
    }
        
        .info-value {
            text-align: left;
        }
        
        .actions-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<!-- Page Header -->
<div class="page-header mb-4">
    <div class="d-flex justify-content-between align-items-center">
        <div>
            <h1 class="page-title">
                <i class="fas fa-user text-primary me-3"></i>
                Détails du Client
            </h1>
            <p class="page-subtitle mb-0">Informations complètes et actions disponibles</p>
        </div>
        <div class="page-actions">
            <a href="${pageContext.request.contextPath}/clients/list" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>
                Retour à la liste
            </a>
        </div>
    </div>
</div>

<!-- Container principal adapté au layout -->
<div class="client-details-container">
    <% 
    String successMessage = (String) request.getAttribute("successMessage");
    if (successMessage != null) { 
    %>
        <div class="alert alert-success d-flex align-items-center mb-4" role="alert">
            <i class="fas fa-check-circle me-2"></i>
            <%= successMessage %>
        </div>
    <% } %>

    <% 
    Client client = (Client) request.getAttribute("client");
    StatutClient statut = (StatutClient) request.getAttribute("statut");
    
    if (client != null) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        String initials = client.getPrenom().substring(0,1) + client.getNom().substring(0,1);
    %>
        <!-- Carte principale du client -->
        <div class="main-client-card fade-in">
            <div class="d-flex align-items-center gap-3">
                <div class="client-avatar-lg">
                    <%= initials %>
                </div>
                <div class="client-main-info flex-1">
                    <h2><%= client.getPrenom() %> <%= client.getNom() %></h2>
                    <div class="client-subtitle"><%= client.getEmail() %></div>
                    <div class="client-badge">
                        <% if (client.getNumeroClient() != null) { %>
                            Client <%= client.getNumeroClient() %>
                        <% } else { %>
                            ID #<%= client.getId() %>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Grille d'informations en colonnes -->
        <div class="row g-4">
            <!-- Colonne 1: Informations personnelles -->
            <div class="col-lg-4 col-md-6">
                <div class="info-card fade-in">
                    <div class="info-card-header">
                        <div class="info-card-icon primary">
                            <i class="fas fa-user"></i>
                        </div>
                        <h5 class="info-card-title">Informations personnelles</h5>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Nom</span>
                        <span class="info-value"><%= client.getNom() %></span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Prénom</span>
                        <span class="info-value"><%= client.getPrenom() %></span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Date de naissance</span>
                        <span class="info-value">
                            <%= client.getDateNaissance() != null ? client.getDateNaissance() : "Non renseignée" %>
                        </span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Profession</span>
                        <span class="info-value">
                            <%= (client.getProfession() != null && !client.getProfession().isEmpty()) ? client.getProfession() : "Non renseignée" %>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Colonne 2: Informations de contact -->
            <div class="col-lg-4 col-md-6">
                <div class="info-card fade-in">
                    <div class="info-card-header">
                        <div class="info-card-icon success">
                            <i class="fas fa-address-book"></i>
                        </div>
                        <h5 class="info-card-title">Contact</h5>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Email</span>
                        <span class="info-value highlight">
                            <a href="mailto:<%= client.getEmail() %>" class="text-decoration-none">
                                <%= client.getEmail() %>
                            </a>
                        </span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Téléphone</span>
                        <span class="info-value">
                            <a href="tel:<%= client.getTelephone() %>" class="text-decoration-none">
                                <%= client.getTelephone() %>
                            </a>
                        </span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Adresse</span>
                        <span class="info-value">
                            <%= (client.getAdresse() != null && !client.getAdresse().isEmpty()) ? client.getAdresse() : "Non renseignée" %>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Colonne 3: Informations système -->
            <div class="col-lg-4 col-md-12">
                <div class="info-card fade-in">
                    <div class="info-card-header">
                        <div class="info-card-icon info">
                            <i class="fas fa-cog"></i>
                        </div>
                        <h5 class="info-card-title">Informations système</h5>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">ID Client</span>
                        <span class="info-value highlight">#<%= client.getId() %></span>
                    </div>
                    
                    <% if (client.getNumeroClient() != null) { %>
                    <div class="info-item">
                        <span class="info-label">Numéro Client</span>
                        <span class="info-value highlight"><%= client.getNumeroClient() %></span>
                    </div>
                    <% } %>
                    
                    <div class="info-item">
                        <span class="info-label">Date de création</span>
                        <span class="info-value">
                            <%= dateFormat.format(java.sql.Timestamp.valueOf(client.getDateCreation())) %>
                        </span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Statut</span>
                        <span class="info-value">
                            <% if (statut != null) { %>
                                <span class="status-badge <%= statut.getLibelle().toLowerCase().contains("actif") ? "active" : "inactive" %>">
                                    <%= statut.getLibelle() %>
                                </span>
                            <% } else { %>
                                <span class="status-badge active">Actif</span>
                            <% } %>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Section Actions rapides -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="info-card fade-in">
                    <div class="info-card-header">
                        <div class="info-card-icon warning">
                            <i class="fas fa-bolt"></i>
                        </div>
                        <h5 class="info-card-title">Actions rapides</h5>
                    </div>
                    
                    <div class="actions-grid">
                        <a href="${pageContext.request.contextPath}/clients/edit?id=<%= client.getId() %>" 
                           class="action-btn primary">
                            <i class="fas fa-edit"></i>
                            <div class="action-btn-content">
                                <div class="action-btn-title">Modifier ce client</div>
                                <div class="action-btn-desc">Mettre à jour les informations personnelles</div>
                            </div>
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/comptes/creer?clientId=<%= client.getId() %>" 
                           class="action-btn success">
                            <i class="fas fa-plus-circle"></i>
                            <div class="action-btn-content">
                                <div class="action-btn-title">Créer un compte</div>
                                <div class="action-btn-desc">Ouvrir un nouveau compte bancaire</div>
                            </div>
                        </a>
                        
                        <button onclick="window.print()" class="action-btn secondary">
                            <i class="fas fa-print"></i>
                            <div class="action-btn-content">
                                <div class="action-btn-title">Imprimer les détails</div>
                                <div class="action-btn-desc">Générer un rapport PDF du profil</div>
                            </div>
                        </button>

                        <a href="${pageContext.request.contextPath}/clients/comptes?clientId=<%= client.getId() %>" 
                           class="action-btn info">
                            <i class="fas fa-university"></i>
                            <div class="action-btn-content">
                                <div class="action-btn-title">Voir les comptes</div>
                                <div class="action-btn-desc">Consulter tous les comptes du client</div>
                            </div>
                        </a>

                        <a href="${pageContext.request.contextPath}/clients/historique?clientId=<%= client.getId() %>" 
                           class="action-btn warning">
                            <i class="fas fa-history"></i>
                            <div class="action-btn-content">
                                <div class="action-btn-title">Historique client</div>
                                <div class="action-btn-desc">Voir l'activité et les transactions</div>
                            </div>
                        </a>

                        <button onclick="exporterClient('<%= client.getId() %>')" class="action-btn secondary">
                            <i class="fas fa-download"></i>
                            <div class="action-btn-content">
                                <div class="action-btn-title">Exporter données</div>
                                <div class="action-btn-desc">Télécharger les informations en CSV</div>
                            </div>
                        </button>
                    </div>
                </div>
            </div>
        </div>

    <% } else { %>
        <div class="empty-state">
            <i class="fas fa-user-slash"></i>
            <h3>Client non trouvé</h3>
            <p>Le client demandé n'existe pas ou a été supprimé de la base de données.</p>
            <a href="${pageContext.request.contextPath}/clients/list" class="action-btn primary">
                <i class="fas fa-arrow-left"></i>
                Retour à la liste des clients
            </a>
        </div>
    <% } %>
</div>

<script>
function exporterClient(clientId) {
    // Fonction pour exporter les données du client
    const url = '${pageContext.request.contextPath}/clients/export?id=' + clientId + '&format=csv';
    
    // Créer un lien temporaire pour télécharger
    const link = document.createElement('a');
    link.href = url;
    link.download = 'client_' + clientId + '_data.csv';
    link.style.display = 'none';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    // Afficher une notification
    if (typeof showNotification === 'function') {
        showNotification('Export en cours...', 'info');
    } else {
        alert('Export des données en cours...');
    }
}

// Animation d'entrée pour les cartes
document.addEventListener('DOMContentLoaded', function() {
    const cards = document.querySelectorAll('.fade-in');
    cards.forEach((card, index) => {
        setTimeout(() => {
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });
});
</script>