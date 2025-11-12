package util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utilitaire pour générer des hash BCrypt
 * Utilisé pour créer les hash de migration SQL
 */
public class PasswordHashGenerator {
    
    public static void main(String[] args) {
        // Générer les hash pour les mots de passe existants
        String[] passwords = {
            "admin123",      // Admin
            "password123"    // Tous les citoyens
        };
        
        System.out.println("=".repeat(60));
        System.out.println("GÉNÉRATION DES HASH BCRYPT (rounds=12)");
        System.out.println("=".repeat(60));
        System.out.println();
        
        for (String password : passwords) {
            String hash = BCrypt.hashpw(password, BCrypt.gensalt(12));
            System.out.println("Mot de passe: " + password);
            System.out.println("Hash BCrypt:  " + hash);
            System.out.println("-".repeat(60));
        }
        
        System.out.println();
        System.out.println("VÉRIFICATION DES HASH");
        System.out.println("=".repeat(60));
        
        // Vérification
        String admin123Hash = BCrypt.hashpw("admin123", BCrypt.gensalt(12));
        System.out.println("admin123 vérifié: " + BCrypt.checkpw("admin123", admin123Hash));
        
        String password123Hash = BCrypt.hashpw("password123", BCrypt.gensalt(12));
        System.out.println("password123 vérifié: " + BCrypt.checkpw("password123", password123Hash));
        
        System.out.println();
        System.out.println("✅ Hash générés avec succès!");
        System.out.println();
        System.out.println("UTILISATION:");
        System.out.println("1. Copiez les hash générés ci-dessus");
        System.out.println("2. Utilisez-les dans le script SQL migration_hash_passwords.sql");
        System.out.println("3. Exécutez le script SQL UNE SEULE FOIS");
        System.out.println("=".repeat(60));
    }
}
