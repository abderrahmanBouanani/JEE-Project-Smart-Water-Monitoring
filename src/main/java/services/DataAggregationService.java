package services;

import dao.DonneeCapteurDao;
import dao.HistoriqueConsommationDao;
import dao.StatistiqueDao;
import dao.UtilisateurDao;
import model.DonneeCapteur;
import model.HistoriqueConsommation;
import model.Statistique;
import model.Utilisateur;
import org.hibernate.Session;
import org.hibernate.Transaction;
import util.HibernateUtil;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Service pour agréger les données des capteurs en historiques de consommation
 * Ce service est appelé automatiquement chaque jour pour créer les synthèses quotidiennes
 */
public class DataAggregationService {

    private final DonneeCapteurDao donneeCapteurDao;
    private final HistoriqueConsommationDao historiqueDao;
    private final UtilisateurDao utilisateurDao;
    private final StatistiqueDao statistiqueDao;

    // Prix de l'eau par litre (à ajuster selon les tarifs réels)
    private static final double PRIX_EAU_PAR_LITRE = 0.00722; // environ 7.22€/m³

    public DataAggregationService() {
        this.donneeCapteurDao = new DonneeCapteurDao();
        this.historiqueDao = new HistoriqueConsommationDao();
        this.utilisateurDao = new UtilisateurDao();
        this.statistiqueDao = new StatistiqueDao();
    }

    /**
     * Agrège les données d'une journée spécifique pour tous les utilisateurs
     * @param date La date pour laquelle agréger les données
     * @return Le nombre d'historiques créés
     */
    public int aggregerDonneesJournee(LocalDate date) {
        System.out.println("🔄 Début de l'agrégation pour le " + date);
        
        int nbHistoriquesCreés = 0;
        
        try {
            // Récupérer tous les utilisateurs
            List<Utilisateur> utilisateurs = utilisateurDao.findAll();
            
            if (utilisateurs == null || utilisateurs.isEmpty()) {
                System.out.println("⚠️ Aucun utilisateur trouvé");
                return 0;
            }
            
            System.out.println("👥 " + utilisateurs.size() + " utilisateurs trouvés");
            
            // Pour chaque utilisateur, agréger ses données
            for (Utilisateur utilisateur : utilisateurs) {
                try {
                    boolean success = aggregerDonneesUtilisateur(utilisateur, date);
                    if (success) {
                        nbHistoriquesCreés++;
                    }
                } catch (Exception e) {
                    System.err.println("❌ Erreur pour l'utilisateur " + utilisateur.getNom() + ": " + e.getMessage());
                    e.printStackTrace();
                }
            }
            
            System.out.println("✅ Agrégation terminée : " + nbHistoriquesCreés + " historiques créés");
            
        } catch (Exception e) {
            System.err.println("❌ Erreur lors de l'agrégation : " + e.getMessage());
            e.printStackTrace();
        }
        
        return nbHistoriquesCreés;
    }

