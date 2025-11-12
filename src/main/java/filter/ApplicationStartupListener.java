package filter;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import util.EnumDataMigrator;

/**
 * Listener qui s'exécute au démarrage de l'application
 * pour corriger les données enum invalides
 */
@WebListener
public class ApplicationStartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("🚀 Application en démarrage - Vérification de l'intégrité des données...");

        // Corriger les données enum invalides
        EnumDataMigrator.fixInvalidCapteurTypes();

        // Afficher les statistiques
        EnumDataMigrator.printCapteurTypeStatistics();

        System.out.println("✅ Vérification d'intégrité des données terminée");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("👋 Application en arrêt");
    }
}

