# 🤖 Système d'Automatisation de l'Agrégation des Données

## 📋 Vue d'ensemble

Ce document explique le système automatique qui agrège les données des capteurs (`DonneeCapteur`) en historiques quotidiens (`HistoriqueConsommation`).

---

## 🎯 Objectif

**Problème à résoudre :**
- Les capteurs génèrent des milliers de mesures par jour (toutes les 5 minutes)
- Ces données brutes sont trop volumineuses pour être consultées efficacement
- Il faut des synthèses quotidiennes pour l'affichage et l'analyse

**Solution :**
- Un job automatique s'exécute chaque nuit à 00h30
- Il agrège toutes les données de la veille
- Crée un enregistrement `HistoriqueConsommation` par utilisateur et par jour

---

## 🏗️ Architecture du Système

### Composants créés

```
📦 Système d'Agrégation
├── 🔧 services/
│   └── DataAggregationService.java      ← Service d'agrégation
├── ⏰ jobs/
│   └── DailyAggregationJob.java         ← Planificateur automatique
├── 🌐 controller/
│   └── AggregationServlet.java          ← Interface admin web
├── 🎨 views/admin/
│   └── aggregation.jsp                  ← Page d'administration
└── 🚀 filter/
    └── ApplicationStartupListener.java   ← Démarre le job au lancement
```

---

## 1️⃣ DataAggregationService

### 📍 Emplacement
`src/main/java/services/DataAggregationService.java`

### 🎯 Responsabilités
- Calculer les agrégats à partir des données brutes
- Créer les enregistrements `HistoriqueConsommation`
- Gérer les périodes et éviter les doublons

### 📊 Méthodes principales

#### `aggregerDonneesJournee(LocalDate date)`
Agrège les données pour une date spécifique pour tous les utilisateurs.

```java
// Exemple d'utilisation
DataAggregationService service = new DataAggregationService();
int nbHistoriques = service.aggregerDonneesJournee(LocalDate.of(2025, 11, 12));
// Retourne : 5 (si 5 utilisateurs ont des données ce jour-là)
```

**Processus :**
1. Récupère tous les utilisateurs
2. Pour chaque utilisateur :
   - Vérifie si un historique existe déjà pour cette date
   - Récupère toutes les `DonneeCapteur` de la journée
   - Calcule les agrégats (volume total, coût, moyenne)
   - Crée l'`HistoriqueConsommation`

#### `aggregerDonneesVeille()`
Agrège automatiquement les données de la veille.

```java
service.aggregerDonneesVeille();
// Agrège les données d'hier
```

#### `aggregerPeriode(LocalDate debut, LocalDate fin)`
Agrège les données pour une période (plusieurs jours).

```java
// Rattraper 7 jours manquants
service.aggregerPeriode(
    LocalDate.of(2025, 11, 5),
    LocalDate.of(2025, 11, 11)
);
```

#### `getStatistiquesAggregation()`
Retourne des statistiques sur l'agrégation.

```java
Map<String, Object> stats = service.getStatistiquesAggregation();
// {
//   "nbHistoriques": 365,
//   "nbDonneesNonAggregees": 1250,
//   "derniereDate": "2025-11-11"
// }
```

### 💡 Calculs effectués

Pour chaque utilisateur et chaque jour :

```java
// 1. Volume total (somme de toutes les mesures)
volumeTotal = SUM(DonneeCapteur.valeurConsommation)
// Exemple : 450.5 litres

// 2. Consommation moyenne (par heure)
consommationMoyenne = volumeTotal / 24
// Exemple : 18.8 L/h

// 3. Coût estimé
coutEstime = volumeTotal × PRIX_EAU_PAR_LITRE
// Exemple : 450.5 × 0.00722 = 3.25€
```

### 🛡️ Sécurités

1. **Évite les doublons**
   - Vérifie si un historique existe déjà avant de créer

2. **Gère les erreurs**
   - Transactions : rollback en cas d'erreur
   - Logs détaillés de chaque étape

