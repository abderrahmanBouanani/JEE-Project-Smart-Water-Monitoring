# 🚀 Guide de Démarrage Rapide - Système d'Agrégation Automatique

## ✅ Ce qui a été créé

Votre projet dispose maintenant d'un **système d'automatisation complet** pour agréger les données des capteurs en historiques quotidiens.

---

## 📦 Fichiers créés

### 1. Services
- ✅ `src/main/java/services/DataAggregationService.java`
  - Service d'agrégation des données
  - Méthodes pour agréger par jour, par période
  - Calcul des statistiques

### 2. Jobs Automatiques
- ✅ `src/main/java/jobs/DailyAggregationJob.java`
  - Planificateur automatique
  - S'exécute chaque nuit à 00h30
  - Gestion du cycle de vie

### 3. Contrôleur Web
- ✅ `src/main/java/controller/AggregationServlet.java`
  - Interface web pour les admins
  - Contrôle manuel de l'agrégation
  - URL : `/admin/aggregation`

### 4. Interface Admin
- ✅ `src/main/webapp/WEB-INF/views/admin/aggregation.jsp`
  - Page d'administration
  - Statistiques en temps réel
  - Actions manuelles

### 5. Listener de Démarrage
- ✅ `src/main/java/filter/ApplicationStartupListener.java` (modifié)
  - Démarre le job automatiquement
  - Arrête proprement à la fermeture

### 6. Page d'accueil Admin
- ✅ `src/main/webapp/index.jsp` (modifié)
  - Lien vers l'agrégation
  - Lien vers le diagnostic

### 7. Documentation
- ✅ `EXPLICATION_CLASSES_DONNEES.md`
  - Explique la différence entre les classes
- ✅ `DOCUMENTATION_SYSTEME_AGREGATION.md`
  - Documentation technique complète

---

## 🎯 Comment ça fonctionne

### Automatique (Production)

```
1. Vous démarrez Tomcat
        ↓
2. ApplicationStartupListener s'exécute
        ↓
3. DailyAggregationJob démarre automatiquement
        ↓
4. Chaque nuit à 00h30 :
   - Récupère toutes les DonneeCapteur de la veille
   - Calcule les agrégats (volume, coût, moyenne)
   - Crée les HistoriqueConsommation
        ↓
5. Les utilisateurs voient leurs historiques sur le dashboard
```

### Manuel (Admin)

```
1. Se connecter en tant qu'admin
        ↓
2. Aller sur la page d'accueil admin
        ↓
3. Cliquer sur "Agrégation des Données"
        ↓
4. Utiliser les boutons :
   - "Agréger la Veille" : Pour hier
   - "Exécuter Maintenant" : Test immédiat
   - "Agrégation par Période" : Rattraper plusieurs jours
```

---

## 🚀 Test du système

### Étape 1 : Vérifier le démarrage

1. **Démarrer Tomcat**

2. **Chercher dans les logs :**
```
🚀 Application en démarrage
...
📅 Démarrage des tâches automatiques...
🚀 Démarrage du planificateur d'agrégation quotidienne
⏰ Heure d'exécution configurée : 00:30
⏳ Prochaine exécution dans XXX minutes
✅ Planificateur démarré avec succès
✅ Tâches automatiques démarrées
```

✅ **Si vous voyez ces logs, le système fonctionne !**

### Étape 2 : Créer des données de test

Pour tester, vous devez avoir :

1. **Un utilisateur** (citoyen)
2. **Un capteur** associé à cet utilisateur
3. **Des données capteur** pour une journée

**Exemple SQL pour insérer des données de test :**

