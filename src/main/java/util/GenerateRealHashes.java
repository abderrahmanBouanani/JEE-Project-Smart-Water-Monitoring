package util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Génère de vrais hash BCrypt pour la migration
 * À exécuter avec: mvn compile exec:java -Dexec.mainClass="util.GenerateRealHashes"
 */
public class GenerateRealHashes {
    
    public static void main(String[] args) {
        System.out.println("=".repeat(70));
        System.out.println("GÉNÉRATION DE HASH BCRYPT RÉELS");
        System.out.println("=".repeat(70));
        System.out.println();
        
        // Générer les hash
        String admin123Hash = BCrypt.hashpw("admin123", BCrypt.gensalt(12));
        String password123Hash = BCrypt.hashpw("password123", BCrypt.gensalt(12));
        String test123Hash = BCrypt.hashpw("test123", BCrypt.gensalt(12));
        
        System.out.println("-- Hash pour 'admin123':");
        System.out.println("UPDATE utilisateurs SET motDePasse = '" + admin123Hash + "'");
        System.out.println("WHERE idUtilisateur = 1 AND email = 'admin@smartwater.com';");
        System.out.println();
        
        System.out.println("-- Hash pour 'password123':");
        System.out.println("UPDATE utilisateurs SET motDePasse = '" + password123Hash + "'");
        System.out.println("WHERE idUtilisateur IN (2, 3, 4, 5, 6);");
        System.out.println();
        
        System.out.println("-- Hash pour 'test123':");
        System.out.println("UPDATE utilisateurs SET motDePasse = '" + test123Hash + "'");
        System.out.println("WHERE idUtilisateur = 7 AND email = 'test@gmail.com';");
        System.out.println();
        
        System.out.println("=".repeat(70));
        System.out.println("VÉRIFICATION DES HASH");
        System.out.println("=".repeat(70));
        
        // Vérifier que les hash fonctionnent
        boolean admin = BCrypt.checkpw("admin123", admin123Hash);
        boolean password = BCrypt.checkpw("password123", password123Hash);
        boolean test = BCrypt.checkpw("test123", test123Hash);
        
        System.out.println("✓ admin123 vérifié: " + admin);
        System.out.println("✓ password123 vérifié: " + password);
        System.out.println("✓ test123 vérifié: " + test);
        System.out.println();
        
        if (admin && password && test) {
            System.out.println("✅ TOUS LES HASH SONT VALIDES!");
            System.out.println();
            System.out.println("COPIEZ LES COMMANDES UPDATE CI-DESSUS ET EXÉCUTEZ-LES DANS MySQL");
        } else {
            System.out.println("❌ ERREUR: Un ou plusieurs hash sont invalides");
        }
        
        System.out.println("=".repeat(70));
    }
}
