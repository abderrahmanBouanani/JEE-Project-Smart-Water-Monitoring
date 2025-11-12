# 📊 Analyse de l'utilisation des classes Model dans le projet Smart Water Monitoring

## Vue d'ensemble
Ce document présente une analyse complète de l'utilisation de chaque classe du package `model` dans les couches de présentation (JSP) et contrôleurs (Servlets) du projet.

---

## 📦 Classes Model analysées

1. **Utilisateur**
2. **Alerte**
3. **CapteurIoT**
4. **DonneeCapteur**
5. **HistoriqueConsommation**
6. **Statistique**
7. **TypeUtilisateur** (Enum)
8. **TypeAlerte** (Enum)
9. **TypeCapteur** (Enum)
10. **ObjectifConsommation**

---

## 1️⃣ Classe `Utilisateur`

### 📍 Utilisation dans les Servlets

#### **AuthServlet.java**
- **Action** : Authentification et gestion de session
- **Méthodes utilisées** :
  - `login()` : Récupère l'utilisateur par email via `utilisateurService.findByEmail(email)`
  - Vérifie le mot de passe avec `utilisateur.getMotDePasse()`
  - Stocke l'utilisateur en session : `session.setAttribute("user", utilisateur)`
  - Redirige selon le type : `utilisateur.getType()` (ADMINISTRATEUR ou CITOYEN)
- **Attributs accédés** : `email`, `motDePasse`, `type`, `nom`

#### **SignupServlet.java**
- **Action** : Création de nouveaux utilisateurs (inscription)
- **Méthodes utilisées** :
  - Crée un nouvel objet `Utilisateur`
  - `setNom()`, `setEmail()`, `setMotDePasse()`, `setAdresse()`, `setDateInscription()`, `setType()`
  - Par défaut, type = `TypeUtilisateur.CITOYEN`
  - Sauvegarde via `utilisateurService.create(newUser)`

#### **UtilisateurServlet.java**
- **Action** : CRUD complet des utilisateurs (Admin uniquement)
- **Méthodes utilisées** :
  - `findAll()` : Liste tous les utilisateurs
  - `findById(id)` : Récupère un utilisateur spécifique
  - `create()` / `update()` : Gestion des opérations CRUD
- **Vérification de sécurité** : `user.getType() != TypeUtilisateur.ADMINISTRATEUR`

#### **AdminProfilServlet.java**
- **Action** : Gestion du profil administrateur
- **Méthodes utilisées** :
  - `findById()` : Récupère les informations de l'admin connecté
  - `update()` : Mise à jour du profil
- **Attributs accédés** : `idUtilisateur`, `nom`, `email`, `adresse`, `type`, `dateInscription`

#### **ProfilServlet.java** (Citizen)
- **Action** : Gestion du profil citoyen
- **Méthodes similaires** : Récupération et mise à jour des informations personnelles

#### **DashboardServlet.java**, **MesAlertesServlet.java**, etc.
- **Action** : Récupération de l'utilisateur connecté depuis la session
- **Usage** : `Utilisateur user = (Utilisateur) session.getAttribute("user")`
- **Attributs accédés** : `idUtilisateur`, `nom` pour personnalisation

### 📄 Utilisation dans les JSP

#### **login.jsp**
- **Champs du formulaire** :
  - `email` : Champ de saisie pour l'email
  - `password` : Champ de saisie pour le mot de passe
- **Affichage** : Messages d'erreur si authentification échoue

#### **signup.jsp**
- **Champs du formulaire** :
  - `nom` : Nom complet
  - `email` : Adresse email
  - `password` : Mot de passe
  - `adresse` : Adresse postale

#### **dashboard.jsp** (Citizen)
- **Affichage** : `${sessionScope.user.nom}` dans le titre et l'en-tête
- **Usage** : Personnalisation de l'interface utilisateur

#### **utilisateur/list.jsp**
- **Affichage en tableau** :
  - `${utilisateur.idUtilisateur}`
  - `${utilisateur.nom}`
  - `${utilisateur.email}`
  - `${utilisateur.adresse}`
  - `${utilisateur.type}` (Badge coloré selon le rôle)
  - `${utilisateur.dateInscription}`