```sql
-- 1. Vérifier qu'on a un utilisateur (ID=1)
SELECT * FROM utilisateurs WHERE id_utilisateur = 1;

-- 2. Vérifier qu'on a un capteur pour cet utilisateur
SELECT * FROM capteurs WHERE utilisateur_id = 1;

-- 3. Insérer des données capteur pour hier
-- (Remplacer HIER par la date d'hier au format 'YYYY-MM-DD HH:MM:SS')

INSERT INTO donnees_capteur (horodatage, valeur_consommation, unite, capteur_id)
VALUES 
  ('2025-11-11 08:00:00', 12.5, 'litres', 1),
  ('2025-11-11 08:30:00', 15.3, 'litres', 1),
  ('2025-11-11 09:00:00', 18.7, 'litres', 1),
  ('2025-11-11 09:30:00', 14.2, 'litres', 1),
  ('2025-11-11 10:00:00', 16.8, 'litres', 1);
-- ... Ajouter plus de lignes pour simuler une journée complète
```

### Étape 3 : Tester l'agrégation manuelle

1. **Se connecter en tant qu'admin**
   - URL : `http://localhost:8080/votre-app/login.jsp`

2. **Accéder à la page d'agrégation**
   - Cliquer sur "Agrégation des Données" depuis la page d'accueil
   - Ou aller directement sur : `http://localhost:8080/votre-app/admin/aggregation`

3. **Cliquer sur "Agréger la Veille"**

4. **Vérifier le message de succès**
   ```
   ✅ Agrégation réussie : 1 historiques créés pour la veille
   ```

5. **Vérifier dans la base de données**
   ```sql
   SELECT * FROM historiques_consommation;
   ```

   Vous devriez voir :
   ```
   | id | date       | volume_total | conso_moyenne | cout_estime | utilisateur_id |
   |----|------------|--------------|---------------|-------------|----------------|
   | 1  | 2025-11-11 | 77.5         | 3.23          | 0.56        | 1              |
   ```

### Étape 4 : Vérifier dans le dashboard citoyen

