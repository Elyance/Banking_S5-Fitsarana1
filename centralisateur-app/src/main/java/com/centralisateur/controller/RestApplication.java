package com.centralisateur.controller;

import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;

/**
 * Configuration JAX-RS pour les endpoints REST
 * Tous les endpoints seront disponibles sous /api/*
 */
@ApplicationPath("/api")
public class RestApplication extends Application {
    // La classe est vide, les annotations suffisent
    // JAX-RS découvrira automatiquement tous les contrôleurs dans le package
}