- **Actions** : Éditer, Supprimer

#### **utilisateur/form.jsp**
- **Formulaire de création/édition** :
  - Tous les champs sont éditables (nom, email, motDePasse, adresse, type)

#### **admin_profil.jsp**
- **Affichage du profil** :
  - `${adminUser.nom}`, `${adminUser.email}`, `${adminUser.adresse}`
  - Mode lecture/édition

---

## 2️⃣ Classe `Alerte`

### 📍 Utilisation dans les Servlets

#### **AlerteServlet.java**
- **Action** : CRUD des alertes (Admin uniquement)
- **Méthodes utilisées** :
  - `findAll()` : Liste toutes les alertes
  - `findById(id)` : Récupère une alerte spécifique
  - `create()` : Création d'une nouvelle alerte
  - `update()` : Mise à jour d'une alerte
  - `delete()` : Suppression d'une alerte
- **Attributs manipulés** : `type`, `message`, `niveauUrgence`, `dateCreation`, `estLue`, `utilisateur`

#### **MesAlertesServlet.java** (Citizen)
- **Action** : Consultation des alertes de l'utilisateur connecté
- **Méthodes utilisées** :
  - `alerteService.findByUserId(user.getIdUtilisateur())` : Alertes de l'utilisateur
  - `alerteService.findUnreadByUserId()` : Alertes non lues
  - `alerteService.marquerCommeLue()` : Marquer une alerte comme lue
- **Actions POST** :
  - `marquer-lue` : Change le statut `estLue`
  - `archiver` : Archive l'alerte

#### **DashboardServlet.java** (Citizen)
- **Action** : Affichage des alertes non lues sur le tableau de bord
- **Méthodes utilisées** :
  - `alerteService.findUnreadByUserId(user.getIdUtilisateur())`
- **Attributs affichés** : Compteur d'alertes non lues

### 📄 Utilisation dans les JSP

#### **alerte/list.jsp**
- **Affichage en tableau** :
  - `${alerte.idAlerte}`
  - `${alerte.type}` : Badge coloré selon le type (SEUIL_DEPASSE, FUITE_DETECTEE, etc.)
  - `${alerte.message}`
  - `${alerte.niveauUrgence}` : Badge (CRITIQUE, ELEVE, MOYEN, FAIBLE)
  - `${alerte.dateCreation}` : Date de création
  - `${alerte.estLue}` : Statut (Lue/Non lue)
  - `${alerte.utilisateur.nom}` : Nom de l'utilisateur concerné
  - `${alerte.donneeCapteur.capteur.reference}` : Référence du capteur (si applicable)
- **Actions** : Éditer, Supprimer

#### **alerte/form.jsp**
- **Formulaire de création/édition** :
  - `type` : Liste déroulante avec les valeurs de l'enum `TypeAlerte`
  - `message` : Zone de texte
  - `niveauUrgence` : Liste déroulante (CRITIQUE, ELEVE, MOYEN, FAIBLE)

#### **mes_alertes.jsp** (Citizen)
- **Affichage des alertes personnelles** :
  - `${alerte.type}` : Badge coloré
  - `${alerte.message}` : Description de l'alerte
  - `${alerte.niveauUrgence}` : Badge d'urgence
  - `${alerte.dateCreation}` : Date
  - `${alerte.estLue}` : Badge Lue/Non lue
- **Actions** :
  - Bouton "Lire" pour marquer comme lue
  - Bouton "Archiver"
  - Bouton "Tout marquer comme lu"

#### **dashboard.jsp** (Citizen)
- **Widget d'alertes** :
  - Affichage du nombre d'alertes non lues
  - Liste des 5 dernières alertes avec aperçu

---

## 3️⃣ Classe `CapteurIoT`

### 📍 Utilisation dans les Servlets

#### **CapteurIoTServlet.java**
- **Action** : CRUD complet des capteurs (Admin uniquement)
- **Méthodes utilisées** :
  - `findAll()` : Liste tous les capteurs
  - `findById(id)` : Récupère un capteur spécifique
  - `create()` : Création d'un nouveau capteur
  - `update()` : Mise à jour d'un capteur
  - `delete()` : Suppression d'un capteur
  - `countActiveByUserId()` : Compte les capteurs actifs d'un utilisateur
