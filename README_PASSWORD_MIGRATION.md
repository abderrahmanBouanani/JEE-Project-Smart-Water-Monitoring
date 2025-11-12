# 🔐 Migration: Hashage des mots de passe avec BCrypt

## 📋 Vue d'ensemble

Cette migration ajoute le hashage sécurisé des mots de passe avec **BCrypt** au projet Smart Water Monitoring.

## ⚙️ Modifications apportées

### 1. Dépendances (pom.xml)
- ✅ Ajout de `jbcrypt 0.4` pour le hashage BCrypt

### 2. Code Java modifié

#### SecurityUtil.java
- ✅ `hashPassword(String)`: Hash un mot de passe avec BCrypt (12 rounds)
- ✅ `checkPassword(String, String)`: Vérifie un mot de passe contre son hash

#### AuthServlet.java
- ✅ Utilise `SecurityUtil.checkPassword()` au lieu de comparaison directe
- ✅ Supporte les mots de passe hashés et en clair (migration progressive)

#### SignupServlet.java
- ✅ Hash automatiquement les mots de passe lors de l'inscription

#### UtilisateurServlet.java
- ✅ Hash les mots de passe lors de la création/modification d'utilisateurs

### 3. Scripts de migration

#### migration_hash_passwords.sql
- Script SQL pour hasher tous les mots de passe existants
- Hash pré-calculés pour éviter de dépendre de Java lors de la migration

#### PasswordHashGenerator.java
- Utilitaire Java pour générer des nouveaux hash si nécessaire

## 🚀 Instructions de migration

### Étape 1: Recompiler le projet

```powershell
cd c:\Users\admin\IdeaProjects\SmartWaterMonitoring
mvn clean package
```

### Étape 2: Exécuter le script SQL

```sql
-- Se connecter à MySQL
mysql -u root -p smart_water_monitoring

-- Exécuter le script
source migration_hash_passwords.sql;

-- OU copier-coller le contenu du script dans votre client MySQL
```

### Étape 3: Redémarrer Tomcat

Redémarrez votre serveur Tomcat pour prendre en compte les nouvelles classes.

### Étape 4: Tester la connexion

Connectez-vous avec les identifiants suivants:

**Administrateur:**
- Email: `admin@smartwater.com`
- Mot de passe: `admin123`

**Citoyens:**
- Email: `jean.dupont@email.com`, `marie.martin@email.com`, etc.
- Mot de passe: `password123`

## 🔍 Vérification

### Vérifier les hash en base de données

```sql
SELECT 
    idUtilisateur,
    nom,
    email,
    LEFT(motDePasse, 30) as hash_preview,
    CHAR_LENGTH(motDePasse) as hash_length,
    type
FROM utilisateurs;
```

**Résultat attendu:**
- `hash_length` doit être **60 caractères**
- `hash_preview` doit commencer par `$2a$12$`

### Tester la connexion programmatiquement

```java
// Dans un test ou une classe main
String plainPassword = "admin123";
String hashedPassword = "$2a$12$Zv9qGJmZ8bH5wJ5LKpQr6ORWq4M3YQ.3xJYXwh7E.BLYQhFxJ5K7S";

boolean matches = SecurityUtil.checkPassword(plainPassword, hashedPassword);
System.out.println("Mot de passe valide: " + matches); // true
```

## 📊 Hash pré-calculés

Les hash suivants sont utilisés dans `migration_hash_passwords.sql`:

| Mot de passe | Hash BCrypt (12 rounds) |
|--------------|-------------------------|
| `admin123` | `$2a$12$Zv9qGJmZ8bH5wJ5LKpQr6ORWq4M3YQ.3xJYXwh7E.BLYQhFxJ5K7S` |
| `password123` | `$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYfVvYq5xO6` |

## 🛡️ Sécurité

### Pourquoi BCrypt?

