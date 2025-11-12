package jobs;

import services.DataAggregationService;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Planificateur de tâches automatiques pour l'agrégation des données
 * Ce job s'exécute automatiquement chaque jour à minuit (ou à une heure configurée)
 */
public class DailyAggregationJob {

    private final DataAggregationService aggregationService;
    private final ScheduledExecutorService scheduler;
    private static DailyAggregationJob instance;

    // Heure d'exécution quotidienne (par défaut : 00:30 - 30 minutes après minuit)
    private final LocalTime heureExecution = LocalTime.of(0, 30);

    private DailyAggregationJob() {
        this.aggregationService = new DataAggregationService();
        this.scheduler = Executors.newScheduledThreadPool(1);
    }

    /**
     * Récupère l'instance unique du job (Singleton)
     */
    public static synchronized DailyAggregationJob getInstance() {
        if (instance == null) {
            instance = new DailyAggregationJob();
        }
        return instance;
    }

    /**
     * Démarre le planificateur de tâches
     */
    public void start() {
        System.out.println("🚀 Démarrage du planificateur d'agrégation quotidienne");
        System.out.println("⏰ Heure d'exécution configurée : " + heureExecution);

        // Calculer le délai initial jusqu'à la prochaine exécution
        long delaiInitial = calculerDelaiJusquaProchaineExecution();
        
        System.out.println("⏳ Prochaine exécution dans " + (delaiInitial / 60) + " minutes");

        // Planifier l'exécution quotidienne
        scheduler.scheduleAtFixedRate(
            this::executerAggregation,
            delaiInitial,                    // Délai initial (en secondes)
            TimeUnit.DAYS.toSeconds(1),      // Période : 1 jour
            TimeUnit.SECONDS                  // Unité de temps
        );

        System.out.println("✅ Planificateur démarré avec succès");
    }

    /**
     * Calcule le nombre de secondes jusqu'à la prochaine exécution planifiée
     */
    private long calculerDelaiJusquaProchaineExecution() {
        LocalDateTime maintenant = LocalDateTime.now();
        LocalDateTime prochaineExecution = maintenant.toLocalDate().atTime(heureExecution);

        // Si l'heure est déjà passée aujourd'hui, planifier pour demain
        if (maintenant.isAfter(prochaineExecution)) {
            prochaineExecution = prochaineExecution.plusDays(1);
        }

        // Calculer la différence en secondes
        long secondesJusquaExecution = java.time.Duration.between(maintenant, prochaineExecution).getSeconds();
        
        return secondesJusquaExecution;
    }

    /**
     * Exécute la tâche d'agrégation
     */
    private void executerAggregation() {
        System.out.println("\n═══════════════════════════════════════════════════════");
        System.out.println("🕐 DÉBUT DE L'AGRÉGATION AUTOMATIQUE - " + LocalDateTime.now());
        System.out.println("═══════════════════════════════════════════════════════\n");

        try {
            // Étape 1 : Agrégation automatique des données capteurs en historiques
            // (effectue un rattrapage des journées manquantes)
            int nbHistoriques = aggregationService.aggregerDonneesVeille();

            System.out.println("\n✅ Agrégation / rattrapage terminée avec succès : " + nbHistoriques + " historiques créés");
            
            // Étape 2 : Génération des statistiques à partir des historiques
            System.out.println("\n📈 Génération des statistiques journalières...");
            LocalDate hier = LocalDate.now().minusDays(1);
            int nbStatistiques = aggregationService.genererStatistiquesJournalieres(hier);
            System.out.println("✅ " + nbStatistiques + " statistiques générées pour la veille");
            
            // Afficher les statistiques globales
            var stats = aggregationService.getStatistiquesAggregation();
            System.out.println("\n📊 Statistiques globales :");
            System.out.println("   - Total historiques : " + stats.get("nbHistoriques"));
            System.out.println("   - Données non agrégées : " + stats.get("nbDonneesNonAggregees"));
            System.out.println("   - Dernière date agrégée : " + stats.get("derniereDate"));
            
        } catch (Exception e) {
            System.err.println("❌ ERREUR lors de l'agrégation automatique : " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("\n═══════════════════════════════════════════════════════");
        System.out.println("🏁 FIN DE L'AGRÉGATION AUTOMATIQUE - " + LocalDateTime.now());
        System.out.println("⏰ Prochaine exécution : demain à " + heureExecution);
        System.out.println("═══════════════════════════════════════════════════════\n");
    }

    /**
     * Exécute l'agrégation immédiatement (pour tests)
     */
    public void executerMaintenant() {
        System.out.println("🔧 Exécution manuelle de l'agrégation");
        executerAggregation();
    }

    /**
     * Arrête le planificateur
     */
    public void stop() {
        System.out.println("🛑 Arrêt du planificateur d'agrégation");
        scheduler.shutdown();
        try {
            if (!scheduler.awaitTermination(10, TimeUnit.SECONDS)) {
                scheduler.shutdownNow();
            }
            System.out.println("✅ Planificateur arrêté");
        } catch (InterruptedException e) {
            scheduler.shutdownNow();
            Thread.currentThread().interrupt();
        }
    }

    /**
     * Vérifie si le planificateur est actif
     */
    public boolean isRunning() {
        return !scheduler.isShutdown();
    }
}
