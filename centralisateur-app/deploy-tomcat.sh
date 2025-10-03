#!/bin/bash

# Script de déploiement simple pour Tomcat
# Compile et copie vers Tomcat

TOMCAT_WEBAPPS="/home/elyance/Documents/apache-tomcat-10.1.28/webapps"

APP_NAME="centralisateur-app"

echo "Copie vers Tomcat..."
sudo cp target/$APP_NAME.war $TOMCAT_WEBAPPS/

echo "Déploiement terminé"
echo "URL: http://localhost:8080/$APP_NAME/"