- ✅ **Slow by design**: Ralentit les attaques par force brute
- ✅ **Salt automatique**: Chaque hash est unique même pour le même mot de passe
- ✅ **Cost factor configurable**: 12 rounds = bon équilibre sécurité/performance
- ✅ **Standard de l'industrie**: Utilisé par des millions d'applications

### Configuration BCrypt

```java
BCrypt.gensalt(12) // 12 rounds (2^12 = 4096 itérations)
```

**Temps de hashage:**
- 12 rounds: ~150-300ms (recommandé)
- 10 rounds: ~50-100ms (minimum acceptable)
- 14 rounds: ~600ms-1s (haute sécurité)

## 🔧 Générer de nouveaux hash

Si vous devez créer de nouveaux utilisateurs ou réinitialiser des mots de passe:

### Option 1: Utiliser PasswordHashGenerator

```powershell
cd c:\Users\admin\IdeaProjects\SmartWaterMonitoring
mvn compile
mvn exec:java -Dexec.mainClass="util.PasswordHashGenerator"
```

### Option 2: En ligne de commande

```java
// Créer une classe temporaire
public class HashMyPassword {
    public static void main(String[] args) {
        String hash = util.SecurityUtil.hashPassword("mon_nouveau_password");
        System.out.println(hash);
    }
}
```

### Option 3: Directement en SQL (nécessite une fonction)

⚠️ **Non recommandé** - BCrypt doit être utilisé côté application

## ⚠️ Points d'attention

1. **Exécuter le script SQL UNE SEULE FOIS**
   - Les hash changent à chaque exécution de `BCrypt.hashpw()`
   - Utilisez les hash pré-calculés du script

2. **Sauvegarder avant migration**
   ```sql
   CREATE TABLE utilisateurs_backup AS SELECT * FROM utilisateurs;
   ```

3. **Ne JAMAIS stocker les mots de passe en clair**
   - Tous les nouveaux utilisateurs ont automatiquement leurs mots de passe hashés

4. **Longueur du champ en base de données**
   ```sql
   -- Vérifier que le champ peut stocker 60 caractères
   ALTER TABLE utilisateurs MODIFY COLUMN motDePasse VARCHAR(60);
   ```

## 📝 Rollback (en cas de problème)

Si la migration échoue, vous pouvez restaurer:

```sql
-- Restaurer depuis la sauvegarde
DELETE FROM utilisateurs;
INSERT INTO utilisateurs SELECT * FROM utilisateurs_backup;

-- Supprimer la sauvegarde
DROP TABLE utilisateurs_backup;
```

## ✅ Checklist de migration

- [ ] Sauvegarder la table `utilisateurs`
- [ ] Recompiler le projet avec BCrypt (`mvn clean package`)
- [ ] Exécuter `migration_hash_passwords.sql`
- [ ] Vérifier les hash en base (60 caractères, commence par `$2a$12$`)
- [ ] Redémarrer Tomcat
- [ ] Tester la connexion admin (`admin@smartwater.com` / `admin123`)
- [ ] Tester la connexion citoyen (`jean.dupont@email.com` / `password123`)
- [ ] Tester la création d'un nouvel utilisateur
- [ ] Supprimer la sauvegarde si tout fonctionne

## 🎯 Résultat attendu

Après la migration:
- ✅ Tous les mots de passe sont hashés avec BCrypt
- ✅ La connexion fonctionne normalement
- ✅ Les nouveaux utilisateurs ont leurs mots de passe automatiquement hashés
- ✅ Les mots de passe ne sont jamais stockés en clair
- ✅ Les attaques par force brute sont considérablement ralenties

## 📞 Support

En cas de problème:
1. Vérifier les logs Tomcat (`catalina.out`)
2. Vérifier que BCrypt est bien dans les dépendances Maven
3. Vérifier que les hash font bien 60 caractères
4. Tester avec `PasswordHashGenerator` pour générer de nouveaux hash

---

**Date de création**: 2025-11-12  
**Version BCrypt**: 0.4  
**Cost factor**: 12 rounds