1. **Se connecter en tant que citoyen** (l'utilisateur qui a le capteur)

2. **Aller sur le dashboard**

3. **Vérifier la section "Historique Récent"**
   - Vous devriez voir la ligne avec la date d'hier
   - Volume total, coût estimé

---

## 📊 Vérifications importantes

### ✅ Checklist de validation

- [ ] Le job démarre automatiquement avec Tomcat
- [ ] Les logs de démarrage sont présents
- [ ] La page `/admin/aggregation` est accessible (admin uniquement)
- [ ] L'agrégation manuelle fonctionne
- [ ] Les historiques sont créés dans la base
- [ ] Les utilisateurs voient leurs historiques sur le dashboard
- [ ] Pas de doublons (réexécuter l'agrégation pour la même date ne duplique pas)

---

## 🐛 Dépannage

### Problème 1 : Le job ne démarre pas

**Symptôme :** Pas de logs "Planificateur démarré"

**Solution :**
1. Vérifier que `@WebListener` est présent sur `ApplicationStartupListener`
2. Recompiler le projet
3. Redémarrer Tomcat complètement

### Problème 2 : Aucun historique créé

**Symptôme :** Message "0 historiques créés"

**Causes possibles :**
1. **Pas de données capteur** pour la date
   - Vérifier : `SELECT * FROM donnees_capteur WHERE DATE(horodatage) = 'YYYY-MM-DD'`

2. **Historique déjà existant**
   - Vérifier : `SELECT * FROM historiques_consommation WHERE date = 'YYYY-MM-DD'`

3. **Capteur non associé à un utilisateur**
   - Vérifier : `SELECT * FROM capteurs WHERE utilisateur_id IS NULL`

**Solution :** Insérer des données de test (voir Étape 2)

### Problème 3 : Page /admin/aggregation non accessible

**Symptôme :** 404 ou redirection

**Solution :**
1. Vérifier que vous êtes connecté en tant qu'ADMINISTRATEUR
2. Vérifier l'URL : `http://localhost:8080/NomDuProjet/admin/aggregation`
3. Vérifier que `AggregationServlet` est compilé

### Problème 4 : Erreur "LazyInitializationException"

**Symptôme :** Erreur lors de l'accès à `capteur.utilisateur`

**Solution :** Utiliser les requêtes HQL avec `JOIN FETCH` dans les DAO

---

## 🎨 Personnalisation

### Changer l'heure d'exécution

**Fichier :** `src/main/java/jobs/DailyAggregationJob.java`

```java
// Ligne 23 - Changer de 00:30 à l'heure souhaitée
private final LocalTime heureExecution = LocalTime.of(2, 0); // 02h00
```

### Changer le prix de l'eau

**Fichier :** `src/main/java/services/DataAggregationService.java`

```java
// Ligne 33 - Modifier le prix
private static final double PRIX_EAU_PAR_LITRE = 0.010; // 10€/m³
```

### Désactiver l'agrégation automatique

**Fichier :** `src/main/java/filter/ApplicationStartupListener.java`

```java
// Ligne 28 - Commenter cette ligne
// DailyAggregationJob.getInstance().start();
```

---

## 📚 Documentation

### Documents créés

1. **`EXPLICATION_CLASSES_DONNEES.md`**
   - Explique pourquoi 4 classes différentes (CapteurIoT, DonneeCapteur, HistoriqueConsommation, Statistique)
   - Schémas et exemples concrets

2. **`DOCUMENTATION_SYSTEME_AGREGATION.md`**
   - Documentation technique complète
   - Architecture du système
   - API et utilisation

3. **`GUIDE_DEMARRAGE_AGREGATION.md`** (ce fichier)
   - Guide rapide pour tester
   - Checklist de validation

---

## 🎓 Concepts clés

### Granularité des données

```
CapteurIoT           → Métadonnées du dispositif
        ↓
DonneeCapteur        → Mesures en temps réel (5 min)
        ↓ (agrégation)
HistoriqueConsommation → Synthèse quotidienne
        ↓ (analyse)
Statistique          → Tendances et insights
```

### Pourquoi agréger ?

1. **Performance** : Au lieu de calculer sur 288 mesures, lire 1 ligne
2. **Stockage** : Supprimer les vieilles mesures brutes, garder les synthèses
3. **Analyse** : Comparer facilement jour par jour, mois par mois

### Exemple chiffré

**Sans agrégation :**
- 1 capteur × 288 mesures/jour × 365 jours = 105 120 lignes/an
- Requête lente pour afficher l'historique de l'année

**Avec agrégation :**
- 1 utilisateur × 1 historique/jour × 365 jours = 365 lignes/an
- Requête instantanée + possibilité de supprimer les mesures brutes après 6 mois

---

## ✅ Prochaines étapes

Maintenant que l'agrégation fonctionne :

1. **Tester avec des données réelles**
   - Connecter de vrais capteurs IoT
   - Laisser tourner 24h
   - Vérifier l'agrégation automatique le lendemain

2. **Créer des statistiques**
   - Implémenter un job similaire pour `Statistique`
   - Calculer moyennes mensuelles, tendances, etc.

3. **Optimiser les performances**
   - Ajouter des index sur les tables
   - Archiver/supprimer les vieilles données capteur

4. **Ajouter des alertes**
   - Notification si le job échoue
   - Email hebdomadaire avec les statistiques

5. **API REST**
   - Exposer les historiques via API
   - Application mobile pour consulter

---

## 🎉 Félicitations !

Votre système dispose maintenant d'une **automatisation professionnelle** pour :
- ✅ Agréger les données quotidiennement
- ✅ Gérer manuellement si besoin
- ✅ Monitorer via l'interface admin
- ✅ Éviter les doublons et gérer les erreurs

Le système s'exécutera automatiquement chaque nuit sans intervention !

---

**Questions ou problèmes ?**
- Consultez `DOCUMENTATION_SYSTEME_AGREGATION.md` pour plus de détails
- Vérifiez les logs Tomcat pour le diagnostic
- Utilisez l'interface admin `/admin/aggregation` pour le contrôle

**Date de création :** 12 novembre 2025  
**Auteur :** GitHub Copilot  
**Projet :** Smart Water Monitoring