- **Attributs manipulés** : `reference`, `type`, `emplacement`, `dateInstallation`, `etat`, `seuilAlerte`, `utilisateur`

#### **DashboardServlet.java** (Citizen)
- **Action** : Affichage des capteurs de l'utilisateur
- **Méthodes utilisées** :
  - `capteurService.findByUserId(user.getIdUtilisateur())`
  - `capteurService.countActiveByUserId(user.getIdUtilisateur())`
- **Affichage** : Statistiques des capteurs (total, actifs)

#### **VisualisationServlet.java** (Citizen)
- **Action** : Visualisation temps réel des capteurs
- **Méthodes utilisées** :
  - `capteurService.findByUserId(user.getIdUtilisateur())`
- **Attributs affichés** : Liste des capteurs avec leurs données récentes

#### **DiagnosticServlet.java** (Admin)
- **Action** : Diagnostic des capteurs
- **Méthodes utilisées** :
  - `capteurService.findAll()`
  - Statistiques par type de capteur
  - Détection de valeurs enum invalides

### 📄 Utilisation dans les JSP

#### **capteur/list.jsp**
- **Statistiques** :
  - `${totalCapteurs}` : Nombre total de capteurs
  - `${capteursActifs}` : Nombre de capteurs actifs
  - `${totalDonnees}` : Nombre total de données enregistrées
- **Affichage en tableau** :
  - `${capteur.idCapteur}`
  - `${capteur.reference}` : Référence unique
  - `${capteur.type}` : Type de capteur (RESIDENTIEL, INDUSTRIEL, etc.)
  - `${capteur.emplacement}` : Localisation
  - `${capteur.dateInstallation}` : Date d'installation
  - `${capteur.etat}` : Actif/Inactif (badge coloré)
  - `${capteur.seuilAlerte}` : Seuil d'alerte configuré
  - `${capteur.utilisateur.nom}` : Propriétaire du capteur
- **Actions** : Éditer, Supprimer, Voir les données

#### **capteur/form.jsp**
- **Formulaire de création/édition** :
  - `reference` : Champ texte
  - `type` : Liste déroulante (TypeCapteur)
  - `emplacement` : Champ texte
  - `dateInstallation` : Champ date
  - `etat` : Case à cocher (Actif/Inactif)
  - `seuilAlerte` : Champ numérique
  - `utilisateur` : Liste déroulante des utilisateurs

#### **visualisation.jsp** (Citizen)
- **Affichage des capteurs** :
  - `${capteur.reference}` : Nom du capteur
  - `${capteur.emplacement}` : Localisation
  - `${capteur.etat}` : Badge Actif/Inactif
  - Graphiques de données en temps réel

#### **dashboard.jsp** (Citizen)
- **Widget de capteurs** :
  - `${totalCapteurs}` : Nombre total de capteurs
  - `${capteursActifs}` : Nombre de capteurs actifs
  - Icônes et cartes statistiques

---

## 4️⃣ Classe `DonneeCapteur`

### 📍 Utilisation dans les Servlets

#### **VisualisationServlet.java** (Citizen)
- **Action** : Affichage des données récentes des capteurs
- **Méthodes utilisées** :
  - `donneeCapteurService.findRecentByUserId(user.getIdUtilisateur())`
- **Attributs utilisés** : `valeur`, `dateReleve`, `capteur`

#### **CapteurIoTServlet.java**
- **Action** : Compte le nombre total de données enregistrées
- **Méthodes utilisées** :
  - `donneeCapteurService.findAll()` pour les statistiques

### 📄 Utilisation dans les JSP

#### **alerte/list.jsp**
- **Affichage conditionnel** :
  - `${alerte.donneeCapteur != null}` : Vérifie si l'alerte est liée à une donnée
  - `${alerte.donneeCapteur.capteur.reference}` : Affiche le capteur source

#### **visualisation.jsp** (Citizen)
- **Affichage des données** :
  - Liste des dernières lectures de capteurs
  - Graphiques temps réel des valeurs mesurées
  - Note : Pas de référence directe dans le JSP analysé, mais utilisé via JavaScript pour les graphiques

