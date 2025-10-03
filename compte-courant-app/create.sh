#!/bin/bash

# Création du répertoire lib et copie du servlet-api.jar
mkdir -p lib

projectName="compte_courant"

# Création des répertoires Java et WEB-INF
javaPath="src/main/java"
mkdir -p "$javaPath"

# Création des dossiers MVC dans src/main/java
controllerPath="src/main/java/com/banque/controller"
entityPath="src/main/java/com/banque/entity"
servicePath="src/main/java/com/banque/service"
repositoryPath="src/main/java/com/banque/repository"

mkdir -p "$controllerPath"
mkdir -p "$entityPath"
mkdir -p "$servicePath"
mkdir -p "$repositoryPath"

ressourcesPath="src/main/ressources"
mkdir -p "$ressourcesPath"


webInfPath="src/main/webapp/WEB-INF"
mkdir -p "$webInfPath"

# Création du fichier web.xml
xmlPath="src/main/webapp/WEB-INF/web.xml"


cat > "$xmlPath" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee 
         https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd" 
         version="6.0">
    
    <display-name>Banking Compte Courant Service</display-name>
    
</web-app>

EOF

echo "Fichier XML créé : $xmlPath"

# Création du fichier pom.xml
pomPath="pom.xml"

cat > "$pomPath" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
    http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.compte_courant</groupId>
    <artifactId>Compte_courant</artifactId>
    <version>1.0</version>
    <packaging>war</packaging>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <wildfly.version>31.0.0.Final</wildfly.version>
    </properties>


    <build>
        <finalName>Compte_courant</finalName>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <source>17</source>
                    <target>17</target>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-war-plugin</artifactId>
                <version>3.4.0</version>
                <configuration>
                    <failOnMissingWebXml>false</failOnMissingWebXml>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.wildfly.plugins</groupId>
                <artifactId>wildfly-maven-plugin</artifactId>
                <version>4.2.0.Final</version>
            </plugin>
        </plugins>
    </build>

        <dependencies>
        <!-- Jakarta EE API - fourni par WildFly/JBoss -->
        <dependency>
            <groupId>jakarta.platform</groupId>
            <artifactId>jakarta.jakartaee-api</artifactId>
            <version>9.1.0</version>
            <scope>provided</scope>
        </dependency>
    </dependencies>


</project>

EOF

echo "Fichier POM créé : $pomPath"
read -p "Appuyez sur une touche pour continuer..."