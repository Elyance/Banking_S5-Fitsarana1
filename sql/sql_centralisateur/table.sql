
-- Script de création de la base de données PostgreSQL
-- Application de gestion des comptes courants bancaires

-- =====================================================
-- CRÉATION DE LA BASE DE DONNÉES
-- =====================================================

CREATE DATABASE centralisateur_db;

\c centralisateur_db;

-- =====================================================
-- TABLES DE RÉFÉRENCE
-- =====================================================

CREATE TABLE IF NOT EXISTS statut_client (
    id BIGSERIAL PRIMARY KEY,
    libelle VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLES PRINCIPALES
-- =====================================================

CREATE TABLE IF NOT EXISTS client (
    id BIGSERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    telephone VARCHAR(20),
    adresse TEXT,
    date_naissance DATE,
    profession VARCHAR(100),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS mvt_client (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT NOT NULL,
    statut_client_id BIGINT NOT NULL,
    description TEXT,
    date_mvt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


