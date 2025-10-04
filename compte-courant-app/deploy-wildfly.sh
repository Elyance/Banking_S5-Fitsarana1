#!/bin/bash

# Configuration pour WildFly
WILDFLY_HOME="/opt/wildfly"
PROJECT_NAME="compte-courant-app"
WAR_FILE="target/${PROJECT_NAME}.war"

echo "🧹 [INFO] Suppression du répertoire target..."
rm -rf target/

echo "🔨 [INFO] Compilation avec Maven..."
mvn clean package

echo "🚀 [INFO] Déploiement vers WildFly..."

if [ -f "$WAR_FILE" ]; then
    # Supprimer l'ancien déploiement s'il existe
    rm -f "$WILDFLY_HOME/standalone/deployments/${PROJECT_NAME}.war"
    rm -f "$WILDFLY_HOME/standalone/deployments/${PROJECT_NAME}.war.deployed"
    rm -f "$WILDFLY_HOME/standalone/deployments/${PROJECT_NAME}.war.failed"
    rm -rf "$WILDFLY_HOME/standalone/deployments/${PROJECT_NAME}.war.undeployed"
    
    # Copier le nouveau fichier WAR
    cp "$WAR_FILE" "$WILDFLY_HOME/standalone/deployments/"
    
    echo "✅ [SUCCESS] Fichier WAR copié avec succès vers WildFly deployments."
    echo "📂 [INFO] Fichier déployé : $WILDFLY_HOME/standalone/deployments/${PROJECT_NAME}.war"
    echo ""
    echo "🌐 [INFO] Accès à l'application :"
    echo "   URL: http://localhost:6060/${PROJECT_NAME}/"
    echo "   Admin Console: http://localhost:9990"
    echo ""
    echo "📝 [INFO] Pour vérifier le déploiement, consultez les logs WildFly :"
    echo "   tail -f $WILDFLY_HOME/standalone/log/server.log"
else
    echo "❌ [ERROR] Fichier WAR non trouvé dans le répertoire target."
    echo "🔍 [INFO] Fichiers disponibles dans target/ :"
    ls -la target/ 2>/dev/null || echo "   Aucun fichier trouvé."
fi