3. **Filtrage précis**
   - Horodatage >= début journée (00:00:00)
   - Horodatage < début journée suivante (00:00:00)

---

## 2️⃣ DailyAggregationJob

### 📍 Emplacement
`src/main/java/jobs/DailyAggregationJob.java`

### 🎯 Responsabilités
- Planifier l'exécution automatique quotidienne
- Gérer le cycle de vie du scheduler
- Permettre l'exécution manuelle

### ⏰ Configuration

```java
private final LocalTime heureExecution = LocalTime.of(0, 30);
// S'exécute chaque jour à 00h30
```

**Pourquoi 00h30 ?**
- Après minuit pour avoir toutes les données de la veille
- 30 minutes de marge pour les synchronisations IoT
- Heure creuse (peu d'utilisateurs connectés)

### 📊 Méthodes principales

#### `start()`
Démarre le planificateur automatique.

```java
DailyAggregationJob.getInstance().start();
// ⏰ Prochaine exécution dans 8h 25min
```

#### `executerMaintenant()`
Exécute l'agrégation immédiatement (test/debug).

```java
DailyAggregationJob.getInstance().executerMaintenant();
// 🔧 Exécution manuelle de l'agrégation
```

#### `stop()`
Arrête proprement le planificateur.

```java
DailyAggregationJob.getInstance().stop();
// 🛑 Arrêt du planificateur d'agrégation
```

### 🔄 Fonctionnement

```
Application démarre
        ↓
ApplicationStartupListener.contextInitialized()
        ↓
DailyAggregationJob.getInstance().start()
        ↓
Calcul du délai jusqu'à 00h30
        ↓
Planification avec ScheduledExecutorService
        ↓
┌─────────────────────────────┐
│   Chaque jour à 00h30       │
│                             │
│  1. Agrège la veille        │
│  2. Affiche les stats       │
│  3. Log les résultats       │
│  4. Attend 24h              │
└─────────────────────────────┘
```

### 📝 Logs générés

```
═══════════════════════════════════════════════════════
🕐 DÉBUT DE L'AGRÉGATION AUTOMATIQUE - 2025-11-12T00:30:00
═══════════════════════════════════════════════════════

🌙 Agrégation automatique des données de la veille : 2025-11-11
🔄 Début de l'agrégation pour le 2025-11-11
👥 8 utilisateurs trouvés
📊 Agrégation pour John Doe - 2025-11-11
📦 288 mesures trouvées
✅ Historique créé : 450.5L, 3.25€
...

✅ Agrégation terminée : 8 historiques créés

📊 Statistiques :
   - Total historiques : 373
   - Données non agrégées : 0
   - Dernière date agrégée : 2025-11-11

═══════════════════════════════════════════════════════
🏁 FIN DE L'AGRÉGATION AUTOMATIQUE - 2025-11-12T00:30:15
⏰ Prochaine exécution : demain à 00:30
═══════════════════════════════════════════════════════
```

---

## 3️⃣ ApplicationStartupListener

### 📍 Emplacement
`src/main/java/filter/ApplicationStartupListener.java`

### 🎯 Responsabilités
- Démarrer le job au lancement de l'application
- Arrêter le job proprement à l'arrêt

### 🚀 Au démarrage

```java
@Override
public void contextInitialized(ServletContextEvent sce) {
    // 1. Vérification de l'intégrité des données
    EnumDataMigrator.fixInvalidCapteurTypes();
    
    // 2. Démarrage du job d'agrégation
    DailyAggregationJob.getInstance().start();
    // ✅ Tâches automatiques démarrées
}
```

### 🛑 À l'arrêt

```java
@Override
public void contextDestroyed(ServletContextEvent sce) {
    // Arrêt propre du job
    DailyAggregationJob.getInstance().stop();
    // ✅ Tâches automatiques arrêtées
}
```

---

## 4️⃣ AggregationServlet

### 📍 Emplacement
`src/main/java/controller/AggregationServlet.java`

### 🌐 URL
`/admin/aggregation`

### 🎯 Responsabilités
- Interface web pour contrôler l'agrégation
- Accessible uniquement aux administrateurs

### 📊 Actions disponibles

| Action | Type | Description |
|--------|------|-------------|
| **Affichage** | GET | Affiche les statistiques et l'interface |
| **Veille** | POST | Agrège les données d'hier |
| **Période** | POST | Agrège une période spécifique |
| **Maintenant** | GET | Exécute le job immédiatement |
| **Stats** | GET | Rafraîchit les statistiques |

### 🔒 Sécurité

```java
// Vérification du rôle administrateur
if (user.getType() != TypeUtilisateur.ADMINISTRATEUR) {
    response.sendRedirect(request.getContextPath() + "/dashboard");
    return;
}
```

---

## 5️⃣ Page d'Administration (JSP)

### 📍 Emplacement
`src/main/webapp/WEB-INF/views/admin/aggregation.jsp`

### 🎨 Sections de la page

#### 1. Statut du Job
```
┌─────────────────────────────────────┐
│ 📊 Statut du Job Automatique        │
│ ✅ Actif                            │
│ Le job s'exécute chaque nuit à 00h30│
└─────────────────────────────────────┘
```

#### 2. Statistiques
```
┌───────────────┬───────────────┬───────────────┐
│  📚 365       │  ⏰ 0        │  ✅ 2025-11-11│
│  Historiques  │  En attente   │  Dernière date│
└───────────────┴───────────────┴───────────────┘
```

#### 3. Actions rapides

**Agrégation de la veille**
- Bouton "Agréger la Veille"
- Agrège toutes les données d'hier

**Exécution manuelle**
- Bouton "Exécuter Maintenant"
- Lance le job immédiatement

**Agrégation par période**
- Formulaire avec date début/fin
- Utile pour rattraper des jours manquants

---

## 🚀 Utilisation

### Démarrage automatique

Le système démarre automatiquement avec l'application Tomcat :

```
1. Démarrer Tomcat
   ↓
2. ApplicationStartupListener s'exécute
   ↓
3. DailyAggregationJob démarre
   ↓
4. Job planifié pour 00h30
```

### Utilisation manuelle (Admin)

#### Via l'interface web

1. Se connecter en tant qu'administrateur
2. Accéder à `/admin/aggregation`
3. Utiliser les boutons selon le besoin :
   - **Veille** : Agrège hier
   - **Période** : Rattrape plusieurs jours
   - **Maintenant** : Test immédiat

#### Via le code

```java
// Service d'agrégation
DataAggregationService service = new DataAggregationService();

// Agréger une date spécifique
service.aggregerDonneesJournee(LocalDate.of(2025, 11, 10));

// Agréger la veille
service.aggregerDonneesVeille();

// Agréger une période
service.aggregerPeriode(
    LocalDate.of(2025, 11, 1),
    LocalDate.of(2025, 11, 11)
);

// Job automatique
DailyAggregationJob.getInstance().executerMaintenant();
```

---

## 📊 Exemple complet

### Scénario : Lundi 12 novembre 2025 à 00h30

#### Données avant agrégation

**Table `donnees_capteur` (11/11/2025) :**
```
| id | horodatage          | valeur | capteur_id |
|----|---------------------|--------|------------|
| 1  | 2025-11-11 00:05:00 | 12.5   | 1          |
| 2  | 2025-11-11 00:10:00 | 8.3    | 1          |
| 3  | 2025-11-11 00:15:00 | 15.1   | 1          |
...
| 288| 2025-11-11 23:55:00 | 9.7    | 1          |
```
→ 288 mesures (toutes les 5 min) pour le capteur 1 de l'utilisateur John

#### Job s'exécute à 00:30

```
🕐 DÉBUT DE L'AGRÉGATION AUTOMATIQUE - 2025-11-12T00:30:00
🌙 Agrégation pour la veille : 2025-11-11
👥 1 utilisateur trouvé : John Doe

📊 Calculs :
   - 288 mesures trouvées
   - Volume total = 450.5 litres
   - Moyenne = 450.5 / 24 = 18.8 L/h
   - Coût = 450.5 × 0.00722 = 3.25€

✅ Création de l'historique
```

#### Données après agrégation

**Table `historiques_consommation` :**
```
| id | date       | volume_total | conso_moyenne | cout_estime | utilisateur_id |
|----|------------|--------------|---------------|-------------|----------------|
| 1  | 2025-11-11 | 450.5        | 18.8          | 3.25        | 1              |
```

#### Résultat pour l'utilisateur

**Dashboard citoyen :**
```
┌─────────────────────────────────────┐
│ 📊 Consommation d'hier              │
│ 💧 450.5 litres                     │
│ 💰 3.25€                            │
│ 📈 Moyenne : 18.8 L/h               │
└─────────────────────────────────────┘
```

---

## 🔧 Configuration

### Modifier l'heure d'exécution

Dans `DailyAggregationJob.java` :

```java
// Changer de 00h30 à 01h00
private final LocalTime heureExecution = LocalTime.of(1, 0);
```

### Modifier le prix de l'eau

Dans `DataAggregationService.java` :

```java
// Prix actuel : 7.22€/m³
private static final double PRIX_EAU_PAR_LITRE = 0.00722;

// Pour 8€/m³ :
private static final double PRIX_EAU_PAR_LITRE = 0.008;
```

### Désactiver l'agrégation automatique

Dans `ApplicationStartupListener.java`, commenter :

```java
// DailyAggregationJob.getInstance().start();
```

---

## 🐛 Dépannage

### Problème : Le job ne démarre pas

**Vérifier les logs au démarrage de Tomcat :**
```
🚀 Application en démarrage
📅 Démarrage des tâches automatiques...
✅ Tâches automatiques démarrées
```

**Si absent :** Vérifier que `ApplicationStartupListener` est bien détecté (`@WebListener`)

### Problème : Pas d'historiques créés

**Vérifier :**
1. Des utilisateurs existent dans la base
2. Des capteurs sont associés aux utilisateurs
3. Des données capteur existent pour la date
4. Pas d'historique déjà existant pour cette date

**Logs à chercher :**
```
ℹ️ Aucune donnée pour John Doe - 2025-11-11
ℹ️ Historique déjà existant pour John Doe - 2025-11-11
```

### Problème : Données non agrégées qui s'accumulent

**Utiliser l'interface admin :**
1. Aller sur `/admin/aggregation`
2. Vérifier "Données en attente"
3. Utiliser "Agrégation par période" pour rattraper

---

## ✅ Avantages du système

| Avantage | Description |
|----------|-------------|
| 🤖 **Automatique** | Pas d'intervention manuelle requise |
| ⚡ **Performance** | Calculs pré-agrégés = affichage rapide |
| 🔒 **Fiable** | Évite les doublons, gère les erreurs |
| 🎛️ **Contrôlable** | Interface admin pour contrôle manuel |
| 📊 **Traçable** | Logs détaillés de chaque exécution |
| 🔄 **Réparable** | Possibilité de rattraper des jours manquants |

---

## 📅 Roadmap / Améliorations futures

- [ ] **Notification email** en cas d'échec d'agrégation
- [ ] **Compression des anciennes données capteur** (> 6 mois)
- [ ] **Génération de statistiques** automatique après agrégation
- [ ] **Dashboard de monitoring** du job (temps d'exécution, succès/échecs)
- [ ] **Configuration dynamique** de l'heure d'exécution (BDD)
- [ ] **API REST** pour contrôler l'agrégation depuis l'extérieur

---

**Auteur** : GitHub Copilot  
**Date** : 12 novembre 2025  
**Projet** : Smart Water Monitoring  
**Version** : 1.0