    /**
     * Agrège les données d'une journée pour un utilisateur spécifique
     * @param utilisateur L'utilisateur
     * @param date La date
     * @return true si l'historique a été créé avec succès
     */
    private boolean aggregerDonneesUtilisateur(Utilisateur utilisateur, LocalDate date) {
        System.out.println("📊 Agrégation pour " + utilisateur.getNom() + " - " + date);
        
        Session session = null;
        Transaction transaction = null;
        
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            // Vérifier si un historique existe déjà pour cette date et cet utilisateur
            String checkQuery = "FROM HistoriqueConsommation h WHERE h.utilisateur.idUtilisateur = :userId AND h.date = :date";
            HistoriqueConsommation existant = session.createQuery(checkQuery, HistoriqueConsommation.class)
                    .setParameter("userId", utilisateur.getIdUtilisateur())
                    .setParameter("date", date)
                    .uniqueResultOptional()
                    .orElse(null);
            
            if (existant != null) {
                System.out.println("ℹ️ Historique déjà existant pour " + utilisateur.getNom() + " - " + date);
                transaction.rollback();
                return false;
            }
            
            // Définir les limites temporelles de la journée
            LocalDateTime debutJournee = date.atStartOfDay(); // 00:00:00
            LocalDateTime finJournee = date.plusDays(1).atStartOfDay(); // 00:00:00 du lendemain
            
            // Récupérer toutes les données des capteurs de cet utilisateur pour cette journée
            String query = "SELECT dc FROM DonneeCapteur dc " +
                          "JOIN dc.capteur c " +
                          "WHERE c.utilisateur.idUtilisateur = :userId " +
                          "AND dc.horodatage >= :debut " +
                          "AND dc.horodatage < :fin";
            
            List<DonneeCapteur> donnees = session.createQuery(query, DonneeCapteur.class)
                    .setParameter("userId", utilisateur.getIdUtilisateur())
                    .setParameter("debut", debutJournee)
                    .setParameter("fin", finJournee)
                    .list();
            
            if (donnees.isEmpty()) {
                System.out.println("ℹ️ Aucune donnée pour " + utilisateur.getNom() + " - " + date);
                transaction.rollback();
                return false;
            }
            
            System.out.println("📦 " + donnees.size() + " mesures trouvées");
            
            // Calculer les agrégats
            double volumeTotal = donnees.stream()
                    .mapToDouble(DonneeCapteur::getValeurConsommation)
                    .sum();
            
            double consommationMoyenne = volumeTotal / 24.0; // Moyenne par heure
            
            double coutEstime = volumeTotal * PRIX_EAU_PAR_LITRE;
            
            // Créer l'historique
            HistoriqueConsommation historique = new HistoriqueConsommation();
            historique.setDate(date);
            historique.setVolumeTotal(volumeTotal);
            historique.setConsommationMoyenne(consommationMoyenne);
            historique.setCoutEstime(coutEstime);
            historique.setUtilisateur(utilisateur);
            
            session.persist(historique);
            transaction.commit();
            
            System.out.println("✅ Historique créé : " + volumeTotal + "L, " + coutEstime + "€");
            
            return true;
            
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            System.err.println("❌ Erreur lors de l'agrégation pour " + utilisateur.getNom() + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    /**
     * Agrège les données de la veille (à appeler automatiquement chaque jour)
     * @return Le nombre d'historiques créés
     */
    public int aggregerDonneesVeille() {
        LocalDate hier = LocalDate.now().minusDays(1);
        System.out.println("🌙 Agrégation automatique des données de la veille : " + hier);
        // Par défaut, on agrège la veille — mais on profite également pour rattraper
        // toute donnée non agrégée plus ancienne (backfill) afin d'éviter des jours
        // non traités qui s'accumulent.
        return aggregerDonneesManquantes();
    }

    /**
     * Agrège automatiquement toutes les journées manquantes jusqu'à la veille.
     * Si des données non agrégées existent depuis plusieurs jours, on effectue
     * un rattrapage de la plus ancienne date trouvée jusqu'à hier.
     * @return nombre total d'historiques créés
     */
    public int aggregerDonneesManquantes() {
        LocalDate hier = LocalDate.now().minusDays(1);
        System.out.println("🌙 Démarrage du rattrapage automatique jusqu'à : " + hier);

        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();

            // Définir la limite : on ne traite que les données antérieures au jour courant
            LocalDateTime limite = hier.plusDays(1).atStartOfDay();

            // Trouver la plus ancienne mesure disponible avant la limite
            LocalDateTime minHorodatage = session.createQuery(
                    "SELECT MIN(dc.horodatage) FROM DonneeCapteur dc WHERE dc.horodatage < :limite", LocalDateTime.class)
                    .setParameter("limite", limite)
                    .uniqueResult();

            if (minHorodatage == null) {
                System.out.println("ℹ️ Aucune donnée antérieure à " + limite + " à agréger");
                return 0;
            }

            LocalDate dateDebut = minHorodatage.toLocalDate();

            if (dateDebut.isAfter(hier)) {
                System.out.println("ℹ️ Les seules données disponibles sont récentes (aucun backfill nécessaire)");
                return 0;
            }

            System.out.println("🔁 Rattrapage : agrégation de " + dateDebut + " à " + hier);
            int total = aggregerPeriode(dateDebut, hier);
            System.out.println("✅ Rattrapage terminé : " + total + " historiques créés");
            return total;

        } catch (Exception e) {
            System.err.println("❌ Erreur lors du rattrapage automatique : " + e.getMessage());
            e.printStackTrace();
            return 0;
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    /**
     * Agrège les données pour une période (plusieurs jours)
     * Utile pour rattraper des jours manquants
     * @param dateDebut Date de début (incluse)
     * @param dateFin Date de fin (incluse)
     * @return Le nombre total d'historiques créés
     */
    public int aggregerPeriode(LocalDate dateDebut, LocalDate dateFin) {
        System.out.println("📅 Agrégation de la période du " + dateDebut + " au " + dateFin);
        
        int totalHistoriques = 0;
        LocalDate currentDate = dateDebut;
        
        while (!currentDate.isAfter(dateFin)) {
            System.out.println("\n--- Traitement du " + currentDate + " ---");
            int nbJour = aggregerDonneesJournee(currentDate);
            totalHistoriques += nbJour;
            currentDate = currentDate.plusDays(1);
        }
        
        System.out.println("\n✅ Agrégation de période terminée : " + totalHistoriques + " historiques créés au total");
        return totalHistoriques;
    }

    /**
     * Récupère les statistiques d'agrégation
     * @return Map contenant diverses statistiques
     */
    public Map<String, Object> getStatistiquesAggregation() {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            
            // Nombre total d'historiques
            Long nbHistoriques = session.createQuery("SELECT COUNT(h) FROM HistoriqueConsommation h", Long.class)
                    .uniqueResult();
            
            // Nombre de données capteur non agrégées (plus anciennes que 2 jours)
            LocalDateTime limite = LocalDate.now().minusDays(2).atStartOfDay();
            Long nbDonneesNonAggregees = session.createQuery(
                    "SELECT COUNT(dc) FROM DonneeCapteur dc WHERE dc.horodatage < :limite", Long.class)
                    .setParameter("limite", limite)
                    .uniqueResult();
            
            // Dernière date agrégée
            LocalDate derniereDate = session.createQuery(
                    "SELECT MAX(h.date) FROM HistoriqueConsommation h", LocalDate.class)
                    .uniqueResult();
            
            // Nombre total de statistiques générées
            Long nbStatistiques = session.createQuery("SELECT COUNT(s) FROM Statistique s", Long.class)
                    .uniqueResult();
            
            // Dernière période de statistiques générée
            String dernierePeriodeStats = session.createQuery(
                    "SELECT MAX(s.periode) FROM Statistique s", String.class)
                    .uniqueResult();
            
            return Map.of(
                "nbHistoriques", nbHistoriques != null ? nbHistoriques : 0L,
                "nbDonneesNonAggregees", nbDonneesNonAggregees != null ? nbDonneesNonAggregees : 0L,
                "derniereDate", derniereDate != null ? derniereDate.toString() : "Aucune",
                "nbStatistiques", nbStatistiques != null ? nbStatistiques : 0L,
                "dernierePeriodeStats", dernierePeriodeStats != null ? dernierePeriodeStats : "Aucune"
            );
            
        } catch (Exception e) {
            System.err.println("❌ Erreur lors de la récupération des statistiques : " + e.getMessage());
            return Map.of(
                "nbHistoriques", 0L,
                "nbDonneesNonAggregees", 0L,
                "derniereDate", "Erreur",
                "nbStatistiques", 0L,
                "dernierePeriodeStats", "Erreur"
            );
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    /**
     * Génère des statistiques journalières à partir des historiques de consommation
     * pour une date donnée.
     * Types de statistiques générées :
     * - CONSOMMATION_MOYENNE : Consommation moyenne sur les 7 derniers jours
     * - CONSOMMATION_TOTALE : Total de la journée
     * - PIC_CONSOMMATION : Consommation maximale de la journée
     * - TENDANCE : Variation par rapport à la moyenne des 7 derniers jours (en %)
     * 
     * @param date La date pour laquelle générer les statistiques
     * @return Le nombre de statistiques créées
     */
    public int genererStatistiquesJournalieres(LocalDate date) {
        System.out.println("📈 Génération des statistiques pour le " + date);
        
        int nbStatistiquesCreees = 0;
        Session session = null;
        Transaction transaction = null;
        
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            // Récupérer tous les utilisateurs
            List<Utilisateur> utilisateurs = utilisateurDao.findAll();
            
            if (utilisateurs == null || utilisateurs.isEmpty()) {
                System.out.println("⚠️ Aucun utilisateur trouvé pour les statistiques");
                return 0;
            }
            
            String periode = date.toString(); // Format YYYY-MM-DD
            
            for (Utilisateur utilisateur : utilisateurs) {
                try {
                    // Vérifier si des statistiques existent déjà pour cette date et cet utilisateur
                    Long existantes = session.createQuery(
                            "SELECT COUNT(s) FROM Statistique s WHERE s.utilisateur.idUtilisateur = :userId AND s.periode = :periode", 
                            Long.class)
                            .setParameter("userId", utilisateur.getIdUtilisateur())
                            .setParameter("periode", periode)
                            .uniqueResult();
                    
                    if (existantes != null && existantes > 0) {
                        System.out.println("ℹ️ Statistiques déjà existantes pour " + utilisateur.getNom() + " - " + date);
                        continue;
                    }
                    
                    // Récupérer l'historique du jour
                    HistoriqueConsommation historiqueDuJour = session.createQuery(
                            "FROM HistoriqueConsommation h WHERE h.utilisateur.idUtilisateur = :userId AND h.date = :date", 
                            HistoriqueConsommation.class)
                            .setParameter("userId", utilisateur.getIdUtilisateur())
                            .setParameter("date", date)
                            .uniqueResultOptional()
                            .orElse(null);
                    
                    if (historiqueDuJour == null) {
                        System.out.println("ℹ️ Aucun historique trouvé pour " + utilisateur.getNom() + " - " + date);
                        continue;
                    }
                    
                    // Récupérer les historiques des 7 derniers jours (pour calculer la moyenne)
                    LocalDate dateDebut7Jours = date.minusDays(7);
                    List<HistoriqueConsommation> historiques7Jours = session.createQuery(
                            "FROM HistoriqueConsommation h WHERE h.utilisateur.idUtilisateur = :userId " +
                            "AND h.date >= :dateDebut AND h.date <= :dateFin ORDER BY h.date DESC", 
                            HistoriqueConsommation.class)
                            .setParameter("userId", utilisateur.getIdUtilisateur())
                            .setParameter("dateDebut", dateDebut7Jours)
                            .setParameter("dateFin", date)
                            .list();
                    
                    if (historiques7Jours.isEmpty()) {
                        System.out.println("ℹ️ Pas assez d'historique pour calculer les statistiques de " + utilisateur.getNom());
                        continue;
                    }
                    
                    // Calculer les statistiques
                    double consommationDuJour = historiqueDuJour.getVolumeTotal();
                    
                    // Consommation moyenne sur 7 jours
                    double moyenneSur7Jours = historiques7Jours.stream()
                            .mapToDouble(HistoriqueConsommation::getVolumeTotal)
                            .average()
                            .orElse(0.0);
                    
                    // Pic de consommation (max sur 7 jours)
                    double picConsommation = historiques7Jours.stream()
                            .mapToDouble(HistoriqueConsommation::getVolumeTotal)
                            .max()
                            .orElse(0.0);
                    
                    // Tendance : variation par rapport à la moyenne (en %)
                    double tendance = 0.0;
                    if (moyenneSur7Jours > 0) {
                        tendance = ((consommationDuJour - moyenneSur7Jours) / moyenneSur7Jours) * 100;
                    }
                    
                    // Créer les statistiques
                    
                    // 1. Consommation totale du jour
                    Statistique statTotal = new Statistique("CONSOMMATION_TOTALE", consommationDuJour, periode, utilisateur);
                    session.persist(statTotal);
                    nbStatistiquesCreees++;
                    
                    // 2. Consommation moyenne sur 7 jours
                    Statistique statMoyenne = new Statistique("CONSOMMATION_MOYENNE", moyenneSur7Jours, periode, utilisateur);
                    session.persist(statMoyenne);
                    nbStatistiquesCreees++;
                    
                    // 3. Pic de consommation
                    Statistique statPic = new Statistique("PIC_CONSOMMATION", picConsommation, periode, utilisateur);
                    session.persist(statPic);
                    nbStatistiquesCreees++;
                    
                    // 4. Tendance (variation en %)
                    Statistique statTendance = new Statistique("TENDANCE", tendance, periode, utilisateur);
                    session.persist(statTendance);
                    nbStatistiquesCreees++;
                    
                    System.out.println("✅ Statistiques créées pour " + utilisateur.getNom() + 
                            " : Total=" + String.format("%.2f", consommationDuJour) + "L, " +
                            "Moyenne=" + String.format("%.2f", moyenneSur7Jours) + "L, " +
                            "Tendance=" + String.format("%.1f", tendance) + "%");
                    
                } catch (Exception e) {
                    System.err.println("❌ Erreur lors de la génération des statistiques pour " + utilisateur.getNom() + ": " + e.getMessage());
                    e.printStackTrace();
                }
            }
            
            transaction.commit();
            System.out.println("✅ Génération des statistiques terminée : " + nbStatistiquesCreees + " statistiques créées");
            
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            System.err.println("❌ Erreur lors de la génération des statistiques : " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
        
        return nbStatistiquesCreees;
    }

    /**
     * Génère les statistiques pour une période (plusieurs jours)
     * @param dateDebut Date de début (incluse)
     * @param dateFin Date de fin (incluse)
     * @return Le nombre total de statistiques créées
     */
    public int genererStatistiquesPeriode(LocalDate dateDebut, LocalDate dateFin) {
        System.out.println("📊 Génération des statistiques de la période du " + dateDebut + " au " + dateFin);
        
        int totalStatistiques = 0;
        LocalDate currentDate = dateDebut;
        
        while (!currentDate.isAfter(dateFin)) {
            int nbJour = genererStatistiquesJournalieres(currentDate);
            totalStatistiques += nbJour;
            currentDate = currentDate.plusDays(1);
        }
        
        System.out.println("\n✅ Génération des statistiques de période terminée : " + totalStatistiques + " statistiques créées au total");
        return totalStatistiques;
    }
}
