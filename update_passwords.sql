-- =====================================================
-- Script de migration: Mise à jour des mots de passe
-- =====================================================
-- Ce script met à jour TOUS les utilisateurs avec des hash valides
-- générés par votre application Java/BCrypt
-- =====================================================

-- Étape 1: Vérifier les utilisateurs actuels
SELECT 
    idUtilisateur,
    nom,
    email,
    LEFT(motDePasse, 20) as hash_preview,
    CHAR_LENGTH(motDePasse) as hash_length,
    type,
    CASE 
        WHEN CHAR_LENGTH(motDePasse) = 60 AND motDePasse LIKE '$2a$12$%' THEN '✅ Hash BCrypt valide'
        ELSE '❌ Mot de passe en clair ou hash invalide'
    END as status
FROM utilisateurs
ORDER BY idUtilisateur;

-- =====================================================
-- Étape 2: Mettre à jour avec des hash VALIDES
-- =====================================================

-- Admin (admin123) - Hash VALIDE fourni
UPDATE utilisateurs 
SET motDePasse = '$2a$12$JRMrW5gjsxQtdOLPj1vHYOHiXkjbvSdFpZewJpWgYJXxj4i6F/tuK'
WHERE idUtilisateur = 1 AND email = 'admin@smartwater.com';

-- =====================================================
-- Pour les autres utilisateurs: MÉTHODE RECOMMANDÉE
-- =====================================================
-- 1. Connectez-vous comme admin avec le hash ci-dessus
-- 2. Allez sur la page de gestion des utilisateurs
-- 3. Modifiez chaque utilisateur et définissez un nouveau mot de passe
-- 4. L'application générera automatiquement un hash BCrypt valide
-- =====================================================

-- OU

-- =====================================================
-- MÉTHODE ALTERNATIVE: Créer un utilisateur temporaire
-- =====================================================
-- 1. Depuis votre application, créez un nouvel utilisateur avec:
--    - Email: temp_password123@test.com
--    - Mot de passe: password123
--
-- 2. Récupérez le hash généré:
SELECT idUtilisateur, email, motDePasse 
FROM utilisateurs 
WHERE email LIKE 'temp_%';

-- 3. Copiez le hash et utilisez-le pour mettre à jour les autres:
-- UPDATE utilisateurs 
-- SET motDePasse = 'HASH_COPIÉ_ICI'
-- WHERE email IN ('jean.dupont@email.com', 'marie.martin@email.com', 
--                  'pierre.bernard@email.com', 'sophie.moreau@email.com', 
--                  'luc.dubois@email.com');

-- 4. Supprimez l'utilisateur temporaire:
-- DELETE FROM utilisateurs WHERE email LIKE 'temp_%';

-- =====================================================
-- Étape 3: Vérification finale
-- =====================================================
SELECT 
    idUtilisateur,
    nom,
    email,
    CASE 
        WHEN CHAR_LENGTH(motDePasse) = 60 AND motDePasse LIKE '$2a$12$%' THEN '✅ Valide'
        ELSE '❌ Invalide'
    END as status,
    CHAR_LENGTH(motDePasse) as length
FROM utilisateurs
ORDER BY idUtilisateur;

-- =====================================================
-- RÉSUMÉ DES MOTS DE PASSE (après migration)
-- =====================================================
-- admin@smartwater.com     -> admin123 (✅ migré)
-- jean.dupont@email.com    -> password123 (⏳ à migrer)
-- marie.martin@email.com   -> password123 (⏳ à migrer)
-- pierre.bernard@email.com -> password123 (⏳ à migrer)
-- sophie.moreau@email.com  -> password123 (⏳ à migrer)
-- luc.dubois@email.com     -> password123 (⏳ à migrer)
-- test@gmail.com           -> test123 (⏳ à migrer)
-- =====================================================
