package filter;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import jobs.DailyAggregationJob;
import util.EnumDataMigrator;

/**
 * Listener qui s'exécute au démarrage de l'application
 * pour corriger les données enum invalides et démarrer les jobs automatiques
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

        // Démarrer le job d'agrégation automatique
        System.out.println("\n📅 Démarrage des tâches automatiques...");
        try {
            DailyAggregationJob.getInstance().start();
            System.out.println("✅ Tâches automatiques démarrées");
        } catch (Exception e) {
            System.err.println("❌ Erreur lors du démarrage des tâches automatiques : " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("👋 Application en arrêt");
        
        // Arrêter le job d'agrégation
        try {
            DailyAggregationJob.getInstance().stop();
            System.out.println("✅ Tâches automatiques arrêtées");
        } catch (Exception e) {
            System.err.println("❌ Erreur lors de l'arrêt des tâches automatiques : " + e.getMessage());
        }
    }
}

