<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    .success-container {
        max-width: 700px;
        margin: 50px auto;
        text-align: center;
        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        border-radius: 20px;
        padding: 40px;
        color: white;
        box-shadow: 0 15px 35px rgba(40, 167, 69, 0.3);
    }

    .success-icon {
        font-size: 4rem;
        margin-bottom: 20px;
        animation: bounceIn 1s ease-out;
    }

    .success-title {
        font-size: 2.5rem;
        font-weight: 300;
        margin-bottom: 15px;
    }

    .success-subtitle {
        font-size: 1.2rem;
        opacity: 0.9;
        margin-bottom: 30px;
    }

    .account-details {
        background: rgba(255, 255, 255, 0.15);
        border-radius: 15px;
        padding: 25px;
        margin: 30px 0;
        backdrop-filter: blur(10px);
    }

    .detail-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 12px 0;
        border-bottom: 1px solid rgba(255, 255, 255, 0.2);
    }

    .detail-row:last-child {
        border-bottom: none;
    }

    .detail-label {
        font-weight: 500;
        opacity: 0.9;
    }

    .detail-value {
        font-weight: bold;
        font-size: 1.1rem;
    }

    .highlight-value {
        background: rgba(255, 255, 255, 0.2);
        padding: 8px 15px;
        border-radius: 20px;
        font-family: 'Courier New', monospace;
    }

    .actions {
        margin-top: 40px;
        display: flex;
        gap: 15px;
        justify-content: center;
        flex-wrap: wrap;
    }

    .btn {
        padding: 15px 30px;
        border: none;
        border-radius: 25px;
        font-size: 1.1rem;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-block;
        min-width: 180px;
    }

    .btn-primary {
        background: rgba(255, 255, 255, 0.9);
        color: #28a745;
        border: 2px solid rgba(255, 255, 255, 0.3);
    }

    .btn-primary:hover {
        background: white;
        transform: translateY(-3px);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
    }

    .btn-secondary {
        background: rgba(255, 255, 255, 0.2);
        color: white;
        border: 2px solid rgba(255, 255, 255, 0.4);
    }

    .btn-secondary:hover {
        background: rgba(255, 255, 255, 0.3);
        transform: translateY(-3px);
        border-color: rgba(255, 255, 255, 0.6);
    }

    .btn-outline {
        background: transparent;
        color: white;
        border: 2px solid rgba(255, 255, 255, 0.6);
    }

    .btn-outline:hover {
        background: rgba(255, 255, 255, 0.1);
        transform: translateY(-3px);
    }

    .next-steps {
        margin-top: 40px;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 15px;
        padding: 25px;
        text-align: left;
    }

    .next-steps h4 {
        margin-top: 0;
        margin-bottom: 15px;
        text-align: center;
        color: white;
    }

    .next-steps ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .next-steps li {
        padding: 10px 0;
        padding-left: 30px;
        position: relative;
        opacity: 0.9;
    }

    .next-steps li:before {
        content: "✓";
        position: absolute;
        left: 0;
        color: #20c997;
        font-weight: bold;
        font-size: 1.2rem;
    }

    @keyframes bounceIn {
        0% {
            transform: scale(0.3);
            opacity: 0;
        }
        50% {
            transform: scale(1.1);
            opacity: 0.8;
        }
        100% {
            transform: scale(1);
            opacity: 1;
        }
    }

    @media (max-width: 768px) {
        .success-container {
            margin: 20px;
            padding: 30px 20px;
        }
        
        .success-title {
            font-size: 2rem;
        }
        
        .actions {
            flex-direction: column;
            align-items: center;
        }
        
        .detail-row {
            flex-direction: column;
            text-align: center;
            gap: 10px;
        }
    }
</style>

<div class="success-container">
    <div class="success-icon">
        <i class="fas fa-check-circle"></i>
    </div>
    
    <h1 class="success-title">Compte Prêt Créé !</h1>
    <p class="success-subtitle">${message}</p>
    
    <div class="account-details">
        <div class="detail-row">
            <span class="detail-label">
                <i class="fas fa-hashtag"></i> Numéro de compte
            </span>
            <span class="detail-value highlight-value">${numeroCompte}</span>
        </div>
        
        <div class="detail-row">
            <span class="detail-label">
                <i class="fas fa-user"></i> Titulaire
            </span>
            <span class="detail-value">${clientNom}</span>
        </div>
        
        <c:if test="${not empty montantEmprunte}">
            <div class="detail-row">
                <span class="detail-label">
                    <i class="fas fa-euro-sign"></i> Montant emprunté
                </span>
                <span class="detail-value">${montantEmprunte}€</span>
            </div>
        </c:if>
        
        <c:if test="${not empty dateCreation}">
            <div class="detail-row">
                <span class="detail-label">
                    <i class="fas fa-calendar-day"></i> Date de début
                </span>
                <span class="detail-value">${dateCreation}</span>
            </div>
        </c:if>
        
        <c:if test="${not empty compteId}">
            <div class="detail-row">
                <span class="detail-label">
                    <i class="fas fa-key"></i> ID du compte
                </span>
                <span class="detail-value">#${compteId}</span>
            </div>
        </c:if>
    </div>
    
    <div class="actions">
        <a href="${pageContext.request.contextPath}/compte-pret/details?id=${compteId}" class="btn btn-primary">
            <i class="fas fa-eye"></i> Voir les détails
        </a>
        
        <a href="${pageContext.request.contextPath}/comptes/creer" class="btn btn-secondary">
            <i class="fas fa-plus"></i> Créer un autre compte
        </a>
        
        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline">
            <i class="fas fa-home"></i> Retour au tableau de bord
        </a>
    </div>
</div>

<script>
// Animation d'entrée pour les détails
document.addEventListener('DOMContentLoaded', function() {
    const details = document.querySelectorAll('.detail-row');
    details.forEach((detail, index) => {
        detail.style.opacity = '0';
        detail.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            detail.style.transition = 'all 0.5s ease';
            detail.style.opacity = '1';
            detail.style.transform = 'translateY(0)';
        }, 200 + (index * 100));
    });
});

// Effet de confettis (optionnel)
function createConfetti() {
    const colors = ['#28a745', '#20c997', '#ffffff', '#17a2b8'];
    const confettiCount = 50;
    
    for (let i = 0; i < confettiCount; i++) {
        const confetti = document.createElement('div');
        confetti.style.position = 'fixed';
        confetti.style.width = '10px';
        confetti.style.height = '10px';
        confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
        confetti.style.left = Math.random() * window.innerWidth + 'px';
        confetti.style.top = '-10px';
        confetti.style.opacity = Math.random();
        confetti.style.transform = 'rotate(' + (Math.random() * 360) + 'deg)';
        confetti.style.pointerEvents = 'none';
        confetti.style.zIndex = '9999';
        
        document.body.appendChild(confetti);
        
        // Animation de chute
        let pos = -10;
        const interval = setInterval(() => {
            pos += Math.random() * 3 + 1;
            confetti.style.top = pos + 'px';
            confetti.style.transform += ' rotate(' + (Math.random() * 10 - 5) + 'deg)';
            
            if (pos > window.innerHeight) {
                clearInterval(interval);
                document.body.removeChild(confetti);
            }
        }, 20);
    }
}

// Lancer les confettis après un délai
setTimeout(createConfetti, 500);
</script>