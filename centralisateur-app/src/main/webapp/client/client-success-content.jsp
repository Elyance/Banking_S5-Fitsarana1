<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.centralisateur.entity.Client" %>
<%@ page import="java.text.SimpleDateFormat" %>

<style>
    .success-container {
        max-width: 800px;
        margin: 0 auto;
    }

    .success-card {
        background: var(--bg-white);
        border-radius: var(--radius-lg);
        padding: 2rem;
        box-shadow: var(--shadow-md);
        border: 1px solid var(--border-light);
        margin-bottom: 2rem;
        text-align: center;
    }

    .success-icon {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        background: linear-gradient(135deg, var(--accent-color), #059669);
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 1.5rem;
        animation: successPulse 1.5s ease-in-out;
    }

    .success-icon i {
        font-size: 2rem;
        color: white;
    }

    @keyframes successPulse {
        0% {
            transform: scale(0);
            opacity: 0;
        }
        50% {
            transform: scale(1.1);
        }
        100% {
            transform: scale(1);
            opacity: 1;
        }
    }

    .success-title {
        font-size: 2rem;
        font-weight: 700;
        color: var(--text-primary);
        margin-bottom: 1rem;
    }

    .success-message {
        font-size: 1.1rem;
        color: var(--text-secondary);
        margin-bottom: 2rem;
        line-height: 1.6;
    }

    .client-info-card {
        background: linear-gradient(135deg, var(--bg-light), var(--bg-white));
        border-radius: var(--radius-md);
        padding: 1.5rem;
        margin: 2rem 0;
        border: 1px solid var(--border-light);
        text-align: left;
    }

    .client-info-title {
        font-size: 1.25rem;
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: 1rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .client-details {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 1rem;
    }

    .client-detail-item {
        display: flex;
        flex-direction: column;
        gap: 0.25rem;
    }

    .detail-label {
        font-size: 0.875rem;
        color: var(--text-muted);
        font-weight: 500;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .detail-value {
        font-size: 1rem;
        color: var(--text-primary);
        font-weight: 500;
    }

    .detail-value.highlight {
        color: var(--primary-color);
        font-weight: 600;
    }

    .action-buttons {
        display: flex;
        gap: 1rem;
        justify-content: center;
        margin-top: 2rem;
        flex-wrap: wrap;
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
        color: white;
    }

    .btn-success {
        background: linear-gradient(135deg, var(--accent-color), #059669);
        color: white;
    }

    .btn-success:hover {
        background: #059669;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(6, 214, 160, 0.3);
        color: white;
    }

    .btn-outline-secondary {
        background: var(--bg-white);
        color: var(--text-secondary);
        border: 2px solid var(--border-color);
    }

    .btn-outline-secondary:hover {
        background: var(--bg-light);
        border-color: var(--primary-color);
        color: var(--primary-color);
    }

    .next-steps {
        background: rgba(37, 99, 235, 0.05);
        border-radius: var(--radius-md);
        padding: 1.5rem;
        margin-top: 2rem;
        border: 1px solid rgba(37, 99, 235, 0.1);
    }

    .next-steps-title {
        font-size: 1.1rem;
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: 1rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .next-steps-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .next-steps-list li {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.5rem 0;
        color: var(--text-secondary);
    }

    .next-steps-list li i {
        color: var(--primary-color);
        width: 16px;
        text-align: center;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .client-details {
            grid-template-columns: 1fr;
        }
        
        .action-buttons {
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
                <i class="fas fa-check-circle text-success me-3"></i>
                Client créé avec succès
            </h1>
            <p class="page-subtitle">Le nouveau client a été enregistré dans le système</p>
        </div>
    </div>
</div>

<div class="success-container">
    <div class="success-card">
        <div class="success-icon">
            <i class="fas fa-check"></i>
        </div>
        
        <h2 class="success-title">Félicitations !</h2>
        
        <p class="success-message">
            <% 
            String message = (String) request.getAttribute("message");
            if (message != null) {
                out.print(message);
            } else {
                out.print("Le client a été enregistré avec succès dans le système.");
            }
            %>
        </p>

        <% 
        Client client = (Client) request.getAttribute("client");
        if (client != null) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        %>
            <div class="client-info-card">
                <h3 class="client-info-title">
                    <i class="fas fa-user"></i>
                    Informations du client
                </h3>
                
                <div class="client-details">
                    <div class="client-detail-item">
                        <span class="detail-label">ID Client</span>
                        <span class="detail-value highlight">#<%= client.getId() %></span>
                    </div>
                    
                    <% if (client.getNumeroClient() != null) { %>
                    <div class="client-detail-item">
                        <span class="detail-label">Numéro Client</span>
                        <span class="detail-value highlight"><%= client.getNumeroClient() %></span>
                    </div>
                    <% } %>
                    
                    <div class="client-detail-item">
                        <span class="detail-label">Nom complet</span>
                        <span class="detail-value"><%= client.getPrenom() %> <%= client.getNom() %></span>
                    </div>
                    
                    <div class="client-detail-item">
                        <span class="detail-label">Email</span>
                        <span class="detail-value"><%= client.getEmail() %></span>
                    </div>
                    
                    <div class="client-detail-item">
                        <span class="detail-label">Téléphone</span>
                        <span class="detail-value"><%= client.getTelephone() %></span>
                    </div>
                    
                    <% if (client.getProfession() != null && !client.getProfession().isEmpty()) { %>
                    <div class="client-detail-item">
                        <span class="detail-label">Profession</span>
                        <span class="detail-value"><%= client.getProfession() %></span>
                    </div>
                    <% } %>
                    
                    <% if (client.getDateNaissance() != null) { %>
                    <div class="client-detail-item">
                        <span class="detail-label">Date de naissance</span>
                        <span class="detail-value"><%= client.getDateNaissance() %></span>
                    </div>
                    <% } %>
                    
                    <div class="client-detail-item">
                        <span class="detail-label">Date de création</span>
                        <span class="detail-value">
                            <%= dateFormat.format(java.sql.Timestamp.valueOf(client.getDateCreation())) %>
                        </span>
                    </div>
                </div>
            </div>
        <% } %>

        <div class="next-steps">
            <h4 class="next-steps-title">
                <i class="fas fa-list-check"></i>
                Prochaines étapes
            </h4>
            <ul class="next-steps-list">
                <li>
                    <i class="fas fa-plus-circle"></i>
                    Créer un compte courant pour ce client
                </li>
                <li>
                    <i class="fas fa-eye"></i>
                    Consulter les détails complets du client
                </li>
                <li>
                    <i class="fas fa-users"></i>
                    Voir tous les clients enregistrés
                </li>
                <li>
                    <i class="fas fa-edit"></i>
                    Modifier les informations si nécessaire
                </li>
            </ul>
        </div>

        <div class="action-buttons">
            <% if (client != null) { %>
                <a href="${pageContext.request.contextPath}/clients/details?id=<%= client.getId() %>" 
                   class="btn btn-primary">
                    <i class="fas fa-eye"></i>
                    Voir les détails
                </a>
                
                <a href="${pageContext.request.contextPath}/compte-courant/creation?clientId=<%= client.getId() %>" 
                   class="btn btn-success">
                    <i class="fas fa-plus-circle"></i>
                    Créer un compte
                </a>
            <% } %>
            
            <a href="${pageContext.request.contextPath}/clients/register" 
               class="btn btn-outline-secondary">
                <i class="fas fa-user-plus"></i>
                Nouveau client
            </a>
            
            <a href="${pageContext.request.contextPath}/clients/list" 
               class="btn btn-outline-secondary">
                <i class="fas fa-list"></i>
                Liste des clients
            </a>
        </div>
    </div>
</div>

<script>
// Animation d'entrée progressive
document.addEventListener('DOMContentLoaded', function() {
    // Animation des éléments de détail
    const detailItems = document.querySelectorAll('.client-detail-item');
    detailItems.forEach((item, index) => {
        item.style.opacity = '0';
        item.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            item.style.transition = 'all 0.3s ease';
            item.style.opacity = '1';
            item.style.transform = 'translateY(0)';
        }, 100 * index);
    });
    
    // Animation des boutons d'action
    const buttons = document.querySelectorAll('.btn');
    buttons.forEach((button, index) => {
        button.style.opacity = '0';
        button.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            button.style.transition = 'all 0.3s ease';
            button.style.opacity = '1';
            button.style.transform = 'translateY(0)';
        }, 500 + (100 * index));
    });
});
</script>