---

## 5️⃣ Classe `HistoriqueConsommation`

### 📍 Utilisation dans les Servlets

#### **HistoriqueServlet.java** (Citizen)
- **Action** : Affichage de l'historique de consommation
- **Méthodes utilisées** :
  - `consommationService.findByUserId(user.getIdUtilisateur())`
- **Attributs utilisés** : `date`, `volumeTotal`, `coutEstime`
- **Calculs effectués** :
  - `totalVolume` : Somme des volumes
  - `totalCout` : Somme des coûts
  - `moyenneVolume` : Moyenne des volumes

#### **DashboardServlet.java** (Citizen)
- **Action** : Affichage des 5 derniers historiques sur le tableau de bord
- **Méthodes utilisées** :
  - `historiqueService.findByUserId(user.getIdUtilisateur())`
  - Limitation aux 5 derniers enregistrements
- **Attributs utilisés** : `volumeTotal`, `coutEstime` (pour les statistiques du jour)

### 📄 Utilisation dans les JSP

#### **historique.jsp** (Citizen)
- **Affichage en tableau** :
  - `${h.date}` : Date de la consommation
  - `${h.volumeTotal}` : Volume total en litres
  - `${h.coutEstime}` : Coût estimé en euros
- **Statistiques globales** :
  - `${totalVolume}` : Volume total consommé
  - `${totalCout}` : Coût total
  - `${moyenneVolume}` : Moyenne de consommation

#### **dashboard.jsp** (Citizen)
- **Widget d'historique** :
  - `${consommationJour}` : Consommation du jour
  - `${coutJour}` : Coût du jour
  - Liste des 5 derniers enregistrements

---

## 6️⃣ Classe `Statistique`

### 📍 Utilisation dans les Servlets

#### **StatistiquesServlet.java** (Citizen)
- **Action** : Affichage des statistiques de consommation
- **Méthodes utilisées** :
  - `statistiqueService.findByUserId(user.getIdUtilisateur())`
  - `statistiqueService.getConsommationMoyenneByUserId()`
  - `statistiqueService.getConsommationTotaleByUserId()`
- **Attributs utilisés** : `type`, `valeur`, `periode`, `utilisateur`

### 📄 Utilisation dans les JSP

#### **stats.jsp** (Citizen)
- **Affichage des statistiques** :
  - `${stat.type}` : Type de statistique
  - `${stat.valeur}` : Valeur numérique
  - `${stat.periode}` : Période (quotidien, mensuel, annuel)
- **Graphiques** :
  - `${consommationMoyenne}` : Consommation moyenne
  - `${consommationTotale}` : Consommation totale
  - Données pour graphiques (quotidiennes, mensuelles, moyennes)

---

## 7️⃣ Enum `TypeUtilisateur`

### 📍 Utilisation dans les Servlets

#### **Tous les servlets** (Vérification de sécurité)
- **Usage** : Contrôle d'accès basé sur le rôle
- **Valeurs** :
  - `TypeUtilisateur.ADMINISTRATEUR` : Accès aux pages d'administration
  - `TypeUtilisateur.CITOYEN` : Accès aux pages citoyens
- **Exemple** : `if (user.getType() == TypeUtilisateur.ADMINISTRATEUR)`

#### **SignupServlet.java**
- **Usage** : Attribution du type par défaut lors de l'inscription
- **Valeur** : `TypeUtilisateur.CITOYEN`

### 📄 Utilisation dans les JSP

#### **utilisateur/list.jsp**
- **Affichage** :
  - `${utilisateur.type}` : Affichage du rôle avec badge coloré
  - ADMINISTRATEUR : Badge rouge
  - CITOYEN : Badge bleu

#### **utilisateur/form.jsp**
- **Formulaire** :
  - Liste déroulante pour sélectionner le type d'utilisateur

---

## 8️⃣ Enum `TypeAlerte`

### 📍 Utilisation dans les Servlets

