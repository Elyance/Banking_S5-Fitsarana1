#!/bin/bash

# Nom du projet
PROJECT_NAME="centralisateur-app"

# Créer le projet Maven avec l'archétype webapp
mvn archetype:generate -DgroupId=com.exemple -DartifactId=$PROJECT_NAME \
  -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false

# Se déplacer dans le projet
cd $PROJECT_NAME

# Créer les dossiers Java EE standards
mkdir -p src/main/java/com/compte-courant/ejb
mkdir -p src/main/java/com/compte-courant/entity
mkdir -p src/main/java/com/compte-courant/rest
mkdir -p src/main/resources/META-INF

# Créer le fichier persistence.xml
cat <<EOF > src/main/resources/META-INF/persistence.xml
<persistence xmlns="http://jakarta.ee/xml/ns/persistence"
             version="3.0">
  <persistence-unit name="AppPU" transaction-type="JTA">
    <jta-data-source>java:/AppDS</jta-data-source>
  </persistence-unit>
</persistence>
EOF

echo "✅ Structure Jakarta EE créée dans le dossier $PROJECT_NAME"
