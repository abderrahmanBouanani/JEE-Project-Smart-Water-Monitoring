-- Script SQL pour corriger les types d'alertes invalides dans la base de données
-- Exécuter ce script dans MySQL pour nettoyer les données

-- 1. Vérifier les alertes avec des types vides ou NULL
SELECT idAlerte, type, message, dateCreation 
FROM alertes 
WHERE type IS NULL OR type = '' OR type NOT IN ('SEUIL_DEPASSE', 'FUITE_DETECTEE', 'CAPTEUR_OFFLINE');

-- 2. Option A : Mettre SEUIL_DEPASSE pour les types vides/invalides (recommandé)
UPDATE alertes 
SET type = 'SEUIL_DEPASSE' 
WHERE type IS NULL OR type = '' OR type NOT IN ('SEUIL_DEPASSE', 'FUITE_DETECTEE', 'CAPTEUR_OFFLINE');

-- 3. Option B : Supprimer les alertes avec des types invalides (si elles sont de test)
-- DELETE FROM alertes 
-- WHERE type IS NULL OR type = '' OR type NOT IN ('SEUIL_DEPASSE', 'FUITE_DETECTEE', 'CAPTEUR_OFFLINE');

-- 4. Vérifier le résultat après correction
SELECT type, COUNT(*) as nombre 
FROM alertes 
GROUP BY type;
