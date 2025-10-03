#!/bin/bash

# Script pour vérifier les logs Tomcat

TOMCAT_LOGS="/home/elyance/Documents/apache-tomcat-10.1.28/logs"

echo "============================="
echo "  VÉRIFICATION DES LOGS TOMCAT"
echo "============================="

echo ""
echo "📋 Logs disponibles:"
ls -la $TOMCAT_LOGS/*.log 2>/dev/null || echo "Aucun fichier .log trouvé"

echo ""
echo "📋 Logs catalina.out (dernières 50 lignes):"
echo "---------------------------------------------"
if [ -f "$TOMCAT_LOGS/catalina.out" ]; then
    tail -50 $TOMCAT_LOGS/catalina.out
else
    echo "Fichier catalina.out non trouvé"
fi

echo ""
echo "📋 Logs localhost (dernières 20 lignes):"
echo "---------------------------------------------"
if [ -f "$TOMCAT_LOGS/localhost."$(date +%Y-%m-%d)".log" ]; then
    tail -20 $TOMCAT_LOGS/localhost.$(date +%Y-%m-%d).log
else
    echo "Fichier localhost du jour non trouvé"
    # Essayer le dernier fichier localhost
    LAST_LOCALHOST=$(ls -t $TOMCAT_LOGS/localhost.*.log 2>/dev/null | head -1)
    if [ -n "$LAST_LOCALHOST" ]; then
        echo "Dernier fichier localhost: $LAST_LOCALHOST"
        tail -20 "$LAST_LOCALHOST"
    fi
fi

echo ""
echo "📋 Filtrer les erreurs (dernières lignes):"
echo "---------------------------------------------"
if [ -f "$TOMCAT_LOGS/catalina.out" ]; then
    grep -i -A 3 -B 1 "error\|exception\|failed" $TOMCAT_LOGS/catalina.out | tail -30
else
    echo "Impossible de filtrer les erreurs"
fi

echo ""
echo "🔍 Pour suivre les logs en temps réel:"
echo "sudo tail -f $TOMCAT_LOGS/catalina.out"