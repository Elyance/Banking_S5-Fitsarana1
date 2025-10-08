<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="content-header">
    <h1 class="m-0">Création de Compte</h1>
    <ol class="breadcrumb float-sm-right">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard">Accueil</a></li>
        <li class="breadcrumb-item active">Création de Compte</li>
    </ol>
</div>

<style>
    .account-creation-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 2rem;
    }

    .creation-card {
        background: white;
        border-radius: 12px;
        padding: 2rem;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        border: 1px solid #e2e8f0;
    }

    .creation-header {
        text-align: center;
        margin-bottom: 3rem;
    }

    .creation-header h2 {
        font-size: 2rem;
        font-weight: 600;
        color: #1e293b;
        margin-bottom: 0.5rem;
    }

    .creation-header .subtitle {
        color: #64748b;
        font-size: 1rem;
    }

    .account-type-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 2rem;
        margin-bottom: 2rem;
    }

    .account-type-card {
        background: linear-gradient(135deg, #f8fafc, #f1f5f9);
        border: 3px solid #e2e8f0;
        border-radius: 12px;
        padding: 2rem;
        text-align: center;
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
    }

    .account-type-card:hover {
        border-color: #3b82f6;
        box-shadow: 0 8px 25px rgba(59, 130, 246, 0.15);
        transform: translateY(-3px);
    }

    .account-type-card.active {
        border-color: #3b82f6;
        background: linear-gradient(135deg, #eff6ff, #dbeafe);
        box-shadow: 0 8px 25px rgba(59, 130, 246, 0.2);
    }

    .account-type-card.disabled {
        opacity: 0.5;
        cursor: not-allowed;
        background: #f9fafb;
    }

    .account-type-card.disabled:hover {
        border-color: #e2e8f0;
        box-shadow: none;
        transform: none;
    }

    .account-type-icon {
        font-size: 3rem;
        margin-bottom: 1rem;
        color: #3b82f6;
        transition: color 0.3s ease;
    }

    .account-type-card.active .account-type-icon {
        color: #2563eb;
    }

    .account-type-name {
        font-size: 1.2rem;
        font-weight: 600;
        color: #1e293b;
        margin-bottom: 0.5rem;
    }

    .account-type-description {
        color: #64748b;
        font-size: 0.9rem;
        line-height: 1.4;
        margin-bottom: 1.5rem;
    }

    .account-type-button {
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: white;
        border: none;
        padding: 0.75rem 1.5rem;
        border-radius: 8px;
        font-weight: 600;
        text-decoration: none;
        display: inline-block;
        transition: all 0.3s ease;
        width: 100%;
    }

    .account-type-button:hover {
        background: linear-gradient(135deg, #2563eb, #1d4ed8);
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        color: white;
        text-decoration: none;
    }

    .account-type-button.disabled {
        background: #6b7280;
        cursor: not-allowed;
    }

    .account-type-button.disabled:hover {
        background: #6b7280;
        transform: none;
        box-shadow: none;
    }

    .disabled-badge {
        position: absolute;
        top: 10px;
        right: 10px;
        background: #ef4444;
        color: white;
        padding: 0.25rem 0.5rem;
        border-radius: 4px;
        font-size: 0.75rem;
        font-weight: 600;
    }

    .back-button {
        text-align: center;
        margin-top: 2rem;
    }

    .back-button a {
        color: #6b7280;
        text-decoration: none;
        font-weight: 500;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        transition: color 0.3s ease;
    }

    .back-button a:hover {
        color: #3b82f6;
    }

    @media (max-width: 768px) {
        .account-creation-container {
            padding: 1rem;
        }

        .creation-card {
            padding: 1.5rem;
        }

        .account-type-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="account-creation-container">
    <div class="creation-card">
        <div class="creation-header">
            <h2><i class="fas fa-plus-circle"></i> Création de Compte</h2>
            <p class="subtitle">Choisissez le type de compte à créer</p>
        </div>

        <div class="account-type-grid">
            <!-- Compte Courant -->
            <div class="account-type-card active">
                <div class="account-type-icon">
                    <i class="fas fa-credit-card"></i>
                </div>
                <div class="account-type-name">Compte Courant</div>
                <div class="account-type-description">
                    Compte de dépôt classique avec possibilité de découvert autorisé
                </div>
                <a href="${pageContext.request.contextPath}/compte-courant/creer" class="account-type-button">
                    <i class="fas fa-arrow-right me-2"></i>Créer un Compte Courant
                </a>
            </div>

            <!-- Compte Prêt -->
            <div class="account-type-card active">
                <div class="account-type-icon">
                    <i class="fas fa-hand-holding-usd"></i>
                </div>
                <div class="account-type-name">Compte Prêt</div>
                <div class="account-type-description">
                    Prêt personnel ou immobilier avec échéancier de remboursement
                </div>
                <a href="${pageContext.request.contextPath}/compte-pret/creer" class="account-type-button">
                    <i class="fas fa-arrow-right me-2"></i>Créer un Compte Prêt
                </a>
            </div>

            <!-- Compte Épargne (désactivé) -->
            <div class="account-type-card disabled">
                <div class="disabled-badge">Bientôt</div>
                <div class="account-type-icon">
                    <i class="fas fa-piggy-bank"></i>
                </div>
                <div class="account-type-name">Compte Épargne</div>
                <div class="account-type-description">
                    Compte d'épargne avec taux d'intérêt (fonctionnalité à venir)
                </div>
                <span class="account-type-button disabled">
                    <i class="fas fa-clock me-2"></i>Bientôt disponible
                </span>
            </div>
        </div>

        <div class="back-button">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-arrow-left"></i> Retour au tableau de bord
            </a>
        </div>
    </div>
</div>