#### **AlerteServlet.java**
- **Usage** : Création et mise à jour des alertes
- **Valeurs possibles** :
  - `SEUIL_DEPASSE` : Seuil de consommation dépassé
  - `FUITE_DETECTEE` : Détection de fuite
  - `CAPTEUR_OFFLINE` : Capteur hors ligne
  - (Autres types selon l'enum)

### 📄 Utilisation dans les JSP

#### **alerte/list.jsp** et **mes_alertes.jsp**
- **Affichage conditionnel** :
  ```jsp
  <c:when test="${alerte.type == 'SEUIL_DEPASSE'}">
      <span class="badge bg-warning">Seuil dépassé</span>
  </c:when>
  <c:when test="${alerte.type == 'FUITE_DETECTEE'}">
      <span class="badge bg-danger">Fuite détectée</span>
  </c:when>
  <c:when test="${alerte.type == 'CAPTEUR_OFFLINE'}">
      <span class="badge bg-secondary">Capteur offline</span>
  </c:when>
  ```

#### **alerte/form.jsp**
- **Formulaire** :
  - Liste déroulante avec toutes les valeurs de l'enum `TypeAlerte`

---

## 9️⃣ Enum `TypeCapteur`

### 📍 Utilisation dans les Servlets

#### **CapteurIoTServlet.java**
- **Usage** : Création et mise à jour des capteurs
- **Valeurs possibles** :
  - `RESIDENTIEL` : Capteur résidentiel
  - `INDUSTRIEL` : Capteur industriel
  - `AGRICOLE` : Capteur agricole
  - `DEBIT_EAU` : Capteur de débit d'eau
  - `QUALITE_EAU` : Capteur de qualité d'eau

#### **DiagnosticServlet.java**
- **Usage** : Vérification des types de capteurs valides
- **Détection** : Valeurs enum invalides en base de données

### 📄 Utilisation dans les JSP

#### **capteur/list.jsp**
- **Affichage** :
  - `${capteur.type}` : Affichage du type de capteur
  - Badges colorés selon le type

#### **capteur/form.jsp**
- **Formulaire** :
  - Liste déroulante avec les valeurs de l'enum `TypeCapteur`
  - `request.setAttribute("typesCapteur", TypeCapteur.values())`

---

## 🔟 Classe `ObjectifConsommation`

### 📍 Utilisation dans les Servlets

**⚠️ CLASSE NON UTILISÉE dans les servlets analysés**

Cette classe semble être prévue pour la gestion des objectifs de consommation, mais n'est actuellement pas implémentée dans les servlets.

### 📄 Utilisation dans les JSP

**⚠️ CLASSE NON UTILISÉE dans les JSP analysés**

Aucune référence à `ObjectifConsommation` n'a été trouvée dans les fichiers JSP.

---

## 📊 Tableau récapitulatif de l'utilisation

| Classe Model | Servlets utilisateurs | JSP utilisateurs | Usage principal |
|--------------|----------------------|------------------|-----------------|
| **Utilisateur** | AuthServlet, SignupServlet, UtilisateurServlet, ProfilServlet, AdminProfilServlet, TOUS (session) | login.jsp, signup.jsp, utilisateur/list.jsp, utilisateur/form.jsp, admin_profil.jsp, dashboard.jsp | Authentification, gestion des comptes, personnalisation |
| **Alerte** | AlerteServlet, MesAlertesServlet, DashboardServlet | alerte/list.jsp, alerte/form.jsp, mes_alertes.jsp, dashboard.jsp | Gestion des alertes, notifications |
| **CapteurIoT** | CapteurIoTServlet, DashboardServlet, VisualisationServlet, DiagnosticServlet | capteur/list.jsp, capteur/form.jsp, visualisation.jsp, dashboard.jsp | Gestion des capteurs, monitoring |
| **DonneeCapteur** | VisualisationServlet, CapteurIoTServlet | alerte/list.jsp, visualisation.jsp | Affichage des mesures |
| **HistoriqueConsommation** | HistoriqueServlet, DashboardServlet | historique.jsp, dashboard.jsp | Suivi de la consommation |
| **Statistique** | StatistiquesServlet | stats.jsp | Analyses et graphiques |
| **TypeUtilisateur** | TOUS (sécurité), SignupServlet | utilisateur/list.jsp, utilisateur/form.jsp | Contrôle d'accès |
| **TypeAlerte** | AlerteServlet | alerte/list.jsp, alerte/form.jsp, mes_alertes.jsp | Classification des alertes |
| **TypeCapteur** | CapteurIoTServlet, DiagnosticServlet | capteur/list.jsp, capteur/form.jsp | Classification des capteurs |
| **ObjectifConsommation** | ❌ Non utilisé | ❌ Non utilisé | Fonctionnalité non implémentée |

---

## 🔒 Patterns de sécurité identifiés

### 1. **Vérification de session**
```java
HttpSession session = request.getSession(false);
if (session == null || session.getAttribute("user") == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}
```

### 2. **Contrôle d'accès basé sur le rôle**
```java
Utilisateur user = (Utilisateur) session.getAttribute("user");
if (user.getType() != TypeUtilisateur.ADMINISTRATEUR) {
    response.sendRedirect(request.getContextPath() + "/dashboard");
    return;
}
```

### 3. **Isolation des données par utilisateur**
```java
List<Alerte> alertes = alerteService.findByUserId(user.getIdUtilisateur());
```

---

## 📈 Flux de données typiques

### Flux d'authentification
1. **login.jsp** → Formulaire avec `email` et `password`
2. **AuthServlet** → Récupère `Utilisateur` via email
3. Vérifie mot de passe et type d'utilisateur
4. Stocke `Utilisateur` en session
5. Redirige vers **dashboard** (citoyen) ou **index.jsp** (admin)

### Flux de consultation d'alertes (Citoyen)
1. **mes_alertes.jsp** → Demande d'affichage des alertes
2. **MesAlertesServlet** → Récupère `Utilisateur` de la session
3. Service → `findByUserId(user.getIdUtilisateur())`
4. Retourne liste de `Alerte` filtrée par utilisateur
5. **mes_alertes.jsp** → Affiche les alertes avec formatage conditionnel

### Flux de gestion des capteurs (Admin)
1. **capteur/list.jsp** → Affichage de tous les capteurs
2. **CapteurIoTServlet** → Vérifie que l'utilisateur est ADMINISTRATEUR
3. Service → `findAll()` pour récupérer tous les `CapteurIoT`
4. Calcul des statistiques (total, actifs)
5. **capteur/list.jsp** → Affiche tableau avec actions CRUD

---

## 🛠️ Recommandations

### ✅ Points forts
- ✔️ Séparation claire entre les rôles (Admin/Citoyen)
- ✔️ Isolation des données par utilisateur (sécurité)
- ✔️ Utilisation cohérente des enums pour la classification
- ✔️ Patterns de sécurité bien appliqués

### ⚠️ Points à améliorer
- ⚠️ `ObjectifConsommation` : Classe non utilisée, à implémenter ou supprimer
- ⚠️ Hachage des mots de passe : Actuellement stockés en clair (commenté dans le code)
- ⚠️ Validation des données : Peu de validation côté serveur
- ⚠️ Gestion des erreurs : Pourrait être plus robuste

### 🚀 Fonctionnalités à développer
- 📌 Implémentation complète de `ObjectifConsommation`
- 📌 Système de notifications push pour les alertes
- 📌 Exportation des données (historique, statistiques)
- 📌 Dashboard administrateur plus complet
- 📌 API REST pour intégration mobile

---

## 📝 Conclusion

Le projet **Smart Water Monitoring** présente une architecture bien structurée avec une utilisation cohérente des classes model dans les couches de présentation et contrôle. Les patterns MVC sont respectés, et la séparation des responsabilités est claire. 

La sécurité est globalement bien gérée avec un contrôle d'accès basé sur les rôles et une isolation des données par utilisateur. Cependant, certaines fonctionnalités restent à implémenter (comme `ObjectifConsommation`) et des améliorations de sécurité sont recommandées (hachage des mots de passe).

Le projet est prêt pour une utilisation en environnement de développement, mais nécessite des améliorations avant une mise en production.

---

**Date d'analyse** : 12 novembre 2025  
**Analysé par** : GitHub Copilot  
**Version du projet** : Branche `feat-MesAlertesServlet-mes_alertes.jsp`

