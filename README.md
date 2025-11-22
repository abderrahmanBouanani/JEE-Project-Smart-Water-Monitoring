# Smart Water Monitoring System 💧

Plateforme de supervision intelligente de la consommation d'eau développée en Jakarta EE, permettant la gestion en temps réel des données IoT, la détection d'anomalies et l'agrégation quotidienne des consommations.

## 📋 Table des matières

- [Description](#description)
- [Fonctionnalités](#fonctionnalités)
- [Architecture](#architecture)
- [Technologies utilisées](#technologies-utilisées)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Configuration](#configuration)
- [Utilisation](#utilisation)
- [Structure du projet](#structure-du-projet)
- [API REST](#api-rest)
- [Simulateur IoT](#simulateur-iot)
- [Tests](#tests)
- [Contributeurs](#contributeurs)

## 📖 Description

Le **Smart Water Monitoring System** est une application web développée dans le cadre du module JEE, permettant aux citoyens et administrateurs de :
- Superviser en temps réel la consommation d'eau via des capteurs IoT
- Recevoir des alertes automatiques en cas d'anomalies (fuites, surconsommation)
- Consulter l'historique et les statistiques de consommation
- Gérer des objectifs de consommation personnalisés
- Bénéficier d'une agrégation quotidienne automatique des données

## ✨ Fonctionnalités

### Pour les Citoyens
- 📊 **Tableau de bord** : Visualisation en temps réel de la consommation
- 📈 **Historique** : Consultation des données historiques avec graphiques
- 🎯 **Objectifs** : Définition d'objectifs mensuels de consommation
- 🔔 **Alertes** : Notifications en cas de fuite ou surconsommation
- 👤 **Profil** : Gestion des informations personnelles

### Pour les Administrateurs
- 🔧 **Gestion des capteurs** : CRUD complet sur les capteurs IoT
- 👥 **Gestion des utilisateurs** : Administration des comptes
- 📉 **Statistiques globales** : Vue d'ensemble du système
- 📋 **Rapports** : Génération de rapports détaillés

### Fonctionnalités techniques
- 🤖 **Collecte IoT** : API REST pour réception des données capteurs
- ⚠️ **Détection automatique** : Algorithmes de détection d'anomalies
- 📅 **Agrégation quotidienne** : Job planifié pour consolidation des données
- 🔐 **Sécurité** : Authentification BCrypt, gestion de sessions, RBAC

## 🏗️ Architecture

Le système adopte une **architecture monolithique en trois couches** :

```
┌─────────────────────────────────────────┐
│     Couche Présentation (JSP/Servlets)  │
├─────────────────────────────────────────┤
│     Couche Métier (Services)            │
├─────────────────────────────────────────┤
│     Couche Données (DAOs/Hibernate)     │
└─────────────────────────────────────────┘
```

### Patterns de conception utilisés
- **DAO (Data Access Object)** : Abstraction de l'accès aux données
- **Service Layer** : Encapsulation de la logique métier
- **MVC (Model-View-Controller)** : Séparation des responsabilités
- **Singleton** : Pour HibernateUtil et jobs planifiés
- **Filter** : Pour l'authentification et contrôle d'accès

## 🛠️ Technologies utilisées

| Couche          | Technologie              | Version     |
|-----------------|--------------------------|-------------|
| **Backend**     | Jakarta EE               | 9.1         |
| **Servlets**    | Jakarta Servlet          | 5.0.0       |
| **JSP**         | Jakarta Server Pages     | 3.0.0       |
| **ORM**         | Hibernate                | 6.4.4       |
| **Base de données** | MySQL                | 8.0         |
| **Sécurité**    | jBCrypt                  | 0.4         |
| **Build**       | Maven                    | 3.x         |
| **Serveur**     | Apache Tomcat / TomEE    | 10.x        |
| **Frontend**    | JSP, Bootstrap, Chart.js | 5.3 / 4.x   |
| **IoT Simulator**| Python                  | 3.8+        |

## 📦 Prérequis

- **Java JDK** : 17 ou supérieur
- **Maven** : 3.8+
- **MySQL** : 8.0+
- **Serveur d'application** : Tomcat 10.x ou TomEE
- **Python** : 3.8+ (pour le simulateur IoT)
- **Git** : Pour cloner le dépôt

## 🚀 Installation

### 1. Cloner le dépôt

```bash
git clone https://github.com/abderrahmanBouanani/JEE-Project-Smart-Water-Monitoring.git
cd JEE-Project-Smart-Water-Monitoring
```

### 2. Configurer la base de données

```sql
-- Créer la base de données
CREATE DATABASE smart_water_monitoring CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Créer un utilisateur
CREATE USER 'water_user'@'localhost' IDENTIFIED BY 'water_password';
GRANT ALL PRIVILEGES ON smart_water_monitoring.* TO 'water_user'@'localhost';
FLUSH PRIVILEGES;
```

### 3. Configurer Hibernate

Copiez le fichier de configuration template et adaptez-le :

```bash
cp src/main/resources/hibernate.cfg.xml.template src/main/resources/hibernate.cfg.xml
```

Éditez `hibernate.cfg.xml` avec vos paramètres :

```xml
<property name="hibernate.connection.url">jdbc:mysql://localhost:3306/smart_water_monitoring</property>
<property name="hibernate.connection.username">water_user</property>
<property name="hibernate.connection.password">water_password</property>
```

### 4. Compiler le projet

```bash
mvn clean install
```

### 5. Déployer sur Tomcat

Copiez le fichier WAR généré :

```bash
cp target/SmartWaterMonitoring-1.0-SNAPSHOT.war $TOMCAT_HOME/webapps/SmartWaterMonitoring.war
```

Ou déployez via votre IDE (IntelliJ IDEA, Eclipse).

### 6. Accéder à l'application

```
http://localhost:8080/SmartWaterMonitoring
```

## ⚙️ Configuration

### Base de données

Le système utilise Hibernate avec génération automatique du schéma (`hbm2ddl.auto=update`). Au premier démarrage, les tables seront créées automatiquement.

### Job d'agrégation

Le job d'agrégation quotidienne s'exécute automatiquement chaque jour à 00:01. Configuration dans `DailyAggregationJob.java`.

### Seuils d'alerte

Les seuils de détection sont configurables dans `AlerteService.java` :
- **Fuite** : Consommation continue > 5 L/h pendant 2h
- **Surconsommation** : > 150% de l'objectif mensuel
- **Anomalie** : Pic soudain > 3x la moyenne

## 📖 Utilisation

### Inscription et connexion

1. Accédez à `/signup.jsp` pour créer un compte
2. Connectez-vous via `/login.jsp`
3. Accédez au tableau de bord selon votre rôle

### Gestion des capteurs (Admin)

```
Menu > Capteurs > Ajouter un capteur
- Référence : CAP-001
- Type : EAU_FROIDE / EAU_CHAUDE / TOTAL
- Utilisateur : Sélectionner un utilisateur
```

### Envoi de données IoT

Utilisez le simulateur Python ou l'API REST :

```bash
python iot_simulator.py --url http://localhost:8080/SmartWaterMonitoring
```

## 📁 Structure du projet

```
SmartWaterMonitoring/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── controller/        # Servlets (AuthServlet, AlerteServlet, etc.)
│   │   │   ├── dao/               # DAOs (UtilisateurDao, CapteurIoTDao, etc.)
│   │   │   ├── filter/            # Filtres (AuthenticationFilter)
│   │   │   ├── model/             # Entités JPA (Utilisateur, CapteurIoT, etc.)
│   │   │   ├── services/          # Services métier
│   │   │   ├── util/              # Utilitaires (HibernateUtil, SecurityUtil)
│   │   │   └── jobs/              # Tâches planifiées
│   │   ├── resources/
│   │   │   ├── hibernate.cfg.xml  # Configuration Hibernate
│   │   │   └── log4j2.xml         # Configuration logging
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── web.xml        # Configuration web
│   │       │   └── views/         # Pages JSP
│   │       ├── login.jsp
│   │       ├── signup.jsp
│   │       └── index.jsp
│   └── test/                      # Tests unitaires
├── iot_simulator.py               # Simulateur IoT Python
├── pom.xml                        # Configuration Maven
└── README.md
```

## 🔌 API REST

### Endpoints IoT

#### POST /api/waterdata
Réception des données de consommation

```json
{
  "capteurId": 1,
  "valeurConsommation": 15.42
}
```

**Réponse** : 200 OK

#### POST /api/alertes
Envoi d'alertes détectées

```json
{
  "capteurId": 1,
  "type": "FUITE_DETECTEE",
  "message": "Suspicion de fuite: Consommation continue..."
}
```

### Endpoints Web (Session requise)

- `GET /dashboard` : Tableau de bord
- `GET /profil` : Profil utilisateur
- `GET /alertes` : Liste des alertes
- `POST /alertes/mark-read` : Marquer comme lu
- `GET /admin/capteurs` : Gestion capteurs (Admin)
- `GET /admin/utilisateurs` : Gestion utilisateurs (Admin)

## 🤖 Simulateur IoT

Le simulateur Python génère des données réalistes de consommation d'eau.

### Installation

```bash
pip install requests
```

### Usage de base

```bash
python iot_simulator.py
```

### Options avancées

```bash
# URL personnalisée et intervalle de 5 secondes
python iot_simulator.py --url http://192.168.1.10:8080/SmartWaterMonitoring --interval 5

# Mode silencieux
python iot_simulator.py --quiet

# Aide
python iot_simulator.py --help
```

### Fonctionnalités du simulateur

- ✅ Génération de données réalistes selon l'heure de la journée
- ✅ Simulation de patterns de consommation (heures de pointe/creuses)
- ✅ Génération aléatoire d'anomalies (3% de probabilité)
- ✅ Support multi-capteurs
- ✅ Récupération automatique des capteurs depuis la DB
- ✅ Gestion d'erreurs et reconnexion automatique

## 🧪 Tests

### Exécuter les tests

```bash
mvn test
```

### Tests unitaires

Les tests couvrent :
- DAOs (CRUD operations)
- Services métier
- Utilitaires (BCrypt, validations)

### Tests d'intégration

Tests manuels recommandés :
1. Inscription et connexion
2. Envoi de données via simulateur
3. Génération d'alertes
4. Agrégation quotidienne (changer l'heure système)

## 👥 Contributeurs

- **Abderrahman BOUANANI** - [GitHub](https://github.com/abderrahmanBouanani)
- **Abou Kekeli EFRAYIM**

**Encadré par** : Pr. Zahrae BENIDER

**École** : ENSA Agadir - Université Ibn Zohr  
**Filière** : DLA2 - Développement Logiciel et Applicatif  
**Année universitaire** : 2025-2026

## 📄 Licence

Ce projet est développé dans un cadre académique pour le module JEE à l'ENSA Agadir.

## 📞 Contact

Pour toute question ou suggestion :
- 📧 Email : a.bouanani2566@uca.ac.ma
- 🎓 Institution : ENSA Agadir

---

**Note** : Ce projet est réalisé à des fins pédagogiques dans le cadre du module Jakarta EE.
